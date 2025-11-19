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
#include "mem_layout.h"
#include "util.h"
#define PROTECTION_BASE  MAIN_PROTECTION_BASE
#define HEIGHT  MAIN_HEIGHT
#define PROTECTION_SIZE MAIN_PROTECTION_SIZE
#define DATA_TAG_BASE  (PROTECTION_BASE + PROTECTION_SIZE) // 0x04000000
#define DATA_TAG_SIZE  (PROTECTION_SIZE / 8) // 8MB
#define COUNTER_BASE (DATA_TAG_BASE + DATA_TAG_SIZE) // 0x04800000



// セットアソシアティブキャッシュの定義
// SPM内でのキャッシュメタデータ領域のベースアドレス (例: SPMの 56 * 64 から開始)
#define CACHE_WAYS (4)
#define CACHE_SETS (128) // 768line
#define CACHE_DATA_SPM_BASE (64 * 4) // データ領域のベースアドレス
#define SPM_METADATA_BASE (CACHE_DATA_SPM_BASE + (CACHE_SETS * CACHE_WAYS * 64)) // メタデータ領域のベースアドレス
struct Info {
    bool valid;
    bool dirty;
    bool hit;
    uint64_t spm_offset;
    uint64_t block_addr;
};
struct CacheMetadata{
    bool valid;
    bool dirty;
    uint32_t access_count : 4;
    uint64_t block_addr;
};
struct CacheMetadata cache_metadata[CACHE_SETS][CACHE_WAYS] = {0};

static inline void setBlockdirty(uint64_t spm_offset){
  uint32_t way_index = (spm_offset / 64) % CACHE_WAYS;
  uint32_t set_index = ((spm_offset - CACHE_DATA_SPM_BASE) / 64 / CACHE_WAYS) % CACHE_SETS;
  cache_metadata[set_index][way_index].dirty = true;
}
static inline void clearBlockdirty(uint64_t spm_offset){
  uint32_t way_index = (spm_offset / 64) % CACHE_WAYS;
  uint32_t set_index = ((spm_offset - CACHE_DATA_SPM_BASE) / 64 / CACHE_WAYS) % CACHE_SETS;
  cache_metadata[set_index][way_index].dirty = false;
}
// | 58bit: ブロックアドレス | 4bit: アクセス数 | 1bit: Dirty | 1bit: Valid |

uint64_t get_spm_manage(uint64_t spm_offset) {
    return SPM_METADATA_BASE + spm_offset / 8;
}

uint32_t total_count = 0;
uint32_t hit_count = 0;

uint64_t ensureBlockInSpm(uint64_t required_block_addr, struct Info tag_info,uint64_t id){
  uint64_t read_id = id;
  // uint64_t manage_addr = get_spm_manage(tag_info.spm_offset);
  // Dirtyビットが立っていれば、現在のブロックをDRAMに書き戻す
  if (tag_info.dirty) {
    spm_write_back(tag_info.spm_offset, tag_info.block_addr, 64,read_id);
    read_id++;
  }
  spm_copy_to_local(required_block_addr, tag_info.spm_offset, 64,read_id);
  int way = tag_info.spm_offset / 64 % CACHE_WAYS;
  int set = ((tag_info.spm_offset - CACHE_DATA_SPM_BASE) / 64 / CACHE_WAYS) % CACHE_SETS;
  cache_metadata[set][way].valid = true;
  cache_metadata[set][way].dirty = false;
  cache_metadata[set][way].access_count = 0;
  cache_metadata[set][way].block_addr = required_block_addr;
  return read_id;
}


struct Info tag_check(uint64_t dram_addr){
  struct Info tag_info = {false, false, false, 0, 0};
  uint64_t set_index = (dram_addr / 64) % CACHE_SETS;
  uint64_t spm_offset = CACHE_DATA_SPM_BASE + (set_index * CACHE_WAYS * 64);
  uint64_t count = 0;
  uint64_t way_index = 0;
  uint32_t lru_counter_max = 0;
  total_count++;
    // wayを決定
  for (uint64_t i = 0; i < CACHE_WAYS; ++i) {
        if (cache_metadata[set_index][i].valid) {
          if (cache_metadata[set_index][i].block_addr == dram_addr) {
            // タグが一致した場合、そのwayを使用
            way_index = i;
            tag_info.valid = true;
            tag_info.dirty = cache_metadata[set_index][i].dirty;
            tag_info.hit = true;
            tag_info.spm_offset = spm_offset;
            hit_count++;
            break;
          } else {
            // wayが空いていない時、カウンタをインクリメントしてLRUを決定
            uint32_t access_count = (cache_metadata[set_index][i].access_count + 1) & 0xF; // 4bitのアクセス数
            // LRU方式でwayを決定
            if (access_count > lru_counter_max) {
                lru_counter_max = access_count;
                way_index = i;
                tag_info.spm_offset = spm_offset;
                tag_info.valid = true;
                tag_info.dirty = cache_metadata[set_index][i].dirty;
                tag_info.block_addr = cache_metadata[set_index][i].block_addr;
            }
          }
        } else {
          // 空きwayが見つかった場合、そのwayを使用
          way_index = i;
          tag_info.spm_offset = spm_offset;
          break;
        }
        spm_offset += 64;
    }
    // 各セットはCACHE_WAYS分のラインを持つため、適切なオフセットを計算
    // カウンターをインクリメント
    for (uint64_t i = 0; i < CACHE_WAYS; ++i) {
        if (cache_metadata[set_index][i].valid &&  i != way_index) {
            uint32_t access_count = (cache_metadata[set_index][i].access_count + 1) & 0xF; // 4bitのアクセス数
            cache_metadata[set_index][i].access_count = access_count;
        }
        if (i == way_index) {
            // 選ばれたwayのカウンターをリセット
            cache_metadata[set_index][i].access_count = 0;
        }
    }
  return tag_info;
}

uint64_t calculate_level_base_addr(uint64_t level) {
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
    return ctx;
}

// uint64_t spm_offset_for_cache_set(uint64_t dram_addr) {
//     uint64_t block_addr = dram_addr & ~0x3F; // 64Bアライメント
//     uint64_t set_index = (block_addr / 64) % CACHE_SETS;
//     uint64_t way_index = 0;
//     uint32_t lru_counter_max = 0;
//     // wayを決定
//     for (uint64_t i = 0; i < CACHE_WAYS; ++i) {
//         uint64_t spm_offset = CACHE_DATA_SPM_BASE + (set_index * CACHE_WAYS * 64) + (i * 64);
//         uint64_t manage_addr = SPM_METADATA_BASE + (spm_offset / 64) * 8;
//         uint64_t info = spm_ld64(manage_addr);
//         bool valid = (info & 1) == 1;
//         uint64_t current_block_addr = (info >> 6) << 6;
//         if (valid) {
//           if (current_block_addr == block_addr) {
//             // タグが一致した場合、そのwayを使用
//             way_index = i;
//             lru_counter_max = 0; // ヒットした場合はLRUカウンタをリセット
//             info = (current_block_addr) | (0 << 2) | (info & 0x3); // アクセス数を0にリセット
//             spm_sd64(manage_addr, info);
//             break;
//           } else {
//             // wayが空いていない時、カウンタをインクリメントしてLRUを決定
//             uint32_t access_count = ((info >> 2) + 1) & 0xF; // 4bitのアクセス数
//             // LRU方式でwayを決定
//             if (access_count > lru_counter_max) {
//                 lru_counter_max = access_count;
//                 way_index = i;
//             }
//           }
//         } else {
//           // 空きwayが見つかった場合、そのwayを使用
//           way_index = i;
//           break;
//         }
//     }
//     // 各セットはCACHE_WAYS分のラインを持つため、適切なオフセットを計算
//     // カウンターをインクリメント
//     for (uint64_t i = 0; i < CACHE_WAYS; ++i) {
//         uint64_t spm_offset = CACHE_DATA_SPM_BASE + (set_index * CACHE_WAYS * 64) + (i * 64);
//         uint64_t manage_addr = SPM_METADATA_BASE + (spm_offset / 64) * 8;
//         uint64_t info = spm_ld64(manage_addr);
//         bool valid = (info & 1) == 1;
//         uint64_t current_block_addr = (info >> 6) << 6;
//         if (valid && current_block_addr != block_addr && i != way_index) {
//             uint32_t access_count = ((info >> 2) + 1) & 0xF; // 4bitのアクセス数
//             info = (info & ~(0xFUL << 2)) | (access_count << 2);
//             spm_sd64(manage_addr, info);
//         }
//     }
//     uint64_t spm_offset = CACHE_DATA_SPM_BASE + (set_index * CACHE_WAYS * 64) + (way_index * 64);
//     return spm_offset;
// }
// bool verifyTreePath(const uint64_t* path_indecis,uint64_t id){
//   uint64_t start_level = 0;
//   // 下から順に見ていく
//   struct Info tag_info;
//   uint64_t spm_offset_array[HEIGHT];
//   for (uint64_t i = HEIGHT;i>0;i--){
//     uint64_t addr = COUNTER_BASE + path_indecis[i-1] / 32 * 64 + calculate_level_base_addr(i);
//     tag_info = tag_check(addr);
//     spm_offset_array[i-1] = tag_info.spm_offset;
//     if (tag_info.hit){
//       start_level = i;
//       break;
//     } else {
      
//     }
//   }
//   for(uint64_t i=start_level; i<HEIGHT; ++i){
//     mac_init();
//     if (i == 0){
//       mac_buffer_set(0);
//       mac_update(0,63);
//     } else {
//       mac_buffer_set(spm_offset_array[i-1]);
//       uint64_t start_bit = 64 + (path_indecis[i-1] % 32) * 8;
//       mac_update(start_bit, start_bit + 7);
//     }
//     uint64_t dram_addr = COUNTER_BASE + path_indecis[i] / 32 * 64 + calculate_level_base_addr(i + 1);
//     tag_info = tag_check(dram_addr);
//     if (!tag_info.hit){
//       ensureBlockInSpm(dram_addr, tag_info);
//     }
//     // MAC計算
//     mac_buffer_set(tag_info.spm_offset);
//     mac_update(0,447);
//     uint64_t computed_mac = mac_final();
//     uint64_t stored_mac = spm_ld64(tag_info.spm_offset + 56);
//     prev_offset = tag_info.spm_offset;
//     if (computed_mac != stored_mac){
//       return false;
//     }
//   }
//   return true;
// }

// void Authentication(){
//    struct AddressContext ctx = setupAddressContext();
//    uint64_t path_indecis[HEIGHT];
//     for(uint64_t i=0; i<HEIGHT; ++i){
//       path_indecis[HEIGHT-1-i] = (ctx.request_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * i)));
//     }
//     struct Info tag_info = tag_check(ctx.counterblock_addr);
//     uint64_t spm_offset;
//     uint64_t major_counter;
//     uint64_t minor_counter_byte_address;
//     uint64_t minor_counter;
//     uint8_t minor_counter_value;
//     if (!tag_info.hit){
//         bool verified = verifyTreePath(path_indecis);
//         if (verified == false){
//             // printf("[Core FW] Authentication failed during counter verification. Aborting.\n");
//             exit(1);
//         }
//     }
//     uint64_t root = spm_ld64(0);
//     uint64_t new_root = root + 1;
//     spm_sd64(0, new_root);
//     uint64_t prev_offset = 0;
//     for (uint64_t i=0;i<HEIGHT;i++){
//       mac_init();
//       if (i == 0){
//           // 最上位層はrootノードを使う
//           mac_buffer_set(0);
//           mac_update(0, 63);
//       } else {
//           uint64_t parent_offset = path_indecis[i-1] % 32 * 8;
//           mac_buffer_set(prev_offset);
//           uint64_t start_bit = 64 + parent_offset;
//           mac_update(start_bit, start_bit + 7);
//       }
//       uint64_t dram_addr = COUNTER_BASE + path_indecis[i] / 32 * 64 + calculate_level_base_addr(i + 1);
//       tag_info = tag_check(dram_addr);
//       if (!tag_info.hit){
//           ensureBlockInSpm(dram_addr, tag_info);
//       }
//       // ここから過去のmajor, minor counterを取り出す
//       uint64_t major_counter = spm_ld64(tag_info.spm_offset);
//       uint64_t minor_counter_byte_address = tag_info.spm_offset + 8 + (path_indecis[i] % 32) / 8 * 8;
//       uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
//       // ここから過去のminor counterを取り出す
//       uint8_t minor_counter_value = (minor_counter >> ((path_indecis[i] % 8) * 8)) & 0xFF;
//       uint8_t new_minor_counter = 0;
//       if (minor_counter_value == 0xFF){
//           uint64_t new_major_counter = major_counter + 1;
//           spm_sd64(tag_info.spm_offset, new_major_counter);
//           new_minor_counter = 0; // minor counterは0に戻す
//       } else {
//           new_minor_counter = minor_counter_value + 1;
//       }
//       uint64_t shift_amount = (path_indecis[i] % 8) * 8;
//       uint64_t clear_mask = ~(0xFFULL << shift_amount);
//       uint64_t cleared_minor_counter = minor_counter & clear_mask;
//       // --- 新しい値を正しい位置へシフトする ---
//       uint64_t shifted_new_value = (new_minor_counter);
//       shifted_new_value <<= shift_amount;
//       uint64_t final_word = cleared_minor_counter | shifted_new_value;
//       // 書き戻し
//       spm_sd64(minor_counter_byte_address, final_word);
//       // ブロックをdirtyに設定する
//       uint64_t mac_manage = get_spm_manage(tag_info.spm_offset);
//       setBlockdirty(mac_manage, dram_addr);
//       // MAC計算を実行
//       // Hash関数を初期化してから当該ブロックをMAC
//       mac_buffer_set(tag_info.spm_offset);
//       mac_update(0, 447); // 448bit = 56B
//       // 親ノードのヘッダーをMACの内部バッファにセット
//       uint64_t mac_result = mac_final();
//       prev_offset = tag_info.spm_offset;
//       spm_sd64(tag_info.spm_offset + 56, mac_result);
//     }
//     major_counter = spm_ld64(tag_info.spm_offset);
//     axim_copy(ctx.spm_data);
//     // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
//     minor_counter_byte_address = tag_info.spm_offset + (ctx.counter_bit_offset / 64) * 8;
//     minor_counter = spm_ld64(minor_counter_byte_address);
//     minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64))) & 0xFF;
//     // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
//     // busy wait AESモジュールの計算完了を待つ
//     set_seed(major_counter, minor_counter_value, ctx.request_addr);
//     // --- 手順3: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
//     while(AES_START_REG);
//     write_xor(ctx.spm_data);
//     xor_start();
//     copy_xor(ctx.spm_data);
//     spm_write_back(ctx.spm_data, ctx.request_addr, 64);
//     // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
//     // ハッシュ関数の内部状態を初期化
//     // SPMに当該MACブロックがあればそのままmodify,なければ今あるブロックをDRAMにwrite backしてから適切なブロックをSPMにDRAMコピー
//     mac_init();
//     mac_buffer_set(ctx.spm_data); 
//     mac_update(0, 511);
//     mac_buffer_set(tag_info.spm_offset);
//     mac_update(ctx.counter_bit_offset, ctx.counter_bit_offset + 7); // 8bit = 1B
//     // MAC計算完了
//     uint64_t computed_mac = mac_final();
//     tag_info = tag_check(ctx.datamacblock_addr);
//     if (!tag_info.hit){
//       ensureBlockInSpm(ctx.datamacblock_addr, tag_info);
//     }
//     // SPM上のMACブロックをDirtyに設定する
//     uint64_t mac_manage = get_spm_manage(tag_info.spm_offset);
//     spm_wait_idle();
//     // --- 手順6: Hashモジュールの計算完了を待ち、結果をSPMに保存 ---
//     spm_sd64(tag_info.spm_offset + ctx.dmac_byte_offset, computed_mac);
//     setBlockdirty(mac_manage, ctx.datamacblock_addr);
//     axim_write_return();
// }

// void Verification(){
//   struct AddressContext ctx = setupAddressContext();
//   // --- 手順1.1 : ツリー検証 ---
//   // 1. パスの特定=親ノードの物理アドレスをルートまで計算していく。
//   uint64_t path_index[HEIGHT]; // 先頭は階層1
//   for(uint64_t i=0; i<HEIGHT; ++i){
//     path_index[HEIGHT-1-i] = (ctx.request_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * i)));
//   }
//   bool verified = verifyTreePath(path_index);
//   if (verified == false){
//       // printf("[Core FW] Verification failed during counter verification. Aborting.\n");
//       exit(1);
//   }
//   // --- 手順1.2 : ツリーの検証は終了、カウンターのload ---
//   spm_copy_to_local(ctx.request_addr, ctx.spm_data, 64);
//   struct Info tag_info = tag_check(ctx.counterblock_addr);
//   ensureBlockInSpm(ctx.counterblock_addr, tag_info);
//   uint64_t major_counter = spm_ld64(tag_info.spm_offset);
//   // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
//   uint64_t minor_counter = spm_ld64(tag_info.spm_offset + (ctx.counter_bit_offset / 64) * 8);
//   uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64) )) & 0xFF;
//   // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
//   // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
//   set_seed(major_counter, minor_counter_value, ctx.request_addr);
//   // --- 手順3: SPM DMAを起動し、DRAMから暗号文をSPMにコピー ---
//   mac_init();
//   mac_buffer_set(ctx.spm_data);
//   mac_update(0, 511);
//   // SPMからカウンターブロックをコピーし、update
//   mac_buffer_set(tag_info.spm_offset);
//   mac_update(ctx.counter_bit_offset, ctx.counter_bit_offset + 7); 
//   // MAC計算完了
//   // --- 手順6: Hashモジュールの計算完了を待ち、結果を取得しSPMから正しい結果をload ---
//   uint64_t mac_result = mac_final();
//   // SPMに当該MACブロックがあるかを確認。なければコピー。
//   tag_info = tag_check(ctx.datamacblock_addr);
//   ensureBlockInSpm(ctx.datamacblock_addr, tag_info);
//   spm_wait_idle();
//   uint64_t expected_mac = spm_ld64(tag_info.spm_offset + ctx.dmac_byte_offset);
//   if (mac_result != expected_mac) {
//       // printf("[Core FW] Verification failed: MAC mismatch! Computed: %016llx, Expected: %016llx\n", mac_result, expected_mac);
//       // エラー処理: MAC不一致
//       exit(1);
//   }
//   // --- 手順7: AXI managerに対し、read bufferにあるデータをリターンするように指示 ---
//   while(AES_START_REG); // busy待ち
//   write_xor(ctx.spm_data);
//   xor_start();
//   copy_xor(ctx.spm_data);
//   axim_write(ctx.spm_data);
//   axim_read_return();
// }
// // カウンターがオーバーフローした場合の再暗号化とデータMACの再計算
// // void Reencryption(uint64_t block_addr, uint64_t major_counter, uint8_t old_minor_counter, uint64_t block_manage, uint64_t mac_manage){
// //     ensureBlockInSpm(block_addr, 0x1 * 64);
// //     // 復号化
// //     set_seed(major_counter, old_minor_counter, block_addr);
// //     // AXI Managerに暗号文をコピーし、XORを実行して復号化

// //     // 次に、暗号化
// //     set_seed(major_counter + 1, 0, block_addr);
// //     // AXI Managerに平文とOTPをコピーし、XORを実行して暗号化
// //     // SPMに書き戻し
// //     // データMACの再計算
// //     mac_init();
// //     mac_buffer_set(0x1 * 64);
// //     mac_update(0, 511);
// //     mac_buffer_set(0x0C0);
// //     mac_update(64, 71);
// //     uint64_t new_mac = mac_final();
// // }
static inline uint64_t decryption_only(uint64_t id){
    struct AddressContext ctx = setupAddressContext();
    struct Info tag_info = tag_check(ctx.counterblock_addr);
      // --- 手順1: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
    // printf("[Core FW] Decryption: spm_offset=%016llx\n", spm_offset);
    uint64_t counter_id = id;
    if (!tag_info.hit){
      counter_id += 1;
      counter_id = ensureBlockInSpm(ctx.counterblock_addr, tag_info, counter_id);
    }
    uint64_t data_id = counter_id + 1;
    spm_copy_to_local(ctx.request_addr, ctx.spm_data, 64,data_id);
    if (!tag_info.hit){
      spm_wait(counter_id);
    }
    uint64_t major_counter = spm_ld64(tag_info.spm_offset);
    // // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
    uint64_t minor_counter_byte_address = tag_info.spm_offset + (ctx.counter_bit_offset / 64) * 8;
    uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
    uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64) )) & 0xFF;
    set_seed(major_counter, minor_counter_value, ctx.request_addr);
    // --- 手順2: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
    // SPM DMAを起動し、DRAMから暗号文をSPMにコピー
    while(AES_START_REG); // busy待ち    
    spm_wait(data_id);
    write_xor(ctx.spm_data);
    xor_start();
    copy_xor(ctx.spm_data);
    axim_write(ctx.spm_data);
    // // --- 手順3: SPM DMAを起動し、SPMからDRAMへ暗号文をwrite back ---
    axim_read_return();
    return data_id;
}
uint64_t encryption_only(uint64_t id){
    // setStats(1);
    struct AddressContext ctx = setupAddressContext();
    struct Info tag_info = tag_check(ctx.counterblock_addr);
    uint64_t counter_id = id;
    if (!tag_info.hit){
      counter_id += 1;
      counter_id = ensureBlockInSpm(ctx.counterblock_addr, tag_info, counter_id);
      spm_wait(counter_id);
    }
    uint64_t major_counter = spm_ld64(tag_info.spm_offset);
    // minor_counterのload
    // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
    uint64_t minor_counter_byte_address = tag_info.spm_offset + (ctx.counter_bit_offset / 64) * 8;
    uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
    uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64) )) & 0xFF;
    minor_counter_value += 1; // インクリメント
    set_seed(major_counter, minor_counter_value, ctx.request_addr);
    // minor counterの書き戻し
    uint64_t shift_amount = (ctx.counter_bit_offset % 64);
    uint64_t clear_mask = ~(0xFFULL << shift_amount);
    uint64_t cleared_minor_counter = minor_counter & clear_mask;
    // --- 新しい値を正しい位置へシフトする ---
    uint64_t shifted_new_value = (minor_counter_value);
    shifted_new_value <<= shift_amount;
    uint64_t final_word = cleared_minor_counter | shifted_new_value;
    // 書き戻し
    spm_sd64(minor_counter_byte_address, final_word);
    // ブロックをdirtyに設定する
    setBlockdirty(tag_info.spm_offset);
    // --- 手順2: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
    // SPM DMAを起動し、DRAMから平文をSPMにコピー
    axim_copy(ctx.spm_data);
    while(AES_START_REG); // busy待ち
    write_xor(ctx.spm_data);
    xor_start();
    copy_xor(ctx.spm_data);
    // --- 手順3: SPM DMAを起動し、SPMからDRAMへ暗号文をwrite back ---
    spm_write_back(ctx.spm_data, ctx.request_addr, 64,counter_id + 1);
    axim_write_return();
    return counter_id + 1;
}
uint64_t write_only(uint64_t id){
    axim_copy(0x040);
    // --- 手順3: SPM DMAを起動し、SPMからDRAMへ暗号文をwrite back ---
    id += 1;
    spm_write_back(0x040, AXIM_REQ_ADDR_REG, 64,id);
    axim_write_return();
    return id;
}
uint64_t read_only(uint64_t id){
    // struct AddressContext ctx = setupAddressContext();
    id += 1;
    spm_copy_to_local(AXIM_REQ_ADDR_REG, 0x040, 64,id);
    spm_copy_to_local(AXIM_REQ_ADDR_REG - 0x90000000, 0x080, 64,id+1);
    spm_wait(id);
    axim_write(0x040);
    axim_read_return();
    return id;
}
uint64_t decryption_tag(uint64_t id){
    struct AddressContext ctx = setupAddressContext();
    struct Info tag_info = tag_check(ctx.counterblock_addr);
    uint64_t counter_id = id;
    if (!tag_info.hit){
      counter_id += 1;
      counter_id = ensureBlockInSpm(ctx.counterblock_addr, tag_info, counter_id);
    }
    uint64_t data_id = counter_id + 1;
    spm_copy_to_local(ctx.request_addr, ctx.spm_data, 64,data_id);
    if (!tag_info.hit){
      // printf("[Core FW] Decryption Tag: Waiting for counter block id %llu %llu\n", counter_id, SPM_COMPLETE_ID);
      spm_wait(counter_id);
    }
    uint64_t major_counter = spm_ld64(tag_info.spm_offset);
    // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
    uint64_t minor_counter_byte_address = tag_info.spm_offset + (ctx.counter_bit_offset / 64) * 8;
    uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
    uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64) )) & 0xFF;
    set_seed(major_counter, minor_counter_value, ctx.request_addr);
    struct Info data_tag_info = tag_check(ctx.datamacblock_addr);
    uint64_t tag_id = data_id;
    if (!data_tag_info.hit){
      tag_id += 1;
      tag_id = ensureBlockInSpm(ctx.datamacblock_addr, data_tag_info, tag_id);
    }
    spm_wait(data_id);
    while(AES_START_REG); // busy待ち
    write_xor(ctx.spm_data);
    xor_start();
    copy_xor(ctx.spm_data+0x40);
    axim_write(ctx.spm_data+0x40);
    axim_read_return();
    mac_init();
    mac_buffer_set(ctx.spm_data);
    mac_update(0, 511);
    // SPMからカウンターブロックをコピーし、update
    mac_buffer_set(tag_info.spm_offset);
    mac_update(ctx.counter_bit_offset, ctx.counter_bit_offset + 7); 
    // MAC計算完了
    // --- 手順6: Hashモジュールの計算完了を待ち、結果を取得しSPMから正しい結果をload ---
    // SPMに当該MACブロックがあるかを確認。なければコピー。
    uint64_t mac_result = mac_final();
    if (!data_tag_info.hit){
      spm_wait(tag_id);
    }
    uint64_t expected_mac = spm_ld64(data_tag_info.spm_offset + ctx.dmac_byte_offset);
    if (mac_result != expected_mac) {
        exit(1);
    }
    return tag_id;
}

uint64_t encryption_tag(uint64_t id){
    struct AddressContext ctx = setupAddressContext();
    struct Info tag_info = tag_check(ctx.counterblock_addr);
    uint64_t counter_id = id;
    if (!tag_info.hit){
      counter_id += 1;
      counter_id = ensureBlockInSpm(ctx.counterblock_addr, tag_info, counter_id);
      spm_wait(counter_id);
    }
    axim_copy(ctx.spm_data);
    // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
    uint64_t major_counter = spm_ld64(tag_info.spm_offset);
    uint64_t minor_counter_byte_address = tag_info.spm_offset + (ctx.counter_bit_offset / 64) * 8;
    uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
    uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64))) & 0xFF;
    uint8_t new_minor_counter_value = minor_counter_value + 1; // インクリメント
    // minor counterの書き戻し
    uint64_t shift_amount = (ctx.counter_bit_offset % 64);
    uint64_t clear_mask = ~(0xFFULL << shift_amount);
    uint64_t cleared_minor_counter = minor_counter & clear_mask;
    // --- 新しい値を正しい位置へシフトする ---
    uint64_t shifted_new_value = (new_minor_counter_value) << shift_amount;
    uint64_t final_word = cleared_minor_counter | shifted_new_value;
    // 書き戻し
    spm_sd64(minor_counter_byte_address, final_word);
    set_seed(major_counter, new_minor_counter_value, ctx.request_addr);
    setBlockdirty(tag_info.spm_offset);    
    // --- 手順3: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
    struct Info data_tag_info = tag_check(ctx.datamacblock_addr);
    uint64_t tag_id = counter_id;
    if (!data_tag_info.hit){
      tag_id += 1;
      tag_id = ensureBlockInSpm(ctx.datamacblock_addr, data_tag_info, tag_id);
    }
    while(AES_START_REG); // busy待ち
    write_xor(ctx.spm_data);
    xor_start();
    copy_xor(ctx.spm_data);
    spm_write_back(ctx.spm_data, ctx.request_addr, 64,tag_id + 1);
    axim_write_return();
    // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
    // ハッシュ関数の内部状態を初期化
    // SPMに当該MACブロックがあればそのままmodify,なければ今あるブロックをDRAMにwrite backしてから適切なブロックをSPMにDRAMコピー
    mac_init();
    mac_buffer_set(ctx.spm_data); 
    mac_update(0, 511);
    mac_buffer_set(tag_info.spm_offset);
    mac_update(ctx.counter_bit_offset, ctx.counter_bit_offset + 7); // 8bit = 1B
    // MAC計算完了
    uint64_t computed_mac = mac_final();
    if (!data_tag_info.hit){
      spm_wait(tag_id);
    }
    // --- 手順6: Hashモジュールの計算完了を待ち、結果をSPMに保存 ---
    spm_sd64(data_tag_info.spm_offset + ctx.dmac_byte_offset, computed_mac);
    // SPM上のMACブロックをDirtyに設定する
    setBlockdirty(data_tag_info.spm_offset);
    return tag_id+1;
}
int main(void){
  /* MEMREQの設定 */
  // memreq_make(size, 2); // 64B, 1リクエスト
  for (uint64_t i=0; i<512; i++){
    spm_sd64(i*8, 0); // SPMの初期化
  }
  spm_sd64(0,1); // rootノードの初期化
  uint64_t dma_id = 0;
  // setStats(1);
  while(1){
    for(;;){
      if(AXIM_STATUS_REG & 1) break; // リクエストが来るまで待つ
    }
    uint64_t addr = AXIM_REQ_ADDR_REG;
    if (addr == 0xFFFFFFFFFFFFFFFF){
      return 0;
    } else {
      if(AXIM_STATUS_REG & 2){ // writeリクエスト
        // dma_id = write_only(dma_id);
        dma_id = encryption_only(dma_id);
        // dma_id = encryption_tag(dma_id);
        // Authentication();
      } else {
        // dma_id = read_only(dma_id);
        dma_id = decryption_only(dma_id);
        // dma_id = decryption_tag(dma_id);
        // Verification();
      }
    }
  }
}

