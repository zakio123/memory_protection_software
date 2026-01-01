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
    verify_one_height(spm_offset_array[i], parent_spm, path_indecis[i], mac_req_id,need_id);
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
    if (i == v_level){
      // 最後はカウンター更新なし
      update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], false,mac_req_id, wait_dma_id[i]);
    } else {
      update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], true,mac_req_id, wait_dma_id[i]);
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
  // int hartid;
  //   asm volatile(
  //       "csrr %0, mhartid"
  //       : "=r"(hartid)
  //   );
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
      bool cache_dirty = is_block_dirty(set_index, light_info.way);
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
        }
      } else {
        if (cache_dirty){
          spm_write_back(old_spm, old_dram_addr, 64, 0);
        }
        ret = push_temp_buffer(old_spm);
        // __sync_fetch_and_add(&push_count, 1);
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
      // __sync_fetch_and_add(&push_count, 1);
      if (ret != 0){
        printf("Error: push failed for  addr=%016llx idx=%ld\n", dram_addr,idx);
        exit(1);
      }
    }
  }
  unlock_dma();
  return;
}


// 同時に複数リクエストを処理するためのテーブル管理
#define MAX_PENDING_REQUESTS 4

typedef enum {
  REQ_IDLE,
  REQ_SPM_MANAGE,
  REQ_MAC_AES_MANAGE,
  REQ_COMPLETED
} request_state_t;
request_state_t request_states[MAX_PENDING_REQUESTS];
typedef struct {
  spm_offset_t spm_offset;
  dma_id_t dma_id;
} height_info_t;
typedef struct {
  dram_addr_t dram_addr;
  bool is_write;
  uint64_t request_id;
  height_info_t height_infos[HEIGHT];
  spm_offset_t mac_spm_offset;
  dma_id_t mac_dma_id;
  dma_id_t data_dma_id;
  long load_start_index;
} llc_request_t;
llc_request_t llc_requests[MAX_PENDING_REQUESTS];


void spm_manage(){
  dma_id_t global_dma_id = 0;
  while(1){
    // LLCリクエストの監視
    for (int i = 0; i< MAX_PENDING_REQUESTS;i++){
      request_state_t state = __atomic_load_n(&request_states[i], __ATOMIC_ACQUIRE);
      llc_request_t* req = &llc_requests[i];
      if (state == REQ_IDLE){
        if(AXIM_STATUS_REG & 1) continue;; // リクエストが来るまで待つ
        bool is_write = (AXIM_STATUS_REG & 2) != 0;
        dram_addr_t addr = AXIM_REQ_ADDR_REG;
        uint64_t req_id = AXIM_REQ_ID_REG;
        req->dram_addr = addr;
        req->is_write = is_write;
        req->request_id = req_id;
        __atomic_store_n(&request_states[i], REQ_SPM_MANAGE, __ATOMIC_RELEASE);
      } else if (state == REQ_SPM_MANAGE){
        for(uint64_t i=0; i<HEIGHT; ++i){
          uint64_t index = (req->dram_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * i)));
          dram_addr_t dram_addr = index / 32 * 64 + level_base[HEIGHT - i];
          long set_index = get_cache_tree_set_index(dram_addr);
          light_tag_info_t info = light_tag_check(dram_addr);
          if (info.hit){
            spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, info.way);
            bool suc = req->is_write ? acquire_write_block(spm_offset) : acquire_read_block(spm_offset);
            if (suc){
              update_lru_on_access(set_index, info.way);
              if (req->is_write){
                set_block_dirty(set_index, info.way);
                clearParentUpdated(set_index, info.way);
              }
              req->load_start_index = HEIGHT - i;
              req->height_infos[HEIGHT - 1 - i].spm_offset = spm_offset;
              req->height_infos[HEIGHT - 1 - i].dma_id = global_dma_id;
            } else {
              break;
            }
          } else {
            long idx = find_temp_entry(dram_addr);
            spm_offset_t spm_offset;
            if (idx == -1){
              spm_offset = pop_temp_buffer();
              idx = alloc_temp_entry(dram_addr, spm_offset);
              global_dma_id += 1;
              spm_copy_to_local(dram_addr, spm_offset, 64, global_dma_id);
            } else {
              spm_offset = get_temp_spm_offset(idx);
            }
            bool suc = req->is_write ? acquire_write_block(spm_offset) : acquire_read_block(spm_offset);
            if (suc){
              if (req->is_write){
                dirty_temp_entry_by_index(idx);
              }
              req->height_infos[HEIGHT - 1 - i].spm_offset = spm_offset;
              req->height_infos[HEIGHT - 1 - i].dma_id = global_dma_id;
            } else {
              break;
            }
          }
        }
      } else if (state == REQ_COMPLETED){
        // キャッシュの解放
        if (req->is_write){
          release_write_block(req->mac_spm_offset);
          for (int j = HEIGHT - 1;j>=req->load_start_index;j--){
            release_write_block(req->height_infos[j].spm_offset);
          }
          if (req->load_start_index != 0){
            release_write_block(req->height_infos[req->load_start_index - 1].spm_offset);
          }
        } else {
          release_read_block(req->mac_spm_offset);
          for (int j = HEIGHT - 1;j>=req->load_start_index;j--){
            release_read_block(req->height_infos[j].spm_offset);
          }
          if (req->load_start_index != 0){
            release_read_block(req->height_infos[req->load_start_index - 1].spm_offset);
          }
        }
        // temp領域の解放
        uint64_t index = (req->dram_addr - PROTECTION_BASE) / 64;
        for (int j = HEIGHT - 1;j>=req->load_start_index;j--){
          dram_addr_t dram_addr = index >> (5 * (HEIGHT - 1 - j)) / 32 * 64 + level_base[j + 1];
          swapp_dram_addr(dram_addr, req->is_write);
        }
        __atomic_store_n(&request_states[i], REQ_IDLE, __ATOMIC_RELEASE);
      }
  }
  }
}


void mac_aes_manage(){
  uint64_t global_mac_req_id = 0;
  while(1){
    for (int i = 0; i< MAX_PENDING_REQUESTS;i++){
      request_state_t state = __atomic_load_n(&request_states[i], __ATOMIC_ACQUIRE);
      if (state == REQ_MAC_AES_MANAGE){
        llc_request_t* req = &llc_requests[i];
        // ツリーの検証
        uint64_t index = (req->dram_addr - PROTECTION_BASE) / 64;
        for (long i = HEIGHT - 1;i>=req->load_start_index;i--){
          spm_offset_t parent_spm = (i == 0) ? 0 : req->height_infos[i-1].spm_offset;
          dma_id_t need_id = (i == 0) ? req->height_infos[0].dma_id : req->height_infos[i-1].dma_id;
          uint64_t v_index = index >> (5 * (HEIGHT - 1 - i));
          // lock_print();
          // printf("Core %d Verification during authen height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, i, spm_offset_array[i], parent_spm, path_indecis[i], need_id);
          // printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[i], mac_req_id);
          // unlock_print();
          verify_one_height(req->height_infos[i].spm_offset, parent_spm, v_index,global_mac_req_id,need_id);
        }
        while(!mac_wait(global_mac_req_id));
        // ツリーの認証
        if (req->is_write){
          // 書き込み時の認証
          if (req->load_start_index == 0){
            // rootノードの更新
            uint64_t root = spm_ld64(0);
            root += 1;
            spm_sd64(0, root);
          } else {
            uint64_t start_level = req->load_start_index - 1;
            spm_offset_t spm_ = req->height_infos[start_level].spm_offset;
            uint64_t major_counter = spm_ld64(spm_);
            uint64_t index = (req->dram_addr - PROTECTION_BASE) / 64;
            index = index >> (5 * (HEIGHT - 1 - start_level));
            uint64_t minor_counter_byte_address = spm_ + 8 + (index % 32) / 8 * 8;
            uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
            // ここから過去のminor counterを取り出す
            uint8_t minor_counter_value = (minor_counter >> ((index % 8) * 8)) & 0xFF;
            uint8_t new_minor_counter = 0;
            if (minor_counter_value == 0xFF){
                // uint64_t new_major_counter = major_counter + 1;
                // spm_sd64(spm_offset_array[load_start_index - 1], new_major_counter);
                new_minor_counter = 0; 
            } else {
                new_minor_counter = minor_counter_value + 1;
            }
            uint64_t shift_amount = (index % 8) * 8;
            uint64_t clear_mask = ~(0xFFULL << shift_amount);
            uint64_t cleared_minor_counter = minor_counter & clear_mask;
            uint64_t shifted_new_value = (new_minor_counter);
            shifted_new_value <<= shift_amount;
            uint64_t final_word = cleared_minor_counter | shifted_new_value;
            // 書き戻し
            spm_sd64(minor_counter_byte_address, final_word);
          }
          uint64_t index = (req->dram_addr - PROTECTION_BASE) / 64;
          for (uint64_t i=req->load_start_index;i<HEIGHT;i++){
            spm_offset_t parent_spm = (i == 0) ? 0 : req->height_infos[i-1].spm_offset;
            dma_id_t need_id = (i == 0) ? req->height_infos[0].dma_id : req->height_infos[i-1].dma_id;
            uint64_t v_index = index >> (5 * (HEIGHT - 1 - i));
            global_mac_req_id += 1;
            update_one_height(req->height_infos[i].spm_offset, (i==0)?0:req->height_infos[i-1].spm_offset, v_index, true,global_mac_req_id, need_id);
          }
        }
        while(!mac_wait(global_mac_req_id));
        // set seed

        uint64_t major_counter;
        uint64_t minor_counter_byte_address;
        uint64_t minor_counter;
        uint8_t minor_counter_value;
        major_counter = spm_ld64(req->height_infos[HEIGHT-1].spm_offset);
        uint64_t counter_bit_offset = 64 + (req->dram_addr / 64) % 32 * 8;
        minor_counter_byte_address = req->height_infos[HEIGHT-1].spm_offset + (counter_bit_offset / 64) * 8;
        minor_counter = spm_ld64(minor_counter_byte_address);
        minor_counter_value = (minor_counter >> ((counter_bit_offset % 64))) & 0xFF;
        // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
        set_seed(major_counter, minor_counter_value, req->dram_addr);
        if (req->is_write){
          while(AES_START_REG);
          xor_start(true, false,req->request_id,DATA_SPM_OFFSET + i * 64);
        }
        // MACの検証/認証
        global_mac_req_id += 1;
        mac_init(global_mac_req_id,true);
        mac_buffer_set(DATA_SPM_OFFSET + i * 64, req->data_dma_id);
        mac_update(0,511);
        mac_buffer_set(req->height_infos[HEIGHT -1].spm_offset, req->height_infos[HEIGHT -1].dma_id);
        mac_update(0,63);
        mac_update(counter_bit_offset, counter_bit_offset + 7);
        if (req->is_write){
          mac_digest(req->mac_spm_offset + ((req->dram_addr - PROTECTION_BASE) / 64) % 8 * 8, req->mac_dma_id);
        } else {
          mac_result_compare(req->mac_spm_offset + ((req->dram_addr - PROTECTION_BASE) / 64) % 8 * 8, req->mac_dma_id);
        }
        while(!mac_wait(global_mac_req_id));
        // リクエスト完了
        if (req->is_write){
          // 書き込み完了通知
          axim_write_return(req->request_id);
        } else {
          while(AES_START_REG);
          xor_start(false, true, req->request_id, DATA_SPM_OFFSET + i * 64);
          axim_read_return(req->request_id);
        }
        __atomic_store_n(&request_states[i], REQ_COMPLETED, __ATOMIC_RELEASE);
      }
    }
  }

}

int main(void){
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
  for (int i=0; i<HEIGHT+1; i++){
    level_base[i] = calculate_level_base_addr(i) + COUNTER_BASE;
  }
  int total = 0;
  if (hart_id == 0){
    spm_manage();
  } else if (hart_id == 1){
    mac_aes_manage();
  } else {
    while(1);
  }
}