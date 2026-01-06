
static inline void verify_one_height(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index, uint32_t mac_req_id, dma_id_t dma_id,dram_addr_t dram_addr, spm_offset_t dram_addr_offset){
  mac_init(mac_req_id,false);
  if (parent_spm_offset == 0){
      mac_buffer_set(0, dma_id);
      mac_update(0,63);
  } else {
      uint64_t start_bit = 64 + (node_index / MINOR_COUNTER_COUNT) % MINOR_COUNTER_COUNT * MINOR_COUNTER_WIDTH;
      mac_buffer_set(parent_spm_offset, dma_id);
      mac_update(0,63);
      mac_update(start_bit, start_bit + (MINOR_COUNTER_WIDTH - 1));
  }
  mac_buffer_set(child_spm_offset, dma_id);
  mac_update(0, 447);
  mac_buffer_set(dram_addr_offset, dma_id);
  mac_update(0,63);
  mac_result_compare(child_spm_offset + 56, dma_id);
}

static inline void update_one_height(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index, 
  bool update_counter, uint32_t mac_req_id, dma_id_t dma_id,
  dram_addr_t dram_addr, spm_offset_t dram_addr_offset){
  mac_init(mac_req_id,false);
  if (parent_spm_offset == 0){
      mac_buffer_set(0, dma_id);
      mac_update(0,63);
  } else {
      uint64_t start_bit = 64 + (node_index / MINOR_COUNTER_COUNT) % MINOR_COUNTER_COUNT * MINOR_COUNTER_WIDTH;
      mac_buffer_set(parent_spm_offset, dma_id);
      mac_update(0,63);
      mac_update(start_bit, start_bit + (MINOR_COUNTER_WIDTH - 1));
  }
  // ブロックの更新
  if (update_counter){
    uint64_t minor_idx = node_index % MINOR_COUNTER_COUNT; 
    uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
    uint64_t base_addr = child_spm_offset; // または start_level
    uint64_t word_offset_bytes = (global_bit_offset / 64) * 8;
    uint64_t local_bit_offset  = global_bit_offset % 64;
    // 2. データの読み出し（Read-Modify-Writeのため、周辺ビットも含めて読む）
    uint64_t word1 = spm_ld64(base_addr + word_offset_bytes);
    uint64_t word2 = 0;
    bool is_split = (local_bit_offset + MINOR_COUNTER_WIDTH > 64);
    // またいでいる場合は次のワードも読む
    if (is_split) {
        word2 = spm_ld64(base_addr + word_offset_bytes + 8);
    }
    // 3. 現在のマイナーカウンター値の抽出
    uint64_t current_val_raw = word1 >> local_bit_offset;
    if (is_split) {
        // 次のワードの下位ビットを、現在の上位ビットとして結合
        current_val_raw |= (word2 << (64 - local_bit_offset));
    }
    uint64_t current_minor_val = current_val_raw & MINOR_COUNTER_MASK;
    // 4. 値の更新（インクリメントとオーバーフロー判定）
    uint64_t new_minor_val;
    if (current_minor_val == MINOR_COUNTER_MASK) {
        // オーバーフロー時の処理
        new_minor_val = 0;
        // --- メジャーカウンターの更新処理 ---
        // ここにメジャーカウンターのインクリメント処理が入ります
        // 例:
        // uint64_t major_counter = spm_ld64(base_addr);
        // spm_sd64(base_addr, major_counter + 1);
        // ----------------------------------
    } else {
        new_minor_val = current_minor_val + 1;
    }
    // 5. 書き戻し用データの作成と保存
    // 書き戻しデータのビット幅（Word1に含まれる分）
    uint64_t bits_in_first = is_split ? (64 - local_bit_offset) : MINOR_COUNTER_WIDTH;
    uint64_t mask_first = MINOR_COUNTER_MASK;
    // A. 更新対象の場所を0クリア (Clear)
    word1 &= ~(mask_first << local_bit_offset);
    // B. 新しい値の下位パートをセット (Set)
    word1 |= ((new_minor_val & mask_first) << local_bit_offset);
    // C. 書き込み
    spm_sd64(base_addr + word_offset_bytes, word1);
    // --- Word 2 の更新（またいでいる場合のみ） ---
    if (is_split) {
        uint64_t bits_in_second = MINOR_COUNTER_WIDTH - bits_in_first;
        uint64_t mask_second = (1ULL << bits_in_second) - 1;
        // A. 更新対象の場所(先頭)を0クリア
        word2 &= ~mask_second;
        // B. 新しい値の上位パートをシフトしてセット
        word2 |= (new_minor_val >> bits_in_first) & mask_second;
        // C. 書き込み
        spm_sd64(base_addr + word_offset_bytes + 8, word2);
    }
    // uint64_t major_counter = spm_ld64(child_spm_offset);
    // uint64_t minor_counter_byte_address = child_spm_offset + 8 + (node_index % 32) / 8 * 8;
    // uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
    // // ここから過去のminor counterを取り出す
    // uint8_t minor_counter_value = (minor_counter >> ((node_index % 8) * 8)) & 0xFF;
    // uint8_t new_minor_counter = 0;
    // if (minor_counter_value == 0xFF){
    //     // uint64_t new_major_counter = major_counter + 1;
    //     // spm_sd64(child_spm_offset, new_major_counter);
    //     new_minor_counter = 0; 
    // } else {
    //     new_minor_counter = minor_counter_value + 1;
    // }
    // uint64_t shift_amount = (node_index % 8) * 8;
    // uint64_t clear_mask = ~(0xFFULL << shift_amount);
    // uint64_t cleared_minor_counter = minor_counter & clear_mask;
    // uint64_t shifted_new_value = (new_minor_counter);
    // shifted_new_value <<= shift_amount;
    // uint64_t final_word = cleared_minor_counter | shifted_new_value;
    // 書き戻し
    // spm_sd64(minor_counter_byte_address, final_word);
  }
  mac_buffer_set(child_spm_offset, dma_id);
  mac_update(0, 447);
  mac_buffer_set(dram_addr_offset, dma_id);
  mac_update(0,63);
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

