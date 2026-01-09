#include "cache_controll.h"
#include "spm_rwlock.h"
uint64_t global_mac_req_id = 1;
uint64_t global_dma_id = 0;
dram_addr_t level_base[HEIGHT + 1] = {0};



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

static inline void update_one_height(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index, 
  bool update_counter, uint32_t mac_req_id, dma_id_t dma_id,
  dram_addr_t dram_addr){
    int hart_id = -1;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hart_id)
    );
  mac_init(mac_req_id,hart_id, 0);
  if (parent_spm_offset == 0){
      mac_buffer_set(0, dma_id,hart_id);
      mac_update(0,63,hart_id);
  } else {
      uint64_t start_bit = 64 + (node_index / MINOR_COUNTER_COUNT) % MINOR_COUNTER_COUNT * MINOR_COUNTER_WIDTH;
      mac_buffer_set(parent_spm_offset, dma_id,hart_id);
      mac_update(0,63,hart_id);
      mac_update(start_bit, start_bit + (MINOR_COUNTER_WIDTH - 1),hart_id);
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
  mac_buffer_set(child_spm_offset, dma_id,hart_id);
  mac_update(0, 447,hart_id);
  mac_input_core(dram_addr,hart_id);
  // mac_buffer_set(dram_addr_offset, dma_id);
  // mac_update(0,63);
  mac_digest(child_spm_offset + 56,dma_id,hart_id);
}

static inline void evicted_node_update(dram_addr_t old_addr, spm_offset_t old_spm) {
    // printf("evict\n");
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
  lock_dma();
  dma_id_t tmp_id = global_dma_id;
  wait_dma_id[v_level] = tmp_id;
  unlock_dma();
  for(long i = v_level - 1; i>=0;i--){
      uint64_t index = v_index >> (ARTY_LOG2 * (v_level - i));
      path_indecis[i] = index;
      dram_addr_t dram_addr = index / MINOR_COUNTER_COUNT * 64 + level_base[i+1];
      dram_addr_array[i] = dram_addr;
      while(1){
        lock_dma();
        light_tag_info_t info = light_tag_check(dram_addr);
        uint64_t tmp_id = global_dma_id;
        if (info.hit){
          long set_index = get_cache_tree_set_index(dram_addr);
          way_index = info.way;
          spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way_index);
          update_lru_on_access(set_index, way_index);
          if (acquire_write_block(spm_offset)){
            clearParentUpdated(set_index, way_index);
            set_block_dirty(set_index, way_index);
            unlock_dma();
            spm_offset_array[i] = spm_offset;
            wait_dma_id[i] = tmp_id;
            load_start_index = i + 1;
            goto AFTER_PATH_CHECK_EVICTION;
          } else {
            unlock_dma();
          }
        } else {
          long idx = find_temp_entry(dram_addr);
          spm_offset_t spm_offset;
          if (idx == -1){
            spm_offset = pop_temp_buffer();
            if (swappable_block(spm_offset) == false){
              int hartid;
              asm volatile(
                  "csrr %0, mhartid"
                  : "=r"(hartid)
              );
              printf("Warning: evict non-swappable temp block used hartid=%d\n", hartid);
              exit(1);
            }
            // __sync_fetch_and_add(&pop_count, 1);
            idx = alloc_temp_entry(dram_addr, spm_offset);
            global_dma_id += 1;
            tmp_id = global_dma_id;
            spm_copy_to_local(dram_addr, spm_offset, 64, tmp_id);
            loaded[i] = true;
          } else {
            spm_offset = get_temp_spm_offset(idx);
          }
          if (acquire_write_block(spm_offset)){
            dirty_temp_entry_by_index(idx);
            unlock_dma();
            wait_dma_id[i] = tmp_id; 
            spm_offset_array[i] = spm_offset;
            break;
          } else {
            unlock_dma();
            for(int j = 0;j<20;j++){}
          }
        }
      }
  }
  // ---------------------------------------------------------
AFTER_PATH_CHECK_EVICTION:
  uint64_t verify_end = read_instret();
  uint64_t mac_req_id = 0;
  int hartid;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hartid)
    );
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
    // mac_wait(mac_req_id, 0);
    // unlock_mac();
    // if (i < v_level){
    //   lock_dma();
    //   long idx = find_temp_entry(dram_addr_array[i]);
    //   if (idx == -1){
    //       printf("Error: not temp entry still exists for addr=%016llx\n", dram_addr_array[i]);
    //       exit(1);
    //   }
    //   dirty_temp_entry_by_index(idx);
    //   unlock_dma();
    // }
  }
  if (mac_req_id > 0){
    mac_wait(mac_req_id, hartid);
  }
  lock_dma();
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
      spm_write_back(temp_spm, dram_addr, 64, 0);
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
  unlock_dma();
  return;
}

static inline void swapp_dram_addr(dram_addr_t dram_addr){
  int hartid;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hartid)
    );
  lock_dma();
  long idx = find_temp_entry(dram_addr);
  if (idx == -1){
    unlock_dma();
    return;
  }
  spm_offset_t temp_spm = get_temp_spm_offset(idx);
  bool swappable_temp = swappable_block(temp_spm);
  if (swappable_temp){
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
      swapp_temp_cache(dram_addr, temp_spm, temp_dirty, light_info.way);
      long ret = invalidate_temp_entry_by_index(idx);
      setParentUpdated(set_index, light_info.way);
      if (!mac_updated){
        bool suc = acquire_write_block(old_spm);
        if (!suc){
          printf("Error: failed to acquire write block for addr=%016llx S:%ld W:%ld\n", old_dram_addr, set_index, light_info.way);
          exit(1);
        }
        long idx = alloc_temp_entry(old_dram_addr, old_spm);
        dirty_temp_entry_by_index(idx);
        unlock_dma();
        evicted_node_update(old_dram_addr, old_spm);
        lock_dma();
        release_write_block(old_spm);
        if (swappable_block(old_spm)){
          spm_write_back(old_spm, old_dram_addr, 64, 0);
          invalidate_temp_entry_by_index(idx);
          ret = push_temp_buffer(old_spm);
          // __sync_fetch_and_add(&push_count, 1);
        }
      } else {
        if (cache_dirty){
          spm_write_back(old_spm, old_dram_addr, 64, 0);
        }
        ret = push_temp_buffer(old_spm);
        // __sync_fetch_and_add(&push_count, 1);
      }
      // swapする
      if (ret != 0){
        // int pop_counter = __atomic_load_n(&pop_count, __ATOMIC_ACQUIRE);
        // int push_counter = __atomic_load_n(&push_count, __ATOMIC_ACQUIRE);
        printf("Error: push failed for swapping: addr=%016llx idx=%ld\n", dram_addr,idx);
        // printf("  mac_updated=%d\n", mac_updated);
        // printf("  push_count=%d, pop_count=%d\n", push_counter, pop_counter);
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
      if (temp_dirty){
          spm_write_back(temp_spm, dram_addr, 64, 0);
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
  unlock_dma();
  return;
}