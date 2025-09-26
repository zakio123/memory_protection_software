#pragma once
#include "memory_map.hpp"
#include "dram.hpp"
#include "spm.hpp"
#include <iostream>
#include <vector>
#include <cstdint>

class SpmModule {
public:
    /**
     * @brief コンストラクタ
     * @param dram データ転送の相手となるDramオブジェクトへの参照
     * @param spm データ転送の相手となるSpmオブジェクトへの参照
     */
    SpmModule(Dram& dram, Spm& spm) 
        : m_dram(dram), m_spm(spm), m_start_reg(0) {}

    /**
     * @brief 64bitのMMIO書き込みを処理
     */
    void mmioWrite64(uint32_t offset, uint64_t value) {
        // STARTレジスタが1(Busy)の場合、新たなコマンドを受け付けない
        if (m_start_reg == 1) {
            std::cout << "  [SPM-DMA HW] Ignored write while busy.\n";
            return;
        }

        switch (offset) {
            case MemoryMap::SPM_Reg::DRAM_ADDR:
                m_dram_addr_reg = value;
                break;
            case MemoryMap::SPM_Reg::SPM_ADDR:
                m_spm_addr_reg = value;
                break;
            case MemoryMap::SPM_Reg::SIZE:
                m_size_reg = value;
                break;
            case MemoryMap::SPM_Reg::DIRECTION:
                m_direction_reg = value;
                break;
            case MemoryMap::SPM_Reg::START:
                // 1を書き込まれたら転送開始
                if (value == 1) {
                    executeTransfer();
                }
                break;
        }
    }

    /**
     * @brief 64bitのMMIO読み出しを処理
     */
    uint64_t mmioRead64(uint32_t offset) {
        // STARTレジスタのみ読み出し可能
        if (offset == MemoryMap::SPM_Reg::START) {
            return m_start_reg;
        }
        return 0;
    }

private:
    /**
     * @brief DMA転送を実行する
     */
    void executeTransfer() {
        m_start_reg = 1; // 1: Busy
        std::cout << "  [SPM-DMA HW] Transfer Started.\n"
                  << "    DRAM Addr: 0x" << std::hex << m_dram_addr_reg
                  << ", SPM Addr: 0x" << m_spm_addr_reg
                  << ", Size: " << std::dec << m_size_reg
                  << ", Direction: " << (m_direction_reg == 0 ? "DRAM->SPM" : "SPM->DRAM") << "\n";
        
        // 転送サイズが0の場合は何もしない
        if (m_size_reg == 0) {
             m_start_reg = 0; // 0: Idle
             return;
        }

        // 一時的なバッファを使ってデータを転送
        std::vector<uint8_t> buffer(m_size_reg);

        if (m_direction_reg == 0) { // 0: コピー (DRAMからSPM)
            // Dramから一時バッファへ読み出し
            m_dram.read(m_dram_addr_reg, buffer.data(), m_size_reg);
            // 一時バッファからSpmへ書き込み
            m_spm.write(m_spm_addr_reg, buffer.data(), m_size_reg);
        } else { // 1: ライトバック (SPMからDRAM)
            // Spmから一時バッファへ読み出し
            m_spm.read(m_spm_addr_reg, buffer.data(), m_size_reg);
            // 一時バッファからDramへ書き込み
            m_dram.write(m_dram_addr_reg, buffer.data(), m_size_reg);
        }

        std::cout << "  [SPM-DMA HW] Transfer Finished.\n";
        m_start_reg = 0; // 0: Idle
    }

    // --- 依存モジュール ---
    Dram& m_dram;
    Spm& m_spm;
    
    // --- MMIOレジスタの状態 ---
    uint64_t m_dram_addr_reg = 0;
    uint64_t m_spm_addr_reg = 0;
    uint64_t m_size_reg = 0;
    uint64_t m_direction_reg = 0;
    uint64_t m_start_reg = 0; // 0: Idle, 1: Busy
};