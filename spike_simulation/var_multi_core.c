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

uint64_t global_mac_req_id = 0;
dma_id_t global_dma_id = 0;

dram_addr_t level_base[HEIGHT + 1] = {0};

volatile bool init_done = false;


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
      dram_addr_t dram_addr = COUNTER_BASE + index / 32 * 64 + calculate_level_base_addr(HEIGHT - i);
      dram_addr_array[HEIGHT - 1 - i] = dram_addr;
      long set_index = get_cache_tree_set_index(dram_addr);
      lock_dma();
      light_tag_info_t info = light_tag_check(dram_addr);
      dma_id_t tmp_id = global_dma_id;
      if (info.hit){
        spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, info.way);
        update_lru_on_access(set_index, info.way);
        unlock_dma();
        load_start_index = HEIGHT - i;
        spm_offset_array[HEIGHT - 1 - i] = spm_offset;
        way_index = info.way;
        wait_dma_id[HEIGHT - 1 - i] = tmp_id;
        break;
      } else {
        long idx = find_temp_entry(dram_addr);
        spm_offset_t spm_offset;
        if (idx == -1){
          spm_offset = pop_temp_buffer();
          idx = alloc_temp_entry(dram_addr, spm_offset);
          tmp_id += 1;
          spm_copy_to_local(dram_addr, spm_offset, 64, tmp_id);
        } else {
          spm_offset = get_temp_spm_offset(idx);
        }
        acquire_temp_entry_by_index(idx);
        global_dma_id = tmp_id;
        unlock_dma();
        wait_dma_id[HEIGHT - 1 - i] = tmp_id;
        spm_offset_array[HEIGHT - 1 - i] = spm_offset;
      }
  }
  dram_addr_t datamacblock_addr = DATA_TAG_BASE + (((request_addr - PROTECTION_BASE) / (64 * 8))) * 64;
  index_t set_index = get_cache_set_index(datamacblock_addr);
  spm_offset_t spm_offset;
  lock_dma();
  dma_id_t tag_id = global_dma_id;
  light_tag_info_t light_info = light_tag_check(datamacblock_addr);
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
  global_dma_id = tag_id;
  unlock_dma();
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    long j = (HEIGHT + load_start_index) - 1 - i;
    spm_offset_t parent_spm = (j == 0) ? 0 : spm_offset_array[j-1];
    dma_id_t need_id = (j == 0) ? wait_dma_id[0] : wait_dma_id[j-1];
    lock_mac();
    mac_req_id = global_mac_req_id;
    mac_req_id += 1;
    verify_one_height(spm_offset_array[j], parent_spm, path_indecis[j], mac_req_id,need_id);
    global_mac_req_id = mac_req_id;
    unlock_mac();
  }
  // 一時的なルートノードのアップデート
  while(!mac_wait(mac_req_id));
  int counter = 0;
  lock_tree_write();
  if (load_start_index == 0){
    // rootノードの更新
    uint64_t root = spm_ld64(0);
    root += 1;
    spm_sd64(0, root);
  } else {
    uint64_t start_level = load_start_index - 1;
    uint64_t major_counter = spm_ld64(spm_offset_array[start_level]);
    uint64_t minor_counter_byte_address = spm_offset_array[start_level] + 8 + (path_indecis[start_level] % 32) / 8 * 8;
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
    uint64_t shift_amount = (path_indecis[load_start_index - 1] % 8) * 8;
    uint64_t clear_mask = ~(0xFFULL << shift_amount);
    uint64_t cleared_minor_counter = minor_counter & clear_mask;
    uint64_t shifted_new_value = (new_minor_counter);
    shifted_new_value <<= shift_amount;
    uint64_t final_word = cleared_minor_counter | shifted_new_value;
    // 書き戻し
    spm_sd64(minor_counter_byte_address, final_word);
    // 一時的なルートなので、parent updatedはfalseにしておく
    index_t set_index = get_cache_set_index(dram_addr_array[start_level]);
    clearParentUpdated(set_index, way_index);
    set_block_dirty(set_index, way_index);
  }
  // 木の更新：ルートから葉まで降りていく
  lock_mac();
  mac_req_id = global_mac_req_id;
  for (uint64_t i=load_start_index;i<HEIGHT;i++){
    mac_req_id += 1;
    update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], true,mac_req_id, wait_dma_id[i]);
    long idx = find_temp_entry(dram_addr_array[i]);
    dirty_temp_entry_by_index(idx);
  }
  global_mac_req_id = mac_req_id;
  unlock_mac();
  counter = 0;
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
  mac_req_id = global_mac_req_id;
  mac_init(mac_req_id);
  mac_buffer_set(DATA_SPM_OFFSET + hartid * 64, tag_id); 
  mac_update(0, 511);
  mac_buffer_set(spm_offset_array[HEIGHT-1], tag_id);
  mac_update(0,63);
  mac_update(counter_bit_offset, counter_bit_offset + 7);
  mac_digest(spm_offset + ((request_addr - PROTECTION_BASE) / 64) % 8 * 8, tag_id);
  unlock_mac();
  counter = 0;
  for (;;){
    counter += 1;
    if (mac_wait(mac_req_id)) break;
    else if (counter > 1000){
      lock_print();
      printf("Core %d waiting for MAC digest req_id %d\n", hartid, mac_req_id);
      unlock_print();
      counter = 0;
    }
  }
  unlock_tree_write();
  lock_dma();
  set_block_dirty(set_index, light_info.way);
  spm_write_back(DATA_SPM_OFFSET + hartid * 64, request_addr, 64, 0);
  while(!mac_wait(mac_req_id));
  unlock_dma();
  axim_write_return(req_id);
  // スワップ
  release_cache_block(set_index, light_info.way);
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    dram_addr_t dram_addr = dram_addr_array[i];
    lock_dma();
    long idx = find_temp_entry(dram_addr);
    release_temp_entry_by_index(idx);
    bool swapable_temp =  swappable_temp_entry_by_index(idx);
    if (swapable_temp){
        light_tag_info_t light_info = light_tag_check(dram_addr);
        index_t set_index = get_cache_set_index(dram_addr);
        if (light_info.way == -1){
            light_info.way = get_victim_way(get_cache_set_index(dram_addr));
        } else {
            // valid化
            set_block_valid(set_index, light_info.way);
        }
        bool swappable_cache = swappable_cache_block(set_index, light_info.way);
        spm_offset_t temp_spm = get_temp_spm_offset(idx);
        if (swappable_cache){
            bool mac_updated = is_mac_updated(set_index, light_info.way);
            bool temp_dirty = is_dirty_temp_entry_by_index(idx);
            if (mac_updated){
                // swapする
                swapp_temp_cache(dram_addr, temp_spm, temp_dirty, light_info.way);
                setParentUpdated(set_index, light_info.way);
            } else{
                if (temp_dirty){
                    spm_write_back(temp_spm, dram_addr, 64, 0);
                }
                push_temp_buffer(temp_spm);
            }
        } else {
            bool temp_dirty = is_dirty_temp_entry_by_index(idx);
            if (temp_dirty){
                spm_write_back(temp_spm, dram_addr, 64, 0);
            }
            push_temp_buffer(temp_spm);
        }
        invalidate_temp_entry_by_index(idx);
        unlock_dma();
    } else {  
      unlock_dma();
      continue;
    }
  }
}

void Verification(dram_addr_t request_addr, uint64_t req_id, int hartid){
  uint64_t start_time = read_instret();
  lock_tree_read();
  uint64_t path_indecis[HEIGHT];
  spm_offset_t spm_offset_array[HEIGHT];
  dram_addr_t dram_addr_array[HEIGHT];
  uint64_t load_start_index = 0;
  dma_id_t wait_dma_id[HEIGHT];
  index_t way_index = 0;
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
      lock_dma();
      light_tag_info_t info = light_tag_check(dram_addr);
      long temp_idx = -1;
      uint64_t tmp_id = global_dma_id;
      if (info.hit){
        long set_index = get_cache_tree_set_index(dram_addr);
        way_index = info.way;
        spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way_index);
        update_lru_on_access(set_index, way_index);
        unlock_dma();
        spm_offset_array[HEIGHT - 1 - i] = spm_offset;
        wait_dma_id[HEIGHT - 1 - i] = tmp_id;
        load_start_index = HEIGHT - i;
        break;
      } else {
        long idx = find_temp_entry(dram_addr);
        spm_offset_t spm_offset;
        if (idx == -1){
          spm_offset = pop_temp_buffer();
          idx = alloc_temp_entry(dram_addr, spm_offset);
          tmp_id += 1;
          spm_copy_to_local(dram_addr, spm_offset, 64, tmp_id);
        } else {
          spm_offset = get_temp_spm_offset(idx);
        }
        acquire_temp_entry_by_index(idx);
        global_dma_id = tmp_id;
        unlock_dma();
        wait_dma_id[HEIGHT - 1 - i] = tmp_id;
        spm_offset_array[HEIGHT - 1 - i] = spm_offset;
      }
      index = index >> 5;
  }
  uint64_t tag_path_check_e = read_instret();
  uint64_t datamac_dma_s = read_instret();
  dram_addr_t datamacblock_addr = get_datamacblock_addr(request_addr);
  index_t set_index = get_cache_set_index(datamacblock_addr);
  spm_offset_t spm_offset;
  lock_dma();
  dma_id_t tag_id = global_dma_id;
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
  acquire_cache_block(set_index, light_info.way);
  global_dma_id = tag_id;
  unlock_dma();
  uint64_t datamac_dma_e = read_instret();
  uint64_t verify_s = read_instret();
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    long j = (HEIGHT + load_start_index) - 1 - i;
    spm_offset_t parent_spm = (j == 0) ? 0 : spm_offset_array[j-1];
    dma_id_t need_id = (j == 0) ? wait_dma_id[0] : wait_dma_id[j-1];
    lock_mac();
    uint64_t mac_req_id = global_mac_req_id;
    mac_req_id += 1;
    verify_one_height(spm_offset_array[j], parent_spm, path_indecis[j], mac_req_id,need_id);
    global_mac_req_id = mac_req_id;
    unlock_mac();
  }
  uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
  spm_offset_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
  lock_mac();
  uint64_t mac_req_id = global_mac_req_id + 1;
  global_mac_req_id = mac_req_id;
  mac_init(mac_req_id);
  mac_buffer_set(DATA_SPM_OFFSET + hartid * 64,data_id);
  mac_update(0, 511);
  mac_buffer_set(spm_offset_array[HEIGHT-1],wait_dma_id[HEIGHT-1]);
  mac_update(0,63);
  mac_update(counter_bit_offset, counter_bit_offset + 7);
  mac_result_compare(spm_offset + dmac_byte_offset, tag_id);
  uint64_t verify_e = read_instret();
  unlock_mac();
  uint64_t wait_s = read_instret();
  dma_id_t wait_id = wait_dma_id[HEIGHT-1];
  int spm_wait_counter = 0;
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
  release_cache_block(set_index, light_info.way);
  uint64_t response_e = read_instret();
  unlock_tree_read();
  uint64_t start_swapp_time = read_instret();
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    dram_addr_t dram_addr = dram_addr_array[i];
    lock_dma();
    long idx = find_temp_entry(dram_addr);
    release_temp_entry_by_index(idx);
    bool swapable_temp = swappable_temp_entry_by_index(idx);
    if (swapable_temp){
        light_tag_info_t light_info = light_tag_check(dram_addr);
        index_t set_index = get_cache_set_index(dram_addr);
        if (light_info.way == -1){
            light_info.way = get_victim_way(get_cache_set_index(dram_addr));
        } else {
            // valid化
            set_block_valid(set_index, light_info.way);
        }
        bool swappable_cache = swappable_cache_block(set_index, light_info.way);
        spm_offset_t temp_spm = get_temp_spm_offset(idx);
        if (swappable_cache){
            bool mac_updated = is_mac_updated(set_index, light_info.way);
            bool temp_dirty = is_dirty_temp_entry_by_index(idx);
            if (mac_updated){
                // swapする
                swapp_temp_cache(dram_addr, temp_spm, temp_dirty, light_info.way);
                setParentUpdated(set_index, light_info.way);
            } else{
                if (temp_dirty){
                    spm_write_back(temp_spm, dram_addr, 64, 0);
                }
                push_temp_buffer(temp_spm);
            }
        } else {
            bool temp_dirty = is_dirty_temp_entry_by_index(idx);
            if (temp_dirty){
                spm_write_back(temp_spm, dram_addr, 64, 0);
            }
            push_temp_buffer(temp_spm);
        }
        invalidate_temp_entry_by_index(idx);
        unlock_dma();
    } else {
      unlock_dma();  
      continue;
    }
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
  for (int i=0; i<HEIGHT+1; i++){
    level_base[i] = calculate_level_base_addr(i) + COUNTER_BASE;
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
      // lock_print();
      // printf("Processed requests: %d hart_id %d\n", total, hart_id);
      // unlock_print();
      instret_dump = true;
    } else {
      instret_dump = false;
    }
    total += 1;
    uint64_t verify_start, verify_end;
    if(is_write){ // writeリクエスト
      verify_start = read_instret();
      Authentication(addr,req_id, hart_id);
      verify_end = read_instret();
    } else {
      verify_start = read_instret();
      Verification(addr,req_id, hart_id);
      verify_end = read_instret();
    }
  }
}