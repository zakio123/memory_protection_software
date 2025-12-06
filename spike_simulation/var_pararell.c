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
    dram_addr_t request_addr;
    bool is_write;
    uint32_t req_id;
    req_state_t state;
    spm_offset_t path_spm_offsets[HEIGHT];
    dram_addr_t path_dram_addrs[HEIGHT];
    uint64_t path_indecis[HEIGHT];
    int temp_index[HEIGHT];
    spm_offset_t mac_spm_offset;
    uint32_t load_start_index;
    dma_id_t internal_wait_id;
    mac_t computed_mac;
    index_t root_way;
    index_t tag_way;
    bool tag_hit;
    dma_id_t wait_tag_dma_id;
    bool load_needed[HEIGHT];
} AddressContext;

// 各ステップの処理
dram_addr_t level_base[HEIGHT+1] = {0};
// 引数: コンテキスト構造体へのポインタ、プロセスリスト内のインデックス、dma_idのポインタ
static inline void step(AddressContext *context, index_t list_i, dma_id_t *global_dma_id) {
    // 状態に応じた処理を行う
  switch (context->state) {
    case RS_PATH_TAG_WALK:{
        // パス計算 + light_tag_check + パス上DMA発行
        context->internal_wait_id = *global_dma_id;
        bool load_needed[HEIGHT] = {0};
        uint64_t start_instret = read_instret();
        for(uint64_t i=0; i<HEIGHT; ++i){
            uint64_t index = (context->request_addr - PROTECTION_BASE) / (64  * (1ULL << (5 * i)));
            context->path_indecis[HEIGHT - 1 - i ] = index;
            dram_addr_t dram_addr = COUNTER_BASE + index / 32 * 64 + level_base[HEIGHT - i];
            bool hit = light_tag_check(dram_addr);
            if (hit){
                context->load_start_index = HEIGHT - i;
                struct Info info = tag_check(dram_addr);
                context->path_spm_offsets[HEIGHT - 1 - i] = info.spm_offset;
                context->path_dram_addrs[HEIGHT - 1 - i] = dram_addr;
                context->root_way = info.way;
                context->temp_index[HEIGHT - 1 - i] = -1;
                acquire_cache_block(dram_addr, info.way);
                break;
            } else {
                context->path_dram_addrs[HEIGHT - 1 - i] = dram_addr;
            }
        }
        uint64_t end_instret = read_instret();
        printf("[Core FW] Path tag walk instret: %llu  start index %llu\n", end_instret - start_instret,context->load_start_index);
        // SPMへのロード
        for (uint64_t i = context->load_start_index;i<HEIGHT;i++){
            dram_addr_t dram_addr = context->path_dram_addrs[i];
            int temp_idx = find_temp_entry(dram_addr);
            if (temp_idx == -1){
                uint64_t start_instret_0 = read_instret();
                (*global_dma_id)++;
                context->load_needed[i] = true;
                context->path_spm_offsets[i] = pop_temp_buffer();
                spm_copy_to_local(dram_addr, context->path_spm_offsets[i], 64, *global_dma_id);
                temp_idx = alloc_temp_entry(dram_addr, context->path_spm_offsets[i]);
                uint64_t end_instret_0 = read_instret();
                printf("[Core FW] Alloc temp entry instret level %llu: %llu\n", i, end_instret_0 - start_instret_0);
            } else {
                context->load_needed[i] = false;
                context->path_spm_offsets[i] = get_temp_spm_offset(temp_idx);
            }
            context->temp_index[i] = temp_idx;
            acquire_temp_entry_by_index(temp_idx);
        }
        // データブロック
        if (!context->is_write){
            (*global_dma_id)++;
            spm_copy_to_local(context->request_addr, DATA_SPM_OFFSET + 64 * list_i, 64, (*global_dma_id));            
        }
        context->state = RS_PATH_VERIFY;
        break;
    }
    case RS_PATH_VERIFY:{
        // verify_one_heightをレベルごとに回す
        for (uint64_t i = context->load_start_index;i<HEIGHT;i++){
            uint32_t parent_spm = (i == 0) ? 0 : context->path_spm_offsets[i-1];
            if (context->load_needed[i]){
                context->internal_wait_id += 1;
                spm_wait(context->internal_wait_id);
                set_loaded_temp_entry_by_index(context->temp_index[i]);
            } else {
                while (is_loaded_temp_entry_by_index(context->temp_index[i]) == false) {
                    // スピン
                }
            }
            bool verify = verify_one_height(context->path_spm_offsets[i], parent_spm, context->path_indecis[i], context->internal_wait_id);
            if (verify == false){
                printf("[Core FW] Verification failed at level %llu\n", i);
                context->state = RS_ERROR;
            }
        }
        if (context->is_write){
            context->state = RS_UPDATE_COUNTER;
        } else {
            context->state = RS_SET_SEED;
        }
        context->internal_wait_id += 1;
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
            uint64_t minor_counter_byte_address = context->path_spm_offsets[start_level] + 8 + (context->path_indecis[start_level] % 32) / 8 * 8;
            uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
            // ここから過去のminor counterを取り出す
            uint8_t minor_counter_value = (minor_counter >> ((context->path_indecis[start_level] % 8) * 8)) & 0xFF;
            uint8_t new_minor_counter = 0;
            if (minor_counter_value == 0xFF){
                // uint64_t new_major_counter = major_counter + 1;
                // spm_sd64(spm_offset_array[load_start_index - 1], new_major_counter);
                new_minor_counter = 0; 
            } else {
                new_minor_counter = minor_counter_value + 1;
            }
            uint64_t shift_amount = (context->path_indecis[start_level] % 8) * 8;
            uint64_t clear_mask = ~(0xFFULL << shift_amount);
            uint64_t cleared_minor_counter = minor_counter & clear_mask;
            uint64_t shifted_new_value = (new_minor_counter);
            shifted_new_value <<= shift_amount;
            uint64_t final_word = cleared_minor_counter | shifted_new_value;
            // 書き戻し
            spm_sd64(minor_counter_byte_address, final_word);
            // 一時的なルートなので、parent updatedはfalseにしておく
            clearParentUpdated(context->path_dram_addrs[start_level], context->root_way);
            setBlockdirty(context->path_dram_addrs[start_level], context->root_way);
        }
        context->state = RS_TREE_UPDATE;
        break;
    }
    case RS_TREE_UPDATE:{
        // update_one_height で木を更新
        for (uint64_t i=context->load_start_index;i<HEIGHT;i++){
            update_one_height(context->path_spm_offsets[i], (i==0)?0:context->path_spm_offsets[i-1], context->path_indecis[i], true);
            dirty_temp_entry_by_index(context->temp_index[i]);
        }
        context->state = RS_SET_SEED;
        break;
    }
    case RS_SWAP_OR_EVICT:{
        // temp <-> cache スワップ & lazy update
        // キャッシュしていたノードのref_countを減らす
        if (context->load_start_index > 0){
            release_cache_block(context->path_dram_addrs[context->load_start_index - 1], context->root_way);
        }
        for (uint64_t i = context->load_start_index;i<HEIGHT;i++){

            uint64_t start_instret_0 = read_instret();
            release_temp_entry_by_index(context->temp_index[i]);
            uint64_t end_instret_0 = read_instret();
            uint64_t start_instret_1=0;
            uint64_t end_instret_1=0;
            uint64_t start_instret_2 =0; uint64_t end_instret_2=0;
            uint64_t start_instret_3 =0; uint64_t end_instret_3=0;
            uint64_t start_instret_4 =0; uint64_t end_instret_4=0;
            uint64_t start_instret = read_instret();
            if (swappable_temp_entry_by_index(context->temp_index[i])){
                start_instret_1 = read_instret();
                struct Info info_i = tag_check(context->path_dram_addrs[i]);
                end_instret_1 = read_instret();
                start_instret_2 = read_instret();
                bool mac_updated = is_mac_updated(context->path_dram_addrs[i], info_i.way);
                end_instret_2 = read_instret();
                start_instret_3 = read_instret();
                bool dirty = is_dirty_temp_entry_by_index(context->temp_index[i]);
                end_instret_3 = read_instret();
                if (mac_updated){
                    // swappして良い
                    start_instret_4 = read_instret();
                    swapp_temp_cache(context->path_dram_addrs[i], info_i, context->path_spm_offsets[i], dirty);
                    setParentUpdated(context->path_dram_addrs[i], info_i.way);
                    end_instret_4 = read_instret();
                } else{
                    // temp_id = evicted_node_update(info_i, temp_id);
                    // swapp_temp_cache(context->path_dram_addrs[i], info_i, context->path_spm_offsets[i], dirty);
                    start_instret_4 = read_instret();
                    spm_write_back(context->path_spm_offsets[i], context->path_dram_addrs[i], 64, 0);
                    push_temp_buffer(context->path_spm_offsets[i]);
                    end_instret_4 = read_instret();
                }
                invalidate_temp_entry_by_index(context->temp_index[i]);
            }
            uint64_t end_instret = read_instret();
            // printf("[Core FW] Swap/Evict instret level %llu: %llu\n", i, end_instret - start_instret);
            // printf("  release_temp_entry: %llu\n", end_instret_0 - start_instret_0);
            // printf("  tag_check: %llu\n", end_instret_1 - start_instret_1);
            // printf("  is_mac_updated: %llu\n", end_instret_2 - start_instret_2);
            // printf("  is_dirty_temp_entry: %llu\n", end_instret_3 - start_instret_3);
            // printf("  swapp/evict: %llu\n", end_instret_4 - start_instret_4);
        }
        context->state = RS_DONE;
        break;
    }
    case RS_SET_SEED:{
        if (aes_lock != -1){
            break;
        }
        uint64_t major_counter = spm_ld64(context->path_spm_offsets[HEIGHT-1]);
        uint64_t counter_bit_offset = 64 + (context->request_addr / 64) % 32 * 8;
        uint64_t minor_counter = spm_ld64(context->path_spm_offsets[HEIGHT-1] + (counter_bit_offset / 64) * 8);
        uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64) )) & 0xFF;
        set_seed(major_counter, minor_counter_value, context->request_addr);
        aes_lock = context->req_id;
        if (context->is_write){
            context->state = RS_AES_XOR_WAIT;
        } else {
            context->state = RS_DATA_WAIT;
        }
        break;
    }
    case RS_DATAMAC_VERIFY_AUTHENTICATE:{
        // データMACの検証/認証
        dram_addr_t dmac_byte_offset = ((context->request_addr - PROTECTION_BASE) / 64) % 8 * 8;
        dram_addr_t datamac_addr = get_datamacblock_addr(context->request_addr);
        if (context->is_write){
            // 書き込みの場合はMACを書き込むだけ
            spm_sd64(context->mac_spm_offset + dmac_byte_offset, context->computed_mac);
            setBlockdirty(datamac_addr, context->tag_way);
            context->state = RS_SWAP_OR_EVICT;
        } else {
            mac_t stored_mac = spm_ld64(context->mac_spm_offset + dmac_byte_offset);
            if (context->computed_mac != stored_mac){
                printf("[Core FW] Data MAC verification failed: computed=%016llx, stored=%016llx\n", context->computed_mac, stored_mac);
                context->state = RS_ERROR;
                // 色々な情報を表示
                printf("Request address: %016llx\n", context->request_addr);
                printf("Data MAC block address: %016llx\n", datamac_addr);
                printf("Tag way: %d\n", context->tag_way);
                printf("Request ID: %d\n", context->req_id);
                printf("Path SPM Offsets:\n");
                for (int i = 0; i < HEIGHT; i++) {
                    printf("  Level %d: %016llx\n", i, context->path_spm_offsets[i]);
                }
                printf("Path DRAM Addresses:\n");
                for (int i = 0; i < HEIGHT; i++) {
                    printf("  Level %d: %016llx\n", i, context->path_dram_addrs[i]);
                }
                printf("load start index: %d\n", context->load_start_index);
                printf("Temp indices:\n");
                for (int i = 0; i < HEIGHT; i++) {
                    printf("  Level %d: %d\n", i, context->temp_index[i]);
                }
                for (int i = 0;i<8;i++){
                    uint64_t mac_part = spm_ld64(context->mac_spm_offset + i * 8);
                    printf("MAC part %d: %016llx\n", i, mac_part);
                }
                for (int i = 0;i<8;i++){
                    uint64_t data_part = spm_ld64(context->path_spm_offsets[HEIGHT-1] + 64 * list_i + i * 8);
                    printf("Counter part %d: %016llx\n", i, data_part);
                }
                return;
            }
            context->state = RS_AES_XOR_WAIT;
        }
        release_cache_block(datamac_addr, context->tag_way);
        break;
    }
    case RS_AES_XOR_WAIT:{
        if (!AES_START_REG && aes_lock == context->req_id){
            if (context->is_write){
                xor_start(true, false, context->req_id);
                copy_xor(DATA_SPM_OFFSET + 64 * list_i);
                context->state = RS_DATAMAC_DMA;
                aes_lock = -1;
            } else {
                context->state = RS_SWAP_OR_EVICT;
            }
        }
        break;
    }
    case RS_DATAMAC_UPDATE:{
        // MAC計算のためのデータ設定
        mac_init();
        mac_buffer_set(DATA_SPM_OFFSET + 64 * list_i);
        mac_update(0, 511);
        mac_buffer_set(context->path_spm_offsets[HEIGHT-1]);
        uint64_t counter_bit_offset = 64 + (context->request_addr / 64) % 32 * 8;
        mac_update(counter_bit_offset, counter_bit_offset + 7);
        context->computed_mac = mac_final();
        context->state = RS_DATAMAC_WAIT;
        break;
    }
    // case RS_MAC_FINAL:{
    //     // MAC 計算&比較/書き込み
    //     context->computed_mac = mac_final();
    //     context->state = RS_DATAMAC_WAIT;
    //     break;
    // }
    case RS_DONE:{
        // 完了。何もしない
        break;
    }
    case RS_ERROR:{
        exit(1);
        break;
    }
    default:{
        printf("Unknown state encountered\n");
        break;
    }        
  }
  return;
}


int main(void){
  // SPMの初期化
  for (uint64_t i=0; i<512; i++){
    spm_sd64(i*8, 0); 
  }
  SPM_SIZE_REG = 64;
  for (uint64_t i=0;i<HEIGHT+1;i++){
      level_base[i] = calculate_level_base_addr(i);
  }
  // rootノードの初期化
  spm_sd64(0,1);
  init_cache_system();
  temp_system_init(CACHE_DATA_SPM_BASE + CACHE_SETS * CACHE_WAYS * 64);
  dma_id_t dma_id = 0;
  int active_processes = 0;
  int MAX_PROCESSES = 3;
  AddressContext process_list[3] = {0};
  //   空きスロット管理
  int free_slots[3] = {0,1,2};
  int free_slot_top = MAX_PROCESSES - 1;
  while(1){
    // リクエスト待ち
    for(;;){
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
        process_list[slot].request_addr = addr;
        process_list[slot].req_id = req_id;
        process_list[slot].state = RS_PATH_TAG_WALK;
        process_list[slot].load_start_index = 0;
      } else {
        break;
      }
    }
    for (int i=0;i<MAX_PROCESSES;i++){
      if (process_list[i].state == RS_DONE){
          if (process_list[i].is_write){
            spm_write_back(DATA_SPM_OFFSET + 64 * i, process_list[i].request_addr, 64, 0);
            axim_write_return(process_list[i].req_id);
          } else {
            if (aes_lock != process_list[i].req_id){
                continue;
            }
            write_xor(DATA_SPM_OFFSET + 64 * i);
            xor_start(false, true, process_list[i].req_id);
            aes_lock = -1;
            axim_read_return(process_list[i].req_id);
          }
          // スロットを解放
          free_slots[++free_slot_top] = i;
          active_processes--;
          process_list[i].state = RS_IDLE;
          process_list[i].request_addr = 0;
          process_list[i].is_write = false;
          process_list[i].req_id = 0;
      } else if (process_list[i].state == RS_IDLE) {
          continue;
      } else if (process_list[i].state == RS_DATAMAC_WAIT) {
            // DMA待ち
            dram_addr_t mac_addr = get_datamacblock_addr(process_list[i].request_addr);
            if (process_list[i].tag_hit == false){
                if (dma_wait(process_list[i].wait_tag_dma_id)){
                    process_list[i].state = RS_DATAMAC_VERIFY_AUTHENTICATE;
                    set_loaded(mac_addr, process_list[i].tag_way);
                }
            } else if (is_loaded(mac_addr, process_list[i].tag_way)){
                process_list[i].state = RS_DATAMAC_VERIFY_AUTHENTICATE;
            } else {
                continue;
            }
      } else if (process_list[i].state == RS_DATA_WAIT) {
          // DMA待ち
        if (dma_wait(process_list[i].internal_wait_id)){
            process_list[i].state = RS_DATAMAC_DMA;
        }
      } else if (process_list[i].state == RS_DATAMAC_DMA){
            dram_addr_t mac_addr = get_datamacblock_addr(process_list[i].request_addr);
            struct Info mac_info = tag_check(mac_addr);
            if (mac_info.way < 0){
                printf("[Core FW] Error: No valid way found for Data MAC block addr=%016llx\n", mac_addr);
                // exit(1);
                continue;
            }
            process_list[i].mac_spm_offset = mac_info.spm_offset;
            process_list[i].tag_way = mac_info.way;
            process_list[i].tag_hit = mac_info.hit;
            if (process_list[i].tag_hit == false){
                dma_id++;
                dma_id_t wait_tag_dma_id = ensureBlockInSpm(mac_addr, mac_info, dma_id);
                process_list[i].wait_tag_dma_id = wait_tag_dma_id;
                dma_id = wait_tag_dma_id;
            }
            acquire_cache_block(mac_addr, process_list[i].tag_way);
            process_list[i].state = RS_DATAMAC_UPDATE;
      } else {
        uint64_t start_instret = read_instret();
        step(&process_list[i], i, &dma_id);
        uint64_t end_instret = read_instret();
        printf("[Core FW] Process %d step instret: %llu state : %d\n", i, end_instret - start_instret, process_list[i].state);
      }
    }
  }
}