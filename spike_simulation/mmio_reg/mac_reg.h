#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>
#include "reg_map.h"
#include "spm_reg.h"
#include "config.h"

void mac_init(uint64_t req_id){
    uint64_t cmd = ((uint64_t)req_id << 32) | 1;
    MAC_COMMAND = cmd; // INIT
}
void mac_update(uint64_t start_bit, uint64_t end_bit){
    uint64_t cmd = ((end_bit & 0XFFFF) << 48) | ((start_bit & 0xFFFF) << 32) | 2;
    MAC_COMMAND = cmd; // UPDATE
}
void mac_digest(spm_offset_t offset,dma_id_t dma_id){
    uint64_t id = (dma_id & 0xFFFF);
    MAC_COMMAND = (offset << 32) | (id << 16) | 4; // OUTPUT
}

void mac_buffer_set(spm_offset_t spm_offset, dma_id_t dma_id){
    uint64_t id = (dma_id & 0xFFFF);
    uint64_t cmd = (spm_offset << 32) | (id << 16) | 8; // SPM_RD
    MAC_COMMAND = cmd;
}
void mac_result_compare(spm_offset_t spm_offset, dma_id_t dma_id){
    uint64_t id = (dma_id & 0xFFFF);
    uint64_t cmd = (spm_offset << 32) | (id << 16) | 16; // COMPARE
    MAC_COMMAND = cmd;
}
bool mac_wait(uint64_t req_id){
    uint64_t complete_id = MAC_ID;
    return (req_id <= complete_id);
}
#ifdef __cplusplus
}
#endif