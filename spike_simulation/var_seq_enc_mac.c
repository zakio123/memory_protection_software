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

// マイナーカウンターがオーバーフローした時の復号化+再暗号化処理
void Authentication(dram_addr_t request_addr, uint32_t req_id){
  // データのコピー
  // HEIGHT-1がリーフ、0が高さ1
  dma_id_t counter_id = 0;
  spm_offset_t counter_spm_offset = 0;
  long index = (request_addr - PROTECTION_BASE) / 64;
  dram_addr_t counter_dram_addr = level_base[HEIGHT] + index / MINOR_COUNTER_COUNT * 64;
  index_t way_index = 0;
  // パス上のノードのタグチェックを行う
  index_t counter_set = get_cache_tree_set_index(counter_dram_addr);
  light_tag_info_t counter_info = light_tag_check_set(counter_set, counter_dram_addr);
  counter_id = global_dma_id;
  if (counter_info.hit){
    counter_spm_offset = get_cache_block_spm_offset(counter_set, counter_info.way);
    update_lru_on_access(counter_set, counter_info.way);
    set_block_dirty(counter_set, counter_info.way);
  } else {
    global_dma_id += 1;
    counter_id = global_dma_id;
    way_index = get_victim_way(counter_set);
    counter_spm_offset = get_cache_block_spm_offset(counter_set, way_index);
    bool dirty = is_block_dirty(counter_set, way_index);
    if (dirty){
      dram_addr_t old_block_addr = get_block_addr(counter_set, way_index);
      spm_write_back(counter_spm_offset, old_block_addr, 0);
    }
    spm_copy_to_local(counter_dram_addr, counter_spm_offset, counter_id);
    set_block_addr(counter_set, way_index, counter_dram_addr);
    clear_block_dirty(counter_set, way_index);
    update_lru_on_access(counter_set, way_index);
  }
  // uint64_t counter_id = data_id;
  uint64_t major_counter = spm_ld64(counter_spm_offset);
  uint64_t minor_idx = index % MINOR_COUNTER_COUNT; 
  uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
  uint64_t word_offset_bytes = (global_bit_offset / 64) * 8;
  uint64_t local_bit_offset  = global_bit_offset % 64;
  // 2. データの読み出し（Read-Modify-Writeのため、周辺ビットも含めて読む）
  uint64_t word1 = spm_ld64(counter_spm_offset + word_offset_bytes);
  uint64_t word2 = 0;
  bool is_split = (local_bit_offset + MINOR_COUNTER_WIDTH > 64);
  // またいでいる場合は次のワードも読む
  if (is_split) {
      word2 = spm_ld64(counter_spm_offset + word_offset_bytes + 8);
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
        // リーフノードであるため、再暗号化処理を行う
      global_mac_req_id = reencryption_lazy(counter_dram_addr, counter_spm_offset);
      new_minor_val = 0;
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
  }
  set_seed(major_counter, new_minor_val, request_addr);
  dram_addr_t datamacblock_addr = DATA_TAG_BASE + (((request_addr - PROTECTION_BASE) / (64 * 8))) * 64;
  index_t set_index = get_cache_mac_index(datamacblock_addr);
  light_tag_info_t light_info = light_tag_check_set(set_index, datamacblock_addr);
  spm_offset_t spm_offset;
  dma_id_t tag_id = global_dma_id;
  if (light_info.hit){
    spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
  } else {
    global_dma_id += 1;
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
    set_block_addr(set_index, light_info.way, datamacblock_addr);
    set_block_dirty(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
  }
  while(AES_START_REG);
  xor_start(true, false,req_id,DATA_SPM_OFFSET);
  // --- 手順3: MAC計算 ---
  // mac_req_id += 1;
  // mac_req_id = global_mac_req_id;
  mac_init(global_mac_req_id,0,1);
  mac_buffer_set(DATA_SPM_OFFSET, tag_id,0); 
  mac_update(0, 511,0);
  mac_buffer_set(counter_spm_offset, counter_id,0);
  mac_update(0,63,0);
  mac_update(global_bit_offset, global_bit_offset + (MINOR_COUNTER_WIDTH - 1),0);
  mac_input_core(request_addr,0);
  mac_digest(spm_offset + ((request_addr - PROTECTION_BASE) / 64) % 8 * 8, tag_id,0);
  set_block_dirty(set_index, light_info.way);
  spm_write_back(DATA_SPM_OFFSET, request_addr, 0);
  axim_write_return(req_id);
  mac_wait(global_mac_req_id,0);
  global_mac_req_id += 1;
}


void Verification(dram_addr_t request_addr, uint64_t req_id){
  uint64_t start_time = read_instret();
  global_dma_id += 1;
  dma_id_t data_id = global_dma_id;
  spm_copy_to_local(request_addr, DATA_SPM_OFFSET, data_id);
  spm_offset_t counter_spm_offset = 0;
  index_t index = (request_addr - PROTECTION_BASE) / 64;
  dram_addr_t counter_addr = level_base[HEIGHT] + index / MINOR_COUNTER_COUNT * 64;
  uint64_t tag_path_check_s = read_instret();
  index_t counter_set = get_cache_tree_set_index(counter_addr);
  light_tag_info_t counter_info = light_tag_check_set(counter_set, counter_addr);
  dma_id_t counter_id = global_dma_id;
  if (counter_info.hit){
    counter_spm_offset = get_cache_block_spm_offset(counter_set, counter_info.way);
    update_lru_on_access(counter_set, counter_info.way);
  } else {
    global_dma_id += 1;
    counter_id = global_dma_id;
    if (counter_info.way < 0){
      counter_info.way = get_victim_way(counter_set);
      counter_spm_offset = get_cache_block_spm_offset(counter_set, counter_info.way);
      bool dirty = is_block_dirty(counter_set, counter_info.way);
      if (dirty){
        dram_addr_t old_block_addr = get_block_addr(counter_set, counter_info.way);
        spm_write_back(counter_spm_offset, old_block_addr, 0);
      }
    } else {
      set_block_valid(counter_set, counter_info.way);
      counter_spm_offset = get_cache_block_spm_offset(counter_set, counter_info.way);
    }
    spm_copy_to_local(counter_addr, counter_spm_offset, counter_id);
    set_block_addr(counter_set, counter_info.way, counter_addr);
    clear_block_dirty(counter_set, counter_info.way);
    update_lru_on_access(counter_set, counter_info.way);
  }
  uint64_t tag_path_check_e = read_instret();
  uint64_t datamac_dma_s = read_instret();
  dram_addr_t datamacblock_addr = get_datamacblock_addr(request_addr);
  index_t mac_set_index = get_cache_set_index(datamacblock_addr);
  dma_id_t tag_id = global_dma_id;
  spm_offset_t spm_offset;
  light_tag_info_t light_info = light_tag_check(datamacblock_addr);
  if (light_info.hit){
    spm_offset = get_cache_block_spm_offset(mac_set_index, light_info.way);
    update_lru_on_access(mac_set_index, light_info.way);
  } else {
    tag_id += 1;
    global_dma_id += 1;
    if (light_info.way == -1){
      light_info.way = get_victim_way(mac_set_index);
      spm_offset = get_cache_block_spm_offset(mac_set_index, light_info.way);
      bool dirty = is_block_dirty(mac_set_index, light_info.way);
      if (dirty){
        dram_addr_t old_block_addr = get_block_addr(mac_set_index, light_info.way);
        spm_write_back(spm_offset, old_block_addr, 0);
      }
    } else {
      set_block_valid(mac_set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(mac_set_index, light_info.way);
    }
    spm_copy_to_local(datamacblock_addr, spm_offset, tag_id);
    set_block_addr(mac_set_index, light_info.way, datamacblock_addr);
    clear_block_dirty(mac_set_index, light_info.way);
    update_lru_on_access(mac_set_index, light_info.way);
  }
  uint64_t datamac_dma_e = read_instret();
  uint64_t wait_s = read_instret();
  if (counter_info.hit == false){
    spm_wait(counter_id);  
  }
  uint64_t wait_e = read_instret();
  uint64_t set_seed_s = read_instret();
  uint64_t major_counter = spm_ld64(counter_spm_offset);
  // 1. 対象となるマイナーカウンターのインデックスを計算
  uint64_t minor_idx = (request_addr / 64) % MINOR_COUNTER_COUNT;
  uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
  uint64_t word_offset_bytes = (global_bit_offset / 64) * 8; // 8バイト単位のオフセット
  uint64_t local_bit_offset  = global_bit_offset % 64;       // 64bitワード内での開始ビット
  uint64_t raw_data = spm_ld64(counter_spm_offset + word_offset_bytes);
  uint64_t extracted_val = raw_data >> local_bit_offset;
  if (local_bit_offset + MINOR_COUNTER_WIDTH > 64) {
      uint64_t next_data = spm_ld64(counter_spm_offset + word_offset_bytes + 8);
      // はみ出した分（上位ビット）を結合
      // (64 - local_bit_offset) は、1つ目のワードに残っていたビット数
      extracted_val |= (next_data << (64 - local_bit_offset));
  }
  // 6. ビットマスクを生成して不要な上位ビットを切り落とす;
  uint16_t minor_counter_value = extracted_val & MINOR_COUNTER_MASK;
  // 結果の使用
  set_seed(major_counter, minor_counter_value, request_addr);
  uint64_t set_seed_e = read_instret();
  uint64_t datamac_s = read_instret();
  mac_init(global_mac_req_id,0,1);
  mac_buffer_set(DATA_SPM_OFFSET,data_id,0);
  mac_update(0, 511,0);
  mac_buffer_set(counter_spm_offset,counter_id,0);
  mac_update(0,63,0);
  mac_update(global_bit_offset, global_bit_offset + (MINOR_COUNTER_WIDTH - 1),0);
  mac_input_core(request_addr,0);
  spm_offset_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
  mac_result_compare(spm_offset + dmac_byte_offset, tag_id,0);
  uint64_t datamac_e = read_instret();
  uint64_t response_s = read_instret();
  while(AES_START_REG);
  uint64_t data_wait_s = read_instret();
  spm_wait(data_id);
  uint64_t data_wait_e = read_instret();
  xor_start(false, true,req_id,DATA_SPM_OFFSET);
  uint64_t mac_wait_s = read_instret();
  mac_wait(global_mac_req_id,0);
  uint64_t mac_wait_e = read_instret();
  global_mac_req_id += 1;
  axim_read_return(req_id);
  uint64_t response_e = read_instret();
  uint64_t swapp_end_time = read_instret();
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