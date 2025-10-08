#pragma once
#include <array>
#include <cstdint>
#include <cstring>
#include "memory_map.hpp"
class Spm {
public:
    static constexpr size_t SPM_SIZE = MemoryMap::SPM_SIZE; // 4KB
    
    // バイト単位のアクセス
    void write(uint64_t addr, const uint8_t* data, uint64_t size) {
        uint64_t local_addr = addr - MemoryMap::SPM_BASE_ADDR; // ローカルアドレスに変換
        if (local_addr + size <= SPM_SIZE) {
            std::memcpy(&m_memory[local_addr], data, size);
        } else {
            std::cerr << "SPM: Write out of bounds! Addr: 0x" << std::hex << addr << ", Size: " << std::dec << size << "\n";
            exit(1);
        }
    }

    void read(uint64_t addr, uint8_t* data, uint64_t size) {
        uint64_t local_addr = addr - MemoryMap::SPM_BASE_ADDR;
        if (local_addr + size <= SPM_SIZE) {
            std::memcpy(data, &m_memory[local_addr], size);
        }
        else {
            std::cerr << "SPM: Read out of bounds! Addr: 0x" << std::hex << addr << ", Size: " << std::dec << size << "\n";
            exit(1);
        }
    }
    
        // // 32ビット単位のアクセス
        // void write32(uint32_t addr, uint32_t data) {
        //     if (addr + 4 <= SPM_SIZE) {
        //         *reinterpret_cast<uint32_t*>(&m_memory[addr]) = data;
        //     }
        // }

        // uint32_t read32(uint32_t addr) {
        //     if (addr + 4 <= SPM_SIZE) {
        //         return *reinterpret_cast<uint32_t*>(&m_memory[addr]);
        //     }
        //     return 0;
        // }

    // --- 64ビット単位のアクセスメソッド (追加) ---

    /**
     * @brief 指定されたアドレスに64bitデータを書き込む
     * @param addr 書き込み先アドレス
     * @param data 書き込む64bitデータ
     */
    void write64(uint64_t addr, uint64_t data) {
        // アドレスが8バイトの書き込み範囲内にあるかチェック
        uint64_t local_addr = addr - MemoryMap::SPM_BASE_ADDR;
        std::cout << "[SPM] Write64 to address 0x" << std::hex << addr << " data 0x" << data << std::dec << "\n";
        if (local_addr + 8 <= SPM_SIZE) {
            // 指定アドレスをuint64_t型ポインタとして解釈し、データを一括で書き込む
            *reinterpret_cast<uint64_t*>(&m_memory[local_addr]) = data;
        }
    }

    /**
     * @brief 指定されたアドレスから64bitデータを読み出す
     * @param addr 読み出し元アドレス
     * @return 読み出した64bitデータ。範囲外の場合は0を返す。
     */
    uint64_t read64(uint64_t addr) {
        // アドレスが8バイトの読み出し範囲内にあるかチェック
        uint64_t local_addr = addr - MemoryMap::SPM_BASE_ADDR;
        if (local_addr + 8 <= SPM_SIZE) {
            std::cout << "[SPM] Read64 from address 0x" << std::hex << addr << std::dec << "\n";    
            // 指定アドレスをuint64_t型ポインタとして解釈し、データを一括で読み出す
            return *reinterpret_cast<uint64_t*>(&m_memory[local_addr]);
        } else {
            std::cerr << "SPM: Read64 out of bounds! Addr: 0x" << std::hex << addr << std::dec << "\n";
            exit(1);
        }
        // return 0;
    }

private:
    std::array<uint8_t, SPM_SIZE> m_memory{};
};