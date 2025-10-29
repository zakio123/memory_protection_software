#pragma once
// #include <cstdint>

#ifndef MEM_LAYOUT_PARAMS_H
#define MEM_LAYOUT_PARAMS_H

/* ================================================================
 *  Memory Layout / Counter Tree / Tag structure parameters
 *  Shared between C and C++
 * ================================================================ */

#ifdef __cplusplus
extern "C" {
#endif

/* ---- Constants (C-compatible macros) ---- */
#define MAIN_PROTECTION_BASE       0x90000000ULL
#define MAIN_HEIGHT            6u      /* tree levels (1=root) */
#define MAIN_BLK64             64u     /* data block size [bytes] */
#define MAIN_NODE_BYTES        64u     /* counter tree node size [bytes] */
#define MAIN_TAGS_PER_BLOCK    8u
#define MAIN_TAG_BYTES         8u
#define MAIN_TAG_BLOCK_BYTES   64u
#define MAIN_PROTECTION_SIZE       (1024ULL * 1024ULL * 64ULL * 32ULL * 8ULL) /* 16GB */
#define MAIN_DATA_TAG_BASE         (MAIN_PROTECTION_BASE + MAIN_PROTECTION_SIZE)
#define MAIN_DATA_TAG_SIZE         (MAIN_PROTECTION_SIZE / 8) /* 2GB */
#define MAIN_COUNTER_BASE          (MAIN_DATA_TAG_BASE + MAIN_DATA_TAG_SIZE)


/* ---- Optional: also expose as typed constants for C++ ---- */
#ifdef __cplusplus
/* constexpr constants for C++ */
static constexpr uint32_t HEIGHT         = MAIN_HEIGHT;
static constexpr size_t   BLK64          = MAIN_BLK64;
static constexpr size_t   NODE           = MAIN_NODE_BYTES;
static constexpr size_t   TAGS_PER_BLOCK = MAIN_TAGS_PER_BLOCK;
static constexpr size_t   TAG_BYTES      = MAIN_TAG_BYTES;
static constexpr size_t   TAG_BLOCK      = MAIN_TAG_BLOCK_BYTES;
static constexpr uint64_t PROTECTION_BASE = MAIN_PROTECTION_BASE;
static constexpr uint64_t PROTECTION_SIZE = MAIN_PROTECTION_SIZE;
static constexpr uint64_t DATA_TAG_BASE   = MAIN_DATA_TAG_BASE;
static constexpr uint64_t DATA_TAG_SIZE   = MAIN_DATA_TAG_SIZE;
static constexpr uint64_t COUNTER_BASE    = MAIN_COUNTER_BASE;
#endif

#ifdef __cplusplus
}  /* extern "C" */
#endif

#endif /* MEM_LAYOUT_PARAMS_H */
