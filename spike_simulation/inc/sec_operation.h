static inline void verify_one_height(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index, uint32_t mac_req_id, dma_id_t dma_id){
  mac_init(mac_req_id);
  if (parent_spm_offset == 0){
      mac_buffer_set(0, dma_id);
      mac_update(0,63);
  } else {
      uint64_t start_bit = 64 + (node_index / 32) % 32 * 8;
      mac_buffer_set(parent_spm_offset, dma_id);
      mac_update(0,63);
      mac_update(start_bit, start_bit + 7);
  }
  mac_buffer_set(child_spm_offset, dma_id);
  mac_update(0, 447);
  mac_result_compare(child_spm_offset + 56, dma_id);
}

static inline void update_one_height(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index, 
  bool update_counter, uint32_t mac_req_id, dma_id_t dma_id){
  mac_init(mac_req_id);
  if (parent_spm_offset == 0){
      mac_buffer_set(0, dma_id);
      mac_update(0,63);
  } else {
      uint64_t start_bit = 64 + (node_index / 32) % 32 * 8;
      mac_buffer_set(parent_spm_offset, dma_id);
      mac_update(0,63);
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
  mac_buffer_set(child_spm_offset, dma_id);
  mac_update(0, 447);
  mac_digest(child_spm_offset + 56,dma_id);
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

