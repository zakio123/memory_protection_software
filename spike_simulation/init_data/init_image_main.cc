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
#include "config.h"

static constexpr uint64_t FNV_PRIME = 0x100000001b3;
static constexpr uint64_t FNV_OFFSET_BASIS = 0xcbf29ce484222325;
// ===== ユーティリティ =====
static void die(const char* m){ std::cerr << m << std::endl; std::exit(1); }

static inline uint64_t div_ceil_u64(uint64_t a, uint64_t b){
  return (a + b - 1) / b;
}
// マイナーカウンターは最大でも16bitという仮定
static void set_minor_val(uint8_t* node_buf, int idx, uint64_t val, int width) {
    // マイナーカウンター領域は 64ビット目 (8バイト目) から開始
    uint64_t start_bit = 64 + (uint64_t)idx * width;
    uint64_t byte_idx = start_bit / 8;
    uint8_t  bit_rem  = start_bit % 8;
    // 値をビット幅でマスク（あふれ防止）
    uint64_t mask = (1ULL << width) - 1;
    uint64_t v = val & mask;
    // 1バイト目への書き込み
    node_buf[byte_idx] |= (uint8_t)(v << bit_rem);
    // 2バイト目にまたがる場合
    if (bit_rem + width > 8) {
        node_buf[byte_idx + 1] |= (uint8_t)(v >> (8 - bit_rem));
    }
}

// ===== データタグMAC（要置換） =====
// 仕様：cipher64B + 1B(counter) をMAC
// ここではデフォルトFNV-1a: tag = FNV(cipher64)→FNV(minor_byte)
static inline uint64_t compute_data_tag(uint8_t cipher64[64], uint16_t counter_byte, uint64_t dram_addr,const int minor_bit_width){
    uint64_t mac = FNV_OFFSET_BASIS;
    for (int i=0;i<64;++i) {
        mac ^= cipher64[i];
        mac *= FNV_PRIME;
    }
    // メジャーカウンターを混ぜる
    for (int i=0;i<8;i++){
      uint8_t byte =0;
      mac ^= byte;
      mac *= FNV_PRIME;
    }
    // マイナーカウンターを混ぜる
    for (int i=0;i<(minor_bit_width+7)/8;i++){
      mac ^= (counter_byte >> (8*i)) & 0xFF;
      mac *= FNV_PRIME;
    }
    // dramアドレスを混ぜる
    for (int i=0;i<8;i++){
      uint8_t byte = (dram_addr >> (8*i)) & 0xFF;
      mac ^= byte;
      mac *= FNV_PRIME;
    }
    return mac;
}

// ===== ツリーノードMAC（要置換） =====
// ノード先頭56B（major+minors+pad）を基本データとし、
// 親64B/子インデックスを混ぜる例。rootは親無し/child=-1。

static inline uint64_t compute_node_mac(uint8_t* node, const uint64_t parent_counter,uint32_t size,uint64_t dram_addr){
    uint64_t mac = FNV_OFFSET_BASIS;
    // 親ノードカウンターを混ぜる
    if (size != 64){
      for (int i=0;i<8;++i) {
        uint8_t byte = 0;
        mac ^= byte;
        mac *= FNV_PRIME;
      }
    }
    for (int i=0;i<(size + 7)/8;++i) {
        mac ^= (uint8_t)((parent_counter >> (8*i)) & 0xFF);
        mac *= FNV_PRIME;
    }
    for (int i=0;i<56;i++){
      mac ^= node[i];
      mac *= FNV_PRIME;
    }
    // dramアドレスを混ぜる
    for (int i=0;i<8;i++){
      uint8_t byte = (dram_addr >> (8*i)) & 0xFF;
      mac ^= byte;
      mac *= FNV_PRIME;
    }
  return mac;
}

// ===== 64B AES-CTR (16B×4) =====
struct CtrDeriver {
  // set_seed(major, minor, addr) 相当の 128b ブロックを生成する例
  aes::Block make_ctr_block(uint64_t block_addr, uint64_t major, uint16_t minor, int sub) const {
    aes::Block iv{};
    // [0..7]=major(LE), [8]=minor, [9]=sub, [10..15]=addr下位48bit(LE)
    uint64_t addr = block_addr + 16 * sub;
    uint64_t seed_0 = major;
    uint64_t seed_1 = (addr) |  ((uint64_t)(minor) << 48);
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
  // const std::string out_path = argv[1];
// 暗号文を入れるvector
    const uint64_t n_blocks = PROTECTION_SIZE / 64;
    std::vector<uint8_t> cipher(n_blocks*64, 0);
  // AES鍵
    static const aes::Block hwkey = {
    0x2b,0x7e,0x15,0x16,0x28,0xae,0xd2,0xa6,
    0xab,0xf7,0x15,0x88,0x09,0xcf,0x4f,0x3c
  };
  // 暗号化
    const uint64_t init_major = 0;
    const uint16_t init_minor = 1;
    CtrDeriver der;
  #pragma omp parallel
  {
    // スレッドローカルAES（鍵展開を各スレッドで）
    aes::AES128 aes_tls(hwkey);

    #pragma omp for schedule(static)
    for (uint64_t b = 0; b < n_blocks; ++b) {
        // std::cout << "Processing block " << b << std::endl;
      uint64_t block_addr = PROTECTION_BASE + (b * 64);
      uint8_t plain[64];
      for (int i=0;i<(int)64;++i) plain[i] = (uint8_t)(b);
      encrypt64_AES_CTR_tls(aes_tls,
        &cipher[b*64], plain,
        block_addr, init_major, init_minor, der);
    }
  }
  std::cout << "[Info] Encryption completed for " << n_blocks << " blocks." << std::endl;

  // データタグ領域（64Bで8タグ=8*8B）
  const uint64_t n_tag_blocks = div_ceil_u64(n_blocks, 64 / 8);
  std::cout << "[Info] Tag blocks: " << n_tag_blocks << std::endl;
  std::vector<uint8_t> tags(n_tag_blocks * 64, 0);
  // タグ計算（ダミー）：各64B暗号文と counter(=1) から 8B
  #pragma omp parallel for schedule(static) 
    for(uint64_t b=0;b<n_blocks;++b){
        uint8_t* ciph = &cipher[b*64];
        uint64_t tag = compute_data_tag(ciph, init_minor, PROTECTION_BASE + b * 64, SETTING_MINOR_COUNTER_WIDTH);
        uint64_t tag_blk_index = b / (64 / 8);
        uint64_t tag_slot      = b % (64 / 8);
        uint8_t*  dst = &tags[tag_blk_index*64 + tag_slot*8];
        std::memcpy(dst, &tag, 8);
        
    }
  
  // カウンタツリー領域（全ノード数）
//   major_counter = 0; // 初期値 8B
//   minor_counter = |1|.....|1|; // 初期値 8bit x 32 = 32B
//   pad = |0|.....|0|; // 初期値 16B
//   mac = 8B
//   一番最初だけ親ノードが64bitde1
  uint64_t parent_counter = 1;
  uint64_t first_node_dram_addr = COUNTER_BASE;
  uint64_t count_log = 0;
  while(1){
    count_log += 1;
    if (1ULL << count_log >= MINOR_COUNTER_COUNT){
      break;
    }
  }
  std::cout << "[Info] Counter tree count_log: " << count_log << std::endl;
  uint64_t total_nodes = ((1ULL << (count_log * HEIGHT)) - 1ULL) / (MINOR_COUNTER_COUNT - 1ULL);
  if (MINOR_COUNTER_COUNT * MINOR_COUNTER_WIDTH > 384){
      die("Too large minor counter configuration.");
  }
  std::cout << "[Info] Total tree nodes: " << total_nodes << std::endl;
  std::vector<uint8_t> tree(total_nodes*64, 0);
  // uint8_t tree[total_nodes*64];
  #pragma omp parallel for schedule(static)
  for(uint64_t n=0;n<total_nodes;++n){
      uint64_t dram_addr = first_node_dram_addr + n * 64;
      uint8_t node[64];
      // 1. ノード全体をまず 0 で初期化 (これでPad領域やMajorの初期化も完了)
      std::memset(node, 0, 64);
      // 2. メジャーカウンターの設定 (先頭8バイト)
      // std::memcpy(node, , 8); 
      // 3. マイナーカウンターの設定 (定数定義に従って埋める)
      // MINOR_COUNTER_COUNT, MINOR_COUNTER_WIDTH は config.h / params.h 由来
      for (int k = 0; k < MINOR_COUNTER_COUNT; ++k) {
          // MINOR_COUNTER_INITIAL など定数があればそれを使う
          set_minor_val(node, k, 1, MINOR_COUNTER_WIDTH); 
      }
      uint64_t mac = compute_node_mac(node, parent_counter, (n==0)?64:SETTING_MINOR_COUNTER_WIDTH, dram_addr);
      // 5. MACの書き込み (末尾8バイト: 56〜63)
      for (int i = 0; i < 8; ++i) {
          node[56 + i] = (mac >> (8 * i)) & 0xFF;
      }
      std::memcpy(&tree[n*64], node, 64);
  }
  std::cout << "[Info] Tree nodes initialized." << std::endl;
  // セクション配置（64Bアライン）
  auto align64 = [](uint64_t x){ return (x + 63ull) & ~63ull; };
  uint64_t off_data = 0;
  uint64_t sz_data  = cipher.size();
  uint64_t off_tag  = align64(off_data + sz_data);
  uint64_t sz_tag   = tags.size();
  uint64_t off_tree = align64(off_tag + sz_tag);
  uint64_t sz_tree  = tree.size();
  uint64_t out_sz   = off_tree + sz_tree;
  // uint64_t total_sz = out_sz + sz_data;
  std::vector<uint8_t> image(out_sz, 0);
  // uint8_t image[out_sz];
  std::memcpy(&image[off_data], cipher.data(), sz_data);
  std::memcpy(&image[off_tag],  tags.data(), sz_tag);
  std::memcpy(&image[off_tree], tree.data(), sz_tree);
  // 出力
  int minor_bit_width = MINOR_COUNTER_WIDTH;
  int minor_count = MINOR_COUNTER_COUNT;
  int height = HEIGHT;
  const std::string out_path = "out_image_mcw" + std::to_string(minor_bit_width) + "_mcc" + std::to_string(minor_count) + "_height" + std::to_string(height) + ".img";
  {
    std::ofstream fo(out_path, std::ios::binary);
    if(!fo) die("cannot open out.img");
    fo.write(reinterpret_cast<const char*>(image.data()), out_sz);
  }
  // 16進数で情報表示
  std::cout << "[OK] image=" << out_path << std::endl 
            << " data_sz=" << std::hex << sz_data << std::dec
            << " tag_sz="  << std::hex << sz_tag << std::dec
            << " tree_sz=" << std::hex << sz_tree << std::dec
            << " blocks="  << std::hex << n_blocks << std::dec
            << " nodes="   <<  total_nodes
            << std::endl;
  std::cout << "nodes= " << total_nodes << std::endl;
  return 0;
}
