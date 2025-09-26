#pragma once
#include <cstdint>
#include <iostream>
#include "memory_map.hpp"

#pragma once
#include <cstdint>
#include <iostream>
#include "memory_map.hpp"

// --- 1. 前方宣言 (名前だけを知らせる) ---
// これにより、Busクラス内でポインタメンバを宣言できる
class Dram;
class Spm;
class SpmModule;
class HashModule;
class AesModule;
class AxiManagerModule;

class Bus {
public:
    Bus(Dram& dram, Spm& spm) : m_dram(dram), m_spm(spm) {}

    // 接続用のメソッド宣言
    void connectSpmModule(SpmModule& mod) { m_spm_mod = &mod; }
    void connectHashModule(HashModule& mod) { m_hash_mod = &mod; }
    void connectAesModule(AesModule& mod) { m_aes_mod = &mod; }
    void connectAxiManagerModule(AxiManagerModule& mod) { m_axi_mgr_mod = &mod; }

    // アクセス用メソッドの宣言
    void write64(uint32_t addr, uint64_t data);
    uint64_t read64(uint32_t addr);

private:
    Dram& m_dram;
    Spm& m_spm;
    SpmModule* m_spm_mod = nullptr;
    HashModule* m_hash_mod = nullptr;
    AesModule* m_aes_mod = nullptr;
    AxiManagerModule* m_axi_mgr_mod = nullptr;
};


// --- 2. 完全な定義のインクルード ---
// Busのメソッドを実装する「直前」で、必要なクラスの全定義を読み込む
#include "dram.hpp"
#include "spm.hpp"
#include "spm_module.hpp"
#include "hash_module.hpp"
#include "aes_module.hpp"
#include "axi_manager_module.hpp"


// --- 3. メソッドの実装 ---
// この時点では、コンパイラは全てのクラスの詳細を知っているので、エラーにならない
inline void Bus::write64(uint32_t addr, uint64_t data) {
    // MMIOアドレス範囲の判定
    // std::cout << "[Bus] Write64 to Address 0x" << std::hex << addr << " Data 0x" << data << std::dec << "\n";
        if (addr >= MemoryMap::MMIO_SPM_DMA_BASE_ADDR && addr < MemoryMap::MMIO_MAC_BASE_ADDR) {
            if (m_spm_mod) m_spm_mod->mmioWrite64(addr - MemoryMap::MMIO_SPM_DMA_BASE_ADDR, data);
        } 
        else if (addr >= MemoryMap::MMIO_MAC_BASE_ADDR && addr < MemoryMap::MMIO_AES_ACCEL_BASE_ADDR) {
            if (m_hash_mod) m_hash_mod->mmioWrite64(addr - MemoryMap::MMIO_MAC_BASE_ADDR, data);
        }
        else if (addr >= MemoryMap::MMIO_AES_ACCEL_BASE_ADDR && addr < MemoryMap::MMIO_AXI_MGR_BASE_ADDR) {
            if (m_aes_mod) m_aes_mod->mmioWrite64(addr - MemoryMap::MMIO_AES_ACCEL_BASE_ADDR, data);
        }
        else if (addr >= MemoryMap::MMIO_AXI_MGR_BASE_ADDR && addr < MemoryMap::SPM_BASE_ADDR) {
            if (m_axi_mgr_mod) m_axi_mgr_mod->mmioWrite64(addr - MemoryMap::MMIO_AXI_MGR_BASE_ADDR, data);
        }
        // SPMデータ領域へのアクセス
        else if (addr >= MemoryMap::SPM_BASE_ADDR && addr < (MemoryMap::SPM_SIZE + MemoryMap::SPM_BASE_ADDR)) { // SPMの終端を仮定
            m_spm.write64(addr, data);
        }
        // DRAMへのアクセス
        else {
            m_dram.write64(addr, data);
        }
}

inline uint64_t Bus::read64(uint32_t addr) {
    // MMIOアドレス範囲の判定
        if (addr >= MemoryMap::MMIO_SPM_DMA_BASE_ADDR && addr < MemoryMap::MMIO_MAC_BASE_ADDR) {
            if (m_spm_mod) return m_spm_mod->mmioRead64(addr - MemoryMap::MMIO_SPM_DMA_BASE_ADDR);
        }
        else if (addr >= MemoryMap::MMIO_MAC_BASE_ADDR && addr < MemoryMap::MMIO_AES_ACCEL_BASE_ADDR) {
            if (m_hash_mod) return m_hash_mod->mmioRead64(addr - MemoryMap::MMIO_MAC_BASE_ADDR);
        }
        else if (addr >= MemoryMap::MMIO_AES_ACCEL_BASE_ADDR && addr < MemoryMap::MMIO_AXI_MGR_BASE_ADDR) {
            if (m_aes_mod) return m_aes_mod->mmioRead64(addr - MemoryMap::MMIO_AES_ACCEL_BASE_ADDR);
        }
        else if (addr >= MemoryMap::MMIO_AXI_MGR_BASE_ADDR && addr < MemoryMap::SPM_BASE_ADDR) {
            if (m_axi_mgr_mod) return m_axi_mgr_mod->mmioRead64(addr - MemoryMap::MMIO_AXI_MGR_BASE_ADDR);
        }
        // SPMデータ領域へのアクセス
        else if (addr >= MemoryMap::SPM_BASE_ADDR && addr < (MemoryMap::SPM_SIZE + MemoryMap::SPM_BASE_ADDR)) {
            return m_spm.read64(addr);
        }
        // DRAMへのアクセス
        else {
            return m_dram.read64(addr);
        }
        return 0; // 該当なし
}