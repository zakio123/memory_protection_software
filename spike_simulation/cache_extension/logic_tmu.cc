#include "logic_tmu.h"


// 定義例
  
tmu_logic_t::tmu_logic_t() {}

void tmu_logic_t::internal_reset() {
    for (int i = 0; i < TOTAL_SLOTS; i++) {
      tmu_valid[i]      = false;
      tmu_dirty[i]      = false;
      tmu_ref_count[i]  = 0;
      tmu_tag[i]  = 0;
      tmu_spm_offset[i] = CACHE_DATA_SPM_BASE + (i * 64);
    }
  }

int tmu_logic_t::check_idx(int slot_idx) const {
    if (slot_idx < 0 || slot_idx >= TOTAL_SLOTS) {
      std::cerr << "check_idx: idx out of range: " << slot_idx << std::endl;
      exit(1);
      return -1;
    }
    if (!tmu_valid[slot_idx]) {
      std::cerr << "check_idx: idx not valid: " << slot_idx << std::endl;
      exit(1);
      return -1;
    }
    return 0;
  }

  // ---- 各命令の "ロジック部分"（レジスタとは独立した関数） ----
  reg_t tmu_logic_t::do_check_tag(long slot_idx, dram_addr_t dram_addr){
    int search_range = std::min(PHYSICAL_WAYS, int(slot_idx & 0xFFFF));
    slot_idx = slot_idx >> 32;
    // slot_idxを物理wayに変換して、相当するset内でタグチェックを行う
    int set_idx = slot_idx / PHYSICAL_WAYS;
    int ahead_set_idx = slot_idx;
    reg_t hit = false;
    reg_t hit_way = -1;
    for (int k = 0;k < search_range;k++){
      if (tmu_valid[ahead_set_idx + k] && tmu_tag[ahead_set_idx + k] == dram_addr){
        hit = true;
        hit_way = k;
        // タグチェックでヒットした時にLRU更新を行う
        tmu_tree_lru[set_idx] = update_tree_lru(tmu_tree_lru[set_idx], hit_way);
        // hit wayをslot_idxからのオフセットで返す
        reg_t res = (hit_way << 32) | (hit ? 1 : 0);
        if (hit_way >= CACHE_WAYS){
          std::cerr << "do_check_tag: invalid way returned: " << hit_way << std::endl;
          exit(1);
        }
        return res;
      }
    }
    for (int k = 0;k < search_range;k++){
      if (!tmu_valid[ahead_set_idx + k]){
        hit = false;
        hit_way = k;
        if (hit_way >= CACHE_WAYS){
          std::cerr << "do_check_tag: invalid way returned: " << hit_way << std::endl;
          exit(1);
        }
        return (hit_way << 32) | 0;
      }
    }
    
    reg_t res = ((reg_t)(-1) << 32) | 0;
    return res;
  }
  
  reg_t tmu_logic_t::do_acquire(int slot_idx) {
    if (check_idx(slot_idx) < 0) {
      std::cerr << "temp_acquire: invalid idx " << slot_idx << std::endl;
      return (reg_t)-1;
    }
    if (tmu_valid[slot_idx] == false){
      std::cerr << "temp_acquire: invalid at idx " << slot_idx << std::endl;
      return (reg_t)-1;
    }
    tmu_ref_count[slot_idx] += 1;
    return (reg_t)0;
  }

  reg_t tmu_logic_t::do_release(int slot_idx) {
    if (check_idx(slot_idx) < 0) {
      std::cerr << "temp_get_spm: invalid idx " << slot_idx << std::endl;
      return (reg_t)-1;
    }
    if (tmu_valid[slot_idx] == false){
      std::cerr << "temp_acquire: invalid at idx " << slot_idx << std::endl;
      return (reg_t)-1;
    }
    if (tmu_ref_count[slot_idx] == 0) {
      std::cerr << "temp_release: ref_count is already 0 at idx " << slot_idx << std::endl;
      return (reg_t)-1;
    }
    tmu_ref_count[slot_idx] -= 1;
    return (reg_t)0;
  }

  reg_t tmu_logic_t::do_set_tag(int slot_idx, dram_addr_t dram_addr) {
    if (slot_idx < 0 || slot_idx >= TOTAL_SLOTS) {
      std::cerr << "temp_set_tag: idx out of range: " << slot_idx << std::endl;
      return (reg_t)-1;
    }
    if (tmu_ref_count[slot_idx] > 0) {
      std::cerr << "temp_set_tag: ref_count > 0: " << slot_idx << std::endl;
      return (reg_t)-1;
    }
    int set_idx = slot_idx / PHYSICAL_WAYS;
    int way_idx = slot_idx % PHYSICAL_WAYS;
    // ツリー型LRUの更新
    tmu_tree_lru[set_idx] = update_tree_lru(tmu_tree_lru[set_idx], way_idx);
    // タグと状態の設定
    tmu_valid[slot_idx] = true;
    tmu_tag[slot_idx] = dram_addr;
    tmu_dirty[slot_idx] = false;
    tmu_ref_count[slot_idx] = 0;
    return (reg_t)0;
  }

  reg_t tmu_logic_t::do_get_tag(int idx) {
    return (reg_t)tmu_tag[idx];
  }

  reg_t tmu_logic_t::do_set_dirty(int idx) {
    if (idx < 0 || idx >= TOTAL_SLOTS) {
      std::cerr << "temp_set_dirty: idx out of range: " << idx << std::endl;
      return (reg_t)-1;
    }
    if (!tmu_valid[idx]) {
      std::cerr << "temp_set_dirty: idx not valid: " << idx << std::endl;
      return (reg_t)-1;
    }
    tmu_dirty[idx]  = true;
    return (reg_t)0;
  }

  reg_t tmu_logic_t::do_is_dirty(int idx) {
    if (tmu_dirty[idx]) {
      return (reg_t)1;
    } else {
      return (reg_t)0;
    }
  }
  reg_t tmu_logic_t::do_clear_dirty(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_clear_dirty: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    tmu_dirty[idx] = false;
    return (reg_t)0;
  }

  reg_t tmu_logic_t::do_set_spm(int idx, spm_offset_t spm_offset) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_set_spm: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    tmu_spm_offset[idx] = spm_offset;
    return (reg_t)0;
  }

  reg_t tmu_logic_t::do_get_spm(int idx) {
    return (reg_t)tmu_spm_offset[idx];
  }

  reg_t tmu_logic_t::do_is_swappable(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_is_swappable: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    return (tmu_ref_count[idx] == 0) ? (reg_t)1 : (reg_t)0;
  }

  reg_t tmu_logic_t::do_return_metadata(int slot_idx){
    if (check_idx(slot_idx) < 0) {
      std::cerr << "temp_return_metadata: invalid idx " << slot_idx << std::endl;
      return (reg_t)-1;
    }
    // PYHSICAL_WAYS分のvalid,dirty,tree_lruをまとめて返す
    int set_idx = slot_idx / PHYSICAL_WAYS;
    reg_t res = 0;
    for (int i = 0; i < PHYSICAL_WAYS; ++i) {
      res |= ((reg_t)(tmu_valid[set_idx * PHYSICAL_WAYS + i] ? 1 : 0)) << (48 + i);
    }
    for (int i = 0; i < PHYSICAL_WAYS; ++i) {
      res |= ((reg_t)(tmu_dirty[set_idx * PHYSICAL_WAYS + i] ? 1 : 0)) << (32 + i);
    }
    res |= ((reg_t)(tmu_tree_lru[set_idx])) << 16;
    return res;
  }

  reg_t tmu_logic_t::do_set_valid(int idx) {
    if (idx < 0 || idx >= TOTAL_SLOTS) {
      std::cerr << "temp_set_valid: idx out of range: " << idx << std::endl;
      return (reg_t)-1;
    }
    tmu_valid[idx]  = true;
    return (reg_t)0;
  }
  reg_t tmu_logic_t::do_is_valid(int idx) {
    if (tmu_valid[idx]) {
      return (reg_t)1;
    } else {
      return (reg_t)0;
    }
  }

uint16_t tmu_logic_t::update_tree_lru(uint16_t current_lru, int accessed_way) const {
    // ツリー型LRUの更新ロジックを実装
    int node = 0;      // 今いる内部ノードの index (bit 位置)
    int start = 0;     // このノードがカバーする leaf 範囲 [start, end)
    int end   = PHYSICAL_WAYS;
    int leaf  = accessed_way; // アクセスされた leaf の index
    for (int lvl = 0; lvl < PHYSICAL_WAYS_LOG2; ++lvl) {
        int mid = (start + end) / 2;
        bool go_left = (leaf < mid);
        if (go_left) {
            // 左側サブツリーが「最近使われた」→ bit[node] = 0
            current_lru &= ~(uint16_t(1) << node);
            // 次は左の子へ
            end = mid;
            node = 2*node + 1; // 左子
        } else {
            // 右側サブツリーが「最近使われた」→ bit[node] = 1
            current_lru |=  (uint16_t(1) << node);
            // 次は右の子へ
            start = mid;
            node = 2*node + 2; // 右子
        }
    }
    return current_lru;
}