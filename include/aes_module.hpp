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
    // AESの状態 (128bit) は 4x4 のバイト行列として扱う
    using State = std::array<std::array<uint8_t, 4>, 4>;
    using Key = std::array<uint8_t, 16>;

    // 実際のAESで使われるS-box (置換テーブル)
    static constexpr std::array<uint8_t, 256> s_box = {
        0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
        0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
        0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
        0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
        0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
        0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
        0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
        0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
        0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
        0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
        0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
        0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
        0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
        0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
        0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
        0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
    };

    // --- AESの各ステップを模倣するヘルパー関数 ---
    
    // SubBytes: S-boxを使って各バイトを置換する
    void subBytes(State& state) {
        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                state[i][j] = s_box[state[i][j]];
            }
        }
    }

    // ShiftRows: 行をサイクリックシフトする
    void shiftRows(State& state) {
        // row 1: 1 byte left shift
        uint8_t temp = state[1][0];
        state[1][0] = state[1][1]; state[1][1] = state[1][2]; state[1][2] = state[1][3]; state[1][3] = temp;
        // row 2: 2 bytes left shift
        std::swap(state[2][0], state[2][2]); std::swap(state[2][1], state[2][3]);
        // row 3: 3 bytes left shift
        temp = state[3][3];
        state[3][3] = state[3][2]; state[3][2] = state[3][1]; state[3][1] = state[3][0]; state[3][0] = temp;
    }

    // MixColumns: 列内のバイトを混合する (簡易版シミュレーション)
    void mixColumns_sim(State& state) {
        for (int j = 0; j < 4; ++j) {
            uint8_t t0 = state[0][j], t1 = state[1][j], t2 = state[2][j], t3 = state[3][j];
            state[0][j] = t0 ^ t1 ^ t2;
            state[1][j] = t1 ^ t2 ^ t3;
            state[2][j] = t2 ^ t3 ^ t0;
            state[3][j] = t3 ^ t0 ^ t1;
        }
    }
    
    // AddRoundKey: 状態とキーでXORを取る
    void addRoundKey(State& state, const Key& key) {
        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                state[j][i] ^= key[i * 4 + j];
            }
        }
    }

    /**
     * @brief 128bitブロックを暗号化するAESのメインパイプライン
     */
    AxiManagerModule::Otp encryptBlock(const Key& key, const AxiManagerModule::Otp& plaintext) {
        State state;
        // 1次元配列(plaintext)を2次元のStateに変換
        for(int i=0; i<16; ++i) state[i % 4][i / 4] = plaintext[i];

        addRoundKey(state, key); // ラウンド0

        // 4ラウンドの暗号化処理をシミュレート
        const int num_rounds = 4;
        for (int round = 0; round < num_rounds; ++round) {
            subBytes(state);
            shiftRows(state);
            if (round < num_rounds - 1) { // 最終ラウンドではMixColumnsは行わない
                mixColumns_sim(state);
            }
            addRoundKey(state, key); // 簡単化のため毎回同じ鍵を使用
        }
        
        // 2次元のStateを1次元配列に戻して返す
        AxiManagerModule::Otp ciphertext;
        for(int i=0; i<16; ++i) ciphertext[i] = state[i % 4][i / 4];
        return ciphertext;
    }
    // モジュール内部に固定で保持されるハードウェアキー
    static constexpr Key m_hardware_key = {
        0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6,
        0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c
    };

    void runOtpGeneration() {
        for (int i = 0; i < 4; ++i) {
            AxiManagerModule::Otp counter_block;
            // m_input_dataからi番目の128bitカウンター値を抽出
            std::copy(m_input_data.begin() + (i * 16), 
                      m_input_data.begin() + ((i + 1) * 16), 
                      counter_block.begin());

            // 固定のハードウェアキーを使って、カウンター値を暗号化する
            AxiManagerModule::Otp otp_block = encryptBlock(m_hardware_key, counter_block);
            
            // std::cout << "  [AES HW] Encrypted counter " << i << ". Pushing result to FIFO...\n";
            m_axi_manager.pushOtpToFifo(otp_block);
        }

        m_start_reg = 0;
        // std::cout << "  [AES HW] OTP generation finished. START register cleared to 0.\n";
    }

    AxiManagerModule& m_axi_manager;
    std::array<uint8_t, 64> m_input_data; // 512bit (64-byte)の入力データバッファ
    uint64_t m_start_reg = 0; // STARTレジスタの状態
};