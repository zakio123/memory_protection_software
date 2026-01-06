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

bool instret_dump = false;
uint64_t global_mac_req_id = 0;

dram_addr_t level_base[HEIGHT + 1] = {0};

dma_id_t Authentication(dma_id_t id, dram_addr_t request_addr, uint32_t req_id){
  uint64_t mac_req_id = global_mac_req_id;
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
  dma_id_t tmp_id = id;
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
        wait_dma_id[HEIGHT - 1 - i] = tmp_id;
        break;
      } else {
        tmp_id += 1;
        wait_dma_id[HEIGHT - 1 - i] = tmp_id;
        spm_offset_t spm_offset = pop_temp_buffer();
        spm_offset_array[HEIGHT - 1 - i] = spm_offset;
        long temp_idx = alloc_temp_entry(dram_addr, spm_offset);
        spm_copy_to_local(dram_addr, spm_offset, 64, tmp_id);
        acquire_temp_entry_by_index(temp_idx);
      }
  }
  // uint64_t counter_id = data_id;
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    long j = (HEIGHT + load_start_index) - 1 - i;
    spm_offset_t parent_spm = (j == 0) ? 0 : spm_offset_array[j-1];
    mac_req_id += 1;
    dma_id_t need_id = (j == 0) ? wait_dma_id[0] : wait_dma_id[j-1];
    spm_sd64(DRAM_ADDR_OFFSET_BASE + (j + 1) * 8, dram_addr_array[j]);
    verify_one_height(spm_offset_array[j], parent_spm, path_indecis[j], mac_req_id,need_id, dram_addr_array[j], DRAM_ADDR_OFFSET_BASE + (j + 1) * 8);
  }
  // 一時的なルートノードのアップデート
  for (;;){
    if (mac_wait(mac_req_id)) break;    
  }
  if (load_start_index == 0){
    // rootノードの更新
    uint64_t root = spm_ld64(0);
    root += 1;
    spm_sd64(0, root);
  } else {
    uint64_t start_level = load_start_index - 1;
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
    // 4. 値の更新（インクリメントとオーバーフロー判定）
    uint64_t new_minor_val;
    if (current_minor_val == MINOR_COUNTER_MASK) {
        // オーバーフロー時の処理
        new_minor_val = 0;
        // --- メジャーカウンターの更新処理 ---
        // ここにメジャーカウンターのインクリメント処理が入ります
        // 例:
        // uint64_t major_counter = spm_ld64(base_addr);
        // spm_sd64(base_addr, major_counter + 1);
        // ----------------------------------
    } else {
        new_minor_val = current_minor_val + 1;
    }
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
    // uint64_t major_counter = spm_ld64(spm_offset_array[start_level]);
    // uint64_t minor_counter_byte_address = spm_offset_array[start_level] + 8 + (path_indecis[start_level] % 32) / 8 * 8;
    // uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
    // // ここから過去のminor counterを取り出す
    // uint8_t minor_counter_value = (minor_counter >> ((path_indecis[start_level] % 8) * 8)) & 0xFF;
    // uint8_t new_minor_counter = 0;
    // if (minor_counter_value == 0xFF){
    //     // uint64_t new_major_counter = major_counter + 1;
    //     // spm_sd64(spm_offset_array[load_start_index - 1], new_major_counter);
    //     new_minor_counter = 0; 
    // } else {
    //     new_minor_counter = minor_counter_value + 1;
    // }
    // uint64_t shift_amount = (path_indecis[load_start_index - 1] % 8) * 8;
    // uint64_t clear_mask = ~(0xFFULL << shift_amount);
    // uint64_t cleared_minor_counter = minor_counter & clear_mask;
    // uint64_t shifted_new_value = (new_minor_counter);
    // shifted_new_value <<= shift_amount;
    // uint64_t final_word = cleared_minor_counter | shifted_new_value;
    // // 書き戻し
    // spm_sd64(minor_counter_byte_address, final_word);
    // 一時的なルートなので、parent updatedはfalseにしておく
    index_t set_index = get_cache_set_index(dram_addr_array[start_level]);
    clearParentUpdated(set_index, way_index);
    set_block_dirty(set_index, way_index);
  }
  // 木の更新：ルートから葉まで降りていく
  for (uint64_t i=load_start_index;i<HEIGHT;i++){
    mac_req_id += 1;
    update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], true,mac_req_id, wait_dma_id[i], dram_addr_array[i], DRAM_ADDR_OFFSET_BASE + (i + 1) * 8);
    long idx = find_temp_entry(dram_addr_array[i]);
    dirty_temp_entry_by_index(idx);
    // if (dram_addr_array[i] == 0x51fb1bdc0){
    //   for(;;){
    //     if (mac_wait(mac_req_id)) break;
    //   }
    //   printf("Debug dirty temp entry mac_req_id=%llu\n", mac_req_id);
    //   for (int k = 0;k<8;k++){
    //     uint64_t val = spm_ld64(spm_offset_array[i] + k * 8);
    //     printf("temp buffer at spm offset %llu word %d: %016llx\n", spm_offset_array[i], k, val);
    //   }
    // }
  }
  for (;;){
    if (mac_wait(mac_req_id)) break;
  }
  // 1. 対象となるマイナーカウンターのインデックスを計算
  uint64_t major_counter = spm_ld64(spm_offset_array[HEIGHT-1]);
  uint64_t minor_idx = (request_addr / 64) % MINOR_COUNTER_COUNT;
  // 2. データの開始位置（ビット単位）を計算
  uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
  // 3. 読み出すべきアドレス（8Bアライン）と、その中でのビットオフセットを計算
  uint64_t base_addr = spm_offset_array[HEIGHT-1];
  uint64_t word_offset_bytes = (global_bit_offset / 64) * 8; // 8バイト単位のオフセット
  uint64_t local_bit_offset  = global_bit_offset % 64;       // 64bitワード内での開始ビット
  // 4. 最初の64bitをロードしてシフト
  uint64_t raw_data = spm_ld64(base_addr + word_offset_bytes);
  uint64_t extracted_val = raw_data >> local_bit_offset;
  // 5. カウンターが64bit境界をまたぐか判定し、必要なら2回目のロードを行う
  //    (開始位置 + データ幅 が 64 を超える場合、次のワードにデータがはみ出している)
  if (local_bit_offset + MINOR_COUNTER_WIDTH > 64) {
      uint64_t next_data = spm_ld64(base_addr + word_offset_bytes + 8);
      // はみ出した分（上位ビット）を結合
      // (64 - local_bit_offset) は、1つ目のワードに残っていたビット数
      extracted_val |= (next_data << (64 - local_bit_offset));
  }
  // 6. ビットマスクを生成して不要な上位ビットを切り落とす;
  uint16_t minor_counter_value = extracted_val & MINOR_COUNTER_MASK;
  // 結果の使用
  // printf("[Core FW] Retrieved Counters: major=%016llx, minor=%02x for request_addr=%016llx\n", major_counter, minor_counter_value, request_addr);
  set_seed(major_counter, minor_counter_value, request_addr);
  dram_addr_t datamacblock_addr = DATA_TAG_BASE + (((request_addr - PROTECTION_BASE) / (64 * 8))) * 64;
  index_t set_index = get_cache_set_index(datamacblock_addr);
  light_tag_info_t light_info = light_tag_check(datamacblock_addr);
  spm_offset_t spm_offset;
  dma_id_t tag_id = tmp_id;
  // struct Info tag_info = tag_check(datamacblock_addr);
  if (light_info.hit){
    spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
  } else {
    tag_id += 1;
    if (light_info.way == -1){
      light_info.way = get_victim_way(set_index);
      bool dirty = is_block_dirty(set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      if (dirty){
        dram_addr_t old_block_addr = get_block_addr(set_index, light_info.way);
        spm_write_back(spm_offset, old_block_addr, 64, 0);
      }
    } else {
      set_block_valid(set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    }
    spm_copy_to_local(datamacblock_addr, spm_offset, 64, tag_id);
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
  acquire_cache_block(set_index, light_info.way);
  while(AES_START_REG);
  xor_start(true, false,req_id,DATA_SPM_OFFSET);
  // --- 手順3: MAC計算 ---
  spm_sd64(DRAM_ADDR_OFFSET_BASE, request_addr);
  mac_req_id += 1;
  mac_init(mac_req_id,true);
  mac_buffer_set(DATA_SPM_OFFSET, tag_id); 
  mac_update(0, 511);
  mac_buffer_set(spm_offset_array[HEIGHT-1], tag_id);
  mac_update(0,63);
  mac_update(global_bit_offset, global_bit_offset + (MINOR_COUNTER_WIDTH - 1));
  mac_buffer_set(DRAM_ADDR_OFFSET_BASE, tag_id);
  mac_update(0,63);
  mac_digest(spm_offset + ((request_addr - PROTECTION_BASE) / 64) % 8 * 8, tag_id);
  set_block_dirty(set_index, light_info.way);
  spm_write_back(DATA_SPM_OFFSET, request_addr, 64, 0);
  axim_write_return(req_id);
  for (;;){
    if (mac_wait(mac_req_id)) break;
  }
  release_cache_block(set_index, light_info.way);
  global_mac_req_id = mac_req_id;
    // スワップ
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    dram_addr_t dram_addr = dram_addr_array[i];
    index_t set_index = get_cache_tree_set_index(dram_addr);
    uint64_t tmp = read_instret();
    long way = get_victim_way(set_index);
    bool mac_updated = is_mac_updated(set_index, way);
    long idx = find_temp_entry(dram_addr);
    release_temp_entry_by_index(idx);
    // release_time = read_instret();
    if (mac_updated){
      spm_offset_t old_spm_offset = get_cache_block_spm_offset(set_index, way);
      dram_addr_t old_dram_addr = get_block_addr(set_index, way);
      bool dirty = is_block_dirty(set_index, way);
      if (dirty){
        spm_write_back(old_spm_offset, old_dram_addr, 64, 0);
      }
      swapp_temp_cache(dram_addr, spm_offset_array[i], true, way);
      push_temp_buffer(old_spm_offset);
      setParentUpdated(set_index, way);
      // swapp_time = read_instret();
    } else {
      spm_write_back(spm_offset_array[i], dram_addr, 64, 0);
      push_temp_buffer(spm_offset_array[i]);
    }
    invalidate_temp_entry_by_index(idx);
  }
  return tag_id;
}

dma_id_t Verification(dma_id_t id, dram_addr_t request_addr, uint64_t req_id){
  uint64_t start_time = read_instret();
  uint64_t mac_req_id = global_mac_req_id;
  // データのコピー
  dma_id_t data_id = id+1;
  spm_copy_to_local(request_addr, DATA_SPM_OFFSET, 64,data_id);
  // HEIGHT-1がリーフ、0が高さ1
  uint64_t path_indecis[HEIGHT];
  spm_offset_t spm_offset_array[HEIGHT];
  dram_addr_t dram_addr_array[HEIGHT];
  uint64_t load_start_index = 0;
  dma_id_t wait_dma_id[HEIGHT];
  index_t way_index = 0;
  dma_id_t tmp_id = data_id;
  uint64_t tag_path_check_s = read_instret();
  for(uint64_t i=0; i<HEIGHT; ++i){
      uint64_t index = (request_addr - PROTECTION_BASE) / (64 * (1ULL << (ARTY_LOG2 * i)));
      path_indecis[HEIGHT - 1 - i ] = index;
      dram_addr_t dram_addr = COUNTER_BASE + index / MINOR_COUNTER_COUNT * 64 + calculate_level_base_addr(HEIGHT - i);
      dram_addr_array[HEIGHT - 1 - i] = dram_addr;
      light_tag_info_t info = light_tag_check(dram_addr);
      long temp_idx = -1;
      if (info.hit){
        load_start_index = HEIGHT - i;
        long set_index = get_cache_tree_set_index(dram_addr);
        way_index = info.way;
        spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way_index);
        spm_offset_array[HEIGHT - 1 - i] = spm_offset;
        wait_dma_id[HEIGHT - 1 - i] = tmp_id;
        update_lru_on_access(set_index, way_index);
        break;
      } else {
        tmp_id += 1;
        wait_dma_id[HEIGHT - 1 - i] = tmp_id;
        spm_offset_t spm_offset = pop_temp_buffer();
        spm_offset_array[HEIGHT - 1 - i] = spm_offset;
        temp_idx = alloc_temp_entry(dram_addr, spm_offset);
        spm_copy_to_local(dram_addr, spm_offset, 64, tmp_id);
        acquire_temp_entry_by_index(temp_idx);
      }
      // printf("Debug path check level %d: addr calc time %d, tag check time %d, temp alloc time %d\n", i, e_1 - s_1, e_2 - s_2, e_3 - s_3);
      // printf("total time for level %d: %d\n", i, e_3 - s_1);
      // printf(" temp idx =%d\n", temp_idx);
  }
  uint64_t tag_path_check_e = read_instret();
  uint64_t verify_s = read_instret();
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    long j = (HEIGHT + load_start_index) - 1 - i;
    spm_offset_t parent_spm = (j == 0) ? 0 : spm_offset_array[j-1];
    mac_req_id += 1;
    dma_id_t need_id = (j == 0) ? wait_dma_id[0] : wait_dma_id[j-1];
    spm_sd64(DRAM_ADDR_OFFSET_BASE + (j + 1) * 8, dram_addr_array[j]);
    verify_one_height(spm_offset_array[j], parent_spm, path_indecis[j], mac_req_id,need_id, dram_addr_array[j], DRAM_ADDR_OFFSET_BASE + (j + 1) * 8);
  }
  uint64_t verify_e = read_instret();
  uint64_t wait_s = read_instret();
  dma_id_t wait_id = wait_dma_id[HEIGHT-1];
  // while(!mac_wait(mac_req_id));
  spm_wait(wait_id);
  uint64_t wait_e = read_instret();
  uint64_t set_seed_s = read_instret();
  // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
  uint64_t major_counter = spm_ld64(spm_offset_array[HEIGHT-1]);

  // 1. 対象となるマイナーカウンターのインデックスを計算
  uint64_t minor_idx = (request_addr / 64) % MINOR_COUNTER_COUNT;
  // 2. データの開始位置（ビット単位）を計算
  uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
  // 3. 読み出すべきアドレス（8Bアライン）と、その中でのビットオフセットを計算
  uint64_t base_addr = spm_offset_array[HEIGHT-1];
  uint64_t word_offset_bytes = (global_bit_offset / 64) * 8; // 8バイト単位のオフセット
  uint64_t local_bit_offset  = global_bit_offset % 64;       // 64bitワード内での開始ビット
  // 4. 最初の64bitをロードしてシフト
  uint64_t raw_data = spm_ld64(base_addr + word_offset_bytes);
  uint64_t extracted_val = raw_data >> local_bit_offset;
  // 5. カウンターが64bit境界をまたぐか判定し、必要なら2回目のロードを行う
  //    (開始位置 + データ幅 が 64 を超える場合、次のワードにデータがはみ出している)
  if (local_bit_offset + MINOR_COUNTER_WIDTH > 64) {
      uint64_t next_data = spm_ld64(base_addr + word_offset_bytes + 8);
      // はみ出した分（上位ビット）を結合
      // (64 - local_bit_offset) は、1つ目のワードに残っていたビット数
      extracted_val |= (next_data << (64 - local_bit_offset));
  }
  // 6. ビットマスクを生成して不要な上位ビットを切り落とす;
  uint16_t minor_counter_value = extracted_val & MINOR_COUNTER_MASK;
  // 結果の使用
  // printf("[Core FW] Retrieved Counters: major=%016llx, minor=%02x for request_addr=%016llx\n", major_counter, minor_counter_value, request_addr);
  set_seed(major_counter, minor_counter_value, request_addr);
  // uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
  // uint64_t minor_counter = spm_ld64(spm_offset_array[HEIGHT-1] + (counter_bit_offset / 64) * 8);
  // uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64) )) & 0xFF;
  // set_seed(major_counter, minor_counter_value, request_addr);
  uint64_t set_seed_e = read_instret();
  // SPMに当該MACブロックがあるかを確認。なければコピー。
  uint64_t datamac_dma_s = read_instret();
  dram_addr_t datamacblock_addr = get_datamacblock_addr(request_addr);
  index_t set_index = get_cache_set_index(datamacblock_addr);
  dma_id_t tag_id = tmp_id;
  spm_offset_t spm_offset;
  light_tag_info_t light_info = light_tag_check(datamacblock_addr);
  if (light_info.hit){
    spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
  } else {
    tag_id += 1;
    if (light_info.way == -1){
      light_info.way = get_victim_way(set_index);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      bool dirty = is_block_dirty(set_index, light_info.way);
      if (dirty){
        dram_addr_t old_block_addr = get_block_addr(set_index, light_info.way);
        spm_write_back(spm_offset, old_block_addr, 64, 0);
      }
    } else {
      set_block_valid(set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    }
    spm_copy_to_local(datamacblock_addr, spm_offset, 64, tag_id);
    set_block_addr(set_index, light_info.way, datamacblock_addr);
    clear_block_dirty(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
  }
  acquire_cache_block(set_index, light_info.way);
  uint64_t datamac_dma_e = read_instret();
  uint64_t datamac_s = read_instret();
  spm_sd64(DRAM_ADDR_OFFSET_BASE, request_addr);
  mac_req_id += 1;
  mac_init(mac_req_id,true);
  mac_buffer_set(DATA_SPM_OFFSET,data_id);
  mac_update(0, 511);
  mac_buffer_set(spm_offset_array[HEIGHT-1],wait_dma_id[HEIGHT-1]);
  mac_update(0,63);
  mac_update(global_bit_offset, global_bit_offset + (MINOR_COUNTER_WIDTH - 1));
  spm_offset_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
  mac_buffer_set(DRAM_ADDR_OFFSET_BASE, tag_id);
  mac_update(0,63);
  mac_result_compare(spm_offset + dmac_byte_offset, tag_id);
  uint64_t datamac_e = read_instret();
  uint64_t response_s = read_instret();
  while(AES_START_REG);
  spm_wait(data_id);
  xor_start(false, true,req_id,DATA_SPM_OFFSET);
  for(;;){
    if (mac_wait(mac_req_id)) break;
  }
  axim_read_return(req_id);
  release_cache_block(set_index, light_info.way);
  uint64_t response_e = read_instret();
  uint64_t start_swapp_time = read_instret();
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    dram_addr_t dram_addr = dram_addr_array[i];
    index_t set_index = get_cache_tree_set_index(dram_addr);
    long way = get_victim_way(set_index);
    bool mac_updated = is_mac_updated(set_index, way);
    long idx = find_temp_entry(dram_addr);
    release_temp_entry_by_index(idx);
    if (mac_updated){
      bool temp_dirty = is_dirty_temp_entry_by_index(idx);
      spm_offset_t old_spm_offset = get_cache_block_spm_offset(set_index, way);
      dram_addr_t old_dram_addr = get_block_addr(set_index, way);
      bool dirty = is_block_dirty(set_index, way);
      if (dirty){
        spm_write_back(old_spm_offset, old_dram_addr, 64, 0);
      }
      swapp_temp_cache(dram_addr, spm_offset_array[i], temp_dirty, way);
      push_temp_buffer(old_spm_offset);
      setParentUpdated(set_index, way);
    } else {
      push_temp_buffer(spm_offset_array[i]);
    }
    invalidate_temp_entry_by_index(idx);
  }
  uint64_t swapp_end_time = read_instret();
  if (instret_dump){
    printf("Total instret time %d\n", swapp_end_time - start_time);
    printf("tag check time %d\n", tag_path_check_e - tag_path_check_s);
    printf("verify time %d verify level %d\n", verify_e - verify_s, load_start_index);
    printf("set seed time %d\n", set_seed_e - set_seed_s); 
    printf("load mac time %d\n", datamac_dma_e - datamac_dma_s);
    printf("mac compute time %d\n", datamac_e - datamac_s);
    printf("response time %d\n", response_e - response_s);
    printf("swapp total time %d\n", swapp_end_time - start_swapp_time);
  }
  global_mac_req_id = mac_req_id;
  return tag_id;
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
  dma_id_t dma_id = 0;
  int total = 0;
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
        dma_id = Authentication(dma_id, addr,req_id);
      } else {
        dma_id = Verification(dma_id, addr,req_id);
      }
    }
  }
}