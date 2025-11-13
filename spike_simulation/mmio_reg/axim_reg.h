#include <stdint.h>
#include <stddef.h>
#include "reg_map.h"
#include "spm_reg.h"
// ヘルパー関数群
void axim_copy(const uint64_t spm_offset){
    while(AXIM_BUSY_REG); // busy待ち
    AXIM_SPM_ADDR_REG = spm_offset;
    AXIM_COMMAND_REG = 1; // WRITE_BACK
    spm_wait_idle();
    SPM_DRAM_ADDRESS  = 0;
    SPM_LOCAL_ADDRESS = spm_offset;
    SPM_SIZE_REG      = 64;
    SPM_DIRECTION     = 0;
    SPM_DESTINATION   = 4;           /* spm->axim */
    SPM_START         = 1;
    spm_wait_idle();
}
void axim_write(const uint64_t spm_offset){
    spm_wait_idle();
    SPM_DRAM_ADDRESS  = 0;
    SPM_LOCAL_ADDRESS = spm_offset;
    SPM_SIZE_REG      = 64;
    SPM_DIRECTION     = 1;
    SPM_DESTINATION   = 4;           /* axim->spm */
    SPM_START         = 1;
    spm_wait_idle();
}
void axim_encrypt(){
    while(AXIM_BUSY_REG); // busy待ち
    AXIM_COMMAND_REG = 4; // ENCRYPT
}
void axim_decrypt(){
    while(AXIM_BUSY_REG); // busy待ち
    AXIM_COMMAND_REG = 8; // DECRYPT
}
void axim_read_return(){
    spm_wait_idle();
    while(AXIM_BUSY_REG); // busy待ち
    AXIM_COMMAND_REG = 16; // READ_RETURN
}
void axim_write_return(){
    while(AXIM_BUSY_REG); // busy待ち
    AXIM_COMMAND_REG = 32; // WRITE_RETURN
}
