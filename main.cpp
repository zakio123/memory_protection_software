#include <iostream>
#include <vector>
#include <iomanip>

// すべてのハードウェアコンポーネントの定義をインクルード
#include "memory_map.hpp"
#include "dram.hpp"
#include "spm.hpp"
#include "bus.hpp"
#include "riscv_core.hpp"
#include "spm_module.hpp"
#include "hash_module.hpp"
#include "aes_module.hpp"
#include "axi_manager_module.hpp"

int main() {
    // --- 1. ハードウェアコンポーネントのインスタンス化 ---
    // 依存関係のない基本コンポーネントから生成
    Dram dram;
    Spm spm;

    // 各MMIOモジュールを生成
    // (依存関係のあるモジュールは、依存先への参照をコンストラクタで渡す)
    SpmModule spm_mod(dram, spm);
    HashModule hash_mod(spm);
    AxiManagerModule axi_mgr_mod(spm); // AXI ManagerはSPMにアクセスする
    AesModule aes_mod(axi_mgr_mod);   // AESはAXI ManagerのFIFOにOTPを供給する

    // バスとコアを生成
    Bus bus(dram, spm);
    RiscVCore core(bus);

    // --- 2. コンポーネント間の接続 (Wiring) ---
    // Busに各MMIOモジュールを接続する
    bus.connectSpmModule(spm_mod);
    bus.connectHashModule(hash_mod);
    bus.connectAesModule(aes_mod);
    bus.connectAxiManagerModule(axi_mgr_mod);
    
    std::cout << "--- System Initialized ---\n";


    // --- 3. DRAMの初期化 (テストデータの設定) ---
    const uint32_t DRAM_TEST_DATA_ADDR = 0x10000;
    // 期待される平文データ
    std::vector<uint8_t> plaintext_data(64);
    for(size_t i = 0; i < plaintext_data.size(); ++i) plaintext_data[i] = static_cast<uint8_t>(i);
    // 暗号化されたデータをDRAMに書き込み (簡易的なXOR暗号)
    std::vector<uint8_t> encrypted_data = plaintext_data;
    for(auto& byte : encrypted_data) byte ^= 0xCC;
    dram.write(DRAM_TEST_DATA_ADDR, encrypted_data.data(), encrypted_data.size());
    std::cout << "[Setup] Wrote encrypted test data to DRAM.\n";


    // --- 4. LLCの役割として、リクエストとコールバックを発行 ---
    bool test_passed = false;
    uint32_t target_address = DRAM_TEST_DATA_ADDR;

    std::cout << "\n[LLC] Issuing read request for address 0x" 
              << std::hex << target_address << std::dec
              << " with a callback.\n";
              
    axi_mgr_mod.receiveLlcReadRequest(target_address, 123, 
        // C++のラムダ式で、完了時に実行されるコールバック処理を定義
        [&](const AxiManagerModule::DataBlock& final_data) {
            std::cout << "\n--- Callback Executed in LLC ---\n";
            std::cout << "[LLC] Received response data via callback.\n";
            
            // Vectorに変換して比較
            std::vector<uint8_t> received_data(final_data.begin(), final_data.end());

            if (received_data == plaintext_data) {
                std::cout << "✅ [SUCCESS] Decrypted data matches original plaintext!\n";
                test_passed = true;
            } else {
                std::cout << "❌ [FAILURE] Data mismatch detected!\n";
            }
        }
    );


    // --- 5. シミュレーション実行 ---
    // コアのメインループを開始する。これにより、コアがAXI Managerの要求を検知し、
    // 一連のハードウェア制御（ファームウェア実行）が開始される。
    core.runMainLoop();


    // --- 6. 最終結果の確認 ---
    std::cout << "\n--- Simulation Finished ---\n";
    if (test_passed) {
        std::cout << "Final Test Status: PASSED\n";
    } else {
        std::cout << "Final Test Status: FAILED\n";
    }

    return 0;
}