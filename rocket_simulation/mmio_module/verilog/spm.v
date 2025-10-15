

module test_spm
(

);

  reg CLK;
  reg RST;
  reg [32-1:0] axi_s_ctrl_spm_awaddr;
  reg [4-1:0] axi_s_ctrl_spm_awcache;
  reg [3-1:0] axi_s_ctrl_spm_awprot;
  reg axi_s_ctrl_spm_awvalid;
  wire axi_s_ctrl_spm_awready;
  reg [64-1:0] axi_s_ctrl_spm_wdata;
  reg [8-1:0] axi_s_ctrl_spm_wstrb;
  reg axi_s_ctrl_spm_wvalid;
  wire axi_s_ctrl_spm_wready;
  wire [2-1:0] axi_s_ctrl_spm_bresp;
  wire axi_s_ctrl_spm_bvalid;
  reg axi_s_ctrl_spm_bready;
  reg [32-1:0] axi_s_ctrl_spm_araddr;
  reg [4-1:0] axi_s_ctrl_spm_arcache;
  reg [3-1:0] axi_s_ctrl_spm_arprot;
  reg axi_s_ctrl_spm_arvalid;
  wire axi_s_ctrl_spm_arready;
  wire [64-1:0] axi_s_ctrl_spm_rdata;
  wire [2-1:0] axi_s_ctrl_spm_rresp;
  wire axi_s_ctrl_spm_rvalid;
  reg axi_s_ctrl_spm_rready;
  wire [32-1:0] axi_m_dram_awaddr;
  wire [8-1:0] axi_m_dram_awlen;
  wire [3-1:0] axi_m_dram_awsize;
  wire [2-1:0] axi_m_dram_awburst;
  wire [1-1:0] axi_m_dram_awlock;
  wire [4-1:0] axi_m_dram_awcache;
  wire [3-1:0] axi_m_dram_awprot;
  wire [4-1:0] axi_m_dram_awqos;
  wire [2-1:0] axi_m_dram_awuser;
  wire axi_m_dram_awvalid;
  reg axi_m_dram_awready;
  wire [128-1:0] axi_m_dram_wdata;
  wire [16-1:0] axi_m_dram_wstrb;
  wire axi_m_dram_wlast;
  wire axi_m_dram_wvalid;
  reg axi_m_dram_wready;
  reg [2-1:0] axi_m_dram_bresp;
  reg axi_m_dram_bvalid;
  wire axi_m_dram_bready;
  wire [32-1:0] axi_m_dram_araddr;
  wire [8-1:0] axi_m_dram_arlen;
  wire [3-1:0] axi_m_dram_arsize;
  wire [2-1:0] axi_m_dram_arburst;
  wire [1-1:0] axi_m_dram_arlock;
  wire [4-1:0] axi_m_dram_arcache;
  wire [3-1:0] axi_m_dram_arprot;
  wire [4-1:0] axi_m_dram_arqos;
  wire [2-1:0] axi_m_dram_aruser;
  wire axi_m_dram_arvalid;
  reg axi_m_dram_arready;
  reg [128-1:0] axi_m_dram_rdata;
  reg [2-1:0] axi_m_dram_rresp;
  reg axi_m_dram_rlast;
  reg axi_m_dram_rvalid;
  wire axi_m_dram_rready;
  wire [128-1:0] axis_out_mac_spm_tdata;
  wire axis_out_mac_spm_tvalid;
  reg axis_out_mac_spm_tready;
  wire axis_out_mac_spm_tlast;
  wire [128-1:0] axis_out_axim_spm_tdata;
  wire axis_out_axim_spm_tvalid;
  reg axis_out_axim_spm_tready;
  wire axis_out_axim_spm_tlast;
  reg [128-1:0] axis_in_axim_spm_tdata;
  reg axis_in_axim_spm_tvalid;
  wire axis_in_axim_spm_tready;
  reg axis_in_axim_spm_tlast;
  wire [128-1:0] axis_out_xored_spm_tdata;
  wire axis_out_xored_spm_tvalid;
  reg axis_out_xored_spm_tready;
  wire axis_out_xored_spm_tlast;
  reg [128-1:0] axis_in_xored_spm_tdata;
  reg axis_in_xored_spm_tvalid;
  wire axis_in_xored_spm_tready;
  reg axis_in_xored_spm_tlast;
  reg [9-1:0] ram_spm_1_addr;
  wire [64-1:0] ram_spm_1_rdata;
  reg [64-1:0] ram_spm_1_wdata;
  reg ram_spm_1_wenable;
  reg ram_spm_1_enable;
  reg [32-1:0] maxi_spm_awaddr;
  wire [4-1:0] maxi_spm_awcache;
  wire [3-1:0] maxi_spm_awprot;
  reg maxi_spm_awvalid;
  wire maxi_spm_awready;
  assign maxi_spm_awcache = 3;
  assign maxi_spm_awprot = 0;
  wire [64-1:0] maxi_spm_wdata;
  wire [8-1:0] maxi_spm_wstrb;
  wire maxi_spm_wvalid;
  wire maxi_spm_wready;
  reg [64-1:0] _maxi_spm_wdata_sb_0;
  reg [8-1:0] _maxi_spm_wstrb_sb_0;
  reg _maxi_spm_wvalid_sb_0;
  wire _maxi_spm_wready_sb_0;
  wire [8-1:0] _sb_maxi_spm_writedata_s_value_0;
  assign _sb_maxi_spm_writedata_s_value_0 = _maxi_spm_wstrb_sb_0;
  wire [64-1:0] _sb_maxi_spm_writedata_s_value_1;
  assign _sb_maxi_spm_writedata_s_value_1 = _maxi_spm_wdata_sb_0;
  wire [72-1:0] _sb_maxi_spm_writedata_s_data_2;
  assign _sb_maxi_spm_writedata_s_data_2 = { _sb_maxi_spm_writedata_s_value_0, _sb_maxi_spm_writedata_s_value_1 };
  wire _sb_maxi_spm_writedata_s_valid_3;
  assign _sb_maxi_spm_writedata_s_valid_3 = _maxi_spm_wvalid_sb_0;
  wire _sb_maxi_spm_writedata_m_ready_4;
  assign _sb_maxi_spm_writedata_m_ready_4 = maxi_spm_wready;
  reg [72-1:0] _sb_maxi_spm_writedata_data_5;
  reg _sb_maxi_spm_writedata_valid_6;
  wire _sb_maxi_spm_writedata_ready_7;
  reg [72-1:0] _sb_maxi_spm_writedata_tmp_data_8;
  reg _sb_maxi_spm_writedata_tmp_valid_9;
  wire [72-1:0] _sb_maxi_spm_writedata_next_data_10;
  wire _sb_maxi_spm_writedata_next_valid_11;
  assign _sb_maxi_spm_writedata_ready_7 = !_sb_maxi_spm_writedata_tmp_valid_9;
  assign _sb_maxi_spm_writedata_next_data_10 = (_sb_maxi_spm_writedata_tmp_valid_9)? _sb_maxi_spm_writedata_tmp_data_8 : _sb_maxi_spm_writedata_s_data_2;
  assign _sb_maxi_spm_writedata_next_valid_11 = _sb_maxi_spm_writedata_tmp_valid_9 || _sb_maxi_spm_writedata_s_valid_3;
  wire [8-1:0] _sb_maxi_spm_writedata_m_value_12;
  assign _sb_maxi_spm_writedata_m_value_12 = _sb_maxi_spm_writedata_data_5[71:64];
  wire [64-1:0] _sb_maxi_spm_writedata_m_value_13;
  assign _sb_maxi_spm_writedata_m_value_13 = _sb_maxi_spm_writedata_data_5[63:0];
  assign _maxi_spm_wready_sb_0 = _sb_maxi_spm_writedata_ready_7;
  assign maxi_spm_wdata = _sb_maxi_spm_writedata_m_value_13;
  assign maxi_spm_wstrb = _sb_maxi_spm_writedata_m_value_12;
  assign maxi_spm_wvalid = _sb_maxi_spm_writedata_valid_6;
  wire [2-1:0] maxi_spm_bresp;
  wire maxi_spm_bvalid;
  wire maxi_spm_bready;
  assign maxi_spm_bready = 1;
  reg [32-1:0] maxi_spm_araddr;
  wire [4-1:0] maxi_spm_arcache;
  wire [3-1:0] maxi_spm_arprot;
  reg maxi_spm_arvalid;
  wire maxi_spm_arready;
  assign maxi_spm_arcache = 3;
  assign maxi_spm_arprot = 0;
  wire [64-1:0] maxi_spm_rdata;
  wire [2-1:0] maxi_spm_rresp;
  wire maxi_spm_rvalid;
  wire maxi_spm_rready;
  wire [64-1:0] _maxi_spm_rdata_sb_0;
  wire _maxi_spm_rvalid_sb_0;
  wire _maxi_spm_rready_sb_0;
  wire [64-1:0] _sb_maxi_spm_readdata_s_value_14;
  assign _sb_maxi_spm_readdata_s_value_14 = maxi_spm_rdata;
  wire [64-1:0] _sb_maxi_spm_readdata_s_data_15;
  assign _sb_maxi_spm_readdata_s_data_15 = { _sb_maxi_spm_readdata_s_value_14 };
  wire _sb_maxi_spm_readdata_s_valid_16;
  assign _sb_maxi_spm_readdata_s_valid_16 = maxi_spm_rvalid;
  wire _sb_maxi_spm_readdata_m_ready_17;
  assign _sb_maxi_spm_readdata_m_ready_17 = _maxi_spm_rready_sb_0;
  reg [64-1:0] _sb_maxi_spm_readdata_data_18;
  reg _sb_maxi_spm_readdata_valid_19;
  wire _sb_maxi_spm_readdata_ready_20;
  reg [64-1:0] _sb_maxi_spm_readdata_tmp_data_21;
  reg _sb_maxi_spm_readdata_tmp_valid_22;
  wire [64-1:0] _sb_maxi_spm_readdata_next_data_23;
  wire _sb_maxi_spm_readdata_next_valid_24;
  assign _sb_maxi_spm_readdata_ready_20 = !_sb_maxi_spm_readdata_tmp_valid_22;
  assign _sb_maxi_spm_readdata_next_data_23 = (_sb_maxi_spm_readdata_tmp_valid_22)? _sb_maxi_spm_readdata_tmp_data_21 : _sb_maxi_spm_readdata_s_data_15;
  assign _sb_maxi_spm_readdata_next_valid_24 = _sb_maxi_spm_readdata_tmp_valid_22 || _sb_maxi_spm_readdata_s_valid_16;
  wire [64-1:0] _sb_maxi_spm_readdata_m_value_25;
  assign _sb_maxi_spm_readdata_m_value_25 = _sb_maxi_spm_readdata_data_18[63:0];
  assign _maxi_spm_rdata_sb_0 = _sb_maxi_spm_readdata_m_value_25;
  assign _maxi_spm_rvalid_sb_0 = _sb_maxi_spm_readdata_valid_19;
  assign maxi_spm_rready = _sb_maxi_spm_readdata_ready_20;
  reg [3-1:0] _maxi_spm_outstanding_wcount;
  wire _maxi_spm_has_outstanding_write;
  assign _maxi_spm_has_outstanding_write = (_maxi_spm_outstanding_wcount > 0) || maxi_spm_awvalid;
  wire [128-1:0] s_axis_spm_tdata;
  wire s_axis_spm_tvalid;
  wire s_axis_spm_tready;
  wire s_axis_spm_tlast;
  wire _s_axis_spm_read_req_fifo_enq;
  wire [105-1:0] _s_axis_spm_read_req_fifo_wdata;
  wire _s_axis_spm_read_req_fifo_full;
  wire _s_axis_spm_read_req_fifo_almost_full;
  wire _s_axis_spm_read_req_fifo_deq;
  wire [105-1:0] _s_axis_spm_read_req_fifo_rdata;
  wire _s_axis_spm_read_req_fifo_empty;
  wire _s_axis_spm_read_req_fifo_almost_empty;
  assign _s_axis_spm_read_req_fifo_enq = 0;
  assign _s_axis_spm_read_req_fifo_wdata = 'hx;
  assign _s_axis_spm_read_req_fifo_deq = 0;

  _s_axis_spm_read_req_fifo
  inst__s_axis_spm_read_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._s_axis_spm_read_req_fifo_enq(_s_axis_spm_read_req_fifo_enq),
    ._s_axis_spm_read_req_fifo_wdata(_s_axis_spm_read_req_fifo_wdata),
    ._s_axis_spm_read_req_fifo_full(_s_axis_spm_read_req_fifo_full),
    ._s_axis_spm_read_req_fifo_almost_full(_s_axis_spm_read_req_fifo_almost_full),
    ._s_axis_spm_read_req_fifo_deq(_s_axis_spm_read_req_fifo_deq),
    ._s_axis_spm_read_req_fifo_rdata(_s_axis_spm_read_req_fifo_rdata),
    ._s_axis_spm_read_req_fifo_empty(_s_axis_spm_read_req_fifo_empty),
    ._s_axis_spm_read_req_fifo_almost_empty(_s_axis_spm_read_req_fifo_almost_empty)
  );

  reg [4-1:0] count__s_axis_spm_read_req_fifo;
  wire [8-1:0] _s_axis_spm_read_op_sel_fifo;
  wire [32-1:0] _s_axis_spm_read_local_addr_fifo;
  wire [32-1:0] _s_axis_spm_read_local_stride_fifo;
  wire [33-1:0] _s_axis_spm_read_local_size_fifo;
  wire [8-1:0] unpack_read_req_op_sel_26;
  wire [32-1:0] unpack_read_req_local_addr_27;
  wire [32-1:0] unpack_read_req_local_stride_28;
  wire [33-1:0] unpack_read_req_local_size_29;
  assign unpack_read_req_op_sel_26 = _s_axis_spm_read_req_fifo_rdata[104:97];
  assign unpack_read_req_local_addr_27 = _s_axis_spm_read_req_fifo_rdata[96:65];
  assign unpack_read_req_local_stride_28 = _s_axis_spm_read_req_fifo_rdata[64:33];
  assign unpack_read_req_local_size_29 = _s_axis_spm_read_req_fifo_rdata[32:0];
  assign _s_axis_spm_read_op_sel_fifo = unpack_read_req_op_sel_26;
  assign _s_axis_spm_read_local_addr_fifo = unpack_read_req_local_addr_27;
  assign _s_axis_spm_read_local_stride_fifo = unpack_read_req_local_stride_28;
  assign _s_axis_spm_read_local_size_fifo = unpack_read_req_local_size_29;
  reg [8-1:0] _s_axis_spm_read_op_sel_buf;
  reg [32-1:0] _s_axis_spm_read_local_addr_buf;
  reg [32-1:0] _s_axis_spm_read_local_stride_buf;
  reg [33-1:0] _s_axis_spm_read_local_size_buf;
  reg _s_axis_spm_read_data_busy;
  wire _s_axis_spm_read_data_idle;
  wire _s_axis_spm_read_idle;
  assign _s_axis_spm_read_data_idle = _s_axis_spm_read_req_fifo_empty && !_s_axis_spm_read_data_busy;
  assign _s_axis_spm_read_idle = _s_axis_spm_read_data_idle;
  reg [128-1:0] m_axis_spm_tdata;
  reg m_axis_spm_tvalid;
  wire m_axis_spm_tready;
  reg m_axis_spm_tlast;
  wire _m_axis_spm_write_req_fifo_enq;
  wire [105-1:0] _m_axis_spm_write_req_fifo_wdata;
  wire _m_axis_spm_write_req_fifo_full;
  wire _m_axis_spm_write_req_fifo_almost_full;
  wire _m_axis_spm_write_req_fifo_deq;
  wire [105-1:0] _m_axis_spm_write_req_fifo_rdata;
  wire _m_axis_spm_write_req_fifo_empty;
  wire _m_axis_spm_write_req_fifo_almost_empty;
  assign _m_axis_spm_write_req_fifo_enq = 0;
  assign _m_axis_spm_write_req_fifo_wdata = 'hx;
  assign _m_axis_spm_write_req_fifo_deq = 0;

  _m_axis_spm_write_req_fifo
  inst__m_axis_spm_write_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._m_axis_spm_write_req_fifo_enq(_m_axis_spm_write_req_fifo_enq),
    ._m_axis_spm_write_req_fifo_wdata(_m_axis_spm_write_req_fifo_wdata),
    ._m_axis_spm_write_req_fifo_full(_m_axis_spm_write_req_fifo_full),
    ._m_axis_spm_write_req_fifo_almost_full(_m_axis_spm_write_req_fifo_almost_full),
    ._m_axis_spm_write_req_fifo_deq(_m_axis_spm_write_req_fifo_deq),
    ._m_axis_spm_write_req_fifo_rdata(_m_axis_spm_write_req_fifo_rdata),
    ._m_axis_spm_write_req_fifo_empty(_m_axis_spm_write_req_fifo_empty),
    ._m_axis_spm_write_req_fifo_almost_empty(_m_axis_spm_write_req_fifo_almost_empty)
  );

  reg [4-1:0] count__m_axis_spm_write_req_fifo;
  wire [8-1:0] _m_axis_spm_write_op_sel_fifo;
  wire [32-1:0] _m_axis_spm_write_local_addr_fifo;
  wire [32-1:0] _m_axis_spm_write_local_stride_fifo;
  wire [33-1:0] _m_axis_spm_write_size_fifo;
  wire [8-1:0] unpack_write_req_op_sel_30;
  wire [32-1:0] unpack_write_req_local_addr_31;
  wire [32-1:0] unpack_write_req_local_stride_32;
  wire [33-1:0] unpack_write_req_local_size_33;
  assign unpack_write_req_op_sel_30 = _m_axis_spm_write_req_fifo_rdata[104:97];
  assign unpack_write_req_local_addr_31 = _m_axis_spm_write_req_fifo_rdata[96:65];
  assign unpack_write_req_local_stride_32 = _m_axis_spm_write_req_fifo_rdata[64:33];
  assign unpack_write_req_local_size_33 = _m_axis_spm_write_req_fifo_rdata[32:0];
  assign _m_axis_spm_write_op_sel_fifo = unpack_write_req_op_sel_30;
  assign _m_axis_spm_write_local_addr_fifo = unpack_write_req_local_addr_31;
  assign _m_axis_spm_write_local_stride_fifo = unpack_write_req_local_stride_32;
  assign _m_axis_spm_write_size_fifo = unpack_write_req_local_size_33;
  reg [8-1:0] _m_axis_spm_write_op_sel_buf;
  reg [32-1:0] _m_axis_spm_write_local_addr_buf;
  reg [32-1:0] _m_axis_spm_write_local_stride_buf;
  reg [33-1:0] _m_axis_spm_write_size_buf;
  reg _m_axis_spm_write_data_busy;
  wire _m_axis_spm_write_data_idle;
  wire _m_axis_spm_write_idle;
  assign _m_axis_spm_write_data_idle = _m_axis_spm_write_req_fifo_empty && !_m_axis_spm_write_data_busy;
  assign _m_axis_spm_write_idle = _m_axis_spm_write_data_idle;
  wire [32-1:0] _tmp_34;
  assign _tmp_34 = maxi_spm_awaddr;

  always @(*) begin
    axi_s_ctrl_spm_awaddr = _tmp_34;
  end

  wire [4-1:0] _tmp_35;
  assign _tmp_35 = maxi_spm_awcache;

  always @(*) begin
    axi_s_ctrl_spm_awcache = _tmp_35;
  end

  wire [3-1:0] _tmp_36;
  assign _tmp_36 = maxi_spm_awprot;

  always @(*) begin
    axi_s_ctrl_spm_awprot = _tmp_36;
  end

  wire _tmp_37;
  assign _tmp_37 = maxi_spm_awvalid;

  always @(*) begin
    axi_s_ctrl_spm_awvalid = _tmp_37;
  end

  assign maxi_spm_awready = axi_s_ctrl_spm_awready;
  wire [64-1:0] _tmp_38;
  assign _tmp_38 = maxi_spm_wdata;

  always @(*) begin
    axi_s_ctrl_spm_wdata = _tmp_38;
  end

  wire [8-1:0] _tmp_39;
  assign _tmp_39 = maxi_spm_wstrb;

  always @(*) begin
    axi_s_ctrl_spm_wstrb = _tmp_39;
  end

  wire _tmp_40;
  assign _tmp_40 = maxi_spm_wvalid;

  always @(*) begin
    axi_s_ctrl_spm_wvalid = _tmp_40;
  end

  assign maxi_spm_wready = axi_s_ctrl_spm_wready;
  assign maxi_spm_bresp = axi_s_ctrl_spm_bresp;
  assign maxi_spm_bvalid = axi_s_ctrl_spm_bvalid;
  wire _tmp_41;
  assign _tmp_41 = maxi_spm_bready;

  always @(*) begin
    axi_s_ctrl_spm_bready = _tmp_41;
  end

  wire [32-1:0] _tmp_42;
  assign _tmp_42 = maxi_spm_araddr;

  always @(*) begin
    axi_s_ctrl_spm_araddr = _tmp_42;
  end

  wire [4-1:0] _tmp_43;
  assign _tmp_43 = maxi_spm_arcache;

  always @(*) begin
    axi_s_ctrl_spm_arcache = _tmp_43;
  end

  wire [3-1:0] _tmp_44;
  assign _tmp_44 = maxi_spm_arprot;

  always @(*) begin
    axi_s_ctrl_spm_arprot = _tmp_44;
  end

  wire _tmp_45;
  assign _tmp_45 = maxi_spm_arvalid;

  always @(*) begin
    axi_s_ctrl_spm_arvalid = _tmp_45;
  end

  assign maxi_spm_arready = axi_s_ctrl_spm_arready;
  assign maxi_spm_rdata = axi_s_ctrl_spm_rdata;
  assign maxi_spm_rresp = axi_s_ctrl_spm_rresp;
  assign maxi_spm_rvalid = axi_s_ctrl_spm_rvalid;
  wire _tmp_46;
  assign _tmp_46 = maxi_spm_rready;

  always @(*) begin
    axi_s_ctrl_spm_rready = _tmp_46;
  end

  assign s_axis_spm_tdata = axis_out_mac_spm_tdata;
  assign s_axis_spm_tvalid = axis_out_mac_spm_tvalid;
  wire _tmp_47;
  assign _tmp_47 = s_axis_spm_tready;

  always @(*) begin
    axis_out_mac_spm_tready = _tmp_47;
  end

  assign s_axis_spm_tlast = axis_out_mac_spm_tlast;
  wire [128-1:0] _tmp_48;
  assign _tmp_48 = m_axis_spm_tdata;

  always @(*) begin
    axis_in_axim_spm_tdata = _tmp_48;
  end

  wire _tmp_49;
  assign _tmp_49 = m_axis_spm_tvalid;

  always @(*) begin
    axis_in_axim_spm_tvalid = _tmp_49;
  end

  assign m_axis_spm_tready = axis_in_axim_spm_tready;
  wire _tmp_50;
  assign _tmp_50 = m_axis_spm_tlast;

  always @(*) begin
    axis_in_axim_spm_tlast = _tmp_50;
  end

  reg [128-1:0] read_data_51;
  wire [32-1:0] memory_awaddr;
  wire [8-1:0] memory_awlen;
  wire [3-1:0] memory_awsize;
  wire [2-1:0] memory_awburst;
  wire [1-1:0] memory_awlock;
  wire [4-1:0] memory_awcache;
  wire [3-1:0] memory_awprot;
  wire [4-1:0] memory_awqos;
  wire [2-1:0] memory_awuser;
  wire memory_awvalid;
  reg memory_awready;
  wire [128-1:0] memory_wdata;
  wire [16-1:0] memory_wstrb;
  wire memory_wlast;
  wire memory_wvalid;
  wire memory_wready;
  wire [2-1:0] memory_bresp;
  reg memory_bvalid;
  wire memory_bready;
  assign memory_bresp = 0;
  wire [32-1:0] memory_araddr;
  wire [8-1:0] memory_arlen;
  wire [3-1:0] memory_arsize;
  wire [2-1:0] memory_arburst;
  wire [1-1:0] memory_arlock;
  wire [4-1:0] memory_arcache;
  wire [3-1:0] memory_arprot;
  wire [4-1:0] memory_arqos;
  wire [2-1:0] memory_aruser;
  wire memory_arvalid;
  reg memory_arready;
  reg [128-1:0] memory_rdata;
  wire [2-1:0] memory_rresp;
  reg memory_rlast;
  reg memory_rvalid;
  wire memory_rready;
  assign memory_rresp = 0;
  reg [32-1:0] _memory_waddr_fsm;
  localparam _memory_waddr_fsm_init = 0;
  reg [32-1:0] _memory_wdata_fsm;
  localparam _memory_wdata_fsm_init = 0;
  reg [32-1:0] _memory_raddr_fsm;
  localparam _memory_raddr_fsm_init = 0;
  reg [32-1:0] _memory_rdata_fsm;
  localparam _memory_rdata_fsm_init = 0;
  wire _memory_wreq_fifo_enq;
  wire [41-1:0] _memory_wreq_fifo_wdata;
  wire _memory_wreq_fifo_full;
  wire _memory_wreq_fifo_almost_full;
  wire _memory_wreq_fifo_deq;
  wire [41-1:0] _memory_wreq_fifo_rdata;
  wire _memory_wreq_fifo_empty;
  wire _memory_wreq_fifo_almost_empty;

  _memory_wreq_fifo
  inst__memory_wreq_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._memory_wreq_fifo_enq(_memory_wreq_fifo_enq),
    ._memory_wreq_fifo_wdata(_memory_wreq_fifo_wdata),
    ._memory_wreq_fifo_full(_memory_wreq_fifo_full),
    ._memory_wreq_fifo_almost_full(_memory_wreq_fifo_almost_full),
    ._memory_wreq_fifo_deq(_memory_wreq_fifo_deq),
    ._memory_wreq_fifo_rdata(_memory_wreq_fifo_rdata),
    ._memory_wreq_fifo_empty(_memory_wreq_fifo_empty),
    ._memory_wreq_fifo_almost_empty(_memory_wreq_fifo_almost_empty)
  );

  reg [4-1:0] count__memory_wreq_fifo;
  wire _memory_rreq_fifo_enq;
  wire [41-1:0] _memory_rreq_fifo_wdata;
  wire _memory_rreq_fifo_full;
  wire _memory_rreq_fifo_almost_full;
  wire _memory_rreq_fifo_deq;
  wire [41-1:0] _memory_rreq_fifo_rdata;
  wire _memory_rreq_fifo_empty;
  wire _memory_rreq_fifo_almost_empty;

  _memory_rreq_fifo
  inst__memory_rreq_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._memory_rreq_fifo_enq(_memory_rreq_fifo_enq),
    ._memory_rreq_fifo_wdata(_memory_rreq_fifo_wdata),
    ._memory_rreq_fifo_full(_memory_rreq_fifo_full),
    ._memory_rreq_fifo_almost_full(_memory_rreq_fifo_almost_full),
    ._memory_rreq_fifo_deq(_memory_rreq_fifo_deq),
    ._memory_rreq_fifo_rdata(_memory_rreq_fifo_rdata),
    ._memory_rreq_fifo_empty(_memory_rreq_fifo_empty),
    ._memory_rreq_fifo_almost_empty(_memory_rreq_fifo_almost_empty)
  );

  reg [4-1:0] count__memory_rreq_fifo;
  wire _memory_wdata_fifo_enq;
  wire [145-1:0] _memory_wdata_fifo_wdata;
  wire _memory_wdata_fifo_full;
  wire _memory_wdata_fifo_almost_full;
  wire _memory_wdata_fifo_deq;
  wire [145-1:0] _memory_wdata_fifo_rdata;
  wire _memory_wdata_fifo_empty;
  wire _memory_wdata_fifo_almost_empty;

  _memory_wdata_fifo
  inst__memory_wdata_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._memory_wdata_fifo_enq(_memory_wdata_fifo_enq),
    ._memory_wdata_fifo_wdata(_memory_wdata_fifo_wdata),
    ._memory_wdata_fifo_full(_memory_wdata_fifo_full),
    ._memory_wdata_fifo_almost_full(_memory_wdata_fifo_almost_full),
    ._memory_wdata_fifo_deq(_memory_wdata_fifo_deq),
    ._memory_wdata_fifo_rdata(_memory_wdata_fifo_rdata),
    ._memory_wdata_fifo_empty(_memory_wdata_fifo_empty),
    ._memory_wdata_fifo_almost_empty(_memory_wdata_fifo_almost_empty)
  );

  reg [4-1:0] count__memory_wdata_fifo;
  assign memory_wready = !_memory_wdata_fifo_almost_full;
  wire [128-1:0] pack_write_data_wdata_52;
  wire [16-1:0] pack_write_data_wstrb_53;
  wire [1-1:0] pack_write_data_wlast_54;
  assign pack_write_data_wdata_52 = memory_wdata;
  assign pack_write_data_wstrb_53 = memory_wstrb;
  assign pack_write_data_wlast_54 = memory_wlast;
  wire [145-1:0] pack_write_data_packed_55;
  assign pack_write_data_packed_55 = { pack_write_data_wlast_54, pack_write_data_wstrb_53, pack_write_data_wdata_52 };
  assign _memory_wdata_fifo_wdata = (memory_wvalid && memory_wready)? pack_write_data_packed_55 : 'hx;
  assign _memory_wdata_fifo_enq = (memory_wvalid && memory_wready)? memory_wvalid && memory_wready && !_memory_wdata_fifo_almost_full : 0;
  localparam _tmp_56 = 1;
  wire [_tmp_56-1:0] _tmp_57;
  assign _tmp_57 = !_memory_wdata_fifo_almost_full;
  reg [_tmp_56-1:0] __tmp_57_1;
  reg [8-1:0] _memory_mem [0:2**20-1];

  initial begin
    $readmemh("memimg_spm.out", _memory_mem);
  end

  reg [33-1:0] _write_count;
  reg [32-1:0] _write_addr;
  reg [33-1:0] _read_count;
  reg [32-1:0] _read_addr;
  reg [33-1:0] _sleep_interval_count;
  reg [33-1:0] _keep_sleep_count;
  wire [32-1:0] pack_write_req_global_addr_58;
  wire [9-1:0] pack_write_req_size_59;
  assign pack_write_req_global_addr_58 = memory_awaddr;
  assign pack_write_req_size_59 = memory_awlen + 1;
  wire [41-1:0] pack_write_req_packed_60;
  assign pack_write_req_packed_60 = { pack_write_req_global_addr_58, pack_write_req_size_59 };
  assign _memory_wreq_fifo_wdata = ((_memory_waddr_fsm == 11) && memory_awvalid && memory_awready)? pack_write_req_packed_60 : 'hx;
  assign _memory_wreq_fifo_enq = ((_memory_waddr_fsm == 11) && memory_awvalid && memory_awready)? (_memory_waddr_fsm == 11) && memory_awvalid && memory_awready && !_memory_wreq_fifo_almost_full : 0;
  localparam _tmp_61 = 1;
  wire [_tmp_61-1:0] _tmp_62;
  assign _tmp_62 = !_memory_wreq_fifo_almost_full;
  reg [_tmp_61-1:0] __tmp_62_1;
  wire [32-1:0] unpack_write_req_global_addr_63;
  wire [9-1:0] unpack_write_req_size_64;
  assign unpack_write_req_global_addr_63 = _memory_wreq_fifo_rdata[40:9];
  assign unpack_write_req_size_64 = _memory_wreq_fifo_rdata[8:0];
  assign _memory_wreq_fifo_deq = ((_memory_wdata_fsm == 0) && !_memory_wreq_fifo_empty && !_memory_wreq_fifo_empty)? 1 : 0;
  wire [128-1:0] pack_write_data_wdata_65;
  wire [16-1:0] pack_write_data_wstrb_66;
  wire [1-1:0] pack_write_data_wlast_67;
  assign pack_write_data_wdata_65 = _memory_wdata_fifo_rdata[127:0];
  assign pack_write_data_wstrb_66 = _memory_wdata_fifo_rdata[143:128];
  assign pack_write_data_wlast_67 = _memory_wdata_fifo_rdata[144];
  wire write_data_wvalid_68;
  assign write_data_wvalid_68 = !_memory_wdata_fifo_empty;
  wire write_data_wready_69;
  assign write_data_wready_69 = (_memory_wdata_fsm == 1) && (_sleep_interval_count != 15);
  assign _memory_wdata_fifo_deq = (write_data_wready_69 && !_memory_wdata_fifo_empty && !_memory_wdata_fifo_empty)? 1 : 0;
  wire [32-1:0] pack_read_req_global_addr_70;
  wire [9-1:0] pack_read_req_size_71;
  assign pack_read_req_global_addr_70 = memory_araddr;
  assign pack_read_req_size_71 = memory_arlen + 1;
  wire [41-1:0] pack_read_req_packed_72;
  assign pack_read_req_packed_72 = { pack_read_req_global_addr_70, pack_read_req_size_71 };
  assign _memory_rreq_fifo_wdata = ((_memory_raddr_fsm == 1) && memory_arvalid && memory_arready)? pack_read_req_packed_72 : 'hx;
  assign _memory_rreq_fifo_enq = ((_memory_raddr_fsm == 1) && memory_arvalid && memory_arready)? (_memory_raddr_fsm == 1) && memory_arvalid && memory_arready && !_memory_rreq_fifo_almost_full : 0;
  localparam _tmp_73 = 1;
  wire [_tmp_73-1:0] _tmp_74;
  assign _tmp_74 = !_memory_rreq_fifo_almost_full;
  reg [_tmp_73-1:0] __tmp_74_1;
  wire [32-1:0] unpack_read_req_global_addr_75;
  wire [9-1:0] unpack_read_req_size_76;
  assign unpack_read_req_global_addr_75 = _memory_rreq_fifo_rdata[40:9];
  assign unpack_read_req_size_76 = _memory_rreq_fifo_rdata[8:0];
  assign _memory_rreq_fifo_deq = ((_memory_rdata_fsm == 0) && !_memory_rreq_fifo_empty && !_memory_rreq_fifo_empty)? 1 : 0;
  reg [32-1:0] _d1__memory_rdata_fsm;
  reg __memory_rdata_fsm_cond_11_0_1;
  assign memory_awaddr = axi_m_dram_awaddr;
  assign memory_awlen = axi_m_dram_awlen;
  assign memory_awsize = axi_m_dram_awsize;
  assign memory_awburst = axi_m_dram_awburst;
  assign memory_awlock = axi_m_dram_awlock;
  assign memory_awcache = axi_m_dram_awcache;
  assign memory_awprot = axi_m_dram_awprot;
  assign memory_awqos = axi_m_dram_awqos;
  assign memory_awuser = axi_m_dram_awuser;
  assign memory_awvalid = axi_m_dram_awvalid;
  wire _tmp_77;
  assign _tmp_77 = memory_awready;

  always @(*) begin
    axi_m_dram_awready = _tmp_77;
  end

  assign memory_wdata = axi_m_dram_wdata;
  assign memory_wstrb = axi_m_dram_wstrb;
  assign memory_wlast = axi_m_dram_wlast;
  assign memory_wvalid = axi_m_dram_wvalid;
  wire _tmp_78;
  assign _tmp_78 = memory_wready;

  always @(*) begin
    axi_m_dram_wready = _tmp_78;
  end

  wire [2-1:0] _tmp_79;
  assign _tmp_79 = memory_bresp;

  always @(*) begin
    axi_m_dram_bresp = _tmp_79;
  end

  wire _tmp_80;
  assign _tmp_80 = memory_bvalid;

  always @(*) begin
    axi_m_dram_bvalid = _tmp_80;
  end

  assign memory_bready = axi_m_dram_bready;
  assign memory_araddr = axi_m_dram_araddr;
  assign memory_arlen = axi_m_dram_arlen;
  assign memory_arsize = axi_m_dram_arsize;
  assign memory_arburst = axi_m_dram_arburst;
  assign memory_arlock = axi_m_dram_arlock;
  assign memory_arcache = axi_m_dram_arcache;
  assign memory_arprot = axi_m_dram_arprot;
  assign memory_arqos = axi_m_dram_arqos;
  assign memory_aruser = axi_m_dram_aruser;
  assign memory_arvalid = axi_m_dram_arvalid;
  wire _tmp_81;
  assign _tmp_81 = memory_arready;

  always @(*) begin
    axi_m_dram_arready = _tmp_81;
  end

  wire [128-1:0] _tmp_82;
  assign _tmp_82 = memory_rdata;

  always @(*) begin
    axi_m_dram_rdata = _tmp_82;
  end

  wire [2-1:0] _tmp_83;
  assign _tmp_83 = memory_rresp;

  always @(*) begin
    axi_m_dram_rresp = _tmp_83;
  end

  wire _tmp_84;
  assign _tmp_84 = memory_rlast;

  always @(*) begin
    axi_m_dram_rlast = _tmp_84;
  end

  wire _tmp_85;
  assign _tmp_85 = memory_rvalid;

  always @(*) begin
    axi_m_dram_rvalid = _tmp_85;
  end

  assign memory_rready = axi_m_dram_rready;
  reg [128-1:0] write_data_86;
  reg [1-1:0] complete;
  reg [32-1:0] th_ctrl;
  localparam th_ctrl_init = 0;
  reg _maxi_spm_raddr_cond_0_1;
  reg signed [64-1:0] axim_rdata_87;
  reg _maxi_spm_waddr_cond_0_1;
  reg _maxi_spm_wdata_cond_0_1;
  reg _maxi_spm_waddr_cond_1_1;
  reg _maxi_spm_wdata_cond_1_1;
  reg _maxi_spm_waddr_cond_2_1;
  reg _maxi_spm_wdata_cond_2_1;
  reg _maxi_spm_waddr_cond_3_1;
  reg _maxi_spm_wdata_cond_3_1;
  reg _maxi_spm_waddr_cond_4_1;
  reg _maxi_spm_wdata_cond_4_1;
  reg _maxi_spm_waddr_cond_5_1;
  reg _maxi_spm_wdata_cond_5_1;
  reg signed [32-1:0] _th_ctrl_i_1;
  reg _m_axis_spm_cond_0_1;
  reg _maxi_spm_raddr_cond_1_1;
  reg signed [64-1:0] axim_rdata_88;
  reg _maxi_spm_waddr_cond_6_1;
  reg _maxi_spm_wdata_cond_6_1;
  reg _maxi_spm_waddr_cond_7_1;
  reg _maxi_spm_wdata_cond_7_1;
  reg _maxi_spm_waddr_cond_8_1;
  reg _maxi_spm_wdata_cond_8_1;
  reg _maxi_spm_waddr_cond_9_1;
  reg _maxi_spm_wdata_cond_9_1;
  reg _maxi_spm_waddr_cond_10_1;
  reg _maxi_spm_wdata_cond_10_1;
  reg _maxi_spm_waddr_cond_11_1;
  reg _maxi_spm_wdata_cond_11_1;
  reg _maxi_spm_raddr_cond_2_1;
  reg signed [64-1:0] axim_rdata_89;
  assign _maxi_spm_rready_sb_0 = (th_ctrl == 4) || (th_ctrl == 48) || (th_ctrl == 86);
  reg [32-1:0] fsm;
  localparam fsm_init = 0;
  reg signed [32-1:0] rdata_90;
  reg signed [32-1:0] rdata_91;
  reg signed [32-1:0] rdata_92;
  reg signed [32-1:0] rdata_93;

  spm
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
    .axis_out_mac_spm_tdata(axis_out_mac_spm_tdata),
    .axis_out_mac_spm_tvalid(axis_out_mac_spm_tvalid),
    .axis_out_mac_spm_tready(axis_out_mac_spm_tready),
    .axis_out_mac_spm_tlast(axis_out_mac_spm_tlast),
    .axis_out_axim_spm_tdata(axis_out_axim_spm_tdata),
    .axis_out_axim_spm_tvalid(axis_out_axim_spm_tvalid),
    .axis_out_axim_spm_tready(axis_out_axim_spm_tready),
    .axis_out_axim_spm_tlast(axis_out_axim_spm_tlast),
    .axis_in_axim_spm_tdata(axis_in_axim_spm_tdata),
    .axis_in_axim_spm_tvalid(axis_in_axim_spm_tvalid),
    .axis_in_axim_spm_tready(axis_in_axim_spm_tready),
    .axis_in_axim_spm_tlast(axis_in_axim_spm_tlast),
    .axis_out_xored_spm_tdata(axis_out_xored_spm_tdata),
    .axis_out_xored_spm_tvalid(axis_out_xored_spm_tvalid),
    .axis_out_xored_spm_tready(axis_out_xored_spm_tready),
    .axis_out_xored_spm_tlast(axis_out_xored_spm_tlast),
    .axis_in_xored_spm_tdata(axis_in_xored_spm_tdata),
    .axis_in_xored_spm_tvalid(axis_in_xored_spm_tvalid),
    .axis_in_xored_spm_tready(axis_in_xored_spm_tready),
    .axis_in_xored_spm_tlast(axis_in_xored_spm_tlast),
    .ram_spm_1_addr(ram_spm_1_addr),
    .ram_spm_1_rdata(ram_spm_1_rdata),
    .ram_spm_1_wdata(ram_spm_1_wdata),
    .ram_spm_1_wenable(ram_spm_1_wenable),
    .ram_spm_1_enable(ram_spm_1_enable)
  );


  initial begin
    CLK = 0;
    forever begin
      #5 CLK = !CLK;
    end
  end


  initial begin
    RST = 0;
    maxi_spm_awaddr = 0;
    maxi_spm_awvalid = 0;
    _maxi_spm_wdata_sb_0 = 0;
    _maxi_spm_wstrb_sb_0 = 0;
    _maxi_spm_wvalid_sb_0 = 0;
    _sb_maxi_spm_writedata_data_5 = 0;
    _sb_maxi_spm_writedata_valid_6 = 0;
    _sb_maxi_spm_writedata_tmp_data_8 = 0;
    _sb_maxi_spm_writedata_tmp_valid_9 = 0;
    maxi_spm_araddr = 0;
    maxi_spm_arvalid = 0;
    _sb_maxi_spm_readdata_data_18 = 0;
    _sb_maxi_spm_readdata_valid_19 = 0;
    _sb_maxi_spm_readdata_tmp_data_21 = 0;
    _sb_maxi_spm_readdata_tmp_valid_22 = 0;
    _maxi_spm_outstanding_wcount = 0;
    count__s_axis_spm_read_req_fifo = 0;
    _s_axis_spm_read_op_sel_buf = 0;
    _s_axis_spm_read_local_addr_buf = 0;
    _s_axis_spm_read_local_stride_buf = 0;
    _s_axis_spm_read_local_size_buf = 0;
    _s_axis_spm_read_data_busy = 0;
    m_axis_spm_tdata = 0;
    m_axis_spm_tvalid = 0;
    m_axis_spm_tlast = 0;
    count__m_axis_spm_write_req_fifo = 0;
    _m_axis_spm_write_op_sel_buf = 0;
    _m_axis_spm_write_local_addr_buf = 0;
    _m_axis_spm_write_local_stride_buf = 0;
    _m_axis_spm_write_size_buf = 0;
    _m_axis_spm_write_data_busy = 0;
    read_data_51 = 0;
    memory_awready = 0;
    memory_bvalid = 0;
    memory_arready = 0;
    memory_rdata = 0;
    memory_rlast = 0;
    memory_rvalid = 0;
    _memory_waddr_fsm = _memory_waddr_fsm_init;
    _memory_wdata_fsm = _memory_wdata_fsm_init;
    _memory_raddr_fsm = _memory_raddr_fsm_init;
    _memory_rdata_fsm = _memory_rdata_fsm_init;
    count__memory_wreq_fifo = 0;
    count__memory_rreq_fifo = 0;
    count__memory_wdata_fifo = 0;
    __tmp_57_1 = 0;
    _write_count = 0;
    _write_addr = 0;
    _read_count = 0;
    _read_addr = 0;
    _sleep_interval_count = 0;
    _keep_sleep_count = 0;
    __tmp_62_1 = 0;
    __tmp_74_1 = 0;
    _d1__memory_rdata_fsm = _memory_rdata_fsm_init;
    __memory_rdata_fsm_cond_11_0_1 = 0;
    write_data_86 = 0;
    complete = 0;
    th_ctrl = th_ctrl_init;
    _maxi_spm_raddr_cond_0_1 = 0;
    axim_rdata_87 = 0;
    _maxi_spm_waddr_cond_0_1 = 0;
    _maxi_spm_wdata_cond_0_1 = 0;
    _maxi_spm_waddr_cond_1_1 = 0;
    _maxi_spm_wdata_cond_1_1 = 0;
    _maxi_spm_waddr_cond_2_1 = 0;
    _maxi_spm_wdata_cond_2_1 = 0;
    _maxi_spm_waddr_cond_3_1 = 0;
    _maxi_spm_wdata_cond_3_1 = 0;
    _maxi_spm_waddr_cond_4_1 = 0;
    _maxi_spm_wdata_cond_4_1 = 0;
    _maxi_spm_waddr_cond_5_1 = 0;
    _maxi_spm_wdata_cond_5_1 = 0;
    _th_ctrl_i_1 = 0;
    _m_axis_spm_cond_0_1 = 0;
    _maxi_spm_raddr_cond_1_1 = 0;
    axim_rdata_88 = 0;
    _maxi_spm_waddr_cond_6_1 = 0;
    _maxi_spm_wdata_cond_6_1 = 0;
    _maxi_spm_waddr_cond_7_1 = 0;
    _maxi_spm_wdata_cond_7_1 = 0;
    _maxi_spm_waddr_cond_8_1 = 0;
    _maxi_spm_wdata_cond_8_1 = 0;
    _maxi_spm_waddr_cond_9_1 = 0;
    _maxi_spm_wdata_cond_9_1 = 0;
    _maxi_spm_waddr_cond_10_1 = 0;
    _maxi_spm_wdata_cond_10_1 = 0;
    _maxi_spm_waddr_cond_11_1 = 0;
    _maxi_spm_wdata_cond_11_1 = 0;
    _maxi_spm_raddr_cond_2_1 = 0;
    axim_rdata_89 = 0;
    fsm = fsm_init;
    rdata_90 = 0;
    rdata_91 = 0;
    rdata_92 = 0;
    rdata_93 = 0;
    #100;
    RST = 1;
    #100;
    RST = 0;
    #1000000;
    $finish;
  end


  always @(posedge CLK) begin
    if(RST) begin
      maxi_spm_awaddr <= 0;
      maxi_spm_awvalid <= 0;
      _maxi_spm_waddr_cond_0_1 <= 0;
      _maxi_spm_waddr_cond_1_1 <= 0;
      _maxi_spm_waddr_cond_2_1 <= 0;
      _maxi_spm_waddr_cond_3_1 <= 0;
      _maxi_spm_waddr_cond_4_1 <= 0;
      _maxi_spm_waddr_cond_5_1 <= 0;
      _maxi_spm_waddr_cond_6_1 <= 0;
      _maxi_spm_waddr_cond_7_1 <= 0;
      _maxi_spm_waddr_cond_8_1 <= 0;
      _maxi_spm_waddr_cond_9_1 <= 0;
      _maxi_spm_waddr_cond_10_1 <= 0;
      _maxi_spm_waddr_cond_11_1 <= 0;
    end else begin
      if(_maxi_spm_waddr_cond_0_1) begin
        maxi_spm_awvalid <= 0;
      end 
      if(_maxi_spm_waddr_cond_1_1) begin
        maxi_spm_awvalid <= 0;
      end 
      if(_maxi_spm_waddr_cond_2_1) begin
        maxi_spm_awvalid <= 0;
      end 
      if(_maxi_spm_waddr_cond_3_1) begin
        maxi_spm_awvalid <= 0;
      end 
      if(_maxi_spm_waddr_cond_4_1) begin
        maxi_spm_awvalid <= 0;
      end 
      if(_maxi_spm_waddr_cond_5_1) begin
        maxi_spm_awvalid <= 0;
      end 
      if(_maxi_spm_waddr_cond_6_1) begin
        maxi_spm_awvalid <= 0;
      end 
      if(_maxi_spm_waddr_cond_7_1) begin
        maxi_spm_awvalid <= 0;
      end 
      if(_maxi_spm_waddr_cond_8_1) begin
        maxi_spm_awvalid <= 0;
      end 
      if(_maxi_spm_waddr_cond_9_1) begin
        maxi_spm_awvalid <= 0;
      end 
      if(_maxi_spm_waddr_cond_10_1) begin
        maxi_spm_awvalid <= 0;
      end 
      if(_maxi_spm_waddr_cond_11_1) begin
        maxi_spm_awvalid <= 0;
      end 
      if((th_ctrl == 9) && ((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid))) begin
        maxi_spm_awaddr <= 0;
        maxi_spm_awvalid <= 1;
      end 
      _maxi_spm_waddr_cond_0_1 <= 1;
      if(maxi_spm_awvalid && !maxi_spm_awready) begin
        maxi_spm_awvalid <= maxi_spm_awvalid;
      end 
      if((th_ctrl == 14) && ((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid))) begin
        maxi_spm_awaddr <= 8;
        maxi_spm_awvalid <= 1;
      end 
      _maxi_spm_waddr_cond_1_1 <= 1;
      if(maxi_spm_awvalid && !maxi_spm_awready) begin
        maxi_spm_awvalid <= maxi_spm_awvalid;
      end 
      if((th_ctrl == 19) && ((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid))) begin
        maxi_spm_awaddr <= 16;
        maxi_spm_awvalid <= 1;
      end 
      _maxi_spm_waddr_cond_2_1 <= 1;
      if(maxi_spm_awvalid && !maxi_spm_awready) begin
        maxi_spm_awvalid <= maxi_spm_awvalid;
      end 
      if((th_ctrl == 24) && ((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid))) begin
        maxi_spm_awaddr <= 24;
        maxi_spm_awvalid <= 1;
      end 
      _maxi_spm_waddr_cond_3_1 <= 1;
      if(maxi_spm_awvalid && !maxi_spm_awready) begin
        maxi_spm_awvalid <= maxi_spm_awvalid;
      end 
      if((th_ctrl == 29) && ((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid))) begin
        maxi_spm_awaddr <= 48;
        maxi_spm_awvalid <= 1;
      end 
      _maxi_spm_waddr_cond_4_1 <= 1;
      if(maxi_spm_awvalid && !maxi_spm_awready) begin
        maxi_spm_awvalid <= maxi_spm_awvalid;
      end 
      if((th_ctrl == 34) && ((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid))) begin
        maxi_spm_awaddr <= 32;
        maxi_spm_awvalid <= 1;
      end 
      _maxi_spm_waddr_cond_5_1 <= 1;
      if(maxi_spm_awvalid && !maxi_spm_awready) begin
        maxi_spm_awvalid <= maxi_spm_awvalid;
      end 
      if((th_ctrl == 53) && ((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid))) begin
        maxi_spm_awaddr <= 0;
        maxi_spm_awvalid <= 1;
      end 
      _maxi_spm_waddr_cond_6_1 <= 1;
      if(maxi_spm_awvalid && !maxi_spm_awready) begin
        maxi_spm_awvalid <= maxi_spm_awvalid;
      end 
      if((th_ctrl == 58) && ((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid))) begin
        maxi_spm_awaddr <= 8;
        maxi_spm_awvalid <= 1;
      end 
      _maxi_spm_waddr_cond_7_1 <= 1;
      if(maxi_spm_awvalid && !maxi_spm_awready) begin
        maxi_spm_awvalid <= maxi_spm_awvalid;
      end 
      if((th_ctrl == 63) && ((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid))) begin
        maxi_spm_awaddr <= 16;
        maxi_spm_awvalid <= 1;
      end 
      _maxi_spm_waddr_cond_8_1 <= 1;
      if(maxi_spm_awvalid && !maxi_spm_awready) begin
        maxi_spm_awvalid <= maxi_spm_awvalid;
      end 
      if((th_ctrl == 68) && ((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid))) begin
        maxi_spm_awaddr <= 24;
        maxi_spm_awvalid <= 1;
      end 
      _maxi_spm_waddr_cond_9_1 <= 1;
      if(maxi_spm_awvalid && !maxi_spm_awready) begin
        maxi_spm_awvalid <= maxi_spm_awvalid;
      end 
      if((th_ctrl == 73) && ((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid))) begin
        maxi_spm_awaddr <= 48;
        maxi_spm_awvalid <= 1;
      end 
      _maxi_spm_waddr_cond_10_1 <= 1;
      if(maxi_spm_awvalid && !maxi_spm_awready) begin
        maxi_spm_awvalid <= maxi_spm_awvalid;
      end 
      if((th_ctrl == 78) && ((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid))) begin
        maxi_spm_awaddr <= 32;
        maxi_spm_awvalid <= 1;
      end 
      _maxi_spm_waddr_cond_11_1 <= 1;
      if(maxi_spm_awvalid && !maxi_spm_awready) begin
        maxi_spm_awvalid <= maxi_spm_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _maxi_spm_wdata_sb_0 <= 0;
      _maxi_spm_wvalid_sb_0 <= 0;
      _maxi_spm_wstrb_sb_0 <= 0;
      _maxi_spm_wdata_cond_0_1 <= 0;
      _maxi_spm_wdata_cond_1_1 <= 0;
      _maxi_spm_wdata_cond_2_1 <= 0;
      _maxi_spm_wdata_cond_3_1 <= 0;
      _maxi_spm_wdata_cond_4_1 <= 0;
      _maxi_spm_wdata_cond_5_1 <= 0;
      _maxi_spm_wdata_cond_6_1 <= 0;
      _maxi_spm_wdata_cond_7_1 <= 0;
      _maxi_spm_wdata_cond_8_1 <= 0;
      _maxi_spm_wdata_cond_9_1 <= 0;
      _maxi_spm_wdata_cond_10_1 <= 0;
      _maxi_spm_wdata_cond_11_1 <= 0;
    end else begin
      if(_maxi_spm_wdata_cond_0_1) begin
        _maxi_spm_wvalid_sb_0 <= 0;
      end 
      if(_maxi_spm_wdata_cond_1_1) begin
        _maxi_spm_wvalid_sb_0 <= 0;
      end 
      if(_maxi_spm_wdata_cond_2_1) begin
        _maxi_spm_wvalid_sb_0 <= 0;
      end 
      if(_maxi_spm_wdata_cond_3_1) begin
        _maxi_spm_wvalid_sb_0 <= 0;
      end 
      if(_maxi_spm_wdata_cond_4_1) begin
        _maxi_spm_wvalid_sb_0 <= 0;
      end 
      if(_maxi_spm_wdata_cond_5_1) begin
        _maxi_spm_wvalid_sb_0 <= 0;
      end 
      if(_maxi_spm_wdata_cond_6_1) begin
        _maxi_spm_wvalid_sb_0 <= 0;
      end 
      if(_maxi_spm_wdata_cond_7_1) begin
        _maxi_spm_wvalid_sb_0 <= 0;
      end 
      if(_maxi_spm_wdata_cond_8_1) begin
        _maxi_spm_wvalid_sb_0 <= 0;
      end 
      if(_maxi_spm_wdata_cond_9_1) begin
        _maxi_spm_wvalid_sb_0 <= 0;
      end 
      if(_maxi_spm_wdata_cond_10_1) begin
        _maxi_spm_wvalid_sb_0 <= 0;
      end 
      if(_maxi_spm_wdata_cond_11_1) begin
        _maxi_spm_wvalid_sb_0 <= 0;
      end 
      if((th_ctrl == 11) && (_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0)) begin
        _maxi_spm_wdata_sb_0 <= 0;
        _maxi_spm_wvalid_sb_0 <= 1;
        _maxi_spm_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_spm_wdata_cond_0_1 <= 1;
      if(_maxi_spm_wvalid_sb_0 && !_maxi_spm_wready_sb_0) begin
        _maxi_spm_wvalid_sb_0 <= _maxi_spm_wvalid_sb_0;
      end 
      if((th_ctrl == 16) && (_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0)) begin
        _maxi_spm_wdata_sb_0 <= 0;
        _maxi_spm_wvalid_sb_0 <= 1;
        _maxi_spm_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_spm_wdata_cond_1_1 <= 1;
      if(_maxi_spm_wvalid_sb_0 && !_maxi_spm_wready_sb_0) begin
        _maxi_spm_wvalid_sb_0 <= _maxi_spm_wvalid_sb_0;
      end 
      if((th_ctrl == 21) && (_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0)) begin
        _maxi_spm_wdata_sb_0 <= 4;
        _maxi_spm_wvalid_sb_0 <= 1;
        _maxi_spm_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_spm_wdata_cond_2_1 <= 1;
      if(_maxi_spm_wvalid_sb_0 && !_maxi_spm_wready_sb_0) begin
        _maxi_spm_wvalid_sb_0 <= _maxi_spm_wvalid_sb_0;
      end 
      if((th_ctrl == 26) && (_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0)) begin
        _maxi_spm_wdata_sb_0 <= 0;
        _maxi_spm_wvalid_sb_0 <= 1;
        _maxi_spm_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_spm_wdata_cond_3_1 <= 1;
      if(_maxi_spm_wvalid_sb_0 && !_maxi_spm_wready_sb_0) begin
        _maxi_spm_wvalid_sb_0 <= _maxi_spm_wvalid_sb_0;
      end 
      if((th_ctrl == 31) && (_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0)) begin
        _maxi_spm_wdata_sb_0 <= 4;
        _maxi_spm_wvalid_sb_0 <= 1;
        _maxi_spm_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_spm_wdata_cond_4_1 <= 1;
      if(_maxi_spm_wvalid_sb_0 && !_maxi_spm_wready_sb_0) begin
        _maxi_spm_wvalid_sb_0 <= _maxi_spm_wvalid_sb_0;
      end 
      if((th_ctrl == 36) && (_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0)) begin
        _maxi_spm_wdata_sb_0 <= 1;
        _maxi_spm_wvalid_sb_0 <= 1;
        _maxi_spm_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_spm_wdata_cond_5_1 <= 1;
      if(_maxi_spm_wvalid_sb_0 && !_maxi_spm_wready_sb_0) begin
        _maxi_spm_wvalid_sb_0 <= _maxi_spm_wvalid_sb_0;
      end 
      if((th_ctrl == 55) && (_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0)) begin
        _maxi_spm_wdata_sb_0 <= 4096;
        _maxi_spm_wvalid_sb_0 <= 1;
        _maxi_spm_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_spm_wdata_cond_6_1 <= 1;
      if(_maxi_spm_wvalid_sb_0 && !_maxi_spm_wready_sb_0) begin
        _maxi_spm_wvalid_sb_0 <= _maxi_spm_wvalid_sb_0;
      end 
      if((th_ctrl == 60) && (_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0)) begin
        _maxi_spm_wdata_sb_0 <= 0;
        _maxi_spm_wvalid_sb_0 <= 1;
        _maxi_spm_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_spm_wdata_cond_7_1 <= 1;
      if(_maxi_spm_wvalid_sb_0 && !_maxi_spm_wready_sb_0) begin
        _maxi_spm_wvalid_sb_0 <= _maxi_spm_wvalid_sb_0;
      end 
      if((th_ctrl == 65) && (_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0)) begin
        _maxi_spm_wdata_sb_0 <= 4;
        _maxi_spm_wvalid_sb_0 <= 1;
        _maxi_spm_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_spm_wdata_cond_8_1 <= 1;
      if(_maxi_spm_wvalid_sb_0 && !_maxi_spm_wready_sb_0) begin
        _maxi_spm_wvalid_sb_0 <= _maxi_spm_wvalid_sb_0;
      end 
      if((th_ctrl == 70) && (_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0)) begin
        _maxi_spm_wdata_sb_0 <= 1;
        _maxi_spm_wvalid_sb_0 <= 1;
        _maxi_spm_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_spm_wdata_cond_9_1 <= 1;
      if(_maxi_spm_wvalid_sb_0 && !_maxi_spm_wready_sb_0) begin
        _maxi_spm_wvalid_sb_0 <= _maxi_spm_wvalid_sb_0;
      end 
      if((th_ctrl == 75) && (_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0)) begin
        _maxi_spm_wdata_sb_0 <= 1;
        _maxi_spm_wvalid_sb_0 <= 1;
        _maxi_spm_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_spm_wdata_cond_10_1 <= 1;
      if(_maxi_spm_wvalid_sb_0 && !_maxi_spm_wready_sb_0) begin
        _maxi_spm_wvalid_sb_0 <= _maxi_spm_wvalid_sb_0;
      end 
      if((th_ctrl == 80) && (_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0)) begin
        _maxi_spm_wdata_sb_0 <= 1;
        _maxi_spm_wvalid_sb_0 <= 1;
        _maxi_spm_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_spm_wdata_cond_11_1 <= 1;
      if(_maxi_spm_wvalid_sb_0 && !_maxi_spm_wready_sb_0) begin
        _maxi_spm_wvalid_sb_0 <= _maxi_spm_wvalid_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_spm_writedata_data_5 <= 0;
      _sb_maxi_spm_writedata_valid_6 <= 0;
      _sb_maxi_spm_writedata_tmp_data_8 <= 0;
      _sb_maxi_spm_writedata_tmp_valid_9 <= 0;
    end else begin
      if(_sb_maxi_spm_writedata_m_ready_4 || !_sb_maxi_spm_writedata_valid_6) begin
        _sb_maxi_spm_writedata_data_5 <= _sb_maxi_spm_writedata_next_data_10;
        _sb_maxi_spm_writedata_valid_6 <= _sb_maxi_spm_writedata_next_valid_11;
      end 
      if(!_sb_maxi_spm_writedata_tmp_valid_9 && _sb_maxi_spm_writedata_valid_6 && !_sb_maxi_spm_writedata_m_ready_4) begin
        _sb_maxi_spm_writedata_tmp_data_8 <= _sb_maxi_spm_writedata_s_data_2;
        _sb_maxi_spm_writedata_tmp_valid_9 <= _sb_maxi_spm_writedata_s_valid_3;
      end 
      if(_sb_maxi_spm_writedata_tmp_valid_9 && _sb_maxi_spm_writedata_m_ready_4) begin
        _sb_maxi_spm_writedata_tmp_valid_9 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      maxi_spm_araddr <= 0;
      maxi_spm_arvalid <= 0;
      _maxi_spm_raddr_cond_0_1 <= 0;
      _maxi_spm_raddr_cond_1_1 <= 0;
      _maxi_spm_raddr_cond_2_1 <= 0;
    end else begin
      if(_maxi_spm_raddr_cond_0_1) begin
        maxi_spm_arvalid <= 0;
      end 
      if(_maxi_spm_raddr_cond_1_1) begin
        maxi_spm_arvalid <= 0;
      end 
      if(_maxi_spm_raddr_cond_2_1) begin
        maxi_spm_arvalid <= 0;
      end 
      if((th_ctrl == 2) && (maxi_spm_arready || !maxi_spm_arvalid)) begin
        maxi_spm_araddr <= 40;
        maxi_spm_arvalid <= 1;
      end 
      _maxi_spm_raddr_cond_0_1 <= 1;
      if(maxi_spm_arvalid && !maxi_spm_arready) begin
        maxi_spm_arvalid <= maxi_spm_arvalid;
      end 
      if((th_ctrl == 46) && (maxi_spm_arready || !maxi_spm_arvalid)) begin
        maxi_spm_araddr <= 40;
        maxi_spm_arvalid <= 1;
      end 
      _maxi_spm_raddr_cond_1_1 <= 1;
      if(maxi_spm_arvalid && !maxi_spm_arready) begin
        maxi_spm_arvalid <= maxi_spm_arvalid;
      end 
      if((th_ctrl == 84) && (maxi_spm_arready || !maxi_spm_arvalid)) begin
        maxi_spm_araddr <= 40;
        maxi_spm_arvalid <= 1;
      end 
      _maxi_spm_raddr_cond_2_1 <= 1;
      if(maxi_spm_arvalid && !maxi_spm_arready) begin
        maxi_spm_arvalid <= maxi_spm_arvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_spm_readdata_data_18 <= 0;
      _sb_maxi_spm_readdata_valid_19 <= 0;
      _sb_maxi_spm_readdata_tmp_data_21 <= 0;
      _sb_maxi_spm_readdata_tmp_valid_22 <= 0;
    end else begin
      if(_sb_maxi_spm_readdata_m_ready_17 || !_sb_maxi_spm_readdata_valid_19) begin
        _sb_maxi_spm_readdata_data_18 <= _sb_maxi_spm_readdata_next_data_23;
        _sb_maxi_spm_readdata_valid_19 <= _sb_maxi_spm_readdata_next_valid_24;
      end 
      if(!_sb_maxi_spm_readdata_tmp_valid_22 && _sb_maxi_spm_readdata_valid_19 && !_sb_maxi_spm_readdata_m_ready_17) begin
        _sb_maxi_spm_readdata_tmp_data_21 <= _sb_maxi_spm_readdata_s_data_15;
        _sb_maxi_spm_readdata_tmp_valid_22 <= _sb_maxi_spm_readdata_s_valid_16;
      end 
      if(_sb_maxi_spm_readdata_tmp_valid_22 && _sb_maxi_spm_readdata_m_ready_17) begin
        _sb_maxi_spm_readdata_tmp_valid_22 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _maxi_spm_outstanding_wcount <= 0;
    end else begin
      if(maxi_spm_awvalid && maxi_spm_awready && !(maxi_spm_bvalid && maxi_spm_bready) && (_maxi_spm_outstanding_wcount < 7)) begin
        _maxi_spm_outstanding_wcount <= _maxi_spm_outstanding_wcount + 1;
      end 
      if(!(maxi_spm_awvalid && maxi_spm_awready) && (maxi_spm_bvalid && maxi_spm_bready) && (_maxi_spm_outstanding_wcount > 0)) begin
        _maxi_spm_outstanding_wcount <= _maxi_spm_outstanding_wcount - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__s_axis_spm_read_req_fifo <= 0;
    end else begin
      if(_s_axis_spm_read_req_fifo_enq && !_s_axis_spm_read_req_fifo_full && (_s_axis_spm_read_req_fifo_deq && !_s_axis_spm_read_req_fifo_empty)) begin
        count__s_axis_spm_read_req_fifo <= count__s_axis_spm_read_req_fifo;
      end else if(_s_axis_spm_read_req_fifo_enq && !_s_axis_spm_read_req_fifo_full) begin
        count__s_axis_spm_read_req_fifo <= count__s_axis_spm_read_req_fifo + 1;
      end else if(_s_axis_spm_read_req_fifo_deq && !_s_axis_spm_read_req_fifo_empty) begin
        count__s_axis_spm_read_req_fifo <= count__s_axis_spm_read_req_fifo - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      m_axis_spm_tdata <= 0;
      m_axis_spm_tvalid <= 0;
      m_axis_spm_tlast <= 0;
      _m_axis_spm_cond_0_1 <= 0;
    end else begin
      if(_m_axis_spm_cond_0_1) begin
        m_axis_spm_tvalid <= 0;
        m_axis_spm_tlast <= 0;
      end 
      if((th_ctrl == 43) && (m_axis_spm_tready || !m_axis_spm_tvalid)) begin
        m_axis_spm_tdata <= write_data_86;
        m_axis_spm_tvalid <= 1;
        m_axis_spm_tlast <= _th_ctrl_i_1 == 3;
      end 
      _m_axis_spm_cond_0_1 <= 1;
      if(m_axis_spm_tvalid && !m_axis_spm_tready) begin
        m_axis_spm_tvalid <= m_axis_spm_tvalid;
        m_axis_spm_tlast <= m_axis_spm_tlast;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _m_axis_spm_write_data_busy <= 0;
    end else begin
      if((th_ctrl == 42) && _m_axis_spm_write_idle) begin
        _m_axis_spm_write_data_busy <= 1;
      end 
      if((th_ctrl == 43) && (m_axis_spm_tready || !m_axis_spm_tvalid)) begin
        _m_axis_spm_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__m_axis_spm_write_req_fifo <= 0;
    end else begin
      if(_m_axis_spm_write_req_fifo_enq && !_m_axis_spm_write_req_fifo_full && (_m_axis_spm_write_req_fifo_deq && !_m_axis_spm_write_req_fifo_empty)) begin
        count__m_axis_spm_write_req_fifo <= count__m_axis_spm_write_req_fifo;
      end else if(_m_axis_spm_write_req_fifo_enq && !_m_axis_spm_write_req_fifo_full) begin
        count__m_axis_spm_write_req_fifo <= count__m_axis_spm_write_req_fifo + 1;
      end else if(_m_axis_spm_write_req_fifo_deq && !_m_axis_spm_write_req_fifo_empty) begin
        count__m_axis_spm_write_req_fifo <= count__m_axis_spm_write_req_fifo - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _keep_sleep_count <= 0;
      _sleep_interval_count <= 0;
    end else begin
      if(_sleep_interval_count == 15) begin
        _keep_sleep_count <= _keep_sleep_count + 1;
      end 
      if((_sleep_interval_count == 15) && (_keep_sleep_count == 3)) begin
        _keep_sleep_count <= 0;
      end 
      if(_sleep_interval_count < 15) begin
        _sleep_interval_count <= _sleep_interval_count + 1;
      end 
      if((_keep_sleep_count == 3) && (_sleep_interval_count == 15)) begin
        _sleep_interval_count <= 0;
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[0]) begin
        _memory_mem[_write_addr + 0] <= pack_write_data_wdata_65[7:0];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[1]) begin
        _memory_mem[_write_addr + 1] <= pack_write_data_wdata_65[15:8];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[2]) begin
        _memory_mem[_write_addr + 2] <= pack_write_data_wdata_65[23:16];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[3]) begin
        _memory_mem[_write_addr + 3] <= pack_write_data_wdata_65[31:24];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[4]) begin
        _memory_mem[_write_addr + 4] <= pack_write_data_wdata_65[39:32];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[5]) begin
        _memory_mem[_write_addr + 5] <= pack_write_data_wdata_65[47:40];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[6]) begin
        _memory_mem[_write_addr + 6] <= pack_write_data_wdata_65[55:48];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[7]) begin
        _memory_mem[_write_addr + 7] <= pack_write_data_wdata_65[63:56];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[8]) begin
        _memory_mem[_write_addr + 8] <= pack_write_data_wdata_65[71:64];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[9]) begin
        _memory_mem[_write_addr + 9] <= pack_write_data_wdata_65[79:72];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[10]) begin
        _memory_mem[_write_addr + 10] <= pack_write_data_wdata_65[87:80];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[11]) begin
        _memory_mem[_write_addr + 11] <= pack_write_data_wdata_65[95:88];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[12]) begin
        _memory_mem[_write_addr + 12] <= pack_write_data_wdata_65[103:96];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[13]) begin
        _memory_mem[_write_addr + 13] <= pack_write_data_wdata_65[111:104];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[14]) begin
        _memory_mem[_write_addr + 14] <= pack_write_data_wdata_65[119:112];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wstrb_66[15]) begin
        _memory_mem[_write_addr + 15] <= pack_write_data_wdata_65[127:120];
      end 
    end
  end

  localparam _memory_waddr_fsm_1 = 1;
  localparam _memory_waddr_fsm_2 = 2;
  localparam _memory_waddr_fsm_3 = 3;
  localparam _memory_waddr_fsm_4 = 4;
  localparam _memory_waddr_fsm_5 = 5;
  localparam _memory_waddr_fsm_6 = 6;
  localparam _memory_waddr_fsm_7 = 7;
  localparam _memory_waddr_fsm_8 = 8;
  localparam _memory_waddr_fsm_9 = 9;
  localparam _memory_waddr_fsm_10 = 10;
  localparam _memory_waddr_fsm_11 = 11;

  always @(posedge CLK) begin
    if(RST) begin
      _memory_waddr_fsm <= _memory_waddr_fsm_init;
      memory_awready <= 0;
    end else begin
      case(_memory_waddr_fsm)
        _memory_waddr_fsm_init: begin
          memory_awready <= 0;
          if(memory_awvalid) begin
            _memory_waddr_fsm <= _memory_waddr_fsm_1;
          end 
        end
        _memory_waddr_fsm_1: begin
          _memory_waddr_fsm <= _memory_waddr_fsm_2;
        end
        _memory_waddr_fsm_2: begin
          _memory_waddr_fsm <= _memory_waddr_fsm_3;
        end
        _memory_waddr_fsm_3: begin
          _memory_waddr_fsm <= _memory_waddr_fsm_4;
        end
        _memory_waddr_fsm_4: begin
          _memory_waddr_fsm <= _memory_waddr_fsm_5;
        end
        _memory_waddr_fsm_5: begin
          _memory_waddr_fsm <= _memory_waddr_fsm_6;
        end
        _memory_waddr_fsm_6: begin
          _memory_waddr_fsm <= _memory_waddr_fsm_7;
        end
        _memory_waddr_fsm_7: begin
          _memory_waddr_fsm <= _memory_waddr_fsm_8;
        end
        _memory_waddr_fsm_8: begin
          _memory_waddr_fsm <= _memory_waddr_fsm_9;
        end
        _memory_waddr_fsm_9: begin
          _memory_waddr_fsm <= _memory_waddr_fsm_10;
        end
        _memory_waddr_fsm_10: begin
          _memory_waddr_fsm <= _memory_waddr_fsm_11;
        end
        _memory_waddr_fsm_11: begin
          if(!_memory_wreq_fifo_almost_full) begin
            memory_awready <= 1;
          end 
          if(memory_awvalid && memory_awready) begin
            memory_awready <= 0;
          end 
          if(!memory_awvalid) begin
            _memory_waddr_fsm <= _memory_waddr_fsm_init;
          end 
          if(memory_awvalid && memory_awready) begin
            _memory_waddr_fsm <= _memory_waddr_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam _memory_wdata_fsm_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      _memory_wdata_fsm <= _memory_wdata_fsm_init;
      memory_bvalid <= 0;
      _write_addr <= 0;
      _write_count <= 0;
    end else begin
      case(_memory_wdata_fsm)
        _memory_wdata_fsm_init: begin
          memory_bvalid <= 0;
          if(!_memory_wreq_fifo_empty) begin
            _write_addr <= unpack_write_req_global_addr_63;
            _write_count <= unpack_write_req_size_64;
          end 
          if(!_memory_wreq_fifo_empty) begin
            _memory_wdata_fsm <= _memory_wdata_fsm_1;
          end 
        end
        _memory_wdata_fsm_1: begin
          if(write_data_wvalid_68 && write_data_wready_69) begin
            _write_addr <= _write_addr + 16;
            _write_count <= _write_count - 1;
          end 
          if(write_data_wvalid_68 && write_data_wready_69 && (_write_count == 1)) begin
            memory_bvalid <= 1;
          end 
          if(write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wlast_67) begin
            memory_bvalid <= 1;
          end 
          if(write_data_wvalid_68 && write_data_wready_69 && (_write_count == 1)) begin
            _memory_wdata_fsm <= _memory_wdata_fsm_init;
          end 
          if(write_data_wvalid_68 && write_data_wready_69 && pack_write_data_wlast_67) begin
            _memory_wdata_fsm <= _memory_wdata_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam _memory_raddr_fsm_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      _memory_raddr_fsm <= _memory_raddr_fsm_init;
      memory_arready <= 0;
    end else begin
      case(_memory_raddr_fsm)
        _memory_raddr_fsm_init: begin
          memory_arready <= 0;
          if(memory_arvalid) begin
            _memory_raddr_fsm <= _memory_raddr_fsm_1;
          end 
        end
        _memory_raddr_fsm_1: begin
          if(!_memory_rreq_fifo_almost_full) begin
            memory_arready <= 1;
          end 
          if(memory_arvalid && memory_arready) begin
            memory_arready <= 0;
          end 
          if(!memory_arvalid) begin
            _memory_raddr_fsm <= _memory_raddr_fsm_init;
          end 
          if(memory_arvalid && memory_arready) begin
            _memory_raddr_fsm <= _memory_raddr_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam _memory_rdata_fsm_1 = 1;
  localparam _memory_rdata_fsm_2 = 2;
  localparam _memory_rdata_fsm_3 = 3;
  localparam _memory_rdata_fsm_4 = 4;
  localparam _memory_rdata_fsm_5 = 5;
  localparam _memory_rdata_fsm_6 = 6;
  localparam _memory_rdata_fsm_7 = 7;
  localparam _memory_rdata_fsm_8 = 8;
  localparam _memory_rdata_fsm_9 = 9;
  localparam _memory_rdata_fsm_10 = 10;
  localparam _memory_rdata_fsm_11 = 11;

  always @(posedge CLK) begin
    if(RST) begin
      _memory_rdata_fsm <= _memory_rdata_fsm_init;
      _d1__memory_rdata_fsm <= _memory_rdata_fsm_init;
      _read_addr <= 0;
      _read_count <= 0;
      memory_rdata[7:0] <= (0 >> 0) & { 8{ 1'd1 } };
      memory_rdata[15:8] <= (0 >> 8) & { 8{ 1'd1 } };
      memory_rdata[23:16] <= (0 >> 16) & { 8{ 1'd1 } };
      memory_rdata[31:24] <= (0 >> 24) & { 8{ 1'd1 } };
      memory_rdata[39:32] <= (0 >> 32) & { 8{ 1'd1 } };
      memory_rdata[47:40] <= (0 >> 40) & { 8{ 1'd1 } };
      memory_rdata[55:48] <= (0 >> 48) & { 8{ 1'd1 } };
      memory_rdata[63:56] <= (0 >> 56) & { 8{ 1'd1 } };
      memory_rdata[71:64] <= (0 >> 64) & { 8{ 1'd1 } };
      memory_rdata[79:72] <= (0 >> 72) & { 8{ 1'd1 } };
      memory_rdata[87:80] <= (0 >> 80) & { 8{ 1'd1 } };
      memory_rdata[95:88] <= (0 >> 88) & { 8{ 1'd1 } };
      memory_rdata[103:96] <= (0 >> 96) & { 8{ 1'd1 } };
      memory_rdata[111:104] <= (0 >> 104) & { 8{ 1'd1 } };
      memory_rdata[119:112] <= (0 >> 112) & { 8{ 1'd1 } };
      memory_rdata[127:120] <= (0 >> 120) & { 8{ 1'd1 } };
      memory_rvalid <= 0;
      memory_rlast <= 0;
      __memory_rdata_fsm_cond_11_0_1 <= 0;
      memory_rdata <= 0;
    end else begin
      _d1__memory_rdata_fsm <= _memory_rdata_fsm;
      case(_d1__memory_rdata_fsm)
        _memory_rdata_fsm_11: begin
          if(__memory_rdata_fsm_cond_11_0_1) begin
            memory_rvalid <= 0;
            memory_rlast <= 0;
          end 
        end
      endcase
      case(_memory_rdata_fsm)
        _memory_rdata_fsm_init: begin
          if(!_memory_rreq_fifo_empty) begin
            _read_addr <= unpack_read_req_global_addr_75;
            _read_count <= unpack_read_req_size_76;
          end 
          if(!_memory_rreq_fifo_empty) begin
            _memory_rdata_fsm <= _memory_rdata_fsm_1;
          end 
        end
        _memory_rdata_fsm_1: begin
          _memory_rdata_fsm <= _memory_rdata_fsm_2;
        end
        _memory_rdata_fsm_2: begin
          _memory_rdata_fsm <= _memory_rdata_fsm_3;
        end
        _memory_rdata_fsm_3: begin
          _memory_rdata_fsm <= _memory_rdata_fsm_4;
        end
        _memory_rdata_fsm_4: begin
          _memory_rdata_fsm <= _memory_rdata_fsm_5;
        end
        _memory_rdata_fsm_5: begin
          _memory_rdata_fsm <= _memory_rdata_fsm_6;
        end
        _memory_rdata_fsm_6: begin
          _memory_rdata_fsm <= _memory_rdata_fsm_7;
        end
        _memory_rdata_fsm_7: begin
          _memory_rdata_fsm <= _memory_rdata_fsm_8;
        end
        _memory_rdata_fsm_8: begin
          _memory_rdata_fsm <= _memory_rdata_fsm_9;
        end
        _memory_rdata_fsm_9: begin
          _memory_rdata_fsm <= _memory_rdata_fsm_10;
        end
        _memory_rdata_fsm_10: begin
          _memory_rdata_fsm <= _memory_rdata_fsm_11;
        end
        _memory_rdata_fsm_11: begin
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[7:0] <= _memory_mem[_read_addr + 0];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[15:8] <= _memory_mem[_read_addr + 1];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[23:16] <= _memory_mem[_read_addr + 2];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[31:24] <= _memory_mem[_read_addr + 3];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[39:32] <= _memory_mem[_read_addr + 4];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[47:40] <= _memory_mem[_read_addr + 5];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[55:48] <= _memory_mem[_read_addr + 6];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[63:56] <= _memory_mem[_read_addr + 7];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[71:64] <= _memory_mem[_read_addr + 8];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[79:72] <= _memory_mem[_read_addr + 9];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[87:80] <= _memory_mem[_read_addr + 10];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[95:88] <= _memory_mem[_read_addr + 11];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[103:96] <= _memory_mem[_read_addr + 12];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[111:104] <= _memory_mem[_read_addr + 13];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[119:112] <= _memory_mem[_read_addr + 14];
          end 
          if(memory_rready | !memory_rvalid) begin
            memory_rdata[127:120] <= _memory_mem[_read_addr + 15];
          end 
          if((_sleep_interval_count < 15) && (_read_count > 0) && memory_rready | !memory_rvalid) begin
            memory_rvalid <= 1;
            _read_addr <= _read_addr + 16;
            _read_count <= _read_count - 1;
          end 
          if((_sleep_interval_count < 15) && (_read_count == 1) && memory_rready | !memory_rvalid) begin
            memory_rlast <= 1;
          end 
          __memory_rdata_fsm_cond_11_0_1 <= 1;
          if(memory_rvalid && !memory_rready) begin
            memory_rvalid <= memory_rvalid;
            memory_rdata <= memory_rdata;
            memory_rlast <= memory_rlast;
          end 
          if(memory_rvalid && memory_rready && (_read_count == 0)) begin
            _memory_rdata_fsm <= _memory_rdata_fsm_init;
          end 
        end
      endcase
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__memory_wreq_fifo <= 0;
      __tmp_62_1 <= 0;
    end else begin
      if(_memory_wreq_fifo_enq && !_memory_wreq_fifo_full && (_memory_wreq_fifo_deq && !_memory_wreq_fifo_empty)) begin
        count__memory_wreq_fifo <= count__memory_wreq_fifo;
      end else if(_memory_wreq_fifo_enq && !_memory_wreq_fifo_full) begin
        count__memory_wreq_fifo <= count__memory_wreq_fifo + 1;
      end else if(_memory_wreq_fifo_deq && !_memory_wreq_fifo_empty) begin
        count__memory_wreq_fifo <= count__memory_wreq_fifo - 1;
      end 
      __tmp_62_1 <= _tmp_62;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__memory_rreq_fifo <= 0;
      __tmp_74_1 <= 0;
    end else begin
      if(_memory_rreq_fifo_enq && !_memory_rreq_fifo_full && (_memory_rreq_fifo_deq && !_memory_rreq_fifo_empty)) begin
        count__memory_rreq_fifo <= count__memory_rreq_fifo;
      end else if(_memory_rreq_fifo_enq && !_memory_rreq_fifo_full) begin
        count__memory_rreq_fifo <= count__memory_rreq_fifo + 1;
      end else if(_memory_rreq_fifo_deq && !_memory_rreq_fifo_empty) begin
        count__memory_rreq_fifo <= count__memory_rreq_fifo - 1;
      end 
      __tmp_74_1 <= _tmp_74;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__memory_wdata_fifo <= 0;
      __tmp_57_1 <= 0;
    end else begin
      if(_memory_wdata_fifo_enq && !_memory_wdata_fifo_full && (_memory_wdata_fifo_deq && !_memory_wdata_fifo_empty)) begin
        count__memory_wdata_fifo <= count__memory_wdata_fifo;
      end else if(_memory_wdata_fifo_enq && !_memory_wdata_fifo_full) begin
        count__memory_wdata_fifo <= count__memory_wdata_fifo + 1;
      end else if(_memory_wdata_fifo_deq && !_memory_wdata_fifo_empty) begin
        count__memory_wdata_fifo <= count__memory_wdata_fifo - 1;
      end 
      __tmp_57_1 <= _tmp_57;
    end
  end

  localparam th_ctrl_1 = 1;
  localparam th_ctrl_2 = 2;
  localparam th_ctrl_3 = 3;
  localparam th_ctrl_4 = 4;
  localparam th_ctrl_5 = 5;
  localparam th_ctrl_6 = 6;
  localparam th_ctrl_7 = 7;
  localparam th_ctrl_8 = 8;
  localparam th_ctrl_9 = 9;
  localparam th_ctrl_10 = 10;
  localparam th_ctrl_11 = 11;
  localparam th_ctrl_12 = 12;
  localparam th_ctrl_13 = 13;
  localparam th_ctrl_14 = 14;
  localparam th_ctrl_15 = 15;
  localparam th_ctrl_16 = 16;
  localparam th_ctrl_17 = 17;
  localparam th_ctrl_18 = 18;
  localparam th_ctrl_19 = 19;
  localparam th_ctrl_20 = 20;
  localparam th_ctrl_21 = 21;
  localparam th_ctrl_22 = 22;
  localparam th_ctrl_23 = 23;
  localparam th_ctrl_24 = 24;
  localparam th_ctrl_25 = 25;
  localparam th_ctrl_26 = 26;
  localparam th_ctrl_27 = 27;
  localparam th_ctrl_28 = 28;
  localparam th_ctrl_29 = 29;
  localparam th_ctrl_30 = 30;
  localparam th_ctrl_31 = 31;
  localparam th_ctrl_32 = 32;
  localparam th_ctrl_33 = 33;
  localparam th_ctrl_34 = 34;
  localparam th_ctrl_35 = 35;
  localparam th_ctrl_36 = 36;
  localparam th_ctrl_37 = 37;
  localparam th_ctrl_38 = 38;
  localparam th_ctrl_39 = 39;
  localparam th_ctrl_40 = 40;
  localparam th_ctrl_41 = 41;
  localparam th_ctrl_42 = 42;
  localparam th_ctrl_43 = 43;
  localparam th_ctrl_44 = 44;
  localparam th_ctrl_45 = 45;
  localparam th_ctrl_46 = 46;
  localparam th_ctrl_47 = 47;
  localparam th_ctrl_48 = 48;
  localparam th_ctrl_49 = 49;
  localparam th_ctrl_50 = 50;
  localparam th_ctrl_51 = 51;
  localparam th_ctrl_52 = 52;
  localparam th_ctrl_53 = 53;
  localparam th_ctrl_54 = 54;
  localparam th_ctrl_55 = 55;
  localparam th_ctrl_56 = 56;
  localparam th_ctrl_57 = 57;
  localparam th_ctrl_58 = 58;
  localparam th_ctrl_59 = 59;
  localparam th_ctrl_60 = 60;
  localparam th_ctrl_61 = 61;
  localparam th_ctrl_62 = 62;
  localparam th_ctrl_63 = 63;
  localparam th_ctrl_64 = 64;
  localparam th_ctrl_65 = 65;
  localparam th_ctrl_66 = 66;
  localparam th_ctrl_67 = 67;
  localparam th_ctrl_68 = 68;
  localparam th_ctrl_69 = 69;
  localparam th_ctrl_70 = 70;
  localparam th_ctrl_71 = 71;
  localparam th_ctrl_72 = 72;
  localparam th_ctrl_73 = 73;
  localparam th_ctrl_74 = 74;
  localparam th_ctrl_75 = 75;
  localparam th_ctrl_76 = 76;
  localparam th_ctrl_77 = 77;
  localparam th_ctrl_78 = 78;
  localparam th_ctrl_79 = 79;
  localparam th_ctrl_80 = 80;
  localparam th_ctrl_81 = 81;
  localparam th_ctrl_82 = 82;
  localparam th_ctrl_83 = 83;
  localparam th_ctrl_84 = 84;
  localparam th_ctrl_85 = 85;
  localparam th_ctrl_86 = 86;
  localparam th_ctrl_87 = 87;
  localparam th_ctrl_88 = 88;
  localparam th_ctrl_89 = 89;
  localparam th_ctrl_90 = 90;
  localparam th_ctrl_91 = 91;
  localparam th_ctrl_92 = 92;

  always @(posedge CLK) begin
    if(RST) begin
      th_ctrl <= th_ctrl_init;
      axim_rdata_87 <= 0;
      _th_ctrl_i_1 <= 0;
      write_data_86 <= 0;
      axim_rdata_88 <= 0;
      axim_rdata_89 <= 0;
      complete <= 0;
    end else begin
      case(th_ctrl)
        th_ctrl_init: begin
          th_ctrl <= th_ctrl_1;
        end
        th_ctrl_1: begin
          if(1) begin
            th_ctrl <= th_ctrl_2;
          end else begin
            th_ctrl <= th_ctrl_8;
          end
        end
        th_ctrl_2: begin
          if(maxi_spm_arready || !maxi_spm_arvalid) begin
            th_ctrl <= th_ctrl_3;
          end 
        end
        th_ctrl_3: begin
          if(maxi_spm_arvalid && maxi_spm_arready) begin
            th_ctrl <= th_ctrl_4;
          end 
        end
        th_ctrl_4: begin
          if(_maxi_spm_rvalid_sb_0) begin
            axim_rdata_87 <= _maxi_spm_rdata_sb_0;
          end 
          if(_maxi_spm_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_5;
          end 
        end
        th_ctrl_5: begin
          if(axim_rdata_87 == 0) begin
            th_ctrl <= th_ctrl_6;
          end else begin
            th_ctrl <= th_ctrl_7;
          end
        end
        th_ctrl_6: begin
          th_ctrl <= th_ctrl_8;
        end
        th_ctrl_7: begin
          th_ctrl <= th_ctrl_1;
        end
        th_ctrl_8: begin
          // $display("DMA Read from AXI Manager");
          th_ctrl <= th_ctrl_9;
        end
        th_ctrl_9: begin
          if((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid)) begin
            th_ctrl <= th_ctrl_10;
          end 
        end
        th_ctrl_10: begin
          if(maxi_spm_awvalid && maxi_spm_awready) begin
            th_ctrl <= th_ctrl_11;
          end 
        end
        th_ctrl_11: begin
          if(_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_12;
          end 
        end
        th_ctrl_12: begin
          if(_maxi_spm_wvalid_sb_0 && _maxi_spm_wready_sb_0) begin
            th_ctrl <= th_ctrl_13;
          end 
        end
        th_ctrl_13: begin
          if(!_maxi_spm_has_outstanding_write) begin
            th_ctrl <= th_ctrl_14;
          end 
        end
        th_ctrl_14: begin
          if((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid)) begin
            th_ctrl <= th_ctrl_15;
          end 
        end
        th_ctrl_15: begin
          if(maxi_spm_awvalid && maxi_spm_awready) begin
            th_ctrl <= th_ctrl_16;
          end 
        end
        th_ctrl_16: begin
          if(_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_17;
          end 
        end
        th_ctrl_17: begin
          if(_maxi_spm_wvalid_sb_0 && _maxi_spm_wready_sb_0) begin
            th_ctrl <= th_ctrl_18;
          end 
        end
        th_ctrl_18: begin
          if(!_maxi_spm_has_outstanding_write) begin
            th_ctrl <= th_ctrl_19;
          end 
        end
        th_ctrl_19: begin
          if((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid)) begin
            th_ctrl <= th_ctrl_20;
          end 
        end
        th_ctrl_20: begin
          if(maxi_spm_awvalid && maxi_spm_awready) begin
            th_ctrl <= th_ctrl_21;
          end 
        end
        th_ctrl_21: begin
          if(_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_22;
          end 
        end
        th_ctrl_22: begin
          if(_maxi_spm_wvalid_sb_0 && _maxi_spm_wready_sb_0) begin
            th_ctrl <= th_ctrl_23;
          end 
        end
        th_ctrl_23: begin
          if(!_maxi_spm_has_outstanding_write) begin
            th_ctrl <= th_ctrl_24;
          end 
        end
        th_ctrl_24: begin
          if((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid)) begin
            th_ctrl <= th_ctrl_25;
          end 
        end
        th_ctrl_25: begin
          if(maxi_spm_awvalid && maxi_spm_awready) begin
            th_ctrl <= th_ctrl_26;
          end 
        end
        th_ctrl_26: begin
          if(_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_27;
          end 
        end
        th_ctrl_27: begin
          if(_maxi_spm_wvalid_sb_0 && _maxi_spm_wready_sb_0) begin
            th_ctrl <= th_ctrl_28;
          end 
        end
        th_ctrl_28: begin
          if(!_maxi_spm_has_outstanding_write) begin
            th_ctrl <= th_ctrl_29;
          end 
        end
        th_ctrl_29: begin
          if((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid)) begin
            th_ctrl <= th_ctrl_30;
          end 
        end
        th_ctrl_30: begin
          if(maxi_spm_awvalid && maxi_spm_awready) begin
            th_ctrl <= th_ctrl_31;
          end 
        end
        th_ctrl_31: begin
          if(_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_32;
          end 
        end
        th_ctrl_32: begin
          if(_maxi_spm_wvalid_sb_0 && _maxi_spm_wready_sb_0) begin
            th_ctrl <= th_ctrl_33;
          end 
        end
        th_ctrl_33: begin
          if(!_maxi_spm_has_outstanding_write) begin
            th_ctrl <= th_ctrl_34;
          end 
        end
        th_ctrl_34: begin
          if((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid)) begin
            th_ctrl <= th_ctrl_35;
          end 
        end
        th_ctrl_35: begin
          if(maxi_spm_awvalid && maxi_spm_awready) begin
            th_ctrl <= th_ctrl_36;
          end 
        end
        th_ctrl_36: begin
          if(_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_37;
          end 
        end
        th_ctrl_37: begin
          if(_maxi_spm_wvalid_sb_0 && _maxi_spm_wready_sb_0) begin
            th_ctrl <= th_ctrl_38;
          end 
        end
        th_ctrl_38: begin
          if(!_maxi_spm_has_outstanding_write) begin
            th_ctrl <= th_ctrl_39;
          end 
        end
        th_ctrl_39: begin
          _th_ctrl_i_1 <= 0;
          th_ctrl <= th_ctrl_40;
        end
        th_ctrl_40: begin
          if(_th_ctrl_i_1 < 4) begin
            th_ctrl <= th_ctrl_41;
          end else begin
            th_ctrl <= th_ctrl_45;
          end
        end
        th_ctrl_41: begin
          write_data_86 <= _th_ctrl_i_1 + 4096 + (_th_ctrl_i_1 << 32) + (_th_ctrl_i_1 << 64) + (_th_ctrl_i_1 << 96);
          th_ctrl <= th_ctrl_42;
        end
        th_ctrl_42: begin
          if(_m_axis_spm_write_idle) begin
            th_ctrl <= th_ctrl_43;
          end 
        end
        th_ctrl_43: begin
          if(m_axis_spm_tready || !m_axis_spm_tvalid) begin
            th_ctrl <= th_ctrl_44;
          end 
        end
        th_ctrl_44: begin
          _th_ctrl_i_1 <= _th_ctrl_i_1 + 1;
          th_ctrl <= th_ctrl_40;
        end
        th_ctrl_45: begin
          if(1) begin
            th_ctrl <= th_ctrl_46;
          end else begin
            th_ctrl <= th_ctrl_52;
          end
        end
        th_ctrl_46: begin
          if(maxi_spm_arready || !maxi_spm_arvalid) begin
            th_ctrl <= th_ctrl_47;
          end 
        end
        th_ctrl_47: begin
          if(maxi_spm_arvalid && maxi_spm_arready) begin
            th_ctrl <= th_ctrl_48;
          end 
        end
        th_ctrl_48: begin
          if(_maxi_spm_rvalid_sb_0) begin
            axim_rdata_88 <= _maxi_spm_rdata_sb_0;
          end 
          if(_maxi_spm_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_49;
          end 
        end
        th_ctrl_49: begin
          if(axim_rdata_88 == 0) begin
            th_ctrl <= th_ctrl_50;
          end else begin
            th_ctrl <= th_ctrl_51;
          end
        end
        th_ctrl_50: begin
          th_ctrl <= th_ctrl_52;
        end
        th_ctrl_51: begin
          th_ctrl <= th_ctrl_45;
        end
        th_ctrl_52: begin
          // $display("DMA Write to DRAM");
          th_ctrl <= th_ctrl_53;
        end
        th_ctrl_53: begin
          if((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid)) begin
            th_ctrl <= th_ctrl_54;
          end 
        end
        th_ctrl_54: begin
          if(maxi_spm_awvalid && maxi_spm_awready) begin
            th_ctrl <= th_ctrl_55;
          end 
        end
        th_ctrl_55: begin
          if(_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_56;
          end 
        end
        th_ctrl_56: begin
          if(_maxi_spm_wvalid_sb_0 && _maxi_spm_wready_sb_0) begin
            th_ctrl <= th_ctrl_57;
          end 
        end
        th_ctrl_57: begin
          if(!_maxi_spm_has_outstanding_write) begin
            th_ctrl <= th_ctrl_58;
          end 
        end
        th_ctrl_58: begin
          if((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid)) begin
            th_ctrl <= th_ctrl_59;
          end 
        end
        th_ctrl_59: begin
          if(maxi_spm_awvalid && maxi_spm_awready) begin
            th_ctrl <= th_ctrl_60;
          end 
        end
        th_ctrl_60: begin
          if(_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_61;
          end 
        end
        th_ctrl_61: begin
          if(_maxi_spm_wvalid_sb_0 && _maxi_spm_wready_sb_0) begin
            th_ctrl <= th_ctrl_62;
          end 
        end
        th_ctrl_62: begin
          if(!_maxi_spm_has_outstanding_write) begin
            th_ctrl <= th_ctrl_63;
          end 
        end
        th_ctrl_63: begin
          if((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid)) begin
            th_ctrl <= th_ctrl_64;
          end 
        end
        th_ctrl_64: begin
          if(maxi_spm_awvalid && maxi_spm_awready) begin
            th_ctrl <= th_ctrl_65;
          end 
        end
        th_ctrl_65: begin
          if(_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_66;
          end 
        end
        th_ctrl_66: begin
          if(_maxi_spm_wvalid_sb_0 && _maxi_spm_wready_sb_0) begin
            th_ctrl <= th_ctrl_67;
          end 
        end
        th_ctrl_67: begin
          if(!_maxi_spm_has_outstanding_write) begin
            th_ctrl <= th_ctrl_68;
          end 
        end
        th_ctrl_68: begin
          if((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid)) begin
            th_ctrl <= th_ctrl_69;
          end 
        end
        th_ctrl_69: begin
          if(maxi_spm_awvalid && maxi_spm_awready) begin
            th_ctrl <= th_ctrl_70;
          end 
        end
        th_ctrl_70: begin
          if(_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_71;
          end 
        end
        th_ctrl_71: begin
          if(_maxi_spm_wvalid_sb_0 && _maxi_spm_wready_sb_0) begin
            th_ctrl <= th_ctrl_72;
          end 
        end
        th_ctrl_72: begin
          if(!_maxi_spm_has_outstanding_write) begin
            th_ctrl <= th_ctrl_73;
          end 
        end
        th_ctrl_73: begin
          if((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid)) begin
            th_ctrl <= th_ctrl_74;
          end 
        end
        th_ctrl_74: begin
          if(maxi_spm_awvalid && maxi_spm_awready) begin
            th_ctrl <= th_ctrl_75;
          end 
        end
        th_ctrl_75: begin
          if(_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_76;
          end 
        end
        th_ctrl_76: begin
          if(_maxi_spm_wvalid_sb_0 && _maxi_spm_wready_sb_0) begin
            th_ctrl <= th_ctrl_77;
          end 
        end
        th_ctrl_77: begin
          if(!_maxi_spm_has_outstanding_write) begin
            th_ctrl <= th_ctrl_78;
          end 
        end
        th_ctrl_78: begin
          if((_maxi_spm_outstanding_wcount == 0) && (maxi_spm_awready || !maxi_spm_awvalid)) begin
            th_ctrl <= th_ctrl_79;
          end 
        end
        th_ctrl_79: begin
          if(maxi_spm_awvalid && maxi_spm_awready) begin
            th_ctrl <= th_ctrl_80;
          end 
        end
        th_ctrl_80: begin
          if(_maxi_spm_wready_sb_0 || !_maxi_spm_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_81;
          end 
        end
        th_ctrl_81: begin
          if(_maxi_spm_wvalid_sb_0 && _maxi_spm_wready_sb_0) begin
            th_ctrl <= th_ctrl_82;
          end 
        end
        th_ctrl_82: begin
          if(!_maxi_spm_has_outstanding_write) begin
            th_ctrl <= th_ctrl_83;
          end 
        end
        th_ctrl_83: begin
          if(1) begin
            th_ctrl <= th_ctrl_84;
          end else begin
            th_ctrl <= th_ctrl_90;
          end
        end
        th_ctrl_84: begin
          if(maxi_spm_arready || !maxi_spm_arvalid) begin
            th_ctrl <= th_ctrl_85;
          end 
        end
        th_ctrl_85: begin
          if(maxi_spm_arvalid && maxi_spm_arready) begin
            th_ctrl <= th_ctrl_86;
          end 
        end
        th_ctrl_86: begin
          if(_maxi_spm_rvalid_sb_0) begin
            axim_rdata_89 <= _maxi_spm_rdata_sb_0;
          end 
          if(_maxi_spm_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_87;
          end 
        end
        th_ctrl_87: begin
          if(axim_rdata_89 == 0) begin
            th_ctrl <= th_ctrl_88;
          end else begin
            th_ctrl <= th_ctrl_89;
          end
        end
        th_ctrl_88: begin
          th_ctrl <= th_ctrl_90;
        end
        th_ctrl_89: begin
          th_ctrl <= th_ctrl_83;
        end
        th_ctrl_90: begin
          // $display("DMA Write to DRAM completed");
          th_ctrl <= th_ctrl_91;
        end
        th_ctrl_91: begin
          complete <= 1;
          th_ctrl <= th_ctrl_92;
        end
      endcase
    end
  end

  localparam fsm_1 = 1;
  localparam fsm_2 = 2;
  localparam fsm_3 = 3;
  localparam fsm_4 = 4;
  localparam fsm_5 = 5;
  localparam fsm_6 = 6;
  localparam fsm_7 = 7;

  always @(posedge CLK) begin
    if(RST) begin
      fsm <= fsm_init;
      rdata_90 <= 0;
      rdata_91 <= 0;
      rdata_92 <= 0;
      rdata_93 <= 0;
    end else begin
      case(fsm)
        fsm_init: begin
          fsm <= fsm_1;
        end
        fsm_1: begin
          if(complete == 1) begin
            fsm <= fsm_2;
          end 
        end
        fsm_2: begin
          if(fsm == 2) begin
            rdata_90 <= { _memory_mem[4099], _memory_mem[4098], _memory_mem[4097], _memory_mem[4096] };
          end 
          fsm <= fsm_3;
        end
        fsm_3: begin
          $display("memory[0x1000] = %x", rdata_90);
          if(fsm == 3) begin
            rdata_91 <= { _memory_mem[4103], _memory_mem[4102], _memory_mem[4101], _memory_mem[4100] };
          end 
          fsm <= fsm_4;
        end
        fsm_4: begin
          $display("memory[0x1004] = %x", rdata_91);
          if(fsm == 4) begin
            rdata_92 <= { _memory_mem[4107], _memory_mem[4106], _memory_mem[4105], _memory_mem[4104] };
          end 
          fsm <= fsm_5;
        end
        fsm_5: begin
          $display("memory[0x1008] = %x", rdata_92);
          if(fsm == 5) begin
            rdata_93 <= { _memory_mem[4159], _memory_mem[4158], _memory_mem[4157], _memory_mem[4156] };
          end 
          fsm <= fsm_6;
        end
        fsm_6: begin
          $display("memory[0x100c] = %x", rdata_93);
          fsm <= fsm_7;
        end
      endcase
    end
  end


endmodule



module _s_axis_spm_read_req_fifo
(
  input CLK,
  input RST,
  input _s_axis_spm_read_req_fifo_enq,
  input [105-1:0] _s_axis_spm_read_req_fifo_wdata,
  output _s_axis_spm_read_req_fifo_full,
  output _s_axis_spm_read_req_fifo_almost_full,
  input _s_axis_spm_read_req_fifo_deq,
  output [105-1:0] _s_axis_spm_read_req_fifo_rdata,
  output _s_axis_spm_read_req_fifo_empty,
  output _s_axis_spm_read_req_fifo_almost_empty
);

  reg [105-1:0] mem [0:8-1];
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
  wire [105-1:0] rdata;
  assign _s_axis_spm_read_req_fifo_full = is_full;
  assign _s_axis_spm_read_req_fifo_almost_full = is_almost_full || is_full;
  assign _s_axis_spm_read_req_fifo_empty = is_empty;
  assign _s_axis_spm_read_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _s_axis_spm_read_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_s_axis_spm_read_req_fifo_enq && !is_full) begin
        mem[head] <= _s_axis_spm_read_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_s_axis_spm_read_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _m_axis_spm_write_req_fifo
(
  input CLK,
  input RST,
  input _m_axis_spm_write_req_fifo_enq,
  input [105-1:0] _m_axis_spm_write_req_fifo_wdata,
  output _m_axis_spm_write_req_fifo_full,
  output _m_axis_spm_write_req_fifo_almost_full,
  input _m_axis_spm_write_req_fifo_deq,
  output [105-1:0] _m_axis_spm_write_req_fifo_rdata,
  output _m_axis_spm_write_req_fifo_empty,
  output _m_axis_spm_write_req_fifo_almost_empty
);

  reg [105-1:0] mem [0:8-1];
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
  wire [105-1:0] rdata;
  assign _m_axis_spm_write_req_fifo_full = is_full;
  assign _m_axis_spm_write_req_fifo_almost_full = is_almost_full || is_full;
  assign _m_axis_spm_write_req_fifo_empty = is_empty;
  assign _m_axis_spm_write_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _m_axis_spm_write_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_m_axis_spm_write_req_fifo_enq && !is_full) begin
        mem[head] <= _m_axis_spm_write_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_m_axis_spm_write_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _memory_wreq_fifo
(
  input CLK,
  input RST,
  input _memory_wreq_fifo_enq,
  input [41-1:0] _memory_wreq_fifo_wdata,
  output _memory_wreq_fifo_full,
  output _memory_wreq_fifo_almost_full,
  input _memory_wreq_fifo_deq,
  output [41-1:0] _memory_wreq_fifo_rdata,
  output _memory_wreq_fifo_empty,
  output _memory_wreq_fifo_almost_empty
);

  reg [41-1:0] mem [0:8-1];
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
  wire [41-1:0] rdata;
  assign _memory_wreq_fifo_full = is_full;
  assign _memory_wreq_fifo_almost_full = is_almost_full || is_full;
  assign _memory_wreq_fifo_empty = is_empty;
  assign _memory_wreq_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _memory_wreq_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_memory_wreq_fifo_enq && !is_full) begin
        mem[head] <= _memory_wreq_fifo_wdata;
        head <= head + 1;
      end 
      if(_memory_wreq_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _memory_rreq_fifo
(
  input CLK,
  input RST,
  input _memory_rreq_fifo_enq,
  input [41-1:0] _memory_rreq_fifo_wdata,
  output _memory_rreq_fifo_full,
  output _memory_rreq_fifo_almost_full,
  input _memory_rreq_fifo_deq,
  output [41-1:0] _memory_rreq_fifo_rdata,
  output _memory_rreq_fifo_empty,
  output _memory_rreq_fifo_almost_empty
);

  reg [41-1:0] mem [0:8-1];
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
  wire [41-1:0] rdata;
  assign _memory_rreq_fifo_full = is_full;
  assign _memory_rreq_fifo_almost_full = is_almost_full || is_full;
  assign _memory_rreq_fifo_empty = is_empty;
  assign _memory_rreq_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _memory_rreq_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_memory_rreq_fifo_enq && !is_full) begin
        mem[head] <= _memory_rreq_fifo_wdata;
        head <= head + 1;
      end 
      if(_memory_rreq_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _memory_wdata_fifo
(
  input CLK,
  input RST,
  input _memory_wdata_fifo_enq,
  input [145-1:0] _memory_wdata_fifo_wdata,
  output _memory_wdata_fifo_full,
  output _memory_wdata_fifo_almost_full,
  input _memory_wdata_fifo_deq,
  output [145-1:0] _memory_wdata_fifo_rdata,
  output _memory_wdata_fifo_empty,
  output _memory_wdata_fifo_almost_empty
);

  reg [145-1:0] mem [0:8-1];
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
  wire [145-1:0] rdata;
  assign _memory_wdata_fifo_full = is_full;
  assign _memory_wdata_fifo_almost_full = is_almost_full || is_full;
  assign _memory_wdata_fifo_empty = is_empty;
  assign _memory_wdata_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _memory_wdata_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_memory_wdata_fifo_enq && !is_full) begin
        mem[head] <= _memory_wdata_fifo_wdata;
        head <= head + 1;
      end 
      if(_memory_wdata_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module spm
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
  input [2-1:0] axi_m_dram_bresp,
  input axi_m_dram_bvalid,
  output axi_m_dram_bready,
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
  input [128-1:0] axi_m_dram_rdata,
  input [2-1:0] axi_m_dram_rresp,
  input axi_m_dram_rlast,
  input axi_m_dram_rvalid,
  output axi_m_dram_rready,
  output reg [128-1:0] axis_out_mac_spm_tdata,
  output reg axis_out_mac_spm_tvalid,
  input axis_out_mac_spm_tready,
  output reg axis_out_mac_spm_tlast,
  output reg [128-1:0] axis_out_axim_spm_tdata,
  output reg axis_out_axim_spm_tvalid,
  input axis_out_axim_spm_tready,
  output reg axis_out_axim_spm_tlast,
  input [128-1:0] axis_in_axim_spm_tdata,
  input axis_in_axim_spm_tvalid,
  output axis_in_axim_spm_tready,
  input axis_in_axim_spm_tlast,
  output reg [128-1:0] axis_out_xored_spm_tdata,
  output reg axis_out_xored_spm_tvalid,
  input axis_out_xored_spm_tready,
  output reg axis_out_xored_spm_tlast,
  input [128-1:0] axis_in_xored_spm_tdata,
  input axis_in_xored_spm_tvalid,
  output axis_in_xored_spm_tready,
  input axis_in_xored_spm_tlast,
  input [9-1:0] ram_spm_1_addr,
  output [64-1:0] ram_spm_1_rdata,
  input [64-1:0] ram_spm_1_wdata,
  input ram_spm_1_wenable,
  input ram_spm_1_enable
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
  wire _axis_out_mac_spm_write_req_fifo_enq;
  wire [105-1:0] _axis_out_mac_spm_write_req_fifo_wdata;
  wire _axis_out_mac_spm_write_req_fifo_full;
  wire _axis_out_mac_spm_write_req_fifo_almost_full;
  wire _axis_out_mac_spm_write_req_fifo_deq;
  wire [105-1:0] _axis_out_mac_spm_write_req_fifo_rdata;
  wire _axis_out_mac_spm_write_req_fifo_empty;
  wire _axis_out_mac_spm_write_req_fifo_almost_empty;

  _axis_out_mac_spm_write_req_fifo
  inst__axis_out_mac_spm_write_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axis_out_mac_spm_write_req_fifo_enq(_axis_out_mac_spm_write_req_fifo_enq),
    ._axis_out_mac_spm_write_req_fifo_wdata(_axis_out_mac_spm_write_req_fifo_wdata),
    ._axis_out_mac_spm_write_req_fifo_full(_axis_out_mac_spm_write_req_fifo_full),
    ._axis_out_mac_spm_write_req_fifo_almost_full(_axis_out_mac_spm_write_req_fifo_almost_full),
    ._axis_out_mac_spm_write_req_fifo_deq(_axis_out_mac_spm_write_req_fifo_deq),
    ._axis_out_mac_spm_write_req_fifo_rdata(_axis_out_mac_spm_write_req_fifo_rdata),
    ._axis_out_mac_spm_write_req_fifo_empty(_axis_out_mac_spm_write_req_fifo_empty),
    ._axis_out_mac_spm_write_req_fifo_almost_empty(_axis_out_mac_spm_write_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axis_out_mac_spm_write_req_fifo;
  wire [8-1:0] _axis_out_mac_spm_write_op_sel_fifo;
  wire [32-1:0] _axis_out_mac_spm_write_local_addr_fifo;
  wire [32-1:0] _axis_out_mac_spm_write_local_stride_fifo;
  wire [33-1:0] _axis_out_mac_spm_write_size_fifo;
  wire [8-1:0] unpack_write_req_op_sel_49;
  wire [32-1:0] unpack_write_req_local_addr_50;
  wire [32-1:0] unpack_write_req_local_stride_51;
  wire [33-1:0] unpack_write_req_local_size_52;
  assign unpack_write_req_op_sel_49 = _axis_out_mac_spm_write_req_fifo_rdata[104:97];
  assign unpack_write_req_local_addr_50 = _axis_out_mac_spm_write_req_fifo_rdata[96:65];
  assign unpack_write_req_local_stride_51 = _axis_out_mac_spm_write_req_fifo_rdata[64:33];
  assign unpack_write_req_local_size_52 = _axis_out_mac_spm_write_req_fifo_rdata[32:0];
  assign _axis_out_mac_spm_write_op_sel_fifo = unpack_write_req_op_sel_49;
  assign _axis_out_mac_spm_write_local_addr_fifo = unpack_write_req_local_addr_50;
  assign _axis_out_mac_spm_write_local_stride_fifo = unpack_write_req_local_stride_51;
  assign _axis_out_mac_spm_write_size_fifo = unpack_write_req_local_size_52;
  reg [8-1:0] _axis_out_mac_spm_write_op_sel_buf;
  reg [32-1:0] _axis_out_mac_spm_write_local_addr_buf;
  reg [32-1:0] _axis_out_mac_spm_write_local_stride_buf;
  reg [33-1:0] _axis_out_mac_spm_write_size_buf;
  reg _axis_out_mac_spm_write_data_busy;
  wire _axis_out_mac_spm_write_data_idle;
  wire _axis_out_mac_spm_write_idle;
  assign _axis_out_mac_spm_write_data_idle = _axis_out_mac_spm_write_req_fifo_empty && !_axis_out_mac_spm_write_data_busy;
  assign _axis_out_mac_spm_write_idle = _axis_out_mac_spm_write_data_idle;
  wire _axis_out_axim_spm_write_req_fifo_enq;
  wire [105-1:0] _axis_out_axim_spm_write_req_fifo_wdata;
  wire _axis_out_axim_spm_write_req_fifo_full;
  wire _axis_out_axim_spm_write_req_fifo_almost_full;
  wire _axis_out_axim_spm_write_req_fifo_deq;
  wire [105-1:0] _axis_out_axim_spm_write_req_fifo_rdata;
  wire _axis_out_axim_spm_write_req_fifo_empty;
  wire _axis_out_axim_spm_write_req_fifo_almost_empty;

  _axis_out_axim_spm_write_req_fifo
  inst__axis_out_axim_spm_write_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axis_out_axim_spm_write_req_fifo_enq(_axis_out_axim_spm_write_req_fifo_enq),
    ._axis_out_axim_spm_write_req_fifo_wdata(_axis_out_axim_spm_write_req_fifo_wdata),
    ._axis_out_axim_spm_write_req_fifo_full(_axis_out_axim_spm_write_req_fifo_full),
    ._axis_out_axim_spm_write_req_fifo_almost_full(_axis_out_axim_spm_write_req_fifo_almost_full),
    ._axis_out_axim_spm_write_req_fifo_deq(_axis_out_axim_spm_write_req_fifo_deq),
    ._axis_out_axim_spm_write_req_fifo_rdata(_axis_out_axim_spm_write_req_fifo_rdata),
    ._axis_out_axim_spm_write_req_fifo_empty(_axis_out_axim_spm_write_req_fifo_empty),
    ._axis_out_axim_spm_write_req_fifo_almost_empty(_axis_out_axim_spm_write_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axis_out_axim_spm_write_req_fifo;
  wire [8-1:0] _axis_out_axim_spm_write_op_sel_fifo;
  wire [32-1:0] _axis_out_axim_spm_write_local_addr_fifo;
  wire [32-1:0] _axis_out_axim_spm_write_local_stride_fifo;
  wire [33-1:0] _axis_out_axim_spm_write_size_fifo;
  wire [8-1:0] unpack_write_req_op_sel_53;
  wire [32-1:0] unpack_write_req_local_addr_54;
  wire [32-1:0] unpack_write_req_local_stride_55;
  wire [33-1:0] unpack_write_req_local_size_56;
  assign unpack_write_req_op_sel_53 = _axis_out_axim_spm_write_req_fifo_rdata[104:97];
  assign unpack_write_req_local_addr_54 = _axis_out_axim_spm_write_req_fifo_rdata[96:65];
  assign unpack_write_req_local_stride_55 = _axis_out_axim_spm_write_req_fifo_rdata[64:33];
  assign unpack_write_req_local_size_56 = _axis_out_axim_spm_write_req_fifo_rdata[32:0];
  assign _axis_out_axim_spm_write_op_sel_fifo = unpack_write_req_op_sel_53;
  assign _axis_out_axim_spm_write_local_addr_fifo = unpack_write_req_local_addr_54;
  assign _axis_out_axim_spm_write_local_stride_fifo = unpack_write_req_local_stride_55;
  assign _axis_out_axim_spm_write_size_fifo = unpack_write_req_local_size_56;
  reg [8-1:0] _axis_out_axim_spm_write_op_sel_buf;
  reg [32-1:0] _axis_out_axim_spm_write_local_addr_buf;
  reg [32-1:0] _axis_out_axim_spm_write_local_stride_buf;
  reg [33-1:0] _axis_out_axim_spm_write_size_buf;
  reg _axis_out_axim_spm_write_data_busy;
  wire _axis_out_axim_spm_write_data_idle;
  wire _axis_out_axim_spm_write_idle;
  assign _axis_out_axim_spm_write_data_idle = _axis_out_axim_spm_write_req_fifo_empty && !_axis_out_axim_spm_write_data_busy;
  assign _axis_out_axim_spm_write_idle = _axis_out_axim_spm_write_data_idle;
  wire _axis_in_axim_spm_read_req_fifo_enq;
  wire [105-1:0] _axis_in_axim_spm_read_req_fifo_wdata;
  wire _axis_in_axim_spm_read_req_fifo_full;
  wire _axis_in_axim_spm_read_req_fifo_almost_full;
  wire _axis_in_axim_spm_read_req_fifo_deq;
  wire [105-1:0] _axis_in_axim_spm_read_req_fifo_rdata;
  wire _axis_in_axim_spm_read_req_fifo_empty;
  wire _axis_in_axim_spm_read_req_fifo_almost_empty;

  _axis_in_axim_spm_read_req_fifo
  inst__axis_in_axim_spm_read_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axis_in_axim_spm_read_req_fifo_enq(_axis_in_axim_spm_read_req_fifo_enq),
    ._axis_in_axim_spm_read_req_fifo_wdata(_axis_in_axim_spm_read_req_fifo_wdata),
    ._axis_in_axim_spm_read_req_fifo_full(_axis_in_axim_spm_read_req_fifo_full),
    ._axis_in_axim_spm_read_req_fifo_almost_full(_axis_in_axim_spm_read_req_fifo_almost_full),
    ._axis_in_axim_spm_read_req_fifo_deq(_axis_in_axim_spm_read_req_fifo_deq),
    ._axis_in_axim_spm_read_req_fifo_rdata(_axis_in_axim_spm_read_req_fifo_rdata),
    ._axis_in_axim_spm_read_req_fifo_empty(_axis_in_axim_spm_read_req_fifo_empty),
    ._axis_in_axim_spm_read_req_fifo_almost_empty(_axis_in_axim_spm_read_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axis_in_axim_spm_read_req_fifo;
  wire [8-1:0] _axis_in_axim_spm_read_op_sel_fifo;
  wire [32-1:0] _axis_in_axim_spm_read_local_addr_fifo;
  wire [32-1:0] _axis_in_axim_spm_read_local_stride_fifo;
  wire [33-1:0] _axis_in_axim_spm_read_local_size_fifo;
  wire [8-1:0] unpack_read_req_op_sel_57;
  wire [32-1:0] unpack_read_req_local_addr_58;
  wire [32-1:0] unpack_read_req_local_stride_59;
  wire [33-1:0] unpack_read_req_local_size_60;
  assign unpack_read_req_op_sel_57 = _axis_in_axim_spm_read_req_fifo_rdata[104:97];
  assign unpack_read_req_local_addr_58 = _axis_in_axim_spm_read_req_fifo_rdata[96:65];
  assign unpack_read_req_local_stride_59 = _axis_in_axim_spm_read_req_fifo_rdata[64:33];
  assign unpack_read_req_local_size_60 = _axis_in_axim_spm_read_req_fifo_rdata[32:0];
  assign _axis_in_axim_spm_read_op_sel_fifo = unpack_read_req_op_sel_57;
  assign _axis_in_axim_spm_read_local_addr_fifo = unpack_read_req_local_addr_58;
  assign _axis_in_axim_spm_read_local_stride_fifo = unpack_read_req_local_stride_59;
  assign _axis_in_axim_spm_read_local_size_fifo = unpack_read_req_local_size_60;
  reg [8-1:0] _axis_in_axim_spm_read_op_sel_buf;
  reg [32-1:0] _axis_in_axim_spm_read_local_addr_buf;
  reg [32-1:0] _axis_in_axim_spm_read_local_stride_buf;
  reg [33-1:0] _axis_in_axim_spm_read_local_size_buf;
  reg _axis_in_axim_spm_read_data_busy;
  wire _axis_in_axim_spm_read_data_idle;
  wire _axis_in_axim_spm_read_idle;
  assign _axis_in_axim_spm_read_data_idle = _axis_in_axim_spm_read_req_fifo_empty && !_axis_in_axim_spm_read_data_busy;
  assign _axis_in_axim_spm_read_idle = _axis_in_axim_spm_read_data_idle;
  wire _axis_out_xored_spm_write_req_fifo_enq;
  wire [105-1:0] _axis_out_xored_spm_write_req_fifo_wdata;
  wire _axis_out_xored_spm_write_req_fifo_full;
  wire _axis_out_xored_spm_write_req_fifo_almost_full;
  wire _axis_out_xored_spm_write_req_fifo_deq;
  wire [105-1:0] _axis_out_xored_spm_write_req_fifo_rdata;
  wire _axis_out_xored_spm_write_req_fifo_empty;
  wire _axis_out_xored_spm_write_req_fifo_almost_empty;

  _axis_out_xored_spm_write_req_fifo
  inst__axis_out_xored_spm_write_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axis_out_xored_spm_write_req_fifo_enq(_axis_out_xored_spm_write_req_fifo_enq),
    ._axis_out_xored_spm_write_req_fifo_wdata(_axis_out_xored_spm_write_req_fifo_wdata),
    ._axis_out_xored_spm_write_req_fifo_full(_axis_out_xored_spm_write_req_fifo_full),
    ._axis_out_xored_spm_write_req_fifo_almost_full(_axis_out_xored_spm_write_req_fifo_almost_full),
    ._axis_out_xored_spm_write_req_fifo_deq(_axis_out_xored_spm_write_req_fifo_deq),
    ._axis_out_xored_spm_write_req_fifo_rdata(_axis_out_xored_spm_write_req_fifo_rdata),
    ._axis_out_xored_spm_write_req_fifo_empty(_axis_out_xored_spm_write_req_fifo_empty),
    ._axis_out_xored_spm_write_req_fifo_almost_empty(_axis_out_xored_spm_write_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axis_out_xored_spm_write_req_fifo;
  wire [8-1:0] _axis_out_xored_spm_write_op_sel_fifo;
  wire [32-1:0] _axis_out_xored_spm_write_local_addr_fifo;
  wire [32-1:0] _axis_out_xored_spm_write_local_stride_fifo;
  wire [33-1:0] _axis_out_xored_spm_write_size_fifo;
  wire [8-1:0] unpack_write_req_op_sel_61;
  wire [32-1:0] unpack_write_req_local_addr_62;
  wire [32-1:0] unpack_write_req_local_stride_63;
  wire [33-1:0] unpack_write_req_local_size_64;
  assign unpack_write_req_op_sel_61 = _axis_out_xored_spm_write_req_fifo_rdata[104:97];
  assign unpack_write_req_local_addr_62 = _axis_out_xored_spm_write_req_fifo_rdata[96:65];
  assign unpack_write_req_local_stride_63 = _axis_out_xored_spm_write_req_fifo_rdata[64:33];
  assign unpack_write_req_local_size_64 = _axis_out_xored_spm_write_req_fifo_rdata[32:0];
  assign _axis_out_xored_spm_write_op_sel_fifo = unpack_write_req_op_sel_61;
  assign _axis_out_xored_spm_write_local_addr_fifo = unpack_write_req_local_addr_62;
  assign _axis_out_xored_spm_write_local_stride_fifo = unpack_write_req_local_stride_63;
  assign _axis_out_xored_spm_write_size_fifo = unpack_write_req_local_size_64;
  reg [8-1:0] _axis_out_xored_spm_write_op_sel_buf;
  reg [32-1:0] _axis_out_xored_spm_write_local_addr_buf;
  reg [32-1:0] _axis_out_xored_spm_write_local_stride_buf;
  reg [33-1:0] _axis_out_xored_spm_write_size_buf;
  reg _axis_out_xored_spm_write_data_busy;
  wire _axis_out_xored_spm_write_data_idle;
  wire _axis_out_xored_spm_write_idle;
  assign _axis_out_xored_spm_write_data_idle = _axis_out_xored_spm_write_req_fifo_empty && !_axis_out_xored_spm_write_data_busy;
  assign _axis_out_xored_spm_write_idle = _axis_out_xored_spm_write_data_idle;
  wire _axis_in_xored_spm_read_req_fifo_enq;
  wire [105-1:0] _axis_in_xored_spm_read_req_fifo_wdata;
  wire _axis_in_xored_spm_read_req_fifo_full;
  wire _axis_in_xored_spm_read_req_fifo_almost_full;
  wire _axis_in_xored_spm_read_req_fifo_deq;
  wire [105-1:0] _axis_in_xored_spm_read_req_fifo_rdata;
  wire _axis_in_xored_spm_read_req_fifo_empty;
  wire _axis_in_xored_spm_read_req_fifo_almost_empty;

  _axis_in_xored_spm_read_req_fifo
  inst__axis_in_xored_spm_read_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axis_in_xored_spm_read_req_fifo_enq(_axis_in_xored_spm_read_req_fifo_enq),
    ._axis_in_xored_spm_read_req_fifo_wdata(_axis_in_xored_spm_read_req_fifo_wdata),
    ._axis_in_xored_spm_read_req_fifo_full(_axis_in_xored_spm_read_req_fifo_full),
    ._axis_in_xored_spm_read_req_fifo_almost_full(_axis_in_xored_spm_read_req_fifo_almost_full),
    ._axis_in_xored_spm_read_req_fifo_deq(_axis_in_xored_spm_read_req_fifo_deq),
    ._axis_in_xored_spm_read_req_fifo_rdata(_axis_in_xored_spm_read_req_fifo_rdata),
    ._axis_in_xored_spm_read_req_fifo_empty(_axis_in_xored_spm_read_req_fifo_empty),
    ._axis_in_xored_spm_read_req_fifo_almost_empty(_axis_in_xored_spm_read_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axis_in_xored_spm_read_req_fifo;
  wire [8-1:0] _axis_in_xored_spm_read_op_sel_fifo;
  wire [32-1:0] _axis_in_xored_spm_read_local_addr_fifo;
  wire [32-1:0] _axis_in_xored_spm_read_local_stride_fifo;
  wire [33-1:0] _axis_in_xored_spm_read_local_size_fifo;
  wire [8-1:0] unpack_read_req_op_sel_65;
  wire [32-1:0] unpack_read_req_local_addr_66;
  wire [32-1:0] unpack_read_req_local_stride_67;
  wire [33-1:0] unpack_read_req_local_size_68;
  assign unpack_read_req_op_sel_65 = _axis_in_xored_spm_read_req_fifo_rdata[104:97];
  assign unpack_read_req_local_addr_66 = _axis_in_xored_spm_read_req_fifo_rdata[96:65];
  assign unpack_read_req_local_stride_67 = _axis_in_xored_spm_read_req_fifo_rdata[64:33];
  assign unpack_read_req_local_size_68 = _axis_in_xored_spm_read_req_fifo_rdata[32:0];
  assign _axis_in_xored_spm_read_op_sel_fifo = unpack_read_req_op_sel_65;
  assign _axis_in_xored_spm_read_local_addr_fifo = unpack_read_req_local_addr_66;
  assign _axis_in_xored_spm_read_local_stride_fifo = unpack_read_req_local_stride_67;
  assign _axis_in_xored_spm_read_local_size_fifo = unpack_read_req_local_size_68;
  reg [8-1:0] _axis_in_xored_spm_read_op_sel_buf;
  reg [32-1:0] _axis_in_xored_spm_read_local_addr_buf;
  reg [32-1:0] _axis_in_xored_spm_read_local_stride_buf;
  reg [33-1:0] _axis_in_xored_spm_read_local_size_buf;
  reg _axis_in_xored_spm_read_data_busy;
  wire _axis_in_xored_spm_read_data_idle;
  wire _axis_in_xored_spm_read_idle;
  assign _axis_in_xored_spm_read_data_idle = _axis_in_xored_spm_read_req_fifo_empty && !_axis_in_xored_spm_read_data_busy;
  assign _axis_in_xored_spm_read_idle = _axis_in_xored_spm_read_data_idle;
  wire [9-1:0] ram_spm_0_addr;
  wire [64-1:0] ram_spm_0_rdata;
  wire [64-1:0] ram_spm_0_wdata;
  wire ram_spm_0_wenable;
  wire ram_spm_0_enable;

  ram_spm
  inst_ram_spm
  (
    .CLK(CLK),
    .ram_spm_0_addr(ram_spm_0_addr),
    .ram_spm_0_rdata(ram_spm_0_rdata),
    .ram_spm_0_wdata(ram_spm_0_wdata),
    .ram_spm_0_wenable(ram_spm_0_wenable),
    .ram_spm_0_enable(ram_spm_0_enable),
    .ram_spm_1_addr(ram_spm_1_addr),
    .ram_spm_1_rdata(ram_spm_1_rdata),
    .ram_spm_1_wdata(ram_spm_1_wdata),
    .ram_spm_1_wenable(ram_spm_1_wenable),
    .ram_spm_1_enable(ram_spm_1_enable)
  );

  reg [64-1:0] dram_addr_69;
  reg [64-1:0] spm_addr_70;
  reg [64-1:0] direction_71;
  reg [64-1:0] destination_72;
  reg [64-1:0] size_73;
  reg [64-1:0] status_74;
  reg [128-1:0] tmp_data_75;
  reg [64-1:0] tmp_data_2_76;
  reg [32-1:0] spm_thread;
  localparam spm_thread_init = 0;
  wire [32-1:0] mask_addr_shifted_77;
  assign mask_addr_shifted_77 = dram_addr_69 >> 4;
  wire [32-1:0] mask_addr_masked_78;
  assign mask_addr_masked_78 = mask_addr_shifted_77 << 4;
  reg [32-1:0] _axi_m_dram_read_req_fsm;
  localparam _axi_m_dram_read_req_fsm_init = 0;
  reg [33-1:0] _axi_m_dram_read_cur_global_size;
  reg _axi_m_dram_read_cont;
  wire [8-1:0] pack_read_req_op_sel_79;
  wire [32-1:0] pack_read_req_local_addr_80;
  wire [32-1:0] pack_read_req_local_stride_81;
  wire [33-1:0] pack_read_req_local_size_82;
  wire [32-1:0] pack_read_req_local_blocksize_83;
  assign pack_read_req_op_sel_79 = _axi_m_dram_read_op_sel;
  assign pack_read_req_local_addr_80 = _axi_m_dram_read_local_addr;
  assign pack_read_req_local_stride_81 = _axi_m_dram_read_local_stride;
  assign pack_read_req_local_size_82 = _axi_m_dram_read_local_size;
  assign pack_read_req_local_blocksize_83 = _axi_m_dram_read_local_blocksize;
  wire [137-1:0] pack_read_req_packed_84;
  assign pack_read_req_packed_84 = { pack_read_req_op_sel_79, pack_read_req_local_addr_80, pack_read_req_local_stride_81, pack_read_req_local_size_82, pack_read_req_local_blocksize_83 };
  assign _axi_m_dram_read_req_fifo_wdata = ((_axi_m_dram_read_req_fsm == 0) && _axi_m_dram_read_start && !_axi_m_dram_read_req_fifo_almost_full)? pack_read_req_packed_84 : 'hx;
  assign _axi_m_dram_read_req_fifo_enq = ((_axi_m_dram_read_req_fsm == 0) && _axi_m_dram_read_start && !_axi_m_dram_read_req_fifo_almost_full)? (_axi_m_dram_read_req_fsm == 0) && _axi_m_dram_read_start && !_axi_m_dram_read_req_fifo_almost_full && !_axi_m_dram_read_req_fifo_almost_full : 0;
  localparam _tmp_85 = 1;
  wire [_tmp_85-1:0] _tmp_86;
  assign _tmp_86 = !_axi_m_dram_read_req_fifo_almost_full;
  reg [_tmp_85-1:0] __tmp_86_1;
  wire [32-1:0] mask_addr_shifted_87;
  assign mask_addr_shifted_87 = _axi_m_dram_read_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_88;
  assign mask_addr_masked_88 = mask_addr_shifted_87 << 4;
  wire [32-1:0] mask_addr_shifted_89;
  assign mask_addr_shifted_89 = _axi_m_dram_read_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_90;
  assign mask_addr_masked_90 = mask_addr_shifted_89 << 4;
  wire [32-1:0] mask_addr_shifted_91;
  assign mask_addr_shifted_91 = _axi_m_dram_read_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_92;
  assign mask_addr_masked_92 = mask_addr_shifted_91 << 4;
  wire [32-1:0] mask_addr_shifted_93;
  assign mask_addr_shifted_93 = _axi_m_dram_read_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_94;
  assign mask_addr_masked_94 = mask_addr_shifted_93 << 4;
  wire [32-1:0] mask_addr_shifted_95;
  assign mask_addr_shifted_95 = _axi_m_dram_read_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_96;
  assign mask_addr_masked_96 = mask_addr_shifted_95 << 4;
  wire [32-1:0] mask_addr_shifted_97;
  assign mask_addr_shifted_97 = _axi_m_dram_read_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_98;
  assign mask_addr_masked_98 = mask_addr_shifted_97 << 4;
  reg _axi_m_dram_raddr_cond_0_1;
  reg [32-1:0] _axi_m_dram_read_data_wide_fsm;
  localparam _axi_m_dram_read_data_wide_fsm_init = 0;
  assign _axi_m_dram_read_req_fifo_deq = ((_axi_m_dram_read_data_wide_fsm == 0) && (!_axi_m_dram_read_data_busy && !_axi_m_dram_read_req_fifo_empty && (_axi_m_dram_read_op_sel_fifo == 1)) && !_axi_m_dram_read_req_fifo_empty)? 1 : 0;
  reg [128-1:0] _axi_m_dram_read_wide_wdata_99;
  reg _axi_m_dram_read_wide_wvalid_100;
  reg [1-1:0] _axi_m_dram_read_wide_count_101;
  reg [32-1:0] write_burst_fsm_0;
  localparam write_burst_fsm_0_init = 0;
  reg [9-1:0] write_burst_addr_102;
  reg [9-1:0] write_burst_stride_103;
  reg [33-1:0] write_burst_length_104;
  reg write_burst_done_105;
  assign _axi_m_dram_rready_sb_0 = (_axi_m_dram_read_data_wide_fsm == 2) && (_axi_m_dram_read_op_sel_buf == 1) && (_axi_m_dram_read_wide_count_101 == 0);
  wire [32-1:0] mask_addr_shifted_106;
  assign mask_addr_shifted_106 = dram_addr_69 >> 4;
  wire [32-1:0] mask_addr_masked_107;
  assign mask_addr_masked_107 = mask_addr_shifted_106 << 4;
  reg [32-1:0] _axi_m_dram_write_req_fsm;
  localparam _axi_m_dram_write_req_fsm_init = 0;
  reg [33-1:0] _axi_m_dram_write_cur_global_size;
  reg _axi_m_dram_write_cont;
  wire [8-1:0] pack_write_req_op_sel_108;
  wire [32-1:0] pack_write_req_local_addr_109;
  wire [32-1:0] pack_write_req_local_stride_110;
  wire [33-1:0] pack_write_req_size_111;
  wire [32-1:0] pack_write_req_local_blocksize_112;
  assign pack_write_req_op_sel_108 = _axi_m_dram_write_op_sel;
  assign pack_write_req_local_addr_109 = _axi_m_dram_write_local_addr;
  assign pack_write_req_local_stride_110 = _axi_m_dram_write_local_stride;
  assign pack_write_req_size_111 = _axi_m_dram_write_local_size;
  assign pack_write_req_local_blocksize_112 = _axi_m_dram_write_local_blocksize;
  wire [137-1:0] pack_write_req_packed_113;
  assign pack_write_req_packed_113 = { pack_write_req_op_sel_108, pack_write_req_local_addr_109, pack_write_req_local_stride_110, pack_write_req_size_111, pack_write_req_local_blocksize_112 };
  localparam _tmp_114 = 1;
  wire [_tmp_114-1:0] _tmp_115;
  assign _tmp_115 = !_axi_m_dram_write_req_fifo_almost_full;
  reg [_tmp_114-1:0] __tmp_115_1;
  wire [32-1:0] mask_addr_shifted_116;
  assign mask_addr_shifted_116 = _axi_m_dram_write_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_117;
  assign mask_addr_masked_117 = mask_addr_shifted_116 << 4;
  wire [32-1:0] mask_addr_shifted_118;
  assign mask_addr_shifted_118 = _axi_m_dram_write_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_119;
  assign mask_addr_masked_119 = mask_addr_shifted_118 << 4;
  wire [32-1:0] mask_addr_shifted_120;
  assign mask_addr_shifted_120 = _axi_m_dram_write_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_121;
  assign mask_addr_masked_121 = mask_addr_shifted_120 << 4;
  wire [32-1:0] mask_addr_shifted_122;
  assign mask_addr_shifted_122 = _axi_m_dram_write_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_123;
  assign mask_addr_masked_123 = mask_addr_shifted_122 << 4;
  wire [32-1:0] mask_addr_shifted_124;
  assign mask_addr_shifted_124 = _axi_m_dram_write_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_125;
  assign mask_addr_masked_125 = mask_addr_shifted_124 << 4;
  wire [32-1:0] mask_addr_shifted_126;
  assign mask_addr_shifted_126 = _axi_m_dram_write_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_127;
  assign mask_addr_masked_127 = mask_addr_shifted_126 << 4;
  wire [8-1:0] pack_write_req_op_sel_128;
  wire [32-1:0] pack_write_req_local_addr_129;
  wire [32-1:0] pack_write_req_local_stride_130;
  wire [33-1:0] pack_write_req_size_131;
  wire [32-1:0] pack_write_req_local_blocksize_132;
  assign pack_write_req_op_sel_128 = _axi_m_dram_write_op_sel;
  assign pack_write_req_local_addr_129 = _axi_m_dram_write_local_addr;
  assign pack_write_req_local_stride_130 = _axi_m_dram_write_local_stride;
  assign pack_write_req_size_131 = _axi_m_dram_write_cur_global_size;
  assign pack_write_req_local_blocksize_132 = _axi_m_dram_write_local_blocksize;
  wire [137-1:0] pack_write_req_packed_133;
  assign pack_write_req_packed_133 = { pack_write_req_op_sel_128, pack_write_req_local_addr_129, pack_write_req_local_stride_130, pack_write_req_size_131, pack_write_req_local_blocksize_132 };
  assign _axi_m_dram_write_req_fifo_wdata = ((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (axi_m_dram_awready || !axi_m_dram_awvalid) && (_axi_m_dram_outstanding_wcount < 6))? pack_write_req_packed_133 : 
                                            ((_axi_m_dram_write_req_fsm == 0) && _axi_m_dram_write_start && !_axi_m_dram_write_req_fifo_almost_full)? pack_write_req_packed_113 : 'hx;
  assign _axi_m_dram_write_req_fifo_enq = ((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (axi_m_dram_awready || !axi_m_dram_awvalid) && (_axi_m_dram_outstanding_wcount < 6))? (_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (axi_m_dram_awready || !axi_m_dram_awvalid) && (_axi_m_dram_outstanding_wcount < 6) && !_axi_m_dram_write_req_fifo_almost_full : 
                                          ((_axi_m_dram_write_req_fsm == 0) && _axi_m_dram_write_start && !_axi_m_dram_write_req_fifo_almost_full)? (_axi_m_dram_write_req_fsm == 0) && _axi_m_dram_write_start && !_axi_m_dram_write_req_fifo_almost_full && !_axi_m_dram_write_req_fifo_almost_full : 0;
  localparam _tmp_134 = 1;
  wire [_tmp_134-1:0] _tmp_135;
  assign _tmp_135 = !_axi_m_dram_write_req_fifo_almost_full;
  reg [_tmp_134-1:0] __tmp_135_1;
  reg _axi_m_dram_waddr_cond_0_1;
  reg [32-1:0] _axi_m_dram_write_data_wide_fsm;
  localparam _axi_m_dram_write_data_wide_fsm_init = 0;
  reg [1-1:0] _axi_m_dram_write_wide_count_136;
  reg [32-1:0] read_burst_fsm_1;
  localparam read_burst_fsm_1_init = 0;
  reg [9-1:0] read_burst_addr_137;
  reg [9-1:0] read_burst_stride_138;
  reg [33-1:0] read_burst_length_139;
  reg read_burst_rvalid_140;
  reg read_burst_rlast_141;
  localparam _tmp_142 = 1;
  wire [_tmp_142-1:0] _tmp_143;
  assign _tmp_143 = (read_burst_fsm_1 == 1) && (!read_burst_rvalid_140 || (_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0 || (_axi_m_dram_write_wide_count_136 > 0)) && (_axi_m_dram_write_size_buf > 0));
  reg [_tmp_142-1:0] __tmp_143_1;
  wire [64-1:0] read_burst_rdata_144;
  assign read_burst_rdata_144 = ram_spm_0_rdata;
  assign _axi_m_dram_write_req_fifo_deq = ((_axi_m_dram_write_data_wide_fsm == 2) && (!_axi_m_dram_write_req_fifo_empty && (_axi_m_dram_write_size_buf == 0)) && !_axi_m_dram_write_req_fifo_empty)? 1 : 
                                          ((_axi_m_dram_write_data_wide_fsm == 0) && (!_axi_m_dram_write_data_busy && !_axi_m_dram_write_req_fifo_empty && (_axi_m_dram_write_op_sel_fifo == 1)) && !_axi_m_dram_write_req_fifo_empty)? 1 : 0;
  reg [128-1:0] _axi_m_dram_write_wide_wdata_145;
  reg _axi_m_dram_wdata_cond_0_1;
  wire [8-1:0] pack_write_req_op_sel_146;
  wire [32-1:0] pack_write_req_local_addr_147;
  wire [32-1:0] pack_write_req_local_stride_148;
  wire [33-1:0] pack_write_req_local_size_149;
  assign pack_write_req_op_sel_146 = 1;
  assign pack_write_req_local_addr_147 = spm_addr_70 >>> 3;
  assign pack_write_req_local_stride_148 = 1;
  assign pack_write_req_local_size_149 = 8;
  wire [105-1:0] pack_write_req_packed_150;
  assign pack_write_req_packed_150 = { pack_write_req_op_sel_146, pack_write_req_local_addr_147, pack_write_req_local_stride_148, pack_write_req_local_size_149 };
  assign _axis_out_mac_spm_write_req_fifo_wdata = ((spm_thread == 20) && !_axis_out_mac_spm_write_req_fifo_almost_full)? pack_write_req_packed_150 : 'hx;
  assign _axis_out_mac_spm_write_req_fifo_enq = ((spm_thread == 20) && !_axis_out_mac_spm_write_req_fifo_almost_full)? (spm_thread == 20) && !_axis_out_mac_spm_write_req_fifo_almost_full && !_axis_out_mac_spm_write_req_fifo_almost_full : 0;
  localparam _tmp_151 = 1;
  wire [_tmp_151-1:0] _tmp_152;
  assign _tmp_152 = !_axis_out_mac_spm_write_req_fifo_almost_full;
  reg [_tmp_151-1:0] __tmp_152_1;
  reg [32-1:0] _axis_out_mac_spm_write_data_wide_fsm;
  localparam _axis_out_mac_spm_write_data_wide_fsm_init = 0;
  assign _axis_out_mac_spm_write_req_fifo_deq = ((_axis_out_mac_spm_write_data_wide_fsm == 0) && (!_axis_out_mac_spm_write_data_busy && !_axis_out_mac_spm_write_req_fifo_empty && (_axis_out_mac_spm_write_op_sel_fifo == 1)) && !_axis_out_mac_spm_write_req_fifo_empty)? 1 : 0;
  reg [1-1:0] _axis_out_mac_spm_write_wide_count_153;
  reg [32-1:0] read_burst_fsm_2;
  localparam read_burst_fsm_2_init = 0;
  reg [9-1:0] read_burst_addr_154;
  reg [9-1:0] read_burst_stride_155;
  reg [33-1:0] read_burst_length_156;
  reg read_burst_rvalid_157;
  reg read_burst_rlast_158;
  localparam _tmp_159 = 1;
  wire [_tmp_159-1:0] _tmp_160;
  assign _tmp_160 = (read_burst_fsm_2 == 1) && (!read_burst_rvalid_157 || (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_153 > 0)));
  reg [_tmp_159-1:0] __tmp_160_1;
  wire [64-1:0] read_burst_rdata_161;
  assign read_burst_rdata_161 = ram_spm_0_rdata;
  reg [128-1:0] _axis_out_mac_spm_write_wide_wdata_162;
  reg _axis_out_mac_spm_cond_0_1;
  reg signed [32-1:0] _spm_thread_i_0;
  localparam _tmp_163 = 1;
  wire [_tmp_163-1:0] _tmp_164;
  assign _tmp_164 = spm_thread == 24;
  reg [_tmp_163-1:0] __tmp_164_1;
  reg signed [64-1:0] read_rdata_165;
  wire [8-1:0] pack_read_req_op_sel_166;
  wire [32-1:0] pack_read_req_local_addr_167;
  wire [32-1:0] pack_read_req_local_stride_168;
  wire [33-1:0] pack_read_req_local_size_169;
  assign pack_read_req_op_sel_166 = 1;
  assign pack_read_req_local_addr_167 = spm_addr_70 >>> 3;
  assign pack_read_req_local_stride_168 = 1;
  assign pack_read_req_local_size_169 = 8;
  wire [105-1:0] pack_read_req_packed_170;
  assign pack_read_req_packed_170 = { pack_read_req_op_sel_166, pack_read_req_local_addr_167, pack_read_req_local_stride_168, pack_read_req_local_size_169 };
  assign _axis_in_axim_spm_read_req_fifo_wdata = ((spm_thread == 31) && !_axis_in_axim_spm_read_req_fifo_almost_full)? pack_read_req_packed_170 : 'hx;
  assign _axis_in_axim_spm_read_req_fifo_enq = ((spm_thread == 31) && !_axis_in_axim_spm_read_req_fifo_almost_full)? (spm_thread == 31) && !_axis_in_axim_spm_read_req_fifo_almost_full && !_axis_in_axim_spm_read_req_fifo_almost_full : 0;
  localparam _tmp_171 = 1;
  wire [_tmp_171-1:0] _tmp_172;
  assign _tmp_172 = !_axis_in_axim_spm_read_req_fifo_almost_full;
  reg [_tmp_171-1:0] __tmp_172_1;
  reg [32-1:0] _axis_in_axim_spm_read_data_wide_fsm;
  localparam _axis_in_axim_spm_read_data_wide_fsm_init = 0;
  assign _axis_in_axim_spm_read_req_fifo_deq = ((_axis_in_axim_spm_read_data_wide_fsm == 0) && (!_axis_in_axim_spm_read_data_busy && !_axis_in_axim_spm_read_req_fifo_empty && (_axis_in_axim_spm_read_op_sel_fifo == 1)) && !_axis_in_axim_spm_read_req_fifo_empty)? 1 : 0;
  reg [128-1:0] _axis_in_axim_spm_read_wide_wdata_173;
  reg _axis_in_axim_spm_read_wide_wvalid_174;
  reg [1-1:0] _axis_in_axim_spm_read_wide_count_175;
  reg [32-1:0] write_burst_fsm_3;
  localparam write_burst_fsm_3_init = 0;
  reg [9-1:0] write_burst_addr_176;
  reg [9-1:0] write_burst_stride_177;
  reg [33-1:0] write_burst_length_178;
  reg write_burst_done_179;
  assign axis_in_axim_spm_tready = (_axis_in_axim_spm_read_data_wide_fsm == 2) && (_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_wide_count_175 == 0);
  wire [8-1:0] pack_write_req_op_sel_180;
  wire [32-1:0] pack_write_req_local_addr_181;
  wire [32-1:0] pack_write_req_local_stride_182;
  wire [33-1:0] pack_write_req_local_size_183;
  assign pack_write_req_op_sel_180 = 1;
  assign pack_write_req_local_addr_181 = spm_addr_70 >>> 3;
  assign pack_write_req_local_stride_182 = 1;
  assign pack_write_req_local_size_183 = 8;
  wire [105-1:0] pack_write_req_packed_184;
  assign pack_write_req_packed_184 = { pack_write_req_op_sel_180, pack_write_req_local_addr_181, pack_write_req_local_stride_182, pack_write_req_local_size_183 };
  assign _axis_out_axim_spm_write_req_fifo_wdata = ((spm_thread == 33) && !_axis_out_axim_spm_write_req_fifo_almost_full)? pack_write_req_packed_184 : 'hx;
  assign _axis_out_axim_spm_write_req_fifo_enq = ((spm_thread == 33) && !_axis_out_axim_spm_write_req_fifo_almost_full)? (spm_thread == 33) && !_axis_out_axim_spm_write_req_fifo_almost_full && !_axis_out_axim_spm_write_req_fifo_almost_full : 0;
  localparam _tmp_185 = 1;
  wire [_tmp_185-1:0] _tmp_186;
  assign _tmp_186 = !_axis_out_axim_spm_write_req_fifo_almost_full;
  reg [_tmp_185-1:0] __tmp_186_1;
  reg [32-1:0] _axis_out_axim_spm_write_data_wide_fsm;
  localparam _axis_out_axim_spm_write_data_wide_fsm_init = 0;
  assign _axis_out_axim_spm_write_req_fifo_deq = ((_axis_out_axim_spm_write_data_wide_fsm == 0) && (!_axis_out_axim_spm_write_data_busy && !_axis_out_axim_spm_write_req_fifo_empty && (_axis_out_axim_spm_write_op_sel_fifo == 1)) && !_axis_out_axim_spm_write_req_fifo_empty)? 1 : 0;
  reg [1-1:0] _axis_out_axim_spm_write_wide_count_187;
  reg [32-1:0] read_burst_fsm_4;
  localparam read_burst_fsm_4_init = 0;
  reg [9-1:0] read_burst_addr_188;
  reg [9-1:0] read_burst_stride_189;
  reg [33-1:0] read_burst_length_190;
  reg read_burst_rvalid_191;
  reg read_burst_rlast_192;
  localparam _tmp_193 = 1;
  wire [_tmp_193-1:0] _tmp_194;
  assign _tmp_194 = (read_burst_fsm_4 == 1) && (!read_burst_rvalid_191 || (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_187 > 0)));
  reg [_tmp_193-1:0] __tmp_194_1;
  wire [64-1:0] read_burst_rdata_195;
  assign read_burst_rdata_195 = ram_spm_0_rdata;
  reg [128-1:0] _axis_out_axim_spm_write_wide_wdata_196;
  reg _axis_out_axim_spm_cond_0_1;
  wire [8-1:0] pack_read_req_op_sel_197;
  wire [32-1:0] pack_read_req_local_addr_198;
  wire [32-1:0] pack_read_req_local_stride_199;
  wire [33-1:0] pack_read_req_local_size_200;
  assign pack_read_req_op_sel_197 = 1;
  assign pack_read_req_local_addr_198 = spm_addr_70 >>> 3;
  assign pack_read_req_local_stride_199 = 1;
  assign pack_read_req_local_size_200 = 8;
  wire [105-1:0] pack_read_req_packed_201;
  assign pack_read_req_packed_201 = { pack_read_req_op_sel_197, pack_read_req_local_addr_198, pack_read_req_local_stride_199, pack_read_req_local_size_200 };
  assign _axis_in_xored_spm_read_req_fifo_wdata = ((spm_thread == 37) && !_axis_in_xored_spm_read_req_fifo_almost_full)? pack_read_req_packed_201 : 'hx;
  assign _axis_in_xored_spm_read_req_fifo_enq = ((spm_thread == 37) && !_axis_in_xored_spm_read_req_fifo_almost_full)? (spm_thread == 37) && !_axis_in_xored_spm_read_req_fifo_almost_full && !_axis_in_xored_spm_read_req_fifo_almost_full : 0;
  localparam _tmp_202 = 1;
  wire [_tmp_202-1:0] _tmp_203;
  assign _tmp_203 = !_axis_in_xored_spm_read_req_fifo_almost_full;
  reg [_tmp_202-1:0] __tmp_203_1;
  reg [32-1:0] _axis_in_xored_spm_read_data_wide_fsm;
  localparam _axis_in_xored_spm_read_data_wide_fsm_init = 0;
  assign _axis_in_xored_spm_read_req_fifo_deq = ((_axis_in_xored_spm_read_data_wide_fsm == 0) && (!_axis_in_xored_spm_read_data_busy && !_axis_in_xored_spm_read_req_fifo_empty && (_axis_in_xored_spm_read_op_sel_fifo == 1)) && !_axis_in_xored_spm_read_req_fifo_empty)? 1 : 0;
  reg [128-1:0] _axis_in_xored_spm_read_wide_wdata_204;
  reg _axis_in_xored_spm_read_wide_wvalid_205;
  reg [1-1:0] _axis_in_xored_spm_read_wide_count_206;
  reg [32-1:0] write_burst_fsm_5;
  localparam write_burst_fsm_5_init = 0;
  reg [9-1:0] write_burst_addr_207;
  reg [9-1:0] write_burst_stride_208;
  reg [33-1:0] write_burst_length_209;
  reg write_burst_done_210;
  assign ram_spm_0_wdata = ((write_burst_fsm_5 == 1) && _axis_in_xored_spm_read_wide_wvalid_205)? _axis_in_xored_spm_read_wide_wdata_204[63:0] : 
                           ((write_burst_fsm_3 == 1) && _axis_in_axim_spm_read_wide_wvalid_174)? _axis_in_axim_spm_read_wide_wdata_173[63:0] : 
                           ((write_burst_fsm_0 == 1) && _axi_m_dram_read_wide_wvalid_100)? _axi_m_dram_read_wide_wdata_99[63:0] : 'hx;
  assign ram_spm_0_wenable = ((write_burst_fsm_5 == 1) && _axis_in_xored_spm_read_wide_wvalid_205)? 1'd1 : 
                             ((write_burst_fsm_3 == 1) && _axis_in_axim_spm_read_wide_wvalid_174)? 1'd1 : 
                             ((write_burst_fsm_0 == 1) && _axi_m_dram_read_wide_wvalid_100)? 1'd1 : 0;
  assign axis_in_xored_spm_tready = (_axis_in_xored_spm_read_data_wide_fsm == 2) && (_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_wide_count_206 == 0);
  wire [8-1:0] pack_write_req_op_sel_211;
  wire [32-1:0] pack_write_req_local_addr_212;
  wire [32-1:0] pack_write_req_local_stride_213;
  wire [33-1:0] pack_write_req_local_size_214;
  assign pack_write_req_op_sel_211 = 1;
  assign pack_write_req_local_addr_212 = spm_addr_70 >>> 3;
  assign pack_write_req_local_stride_213 = 1;
  assign pack_write_req_local_size_214 = 8;
  wire [105-1:0] pack_write_req_packed_215;
  assign pack_write_req_packed_215 = { pack_write_req_op_sel_211, pack_write_req_local_addr_212, pack_write_req_local_stride_213, pack_write_req_local_size_214 };
  assign _axis_out_xored_spm_write_req_fifo_wdata = ((spm_thread == 40) && !_axis_out_xored_spm_write_req_fifo_almost_full)? pack_write_req_packed_215 : 'hx;
  assign _axis_out_xored_spm_write_req_fifo_enq = ((spm_thread == 40) && !_axis_out_xored_spm_write_req_fifo_almost_full)? (spm_thread == 40) && !_axis_out_xored_spm_write_req_fifo_almost_full && !_axis_out_xored_spm_write_req_fifo_almost_full : 0;
  localparam _tmp_216 = 1;
  wire [_tmp_216-1:0] _tmp_217;
  assign _tmp_217 = !_axis_out_xored_spm_write_req_fifo_almost_full;
  reg [_tmp_216-1:0] __tmp_217_1;
  reg [32-1:0] _axis_out_xored_spm_write_data_wide_fsm;
  localparam _axis_out_xored_spm_write_data_wide_fsm_init = 0;
  assign _axis_out_xored_spm_write_req_fifo_deq = ((_axis_out_xored_spm_write_data_wide_fsm == 0) && (!_axis_out_xored_spm_write_data_busy && !_axis_out_xored_spm_write_req_fifo_empty && (_axis_out_xored_spm_write_op_sel_fifo == 1)) && !_axis_out_xored_spm_write_req_fifo_empty)? 1 : 0;
  reg [1-1:0] _axis_out_xored_spm_write_wide_count_218;
  reg [32-1:0] read_burst_fsm_6;
  localparam read_burst_fsm_6_init = 0;
  reg [9-1:0] read_burst_addr_219;
  reg [9-1:0] read_burst_stride_220;
  reg [33-1:0] read_burst_length_221;
  reg read_burst_rvalid_222;
  reg read_burst_rlast_223;
  assign ram_spm_0_addr = ((read_burst_fsm_6 == 1) && (!read_burst_rvalid_222 || (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_218 > 0))))? read_burst_addr_219 : 
                          ((write_burst_fsm_5 == 1) && _axis_in_xored_spm_read_wide_wvalid_205)? write_burst_addr_207 : 
                          ((read_burst_fsm_4 == 1) && (!read_burst_rvalid_191 || (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_187 > 0))))? read_burst_addr_188 : 
                          ((write_burst_fsm_3 == 1) && _axis_in_axim_spm_read_wide_wvalid_174)? write_burst_addr_176 : 
                          (spm_thread == 24)? (spm_addr_70 >>> 3) + _spm_thread_i_0 : 
                          ((read_burst_fsm_2 == 1) && (!read_burst_rvalid_157 || (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_153 > 0))))? read_burst_addr_154 : 
                          ((read_burst_fsm_1 == 1) && (!read_burst_rvalid_140 || (_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0 || (_axi_m_dram_write_wide_count_136 > 0)) && (_axi_m_dram_write_size_buf > 0)))? read_burst_addr_137 : 
                          ((write_burst_fsm_0 == 1) && _axi_m_dram_read_wide_wvalid_100)? write_burst_addr_102 : 'hx;
  assign ram_spm_0_enable = ((read_burst_fsm_6 == 1) && (!read_burst_rvalid_222 || (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_218 > 0))))? 1'd1 : 
                            ((write_burst_fsm_5 == 1) && _axis_in_xored_spm_read_wide_wvalid_205)? 1'd1 : 
                            ((read_burst_fsm_4 == 1) && (!read_burst_rvalid_191 || (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_187 > 0))))? 1'd1 : 
                            ((write_burst_fsm_3 == 1) && _axis_in_axim_spm_read_wide_wvalid_174)? 1'd1 : 
                            (spm_thread == 24)? 1'd1 : 
                            ((read_burst_fsm_2 == 1) && (!read_burst_rvalid_157 || (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_153 > 0))))? 1'd1 : 
                            ((read_burst_fsm_1 == 1) && (!read_burst_rvalid_140 || (_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0 || (_axi_m_dram_write_wide_count_136 > 0)) && (_axi_m_dram_write_size_buf > 0)))? 1'd1 : 
                            ((write_burst_fsm_0 == 1) && _axi_m_dram_read_wide_wvalid_100)? 1'd1 : 0;
  localparam _tmp_224 = 1;
  wire [_tmp_224-1:0] _tmp_225;
  assign _tmp_225 = (read_burst_fsm_6 == 1) && (!read_burst_rvalid_222 || (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_218 > 0)));
  reg [_tmp_224-1:0] __tmp_225_1;
  wire [64-1:0] read_burst_rdata_226;
  assign read_burst_rdata_226 = ram_spm_0_rdata;
  reg [128-1:0] _axis_out_xored_spm_write_wide_wdata_227;
  reg _axis_out_xored_spm_cond_0_1;

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
      if((_axi_s_ctrl_spm_register_4 == 1) && (spm_thread == 2) && 0) begin
        _axi_s_ctrl_spm_register_0 <= 0;
      end 
      if((_axi_s_ctrl_spm_register_4 == 1) && (spm_thread == 2) && 0) begin
        _axi_s_ctrl_spm_register_1 <= 0;
      end 
      if((_axi_s_ctrl_spm_register_4 == 1) && (spm_thread == 2) && 0) begin
        _axi_s_ctrl_spm_register_2 <= 0;
      end 
      if((_axi_s_ctrl_spm_register_4 == 1) && (spm_thread == 2) && 0) begin
        _axi_s_ctrl_spm_register_3 <= 0;
      end 
      if((_axi_s_ctrl_spm_register_4 == 1) && (spm_thread == 2) && 1) begin
        _axi_s_ctrl_spm_register_4 <= 0;
      end 
      if((_axi_s_ctrl_spm_register_4 == 1) && (spm_thread == 2) && 0) begin
        _axi_s_ctrl_spm_register_5 <= 0;
      end 
      if((_axi_s_ctrl_spm_register_4 == 1) && (spm_thread == 2) && 0) begin
        _axi_s_ctrl_spm_register_6 <= 0;
      end 
      if((spm_thread == 8) && 0) begin
        _axi_s_ctrl_spm_register_0 <= 1;
        _axi_s_ctrl_spm_flag_0 <= 0;
      end 
      if((spm_thread == 8) && 0) begin
        _axi_s_ctrl_spm_register_1 <= 1;
        _axi_s_ctrl_spm_flag_1 <= 0;
      end 
      if((spm_thread == 8) && 0) begin
        _axi_s_ctrl_spm_register_2 <= 1;
        _axi_s_ctrl_spm_flag_2 <= 0;
      end 
      if((spm_thread == 8) && 0) begin
        _axi_s_ctrl_spm_register_3 <= 1;
        _axi_s_ctrl_spm_flag_3 <= 0;
      end 
      if((spm_thread == 8) && 0) begin
        _axi_s_ctrl_spm_register_4 <= 1;
        _axi_s_ctrl_spm_flag_4 <= 0;
      end 
      if((spm_thread == 8) && 1) begin
        _axi_s_ctrl_spm_register_5 <= 1;
        _axi_s_ctrl_spm_flag_5 <= 0;
      end 
      if((spm_thread == 8) && 0) begin
        _axi_s_ctrl_spm_register_6 <= 1;
        _axi_s_ctrl_spm_flag_6 <= 0;
      end 
      if((spm_thread == 42) && 0) begin
        _axi_s_ctrl_spm_register_0 <= 0;
        _axi_s_ctrl_spm_flag_0 <= 0;
      end 
      if((spm_thread == 42) && 0) begin
        _axi_s_ctrl_spm_register_1 <= 0;
        _axi_s_ctrl_spm_flag_1 <= 0;
      end 
      if((spm_thread == 42) && 0) begin
        _axi_s_ctrl_spm_register_2 <= 0;
        _axi_s_ctrl_spm_flag_2 <= 0;
      end 
      if((spm_thread == 42) && 0) begin
        _axi_s_ctrl_spm_register_3 <= 0;
        _axi_s_ctrl_spm_flag_3 <= 0;
      end 
      if((spm_thread == 42) && 1) begin
        _axi_s_ctrl_spm_register_4 <= 0;
        _axi_s_ctrl_spm_flag_4 <= 0;
      end 
      if((spm_thread == 42) && 0) begin
        _axi_s_ctrl_spm_register_5 <= 0;
        _axi_s_ctrl_spm_flag_5 <= 0;
      end 
      if((spm_thread == 42) && 0) begin
        _axi_s_ctrl_spm_register_6 <= 0;
        _axi_s_ctrl_spm_flag_6 <= 0;
      end 
      if((spm_thread == 43) && 0) begin
        _axi_s_ctrl_spm_register_0 <= 0;
        _axi_s_ctrl_spm_flag_0 <= 0;
      end 
      if((spm_thread == 43) && 0) begin
        _axi_s_ctrl_spm_register_1 <= 0;
        _axi_s_ctrl_spm_flag_1 <= 0;
      end 
      if((spm_thread == 43) && 0) begin
        _axi_s_ctrl_spm_register_2 <= 0;
        _axi_s_ctrl_spm_flag_2 <= 0;
      end 
      if((spm_thread == 43) && 0) begin
        _axi_s_ctrl_spm_register_3 <= 0;
        _axi_s_ctrl_spm_flag_3 <= 0;
      end 
      if((spm_thread == 43) && 0) begin
        _axi_s_ctrl_spm_register_4 <= 0;
        _axi_s_ctrl_spm_flag_4 <= 0;
      end 
      if((spm_thread == 43) && 1) begin
        _axi_s_ctrl_spm_register_5 <= 0;
        _axi_s_ctrl_spm_flag_5 <= 0;
      end 
      if((spm_thread == 43) && 0) begin
        _axi_s_ctrl_spm_register_6 <= 0;
        _axi_s_ctrl_spm_flag_6 <= 0;
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
      axi_m_dram_awaddr <= 0;
      axi_m_dram_awlen <= 0;
      axi_m_dram_awvalid <= 0;
      _axi_m_dram_waddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_dram_waddr_cond_0_1) begin
        axi_m_dram_awvalid <= 0;
      end 
      if((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (_axi_m_dram_outstanding_wcount < 6) && ((_axi_m_dram_outstanding_wcount < 6) && (axi_m_dram_awready || !axi_m_dram_awvalid))) begin
        axi_m_dram_awaddr <= _axi_m_dram_write_global_addr;
        axi_m_dram_awlen <= _axi_m_dram_write_cur_global_size - 1;
        axi_m_dram_awvalid <= 1;
      end 
      if((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (_axi_m_dram_outstanding_wcount < 6) && ((_axi_m_dram_outstanding_wcount < 6) && (axi_m_dram_awready || !axi_m_dram_awvalid)) && (_axi_m_dram_write_cur_global_size == 0)) begin
        axi_m_dram_awvalid <= 0;
      end 
      _axi_m_dram_waddr_cond_0_1 <= 1;
      if(axi_m_dram_awvalid && !axi_m_dram_awready) begin
        axi_m_dram_awvalid <= axi_m_dram_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_dram_wdata_sb_0 <= 0;
      _axi_m_dram_wvalid_sb_0 <= 0;
      _axi_m_dram_wlast_sb_0 <= 0;
      _axi_m_dram_wstrb_sb_0 <= 0;
      _axi_m_dram_wdata_cond_0_1 <= 0;
    end else begin
      if(_axi_m_dram_wdata_cond_0_1) begin
        _axi_m_dram_wvalid_sb_0 <= 0;
        _axi_m_dram_wlast_sb_0 <= 0;
      end 
      if((_axi_m_dram_write_data_wide_fsm == 2) && (_axi_m_dram_write_op_sel_buf == 1) && (_axi_m_dram_write_wide_count_136 == 1) && read_burst_rvalid_140 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0 || (_axi_m_dram_write_wide_count_136 > 0)) && (_axi_m_dram_write_size_buf > 0)) && (_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0)) begin
        _axi_m_dram_wdata_sb_0 <= { read_burst_rdata_144, _axi_m_dram_write_wide_wdata_145[127:64] };
        _axi_m_dram_wvalid_sb_0 <= 1;
        _axi_m_dram_wlast_sb_0 <= read_burst_rlast_141 || (_axi_m_dram_write_size_buf == 1);
        _axi_m_dram_wstrb_sb_0 <= { 16{ 1'd1 } };
      end 
      _axi_m_dram_wdata_cond_0_1 <= 1;
      if(_axi_m_dram_wvalid_sb_0 && !_axi_m_dram_wready_sb_0) begin
        _axi_m_dram_wvalid_sb_0 <= _axi_m_dram_wvalid_sb_0;
        _axi_m_dram_wlast_sb_0 <= _axi_m_dram_wlast_sb_0;
      end 
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
      axi_m_dram_araddr <= 0;
      axi_m_dram_arlen <= 0;
      axi_m_dram_arvalid <= 0;
      _axi_m_dram_raddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_dram_raddr_cond_0_1) begin
        axi_m_dram_arvalid <= 0;
      end 
      if((_axi_m_dram_read_req_fsm == 1) && (axi_m_dram_arready || !axi_m_dram_arvalid)) begin
        axi_m_dram_araddr <= _axi_m_dram_read_global_addr;
        axi_m_dram_arlen <= _axi_m_dram_read_cur_global_size - 1;
        axi_m_dram_arvalid <= 1;
      end 
      _axi_m_dram_raddr_cond_0_1 <= 1;
      if(axi_m_dram_arvalid && !axi_m_dram_arready) begin
        axi_m_dram_arvalid <= axi_m_dram_arvalid;
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
      _axi_m_dram_read_op_sel <= 0;
      _axi_m_dram_read_global_addr <= 0;
      _axi_m_dram_read_global_size <= 0;
      _axi_m_dram_read_local_addr <= 0;
      _axi_m_dram_read_local_stride <= 0;
      _axi_m_dram_read_local_size <= 0;
      _axi_m_dram_read_local_blocksize <= 0;
      _axi_m_dram_read_req_busy <= 0;
      _axi_m_dram_read_cur_global_size <= 0;
      _axi_m_dram_read_data_busy <= 0;
      _axi_m_dram_read_op_sel_buf <= 0;
      _axi_m_dram_read_local_addr_buf <= 0;
      _axi_m_dram_read_local_stride_buf <= 0;
      _axi_m_dram_read_local_size_buf <= 0;
      _axi_m_dram_read_local_blocksize_buf <= 0;
      _axi_m_dram_write_op_sel <= 0;
      _axi_m_dram_write_global_addr <= 0;
      _axi_m_dram_write_global_size <= 0;
      _axi_m_dram_write_local_addr <= 0;
      _axi_m_dram_write_local_stride <= 0;
      _axi_m_dram_write_local_size <= 0;
      _axi_m_dram_write_local_blocksize <= 0;
      _axi_m_dram_write_req_busy <= 0;
      _axi_m_dram_write_cur_global_size <= 0;
      _axi_m_dram_write_data_busy <= 0;
      _axi_m_dram_write_op_sel_buf <= 0;
      _axi_m_dram_write_local_addr_buf <= 0;
      _axi_m_dram_write_local_stride_buf <= 0;
      _axi_m_dram_write_size_buf <= 0;
      _axi_m_dram_write_local_blocksize_buf <= 0;
    end else begin
      if(axi_m_dram_awvalid && axi_m_dram_awready && !(axi_m_dram_bvalid && axi_m_dram_bready) && (_axi_m_dram_outstanding_wcount < 7)) begin
        _axi_m_dram_outstanding_wcount <= _axi_m_dram_outstanding_wcount + 1;
      end 
      if(!(axi_m_dram_awvalid && axi_m_dram_awready) && (axi_m_dram_bvalid && axi_m_dram_bready) && (_axi_m_dram_outstanding_wcount > 0)) begin
        _axi_m_dram_outstanding_wcount <= _axi_m_dram_outstanding_wcount - 1;
      end 
      _axi_m_dram_read_start <= 0;
      _axi_m_dram_write_start <= 0;
      if((spm_thread == 12) && _axi_m_dram_read_req_idle) begin
        _axi_m_dram_read_start <= 1;
        _axi_m_dram_read_op_sel <= 1;
        _axi_m_dram_read_global_addr <= mask_addr_masked_78;
        _axi_m_dram_read_global_size <= 4 + (((8 & 1) > 0)? 1 : 0);
        _axi_m_dram_read_local_addr <= spm_addr_70 >>> 3;
        _axi_m_dram_read_local_stride <= 1;
        _axi_m_dram_read_local_size <= 8;
        _axi_m_dram_read_local_blocksize <= 1;
      end 
      if((_axi_m_dram_read_req_fsm == 0) && _axi_m_dram_read_start) begin
        _axi_m_dram_read_req_busy <= 1;
      end 
      if(_axi_m_dram_read_start && _axi_m_dram_read_req_fifo_almost_full) begin
        _axi_m_dram_read_start <= 1;
      end 
      if((_axi_m_dram_read_req_fsm == 0) && (_axi_m_dram_read_start || _axi_m_dram_read_cont) && !_axi_m_dram_read_req_fifo_almost_full && (_axi_m_dram_read_global_size <= 256) && ((mask_addr_masked_88 & 4095) + (_axi_m_dram_read_global_size << 4) >= 4096)) begin
        _axi_m_dram_read_cur_global_size <= 4096 - (mask_addr_masked_90 & 4095) >> 4;
        _axi_m_dram_read_global_size <= _axi_m_dram_read_global_size - (4096 - (mask_addr_masked_92 & 4095) >> 4);
      end else if((_axi_m_dram_read_req_fsm == 0) && (_axi_m_dram_read_start || _axi_m_dram_read_cont) && !_axi_m_dram_read_req_fifo_almost_full && (_axi_m_dram_read_global_size <= 256)) begin
        _axi_m_dram_read_cur_global_size <= _axi_m_dram_read_global_size;
        _axi_m_dram_read_global_size <= 0;
      end else if((_axi_m_dram_read_req_fsm == 0) && (_axi_m_dram_read_start || _axi_m_dram_read_cont) && !_axi_m_dram_read_req_fifo_almost_full && ((mask_addr_masked_94 & 4095) + 4096 >= 4096)) begin
        _axi_m_dram_read_cur_global_size <= 4096 - (mask_addr_masked_96 & 4095) >> 4;
        _axi_m_dram_read_global_size <= _axi_m_dram_read_global_size - (4096 - (mask_addr_masked_98 & 4095) >> 4);
      end else if((_axi_m_dram_read_req_fsm == 0) && (_axi_m_dram_read_start || _axi_m_dram_read_cont) && !_axi_m_dram_read_req_fifo_almost_full) begin
        _axi_m_dram_read_cur_global_size <= 256;
        _axi_m_dram_read_global_size <= _axi_m_dram_read_global_size - 256;
      end 
      if((_axi_m_dram_read_req_fsm == 1) && (axi_m_dram_arready || !axi_m_dram_arvalid)) begin
        _axi_m_dram_read_global_addr <= _axi_m_dram_read_global_addr + (_axi_m_dram_read_cur_global_size << 4);
      end 
      if((_axi_m_dram_read_req_fsm == 1) && (axi_m_dram_arready || !axi_m_dram_arvalid) && (_axi_m_dram_read_global_size == 0)) begin
        _axi_m_dram_read_req_busy <= 0;
      end 
      if((_axi_m_dram_read_data_wide_fsm == 0) && (!_axi_m_dram_read_data_busy && !_axi_m_dram_read_req_fifo_empty && (_axi_m_dram_read_op_sel_fifo == 1))) begin
        _axi_m_dram_read_data_busy <= 1;
        _axi_m_dram_read_op_sel_buf <= _axi_m_dram_read_op_sel_fifo;
        _axi_m_dram_read_local_addr_buf <= _axi_m_dram_read_local_addr_fifo;
        _axi_m_dram_read_local_stride_buf <= _axi_m_dram_read_local_stride_fifo;
        _axi_m_dram_read_local_size_buf <= _axi_m_dram_read_local_size_fifo;
        _axi_m_dram_read_local_blocksize_buf <= _axi_m_dram_read_local_blocksize_fifo;
      end 
      if((_axi_m_dram_read_data_wide_fsm == 2) && (_axi_m_dram_read_op_sel_buf == 1) && _axi_m_dram_rvalid_sb_0 && (_axi_m_dram_read_wide_count_101 == 0)) begin
        _axi_m_dram_read_local_size_buf <= _axi_m_dram_read_local_size_buf - 1;
      end 
      if((_axi_m_dram_read_data_wide_fsm == 2) && (_axi_m_dram_read_op_sel_buf == 1) && (_axi_m_dram_read_wide_count_101 > 0)) begin
        _axi_m_dram_read_local_size_buf <= _axi_m_dram_read_local_size_buf - 1;
      end 
      if((_axi_m_dram_read_data_wide_fsm == 2) && (_axi_m_dram_read_local_size_buf <= 1) && (_axi_m_dram_read_op_sel_buf == 1) && (_axi_m_dram_read_wide_count_101 > 0)) begin
        _axi_m_dram_read_data_busy <= 0;
      end 
      if((_axi_m_dram_read_data_wide_fsm == 2) && (_axi_m_dram_read_local_size_buf <= 1) && (_axi_m_dram_read_op_sel_buf == 1) && _axi_m_dram_rvalid_sb_0 && (_axi_m_dram_read_wide_count_101 == 0)) begin
        _axi_m_dram_read_data_busy <= 0;
      end 
      if((spm_thread == 15) && _axi_m_dram_write_req_idle) begin
        _axi_m_dram_write_start <= 1;
        _axi_m_dram_write_op_sel <= 1;
        _axi_m_dram_write_global_addr <= mask_addr_masked_107;
        _axi_m_dram_write_global_size <= 4 + (((8 & 1) > 0)? 1 : 0);
        _axi_m_dram_write_local_addr <= spm_addr_70 >>> 3;
        _axi_m_dram_write_local_stride <= 1;
        _axi_m_dram_write_local_size <= 8;
        _axi_m_dram_write_local_blocksize <= 1;
      end 
      if((_axi_m_dram_write_req_fsm == 0) && _axi_m_dram_write_start) begin
        _axi_m_dram_write_req_busy <= 1;
      end 
      if(_axi_m_dram_write_start && _axi_m_dram_write_req_fifo_almost_full) begin
        _axi_m_dram_write_start <= 1;
      end 
      if((_axi_m_dram_write_req_fsm == 0) && (_axi_m_dram_write_start || _axi_m_dram_write_cont) && !_axi_m_dram_write_req_fifo_almost_full && (_axi_m_dram_write_global_size <= 256) && ((mask_addr_masked_117 & 4095) + (_axi_m_dram_write_global_size << 4) >= 4096)) begin
        _axi_m_dram_write_cur_global_size <= 4096 - (mask_addr_masked_119 & 4095) >> 4;
        _axi_m_dram_write_global_size <= _axi_m_dram_write_global_size - (4096 - (mask_addr_masked_121 & 4095) >> 4);
      end else if((_axi_m_dram_write_req_fsm == 0) && (_axi_m_dram_write_start || _axi_m_dram_write_cont) && !_axi_m_dram_write_req_fifo_almost_full && (_axi_m_dram_write_global_size <= 256)) begin
        _axi_m_dram_write_cur_global_size <= _axi_m_dram_write_global_size;
        _axi_m_dram_write_global_size <= 0;
      end else if((_axi_m_dram_write_req_fsm == 0) && (_axi_m_dram_write_start || _axi_m_dram_write_cont) && !_axi_m_dram_write_req_fifo_almost_full && ((mask_addr_masked_123 & 4095) + 4096 >= 4096)) begin
        _axi_m_dram_write_cur_global_size <= 4096 - (mask_addr_masked_125 & 4095) >> 4;
        _axi_m_dram_write_global_size <= _axi_m_dram_write_global_size - (4096 - (mask_addr_masked_127 & 4095) >> 4);
      end else if((_axi_m_dram_write_req_fsm == 0) && (_axi_m_dram_write_start || _axi_m_dram_write_cont) && !_axi_m_dram_write_req_fifo_almost_full) begin
        _axi_m_dram_write_cur_global_size <= 256;
        _axi_m_dram_write_global_size <= _axi_m_dram_write_global_size - 256;
      end 
      if((_axi_m_dram_write_req_fsm == 1) && ((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (axi_m_dram_awready || !axi_m_dram_awvalid) && (_axi_m_dram_outstanding_wcount < 6))) begin
        _axi_m_dram_write_global_addr <= _axi_m_dram_write_global_addr + (_axi_m_dram_write_cur_global_size << 4);
      end 
      if((_axi_m_dram_write_req_fsm == 1) && ((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (axi_m_dram_awready || !axi_m_dram_awvalid) && (_axi_m_dram_outstanding_wcount < 6)) && (_axi_m_dram_write_global_size == 0)) begin
        _axi_m_dram_write_req_busy <= 0;
      end 
      if((_axi_m_dram_write_data_wide_fsm == 0) && (!_axi_m_dram_write_data_busy && !_axi_m_dram_write_req_fifo_empty && (_axi_m_dram_write_op_sel_fifo == 1))) begin
        _axi_m_dram_write_data_busy <= 1;
        _axi_m_dram_write_op_sel_buf <= _axi_m_dram_write_op_sel_fifo;
        _axi_m_dram_write_local_addr_buf <= _axi_m_dram_write_local_addr_fifo;
        _axi_m_dram_write_local_stride_buf <= _axi_m_dram_write_local_stride_fifo;
        _axi_m_dram_write_size_buf <= (_axi_m_dram_write_size_fifo >> 1) + (((_axi_m_dram_write_size_fifo & 1) > 0)? 1 : 0) << 1;
        _axi_m_dram_write_local_blocksize_buf <= _axi_m_dram_write_local_blocksize_fifo;
      end 
      if(_axi_m_dram_write_data_wide_fsm == 1) begin
        _axi_m_dram_write_size_buf <= 0;
      end 
      if((_axi_m_dram_write_data_wide_fsm == 2) && (!_axi_m_dram_write_req_fifo_empty && (_axi_m_dram_write_size_buf == 0))) begin
        _axi_m_dram_write_size_buf <= _axi_m_dram_write_size_fifo << 1;
      end 
      if((_axi_m_dram_write_data_wide_fsm == 2) && read_burst_rvalid_140 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0 || (_axi_m_dram_write_wide_count_136 > 0)) && (_axi_m_dram_write_size_buf > 0))) begin
        _axi_m_dram_write_size_buf <= _axi_m_dram_write_size_buf - 1;
      end 
      if((_axi_m_dram_write_data_wide_fsm == 2) && (_axi_m_dram_write_wide_count_136 == 1) && read_burst_rvalid_140 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0 || (_axi_m_dram_write_wide_count_136 > 0)) && (_axi_m_dram_write_size_buf > 0)) && read_burst_rlast_141) begin
        _axi_m_dram_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axi_m_dram_read_req_fifo <= 0;
      __tmp_86_1 <= 0;
    end else begin
      if(_axi_m_dram_read_req_fifo_enq && !_axi_m_dram_read_req_fifo_full && (_axi_m_dram_read_req_fifo_deq && !_axi_m_dram_read_req_fifo_empty)) begin
        count__axi_m_dram_read_req_fifo <= count__axi_m_dram_read_req_fifo;
      end else if(_axi_m_dram_read_req_fifo_enq && !_axi_m_dram_read_req_fifo_full) begin
        count__axi_m_dram_read_req_fifo <= count__axi_m_dram_read_req_fifo + 1;
      end else if(_axi_m_dram_read_req_fifo_deq && !_axi_m_dram_read_req_fifo_empty) begin
        count__axi_m_dram_read_req_fifo <= count__axi_m_dram_read_req_fifo - 1;
      end 
      __tmp_86_1 <= _tmp_86;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axi_m_dram_write_req_fifo <= 0;
      __tmp_115_1 <= 0;
      __tmp_135_1 <= 0;
    end else begin
      if(_axi_m_dram_write_req_fifo_enq && !_axi_m_dram_write_req_fifo_full && (_axi_m_dram_write_req_fifo_deq && !_axi_m_dram_write_req_fifo_empty)) begin
        count__axi_m_dram_write_req_fifo <= count__axi_m_dram_write_req_fifo;
      end else if(_axi_m_dram_write_req_fifo_enq && !_axi_m_dram_write_req_fifo_full) begin
        count__axi_m_dram_write_req_fifo <= count__axi_m_dram_write_req_fifo + 1;
      end else if(_axi_m_dram_write_req_fifo_deq && !_axi_m_dram_write_req_fifo_empty) begin
        count__axi_m_dram_write_req_fifo <= count__axi_m_dram_write_req_fifo - 1;
      end 
      __tmp_115_1 <= _tmp_115;
      __tmp_135_1 <= _tmp_135;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axis_out_mac_spm_tdata <= 0;
      axis_out_mac_spm_tvalid <= 0;
      axis_out_mac_spm_tlast <= 0;
      _axis_out_mac_spm_cond_0_1 <= 0;
    end else begin
      if(_axis_out_mac_spm_cond_0_1) begin
        axis_out_mac_spm_tvalid <= 0;
        axis_out_mac_spm_tlast <= 0;
      end 
      if((_axis_out_mac_spm_write_data_wide_fsm == 2) && (_axis_out_mac_spm_write_op_sel_buf == 1) && (_axis_out_mac_spm_write_wide_count_153 == 1) && read_burst_rvalid_157 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_153 > 0)) && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid)) begin
        axis_out_mac_spm_tdata <= { read_burst_rdata_161, _axis_out_mac_spm_write_wide_wdata_162[127:64] };
        axis_out_mac_spm_tvalid <= 1;
        axis_out_mac_spm_tlast <= read_burst_rlast_158 || (_axis_out_mac_spm_write_size_buf <= 1);
      end 
      _axis_out_mac_spm_cond_0_1 <= 1;
      if(axis_out_mac_spm_tvalid && !axis_out_mac_spm_tready) begin
        axis_out_mac_spm_tvalid <= axis_out_mac_spm_tvalid;
        axis_out_mac_spm_tlast <= axis_out_mac_spm_tlast;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axis_out_mac_spm_write_data_busy <= 0;
      _axis_out_mac_spm_write_op_sel_buf <= 0;
      _axis_out_mac_spm_write_local_addr_buf <= 0;
      _axis_out_mac_spm_write_local_stride_buf <= 0;
      _axis_out_mac_spm_write_size_buf <= 0;
    end else begin
      if((_axis_out_mac_spm_write_data_wide_fsm == 0) && (!_axis_out_mac_spm_write_data_busy && !_axis_out_mac_spm_write_req_fifo_empty && (_axis_out_mac_spm_write_op_sel_fifo == 1))) begin
        _axis_out_mac_spm_write_data_busy <= 1;
        _axis_out_mac_spm_write_op_sel_buf <= _axis_out_mac_spm_write_op_sel_fifo;
        _axis_out_mac_spm_write_local_addr_buf <= _axis_out_mac_spm_write_local_addr_fifo;
        _axis_out_mac_spm_write_local_stride_buf <= _axis_out_mac_spm_write_local_stride_fifo;
        _axis_out_mac_spm_write_size_buf <= (_axis_out_mac_spm_write_size_fifo >> 1) + (((_axis_out_mac_spm_write_size_fifo & 1) > 0)? 1 : 0) << 1;
      end 
      if((_axis_out_mac_spm_write_data_wide_fsm == 2) && read_burst_rvalid_157 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_153 > 0))) begin
        _axis_out_mac_spm_write_size_buf <= _axis_out_mac_spm_write_size_buf - 1;
      end 
      if((_axis_out_mac_spm_write_data_wide_fsm == 2) && (_axis_out_mac_spm_write_wide_count_153 == 1) && read_burst_rvalid_157 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_153 > 0)) && read_burst_rlast_158) begin
        _axis_out_mac_spm_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_out_mac_spm_write_req_fifo <= 0;
      __tmp_152_1 <= 0;
    end else begin
      if(_axis_out_mac_spm_write_req_fifo_enq && !_axis_out_mac_spm_write_req_fifo_full && (_axis_out_mac_spm_write_req_fifo_deq && !_axis_out_mac_spm_write_req_fifo_empty)) begin
        count__axis_out_mac_spm_write_req_fifo <= count__axis_out_mac_spm_write_req_fifo;
      end else if(_axis_out_mac_spm_write_req_fifo_enq && !_axis_out_mac_spm_write_req_fifo_full) begin
        count__axis_out_mac_spm_write_req_fifo <= count__axis_out_mac_spm_write_req_fifo + 1;
      end else if(_axis_out_mac_spm_write_req_fifo_deq && !_axis_out_mac_spm_write_req_fifo_empty) begin
        count__axis_out_mac_spm_write_req_fifo <= count__axis_out_mac_spm_write_req_fifo - 1;
      end 
      __tmp_152_1 <= _tmp_152;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axis_out_axim_spm_tdata <= 0;
      axis_out_axim_spm_tvalid <= 0;
      axis_out_axim_spm_tlast <= 0;
      _axis_out_axim_spm_cond_0_1 <= 0;
    end else begin
      if(_axis_out_axim_spm_cond_0_1) begin
        axis_out_axim_spm_tvalid <= 0;
        axis_out_axim_spm_tlast <= 0;
      end 
      if((_axis_out_axim_spm_write_data_wide_fsm == 2) && (_axis_out_axim_spm_write_op_sel_buf == 1) && (_axis_out_axim_spm_write_wide_count_187 == 1) && read_burst_rvalid_191 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_187 > 0)) && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid)) begin
        axis_out_axim_spm_tdata <= { read_burst_rdata_195, _axis_out_axim_spm_write_wide_wdata_196[127:64] };
        axis_out_axim_spm_tvalid <= 1;
        axis_out_axim_spm_tlast <= read_burst_rlast_192 || (_axis_out_axim_spm_write_size_buf <= 1);
      end 
      _axis_out_axim_spm_cond_0_1 <= 1;
      if(axis_out_axim_spm_tvalid && !axis_out_axim_spm_tready) begin
        axis_out_axim_spm_tvalid <= axis_out_axim_spm_tvalid;
        axis_out_axim_spm_tlast <= axis_out_axim_spm_tlast;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axis_out_axim_spm_write_data_busy <= 0;
      _axis_out_axim_spm_write_op_sel_buf <= 0;
      _axis_out_axim_spm_write_local_addr_buf <= 0;
      _axis_out_axim_spm_write_local_stride_buf <= 0;
      _axis_out_axim_spm_write_size_buf <= 0;
    end else begin
      if((_axis_out_axim_spm_write_data_wide_fsm == 0) && (!_axis_out_axim_spm_write_data_busy && !_axis_out_axim_spm_write_req_fifo_empty && (_axis_out_axim_spm_write_op_sel_fifo == 1))) begin
        _axis_out_axim_spm_write_data_busy <= 1;
        _axis_out_axim_spm_write_op_sel_buf <= _axis_out_axim_spm_write_op_sel_fifo;
        _axis_out_axim_spm_write_local_addr_buf <= _axis_out_axim_spm_write_local_addr_fifo;
        _axis_out_axim_spm_write_local_stride_buf <= _axis_out_axim_spm_write_local_stride_fifo;
        _axis_out_axim_spm_write_size_buf <= (_axis_out_axim_spm_write_size_fifo >> 1) + (((_axis_out_axim_spm_write_size_fifo & 1) > 0)? 1 : 0) << 1;
      end 
      if((_axis_out_axim_spm_write_data_wide_fsm == 2) && read_burst_rvalid_191 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_187 > 0))) begin
        _axis_out_axim_spm_write_size_buf <= _axis_out_axim_spm_write_size_buf - 1;
      end 
      if((_axis_out_axim_spm_write_data_wide_fsm == 2) && (_axis_out_axim_spm_write_wide_count_187 == 1) && read_burst_rvalid_191 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_187 > 0)) && read_burst_rlast_192) begin
        _axis_out_axim_spm_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_out_axim_spm_write_req_fifo <= 0;
      __tmp_186_1 <= 0;
    end else begin
      if(_axis_out_axim_spm_write_req_fifo_enq && !_axis_out_axim_spm_write_req_fifo_full && (_axis_out_axim_spm_write_req_fifo_deq && !_axis_out_axim_spm_write_req_fifo_empty)) begin
        count__axis_out_axim_spm_write_req_fifo <= count__axis_out_axim_spm_write_req_fifo;
      end else if(_axis_out_axim_spm_write_req_fifo_enq && !_axis_out_axim_spm_write_req_fifo_full) begin
        count__axis_out_axim_spm_write_req_fifo <= count__axis_out_axim_spm_write_req_fifo + 1;
      end else if(_axis_out_axim_spm_write_req_fifo_deq && !_axis_out_axim_spm_write_req_fifo_empty) begin
        count__axis_out_axim_spm_write_req_fifo <= count__axis_out_axim_spm_write_req_fifo - 1;
      end 
      __tmp_186_1 <= _tmp_186;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axis_in_axim_spm_read_data_busy <= 0;
      _axis_in_axim_spm_read_op_sel_buf <= 0;
      _axis_in_axim_spm_read_local_addr_buf <= 0;
      _axis_in_axim_spm_read_local_stride_buf <= 0;
      _axis_in_axim_spm_read_local_size_buf <= 0;
    end else begin
      if((_axis_in_axim_spm_read_data_wide_fsm == 0) && (!_axis_in_axim_spm_read_data_busy && !_axis_in_axim_spm_read_req_fifo_empty && (_axis_in_axim_spm_read_op_sel_fifo == 1))) begin
        _axis_in_axim_spm_read_data_busy <= 1;
        _axis_in_axim_spm_read_op_sel_buf <= _axis_in_axim_spm_read_op_sel_fifo;
        _axis_in_axim_spm_read_local_addr_buf <= _axis_in_axim_spm_read_local_addr_fifo;
        _axis_in_axim_spm_read_local_stride_buf <= _axis_in_axim_spm_read_local_stride_fifo;
        _axis_in_axim_spm_read_local_size_buf <= _axis_in_axim_spm_read_local_size_fifo;
      end 
      if((_axis_in_axim_spm_read_data_wide_fsm == 2) && (_axis_in_axim_spm_read_op_sel_buf == 1) && axis_in_axim_spm_tvalid && (_axis_in_axim_spm_read_wide_count_175 == 0)) begin
        _axis_in_axim_spm_read_local_size_buf <= _axis_in_axim_spm_read_local_size_buf - 1;
      end 
      if((_axis_in_axim_spm_read_data_wide_fsm == 2) && (_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_wide_count_175 > 0)) begin
        _axis_in_axim_spm_read_local_size_buf <= _axis_in_axim_spm_read_local_size_buf - 1;
      end 
      if((_axis_in_axim_spm_read_data_wide_fsm == 2) && (_axis_in_axim_spm_read_local_size_buf <= 1) && (_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_wide_count_175 > 0)) begin
        _axis_in_axim_spm_read_data_busy <= 0;
      end 
      if((_axis_in_axim_spm_read_data_wide_fsm == 2) && (_axis_in_axim_spm_read_local_size_buf <= 1) && (_axis_in_axim_spm_read_op_sel_buf == 1) && axis_in_axim_spm_tvalid && (_axis_in_axim_spm_read_wide_count_175 == 0)) begin
        _axis_in_axim_spm_read_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_in_axim_spm_read_req_fifo <= 0;
      __tmp_172_1 <= 0;
    end else begin
      if(_axis_in_axim_spm_read_req_fifo_enq && !_axis_in_axim_spm_read_req_fifo_full && (_axis_in_axim_spm_read_req_fifo_deq && !_axis_in_axim_spm_read_req_fifo_empty)) begin
        count__axis_in_axim_spm_read_req_fifo <= count__axis_in_axim_spm_read_req_fifo;
      end else if(_axis_in_axim_spm_read_req_fifo_enq && !_axis_in_axim_spm_read_req_fifo_full) begin
        count__axis_in_axim_spm_read_req_fifo <= count__axis_in_axim_spm_read_req_fifo + 1;
      end else if(_axis_in_axim_spm_read_req_fifo_deq && !_axis_in_axim_spm_read_req_fifo_empty) begin
        count__axis_in_axim_spm_read_req_fifo <= count__axis_in_axim_spm_read_req_fifo - 1;
      end 
      __tmp_172_1 <= _tmp_172;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axis_out_xored_spm_tdata <= 0;
      axis_out_xored_spm_tvalid <= 0;
      axis_out_xored_spm_tlast <= 0;
      _axis_out_xored_spm_cond_0_1 <= 0;
    end else begin
      if(_axis_out_xored_spm_cond_0_1) begin
        axis_out_xored_spm_tvalid <= 0;
        axis_out_xored_spm_tlast <= 0;
      end 
      if((_axis_out_xored_spm_write_data_wide_fsm == 2) && (_axis_out_xored_spm_write_op_sel_buf == 1) && (_axis_out_xored_spm_write_wide_count_218 == 1) && read_burst_rvalid_222 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_218 > 0)) && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid)) begin
        axis_out_xored_spm_tdata <= { read_burst_rdata_226, _axis_out_xored_spm_write_wide_wdata_227[127:64] };
        axis_out_xored_spm_tvalid <= 1;
        axis_out_xored_spm_tlast <= read_burst_rlast_223 || (_axis_out_xored_spm_write_size_buf <= 1);
      end 
      _axis_out_xored_spm_cond_0_1 <= 1;
      if(axis_out_xored_spm_tvalid && !axis_out_xored_spm_tready) begin
        axis_out_xored_spm_tvalid <= axis_out_xored_spm_tvalid;
        axis_out_xored_spm_tlast <= axis_out_xored_spm_tlast;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axis_out_xored_spm_write_data_busy <= 0;
      _axis_out_xored_spm_write_op_sel_buf <= 0;
      _axis_out_xored_spm_write_local_addr_buf <= 0;
      _axis_out_xored_spm_write_local_stride_buf <= 0;
      _axis_out_xored_spm_write_size_buf <= 0;
    end else begin
      if((_axis_out_xored_spm_write_data_wide_fsm == 0) && (!_axis_out_xored_spm_write_data_busy && !_axis_out_xored_spm_write_req_fifo_empty && (_axis_out_xored_spm_write_op_sel_fifo == 1))) begin
        _axis_out_xored_spm_write_data_busy <= 1;
        _axis_out_xored_spm_write_op_sel_buf <= _axis_out_xored_spm_write_op_sel_fifo;
        _axis_out_xored_spm_write_local_addr_buf <= _axis_out_xored_spm_write_local_addr_fifo;
        _axis_out_xored_spm_write_local_stride_buf <= _axis_out_xored_spm_write_local_stride_fifo;
        _axis_out_xored_spm_write_size_buf <= (_axis_out_xored_spm_write_size_fifo >> 1) + (((_axis_out_xored_spm_write_size_fifo & 1) > 0)? 1 : 0) << 1;
      end 
      if((_axis_out_xored_spm_write_data_wide_fsm == 2) && read_burst_rvalid_222 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_218 > 0))) begin
        _axis_out_xored_spm_write_size_buf <= _axis_out_xored_spm_write_size_buf - 1;
      end 
      if((_axis_out_xored_spm_write_data_wide_fsm == 2) && (_axis_out_xored_spm_write_wide_count_218 == 1) && read_burst_rvalid_222 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_218 > 0)) && read_burst_rlast_223) begin
        _axis_out_xored_spm_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_out_xored_spm_write_req_fifo <= 0;
      __tmp_217_1 <= 0;
    end else begin
      if(_axis_out_xored_spm_write_req_fifo_enq && !_axis_out_xored_spm_write_req_fifo_full && (_axis_out_xored_spm_write_req_fifo_deq && !_axis_out_xored_spm_write_req_fifo_empty)) begin
        count__axis_out_xored_spm_write_req_fifo <= count__axis_out_xored_spm_write_req_fifo;
      end else if(_axis_out_xored_spm_write_req_fifo_enq && !_axis_out_xored_spm_write_req_fifo_full) begin
        count__axis_out_xored_spm_write_req_fifo <= count__axis_out_xored_spm_write_req_fifo + 1;
      end else if(_axis_out_xored_spm_write_req_fifo_deq && !_axis_out_xored_spm_write_req_fifo_empty) begin
        count__axis_out_xored_spm_write_req_fifo <= count__axis_out_xored_spm_write_req_fifo - 1;
      end 
      __tmp_217_1 <= _tmp_217;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axis_in_xored_spm_read_data_busy <= 0;
      _axis_in_xored_spm_read_op_sel_buf <= 0;
      _axis_in_xored_spm_read_local_addr_buf <= 0;
      _axis_in_xored_spm_read_local_stride_buf <= 0;
      _axis_in_xored_spm_read_local_size_buf <= 0;
    end else begin
      if((_axis_in_xored_spm_read_data_wide_fsm == 0) && (!_axis_in_xored_spm_read_data_busy && !_axis_in_xored_spm_read_req_fifo_empty && (_axis_in_xored_spm_read_op_sel_fifo == 1))) begin
        _axis_in_xored_spm_read_data_busy <= 1;
        _axis_in_xored_spm_read_op_sel_buf <= _axis_in_xored_spm_read_op_sel_fifo;
        _axis_in_xored_spm_read_local_addr_buf <= _axis_in_xored_spm_read_local_addr_fifo;
        _axis_in_xored_spm_read_local_stride_buf <= _axis_in_xored_spm_read_local_stride_fifo;
        _axis_in_xored_spm_read_local_size_buf <= _axis_in_xored_spm_read_local_size_fifo;
      end 
      if((_axis_in_xored_spm_read_data_wide_fsm == 2) && (_axis_in_xored_spm_read_op_sel_buf == 1) && axis_in_xored_spm_tvalid && (_axis_in_xored_spm_read_wide_count_206 == 0)) begin
        _axis_in_xored_spm_read_local_size_buf <= _axis_in_xored_spm_read_local_size_buf - 1;
      end 
      if((_axis_in_xored_spm_read_data_wide_fsm == 2) && (_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_wide_count_206 > 0)) begin
        _axis_in_xored_spm_read_local_size_buf <= _axis_in_xored_spm_read_local_size_buf - 1;
      end 
      if((_axis_in_xored_spm_read_data_wide_fsm == 2) && (_axis_in_xored_spm_read_local_size_buf <= 1) && (_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_wide_count_206 > 0)) begin
        _axis_in_xored_spm_read_data_busy <= 0;
      end 
      if((_axis_in_xored_spm_read_data_wide_fsm == 2) && (_axis_in_xored_spm_read_local_size_buf <= 1) && (_axis_in_xored_spm_read_op_sel_buf == 1) && axis_in_xored_spm_tvalid && (_axis_in_xored_spm_read_wide_count_206 == 0)) begin
        _axis_in_xored_spm_read_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_in_xored_spm_read_req_fifo <= 0;
      __tmp_203_1 <= 0;
    end else begin
      if(_axis_in_xored_spm_read_req_fifo_enq && !_axis_in_xored_spm_read_req_fifo_full && (_axis_in_xored_spm_read_req_fifo_deq && !_axis_in_xored_spm_read_req_fifo_empty)) begin
        count__axis_in_xored_spm_read_req_fifo <= count__axis_in_xored_spm_read_req_fifo;
      end else if(_axis_in_xored_spm_read_req_fifo_enq && !_axis_in_xored_spm_read_req_fifo_full) begin
        count__axis_in_xored_spm_read_req_fifo <= count__axis_in_xored_spm_read_req_fifo + 1;
      end else if(_axis_in_xored_spm_read_req_fifo_deq && !_axis_in_xored_spm_read_req_fifo_empty) begin
        count__axis_in_xored_spm_read_req_fifo <= count__axis_in_xored_spm_read_req_fifo - 1;
      end 
      __tmp_203_1 <= _tmp_203;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      __tmp_143_1 <= 0;
      __tmp_160_1 <= 0;
      __tmp_164_1 <= 0;
      __tmp_194_1 <= 0;
      __tmp_225_1 <= 0;
    end else begin
      __tmp_143_1 <= _tmp_143;
      __tmp_160_1 <= _tmp_160;
      __tmp_164_1 <= _tmp_164;
      __tmp_194_1 <= _tmp_194;
      __tmp_225_1 <= _tmp_225;
    end
  end

  localparam spm_thread_1 = 1;
  localparam spm_thread_2 = 2;
  localparam spm_thread_3 = 3;
  localparam spm_thread_4 = 4;
  localparam spm_thread_5 = 5;
  localparam spm_thread_6 = 6;
  localparam spm_thread_7 = 7;
  localparam spm_thread_8 = 8;
  localparam spm_thread_9 = 9;
  localparam spm_thread_10 = 10;
  localparam spm_thread_11 = 11;
  localparam spm_thread_12 = 12;
  localparam spm_thread_13 = 13;
  localparam spm_thread_14 = 14;
  localparam spm_thread_15 = 15;
  localparam spm_thread_16 = 16;
  localparam spm_thread_17 = 17;
  localparam spm_thread_18 = 18;
  localparam spm_thread_19 = 19;
  localparam spm_thread_20 = 20;
  localparam spm_thread_21 = 21;
  localparam spm_thread_22 = 22;
  localparam spm_thread_23 = 23;
  localparam spm_thread_24 = 24;
  localparam spm_thread_25 = 25;
  localparam spm_thread_26 = 26;
  localparam spm_thread_27 = 27;
  localparam spm_thread_28 = 28;
  localparam spm_thread_29 = 29;
  localparam spm_thread_30 = 30;
  localparam spm_thread_31 = 31;
  localparam spm_thread_32 = 32;
  localparam spm_thread_33 = 33;
  localparam spm_thread_34 = 34;
  localparam spm_thread_35 = 35;
  localparam spm_thread_36 = 36;
  localparam spm_thread_37 = 37;
  localparam spm_thread_38 = 38;
  localparam spm_thread_39 = 39;
  localparam spm_thread_40 = 40;
  localparam spm_thread_41 = 41;
  localparam spm_thread_42 = 42;
  localparam spm_thread_43 = 43;
  localparam spm_thread_44 = 44;
  localparam spm_thread_45 = 45;

  always @(posedge CLK) begin
    if(RST) begin
      spm_thread <= spm_thread_init;
      dram_addr_69 <= 0;
      spm_addr_70 <= 0;
      size_73 <= 0;
      direction_71 <= 0;
      destination_72 <= 0;
      _spm_thread_i_0 <= 0;
      read_rdata_165 <= 0;
      tmp_data_2_76 <= 0;
    end else begin
      case(spm_thread)
        spm_thread_init: begin
          spm_thread <= spm_thread_1;
        end
        spm_thread_1: begin
          if(1) begin
            spm_thread <= spm_thread_2;
          end else begin
            spm_thread <= spm_thread_45;
          end
        end
        spm_thread_2: begin
          if(_axi_s_ctrl_spm_register_4 == 1) begin
            spm_thread <= spm_thread_3;
          end 
        end
        spm_thread_3: begin
          dram_addr_69 <= _axi_s_ctrl_spm_register_0;
          spm_thread <= spm_thread_4;
        end
        spm_thread_4: begin
          spm_addr_70 <= _axi_s_ctrl_spm_register_1;
          spm_thread <= spm_thread_5;
        end
        spm_thread_5: begin
          size_73 <= _axi_s_ctrl_spm_register_2;
          spm_thread <= spm_thread_6;
        end
        spm_thread_6: begin
          direction_71 <= _axi_s_ctrl_spm_register_3;
          spm_thread <= spm_thread_7;
        end
        spm_thread_7: begin
          destination_72 <= _axi_s_ctrl_spm_register_6;
          spm_thread <= spm_thread_8;
        end
        spm_thread_8: begin
          spm_thread <= spm_thread_9;
        end
        spm_thread_9: begin
          // $display("SPM operation: dram_addr=%x, spm_addr=%x, size=%d, direction=%d, destination=%d", dram_addr_69, spm_addr_70, size_73, direction_71, destination_72);
          spm_thread <= spm_thread_10;
        end
        spm_thread_10: begin
          if(destination_72 == 1) begin
            spm_thread <= spm_thread_11;
          end else begin
            spm_thread <= spm_thread_18;
          end
        end
        spm_thread_11: begin
          if(direction_71 == 0) begin
            spm_thread <= spm_thread_12;
          end else begin
            spm_thread <= spm_thread_15;
          end
        end
        spm_thread_12: begin
          if(_axi_m_dram_read_req_idle) begin
            spm_thread <= spm_thread_13;
          end 
        end
        spm_thread_13: begin
          if(_axi_m_dram_read_idle) begin
            spm_thread <= spm_thread_14;
          end 
        end
        spm_thread_14: begin
          spm_thread <= spm_thread_17;
        end
        spm_thread_15: begin
          if(_axi_m_dram_write_req_idle) begin
            spm_thread <= spm_thread_16;
          end 
        end
        spm_thread_16: begin
          if(_axi_m_dram_write_idle && !_axi_m_dram_has_outstanding_write) begin
            spm_thread <= spm_thread_17;
          end 
        end
        spm_thread_17: begin
          spm_thread <= spm_thread_42;
        end
        spm_thread_18: begin
          if(destination_72 == 2) begin
            spm_thread <= spm_thread_19;
          end else begin
            spm_thread <= spm_thread_29;
          end
        end
        spm_thread_19: begin
          if(direction_71 == 1) begin
            spm_thread <= spm_thread_20;
          end else begin
            spm_thread <= spm_thread_28;
          end
        end
        spm_thread_20: begin
          if(!_axis_out_mac_spm_write_req_fifo_almost_full) begin
            spm_thread <= spm_thread_21;
          end 
        end
        spm_thread_21: begin
          if(_axis_out_mac_spm_write_idle) begin
            spm_thread <= spm_thread_22;
          end 
        end
        spm_thread_22: begin
          _spm_thread_i_0 <= 0;
          spm_thread <= spm_thread_23;
        end
        spm_thread_23: begin
          if(_spm_thread_i_0 < 8) begin
            spm_thread <= spm_thread_24;
          end else begin
            spm_thread <= spm_thread_28;
          end
        end
        spm_thread_24: begin
          if(__tmp_164_1) begin
            read_rdata_165 <= ram_spm_0_rdata;
          end 
          if(__tmp_164_1) begin
            spm_thread <= spm_thread_25;
          end 
        end
        spm_thread_25: begin
          tmp_data_2_76 <= read_rdata_165;
          spm_thread <= spm_thread_26;
        end
        spm_thread_26: begin
          // $display(" MAC data %d: %x", _spm_thread_i_0, tmp_data_2_76);
          spm_thread <= spm_thread_27;
        end
        spm_thread_27: begin
          _spm_thread_i_0 <= _spm_thread_i_0 + 1;
          spm_thread <= spm_thread_23;
        end
        spm_thread_28: begin
          spm_thread <= spm_thread_42;
        end
        spm_thread_29: begin
          if(destination_72 == 4) begin
            spm_thread <= spm_thread_30;
          end else begin
            spm_thread <= spm_thread_35;
          end
        end
        spm_thread_30: begin
          if(direction_71 == 0) begin
            spm_thread <= spm_thread_31;
          end else begin
            spm_thread <= spm_thread_33;
          end
        end
        spm_thread_31: begin
          if(!_axis_in_axim_spm_read_req_fifo_almost_full) begin
            spm_thread <= spm_thread_32;
          end 
        end
        spm_thread_32: begin
          spm_thread <= spm_thread_34;
        end
        spm_thread_33: begin
          if(!_axis_out_axim_spm_write_req_fifo_almost_full) begin
            spm_thread <= spm_thread_34;
          end 
        end
        spm_thread_34: begin
          spm_thread <= spm_thread_42;
        end
        spm_thread_35: begin
          if(destination_72 == 8) begin
            spm_thread <= spm_thread_36;
          end else begin
            spm_thread <= spm_thread_42;
          end
        end
        spm_thread_36: begin
          if(direction_71 == 0) begin
            spm_thread <= spm_thread_37;
          end else begin
            spm_thread <= spm_thread_40;
          end
        end
        spm_thread_37: begin
          if(!_axis_in_xored_spm_read_req_fifo_almost_full) begin
            spm_thread <= spm_thread_38;
          end 
        end
        spm_thread_38: begin
          if(_axis_in_xored_spm_read_idle) begin
            spm_thread <= spm_thread_39;
          end 
        end
        spm_thread_39: begin
          spm_thread <= spm_thread_41;
        end
        spm_thread_40: begin
          if(!_axis_out_xored_spm_write_req_fifo_almost_full) begin
            spm_thread <= spm_thread_41;
          end 
        end
        spm_thread_41: begin
          spm_thread <= spm_thread_42;
        end
        spm_thread_42: begin
          spm_thread <= spm_thread_43;
        end
        spm_thread_43: begin
          spm_thread <= spm_thread_44;
        end
        spm_thread_44: begin
          spm_thread <= spm_thread_1;
        end
      endcase
    end
  end

  localparam _axi_m_dram_read_req_fsm_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_dram_read_req_fsm <= _axi_m_dram_read_req_fsm_init;
      _axi_m_dram_read_cont <= 0;
    end else begin
      case(_axi_m_dram_read_req_fsm)
        _axi_m_dram_read_req_fsm_init: begin
          if((_axi_m_dram_read_req_fsm == 0) && (_axi_m_dram_read_start || _axi_m_dram_read_cont) && !_axi_m_dram_read_req_fifo_almost_full) begin
            _axi_m_dram_read_req_fsm <= _axi_m_dram_read_req_fsm_1;
          end 
        end
        _axi_m_dram_read_req_fsm_1: begin
          if(axi_m_dram_arready || !axi_m_dram_arvalid) begin
            _axi_m_dram_read_cont <= 1;
          end 
          if((axi_m_dram_arready || !axi_m_dram_arvalid) && (_axi_m_dram_read_global_size == 0)) begin
            _axi_m_dram_read_cont <= 0;
          end 
          if(axi_m_dram_arready || !axi_m_dram_arvalid) begin
            _axi_m_dram_read_req_fsm <= _axi_m_dram_read_req_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam _axi_m_dram_read_data_wide_fsm_1 = 1;
  localparam _axi_m_dram_read_data_wide_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_dram_read_data_wide_fsm <= _axi_m_dram_read_data_wide_fsm_init;
      _axi_m_dram_read_wide_count_101 <= 0;
      _axi_m_dram_read_wide_wvalid_100 <= 0;
      _axi_m_dram_read_wide_wdata_99 <= 0;
    end else begin
      case(_axi_m_dram_read_data_wide_fsm)
        _axi_m_dram_read_data_wide_fsm_init: begin
          if(!_axi_m_dram_read_data_busy && !_axi_m_dram_read_req_fifo_empty && (_axi_m_dram_read_op_sel_fifo == 1)) begin
            _axi_m_dram_read_data_wide_fsm <= _axi_m_dram_read_data_wide_fsm_1;
          end 
        end
        _axi_m_dram_read_data_wide_fsm_1: begin
          _axi_m_dram_read_wide_count_101 <= 0;
          _axi_m_dram_read_wide_wvalid_100 <= 0;
          _axi_m_dram_read_data_wide_fsm <= _axi_m_dram_read_data_wide_fsm_2;
        end
        _axi_m_dram_read_data_wide_fsm_2: begin
          if(_axi_m_dram_read_op_sel_buf == 1) begin
            _axi_m_dram_read_wide_wvalid_100 <= 0;
          end 
          if((_axi_m_dram_read_op_sel_buf == 1) && _axi_m_dram_rvalid_sb_0 && (_axi_m_dram_read_wide_count_101 == 0)) begin
            _axi_m_dram_read_wide_count_101 <= _axi_m_dram_read_wide_count_101 + 1;
            _axi_m_dram_read_wide_wdata_99 <= _axi_m_dram_rdata_sb_0;
            _axi_m_dram_read_wide_wvalid_100 <= 1;
          end 
          if((_axi_m_dram_read_op_sel_buf == 1) && (_axi_m_dram_read_wide_count_101 > 0)) begin
            _axi_m_dram_read_wide_count_101 <= _axi_m_dram_read_wide_count_101 + 1;
            _axi_m_dram_read_wide_wdata_99 <= _axi_m_dram_read_wide_wdata_99 >> 64;
            _axi_m_dram_read_wide_wvalid_100 <= 1;
          end 
          if((_axi_m_dram_read_op_sel_buf == 1) && (_axi_m_dram_read_wide_count_101 == 1)) begin
            _axi_m_dram_read_wide_count_101 <= 0;
          end 
          if((_axi_m_dram_read_local_size_buf <= 1) && (_axi_m_dram_read_op_sel_buf == 1) && (_axi_m_dram_read_wide_count_101 > 0)) begin
            _axi_m_dram_read_data_wide_fsm <= _axi_m_dram_read_data_wide_fsm_init;
          end 
          if((_axi_m_dram_read_local_size_buf <= 1) && (_axi_m_dram_read_op_sel_buf == 1) && _axi_m_dram_rvalid_sb_0 && (_axi_m_dram_read_wide_count_101 == 0)) begin
            _axi_m_dram_read_data_wide_fsm <= _axi_m_dram_read_data_wide_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam write_burst_fsm_0_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      write_burst_fsm_0 <= write_burst_fsm_0_init;
      write_burst_addr_102 <= 0;
      write_burst_stride_103 <= 0;
      write_burst_length_104 <= 0;
      write_burst_done_105 <= 0;
    end else begin
      case(write_burst_fsm_0)
        write_burst_fsm_0_init: begin
          write_burst_addr_102 <= _axi_m_dram_read_local_addr_buf;
          write_burst_stride_103 <= _axi_m_dram_read_local_stride_buf;
          write_burst_length_104 <= _axi_m_dram_read_local_size_buf;
          write_burst_done_105 <= 0;
          if((_axi_m_dram_read_data_wide_fsm == 1) && (_axi_m_dram_read_op_sel_buf == 1) && (_axi_m_dram_read_local_size_buf > 0)) begin
            write_burst_fsm_0 <= write_burst_fsm_0_1;
          end 
        end
        write_burst_fsm_0_1: begin
          if(_axi_m_dram_read_wide_wvalid_100) begin
            write_burst_addr_102 <= write_burst_addr_102 + write_burst_stride_103;
            write_burst_length_104 <= write_burst_length_104 - 1;
            write_burst_done_105 <= 0;
          end 
          if(_axi_m_dram_read_wide_wvalid_100 && (write_burst_length_104 <= 1)) begin
            write_burst_done_105 <= 1;
          end 
          if(_axi_m_dram_read_wide_wvalid_100 && 0) begin
            write_burst_done_105 <= 1;
          end 
          if(_axi_m_dram_read_wide_wvalid_100 && (write_burst_length_104 <= 1)) begin
            write_burst_fsm_0 <= write_burst_fsm_0_init;
          end 
          if(_axi_m_dram_read_wide_wvalid_100 && 0) begin
            write_burst_fsm_0 <= write_burst_fsm_0_init;
          end 
          if(0) begin
            write_burst_fsm_0 <= write_burst_fsm_0_init;
          end 
        end
      endcase
    end
  end

  localparam _axi_m_dram_write_req_fsm_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_dram_write_req_fsm <= _axi_m_dram_write_req_fsm_init;
      _axi_m_dram_write_cont <= 0;
    end else begin
      case(_axi_m_dram_write_req_fsm)
        _axi_m_dram_write_req_fsm_init: begin
          if((_axi_m_dram_write_req_fsm == 0) && (_axi_m_dram_write_start || _axi_m_dram_write_cont) && !_axi_m_dram_write_req_fifo_almost_full) begin
            _axi_m_dram_write_req_fsm <= _axi_m_dram_write_req_fsm_1;
          end 
        end
        _axi_m_dram_write_req_fsm_1: begin
          if((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (axi_m_dram_awready || !axi_m_dram_awvalid) && (_axi_m_dram_outstanding_wcount < 6)) begin
            _axi_m_dram_write_cont <= 1;
          end 
          if((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (axi_m_dram_awready || !axi_m_dram_awvalid) && (_axi_m_dram_outstanding_wcount < 6) && (_axi_m_dram_write_global_size == 0)) begin
            _axi_m_dram_write_cont <= 0;
          end 
          if((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (axi_m_dram_awready || !axi_m_dram_awvalid) && (_axi_m_dram_outstanding_wcount < 6)) begin
            _axi_m_dram_write_req_fsm <= _axi_m_dram_write_req_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam _axi_m_dram_write_data_wide_fsm_1 = 1;
  localparam _axi_m_dram_write_data_wide_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_dram_write_data_wide_fsm <= _axi_m_dram_write_data_wide_fsm_init;
      _axi_m_dram_write_wide_count_136 <= 0;
      _axi_m_dram_write_wide_wdata_145 <= 0;
    end else begin
      case(_axi_m_dram_write_data_wide_fsm)
        _axi_m_dram_write_data_wide_fsm_init: begin
          if(!_axi_m_dram_write_data_busy && !_axi_m_dram_write_req_fifo_empty && (_axi_m_dram_write_op_sel_fifo == 1)) begin
            _axi_m_dram_write_data_wide_fsm <= _axi_m_dram_write_data_wide_fsm_1;
          end 
        end
        _axi_m_dram_write_data_wide_fsm_1: begin
          _axi_m_dram_write_wide_count_136 <= 0;
          _axi_m_dram_write_data_wide_fsm <= _axi_m_dram_write_data_wide_fsm_2;
        end
        _axi_m_dram_write_data_wide_fsm_2: begin
          if(read_burst_rvalid_140 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0 || (_axi_m_dram_write_wide_count_136 > 0)) && (_axi_m_dram_write_size_buf > 0))) begin
            _axi_m_dram_write_wide_wdata_145 <= { read_burst_rdata_144, _axi_m_dram_write_wide_wdata_145[127:64] };
            _axi_m_dram_write_wide_count_136 <= _axi_m_dram_write_wide_count_136 + 1;
          end 
          if(read_burst_rvalid_140 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0 || (_axi_m_dram_write_wide_count_136 > 0)) && (_axi_m_dram_write_size_buf > 0)) && (_axi_m_dram_write_wide_count_136 == 1)) begin
            _axi_m_dram_write_wide_count_136 <= 0;
          end 
          if((_axi_m_dram_write_wide_count_136 == 1) && read_burst_rvalid_140 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0 || (_axi_m_dram_write_wide_count_136 > 0)) && (_axi_m_dram_write_size_buf > 0)) && read_burst_rlast_141) begin
            _axi_m_dram_write_data_wide_fsm <= _axi_m_dram_write_data_wide_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam read_burst_fsm_1_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      read_burst_fsm_1 <= read_burst_fsm_1_init;
      read_burst_addr_137 <= 0;
      read_burst_stride_138 <= 0;
      read_burst_length_139 <= 0;
      read_burst_rvalid_140 <= 0;
      read_burst_rlast_141 <= 0;
    end else begin
      case(read_burst_fsm_1)
        read_burst_fsm_1_init: begin
          read_burst_addr_137 <= _axi_m_dram_write_local_addr_buf;
          read_burst_stride_138 <= _axi_m_dram_write_local_stride_buf;
          read_burst_length_139 <= _axi_m_dram_write_size_buf;
          read_burst_rvalid_140 <= 0;
          read_burst_rlast_141 <= 0;
          if((_axi_m_dram_write_data_wide_fsm == 1) && (_axi_m_dram_write_op_sel_buf == 1) && (_axi_m_dram_write_size_buf > 0)) begin
            read_burst_fsm_1 <= read_burst_fsm_1_1;
          end 
        end
        read_burst_fsm_1_1: begin
          if((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0 || (_axi_m_dram_write_wide_count_136 > 0)) && (_axi_m_dram_write_size_buf > 0) && (read_burst_length_139 > 0)) begin
            read_burst_addr_137 <= read_burst_addr_137 + read_burst_stride_138;
            read_burst_length_139 <= read_burst_length_139 - 1;
            read_burst_rvalid_140 <= 1;
          end 
          if((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0 || (_axi_m_dram_write_wide_count_136 > 0)) && (_axi_m_dram_write_size_buf > 0) && (read_burst_length_139 <= 1)) begin
            read_burst_rlast_141 <= 1;
          end 
          if(read_burst_rlast_141 && read_burst_rvalid_140 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0 || (_axi_m_dram_write_wide_count_136 > 0)) && (_axi_m_dram_write_size_buf > 0))) begin
            read_burst_rvalid_140 <= 0;
            read_burst_rlast_141 <= 0;
          end 
          if(0) begin
            read_burst_rvalid_140 <= 0;
            read_burst_rlast_141 <= 0;
          end 
          if(read_burst_rlast_141 && read_burst_rvalid_140 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0 || (_axi_m_dram_write_wide_count_136 > 0)) && (_axi_m_dram_write_size_buf > 0))) begin
            read_burst_fsm_1 <= read_burst_fsm_1_init;
          end 
          if(0) begin
            read_burst_fsm_1 <= read_burst_fsm_1_init;
          end 
        end
      endcase
    end
  end

  localparam _axis_out_mac_spm_write_data_wide_fsm_1 = 1;
  localparam _axis_out_mac_spm_write_data_wide_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axis_out_mac_spm_write_data_wide_fsm <= _axis_out_mac_spm_write_data_wide_fsm_init;
      _axis_out_mac_spm_write_wide_count_153 <= 0;
      _axis_out_mac_spm_write_wide_wdata_162 <= 0;
    end else begin
      case(_axis_out_mac_spm_write_data_wide_fsm)
        _axis_out_mac_spm_write_data_wide_fsm_init: begin
          if(!_axis_out_mac_spm_write_data_busy && !_axis_out_mac_spm_write_req_fifo_empty && (_axis_out_mac_spm_write_op_sel_fifo == 1)) begin
            _axis_out_mac_spm_write_data_wide_fsm <= _axis_out_mac_spm_write_data_wide_fsm_1;
          end 
        end
        _axis_out_mac_spm_write_data_wide_fsm_1: begin
          _axis_out_mac_spm_write_wide_count_153 <= 0;
          _axis_out_mac_spm_write_data_wide_fsm <= _axis_out_mac_spm_write_data_wide_fsm_2;
        end
        _axis_out_mac_spm_write_data_wide_fsm_2: begin
          if(read_burst_rvalid_157 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_153 > 0))) begin
            _axis_out_mac_spm_write_wide_wdata_162 <= { read_burst_rdata_161, _axis_out_mac_spm_write_wide_wdata_162[127:64] };
            _axis_out_mac_spm_write_wide_count_153 <= _axis_out_mac_spm_write_wide_count_153 + 1;
          end 
          if(read_burst_rvalid_157 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_153 > 0)) && (_axis_out_mac_spm_write_wide_count_153 == 1)) begin
            _axis_out_mac_spm_write_wide_count_153 <= 0;
          end 
          if((_axis_out_mac_spm_write_wide_count_153 == 1) && read_burst_rvalid_157 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_153 > 0)) && read_burst_rlast_158) begin
            _axis_out_mac_spm_write_data_wide_fsm <= _axis_out_mac_spm_write_data_wide_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam read_burst_fsm_2_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      read_burst_fsm_2 <= read_burst_fsm_2_init;
      read_burst_addr_154 <= 0;
      read_burst_stride_155 <= 0;
      read_burst_length_156 <= 0;
      read_burst_rvalid_157 <= 0;
      read_burst_rlast_158 <= 0;
    end else begin
      case(read_burst_fsm_2)
        read_burst_fsm_2_init: begin
          read_burst_addr_154 <= _axis_out_mac_spm_write_local_addr_buf;
          read_burst_stride_155 <= _axis_out_mac_spm_write_local_stride_buf;
          read_burst_length_156 <= _axis_out_mac_spm_write_size_buf;
          read_burst_rvalid_157 <= 0;
          read_burst_rlast_158 <= 0;
          if((_axis_out_mac_spm_write_data_wide_fsm == 1) && (_axis_out_mac_spm_write_op_sel_buf == 1) && (_axis_out_mac_spm_write_size_buf > 0)) begin
            read_burst_fsm_2 <= read_burst_fsm_2_1;
          end 
        end
        read_burst_fsm_2_1: begin
          if((axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_153 > 0)) && (read_burst_length_156 > 0)) begin
            read_burst_addr_154 <= read_burst_addr_154 + read_burst_stride_155;
            read_burst_length_156 <= read_burst_length_156 - 1;
            read_burst_rvalid_157 <= 1;
          end 
          if((axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_153 > 0)) && (read_burst_length_156 <= 1)) begin
            read_burst_rlast_158 <= 1;
          end 
          if(read_burst_rlast_158 && read_burst_rvalid_157 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_153 > 0))) begin
            read_burst_rvalid_157 <= 0;
            read_burst_rlast_158 <= 0;
          end 
          if(0) begin
            read_burst_rvalid_157 <= 0;
            read_burst_rlast_158 <= 0;
          end 
          if(read_burst_rlast_158 && read_burst_rvalid_157 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_153 > 0))) begin
            read_burst_fsm_2 <= read_burst_fsm_2_init;
          end 
          if(0) begin
            read_burst_fsm_2 <= read_burst_fsm_2_init;
          end 
        end
      endcase
    end
  end

  localparam _axis_in_axim_spm_read_data_wide_fsm_1 = 1;
  localparam _axis_in_axim_spm_read_data_wide_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axis_in_axim_spm_read_data_wide_fsm <= _axis_in_axim_spm_read_data_wide_fsm_init;
      _axis_in_axim_spm_read_wide_count_175 <= 0;
      _axis_in_axim_spm_read_wide_wvalid_174 <= 0;
      _axis_in_axim_spm_read_wide_wdata_173 <= 0;
    end else begin
      case(_axis_in_axim_spm_read_data_wide_fsm)
        _axis_in_axim_spm_read_data_wide_fsm_init: begin
          if(!_axis_in_axim_spm_read_data_busy && !_axis_in_axim_spm_read_req_fifo_empty && (_axis_in_axim_spm_read_op_sel_fifo == 1)) begin
            _axis_in_axim_spm_read_data_wide_fsm <= _axis_in_axim_spm_read_data_wide_fsm_1;
          end 
        end
        _axis_in_axim_spm_read_data_wide_fsm_1: begin
          _axis_in_axim_spm_read_wide_count_175 <= 0;
          _axis_in_axim_spm_read_wide_wvalid_174 <= 0;
          _axis_in_axim_spm_read_data_wide_fsm <= _axis_in_axim_spm_read_data_wide_fsm_2;
        end
        _axis_in_axim_spm_read_data_wide_fsm_2: begin
          if(_axis_in_axim_spm_read_op_sel_buf == 1) begin
            _axis_in_axim_spm_read_wide_wvalid_174 <= 0;
          end 
          if((_axis_in_axim_spm_read_op_sel_buf == 1) && axis_in_axim_spm_tvalid && (_axis_in_axim_spm_read_wide_count_175 == 0)) begin
            _axis_in_axim_spm_read_wide_count_175 <= _axis_in_axim_spm_read_wide_count_175 + 1;
            _axis_in_axim_spm_read_wide_wdata_173 <= axis_in_axim_spm_tdata;
            _axis_in_axim_spm_read_wide_wvalid_174 <= 1;
          end 
          if((_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_wide_count_175 > 0)) begin
            _axis_in_axim_spm_read_wide_count_175 <= _axis_in_axim_spm_read_wide_count_175 + 1;
            _axis_in_axim_spm_read_wide_wdata_173 <= _axis_in_axim_spm_read_wide_wdata_173 >> 64;
            _axis_in_axim_spm_read_wide_wvalid_174 <= 1;
          end 
          if((_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_wide_count_175 == 1)) begin
            _axis_in_axim_spm_read_wide_count_175 <= 0;
          end 
          if((_axis_in_axim_spm_read_local_size_buf <= 1) && (_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_wide_count_175 > 0)) begin
            _axis_in_axim_spm_read_data_wide_fsm <= _axis_in_axim_spm_read_data_wide_fsm_init;
          end 
          if((_axis_in_axim_spm_read_local_size_buf <= 1) && (_axis_in_axim_spm_read_op_sel_buf == 1) && axis_in_axim_spm_tvalid && (_axis_in_axim_spm_read_wide_count_175 == 0)) begin
            _axis_in_axim_spm_read_data_wide_fsm <= _axis_in_axim_spm_read_data_wide_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam write_burst_fsm_3_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      write_burst_fsm_3 <= write_burst_fsm_3_init;
      write_burst_addr_176 <= 0;
      write_burst_stride_177 <= 0;
      write_burst_length_178 <= 0;
      write_burst_done_179 <= 0;
    end else begin
      case(write_burst_fsm_3)
        write_burst_fsm_3_init: begin
          write_burst_addr_176 <= _axis_in_axim_spm_read_local_addr_buf;
          write_burst_stride_177 <= _axis_in_axim_spm_read_local_stride_buf;
          write_burst_length_178 <= _axis_in_axim_spm_read_local_size_buf;
          write_burst_done_179 <= 0;
          if((_axis_in_axim_spm_read_data_wide_fsm == 1) && (_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_local_size_buf > 0)) begin
            write_burst_fsm_3 <= write_burst_fsm_3_1;
          end 
        end
        write_burst_fsm_3_1: begin
          if(_axis_in_axim_spm_read_wide_wvalid_174) begin
            write_burst_addr_176 <= write_burst_addr_176 + write_burst_stride_177;
            write_burst_length_178 <= write_burst_length_178 - 1;
            write_burst_done_179 <= 0;
          end 
          if(_axis_in_axim_spm_read_wide_wvalid_174 && (write_burst_length_178 <= 1)) begin
            write_burst_done_179 <= 1;
          end 
          if(_axis_in_axim_spm_read_wide_wvalid_174 && 0) begin
            write_burst_done_179 <= 1;
          end 
          if(_axis_in_axim_spm_read_wide_wvalid_174 && (write_burst_length_178 <= 1)) begin
            write_burst_fsm_3 <= write_burst_fsm_3_init;
          end 
          if(_axis_in_axim_spm_read_wide_wvalid_174 && 0) begin
            write_burst_fsm_3 <= write_burst_fsm_3_init;
          end 
          if(0) begin
            write_burst_fsm_3 <= write_burst_fsm_3_init;
          end 
        end
      endcase
    end
  end

  localparam _axis_out_axim_spm_write_data_wide_fsm_1 = 1;
  localparam _axis_out_axim_spm_write_data_wide_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axis_out_axim_spm_write_data_wide_fsm <= _axis_out_axim_spm_write_data_wide_fsm_init;
      _axis_out_axim_spm_write_wide_count_187 <= 0;
      _axis_out_axim_spm_write_wide_wdata_196 <= 0;
    end else begin
      case(_axis_out_axim_spm_write_data_wide_fsm)
        _axis_out_axim_spm_write_data_wide_fsm_init: begin
          if(!_axis_out_axim_spm_write_data_busy && !_axis_out_axim_spm_write_req_fifo_empty && (_axis_out_axim_spm_write_op_sel_fifo == 1)) begin
            _axis_out_axim_spm_write_data_wide_fsm <= _axis_out_axim_spm_write_data_wide_fsm_1;
          end 
        end
        _axis_out_axim_spm_write_data_wide_fsm_1: begin
          _axis_out_axim_spm_write_wide_count_187 <= 0;
          _axis_out_axim_spm_write_data_wide_fsm <= _axis_out_axim_spm_write_data_wide_fsm_2;
        end
        _axis_out_axim_spm_write_data_wide_fsm_2: begin
          if(read_burst_rvalid_191 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_187 > 0))) begin
            _axis_out_axim_spm_write_wide_wdata_196 <= { read_burst_rdata_195, _axis_out_axim_spm_write_wide_wdata_196[127:64] };
            _axis_out_axim_spm_write_wide_count_187 <= _axis_out_axim_spm_write_wide_count_187 + 1;
          end 
          if(read_burst_rvalid_191 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_187 > 0)) && (_axis_out_axim_spm_write_wide_count_187 == 1)) begin
            _axis_out_axim_spm_write_wide_count_187 <= 0;
          end 
          if((_axis_out_axim_spm_write_wide_count_187 == 1) && read_burst_rvalid_191 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_187 > 0)) && read_burst_rlast_192) begin
            _axis_out_axim_spm_write_data_wide_fsm <= _axis_out_axim_spm_write_data_wide_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam read_burst_fsm_4_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      read_burst_fsm_4 <= read_burst_fsm_4_init;
      read_burst_addr_188 <= 0;
      read_burst_stride_189 <= 0;
      read_burst_length_190 <= 0;
      read_burst_rvalid_191 <= 0;
      read_burst_rlast_192 <= 0;
    end else begin
      case(read_burst_fsm_4)
        read_burst_fsm_4_init: begin
          read_burst_addr_188 <= _axis_out_axim_spm_write_local_addr_buf;
          read_burst_stride_189 <= _axis_out_axim_spm_write_local_stride_buf;
          read_burst_length_190 <= _axis_out_axim_spm_write_size_buf;
          read_burst_rvalid_191 <= 0;
          read_burst_rlast_192 <= 0;
          if((_axis_out_axim_spm_write_data_wide_fsm == 1) && (_axis_out_axim_spm_write_op_sel_buf == 1) && (_axis_out_axim_spm_write_size_buf > 0)) begin
            read_burst_fsm_4 <= read_burst_fsm_4_1;
          end 
        end
        read_burst_fsm_4_1: begin
          if((axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_187 > 0)) && (read_burst_length_190 > 0)) begin
            read_burst_addr_188 <= read_burst_addr_188 + read_burst_stride_189;
            read_burst_length_190 <= read_burst_length_190 - 1;
            read_burst_rvalid_191 <= 1;
          end 
          if((axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_187 > 0)) && (read_burst_length_190 <= 1)) begin
            read_burst_rlast_192 <= 1;
          end 
          if(read_burst_rlast_192 && read_burst_rvalid_191 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_187 > 0))) begin
            read_burst_rvalid_191 <= 0;
            read_burst_rlast_192 <= 0;
          end 
          if(0) begin
            read_burst_rvalid_191 <= 0;
            read_burst_rlast_192 <= 0;
          end 
          if(read_burst_rlast_192 && read_burst_rvalid_191 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_187 > 0))) begin
            read_burst_fsm_4 <= read_burst_fsm_4_init;
          end 
          if(0) begin
            read_burst_fsm_4 <= read_burst_fsm_4_init;
          end 
        end
      endcase
    end
  end

  localparam _axis_in_xored_spm_read_data_wide_fsm_1 = 1;
  localparam _axis_in_xored_spm_read_data_wide_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axis_in_xored_spm_read_data_wide_fsm <= _axis_in_xored_spm_read_data_wide_fsm_init;
      _axis_in_xored_spm_read_wide_count_206 <= 0;
      _axis_in_xored_spm_read_wide_wvalid_205 <= 0;
      _axis_in_xored_spm_read_wide_wdata_204 <= 0;
    end else begin
      case(_axis_in_xored_spm_read_data_wide_fsm)
        _axis_in_xored_spm_read_data_wide_fsm_init: begin
          if(!_axis_in_xored_spm_read_data_busy && !_axis_in_xored_spm_read_req_fifo_empty && (_axis_in_xored_spm_read_op_sel_fifo == 1)) begin
            _axis_in_xored_spm_read_data_wide_fsm <= _axis_in_xored_spm_read_data_wide_fsm_1;
          end 
        end
        _axis_in_xored_spm_read_data_wide_fsm_1: begin
          _axis_in_xored_spm_read_wide_count_206 <= 0;
          _axis_in_xored_spm_read_wide_wvalid_205 <= 0;
          _axis_in_xored_spm_read_data_wide_fsm <= _axis_in_xored_spm_read_data_wide_fsm_2;
        end
        _axis_in_xored_spm_read_data_wide_fsm_2: begin
          if(_axis_in_xored_spm_read_op_sel_buf == 1) begin
            _axis_in_xored_spm_read_wide_wvalid_205 <= 0;
          end 
          if((_axis_in_xored_spm_read_op_sel_buf == 1) && axis_in_xored_spm_tvalid && (_axis_in_xored_spm_read_wide_count_206 == 0)) begin
            _axis_in_xored_spm_read_wide_count_206 <= _axis_in_xored_spm_read_wide_count_206 + 1;
            _axis_in_xored_spm_read_wide_wdata_204 <= axis_in_xored_spm_tdata;
            _axis_in_xored_spm_read_wide_wvalid_205 <= 1;
          end 
          if((_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_wide_count_206 > 0)) begin
            _axis_in_xored_spm_read_wide_count_206 <= _axis_in_xored_spm_read_wide_count_206 + 1;
            _axis_in_xored_spm_read_wide_wdata_204 <= _axis_in_xored_spm_read_wide_wdata_204 >> 64;
            _axis_in_xored_spm_read_wide_wvalid_205 <= 1;
          end 
          if((_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_wide_count_206 == 1)) begin
            _axis_in_xored_spm_read_wide_count_206 <= 0;
          end 
          if((_axis_in_xored_spm_read_local_size_buf <= 1) && (_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_wide_count_206 > 0)) begin
            _axis_in_xored_spm_read_data_wide_fsm <= _axis_in_xored_spm_read_data_wide_fsm_init;
          end 
          if((_axis_in_xored_spm_read_local_size_buf <= 1) && (_axis_in_xored_spm_read_op_sel_buf == 1) && axis_in_xored_spm_tvalid && (_axis_in_xored_spm_read_wide_count_206 == 0)) begin
            _axis_in_xored_spm_read_data_wide_fsm <= _axis_in_xored_spm_read_data_wide_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam write_burst_fsm_5_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      write_burst_fsm_5 <= write_burst_fsm_5_init;
      write_burst_addr_207 <= 0;
      write_burst_stride_208 <= 0;
      write_burst_length_209 <= 0;
      write_burst_done_210 <= 0;
    end else begin
      case(write_burst_fsm_5)
        write_burst_fsm_5_init: begin
          write_burst_addr_207 <= _axis_in_xored_spm_read_local_addr_buf;
          write_burst_stride_208 <= _axis_in_xored_spm_read_local_stride_buf;
          write_burst_length_209 <= _axis_in_xored_spm_read_local_size_buf;
          write_burst_done_210 <= 0;
          if((_axis_in_xored_spm_read_data_wide_fsm == 1) && (_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_local_size_buf > 0)) begin
            write_burst_fsm_5 <= write_burst_fsm_5_1;
          end 
        end
        write_burst_fsm_5_1: begin
          if(_axis_in_xored_spm_read_wide_wvalid_205) begin
            write_burst_addr_207 <= write_burst_addr_207 + write_burst_stride_208;
            write_burst_length_209 <= write_burst_length_209 - 1;
            write_burst_done_210 <= 0;
          end 
          if(_axis_in_xored_spm_read_wide_wvalid_205 && (write_burst_length_209 <= 1)) begin
            write_burst_done_210 <= 1;
          end 
          if(_axis_in_xored_spm_read_wide_wvalid_205 && 0) begin
            write_burst_done_210 <= 1;
          end 
          if(_axis_in_xored_spm_read_wide_wvalid_205 && (write_burst_length_209 <= 1)) begin
            write_burst_fsm_5 <= write_burst_fsm_5_init;
          end 
          if(_axis_in_xored_spm_read_wide_wvalid_205 && 0) begin
            write_burst_fsm_5 <= write_burst_fsm_5_init;
          end 
          if(0) begin
            write_burst_fsm_5 <= write_burst_fsm_5_init;
          end 
        end
      endcase
    end
  end

  localparam _axis_out_xored_spm_write_data_wide_fsm_1 = 1;
  localparam _axis_out_xored_spm_write_data_wide_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axis_out_xored_spm_write_data_wide_fsm <= _axis_out_xored_spm_write_data_wide_fsm_init;
      _axis_out_xored_spm_write_wide_count_218 <= 0;
      _axis_out_xored_spm_write_wide_wdata_227 <= 0;
    end else begin
      case(_axis_out_xored_spm_write_data_wide_fsm)
        _axis_out_xored_spm_write_data_wide_fsm_init: begin
          if(!_axis_out_xored_spm_write_data_busy && !_axis_out_xored_spm_write_req_fifo_empty && (_axis_out_xored_spm_write_op_sel_fifo == 1)) begin
            _axis_out_xored_spm_write_data_wide_fsm <= _axis_out_xored_spm_write_data_wide_fsm_1;
          end 
        end
        _axis_out_xored_spm_write_data_wide_fsm_1: begin
          _axis_out_xored_spm_write_wide_count_218 <= 0;
          _axis_out_xored_spm_write_data_wide_fsm <= _axis_out_xored_spm_write_data_wide_fsm_2;
        end
        _axis_out_xored_spm_write_data_wide_fsm_2: begin
          if(read_burst_rvalid_222 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_218 > 0))) begin
            _axis_out_xored_spm_write_wide_wdata_227 <= { read_burst_rdata_226, _axis_out_xored_spm_write_wide_wdata_227[127:64] };
            _axis_out_xored_spm_write_wide_count_218 <= _axis_out_xored_spm_write_wide_count_218 + 1;
          end 
          if(read_burst_rvalid_222 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_218 > 0)) && (_axis_out_xored_spm_write_wide_count_218 == 1)) begin
            _axis_out_xored_spm_write_wide_count_218 <= 0;
          end 
          if((_axis_out_xored_spm_write_wide_count_218 == 1) && read_burst_rvalid_222 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_218 > 0)) && read_burst_rlast_223) begin
            _axis_out_xored_spm_write_data_wide_fsm <= _axis_out_xored_spm_write_data_wide_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam read_burst_fsm_6_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      read_burst_fsm_6 <= read_burst_fsm_6_init;
      read_burst_addr_219 <= 0;
      read_burst_stride_220 <= 0;
      read_burst_length_221 <= 0;
      read_burst_rvalid_222 <= 0;
      read_burst_rlast_223 <= 0;
    end else begin
      case(read_burst_fsm_6)
        read_burst_fsm_6_init: begin
          read_burst_addr_219 <= _axis_out_xored_spm_write_local_addr_buf;
          read_burst_stride_220 <= _axis_out_xored_spm_write_local_stride_buf;
          read_burst_length_221 <= _axis_out_xored_spm_write_size_buf;
          read_burst_rvalid_222 <= 0;
          read_burst_rlast_223 <= 0;
          if((_axis_out_xored_spm_write_data_wide_fsm == 1) && (_axis_out_xored_spm_write_op_sel_buf == 1) && (_axis_out_xored_spm_write_size_buf > 0)) begin
            read_burst_fsm_6 <= read_burst_fsm_6_1;
          end 
        end
        read_burst_fsm_6_1: begin
          if((axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_218 > 0)) && (read_burst_length_221 > 0)) begin
            read_burst_addr_219 <= read_burst_addr_219 + read_burst_stride_220;
            read_burst_length_221 <= read_burst_length_221 - 1;
            read_burst_rvalid_222 <= 1;
          end 
          if((axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_218 > 0)) && (read_burst_length_221 <= 1)) begin
            read_burst_rlast_223 <= 1;
          end 
          if(read_burst_rlast_223 && read_burst_rvalid_222 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_218 > 0))) begin
            read_burst_rvalid_222 <= 0;
            read_burst_rlast_223 <= 0;
          end 
          if(0) begin
            read_burst_rvalid_222 <= 0;
            read_burst_rlast_223 <= 0;
          end 
          if(read_burst_rlast_223 && read_burst_rvalid_222 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_218 > 0))) begin
            read_burst_fsm_6 <= read_burst_fsm_6_init;
          end 
          if(0) begin
            read_burst_fsm_6 <= read_burst_fsm_6_init;
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



module _axis_out_mac_spm_write_req_fifo
(
  input CLK,
  input RST,
  input _axis_out_mac_spm_write_req_fifo_enq,
  input [105-1:0] _axis_out_mac_spm_write_req_fifo_wdata,
  output _axis_out_mac_spm_write_req_fifo_full,
  output _axis_out_mac_spm_write_req_fifo_almost_full,
  input _axis_out_mac_spm_write_req_fifo_deq,
  output [105-1:0] _axis_out_mac_spm_write_req_fifo_rdata,
  output _axis_out_mac_spm_write_req_fifo_empty,
  output _axis_out_mac_spm_write_req_fifo_almost_empty
);

  reg [105-1:0] mem [0:8-1];
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
  wire [105-1:0] rdata;
  assign _axis_out_mac_spm_write_req_fifo_full = is_full;
  assign _axis_out_mac_spm_write_req_fifo_almost_full = is_almost_full || is_full;
  assign _axis_out_mac_spm_write_req_fifo_empty = is_empty;
  assign _axis_out_mac_spm_write_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axis_out_mac_spm_write_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axis_out_mac_spm_write_req_fifo_enq && !is_full) begin
        mem[head] <= _axis_out_mac_spm_write_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axis_out_mac_spm_write_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _axis_out_axim_spm_write_req_fifo
(
  input CLK,
  input RST,
  input _axis_out_axim_spm_write_req_fifo_enq,
  input [105-1:0] _axis_out_axim_spm_write_req_fifo_wdata,
  output _axis_out_axim_spm_write_req_fifo_full,
  output _axis_out_axim_spm_write_req_fifo_almost_full,
  input _axis_out_axim_spm_write_req_fifo_deq,
  output [105-1:0] _axis_out_axim_spm_write_req_fifo_rdata,
  output _axis_out_axim_spm_write_req_fifo_empty,
  output _axis_out_axim_spm_write_req_fifo_almost_empty
);

  reg [105-1:0] mem [0:8-1];
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
  wire [105-1:0] rdata;
  assign _axis_out_axim_spm_write_req_fifo_full = is_full;
  assign _axis_out_axim_spm_write_req_fifo_almost_full = is_almost_full || is_full;
  assign _axis_out_axim_spm_write_req_fifo_empty = is_empty;
  assign _axis_out_axim_spm_write_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axis_out_axim_spm_write_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axis_out_axim_spm_write_req_fifo_enq && !is_full) begin
        mem[head] <= _axis_out_axim_spm_write_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axis_out_axim_spm_write_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _axis_in_axim_spm_read_req_fifo
(
  input CLK,
  input RST,
  input _axis_in_axim_spm_read_req_fifo_enq,
  input [105-1:0] _axis_in_axim_spm_read_req_fifo_wdata,
  output _axis_in_axim_spm_read_req_fifo_full,
  output _axis_in_axim_spm_read_req_fifo_almost_full,
  input _axis_in_axim_spm_read_req_fifo_deq,
  output [105-1:0] _axis_in_axim_spm_read_req_fifo_rdata,
  output _axis_in_axim_spm_read_req_fifo_empty,
  output _axis_in_axim_spm_read_req_fifo_almost_empty
);

  reg [105-1:0] mem [0:8-1];
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
  wire [105-1:0] rdata;
  assign _axis_in_axim_spm_read_req_fifo_full = is_full;
  assign _axis_in_axim_spm_read_req_fifo_almost_full = is_almost_full || is_full;
  assign _axis_in_axim_spm_read_req_fifo_empty = is_empty;
  assign _axis_in_axim_spm_read_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axis_in_axim_spm_read_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axis_in_axim_spm_read_req_fifo_enq && !is_full) begin
        mem[head] <= _axis_in_axim_spm_read_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axis_in_axim_spm_read_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _axis_out_xored_spm_write_req_fifo
(
  input CLK,
  input RST,
  input _axis_out_xored_spm_write_req_fifo_enq,
  input [105-1:0] _axis_out_xored_spm_write_req_fifo_wdata,
  output _axis_out_xored_spm_write_req_fifo_full,
  output _axis_out_xored_spm_write_req_fifo_almost_full,
  input _axis_out_xored_spm_write_req_fifo_deq,
  output [105-1:0] _axis_out_xored_spm_write_req_fifo_rdata,
  output _axis_out_xored_spm_write_req_fifo_empty,
  output _axis_out_xored_spm_write_req_fifo_almost_empty
);

  reg [105-1:0] mem [0:8-1];
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
  wire [105-1:0] rdata;
  assign _axis_out_xored_spm_write_req_fifo_full = is_full;
  assign _axis_out_xored_spm_write_req_fifo_almost_full = is_almost_full || is_full;
  assign _axis_out_xored_spm_write_req_fifo_empty = is_empty;
  assign _axis_out_xored_spm_write_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axis_out_xored_spm_write_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axis_out_xored_spm_write_req_fifo_enq && !is_full) begin
        mem[head] <= _axis_out_xored_spm_write_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axis_out_xored_spm_write_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _axis_in_xored_spm_read_req_fifo
(
  input CLK,
  input RST,
  input _axis_in_xored_spm_read_req_fifo_enq,
  input [105-1:0] _axis_in_xored_spm_read_req_fifo_wdata,
  output _axis_in_xored_spm_read_req_fifo_full,
  output _axis_in_xored_spm_read_req_fifo_almost_full,
  input _axis_in_xored_spm_read_req_fifo_deq,
  output [105-1:0] _axis_in_xored_spm_read_req_fifo_rdata,
  output _axis_in_xored_spm_read_req_fifo_empty,
  output _axis_in_xored_spm_read_req_fifo_almost_empty
);

  reg [105-1:0] mem [0:8-1];
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
  wire [105-1:0] rdata;
  assign _axis_in_xored_spm_read_req_fifo_full = is_full;
  assign _axis_in_xored_spm_read_req_fifo_almost_full = is_almost_full || is_full;
  assign _axis_in_xored_spm_read_req_fifo_empty = is_empty;
  assign _axis_in_xored_spm_read_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axis_in_xored_spm_read_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axis_in_xored_spm_read_req_fifo_enq && !is_full) begin
        mem[head] <= _axis_in_xored_spm_read_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axis_in_xored_spm_read_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module ram_spm
(
  input CLK,
  input [9-1:0] ram_spm_0_addr,
  output [64-1:0] ram_spm_0_rdata,
  input [64-1:0] ram_spm_0_wdata,
  input ram_spm_0_wenable,
  input ram_spm_0_enable,
  input [9-1:0] ram_spm_1_addr,
  output [64-1:0] ram_spm_1_rdata,
  input [64-1:0] ram_spm_1_wdata,
  input ram_spm_1_wenable,
  input ram_spm_1_enable
);

  reg [64-1:0] ram_spm_0_rdata_out;
  assign ram_spm_0_rdata = ram_spm_0_rdata_out;
  reg [64-1:0] ram_spm_1_rdata_out;
  assign ram_spm_1_rdata = ram_spm_1_rdata_out;
  reg [64-1:0] mem [0:512-1];

  always @(posedge CLK) begin
    if(ram_spm_0_enable) begin
      if(ram_spm_0_wenable) begin
        mem[ram_spm_0_addr] <= ram_spm_0_wdata;
        ram_spm_0_rdata_out <= ram_spm_0_wdata;
      end else begin
        ram_spm_0_rdata_out <= mem[ram_spm_0_addr];
      end
    end 
  end


  always @(posedge CLK) begin
    if(ram_spm_1_enable) begin
      if(ram_spm_1_wenable) begin
        mem[ram_spm_1_addr] <= ram_spm_1_wdata;
        ram_spm_1_rdata_out <= ram_spm_1_wdata;
      end else begin
        ram_spm_1_rdata_out <= mem[ram_spm_1_addr];
      end
    end 
  end


endmodule

