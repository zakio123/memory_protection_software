#pragma once
#include <array>
#include <cstdint>
#include <cstring>

class Spm {
public:
    static constexpr size_t SPM_SIZE = 4096;

    void write(uint32_t addr, const uint8_t* data, uint32_t size) {
        if (addr + size <= SPM_SIZE) {
            std::memcpy(&m_memory[addr], data, size);
        }
    }

    void read(uint32_t addr, uint8_t* data, uint32_t size) {
        if (addr + size <= SPM_SIZE) {
            std::memcpy(data, &m_memory[addr], size);
        }
    }
    
    void write32(uint32_t addr, uint32_t data) {
        if (addr + 4 <= SPM_SIZE) {
            *reinterpret_cast<uint32_t*>(&m_memory[addr]) = data;
        }
    }

    uint32_t read32(uint32_t addr) {
        if (addr + 4 <= SPM_SIZE) {
            return *reinterpret_cast<uint32_t*>(&m_memory[addr]);
        }
        return 0;
    }

private:
    std::array<uint8_t, SPM_SIZE> m_memory{};
};