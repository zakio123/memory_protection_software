#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <inttypes.h>
#include "config.h" 
#include "cache_controll.h"

// --- テスト用マクロ ---
#define ASSERT_LOG(fmt, ...) printf("[TEST_LOG] " fmt "\n", ##__VA_ARGS__)

// --- ヘルパー関数: キャッシュの状態をダンプ ---
// 特定のセットのValid, Dirty, RefCount, AccessCountを表示
void dump_set_state(index_t set_idx) {
    printf("  [State Set:%u] ", set_idx);
    for (int w = 0; w < CACHE_WAYS; w++) {
        // HWモードでもメタデータ配列(access_count_metadata等)はSW側で管理している前提のコードになっているため直接読みます
        // HWモードでTMU内部状態が見えない場合は、swappableなどの関数経由で推測します
        bool is_v = is_block_valid(set_idx, w);
        bool is_d = is_block_dirty(set_idx, w);
        bool is_swap = swappable_cache_block(set_idx, w);
        uint32_t cnt = access_count_metadata[set_idx][w]; 
        
        printf("W%d(V:%d D:%d Swp:%d Cnt:%u) ", w, is_v, is_d, is_swap, cnt);
    }
    printf("\n");
}

// --- テストシナリオ ---

// 1. 基本的なFillとHitの挙動確認
void test_basic_fill_hit() {
    ASSERT_LOG("--- Test 1: Basic Fill & Hit ---");
    
    // Set 0 にマッピングされるアドレスを想定
    dram_addr_t addr1 = 0x1000; 
    index_t set_idx = get_cache_set_index(addr1);
    
    ASSERT_LOG("Checking Addr: 0x%llx (Set: %u)", addr1, set_idx);

    // 1-1. Cold Miss (Fill)
    light_tag_info_t info = light_tag_check(addr1);
    ASSERT_LOG("Access 1 (Cold Miss): Hit=%d, Way=%d", info.hit, info.way);
    set_block_valid(set_idx, info.way);
    printf("validated way %d for addr 0x%llx\n", info.way, addr1);
    if (!info.hit) {
        // ミスしたらデータをSPMに入れたと仮定してセットアップ
        struct Info tag_update = tag_check(addr1);
        spm_copy_to_local(addr1, tag_update.spm_offset, 64, 0);
        spm_wait(0);
    }
    dump_set_state(set_idx);

    // 1-2. Hit
    struct Info in = tag_check(addr1);
    ASSERT_LOG("Access 2 (Expected Hit): Hit=%d, Way=%d, Dirty=%d", in.hit, in.way, in.dirty);
    dump_set_state(set_idx);
}

// 2. LRU追い出しポリシーの確認
void test_eviction_policy() {
    ASSERT_LOG("--- Test 2: Eviction Policy (LRU) ---");
    
    // Set 1 を使用
    // Set 1 にマッピングされるアドレスをCACHE_WAYS + 1個用意
    // 仮にCACHE_WAYS=4と仮定。環境に合わせてループ数を調整してください。
    int ways = CACHE_WAYS;
    dram_addr_t base_addr = 0x2000; // Set index計算に依存します
    
    // 最初にSet Indexを固定するためのオフセット計算（簡易的）
    // 実際の実装に合わせて調整が必要ですが、ここでは単純にアドレスをずらします
    index_t target_set = get_cache_set_index(base_addr);
    
    ASSERT_LOG("Target Set: %u (Ways: %d)", target_set, ways);

    // Step 1: Wayをすべて埋める
    for (int i = 0; i < ways; i++) {
        dram_addr_t addr = base_addr + (i * 0x100000); // Set indexが変わらないように大きくずらす
        // Check Set Index
        if (get_cache_set_index(addr) != target_set) {
            ASSERT_LOG("Error: Address generation failed to hit same set.");
            return;
        }

        struct Info info = tag_check(addr);
        if (!info.hit) {
            swapp_temp_cache(addr, info, 0x200 + i*64, false); // Fill
        }
        ASSERT_LOG("Fill Way %d: Addr 0x%llx -> Selected Way %d", i, addr, info.way);
    }
    dump_set_state(target_set);

    // Step 2: アクセス頻度に差をつける
    // Way 0, 1, 2 を再度アクセスしてカウンターを上げる（Way 3がLRUになるはず）
    for (int k=0; k<2; k++) { // 何回かアクセス
        for (int i = 0; i < ways - 1; i++) {
            dram_addr_t addr = base_addr + (i * 0x100000);
            tag_check(addr); 
        }
    }
    ASSERT_LOG("After updating LRU counters (Should protect Way 0-%d):", ways-2);
    dump_set_state(target_set);

    // Step 3: 新しいアドレスでアクセスして追い出し発生
    dram_addr_t new_addr = base_addr + (ways * 0x100000);
    struct Info eviction_info = tag_check(new_addr);
    
    ASSERT_LOG("Eviction Access: Addr 0x%llx -> Hit=%d, Way=%d, Dirty=%d", 
               new_addr, eviction_info.hit, eviction_info.way, eviction_info.dirty);

    // 期待値: カウンタが一番小さい(更新されていない) Way (このシナリオでは最後のWay) が選ばれるはず
    dump_set_state(target_set);
}

// 3. ロック（参照カウント）による追い出し禁止の確認
void test_locking_behavior() {
    ASSERT_LOG("--- Test 3: Locking (Ref Count) ---");

    index_t set_idx = 10; // 適当なセット
    dram_addr_t addr = 0x30000 + (set_idx * 64); // マッピング調整
    
    // 1. Fill & Lock
    struct Info info = tag_check(addr);
    if (!info.hit) swapp_temp_cache(addr, info, 0x300, false);
    
    // ロック取得
    bool locked = acquire_cache_block(set_idx, info.way);
    ASSERT_LOG("Acquire Block Way %d: Result=%d", info.way, locked);
    dump_set_state(set_idx);

    // 2. 他のWayを埋めて、無理やりこのWayを追い出し候補にする状況を作る
    // （実装のLRUロジック次第ですが、lockedなブロックはswappable_cache_blockがfalseを返すはず）
    
    // テスト簡略化のため、swappableチェックを直接呼び出し
    bool can_swap = swappable_cache_block(set_idx, info.way);
    ASSERT_LOG("Is Way %d swappable? : %d (Expect 0)", info.way, can_swap);

    // 3. ロック解除
    release_cache_block(set_idx, info.way);
    can_swap = swappable_cache_block(set_idx, info.way);
    ASSERT_LOG("Released. Is Way %d swappable? : %d (Expect 1)", info.way, can_swap);
}

// 4. Dirty Bitの挙動確認
void test_dirty_bit() {
    ASSERT_LOG("--- Test 4: Dirty Bit Logic ---");
    index_t set_idx = 20;
    dram_addr_t addr = 0x40000 + (set_idx * 64);

    // Fill
    struct Info info = tag_check(addr);
    if (!info.hit) swapp_temp_cache(addr, info, 0x400, false);

    // Dirtyセット
    set_block_dirty(set_idx, info.way);
    bool d = is_block_dirty(set_idx, info.way);
    ASSERT_LOG("Set Dirty Way %d -> is_dirty: %d", info.way, d);

    // Tag CheckでDirty情報が返るか（Hit時）
    struct Info hit_info = tag_check(addr);
    ASSERT_LOG("Tag Check (Hit) -> Dirty in Info: %d", hit_info.dirty);

    // Clear
    clear_block_dirty(set_idx, info.way);
    d = is_block_dirty(set_idx, info.way);
    ASSERT_LOG("Clear Dirty Way %d -> is_dirty: %d", info.way, d);
}

int main() {
    ASSERT_LOG("Starting Cache System Test...");
    
    init_cache_system();
    
    test_basic_fill_hit();
    test_eviction_policy();
    test_locking_behavior();
    test_dirty_bit();

    ASSERT_LOG("Test Finished.");
    return 0;
}