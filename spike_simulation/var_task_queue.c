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


static inline void swapp_dram_addr(dram_addr_t dram_addr, bool is_write){
  // int hartid;
  //   asm volatile(
  //       "csrr %0, mhartid"
  //       : "=r"(hartid)
  //   );
  long idx = find_temp_entry(dram_addr);
  lock_print();
  printf("SPM Swap Manager: Swapping dram_addr=%016llx is_write=%d found idx=%ld\n", dram_addr, is_write, idx);
  unlock_print();
  if (idx == -1){
    lock_print();
    printf("Error: temp entry not found for addr=%016llx during swap\n", dram_addr);
    unlock_print();
    return;
  }
  spm_offset_t temp_spm = get_temp_spm_offset(idx);
  bool swappable_temp = swappable_block(temp_spm);
  if (swappable_temp){
    lock_print();
    printf("SPM Swap Manager: Swappable temp entry for addr=%016llx spm_offset=%lx\n", dram_addr, temp_spm);
    unlock_print();
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
      if (!mac_updated){
        // bool suc = acquire_write_block(old_spm);
        // if (!suc){
        //   printf("Error: failed to acquire write block for addr=%016llx S:%ld W:%ld\n", old_dram_addr, set_index, light_info.way);
        //   exit(1);
        // }
        // long idx = alloc_temp_entry(old_dram_addr, old_spm);
        // dirty_temp_entry_by_index(idx);
        // unlock_dma();
        // evicted_node_update(old_dram_addr, old_spm);
        // lock_dma();
        // release_write_block(old_spm);
        spm_write_back(temp_spm, dram_addr, 64, 0);
        long ret = push_temp_buffer(temp_spm);
        __sync_fetch_and_add(&push_count, 1);
      } else {
        setParentUpdated(set_index, light_info.way);
        swapp_temp_cache(dram_addr, temp_spm, temp_dirty, light_info.way);
        if (cache_dirty){
          spm_write_back(old_spm, old_dram_addr, 64, 0);
        }
        long ret = push_temp_buffer(old_spm);
        __sync_fetch_and_add(&push_count, 1);
      }
      long ret = invalidate_temp_entry_by_index(idx);
      if (ret != 0){
        lock_print();
        printf("Error: invalidate failed for swapping: addr=%016llx idx=%ld\n", dram_addr,idx);
        printf("  mac_updated=%d\n", mac_updated);
        printf("  push_count=%d, pop_count=%d\n", push_count, pop_count);
        unlock_print();
        exit(1);
      }
      // swapする
      // lock_print();
      // printf("swapping cache block addr=%016llx spm_offset %lx S:%ld W:%ld old spm %lx\n", dram_addr, temp_spm, set_index, light_info.way, old_spm);
      // unlock_print();
    } else {
      bool temp_dirty = is_dirty_temp_entry_by_index(idx);
      if (temp_dirty){
          spm_write_back(temp_spm, dram_addr, 64, 0);
      }
      invalidate_temp_entry_by_index(idx);
      long ret = push_temp_buffer(temp_spm);
        // lock_print();
        // printf("swapping cache block is non-swappable addr=%016llx spm_offset %lx S:%ld W:%ld\n", dram_addr, temp_spm, set_index, light_info.way);
        // unlock_print();
      __sync_fetch_and_add(&push_count, 1);
      if (ret != 0){
        printf("Error: push failed for  addr=%016llx idx=%ld\n", dram_addr,idx);
        exit(1);
      }
    }
  } else {
    lock_print();
    printf("SPM Swap Manager: Non-swappable temp entry for addr=%016llx spm_offset=%lx\n", dram_addr, temp_spm);
    TMU_INSN_R(F7_TMU_SHOW_REF_COUNT, temp_spm, 0, 0);
    unlock_print();
  }
  return;
}


// 同時に複数リクエストを処理するためのテーブル管理
#define MAX_PENDING_REQUESTS 2

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
  // height_info_t height_infos[HEIGHT];
  spm_offset_t mac_spm_offset;
  dma_id_t mac_dma_id;
  dma_id_t data_dma_id;
  long load_start_index;
  long current_index;
} llc_request_t;
llc_request_t llc_requests[MAX_PENDING_REQUESTS];
spm_offset_t spm_height_infos[MAX_PENDING_REQUESTS][HEIGHT];
dma_id_t id_infos[MAX_PENDING_REQUESTS][HEIGHT];

void spm_manage(){
  dma_id_t global_dma_id = 0;
  while(1){
    // LLCリクエストの監視
    for (int i = 0; i< MAX_PENDING_REQUESTS;i++){
      request_state_t state = __atomic_load_n(&request_states[i], __ATOMIC_ACQUIRE);
      if (state == REQ_IDLE){
        llc_request_t* req = &llc_requests[i]; 
        if (req->current_index != -1){
          goto BEFORE_LOOP;
        }  
        if ((AXIM_STATUS_REG & 1) == 0){
          continue;
        }
        lock_print();
        printf("SPM Manager: Received new LLC request in slot %d\n", i);
        unlock_print();

        bool is_write = (AXIM_STATUS_REG & 2) != 0;
        dram_addr_t addr = AXIM_REQ_ADDR_REG;
        uint64_t req_id = AXIM_REQ_ID_REG;
        req->dram_addr = addr;
        req->is_write = is_write;
        req->request_id = req_id;
        req->current_index = 0;
        uint64_t s = read_instret();
BEFORE_LOOP:
        lock_print();
        printf("SPM : req addr %016llx is_write %d current_index %ld\n", req->dram_addr, req->is_write, req->current_index);
        unlock_print();
        for(long j=req->current_index; j<HEIGHT; ++j){
          uint64_t s1 = read_instret();
          uint64_t index = (req->dram_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * j)));
          dram_addr_t dram_addr = index / 32 * 64 + level_base[HEIGHT - j];
          long set_index = get_cache_tree_set_index(dram_addr);
          uint64_t info = light_tag_check_(dram_addr);
          uint64_t s2 = read_instret();
          // lock_print();
          // printf("SPM Manager: Light tag check at height %ld for LLC request in slot %d addr=%016llx set_index=%lu hit=%d time %llu cycles\n", j, i, dram_addr, set_index, info.hit, s2 - s1);
          // unlock_print();
          uint64_t s3 = read_instret();
          if (info & 0x1){
            // uint64_t e6 = read_instret();
            index_t way = (info >> 32);
            spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way);
            long suc = req->is_write ? acquire_write_block(spm_offset) : acquire_read_block(spm_offset);
            uint64_t e7 = read_instret();
            if (suc){
              update_lru_on_access(set_index, way);
              if (req->is_write){
                set_block_dirty(set_index, way);
                clearParentUpdated(set_index, way);
              }
              // uint64_t e4 = read_instret();
              // temp_height_infos[i][HEIGHT - j - 1] = (height_info_t){.spm_offset = spm_offset, .dma_id = global_dma_id};
              // // temp_height_infos[i][HEIGHT - j - 1].dma_id = global_dma_id;
              req->load_start_index = HEIGHT - j;
              spm_height_infos[i][HEIGHT - j - 1] = spm_offset;
              id_infos[i][HEIGHT - j - 1] = global_dma_id;
              // uint64_t e5 = read_instret();
              // lock_print();
              // uint64_t e1 = read_instret();
              // printf("SPM Manager: Hit at height %ld for LLC request in slot %d addr=%016llx SPM offset=%016llx time %llu cycles\n", j, i, dram_addr, spm_offset, e1 - s3);
              // printf(" array time %llu cycles\n", e5 - e4);
              // printf(" acquire time %llu cycles\n", e7 - e6);
              // printf(" rest time %llu cycles\n", e4 - e7);
              // printf(" hit check time %llu cycles\n", e6 - s3);
              // unlock_print();
              goto AFTER_PATH_CHECK;
            } else {
              req->current_index = j;
              goto AFTER_LOOP;
            }
          } else {
            long idx = find_temp_entry(dram_addr);
            spm_offset_t spm_offset;
            bool pop = false;
            if (idx == -1){
              spm_offset = pop_temp_buffer();
              pop = true;
              if (spm_offset == -1){
                req->current_index = j;
                lock_print();
                printf("pop fail during slot %d mangae; push_count=%d pop_count=%d addr=%016llx\n", i, push_count, pop_count,req->dram_addr);
                unlock_print();
                for (int k = 0; k < MAX_PENDING_REQUESTS; k++){
                  llc_request_t* r = &llc_requests[k];
                  lock_print();
                  printf("  slot %d req addr=%016llx is_write=%d request_id=%llu current_index=%ld load_start_index=%ld\n", k, r->dram_addr, r->is_write, r->request_id, r->current_index, r->load_start_index);
                  request_state_t st = __atomic_load_n(&request_states[k], __ATOMIC_ACQUIRE);
                  printf("    state=%d\n", st);
                  for (long h = 0; h < HEIGHT; h++){
                    printf("    height %ld spm_offset=%016llx dma_id=%llu\n", h, spm_height_infos[k][h], id_infos[k][h]);
                  }
                  unlock_print();
                }
                long res;
                TMX_INSN_R(F7_TMX_SHOW_ACTIVE, res, 0, 0);
                // spm_offsetのロック周りを表示させる
                for (int k = 0;k<16;k++){
                  spm_offset_t s = get_temp_spm_offset(k);
                  TMU_INSN_R(F7_TMU_SHOW_REF_COUNT, res, s, 0);
                }
                exit(1);
                goto AFTER_LOOP;
              }
              __sync_fetch_and_add(&pop_count, 1);
              idx = alloc_temp_entry(dram_addr, spm_offset);
              global_dma_id += 1;
              spm_copy_to_local(dram_addr, spm_offset, 64, global_dma_id);
            } else {
              spm_offset = get_temp_spm_offset(idx);
            }
            long suc = req->is_write ? acquire_write_block(spm_offset) : acquire_read_block(spm_offset);
            if (suc){
              if (req->is_write){
                dirty_temp_entry_by_index(idx);
              }
              // temp_height_infos[i][HEIGHT - 1 - j].spm_offset = spm_offset;
              // temp_height_infos[i][HEIGHT - 1 - j].dma_id = global_dma_id;
              spm_height_infos[i][HEIGHT - j - 1] = spm_offset;
              id_infos[i][HEIGHT - j - 1] = global_dma_id;
              // lock_print();
              // uint64_t e2 = read_instret();
              // printf("SPM Manager: Temp hit at height %ld for LLC request in slot %d addr=%016llx SPM offset=%016llx time %llu cycles\n", j, i, dram_addr, spm_offset, e2 - s3);
              // unlock_print();
            } else {
              if (pop == false){
                lock_print();
                printf("Error: failed to acquire block for temp entry addr=%016llx during SPM manage in slot %d\n", dram_addr, i);
                printf("SPM Manager: push_count=%d pop_count=%d\n", push_count, pop_count);
                printf("spm_offset=%lx\n", spm_offset);
                printf("current state dump:\n");
                for (int k = 0; k < MAX_PENDING_REQUESTS; k++){
                  llc_request_t* r = &llc_requests[k];
                  lock_print();
                  printf("  slot %d req addr=%016llx is_write=%d request_id=%llu current_index=%ld load_start_index=%ld\n", k, r->dram_addr, r->is_write, r->request_id, r->current_index, r->load_start_index);
                  request_state_t st = __atomic_load_n(&request_states[k], __ATOMIC_ACQUIRE);
                  printf("    state=%d\n", st);
                  for (long h = 0; h < HEIGHT; h++){
                    printf("    height %ld spm_offset=%016llx dma_id=%llu\n", h, spm_height_infos[k][h], id_infos[k][h]);
                  }
                }
                unlock_print();
                exit(1);
              }
              req->current_index = j;
              goto AFTER_LOOP;
            }
          }
        }
AFTER_PATH_CHECK:
        uint64_t e = read_instret();
        // Dataブロック
        if (!req->is_write){
          global_dma_id += 1;
          spm_copy_to_local(req->dram_addr, DATA_SPM_OFFSET + i * 64, 64, global_dma_id);
        }
        req->data_dma_id = global_dma_id;
        // MACのDMA管理へ移行
        lock_print();
        printf("SPM Manager: Finished path check for LLC request in slot %d\n", i);
        unlock_print();
        dram_addr_t datamacblock_addr = DATA_TAG_BASE + (((req->dram_addr - PROTECTION_BASE) / (64 * 8))) * 64;
        index_t set_index = get_cache_set_index(datamacblock_addr);
        spm_offset_t spm_offset;
        light_tag_info_t light_info = light_tag_check(datamacblock_addr);
        if (light_info.hit){
          spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
        } else {
          if (light_info.way == -1){
            light_info.way = get_victim_way(set_index);
            bool dirty = is_block_dirty(set_index, light_info.way);
            spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
            if (dirty){
              dram_addr_t old_block_addr = get_block_addr(set_index, light_info.way);
              spm_write_back(spm_offset, old_block_addr, 64, 0);
            }
            // タグメタデータ更新
            clear_block_dirty(set_index, light_info.way);
          } else {
            set_block_valid(set_index, light_info.way);
            spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
          }
          global_dma_id += 1;
          spm_copy_to_local(datamacblock_addr, spm_offset, 64, global_dma_id);
          set_block_addr(set_index, light_info.way, datamacblock_addr);
          // long slot_idx = (set_index * CACHE_WAYS) + light_info.way;
          // #ifdef ENABLE_TMU_HARDWARE
          //   long ret;
          //   TMU_INSN_R(F7_TMU_SET_TAG, ret, slot_idx, datamacblock_addr); 
          // #else
          //   valid_metadata[set_index][light_info.way] = true;
          //   dirty_metadata[set_index][light_info.way] = false;
          //   block_addr_metadata[set_index][light_info.way] = datamacblock_addr;
          // #endif
        }
        update_lru_on_access(set_index, light_info.way);
        req->mac_spm_offset = spm_offset;
        req->mac_dma_id = global_dma_id;
        long suc = req->is_write ? acquire_write_block(spm_offset) : acquire_read_block(spm_offset);
        if (suc){
          if (req->is_write){
              set_block_dirty(set_index, light_info.way);
          }
        } else {
          lock_print();
          printf("SPM Manager: Failed to acquire block for MAC addr=%016llx in slot %d\n", datamacblock_addr, i);
          unlock_print();
          continue;
        }
        // uint64_t end_time = read_instret();
        // if (req->request_id % 1000 == 0){
        //   lock_print();
        //   printf("SPM Manager: LLC request %llu load_start_index %llu SPM manage time %llu cycles\n", req->request_id, req->load_start_index, end_time - start_time);
        //   unlock_print();
        // }
        __atomic_store_n(&request_states[i], REQ_MAC_AES_MANAGE, __ATOMIC_RELEASE);
        // __atomic_store_n(&request_states[i], REQ_SPM_MANAGE, __ATOMIC_RELEASE);
      } else if (state == REQ_SPM_MANAGE){
        // ツリー上のノードのタグチェックを行う
        uint64_t start_time = read_instret();
        llc_request_t* req = &llc_requests[i];
        // uint64_t s = read_instret();
        // for(long j=req->current_index; j<HEIGHT; ++j){
        //   uint64_t s1 = read_instret();
        //   uint64_t index = (req->dram_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * j)));
        //   dram_addr_t dram_addr = index / 32 * 64 + level_base[HEIGHT - j];
        //   long set_index = get_cache_tree_set_index(dram_addr);
        //   uint64_t info = light_tag_check_(dram_addr);
        //   uint64_t s2 = read_instret();
        //   // lock_print();
        //   // printf("SPM Manager: Light tag check at height %ld for LLC request in slot %d addr=%016llx set_index=%lu hit=%d time %llu cycles\n", j, i, dram_addr, set_index, info.hit, s2 - s1);
        //   // unlock_print();
        //   uint64_t s3 = read_instret();
        //   if (info & 0x1){
        //     // uint64_t e6 = read_instret();
        //     index_t way = (info >> 32);
        //     spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way);
        //     long suc = req->is_write ? acquire_write_block(spm_offset) : acquire_read_block(spm_offset);
        //     uint64_t e7 = read_instret();
        //     if (suc){
        //       update_lru_on_access(set_index, way);
        //       if (req->is_write){
        //         set_block_dirty(set_index, way);
        //         clearParentUpdated(set_index, way);
        //       }
        //       // uint64_t e4 = read_instret();
        //       // temp_height_infos[i][HEIGHT - j - 1] = (height_info_t){.spm_offset = spm_offset, .dma_id = global_dma_id};
        //       // // temp_height_infos[i][HEIGHT - j - 1].dma_id = global_dma_id;
        //       req->load_start_index = HEIGHT - j;
        //       spm_height_infos[i][HEIGHT - j - 1] = spm_offset;
        //       id_infos[i][HEIGHT - j - 1] = global_dma_id;
        //       // uint64_t e5 = read_instret();
        //       // lock_print();
        //       // uint64_t e1 = read_instret();
        //       // printf("SPM Manager: Hit at height %ld for LLC request in slot %d addr=%016llx SPM offset=%016llx time %llu cycles\n", j, i, dram_addr, spm_offset, e1 - s3);
        //       // printf(" array time %llu cycles\n", e5 - e4);
        //       // printf(" acquire time %llu cycles\n", e7 - e6);
        //       // printf(" rest time %llu cycles\n", e4 - e7);
        //       // printf(" hit check time %llu cycles\n", e6 - s3);
        //       // unlock_print();
        //       break;
        //     } else {
        //       req->current_index = j;
        //       goto AFTER_LOOP;
        //     }
        //   } else {
        //     long idx = find_temp_entry(dram_addr);
        //     spm_offset_t spm_offset;
        //     if (idx == -1){
        //       spm_offset = pop_temp_buffer();
        //       if (spm_offset == -1){
        //         req->current_index = j;
        //         goto AFTER_LOOP;
        //       }
        //       idx = alloc_temp_entry(dram_addr, spm_offset);
        //       global_dma_id += 1;
        //       spm_copy_to_local(dram_addr, spm_offset, 64, global_dma_id);
        //     } else {
        //       spm_offset = get_temp_spm_offset(idx);
        //     }
        //     long suc = req->is_write ? acquire_write_block(spm_offset) : acquire_read_block(spm_offset);
        //     if (suc){
        //       if (req->is_write){
        //         dirty_temp_entry_by_index(idx);
        //       }
        //       // temp_height_infos[i][HEIGHT - 1 - j].spm_offset = spm_offset;
        //       // temp_height_infos[i][HEIGHT - 1 - j].dma_id = global_dma_id;
        //       spm_height_infos[i][HEIGHT - j - 1] = spm_offset;
        //       id_infos[i][HEIGHT - j - 1] = global_dma_id;
        //       // lock_print();
        //       // uint64_t e2 = read_instret();
        //       // printf("SPM Manager: Temp hit at height %ld for LLC request in slot %d addr=%016llx SPM offset=%016llx time %llu cycles\n", j, i, dram_addr, spm_offset, e2 - s3);
        //       // unlock_print();
        //     } else {
        //       req->current_index = j;
        //       goto AFTER_LOOP;
        //     }
        //   }
        // }
        // uint64_t e = read_instret();
        
        // // MACのDMA管理へ移行
        // // lock_print();
        // // printf("SPM Manager: Finished path check for LLC request in slot %d\n", i);
        // // unlock_print();
        // dram_addr_t datamacblock_addr = DATA_TAG_BASE + (((req->dram_addr - PROTECTION_BASE) / (64 * 8))) * 64;
        // index_t set_index = get_cache_set_index(datamacblock_addr);
        // spm_offset_t spm_offset;
        // light_tag_info_t light_info = light_tag_check(datamacblock_addr);
        // if (light_info.hit){
        //   spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
        // } else {
        //   if (light_info.way == -1){
        //     light_info.way = get_victim_way(set_index);
        //     bool dirty = is_block_dirty(set_index, light_info.way);
        //     spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
        //     if (dirty){
        //       dram_addr_t old_block_addr = get_block_addr(set_index, light_info.way);
        //       spm_write_back(spm_offset, old_block_addr, 64, 0);
        //     }
        //     // タグメタデータ更新
        //     clear_block_dirty(set_index, light_info.way);
        //   } else {
        //     set_block_valid(set_index, light_info.way);
        //     spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
        //   }
        //   global_dma_id += 1;
        //   spm_copy_to_local(datamacblock_addr, spm_offset, 64, global_dma_id);
        //   set_block_addr(set_index, light_info.way, datamacblock_addr);
        //   // long slot_idx = (set_index * CACHE_WAYS) + light_info.way;
        //   // #ifdef ENABLE_TMU_HARDWARE
        //   //   long ret;
        //   //   TMU_INSN_R(F7_TMU_SET_TAG, ret, slot_idx, datamacblock_addr); 
        //   // #else
        //   //   valid_metadata[set_index][light_info.way] = true;
        //   //   dirty_metadata[set_index][light_info.way] = false;
        //   //   block_addr_metadata[set_index][light_info.way] = datamacblock_addr;
        //   // #endif
        // }
        // update_lru_on_access(set_index, light_info.way);
        // req->mac_spm_offset = spm_offset;
        // req->mac_dma_id = global_dma_id;
        // long suc = req->is_write ? acquire_write_block(spm_offset) : acquire_read_block(spm_offset);
        // if (suc){
        //   if (req->is_write){
        //       set_block_dirty(set_index, light_info.way);
        //   }
        // } else {
        //   continue;
        // }
        // uint64_t end_time = read_instret();
        // // if (req->request_id % 1000 == 0){
        // //   lock_print();
        // //   printf("SPM Manager: LLC request %llu load_start_index %llu SPM manage time %llu cycles\n", req->request_id, req->load_start_index, end_time - start_time);
        // //   unlock_print();
        // // }
        // __atomic_store_n(&request_states[i], REQ_MAC_AES_MANAGE, __ATOMIC_RELEASE);
      } else if (state == REQ_COMPLETED){
        // キャッシュの解放
        lock_print();
        printf("SPM Manager: Cleaning up after completed LLC request in slot %d\n", i);
        unlock_print();
        llc_request_t* req = &llc_requests[i];
        if (req->is_write){
          release_write_block(req->mac_spm_offset);
          for (int j = HEIGHT - 1;j>=req->load_start_index;j--){
            release_write_block(spm_height_infos[i][j]);
          }
          if (req->load_start_index != 0){
            release_write_block(spm_height_infos[i][req->load_start_index - 1]);
          }
        } else {
          release_read_block(req->mac_spm_offset);
          for (int j = HEIGHT - 1;j>=req->load_start_index;j--){
            release_read_block(spm_height_infos[i][j]);
          }
          if (req->load_start_index != 0){
            release_read_block(spm_height_infos[i][req->load_start_index - 1]);
          }
        }
        // temp領域の解放
        uint64_t index = (req->dram_addr - PROTECTION_BASE) / 64;
        for (int j = HEIGHT - 1;j>=req->load_start_index;j--){
          // lock_print();
          // printf("SPM Manager: Freeing temp entries for LLC request in slot %d at height %d\n", i, j);
          // unlock_print();
          dram_addr_t dram_addr = (index >> (5 * (HEIGHT - 1 - j))) / 32 * 64 + level_base[j + 1];
          swapp_dram_addr(dram_addr, req->is_write);
        }
        req->current_index = -1;
        __atomic_store_n(&request_states[i], REQ_IDLE, __ATOMIC_RELEASE);
      }
AFTER_LOOP:
    }
  }
}

void mac_aes_manage(){
  uint64_t global_mac_req_id = 0;
  while(1){
    for (int i = 0; i< MAX_PENDING_REQUESTS;i++){
      request_state_t state = __atomic_load_n(&request_states[i], __ATOMIC_ACQUIRE);
      uint64_t s1 = read_instret();
      if (state == REQ_MAC_AES_MANAGE){
        llc_request_t* req = &llc_requests[i];
        lock_print();
        printf("MAC/AES Manager: Processing LLC request in slot %d addr=%016llx is_write=%d\n", i, req->dram_addr, req->is_write);
        unlock_print();
        // ツリーの検証
        uint64_t index = (req->dram_addr - PROTECTION_BASE) / 64;
        for (long j = HEIGHT - 1;j>=req->load_start_index;j--){
          spm_offset_t parent_spm = (j == 0) ? 0 : spm_height_infos[i][j-1];
          dma_id_t need_id = (j == 0) ? id_infos[i][0] : id_infos[i][j-1];
          uint64_t v_index = index >> (5 * (HEIGHT - 1 - j));
          lock_print();
          printf("Core %d Verification during authen height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", i, j, spm_height_infos[i][j], parent_spm, v_index, need_id);
          printf("  dram_addr=%016llx mac_req_id %d\n", req->dram_addr, global_mac_req_id);
          unlock_print();
          global_mac_req_id += 1;
          verify_one_height(spm_height_infos[i][j], parent_spm, v_index,global_mac_req_id,need_id);
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
            spm_offset_t spm_ = spm_height_infos[i][start_level];
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
          for (uint64_t j=req->load_start_index;j<HEIGHT;j++){
            spm_offset_t parent_spm = (j == 0) ? 0 : spm_height_infos[i][j-1];
            dma_id_t need_id = (j == 0) ? id_infos[i][0] : id_infos[i][j-1];
            uint64_t v_index = index >> (5 * (HEIGHT - 1 - j));
            lock_print();
            printf("Core %d Update during authen height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", i, j, spm_height_infos[i][j], parent_spm, v_index, need_id);
            printf("  dram_addr=%016llx mac_req_id %d\n", req->dram_addr, global_mac_req_id);
            unlock_print();
            global_mac_req_id += 1;
            update_one_height(spm_height_infos[i][j], parent_spm, v_index, true,global_mac_req_id, need_id);
          }
        }
        // set seed
        uint64_t major_counter;
        uint64_t minor_counter_byte_address;
        uint64_t minor_counter;
        uint8_t minor_counter_value;
        spm_offset_t spm_offset = spm_height_infos[i][HEIGHT - 1];
        major_counter = spm_ld64(spm_offset);
        uint64_t counter_bit_offset = 64 + (req->dram_addr / 64) % 32 * 8;
        minor_counter_byte_address = spm_offset + (counter_bit_offset / 64) * 8;
        minor_counter = spm_ld64(minor_counter_byte_address);
        minor_counter_value = (minor_counter >> ((counter_bit_offset % 64))) & 0xFF;
        // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
        // lock_print();
        // printf("MAC/AES Manager: Setting AES seed for LLC request in slot %d addr=%016llx major_counter=%016llx minor_counter=%02x\n", i, req->dram_addr, major_counter, minor_counter_value);
        // unlock_print();
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
        mac_buffer_set(spm_offset, id_infos[i][HEIGHT -1]);
        mac_update(0,63);
        mac_update(counter_bit_offset, counter_bit_offset + 7);
        if (req->is_write){
          mac_digest(req->mac_spm_offset + ((req->dram_addr - PROTECTION_BASE) / 64) % 8 * 8, req->mac_dma_id);
        } else {
          mac_result_compare(req->mac_spm_offset + ((req->dram_addr - PROTECTION_BASE) / 64) % 8 * 8, req->mac_dma_id);
        }
        // リクエスト完了
        if (req->is_write){
          // 書き込み完了通知
          spm_write_back(DATA_SPM_OFFSET + i * 64, req->dram_addr, 64, 0);
          axim_write_return(req->request_id);
          while(!mac_wait(global_mac_req_id));
        } else {
          spm_wait(req->data_dma_id);
          xor_start(false, true, req->request_id, DATA_SPM_OFFSET + i * 64);
          while(!mac_wait(global_mac_req_id));
          axim_read_return(req->request_id);
        }
        uint64_t s2 = read_instret();
        __atomic_store_n(&request_states[i], REQ_COMPLETED, __ATOMIC_RELEASE);
        // if (req->request_id % 1000 == 0){
        //   lock_print();
        //   printf("MAC/AES Manager: Completed LLC request in slot %d addr=%016llx is_write=%d load_start_index=%d instret=%llu\n", i, req->dram_addr, req->is_write, req->load_start_index, s2 - s1);
        //   unlock_print();
        // }
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
    for (int i=0; i<HEIGHT+1; i++){
      level_base[i] = calculate_level_base_addr(i) + COUNTER_BASE;
    }
    for (int i=0; i<MAX_PENDING_REQUESTS; i++){
      llc_requests[i].current_index = -1;
      __atomic_store_n(&request_states[i], REQ_IDLE, __ATOMIC_RELEASE);
    }
    __atomic_store_n(&init_done, true, __ATOMIC_RELEASE);
  } else {
    lock_print();
    printf("Core %d waiting for initialization...\n", hart_id);
    unlock_print();
    while(1){
      bool done = __atomic_load_n(&init_done, __ATOMIC_ACQUIRE);
      if (done) break;
    }
  }
  if (hart_id == 0){
    spm_manage();
  } else if (hart_id == 1){
    mac_aes_manage();
  } else {
    while(1);
  }
}