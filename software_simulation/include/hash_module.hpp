#pragma once
#include "spm.hpp" // SPMへのアクセスに必要
#include "memory_map.hpp"
#include <iostream>
#include <array>
#include <vector>
#include <cstdint>

class HashModule {
public:
    /**
     * @brief コンストラクタ
     * @param spm データコピー元となるSpmModuleへの参照
     */
    HashModule(Spm& spm) : m_spm(spm) {
        reset();
    }

    /**
     * @brief 64bitのMMIO書き込みを処理
     */
    void mmioWrite64(uint32_t offset, uint64_t value) {
        // STATUSが1(Busy)の場合、いかなる入力も受け付けない
        if (m_status == 1) {
            std::cout << "  [Hash HW] Ignored write while busy.\n";
            return;
        }

        switch (offset) {
            case MemoryMap::MacReg::SPM_ADDR:
                m_spm_addr_reg = value;
                break;
            case MemoryMap::MacReg::SPM_START:
                if (value == 1) executeDmaCopy();
                break;
            case MemoryMap::MacReg::COMMAND:
                executeCommand(value);
                break;
            case MemoryMap::MacReg::START_BIT:
                m_start_bit_reg = value;
                break;
            case MemoryMap::MacReg::END_BIT:
                m_end_bit_reg = value;
                break;
        }
    }

    /**
     * @brief 64bitのMMIO読み出しを処理
     */
    uint64_t mmioRead64(uint32_t offset) {
        switch (offset) {
            case MemoryMap::MacReg::STATUS:
                return m_status;
            case MemoryMap::MacReg::MAC_RESULT:
                return m_mac_result;
            // SPM_STARTの読み出し動作は未定義のため0を返す
            case MemoryMap::MacReg::SPM_START:
                return 0;
        }
        return 0;
    }

private:
    // FNV-1aハッシュ用の定数 (64bit版)
    static constexpr uint64_t FNV_PRIME = 0x100000001b3;
    static constexpr uint64_t FNV_OFFSET_BASIS = 0xcbf29ce484222325;
    void reset() {
        m_spm_addr_reg = 0;
        m_start_bit_reg = 0;
        m_end_bit_reg = 0;
        m_mac_result = 0;
        m_status = 0;
        m_internal_buffer.fill(0);
    }

    // SPMから内部バッファへのDMAコピーを実行
    void executeDmaCopy() {
        m_status = 1; // Busyに設定
        // std::cout << "  [Hash HW] DMA Copy Started (SPM:0x" << std::hex << m_spm_addr_reg
        //           << " -> Internal Buffer, 64 Bytes)\n" << std::dec;
        m_spm.read(m_spm_addr_reg, m_internal_buffer.data(), m_internal_buffer.size());
        // std::cout << "  [Hash HW] DMA Copy Finished.\n";
        m_status = 0; // Idleに戻す
    }

    // COMMANDレジスタに書き込まれたコマンドを実行
    void executeCommand(uint64_t command) {
        m_status = 1; // Busyに設定
        if (command & 1) { // INIT
            std::cout << "  [Hash HW] Command INIT received. MAC state cleared.\n";
            m_mac_result = FNV_OFFSET_BASIS;
        }
        if (command & 2) { // UPDATE
            // std::cout << "  [Hash HW] Command UPDATE received (Bits " << m_start_bit_reg << " to " << m_end_bit_reg << ").\n";
            
            // ★変更点: ビット指定をバイト範囲に変換して処理
            // 指定されたビット範囲を含む最小のバイト範囲を計算
            uint64_t start_byte = m_start_bit_reg / 8;
            uint64_t end_byte = (m_end_bit_reg) / 8;
            if (end_byte >= m_internal_buffer.size() || m_start_bit_reg > m_end_bit_reg) {
                //  std::cout << "  [Hash HW] ERROR: Invalid bit range.\n";
            } else {
                
                std::cout << "  [Hash HW] Processing bytes from " << start_byte << " to " << end_byte << ".\n";
                // internal_bufferの指定バイト範囲をprint
                std::cout << "  [Hash HW] Data: ";
                for (uint64_t i = start_byte; i <= end_byte; ++i) {
                    std::cout << std::hex << static_cast<int>(m_internal_buffer[i]) << " ";
                }
                std::cout << std::dec << "\n";
                // FNV-1aアルゴリズムをそのバイト範囲で実行

                for (uint64_t i = start_byte; i <= end_byte; ++i) {
                    m_mac_result ^= m_internal_buffer[i];
                    m_mac_result *= FNV_PRIME;
                }
            }
        }
        if (command & 4) { // DIGEST
            // std::cout << "  [Hash HW] Command DIGEST received. Calculation finalized.\n";
            // 実際のハードウェアではパディングなどを行うが、シミュレーションでは何もしない
        }
        m_status = 0; // Idleに戻す
    }

    // --- 依存モジュール ---
    Spm& m_spm;

    // --- 内部状態 ---
    std::array<uint8_t, 64> m_internal_buffer;
    
    // MMIOレジスタの状態
    uint64_t m_spm_addr_reg = 0;
    uint64_t m_start_bit_reg = 0;
    uint64_t m_end_bit_reg = 0;
    uint64_t m_mac_result = 0;
    uint64_t m_status = 0;
};