

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
  wire [4-1:0] axi_m_dram_awid;
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
  wire [64-1:0] axi_m_dram_wdata;
  wire [8-1:0] axi_m_dram_wstrb;
  wire axi_m_dram_wlast;
  wire axi_m_dram_wvalid;
  reg axi_m_dram_wready;
  reg [4-1:0] axi_m_dram_bid;
  reg [2-1:0] axi_m_dram_bresp;
  reg axi_m_dram_bvalid;
  wire axi_m_dram_bready;
  wire [4-1:0] axi_m_dram_arid;
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
  reg [4-1:0] axi_m_dram_rid;
  reg [64-1:0] axi_m_dram_rdata;
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
  wire [64-1:0] memory_wdata;
  wire [8-1:0] memory_wstrb;
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
  reg [64-1:0] memory_rdata;
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
  wire [73-1:0] _memory_wdata_fifo_wdata;
  wire _memory_wdata_fifo_full;
  wire _memory_wdata_fifo_almost_full;
  wire _memory_wdata_fifo_deq;
  wire [73-1:0] _memory_wdata_fifo_rdata;
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
  wire [64-1:0] pack_write_data_wdata_52;
  wire [8-1:0] pack_write_data_wstrb_53;
  wire [1-1:0] pack_write_data_wlast_54;
  assign pack_write_data_wdata_52 = memory_wdata;
  assign pack_write_data_wstrb_53 = memory_wstrb;
  assign pack_write_data_wlast_54 = memory_wlast;
  wire [73-1:0] pack_write_data_packed_55;
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
  wire [64-1:0] pack_write_data_wdata_65;
  wire [8-1:0] pack_write_data_wstrb_66;
  wire [1-1:0] pack_write_data_wlast_67;
  assign pack_write_data_wdata_65 = _memory_wdata_fifo_rdata[63:0];
  assign pack_write_data_wstrb_66 = _memory_wdata_fifo_rdata[71:64];
  assign pack_write_data_wlast_67 = _memory_wdata_fifo_rdata[72];
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

  wire [4-1:0] _tmp_79;
  assign _tmp_79 = 0;

  always @(*) begin
    axi_m_dram_bid = _tmp_79;
  end

  wire [2-1:0] _tmp_80;
  assign _tmp_80 = memory_bresp;

  always @(*) begin
    axi_m_dram_bresp = _tmp_80;
  end

  wire _tmp_81;
  assign _tmp_81 = memory_bvalid;

  always @(*) begin
    axi_m_dram_bvalid = _tmp_81;
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
  wire _tmp_82;
  assign _tmp_82 = memory_arready;

  always @(*) begin
    axi_m_dram_arready = _tmp_82;
  end

  wire [4-1:0] _tmp_83;
  assign _tmp_83 = 0;

  always @(*) begin
    axi_m_dram_rid = _tmp_83;
  end

  wire [64-1:0] _tmp_84;
  assign _tmp_84 = memory_rdata;

  always @(*) begin
    axi_m_dram_rdata = _tmp_84;
  end

  wire [2-1:0] _tmp_85;
  assign _tmp_85 = memory_rresp;

  always @(*) begin
    axi_m_dram_rresp = _tmp_85;
  end

  wire _tmp_86;
  assign _tmp_86 = memory_rlast;

  always @(*) begin
    axi_m_dram_rlast = _tmp_86;
  end

  wire _tmp_87;
  assign _tmp_87 = memory_rvalid;

  always @(*) begin
    axi_m_dram_rvalid = _tmp_87;
  end

  assign memory_rready = axi_m_dram_rready;
  reg [128-1:0] write_data_88;
  reg [1-1:0] complete;
  reg [32-1:0] th_ctrl;
  localparam th_ctrl_init = 0;
  reg _maxi_spm_raddr_cond_0_1;
  reg signed [64-1:0] axim_rdata_89;
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
  reg signed [32-1:0] _th_ctrl_i_0;
  reg _m_axis_spm_cond_0_1;
  reg _maxi_spm_raddr_cond_1_1;
  reg signed [64-1:0] axim_rdata_90;
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
  reg signed [64-1:0] axim_rdata_91;
  assign _maxi_spm_rready_sb_0 = (th_ctrl == 4) || (th_ctrl == 48) || (th_ctrl == 86);
  reg [32-1:0] fsm;
  localparam fsm_init = 0;
  reg signed [32-1:0] rdata_92;
  reg signed [32-1:0] rdata_93;
  reg signed [32-1:0] rdata_94;
  reg signed [32-1:0] rdata_95;

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
    .axi_m_dram_awid(axi_m_dram_awid),
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
    .axi_m_dram_bid(axi_m_dram_bid),
    .axi_m_dram_bresp(axi_m_dram_bresp),
    .axi_m_dram_bvalid(axi_m_dram_bvalid),
    .axi_m_dram_bready(axi_m_dram_bready),
    .axi_m_dram_arid(axi_m_dram_arid),
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
    .axi_m_dram_rid(axi_m_dram_rid),
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
    write_data_88 = 0;
    complete = 0;
    th_ctrl = th_ctrl_init;
    _maxi_spm_raddr_cond_0_1 = 0;
    axim_rdata_89 = 0;
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
    _th_ctrl_i_0 = 0;
    _m_axis_spm_cond_0_1 = 0;
    _maxi_spm_raddr_cond_1_1 = 0;
    axim_rdata_90 = 0;
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
    axim_rdata_91 = 0;
    fsm = fsm_init;
    rdata_92 = 0;
    rdata_93 = 0;
    rdata_94 = 0;
    rdata_95 = 0;
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
        m_axis_spm_tdata <= write_data_88;
        m_axis_spm_tvalid <= 1;
        m_axis_spm_tlast <= _th_ctrl_i_0 == 3;
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
            _write_addr <= _write_addr + 8;
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
          if((_sleep_interval_count < 15) && (_read_count > 0) && memory_rready | !memory_rvalid) begin
            memory_rvalid <= 1;
            _read_addr <= _read_addr + 8;
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
      axim_rdata_89 <= 0;
      _th_ctrl_i_0 <= 0;
      write_data_88 <= 0;
      axim_rdata_90 <= 0;
      axim_rdata_91 <= 0;
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
            axim_rdata_89 <= _maxi_spm_rdata_sb_0;
          end 
          if(_maxi_spm_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_5;
          end 
        end
        th_ctrl_5: begin
          if(axim_rdata_89 == 0) begin
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
          $display("DMA Read from AXI Manager");
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
          _th_ctrl_i_0 <= 0;
          th_ctrl <= th_ctrl_40;
        end
        th_ctrl_40: begin
          if(_th_ctrl_i_0 < 4) begin
            th_ctrl <= th_ctrl_41;
          end else begin
            th_ctrl <= th_ctrl_45;
          end
        end
        th_ctrl_41: begin
          write_data_88 <= _th_ctrl_i_0 + 4096 + (_th_ctrl_i_0 << 32) + (_th_ctrl_i_0 << 64) + (_th_ctrl_i_0 << 96);
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
          _th_ctrl_i_0 <= _th_ctrl_i_0 + 1;
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
            axim_rdata_90 <= _maxi_spm_rdata_sb_0;
          end 
          if(_maxi_spm_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_49;
          end 
        end
        th_ctrl_49: begin
          if(axim_rdata_90 == 0) begin
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
          $display("DMA Write to DRAM");
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
            axim_rdata_91 <= _maxi_spm_rdata_sb_0;
          end 
          if(_maxi_spm_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_87;
          end 
        end
        th_ctrl_87: begin
          if(axim_rdata_91 == 0) begin
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
          $display("DMA Write to DRAM completed");
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
      rdata_92 <= 0;
      rdata_93 <= 0;
      rdata_94 <= 0;
      rdata_95 <= 0;
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
            rdata_92 <= { _memory_mem[4099], _memory_mem[4098], _memory_mem[4097], _memory_mem[4096] };
          end 
          fsm <= fsm_3;
        end
        fsm_3: begin
          $display("memory[0x1000] = %x", rdata_92);
          if(fsm == 3) begin
            rdata_93 <= { _memory_mem[4103], _memory_mem[4102], _memory_mem[4101], _memory_mem[4100] };
          end 
          fsm <= fsm_4;
        end
        fsm_4: begin
          $display("memory[0x1004] = %x", rdata_93);
          if(fsm == 4) begin
            rdata_94 <= { _memory_mem[4107], _memory_mem[4106], _memory_mem[4105], _memory_mem[4104] };
          end 
          fsm <= fsm_5;
        end
        fsm_5: begin
          $display("memory[0x1008] = %x", rdata_94);
          if(fsm == 5) begin
            rdata_95 <= { _memory_mem[4159], _memory_mem[4158], _memory_mem[4157], _memory_mem[4156] };
          end 
          fsm <= fsm_6;
        end
        fsm_6: begin
          $display("memory[0x100c] = %x", rdata_95);
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
  input [73-1:0] _memory_wdata_fifo_wdata,
  output _memory_wdata_fifo_full,
  output _memory_wdata_fifo_almost_full,
  input _memory_wdata_fifo_deq,
  output [73-1:0] _memory_wdata_fifo_rdata,
  output _memory_wdata_fifo_empty,
  output _memory_wdata_fifo_almost_empty
);

  reg [73-1:0] mem [0:8-1];
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
  wire [73-1:0] rdata;
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
  output [64-1:0] axi_m_dram_wdata,
  output [8-1:0] axi_m_dram_wstrb,
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
  input [64-1:0] axi_m_dram_rdata,
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
  assign axi_m_dram_awsize = 3;
  assign axi_m_dram_awburst = 1;
  assign axi_m_dram_awlock = 0;
  assign axi_m_dram_awcache = 3;
  assign axi_m_dram_awprot = 0;
  assign axi_m_dram_awqos = 0;
  assign axi_m_dram_awuser = 0;
  reg [64-1:0] _axi_m_dram_wdata_sb_0;
  reg [8-1:0] _axi_m_dram_wstrb_sb_0;
  reg _axi_m_dram_wlast_sb_0;
  reg _axi_m_dram_wvalid_sb_0;
  wire _axi_m_dram_wready_sb_0;
  wire _sb_axi_m_dram_writedata_s_value_9;
  assign _sb_axi_m_dram_writedata_s_value_9 = _axi_m_dram_wlast_sb_0;
  wire [8-1:0] _sb_axi_m_dram_writedata_s_value_10;
  assign _sb_axi_m_dram_writedata_s_value_10 = _axi_m_dram_wstrb_sb_0;
  wire [64-1:0] _sb_axi_m_dram_writedata_s_value_11;
  assign _sb_axi_m_dram_writedata_s_value_11 = _axi_m_dram_wdata_sb_0;
  wire [73-1:0] _sb_axi_m_dram_writedata_s_data_12;
  assign _sb_axi_m_dram_writedata_s_data_12 = { _sb_axi_m_dram_writedata_s_value_9, _sb_axi_m_dram_writedata_s_value_10, _sb_axi_m_dram_writedata_s_value_11 };
  wire _sb_axi_m_dram_writedata_s_valid_13;
  assign _sb_axi_m_dram_writedata_s_valid_13 = _axi_m_dram_wvalid_sb_0;
  wire _sb_axi_m_dram_writedata_m_ready_14;
  assign _sb_axi_m_dram_writedata_m_ready_14 = axi_m_dram_wready;
  reg [73-1:0] _sb_axi_m_dram_writedata_data_15;
  reg _sb_axi_m_dram_writedata_valid_16;
  wire _sb_axi_m_dram_writedata_ready_17;
  reg [73-1:0] _sb_axi_m_dram_writedata_tmp_data_18;
  reg _sb_axi_m_dram_writedata_tmp_valid_19;
  wire [73-1:0] _sb_axi_m_dram_writedata_next_data_20;
  wire _sb_axi_m_dram_writedata_next_valid_21;
  assign _sb_axi_m_dram_writedata_ready_17 = !_sb_axi_m_dram_writedata_tmp_valid_19;
  assign _sb_axi_m_dram_writedata_next_data_20 = (_sb_axi_m_dram_writedata_tmp_valid_19)? _sb_axi_m_dram_writedata_tmp_data_18 : _sb_axi_m_dram_writedata_s_data_12;
  assign _sb_axi_m_dram_writedata_next_valid_21 = _sb_axi_m_dram_writedata_tmp_valid_19 || _sb_axi_m_dram_writedata_s_valid_13;
  wire _sb_axi_m_dram_writedata_m_value_22;
  assign _sb_axi_m_dram_writedata_m_value_22 = _sb_axi_m_dram_writedata_data_15[72:72];
  wire [8-1:0] _sb_axi_m_dram_writedata_m_value_23;
  assign _sb_axi_m_dram_writedata_m_value_23 = _sb_axi_m_dram_writedata_data_15[71:64];
  wire [64-1:0] _sb_axi_m_dram_writedata_m_value_24;
  assign _sb_axi_m_dram_writedata_m_value_24 = _sb_axi_m_dram_writedata_data_15[63:0];
  assign _axi_m_dram_wready_sb_0 = _sb_axi_m_dram_writedata_ready_17;
  assign axi_m_dram_wdata = _sb_axi_m_dram_writedata_m_value_24;
  assign axi_m_dram_wstrb = _sb_axi_m_dram_writedata_m_value_23;
  assign axi_m_dram_wlast = _sb_axi_m_dram_writedata_m_value_22;
  assign axi_m_dram_wvalid = _sb_axi_m_dram_writedata_valid_16;
  assign axi_m_dram_bready = 1;
  assign axi_m_dram_arsize = 3;
  assign axi_m_dram_arburst = 1;
  assign axi_m_dram_arlock = 0;
  assign axi_m_dram_arcache = 3;
  assign axi_m_dram_arprot = 0;
  assign axi_m_dram_arqos = 0;
  assign axi_m_dram_aruser = 0;
  wire [64-1:0] _axi_m_dram_rdata_sb_0;
  wire _axi_m_dram_rlast_sb_0;
  wire _axi_m_dram_rvalid_sb_0;
  wire _axi_m_dram_rready_sb_0;
  wire _sb_axi_m_dram_readdata_s_value_25;
  assign _sb_axi_m_dram_readdata_s_value_25 = axi_m_dram_rlast;
  wire [64-1:0] _sb_axi_m_dram_readdata_s_value_26;
  assign _sb_axi_m_dram_readdata_s_value_26 = axi_m_dram_rdata;
  wire [65-1:0] _sb_axi_m_dram_readdata_s_data_27;
  assign _sb_axi_m_dram_readdata_s_data_27 = { _sb_axi_m_dram_readdata_s_value_25, _sb_axi_m_dram_readdata_s_value_26 };
  wire _sb_axi_m_dram_readdata_s_valid_28;
  assign _sb_axi_m_dram_readdata_s_valid_28 = axi_m_dram_rvalid;
  wire _sb_axi_m_dram_readdata_m_ready_29;
  assign _sb_axi_m_dram_readdata_m_ready_29 = _axi_m_dram_rready_sb_0;
  reg [65-1:0] _sb_axi_m_dram_readdata_data_30;
  reg _sb_axi_m_dram_readdata_valid_31;
  wire _sb_axi_m_dram_readdata_ready_32;
  reg [65-1:0] _sb_axi_m_dram_readdata_tmp_data_33;
  reg _sb_axi_m_dram_readdata_tmp_valid_34;
  wire [65-1:0] _sb_axi_m_dram_readdata_next_data_35;
  wire _sb_axi_m_dram_readdata_next_valid_36;
  assign _sb_axi_m_dram_readdata_ready_32 = !_sb_axi_m_dram_readdata_tmp_valid_34;
  assign _sb_axi_m_dram_readdata_next_data_35 = (_sb_axi_m_dram_readdata_tmp_valid_34)? _sb_axi_m_dram_readdata_tmp_data_33 : _sb_axi_m_dram_readdata_s_data_27;
  assign _sb_axi_m_dram_readdata_next_valid_36 = _sb_axi_m_dram_readdata_tmp_valid_34 || _sb_axi_m_dram_readdata_s_valid_28;
  wire _sb_axi_m_dram_readdata_m_value_37;
  assign _sb_axi_m_dram_readdata_m_value_37 = _sb_axi_m_dram_readdata_data_30[64:64];
  wire [64-1:0] _sb_axi_m_dram_readdata_m_value_38;
  assign _sb_axi_m_dram_readdata_m_value_38 = _sb_axi_m_dram_readdata_data_30[63:0];
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
  assign mask_addr_shifted_77 = dram_addr_69 >> 3;
  wire [32-1:0] mask_addr_masked_78;
  assign mask_addr_masked_78 = mask_addr_shifted_77 << 3;
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
  assign mask_addr_shifted_87 = _axi_m_dram_read_global_addr >> 3;
  wire [32-1:0] mask_addr_masked_88;
  assign mask_addr_masked_88 = mask_addr_shifted_87 << 3;
  wire [32-1:0] mask_addr_shifted_89;
  assign mask_addr_shifted_89 = _axi_m_dram_read_global_addr >> 3;
  wire [32-1:0] mask_addr_masked_90;
  assign mask_addr_masked_90 = mask_addr_shifted_89 << 3;
  wire [32-1:0] mask_addr_shifted_91;
  assign mask_addr_shifted_91 = _axi_m_dram_read_global_addr >> 3;
  wire [32-1:0] mask_addr_masked_92;
  assign mask_addr_masked_92 = mask_addr_shifted_91 << 3;
  wire [32-1:0] mask_addr_shifted_93;
  assign mask_addr_shifted_93 = _axi_m_dram_read_global_addr >> 3;
  wire [32-1:0] mask_addr_masked_94;
  assign mask_addr_masked_94 = mask_addr_shifted_93 << 3;
  wire [32-1:0] mask_addr_shifted_95;
  assign mask_addr_shifted_95 = _axi_m_dram_read_global_addr >> 3;
  wire [32-1:0] mask_addr_masked_96;
  assign mask_addr_masked_96 = mask_addr_shifted_95 << 3;
  wire [32-1:0] mask_addr_shifted_97;
  assign mask_addr_shifted_97 = _axi_m_dram_read_global_addr >> 3;
  wire [32-1:0] mask_addr_masked_98;
  assign mask_addr_masked_98 = mask_addr_shifted_97 << 3;
  reg _axi_m_dram_raddr_cond_0_1;
  reg [32-1:0] _axi_m_dram_read_data_fsm;
  localparam _axi_m_dram_read_data_fsm_init = 0;
  assign _axi_m_dram_read_req_fifo_deq = ((_axi_m_dram_read_data_fsm == 0) && (!_axi_m_dram_read_data_busy && !_axi_m_dram_read_req_fifo_empty && (_axi_m_dram_read_op_sel_fifo == 1)) && !_axi_m_dram_read_req_fifo_empty)? 1 : 0;
  reg [32-1:0] write_burst_fsm_0;
  localparam write_burst_fsm_0_init = 0;
  reg [9-1:0] write_burst_addr_99;
  reg [9-1:0] write_burst_stride_100;
  reg [33-1:0] write_burst_length_101;
  reg write_burst_done_102;
  assign _axi_m_dram_rready_sb_0 = _axi_m_dram_read_data_fsm == 2;
  wire [32-1:0] mask_addr_shifted_103;
  assign mask_addr_shifted_103 = dram_addr_69 >> 3;
  wire [32-1:0] mask_addr_masked_104;
  assign mask_addr_masked_104 = mask_addr_shifted_103 << 3;
  reg [32-1:0] _axi_m_dram_write_req_fsm;
  localparam _axi_m_dram_write_req_fsm_init = 0;
  reg [33-1:0] _axi_m_dram_write_cur_global_size;
  reg _axi_m_dram_write_cont;
  wire [8-1:0] pack_write_req_op_sel_105;
  wire [32-1:0] pack_write_req_local_addr_106;
  wire [32-1:0] pack_write_req_local_stride_107;
  wire [33-1:0] pack_write_req_size_108;
  wire [32-1:0] pack_write_req_local_blocksize_109;
  assign pack_write_req_op_sel_105 = _axi_m_dram_write_op_sel;
  assign pack_write_req_local_addr_106 = _axi_m_dram_write_local_addr;
  assign pack_write_req_local_stride_107 = _axi_m_dram_write_local_stride;
  assign pack_write_req_size_108 = _axi_m_dram_write_local_size;
  assign pack_write_req_local_blocksize_109 = _axi_m_dram_write_local_blocksize;
  wire [137-1:0] pack_write_req_packed_110;
  assign pack_write_req_packed_110 = { pack_write_req_op_sel_105, pack_write_req_local_addr_106, pack_write_req_local_stride_107, pack_write_req_size_108, pack_write_req_local_blocksize_109 };
  localparam _tmp_111 = 1;
  wire [_tmp_111-1:0] _tmp_112;
  assign _tmp_112 = !_axi_m_dram_write_req_fifo_almost_full;
  reg [_tmp_111-1:0] __tmp_112_1;
  wire [32-1:0] mask_addr_shifted_113;
  assign mask_addr_shifted_113 = _axi_m_dram_write_global_addr >> 3;
  wire [32-1:0] mask_addr_masked_114;
  assign mask_addr_masked_114 = mask_addr_shifted_113 << 3;
  wire [32-1:0] mask_addr_shifted_115;
  assign mask_addr_shifted_115 = _axi_m_dram_write_global_addr >> 3;
  wire [32-1:0] mask_addr_masked_116;
  assign mask_addr_masked_116 = mask_addr_shifted_115 << 3;
  wire [32-1:0] mask_addr_shifted_117;
  assign mask_addr_shifted_117 = _axi_m_dram_write_global_addr >> 3;
  wire [32-1:0] mask_addr_masked_118;
  assign mask_addr_masked_118 = mask_addr_shifted_117 << 3;
  wire [32-1:0] mask_addr_shifted_119;
  assign mask_addr_shifted_119 = _axi_m_dram_write_global_addr >> 3;
  wire [32-1:0] mask_addr_masked_120;
  assign mask_addr_masked_120 = mask_addr_shifted_119 << 3;
  wire [32-1:0] mask_addr_shifted_121;
  assign mask_addr_shifted_121 = _axi_m_dram_write_global_addr >> 3;
  wire [32-1:0] mask_addr_masked_122;
  assign mask_addr_masked_122 = mask_addr_shifted_121 << 3;
  wire [32-1:0] mask_addr_shifted_123;
  assign mask_addr_shifted_123 = _axi_m_dram_write_global_addr >> 3;
  wire [32-1:0] mask_addr_masked_124;
  assign mask_addr_masked_124 = mask_addr_shifted_123 << 3;
  wire [8-1:0] pack_write_req_op_sel_125;
  wire [32-1:0] pack_write_req_local_addr_126;
  wire [32-1:0] pack_write_req_local_stride_127;
  wire [33-1:0] pack_write_req_size_128;
  wire [32-1:0] pack_write_req_local_blocksize_129;
  assign pack_write_req_op_sel_125 = _axi_m_dram_write_op_sel;
  assign pack_write_req_local_addr_126 = _axi_m_dram_write_local_addr;
  assign pack_write_req_local_stride_127 = _axi_m_dram_write_local_stride;
  assign pack_write_req_size_128 = _axi_m_dram_write_cur_global_size;
  assign pack_write_req_local_blocksize_129 = _axi_m_dram_write_local_blocksize;
  wire [137-1:0] pack_write_req_packed_130;
  assign pack_write_req_packed_130 = { pack_write_req_op_sel_125, pack_write_req_local_addr_126, pack_write_req_local_stride_127, pack_write_req_size_128, pack_write_req_local_blocksize_129 };
  assign _axi_m_dram_write_req_fifo_wdata = ((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (axi_m_dram_awready || !axi_m_dram_awvalid) && (_axi_m_dram_outstanding_wcount < 6))? pack_write_req_packed_130 : 
                                            ((_axi_m_dram_write_req_fsm == 0) && _axi_m_dram_write_start && !_axi_m_dram_write_req_fifo_almost_full)? pack_write_req_packed_110 : 'hx;
  assign _axi_m_dram_write_req_fifo_enq = ((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (axi_m_dram_awready || !axi_m_dram_awvalid) && (_axi_m_dram_outstanding_wcount < 6))? (_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (axi_m_dram_awready || !axi_m_dram_awvalid) && (_axi_m_dram_outstanding_wcount < 6) && !_axi_m_dram_write_req_fifo_almost_full : 
                                          ((_axi_m_dram_write_req_fsm == 0) && _axi_m_dram_write_start && !_axi_m_dram_write_req_fifo_almost_full)? (_axi_m_dram_write_req_fsm == 0) && _axi_m_dram_write_start && !_axi_m_dram_write_req_fifo_almost_full && !_axi_m_dram_write_req_fifo_almost_full : 0;
  localparam _tmp_131 = 1;
  wire [_tmp_131-1:0] _tmp_132;
  assign _tmp_132 = !_axi_m_dram_write_req_fifo_almost_full;
  reg [_tmp_131-1:0] __tmp_132_1;
  reg _axi_m_dram_waddr_cond_0_1;
  reg [32-1:0] _axi_m_dram_write_data_fsm;
  localparam _axi_m_dram_write_data_fsm_init = 0;
  reg [32-1:0] read_burst_fsm_1;
  localparam read_burst_fsm_1_init = 0;
  reg [9-1:0] read_burst_addr_133;
  reg [9-1:0] read_burst_stride_134;
  reg [33-1:0] read_burst_length_135;
  reg read_burst_rvalid_136;
  reg read_burst_rlast_137;
  localparam _tmp_138 = 1;
  wire [_tmp_138-1:0] _tmp_139;
  assign _tmp_139 = (read_burst_fsm_1 == 1) && (!read_burst_rvalid_136 || (_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0) && (_axi_m_dram_write_size_buf > 0));
  reg [_tmp_138-1:0] __tmp_139_1;
  wire [64-1:0] read_burst_rdata_140;
  assign read_burst_rdata_140 = ram_spm_0_rdata;
  assign _axi_m_dram_write_req_fifo_deq = ((_axi_m_dram_write_data_fsm == 2) && (!_axi_m_dram_write_req_fifo_empty && (_axi_m_dram_write_size_buf == 0)) && !_axi_m_dram_write_req_fifo_empty)? 1 : 
                                          ((_axi_m_dram_write_data_fsm == 0) && (!_axi_m_dram_write_data_busy && !_axi_m_dram_write_req_fifo_empty && (_axi_m_dram_write_op_sel_fifo == 1)) && !_axi_m_dram_write_req_fifo_empty)? 1 : 0;
  reg _axi_m_dram_wdata_cond_0_1;
  wire [8-1:0] pack_write_req_op_sel_141;
  wire [32-1:0] pack_write_req_local_addr_142;
  wire [32-1:0] pack_write_req_local_stride_143;
  wire [33-1:0] pack_write_req_local_size_144;
  assign pack_write_req_op_sel_141 = 1;
  assign pack_write_req_local_addr_142 = spm_addr_70 >>> 3;
  assign pack_write_req_local_stride_143 = 1;
  assign pack_write_req_local_size_144 = 8;
  wire [105-1:0] pack_write_req_packed_145;
  assign pack_write_req_packed_145 = { pack_write_req_op_sel_141, pack_write_req_local_addr_142, pack_write_req_local_stride_143, pack_write_req_local_size_144 };
  assign _axis_out_mac_spm_write_req_fifo_wdata = ((spm_thread == 19) && !_axis_out_mac_spm_write_req_fifo_almost_full)? pack_write_req_packed_145 : 'hx;
  assign _axis_out_mac_spm_write_req_fifo_enq = ((spm_thread == 19) && !_axis_out_mac_spm_write_req_fifo_almost_full)? (spm_thread == 19) && !_axis_out_mac_spm_write_req_fifo_almost_full && !_axis_out_mac_spm_write_req_fifo_almost_full : 0;
  localparam _tmp_146 = 1;
  wire [_tmp_146-1:0] _tmp_147;
  assign _tmp_147 = !_axis_out_mac_spm_write_req_fifo_almost_full;
  reg [_tmp_146-1:0] __tmp_147_1;
  reg [32-1:0] _axis_out_mac_spm_write_data_wide_fsm;
  localparam _axis_out_mac_spm_write_data_wide_fsm_init = 0;
  assign _axis_out_mac_spm_write_req_fifo_deq = ((_axis_out_mac_spm_write_data_wide_fsm == 0) && (!_axis_out_mac_spm_write_data_busy && !_axis_out_mac_spm_write_req_fifo_empty && (_axis_out_mac_spm_write_op_sel_fifo == 1)) && !_axis_out_mac_spm_write_req_fifo_empty)? 1 : 0;
  reg [1-1:0] _axis_out_mac_spm_write_wide_count_148;
  reg [32-1:0] read_burst_fsm_2;
  localparam read_burst_fsm_2_init = 0;
  reg [9-1:0] read_burst_addr_149;
  reg [9-1:0] read_burst_stride_150;
  reg [33-1:0] read_burst_length_151;
  reg read_burst_rvalid_152;
  reg read_burst_rlast_153;
  localparam _tmp_154 = 1;
  wire [_tmp_154-1:0] _tmp_155;
  assign _tmp_155 = (read_burst_fsm_2 == 1) && (!read_burst_rvalid_152 || (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_148 > 0)));
  reg [_tmp_154-1:0] __tmp_155_1;
  wire [64-1:0] read_burst_rdata_156;
  assign read_burst_rdata_156 = ram_spm_0_rdata;
  reg [128-1:0] _axis_out_mac_spm_write_wide_wdata_157;
  reg _axis_out_mac_spm_cond_0_1;
  wire [8-1:0] pack_read_req_op_sel_158;
  wire [32-1:0] pack_read_req_local_addr_159;
  wire [32-1:0] pack_read_req_local_stride_160;
  wire [33-1:0] pack_read_req_local_size_161;
  assign pack_read_req_op_sel_158 = 1;
  assign pack_read_req_local_addr_159 = spm_addr_70 >>> 3;
  assign pack_read_req_local_stride_160 = 1;
  assign pack_read_req_local_size_161 = 8;
  wire [105-1:0] pack_read_req_packed_162;
  assign pack_read_req_packed_162 = { pack_read_req_op_sel_158, pack_read_req_local_addr_159, pack_read_req_local_stride_160, pack_read_req_local_size_161 };
  assign _axis_in_axim_spm_read_req_fifo_wdata = ((spm_thread == 24) && !_axis_in_axim_spm_read_req_fifo_almost_full)? pack_read_req_packed_162 : 'hx;
  assign _axis_in_axim_spm_read_req_fifo_enq = ((spm_thread == 24) && !_axis_in_axim_spm_read_req_fifo_almost_full)? (spm_thread == 24) && !_axis_in_axim_spm_read_req_fifo_almost_full && !_axis_in_axim_spm_read_req_fifo_almost_full : 0;
  localparam _tmp_163 = 1;
  wire [_tmp_163-1:0] _tmp_164;
  assign _tmp_164 = !_axis_in_axim_spm_read_req_fifo_almost_full;
  reg [_tmp_163-1:0] __tmp_164_1;
  reg [32-1:0] _axis_in_axim_spm_read_data_wide_fsm;
  localparam _axis_in_axim_spm_read_data_wide_fsm_init = 0;
  assign _axis_in_axim_spm_read_req_fifo_deq = ((_axis_in_axim_spm_read_data_wide_fsm == 0) && (!_axis_in_axim_spm_read_data_busy && !_axis_in_axim_spm_read_req_fifo_empty && (_axis_in_axim_spm_read_op_sel_fifo == 1)) && !_axis_in_axim_spm_read_req_fifo_empty)? 1 : 0;
  reg [128-1:0] _axis_in_axim_spm_read_wide_wdata_165;
  reg _axis_in_axim_spm_read_wide_wvalid_166;
  reg [1-1:0] _axis_in_axim_spm_read_wide_count_167;
  reg [32-1:0] write_burst_fsm_3;
  localparam write_burst_fsm_3_init = 0;
  reg [9-1:0] write_burst_addr_168;
  reg [9-1:0] write_burst_stride_169;
  reg [33-1:0] write_burst_length_170;
  reg write_burst_done_171;
  assign axis_in_axim_spm_tready = (_axis_in_axim_spm_read_data_wide_fsm == 2) && (_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_wide_count_167 == 0);
  wire [8-1:0] pack_write_req_op_sel_172;
  wire [32-1:0] pack_write_req_local_addr_173;
  wire [32-1:0] pack_write_req_local_stride_174;
  wire [33-1:0] pack_write_req_local_size_175;
  assign pack_write_req_op_sel_172 = 1;
  assign pack_write_req_local_addr_173 = spm_addr_70 >>> 3;
  assign pack_write_req_local_stride_174 = 1;
  assign pack_write_req_local_size_175 = 8;
  wire [105-1:0] pack_write_req_packed_176;
  assign pack_write_req_packed_176 = { pack_write_req_op_sel_172, pack_write_req_local_addr_173, pack_write_req_local_stride_174, pack_write_req_local_size_175 };
  assign _axis_out_axim_spm_write_req_fifo_wdata = ((spm_thread == 26) && !_axis_out_axim_spm_write_req_fifo_almost_full)? pack_write_req_packed_176 : 'hx;
  assign _axis_out_axim_spm_write_req_fifo_enq = ((spm_thread == 26) && !_axis_out_axim_spm_write_req_fifo_almost_full)? (spm_thread == 26) && !_axis_out_axim_spm_write_req_fifo_almost_full && !_axis_out_axim_spm_write_req_fifo_almost_full : 0;
  localparam _tmp_177 = 1;
  wire [_tmp_177-1:0] _tmp_178;
  assign _tmp_178 = !_axis_out_axim_spm_write_req_fifo_almost_full;
  reg [_tmp_177-1:0] __tmp_178_1;
  reg [32-1:0] _axis_out_axim_spm_write_data_wide_fsm;
  localparam _axis_out_axim_spm_write_data_wide_fsm_init = 0;
  assign _axis_out_axim_spm_write_req_fifo_deq = ((_axis_out_axim_spm_write_data_wide_fsm == 0) && (!_axis_out_axim_spm_write_data_busy && !_axis_out_axim_spm_write_req_fifo_empty && (_axis_out_axim_spm_write_op_sel_fifo == 1)) && !_axis_out_axim_spm_write_req_fifo_empty)? 1 : 0;
  reg [1-1:0] _axis_out_axim_spm_write_wide_count_179;
  reg [32-1:0] read_burst_fsm_4;
  localparam read_burst_fsm_4_init = 0;
  reg [9-1:0] read_burst_addr_180;
  reg [9-1:0] read_burst_stride_181;
  reg [33-1:0] read_burst_length_182;
  reg read_burst_rvalid_183;
  reg read_burst_rlast_184;
  localparam _tmp_185 = 1;
  wire [_tmp_185-1:0] _tmp_186;
  assign _tmp_186 = (read_burst_fsm_4 == 1) && (!read_burst_rvalid_183 || (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_179 > 0)));
  reg [_tmp_185-1:0] __tmp_186_1;
  wire [64-1:0] read_burst_rdata_187;
  assign read_burst_rdata_187 = ram_spm_0_rdata;
  reg [128-1:0] _axis_out_axim_spm_write_wide_wdata_188;
  reg _axis_out_axim_spm_cond_0_1;
  wire [8-1:0] pack_read_req_op_sel_189;
  wire [32-1:0] pack_read_req_local_addr_190;
  wire [32-1:0] pack_read_req_local_stride_191;
  wire [33-1:0] pack_read_req_local_size_192;
  assign pack_read_req_op_sel_189 = 1;
  assign pack_read_req_local_addr_190 = spm_addr_70 >>> 3;
  assign pack_read_req_local_stride_191 = 1;
  assign pack_read_req_local_size_192 = 8;
  wire [105-1:0] pack_read_req_packed_193;
  assign pack_read_req_packed_193 = { pack_read_req_op_sel_189, pack_read_req_local_addr_190, pack_read_req_local_stride_191, pack_read_req_local_size_192 };
  assign _axis_in_xored_spm_read_req_fifo_wdata = ((spm_thread == 30) && !_axis_in_xored_spm_read_req_fifo_almost_full)? pack_read_req_packed_193 : 'hx;
  assign _axis_in_xored_spm_read_req_fifo_enq = ((spm_thread == 30) && !_axis_in_xored_spm_read_req_fifo_almost_full)? (spm_thread == 30) && !_axis_in_xored_spm_read_req_fifo_almost_full && !_axis_in_xored_spm_read_req_fifo_almost_full : 0;
  localparam _tmp_194 = 1;
  wire [_tmp_194-1:0] _tmp_195;
  assign _tmp_195 = !_axis_in_xored_spm_read_req_fifo_almost_full;
  reg [_tmp_194-1:0] __tmp_195_1;
  reg [32-1:0] _axis_in_xored_spm_read_data_wide_fsm;
  localparam _axis_in_xored_spm_read_data_wide_fsm_init = 0;
  assign _axis_in_xored_spm_read_req_fifo_deq = ((_axis_in_xored_spm_read_data_wide_fsm == 0) && (!_axis_in_xored_spm_read_data_busy && !_axis_in_xored_spm_read_req_fifo_empty && (_axis_in_xored_spm_read_op_sel_fifo == 1)) && !_axis_in_xored_spm_read_req_fifo_empty)? 1 : 0;
  reg [128-1:0] _axis_in_xored_spm_read_wide_wdata_196;
  reg _axis_in_xored_spm_read_wide_wvalid_197;
  reg [1-1:0] _axis_in_xored_spm_read_wide_count_198;
  reg [32-1:0] write_burst_fsm_5;
  localparam write_burst_fsm_5_init = 0;
  reg [9-1:0] write_burst_addr_199;
  reg [9-1:0] write_burst_stride_200;
  reg [33-1:0] write_burst_length_201;
  reg write_burst_done_202;
  assign ram_spm_0_wdata = ((write_burst_fsm_5 == 1) && _axis_in_xored_spm_read_wide_wvalid_197)? _axis_in_xored_spm_read_wide_wdata_196[63:0] : 
                           ((write_burst_fsm_3 == 1) && _axis_in_axim_spm_read_wide_wvalid_166)? _axis_in_axim_spm_read_wide_wdata_165[63:0] : 
                           ((write_burst_fsm_0 == 1) && _axi_m_dram_rvalid_sb_0)? _axi_m_dram_rdata_sb_0 : 'hx;
  assign ram_spm_0_wenable = ((write_burst_fsm_5 == 1) && _axis_in_xored_spm_read_wide_wvalid_197)? 1'd1 : 
                             ((write_burst_fsm_3 == 1) && _axis_in_axim_spm_read_wide_wvalid_166)? 1'd1 : 
                             ((write_burst_fsm_0 == 1) && _axi_m_dram_rvalid_sb_0)? 1'd1 : 0;
  assign axis_in_xored_spm_tready = (_axis_in_xored_spm_read_data_wide_fsm == 2) && (_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_wide_count_198 == 0);
  wire [8-1:0] pack_write_req_op_sel_203;
  wire [32-1:0] pack_write_req_local_addr_204;
  wire [32-1:0] pack_write_req_local_stride_205;
  wire [33-1:0] pack_write_req_local_size_206;
  assign pack_write_req_op_sel_203 = 1;
  assign pack_write_req_local_addr_204 = spm_addr_70 >>> 3;
  assign pack_write_req_local_stride_205 = 1;
  assign pack_write_req_local_size_206 = 8;
  wire [105-1:0] pack_write_req_packed_207;
  assign pack_write_req_packed_207 = { pack_write_req_op_sel_203, pack_write_req_local_addr_204, pack_write_req_local_stride_205, pack_write_req_local_size_206 };
  assign _axis_out_xored_spm_write_req_fifo_wdata = ((spm_thread == 33) && !_axis_out_xored_spm_write_req_fifo_almost_full)? pack_write_req_packed_207 : 'hx;
  assign _axis_out_xored_spm_write_req_fifo_enq = ((spm_thread == 33) && !_axis_out_xored_spm_write_req_fifo_almost_full)? (spm_thread == 33) && !_axis_out_xored_spm_write_req_fifo_almost_full && !_axis_out_xored_spm_write_req_fifo_almost_full : 0;
  localparam _tmp_208 = 1;
  wire [_tmp_208-1:0] _tmp_209;
  assign _tmp_209 = !_axis_out_xored_spm_write_req_fifo_almost_full;
  reg [_tmp_208-1:0] __tmp_209_1;
  reg [32-1:0] _axis_out_xored_spm_write_data_wide_fsm;
  localparam _axis_out_xored_spm_write_data_wide_fsm_init = 0;
  assign _axis_out_xored_spm_write_req_fifo_deq = ((_axis_out_xored_spm_write_data_wide_fsm == 0) && (!_axis_out_xored_spm_write_data_busy && !_axis_out_xored_spm_write_req_fifo_empty && (_axis_out_xored_spm_write_op_sel_fifo == 1)) && !_axis_out_xored_spm_write_req_fifo_empty)? 1 : 0;
  reg [1-1:0] _axis_out_xored_spm_write_wide_count_210;
  reg [32-1:0] read_burst_fsm_6;
  localparam read_burst_fsm_6_init = 0;
  reg [9-1:0] read_burst_addr_211;
  reg [9-1:0] read_burst_stride_212;
  reg [33-1:0] read_burst_length_213;
  reg read_burst_rvalid_214;
  reg read_burst_rlast_215;
  assign ram_spm_0_addr = ((read_burst_fsm_6 == 1) && (!read_burst_rvalid_214 || (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_210 > 0))))? read_burst_addr_211 : 
                          ((write_burst_fsm_5 == 1) && _axis_in_xored_spm_read_wide_wvalid_197)? write_burst_addr_199 : 
                          ((read_burst_fsm_4 == 1) && (!read_burst_rvalid_183 || (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_179 > 0))))? read_burst_addr_180 : 
                          ((write_burst_fsm_3 == 1) && _axis_in_axim_spm_read_wide_wvalid_166)? write_burst_addr_168 : 
                          ((read_burst_fsm_2 == 1) && (!read_burst_rvalid_152 || (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_148 > 0))))? read_burst_addr_149 : 
                          ((read_burst_fsm_1 == 1) && (!read_burst_rvalid_136 || (_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0) && (_axi_m_dram_write_size_buf > 0)))? read_burst_addr_133 : 
                          ((write_burst_fsm_0 == 1) && _axi_m_dram_rvalid_sb_0)? write_burst_addr_99 : 'hx;
  assign ram_spm_0_enable = ((read_burst_fsm_6 == 1) && (!read_burst_rvalid_214 || (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_210 > 0))))? 1'd1 : 
                            ((write_burst_fsm_5 == 1) && _axis_in_xored_spm_read_wide_wvalid_197)? 1'd1 : 
                            ((read_burst_fsm_4 == 1) && (!read_burst_rvalid_183 || (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_179 > 0))))? 1'd1 : 
                            ((write_burst_fsm_3 == 1) && _axis_in_axim_spm_read_wide_wvalid_166)? 1'd1 : 
                            ((read_burst_fsm_2 == 1) && (!read_burst_rvalid_152 || (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_148 > 0))))? 1'd1 : 
                            ((read_burst_fsm_1 == 1) && (!read_burst_rvalid_136 || (_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0) && (_axi_m_dram_write_size_buf > 0)))? 1'd1 : 
                            ((write_burst_fsm_0 == 1) && _axi_m_dram_rvalid_sb_0)? 1'd1 : 0;
  localparam _tmp_216 = 1;
  wire [_tmp_216-1:0] _tmp_217;
  assign _tmp_217 = (read_burst_fsm_6 == 1) && (!read_burst_rvalid_214 || (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_210 > 0)));
  reg [_tmp_216-1:0] __tmp_217_1;
  wire [64-1:0] read_burst_rdata_218;
  assign read_burst_rdata_218 = ram_spm_0_rdata;
  reg [128-1:0] _axis_out_xored_spm_write_wide_wdata_219;
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
      if((spm_thread == 35) && 0) begin
        _axi_s_ctrl_spm_register_0 <= 0;
        _axi_s_ctrl_spm_flag_0 <= 0;
      end 
      if((spm_thread == 35) && 0) begin
        _axi_s_ctrl_spm_register_1 <= 0;
        _axi_s_ctrl_spm_flag_1 <= 0;
      end 
      if((spm_thread == 35) && 0) begin
        _axi_s_ctrl_spm_register_2 <= 0;
        _axi_s_ctrl_spm_flag_2 <= 0;
      end 
      if((spm_thread == 35) && 0) begin
        _axi_s_ctrl_spm_register_3 <= 0;
        _axi_s_ctrl_spm_flag_3 <= 0;
      end 
      if((spm_thread == 35) && 1) begin
        _axi_s_ctrl_spm_register_4 <= 0;
        _axi_s_ctrl_spm_flag_4 <= 0;
      end 
      if((spm_thread == 35) && 0) begin
        _axi_s_ctrl_spm_register_5 <= 0;
        _axi_s_ctrl_spm_flag_5 <= 0;
      end 
      if((spm_thread == 35) && 0) begin
        _axi_s_ctrl_spm_register_6 <= 0;
        _axi_s_ctrl_spm_flag_6 <= 0;
      end 
      if((spm_thread == 36) && 0) begin
        _axi_s_ctrl_spm_register_0 <= 0;
        _axi_s_ctrl_spm_flag_0 <= 0;
      end 
      if((spm_thread == 36) && 0) begin
        _axi_s_ctrl_spm_register_1 <= 0;
        _axi_s_ctrl_spm_flag_1 <= 0;
      end 
      if((spm_thread == 36) && 0) begin
        _axi_s_ctrl_spm_register_2 <= 0;
        _axi_s_ctrl_spm_flag_2 <= 0;
      end 
      if((spm_thread == 36) && 0) begin
        _axi_s_ctrl_spm_register_3 <= 0;
        _axi_s_ctrl_spm_flag_3 <= 0;
      end 
      if((spm_thread == 36) && 0) begin
        _axi_s_ctrl_spm_register_4 <= 0;
        _axi_s_ctrl_spm_flag_4 <= 0;
      end 
      if((spm_thread == 36) && 1) begin
        _axi_s_ctrl_spm_register_5 <= 0;
        _axi_s_ctrl_spm_flag_5 <= 0;
      end 
      if((spm_thread == 36) && 0) begin
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
      axi_m_dram_awid <= 0;
      axi_m_dram_awaddr <= 0;
      axi_m_dram_awlen <= 0;
      axi_m_dram_awvalid <= 0;
      _axi_m_dram_waddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_dram_waddr_cond_0_1) begin
        axi_m_dram_awvalid <= 0;
      end 
      if((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (_axi_m_dram_outstanding_wcount < 6) && ((_axi_m_dram_outstanding_wcount < 6) && (axi_m_dram_awready || !axi_m_dram_awvalid))) begin
        axi_m_dram_awid <= 0;
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
      if((_axi_m_dram_write_op_sel_buf == 1) && read_burst_rvalid_136 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0) && (_axi_m_dram_write_size_buf > 0)) && (_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0)) begin
        _axi_m_dram_wdata_sb_0 <= read_burst_rdata_140;
        _axi_m_dram_wvalid_sb_0 <= 1;
        _axi_m_dram_wlast_sb_0 <= read_burst_rlast_137 || (_axi_m_dram_write_size_buf == 1);
        _axi_m_dram_wstrb_sb_0 <= { 8{ 1'd1 } };
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
      axi_m_dram_arid <= 0;
      axi_m_dram_araddr <= 0;
      axi_m_dram_arlen <= 0;
      axi_m_dram_arvalid <= 0;
      _axi_m_dram_raddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_dram_raddr_cond_0_1) begin
        axi_m_dram_arvalid <= 0;
      end 
      if((_axi_m_dram_read_req_fsm == 1) && (axi_m_dram_arready || !axi_m_dram_arvalid)) begin
        axi_m_dram_arid <= 0;
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
      if((spm_thread == 11) && _axi_m_dram_read_req_idle) begin
        _axi_m_dram_read_start <= 1;
        _axi_m_dram_read_op_sel <= 1;
        _axi_m_dram_read_global_addr <= mask_addr_masked_78;
        _axi_m_dram_read_global_size <= size_73 >>> 3;
        _axi_m_dram_read_local_addr <= spm_addr_70 >>> 3;
        _axi_m_dram_read_local_stride <= 1;
        _axi_m_dram_read_local_size <= size_73 >>> 3;
        _axi_m_dram_read_local_blocksize <= 1;
      end 
      if((_axi_m_dram_read_req_fsm == 0) && _axi_m_dram_read_start) begin
        _axi_m_dram_read_req_busy <= 1;
      end 
      if(_axi_m_dram_read_start && _axi_m_dram_read_req_fifo_almost_full) begin
        _axi_m_dram_read_start <= 1;
      end 
      if((_axi_m_dram_read_req_fsm == 0) && (_axi_m_dram_read_start || _axi_m_dram_read_cont) && !_axi_m_dram_read_req_fifo_almost_full && (_axi_m_dram_read_global_size <= 256) && ((mask_addr_masked_88 & 4095) + (_axi_m_dram_read_global_size << 3) >= 4096)) begin
        _axi_m_dram_read_cur_global_size <= 4096 - (mask_addr_masked_90 & 4095) >> 3;
        _axi_m_dram_read_global_size <= _axi_m_dram_read_global_size - (4096 - (mask_addr_masked_92 & 4095) >> 3);
      end else if((_axi_m_dram_read_req_fsm == 0) && (_axi_m_dram_read_start || _axi_m_dram_read_cont) && !_axi_m_dram_read_req_fifo_almost_full && (_axi_m_dram_read_global_size <= 256)) begin
        _axi_m_dram_read_cur_global_size <= _axi_m_dram_read_global_size;
        _axi_m_dram_read_global_size <= 0;
      end else if((_axi_m_dram_read_req_fsm == 0) && (_axi_m_dram_read_start || _axi_m_dram_read_cont) && !_axi_m_dram_read_req_fifo_almost_full && ((mask_addr_masked_94 & 4095) + 2048 >= 4096)) begin
        _axi_m_dram_read_cur_global_size <= 4096 - (mask_addr_masked_96 & 4095) >> 3;
        _axi_m_dram_read_global_size <= _axi_m_dram_read_global_size - (4096 - (mask_addr_masked_98 & 4095) >> 3);
      end else if((_axi_m_dram_read_req_fsm == 0) && (_axi_m_dram_read_start || _axi_m_dram_read_cont) && !_axi_m_dram_read_req_fifo_almost_full) begin
        _axi_m_dram_read_cur_global_size <= 256;
        _axi_m_dram_read_global_size <= _axi_m_dram_read_global_size - 256;
      end 
      if((_axi_m_dram_read_req_fsm == 1) && (axi_m_dram_arready || !axi_m_dram_arvalid)) begin
        _axi_m_dram_read_global_addr <= _axi_m_dram_read_global_addr + (_axi_m_dram_read_cur_global_size << 3);
      end 
      if((_axi_m_dram_read_req_fsm == 1) && (axi_m_dram_arready || !axi_m_dram_arvalid) && (_axi_m_dram_read_global_size == 0)) begin
        _axi_m_dram_read_req_busy <= 0;
      end 
      if((_axi_m_dram_read_data_fsm == 0) && (!_axi_m_dram_read_data_busy && !_axi_m_dram_read_req_fifo_empty && (_axi_m_dram_read_op_sel_fifo == 1))) begin
        _axi_m_dram_read_data_busy <= 1;
        _axi_m_dram_read_op_sel_buf <= _axi_m_dram_read_op_sel_fifo;
        _axi_m_dram_read_local_addr_buf <= _axi_m_dram_read_local_addr_fifo;
        _axi_m_dram_read_local_stride_buf <= _axi_m_dram_read_local_stride_fifo;
        _axi_m_dram_read_local_size_buf <= _axi_m_dram_read_local_size_fifo;
        _axi_m_dram_read_local_blocksize_buf <= _axi_m_dram_read_local_blocksize_fifo;
      end 
      if((_axi_m_dram_read_data_fsm == 2) && _axi_m_dram_rvalid_sb_0) begin
        _axi_m_dram_read_local_size_buf <= _axi_m_dram_read_local_size_buf - 1;
      end 
      if((_axi_m_dram_read_data_fsm == 2) && _axi_m_dram_rvalid_sb_0 && (_axi_m_dram_read_local_size_buf <= 1)) begin
        _axi_m_dram_read_data_busy <= 0;
      end 
      if((spm_thread == 14) && _axi_m_dram_write_req_idle) begin
        _axi_m_dram_write_start <= 1;
        _axi_m_dram_write_op_sel <= 1;
        _axi_m_dram_write_global_addr <= mask_addr_masked_104;
        _axi_m_dram_write_global_size <= 8;
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
      if((_axi_m_dram_write_req_fsm == 0) && (_axi_m_dram_write_start || _axi_m_dram_write_cont) && !_axi_m_dram_write_req_fifo_almost_full && (_axi_m_dram_write_global_size <= 256) && ((mask_addr_masked_114 & 4095) + (_axi_m_dram_write_global_size << 3) >= 4096)) begin
        _axi_m_dram_write_cur_global_size <= 4096 - (mask_addr_masked_116 & 4095) >> 3;
        _axi_m_dram_write_global_size <= _axi_m_dram_write_global_size - (4096 - (mask_addr_masked_118 & 4095) >> 3);
      end else if((_axi_m_dram_write_req_fsm == 0) && (_axi_m_dram_write_start || _axi_m_dram_write_cont) && !_axi_m_dram_write_req_fifo_almost_full && (_axi_m_dram_write_global_size <= 256)) begin
        _axi_m_dram_write_cur_global_size <= _axi_m_dram_write_global_size;
        _axi_m_dram_write_global_size <= 0;
      end else if((_axi_m_dram_write_req_fsm == 0) && (_axi_m_dram_write_start || _axi_m_dram_write_cont) && !_axi_m_dram_write_req_fifo_almost_full && ((mask_addr_masked_120 & 4095) + 2048 >= 4096)) begin
        _axi_m_dram_write_cur_global_size <= 4096 - (mask_addr_masked_122 & 4095) >> 3;
        _axi_m_dram_write_global_size <= _axi_m_dram_write_global_size - (4096 - (mask_addr_masked_124 & 4095) >> 3);
      end else if((_axi_m_dram_write_req_fsm == 0) && (_axi_m_dram_write_start || _axi_m_dram_write_cont) && !_axi_m_dram_write_req_fifo_almost_full) begin
        _axi_m_dram_write_cur_global_size <= 256;
        _axi_m_dram_write_global_size <= _axi_m_dram_write_global_size - 256;
      end 
      if((_axi_m_dram_write_req_fsm == 1) && ((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (axi_m_dram_awready || !axi_m_dram_awvalid) && (_axi_m_dram_outstanding_wcount < 6))) begin
        _axi_m_dram_write_global_addr <= _axi_m_dram_write_global_addr + (_axi_m_dram_write_cur_global_size << 3);
      end 
      if((_axi_m_dram_write_req_fsm == 1) && ((_axi_m_dram_write_req_fsm == 1) && !_axi_m_dram_write_req_fifo_almost_full && (axi_m_dram_awready || !axi_m_dram_awvalid) && (_axi_m_dram_outstanding_wcount < 6)) && (_axi_m_dram_write_global_size == 0)) begin
        _axi_m_dram_write_req_busy <= 0;
      end 
      if((_axi_m_dram_write_data_fsm == 0) && (!_axi_m_dram_write_data_busy && !_axi_m_dram_write_req_fifo_empty && (_axi_m_dram_write_op_sel_fifo == 1))) begin
        _axi_m_dram_write_data_busy <= 1;
        _axi_m_dram_write_op_sel_buf <= _axi_m_dram_write_op_sel_fifo;
        _axi_m_dram_write_local_addr_buf <= _axi_m_dram_write_local_addr_fifo;
        _axi_m_dram_write_local_stride_buf <= _axi_m_dram_write_local_stride_fifo;
        _axi_m_dram_write_size_buf <= _axi_m_dram_write_size_fifo;
        _axi_m_dram_write_local_blocksize_buf <= _axi_m_dram_write_local_blocksize_fifo;
      end 
      if(_axi_m_dram_write_data_fsm == 1) begin
        _axi_m_dram_write_size_buf <= 0;
      end 
      if((_axi_m_dram_write_data_fsm == 2) && (!_axi_m_dram_write_req_fifo_empty && (_axi_m_dram_write_size_buf == 0))) begin
        _axi_m_dram_write_size_buf <= _axi_m_dram_write_size_fifo;
      end 
      if((_axi_m_dram_write_data_fsm == 2) && read_burst_rvalid_136 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0) && (_axi_m_dram_write_size_buf > 0))) begin
        _axi_m_dram_write_size_buf <= _axi_m_dram_write_size_buf - 1;
      end 
      if((_axi_m_dram_write_data_fsm == 2) && ((_axi_m_dram_write_op_sel_buf == 1) && read_burst_rvalid_136 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0) && (_axi_m_dram_write_size_buf > 0))) && read_burst_rlast_137) begin
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
      __tmp_112_1 <= 0;
      __tmp_132_1 <= 0;
    end else begin
      if(_axi_m_dram_write_req_fifo_enq && !_axi_m_dram_write_req_fifo_full && (_axi_m_dram_write_req_fifo_deq && !_axi_m_dram_write_req_fifo_empty)) begin
        count__axi_m_dram_write_req_fifo <= count__axi_m_dram_write_req_fifo;
      end else if(_axi_m_dram_write_req_fifo_enq && !_axi_m_dram_write_req_fifo_full) begin
        count__axi_m_dram_write_req_fifo <= count__axi_m_dram_write_req_fifo + 1;
      end else if(_axi_m_dram_write_req_fifo_deq && !_axi_m_dram_write_req_fifo_empty) begin
        count__axi_m_dram_write_req_fifo <= count__axi_m_dram_write_req_fifo - 1;
      end 
      __tmp_112_1 <= _tmp_112;
      __tmp_132_1 <= _tmp_132;
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
      if((_axis_out_mac_spm_write_data_wide_fsm == 2) && (_axis_out_mac_spm_write_op_sel_buf == 1) && (_axis_out_mac_spm_write_wide_count_148 == 1) && read_burst_rvalid_152 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_148 > 0)) && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid)) begin
        axis_out_mac_spm_tdata <= { read_burst_rdata_156, _axis_out_mac_spm_write_wide_wdata_157[127:64] };
        axis_out_mac_spm_tvalid <= 1;
        axis_out_mac_spm_tlast <= read_burst_rlast_153 || (_axis_out_mac_spm_write_size_buf <= 1);
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
      if((_axis_out_mac_spm_write_data_wide_fsm == 2) && read_burst_rvalid_152 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_148 > 0))) begin
        _axis_out_mac_spm_write_size_buf <= _axis_out_mac_spm_write_size_buf - 1;
      end 
      if((_axis_out_mac_spm_write_data_wide_fsm == 2) && (_axis_out_mac_spm_write_wide_count_148 == 1) && read_burst_rvalid_152 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_148 > 0)) && read_burst_rlast_153) begin
        _axis_out_mac_spm_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_out_mac_spm_write_req_fifo <= 0;
      __tmp_147_1 <= 0;
    end else begin
      if(_axis_out_mac_spm_write_req_fifo_enq && !_axis_out_mac_spm_write_req_fifo_full && (_axis_out_mac_spm_write_req_fifo_deq && !_axis_out_mac_spm_write_req_fifo_empty)) begin
        count__axis_out_mac_spm_write_req_fifo <= count__axis_out_mac_spm_write_req_fifo;
      end else if(_axis_out_mac_spm_write_req_fifo_enq && !_axis_out_mac_spm_write_req_fifo_full) begin
        count__axis_out_mac_spm_write_req_fifo <= count__axis_out_mac_spm_write_req_fifo + 1;
      end else if(_axis_out_mac_spm_write_req_fifo_deq && !_axis_out_mac_spm_write_req_fifo_empty) begin
        count__axis_out_mac_spm_write_req_fifo <= count__axis_out_mac_spm_write_req_fifo - 1;
      end 
      __tmp_147_1 <= _tmp_147;
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
      if((_axis_out_axim_spm_write_data_wide_fsm == 2) && (_axis_out_axim_spm_write_op_sel_buf == 1) && (_axis_out_axim_spm_write_wide_count_179 == 1) && read_burst_rvalid_183 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_179 > 0)) && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid)) begin
        axis_out_axim_spm_tdata <= { read_burst_rdata_187, _axis_out_axim_spm_write_wide_wdata_188[127:64] };
        axis_out_axim_spm_tvalid <= 1;
        axis_out_axim_spm_tlast <= read_burst_rlast_184 || (_axis_out_axim_spm_write_size_buf <= 1);
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
      if((_axis_out_axim_spm_write_data_wide_fsm == 2) && read_burst_rvalid_183 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_179 > 0))) begin
        _axis_out_axim_spm_write_size_buf <= _axis_out_axim_spm_write_size_buf - 1;
      end 
      if((_axis_out_axim_spm_write_data_wide_fsm == 2) && (_axis_out_axim_spm_write_wide_count_179 == 1) && read_burst_rvalid_183 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_179 > 0)) && read_burst_rlast_184) begin
        _axis_out_axim_spm_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_out_axim_spm_write_req_fifo <= 0;
      __tmp_178_1 <= 0;
    end else begin
      if(_axis_out_axim_spm_write_req_fifo_enq && !_axis_out_axim_spm_write_req_fifo_full && (_axis_out_axim_spm_write_req_fifo_deq && !_axis_out_axim_spm_write_req_fifo_empty)) begin
        count__axis_out_axim_spm_write_req_fifo <= count__axis_out_axim_spm_write_req_fifo;
      end else if(_axis_out_axim_spm_write_req_fifo_enq && !_axis_out_axim_spm_write_req_fifo_full) begin
        count__axis_out_axim_spm_write_req_fifo <= count__axis_out_axim_spm_write_req_fifo + 1;
      end else if(_axis_out_axim_spm_write_req_fifo_deq && !_axis_out_axim_spm_write_req_fifo_empty) begin
        count__axis_out_axim_spm_write_req_fifo <= count__axis_out_axim_spm_write_req_fifo - 1;
      end 
      __tmp_178_1 <= _tmp_178;
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
      if((_axis_in_axim_spm_read_data_wide_fsm == 2) && (_axis_in_axim_spm_read_op_sel_buf == 1) && axis_in_axim_spm_tvalid && (_axis_in_axim_spm_read_wide_count_167 == 0)) begin
        _axis_in_axim_spm_read_local_size_buf <= _axis_in_axim_spm_read_local_size_buf - 1;
      end 
      if((_axis_in_axim_spm_read_data_wide_fsm == 2) && (_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_wide_count_167 > 0)) begin
        _axis_in_axim_spm_read_local_size_buf <= _axis_in_axim_spm_read_local_size_buf - 1;
      end 
      if((_axis_in_axim_spm_read_data_wide_fsm == 2) && (_axis_in_axim_spm_read_local_size_buf <= 1) && (_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_wide_count_167 > 0)) begin
        _axis_in_axim_spm_read_data_busy <= 0;
      end 
      if((_axis_in_axim_spm_read_data_wide_fsm == 2) && (_axis_in_axim_spm_read_local_size_buf <= 1) && (_axis_in_axim_spm_read_op_sel_buf == 1) && axis_in_axim_spm_tvalid && (_axis_in_axim_spm_read_wide_count_167 == 0)) begin
        _axis_in_axim_spm_read_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_in_axim_spm_read_req_fifo <= 0;
      __tmp_164_1 <= 0;
    end else begin
      if(_axis_in_axim_spm_read_req_fifo_enq && !_axis_in_axim_spm_read_req_fifo_full && (_axis_in_axim_spm_read_req_fifo_deq && !_axis_in_axim_spm_read_req_fifo_empty)) begin
        count__axis_in_axim_spm_read_req_fifo <= count__axis_in_axim_spm_read_req_fifo;
      end else if(_axis_in_axim_spm_read_req_fifo_enq && !_axis_in_axim_spm_read_req_fifo_full) begin
        count__axis_in_axim_spm_read_req_fifo <= count__axis_in_axim_spm_read_req_fifo + 1;
      end else if(_axis_in_axim_spm_read_req_fifo_deq && !_axis_in_axim_spm_read_req_fifo_empty) begin
        count__axis_in_axim_spm_read_req_fifo <= count__axis_in_axim_spm_read_req_fifo - 1;
      end 
      __tmp_164_1 <= _tmp_164;
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
      if((_axis_out_xored_spm_write_data_wide_fsm == 2) && (_axis_out_xored_spm_write_op_sel_buf == 1) && (_axis_out_xored_spm_write_wide_count_210 == 1) && read_burst_rvalid_214 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_210 > 0)) && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid)) begin
        axis_out_xored_spm_tdata <= { read_burst_rdata_218, _axis_out_xored_spm_write_wide_wdata_219[127:64] };
        axis_out_xored_spm_tvalid <= 1;
        axis_out_xored_spm_tlast <= read_burst_rlast_215 || (_axis_out_xored_spm_write_size_buf <= 1);
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
      if((_axis_out_xored_spm_write_data_wide_fsm == 2) && read_burst_rvalid_214 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_210 > 0))) begin
        _axis_out_xored_spm_write_size_buf <= _axis_out_xored_spm_write_size_buf - 1;
      end 
      if((_axis_out_xored_spm_write_data_wide_fsm == 2) && (_axis_out_xored_spm_write_wide_count_210 == 1) && read_burst_rvalid_214 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_210 > 0)) && read_burst_rlast_215) begin
        _axis_out_xored_spm_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_out_xored_spm_write_req_fifo <= 0;
      __tmp_209_1 <= 0;
    end else begin
      if(_axis_out_xored_spm_write_req_fifo_enq && !_axis_out_xored_spm_write_req_fifo_full && (_axis_out_xored_spm_write_req_fifo_deq && !_axis_out_xored_spm_write_req_fifo_empty)) begin
        count__axis_out_xored_spm_write_req_fifo <= count__axis_out_xored_spm_write_req_fifo;
      end else if(_axis_out_xored_spm_write_req_fifo_enq && !_axis_out_xored_spm_write_req_fifo_full) begin
        count__axis_out_xored_spm_write_req_fifo <= count__axis_out_xored_spm_write_req_fifo + 1;
      end else if(_axis_out_xored_spm_write_req_fifo_deq && !_axis_out_xored_spm_write_req_fifo_empty) begin
        count__axis_out_xored_spm_write_req_fifo <= count__axis_out_xored_spm_write_req_fifo - 1;
      end 
      __tmp_209_1 <= _tmp_209;
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
      if((_axis_in_xored_spm_read_data_wide_fsm == 2) && (_axis_in_xored_spm_read_op_sel_buf == 1) && axis_in_xored_spm_tvalid && (_axis_in_xored_spm_read_wide_count_198 == 0)) begin
        _axis_in_xored_spm_read_local_size_buf <= _axis_in_xored_spm_read_local_size_buf - 1;
      end 
      if((_axis_in_xored_spm_read_data_wide_fsm == 2) && (_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_wide_count_198 > 0)) begin
        _axis_in_xored_spm_read_local_size_buf <= _axis_in_xored_spm_read_local_size_buf - 1;
      end 
      if((_axis_in_xored_spm_read_data_wide_fsm == 2) && (_axis_in_xored_spm_read_local_size_buf <= 1) && (_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_wide_count_198 > 0)) begin
        _axis_in_xored_spm_read_data_busy <= 0;
      end 
      if((_axis_in_xored_spm_read_data_wide_fsm == 2) && (_axis_in_xored_spm_read_local_size_buf <= 1) && (_axis_in_xored_spm_read_op_sel_buf == 1) && axis_in_xored_spm_tvalid && (_axis_in_xored_spm_read_wide_count_198 == 0)) begin
        _axis_in_xored_spm_read_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_in_xored_spm_read_req_fifo <= 0;
      __tmp_195_1 <= 0;
    end else begin
      if(_axis_in_xored_spm_read_req_fifo_enq && !_axis_in_xored_spm_read_req_fifo_full && (_axis_in_xored_spm_read_req_fifo_deq && !_axis_in_xored_spm_read_req_fifo_empty)) begin
        count__axis_in_xored_spm_read_req_fifo <= count__axis_in_xored_spm_read_req_fifo;
      end else if(_axis_in_xored_spm_read_req_fifo_enq && !_axis_in_xored_spm_read_req_fifo_full) begin
        count__axis_in_xored_spm_read_req_fifo <= count__axis_in_xored_spm_read_req_fifo + 1;
      end else if(_axis_in_xored_spm_read_req_fifo_deq && !_axis_in_xored_spm_read_req_fifo_empty) begin
        count__axis_in_xored_spm_read_req_fifo <= count__axis_in_xored_spm_read_req_fifo - 1;
      end 
      __tmp_195_1 <= _tmp_195;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      __tmp_139_1 <= 0;
      __tmp_155_1 <= 0;
      __tmp_186_1 <= 0;
      __tmp_217_1 <= 0;
    end else begin
      __tmp_139_1 <= _tmp_139;
      __tmp_155_1 <= _tmp_155;
      __tmp_186_1 <= _tmp_186;
      __tmp_217_1 <= _tmp_217;
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

  always @(posedge CLK) begin
    if(RST) begin
      spm_thread <= spm_thread_init;
      dram_addr_69 <= 0;
      spm_addr_70 <= 0;
      size_73 <= 0;
      direction_71 <= 0;
      destination_72 <= 0;
    end else begin
      case(spm_thread)
        spm_thread_init: begin
          spm_thread <= spm_thread_1;
        end
        spm_thread_1: begin
          if(1) begin
            spm_thread <= spm_thread_2;
          end else begin
            spm_thread <= spm_thread_38;
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
          if(destination_72 == 1) begin
            spm_thread <= spm_thread_10;
          end else begin
            spm_thread <= spm_thread_17;
          end
        end
        spm_thread_10: begin
          if(direction_71 == 0) begin
            spm_thread <= spm_thread_11;
          end else begin
            spm_thread <= spm_thread_14;
          end
        end
        spm_thread_11: begin
          if(_axi_m_dram_read_req_idle) begin
            spm_thread <= spm_thread_12;
          end 
        end
        spm_thread_12: begin
          if(_axi_m_dram_read_idle) begin
            spm_thread <= spm_thread_13;
          end 
        end
        spm_thread_13: begin
          spm_thread <= spm_thread_16;
        end
        spm_thread_14: begin
          if(_axi_m_dram_write_req_idle) begin
            spm_thread <= spm_thread_15;
          end 
        end
        spm_thread_15: begin
          if(_axi_m_dram_write_idle && !_axi_m_dram_has_outstanding_write) begin
            spm_thread <= spm_thread_16;
          end 
        end
        spm_thread_16: begin
          spm_thread <= spm_thread_35;
        end
        spm_thread_17: begin
          if(destination_72 == 2) begin
            spm_thread <= spm_thread_18;
          end else begin
            spm_thread <= spm_thread_22;
          end
        end
        spm_thread_18: begin
          if(direction_71 == 1) begin
            spm_thread <= spm_thread_19;
          end else begin
            spm_thread <= spm_thread_21;
          end
        end
        spm_thread_19: begin
          if(!_axis_out_mac_spm_write_req_fifo_almost_full) begin
            spm_thread <= spm_thread_20;
          end 
        end
        spm_thread_20: begin
          if(_axis_out_mac_spm_write_idle) begin
            spm_thread <= spm_thread_21;
          end 
        end
        spm_thread_21: begin
          spm_thread <= spm_thread_35;
        end
        spm_thread_22: begin
          if(destination_72 == 4) begin
            spm_thread <= spm_thread_23;
          end else begin
            spm_thread <= spm_thread_28;
          end
        end
        spm_thread_23: begin
          if(direction_71 == 0) begin
            spm_thread <= spm_thread_24;
          end else begin
            spm_thread <= spm_thread_26;
          end
        end
        spm_thread_24: begin
          if(!_axis_in_axim_spm_read_req_fifo_almost_full) begin
            spm_thread <= spm_thread_25;
          end 
        end
        spm_thread_25: begin
          spm_thread <= spm_thread_27;
        end
        spm_thread_26: begin
          if(!_axis_out_axim_spm_write_req_fifo_almost_full) begin
            spm_thread <= spm_thread_27;
          end 
        end
        spm_thread_27: begin
          spm_thread <= spm_thread_35;
        end
        spm_thread_28: begin
          if(destination_72 == 8) begin
            spm_thread <= spm_thread_29;
          end else begin
            spm_thread <= spm_thread_35;
          end
        end
        spm_thread_29: begin
          if(direction_71 == 0) begin
            spm_thread <= spm_thread_30;
          end else begin
            spm_thread <= spm_thread_33;
          end
        end
        spm_thread_30: begin
          if(!_axis_in_xored_spm_read_req_fifo_almost_full) begin
            spm_thread <= spm_thread_31;
          end 
        end
        spm_thread_31: begin
          if(_axis_in_xored_spm_read_idle) begin
            spm_thread <= spm_thread_32;
          end 
        end
        spm_thread_32: begin
          spm_thread <= spm_thread_34;
        end
        spm_thread_33: begin
          if(!_axis_out_xored_spm_write_req_fifo_almost_full) begin
            spm_thread <= spm_thread_34;
          end 
        end
        spm_thread_34: begin
          spm_thread <= spm_thread_35;
        end
        spm_thread_35: begin
          spm_thread <= spm_thread_36;
        end
        spm_thread_36: begin
          spm_thread <= spm_thread_37;
        end
        spm_thread_37: begin
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

  localparam _axi_m_dram_read_data_fsm_1 = 1;
  localparam _axi_m_dram_read_data_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_dram_read_data_fsm <= _axi_m_dram_read_data_fsm_init;
    end else begin
      case(_axi_m_dram_read_data_fsm)
        _axi_m_dram_read_data_fsm_init: begin
          if(!_axi_m_dram_read_data_busy && !_axi_m_dram_read_req_fifo_empty && (_axi_m_dram_read_op_sel_fifo == 1)) begin
            _axi_m_dram_read_data_fsm <= _axi_m_dram_read_data_fsm_1;
          end 
        end
        _axi_m_dram_read_data_fsm_1: begin
          _axi_m_dram_read_data_fsm <= _axi_m_dram_read_data_fsm_2;
        end
        _axi_m_dram_read_data_fsm_2: begin
          if(_axi_m_dram_rvalid_sb_0 && (_axi_m_dram_read_local_size_buf <= 1)) begin
            _axi_m_dram_read_data_fsm <= _axi_m_dram_read_data_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam write_burst_fsm_0_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      write_burst_fsm_0 <= write_burst_fsm_0_init;
      write_burst_addr_99 <= 0;
      write_burst_stride_100 <= 0;
      write_burst_length_101 <= 0;
      write_burst_done_102 <= 0;
    end else begin
      case(write_burst_fsm_0)
        write_burst_fsm_0_init: begin
          write_burst_addr_99 <= _axi_m_dram_read_local_addr_buf;
          write_burst_stride_100 <= _axi_m_dram_read_local_stride_buf;
          write_burst_length_101 <= _axi_m_dram_read_local_size_buf;
          write_burst_done_102 <= 0;
          if((_axi_m_dram_read_data_fsm == 1) && (_axi_m_dram_read_op_sel_buf == 1) && (_axi_m_dram_read_local_size_buf > 0)) begin
            write_burst_fsm_0 <= write_burst_fsm_0_1;
          end 
        end
        write_burst_fsm_0_1: begin
          if(_axi_m_dram_rvalid_sb_0) begin
            write_burst_addr_99 <= write_burst_addr_99 + write_burst_stride_100;
            write_burst_length_101 <= write_burst_length_101 - 1;
            write_burst_done_102 <= 0;
          end 
          if(_axi_m_dram_rvalid_sb_0 && (write_burst_length_101 <= 1)) begin
            write_burst_done_102 <= 1;
          end 
          if(_axi_m_dram_rvalid_sb_0 && 0) begin
            write_burst_done_102 <= 1;
          end 
          if(_axi_m_dram_rvalid_sb_0 && (write_burst_length_101 <= 1)) begin
            write_burst_fsm_0 <= write_burst_fsm_0_init;
          end 
          if(_axi_m_dram_rvalid_sb_0 && 0) begin
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

  localparam _axi_m_dram_write_data_fsm_1 = 1;
  localparam _axi_m_dram_write_data_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_dram_write_data_fsm <= _axi_m_dram_write_data_fsm_init;
    end else begin
      case(_axi_m_dram_write_data_fsm)
        _axi_m_dram_write_data_fsm_init: begin
          if(!_axi_m_dram_write_data_busy && !_axi_m_dram_write_req_fifo_empty && (_axi_m_dram_write_op_sel_fifo == 1)) begin
            _axi_m_dram_write_data_fsm <= _axi_m_dram_write_data_fsm_1;
          end 
        end
        _axi_m_dram_write_data_fsm_1: begin
          _axi_m_dram_write_data_fsm <= _axi_m_dram_write_data_fsm_2;
        end
        _axi_m_dram_write_data_fsm_2: begin
          if((_axi_m_dram_write_op_sel_buf == 1) && read_burst_rvalid_136 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0) && (_axi_m_dram_write_size_buf > 0)) && read_burst_rlast_137) begin
            _axi_m_dram_write_data_fsm <= _axi_m_dram_write_data_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam read_burst_fsm_1_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      read_burst_fsm_1 <= read_burst_fsm_1_init;
      read_burst_addr_133 <= 0;
      read_burst_stride_134 <= 0;
      read_burst_length_135 <= 0;
      read_burst_rvalid_136 <= 0;
      read_burst_rlast_137 <= 0;
    end else begin
      case(read_burst_fsm_1)
        read_burst_fsm_1_init: begin
          read_burst_addr_133 <= _axi_m_dram_write_local_addr_buf;
          read_burst_stride_134 <= _axi_m_dram_write_local_stride_buf;
          read_burst_length_135 <= _axi_m_dram_write_size_buf;
          read_burst_rvalid_136 <= 0;
          read_burst_rlast_137 <= 0;
          if((_axi_m_dram_write_data_fsm == 1) && (_axi_m_dram_write_op_sel_buf == 1) && (_axi_m_dram_write_size_buf > 0)) begin
            read_burst_fsm_1 <= read_burst_fsm_1_1;
          end 
        end
        read_burst_fsm_1_1: begin
          if((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0) && (_axi_m_dram_write_size_buf > 0) && (read_burst_length_135 > 0)) begin
            read_burst_addr_133 <= read_burst_addr_133 + read_burst_stride_134;
            read_burst_length_135 <= read_burst_length_135 - 1;
            read_burst_rvalid_136 <= 1;
          end 
          if((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0) && (_axi_m_dram_write_size_buf > 0) && (read_burst_length_135 <= 1)) begin
            read_burst_rlast_137 <= 1;
          end 
          if(read_burst_rlast_137 && read_burst_rvalid_136 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0) && (_axi_m_dram_write_size_buf > 0))) begin
            read_burst_rvalid_136 <= 0;
            read_burst_rlast_137 <= 0;
          end 
          if(0) begin
            read_burst_rvalid_136 <= 0;
            read_burst_rlast_137 <= 0;
          end 
          if(read_burst_rlast_137 && read_burst_rvalid_136 && ((_axi_m_dram_wready_sb_0 || !_axi_m_dram_wvalid_sb_0) && (_axi_m_dram_write_size_buf > 0))) begin
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
      _axis_out_mac_spm_write_wide_count_148 <= 0;
      _axis_out_mac_spm_write_wide_wdata_157 <= 0;
    end else begin
      case(_axis_out_mac_spm_write_data_wide_fsm)
        _axis_out_mac_spm_write_data_wide_fsm_init: begin
          if(!_axis_out_mac_spm_write_data_busy && !_axis_out_mac_spm_write_req_fifo_empty && (_axis_out_mac_spm_write_op_sel_fifo == 1)) begin
            _axis_out_mac_spm_write_data_wide_fsm <= _axis_out_mac_spm_write_data_wide_fsm_1;
          end 
        end
        _axis_out_mac_spm_write_data_wide_fsm_1: begin
          _axis_out_mac_spm_write_wide_count_148 <= 0;
          _axis_out_mac_spm_write_data_wide_fsm <= _axis_out_mac_spm_write_data_wide_fsm_2;
        end
        _axis_out_mac_spm_write_data_wide_fsm_2: begin
          if(read_burst_rvalid_152 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_148 > 0))) begin
            _axis_out_mac_spm_write_wide_wdata_157 <= { read_burst_rdata_156, _axis_out_mac_spm_write_wide_wdata_157[127:64] };
            _axis_out_mac_spm_write_wide_count_148 <= _axis_out_mac_spm_write_wide_count_148 + 1;
          end 
          if(read_burst_rvalid_152 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_148 > 0)) && (_axis_out_mac_spm_write_wide_count_148 == 1)) begin
            _axis_out_mac_spm_write_wide_count_148 <= 0;
          end 
          if((_axis_out_mac_spm_write_wide_count_148 == 1) && read_burst_rvalid_152 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_148 > 0)) && read_burst_rlast_153) begin
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
      read_burst_addr_149 <= 0;
      read_burst_stride_150 <= 0;
      read_burst_length_151 <= 0;
      read_burst_rvalid_152 <= 0;
      read_burst_rlast_153 <= 0;
    end else begin
      case(read_burst_fsm_2)
        read_burst_fsm_2_init: begin
          read_burst_addr_149 <= _axis_out_mac_spm_write_local_addr_buf;
          read_burst_stride_150 <= _axis_out_mac_spm_write_local_stride_buf;
          read_burst_length_151 <= _axis_out_mac_spm_write_size_buf;
          read_burst_rvalid_152 <= 0;
          read_burst_rlast_153 <= 0;
          if((_axis_out_mac_spm_write_data_wide_fsm == 1) && (_axis_out_mac_spm_write_op_sel_buf == 1) && (_axis_out_mac_spm_write_size_buf > 0)) begin
            read_burst_fsm_2 <= read_burst_fsm_2_1;
          end 
        end
        read_burst_fsm_2_1: begin
          if((axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_148 > 0)) && (read_burst_length_151 > 0)) begin
            read_burst_addr_149 <= read_burst_addr_149 + read_burst_stride_150;
            read_burst_length_151 <= read_burst_length_151 - 1;
            read_burst_rvalid_152 <= 1;
          end 
          if((axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_148 > 0)) && (read_burst_length_151 <= 1)) begin
            read_burst_rlast_153 <= 1;
          end 
          if(read_burst_rlast_153 && read_burst_rvalid_152 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_148 > 0))) begin
            read_burst_rvalid_152 <= 0;
            read_burst_rlast_153 <= 0;
          end 
          if(0) begin
            read_burst_rvalid_152 <= 0;
            read_burst_rlast_153 <= 0;
          end 
          if(read_burst_rlast_153 && read_burst_rvalid_152 && (axis_out_mac_spm_tready || !axis_out_mac_spm_tvalid || (_axis_out_mac_spm_write_wide_count_148 > 0))) begin
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
      _axis_in_axim_spm_read_wide_count_167 <= 0;
      _axis_in_axim_spm_read_wide_wvalid_166 <= 0;
      _axis_in_axim_spm_read_wide_wdata_165 <= 0;
    end else begin
      case(_axis_in_axim_spm_read_data_wide_fsm)
        _axis_in_axim_spm_read_data_wide_fsm_init: begin
          if(!_axis_in_axim_spm_read_data_busy && !_axis_in_axim_spm_read_req_fifo_empty && (_axis_in_axim_spm_read_op_sel_fifo == 1)) begin
            _axis_in_axim_spm_read_data_wide_fsm <= _axis_in_axim_spm_read_data_wide_fsm_1;
          end 
        end
        _axis_in_axim_spm_read_data_wide_fsm_1: begin
          _axis_in_axim_spm_read_wide_count_167 <= 0;
          _axis_in_axim_spm_read_wide_wvalid_166 <= 0;
          _axis_in_axim_spm_read_data_wide_fsm <= _axis_in_axim_spm_read_data_wide_fsm_2;
        end
        _axis_in_axim_spm_read_data_wide_fsm_2: begin
          if(_axis_in_axim_spm_read_op_sel_buf == 1) begin
            _axis_in_axim_spm_read_wide_wvalid_166 <= 0;
          end 
          if((_axis_in_axim_spm_read_op_sel_buf == 1) && axis_in_axim_spm_tvalid && (_axis_in_axim_spm_read_wide_count_167 == 0)) begin
            _axis_in_axim_spm_read_wide_count_167 <= _axis_in_axim_spm_read_wide_count_167 + 1;
            _axis_in_axim_spm_read_wide_wdata_165 <= axis_in_axim_spm_tdata;
            _axis_in_axim_spm_read_wide_wvalid_166 <= 1;
          end 
          if((_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_wide_count_167 > 0)) begin
            _axis_in_axim_spm_read_wide_count_167 <= _axis_in_axim_spm_read_wide_count_167 + 1;
            _axis_in_axim_spm_read_wide_wdata_165 <= _axis_in_axim_spm_read_wide_wdata_165 >> 64;
            _axis_in_axim_spm_read_wide_wvalid_166 <= 1;
          end 
          if((_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_wide_count_167 == 1)) begin
            _axis_in_axim_spm_read_wide_count_167 <= 0;
          end 
          if((_axis_in_axim_spm_read_local_size_buf <= 1) && (_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_wide_count_167 > 0)) begin
            _axis_in_axim_spm_read_data_wide_fsm <= _axis_in_axim_spm_read_data_wide_fsm_init;
          end 
          if((_axis_in_axim_spm_read_local_size_buf <= 1) && (_axis_in_axim_spm_read_op_sel_buf == 1) && axis_in_axim_spm_tvalid && (_axis_in_axim_spm_read_wide_count_167 == 0)) begin
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
      write_burst_addr_168 <= 0;
      write_burst_stride_169 <= 0;
      write_burst_length_170 <= 0;
      write_burst_done_171 <= 0;
    end else begin
      case(write_burst_fsm_3)
        write_burst_fsm_3_init: begin
          write_burst_addr_168 <= _axis_in_axim_spm_read_local_addr_buf;
          write_burst_stride_169 <= _axis_in_axim_spm_read_local_stride_buf;
          write_burst_length_170 <= _axis_in_axim_spm_read_local_size_buf;
          write_burst_done_171 <= 0;
          if((_axis_in_axim_spm_read_data_wide_fsm == 1) && (_axis_in_axim_spm_read_op_sel_buf == 1) && (_axis_in_axim_spm_read_local_size_buf > 0)) begin
            write_burst_fsm_3 <= write_burst_fsm_3_1;
          end 
        end
        write_burst_fsm_3_1: begin
          if(_axis_in_axim_spm_read_wide_wvalid_166) begin
            write_burst_addr_168 <= write_burst_addr_168 + write_burst_stride_169;
            write_burst_length_170 <= write_burst_length_170 - 1;
            write_burst_done_171 <= 0;
          end 
          if(_axis_in_axim_spm_read_wide_wvalid_166 && (write_burst_length_170 <= 1)) begin
            write_burst_done_171 <= 1;
          end 
          if(_axis_in_axim_spm_read_wide_wvalid_166 && 0) begin
            write_burst_done_171 <= 1;
          end 
          if(_axis_in_axim_spm_read_wide_wvalid_166 && (write_burst_length_170 <= 1)) begin
            write_burst_fsm_3 <= write_burst_fsm_3_init;
          end 
          if(_axis_in_axim_spm_read_wide_wvalid_166 && 0) begin
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
      _axis_out_axim_spm_write_wide_count_179 <= 0;
      _axis_out_axim_spm_write_wide_wdata_188 <= 0;
    end else begin
      case(_axis_out_axim_spm_write_data_wide_fsm)
        _axis_out_axim_spm_write_data_wide_fsm_init: begin
          if(!_axis_out_axim_spm_write_data_busy && !_axis_out_axim_spm_write_req_fifo_empty && (_axis_out_axim_spm_write_op_sel_fifo == 1)) begin
            _axis_out_axim_spm_write_data_wide_fsm <= _axis_out_axim_spm_write_data_wide_fsm_1;
          end 
        end
        _axis_out_axim_spm_write_data_wide_fsm_1: begin
          _axis_out_axim_spm_write_wide_count_179 <= 0;
          _axis_out_axim_spm_write_data_wide_fsm <= _axis_out_axim_spm_write_data_wide_fsm_2;
        end
        _axis_out_axim_spm_write_data_wide_fsm_2: begin
          if(read_burst_rvalid_183 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_179 > 0))) begin
            _axis_out_axim_spm_write_wide_wdata_188 <= { read_burst_rdata_187, _axis_out_axim_spm_write_wide_wdata_188[127:64] };
            _axis_out_axim_spm_write_wide_count_179 <= _axis_out_axim_spm_write_wide_count_179 + 1;
          end 
          if(read_burst_rvalid_183 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_179 > 0)) && (_axis_out_axim_spm_write_wide_count_179 == 1)) begin
            _axis_out_axim_spm_write_wide_count_179 <= 0;
          end 
          if((_axis_out_axim_spm_write_wide_count_179 == 1) && read_burst_rvalid_183 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_179 > 0)) && read_burst_rlast_184) begin
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
      read_burst_addr_180 <= 0;
      read_burst_stride_181 <= 0;
      read_burst_length_182 <= 0;
      read_burst_rvalid_183 <= 0;
      read_burst_rlast_184 <= 0;
    end else begin
      case(read_burst_fsm_4)
        read_burst_fsm_4_init: begin
          read_burst_addr_180 <= _axis_out_axim_spm_write_local_addr_buf;
          read_burst_stride_181 <= _axis_out_axim_spm_write_local_stride_buf;
          read_burst_length_182 <= _axis_out_axim_spm_write_size_buf;
          read_burst_rvalid_183 <= 0;
          read_burst_rlast_184 <= 0;
          if((_axis_out_axim_spm_write_data_wide_fsm == 1) && (_axis_out_axim_spm_write_op_sel_buf == 1) && (_axis_out_axim_spm_write_size_buf > 0)) begin
            read_burst_fsm_4 <= read_burst_fsm_4_1;
          end 
        end
        read_burst_fsm_4_1: begin
          if((axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_179 > 0)) && (read_burst_length_182 > 0)) begin
            read_burst_addr_180 <= read_burst_addr_180 + read_burst_stride_181;
            read_burst_length_182 <= read_burst_length_182 - 1;
            read_burst_rvalid_183 <= 1;
          end 
          if((axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_179 > 0)) && (read_burst_length_182 <= 1)) begin
            read_burst_rlast_184 <= 1;
          end 
          if(read_burst_rlast_184 && read_burst_rvalid_183 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_179 > 0))) begin
            read_burst_rvalid_183 <= 0;
            read_burst_rlast_184 <= 0;
          end 
          if(0) begin
            read_burst_rvalid_183 <= 0;
            read_burst_rlast_184 <= 0;
          end 
          if(read_burst_rlast_184 && read_burst_rvalid_183 && (axis_out_axim_spm_tready || !axis_out_axim_spm_tvalid || (_axis_out_axim_spm_write_wide_count_179 > 0))) begin
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
      _axis_in_xored_spm_read_wide_count_198 <= 0;
      _axis_in_xored_spm_read_wide_wvalid_197 <= 0;
      _axis_in_xored_spm_read_wide_wdata_196 <= 0;
    end else begin
      case(_axis_in_xored_spm_read_data_wide_fsm)
        _axis_in_xored_spm_read_data_wide_fsm_init: begin
          if(!_axis_in_xored_spm_read_data_busy && !_axis_in_xored_spm_read_req_fifo_empty && (_axis_in_xored_spm_read_op_sel_fifo == 1)) begin
            _axis_in_xored_spm_read_data_wide_fsm <= _axis_in_xored_spm_read_data_wide_fsm_1;
          end 
        end
        _axis_in_xored_spm_read_data_wide_fsm_1: begin
          _axis_in_xored_spm_read_wide_count_198 <= 0;
          _axis_in_xored_spm_read_wide_wvalid_197 <= 0;
          _axis_in_xored_spm_read_data_wide_fsm <= _axis_in_xored_spm_read_data_wide_fsm_2;
        end
        _axis_in_xored_spm_read_data_wide_fsm_2: begin
          if(_axis_in_xored_spm_read_op_sel_buf == 1) begin
            _axis_in_xored_spm_read_wide_wvalid_197 <= 0;
          end 
          if((_axis_in_xored_spm_read_op_sel_buf == 1) && axis_in_xored_spm_tvalid && (_axis_in_xored_spm_read_wide_count_198 == 0)) begin
            _axis_in_xored_spm_read_wide_count_198 <= _axis_in_xored_spm_read_wide_count_198 + 1;
            _axis_in_xored_spm_read_wide_wdata_196 <= axis_in_xored_spm_tdata;
            _axis_in_xored_spm_read_wide_wvalid_197 <= 1;
          end 
          if((_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_wide_count_198 > 0)) begin
            _axis_in_xored_spm_read_wide_count_198 <= _axis_in_xored_spm_read_wide_count_198 + 1;
            _axis_in_xored_spm_read_wide_wdata_196 <= _axis_in_xored_spm_read_wide_wdata_196 >> 64;
            _axis_in_xored_spm_read_wide_wvalid_197 <= 1;
          end 
          if((_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_wide_count_198 == 1)) begin
            _axis_in_xored_spm_read_wide_count_198 <= 0;
          end 
          if((_axis_in_xored_spm_read_local_size_buf <= 1) && (_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_wide_count_198 > 0)) begin
            _axis_in_xored_spm_read_data_wide_fsm <= _axis_in_xored_spm_read_data_wide_fsm_init;
          end 
          if((_axis_in_xored_spm_read_local_size_buf <= 1) && (_axis_in_xored_spm_read_op_sel_buf == 1) && axis_in_xored_spm_tvalid && (_axis_in_xored_spm_read_wide_count_198 == 0)) begin
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
      write_burst_addr_199 <= 0;
      write_burst_stride_200 <= 0;
      write_burst_length_201 <= 0;
      write_burst_done_202 <= 0;
    end else begin
      case(write_burst_fsm_5)
        write_burst_fsm_5_init: begin
          write_burst_addr_199 <= _axis_in_xored_spm_read_local_addr_buf;
          write_burst_stride_200 <= _axis_in_xored_spm_read_local_stride_buf;
          write_burst_length_201 <= _axis_in_xored_spm_read_local_size_buf;
          write_burst_done_202 <= 0;
          if((_axis_in_xored_spm_read_data_wide_fsm == 1) && (_axis_in_xored_spm_read_op_sel_buf == 1) && (_axis_in_xored_spm_read_local_size_buf > 0)) begin
            write_burst_fsm_5 <= write_burst_fsm_5_1;
          end 
        end
        write_burst_fsm_5_1: begin
          if(_axis_in_xored_spm_read_wide_wvalid_197) begin
            write_burst_addr_199 <= write_burst_addr_199 + write_burst_stride_200;
            write_burst_length_201 <= write_burst_length_201 - 1;
            write_burst_done_202 <= 0;
          end 
          if(_axis_in_xored_spm_read_wide_wvalid_197 && (write_burst_length_201 <= 1)) begin
            write_burst_done_202 <= 1;
          end 
          if(_axis_in_xored_spm_read_wide_wvalid_197 && 0) begin
            write_burst_done_202 <= 1;
          end 
          if(_axis_in_xored_spm_read_wide_wvalid_197 && (write_burst_length_201 <= 1)) begin
            write_burst_fsm_5 <= write_burst_fsm_5_init;
          end 
          if(_axis_in_xored_spm_read_wide_wvalid_197 && 0) begin
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
      _axis_out_xored_spm_write_wide_count_210 <= 0;
      _axis_out_xored_spm_write_wide_wdata_219 <= 0;
    end else begin
      case(_axis_out_xored_spm_write_data_wide_fsm)
        _axis_out_xored_spm_write_data_wide_fsm_init: begin
          if(!_axis_out_xored_spm_write_data_busy && !_axis_out_xored_spm_write_req_fifo_empty && (_axis_out_xored_spm_write_op_sel_fifo == 1)) begin
            _axis_out_xored_spm_write_data_wide_fsm <= _axis_out_xored_spm_write_data_wide_fsm_1;
          end 
        end
        _axis_out_xored_spm_write_data_wide_fsm_1: begin
          _axis_out_xored_spm_write_wide_count_210 <= 0;
          _axis_out_xored_spm_write_data_wide_fsm <= _axis_out_xored_spm_write_data_wide_fsm_2;
        end
        _axis_out_xored_spm_write_data_wide_fsm_2: begin
          if(read_burst_rvalid_214 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_210 > 0))) begin
            _axis_out_xored_spm_write_wide_wdata_219 <= { read_burst_rdata_218, _axis_out_xored_spm_write_wide_wdata_219[127:64] };
            _axis_out_xored_spm_write_wide_count_210 <= _axis_out_xored_spm_write_wide_count_210 + 1;
          end 
          if(read_burst_rvalid_214 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_210 > 0)) && (_axis_out_xored_spm_write_wide_count_210 == 1)) begin
            _axis_out_xored_spm_write_wide_count_210 <= 0;
          end 
          if((_axis_out_xored_spm_write_wide_count_210 == 1) && read_burst_rvalid_214 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_210 > 0)) && read_burst_rlast_215) begin
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
      read_burst_addr_211 <= 0;
      read_burst_stride_212 <= 0;
      read_burst_length_213 <= 0;
      read_burst_rvalid_214 <= 0;
      read_burst_rlast_215 <= 0;
    end else begin
      case(read_burst_fsm_6)
        read_burst_fsm_6_init: begin
          read_burst_addr_211 <= _axis_out_xored_spm_write_local_addr_buf;
          read_burst_stride_212 <= _axis_out_xored_spm_write_local_stride_buf;
          read_burst_length_213 <= _axis_out_xored_spm_write_size_buf;
          read_burst_rvalid_214 <= 0;
          read_burst_rlast_215 <= 0;
          if((_axis_out_xored_spm_write_data_wide_fsm == 1) && (_axis_out_xored_spm_write_op_sel_buf == 1) && (_axis_out_xored_spm_write_size_buf > 0)) begin
            read_burst_fsm_6 <= read_burst_fsm_6_1;
          end 
        end
        read_burst_fsm_6_1: begin
          if((axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_210 > 0)) && (read_burst_length_213 > 0)) begin
            read_burst_addr_211 <= read_burst_addr_211 + read_burst_stride_212;
            read_burst_length_213 <= read_burst_length_213 - 1;
            read_burst_rvalid_214 <= 1;
          end 
          if((axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_210 > 0)) && (read_burst_length_213 <= 1)) begin
            read_burst_rlast_215 <= 1;
          end 
          if(read_burst_rlast_215 && read_burst_rvalid_214 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_210 > 0))) begin
            read_burst_rvalid_214 <= 0;
            read_burst_rlast_215 <= 0;
          end 
          if(0) begin
            read_burst_rvalid_214 <= 0;
            read_burst_rlast_215 <= 0;
          end 
          if(read_burst_rlast_215 && read_burst_rvalid_214 && (axis_out_xored_spm_tready || !axis_out_xored_spm_tvalid || (_axis_out_xored_spm_write_wide_count_210 > 0))) begin
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

