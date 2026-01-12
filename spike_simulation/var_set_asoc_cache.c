#include <stdint.h>
#include "mmio_reg/spm_reg.h"
#include "mmio_reg/mac_reg.h"
#include "mmio_reg/aes_reg.h"
#include "mmio_reg/axim_reg.h"
#include "mmio_reg/memreq_reg.h"
#include "mmio_reg/xor_reg.h"
#include "mmio_reg/reg_map.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "util.h"
#include "config.h"
#include "cache_controll.h"
#include "addr_util.h"
#include "sec_operation.h"
#define REENCRYPTION_SPM_OFFSET DATA_SPM_OFFSET + 64

bool instret_dump = false;


// マイナーカウンターがオーバーフローした時の復号化+再暗号化処理
static inline void reencryption(dram_addr_t counter_block_addr,spm_offset_t counter_spm_offset){
  // printf("[Core FW] Re-encrypting data block for counter_block_addr=%016llx dma_id=%llu global_mac_req_id=%llu\n", counter_block_addr, global_dma_id, global_mac_req_id);
  dram_addr_t data_block_addr = PROTECTION_BASE + (counter_block_addr - level_base[HEIGHT]) / 64 * (MINOR_COUNTER_COUNT * 64);
  uint64_t old_major_counter = spm_ld64(counter_spm_offset);
  uint64_t new_major_counter = old_major_counter + 1;
  dma_id_t dma_id;
  for (long i = 0;i < MINOR_COUNTER_COUNT;i++){
    // 必要なデータを読み出す。
    // global_dma_id += 1;
    dma_id = global_dma_id;
    dram_addr_t dram_addr = data_block_addr + i * 64;
    spm_copy_to_local(dram_addr, REENCRYPTION_SPM_OFFSET, dma_id);
    // MACブロックの取得
    dram_addr_t datamacblock_addr = get_datamacblock_addr(dram_addr);
    index_t set_index = get_cache_mac_index(datamacblock_addr);
    spm_offset_t spm_offset;
    light_tag_info_t light_info = light_tag_check(datamacblock_addr);
    if (light_info.hit){
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      update_lru_on_access(set_index, light_info.way);
    } else {
      global_dma_id += 1;
      dma_id = global_dma_id;
      if (light_info.way == -1){
        light_info.way = get_victim_way(set_index);
        spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
        bool dirty = is_block_dirty(set_index, light_info.way);
        if (dirty){
          dram_addr_t old_block_addr = get_block_addr(set_index, light_info.way);
          spm_write_back(spm_offset, old_block_addr,  0);
        }
      } else {
        set_block_valid(set_index, light_info.way);
        spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      }
      spm_copy_to_local(datamacblock_addr, spm_offset, dma_id);
      set_block_addr(set_index, light_info.way, datamacblock_addr);
      clear_block_dirty(set_index, light_info.way);
    }
    // マイナーカウンターの取得
    uint64_t global_bit_offset = 64 + (i * MINOR_COUNTER_WIDTH);
    // dmacの比較
    mac_init(global_mac_req_id,0,1);
    mac_buffer_set(REENCRYPTION_SPM_OFFSET, dma_id,0);
    mac_update(0,511,0);
    mac_buffer_set(counter_spm_offset, dma_id,0);
    mac_update(0,63,0);
    mac_update(global_bit_offset, global_bit_offset + MINOR_COUNTER_WIDTH - 1,0);
    mac_input_core(dram_addr,0);
    spm_offset_t dmac_byte_offset = ((dram_addr - PROTECTION_BASE) / 64) % 8 * 8;
    mac_digest(spm_offset + dmac_byte_offset,dma_id,0);
    mac_wait(global_mac_req_id,0);
    global_mac_req_id += 1;
    // 3. 読み出すべきアドレス（8Bアライン）と、その中でのビットオフセットを計算
    uint64_t word_offset_bytes = (global_bit_offset / 64) * 8; // 8バイト単位のオフセット
    uint64_t local_bit_offset  = global_bit_offset % 64;       // 64bitワード内での開始ビット
    // 4. 最初の64bitをロードしてシフト
    uint64_t raw_data = spm_ld64(counter_spm_offset + word_offset_bytes);
    uint64_t extracted_val = raw_data >> local_bit_offset;
    // 5. カウンターが64bit境界をまたぐか判定し、必要なら2回目のロードを行う
    // (開始位置 + データ幅 が 64 を超える場合、次のワードにデータがはみ出している)
    if (local_bit_offset + MINOR_COUNTER_WIDTH > 64) {
        uint64_t next_data = spm_ld64(counter_spm_offset + word_offset_bytes + 8);
        // はみ出した分（上位ビット）を結合
        // (64 - local_bit_offset) は、1つ目のワードに残っていたビット数
        extracted_val |= (next_data << (64 - local_bit_offset));
    }
    // 6. ビットマスクを生成して不要な上位ビットを切り落とす;
    uint16_t minor_counter_value = extracted_val & MINOR_COUNTER_MASK;
    // 結果の使用
    set_seed(old_major_counter, minor_counter_value, dram_addr);
    while(AES_START_REG);
    // 復号化
    spm_wait(dma_id);
    xor_start(false,false,0,REENCRYPTION_SPM_OFFSET);
    // 再暗号化
    set_seed(new_major_counter, 0, dram_addr);
    while(AES_START_REG);
    xor_start(false,false,0,REENCRYPTION_SPM_OFFSET);
    // 書き戻し
    spm_write_back(REENCRYPTION_SPM_OFFSET, dram_addr,  0);
    // minorカウンターの更新
    // MACの更新
    // uint64_t mac_req_id = global_mac_req_id;
    mac_init(global_mac_req_id,0,1);
    mac_buffer_set(REENCRYPTION_SPM_OFFSET, 0,0);
    mac_update(0,511,0);
    mac_buffer_set(counter_spm_offset, dma_id,0);
    mac_update(0,63,0);
    mac_update(global_bit_offset, global_bit_offset + MINOR_COUNTER_WIDTH - 1,0);
    mac_input_core(dram_addr,0);
    mac_digest(spm_offset + dmac_byte_offset,dma_id,0);
    mac_wait(global_mac_req_id,0);
    global_mac_req_id += 1;
  }
  // majorカウンターをインクリメント
  spm_sd64(counter_spm_offset, new_major_counter);
  // // minorカウンターエリアを0クリア
  // for (long i = 0;i < 384 / 8;i++){
  //   spm_sd64(counter_spm_offset + 8 + i * 8, 0);
  // }
  // printf("[Core FW] Re-encrypted data block for counter_block_addr=%016llx\n", counter_block_addr);
  // return dma_id;
}


// 中間ノードのマイナーカウンターがオーバーフローした時の再計算処理
static inline void recalc_tag(dram_addr_t node_dram_addr, spm_offset_t node_spm_offset, int height, long index){
  // printf("[Core FW] Recalculating tag at level %d for node_addr=%016llx dma_id=%llu global_mac_req_id=%llu index=%llu\n", height, node_dram_addr, global_dma_id,global_mac_req_id,index);
  long block_idx = index / MINOR_COUNTER_COUNT;
  dram_addr_t child_base_addr = level_base[height + 2] + block_idx * MINOR_COUNTER_COUNT * 64;
  uint64_t old_major_counter = spm_ld64(node_spm_offset);
  uint64_t new_major_counter = old_major_counter + 1;
  for (long i = 0;i < MINOR_COUNTER_COUNT;i++){
    // 子ノードの検証
    // 子ノードのアドレス計算
    long child_index = (block_idx * MINOR_COUNTER_COUNT + i) * MINOR_COUNTER_COUNT;
    dram_addr_t child_dram_addr = child_base_addr + i * 64;
    light_tag_info_t light_info = light_tag_check(child_dram_addr);
    spm_offset_t child_spm_offset;
    long temp_idx = -1;
    dma_id_t dma_id = global_dma_id;
    if (light_info.hit){
      // printf("[core fw] cache hit for addr=%016llx\n", child_dram_addr);
      index_t set_index = get_cache_tree_set_index(child_dram_addr);
      bool mac_updated = is_mac_updated(set_index, light_info.way);
      if (!mac_updated){
        continue; // MACが更新されていない場合はあとでやればいいのでスキップ
      } else {
        child_spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
        set_block_dirty(set_index, light_info.way);
        setParentUpdated(set_index, light_info.way);
      }
    } else {
      // tempバッファを検索
      temp_idx = find_temp_entry(child_dram_addr);
      if (temp_idx >= 0){
        // printf("[core fw] temp hit for addr=%016llx\n", child_dram_addr);
        child_spm_offset = get_temp_spm_offset(temp_idx);
      } else {
        // printf("[core fw] miss for addr=%016llx\n", child_dram_addr);
        child_spm_offset = REENCRYPTION_SPM_OFFSET; // 一時バッファを使用
        global_dma_id += 1;
        dma_id = global_dma_id;
        spm_copy_to_local(child_dram_addr, child_spm_offset, dma_id);
      }
    }
    // printf("[core fw] re height = %d, child_index=%llu, child_addr=%016llx, child_spm_offset=%016llx\n", height + 1, child_index, child_dram_addr, child_spm_offset); 
    spm_wait(dma_id);
    spm_sd64(node_spm_offset, old_major_counter);
    verify_one_height(child_spm_offset, node_spm_offset, child_index, global_mac_req_id, dma_id, child_dram_addr);
    // while(!mac_wait(global_mac_req_id,0));
    mac_wait(global_mac_req_id,0);
    global_mac_req_id += 1;
    // minor_counterをリセット
    uint64_t word1 = 0;
    uint64_t word2 = 0;
    uint64_t global_bit_offset = 64 + (i * MINOR_COUNTER_WIDTH);
    uint64_t local_bit_offset = (i * MINOR_COUNTER_WIDTH) % 64;
    uint64_t word_offset_bytes = (global_bit_offset / 64) * 8;
    bool is_split = (local_bit_offset + MINOR_COUNTER_WIDTH > 64);
    // またいでいる場合は次のワードも読む
    word1 = spm_ld64(node_spm_offset + word_offset_bytes);
    if (is_split) {
        word2 = spm_ld64(node_spm_offset + word_offset_bytes + 8);
    }
    // 3. 現在のマイナーカウンター値の抽出
    uint64_t current_minor_val = 0;
    // 4. 値の更新（インクリメントとオーバーフロー判定）
    uint64_t new_minor_val;
    // 5. 書き戻し用データの作成と保存
    // 書き戻しデータのビット幅（Word1に含まれる分）
    uint64_t bits_in_first = is_split ? (64 - local_bit_offset) : MINOR_COUNTER_WIDTH;
    uint64_t mask_first = MINOR_COUNTER_MASK;
    // A. 更新対象の場所を0クリア (Clear)
    word1 &= ~(mask_first << local_bit_offset);
    // B. 新しい値の下位パートをセット (Set)
    word1 |= ((new_minor_val & mask_first) << local_bit_offset);
    // C. 書き込み
    spm_sd64(node_spm_offset + word_offset_bytes, word1);
    // --- Word 2 の更新（またいでいる場合のみ） ---
    if (is_split) {
        uint64_t bits_in_second = MINOR_COUNTER_WIDTH - bits_in_first;
        uint64_t mask_second = (1ULL << bits_in_second) - 1;
        // A. 更新対象の場所(先頭)を0クリア
        word2 &= ~mask_second;
        // B. 新しい値の上位パートをシフトしてセット
        word2 |= (new_minor_val >> bits_in_first) & mask_second;
        // C. 書き込み
        spm_sd64(node_spm_offset + word_offset_bytes + 8, word2);
    }
    spm_sd64(node_spm_offset, new_major_counter);
    update_one_height(child_spm_offset, node_spm_offset, child_index, false, global_mac_req_id, dma_id, child_dram_addr);
    // while(!mac_wait(global_mac_req_id,0));
    mac_wait(global_mac_req_id,0);
    global_mac_req_id += 1;
    if (!light_info.hit){
      if (temp_idx >= 0){
        dirty_temp_entry_by_index(temp_idx);
      } else {
        spm_write_back(child_spm_offset, child_dram_addr, 0);
      }
    }
  }
  // printf("[Core FW] Recalculated tag at level %d for node_addr=%016llx\n", height, node_dram_addr);
  // exit(1);
}

void Authentication(dram_addr_t request_addr, uint32_t req_id){
  // データのコピー
  uint64_t start_time = read_instret();
  // HEIGHT-1がリーフ、0が高さ1
  uint64_t path_indecis[HEIGHT];
  spm_offset_t spm_offset_array[HEIGHT];
  dram_addr_t dram_addr_array[HEIGHT];
  uint64_t load_start_index = 0;
  dma_id_t wait_dma_id[HEIGHT];
  index_t way_index = 0;
  // パス上のノードのタグチェックを行う
  uint64_t verify_start = read_instret();
  // dma_id_t tmp_id = id;
  for(uint64_t i=0; i<HEIGHT; ++i){
      uint64_t index = (request_addr - PROTECTION_BASE) / (64 * (1ULL << (ARTY_LOG2 * i)));
      path_indecis[HEIGHT - 1 - i ] = index;
      dram_addr_t dram_addr = COUNTER_BASE + index / MINOR_COUNTER_COUNT * 64 + calculate_level_base_addr(HEIGHT - i);
      dram_addr_array[HEIGHT - 1 - i] = dram_addr;
      long set_index = get_cache_tree_set_index(dram_addr);
      light_tag_info_t info = light_tag_check(dram_addr);
      if (info.hit){
        load_start_index = HEIGHT - i;
        spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, info.way);
        update_lru_on_access(set_index, info.way);
        spm_offset_array[HEIGHT - 1 - i] = spm_offset;
        way_index = info.way;
        wait_dma_id[HEIGHT - 1 - i] = global_dma_id;
        acquire_write_block(spm_offset);
        if (i == 0){
          set_block_dirty(set_index, way_index);
          clearParentUpdated(set_index, way_index);
        }
        break;
      } else {
        global_dma_id += 1;
        wait_dma_id[HEIGHT - 1 - i] = global_dma_id;
        spm_offset_t spm_offset = pop_temp_buffer();
        spm_offset_array[HEIGHT - 1 - i] = spm_offset;
        long temp_idx = alloc_temp_entry(dram_addr, spm_offset);
        spm_copy_to_local(dram_addr, spm_offset, global_dma_id);
        // acquire_temp_entry_by_index(temp_idx);
        acquire_write_block(spm_offset);
        if (i == 0){
          dirty_temp_entry_by_index(temp_idx);
        }
      }
  }
  // uint64_t counter_id = data_id;
  uint64_t mac_req_id = 0;
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    long j = (HEIGHT + load_start_index) - 1 - i;
    spm_offset_t parent_spm = (j == 0) ? 0 : spm_offset_array[j-1];
    dma_id_t need_id = (j == 0) ? wait_dma_id[0] : wait_dma_id[j-1];
    mac_req_id = global_mac_req_id;
    verify_one_height(spm_offset_array[j], parent_spm, path_indecis[j], mac_req_id,need_id, dram_addr_array[j]);
    global_mac_req_id += 1;
  }
  // 一時的なルートノードのアップデート
  if (mac_req_id > 0){
    mac_wait(mac_req_id,0);
  }
  // リーフのみを更新
  // if (load_start_index == 0){
  //   // rootノードの更新
  //   uint64_t root = spm_ld64(0);
  //   root += 1;
  //   spm_sd64(0, root);
  // } else {
  //   uint64_t start_level = load_start_index - 1;
  //   uint64_t minor_idx = path_indecis[start_level] % MINOR_COUNTER_COUNT; 
  //   uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
  //   uint64_t base_addr = spm_offset_array[start_level]; // または start_level
  //   uint64_t word_offset_bytes = (global_bit_offset / 64) * 8;
  //   uint64_t local_bit_offset  = global_bit_offset % 64;
  //   // 2. データの読み出し（Read-Modify-Writeのため、周辺ビットも含めて読む）
  //   uint64_t word1 = spm_ld64(base_addr + word_offset_bytes);
  //   uint64_t word2 = 0;
  //   bool is_split = (local_bit_offset + MINOR_COUNTER_WIDTH > 64);
  //   // またいでいる場合は次のワードも読む
  //   if (is_split) {
  //       word2 = spm_ld64(base_addr + word_offset_bytes + 8);
  //   }
  //   // 3. 現在のマイナーカウンター値の抽出
  //   uint64_t current_val_raw = word1 >> local_bit_offset;
  //   if (is_split) {
  //       // 次のワードの下位ビットを、現在の上位ビットとして結合
  //       current_val_raw |= (word2 << (64 - local_bit_offset));
  //   }
  //   uint64_t current_minor_val = current_val_raw & MINOR_COUNTER_MASK;
  //   // 4. 値の更新（インクリメントとオーバーフロー判定）
  //   if (current_minor_val == MINOR_COUNTER_MASK) {
  //       // オーバーフロー時の処理
  //       // printf("[Core FW] Minor counter overflow at level %llu for request_addr=%016llx\n", start_level, request_addr);
  //       // // pathのdram_addrとインデックスを表示
  //       // for (uint64_t lvl = start_level; lvl < HEIGHT; lvl++) {
  //       //     printf("  Level %llu: dram_addr=%016llx, index=%llu\n", lvl, dram_addr_array[lvl], path_indecis[lvl]);
  //       // }
  //       // exit(1);
  //       if (start_level == HEIGHT - 1){
  //         // リーフノードであるため、再暗号化処理を行う
  //         reencryption(dram_addr_array[start_level], spm_offset_array[start_level]);
  //       } else {
  //         // tag再計算
  //         recalc_tag(dram_addr_array[start_level], spm_offset_array[start_level], start_level, path_indecis[start_level]);
  //       }
  //   } else {
  //       uint64_t new_minor_val = current_minor_val + 1;
  //       // 5. 書き戻し用データの作成と保存
  //       // 書き戻しデータのビット幅（Word1に含まれる分）
  //       uint64_t bits_in_first = is_split ? (64 - local_bit_offset) : MINOR_COUNTER_WIDTH;
  //       uint64_t mask_first = MINOR_COUNTER_MASK;
  //       // A. 更新対象の場所を0クリア (Clear)
  //       word1 &= ~(mask_first << local_bit_offset);
  //       // B. 新しい値の下位パートをセット (Set)
  //       word1 |= ((new_minor_val & mask_first) << local_bit_offset);
  //       // C. 書き込み
  //       spm_sd64(base_addr + word_offset_bytes, word1);
  //       // --- Word 2 の更新（またいでいる場合のみ） ---
  //       if (is_split) {
  //         uint64_t bits_in_second = MINOR_COUNTER_WIDTH - bits_in_first;
  //         uint64_t mask_second = (1ULL << bits_in_second) - 1;
  //         // A. 更新対象の場所(先頭)を0クリア
  //         word2 &= ~mask_second;
  //         // B. 新しい値の上位パートをシフトしてセット
  //         word2 |= (new_minor_val >> bits_in_first) & mask_second;
  //         // C. 書き込み
  //         spm_sd64(base_addr + word_offset_bytes + 8, word2);
  //       }
  //   }
  //   index_t set_index = get_cache_set_index(dram_addr_array[start_level]);
  //   clearParentUpdated(set_index, way_index);
  //   set_block_dirty(set_index, way_index);
  // }
  // 木の更新：ルートから葉まで降りていく
  // リーフのみを更新

  // for (uint64_t i=load_start_index;i<HEIGHT;i++){
  //   mac_req_id = global_mac_req_id;
  //   update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], true,mac_req_id, wait_dma_id[i], dram_addr_array[i]);
  //   global_mac_req_id += 1;
  //   // long idx = find_temp_entry(dram_addr_array[i]);
  // }
  // if (mac_req_id > 0){
  //   mac_wait(mac_req_id,0);
  // }
  // 1. 対象となるマイナーカウンターのインデックスを計算
  // {uint64_t major_counter = spm_ld64(spm_offset_array[HEIGHT-1]);
  // uint64_t minor_idx = (request_addr / 64) % MINOR_COUNTER_COUNT;
  // // 2. データの開始位置（ビット単位）を計算
  // uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
  // // 3. 読み出すべきアドレス（8Bアライン）と、その中でのビットオフセットを計算
  // uint64_t base_addr = spm_offset_array[HEIGHT-1];
  // uint64_t word_offset_bytes = (global_bit_offset / 64) * 8; // 8バイト単位のオフセット
  // uint64_t local_bit_offset  = global_bit_offset % 64;       // 64bitワード内での開始ビット
  // // 4. 最初の64bitをロードしてシフト
  // uint64_t raw_data = spm_ld64(base_addr + word_offset_bytes);
  // uint64_t extracted_val = raw_data >> local_bit_offset;
  // // 5. カウンターが64bit境界をまたぐか判定し、必要なら2回目のロードを行う
  // //    (開始位置 + データ幅 が 64 を超える場合、次のワードにデータがはみ出している)
  // if (local_bit_offset + MINOR_COUNTER_WIDTH > 64) {
  //     uint64_t next_data = spm_ld64(base_addr + word_offset_bytes + 8);
  //     // はみ出した分（上位ビット）を結合
  //     // (64 - local_bit_offset) は、1つ目のワードに残っていたビット数
  //     extracted_val |= (next_data << (64 - local_bit_offset));
  // }
  // // 6. ビットマスクを生成して不要な上位ビットを切り落とす;
  // uint16_t minor_counter_value = extracted_val & MINOR_COUNTER_MASK;}
  // 結果の使用
  // リーフのみを更新
    uint64_t start_level = HEIGHT - 1;
    uint64_t major_counter = spm_ld64(spm_offset_array[start_level]);
    uint64_t minor_idx = path_indecis[start_level] % MINOR_COUNTER_COUNT; 
    uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
    uint64_t base_addr = spm_offset_array[start_level]; // または start_level
    uint64_t word_offset_bytes = (global_bit_offset / 64) * 8;
    uint64_t local_bit_offset  = global_bit_offset % 64;
    // 2. データの読み出し（Read-Modify-Writeのため、周辺ビットも含めて読む）
    uint64_t word1 = spm_ld64(base_addr + word_offset_bytes);
    uint64_t word2 = 0;
    bool is_split = (local_bit_offset + MINOR_COUNTER_WIDTH > 64);
    // またいでいる場合は次のワードも読む
    if (is_split) {
        word2 = spm_ld64(base_addr + word_offset_bytes + 8);
    }
    // 3. 現在のマイナーカウンター値の抽出
    uint64_t current_val_raw = word1 >> local_bit_offset;
    if (is_split) {
        // 次のワードの下位ビットを、現在の上位ビットとして結合
        current_val_raw |= (word2 << (64 - local_bit_offset));
    }
    uint64_t current_minor_val = current_val_raw & MINOR_COUNTER_MASK;
    uint16_t minor_counter_value = current_minor_val;
    // 4. 値の更新（インクリメントとオーバーフロー判定）
    if (current_minor_val == MINOR_COUNTER_MASK) {
        // オーバーフロー時の処理
        // printf("[Core FW] Minor counter overflow at level %llu for request_addr=%016llx\n", start_level, request_addr);
        // // pathのdram_addrとインデックスを表示
        // for (uint64_t lvl = start_level; lvl < HEIGHT; lvl++) {
        //     printf("  Level %llu: dram_addr=%016llx, index=%llu\n", lvl, dram_addr_array[lvl], path_indecis[lvl]);
        // }
        // exit(1);
        // if (start_level == HEIGHT - 1){
        //   // リーフノードであるため、再暗号化処理を行う
        //   reencryption(dram_addr_array[start_level], spm_offset_array[start_level]);
        // } else {
        //   // tag再計算
        //   recalc_tag(dram_addr_array[start_level], spm_offset_array[start_level], start_level, path_indecis[start_level]);
        // }
    } else {
        uint64_t new_minor_val = current_minor_val + 1;
        minor_counter_value += 1;
        // 5. 書き戻し用データの作成と保存
        // 書き戻しデータのビット幅（Word1に含まれる分）
        uint64_t bits_in_first = is_split ? (64 - local_bit_offset) : MINOR_COUNTER_WIDTH;
        uint64_t mask_first = MINOR_COUNTER_MASK;
        // A. 更新対象の場所を0クリア (Clear)
        word1 &= ~(mask_first << local_bit_offset);
        // B. 新しい値の下位パートをセット (Set)
        word1 |= ((new_minor_val & mask_first) << local_bit_offset);
        // C. 書き込み
        spm_sd64(base_addr + word_offset_bytes, word1);
        // --- Word 2 の更新（またいでいる場合のみ） ---
        if (is_split) {
          uint64_t bits_in_second = MINOR_COUNTER_WIDTH - bits_in_first;
          uint64_t mask_second = (1ULL << bits_in_second) - 1;
          // A. 更新対象の場所(先頭)を0クリア
          word2 &= ~mask_second;
          // B. 新しい値の上位パートをシフトしてセット
          word2 |= (new_minor_val >> bits_in_first) & mask_second;
          // C. 書き込み
          spm_sd64(base_addr + word_offset_bytes + 8, word2);
        }
    }
  set_seed(major_counter, minor_counter_value, request_addr);
  dram_addr_t datamacblock_addr = DATA_TAG_BASE + (((request_addr - PROTECTION_BASE) / (64 * 8))) * 64;
  index_t set_index = get_cache_mac_index(datamacblock_addr);
  light_tag_info_t light_info = light_tag_check_set(set_index, datamacblock_addr);
  spm_offset_t spm_offset;
  dma_id_t tag_id = global_dma_id;
  // struct Info tag_info = tag_check(datamacblock_addr);
  if (light_info.hit){
    spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
  } else {
    global_dma_id += 1;
    // tag_id += 1;
    tag_id = global_dma_id;
    if (light_info.way == -1){
      light_info.way = get_victim_way(set_index);
      bool dirty = is_block_dirty(set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      if (dirty){
        dram_addr_t old_block_addr = get_block_addr(set_index, light_info.way);
        spm_write_back(spm_offset, old_block_addr, 0);
      }
    } else {
      set_block_valid(set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    }
    spm_copy_to_local(datamacblock_addr, spm_offset, tag_id);
    long slot_idx = (set_index * CACHE_WAYS) + light_info.way;
    #ifdef ENABLE_TMU_HARDWARE
      long ret;
      TMU_INSN_R(F7_TMU_SET_TAG, ret, slot_idx, datamacblock_addr); 
    #else
      valid_metadata[set_index][light_info.way] = true;
      dirty_metadata[set_index][light_info.way] = false;
      block_addr_metadata[set_index][light_info.way] = datamacblock_addr;
    #endif
    // タグメタデータ更新
    clear_block_dirty(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
  }
  // acquire_cache_block(set_index, light_info.way);
  acquire_write_block(spm_offset);
  while(AES_START_REG);
  xor_start(true, false,req_id,DATA_SPM_OFFSET);
  // --- 手順3: MAC計算 ---
  // mac_req_id += 1;
  // mac_req_id = global_mac_req_id;
  mac_init(global_mac_req_id,0,1);
  mac_buffer_set(DATA_SPM_OFFSET, tag_id,0); 
  mac_update(0, 511,0);
  mac_buffer_set(spm_offset_array[HEIGHT-1], tag_id,0);
  mac_update(0,63,0);
  mac_update(global_bit_offset, global_bit_offset + (MINOR_COUNTER_WIDTH - 1),0);
  mac_input_core(request_addr,0);
  mac_digest(spm_offset + ((request_addr - PROTECTION_BASE) / 64) % 8 * 8, tag_id,0);
  set_block_dirty(set_index, light_info.way);
  spm_write_back(DATA_SPM_OFFSET, request_addr, 0);
  axim_write_return(req_id);
  mac_wait(global_mac_req_id,0);
  global_mac_req_id += 1;
  release_write_block(spm_offset);
    // スワップ
  for (long i = HEIGHT - 1; i >= (long)load_start_index; i--){
    spm_offset_t spm_offset = spm_offset_array[i];
    release_write_block(spm_offset);
  }
  if (load_start_index != 0){
    // rootノードの更新
    spm_offset_t root_spm = spm_offset_array[load_start_index - 1];
    release_write_block(root_spm);
  }
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    dram_addr_t dram_addr = dram_addr_array[i];
    bool is_write = true;
    bool is_leaf = (i == HEIGHT - 1);
    swapp_dram_addr(dram_addr,is_leaf,true);
  }
}


void Verification(dram_addr_t request_addr, uint64_t req_id){
  uint64_t start_time = read_instret();
  global_dma_id += 1;
  dma_id_t data_id = global_dma_id;
  spm_copy_to_local(request_addr, DATA_SPM_OFFSET, data_id);
  // HEIGHT-1がリーフ、0が高さ1
  spm_offset_t spm_offset_array[HEIGHT];
  dram_addr_t dram_addr_array[HEIGHT];
  uint64_t hit_index = HEIGHT;
  dma_id_t wait_dma_id[HEIGHT];
  uint64_t tag_path_check_s = read_instret();
  index_t index = (request_addr - PROTECTION_BASE) / 64;
  index_t v_i = index;
  // level_baseもポインタで走査する
  for (long i = 0;i<HEIGHT;i++){
    dram_addr_t dram_addr = index / MINOR_COUNTER_COUNT * 64 + level_base[HEIGHT - i];
    index = index / MINOR_COUNTER_COUNT;
    dram_addr_array[i] = dram_addr;
    index_t set_index = get_cache_tree_set_index(dram_addr);
    light_tag_info_t info = light_tag_check_set(set_index, dram_addr);
    if (info.hit){
      hit_index = i;
      index_t way_index = info.way;//get_way(set_index,dram_addr);
      update_lru_on_access(set_index, way_index);
      spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way_index);
      spm_offset_array[i] = spm_offset;
      wait_dma_id[i] = global_dma_id;
      acquire_read_block(spm_offset);
      break;
    } else {
      global_dma_id += 1;
      wait_dma_id[i] = global_dma_id;
      spm_offset_t spm_offset = pop_temp_buffer();
      spm_offset_array[i] = spm_offset;
      alloc_temp_entry(dram_addr, spm_offset);
      spm_copy_to_local(dram_addr, spm_offset, global_dma_id);
      acquire_read_block(spm_offset);
    }
  }
  uint64_t tag_path_check_e = read_instret();
  // printf("[Core FW] Verification Tag Path Check Time: %llu %llu\n", tag_path_check_e - tag_path_check_s,hit_index);
  // exit(1);
  uint64_t verify_s = read_instret();
  uint64_t mac_req_id = 0;
  // index = (request_addr - PROTECTION_BASE) / 64;
  for (uint64_t i = 0;i<hit_index;i++){
    spm_offset_t parent_spm = (i == HEIGHT - 1) ? 0 : spm_offset_array[i+1];
    dma_id_t need_id = (i == HEIGHT - 1) ? wait_dma_id[HEIGHT - 1] : wait_dma_id[i+1];
    mac_req_id = global_mac_req_id;
    verify_one_height(spm_offset_array[i], parent_spm, v_i, mac_req_id,need_id, dram_addr_array[i]);
    global_mac_req_id += 1;
    v_i = v_i / MINOR_COUNTER_COUNT;
  }
  uint64_t verify_e = read_instret();
  uint64_t wait_s = read_instret();
  if (hit_index > 0){
    dma_id_t wait_id = wait_dma_id[0];
    spm_wait(wait_id);  
  }
  uint64_t wait_e = read_instret();
  uint64_t set_seed_s = read_instret();
  spm_offset_t base_spm_offset = spm_offset_array[0];
  uint64_t major_counter = spm_ld64(base_spm_offset);
  // 1. 対象となるマイナーカウンターのインデックスを計算
  uint64_t minor_idx = (request_addr / 64) % MINOR_COUNTER_COUNT;
  // 2. データの開始位置（ビット単位）を計算
  uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
  // 3. 読み出すべきアドレス（8Bアライン）と、その中でのビットオフセットを計算
  // uint64_t base_addr = spm_ld64(DATA_SPM_ARRAY + (HEIGHT-1) * 8);
  uint64_t word_offset_bytes = (global_bit_offset / 64) * 8; // 8バイト単位のオフセット
  uint64_t local_bit_offset  = global_bit_offset % 64;       // 64bitワード内での開始ビット
  // 4. 最初の64bitをロードしてシフト
  uint64_t raw_data = spm_ld64(base_spm_offset + word_offset_bytes);
  uint64_t extracted_val = raw_data >> local_bit_offset;
  // 5. カウンターが64bit境界をまたぐか判定し、必要なら2回目のロードを行う
  //    (開始位置 + データ幅 が 64 を超える場合、次のワードにデータがはみ出している)
  if (local_bit_offset + MINOR_COUNTER_WIDTH > 64) {
      uint64_t next_data = spm_ld64(base_spm_offset + word_offset_bytes + 8);
      // はみ出した分（上位ビット）を結合
      // (64 - local_bit_offset) は、1つ目のワードに残っていたビット数
      extracted_val |= (next_data << (64 - local_bit_offset));
  }
  // 6. ビットマスクを生成して不要な上位ビットを切り落とす;
  uint16_t minor_counter_value = extracted_val & MINOR_COUNTER_MASK;
  // 結果の使用
  set_seed(major_counter, minor_counter_value, request_addr);
  uint64_t set_seed_e = read_instret();
  // SPMに当該MACブロックがあるかを確認。なければコピー。
  uint64_t datamac_dma_s = read_instret();
  dram_addr_t datamacblock_addr = get_datamacblock_addr(request_addr);
  index_t set_index = get_cache_set_index(datamacblock_addr);
  dma_id_t tag_id = global_dma_id;
  spm_offset_t spm_offset;
  light_tag_info_t light_info = light_tag_check(datamacblock_addr);
  if (light_info.hit){
    spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
  } else {
    tag_id += 1;
    global_dma_id += 1;
    if (light_info.way == -1){
      light_info.way = get_victim_way(set_index);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      bool dirty = is_block_dirty(set_index, light_info.way);
      if (dirty){
        dram_addr_t old_block_addr = get_block_addr(set_index, light_info.way);
        spm_write_back(spm_offset, old_block_addr, 0);
      }
    } else {
      set_block_valid(set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    }
    spm_copy_to_local(datamacblock_addr, spm_offset, tag_id);
    set_block_addr(set_index, light_info.way, datamacblock_addr);
    clear_block_dirty(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
  }
  acquire_read_block(spm_offset);
  uint64_t datamac_dma_e = read_instret();
  uint64_t datamac_s = read_instret();
  mac_init(global_mac_req_id,0,1);
  mac_buffer_set(DATA_SPM_OFFSET,data_id,0);
  mac_update(0, 511,0);
  mac_buffer_set(base_spm_offset,wait_dma_id[0],0);
  mac_update(0,63,0);
  mac_update(global_bit_offset, global_bit_offset + (MINOR_COUNTER_WIDTH - 1),0);
  mac_input_core(request_addr,0);
  spm_offset_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
  mac_result_compare(spm_offset + dmac_byte_offset, tag_id,0);
  uint64_t datamac_e = read_instret();
  uint64_t response_s = read_instret();
  while(AES_START_REG);
  spm_wait(data_id);
  xor_start(false, true,req_id,DATA_SPM_OFFSET);
  mac_wait(global_mac_req_id,0);
  global_mac_req_id += 1;
  axim_read_return(req_id);
  release_read_block(spm_offset);
  uint64_t response_e = read_instret();
  uint64_t start_swapp_time = read_instret();
  for (long i = 0; i < hit_index; i++){
    spm_offset_t spm_offset = spm_offset_array[i];
    release_read_block(spm_offset);
  }
  if (hit_index != HEIGHT){
    spm_offset_t spm_offset = spm_offset_array[hit_index];
    release_read_block(spm_offset);
  }
  for (uint64_t i = 0;i<hit_index;i++){
    dram_addr_t dram_addr = dram_addr_array[i];
    swapp_dram_addr(dram_addr,false,false);
  }
  uint64_t swapp_end_time = read_instret();
  if (instret_dump){
    printf("Total instret time %d\n", swapp_end_time - start_time);
    printf("tag check time %d\n", tag_path_check_e - tag_path_check_s);
    printf("verify time %d verify level %d\n", verify_e - verify_s, hit_index);
    printf("wait dma time %d\n", wait_e - wait_s);
    printf("set seed time %d\n", set_seed_e - set_seed_s); 
    printf("load mac time %d\n", datamac_dma_e - datamac_dma_s);
    printf("mac compute time %d\n", datamac_e - datamac_s);
    printf("response time %d\n", response_e - response_s);
    printf("swapp total time %d\n", swapp_end_time - start_swapp_time);
  }
}

int main(void){
  // loadをいじる
  SPM_SIZE_REG = 64;
  for (uint64_t i=0; i<512; i++){
    spm_sd64(i*8, 0); 
  }
  // rootノードの初期化
  spm_sd64(0,1);
  init_cache_system();
  temp_system_init(CACHE_DATA_SPM_BASE + CACHE_SETS * CACHE_WAYS * 64);
  // dma_id_t dma_id = 0;
  int total = 0;
  for (int i = 0;i < HEIGHT+1;i++){
    level_base[i] = calculate_level_base_addr(i) + COUNTER_BASE;
  }
  while(1){
    for(;;){
      if(AXIM_STATUS_REG & 1) break; // リクエストが来るまで待つ
    }
    bool is_write = (AXIM_STATUS_REG & 2) != 0;
    dram_addr_t addr = AXIM_REQ_ADDR_REG;
    uint64_t req_id = AXIM_REQ_ID_REG;
    total += 1;
    if (total % 10000 == 0){
      printf("Processed %d requests\n", total);
      instret_dump = true;
    } else {
      instret_dump = false;
    }
    if ((addr - PROTECTION_BASE) >= (16ULL * 1024 * 1024 * 1024)){ // 16GBを超えないようにしたい
      printf("Error: Address out of range: %016llx\n", addr);
      exit(1);
    }
    if (addr == 0xFFFFFFFFFFFFFFFF){
      return 0;
    } else {
      if(is_write){ // writeリクエスト
        Authentication(addr,req_id);
      } else {
        Verification(addr,req_id);
      }
    }
  }
}