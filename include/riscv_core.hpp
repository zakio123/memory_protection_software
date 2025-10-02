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
        while ((m_bus.read64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::STATUS) & 1) == 0) {}
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
    std::array<uint64_t, 4> level_base_addr = {
    (1ULL << (5 *3)) * 64 + (1ULL << (5 *2)) * 64 + (1ULL << (5 *1)) * 64, // height 1
    (1ULL << (5 *3)) * 64 + (1ULL << (5 *2)) * 64 , // height 2
    (1ULL << (5 *3)) * 64, // height 3
    0, // height 4
    };
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
        ctx.counterblock_addr = MemoryMap::COUNTER_BASE_ADDR + ((ctx.request_addr / (64 * 32))) * 64;
        ctx.datamacblock_addr = MemoryMap::DATA_TAG_BASE_ADDR + ((ctx.request_addr / (64 * 8))) * 64;
        // オフセット
        ctx.counter_bit_offset = 64 + (ctx.request_addr / 64) % 32 * 8;
        ctx.dmac_byte_offset = (ctx.request_addr / 64) % 8 * 8;

        // SPMアドレス
        ctx.spm_data = MemoryMap::SPM_BASE_ADDR + 0x040;
        ctx.spm_mac_block = MemoryMap::SPM_BASE_ADDR + 0x080;
        ctx.spm_counter_block = MemoryMap::SPM_BASE_ADDR + 0x0C0;
        ctx.spm_mac_manage = MemoryMap::SPM_BASE_ADDR + 56 * 64 + 1*8;
        ctx.spm_counter_manage = MemoryMap::SPM_BASE_ADDR + 56 * 64 + 3*8;
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
    bool tag_check(uint64_t spm_management_addr, uint64_t block_addr) {
        uint64_t current_block_info = m_bus.read64(spm_management_addr);
        bool is_valid = (current_block_info & 1) != 0;
        uint64_t current_block_addr = (current_block_info >> 6) << 6;
        return is_valid && (current_block_addr == block_addr);
    }
    void startSpmDma(uint64_t dram_addr, uint64_t spm_addr, uint64_t size, uint64_t direction) {
        pollUntilReady(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START);
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DRAM_ADDR, dram_addr);
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SPM_ADDR, spm_addr);
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::SIZE, size);
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::DIRECTION, direction);
        m_bus.write64(MemoryMap::MMIO_SPM_DMA_BASE_ADDR + MemoryMap::SPM_Reg::START, 1);
    }
    /*
     * @brief 指定されたSPM管理アドレスの管理情報を更新し、指定されたブロックをDirtyに設定する
    */
    void setBlockdirty(uint64_t spm_management_addr, uint64_t block_addr) {
        uint64_t new_info = ((block_addr >> 6) << 6) | 0x3; // ValidとDirtyをセット
        m_bus.write64(spm_management_addr, new_info);
        // uint64_t updated_info = m_bus.read64(spm_management_addr);
        // bool is_valid = (updated_info & 1) != 0;
        // bool is_dirty = (updated_info & 2) != 0;
        // uint64_t current_block_addr = (updated_info >> 6) << 6;
    }
    /**
     * @brief 指定されたSPM管理アドレスの管理情報を更新し、指定されたブロックのDirtyをクリアする またはValidのみセットする
    */
    void clearBlockdirty(uint64_t spm_management_addr, uint64_t block_addr) {
        uint64_t new_info = ((block_addr >> 6) << 6) | 0x1; // Validのみセット
        m_bus.write64(spm_management_addr, new_info);
    }
    /*
     * @brief MACモジュールのバッファにデータをセットし、計算を指示する
    */
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
    
    bool verifyTreePath(const std::array<uint64_t, 4>& path_indices) {
        std::cout << "[Core FW] --- Verifying Merkle Tree Path ---\n";
        for (uint64_t i = 0; i < Parameter::HEIGHT; ++i) {
            uint64_t height = i + 1;
            uint64_t spm_addr = MemoryMap::SPM_BASE_ADDR + (6 - i) * 64;
            uint64_t spm_manage = MemoryMap::SPM_BASE_ADDR + 56 * 64 + (6 - i) * 8;
            // DRAM上のノードアドレスを計算
            uint64_t dram_addr = MemoryMap::COUNTER_BASE_ADDR + path_indices[i] / 32 * 64;
            dram_addr += level_base_addr[i];
            // 必要なノードをSPMにロード
            ensureBlockInSpm(dram_addr, spm_addr, spm_manage, "Tree Level " + std::to_string(height));

            // --- MAC計算 ---
            // MACを初期化
            pollUntilReady(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS);
            m_bus.write64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::COMMAND, 1); // INIT
            pollUntilReady(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS);

            // 現在のノードデータをハッシュ入力に設定
            setMacBuffer(spm_addr, 0, 448 - 1); // 448bit

            // 親ノードのハッシュをハッシュ入力に設定
            if (i == 0) { // 最下層ノードの場合、親はルート
                setMacBuffer(MemoryMap::SPM_BASE_ADDR, 0, 63);
            } else {
                uint64_t parent_spm_addr = spm_addr + 64; // SPM上では直前の階層
                uint64_t parent_offset_in_node = (path_indices[i - 1] % 32) * 8;
                setMacBuffer(parent_spm_addr, 64 + parent_offset_in_node, 64 + parent_offset_in_node + 7);
            }

            // MAC計算を完了
            m_bus.write64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::COMMAND, 4); // FINALIZE
            pollUntilReady(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS);
            
            // --- MAC検証 ---
            uint64_t computed_mac = m_bus.read64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::MAC_RESULT);
            uint64_t expected_mac = m_bus.read64(spm_addr + 56); // 56Byte目にMACがある
            
            std::cout << "[Core FW] Level " << height << " - Computed MAC: 0x" << std::hex << computed_mac
                      << ", Expected MAC: 0x" << expected_mac << std::dec << "\n";

            if (computed_mac != expected_mac) {
                std::cout << "[Core FW] Verification failed at level " << height << ". Aborting.\n";
                return false; // 検証失敗
            }
        }
        std::cout << "[Core FW] --- Merkle Tree Path Verified Successfully ---\n";
        return true; // 全ての階層で検証成功
    }
    /**
     * @brief メジャー・マイナーカウンターとアドレスを元にOTP用のシードを生成しAESアクセラレータに書き込む
     */
    void makeseed_otp(uint64_t request_addr, uint64_t major_counter, uint8_t minor_counter){
        std::cout << "[Core FW] Setting up AES seeds for OTP generation...\n";
        std::cout << "[Core FW] Major Counter: " << major_counter << ", Minor Counter: " << static_cast<int>(minor_counter) << "\n";
        uint64_t seed_0 = request_addr + major_counter;
        uint64_t seed_1 = request_addr + static_cast<uint64_t>(minor_counter);
        uint64_t seed_2 = request_addr + 16 + major_counter;
        uint64_t seed_3 = request_addr + 16 + static_cast<uint64_t>(minor_counter);
        uint64_t seed_4 = request_addr + 32 + major_counter;
        uint64_t seed_5 = request_addr + 32 + static_cast<uint64_t>(minor_counter);
        uint64_t seed_6 = request_addr + 48 + major_counter;
        uint64_t seed_7 = request_addr + 48 + static_cast<uint64_t>(minor_counter);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_0, seed_0);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_1, seed_1);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_2, seed_2);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_3, seed_3);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_4, seed_4);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_5, seed_5);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_6, seed_6);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::INPUT_7, seed_7);
        m_bus.write64(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::START, 1); 
    }
    /**
     * @brief コア上で実行されるファームウェア/ドライバに相当する認証アルゴリズム
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
        // bool hit = tag_check(ctx.spm_counter_manage, ctx.counterblock_addr);
        // まずは検証を行う
        std::array<uint64_t,4> path_index; // 先頭は階層1
        for (int i=0;i<4;i++){
            path_index[3-i] = (ctx.request_addr / (64 * (1ULL << (5 * i))));
        }
        // print path_index
        std::cout << "[Core FW] Path Indices: ";
        for (int i=0;i<4;i++){
            std::cout << path_index[i] << " ";
        }
        std::cout << "\n";
        {
            ensureBlockInSpm(ctx.counterblock_addr, ctx.spm_counter_block, ctx.spm_counter_manage, "Counter");
            uint64_t major_counter = m_bus.read64(ctx.spm_counter_block);
            uint64_t minor_counter_byte_address = ctx.spm_counter_block + (ctx.counter_bit_offset / 64) * 8;
            uint64_t minor_counter = m_bus.read64(minor_counter_byte_address);
            // ここから過去のminor counterを取り出す
            uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64) )) & 0xFF;
            if (minor_counter_value != 0 || major_counter != 0){
                // メジャーマイナー、どちらかが0でなければ検証を行う
                // 1. パスの特定=親ノードの物理アドレスをルートまで計算していく。
                bool verified = verifyTreePath(path_index);
                if (verified == false){
                    std::cout << "[Core FW] Authentication failed during counter verification. Aborting.\n";
                    exit(1);
                }
            }
        }
        // 手順1.1 : カウンターを読み取り、インクリメントして書き戻しツリーの認証を行う
        std::cout << "[Core FW] Incrementing minor counter and updating major counter and tree\n";
        // root update
        uint64_t spm_root_addr = MemoryMap::SPM_BASE_ADDR + 0 * 64;
        uint64_t root = m_bus.read64(spm_root_addr);
        uint64_t new_root = root + 1;
        m_bus.write64(spm_root_addr, new_root);
        uint64_t height = 1;
        for (uint64_t i=0;i<Parameter::HEIGHT;i++){
            std::cout << "[Core FW] Processing Counter Level " << height << "\n";
            uint64_t spm_addr = MemoryMap::SPM_BASE_ADDR + (6-i) * 64;
            uint64_t spm_manage = MemoryMap::SPM_BASE_ADDR + 56 * 64 + (6-i) * 8;
            uint64_t dram_addr = MemoryMap::COUNTER_BASE_ADDR + path_index[i] / 32 * 64;
            dram_addr += level_base_addr[i];
            ensureBlockInSpm(dram_addr, spm_addr, spm_manage, "Counter Level " + std::to_string(height));
            height += 1;
            // ここから過去のmajor, minor counterを取り出す
            uint64_t major_counter = m_bus.read64(spm_addr);
            uint64_t minor_counter_byte_address = spm_addr + 8 + (path_index[i] % 32) / 8 * 8;
            uint64_t minor_counter = m_bus.read64(minor_counter_byte_address);
            // ここから過去のminor counterを取り出す
            uint8_t minor_counter_value = (minor_counter >> ((path_index[i] % 8) * 8)) & 0xFF;
            uint8_t new_minor_counter = 0;
            if (minor_counter_value == 0xFF){
                uint64_t new_major_counter = major_counter + 1;
                m_bus.write64(spm_addr, new_major_counter);
                new_minor_counter = 0; // minor counterは0に戻す
                std::cout << "[Core FW] Minor counter overflow at level " << height-1 << ". Incrementing major counter.\n";
                // exit(1); // 今回はエラーにする
            } else {
                new_minor_counter = minor_counter_value + 1;
            }
            uint64_t shift_amount = (path_index[i] % 8) * 8;
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
            setBlockdirty(spm_manage, dram_addr);
            // MAC計算を実行
            // Hash関数を初期化してから当該ブロックをMAC
            while(m_bus.read64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS) != 0) {}
            m_bus.write64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::COMMAND, 1); // 1: Initialize
            // busy wait
            while(m_bus.read64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS) != 0) {}
            // SPMからこの階層のブロックをコピーし、update
            setMacBuffer(spm_addr, 0, 448-1); // 448
            // 親ノードのヘッダーをMACの内部バッファにセット
            if (i == 0){
                // 最上位層はrootノードを使う
                setMacBuffer(MemoryMap::SPM_BASE_ADDR, 0, 63);
            } else {
                uint64_t parent_offset = path_index[i-1] % 32 * 8;
                setMacBuffer(spm_addr + 64, 64 + parent_offset ,64 + parent_offset + 7); 
            }
            // MAC計算完了
            m_bus.write64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::COMMAND, 4); // 4: MAC Finalize
            while(m_bus.read64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::STATUS) != 0) {}
            uint64_t mac_result = m_bus.read64(MemoryMap::MMIO_MAC_BASE_ADDR + MemoryMap::MacReg::MAC_RESULT);
            m_bus.write64(spm_addr + 56, mac_result); // 56BにMACがある
        }
        uint64_t major_counter = m_bus.read64(ctx.spm_counter_block);
        // minor_counterのload
        // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
        uint64_t minor_counter_byte_address = ctx.spm_counter_block + (ctx.counter_bit_offset / 64) * 8;
        uint64_t minor_counter = m_bus.read64(minor_counter_byte_address);
        uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64))) & 0xFF;
        // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
        makeseed_otp(ctx.request_addr, major_counter, minor_counter_value);
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
    /**
     * @brief コア上で実行されるファームウェア/ドライバに相当する検証アルゴリズム
     */
    void runVerification() {
        std::cout << "[Core FW] --- Verification Start ---\n";
        // uint64_t request_addr = m_bus.read64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::REQ_ADDR);
        auto ctx = setupAddressContext();
        std::cout << "[Core FW] Request Address: 0x" << std::hex << ctx.request_addr << std::dec << "\n";
        // --- 手順1: SPMからカウンターをload ---
        // 初めにspmにあるカウンターのアドレスを確認する
        std::cout << "[Core FW] Step 1: Handling counter block in SPM...\n";
        // --- 手順1.1 : ツリー検証 ---
        {
            // missの場合、カウンターブロックの検証が必要
            // 1. パスの特定=親ノードの物理アドレスをルートまで計算していく。
            std::array<uint64_t,4> path_index; // 先頭は階層1
            for (int i=0;i<4;i++){
                path_index[3-i] = (ctx.request_addr / (64 * (1ULL << (5 * i))));
            }
            bool verified = verifyTreePath(path_index);
            if (verified == false){
                std::cout << "[Core FW] Verification failed during counter verification. Aborting.\n";
                exit(1);
            }
        }
        // --- 手順1.2 : ツリーの検証は終了、カウンターのload ---
        uint64_t major_counter = m_bus.read64(ctx.spm_counter_block);
        // minor_counterのload
        // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
        uint64_t minor_counter_byte_address = ctx.spm_counter_block + (ctx.counter_bit_offset / 64) * 8;
        uint64_t minor_counter = m_bus.read64(minor_counter_byte_address);
        uint8_t minor_counter_value = (minor_counter >> ((ctx.counter_bit_offset % 64) )) & 0xFF;
        std::cout << "[Core FW] Loaded Counter - Major: " << major_counter << ", Minor: " << static_cast<uint32_t>(minor_counter_value) << "\n";
        // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
        makeseed_otp(ctx.request_addr, major_counter, minor_counter_value);
        // --- 手順3: SPM DMAを起動し、DRAMから暗号文をSPMにコピー ---
        std::cout << "[Core FW] Step 3: Commanding SPM DMA to copy ciphertext from DRAM to SPM...\n";
        startSpmDma(ctx.request_addr, ctx.spm_data, 64, 0); // 0: DRAM -> SPM
        std::cout << "[Core FW] Ciphertext loaded from DRAM to SPM.\n";
        // --- 手順3: AXI ManagerにOTPとともにXORを実行し、復号化を指示 ---
        // SPMからAXI Managerへ暗号文をコピー
        pollUntilReady(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::BUSY);
        m_bus.write64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::SPM_ADDR, ctx.spm_data);
        m_bus.write64(MemoryMap::MMIO_AXI_MGR_BASE_ADDR + MemoryMap::AxiManagerReg::COMMAND, 2); // 2: Decrypt
        // AESの完了を待つ
        pollUntilReady(MemoryMap::MMIO_AES_ACCEL_BASE_ADDR + MemoryMap::AesReg::START);
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
        if (mac_result != expected_mac) {
            std::cout << "[Core FW] MAC verification failed. Aborting operation.\n";
            // エラー処理: MAC不一致
            exit(1);
        }
        
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