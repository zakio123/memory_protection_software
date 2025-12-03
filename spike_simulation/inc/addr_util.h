#include "config.h"
static inline dram_addr_t calculate_level_base_addr(uint64_t level) {
    dram_addr_t offset = 64 * ((1 << (5 * (level-1))) - 1) / (32 - 1);
    return offset;
}

static inline dram_addr_t get_counterblock_addr(dram_addr_t request_addr){
    dram_addr_t counterblock_addr = COUNTER_BASE + (((request_addr - PROTECTION_BASE) / (64 * 32))) * 64 + calculate_level_base_addr(HEIGHT);
    return counterblock_addr;
}

static inline dram_addr_t get_datamacblock_addr(dram_addr_t request_addr){
    dram_addr_t datamacblock_addr = DATA_TAG_BASE + (((request_addr - PROTECTION_BASE) / (64 * 8))) * 64;
    return datamacblock_addr;
}
