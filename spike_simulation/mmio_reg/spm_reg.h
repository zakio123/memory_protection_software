#pragma once
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include "reg_map.h"


/* --- SPM 操作用インライン関数 --- */
static inline void spm_wait_idle(void) {
  while (SPM_START) { /* busy==1 の間スピン */ }
}

/* DRAM -> SPM */
static inline void spm_copy_to_local(uint64_t dram_pa, uint64_t local_off, uint64_t size) {
  spm_wait_idle();
  SPM_DRAM_ADDRESS  = dram_pa;
  SPM_LOCAL_ADDRESS = local_off;   /* SPM_MEM_BASE からの相対(バイト) */
  SPM_SIZE_REG      = size;
  SPM_DIRECTION     = 0;
  SPM_DESTINATION   = 1;           /* DRAM */
  SPM_START         = 1;           /* GO */
  // spm_wait_idle();
}

/* SPM -> DRAM */
static inline void spm_write_back(uint64_t local_off, uint64_t dram_pa, uint64_t size) {
  spm_wait_idle();
  SPM_DRAM_ADDRESS  = dram_pa;
  SPM_LOCAL_ADDRESS = local_off;
  SPM_SIZE_REG      = size;
  SPM_DIRECTION     = 1;
  SPM_DESTINATION   = 1;           /* DRAM */
  SPM_START         = 1;
  // spm_wait_idle();
}

/* データ窓の直接アクセス（必要なら 1/2/4 も追加） */
static inline uint64_t spm_ld64(uint64_t off) {
  return *(volatile uint64_t *)((uintptr_t)(SPM_MEM_BASE + off));
}
static inline void spm_sd64(uint64_t off, uint64_t v) {
  *(volatile uint64_t *)((uintptr_t)(SPM_MEM_BASE + off)) = v;
}

static inline void setBlockdirty(uint64_t spm_manage, uint64_t block_addr){
  uint64_t new_info = ((block_addr >> 6) << 6) | 0x3; // dirty | valid
  spm_sd64(spm_manage, new_info);
}
static inline void clearBlockdirty(uint64_t spm_manage, uint64_t block_addr){
  uint64_t new_info = ((block_addr >> 6) << 6) | 0x1; // valid
  spm_sd64(spm_manage, new_info);
}