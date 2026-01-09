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
#include "lock.h"
#include "spm_rwlock.h"

dram_addr_t level_base[HEIGHT + 1] = {0};

volatile bool init_done = false;

volatile int push_count = 0;
volatile int pop_count = 0;


void Authentication(dram_addr_t request_addr, uint32_t req_id, int hartid){
  // lock_print();
  // printf("Core %d Authentication started for addr=%016llx req_id=%d\n", hartid, request_addr, req_id);
  // unlock_print();
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
  for(uint64_t i=0; i<HEIGHT; ++i){
      uint64_t index = (request_addr - PROTECTION_BASE) / (64 * (1ULL << (ARTY_LOG2 * i)));
      path_indecis[HEIGHT - 1 - i ] = index;
      dram_addr_t dram_addr = index / MINOR_COUNTER_COUNT * 64 + level_base[HEIGHT - i];
      dram_addr_array[HEIGHT - 1 - i] = dram_addr;
      long set_index = get_cache_tree_set_index(dram_addr);
      while(1){
        lock_dma();
        light_tag_info_t info = light_tag_check(dram_addr);
        dma_id_t tmp_id = global_dma_id;
        if (info.hit){
          spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, info.way);
          if (acquire_write_block(spm_offset)){
            update_lru_on_access(set_index, info.way);
            set_block_dirty(set_index, info.way);
            clearParentUpdated(set_index, info.way);
            unlock_dma();
            load_start_index = HEIGHT - i;
            spm_offset_array[HEIGHT - 1 - i] = spm_offset;
            way_index = info.way;
            wait_dma_id[HEIGHT - 1 - i] = tmp_id;
            goto AFTER_PATH_CHECK_AUTH;
          } else {
            unlock_dma();
            for (int k = 0; k < 20; k++){
              __asm__ volatile ("nop");
            }
          }
        } else {
          long idx = find_temp_entry(dram_addr);
          spm_offset_t spm_offset;
          // bool pop_ = false;
          if (idx == -1){
            spm_offset = pop_temp_buffer();
            if (swappable_block(spm_offset) == false){
              printf("Warning: authen non-swappable temp block used hartid=%d\n", hartid);
              exit(1);
            }
            // pop_ = true;
            // __sync_fetch_and_add(&pop_count, 1);
            idx = alloc_temp_entry(dram_addr, spm_offset);
            tmp_id += 1;
            spm_copy_to_local(dram_addr, spm_offset, 64, tmp_id);
          } else {
            spm_offset = get_temp_spm_offset(idx);
          }
          global_dma_id = tmp_id;
          if (acquire_write_block(spm_offset)){
            dirty_temp_entry_by_index(idx);
            unlock_dma();
            wait_dma_id[HEIGHT - 1 - i] = tmp_id;
            spm_offset_array[HEIGHT - 1 - i] = spm_offset;
            break;
          } else {
            unlock_dma();
            for (int k = 0; k < 10; k++){
              __asm__ volatile ("nop");
            }
          }
        }
      }
  }
AFTER_PATH_CHECK_AUTH:
  uint64_t verify_end = read_instret();
  dram_addr_t datamacblock_addr = DATA_TAG_BASE + (((request_addr - PROTECTION_BASE) / (64 * 8))) * 64;
  index_t set_index = get_cache_set_index(datamacblock_addr);
  spm_offset_t spm_offset;
  dma_id_t tag_id;
  light_tag_info_t light_info;
  while(1){
    lock_dma();
    tag_id = global_dma_id;
    light_info = light_tag_check(datamacblock_addr);
    if (light_info.hit){
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      update_lru_on_access(set_index, light_info.way);
    } else {
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
      global_dma_id += 1;
      tag_id = global_dma_id;
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
    if (acquire_write_block(spm_offset)){
      set_block_dirty(set_index, light_info.way);
      unlock_dma();
      break;
    } else {
      unlock_dma();
      for(int j = 0;j<20;j++){}
    }
  }
  uint64_t mac_req_id = 0;
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    long j = (HEIGHT + load_start_index) - 1 - i;
    spm_offset_t parent_spm = (j == 0) ? 0 : spm_offset_array[j-1];
    dma_id_t need_id = (j == 0) ? wait_dma_id[0] : wait_dma_id[j-1];
    // lock_mac();
    // global_mac_req_id += 1;
    mac_req_id = __sync_fetch_and_add(&global_mac_req_id, 1);
    //   global_mac_req_id += 1;
    // mac_req_id = global_mac_req_id;
    #ifdef DUMP
    lock_print();
    printf("Core %d Verification during authen height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, j, spm_offset_array[j], parent_spm, path_indecis[j], need_id);
    printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[j], mac_req_id);
    // printf("  parent dram_addr=%016llx\n", (j == 0) ? 0 : dram_addr_array[j-1]);
    unlock_print();
    #endif
    verify_one_height(spm_offset_array[j], parent_spm, path_indecis[j], mac_req_id,need_id, dram_addr_array[j]);
    // mac_wait(mac_req_id, 0);
    // unlock_mac();
  }
  // 一時的なルートノードのアップデート
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
        // オーバーフロー時の処理
        // printf("[Core FW] Minor counter overflow at level %llu for request_addr=%016llx\n", start_level, request_addr);
        // // pathのdram_addrとインデックスを表示
        // for (uint64_t lvl = start_level; lvl < HEIGHT; lvl++) {
        //     printf("  Level %llu: dram_addr=%016llx, index=%llu\n", lvl, dram_addr_array[lvl], path_indecis[lvl]);
        // }
        // exit(1);
        // if (start_level == HEIGHT - 1){
        //   // リーフノードであるため、再暗号化処理を行う
        //   tmp_id = reencrpytion(dram_addr_array[start_level], spm_offset_array[start_level], tmp_id);
        // } else {
        //   // tag再計算
        //   tmp_id = recalc_tag(dram_addr_array[start_level], spm_offset_array[start_level], tmp_id, start_level, path_indecis[start_level]);
        // }
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
  // 木の更新：ルートから葉まで降りていく
  for (uint64_t i=load_start_index;i<HEIGHT;i++){
    spm_offset_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    dma_id_t need_id = (i == 0) ? wait_dma_id[0] : wait_dma_id[i-1];
    // lock_mac();
    // global_mac_req_id += 1;
    mac_req_id = __sync_fetch_and_add(&global_mac_req_id, 1);
      // global_mac_req_id += 1;
  // mac_req_id = global_mac_req_id;
    // mac_req_id += 1;
    #ifdef DUMP
    lock_print();
    printf("Core %d Update height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, i, spm_offset_array[i], parent_spm, path_indecis[i], need_id);
    printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[i], mac_req_id);
    // printf("  parent dram_addr=%016llx\n", (i == 0) ? 0 : dram_addr_array[i-1]);
    unlock_print();
    #endif
    update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], true,mac_req_id, wait_dma_id[i], dram_addr_array[i]);
    // unlock_mac();
  }
  if (mac_req_id > 0){
    mac_wait(mac_req_id, hartid);
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
  // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
  lock_xor();
  set_seed(major_counter, minor_counter_value, request_addr);
  while(AES_START_REG);
  xor_start(true, false,req_id,DATA_SPM_OFFSET + hartid * 64);
  unlock_xor();
  // --- 手順3: MAC計算 ---
  // lock_mac();
  // global_mac_req_id += 1;
  mac_req_id = __sync_fetch_and_add(&global_mac_req_id, 1);
  //   global_mac_req_id += 1;
  // mac_req_id = global_mac_req_id;
  mac_init(mac_req_id, hartid, 1);
  mac_buffer_set(DATA_SPM_OFFSET + hartid * 64, tag_id, hartid); 
  mac_update(0, 511, hartid);
  mac_buffer_set(spm_offset_array[HEIGHT-1], tag_id, hartid);
  mac_update(0,63, hartid);
  mac_update(global_bit_offset, global_bit_offset + MINOR_COUNTER_WIDTH - 1, hartid);
  mac_input_core(request_addr, hartid);
  mac_digest(spm_offset + ((request_addr - PROTECTION_BASE) / 64) % 8 * 8, tag_id, hartid);
  // mac_wait(mac_req_id, hartid);
  // unlock_mac();
  lock_dma();
  spm_write_back(DATA_SPM_OFFSET + hartid * 64, request_addr, 64, 0);
  unlock_dma();
  mac_wait(mac_req_id, hartid);
  axim_write_return(req_id);
    // キャッシュ領域の解放
  lock_dma();
  release_write_block(spm_offset);
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    uint64_t j = HEIGHT + load_start_index - 1 - i;
    spm_offset_t spm = spm_offset_array[j];
    release_write_block(spm);
  }
  if (load_start_index != 0){
    spm_offset_t root_spm = spm_offset_array[load_start_index - 1];
    release_write_block(root_spm);
  }
  unlock_dma();
  // temp領域の解放
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    uint64_t j = (HEIGHT + load_start_index) - 1 - i;
    dram_addr_t dram_addr = dram_addr_array[j];
    swapp_dram_addr(dram_addr);
  }
}

void Verification(dram_addr_t request_addr, uint64_t req_id, int hartid){
  // lock_print();
  // printf("Core %d Verification started for addr=%016llx req_id=%llu\n", hartid, request_addr, req_id);
  // unlock_print();
  uint64_t start_time = read_instret();
  // lock_tree_read();
  uint64_t path_indecis[HEIGHT];
  spm_offset_t spm_offset_array[HEIGHT];
  dram_addr_t dram_addr_array[HEIGHT];
  uint64_t load_start_index = 0;
  dma_id_t wait_dma_id[HEIGHT];
  // データのコピー
  lock_dma();
  dma_id_t data_id = global_dma_id + 1;
  spm_copy_to_local(request_addr, DATA_SPM_OFFSET + hartid * 64, 64,data_id);
  global_dma_id = data_id;
  unlock_dma();
  uint64_t tag_path_check_s = read_instret();
  uint64_t index = (request_addr - PROTECTION_BASE) / 64;
  bool temp_hit_stop = false;
  for(long i= HEIGHT  - 1; i>=0; --i){
      path_indecis[i] = index;
      dram_addr_t dram_addr = index / MINOR_COUNTER_COUNT * 64 + level_base[i + 1];
      dram_addr_array[i] = dram_addr;
      while(1){
        lock_dma();
        light_tag_info_t info = light_tag_check(dram_addr);
        uint64_t tmp_id = global_dma_id;
        if (info.hit){
          long set_index = get_cache_tree_set_index(dram_addr);
          index_t way_index = info.way;
          spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way_index);
          update_lru_on_access(set_index, way_index);
          if (acquire_read_block(spm_offset)){
            unlock_dma();
            spm_offset_array[i] = spm_offset;
            wait_dma_id[i] = tmp_id;
            load_start_index = i+1;
            goto AFTER_PATH_CHECK_VERIFY;
          } else {
            unlock_dma();
            for (int k = 0; k < 20; k++){
              __asm__ volatile ("nop");
            }
          }
        } else {
          long idx = find_temp_entry(dram_addr);
          spm_offset_t spm_offset;
          bool hit = false;
          if (idx == -1){
            spm_offset = pop_temp_buffer();
            if (swappable_block(spm_offset) == false){
              printf("Warning: verify non-swappable temp block used hartid=%d\n", hartid);
              exit(1);
            }
            // __sync_fetch_and_add(&pop_count, 1);
            idx = alloc_temp_entry(dram_addr, spm_offset);
            tmp_id += 1;
            spm_copy_to_local(dram_addr, spm_offset, 64, tmp_id);
          } else {
            spm_offset = get_temp_spm_offset(idx);
            hit = true;
          }
          global_dma_id = tmp_id;
          if (acquire_read_block(spm_offset)){
            unlock_dma();
            wait_dma_id[i] = tmp_id; 
            spm_offset_array[i] = spm_offset;
            if (hit == true){
              load_start_index = i + 1;
              temp_hit_stop = true;
              goto AFTER_PATH_CHECK_VERIFY; 
            }
            break;
          } else {
            unlock_dma();
            if (hit == false){
              lock_print();
              printf("core error %d failed to acquire read block addr=%016llx\n", hartid, dram_addr);
              unlock_print();
              exit(1);
            }
            for (int k = 0; k < 20; k++){
              __asm__ volatile ("nop");
            }
          }
        }
      }
      index = index >> ARTY_LOG2;
  }
AFTER_PATH_CHECK_VERIFY:
  uint64_t tag_path_check_e = read_instret();
  uint64_t mac_req_id = 0;
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    long j = (HEIGHT + load_start_index) - 1 - i;
    spm_offset_t parent_spm = (j == 0) ? 0 : spm_offset_array[j-1];
    dma_id_t need_id = (j == 0) ? wait_dma_id[0] : wait_dma_id[j-1];
    // lock_mac();
    mac_req_id = __sync_fetch_and_add(&global_mac_req_id, 1);
      // global_mac_req_id += 1;
      // mac_req_id = global_mac_req_id;
    // global_mac_req_id += 1;
    #ifdef DUMP
    lock_print();
    printf("Core %d Verification height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, j, spm_offset_array[j], parent_spm, path_indecis[j], need_id);
    printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[j], mac_req_id);
    #endif
    // if (mac_req_id == 48371){
    //   // 親の子のデータを表示
    //   spm_wait(need_id);
    //   for (int i = 0;i<8;i++){
    //     uint64_t word = spm_ld64(parent_spm + i * 8);
    //     printf("    parent data[%d]=%016llx\n", i, word);
    //   }
    //   for (int i = 0;i<8;i++){
    //     uint64_t word = spm_ld64(spm_offset_array[j] + i * 8);
    //     printf("    current data[%d]=%016llx\n", i, word);
    //   }
    // }
    unlock_print();
    verify_one_height(spm_offset_array[j], parent_spm, path_indecis[j], mac_req_id,need_id, dram_addr_array[j]);
    // mac_wait(mac_req_id, 0);
    // unlock_mac();
  }
  uint64_t datamac_dma_s = read_instret();
  dram_addr_t datamacblock_addr = get_datamacblock_addr(request_addr);
  index_t set_index = get_cache_set_index(datamacblock_addr);
  spm_offset_t spm_offset;
  dma_id_t tag_id;
  light_tag_info_t light_info;
  while(1){
    lock_dma();
    tag_id = global_dma_id;
    light_info = light_tag_check(datamacblock_addr);
    if (light_info.hit){
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      update_lru_on_access(set_index, light_info.way);
    } else {
      // tag_id += 1;
      if (light_info.way == -1){
        light_info.way = get_victim_way(set_index);
        spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
        bool dirty = is_block_dirty(set_index, light_info.way);
        if (dirty){
          dram_addr_t old_block_addr = get_block_addr(set_index, light_info.way);
          spm_write_back(spm_offset, old_block_addr, 64, 0);
          clear_block_dirty(set_index, light_info.way);
        }
      } else {
        set_block_valid(set_index, light_info.way);
        spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      }
      global_dma_id += 1;
      tag_id = global_dma_id;
      spm_copy_to_local(datamacblock_addr, spm_offset, 64, tag_id);
      set_block_addr(set_index, light_info.way, datamacblock_addr);
      update_lru_on_access(set_index, light_info.way);
    }
    if (acquire_read_block(spm_offset)){
      unlock_dma();
      break;
    } else {
      unlock_dma();
      for(int j = 0;j<20;j++){}
    }
  }
  uint64_t datamac_dma_e = read_instret();
  uint64_t verify_s = read_instret();

      // 1. 対象となるマイナーカウンターのインデックスを計算
  uint64_t major_counter = spm_ld64(spm_offset_array[HEIGHT-1]);
  uint64_t minor_idx = (request_addr / 64) % MINOR_COUNTER_COUNT;
  // 2. データの開始位置（ビット単位）を計算
  uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);

  // uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
  spm_offset_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
  // lock_print();
  // printf("Core %d Verification MAC %d\n", hartid,tag_id);
  // unlock_print();
  // lock_mac();
  // global_mac_req_id += 1;
  // mac_req_id = global_mac_req_id;
  mac_req_id = __sync_fetch_and_add(&global_mac_req_id, 1);
  mac_init(mac_req_id,hartid, 1);
  mac_buffer_set(DATA_SPM_OFFSET + hartid * 64,data_id,hartid);
  mac_update(0, 511,hartid);
  mac_buffer_set(spm_offset_array[HEIGHT-1],wait_dma_id[HEIGHT-1],hartid);
  mac_update(0,63,hartid);
  mac_update(global_bit_offset, global_bit_offset + MINOR_COUNTER_WIDTH - 1,hartid);
  mac_input_core(request_addr,hartid);
  mac_result_compare(spm_offset + dmac_byte_offset, tag_id,hartid);
  uint64_t verify_e = read_instret();
  // mac_wait(mac_req_id,0);
  // unlock_mac();
  uint64_t wait_s = read_instret();
  dma_id_t wait_id = wait_dma_id[HEIGHT-1];
  spm_wait(wait_id);
  uint64_t wait_e = read_instret();
  uint64_t set_seed_s = read_instret();
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
  lock_xor();
  set_seed(major_counter, minor_counter_value, request_addr);
  uint64_t set_seed_e = read_instret();
  uint64_t response_s = read_instret();
  while(AES_START_REG);
  spm_wait(data_id);
  xor_start(false, true,req_id,DATA_SPM_OFFSET + hartid * 64);
  unlock_xor();
  mac_wait(mac_req_id, hartid);
  axim_read_return(req_id);
  uint64_t response_e = read_instret();
  // unlock_tree_read();
  uint64_t start_swapp_time = read_instret();
  // temp領域の解放
  // キャッシュ領域の解放
  lock_dma();
  release_read_block(spm_offset);
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    uint64_t j = HEIGHT + load_start_index - 1 - i;
    spm_offset_t spm = spm_offset_array[j];
    release_read_block(spm);
  }
  if (load_start_index != 0){
    spm_offset_t root_spm = spm_offset_array[load_start_index - 1];
    release_read_block(root_spm);
  }
  unlock_dma();
  // swapp処理
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    uint64_t j = HEIGHT + load_start_index - 1 - i;
    dram_addr_t dram_addr = dram_addr_array[j];
    swapp_dram_addr(dram_addr);
  }
  if (temp_hit_stop){
    dram_addr_t dram_addr = dram_addr_array[load_start_index - 1];
    swapp_dram_addr(dram_addr);
  }
  uint64_t end_swapp_time = read_instret();
  // if (req_id % 1000 == 999){
  //   lock_print();
  //   printf("Core %d Verification timing breakdown (in instret)\n", hartid);
  //   printf("  request id: %d\n", req_id);
  //   printf("  load start index: %d\n", load_start_index);
  //   printf("  Tag path check time: %d\n", tag_path_check_e - tag_path_check_s);
  //   printf("  MAC verification time: %d\n", verify_e - verify_s);
  //   printf("  DMA wait time: %d\n", wait_e - wait_s);
  //   printf("  Set seed time: %d\n", set_seed_e - set_seed_s);
  //   printf("  Response time: %d\n", response_e - response_s);
  //   printf("  Swapp time: %d\n", end_swapp_time - start_swapp_time);
  //   printf("  Total time: %d\n", end_swapp_time - start_time);
  //   unlock_print();
  // }
}

int main(void){
  // グローバル配列へのアクセスの比較
  // loadをいじる
  int hart_id = -1;
  asm volatile( //This function reads out a system register and put the ID of the core into the id variable
    "csrrs %0, 0xF14, zero" //CSSRS rd, mhartid, 0
    : "=r"(hart_id) //output
    : //input
    : //clobbered
  );
  bool instret_dump = false;
  if (hart_id == 0){
    SPM_SIZE_REG = 64;
    for (uint64_t i=0; i<512; i++){
      spm_sd64(i*8, 0); 
    }
    spm_sd64(0,1);
    init_cache_system();
    temp_system_init(CACHE_DATA_SPM_BASE + CACHE_SETS * CACHE_WAYS * 64);
    for (int i=0; i<HEIGHT+1; i++){
      level_base[i] = calculate_level_base_addr(i) + COUNTER_BASE;
    }
    // init_done = true;
    __atomic_store_n(&init_done, true, __ATOMIC_RELEASE);
  } else {
    lock_axim();
    printf("Core %d waiting for initialization...\n", hart_id);
    unlock_axim();

    while(1){
      bool done = __atomic_load_n(&init_done, __ATOMIC_ACQUIRE);
      if (done) break;
    }
  }

  int total = 0;
  while(1){
    lock_axim();
    for(;;){
      if(AXIM_STATUS_REG & 1) break; // リクエストが来るまで待つ
    }
    bool is_write = (AXIM_STATUS_REG & 2) != 0;
    dram_addr_t addr = AXIM_REQ_ADDR_REG;
    uint64_t req_id = AXIM_REQ_ID_REG;
    unlock_axim();
    if (total % 100 == 0 && hart_id == 0){
      instret_dump = true;
    } else {
      instret_dump = false;
    }
    if(is_write){
      Authentication(addr,req_id, hart_id);
    } else {
      Verification(addr,req_id, hart_id);
    }
  }
}