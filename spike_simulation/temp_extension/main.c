#include <stdint.h>
#include <stdio.h>
/* エンコーディング定義 */
#define TMX_OPCODE 0x0b
#define TMX_F3     0x0

/* インラインアセンブラマクロ */
/* .insn r opcode, funct3, funct7, rd, rs1, rs2 */

#define TMX_INSN_R(funct7, rd, rs1, rs2) \
    asm volatile ( \
        ".insn r %1, %2, %3, %0, %4, %5" \
        : "=r"(rd) \
        : "i"(TMX_OPCODE), "i"(TMX_F3), "i"(funct7), "r"(rs1), "r"(rs2) \
    )

/* API関数 */

static inline long temp_find(uint64_t dram_addr) {
    long ret;
    TMX_INSN_R(0x00, ret, dram_addr, 0); // rs2=x0
    return ret;
}

static inline uint64_t temp_get_spm(long idx) {
    uint64_t ret;
    TMX_INSN_R(0x01, ret, idx, 0);
    return ret;
}

static inline long temp_alloc(uint64_t dram_addr, uint64_t spm_offset) {
    long ret;
    TMX_INSN_R(0x02, ret, dram_addr, spm_offset);
    return ret;
}

static inline long temp_invalidate(long idx) {
    long ret;
    TMX_INSN_R(0x03, ret, idx, 0);
    return ret;
}

static inline void temp_set_dirty(long idx) {
    long ret;
    TMX_INSN_R(0x04, ret, idx, 0);
}

static inline int temp_is_dirty(long idx) {
    long ret;
    TMX_INSN_R(0x05, ret, idx, 0);
    return (int)ret;
}

static inline void temp_acquire(long idx) {
    long ret;
    TMX_INSN_R(0x06, ret, idx, 0);
}

static inline void temp_release(long idx) {
    long ret;
    TMX_INSN_R(0x07, ret, idx, 0);
}

static inline void temp_set_loaded(long idx) {
    long ret;
    TMX_INSN_R(0x08, ret, idx, 0);
}

static inline int temp_is_loaded(long idx) {
    long ret;
    TMX_INSN_R(0x09, ret, idx, 0);
    return (int)ret;
}

static inline int temp_swappable(long idx) {
    long ret;
    TMX_INSN_R(0x0A, ret, idx, 0);
    return (int)ret;
}
void check(int condition, const char* message) {
    if (condition) {
        printf("[PASS] %s\n", message);
    } else {
        printf("[FAIL] %s\n", message);
    }
}
/* --- 4. メイン --- */
int main() {
    printf("=== Starting TMX (Temp Management Extension) Tests ===\n");

    uint64_t addr1 = 0x80001000;
    uint64_t spm1  = 0x100;
    uint64_t addr2 = 0x80002000;
    uint64_t spm2  = 0x200;

    // --- Test 1: Alloc & Find ---
    printf("\n--- Test 1: Allocation & Search ---\n");
    
    // 最初は何もないはず
    long idx1 = temp_find(addr1);
    check(idx1 == -1, "Find existing addr (should be -1)");

    // 割り当て
    idx1 = temp_alloc(addr1, spm1);
    printf("Allocated Addr1 to Index: %ld\n", idx1);
    check(idx1 != -1, "Alloc Addr1");

    // 検索確認
    long found_idx = temp_find(addr1);
    check(found_idx == idx1, "Find Addr1 returns correct index");

    // SPMオフセット確認
    uint64_t get_spm = temp_get_spm(idx1);
    check(get_spm == spm1, "Get SPM Offset matches");

    // 別のデータを割り当て
    long idx2 = temp_alloc(addr2, spm2);
    check(idx2 != -1 && idx2 != idx1, "Alloc Addr2 to different index");

    // --- Test 2: Status Flags (Dirty/Loaded) ---
    printf("\n--- Test 2: Flags (Dirty/Loaded) ---\n");

    check(temp_is_dirty(idx1) == 0, "Initial Dirty is 0");
    check(temp_is_loaded(idx1) == 0, "Initial Loaded is 0");

    temp_set_dirty(idx1);
    check(temp_is_dirty(idx1) == 1, "Set Dirty -> Is Dirty");

    temp_set_loaded(idx1);
    check(temp_is_loaded(idx1) == 1, "Set Loaded -> Is Loaded");

    // idx2には影響しないはず
    check(temp_is_dirty(idx2) == 0, "Idx2 Dirty remains 0");

    // --- Test 3: Locking & Swappable ---
    printf("\n--- Test 3: Locking ---\n");

    check(temp_swappable(idx1) == 1, "Initially Swappable (Ref=0)");

    temp_acquire(idx1); // Lock
    check(temp_swappable(idx1) == 0, "After Acquire -> Not Swappable");

    temp_release(idx1); // Unlock
    check(temp_swappable(idx1) == 1, "After Release -> Swappable");

    // --- Test 4: Invalidate ---
    printf("\n--- Test 4: Invalidation ---\n");

    long res = temp_invalidate(idx1);
    res = temp_invalidate(idx1);
    check(res == 0, "Invalidate Idx1");
    // 検索できなくなっているはず
    found_idx = temp_find(addr1);
    check(found_idx == -1, "Find Addr1 after invalidation returns -1");

    // idx2は生きているはず
    found_idx = temp_find(addr2);
    check(found_idx == idx2, "Addr2 is still valid");

    printf("\n=== All Tests Completed ===\n");
    return 0;
}
