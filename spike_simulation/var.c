#include <stdint.h>
#include "mmio_reg/spm_reg.h"
#include "mmio_reg/mac_reg.h"
#include "mmio_reg/aes_reg.h"
#include "mmio_reg/axim_reg.h"
#include "mmio_reg/memreq_reg.h"
#include "mmio_reg/reg_map.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define PROTECTION_BASE 0x90000000ULL
#define PROTECTION_SIZE 0x04000000ULL // 64MB
#define DATA_TAG_BASE  PROTECTION_BASE + PROTECTION_SIZE // 0x94000000
#define DATA_TAG_SIZE 1024 * 1024 * 8 // 8MB
#define COUNTER_BASE DATA_TAG_BASE + DATA_TAG_SIZE // 0x94800000
#define HEIGHT 4
struct AddressContext {
    uint64_t request_addr;
    uint64_t counterblock_addr;
    uint64_t datamacblock_addr;
    uint64_t counter_bit_offset;
    uint64_t dmac_byte_offset;
    uint64_t spm_data;
    uint64_t spm_mac_block;
    uint64_t spm_counter_block;
    uint64_t spm_counter_manage;
    uint64_t spm_mac_manage;
};
static const uint64_t level_base_addr[HEIGHT] = {(1ULL << (5*3)) * 64 + (1ULL << (5 * 2)) * 64 + (1ULL << (5 * 1)) * 64, (1ULL << (5*3)) * 64 + (1ULL << (5 * 2)) * 64, (1ULL << (5*3)) * 64, 0};

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
    ctx.spm_counter_block = 0x0C0;
    ctx.spm_mac_manage = 56 * 64 + 1*8;
    ctx.spm_counter_manage = 56 * 64 + 3*8;
    return ctx;
}

bool verifyTreePath(const uint64_t* path_indecis){
  for(uint64_t i=0; i<HEIGHT; ++i){
    uint64_t spm_addr = (6-i) * 64;
    uint64_t manage_addr = 56 * 64 + (6 - i) * 8;
    uint64_t dram_addr = COUNTER_BASE + path_indecis[i] / 32 * 64 + level_base_addr[i];
    ensureBlockInSpm(dram_addr, spm_addr, manage_addr);
    // MAC計算
    mac_init();
    mac_buffer_set(spm_addr);
    mac_update(0,447);
    if (i == 0){
      mac_buffer_set(0);
      mac_update(0,63);
    } else {
      mac_buffer_set(spm_addr + 64);
      uint64_t start_bit = 64 + (path_indecis[i-1] % 32) * 8;
      mac_update(start_bit, start_bit + 7);
    }
    uint64_t computed_mac = mac_final();
    uint64_t stored_mac = spm_ld64(spm_addr + 56);
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
      path_indecis[3-i] = (ctx.request_addr - 0x90000000ULL) / (64 * (1ULL << (5 * i)));
    }
    // printf("[Core FW] --- Starting Authentication ---\n");
    // printf("path: %llu, %llu, %llu, %llu\n", path_indecis[0], path_indecis[1], path_indecis[2], path_indecis[3]);
    {
      ensureBlockInSpm(ctx.counterblock_addr, ctx.spm_counter_block, ctx.spm_counter_manage);
      uint64_t major_counter = spm_ld64(ctx.spm_counter_block);
      uint64_t minor_counter_byte_address = ctx.spm_counter_block + (ctx.counter_bit_offset / 64) * 8;
      uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
      // ここから過去のminor counterを取り出す
      uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64) )) & 0xFF;
      if (minor_counter_value != 0 || major_counter != 0){
          // メジャーマイナー、どちらかが0でなければ検証を行う
          // 1. パスの特定=親ノードの物理アドレスをルートまで計算していく。
          bool verified = verifyTreePath(path_indecis);
          if (verified == false){
              printf("[Core FW] Authentication failed during counter verification. Aborting.\n");
              exit(1);
          }
      }
    }
    uint64_t root = spm_ld64(0);
    uint64_t new_root = root + 1;
    spm_sd64(0, new_root);
    for (uint64_t i=0;i<HEIGHT;i++){
            uint64_t spm_addr = (6-i) * 64;
            uint64_t spm_manage = 56 * 64 + (6-i) * 8;
            uint64_t dram_addr = COUNTER_BASE + path_indecis[i] / 32 * 64;
            dram_addr += level_base_addr[i];
            ensureBlockInSpm(dram_addr, spm_addr, spm_manage);
            // height += 1;
            // ここから過去のmajor, minor counterを取り出す
            uint64_t major_counter = spm_ld64(spm_addr);
            uint64_t minor_counter_byte_address = spm_addr + 8 + (path_indecis[i] % 32) / 8 * 8;
            uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
            // ここから過去のminor counterを取り出す
            uint8_t minor_counter_value = (minor_counter >> ((path_indecis[i] % 8) * 8)) & 0xFF;
            uint8_t new_minor_counter = 0;
            if (minor_counter_value == 0xFF){
                uint64_t new_major_counter = major_counter + 1;
                spm_sd64(spm_addr, new_major_counter);
                new_minor_counter = 0; // minor counterは0に戻す
                // printf("Major counter overflow. Incremented major to %llu and reset minor to 0.\n", new_major_counter);
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
            // カウンターをprint
            // 書き戻し
            spm_sd64(minor_counter_byte_address, final_word);
            // ブロックをdirtyに設定する
            setBlockdirty(spm_manage, dram_addr);
            // MAC計算を実行
            // Hash関数を初期化してから当該ブロックをMAC
            mac_init();
            mac_buffer_set(spm_addr);
            mac_update(0, 447); // 448bit = 56B
            // 親ノードのヘッダーをMACの内部バッファにセット
            if (i == 0){
                // 最上位層はrootノードを使う
                mac_buffer_set(0);
                mac_update(0, 63);
            } else {
                uint64_t parent_offset = path_indecis[i-1] % 32 * 8;
                mac_buffer_set(spm_addr+ 64);
                uint64_t start_bit = 64 + parent_offset;
                mac_update(start_bit, start_bit + 7);
            }
            // MAC計算完了
            uint64_t mac_result = mac_final();
            // printf("Level %llu: Updated Major=%llu, Minor=%u, New MAC=%016llx\n", i, major_counter, new_minor_counter, mac_result);
            spm_sd64(spm_addr + 56, mac_result); // 56BにMACがある
        }
    uint64_t major_counter = spm_ld64(ctx.spm_counter_block);
    // minor_counterのload
    // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
    uint64_t minor_counter_byte_address = ctx.spm_counter_block + (ctx.counter_bit_offset / 64) * 8;
    uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
    uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64))) & 0xFF;
    // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
    printf("[Core FW] Major Counter: %llu, Minor Counter: %u, Request Address: 0x%llx\n", major_counter, minor_counter_value, ctx.request_addr);
    set_seed(major_counter, minor_counter_value, ctx.request_addr);
    // --- 手順3: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
    // busy wait AESモジュールの計算完了を待つ
    axim_encrypt();
    // --- 手順4: AXI Managerに暗号文をSPMにwrite backするよう指示 ---
    axim_write_back(ctx.spm_data);
    // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
    // ハッシュ関数の内部状態を初期化
    mac_init();
    mac_buffer_set(ctx.spm_data); 
    mac_update(0, 511); // 512bit = 64B
    mac_buffer_set(ctx.spm_counter_block);
    mac_update(ctx.counter_bit_offset, ctx.counter_bit_offset + 7); // 8bit = 1B
    // MAC計算完了
    uint64_t computed_mac = mac_final();
    // --- 手順6: Hashモジュールの計算完了を待ち、結果をSPMに保存 ---
    // SPMに当該MACブロックがあればそのままmodify,なければ今あるブロックをDRAMにwrite backしてから適切なブロックをSPMにDRAMコピー
    ensureBlockInSpm(ctx.datamacblock_addr, ctx.spm_mac_block, ctx.spm_mac_manage);
    spm_sd64(ctx.spm_mac_block + ctx.dmac_byte_offset, computed_mac);
    // SPM上のMACブロックをDirtyに設定する
    setBlockdirty(ctx.spm_mac_manage, ctx.datamacblock_addr);
    // --- 手順7: SPM DMAを起動し、SPMからDRAMへ暗号文をwrite back ---
    spm_write_back(ctx.spm_data, ctx.request_addr, 64);

    // --- 手順8: AXI managerに対し、write ackの完了を通知 ---
    // busy wait
    axim_write_return();
    // printf("[Core FW] --- Authentication Finished ---\n");
}

void Verification(){
  // printf("[Core FW] --- Starting Verification ---\n");
  struct AddressContext ctx = setupAddressContext();
  // printf("[Core FW] Request Address: 0x%llx\n", ctx.request_addr);
  // --- 手順1: SPMからカウンターをload ---
  // 初めにspmにあるカウンターのアドレスを確認する
  // printf("[Core FW] Step 1: Handling counter block in SPM...\n");
  // --- 手順1.1 : ツリー検証 ---
  {
      // missの場合、カウンターブロックの検証が必要
      // 1. パスの特定=親ノードの物理アドレスをルートまで計算していく。
      uint64_t path_index[4]; // 先頭は階層1
      for(uint64_t i=0; i<HEIGHT; ++i){
          path_index[3-i] = (ctx.request_addr - 0x90000000ULL) / (64 * (1ULL << (5 * i)));
      }
      bool verified = verifyTreePath(path_index);
      if (verified == false){
          printf("[Core FW] Verification failed during counter verification. Aborting.\n");
          exit(1);
      }
  }
  // --- 手順1.2 : ツリーの検証は終了、カウンターのload ---
  uint64_t major_counter = spm_ld64(ctx.spm_counter_block);
  // minor_counterのload
  // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
  uint64_t minor_counter_byte_address = ctx.spm_counter_block + (ctx.counter_bit_offset / 64) * 8;
  uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
  uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64) )) & 0xFF;
  // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
  printf("[Core FW] Step 2: Setting AES seed and starting encryption...\n");
  printf("[Core FW] Major Counter: %llu, Minor Counter: %u, Request Address: 0x%llx\n", major_counter, minor_counter_value, ctx.request_addr);
  set_seed(major_counter, minor_counter_value, ctx.request_addr);
  // --- 手順3: SPM DMAを起動し、DRAMから暗号文をSPMにコピー ---
  spm_copy_to_local(ctx.request_addr, ctx.spm_data, 64);
  // --- 手順3: AXI ManagerにOTPとともにXORを実行し、復号化を指示 ---
  // SPMからAXI Managerへ暗号文をコピー
  axim_copy(ctx.spm_data);
  axim_decrypt();

  // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
  // printf("[Core FW] Step 5: Commanding Hash module to compute MAC...\n");
  // SPMから暗号文をコピーし、update
  mac_init();
  mac_buffer_set(ctx.spm_data);
  mac_update(0, 511);
  // SPMからカウンターブロックをコピー
  mac_buffer_set(ctx.spm_counter_block);
  mac_update(ctx.counter_bit_offset, ctx.counter_bit_offset + 7); // todo: correct end bit length
  // MAC計算完了

  // --- 手順6: Hashモジュールの計算完了を待ち、結果を取得しSPMから正しい結果をload ---
  uint64_t mac_result = mac_final();
  // SPMに当該MACブロックがあるかを確認。なければコピー。
  ensureBlockInSpm(ctx.datamacblock_addr, ctx.spm_mac_block, ctx.spm_mac_manage);
  uint64_t expected_mac = spm_ld64(ctx.spm_mac_block + ctx.dmac_byte_offset);
  if (mac_result != expected_mac) {
      printf("[Core FW] Verification failed: MAC mismatch! Computed: %016llx, Expected: %016llx\n", mac_result, expected_mac);
      // エラー処理: MAC不一致
      exit(1);
  }
  
  // --- 手順7: AXI managerに対し、read bufferにあるデータをリターンするように指示 ---
  // busy wait
  // printf("[Core FW] Step 7: Returning decrypted data...\n");
  axim_read_return();
}

int main(void){
  /* MEMREQの設定 */
  memreq_make(1024 * 1024, 40000); // 64B, 400リクエスト
  // printf("[Core FW] MEMREQ configured for 64B transfers.\n");
  while(1){
    for(;;){
      // printf("Waiting for request...\n");
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
