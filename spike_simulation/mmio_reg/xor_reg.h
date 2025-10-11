#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include "reg_map.h"
#include "spm_reg.h"
/* --- XOR 操作用インライン関数 --- */
static inline void xor_is_busy() {
    while(XOR_START_REG); // busy==1 の間スピン
    return;
}
static inline void xor_start() {
    xor_is_busy();
    XOR_START_REG = 1;
    xor_is_busy();
    return;
}

static inline void write_xor(uint64_t spm_offset){
    spm_wait_idle();
    SPM_DRAM_ADDRESS  = 0;
    SPM_LOCAL_ADDRESS = spm_offset;
    SPM_SIZE_REG      = 64;
    SPM_DIRECTION     = 1;
    SPM_DESTINATION   = 8;           /* SPM->XOR */
    SPM_START         = 1;
    spm_wait_idle();
}
static inline void copy_xor(const uint64_t spm_offset){
    spm_wait_idle();
    SPM_DRAM_ADDRESS  = 0;
    SPM_LOCAL_ADDRESS = spm_offset;
    SPM_SIZE_REG      = 64;
    SPM_DIRECTION     = 0;
    SPM_DESTINATION   = 8;           /* XOR->SPM */
    SPM_START         = 1;
    spm_wait_idle();
}