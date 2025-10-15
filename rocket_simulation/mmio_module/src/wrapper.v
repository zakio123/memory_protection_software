

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
// --- モジュール間接続のためのwire定義 ---
// wire定義　SPM-> MAC
wire [128-1:0] axis_in_mac_tdata;
wire axis_in_mac_tvalid;
wire axis_in_mac_tready;
wire axis_in_mac_tlast;

// wire定義　AES-> XORed
wire [128-1:0] axis_in_aes_tdata;
wire axis_in_aes_tvalid;
wire axis_in_aes_tready;
wire axis_in_aes_tlast;

//  wire定義 XORed-> SPM
wire [128-1:0] axis_out_xoreddata_tdata;
wire axis_out_xoreddata_tvalid;
wire axis_out_xoreddata_tready;
wire axis_out_xoreddata_tlast;

//  wire定義 SPM-> XORed
wire [128-1:0] axis_in_xordata_tdata;
wire axis_in_xordata_tvalid;
wire axis_in_xordata_tready;
wire axis_in_xordata_tlast;

// wire定義　AXI axim-> SPM
wire [128-1:0] axis_out_axim_tdata;
wire axis_out_axim_tvalid;
wire axis_out_axim_tready;
wire axis_out_axim_tlast;
// wire定義　SPM-> AXI axim
wire [128-1:0] axis_in_axim_tdata;
wire axis_in_axim_tvalid;
wire axis_in_axim_tready;
wire axis_in_axim_tlast;

// RAM interface
wire [63:0] ram_spm_1_wdata;
wire [63:0] ram_spm_1_rdata;
wire [63:0] ram_spm_1_addr;
wire ram_spm_1_wenable;
wire ram_spm_1_enable;

spm spm_inst (
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
  // AXI streamin if to AXI axim
  .axis_out_axim_spm_tdata(axis_in_axim_tdata),
  .axis_out_axim_spm_tvalid(axis_in_axim_tvalid),
  .axis_out_axim_spm_tready(axis_in_axim_tready),
  .axis_out_axim_spm_tlast(axis_in_axim_tlast),
  // AXI streamout if from AXI axim
  .axis_in_axim_spm_tdata(axis_out_axim_tdata),
  .axis_in_axim_spm_tvalid(axis_out_axim_tvalid),
  .axis_in_axim_spm_tready(axis_out_axim_tready),
  .axis_in_axim_spm_tlast(axis_out_axim_tlast),
  // AXI streamout if to MAC
  .axis_out_mac_spm_tdata(axis_in_mac_tdata),
  .axis_out_mac_spm_tvalid(axis_in_mac_tvalid),
  .axis_out_mac_spm_tready(axis_in_mac_tready),
  .axis_out_mac_spm_tlast(axis_in_mac_tlast),
  // AXI streamout if to XORed
  .axis_out_xored_spm_tdata(axis_in_xordata_tdata),
  .axis_out_xored_spm_tvalid(axis_in_xordata_tvalid),
  .axis_out_xored_spm_tready(axis_in_xordata_tready),
  .axis_out_xored_spm_tlast(axis_in_xordata_tlast),
  // AXI streamin if from XORed
  .axis_in_xored_spm_tdata(axis_out_xoreddata_tdata),
  .axis_in_xored_spm_tvalid(axis_out_xoreddata_tvalid),
  .axis_in_xored_spm_tready(axis_out_xoreddata_tready),
  .axis_in_xored_spm_tlast(axis_out_xoreddata_tlast),

  // Master Interface to DRAM
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
  // RAMへの接続
  .ram_spm_1_wdata(ram_spm_1_wdata),
  .ram_spm_1_rdata(ram_spm_1_rdata),
  .ram_spm_1_addr(ram_spm_1_addr),
  .ram_spm_1_wenable(ram_spm_1_wenable),
  .ram_spm_1_enable(ram_spm_1_enable)
);

// --- MAC Module Instance ---
mac mac_inst (
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

  // AXI streamin if from SPM
  .axis_in_mac_tdata(axis_in_mac_tdata),
  .axis_in_mac_tvalid(axis_in_mac_tvalid),
  .axis_in_mac_tready(axis_in_mac_tready),
  .axis_in_mac_tlast(axis_in_mac_tlast)
);

// --- XORed Module Instance ---
xored xor_inst (
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
  // AXI streamin if from AES
  .axis_in_aes_tdata(axis_in_aes_tdata),
  .axis_in_aes_tvalid(axis_in_aes_tvalid),
  .axis_in_aes_tready(axis_in_aes_tready),
  .axis_in_aes_tlast(axis_in_aes_tlast),
  // AXI streamin if from SPM
  .axis_in_xordata_tdata(axis_in_xordata_tdata),
  .axis_in_xordata_tvalid(axis_in_xordata_tvalid),
  .axis_in_xordata_tready(axis_in_xordata_tready),
  .axis_in_xordata_tlast(axis_in_xordata_tlast),
  // AXI streamout if to SPM
  .axis_out_xoreddata_tdata(axis_out_xoreddata_tdata),
  .axis_out_xoreddata_tvalid(axis_out_xoreddata_tvalid),
  .axis_out_xoreddata_tready(axis_out_xoreddata_tready),
  .axis_out_xoreddata_tlast(axis_out_xoreddata_tlast)
);

// --- AES Module Instance ---
aes aes_inst (
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

// --- AXI axim (axim) Module Instance ---
axim axim_inst (
  .CLK(CLK),
  .RST(RST),

  // Slave Control Interface
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
  // AXI streamout if to SPM
  .axis_out_axim_tdata(axis_out_axim_tdata),
  .axis_out_axim_tvalid(axis_out_axim_tvalid),
  .axis_out_axim_tready(axis_out_axim_tready),
  .axis_out_axim_tlast(axis_out_axim_tlast),
  // AXI streamin if from SPM
  .axis_in_axim_tdata(axis_in_axim_tdata),
  .axis_in_axim_tvalid(axis_in_axim_tvalid),
  .axis_in_axim_tready(axis_in_axim_tready),
  .axis_in_axim_tlast(axis_in_axim_tlast),
  // Slave Interface to LLC
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

ram_wrapper inst_wrapper(
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