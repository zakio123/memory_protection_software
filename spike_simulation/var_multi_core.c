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
uint64_t global_mac_req_id = 0;
dma_id_t global_dma_id = 0;

dram_addr_t level_base[HEIGHT + 1] = {0};

volatile bool init_done = false;

volatile int push_count = 0;
volatile int pop_count = 0;


static inline void evicted_node_update(dram_addr_t old_addr, spm_offset_t old_spm) {
  // ---------------------------------------------------------
  // 1. Victimのレベル(階層)とインデックスを特定
  // ---------------------------------------------------------
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
  dram_addr_t v_index = (old_addr - (v_level_base_addr))/ 64 * 32;
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
  lock_dma();
  dma_id_t tmp_id = global_dma_id;
  wait_dma_id[v_level] = tmp_id;
  unlock_dma();
  for(long i = v_level - 1; i>=0;i--){
      uint64_t index = v_index >> (5 * (v_level - i));
      path_indecis[i] = index;
      dram_addr_t dram_addr = index / 32 * 64 + level_base[i+1];
      dram_addr_array[i] = dram_addr;
      while(1){
        lock_dma();
        light_tag_info_t info = light_tag_check(dram_addr);
        uint64_t tmp_id = global_dma_id;
        if (info.hit){
          long set_index = get_cache_tree_set_index(dram_addr);
          way_index = info.way;
          spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way_index);
          update_lru_on_access(set_index, way_index);
          if (acquire_write_block(spm_offset)){
            unlock_dma();
            spm_offset_array[i] = spm_offset;
            wait_dma_id[i] = tmp_id;
            load_start_index = i + 1;
            goto AFTER_PATH_CHECK_EVICTION;
          } else {
            unlock_dma();
          }
        } else {
          long idx = find_temp_entry(dram_addr);
          spm_offset_t spm_offset;
          if (idx == -1){
            spm_offset = pop_temp_buffer();
            if (swappable_block(spm_offset) == false){
              int hartid;
              asm volatile(
                  "csrr %0, mhartid"
                  : "=r"(hartid)
              );
              printf("Warning: evict non-swappable temp block used hartid=%d\n", hartid);
              exit(1);
            }
            __sync_fetch_and_add(&pop_count, 1);
            idx = alloc_temp_entry(dram_addr, spm_offset);
            tmp_id += 1;
            spm_copy_to_local(dram_addr, spm_offset, 64, tmp_id);
            loaded[i] = true;
          } else {
            spm_offset = get_temp_spm_offset(idx);
          }
          global_dma_id = tmp_id;
          if (acquire_write_block(spm_offset)){
            unlock_dma();
            wait_dma_id[i] = tmp_id; 
            spm_offset_array[i] = spm_offset;
            break;
          } else {
            unlock_dma();
          }
        }
      }
  }
  // ---------------------------------------------------------
AFTER_PATH_CHECK_EVICTION:
  uint64_t verify_end = read_instret();
  lock_mac();
  uint64_t mac_req_id;
  mac_req_id = global_mac_req_id;
  unlock_mac();
  int hartid;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hartid)
    );
  // v_levelからキャッシュヒットしたところまでを検証
  for (long i = v_level-1;i>=load_start_index;i--){
    spm_offset_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    dma_id_t need_id = (i == 0) ? wait_dma_id[0] : wait_dma_id[i-1];
    lock_mac();
    mac_req_id = global_mac_req_id;
    mac_req_id += 1;
    // lock_print();
    // printf("Core %d Verification during eviction height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, i, spm_offset_array[i], parent_spm, path_indecis[i], need_id);
    // printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[i], mac_req_id);
    // unlock_print();
    spm_sd64(DRAM_ADDR_OFFSET_BASE + (i + 1) * 8 + hartid * (1 + HEIGHT) * 8, dram_addr_array[i]);
    verify_one_height(spm_offset_array[i], parent_spm, path_indecis[i], mac_req_id,need_id, dram_addr_array[i], DRAM_ADDR_OFFSET_BASE + (i + 1) * 8 + hartid * (1 + HEIGHT) * 8);
    global_mac_req_id = mac_req_id;
    unlock_mac();
  }
  while(!mac_wait(mac_req_id));
  // printf("[Evict] Verification done.\n");
  // 一時的なルートノードのアップデート
  if (load_start_index == 0){
    // rootノードの更新
    uint64_t root = spm_ld64(0);
    root += 1;
    spm_sd64(0, root);
  } else {
    uint64_t start_level = load_start_index - 1;
    spm_offset_t spm_ = spm_offset_array[start_level];
    index_t set_index = get_cache_set_index(dram_addr_array[start_level]);
    lock_dma();
    clearParentUpdated(set_index, way_index);
    set_block_dirty(set_index, way_index);
    unlock_dma();
    uint64_t major_counter = spm_ld64(spm_);
    uint64_t minor_counter_byte_address = spm_ + 8 + (path_indecis[start_level] % 32) / 8 * 8;
    uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
    // ここから過去のminor counterを取り出す
    uint8_t minor_counter_value = (minor_counter >> ((path_indecis[start_level] % 8) * 8)) & 0xFF;
    uint8_t new_minor_counter = 0;
    if (minor_counter_value == 0xFF){
        // uint64_t new_major_counter = major_counter + 1;
        // spm_sd64(spm_offset_array[load_start_index - 1], new_major_counter);
        new_minor_counter = 0; 
    } else {
        new_minor_counter = minor_counter_value + 1;
    }
    uint64_t shift_amount = (path_indecis[start_level] % 8) * 8;
    uint64_t clear_mask = ~(0xFFULL << shift_amount);
    uint64_t cleared_minor_counter = minor_counter & clear_mask;
    uint64_t shifted_new_value = (new_minor_counter);
    shifted_new_value <<= shift_amount;
    uint64_t final_word = cleared_minor_counter | shifted_new_value;
    // 書き戻し
    spm_sd64(minor_counter_byte_address, final_word);
  }
  // 木の更新：ルートからv_levelまで降りていく
  for (uint64_t i=load_start_index;i<=v_level;i++){
    spm_offset_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    dma_id_t need_id = (i == 0) ? wait_dma_id[0] : wait_dma_id[i-1];
    lock_mac();
    mac_req_id = global_mac_req_id;
    mac_req_id += 1;
    // lock_print();
    // printf("Core %d Update during eviction height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, i, spm_offset_array[i], parent_spm, path_indecis[i], need_id);
    // printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[i], mac_req_id);
    // unlock_print();
    global_mac_req_id = mac_req_id;
    spm_sd64(DRAM_ADDR_OFFSET_BASE + (i + 1) * 8 + hartid * (1 + HEIGHT) * 8, dram_addr_array[i]);
    if (i == v_level){
      // 最後はカウンター更新なし
      update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], false,mac_req_id, wait_dma_id[i], dram_addr_array[i], DRAM_ADDR_OFFSET_BASE + (i + 1) * 8 + hartid * (1 + HEIGHT) * 8);
    } else {
      update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], true,mac_req_id, wait_dma_id[i], dram_addr_array[i], DRAM_ADDR_OFFSET_BASE + (i + 1) * 8 + hartid * (1 + HEIGHT) * 8);
    }
    unlock_mac();
    if (i < v_level){
      lock_dma();
      long idx = find_temp_entry(dram_addr_array[i]);
      if (idx == -1){
          printf("Error: not temp entry still exists for addr=%016llx\n", dram_addr_array[i]);
          exit(1);
      }
      dirty_temp_entry_by_index(idx);
      unlock_dma();
    }
  }
  while(!mac_wait(mac_req_id));
  lock_dma();
  // temp領域の解放
  for (int i = v_level - 1;i>=load_start_index;i--){
    dram_addr_t dram_addr = dram_addr_array[i];
    long idx = find_temp_entry(dram_addr);
    if (idx == -1){
        printf("Error: temp entry still exists for addr=%016llx\n", dram_addr);
        exit(1);
    }
    spm_offset_t temp_spm = get_temp_spm_offset(idx);
    release_write_block(temp_spm);
    bool swappable_temp = swappable_block(temp_spm);
    if (swappable_temp && loaded[i]){
      spm_write_back(temp_spm, dram_addr, 64, 0);
      long ret = push_temp_buffer(temp_spm);
      __sync_fetch_and_add(&push_count, 1);
      if (ret != 0){
        printf("Error: invalidate temp entry failed for addr=%016llx idx=%ld\n", dram_addr,idx);
        exit(1);
      }
      invalidate_temp_entry_by_index(idx);
    }
  }
  // キャッシュ領域の解放
  if (load_start_index != 0){
    spm_offset_t root_spm = spm_offset_array[load_start_index - 1];
    release_write_block(root_spm);
  }
  unlock_dma();
  return;
}

static inline void swapp_dram_addr(dram_addr_t dram_addr, bool is_write){
  int hartid;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hartid)
    );
  lock_dma();
  long idx = find_temp_entry(dram_addr);
  if (idx == -1){
    unlock_dma();
    return;
  }
  spm_offset_t temp_spm = get_temp_spm_offset(idx);
  bool swappable_temp = swappable_block(temp_spm);
  if (swappable_temp){
    light_tag_info_t light_info = light_tag_check(dram_addr);
    index_t set_index = get_cache_set_index(dram_addr);
    if (light_info.way == -1){
        light_info.way = get_victim_way(get_cache_set_index(dram_addr));
    } else {
        // valid化
        set_block_valid(set_index, light_info.way);
    }
    spm_offset_t old_spm = get_cache_block_spm_offset(set_index, light_info.way);
    bool swappable_cache = swappable_block(old_spm);
    if (swappable_cache){
      bool mac_updated = is_mac_updated(set_index, light_info.way);
      bool temp_dirty = is_dirty_temp_entry_by_index(idx);
      dram_addr_t old_dram_addr = get_block_addr(set_index, light_info.way);
      swapp_temp_cache(dram_addr, temp_spm, temp_dirty, light_info.way);
      long ret = invalidate_temp_entry_by_index(idx);
      setParentUpdated(set_index, light_info.way);
      if (!mac_updated){
        bool suc = acquire_write_block(old_spm);
        if (!suc){
          printf("Error: failed to acquire write block for addr=%016llx S:%ld W:%ld\n", old_dram_addr, set_index, light_info.way);
          exit(1);
        }
        long idx = alloc_temp_entry(old_dram_addr, old_spm);
        dirty_temp_entry_by_index(idx);
        unlock_dma();
        evicted_node_update(old_dram_addr, old_spm);
        lock_dma();
        release_write_block(old_spm);
        if (swappable_block(old_spm)){
          spm_write_back(old_spm, old_dram_addr, 64, 0);
          invalidate_temp_entry_by_index(idx);
          ret = push_temp_buffer(old_spm);
          __sync_fetch_and_add(&push_count, 1);
        }
      } else {
        spm_write_back(old_spm, old_dram_addr, 64, 0);
        ret = push_temp_buffer(old_spm);
        __sync_fetch_and_add(&push_count, 1);
      }
      // swapする
      if (ret != 0){
        int pop_counter = __atomic_load_n(&pop_count, __ATOMIC_ACQUIRE);
        int push_counter = __atomic_load_n(&push_count, __ATOMIC_ACQUIRE);
        printf("Error: push failed for swapping: addr=%016llx idx=%ld\n", dram_addr,idx);
        printf("  mac_updated=%d\n", mac_updated);
        printf("  push_count=%d, pop_count=%d\n", push_counter, pop_counter);
        exit(1);
      }
      // lock_print();
      // printf("Core %d swapping cache block addr=%016llx spm_offset %lx S:%ld W:%ld old spm %lx\n",hartid, dram_addr, temp_spm, set_index, light_info.way, old_spm);
      // unlock_print();
    } else {
      bool temp_dirty = is_dirty_temp_entry_by_index(idx);
      if (temp_dirty){
          spm_write_back(temp_spm, dram_addr, 64, 0);
      }
      invalidate_temp_entry_by_index(idx);
      long ret = push_temp_buffer(temp_spm);
      // lock_print();
      // printf("Core %d swapping cache block is non-swappable addr=%016llx spm_offset %lx S:%ld W:%ld\n", hartid, dram_addr, temp_spm, set_index, light_info.way);
      // unlock_print();
      __sync_fetch_and_add(&push_count, 1);
      if (ret != 0){
        printf("Error: push failed for  addr=%016llx idx=%ld\n", dram_addr,idx);
        exit(1);
      }
    }
  }
  unlock_dma();
  return;
}

void Authentication(dram_addr_t request_addr, uint32_t req_id, int hartid){
  // データのコピー
  uint64_t start_time = read_instret();
  // HEIGHT-1がリーフ、0が高さ1
  uint64_t mac_req_id = 0;
  uint64_t path_indecis[HEIGHT];
  spm_offset_t spm_offset_array[HEIGHT];
  dram_addr_t dram_addr_array[HEIGHT];
  uint64_t load_start_index = 0;
  dma_id_t wait_dma_id[HEIGHT];
  index_t way_index = 0;
  // パス上のノードのタグチェックを行う
  uint64_t verify_start = read_instret();
  for(uint64_t i=0; i<HEIGHT; ++i){
      uint64_t index = (request_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * i)));
      path_indecis[HEIGHT - 1 - i ] = index;
      dram_addr_t dram_addr = index / 32 * 64 + level_base[HEIGHT - i];
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
          bool pop_ = false;
          if (idx == -1){
            spm_offset = pop_temp_buffer();
            if (swappable_block(spm_offset) == false){
              printf("Warning: authen non-swappable temp block used hartid=%d\n", hartid);
              exit(1);
            }
            pop_ = true;
            __sync_fetch_and_add(&pop_count, 1);
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
    global_dma_id = tag_id;
    if (acquire_write_block(spm_offset)){
      set_block_dirty(set_index, light_info.way);
      unlock_dma();
      break;
    } else {
      unlock_dma();

    }
  }
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    long j = (HEIGHT + load_start_index) - 1 - i;
    spm_offset_t parent_spm = (j == 0) ? 0 : spm_offset_array[j-1];
    dma_id_t need_id = (j == 0) ? wait_dma_id[0] : wait_dma_id[j-1];
    lock_mac();
    mac_req_id = global_mac_req_id;
    mac_req_id += 1;
    // lock_print();
    // printf("Core %d Verification during authen height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, j, spm_offset_array[j], parent_spm, path_indecis[j], need_id);
    // printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[j], mac_req_id);
    // unlock_print();
    spm_sd64(DRAM_ADDR_OFFSET_BASE + (j + 1) * 8 + hartid * (1 + HEIGHT) * 8, dram_addr_array[j]);
    // mac_buffer_set(DRAM_ADDR_OFFSET_BASE + (j + 1) * 8 + hartid * (1 + HEIGHT), mac_req_id);
    verify_one_height(spm_offset_array[j], parent_spm, path_indecis[j], mac_req_id,need_id, dram_addr_array[j], DRAM_ADDR_OFFSET_BASE + (j + 1) * 8 + hartid * (1 + HEIGHT) * 8);
    global_mac_req_id = mac_req_id;
    unlock_mac();
  }
  // 一時的なルートノードのアップデート
  while(!mac_wait(mac_req_id));
  if (load_start_index == 0){
    // rootノードの更新
    uint64_t root = spm_ld64(0);
    root += 1;
    spm_sd64(0, root);
  } else {
    uint64_t start_level = load_start_index - 1;
    spm_offset_t spm_ = spm_offset_array[start_level];
    uint64_t major_counter = spm_ld64(spm_);
    uint64_t minor_counter_byte_address = spm_ + 8 + (path_indecis[start_level] % 32) / 8 * 8;
    uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
    // ここから過去のminor counterを取り出す
    uint8_t minor_counter_value = (minor_counter >> ((path_indecis[start_level] % 8) * 8)) & 0xFF;
    uint8_t new_minor_counter = 0;
    if (minor_counter_value == 0xFF){
        // uint64_t new_major_counter = major_counter + 1;
        // spm_sd64(spm_offset_array[load_start_index - 1], new_major_counter);
        new_minor_counter = 0; 
    } else {
        new_minor_counter = minor_counter_value + 1;
    }
    uint64_t shift_amount = (path_indecis[start_level] % 8) * 8;
    uint64_t clear_mask = ~(0xFFULL << shift_amount);
    uint64_t cleared_minor_counter = minor_counter & clear_mask;
    uint64_t shifted_new_value = (new_minor_counter);
    shifted_new_value <<= shift_amount;
    uint64_t final_word = cleared_minor_counter | shifted_new_value;
    // 書き戻し
    spm_sd64(minor_counter_byte_address, final_word);
  }
  // 木の更新：ルートから葉まで降りていく
  for (uint64_t i=load_start_index;i<HEIGHT;i++){
    spm_offset_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    dma_id_t need_id = (i == 0) ? wait_dma_id[0] : wait_dma_id[i-1];
    lock_mac();
    mac_req_id = global_mac_req_id;
    mac_req_id += 1;
    // lock_print();
    // printf("Core %d Update height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, i, spm_offset_array[i], parent_spm, path_indecis[i], need_id);
    // printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[i], mac_req_id);
    // unlock_print();
    // spm_sd64(DRAM_ADDR_OFFSET_BASE + (i + 1) * 8 + hartid * (1 + HEIGHT) * 8, dram_addr_array[i]);
    update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], true,mac_req_id, wait_dma_id[i], dram_addr_array[i], DRAM_ADDR_OFFSET_BASE + (i + 1) * 8 + hartid * (1 + HEIGHT) * 8);
    global_mac_req_id = mac_req_id;
    unlock_mac();
  }
  while(!mac_wait(mac_req_id));
  uint64_t major_counter;
  uint64_t minor_counter_byte_address;
  uint64_t minor_counter;
  uint8_t minor_counter_value;
  major_counter = spm_ld64(spm_offset_array[HEIGHT-1]);
  uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
  minor_counter_byte_address = spm_offset_array[HEIGHT-1] + (counter_bit_offset / 64) * 8;
  minor_counter = spm_ld64(minor_counter_byte_address);
  minor_counter_value = (minor_counter >> ((counter_bit_offset % 64))) & 0xFF;
  // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
  lock_xor();
  set_seed(major_counter, minor_counter_value, request_addr);
  while(AES_START_REG);
  xor_start(true, false,req_id,DATA_SPM_OFFSET + hartid * 64);
  unlock_xor();
  // --- 手順3: MAC計算 ---
  lock_mac();
  global_mac_req_id += 1;
  spm_sd64(DRAM_ADDR_OFFSET_BASE + hartid * (1 + HEIGHT) * 8, request_addr);
  mac_req_id = global_mac_req_id;
  mac_init(mac_req_id,true);
  mac_buffer_set(DATA_SPM_OFFSET + hartid * 64, tag_id); 
  mac_update(0, 511);
  mac_buffer_set(spm_offset_array[HEIGHT-1], tag_id);
  mac_update(0,63);
  mac_update(counter_bit_offset, counter_bit_offset + 7);
  mac_buffer_set(DRAM_ADDR_OFFSET_BASE + hartid * (1 + HEIGHT) * 8, tag_id);
  mac_update(0,63);
  mac_digest(spm_offset + ((request_addr - PROTECTION_BASE) / 64) % 8 * 8, tag_id);
  unlock_mac();
  lock_dma();
  spm_write_back(DATA_SPM_OFFSET + hartid * 64, request_addr, 64, 0);
  unlock_dma();
  while(!mac_wait(mac_req_id));
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
    swapp_dram_addr(dram_addr,true);
  }
}

void Verification(dram_addr_t request_addr, uint64_t req_id, int hartid){
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
  for(uint64_t i=0; i<HEIGHT; ++i){
      path_indecis[HEIGHT - 1 - i ] = index;
      dram_addr_t dram_addr = index / 32 * 64 + level_base[HEIGHT - i];
      dram_addr_array[HEIGHT - 1 - i] = dram_addr;
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
            spm_offset_array[HEIGHT - 1 - i] = spm_offset;
            wait_dma_id[HEIGHT - 1 - i] = tmp_id;
            load_start_index = HEIGHT - i;
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
          if (idx == -1){
            spm_offset = pop_temp_buffer();
            if (swappable_block(spm_offset) == false){
              printf("Warning: verify non-swappable temp block used hartid=%d\n", hartid);
              exit(1);
            }
            __sync_fetch_and_add(&pop_count, 1);
            idx = alloc_temp_entry(dram_addr, spm_offset);
            tmp_id += 1;
            spm_copy_to_local(dram_addr, spm_offset, 64, tmp_id);
          } else {
            spm_offset = get_temp_spm_offset(idx);
          }
          global_dma_id = tmp_id;
          if (acquire_read_block(spm_offset)){
            unlock_dma();
            wait_dma_id[HEIGHT - 1 - i] = tmp_id; 
            spm_offset_array[HEIGHT - 1 - i] = spm_offset;
            break;
          } else {
            unlock_dma();
            for (int k = 0; k < 20; k++){
              __asm__ volatile ("nop");
            }
          }
        }
      }
      index = index >> 5;
  }
AFTER_PATH_CHECK_VERIFY:
  uint64_t tag_path_check_e = read_instret();
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
      tag_id += 1;
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
      spm_copy_to_local(datamacblock_addr, spm_offset, 64, tag_id);
      set_block_addr(set_index, light_info.way, datamacblock_addr);
      update_lru_on_access(set_index, light_info.way);
    }
    global_dma_id = tag_id;
    if (acquire_read_block(spm_offset)){
      unlock_dma();
      break;
    } else {
      unlock_dma();
    }
  }
  uint64_t datamac_dma_e = read_instret();
  uint64_t verify_s = read_instret();
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    long j = (HEIGHT + load_start_index) - 1 - i;
    spm_offset_t parent_spm = (j == 0) ? 0 : spm_offset_array[j-1];
    dma_id_t need_id = (j == 0) ? wait_dma_id[0] : wait_dma_id[j-1];
    lock_mac();
    uint64_t mac_req_id = global_mac_req_id;
    mac_req_id += 1;
    // lock_print();
    // printf("Core %d Verification height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, j, spm_offset_array[j], parent_spm, path_indecis[j], need_id);
    // printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[j], mac_req_id);
    // unlock_print();
    spm_sd64(DRAM_ADDR_OFFSET_BASE + (j + 1) * 8 + hartid * (1 + HEIGHT) * 8, dram_addr_array[j]);
    verify_one_height(spm_offset_array[j], parent_spm, path_indecis[j], mac_req_id,need_id, dram_addr_array[j], DRAM_ADDR_OFFSET_BASE + (j + 1) * 8 + hartid * (1 + HEIGHT) * 8);
    global_mac_req_id = mac_req_id;
    unlock_mac();
  }
  uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
  spm_offset_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
  lock_mac();
  uint64_t mac_req_id = global_mac_req_id + 1;
  global_mac_req_id = mac_req_id;
  spm_sd64(DRAM_ADDR_OFFSET_BASE + hartid * (1 + HEIGHT) * 8, request_addr);
  mac_init(mac_req_id,true);
  mac_buffer_set(DATA_SPM_OFFSET + hartid * 64,data_id);
  mac_update(0, 511);
  mac_buffer_set(spm_offset_array[HEIGHT-1],wait_dma_id[HEIGHT-1]);
  mac_update(0,63);
  mac_update(counter_bit_offset, counter_bit_offset + 7);
  mac_buffer_set(DRAM_ADDR_OFFSET_BASE + hartid * (1 + HEIGHT) * 8, data_id);
  mac_update(0,63);
  mac_result_compare(spm_offset + dmac_byte_offset, tag_id);
  uint64_t verify_e = read_instret();
  unlock_mac();
  uint64_t wait_s = read_instret();
  dma_id_t wait_id = wait_dma_id[HEIGHT-1];
  spm_wait(wait_id);
  uint64_t wait_e = read_instret();
  uint64_t set_seed_s = read_instret();
  uint64_t major_counter = spm_ld64(spm_offset_array[HEIGHT-1]);
  uint64_t minor_counter = spm_ld64(spm_offset_array[HEIGHT-1] + (counter_bit_offset / 64) * 8);
  uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64) )) & 0xFF;
  lock_xor();
  set_seed(major_counter, minor_counter_value, request_addr);
  uint64_t set_seed_e = read_instret();
  uint64_t response_s = read_instret();
  while(AES_START_REG);
  spm_wait(data_id);
  xor_start(false, true,req_id,DATA_SPM_OFFSET + hartid * 64);
  unlock_xor();
  while(!mac_wait(mac_req_id));
  axim_read_return(req_id);
  uint64_t response_e = read_instret();
  // unlock_tree_read();
  uint64_t start_swapp_time = read_instret();
  // temp領域の解放
  lock_dma();
  // キャッシュ領域の解放
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
    swapp_dram_addr(dram_addr,false);
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