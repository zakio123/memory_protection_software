
// static inlinve void activa

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
  mac_buffer_set(child_spm_offset);
  mac_update(0, 447);
  mac_t computed_mac = mac_digest(0);
  mac_t stored_mac = spm_ld64(child_spm_offset + 56);
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
  mac_t computed_mac = mac_digest(0);
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

// dma_id_t evicted_node_update(struct Info tag_info, dma_id_t id) {
//   // printf("[Core FW] Evicted node update for dram addr %016llx at spm offset %016llx\n", tag_info.block_addr, tag_info.spm_offset);
//     // ---------------------------------------------------------
//     // 1. Victimのレベル(階層)とインデックスを特定
//     // ---------------------------------------------------------
//     uint32_t v_level = 0; // Victimのレベル (0=Root)
//     dram_addr_t v_level_base_addr = 0;

//     // アドレスマップを上(L1)からスキャンして、Victimがどの深さにいるか探す
//     // (Rootは固定なのでL1からチェック)
//     for (int l = 1; l <= HEIGHT; l++) {
//         dram_addr_t base = calculate_level_base_addr(l);
//         dram_addr_t next_base = calculate_level_base_addr(l + 1);
//         if (tag_info.block_addr >= (COUNTER_BASE + base)) { // アドレス境界を見て階層を判定
//             // 最終レベル、または次のレベルの手前なら確定
//             if (l == HEIGHT || tag_info.block_addr < (COUNTER_BASE + next_base)) {
//                 v_level = l;
//                 v_level_base_addr = base;
//                 break;
//             }
//         }
//     }
//     // ガード: Root(Lv.0)はEvictされないはずなので無視
//     if (v_level == 0) return id;
//     // 何個めのブロックか
//     dram_addr_t v_index = (tag_info.block_addr - (COUNTER_BASE + v_level_base_addr))/ 64 * 32;
//     uint64_t path_indecis[HEIGHT] = {0};
//   // struct Info info_array[HEIGHT] = {0};
//   spm_offset_t spm_offset_array[HEIGHT] = {0};
//   dram_addr_t dram_addr_array[HEIGHT] = {0};
//   bool load_needed[HEIGHT] = {0};
//   int temp_idx_array[HEIGHT] = {0};
//   index_t hit_way = 0;
//   uint64_t load_start_index = 0;
//   // victim_levelの一個上から順にレベルをチェックしていく
//   for(uint64_t i=1; i<v_level; ++i){
//       uint64_t index = v_index >> (5 * i);
//       path_indecis[v_level - 1 - i] = index;
//       dram_addr_t dram_addr = COUNTER_BASE + index / 32 * 64 + calculate_level_base_addr(v_level - i);
//       bool hit = light_tag_check(dram_addr);
//       if (hit){
//         load_start_index = v_level - i;
//         dram_addr_array[v_level - 1 - i] = dram_addr;
//         load_needed[v_level - 1 - i] = false;
//         struct Info info = tag_check(dram_addr);
//         spm_offset_array[v_level - 1 - i] = info.spm_offset;
//         hit_way = info.way;
//         temp_idx_array[v_level - 1 - i] = -1;
//         break;
//       } else {
//         int temp_idx = find_temp_entry(dram_addr);
//         if (temp_idx < 0){
//           spm_offset_array[v_level - 1 - i] = pop_temp_buffer();
//           temp_idx = alloc_temp_entry(dram_addr, spm_offset_array[v_level - 1 - i]);
//           load_needed[v_level - 1 - i] = true;
//         } else {
//           spm_offset_array[v_level - 1 - i] = get_temp_spm_offset(temp_idx);
//           load_needed[v_level - 1 - i] = false;
//         }
//         if (temp_idx < 0){
//           printf("[Core FW] Error: No available temp entry for dram addr %016llx during evicted node update\n", dram_addr);
//           exit(1);
//         }
//         temp_idx_array[v_level - 1 - i] = temp_idx;
//         dram_addr_array[v_level - 1 - i] = dram_addr;
//       }
//   }
//   dram_addr_t tmp = COUNTER_BASE + v_index / 32 * 64 + calculate_level_base_addr(v_level);
//   // if (tmp != tag_info.block_addr){
//   //     printf("[Core FW]   Warning: Calculated dram addr %016llx does not match victim block addr %016llx\n", tmp, tag_info.block_addr);
//   // }
//   spm_offset_array[v_level - 1] = tag_info.spm_offset;
//   dram_addr_array[v_level - 1] = tag_info.block_addr;
//   path_indecis[v_level - 1] = v_index;
//   temp_idx_array[v_level - 1] = -1;
//   load_needed[v_level - 1] = false;
//   // ---------------------------------------------------------
//   // 2. SPMへのロードと検証、更新、スワップ
//   // ---------------------------------------------------------
//   dma_id_t tmp_id = id;
//   // 上から順にSPMにロード
//   for (uint64_t i = load_start_index;i<v_level-1;i++){
//     if (load_needed[i] == true){
//       tmp_id += 1;
//       dram_addr_t dram_addr = dram_addr_array[i];
//       spm_copy_to_local(dram_addr, spm_offset_array[i], 64, tmp_id);
//     }
//   }
//   // id = tmp_id;
//   for (uint64_t i = load_start_index;i<v_level-1;i++){
//     uint32_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
//     if (load_needed[i] == true){
//       id += 1;
//     }
//     bool verify = verify_one_height(spm_offset_array[i], parent_spm, path_indecis[i], id);
//     if (verify == false){
//       printf("[Core FW] Verification failed at level %llu\n", i);
//       exit(1);
//     }
//   }
//   // 一時的なルートノードのアップデート
//   if (load_start_index == 0){
//     // rootノードの更新
//     uint64_t root = spm_ld64(0);
//     root += 1;
//     spm_sd64(0, root);
//   } else {
//     uint64_t start_level = load_start_index - 1;
//     uint64_t major_counter = spm_ld64(spm_offset_array[start_level]);
//     uint64_t minor_counter_byte_address = spm_offset_array[start_level] + 8 + (path_indecis[start_level] % 32) / 8 * 8;
//     uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
//     // ここから過去のminor counterを取り出す
//     uint8_t minor_counter_value = (minor_counter >> ((path_indecis[start_level] % 8) * 8)) & 0xFF;
//     uint8_t new_minor_counter = 0;
//     if (minor_counter_value == 0xFF){
//         // uint64_t new_major_counter = major_counter + 1;
//         // spm_sd64(spm_offset_array[load_start_index - 1], new_major_counter);
//         new_minor_counter = 0; 
//     } else {
//         new_minor_counter = minor_counter_value + 1;
//     }
//     uint64_t shift_amount = (path_indecis[load_start_index - 1] % 8) * 8;
//     uint64_t clear_mask = ~(0xFFULL << shift_amount);
//     uint64_t cleared_minor_counter = minor_counter & clear_mask;
//     uint64_t shifted_new_value = (new_minor_counter);
//     shifted_new_value <<= shift_amount;
//     uint64_t final_word = cleared_minor_counter | shifted_new_value;
//     // 書き戻し
//     spm_sd64(minor_counter_byte_address, final_word);
//     // 一時的なルートなので、parent updatedはfalseにしておく
//     clearParentUpdated(dram_addr_array[start_level], hit_way);
//     setBlockdirty(dram_addr_array[start_level], hit_way);
//   }
//   // 木の更新：ルートから葉まで降りていく
//   for (uint64_t i=load_start_index;i<v_level;i++){
//     bool upd = (i == v_level - 1) ? false : true;
//     update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], upd);
//     // printf("[Core FW]   Updated level %llu node at dram addr %016llx\n", i, dram_addr_array[i]);
//   }
//   // スワップ
//   for (uint64_t i = load_start_index;i<v_level-1;i++){
//     // 全部swappしない
//     if (load_needed[i] == true){
//       // printf("[Core FW]   Swapping temp entry for dram addr %016llx at spm offset %016llx\n", dram_addr_array[i], spm_offset_array[i]);
//       spm_write_back(spm_offset_array[i], dram_addr_array[i], 64, 0);
//       push_temp_buffer(spm_offset_array[i]);
//       invalidate_temp_entry_by_index(temp_idx_array[i]);
//     } else {
//       dirty_temp_entry_by_index(temp_idx_array[i]);
//     }
//   }
//   spm_write_back(spm_offset_array[v_level - 1], dram_addr_array[v_level - 1], 64, 0);
//   setParentUpdated(dram_addr_array[v_level - 1], tag_info.way);
//   return id;
// }