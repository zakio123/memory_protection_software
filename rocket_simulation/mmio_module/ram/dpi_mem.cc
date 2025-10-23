#include <svdpi.h>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <sys/mman.h>
#include <unistd.h>

static uint8_t* g_mem = nullptr;
static uint64_t g_words = 0;   // 64bit words
static uint64_t g_bytes = 0;   // total bytes

extern "C" void dpi_mem_init_words(unsigned long long words) {
    if (g_mem) return;
    g_words = words;
    g_bytes = g_words * 8ull;

    void* p = mmap(nullptr, g_bytes, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (p == MAP_FAILED) {
        perror("mmap");
        std::exit(1);
    }
    g_mem = static_cast<uint8_t*>(p);
    std::memset(g_mem, 0, g_bytes);
    std::fprintf(stderr, "[dpi_mem] init: words=%llu bytes=%llu\n",
                 (unsigned long long)g_words, (unsigned long long)g_bytes);
}

static inline void check_idx(uint32_t idx) {
    if (!g_mem || (uint64_t)idx >= g_words) {
        std::fprintf(stderr, "[dpi_mem] OOB idx=%u (words=%llu)\n",
                     idx, (unsigned long long)g_words);
        std::abort();
    }
}

extern "C" unsigned long long dpi_mem_read64_idx(unsigned int idx) {
    check_idx(idx);
    uint64_t v;
    std::memcpy(&v, g_mem + ((uint64_t)idx << 3), 8);
    return v; // little-endian
}

extern "C" void dpi_mem_write64_mask_idx(unsigned int idx,
                                         unsigned long long data,
                                         unsigned char mask) {
    check_idx(idx);
    uint8_t* p = g_mem + ((uint64_t)idx << 3);
    // 1bit=1byte enable
    for (int i = 0; i < 8; i++) {
        if (mask & (1u << i)) {
            p[i] = (uint8_t)((data >> (8*i)) & 0xFF);
        }
    }
}
