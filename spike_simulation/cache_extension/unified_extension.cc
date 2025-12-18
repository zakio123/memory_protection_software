#include "extension.h"
#include "tmx_encoding.h"
#include "tmu_encoding.h"
#include "logic_tmx.h"
#include "logic_tmu.h"

// tmxの定義
#define MATCH_TEMP_FIND       TMX_MATCH(F7_TMX_FIND)
#define MASK_TEMP_FIND        TMX_MASK
#define MATCH_TEMP_GET_SPM    TMX_MATCH(F7_TMX_GET_SPM)
#define MASK_TEMP_GET_SPM     TMX_MASK
#define MATCH_TEMP_ALLOC      TMX_MATCH(F7_TMX_ALLOC)
#define MASK_TEMP_ALLOC       TMX_MASK
#define MATCH_TEMP_INVALID    TMX_MATCH(F7_TMX_INVALID)
#define MASK_TEMP_INVALID     TMX_MASK
#define MATCH_TEMP_SET_DIRTY  TMX_MATCH(F7_TMX_SET_D)
#define MASK_TEMP_SET_DIRTY   TMX_MASK
#define MATCH_TEMP_IS_DIRTY   TMX_MATCH(F7_TMX_IS_D)
#define MASK_TEMP_IS_DIRTY    TMX_MASK
#define MATCH_TEMP_ACQUIRE    TMX_MATCH(F7_TMX_ACQ)
#define MASK_TEMP_ACQUIRE     TMX_MASK
#define MATCH_TEMP_RELEASE    TMX_MATCH(F7_TMX_REL)
#define MASK_TEMP_RELEASE     TMX_MASK
#define MATCH_TEMP_SET_LOAD   TMX_MATCH(F7_TMX_SET_L)
#define MASK_TEMP_SET_LOAD    TMX_MASK
#define MATCH_TEMP_IS_LOAD    TMX_MATCH(F7_TMX_IS_L)
#define MASK_TEMP_IS_LOAD     TMX_MASK
#define MATCH_TEMP_SWAPPABLE  TMX_MATCH(F7_TMX_SWAP)
#define MASK_TEMP_SWAPPABLE   TMX_MASK
#define MATCH_TEMP_PUSH     TMX_MATCH(F7_TMX_PUSH)
#define MASK_TEMP_PUSH      TMX_MASK
#define MATCH_TEMP_POP      TMX_MATCH(F7_TMX_POP)
#define MASK_TEMP_POP       TMX_MASK
// tmuの定義
#define MATCH_TMU_CHECK_TAG   TMU_MATCH(F7_TMU_CHECK_TAG)
#define MASK_TMU_CHECK_TAG    TMU_MASK
#define MATCH_TMU_ACQUIRE     TMU_MATCH(F7_TMU_ACQUIRE)
#define MASK_TMU_ACQUIRE      TMU_MASK
#define MATCH_TMU_RELEASE     TMU_MATCH(F7_TMU_RELEASE)
#define MASK_TMU_RELEASE      TMU_MASK
#define MATCH_TMU_SET_TAG     TMU_MATCH(F7_TMU_SET_TAG)
#define MASK_TMU_SET_TAG      TMU_MASK
#define MATCH_TMU_GET_TAG     TMU_MATCH(F7_TMU_GET_TAG)
#define MASK_TMU_GET_TAG      TMU_MASK
#define MATCH_TMU_SET_DIRTY   TMU_MATCH(F7_TMU_SET_D)
#define MASK_TMU_SET_DIRTY    TMU_MASK
#define MATCH_TMU_IS_DIRTY    TMU_MATCH(F7_TMU_IS_D)
#define MASK_TMU_IS_DIRTY     TMU_MASK
#define MATCH_TMU_CLEAR_DIRTY TMU_MATCH(F7_TMU_CLEAR_D)
#define MASK_TMU_CLEAR_DIRTY  TMU_MASK
#define MATCH_TMU_SET_SPM     TMU_MATCH(F7_TMU_SET_SPM)
#define MASK_TMU_SET_SPM      TMU_MASK
#define MATCH_TMU_GET_SPM     TMU_MATCH(F7_TMU_GET_SPM)
#define MASK_TMU_GET_SPM      TMU_MASK
#define MATCH_TMU_IS_SWAPPABLE TMU_MATCH(F7_TMU_IS_SWAPPABLE)
#define MASK_TMU_IS_SWAPPABLE  TMU_MASK
#define MATCH_TMU_RETURN_METADATA TMU_MATCH(F7_TMU_RETURN_METADATA)
#define MASK_TMU_RETURN_METADATA  TMU_MASK
#define MATCH_TMU_SET_VALID   TMU_MATCH(F7_TMU_SET_VALID)
#define MASK_TMU_SET_VALID    TMU_MASK
#define MATCH_TMU_IS_VALID    TMU_MATCH(F7_TMU_IS_VALID)
#define MASK_TMU_IS_VALID     TMU_MASK
#define MATCH_TMU_LIGHT_TAG_CHECK TMU_MATCH(F7_TMU_LIGHT_TAG_CHECK)
#define MASK_TMU_LIGHT_TAG_CHECK  TMU_MASK
#define MATCH_TMU_SET_BIT    TMU_MATCH(F7_TMU_SET_BIT)
#define MASK_TMU_SET_BIT     TMU_MASK
#define MATCH_TMU_CLEAR_BIT  TMU_MATCH(F7_TMU_CLEAR_BIT)
#define MASK_TMU_CLEAR_BIT   TMU_MASK
#define MATCH_TMU_IS_BIT_SET TMU_MATCH(F7_TMU_IS_BIT_SET)
#define MASK_TMU_IS_BIT_SET  TMU_MASK


class unified_extension_t : public extension_t {
public:
    unified_extension_t() {
        logic_tmx.internal_reset();
        logic_tmu.internal_reset();
    }
  const char* name() const override { return "unified_extension"; }

  void reset(processor_t &p) override {
    logic_tmx.internal_reset();
    logic_tmu.internal_reset();
  }

  // 命令の統合登録
  std::vector<insn_desc_t> get_instructions(const processor_t &proc) override {
    std::vector<insn_desc_t> v;
    // tmx命令群の登録
    v.push_back((insn_desc_t){
      MATCH_TEMP_FIND, MASK_TEMP_FIND,
      &unified_extension_t::exec_tmx_find, // fast_rv32i
      &unified_extension_t::exec_tmx_find, // fast_rv64i
      &unified_extension_t::exec_tmx_find, // fast_rv32e
      &unified_extension_t::exec_tmx_find, // fast_rv64e
      &unified_extension_t::exec_tmx_find, // logged_rv32i
      &unified_extension_t::exec_tmx_find, // logged_rv64i
      &unified_extension_t::exec_tmx_find, // logged_rv32e
      &unified_extension_t::exec_tmx_find  // logged_rv64e
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_GET_SPM, MASK_TEMP_GET_SPM,
      &unified_extension_t::exec_tmx_get_spm,
      &unified_extension_t::exec_tmx_get_spm,
      &unified_extension_t::exec_tmx_get_spm,
      &unified_extension_t::exec_tmx_get_spm,
      &unified_extension_t::exec_tmx_get_spm,
      &unified_extension_t::exec_tmx_get_spm,
      &unified_extension_t::exec_tmx_get_spm,
      &unified_extension_t::exec_tmx_get_spm
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_ALLOC, MASK_TEMP_ALLOC,
      &unified_extension_t::exec_tmx_alloc,
      &unified_extension_t::exec_tmx_alloc,
      &unified_extension_t::exec_tmx_alloc,
      &unified_extension_t::exec_tmx_alloc,
      &unified_extension_t::exec_tmx_alloc,
      &unified_extension_t::exec_tmx_alloc,
      &unified_extension_t::exec_tmx_alloc,
      &unified_extension_t::exec_tmx_alloc
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_INVALID, MASK_TEMP_INVALID,
      &unified_extension_t::exec_tmx_invalidate,
      &unified_extension_t::exec_tmx_invalidate,
      &unified_extension_t::exec_tmx_invalidate,
      &unified_extension_t::exec_tmx_invalidate,
      &unified_extension_t::exec_tmx_invalidate,
      &unified_extension_t::exec_tmx_invalidate,
      &unified_extension_t::exec_tmx_invalidate,
      &unified_extension_t::exec_tmx_invalidate
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_SET_DIRTY, MASK_TEMP_SET_DIRTY,
      &unified_extension_t::exec_tmx_set_dirty,
      &unified_extension_t::exec_tmx_set_dirty,
      &unified_extension_t::exec_tmx_set_dirty,
      &unified_extension_t::exec_tmx_set_dirty,
      &unified_extension_t::exec_tmx_set_dirty,
      &unified_extension_t::exec_tmx_set_dirty,
      &unified_extension_t::exec_tmx_set_dirty,
      &unified_extension_t::exec_tmx_set_dirty
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_IS_DIRTY, MASK_TEMP_IS_DIRTY,
      &unified_extension_t::exec_tmx_is_dirty,
      &unified_extension_t::exec_tmx_is_dirty,
      &unified_extension_t::exec_tmx_is_dirty,
      &unified_extension_t::exec_tmx_is_dirty,
      &unified_extension_t::exec_tmx_is_dirty,
      &unified_extension_t::exec_tmx_is_dirty,
      &unified_extension_t::exec_tmx_is_dirty,
      &unified_extension_t::exec_tmx_is_dirty
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_ACQUIRE, MASK_TEMP_ACQUIRE,
      &unified_extension_t::exec_tmx_acquire,
      &unified_extension_t::exec_tmx_acquire,
      &unified_extension_t::exec_tmx_acquire,
      &unified_extension_t::exec_tmx_acquire,
      &unified_extension_t::exec_tmx_acquire,
      &unified_extension_t::exec_tmx_acquire,
      &unified_extension_t::exec_tmx_acquire,
      &unified_extension_t::exec_tmx_acquire
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_RELEASE, MASK_TEMP_RELEASE,
      &unified_extension_t::exec_tmx_release,
      &unified_extension_t::exec_tmx_release,
      &unified_extension_t::exec_tmx_release,
      &unified_extension_t::exec_tmx_release,
      &unified_extension_t::exec_tmx_release,
      &unified_extension_t::exec_tmx_release,
      &unified_extension_t::exec_tmx_release,
      &unified_extension_t::exec_tmx_release
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_SET_LOAD, MASK_TEMP_SET_LOAD,
      &unified_extension_t::exec_tmx_set_loaded,
      &unified_extension_t::exec_tmx_set_loaded,
      &unified_extension_t::exec_tmx_set_loaded,
      &unified_extension_t::exec_tmx_set_loaded,
      &unified_extension_t::exec_tmx_set_loaded,
      &unified_extension_t::exec_tmx_set_loaded,
      &unified_extension_t::exec_tmx_set_loaded,
      &unified_extension_t::exec_tmx_set_loaded
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_IS_LOAD, MASK_TEMP_IS_LOAD,
      &unified_extension_t::exec_tmx_is_loaded,
      &unified_extension_t::exec_tmx_is_loaded,
      &unified_extension_t::exec_tmx_is_loaded,
      &unified_extension_t::exec_tmx_is_loaded,
      &unified_extension_t::exec_tmx_is_loaded,
      &unified_extension_t::exec_tmx_is_loaded,
      &unified_extension_t::exec_tmx_is_loaded,
      &unified_extension_t::exec_tmx_is_loaded
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_SWAPPABLE, MASK_TEMP_SWAPPABLE,
      &unified_extension_t::exec_tmx_swappable,
      &unified_extension_t::exec_tmx_swappable,
      &unified_extension_t::exec_tmx_swappable,
      &unified_extension_t::exec_tmx_swappable,
      &unified_extension_t::exec_tmx_swappable,
      &unified_extension_t::exec_tmx_swappable,
      &unified_extension_t::exec_tmx_swappable,
      &unified_extension_t::exec_tmx_swappable
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_POP, MASK_TEMP_POP,
      &unified_extension_t::exec_tmx_pop,
      &unified_extension_t::exec_tmx_pop,
      &unified_extension_t::exec_tmx_pop,
      &unified_extension_t::exec_tmx_pop,
      &unified_extension_t::exec_tmx_pop,
      &unified_extension_t::exec_tmx_pop,
      &unified_extension_t::exec_tmx_pop,
      &unified_extension_t::exec_tmx_pop
    });
    v.push_back((insn_desc_t){
      MATCH_TEMP_PUSH, MASK_TEMP_PUSH,
      &unified_extension_t::exec_tmx_push,
      &unified_extension_t::exec_tmx_push,
      &unified_extension_t::exec_tmx_push,
      &unified_extension_t::exec_tmx_push,
      &unified_extension_t::exec_tmx_push,
      &unified_extension_t::exec_tmx_push,
      &unified_extension_t::exec_tmx_push,
      &unified_extension_t::exec_tmx_push
    });
    
    // tmu命令群の登録
    v.push_back((insn_desc_t){
      MATCH_TMU_CHECK_TAG, MASK_TMU_CHECK_TAG,
      &unified_extension_t::exec_tmu_check_tag,
      &unified_extension_t::exec_tmu_check_tag,
      &unified_extension_t::exec_tmu_check_tag,
      &unified_extension_t::exec_tmu_check_tag,
      &unified_extension_t::exec_tmu_check_tag,
      &unified_extension_t::exec_tmu_check_tag,
      &unified_extension_t::exec_tmu_check_tag,
      &unified_extension_t::exec_tmu_check_tag
    });
    v.push_back((insn_desc_t){
      MATCH_TMU_ACQUIRE, MASK_TMU_ACQUIRE,
      &unified_extension_t::exec_tmu_acquire,
      &unified_extension_t::exec_tmu_acquire,
      &unified_extension_t::exec_tmu_acquire,
      &unified_extension_t::exec_tmu_acquire,
      &unified_extension_t::exec_tmu_acquire,
      &unified_extension_t::exec_tmu_acquire,
      &unified_extension_t::exec_tmu_acquire,
      &unified_extension_t::exec_tmu_acquire
    });
    v.push_back((insn_desc_t){
      MATCH_TMU_RELEASE, MASK_TMU_RELEASE,
      &unified_extension_t::exec_tmu_release,
      &unified_extension_t::exec_tmu_release,
      &unified_extension_t::exec_tmu_release,
      &unified_extension_t::exec_tmu_release,
      &unified_extension_t::exec_tmu_release,
      &unified_extension_t::exec_tmu_release,
      &unified_extension_t::exec_tmu_release,
      &unified_extension_t::exec_tmu_release
    });
    v.push_back((insn_desc_t){
        MATCH_TMU_SET_TAG, MASK_TMU_SET_TAG,
        &unified_extension_t::exec_tmu_set_tag,
        &unified_extension_t::exec_tmu_set_tag,
        &unified_extension_t::exec_tmu_set_tag,
        &unified_extension_t::exec_tmu_set_tag,
        &unified_extension_t::exec_tmu_set_tag,
        &unified_extension_t::exec_tmu_set_tag,
        &unified_extension_t::exec_tmu_set_tag,
        &unified_extension_t::exec_tmu_set_tag
      });
    v.push_back((insn_desc_t){
        MATCH_TMU_GET_TAG, MASK_TMU_GET_TAG,
        &unified_extension_t::exec_tmu_get_tag,
        &unified_extension_t::exec_tmu_get_tag,
        &unified_extension_t::exec_tmu_get_tag,
        &unified_extension_t::exec_tmu_get_tag,
        &unified_extension_t::exec_tmu_get_tag,
        &unified_extension_t::exec_tmu_get_tag,
        &unified_extension_t::exec_tmu_get_tag,
        &unified_extension_t::exec_tmu_get_tag
      });
    v.push_back((insn_desc_t){
        MATCH_TMU_SET_DIRTY, MASK_TMU_SET_DIRTY,
        &unified_extension_t::exec_tmu_set_dirty,
        &unified_extension_t::exec_tmu_set_dirty,
        &unified_extension_t::exec_tmu_set_dirty,
        &unified_extension_t::exec_tmu_set_dirty,
        &unified_extension_t::exec_tmu_set_dirty,
        &unified_extension_t::exec_tmu_set_dirty,
        &unified_extension_t::exec_tmu_set_dirty,
        &unified_extension_t::exec_tmu_set_dirty
      });
    v.push_back((insn_desc_t){
        MATCH_TMU_IS_DIRTY, MASK_TMU_IS_DIRTY,
        &unified_extension_t::exec_tmu_is_dirty,
        &unified_extension_t::exec_tmu_is_dirty,
        &unified_extension_t::exec_tmu_is_dirty,
        &unified_extension_t::exec_tmu_is_dirty,
        &unified_extension_t::exec_tmu_is_dirty,
        &unified_extension_t::exec_tmu_is_dirty,
        &unified_extension_t::exec_tmu_is_dirty,
        &unified_extension_t::exec_tmu_is_dirty
      });
    v.push_back((insn_desc_t){
        MATCH_TMU_CLEAR_DIRTY, MASK_TMU_CLEAR_DIRTY,
        &unified_extension_t::exec_tmu_clear_dirty,
        &unified_extension_t::exec_tmu_clear_dirty,
        &unified_extension_t::exec_tmu_clear_dirty,
        &unified_extension_t::exec_tmu_clear_dirty,
        &unified_extension_t::exec_tmu_clear_dirty,
        &unified_extension_t::exec_tmu_clear_dirty,
        &unified_extension_t::exec_tmu_clear_dirty,
        &unified_extension_t::exec_tmu_clear_dirty
      });
    v.push_back((insn_desc_t){
        MATCH_TMU_SET_SPM, MASK_TMU_SET_SPM,
        &unified_extension_t::exec_tmu_set_spm,
        &unified_extension_t::exec_tmu_set_spm,
        &unified_extension_t::exec_tmu_set_spm,
        &unified_extension_t::exec_tmu_set_spm,
        &unified_extension_t::exec_tmu_set_spm,
        &unified_extension_t::exec_tmu_set_spm,
        &unified_extension_t::exec_tmu_set_spm,
        &unified_extension_t::exec_tmu_set_spm
      });
    v.push_back((insn_desc_t){
        MATCH_TMU_GET_SPM, MASK_TMU_GET_SPM,
        &unified_extension_t::exec_tmu_get_spm,
        &unified_extension_t::exec_tmu_get_spm,
        &unified_extension_t::exec_tmu_get_spm,
        &unified_extension_t::exec_tmu_get_spm,
        &unified_extension_t::exec_tmu_get_spm,
        &unified_extension_t::exec_tmu_get_spm,
        &unified_extension_t::exec_tmu_get_spm,
        &unified_extension_t::exec_tmu_get_spm
      });
    v.push_back((insn_desc_t){
        MATCH_TMU_IS_SWAPPABLE, MASK_TMU_IS_SWAPPABLE,
        &unified_extension_t::exec_tmu_is_swappable,
        &unified_extension_t::exec_tmu_is_swappable,
        &unified_extension_t::exec_tmu_is_swappable,
        &unified_extension_t::exec_tmu_is_swappable,
        &unified_extension_t::exec_tmu_is_swappable,
        &unified_extension_t::exec_tmu_is_swappable,
        &unified_extension_t::exec_tmu_is_swappable,
        &unified_extension_t::exec_tmu_is_swappable
    });
    v.push_back((insn_desc_t){
        MATCH_TMU_RETURN_METADATA, MASK_TMU_RETURN_METADATA,
        &unified_extension_t::exec_tmu_return_metadata,
        &unified_extension_t::exec_tmu_return_metadata,
        &unified_extension_t::exec_tmu_return_metadata,
        &unified_extension_t::exec_tmu_return_metadata,
        &unified_extension_t::exec_tmu_return_metadata,
        &unified_extension_t::exec_tmu_return_metadata,
        &unified_extension_t::exec_tmu_return_metadata,
        &unified_extension_t::exec_tmu_return_metadata
      });
    v.push_back((insn_desc_t){
      MATCH_TMU_SET_VALID, MASK_TMU_SET_VALID,
      &unified_extension_t::exec_tmu_set_valid,
      &unified_extension_t::exec_tmu_set_valid,
      &unified_extension_t::exec_tmu_set_valid,
      &unified_extension_t::exec_tmu_set_valid,
      &unified_extension_t::exec_tmu_set_valid,
      &unified_extension_t::exec_tmu_set_valid,
      &unified_extension_t::exec_tmu_set_valid,
      &unified_extension_t::exec_tmu_set_valid
    });
    v.push_back((insn_desc_t){
      MATCH_TMU_IS_VALID, MASK_TMU_IS_VALID,
      &unified_extension_t::exec_tmu_is_valid,
      &unified_extension_t::exec_tmu_is_valid,
      &unified_extension_t::exec_tmu_is_valid,
      &unified_extension_t::exec_tmu_is_valid,
      &unified_extension_t::exec_tmu_is_valid,
      &unified_extension_t::exec_tmu_is_valid,
      &unified_extension_t::exec_tmu_is_valid,
      &unified_extension_t::exec_tmu_is_valid
    });
    v.push_back((insn_desc_t){
      MATCH_TMU_LIGHT_TAG_CHECK, MASK_TMU_LIGHT_TAG_CHECK,
      &unified_extension_t::exec_tmu_light_tag_check,
      &unified_extension_t::exec_tmu_light_tag_check,
      &unified_extension_t::exec_tmu_light_tag_check,
      &unified_extension_t::exec_tmu_light_tag_check,
      &unified_extension_t::exec_tmu_light_tag_check,
      &unified_extension_t::exec_tmu_light_tag_check,
      &unified_extension_t::exec_tmu_light_tag_check,
      &unified_extension_t::exec_tmu_light_tag_check
    });
    v.push_back((insn_desc_t){
      MATCH_TMU_SET_BIT, MASK_TMU_SET_BIT,
      &unified_extension_t::exec_tmu_set_bit,
      &unified_extension_t::exec_tmu_set_bit,
      &unified_extension_t::exec_tmu_set_bit,
      &unified_extension_t::exec_tmu_set_bit,
      &unified_extension_t::exec_tmu_set_bit,
      &unified_extension_t::exec_tmu_set_bit,
      &unified_extension_t::exec_tmu_set_bit,
      &unified_extension_t::exec_tmu_set_bit
    });
    v.push_back((insn_desc_t){
      MATCH_TMU_CLEAR_BIT, MASK_TMU_CLEAR_BIT,
      &unified_extension_t::exec_tmu_clear_bit,
      &unified_extension_t::exec_tmu_clear_bit,
      &unified_extension_t::exec_tmu_clear_bit,
      &unified_extension_t::exec_tmu_clear_bit,
      &unified_extension_t::exec_tmu_clear_bit,
      &unified_extension_t::exec_tmu_clear_bit,
      &unified_extension_t::exec_tmu_clear_bit,
      &unified_extension_t::exec_tmu_clear_bit
    });
    v.push_back((insn_desc_t){
      MATCH_TMU_IS_BIT_SET, MASK_TMU_IS_BIT_SET,
      &unified_extension_t::exec_tmu_is_bit_set,
      &unified_extension_t::exec_tmu_is_bit_set,
      &unified_extension_t::exec_tmu_is_bit_set,
      &unified_extension_t::exec_tmu_is_bit_set,
      &unified_extension_t::exec_tmu_is_bit_set,
      &unified_extension_t::exec_tmu_is_bit_set,
      &unified_extension_t::exec_tmu_is_bit_set,
      &unified_extension_t::exec_tmu_is_bit_set
    });
    return v;
  }

  // Disasmの統合登録
  std::vector<disasm_insn_t*> get_disasms(const processor_t *proc) override {
    std::vector<disasm_insn_t*> disasms;    
    return disasms;
  }
    tmx_logic_t     logic_tmx;
    tmu_logic_t   logic_tmu;
private:


  static reg_t exec_tmx_find(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    reg_t rs1 = p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmx.do_find(rs1);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_tmx_get_spm(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmx.do_get_spm(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_tmx_alloc(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    reg_t addr = (reg_t)p->get_state()->XPR[insn.rs1()];
    reg_t spm  = (reg_t)p->get_state()->XPR[insn.rs2()];
    reg_t res  = ext->logic_tmx.do_alloc(addr, spm);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_tmx_invalidate(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmx.do_invalidate(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_tmx_set_dirty(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmx.do_set_dirty(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_tmx_is_dirty(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmx.do_is_dirty(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_tmx_acquire(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmx.do_acquire(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_tmx_release(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmx.do_release(idx);
      int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_tmx_set_loaded(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmx.do_set_loaded(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_tmx_is_loaded(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmx.do_is_loaded(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_tmx_swappable(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int idx   = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmx.do_swappable(idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmx_push(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    uint64_t spm_offset = (uint64_t)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmx.do_push(spm_offset);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

  static reg_t exec_tmx_pop(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    reg_t res = ext->logic_tmx.do_pop();
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }

// tmu命令群の実装
  static reg_t exec_tmu_check_tag(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    long slot_idx = (long)p->get_state()->XPR[insn.rs1()];
    uint64_t addr = (uint64_t)p->get_state()->XPR[insn.rs2()];
    reg_t res = ext->logic_tmu.do_check_tag(slot_idx,addr);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_acquire(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmu.do_acquire(slot_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_release(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmu.do_release(slot_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_set_tag(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    uint64_t tag = (uint64_t)p->get_state()->XPR[insn.rs2()];
    reg_t res = ext->logic_tmu.do_set_tag(slot_idx, tag);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_get_tag(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmu.do_get_tag(slot_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_set_dirty(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmu.do_set_dirty(slot_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_is_dirty(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmu.do_is_dirty(slot_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_clear_dirty(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmu.do_clear_dirty(slot_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_set_spm(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t spm = p->get_state()->XPR[insn.rs2()];
    reg_t res = ext->logic_tmu.do_set_spm(slot_idx, spm);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
    static reg_t exec_tmu_get_spm(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmu.do_get_spm(slot_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_is_swappable(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmu.do_is_swappable(slot_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_return_metadata(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmu.do_return_metadata(slot_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_set_valid(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmu.do_set_valid(slot_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_is_valid(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    reg_t res = ext->logic_tmu.do_is_valid(slot_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_light_tag_check(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    long slot_idx = (long)p->get_state()->XPR[insn.rs1()];
    uint64_t addr = (uint64_t)p->get_state()->XPR[insn.rs2()];
    reg_t res = ext->logic_tmu.do_light_tag_check(slot_idx,addr);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_set_bit(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    int bit_idx = (int)p->get_state()->XPR[insn.rs2()];
    reg_t res = ext->logic_tmu.do_set_bit(slot_idx, bit_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_clear_bit(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    int bit_idx = (int)p->get_state()->XPR[insn.rs2()];
    reg_t res = ext->logic_tmu.do_clear_bit(slot_idx, bit_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
  static reg_t exec_tmu_is_bit_set(processor_t* p, insn_t insn, reg_t pc) {
    auto* ext = static_cast<unified_extension_t*>(p->get_extension("unified_extension"));
    int slot_idx = (int)p->get_state()->XPR[insn.rs1()];
    int bit_idx = (int)p->get_state()->XPR[insn.rs2()];
    reg_t res = ext->logic_tmu.do_is_bit_set(slot_idx, bit_idx);
    int rd = insn.rd();
    if (rd != 0) { // x0への書き込みは無視
        p->get_state()->XPR.write(rd, res);
    }
    return pc + 4;
  }
};

// ここで1回だけ登録する
REGISTER_EXTENSION(unified_extension, []() { return new unified_extension_t; })