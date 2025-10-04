#include <stdint.h>
#include <stddef.h>



void mac_buffer_set(uint64_t spm_offset){
    MAC_SPM_ADDR = spm_offset;
    MAC_SPM_START = 1;
    while (MAC_SPM_START); // busy待ち
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