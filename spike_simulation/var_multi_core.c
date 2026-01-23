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
#include "addr_util.h"
#include "util.h"
#include "config.h"
#include "cache_controll.h"
#include "sec_operation.h"
#include "lock.h"

volatile bool init_done = false;

volatile int push_count = 0;
volatile int pop_count = 0;

void Authentication(dram_addr_t request_addr, uint32_t req_id, int hartid){
  #ifdef DUMP
  lock_print();
  printf("Core %d Authentication called for addr=%016llx req_id=%d\n", hartid, request_addr, req_id);
  unlock_print();
  #endif
  // データのコピー
  uint64_t start_time = read_instret();
  // HEIGHT-1がリーフ、0が高さ1
  spm_offset_t spm_offset_array[HEIGHT];
  dram_addr_t dram_addr_array[HEIGHT];
  uint64_t hit_index = HEIGHT;
  dma_id_t wait_dma_id[HEIGHT];
  index_t way_index = 0;
  // パス上のノードのタグチェックを行う
  bool skip_check = false;
  uint64_t verify_start = read_instret();
  uint64_t v_i = (request_addr - PROTECTION_BASE) / 64;
  uint64_t index = v_i;
  bool temp_hit = false;
  // i =0 の時のみループの外で行う
  index = index / MINOR_COUNTER_COUNT;
  dram_addr_t dram_addr = index * 64 + level_base[HEIGHT];
  dram_addr_array[0] = dram_addr;
  long leaf_set_index = get_cache_tree_set_index(dram_addr);
  while(1){
    lock_tree(leaf_set_index);
    light_tag_info_t info = light_tag_check_set(leaf_set_index,dram_addr);
    if (info.hit){
      spm_offset_t spm_offset = get_cache_block_spm_offset(leaf_set_index, info.way);
      bool suc = acquire_write_block(spm_offset); 
      if (suc){
        update_lru_on_access(leaf_set_index, info.way);
        clearParentUpdated(leaf_set_index, info.way);
        unlock_tree(leaf_set_index);
        set_block_dirty(leaf_set_index, info.way);
        wait_dma_id[0] = __atomic_load_n(&global_dma_id, __ATOMIC_ACQUIRE);
        hit_index = 0;
        spm_offset_array[0] = spm_offset;
        goto AFTER_PATH_CHECK_AUTH;
      } else {
        unlock_tree(leaf_set_index);
        for (int k = 0; k < 20; k++){
          __asm__ volatile ("nop");
        }
      }
    } else {
      long idx = find_temp_entry(dram_addr);
      spm_offset_t spm_offset;
      if (idx < 0){
        spm_offset = pop_temp_buffer();
        if (spm_offset < 0 || spm_offset >= DRAM_ADDR_OFFSET_BASE){
          lock_print();
          printf("Error: No free temp buffer during auth addr=%016llx spm_offset=%016llx\n", dram_addr,spm_offset);
          unlock_print();
          exit(1);
        }
        idx = alloc_temp_entry(dram_addr, spm_offset);
        bool suc = acquire_write_block(spm_offset);
        unlock_tree(leaf_set_index);
        dirty_temp_entry_by_index(idx);
        uint64_t tmp_id = __sync_add_and_fetch(&global_dma_id, 1);
        spm_copy_to_local_id(dram_addr, spm_offset, tmp_id, hartid);
        spm_offset_array[0] = spm_offset;
        wait_dma_id[0] = tmp_id;
        break;
      } else {
        skip_check = true;
        spm_offset = get_temp_spm_offset(idx);
        bool suc = acquire_write_block(spm_offset);
        if (suc){
          dirty_temp_entry_by_index(idx);
          unlock_tree(leaf_set_index);
          temp_hit = true;
          hit_index = 0;
          wait_dma_id[0] = __atomic_load_n(&global_dma_id, __ATOMIC_ACQUIRE);
          spm_offset_array[0] = spm_offset;
          goto AFTER_PATH_CHECK_AUTH;
        } else {
          unlock_tree(leaf_set_index);
          for (int k = 0; k < 10; k++){
            __asm__ volatile ("nop");
          }
        }
      }
    }
  }
  for(uint64_t i=1; i<HEIGHT; ++i){
      index = index / MINOR_COUNTER_COUNT;
      dram_addr_t dram_addr = index * 64 + level_base[HEIGHT - i];
      dram_addr_array[i] = dram_addr;
      long set_index = get_cache_tree_set_index(dram_addr);
      while(1){
        lock_tree(set_index);
        light_tag_info_t info = light_tag_check_set(set_index,dram_addr);
        if (info.hit){
          spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, info.way);
          bool suc = acquire_read_block(spm_offset); 
          if (suc){
            update_lru_on_access(set_index, info.way);
            unlock_tree(set_index);
            wait_dma_id[i] = __atomic_load_n(&global_dma_id, __ATOMIC_ACQUIRE);
            hit_index = i;
            spm_offset_array[i] = spm_offset;
            goto AFTER_PATH_CHECK_AUTH;
          } else {
            unlock_tree(set_index);
            for (int k = 0; k < 20; k++){
              __asm__ volatile ("nop");
            }
          }
        } else {
          long idx = find_temp_entry(dram_addr);
          spm_offset_t spm_offset;
          if (idx < 0){
            spm_offset = pop_temp_buffer();
            // if (spm_offset < 0 || spm_offset >= DRAM_ADDR_OFFSET_BASE){
            //   lock_print();
            //   printf("Error: No free temp buffer during auth addr=%016llx spm_offset=%016llx\n", dram_addr,spm_offset);
            //   unlock_print();
            //   exit(1);
            // }
            idx = alloc_temp_entry(dram_addr, spm_offset);
            bool suc = acquire_read_block(spm_offset);
            unlock_tree(set_index);
            uint64_t tmp_id = __sync_add_and_fetch(&global_dma_id, 1);
            spm_copy_to_local_id(dram_addr, spm_offset, tmp_id, hartid);
            spm_offset_array[i] = spm_offset;
            wait_dma_id[i] = tmp_id;
            break;
          } else {
            spm_offset = get_temp_spm_offset(idx);
            bool suc = acquire_read_block(spm_offset);
            if (suc){
              unlock_tree(set_index);
              temp_hit = true;
              hit_index = i;
              wait_dma_id[i] = __atomic_load_n(&global_dma_id, __ATOMIC_ACQUIRE);
              spm_offset_array[i] = spm_offset;
              goto AFTER_PATH_CHECK_AUTH;
            } else {
              unlock_tree(set_index);
              for (int k = 0; k < 10; k++){
                __asm__ volatile ("nop");
              }
            }
          }
        }
      }
  }
AFTER_PATH_CHECK_AUTH:
  uint64_t mac_req_id = 0;
  if (!skip_check){
    for (uint64_t i = 0;i<hit_index;i++){
      spm_offset_t parent_spm = (i == HEIGHT - 1) ? 0 : spm_offset_array[i+1];
      dma_id_t need_id = (i == HEIGHT - 1) ? wait_dma_id[HEIGHT - 1] : wait_dma_id[i+1];
      mac_req_id = __sync_fetch_and_add(&global_mac_req_id, 1);
      #ifdef DUMP
      lock_print();
      printf("Core %d Verification during authen height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, i, spm_offset_array[i], parent_spm, v_i, need_id);
      printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[i], mac_req_id);
      // printf("  parent dram_addr=%016llx\n", (j == 0) ? 0 : dram_addr_array[j-1]);
      unlock_print();
      #endif
      verify_one_height(spm_offset_array[i], parent_spm, v_i, mac_req_id,need_id, dram_addr_array[i]);
      v_i = v_i >> ARTY_LOG2;
    }
  }
  uint64_t verify_end = read_instret();
  dram_addr_t datamacblock_addr = DATA_TAG_BASE + (((request_addr - PROTECTION_BASE) / (64 * 8))) * 64;
  long set_index = get_cache_mac_index(datamacblock_addr);
  spm_offset_t spm_offset;
  dma_id_t tag_id;
  light_tag_info_t light_info;
  bool found_in_cache = false;
  bool dirty_in_cache = false;
  // 【変更】Data MAC探索は lock_spm
  lock_spm(set_index);
  light_info = light_tag_check_set(set_index, datamacblock_addr);
  if (light_info.hit){
    spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
    set_block_dirty(set_index, light_info.way);
    found_in_cache = true;
    unlock_spm(set_index); // SPMロック解除
    tag_id = __atomic_load_n(&global_dma_id, __ATOMIC_ACQUIRE);
  } else {
    dram_addr_t old_block_addr = 0;
    bool cache_dirty = false;
    if (light_info.way == -1){
      light_info.way = get_victim_way(set_index);
      cache_dirty = is_block_dirty(set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      if (cache_dirty){
        dirty_in_cache = true;
        old_block_addr = get_block_addr(set_index, light_info.way);
        spm_write_back_id(spm_offset, old_block_addr,  0, hartid);
      }
    } else {
      set_block_valid(set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    }
    set_block_dirty(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
    set_block_addr(set_index, light_info.way, datamacblock_addr);
    // メタデータ更新完了、DMA転送へ
    unlock_spm(set_index);
    tag_id = __sync_add_and_fetch(&global_dma_id, 1);
    spm_copy_to_local_id(datamacblock_addr, spm_offset,  tag_id, hartid);
  }
  // 一時的なルートノードのアップデート
  if (mac_req_id > 0){
    mac_wait(mac_req_id, hartid);
  }
  uint64_t start_level = 0;
  uint64_t base_addr = spm_offset_array[start_level]; // または start_level
  uint64_t major_counter = spm_ld64(base_addr);
  uint64_t minor_idx = (request_addr / 64) % MINOR_COUNTER_COUNT; 
  uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
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
      // 何もしない
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
  #ifdef DUMP
  lock_print();
  printf("Core %d Minor counter update at leaf node for addr=%016llx : spm offset %016llx\n", hartid, dram_addr_array[HEIGHT-1], base_addr);
  unlock_print();
  #endif
  // if (request_addr == 0x1eced5340 || request_addr == 0x1d61980c0 || request_addr == 0x212a9aa40 || request_addr == 0x23ded5600 || request_addr == 0x1c20e4100 || request_addr == 0x112dde540) {
  //   lock_print();
  //   printf("Debug stop at auth for addr=%016llx req_id=%d\n", request_addr, req_id);
  //   printf("  major_counter=%016llx minor_counter_value=%04x\n", major_counter, minor_counter_value);
  //   unlock_print();
  // }
  lock_xor();
  set_seed(major_counter, minor_counter_value, request_addr);
  while(AES_START_REG);
  xor_start(true, false,req_id,DATA_SPM_OFFSET + hartid * 64);
  unlock_xor();
  // --- 手順3: MAC計算 ---
  mac_req_id = __sync_fetch_and_add(&global_mac_req_id, 1);
  #ifdef DUMP
  lock_print();
  printf("Core %d MAC calculation during auth for addr=%016llx req_id=%d counter offset=%016llx mac_offset = %016llx mac_req_id = %d\n", hartid, datamacblock_addr, req_id,spm_offset_array[0],spm_offset, mac_req_id);
  printf(" cache hit %d dirty in cache %d\n", found_in_cache ? 1 : 0, dirty_in_cache ? 1 : 0);
  unlock_print();
  #endif
  
  mac_init(mac_req_id, hartid, 1);
  mac_buffer_set(DATA_SPM_OFFSET + hartid * 64, tag_id, hartid); 
  mac_update(0, 511, hartid);
  mac_buffer_set(spm_offset_array[0], tag_id, hartid);
  mac_update(0,63, hartid);
  mac_update(global_bit_offset, global_bit_offset + MINOR_COUNTER_WIDTH - 1, hartid);
  mac_input_core(request_addr, hartid);
  mac_digest(spm_offset + ((request_addr - PROTECTION_BASE) / 64) % 8 * 8, tag_id, hartid);
  spm_write_back_id(DATA_SPM_OFFSET + hartid * 64, request_addr,  0, hartid);
  axim_write_return(req_id);
  mac_wait(mac_req_id, hartid);
  for (uint64_t i = 0;i<=hit_index && i < HEIGHT;i++){
    spm_offset_t spm = spm_offset_array[i];
    // if (spm < 0 || spm >= DRAM_ADDR_OFFSET_BASE){
    //     lock_print();
    //     printf("Error: Invalid spm offset during authentication release addr=%016llx spm_offset=%016llx index=%llu\n", dram_addr_array[i], spm,i);
    //     unlock_print();
    //     exit(1);
    // }
    if (i == 0){
      release_write_block(spm);
    } else {
      release_read_block(spm);
    }
  }
  // キャッシュ領域の解放
  // lock_tree(set_index);
  // unlock_tree(set_index);
  for (uint64_t i = 0;i<hit_index;i++){
    dram_addr_t dram_addr = dram_addr_array[i];
    bool is_leaf = (i == 0) ? true : false;
    swapp_dram_addr(dram_addr,is_leaf,true);
  }
  if (temp_hit){
    spm_offset_t spm = spm_offset_array[hit_index];
    bool swappa = swappable_block(spm);
    if (swappa){
      bool is_leaf = (hit_index == 0) ? true : false;
      dram_addr_t dram_addr = dram_addr_array[hit_index];
      swapp_dram_addr(dram_addr, is_leaf, true);
    }
  }
}
#define ACQUIRE_LOCK_WITH_PROFILE(lock_f, counter_var) do { \
    uint64_t _start = read_instret();                       \
    lock_f;                                                 \
    uint64_t _end = read_instret();                         \
    (counter_var) += (_end - _start);                       \
} while(0)
void Verification(dram_addr_t request_addr, uint64_t req_id, int hartid){
  // ロック取得にかかる命令数を計るマクロ
  #ifdef DUMP
  lock_print();
  printf("Core %d Verification called for addr=%016llx req_id=%llu\n", hartid, request_addr, req_id);
  unlock_print();
  #endif
  uint64_t lock_counter_tree = 0;
  uint64_t lock_counter_spm = 0;
  uint64_t lock_counter_xor = 0;
  uint64_t mac_wait_counter = 0;
  uint64_t start_time = read_instret();
  spm_offset_t spm_offset_array[HEIGHT];
  dram_addr_t dram_addr_array[HEIGHT];
  long hit_index = HEIGHT;
  dma_id_t wait_dma_id[HEIGHT];
  // データのコピー
  dma_id_t data_id = __sync_add_and_fetch(&global_dma_id, 1);
  spm_copy_to_local_id(request_addr, DATA_SPM_OFFSET + hartid * 64, data_id, hartid);
  uint64_t tag_path_check_s = read_instret();
  uint64_t index = (request_addr - PROTECTION_BASE) / 64;
  uint64_t v_i = index;
  uint64_t minor_idx = index % MINOR_COUNTER_COUNT;
  bool temp_hit_stop = false;
  long set_index;
path_check_start:
  for(long i = 0; i<HEIGHT; i++){
      index = index / MINOR_COUNTER_COUNT;
      dram_addr_t dram_addr = index * 64 + level_base[HEIGHT - i];
      dram_addr_array[i] = dram_addr;
      set_index = get_cache_tree_set_index(dram_addr);
      while(1){
        // lock_tree(set_index);
        ACQUIRE_LOCK_WITH_PROFILE(lock_tree(set_index), lock_counter_tree);
        light_tag_info_t info = light_tag_check_set(set_index, dram_addr);  
        if (info.hit){
          index_t way_index = info.way;
          spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way_index);
          bool suc = acquire_read_block(spm_offset);
          if (suc){
            update_lru_on_access(set_index, way_index);
            unlock_tree(set_index);
            wait_dma_id[i] = __atomic_load_n(&global_dma_id, __ATOMIC_ACQUIRE);
            spm_offset_array[i] = spm_offset;
            hit_index = i;
            goto AFTER_PATH_CHECK_VERIFY;
          } else {
            unlock_tree(set_index);
            for (int k = 0; k < 20; k++){
              __asm__ volatile ("nop");
            }
          }
        } else {
          long idx = find_temp_entry(dram_addr);
          spm_offset_t spm_offset;
          if (idx < 0){
            spm_offset = pop_temp_buffer();
            idx = alloc_temp_entry(dram_addr, spm_offset);
            acquire_read_block(spm_offset);
            unlock_tree(set_index);
            uint64_t tmp_id = __sync_add_and_fetch(&global_dma_id, 1);
            spm_copy_to_local_id(dram_addr, spm_offset,  tmp_id, hartid);
            spm_offset_array[i] = spm_offset;
            wait_dma_id[i] = tmp_id;
            break;
          } else {
            spm_offset = get_temp_spm_offset(idx);
            bool suc = acquire_read_block(spm_offset);
            if (suc){
              unlock_tree(set_index);
              wait_dma_id[i] = __atomic_load_n(&global_dma_id, __ATOMIC_ACQUIRE);
              spm_offset_array[i] = spm_offset;
              temp_hit_stop = true;
              hit_index = i;
              goto AFTER_PATH_CHECK_VERIFY;
            } else {
              unlock_tree(set_index);
              for (int k = 0; k < 10; k++){
                __asm__ volatile ("nop");
              }
            }
          }
        }
      }
  }
AFTER_PATH_CHECK_VERIFY:
  uint64_t mac_req_id = 0;
  uint64_t tag_path_check_e = read_instret();
  uint64_t tree_s = read_instret();
  for (long i = 0;i<hit_index;i++){
    spm_offset_t parent_spm;
    dma_id_t need_id;
    if (i == HEIGHT - 1){
      parent_spm = 0;
      need_id = wait_dma_id[HEIGHT - 1];
    } else {
      parent_spm = spm_offset_array[i+1];
      need_id = wait_dma_id[i+1];
    }
    mac_req_id = __sync_fetch_and_add(&global_mac_req_id, 1);
    #ifdef DUMP
      lock_print();
      printf("Core %d Verification height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, i, spm_offset_array[i], parent_spm, v_i, need_id);
      printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[i], mac_req_id);
      unlock_print();
    #endif
    verify_one_height(spm_offset_array[i], parent_spm, v_i, mac_req_id,need_id, dram_addr_array[i]);
    v_i = v_i >> ARTY_LOG2;
  }
  uint64_t tree_e = read_instret();
  uint64_t datamac_dma_s = read_instret();
MAC_TAG_CHECK:
  dram_addr_t datamacblock_addr = get_datamacblock_addr(request_addr);
  set_index = get_cache_mac_index(datamacblock_addr);
  spm_offset_t mac_spm_offset;
  dma_id_t tag_id;
  light_tag_info_t light_info;
  bool found_in_cache = false;
  bool dirty_in_cache = false;
  // uint64_t spm_counter = 0;
  // lock_spm(set_index);
  ACQUIRE_LOCK_WITH_PROFILE(lock_spm(set_index), lock_counter_spm);
  light_info = light_tag_check_set(set_index,datamacblock_addr);
  if (light_info.hit){
    mac_spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
    unlock_spm(set_index); // SPMロック解除
    found_in_cache = true;
    tag_id = __atomic_load_n(&global_dma_id, __ATOMIC_ACQUIRE);
  } else {
    bool cache_dirty = false;
    dram_addr_t old_block_addr = 0;
    if (light_info.way < 0){
      light_info.way = get_victim_way(set_index);
      cache_dirty = is_block_dirty(set_index, light_info.way);
      mac_spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      if (cache_dirty){
        dirty_in_cache = true;
        old_block_addr = get_block_addr(set_index, light_info.way);
        spm_write_back_id(mac_spm_offset, old_block_addr,  0, hartid);
      }
    } else {
      set_block_valid(set_index, light_info.way);
      mac_spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    }
    clear_block_dirty(set_index, light_info.way);
    set_block_addr(set_index, light_info.way, datamacblock_addr);
    update_lru_on_access(set_index, light_info.way);
    // メタデータ更新完了、DMA転送へ
    unlock_spm(set_index);
    tag_id = __sync_add_and_fetch(&global_dma_id, 1);
    spm_copy_to_local_id(datamacblock_addr, mac_spm_offset,  tag_id, hartid);
  }
  uint64_t datamac_dma_e = read_instret();
  // uint64_t verify_s = read_instret();
  // 1. 対象となるマイナーカウンターのインデックスを計算
  // 2. データの開始位置（ビット単位）を計算
  spm_wait(wait_dma_id[0]);
  uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
  spm_offset_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
  uint64_t base_addr = spm_offset_array[0];
  dma_id_t wait_id = wait_dma_id[0];
  uint64_t major_counter = spm_ld64(base_addr);
  uint64_t word_offset_bytes = (global_bit_offset / 64) * 8; // 8バイト単位のオフセット
  uint64_t local_bit_offset  = global_bit_offset % 64;       // 64bitワード内での開始ビット
  // 4. 最初の64bitをロードしてシフト
  uint64_t raw_data = spm_ld64(base_addr + word_offset_bytes);
  uint64_t extracted_val = raw_data >> local_bit_offset;
  // 5. カウンターが64bit境界をまたぐか判定し、必要なら2回目のロードを行う
  if (local_bit_offset + MINOR_COUNTER_WIDTH > 64) {
      uint64_t next_data = spm_ld64(base_addr + word_offset_bytes + 8);
      // はみ出した分（上位ビット）を結合
      // (64 - local_bit_offset) は、1つ目のワードに残っていたビット数
      extracted_val |= (next_data << (64 - local_bit_offset));
  }
  // 6. ビットマスクを生成して不要な上位ビットを切り落とす;
  uint16_t minor_counter_value = extracted_val & MINOR_COUNTER_MASK;
  // lock_xor();
  ACQUIRE_LOCK_WITH_PROFILE(lock_xor(), lock_counter_xor);
  set_seed(major_counter, minor_counter_value, request_addr);
  mac_req_id = __sync_fetch_and_add(&global_mac_req_id, 1);
  #ifdef DUMP
  lock_print();
  printf("Core %d MAC calculation during veri for addr=%016llx req_id=%d counter offset=%016llx mac_offset = %016llx mac_req_id = %d\n", hartid, datamacblock_addr, req_id,spm_offset_array[0],mac_spm_offset, mac_req_id);
  printf(" cache hit %d dirty in cache %d\n", found_in_cache ? 1 : 0, dirty_in_cache ? 1 : 0);
  unlock_print();
  #endif
  mac_init(mac_req_id,hartid, 1);
  mac_buffer_set(DATA_SPM_OFFSET + hartid * 64,data_id,hartid);
  mac_update(0, 511,hartid);
  mac_buffer_set(base_addr,wait_id,hartid);
  mac_update(0,63,hartid);
  mac_update(global_bit_offset, global_bit_offset + MINOR_COUNTER_WIDTH - 1,hartid);
  mac_input_core(request_addr,hartid);
  mac_result_compare(mac_spm_offset + dmac_byte_offset, tag_id,hartid);
  // uint64_t verify_e = read_instret();
  // // uint64_t set_seed_s = read_instret();
  // uint64_t set_seed_e = read_instret();
  while(AES_START_REG);
  xor_start(false, true,req_id,DATA_SPM_OFFSET + hartid * 64);
  unlock_xor();
  uint64_t response_s = read_instret();
  ACQUIRE_LOCK_WITH_PROFILE(mac_wait(mac_req_id, hartid), mac_wait_counter);
  axim_read_return(req_id);
  uint64_t response_e = read_instret();
  uint64_t start_swapp_time = read_instret();
  for (long i = 0;i<=hit_index && i < HEIGHT;i++){
      spm_offset_t spm = spm_offset_array[i];
      // if (spm < 0 || spm >= DRAM_ADDR_OFFSET_BASE){
      //   lock_print();
      //   printf("Error: Invalid spm offset during verification release addr=%016llx spm_offset=%016llx\n", dram_addr_array[i], spm);
      //   unlock_print();
      //   exit(1);
      // }
      release_read_block(spm);
  }
  // swapp処理
  for (uint64_t i = 0;i<=hit_index;i++){
    dram_addr_t dram_addr = dram_addr_array[i];
    bool is_leaf = (i == 0) ? true : false;
    if (temp_hit_stop || i != hit_index){
      swapp_dram_addr(dram_addr,is_leaf,false);
    }
  }
  uint64_t end_swapp_time = read_instret();
  // if (req_id % 1000 == 999 || req_id % 1000 == 998){
  //   lock_print();
  //   printf("Core %d Verification breakdown (in instret)\n", hartid);
  //   printf("  request id: %d\n", req_id);
  //   printf("  hit index: %d\n", hit_index);
  //   printf("  Tag path check time: start %d end %d\n", tag_path_check_s, tag_path_check_e);
  //   printf("  Data MAC DMA time: start %d end %d\n", datamac_dma_s, datamac_dma_e);
  //   printf("  MAC Cache hit in cache: %d dirty in cache: %d\n", found_in_cache ? 1 : 0, dirty_in_cache ? 1 : 0);
  //   printf("  Tree MAC computation time: start %d end %d\n", tree_s, tree_e);
  //   // printf("  MAC verification time: start %d end %d\n", verify_s, verify_e);
  //   // printf("  Set seed time: start %d end %d\n", set_seed_s, set_seed_e);
  //   printf("  Response time: start %d end %d\n", response_s, response_e);
  //   printf("  Swapp time: start %d end %d\n", start_swapp_time, end_swapp_time);
  //   // printf("  MAC wait time: start %d end %d\n", mac_wait_s, mac_wait_e);
  //   printf("  Lock wait counts: tree %d spm %d xor %d\n", lock_counter_tree, lock_counter_spm, lock_counter_xor);
  //   printf("  MAC wait lock count: %d\n", mac_wait_counter);
  //   printf("  Total time: start %d end %d\n", start_time, end_swapp_time);
  //   // printf("  lock_wait_counter: %d\n", lock_counter);
  //   // printf("  spm_lock_wait_counter: %d\n", spm_counter);
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
    __atomic_store_n(&init_done, true, __ATOMIC_RELEASE);
  } else {
    lock_print();
    printf("Core %d waiting for initialization...\n", hart_id);
    unlock_print();
    SPM_SIZE_REG_2 = 64;
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
    // long set_index = get_cache_tree_set_index(addr);
    // printf("set_index %ld\n", set_index);
    // uint64_t s = read_instret();
    // lock_tree(set_index);
    // uint64_t e = read_instret();
    // uint64_t s_1 = read_instret();
    // lock_print();
    // uint64_t e_1 = read_instret();
    // printf("Core %d lock_tree instret before lock %llu after lock %llu diff %llu\n", hart_id, s, e, e - s);
    // printf("Core %d lock_print instret before lock %llu after lock %llu diff %llu\n", hart_id, s_1, e_1, e_1 - s_1);
    // unlock_print();
    // exit(1);
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