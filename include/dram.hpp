#pragma once
#include <vector>
#include <cstdint>
#include <iostream>
#include <cstring>

class Dram {
public:
    Dram(size_t size_bytes = 1024 * 1024) : m_memory(size_bytes) {
        std::cout << "DRAM: Initializing... (Size: " << size_bytes / 1024 << " KB)\n";
        // テストデータを書き込む
        const char* test_data = "Hello from DRAM!";
        write(0x1000, reinterpret_cast<const uint8_t*>(test_data), std::strlen(test_data) + 1);
    }

    void write(uint64_t addr, const uint8_t* data, uint64_t size) {
        if (addr + size <= m_memory.size()) {
            std::memcpy(&m_memory[addr], data, size);
        }
    }

    void read(uint64_t addr, uint8_t* data, uint64_t size) {
        if (addr + size <= m_memory.size()) {
            std::memcpy(data, &m_memory[addr], size);
        }
    }
    void write64(uint32_t addr, uint64_t data) {
        if (addr + 8 <= m_memory.size()) {
            *reinterpret_cast<uint64_t*>(&m_memory[addr]) = data;
        }
    }
    uint64_t read64(uint32_t addr) {
        if (addr + 8 <= m_memory.size()) {
            return *reinterpret_cast<uint64_t*>(&m_memory[addr]);
        }
        return 0;
    }

private:
    std::vector<uint8_t> m_memory;
};