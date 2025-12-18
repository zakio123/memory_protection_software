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
int aes_lock = -1;

uint32_t global_mac_req_id = 0;
typedef enum {
    RS_IDLE,              // 未使用
    RS_PATH_TAG_WALK,     // パス計算 + light_tag_check + パス上DMA発行 + データ・MACブロック確保
    RS_PATH_VERIFY,       // verify_one_heightをレベルごとに回す
    RS_UPDATE_COUNTER,    // ルートや一時的なルートのカウンター更新
    RS_TREE_UPDATE,       // update_one_height で木を更新
    RS_SWAP_OR_EVICT,     // temp <-> cache スワップ & lazy update
    RS_SET_SEED,          // major/minor counterから set_seed
    RS_DATA_WAIT,        // データブロックDMA待ち
    RS_DATAMAC_WAIT,      // ↑のDMA待ち
    RS_AES_XOR_WAIT,      // AES_START_REG が 0 になるのを待つ
    RS_DATAMAC_UPDATE,    // MAC計算のためのデータ設定
    RS_DATAMAC_VERIFY_AUTHENTICATE, // データMACの検証/認証
    RS_MAC_FINAL,         // MAC 計算&比較/書き込み
    RS_DONE,              // 完了
    RS_ERROR,
    RS_DATAMAC_DMA,
} req_state_t;

static inline bool dma_wait(dma_id_t id){
    bool done = (id <= SPM_COMPLETE_ID);
    return done;
}
static inline uint64_t read_instret() {
    uint64_t val;
    asm volatile ("csrr %0, minstret" : "=r" (val));
    return val;
}

typedef struct {
    // dram_addr_t request_addr;
    bool is_write;
    uint32_t req_id;
    spm_offset_t path_spm_offsets[HEIGHT];
    dram_addr_t path_dram_addrs[HEIGHT];
    uint32_t counter_spm_offset;
    uint64_t path_indices[HEIGHT];
    bool load_needed[HEIGHT];
    spm_offset_t mac_spm_offset;
    uint32_t load_start_index;
    dma_id_t internal_wait_id;
    bool tag_hit;
    dma_id_t wait_tag_dma_id;
    uint32_t level;
    index_t tag_way;
    index_t root_way;
} AddressContext;

// 各ステップの処理
dram_addr_t level_base[HEIGHT+1] = {0};
// 引数: コンテキスト構造体へのポインタ、プロセスリスト内のインデックス、dma_idのポインタ
static inline  req_state_t step(AddressContext *context, index_t list_i, dma_id_t *global_dma_id, req_state_t current_state, dram_addr_t request_addr) {
    // 状態に応じた処理を行う
        // コンテキストが持つ配列へのpointerをローカル変数にコピー
    uint64_t *path_indices = context->path_indices;
    spm_offset_t *path_spm_offsets = context->path_spm_offsets;
    bool *load_needed = context->load_needed;
    dram_addr_t *path_dram_addrs = context->path_dram_addrs;
while(1){
    uint64_t start_instret = read_instret();
  switch (current_state) {
    case RS_PATH_TAG_WALK:{
        context->internal_wait_id = *global_dma_id;
        dma_id_t start_id = *global_dma_id;
        uint64_t start_time = read_instret();
        for(uint64_t i=0; i<HEIGHT; ++i){
            uint64_t index = (request_addr - PROTECTION_BASE) / (64  * (1ULL << (5 * i)));
            path_indices[HEIGHT - 1 - i] = index;
            dram_addr_t dram_addr = ((index >> 5) << 6) + level_base[HEIGHT - i];
            path_dram_addrs[HEIGHT - 1 - i] = dram_addr;
            struct Info info = tag_check(dram_addr);
            if (info.hit){
                context->load_start_index = HEIGHT - i;
                index_t set_index = get_cache_set_index(dram_addr);
                spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, info.way);
                context->root_way = info.way;
                acquire_cache_block(set_index, info.way);
                path_spm_offsets[HEIGHT - 1 - i] = spm_offset;
                load_needed[HEIGHT - 1 - i] = false;
                break;
            } else {
                int temp_idx = find_temp_entry(dram_addr);
                spm_offset_t spm_offset;
                if (temp_idx == -1){
                    load_needed[HEIGHT - 1 - i] = true;
                    spm_offset = pop_temp_buffer();
                    temp_idx = alloc_temp_entry(dram_addr, spm_offset);
                    start_id++;
                    spm_copy_to_local(dram_addr, spm_offset,64, start_id);
                } else {
                    load_needed[HEIGHT - 1 - i] = false;
                    spm_offset = get_temp_spm_offset(temp_idx);
                }
                path_spm_offsets[HEIGHT - 1 - i] = spm_offset;
                acquire_temp_entry_by_index(temp_idx);
            }
        }
        uint64_t end_time = read_instret();
        // for (uint64_t i = context->load_start_index;i<HEIGHT;i++){
        //     if (context->load_needed[i]){
        //         start_id++;
        //         spm_copy_to_local(context->path_dram_addrs[i], context->path_spm_offsets[i], 64, start_id);
        //     }
        // }
        uint64_t e_0 = read_instret();
        // データブロック
        if (!context->is_write){
            start_id++;
            spm_copy_to_local(request_addr, DATA_SPM_OFFSET + 64 * list_i, 64, start_id);            
        }
        uint64_t e_1 = read_instret();
        uint64_t mac_block_addr = get_datamacblock_addr(request_addr);
        struct Info mac_info = tag_check(mac_block_addr);
        uint64_t e_2 = read_instret();
        context->mac_spm_offset = mac_info.spm_offset;
        context->tag_hit = mac_info.hit;
        context->tag_way = mac_info.way;
        uint64_t e_3 = read_instret();
        if (mac_info.hit == false){
            start_id++;
            context->wait_tag_dma_id = ensureBlockInSpm(mac_block_addr, mac_info, start_id);
        }
        uint64_t e_4 = read_instret();
        acquire_cache_block(get_cache_set_index(mac_block_addr), mac_info.way);
        uint64_t e_5 = read_instret();
        printf("aquire_cache_block time %llu\n", e_5 - e_4);
        printf("ensureBlockInSpm time %llu\n", e_4 - e_3);
        printf("mac_tag_check time %llu\n", e_3 - e_2);
        printf("data_spm_copy time %llu\n", e_2 - e_1);
        exit(1);
        if (context->load_start_index == HEIGHT){
            if (context->is_write){
                context->level = context->load_start_index;
                current_state = RS_UPDATE_COUNTER;
            } else {
                current_state = RS_DATA_WAIT;
            }
            context->internal_wait_id += 1;
        } else {
            current_state = RS_PATH_VERIFY;
            context->level = HEIGHT - 1;  
        } 
        *global_dma_id = start_id;
        break;
    }
    case RS_PATH_VERIFY:{
        uint32_t i = context->level;
        int idx = find_temp_entry(path_dram_addrs[i]);
        spm_offset_t parent_spm = (i == 0) ? 0  : path_spm_offsets[i-1];
        if (context->load_needed[i]){
            if (i != context->load_start_index){
                if (!dma_wait(context->internal_wait_id+2)){
                    return current_state;
                }
            } else {
                if (!dma_wait(context->internal_wait_id+1)){
                    return current_state;
                }
            }
            context->internal_wait_id += 1;
            if (idx >= 0){
                set_loaded_temp_entry_by_index(idx);
            } 
        } else {
            if (idx >= 0) {
                if (is_loaded_temp_entry_by_index(idx) == false) {
                    return current_state;
                }
            }
        }
        global_mac_req_id += 1;
        uint32_t mac_req_id = (global_mac_req_id);
        verify_one_height(path_spm_offsets[i], parent_spm, path_indices[i], mac_req_id);
        if (context->level == context->load_start_index){
            // 全レベル完了
            // while(!(mac_wait(mac_req_id)));
            if (context->is_write){
                context->level = context->load_start_index;
                current_state = RS_UPDATE_COUNTER;
            } else {
                current_state = RS_DATA_WAIT;
            }
            context->internal_wait_id += 1;
        } else {
            context->level -= 1;
        }
        break;
    }
    case RS_UPDATE_COUNTER:{
        if (context->load_start_index == 0){
            // rootノードの更新
            uint64_t root = spm_ld64(0);
            root += 1;
            spm_sd64(0, root);
        } else {
            uint64_t start_level = context->load_start_index - 1;
            uint64_t major_counter = spm_ld64(context->path_spm_offsets[start_level]);
            uint32_t index = context->path_indices[context->load_start_index - 1];
            uint64_t minor_counter_byte_address = context->path_spm_offsets[start_level] + 8 + (index % 32) / 8 * 8;
            uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
            // ここから過去のminor counterを取り出す
            uint8_t minor_counter_value = (minor_counter >> ((index % 8) * 8)) & 0xFF;
            uint8_t new_minor_counter = 0;
            if (minor_counter_value == 0xFF){
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
            index_t set_index = get_cache_set_index(context->path_dram_addrs[start_level]);
            clearParentUpdated(set_index,context->root_way);
            set_block_dirty(set_index,context->root_way);
        }
        current_state = RS_TREE_UPDATE;
        break;
    }
    case RS_TREE_UPDATE:{
        // update_one_height で木を更新
        uint32_t mac_req_id = 0;
        for (uint64_t i=context->load_start_index;i<HEIGHT;i++){
            global_mac_req_id += 1;
            uint64_t index = path_indices[i];
            int idx = find_temp_entry(path_dram_addrs[i]);
            spm_offset_t parent_spm = (i == 0) ? 0 : path_spm_offsets[i-1];
            mac_req_id = (global_mac_req_id);
            update_one_height(path_spm_offsets[i], parent_spm, index, true, mac_req_id);
            if (idx >= 0){
                dirty_temp_entry_by_index(idx);
            }
        }
        mac_wait(mac_req_id);
        current_state = RS_SET_SEED;
        break;
    }
    case RS_SWAP_OR_EVICT:{
        // temp <-> cache スワップ & lazy update
        // キャッシュしていたノードのref_countを減らす
        if (context->load_start_index > 0){
            index_t set_index = get_cache_set_index(context->path_dram_addrs[context->load_start_index - 1]);
            release_cache_block(set_index, context->root_way);
        }
        for (uint64_t i = context->load_start_index;i<HEIGHT;i++){
            dram_addr_t dram_addr = path_dram_addrs[i];
            int idx = find_temp_entry(dram_addr);
            release_temp_entry_by_index(idx);
            index_t set_index = get_cache_set_index(dram_addr);
            uint64_t s = read_instret();
            struct Info info_i = tag_check(dram_addr);
            uint64_t e = read_instret();
            bool swappable_cache = swappable_cache_block(set_index, info_i.way);
            if (swappable_temp_entry_by_index(idx)){
                bool dirty = is_dirty_temp_entry_by_index(idx);
                spm_offset_t temp_spm = path_spm_offsets[i];
                if (swappable_cache){
                    if (info_i.way >= 0){
                        bool mac_updated = is_mac_updated(set_index, info_i.way);
                        if (mac_updated){
                            swapp_temp_cache(dram_addr, info_i, temp_spm, dirty);
                            setParentUpdated(set_index, info_i.way);
                        } else{
                            if (dirty){
                                spm_write_back(temp_spm, dram_addr, 64, 0);
                            }
                            push_temp_buffer(temp_spm);
                        }
                    } else {
                        if (dirty){
                            spm_write_back(temp_spm, dram_addr, 64, 0);
                        }
                        push_temp_buffer(temp_spm);
                    }
                } else {
                    spm_write_back(temp_spm, dram_addr, 64, 0);
                    push_temp_buffer(temp_spm);
                }
                invalidate_temp_entry_by_index(idx);
            }
        }
        current_state = RS_DONE;
        break;
    }
    case RS_DATAMAC_UPDATE:{
        // MAC計算のためのデータ設定
        dram_addr_t mac_addr = get_datamacblock_addr(request_addr);
        index_t set_index = get_cache_set_index(mac_addr);
        if (context->tag_hit == false){
            if (dma_wait(context->wait_tag_dma_id)){
                set_loaded(set_index, context->tag_way);
            } else {
                return current_state;
            }
        } else {
            if (!is_loaded(set_index, context->tag_way)){
                return current_state;
            }
        }
        global_mac_req_id += 1;
        uint32_t mac_req_id = (global_mac_req_id);
        mac_init(mac_req_id);
        mac_buffer_set(DATA_SPM_OFFSET + 64 * list_i);
        mac_update(0, 511);
        mac_buffer_set(context->path_spm_offsets[HEIGHT - 1] );
        uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
        mac_update(0,63);
        mac_update(counter_bit_offset, counter_bit_offset + 7);
        dram_addr_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
        if (context->is_write){
            mac_digest(context->mac_spm_offset + dmac_byte_offset);
            set_block_dirty(set_index, context->tag_way);
        } else {
            mac_result_compare(context->mac_spm_offset + dmac_byte_offset);
        }
        mac_wait(mac_req_id);
        release_cache_block(set_index, context->tag_way);
        if (context->is_write){
            current_state = RS_SWAP_OR_EVICT;
            spm_write_back(DATA_SPM_OFFSET + 64 * list_i, request_addr, 64, 0);
            axim_write_return(context->req_id);
            return current_state;
        } else {
            current_state = RS_SET_SEED;
        }
        break;
    }
    case RS_DONE:{
        // 完了。何もしない
        return current_state;
    }
    case RS_IDLE: {
        // 未使用。何もしない
        return current_state;
    }
    case RS_DATA_WAIT: {
        if (dma_wait(context->internal_wait_id)){
            current_state = RS_DATAMAC_UPDATE;
        } else {
            return current_state;
        }
        break;
    } 
    case RS_DATAMAC_DMA:{
        dram_addr_t mac_addr = get_datamacblock_addr(request_addr);
        index_t set_index = get_cache_set_index(mac_addr);
        struct Info mac_info = tag_check(mac_addr);
        if (mac_info.way < 0){
            printf("Error: No way found for datamac block at address 0x%lx\n", mac_addr);
            return current_state;
        }
        context->mac_spm_offset = mac_info.spm_offset;
        context->tag_hit = mac_info.hit;
        dma_id_t dma_id = *global_dma_id;
        if (context->tag_hit == false){
            dma_id++;
            dma_id = ensureBlockInSpm(mac_addr, mac_info, dma_id);
            context->wait_tag_dma_id = dma_id;
        }
        *global_dma_id = dma_id;
        acquire_cache_block(set_index, mac_info.way);
        context->tag_way = mac_info.way;
        current_state = RS_DATAMAC_UPDATE;
        break;
      } case RS_AES_XOR_WAIT: {
        if (!AES_START_REG && aes_lock == context->req_id){
            if (context->is_write){
                xor_start(true, false, context->req_id, DATA_SPM_OFFSET + 64 * list_i);
                current_state = RS_DATAMAC_UPDATE;
                aes_lock = -1;
            } else {
                current_state = RS_SWAP_OR_EVICT;
                aes_lock = -1;
                // write_xor(DATA_SPM_OFFSET + 64 * i);
                xor_start(false, true, context->req_id,DATA_SPM_OFFSET + 64 * list_i);
                aes_lock = -1;
                axim_read_return(context->req_id);
                return current_state;
            }
        } else {
            return current_state;
        }
        break;
      } case RS_SET_SEED: {
        if (aes_lock != -1){
            return current_state;
        }
        uint64_t major_counter = spm_ld64(context->path_spm_offsets[HEIGHT - 1]);
        uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
        uint64_t minor_counter = spm_ld64(context->path_spm_offsets[HEIGHT - 1] + (counter_bit_offset / 64) * 8);
        uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64) )) & 0xFF;
        set_seed(major_counter, minor_counter_value, request_addr);
        aes_lock = context->req_id;
        current_state = RS_AES_XOR_WAIT;
        break;
    }
    case RS_ERROR:{
        exit(1);
        return current_state;
    }
    default:{
        printf("Unknown state encountered\n");
        return current_state;
    }        
  }
    // uint64_t end_instret = read_instret();
    // printf("Process %d: State %d took %lu instructions\n", list_i, current_state, end_instret - start_instret);
}
  return current_state;
}


int main(void){
  // SPMの初期化
  for (uint64_t i=0; i<512; i++){
    spm_sd64(i*8, 0); 
  }
  SPM_SIZE_REG = 64;
  for (uint64_t i=0;i<HEIGHT+1;i++){
      level_base[i] = calculate_level_base_addr(i) + COUNTER_BASE;
  }
  // rootノードの初期化
  spm_sd64(0,1);
  init_cache_system();
  temp_system_init(CACHE_DATA_SPM_BASE + TOTAL_SLOTS * 64);
  dma_id_t dma_id = 0;
  int active_processes = 0;
  const int MAX_PROCESSES = 3;
  AddressContext process_list[3] = {0};
  req_state_t states[3] = {RS_IDLE};
  dram_addr_t request_addr[3] = {0};
  //   空きスロット管理
  int free_slots[3] = {0};
  for (int i=0;i<MAX_PROCESSES;i++){
    free_slots[i] = MAX_PROCESSES - 1 - i;
  }
  int free_slot_top = MAX_PROCESSES - 1;
  uint32_t instr_list[1] = {0};
  uint64_t start_instrt, end_instrt;
  while(1){
    // リクエスト待ち
    while(1){
      if (AXIM_STATUS_REG != 0 && active_processes < MAX_PROCESSES){
        // あればリクエスト登録
        int slot = free_slots[free_slot_top--];
        dram_addr_t addr = AXIM_REQ_ADDR_REG;
        if (AXIM_STATUS_REG & 2){ // writeリクエスト
            process_list[slot].is_write = true;
        } else {
            process_list[slot].is_write = false;
        }
        uint32_t req_id = AXIM_REQ_ID_REG;
        active_processes++;
        request_addr[slot] = addr;
        process_list[slot].req_id = req_id;
        states[slot] = RS_PATH_TAG_WALK;
        process_list[slot].load_start_index = 0;
        start_instrt = read_instret();
      } else {
        break;
      }
    }
    int i = 0;
    if (active_processes == 0){
        continue;
    }
    while(1){
      if (states[i] == RS_DONE){
          // スロットを解放
          free_slots[++free_slot_top] = i;
          active_processes--;
          states[i] = RS_IDLE;
          break;
      } else if (states[i] != RS_IDLE){
        states[i] = step(&process_list[i], i, &dma_id, states[i],request_addr[i]);
        // uint64_t elapsed = end_instrt - start_instrt;
        // if (states[i] != state){
        //     printf("Process %d: State changed from %d to %d, elapsed instret: %lu\n", i, state, states[i], elapsed);
        // } else {
        //     printf("Process %d: State %d unchanged, elapsed instret: %lu\n", i, state, elapsed);
        // }
      }
      i = (i + 1) % MAX_PROCESSES;
    }
  } 
}

