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
static const uint64_t MAC_UPD_0_511 = ((uint64_t)511 << 48) | 2;
static const uint64_t MAC_UPD_0_63  = ((uint64_t)63  << 48) | 2;
static inline uint64_t read_instret() {
    uint64_t val;
    asm volatile ("csrr %0, minstret" : "=r" (val));
    return val;
}

bool instret_dump = false;


dma_id_t Authentication(dma_id_t id, dram_addr_t request_addr, uint32_t req_id){
  uint32_t mac_req_id = req_id;
  // HEIGHT-1がリーフ、0が高さ1
  uint64_t path_indecis[HEIGHT] = {0};
  spm_offset_t spm_offset_array[HEIGHT] = {0};
  dram_addr_t dram_addr_array[HEIGHT] = {0};
  int temp_idx_array[HEIGHT] = {0};
  uint64_t load_start_index = 0;
  index_t way_index = 0;
  for(uint64_t i=0; i<HEIGHT; ++i){
      uint64_t index = (request_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * i)));
      path_indecis[HEIGHT - 1 - i ] = index;
      dram_addr_t dram_addr = COUNTER_BASE + index / 32 * 64 + calculate_level_base_addr(HEIGHT - i);
      dram_addr_array[HEIGHT - 1 - i] = dram_addr;
      #ifdef ENABLE_TMU_HARDWARE
      struct Info info = tag_check(dram_addr);
      if (info.hit){
        load_start_index = HEIGHT - i;
        spm_offset_array[HEIGHT - 1 - i] = info.spm_offset;
        way_index = info.way;
        temp_idx_array[HEIGHT - 1 - i] = -1;
        index_t set_index = get_cache_set_index(dram_addr);
        break;
      }
      #else
      light_tag_info_t info = light_tag_check(dram_addr);
      if (info.hit){
        load_start_index = HEIGHT - i;
        struct Info info = tag_check(dram_addr);
        spm_offset_array[HEIGHT - 1 - i] = info.spm_offset;
        way_index = info.way;
        temp_idx_array[HEIGHT - 1 - i] = -1;
        index_t set_index = get_cache_set_index(dram_addr);
        // printf("tree verification node cache acquire S:%u W:%u\n", set_index, info.way);
        // acquire_cache_block(set_index, info.way);
        break;
      }
      #endif
  }
  dma_id_t tmp_id = id;
  // 上から順にSPMにロード
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
      tmp_id += 1;
      spm_offset_array[i] = pop_temp_buffer();
      dram_addr_t dram_addr = dram_addr_array[i];
      spm_offset_t spm_offset = spm_offset_array[i];
      temp_idx_array[i] = alloc_temp_entry(dram_addr, spm_offset);
      spm_copy_to_local(dram_addr, spm_offset, 64, tmp_id);
      acquire_temp_entry_by_index(temp_idx_array[i]);
  }
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    uint32_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    id += 1;
    mac_req_id += 1;
    // spm_wait(id);
    verify_one_height(spm_offset_array[i], parent_spm, path_indecis[i], mac_req_id, id);
  }
  spm_wait(id);
  // 一時的なルートノードのアップデート
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
  for (uint64_t i=load_start_index;i<HEIGHT;i++){
    mac_req_id += 1;
    update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], true,mac_req_id, id);
  }
  // スワップ
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    struct Info info_i = tag_check(dram_addr_array[i]);
    index_t set_index = get_cache_set_index(dram_addr_array[i]);
    bool mac_updated = is_mac_updated(set_index, info_i.way);
    release_temp_entry_by_index(temp_idx_array[i]);
    if (mac_updated){
      // swappして良い
      // spm_write_back(spm_offset_array[i], dram_addr_array[i], 64, 0);
      swapp_temp_cache(dram_addr_array[i], info_i, spm_offset_array[i],true);
      setParentUpdated(set_index, info_i.way);
    } else{
      // id = evicted_node_update(info_i, id);
      // swapp_temp_cache(dram_addr_array[i], info_i, spm_offset_array[i], true);
      spm_write_back(spm_offset_array[i], dram_addr_array[i], 64, 0);
      push_temp_buffer(spm_offset_array[i]);
    }
    invalidate_temp_entry_by_index(temp_idx_array[i]);
  }
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
  set_seed(major_counter, minor_counter_value, request_addr);
  dram_addr_t datamacblock_addr = DATA_TAG_BASE + (((request_addr - PROTECTION_BASE) / (64 * 8))) * 64;
  struct Info tag_info = tag_check(datamacblock_addr);
  dma_id_t tag_id = id;
  if (!tag_info.hit){
    tag_id += 1;
    ensureBlockInSpm(datamacblock_addr, tag_info, tag_id);
  }
  index_t set_index = get_cache_set_index(datamacblock_addr);
  acquire_cache_block(set_index, tag_info.way);
  while(AES_START_REG);
  xor_start(true, false,req_id,DATA_SPM_OFFSET);
  // --- 手順3: MAC計算 ---
  mac_req_id += 1;
  mac_init(mac_req_id);
  mac_buffer_set(DATA_SPM_OFFSET, tag_id); 
  mac_update(0, 511);
  mac_buffer_set(spm_offset_array[HEIGHT-1], tag_id);
  mac_update(0,63);
  mac_update(counter_bit_offset, counter_bit_offset + 7);
  // if (!tag_info.hit){
  //   spm_wait(tag_id);
  // }
  // MAC計算完了
  mac_digest(tag_info.spm_offset + ((request_addr - PROTECTION_BASE) / 64) % 8 * 8, tag_id);
  set_block_dirty(set_index, tag_info.way);
  spm_write_back(DATA_SPM_OFFSET, request_addr, 64, 0);
  axim_write_return(req_id);
  mac_wait(mac_req_id);
  release_cache_block(set_index, tag_info.way);
  return tag_id;
}

dma_id_t Verification(dma_id_t id, dram_addr_t request_addr, uint64_t req_id){
  uint64_t mac_req_id = req_id;
  uint64_t start_time = read_instret();
  // HEIGHT-1がリーフ、0が高さ1
  uint64_t path_indecis[HEIGHT];
  spm_offset_t spm_offset_array[HEIGHT];
  dram_addr_t dram_addr_array[HEIGHT];
  uint64_t load_start_index = 0;
  index_t way_index = 0;
  // パス上のノードのタグチェックを行う
  uint64_t verify_start = read_instret();
  for(uint64_t i=0; i<HEIGHT; ++i){
      uint64_t index = (request_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * i)));
      path_indecis[HEIGHT - 1 - i ] = index;
      dram_addr_t dram_addr = COUNTER_BASE + index / 32 * 64 + calculate_level_base_addr(HEIGHT - i);
      dram_addr_array[HEIGHT - 1 - i] = dram_addr;
      light_tag_info_t info = light_tag_check(dram_addr);
      if (info.hit){
        load_start_index = HEIGHT - i;
        long set_index = get_cache_tree_set_index(dram_addr);
        spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, info.way);
        update_lru_on_access(set_index, info.way);
        spm_offset_array[HEIGHT - 1 - i] = spm_offset;
        way_index = info.way;
        break;
      }
  }
  uint64_t tag_end = read_instret();
  dma_id_t tmp_id = id;
  // 上から順にSPMにロード。ミスしているノードのみロード
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    tmp_id += 1;
    dram_addr_t dram_addr = dram_addr_array[i];
    spm_offset_array[i] = pop_temp_buffer();
    long temp_idx = alloc_temp_entry(dram_addr, spm_offset_array[i]);
    spm_copy_to_local(dram_addr, spm_offset_array[i], 64, tmp_id);
    acquire_temp_entry_by_index(temp_idx);
  }
  uint64_t load_end = read_instret();
  uint64_t spm_wait_time = 0;
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    spm_offset_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    id += 1;
    // uint64_t spm_wait_start = read_instret();
    // spm_wait(id);
    // uint64_t spm_wait_end = read_instret();
    // spm_wait_time += (spm_wait_end - spm_wait_start);
    mac_req_id += 1;
    verify_one_height(spm_offset_array[i], parent_spm, path_indecis[i], mac_req_id,id);
  }
  uint64_t verify_end = read_instret();
  dma_id_t data_id = id+1;
  spm_copy_to_local(request_addr, DATA_SPM_OFFSET, 64,data_id);
  uint64_t load_data_end = read_instret();
  uint64_t d_w_s = read_instret();
  spm_wait(id);
  uint64_t d_w_e = read_instret();
  uint64_t major_counter = spm_ld64(spm_offset_array[HEIGHT-1]);
  // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
  uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
  uint64_t minor_counter = spm_ld64(spm_offset_array[HEIGHT-1] + (counter_bit_offset / 64) * 8);
  uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64) )) & 0xFF;
  set_seed(major_counter, minor_counter_value, request_addr);
  uint64_t set_seed_end = read_instret();
  // SPMに当該MACブロックがあるかを確認。なければコピー。
  dram_addr_t datamacblock_addr = get_datamacblock_addr(request_addr);
  index_t set_index = get_cache_set_index(datamacblock_addr);
  dma_id_t tag_id = data_id;
  spm_offset_t spm_offset;
  struct Info tag_info = tag_check(datamacblock_addr);
  if (!tag_info.hit){ 
    tag_id += 1;
    ensureBlockInSpm(datamacblock_addr, tag_info,tag_id);
  }  
  // #endif
  acquire_cache_block(set_index, tag_info.way);
  uint64_t datamac_dma_end = read_instret();
  asm volatile ("datatag_update:");
  mac_req_id += 1;
  mac_init(mac_req_id);
  mac_buffer_set(DATA_SPM_OFFSET,data_id);
  // mac_update(0, 511);
  MAC_COMMAND = MAC_UPD_0_511;
  mac_buffer_set(spm_offset_array[HEIGHT-1],data_id);
  // mac_update(0,63);
  MAC_COMMAND = MAC_UPD_0_63;
  mac_update(counter_bit_offset, counter_bit_offset + 7);
  spm_offset_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
  mac_result_compare(tag_info.spm_offset + dmac_byte_offset, tag_id);
  uint64_t datamac_end = read_instret();
  while(AES_START_REG);
  spm_wait(data_id);
  xor_start(false, true,req_id,DATA_SPM_OFFSET);
  mac_wait(mac_req_id);
  axim_read_return(req_id);
  release_cache_block(set_index, tag_info.way);
  uint64_t end_time = read_instret();
  // swapp処理計測のための変数

  uint64_t tag_check_time=0;
  uint64_t release_time=0, push_time=0, swapp_time=0, invalidate_time=0;
  uint64_t start_swapp_time = 0;
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    dram_addr_t dram_addr = dram_addr_array[i];
    start_swapp_time = read_instret();
    // struct Info info;
    index_t set_index = get_cache_tree_set_index(dram_addr);
    uint64_t tmp = read_instret();
    long way = get_victim_way(set_index);
    bool dirty = is_block_dirty(set_index, way);
    spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way);
    dram_addr_t block_addr = get_block_addr(set_index, way);
    bool mac_updated = is_mac_updated(set_index, way);
    tag_check_time = read_instret();
    long idx = find_temp_entry(dram_addr);
    release_temp_entry_by_index(idx);
    release_time = read_instret();
    if (mac_updated){
      bool temp_dirty = is_dirty_temp_entry_by_index(idx);
      if (dirty){
          spm_write_back(spm_offset, block_addr, 64, 0);
      }
      // set_loaded(set_index, way);
      update_lru_on_access(set_index, way);
      #ifdef ENABLE_TMU_HARDWARE
        long slot_idx = (set_index * CACHE_WAYS) + way;
        long ret;
        TMU_INSN_R(F7_TMU_SET_TAG, ret, slot_idx, dram_addr_array[i]); 
        TMU_INSN_R(F7_TMU_SET_SPM, ret, slot_idx, spm_offset_array[i]); 
        if (temp_dirty){
          TMU_INSN_R(F7_TMU_SET_D, ret, slot_idx, 0); 
        } else {
          TMU_INSN_R(F7_TMU_CLEAR_D, ret, slot_idx, 0); 
        }
      #else
        valid_metadata[set_index][tag_info.way] = true;
        dirty_metadata[set_index][tag_info.way] = dirty;
        block_addr_metadata[set_index][tag_info.way] = dram_addr;
        spm_offset_metadata[set_index][tag_info.way] = spm_offset;
        ref_count_metadata[set_index][tag_info.way] = 0;
      #endif
      push_temp_buffer(spm_offset);
      // swapp_temp_cache(dram_addr_array[i], info, spm_offset_array[i], temp_dirty);
      swapp_time = read_instret();
    } else {
      // tag_id = evicted_node_update(info, tag_id);
      // // swappして良い
      // bool dirty = is_dirty_temp_entry_by_index(temp_idx_array[i]);
      // swapp_temp_cache(dram_addr_array[i], info, spm_offset_array[i], dirty);
      push_temp_buffer(spm_offset_array[i]);
      push_time = read_instret();
    }
    invalidate_temp_entry_by_index(idx);
    invalidate_time = read_instret();
    // printf("Verification swapp level %d tag_check_time:%d release_time:%d swapp_time:%d push_time:%d invalidate_time:%d or %d set index calc %d\n",
    //     i,
    //     tag_check_time - start_swapp_time,
    //     release_time - tag_check_time,
    //     swapp_time - release_time,
    //     push_time - release_time,
    //     invalidate_time - push_time,
    //     invalidate_time - swapp_time,
    //     tmp - start_swapp_time
    //   );
    //   exit(1);
  }
  uint64_t swapp_end_time = read_instret();
  if (instret_dump){
    printf("Total instret time %d\n", swapp_end_time - start_time);
    printf("tag check time %d\n", tag_end - verify_start);
    printf("load time %d\n", load_end - tag_end);
    printf("verify time %d verify level %d\n", verify_end - load_end, load_start_index);
    printf("spm wait time %d\n", d_w_e - d_w_s);
    printf("set seed time %d\n", set_seed_end - load_data_end); 
    printf("load mac time %d\n", datamac_dma_end - set_seed_end);
    printf("mac compute time %d\n", datamac_end - datamac_dma_end);
    printf("response time %d\n", end_time - datamac_end);
    printf("swapp total time %d\n", swapp_end_time - end_time);
    printf("Verification swapp tag_check_time:%d release_time:%d swapp_time:%d push_time:%d invalidate_time:%d or %d\n",
        tag_check_time - start_swapp_time,
        release_time - tag_check_time,
        swapp_time - release_time,
        push_time - release_time,
        invalidate_time - push_time,
        invalidate_time - swapp_time
      );
  }
  return tag_id;
}

int main(void){
  // グローバル配列へのアクセスの比較
  // loadをいじる
  SPM_SIZE_REG = 64;
  for (uint64_t i=0; i<512; i++){
    spm_sd64(i*8, 0); 
  }
  // rootノードの初期化
  spm_sd64(0,1);
  init_cache_system();
  temp_system_init(CACHE_DATA_SPM_BASE + CACHE_SETS * CACHE_WAYS * 64);
  dma_id_t dma_id = 0;
  int total = 0;
  while(1){
    for(;;){
      if(AXIM_STATUS_REG & 1) break; // リクエストが来るまで待つ
    }
    bool is_write = (AXIM_STATUS_REG & 2) != 0;
    dram_addr_t addr = AXIM_REQ_ADDR_REG;
    uint64_t req_id = AXIM_REQ_ID_REG;
    // uint16_t lru = (addr / (64 * 64)) & 0xFF;
    // uint16_t a = (addr / 64) & 0x3;
    // uint16_t b = (addr / (2048)) & 0x3;
    // uint64_t s = read_instret();
    // lru = update_tree_lru(lru, a);
    // lru = update_tree_lru(lru, b);
    // uint64_t e = read_instret();
    // int way = select_victim_way(lru);
    // uint64_t f = read_instret();
    // printf("LRU update time %d select victim time a %d way %d\n", e - s, f - e,way);
    // exit(1);
    total += 1;
    if (total % 1000 == 999){
      printf("Processed %d requests\n", total);
      instret_dump = true;
    } else {
      instret_dump = false;
    }
    if (addr == 0xFFFFFFFFFFFFFFFF){
      return 0;
    } else {
      if(is_write){ // writeリクエスト
        dma_id = Authentication(dma_id, addr,req_id);
      } else {
        dma_id = Verification(dma_id, addr,req_id);
      }
    }
  }
}


 