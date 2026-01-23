#pragma once
#include "config.h"
int mac_lock = 0;
int dma_lock = 0;
int axim_lock = 0;
int xor_lock = 0;
int spm_lock = 0;
int print_lock = 0;
long tree_lock[CACHE_SETS] = {0};

void lock_print() {
    while (__sync_lock_test_and_set(&print_lock, 1)) {
    }
}
void unlock_print() {
    __sync_lock_release(&print_lock);
}
void lock_mac() {
    while (__sync_lock_test_and_set(&mac_lock, 1)) {
    }
}
void unlock_mac() {
    __sync_lock_release(&mac_lock);
}
static inline void lock_dma() {
    // 失敗したらノップを入れたい
    // int counter = 0;
    while (__sync_lock_test_and_set(&dma_lock, 1)) {
        // for (int i = 0; i < 4; i++) {
        //     asm volatile("nop");
        // }
        // asm volatile("nop");
        // asm volatile("nop");
        // asm volatile("nop");
        // counter++;
        // if (counter % 1000 == 0) {
        //     lock_print();
        //     int hartid = -1;
        //     asm volatile(
        //         "csrr %0, mhartid"
        //         : "=r"(hartid)
        //     );
        //     printf("DMA lock waiting... counter=%d hartid=%d\n", counter, hartid);
        //     unlock_print();
        // }
    }
}
static inline void unlock_dma() {
    __sync_lock_release(&dma_lock);
}
void lock_axim() {
    while (__sync_lock_test_and_set(&axim_lock, 1)) {
    }
}
void unlock_axim() {
    __sync_lock_release(&axim_lock);
}
void lock_xor() {
    while (__sync_lock_test_and_set(&xor_lock, 1)) {
    }
}
void unlock_xor() {
    __sync_lock_release(&xor_lock);
}
static inline void lock_spm(long set_index) {
    // int counter = 0;
    while (__sync_lock_test_and_set(&tree_lock[set_index], 1)) {
        // counter ++;
        // if (counter % 1000 == 0) {
        //     lock_print();
        //     int hartid = -1;
        //     asm volatile(
        //         "csrr %0, mhartid"
        //         : "=r"(hartid)
        //     );
        //     printf("SPM lock waiting... counter=%d hartid=%d\n", counter, hartid);
        //     unlock_print();
        // }
    }
}
void unlock_spm(long set_index) {
    __sync_lock_release(&tree_lock[set_index]);
}


static inline void lock_tree(long set_index) {
    // int counter = 0;
    // 1. まずアトミックにロック取得を試みる (Test-and-Set)
    while(1){
        if (__sync_lock_test_and_set(&tree_lock[set_index], 1) == 0) {
            return; // ロック取得成功！
        }

        // 2. 失敗したら、ロックが解放されるまで「読み出し」だけで待機する (Test)
        // volatile をつけることで、コンパイラによる「値が変わらないはず」という最適化を防ぐ
        while (*(volatile int*)&tree_lock[set_index] != 0) {
            // ここはただの Load 命令になるので、キャッシュ内で完結しバスを汚さない
            // RISC-Vの 'pause' 命令 (Zihintpause拡張) があればここで呼ぶのがベスト
            asm volatile ("nop"); // 軽いウェイト (必要に応じて pause 等に変更)
        }
    }

}
void unlock_tree(long set_index){
    __sync_lock_release(&tree_lock[set_index]);
}