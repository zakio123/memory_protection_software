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
// #include "sec_operation.h"
#define REENCRYPTION_SPM_OFFSET DATA_SPM_OFFSET + 64
bool instret_dump = false;
dram_addr_t level_base[HEIGHT + 1] = {0};
dma_id_t global_dma_id = 0;
uint64_t global_mac_req_id = 1;
int over_flow_count = 0;

void update_tag(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index, 
  uint32_t mac_req_id, dma_id_t dma_id,dram_addr_t dram_addr){
    int hart_id = -1;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hart_id)
    );
  mac_init(mac_req_id,hart_id,0);
  if (parent_spm_offset == 0){
      mac_buffer_set(0, dma_id,hart_id);
      mac_update(0,63,hart_id);
  } else {
      uint64_t start_bit = 64 + (node_index / MINOR_COUNTER_COUNT) % MINOR_COUNTER_COUNT * MINOR_COUNTER_WIDTH;
      mac_buffer_set(parent_spm_offset, dma_id,hart_id);
      mac_update(0,63,hart_id);
      mac_update(start_bit, start_bit + (MINOR_COUNTER_WIDTH - 1),hart_id);
  }
  mac_buffer_set(child_spm_offset, dma_id,hart_id);
  mac_update(0, 447,hart_id);
  mac_input_core(dram_addr,hart_id);
  mac_digest(child_spm_offset + 56, dma_id,hart_id);
}

static inline void verify_one_height_lazy_root(spm_offset_t child_spm_offset, 
    uint32_t mac_req_id, dma_id_t dma_id,dram_addr_t dram_addr){
    int hart_id = -1;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hart_id)
    );
  mac_init(mac_req_id,hart_id,0);
  mac_buffer_set(0, dma_id,0);
  mac_update(0,63,hart_id);
  mac_buffer_set(child_spm_offset, dma_id,hart_id);
  mac_update(0, 447,hart_id);
  mac_input_core(dram_addr,hart_id);
  mac_result_compare(child_spm_offset + 56, dma_id,hart_id);
}

static inline void verify_one_height_lazy(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index, 
    uint32_t mac_req_id, dma_id_t dma_id,dram_addr_t dram_addr){
    int hart_id = -1;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hart_id)
    );
  mac_init(mac_req_id,hart_id,0);
  if (parent_spm_offset == 0){
      mac_buffer_set(0, dma_id,hart_id);
      mac_update(0,63,hart_id);
  } else {
      uint64_t start_bit = 64 + (node_index / MINOR_COUNTER_COUNT) % MINOR_COUNTER_COUNT * MINOR_COUNTER_WIDTH;
      mac_buffer_set(parent_spm_offset, dma_id,hart_id);
      mac_update(0,63,hart_id);
      mac_update(start_bit, start_bit + (MINOR_COUNTER_WIDTH - 1),hart_id);
  }
  mac_buffer_set(child_spm_offset, dma_id,hart_id);
  mac_update(0, 447,hart_id);
  mac_input_core(dram_addr,hart_id);
  mac_result_compare(child_spm_offset + 56, dma_id,hart_id);
}

// マイナーカウンターがオーバーフローした時の復号化+再暗号化処理
static inline uint64_t reencryption_lazy(dram_addr_t counter_block_addr,spm_offset_t counter_spm_offset){
  dram_addr_t data_block_addr = PROTECTION_BASE + (counter_block_addr - level_base[HEIGHT]) / 64 * (MINOR_COUNTER_COUNT * 64);
  uint64_t old_major_counter = spm_ld64(counter_spm_offset);
  uint64_t new_major_counter = old_major_counter + 1;
  dma_id_t dma_id;
  for (long i = 0;i < MINOR_COUNTER_COUNT;i++){
    // 必要なデータを読み出す。
    global_dma_id += 1;
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
      set_block_dirty(set_index, light_info.way);
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
      set_block_dirty(set_index, light_info.way);
    }
    // マイナーカウンターの取得
    uint64_t global_bit_offset = 64 + (i * MINOR_COUNTER_WIDTH);
    spm_sd64(counter_spm_offset, old_major_counter);
    // dmacの比較
    mac_init(global_mac_req_id,0,1);
    mac_buffer_set(REENCRYPTION_SPM_OFFSET, dma_id,0);
    mac_update(0,511,0);
    mac_buffer_set(counter_spm_offset, dma_id,0);
    mac_update(0,63,0);
    mac_update(global_bit_offset, global_bit_offset + MINOR_COUNTER_WIDTH - 1,0);
    mac_input_core(dram_addr,0);
    spm_offset_t dmac_byte_offset = ((dram_addr - PROTECTION_BASE) / 64) % 8 * 8;
    mac_result_compare(spm_offset + dmac_byte_offset,dma_id,0);
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
    uint64_t word1 = 0;
    uint64_t word2 = 0;
    bool is_split = (local_bit_offset + MINOR_COUNTER_WIDTH > 64);
    // またいでいる場合は次のワードも読む
    word1 = spm_ld64(counter_spm_offset + word_offset_bytes);
    if (is_split) {
        word2 = spm_ld64(counter_spm_offset + word_offset_bytes + 8);
    }
    uint64_t new_minor_val = 0;
    // 5. 書き戻し用データの作成と保存
    // 書き戻しデータのビット幅（Word1に含まれる分）
    uint64_t bits_in_first = is_split ? (64 - local_bit_offset) : MINOR_COUNTER_WIDTH;
    uint64_t mask_first = MINOR_COUNTER_MASK;
    // A. 更新対象の場所を0クリア (Clear)
    word1 &= ~(mask_first << local_bit_offset);
    // B. 新しい値の下位パートをセット (Set)
    word1 |= ((new_minor_val & mask_first) << local_bit_offset);
    // C. 書き込み
    spm_sd64(counter_spm_offset + word_offset_bytes, word1);
    // --- Word 2 の更新（またいでいる場合のみ） ---
    if (is_split) {
        uint64_t bits_in_second = MINOR_COUNTER_WIDTH - bits_in_first;
        uint64_t mask_second = (1ULL << bits_in_second) - 1;
        // A. 更新対象の場所(先頭)を0クリア
        word2 &= ~mask_second;
        // B. 新しい値の上位パートをシフトしてセット
        word2 |= (new_minor_val >> bits_in_first) & mask_second;
        // C. 書き込み
        spm_sd64(counter_spm_offset + word_offset_bytes + 8, word2);
    }
    spm_sd64(counter_spm_offset, new_major_counter);
    mac_init(global_mac_req_id,0,1);
    mac_buffer_set(REENCRYPTION_SPM_OFFSET, dma_id,0);
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
  return global_mac_req_id;
}


// 中間ノードのマイナーカウンターがオーバーフローした時の再計算処理
static inline uint64_t recalc_tag_lazy(dram_addr_t node_dram_addr, spm_offset_t node_spm_offset, int height, long index){
  long block_idx = index / MINOR_COUNTER_COUNT;
  dram_addr_t child_base_addr = level_base[height + 2] + block_idx * MINOR_COUNTER_COUNT * 64;
  uint64_t old_major_counter = spm_ld64(node_spm_offset);
  uint64_t new_major_counter = old_major_counter + 1;
  for (long i = 0;i < MINOR_COUNTER_COUNT;i++){
    long child_index = (block_idx * MINOR_COUNTER_COUNT + i) * MINOR_COUNTER_COUNT;
    dram_addr_t child_dram_addr = child_base_addr + i * 64;
    light_tag_info_t light_info = light_tag_check(child_dram_addr);
    spm_offset_t child_spm_offset;
    long temp_idx = -1;
    dma_id_t dma_id = global_dma_id;
    bool v_do = true;
    if (light_info.hit){
      // printf("[core fw] cache hit for addr=%016llx\n", child_dram_addr);
      index_t set_index = get_cache_tree_set_index(child_dram_addr);
      bool mac_updated = is_mac_updated(set_index, light_info.way);
      child_spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      set_block_dirty(set_index, light_info.way);
      setParentUpdated(set_index, light_info.way);
      if (!mac_updated){
        v_do = false;
      }
      // if (!mac_updated){
      //   child_spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      //   setParentUpdated(set_index, light_info.way);
      // } else {
      //   child_spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      //   setParentUpdated(set_index, light_info.way);
      //   set_block_dirty(set_index, light_info.way);
      // }

    } else {
      // tempバッファを検索
      temp_idx = find_temp_entry(child_dram_addr);
      if (temp_idx >= 0){
        child_spm_offset = get_temp_spm_offset(temp_idx);
      } else {
        child_spm_offset = REENCRYPTION_SPM_OFFSET; // 一時バッファを使用
        global_dma_id += 1;
        dma_id = global_dma_id;
        spm_copy_to_local(child_dram_addr, child_spm_offset, dma_id);
      }
    }
    spm_wait(dma_id);
    if (v_do){
      spm_sd64(node_spm_offset, old_major_counter);
      verify_one_height_lazy(child_spm_offset, node_spm_offset, child_index, global_mac_req_id, dma_id, child_dram_addr);
      mac_wait(global_mac_req_id,0);
      global_mac_req_id += 1;
    }
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
    // 4. 値の更新（インクリメントとオーバーフロー判定）
    uint64_t new_minor_val = 0;
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
    update_tag(child_spm_offset, node_spm_offset, child_index, global_mac_req_id, dma_id, child_dram_addr);
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
  uint64_t tmp = global_mac_req_id;
  return tmp;
}


static inline void update_one_height_lazy(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index, 
  bool update_counter, uint32_t mac_req_id, dma_id_t dma_id,
  dram_addr_t dram_addr){
    int hart_id = -1;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hart_id)
    );
    // ブロックの更新
  spm_wait(dma_id);
  uint64_t mac_req = mac_req_id;
  if (update_counter){
    uint64_t minor_idx = node_index % MINOR_COUNTER_COUNT; 
    uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
    uint64_t base_addr = child_spm_offset; // または start_level
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
        int start_level = -1;
        for (int l = 0; l < HEIGHT; l++) {
          dram_addr_t base = level_base[l+1];
          dram_addr_t next_base = (l < HEIGHT - 1) ? level_base[l+2] : UINT64_MAX;
          if (dram_addr >= base && dram_addr < next_base) {
            start_level = l;
            break;
          }
        }
        if (start_level == HEIGHT - 1){
          // リーフノードであるため、再暗号化処理を行う
          mac_req = reencryption_lazy(dram_addr, child_spm_offset );
        } else {
          // tag再計算
          mac_req = recalc_tag_lazy(dram_addr, child_spm_offset, start_level, node_index);
        }
        over_flow_count += 1;
    } else {
        new_minor_val = current_minor_val + 1;
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
  }
  mac_init(mac_req,hart_id, 0);
  if (parent_spm_offset == 0){
      mac_buffer_set(0, dma_id,hart_id);
      mac_update(0,63,hart_id);
  } else {
      uint64_t start_bit = 64 + (node_index / MINOR_COUNTER_COUNT) % MINOR_COUNTER_COUNT * MINOR_COUNTER_WIDTH;
      mac_buffer_set(parent_spm_offset, dma_id,hart_id);
      mac_update(0,63,hart_id);
      mac_update(start_bit, start_bit + (MINOR_COUNTER_WIDTH - 1),hart_id);
  }
  mac_buffer_set(child_spm_offset, dma_id,hart_id);
  mac_update(0, 447,hart_id);
  mac_input_core(dram_addr,hart_id);
  mac_digest(child_spm_offset + 56,dma_id,hart_id);
}

static inline void evicted_node_update(dram_addr_t old_addr, spm_offset_t old_spm) {
    int hartid;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hartid)
    );
  int v_level = -1; // Victimのレベル (0=Root)
  dram_addr_t v_level_base_addr = 0;

  for (int l = 0; l < HEIGHT; l++) {
    dram_addr_t base = level_base[l+1];
    if (l < HEIGHT - 1){
      dram_addr_t next_base = level_base[l+2];
      if (old_addr >= base && old_addr < next_base){
          v_level = l;
          v_level_base_addr = base;
          break;
      }
    } else {
      v_level = l;
      v_level_base_addr = base;
    }
  }
  // 何個めのブロックか
  dram_addr_t v_index = (old_addr - (v_level_base_addr))/ 64 * MINOR_COUNTER_COUNT;
  uint64_t path_indecis[HEIGHT] = {0};
  spm_offset_t spm_offset_array[HEIGHT] = {0};
  dram_addr_t dram_addr_array[HEIGHT] = {0};
  dma_id_t wait_dma_id[HEIGHT] = {0};
  bool loaded[HEIGHT] = {0};
  index_t way_index = 0;
  long load_start_index = 0;
  path_indecis[v_level] = v_index;
  dram_addr_array[v_level] = old_addr;
  spm_offset_array[v_level] = old_spm;
  dma_id_t tmp_id = global_dma_id;
  wait_dma_id[v_level] = tmp_id;
  for(long i = v_level - 1; i>=0;i--){
      uint64_t index = v_index >> (ARTY_LOG2 * (v_level - i));
      path_indecis[i] = index;
      dram_addr_t dram_addr = index / MINOR_COUNTER_COUNT * 64 + level_base[i+1];
      dram_addr_array[i] = dram_addr;
      light_tag_info_t info = light_tag_check(dram_addr);
      if (info.hit){
        long set_index = get_cache_tree_set_index(dram_addr);
        way_index = info.way;
        spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way_index);
        update_lru_on_access(set_index, way_index);
        clearParentUpdated(set_index, way_index);
        set_block_dirty(set_index, way_index);
        wait_dma_id[i] = global_dma_id;
        spm_offset_array[i] = spm_offset;
        load_start_index = i + 1;
        break;
      } else {
        long idx = find_temp_entry(dram_addr);
        spm_offset_t spm_offset;
        if (idx < 0){
          spm_offset = pop_temp_buffer();
          idx = alloc_temp_entry(dram_addr, spm_offset);
          dirty_temp_entry_by_index(idx);
          global_dma_id += 1;
          uint64_t tmp_id = global_dma_id;
          spm_copy_to_local(dram_addr, spm_offset,  tmp_id);
          loaded[i] = true;
          spm_offset_array[i] = spm_offset;
          wait_dma_id[i] = tmp_id;
        } else {
          spm_offset = get_temp_spm_offset(idx);
          dirty_temp_entry_by_index(idx);
          wait_dma_id[i] = global_dma_id;
          spm_offset_array[i] = spm_offset;
        }
      }
  }
AFTER_PATH_CHECK_EVICTION:
  uint64_t verify_end = read_instret();
  uint64_t mac_req_id = 0;
  // v_levelからキャッシュヒットしたところまでを検証
  for (long i = v_level-1;i>=load_start_index;i--){
    spm_offset_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    dma_id_t need_id = (i == 0) ? wait_dma_id[0] : wait_dma_id[i-1];
    mac_req_id = global_mac_req_id;
  #ifdef DUMP
    lock_print();
    printf("Core %d Verification during eviction height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, i, spm_offset_array[i], parent_spm, path_indecis[i], need_id);
    printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[i], mac_req_id);
        // printf("  parent dram_addr=%016llx\n", (i == 0) ? 0 : dram_addr_array[i-1]);
    unlock_print();
  #endif
    verify_one_height_lazy(spm_offset_array[i], parent_spm, path_indecis[i], mac_req_id,need_id, dram_addr_array[i]);
    global_mac_req_id += 1;
  }
  if (mac_req_id > 0){
    mac_wait(mac_req_id, hartid);
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
    if (current_minor_val == MINOR_COUNTER_MASK) {
      // 一旦何もしない
    } else {
        uint64_t new_minor_val = current_minor_val + 1;
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
  }
  // 木の更新：ルートからv_levelまで降りていく
  for (uint64_t i=load_start_index;i<=v_level;i++){
    spm_offset_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    dma_id_t need_id = (i == 0) ? wait_dma_id[0] : wait_dma_id[i-1];
    mac_req_id = global_mac_req_id;
    #ifdef DUMP
    lock_print();
    printf("Core %d Update during eviction height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, i, spm_offset_array[i], parent_spm, path_indecis[i], need_id);
    printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[i], mac_req_id);
        // printf("  parent dram_addr=%016llx\n", (i == 0) ? 0 : dram_addr_array[i-1]);
    unlock_print();
    #endif
    if (i == v_level){
      // 最後はカウンター更新なし
      update_one_height_lazy(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], false,mac_req_id, wait_dma_id[i], dram_addr_array[i]);
    } else {
      update_one_height_lazy(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], true,mac_req_id, wait_dma_id[i], dram_addr_array[i]);
    }
    global_mac_req_id += 1;
  }
  if (mac_req_id > 0){
    mac_wait(mac_req_id, hartid);
  }
  // temp領域の解放
  for (int i = v_level - 1;i>=load_start_index;i--){
    dram_addr_t dram_addr = dram_addr_array[i];
    long idx = find_temp_entry(dram_addr);
    if (idx == -1){
        printf("Error: temp entry still exists for addr=%016llx\n", dram_addr);
        exit(1);
    }
    spm_offset_t temp_spm = get_temp_spm_offset(idx);
    if (loaded[i]){
      spm_write_back(temp_spm, dram_addr,  0);
      long ret = push_temp_buffer(temp_spm);
      if (ret != 0){
        printf("Error: invalidate temp entry failed for addr=%016llx idx=%ld\n", dram_addr,idx);
        exit(1);
      }
      invalidate_temp_entry_by_index(idx);
    }
  }
  return;
}

static inline void swapp_dram_addr(dram_addr_t dram_addr,bool is_leaf){
  int hartid;
  asm volatile(
      "csrr %0, mhartid"
      : "=r"(hartid)
  );
  long idx = find_temp_entry(dram_addr);
  if (idx < 0){
    return;
  }
  spm_offset_t temp_spm = get_temp_spm_offset(idx);
  index_t set_index = get_cache_tree_set_index(dram_addr);
  light_tag_info_t light_info = light_tag_check_set(set_index, dram_addr);
  if (light_info.way < 0){
      light_info.way = get_victim_way(set_index);
  } else {
      set_block_valid(set_index, light_info.way);
  }
  spm_offset_t old_spm = get_cache_block_spm_offset(set_index, light_info.way);
  bool mac_updated = is_mac_updated(set_index, light_info.way);
  bool temp_dirty = is_dirty_temp_entry_by_index(idx);
  dram_addr_t old_dram_addr = get_block_addr(set_index, light_info.way);
  bool cache_dirty = is_block_dirty(set_index, light_info.way);
  swapp_temp_cache(dram_addr, temp_spm, temp_dirty, light_info.way);
  long ret = invalidate_temp_entry_by_index(idx);
  if (is_leaf && temp_dirty){
    clearParentUpdated(set_index, light_info.way);
  } else {
    setParentUpdated(set_index, light_info.way);
  }
  asm volatile("mac_update_tag:");
  if (!mac_updated){
    evicted_node_update(old_dram_addr, old_spm);
    // spm_write_back(old_spm, old_dram_addr,  0);
  } 
  if (cache_dirty){
    spm_write_back(old_spm, old_dram_addr,  0);
  }
  ret = push_temp_buffer(old_spm);
  #ifdef DUMP
  lock_print();
  printf("Core %d swapping cache block addr=%016llx spm_offset %lx S:%ld W:%ld old spm %lx\n",hartid, dram_addr, temp_spm, set_index, light_info.way, old_spm);
  unlock_print();
  #endif
  return;
}


void Authentication(dram_addr_t request_addr, uint32_t req_id){
  // データのコピー
  uint64_t start_time = read_instret();
  // HEIGHT-1がリーフ、0が高さ1
  uint64_t path_indecis[HEIGHT];
  spm_offset_t spm_offset_array[HEIGHT];
  dram_addr_t dram_addr_array[HEIGHT];
  long hit_index = HEIGHT;
  dma_id_t wait_dma_id[HEIGHT];
  index_t way_index = 0;
  // パス上のノードのタグチェックを行う
  uint64_t tag_check_start = read_instret();
  uint64_t index = (request_addr - PROTECTION_BASE) / 64;
  for(uint64_t i=0; i<HEIGHT; ++i){
      path_indecis[i] = index;
      dram_addr_t dram_addr = index / MINOR_COUNTER_COUNT * 64 + level_base[HEIGHT - i];
      index /= MINOR_COUNTER_COUNT;
      dram_addr_array[i] = dram_addr;
      long set_index = get_cache_tree_set_index(dram_addr);
      light_tag_info_t info = light_tag_check_set(set_index, dram_addr);
      if (info.hit){
        hit_index = i;
        spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, info.way);
        update_lru_on_access(set_index, info.way);
        spm_offset_array[i] = spm_offset;
        way_index = info.way;
        wait_dma_id[i] = global_dma_id;
        if (i == 0){
          set_block_dirty(set_index, way_index);
          clearParentUpdated(set_index, way_index);
        }
        break;
      } else {
        global_dma_id += 1;
        wait_dma_id[i] = global_dma_id;
        spm_offset_t spm_offset = pop_temp_buffer();
        spm_offset_array[i] = spm_offset;
        long temp_idx = alloc_temp_entry(dram_addr, spm_offset);
        spm_copy_to_local(dram_addr, spm_offset, global_dma_id);
        if (i == 0){
          dirty_temp_entry_by_index(temp_idx);
        }
      }
  }
  uint64_t tag_check_end = read_instret();
  uint64_t verify_start = read_instret();
  uint64_t mac_req_id = 0;
  for (long i = 0;i<hit_index;i++){
    spm_offset_t parent_spm = (i == HEIGHT - 1) ? 0 : spm_offset_array[i+1];
    dma_id_t need_id = (i == HEIGHT - 1) ? wait_dma_id[HEIGHT - 1] : wait_dma_id[i+1];
    mac_req_id = global_mac_req_id;
    verify_one_height_lazy(spm_offset_array[i], parent_spm, path_indecis[i], mac_req_id,need_id, dram_addr_array[i]);
    global_mac_req_id += 1;
  }
  // 一時的なルートノードのアップデート
  if (mac_req_id > 0){
    mac_wait(mac_req_id,0);
  }
  uint64_t verify_end = read_instret();
  uint64_t update_start = read_instret();
  // リーフのみを更新
  uint64_t major_counter = spm_ld64(spm_offset_array[0]);
  uint64_t minor_idx = path_indecis[0] % MINOR_COUNTER_COUNT; 
  uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
  uint64_t base_addr = spm_offset_array[0]; // または start_level
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
      reencryption_lazy(dram_addr_array[0], spm_offset_array[0]);
      over_flow_count += 1;
      major_counter += 1;
      minor_counter_value = 0;
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
  uint64_t update_end = read_instret();
  uint64_t set_seed_s = read_instret();
  set_seed(major_counter, minor_counter_value, request_addr);
  uint64_t set_seed_e = read_instret();
  uint64_t datamac_dma = read_instret();
  dram_addr_t datamacblock_addr = get_datamacblock_addr(request_addr);
  index_t set_index = get_cache_mac_index(datamacblock_addr);
  light_tag_info_t light_info = light_tag_check_set(set_index, datamacblock_addr);
  spm_offset_t spm_offset;
  dma_id_t tag_id = global_dma_id;
  bool cache_dirty = false;
  if (light_info.hit){
    spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
    set_block_dirty(set_index, light_info.way);
  } else {
    global_dma_id += 1;
    tag_id = global_dma_id;
    if (light_info.way == -1){
      light_info.way = get_victim_way(set_index);
      bool dirty = is_block_dirty(set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      if (dirty){
        cache_dirty = true;
        dram_addr_t old_block_addr = get_block_addr(set_index, light_info.way);
        spm_write_back(spm_offset, old_block_addr, 0);
      }
    } else {
      set_block_valid(set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    }
    spm_copy_to_local(datamacblock_addr, spm_offset, tag_id);
    set_block_addr(set_index, light_info.way, datamacblock_addr);
    set_block_dirty(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
  }
  uint64_t datamac_dma_e = read_instret();
  uint64_t xor_start_ = read_instret();
  while(AES_START_REG);
  xor_start(true, false,req_id,DATA_SPM_OFFSET);
  uint64_t xor_end = read_instret();
  // --- 手順3: MAC計算 ---
  uint64_t mac_start = read_instret();
  mac_init(global_mac_req_id,0,1);
  mac_buffer_set(DATA_SPM_OFFSET, tag_id,0); 
  mac_update(0, 511,0);
  mac_buffer_set(spm_offset_array[0], tag_id,0);
  mac_update(0,63,0);
  mac_update(global_bit_offset, global_bit_offset + (MINOR_COUNTER_WIDTH - 1),0);
  mac_input_core(request_addr,0);
  mac_digest(spm_offset + ((request_addr - PROTECTION_BASE) / 64) % 8 * 8, tag_id,0);
  uint64_t mac_end = read_instret();
  uint64_t write_back_s = read_instret();
  spm_write_back(DATA_SPM_OFFSET, request_addr, 0);
  uint64_t write_back_e = read_instret();
  uint64_t response_start = read_instret();
  axim_write_return(req_id);
  mac_wait(global_mac_req_id,0);
  global_mac_req_id += 1;
  uint64_t response_end = read_instret();
    // スワップ
  // for (long i = 0;i<hit_index;i++){
  //   dram_addr_t dram_addr = dram_addr_array[i];
  //   bool is_leaf = (i == 0);
  //   swapp_dram_addr(dram_addr,is_leaf);
  // }
  uint64_t swap_start = read_instret();
  for (uint64_t i = 0;i<hit_index;i++){
    dram_addr_t dram_addr = dram_addr_array[i];
    long idx = find_temp_entry(dram_addr);
    spm_offset_t temp_spm = spm_offset_array[i];
    index_t set_index = get_cache_tree_set_index(dram_addr);
    light_tag_info_t light_info = light_tag_check_set(set_index, dram_addr);
    if (light_info.way < 0){
        light_info.way = get_victim_way(set_index);
    } else {
        set_block_valid(set_index, light_info.way);
    }
    spm_offset_t old_spm = get_cache_block_spm_offset(set_index, light_info.way);
    bool mac_updated = is_mac_updated(set_index, light_info.way);
    bool temp_dirty = is_dirty_temp_entry_by_index(idx);
    dram_addr_t old_dram_addr = get_block_addr(set_index, light_info.way);
    bool cache_dirty = is_block_dirty(set_index, light_info.way);
    swapp_temp_cache(dram_addr, temp_spm, temp_dirty, light_info.way);
    invalidate_temp_entry_by_index(idx);
    if (i == 0 && temp_dirty){
      clearParentUpdated(set_index, light_info.way);
    } else {
      setParentUpdated(set_index, light_info.way);
    }
    if (!mac_updated){
      evicted_node_update(old_dram_addr, old_spm);
    } 
    if (cache_dirty){
      spm_write_back(old_spm, old_dram_addr,  0);
    }
    push_temp_buffer(old_spm);
  }
  uint64_t swap_end = read_instret();
  if (1){
    printf("Authentication req_id %d instret summary:\n", req_id);
    printf("  Total time: %llu\n", swap_end - start_time);
    printf("  Tag check time: %llu\n", tag_check_end - tag_check_start);
    printf("  Verification time: %llu\n", verify_end - verify_start);
    printf("  Update time: %llu\n", update_end - update_start);
    printf("  Set seed time: %llu\n", set_seed_e - set_seed_s);
    printf("  Data MAC DMA time: %llu\n", datamac_dma_e - datamac_dma);
    printf("  XOR time: %llu\n", xor_end - xor_start_);
    printf("  MAC time: %llu\n", mac_end - mac_start);
    printf("  Write back time: %llu\n", write_back_e - write_back_s);
    printf("  Response time: %llu\n", response_end - response_start);
    printf("  Swap time: %llu\n", swap_end - swap_start);
  }
}


void Verification(dram_addr_t request_addr, uint64_t req_id){
  if (req_id > 600){
    exit(1);
  }
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
      break;
    } else {
      global_dma_id += 1;
      wait_dma_id[i] = global_dma_id;
      spm_offset_t spm_offset = pop_temp_buffer();
      spm_offset_array[i] = spm_offset;
      alloc_temp_entry(dram_addr, spm_offset);
      spm_copy_to_local(dram_addr, spm_offset, global_dma_id);
    }
  }
  uint64_t tag_path_check_e = read_instret();
  // SPMに当該MACブロックがあるかを確認。なければコピー。
  uint64_t datamac_dma_s = read_instret();
  dram_addr_t datamacblock_addr = get_datamacblock_addr(request_addr);
  index_t set_index = get_cache_set_index(datamacblock_addr);
  dma_id_t tag_id = global_dma_id;
  spm_offset_t spm_offset;
  light_tag_info_t light_info = light_tag_check(datamacblock_addr);
  bool cache_dirty = false;
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
        cache_dirty = true;
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
  uint64_t datamac_dma_e = read_instret();
  // exit(1);
  uint64_t verify_s = read_instret();
  uint64_t mac_req_id = 0;
  for (uint64_t i = 0;i<hit_index;i++){
    mac_req_id = global_mac_req_id;
    if (i == HEIGHT - 1){
      verify_one_height_lazy_root(spm_offset_array[i], global_mac_req_id, wait_dma_id[HEIGHT - 1], dram_addr_array[i]);
      v_i = v_i / MINOR_COUNTER_COUNT;
    } else {
      verify_one_height_lazy(spm_offset_array[i], spm_offset_array[i+1], v_i, global_mac_req_id, wait_dma_id[i+1], dram_addr_array[i]);
    }
    global_mac_req_id += 1;
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
  uint64_t counter_ext_s = read_instret();
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
  uint64_t counter_ext_e = read_instret();
  set_seed(major_counter, minor_counter_value, request_addr);
  uint64_t set_seed_e = read_instret();
  printf("counter read instret=%llu\n", counter_ext_e - counter_ext_s);
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
  uint64_t xor_s = read_instret();
  while(AES_START_REG);
  uint64_t data_wait_s = read_instret();
  spm_wait(data_id);
  uint64_t data_wait_e = read_instret();
  xor_start(false, true,req_id,DATA_SPM_OFFSET);
  uint64_t xor_e = read_instret();
  uint64_t response_s = read_instret();
  uint64_t mac_wait_s = read_instret();
  mac_wait(global_mac_req_id,0);
  uint64_t mac_wait_e = read_instret();
  global_mac_req_id += 1;
  axim_read_return(req_id);
  uint64_t response_e = read_instret();
  uint64_t start_swapp_time = read_instret();
  for (uint64_t i = 0;i<hit_index;i++){
    dram_addr_t dram_addr = dram_addr_array[i];
    long idx = find_temp_entry(dram_addr);
    spm_offset_t temp_spm = spm_offset_array[i];
    index_t set_index = get_cache_tree_set_index(dram_addr);
    light_tag_info_t light_info = light_tag_check_set(set_index, dram_addr);
    if (light_info.way < 0){
        light_info.way = get_victim_way(set_index);
    } else {
        set_block_valid(set_index, light_info.way);
    }
    spm_offset_t old_spm = get_cache_block_spm_offset(set_index, light_info.way);
    bool mac_updated = is_mac_updated(set_index, light_info.way);
    bool temp_dirty = is_dirty_temp_entry_by_index(idx);
    dram_addr_t old_dram_addr = get_block_addr(set_index, light_info.way);
    bool cache_dirty = is_block_dirty(set_index, light_info.way);
    swapp_temp_cache(dram_addr, temp_spm, temp_dirty, light_info.way);
    invalidate_temp_entry_by_index(idx);
    if (i == 0 && temp_dirty){
      clearParentUpdated(set_index, light_info.way);
    } else {
      setParentUpdated(set_index, light_info.way);
    }
    if (!mac_updated){
      evicted_node_update(old_dram_addr, old_spm);
    } 
    if (cache_dirty){
      spm_write_back(old_spm, old_dram_addr,  0);
    }
    push_temp_buffer(old_spm);
  }
  uint64_t swapp_end_time = read_instret();
  if (1){
    printf("Total instret time %d\n", swapp_end_time - start_time);
    printf("  tag check time %d\n", tag_path_check_e - tag_path_check_s);
    printf("  verify time %d verify level %d\n", verify_e - verify_s, hit_index);
    printf("  mac cache hit %d dirty %d ", light_info.hit, cache_dirty);
    printf("  wait dma time %d\n", wait_e - wait_s);
    printf("  set seed time %d\n", set_seed_e - set_seed_s); 
    printf("  load mac time %d\n", datamac_dma_e - datamac_dma_s);
    printf("  mac compute time %d\n", datamac_e - datamac_s);
    printf("  xor time %d\n", xor_e - xor_s);
    printf("  response time %d\n", response_e - response_s);
    printf("  data wait time %d\n", data_wait_e - data_wait_s);
    printf("  mac wait time %d\n", mac_wait_e - mac_wait_s);
    printf("  overflow count %d\n", over_flow_count);
    printf("  swapp total time %d\n", swapp_end_time - start_swapp_time);
  }
  exit(1);
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