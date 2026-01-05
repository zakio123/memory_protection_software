#include "logic_tmx.h"
tmx_logic_t::tmx_logic_t() {}
void tmx_logic_t::internal_reset() {
    for (int i = 0; i < TEMP_POOL_SIZE; i++) {
      temp_valid[i]      = false;
      temp_dirty[i]      = false;
      temp_loaded[i]     = false;
      temp_ref_count[i]  = 0;
      temp_dram_addr[i]  = 0;
      temp_spm_offset[i] = 0;

      active_indices[i]      = 0;
      pos_in_active_list[i]  = -1;
      free_indices[i]        = i;
    }
    active_count     = 0;
    free_indices_top = TEMP_POOL_SIZE - 1;
    free_spm_offset_top = -1;
    std::cout << "tmx_logic_t internal reset completed." << std::endl;
  }
// エラー時は -1 を返す
int tmx_logic_t::check_idx(int idx) const {
    if (idx < 0 || idx >= TEMP_POOL_SIZE) {
      std::cerr << "check_idx: idx out of range: " << idx << std::endl;
      return -1;
    }
    if (!temp_valid[idx]) {
      std::cerr << "check_idx: idx not valid: " << idx << std::endl;
      return -1;
    }
    return 0;
  }

// ---- 各命令の "ロジック部分"（レジスタとは独立した関数） ----
  reg_t tmx_logic_t::do_find(uint64_t dram_addr) {
    int res = -1;
    for (int k = 0; k < active_count; k++) {
      int idx = active_indices[k];
      if (temp_dram_addr[idx] == dram_addr && temp_valid[idx]) {
        res = idx;
        break;
      }
    }
    return (reg_t)res;
  }

  reg_t tmx_logic_t::do_get_spm(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_get_spm: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    return (reg_t)temp_spm_offset[idx];
  }

  reg_t tmx_logic_t::do_alloc(uint64_t dram_addr, uint64_t spm_offset) {
    if (free_indices_top < 0) {
      std::cerr << "temp_alloc: no free indices available" << std::endl;
      return (reg_t)-1; // 空きなし
    }
    int idx = free_indices[free_indices_top--];

    temp_valid[idx]      = true;
    temp_dirty[idx]      = false;
    temp_loaded[idx]     = false;
    temp_dram_addr[idx]  = dram_addr;
    temp_spm_offset[idx] = spm_offset;
    temp_ref_count[idx]  = 0;

    active_indices[active_count] = idx;
    pos_in_active_list[idx]      = active_count;
    active_count++;

    return (reg_t)idx;
  }

  reg_t tmx_logic_t::do_invalidate(int idx) {
    if (idx < 0 || idx >= TEMP_POOL_SIZE) {
      std::cerr << "temp_invalidate: idx out of range: " << idx << std::endl;
      return (reg_t)-1;
    }
    if (!temp_valid[idx]) {
      std::cerr << "temp_invalidate: idx not valid: " << idx << std::endl;
      return (reg_t)-1;
    }
    if (temp_ref_count[idx] > 0) {
      std::cerr << "temp_invalidate: ref_count > 0: " << idx << std::endl;
      return (reg_t)-1;
    }
    temp_valid[idx]  = false;
    temp_dirty[idx]  = false;
    temp_loaded[idx] = false;
    temp_dram_addr[idx] = 0;
    temp_spm_offset[idx] = 0;

    int pos      = pos_in_active_list[idx];
    int last_idx = active_indices[active_count - 1];

    active_indices[pos] = last_idx;
    pos_in_active_list[last_idx] = pos;
    active_count--;

    free_indices[++free_indices_top] = idx;
    return (reg_t)0;
  }

  reg_t tmx_logic_t::do_set_dirty(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_set_dirty: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    temp_dirty[idx] = true;
    return (reg_t)0;
  }

  reg_t tmx_logic_t::do_is_dirty(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_is_dirty: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    return temp_dirty[idx] ? (reg_t)1 : (reg_t)0;
  }

  reg_t tmx_logic_t::do_acquire(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_acquire: invalid idx " << idx << std::endl;
      return (reg_t)0; // bool false
    }
    temp_ref_count[idx] += 1;
    return (reg_t)1;
  }

  reg_t tmx_logic_t::do_release(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_release: invalid idx " << idx << std::endl;
      return (reg_t)0;
    }
    if (temp_ref_count[idx] == 0) return (reg_t)0;
    temp_ref_count[idx] -= 1;
    return (reg_t)1;
  }

  reg_t tmx_logic_t::do_set_loaded(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_set_loaded: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    temp_loaded[idx] = true;
    return (reg_t)0;
  }

  reg_t tmx_logic_t::do_is_loaded(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_is_loaded: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    return temp_loaded[idx] ? (reg_t)1 : (reg_t)0;
  }

  reg_t tmx_logic_t::do_swappable(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_swappable: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    return (temp_ref_count[idx] == 0) ? (reg_t)1 : (reg_t)0;
  }
  
  reg_t tmx_logic_t::do_push(uint64_t spm_offset) {
    if (free_spm_offset_top >= TEMP_POOL_SIZE - 1) {
      std::cerr << "temp_push: no free indices available" << std::endl;
      return (reg_t)-1; // 空きなし
    }
    // 既に存在するかチェック
    for (int i = 0; i <= free_spm_offset_top; i++) {
      if (free_spm_offset_stack[i] == spm_offset) {
        std::cerr << "temp_push: spm_offset already in stack: " << spm_offset << std::endl;
        return (reg_t)-1; // 重複
      }
    }
    free_spm_offset_stack[++free_spm_offset_top] = spm_offset;
    return (reg_t)0;
  }
  reg_t tmx_logic_t::do_pop() {
    if (free_spm_offset_top < 0) {
      std::cerr << "temp_pop: no spm offsets available" << std::endl;
      return (reg_t)-1; // 空
    }
    return (reg_t)free_spm_offset_stack[free_spm_offset_top--];
  }
  reg_t tmx_logic_t::do_show_active_slot(){
    std::cout << "Active temp slots:" << std::endl;
    for (int k = 0; k < active_count; k++) {
      int idx = active_indices[k];
      std::cout << "  Index: " << idx
                << " Addr: " << std::hex << temp_dram_addr[idx]
                << " SPM: " << temp_spm_offset[idx]
                << " Dirty: " << (temp_dirty[idx] ? "Yes" : "No")
                << " Loaded: " << (temp_loaded[idx] ? "Yes" : "No")
                << " RefCount: " << std::dec << temp_ref_count[idx]
                << std::endl;
    }
    return (reg_t)0;
  }
