#ifdef __cplusplus
extern "C" {
#endif

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
void xor_start(bool input_from_reqio, bool output_to_reqio) {
    xor_is_busy();
    uint64_t reg = 1;
    if (input_from_reqio){
        reg += 2;
    }
    if (output_to_reqio){
        reg += 4;
    }
    XOR_START_REG = reg;
    xor_is_busy();
    return;
}
void write_xor(const spm_offset_t spm_offset){
    spm_wait_idle();
    SPM_DRAM_ADDRESS  = 0;
    SPM_LOCAL_ADDRESS = (uint64_t)spm_offset;
    SPM_DIRECTION     = 1;
    SPM_DESTINATION   = 8;           /* SPM->XOR */
    SPM_START         = 1;
    spm_wait_idle();
}
void copy_xor(const spm_offset_t spm_offset){
    spm_wait_idle();
    SPM_DRAM_ADDRESS  = 0;
    SPM_LOCAL_ADDRESS = (uint64_t)spm_offset;
    SPM_DIRECTION     = 0;
    SPM_DESTINATION   = 8;           /* XOR->SPM */
    SPM_START         = 1;
    spm_wait_idle();
}
#ifdef __cplusplus
}
#endif