#include <stdint.h>
#include "mmio_reg/spm_reg.h"
#include "mmio_reg/mac_reg.h"
#include "mmio_reg/aes_reg.h"
#include "mmio_reg/axim_reg.h"
#include "mmio_reg/memreq_reg.h"
#include "mmio_reg/xor_reg.h"
#include "mmio_reg/reg_map.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "util.h"
#include "config.h"
#include "cache_controll.h"
#include "addr_util.h"
// #include "sec_operation.h"
#define REENCRYPTION_SPM_OFFSET DATA_SPM_OFFSET + 64

#define COUNTER_EFFECTIVE_BITS 56
#define COUNTER_COUNT_ZCC 128
#define COUNTER_EFFECTIVE_MASK ((1ULL << COUNTER_EFFECTIVE_BITS) - 1ULL)

#if MINOR_COUNTER_COUNT != COUNTER_COUNT_ZCC
#warning "var_seq_zcc.c assumes MINOR_COUNTER_COUNT=128 for correct layout"
#endif
#if PROTECTION_SIZE_GRAIN != 64
#warning "var_seq_zcc.c assumes PROTECTION_SIZE_GRAIN=64B"
#endif

// ZCC layout (511 bits used + 1 reserved bit at bit63)
#define ZCC_MAJOR_START 0
#define ZCC_MAJOR_BITS 56
#define ZCC_FORMAT_BIT 56
#define ZCC_CTRSZ_START 57
#define ZCC_CTRSZ_BITS 6
#define ZCC_RESERVED_BIT 63
#define ZCC_BITVECTOR_START 64
#define ZCC_BITVECTOR_BITS 128
#define ZCC_NZ_START 192
#define ZCC_NZ_BITS 256

// MCR layout (paper-like 49+7+1+7+384+64 = 512 bits)
#define MCR_MAJOR49_START 0
#define MCR_MAJOR49_BITS 49
#define MCR_BASE1_START 49
#define MCR_BASE_BITS 7
#define MCR_FORMAT_BIT 56
#define MCR_BASE2_START 57
#define MCR_MINORS_START 64
#define MCR_MINOR_BITS 3

bool instret_dump = false;
dram_addr_t level_base[HEIGHT + 1] = {0};
dma_id_t global_dma_id = 0;
uint64_t global_mac_req_id = 1;
int over_flow_count = 0;

static inline uint64_t mask_u64(unsigned width) {
  if (width == 0) return 0;
  if (width >= 64) return UINT64_MAX;
  return (1ULL << width) - 1ULL;
}

static inline uint64_t read_bits_u64(spm_offset_t base, unsigned start_bit, unsigned width) {
  if (width == 0) return 0;
  unsigned word_idx = start_bit >> 6;
  unsigned bit_idx = start_bit & 63U;
  uint64_t lo = spm_ld64(base + (word_idx * 8)) >> bit_idx;
  if (bit_idx + width <= 64) return lo & mask_u64(width);
  unsigned hi_bits = bit_idx + width - 64;
  uint64_t hi = spm_ld64(base + ((word_idx + 1) * 8)) & mask_u64(hi_bits);
  return (lo | (hi << (64 - bit_idx))) & mask_u64(width);
}

static inline void write_bits_u64(spm_offset_t base, unsigned start_bit, unsigned width, uint64_t value) {
  if (width == 0) return;
  value &= mask_u64(width);
  unsigned word_idx = start_bit >> 6;
  unsigned bit_idx = start_bit & 63U;
  uint64_t word0 = spm_ld64(base + (word_idx * 8));
  uint64_t mask0 = mask_u64(width) << bit_idx;
  if (bit_idx + width <= 64) {
    word0 = (word0 & ~mask0) | ((value << bit_idx) & mask0);
    spm_sd64(base + (word_idx * 8), word0);
  } else {
    unsigned first_bits = 64 - bit_idx;
    unsigned second_bits = width - first_bits;
    uint64_t low_part = value & mask_u64(first_bits);
    word0 &= ~(mask_u64(first_bits) << bit_idx);
    word0 |= (low_part << bit_idx);
    spm_sd64(base + (word_idx * 8), word0);
    uint64_t word1 = spm_ld64(base + ((word_idx + 1) * 8));
    word1 &= ~mask_u64(second_bits);
    word1 |= (value >> first_bits) & mask_u64(second_bits);
    spm_sd64(base + ((word_idx + 1) * 8), word1);
  }
}

static inline uint64_t low_mask_bits(unsigned n) {
  if (n == 0) return 0;
  if (n >= 64) return UINT64_MAX;
  return (1ULL << n) - 1ULL;
}

static inline unsigned popcount64_sw(uint64_t x) {
  unsigned c = 0;
  while (x != 0) {
    c += (unsigned)(x & 1ULL);
    x >>= 1;
  }
  return c;
}

static inline unsigned rank1_128(uint64_t lo, uint64_t hi, unsigned idx) {
  if (idx == 0) return 0;
  if (idx <= 64) return popcount64_sw(lo & low_mask_bits(idx));
  return popcount64_sw(lo) + popcount64_sw(hi & low_mask_bits(idx - 64));
}

static inline unsigned zcc_width_from_field(spm_offset_t base) {
  unsigned w = (unsigned)read_bits_u64(base, ZCC_CTRSZ_START, ZCC_CTRSZ_BITS);
  if (w == 0) return COUNTER_EFFECTIVE_BITS;
  if (w > COUNTER_EFFECTIVE_BITS) return COUNTER_EFFECTIVE_BITS;
  return w;
}

static inline unsigned zcc_width_from_nnz(unsigned nnz) {
  if (nnz == 0) return COUNTER_EFFECTIVE_BITS;
  unsigned w = 256U / nnz;
  if (w == 0) w = 1;
  if (w > COUNTER_EFFECTIVE_BITS) w = COUNTER_EFFECTIVE_BITS;
  return w;
}

static inline void counter_decode_all_effective(spm_offset_t base, uint64_t out[MINOR_COUNTER_COUNT]) {
  bool is_mcr = (read_bits_u64(base, ZCC_FORMAT_BIT, 1) != 0);
  if (!is_mcr) {
    uint64_t major = read_bits_u64(base, ZCC_MAJOR_START, ZCC_MAJOR_BITS) & COUNTER_EFFECTIVE_MASK;
    uint64_t bv_lo = read_bits_u64(base, ZCC_BITVECTOR_START, 64);
    uint64_t bv_hi = read_bits_u64(base, ZCC_BITVECTOR_START + 64, 64);
    unsigned w = zcc_width_from_field(base);
    unsigned pos = 0;
    for (unsigned i = 0; i < MINOR_COUNTER_COUNT; i++) {
      bool nz = (i < 64) ? ((bv_lo >> i) & 1ULL) : ((bv_hi >> (i - 64)) & 1ULL);
      uint64_t delta = 0;
      if (nz) {
        delta = read_bits_u64(base, ZCC_NZ_START + (unsigned)(pos * w), w);
        pos++;
      }
      out[i] = (major + delta) & COUNTER_EFFECTIVE_MASK;
    }
    return;
  }

  uint64_t major49 = read_bits_u64(base, MCR_MAJOR49_START, MCR_MAJOR49_BITS);
  uint64_t major_floor = (major49 << 7) & COUNTER_EFFECTIVE_MASK;
  uint64_t base1 = read_bits_u64(base, MCR_BASE1_START, MCR_BASE_BITS);
  uint64_t base2 = read_bits_u64(base, MCR_BASE2_START, MCR_BASE_BITS);
  for (unsigned i = 0; i < MINOR_COUNTER_COUNT; i++) {
    uint64_t minor3 = read_bits_u64(base, MCR_MINORS_START + i * MCR_MINOR_BITS, MCR_MINOR_BITS);
    uint64_t grp_base = (i < 64) ? base1 : base2;
    out[i] = (major_floor + grp_base + minor3) & COUNTER_EFFECTIVE_MASK;
  }
}

static inline uint64_t counter_get_effective(spm_offset_t base, unsigned idx) {
  if (idx >= MINOR_COUNTER_COUNT) return 0;
  bool is_mcr = (read_bits_u64(base, ZCC_FORMAT_BIT, 1) != 0);
  if (!is_mcr) {
    uint64_t major = read_bits_u64(base, ZCC_MAJOR_START, ZCC_MAJOR_BITS) & COUNTER_EFFECTIVE_MASK;
    uint64_t bv_lo = read_bits_u64(base, ZCC_BITVECTOR_START, 64);
    uint64_t bv_hi = read_bits_u64(base, ZCC_BITVECTOR_START + 64, 64);
    bool nz = (idx < 64) ? ((bv_lo >> idx) & 1ULL) : ((bv_hi >> (idx - 64)) & 1ULL);
    if (!nz) return major;
    unsigned w = zcc_width_from_field(base);
    unsigned pos = rank1_128(bv_lo, bv_hi, idx);
    uint64_t delta = read_bits_u64(base, ZCC_NZ_START + (unsigned)(pos * w), w);
    return (major + delta) & COUNTER_EFFECTIVE_MASK;
  }

  uint64_t major49 = read_bits_u64(base, MCR_MAJOR49_START, MCR_MAJOR49_BITS);
  uint64_t major_floor = (major49 << 7) & COUNTER_EFFECTIVE_MASK;
  uint64_t basev = (idx < 64) ? read_bits_u64(base, MCR_BASE1_START, MCR_BASE_BITS)
                              : read_bits_u64(base, MCR_BASE2_START, MCR_BASE_BITS);
  uint64_t minor3 = read_bits_u64(base, MCR_MINORS_START + idx * MCR_MINOR_BITS, MCR_MINOR_BITS);
  return (major_floor + basev + minor3) & COUNTER_EFFECTIVE_MASK;
}

static inline bool counter_encode_zcc(spm_offset_t base, const uint64_t vals[MINOR_COUNTER_COUNT]) {
  uint64_t minv = COUNTER_EFFECTIVE_MASK;
  uint64_t maxv = 0;
  for (unsigned i = 0; i < MINOR_COUNTER_COUNT; i++) {
    uint64_t v = vals[i] & COUNTER_EFFECTIVE_MASK;
    if (v < minv) minv = v;
    if (v > maxv) maxv = v;
  }
  uint64_t deltas[MINOR_COUNTER_COUNT];
  unsigned nnz = 0;
  uint64_t max_delta = 0;
  for (unsigned i = 0; i < MINOR_COUNTER_COUNT; i++) {
    deltas[i] = (vals[i] - minv) & COUNTER_EFFECTIVE_MASK;
    if (deltas[i] != 0) nnz++;
    if (deltas[i] > max_delta) max_delta = deltas[i];
  }
  if (nnz > 64) return false;

  unsigned w = zcc_width_from_nnz(nnz);
  if (max_delta > mask_u64(w)) return false;

  for (unsigned i = 0; i < 7; i++) spm_sd64(base + (i * 8), 0);
  write_bits_u64(base, ZCC_MAJOR_START, ZCC_MAJOR_BITS, minv);
  write_bits_u64(base, ZCC_FORMAT_BIT, 1, 0);
  write_bits_u64(base, ZCC_CTRSZ_START, ZCC_CTRSZ_BITS, w);
  write_bits_u64(base, ZCC_RESERVED_BIT, 1, 0);

  uint64_t bv_lo = 0;
  uint64_t bv_hi = 0;
  unsigned pos = 0;
  for (unsigned i = 0; i < MINOR_COUNTER_COUNT; i++) {
    if (deltas[i] == 0) continue;
    if (i < 64) bv_lo |= (1ULL << i);
    else bv_hi |= (1ULL << (i - 64));
    write_bits_u64(base, ZCC_NZ_START + (unsigned)(pos * w), w, deltas[i]);
    pos++;
  }
  write_bits_u64(base, ZCC_BITVECTOR_START, 64, bv_lo);
  write_bits_u64(base, ZCC_BITVECTOR_START + 64, 64, bv_hi);
  return true;
}

static inline bool counter_encode_mcr(spm_offset_t base, const uint64_t vals[MINOR_COUNTER_COUNT]) {
  uint64_t min1 = COUNTER_EFFECTIVE_MASK;
  uint64_t min2 = COUNTER_EFFECTIVE_MASK;
  uint64_t max1 = 0;
  uint64_t max2 = 0;
  for (unsigned i = 0; i < 64; i++) {
    uint64_t v = vals[i] & COUNTER_EFFECTIVE_MASK;
    if (v < min1) min1 = v;
    if (v > max1) max1 = v;
  }
  for (unsigned i = 64; i < MINOR_COUNTER_COUNT; i++) {
    uint64_t v = vals[i] & COUNTER_EFFECTIVE_MASK;
    if (v < min2) min2 = v;
    if (v > max2) max2 = v;
  }
  if ((max1 - min1) > 7 || (max2 - min2) > 7) return false;

  uint64_t mins_max = (min1 > min2) ? min1 : min2;
  uint64_t mins_min = (min1 < min2) ? min1 : min2;
  uint64_t low = 0;
  if (mins_max > 127) {
    low = mins_max - 127;
    low = (low + 127ULL) & ~127ULL;
  }
  uint64_t high = mins_min & ~127ULL;
  if (low > high) return false;
  uint64_t major_floor = high;
  uint64_t major49 = major_floor >> 7;
  if (major49 > mask_u64(MCR_MAJOR49_BITS)) return false;

  uint64_t base1 = min1 - major_floor;
  uint64_t base2 = min2 - major_floor;
  if (base1 > 127 || base2 > 127) return false;

  for (unsigned i = 0; i < MINOR_COUNTER_COUNT; i++) {
    uint64_t grp_base = (i < 64) ? base1 : base2;
    uint64_t rel = (vals[i] & COUNTER_EFFECTIVE_MASK) - major_floor - grp_base;
    if (rel > 7) return false;
  }

  for (unsigned i = 0; i < 7; i++) spm_sd64(base + (i * 8), 0);
  write_bits_u64(base, MCR_MAJOR49_START, MCR_MAJOR49_BITS, major49);
  write_bits_u64(base, MCR_BASE1_START, MCR_BASE_BITS, base1);
  write_bits_u64(base, MCR_FORMAT_BIT, 1, 1);
  write_bits_u64(base, MCR_BASE2_START, MCR_BASE_BITS, base2);
  for (unsigned i = 0; i < MINOR_COUNTER_COUNT; i++) {
    uint64_t grp_base = (i < 64) ? base1 : base2;
    uint64_t rel = (vals[i] & COUNTER_EFFECTIVE_MASK) - major_floor - grp_base;
    write_bits_u64(base, MCR_MINORS_START + i * MCR_MINOR_BITS, MCR_MINOR_BITS, rel);
  }
  return true;
}

static inline bool counter_encode_auto(spm_offset_t base, const uint64_t vals[MINOR_COUNTER_COUNT]) {
  if (counter_encode_zcc(base, vals)) return true;
  if (counter_encode_mcr(base, vals)) return true;
  return false;
}

static inline uint64_t counter_overflow_new_base(const uint64_t vals[MINOR_COUNTER_COUNT]) {
  uint64_t maxv = 0;
  for (unsigned i = 0; i < MINOR_COUNTER_COUNT; i++) {
    uint64_t v = vals[i] & COUNTER_EFFECTIVE_MASK;
    if (v > maxv) maxv = v;
  }
  if (maxv == COUNTER_EFFECTIVE_MASK) {
    printf("Error: 56-bit counter overflow detected.\n");
    exit(1);
  }
  return (maxv + 1) & COUNTER_EFFECTIVE_MASK;
}

static inline void counter_set_all_to_base_zcc(spm_offset_t base, uint64_t new_base) {
  for (unsigned i = 0; i < 7; i++) spm_sd64(base + (i * 8), 0);
  write_bits_u64(base, ZCC_MAJOR_START, ZCC_MAJOR_BITS, new_base & COUNTER_EFFECTIVE_MASK);
  write_bits_u64(base, ZCC_FORMAT_BIT, 1, 0);
  write_bits_u64(base, ZCC_CTRSZ_START, ZCC_CTRSZ_BITS, COUNTER_EFFECTIVE_BITS);
  write_bits_u64(base, ZCC_RESERVED_BIT, 1, 0);
}

static inline bool counter_try_increment(spm_offset_t base, unsigned idx, uint64_t *new_counter) {
  if (idx >= MINOR_COUNTER_COUNT) return false;
  uint64_t vals[MINOR_COUNTER_COUNT];
  counter_decode_all_effective(base, vals);
  if (vals[idx] == COUNTER_EFFECTIVE_MASK) return false;
  vals[idx] += 1;
  if (!counter_encode_auto(base, vals)) return false;
  if (new_counter) *new_counter = vals[idx] & COUNTER_EFFECTIVE_MASK;
  return true;
}

static inline unsigned parent_counter_slot(uint64_t node_index) {
  return (unsigned)((node_index / MINOR_COUNTER_COUNT) % MINOR_COUNTER_COUNT);
}

static inline void mac_absorb_counter56(uint64_t counter56, dma_id_t dma_id, int hart_id) {
  (void)dma_id;
  mac_input_core(counter56 & COUNTER_EFFECTIVE_MASK, hart_id);
}

static inline void update_tag_with_parent_counter(spm_offset_t child_spm_offset, uint64_t parent_counter,
    uint32_t mac_req_id, dma_id_t dma_id, dram_addr_t dram_addr) {
  int hart_id = -1;
  asm volatile("csrr %0, mhartid" : "=r"(hart_id));
  mac_init(mac_req_id, hart_id, 0);
  mac_absorb_counter56(parent_counter, dma_id, hart_id);
  mac_buffer_set(child_spm_offset, dma_id, hart_id);
  mac_update(0, 447, hart_id);
  mac_input_core(dram_addr, hart_id);
  mac_digest(child_spm_offset + 56, dma_id, hart_id);
}

static inline void verify_one_height_with_parent_counter(spm_offset_t child_spm_offset, uint64_t parent_counter,
    uint32_t mac_req_id, dma_id_t dma_id, dram_addr_t dram_addr) {
  int hart_id = -1;
  asm volatile("csrr %0, mhartid" : "=r"(hart_id));
  mac_init(mac_req_id, hart_id, 0);
  mac_absorb_counter56(parent_counter, dma_id, hart_id);
  mac_buffer_set(child_spm_offset, dma_id, hart_id);
  mac_update(0, 447, hart_id);
  mac_input_core(dram_addr, hart_id);
  mac_result_compare(child_spm_offset + 56, dma_id, hart_id);
}

void update_tag(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index,
  uint32_t mac_req_id, dma_id_t dma_id, dram_addr_t dram_addr) {
  uint64_t parent_counter = 0;
  spm_wait(dma_id);
  if (parent_spm_offset == 0) {
    parent_counter = spm_ld64(0) & COUNTER_EFFECTIVE_MASK;
  } else {
    parent_counter = counter_get_effective(parent_spm_offset, parent_counter_slot(node_index));
  }
  update_tag_with_parent_counter(child_spm_offset, parent_counter, mac_req_id, dma_id, dram_addr);
}

static inline void verify_one_height_lazy_root(spm_offset_t child_spm_offset,
  uint32_t mac_req_id, dma_id_t dma_id, dram_addr_t dram_addr) {
  uint64_t root_counter = spm_ld64(0) & COUNTER_EFFECTIVE_MASK;
  verify_one_height_with_parent_counter(child_spm_offset, root_counter, mac_req_id, dma_id, dram_addr);
}

static inline void verify_one_height_lazy(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index,
    uint32_t mac_req_id, dma_id_t dma_id, dram_addr_t dram_addr) {
  uint64_t parent_counter = 0;
  spm_wait(dma_id);
  if (parent_spm_offset == 0) {
    parent_counter = spm_ld64(0) & COUNTER_EFFECTIVE_MASK;
  } else {
    parent_counter = counter_get_effective(parent_spm_offset, parent_counter_slot(node_index));
  }
  verify_one_height_with_parent_counter(child_spm_offset, parent_counter, mac_req_id, dma_id, dram_addr);
}

// マイナーカウンターがオーバーフローした時の復号化+再暗号化処理
static inline uint64_t reencryption_lazy(dram_addr_t counter_block_addr, spm_offset_t counter_spm_offset) {
  dram_addr_t data_block_addr = PROTECTION_BASE + (counter_block_addr - level_base[HEIGHT]) / 64 * (MINOR_COUNTER_COUNT * 64);
  uint64_t old_vals[MINOR_COUNTER_COUNT];
  counter_decode_all_effective(counter_spm_offset, old_vals);
  uint64_t new_base = counter_overflow_new_base(old_vals);

  for (long i = 0; i < MINOR_COUNTER_COUNT; i++) {
    global_dma_id += 1;
    dma_id_t dma_id = global_dma_id;
    dram_addr_t dram_addr = data_block_addr + i * 64;
    spm_copy_to_local(dram_addr, REENCRYPTION_SPM_OFFSET, dma_id);

    dram_addr_t datamacblock_addr = get_datamacblock_addr(dram_addr);
    index_t set_index = get_cache_mac_index(datamacblock_addr);
    spm_offset_t spm_offset;
    light_tag_info_t light_info = light_tag_check(datamacblock_addr);
    if (light_info.hit) {
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      set_block_dirty(set_index, light_info.way);
    } else {
      global_dma_id += 1;
      dma_id = global_dma_id;
      if (light_info.way == -1) {
        light_info.way = get_victim_way(set_index);
        spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
        if (is_block_dirty(set_index, light_info.way)) {
          dram_addr_t old_block_addr = get_block_addr(set_index, light_info.way);
          spm_write_back(spm_offset, old_block_addr, 0);
        }
      } else {
        set_block_valid(set_index, light_info.way);
        spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      }
      spm_copy_to_local(datamacblock_addr, spm_offset, dma_id);
      set_block_addr(set_index, light_info.way, datamacblock_addr);
      set_block_dirty(set_index, light_info.way);
    }

    uint64_t old_counter = old_vals[i] & COUNTER_EFFECTIVE_MASK;
    spm_offset_t dmac_byte_offset = ((dram_addr - PROTECTION_BASE) / 64) % 8 * 8;
    mac_init(global_mac_req_id, 0, 1);
    mac_buffer_set(REENCRYPTION_SPM_OFFSET, dma_id, 0);
    mac_update(0, 511, 0);
    mac_absorb_counter56(old_counter, dma_id, 0);
    mac_input_core(dram_addr, 0);
    mac_result_compare(spm_offset + dmac_byte_offset, dma_id, 0);
    mac_wait(global_mac_req_id, 0);
    global_mac_req_id += 1;

    set_seed(old_counter, 0, dram_addr);
    while (AES_START_REG);
    spm_wait(dma_id);
    xor_start(false, false, 0, REENCRYPTION_SPM_OFFSET);

    set_seed(new_base, 0, dram_addr);
    while (AES_START_REG);
    xor_start(false, false, 0, REENCRYPTION_SPM_OFFSET);
    spm_write_back(REENCRYPTION_SPM_OFFSET, dram_addr, 0);

    mac_init(global_mac_req_id, 0, 1);
    mac_buffer_set(REENCRYPTION_SPM_OFFSET, dma_id, 0);
    mac_update(0, 511, 0);
    mac_absorb_counter56(new_base, dma_id, 0);
    mac_input_core(dram_addr, 0);
    mac_digest(spm_offset + dmac_byte_offset, dma_id, 0);
    mac_wait(global_mac_req_id, 0);
    global_mac_req_id += 1;
  }

  counter_set_all_to_base_zcc(counter_spm_offset, new_base);
  return global_mac_req_id;
}

// 中間ノードのマイナーカウンターがオーバーフローした時の再計算処理
static inline uint64_t recalc_tag_lazy(dram_addr_t node_dram_addr, spm_offset_t node_spm_offset, int height, long index) {
  long block_idx = index / MINOR_COUNTER_COUNT;
  dram_addr_t child_base_addr = level_base[height + 2] + block_idx * MINOR_COUNTER_COUNT * 64;
  uint64_t old_vals[MINOR_COUNTER_COUNT];
  counter_decode_all_effective(node_spm_offset, old_vals);
  uint64_t new_base = counter_overflow_new_base(old_vals);

  for (long i = 0; i < MINOR_COUNTER_COUNT; i++) {
    long child_index = (block_idx * MINOR_COUNTER_COUNT + i) * MINOR_COUNTER_COUNT;
    dram_addr_t child_dram_addr = child_base_addr + i * 64;
    light_tag_info_t light_info = light_tag_check(child_dram_addr);
    spm_offset_t child_spm_offset;
    long temp_idx = -1;
    dma_id_t dma_id = global_dma_id;
    bool do_verify = true;
    if (light_info.hit) {
      index_t set_index = get_cache_tree_set_index(child_dram_addr);
      bool mac_updated = is_mac_updated(set_index, light_info.way);
      child_spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      set_block_dirty(set_index, light_info.way);
      setParentUpdated(set_index, light_info.way);
      if (!mac_updated) do_verify = false;
    } else {
      temp_idx = find_temp_entry(child_dram_addr);
      if (temp_idx >= 0) {
        child_spm_offset = get_temp_spm_offset(temp_idx);
      } else {
        child_spm_offset = REENCRYPTION_SPM_OFFSET;
        global_dma_id += 1;
        dma_id = global_dma_id;
        spm_copy_to_local(child_dram_addr, child_spm_offset, dma_id);
      }
    }
    spm_wait(dma_id);
    if (do_verify) {
      verify_one_height_with_parent_counter(child_spm_offset, old_vals[i], global_mac_req_id, dma_id, child_dram_addr);
      mac_wait(global_mac_req_id, 0);
      global_mac_req_id += 1;
    }

    update_tag_with_parent_counter(child_spm_offset, new_base, global_mac_req_id, dma_id, child_dram_addr);
    mac_wait(global_mac_req_id, 0);
    global_mac_req_id += 1;
    if (!light_info.hit) {
      if (temp_idx >= 0) dirty_temp_entry_by_index(temp_idx);
      else spm_write_back(child_spm_offset, child_dram_addr, 0);
    }
  }

  counter_set_all_to_base_zcc(node_spm_offset, new_base);
  return global_mac_req_id;
}


static inline void update_one_height_lazy(spm_offset_t child_spm_offset, spm_offset_t parent_spm_offset, uint64_t node_index,
  bool update_counter, uint32_t mac_req_id, dma_id_t dma_id,
  dram_addr_t dram_addr) {
  int hart_id = -1;
  asm volatile("csrr %0, mhartid" : "=r"(hart_id));
  spm_wait(dma_id);

  uint64_t mac_req = mac_req_id;
  if (update_counter) {
    unsigned idx = (unsigned)(node_index % MINOR_COUNTER_COUNT);
    uint64_t new_counter = 0;
    if (!counter_try_increment(child_spm_offset, idx, &new_counter)) {
      int start_level = -1;
      for (int l = 0; l < HEIGHT; l++) {
        dram_addr_t base = level_base[l + 1];
        dram_addr_t next_base = (l < HEIGHT - 1) ? level_base[l + 2] : UINT64_MAX;
        if (dram_addr >= base && dram_addr < next_base) {
          start_level = l;
          break;
        }
      }
      if (start_level == HEIGHT - 1) {
        mac_req = reencryption_lazy(dram_addr, child_spm_offset);
      } else {
        mac_req = recalc_tag_lazy(dram_addr, child_spm_offset, start_level, node_index);
      }
      over_flow_count += 1;
    }
  }

  mac_init(mac_req, hart_id, 0);
  uint64_t parent_counter = 0;
  if (parent_spm_offset == 0) {
    parent_counter = spm_ld64(0) & COUNTER_EFFECTIVE_MASK;
  } else {
    parent_counter = counter_get_effective(parent_spm_offset, parent_counter_slot(node_index));
  }
  mac_absorb_counter56(parent_counter, dma_id, hart_id);
  mac_buffer_set(child_spm_offset, dma_id, hart_id);
  mac_update(0, 447, hart_id);
  mac_input_core(dram_addr, hart_id);
  mac_digest(child_spm_offset + 56, dma_id, hart_id);
}

static inline void evicted_node_update(dram_addr_t old_addr, spm_offset_t old_spm) {
    int hartid;
    asm volatile(
        "csrr %0, mhartid"
        : "=r"(hartid)
    );
  int v_level = -1; // Victimのレベル (0=Root)
  dram_addr_t v_level_base_addr = 0;

  for (int l = 0; l < HEIGHT; l++) {
    dram_addr_t base = level_base[l+1];
    if (l < HEIGHT - 1){
      dram_addr_t next_base = level_base[l+2];
      if (old_addr >= base && old_addr < next_base){
          v_level = l;
          v_level_base_addr = base;
          break;
      }
    } else {
      v_level = l;
      v_level_base_addr = base;
    }
  }
  // 何個めのブロックか
  dram_addr_t v_index = (old_addr - (v_level_base_addr))/ 64 * MINOR_COUNTER_COUNT;
  uint64_t path_indecis[HEIGHT] = {0};
  spm_offset_t spm_offset_array[HEIGHT] = {0};
  dram_addr_t dram_addr_array[HEIGHT] = {0};
  dma_id_t wait_dma_id[HEIGHT] = {0};
  bool loaded[HEIGHT] = {0};
  index_t way_index = 0;
  long load_start_index = 0;
  path_indecis[v_level] = v_index;
  dram_addr_array[v_level] = old_addr;
  spm_offset_array[v_level] = old_spm;
  dma_id_t tmp_id = global_dma_id;
  wait_dma_id[v_level] = tmp_id;
  for(long i = v_level - 1; i>=0;i--){
      uint64_t index = v_index >> (ARTY_LOG2 * (v_level - i));
      path_indecis[i] = index;
      dram_addr_t dram_addr = index / MINOR_COUNTER_COUNT * 64 + level_base[i+1];
      dram_addr_array[i] = dram_addr;
      light_tag_info_t info = light_tag_check(dram_addr);
      if (info.hit){
        long set_index = get_cache_tree_set_index(dram_addr);
        way_index = info.way;
        spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way_index);
        update_lru_on_access(set_index, way_index);
        clearParentUpdated(set_index, way_index);
        set_block_dirty(set_index, way_index);
        wait_dma_id[i] = global_dma_id;
        spm_offset_array[i] = spm_offset;
        load_start_index = i + 1;
        break;
      } else {
        long idx = find_temp_entry(dram_addr);
        spm_offset_t spm_offset;
        if (idx < 0){
          spm_offset = pop_temp_buffer();
          idx = alloc_temp_entry(dram_addr, spm_offset);
          dirty_temp_entry_by_index(idx);
          global_dma_id += 1;
          uint64_t tmp_id = global_dma_id;
          spm_copy_to_local(dram_addr, spm_offset,  tmp_id);
          loaded[i] = true;
          spm_offset_array[i] = spm_offset;
          wait_dma_id[i] = tmp_id;
        } else {
          spm_offset = get_temp_spm_offset(idx);
          dirty_temp_entry_by_index(idx);
          wait_dma_id[i] = global_dma_id;
          spm_offset_array[i] = spm_offset;
        }
      }
  }
AFTER_PATH_CHECK_EVICTION:
  uint64_t verify_end = read_instret();
  uint64_t mac_req_id = 0;
  // v_levelからキャッシュヒットしたところまでを検証
  for (long i = v_level-1;i>=load_start_index;i--){
    spm_offset_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    dma_id_t need_id = (i == 0) ? wait_dma_id[0] : wait_dma_id[i-1];
    mac_req_id = global_mac_req_id;
  #ifdef DUMP
    lock_print();
    printf("Core %d Verification during eviction height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, i, spm_offset_array[i], parent_spm, path_indecis[i], need_id);
    printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[i], mac_req_id);
        // printf("  parent dram_addr=%016llx\n", (i == 0) ? 0 : dram_addr_array[i-1]);
    unlock_print();
  #endif
    verify_one_height_lazy(spm_offset_array[i], parent_spm, path_indecis[i], mac_req_id,need_id, dram_addr_array[i]);
    global_mac_req_id += 1;
  }
  if (mac_req_id > 0){
    mac_wait(mac_req_id, hartid);
  }
  if (load_start_index == 0){
    // rootノードの更新
    uint64_t root = spm_ld64(0);
    root += 1;
    spm_sd64(0, root);
  } else {
    uint64_t start_level = load_start_index - 1;
    unsigned minor_idx = (unsigned)(path_indecis[start_level] % MINOR_COUNTER_COUNT);
    uint64_t new_counter = 0;
    if (!counter_try_increment(spm_offset_array[start_level], minor_idx, &new_counter)) {
      if (start_level == HEIGHT - 1) {
        reencryption_lazy(dram_addr_array[start_level], spm_offset_array[start_level]);
      } else {
        recalc_tag_lazy(dram_addr_array[start_level], spm_offset_array[start_level], start_level, path_indecis[start_level]);
      }
      over_flow_count += 1;
    }
  }
  // 木の更新：ルートからv_levelまで降りていく
  for (uint64_t i=load_start_index;i<=v_level;i++){
    spm_offset_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    dma_id_t need_id = (i == 0) ? wait_dma_id[0] : wait_dma_id[i-1];
    mac_req_id = global_mac_req_id;
    #ifdef DUMP
    lock_print();
    printf("Core %d Update during eviction height %d spm_offset=%016llx parent_spm=%016llx path_index=%016llx need_id=%d\n", hartid, i, spm_offset_array[i], parent_spm, path_indecis[i], need_id);
    printf("  dram_addr=%016llx mac_req_id %d\n", dram_addr_array[i], mac_req_id);
        // printf("  parent dram_addr=%016llx\n", (i == 0) ? 0 : dram_addr_array[i-1]);
    unlock_print();
    #endif
    if (i == v_level){
      // 最後はカウンター更新なし
      update_one_height_lazy(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], false,mac_req_id, wait_dma_id[i], dram_addr_array[i]);
    } else {
      update_one_height_lazy(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], true,mac_req_id, wait_dma_id[i], dram_addr_array[i]);
    }
    global_mac_req_id += 1;
  }
  if (mac_req_id > 0){
    mac_wait(mac_req_id, hartid);
  }
  // temp領域の解放
  for (int i = v_level - 1;i>=load_start_index;i--){
    dram_addr_t dram_addr = dram_addr_array[i];
    long idx = find_temp_entry(dram_addr);
    if (idx == -1){
        printf("Error: temp entry still exists for addr=%016llx\n", dram_addr);
        exit(1);
    }
    spm_offset_t temp_spm = get_temp_spm_offset(idx);
    if (loaded[i]){
      spm_write_back(temp_spm, dram_addr,  0);
      long ret = push_temp_buffer(temp_spm);
      if (ret != 0){
        printf("Error: invalidate temp entry failed for addr=%016llx idx=%ld\n", dram_addr,idx);
        exit(1);
      }
      invalidate_temp_entry_by_index(idx);
    }
  }
  return;
}

static inline void swapp_dram_addr(dram_addr_t dram_addr,bool is_leaf){
  int hartid;
  asm volatile(
      "csrr %0, mhartid"
      : "=r"(hartid)
  );
  long idx = find_temp_entry(dram_addr);
  if (idx < 0){
    return;
  }
  spm_offset_t temp_spm = get_temp_spm_offset(idx);
  index_t set_index = get_cache_tree_set_index(dram_addr);
  light_tag_info_t light_info = light_tag_check_set(set_index, dram_addr);
  if (light_info.way < 0){
      light_info.way = get_victim_way(set_index);
  } else {
      set_block_valid(set_index, light_info.way);
  }
  spm_offset_t old_spm = get_cache_block_spm_offset(set_index, light_info.way);
  bool mac_updated = is_mac_updated(set_index, light_info.way);
  bool temp_dirty = is_dirty_temp_entry_by_index(idx);
  dram_addr_t old_dram_addr = get_block_addr(set_index, light_info.way);
  bool cache_dirty = is_block_dirty(set_index, light_info.way);
  swapp_temp_cache(dram_addr, temp_spm, temp_dirty, light_info.way);
  long ret = invalidate_temp_entry_by_index(idx);
  if (is_leaf && temp_dirty){
    clearParentUpdated(set_index, light_info.way);
  } else {
    setParentUpdated(set_index, light_info.way);
  }
  asm volatile("mac_update_tag:");
  if (!mac_updated){
    evicted_node_update(old_dram_addr, old_spm);
    // spm_write_back(old_spm, old_dram_addr,  0);
  } 
  if (cache_dirty){
    spm_write_back(old_spm, old_dram_addr,  0);
  }
  ret = push_temp_buffer(old_spm);
  #ifdef DUMP
  lock_print();
  printf("Core %d swapping cache block addr=%016llx spm_offset %lx S:%ld W:%ld old spm %lx\n",hartid, dram_addr, temp_spm, set_index, light_info.way, old_spm);
  unlock_print();
  #endif
  return;
}


void Authentication(dram_addr_t request_addr, uint32_t req_id){
  // データのコピー
  uint64_t start_time = read_instret();
  // HEIGHT-1がリーフ、0が高さ1
  uint64_t path_indecis[HEIGHT];
  spm_offset_t spm_offset_array[HEIGHT];
  dram_addr_t dram_addr_array[HEIGHT];
  long hit_index = HEIGHT;
  dma_id_t wait_dma_id[HEIGHT];
  index_t way_index = 0;
  // パス上のノードのタグチェックを行う
  uint64_t tag_check_start = read_instret();
  uint64_t index = (request_addr - PROTECTION_BASE) / 64;
  for(uint64_t i=0; i<HEIGHT; ++i){
      path_indecis[i] = index;
      dram_addr_t dram_addr = index / MINOR_COUNTER_COUNT * 64 + level_base[HEIGHT - i];
      index /= MINOR_COUNTER_COUNT;
      dram_addr_array[i] = dram_addr;
      long set_index = get_cache_tree_set_index(dram_addr);
      light_tag_info_t info = light_tag_check_set(set_index, dram_addr);
      if (info.hit){
        hit_index = i;
        spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, info.way);
        update_lru_on_access(set_index, info.way);
        spm_offset_array[i] = spm_offset;
        way_index = info.way;
        wait_dma_id[i] = global_dma_id;
        if (i == 0){
          set_block_dirty(set_index, way_index);
          clearParentUpdated(set_index, way_index);
        }
        break;
      } else {
        global_dma_id += 1;
        wait_dma_id[i] = global_dma_id;
        spm_offset_t spm_offset = pop_temp_buffer();
        spm_offset_array[i] = spm_offset;
        long temp_idx = alloc_temp_entry(dram_addr, spm_offset);
        spm_copy_to_local(dram_addr, spm_offset, global_dma_id);
        if (i == 0){
          dirty_temp_entry_by_index(temp_idx);
        }
      }
  }
  uint64_t tag_check_end = read_instret();
  uint64_t verify_start = read_instret();
  uint64_t mac_req_id = 0;
  for (long i = 0;i<hit_index;i++){
    spm_offset_t parent_spm = (i == HEIGHT - 1) ? 0 : spm_offset_array[i+1];
    dma_id_t need_id = (i == HEIGHT - 1) ? wait_dma_id[HEIGHT - 1] : wait_dma_id[i+1];
    mac_req_id = global_mac_req_id;
    verify_one_height_lazy(spm_offset_array[i], parent_spm, path_indecis[i], mac_req_id,need_id, dram_addr_array[i]);
    global_mac_req_id += 1;
  }
  // 一時的なルートノードのアップデート
  if (mac_req_id > 0){
    mac_wait(mac_req_id,0);
  }
  uint64_t verify_end = read_instret();
  uint64_t update_start = read_instret();
  // リーフのみを更新
  unsigned minor_idx = (unsigned)(path_indecis[0] % MINOR_COUNTER_COUNT);
  uint64_t effective_counter = 0;
  if (!counter_try_increment(spm_offset_array[0], minor_idx, &effective_counter)) {
    reencryption_lazy(dram_addr_array[0], spm_offset_array[0]);
    over_flow_count += 1;
    effective_counter = counter_get_effective(spm_offset_array[0], minor_idx);
  }
  uint64_t update_end = read_instret();
  uint64_t set_seed_s = read_instret();
  set_seed(effective_counter, 0, request_addr);
  uint64_t set_seed_e = read_instret();
  uint64_t datamac_dma = read_instret();
  dram_addr_t datamacblock_addr = get_datamacblock_addr(request_addr);
  index_t set_index = get_cache_mac_index(datamacblock_addr);
  light_tag_info_t light_info = light_tag_check_set(set_index, datamacblock_addr);
  spm_offset_t spm_offset;
  dma_id_t tag_id = global_dma_id;
  bool cache_dirty = false;
  if (light_info.hit){
    spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
    set_block_dirty(set_index, light_info.way);
  } else {
    global_dma_id += 1;
    tag_id = global_dma_id;
    if (light_info.way == -1){
      light_info.way = get_victim_way(set_index);
      bool dirty = is_block_dirty(set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      if (dirty){
        cache_dirty = true;
        dram_addr_t old_block_addr = get_block_addr(set_index, light_info.way);
        spm_write_back(spm_offset, old_block_addr, 0);
      }
    } else {
      set_block_valid(set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    }
    spm_copy_to_local(datamacblock_addr, spm_offset, tag_id);
    set_block_addr(set_index, light_info.way, datamacblock_addr);
    set_block_dirty(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
  }
  uint64_t datamac_dma_e = read_instret();
  uint64_t xor_start_ = read_instret();
  while(AES_START_REG);
  xor_start(true, false,req_id,DATA_SPM_OFFSET);
  uint64_t xor_end = read_instret();
  // --- 手順3: MAC計算 ---
  uint64_t mac_start = read_instret();
  mac_init(global_mac_req_id,0,1);
  mac_buffer_set(DATA_SPM_OFFSET, tag_id,0); 
  mac_update(0, 511,0);
  mac_absorb_counter56(effective_counter, tag_id, 0);
  mac_input_core(request_addr,0);
  mac_digest(spm_offset + ((request_addr - PROTECTION_BASE) / 64) % 8 * 8, tag_id,0);
  uint64_t mac_end = read_instret();
  uint64_t write_back_s = read_instret();
  spm_write_back(DATA_SPM_OFFSET, request_addr, 0);
  uint64_t write_back_e = read_instret();
  uint64_t response_start = read_instret();
  axim_write_return(req_id);
  mac_wait(global_mac_req_id,0);
  global_mac_req_id += 1;
  uint64_t response_end = read_instret();
    // スワップ
  // for (long i = 0;i<hit_index;i++){
  //   dram_addr_t dram_addr = dram_addr_array[i];
  //   bool is_leaf = (i == 0);
  //   swapp_dram_addr(dram_addr,is_leaf);
  // }
  uint64_t swap_start = read_instret();
  for (uint64_t i = 0;i<hit_index;i++){
    dram_addr_t dram_addr = dram_addr_array[i];
    long idx = find_temp_entry(dram_addr);
    spm_offset_t temp_spm = spm_offset_array[i];
    index_t set_index = get_cache_tree_set_index(dram_addr);
    light_tag_info_t light_info = light_tag_check_set(set_index, dram_addr);
    if (light_info.way < 0){
        light_info.way = get_victim_way(set_index);
    } else {
        set_block_valid(set_index, light_info.way);
    }
    spm_offset_t old_spm = get_cache_block_spm_offset(set_index, light_info.way);
    bool mac_updated = is_mac_updated(set_index, light_info.way);
    bool temp_dirty = is_dirty_temp_entry_by_index(idx);
    dram_addr_t old_dram_addr = get_block_addr(set_index, light_info.way);
    bool cache_dirty = is_block_dirty(set_index, light_info.way);
    swapp_temp_cache(dram_addr, temp_spm, temp_dirty, light_info.way);
    invalidate_temp_entry_by_index(idx);
    if (i == 0 && temp_dirty){
      clearParentUpdated(set_index, light_info.way);
    } else {
      setParentUpdated(set_index, light_info.way);
    }
    if (!mac_updated){
      evicted_node_update(old_dram_addr, old_spm);
    } 
    if (cache_dirty){
      spm_write_back(old_spm, old_dram_addr,  0);
    }
    push_temp_buffer(old_spm);
  }
  uint64_t swap_end = read_instret();
}


void Verification(dram_addr_t request_addr, uint64_t req_id){
  uint64_t start_time = read_instret();
  global_dma_id += 1;
  dma_id_t data_id = global_dma_id;
  spm_copy_to_local(request_addr, DATA_SPM_OFFSET, data_id);
  // HEIGHT-1がリーフ、0が高さ1
  spm_offset_t spm_offset_array[HEIGHT];
  dram_addr_t dram_addr_array[HEIGHT];
  uint64_t hit_index = HEIGHT;
  dma_id_t wait_dma_id[HEIGHT];
  uint64_t tag_path_check_s = read_instret();
  index_t index = (request_addr - PROTECTION_BASE) / 64;
  index_t v_i = index;
  for (long i = 0;i<HEIGHT;i++){
    dram_addr_t dram_addr = index / MINOR_COUNTER_COUNT * 64 + level_base[HEIGHT - i];
    index = index / MINOR_COUNTER_COUNT;
    dram_addr_array[i] = dram_addr;
    index_t set_index = get_cache_tree_set_index(dram_addr);
    light_tag_info_t info = light_tag_check_set(set_index, dram_addr);
    if (info.hit){
      hit_index = i;
      index_t way_index = info.way;//get_way(set_index,dram_addr);
      update_lru_on_access(set_index, way_index);
      spm_offset_t spm_offset = get_cache_block_spm_offset(set_index, way_index);
      spm_offset_array[i] = spm_offset;
      wait_dma_id[i] = global_dma_id;
      break;
    } else {
      global_dma_id += 1;
      wait_dma_id[i] = global_dma_id;
      spm_offset_t spm_offset = pop_temp_buffer();
      spm_offset_array[i] = spm_offset;
      alloc_temp_entry(dram_addr, spm_offset);
      spm_copy_to_local(dram_addr, spm_offset, global_dma_id);
    }
  }
  uint64_t tag_path_check_e = read_instret();
  // SPMに当該MACブロックがあるかを確認。なければコピー。
  uint64_t datamac_dma_s = read_instret();
  dram_addr_t datamacblock_addr = get_datamacblock_addr(request_addr);
  index_t set_index = get_cache_set_index(datamacblock_addr);
  dma_id_t tag_id = global_dma_id;
  spm_offset_t spm_offset;
  light_tag_info_t light_info = light_tag_check(datamacblock_addr);
  bool cache_dirty = false;
  if (light_info.hit){
    spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
  } else {
    tag_id += 1;
    global_dma_id += 1;
    if (light_info.way == -1){
      light_info.way = get_victim_way(set_index);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
      bool dirty = is_block_dirty(set_index, light_info.way);
      if (dirty){
        dram_addr_t old_block_addr = get_block_addr(set_index, light_info.way);
        spm_write_back(spm_offset, old_block_addr, 0);
        cache_dirty = true;
      }
    } else {
      set_block_valid(set_index, light_info.way);
      spm_offset = get_cache_block_spm_offset(set_index, light_info.way);
    }
    spm_copy_to_local(datamacblock_addr, spm_offset, tag_id);
    set_block_addr(set_index, light_info.way, datamacblock_addr);
    clear_block_dirty(set_index, light_info.way);
    update_lru_on_access(set_index, light_info.way);
  }
  uint64_t datamac_dma_e = read_instret();
  // exit(1);
  uint64_t verify_s = read_instret();
  uint64_t mac_req_id = 0;
  for (uint64_t i = 0;i<hit_index;i++){
    mac_req_id = global_mac_req_id;
    if (i == HEIGHT - 1){
      verify_one_height_lazy_root(spm_offset_array[i], global_mac_req_id, wait_dma_id[HEIGHT - 1], dram_addr_array[i]);
    } else {
      verify_one_height_lazy(spm_offset_array[i], spm_offset_array[i+1], v_i, global_mac_req_id, wait_dma_id[i+1], dram_addr_array[i]);
    }
    global_mac_req_id += 1;
    v_i = v_i / MINOR_COUNTER_COUNT;
  }
  uint64_t verify_e = read_instret();
  uint64_t wait_s = read_instret();
  if (hit_index > 0){
    dma_id_t wait_id = wait_dma_id[0];
    spm_wait(wait_id);  
  }
  uint64_t wait_e = read_instret();
  uint64_t set_seed_s = read_instret();
  spm_offset_t base_spm_offset = spm_offset_array[0];

  uint64_t counter_ext_s = read_instret();
  unsigned minor_idx = (unsigned)((request_addr / 64) % MINOR_COUNTER_COUNT);
  uint64_t effective_counter = counter_get_effective(base_spm_offset, minor_idx);
  uint64_t counter_ext_e = read_instret();
  set_seed(effective_counter, 0, request_addr);
  uint64_t set_seed_e = read_instret();
  uint64_t datamac_s = read_instret();
  mac_init(global_mac_req_id,0,1);
  mac_buffer_set(DATA_SPM_OFFSET,data_id,0);
  mac_update(0, 511,0);
  mac_absorb_counter56(effective_counter, wait_dma_id[0], 0);
  mac_input_core(request_addr,0);
  spm_offset_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
  mac_result_compare(spm_offset + dmac_byte_offset, tag_id,0);
  uint64_t datamac_e = read_instret();
  uint64_t xor_s = read_instret();
  while(AES_START_REG);
  uint64_t data_wait_s = read_instret();
  spm_wait(data_id);
  uint64_t data_wait_e = read_instret();
  xor_start(false, true,req_id,DATA_SPM_OFFSET);
  uint64_t xor_e = read_instret();
  uint64_t response_s = read_instret();
  uint64_t mac_wait_s = read_instret();
  mac_wait(global_mac_req_id,0);
  uint64_t mac_wait_e = read_instret();
  global_mac_req_id += 1;
  axim_read_return(req_id);
  uint64_t response_e = read_instret();
  uint64_t start_swapp_time = read_instret();
  for (uint64_t i = 0;i<hit_index;i++){
    dram_addr_t dram_addr = dram_addr_array[i];
    long idx = find_temp_entry(dram_addr);
    spm_offset_t temp_spm = spm_offset_array[i];
    index_t set_index = get_cache_tree_set_index(dram_addr);
    light_tag_info_t light_info = light_tag_check_set(set_index, dram_addr);
    if (light_info.way < 0){
        light_info.way = get_victim_way(set_index);
    } else {
        set_block_valid(set_index, light_info.way);
    }
    spm_offset_t old_spm = get_cache_block_spm_offset(set_index, light_info.way);
    bool mac_updated = is_mac_updated(set_index, light_info.way);
    bool temp_dirty = is_dirty_temp_entry_by_index(idx);
    dram_addr_t old_dram_addr = get_block_addr(set_index, light_info.way);
    bool cache_dirty = is_block_dirty(set_index, light_info.way);
    swapp_temp_cache(dram_addr, temp_spm, temp_dirty, light_info.way);
    invalidate_temp_entry_by_index(idx);
    if (i == 0 && temp_dirty){
      clearParentUpdated(set_index, light_info.way);
    } else {
      setParentUpdated(set_index, light_info.way);
    }
    if (!mac_updated){
      evicted_node_update(old_dram_addr, old_spm);
    } 
    if (cache_dirty){
      spm_write_back(old_spm, old_dram_addr,  0);
    }
    push_temp_buffer(old_spm);
  }
  uint64_t swapp_end_time = read_instret();
}

int main(void){
  if (MINOR_COUNTER_COUNT != COUNTER_COUNT_ZCC || PROTECTION_SIZE_GRAIN != 64) {
    printf("Error: var_seq_zcc requires MINOR_COUNTER_COUNT=128 and PROTECTION_SIZE_GRAIN=64.\n");
    return 1;
  }
  // loadをいじる
  SPM_SIZE_REG = 64;
  for (uint64_t i=0; i<512; i++){
    spm_sd64(i*8, 0); 
  }
  // rootノードの初期化
  spm_sd64(0,1);
  init_cache_system();
  temp_system_init(CACHE_DATA_SPM_BASE + CACHE_SETS * CACHE_WAYS * 64);
  // dma_id_t dma_id = 0;
  int total = 0;
  for (int i = 0;i < HEIGHT+1;i++){
    level_base[i] = calculate_level_base_addr(i) + COUNTER_BASE;
  }
  while(1){
    for(;;){
      if(AXIM_STATUS_REG & 1) break; // リクエストが来るまで待つ
    }
    bool is_write = (AXIM_STATUS_REG & 2) != 0;
    dram_addr_t addr = AXIM_REQ_ADDR_REG;
    uint64_t req_id = AXIM_REQ_ID_REG;
    total += 1;
    if (total % 10000 == 0){
      printf("Processed %d requests\n", total);
      instret_dump = true;
    } else {
      instret_dump = false;
    }
    if ((addr - PROTECTION_BASE) >= (16ULL * 1024 * 1024 * 1024)){ // 16GBを超えないようにしたい
      printf("Error: Address out of range: %016llx\n", addr);
      exit(1);
    }
    if (addr == 0xFFFFFFFFFFFFFFFF){
      return 0;
    } else {
      if(is_write){ // writeリクエスト
        Authentication(addr,req_id);
      } else {
        Verification(addr,req_id);
      }
    }
  }
}
