`include "dpi_mem_pkg.sv"
// 元の mem_combMem と同じポート・同じ挙動（R:同サイクルread, W:同期書込/バイトマスク）
module mem_combMem(
  input  [24:0] R0_addr,
  input         R0_en,
                 R0_clk,
  input  [24:0] W0_addr,
  input         W0_en,
                 W0_clk,
  input  [63:0] W0_data,
  input  [7:0]  W0_mask,
  output [63:0] R0_data
);
  import dpi_mem_pkg::*;

  // R口: 1拍ラッチ→同サイクルに組合せ読み（元の assign と同等）
  reg        _GEN;
  reg [24:0] _GEN_0;

  // 256MiB / 8B = 2^25 words を確保（plusargsで上書き可）
  initial begin
    longint unsigned words = 25'(1) << 25;
    dpi_mem_init_words(words);
  end

  always @(posedge R0_clk) begin
    _GEN   <= R0_en;
    _GEN_0 <= R0_addr;
  end

  // _GEN=1の時のみ有効値、0ならX（元実装に合わせる）
  assign R0_data = _GEN ? dpi_mem_read64_idx(_GEN_0) : 64'bx;

  // W口: posedgeでマスク付き1回呼び出し（論理等価）
  always @(posedge W0_clk) begin
    if (W0_en) dpi_mem_write64_mask_idx(W0_addr, W0_data, W0_mask);
  end
endmodule