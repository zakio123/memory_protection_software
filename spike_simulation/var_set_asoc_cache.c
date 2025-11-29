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
// #include "mem_layout.h"
#include "util.h"
#include "config.h"
#include "cache_controll.h"


static inline dma_id_t ensureBlockInSpm(dram_addr_t required_dram_addr, struct Info tag_info,dma_id_t id){
  dma_id_t read_id = id;
  if (tag_info.dirty) {
    spm_write_back(tag_info.spm_offset, tag_info.block_addr, 64,0);
  }
  spm_copy_to_local(required_dram_addr, tag_info.spm_offset, 64,read_id);
  index_t set_index = get_cache_set_index(required_dram_addr);
  cache_metadata[set_index][tag_info.way].valid = true;
  cache_metadata[set_index][tag_info.way].dirty = false;
  cache_metadata[set_index][tag_info.way].access_count = 0;
  cache_metadata[set_index][tag_info.way].block_addr = required_dram_addr;
  return read_id;
}

static inline void swapp_temp_cache(dram_addr_t dram_addr, struct Info tag_info, spm_offset_t spm_offset,bool dirty){
  index_t set_index = get_cache_set_index(dram_addr);
  if (tag_info.dirty){
    spm_write_back(tag_info.spm_offset, tag_info.block_addr, 64, 0);
  }
  cache_metadata[set_index][tag_info.way].spm_offset = spm_offset;
  cache_metadata[set_index][tag_info.way].valid = true;
  cache_metadata[set_index][tag_info.way].dirty = dirty;
  cache_metadata[set_index][tag_info.way].access_count = 0;
  cache_metadata[set_index][tag_info.way].block_addr = dram_addr;
  push_temp_buffer(tag_info.spm_offset);
}

static inline dram_addr_t calculate_level_base_addr(uint64_t level) {
    dram_addr_t offset = 64 * ((1 << (5 * (level-1))) - 1) / (32 - 1);
    return offset;
}

static inline dram_addr_t get_counterblock_addr(dram_addr_t request_addr){
    dram_addr_t counterblock_addr = COUNTER_BASE + (((request_addr - PROTECTION_BASE) / (64 * 32))) * 64 + calculate_level_base_addr(HEIGHT);
    return counterblock_addr;
}

static inline dram_addr_t get_datamacblock_addr(dram_addr_t request_addr){
    dram_addr_t datamacblock_addr = DATA_TAG_BASE + (((request_addr - PROTECTION_BASE) / (64 * 8))) * 64;
    return datamacblock_addr;
}

static inline bool verify_one_height(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index, dma_id_t child_id){
  mac_init();
  if (parent_spm_offset == 0){
      mac_buffer_set(0);
      mac_update(0,63);
  } else {
      uint64_t start_bit = 64 + (node_index / 32) % 32 * 8;
      mac_buffer_set(parent_spm_offset);
      mac_update(start_bit, start_bit + 7);
  }
  spm_wait(child_id);
  mac_buffer_set(child_spm_offset);
  mac_update(0, 447);
  mac_t computed_mac = mac_final();
  mac_t stored_mac = spm_ld64(child_spm_offset + 56);
  if (computed_mac != stored_mac){
    printf("[Core FW] MAC verification failed: computed=%016llx, stored=%016llx\n", computed_mac, stored_mac);
    printf("path index=%llu, child_spm_offset=0x%08x, parent_spm_offset=0x%08x\n", node_index, child_spm_offset, parent_spm_offset);
    return false;
  }
  return true;
}

static inline void update_one_height(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index, bool update_counter){
  mac_init();
  if (parent_spm_offset == 0){
      mac_buffer_set(0);
      mac_update(0,63);
  } else {
      uint64_t start_bit = 64 + (node_index / 32) % 32 * 8;
      mac_buffer_set(parent_spm_offset);
      mac_update(start_bit, start_bit + 7);
  }
  // ブロックの更新
  if (update_counter){
    uint64_t major_counter = spm_ld64(child_spm_offset);
    uint64_t minor_counter_byte_address = child_spm_offset + 8 + (node_index % 32) / 8 * 8;
    uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
    // ここから過去のminor counterを取り出す
    uint8_t minor_counter_value = (minor_counter >> ((node_index % 8) * 8)) & 0xFF;
    uint8_t new_minor_counter = 0;
    if (minor_counter_value == 0xFF){
        // uint64_t new_major_counter = major_counter + 1;
        // spm_sd64(child_spm_offset, new_major_counter);
        new_minor_counter = 0; 
    } else {
        new_minor_counter = minor_counter_value + 1;
    }
    uint64_t shift_amount = (node_index % 8) * 8;
    uint64_t clear_mask = ~(0xFFULL << shift_amount);
    uint64_t cleared_minor_counter = minor_counter & clear_mask;
    uint64_t shifted_new_value = (new_minor_counter);
    shifted_new_value <<= shift_amount;
    uint64_t final_word = cleared_minor_counter | shifted_new_value;
    // 書き戻し
    spm_sd64(minor_counter_byte_address, final_word);
  }
  mac_buffer_set(child_spm_offset);
  mac_update(0, 447);
  mac_t computed_mac = mac_final();
  spm_sd64(child_spm_offset + 56, computed_mac);
}

// ===========================================================================
// Tree Notation (ツリー構造の定義)
// ===========================================================================
// Level 0: [ ROOT ] (SPM offset 0)
// Level 1: [ Node ] ...
//   ...
// Level V: [ Victim ] (今回処理する対象。Dirtyなので書き戻しが必要)
//   ...
// Level H: [ Leaf ] (Data Counters)
// ===========================================================================

dma_id_t evicted_node_update(struct Info tag_info, dma_id_t id) {
  // printf("[Core FW] Evicted node update for dram addr %016llx at spm offset %016llx\n", tag_info.block_addr, tag_info.spm_offset);
    // ---------------------------------------------------------
    // 1. Victimのレベル(階層)とインデックスを特定
    // ---------------------------------------------------------
    uint32_t v_level = 0; // Victimのレベル (0=Root)
    dram_addr_t v_level_base_addr = 0;

    // アドレスマップを上(L1)からスキャンして、Victimがどの深さにいるか探す
    // (Rootは固定なのでL1からチェック)
    for (int l = 1; l <= HEIGHT; l++) {
        dram_addr_t base = calculate_level_base_addr(l);
        dram_addr_t next_base = calculate_level_base_addr(l + 1);
        if (tag_info.block_addr >= (COUNTER_BASE + base)) { // アドレス境界を見て階層を判定
            // 最終レベル、または次のレベルの手前なら確定
            if (l == HEIGHT || tag_info.block_addr < (COUNTER_BASE + next_base)) {
                v_level = l;
                v_level_base_addr = base;
                break;
            }
        }
    }
    // ガード: Root(Lv.0)はEvictされないはずなので無視
    if (v_level == 0) return id;
    // 何個めのブロックか
    dram_addr_t v_index = (tag_info.block_addr - (COUNTER_BASE + v_level_base_addr))/ 64 * 32;
    uint64_t path_indecis[HEIGHT] = {0};
  // struct Info info_array[HEIGHT] = {0};
  spm_offset_t spm_offset_array[HEIGHT] = {0};
  dram_addr_t dram_addr_array[HEIGHT] = {0};
  bool load_needed[HEIGHT] = {0};
  uint64_t start_level = 0;
  int temp_idx_array[HEIGHT] = {0};
  bool hit_found = false;
  index_t hit_way = 0;
  // victim_levelの一個上から順にレベルをチェックしていく
  for(uint64_t i=1; i<v_level; ++i){
      uint64_t index = v_index >> (5 * i);
      path_indecis[v_level - 1 - i] = index;
      dram_addr_t dram_addr = COUNTER_BASE + index / 32 * 64 + calculate_level_base_addr(v_level - i);
      bool hit = light_tag_check(dram_addr);
      if (hit){
        hit_found = true;
        start_level = v_level - 1 - i;
        dram_addr_array[v_level - 1 - i] = dram_addr;
        load_needed[v_level - 1 - i] = false;
        struct Info info = tag_check(dram_addr);
        spm_offset_array[v_level - 1 - i] = info.spm_offset;
        hit_way = info.way;
        temp_idx_array[v_level - 1 - i] = -1;
        break;
      } else {
        int temp_idx = find_temp_entry(dram_addr);
        if (temp_idx < 0){
          spm_offset_array[v_level - 1 - i] = pop_temp_buffer();
          temp_idx = alloc_temp_entry(dram_addr, spm_offset_array[v_level - 1 - i]);
          load_needed[v_level - 1 - i] = true;
        } else {
          spm_offset_array[v_level - 1 - i] = get_temp_spm_offset(temp_idx);
          load_needed[v_level - 1 - i] = false;
        }
        if (temp_idx < 0){
          printf("[Core FW] Error: No available temp entry for dram addr %016llx during evicted node update\n", dram_addr);
          exit(1);
        }
        temp_idx_array[v_level - 1 - i] = temp_idx;
        dram_addr_array[v_level - 1 - i] = dram_addr;
      }
  }
  dram_addr_t tmp = COUNTER_BASE + v_index / 32 * 64 + calculate_level_base_addr(v_level);
  // if (tmp != tag_info.block_addr){
  //     printf("[Core FW]   Warning: Calculated dram addr %016llx does not match victim block addr %016llx\n", tmp, tag_info.block_addr);
  // }
  spm_offset_array[v_level - 1] = tag_info.spm_offset;
  dram_addr_array[v_level - 1] = tag_info.block_addr;
  path_indecis[v_level - 1] = v_index;
  temp_idx_array[v_level - 1] = -1;
  load_needed[v_level - 1] = false;
  // ---------------------------------------------------------
  // 2. SPMへのロードと検証、更新、スワップ
  // ---------------------------------------------------------
  uint64_t load_start_index = hit_found ? (start_level + 1) : 0;
  dma_id_t tmp_id = id;
  // 上から順にSPMにロード
  for (uint64_t i = load_start_index;i<v_level-1;i++){
    if (load_needed[i] == true){
      tmp_id += 1;
      dram_addr_t dram_addr = dram_addr_array[i];
      spm_copy_to_local(dram_addr, spm_offset_array[i], 64, tmp_id);
    }
    // else {
    //   printf("[Core FW] Unexpected hit during load phase at level %llu\n", i);
    //   exit(1);
    // }
  }
  // id = tmp_id;
  for (uint64_t i = load_start_index;i<v_level-1;i++){
    uint32_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    if (load_needed[i] == true){
      id += 1;
    }
    bool verify = verify_one_height(spm_offset_array[i], parent_spm, path_indecis[i], id);
    if (verify == false){
      printf("[Core FW] Verification failed at level %llu\n", i);
      exit(1);
    }
  }
  // 一時的なルートノードのアップデート
  if (load_start_index == 0){
    // rootノードの更新
    uint64_t root = spm_ld64(0);
    root += 1;
    spm_sd64(0, root);
  } else {
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
    clearParentUpdated(dram_addr_array[start_level], hit_way);
    setBlockdirty(dram_addr_array[start_level], hit_way);
  }
  // 木の更新：ルートから葉まで降りていく
  for (uint64_t i=load_start_index;i<v_level;i++){
    bool upd = (i == v_level - 1) ? false : true;
    update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], upd);
    // printf("[Core FW]   Updated level %llu node at dram addr %016llx\n", i, dram_addr_array[i]);
  }
  // スワップ
  for (uint64_t i = load_start_index;i<v_level-1;i++){
    // 全部swappしない
    if (load_needed[i] == true){
      // printf("[Core FW]   Swapping temp entry for dram addr %016llx at spm offset %016llx\n", dram_addr_array[i], spm_offset_array[i]);
      spm_write_back(spm_offset_array[i], dram_addr_array[i], 64, 0);
      push_temp_buffer(spm_offset_array[i]);
      invalidate_temp_entry_by_index(temp_idx_array[i]);
    } else {
      // printf("set dirty true for dram addr %016llx at spm offset %016llx\n", dram_addr_array[i], spm_offset_array[i]);
      dirty_temp_entry_by_index(temp_idx_array[i]);
      // printf("dirty %d, valid %d\n", is_dirty_temp_entry_by_index(temp_idx_array[i]), temp_table[temp_idx_array[i]].valid);
    }
  }
  spm_write_back(spm_offset_array[v_level - 1], dram_addr_array[v_level - 1], 64, 0);
  setParentUpdated(dram_addr_array[v_level - 1], tag_info.way);
  // printf("eviction update done\n");
  return id;
}


dma_id_t Authentication(dma_id_t id, dram_addr_t request_addr){
  // HEIGHT-1がリーフ、0が高さ1
  uint64_t path_indecis[HEIGHT] = {0};
  // struct Info info_array[HEIGHT] = {0};
  spm_offset_t spm_offset_array[HEIGHT] = {0};
  dram_addr_t dram_addr_array[HEIGHT] = {0};
  int temp_idx_array[HEIGHT] = {0};
  uint64_t start_level = 0;
  bool hit_found = false;
  index_t way_index = 0;
  for(uint64_t i=0; i<HEIGHT; ++i){
      uint64_t index = (request_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * i)));
      path_indecis[HEIGHT - 1 - i ] = index;
      dram_addr_t dram_addr = COUNTER_BASE + index / 32 * 64 + calculate_level_base_addr(HEIGHT - i);
      // struct Info info = tag_check(dram_addr);
      // info_array[HEIGHT - 1 - i] = info;
      bool hit = light_tag_check(dram_addr);
      if (hit){
        hit_found = true;
        start_level = HEIGHT - 1 - i;
        struct Info info = tag_check(dram_addr);
        spm_offset_array[HEIGHT - 1 - i] = info.spm_offset;
        dram_addr_array[HEIGHT - 1 - i] = dram_addr;
        way_index = info.way;
        temp_idx_array[HEIGHT - 1 - i] = -1;
        break;
      } else {
        dram_addr_array[HEIGHT - 1 - i] = dram_addr;
      }
  }
  uint64_t load_start_index = hit_found ? (start_level + 1) : 0;
  dma_id_t tmp_id = id;
  // 上から順にSPMにロード
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
      tmp_id += 1;
      spm_offset_array[i] = pop_temp_buffer();
      temp_idx_array[i] = alloc_temp_entry(dram_addr_array[i], spm_offset_array[i]);
      dram_addr_t dram_addr = dram_addr_array[i];
      spm_copy_to_local(dram_addr, spm_offset_array[i], 64, tmp_id);
    // }
    // else {
    //   printf("[Core FW] Unexpected hit during load phase at level %llu\n", i);
    //   exit(1);
    // }
  }
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    uint32_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    id += 1;
    bool verify = verify_one_height(spm_offset_array[i], parent_spm, path_indecis[i], id);
    if (verify == false){
      printf("[Core FW] Verification failed at level %llu\n", i);
      exit(1);
    }
  }
  // 一時的なルートノードのアップデート
  if (load_start_index == 0){
    // rootノードの更新
    uint64_t root = spm_ld64(0);
    root += 1;
    spm_sd64(0, root);
  } else {
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
    clearParentUpdated(dram_addr_array[start_level], way_index);
    setBlockdirty(dram_addr_array[start_level], way_index);
  }
  // 木の更新：ルートから葉まで降りていく
  for (uint64_t i=load_start_index;i<HEIGHT;i++){
    update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], true);
  }
  // スワップ
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    struct Info info_i = tag_check(dram_addr_array[i]);
    bool mac_updated = is_mac_updated(dram_addr_array[i], info_i.way);
    if (mac_updated){
      // swappして良い
      // spm_write_back(spm_offset_array[i], dram_addr_array[i], 64, 0);
      swapp_temp_cache(dram_addr_array[i], info_i, spm_offset_array[i],true);
      setParentUpdated(dram_addr_array[i], info_i.way);
    } else{
      id = evicted_node_update(info_i, id);
      swapp_temp_cache(dram_addr_array[i], info_i, spm_offset_array[i], true);
      // spm_write_back(spm_offset_array[i], dram_addr_array[i], 64, 0);
      // push_temp_buffer(spm_offset_array[i]);
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
  while(AES_START_REG);
  // write_xor(DATA_SPM_OFFSET);
  xor_start(true, false);
  copy_xor(DATA_SPM_OFFSET);
  // ハッシュ関数の内部状態を初期化
  // SPMに当該MACブロックがあればそのままmodify,なければ今あるブロックをDRAMにwrite backしてから適切なブロックをSPMにDRAMコピー
  mac_init();
  mac_buffer_set(DATA_SPM_OFFSET); 
  mac_update(0, 511);
  mac_buffer_set(spm_offset_array[HEIGHT-1]);
  mac_update(counter_bit_offset, counter_bit_offset + 7); // 
  // MAC計算完了
  uint64_t computed_mac = mac_final();
  if (!tag_info.hit){
    spm_wait(tag_id);
  }
  uint64_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
  spm_sd64(tag_info.spm_offset + dmac_byte_offset, computed_mac);
  setBlockdirty(datamacblock_addr, tag_info.way);
  spm_write_back(DATA_SPM_OFFSET, request_addr, 64, 0);
  axim_write_return();
  return tag_id;
}

dma_id_t Verification(dma_id_t id, dram_addr_t request_addr){
  // HEIGHT-1がリーフ、0が高さ1
  uint64_t path_indecis[HEIGHT] = {0};
  spm_offset_t spm_offset_array[HEIGHT] = {0};
  dram_addr_t dram_addr_array[HEIGHT] = {0};
  int temp_idx_array[HEIGHT] = {0};
  uint64_t start_level = 0;
  bool hit_found = false;
  // パス上のノードのタグチェックを行う
  for(uint64_t i=0; i<HEIGHT; ++i){
      uint64_t index = (request_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * i)));
      path_indecis[HEIGHT - 1 - i ] = index;
      dram_addr_t dram_addr = COUNTER_BASE + index / 32 * 64 + calculate_level_base_addr(HEIGHT - i);
      bool light_hit = light_tag_check(dram_addr);
      if (light_hit){
        hit_found = true;
        start_level = HEIGHT - 1 - i;
        dram_addr_array[HEIGHT - 1 - i] = dram_addr;
        struct Info info = tag_check(dram_addr);
        spm_offset_array[HEIGHT - 1 - i] = info.spm_offset;
        break;
      } else {
        dram_addr_array[HEIGHT - 1 - i] = dram_addr;
      }
  }
  uint64_t load_start_index = hit_found ? (start_level + 1) : 0;
  dma_id_t tmp_id = id;
  // 上から順にSPMにロード。ミスしているノードのみロード
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    tmp_id += 1;
    dram_addr_t dram_addr = dram_addr_array[i];
    spm_offset_array[i] = pop_temp_buffer();
    temp_idx_array[i] = alloc_temp_entry(dram_addr, spm_offset_array[i]);
    spm_copy_to_local(dram_addr, spm_offset_array[i], 64, tmp_id);
  }
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    spm_offset_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    id += 1;
    bool verify = verify_one_height(spm_offset_array[i], parent_spm, path_indecis[i], id);
    if (verify == false){
      printf("[Core FW] Verification failed at level %llu\n", i);
      exit(1);
    }
  }
  dma_id_t data_id = id+1;
  spm_copy_to_local(request_addr, DATA_SPM_OFFSET, 64,data_id);
  uint64_t major_counter = spm_ld64(spm_offset_array[HEIGHT-1]);
  // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
  uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
  uint64_t minor_counter = spm_ld64(spm_offset_array[HEIGHT-1] + (counter_bit_offset / 64) * 8);
  uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64) )) & 0xFF;
  set_seed(major_counter, minor_counter_value, request_addr);
  // SPMに当該MACブロックがあるかを確認。なければコピー。
  dram_addr_t datamacblock_addr = get_datamacblock_addr(request_addr);
  struct Info tag_info = tag_check(datamacblock_addr);
  dma_id_t tag_id = data_id;
  if (!tag_info.hit){
    tag_id += 1;
    ensureBlockInSpm(datamacblock_addr, tag_info,tag_id);
  }
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    struct Info info = tag_check(dram_addr_array[i]);
    bool mac_updated = is_mac_updated(dram_addr_array[i], info.way);
    if (mac_updated){
      bool dirty = is_dirty_temp_entry_by_index(temp_idx_array[i]);
      swapp_temp_cache(dram_addr_array[i], info, spm_offset_array[i], dirty);
    } else {
      tag_id = evicted_node_update(info, tag_id);
      // swappして良い
      bool dirty = is_dirty_temp_entry_by_index(temp_idx_array[i]);
      swapp_temp_cache(dram_addr_array[i], info, spm_offset_array[i], dirty);
    }
    invalidate_temp_entry_by_index(temp_idx_array[i]);
    // bool dirty = is_dirty_temp_entry_by_index(temp_idx_array[i]);
    // swapp_temp_cache(dram_addr_array[i], info, spm_offset_array[i], dirty);
    // invalidate_temp_entry_by_index(temp_idx_array[i]);
    // else {
    //   // 親が更新されていない場合は、evicted node updateを行う またはpush
    //   tag_id = evicted_node_update(info, tag_id);
    //   bool dirty = is_dirty_temp_entry_by_index(temp_idx_array[i]);
      // if (dirty){
      //   printf("[Core FW] Warning: Dirty temp entry found for at level : %d, dram addr %016llx during Verification at spm offset %016llx\n", i, dram_addr_array[i], spm_offset_array[i]);
      // }
    //   swapp_temp_cache(dram_addr_array[i], info, spm_offset_array[i], dirty);
    //   // push_temp_buffer(spm_offset_array[i]);
    // }
  }
  // --- 手順3: SPM DMAを起動し、DRAMから暗号文をSPMにコピー ---
  spm_wait(data_id);
  mac_init();
  mac_buffer_set(DATA_SPM_OFFSET);
  mac_update(0, 511);
  // SPMからカウンターブロックをコピーし、update
  mac_buffer_set(spm_offset_array[HEIGHT-1]);
  mac_update(counter_bit_offset, counter_bit_offset + 7); 
  mac_t mac_result = mac_final();
  if (!tag_info.hit){
    spm_wait(tag_id);
  }
  spm_offset_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
  mac_t expected_mac = spm_ld64(tag_info.spm_offset + dmac_byte_offset);
  if (mac_result != expected_mac) {
    printf("[Core FW] MAC verification failed during Verification: computed=%016llx, expected=%016llx\n", mac_result, expected_mac);
    exit(1);
  }
  // --- 手順7: AXI managerに対し、read bufferにあるデータをリターンするように指示 ---
  while(AES_START_REG); // busy待ち
  write_xor(DATA_SPM_OFFSET);
  xor_start(false, true);
  axim_read_return();
  return tag_id;
}

int main(void){
  // SPMの初期化
  for (uint64_t i=0; i<512; i++){
    spm_sd64(i*8, 0); 
  }
  // rootノードの初期化
  spm_sd64(0,1);
  init_cache_system();
  temp_system_init(CACHE_DATA_SPM_BASE + CACHE_SETS * CACHE_WAYS * 64);
  dma_id_t dma_id = 0;
  while(1){
    for(;;){
      if(AXIM_STATUS_REG & 1) break; // リクエストが来るまで待つ
    }
    dram_addr_t addr = AXIM_REQ_ADDR_REG;
    // printf("addr=%016llx\n", addr);
    if (addr == 0xFFFFFFFFFFFFFFFF){
      return 0;
    } else {
      if(AXIM_STATUS_REG & 2){ // writeリクエスト
        dma_id = Authentication(dma_id, addr);
      } else {
        dma_id = Verification(dma_id, addr);
      }
    }
  }
}


// uint64_t decryption_only(uint64_t id, uint64_t request_addr){
//   uint64_t counterblock_addr = get_counterblock_addr(request_addr);
//   struct Info tag_info = tag_check(counterblock_addr);
//     // --- 手順1: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
//   // printf("[Core FW] Decryption: spm_offset=%016llx\n", spm_offset);
//   uint64_t counter_id = id;
//   if (!tag_info.hit){
//     counter_id += 1;
//     counter_id = ensureBlockInSpm(counterblock_addr, tag_info, counter_id);
//   }
//   uint64_t data_id = counter_id + 1;
//   spm_copy_to_local(request_addr, DATA_SPM_OFFSET, 64,data_id);
//   if (!tag_info.hit){
//     spm_wait(counter_id);
//   }
//   uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
//   uint64_t major_counter = spm_ld64(tag_info.spm_offset);
//   uint64_t minor_counter_byte_address = tag_info.spm_offset + (counter_bit_offset / 64) * 8;
//   uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
//   uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64) )) & 0xFF;
//   set_seed(major_counter, minor_counter_value, request_addr);
//   // --- 手順2: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
//   // SPM DMAを起動し、DRAMから暗号文をSPMにコピー
//   while(AES_START_REG); // busy待ち    
//   spm_wait(data_id);
//   write_xor(DATA_SPM_OFFSET);
//   xor_start();
//   copy_xor(DATA_SPM_OFFSET);
//   axim_write(DATA_SPM_OFFSET);
//   // // --- 手順3: SPM DMAを起動し、SPMからDRAMへ暗号文をwrite back ---
//   axim_read_return();
//   return data_id;
// }
// uint64_t encryption_only(uint64_t id, uint64_t request_addr){
//   uint64_t counterblock_addr = get_counterblock_addr(request_addr);
//     struct Info tag_info = tag_check(counterblock_addr);
//     uint64_t counter_id = id;
//     if (!tag_info.hit){
//       counter_id += 1;
//       counter_id = ensureBlockInSpm(counterblock_addr, tag_info, counter_id);
//       spm_wait(counter_id);
//     }
//     uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
//     uint64_t major_counter = spm_ld64(tag_info.spm_offset);
//     // minor_counterのload
//     // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
//     uint64_t minor_counter_byte_address = tag_info.spm_offset + (counter_bit_offset / 64) * 8;
//     uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
//     uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64) )) & 0xFF;
//     minor_counter_value += 1; // インクリメント
//     set_seed(major_counter, minor_counter_value, request_addr);
//     // minor counterの書き戻し
//     uint64_t shift_amount = (counter_bit_offset % 64);
//     uint64_t clear_mask = ~(0xFFULL << shift_amount);
//     uint64_t cleared_minor_counter = minor_counter & clear_mask;
//     // --- 新しい値を正しい位置へシフトする ---
//     uint64_t shifted_new_value = (minor_counter_value);
//     shifted_new_value <<= shift_amount;
//     uint64_t final_word = cleared_minor_counter | shifted_new_value;
//     // 書き戻し
//     spm_sd64(minor_counter_byte_address, final_word);
//     // ブロックをdirtyに設定する
//     setBlockdirty(tag_info.spm_offset);
//     // --- 手順2: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
//     // SPM DMAを起動し、DRAMから平文をSPMにコピー
//     axim_copy(DATA_SPM_OFFSET);
//     while(AES_START_REG); // busy待ち
//     write_xor(DATA_SPM_OFFSET);
//     xor_start();
//     copy_xor(DATA_SPM_OFFSET);
//     // --- 手順3: SPM DMAを起動し、SPMからDRAMへ暗号文をwrite back ---
//     spm_write_back(DATA_SPM_OFFSET, request_addr, 64,counter_id + 1);
//     axim_write_return();
//     return counter_id + 1;
// }
// uint64_t write_only(uint64_t id, uint64_t request_addr){
//     axim_copy(DATA_SPM_OFFSET);
//     // --- 手順3: SPM DMAを起動し、SPMからDRAMへ暗号文をwrite back ---
//     // id += 1;
//     spm_write_back(DATA_SPM_OFFSET, request_addr, 64,0);
//     axim_write_return();
//     return id;
// }
// uint64_t read_only(uint64_t id, uint64_t request_addr){
//     // struct AddressContext ctx = setupAddressContext();
//     id += 1;
//     spm_copy_to_local(request_addr, DATA_SPM_OFFSET, 64,id);
//     spm_wait(id);
//     axim_write(DATA_SPM_OFFSET);
//     axim_read_return();
//     return id;
// }
// uint64_t decryption_tag(uint64_t id, uint64_t request_addr){
//   uint64_t counterblock_addr = get_counterblock_addr(request_addr);
//   struct Info tag_info = tag_check(counterblock_addr);
//   uint64_t counter_id = id;
//   if (!tag_info.hit){
//     counter_id += 1;
//     counter_id = ensureBlockInSpm(counterblock_addr, tag_info, counter_id);
//   }
//   uint64_t data_id = counter_id + 1;
//   spm_copy_to_local(request_addr, DATA_SPM_OFFSET, 64,data_id);
//   if (!tag_info.hit){
//     spm_wait(counter_id);
//   }
//   uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
//   uint64_t major_counter = spm_ld64(tag_info.spm_offset);
//   // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
//   uint64_t minor_counter_byte_address = tag_info.spm_offset + (counter_bit_offset / 64) * 8;
//   uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
//   uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64) )) & 0xFF;
//   set_seed(major_counter, minor_counter_value, request_addr);
//   struct Info data_tag_info = tag_check(get_datamacblock_addr(request_addr));
//     uint64_t tag_id = data_id;
//     if (!data_tag_info.hit){
//       tag_id += 1;
//       tag_id = ensureBlockInSpm(get_datamacblock_addr(request_addr), data_tag_info, tag_id);
//     }
//     spm_wait(data_id);
//     while(AES_START_REG); // busy待ち
//     mac_init();
//     mac_buffer_set(DATA_SPM_OFFSET);
//     mac_update(0, 511);
//     // SPMからカウンターブロックをコピーし、update
//     mac_buffer_set(tag_info.spm_offset);
//     mac_update(counter_bit_offset, counter_bit_offset + 7); 
//     // --- 手順6: Hashモジュールの計算完了を待ち、結果を取得しSPMから正しい結果をload ---
//     // SPMに当該MACブロックがあるかを確認。なければコピー。
//     uint64_t mac_result = mac_final();
//     if (!data_tag_info.hit){
//       spm_wait(tag_id);
//     }
//     uint64_t dmac_byte_offset = (request_addr / 64) % 8 * 8;
//     uint64_t expected_mac = spm_ld64(data_tag_info.spm_offset + dmac_byte_offset);
//     if (mac_result != expected_mac) {
//         exit(1);
//     }
//     write_xor(DATA_SPM_OFFSET);
//     xor_start();
//     copy_xor(DATA_SPM_OFFSET);
//     axim_write(DATA_SPM_OFFSET);
//     axim_read_return();
//     return tag_id;
// }
// uint64_t encryption_tag(uint64_t id, uint64_t request_addr){
//   uint64_t counterblock_addr = get_counterblock_addr(request_addr);
//   struct Info tag_info = tag_check(counterblock_addr);
//   uint64_t counter_id = id;
//   if (!tag_info.hit){
//     counter_id += 1;
//     counter_id = ensureBlockInSpm(counterblock_addr, tag_info, counter_id);
//     spm_wait(counter_id);
//   }
//   axim_copy(DATA_SPM_OFFSET);
//   // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
//   uint64_t major_counter = spm_ld64(tag_info.spm_offset);
//   uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
//   uint64_t minor_counter_byte_address = tag_info.spm_offset + (counter_bit_offset / 64) * 8;
//   uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
//   uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64))) & 0xFF;
//   uint8_t new_minor_counter_value = minor_counter_value + 1; // インクリメント
//   // minor counterの書き戻し
//   uint64_t shift_amount = (counter_bit_offset % 64);
//   uint64_t clear_mask = ~(0xFFULL << shift_amount);
//   uint64_t cleared_minor_counter = minor_counter & clear_mask;
//   // --- 新しい値を正しい位置へシフトする ---
//   uint64_t shifted_new_value = (new_minor_counter_value) << shift_amount;
//   uint64_t final_word = cleared_minor_counter | shifted_new_value;
//   // 書き戻し
//   spm_sd64(minor_counter_byte_address, final_word);
//   set_seed(major_counter, new_minor_counter_value, request_addr);
//   setBlockdirty(tag_info.spm_offset);    
//   // --- 手順3: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
//   uint64_t datamacblock_addr = get_datamacblock_addr(request_addr);
//   struct Info data_tag_info = tag_check(datamacblock_addr);
//   uint64_t tag_id = counter_id;
//   if (!data_tag_info.hit){
//     tag_id += 1;
//     tag_id = ensureBlockInSpm(datamacblock_addr, data_tag_info, tag_id);
//   }
//     while(AES_START_REG); // busy待ち
//     write_xor(DATA_SPM_OFFSET);
//     xor_start();
//     copy_xor(DATA_SPM_OFFSET);
//     spm_write_back(DATA_SPM_OFFSET, request_addr, 64,tag_id + 1);
//     axim_write_return();
//     // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
//     // ハッシュ関数の内部状態を初期化
//     // SPMに当該MACブロックがあればそのままmodify,なければ今あるブロックをDRAMにwrite backしてから適切なブロックをSPMにDRAMコピー
//     mac_init();
//     mac_buffer_set(DATA_SPM_OFFSET); 
//     mac_update(0, 511);
//     mac_buffer_set(tag_info.spm_offset);
//     mac_update(counter_bit_offset, counter_bit_offset + 7); // 8bit = 1B
//     // MAC計算完了
//     uint64_t computed_mac = mac_final();
//     if (!data_tag_info.hit){
//       spm_wait(tag_id);
//     }
//     // --- 手順6: Hashモジュールの計算完了を待ち、結果をSPMに保存 ---
//     uint64_t dmac_byte_offset = (request_addr / 64) % 8 * 8;
//     spm_sd64(data_tag_info.spm_offset + dmac_byte_offset, computed_mac);
//     // SPM上のMACブロックをDirtyに設定する
//     setBlockdirty(data_tag_info.spm_offset);
//     return tag_id+1;
// }
