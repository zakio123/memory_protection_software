#include <stdint.h>
#include <stddef.h>
#include "reg_map.h"

// ヘルパー関数群
void axim_write_back(const uint64_t spm_offset){
    while(AXIM_BUSY_REG); // busy待ち
    AXIM_SPM_ADDR_REG = spm_offset;
    AXIM_COMMAND_REG = 1; // WRITE_BACK
}
void axim_copy(const uint64_t spm_offset){
    while(AXIM_BUSY_REG); // busy待ち
    AXIM_SPM_ADDR_REG = spm_offset;
    AXIM_COMMAND_REG = 2; // READ_DATA
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
    while(AXIM_BUSY_REG); // busy待ち
    AXIM_COMMAND_REG = 16; // READ_RETURN
}
void axim_write_return(){
    while(AXIM_BUSY_REG); // busy待ち
    AXIM_COMMAND_REG = 32; // WRITE_RETURN
}
