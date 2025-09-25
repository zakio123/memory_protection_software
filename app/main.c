#include <stdio.h>
#include "software_if.h"
#include "accelerator_regs.h"

int app_main() {
    int input_val = 21;
    printf("SW:   Setting input value (%d) to REG_A.\n", input_val);

    // 1. レジスタAに値を書き込む (これがトリガーになる)
    mmio_write(REG_ADDR_A, input_val);

    printf("SW:   Waiting for calculation to complete...\n");

    // 2. STATUSレジスタが0 (Idle) になるまでポーリングして待つ
    while (mmio_read(REG_ADDR_STATUS) == 1) {
        // busy-wait
    }

    printf("SW:   Calculation finished.\n");

    // 3. レジスタBから結果を読み取る
    int result = mmio_read(REG_ADDR_B);

    printf("SW:   Read result from REG_B: %d\n", result);

    if (result == input_val * 2) {
        printf("SW:   SUCCESS!\n");
    } else {
        printf("SW:   FAILURE...\n");
    }

    return 0;
}