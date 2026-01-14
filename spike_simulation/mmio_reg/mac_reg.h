#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include "reg_map.h"
#include "spm_reg.h"
#include "config.h"
#include "lock.h"
#include "mac_encoding.h"
#define MAC_INSN_R(funct7, rd, rs1, rs2) \
    asm volatile ( \
        ".insn r %1, %2, %3, %0, %4, %5" \
        : "=r"(rd) \
        : "i"(MAC_OPCODE), "i"(MAC_F3), "i"(funct7), "r"(rs1), "r"(rs2) \
    )
void mac_init(uint64_t req_id, int hart_id, int is_write){
    // uint64_t cmd = ((uint64_t)req_id << 32) | 1;
    // MAC_COMMAND = cmd; // INIT
    // printf("MAC INIT called with req_id=%llu\n", req_id);
    // if (req_id > 21000){
    //     lock_print();
    //     printf("MAC INIT called with req_id=%llu hart_id=%d is_dmac=%d\n", req_id, hart_id,is_write);
    //     unlock_print();
    // }
    long unused;
    if (hart_id == 0){
        MAC_INSN_R(F7_MAC_INIT, unused, req_id, is_write);    
    } else {
        MAC_INSN_R(F7_MAC_INIT_2, unused, req_id, is_write);
    }
}
void mac_update(uint64_t start_bit, uint64_t end_bit,int hart_id){
    // uint64_t cmd = ((end_bit & 0XFFFF) << 48) | ((start_bit & 0xFFFF) << 32) | 2;
    // MAC_COMMAND = cmd; // UPDATE
    // printf("MAC UPDATE called with start_bit=%llu, end_bit=%llu\n", start_bit, end_bit);
    long unused;
    if (hart_id == 0){
        MAC_INSN_R(F7_MAC_UPDATE, unused, start_bit, end_bit);
    } else {
        MAC_INSN_R(F7_MAC_UPDATE_2, unused, start_bit, end_bit);
    }
}
//     MAC_INSN_R(F7_MAC_UPDATE, unused, start_bit, end_bit);
// }
void mac_digest(spm_offset_t offset,dma_id_t dma_id,int hart_id){
    long unused;
    if (hart_id == 0){
        MAC_INSN_R(F7_MAC_DIGEST, unused, offset, dma_id);
    } else {
        MAC_INSN_R(F7_MAC_DIGEST_2, unused, offset, dma_id);
    }
    // MAC_INSN_R(F7_MAC_DIGEST, unused, offset, dma_id);
    // uint64_t id = (dma_id & 0xFFFF);
    // MAC_COMMAND = (offset << 32) | (id << 16) | 4; // OUTPUT
}

void mac_buffer_set(spm_offset_t spm_offset, dma_id_t dma_id,int hart_id){
    // uint64_t id = (dma_id & 0xFFFF);
    // uint64_t cmd = (spm_offset << 32) | (id << 16) | 8; // SPM_RD
    // MAC_COMMAND = cmd;
    long unused;
    if (hart_id == 0){
        MAC_INSN_R(F7_MAC_COPY, unused, spm_offset, dma_id);
    } else {
        MAC_INSN_R(F7_MAC_COPY_2, unused, spm_offset, dma_id);
    }
}
void mac_result_compare(spm_offset_t spm_offset, dma_id_t dma_id,int hart_id){
    long unused;
    if (hart_id == 0){
        MAC_INSN_R(F7_MAC_COMPARE, unused, spm_offset, dma_id);
    } else {
        MAC_INSN_R(F7_MAC_COMPARE_2, unused, spm_offset, dma_id);
    }
    // uint64_t id = (dma_id & 0xFFFF);
    // uint64_t cmd = (spm_offset << 32) | (id << 16) | 16; // COMPARE
    // MAC_COMMAND = cmd;
}
void mac_wait(uint64_t req_id, long hart_id){
    if (hart_id == 0){
        int counter = 0;
        while (1){
            counter += 1;
            uint64_t complete_id = MAC_ID;
            if (req_id <= complete_id) break;
            if (counter % 1000000 == 0){
                lock_print();
                printf("MAC WAIT: hart_id=0 waiting for req_id=%llu current_complete_id=%llu\n", req_id, complete_id);
                uint64_t spm_id = SPM_COMPLETE_ID;
                printf("  SPM COMPLETE ID=%llu\n", spm_id);
                uint64_t a = MAC_ID_2;
                printf("  MAC COMPLETE ID=%llu\n", a);
                unlock_print();
                exit(1);
            }
        }
    } else {
        int counter = 0;
        while (1){
            counter += 1;
            uint64_t complete_id = MAC_ID_2;
            if (req_id <= complete_id) break;
            if (counter % 1000000 == 0){
                lock_print();
                printf("WAIT: hart_id=1 waiting for req_id=%llu current_complete_id=%llu\n", req_id, complete_id);
                uint64_t spm_id = SPM_COMPLETE_ID;
                printf("  SPM COMPLETE ID=%llu\n", spm_id);
                uint64_t a = MAC_ID;
                printf(" anotje MAC COMPLETE ID=%llu\n", a);
                unlock_print();
                exit(1);
            }
        }
    }
}
void mac_input_core(uint64_t input,long hart_id){
    // 56bitまで入力として扱えるようにする
    input = (input << 8) | 32;
    if (hart_id == 0){
        MAC_COMMAND = input;
    } else {
        MAC_COMMAND_2 = input;
    }
    // MAC_COMMAND = input;
}
#ifdef __cplusplus
}
#endif