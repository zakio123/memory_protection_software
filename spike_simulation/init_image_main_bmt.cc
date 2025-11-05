#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <array>
#include <string>
#include <fstream>
#include <iostream>
#include <cassert>
#include "aes128.h"
#include "mem_layout_bmt.h"
static constexpr uint64_t FNV_PRIME = 0x100000001b3;
static constexpr uint64_t FNV_OFFSET_BASIS = 0xcbf29ce484222325;
// ===== ユーティリティ =====
// static void die(const char* m){ std::cerr << m << std::endl; std::exit(1); }

static inline uint64_t div_ceil_u64(uint64_t a, uint64_t b){
  return (a + b - 1) / b;
}


// ===== データタグMAC（要置換） =====
// 仕様：cipher64B + 1B(counter) をMAC
// ここではデフォルトFNV-1a: tag = FNV(cipher64)→FNV(minor_byte)
static inline uint64_t compute_data_tag(uint8_t cipher64[64], uint8_t counter_byte){
    uint64_t mac = 0;
    for (int i=0;i<64;++i) {
        mac ^= cipher64[i];
        mac *= FNV_PRIME;
    }
    mac ^= counter_byte;
    mac *= FNV_PRIME;
    return mac;
}

// ===== ツリーノードMAC（要置換） =====
// ノード先頭56B（major+minors+pad）を基本データとし、
// 親64B/子インデックスを混ぜる例。rootは親無し/child=-1。

uint64_t compute_node_mac(const uint64_t* child_nodes){
  uint64_t mac = 0;
  // 親ノードカウンターを混ぜる
  for (int i=0;i<8;++i) {
    for (int j =0;j<8;j++){
      mac ^= (uint8_t)((child_nodes[j] >> (8*i)) & 0xFF);
      mac *= FNV_PRIME;
    }
  }
  return mac;
}

// ===== 64B AES-CTR (16B×4) =====
struct CtrDeriver {
  // set_seed(major, minor, addr) 相当の 128b ブロックを生成する例
  aes::Block make_ctr_block(uint64_t block_addr, uint64_t major, uint8_t minor, int sub) const {
    aes::Block iv{};
    // [0..7]=major(LE), [8]=minor, [9]=sub, [10..15]=addr下位48bit(LE)
    uint64_t addr = block_addr + 16 * sub;
    uint64_t seed_0 = addr + major;
    uint64_t seed_1 = addr + (minor);
    for(int i=0;i<8;++i) iv[i] = (uint8_t)((seed_0 >> (8*i)) & 0xFF);
    for(int i=0;i<8;++i) iv[8+i] = (uint8_t)((seed_1 >> (8*i)) & 0xFF);
    return iv;
  }
};
static void encrypt64_AES_CTR(const aes::AES128& aes,
                              uint8_t* dst64,
                              uint8_t* src64,
                              uint64_t block_addr,
                              uint64_t major, uint8_t minor,
                              const CtrDeriver& der={})
{
  for(int k=0;k<4;++k){
    aes::Block ctr = der.make_ctr_block(block_addr, major, minor, k);
    aes::Block ks  = aes.encrypt_block(ctr);
    for(int i=0;i<16;++i) dst64[k*16+i] = src64[k*16+i] ^ ks[i];
  }
}
static void encrypt64_AES_CTR_tls(const aes::AES128& aes_tls,
                                  uint8_t* dst64, const uint8_t* src64,
                                  uint64_t block_addr, uint64_t major, uint8_t minor,
                                  const CtrDeriver& der = {})
{
  for(int k=0;k<4;++k){
    aes::Block ctr = der.make_ctr_block(block_addr, major, minor, k);
    aes::Block ks  = aes_tls.encrypt_block(ctr);
    for(int i=0;i<16;++i) dst64[k*16+i] = src64[k*16+i] ^ ks[i];
  }
}
int main(int argc, char** argv){
  const std::string out_path = argv[1];
// 暗号文を入れるvector
    const uint64_t n_blocks = PROTECTION_SIZE / BLK64;
    std::vector<uint8_t> cipher(n_blocks*BLK64, 0);
  // AES鍵
    static const aes::Block hwkey = {
    0x2b,0x7e,0x15,0x16,0x28,0xae,0xd2,0xa6,
    0xab,0xf7,0x15,0x88,0x09,0xcf,0x4f,0x3c
  };
  // 暗号化
    const uint64_t init_major = 0;
    const uint8_t  init_minor = 1;
    CtrDeriver der;
  #pragma omp parallel
  {
    // スレッドローカルAES（鍵展開を各スレッドで）
    aes::AES128 aes_tls(hwkey);

    #pragma omp for schedule(static)
    for (uint64_t b = 0; b < n_blocks; ++b) {
        // std::cout << "Processing block " << b << std::endl;
      uint64_t block_addr = PROTECTION_BASE + (b * BLK64);
      // テスト用のプレーン（パターン値）：競合なし
      uint8_t plain[BLK64];
      for (int i=0;i<(int)BLK64;++i) plain[i] = (uint8_t)(b);
      encrypt64_AES_CTR_tls(aes_tls,
        &cipher[b*BLK64], plain,
        block_addr, init_major, init_minor, der);
    }
  }
  std::cout << "[Info] Encryption completed for " << n_blocks << " blocks." << std::endl;

  // データタグ領域（64Bで8タグ=8*8B）
  const uint64_t n_tag_blocks = div_ceil_u64(n_blocks, TAGS_PER_BLOCK);
  std::vector<uint8_t> tags(n_tag_blocks * TAG_BLOCK, 0);
  // タグ計算（ダミー）：各64B暗号文と counter(=1) から 8B
  #pragma omp parallel for schedule(static) 
    for(uint64_t b=0;b<n_blocks;++b){
        uint8_t* ciph = &cipher[b*BLK64];
        uint64_t tag = compute_data_tag(ciph, /*minor*/init_minor);
        uint64_t tag_blk_index = b / TAGS_PER_BLOCK;
        uint64_t tag_slot      = b % TAGS_PER_BLOCK;
        uint8_t*  dst = &tags[tag_blk_index*TAG_BLOCK + tag_slot*TAG_BYTES];
        std::memcpy(dst, &tag, 8);
    }
  
  // マークルツリー領域（全ノード数）
//   mac = 8B
//   一番最初だけ親ノードが64bitde1
  uint64_t total_nodes = ((1ULL << (3ULL * (HEIGHT))) - 1ULL) / (ARY - 1ULL);
  uint64_t nodes[8];
  for (int i=0;i<8;++i) {
    if (i==0){
      nodes[i] = 0;
    } else if (i <5){
      nodes[i] = 0x0101010101010101;
    } else {
      nodes[i] = 0;
    }
  };
  std::vector<uint8_t> counters(COUNTER_SIZE, 0);
  for (int i=0;i<(COUNTER_SIZE / 64);++i){
    std::memcpy(&counters[i*64], nodes, 64);
  }
  std::vector<uint8_t> tree(total_nodes*NODE, 0);
  uint64_t mac;
  uint64_t mac_array[HEIGHT];
  uint64_t acc_nodes = 0;
  for (int i=0;i<HEIGHT;++i){
    mac = compute_node_mac(nodes);
    mac_array[i] = mac;
    std::cout << "[Info] level=" << i << " mac=" << std::hex << mac << std::dec << std::endl;
    // ノード書き込み
    for (int j=0;j<8;j++){
      nodes[j] = mac;
    }
  }
  // ノード配置
  uint64_t offset = 0;
  for (int level=0;level<(int)HEIGHT;++level){
    uint64_t n_nodes_level = (1ULL << (3ULL * level))*64;
    for (uint64_t n=0;n<n_nodes_level / 8;++n){
      // ノード本体（major, minors, pad）はゼロ初期化済み
      // MAC書き込み
      std::memcpy(&tree[offset + n * 8], &mac_array[HEIGHT-level-1], 8);
    }
    std::cout << "[Info] level=" << level << " nodes=" << mac_array[HEIGHT-level-1] << std::endl;
    std::cout << "[Info] offset=" << offset << " size=" << n_nodes_level << std::endl;
    offset += n_nodes_level;

  }
  // セクション配置（64Bアライン）
  auto align64 = [](uint64_t x){ return (x + 63ull) & ~63ull; };
  uint64_t off_data = 0;
  uint64_t sz_data  = cipher.size();
  uint64_t off_tag  = align64(off_data + sz_data);
  uint64_t sz_tag   = tags.size();
  uint64_t off_ctr = align64(off_tag + sz_tag);
  uint64_t sz_ctr  = counters.size();
  uint64_t off_tree = align64(off_ctr + sz_ctr);
  uint64_t sz_tree  = tree.size();
  uint64_t out_sz   = off_tree + sz_tree;
  // uint64_t total_sz = out_sz + sz_data;
  std::vector<uint8_t> image(out_sz, 0);
  std::memcpy(&image[off_data], cipher.data(), sz_data);
  std::memcpy(&image[off_tag],  tags.data(), sz_tag);
  std::memcpy(&image[off_ctr], counters.data(), sz_ctr);
  std::memcpy(&image[off_tree], tree.data(), sz_tree);
  // 出力
  {
    std::ofstream fo(out_path, std::ios::binary);
    // if(!fo) die("cannot open out.img");
    fo.write(reinterpret_cast<const char*>(image.data()), image.size());
  }

  std::cout << "[OK] image=" << out_path
            << " data_sz=" << sz_data
            << " tag_sz="  << sz_tag
            << " tree_sz=" << sz_tree
            << " blocks="  << n_blocks
            << " nodes="   << total_nodes
            << std::endl;
  return 0;
}
