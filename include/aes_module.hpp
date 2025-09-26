#pragma once
#include "axi_manager_module.hpp"
#include "memory_map.hpp"
#include <iostream>
#include <vector>
#include <array>
#include <cstring> // for std::memcpy

class AesModule {
public:
    AesModule(AxiManagerModule& axi_manager) 
        : m_axi_manager(axi_manager) {
        m_input_data.fill(0);
    }

    /**
     * @brief 64bitのMMIO書き込みを処理
     */
    void mmioWrite64(uint32_t offset, uint64_t value) {
        std::cout << "  [AES HW] MMIO Write64: offset=0x" << std::hex << offset 
                  << ", value=0x" << value << std::dec << ".\n";

        if (offset >= MemoryMap::AesReg::INPUT_0 && offset <= MemoryMap::AesReg::INPUT_7) {
            // 64bitデータを内部の512bitバッファの適切な位置にコピー
            std::memcpy(&m_input_data[offset], &value, sizeof(uint64_t));
        }
        else if (offset == MemoryMap::AesReg::START) {
            // Startビットが1にされたら生成処理を開始
            if ((value & 1) && m_start_reg == 0) {
                m_start_reg = 1; // 処理中(Busy)状態にする
                runOtpGeneration();
            }
        }
    }

    /**
     * @brief 64bitのMMIO読み出しを処理
     */
    uint64_t mmioRead64(uint32_t offset) {
        if (offset == MemoryMap::AesReg::START) {
            return m_start_reg;
        }
        return 0;
    }

private:
    void runOtpGeneration() {
        std::cout << "  [AES HW] Starting OTP generation...\n";
        for (int i = 0; i < 4; ++i) {
            AxiManagerModule::Otp otp = generateOtp(i);
            std::cout << "  [AES HW] Generated OTP " << i << ". Pushing to FIFO...\n";
            m_axi_manager.pushOtpToFifo(otp);
        }
        // 処理が完了したので、STARTレジスタを自動的に0に戻す
        m_start_reg = 0;
        std::cout << "  [AES HW] OTP generation finished. START register cleared to 0.\n";
    }

    AxiManagerModule::Otp generateOtp(int sequence_num) {
        AxiManagerModule::Otp otp;
        for (size_t i = 0; i < otp.size(); ++i) {
            otp[i] = m_input_data[i] ^ (0x11 * sequence_num);
        }
        return otp;
    }

    AxiManagerModule& m_axi_manager;
    std::array<uint8_t, 64> m_input_data; // 512bit (64-byte)の入力データバッファ
    uint64_t m_start_reg = 0; // STARTレジスタの状態
};