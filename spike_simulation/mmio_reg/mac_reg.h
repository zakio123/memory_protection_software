#include <stdint.h>
#include <stddef.h>
#include "reg_map.h"
#include "spm_reg.h"
void mac_buffer_set(uint64_t spm_offset){
    while (MAC_SPM_START); // busy待ち
    SPM_DRAM_ADDRESS  = 0;
    SPM_LOCAL_ADDRESS = spm_offset;
    SPM_DIRECTION     = 1;
    SPM_DESTINATION   = 2;
    SPM_START         = 1;
}
void mac_init(void){
    while (MAC_STATUS & 1);
    MAC_COMMAND = 1; // INIT
}
void mac_update(uint64_t start_bit, uint64_t end_bit){
    while (MAC_STATUS & 1); // busy待ち
    MAC_START_BIT = start_bit;
    MAC_END_BIT = end_bit;
    MAC_COMMAND = 2; // UPDATE
}
uint64_t mac_final(void){
    while (MAC_STATUS & 1); // busy待ち
    MAC_COMMAND = 4; // NOP
    while (MAC_STATUS & 1); // busy待ち
    return MAC_RESULT;
}