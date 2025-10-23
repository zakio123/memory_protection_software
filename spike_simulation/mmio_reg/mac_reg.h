#include <stdint.h>
#include <stddef.h>
#include "reg_map.h"
#include "spm_reg.h"


void mac_buffer_set(uint64_t spm_offset){
    // MAC_SPM_ADDR = spm_offset;
    // MAC_SPM_START = 1;
    while (MAC_STATUS); // busy待ち
    spm_wait_idle();
    SPM_DRAM_ADDRESS  = 0;
    SPM_LOCAL_ADDRESS = spm_offset;
    SPM_SIZE_REG      = 64;
    SPM_DIRECTION     = 1;
    SPM_DESTINATION   = 2;
    SPM_START         = 1;
    spm_wait_idle();
}
void mac_init(void){
    MAC_COMMAND = 1; // INIT
    while (MAC_STATUS & 1); // busy待ち
}
void mac_update(uint64_t start_bit, uint64_t end_bit){
    MAC_START_BIT = start_bit;
    MAC_END_BIT = end_bit;
    MAC_COMMAND = 2; // UPDATE
    while (MAC_STATUS & 1); // busy待ち
}
uint64_t mac_final(void){
    MAC_COMMAND = 4; // NOP
    while (MAC_STATUS & 1); // busy待ち
    return MAC_RESULT;
}