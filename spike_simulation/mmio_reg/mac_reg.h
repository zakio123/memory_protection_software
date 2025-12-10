#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>
#include "reg_map.h"
#include "spm_reg.h"
#include "config.h"

// static inline uint64_t mac_ld64(spm_offset_t off) {
//     if (off >= MAC_RESULT_SIZE) return 0;
//     return *(volatile uint64_t *)((uintptr_t)(MAC_BASE + MAC_REG_MAC_RESULT + (uint64_t)off));
// }

void mac_init(uint32_t req_id){
    uint64_t cmd = ((uint64_t)req_id << 32) | 1;
    MAC_COMMAND = cmd; // INIT
}
void mac_update(uint64_t start_bit, uint64_t end_bit){
    uint64_t cmd = ((end_bit & 0XFFFF) << 48) | ((start_bit & 0xFFFF) << 32) | 2;
    MAC_COMMAND = cmd; // UPDATE
}
void mac_digest(uint32_t offset){
    MAC_COMMAND = ((uint64_t)offset << 32) | 4; // OUTPUT
}

void mac_buffer_set(spm_offset_t spm_offset){
    uint64_t cmd = ((uint64_t)spm_offset << 32) | 8; // SPM_RD
    MAC_COMMAND = cmd;
}
void mac_result_compare(spm_offset_t spm_offset){
    uint64_t cmd = ((uint64_t)spm_offset << 32) | 16; // COMPARE
    MAC_COMMAND = cmd;
}
bool mac_wait(uint32_t req_id){
    uint32_t complete_id = MAC_ID;
    return (req_id <= complete_id);
}
#ifdef __cplusplus
}
#endif