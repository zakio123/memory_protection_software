// temp_extension.cc
#include "extension.h"
#include "processor.h"
#include "decode.h"
#include "tmu_encoding.h"
#include "config.h"


// 定義例
  
class tmu_logic_t  {
public:
  tmu_logic_t();

private:

  // ---- 内部状態（C 実装と同じ構造） ----
  const int BIT_ARRAY_SIZE = 32;
  bool      tmu_valid     [TOTAL_SLOTS];
  bool      tmu_dirty     [TOTAL_SLOTS];
  dram_addr_t  tmu_tag       [TOTAL_SLOTS];
  spm_offset_t  tmu_spm_offset[TOTAL_SLOTS];
  uint16_t tmu_tree_lru[TOTAL_SLOTS / PHYSICAL_WAYS]; // ツリー型LRU用配列
  bool tmu_bit_array[TOTAL_SLOTS][TMU_BIT_ARRAY_SIZE]; // ビット配列拡張用
  uint32_t  tmu_r_ref_count [TOTAL_SLOTS + TEMP_POOL_SIZE];
  uint32_t  tmu_w_ref_count [TOTAL_SLOTS + TEMP_POOL_SIZE];

  int check_idx(int slot_idx) const;
  uint16_t update_tree_lru(uint16_t current_lru, int accessed_way) const;
public:
  void internal_reset();
// ---- 各命令の "ロジック部分"（レジスタとは独立した関数） ----
  reg_t do_check_tag(long slot_idx, dram_addr_t dram_addr);
  
  reg_t do_acquire(spm_offset_t spm_offset, bool is_write) ;
  reg_t do_release(spm_offset_t spm_offset, bool is_write) ;

  reg_t do_set_tag(int slot_idx, dram_addr_t dram_addr);
  reg_t do_get_tag(int idx);
  reg_t do_set_dirty(int idx);
  reg_t do_is_dirty(int idx);
  reg_t do_clear_dirty(int idx);

  reg_t do_set_spm(int idx, spm_offset_t spm_offset);

  reg_t do_get_spm(int idx);

  reg_t do_is_swappable(spm_offset_t spm_offset);

  reg_t do_return_metadata(int slot_idx);

  reg_t do_set_valid(int idx);
  reg_t do_is_valid(int idx);

  reg_t do_set_bit(int idx, int bit_pos);
  reg_t do_clear_bit(int idx, int bit_pos);
  reg_t do_is_bit_set(int idx, int bit_pos);
  reg_t do_show_ref_count(spm_offset_t spm_offset);
  reg_t do_light_tag_check(long slot_idx, dram_addr_t dram_addr);

  reg_t do_get_way(long slot_idx, dram_addr_t dram_addr);
  reg_t do_hit(long slot_idx, dram_addr_t dram_addr);
};