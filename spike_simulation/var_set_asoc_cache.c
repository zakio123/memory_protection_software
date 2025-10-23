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
#define PROTECTION_BASE 0x90000000ULL
#define PROTECTION_SIZE 0x04000000ULL // 64MB
#define DATA_TAG_BASE  (PROTECTION_BASE + PROTECTION_SIZE) // 0x04000000
#define DATA_TAG_SIZE  (1024 * 1024 * 8) // 8MB
#define COUNTER_BASE (DATA_TAG_BASE + DATA_TAG_SIZE) // 0x04800000
#define HEIGHT 4

// セットアソシアティブキャッシュの定義
// SPM内でのキャッシュメタデータ領域のベースアドレス (例: SPMの 56 * 64 から開始)
#define CACHE_WAYS (2)
#define CACHE_SETS (16) // 8line
#define CACHE_DATA_SPM_BASE (64 * 4) // データ領域のベースアドレス
#define SPM_METADATA_BASE (56 * 64)

// キャッシュ用タグの構成
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
      // 新しいブロックをDRAMからSPMに読み込む
      spm_copy_to_local(required_block_addr, spm_offset, 64);
      clearBlockdirty(manage_addr, required_block_addr);
  } else {
      // キャッシュヒット時にアクセス数を0にリセット
      if (dirty) setBlockdirty(manage_addr, required_block_addr);
      else clearBlockdirty(manage_addr, required_block_addr);
  }
}

uint64_t calculate_level_base_addr(uint64_t level) {
    // Height4からlevelまでのオフセットを計算
    // level 1 から (level - 1) までの各階層のサイズを合計する
    // 1なら0, 2なら64, 3なら64+32*64,4なら64+32*64+1024*64を返したい
    uint64_t offset = 64 * ((1 << (5 * (level-1))) - 1) / (32 - 1);
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
    ctx.counterblock_addr = COUNTER_BASE + (((ctx.request_addr - PROTECTION_BASE) / (64 * 32))) * 64 + calculate_level_base_addr(HEIGHT);
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
            break;
          } else {
            // wayが空いていない時、カウンタをインクリメントしてLRUを決定
            uint32_t access_count = ((info >> 2) + 1) & 0xF; // 4bitのアクセス数
            uint64_t new_info = (current_block_addr) | (access_count << 2) | (info & 0x3);
            spm_sd64(manage_addr, new_info);
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
    uint64_t spm_offset = CACHE_DATA_SPM_BASE + (set_index * CACHE_WAYS * 64) + (way_index * 64);
    return spm_offset;
}


bool verifyTreePath(const uint64_t* path_indecis){
  uint64_t prev_offset = 0;
  for(uint64_t i=0; i<HEIGHT; ++i){
    mac_init();
    if (i == 0){
      mac_buffer_set(0);
      mac_update(0,63);
    } else {
      mac_buffer_set(prev_offset);
      uint64_t start_bit = 64 + (path_indecis[i-1] % 32) * 8;
      mac_update(start_bit, start_bit + 7);
    }
    uint64_t dram_addr = COUNTER_BASE + path_indecis[i] / 32 * 64 + calculate_level_base_addr(i + 1);
    uint64_t spm_offset = spm_offset_for_cache_set(dram_addr);
    ensureBlockInSpm(dram_addr, spm_offset);
    // MAC計算

    mac_buffer_set(spm_offset);
    mac_update(0,447);
    uint64_t computed_mac = mac_final();
    uint64_t stored_mac = spm_ld64(spm_offset + 56);
    prev_offset = spm_offset;
    if (computed_mac != stored_mac){
      printf("Level %llu: computed_mac=%016llx, stored_mac=%016llx\n", i, computed_mac, stored_mac);
      return false;
    }
  }
  return true;
}

void Authentication(){
   struct AddressContext ctx = setupAddressContext();
   uint64_t path_indecis[HEIGHT];
    for(uint64_t i=0; i<HEIGHT; ++i){
      path_indecis[3-i] = (ctx.request_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * i)));
    }
    uint64_t spm_offset = spm_offset_for_cache_set(ctx.counterblock_addr);
    ensureBlockInSpm(ctx.counterblock_addr, spm_offset);
    uint64_t major_counter = spm_ld64(spm_offset);
    uint64_t minor_counter_byte_address = spm_offset + (ctx.counter_bit_offset / 64) * 8;
    uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
    // ここから過去のminor counterを取り出す
    uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64) )) & 0xFF;
    if (minor_counter_value != 0 || major_counter != 0){
        // 1. パスの特定=親ノードの物理アドレスをルートまで計算していく。
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
      if (i == 0){
          // 最上位層はrootノードを使う
          mac_buffer_set(0);
          mac_update(0, 63);
      } else {
          uint64_t parent_offset = path_indecis[i-1] % 32 * 8;
          mac_buffer_set(prev_offset);
          uint64_t start_bit = 64 + parent_offset;
          mac_update(start_bit, start_bit + 7);
      }
      uint64_t dram_addr = COUNTER_BASE + path_indecis[i] / 32 * 64 + calculate_level_base_addr(i + 1);
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
      printf("Level %llu: Updated Major=%llu, Minor=%u, New MAC=%016llx\n", i, major_counter, new_minor_counter, mac_result);
      spm_sd64(spm_offset + 56, mac_result); // 56BにMACがある
    }
    spm_offset = spm_offset_for_cache_set(ctx.counterblock_addr);
    major_counter = spm_ld64(spm_offset);
    // minor_counterのload
    // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
    minor_counter_byte_address = spm_offset + (ctx.counter_bit_offset / 64) * 8;
    minor_counter = spm_ld64(minor_counter_byte_address);
    minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64))) & 0xFF;
    // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
    set_seed(major_counter, minor_counter_value, ctx.request_addr);
    // --- 手順3: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
    // busy wait AESモジュールの計算完了を待つ
    axim_copy(ctx.spm_data);
    write_xor(ctx.spm_data);
    xor_start();
    copy_xor(ctx.spm_data);
    // axim_encrypt();
    // // --- 手順4: AXI Managerに暗号文をSPMにwrite backするよう指示 ---
    // axim_copy(ctx.spm_data);
    // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
    // ハッシュ関数の内部状態を初期化
    mac_init();
    mac_buffer_set(ctx.spm_data); 
    mac_update(0, 511); // 512bit = 64B
    mac_buffer_set(spm_offset);
    mac_update(ctx.counter_bit_offset, ctx.counter_bit_offset + 7); // 8bit = 1B
    // MAC計算完了
    uint64_t computed_mac = mac_final();
    // --- 手順6: Hashモジュールの計算完了を待ち、結果をSPMに保存 ---
    // SPMに当該MACブロックがあればそのままmodify,なければ今あるブロックをDRAMにwrite backしてから適切なブロックをSPMにDRAMコピー
    ensureBlockInSpm(ctx.datamacblock_addr, ctx.spm_mac_block);
    spm_sd64(ctx.spm_mac_block + ctx.dmac_byte_offset, computed_mac);
    // SPM上のMACブロックをDirtyに設定する
    uint64_t mac_manage = get_spm_manage(ctx.spm_mac_block);
    setBlockdirty(mac_manage, ctx.datamacblock_addr);
    // --- 手順7: SPM DMAを起動し、SPMからDRAMへ暗号文をwrite back ---
    spm_write_back(ctx.spm_data, ctx.request_addr, 64);
    axim_write_return();
}

void Verification(){
  struct AddressContext ctx = setupAddressContext();
  // --- 手順1.1 : ツリー検証 ---
  {
      // 1. パスの特定=親ノードの物理アドレスをルートまで計算していく。
      uint64_t path_index[4]; // 先頭は階層1
      for(uint64_t i=0; i<HEIGHT; ++i){
          path_index[3-i] = (ctx.request_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * i)));
      }
      bool verified = verifyTreePath(path_index);
      if (verified == false){
          printf("[Core FW] Verification failed during counter verification. Aborting.\n");
          exit(1);
      }
  }
  // --- 手順1.2 : ツリーの検証は終了、カウンターのload ---
  uint64_t spm_offset = spm_offset_for_cache_set(ctx.counterblock_addr);
  uint64_t major_counter = spm_ld64(spm_offset);
  // minor_counterのload
  // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
  uint64_t minor_counter_byte_address = spm_offset + (ctx.counter_bit_offset / 64) * 8;
  uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
  uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64) )) & 0xFF;
  // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
  set_seed(major_counter, minor_counter_value, ctx.request_addr);
  // --- 手順3: SPM DMAを起動し、DRAMから暗号文をSPMにコピー ---
  spm_copy_to_local(ctx.request_addr, ctx.spm_data, 64);
  // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
  mac_init();
  mac_buffer_set(ctx.spm_data);
  mac_update(0, 511);
  // SPMからカウンターブロックをコピーし、update
  mac_buffer_set(spm_offset);
  mac_update(ctx.counter_bit_offset, ctx.counter_bit_offset + 7); // todo: correct end bit length
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
  // busy wait
  // printf("[Core FW] Step 7: Returning decrypted data...\n");
  write_xor(ctx.spm_data);
  xor_start();
  copy_xor(ctx.spm_data);
  axim_write(ctx.spm_data);
  axim_read_return();
}
// カウンターがオーバーフローした場合の再暗号化とデータMACの再計算
void Reencryption(uint64_t block_addr, uint64_t major_counter, uint8_t old_minor_counter, uint64_t block_manage, uint64_t mac_manage){
    ensureBlockInSpm(block_addr, 0x1 * 64);
    // 復号化
    set_seed(major_counter, old_minor_counter, block_addr);
    // AXI Managerに暗号文をコピーし、XORを実行して復号化

    // 次に、暗号化
    set_seed(major_counter + 1, 0, block_addr);
    // AXI Managerに平文とOTPをコピーし、XORを実行して暗号化
    // SPMに書き戻し
    // データMACの再計算
    mac_init();
    mac_buffer_set(0x1 * 64);
    mac_update(0, 511);
    mac_buffer_set(0x0C0);
    mac_update(64, 71);
    uint64_t new_mac = mac_final();
}
int main(void){
  /* MEMREQの設定 */
  memreq_make(1024 * 1024 * 64, 1024); // 64B, 1リクエスト
  for (uint64_t i=0; i<512; i++){
    spm_sd64(i*8, 0); // SPMの初期化
  }
  // カウンターの初期化
  for (uint64_t i=0; i<3 * 1024 * 1024 / 1024; i++){
    spm_write_back(0,COUNTER_BASE+i*1024,1024);
  }
  while(1){
    for(;;){
      if(AXIM_STATUS_REG & 1) break; // リクエストが来るまで待つ
    }
    if(AXIM_STATUS_REG & 2){ // writeリクエスト
      Authentication();
    } else {
      Verification();
    }
  }
  return 0;
}
