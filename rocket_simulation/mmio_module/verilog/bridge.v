

module bridge
(
  input CLK,
  input RST,
  input [4-1:0] axi_s_bridge_awid,
  input [32-1:0] axi_s_bridge_awaddr,
  input [8-1:0] axi_s_bridge_awlen,
  input [3-1:0] axi_s_bridge_awsize,
  input [2-1:0] axi_s_bridge_awburst,
  input [1-1:0] axi_s_bridge_awlock,
  input [4-1:0] axi_s_bridge_awcache,
  input [3-1:0] axi_s_bridge_awprot,
  input [4-1:0] axi_s_bridge_awqos,
  input [2-1:0] axi_s_bridge_awuser,
  input axi_s_bridge_awvalid,
  output axi_s_bridge_awready,
  input [64-1:0] axi_s_bridge_wdata,
  input [8-1:0] axi_s_bridge_wstrb,
  input axi_s_bridge_wlast,
  input axi_s_bridge_wvalid,
  output axi_s_bridge_wready,
  output reg [4-1:0] axi_s_bridge_bid,
  output [2-1:0] axi_s_bridge_bresp,
  output reg axi_s_bridge_bvalid,
  input axi_s_bridge_bready,
  input [4-1:0] axi_s_bridge_arid,
  input [32-1:0] axi_s_bridge_araddr,
  input [8-1:0] axi_s_bridge_arlen,
  input [3-1:0] axi_s_bridge_arsize,
  input [2-1:0] axi_s_bridge_arburst,
  input [1-1:0] axi_s_bridge_arlock,
  input [4-1:0] axi_s_bridge_arcache,
  input [3-1:0] axi_s_bridge_arprot,
  input [4-1:0] axi_s_bridge_arqos,
  input [2-1:0] axi_s_bridge_aruser,
  input axi_s_bridge_arvalid,
  output axi_s_bridge_arready,
  output reg [4-1:0] axi_s_bridge_rid,
  output reg [64-1:0] axi_s_bridge_rdata,
  output [2-1:0] axi_s_bridge_rresp,
  output reg axi_s_bridge_rlast,
  output reg axi_s_bridge_rvalid,
  input axi_s_bridge_rready,
  output [32-1+1-1:0] axi_m_dram_awaddr,
  output [8-1+1-1:0] axi_m_dram_awlen,
  output [3-1+1-1:0] axi_m_dram_awsize,
  output [2-1+1-1:0] axi_m_dram_awburst,
  output [1-1+1-1:0] axi_m_dram_awlock,
  output [4-1+1-1:0] axi_m_dram_awcache,
  output [3-1+1-1:0] axi_m_dram_awprot,
  output [4-1+1-1:0] axi_m_dram_awqos,
  output [2-1+1-1:0] axi_m_dram_awuser,
  output axi_m_dram_awvalid,
  input axi_m_dram_awready,
  output [128-1+1-1:0] axi_m_dram_wdata,
  output [16-1+1-1:0] axi_m_dram_wstrb,
  output axi_m_dram_wlast,
  output axi_m_dram_wvalid,
  input axi_m_dram_wready,
  input [2-1+1-1:0] axi_m_dram_bresp,
  input axi_m_dram_bvalid,
  output axi_m_dram_bready,
  output [32-1+1-1:0] axi_m_dram_araddr,
  output [8-1+1-1:0] axi_m_dram_arlen,
  output [3-1+1-1:0] axi_m_dram_arsize,
  output [2-1+1-1:0] axi_m_dram_arburst,
  output [1-1+1-1:0] axi_m_dram_arlock,
  output [4-1+1-1:0] axi_m_dram_arcache,
  output [3-1+1-1:0] axi_m_dram_arprot,
  output [4-1+1-1:0] axi_m_dram_arqos,
  output [2-1+1-1:0] axi_m_dram_aruser,
  output axi_m_dram_arvalid,
  input axi_m_dram_arready,
  input [128-1+1-1:0] axi_m_dram_rdata,
  input [2-1+1-1:0] axi_m_dram_rresp,
  input axi_m_dram_rlast,
  input axi_m_dram_rvalid,
  output axi_m_dram_rready,
  input [32-1+1-1:0] axi_s_llc_awaddr,
  input [8-1+1-1:0] axi_s_llc_awlen,
  input [3-1+1-1:0] axi_s_llc_awsize,
  input [2-1+1-1:0] axi_s_llc_awburst,
  input [1-1+1-1:0] axi_s_llc_awlock,
  input [4-1+1-1:0] axi_s_llc_awcache,
  input [3-1+1-1:0] axi_s_llc_awprot,
  input [4-1+1-1:0] axi_s_llc_awqos,
  input [2-1+1-1:0] axi_s_llc_awuser,
  input axi_s_llc_awvalid,
  output axi_s_llc_awready,
  input [128-1+1-1:0] axi_s_llc_wdata,
  input [16-1+1-1:0] axi_s_llc_wstrb,
  input axi_s_llc_wlast,
  input axi_s_llc_wvalid,
  output axi_s_llc_wready,
  output [2-1+1-1:0] axi_s_llc_bresp,
  output axi_s_llc_bvalid,
  input axi_s_llc_bready,
  input [32-1+1-1:0] axi_s_llc_araddr,
  input [8-1+1-1:0] axi_s_llc_arlen,
  input [3-1+1-1:0] axi_s_llc_arsize,
  input [2-1+1-1:0] axi_s_llc_arburst,
  input [1-1+1-1:0] axi_s_llc_arlock,
  input [4-1+1-1:0] axi_s_llc_arcache,
  input [3-1+1-1:0] axi_s_llc_arprot,
  input [4-1+1-1:0] axi_s_llc_arqos,
  input [2-1+1-1:0] axi_s_llc_aruser,
  input axi_s_llc_arvalid,
  output axi_s_llc_arready,
  output [128-1+1-1:0] axi_s_llc_rdata,
  output [2-1+1-1:0] axi_s_llc_rresp,
  output axi_s_llc_rlast,
  output axi_s_llc_rvalid,
  input axi_s_llc_rready
);

  reg [32-1+1-1:0] axi_s_ctrl_spm_awaddr;
  reg [4-1+1-1:0] axi_s_ctrl_spm_awcache;
  reg [3-1+1-1:0] axi_s_ctrl_spm_awprot;
  reg axi_s_ctrl_spm_awvalid;
  wire axi_s_ctrl_spm_awready;
  reg [64-1+1-1:0] axi_s_ctrl_spm_wdata;
  reg [8-1+1-1:0] axi_s_ctrl_spm_wstrb;
  reg axi_s_ctrl_spm_wvalid;
  wire axi_s_ctrl_spm_wready;
  wire [2-1+1-1:0] axi_s_ctrl_spm_bresp;
  wire axi_s_ctrl_spm_bvalid;
  reg axi_s_ctrl_spm_bready;
  reg [32-1+1-1:0] axi_s_ctrl_spm_araddr;
  reg [4-1+1-1:0] axi_s_ctrl_spm_arcache;
  reg [3-1+1-1:0] axi_s_ctrl_spm_arprot;
  reg axi_s_ctrl_spm_arvalid;
  wire axi_s_ctrl_spm_arready;
  wire [64-1+1-1:0] axi_s_ctrl_spm_rdata;
  wire [2-1+1-1:0] axi_s_ctrl_spm_rresp;
  wire axi_s_ctrl_spm_rvalid;
  reg axi_s_ctrl_spm_rready;
  reg [32-1+1-1:0] axi_s_ctrl_mac_awaddr;
  reg [4-1+1-1:0] axi_s_ctrl_mac_awcache;
  reg [3-1+1-1:0] axi_s_ctrl_mac_awprot;
  reg axi_s_ctrl_mac_awvalid;
  wire axi_s_ctrl_mac_awready;
  reg [64-1+1-1:0] axi_s_ctrl_mac_wdata;
  reg [8-1+1-1:0] axi_s_ctrl_mac_wstrb;
  reg axi_s_ctrl_mac_wvalid;
  wire axi_s_ctrl_mac_wready;
  wire [2-1+1-1:0] axi_s_ctrl_mac_bresp;
  wire axi_s_ctrl_mac_bvalid;
  reg axi_s_ctrl_mac_bready;
  reg [32-1+1-1:0] axi_s_ctrl_mac_araddr;
  reg [4-1+1-1:0] axi_s_ctrl_mac_arcache;
  reg [3-1+1-1:0] axi_s_ctrl_mac_arprot;
  reg axi_s_ctrl_mac_arvalid;
  wire axi_s_ctrl_mac_arready;
  wire [64-1+1-1:0] axi_s_ctrl_mac_rdata;
  wire [2-1+1-1:0] axi_s_ctrl_mac_rresp;
  wire axi_s_ctrl_mac_rvalid;
  reg axi_s_ctrl_mac_rready;
  reg [32-1+1-1:0] axi_s_ctrl_xor_awaddr;
  reg [4-1+1-1:0] axi_s_ctrl_xor_awcache;
  reg [3-1+1-1:0] axi_s_ctrl_xor_awprot;
  reg axi_s_ctrl_xor_awvalid;
  wire axi_s_ctrl_xor_awready;
  reg [64-1+1-1:0] axi_s_ctrl_xor_wdata;
  reg [8-1+1-1:0] axi_s_ctrl_xor_wstrb;
  reg axi_s_ctrl_xor_wvalid;
  wire axi_s_ctrl_xor_wready;
  wire [2-1+1-1:0] axi_s_ctrl_xor_bresp;
  wire axi_s_ctrl_xor_bvalid;
  reg axi_s_ctrl_xor_bready;
  reg [32-1+1-1:0] axi_s_ctrl_xor_araddr;
  reg [4-1+1-1:0] axi_s_ctrl_xor_arcache;
  reg [3-1+1-1:0] axi_s_ctrl_xor_arprot;
  reg axi_s_ctrl_xor_arvalid;
  wire axi_s_ctrl_xor_arready;
  wire [64-1+1-1:0] axi_s_ctrl_xor_rdata;
  wire [2-1+1-1:0] axi_s_ctrl_xor_rresp;
  wire axi_s_ctrl_xor_rvalid;
  reg axi_s_ctrl_xor_rready;
  reg [32-1+1-1:0] axi_s_ctrl_aes_awaddr;
  reg [4-1+1-1:0] axi_s_ctrl_aes_awcache;
  reg [3-1+1-1:0] axi_s_ctrl_aes_awprot;
  reg axi_s_ctrl_aes_awvalid;
  wire axi_s_ctrl_aes_awready;
  reg [64-1+1-1:0] axi_s_ctrl_aes_wdata;
  reg [8-1+1-1:0] axi_s_ctrl_aes_wstrb;
  reg axi_s_ctrl_aes_wvalid;
  wire axi_s_ctrl_aes_wready;
  wire [2-1+1-1:0] axi_s_ctrl_aes_bresp;
  wire axi_s_ctrl_aes_bvalid;
  reg axi_s_ctrl_aes_bready;
  reg [32-1+1-1:0] axi_s_ctrl_aes_araddr;
  reg [4-1+1-1:0] axi_s_ctrl_aes_arcache;
  reg [3-1+1-1:0] axi_s_ctrl_aes_arprot;
  reg axi_s_ctrl_aes_arvalid;
  wire axi_s_ctrl_aes_arready;
  wire [64-1+1-1:0] axi_s_ctrl_aes_rdata;
  wire [2-1+1-1:0] axi_s_ctrl_aes_rresp;
  wire axi_s_ctrl_aes_rvalid;
  reg axi_s_ctrl_aes_rready;
  reg [32-1+1-1:0] axi_s_ctrl_axim_awaddr;
  reg [4-1+1-1:0] axi_s_ctrl_axim_awcache;
  reg [3-1+1-1:0] axi_s_ctrl_axim_awprot;
  reg axi_s_ctrl_axim_awvalid;
  wire axi_s_ctrl_axim_awready;
  reg [64-1+1-1:0] axi_s_ctrl_axim_wdata;
  reg [8-1+1-1:0] axi_s_ctrl_axim_wstrb;
  reg axi_s_ctrl_axim_wvalid;
  wire axi_s_ctrl_axim_wready;
  wire [2-1+1-1:0] axi_s_ctrl_axim_bresp;
  wire axi_s_ctrl_axim_bvalid;
  reg axi_s_ctrl_axim_bready;
  reg [32-1+1-1:0] axi_s_ctrl_axim_araddr;
  reg [4-1+1-1:0] axi_s_ctrl_axim_arcache;
  reg [3-1+1-1:0] axi_s_ctrl_axim_arprot;
  reg axi_s_ctrl_axim_arvalid;
  wire axi_s_ctrl_axim_arready;
  wire [64-1+1-1:0] axi_s_ctrl_axim_rdata;
  wire [2-1+1-1:0] axi_s_ctrl_axim_rresp;
  wire axi_s_ctrl_axim_rvalid;
  reg axi_s_ctrl_axim_rready;
  reg [32-1+1-1:0] axi_s_spm_data_awaddr;
  reg [4-1+1-1:0] axi_s_spm_data_awcache;
  reg [3-1+1-1:0] axi_s_spm_data_awprot;
  reg axi_s_spm_data_awvalid;
  wire axi_s_spm_data_awready;
  reg [64-1+1-1:0] axi_s_spm_data_wdata;
  reg [8-1+1-1:0] axi_s_spm_data_wstrb;
  reg axi_s_spm_data_wvalid;
  wire axi_s_spm_data_wready;
  wire [2-1+1-1:0] axi_s_spm_data_bresp;
  wire axi_s_spm_data_bvalid;
  reg axi_s_spm_data_bready;
  reg [32-1+1-1:0] axi_s_spm_data_araddr;
  reg [4-1+1-1:0] axi_s_spm_data_arcache;
  reg [3-1+1-1:0] axi_s_spm_data_arprot;
  reg axi_s_spm_data_arvalid;
  wire axi_s_spm_data_arready;
  wire [64-1+1-1:0] axi_s_spm_data_rdata;
  wire [2-1+1-1:0] axi_s_spm_data_rresp;
  wire axi_s_spm_data_rvalid;
  reg axi_s_spm_data_rready;
  reg [32-1:0] axi_m_ctrl_spm_awaddr;
  wire [4-1:0] axi_m_ctrl_spm_awcache;
  wire [3-1:0] axi_m_ctrl_spm_awprot;
  reg axi_m_ctrl_spm_awvalid;
  wire axi_m_ctrl_spm_awready;
  assign axi_m_ctrl_spm_awcache = 3;
  assign axi_m_ctrl_spm_awprot = 0;
  wire [64-1:0] axi_m_ctrl_spm_wdata;
  wire [8-1:0] axi_m_ctrl_spm_wstrb;
  wire axi_m_ctrl_spm_wvalid;
  wire axi_m_ctrl_spm_wready;
  reg [64-1:0] _axi_m_ctrl_spm_wdata_sb_0;
  reg [8-1:0] _axi_m_ctrl_spm_wstrb_sb_0;
  reg _axi_m_ctrl_spm_wvalid_sb_0;
  wire _axi_m_ctrl_spm_wready_sb_0;
  wire [8-1:0] _sb_axi_m_ctrl_spm_writedata_s_value_0;
  assign _sb_axi_m_ctrl_spm_writedata_s_value_0 = _axi_m_ctrl_spm_wstrb_sb_0;
  wire [64-1:0] _sb_axi_m_ctrl_spm_writedata_s_value_1;
  assign _sb_axi_m_ctrl_spm_writedata_s_value_1 = _axi_m_ctrl_spm_wdata_sb_0;
  wire [72-1:0] _sb_axi_m_ctrl_spm_writedata_s_data_2;
  assign _sb_axi_m_ctrl_spm_writedata_s_data_2 = { _sb_axi_m_ctrl_spm_writedata_s_value_0, _sb_axi_m_ctrl_spm_writedata_s_value_1 };
  wire _sb_axi_m_ctrl_spm_writedata_s_valid_3;
  assign _sb_axi_m_ctrl_spm_writedata_s_valid_3 = _axi_m_ctrl_spm_wvalid_sb_0;
  wire _sb_axi_m_ctrl_spm_writedata_m_ready_4;
  assign _sb_axi_m_ctrl_spm_writedata_m_ready_4 = axi_m_ctrl_spm_wready;
  reg [72-1:0] _sb_axi_m_ctrl_spm_writedata_data_5;
  reg _sb_axi_m_ctrl_spm_writedata_valid_6;
  wire _sb_axi_m_ctrl_spm_writedata_ready_7;
  reg [72-1:0] _sb_axi_m_ctrl_spm_writedata_tmp_data_8;
  reg _sb_axi_m_ctrl_spm_writedata_tmp_valid_9;
  wire [72-1:0] _sb_axi_m_ctrl_spm_writedata_next_data_10;
  wire _sb_axi_m_ctrl_spm_writedata_next_valid_11;
  assign _sb_axi_m_ctrl_spm_writedata_ready_7 = !_sb_axi_m_ctrl_spm_writedata_tmp_valid_9;
  assign _sb_axi_m_ctrl_spm_writedata_next_data_10 = (_sb_axi_m_ctrl_spm_writedata_tmp_valid_9)? _sb_axi_m_ctrl_spm_writedata_tmp_data_8 : _sb_axi_m_ctrl_spm_writedata_s_data_2;
  assign _sb_axi_m_ctrl_spm_writedata_next_valid_11 = _sb_axi_m_ctrl_spm_writedata_tmp_valid_9 || _sb_axi_m_ctrl_spm_writedata_s_valid_3;
  wire [8-1:0] _sb_axi_m_ctrl_spm_writedata_m_value_12;
  assign _sb_axi_m_ctrl_spm_writedata_m_value_12 = _sb_axi_m_ctrl_spm_writedata_data_5[71:64];
  wire [64-1:0] _sb_axi_m_ctrl_spm_writedata_m_value_13;
  assign _sb_axi_m_ctrl_spm_writedata_m_value_13 = _sb_axi_m_ctrl_spm_writedata_data_5[63:0];
  assign _axi_m_ctrl_spm_wready_sb_0 = _sb_axi_m_ctrl_spm_writedata_ready_7;
  assign axi_m_ctrl_spm_wdata = _sb_axi_m_ctrl_spm_writedata_m_value_13;
  assign axi_m_ctrl_spm_wstrb = _sb_axi_m_ctrl_spm_writedata_m_value_12;
  assign axi_m_ctrl_spm_wvalid = _sb_axi_m_ctrl_spm_writedata_valid_6;
  wire [2-1:0] axi_m_ctrl_spm_bresp;
  wire axi_m_ctrl_spm_bvalid;
  wire axi_m_ctrl_spm_bready;
  assign axi_m_ctrl_spm_bready = 1;
  reg [32-1:0] axi_m_ctrl_spm_araddr;
  wire [4-1:0] axi_m_ctrl_spm_arcache;
  wire [3-1:0] axi_m_ctrl_spm_arprot;
  reg axi_m_ctrl_spm_arvalid;
  wire axi_m_ctrl_spm_arready;
  assign axi_m_ctrl_spm_arcache = 3;
  assign axi_m_ctrl_spm_arprot = 0;
  wire [64-1:0] axi_m_ctrl_spm_rdata;
  wire [2-1:0] axi_m_ctrl_spm_rresp;
  wire axi_m_ctrl_spm_rvalid;
  wire axi_m_ctrl_spm_rready;
  wire [64-1:0] _axi_m_ctrl_spm_rdata_sb_0;
  wire _axi_m_ctrl_spm_rvalid_sb_0;
  wire _axi_m_ctrl_spm_rready_sb_0;
  wire [64-1:0] _sb_axi_m_ctrl_spm_readdata_s_value_14;
  assign _sb_axi_m_ctrl_spm_readdata_s_value_14 = axi_m_ctrl_spm_rdata;
  wire [64-1:0] _sb_axi_m_ctrl_spm_readdata_s_data_15;
  assign _sb_axi_m_ctrl_spm_readdata_s_data_15 = { _sb_axi_m_ctrl_spm_readdata_s_value_14 };
  wire _sb_axi_m_ctrl_spm_readdata_s_valid_16;
  assign _sb_axi_m_ctrl_spm_readdata_s_valid_16 = axi_m_ctrl_spm_rvalid;
  wire _sb_axi_m_ctrl_spm_readdata_m_ready_17;
  assign _sb_axi_m_ctrl_spm_readdata_m_ready_17 = _axi_m_ctrl_spm_rready_sb_0;
  reg [64-1:0] _sb_axi_m_ctrl_spm_readdata_data_18;
  reg _sb_axi_m_ctrl_spm_readdata_valid_19;
  wire _sb_axi_m_ctrl_spm_readdata_ready_20;
  reg [64-1:0] _sb_axi_m_ctrl_spm_readdata_tmp_data_21;
  reg _sb_axi_m_ctrl_spm_readdata_tmp_valid_22;
  wire [64-1:0] _sb_axi_m_ctrl_spm_readdata_next_data_23;
  wire _sb_axi_m_ctrl_spm_readdata_next_valid_24;
  assign _sb_axi_m_ctrl_spm_readdata_ready_20 = !_sb_axi_m_ctrl_spm_readdata_tmp_valid_22;
  assign _sb_axi_m_ctrl_spm_readdata_next_data_23 = (_sb_axi_m_ctrl_spm_readdata_tmp_valid_22)? _sb_axi_m_ctrl_spm_readdata_tmp_data_21 : _sb_axi_m_ctrl_spm_readdata_s_data_15;
  assign _sb_axi_m_ctrl_spm_readdata_next_valid_24 = _sb_axi_m_ctrl_spm_readdata_tmp_valid_22 || _sb_axi_m_ctrl_spm_readdata_s_valid_16;
  wire [64-1:0] _sb_axi_m_ctrl_spm_readdata_m_value_25;
  assign _sb_axi_m_ctrl_spm_readdata_m_value_25 = _sb_axi_m_ctrl_spm_readdata_data_18[63:0];
  assign _axi_m_ctrl_spm_rdata_sb_0 = _sb_axi_m_ctrl_spm_readdata_m_value_25;
  assign _axi_m_ctrl_spm_rvalid_sb_0 = _sb_axi_m_ctrl_spm_readdata_valid_19;
  assign axi_m_ctrl_spm_rready = _sb_axi_m_ctrl_spm_readdata_ready_20;
  reg [3-1:0] _axi_m_ctrl_spm_outstanding_wcount;
  wire _axi_m_ctrl_spm_has_outstanding_write;
  assign _axi_m_ctrl_spm_has_outstanding_write = (_axi_m_ctrl_spm_outstanding_wcount > 0) || axi_m_ctrl_spm_awvalid;
  wire [32-1+1-1:0] _tmp_26;
  assign _tmp_26 = axi_m_ctrl_spm_awaddr;

  always @(*) begin
    axi_s_ctrl_spm_awaddr = _tmp_26;
  end

  wire [4-1+1-1:0] _tmp_27;
  assign _tmp_27 = axi_m_ctrl_spm_awcache;

  always @(*) begin
    axi_s_ctrl_spm_awcache = _tmp_27;
  end

  wire [3-1+1-1:0] _tmp_28;
  assign _tmp_28 = axi_m_ctrl_spm_awprot;

  always @(*) begin
    axi_s_ctrl_spm_awprot = _tmp_28;
  end

  wire _tmp_29;
  assign _tmp_29 = axi_m_ctrl_spm_awvalid;

  always @(*) begin
    axi_s_ctrl_spm_awvalid = _tmp_29;
  end

  assign axi_m_ctrl_spm_awready = axi_s_ctrl_spm_awready;
  wire [64-1+1-1:0] _tmp_30;
  assign _tmp_30 = axi_m_ctrl_spm_wdata;

  always @(*) begin
    axi_s_ctrl_spm_wdata = _tmp_30;
  end

  wire [8-1+1-1:0] _tmp_31;
  assign _tmp_31 = axi_m_ctrl_spm_wstrb;

  always @(*) begin
    axi_s_ctrl_spm_wstrb = _tmp_31;
  end

  wire _tmp_32;
  assign _tmp_32 = axi_m_ctrl_spm_wvalid;

  always @(*) begin
    axi_s_ctrl_spm_wvalid = _tmp_32;
  end

  assign axi_m_ctrl_spm_wready = axi_s_ctrl_spm_wready;
  assign axi_m_ctrl_spm_bresp = axi_s_ctrl_spm_bresp;
  assign axi_m_ctrl_spm_bvalid = axi_s_ctrl_spm_bvalid;
  wire _tmp_33;
  assign _tmp_33 = axi_m_ctrl_spm_bready;

  always @(*) begin
    axi_s_ctrl_spm_bready = _tmp_33;
  end

  wire [32-1+1-1:0] _tmp_34;
  assign _tmp_34 = axi_m_ctrl_spm_araddr;

  always @(*) begin
    axi_s_ctrl_spm_araddr = _tmp_34;
  end

  wire [4-1+1-1:0] _tmp_35;
  assign _tmp_35 = axi_m_ctrl_spm_arcache;

  always @(*) begin
    axi_s_ctrl_spm_arcache = _tmp_35;
  end

  wire [3-1+1-1:0] _tmp_36;
  assign _tmp_36 = axi_m_ctrl_spm_arprot;

  always @(*) begin
    axi_s_ctrl_spm_arprot = _tmp_36;
  end

  wire _tmp_37;
  assign _tmp_37 = axi_m_ctrl_spm_arvalid;

  always @(*) begin
    axi_s_ctrl_spm_arvalid = _tmp_37;
  end

  assign axi_m_ctrl_spm_arready = axi_s_ctrl_spm_arready;
  assign axi_m_ctrl_spm_rdata = axi_s_ctrl_spm_rdata;
  assign axi_m_ctrl_spm_rresp = axi_s_ctrl_spm_rresp;
  assign axi_m_ctrl_spm_rvalid = axi_s_ctrl_spm_rvalid;
  wire _tmp_38;
  assign _tmp_38 = axi_m_ctrl_spm_rready;

  always @(*) begin
    axi_s_ctrl_spm_rready = _tmp_38;
  end

  reg [32-1:0] axi_m_spm_data_awaddr;
  wire [4-1:0] axi_m_spm_data_awcache;
  wire [3-1:0] axi_m_spm_data_awprot;
  reg axi_m_spm_data_awvalid;
  wire axi_m_spm_data_awready;
  assign axi_m_spm_data_awcache = 3;
  assign axi_m_spm_data_awprot = 0;
  wire [64-1:0] axi_m_spm_data_wdata;
  wire [8-1:0] axi_m_spm_data_wstrb;
  wire axi_m_spm_data_wvalid;
  wire axi_m_spm_data_wready;
  reg [64-1:0] _axi_m_spm_data_wdata_sb_0;
  reg [8-1:0] _axi_m_spm_data_wstrb_sb_0;
  reg _axi_m_spm_data_wvalid_sb_0;
  wire _axi_m_spm_data_wready_sb_0;
  wire [8-1:0] _sb_axi_m_spm_data_writedata_s_value_39;
  assign _sb_axi_m_spm_data_writedata_s_value_39 = _axi_m_spm_data_wstrb_sb_0;
  wire [64-1:0] _sb_axi_m_spm_data_writedata_s_value_40;
  assign _sb_axi_m_spm_data_writedata_s_value_40 = _axi_m_spm_data_wdata_sb_0;
  wire [72-1:0] _sb_axi_m_spm_data_writedata_s_data_41;
  assign _sb_axi_m_spm_data_writedata_s_data_41 = { _sb_axi_m_spm_data_writedata_s_value_39, _sb_axi_m_spm_data_writedata_s_value_40 };
  wire _sb_axi_m_spm_data_writedata_s_valid_42;
  assign _sb_axi_m_spm_data_writedata_s_valid_42 = _axi_m_spm_data_wvalid_sb_0;
  wire _sb_axi_m_spm_data_writedata_m_ready_43;
  assign _sb_axi_m_spm_data_writedata_m_ready_43 = axi_m_spm_data_wready;
  reg [72-1:0] _sb_axi_m_spm_data_writedata_data_44;
  reg _sb_axi_m_spm_data_writedata_valid_45;
  wire _sb_axi_m_spm_data_writedata_ready_46;
  reg [72-1:0] _sb_axi_m_spm_data_writedata_tmp_data_47;
  reg _sb_axi_m_spm_data_writedata_tmp_valid_48;
  wire [72-1:0] _sb_axi_m_spm_data_writedata_next_data_49;
  wire _sb_axi_m_spm_data_writedata_next_valid_50;
  assign _sb_axi_m_spm_data_writedata_ready_46 = !_sb_axi_m_spm_data_writedata_tmp_valid_48;
  assign _sb_axi_m_spm_data_writedata_next_data_49 = (_sb_axi_m_spm_data_writedata_tmp_valid_48)? _sb_axi_m_spm_data_writedata_tmp_data_47 : _sb_axi_m_spm_data_writedata_s_data_41;
  assign _sb_axi_m_spm_data_writedata_next_valid_50 = _sb_axi_m_spm_data_writedata_tmp_valid_48 || _sb_axi_m_spm_data_writedata_s_valid_42;
  wire [8-1:0] _sb_axi_m_spm_data_writedata_m_value_51;
  assign _sb_axi_m_spm_data_writedata_m_value_51 = _sb_axi_m_spm_data_writedata_data_44[71:64];
  wire [64-1:0] _sb_axi_m_spm_data_writedata_m_value_52;
  assign _sb_axi_m_spm_data_writedata_m_value_52 = _sb_axi_m_spm_data_writedata_data_44[63:0];
  assign _axi_m_spm_data_wready_sb_0 = _sb_axi_m_spm_data_writedata_ready_46;
  assign axi_m_spm_data_wdata = _sb_axi_m_spm_data_writedata_m_value_52;
  assign axi_m_spm_data_wstrb = _sb_axi_m_spm_data_writedata_m_value_51;
  assign axi_m_spm_data_wvalid = _sb_axi_m_spm_data_writedata_valid_45;
  wire [2-1:0] axi_m_spm_data_bresp;
  wire axi_m_spm_data_bvalid;
  wire axi_m_spm_data_bready;
  assign axi_m_spm_data_bready = 1;
  reg [32-1:0] axi_m_spm_data_araddr;
  wire [4-1:0] axi_m_spm_data_arcache;
  wire [3-1:0] axi_m_spm_data_arprot;
  reg axi_m_spm_data_arvalid;
  wire axi_m_spm_data_arready;
  assign axi_m_spm_data_arcache = 3;
  assign axi_m_spm_data_arprot = 0;
  wire [64-1:0] axi_m_spm_data_rdata;
  wire [2-1:0] axi_m_spm_data_rresp;
  wire axi_m_spm_data_rvalid;
  wire axi_m_spm_data_rready;
  wire [64-1:0] _axi_m_spm_data_rdata_sb_0;
  wire _axi_m_spm_data_rvalid_sb_0;
  wire _axi_m_spm_data_rready_sb_0;
  wire [64-1:0] _sb_axi_m_spm_data_readdata_s_value_53;
  assign _sb_axi_m_spm_data_readdata_s_value_53 = axi_m_spm_data_rdata;
  wire [64-1:0] _sb_axi_m_spm_data_readdata_s_data_54;
  assign _sb_axi_m_spm_data_readdata_s_data_54 = { _sb_axi_m_spm_data_readdata_s_value_53 };
  wire _sb_axi_m_spm_data_readdata_s_valid_55;
  assign _sb_axi_m_spm_data_readdata_s_valid_55 = axi_m_spm_data_rvalid;
  wire _sb_axi_m_spm_data_readdata_m_ready_56;
  assign _sb_axi_m_spm_data_readdata_m_ready_56 = _axi_m_spm_data_rready_sb_0;
  reg [64-1:0] _sb_axi_m_spm_data_readdata_data_57;
  reg _sb_axi_m_spm_data_readdata_valid_58;
  wire _sb_axi_m_spm_data_readdata_ready_59;
  reg [64-1:0] _sb_axi_m_spm_data_readdata_tmp_data_60;
  reg _sb_axi_m_spm_data_readdata_tmp_valid_61;
  wire [64-1:0] _sb_axi_m_spm_data_readdata_next_data_62;
  wire _sb_axi_m_spm_data_readdata_next_valid_63;
  assign _sb_axi_m_spm_data_readdata_ready_59 = !_sb_axi_m_spm_data_readdata_tmp_valid_61;
  assign _sb_axi_m_spm_data_readdata_next_data_62 = (_sb_axi_m_spm_data_readdata_tmp_valid_61)? _sb_axi_m_spm_data_readdata_tmp_data_60 : _sb_axi_m_spm_data_readdata_s_data_54;
  assign _sb_axi_m_spm_data_readdata_next_valid_63 = _sb_axi_m_spm_data_readdata_tmp_valid_61 || _sb_axi_m_spm_data_readdata_s_valid_55;
  wire [64-1:0] _sb_axi_m_spm_data_readdata_m_value_64;
  assign _sb_axi_m_spm_data_readdata_m_value_64 = _sb_axi_m_spm_data_readdata_data_57[63:0];
  assign _axi_m_spm_data_rdata_sb_0 = _sb_axi_m_spm_data_readdata_m_value_64;
  assign _axi_m_spm_data_rvalid_sb_0 = _sb_axi_m_spm_data_readdata_valid_58;
  assign axi_m_spm_data_rready = _sb_axi_m_spm_data_readdata_ready_59;
  reg [3-1:0] _axi_m_spm_data_outstanding_wcount;
  wire _axi_m_spm_data_has_outstanding_write;
  assign _axi_m_spm_data_has_outstanding_write = (_axi_m_spm_data_outstanding_wcount > 0) || axi_m_spm_data_awvalid;
  wire [32-1+1-1:0] _tmp_65;
  assign _tmp_65 = axi_m_spm_data_awaddr;

  always @(*) begin
    axi_s_spm_data_awaddr = _tmp_65;
  end

  wire [4-1+1-1:0] _tmp_66;
  assign _tmp_66 = axi_m_spm_data_awcache;

  always @(*) begin
    axi_s_spm_data_awcache = _tmp_66;
  end

  wire [3-1+1-1:0] _tmp_67;
  assign _tmp_67 = axi_m_spm_data_awprot;

  always @(*) begin
    axi_s_spm_data_awprot = _tmp_67;
  end

  wire _tmp_68;
  assign _tmp_68 = axi_m_spm_data_awvalid;

  always @(*) begin
    axi_s_spm_data_awvalid = _tmp_68;
  end

  assign axi_m_spm_data_awready = axi_s_spm_data_awready;
  wire [64-1+1-1:0] _tmp_69;
  assign _tmp_69 = axi_m_spm_data_wdata;

  always @(*) begin
    axi_s_spm_data_wdata = _tmp_69;
  end

  wire [8-1+1-1:0] _tmp_70;
  assign _tmp_70 = axi_m_spm_data_wstrb;

  always @(*) begin
    axi_s_spm_data_wstrb = _tmp_70;
  end

  wire _tmp_71;
  assign _tmp_71 = axi_m_spm_data_wvalid;

  always @(*) begin
    axi_s_spm_data_wvalid = _tmp_71;
  end

  assign axi_m_spm_data_wready = axi_s_spm_data_wready;
  assign axi_m_spm_data_bresp = axi_s_spm_data_bresp;
  assign axi_m_spm_data_bvalid = axi_s_spm_data_bvalid;
  wire _tmp_72;
  assign _tmp_72 = axi_m_spm_data_bready;

  always @(*) begin
    axi_s_spm_data_bready = _tmp_72;
  end

  wire [32-1+1-1:0] _tmp_73;
  assign _tmp_73 = axi_m_spm_data_araddr;

  always @(*) begin
    axi_s_spm_data_araddr = _tmp_73;
  end

  wire [4-1+1-1:0] _tmp_74;
  assign _tmp_74 = axi_m_spm_data_arcache;

  always @(*) begin
    axi_s_spm_data_arcache = _tmp_74;
  end

  wire [3-1+1-1:0] _tmp_75;
  assign _tmp_75 = axi_m_spm_data_arprot;

  always @(*) begin
    axi_s_spm_data_arprot = _tmp_75;
  end

  wire _tmp_76;
  assign _tmp_76 = axi_m_spm_data_arvalid;

  always @(*) begin
    axi_s_spm_data_arvalid = _tmp_76;
  end

  assign axi_m_spm_data_arready = axi_s_spm_data_arready;
  assign axi_m_spm_data_rdata = axi_s_spm_data_rdata;
  assign axi_m_spm_data_rresp = axi_s_spm_data_rresp;
  assign axi_m_spm_data_rvalid = axi_s_spm_data_rvalid;
  wire _tmp_77;
  assign _tmp_77 = axi_m_spm_data_rready;

  always @(*) begin
    axi_s_spm_data_rready = _tmp_77;
  end

  reg [32-1:0] axi_m_ctrl_mac_awaddr;
  wire [4-1:0] axi_m_ctrl_mac_awcache;
  wire [3-1:0] axi_m_ctrl_mac_awprot;
  reg axi_m_ctrl_mac_awvalid;
  wire axi_m_ctrl_mac_awready;
  assign axi_m_ctrl_mac_awcache = 3;
  assign axi_m_ctrl_mac_awprot = 0;
  wire [64-1:0] axi_m_ctrl_mac_wdata;
  wire [8-1:0] axi_m_ctrl_mac_wstrb;
  wire axi_m_ctrl_mac_wvalid;
  wire axi_m_ctrl_mac_wready;
  reg [64-1:0] _axi_m_ctrl_mac_wdata_sb_0;
  reg [8-1:0] _axi_m_ctrl_mac_wstrb_sb_0;
  reg _axi_m_ctrl_mac_wvalid_sb_0;
  wire _axi_m_ctrl_mac_wready_sb_0;
  wire [8-1:0] _sb_axi_m_ctrl_mac_writedata_s_value_78;
  assign _sb_axi_m_ctrl_mac_writedata_s_value_78 = _axi_m_ctrl_mac_wstrb_sb_0;
  wire [64-1:0] _sb_axi_m_ctrl_mac_writedata_s_value_79;
  assign _sb_axi_m_ctrl_mac_writedata_s_value_79 = _axi_m_ctrl_mac_wdata_sb_0;
  wire [72-1:0] _sb_axi_m_ctrl_mac_writedata_s_data_80;
  assign _sb_axi_m_ctrl_mac_writedata_s_data_80 = { _sb_axi_m_ctrl_mac_writedata_s_value_78, _sb_axi_m_ctrl_mac_writedata_s_value_79 };
  wire _sb_axi_m_ctrl_mac_writedata_s_valid_81;
  assign _sb_axi_m_ctrl_mac_writedata_s_valid_81 = _axi_m_ctrl_mac_wvalid_sb_0;
  wire _sb_axi_m_ctrl_mac_writedata_m_ready_82;
  assign _sb_axi_m_ctrl_mac_writedata_m_ready_82 = axi_m_ctrl_mac_wready;
  reg [72-1:0] _sb_axi_m_ctrl_mac_writedata_data_83;
  reg _sb_axi_m_ctrl_mac_writedata_valid_84;
  wire _sb_axi_m_ctrl_mac_writedata_ready_85;
  reg [72-1:0] _sb_axi_m_ctrl_mac_writedata_tmp_data_86;
  reg _sb_axi_m_ctrl_mac_writedata_tmp_valid_87;
  wire [72-1:0] _sb_axi_m_ctrl_mac_writedata_next_data_88;
  wire _sb_axi_m_ctrl_mac_writedata_next_valid_89;
  assign _sb_axi_m_ctrl_mac_writedata_ready_85 = !_sb_axi_m_ctrl_mac_writedata_tmp_valid_87;
  assign _sb_axi_m_ctrl_mac_writedata_next_data_88 = (_sb_axi_m_ctrl_mac_writedata_tmp_valid_87)? _sb_axi_m_ctrl_mac_writedata_tmp_data_86 : _sb_axi_m_ctrl_mac_writedata_s_data_80;
  assign _sb_axi_m_ctrl_mac_writedata_next_valid_89 = _sb_axi_m_ctrl_mac_writedata_tmp_valid_87 || _sb_axi_m_ctrl_mac_writedata_s_valid_81;
  wire [8-1:0] _sb_axi_m_ctrl_mac_writedata_m_value_90;
  assign _sb_axi_m_ctrl_mac_writedata_m_value_90 = _sb_axi_m_ctrl_mac_writedata_data_83[71:64];
  wire [64-1:0] _sb_axi_m_ctrl_mac_writedata_m_value_91;
  assign _sb_axi_m_ctrl_mac_writedata_m_value_91 = _sb_axi_m_ctrl_mac_writedata_data_83[63:0];
  assign _axi_m_ctrl_mac_wready_sb_0 = _sb_axi_m_ctrl_mac_writedata_ready_85;
  assign axi_m_ctrl_mac_wdata = _sb_axi_m_ctrl_mac_writedata_m_value_91;
  assign axi_m_ctrl_mac_wstrb = _sb_axi_m_ctrl_mac_writedata_m_value_90;
  assign axi_m_ctrl_mac_wvalid = _sb_axi_m_ctrl_mac_writedata_valid_84;
  wire [2-1:0] axi_m_ctrl_mac_bresp;
  wire axi_m_ctrl_mac_bvalid;
  wire axi_m_ctrl_mac_bready;
  assign axi_m_ctrl_mac_bready = 1;
  reg [32-1:0] axi_m_ctrl_mac_araddr;
  wire [4-1:0] axi_m_ctrl_mac_arcache;
  wire [3-1:0] axi_m_ctrl_mac_arprot;
  reg axi_m_ctrl_mac_arvalid;
  wire axi_m_ctrl_mac_arready;
  assign axi_m_ctrl_mac_arcache = 3;
  assign axi_m_ctrl_mac_arprot = 0;
  wire [64-1:0] axi_m_ctrl_mac_rdata;
  wire [2-1:0] axi_m_ctrl_mac_rresp;
  wire axi_m_ctrl_mac_rvalid;
  wire axi_m_ctrl_mac_rready;
  wire [64-1:0] _axi_m_ctrl_mac_rdata_sb_0;
  wire _axi_m_ctrl_mac_rvalid_sb_0;
  wire _axi_m_ctrl_mac_rready_sb_0;
  wire [64-1:0] _sb_axi_m_ctrl_mac_readdata_s_value_92;
  assign _sb_axi_m_ctrl_mac_readdata_s_value_92 = axi_m_ctrl_mac_rdata;
  wire [64-1:0] _sb_axi_m_ctrl_mac_readdata_s_data_93;
  assign _sb_axi_m_ctrl_mac_readdata_s_data_93 = { _sb_axi_m_ctrl_mac_readdata_s_value_92 };
  wire _sb_axi_m_ctrl_mac_readdata_s_valid_94;
  assign _sb_axi_m_ctrl_mac_readdata_s_valid_94 = axi_m_ctrl_mac_rvalid;
  wire _sb_axi_m_ctrl_mac_readdata_m_ready_95;
  assign _sb_axi_m_ctrl_mac_readdata_m_ready_95 = _axi_m_ctrl_mac_rready_sb_0;
  reg [64-1:0] _sb_axi_m_ctrl_mac_readdata_data_96;
  reg _sb_axi_m_ctrl_mac_readdata_valid_97;
  wire _sb_axi_m_ctrl_mac_readdata_ready_98;
  reg [64-1:0] _sb_axi_m_ctrl_mac_readdata_tmp_data_99;
  reg _sb_axi_m_ctrl_mac_readdata_tmp_valid_100;
  wire [64-1:0] _sb_axi_m_ctrl_mac_readdata_next_data_101;
  wire _sb_axi_m_ctrl_mac_readdata_next_valid_102;
  assign _sb_axi_m_ctrl_mac_readdata_ready_98 = !_sb_axi_m_ctrl_mac_readdata_tmp_valid_100;
  assign _sb_axi_m_ctrl_mac_readdata_next_data_101 = (_sb_axi_m_ctrl_mac_readdata_tmp_valid_100)? _sb_axi_m_ctrl_mac_readdata_tmp_data_99 : _sb_axi_m_ctrl_mac_readdata_s_data_93;
  assign _sb_axi_m_ctrl_mac_readdata_next_valid_102 = _sb_axi_m_ctrl_mac_readdata_tmp_valid_100 || _sb_axi_m_ctrl_mac_readdata_s_valid_94;
  wire [64-1:0] _sb_axi_m_ctrl_mac_readdata_m_value_103;
  assign _sb_axi_m_ctrl_mac_readdata_m_value_103 = _sb_axi_m_ctrl_mac_readdata_data_96[63:0];
  assign _axi_m_ctrl_mac_rdata_sb_0 = _sb_axi_m_ctrl_mac_readdata_m_value_103;
  assign _axi_m_ctrl_mac_rvalid_sb_0 = _sb_axi_m_ctrl_mac_readdata_valid_97;
  assign axi_m_ctrl_mac_rready = _sb_axi_m_ctrl_mac_readdata_ready_98;
  reg [3-1:0] _axi_m_ctrl_mac_outstanding_wcount;
  wire _axi_m_ctrl_mac_has_outstanding_write;
  assign _axi_m_ctrl_mac_has_outstanding_write = (_axi_m_ctrl_mac_outstanding_wcount > 0) || axi_m_ctrl_mac_awvalid;
  wire [32-1+1-1:0] _tmp_104;
  assign _tmp_104 = axi_m_ctrl_mac_awaddr;

  always @(*) begin
    axi_s_ctrl_mac_awaddr = _tmp_104;
  end

  wire [4-1+1-1:0] _tmp_105;
  assign _tmp_105 = axi_m_ctrl_mac_awcache;

  always @(*) begin
    axi_s_ctrl_mac_awcache = _tmp_105;
  end

  wire [3-1+1-1:0] _tmp_106;
  assign _tmp_106 = axi_m_ctrl_mac_awprot;

  always @(*) begin
    axi_s_ctrl_mac_awprot = _tmp_106;
  end

  wire _tmp_107;
  assign _tmp_107 = axi_m_ctrl_mac_awvalid;

  always @(*) begin
    axi_s_ctrl_mac_awvalid = _tmp_107;
  end

  assign axi_m_ctrl_mac_awready = axi_s_ctrl_mac_awready;
  wire [64-1+1-1:0] _tmp_108;
  assign _tmp_108 = axi_m_ctrl_mac_wdata;

  always @(*) begin
    axi_s_ctrl_mac_wdata = _tmp_108;
  end

  wire [8-1+1-1:0] _tmp_109;
  assign _tmp_109 = axi_m_ctrl_mac_wstrb;

  always @(*) begin
    axi_s_ctrl_mac_wstrb = _tmp_109;
  end

  wire _tmp_110;
  assign _tmp_110 = axi_m_ctrl_mac_wvalid;

  always @(*) begin
    axi_s_ctrl_mac_wvalid = _tmp_110;
  end

  assign axi_m_ctrl_mac_wready = axi_s_ctrl_mac_wready;
  assign axi_m_ctrl_mac_bresp = axi_s_ctrl_mac_bresp;
  assign axi_m_ctrl_mac_bvalid = axi_s_ctrl_mac_bvalid;
  wire _tmp_111;
  assign _tmp_111 = axi_m_ctrl_mac_bready;

  always @(*) begin
    axi_s_ctrl_mac_bready = _tmp_111;
  end

  wire [32-1+1-1:0] _tmp_112;
  assign _tmp_112 = axi_m_ctrl_mac_araddr;

  always @(*) begin
    axi_s_ctrl_mac_araddr = _tmp_112;
  end

  wire [4-1+1-1:0] _tmp_113;
  assign _tmp_113 = axi_m_ctrl_mac_arcache;

  always @(*) begin
    axi_s_ctrl_mac_arcache = _tmp_113;
  end

  wire [3-1+1-1:0] _tmp_114;
  assign _tmp_114 = axi_m_ctrl_mac_arprot;

  always @(*) begin
    axi_s_ctrl_mac_arprot = _tmp_114;
  end

  wire _tmp_115;
  assign _tmp_115 = axi_m_ctrl_mac_arvalid;

  always @(*) begin
    axi_s_ctrl_mac_arvalid = _tmp_115;
  end

  assign axi_m_ctrl_mac_arready = axi_s_ctrl_mac_arready;
  assign axi_m_ctrl_mac_rdata = axi_s_ctrl_mac_rdata;
  assign axi_m_ctrl_mac_rresp = axi_s_ctrl_mac_rresp;
  assign axi_m_ctrl_mac_rvalid = axi_s_ctrl_mac_rvalid;
  wire _tmp_116;
  assign _tmp_116 = axi_m_ctrl_mac_rready;

  always @(*) begin
    axi_s_ctrl_mac_rready = _tmp_116;
  end

  reg [32-1:0] axi_m_ctrl_xor_awaddr;
  wire [4-1:0] axi_m_ctrl_xor_awcache;
  wire [3-1:0] axi_m_ctrl_xor_awprot;
  reg axi_m_ctrl_xor_awvalid;
  wire axi_m_ctrl_xor_awready;
  assign axi_m_ctrl_xor_awcache = 3;
  assign axi_m_ctrl_xor_awprot = 0;
  wire [64-1:0] axi_m_ctrl_xor_wdata;
  wire [8-1:0] axi_m_ctrl_xor_wstrb;
  wire axi_m_ctrl_xor_wvalid;
  wire axi_m_ctrl_xor_wready;
  reg [64-1:0] _axi_m_ctrl_xor_wdata_sb_0;
  reg [8-1:0] _axi_m_ctrl_xor_wstrb_sb_0;
  reg _axi_m_ctrl_xor_wvalid_sb_0;
  wire _axi_m_ctrl_xor_wready_sb_0;
  wire [8-1:0] _sb_axi_m_ctrl_xor_writedata_s_value_117;
  assign _sb_axi_m_ctrl_xor_writedata_s_value_117 = _axi_m_ctrl_xor_wstrb_sb_0;
  wire [64-1:0] _sb_axi_m_ctrl_xor_writedata_s_value_118;
  assign _sb_axi_m_ctrl_xor_writedata_s_value_118 = _axi_m_ctrl_xor_wdata_sb_0;
  wire [72-1:0] _sb_axi_m_ctrl_xor_writedata_s_data_119;
  assign _sb_axi_m_ctrl_xor_writedata_s_data_119 = { _sb_axi_m_ctrl_xor_writedata_s_value_117, _sb_axi_m_ctrl_xor_writedata_s_value_118 };
  wire _sb_axi_m_ctrl_xor_writedata_s_valid_120;
  assign _sb_axi_m_ctrl_xor_writedata_s_valid_120 = _axi_m_ctrl_xor_wvalid_sb_0;
  wire _sb_axi_m_ctrl_xor_writedata_m_ready_121;
  assign _sb_axi_m_ctrl_xor_writedata_m_ready_121 = axi_m_ctrl_xor_wready;
  reg [72-1:0] _sb_axi_m_ctrl_xor_writedata_data_122;
  reg _sb_axi_m_ctrl_xor_writedata_valid_123;
  wire _sb_axi_m_ctrl_xor_writedata_ready_124;
  reg [72-1:0] _sb_axi_m_ctrl_xor_writedata_tmp_data_125;
  reg _sb_axi_m_ctrl_xor_writedata_tmp_valid_126;
  wire [72-1:0] _sb_axi_m_ctrl_xor_writedata_next_data_127;
  wire _sb_axi_m_ctrl_xor_writedata_next_valid_128;
  assign _sb_axi_m_ctrl_xor_writedata_ready_124 = !_sb_axi_m_ctrl_xor_writedata_tmp_valid_126;
  assign _sb_axi_m_ctrl_xor_writedata_next_data_127 = (_sb_axi_m_ctrl_xor_writedata_tmp_valid_126)? _sb_axi_m_ctrl_xor_writedata_tmp_data_125 : _sb_axi_m_ctrl_xor_writedata_s_data_119;
  assign _sb_axi_m_ctrl_xor_writedata_next_valid_128 = _sb_axi_m_ctrl_xor_writedata_tmp_valid_126 || _sb_axi_m_ctrl_xor_writedata_s_valid_120;
  wire [8-1:0] _sb_axi_m_ctrl_xor_writedata_m_value_129;
  assign _sb_axi_m_ctrl_xor_writedata_m_value_129 = _sb_axi_m_ctrl_xor_writedata_data_122[71:64];
  wire [64-1:0] _sb_axi_m_ctrl_xor_writedata_m_value_130;
  assign _sb_axi_m_ctrl_xor_writedata_m_value_130 = _sb_axi_m_ctrl_xor_writedata_data_122[63:0];
  assign _axi_m_ctrl_xor_wready_sb_0 = _sb_axi_m_ctrl_xor_writedata_ready_124;
  assign axi_m_ctrl_xor_wdata = _sb_axi_m_ctrl_xor_writedata_m_value_130;
  assign axi_m_ctrl_xor_wstrb = _sb_axi_m_ctrl_xor_writedata_m_value_129;
  assign axi_m_ctrl_xor_wvalid = _sb_axi_m_ctrl_xor_writedata_valid_123;
  wire [2-1:0] axi_m_ctrl_xor_bresp;
  wire axi_m_ctrl_xor_bvalid;
  wire axi_m_ctrl_xor_bready;
  assign axi_m_ctrl_xor_bready = 1;
  reg [32-1:0] axi_m_ctrl_xor_araddr;
  wire [4-1:0] axi_m_ctrl_xor_arcache;
  wire [3-1:0] axi_m_ctrl_xor_arprot;
  reg axi_m_ctrl_xor_arvalid;
  wire axi_m_ctrl_xor_arready;
  assign axi_m_ctrl_xor_arcache = 3;
  assign axi_m_ctrl_xor_arprot = 0;
  wire [64-1:0] axi_m_ctrl_xor_rdata;
  wire [2-1:0] axi_m_ctrl_xor_rresp;
  wire axi_m_ctrl_xor_rvalid;
  wire axi_m_ctrl_xor_rready;
  wire [64-1:0] _axi_m_ctrl_xor_rdata_sb_0;
  wire _axi_m_ctrl_xor_rvalid_sb_0;
  wire _axi_m_ctrl_xor_rready_sb_0;
  wire [64-1:0] _sb_axi_m_ctrl_xor_readdata_s_value_131;
  assign _sb_axi_m_ctrl_xor_readdata_s_value_131 = axi_m_ctrl_xor_rdata;
  wire [64-1:0] _sb_axi_m_ctrl_xor_readdata_s_data_132;
  assign _sb_axi_m_ctrl_xor_readdata_s_data_132 = { _sb_axi_m_ctrl_xor_readdata_s_value_131 };
  wire _sb_axi_m_ctrl_xor_readdata_s_valid_133;
  assign _sb_axi_m_ctrl_xor_readdata_s_valid_133 = axi_m_ctrl_xor_rvalid;
  wire _sb_axi_m_ctrl_xor_readdata_m_ready_134;
  assign _sb_axi_m_ctrl_xor_readdata_m_ready_134 = _axi_m_ctrl_xor_rready_sb_0;
  reg [64-1:0] _sb_axi_m_ctrl_xor_readdata_data_135;
  reg _sb_axi_m_ctrl_xor_readdata_valid_136;
  wire _sb_axi_m_ctrl_xor_readdata_ready_137;
  reg [64-1:0] _sb_axi_m_ctrl_xor_readdata_tmp_data_138;
  reg _sb_axi_m_ctrl_xor_readdata_tmp_valid_139;
  wire [64-1:0] _sb_axi_m_ctrl_xor_readdata_next_data_140;
  wire _sb_axi_m_ctrl_xor_readdata_next_valid_141;
  assign _sb_axi_m_ctrl_xor_readdata_ready_137 = !_sb_axi_m_ctrl_xor_readdata_tmp_valid_139;
  assign _sb_axi_m_ctrl_xor_readdata_next_data_140 = (_sb_axi_m_ctrl_xor_readdata_tmp_valid_139)? _sb_axi_m_ctrl_xor_readdata_tmp_data_138 : _sb_axi_m_ctrl_xor_readdata_s_data_132;
  assign _sb_axi_m_ctrl_xor_readdata_next_valid_141 = _sb_axi_m_ctrl_xor_readdata_tmp_valid_139 || _sb_axi_m_ctrl_xor_readdata_s_valid_133;
  wire [64-1:0] _sb_axi_m_ctrl_xor_readdata_m_value_142;
  assign _sb_axi_m_ctrl_xor_readdata_m_value_142 = _sb_axi_m_ctrl_xor_readdata_data_135[63:0];
  assign _axi_m_ctrl_xor_rdata_sb_0 = _sb_axi_m_ctrl_xor_readdata_m_value_142;
  assign _axi_m_ctrl_xor_rvalid_sb_0 = _sb_axi_m_ctrl_xor_readdata_valid_136;
  assign axi_m_ctrl_xor_rready = _sb_axi_m_ctrl_xor_readdata_ready_137;
  reg [3-1:0] _axi_m_ctrl_xor_outstanding_wcount;
  wire _axi_m_ctrl_xor_has_outstanding_write;
  assign _axi_m_ctrl_xor_has_outstanding_write = (_axi_m_ctrl_xor_outstanding_wcount > 0) || axi_m_ctrl_xor_awvalid;
  wire [32-1+1-1:0] _tmp_143;
  assign _tmp_143 = axi_m_ctrl_xor_awaddr;

  always @(*) begin
    axi_s_ctrl_xor_awaddr = _tmp_143;
  end

  wire [4-1+1-1:0] _tmp_144;
  assign _tmp_144 = axi_m_ctrl_xor_awcache;

  always @(*) begin
    axi_s_ctrl_xor_awcache = _tmp_144;
  end

  wire [3-1+1-1:0] _tmp_145;
  assign _tmp_145 = axi_m_ctrl_xor_awprot;

  always @(*) begin
    axi_s_ctrl_xor_awprot = _tmp_145;
  end

  wire _tmp_146;
  assign _tmp_146 = axi_m_ctrl_xor_awvalid;

  always @(*) begin
    axi_s_ctrl_xor_awvalid = _tmp_146;
  end

  assign axi_m_ctrl_xor_awready = axi_s_ctrl_xor_awready;
  wire [64-1+1-1:0] _tmp_147;
  assign _tmp_147 = axi_m_ctrl_xor_wdata;

  always @(*) begin
    axi_s_ctrl_xor_wdata = _tmp_147;
  end

  wire [8-1+1-1:0] _tmp_148;
  assign _tmp_148 = axi_m_ctrl_xor_wstrb;

  always @(*) begin
    axi_s_ctrl_xor_wstrb = _tmp_148;
  end

  wire _tmp_149;
  assign _tmp_149 = axi_m_ctrl_xor_wvalid;

  always @(*) begin
    axi_s_ctrl_xor_wvalid = _tmp_149;
  end

  assign axi_m_ctrl_xor_wready = axi_s_ctrl_xor_wready;
  assign axi_m_ctrl_xor_bresp = axi_s_ctrl_xor_bresp;
  assign axi_m_ctrl_xor_bvalid = axi_s_ctrl_xor_bvalid;
  wire _tmp_150;
  assign _tmp_150 = axi_m_ctrl_xor_bready;

  always @(*) begin
    axi_s_ctrl_xor_bready = _tmp_150;
  end

  wire [32-1+1-1:0] _tmp_151;
  assign _tmp_151 = axi_m_ctrl_xor_araddr;

  always @(*) begin
    axi_s_ctrl_xor_araddr = _tmp_151;
  end

  wire [4-1+1-1:0] _tmp_152;
  assign _tmp_152 = axi_m_ctrl_xor_arcache;

  always @(*) begin
    axi_s_ctrl_xor_arcache = _tmp_152;
  end

  wire [3-1+1-1:0] _tmp_153;
  assign _tmp_153 = axi_m_ctrl_xor_arprot;

  always @(*) begin
    axi_s_ctrl_xor_arprot = _tmp_153;
  end

  wire _tmp_154;
  assign _tmp_154 = axi_m_ctrl_xor_arvalid;

  always @(*) begin
    axi_s_ctrl_xor_arvalid = _tmp_154;
  end

  assign axi_m_ctrl_xor_arready = axi_s_ctrl_xor_arready;
  assign axi_m_ctrl_xor_rdata = axi_s_ctrl_xor_rdata;
  assign axi_m_ctrl_xor_rresp = axi_s_ctrl_xor_rresp;
  assign axi_m_ctrl_xor_rvalid = axi_s_ctrl_xor_rvalid;
  wire _tmp_155;
  assign _tmp_155 = axi_m_ctrl_xor_rready;

  always @(*) begin
    axi_s_ctrl_xor_rready = _tmp_155;
  end

  reg [32-1:0] axi_m_ctrl_aes_awaddr;
  wire [4-1:0] axi_m_ctrl_aes_awcache;
  wire [3-1:0] axi_m_ctrl_aes_awprot;
  reg axi_m_ctrl_aes_awvalid;
  wire axi_m_ctrl_aes_awready;
  assign axi_m_ctrl_aes_awcache = 3;
  assign axi_m_ctrl_aes_awprot = 0;
  wire [64-1:0] axi_m_ctrl_aes_wdata;
  wire [8-1:0] axi_m_ctrl_aes_wstrb;
  wire axi_m_ctrl_aes_wvalid;
  wire axi_m_ctrl_aes_wready;
  reg [64-1:0] _axi_m_ctrl_aes_wdata_sb_0;
  reg [8-1:0] _axi_m_ctrl_aes_wstrb_sb_0;
  reg _axi_m_ctrl_aes_wvalid_sb_0;
  wire _axi_m_ctrl_aes_wready_sb_0;
  wire [8-1:0] _sb_axi_m_ctrl_aes_writedata_s_value_156;
  assign _sb_axi_m_ctrl_aes_writedata_s_value_156 = _axi_m_ctrl_aes_wstrb_sb_0;
  wire [64-1:0] _sb_axi_m_ctrl_aes_writedata_s_value_157;
  assign _sb_axi_m_ctrl_aes_writedata_s_value_157 = _axi_m_ctrl_aes_wdata_sb_0;
  wire [72-1:0] _sb_axi_m_ctrl_aes_writedata_s_data_158;
  assign _sb_axi_m_ctrl_aes_writedata_s_data_158 = { _sb_axi_m_ctrl_aes_writedata_s_value_156, _sb_axi_m_ctrl_aes_writedata_s_value_157 };
  wire _sb_axi_m_ctrl_aes_writedata_s_valid_159;
  assign _sb_axi_m_ctrl_aes_writedata_s_valid_159 = _axi_m_ctrl_aes_wvalid_sb_0;
  wire _sb_axi_m_ctrl_aes_writedata_m_ready_160;
  assign _sb_axi_m_ctrl_aes_writedata_m_ready_160 = axi_m_ctrl_aes_wready;
  reg [72-1:0] _sb_axi_m_ctrl_aes_writedata_data_161;
  reg _sb_axi_m_ctrl_aes_writedata_valid_162;
  wire _sb_axi_m_ctrl_aes_writedata_ready_163;
  reg [72-1:0] _sb_axi_m_ctrl_aes_writedata_tmp_data_164;
  reg _sb_axi_m_ctrl_aes_writedata_tmp_valid_165;
  wire [72-1:0] _sb_axi_m_ctrl_aes_writedata_next_data_166;
  wire _sb_axi_m_ctrl_aes_writedata_next_valid_167;
  assign _sb_axi_m_ctrl_aes_writedata_ready_163 = !_sb_axi_m_ctrl_aes_writedata_tmp_valid_165;
  assign _sb_axi_m_ctrl_aes_writedata_next_data_166 = (_sb_axi_m_ctrl_aes_writedata_tmp_valid_165)? _sb_axi_m_ctrl_aes_writedata_tmp_data_164 : _sb_axi_m_ctrl_aes_writedata_s_data_158;
  assign _sb_axi_m_ctrl_aes_writedata_next_valid_167 = _sb_axi_m_ctrl_aes_writedata_tmp_valid_165 || _sb_axi_m_ctrl_aes_writedata_s_valid_159;
  wire [8-1:0] _sb_axi_m_ctrl_aes_writedata_m_value_168;
  assign _sb_axi_m_ctrl_aes_writedata_m_value_168 = _sb_axi_m_ctrl_aes_writedata_data_161[71:64];
  wire [64-1:0] _sb_axi_m_ctrl_aes_writedata_m_value_169;
  assign _sb_axi_m_ctrl_aes_writedata_m_value_169 = _sb_axi_m_ctrl_aes_writedata_data_161[63:0];
  assign _axi_m_ctrl_aes_wready_sb_0 = _sb_axi_m_ctrl_aes_writedata_ready_163;
  assign axi_m_ctrl_aes_wdata = _sb_axi_m_ctrl_aes_writedata_m_value_169;
  assign axi_m_ctrl_aes_wstrb = _sb_axi_m_ctrl_aes_writedata_m_value_168;
  assign axi_m_ctrl_aes_wvalid = _sb_axi_m_ctrl_aes_writedata_valid_162;
  wire [2-1:0] axi_m_ctrl_aes_bresp;
  wire axi_m_ctrl_aes_bvalid;
  wire axi_m_ctrl_aes_bready;
  assign axi_m_ctrl_aes_bready = 1;
  reg [32-1:0] axi_m_ctrl_aes_araddr;
  wire [4-1:0] axi_m_ctrl_aes_arcache;
  wire [3-1:0] axi_m_ctrl_aes_arprot;
  reg axi_m_ctrl_aes_arvalid;
  wire axi_m_ctrl_aes_arready;
  assign axi_m_ctrl_aes_arcache = 3;
  assign axi_m_ctrl_aes_arprot = 0;
  wire [64-1:0] axi_m_ctrl_aes_rdata;
  wire [2-1:0] axi_m_ctrl_aes_rresp;
  wire axi_m_ctrl_aes_rvalid;
  wire axi_m_ctrl_aes_rready;
  wire [64-1:0] _axi_m_ctrl_aes_rdata_sb_0;
  wire _axi_m_ctrl_aes_rvalid_sb_0;
  wire _axi_m_ctrl_aes_rready_sb_0;
  wire [64-1:0] _sb_axi_m_ctrl_aes_readdata_s_value_170;
  assign _sb_axi_m_ctrl_aes_readdata_s_value_170 = axi_m_ctrl_aes_rdata;
  wire [64-1:0] _sb_axi_m_ctrl_aes_readdata_s_data_171;
  assign _sb_axi_m_ctrl_aes_readdata_s_data_171 = { _sb_axi_m_ctrl_aes_readdata_s_value_170 };
  wire _sb_axi_m_ctrl_aes_readdata_s_valid_172;
  assign _sb_axi_m_ctrl_aes_readdata_s_valid_172 = axi_m_ctrl_aes_rvalid;
  wire _sb_axi_m_ctrl_aes_readdata_m_ready_173;
  assign _sb_axi_m_ctrl_aes_readdata_m_ready_173 = _axi_m_ctrl_aes_rready_sb_0;
  reg [64-1:0] _sb_axi_m_ctrl_aes_readdata_data_174;
  reg _sb_axi_m_ctrl_aes_readdata_valid_175;
  wire _sb_axi_m_ctrl_aes_readdata_ready_176;
  reg [64-1:0] _sb_axi_m_ctrl_aes_readdata_tmp_data_177;
  reg _sb_axi_m_ctrl_aes_readdata_tmp_valid_178;
  wire [64-1:0] _sb_axi_m_ctrl_aes_readdata_next_data_179;
  wire _sb_axi_m_ctrl_aes_readdata_next_valid_180;
  assign _sb_axi_m_ctrl_aes_readdata_ready_176 = !_sb_axi_m_ctrl_aes_readdata_tmp_valid_178;
  assign _sb_axi_m_ctrl_aes_readdata_next_data_179 = (_sb_axi_m_ctrl_aes_readdata_tmp_valid_178)? _sb_axi_m_ctrl_aes_readdata_tmp_data_177 : _sb_axi_m_ctrl_aes_readdata_s_data_171;
  assign _sb_axi_m_ctrl_aes_readdata_next_valid_180 = _sb_axi_m_ctrl_aes_readdata_tmp_valid_178 || _sb_axi_m_ctrl_aes_readdata_s_valid_172;
  wire [64-1:0] _sb_axi_m_ctrl_aes_readdata_m_value_181;
  assign _sb_axi_m_ctrl_aes_readdata_m_value_181 = _sb_axi_m_ctrl_aes_readdata_data_174[63:0];
  assign _axi_m_ctrl_aes_rdata_sb_0 = _sb_axi_m_ctrl_aes_readdata_m_value_181;
  assign _axi_m_ctrl_aes_rvalid_sb_0 = _sb_axi_m_ctrl_aes_readdata_valid_175;
  assign axi_m_ctrl_aes_rready = _sb_axi_m_ctrl_aes_readdata_ready_176;
  reg [3-1:0] _axi_m_ctrl_aes_outstanding_wcount;
  wire _axi_m_ctrl_aes_has_outstanding_write;
  assign _axi_m_ctrl_aes_has_outstanding_write = (_axi_m_ctrl_aes_outstanding_wcount > 0) || axi_m_ctrl_aes_awvalid;
  wire [32-1+1-1:0] _tmp_182;
  assign _tmp_182 = axi_m_ctrl_aes_awaddr;

  always @(*) begin
    axi_s_ctrl_aes_awaddr = _tmp_182;
  end

  wire [4-1+1-1:0] _tmp_183;
  assign _tmp_183 = axi_m_ctrl_aes_awcache;

  always @(*) begin
    axi_s_ctrl_aes_awcache = _tmp_183;
  end

  wire [3-1+1-1:0] _tmp_184;
  assign _tmp_184 = axi_m_ctrl_aes_awprot;

  always @(*) begin
    axi_s_ctrl_aes_awprot = _tmp_184;
  end

  wire _tmp_185;
  assign _tmp_185 = axi_m_ctrl_aes_awvalid;

  always @(*) begin
    axi_s_ctrl_aes_awvalid = _tmp_185;
  end

  assign axi_m_ctrl_aes_awready = axi_s_ctrl_aes_awready;
  wire [64-1+1-1:0] _tmp_186;
  assign _tmp_186 = axi_m_ctrl_aes_wdata;

  always @(*) begin
    axi_s_ctrl_aes_wdata = _tmp_186;
  end

  wire [8-1+1-1:0] _tmp_187;
  assign _tmp_187 = axi_m_ctrl_aes_wstrb;

  always @(*) begin
    axi_s_ctrl_aes_wstrb = _tmp_187;
  end

  wire _tmp_188;
  assign _tmp_188 = axi_m_ctrl_aes_wvalid;

  always @(*) begin
    axi_s_ctrl_aes_wvalid = _tmp_188;
  end

  assign axi_m_ctrl_aes_wready = axi_s_ctrl_aes_wready;
  assign axi_m_ctrl_aes_bresp = axi_s_ctrl_aes_bresp;
  assign axi_m_ctrl_aes_bvalid = axi_s_ctrl_aes_bvalid;
  wire _tmp_189;
  assign _tmp_189 = axi_m_ctrl_aes_bready;

  always @(*) begin
    axi_s_ctrl_aes_bready = _tmp_189;
  end

  wire [32-1+1-1:0] _tmp_190;
  assign _tmp_190 = axi_m_ctrl_aes_araddr;

  always @(*) begin
    axi_s_ctrl_aes_araddr = _tmp_190;
  end

  wire [4-1+1-1:0] _tmp_191;
  assign _tmp_191 = axi_m_ctrl_aes_arcache;

  always @(*) begin
    axi_s_ctrl_aes_arcache = _tmp_191;
  end

  wire [3-1+1-1:0] _tmp_192;
  assign _tmp_192 = axi_m_ctrl_aes_arprot;

  always @(*) begin
    axi_s_ctrl_aes_arprot = _tmp_192;
  end

  wire _tmp_193;
  assign _tmp_193 = axi_m_ctrl_aes_arvalid;

  always @(*) begin
    axi_s_ctrl_aes_arvalid = _tmp_193;
  end

  assign axi_m_ctrl_aes_arready = axi_s_ctrl_aes_arready;
  assign axi_m_ctrl_aes_rdata = axi_s_ctrl_aes_rdata;
  assign axi_m_ctrl_aes_rresp = axi_s_ctrl_aes_rresp;
  assign axi_m_ctrl_aes_rvalid = axi_s_ctrl_aes_rvalid;
  wire _tmp_194;
  assign _tmp_194 = axi_m_ctrl_aes_rready;

  always @(*) begin
    axi_s_ctrl_aes_rready = _tmp_194;
  end

  reg [32-1:0] axi_m_ctrl_axim_awaddr;
  wire [4-1:0] axi_m_ctrl_axim_awcache;
  wire [3-1:0] axi_m_ctrl_axim_awprot;
  reg axi_m_ctrl_axim_awvalid;
  wire axi_m_ctrl_axim_awready;
  assign axi_m_ctrl_axim_awcache = 3;
  assign axi_m_ctrl_axim_awprot = 0;
  wire [64-1:0] axi_m_ctrl_axim_wdata;
  wire [8-1:0] axi_m_ctrl_axim_wstrb;
  wire axi_m_ctrl_axim_wvalid;
  wire axi_m_ctrl_axim_wready;
  reg [64-1:0] _axi_m_ctrl_axim_wdata_sb_0;
  reg [8-1:0] _axi_m_ctrl_axim_wstrb_sb_0;
  reg _axi_m_ctrl_axim_wvalid_sb_0;
  wire _axi_m_ctrl_axim_wready_sb_0;
  wire [8-1:0] _sb_axi_m_ctrl_axim_writedata_s_value_195;
  assign _sb_axi_m_ctrl_axim_writedata_s_value_195 = _axi_m_ctrl_axim_wstrb_sb_0;
  wire [64-1:0] _sb_axi_m_ctrl_axim_writedata_s_value_196;
  assign _sb_axi_m_ctrl_axim_writedata_s_value_196 = _axi_m_ctrl_axim_wdata_sb_0;
  wire [72-1:0] _sb_axi_m_ctrl_axim_writedata_s_data_197;
  assign _sb_axi_m_ctrl_axim_writedata_s_data_197 = { _sb_axi_m_ctrl_axim_writedata_s_value_195, _sb_axi_m_ctrl_axim_writedata_s_value_196 };
  wire _sb_axi_m_ctrl_axim_writedata_s_valid_198;
  assign _sb_axi_m_ctrl_axim_writedata_s_valid_198 = _axi_m_ctrl_axim_wvalid_sb_0;
  wire _sb_axi_m_ctrl_axim_writedata_m_ready_199;
  assign _sb_axi_m_ctrl_axim_writedata_m_ready_199 = axi_m_ctrl_axim_wready;
  reg [72-1:0] _sb_axi_m_ctrl_axim_writedata_data_200;
  reg _sb_axi_m_ctrl_axim_writedata_valid_201;
  wire _sb_axi_m_ctrl_axim_writedata_ready_202;
  reg [72-1:0] _sb_axi_m_ctrl_axim_writedata_tmp_data_203;
  reg _sb_axi_m_ctrl_axim_writedata_tmp_valid_204;
  wire [72-1:0] _sb_axi_m_ctrl_axim_writedata_next_data_205;
  wire _sb_axi_m_ctrl_axim_writedata_next_valid_206;
  assign _sb_axi_m_ctrl_axim_writedata_ready_202 = !_sb_axi_m_ctrl_axim_writedata_tmp_valid_204;
  assign _sb_axi_m_ctrl_axim_writedata_next_data_205 = (_sb_axi_m_ctrl_axim_writedata_tmp_valid_204)? _sb_axi_m_ctrl_axim_writedata_tmp_data_203 : _sb_axi_m_ctrl_axim_writedata_s_data_197;
  assign _sb_axi_m_ctrl_axim_writedata_next_valid_206 = _sb_axi_m_ctrl_axim_writedata_tmp_valid_204 || _sb_axi_m_ctrl_axim_writedata_s_valid_198;
  wire [8-1:0] _sb_axi_m_ctrl_axim_writedata_m_value_207;
  assign _sb_axi_m_ctrl_axim_writedata_m_value_207 = _sb_axi_m_ctrl_axim_writedata_data_200[71:64];
  wire [64-1:0] _sb_axi_m_ctrl_axim_writedata_m_value_208;
  assign _sb_axi_m_ctrl_axim_writedata_m_value_208 = _sb_axi_m_ctrl_axim_writedata_data_200[63:0];
  assign _axi_m_ctrl_axim_wready_sb_0 = _sb_axi_m_ctrl_axim_writedata_ready_202;
  assign axi_m_ctrl_axim_wdata = _sb_axi_m_ctrl_axim_writedata_m_value_208;
  assign axi_m_ctrl_axim_wstrb = _sb_axi_m_ctrl_axim_writedata_m_value_207;
  assign axi_m_ctrl_axim_wvalid = _sb_axi_m_ctrl_axim_writedata_valid_201;
  wire [2-1:0] axi_m_ctrl_axim_bresp;
  wire axi_m_ctrl_axim_bvalid;
  wire axi_m_ctrl_axim_bready;
  assign axi_m_ctrl_axim_bready = 1;
  reg [32-1:0] axi_m_ctrl_axim_araddr;
  wire [4-1:0] axi_m_ctrl_axim_arcache;
  wire [3-1:0] axi_m_ctrl_axim_arprot;
  reg axi_m_ctrl_axim_arvalid;
  wire axi_m_ctrl_axim_arready;
  assign axi_m_ctrl_axim_arcache = 3;
  assign axi_m_ctrl_axim_arprot = 0;
  wire [64-1:0] axi_m_ctrl_axim_rdata;
  wire [2-1:0] axi_m_ctrl_axim_rresp;
  wire axi_m_ctrl_axim_rvalid;
  wire axi_m_ctrl_axim_rready;
  wire [64-1:0] _axi_m_ctrl_axim_rdata_sb_0;
  wire _axi_m_ctrl_axim_rvalid_sb_0;
  wire _axi_m_ctrl_axim_rready_sb_0;
  wire [64-1:0] _sb_axi_m_ctrl_axim_readdata_s_value_209;
  assign _sb_axi_m_ctrl_axim_readdata_s_value_209 = axi_m_ctrl_axim_rdata;
  wire [64-1:0] _sb_axi_m_ctrl_axim_readdata_s_data_210;
  assign _sb_axi_m_ctrl_axim_readdata_s_data_210 = { _sb_axi_m_ctrl_axim_readdata_s_value_209 };
  wire _sb_axi_m_ctrl_axim_readdata_s_valid_211;
  assign _sb_axi_m_ctrl_axim_readdata_s_valid_211 = axi_m_ctrl_axim_rvalid;
  wire _sb_axi_m_ctrl_axim_readdata_m_ready_212;
  assign _sb_axi_m_ctrl_axim_readdata_m_ready_212 = _axi_m_ctrl_axim_rready_sb_0;
  reg [64-1:0] _sb_axi_m_ctrl_axim_readdata_data_213;
  reg _sb_axi_m_ctrl_axim_readdata_valid_214;
  wire _sb_axi_m_ctrl_axim_readdata_ready_215;
  reg [64-1:0] _sb_axi_m_ctrl_axim_readdata_tmp_data_216;
  reg _sb_axi_m_ctrl_axim_readdata_tmp_valid_217;
  wire [64-1:0] _sb_axi_m_ctrl_axim_readdata_next_data_218;
  wire _sb_axi_m_ctrl_axim_readdata_next_valid_219;
  assign _sb_axi_m_ctrl_axim_readdata_ready_215 = !_sb_axi_m_ctrl_axim_readdata_tmp_valid_217;
  assign _sb_axi_m_ctrl_axim_readdata_next_data_218 = (_sb_axi_m_ctrl_axim_readdata_tmp_valid_217)? _sb_axi_m_ctrl_axim_readdata_tmp_data_216 : _sb_axi_m_ctrl_axim_readdata_s_data_210;
  assign _sb_axi_m_ctrl_axim_readdata_next_valid_219 = _sb_axi_m_ctrl_axim_readdata_tmp_valid_217 || _sb_axi_m_ctrl_axim_readdata_s_valid_211;
  wire [64-1:0] _sb_axi_m_ctrl_axim_readdata_m_value_220;
  assign _sb_axi_m_ctrl_axim_readdata_m_value_220 = _sb_axi_m_ctrl_axim_readdata_data_213[63:0];
  assign _axi_m_ctrl_axim_rdata_sb_0 = _sb_axi_m_ctrl_axim_readdata_m_value_220;
  assign _axi_m_ctrl_axim_rvalid_sb_0 = _sb_axi_m_ctrl_axim_readdata_valid_214;
  assign axi_m_ctrl_axim_rready = _sb_axi_m_ctrl_axim_readdata_ready_215;
  reg [3-1:0] _axi_m_ctrl_axim_outstanding_wcount;
  wire _axi_m_ctrl_axim_has_outstanding_write;
  assign _axi_m_ctrl_axim_has_outstanding_write = (_axi_m_ctrl_axim_outstanding_wcount > 0) || axi_m_ctrl_axim_awvalid;
  wire [32-1+1-1:0] _tmp_221;
  assign _tmp_221 = axi_m_ctrl_axim_awaddr;

  always @(*) begin
    axi_s_ctrl_axim_awaddr = _tmp_221;
  end

  wire [4-1+1-1:0] _tmp_222;
  assign _tmp_222 = axi_m_ctrl_axim_awcache;

  always @(*) begin
    axi_s_ctrl_axim_awcache = _tmp_222;
  end

  wire [3-1+1-1:0] _tmp_223;
  assign _tmp_223 = axi_m_ctrl_axim_awprot;

  always @(*) begin
    axi_s_ctrl_axim_awprot = _tmp_223;
  end

  wire _tmp_224;
  assign _tmp_224 = axi_m_ctrl_axim_awvalid;

  always @(*) begin
    axi_s_ctrl_axim_awvalid = _tmp_224;
  end

  assign axi_m_ctrl_axim_awready = axi_s_ctrl_axim_awready;
  wire [64-1+1-1:0] _tmp_225;
  assign _tmp_225 = axi_m_ctrl_axim_wdata;

  always @(*) begin
    axi_s_ctrl_axim_wdata = _tmp_225;
  end

  wire [8-1+1-1:0] _tmp_226;
  assign _tmp_226 = axi_m_ctrl_axim_wstrb;

  always @(*) begin
    axi_s_ctrl_axim_wstrb = _tmp_226;
  end

  wire _tmp_227;
  assign _tmp_227 = axi_m_ctrl_axim_wvalid;

  always @(*) begin
    axi_s_ctrl_axim_wvalid = _tmp_227;
  end

  assign axi_m_ctrl_axim_wready = axi_s_ctrl_axim_wready;
  assign axi_m_ctrl_axim_bresp = axi_s_ctrl_axim_bresp;
  assign axi_m_ctrl_axim_bvalid = axi_s_ctrl_axim_bvalid;
  wire _tmp_228;
  assign _tmp_228 = axi_m_ctrl_axim_bready;

  always @(*) begin
    axi_s_ctrl_axim_bready = _tmp_228;
  end

  wire [32-1+1-1:0] _tmp_229;
  assign _tmp_229 = axi_m_ctrl_axim_araddr;

  always @(*) begin
    axi_s_ctrl_axim_araddr = _tmp_229;
  end

  wire [4-1+1-1:0] _tmp_230;
  assign _tmp_230 = axi_m_ctrl_axim_arcache;

  always @(*) begin
    axi_s_ctrl_axim_arcache = _tmp_230;
  end

  wire [3-1+1-1:0] _tmp_231;
  assign _tmp_231 = axi_m_ctrl_axim_arprot;

  always @(*) begin
    axi_s_ctrl_axim_arprot = _tmp_231;
  end

  wire _tmp_232;
  assign _tmp_232 = axi_m_ctrl_axim_arvalid;

  always @(*) begin
    axi_s_ctrl_axim_arvalid = _tmp_232;
  end

  assign axi_m_ctrl_axim_arready = axi_s_ctrl_axim_arready;
  assign axi_m_ctrl_axim_rdata = axi_s_ctrl_axim_rdata;
  assign axi_m_ctrl_axim_rresp = axi_s_ctrl_axim_rresp;
  assign axi_m_ctrl_axim_rvalid = axi_s_ctrl_axim_rvalid;
  wire _tmp_233;
  assign _tmp_233 = axi_m_ctrl_axim_rready;

  always @(*) begin
    axi_s_ctrl_axim_rready = _tmp_233;
  end

  assign axi_s_bridge_bresp = 0;
  assign axi_s_bridge_rresp = 0;

  wrapper
  uut
  (
    .CLK(CLK),
    .RST(RST),
    .axi_s_ctrl_spm_awaddr(axi_s_ctrl_spm_awaddr),
    .axi_s_ctrl_spm_awcache(axi_s_ctrl_spm_awcache),
    .axi_s_ctrl_spm_awprot(axi_s_ctrl_spm_awprot),
    .axi_s_ctrl_spm_awvalid(axi_s_ctrl_spm_awvalid),
    .axi_s_ctrl_spm_awready(axi_s_ctrl_spm_awready),
    .axi_s_ctrl_spm_wdata(axi_s_ctrl_spm_wdata),
    .axi_s_ctrl_spm_wstrb(axi_s_ctrl_spm_wstrb),
    .axi_s_ctrl_spm_wvalid(axi_s_ctrl_spm_wvalid),
    .axi_s_ctrl_spm_wready(axi_s_ctrl_spm_wready),
    .axi_s_ctrl_spm_bresp(axi_s_ctrl_spm_bresp),
    .axi_s_ctrl_spm_bvalid(axi_s_ctrl_spm_bvalid),
    .axi_s_ctrl_spm_bready(axi_s_ctrl_spm_bready),
    .axi_s_ctrl_spm_araddr(axi_s_ctrl_spm_araddr),
    .axi_s_ctrl_spm_arcache(axi_s_ctrl_spm_arcache),
    .axi_s_ctrl_spm_arprot(axi_s_ctrl_spm_arprot),
    .axi_s_ctrl_spm_arvalid(axi_s_ctrl_spm_arvalid),
    .axi_s_ctrl_spm_arready(axi_s_ctrl_spm_arready),
    .axi_s_ctrl_spm_rdata(axi_s_ctrl_spm_rdata),
    .axi_s_ctrl_spm_rresp(axi_s_ctrl_spm_rresp),
    .axi_s_ctrl_spm_rvalid(axi_s_ctrl_spm_rvalid),
    .axi_s_ctrl_spm_rready(axi_s_ctrl_spm_rready),
    .axi_m_dram_awaddr(axi_m_dram_awaddr),
    .axi_m_dram_awlen(axi_m_dram_awlen),
    .axi_m_dram_awsize(axi_m_dram_awsize),
    .axi_m_dram_awburst(axi_m_dram_awburst),
    .axi_m_dram_awlock(axi_m_dram_awlock),
    .axi_m_dram_awcache(axi_m_dram_awcache),
    .axi_m_dram_awprot(axi_m_dram_awprot),
    .axi_m_dram_awqos(axi_m_dram_awqos),
    .axi_m_dram_awuser(axi_m_dram_awuser),
    .axi_m_dram_awvalid(axi_m_dram_awvalid),
    .axi_m_dram_awready(axi_m_dram_awready),
    .axi_m_dram_wdata(axi_m_dram_wdata),
    .axi_m_dram_wstrb(axi_m_dram_wstrb),
    .axi_m_dram_wlast(axi_m_dram_wlast),
    .axi_m_dram_wvalid(axi_m_dram_wvalid),
    .axi_m_dram_wready(axi_m_dram_wready),
    .axi_m_dram_bresp(axi_m_dram_bresp),
    .axi_m_dram_bvalid(axi_m_dram_bvalid),
    .axi_m_dram_bready(axi_m_dram_bready),
    .axi_m_dram_araddr(axi_m_dram_araddr),
    .axi_m_dram_arlen(axi_m_dram_arlen),
    .axi_m_dram_arsize(axi_m_dram_arsize),
    .axi_m_dram_arburst(axi_m_dram_arburst),
    .axi_m_dram_arlock(axi_m_dram_arlock),
    .axi_m_dram_arcache(axi_m_dram_arcache),
    .axi_m_dram_arprot(axi_m_dram_arprot),
    .axi_m_dram_arqos(axi_m_dram_arqos),
    .axi_m_dram_aruser(axi_m_dram_aruser),
    .axi_m_dram_arvalid(axi_m_dram_arvalid),
    .axi_m_dram_arready(axi_m_dram_arready),
    .axi_m_dram_rdata(axi_m_dram_rdata),
    .axi_m_dram_rresp(axi_m_dram_rresp),
    .axi_m_dram_rlast(axi_m_dram_rlast),
    .axi_m_dram_rvalid(axi_m_dram_rvalid),
    .axi_m_dram_rready(axi_m_dram_rready),
    .axi_s_ctrl_mac_awaddr(axi_s_ctrl_mac_awaddr),
    .axi_s_ctrl_mac_awcache(axi_s_ctrl_mac_awcache),
    .axi_s_ctrl_mac_awprot(axi_s_ctrl_mac_awprot),
    .axi_s_ctrl_mac_awvalid(axi_s_ctrl_mac_awvalid),
    .axi_s_ctrl_mac_awready(axi_s_ctrl_mac_awready),
    .axi_s_ctrl_mac_wdata(axi_s_ctrl_mac_wdata),
    .axi_s_ctrl_mac_wstrb(axi_s_ctrl_mac_wstrb),
    .axi_s_ctrl_mac_wvalid(axi_s_ctrl_mac_wvalid),
    .axi_s_ctrl_mac_wready(axi_s_ctrl_mac_wready),
    .axi_s_ctrl_mac_bresp(axi_s_ctrl_mac_bresp),
    .axi_s_ctrl_mac_bvalid(axi_s_ctrl_mac_bvalid),
    .axi_s_ctrl_mac_bready(axi_s_ctrl_mac_bready),
    .axi_s_ctrl_mac_araddr(axi_s_ctrl_mac_araddr),
    .axi_s_ctrl_mac_arcache(axi_s_ctrl_mac_arcache),
    .axi_s_ctrl_mac_arprot(axi_s_ctrl_mac_arprot),
    .axi_s_ctrl_mac_arvalid(axi_s_ctrl_mac_arvalid),
    .axi_s_ctrl_mac_arready(axi_s_ctrl_mac_arready),
    .axi_s_ctrl_mac_rdata(axi_s_ctrl_mac_rdata),
    .axi_s_ctrl_mac_rresp(axi_s_ctrl_mac_rresp),
    .axi_s_ctrl_mac_rvalid(axi_s_ctrl_mac_rvalid),
    .axi_s_ctrl_mac_rready(axi_s_ctrl_mac_rready),
    .axi_s_ctrl_xor_awaddr(axi_s_ctrl_xor_awaddr),
    .axi_s_ctrl_xor_awcache(axi_s_ctrl_xor_awcache),
    .axi_s_ctrl_xor_awprot(axi_s_ctrl_xor_awprot),
    .axi_s_ctrl_xor_awvalid(axi_s_ctrl_xor_awvalid),
    .axi_s_ctrl_xor_awready(axi_s_ctrl_xor_awready),
    .axi_s_ctrl_xor_wdata(axi_s_ctrl_xor_wdata),
    .axi_s_ctrl_xor_wstrb(axi_s_ctrl_xor_wstrb),
    .axi_s_ctrl_xor_wvalid(axi_s_ctrl_xor_wvalid),
    .axi_s_ctrl_xor_wready(axi_s_ctrl_xor_wready),
    .axi_s_ctrl_xor_bresp(axi_s_ctrl_xor_bresp),
    .axi_s_ctrl_xor_bvalid(axi_s_ctrl_xor_bvalid),
    .axi_s_ctrl_xor_bready(axi_s_ctrl_xor_bready),
    .axi_s_ctrl_xor_araddr(axi_s_ctrl_xor_araddr),
    .axi_s_ctrl_xor_arcache(axi_s_ctrl_xor_arcache),
    .axi_s_ctrl_xor_arprot(axi_s_ctrl_xor_arprot),
    .axi_s_ctrl_xor_arvalid(axi_s_ctrl_xor_arvalid),
    .axi_s_ctrl_xor_arready(axi_s_ctrl_xor_arready),
    .axi_s_ctrl_xor_rdata(axi_s_ctrl_xor_rdata),
    .axi_s_ctrl_xor_rresp(axi_s_ctrl_xor_rresp),
    .axi_s_ctrl_xor_rvalid(axi_s_ctrl_xor_rvalid),
    .axi_s_ctrl_xor_rready(axi_s_ctrl_xor_rready),
    .axi_s_ctrl_aes_awaddr(axi_s_ctrl_aes_awaddr),
    .axi_s_ctrl_aes_awcache(axi_s_ctrl_aes_awcache),
    .axi_s_ctrl_aes_awprot(axi_s_ctrl_aes_awprot),
    .axi_s_ctrl_aes_awvalid(axi_s_ctrl_aes_awvalid),
    .axi_s_ctrl_aes_awready(axi_s_ctrl_aes_awready),
    .axi_s_ctrl_aes_wdata(axi_s_ctrl_aes_wdata),
    .axi_s_ctrl_aes_wstrb(axi_s_ctrl_aes_wstrb),
    .axi_s_ctrl_aes_wvalid(axi_s_ctrl_aes_wvalid),
    .axi_s_ctrl_aes_wready(axi_s_ctrl_aes_wready),
    .axi_s_ctrl_aes_bresp(axi_s_ctrl_aes_bresp),
    .axi_s_ctrl_aes_bvalid(axi_s_ctrl_aes_bvalid),
    .axi_s_ctrl_aes_bready(axi_s_ctrl_aes_bready),
    .axi_s_ctrl_aes_araddr(axi_s_ctrl_aes_araddr),
    .axi_s_ctrl_aes_arcache(axi_s_ctrl_aes_arcache),
    .axi_s_ctrl_aes_arprot(axi_s_ctrl_aes_arprot),
    .axi_s_ctrl_aes_arvalid(axi_s_ctrl_aes_arvalid),
    .axi_s_ctrl_aes_arready(axi_s_ctrl_aes_arready),
    .axi_s_ctrl_aes_rdata(axi_s_ctrl_aes_rdata),
    .axi_s_ctrl_aes_rresp(axi_s_ctrl_aes_rresp),
    .axi_s_ctrl_aes_rvalid(axi_s_ctrl_aes_rvalid),
    .axi_s_ctrl_aes_rready(axi_s_ctrl_aes_rready),
    .axi_s_ctrl_axim_awaddr(axi_s_ctrl_axim_awaddr),
    .axi_s_ctrl_axim_awcache(axi_s_ctrl_axim_awcache),
    .axi_s_ctrl_axim_awprot(axi_s_ctrl_axim_awprot),
    .axi_s_ctrl_axim_awvalid(axi_s_ctrl_axim_awvalid),
    .axi_s_ctrl_axim_awready(axi_s_ctrl_axim_awready),
    .axi_s_ctrl_axim_wdata(axi_s_ctrl_axim_wdata),
    .axi_s_ctrl_axim_wstrb(axi_s_ctrl_axim_wstrb),
    .axi_s_ctrl_axim_wvalid(axi_s_ctrl_axim_wvalid),
    .axi_s_ctrl_axim_wready(axi_s_ctrl_axim_wready),
    .axi_s_ctrl_axim_bresp(axi_s_ctrl_axim_bresp),
    .axi_s_ctrl_axim_bvalid(axi_s_ctrl_axim_bvalid),
    .axi_s_ctrl_axim_bready(axi_s_ctrl_axim_bready),
    .axi_s_ctrl_axim_araddr(axi_s_ctrl_axim_araddr),
    .axi_s_ctrl_axim_arcache(axi_s_ctrl_axim_arcache),
    .axi_s_ctrl_axim_arprot(axi_s_ctrl_axim_arprot),
    .axi_s_ctrl_axim_arvalid(axi_s_ctrl_axim_arvalid),
    .axi_s_ctrl_axim_arready(axi_s_ctrl_axim_arready),
    .axi_s_ctrl_axim_rdata(axi_s_ctrl_axim_rdata),
    .axi_s_ctrl_axim_rresp(axi_s_ctrl_axim_rresp),
    .axi_s_ctrl_axim_rvalid(axi_s_ctrl_axim_rvalid),
    .axi_s_ctrl_axim_rready(axi_s_ctrl_axim_rready),
    .axi_s_llc_awaddr(axi_s_llc_awaddr),
    .axi_s_llc_awlen(axi_s_llc_awlen),
    .axi_s_llc_awsize(axi_s_llc_awsize),
    .axi_s_llc_awburst(axi_s_llc_awburst),
    .axi_s_llc_awlock(axi_s_llc_awlock),
    .axi_s_llc_awcache(axi_s_llc_awcache),
    .axi_s_llc_awprot(axi_s_llc_awprot),
    .axi_s_llc_awqos(axi_s_llc_awqos),
    .axi_s_llc_awuser(axi_s_llc_awuser),
    .axi_s_llc_awvalid(axi_s_llc_awvalid),
    .axi_s_llc_awready(axi_s_llc_awready),
    .axi_s_llc_wdata(axi_s_llc_wdata),
    .axi_s_llc_wstrb(axi_s_llc_wstrb),
    .axi_s_llc_wlast(axi_s_llc_wlast),
    .axi_s_llc_wvalid(axi_s_llc_wvalid),
    .axi_s_llc_wready(axi_s_llc_wready),
    .axi_s_llc_bresp(axi_s_llc_bresp),
    .axi_s_llc_bvalid(axi_s_llc_bvalid),
    .axi_s_llc_bready(axi_s_llc_bready),
    .axi_s_llc_araddr(axi_s_llc_araddr),
    .axi_s_llc_arlen(axi_s_llc_arlen),
    .axi_s_llc_arsize(axi_s_llc_arsize),
    .axi_s_llc_arburst(axi_s_llc_arburst),
    .axi_s_llc_arlock(axi_s_llc_arlock),
    .axi_s_llc_arcache(axi_s_llc_arcache),
    .axi_s_llc_arprot(axi_s_llc_arprot),
    .axi_s_llc_arqos(axi_s_llc_arqos),
    .axi_s_llc_aruser(axi_s_llc_aruser),
    .axi_s_llc_arvalid(axi_s_llc_arvalid),
    .axi_s_llc_arready(axi_s_llc_arready),
    .axi_s_llc_rdata(axi_s_llc_rdata),
    .axi_s_llc_rresp(axi_s_llc_rresp),
    .axi_s_llc_rlast(axi_s_llc_rlast),
    .axi_s_llc_rvalid(axi_s_llc_rvalid),
    .axi_s_llc_rready(axi_s_llc_rready),
    .axi_s_spm_data_awaddr(axi_s_spm_data_awaddr),
    .axi_s_spm_data_awcache(axi_s_spm_data_awcache),
    .axi_s_spm_data_awprot(axi_s_spm_data_awprot),
    .axi_s_spm_data_awvalid(axi_s_spm_data_awvalid),
    .axi_s_spm_data_awready(axi_s_spm_data_awready),
    .axi_s_spm_data_wdata(axi_s_spm_data_wdata),
    .axi_s_spm_data_wstrb(axi_s_spm_data_wstrb),
    .axi_s_spm_data_wvalid(axi_s_spm_data_wvalid),
    .axi_s_spm_data_wready(axi_s_spm_data_wready),
    .axi_s_spm_data_bresp(axi_s_spm_data_bresp),
    .axi_s_spm_data_bvalid(axi_s_spm_data_bvalid),
    .axi_s_spm_data_bready(axi_s_spm_data_bready),
    .axi_s_spm_data_araddr(axi_s_spm_data_araddr),
    .axi_s_spm_data_arcache(axi_s_spm_data_arcache),
    .axi_s_spm_data_arprot(axi_s_spm_data_arprot),
    .axi_s_spm_data_arvalid(axi_s_spm_data_arvalid),
    .axi_s_spm_data_arready(axi_s_spm_data_arready),
    .axi_s_spm_data_rdata(axi_s_spm_data_rdata),
    .axi_s_spm_data_rresp(axi_s_spm_data_rresp),
    .axi_s_spm_data_rvalid(axi_s_spm_data_rvalid),
    .axi_s_spm_data_rready(axi_s_spm_data_rready)
  );

  reg [64-1:0] addr_reg;
  reg [1-1:0] is_write;
  reg [1-1:0] request_valid;
  reg [64-1:0] write_data;
  reg [64-1:0] read_data;
  reg [64-1:0] status_234;
  reg [1-1:0] request_complete_235;
  reg [32-1:0] bridge_thread;
  localparam bridge_thread_init = 0;
  reg _axi_m_spm_data_waddr_cond_0_1;
  reg _axi_m_spm_data_wdata_cond_0_1;
  reg _axi_m_spm_data_raddr_cond_0_1;
  reg signed [64-1:0] axim_rdata_236;
  assign _axi_m_spm_data_rready_sb_0 = bridge_thread == 14;
  reg _axi_m_ctrl_spm_waddr_cond_0_1;
  reg _axi_m_ctrl_spm_wdata_cond_0_1;
  reg _axi_m_ctrl_spm_raddr_cond_0_1;
  reg signed [64-1:0] axim_rdata_237;
  assign _axi_m_ctrl_spm_rready_sb_0 = bridge_thread == 27;
  reg _axi_m_ctrl_mac_waddr_cond_0_1;
  reg _axi_m_ctrl_mac_wdata_cond_0_1;
  reg _axi_m_ctrl_mac_raddr_cond_0_1;
  reg signed [64-1:0] axim_rdata_238;
  assign _axi_m_ctrl_mac_rready_sb_0 = bridge_thread == 40;
  reg _axi_m_ctrl_aes_waddr_cond_0_1;
  reg _axi_m_ctrl_aes_wdata_cond_0_1;
  reg _axi_m_ctrl_aes_raddr_cond_0_1;
  reg signed [64-1:0] axim_rdata_239;
  assign _axi_m_ctrl_aes_rready_sb_0 = bridge_thread == 53;
  reg _axi_m_ctrl_axim_waddr_cond_0_1;
  reg _axi_m_ctrl_axim_wdata_cond_0_1;
  reg _axi_m_ctrl_axim_raddr_cond_0_1;
  reg signed [64-1:0] axim_rdata_240;
  assign _axi_m_ctrl_axim_rready_sb_0 = bridge_thread == 66;
  reg _axi_m_ctrl_xor_waddr_cond_0_1;
  reg _axi_m_ctrl_xor_wdata_cond_0_1;
  reg _axi_m_ctrl_xor_raddr_cond_0_1;
  reg signed [64-1:0] axim_rdata_241;
  assign _axi_m_ctrl_xor_rready_sb_0 = bridge_thread == 79;
  reg [32-1:0] fsm;
  localparam fsm_init = 0;
  reg [32-1:0] addr_242;
  reg [9-1:0] length_243;
  reg writevalid_244;
  reg readvalid_245;
  reg prev_awvalid_246;
  reg prev_arvalid_247;
  assign axi_s_bridge_awready = (fsm == 1) && (!writevalid_244 && !readvalid_245 && !axi_s_bridge_bvalid && prev_awvalid_246);
  assign axi_s_bridge_arready = (fsm == 1) && (!readvalid_245 && !writevalid_244 && prev_arvalid_247 && !prev_awvalid_246);
  reg _axi_s_bridge_rdata_cond_0_1;
  assign axi_s_bridge_wready = fsm == 201;

  always @(posedge CLK) begin
    if(RST) begin
      axi_m_ctrl_spm_awaddr <= 0;
      axi_m_ctrl_spm_awvalid <= 0;
      _axi_m_ctrl_spm_waddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_spm_waddr_cond_0_1) begin
        axi_m_ctrl_spm_awvalid <= 0;
      end 
      if((bridge_thread == 19) && ((_axi_m_ctrl_spm_outstanding_wcount == 0) && (axi_m_ctrl_spm_awready || !axi_m_ctrl_spm_awvalid))) begin
        axi_m_ctrl_spm_awaddr <= addr_reg - 4096;
        axi_m_ctrl_spm_awvalid <= 1;
      end 
      _axi_m_ctrl_spm_waddr_cond_0_1 <= 1;
      if(axi_m_ctrl_spm_awvalid && !axi_m_ctrl_spm_awready) begin
        axi_m_ctrl_spm_awvalid <= axi_m_ctrl_spm_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_ctrl_spm_wdata_sb_0 <= 0;
      _axi_m_ctrl_spm_wvalid_sb_0 <= 0;
      _axi_m_ctrl_spm_wstrb_sb_0 <= 0;
      _axi_m_ctrl_spm_wdata_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_spm_wdata_cond_0_1) begin
        _axi_m_ctrl_spm_wvalid_sb_0 <= 0;
      end 
      if((bridge_thread == 21) && (_axi_m_ctrl_spm_wready_sb_0 || !_axi_m_ctrl_spm_wvalid_sb_0)) begin
        _axi_m_ctrl_spm_wdata_sb_0 <= write_data;
        _axi_m_ctrl_spm_wvalid_sb_0 <= 1;
        _axi_m_ctrl_spm_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _axi_m_ctrl_spm_wdata_cond_0_1 <= 1;
      if(_axi_m_ctrl_spm_wvalid_sb_0 && !_axi_m_ctrl_spm_wready_sb_0) begin
        _axi_m_ctrl_spm_wvalid_sb_0 <= _axi_m_ctrl_spm_wvalid_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_ctrl_spm_writedata_data_5 <= 0;
      _sb_axi_m_ctrl_spm_writedata_valid_6 <= 0;
      _sb_axi_m_ctrl_spm_writedata_tmp_data_8 <= 0;
      _sb_axi_m_ctrl_spm_writedata_tmp_valid_9 <= 0;
    end else begin
      if(_sb_axi_m_ctrl_spm_writedata_m_ready_4 || !_sb_axi_m_ctrl_spm_writedata_valid_6) begin
        _sb_axi_m_ctrl_spm_writedata_data_5 <= _sb_axi_m_ctrl_spm_writedata_next_data_10;
        _sb_axi_m_ctrl_spm_writedata_valid_6 <= _sb_axi_m_ctrl_spm_writedata_next_valid_11;
      end 
      if(!_sb_axi_m_ctrl_spm_writedata_tmp_valid_9 && _sb_axi_m_ctrl_spm_writedata_valid_6 && !_sb_axi_m_ctrl_spm_writedata_m_ready_4) begin
        _sb_axi_m_ctrl_spm_writedata_tmp_data_8 <= _sb_axi_m_ctrl_spm_writedata_s_data_2;
        _sb_axi_m_ctrl_spm_writedata_tmp_valid_9 <= _sb_axi_m_ctrl_spm_writedata_s_valid_3;
      end 
      if(_sb_axi_m_ctrl_spm_writedata_tmp_valid_9 && _sb_axi_m_ctrl_spm_writedata_m_ready_4) begin
        _sb_axi_m_ctrl_spm_writedata_tmp_valid_9 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_m_ctrl_spm_araddr <= 0;
      axi_m_ctrl_spm_arvalid <= 0;
      _axi_m_ctrl_spm_raddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_spm_raddr_cond_0_1) begin
        axi_m_ctrl_spm_arvalid <= 0;
      end 
      if((bridge_thread == 25) && (axi_m_ctrl_spm_arready || !axi_m_ctrl_spm_arvalid)) begin
        axi_m_ctrl_spm_araddr <= addr_reg - 4096;
        axi_m_ctrl_spm_arvalid <= 1;
      end 
      _axi_m_ctrl_spm_raddr_cond_0_1 <= 1;
      if(axi_m_ctrl_spm_arvalid && !axi_m_ctrl_spm_arready) begin
        axi_m_ctrl_spm_arvalid <= axi_m_ctrl_spm_arvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_ctrl_spm_readdata_data_18 <= 0;
      _sb_axi_m_ctrl_spm_readdata_valid_19 <= 0;
      _sb_axi_m_ctrl_spm_readdata_tmp_data_21 <= 0;
      _sb_axi_m_ctrl_spm_readdata_tmp_valid_22 <= 0;
    end else begin
      if(_sb_axi_m_ctrl_spm_readdata_m_ready_17 || !_sb_axi_m_ctrl_spm_readdata_valid_19) begin
        _sb_axi_m_ctrl_spm_readdata_data_18 <= _sb_axi_m_ctrl_spm_readdata_next_data_23;
        _sb_axi_m_ctrl_spm_readdata_valid_19 <= _sb_axi_m_ctrl_spm_readdata_next_valid_24;
      end 
      if(!_sb_axi_m_ctrl_spm_readdata_tmp_valid_22 && _sb_axi_m_ctrl_spm_readdata_valid_19 && !_sb_axi_m_ctrl_spm_readdata_m_ready_17) begin
        _sb_axi_m_ctrl_spm_readdata_tmp_data_21 <= _sb_axi_m_ctrl_spm_readdata_s_data_15;
        _sb_axi_m_ctrl_spm_readdata_tmp_valid_22 <= _sb_axi_m_ctrl_spm_readdata_s_valid_16;
      end 
      if(_sb_axi_m_ctrl_spm_readdata_tmp_valid_22 && _sb_axi_m_ctrl_spm_readdata_m_ready_17) begin
        _sb_axi_m_ctrl_spm_readdata_tmp_valid_22 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_ctrl_spm_outstanding_wcount <= 0;
    end else begin
      if(axi_m_ctrl_spm_awvalid && axi_m_ctrl_spm_awready && !(axi_m_ctrl_spm_bvalid && axi_m_ctrl_spm_bready) && (_axi_m_ctrl_spm_outstanding_wcount < 7)) begin
        _axi_m_ctrl_spm_outstanding_wcount <= _axi_m_ctrl_spm_outstanding_wcount + 1;
      end 
      if(!(axi_m_ctrl_spm_awvalid && axi_m_ctrl_spm_awready) && (axi_m_ctrl_spm_bvalid && axi_m_ctrl_spm_bready) && (_axi_m_ctrl_spm_outstanding_wcount > 0)) begin
        _axi_m_ctrl_spm_outstanding_wcount <= _axi_m_ctrl_spm_outstanding_wcount - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_m_spm_data_awaddr <= 0;
      axi_m_spm_data_awvalid <= 0;
      _axi_m_spm_data_waddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_spm_data_waddr_cond_0_1) begin
        axi_m_spm_data_awvalid <= 0;
      end 
      if((bridge_thread == 6) && ((_axi_m_spm_data_outstanding_wcount == 0) && (axi_m_spm_data_awready || !axi_m_spm_data_awvalid))) begin
        axi_m_spm_data_awaddr <= addr_reg;
        axi_m_spm_data_awvalid <= 1;
      end 
      _axi_m_spm_data_waddr_cond_0_1 <= 1;
      if(axi_m_spm_data_awvalid && !axi_m_spm_data_awready) begin
        axi_m_spm_data_awvalid <= axi_m_spm_data_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_spm_data_wdata_sb_0 <= 0;
      _axi_m_spm_data_wvalid_sb_0 <= 0;
      _axi_m_spm_data_wstrb_sb_0 <= 0;
      _axi_m_spm_data_wdata_cond_0_1 <= 0;
    end else begin
      if(_axi_m_spm_data_wdata_cond_0_1) begin
        _axi_m_spm_data_wvalid_sb_0 <= 0;
      end 
      if((bridge_thread == 8) && (_axi_m_spm_data_wready_sb_0 || !_axi_m_spm_data_wvalid_sb_0)) begin
        _axi_m_spm_data_wdata_sb_0 <= write_data;
        _axi_m_spm_data_wvalid_sb_0 <= 1;
        _axi_m_spm_data_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _axi_m_spm_data_wdata_cond_0_1 <= 1;
      if(_axi_m_spm_data_wvalid_sb_0 && !_axi_m_spm_data_wready_sb_0) begin
        _axi_m_spm_data_wvalid_sb_0 <= _axi_m_spm_data_wvalid_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_spm_data_writedata_data_44 <= 0;
      _sb_axi_m_spm_data_writedata_valid_45 <= 0;
      _sb_axi_m_spm_data_writedata_tmp_data_47 <= 0;
      _sb_axi_m_spm_data_writedata_tmp_valid_48 <= 0;
    end else begin
      if(_sb_axi_m_spm_data_writedata_m_ready_43 || !_sb_axi_m_spm_data_writedata_valid_45) begin
        _sb_axi_m_spm_data_writedata_data_44 <= _sb_axi_m_spm_data_writedata_next_data_49;
        _sb_axi_m_spm_data_writedata_valid_45 <= _sb_axi_m_spm_data_writedata_next_valid_50;
      end 
      if(!_sb_axi_m_spm_data_writedata_tmp_valid_48 && _sb_axi_m_spm_data_writedata_valid_45 && !_sb_axi_m_spm_data_writedata_m_ready_43) begin
        _sb_axi_m_spm_data_writedata_tmp_data_47 <= _sb_axi_m_spm_data_writedata_s_data_41;
        _sb_axi_m_spm_data_writedata_tmp_valid_48 <= _sb_axi_m_spm_data_writedata_s_valid_42;
      end 
      if(_sb_axi_m_spm_data_writedata_tmp_valid_48 && _sb_axi_m_spm_data_writedata_m_ready_43) begin
        _sb_axi_m_spm_data_writedata_tmp_valid_48 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_m_spm_data_araddr <= 0;
      axi_m_spm_data_arvalid <= 0;
      _axi_m_spm_data_raddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_spm_data_raddr_cond_0_1) begin
        axi_m_spm_data_arvalid <= 0;
      end 
      if((bridge_thread == 12) && (axi_m_spm_data_arready || !axi_m_spm_data_arvalid)) begin
        axi_m_spm_data_araddr <= addr_reg;
        axi_m_spm_data_arvalid <= 1;
      end 
      _axi_m_spm_data_raddr_cond_0_1 <= 1;
      if(axi_m_spm_data_arvalid && !axi_m_spm_data_arready) begin
        axi_m_spm_data_arvalid <= axi_m_spm_data_arvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_spm_data_readdata_data_57 <= 0;
      _sb_axi_m_spm_data_readdata_valid_58 <= 0;
      _sb_axi_m_spm_data_readdata_tmp_data_60 <= 0;
      _sb_axi_m_spm_data_readdata_tmp_valid_61 <= 0;
    end else begin
      if(_sb_axi_m_spm_data_readdata_m_ready_56 || !_sb_axi_m_spm_data_readdata_valid_58) begin
        _sb_axi_m_spm_data_readdata_data_57 <= _sb_axi_m_spm_data_readdata_next_data_62;
        _sb_axi_m_spm_data_readdata_valid_58 <= _sb_axi_m_spm_data_readdata_next_valid_63;
      end 
      if(!_sb_axi_m_spm_data_readdata_tmp_valid_61 && _sb_axi_m_spm_data_readdata_valid_58 && !_sb_axi_m_spm_data_readdata_m_ready_56) begin
        _sb_axi_m_spm_data_readdata_tmp_data_60 <= _sb_axi_m_spm_data_readdata_s_data_54;
        _sb_axi_m_spm_data_readdata_tmp_valid_61 <= _sb_axi_m_spm_data_readdata_s_valid_55;
      end 
      if(_sb_axi_m_spm_data_readdata_tmp_valid_61 && _sb_axi_m_spm_data_readdata_m_ready_56) begin
        _sb_axi_m_spm_data_readdata_tmp_valid_61 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_spm_data_outstanding_wcount <= 0;
    end else begin
      if(axi_m_spm_data_awvalid && axi_m_spm_data_awready && !(axi_m_spm_data_bvalid && axi_m_spm_data_bready) && (_axi_m_spm_data_outstanding_wcount < 7)) begin
        _axi_m_spm_data_outstanding_wcount <= _axi_m_spm_data_outstanding_wcount + 1;
      end 
      if(!(axi_m_spm_data_awvalid && axi_m_spm_data_awready) && (axi_m_spm_data_bvalid && axi_m_spm_data_bready) && (_axi_m_spm_data_outstanding_wcount > 0)) begin
        _axi_m_spm_data_outstanding_wcount <= _axi_m_spm_data_outstanding_wcount - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_m_ctrl_mac_awaddr <= 0;
      axi_m_ctrl_mac_awvalid <= 0;
      _axi_m_ctrl_mac_waddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_mac_waddr_cond_0_1) begin
        axi_m_ctrl_mac_awvalid <= 0;
      end 
      if((bridge_thread == 32) && ((_axi_m_ctrl_mac_outstanding_wcount == 0) && (axi_m_ctrl_mac_awready || !axi_m_ctrl_mac_awvalid))) begin
        axi_m_ctrl_mac_awaddr <= addr_reg - 8192;
        axi_m_ctrl_mac_awvalid <= 1;
      end 
      _axi_m_ctrl_mac_waddr_cond_0_1 <= 1;
      if(axi_m_ctrl_mac_awvalid && !axi_m_ctrl_mac_awready) begin
        axi_m_ctrl_mac_awvalid <= axi_m_ctrl_mac_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_ctrl_mac_wdata_sb_0 <= 0;
      _axi_m_ctrl_mac_wvalid_sb_0 <= 0;
      _axi_m_ctrl_mac_wstrb_sb_0 <= 0;
      _axi_m_ctrl_mac_wdata_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_mac_wdata_cond_0_1) begin
        _axi_m_ctrl_mac_wvalid_sb_0 <= 0;
      end 
      if((bridge_thread == 34) && (_axi_m_ctrl_mac_wready_sb_0 || !_axi_m_ctrl_mac_wvalid_sb_0)) begin
        _axi_m_ctrl_mac_wdata_sb_0 <= write_data;
        _axi_m_ctrl_mac_wvalid_sb_0 <= 1;
        _axi_m_ctrl_mac_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _axi_m_ctrl_mac_wdata_cond_0_1 <= 1;
      if(_axi_m_ctrl_mac_wvalid_sb_0 && !_axi_m_ctrl_mac_wready_sb_0) begin
        _axi_m_ctrl_mac_wvalid_sb_0 <= _axi_m_ctrl_mac_wvalid_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_ctrl_mac_writedata_data_83 <= 0;
      _sb_axi_m_ctrl_mac_writedata_valid_84 <= 0;
      _sb_axi_m_ctrl_mac_writedata_tmp_data_86 <= 0;
      _sb_axi_m_ctrl_mac_writedata_tmp_valid_87 <= 0;
    end else begin
      if(_sb_axi_m_ctrl_mac_writedata_m_ready_82 || !_sb_axi_m_ctrl_mac_writedata_valid_84) begin
        _sb_axi_m_ctrl_mac_writedata_data_83 <= _sb_axi_m_ctrl_mac_writedata_next_data_88;
        _sb_axi_m_ctrl_mac_writedata_valid_84 <= _sb_axi_m_ctrl_mac_writedata_next_valid_89;
      end 
      if(!_sb_axi_m_ctrl_mac_writedata_tmp_valid_87 && _sb_axi_m_ctrl_mac_writedata_valid_84 && !_sb_axi_m_ctrl_mac_writedata_m_ready_82) begin
        _sb_axi_m_ctrl_mac_writedata_tmp_data_86 <= _sb_axi_m_ctrl_mac_writedata_s_data_80;
        _sb_axi_m_ctrl_mac_writedata_tmp_valid_87 <= _sb_axi_m_ctrl_mac_writedata_s_valid_81;
      end 
      if(_sb_axi_m_ctrl_mac_writedata_tmp_valid_87 && _sb_axi_m_ctrl_mac_writedata_m_ready_82) begin
        _sb_axi_m_ctrl_mac_writedata_tmp_valid_87 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_m_ctrl_mac_araddr <= 0;
      axi_m_ctrl_mac_arvalid <= 0;
      _axi_m_ctrl_mac_raddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_mac_raddr_cond_0_1) begin
        axi_m_ctrl_mac_arvalid <= 0;
      end 
      if((bridge_thread == 38) && (axi_m_ctrl_mac_arready || !axi_m_ctrl_mac_arvalid)) begin
        axi_m_ctrl_mac_araddr <= addr_reg - 8192;
        axi_m_ctrl_mac_arvalid <= 1;
      end 
      _axi_m_ctrl_mac_raddr_cond_0_1 <= 1;
      if(axi_m_ctrl_mac_arvalid && !axi_m_ctrl_mac_arready) begin
        axi_m_ctrl_mac_arvalid <= axi_m_ctrl_mac_arvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_ctrl_mac_readdata_data_96 <= 0;
      _sb_axi_m_ctrl_mac_readdata_valid_97 <= 0;
      _sb_axi_m_ctrl_mac_readdata_tmp_data_99 <= 0;
      _sb_axi_m_ctrl_mac_readdata_tmp_valid_100 <= 0;
    end else begin
      if(_sb_axi_m_ctrl_mac_readdata_m_ready_95 || !_sb_axi_m_ctrl_mac_readdata_valid_97) begin
        _sb_axi_m_ctrl_mac_readdata_data_96 <= _sb_axi_m_ctrl_mac_readdata_next_data_101;
        _sb_axi_m_ctrl_mac_readdata_valid_97 <= _sb_axi_m_ctrl_mac_readdata_next_valid_102;
      end 
      if(!_sb_axi_m_ctrl_mac_readdata_tmp_valid_100 && _sb_axi_m_ctrl_mac_readdata_valid_97 && !_sb_axi_m_ctrl_mac_readdata_m_ready_95) begin
        _sb_axi_m_ctrl_mac_readdata_tmp_data_99 <= _sb_axi_m_ctrl_mac_readdata_s_data_93;
        _sb_axi_m_ctrl_mac_readdata_tmp_valid_100 <= _sb_axi_m_ctrl_mac_readdata_s_valid_94;
      end 
      if(_sb_axi_m_ctrl_mac_readdata_tmp_valid_100 && _sb_axi_m_ctrl_mac_readdata_m_ready_95) begin
        _sb_axi_m_ctrl_mac_readdata_tmp_valid_100 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_ctrl_mac_outstanding_wcount <= 0;
    end else begin
      if(axi_m_ctrl_mac_awvalid && axi_m_ctrl_mac_awready && !(axi_m_ctrl_mac_bvalid && axi_m_ctrl_mac_bready) && (_axi_m_ctrl_mac_outstanding_wcount < 7)) begin
        _axi_m_ctrl_mac_outstanding_wcount <= _axi_m_ctrl_mac_outstanding_wcount + 1;
      end 
      if(!(axi_m_ctrl_mac_awvalid && axi_m_ctrl_mac_awready) && (axi_m_ctrl_mac_bvalid && axi_m_ctrl_mac_bready) && (_axi_m_ctrl_mac_outstanding_wcount > 0)) begin
        _axi_m_ctrl_mac_outstanding_wcount <= _axi_m_ctrl_mac_outstanding_wcount - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_m_ctrl_xor_awaddr <= 0;
      axi_m_ctrl_xor_awvalid <= 0;
      _axi_m_ctrl_xor_waddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_xor_waddr_cond_0_1) begin
        axi_m_ctrl_xor_awvalid <= 0;
      end 
      if((bridge_thread == 71) && ((_axi_m_ctrl_xor_outstanding_wcount == 0) && (axi_m_ctrl_xor_awready || !axi_m_ctrl_xor_awvalid))) begin
        axi_m_ctrl_xor_awaddr <= addr_reg - 20480;
        axi_m_ctrl_xor_awvalid <= 1;
      end 
      _axi_m_ctrl_xor_waddr_cond_0_1 <= 1;
      if(axi_m_ctrl_xor_awvalid && !axi_m_ctrl_xor_awready) begin
        axi_m_ctrl_xor_awvalid <= axi_m_ctrl_xor_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_ctrl_xor_wdata_sb_0 <= 0;
      _axi_m_ctrl_xor_wvalid_sb_0 <= 0;
      _axi_m_ctrl_xor_wstrb_sb_0 <= 0;
      _axi_m_ctrl_xor_wdata_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_xor_wdata_cond_0_1) begin
        _axi_m_ctrl_xor_wvalid_sb_0 <= 0;
      end 
      if((bridge_thread == 73) && (_axi_m_ctrl_xor_wready_sb_0 || !_axi_m_ctrl_xor_wvalid_sb_0)) begin
        _axi_m_ctrl_xor_wdata_sb_0 <= write_data;
        _axi_m_ctrl_xor_wvalid_sb_0 <= 1;
        _axi_m_ctrl_xor_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _axi_m_ctrl_xor_wdata_cond_0_1 <= 1;
      if(_axi_m_ctrl_xor_wvalid_sb_0 && !_axi_m_ctrl_xor_wready_sb_0) begin
        _axi_m_ctrl_xor_wvalid_sb_0 <= _axi_m_ctrl_xor_wvalid_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_ctrl_xor_writedata_data_122 <= 0;
      _sb_axi_m_ctrl_xor_writedata_valid_123 <= 0;
      _sb_axi_m_ctrl_xor_writedata_tmp_data_125 <= 0;
      _sb_axi_m_ctrl_xor_writedata_tmp_valid_126 <= 0;
    end else begin
      if(_sb_axi_m_ctrl_xor_writedata_m_ready_121 || !_sb_axi_m_ctrl_xor_writedata_valid_123) begin
        _sb_axi_m_ctrl_xor_writedata_data_122 <= _sb_axi_m_ctrl_xor_writedata_next_data_127;
        _sb_axi_m_ctrl_xor_writedata_valid_123 <= _sb_axi_m_ctrl_xor_writedata_next_valid_128;
      end 
      if(!_sb_axi_m_ctrl_xor_writedata_tmp_valid_126 && _sb_axi_m_ctrl_xor_writedata_valid_123 && !_sb_axi_m_ctrl_xor_writedata_m_ready_121) begin
        _sb_axi_m_ctrl_xor_writedata_tmp_data_125 <= _sb_axi_m_ctrl_xor_writedata_s_data_119;
        _sb_axi_m_ctrl_xor_writedata_tmp_valid_126 <= _sb_axi_m_ctrl_xor_writedata_s_valid_120;
      end 
      if(_sb_axi_m_ctrl_xor_writedata_tmp_valid_126 && _sb_axi_m_ctrl_xor_writedata_m_ready_121) begin
        _sb_axi_m_ctrl_xor_writedata_tmp_valid_126 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_m_ctrl_xor_araddr <= 0;
      axi_m_ctrl_xor_arvalid <= 0;
      _axi_m_ctrl_xor_raddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_xor_raddr_cond_0_1) begin
        axi_m_ctrl_xor_arvalid <= 0;
      end 
      if((bridge_thread == 77) && (axi_m_ctrl_xor_arready || !axi_m_ctrl_xor_arvalid)) begin
        axi_m_ctrl_xor_araddr <= addr_reg - 20480;
        axi_m_ctrl_xor_arvalid <= 1;
      end 
      _axi_m_ctrl_xor_raddr_cond_0_1 <= 1;
      if(axi_m_ctrl_xor_arvalid && !axi_m_ctrl_xor_arready) begin
        axi_m_ctrl_xor_arvalid <= axi_m_ctrl_xor_arvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_ctrl_xor_readdata_data_135 <= 0;
      _sb_axi_m_ctrl_xor_readdata_valid_136 <= 0;
      _sb_axi_m_ctrl_xor_readdata_tmp_data_138 <= 0;
      _sb_axi_m_ctrl_xor_readdata_tmp_valid_139 <= 0;
    end else begin
      if(_sb_axi_m_ctrl_xor_readdata_m_ready_134 || !_sb_axi_m_ctrl_xor_readdata_valid_136) begin
        _sb_axi_m_ctrl_xor_readdata_data_135 <= _sb_axi_m_ctrl_xor_readdata_next_data_140;
        _sb_axi_m_ctrl_xor_readdata_valid_136 <= _sb_axi_m_ctrl_xor_readdata_next_valid_141;
      end 
      if(!_sb_axi_m_ctrl_xor_readdata_tmp_valid_139 && _sb_axi_m_ctrl_xor_readdata_valid_136 && !_sb_axi_m_ctrl_xor_readdata_m_ready_134) begin
        _sb_axi_m_ctrl_xor_readdata_tmp_data_138 <= _sb_axi_m_ctrl_xor_readdata_s_data_132;
        _sb_axi_m_ctrl_xor_readdata_tmp_valid_139 <= _sb_axi_m_ctrl_xor_readdata_s_valid_133;
      end 
      if(_sb_axi_m_ctrl_xor_readdata_tmp_valid_139 && _sb_axi_m_ctrl_xor_readdata_m_ready_134) begin
        _sb_axi_m_ctrl_xor_readdata_tmp_valid_139 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_ctrl_xor_outstanding_wcount <= 0;
    end else begin
      if(axi_m_ctrl_xor_awvalid && axi_m_ctrl_xor_awready && !(axi_m_ctrl_xor_bvalid && axi_m_ctrl_xor_bready) && (_axi_m_ctrl_xor_outstanding_wcount < 7)) begin
        _axi_m_ctrl_xor_outstanding_wcount <= _axi_m_ctrl_xor_outstanding_wcount + 1;
      end 
      if(!(axi_m_ctrl_xor_awvalid && axi_m_ctrl_xor_awready) && (axi_m_ctrl_xor_bvalid && axi_m_ctrl_xor_bready) && (_axi_m_ctrl_xor_outstanding_wcount > 0)) begin
        _axi_m_ctrl_xor_outstanding_wcount <= _axi_m_ctrl_xor_outstanding_wcount - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_m_ctrl_aes_awaddr <= 0;
      axi_m_ctrl_aes_awvalid <= 0;
      _axi_m_ctrl_aes_waddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_aes_waddr_cond_0_1) begin
        axi_m_ctrl_aes_awvalid <= 0;
      end 
      if((bridge_thread == 45) && ((_axi_m_ctrl_aes_outstanding_wcount == 0) && (axi_m_ctrl_aes_awready || !axi_m_ctrl_aes_awvalid))) begin
        axi_m_ctrl_aes_awaddr <= addr_reg - 12288;
        axi_m_ctrl_aes_awvalid <= 1;
      end 
      _axi_m_ctrl_aes_waddr_cond_0_1 <= 1;
      if(axi_m_ctrl_aes_awvalid && !axi_m_ctrl_aes_awready) begin
        axi_m_ctrl_aes_awvalid <= axi_m_ctrl_aes_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_ctrl_aes_wdata_sb_0 <= 0;
      _axi_m_ctrl_aes_wvalid_sb_0 <= 0;
      _axi_m_ctrl_aes_wstrb_sb_0 <= 0;
      _axi_m_ctrl_aes_wdata_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_aes_wdata_cond_0_1) begin
        _axi_m_ctrl_aes_wvalid_sb_0 <= 0;
      end 
      if((bridge_thread == 47) && (_axi_m_ctrl_aes_wready_sb_0 || !_axi_m_ctrl_aes_wvalid_sb_0)) begin
        _axi_m_ctrl_aes_wdata_sb_0 <= write_data;
        _axi_m_ctrl_aes_wvalid_sb_0 <= 1;
        _axi_m_ctrl_aes_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _axi_m_ctrl_aes_wdata_cond_0_1 <= 1;
      if(_axi_m_ctrl_aes_wvalid_sb_0 && !_axi_m_ctrl_aes_wready_sb_0) begin
        _axi_m_ctrl_aes_wvalid_sb_0 <= _axi_m_ctrl_aes_wvalid_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_ctrl_aes_writedata_data_161 <= 0;
      _sb_axi_m_ctrl_aes_writedata_valid_162 <= 0;
      _sb_axi_m_ctrl_aes_writedata_tmp_data_164 <= 0;
      _sb_axi_m_ctrl_aes_writedata_tmp_valid_165 <= 0;
    end else begin
      if(_sb_axi_m_ctrl_aes_writedata_m_ready_160 || !_sb_axi_m_ctrl_aes_writedata_valid_162) begin
        _sb_axi_m_ctrl_aes_writedata_data_161 <= _sb_axi_m_ctrl_aes_writedata_next_data_166;
        _sb_axi_m_ctrl_aes_writedata_valid_162 <= _sb_axi_m_ctrl_aes_writedata_next_valid_167;
      end 
      if(!_sb_axi_m_ctrl_aes_writedata_tmp_valid_165 && _sb_axi_m_ctrl_aes_writedata_valid_162 && !_sb_axi_m_ctrl_aes_writedata_m_ready_160) begin
        _sb_axi_m_ctrl_aes_writedata_tmp_data_164 <= _sb_axi_m_ctrl_aes_writedata_s_data_158;
        _sb_axi_m_ctrl_aes_writedata_tmp_valid_165 <= _sb_axi_m_ctrl_aes_writedata_s_valid_159;
      end 
      if(_sb_axi_m_ctrl_aes_writedata_tmp_valid_165 && _sb_axi_m_ctrl_aes_writedata_m_ready_160) begin
        _sb_axi_m_ctrl_aes_writedata_tmp_valid_165 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_m_ctrl_aes_araddr <= 0;
      axi_m_ctrl_aes_arvalid <= 0;
      _axi_m_ctrl_aes_raddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_aes_raddr_cond_0_1) begin
        axi_m_ctrl_aes_arvalid <= 0;
      end 
      if((bridge_thread == 51) && (axi_m_ctrl_aes_arready || !axi_m_ctrl_aes_arvalid)) begin
        axi_m_ctrl_aes_araddr <= addr_reg - 12288;
        axi_m_ctrl_aes_arvalid <= 1;
      end 
      _axi_m_ctrl_aes_raddr_cond_0_1 <= 1;
      if(axi_m_ctrl_aes_arvalid && !axi_m_ctrl_aes_arready) begin
        axi_m_ctrl_aes_arvalid <= axi_m_ctrl_aes_arvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_ctrl_aes_readdata_data_174 <= 0;
      _sb_axi_m_ctrl_aes_readdata_valid_175 <= 0;
      _sb_axi_m_ctrl_aes_readdata_tmp_data_177 <= 0;
      _sb_axi_m_ctrl_aes_readdata_tmp_valid_178 <= 0;
    end else begin
      if(_sb_axi_m_ctrl_aes_readdata_m_ready_173 || !_sb_axi_m_ctrl_aes_readdata_valid_175) begin
        _sb_axi_m_ctrl_aes_readdata_data_174 <= _sb_axi_m_ctrl_aes_readdata_next_data_179;
        _sb_axi_m_ctrl_aes_readdata_valid_175 <= _sb_axi_m_ctrl_aes_readdata_next_valid_180;
      end 
      if(!_sb_axi_m_ctrl_aes_readdata_tmp_valid_178 && _sb_axi_m_ctrl_aes_readdata_valid_175 && !_sb_axi_m_ctrl_aes_readdata_m_ready_173) begin
        _sb_axi_m_ctrl_aes_readdata_tmp_data_177 <= _sb_axi_m_ctrl_aes_readdata_s_data_171;
        _sb_axi_m_ctrl_aes_readdata_tmp_valid_178 <= _sb_axi_m_ctrl_aes_readdata_s_valid_172;
      end 
      if(_sb_axi_m_ctrl_aes_readdata_tmp_valid_178 && _sb_axi_m_ctrl_aes_readdata_m_ready_173) begin
        _sb_axi_m_ctrl_aes_readdata_tmp_valid_178 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_ctrl_aes_outstanding_wcount <= 0;
    end else begin
      if(axi_m_ctrl_aes_awvalid && axi_m_ctrl_aes_awready && !(axi_m_ctrl_aes_bvalid && axi_m_ctrl_aes_bready) && (_axi_m_ctrl_aes_outstanding_wcount < 7)) begin
        _axi_m_ctrl_aes_outstanding_wcount <= _axi_m_ctrl_aes_outstanding_wcount + 1;
      end 
      if(!(axi_m_ctrl_aes_awvalid && axi_m_ctrl_aes_awready) && (axi_m_ctrl_aes_bvalid && axi_m_ctrl_aes_bready) && (_axi_m_ctrl_aes_outstanding_wcount > 0)) begin
        _axi_m_ctrl_aes_outstanding_wcount <= _axi_m_ctrl_aes_outstanding_wcount - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_m_ctrl_axim_awaddr <= 0;
      axi_m_ctrl_axim_awvalid <= 0;
      _axi_m_ctrl_axim_waddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_axim_waddr_cond_0_1) begin
        axi_m_ctrl_axim_awvalid <= 0;
      end 
      if((bridge_thread == 58) && ((_axi_m_ctrl_axim_outstanding_wcount == 0) && (axi_m_ctrl_axim_awready || !axi_m_ctrl_axim_awvalid))) begin
        axi_m_ctrl_axim_awaddr <= addr_reg - 16384;
        axi_m_ctrl_axim_awvalid <= 1;
      end 
      _axi_m_ctrl_axim_waddr_cond_0_1 <= 1;
      if(axi_m_ctrl_axim_awvalid && !axi_m_ctrl_axim_awready) begin
        axi_m_ctrl_axim_awvalid <= axi_m_ctrl_axim_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_ctrl_axim_wdata_sb_0 <= 0;
      _axi_m_ctrl_axim_wvalid_sb_0 <= 0;
      _axi_m_ctrl_axim_wstrb_sb_0 <= 0;
      _axi_m_ctrl_axim_wdata_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_axim_wdata_cond_0_1) begin
        _axi_m_ctrl_axim_wvalid_sb_0 <= 0;
      end 
      if((bridge_thread == 60) && (_axi_m_ctrl_axim_wready_sb_0 || !_axi_m_ctrl_axim_wvalid_sb_0)) begin
        _axi_m_ctrl_axim_wdata_sb_0 <= write_data;
        _axi_m_ctrl_axim_wvalid_sb_0 <= 1;
        _axi_m_ctrl_axim_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _axi_m_ctrl_axim_wdata_cond_0_1 <= 1;
      if(_axi_m_ctrl_axim_wvalid_sb_0 && !_axi_m_ctrl_axim_wready_sb_0) begin
        _axi_m_ctrl_axim_wvalid_sb_0 <= _axi_m_ctrl_axim_wvalid_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_ctrl_axim_writedata_data_200 <= 0;
      _sb_axi_m_ctrl_axim_writedata_valid_201 <= 0;
      _sb_axi_m_ctrl_axim_writedata_tmp_data_203 <= 0;
      _sb_axi_m_ctrl_axim_writedata_tmp_valid_204 <= 0;
    end else begin
      if(_sb_axi_m_ctrl_axim_writedata_m_ready_199 || !_sb_axi_m_ctrl_axim_writedata_valid_201) begin
        _sb_axi_m_ctrl_axim_writedata_data_200 <= _sb_axi_m_ctrl_axim_writedata_next_data_205;
        _sb_axi_m_ctrl_axim_writedata_valid_201 <= _sb_axi_m_ctrl_axim_writedata_next_valid_206;
      end 
      if(!_sb_axi_m_ctrl_axim_writedata_tmp_valid_204 && _sb_axi_m_ctrl_axim_writedata_valid_201 && !_sb_axi_m_ctrl_axim_writedata_m_ready_199) begin
        _sb_axi_m_ctrl_axim_writedata_tmp_data_203 <= _sb_axi_m_ctrl_axim_writedata_s_data_197;
        _sb_axi_m_ctrl_axim_writedata_tmp_valid_204 <= _sb_axi_m_ctrl_axim_writedata_s_valid_198;
      end 
      if(_sb_axi_m_ctrl_axim_writedata_tmp_valid_204 && _sb_axi_m_ctrl_axim_writedata_m_ready_199) begin
        _sb_axi_m_ctrl_axim_writedata_tmp_valid_204 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_m_ctrl_axim_araddr <= 0;
      axi_m_ctrl_axim_arvalid <= 0;
      _axi_m_ctrl_axim_raddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_ctrl_axim_raddr_cond_0_1) begin
        axi_m_ctrl_axim_arvalid <= 0;
      end 
      if((bridge_thread == 64) && (axi_m_ctrl_axim_arready || !axi_m_ctrl_axim_arvalid)) begin
        axi_m_ctrl_axim_araddr <= addr_reg - 16384;
        axi_m_ctrl_axim_arvalid <= 1;
      end 
      _axi_m_ctrl_axim_raddr_cond_0_1 <= 1;
      if(axi_m_ctrl_axim_arvalid && !axi_m_ctrl_axim_arready) begin
        axi_m_ctrl_axim_arvalid <= axi_m_ctrl_axim_arvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_ctrl_axim_readdata_data_213 <= 0;
      _sb_axi_m_ctrl_axim_readdata_valid_214 <= 0;
      _sb_axi_m_ctrl_axim_readdata_tmp_data_216 <= 0;
      _sb_axi_m_ctrl_axim_readdata_tmp_valid_217 <= 0;
    end else begin
      if(_sb_axi_m_ctrl_axim_readdata_m_ready_212 || !_sb_axi_m_ctrl_axim_readdata_valid_214) begin
        _sb_axi_m_ctrl_axim_readdata_data_213 <= _sb_axi_m_ctrl_axim_readdata_next_data_218;
        _sb_axi_m_ctrl_axim_readdata_valid_214 <= _sb_axi_m_ctrl_axim_readdata_next_valid_219;
      end 
      if(!_sb_axi_m_ctrl_axim_readdata_tmp_valid_217 && _sb_axi_m_ctrl_axim_readdata_valid_214 && !_sb_axi_m_ctrl_axim_readdata_m_ready_212) begin
        _sb_axi_m_ctrl_axim_readdata_tmp_data_216 <= _sb_axi_m_ctrl_axim_readdata_s_data_210;
        _sb_axi_m_ctrl_axim_readdata_tmp_valid_217 <= _sb_axi_m_ctrl_axim_readdata_s_valid_211;
      end 
      if(_sb_axi_m_ctrl_axim_readdata_tmp_valid_217 && _sb_axi_m_ctrl_axim_readdata_m_ready_212) begin
        _sb_axi_m_ctrl_axim_readdata_tmp_valid_217 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_ctrl_axim_outstanding_wcount <= 0;
    end else begin
      if(axi_m_ctrl_axim_awvalid && axi_m_ctrl_axim_awready && !(axi_m_ctrl_axim_bvalid && axi_m_ctrl_axim_bready) && (_axi_m_ctrl_axim_outstanding_wcount < 7)) begin
        _axi_m_ctrl_axim_outstanding_wcount <= _axi_m_ctrl_axim_outstanding_wcount + 1;
      end 
      if(!(axi_m_ctrl_axim_awvalid && axi_m_ctrl_axim_awready) && (axi_m_ctrl_axim_bvalid && axi_m_ctrl_axim_bready) && (_axi_m_ctrl_axim_outstanding_wcount > 0)) begin
        _axi_m_ctrl_axim_outstanding_wcount <= _axi_m_ctrl_axim_outstanding_wcount - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_bridge_rdata <= 0;
      axi_s_bridge_rvalid <= 0;
      axi_s_bridge_rlast <= 0;
      _axi_s_bridge_rdata_cond_0_1 <= 0;
    end else begin
      if(_axi_s_bridge_rdata_cond_0_1) begin
        axi_s_bridge_rvalid <= 0;
        axi_s_bridge_rlast <= 0;
      end 
      if((fsm == 102) && (axi_s_bridge_rready || !axi_s_bridge_rvalid)) begin
        axi_s_bridge_rdata <= read_data;
        axi_s_bridge_rvalid <= 1;
        axi_s_bridge_rlast <= 1;
      end 
      _axi_s_bridge_rdata_cond_0_1 <= 1;
      if(axi_s_bridge_rvalid && !axi_s_bridge_rready) begin
        axi_s_bridge_rvalid <= axi_s_bridge_rvalid;
        axi_s_bridge_rlast <= axi_s_bridge_rlast;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_bridge_bid <= 0;
      axi_s_bridge_rid <= 0;
      axi_s_bridge_bvalid <= 0;
      prev_awvalid_246 <= 0;
      prev_arvalid_247 <= 0;
      writevalid_244 <= 0;
      readvalid_245 <= 0;
      addr_242 <= 0;
      length_243 <= 0;
    end else begin
      if(axi_s_bridge_awvalid && axi_s_bridge_awready && !axi_s_bridge_bvalid) begin
        axi_s_bridge_bid <= axi_s_bridge_awid;
      end 
      if(axi_s_bridge_arvalid && axi_s_bridge_arready) begin
        axi_s_bridge_rid <= axi_s_bridge_arid;
      end 
      if(axi_s_bridge_bvalid && axi_s_bridge_bready) begin
        axi_s_bridge_bvalid <= 0;
      end 
      if(axi_s_bridge_wvalid && axi_s_bridge_wready && axi_s_bridge_wlast) begin
        axi_s_bridge_bvalid <= 1;
      end 
      prev_awvalid_246 <= axi_s_bridge_awvalid;
      prev_arvalid_247 <= axi_s_bridge_arvalid;
      writevalid_244 <= 0;
      readvalid_245 <= 0;
      if(axi_s_bridge_awready && axi_s_bridge_awvalid && !axi_s_bridge_bvalid) begin
        addr_242 <= axi_s_bridge_awaddr;
        length_243 <= axi_s_bridge_awlen + 1;
        writevalid_244 <= 1;
      end else if(axi_s_bridge_arready && axi_s_bridge_arvalid) begin
        addr_242 <= axi_s_bridge_araddr;
        length_243 <= axi_s_bridge_arlen + 1;
        readvalid_245 <= 1;
      end 
    end
  end

  localparam bridge_thread_1 = 1;
  localparam bridge_thread_2 = 2;
  localparam bridge_thread_3 = 3;
  localparam bridge_thread_4 = 4;
  localparam bridge_thread_5 = 5;
  localparam bridge_thread_6 = 6;
  localparam bridge_thread_7 = 7;
  localparam bridge_thread_8 = 8;
  localparam bridge_thread_9 = 9;
  localparam bridge_thread_10 = 10;
  localparam bridge_thread_11 = 11;
  localparam bridge_thread_12 = 12;
  localparam bridge_thread_13 = 13;
  localparam bridge_thread_14 = 14;
  localparam bridge_thread_15 = 15;
  localparam bridge_thread_16 = 16;
  localparam bridge_thread_17 = 17;
  localparam bridge_thread_18 = 18;
  localparam bridge_thread_19 = 19;
  localparam bridge_thread_20 = 20;
  localparam bridge_thread_21 = 21;
  localparam bridge_thread_22 = 22;
  localparam bridge_thread_23 = 23;
  localparam bridge_thread_24 = 24;
  localparam bridge_thread_25 = 25;
  localparam bridge_thread_26 = 26;
  localparam bridge_thread_27 = 27;
  localparam bridge_thread_28 = 28;
  localparam bridge_thread_29 = 29;
  localparam bridge_thread_30 = 30;
  localparam bridge_thread_31 = 31;
  localparam bridge_thread_32 = 32;
  localparam bridge_thread_33 = 33;
  localparam bridge_thread_34 = 34;
  localparam bridge_thread_35 = 35;
  localparam bridge_thread_36 = 36;
  localparam bridge_thread_37 = 37;
  localparam bridge_thread_38 = 38;
  localparam bridge_thread_39 = 39;
  localparam bridge_thread_40 = 40;
  localparam bridge_thread_41 = 41;
  localparam bridge_thread_42 = 42;
  localparam bridge_thread_43 = 43;
  localparam bridge_thread_44 = 44;
  localparam bridge_thread_45 = 45;
  localparam bridge_thread_46 = 46;
  localparam bridge_thread_47 = 47;
  localparam bridge_thread_48 = 48;
  localparam bridge_thread_49 = 49;
  localparam bridge_thread_50 = 50;
  localparam bridge_thread_51 = 51;
  localparam bridge_thread_52 = 52;
  localparam bridge_thread_53 = 53;
  localparam bridge_thread_54 = 54;
  localparam bridge_thread_55 = 55;
  localparam bridge_thread_56 = 56;
  localparam bridge_thread_57 = 57;
  localparam bridge_thread_58 = 58;
  localparam bridge_thread_59 = 59;
  localparam bridge_thread_60 = 60;
  localparam bridge_thread_61 = 61;
  localparam bridge_thread_62 = 62;
  localparam bridge_thread_63 = 63;
  localparam bridge_thread_64 = 64;
  localparam bridge_thread_65 = 65;
  localparam bridge_thread_66 = 66;
  localparam bridge_thread_67 = 67;
  localparam bridge_thread_68 = 68;
  localparam bridge_thread_69 = 69;
  localparam bridge_thread_70 = 70;
  localparam bridge_thread_71 = 71;
  localparam bridge_thread_72 = 72;
  localparam bridge_thread_73 = 73;
  localparam bridge_thread_74 = 74;
  localparam bridge_thread_75 = 75;
  localparam bridge_thread_76 = 76;
  localparam bridge_thread_77 = 77;
  localparam bridge_thread_78 = 78;
  localparam bridge_thread_79 = 79;
  localparam bridge_thread_80 = 80;
  localparam bridge_thread_81 = 81;
  localparam bridge_thread_82 = 82;
  localparam bridge_thread_83 = 83;
  localparam bridge_thread_84 = 84;
  localparam bridge_thread_85 = 85;
  localparam bridge_thread_86 = 86;
  localparam bridge_thread_87 = 87;
  localparam bridge_thread_88 = 88;
  localparam bridge_thread_89 = 89;
  localparam bridge_thread_90 = 90;
  localparam bridge_thread_91 = 91;
  localparam bridge_thread_92 = 92;
  localparam bridge_thread_93 = 93;

  always @(posedge CLK) begin
    if(RST) begin
      bridge_thread <= bridge_thread_init;
      axim_rdata_236 <= 0;
      read_data <= 0;
      axim_rdata_237 <= 0;
      axim_rdata_238 <= 0;
      axim_rdata_239 <= 0;
      axim_rdata_240 <= 0;
      axim_rdata_241 <= 0;
      request_complete_235 <= 0;
      status_234 <= 0;
    end else begin
      case(bridge_thread)
        bridge_thread_init: begin
          bridge_thread <= bridge_thread_1;
        end
        bridge_thread_1: begin
          if(1) begin
            bridge_thread <= bridge_thread_2;
          end else begin
            bridge_thread <= bridge_thread_93;
          end
        end
        bridge_thread_2: begin
          if(status_234 == 0) begin
            bridge_thread <= bridge_thread_3;
          end else begin
            bridge_thread <= bridge_thread_87;
          end
        end
        bridge_thread_3: begin
          if(request_valid == 1) begin
            bridge_thread <= bridge_thread_4;
          end else begin
            bridge_thread <= bridge_thread_86;
          end
        end
        bridge_thread_4: begin
          if(addr_reg < 4096) begin
            bridge_thread <= bridge_thread_5;
          end else begin
            bridge_thread <= bridge_thread_17;
          end
        end
        bridge_thread_5: begin
          if(is_write == 1) begin
            bridge_thread <= bridge_thread_6;
          end else begin
            bridge_thread <= bridge_thread_12;
          end
        end
        bridge_thread_6: begin
          if((_axi_m_spm_data_outstanding_wcount == 0) && (axi_m_spm_data_awready || !axi_m_spm_data_awvalid)) begin
            bridge_thread <= bridge_thread_7;
          end 
        end
        bridge_thread_7: begin
          if(axi_m_spm_data_awvalid && axi_m_spm_data_awready) begin
            bridge_thread <= bridge_thread_8;
          end 
        end
        bridge_thread_8: begin
          if(_axi_m_spm_data_wready_sb_0 || !_axi_m_spm_data_wvalid_sb_0) begin
            bridge_thread <= bridge_thread_9;
          end 
        end
        bridge_thread_9: begin
          if(_axi_m_spm_data_wvalid_sb_0 && _axi_m_spm_data_wready_sb_0) begin
            bridge_thread <= bridge_thread_10;
          end 
        end
        bridge_thread_10: begin
          if(!_axi_m_spm_data_has_outstanding_write) begin
            bridge_thread <= bridge_thread_11;
          end 
        end
        bridge_thread_11: begin
          bridge_thread <= bridge_thread_16;
        end
        bridge_thread_12: begin
          if(axi_m_spm_data_arready || !axi_m_spm_data_arvalid) begin
            bridge_thread <= bridge_thread_13;
          end 
        end
        bridge_thread_13: begin
          if(axi_m_spm_data_arvalid && axi_m_spm_data_arready) begin
            bridge_thread <= bridge_thread_14;
          end 
        end
        bridge_thread_14: begin
          if(_axi_m_spm_data_rvalid_sb_0) begin
            axim_rdata_236 <= _axi_m_spm_data_rdata_sb_0;
          end 
          if(_axi_m_spm_data_rvalid_sb_0) begin
            bridge_thread <= bridge_thread_15;
          end 
        end
        bridge_thread_15: begin
          read_data <= axim_rdata_236;
          bridge_thread <= bridge_thread_16;
        end
        bridge_thread_16: begin
          bridge_thread <= bridge_thread_83;
        end
        bridge_thread_17: begin
          if(addr_reg < 8192) begin
            bridge_thread <= bridge_thread_18;
          end else begin
            bridge_thread <= bridge_thread_30;
          end
        end
        bridge_thread_18: begin
          if(is_write == 1) begin
            bridge_thread <= bridge_thread_19;
          end else begin
            bridge_thread <= bridge_thread_25;
          end
        end
        bridge_thread_19: begin
          if((_axi_m_ctrl_spm_outstanding_wcount == 0) && (axi_m_ctrl_spm_awready || !axi_m_ctrl_spm_awvalid)) begin
            bridge_thread <= bridge_thread_20;
          end 
        end
        bridge_thread_20: begin
          if(axi_m_ctrl_spm_awvalid && axi_m_ctrl_spm_awready) begin
            bridge_thread <= bridge_thread_21;
          end 
        end
        bridge_thread_21: begin
          if(_axi_m_ctrl_spm_wready_sb_0 || !_axi_m_ctrl_spm_wvalid_sb_0) begin
            bridge_thread <= bridge_thread_22;
          end 
        end
        bridge_thread_22: begin
          if(_axi_m_ctrl_spm_wvalid_sb_0 && _axi_m_ctrl_spm_wready_sb_0) begin
            bridge_thread <= bridge_thread_23;
          end 
        end
        bridge_thread_23: begin
          if(!_axi_m_ctrl_spm_has_outstanding_write) begin
            bridge_thread <= bridge_thread_24;
          end 
        end
        bridge_thread_24: begin
          bridge_thread <= bridge_thread_29;
        end
        bridge_thread_25: begin
          if(axi_m_ctrl_spm_arready || !axi_m_ctrl_spm_arvalid) begin
            bridge_thread <= bridge_thread_26;
          end 
        end
        bridge_thread_26: begin
          if(axi_m_ctrl_spm_arvalid && axi_m_ctrl_spm_arready) begin
            bridge_thread <= bridge_thread_27;
          end 
        end
        bridge_thread_27: begin
          if(_axi_m_ctrl_spm_rvalid_sb_0) begin
            axim_rdata_237 <= _axi_m_ctrl_spm_rdata_sb_0;
          end 
          if(_axi_m_ctrl_spm_rvalid_sb_0) begin
            bridge_thread <= bridge_thread_28;
          end 
        end
        bridge_thread_28: begin
          read_data <= axim_rdata_237;
          bridge_thread <= bridge_thread_29;
        end
        bridge_thread_29: begin
          bridge_thread <= bridge_thread_83;
        end
        bridge_thread_30: begin
          if(addr_reg < 12288) begin
            bridge_thread <= bridge_thread_31;
          end else begin
            bridge_thread <= bridge_thread_43;
          end
        end
        bridge_thread_31: begin
          if(is_write == 1) begin
            bridge_thread <= bridge_thread_32;
          end else begin
            bridge_thread <= bridge_thread_38;
          end
        end
        bridge_thread_32: begin
          if((_axi_m_ctrl_mac_outstanding_wcount == 0) && (axi_m_ctrl_mac_awready || !axi_m_ctrl_mac_awvalid)) begin
            bridge_thread <= bridge_thread_33;
          end 
        end
        bridge_thread_33: begin
          if(axi_m_ctrl_mac_awvalid && axi_m_ctrl_mac_awready) begin
            bridge_thread <= bridge_thread_34;
          end 
        end
        bridge_thread_34: begin
          if(_axi_m_ctrl_mac_wready_sb_0 || !_axi_m_ctrl_mac_wvalid_sb_0) begin
            bridge_thread <= bridge_thread_35;
          end 
        end
        bridge_thread_35: begin
          if(_axi_m_ctrl_mac_wvalid_sb_0 && _axi_m_ctrl_mac_wready_sb_0) begin
            bridge_thread <= bridge_thread_36;
          end 
        end
        bridge_thread_36: begin
          if(!_axi_m_ctrl_mac_has_outstanding_write) begin
            bridge_thread <= bridge_thread_37;
          end 
        end
        bridge_thread_37: begin
          bridge_thread <= bridge_thread_42;
        end
        bridge_thread_38: begin
          if(axi_m_ctrl_mac_arready || !axi_m_ctrl_mac_arvalid) begin
            bridge_thread <= bridge_thread_39;
          end 
        end
        bridge_thread_39: begin
          if(axi_m_ctrl_mac_arvalid && axi_m_ctrl_mac_arready) begin
            bridge_thread <= bridge_thread_40;
          end 
        end
        bridge_thread_40: begin
          if(_axi_m_ctrl_mac_rvalid_sb_0) begin
            axim_rdata_238 <= _axi_m_ctrl_mac_rdata_sb_0;
          end 
          if(_axi_m_ctrl_mac_rvalid_sb_0) begin
            bridge_thread <= bridge_thread_41;
          end 
        end
        bridge_thread_41: begin
          read_data <= axim_rdata_238;
          bridge_thread <= bridge_thread_42;
        end
        bridge_thread_42: begin
          bridge_thread <= bridge_thread_83;
        end
        bridge_thread_43: begin
          if(addr_reg < 16384) begin
            bridge_thread <= bridge_thread_44;
          end else begin
            bridge_thread <= bridge_thread_56;
          end
        end
        bridge_thread_44: begin
          if(is_write == 1) begin
            bridge_thread <= bridge_thread_45;
          end else begin
            bridge_thread <= bridge_thread_51;
          end
        end
        bridge_thread_45: begin
          if((_axi_m_ctrl_aes_outstanding_wcount == 0) && (axi_m_ctrl_aes_awready || !axi_m_ctrl_aes_awvalid)) begin
            bridge_thread <= bridge_thread_46;
          end 
        end
        bridge_thread_46: begin
          if(axi_m_ctrl_aes_awvalid && axi_m_ctrl_aes_awready) begin
            bridge_thread <= bridge_thread_47;
          end 
        end
        bridge_thread_47: begin
          if(_axi_m_ctrl_aes_wready_sb_0 || !_axi_m_ctrl_aes_wvalid_sb_0) begin
            bridge_thread <= bridge_thread_48;
          end 
        end
        bridge_thread_48: begin
          if(_axi_m_ctrl_aes_wvalid_sb_0 && _axi_m_ctrl_aes_wready_sb_0) begin
            bridge_thread <= bridge_thread_49;
          end 
        end
        bridge_thread_49: begin
          if(!_axi_m_ctrl_aes_has_outstanding_write) begin
            bridge_thread <= bridge_thread_50;
          end 
        end
        bridge_thread_50: begin
          bridge_thread <= bridge_thread_55;
        end
        bridge_thread_51: begin
          if(axi_m_ctrl_aes_arready || !axi_m_ctrl_aes_arvalid) begin
            bridge_thread <= bridge_thread_52;
          end 
        end
        bridge_thread_52: begin
          if(axi_m_ctrl_aes_arvalid && axi_m_ctrl_aes_arready) begin
            bridge_thread <= bridge_thread_53;
          end 
        end
        bridge_thread_53: begin
          if(_axi_m_ctrl_aes_rvalid_sb_0) begin
            axim_rdata_239 <= _axi_m_ctrl_aes_rdata_sb_0;
          end 
          if(_axi_m_ctrl_aes_rvalid_sb_0) begin
            bridge_thread <= bridge_thread_54;
          end 
        end
        bridge_thread_54: begin
          read_data <= axim_rdata_239;
          bridge_thread <= bridge_thread_55;
        end
        bridge_thread_55: begin
          bridge_thread <= bridge_thread_83;
        end
        bridge_thread_56: begin
          if(addr_reg < 20480) begin
            bridge_thread <= bridge_thread_57;
          end else begin
            bridge_thread <= bridge_thread_69;
          end
        end
        bridge_thread_57: begin
          if(is_write == 1) begin
            bridge_thread <= bridge_thread_58;
          end else begin
            bridge_thread <= bridge_thread_64;
          end
        end
        bridge_thread_58: begin
          if((_axi_m_ctrl_axim_outstanding_wcount == 0) && (axi_m_ctrl_axim_awready || !axi_m_ctrl_axim_awvalid)) begin
            bridge_thread <= bridge_thread_59;
          end 
        end
        bridge_thread_59: begin
          if(axi_m_ctrl_axim_awvalid && axi_m_ctrl_axim_awready) begin
            bridge_thread <= bridge_thread_60;
          end 
        end
        bridge_thread_60: begin
          if(_axi_m_ctrl_axim_wready_sb_0 || !_axi_m_ctrl_axim_wvalid_sb_0) begin
            bridge_thread <= bridge_thread_61;
          end 
        end
        bridge_thread_61: begin
          if(_axi_m_ctrl_axim_wvalid_sb_0 && _axi_m_ctrl_axim_wready_sb_0) begin
            bridge_thread <= bridge_thread_62;
          end 
        end
        bridge_thread_62: begin
          if(!_axi_m_ctrl_axim_has_outstanding_write) begin
            bridge_thread <= bridge_thread_63;
          end 
        end
        bridge_thread_63: begin
          bridge_thread <= bridge_thread_68;
        end
        bridge_thread_64: begin
          if(axi_m_ctrl_axim_arready || !axi_m_ctrl_axim_arvalid) begin
            bridge_thread <= bridge_thread_65;
          end 
        end
        bridge_thread_65: begin
          if(axi_m_ctrl_axim_arvalid && axi_m_ctrl_axim_arready) begin
            bridge_thread <= bridge_thread_66;
          end 
        end
        bridge_thread_66: begin
          if(_axi_m_ctrl_axim_rvalid_sb_0) begin
            axim_rdata_240 <= _axi_m_ctrl_axim_rdata_sb_0;
          end 
          if(_axi_m_ctrl_axim_rvalid_sb_0) begin
            bridge_thread <= bridge_thread_67;
          end 
        end
        bridge_thread_67: begin
          read_data <= axim_rdata_240;
          bridge_thread <= bridge_thread_68;
        end
        bridge_thread_68: begin
          bridge_thread <= bridge_thread_83;
        end
        bridge_thread_69: begin
          if(addr_reg < 24576) begin
            bridge_thread <= bridge_thread_70;
          end else begin
            bridge_thread <= bridge_thread_82;
          end
        end
        bridge_thread_70: begin
          if(is_write == 1) begin
            bridge_thread <= bridge_thread_71;
          end else begin
            bridge_thread <= bridge_thread_77;
          end
        end
        bridge_thread_71: begin
          if((_axi_m_ctrl_xor_outstanding_wcount == 0) && (axi_m_ctrl_xor_awready || !axi_m_ctrl_xor_awvalid)) begin
            bridge_thread <= bridge_thread_72;
          end 
        end
        bridge_thread_72: begin
          if(axi_m_ctrl_xor_awvalid && axi_m_ctrl_xor_awready) begin
            bridge_thread <= bridge_thread_73;
          end 
        end
        bridge_thread_73: begin
          if(_axi_m_ctrl_xor_wready_sb_0 || !_axi_m_ctrl_xor_wvalid_sb_0) begin
            bridge_thread <= bridge_thread_74;
          end 
        end
        bridge_thread_74: begin
          if(_axi_m_ctrl_xor_wvalid_sb_0 && _axi_m_ctrl_xor_wready_sb_0) begin
            bridge_thread <= bridge_thread_75;
          end 
        end
        bridge_thread_75: begin
          if(!_axi_m_ctrl_xor_has_outstanding_write) begin
            bridge_thread <= bridge_thread_76;
          end 
        end
        bridge_thread_76: begin
          bridge_thread <= bridge_thread_81;
        end
        bridge_thread_77: begin
          if(axi_m_ctrl_xor_arready || !axi_m_ctrl_xor_arvalid) begin
            bridge_thread <= bridge_thread_78;
          end 
        end
        bridge_thread_78: begin
          if(axi_m_ctrl_xor_arvalid && axi_m_ctrl_xor_arready) begin
            bridge_thread <= bridge_thread_79;
          end 
        end
        bridge_thread_79: begin
          if(_axi_m_ctrl_xor_rvalid_sb_0) begin
            axim_rdata_241 <= _axi_m_ctrl_xor_rdata_sb_0;
          end 
          if(_axi_m_ctrl_xor_rvalid_sb_0) begin
            bridge_thread <= bridge_thread_80;
          end 
        end
        bridge_thread_80: begin
          read_data <= axim_rdata_241;
          bridge_thread <= bridge_thread_81;
        end
        bridge_thread_81: begin
          bridge_thread <= bridge_thread_83;
        end
        bridge_thread_82: begin
          $display(" Invalid address: %x", addr_reg);
          bridge_thread <= bridge_thread_83;
        end
        bridge_thread_83: begin
          request_complete_235 <= 1;
          bridge_thread <= bridge_thread_84;
        end
        bridge_thread_84: begin
          status_234 <= 1;
          bridge_thread <= bridge_thread_85;
        end
        bridge_thread_85: begin
          bridge_thread <= bridge_thread_86;
        end
        bridge_thread_86: begin
          bridge_thread <= bridge_thread_92;
        end
        bridge_thread_87: begin
          if(status_234 == 1) begin
            bridge_thread <= bridge_thread_88;
          end else begin
            bridge_thread <= bridge_thread_92;
          end
        end
        bridge_thread_88: begin
          if(request_valid == 0) begin
            bridge_thread <= bridge_thread_89;
          end else begin
            bridge_thread <= bridge_thread_92;
          end
        end
        bridge_thread_89: begin
          request_complete_235 <= 0;
          bridge_thread <= bridge_thread_90;
        end
        bridge_thread_90: begin
          status_234 <= 0;
          bridge_thread <= bridge_thread_91;
        end
        bridge_thread_91: begin
          bridge_thread <= bridge_thread_92;
        end
        bridge_thread_92: begin
          bridge_thread <= bridge_thread_1;
        end
      endcase
    end
  end

  localparam fsm_1 = 1;
  localparam fsm_200 = 200;
  localparam fsm_201 = 201;
  localparam fsm_202 = 202;
  localparam fsm_203 = 203;
  localparam fsm_204 = 204;
  localparam fsm_205 = 205;
  localparam fsm_100 = 100;
  localparam fsm_101 = 101;
  localparam fsm_102 = 102;
  localparam fsm_103 = 103;
  localparam fsm_104 = 104;
  localparam fsm_105 = 105;

  always @(posedge CLK) begin
    if(RST) begin
      fsm <= fsm_init;
      addr_reg <= 0;
      is_write <= 0;
      request_valid <= 0;
      write_data <= 0;
    end else begin
      case(fsm)
        fsm_init: begin
          fsm <= fsm_1;
        end
        fsm_1: begin
          addr_reg <= addr_242;
          if(writevalid_244) begin
            is_write <= 1;
          end 
          if(readvalid_245) begin
            is_write <= 0;
            request_valid <= 1;
          end 
          if(readvalid_245) begin
            fsm <= fsm_100;
          end 
          if(writevalid_244) begin
            fsm <= fsm_200;
          end 
        end
        fsm_100: begin
          fsm <= fsm_101;
        end
        fsm_101: begin
          if(request_complete_235 == 1) begin
            fsm <= fsm_102;
          end 
        end
        fsm_102: begin
          if(axi_s_bridge_rready || !axi_s_bridge_rvalid) begin
            fsm <= fsm_103;
          end 
        end
        fsm_103: begin
          request_valid <= 0;
          fsm <= fsm_104;
        end
        fsm_104: begin
          if(status_234 == 0) begin
            fsm <= fsm_105;
          end 
        end
        fsm_105: begin
          fsm <= fsm_init;
        end
        fsm_200: begin
          fsm <= fsm_201;
        end
        fsm_201: begin
          write_data <= axi_s_bridge_wdata;
          if(axi_s_bridge_wlast & axi_s_bridge_wvalid) begin
            fsm <= fsm_202;
          end 
        end
        fsm_202: begin
          request_valid <= 1;
          fsm <= fsm_203;
        end
        fsm_203: begin
          if(request_complete_235 == 1) begin
            fsm <= fsm_204;
          end 
        end
        fsm_204: begin
          request_valid <= 0;
          if(status_234 == 0) begin
            fsm <= fsm_205;
          end 
        end
        fsm_205: begin
          fsm <= fsm_init;
        end
      endcase
    end
  end


endmodule



module wrapper
(
  input CLK,
  input RST,
  input [32-1:0] axi_s_ctrl_spm_awaddr,
  input [4-1:0] axi_s_ctrl_spm_awcache,
  input [3-1:0] axi_s_ctrl_spm_awprot,
  input axi_s_ctrl_spm_awvalid,
  output axi_s_ctrl_spm_awready,
  input [64-1:0] axi_s_ctrl_spm_wdata,
  input [8-1:0] axi_s_ctrl_spm_wstrb,
  input axi_s_ctrl_spm_wvalid,
  output axi_s_ctrl_spm_wready,
  output [2-1:0] axi_s_ctrl_spm_bresp,
  output axi_s_ctrl_spm_bvalid,
  input axi_s_ctrl_spm_bready,
  input [32-1:0] axi_s_ctrl_spm_araddr,
  input [4-1:0] axi_s_ctrl_spm_arcache,
  input [3-1:0] axi_s_ctrl_spm_arprot,
  input axi_s_ctrl_spm_arvalid,
  output axi_s_ctrl_spm_arready,
  output [64-1:0] axi_s_ctrl_spm_rdata,
  output [2-1:0] axi_s_ctrl_spm_rresp,
  output axi_s_ctrl_spm_rvalid,
  input axi_s_ctrl_spm_rready,
  output [32-1:0] axi_m_dram_awaddr,
  output [8-1:0] axi_m_dram_awlen,
  output [3-1:0] axi_m_dram_awsize,
  output [2-1:0] axi_m_dram_awburst,
  output [1-1:0] axi_m_dram_awlock,
  output [4-1:0] axi_m_dram_awcache,
  output [3-1:0] axi_m_dram_awprot,
  output [4-1:0] axi_m_dram_awqos,
  output [2-1:0] axi_m_dram_awuser,
  output axi_m_dram_awvalid,
  input axi_m_dram_awready,
  output [128-1:0] axi_m_dram_wdata,
  output [16-1:0] axi_m_dram_wstrb,
  output axi_m_dram_wlast,
  output axi_m_dram_wvalid,
  input axi_m_dram_wready,
  input [2-1:0] axi_m_dram_bresp,
  input axi_m_dram_bvalid,
  output axi_m_dram_bready,
  output [32-1:0] axi_m_dram_araddr,
  output [8-1:0] axi_m_dram_arlen,
  output [3-1:0] axi_m_dram_arsize,
  output [2-1:0] axi_m_dram_arburst,
  output [1-1:0] axi_m_dram_arlock,
  output [4-1:0] axi_m_dram_arcache,
  output [3-1:0] axi_m_dram_arprot,
  output [4-1:0] axi_m_dram_arqos,
  output [2-1:0] axi_m_dram_aruser,
  output axi_m_dram_arvalid,
  input axi_m_dram_arready,
  input [128-1:0] axi_m_dram_rdata,
  input [2-1:0] axi_m_dram_rresp,
  input axi_m_dram_rlast,
  input axi_m_dram_rvalid,
  output axi_m_dram_rready,
  input [32-1:0] axi_s_ctrl_mac_awaddr,
  input [4-1:0] axi_s_ctrl_mac_awcache,
  input [3-1:0] axi_s_ctrl_mac_awprot,
  input axi_s_ctrl_mac_awvalid,
  output axi_s_ctrl_mac_awready,
  input [64-1:0] axi_s_ctrl_mac_wdata,
  input [8-1:0] axi_s_ctrl_mac_wstrb,
  input axi_s_ctrl_mac_wvalid,
  output axi_s_ctrl_mac_wready,
  output [2-1:0] axi_s_ctrl_mac_bresp,
  output axi_s_ctrl_mac_bvalid,
  input axi_s_ctrl_mac_bready,
  input [32-1:0] axi_s_ctrl_mac_araddr,
  input [4-1:0] axi_s_ctrl_mac_arcache,
  input [3-1:0] axi_s_ctrl_mac_arprot,
  input axi_s_ctrl_mac_arvalid,
  output axi_s_ctrl_mac_arready,
  output [64-1:0] axi_s_ctrl_mac_rdata,
  output [2-1:0] axi_s_ctrl_mac_rresp,
  output axi_s_ctrl_mac_rvalid,
  input axi_s_ctrl_mac_rready,
  input [32-1:0] axi_s_ctrl_xor_awaddr,
  input [4-1:0] axi_s_ctrl_xor_awcache,
  input [3-1:0] axi_s_ctrl_xor_awprot,
  input axi_s_ctrl_xor_awvalid,
  output axi_s_ctrl_xor_awready,
  input [64-1:0] axi_s_ctrl_xor_wdata,
  input [8-1:0] axi_s_ctrl_xor_wstrb,
  input axi_s_ctrl_xor_wvalid,
  output axi_s_ctrl_xor_wready,
  output [2-1:0] axi_s_ctrl_xor_bresp,
  output axi_s_ctrl_xor_bvalid,
  input axi_s_ctrl_xor_bready,
  input [32-1:0] axi_s_ctrl_xor_araddr,
  input [4-1:0] axi_s_ctrl_xor_arcache,
  input [3-1:0] axi_s_ctrl_xor_arprot,
  input axi_s_ctrl_xor_arvalid,
  output axi_s_ctrl_xor_arready,
  output [64-1:0] axi_s_ctrl_xor_rdata,
  output [2-1:0] axi_s_ctrl_xor_rresp,
  output axi_s_ctrl_xor_rvalid,
  input axi_s_ctrl_xor_rready,
  input [32-1:0] axi_s_ctrl_aes_awaddr,
  input [4-1:0] axi_s_ctrl_aes_awcache,
  input [3-1:0] axi_s_ctrl_aes_awprot,
  input axi_s_ctrl_aes_awvalid,
  output axi_s_ctrl_aes_awready,
  input [64-1:0] axi_s_ctrl_aes_wdata,
  input [8-1:0] axi_s_ctrl_aes_wstrb,
  input axi_s_ctrl_aes_wvalid,
  output axi_s_ctrl_aes_wready,
  output [2-1:0] axi_s_ctrl_aes_bresp,
  output axi_s_ctrl_aes_bvalid,
  input axi_s_ctrl_aes_bready,
  input [32-1:0] axi_s_ctrl_aes_araddr,
  input [4-1:0] axi_s_ctrl_aes_arcache,
  input [3-1:0] axi_s_ctrl_aes_arprot,
  input axi_s_ctrl_aes_arvalid,
  output axi_s_ctrl_aes_arready,
  output [64-1:0] axi_s_ctrl_aes_rdata,
  output [2-1:0] axi_s_ctrl_aes_rresp,
  output axi_s_ctrl_aes_rvalid,
  input axi_s_ctrl_aes_rready,
  input [32-1:0] axi_s_ctrl_axim_awaddr,
  input [4-1:0] axi_s_ctrl_axim_awcache,
  input [3-1:0] axi_s_ctrl_axim_awprot,
  input axi_s_ctrl_axim_awvalid,
  output axi_s_ctrl_axim_awready,
  input [64-1:0] axi_s_ctrl_axim_wdata,
  input [8-1:0] axi_s_ctrl_axim_wstrb,
  input axi_s_ctrl_axim_wvalid,
  output axi_s_ctrl_axim_wready,
  output [2-1:0] axi_s_ctrl_axim_bresp,
  output axi_s_ctrl_axim_bvalid,
  input axi_s_ctrl_axim_bready,
  input [32-1:0] axi_s_ctrl_axim_araddr,
  input [4-1:0] axi_s_ctrl_axim_arcache,
  input [3-1:0] axi_s_ctrl_axim_arprot,
  input axi_s_ctrl_axim_arvalid,
  output axi_s_ctrl_axim_arready,
  output [64-1:0] axi_s_ctrl_axim_rdata,
  output [2-1:0] axi_s_ctrl_axim_rresp,
  output axi_s_ctrl_axim_rvalid,
  input axi_s_ctrl_axim_rready,
  input [32-1:0] axi_s_llc_awaddr,
  input [8-1:0] axi_s_llc_awlen,
  input [3-1:0] axi_s_llc_awsize,
  input [2-1:0] axi_s_llc_awburst,
  input [1-1:0] axi_s_llc_awlock,
  input [4-1:0] axi_s_llc_awcache,
  input [3-1:0] axi_s_llc_awprot,
  input [4-1:0] axi_s_llc_awqos,
  input [2-1:0] axi_s_llc_awuser,
  input axi_s_llc_awvalid,
  output axi_s_llc_awready,
  input [128-1:0] axi_s_llc_wdata,
  input [16-1:0] axi_s_llc_wstrb,
  input axi_s_llc_wlast,
  input axi_s_llc_wvalid,
  output axi_s_llc_wready,
  output [2-1:0] axi_s_llc_bresp,
  output axi_s_llc_bvalid,
  input axi_s_llc_bready,
  input [32-1:0] axi_s_llc_araddr,
  input [8-1:0] axi_s_llc_arlen,
  input [3-1:0] axi_s_llc_arsize,
  input [2-1:0] axi_s_llc_arburst,
  input [1-1:0] axi_s_llc_arlock,
  input [4-1:0] axi_s_llc_arcache,
  input [3-1:0] axi_s_llc_arprot,
  input [4-1:0] axi_s_llc_arqos,
  input [2-1:0] axi_s_llc_aruser,
  input axi_s_llc_arvalid,
  output axi_s_llc_arready,
  output [128-1:0] axi_s_llc_rdata,
  output [2-1:0] axi_s_llc_rresp,
  output axi_s_llc_rlast,
  output axi_s_llc_rvalid,
  input axi_s_llc_rready,
  input [32-1:0] axi_s_spm_data_awaddr,
  input [4-1:0] axi_s_spm_data_awcache,
  input [3-1:0] axi_s_spm_data_awprot,
  input axi_s_spm_data_awvalid,
  output axi_s_spm_data_awready,
  input [64-1:0] axi_s_spm_data_wdata,
  input [8-1:0] axi_s_spm_data_wstrb,
  input axi_s_spm_data_wvalid,
  output axi_s_spm_data_wready,
  output [2-1:0] axi_s_spm_data_bresp,
  output axi_s_spm_data_bvalid,
  input axi_s_spm_data_bready,
  input [32-1:0] axi_s_spm_data_araddr,
  input [4-1:0] axi_s_spm_data_arcache,
  input [3-1:0] axi_s_spm_data_arprot,
  input axi_s_spm_data_arvalid,
  output axi_s_spm_data_arready,
  output [64-1:0] axi_s_spm_data_rdata,
  output [2-1:0] axi_s_spm_data_rresp,
  output axi_s_spm_data_rvalid,
  input axi_s_spm_data_rready
);

  wire [128-1:0] axis_in_mac_tdata;
  wire axis_in_mac_tvalid;
  wire axis_in_mac_tready;
  wire axis_in_mac_tlast;
  wire [128-1:0] axis_in_aes_tdata;
  wire axis_in_aes_tvalid;
  wire axis_in_aes_tready;
  wire axis_in_aes_tlast;
  wire [128-1:0] axis_out_xoreddata_tdata;
  wire axis_out_xoreddata_tvalid;
  wire axis_out_xoreddata_tready;
  wire axis_out_xoreddata_tlast;
  wire [128-1:0] axis_in_xordata_tdata;
  wire axis_in_xordata_tvalid;
  wire axis_in_xordata_tready;
  wire axis_in_xordata_tlast;
  wire [128-1:0] axis_out_axim_tdata;
  wire axis_out_axim_tvalid;
  wire axis_out_axim_tready;
  wire axis_out_axim_tlast;
  wire [128-1:0] axis_in_axim_tdata;
  wire axis_in_axim_tvalid;
  wire axis_in_axim_tready;
  wire axis_in_axim_tlast;
  wire [63:0] ram_spm_1_wdata;
  wire [63:0] ram_spm_1_rdata;
  wire [63:0] ram_spm_1_addr;
  wire ram_spm_1_wenable;
  wire ram_spm_1_enable;

  spm
  spm_inst
  (
    .CLK(CLK),
    .RST(RST),
    .axi_s_ctrl_spm_awaddr(axi_s_ctrl_spm_awaddr),
    .axi_s_ctrl_spm_awcache(axi_s_ctrl_spm_awcache),
    .axi_s_ctrl_spm_awprot(axi_s_ctrl_spm_awprot),
    .axi_s_ctrl_spm_awvalid(axi_s_ctrl_spm_awvalid),
    .axi_s_ctrl_spm_awready(axi_s_ctrl_spm_awready),
    .axi_s_ctrl_spm_wdata(axi_s_ctrl_spm_wdata),
    .axi_s_ctrl_spm_wstrb(axi_s_ctrl_spm_wstrb),
    .axi_s_ctrl_spm_wvalid(axi_s_ctrl_spm_wvalid),
    .axi_s_ctrl_spm_wready(axi_s_ctrl_spm_wready),
    .axi_s_ctrl_spm_bresp(axi_s_ctrl_spm_bresp),
    .axi_s_ctrl_spm_bvalid(axi_s_ctrl_spm_bvalid),
    .axi_s_ctrl_spm_bready(axi_s_ctrl_spm_bready),
    .axi_s_ctrl_spm_araddr(axi_s_ctrl_spm_araddr),
    .axi_s_ctrl_spm_arcache(axi_s_ctrl_spm_arcache),
    .axi_s_ctrl_spm_arprot(axi_s_ctrl_spm_arprot),
    .axi_s_ctrl_spm_arvalid(axi_s_ctrl_spm_arvalid),
    .axi_s_ctrl_spm_arready(axi_s_ctrl_spm_arready),
    .axi_s_ctrl_spm_rdata(axi_s_ctrl_spm_rdata),
    .axi_s_ctrl_spm_rresp(axi_s_ctrl_spm_rresp),
    .axi_s_ctrl_spm_rvalid(axi_s_ctrl_spm_rvalid),
    .axi_s_ctrl_spm_rready(axi_s_ctrl_spm_rready),
    .axis_out_axim_spm_tdata(axis_in_axim_tdata),
    .axis_out_axim_spm_tvalid(axis_in_axim_tvalid),
    .axis_out_axim_spm_tready(axis_in_axim_tready),
    .axis_out_axim_spm_tlast(axis_in_axim_tlast),
    .axis_in_axim_spm_tdata(axis_out_axim_tdata),
    .axis_in_axim_spm_tvalid(axis_out_axim_tvalid),
    .axis_in_axim_spm_tready(axis_out_axim_tready),
    .axis_in_axim_spm_tlast(axis_out_axim_tlast),
    .axis_out_mac_spm_tdata(axis_in_mac_tdata),
    .axis_out_mac_spm_tvalid(axis_in_mac_tvalid),
    .axis_out_mac_spm_tready(axis_in_mac_tready),
    .axis_out_mac_spm_tlast(axis_in_mac_tlast),
    .axis_out_xored_spm_tdata(axis_in_xordata_tdata),
    .axis_out_xored_spm_tvalid(axis_in_xordata_tvalid),
    .axis_out_xored_spm_tready(axis_in_xordata_tready),
    .axis_out_xored_spm_tlast(axis_in_xordata_tlast),
    .axis_in_xored_spm_tdata(axis_out_xoreddata_tdata),
    .axis_in_xored_spm_tvalid(axis_out_xoreddata_tvalid),
    .axis_in_xored_spm_tready(axis_out_xoreddata_tready),
    .axis_in_xored_spm_tlast(axis_out_xoreddata_tlast),
    .axi_m_dram_awaddr(axi_m_dram_awaddr),
    .axi_m_dram_awlen(axi_m_dram_awlen),
    .axi_m_dram_awsize(axi_m_dram_awsize),
    .axi_m_dram_awburst(axi_m_dram_awburst),
    .axi_m_dram_awlock(axi_m_dram_awlock),
    .axi_m_dram_awcache(axi_m_dram_awcache),
    .axi_m_dram_awprot(axi_m_dram_awprot),
    .axi_m_dram_awqos(axi_m_dram_awqos),
    .axi_m_dram_awuser(axi_m_dram_awuser),
    .axi_m_dram_awvalid(axi_m_dram_awvalid),
    .axi_m_dram_awready(axi_m_dram_awready),
    .axi_m_dram_wdata(axi_m_dram_wdata),
    .axi_m_dram_wstrb(axi_m_dram_wstrb),
    .axi_m_dram_wlast(axi_m_dram_wlast),
    .axi_m_dram_wvalid(axi_m_dram_wvalid),
    .axi_m_dram_wready(axi_m_dram_wready),
    .axi_m_dram_bresp(axi_m_dram_bresp),
    .axi_m_dram_bvalid(axi_m_dram_bvalid),
    .axi_m_dram_bready(axi_m_dram_bready),
    .axi_m_dram_araddr(axi_m_dram_araddr),
    .axi_m_dram_arlen(axi_m_dram_arlen),
    .axi_m_dram_arsize(axi_m_dram_arsize),
    .axi_m_dram_arburst(axi_m_dram_arburst),
    .axi_m_dram_arlock(axi_m_dram_arlock),
    .axi_m_dram_arcache(axi_m_dram_arcache),
    .axi_m_dram_arprot(axi_m_dram_arprot),
    .axi_m_dram_arqos(axi_m_dram_arqos),
    .axi_m_dram_aruser(axi_m_dram_aruser),
    .axi_m_dram_arvalid(axi_m_dram_arvalid),
    .axi_m_dram_arready(axi_m_dram_arready),
    .axi_m_dram_rdata(axi_m_dram_rdata),
    .axi_m_dram_rresp(axi_m_dram_rresp),
    .axi_m_dram_rlast(axi_m_dram_rlast),
    .axi_m_dram_rvalid(axi_m_dram_rvalid),
    .axi_m_dram_rready(axi_m_dram_rready),
    .ram_spm_1_wdata(ram_spm_1_wdata),
    .ram_spm_1_rdata(ram_spm_1_rdata),
    .ram_spm_1_addr(ram_spm_1_addr),
    .ram_spm_1_wenable(ram_spm_1_wenable),
    .ram_spm_1_enable(ram_spm_1_enable)
  );


  mac
  mac_inst
  (
    .CLK(CLK),
    .RST(RST),
    .axi_s_ctrl_mac_awaddr(axi_s_ctrl_mac_awaddr),
    .axi_s_ctrl_mac_awcache(axi_s_ctrl_mac_awcache),
    .axi_s_ctrl_mac_awprot(axi_s_ctrl_mac_awprot),
    .axi_s_ctrl_mac_awvalid(axi_s_ctrl_mac_awvalid),
    .axi_s_ctrl_mac_awready(axi_s_ctrl_mac_awready),
    .axi_s_ctrl_mac_wdata(axi_s_ctrl_mac_wdata),
    .axi_s_ctrl_mac_wstrb(axi_s_ctrl_mac_wstrb),
    .axi_s_ctrl_mac_wvalid(axi_s_ctrl_mac_wvalid),
    .axi_s_ctrl_mac_wready(axi_s_ctrl_mac_wready),
    .axi_s_ctrl_mac_bresp(axi_s_ctrl_mac_bresp),
    .axi_s_ctrl_mac_bvalid(axi_s_ctrl_mac_bvalid),
    .axi_s_ctrl_mac_bready(axi_s_ctrl_mac_bready),
    .axi_s_ctrl_mac_araddr(axi_s_ctrl_mac_araddr),
    .axi_s_ctrl_mac_arcache(axi_s_ctrl_mac_arcache),
    .axi_s_ctrl_mac_arprot(axi_s_ctrl_mac_arprot),
    .axi_s_ctrl_mac_arvalid(axi_s_ctrl_mac_arvalid),
    .axi_s_ctrl_mac_arready(axi_s_ctrl_mac_arready),
    .axi_s_ctrl_mac_rdata(axi_s_ctrl_mac_rdata),
    .axi_s_ctrl_mac_rresp(axi_s_ctrl_mac_rresp),
    .axi_s_ctrl_mac_rvalid(axi_s_ctrl_mac_rvalid),
    .axi_s_ctrl_mac_rready(axi_s_ctrl_mac_rready),
    .axis_in_mac_tdata(axis_in_mac_tdata),
    .axis_in_mac_tvalid(axis_in_mac_tvalid),
    .axis_in_mac_tready(axis_in_mac_tready),
    .axis_in_mac_tlast(axis_in_mac_tlast)
  );


  xored
  xor_inst
  (
    .CLK(CLK),
    .RST(RST),
    .axi_s_ctrl_xored_awaddr(axi_s_ctrl_xor_awaddr),
    .axi_s_ctrl_xored_awcache(axi_s_ctrl_xor_awcache),
    .axi_s_ctrl_xored_awprot(axi_s_ctrl_xor_awprot),
    .axi_s_ctrl_xored_awvalid(axi_s_ctrl_xor_awvalid),
    .axi_s_ctrl_xored_awready(axi_s_ctrl_xor_awready),
    .axi_s_ctrl_xored_wdata(axi_s_ctrl_xor_wdata),
    .axi_s_ctrl_xored_wstrb(axi_s_ctrl_xor_wstrb),
    .axi_s_ctrl_xored_wvalid(axi_s_ctrl_xor_wvalid),
    .axi_s_ctrl_xored_wready(axi_s_ctrl_xor_wready),
    .axi_s_ctrl_xored_bresp(axi_s_ctrl_xor_bresp),
    .axi_s_ctrl_xored_bvalid(axi_s_ctrl_xor_bvalid),
    .axi_s_ctrl_xored_bready(axi_s_ctrl_xor_bready),
    .axi_s_ctrl_xored_araddr(axi_s_ctrl_xor_araddr),
    .axi_s_ctrl_xored_arcache(axi_s_ctrl_xor_arcache),
    .axi_s_ctrl_xored_arprot(axi_s_ctrl_xor_arprot),
    .axi_s_ctrl_xored_arvalid(axi_s_ctrl_xor_arvalid),
    .axi_s_ctrl_xored_arready(axi_s_ctrl_xor_arready),
    .axi_s_ctrl_xored_rdata(axi_s_ctrl_xor_rdata),
    .axi_s_ctrl_xored_rresp(axi_s_ctrl_xor_rresp),
    .axi_s_ctrl_xored_rvalid(axi_s_ctrl_xor_rvalid),
    .axi_s_ctrl_xored_rready(axi_s_ctrl_xor_rready),
    .axis_in_aes_tdata(axis_in_aes_tdata),
    .axis_in_aes_tvalid(axis_in_aes_tvalid),
    .axis_in_aes_tready(axis_in_aes_tready),
    .axis_in_aes_tlast(axis_in_aes_tlast),
    .axis_in_xordata_tdata(axis_in_xordata_tdata),
    .axis_in_xordata_tvalid(axis_in_xordata_tvalid),
    .axis_in_xordata_tready(axis_in_xordata_tready),
    .axis_in_xordata_tlast(axis_in_xordata_tlast),
    .axis_out_xoreddata_tdata(axis_out_xoreddata_tdata),
    .axis_out_xoreddata_tvalid(axis_out_xoreddata_tvalid),
    .axis_out_xoreddata_tready(axis_out_xoreddata_tready),
    .axis_out_xoreddata_tlast(axis_out_xoreddata_tlast)
  );


  aes
  aes_inst
  (
    .CLK(CLK),
    .RST(RST),
    .axi_s_ctrl_aes_awaddr(axi_s_ctrl_aes_awaddr),
    .axi_s_ctrl_aes_awcache(axi_s_ctrl_aes_awcache),
    .axi_s_ctrl_aes_awprot(axi_s_ctrl_aes_awprot),
    .axi_s_ctrl_aes_awvalid(axi_s_ctrl_aes_awvalid),
    .axi_s_ctrl_aes_awready(axi_s_ctrl_aes_awready),
    .axi_s_ctrl_aes_wdata(axi_s_ctrl_aes_wdata),
    .axi_s_ctrl_aes_wstrb(axi_s_ctrl_aes_wstrb),
    .axi_s_ctrl_aes_wvalid(axi_s_ctrl_aes_wvalid),
    .axi_s_ctrl_aes_wready(axi_s_ctrl_aes_wready),
    .axi_s_ctrl_aes_bresp(axi_s_ctrl_aes_bresp),
    .axi_s_ctrl_aes_bvalid(axi_s_ctrl_aes_bvalid),
    .axi_s_ctrl_aes_bready(axi_s_ctrl_aes_bready),
    .axi_s_ctrl_aes_araddr(axi_s_ctrl_aes_araddr),
    .axi_s_ctrl_aes_arcache(axi_s_ctrl_aes_arcache),
    .axi_s_ctrl_aes_arprot(axi_s_ctrl_aes_arprot),
    .axi_s_ctrl_aes_arvalid(axi_s_ctrl_aes_arvalid),
    .axi_s_ctrl_aes_arready(axi_s_ctrl_aes_arready),
    .axi_s_ctrl_aes_rdata(axi_s_ctrl_aes_rdata),
    .axi_s_ctrl_aes_rresp(axi_s_ctrl_aes_rresp),
    .axi_s_ctrl_aes_rvalid(axi_s_ctrl_aes_rvalid),
    .axi_s_ctrl_aes_rready(axi_s_ctrl_aes_rready),
    .axis_out_aes_tdata(axis_in_aes_tdata),
    .axis_out_aes_tvalid(axis_in_aes_tvalid),
    .axis_out_aes_tready(axis_in_aes_tready),
    .axis_out_aes_tlast(axis_in_aes_tlast)
  );


  axim
  axim_inst
  (
    .CLK(CLK),
    .RST(RST),
    .axi_s_ctrl_axim_awaddr(axi_s_ctrl_axim_awaddr),
    .axi_s_ctrl_axim_awcache(axi_s_ctrl_axim_awcache),
    .axi_s_ctrl_axim_awprot(axi_s_ctrl_axim_awprot),
    .axi_s_ctrl_axim_awvalid(axi_s_ctrl_axim_awvalid),
    .axi_s_ctrl_axim_awready(axi_s_ctrl_axim_awready),
    .axi_s_ctrl_axim_wdata(axi_s_ctrl_axim_wdata),
    .axi_s_ctrl_axim_wstrb(axi_s_ctrl_axim_wstrb),
    .axi_s_ctrl_axim_wvalid(axi_s_ctrl_axim_wvalid),
    .axi_s_ctrl_axim_wready(axi_s_ctrl_axim_wready),
    .axi_s_ctrl_axim_bresp(axi_s_ctrl_axim_bresp),
    .axi_s_ctrl_axim_bvalid(axi_s_ctrl_axim_bvalid),
    .axi_s_ctrl_axim_bready(axi_s_ctrl_axim_bready),
    .axi_s_ctrl_axim_araddr(axi_s_ctrl_axim_araddr),
    .axi_s_ctrl_axim_arcache(axi_s_ctrl_axim_arcache),
    .axi_s_ctrl_axim_arprot(axi_s_ctrl_axim_arprot),
    .axi_s_ctrl_axim_arvalid(axi_s_ctrl_axim_arvalid),
    .axi_s_ctrl_axim_arready(axi_s_ctrl_axim_arready),
    .axi_s_ctrl_axim_rdata(axi_s_ctrl_axim_rdata),
    .axi_s_ctrl_axim_rresp(axi_s_ctrl_axim_rresp),
    .axi_s_ctrl_axim_rvalid(axi_s_ctrl_axim_rvalid),
    .axi_s_ctrl_axim_rready(axi_s_ctrl_axim_rready),
    .axis_out_axim_tdata(axis_out_axim_tdata),
    .axis_out_axim_tvalid(axis_out_axim_tvalid),
    .axis_out_axim_tready(axis_out_axim_tready),
    .axis_out_axim_tlast(axis_out_axim_tlast),
    .axis_in_axim_tdata(axis_in_axim_tdata),
    .axis_in_axim_tvalid(axis_in_axim_tvalid),
    .axis_in_axim_tready(axis_in_axim_tready),
    .axis_in_axim_tlast(axis_in_axim_tlast),
    .axi_s_llc_awaddr(axi_s_llc_awaddr),
    .axi_s_llc_awlen(axi_s_llc_awlen),
    .axi_s_llc_awsize(axi_s_llc_awsize),
    .axi_s_llc_awburst(axi_s_llc_awburst),
    .axi_s_llc_awlock(axi_s_llc_awlock),
    .axi_s_llc_awcache(axi_s_llc_awcache),
    .axi_s_llc_awprot(axi_s_llc_awprot),
    .axi_s_llc_awqos(axi_s_llc_awqos),
    .axi_s_llc_awuser(axi_s_llc_awuser),
    .axi_s_llc_awvalid(axi_s_llc_awvalid),
    .axi_s_llc_awready(axi_s_llc_awready),
    .axi_s_llc_wdata(axi_s_llc_wdata),
    .axi_s_llc_wstrb(axi_s_llc_wstrb),
    .axi_s_llc_wlast(axi_s_llc_wlast),
    .axi_s_llc_wvalid(axi_s_llc_wvalid),
    .axi_s_llc_wready(axi_s_llc_wready),
    .axi_s_llc_bresp(axi_s_llc_bresp),
    .axi_s_llc_bvalid(axi_s_llc_bvalid),
    .axi_s_llc_bready(axi_s_llc_bready),
    .axi_s_llc_araddr(axi_s_llc_araddr),
    .axi_s_llc_arlen(axi_s_llc_arlen),
    .axi_s_llc_arsize(axi_s_llc_arsize),
    .axi_s_llc_arburst(axi_s_llc_arburst),
    .axi_s_llc_arlock(axi_s_llc_arlock),
    .axi_s_llc_arcache(axi_s_llc_arcache),
    .axi_s_llc_arprot(axi_s_llc_arprot),
    .axi_s_llc_arqos(axi_s_llc_arqos),
    .axi_s_llc_aruser(axi_s_llc_aruser),
    .axi_s_llc_arvalid(axi_s_llc_arvalid),
    .axi_s_llc_arready(axi_s_llc_arready),
    .axi_s_llc_rdata(axi_s_llc_rdata),
    .axi_s_llc_rresp(axi_s_llc_rresp),
    .axi_s_llc_rlast(axi_s_llc_rlast),
    .axi_s_llc_rvalid(axi_s_llc_rvalid),
    .axi_s_llc_rready(axi_s_llc_rready)
  );


  ram_wrapper
  inst_wrapper
  (
    .CLK(CLK),
    .RST(RST),
    .axi_s_spm_data_awaddr(axi_s_spm_data_awaddr),
    .axi_s_spm_data_awcache(axi_s_spm_data_awcache),
    .axi_s_spm_data_awprot(axi_s_spm_data_awprot),
    .axi_s_spm_data_awvalid(axi_s_spm_data_awvalid),
    .axi_s_spm_data_awready(axi_s_spm_data_awready),
    .axi_s_spm_data_wdata(axi_s_spm_data_wdata),
    .axi_s_spm_data_wstrb(axi_s_spm_data_wstrb),
    .axi_s_spm_data_wvalid(axi_s_spm_data_wvalid),
    .axi_s_spm_data_wready(axi_s_spm_data_wready),
    .axi_s_spm_data_bresp(axi_s_spm_data_bresp),
    .axi_s_spm_data_bvalid(axi_s_spm_data_bvalid),
    .axi_s_spm_data_bready(axi_s_spm_data_bready),
    .axi_s_spm_data_araddr(axi_s_spm_data_araddr),
    .axi_s_spm_data_arcache(axi_s_spm_data_arcache),
    .axi_s_spm_data_arprot(axi_s_spm_data_arprot),
    .axi_s_spm_data_arvalid(axi_s_spm_data_arvalid),
    .axi_s_spm_data_arready(axi_s_spm_data_arready),
    .axi_s_spm_data_rdata(axi_s_spm_data_rdata),
    .axi_s_spm_data_rresp(axi_s_spm_data_rresp),
    .axi_s_spm_data_rvalid(axi_s_spm_data_rvalid),
    .axi_s_spm_data_rready(axi_s_spm_data_rready),
    .ram_spm_1_wdata(ram_spm_1_wdata),
    .ram_spm_1_rdata(ram_spm_1_rdata),
    .ram_spm_1_addr(ram_spm_1_addr),
    .ram_spm_1_wenable(ram_spm_1_wenable),
    .ram_spm_1_enable(ram_spm_1_enable)
  );


endmodule



module ram_wrapper
(
  input CLK,
  input RST,
  input [32-1:0] axi_s_spm_data_awaddr,
  input [4-1:0] axi_s_spm_data_awcache,
  input [3-1:0] axi_s_spm_data_awprot,
  input axi_s_spm_data_awvalid,
  output axi_s_spm_data_awready,
  input [64-1:0] axi_s_spm_data_wdata,
  input [8-1:0] axi_s_spm_data_wstrb,
  input axi_s_spm_data_wvalid,
  output axi_s_spm_data_wready,
  output [2-1:0] axi_s_spm_data_bresp,
  output reg axi_s_spm_data_bvalid,
  input axi_s_spm_data_bready,
  input [32-1:0] axi_s_spm_data_araddr,
  input [4-1:0] axi_s_spm_data_arcache,
  input [3-1:0] axi_s_spm_data_arprot,
  input axi_s_spm_data_arvalid,
  output axi_s_spm_data_arready,
  output reg [64-1:0] axi_s_spm_data_rdata,
  output [2-1:0] axi_s_spm_data_rresp,
  output reg axi_s_spm_data_rvalid,
  input axi_s_spm_data_rready,
  output reg [64-1:0] ram_spm_1_wdata,
  input [64-1:0] ram_spm_1_rdata,
  output reg [64-1:0] ram_spm_1_addr,
  output reg [1-1:0] ram_spm_1_wenable,
  output reg [1-1:0] ram_spm_1_enable
);

  assign axi_s_spm_data_bresp = 0;
  assign axi_s_spm_data_rresp = 0;
  reg [64-1:0] rdata_reg;
  reg [32-1:0] fsm;
  localparam fsm_init = 0;
  reg [32-1:0] addr_0;
  reg writevalid_1;
  reg readvalid_2;
  reg prev_awvalid_3;
  reg prev_arvalid_4;
  assign axi_s_spm_data_awready = (fsm == 1) && (!writevalid_1 && !readvalid_2 && !axi_s_spm_data_bvalid && prev_awvalid_3);
  assign axi_s_spm_data_arready = (fsm == 1) && (!readvalid_2 && !writevalid_1 && prev_arvalid_4 && !prev_awvalid_3);
  reg _axi_s_spm_data_rdata_cond_0_1;
  assign axi_s_spm_data_wready = fsm == 200;

  always @(posedge CLK) begin
    if(RST) begin
      axi_s_spm_data_rdata <= 0;
      axi_s_spm_data_rvalid <= 0;
      _axi_s_spm_data_rdata_cond_0_1 <= 0;
    end else begin
      if(_axi_s_spm_data_rdata_cond_0_1) begin
        axi_s_spm_data_rvalid <= 0;
      end 
      if((fsm == 102) && (axi_s_spm_data_rready || !axi_s_spm_data_rvalid)) begin
        axi_s_spm_data_rdata <= rdata_reg;
        axi_s_spm_data_rvalid <= 1;
      end 
      _axi_s_spm_data_rdata_cond_0_1 <= 1;
      if(axi_s_spm_data_rvalid && !axi_s_spm_data_rready) begin
        axi_s_spm_data_rvalid <= axi_s_spm_data_rvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_spm_data_bvalid <= 0;
      prev_awvalid_3 <= 0;
      prev_arvalid_4 <= 0;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      addr_0 <= 0;
    end else begin
      if(axi_s_spm_data_bvalid && axi_s_spm_data_bready) begin
        axi_s_spm_data_bvalid <= 0;
      end 
      if(axi_s_spm_data_wvalid && axi_s_spm_data_wready) begin
        axi_s_spm_data_bvalid <= 1;
      end 
      prev_awvalid_3 <= axi_s_spm_data_awvalid;
      prev_arvalid_4 <= axi_s_spm_data_arvalid;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      if(axi_s_spm_data_awready && axi_s_spm_data_awvalid && !axi_s_spm_data_bvalid) begin
        addr_0 <= axi_s_spm_data_awaddr;
        writevalid_1 <= 1;
      end else if(axi_s_spm_data_arready && axi_s_spm_data_arvalid) begin
        addr_0 <= axi_s_spm_data_araddr;
        readvalid_2 <= 1;
      end 
    end
  end

  localparam fsm_1 = 1;
  localparam fsm_100 = 100;
  localparam fsm_101 = 101;
  localparam fsm_102 = 102;
  localparam fsm_200 = 200;
  localparam fsm_201 = 201;

  always @(posedge CLK) begin
    if(RST) begin
      fsm <= fsm_init;
      ram_spm_1_addr <= 0;
      ram_spm_1_wenable <= 0;
      ram_spm_1_enable <= 0;
      rdata_reg <= 0;
      ram_spm_1_wdata <= 0;
    end else begin
      case(fsm)
        fsm_init: begin
          fsm <= fsm_1;
        end
        fsm_1: begin
          ram_spm_1_addr <= addr_0 / 8;
          if(readvalid_2) begin
            ram_spm_1_wenable <= 0;
            ram_spm_1_enable <= 1;
          end 
          if(readvalid_2) begin
            fsm <= fsm_100;
          end 
          if(writevalid_1) begin
            fsm <= fsm_200;
          end 
        end
        fsm_100: begin
          ram_spm_1_enable <= 0;
          ram_spm_1_wenable <= 0;
          ram_spm_1_addr <= 0;
          fsm <= fsm_101;
        end
        fsm_101: begin
          rdata_reg <= ram_spm_1_rdata;
          fsm <= fsm_102;
        end
        fsm_102: begin
          if(axi_s_spm_data_rready || !axi_s_spm_data_rvalid) begin
            fsm <= fsm_init;
          end 
        end
        fsm_200: begin
          ram_spm_1_wdata <= axi_s_spm_data_wdata;
          ram_spm_1_wenable <= 1;
          ram_spm_1_enable <= 1;
          if(axi_s_spm_data_wvalid) begin
            fsm <= fsm_201;
          end 
        end
        fsm_201: begin
          ram_spm_1_wenable <= 0;
          ram_spm_1_enable <= 0;
          ram_spm_1_wdata <= 0;
          ram_spm_1_addr <= 0;
          fsm <= fsm_init;
        end
      endcase
    end
  end


endmodule

