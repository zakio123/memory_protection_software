#pragma once
#include <cstdint>

namespace MemoryMap {
    constexpr uint32_t MMIO_BASE_ADDR = 0x40000000;
    constexpr uint32_t SPM_BASE_ADDR  = 0x50000000;

    namespace DmaReg {
        constexpr uint32_t DRAM_ADDR   = 0x00;
        constexpr uint32_t SPM_ADDR    = 0x04;
        constexpr uint32_t SIZE        = 0x08;
        constexpr uint32_t DIRECTION   = 0x0C;
        constexpr uint32_t START       = 0x10;
    }
}