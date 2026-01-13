#include "cache_controll.h"
#include "spm_rwlock.h"
#include "config.h"
#define REENCRYPTION_SPM_OFFSET DATA_SPM_OFFSET + 64
uint64_t global_mac_req_id = 1;
uint64_t global_dma_id = 0;
dram_addr_t level_base[HEIGHT + 1] = {0};

void update_tag(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index, 
  uint32_t mac_req_id, dma_id_t dma_id,dram_addr_t dram_addr){
    int hart_id = -1;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hart_id)
    );
  mac_init(mac_req_id,hart_id,0);
  if (parent_spm_offset == 0){
      mac_buffer_set(0, dma_id,hart_id);
      mac_update(0,63,hart_id);
  } else {
      uint64_t start_bit = 64 + (node_index / MINOR_COUNTER_COUNT) % MINOR_COUNTER_COUNT * MINOR_COUNTER_WIDTH;
      mac_buffer_set(parent_spm_offset, dma_id,hart_id);
      mac_update(0,63,hart_id);
      mac_update(start_bit, start_bit + (MINOR_COUNTER_WIDTH - 1),hart_id);
  }
  mac_buffer_set(child_spm_offset, dma_id,hart_id);
  mac_update(0, 447,hart_id);
  mac_input_core(dram_addr,hart_id);
  mac_digest(child_spm_offset + 56, dma_id,hart_id);
}

static inline uint64_t reencryption(dram_addr_t counter_block_addr,spm_offset_t counter_spm_offset){
  dram_addr_t data_block_addr = PROTECTION_BASE + (counter_block_addr - level_base[HEIGHT]) / 64 * (MINOR_COUNTER_COUNT * 64);
  uint64_t old_major_counter = spm_ld64(counter_spm_offset);
  uint64_t new_major_counter = old_major_counter + 1;
  dma_id_t dma_id;
  for (long i = 0;i < MINOR_COUNTER_COUNT;i++){
    // 必要なデータを読み出す。
    global_dma_id += 1;
    dma_id = global_dma_id;
    dram_addr_t dram_addr = data_block_addr + i * 64;
    spm_copy_to_local(dram_addr, REENCRYPTION_SPM_OFFSET, dma_id);
    // MACブロックの取得
    dram_addr_t datamacblock_addr = get_datamacblock_addr(dram_addr);
    index_t set_index = get_cache_mac_index(datamacblock_addr);
    spm_offset_t spm_offset;
    light_tag_info_t light_info = light_tag_check(datamacblock_addr);
    if (light_info.hit){
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      set_block_dirty(set_index, light_info.way);
    } else {
      global_dma_id += 1;
      dma_id = global_dma_id;
      if (light_info.way == -1){
        light_info.way = get_victim_way(set_index);
        spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
        bool dirty = is_block_dirty(set_index, light_info.way);
        if (dirty){
          dram_addr_t old_block_addr = get_block_addr(set_index, light_info.way);
          spm_write_back(spm_offset, old_block_addr,  0);
        }
      } else {
        set_block_valid(set_index, light_info.way);
        spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      }
      spm_copy_to_local(datamacblock_addr, spm_offset, dma_id);
      set_block_addr(set_index, light_info.way, datamacblock_addr);
      set_block_dirty(set_index, light_info.way);
      // clear_block_dirty(set_index, light_info.way);
    }
    // マイナーカウンターの取得
    uint64_t global_bit_offset = 64 + (i * MINOR_COUNTER_WIDTH);
    spm_sd64(counter_spm_offset, old_major_counter);
    // dmacの比較
    mac_init(global_mac_req_id,0,1);
    mac_buffer_set(REENCRYPTION_SPM_OFFSET, dma_id,0);
    mac_update(0,511,0);
    mac_buffer_set(counter_spm_offset, dma_id,0);
    mac_update(0,63,0);
    mac_update(global_bit_offset, global_bit_offset + MINOR_COUNTER_WIDTH - 1,0);
    mac_input_core(dram_addr,0);
    spm_offset_t dmac_byte_offset = ((dram_addr - PROTECTION_BASE) / 64) % 8 * 8;
    mac_result_compare(spm_offset + dmac_byte_offset,dma_id,0);
    mac_wait(global_mac_req_id,0);
    global_mac_req_id += 1;
    // 3. 読み出すべきアドレス（8Bアライン）と、その中でのビットオフセットを計算
    uint64_t word_offset_bytes = (global_bit_offset / 64) * 8; // 8バイト単位のオフセット
    uint64_t local_bit_offset  = global_bit_offset % 64;       // 64bitワード内での開始ビット
    // 4. 最初の64bitをロードしてシフト
    uint64_t raw_data = spm_ld64(counter_spm_offset + word_offset_bytes);
    uint64_t extracted_val = raw_data >> local_bit_offset;
    // 5. カウンターが64bit境界をまたぐか判定し、必要なら2回目のロードを行う
    // (開始位置 + データ幅 が 64 を超える場合、次のワードにデータがはみ出している)
    if (local_bit_offset + MINOR_COUNTER_WIDTH > 64) {
        uint64_t next_data = spm_ld64(counter_spm_offset + word_offset_bytes + 8);
        // はみ出した分（上位ビット）を結合
        // (64 - local_bit_offset) は、1つ目のワードに残っていたビット数
        extracted_val |= (next_data << (64 - local_bit_offset));
    }
    // 6. ビットマスクを生成して不要な上位ビットを切り落とす;
    uint16_t minor_counter_value = extracted_val & MINOR_COUNTER_MASK;
    // 結果の使用
    set_seed(old_major_counter, minor_counter_value, dram_addr);
    while(AES_START_REG);
    // 復号化
    spm_wait(dma_id);
    xor_start(false,false,0,REENCRYPTION_SPM_OFFSET);
    // 再暗号化
    set_seed(new_major_counter, 0, dram_addr);
    while(AES_START_REG);
    xor_start(false,false,0,REENCRYPTION_SPM_OFFSET);
    // 書き戻し
    spm_write_back(REENCRYPTION_SPM_OFFSET, dram_addr,  0);
    // minorカウンターの更新
    uint64_t word1 = 0;
    uint64_t word2 = 0;
    bool is_split = (local_bit_offset + MINOR_COUNTER_WIDTH > 64);
    // またいでいる場合は次のワードも読む
    word1 = spm_ld64(counter_spm_offset + word_offset_bytes);
    if (is_split) {
        word2 = spm_ld64(counter_spm_offset + word_offset_bytes + 8);
    }
    uint64_t new_minor_val = 0;
    // 5. 書き戻し用データの作成と保存
    // 書き戻しデータのビット幅（Word1に含まれる分）
    uint64_t bits_in_first = is_split ? (64 - local_bit_offset) : MINOR_COUNTER_WIDTH;
    uint64_t mask_first = MINOR_COUNTER_MASK;
    // A. 更新対象の場所を0クリア (Clear)
    word1 &= ~(mask_first << local_bit_offset);
    // B. 新しい値の下位パートをセット (Set)
    word1 |= ((new_minor_val & mask_first) << local_bit_offset);
    // C. 書き込み
    spm_sd64(counter_spm_offset + word_offset_bytes, word1);
    // --- Word 2 の更新（またいでいる場合のみ） ---
    if (is_split) {
        uint64_t bits_in_second = MINOR_COUNTER_WIDTH - bits_in_first;
        uint64_t mask_second = (1ULL << bits_in_second) - 1;
        // A. 更新対象の場所(先頭)を0クリア
        word2 &= ~mask_second;
        // B. 新しい値の上位パートをシフトしてセット
        word2 |= (new_minor_val >> bits_in_first) & mask_second;
        // C. 書き込み
        spm_sd64(counter_spm_offset + word_offset_bytes + 8, word2);
    }
    spm_sd64(counter_spm_offset, new_major_counter);
    // MACの更新
    // uint64_t mac_req_id = global_mac_req_id;
    mac_init(global_mac_req_id,0,1);
    mac_buffer_set(REENCRYPTION_SPM_OFFSET, dma_id,0);
    mac_update(0,511,0);
    mac_buffer_set(counter_spm_offset, dma_id,0);
    mac_update(0,63,0);
    mac_update(global_bit_offset, global_bit_offset + MINOR_COUNTER_WIDTH - 1,0);
    mac_input_core(dram_addr,0);
    mac_digest(spm_offset + dmac_byte_offset,dma_id,0);
    mac_wait(global_mac_req_id,0);
    global_mac_req_id += 1;
  }
  // majorカウンターをインクリメント
  spm_sd64(counter_spm_offset, new_major_counter);
  // // minorカウンターエリアを0クリア
  for (long i = 0;i < MINOR_COUNTER_COUNT * MINOR_COUNTER_WIDTH / 64;i++){
    spm_sd64(counter_spm_offset + 8 + i * 8, 0);
  }
  // return dma_id;
  // exit(1);
  return global_mac_req_id;
}

static inline void verify_one_height(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index, 
    uint32_t mac_req_id, dma_id_t dma_id,dram_addr_t dram_addr){
    int hart_id = -1;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hart_id)
    );
  mac_init(mac_req_id,hart_id,0);
  if (parent_spm_offset == 0){
      mac_buffer_set(0, dma_id,hart_id);
      mac_update(0,63,hart_id);
  } else {
      uint64_t start_bit = 64 + (node_index / MINOR_COUNTER_COUNT) % MINOR_COUNTER_COUNT * MINOR_COUNTER_WIDTH;
      mac_buffer_set(parent_spm_offset, dma_id,hart_id);
      mac_update(0,63,hart_id);
      mac_update(start_bit, start_bit + (MINOR_COUNTER_WIDTH - 1),hart_id);
  }
  mac_buffer_set(child_spm_offset, dma_id,hart_id);
  mac_update(0, 447,hart_id);
  mac_input_core(dram_addr,hart_id);
  mac_result_compare(child_spm_offset + 56, dma_id,hart_id);
}


// 中間ノードのマイナーカウンターがオーバーフローした時の再計算処理
// Eagerアップデート用
static inline uint64_t recalc_tag(dram_addr_t node_dram_addr, spm_offset_t node_spm_offset, int height, long index){
  long block_idx = index / MINOR_COUNTER_COUNT;
  uint64_t maq_req_id = global_mac_req_id;
  dram_addr_t child_base_addr = level_base[height + 2] + block_idx * MINOR_COUNTER_COUNT * 64;
  uint64_t old_major_counter = spm_ld64(node_spm_offset);
  uint64_t new_major_counter = old_major_counter + 1;
  for (long i = 0;i < MINOR_COUNTER_COUNT;i++){
    // 子ノードの検証
    // 子ノードのアドレス計算
    long child_index = (block_idx * MINOR_COUNTER_COUNT + i) * MINOR_COUNTER_COUNT;
    dram_addr_t child_dram_addr = child_base_addr + i * 64;
    light_tag_info_t light_info = light_tag_check(child_dram_addr);
    spm_offset_t child_spm_offset;
    long temp_idx = -1;
    dma_id_t dma_id = global_dma_id;
    if (light_info.hit){
      index_t set_index = get_cache_tree_set_index(child_dram_addr);
      // bool mac_updated = is_mac_updated(set_index, light_info.way);
      // if (!mac_updated){
      //   continue; // MACが更新されていない場合はあとでやればいいのでスキップ
      // } else {
      child_spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      set_block_dirty(set_index, light_info.way);
      // setParentUpdated(set_index, light_info.way);
      // }
    } else {
      // tempバッファを検索
      temp_idx = find_temp_entry(child_dram_addr);
      if (temp_idx >= 0){
        child_spm_offset = get_temp_spm_offset(temp_idx);
      } else {
        child_spm_offset = REENCRYPTION_SPM_OFFSET; // 一時バッファを使用
        global_dma_id += 1;
        dma_id = global_dma_id;
        spm_copy_to_local(child_dram_addr, child_spm_offset, dma_id);
      }
    }
    spm_wait(dma_id);
    spm_sd64(node_spm_offset, old_major_counter);
    verify_one_height(child_spm_offset, node_spm_offset, child_index, maq_req_id, dma_id, child_dram_addr);
    mac_wait(maq_req_id,0);
    maq_req_id += 1;
    uint64_t word1 = 0;
    uint64_t word2 = 0;
    uint64_t global_bit_offset = 64 + (i * MINOR_COUNTER_WIDTH);
    uint64_t local_bit_offset = (i * MINOR_COUNTER_WIDTH) % 64;
    uint64_t word_offset_bytes = (global_bit_offset / 64) * 8;
    bool is_split = (local_bit_offset + MINOR_COUNTER_WIDTH > 64);
    // またいでいる場合は次のワードも読む
    word1 = spm_ld64(node_spm_offset + word_offset_bytes);
    if (is_split) {
        word2 = spm_ld64(node_spm_offset + word_offset_bytes + 8);
    }
    // 3. 現在のマイナーカウンター値の抽出
    // uint64_t current_minor_val = 0;
    // 4. 値の更新（インクリメントとオーバーフロー判定）
    uint64_t new_minor_val = 0;
    // 5. 書き戻し用データの作成と保存
    // 書き戻しデータのビット幅（Word1に含まれる分）
    uint64_t bits_in_first = is_split ? (64 - local_bit_offset) : MINOR_COUNTER_WIDTH;
    uint64_t mask_first = MINOR_COUNTER_MASK;
    // A. 更新対象の場所を0クリア (Clear)
    word1 &= ~(mask_first << local_bit_offset);
    // B. 新しい値の下位パートをセット (Set)
    word1 |= ((new_minor_val & mask_first) << local_bit_offset);
    // C. 書き込み
    spm_sd64(node_spm_offset + word_offset_bytes, word1);
    // --- Word 2 の更新（またいでいる場合のみ） ---
    if (is_split) {
        uint64_t bits_in_second = MINOR_COUNTER_WIDTH - bits_in_first;
        uint64_t mask_second = (1ULL << bits_in_second) - 1;
        // A. 更新対象の場所(先頭)を0クリア
        word2 &= ~mask_second;
        // B. 新しい値の上位パートをシフトしてセット
        word2 |= (new_minor_val >> bits_in_first) & mask_second;
        // C. 書き込み
        spm_sd64(node_spm_offset + word_offset_bytes + 8, word2);
    }
    spm_sd64(node_spm_offset, new_major_counter);
    update_tag(child_spm_offset, node_spm_offset, child_index, maq_req_id, dma_id, child_dram_addr);
    mac_wait(maq_req_id,0);
    maq_req_id += 1;
    if (!light_info.hit){
      if (temp_idx >= 0){
        dirty_temp_entry_by_index(temp_idx);
      } else {
        spm_write_back(child_spm_offset, child_dram_addr, 0);
      }
    }
  }
  global_mac_req_id = maq_req_id;
  // // exit(1);
  // for (int i = 0;i<8;i++){
  //   printf("data[%d] %llx \n", i, spm_ld64(node_spm_offset + i * 8));
  // }
  // exit(1);
  return maq_req_id;
}


static inline void update_one_height(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index, 
  bool update_counter, uint32_t mac_req_id, dma_id_t dma_id,
  dram_addr_t dram_addr){
    int hart_id = -1;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hart_id)
    );
    // ブロックの更新
  spm_wait(dma_id);
  uint64_t mac_req = mac_req_id;
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
        int start_level = -1;
        for (int l = 0; l < HEIGHT; l++) {
          dram_addr_t base = level_base[l+1];
          dram_addr_t next_base = (l < HEIGHT - 1) ? level_base[l+2] : UINT64_MAX;
          if (dram_addr >= base && dram_addr < next_base) {
            start_level = l;
            break;
          }
        }
        #ifdef EAGER
        if (start_level == HEIGHT - 1){
          // リーフノードであるため、再暗号化処理を行う
          mac_req = reencryption(dram_addr, child_spm_offset );
        } else {
          // tag再計算
          mac_req = recalc_tag(dram_addr, child_spm_offset, start_level, node_index);
        }
        #endif
    } else {
        new_minor_val = current_minor_val + 1;
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
    }
  }
  mac_init(mac_req,hart_id, 0);
  if (parent_spm_offset == 0){
      mac_buffer_set(0, dma_id,hart_id);
      mac_update(0,63,hart_id);
  } else {
      uint64_t start_bit = 64 + (node_index / MINOR_COUNTER_COUNT) % MINOR_COUNTER_COUNT * MINOR_COUNTER_WIDTH;
      mac_buffer_set(parent_spm_offset, dma_id,hart_id);
      mac_update(0,63,hart_id);
      mac_update(start_bit, start_bit + (MINOR_COUNTER_WIDTH - 1),hart_id);
  }
  mac_buffer_set(child_spm_offset, dma_id,hart_id);
  mac_update(0, 447,hart_id);
  mac_input_core(dram_addr,hart_id);
  // mac_buffer_set(dram_addr_offset, dma_id);
  // mac_update(0,63);
  mac_digest(child_spm_offset + 56,dma_id,hart_id);
  // return maq_req_id;
}



static inline void evicted_node_update(dram_addr_t old_addr, spm_offset_t old_spm) {
    // printf("evict\n");
      int hartid;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hartid)
    );
    // lock_print();
    // printf("Evicted node update called for addr=%016llx hartid=%d\n", old_addr, hartid);
    // unlock_print();
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
  dram_addr_t v_index = (old_addr - (v_level_base_addr))/ 64 * MINOR_COUNTER_COUNT;
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
  dma_id_t tmp_id = __atomic_load_n(&global_dma_id, __ATOMIC_ACQUIRE);
  wait_dma_id[v_level] = tmp_id;
  for(long i = v_level - 1; i>=0;i--){
      uint64_t index = v_index >> (ARTY_LOG2 * (v_level - i));
      path_indecis[i] = index;
      dram_addr_t dram_addr = index / MINOR_COUNTER_COUNT * 64 + level_base[i+1];
      dram_addr_array[i] = dram_addr;
      while(1){
        lock_tree();
        light_tag_info_t info = light_tag_check(dram_addr);
        // uint64_t tmp_id = global_dma_id;
        if (info.hit){
          long set_index = get_cache_tree_set_index(dram_addr);
          way_index = info.way;
          spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way_index);
          if (acquire_write_block(spm_offset)){
            update_lru_on_access(set_index, way_index);
            clearParentUpdated(set_index, way_index);
            set_block_dirty(set_index, way_index);
            unlock_tree();
            wait_dma_id[i] = __atomic_load_n(&global_dma_id, __ATOMIC_ACQUIRE);
            spm_offset_array[i] = spm_offset;
            load_start_index = i + 1;
            goto AFTER_PATH_CHECK_EVICTION;
          } else {
            unlock_tree();
          }
        } else {
          long idx = find_temp_entry(dram_addr);
          spm_offset_t spm_offset;
          if (idx < 0){
            spm_offset = pop_temp_buffer();
            idx = alloc_temp_entry(dram_addr, spm_offset);
            bool suc = acquire_write_block(spm_offset);
            dirty_temp_entry_by_index(idx);
            unlock_tree();
            if (!suc){
              printf("Error: failed to acquire newly allocated temp entry addr=%016llx spm_offset=%016llx hartid=%d\n", dram_addr, spm_offset, hartid);
              exit(1);
            }
            uint64_t tmp_id = __sync_add_and_fetch(&global_dma_id, 1);
            lock_dma();
            spm_copy_to_local(dram_addr, spm_offset,  tmp_id);
            unlock_dma();
            loaded[i] = true;
            spm_offset_array[i] = spm_offset;
            wait_dma_id[i] = tmp_id;
            break;
          } else {
            spm_offset = get_temp_spm_offset(idx);
            bool suc = acquire_write_block(spm_offset);
            if (!suc){
              unlock_tree();
              for(int j = 0;j<20;j++){}
              continue;
            } else {
              dirty_temp_entry_by_index(idx);
              unlock_tree();
              wait_dma_id[i] = __atomic_load_n(&global_dma_id, __ATOMIC_ACQUIRE);
              spm_offset_array[i] = spm_offset;
              break;
            }
          }
        }
      }
  }
  // ---------------------------------------------------------
AFTER_PATH_CHECK_EVICTION:
  uint64_t verify_end = read_instret();
  uint64_t mac_req_id = 0;
  // v_levelからキャッシュヒットしたところまでを検証
  for (long i = v_level-1;i>=load_start_index;i--){
    spm_offset_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    dma_id_t need_id = (i == 0) ? wait_dma_id[0] : wait_dma_id[i-1];
    // lock_mac();
  //     global_mac_req_id += 1;
  // mac_req_id = global_mac_req_id;
    // global_mac_req_id += ;
    mac_req_id = __sync_fetch_and_add(&global_mac_req_id, 1);
    // mac_req_id += 1;
  #ifdef DUMP
    lock_print();
    printf("Core %d Verification during eviction height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, i, spm_offset_array[i], parent_spm, path_indecis[i], need_id);
    printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[i], mac_req_id);
        // printf("  parent dram_addr=%016llx\n", (i == 0) ? 0 : dram_addr_array[i-1]);
    unlock_print();
  #endif
    verify_one_height(spm_offset_array[i], parent_spm, path_indecis[i], mac_req_id,need_id, dram_addr_array[i]);
    // unlock_mac();
  }
  if (mac_req_id > 0){
    mac_wait(mac_req_id, hartid);
  }
  // printf("[Evict] Verification done.\n");
  // 一時的なルートノードのアップデート
  if (load_start_index == 0){
    // rootノードの更新
    uint64_t root = spm_ld64(0);
    root += 1;
    spm_sd64(0, root);
  } else {
        uint64_t start_level = load_start_index - 1;
    uint64_t minor_idx = path_indecis[start_level] % MINOR_COUNTER_COUNT; 
    uint64_t global_bit_offset = 64 + (minor_idx * MINOR_COUNTER_WIDTH);
    uint64_t base_addr = spm_offset_array[start_level]; // または start_level
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
    if (current_minor_val == MINOR_COUNTER_MASK) {
        // オーバーフロー時の処理
        // printf("[Core FW] Minor counter overflow at level %llu for request_addr=%016llx\n", start_level, request_addr);
        // // pathのdram_addrとインデックスを表示
        // for (uint64_t lvl = start_level; lvl < HEIGHT; lvl++) {
        //     printf("  Level %llu: dram_addr=%016llx, index=%llu\n", lvl, dram_addr_array[lvl], path_indecis[lvl]);
        // }
        // exit(1);
        // if (start_level == HEIGHT - 1){
        //   // リーフノードであるため、再暗号化処理を行う
        //   tmp_id = reencrpytion(dram_addr_array[start_level], spm_offset_array[start_level], tmp_id);
        // } else {
        //   // tag再計算
        //   tmp_id = recalc_tag(dram_addr_array[start_level], spm_offset_array[start_level], tmp_id, start_level, path_indecis[start_level]);
        // }
    } else {
        uint64_t new_minor_val = current_minor_val + 1;
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
    }
  }
  // 木の更新：ルートからv_levelまで降りていく
  for (uint64_t i=load_start_index;i<=v_level;i++){
    spm_offset_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    dma_id_t need_id = (i == 0) ? wait_dma_id[0] : wait_dma_id[i-1];
    // lock_mac();
    // global_mac_req_id += 1;
    mac_req_id = __sync_fetch_and_add(&global_mac_req_id, 1);
    // global_mac_req_id += 1;
    // mac_req_id = global_mac_req_id;
    #ifdef DUMP
    lock_print();
    printf("Core %d Update during eviction height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, i, spm_offset_array[i], parent_spm, path_indecis[i], need_id);
    printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[i], mac_req_id);
        // printf("  parent dram_addr=%016llx\n", (i == 0) ? 0 : dram_addr_array[i-1]);
    unlock_print();
    #endif
    if (i == v_level){
      // 最後はカウンター更新なし
      update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], false,mac_req_id, wait_dma_id[i], dram_addr_array[i]);
    } else {
      update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], true,mac_req_id, wait_dma_id[i], dram_addr_array[i]);
    }
  }
  if (mac_req_id > 0){
    mac_wait(mac_req_id, hartid);
  }
  lock_tree();
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
      lock_dma();
      spm_write_back(temp_spm, dram_addr,  0);
      unlock_dma();
      long ret = push_temp_buffer(temp_spm);
      // __sync_fetch_and_add(&push_count, 1);
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
  unlock_tree();
  // lock_print();
  // printf("Core %d Evicted node update done for addr=%016llx hartid=%d\n", hartid, old_addr, hartid);
  // unlock_print();
  return;
}

static inline void swapp_dram_addr(dram_addr_t dram_addr,bool is_leaf,bool is_write){
  int hartid;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hartid)
    );
  lock_tree();
  long idx = find_temp_entry(dram_addr);
  if (idx == -1){
    unlock_tree();
    return;
  }
  spm_offset_t temp_spm = get_temp_spm_offset(idx);
  bool swappable_temp = swappable_block(temp_spm);
  if (swappable_temp){
    index_t set_index = get_cache_tree_set_index(dram_addr);
    light_tag_info_t light_info = light_tag_check_set(set_index, dram_addr);
    if (light_info.way == -1){
        light_info.way = get_victim_way(set_index);
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
      if (is_leaf && temp_dirty){
        clearParentUpdated(set_index, light_info.way);
      } else {
        setParentUpdated(set_index, light_info.way);
      }
      if (!mac_updated){
        bool suc = acquire_write_block(old_spm);
        if (!suc){
          printf("Error: failed to acquire write block for addr=%016llx S:%ld W:%ld\n", old_dram_addr, set_index, light_info.way);
          exit(1);
        }
        long idx = alloc_temp_entry(old_dram_addr, old_spm);
        dirty_temp_entry_by_index(idx);
        unlock_tree();
        evicted_node_update(old_dram_addr, old_spm);
        lock_tree();
        release_write_block(old_spm);
        if (swappable_block(old_spm)){
          lock_dma();
          spm_write_back(old_spm, old_dram_addr, 0);
          unlock_dma();
          invalidate_temp_entry_by_index(idx);
          ret = push_temp_buffer(old_spm);
          // __sync_fetch_and_add(&push_count, 1);
        }
      } else {
        if (cache_dirty){
          lock_dma();
          spm_write_back(old_spm, old_dram_addr,  0);
          unlock_dma();
        }
        ret = push_temp_buffer(old_spm);
        // __sync_fetch_and_add(&push_count, 1);
      }
      // swapする
      if (ret != 0){
        printf("Error: push failed for swapping: addr=%016llx idx=%ld\n", dram_addr,idx);
        exit(1);
      }
      #ifdef DUMP
      lock_print();
      printf("Core %d swapping cache block addr=%016llx spm_offset %lx S:%ld W:%ld old spm %lx\n",hartid, dram_addr, temp_spm, set_index, light_info.way, old_spm);
      unlock_print();
      #endif
    } else {
      #ifdef DUMP
      lock_print();
      printf("Core %d swapping cache block is non-swappable addr=%016llx spm_offset %lx S:%ld W:%ld\n", hartid, dram_addr, temp_spm, set_index, light_info.way);
      unlock_print();
      #endif
      bool temp_dirty = is_dirty_temp_entry_by_index(idx);
      if (temp_dirty && is_leaf){
        lock_print();
        printf("Error: leaf node dirty but non-swappable addr=%016llx spm_offset %lx S:%ld W:%ld\n", dram_addr, temp_spm, set_index, light_info.way);
        unlock_print();
        exit(1);
      }
      if (temp_dirty){
      lock_dma();
        spm_write_back(temp_spm, dram_addr,  0);
      unlock_dma();
      }
      invalidate_temp_entry_by_index(idx);
      long ret = push_temp_buffer(temp_spm);
      // __sync_fetch_and_add(&push_count, 1);
      if (ret != 0){
        printf("Error: push failed for  addr=%016llx idx=%ld\n", dram_addr,idx);
        exit(1);
      }
    }
  }
  unlock_tree();
  return;
}