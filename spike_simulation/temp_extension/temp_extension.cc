// temp_extension.cc
#include "extension.h"
#include "processor.h"
#include "decode.h"

// ★ここに追加：レジスタ表示用のフォーマッタを自分で定義する
// x_reg_t は「汎用レジスタ(x0-x31)」を表示するためのクラスです。
// 引数は命令ビット内でのシフト量です（RISC-V仕様準拠）。
// static const sreg_t x_rd(7);
// static const sreg_t x_rs1(15);
// static const sreg_t x_rs2(20);
#define OPCODE_CUSTOM0 0x0b

// マクロ: MATCH値生成ヘルパ (funct3, funct7, opcode)
// 命令ビット: funct7(31:25) | rs2(24:20) | rs1(19:15) | funct3(14:12) | rd(11:7) | opcode(6:0)
#define INSN_MATCH(funct3, funct7) \
  (((funct7) << 25) | ((funct3) << 12) | OPCODE_CUSTOM0)

// マクロ: MASK値生成ヘルパ (funct7, funct3, opcode を見る。rd, rs1, rs2 はマスク0)
#define INSN_MASK \
  (0xFE00707F) 

// 定義例
  #define MATCH_TEMP_FIND       INSN_MATCH(0, 0x00)
  #define MASK_TEMP_FIND        INSN_MASK
  #define MATCH_TEMP_GET_SPM    INSN_MATCH(0, 0x01)
  #define MASK_TEMP_GET_SPM     INSN_MASK
  #define MATCH_TEMP_ALLOC      INSN_MATCH(0, 0x02)
  #define MASK_TEMP_ALLOC       INSN_MASK
  #define MATCH_TEMP_INVALID    INSN_MATCH(0, 0x03)
  #define MASK_TEMP_INVALID     INSN_MASK
  #define MATCH_TEMP_SET_DIRTY  INSN_MATCH(0, 0x04)
  #define MASK_TEMP_SET_DIRTY   INSN_MASK
  #define MATCH_TEMP_IS_DIRTY   INSN_MATCH(0, 0x05)
  #define MASK_TEMP_IS_DIRTY    INSN_MASK
  #define MATCH_TEMP_ACQUIRE    INSN_MATCH(0, 0x06)
  #define MASK_TEMP_ACQUIRE     INSN_MASK
  #define MATCH_TEMP_RELEASE    INSN_MATCH(0, 0x07)
  #define MASK_TEMP_RELEASE     INSN_MASK
  #define MATCH_TEMP_SET_LOAD   INSN_MATCH(0, 0x08)
  #define MASK_TEMP_SET_LOAD    INSN_MASK
  #define MATCH_TEMP_IS_LOAD    INSN_MATCH(0, 0x09)
  #define MASK_TEMP_IS_LOAD     INSN_MASK
  #define MATCH_TEMP_SWAPPABLE  INSN_MATCH(0, 0x0A)
  #define MASK_TEMP_SWAPPABLE   INSN_MASK
  #define MATCH_TEMP_POP      INSN_MATCH(0, 0x0B)
  #define MASK_TEMP_POP       INSN_MASK
  #define MATCH_TEMP_PUSH     INSN_MATCH(0, 0x0C)
  #define MASK_TEMP_PUSH      INSN_MASK

static const int TEMP_MAX_ENTRIES = 64; // TEMP_POOL_SIZE に合わせて変更

class temp_extension_t : public extension_t {
public:
  temp_extension_t() {
    internal_reset();
  }

  const char* name() const override {
    return "temp_ext";
  }

  void reset(processor_t&) override {
  }

  // ---- 命令テーブルの登録 ----
  std::vector<insn_desc_t> get_instructions(const processor_t& proc) override {
    std::vector<insn_desc_t> v;
    v.push_back((insn_desc_t){
      MATCH_TEMP_FIND, MASK_TEMP_FIND,
      &temp_extension_t::exec_temp_find, // fast_rv32i
      &temp_extension_t::exec_temp_find, // fast_rv64i
      &temp_extension_t::exec_temp_find, // fast_rv32e
      &temp_extension_t::exec_temp_find, // fast_rv64e
      &temp_extension_t::exec_temp_find, // logged_rv32i
      &temp_extension_t::exec_temp_find, // logged_rv64i
      &temp_extension_t::exec_temp_find, // logged_rv32e
      &temp_extension_t::exec_temp_find  // logged_rv64e
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_GET_SPM, MASK_TEMP_GET_SPM,
      &temp_extension_t::exec_temp_get_spm,
      &temp_extension_t::exec_temp_get_spm,
      &temp_extension_t::exec_temp_get_spm,
      &temp_extension_t::exec_temp_get_spm,
      &temp_extension_t::exec_temp_get_spm,
      &temp_extension_t::exec_temp_get_spm,
      &temp_extension_t::exec_temp_get_spm,
      &temp_extension_t::exec_temp_get_spm
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_ALLOC, MASK_TEMP_ALLOC,
      &temp_extension_t::exec_temp_alloc,
      &temp_extension_t::exec_temp_alloc,
      &temp_extension_t::exec_temp_alloc,
      &temp_extension_t::exec_temp_alloc,
      &temp_extension_t::exec_temp_alloc,
      &temp_extension_t::exec_temp_alloc,
      &temp_extension_t::exec_temp_alloc,
      &temp_extension_t::exec_temp_alloc
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_INVALID, MASK_TEMP_INVALID,
      &temp_extension_t::exec_temp_invalidate,
      &temp_extension_t::exec_temp_invalidate,
      &temp_extension_t::exec_temp_invalidate,
      &temp_extension_t::exec_temp_invalidate,
      &temp_extension_t::exec_temp_invalidate,
      &temp_extension_t::exec_temp_invalidate,
      &temp_extension_t::exec_temp_invalidate,
      &temp_extension_t::exec_temp_invalidate
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_SET_DIRTY, MASK_TEMP_SET_DIRTY,
      &temp_extension_t::exec_temp_set_dirty,
      &temp_extension_t::exec_temp_set_dirty,
      &temp_extension_t::exec_temp_set_dirty,
      &temp_extension_t::exec_temp_set_dirty,
      &temp_extension_t::exec_temp_set_dirty,
      &temp_extension_t::exec_temp_set_dirty,
      &temp_extension_t::exec_temp_set_dirty,
      &temp_extension_t::exec_temp_set_dirty
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_IS_DIRTY, MASK_TEMP_IS_DIRTY,
      &temp_extension_t::exec_temp_is_dirty,
      &temp_extension_t::exec_temp_is_dirty,
      &temp_extension_t::exec_temp_is_dirty,
      &temp_extension_t::exec_temp_is_dirty,
      &temp_extension_t::exec_temp_is_dirty,
      &temp_extension_t::exec_temp_is_dirty,
      &temp_extension_t::exec_temp_is_dirty,
      &temp_extension_t::exec_temp_is_dirty
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_ACQUIRE, MASK_TEMP_ACQUIRE,
      &temp_extension_t::exec_temp_acquire,
      &temp_extension_t::exec_temp_acquire,
      &temp_extension_t::exec_temp_acquire,
      &temp_extension_t::exec_temp_acquire,
      &temp_extension_t::exec_temp_acquire,
      &temp_extension_t::exec_temp_acquire,
      &temp_extension_t::exec_temp_acquire,
      &temp_extension_t::exec_temp_acquire
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_RELEASE, MASK_TEMP_RELEASE,
      &temp_extension_t::exec_temp_release,
      &temp_extension_t::exec_temp_release,
      &temp_extension_t::exec_temp_release,
      &temp_extension_t::exec_temp_release,
      &temp_extension_t::exec_temp_release,
      &temp_extension_t::exec_temp_release,
      &temp_extension_t::exec_temp_release,
      &temp_extension_t::exec_temp_release
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_SET_LOAD, MASK_TEMP_SET_LOAD,
      &temp_extension_t::exec_temp_set_loaded,
      &temp_extension_t::exec_temp_set_loaded,
      &temp_extension_t::exec_temp_set_loaded,
      &temp_extension_t::exec_temp_set_loaded,
      &temp_extension_t::exec_temp_set_loaded,
      &temp_extension_t::exec_temp_set_loaded,
      &temp_extension_t::exec_temp_set_loaded,
      &temp_extension_t::exec_temp_set_loaded
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_IS_LOAD, MASK_TEMP_IS_LOAD,
      &temp_extension_t::exec_temp_is_loaded,
      &temp_extension_t::exec_temp_is_loaded,
      &temp_extension_t::exec_temp_is_loaded,
      &temp_extension_t::exec_temp_is_loaded,
      &temp_extension_t::exec_temp_is_loaded,
      &temp_extension_t::exec_temp_is_loaded,
      &temp_extension_t::exec_temp_is_loaded,
      &temp_extension_t::exec_temp_is_loaded
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_SWAPPABLE, MASK_TEMP_SWAPPABLE,
      &temp_extension_t::exec_temp_swappable,
      &temp_extension_t::exec_temp_swappable,
      &temp_extension_t::exec_temp_swappable,
      &temp_extension_t::exec_temp_swappable,
      &temp_extension_t::exec_temp_swappable,
      &temp_extension_t::exec_temp_swappable,
      &temp_extension_t::exec_temp_swappable,
      &temp_extension_t::exec_temp_swappable
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_POP, MASK_TEMP_POP,
      &temp_extension_t::exec_temp_pop,
      &temp_extension_t::exec_temp_pop,
      &temp_extension_t::exec_temp_pop,
      &temp_extension_t::exec_temp_pop,
      &temp_extension_t::exec_temp_pop,
      &temp_extension_t::exec_temp_pop,
      &temp_extension_t::exec_temp_pop,
      &temp_extension_t::exec_temp_pop
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_PUSH, MASK_TEMP_PUSH,
      &temp_extension_t::exec_temp_push,
      &temp_extension_t::exec_temp_push,
      &temp_extension_t::exec_temp_push,
      &temp_extension_t::exec_temp_push,
      &temp_extension_t::exec_temp_push,
      &temp_extension_t::exec_temp_push,
      &temp_extension_t::exec_temp_push,
      &temp_extension_t::exec_temp_push
    });
    return v;
  }
    // ディスアセンブル（命令名表示）のために必要
  std::vector<disasm_insn_t*> get_disasms(const processor_t *proc) override {
      std::vector<disasm_insn_t*> insns;
      // // ここで名前 "temp_find" を登録する
      // insns.push_back(new disasm_insn_t("temp_find", MATCH_TEMP_FIND, MASK_TEMP_FIND, {&x_rd, &x_rs1}));
      // // 他の命令も同様に...
      return insns;
  }

private:
  void internal_reset() {
    for (int i = 0; i < TEMP_MAX_ENTRIES; i++) {
      temp_valid[i]      = false;
      temp_dirty[i]      = false;
      temp_loaded[i]     = false;
      temp_ref_count[i]  = 0;
      temp_dram_addr[i]  = 0;
      temp_spm_offset[i] = 0;

      active_indices[i]      = 0;
      pos_in_active_list[i]  = 0;
      free_indices[i]        = i;
    }
    active_count     = 0;
    free_indices_top = TEMP_MAX_ENTRIES - 1;
    free_spm_offset_top = -1;
  }
  // ---- 内部状態（C 実装と同じ構造） ----
  bool      temp_valid     [TEMP_MAX_ENTRIES];
  bool      temp_dirty     [TEMP_MAX_ENTRIES];
  bool      temp_loaded    [TEMP_MAX_ENTRIES];
  uint32_t  temp_ref_count [TEMP_MAX_ENTRIES];
  uint64_t  temp_dram_addr [TEMP_MAX_ENTRIES];
  uint64_t  temp_spm_offset[TEMP_MAX_ENTRIES];

  uint64_t free_spm_offset_stack[TEMP_MAX_ENTRIES];
  int      free_spm_offset_top;

  int       free_indices       [TEMP_MAX_ENTRIES];
  int       free_indices_top;       // スタック top

  int       active_indices     [TEMP_MAX_ENTRIES];
  int       active_count;           // 有効エントリ数
  int       pos_in_active_list [TEMP_MAX_ENTRIES];

  // ---- 共通ヘルパ ----

  // エラー時は -1 を返す
  int check_idx(int idx) const {
    if (idx < 0 || idx >= TEMP_MAX_ENTRIES) {
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

  reg_t do_find(uint64_t dram_addr) {
    int res = -1;
    for (int k = 0; k < active_count; k++) {
      int idx = active_indices[k];
      if (temp_dram_addr[idx] == dram_addr) {
        res = idx;
        break;
      }
    }
    return (reg_t)res;
  }

  reg_t do_get_spm(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_get_spm: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    return (reg_t)temp_spm_offset[idx];
  }

  reg_t do_alloc(uint64_t dram_addr, uint64_t spm_offset) {
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

  reg_t do_invalidate(int idx) {
    if (idx < 0 || idx >= TEMP_MAX_ENTRIES) {
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

    int pos      = pos_in_active_list[idx];
    int last_idx = active_indices[active_count - 1];

    active_indices[pos] = last_idx;
    pos_in_active_list[last_idx] = pos;
    active_count--;

    free_indices[++free_indices_top] = idx;

    return (reg_t)0;
  }

  reg_t do_set_dirty(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_set_dirty: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    temp_dirty[idx] = true;
    return (reg_t)0;
  }

  reg_t do_is_dirty(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_is_dirty: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    return temp_dirty[idx] ? (reg_t)1 : (reg_t)0;
  }

  reg_t do_acquire(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_acquire: invalid idx " << idx << std::endl;
      return (reg_t)0; // bool false
    }
    temp_ref_count[idx] += 1;
    return (reg_t)1;
  }

  reg_t do_release(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_release: invalid idx " << idx << std::endl;
      return (reg_t)0;
    }
    if (temp_ref_count[idx] == 0) return (reg_t)0;
    temp_ref_count[idx] -= 1;
    return (reg_t)1;
  }

  reg_t do_set_loaded(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_set_loaded: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    temp_loaded[idx] = true;
    return (reg_t)0;
  }

  reg_t do_is_loaded(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_is_loaded: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    return temp_loaded[idx] ? (reg_t)1 : (reg_t)0;
  }

  reg_t do_swappable(int idx) {
    if (check_idx(idx) < 0) {
      std::cerr << "temp_swappable: invalid idx " << idx << std::endl;
      return (reg_t)-1;
    }
    return (temp_ref_count[idx] == 0) ? (reg_t)1 : (reg_t)0;
  }
  reg_t do_push(uint64_t spm_offset) {
    if (free_indices_top >= TEMP_MAX_ENTRIES - 1) {
      std::cerr << "temp_push: no free indices available" << std::endl;
      return (reg_t)-1; // 空きなし
    }
    free_spm_offset_stack[++free_spm_offset_top] = spm_offset;
    return (reg_t)0;
  }
  reg_t do_pop() {
    if (free_spm_offset_top < 0) {
      std::cerr << "temp_pop: no spm offsets available" << std::endl;
      return (reg_t)-1; // 空
    }
    return (reg_t)free_spm_offset_stack[free_spm_offset_top--];
  }

  // ---- 各命令の exec_* ラッパ（Spike が呼ぶ） ----
  // RS1/RS2/WRITE_RD は decode.h 由来のマクロを想定

  static reg_t exec_temp_find(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<temp_extension_t*>(p->get_extension("temp_ext"));
    reg_t rs1 = p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->do_find(rs1);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_temp_get_spm(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<temp_extension_t*>(p->get_extension("temp_ext"));
    int idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->do_get_spm(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_temp_alloc(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<temp_extension_t*>(p->get_extension("temp_ext"));
    reg_t addr = (reg_t)p->get_state()->XPR[insn.rs1()];
    reg_t spm  = (reg_t)p->get_state()->XPR[insn.rs2()];
    reg_t res  = ext->do_alloc(addr, spm);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_temp_invalidate(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<temp_extension_t*>(p->get_extension("temp_ext"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->do_invalidate(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_temp_set_dirty(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<temp_extension_t*>(p->get_extension("temp_ext"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->do_set_dirty(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_temp_is_dirty(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<temp_extension_t*>(p->get_extension("temp_ext"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->do_is_dirty(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_temp_acquire(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<temp_extension_t*>(p->get_extension("temp_ext"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->do_acquire(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_temp_release(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<temp_extension_t*>(p->get_extension("temp_ext"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->do_release(idx);
      int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_temp_set_loaded(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<temp_extension_t*>(p->get_extension("temp_ext"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->do_set_loaded(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_temp_is_loaded(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<temp_extension_t*>(p->get_extension("temp_ext"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->do_is_loaded(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_temp_swappable(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<temp_extension_t*>(p->get_extension("temp_ext"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->do_swappable(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_temp_push(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<temp_extension_t*>(p->get_extension("temp_ext"));
    uint64_t spm_offset = (uint64_t)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->do_push(spm_offset);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_temp_pop(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<temp_extension_t*>(p->get_extension("temp_ext"));
    reg_t res = ext->do_pop();
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
};

// 実際にはどこかで factory に登録する必要がある:
REGISTER_EXTENSION(temp_extension, []() { return new temp_extension_t; })
