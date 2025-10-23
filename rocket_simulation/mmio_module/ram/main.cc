#include "Vmem_combMem.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

static vluint64_t main_time = 0;
double sc_time_stamp() { return main_time; }

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    auto* top = new Vmem_combMem;
    auto* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("wave.vcd");

    auto tick = [&](int n = 1) {
        for (int i = 0; i < n; i++) {
            top->R0_clk = 0; top->W0_clk = 0; top->eval(); tfp->dump(main_time++);
            top->R0_clk = 1; top->W0_clk = 1; top->eval(); tfp->dump(main_time++);
        }
    };

    // 初期値
    top->R0_en = 0; top->W0_en = 0; top->R0_addr = 0; top->W0_addr = 0;
    top->W0_mask = 0; top->W0_data = 0;
    tick(2);

    // 書き込み（idx=10 へ 0x1234...F0, 全byte有効）
    top->W0_en   = 1;
    top->W0_addr = 10;
    top->W0_data = 0x123456789ABCDEF0ull;
    top->W0_mask = 0xFF;
    tick(1);
    top->W0_en = 0;

    // 読み出し（R口は1拍ラッチ→同サイクルにコンビ出力）
    top->R0_en   = 1;
    top->R0_addr = 10;
    tick(2);
    std::cout << "[sim] R0_data = 0x" << std::hex << top->R0_data << std::dec << "\n";

    tfp->close();
    delete tfp;
    delete top;
    return 0;
}