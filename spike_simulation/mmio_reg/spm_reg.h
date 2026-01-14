#ifdef __cplusplus
extern "C" {
#endif

#pragma once
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include "reg_map.h"
#include "config.h"
#include "lock.h"

/* --- SPM 操作用インライン関数 --- */
static inline void spm_wait_idle(void) {
  while (SPM_START) { /* busy==1 の間スピン */ }
}
static inline void spm_wait(uint64_t id){
  int counter = 0;
  while(1){
    counter++;
    if (SPM_COMPLETE_ID >= id) break;
    if (counter % 100000 == 0){
      lock_print();
      int hartid = -1;
      asm volatile(
          "csrr %0, mhartid"
          : "=r"(hartid)
      );
      printf("Core %d SPM wait id=%llu current=%llu\n", hartid, id, SPM_COMPLETE_ID);
      unlock_print();
      // exit(1);
    }
  }
}

/* DRAM -> SPM */
// #define SPM_REG_DRAM_ADDR    (SPM_CTRL_BASE + 0x00ULL)
// #define SPM_REG_LOCAL_ADDR   (SPM_CTRL_BASE + 0x08ULL) /* SPMデータ窓先頭からのバイトオフセット */
// #define SPM_REG_SIZE         (SPM_CTRL_BASE + 0x10ULL)
// #define SPM_REG_DIRECTION    (SPM_CTRL_BASE + 0x18ULL) /* 0/1 */
// #define SPM_REG_START        (SPM_CTRL_BASE + 0x20ULL) /* write 1=start / read: busy */
// #define SPM_REG_STATUS       (SPM_CTRL_BASE + 0x28ULL)
// #define SPM_REG_DESTINATION  (SPM_CTRL_BASE + 0x30ULL) /* 1:DRAM 2:MAC, 4:AXIManager (OR可) */
// #define SPM_REG_ID           (SPM_CTRL_BASE + 0x38ULL)
// #define SPM_REG_COMPLETE_ID  (SPM_CTRL_BASE + 0x40ULL)
typedef struct {
    volatile uint64_t dram_addr;
    volatile uint64_t spm_local_addr;
    volatile uint64_t size;
    volatile uint64_t direction;
    volatile uint64_t start;
    volatile uint64_t status;
    volatile uint64_t destination;
    volatile uint64_t id;
} spm_ctrl_t;

// // 使い方は
// spm_ctrl_t *ctrl = (spm_ctrl_t *)0x60020000;
// ctrl->dram_addr = ...;  // -> sd ..., 0(sX)
// ctrl->spm_local_addr = ...; // -> sd ..., 8(sX)
static inline void spm_copy_to_local(dram_addr_t dram_pa, spm_offset_t local_off, dma_id_t id) {
  // if (id > 32000){
  // lock_print();
  // int hartid = -1;
  // asm volatile(
  //     "csrr %0, mhartid"
  //     : "=r"(hartid)
  // );
  // printf("Co %d SPM c to l s da=%016llx l_o=%016llx id=%llu\n", hartid, dram_pa, local_off, id);
  // unlock_print();
  // }
  SPM_DRAM_ADDRESS  = dram_pa;
  SPM_LOCAL_ADDRESS = local_off;   /* SPM_MEM_BASE からの相対(バイト) */
  // SPM_SIZE_REG      = size;
  SPM_DIRECTION     = 0;
  // SPM_DESTINATION   = 1;           /* DRAM */
  SPM_ID          = id;
  SPM_START         = 1;           /* GO */
  // spm_wait_idle();
  // spm_ctrl_t *ctrl = (spm_ctrl_t *)SPM_CTRL_BASE;
  // ctrl->dram_addr = dram_pa;
  // ctrl->spm_local_addr = (uint64_t)local_off;   /* SPM_MEM_BASE からの相対(バイト) */
  // // ctrl->size = size;
  // ctrl->direction = 0;
  // // ctrl->destination = 1;           /* DRAM */
  // ctrl->id = id;
  // ctrl->start = 1;           /* GO */
}

/* SPM -> DRAM */
static inline void spm_write_back(spm_offset_t local_off, dram_addr_t dram_pa, dma_id_t id) {
  SPM_DRAM_ADDRESS  = dram_pa;
  SPM_LOCAL_ADDRESS = local_off;
  // SPM_SIZE_REG      = size;
  SPM_DIRECTION     = 1;
  // SPM_DESTINATION   = 1;           /* DRAM */
  SPM_ID          = id;
  SPM_START         = 1;
}

/* データ窓の直接アクセス（必要なら 1/2/4 も追加） */
static inline uint64_t spm_ld64(spm_offset_t off) {
  return *(volatile uint64_t *)((uintptr_t)(SPM_MEM_BASE + (uint64_t)off));
}
static inline void spm_sd64(spm_offset_t off, uint64_t v) {
  *(volatile uint64_t *)((uintptr_t)(SPM_MEM_BASE + (uint64_t)off)) = v;
}

#ifdef __cplusplus
}
#endif
