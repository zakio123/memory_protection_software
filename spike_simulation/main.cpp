// src/main.cpp

#include <stdint.h>
#include <stdio.h>

// ------------------------------------------------------------
// 1. C言語の資産をインクルード (マングリング防止)
// ------------------------------------------------------------
extern "C" {
    #include "mmio_reg/spm_reg.h"
    #include "mmio_reg/reg_map.h"
    #include "mmio_reg/mac_reg.h"
    #include "mmio_reg/aes_reg.h"
    #include "mmio_reg/axim_reg.h"
    #include "mmio_reg/xor_reg.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdbool.h>
}

// ------------------------------------------------------------
// 2. C++のクラス定義をインクルード
// ------------------------------------------------------------
#include "inc/config.h"
#include "inc/spm_mgmt.hpp" // 前回作成した SpmManager/SpmHandle

// ------------------------------------------------------------
// 3. ロジック実装 (Verification)
//    - RAIIにより、push_temp_buffer が不要になります
// ------------------------------------------------------------
dma_id_t Verification(dma_id_t id, dram_addr_t request_addr) {
    // // A. パス上のノード確保 (RAII: コンストラクタで自動ロード/共有)
    // //    スコープを抜けると自動で解放されるため、後始末のコードは不要です。
    // SpmHandle handles[HEIGHT];
    // uint64_t path_indices[HEIGHT];
    // dram_addr_t dram_addrs[HEIGHT];

    // // アドレス計算 & ハンドル取得 (連続発行)
    // for (uint64_t i = 0; i < HEIGHT; ++i) {
    //     uint64_t index = (request_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * i)));
    //     path_indices[HEIGHT - 1 - i] = index;
        
    //     dram_addr_t d_addr = COUNTER_BASE + index / 32 * 64 + calculate_level_base_addr(HEIGHT - i);
    //     dram_addrs[HEIGHT - 1 - i] = d_addr;

    //     // ★ ここで自動的に Cache検索 -> Temp確保 -> DMA発行 が行われる
    //     handles[HEIGHT - 1 - i] = SpmHandle(d_addr, id);
    // }

    // // データ用とMAC用も確保
    // dma_id_t data_id = id + 1;
    // SpmHandle data_handle(request_addr, data_id);
    
    // dram_addr_t mac_addr = get_datamacblock_addr(request_addr);
    // dma_id_t mac_id = data_id + 1;
    // SpmHandle mac_tag_handle(mac_addr, mac_id);

    // // B. バリア同期 (最後に発行したIDを待つ)
    // spm_wait(mac_id);

    // // C. 検証処理
    // for (uint64_t i = 0; i < HEIGHT; i++) {
    //     // ハンドルからオフセットを取得 (.get())
    //     spm_offset_t curr = handles[i].get();
    //     spm_offset_t parent = (i == 0) ? 0 : handles[i-1].get();

    //     if (!verify_one_height(curr, parent, path_indices[i], id)) {
    //         printf("[Core FW] Verification failed at level %lu\n", i);
    //         exit(1); 
    //         // ★ exitしても、handles配列のデストラクタが走り、
    //         //    Temp領域は正しく解放されます (メモリリークなし)
    //     }
    // }

    // // ... (Seed計算、MAC計算など) ...

    // // D. キャッシュ管理 (昇格)
    // // 検証に成功したので、今回ロードしたTempブロックをCacheに昇格させる
    // for (uint64_t i = 0; i < HEIGHT; i++) {
    //     // ヒットしていなかった(Tempにある)場合のみ昇格処理
    //     // handle内部で状態判定して処理してくれる
    //     handles[i].promote(); 
    // }

    // // E. データの転送指示など
    // while(AES_START_REG); 
    // write_xor(DATA_SPM_OFFSET);
    // xor_start(false, true);
    // axim_read_return();

    // // ★ 関数終了: handles配列などのデストラクタが起動
    // // -> Tempとして確保されたまま(Promoteされなかった)ものは解放(Free)
    // // -> PromoteされたものはCacheとして維持
    // // -> 元々Cacheだったものは何もしない
    return id;
}

// Authentication も同様に書き換え可能...
dma_id_t Authentication(dma_id_t id, dram_addr_t request_addr) {
    // Authenticationの実装も同様にRAIIを活用して書き換え可能
    return id;
}

// ------------------------------------------------------------
// 4. メイン関数
// ------------------------------------------------------------
// crt.S から呼ばれるため、名前マングリングを防ぐ
extern "C" int main(void) {
    // for (uint64_t i = 0; i < 512; i++) {
    //     spm_sd64(i * 8, 0);
    // }
    // // Rootノード初期化
    // spm_sd64(0, 1);

    // ★ マネージャの初期化 (シングルトン生成)
    // これで内部の metadata や free_stack が初期化される
    // init_cache_system() の代わり
    // SpmManager::getInstance(); 
    // ※ TempManager / UnifiedSpmManager どちらを採用した場合でもここを呼ぶ
    dma_id_t dma_id = 0;
    uint64_t request_count = AXIM_STATUS_REG + 1;
    printf("[Core FW] Initializing SpmManager for %llu requests.\n", request_count);
    printf("[Core FW] C++ Firmware Started.\n");
    // while (1) {
    //     // AXIリクエスト待ち
    //     while (!(AXIM_STATUS_REG & 1));
    //     dram_addr_t addr = AXIM_REQ_ADDR_REG;
    //     // 終了判定
    //     if (addr == 0xFFFFFFFFFFFFFFFF) {
    //         return 0;
    //     }
    //     if (AXIM_STATUS_REG & 2) { // Write Request
    //         dma_id = Authentication(dma_id, addr);
    //     } else { // Read Request
    //         dma_id = Verification(dma_id, addr);
    //     }
    // }
    
    return 0;
}