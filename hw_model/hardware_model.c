#include <stdio.h>
#include "hardware_model.h"
#include "accelerator_regs.h"

// ハードウェア内部の状態を保持する変数
static int reg_a = 0;
static int reg_b = 0;
static int status = 0; // 0: Idle, 1: Busy

// MMIO書き込みがあった際のハードウェアの挙動
void hardware_write_reg(unsigned int addr, int value) {
    if (addr == REG_ADDR_A) {
        printf("  HW: Write detected on REG_A with value %d. Starting process...\n", value);
        
        // 1. 内部レジスタに値を保存
        reg_a = value;
        
        // 2. ステータスをBusy (1) に設定
        status = 1;
        printf("  HW: STATUS set to Busy (1).\n");
        
        // 3. 計算を実行
        printf("  HW: Calculating (value * 2)...\n");
        reg_b = reg_a * 2;
        
        // 4. ステータスをIdle (0) に戻す
        status = 0;
        printf("  HW: Calculation done. Result %d stored in REG_B.\n", reg_b);
        printf("  HW: STATUS set to Idle (0).\n");
    }
}

// MMIO読み出しがあった際のハードウェアの挙動
int hardware_read_reg(unsigned int addr) {
    switch (addr) {
        case REG_ADDR_STATUS:
            return status;
        case REG_ADDR_B:
            return reg_b;
        default:
            return 0;
    }
}