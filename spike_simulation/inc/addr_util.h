#include "config.h"
static inline dram_addr_t calculate_level_base_addr(uint64_t level) {
    dram_addr_t tmp = 64ULL * ((1ULL << (ARTY_LOG2 * (level-1ULL))) - 1ULL);
    dram_addr_t offset = tmp / (MINOR_COUNTER_COUNT - 1);
    return offset;
}

// static inline dram_addr_t get_counterblock_addr(dram_addr_t request_addr){
//     dram_addr_t counterblock_addr = COUNTER_BASE + (((request_addr - PROTECTION_BASE) / (PROTECTION_SIZE_GRAIN * MINOR_COUNTER_COUNT))) * 64 + calculate_level_base_addr(HEIGHT);
//     return counterblock_addr;
// }

static inline dram_addr_t get_datamacblock_addr(dram_addr_t request_addr){
    // Each MAC block covers MAC_COVERAGE_BLOCKS data blocks
    // PROTECTION_SIZE_GRAIN defines the granularity (currently 128 bytes = 2 x 64B blocks)
    // Total coverage per MAC = PROTECTION_SIZE_GRAIN * MAC_COVERAGE_BLOCKS
    dram_addr_t datamacblock_addr = DATA_TAG_BASE +
        (((request_addr - PROTECTION_BASE) / (PROTECTION_SIZE_GRAIN * MAC_COVERAGE_BLOCKS))) * 64;
    return datamacblock_addr;
}
static inline uint64_t read_instret() {
    uint64_t val;
    asm volatile ("csrr %0, minstret" : "=r" (val));
    return val;
}