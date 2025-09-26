#pragma once
#include <cstdint>

namespace MemoryMap {
    // 各コンポーネントのベースアドレス
    constexpr uint64_t PROTECTION_BASE_ADDR = 0x00000000;
    constexpr uint64_t PROTECTION_SIZE = 0x20000000; // 512MB
    constexpr uint64_t COUNTER_BASE_ADDR = 0x20000000;
    constexpr uint64_t COUNTER_SIZE = 1024 * 1024 * 16; // 16MB
    constexpr uint64_t DATA_TAG_BASE_ADDR = COUNTER_BASE_ADDR + COUNTER_SIZE; // 0x20020000
    constexpr uint64_t DATA_TAG_SIZE = 1024 * 1024 * 64; // 64MB


    constexpr uint64_t MMIO_SPM_DMA_BASE_ADDR   = 0x40000000;
    constexpr uint64_t MMIO_MAC_BASE_ADDR = 0x40010000;
    constexpr uint64_t MMIO_AES_ACCEL_BASE_ADDR  = 0x40020000;
    constexpr uint64_t MMIO_AXI_MGR_BASE_ADDR   = 0x40030000;
    // constexpr uint64_t MMIO_BASE_ADDR            = MMIO_SPM_DMA_BASE_ADDR;
    constexpr uint64_t SPM_BASE_ADDR        = 0x50000000;
    constexpr uint64_t SPM_SIZE               = 0x00001000; // 4KB

    // SpmDmaController用レジスタ・オフセット
    namespace SPM_Reg {
        constexpr uint64_t DRAM_ADDR = 0x00;
        constexpr uint64_t SPM_ADDR  = 0x08;
        constexpr uint64_t SIZE      = 0x10;
        constexpr uint64_t DIRECTION = 0x18;
        constexpr uint64_t START     = 0x20;
    }

    // HashAccelerator用レジスタ・オフセット
    namespace MacReg {
        constexpr uint64_t SPM_ADDR     = 0x00;
        constexpr uint64_t SPM_START    = 0x08;
        constexpr uint64_t COMMAND      = 0x10;
        constexpr uint64_t START_BIT    = 0x18;
        constexpr uint64_t END_BIT      = 0x20;
        constexpr uint64_t STATUS       = 0x28;
        constexpr uint64_t MAC_RESULT = 0x30;
    }
    namespace AesReg{
        constexpr uint64_t INPUT_0 = 0x00;
        constexpr uint64_t INPUT_1 = 0x08;
        constexpr uint64_t INPUT_2 = 0x10;
        constexpr uint64_t INPUT_3 = 0x18;
        constexpr uint64_t INPUT_4 = 0x20;
        constexpr uint64_t INPUT_5 = 0x28;
        constexpr uint64_t INPUT_6 = 0x30;
        constexpr uint64_t INPUT_7 = 0x38;
        constexpr uint64_t START = 0x40;
    }
    namespace AxiManagerReg {
        constexpr uint64_t STATUS = 0x00;
        constexpr uint64_t REQ_ADDR = 0x08;
        constexpr uint64_t REQ_ID = 0x10;
        constexpr uint64_t SPM_ADDR = 0x18;
        constexpr uint64_t COMMAND = 0x20;
        constexpr uint64_t BUSY = 0x28;
    }
}