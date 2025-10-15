

module test_double
(

);

  reg CLK;
  reg RST;
  reg [4-1:0] axi_s_ctrl_double_awid;
  reg [32-1:0] axi_s_ctrl_double_awaddr;
  reg [8-1:0] axi_s_ctrl_double_awlen;
  reg [3-1:0] axi_s_ctrl_double_awsize;
  reg [2-1:0] axi_s_ctrl_double_awburst;
  reg [1-1:0] axi_s_ctrl_double_awlock;
  reg [4-1:0] axi_s_ctrl_double_awcache;
  reg [3-1:0] axi_s_ctrl_double_awprot;
  reg [4-1:0] axi_s_ctrl_double_awqos;
  reg [2-1:0] axi_s_ctrl_double_awuser;
  reg axi_s_ctrl_double_awvalid;
  wire axi_s_ctrl_double_awready;
  reg [64-1:0] axi_s_ctrl_double_wdata;
  reg [8-1:0] axi_s_ctrl_double_wstrb;
  reg axi_s_ctrl_double_wlast;
  reg axi_s_ctrl_double_wvalid;
  wire axi_s_ctrl_double_wready;
  wire [4-1:0] axi_s_ctrl_double_bid;
  wire [2-1:0] axi_s_ctrl_double_bresp;
  wire axi_s_ctrl_double_bvalid;
  reg axi_s_ctrl_double_bready;
  reg [4-1:0] axi_s_ctrl_double_arid;
  reg [32-1:0] axi_s_ctrl_double_araddr;
  reg [8-1:0] axi_s_ctrl_double_arlen;
  reg [3-1:0] axi_s_ctrl_double_arsize;
  reg [2-1:0] axi_s_ctrl_double_arburst;
  reg [1-1:0] axi_s_ctrl_double_arlock;
  reg [4-1:0] axi_s_ctrl_double_arcache;
  reg [3-1:0] axi_s_ctrl_double_arprot;
  reg [4-1:0] axi_s_ctrl_double_arqos;
  reg [2-1:0] axi_s_ctrl_double_aruser;
  reg axi_s_ctrl_double_arvalid;
  wire axi_s_ctrl_double_arready;
  wire [4-1:0] axi_s_ctrl_double_rid;
  wire [64-1:0] axi_s_ctrl_double_rdata;
  wire [2-1:0] axi_s_ctrl_double_rresp;
  wire axi_s_ctrl_double_rlast;
  wire axi_s_ctrl_double_rvalid;
  reg axi_s_ctrl_double_rready;
  reg [32-1:0] maxi_double_awaddr;
  reg [8-1:0] maxi_double_awlen;
  wire [3-1:0] maxi_double_awsize;
  wire [2-1:0] maxi_double_awburst;
  wire [1-1:0] maxi_double_awlock;
  wire [4-1:0] maxi_double_awcache;
  wire [3-1:0] maxi_double_awprot;
  wire [4-1:0] maxi_double_awqos;
  wire [2-1:0] maxi_double_awuser;
  reg maxi_double_awvalid;
  wire maxi_double_awready;
  assign maxi_double_awsize = 3;
  assign maxi_double_awburst = 1;
  assign maxi_double_awlock = 0;
  assign maxi_double_awcache = 3;
  assign maxi_double_awprot = 0;
  assign maxi_double_awqos = 0;
  assign maxi_double_awuser = 0;
  wire [64-1:0] maxi_double_wdata;
  wire [8-1:0] maxi_double_wstrb;
  wire maxi_double_wlast;
  wire maxi_double_wvalid;
  wire maxi_double_wready;
  reg [64-1:0] _maxi_double_wdata_sb_0;
  reg [8-1:0] _maxi_double_wstrb_sb_0;
  reg _maxi_double_wlast_sb_0;
  reg _maxi_double_wvalid_sb_0;
  wire _maxi_double_wready_sb_0;
  wire _sb_maxi_double_writedata_s_value_0;
  assign _sb_maxi_double_writedata_s_value_0 = _maxi_double_wlast_sb_0;
  wire [8-1:0] _sb_maxi_double_writedata_s_value_1;
  assign _sb_maxi_double_writedata_s_value_1 = _maxi_double_wstrb_sb_0;
  wire [64-1:0] _sb_maxi_double_writedata_s_value_2;
  assign _sb_maxi_double_writedata_s_value_2 = _maxi_double_wdata_sb_0;
  wire [73-1:0] _sb_maxi_double_writedata_s_data_3;
  assign _sb_maxi_double_writedata_s_data_3 = { _sb_maxi_double_writedata_s_value_0, _sb_maxi_double_writedata_s_value_1, _sb_maxi_double_writedata_s_value_2 };
  wire _sb_maxi_double_writedata_s_valid_4;
  assign _sb_maxi_double_writedata_s_valid_4 = _maxi_double_wvalid_sb_0;
  wire _sb_maxi_double_writedata_m_ready_5;
  assign _sb_maxi_double_writedata_m_ready_5 = maxi_double_wready;
  reg [73-1:0] _sb_maxi_double_writedata_data_6;
  reg _sb_maxi_double_writedata_valid_7;
  wire _sb_maxi_double_writedata_ready_8;
  reg [73-1:0] _sb_maxi_double_writedata_tmp_data_9;
  reg _sb_maxi_double_writedata_tmp_valid_10;
  wire [73-1:0] _sb_maxi_double_writedata_next_data_11;
  wire _sb_maxi_double_writedata_next_valid_12;
  assign _sb_maxi_double_writedata_ready_8 = !_sb_maxi_double_writedata_tmp_valid_10;
  assign _sb_maxi_double_writedata_next_data_11 = (_sb_maxi_double_writedata_tmp_valid_10)? _sb_maxi_double_writedata_tmp_data_9 : _sb_maxi_double_writedata_s_data_3;
  assign _sb_maxi_double_writedata_next_valid_12 = _sb_maxi_double_writedata_tmp_valid_10 || _sb_maxi_double_writedata_s_valid_4;
  wire _sb_maxi_double_writedata_m_value_13;
  assign _sb_maxi_double_writedata_m_value_13 = _sb_maxi_double_writedata_data_6[72:72];
  wire [8-1:0] _sb_maxi_double_writedata_m_value_14;
  assign _sb_maxi_double_writedata_m_value_14 = _sb_maxi_double_writedata_data_6[71:64];
  wire [64-1:0] _sb_maxi_double_writedata_m_value_15;
  assign _sb_maxi_double_writedata_m_value_15 = _sb_maxi_double_writedata_data_6[63:0];
  assign _maxi_double_wready_sb_0 = _sb_maxi_double_writedata_ready_8;
  assign maxi_double_wdata = _sb_maxi_double_writedata_m_value_15;
  assign maxi_double_wstrb = _sb_maxi_double_writedata_m_value_14;
  assign maxi_double_wlast = _sb_maxi_double_writedata_m_value_13;
  assign maxi_double_wvalid = _sb_maxi_double_writedata_valid_7;
  wire [2-1:0] maxi_double_bresp;
  wire maxi_double_bvalid;
  wire maxi_double_bready;
  assign maxi_double_bready = 1;
  reg [32-1:0] maxi_double_araddr;
  reg [8-1:0] maxi_double_arlen;
  wire [3-1:0] maxi_double_arsize;
  wire [2-1:0] maxi_double_arburst;
  wire [1-1:0] maxi_double_arlock;
  wire [4-1:0] maxi_double_arcache;
  wire [3-1:0] maxi_double_arprot;
  wire [4-1:0] maxi_double_arqos;
  wire [2-1:0] maxi_double_aruser;
  reg maxi_double_arvalid;
  wire maxi_double_arready;
  assign maxi_double_arsize = 3;
  assign maxi_double_arburst = 1;
  assign maxi_double_arlock = 0;
  assign maxi_double_arcache = 3;
  assign maxi_double_arprot = 0;
  assign maxi_double_arqos = 0;
  assign maxi_double_aruser = 0;
  wire [64-1:0] maxi_double_rdata;
  wire [2-1:0] maxi_double_rresp;
  wire maxi_double_rlast;
  wire maxi_double_rvalid;
  wire maxi_double_rready;
  wire [64-1:0] _maxi_double_rdata_sb_0;
  wire _maxi_double_rlast_sb_0;
  wire _maxi_double_rvalid_sb_0;
  wire _maxi_double_rready_sb_0;
  wire _sb_maxi_double_readdata_s_value_16;
  assign _sb_maxi_double_readdata_s_value_16 = maxi_double_rlast;
  wire [64-1:0] _sb_maxi_double_readdata_s_value_17;
  assign _sb_maxi_double_readdata_s_value_17 = maxi_double_rdata;
  wire [65-1:0] _sb_maxi_double_readdata_s_data_18;
  assign _sb_maxi_double_readdata_s_data_18 = { _sb_maxi_double_readdata_s_value_16, _sb_maxi_double_readdata_s_value_17 };
  wire _sb_maxi_double_readdata_s_valid_19;
  assign _sb_maxi_double_readdata_s_valid_19 = maxi_double_rvalid;
  wire _sb_maxi_double_readdata_m_ready_20;
  assign _sb_maxi_double_readdata_m_ready_20 = _maxi_double_rready_sb_0;
  reg [65-1:0] _sb_maxi_double_readdata_data_21;
  reg _sb_maxi_double_readdata_valid_22;
  wire _sb_maxi_double_readdata_ready_23;
  reg [65-1:0] _sb_maxi_double_readdata_tmp_data_24;
  reg _sb_maxi_double_readdata_tmp_valid_25;
  wire [65-1:0] _sb_maxi_double_readdata_next_data_26;
  wire _sb_maxi_double_readdata_next_valid_27;
  assign _sb_maxi_double_readdata_ready_23 = !_sb_maxi_double_readdata_tmp_valid_25;
  assign _sb_maxi_double_readdata_next_data_26 = (_sb_maxi_double_readdata_tmp_valid_25)? _sb_maxi_double_readdata_tmp_data_24 : _sb_maxi_double_readdata_s_data_18;
  assign _sb_maxi_double_readdata_next_valid_27 = _sb_maxi_double_readdata_tmp_valid_25 || _sb_maxi_double_readdata_s_valid_19;
  wire _sb_maxi_double_readdata_m_value_28;
  assign _sb_maxi_double_readdata_m_value_28 = _sb_maxi_double_readdata_data_21[64:64];
  wire [64-1:0] _sb_maxi_double_readdata_m_value_29;
  assign _sb_maxi_double_readdata_m_value_29 = _sb_maxi_double_readdata_data_21[63:0];
  assign _maxi_double_rdata_sb_0 = _sb_maxi_double_readdata_m_value_29;
  assign _maxi_double_rlast_sb_0 = _sb_maxi_double_readdata_m_value_28;
  assign _maxi_double_rvalid_sb_0 = _sb_maxi_double_readdata_valid_22;
  assign maxi_double_rready = _sb_maxi_double_readdata_ready_23;
  reg [3-1:0] _maxi_double_outstanding_wcount;
  wire _maxi_double_has_outstanding_write;
  assign _maxi_double_has_outstanding_write = (_maxi_double_outstanding_wcount > 0) || maxi_double_awvalid;
  reg _maxi_double_read_start;
  reg [8-1:0] _maxi_double_read_op_sel;
  reg [32-1:0] _maxi_double_read_global_addr;
  reg [33-1:0] _maxi_double_read_global_size;
  reg [32-1:0] _maxi_double_read_local_addr;
  reg [32-1:0] _maxi_double_read_local_stride;
  reg [33-1:0] _maxi_double_read_local_size;
  reg [32-1:0] _maxi_double_read_local_blocksize;
  wire _maxi_double_read_req_fifo_enq;
  wire [137-1:0] _maxi_double_read_req_fifo_wdata;
  wire _maxi_double_read_req_fifo_full;
  wire _maxi_double_read_req_fifo_almost_full;
  wire _maxi_double_read_req_fifo_deq;
  wire [137-1:0] _maxi_double_read_req_fifo_rdata;
  wire _maxi_double_read_req_fifo_empty;
  wire _maxi_double_read_req_fifo_almost_empty;
  assign _maxi_double_read_req_fifo_enq = 0;
  assign _maxi_double_read_req_fifo_wdata = 'hx;
  assign _maxi_double_read_req_fifo_deq = 0;

  _maxi_double_read_req_fifo
  inst__maxi_double_read_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._maxi_double_read_req_fifo_enq(_maxi_double_read_req_fifo_enq),
    ._maxi_double_read_req_fifo_wdata(_maxi_double_read_req_fifo_wdata),
    ._maxi_double_read_req_fifo_full(_maxi_double_read_req_fifo_full),
    ._maxi_double_read_req_fifo_almost_full(_maxi_double_read_req_fifo_almost_full),
    ._maxi_double_read_req_fifo_deq(_maxi_double_read_req_fifo_deq),
    ._maxi_double_read_req_fifo_rdata(_maxi_double_read_req_fifo_rdata),
    ._maxi_double_read_req_fifo_empty(_maxi_double_read_req_fifo_empty),
    ._maxi_double_read_req_fifo_almost_empty(_maxi_double_read_req_fifo_almost_empty)
  );

  reg [4-1:0] count__maxi_double_read_req_fifo;
  wire [8-1:0] _maxi_double_read_op_sel_fifo;
  wire [32-1:0] _maxi_double_read_local_addr_fifo;
  wire [32-1:0] _maxi_double_read_local_stride_fifo;
  wire [33-1:0] _maxi_double_read_local_size_fifo;
  wire [32-1:0] _maxi_double_read_local_blocksize_fifo;
  wire [8-1:0] unpack_read_req_op_sel_30;
  wire [32-1:0] unpack_read_req_local_addr_31;
  wire [32-1:0] unpack_read_req_local_stride_32;
  wire [33-1:0] unpack_read_req_local_size_33;
  wire [32-1:0] unpack_read_req_local_blocksize_34;
  assign unpack_read_req_op_sel_30 = _maxi_double_read_req_fifo_rdata[136:129];
  assign unpack_read_req_local_addr_31 = _maxi_double_read_req_fifo_rdata[128:97];
  assign unpack_read_req_local_stride_32 = _maxi_double_read_req_fifo_rdata[96:65];
  assign unpack_read_req_local_size_33 = _maxi_double_read_req_fifo_rdata[64:32];
  assign unpack_read_req_local_blocksize_34 = _maxi_double_read_req_fifo_rdata[31:0];
  assign _maxi_double_read_op_sel_fifo = unpack_read_req_op_sel_30;
  assign _maxi_double_read_local_addr_fifo = unpack_read_req_local_addr_31;
  assign _maxi_double_read_local_stride_fifo = unpack_read_req_local_stride_32;
  assign _maxi_double_read_local_size_fifo = unpack_read_req_local_size_33;
  assign _maxi_double_read_local_blocksize_fifo = unpack_read_req_local_blocksize_34;
  reg [8-1:0] _maxi_double_read_op_sel_buf;
  reg [32-1:0] _maxi_double_read_local_addr_buf;
  reg [32-1:0] _maxi_double_read_local_stride_buf;
  reg [33-1:0] _maxi_double_read_local_size_buf;
  reg [32-1:0] _maxi_double_read_local_blocksize_buf;
  reg _maxi_double_read_req_busy;
  reg _maxi_double_read_data_busy;
  wire _maxi_double_read_req_idle;
  wire _maxi_double_read_data_idle;
  wire _maxi_double_read_idle;
  assign _maxi_double_read_req_idle = !_maxi_double_read_start && !_maxi_double_read_req_busy;
  assign _maxi_double_read_data_idle = _maxi_double_read_req_fifo_empty && !_maxi_double_read_data_busy;
  assign _maxi_double_read_idle = _maxi_double_read_req_idle && _maxi_double_read_data_idle;
  reg _maxi_double_write_start;
  reg [8-1:0] _maxi_double_write_op_sel;
  reg [32-1:0] _maxi_double_write_global_addr;
  reg [33-1:0] _maxi_double_write_global_size;
  reg [32-1:0] _maxi_double_write_local_addr;
  reg [32-1:0] _maxi_double_write_local_stride;
  reg [33-1:0] _maxi_double_write_local_size;
  reg [32-1:0] _maxi_double_write_local_blocksize;
  wire _maxi_double_write_req_fifo_enq;
  wire [137-1:0] _maxi_double_write_req_fifo_wdata;
  wire _maxi_double_write_req_fifo_full;
  wire _maxi_double_write_req_fifo_almost_full;
  wire _maxi_double_write_req_fifo_deq;
  wire [137-1:0] _maxi_double_write_req_fifo_rdata;
  wire _maxi_double_write_req_fifo_empty;
  wire _maxi_double_write_req_fifo_almost_empty;
  assign _maxi_double_write_req_fifo_enq = 0;
  assign _maxi_double_write_req_fifo_wdata = 'hx;
  assign _maxi_double_write_req_fifo_deq = 0;

  _maxi_double_write_req_fifo
  inst__maxi_double_write_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._maxi_double_write_req_fifo_enq(_maxi_double_write_req_fifo_enq),
    ._maxi_double_write_req_fifo_wdata(_maxi_double_write_req_fifo_wdata),
    ._maxi_double_write_req_fifo_full(_maxi_double_write_req_fifo_full),
    ._maxi_double_write_req_fifo_almost_full(_maxi_double_write_req_fifo_almost_full),
    ._maxi_double_write_req_fifo_deq(_maxi_double_write_req_fifo_deq),
    ._maxi_double_write_req_fifo_rdata(_maxi_double_write_req_fifo_rdata),
    ._maxi_double_write_req_fifo_empty(_maxi_double_write_req_fifo_empty),
    ._maxi_double_write_req_fifo_almost_empty(_maxi_double_write_req_fifo_almost_empty)
  );

  reg [4-1:0] count__maxi_double_write_req_fifo;
  wire [8-1:0] _maxi_double_write_op_sel_fifo;
  wire [32-1:0] _maxi_double_write_local_addr_fifo;
  wire [32-1:0] _maxi_double_write_local_stride_fifo;
  wire [33-1:0] _maxi_double_write_size_fifo;
  wire [32-1:0] _maxi_double_write_local_blocksize_fifo;
  wire [8-1:0] unpack_write_req_op_sel_35;
  wire [32-1:0] unpack_write_req_local_addr_36;
  wire [32-1:0] unpack_write_req_local_stride_37;
  wire [33-1:0] unpack_write_req_size_38;
  wire [32-1:0] unpack_write_req_local_blocksize_39;
  assign unpack_write_req_op_sel_35 = _maxi_double_write_req_fifo_rdata[136:129];
  assign unpack_write_req_local_addr_36 = _maxi_double_write_req_fifo_rdata[128:97];
  assign unpack_write_req_local_stride_37 = _maxi_double_write_req_fifo_rdata[96:65];
  assign unpack_write_req_size_38 = _maxi_double_write_req_fifo_rdata[64:32];
  assign unpack_write_req_local_blocksize_39 = _maxi_double_write_req_fifo_rdata[31:0];
  assign _maxi_double_write_op_sel_fifo = unpack_write_req_op_sel_35;
  assign _maxi_double_write_local_addr_fifo = unpack_write_req_local_addr_36;
  assign _maxi_double_write_local_stride_fifo = unpack_write_req_local_stride_37;
  assign _maxi_double_write_size_fifo = unpack_write_req_size_38;
  assign _maxi_double_write_local_blocksize_fifo = unpack_write_req_local_blocksize_39;
  reg [8-1:0] _maxi_double_write_op_sel_buf;
  reg [32-1:0] _maxi_double_write_local_addr_buf;
  reg [32-1:0] _maxi_double_write_local_stride_buf;
  reg [33-1:0] _maxi_double_write_size_buf;
  reg [32-1:0] _maxi_double_write_local_blocksize_buf;
  reg _maxi_double_write_req_busy;
  reg _maxi_double_write_data_busy;
  wire _maxi_double_write_req_idle;
  wire _maxi_double_write_data_idle;
  wire _maxi_double_write_idle;
  assign _maxi_double_write_req_idle = !_maxi_double_write_start && !_maxi_double_write_req_busy;
  assign _maxi_double_write_data_idle = _maxi_double_write_req_fifo_empty && !_maxi_double_write_data_busy;
  assign _maxi_double_write_idle = _maxi_double_write_req_idle && _maxi_double_write_data_idle;
  wire [4-1:0] _tmp_40;
  assign _tmp_40 = 0;

  always @(*) begin
    axi_s_ctrl_double_awid = _tmp_40;
  end

  wire [32-1:0] _tmp_41;
  assign _tmp_41 = maxi_double_awaddr;

  always @(*) begin
    axi_s_ctrl_double_awaddr = _tmp_41;
  end

  wire [8-1:0] _tmp_42;
  assign _tmp_42 = maxi_double_awlen;

  always @(*) begin
    axi_s_ctrl_double_awlen = _tmp_42;
  end

  wire [3-1:0] _tmp_43;
  assign _tmp_43 = maxi_double_awsize;

  always @(*) begin
    axi_s_ctrl_double_awsize = _tmp_43;
  end

  wire [2-1:0] _tmp_44;
  assign _tmp_44 = maxi_double_awburst;

  always @(*) begin
    axi_s_ctrl_double_awburst = _tmp_44;
  end

  wire [1-1:0] _tmp_45;
  assign _tmp_45 = maxi_double_awlock;

  always @(*) begin
    axi_s_ctrl_double_awlock = _tmp_45;
  end

  wire [4-1:0] _tmp_46;
  assign _tmp_46 = maxi_double_awcache;

  always @(*) begin
    axi_s_ctrl_double_awcache = _tmp_46;
  end

  wire [3-1:0] _tmp_47;
  assign _tmp_47 = maxi_double_awprot;

  always @(*) begin
    axi_s_ctrl_double_awprot = _tmp_47;
  end

  wire [4-1:0] _tmp_48;
  assign _tmp_48 = maxi_double_awqos;

  always @(*) begin
    axi_s_ctrl_double_awqos = _tmp_48;
  end

  wire [2-1:0] _tmp_49;
  assign _tmp_49 = maxi_double_awuser;

  always @(*) begin
    axi_s_ctrl_double_awuser = _tmp_49;
  end

  wire _tmp_50;
  assign _tmp_50 = maxi_double_awvalid;

  always @(*) begin
    axi_s_ctrl_double_awvalid = _tmp_50;
  end

  assign maxi_double_awready = axi_s_ctrl_double_awready;
  wire [64-1:0] _tmp_51;
  assign _tmp_51 = maxi_double_wdata;

  always @(*) begin
    axi_s_ctrl_double_wdata = _tmp_51;
  end

  wire [8-1:0] _tmp_52;
  assign _tmp_52 = maxi_double_wstrb;

  always @(*) begin
    axi_s_ctrl_double_wstrb = _tmp_52;
  end

  wire _tmp_53;
  assign _tmp_53 = maxi_double_wlast;

  always @(*) begin
    axi_s_ctrl_double_wlast = _tmp_53;
  end

  wire _tmp_54;
  assign _tmp_54 = maxi_double_wvalid;

  always @(*) begin
    axi_s_ctrl_double_wvalid = _tmp_54;
  end

  assign maxi_double_wready = axi_s_ctrl_double_wready;
  assign maxi_double_bresp = axi_s_ctrl_double_bresp;
  assign maxi_double_bvalid = axi_s_ctrl_double_bvalid;
  wire _tmp_55;
  assign _tmp_55 = maxi_double_bready;

  always @(*) begin
    axi_s_ctrl_double_bready = _tmp_55;
  end

  wire [4-1:0] _tmp_56;
  assign _tmp_56 = 0;

  always @(*) begin
    axi_s_ctrl_double_arid = _tmp_56;
  end

  wire [32-1:0] _tmp_57;
  assign _tmp_57 = maxi_double_araddr;

  always @(*) begin
    axi_s_ctrl_double_araddr = _tmp_57;
  end

  wire [8-1:0] _tmp_58;
  assign _tmp_58 = maxi_double_arlen;

  always @(*) begin
    axi_s_ctrl_double_arlen = _tmp_58;
  end

  wire [3-1:0] _tmp_59;
  assign _tmp_59 = maxi_double_arsize;

  always @(*) begin
    axi_s_ctrl_double_arsize = _tmp_59;
  end

  wire [2-1:0] _tmp_60;
  assign _tmp_60 = maxi_double_arburst;

  always @(*) begin
    axi_s_ctrl_double_arburst = _tmp_60;
  end

  wire [1-1:0] _tmp_61;
  assign _tmp_61 = maxi_double_arlock;

  always @(*) begin
    axi_s_ctrl_double_arlock = _tmp_61;
  end

  wire [4-1:0] _tmp_62;
  assign _tmp_62 = maxi_double_arcache;

  always @(*) begin
    axi_s_ctrl_double_arcache = _tmp_62;
  end

  wire [3-1:0] _tmp_63;
  assign _tmp_63 = maxi_double_arprot;

  always @(*) begin
    axi_s_ctrl_double_arprot = _tmp_63;
  end

  wire [4-1:0] _tmp_64;
  assign _tmp_64 = maxi_double_arqos;

  always @(*) begin
    axi_s_ctrl_double_arqos = _tmp_64;
  end

  wire [2-1:0] _tmp_65;
  assign _tmp_65 = maxi_double_aruser;

  always @(*) begin
    axi_s_ctrl_double_aruser = _tmp_65;
  end

  wire _tmp_66;
  assign _tmp_66 = maxi_double_arvalid;

  always @(*) begin
    axi_s_ctrl_double_arvalid = _tmp_66;
  end

  assign maxi_double_arready = axi_s_ctrl_double_arready;
  assign maxi_double_rdata = axi_s_ctrl_double_rdata;
  assign maxi_double_rresp = axi_s_ctrl_double_rresp;
  assign maxi_double_rlast = axi_s_ctrl_double_rlast;
  assign maxi_double_rvalid = axi_s_ctrl_double_rvalid;
  wire _tmp_67;
  assign _tmp_67 = maxi_double_rready;

  always @(*) begin
    axi_s_ctrl_double_rready = _tmp_67;
  end

  reg [64-1:0] data_68;
  reg [32-1:0] th_ctrl;
  localparam th_ctrl_init = 0;
  reg _maxi_double_waddr_cond_0_1;
  reg _maxi_double_wdata_cond_0_1;
  reg _maxi_double_raddr_cond_0_1;
  reg signed [64-1:0] axim_rdata_69;
  reg _maxi_double_raddr_cond_1_1;
  reg signed [64-1:0] axim_rdata_70;
  assign _maxi_double_rready_sb_0 = (th_ctrl == 6) || (th_ctrl == 11);

  double
  uut
  (
    .CLK(CLK),
    .RST(RST),
    .axi_s_ctrl_double_awid(axi_s_ctrl_double_awid),
    .axi_s_ctrl_double_awaddr(axi_s_ctrl_double_awaddr),
    .axi_s_ctrl_double_awlen(axi_s_ctrl_double_awlen),
    .axi_s_ctrl_double_awsize(axi_s_ctrl_double_awsize),
    .axi_s_ctrl_double_awburst(axi_s_ctrl_double_awburst),
    .axi_s_ctrl_double_awlock(axi_s_ctrl_double_awlock),
    .axi_s_ctrl_double_awcache(axi_s_ctrl_double_awcache),
    .axi_s_ctrl_double_awprot(axi_s_ctrl_double_awprot),
    .axi_s_ctrl_double_awqos(axi_s_ctrl_double_awqos),
    .axi_s_ctrl_double_awuser(axi_s_ctrl_double_awuser),
    .axi_s_ctrl_double_awvalid(axi_s_ctrl_double_awvalid),
    .axi_s_ctrl_double_awready(axi_s_ctrl_double_awready),
    .axi_s_ctrl_double_wdata(axi_s_ctrl_double_wdata),
    .axi_s_ctrl_double_wstrb(axi_s_ctrl_double_wstrb),
    .axi_s_ctrl_double_wlast(axi_s_ctrl_double_wlast),
    .axi_s_ctrl_double_wvalid(axi_s_ctrl_double_wvalid),
    .axi_s_ctrl_double_wready(axi_s_ctrl_double_wready),
    .axi_s_ctrl_double_bid(axi_s_ctrl_double_bid),
    .axi_s_ctrl_double_bresp(axi_s_ctrl_double_bresp),
    .axi_s_ctrl_double_bvalid(axi_s_ctrl_double_bvalid),
    .axi_s_ctrl_double_bready(axi_s_ctrl_double_bready),
    .axi_s_ctrl_double_arid(axi_s_ctrl_double_arid),
    .axi_s_ctrl_double_araddr(axi_s_ctrl_double_araddr),
    .axi_s_ctrl_double_arlen(axi_s_ctrl_double_arlen),
    .axi_s_ctrl_double_arsize(axi_s_ctrl_double_arsize),
    .axi_s_ctrl_double_arburst(axi_s_ctrl_double_arburst),
    .axi_s_ctrl_double_arlock(axi_s_ctrl_double_arlock),
    .axi_s_ctrl_double_arcache(axi_s_ctrl_double_arcache),
    .axi_s_ctrl_double_arprot(axi_s_ctrl_double_arprot),
    .axi_s_ctrl_double_arqos(axi_s_ctrl_double_arqos),
    .axi_s_ctrl_double_aruser(axi_s_ctrl_double_aruser),
    .axi_s_ctrl_double_arvalid(axi_s_ctrl_double_arvalid),
    .axi_s_ctrl_double_arready(axi_s_ctrl_double_arready),
    .axi_s_ctrl_double_rid(axi_s_ctrl_double_rid),
    .axi_s_ctrl_double_rdata(axi_s_ctrl_double_rdata),
    .axi_s_ctrl_double_rresp(axi_s_ctrl_double_rresp),
    .axi_s_ctrl_double_rlast(axi_s_ctrl_double_rlast),
    .axi_s_ctrl_double_rvalid(axi_s_ctrl_double_rvalid),
    .axi_s_ctrl_double_rready(axi_s_ctrl_double_rready)
  );


  initial begin
    $dumpfile("double_device.vcd");
    $dumpvars(0, uut);
  end


  initial begin
    CLK = 0;
    forever begin
      #5 CLK = !CLK;
    end
  end


  initial begin
    RST = 0;
    maxi_double_awaddr = 0;
    maxi_double_awlen = 0;
    maxi_double_awvalid = 0;
    _maxi_double_wdata_sb_0 = 0;
    _maxi_double_wstrb_sb_0 = 0;
    _maxi_double_wlast_sb_0 = 0;
    _maxi_double_wvalid_sb_0 = 0;
    _sb_maxi_double_writedata_data_6 = 0;
    _sb_maxi_double_writedata_valid_7 = 0;
    _sb_maxi_double_writedata_tmp_data_9 = 0;
    _sb_maxi_double_writedata_tmp_valid_10 = 0;
    maxi_double_araddr = 0;
    maxi_double_arlen = 0;
    maxi_double_arvalid = 0;
    _sb_maxi_double_readdata_data_21 = 0;
    _sb_maxi_double_readdata_valid_22 = 0;
    _sb_maxi_double_readdata_tmp_data_24 = 0;
    _sb_maxi_double_readdata_tmp_valid_25 = 0;
    _maxi_double_outstanding_wcount = 0;
    _maxi_double_read_start = 0;
    _maxi_double_read_op_sel = 0;
    _maxi_double_read_global_addr = 0;
    _maxi_double_read_global_size = 0;
    _maxi_double_read_local_addr = 0;
    _maxi_double_read_local_stride = 0;
    _maxi_double_read_local_size = 0;
    _maxi_double_read_local_blocksize = 0;
    count__maxi_double_read_req_fifo = 0;
    _maxi_double_read_op_sel_buf = 0;
    _maxi_double_read_local_addr_buf = 0;
    _maxi_double_read_local_stride_buf = 0;
    _maxi_double_read_local_size_buf = 0;
    _maxi_double_read_local_blocksize_buf = 0;
    _maxi_double_read_req_busy = 0;
    _maxi_double_read_data_busy = 0;
    _maxi_double_write_start = 0;
    _maxi_double_write_op_sel = 0;
    _maxi_double_write_global_addr = 0;
    _maxi_double_write_global_size = 0;
    _maxi_double_write_local_addr = 0;
    _maxi_double_write_local_stride = 0;
    _maxi_double_write_local_size = 0;
    _maxi_double_write_local_blocksize = 0;
    count__maxi_double_write_req_fifo = 0;
    _maxi_double_write_op_sel_buf = 0;
    _maxi_double_write_local_addr_buf = 0;
    _maxi_double_write_local_stride_buf = 0;
    _maxi_double_write_size_buf = 0;
    _maxi_double_write_local_blocksize_buf = 0;
    _maxi_double_write_req_busy = 0;
    _maxi_double_write_data_busy = 0;
    data_68 = 0;
    th_ctrl = th_ctrl_init;
    _maxi_double_waddr_cond_0_1 = 0;
    _maxi_double_wdata_cond_0_1 = 0;
    _maxi_double_raddr_cond_0_1 = 0;
    axim_rdata_69 = 0;
    _maxi_double_raddr_cond_1_1 = 0;
    axim_rdata_70 = 0;
    #100;
    RST = 1;
    #100;
    RST = 0;
    #1000000;
    $finish;
  end


  always @(posedge CLK) begin
    if(RST) begin
      maxi_double_awaddr <= 0;
      maxi_double_awlen <= 0;
      maxi_double_awvalid <= 0;
      _maxi_double_waddr_cond_0_1 <= 0;
    end else begin
      if(_maxi_double_waddr_cond_0_1) begin
        maxi_double_awvalid <= 0;
      end 
      if((th_ctrl == 2) && ((_maxi_double_outstanding_wcount < 6) && (maxi_double_awready || !maxi_double_awvalid))) begin
        maxi_double_awaddr <= 0;
        maxi_double_awlen <= 0;
        maxi_double_awvalid <= 1;
      end 
      if((th_ctrl == 2) && ((_maxi_double_outstanding_wcount < 6) && (maxi_double_awready || !maxi_double_awvalid)) && 0) begin
        maxi_double_awvalid <= 0;
      end 
      _maxi_double_waddr_cond_0_1 <= 1;
      if(maxi_double_awvalid && !maxi_double_awready) begin
        maxi_double_awvalid <= maxi_double_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _maxi_double_wdata_sb_0 <= 0;
      _maxi_double_wvalid_sb_0 <= 0;
      _maxi_double_wlast_sb_0 <= 0;
      _maxi_double_wstrb_sb_0 <= 0;
      _maxi_double_wdata_cond_0_1 <= 0;
    end else begin
      if(_maxi_double_wdata_cond_0_1) begin
        _maxi_double_wvalid_sb_0 <= 0;
        _maxi_double_wlast_sb_0 <= 0;
      end 
      if((th_ctrl == 3) && (_maxi_double_wready_sb_0 || !_maxi_double_wvalid_sb_0)) begin
        _maxi_double_wdata_sb_0 <= 3;
        _maxi_double_wvalid_sb_0 <= 1;
        _maxi_double_wlast_sb_0 <= 1;
        _maxi_double_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_double_wdata_cond_0_1 <= 1;
      if(_maxi_double_wvalid_sb_0 && !_maxi_double_wready_sb_0) begin
        _maxi_double_wvalid_sb_0 <= _maxi_double_wvalid_sb_0;
        _maxi_double_wlast_sb_0 <= _maxi_double_wlast_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_double_writedata_data_6 <= 0;
      _sb_maxi_double_writedata_valid_7 <= 0;
      _sb_maxi_double_writedata_tmp_data_9 <= 0;
      _sb_maxi_double_writedata_tmp_valid_10 <= 0;
    end else begin
      if(_sb_maxi_double_writedata_m_ready_5 || !_sb_maxi_double_writedata_valid_7) begin
        _sb_maxi_double_writedata_data_6 <= _sb_maxi_double_writedata_next_data_11;
        _sb_maxi_double_writedata_valid_7 <= _sb_maxi_double_writedata_next_valid_12;
      end 
      if(!_sb_maxi_double_writedata_tmp_valid_10 && _sb_maxi_double_writedata_valid_7 && !_sb_maxi_double_writedata_m_ready_5) begin
        _sb_maxi_double_writedata_tmp_data_9 <= _sb_maxi_double_writedata_s_data_3;
        _sb_maxi_double_writedata_tmp_valid_10 <= _sb_maxi_double_writedata_s_valid_4;
      end 
      if(_sb_maxi_double_writedata_tmp_valid_10 && _sb_maxi_double_writedata_m_ready_5) begin
        _sb_maxi_double_writedata_tmp_valid_10 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      maxi_double_araddr <= 0;
      maxi_double_arlen <= 0;
      maxi_double_arvalid <= 0;
      _maxi_double_raddr_cond_0_1 <= 0;
      _maxi_double_raddr_cond_1_1 <= 0;
    end else begin
      if(_maxi_double_raddr_cond_0_1) begin
        maxi_double_arvalid <= 0;
      end 
      if(_maxi_double_raddr_cond_1_1) begin
        maxi_double_arvalid <= 0;
      end 
      if((th_ctrl == 5) && (maxi_double_arready || !maxi_double_arvalid)) begin
        maxi_double_araddr <= 8;
        maxi_double_arlen <= 0;
        maxi_double_arvalid <= 1;
      end 
      _maxi_double_raddr_cond_0_1 <= 1;
      if(maxi_double_arvalid && !maxi_double_arready) begin
        maxi_double_arvalid <= maxi_double_arvalid;
      end 
      if((th_ctrl == 10) && (maxi_double_arready || !maxi_double_arvalid)) begin
        maxi_double_araddr <= 8;
        maxi_double_arlen <= 0;
        maxi_double_arvalid <= 1;
      end 
      _maxi_double_raddr_cond_1_1 <= 1;
      if(maxi_double_arvalid && !maxi_double_arready) begin
        maxi_double_arvalid <= maxi_double_arvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_double_readdata_data_21 <= 0;
      _sb_maxi_double_readdata_valid_22 <= 0;
      _sb_maxi_double_readdata_tmp_data_24 <= 0;
      _sb_maxi_double_readdata_tmp_valid_25 <= 0;
    end else begin
      if(_sb_maxi_double_readdata_m_ready_20 || !_sb_maxi_double_readdata_valid_22) begin
        _sb_maxi_double_readdata_data_21 <= _sb_maxi_double_readdata_next_data_26;
        _sb_maxi_double_readdata_valid_22 <= _sb_maxi_double_readdata_next_valid_27;
      end 
      if(!_sb_maxi_double_readdata_tmp_valid_25 && _sb_maxi_double_readdata_valid_22 && !_sb_maxi_double_readdata_m_ready_20) begin
        _sb_maxi_double_readdata_tmp_data_24 <= _sb_maxi_double_readdata_s_data_18;
        _sb_maxi_double_readdata_tmp_valid_25 <= _sb_maxi_double_readdata_s_valid_19;
      end 
      if(_sb_maxi_double_readdata_tmp_valid_25 && _sb_maxi_double_readdata_m_ready_20) begin
        _sb_maxi_double_readdata_tmp_valid_25 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _maxi_double_outstanding_wcount <= 0;
      _maxi_double_read_start <= 0;
      _maxi_double_write_start <= 0;
      _maxi_double_write_req_busy <= 0;
      _maxi_double_write_data_busy <= 0;
      _maxi_double_read_req_busy <= 0;
      _maxi_double_read_data_busy <= 0;
    end else begin
      if(maxi_double_awvalid && maxi_double_awready && !(maxi_double_bvalid && maxi_double_bready) && (_maxi_double_outstanding_wcount < 7)) begin
        _maxi_double_outstanding_wcount <= _maxi_double_outstanding_wcount + 1;
      end 
      if(!(maxi_double_awvalid && maxi_double_awready) && (maxi_double_bvalid && maxi_double_bready) && (_maxi_double_outstanding_wcount > 0)) begin
        _maxi_double_outstanding_wcount <= _maxi_double_outstanding_wcount - 1;
      end 
      _maxi_double_read_start <= 0;
      _maxi_double_write_start <= 0;
      if((th_ctrl == 1) && _maxi_double_write_idle) begin
        _maxi_double_write_req_busy <= 1;
        _maxi_double_write_data_busy <= 1;
      end 
      if((th_ctrl == 2) && ((_maxi_double_outstanding_wcount < 6) && (maxi_double_awready || !maxi_double_awvalid))) begin
        _maxi_double_write_req_busy <= 0;
      end 
      if((th_ctrl == 3) && (_maxi_double_wready_sb_0 || !_maxi_double_wvalid_sb_0)) begin
        _maxi_double_write_data_busy <= 0;
      end 
      if((th_ctrl == 4) && _maxi_double_read_idle) begin
        _maxi_double_read_req_busy <= 1;
        _maxi_double_read_data_busy <= 1;
      end 
      if((th_ctrl == 5) && (maxi_double_arready || !maxi_double_arvalid)) begin
        _maxi_double_read_req_busy <= 0;
      end 
      if((th_ctrl == 6) && _maxi_double_rvalid_sb_0) begin
        _maxi_double_read_data_busy <= 0;
      end 
      if((th_ctrl == 9) && _maxi_double_read_idle) begin
        _maxi_double_read_req_busy <= 1;
        _maxi_double_read_data_busy <= 1;
      end 
      if((th_ctrl == 10) && (maxi_double_arready || !maxi_double_arvalid)) begin
        _maxi_double_read_req_busy <= 0;
      end 
      if((th_ctrl == 11) && _maxi_double_rvalid_sb_0) begin
        _maxi_double_read_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__maxi_double_read_req_fifo <= 0;
    end else begin
      if(_maxi_double_read_req_fifo_enq && !_maxi_double_read_req_fifo_full && (_maxi_double_read_req_fifo_deq && !_maxi_double_read_req_fifo_empty)) begin
        count__maxi_double_read_req_fifo <= count__maxi_double_read_req_fifo;
      end else if(_maxi_double_read_req_fifo_enq && !_maxi_double_read_req_fifo_full) begin
        count__maxi_double_read_req_fifo <= count__maxi_double_read_req_fifo + 1;
      end else if(_maxi_double_read_req_fifo_deq && !_maxi_double_read_req_fifo_empty) begin
        count__maxi_double_read_req_fifo <= count__maxi_double_read_req_fifo - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__maxi_double_write_req_fifo <= 0;
    end else begin
      if(_maxi_double_write_req_fifo_enq && !_maxi_double_write_req_fifo_full && (_maxi_double_write_req_fifo_deq && !_maxi_double_write_req_fifo_empty)) begin
        count__maxi_double_write_req_fifo <= count__maxi_double_write_req_fifo;
      end else if(_maxi_double_write_req_fifo_enq && !_maxi_double_write_req_fifo_full) begin
        count__maxi_double_write_req_fifo <= count__maxi_double_write_req_fifo + 1;
      end else if(_maxi_double_write_req_fifo_deq && !_maxi_double_write_req_fifo_empty) begin
        count__maxi_double_write_req_fifo <= count__maxi_double_write_req_fifo - 1;
      end 
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

  always @(posedge CLK) begin
    if(RST) begin
      th_ctrl <= th_ctrl_init;
      axim_rdata_69 <= 0;
      data_68 <= 0;
      axim_rdata_70 <= 0;
    end else begin
      case(th_ctrl)
        th_ctrl_init: begin
          th_ctrl <= th_ctrl_1;
        end
        th_ctrl_1: begin
          if(_maxi_double_write_idle) begin
            th_ctrl <= th_ctrl_2;
          end 
        end
        th_ctrl_2: begin
          if((_maxi_double_outstanding_wcount < 6) && (maxi_double_awready || !maxi_double_awvalid)) begin
            th_ctrl <= th_ctrl_3;
          end 
        end
        th_ctrl_3: begin
          if(_maxi_double_wready_sb_0 || !_maxi_double_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_4;
          end 
        end
        th_ctrl_4: begin
          if(_maxi_double_read_idle) begin
            th_ctrl <= th_ctrl_5;
          end 
        end
        th_ctrl_5: begin
          if(maxi_double_arready || !maxi_double_arvalid) begin
            th_ctrl <= th_ctrl_6;
          end 
        end
        th_ctrl_6: begin
          if(_maxi_double_rvalid_sb_0) begin
            axim_rdata_69 <= _maxi_double_rdata_sb_0;
          end 
          if(_maxi_double_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_7;
          end 
        end
        th_ctrl_7: begin
          data_68 <= axim_rdata_69;
          th_ctrl <= th_ctrl_8;
        end
        th_ctrl_8: begin
          $display("out_reg: %d", data_68);
          th_ctrl <= th_ctrl_9;
        end
        th_ctrl_9: begin
          if(_maxi_double_read_idle) begin
            th_ctrl <= th_ctrl_10;
          end 
        end
        th_ctrl_10: begin
          if(maxi_double_arready || !maxi_double_arvalid) begin
            th_ctrl <= th_ctrl_11;
          end 
        end
        th_ctrl_11: begin
          if(_maxi_double_rvalid_sb_0) begin
            axim_rdata_70 <= _maxi_double_rdata_sb_0;
          end 
          if(_maxi_double_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_12;
          end 
        end
        th_ctrl_12: begin
          data_68 <= axim_rdata_70;
          th_ctrl <= th_ctrl_13;
        end
        th_ctrl_13: begin
          $display("out_reg: %d", data_68);
          th_ctrl <= th_ctrl_14;
        end
      endcase
    end
  end


endmodule



module _maxi_double_read_req_fifo
(
  input CLK,
  input RST,
  input _maxi_double_read_req_fifo_enq,
  input [137-1:0] _maxi_double_read_req_fifo_wdata,
  output _maxi_double_read_req_fifo_full,
  output _maxi_double_read_req_fifo_almost_full,
  input _maxi_double_read_req_fifo_deq,
  output [137-1:0] _maxi_double_read_req_fifo_rdata,
  output _maxi_double_read_req_fifo_empty,
  output _maxi_double_read_req_fifo_almost_empty
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
  assign _maxi_double_read_req_fifo_full = is_full;
  assign _maxi_double_read_req_fifo_almost_full = is_almost_full || is_full;
  assign _maxi_double_read_req_fifo_empty = is_empty;
  assign _maxi_double_read_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _maxi_double_read_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_maxi_double_read_req_fifo_enq && !is_full) begin
        mem[head] <= _maxi_double_read_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_maxi_double_read_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _maxi_double_write_req_fifo
(
  input CLK,
  input RST,
  input _maxi_double_write_req_fifo_enq,
  input [137-1:0] _maxi_double_write_req_fifo_wdata,
  output _maxi_double_write_req_fifo_full,
  output _maxi_double_write_req_fifo_almost_full,
  input _maxi_double_write_req_fifo_deq,
  output [137-1:0] _maxi_double_write_req_fifo_rdata,
  output _maxi_double_write_req_fifo_empty,
  output _maxi_double_write_req_fifo_almost_empty
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
  assign _maxi_double_write_req_fifo_full = is_full;
  assign _maxi_double_write_req_fifo_almost_full = is_almost_full || is_full;
  assign _maxi_double_write_req_fifo_empty = is_empty;
  assign _maxi_double_write_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _maxi_double_write_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_maxi_double_write_req_fifo_enq && !is_full) begin
        mem[head] <= _maxi_double_write_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_maxi_double_write_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module double
(
  input CLK,
  input RST,
  input [4-1:0] axi_s_ctrl_double_awid,
  input [32-1:0] axi_s_ctrl_double_awaddr,
  input [8-1:0] axi_s_ctrl_double_awlen,
  input [3-1:0] axi_s_ctrl_double_awsize,
  input [2-1:0] axi_s_ctrl_double_awburst,
  input [1-1:0] axi_s_ctrl_double_awlock,
  input [4-1:0] axi_s_ctrl_double_awcache,
  input [3-1:0] axi_s_ctrl_double_awprot,
  input [4-1:0] axi_s_ctrl_double_awqos,
  input [2-1:0] axi_s_ctrl_double_awuser,
  input axi_s_ctrl_double_awvalid,
  output axi_s_ctrl_double_awready,
  input [64-1:0] axi_s_ctrl_double_wdata,
  input [8-1:0] axi_s_ctrl_double_wstrb,
  input axi_s_ctrl_double_wlast,
  input axi_s_ctrl_double_wvalid,
  output axi_s_ctrl_double_wready,
  output reg [4-1:0] axi_s_ctrl_double_bid,
  output [2-1:0] axi_s_ctrl_double_bresp,
  output reg axi_s_ctrl_double_bvalid,
  input axi_s_ctrl_double_bready,
  input [4-1:0] axi_s_ctrl_double_arid,
  input [32-1:0] axi_s_ctrl_double_araddr,
  input [8-1:0] axi_s_ctrl_double_arlen,
  input [3-1:0] axi_s_ctrl_double_arsize,
  input [2-1:0] axi_s_ctrl_double_arburst,
  input [1-1:0] axi_s_ctrl_double_arlock,
  input [4-1:0] axi_s_ctrl_double_arcache,
  input [3-1:0] axi_s_ctrl_double_arprot,
  input [4-1:0] axi_s_ctrl_double_arqos,
  input [2-1:0] axi_s_ctrl_double_aruser,
  input axi_s_ctrl_double_arvalid,
  output axi_s_ctrl_double_arready,
  output reg [4-1:0] axi_s_ctrl_double_rid,
  output reg [64-1:0] axi_s_ctrl_double_rdata,
  output [2-1:0] axi_s_ctrl_double_rresp,
  output reg axi_s_ctrl_double_rlast,
  output reg axi_s_ctrl_double_rvalid,
  input axi_s_ctrl_double_rready
);

  assign axi_s_ctrl_double_bresp = 0;
  assign axi_s_ctrl_double_rresp = 0;
  reg signed [64-1:0] _axi_s_ctrl_double_register_0;
  reg signed [64-1:0] _axi_s_ctrl_double_register_1;
  reg signed [64-1:0] _axi_s_ctrl_double_register_2;
  reg _axi_s_ctrl_double_flag_0;
  reg _axi_s_ctrl_double_flag_1;
  reg _axi_s_ctrl_double_flag_2;
  reg signed [64-1:0] _axi_s_ctrl_double_resetval_0;
  reg signed [64-1:0] _axi_s_ctrl_double_resetval_1;
  reg signed [64-1:0] _axi_s_ctrl_double_resetval_2;
  localparam _axi_s_ctrl_double_maskwidth = 2;
  localparam _axi_s_ctrl_double_mask = { _axi_s_ctrl_double_maskwidth{ 1'd1 } };
  localparam _axi_s_ctrl_double_shift = 3;
  reg [32-1:0] _axi_s_ctrl_double_register_fsm;
  localparam _axi_s_ctrl_double_register_fsm_init = 0;
  reg [32-1:0] addr_0;
  reg [9-1:0] length_1;
  reg writevalid_2;
  reg readvalid_3;
  reg prev_awvalid_4;
  reg prev_arvalid_5;
  assign axi_s_ctrl_double_awready = (_axi_s_ctrl_double_register_fsm == 0) && (!writevalid_2 && !readvalid_3 && !axi_s_ctrl_double_bvalid && prev_awvalid_4);
  assign axi_s_ctrl_double_arready = (_axi_s_ctrl_double_register_fsm == 0) && (!readvalid_3 && !writevalid_2 && prev_arvalid_5 && !prev_awvalid_4);
  reg [9-1:0] axis_rcount_6;
  reg axis_rlast_7;
  reg [_axi_s_ctrl_double_maskwidth-1:0] axis_maskaddr_8;
  wire signed [64-1:0] axis_rdata_9;
  assign axis_rdata_9 = (axis_maskaddr_8 == 0)? _axi_s_ctrl_double_register_0 : 
                        (axis_maskaddr_8 == 1)? _axi_s_ctrl_double_register_1 : 
                        (axis_maskaddr_8 == 2)? _axi_s_ctrl_double_register_2 : 'hx;
  wire axis_flag_10;
  assign axis_flag_10 = (axis_maskaddr_8 == 0)? _axi_s_ctrl_double_flag_0 : 
                        (axis_maskaddr_8 == 1)? _axi_s_ctrl_double_flag_1 : 
                        (axis_maskaddr_8 == 2)? _axi_s_ctrl_double_flag_2 : 'hx;
  wire signed [64-1:0] axis_resetval_11;
  assign axis_resetval_11 = (axis_maskaddr_8 == 0)? _axi_s_ctrl_double_resetval_0 : 
                            (axis_maskaddr_8 == 1)? _axi_s_ctrl_double_resetval_1 : 
                            (axis_maskaddr_8 == 2)? _axi_s_ctrl_double_resetval_2 : 'hx;
  reg _axi_s_ctrl_double_rdata_cond_0_1;
  assign axi_s_ctrl_double_wready = _axi_s_ctrl_double_register_fsm == 2;
  reg [64-1:0] in_reg_12;
  reg [32-1:0] double_read_thread;
  localparam double_read_thread_init = 0;

  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_double_rdata <= 0;
      axi_s_ctrl_double_rvalid <= 0;
      axi_s_ctrl_double_rlast <= 0;
      _axi_s_ctrl_double_rdata_cond_0_1 <= 0;
    end else begin
      if(_axi_s_ctrl_double_rdata_cond_0_1) begin
        axi_s_ctrl_double_rvalid <= 0;
        axi_s_ctrl_double_rlast <= 0;
      end 
      if((_axi_s_ctrl_double_register_fsm == 1) && (axi_s_ctrl_double_rready || !axi_s_ctrl_double_rvalid)) begin
        axi_s_ctrl_double_rdata <= axis_rdata_9;
        axi_s_ctrl_double_rvalid <= 1;
        axi_s_ctrl_double_rlast <= axis_rlast_7;
      end 
      _axi_s_ctrl_double_rdata_cond_0_1 <= 1;
      if(axi_s_ctrl_double_rvalid && !axi_s_ctrl_double_rready) begin
        axi_s_ctrl_double_rvalid <= axi_s_ctrl_double_rvalid;
        axi_s_ctrl_double_rlast <= axi_s_ctrl_double_rlast;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_double_bid <= 0;
      axi_s_ctrl_double_rid <= 0;
      axi_s_ctrl_double_bvalid <= 0;
      prev_awvalid_4 <= 0;
      prev_arvalid_5 <= 0;
      writevalid_2 <= 0;
      readvalid_3 <= 0;
      addr_0 <= 0;
      length_1 <= 0;
      _axi_s_ctrl_double_register_0 <= 0;
      _axi_s_ctrl_double_flag_0 <= 0;
      _axi_s_ctrl_double_register_1 <= 0;
      _axi_s_ctrl_double_flag_1 <= 0;
      _axi_s_ctrl_double_register_2 <= 0;
      _axi_s_ctrl_double_flag_2 <= 0;
    end else begin
      if(axi_s_ctrl_double_awvalid && axi_s_ctrl_double_awready && !axi_s_ctrl_double_bvalid) begin
        axi_s_ctrl_double_bid <= axi_s_ctrl_double_awid;
      end 
      if(axi_s_ctrl_double_arvalid && axi_s_ctrl_double_arready) begin
        axi_s_ctrl_double_rid <= axi_s_ctrl_double_arid;
      end 
      if(axi_s_ctrl_double_bvalid && axi_s_ctrl_double_bready) begin
        axi_s_ctrl_double_bvalid <= 0;
      end 
      if(axi_s_ctrl_double_wvalid && axi_s_ctrl_double_wready && axi_s_ctrl_double_wlast) begin
        axi_s_ctrl_double_bvalid <= 1;
      end 
      prev_awvalid_4 <= axi_s_ctrl_double_awvalid;
      prev_arvalid_5 <= axi_s_ctrl_double_arvalid;
      writevalid_2 <= 0;
      readvalid_3 <= 0;
      if(axi_s_ctrl_double_awready && axi_s_ctrl_double_awvalid && !axi_s_ctrl_double_bvalid) begin
        addr_0 <= axi_s_ctrl_double_awaddr;
        length_1 <= axi_s_ctrl_double_awlen + 1;
        writevalid_2 <= 1;
      end else if(axi_s_ctrl_double_arready && axi_s_ctrl_double_arvalid) begin
        addr_0 <= axi_s_ctrl_double_araddr;
        length_1 <= axi_s_ctrl_double_arlen + 1;
        readvalid_3 <= 1;
      end 
      if((_axi_s_ctrl_double_register_fsm == 1) && (axi_s_ctrl_double_rready || !axi_s_ctrl_double_rvalid) && axis_flag_10 && (axis_maskaddr_8 == 0)) begin
        _axi_s_ctrl_double_register_0 <= axis_resetval_11;
        _axi_s_ctrl_double_flag_0 <= 0;
      end 
      if((_axi_s_ctrl_double_register_fsm == 1) && (axi_s_ctrl_double_rready || !axi_s_ctrl_double_rvalid) && axis_flag_10 && (axis_maskaddr_8 == 1)) begin
        _axi_s_ctrl_double_register_1 <= axis_resetval_11;
        _axi_s_ctrl_double_flag_1 <= 0;
      end 
      if((_axi_s_ctrl_double_register_fsm == 1) && (axi_s_ctrl_double_rready || !axi_s_ctrl_double_rvalid) && axis_flag_10 && (axis_maskaddr_8 == 2)) begin
        _axi_s_ctrl_double_register_2 <= axis_resetval_11;
        _axi_s_ctrl_double_flag_2 <= 0;
      end 
      if((_axi_s_ctrl_double_register_fsm == 2) && axi_s_ctrl_double_wvalid && (axis_maskaddr_8 == 0)) begin
        _axi_s_ctrl_double_register_0 <= axi_s_ctrl_double_wdata;
      end 
      if((_axi_s_ctrl_double_register_fsm == 2) && axi_s_ctrl_double_wvalid && (axis_maskaddr_8 == 1)) begin
        _axi_s_ctrl_double_register_1 <= axi_s_ctrl_double_wdata;
      end 
      if((_axi_s_ctrl_double_register_fsm == 2) && axi_s_ctrl_double_wvalid && (axis_maskaddr_8 == 2)) begin
        _axi_s_ctrl_double_register_2 <= axi_s_ctrl_double_wdata;
      end 
      if((double_read_thread == 3) && 0) begin
        _axi_s_ctrl_double_register_0 <= in_reg_12 << 1;
        _axi_s_ctrl_double_flag_0 <= 0;
      end 
      if((double_read_thread == 3) && 1) begin
        _axi_s_ctrl_double_register_1 <= in_reg_12 << 1;
        _axi_s_ctrl_double_flag_1 <= 0;
      end 
      if((double_read_thread == 3) && 0) begin
        _axi_s_ctrl_double_register_2 <= in_reg_12 << 1;
        _axi_s_ctrl_double_flag_2 <= 0;
      end 
    end
  end

  localparam _axi_s_ctrl_double_register_fsm_1 = 1;
  localparam _axi_s_ctrl_double_register_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_s_ctrl_double_register_fsm <= _axi_s_ctrl_double_register_fsm_init;
      axis_rcount_6 <= 0;
      axis_rlast_7 <= 0;
      axis_maskaddr_8 <= 0;
    end else begin
      case(_axi_s_ctrl_double_register_fsm)
        _axi_s_ctrl_double_register_fsm_init: begin
          if(readvalid_3) begin
            axis_rcount_6 <= length_1;
            axis_rlast_7 <= length_1 <= 1;
          end 
          if(readvalid_3 || writevalid_2) begin
            axis_maskaddr_8 <= (addr_0 >> _axi_s_ctrl_double_shift) & _axi_s_ctrl_double_mask;
          end 
          if(readvalid_3) begin
            _axi_s_ctrl_double_register_fsm <= _axi_s_ctrl_double_register_fsm_1;
          end 
          if(writevalid_2) begin
            _axi_s_ctrl_double_register_fsm <= _axi_s_ctrl_double_register_fsm_2;
          end 
        end
        _axi_s_ctrl_double_register_fsm_1: begin
          if(axi_s_ctrl_double_rready || !axi_s_ctrl_double_rvalid) begin
            axis_maskaddr_8 <= axis_maskaddr_8 + 1;
            axis_rcount_6 <= axis_rcount_6 - 1;
            axis_rlast_7 <= axis_rcount_6 <= 1;
          end 
          if((axi_s_ctrl_double_rready || !axi_s_ctrl_double_rvalid) && axis_rlast_7) begin
            _axi_s_ctrl_double_register_fsm <= _axi_s_ctrl_double_register_fsm_init;
          end 
        end
        _axi_s_ctrl_double_register_fsm_2: begin
          if(axi_s_ctrl_double_wvalid) begin
            axis_maskaddr_8 <= axis_maskaddr_8 + 1;
          end 
          if(axi_s_ctrl_double_wvalid && axi_s_ctrl_double_wlast) begin
            _axi_s_ctrl_double_register_fsm <= _axi_s_ctrl_double_register_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam double_read_thread_1 = 1;
  localparam double_read_thread_2 = 2;
  localparam double_read_thread_3 = 3;
  localparam double_read_thread_4 = 4;
  localparam double_read_thread_5 = 5;

  always @(posedge CLK) begin
    if(RST) begin
      double_read_thread <= double_read_thread_init;
      in_reg_12 <= 0;
    end else begin
      case(double_read_thread)
        double_read_thread_init: begin
          double_read_thread <= double_read_thread_1;
        end
        double_read_thread_1: begin
          if(1) begin
            double_read_thread <= double_read_thread_2;
          end else begin
            double_read_thread <= double_read_thread_5;
          end
        end
        double_read_thread_2: begin
          in_reg_12 <= _axi_s_ctrl_double_register_0;
          double_read_thread <= double_read_thread_3;
        end
        double_read_thread_3: begin
          double_read_thread <= double_read_thread_4;
        end
        double_read_thread_4: begin
          double_read_thread <= double_read_thread_1;
        end
      endcase
    end
  end


endmodule

