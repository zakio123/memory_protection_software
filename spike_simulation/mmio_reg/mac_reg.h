#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>
#include "reg_map.h"
#include "spm_reg.h"
#include "config.h"

static inline uint64_t mac_ld64(spm_offset_t off) {
    if (off >= MAC_RESULT_SIZE) return 0;
    return *(volatile uint64_t *)((uintptr_t)(MAC_BASE + MAC_REG_MAC_RESULT + (uint64_t)off));
}

void mac_init(void){
    while (MAC_STATUS & 1);
    MAC_COMMAND = 1; // INIT
}
void mac_update(uint64_t start_bit, uint64_t end_bit){
    while (MAC_STATUS & 1); // busy待ち
    uint64_t cmd = ((end_bit & 0XFFFF) << 48) | ((start_bit & 0xFFFF) << 32) | 2;
    MAC_COMMAND = cmd; // UPDATE
}
uint64_t mac_digest(uint32_t offset){
    while (MAC_STATUS & 1); // busy待ち
    MAC_COMMAND = ((uint64_t)offset << 32) | 4;
    while (MAC_STATUS & 1); // busy待ち
    uint64_t mac = mac_ld64(offset);
    return mac;
}

void mac_buffer_set(spm_offset_t spm_offset){
    while(MAC_STATUS & 1); // busy待ち
    uint64_t cmd = ((uint64_t)spm_offset << 32) | 8; // SPM_RD
    MAC_COMMAND = cmd;
}
#ifdef __cplusplus
}
#endif