#ifndef TEMP_MANAGER_H
#define TEMP_MANAGER_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "config.h"       // TEMP_POOL_SIZE, dram_addr_t 等
#include "tmx_encoding.h" // TMX_MATCH, F7_TMX_* 等




/* --- インラインアセンブラマクロ (HWモード用) --- */
#ifdef ENABLE_TMX_HARDWARE
#define TMX_INSN_R(funct7, rd, rs1, rs2) \
    asm volatile ( \
        ".insn r %1, %2, %3, %0, %4, %5" \
        : "=r"(rd) \
        : "i"(TMX_OPCODE), "i"(TMX_F3), "i"(funct7), "r"(rs1), "r"(rs2) \
    )
#endif

/* --- 外部変数宣言 (SWモード用) --- */
#ifndef ENABLE_TMX_HARDWARE
bool temp_valid[TEMP_POOL_SIZE];
bool temp_dirty[TEMP_POOL_SIZE];
bool temp_loaded[TEMP_POOL_SIZE];
int  temp_ref_count[TEMP_POOL_SIZE];
dram_addr_t temp_dram_addr[TEMP_POOL_SIZE];
spm_offset_t temp_spm_offset[TEMP_POOL_SIZE];

int active_indices[TEMP_POOL_SIZE];
int active_count;
int pos_in_active_list[TEMP_POOL_SIZE];
int free_indices[TEMP_POOL_SIZE];
int free_indices_top;

spm_offset_t temp_pool_stack[TEMP_POOL_SIZE];
int temp_pool_top;
#endif


/* =========================================================
   関数実装 (内部分岐)
   ========================================================= */

// --- Stack Operations ---

static inline int push_temp_buffer(spm_offset_t spm_addr) {
#ifdef ENABLE_TMX_HARDWARE
    long ret;
    TMX_INSN_R(F7_TMX_PUSH, ret, spm_addr, 0);
    return (int)ret;
#else
    if (temp_pool_top >= TEMP_POOL_SIZE - 1) {
        printf("temp_push: no free space in temp pool\n");
        return -1;
    }
    temp_pool_stack[++temp_pool_top] = spm_addr;
#endif
}

static inline spm_offset_t pop_temp_buffer() {
#ifdef ENABLE_TMX_HARDWARE
    long ret;
    TMX_INSN_R(F7_TMX_POP, ret, 0, 0);
    return (spm_offset_t)ret;
#else
    // if (temp_pool_top < 0) return 0;
    return temp_pool_stack[temp_pool_top--];
#endif
}

// --- Management Operations ---
static inline void temp_system_init(spm_offset_t temp_region_base) {
#ifdef ENABLE_TMX_HARDWARE
    // HW版: 指定領域をすべてHWプールにPush
    for (int i = 0; i < TEMP_POOL_SIZE; i++) {
        spm_offset_t addr = temp_region_base + i * 64;
        int ret = push_temp_buffer(addr);
        if (ret < 0) {
            printf("temp_system_init: failed to push addr %#lx\n", addr);
        }
    }
#else
    // SW版: テーブルとスタックの初期化
    for (int i = 0; i < TEMP_POOL_SIZE; i++) {
        temp_valid[i] = false;
        temp_dirty[i] = false;
        temp_dram_addr[i] = 0;
        temp_spm_offset[i] = 0;
        temp_ref_count[i] = 0;
        temp_loaded[i] = false;
        free_indices[i] = i;
        pos_in_active_list[i] = -1;
    }
    free_indices_top = TEMP_POOL_SIZE - 1;
    active_count = 0;
    // プール初期化
    temp_pool_top = -1;
    for (int i = 0; i < TEMP_POOL_SIZE; i++) {
        temp_pool_stack[++temp_pool_top] = temp_region_base + i*64;
    }
#endif
}

static inline int find_temp_entry(dram_addr_t dram_addr) {
#ifdef ENABLE_TMX_HARDWARE
    long ret;
    TMX_INSN_R(F7_TMX_FIND, ret, dram_addr, 0);
    return (int)ret;
#else
    for (int k = 0; k < active_count; k++) {
        int idx = active_indices[k];
        if (temp_dram_addr[idx] == dram_addr) {
            return idx;
        }
    }
    return -1;
#endif
}

static inline spm_offset_t get_temp_spm_offset(int idx) {
#ifdef ENABLE_TMX_HARDWARE
    long ret;
    TMX_INSN_R(F7_TMX_GET_SPM, ret, idx, 0);
    return (spm_offset_t)ret;
#else
    return temp_spm_offset[idx];
#endif
}

static inline long alloc_temp_entry(dram_addr_t dram_addr, spm_offset_t spm_offset) {
#ifdef ENABLE_TMX_HARDWARE
    long ret;
    TMX_INSN_R(F7_TMX_ALLOC, ret, dram_addr, spm_offset);
    return ret;
#else
    if (free_indices_top < 0) return -1;
    spm_offset_t real_spm = spm_offset;
    // もしSW版でもここだけで完結させたいなら：
    // spm_offset_t real_spm = pop_temp_buffer();

    int idx = free_indices[free_indices_top--];
    temp_valid[idx] = true;
    temp_dirty[idx] = false;
    temp_dram_addr[idx] = dram_addr;
    temp_spm_offset[idx] = real_spm;
    temp_ref_count[idx] = 0;
    
    active_indices[active_count] = idx;
    pos_in_active_list[idx] = active_count;
    active_count++;
    return idx;
#endif
}

static inline long invalidate_temp_entry_by_index(long idx) {
#ifdef ENABLE_TMX_HARDWARE
    long ret;
    TMX_INSN_R(F7_TMX_INVALID, ret, idx, 0);
    return ret;
#else
    if (idx < 0 || !temp_valid[idx]) return -1;
    
    temp_valid[idx] = false;
    temp_dirty[idx] = false;
    temp_loaded[idx] = false;
    
    // Swap removal
    long pos = pos_in_active_list[idx];
    long last_idx = active_indices[active_count - 1];
    
    active_indices[pos] = last_idx;
    pos_in_active_list[last_idx] = pos;
    active_count--;
    
    free_indices[++free_indices_top] = idx;
    return 0;
#endif
}

static inline long dirty_temp_entry_by_index(long idx) {
#ifdef ENABLE_TMX_HARDWARE
    long ret; 
    TMX_INSN_R(F7_TMX_SET_D, ret, idx, 0);
    return ret;
#else
    if (idx < 0 || !temp_valid[idx]) return -1;
    temp_dirty[idx] = true;
    return 0;
#endif
}

static inline bool is_dirty_temp_entry_by_index(long idx) {
#ifdef ENABLE_TMX_HARDWARE
    long ret; TMX_INSN_R(F7_TMX_IS_D, ret, idx, 0); return (bool)ret;
#else
    return temp_dirty[idx];
#endif
}

static inline bool acquire_temp_entry_by_index(long idx) {
#ifdef ENABLE_TMX_HARDWARE
    long ret; 
    TMX_INSN_R(F7_TMX_ACQ, ret, idx, 0); 
    return (bool)ret;
#else
    if (idx < 0 || !temp_valid[idx]) return false;
    temp_ref_count[idx]++;
    return true;
#endif
}

static inline bool release_temp_entry_by_index(long idx) {
#ifdef ENABLE_TMX_HARDWARE
    long ret; 
    TMX_INSN_R(F7_TMX_REL, ret, idx, 0); 
    return (bool)ret;
#else
    if (idx < 0 || !temp_valid[idx]) return false;
    if (temp_ref_count[idx] > 0) temp_ref_count[idx]--;
    return true;
#endif
}

static inline long set_loaded_temp_entry_by_index(long idx) {
#ifdef ENABLE_TMX_HARDWARE
    long ret; TMX_INSN_R(F7_TMX_SET_L, ret, idx, 0);
    return ret;
#else
    if (idx < 0 || !temp_valid[idx]) return -1;
    temp_loaded[idx] = true;
    return 0;
#endif
}

static inline bool is_loaded_temp_entry_by_index(long idx) {
#ifdef ENABLE_TMX_HARDWARE
    long ret; TMX_INSN_R(F7_TMX_IS_L, ret, idx, 0); return (bool)ret;
#else
    if (idx < 0 || !temp_valid[idx]) return false;
    return temp_loaded[idx];
#endif
}

static inline bool swappable_temp_entry_by_index(int idx) {
#ifdef ENABLE_TMX_HARDWARE
    long ret; TMX_INSN_R(F7_TMX_SWAP, ret, idx, 0); return (bool)ret;
#else
    return (temp_ref_count[idx] == 0);
#endif
}

static inline void printf_temp_table_status(long idx) {
#ifdef ENABLE_TMX_HARDWARE
    // HW版: ステータス表示命令はないのでここでは何もしない
#else
    if (idx < 0 || !temp_valid[idx]) {
        printf("Temp Entry %d is invalid.\n", idx);
        return;
    }
    printf("Temp Entry %d: Valid=%d, Dirty=%d, Loaded=%d, Ref=%d, Addr=%016llx, SPM=%016llx\n",
           idx, temp_valid[idx], temp_dirty[idx], temp_loaded[idx], 
           temp_ref_count[idx], temp_dram_addr[idx], temp_spm_offset[idx]);
#endif
}

#endif // TEMP_MANAGER_H