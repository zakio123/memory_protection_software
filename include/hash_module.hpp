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
            case MemoryMap::MAC_AccelReg::SPM_ADDR:
                m_spm_addr_reg = value;
                break;
            case MemoryMap::MAC_AccelReg::SPM_START:
                if (value == 1) executeDmaCopy();
                break;
            case MemoryMap::MAC_AccelReg::COMMAND:
                executeCommand(value);
                break;
            case MemoryMap::MAC_AccelReg::START_BIT:
                m_start_bit_reg = value;
                break;
            case MemoryMap::MAC_AccelReg::END_BIT:
                m_end_bit_reg = value;
                break;
        }
    }

    /**
     * @brief 64bitのMMIO読み出しを処理
     */
    uint64_t mmioRead64(uint32_t offset) {
        switch (offset) {
            case MemoryMap::MAC_AccelReg::STATUS:
                return m_status;
            case MemoryMap::MAC_AccelReg::MAC_RESULT:
                return m_mac_result;
            // SPM_STARTの読み出し動作は未定義のため0を返す
            case MemoryMap::MAC_AccelReg::SPM_START:
                return 0;
        }
        return 0;
    }

private:
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
        std::cout << "  [Hash HW] DMA Copy Started (SPM:0x" << std::hex << m_spm_addr_reg
                  << " -> Internal Buffer, 64 Bytes)\n" << std::dec;
        m_spm.read(m_spm_addr_reg, m_internal_buffer.data(), m_internal_buffer.size());
        std::cout << "  [Hash HW] DMA Copy Finished.\n";
        m_status = 0; // Idleに戻す
    }

    // COMMANDレジスタに書き込まれたコマンドを実行
    void executeCommand(uint64_t command) {
        m_status = 1; // Busyに設定
        if (command & 1) { // INIT
            std::cout << "  [Hash HW] Command INIT received. MAC state cleared.\n";
            m_mac_result = 0;
        }
        if (command & 2) { // UPDATE
            std::cout << "  [Hash HW] Command UPDATE received (Bits " << m_start_bit_reg << " to " << m_end_bit_reg << ").\n";
            for (uint64_t i = m_start_bit_reg; i <= m_end_bit_reg; ++i) {
                bool bit = getBit(i);
                // 簡易ハッシュアルゴリズム: 巡回左シフト + XOR
                m_mac_result = ((m_mac_result << 1) | (m_mac_result >> 63)) ^ bit;
            }
        }
        if (command & 4) { // DIGEST
            std::cout << "  [Hash HW] Command DIGEST received. Calculation finalized.\n";
            // 実際のハードウェアではパディングなどを行うが、シミュレーションでは何もしない
        }
        m_status = 0; // Idleに戻す
    }

    // 内部バッファから指定されたインデックスのビットを取得
    bool getBit(uint64_t bit_index) {
        if (bit_index >= m_internal_buffer.size() * 8) return false;
        uint64_t byte_index = bit_index / 8;
        uint8_t bit_offset = bit_index % 8;
        return (m_internal_buffer[byte_index] >> bit_offset) & 1;
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