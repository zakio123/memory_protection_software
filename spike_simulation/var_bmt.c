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
#include "mem_layout_bmt.h"
#include "util.h"
#define PROTECTION_BASE  MAIN_PROTECTION_BASE
#define HEIGHT  MAIN_HEIGHT
#define PROTECTION_SIZE MAIN_PROTECTION_SIZE
#define DATA_TAG_BASE  (PROTECTION_BASE + PROTECTION_SIZE) // 0x04000000
#define DATA_TAG_SIZE  (PROTECTION_SIZE / 8) // 8MB
#define COUNTER_BASE (DATA_TAG_BASE + DATA_TAG_SIZE) // 0x04800000
#define NODE_BASE (MAIN_COUNTER_BASE + MAIN_COUNTER_SIZE)

// セットアソシアティブキャッシュの定義
// SPM内でのキャッシュメタデータ領域のベースアドレス (例: SPMの 56 * 64 から開始)
#define CACHE_WAYS (2)
#define CACHE_SETS (48) // 24line
#define CACHE_DATA_SPM_BASE (64 * 4) // データ領域のベースアドレス
#define SPM_METADATA_BASE (100 * 64)
#define ARY 8
// | 58bit: ブロックアドレス | 4bit: アクセス数 | 1bit: Dirty | 1bit: Valid |

uint64_t get_spm_manage(uint64_t spm_offset) {
    return SPM_METADATA_BASE + (spm_offset / 64) * 8;
}

void ensureBlockInSpm(uint64_t required_block_addr, uint64_t spm_offset){
  uint64_t manage_addr = get_spm_manage(spm_offset);
  uint64_t info = spm_ld64(manage_addr);
  bool     valid = (info & 0x1ULL) != 0;
  bool     dirty = (info & 0x2ULL) != 0;
  uint64_t current_block_addr = (info >> 6) << 6;
  if (!valid || current_block_addr != required_block_addr) {
      // Dirtyビットが立っていれば、現在のブロックをDRAMに書き戻す
      if (valid && dirty) {
        spm_write_back(spm_offset, current_block_addr, 64);
      }
      spm_copy_to_local(required_block_addr, spm_offset, 64);
      clearBlockdirty(manage_addr, required_block_addr);
  } else {
      // キャッシュヒット時にアクセス数を0にリセット
      if (dirty) setBlockdirty(manage_addr, required_block_addr);
      else clearBlockdirty(manage_addr, required_block_addr);
  }
}
bool tag_check(uint64_t dram_addr){
  uint64_t set_index = (dram_addr / 64) % CACHE_SETS;
  uint64_t spm_offset = CACHE_DATA_SPM_BASE + (set_index * CACHE_WAYS * 64);
  for (uint64_t i = 0; i < CACHE_WAYS; ++i) {
      uint64_t manage_addr = get_spm_manage(spm_offset);
      uint64_t info = spm_ld64(manage_addr);
      bool valid = (info & 1) == 1;
      uint64_t current_block_addr = (info >> 6) << 6;
      if (valid && current_block_addr == dram_addr) {
          return true; // キャッシュヒット
      }
      spm_offset += 64;
  }
  return false; // キャッシュミス
}

uint64_t calculate_level_base_addr(uint64_t level) {
    uint64_t offset = 64 * ((1 << (3 * (level-1))) - 1) / (ARY - 1);
    return offset;
}

struct AddressContext {
    uint64_t request_addr;
    uint64_t counterblock_addr;
    uint64_t datamacblock_addr;
    uint64_t counter_bit_offset;
    uint64_t dmac_byte_offset;
    uint64_t spm_data;
    uint64_t spm_mac_block;
};

struct AddressContext setupAddressContext() {
    struct AddressContext ctx;
    ctx.request_addr = AXIM_REQ_ADDR_REG;
    // DRAMアドレス
    ctx.counterblock_addr = COUNTER_BASE + (((ctx.request_addr - PROTECTION_BASE) / (64 * 32))) * 64;
    ctx.datamacblock_addr = DATA_TAG_BASE + (((ctx.request_addr - PROTECTION_BASE) / (64 * 8))) * 64;
    // オフセット
    ctx.counter_bit_offset = 64 + (ctx.request_addr / 64) % 32 * 8;
    ctx.dmac_byte_offset = (ctx.request_addr / 64) % 8 * 8;
    // SPMアドレス
    ctx.spm_data = 0x040;
    ctx.spm_mac_block = 0x080;
    return ctx;
}

uint64_t spm_offset_for_cache_set(uint64_t dram_addr) {
    uint64_t block_addr = dram_addr & ~0x3F; // 64Bアライメント
    uint64_t set_index = (block_addr / 64) % CACHE_SETS;
    uint64_t way_index = 0;
    uint32_t lru_counter_max = 0;
    // wayを決定
    for (uint64_t i = 0; i < CACHE_WAYS; ++i) {
        uint64_t spm_offset = CACHE_DATA_SPM_BASE + (set_index * CACHE_WAYS * 64) + (i * 64);
        uint64_t manage_addr = SPM_METADATA_BASE + (spm_offset / 64) * 8;
        uint64_t info = spm_ld64(manage_addr);
        bool valid = (info & 1) == 1;
        uint64_t current_block_addr = (info >> 6) << 6;
        if (valid) {
          if (current_block_addr == block_addr) {
            // タグが一致した場合、そのwayを使用
            way_index = i;
            lru_counter_max = 0; // ヒットした場合はLRUカウンタをリセット
            info = (current_block_addr) | (0 << 2) | (info & 0x3); // アクセス数を0にリセット
            spm_sd64(manage_addr, info);
            break;
          } else {
            // wayが空いていない時、カウンタをインクリメントしてLRUを決定
            uint32_t access_count = ((info >> 2) + 1) & 0xF; // 4bitのアクセス数
            // LRU方式でwayを決定
            if (access_count > lru_counter_max) {
                lru_counter_max = access_count;
                way_index = i;
            }
          }
        } else {
          // 空きwayが見つかった場合、そのwayを使用
          way_index = i;
          break;
        }
    }
    // 各セットはCACHE_WAYS分のラインを持つため、適切なオフセットを計算
    // カウンターをインクリメント
    for (uint64_t i = 0; i < CACHE_WAYS; ++i) {
        uint64_t spm_offset = CACHE_DATA_SPM_BASE + (set_index * CACHE_WAYS * 64) + (i * 64);
        uint64_t manage_addr = SPM_METADATA_BASE + (spm_offset / 64) * 8;
        uint64_t info = spm_ld64(manage_addr);
        bool valid = (info & 1) == 1;
        uint64_t current_block_addr = (info >> 6) << 6;
        if (valid && current_block_addr != block_addr && i != way_index) {
            uint32_t access_count = ((info >> 2) + 1) & 0xF; // 4bitのアクセス数
            info = (info & ~(0xFUL << 2)) | (access_count << 2);
            spm_sd64(manage_addr, info);
        }
    }
    uint64_t spm_offset = CACHE_DATA_SPM_BASE + (set_index * CACHE_WAYS * 64) + (way_index * 64);
    return spm_offset;
}
bool verifyTreePath(const uint64_t* path_indecis){
  printf("Starting tree path verification...\n");
  for (uint64_t i = 0; i < HEIGHT; ++i) {
      printf("Path index at level %llu: %llu\n", i, path_indecis[i]);
  }
  // キャッシュのtagを見ていき、検証を始める階層を決定する
  uint64_t start_level = 0;
  // 下から順に見ていく
  // uint64_t addr = 0;
  // for (uint64_t i = HEIGHT;i>0;i--){
  //   addr = COUNTER_BASE + path_indecis[i-1] / 8 * 64 + calculate_level_base_addr(i);
  //   bool valid = tag_check(addr);
  //   if (valid){
  //     start_level = i;
  //     break;
  //   }
  // }
  // uint64_t prev_offset = 0;
  // if (start_level != 0){
  //   uint64_t dram_addr = NODE_BASE + path_indecis[start_level +1] / 8 * 64 + calculate_level_base_addr(HEIGHT-start_level);
  //   prev_offset = spm_offset_for_cache_set(dram_addr);
  // }
  for(uint64_t i=start_level; i<HEIGHT; ++i){
    mac_init();
    printf("Verifying level %llu offset %llu\n", i, calculate_level_base_addr(HEIGHT - i));
    uint64_t dram_addr = NODE_BASE + path_indecis[i] / 8 * 64 + calculate_level_base_addr(HEIGHT - i);
    uint64_t spm_offset = spm_offset_for_cache_set(dram_addr);
    ensureBlockInSpm(dram_addr, spm_offset);
    // MAC計算
    mac_buffer_set(spm_offset);
    mac_update(0,511);
    uint64_t computed_mac = mac_final();
    if (i == HEIGHT-1){
      uint64_t stored_mac = spm_ld64(0);
      if (computed_mac != stored_mac){
        printf("Level %llu: computed_mac=%016llx, stored_mac=%016llx\n", i, computed_mac, stored_mac);
        return false;
      }
    } else {
      dram_addr = NODE_BASE + path_indecis[i+1] / 8 * 64 + calculate_level_base_addr(HEIGHT - (i + 1));
      spm_offset = spm_offset_for_cache_set(dram_addr);
      ensureBlockInSpm(dram_addr, spm_offset);
      uint64_t stored_mac = spm_ld64(spm_offset + path_indecis[i+1] % 8 * 8);
      if (computed_mac != stored_mac){
        printf("Level %llu: computed_mac=%016llx, stored_mac=%016llx\n", i, computed_mac, stored_mac);
        return false;
      }
    }
  }
  return true;
}

void Authentication(){
   struct AddressContext ctx = setupAddressContext();
   uint64_t path_indecis[HEIGHT];
    for(uint64_t i=0; i<HEIGHT; ++i){
      path_indecis[i] = (ctx.request_addr - PROTECTION_BASE) / 64 / 32 / (64 * (1ULL << (3 * i)));
    }
    bool counter_hit = tag_check(ctx.counterblock_addr);
    uint64_t spm_offset;
    uint64_t major_counter;
    uint64_t minor_counter_byte_address;
    uint64_t minor_counter;
    uint8_t minor_counter_value;
    if (!counter_hit){
        bool verified = verifyTreePath(path_indecis);
        if (verified == false){
            printf("[Core FW] Authentication failed during counter verification. Aborting.\n");
            exit(1);
        }
    }
    uint64_t root = spm_ld64(0);
    uint64_t new_root = root + 1;
    spm_sd64(0, new_root);
    uint64_t prev_offset = 0;
    for (uint64_t i=0;i<HEIGHT;i++){
      mac_init();
      uint64_t dram_addr = COUNTER_BASE + path_indecis[i] / 8 * 64 + calculate_level_base_addr(i + 1);
      spm_offset = spm_offset_for_cache_set(dram_addr);
      ensureBlockInSpm(dram_addr, spm_offset);
      // ここから過去のmajor, minor counterを取り出す
      uint64_t major_counter = spm_ld64(spm_offset);
      uint64_t minor_counter_byte_address = spm_offset + 8 + (path_indecis[i] % 32) / 8 * 8;
      uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
      // ここから過去のminor counterを取り出す
      uint8_t minor_counter_value = (minor_counter >> ((path_indecis[i] % 8) * 8)) & 0xFF;
      uint8_t new_minor_counter = 0;
      if (minor_counter_value == 0xFF){
          uint64_t new_major_counter = major_counter + 1;
          spm_sd64(spm_offset, new_major_counter);
          new_minor_counter = 0; // minor counterは0に戻す
          // exit(1); // 今回はエラーにする
      } else {
          new_minor_counter = minor_counter_value + 1;
      }
      uint64_t shift_amount = (path_indecis[i] % 8) * 8;
      uint64_t clear_mask = ~(0xFFULL << shift_amount);
      uint64_t cleared_minor_counter = minor_counter & clear_mask;
      // --- 新しい値を正しい位置へシフトする ---
      uint64_t shifted_new_value = (new_minor_counter);
      shifted_new_value <<= shift_amount;
      uint64_t final_word = cleared_minor_counter | shifted_new_value;
      // 書き戻し
      spm_sd64(minor_counter_byte_address, final_word);
      // ブロックをdirtyに設定する
      uint64_t mac_manage = get_spm_manage(spm_offset);
      setBlockdirty(mac_manage, dram_addr);
      // MAC計算を実行
      // Hash関数を初期化してから当該ブロックをMAC
      mac_buffer_set(spm_offset);
      mac_update(0, 447); // 448bit = 56B
      // 親ノードのヘッダーをMACの内部バッファにセット
      uint64_t mac_result = mac_final();
      prev_offset = spm_offset;
      spm_sd64(spm_offset + 56, mac_result);
    }
    spm_offset = spm_offset_for_cache_set(ctx.counterblock_addr);
    major_counter = spm_ld64(spm_offset);
    axim_copy(ctx.spm_data);
    // minor_counterのload
    // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
    minor_counter_byte_address = spm_offset + (ctx.counter_bit_offset / 64) * 8;
    minor_counter = spm_ld64(minor_counter_byte_address);
    minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64))) & 0xFF;
    // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
    // busy wait AESモジュールの計算完了を待つ
    set_seed(major_counter, minor_counter_value, ctx.request_addr);
    // --- 手順3: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
    while(AES_START_REG); // busy待ち
    write_xor(ctx.spm_data);
    xor_start();
    copy_xor(ctx.spm_data);
    spm_write_back(ctx.spm_data, ctx.request_addr, 64);
    // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
    // ハッシュ関数の内部状態を初期化
    // SPMに当該MACブロックがあればそのままmodify,なければ今あるブロックをDRAMにwrite backしてから適切なブロックをSPMにDRAMコピー
    mac_init();
    mac_buffer_set(ctx.spm_data); 
    mac_update(0, 511);
    mac_buffer_set(spm_offset);
    mac_update(ctx.counter_bit_offset, ctx.counter_bit_offset + 7); // 8bit = 1B
    // MAC計算完了
    uint64_t computed_mac = mac_final();
    ensureBlockInSpm(ctx.datamacblock_addr, ctx.spm_mac_block);
    // --- 手順6: Hashモジュールの計算完了を待ち、結果をSPMに保存 ---
    spm_sd64(ctx.spm_mac_block + ctx.dmac_byte_offset, computed_mac);
    // SPM上のMACブロックをDirtyに設定する
    uint64_t mac_manage = get_spm_manage(ctx.spm_mac_block);
    setBlockdirty(mac_manage, ctx.datamacblock_addr);
    axim_write_return();
}

void Verification(){
  struct AddressContext ctx = setupAddressContext();
  // --- 手順1.1 : ツリー検証 ---
  // 1. パスの特定=親ノードの物理アドレスをルートまで計算していく。
  uint64_t path_index[HEIGHT]; // 先頭は階層1
  for(uint64_t i=0; i<HEIGHT; ++i){
    path_index[HEIGHT-1-i] = (ctx.request_addr - PROTECTION_BASE) / 32 / (64 * (1ULL << (3 * i)));
  }
  bool verified = verifyTreePath(path_index);
  if (verified == false){
      printf("[Core FW] Verification failed during counter verification. Aborting.\n");
      exit(1);
  }
  // --- 手順1.2 : ツリーの検証は終了、カウンターのload ---
  spm_copy_to_local(ctx.request_addr, ctx.spm_data, 64);
  uint64_t spm_offset = spm_offset_for_cache_set(ctx.counterblock_addr);
  uint64_t major_counter = spm_ld64(spm_offset);
  // minor_counterのload
  // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
  uint64_t minor_counter = spm_ld64(spm_offset + (ctx.counter_bit_offset / 64) * 8);
  uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64) )) & 0xFF;
  // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
  // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
  set_seed(major_counter, minor_counter_value, ctx.request_addr);
  // --- 手順3: SPM DMAを起動し、DRAMから暗号文をSPMにコピー ---
  mac_init();
  mac_buffer_set(ctx.spm_data);
  mac_update(0, 511);
  // SPMからカウンターブロックをコピーし、update
  mac_buffer_set(spm_offset);
  mac_update(ctx.counter_bit_offset, ctx.counter_bit_offset + 7); 
  // MAC計算完了
  // --- 手順6: Hashモジュールの計算完了を待ち、結果を取得しSPMから正しい結果をload ---
  uint64_t mac_result = mac_final();
  // SPMに当該MACブロックがあるかを確認。なければコピー。
  ensureBlockInSpm(ctx.datamacblock_addr, ctx.spm_mac_block);
  uint64_t expected_mac = spm_ld64(ctx.spm_mac_block + ctx.dmac_byte_offset);
  if (mac_result != expected_mac) {
      printf("[Core FW] Verification failed: MAC mismatch! Computed: %016llx, Expected: %016llx\n", mac_result, expected_mac);
      // エラー処理: MAC不一致
      exit(1);
  }
  // --- 手順7: AXI managerに対し、read bufferにあるデータをリターンするように指示 ---
  while(AES_START_REG); // busy待ち
  write_xor(ctx.spm_data);
  xor_start();
  copy_xor(ctx.spm_data);
  axim_write(ctx.spm_data);
  axim_read_return();
}

int main(void){
  /* MEMREQの設定 */
  uint64_t size = PROTECTION_SIZE;
  uint64_t nu = 4096 * 32; 
  memreq_make(size, 16384); 
  for (uint64_t i=0; i<512; i++){
    spm_sd64(i*8, 0); // SPMの初期化
  }
  spm_sd64(0,1); // rootノードの初期化
  while(1){
    for(;;){
      if(AXIM_STATUS_REG & 1) break; // リクエストが来るまで待つ
    }
    uint64_t addr = AXIM_REQ_ADDR_REG;
    if (addr == 0xFFFFFFFFFFFFFFFF){
      // setStats(0);
      return 0;
    } else {
      if(AXIM_STATUS_REG & 2){ // writeリクエスト
        setStats(1);
        Authentication();
        setStats(0);
        return 0;
      } else {
        setStats(1);
        Verification();
        setStats(0);
        return 0;
      }
    }
  }
}