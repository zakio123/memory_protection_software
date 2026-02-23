#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <array>
#include <string>
#include <fstream>
#include <iostream>
#include <algorithm>
#include "aes128.h"
#include "config.h"

static constexpr uint64_t FNV_PRIME = 0x100000001b3ULL;
static constexpr uint64_t FNV_OFFSET_BASIS = 0xcbf29ce484222325ULL;
static constexpr uint64_t COUNTER_BITS = 56;
static constexpr uint64_t COUNTER_MASK = (1ULL << COUNTER_BITS) - 1ULL;

// ZCC layout (same as var_seq_zcc.c)
static constexpr uint32_t ZCC_MAJOR_START = 0;
static constexpr uint32_t ZCC_MAJOR_BITS = 56;
static constexpr uint32_t ZCC_FORMAT_BIT = 56;
static constexpr uint32_t ZCC_CTRSZ_START = 57;
static constexpr uint32_t ZCC_CTRSZ_BITS = 6;
static constexpr uint32_t ZCC_RESERVED_BIT = 63;

static void die(const char* m) {
  std::cerr << m << std::endl;
  std::exit(1);
}

static inline uint64_t div_ceil_u64(uint64_t a, uint64_t b) {
  return (a + b - 1) / b;
}

static inline uint64_t mask_u64(uint32_t width) {
  if (width == 0) return 0;
  if (width >= 64) return UINT64_MAX;
  return (1ULL << width) - 1ULL;
}

static inline void set_bits_le(uint8_t* buf, uint32_t start_bit, uint32_t width, uint64_t value) {
  value &= mask_u64(width);
  for (uint32_t i = 0; i < width; i++) {
    const uint32_t bit_pos = start_bit + i;
    const uint32_t byte_pos = bit_pos >> 3;
    const uint32_t bit_in_byte = bit_pos & 7U;
    const uint8_t bit = (value >> i) & 1U;
    buf[byte_pos] = (buf[byte_pos] & ~(1U << bit_in_byte)) | (bit << bit_in_byte);
  }
}

static inline void init_zcc_node_zero(uint8_t node[64], uint64_t major56) {
  std::memset(node, 0, 64);
  set_bits_le(node, ZCC_MAJOR_START, ZCC_MAJOR_BITS, major56 & COUNTER_MASK);
  set_bits_le(node, ZCC_FORMAT_BIT, 1, 0);               // ZCC
  set_bits_le(node, ZCC_CTRSZ_START, ZCC_CTRSZ_BITS, 56);
  set_bits_le(node, ZCC_RESERVED_BIT, 1, 0);
}

static inline uint64_t compute_data_tag(const uint8_t cipher64[64], uint64_t counter56, uint64_t dram_addr) {
  uint64_t mac = FNV_OFFSET_BASIS;
  for (int i = 0; i < 64; i++) {
    mac ^= cipher64[i];
    mac *= FNV_PRIME;
  }
  // mac_input_core() (command=32) absorbs 8 bytes; counter56 is zero-extended.
  for (int i = 0; i < 8; i++) {
    mac ^= static_cast<uint8_t>((counter56 >> (8 * i)) & 0xFF);
    mac *= FNV_PRIME;
  }
  for (int i = 0; i < 8; i++) {
    mac ^= static_cast<uint8_t>((dram_addr >> (8 * i)) & 0xFF);
    mac *= FNV_PRIME;
  }
  return mac;
}

static inline uint64_t compute_node_mac(const uint8_t node[64], uint64_t parent_counter56, uint64_t dram_addr) {
  uint64_t mac = FNV_OFFSET_BASIS;
  // mac_input_core() (command=32) absorbs 8 bytes; counter56 is zero-extended.
  for (int i = 0; i < 8; i++) {
    mac ^= static_cast<uint8_t>((parent_counter56 >> (8 * i)) & 0xFF);
    mac *= FNV_PRIME;
  }
  for (int i = 0; i < 56; i++) {
    mac ^= node[i];
    mac *= FNV_PRIME;
  }
  for (int i = 0; i < 8; i++) {
    mac ^= static_cast<uint8_t>((dram_addr >> (8 * i)) & 0xFF);
    mac *= FNV_PRIME;
  }
  return mac;
}

struct CtrDeriver {
  aes::Block make_ctr_block(uint64_t block_addr, uint64_t counter56, int sub) const {
    aes::Block iv{};
    uint64_t addr = block_addr + 16ULL * static_cast<uint64_t>(sub);
    uint64_t seed_0 = counter56 & COUNTER_MASK;
    uint64_t seed_1 = addr;
    for (int i = 0; i < 8; i++) iv[i] = (seed_0 >> (8 * i)) & 0xFF;
    for (int i = 0; i < 8; i++) iv[8 + i] = (seed_1 >> (8 * i)) & 0xFF;
    return iv;
  }
};

static void encrypt64_AES_CTR_tls(
    const aes::AES128& aes_tls,
    uint8_t* dst64,
    const uint8_t* src64,
    uint64_t block_addr,
    uint64_t counter56,
    const CtrDeriver& der = {}) {
  for (int k = 0; k < 4; k++) {
    aes::Block ctr = der.make_ctr_block(block_addr, counter56, k);
    aes::Block ks = aes_tls.encrypt_block(ctr);
    for (int i = 0; i < 16; i++) dst64[k * 16 + i] = src64[k * 16 + i] ^ ks[i];
  }
}

int main() {
  if (MINOR_COUNTER_COUNT != 128) {
    die("init_image_main_zcc.cc requires MINOR_COUNTER_COUNT=128");
  }
  if (PROTECTION_SIZE_GRAIN != 64) {
    die("init_image_main_zcc.cc requires PROTECTION_SIZE_GRAIN=64");
  }

  const uint64_t n_blocks = PROTECTION_SIZE / 64;
  std::vector<uint8_t> cipher(n_blocks * 64, 0);

  static const aes::Block hwkey = {
    0x2b,0x7e,0x15,0x16,0x28,0xae,0xd2,0xa6,
    0xab,0xf7,0x15,0x88,0x09,0xcf,0x4f,0x3c
  };

  const uint64_t init_counter56 = 0;
  CtrDeriver der;
  #pragma omp parallel
  {
    aes::AES128 aes_tls(hwkey);
    #pragma omp for schedule(static)
    for (uint64_t b = 0; b < n_blocks; b++) {
      uint64_t block_addr = PROTECTION_BASE + (b * 64);
      uint8_t plain[64];
      for (int i = 0; i < 64; i++) plain[i] = static_cast<uint8_t>(b);
      encrypt64_AES_CTR_tls(aes_tls, &cipher[b * 64], plain, block_addr, init_counter56, der);
    }
  }
  std::cout << "[Info] Encryption completed for " << n_blocks << " blocks.\n";

  const uint64_t n_tag_blocks = div_ceil_u64(n_blocks, 8);
  std::vector<uint8_t> tags(n_tag_blocks * 64, 0);
  #pragma omp parallel for schedule(static)
  for (uint64_t b = 0; b < n_blocks; b++) {
    uint64_t tag = compute_data_tag(&cipher[b * 64], init_counter56, PROTECTION_BASE + b * 64);
    uint64_t tag_blk_index = b / 8;
    uint64_t tag_slot = b % 8;
    std::memcpy(&tags[tag_blk_index * 64 + tag_slot * 8], &tag, 8);
  }
  std::cout << "[Info] Tag blocks: " << n_tag_blocks << "\n";

  uint64_t count_log = 0;
  while ((1ULL << count_log) < MINOR_COUNTER_COUNT) count_log++;
  const uint64_t total_nodes = ((1ULL << (count_log * HEIGHT)) - 1ULL) / (MINOR_COUNTER_COUNT - 1ULL);
  std::vector<uint8_t> tree(total_nodes * 64, 0);
  std::cout << "[Info] Total tree nodes: " << total_nodes << "\n";

  #pragma omp parallel for schedule(static)
  for (uint64_t n = 0; n < total_nodes; n++) {
    uint64_t dram_addr = COUNTER_BASE + n * 64;
    uint8_t node[64];
    init_zcc_node_zero(node, 0);
    uint64_t parent_counter = (n == 0) ? 1 : 0;
    uint64_t mac = compute_node_mac(node, parent_counter, dram_addr);
    std::memcpy(&node[56], &mac, 8);
    std::memcpy(&tree[n * 64], node, 64);
  }

  auto align64 = [](uint64_t x) { return (x + 63ULL) & ~63ULL; };
  uint64_t off_data = 0;
  uint64_t sz_data = cipher.size();
  uint64_t off_tag = align64(off_data + sz_data);
  uint64_t sz_tag = tags.size();
  uint64_t off_tree = align64(off_tag + sz_tag);
  uint64_t sz_tree = tree.size();
  uint64_t out_sz = off_tree + sz_tree;
  std::vector<uint8_t> image(out_sz, 0);
  std::memcpy(&image[off_data], cipher.data(), sz_data);
  std::memcpy(&image[off_tag], tags.data(), sz_tag);
  std::memcpy(&image[off_tree], tree.data(), sz_tree);

  const std::string out_path =
      "out_image_zcc_mcw56_mcc" + std::to_string(MINOR_COUNTER_COUNT) +
      "_height" + std::to_string(HEIGHT) + ".img";
  {
    std::ofstream fo(out_path, std::ios::binary);
    if (!fo) die("cannot open output image");
    fo.write(reinterpret_cast<const char*>(image.data()), out_sz);
  }

  std::cout << "[OK] image=" << out_path
            << " data_sz=0x" << std::hex << sz_data
            << " tag_sz=0x" << sz_tag
            << " tree_sz=0x" << sz_tree << std::dec
            << " blocks=" << n_blocks
            << " nodes=" << total_nodes
            << "\n";
  return 0;
}
