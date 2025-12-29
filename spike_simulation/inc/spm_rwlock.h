#include "config.h"
#include "mem_layout.h"
#include "temp_controll.h"
#include "tmu_encoding.h"
#include <stdio.h>
#include "../mmio_reg/spm_reg.h"
/* --- インラインアセンブラマクロ (HWモード用) --- */
#ifdef ENABLE_TMU_HARDWARE
#define TMU_INSN_R(funct7, rd, rs1, rs2) \
    asm volatile ( \
        ".insn r %1, %2, %3, %0, %4, %5" \
        : "=r"(rd) \
        : "i"(TMU_OPCODE), "i"(TMU_F3), "i"(funct7), "r"(rs1), "r"(rs2) \
    )
#endif

static inline bool acquire_read_block(spm_offset_t spm_offset){
  #ifdef ENABLE_TMU_HARDWARE
    long ret;
    TMU_INSN_R(F7_TMU_ACQUIRE, ret, spm_offset, 0); 
    return (bool)ret;
  #else
  if (valid_metadata[set_index][way_index] == false){
    printf("Error: Attempt to acquire invalid cache block S:%u W:%u\n", set_index, way_index);
      return false;
  } else {
    ref_count_metadata[set_index][way_index] += 1;
      return true;
    }
  #endif
}
static inline void release_read_block(spm_offset_t spm_offset){
  #ifdef ENABLE_TMU_HARDWARE
    long ret;
    TMU_INSN_R(F7_TMU_RELEASE, ret, spm_offset, 0); 
  #else
    if (valid_metadata[set_index][way_index] == false){
        printf("Error: Attempt to release invalid cache block S:%u W:%u\n", set_index, way_index);
        exit(1);
        return;
    }
    if (ref_count_metadata[set_index][way_index] == 0){
        printf("Error: Attempt to release cache block S:%u W:%u with ref_count 0\n", set_index, way_index);
        exit(1);
        return;
    }
    ref_count_metadata[set_index][way_index] -= 1;
  #endif
}

static inline bool acquire_write_block(spm_offset_t spm_offset){
  #ifdef ENABLE_TMU_HARDWARE
    long ret;
    TMU_INSN_R(F7_TMU_ACQUIRE, ret, spm_offset, 1); 
    return (bool)ret;
  #else
  if (valid_metadata[set_index][way_index] == false){
    printf("Error: Attempt to acquire invalid cache block S:%u W:%u\n", set_index, way_index);
      return false;
  } else {
    ref_count_metadata[set_index][way_index] += 1;
      return true;
    }
  #endif
}
static inline void release_write_block(spm_offset_t spm_offset){
  #ifdef ENABLE_TMU_HARDWARE
    long ret;
    TMU_INSN_R(F7_TMU_RELEASE, ret, spm_offset, 1); 
  #else
    if (valid_metadata[set_index][way_index] == false){
        printf("Error: Attempt to release invalid cache block S:%u W:%u\n", set_index, way_index);
        exit(1);
        return;
    }
    if (ref_count_metadata[set_index][way_index] == 0){
        printf("Error: Attempt to release cache block S:%u W:%u with ref_count 0\n", set_index, way_index);
        exit(1);
        return;
    }
    ref_count_metadata[set_index][way_index] -= 1;
  #endif
}

static inline bool swappable_block(spm_offset_t spm_offset){
  #ifdef ENABLE_TMU_HARDWARE
    long ret;
    TMU_INSN_R(F7_TMU_IS_SWAPPABLE, ret, spm_offset, 0); 
    return (bool)ret;
  #else
  return (ref_count_metadata[set_index][way_index] == 0);
  #endif
}