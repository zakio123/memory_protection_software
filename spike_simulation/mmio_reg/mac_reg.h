#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>
#include "reg_map.h"
#include "spm_reg.h"
#include "config.h"
#include "mac_encoding.h"
#define MAC_INSN_R(funct7, rd, rs1, rs2) \
    asm volatile ( \
        ".insn r %1, %2, %3, %0, %4, %5" \
        : "=r"(rd) \
        : "i"(MAC_OPCODE), "i"(MAC_F3), "i"(funct7), "r"(rs1), "r"(rs2) \
    )
void mac_init(uint64_t req_id){
    // uint64_t cmd = ((uint64_t)req_id << 32) | 1;
    // MAC_COMMAND = cmd; // INIT
    // printf("MAC INIT called with req_id=%llu\n", req_id);
    long unused;
    MAC_INSN_R(F7_MAC_INIT, unused, req_id, 0);
}
void mac_update(uint64_t start_bit, uint64_t end_bit){
    // uint64_t cmd = ((end_bit & 0XFFFF) << 48) | ((start_bit & 0xFFFF) << 32) | 2;
    // MAC_COMMAND = cmd; // UPDATE
    // printf("MAC UPDATE called with start_bit=%llu, end_bit=%llu\n", start_bit, end_bit);
    long unused;
    MAC_INSN_R(F7_MAC_UPDATE, unused, start_bit, end_bit);
}
void mac_digest(spm_offset_t offset,dma_id_t dma_id){
    long unused;
    MAC_INSN_R(F7_MAC_DIGEST, unused, offset, dma_id);
    // uint64_t id = (dma_id & 0xFFFF);
    // MAC_COMMAND = (offset << 32) | (id << 16) | 4; // OUTPUT
}

void mac_buffer_set(spm_offset_t spm_offset, dma_id_t dma_id){
    // uint64_t id = (dma_id & 0xFFFF);
    // uint64_t cmd = (spm_offset << 32) | (id << 16) | 8; // SPM_RD
    // MAC_COMMAND = cmd;
    long unused;
    MAC_INSN_R(F7_MAC_COPY, unused, spm_offset, dma_id);
}
void mac_result_compare(spm_offset_t spm_offset, dma_id_t dma_id){
    long unused;
    MAC_INSN_R(F7_MAC_COMPARE, unused, spm_offset, dma_id);
    // uint64_t id = (dma_id & 0xFFFF);
    // uint64_t cmd = (spm_offset << 32) | (id << 16) | 16; // COMPARE
    // MAC_COMMAND = cmd;
}
bool mac_wait(uint64_t req_id){
    uint64_t complete_id = MAC_ID;
    return (req_id <= complete_id);
}
#ifdef __cplusplus
}
#endif