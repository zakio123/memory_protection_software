#include <stdio.h>
#include "config_mock.h"
// モック用のヘッダを spm_access.h として扱う
#include "spm_reg.h" 
// 実装ヘッダの読み込み (マクロで切り替えるため、ここではincludeのみ)
#include "cache_metadata_manage.h"

// --- テストユーティリティ ---
void print_result(const char* name, uint64_t start, uint64_t end, int count) {
    uint64_t total = end - start;
    // ループや計測自体のオーバーヘッドをざっくり引く(環境によるが数命令)
    // ここでは生の値を出します
    printf("[%-15s] Total: %5llu, Avg: %5llu insts\n", name, total, total / count);
}

int main() {
    printf("=== Cache Metadata Benchmark ===\n");
    #ifdef ENABLE_SPM_METADATA
    printf("Mode: SPM Packed (Manual bitwise ops)\n");
    // 擬似SPMのメタデータ領域を 0x60000000 からとする
    init_cache_system(0x60000000); 
    #else
    printf("Mode: RAM AoS (Compiler offset calc)\n");
    init_cache_system(0);
    #endif

    uint64_t start, end;
    dram_addr_t base_addr = 0x80001000;
    int LOOP_CNT = 100;

    // --- Test 1: Cold Miss (Allocate) ---
    // 毎回違うアドレスにアクセスして、Valid=0 なWayを探して埋めるコスト
    // ※ init直後なので全WayがValid=0
    start = read_instret();
    for (int i = 0; i < CACHE_WAYS * 8; i++) {
        dram_addr_t addr = base_addr + (i * 0x10000); // 同じセット、違うタグ
        tag_check(addr);
    }
    end = read_instret();
    print_result("Cold Miss", start, end, CACHE_WAYS * 8);


    // --- Test 2: Hit ---
    // さっき埋めたアドレスに再度アクセス。ヒット判定のコスト。
    start = read_instret();
    for (int i = 0; i < CACHE_WAYS * 8; i++) {
        dram_addr_t addr = base_addr + (i * 0x10000);
        tag_check(addr);
    }
    end = read_instret();
    print_result("Cache Hit", start, end, CACHE_WAYS * 8);


    // --- Test 3: Victim Search (Conflict Miss) ---
    // ウェイがいっぱいの状態で新しいアドレスにアクセス。
    // RefCount=0 を探して LRU更新 して返すコスト。
    dram_addr_t conflict_addr = base_addr + (CACHE_WAYS * 0x10000);
    start = read_instret();
    tag_check(conflict_addr);
    end = read_instret();
    print_result("Victim Search", start, end, 1);


    // --- Test 4: Acquire (Lock) ---
    // ヒット後のロック取得コスト (Read-Modify-Write)
    index_t set = get_cache_set_index(base_addr);
    start = read_instret();
    for(int i=0; i<LOOP_CNT; i++) {
        acquire_cache_block(set, 0);
    }
    end = read_instret();
    print_result("Acquire", start, end, LOOP_CNT);


    // --- Test 5: Release (Unlock) ---
    start = read_instret();
    for(int i=0; i<LOOP_CNT; i++) {
        release_cache_block(set, 0);
    }
    end = read_instret();
    print_result("Release", start, end, LOOP_CNT);

    return 0;
}