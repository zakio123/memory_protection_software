#pragma once
#include "bus.hpp"
#include "memory_map.hpp"
#include <iostream>
#include <vector>

class RiscVCore {
public:
    /**
     * @brief コンストラクタ
     * @param bus コアがアクセスするシステムバスへの参照
     */
    RiscVCore(Bus& bus) : m_bus(bus) {}

    /**
     * @brief コアのメインループ。外部からのリクエストを待って処理を開始する。
     */
    void runMainLoop() {
        std::cout << "[Core] Started. Polling for requests from AXI Manager...\n";

        // AXI ManagerのSTATUSレジスタをポーリングし、リクエストがキューに入るのを待つ
        while ((m_bus.read64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::STATUS) & 1) == 0) {
            // In a real system, the core might enter a low-power state here.
        }
        
        std::cout << "[Core] Request detected in AXI Manager's queue.\n";
        
        // リクエストを処理するアルゴリズムを実行
        if (m_bus.read64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::STATUS) & 2) {
            runAuthentication();
        } else {
            runVerification();
        }
    }

private:
    // 各種アドレス計算ヘルパーメソッド
    uint64_t counterblock_address(uint64_t request_addr) {
        // キャッシュラインに対応するカウンターブロック(64B単位)の先頭アドレスを計算して返す
        // Byte単位
    },
    uint64_t counterblock_offset(uint64_t request_addr) {
        // キャッシュラインに対応するカウンターブロック(64B単位)内でのオフセットを計算して返す
        // bit単位で返すことに注意

    },
    uint64_t data_mac_address(uint64_t request_addr) {
        // キャッシュラインに対応するData MAC(64B単位)の先頭アドレスを計算して返す
        // Byte単位
    },
    uint64_t data_mac_offset(uint64_t request_addr) {
        // キャッシュラインに対応するData MAC(64B単位)内でのオフセットを計算して返す
        // Byte単位

    },
    // SPM内の特別な配置 64B * 64lines(0x0000 - 0x7FFFのアドレス空間)
    // - 0x000-0x03F: 暗号文(64B)
    // - 0x040-0x07F: MAC(64B)
    // - 0x080-0x27F: カウンターブロック(64B * 8 = 512B)
    // - 0x600-0x7FF: その他のデータ領域
    /**
     * @brief コア上で実行されるファームウェア/ドライバに相当するアルゴリズム
     */
    void runAuthentication() {
        std::cout << "[Core FW] --- Authentication Start ---\n";
        // --- 手順0: AXI Managerのリクエスト内容を確認し、必要な初期化を実施 ---
        // アドレスを取得
        uint64_t request_addr = m_bus.read64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::REQ_ADDR);
        std::cout << "[Core FW] Request Address: 0x" << std::hex << request_addr << std::dec << "\n";
        // 物理アドレスを計算、カウンターとdata mac
        uint64_t counterblock_addr = counterblock_address(request_addr);
        uint64_t data_mac_addr = data_mac_address(request_addr);
        uint64_t counter_offset = counterblock_offset(request_addr);
        uint64_t dmac_offset = data_mac_offset(request_addr);

        // SPMアドレスを計算
        uint64_t spm_data_addr = MemoryMap::SPM_BASE_ADDR + 0x000; // 暗号文
        uint64_t spm_mac_addr = MemoryMap::SPM_BASE_ADDR + 0x040; // MAC
        uint64_t spm_counter_addr = MemoryMap::SPM_BASE_ADDR + 0x080 + (counter_offset / 8); // カウンター
        // SPM管理アドレスの計算.カウンターとMACの現在データを確かめるために
        uint64_t spm_counter_manager_addr = ;
        uint64_t spm_mac_manager_addr = ;

        // --- 手順1: SPMからカウンターを読み取り、インクリメントしてSPMに書き戻し ---
        // 初めにspmにあるカウンターのアドレスを確認する
        std::cout << "[Core FW] Step 1: Handling counter block in SPM...\n";
        uint64_t current_counterblock_info = m_bus.read64(spm_counter_manager_addr);
        uint64_t current_mac_info = m_bus.read64(spm_mac_manager_addr);
        if ((current_counterblock_info >> 6) != (counterblock_addr >> 6)) {
            // 必要なカウンターブロックがSPMにない
            // 3つのケース
            // 1. SPMが空の場合: そのままDRAMから読み込み
            // 2. 既にSPMにあるカウンターブロックがdirtyの場合: 既存のブロックをDRAMに書き戻し、新しいブロックをDRAMから読み込み
            // 3. 既にSPMにあるカウンターブロックがcleanの場合: そのまま新しいブロックをDRAMから読み込み
            if ((current_counterblock_info & 2) == 1) {
                // 該当ブロックがdirtyの場合、write-backを行う
                // write-back
                uint64_t dram_writeback_addr = (current_counterblock_info >> 6) << 6; // 64Bアラインメント
                while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DRAM_ADDR, dram_writeback_addr);
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SPM_ADDR, spm_counterblock_addr);
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SIZE, 64); // 64B
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DIRECTION, 1); // SPM -> DRAM
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START, 1);
                while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
                std::cout << "[Core FW] Existing counter block written back to DRAM.\n";
            }
            // 新しいカウンターブロックをDRAMからSPMに読み込み
            while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DRAM_ADDR, counterblock_addr);
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SPM_ADDR, spm_counterblock_addr);
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SIZE, 64); // 64B
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DIRECTION, 0); // DRAM -> SPM
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START, 1);
            while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
            std::cout << "[Core FW] New counter block loaded from DRAM to SPM.\n";
        }
        // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---

        // --- 手順3: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---

        // --- 手順4: AXI Managerに暗号文をSPMにコピーするよう指示 ---

        // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---

        // --- 手順6: Hashモジュールの計算完了を待ち、結果をSPMに保存 ---
        // SPMに当該MACブロックがあればそのままmodify,なければ今あるブロックをDRAMにwrite backしてから適切なブロックをSPMにDRAMコピー

        // --- 手順7: SPM DMAを起動し、SPMからDRAMへ暗号文をwrite back ---

        // --- 手順8: AXI managerに対し、write ackの完了を通知 ---
        // busy wait
        while(m_bus.read64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::BUSY) != 0) {}
        m_bus.write64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::COMMAND, 16); // 16: Write Ack

        std::cout << "[Core FW] --- Authentication Finished ---\n";
    }
    void runVerification() {
        std::cout << "[Core FW] --- Verification Start ---\n";
        // --- 手順1: SPMからカウンターをload ---
        // 初めにspmにあるカウンターのアドレスを確認する
        std::cout << "[Core FW] Step 1: Handling counter block in SPM...\n";
        uint64_t current_counterblock_info = m_bus.read64(spm_counter_manager_addr);
        uint64_t current_mac_info = m_bus.read64(spm_mac_manager_addr);
        if ((current_counterblock_info >> 6) != (counterblock_addr >> 6)) {
            // 必要なカウンターブロックがSPMにない
            // 3つのケース
            // 1. SPMが空の場合: そのままDRAMから読み込み
            // 2. 既にSPMにあるカウンターブロックがdirtyの場合: 既存のブロックをDRAMに書き戻し、新しいブロックをDRAMから読み込み
            // 3. 既にSPMにあるカウンターブロックがcleanの場合: そのまま新しいブロックをDRAMから読み込み
            if ((current_counterblock_info & 2) == 1) {
                // 該当ブロックがdirtyの場合、write-backを行う
                // write-back
                uint64_t dram_writeback_addr = (current_counterblock_info >> 6) << 6; // 64Bアラインメント
                while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DRAM_ADDR, dram_writeback_addr);
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SPM_ADDR, spm_counterblock_addr);
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SIZE, 64); // 64B
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DIRECTION, 1); // SPM -> DRAM
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START, 1);
                while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
                std::cout << "[Core FW] Existing counter block written back to DRAM.\n";
            }
            // 新しいカウンターブロックをDRAMからSPMに読み込み
            while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DRAM_ADDR, counterblock_addr);
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SPM_ADDR, spm_counterblock_addr);
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SIZE, 64); // 64B
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DIRECTION, 0); // DRAM -> SPM
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START, 1);
            while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
            std::cout << "[Core FW] New counter block loaded from DRAM to SPM.\n";
        }
        // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
        uint64_t seed_0 = ;
        uint64_t seed_1 = ;
        uint64_t seed_2 = ;
        uint64_t seed_3 = ;
        uint64_t seed_4 = ;
        uint64_t seed_5 = ;
        uint64_t seed_6 = ;
        uint64_t seed_7 = ;
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + AesReg::INPUT_0, seed_0);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + AesReg::INPUT_1, seed_1);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + AesReg::INPUT_2, seed_2);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + AesReg::INPUT_3, seed_3);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + AesReg::INPUT_4, seed_4);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + AesReg::INPUT_5, seed_5);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + AesReg::INPUT_6, seed_6);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + AesReg::INPUT_7, seed_7);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + AesReg::START, 1); 
        // --- 手順3: SPM DMAを起動し、DRAMから暗号文をSPMにコピー ---
        std::cout << "[Core FW] Step 3: Commanding SPM DMA to copy ciphertext from DRAM to SPM...\n";
        while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DRAM_ADDR, request_addr);
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SPM_ADDR, spm_data_addr);
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SIZE, 64); // 64B
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DIRECTION, 0); // DRAM -> SPM
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START, 1);
        while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
        std::cout << "[Core FW] Ciphertext loaded from DRAM to SPM.\n";
        // --- 手順3: AXI ManagerにOTPとともにXORを実行し、復号化を指示 ---
        // AESの完了を待つ
        while(m_bus.read64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + AesReg::START) != 0) {}
        // 復号化を指示
        std::cout << "[Core FW] Step 4: Commanding AXI Manager to decrypt ciphertext in SPM...\n";
        // busy wait
        while(m_bus.read64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::BUSY) != 0) {}
        m_bus.write64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::COMMAND, 8); // 8: Decrypt Data in SPM

        // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
        std::cout << "[Core FW] Step 5: Commanding Hash module to compute MAC...\n";
        // ハッシュ関数の内部状態を初期化
        while(m_bus.read64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::START) != 0) {}
        m_bus.write64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::COMMAND, 1); // 1: Initialize
        // busy wait
        while(m_bus.read64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::START) != 0) {}
        // SPMから暗号文をコピー
        m_bus.write64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::SPM_Reg::SPM_ADDR, spm_data_addr);
        m_bus.write64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::SPM_Reg::SPM_START, 1); // 先頭から
        while(m_bus.read64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::START) != 0) {}
        // MAC計算を開始
        m_bus.write64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::START_BIT,0); // 512bit
        m_bus.write64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::END_BIT,511);
        m_bus.write64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::COMMAND, 2); // 2: MAC Update
        while(m_bus.read64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::STATUS) != 0) {}
        // SPMからカウンターブロックをコピー
        m_bus.write64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::SPM_Reg::SPM_ADDR, spm_counter_addr);
        m_bus.write64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::SPM_Reg::SPM_START, 1); // 先頭から
        while(m_bus.read64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::START) != 0) {}
        m_bus.write64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::START_BIT,_); // todo: correct start bit length
        m_bus.write64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::END_BIT,_); // todo: correct end bit length
        m_bus.write64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::COMMAND, 2); // 2: MAC Update
        while(m_bus.read64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::STATUS) != 0) {}
        // MAC計算完了
        m_bus.write64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::COMMAND, 4); // 4: MAC Finalize
        while(m_bus.read64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::STATUS) != 0) {}
        // --- 手順6: Hashモジュールの計算完了を待ち、結果を取得しSPMから正しい結果をload ---
        uint64_t mac_result = m_bus.read64(MemoryMap::MMIO_HASH_ACCEL_BASE_ADDR + MemoryMap::HashReg::MAC_RESULT);
        // SPMに当該MACブロックがあるかを確認。なければコピー。
        if (current_mac_info & 1 == 1) {
            // dirtyの時はwrite-back
            if (current_mac_info & 2 == 1) {
                // write-back
                uint64_t dram_writeback_addr = (current_mac_info >> 6) << 6; // 64Bアラインメント
                while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DRAM_ADDR, dram_writeback_addr);
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SPM_ADDR, spm_mac_addr);
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SIZE, 64); // 64B
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DIRECTION, 1); // SPM -> DRAM
                m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START, 1);
                while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
                std::cout << "[Core FW] Existing MAC block written back to DRAM.\n";
            }
            // 新しいMACブロックをDRAMからSPMに読み込み
            while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DRAM_ADDR, data_mac_addr);
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SPM_ADDR, spm_mac_addr);
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SIZE, 64); // 64B
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DIRECTION, 0); // DRAM -> SPM
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START, 1);
            while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
            std::cout << "[Core FW] New MAC block loaded from DRAM to SPM.\n";
        } else {
            // SPMが空の場合: そのままDRAMから読み込み
            while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DRAM_ADDR, data_mac_addr);
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SPM_ADDR, spm_mac_addr);
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SIZE, 64); // 64B
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DIRECTION, 0); // DRAM -> SPM
            m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START, 1);
            while(m_bus.read64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START) != 0) {}
        }
        uint64_t expected_mac = m_bus.read64(spm_mac_addr); // todo: SPMから読み取る。SPM MACアドレスを確認
        if (mac_result != expected_mac) {
            std::cout << "[Core FW] MAC verification failed. Aborting operation.\n";
            // エラー処理: MAC不一致
            // AXI Managerにエラーを通知するなど
            return;
        }
        std::cout << "[Core FW] MAC verification succeeded.\n";
        
        // --- 手順7: AXI managerに対し、read bufferにあるデータをリターンするように指示 ---
        std::cout << "[Core FW] Step 7: Commanding AXI manager to return data in read buffer...\n";
        // busy wait
        while(m_bus.read64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::BUSY) != 0) {}
        m_bus.write64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::COMMAND, 32); // 1: Return Data
        std::cout << "[Core FW] --- Algorithm Finished ---\n";
    }

private:
    Bus& m_bus;
};