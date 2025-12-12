#ifndef CONFIG_MOCK_H
#define CONFIG_MOCK_H

#include <stdint.h>
#include <stdbool.h>
// #define META_SPM_BASE 0x60000000ULL

// 計測用 CSR読み込み
static inline uint64_t read_instret() {
    uint64_t val;
    asm volatile ("csrr %0, minstret" : "=r" (val));
    return val;
}

#endif