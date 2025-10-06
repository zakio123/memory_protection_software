#include <stdint.h>
#include <stddef.h>
#include "reg_map.h"
void set_seed(const uint64_t major_counter, const uint8_t minor_counter, const uint64_t request_addr){
    uint64_t seed_0 = request_addr + major_counter;
    uint64_t seed_1 = request_addr + (minor_counter);
    uint64_t seed_2 = request_addr + 16 + major_counter;
    uint64_t seed_3 = request_addr + 16 + (minor_counter);
    uint64_t seed_4 = request_addr + 32 + major_counter;
    uint64_t seed_5 = request_addr + 32 + (minor_counter);
    uint64_t seed_6 = request_addr + 48 + major_counter;
    uint64_t seed_7 = request_addr + 48 + (minor_counter);
    AES_INPUT_0_REG = seed_0;
    AES_INPUT_1_REG = seed_1;
    AES_INPUT_2_REG = seed_2;
    AES_INPUT_3_REG = seed_3;
    AES_INPUT_4_REG = seed_4;
    AES_INPUT_5_REG = seed_5;
    AES_INPUT_6_REG = seed_6;
    AES_INPUT_7_REG = seed_7;
    AES_START_REG = 1; // start
    while (AES_START_REG); // busy待ち
}