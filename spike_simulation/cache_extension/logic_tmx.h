
#include "extension.h"
#include "processor.h"
#include "decode.h"
#include "tmx_encoding.h"
#include "config.h"


// 定義例

class tmx_logic_t  {
public:
  tmx_logic_t();
private:
  // ---- 内部状態（C 実装と同じ構造） ----
  bool      temp_valid     [TEMP_POOL_SIZE];
  bool      temp_dirty     [TEMP_POOL_SIZE];
  bool      temp_loaded    [TEMP_POOL_SIZE];
  uint32_t  temp_ref_count [TEMP_POOL_SIZE];
  uint64_t  temp_dram_addr [TEMP_POOL_SIZE];
  spm_offset_t  temp_spm_offset[TEMP_POOL_SIZE];
  int       temp_pool_top;

  spm_offset_t free_spm_offset_stack[TEMP_POOL_SIZE];
  int      free_spm_offset_top;

  int       free_indices       [TEMP_POOL_SIZE];
  int       free_indices_top;       // スタック top

  int       active_indices     [TEMP_POOL_SIZE];
  int       active_count;           // 有効エントリ数
  int       pos_in_active_list [TEMP_POOL_SIZE];

  // ---- 共通ヘルパ ----

  // エラー時は -1 を返す
  int check_idx(int idx) const;
public:
  void internal_reset();
  // ---- 各命令の "ロジック部分"（レジスタとは独立した関数） ----
  reg_t do_find(uint64_t dram_addr);
  reg_t do_get_spm(int idx) ;

  reg_t do_alloc(uint64_t dram_addr, uint64_t spm_offset);

  reg_t do_invalidate(int idx);

  reg_t do_set_dirty(int idx) ;

  reg_t do_is_dirty(int idx) ;

  reg_t do_acquire(int idx) ;

  reg_t do_release(int idx) ;

  reg_t do_set_loaded(int idx);

  reg_t do_is_loaded(int idx);

  reg_t do_swappable(int idx);
  reg_t do_push(uint64_t spm_offset);
  reg_t do_pop() ;
  reg_t do_show_active_slot();
};
