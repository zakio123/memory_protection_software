#pragma once
#include "spm.hpp" // SPMへのアクセスに必要
#include "memory_map.hpp"
#include <iostream>
#include <vector>
#include <array>
#include <queue>
#include <functional>
#include <cstdint>
#include <bitset>
// Forward declaration for SpmModule if needed, but including is fine.

class AxiManagerModule {
public:
    // 型定義
    using Otp = std::array<uint8_t, 16>;
    using DataBlock = std::array<uint8_t, 64>;
    // コールバック関数の型定義: Readはデータ、WriteはACK(成功フラグ)を返す
    using ReadResponseCallback = std::function<void(const DataBlock&)>;
    using WriteResponseCallback = std::function<void(bool)>;

private:
    // LLCからのリクエストを格納する内部構造体
    struct LlcRequest {
        bool is_write;
        uint64_t addr;
        uint64_t id;
        DataBlock write_data; // Writeリクエストの場合のみ使用
        ReadResponseCallback read_cb;
        WriteResponseCallback write_cb;
    };

public:
    /**
     * @brief コンストラクタ
     * @param spm SPMへのアクセスに使用するSpmModuleへの参照
     */
    AxiManagerModule(Spm& spm) : m_spm(spm) {}

    // --- LLCからのインターフェース ---
    void receiveLlcReadRequest(uint64_t addr, uint64_t id, ReadResponseCallback cb) {
        m_request_queue.push({false, addr, id, {}, cb, nullptr});
        // std::cout << "[AXIM] Read Request Queued (Addr: 0x" << std::hex << addr << ").\n" << std::dec;
    }

    void receiveLlcWriteRequest(uint64_t addr, uint64_t id, const DataBlock& data, WriteResponseCallback cb) {
        m_request_queue.push({true, addr, id, data, nullptr, cb});
        // std::cout << "[AXIM] Write Request Queued (Addr: 0x" << std::hex << addr << ").\n" << std::dec;
        // w_data_bufferにデータをセット
        m_w_buffer = data;
    }

    // --- AESからのインターフェース ---
    void pushOtpToFifo(const Otp& otp) {
        m_otp_fifo.push(otp);
    }
    
    // --- コアからのMMIOインターフェース ---
    void mmioWrite64(uint64_t offset, uint64_t value) {
        if (offset == MemoryMap::AxiManagerReg::SPM_ADDR) {
            m_spm_addr_reg = value;
        } else if (offset == MemoryMap::AxiManagerReg::COMMAND) {
            if (m_busy_reg == 0) {
                executeCommand(value);
            }
        }
    }

    uint64_t mmioRead64(uint64_t offset) {
        switch (offset) {
            case MemoryMap::AxiManagerReg::STATUS: {
                uint64_t status = 0;
                if (!m_request_queue.empty()) {
                    status |= 1; // bit 0: キューにリクエストあり
                    if (m_request_queue.front().is_write) {
                        status |= 2; // bit 1: Writeリクエスト
                    }
                }
                return status;
            }
            case MemoryMap::AxiManagerReg::REQ_ADDR:
                return m_request_queue.empty() ? 0 : m_request_queue.front().addr;
            case MemoryMap::AxiManagerReg::REQ_ID:
                return m_request_queue.empty() ? 0 : m_request_queue.front().id;
            case MemoryMap::AxiManagerReg::BUSY:
                return m_busy_reg;
        }
        return 0;
    }

private:
    void executeCommand(uint64_t command) {
        m_busy_reg = 1;
        std::cout << "  [AXIM HW] Executing Command: 0b" << std::bitset<6>(command) << "\n";

        if (command & 1) { // Data Write Back (W Buffer -> SPM)
            m_spm.write(m_spm_addr_reg, m_w_buffer.data(), m_w_buffer.size());
        }
        if (command & 2) { // Data Copy (SPM -> R Buffer)
            m_spm.read(m_spm_addr_reg, m_r_buffer.data(), m_r_buffer.size());
            for (size_t i = 0; i < m_r_buffer.size(); ++i) {
                std::cout << std::hex << static_cast<int>(m_r_buffer[i]) << " ";
            }
            std::cout << std::dec << "\n";
        }
        if (command & 4) { // 暗号化 (OTP xor W Buffer)
            // 暗号化する前のw_bufferをprint
            for (size_t j = 0; j < 4; ++j) { // 64Bを16Bずつ4回に分けて処理
                // OTPが足りない場合はスキップ
                if (!m_otp_fifo.empty()) {
                    auto otp_part = m_otp_fifo.front(); m_otp_fifo.pop();
                    for(size_t i=0; i<16; ++i) m_w_buffer[16*j+i] ^= otp_part[i];
                }
            }
        }
        if (command & 8) { // 復号化 (OTP xor R Buffer)
            for (size_t j = 0; j < 4; ++j) { // 64Bを16Bずつ4回に分けて処理
                if (!m_otp_fifo.empty()) {
                    std::cout << "  [AXIM HW] Processing Decryption Command.\n";
                    auto otp_part = m_otp_fifo.front(); m_otp_fifo.pop();
                    for(size_t i=0; i<16; ++i) m_r_buffer[j*16+i] ^= otp_part[i];
                }
            }

        }
        if (command & 16) { // Read Response (R Buffer -> LLC)
            if (!m_request_queue.empty() && !m_request_queue.front().is_write) {
                auto req = m_request_queue.front(); m_request_queue.pop();
                if(req.read_cb) req.read_cb(m_r_buffer);
            }
        }
        if (command & 32) { // Write Response (ACK -> LLC)
            if (!m_request_queue.empty() && m_request_queue.front().is_write) {
                auto req = m_request_queue.front(); m_request_queue.pop();
                if(req.write_cb) req.write_cb(true); // 常に成功を返す
            }
        }
        m_busy_reg = 0;
    }

    // --- 依存モジュール ---
    Spm& m_spm;

    // --- 内部状態 ---
    std::queue<LlcRequest> m_request_queue;
    std::queue<Otp> m_otp_fifo;
    DataBlock m_r_buffer{}; // Read Buffer
    DataBlock m_w_buffer{}; // Write Buffer
    
    // MMIOレジスタの状態
    uint64_t m_spm_addr_reg = 0;
    uint64_t m_busy_reg = 0;
};