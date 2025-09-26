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
    // --- 1. アドレス計算をまとめるための構造体とメソッド ---
    struct AddressContext {
        uint64_t request_addr;
        uint64_t counterblock_addr, datamacblock_addr;
        uint64_t counter_bit_offset, dmac_byte_offset;
        uint64_t spm_data, spm_mac_block, spm_counter_block;
        uint64_t spm_counter_manage, spm_mac_manage;
    };

    AddressContext setupAddressContext() {
        AddressContext ctx;
        ctx.request_addr = m_bus.read64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::REQ_ADDR);
        
        // DRAMアドレス
        ctx.counterblock_addr = MemoryMap::COUNTER_BASE_ADDR + ((ctx.request_addr / (64 * 64))) * 64;
        ctx.datamacblock_addr = MemoryMap::DATA_TAG_BASE_ADDR + ((ctx.request_addr / (64 * 8))) * 64;
        
        // オフセット
        ctx.counter_bit_offset = 64 + (ctx.request_addr / 64) % 64 * 4;
        ctx.dmac_byte_offset = (ctx.request_addr / 64) % 8 * 8;

        // SPMアドレス
        ctx.spm_data = MemoryMap::SPM_BASE_ADDR + 0x000;
        ctx.spm_mac_block = MemoryMap::SPM_BASE_ADDR + 0x040;
        ctx.spm_counter_block = MemoryMap::SPM_BASE_ADDR + 0x080;
        ctx.spm_counter_manage = MemoryMap::SPM_BASE_ADDR + (1+56)*8;
        ctx.spm_mac_manage = MemoryMap::SPM_BASE_ADDR + (2+56)*8;
        
        return ctx;
    }
    // --- 2. SPMキャッシュ管理ロジックを共通化 ---
    /**
     * @brief 指定されたブロックがSPMに存在することを確認し、なければロードする
     * @param required_block_addr DRAM上の必要なブロックの先頭アドレス
     * @param spm_block_addr SPM上の格納先アドレス
     * @param spm_management_addr SPM上の管理情報のアドレス
     * @param block_name ログ表示用のブロック名
     */
    void ensureBlockInSpm(uint64_t required_block_addr, uint64_t spm_block_addr, uint64_t spm_management_addr, const std::string& block_name) {
        uint64_t current_block_info = m_bus.read64(spm_management_addr);
        bool is_valid = (current_block_info & 1) != 0;
        bool is_dirty = (current_block_info & 2) != 0;
        uint64_t current_block_addr = (current_block_info >> 6) << 6;
        // manage情報をプリンt
        std::cout << "[Core FW] " << block_name << " Block Management Info - Valid: " << is_valid 
                  << ", Dirty: " << is_dirty << ", Current Block Addr: 0x" << std::hex << current_block_addr << std::dec << "\n";
        // SPM上のブロックが目的のブロックと違う場合、入れ替え処理を行う
        if (!is_valid || current_block_addr != required_block_addr) {
            std::cout << "[Core FW] " << block_name << " block miss in SPM. Required: 0x" << std::hex << required_block_addr << std::dec << "\n";
            // Dirtyビットが立っていれば、現在のブロックをDRAMに書き戻す
            if (is_valid && is_dirty) {
                std::cout << "[Core FW] Writing back dirty " << block_name << " block (0x" << std::hex << current_block_addr << std::dec << ").\n";
                startSpmDma(current_block_addr, spm_block_addr, 64, 1); // 1: SPM -> DRAM
                pollUntilReady(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START);
            }
            // 新しいブロックをDRAMからSPMに読み込む
            std::cout << "[Core FW] Loading new " << block_name << " block into SPM.\n";
            startSpmDma(required_block_addr, spm_block_addr, 64, 0); // 0: DRAM -> SPM
            pollUntilReady(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START);
            // 管理情報を更新 (Valid=1, Dirty=0)
            clearBlockdirty(spm_management_addr, required_block_addr);
        } else {
            std::cout << "[Core FW] " << block_name << " block hit in SPM.\n";
        }
    }
    // --- 3. ハードウェア制御を抽象化 ---
    void pollUntilReady(uint64_t status_addr) {
        while(m_bus.read64(status_addr) != 0) {}
    }

    void startSpmDma(uint64_t dram_addr, uint64_t spm_addr, uint64_t size, uint64_t direction) {
        pollUntilReady(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START);
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DRAM_ADDR, dram_addr);
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SPM_ADDR, spm_addr);
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SIZE, size);
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DIRECTION, direction);
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START, 1);
    }
    void setBlockdirty(uint64_t spm_management_addr, uint64_t block_addr) {
        uint64_t new_info = ((block_addr >> 6) << 6) | 0x3; // ValidとDirtyをセット
        m_bus.write64(spm_management_addr, new_info);
        // 管理情報をプリント
        uint64_t updated_info = m_bus.read64(spm_management_addr);
        bool is_valid = (updated_info & 1) != 0;
        bool is_dirty = (updated_info & 2) != 0;
        uint64_t current_block_addr = (updated_info >> 6) << 6;
        std::cout << "[Core FW] Updated Block Management Info - Valid: " << is_valid 
                  << ", Dirty: " << is_dirty << ", Current Block Addr: 0x" << std::hex << current_block_addr << std::dec << "\n";
    }
    void clearBlockdirty(uint64_t spm_management_addr, uint64_t block_addr) {
        uint64_t new_info = ((block_addr >> 6) << 6) | 0x1; // Validのみセット
        m_bus.write64(spm_management_addr, new_info);
    }
    void setMacBuffer(uint64_t spm_addr, uint64_t start_bit, uint64_t end_bit){
        // busy wait
        while(m_bus.read64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS) != 0) {}
        // SPMから暗号文をコピー
        m_bus.write64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::SPM_ADDR, spm_addr);
        m_bus.write64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::SPM_START, 1); // 先頭から
        while(m_bus.read64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::SPM_START) != 0) {}
        // MAC計算を開始
        m_bus.write64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::START_BIT,start_bit);
        m_bus.write64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::END_BIT,end_bit);
        m_bus.write64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::COMMAND, 2); // 2: MAC Update
        while(m_bus.read64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS) != 0) {}
    }
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
        auto ctx = setupAddressContext();
        std::cout << "[Core FW] Request Address: 0x" << std::hex << ctx.request_addr << std::dec << "\n";

        // --- 手順1: SPMからカウンターを読み取り、インクリメントしてSPMに書き戻し ---
        // 初めにspmにあるカウンターのアドレスを確認する
        std::cout << "[Core FW] Step 1: Handling counter block in SPM...\n";
        ensureBlockInSpm(ctx.counterblock_addr, ctx.spm_counter_block, ctx.spm_counter_manage, "Counter");
        // カウンターを読み取り、インクリメントして書き戻す
        uint64_t major_counter = m_bus.read64(ctx.spm_counter_block);
        // minor_counterのload
        // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
        uint64_t minor_counter_byte_address = ctx.spm_counter_block + (ctx.counter_bit_offset / 64) * 8;
        uint64_t minor_counter = m_bus.read64(minor_counter_byte_address);
        // ここから過去のminor counterを取り出す
        uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 8) * 8)) & 0xFF;
        uint8_t new_minor_counter = minor_counter_value + 1;
        uint64_t shift_amount = (ctx.counter_bit_offset % 8) * 8;
        uint64_t clear_mask = ~(0xFFULL << shift_amount);
        uint64_t cleared_minor_counter = minor_counter & clear_mask;
        // --- 新しい値を正しい位置へシフトする ---
        uint64_t shifted_new_value = static_cast<uint64_t>(new_minor_counter) << shift_amount;
        uint64_t final_word = cleared_minor_counter | shifted_new_value;
        // カウンターをprint
        std::cout << "[Core FW] Loaded Counter - Major: " << major_counter << ", Minor: " << static_cast<uint32_t>(new_minor_counter) << "\n";
        // 書き戻し
        m_bus.write64(minor_counter_byte_address, final_word);
        // ブロックをdirtyに設定する
        setBlockdirty(ctx.spm_counter_manage, ctx.counterblock_addr);
        // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
        uint64_t seed_0 = 0 + major_counter;
        uint64_t seed_1 = 1 + static_cast<uint64_t>(new_minor_counter);
        uint64_t seed_2 = 2 + major_counter;
        uint64_t seed_3 = 3 + static_cast<uint64_t>(new_minor_counter);
        uint64_t seed_4 = 4 + major_counter;
        uint64_t seed_5 = 5 + static_cast<uint64_t>(new_minor_counter);
        uint64_t seed_6 = 6 + major_counter;
        uint64_t seed_7 = 7 + static_cast<uint64_t>(new_minor_counter);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_0, seed_0);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_1, seed_1);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_2, seed_2);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_3, seed_3);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_4, seed_4);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_5, seed_5);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_6, seed_6);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_7, seed_7);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::START, 1); 
        // --- 手順3: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
        std::cout << "[Core FW] Step 3: Commanding AXI Manager to encrypt data...\n";
        // busy wait AESモジュールの計算完了を待つ
        pollUntilReady(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::START);
        m_bus.write64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::COMMAND, 4); // 8: Encrypt
        // busy wait AXI ManagerのBUSYがクリアされるのを待つ
        pollUntilReady(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::BUSY);
        // --- 手順4: AXI Managerに暗号文をSPMにwrite backするよう指示 ---
        m_bus.write64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::SPM_ADDR, ctx.spm_data);
        m_bus.write64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::COMMAND, 1); // 4: Write Back to SPM
        // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
        std::cout << "[Core FW] Step 5: Commanding Hash module to compute MAC...\n";
        // ハッシュ関数の内部状態を初期化
        pollUntilReady(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS);
        m_bus.write64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::COMMAND, 1); // 1: Initialize
        // busy wait
        pollUntilReady(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS);
        // SPMから暗号文をコピーし、update
        setMacBuffer(ctx.spm_data, 0, 511);
        // SPMからカウンターブロックをコピー
        setMacBuffer(ctx.spm_counter_block, ctx.counter_bit_offset, ctx.counter_bit_offset + 7); // todo: correct end bit length
        // MAC計算完了
        m_bus.write64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::COMMAND, 4); // 4: MAC Finalize
        // --- 手順6: Hashモジュールの計算完了を待ち、結果をSPMに保存 ---
        // SPMに当該MACブロックがあればそのままmodify,なければ今あるブロックをDRAMにwrite backしてから適切なブロックをSPMにDRAMコピー
        ensureBlockInSpm(ctx.datamacblock_addr, ctx.spm_mac_block, ctx.spm_mac_manage, "MAC");
        pollUntilReady(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS);
        uint64_t computed_mac = m_bus.read64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::MAC_RESULT);
        m_bus.write64(ctx.spm_mac_block + ctx.dmac_byte_offset, computed_mac);
        std::cout << "[Core FW] Computed MAC: 0x" << std::hex << computed_mac << std::dec << "\n";
        // SPM上のMACブロックをDirtyに設定する
        setBlockdirty(ctx.spm_mac_manage, ctx.datamacblock_addr);
        // --- 手順7: SPM DMAを起動し、SPMからDRAMへ暗号文をwrite back ---
        startSpmDma(ctx.request_addr, ctx.spm_data, 64, 1); // 1: SPM -> DRAM
        pollUntilReady(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START);
        // --- 手順8: AXI managerに対し、write ackの完了を通知 ---
        // busy wait
        while(m_bus.read64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::BUSY) != 0) {}
        m_bus.write64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::COMMAND, 32); // 32: Write Ack

        std::cout << "[Core FW] --- Authentication Finished ---\n";
    }
    void runVerification() {
        std::cout << "[Core FW] --- Verification Start ---\n";
        // uint64_t request_addr = m_bus.read64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::REQ_ADDR);
        auto ctx = setupAddressContext();
        std::cout << "[Core FW] Request Address: 0x" << std::hex << ctx.request_addr << std::dec << "\n";
        // --- 手順1: SPMからカウンターをload ---
        // 初めにspmにあるカウンターのアドレスを確認する
        std::cout << "[Core FW] Step 1: Handling counter block in SPM...\n";
        ensureBlockInSpm(ctx.counterblock_addr, ctx.spm_counter_block, ctx.spm_counter_manage, "Counter");
        uint64_t major_counter = m_bus.read64(ctx.spm_counter_block);
        // minor_counterのload
        // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
        uint64_t minor_counter_byte_address = ctx.spm_counter_block + (ctx.counter_bit_offset / 64) * 8;
        uint64_t minor_counter = m_bus.read64(minor_counter_byte_address);
        // ここから過去のminor counterを取り出す
        uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 8) * 8)) & 0xFF;
        // カウンターをprint
        std::cout << "[Core FW] Loaded Counter - Major: " << major_counter << ", Minor: " << static_cast<uint32_t>(minor_counter_value) << "\n";
        // カウンターをload
        // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
        uint64_t seed_0 = 0 + major_counter;
        uint64_t seed_1 = 1 + static_cast<uint64_t>(minor_counter_value);
        uint64_t seed_2 = 2 + major_counter;
        uint64_t seed_3 = 3 + static_cast<uint64_t>(minor_counter_value);
        uint64_t seed_4 = 4 + major_counter;
        uint64_t seed_5 = 5 + static_cast<uint64_t>(minor_counter_value);
        uint64_t seed_6 = 6 + major_counter;
        uint64_t seed_7 = 7 + static_cast<uint64_t>(minor_counter_value);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_0, seed_0);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_1, seed_1);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_2, seed_2);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_3, seed_3);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_4, seed_4);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_5, seed_5);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_6, seed_6);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_7, seed_7);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::START, 1); 
        // --- 手順3: SPM DMAを起動し、DRAMから暗号文をSPMにコピー ---
        std::cout << "[Core FW] Step 3: Commanding SPM DMA to copy ciphertext from DRAM to SPM...\n";
        startSpmDma(ctx.request_addr, ctx.spm_data, 64, 0); // 0: DRAM -> SPM
        std::cout << "[Core FW] Ciphertext loaded from DRAM to SPM.\n";
        // --- 手順3: AXI ManagerにOTPとともにXORを実行し、復号化を指示 ---
        // AESの完了を待つ
        pollUntilReady(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::START);
        // SPMからAXI Managerへ暗号文をコピー
        pollUntilReady(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::BUSY);
        m_bus.write64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::SPM_ADDR, ctx.spm_data);
        m_bus.write64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::COMMAND, 2); // 2: Decrypt
        // 復号化を指示
        std::cout << "[Core FW] Step 4: Commanding AXI Manager to decrypt ciphertext in SPM...\n";
        // busy wait
        pollUntilReady(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::BUSY);
        m_bus.write64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::COMMAND, 8); // 8: Decrypt Data in SPM

        // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
        std::cout << "[Core FW] Step 5: Commanding Hash module to compute MAC...\n";
        // ハッシュ関数の内部状態を初期化
        while(m_bus.read64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS) != 0) {}
        m_bus.write64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::COMMAND, 1); // 1: Initialize
        // busy wait
        while(m_bus.read64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS) != 0) {}
        // SPMから暗号文をコピーし、update
        setMacBuffer(ctx.spm_data, 0, 511);
        // SPMからカウンターブロックをコピー
        setMacBuffer(ctx.spm_counter_block, ctx.counter_bit_offset, ctx.counter_bit_offset + 7); // todo: correct end bit length
        // MAC計算完了
        m_bus.write64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::COMMAND, 4); // 4: MAC Finalize
        while(m_bus.read64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS) != 0) {}

        // --- 手順6: Hashモジュールの計算完了を待ち、結果を取得しSPMから正しい結果をload ---
        uint64_t mac_result = m_bus.read64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::MAC_RESULT);
        // SPMに当該MACブロックがあるかを確認。なければコピー。
        ensureBlockInSpm(ctx.datamacblock_addr, ctx.spm_mac_block, ctx.spm_mac_manage, "MAC");
        uint64_t expected_mac = m_bus.read64(ctx.spm_mac_block + ctx.dmac_byte_offset);
        std::cout << "[Core FW] Expected MAC: 0x" << std::hex << expected_mac << std::dec << "\n";
        std::cout << "[Core FW] Computed MAC: 0x" << std::hex << mac_result << std::dec << "\n";
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
        m_bus.write64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::COMMAND, 16); // 1: Return Data
        std::cout << "[Core FW] --- Verification Finished ---\n";
    }

private:
    Bus& m_bus;
};