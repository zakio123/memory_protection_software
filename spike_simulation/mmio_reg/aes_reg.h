#ifdef __cplusplus
extern "C" {
#endif
#include <stdint.h>
#include <stddef.h>
#include "reg_map.h"
#include "config.h"

static inline void set_seed(const uint64_t major_counter, const uint16_t minor_counter, const dram_addr_t request_addr) {
    // printf("[Core FW] Setting AES Seed: major=%016llx, minor=%02x, addr=%016llx\n", major_counter, minor_counter, request_addr);
    uint64_t seed_0 = major_counter;
    uint64_t seed_1 = (uint64_t)minor_counter << 48 | request_addr;
    uint64_t seed_2 = major_counter;
    uint64_t seed_3 = (uint64_t)minor_counter << 48 | (request_addr + 16);
    uint64_t seed_4 = major_counter;
    uint64_t seed_5 = (uint64_t)minor_counter << 48 | (request_addr + 32);
    uint64_t seed_6 = major_counter;
    uint64_t seed_7 = (uint64_t)minor_counter << 48 | (request_addr + 48);
    AES_INPUT_0_REG = seed_0;
    AES_INPUT_1_REG = seed_1;
    AES_INPUT_2_REG = seed_2;
    AES_INPUT_3_REG = seed_3;
    AES_INPUT_4_REG = seed_4;
    AES_INPUT_5_REG = seed_5;
    AES_INPUT_6_REG = seed_6;
    AES_INPUT_7_REG = seed_7;
    // uint64_t cmd = ((uint64_t)req_id << 32) | (input_from_reqio ? 1ULL : 0ULL) | ((output_to_reqio ? 1ULL : 0ULL) << 1);
    // cmd = cmd | ((spm_offset & ((1ULL << 30ULL) - 1ULL)) << 2);
    AES_START_REG = 1; 
    // while (AES_START_REG); // busy待ち
}
static inline void set_seed_global(const uint64_t major_counter, const dram_addr_t request_addr) {
    // printf("[Core FW] Setting AES Seed: major=%016llx, minor=%02x, addr=%016llx\n", major_counter, minor_counter, request_addr);
    uint64_t seed_0 = major_counter;
    uint64_t seed_1 = request_addr;
    uint64_t seed_2 = major_counter;
    uint64_t seed_3 = request_addr + 16;
    uint64_t seed_4 = major_counter;
    uint64_t seed_5 = request_addr + 32;
    uint64_t seed_6 = major_counter;
    uint64_t seed_7 = request_addr + 48;
    AES_INPUT_0_REG = seed_0;
    AES_INPUT_1_REG = seed_1;
    AES_INPUT_2_REG = seed_2;
    AES_INPUT_3_REG = seed_3;
    AES_INPUT_4_REG = seed_4;
    AES_INPUT_5_REG = seed_5;
    AES_INPUT_6_REG = seed_6;
    AES_INPUT_7_REG = seed_7;
    AES_START_REG = 1; 
    }
#ifdef __cplusplus
}
#endif