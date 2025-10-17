

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
  output reg axi_s_ctrl_spm_bvalid,
  input axi_s_ctrl_spm_bready,
  input [32-1:0] axi_s_ctrl_spm_araddr,
  input [4-1:0] axi_s_ctrl_spm_arcache,
  input [3-1:0] axi_s_ctrl_spm_arprot,
  input axi_s_ctrl_spm_arvalid,
  output axi_s_ctrl_spm_arready,
  output reg [64-1:0] axi_s_ctrl_spm_rdata,
  output [2-1:0] axi_s_ctrl_spm_rresp,
  output reg axi_s_ctrl_spm_rvalid,
  input axi_s_ctrl_spm_rready,
  output reg [4-1:0] axi_m_dram_awid,
  output reg [32-1:0] axi_m_dram_awaddr,
  output reg [8-1:0] axi_m_dram_awlen,
  output [3-1:0] axi_m_dram_awsize,
  output [2-1:0] axi_m_dram_awburst,
  output [1-1:0] axi_m_dram_awlock,
  output [4-1:0] axi_m_dram_awcache,
  output [3-1:0] axi_m_dram_awprot,
  output [4-1:0] axi_m_dram_awqos,
  output [2-1:0] axi_m_dram_awuser,
  output reg axi_m_dram_awvalid,
  input axi_m_dram_awready,
  output [128-1:0] axi_m_dram_wdata,
  output [16-1:0] axi_m_dram_wstrb,
  output axi_m_dram_wlast,
  output axi_m_dram_wvalid,
  input axi_m_dram_wready,
  input [4-1:0] axi_m_dram_bid,
  input [2-1:0] axi_m_dram_bresp,
  input axi_m_dram_bvalid,
  output axi_m_dram_bready,
  output reg [4-1:0] axi_m_dram_arid,
  output reg [32-1:0] axi_m_dram_araddr,
  output reg [8-1:0] axi_m_dram_arlen,
  output [3-1:0] axi_m_dram_arsize,
  output [2-1:0] axi_m_dram_arburst,
  output [1-1:0] axi_m_dram_arlock,
  output [4-1:0] axi_m_dram_arcache,
  output [3-1:0] axi_m_dram_arprot,
  output [4-1:0] axi_m_dram_arqos,
  output [2-1:0] axi_m_dram_aruser,
  output reg axi_m_dram_arvalid,
  input axi_m_dram_arready,
  input [4-1:0] axi_m_dram_rid,
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
  output reg axi_s_ctrl_mac_bvalid,
  input axi_s_ctrl_mac_bready,
  input [32-1:0] axi_s_ctrl_mac_araddr,
  input [4-1:0] axi_s_ctrl_mac_arcache,
  input [3-1:0] axi_s_ctrl_mac_arprot,
  input axi_s_ctrl_mac_arvalid,
  output axi_s_ctrl_mac_arready,
  output reg [64-1:0] axi_s_ctrl_mac_rdata,
  output [2-1:0] axi_s_ctrl_mac_rresp,
  output reg axi_s_ctrl_mac_rvalid,
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
  output reg axi_s_ctrl_xor_bvalid,
  input axi_s_ctrl_xor_bready,
  input [32-1:0] axi_s_ctrl_xor_araddr,
  input [4-1:0] axi_s_ctrl_xor_arcache,
  input [3-1:0] axi_s_ctrl_xor_arprot,
  input axi_s_ctrl_xor_arvalid,
  output axi_s_ctrl_xor_arready,
  output reg [64-1:0] axi_s_ctrl_xor_rdata,
  output [2-1:0] axi_s_ctrl_xor_rresp,
  output reg axi_s_ctrl_xor_rvalid,
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
  output reg axi_s_ctrl_aes_bvalid,
  input axi_s_ctrl_aes_bready,
  input [32-1:0] axi_s_ctrl_aes_araddr,
  input [4-1:0] axi_s_ctrl_aes_arcache,
  input [3-1:0] axi_s_ctrl_aes_arprot,
  input axi_s_ctrl_aes_arvalid,
  output axi_s_ctrl_aes_arready,
  output reg [64-1:0] axi_s_ctrl_aes_rdata,
  output [2-1:0] axi_s_ctrl_aes_rresp,
  output reg axi_s_ctrl_aes_rvalid,
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
  output reg axi_s_ctrl_axim_bvalid,
  input axi_s_ctrl_axim_bready,
  input [32-1:0] axi_s_ctrl_axim_araddr,
  input [4-1:0] axi_s_ctrl_axim_arcache,
  input [3-1:0] axi_s_ctrl_axim_arprot,
  input axi_s_ctrl_axim_arvalid,
  output axi_s_ctrl_axim_arready,
  output reg [64-1:0] axi_s_ctrl_axim_rdata,
  output [2-1:0] axi_s_ctrl_axim_rresp,
  output reg axi_s_ctrl_axim_rvalid,
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
  output reg axi_s_llc_bvalid,
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
  output reg [128-1:0] axi_s_llc_rdata,
  output [2-1:0] axi_s_llc_rresp,
  output reg axi_s_llc_rlast,
  output reg axi_s_llc_rvalid,
  input axi_s_llc_rready,
  input [32-1:0] axi_s_ctrl_memreq_awaddr,
  input [4-1:0] axi_s_ctrl_memreq_awcache,
  input [3-1:0] axi_s_ctrl_memreq_awprot,
  input axi_s_ctrl_memreq_awvalid,
  output axi_s_ctrl_memreq_awready,
  input [64-1:0] axi_s_ctrl_memreq_wdata,
  input [8-1:0] axi_s_ctrl_memreq_wstrb,
  input axi_s_ctrl_memreq_wvalid,
  output axi_s_ctrl_memreq_wready,
  output [2-1:0] axi_s_ctrl_memreq_bresp,
  output reg axi_s_ctrl_memreq_bvalid,
  input axi_s_ctrl_memreq_bready,
  input [32-1:0] axi_s_ctrl_memreq_araddr,
  input [4-1:0] axi_s_ctrl_memreq_arcache,
  input [3-1:0] axi_s_ctrl_memreq_arprot,
  input axi_s_ctrl_memreq_arvalid,
  output axi_s_ctrl_memreq_arready,
  output reg [64-1:0] axi_s_ctrl_memreq_rdata,
  output [2-1:0] axi_s_ctrl_memreq_rresp,
  output reg axi_s_ctrl_memreq_rvalid,
  input axi_s_ctrl_memreq_rready
);

  assign axi_s_ctrl_spm_bresp = 0;
  assign axi_s_ctrl_spm_rresp = 0;
  reg signed [64-1:0] _axi_s_ctrl_spm_register_0;
  reg signed [64-1:0] _axi_s_ctrl_spm_register_1;
  reg signed [64-1:0] _axi_s_ctrl_spm_register_2;
  reg signed [64-1:0] _axi_s_ctrl_spm_register_3;
  reg signed [64-1:0] _axi_s_ctrl_spm_register_4;
  reg signed [64-1:0] _axi_s_ctrl_spm_register_5;
  reg signed [64-1:0] _axi_s_ctrl_spm_register_6;
  reg _axi_s_ctrl_spm_flag_0;
  reg _axi_s_ctrl_spm_flag_1;
  reg _axi_s_ctrl_spm_flag_2;
  reg _axi_s_ctrl_spm_flag_3;
  reg _axi_s_ctrl_spm_flag_4;
  reg _axi_s_ctrl_spm_flag_5;
  reg _axi_s_ctrl_spm_flag_6;
  reg signed [64-1:0] _axi_s_ctrl_spm_resetval_0;
  reg signed [64-1:0] _axi_s_ctrl_spm_resetval_1;
  reg signed [64-1:0] _axi_s_ctrl_spm_resetval_2;
  reg signed [64-1:0] _axi_s_ctrl_spm_resetval_3;
  reg signed [64-1:0] _axi_s_ctrl_spm_resetval_4;
  reg signed [64-1:0] _axi_s_ctrl_spm_resetval_5;
  reg signed [64-1:0] _axi_s_ctrl_spm_resetval_6;
  localparam _axi_s_ctrl_spm_maskwidth = 3;
  localparam _axi_s_ctrl_spm_mask = { _axi_s_ctrl_spm_maskwidth{ 1'd1 } };
  localparam _axi_s_ctrl_spm_shift = 3;
  reg [32-1:0] _axi_s_ctrl_spm_register_fsm;
  localparam _axi_s_ctrl_spm_register_fsm_init = 0;
  reg [32-1:0] addr_0;
  reg writevalid_1;
  reg readvalid_2;
  reg prev_awvalid_3;
  reg prev_arvalid_4;
  assign axi_s_ctrl_spm_awready = (_axi_s_ctrl_spm_register_fsm == 0) && (!writevalid_1 && !readvalid_2 && !axi_s_ctrl_spm_bvalid && prev_awvalid_3);
  assign axi_s_ctrl_spm_arready = (_axi_s_ctrl_spm_register_fsm == 0) && (!readvalid_2 && !writevalid_1 && prev_arvalid_4 && !prev_awvalid_3);
  reg [_axi_s_ctrl_spm_maskwidth-1:0] axis_maskaddr_5;
  wire signed [64-1:0] axislite_rdata_6;
  assign axislite_rdata_6 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_spm_register_0 : 
                            (axis_maskaddr_5 == 1)? _axi_s_ctrl_spm_register_1 : 
                            (axis_maskaddr_5 == 2)? _axi_s_ctrl_spm_register_2 : 
                            (axis_maskaddr_5 == 3)? _axi_s_ctrl_spm_register_3 : 
                            (axis_maskaddr_5 == 4)? _axi_s_ctrl_spm_register_4 : 
                            (axis_maskaddr_5 == 5)? _axi_s_ctrl_spm_register_5 : 
                            (axis_maskaddr_5 == 6)? _axi_s_ctrl_spm_register_6 : 'hx;
  wire axislite_flag_7;
  assign axislite_flag_7 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_spm_flag_0 : 
                           (axis_maskaddr_5 == 1)? _axi_s_ctrl_spm_flag_1 : 
                           (axis_maskaddr_5 == 2)? _axi_s_ctrl_spm_flag_2 : 
                           (axis_maskaddr_5 == 3)? _axi_s_ctrl_spm_flag_3 : 
                           (axis_maskaddr_5 == 4)? _axi_s_ctrl_spm_flag_4 : 
                           (axis_maskaddr_5 == 5)? _axi_s_ctrl_spm_flag_5 : 
                           (axis_maskaddr_5 == 6)? _axi_s_ctrl_spm_flag_6 : 'hx;
  wire signed [64-1:0] axislite_resetval_8;
  assign axislite_resetval_8 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_spm_resetval_0 : 
                               (axis_maskaddr_5 == 1)? _axi_s_ctrl_spm_resetval_1 : 
                               (axis_maskaddr_5 == 2)? _axi_s_ctrl_spm_resetval_2 : 
                               (axis_maskaddr_5 == 3)? _axi_s_ctrl_spm_resetval_3 : 
                               (axis_maskaddr_5 == 4)? _axi_s_ctrl_spm_resetval_4 : 
                               (axis_maskaddr_5 == 5)? _axi_s_ctrl_spm_resetval_5 : 
                               (axis_maskaddr_5 == 6)? _axi_s_ctrl_spm_resetval_6 : 'hx;
  reg _axi_s_ctrl_spm_rdata_cond_0_1;
  assign axi_s_ctrl_spm_wready = _axi_s_ctrl_spm_register_fsm == 3;
  assign axi_m_dram_awsize = 4;
  assign axi_m_dram_awburst = 1;
  assign axi_m_dram_awlock = 0;
  assign axi_m_dram_awcache = 3;
  assign axi_m_dram_awprot = 0;
  assign axi_m_dram_awqos = 0;
  assign axi_m_dram_awuser = 0;
  reg [128-1:0] _axi_m_dram_wdata_sb_0;
  reg [16-1:0] _axi_m_dram_wstrb_sb_0;
  reg _axi_m_dram_wlast_sb_0;
  reg _axi_m_dram_wvalid_sb_0;
  wire _axi_m_dram_wready_sb_0;
  wire _sb_axi_m_dram_writedata_s_value_9;
  assign _sb_axi_m_dram_writedata_s_value_9 = _axi_m_dram_wlast_sb_0;
  wire [16-1:0] _sb_axi_m_dram_writedata_s_value_10;
  assign _sb_axi_m_dram_writedata_s_value_10 = _axi_m_dram_wstrb_sb_0;
  wire [128-1:0] _sb_axi_m_dram_writedata_s_value_11;
  assign _sb_axi_m_dram_writedata_s_value_11 = _axi_m_dram_wdata_sb_0;
  wire [145-1:0] _sb_axi_m_dram_writedata_s_data_12;
  assign _sb_axi_m_dram_writedata_s_data_12 = { _sb_axi_m_dram_writedata_s_value_9, _sb_axi_m_dram_writedata_s_value_10, _sb_axi_m_dram_writedata_s_value_11 };
  wire _sb_axi_m_dram_writedata_s_valid_13;
  assign _sb_axi_m_dram_writedata_s_valid_13 = _axi_m_dram_wvalid_sb_0;
  wire _sb_axi_m_dram_writedata_m_ready_14;
  assign _sb_axi_m_dram_writedata_m_ready_14 = axi_m_dram_wready;
  reg [145-1:0] _sb_axi_m_dram_writedata_data_15;
  reg _sb_axi_m_dram_writedata_valid_16;
  wire _sb_axi_m_dram_writedata_ready_17;
  reg [145-1:0] _sb_axi_m_dram_writedata_tmp_data_18;
  reg _sb_axi_m_dram_writedata_tmp_valid_19;
  wire [145-1:0] _sb_axi_m_dram_writedata_next_data_20;
  wire _sb_axi_m_dram_writedata_next_valid_21;
  assign _sb_axi_m_dram_writedata_ready_17 = !_sb_axi_m_dram_writedata_tmp_valid_19;
  assign _sb_axi_m_dram_writedata_next_data_20 = (_sb_axi_m_dram_writedata_tmp_valid_19)? _sb_axi_m_dram_writedata_tmp_data_18 : _sb_axi_m_dram_writedata_s_data_12;
  assign _sb_axi_m_dram_writedata_next_valid_21 = _sb_axi_m_dram_writedata_tmp_valid_19 || _sb_axi_m_dram_writedata_s_valid_13;
  wire _sb_axi_m_dram_writedata_m_value_22;
  assign _sb_axi_m_dram_writedata_m_value_22 = _sb_axi_m_dram_writedata_data_15[144:144];
  wire [16-1:0] _sb_axi_m_dram_writedata_m_value_23;
  assign _sb_axi_m_dram_writedata_m_value_23 = _sb_axi_m_dram_writedata_data_15[143:128];
  wire [128-1:0] _sb_axi_m_dram_writedata_m_value_24;
  assign _sb_axi_m_dram_writedata_m_value_24 = _sb_axi_m_dram_writedata_data_15[127:0];
  assign _axi_m_dram_wready_sb_0 = _sb_axi_m_dram_writedata_ready_17;
  assign axi_m_dram_wdata = _sb_axi_m_dram_writedata_m_value_24;
  assign axi_m_dram_wstrb = _sb_axi_m_dram_writedata_m_value_23;
  assign axi_m_dram_wlast = _sb_axi_m_dram_writedata_m_value_22;
  assign axi_m_dram_wvalid = _sb_axi_m_dram_writedata_valid_16;
  assign axi_m_dram_bready = 1;
  assign axi_m_dram_arsize = 4;
  assign axi_m_dram_arburst = 1;
  assign axi_m_dram_arlock = 0;
  assign axi_m_dram_arcache = 3;
  assign axi_m_dram_arprot = 0;
  assign axi_m_dram_arqos = 0;
  assign axi_m_dram_aruser = 0;
  wire [128-1:0] _axi_m_dram_rdata_sb_0;
  wire _axi_m_dram_rlast_sb_0;
  wire _axi_m_dram_rvalid_sb_0;
  wire _axi_m_dram_rready_sb_0;
  wire _sb_axi_m_dram_readdata_s_value_25;
  assign _sb_axi_m_dram_readdata_s_value_25 = axi_m_dram_rlast;
  wire [128-1:0] _sb_axi_m_dram_readdata_s_value_26;
  assign _sb_axi_m_dram_readdata_s_value_26 = axi_m_dram_rdata;
  wire [129-1:0] _sb_axi_m_dram_readdata_s_data_27;
  assign _sb_axi_m_dram_readdata_s_data_27 = { _sb_axi_m_dram_readdata_s_value_25, _sb_axi_m_dram_readdata_s_value_26 };
  wire _sb_axi_m_dram_readdata_s_valid_28;
  assign _sb_axi_m_dram_readdata_s_valid_28 = axi_m_dram_rvalid;
  wire _sb_axi_m_dram_readdata_m_ready_29;
  assign _sb_axi_m_dram_readdata_m_ready_29 = _axi_m_dram_rready_sb_0;
  reg [129-1:0] _sb_axi_m_dram_readdata_data_30;
  reg _sb_axi_m_dram_readdata_valid_31;
  wire _sb_axi_m_dram_readdata_ready_32;
  reg [129-1:0] _sb_axi_m_dram_readdata_tmp_data_33;
  reg _sb_axi_m_dram_readdata_tmp_valid_34;
  wire [129-1:0] _sb_axi_m_dram_readdata_next_data_35;
  wire _sb_axi_m_dram_readdata_next_valid_36;
  assign _sb_axi_m_dram_readdata_ready_32 = !_sb_axi_m_dram_readdata_tmp_valid_34;
  assign _sb_axi_m_dram_readdata_next_data_35 = (_sb_axi_m_dram_readdata_tmp_valid_34)? _sb_axi_m_dram_readdata_tmp_data_33 : _sb_axi_m_dram_readdata_s_data_27;
  assign _sb_axi_m_dram_readdata_next_valid_36 = _sb_axi_m_dram_readdata_tmp_valid_34 || _sb_axi_m_dram_readdata_s_valid_28;
  wire _sb_axi_m_dram_readdata_m_value_37;
  assign _sb_axi_m_dram_readdata_m_value_37 = _sb_axi_m_dram_readdata_data_30[128:128];
  wire [128-1:0] _sb_axi_m_dram_readdata_m_value_38;
  assign _sb_axi_m_dram_readdata_m_value_38 = _sb_axi_m_dram_readdata_data_30[127:0];
  assign _axi_m_dram_rdata_sb_0 = _sb_axi_m_dram_readdata_m_value_38;
  assign _axi_m_dram_rlast_sb_0 = _sb_axi_m_dram_readdata_m_value_37;
  assign _axi_m_dram_rvalid_sb_0 = _sb_axi_m_dram_readdata_valid_31;
  assign axi_m_dram_rready = _sb_axi_m_dram_readdata_ready_32;
  reg [3-1:0] _axi_m_dram_outstanding_wcount;
  wire _axi_m_dram_has_outstanding_write;
  assign _axi_m_dram_has_outstanding_write = (_axi_m_dram_outstanding_wcount > 0) || axi_m_dram_awvalid;
  reg _axi_m_dram_read_start;
  reg [8-1:0] _axi_m_dram_read_op_sel;
  reg [32-1:0] _axi_m_dram_read_global_addr;
  reg [33-1:0] _axi_m_dram_read_global_size;
  reg [32-1:0] _axi_m_dram_read_local_addr;
  reg [32-1:0] _axi_m_dram_read_local_stride;
  reg [33-1:0] _axi_m_dram_read_local_size;
  reg [32-1:0] _axi_m_dram_read_local_blocksize;
  wire _axi_m_dram_read_req_fifo_enq;
  wire [137-1:0] _axi_m_dram_read_req_fifo_wdata;
  wire _axi_m_dram_read_req_fifo_full;
  wire _axi_m_dram_read_req_fifo_almost_full;
  wire _axi_m_dram_read_req_fifo_deq;
  wire [137-1:0] _axi_m_dram_read_req_fifo_rdata;
  wire _axi_m_dram_read_req_fifo_empty;
  wire _axi_m_dram_read_req_fifo_almost_empty;
  assign _axi_m_dram_read_req_fifo_enq = 0;
  assign _axi_m_dram_read_req_fifo_wdata = 'hx;
  assign _axi_m_dram_read_req_fifo_deq = 0;

  _axi_m_dram_read_req_fifo
  inst__axi_m_dram_read_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axi_m_dram_read_req_fifo_enq(_axi_m_dram_read_req_fifo_enq),
    ._axi_m_dram_read_req_fifo_wdata(_axi_m_dram_read_req_fifo_wdata),
    ._axi_m_dram_read_req_fifo_full(_axi_m_dram_read_req_fifo_full),
    ._axi_m_dram_read_req_fifo_almost_full(_axi_m_dram_read_req_fifo_almost_full),
    ._axi_m_dram_read_req_fifo_deq(_axi_m_dram_read_req_fifo_deq),
    ._axi_m_dram_read_req_fifo_rdata(_axi_m_dram_read_req_fifo_rdata),
    ._axi_m_dram_read_req_fifo_empty(_axi_m_dram_read_req_fifo_empty),
    ._axi_m_dram_read_req_fifo_almost_empty(_axi_m_dram_read_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axi_m_dram_read_req_fifo;
  wire [8-1:0] _axi_m_dram_read_op_sel_fifo;
  wire [32-1:0] _axi_m_dram_read_local_addr_fifo;
  wire [32-1:0] _axi_m_dram_read_local_stride_fifo;
  wire [33-1:0] _axi_m_dram_read_local_size_fifo;
  wire [32-1:0] _axi_m_dram_read_local_blocksize_fifo;
  wire [8-1:0] unpack_read_req_op_sel_39;
  wire [32-1:0] unpack_read_req_local_addr_40;
  wire [32-1:0] unpack_read_req_local_stride_41;
  wire [33-1:0] unpack_read_req_local_size_42;
  wire [32-1:0] unpack_read_req_local_blocksize_43;
  assign unpack_read_req_op_sel_39 = _axi_m_dram_read_req_fifo_rdata[136:129];
  assign unpack_read_req_local_addr_40 = _axi_m_dram_read_req_fifo_rdata[128:97];
  assign unpack_read_req_local_stride_41 = _axi_m_dram_read_req_fifo_rdata[96:65];
  assign unpack_read_req_local_size_42 = _axi_m_dram_read_req_fifo_rdata[64:32];
  assign unpack_read_req_local_blocksize_43 = _axi_m_dram_read_req_fifo_rdata[31:0];
  assign _axi_m_dram_read_op_sel_fifo = unpack_read_req_op_sel_39;
  assign _axi_m_dram_read_local_addr_fifo = unpack_read_req_local_addr_40;
  assign _axi_m_dram_read_local_stride_fifo = unpack_read_req_local_stride_41;
  assign _axi_m_dram_read_local_size_fifo = unpack_read_req_local_size_42;
  assign _axi_m_dram_read_local_blocksize_fifo = unpack_read_req_local_blocksize_43;
  reg [8-1:0] _axi_m_dram_read_op_sel_buf;
  reg [32-1:0] _axi_m_dram_read_local_addr_buf;
  reg [32-1:0] _axi_m_dram_read_local_stride_buf;
  reg [33-1:0] _axi_m_dram_read_local_size_buf;
  reg [32-1:0] _axi_m_dram_read_local_blocksize_buf;
  reg _axi_m_dram_read_req_busy;
  reg _axi_m_dram_read_data_busy;
  wire _axi_m_dram_read_req_idle;
  wire _axi_m_dram_read_data_idle;
  wire _axi_m_dram_read_idle;
  assign _axi_m_dram_read_req_idle = !_axi_m_dram_read_start && !_axi_m_dram_read_req_busy;
  assign _axi_m_dram_read_data_idle = _axi_m_dram_read_req_fifo_empty && !_axi_m_dram_read_data_busy;
  assign _axi_m_dram_read_idle = _axi_m_dram_read_req_idle && _axi_m_dram_read_data_idle;
  reg _axi_m_dram_write_start;
  reg [8-1:0] _axi_m_dram_write_op_sel;
  reg [32-1:0] _axi_m_dram_write_global_addr;
  reg [33-1:0] _axi_m_dram_write_global_size;
  reg [32-1:0] _axi_m_dram_write_local_addr;
  reg [32-1:0] _axi_m_dram_write_local_stride;
  reg [33-1:0] _axi_m_dram_write_local_size;
  reg [32-1:0] _axi_m_dram_write_local_blocksize;
  wire _axi_m_dram_write_req_fifo_enq;
  wire [137-1:0] _axi_m_dram_write_req_fifo_wdata;
  wire _axi_m_dram_write_req_fifo_full;
  wire _axi_m_dram_write_req_fifo_almost_full;
  wire _axi_m_dram_write_req_fifo_deq;
  wire [137-1:0] _axi_m_dram_write_req_fifo_rdata;
  wire _axi_m_dram_write_req_fifo_empty;
  wire _axi_m_dram_write_req_fifo_almost_empty;
  assign _axi_m_dram_write_req_fifo_enq = 0;
  assign _axi_m_dram_write_req_fifo_wdata = 'hx;
  assign _axi_m_dram_write_req_fifo_deq = 0;

  _axi_m_dram_write_req_fifo
  inst__axi_m_dram_write_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axi_m_dram_write_req_fifo_enq(_axi_m_dram_write_req_fifo_enq),
    ._axi_m_dram_write_req_fifo_wdata(_axi_m_dram_write_req_fifo_wdata),
    ._axi_m_dram_write_req_fifo_full(_axi_m_dram_write_req_fifo_full),
    ._axi_m_dram_write_req_fifo_almost_full(_axi_m_dram_write_req_fifo_almost_full),
    ._axi_m_dram_write_req_fifo_deq(_axi_m_dram_write_req_fifo_deq),
    ._axi_m_dram_write_req_fifo_rdata(_axi_m_dram_write_req_fifo_rdata),
    ._axi_m_dram_write_req_fifo_empty(_axi_m_dram_write_req_fifo_empty),
    ._axi_m_dram_write_req_fifo_almost_empty(_axi_m_dram_write_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axi_m_dram_write_req_fifo;
  wire [8-1:0] _axi_m_dram_write_op_sel_fifo;
  wire [32-1:0] _axi_m_dram_write_local_addr_fifo;
  wire [32-1:0] _axi_m_dram_write_local_stride_fifo;
  wire [33-1:0] _axi_m_dram_write_size_fifo;
  wire [32-1:0] _axi_m_dram_write_local_blocksize_fifo;
  wire [8-1:0] unpack_write_req_op_sel_44;
  wire [32-1:0] unpack_write_req_local_addr_45;
  wire [32-1:0] unpack_write_req_local_stride_46;
  wire [33-1:0] unpack_write_req_size_47;
  wire [32-1:0] unpack_write_req_local_blocksize_48;
  assign unpack_write_req_op_sel_44 = _axi_m_dram_write_req_fifo_rdata[136:129];
  assign unpack_write_req_local_addr_45 = _axi_m_dram_write_req_fifo_rdata[128:97];
  assign unpack_write_req_local_stride_46 = _axi_m_dram_write_req_fifo_rdata[96:65];
  assign unpack_write_req_size_47 = _axi_m_dram_write_req_fifo_rdata[64:32];
  assign unpack_write_req_local_blocksize_48 = _axi_m_dram_write_req_fifo_rdata[31:0];
  assign _axi_m_dram_write_op_sel_fifo = unpack_write_req_op_sel_44;
  assign _axi_m_dram_write_local_addr_fifo = unpack_write_req_local_addr_45;
  assign _axi_m_dram_write_local_stride_fifo = unpack_write_req_local_stride_46;
  assign _axi_m_dram_write_size_fifo = unpack_write_req_size_47;
  assign _axi_m_dram_write_local_blocksize_fifo = unpack_write_req_local_blocksize_48;
  reg [8-1:0] _axi_m_dram_write_op_sel_buf;
  reg [32-1:0] _axi_m_dram_write_local_addr_buf;
  reg [32-1:0] _axi_m_dram_write_local_stride_buf;
  reg [33-1:0] _axi_m_dram_write_size_buf;
  reg [32-1:0] _axi_m_dram_write_local_blocksize_buf;
  reg _axi_m_dram_write_req_busy;
  reg _axi_m_dram_write_data_busy;
  wire _axi_m_dram_write_req_idle;
  wire _axi_m_dram_write_data_idle;
  wire _axi_m_dram_write_idle;
  assign _axi_m_dram_write_req_idle = !_axi_m_dram_write_start && !_axi_m_dram_write_req_busy;
  assign _axi_m_dram_write_data_idle = _axi_m_dram_write_req_fifo_empty && !_axi_m_dram_write_data_busy;
  assign _axi_m_dram_write_idle = _axi_m_dram_write_req_idle && _axi_m_dram_write_data_idle;
  assign axi_s_ctrl_mac_bresp = 0;
  assign axi_s_ctrl_mac_rresp = 0;
  reg signed [64-1:0] _axi_s_ctrl_mac_register_0;
  reg signed [64-1:0] _axi_s_ctrl_mac_register_1;
  reg signed [64-1:0] _axi_s_ctrl_mac_register_2;
  reg signed [64-1:0] _axi_s_ctrl_mac_register_3;
  reg signed [64-1:0] _axi_s_ctrl_mac_register_4;
  reg signed [64-1:0] _axi_s_ctrl_mac_register_5;
  reg signed [64-1:0] _axi_s_ctrl_mac_register_6;
  reg _axi_s_ctrl_mac_flag_0;
  reg _axi_s_ctrl_mac_flag_1;
  reg _axi_s_ctrl_mac_flag_2;
  reg _axi_s_ctrl_mac_flag_3;
  reg _axi_s_ctrl_mac_flag_4;
  reg _axi_s_ctrl_mac_flag_5;
  reg _axi_s_ctrl_mac_flag_6;
  reg signed [64-1:0] _axi_s_ctrl_mac_resetval_0;
  reg signed [64-1:0] _axi_s_ctrl_mac_resetval_1;
  reg signed [64-1:0] _axi_s_ctrl_mac_resetval_2;
  reg signed [64-1:0] _axi_s_ctrl_mac_resetval_3;
  reg signed [64-1:0] _axi_s_ctrl_mac_resetval_4;
  reg signed [64-1:0] _axi_s_ctrl_mac_resetval_5;
  reg signed [64-1:0] _axi_s_ctrl_mac_resetval_6;
  localparam _axi_s_ctrl_mac_maskwidth = 3;
  localparam _axi_s_ctrl_mac_mask = { _axi_s_ctrl_mac_maskwidth{ 1'd1 } };
  localparam _axi_s_ctrl_mac_shift = 3;
  reg [32-1:0] _axi_s_ctrl_mac_register_fsm;
  localparam _axi_s_ctrl_mac_register_fsm_init = 0;
  reg [32-1:0] addr_49;
  reg writevalid_50;
  reg readvalid_51;
  reg prev_awvalid_52;
  reg prev_arvalid_53;
  assign axi_s_ctrl_mac_awready = (_axi_s_ctrl_mac_register_fsm == 0) && (!writevalid_50 && !readvalid_51 && !axi_s_ctrl_mac_bvalid && prev_awvalid_52);
  assign axi_s_ctrl_mac_arready = (_axi_s_ctrl_mac_register_fsm == 0) && (!readvalid_51 && !writevalid_50 && prev_arvalid_53 && !prev_awvalid_52);
  reg [_axi_s_ctrl_mac_maskwidth-1:0] axis_maskaddr_54;
  wire signed [64-1:0] axislite_rdata_55;
  assign axislite_rdata_55 = (axis_maskaddr_54 == 0)? _axi_s_ctrl_mac_register_0 : 
                             (axis_maskaddr_54 == 1)? _axi_s_ctrl_mac_register_1 : 
                             (axis_maskaddr_54 == 2)? _axi_s_ctrl_mac_register_2 : 
                             (axis_maskaddr_54 == 3)? _axi_s_ctrl_mac_register_3 : 
                             (axis_maskaddr_54 == 4)? _axi_s_ctrl_mac_register_4 : 
                             (axis_maskaddr_54 == 5)? _axi_s_ctrl_mac_register_5 : 
                             (axis_maskaddr_54 == 6)? _axi_s_ctrl_mac_register_6 : 'hx;
  wire axislite_flag_56;
  assign axislite_flag_56 = (axis_maskaddr_54 == 0)? _axi_s_ctrl_mac_flag_0 : 
                            (axis_maskaddr_54 == 1)? _axi_s_ctrl_mac_flag_1 : 
                            (axis_maskaddr_54 == 2)? _axi_s_ctrl_mac_flag_2 : 
                            (axis_maskaddr_54 == 3)? _axi_s_ctrl_mac_flag_3 : 
                            (axis_maskaddr_54 == 4)? _axi_s_ctrl_mac_flag_4 : 
                            (axis_maskaddr_54 == 5)? _axi_s_ctrl_mac_flag_5 : 
                            (axis_maskaddr_54 == 6)? _axi_s_ctrl_mac_flag_6 : 'hx;
  wire signed [64-1:0] axislite_resetval_57;
  assign axislite_resetval_57 = (axis_maskaddr_54 == 0)? _axi_s_ctrl_mac_resetval_0 : 
                                (axis_maskaddr_54 == 1)? _axi_s_ctrl_mac_resetval_1 : 
                                (axis_maskaddr_54 == 2)? _axi_s_ctrl_mac_resetval_2 : 
                                (axis_maskaddr_54 == 3)? _axi_s_ctrl_mac_resetval_3 : 
                                (axis_maskaddr_54 == 4)? _axi_s_ctrl_mac_resetval_4 : 
                                (axis_maskaddr_54 == 5)? _axi_s_ctrl_mac_resetval_5 : 
                                (axis_maskaddr_54 == 6)? _axi_s_ctrl_mac_resetval_6 : 'hx;
  reg _axi_s_ctrl_mac_rdata_cond_0_1;
  assign axi_s_ctrl_mac_wready = _axi_s_ctrl_mac_register_fsm == 3;
  assign axi_s_ctrl_xor_bresp = 0;
  assign axi_s_ctrl_xor_rresp = 0;
  reg signed [64-1:0] _axi_s_ctrl_xor_register_0;
  reg signed [64-1:0] _axi_s_ctrl_xor_register_1;
  reg _axi_s_ctrl_xor_flag_0;
  reg _axi_s_ctrl_xor_flag_1;
  reg signed [64-1:0] _axi_s_ctrl_xor_resetval_0;
  reg signed [64-1:0] _axi_s_ctrl_xor_resetval_1;
  localparam _axi_s_ctrl_xor_maskwidth = 1;
  localparam _axi_s_ctrl_xor_mask = { _axi_s_ctrl_xor_maskwidth{ 1'd1 } };
  localparam _axi_s_ctrl_xor_shift = 3;
  reg [32-1:0] _axi_s_ctrl_xor_register_fsm;
  localparam _axi_s_ctrl_xor_register_fsm_init = 0;
  reg [32-1:0] addr_58;
  reg writevalid_59;
  reg readvalid_60;
  reg prev_awvalid_61;
  reg prev_arvalid_62;
  assign axi_s_ctrl_xor_awready = (_axi_s_ctrl_xor_register_fsm == 0) && (!writevalid_59 && !readvalid_60 && !axi_s_ctrl_xor_bvalid && prev_awvalid_61);
  assign axi_s_ctrl_xor_arready = (_axi_s_ctrl_xor_register_fsm == 0) && (!readvalid_60 && !writevalid_59 && prev_arvalid_62 && !prev_awvalid_61);
  reg [_axi_s_ctrl_xor_maskwidth-1:0] axis_maskaddr_63;
  wire signed [64-1:0] axislite_rdata_64;
  assign axislite_rdata_64 = (axis_maskaddr_63 == 0)? _axi_s_ctrl_xor_register_0 : 
                             (axis_maskaddr_63 == 1)? _axi_s_ctrl_xor_register_1 : 'hx;
  wire axislite_flag_65;
  assign axislite_flag_65 = (axis_maskaddr_63 == 0)? _axi_s_ctrl_xor_flag_0 : 
                            (axis_maskaddr_63 == 1)? _axi_s_ctrl_xor_flag_1 : 'hx;
  wire signed [64-1:0] axislite_resetval_66;
  assign axislite_resetval_66 = (axis_maskaddr_63 == 0)? _axi_s_ctrl_xor_resetval_0 : 
                                (axis_maskaddr_63 == 1)? _axi_s_ctrl_xor_resetval_1 : 'hx;
  reg _axi_s_ctrl_xor_rdata_cond_0_1;
  assign axi_s_ctrl_xor_wready = _axi_s_ctrl_xor_register_fsm == 3;
  assign axi_s_ctrl_aes_bresp = 0;
  assign axi_s_ctrl_aes_rresp = 0;
  reg signed [64-1:0] _axi_s_ctrl_aes_register_0;
  reg signed [64-1:0] _axi_s_ctrl_aes_register_1;
  reg signed [64-1:0] _axi_s_ctrl_aes_register_2;
  reg signed [64-1:0] _axi_s_ctrl_aes_register_3;
  reg signed [64-1:0] _axi_s_ctrl_aes_register_4;
  reg signed [64-1:0] _axi_s_ctrl_aes_register_5;
  reg signed [64-1:0] _axi_s_ctrl_aes_register_6;
  reg signed [64-1:0] _axi_s_ctrl_aes_register_7;
  reg signed [64-1:0] _axi_s_ctrl_aes_register_8;
  reg _axi_s_ctrl_aes_flag_0;
  reg _axi_s_ctrl_aes_flag_1;
  reg _axi_s_ctrl_aes_flag_2;
  reg _axi_s_ctrl_aes_flag_3;
  reg _axi_s_ctrl_aes_flag_4;
  reg _axi_s_ctrl_aes_flag_5;
  reg _axi_s_ctrl_aes_flag_6;
  reg _axi_s_ctrl_aes_flag_7;
  reg _axi_s_ctrl_aes_flag_8;
  reg signed [64-1:0] _axi_s_ctrl_aes_resetval_0;
  reg signed [64-1:0] _axi_s_ctrl_aes_resetval_1;
  reg signed [64-1:0] _axi_s_ctrl_aes_resetval_2;
  reg signed [64-1:0] _axi_s_ctrl_aes_resetval_3;
  reg signed [64-1:0] _axi_s_ctrl_aes_resetval_4;
  reg signed [64-1:0] _axi_s_ctrl_aes_resetval_5;
  reg signed [64-1:0] _axi_s_ctrl_aes_resetval_6;
  reg signed [64-1:0] _axi_s_ctrl_aes_resetval_7;
  reg signed [64-1:0] _axi_s_ctrl_aes_resetval_8;
  localparam _axi_s_ctrl_aes_maskwidth = 4;
  localparam _axi_s_ctrl_aes_mask = { _axi_s_ctrl_aes_maskwidth{ 1'd1 } };
  localparam _axi_s_ctrl_aes_shift = 3;
  reg [32-1:0] _axi_s_ctrl_aes_register_fsm;
  localparam _axi_s_ctrl_aes_register_fsm_init = 0;
  reg [32-1:0] addr_67;
  reg writevalid_68;
  reg readvalid_69;
  reg prev_awvalid_70;
  reg prev_arvalid_71;
  assign axi_s_ctrl_aes_awready = (_axi_s_ctrl_aes_register_fsm == 0) && (!writevalid_68 && !readvalid_69 && !axi_s_ctrl_aes_bvalid && prev_awvalid_70);
  assign axi_s_ctrl_aes_arready = (_axi_s_ctrl_aes_register_fsm == 0) && (!readvalid_69 && !writevalid_68 && prev_arvalid_71 && !prev_awvalid_70);
  reg [_axi_s_ctrl_aes_maskwidth-1:0] axis_maskaddr_72;
  wire signed [64-1:0] axislite_rdata_73;
  assign axislite_rdata_73 = (axis_maskaddr_72 == 0)? _axi_s_ctrl_aes_register_0 : 
                             (axis_maskaddr_72 == 1)? _axi_s_ctrl_aes_register_1 : 
                             (axis_maskaddr_72 == 2)? _axi_s_ctrl_aes_register_2 : 
                             (axis_maskaddr_72 == 3)? _axi_s_ctrl_aes_register_3 : 
                             (axis_maskaddr_72 == 4)? _axi_s_ctrl_aes_register_4 : 
                             (axis_maskaddr_72 == 5)? _axi_s_ctrl_aes_register_5 : 
                             (axis_maskaddr_72 == 6)? _axi_s_ctrl_aes_register_6 : 
                             (axis_maskaddr_72 == 7)? _axi_s_ctrl_aes_register_7 : 
                             (axis_maskaddr_72 == 8)? _axi_s_ctrl_aes_register_8 : 'hx;
  wire axislite_flag_74;
  assign axislite_flag_74 = (axis_maskaddr_72 == 0)? _axi_s_ctrl_aes_flag_0 : 
                            (axis_maskaddr_72 == 1)? _axi_s_ctrl_aes_flag_1 : 
                            (axis_maskaddr_72 == 2)? _axi_s_ctrl_aes_flag_2 : 
                            (axis_maskaddr_72 == 3)? _axi_s_ctrl_aes_flag_3 : 
                            (axis_maskaddr_72 == 4)? _axi_s_ctrl_aes_flag_4 : 
                            (axis_maskaddr_72 == 5)? _axi_s_ctrl_aes_flag_5 : 
                            (axis_maskaddr_72 == 6)? _axi_s_ctrl_aes_flag_6 : 
                            (axis_maskaddr_72 == 7)? _axi_s_ctrl_aes_flag_7 : 
                            (axis_maskaddr_72 == 8)? _axi_s_ctrl_aes_flag_8 : 'hx;
  wire signed [64-1:0] axislite_resetval_75;
  assign axislite_resetval_75 = (axis_maskaddr_72 == 0)? _axi_s_ctrl_aes_resetval_0 : 
                                (axis_maskaddr_72 == 1)? _axi_s_ctrl_aes_resetval_1 : 
                                (axis_maskaddr_72 == 2)? _axi_s_ctrl_aes_resetval_2 : 
                                (axis_maskaddr_72 == 3)? _axi_s_ctrl_aes_resetval_3 : 
                                (axis_maskaddr_72 == 4)? _axi_s_ctrl_aes_resetval_4 : 
                                (axis_maskaddr_72 == 5)? _axi_s_ctrl_aes_resetval_5 : 
                                (axis_maskaddr_72 == 6)? _axi_s_ctrl_aes_resetval_6 : 
                                (axis_maskaddr_72 == 7)? _axi_s_ctrl_aes_resetval_7 : 
                                (axis_maskaddr_72 == 8)? _axi_s_ctrl_aes_resetval_8 : 'hx;
  reg _axi_s_ctrl_aes_rdata_cond_0_1;
  assign axi_s_ctrl_aes_wready = _axi_s_ctrl_aes_register_fsm == 3;
  assign axi_s_ctrl_axim_bresp = 0;
  assign axi_s_ctrl_axim_rresp = 0;
  reg signed [64-1:0] _axi_s_ctrl_axim_register_0;
  reg signed [64-1:0] _axi_s_ctrl_axim_register_1;
  reg signed [64-1:0] _axi_s_ctrl_axim_register_2;
  reg signed [64-1:0] _axi_s_ctrl_axim_register_3;
  reg signed [64-1:0] _axi_s_ctrl_axim_register_4;
  reg signed [64-1:0] _axi_s_ctrl_axim_register_5;
  reg _axi_s_ctrl_axim_flag_0;
  reg _axi_s_ctrl_axim_flag_1;
  reg _axi_s_ctrl_axim_flag_2;
  reg _axi_s_ctrl_axim_flag_3;
  reg _axi_s_ctrl_axim_flag_4;
  reg _axi_s_ctrl_axim_flag_5;
  reg signed [64-1:0] _axi_s_ctrl_axim_resetval_0;
  reg signed [64-1:0] _axi_s_ctrl_axim_resetval_1;
  reg signed [64-1:0] _axi_s_ctrl_axim_resetval_2;
  reg signed [64-1:0] _axi_s_ctrl_axim_resetval_3;
  reg signed [64-1:0] _axi_s_ctrl_axim_resetval_4;
  reg signed [64-1:0] _axi_s_ctrl_axim_resetval_5;
  localparam _axi_s_ctrl_axim_maskwidth = 3;
  localparam _axi_s_ctrl_axim_mask = { _axi_s_ctrl_axim_maskwidth{ 1'd1 } };
  localparam _axi_s_ctrl_axim_shift = 3;
  reg [32-1:0] _axi_s_ctrl_axim_register_fsm;
  localparam _axi_s_ctrl_axim_register_fsm_init = 0;
  reg [32-1:0] addr_76;
  reg writevalid_77;
  reg readvalid_78;
  reg prev_awvalid_79;
  reg prev_arvalid_80;
  assign axi_s_ctrl_axim_awready = (_axi_s_ctrl_axim_register_fsm == 0) && (!writevalid_77 && !readvalid_78 && !axi_s_ctrl_axim_bvalid && prev_awvalid_79);
  assign axi_s_ctrl_axim_arready = (_axi_s_ctrl_axim_register_fsm == 0) && (!readvalid_78 && !writevalid_77 && prev_arvalid_80 && !prev_awvalid_79);
  reg [_axi_s_ctrl_axim_maskwidth-1:0] axis_maskaddr_81;
  wire signed [64-1:0] axislite_rdata_82;
  assign axislite_rdata_82 = (axis_maskaddr_81 == 0)? _axi_s_ctrl_axim_register_0 : 
                             (axis_maskaddr_81 == 1)? _axi_s_ctrl_axim_register_1 : 
                             (axis_maskaddr_81 == 2)? _axi_s_ctrl_axim_register_2 : 
                             (axis_maskaddr_81 == 3)? _axi_s_ctrl_axim_register_3 : 
                             (axis_maskaddr_81 == 4)? _axi_s_ctrl_axim_register_4 : 
                             (axis_maskaddr_81 == 5)? _axi_s_ctrl_axim_register_5 : 'hx;
  wire axislite_flag_83;
  assign axislite_flag_83 = (axis_maskaddr_81 == 0)? _axi_s_ctrl_axim_flag_0 : 
                            (axis_maskaddr_81 == 1)? _axi_s_ctrl_axim_flag_1 : 
                            (axis_maskaddr_81 == 2)? _axi_s_ctrl_axim_flag_2 : 
                            (axis_maskaddr_81 == 3)? _axi_s_ctrl_axim_flag_3 : 
                            (axis_maskaddr_81 == 4)? _axi_s_ctrl_axim_flag_4 : 
                            (axis_maskaddr_81 == 5)? _axi_s_ctrl_axim_flag_5 : 'hx;
  wire signed [64-1:0] axislite_resetval_84;
  assign axislite_resetval_84 = (axis_maskaddr_81 == 0)? _axi_s_ctrl_axim_resetval_0 : 
                                (axis_maskaddr_81 == 1)? _axi_s_ctrl_axim_resetval_1 : 
                                (axis_maskaddr_81 == 2)? _axi_s_ctrl_axim_resetval_2 : 
                                (axis_maskaddr_81 == 3)? _axi_s_ctrl_axim_resetval_3 : 
                                (axis_maskaddr_81 == 4)? _axi_s_ctrl_axim_resetval_4 : 
                                (axis_maskaddr_81 == 5)? _axi_s_ctrl_axim_resetval_5 : 'hx;
  reg _axi_s_ctrl_axim_rdata_cond_0_1;
  assign axi_s_ctrl_axim_wready = _axi_s_ctrl_axim_register_fsm == 3;
  assign axi_s_llc_bresp = 0;
  assign axi_s_llc_rresp = 0;
  assign axi_s_ctrl_memreq_bresp = 0;
  assign axi_s_ctrl_memreq_rresp = 0;
  reg signed [64-1:0] _axi_s_ctrl_memreq_register_0;
  reg signed [64-1:0] _axi_s_ctrl_memreq_register_1;
  reg signed [64-1:0] _axi_s_ctrl_memreq_register_2;
  reg signed [64-1:0] _axi_s_ctrl_memreq_register_3;
  reg signed [64-1:0] _axi_s_ctrl_memreq_register_4;
  reg signed [64-1:0] _axi_s_ctrl_memreq_register_5;
  reg signed [64-1:0] _axi_s_ctrl_memreq_register_6;
  reg _axi_s_ctrl_memreq_flag_0;
  reg _axi_s_ctrl_memreq_flag_1;
  reg _axi_s_ctrl_memreq_flag_2;
  reg _axi_s_ctrl_memreq_flag_3;
  reg _axi_s_ctrl_memreq_flag_4;
  reg _axi_s_ctrl_memreq_flag_5;
  reg _axi_s_ctrl_memreq_flag_6;
  reg signed [64-1:0] _axi_s_ctrl_memreq_resetval_0;
  reg signed [64-1:0] _axi_s_ctrl_memreq_resetval_1;
  reg signed [64-1:0] _axi_s_ctrl_memreq_resetval_2;
  reg signed [64-1:0] _axi_s_ctrl_memreq_resetval_3;
  reg signed [64-1:0] _axi_s_ctrl_memreq_resetval_4;
  reg signed [64-1:0] _axi_s_ctrl_memreq_resetval_5;
  reg signed [64-1:0] _axi_s_ctrl_memreq_resetval_6;
  localparam _axi_s_ctrl_memreq_maskwidth = 3;
  localparam _axi_s_ctrl_memreq_mask = { _axi_s_ctrl_memreq_maskwidth{ 1'd1 } };
  localparam _axi_s_ctrl_memreq_shift = 3;
  reg [32-1:0] _axi_s_ctrl_memreq_register_fsm;
  localparam _axi_s_ctrl_memreq_register_fsm_init = 0;
  reg [32-1:0] addr_85;
  reg writevalid_86;
  reg readvalid_87;
  reg prev_awvalid_88;
  reg prev_arvalid_89;
  assign axi_s_ctrl_memreq_awready = (_axi_s_ctrl_memreq_register_fsm == 0) && (!writevalid_86 && !readvalid_87 && !axi_s_ctrl_memreq_bvalid && prev_awvalid_88);
  assign axi_s_ctrl_memreq_arready = (_axi_s_ctrl_memreq_register_fsm == 0) && (!readvalid_87 && !writevalid_86 && prev_arvalid_89 && !prev_awvalid_88);
  reg [_axi_s_ctrl_memreq_maskwidth-1:0] axis_maskaddr_90;
  wire signed [64-1:0] axislite_rdata_91;
  assign axislite_rdata_91 = (axis_maskaddr_90 == 0)? _axi_s_ctrl_memreq_register_0 : 
                             (axis_maskaddr_90 == 1)? _axi_s_ctrl_memreq_register_1 : 
                             (axis_maskaddr_90 == 2)? _axi_s_ctrl_memreq_register_2 : 
                             (axis_maskaddr_90 == 3)? _axi_s_ctrl_memreq_register_3 : 
                             (axis_maskaddr_90 == 4)? _axi_s_ctrl_memreq_register_4 : 
                             (axis_maskaddr_90 == 5)? _axi_s_ctrl_memreq_register_5 : 
                             (axis_maskaddr_90 == 6)? _axi_s_ctrl_memreq_register_6 : 'hx;
  wire axislite_flag_92;
  assign axislite_flag_92 = (axis_maskaddr_90 == 0)? _axi_s_ctrl_memreq_flag_0 : 
                            (axis_maskaddr_90 == 1)? _axi_s_ctrl_memreq_flag_1 : 
                            (axis_maskaddr_90 == 2)? _axi_s_ctrl_memreq_flag_2 : 
                            (axis_maskaddr_90 == 3)? _axi_s_ctrl_memreq_flag_3 : 
                            (axis_maskaddr_90 == 4)? _axi_s_ctrl_memreq_flag_4 : 
                            (axis_maskaddr_90 == 5)? _axi_s_ctrl_memreq_flag_5 : 
                            (axis_maskaddr_90 == 6)? _axi_s_ctrl_memreq_flag_6 : 'hx;
  wire signed [64-1:0] axislite_resetval_93;
  assign axislite_resetval_93 = (axis_maskaddr_90 == 0)? _axi_s_ctrl_memreq_resetval_0 : 
                                (axis_maskaddr_90 == 1)? _axi_s_ctrl_memreq_resetval_1 : 
                                (axis_maskaddr_90 == 2)? _axi_s_ctrl_memreq_resetval_2 : 
                                (axis_maskaddr_90 == 3)? _axi_s_ctrl_memreq_resetval_3 : 
                                (axis_maskaddr_90 == 4)? _axi_s_ctrl_memreq_resetval_4 : 
                                (axis_maskaddr_90 == 5)? _axi_s_ctrl_memreq_resetval_5 : 
                                (axis_maskaddr_90 == 6)? _axi_s_ctrl_memreq_resetval_6 : 'hx;
  reg _axi_s_ctrl_memreq_rdata_cond_0_1;
  assign axi_s_ctrl_memreq_wready = _axi_s_ctrl_memreq_register_fsm == 3;

  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_spm_rdata <= 0;
      axi_s_ctrl_spm_rvalid <= 0;
      _axi_s_ctrl_spm_rdata_cond_0_1 <= 0;
    end else begin
      if(_axi_s_ctrl_spm_rdata_cond_0_1) begin
        axi_s_ctrl_spm_rvalid <= 0;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 1) && (axi_s_ctrl_spm_rready || !axi_s_ctrl_spm_rvalid)) begin
        axi_s_ctrl_spm_rdata <= axislite_rdata_6;
        axi_s_ctrl_spm_rvalid <= 1;
      end 
      _axi_s_ctrl_spm_rdata_cond_0_1 <= 1;
      if(axi_s_ctrl_spm_rvalid && !axi_s_ctrl_spm_rready) begin
        axi_s_ctrl_spm_rvalid <= axi_s_ctrl_spm_rvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_spm_bvalid <= 0;
      prev_awvalid_3 <= 0;
      prev_arvalid_4 <= 0;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      addr_0 <= 0;
      _axi_s_ctrl_spm_register_0 <= 0;
      _axi_s_ctrl_spm_flag_0 <= 0;
      _axi_s_ctrl_spm_register_1 <= 0;
      _axi_s_ctrl_spm_flag_1 <= 0;
      _axi_s_ctrl_spm_register_2 <= 0;
      _axi_s_ctrl_spm_flag_2 <= 0;
      _axi_s_ctrl_spm_register_3 <= 0;
      _axi_s_ctrl_spm_flag_3 <= 0;
      _axi_s_ctrl_spm_register_4 <= 0;
      _axi_s_ctrl_spm_flag_4 <= 0;
      _axi_s_ctrl_spm_register_5 <= 0;
      _axi_s_ctrl_spm_flag_5 <= 0;
      _axi_s_ctrl_spm_register_6 <= 0;
      _axi_s_ctrl_spm_flag_6 <= 0;
    end else begin
      if(axi_s_ctrl_spm_bvalid && axi_s_ctrl_spm_bready) begin
        axi_s_ctrl_spm_bvalid <= 0;
      end 
      if(axi_s_ctrl_spm_wvalid && axi_s_ctrl_spm_wready) begin
        axi_s_ctrl_spm_bvalid <= 1;
      end 
      prev_awvalid_3 <= axi_s_ctrl_spm_awvalid;
      prev_arvalid_4 <= axi_s_ctrl_spm_arvalid;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      if(axi_s_ctrl_spm_awready && axi_s_ctrl_spm_awvalid && !axi_s_ctrl_spm_bvalid) begin
        addr_0 <= axi_s_ctrl_spm_awaddr;
        writevalid_1 <= 1;
      end else if(axi_s_ctrl_spm_arready && axi_s_ctrl_spm_arvalid) begin
        addr_0 <= axi_s_ctrl_spm_araddr;
        readvalid_2 <= 1;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 1) && (axi_s_ctrl_spm_rready || !axi_s_ctrl_spm_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 0)) begin
        _axi_s_ctrl_spm_register_0 <= axislite_resetval_8;
        _axi_s_ctrl_spm_flag_0 <= 0;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 1) && (axi_s_ctrl_spm_rready || !axi_s_ctrl_spm_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 1)) begin
        _axi_s_ctrl_spm_register_1 <= axislite_resetval_8;
        _axi_s_ctrl_spm_flag_1 <= 0;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 1) && (axi_s_ctrl_spm_rready || !axi_s_ctrl_spm_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 2)) begin
        _axi_s_ctrl_spm_register_2 <= axislite_resetval_8;
        _axi_s_ctrl_spm_flag_2 <= 0;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 1) && (axi_s_ctrl_spm_rready || !axi_s_ctrl_spm_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 3)) begin
        _axi_s_ctrl_spm_register_3 <= axislite_resetval_8;
        _axi_s_ctrl_spm_flag_3 <= 0;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 1) && (axi_s_ctrl_spm_rready || !axi_s_ctrl_spm_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 4)) begin
        _axi_s_ctrl_spm_register_4 <= axislite_resetval_8;
        _axi_s_ctrl_spm_flag_4 <= 0;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 1) && (axi_s_ctrl_spm_rready || !axi_s_ctrl_spm_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 5)) begin
        _axi_s_ctrl_spm_register_5 <= axislite_resetval_8;
        _axi_s_ctrl_spm_flag_5 <= 0;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 1) && (axi_s_ctrl_spm_rready || !axi_s_ctrl_spm_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 6)) begin
        _axi_s_ctrl_spm_register_6 <= axislite_resetval_8;
        _axi_s_ctrl_spm_flag_6 <= 0;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 3) && axi_s_ctrl_spm_wvalid && (axis_maskaddr_5 == 0)) begin
        _axi_s_ctrl_spm_register_0 <= axi_s_ctrl_spm_wdata;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 3) && axi_s_ctrl_spm_wvalid && (axis_maskaddr_5 == 1)) begin
        _axi_s_ctrl_spm_register_1 <= axi_s_ctrl_spm_wdata;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 3) && axi_s_ctrl_spm_wvalid && (axis_maskaddr_5 == 2)) begin
        _axi_s_ctrl_spm_register_2 <= axi_s_ctrl_spm_wdata;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 3) && axi_s_ctrl_spm_wvalid && (axis_maskaddr_5 == 3)) begin
        _axi_s_ctrl_spm_register_3 <= axi_s_ctrl_spm_wdata;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 3) && axi_s_ctrl_spm_wvalid && (axis_maskaddr_5 == 4)) begin
        _axi_s_ctrl_spm_register_4 <= axi_s_ctrl_spm_wdata;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 3) && axi_s_ctrl_spm_wvalid && (axis_maskaddr_5 == 5)) begin
        _axi_s_ctrl_spm_register_5 <= axi_s_ctrl_spm_wdata;
      end 
      if((_axi_s_ctrl_spm_register_fsm == 3) && axi_s_ctrl_spm_wvalid && (axis_maskaddr_5 == 6)) begin
        _axi_s_ctrl_spm_register_6 <= axi_s_ctrl_spm_wdata;
      end 
    end
  end

  localparam _axi_s_ctrl_spm_register_fsm_1 = 1;
  localparam _axi_s_ctrl_spm_register_fsm_2 = 2;
  localparam _axi_s_ctrl_spm_register_fsm_3 = 3;
  localparam _axi_s_ctrl_spm_register_fsm_4 = 4;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_s_ctrl_spm_register_fsm <= _axi_s_ctrl_spm_register_fsm_init;
      axis_maskaddr_5 <= 0;
    end else begin
      case(_axi_s_ctrl_spm_register_fsm)
        _axi_s_ctrl_spm_register_fsm_init: begin
          if(readvalid_2 || writevalid_1) begin
            axis_maskaddr_5 <= (addr_0 >> _axi_s_ctrl_spm_shift) & _axi_s_ctrl_spm_mask;
          end 
          if(readvalid_2) begin
            _axi_s_ctrl_spm_register_fsm <= _axi_s_ctrl_spm_register_fsm_1;
          end 
          if(writevalid_1) begin
            _axi_s_ctrl_spm_register_fsm <= _axi_s_ctrl_spm_register_fsm_3;
          end 
        end
        _axi_s_ctrl_spm_register_fsm_1: begin
          if(axi_s_ctrl_spm_rready || !axi_s_ctrl_spm_rvalid) begin
            _axi_s_ctrl_spm_register_fsm <= _axi_s_ctrl_spm_register_fsm_2;
          end 
        end
        _axi_s_ctrl_spm_register_fsm_2: begin
          if(axi_s_ctrl_spm_rready && axi_s_ctrl_spm_rvalid) begin
            _axi_s_ctrl_spm_register_fsm <= _axi_s_ctrl_spm_register_fsm_init;
          end 
        end
        _axi_s_ctrl_spm_register_fsm_3: begin
          if(axi_s_ctrl_spm_wvalid) begin
            _axi_s_ctrl_spm_register_fsm <= _axi_s_ctrl_spm_register_fsm_4;
          end 
        end
        _axi_s_ctrl_spm_register_fsm_4: begin
          if(axi_s_ctrl_spm_bready && axi_s_ctrl_spm_bvalid) begin
            _axi_s_ctrl_spm_register_fsm <= _axi_s_ctrl_spm_register_fsm_init;
          end 
        end
      endcase
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_dram_writedata_data_15 <= 0;
      _sb_axi_m_dram_writedata_valid_16 <= 0;
      _sb_axi_m_dram_writedata_tmp_data_18 <= 0;
      _sb_axi_m_dram_writedata_tmp_valid_19 <= 0;
    end else begin
      if(_sb_axi_m_dram_writedata_m_ready_14 || !_sb_axi_m_dram_writedata_valid_16) begin
        _sb_axi_m_dram_writedata_data_15 <= _sb_axi_m_dram_writedata_next_data_20;
        _sb_axi_m_dram_writedata_valid_16 <= _sb_axi_m_dram_writedata_next_valid_21;
      end 
      if(!_sb_axi_m_dram_writedata_tmp_valid_19 && _sb_axi_m_dram_writedata_valid_16 && !_sb_axi_m_dram_writedata_m_ready_14) begin
        _sb_axi_m_dram_writedata_tmp_data_18 <= _sb_axi_m_dram_writedata_s_data_12;
        _sb_axi_m_dram_writedata_tmp_valid_19 <= _sb_axi_m_dram_writedata_s_valid_13;
      end 
      if(_sb_axi_m_dram_writedata_tmp_valid_19 && _sb_axi_m_dram_writedata_m_ready_14) begin
        _sb_axi_m_dram_writedata_tmp_valid_19 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_dram_readdata_data_30 <= 0;
      _sb_axi_m_dram_readdata_valid_31 <= 0;
      _sb_axi_m_dram_readdata_tmp_data_33 <= 0;
      _sb_axi_m_dram_readdata_tmp_valid_34 <= 0;
    end else begin
      if(_sb_axi_m_dram_readdata_m_ready_29 || !_sb_axi_m_dram_readdata_valid_31) begin
        _sb_axi_m_dram_readdata_data_30 <= _sb_axi_m_dram_readdata_next_data_35;
        _sb_axi_m_dram_readdata_valid_31 <= _sb_axi_m_dram_readdata_next_valid_36;
      end 
      if(!_sb_axi_m_dram_readdata_tmp_valid_34 && _sb_axi_m_dram_readdata_valid_31 && !_sb_axi_m_dram_readdata_m_ready_29) begin
        _sb_axi_m_dram_readdata_tmp_data_33 <= _sb_axi_m_dram_readdata_s_data_27;
        _sb_axi_m_dram_readdata_tmp_valid_34 <= _sb_axi_m_dram_readdata_s_valid_28;
      end 
      if(_sb_axi_m_dram_readdata_tmp_valid_34 && _sb_axi_m_dram_readdata_m_ready_29) begin
        _sb_axi_m_dram_readdata_tmp_valid_34 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_dram_outstanding_wcount <= 0;
      _axi_m_dram_read_start <= 0;
      _axi_m_dram_write_start <= 0;
    end else begin
      if(axi_m_dram_awvalid && axi_m_dram_awready && !(axi_m_dram_bvalid && axi_m_dram_bready) && (_axi_m_dram_outstanding_wcount < 7)) begin
        _axi_m_dram_outstanding_wcount <= _axi_m_dram_outstanding_wcount + 1;
      end 
      if(!(axi_m_dram_awvalid && axi_m_dram_awready) && (axi_m_dram_bvalid && axi_m_dram_bready) && (_axi_m_dram_outstanding_wcount > 0)) begin
        _axi_m_dram_outstanding_wcount <= _axi_m_dram_outstanding_wcount - 1;
      end 
      _axi_m_dram_read_start <= 0;
      _axi_m_dram_write_start <= 0;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axi_m_dram_read_req_fifo <= 0;
    end else begin
      if(_axi_m_dram_read_req_fifo_enq && !_axi_m_dram_read_req_fifo_full && (_axi_m_dram_read_req_fifo_deq && !_axi_m_dram_read_req_fifo_empty)) begin
        count__axi_m_dram_read_req_fifo <= count__axi_m_dram_read_req_fifo;
      end else if(_axi_m_dram_read_req_fifo_enq && !_axi_m_dram_read_req_fifo_full) begin
        count__axi_m_dram_read_req_fifo <= count__axi_m_dram_read_req_fifo + 1;
      end else if(_axi_m_dram_read_req_fifo_deq && !_axi_m_dram_read_req_fifo_empty) begin
        count__axi_m_dram_read_req_fifo <= count__axi_m_dram_read_req_fifo - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axi_m_dram_write_req_fifo <= 0;
    end else begin
      if(_axi_m_dram_write_req_fifo_enq && !_axi_m_dram_write_req_fifo_full && (_axi_m_dram_write_req_fifo_deq && !_axi_m_dram_write_req_fifo_empty)) begin
        count__axi_m_dram_write_req_fifo <= count__axi_m_dram_write_req_fifo;
      end else if(_axi_m_dram_write_req_fifo_enq && !_axi_m_dram_write_req_fifo_full) begin
        count__axi_m_dram_write_req_fifo <= count__axi_m_dram_write_req_fifo + 1;
      end else if(_axi_m_dram_write_req_fifo_deq && !_axi_m_dram_write_req_fifo_empty) begin
        count__axi_m_dram_write_req_fifo <= count__axi_m_dram_write_req_fifo - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_mac_rdata <= 0;
      axi_s_ctrl_mac_rvalid <= 0;
      _axi_s_ctrl_mac_rdata_cond_0_1 <= 0;
    end else begin
      if(_axi_s_ctrl_mac_rdata_cond_0_1) begin
        axi_s_ctrl_mac_rvalid <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid)) begin
        axi_s_ctrl_mac_rdata <= axislite_rdata_55;
        axi_s_ctrl_mac_rvalid <= 1;
      end 
      _axi_s_ctrl_mac_rdata_cond_0_1 <= 1;
      if(axi_s_ctrl_mac_rvalid && !axi_s_ctrl_mac_rready) begin
        axi_s_ctrl_mac_rvalid <= axi_s_ctrl_mac_rvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_mac_bvalid <= 0;
      prev_awvalid_52 <= 0;
      prev_arvalid_53 <= 0;
      writevalid_50 <= 0;
      readvalid_51 <= 0;
      addr_49 <= 0;
      _axi_s_ctrl_mac_register_0 <= 0;
      _axi_s_ctrl_mac_flag_0 <= 0;
      _axi_s_ctrl_mac_register_1 <= 0;
      _axi_s_ctrl_mac_flag_1 <= 0;
      _axi_s_ctrl_mac_register_2 <= 0;
      _axi_s_ctrl_mac_flag_2 <= 0;
      _axi_s_ctrl_mac_register_3 <= 0;
      _axi_s_ctrl_mac_flag_3 <= 0;
      _axi_s_ctrl_mac_register_4 <= 0;
      _axi_s_ctrl_mac_flag_4 <= 0;
      _axi_s_ctrl_mac_register_5 <= 0;
      _axi_s_ctrl_mac_flag_5 <= 0;
      _axi_s_ctrl_mac_register_6 <= 0;
      _axi_s_ctrl_mac_flag_6 <= 0;
    end else begin
      if(axi_s_ctrl_mac_bvalid && axi_s_ctrl_mac_bready) begin
        axi_s_ctrl_mac_bvalid <= 0;
      end 
      if(axi_s_ctrl_mac_wvalid && axi_s_ctrl_mac_wready) begin
        axi_s_ctrl_mac_bvalid <= 1;
      end 
      prev_awvalid_52 <= axi_s_ctrl_mac_awvalid;
      prev_arvalid_53 <= axi_s_ctrl_mac_arvalid;
      writevalid_50 <= 0;
      readvalid_51 <= 0;
      if(axi_s_ctrl_mac_awready && axi_s_ctrl_mac_awvalid && !axi_s_ctrl_mac_bvalid) begin
        addr_49 <= axi_s_ctrl_mac_awaddr;
        writevalid_50 <= 1;
      end else if(axi_s_ctrl_mac_arready && axi_s_ctrl_mac_arvalid) begin
        addr_49 <= axi_s_ctrl_mac_araddr;
        readvalid_51 <= 1;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_56 && (axis_maskaddr_54 == 0)) begin
        _axi_s_ctrl_mac_register_0 <= axislite_resetval_57;
        _axi_s_ctrl_mac_flag_0 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_56 && (axis_maskaddr_54 == 1)) begin
        _axi_s_ctrl_mac_register_1 <= axislite_resetval_57;
        _axi_s_ctrl_mac_flag_1 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_56 && (axis_maskaddr_54 == 2)) begin
        _axi_s_ctrl_mac_register_2 <= axislite_resetval_57;
        _axi_s_ctrl_mac_flag_2 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_56 && (axis_maskaddr_54 == 3)) begin
        _axi_s_ctrl_mac_register_3 <= axislite_resetval_57;
        _axi_s_ctrl_mac_flag_3 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_56 && (axis_maskaddr_54 == 4)) begin
        _axi_s_ctrl_mac_register_4 <= axislite_resetval_57;
        _axi_s_ctrl_mac_flag_4 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_56 && (axis_maskaddr_54 == 5)) begin
        _axi_s_ctrl_mac_register_5 <= axislite_resetval_57;
        _axi_s_ctrl_mac_flag_5 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_56 && (axis_maskaddr_54 == 6)) begin
        _axi_s_ctrl_mac_register_6 <= axislite_resetval_57;
        _axi_s_ctrl_mac_flag_6 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_54 == 0)) begin
        _axi_s_ctrl_mac_register_0 <= axi_s_ctrl_mac_wdata;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_54 == 1)) begin
        _axi_s_ctrl_mac_register_1 <= axi_s_ctrl_mac_wdata;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_54 == 2)) begin
        _axi_s_ctrl_mac_register_2 <= axi_s_ctrl_mac_wdata;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_54 == 3)) begin
        _axi_s_ctrl_mac_register_3 <= axi_s_ctrl_mac_wdata;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_54 == 4)) begin
        _axi_s_ctrl_mac_register_4 <= axi_s_ctrl_mac_wdata;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_54 == 5)) begin
        _axi_s_ctrl_mac_register_5 <= axi_s_ctrl_mac_wdata;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_54 == 6)) begin
        _axi_s_ctrl_mac_register_6 <= axi_s_ctrl_mac_wdata;
      end 
    end
  end

  localparam _axi_s_ctrl_mac_register_fsm_1 = 1;
  localparam _axi_s_ctrl_mac_register_fsm_2 = 2;
  localparam _axi_s_ctrl_mac_register_fsm_3 = 3;
  localparam _axi_s_ctrl_mac_register_fsm_4 = 4;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_s_ctrl_mac_register_fsm <= _axi_s_ctrl_mac_register_fsm_init;
      axis_maskaddr_54 <= 0;
    end else begin
      case(_axi_s_ctrl_mac_register_fsm)
        _axi_s_ctrl_mac_register_fsm_init: begin
          if(readvalid_51 || writevalid_50) begin
            axis_maskaddr_54 <= (addr_49 >> _axi_s_ctrl_mac_shift) & _axi_s_ctrl_mac_mask;
          end 
          if(readvalid_51) begin
            _axi_s_ctrl_mac_register_fsm <= _axi_s_ctrl_mac_register_fsm_1;
          end 
          if(writevalid_50) begin
            _axi_s_ctrl_mac_register_fsm <= _axi_s_ctrl_mac_register_fsm_3;
          end 
        end
        _axi_s_ctrl_mac_register_fsm_1: begin
          if(axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) begin
            _axi_s_ctrl_mac_register_fsm <= _axi_s_ctrl_mac_register_fsm_2;
          end 
        end
        _axi_s_ctrl_mac_register_fsm_2: begin
          if(axi_s_ctrl_mac_rready && axi_s_ctrl_mac_rvalid) begin
            _axi_s_ctrl_mac_register_fsm <= _axi_s_ctrl_mac_register_fsm_init;
          end 
        end
        _axi_s_ctrl_mac_register_fsm_3: begin
          if(axi_s_ctrl_mac_wvalid) begin
            _axi_s_ctrl_mac_register_fsm <= _axi_s_ctrl_mac_register_fsm_4;
          end 
        end
        _axi_s_ctrl_mac_register_fsm_4: begin
          if(axi_s_ctrl_mac_bready && axi_s_ctrl_mac_bvalid) begin
            _axi_s_ctrl_mac_register_fsm <= _axi_s_ctrl_mac_register_fsm_init;
          end 
        end
      endcase
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_xor_rdata <= 0;
      axi_s_ctrl_xor_rvalid <= 0;
      _axi_s_ctrl_xor_rdata_cond_0_1 <= 0;
    end else begin
      if(_axi_s_ctrl_xor_rdata_cond_0_1) begin
        axi_s_ctrl_xor_rvalid <= 0;
      end 
      if((_axi_s_ctrl_xor_register_fsm == 1) && (axi_s_ctrl_xor_rready || !axi_s_ctrl_xor_rvalid)) begin
        axi_s_ctrl_xor_rdata <= axislite_rdata_64;
        axi_s_ctrl_xor_rvalid <= 1;
      end 
      _axi_s_ctrl_xor_rdata_cond_0_1 <= 1;
      if(axi_s_ctrl_xor_rvalid && !axi_s_ctrl_xor_rready) begin
        axi_s_ctrl_xor_rvalid <= axi_s_ctrl_xor_rvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_xor_bvalid <= 0;
      prev_awvalid_61 <= 0;
      prev_arvalid_62 <= 0;
      writevalid_59 <= 0;
      readvalid_60 <= 0;
      addr_58 <= 0;
      _axi_s_ctrl_xor_register_0 <= 0;
      _axi_s_ctrl_xor_flag_0 <= 0;
      _axi_s_ctrl_xor_register_1 <= 0;
      _axi_s_ctrl_xor_flag_1 <= 0;
    end else begin
      if(axi_s_ctrl_xor_bvalid && axi_s_ctrl_xor_bready) begin
        axi_s_ctrl_xor_bvalid <= 0;
      end 
      if(axi_s_ctrl_xor_wvalid && axi_s_ctrl_xor_wready) begin
        axi_s_ctrl_xor_bvalid <= 1;
      end 
      prev_awvalid_61 <= axi_s_ctrl_xor_awvalid;
      prev_arvalid_62 <= axi_s_ctrl_xor_arvalid;
      writevalid_59 <= 0;
      readvalid_60 <= 0;
      if(axi_s_ctrl_xor_awready && axi_s_ctrl_xor_awvalid && !axi_s_ctrl_xor_bvalid) begin
        addr_58 <= axi_s_ctrl_xor_awaddr;
        writevalid_59 <= 1;
      end else if(axi_s_ctrl_xor_arready && axi_s_ctrl_xor_arvalid) begin
        addr_58 <= axi_s_ctrl_xor_araddr;
        readvalid_60 <= 1;
      end 
      if((_axi_s_ctrl_xor_register_fsm == 1) && (axi_s_ctrl_xor_rready || !axi_s_ctrl_xor_rvalid) && axislite_flag_65 && (axis_maskaddr_63 == 0)) begin
        _axi_s_ctrl_xor_register_0 <= axislite_resetval_66;
        _axi_s_ctrl_xor_flag_0 <= 0;
      end 
      if((_axi_s_ctrl_xor_register_fsm == 1) && (axi_s_ctrl_xor_rready || !axi_s_ctrl_xor_rvalid) && axislite_flag_65 && (axis_maskaddr_63 == 1)) begin
        _axi_s_ctrl_xor_register_1 <= axislite_resetval_66;
        _axi_s_ctrl_xor_flag_1 <= 0;
      end 
      if((_axi_s_ctrl_xor_register_fsm == 3) && axi_s_ctrl_xor_wvalid && (axis_maskaddr_63 == 0)) begin
        _axi_s_ctrl_xor_register_0 <= axi_s_ctrl_xor_wdata;
      end 
      if((_axi_s_ctrl_xor_register_fsm == 3) && axi_s_ctrl_xor_wvalid && (axis_maskaddr_63 == 1)) begin
        _axi_s_ctrl_xor_register_1 <= axi_s_ctrl_xor_wdata;
      end 
    end
  end

  localparam _axi_s_ctrl_xor_register_fsm_1 = 1;
  localparam _axi_s_ctrl_xor_register_fsm_2 = 2;
  localparam _axi_s_ctrl_xor_register_fsm_3 = 3;
  localparam _axi_s_ctrl_xor_register_fsm_4 = 4;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_s_ctrl_xor_register_fsm <= _axi_s_ctrl_xor_register_fsm_init;
      axis_maskaddr_63 <= 0;
    end else begin
      case(_axi_s_ctrl_xor_register_fsm)
        _axi_s_ctrl_xor_register_fsm_init: begin
          if(readvalid_60 || writevalid_59) begin
            axis_maskaddr_63 <= (addr_58 >> _axi_s_ctrl_xor_shift) & _axi_s_ctrl_xor_mask;
          end 
          if(readvalid_60) begin
            _axi_s_ctrl_xor_register_fsm <= _axi_s_ctrl_xor_register_fsm_1;
          end 
          if(writevalid_59) begin
            _axi_s_ctrl_xor_register_fsm <= _axi_s_ctrl_xor_register_fsm_3;
          end 
        end
        _axi_s_ctrl_xor_register_fsm_1: begin
          if(axi_s_ctrl_xor_rready || !axi_s_ctrl_xor_rvalid) begin
            _axi_s_ctrl_xor_register_fsm <= _axi_s_ctrl_xor_register_fsm_2;
          end 
        end
        _axi_s_ctrl_xor_register_fsm_2: begin
          if(axi_s_ctrl_xor_rready && axi_s_ctrl_xor_rvalid) begin
            _axi_s_ctrl_xor_register_fsm <= _axi_s_ctrl_xor_register_fsm_init;
          end 
        end
        _axi_s_ctrl_xor_register_fsm_3: begin
          if(axi_s_ctrl_xor_wvalid) begin
            _axi_s_ctrl_xor_register_fsm <= _axi_s_ctrl_xor_register_fsm_4;
          end 
        end
        _axi_s_ctrl_xor_register_fsm_4: begin
          if(axi_s_ctrl_xor_bready && axi_s_ctrl_xor_bvalid) begin
            _axi_s_ctrl_xor_register_fsm <= _axi_s_ctrl_xor_register_fsm_init;
          end 
        end
      endcase
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_aes_rdata <= 0;
      axi_s_ctrl_aes_rvalid <= 0;
      _axi_s_ctrl_aes_rdata_cond_0_1 <= 0;
    end else begin
      if(_axi_s_ctrl_aes_rdata_cond_0_1) begin
        axi_s_ctrl_aes_rvalid <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid)) begin
        axi_s_ctrl_aes_rdata <= axislite_rdata_73;
        axi_s_ctrl_aes_rvalid <= 1;
      end 
      _axi_s_ctrl_aes_rdata_cond_0_1 <= 1;
      if(axi_s_ctrl_aes_rvalid && !axi_s_ctrl_aes_rready) begin
        axi_s_ctrl_aes_rvalid <= axi_s_ctrl_aes_rvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_aes_bvalid <= 0;
      prev_awvalid_70 <= 0;
      prev_arvalid_71 <= 0;
      writevalid_68 <= 0;
      readvalid_69 <= 0;
      addr_67 <= 0;
      _axi_s_ctrl_aes_register_0 <= 0;
      _axi_s_ctrl_aes_flag_0 <= 0;
      _axi_s_ctrl_aes_register_1 <= 0;
      _axi_s_ctrl_aes_flag_1 <= 0;
      _axi_s_ctrl_aes_register_2 <= 0;
      _axi_s_ctrl_aes_flag_2 <= 0;
      _axi_s_ctrl_aes_register_3 <= 0;
      _axi_s_ctrl_aes_flag_3 <= 0;
      _axi_s_ctrl_aes_register_4 <= 0;
      _axi_s_ctrl_aes_flag_4 <= 0;
      _axi_s_ctrl_aes_register_5 <= 0;
      _axi_s_ctrl_aes_flag_5 <= 0;
      _axi_s_ctrl_aes_register_6 <= 0;
      _axi_s_ctrl_aes_flag_6 <= 0;
      _axi_s_ctrl_aes_register_7 <= 0;
      _axi_s_ctrl_aes_flag_7 <= 0;
      _axi_s_ctrl_aes_register_8 <= 0;
      _axi_s_ctrl_aes_flag_8 <= 0;
    end else begin
      if(axi_s_ctrl_aes_bvalid && axi_s_ctrl_aes_bready) begin
        axi_s_ctrl_aes_bvalid <= 0;
      end 
      if(axi_s_ctrl_aes_wvalid && axi_s_ctrl_aes_wready) begin
        axi_s_ctrl_aes_bvalid <= 1;
      end 
      prev_awvalid_70 <= axi_s_ctrl_aes_awvalid;
      prev_arvalid_71 <= axi_s_ctrl_aes_arvalid;
      writevalid_68 <= 0;
      readvalid_69 <= 0;
      if(axi_s_ctrl_aes_awready && axi_s_ctrl_aes_awvalid && !axi_s_ctrl_aes_bvalid) begin
        addr_67 <= axi_s_ctrl_aes_awaddr;
        writevalid_68 <= 1;
      end else if(axi_s_ctrl_aes_arready && axi_s_ctrl_aes_arvalid) begin
        addr_67 <= axi_s_ctrl_aes_araddr;
        readvalid_69 <= 1;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_74 && (axis_maskaddr_72 == 0)) begin
        _axi_s_ctrl_aes_register_0 <= axislite_resetval_75;
        _axi_s_ctrl_aes_flag_0 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_74 && (axis_maskaddr_72 == 1)) begin
        _axi_s_ctrl_aes_register_1 <= axislite_resetval_75;
        _axi_s_ctrl_aes_flag_1 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_74 && (axis_maskaddr_72 == 2)) begin
        _axi_s_ctrl_aes_register_2 <= axislite_resetval_75;
        _axi_s_ctrl_aes_flag_2 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_74 && (axis_maskaddr_72 == 3)) begin
        _axi_s_ctrl_aes_register_3 <= axislite_resetval_75;
        _axi_s_ctrl_aes_flag_3 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_74 && (axis_maskaddr_72 == 4)) begin
        _axi_s_ctrl_aes_register_4 <= axislite_resetval_75;
        _axi_s_ctrl_aes_flag_4 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_74 && (axis_maskaddr_72 == 5)) begin
        _axi_s_ctrl_aes_register_5 <= axislite_resetval_75;
        _axi_s_ctrl_aes_flag_5 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_74 && (axis_maskaddr_72 == 6)) begin
        _axi_s_ctrl_aes_register_6 <= axislite_resetval_75;
        _axi_s_ctrl_aes_flag_6 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_74 && (axis_maskaddr_72 == 7)) begin
        _axi_s_ctrl_aes_register_7 <= axislite_resetval_75;
        _axi_s_ctrl_aes_flag_7 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_74 && (axis_maskaddr_72 == 8)) begin
        _axi_s_ctrl_aes_register_8 <= axislite_resetval_75;
        _axi_s_ctrl_aes_flag_8 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_72 == 0)) begin
        _axi_s_ctrl_aes_register_0 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_72 == 1)) begin
        _axi_s_ctrl_aes_register_1 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_72 == 2)) begin
        _axi_s_ctrl_aes_register_2 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_72 == 3)) begin
        _axi_s_ctrl_aes_register_3 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_72 == 4)) begin
        _axi_s_ctrl_aes_register_4 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_72 == 5)) begin
        _axi_s_ctrl_aes_register_5 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_72 == 6)) begin
        _axi_s_ctrl_aes_register_6 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_72 == 7)) begin
        _axi_s_ctrl_aes_register_7 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_72 == 8)) begin
        _axi_s_ctrl_aes_register_8 <= axi_s_ctrl_aes_wdata;
      end 
    end
  end

  localparam _axi_s_ctrl_aes_register_fsm_1 = 1;
  localparam _axi_s_ctrl_aes_register_fsm_2 = 2;
  localparam _axi_s_ctrl_aes_register_fsm_3 = 3;
  localparam _axi_s_ctrl_aes_register_fsm_4 = 4;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_s_ctrl_aes_register_fsm <= _axi_s_ctrl_aes_register_fsm_init;
      axis_maskaddr_72 <= 0;
    end else begin
      case(_axi_s_ctrl_aes_register_fsm)
        _axi_s_ctrl_aes_register_fsm_init: begin
          if(readvalid_69 || writevalid_68) begin
            axis_maskaddr_72 <= (addr_67 >> _axi_s_ctrl_aes_shift) & _axi_s_ctrl_aes_mask;
          end 
          if(readvalid_69) begin
            _axi_s_ctrl_aes_register_fsm <= _axi_s_ctrl_aes_register_fsm_1;
          end 
          if(writevalid_68) begin
            _axi_s_ctrl_aes_register_fsm <= _axi_s_ctrl_aes_register_fsm_3;
          end 
        end
        _axi_s_ctrl_aes_register_fsm_1: begin
          if(axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) begin
            _axi_s_ctrl_aes_register_fsm <= _axi_s_ctrl_aes_register_fsm_2;
          end 
        end
        _axi_s_ctrl_aes_register_fsm_2: begin
          if(axi_s_ctrl_aes_rready && axi_s_ctrl_aes_rvalid) begin
            _axi_s_ctrl_aes_register_fsm <= _axi_s_ctrl_aes_register_fsm_init;
          end 
        end
        _axi_s_ctrl_aes_register_fsm_3: begin
          if(axi_s_ctrl_aes_wvalid) begin
            _axi_s_ctrl_aes_register_fsm <= _axi_s_ctrl_aes_register_fsm_4;
          end 
        end
        _axi_s_ctrl_aes_register_fsm_4: begin
          if(axi_s_ctrl_aes_bready && axi_s_ctrl_aes_bvalid) begin
            _axi_s_ctrl_aes_register_fsm <= _axi_s_ctrl_aes_register_fsm_init;
          end 
        end
      endcase
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_axim_rdata <= 0;
      axi_s_ctrl_axim_rvalid <= 0;
      _axi_s_ctrl_axim_rdata_cond_0_1 <= 0;
    end else begin
      if(_axi_s_ctrl_axim_rdata_cond_0_1) begin
        axi_s_ctrl_axim_rvalid <= 0;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 1) && (axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid)) begin
        axi_s_ctrl_axim_rdata <= axislite_rdata_82;
        axi_s_ctrl_axim_rvalid <= 1;
      end 
      _axi_s_ctrl_axim_rdata_cond_0_1 <= 1;
      if(axi_s_ctrl_axim_rvalid && !axi_s_ctrl_axim_rready) begin
        axi_s_ctrl_axim_rvalid <= axi_s_ctrl_axim_rvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_axim_bvalid <= 0;
      prev_awvalid_79 <= 0;
      prev_arvalid_80 <= 0;
      writevalid_77 <= 0;
      readvalid_78 <= 0;
      addr_76 <= 0;
      _axi_s_ctrl_axim_register_0 <= 0;
      _axi_s_ctrl_axim_flag_0 <= 0;
      _axi_s_ctrl_axim_register_1 <= 0;
      _axi_s_ctrl_axim_flag_1 <= 0;
      _axi_s_ctrl_axim_register_2 <= 0;
      _axi_s_ctrl_axim_flag_2 <= 0;
      _axi_s_ctrl_axim_register_3 <= 0;
      _axi_s_ctrl_axim_flag_3 <= 0;
      _axi_s_ctrl_axim_register_4 <= 0;
      _axi_s_ctrl_axim_flag_4 <= 0;
      _axi_s_ctrl_axim_register_5 <= 0;
      _axi_s_ctrl_axim_flag_5 <= 0;
    end else begin
      if(axi_s_ctrl_axim_bvalid && axi_s_ctrl_axim_bready) begin
        axi_s_ctrl_axim_bvalid <= 0;
      end 
      if(axi_s_ctrl_axim_wvalid && axi_s_ctrl_axim_wready) begin
        axi_s_ctrl_axim_bvalid <= 1;
      end 
      prev_awvalid_79 <= axi_s_ctrl_axim_awvalid;
      prev_arvalid_80 <= axi_s_ctrl_axim_arvalid;
      writevalid_77 <= 0;
      readvalid_78 <= 0;
      if(axi_s_ctrl_axim_awready && axi_s_ctrl_axim_awvalid && !axi_s_ctrl_axim_bvalid) begin
        addr_76 <= axi_s_ctrl_axim_awaddr;
        writevalid_77 <= 1;
      end else if(axi_s_ctrl_axim_arready && axi_s_ctrl_axim_arvalid) begin
        addr_76 <= axi_s_ctrl_axim_araddr;
        readvalid_78 <= 1;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 1) && (axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid) && axislite_flag_83 && (axis_maskaddr_81 == 0)) begin
        _axi_s_ctrl_axim_register_0 <= axislite_resetval_84;
        _axi_s_ctrl_axim_flag_0 <= 0;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 1) && (axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid) && axislite_flag_83 && (axis_maskaddr_81 == 1)) begin
        _axi_s_ctrl_axim_register_1 <= axislite_resetval_84;
        _axi_s_ctrl_axim_flag_1 <= 0;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 1) && (axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid) && axislite_flag_83 && (axis_maskaddr_81 == 2)) begin
        _axi_s_ctrl_axim_register_2 <= axislite_resetval_84;
        _axi_s_ctrl_axim_flag_2 <= 0;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 1) && (axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid) && axislite_flag_83 && (axis_maskaddr_81 == 3)) begin
        _axi_s_ctrl_axim_register_3 <= axislite_resetval_84;
        _axi_s_ctrl_axim_flag_3 <= 0;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 1) && (axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid) && axislite_flag_83 && (axis_maskaddr_81 == 4)) begin
        _axi_s_ctrl_axim_register_4 <= axislite_resetval_84;
        _axi_s_ctrl_axim_flag_4 <= 0;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 1) && (axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid) && axislite_flag_83 && (axis_maskaddr_81 == 5)) begin
        _axi_s_ctrl_axim_register_5 <= axislite_resetval_84;
        _axi_s_ctrl_axim_flag_5 <= 0;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 3) && axi_s_ctrl_axim_wvalid && (axis_maskaddr_81 == 0)) begin
        _axi_s_ctrl_axim_register_0 <= axi_s_ctrl_axim_wdata;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 3) && axi_s_ctrl_axim_wvalid && (axis_maskaddr_81 == 1)) begin
        _axi_s_ctrl_axim_register_1 <= axi_s_ctrl_axim_wdata;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 3) && axi_s_ctrl_axim_wvalid && (axis_maskaddr_81 == 2)) begin
        _axi_s_ctrl_axim_register_2 <= axi_s_ctrl_axim_wdata;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 3) && axi_s_ctrl_axim_wvalid && (axis_maskaddr_81 == 3)) begin
        _axi_s_ctrl_axim_register_3 <= axi_s_ctrl_axim_wdata;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 3) && axi_s_ctrl_axim_wvalid && (axis_maskaddr_81 == 4)) begin
        _axi_s_ctrl_axim_register_4 <= axi_s_ctrl_axim_wdata;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 3) && axi_s_ctrl_axim_wvalid && (axis_maskaddr_81 == 5)) begin
        _axi_s_ctrl_axim_register_5 <= axi_s_ctrl_axim_wdata;
      end 
    end
  end

  localparam _axi_s_ctrl_axim_register_fsm_1 = 1;
  localparam _axi_s_ctrl_axim_register_fsm_2 = 2;
  localparam _axi_s_ctrl_axim_register_fsm_3 = 3;
  localparam _axi_s_ctrl_axim_register_fsm_4 = 4;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_s_ctrl_axim_register_fsm <= _axi_s_ctrl_axim_register_fsm_init;
      axis_maskaddr_81 <= 0;
    end else begin
      case(_axi_s_ctrl_axim_register_fsm)
        _axi_s_ctrl_axim_register_fsm_init: begin
          if(readvalid_78 || writevalid_77) begin
            axis_maskaddr_81 <= (addr_76 >> _axi_s_ctrl_axim_shift) & _axi_s_ctrl_axim_mask;
          end 
          if(readvalid_78) begin
            _axi_s_ctrl_axim_register_fsm <= _axi_s_ctrl_axim_register_fsm_1;
          end 
          if(writevalid_77) begin
            _axi_s_ctrl_axim_register_fsm <= _axi_s_ctrl_axim_register_fsm_3;
          end 
        end
        _axi_s_ctrl_axim_register_fsm_1: begin
          if(axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid) begin
            _axi_s_ctrl_axim_register_fsm <= _axi_s_ctrl_axim_register_fsm_2;
          end 
        end
        _axi_s_ctrl_axim_register_fsm_2: begin
          if(axi_s_ctrl_axim_rready && axi_s_ctrl_axim_rvalid) begin
            _axi_s_ctrl_axim_register_fsm <= _axi_s_ctrl_axim_register_fsm_init;
          end 
        end
        _axi_s_ctrl_axim_register_fsm_3: begin
          if(axi_s_ctrl_axim_wvalid) begin
            _axi_s_ctrl_axim_register_fsm <= _axi_s_ctrl_axim_register_fsm_4;
          end 
        end
        _axi_s_ctrl_axim_register_fsm_4: begin
          if(axi_s_ctrl_axim_bready && axi_s_ctrl_axim_bvalid) begin
            _axi_s_ctrl_axim_register_fsm <= _axi_s_ctrl_axim_register_fsm_init;
          end 
        end
      endcase
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_llc_bvalid <= 0;
    end else begin
      if(axi_s_llc_bvalid && axi_s_llc_bready) begin
        axi_s_llc_bvalid <= 0;
      end 
      if(axi_s_llc_wvalid && axi_s_llc_wready && axi_s_llc_wlast) begin
        axi_s_llc_bvalid <= 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_memreq_rdata <= 0;
      axi_s_ctrl_memreq_rvalid <= 0;
      _axi_s_ctrl_memreq_rdata_cond_0_1 <= 0;
    end else begin
      if(_axi_s_ctrl_memreq_rdata_cond_0_1) begin
        axi_s_ctrl_memreq_rvalid <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid)) begin
        axi_s_ctrl_memreq_rdata <= axislite_rdata_91;
        axi_s_ctrl_memreq_rvalid <= 1;
      end 
      _axi_s_ctrl_memreq_rdata_cond_0_1 <= 1;
      if(axi_s_ctrl_memreq_rvalid && !axi_s_ctrl_memreq_rready) begin
        axi_s_ctrl_memreq_rvalid <= axi_s_ctrl_memreq_rvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_memreq_bvalid <= 0;
      prev_awvalid_88 <= 0;
      prev_arvalid_89 <= 0;
      writevalid_86 <= 0;
      readvalid_87 <= 0;
      addr_85 <= 0;
      _axi_s_ctrl_memreq_register_0 <= 0;
      _axi_s_ctrl_memreq_flag_0 <= 0;
      _axi_s_ctrl_memreq_register_1 <= 0;
      _axi_s_ctrl_memreq_flag_1 <= 0;
      _axi_s_ctrl_memreq_register_2 <= 0;
      _axi_s_ctrl_memreq_flag_2 <= 0;
      _axi_s_ctrl_memreq_register_3 <= 0;
      _axi_s_ctrl_memreq_flag_3 <= 0;
      _axi_s_ctrl_memreq_register_4 <= 0;
      _axi_s_ctrl_memreq_flag_4 <= 0;
      _axi_s_ctrl_memreq_register_5 <= 0;
      _axi_s_ctrl_memreq_flag_5 <= 0;
      _axi_s_ctrl_memreq_register_6 <= 0;
      _axi_s_ctrl_memreq_flag_6 <= 0;
    end else begin
      if(axi_s_ctrl_memreq_bvalid && axi_s_ctrl_memreq_bready) begin
        axi_s_ctrl_memreq_bvalid <= 0;
      end 
      if(axi_s_ctrl_memreq_wvalid && axi_s_ctrl_memreq_wready) begin
        axi_s_ctrl_memreq_bvalid <= 1;
      end 
      prev_awvalid_88 <= axi_s_ctrl_memreq_awvalid;
      prev_arvalid_89 <= axi_s_ctrl_memreq_arvalid;
      writevalid_86 <= 0;
      readvalid_87 <= 0;
      if(axi_s_ctrl_memreq_awready && axi_s_ctrl_memreq_awvalid && !axi_s_ctrl_memreq_bvalid) begin
        addr_85 <= axi_s_ctrl_memreq_awaddr;
        writevalid_86 <= 1;
      end else if(axi_s_ctrl_memreq_arready && axi_s_ctrl_memreq_arvalid) begin
        addr_85 <= axi_s_ctrl_memreq_araddr;
        readvalid_87 <= 1;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_92 && (axis_maskaddr_90 == 0)) begin
        _axi_s_ctrl_memreq_register_0 <= axislite_resetval_93;
        _axi_s_ctrl_memreq_flag_0 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_92 && (axis_maskaddr_90 == 1)) begin
        _axi_s_ctrl_memreq_register_1 <= axislite_resetval_93;
        _axi_s_ctrl_memreq_flag_1 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_92 && (axis_maskaddr_90 == 2)) begin
        _axi_s_ctrl_memreq_register_2 <= axislite_resetval_93;
        _axi_s_ctrl_memreq_flag_2 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_92 && (axis_maskaddr_90 == 3)) begin
        _axi_s_ctrl_memreq_register_3 <= axislite_resetval_93;
        _axi_s_ctrl_memreq_flag_3 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_92 && (axis_maskaddr_90 == 4)) begin
        _axi_s_ctrl_memreq_register_4 <= axislite_resetval_93;
        _axi_s_ctrl_memreq_flag_4 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_92 && (axis_maskaddr_90 == 5)) begin
        _axi_s_ctrl_memreq_register_5 <= axislite_resetval_93;
        _axi_s_ctrl_memreq_flag_5 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_92 && (axis_maskaddr_90 == 6)) begin
        _axi_s_ctrl_memreq_register_6 <= axislite_resetval_93;
        _axi_s_ctrl_memreq_flag_6 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_90 == 0)) begin
        _axi_s_ctrl_memreq_register_0 <= axi_s_ctrl_memreq_wdata;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_90 == 1)) begin
        _axi_s_ctrl_memreq_register_1 <= axi_s_ctrl_memreq_wdata;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_90 == 2)) begin
        _axi_s_ctrl_memreq_register_2 <= axi_s_ctrl_memreq_wdata;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_90 == 3)) begin
        _axi_s_ctrl_memreq_register_3 <= axi_s_ctrl_memreq_wdata;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_90 == 4)) begin
        _axi_s_ctrl_memreq_register_4 <= axi_s_ctrl_memreq_wdata;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_90 == 5)) begin
        _axi_s_ctrl_memreq_register_5 <= axi_s_ctrl_memreq_wdata;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_90 == 6)) begin
        _axi_s_ctrl_memreq_register_6 <= axi_s_ctrl_memreq_wdata;
      end 
    end
  end

  localparam _axi_s_ctrl_memreq_register_fsm_1 = 1;
  localparam _axi_s_ctrl_memreq_register_fsm_2 = 2;
  localparam _axi_s_ctrl_memreq_register_fsm_3 = 3;
  localparam _axi_s_ctrl_memreq_register_fsm_4 = 4;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_s_ctrl_memreq_register_fsm <= _axi_s_ctrl_memreq_register_fsm_init;
      axis_maskaddr_90 <= 0;
    end else begin
      case(_axi_s_ctrl_memreq_register_fsm)
        _axi_s_ctrl_memreq_register_fsm_init: begin
          if(readvalid_87 || writevalid_86) begin
            axis_maskaddr_90 <= (addr_85 >> _axi_s_ctrl_memreq_shift) & _axi_s_ctrl_memreq_mask;
          end 
          if(readvalid_87) begin
            _axi_s_ctrl_memreq_register_fsm <= _axi_s_ctrl_memreq_register_fsm_1;
          end 
          if(writevalid_86) begin
            _axi_s_ctrl_memreq_register_fsm <= _axi_s_ctrl_memreq_register_fsm_3;
          end 
        end
        _axi_s_ctrl_memreq_register_fsm_1: begin
          if(axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) begin
            _axi_s_ctrl_memreq_register_fsm <= _axi_s_ctrl_memreq_register_fsm_2;
          end 
        end
        _axi_s_ctrl_memreq_register_fsm_2: begin
          if(axi_s_ctrl_memreq_rready && axi_s_ctrl_memreq_rvalid) begin
            _axi_s_ctrl_memreq_register_fsm <= _axi_s_ctrl_memreq_register_fsm_init;
          end 
        end
        _axi_s_ctrl_memreq_register_fsm_3: begin
          if(axi_s_ctrl_memreq_wvalid) begin
            _axi_s_ctrl_memreq_register_fsm <= _axi_s_ctrl_memreq_register_fsm_4;
          end 
        end
        _axi_s_ctrl_memreq_register_fsm_4: begin
          if(axi_s_ctrl_memreq_bready && axi_s_ctrl_memreq_bvalid) begin
            _axi_s_ctrl_memreq_register_fsm <= _axi_s_ctrl_memreq_register_fsm_init;
          end 
        end
      endcase
    end
  end


endmodule



module _axi_m_dram_read_req_fifo
(
  input CLK,
  input RST,
  input _axi_m_dram_read_req_fifo_enq,
  input [137-1:0] _axi_m_dram_read_req_fifo_wdata,
  output _axi_m_dram_read_req_fifo_full,
  output _axi_m_dram_read_req_fifo_almost_full,
  input _axi_m_dram_read_req_fifo_deq,
  output [137-1:0] _axi_m_dram_read_req_fifo_rdata,
  output _axi_m_dram_read_req_fifo_empty,
  output _axi_m_dram_read_req_fifo_almost_empty
);

  reg [137-1:0] mem [0:8-1];
  reg [3-1:0] head;
  reg [3-1:0] tail;
  wire is_empty;
  wire is_almost_empty;
  wire is_full;
  wire is_almost_full;
  assign is_empty = head == tail;
  assign is_almost_empty = head == (tail + 1 & 7);
  assign is_full = (head + 1 & 7) == tail;
  assign is_almost_full = (head + 2 & 7) == tail;
  wire [137-1:0] rdata;
  assign _axi_m_dram_read_req_fifo_full = is_full;
  assign _axi_m_dram_read_req_fifo_almost_full = is_almost_full || is_full;
  assign _axi_m_dram_read_req_fifo_empty = is_empty;
  assign _axi_m_dram_read_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axi_m_dram_read_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axi_m_dram_read_req_fifo_enq && !is_full) begin
        mem[head] <= _axi_m_dram_read_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axi_m_dram_read_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _axi_m_dram_write_req_fifo
(
  input CLK,
  input RST,
  input _axi_m_dram_write_req_fifo_enq,
  input [137-1:0] _axi_m_dram_write_req_fifo_wdata,
  output _axi_m_dram_write_req_fifo_full,
  output _axi_m_dram_write_req_fifo_almost_full,
  input _axi_m_dram_write_req_fifo_deq,
  output [137-1:0] _axi_m_dram_write_req_fifo_rdata,
  output _axi_m_dram_write_req_fifo_empty,
  output _axi_m_dram_write_req_fifo_almost_empty
);

  reg [137-1:0] mem [0:8-1];
  reg [3-1:0] head;
  reg [3-1:0] tail;
  wire is_empty;
  wire is_almost_empty;
  wire is_full;
  wire is_almost_full;
  assign is_empty = head == tail;
  assign is_almost_empty = head == (tail + 1 & 7);
  assign is_full = (head + 1 & 7) == tail;
  assign is_almost_full = (head + 2 & 7) == tail;
  wire [137-1:0] rdata;
  assign _axi_m_dram_write_req_fifo_full = is_full;
  assign _axi_m_dram_write_req_fifo_almost_full = is_almost_full || is_full;
  assign _axi_m_dram_write_req_fifo_empty = is_empty;
  assign _axi_m_dram_write_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axi_m_dram_write_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axi_m_dram_write_req_fifo_enq && !is_full) begin
        mem[head] <= _axi_m_dram_write_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axi_m_dram_write_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule

