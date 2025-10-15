

module test_xored
(

);

  reg CLK;
  reg RST;
  reg [32-1:0] axi_s_ctrl_xored_awaddr;
  reg [4-1:0] axi_s_ctrl_xored_awcache;
  reg [3-1:0] axi_s_ctrl_xored_awprot;
  reg axi_s_ctrl_xored_awvalid;
  wire axi_s_ctrl_xored_awready;
  reg [64-1:0] axi_s_ctrl_xored_wdata;
  reg [8-1:0] axi_s_ctrl_xored_wstrb;
  reg axi_s_ctrl_xored_wvalid;
  wire axi_s_ctrl_xored_wready;
  wire [2-1:0] axi_s_ctrl_xored_bresp;
  wire axi_s_ctrl_xored_bvalid;
  reg axi_s_ctrl_xored_bready;
  reg [32-1:0] axi_s_ctrl_xored_araddr;
  reg [4-1:0] axi_s_ctrl_xored_arcache;
  reg [3-1:0] axi_s_ctrl_xored_arprot;
  reg axi_s_ctrl_xored_arvalid;
  wire axi_s_ctrl_xored_arready;
  wire [64-1:0] axi_s_ctrl_xored_rdata;
  wire [2-1:0] axi_s_ctrl_xored_rresp;
  wire axi_s_ctrl_xored_rvalid;
  reg axi_s_ctrl_xored_rready;
  reg [128-1:0] axis_in_xordata_tdata;
  reg axis_in_xordata_tvalid;
  wire axis_in_xordata_tready;
  reg axis_in_xordata_tlast;
  wire [128-1:0] axis_out_xoreddata_tdata;
  wire axis_out_xoreddata_tvalid;
  reg axis_out_xoreddata_tready;
  wire axis_out_xoreddata_tlast;
  reg [128-1:0] axis_in_aes_tdata;
  reg axis_in_aes_tvalid;
  wire axis_in_aes_tready;
  reg axis_in_aes_tlast;
  reg [32-1:0] maxi_xor_awaddr;
  wire [4-1:0] maxi_xor_awcache;
  wire [3-1:0] maxi_xor_awprot;
  reg maxi_xor_awvalid;
  wire maxi_xor_awready;
  assign maxi_xor_awcache = 3;
  assign maxi_xor_awprot = 0;
  wire [64-1:0] maxi_xor_wdata;
  wire [8-1:0] maxi_xor_wstrb;
  wire maxi_xor_wvalid;
  wire maxi_xor_wready;
  reg [64-1:0] _maxi_xor_wdata_sb_0;
  reg [8-1:0] _maxi_xor_wstrb_sb_0;
  reg _maxi_xor_wvalid_sb_0;
  wire _maxi_xor_wready_sb_0;
  wire [8-1:0] _sb_maxi_xor_writedata_s_value_0;
  assign _sb_maxi_xor_writedata_s_value_0 = _maxi_xor_wstrb_sb_0;
  wire [64-1:0] _sb_maxi_xor_writedata_s_value_1;
  assign _sb_maxi_xor_writedata_s_value_1 = _maxi_xor_wdata_sb_0;
  wire [72-1:0] _sb_maxi_xor_writedata_s_data_2;
  assign _sb_maxi_xor_writedata_s_data_2 = { _sb_maxi_xor_writedata_s_value_0, _sb_maxi_xor_writedata_s_value_1 };
  wire _sb_maxi_xor_writedata_s_valid_3;
  assign _sb_maxi_xor_writedata_s_valid_3 = _maxi_xor_wvalid_sb_0;
  wire _sb_maxi_xor_writedata_m_ready_4;
  assign _sb_maxi_xor_writedata_m_ready_4 = maxi_xor_wready;
  reg [72-1:0] _sb_maxi_xor_writedata_data_5;
  reg _sb_maxi_xor_writedata_valid_6;
  wire _sb_maxi_xor_writedata_ready_7;
  reg [72-1:0] _sb_maxi_xor_writedata_tmp_data_8;
  reg _sb_maxi_xor_writedata_tmp_valid_9;
  wire [72-1:0] _sb_maxi_xor_writedata_next_data_10;
  wire _sb_maxi_xor_writedata_next_valid_11;
  assign _sb_maxi_xor_writedata_ready_7 = !_sb_maxi_xor_writedata_tmp_valid_9;
  assign _sb_maxi_xor_writedata_next_data_10 = (_sb_maxi_xor_writedata_tmp_valid_9)? _sb_maxi_xor_writedata_tmp_data_8 : _sb_maxi_xor_writedata_s_data_2;
  assign _sb_maxi_xor_writedata_next_valid_11 = _sb_maxi_xor_writedata_tmp_valid_9 || _sb_maxi_xor_writedata_s_valid_3;
  wire [8-1:0] _sb_maxi_xor_writedata_m_value_12;
  assign _sb_maxi_xor_writedata_m_value_12 = _sb_maxi_xor_writedata_data_5[71:64];
  wire [64-1:0] _sb_maxi_xor_writedata_m_value_13;
  assign _sb_maxi_xor_writedata_m_value_13 = _sb_maxi_xor_writedata_data_5[63:0];
  assign _maxi_xor_wready_sb_0 = _sb_maxi_xor_writedata_ready_7;
  assign maxi_xor_wdata = _sb_maxi_xor_writedata_m_value_13;
  assign maxi_xor_wstrb = _sb_maxi_xor_writedata_m_value_12;
  assign maxi_xor_wvalid = _sb_maxi_xor_writedata_valid_6;
  wire [2-1:0] maxi_xor_bresp;
  wire maxi_xor_bvalid;
  wire maxi_xor_bready;
  assign maxi_xor_bready = 1;
  reg [32-1:0] maxi_xor_araddr;
  wire [4-1:0] maxi_xor_arcache;
  wire [3-1:0] maxi_xor_arprot;
  reg maxi_xor_arvalid;
  wire maxi_xor_arready;
  assign maxi_xor_arcache = 3;
  assign maxi_xor_arprot = 0;
  wire [64-1:0] maxi_xor_rdata;
  wire [2-1:0] maxi_xor_rresp;
  wire maxi_xor_rvalid;
  wire maxi_xor_rready;
  wire [64-1:0] _maxi_xor_rdata_sb_0;
  wire _maxi_xor_rvalid_sb_0;
  wire _maxi_xor_rready_sb_0;
  wire [64-1:0] _sb_maxi_xor_readdata_s_value_14;
  assign _sb_maxi_xor_readdata_s_value_14 = maxi_xor_rdata;
  wire [64-1:0] _sb_maxi_xor_readdata_s_data_15;
  assign _sb_maxi_xor_readdata_s_data_15 = { _sb_maxi_xor_readdata_s_value_14 };
  wire _sb_maxi_xor_readdata_s_valid_16;
  assign _sb_maxi_xor_readdata_s_valid_16 = maxi_xor_rvalid;
  wire _sb_maxi_xor_readdata_m_ready_17;
  assign _sb_maxi_xor_readdata_m_ready_17 = _maxi_xor_rready_sb_0;
  reg [64-1:0] _sb_maxi_xor_readdata_data_18;
  reg _sb_maxi_xor_readdata_valid_19;
  wire _sb_maxi_xor_readdata_ready_20;
  reg [64-1:0] _sb_maxi_xor_readdata_tmp_data_21;
  reg _sb_maxi_xor_readdata_tmp_valid_22;
  wire [64-1:0] _sb_maxi_xor_readdata_next_data_23;
  wire _sb_maxi_xor_readdata_next_valid_24;
  assign _sb_maxi_xor_readdata_ready_20 = !_sb_maxi_xor_readdata_tmp_valid_22;
  assign _sb_maxi_xor_readdata_next_data_23 = (_sb_maxi_xor_readdata_tmp_valid_22)? _sb_maxi_xor_readdata_tmp_data_21 : _sb_maxi_xor_readdata_s_data_15;
  assign _sb_maxi_xor_readdata_next_valid_24 = _sb_maxi_xor_readdata_tmp_valid_22 || _sb_maxi_xor_readdata_s_valid_16;
  wire [64-1:0] _sb_maxi_xor_readdata_m_value_25;
  assign _sb_maxi_xor_readdata_m_value_25 = _sb_maxi_xor_readdata_data_18[63:0];
  assign _maxi_xor_rdata_sb_0 = _sb_maxi_xor_readdata_m_value_25;
  assign _maxi_xor_rvalid_sb_0 = _sb_maxi_xor_readdata_valid_19;
  assign maxi_xor_rready = _sb_maxi_xor_readdata_ready_20;
  reg [3-1:0] _maxi_xor_outstanding_wcount;
  wire _maxi_xor_has_outstanding_write;
  assign _maxi_xor_has_outstanding_write = (_maxi_xor_outstanding_wcount > 0) || maxi_xor_awvalid;
  reg [128-1:0] m_axis_xor_tdata;
  reg m_axis_xor_tvalid;
  wire m_axis_xor_tready;
  reg m_axis_xor_tlast;
  wire _m_axis_xor_write_req_fifo_enq;
  wire [105-1:0] _m_axis_xor_write_req_fifo_wdata;
  wire _m_axis_xor_write_req_fifo_full;
  wire _m_axis_xor_write_req_fifo_almost_full;
  wire _m_axis_xor_write_req_fifo_deq;
  wire [105-1:0] _m_axis_xor_write_req_fifo_rdata;
  wire _m_axis_xor_write_req_fifo_empty;
  wire _m_axis_xor_write_req_fifo_almost_empty;

  _m_axis_xor_write_req_fifo
  inst__m_axis_xor_write_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._m_axis_xor_write_req_fifo_enq(_m_axis_xor_write_req_fifo_enq),
    ._m_axis_xor_write_req_fifo_wdata(_m_axis_xor_write_req_fifo_wdata),
    ._m_axis_xor_write_req_fifo_full(_m_axis_xor_write_req_fifo_full),
    ._m_axis_xor_write_req_fifo_almost_full(_m_axis_xor_write_req_fifo_almost_full),
    ._m_axis_xor_write_req_fifo_deq(_m_axis_xor_write_req_fifo_deq),
    ._m_axis_xor_write_req_fifo_rdata(_m_axis_xor_write_req_fifo_rdata),
    ._m_axis_xor_write_req_fifo_empty(_m_axis_xor_write_req_fifo_empty),
    ._m_axis_xor_write_req_fifo_almost_empty(_m_axis_xor_write_req_fifo_almost_empty)
  );

  reg [4-1:0] count__m_axis_xor_write_req_fifo;
  wire [8-1:0] _m_axis_xor_write_op_sel_fifo;
  wire [32-1:0] _m_axis_xor_write_local_addr_fifo;
  wire [32-1:0] _m_axis_xor_write_local_stride_fifo;
  wire [33-1:0] _m_axis_xor_write_size_fifo;
  wire [8-1:0] unpack_write_req_op_sel_26;
  wire [32-1:0] unpack_write_req_local_addr_27;
  wire [32-1:0] unpack_write_req_local_stride_28;
  wire [33-1:0] unpack_write_req_local_size_29;
  assign unpack_write_req_op_sel_26 = _m_axis_xor_write_req_fifo_rdata[104:97];
  assign unpack_write_req_local_addr_27 = _m_axis_xor_write_req_fifo_rdata[96:65];
  assign unpack_write_req_local_stride_28 = _m_axis_xor_write_req_fifo_rdata[64:33];
  assign unpack_write_req_local_size_29 = _m_axis_xor_write_req_fifo_rdata[32:0];
  assign _m_axis_xor_write_op_sel_fifo = unpack_write_req_op_sel_26;
  assign _m_axis_xor_write_local_addr_fifo = unpack_write_req_local_addr_27;
  assign _m_axis_xor_write_local_stride_fifo = unpack_write_req_local_stride_28;
  assign _m_axis_xor_write_size_fifo = unpack_write_req_local_size_29;
  reg [8-1:0] _m_axis_xor_write_op_sel_buf;
  reg [32-1:0] _m_axis_xor_write_local_addr_buf;
  reg [32-1:0] _m_axis_xor_write_local_stride_buf;
  reg [33-1:0] _m_axis_xor_write_size_buf;
  reg _m_axis_xor_write_data_busy;
  wire _m_axis_xor_write_data_idle;
  wire _m_axis_xor_write_idle;
  assign _m_axis_xor_write_data_idle = _m_axis_xor_write_req_fifo_empty && !_m_axis_xor_write_data_busy;
  assign _m_axis_xor_write_idle = _m_axis_xor_write_data_idle;
  reg [128-1:0] m_axis_aes_xor_tdata;
  reg m_axis_aes_xor_tvalid;
  wire m_axis_aes_xor_tready;
  reg m_axis_aes_xor_tlast;
  wire _m_axis_aes_xor_write_req_fifo_enq;
  wire [105-1:0] _m_axis_aes_xor_write_req_fifo_wdata;
  wire _m_axis_aes_xor_write_req_fifo_full;
  wire _m_axis_aes_xor_write_req_fifo_almost_full;
  wire _m_axis_aes_xor_write_req_fifo_deq;
  wire [105-1:0] _m_axis_aes_xor_write_req_fifo_rdata;
  wire _m_axis_aes_xor_write_req_fifo_empty;
  wire _m_axis_aes_xor_write_req_fifo_almost_empty;
  assign _m_axis_aes_xor_write_req_fifo_enq = 0;
  assign _m_axis_aes_xor_write_req_fifo_wdata = 'hx;
  assign _m_axis_aes_xor_write_req_fifo_deq = 0;

  _m_axis_aes_xor_write_req_fifo
  inst__m_axis_aes_xor_write_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._m_axis_aes_xor_write_req_fifo_enq(_m_axis_aes_xor_write_req_fifo_enq),
    ._m_axis_aes_xor_write_req_fifo_wdata(_m_axis_aes_xor_write_req_fifo_wdata),
    ._m_axis_aes_xor_write_req_fifo_full(_m_axis_aes_xor_write_req_fifo_full),
    ._m_axis_aes_xor_write_req_fifo_almost_full(_m_axis_aes_xor_write_req_fifo_almost_full),
    ._m_axis_aes_xor_write_req_fifo_deq(_m_axis_aes_xor_write_req_fifo_deq),
    ._m_axis_aes_xor_write_req_fifo_rdata(_m_axis_aes_xor_write_req_fifo_rdata),
    ._m_axis_aes_xor_write_req_fifo_empty(_m_axis_aes_xor_write_req_fifo_empty),
    ._m_axis_aes_xor_write_req_fifo_almost_empty(_m_axis_aes_xor_write_req_fifo_almost_empty)
  );

  reg [4-1:0] count__m_axis_aes_xor_write_req_fifo;
  wire [8-1:0] _m_axis_aes_xor_write_op_sel_fifo;
  wire [32-1:0] _m_axis_aes_xor_write_local_addr_fifo;
  wire [32-1:0] _m_axis_aes_xor_write_local_stride_fifo;
  wire [33-1:0] _m_axis_aes_xor_write_size_fifo;
  wire [8-1:0] unpack_write_req_op_sel_30;
  wire [32-1:0] unpack_write_req_local_addr_31;
  wire [32-1:0] unpack_write_req_local_stride_32;
  wire [33-1:0] unpack_write_req_local_size_33;
  assign unpack_write_req_op_sel_30 = _m_axis_aes_xor_write_req_fifo_rdata[104:97];
  assign unpack_write_req_local_addr_31 = _m_axis_aes_xor_write_req_fifo_rdata[96:65];
  assign unpack_write_req_local_stride_32 = _m_axis_aes_xor_write_req_fifo_rdata[64:33];
  assign unpack_write_req_local_size_33 = _m_axis_aes_xor_write_req_fifo_rdata[32:0];
  assign _m_axis_aes_xor_write_op_sel_fifo = unpack_write_req_op_sel_30;
  assign _m_axis_aes_xor_write_local_addr_fifo = unpack_write_req_local_addr_31;
  assign _m_axis_aes_xor_write_local_stride_fifo = unpack_write_req_local_stride_32;
  assign _m_axis_aes_xor_write_size_fifo = unpack_write_req_local_size_33;
  reg [8-1:0] _m_axis_aes_xor_write_op_sel_buf;
  reg [32-1:0] _m_axis_aes_xor_write_local_addr_buf;
  reg [32-1:0] _m_axis_aes_xor_write_local_stride_buf;
  reg [33-1:0] _m_axis_aes_xor_write_size_buf;
  reg _m_axis_aes_xor_write_data_busy;
  wire _m_axis_aes_xor_write_data_idle;
  wire _m_axis_aes_xor_write_idle;
  assign _m_axis_aes_xor_write_data_idle = _m_axis_aes_xor_write_req_fifo_empty && !_m_axis_aes_xor_write_data_busy;
  assign _m_axis_aes_xor_write_idle = _m_axis_aes_xor_write_data_idle;
  wire [128-1:0] s_axis_xor_tdata;
  wire s_axis_xor_tvalid;
  wire s_axis_xor_tready;
  wire s_axis_xor_tlast;
  wire _s_axis_xor_read_req_fifo_enq;
  wire [105-1:0] _s_axis_xor_read_req_fifo_wdata;
  wire _s_axis_xor_read_req_fifo_full;
  wire _s_axis_xor_read_req_fifo_almost_full;
  wire _s_axis_xor_read_req_fifo_deq;
  wire [105-1:0] _s_axis_xor_read_req_fifo_rdata;
  wire _s_axis_xor_read_req_fifo_empty;
  wire _s_axis_xor_read_req_fifo_almost_empty;
  assign _s_axis_xor_read_req_fifo_enq = 0;
  assign _s_axis_xor_read_req_fifo_wdata = 'hx;
  assign _s_axis_xor_read_req_fifo_deq = 0;

  _s_axis_xor_read_req_fifo
  inst__s_axis_xor_read_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._s_axis_xor_read_req_fifo_enq(_s_axis_xor_read_req_fifo_enq),
    ._s_axis_xor_read_req_fifo_wdata(_s_axis_xor_read_req_fifo_wdata),
    ._s_axis_xor_read_req_fifo_full(_s_axis_xor_read_req_fifo_full),
    ._s_axis_xor_read_req_fifo_almost_full(_s_axis_xor_read_req_fifo_almost_full),
    ._s_axis_xor_read_req_fifo_deq(_s_axis_xor_read_req_fifo_deq),
    ._s_axis_xor_read_req_fifo_rdata(_s_axis_xor_read_req_fifo_rdata),
    ._s_axis_xor_read_req_fifo_empty(_s_axis_xor_read_req_fifo_empty),
    ._s_axis_xor_read_req_fifo_almost_empty(_s_axis_xor_read_req_fifo_almost_empty)
  );

  reg [4-1:0] count__s_axis_xor_read_req_fifo;
  wire [8-1:0] _s_axis_xor_read_op_sel_fifo;
  wire [32-1:0] _s_axis_xor_read_local_addr_fifo;
  wire [32-1:0] _s_axis_xor_read_local_stride_fifo;
  wire [33-1:0] _s_axis_xor_read_local_size_fifo;
  wire [8-1:0] unpack_read_req_op_sel_34;
  wire [32-1:0] unpack_read_req_local_addr_35;
  wire [32-1:0] unpack_read_req_local_stride_36;
  wire [33-1:0] unpack_read_req_local_size_37;
  assign unpack_read_req_op_sel_34 = _s_axis_xor_read_req_fifo_rdata[104:97];
  assign unpack_read_req_local_addr_35 = _s_axis_xor_read_req_fifo_rdata[96:65];
  assign unpack_read_req_local_stride_36 = _s_axis_xor_read_req_fifo_rdata[64:33];
  assign unpack_read_req_local_size_37 = _s_axis_xor_read_req_fifo_rdata[32:0];
  assign _s_axis_xor_read_op_sel_fifo = unpack_read_req_op_sel_34;
  assign _s_axis_xor_read_local_addr_fifo = unpack_read_req_local_addr_35;
  assign _s_axis_xor_read_local_stride_fifo = unpack_read_req_local_stride_36;
  assign _s_axis_xor_read_local_size_fifo = unpack_read_req_local_size_37;
  reg [8-1:0] _s_axis_xor_read_op_sel_buf;
  reg [32-1:0] _s_axis_xor_read_local_addr_buf;
  reg [32-1:0] _s_axis_xor_read_local_stride_buf;
  reg [33-1:0] _s_axis_xor_read_local_size_buf;
  reg _s_axis_xor_read_data_busy;
  wire _s_axis_xor_read_data_idle;
  wire _s_axis_xor_read_idle;
  assign _s_axis_xor_read_data_idle = _s_axis_xor_read_req_fifo_empty && !_s_axis_xor_read_data_busy;
  assign _s_axis_xor_read_idle = _s_axis_xor_read_data_idle;
  wire [32-1:0] _tmp_38;
  assign _tmp_38 = maxi_xor_awaddr;

  always @(*) begin
    axi_s_ctrl_xored_awaddr = _tmp_38;
  end

  wire [4-1:0] _tmp_39;
  assign _tmp_39 = maxi_xor_awcache;

  always @(*) begin
    axi_s_ctrl_xored_awcache = _tmp_39;
  end

  wire [3-1:0] _tmp_40;
  assign _tmp_40 = maxi_xor_awprot;

  always @(*) begin
    axi_s_ctrl_xored_awprot = _tmp_40;
  end

  wire _tmp_41;
  assign _tmp_41 = maxi_xor_awvalid;

  always @(*) begin
    axi_s_ctrl_xored_awvalid = _tmp_41;
  end

  assign maxi_xor_awready = axi_s_ctrl_xored_awready;
  wire [64-1:0] _tmp_42;
  assign _tmp_42 = maxi_xor_wdata;

  always @(*) begin
    axi_s_ctrl_xored_wdata = _tmp_42;
  end

  wire [8-1:0] _tmp_43;
  assign _tmp_43 = maxi_xor_wstrb;

  always @(*) begin
    axi_s_ctrl_xored_wstrb = _tmp_43;
  end

  wire _tmp_44;
  assign _tmp_44 = maxi_xor_wvalid;

  always @(*) begin
    axi_s_ctrl_xored_wvalid = _tmp_44;
  end

  assign maxi_xor_wready = axi_s_ctrl_xored_wready;
  assign maxi_xor_bresp = axi_s_ctrl_xored_bresp;
  assign maxi_xor_bvalid = axi_s_ctrl_xored_bvalid;
  wire _tmp_45;
  assign _tmp_45 = maxi_xor_bready;

  always @(*) begin
    axi_s_ctrl_xored_bready = _tmp_45;
  end

  wire [32-1:0] _tmp_46;
  assign _tmp_46 = maxi_xor_araddr;

  always @(*) begin
    axi_s_ctrl_xored_araddr = _tmp_46;
  end

  wire [4-1:0] _tmp_47;
  assign _tmp_47 = maxi_xor_arcache;

  always @(*) begin
    axi_s_ctrl_xored_arcache = _tmp_47;
  end

  wire [3-1:0] _tmp_48;
  assign _tmp_48 = maxi_xor_arprot;

  always @(*) begin
    axi_s_ctrl_xored_arprot = _tmp_48;
  end

  wire _tmp_49;
  assign _tmp_49 = maxi_xor_arvalid;

  always @(*) begin
    axi_s_ctrl_xored_arvalid = _tmp_49;
  end

  assign maxi_xor_arready = axi_s_ctrl_xored_arready;
  assign maxi_xor_rdata = axi_s_ctrl_xored_rdata;
  assign maxi_xor_rresp = axi_s_ctrl_xored_rresp;
  assign maxi_xor_rvalid = axi_s_ctrl_xored_rvalid;
  wire _tmp_50;
  assign _tmp_50 = maxi_xor_rready;

  always @(*) begin
    axi_s_ctrl_xored_rready = _tmp_50;
  end

  wire [128-1:0] _tmp_51;
  assign _tmp_51 = m_axis_xor_tdata;

  always @(*) begin
    axis_in_xordata_tdata = _tmp_51;
  end

  wire _tmp_52;
  assign _tmp_52 = m_axis_xor_tvalid;

  always @(*) begin
    axis_in_xordata_tvalid = _tmp_52;
  end

  assign m_axis_xor_tready = axis_in_xordata_tready;
  wire _tmp_53;
  assign _tmp_53 = m_axis_xor_tlast;

  always @(*) begin
    axis_in_xordata_tlast = _tmp_53;
  end

  wire [128-1:0] _tmp_54;
  assign _tmp_54 = m_axis_aes_xor_tdata;

  always @(*) begin
    axis_in_aes_tdata = _tmp_54;
  end

  wire _tmp_55;
  assign _tmp_55 = m_axis_aes_xor_tvalid;

  always @(*) begin
    axis_in_aes_tvalid = _tmp_55;
  end

  assign m_axis_aes_xor_tready = axis_in_aes_tready;
  wire _tmp_56;
  assign _tmp_56 = m_axis_aes_xor_tlast;

  always @(*) begin
    axis_in_aes_tlast = _tmp_56;
  end

  assign s_axis_xor_tdata = axis_out_xoreddata_tdata;
  assign s_axis_xor_tvalid = axis_out_xoreddata_tvalid;
  wire _tmp_57;
  assign _tmp_57 = s_axis_xor_tready;

  always @(*) begin
    axis_out_xoreddata_tready = _tmp_57;
  end

  assign s_axis_xor_tlast = axis_out_xoreddata_tlast;
  reg [128-1:0] otp_58;
  reg [128-1:0] data_59;
  reg [128-1:0] read_data_60;
  wire [4-1:0] xor_ram_0_addr;
  wire [128-1:0] xor_ram_0_rdata;
  wire [128-1:0] xor_ram_0_wdata;
  wire xor_ram_0_wenable;
  wire xor_ram_0_enable;

  xor_ram
  inst_xor_ram
  (
    .CLK(CLK),
    .xor_ram_0_addr(xor_ram_0_addr),
    .xor_ram_0_rdata(xor_ram_0_rdata),
    .xor_ram_0_wdata(xor_ram_0_wdata),
    .xor_ram_0_wenable(xor_ram_0_wenable),
    .xor_ram_0_enable(xor_ram_0_enable)
  );

  reg [32-1:0] th_read;
  localparam th_read_init = 0;
  reg signed [32-1:0] _th_read_i_2;
  reg signed [128-1:0] axistreamin_tdata_61;
  reg axistreamin_tlast_62;
  assign s_axis_xor_tready = th_read == 4;
  reg signed [32-1:0] _th_read_last_3;
  reg [32-1:0] th_ctrl;
  localparam th_ctrl_init = 0;
  reg _maxi_xor_waddr_cond_0_1;
  reg _maxi_xor_wdata_cond_0_1;
  reg signed [32-1:0] _th_ctrl_i_4;
  assign xor_ram_0_wdata = (th_ctrl == 9)? data_59 : 'hx;
  assign xor_ram_0_wenable = (th_ctrl == 9)? 1'd1 : 0;
  wire [8-1:0] pack_write_req_op_sel_63;
  wire [32-1:0] pack_write_req_local_addr_64;
  wire [32-1:0] pack_write_req_local_stride_65;
  wire [33-1:0] pack_write_req_local_size_66;
  assign pack_write_req_op_sel_63 = 1;
  assign pack_write_req_local_addr_64 = 0;
  assign pack_write_req_local_stride_65 = 1;
  assign pack_write_req_local_size_66 = 4;
  wire [105-1:0] pack_write_req_packed_67;
  assign pack_write_req_packed_67 = { pack_write_req_op_sel_63, pack_write_req_local_addr_64, pack_write_req_local_stride_65, pack_write_req_local_size_66 };
  assign _m_axis_xor_write_req_fifo_wdata = ((th_ctrl == 11) && !_m_axis_xor_write_req_fifo_almost_full)? pack_write_req_packed_67 : 'hx;
  assign _m_axis_xor_write_req_fifo_enq = ((th_ctrl == 11) && !_m_axis_xor_write_req_fifo_almost_full)? (th_ctrl == 11) && !_m_axis_xor_write_req_fifo_almost_full && !_m_axis_xor_write_req_fifo_almost_full : 0;
  localparam _tmp_68 = 1;
  wire [_tmp_68-1:0] _tmp_69;
  assign _tmp_69 = !_m_axis_xor_write_req_fifo_almost_full;
  reg [_tmp_68-1:0] __tmp_69_1;
  reg [32-1:0] _m_axis_xor_write_data_fsm;
  localparam _m_axis_xor_write_data_fsm_init = 0;
  assign _m_axis_xor_write_req_fifo_deq = ((_m_axis_xor_write_data_fsm == 0) && (!_m_axis_xor_write_data_busy && !_m_axis_xor_write_req_fifo_empty && (_m_axis_xor_write_op_sel_fifo == 1)) && !_m_axis_xor_write_req_fifo_empty)? 1 : 0;
  reg [32-1:0] read_burst_fsm_1;
  localparam read_burst_fsm_1_init = 0;
  reg [4-1:0] read_burst_addr_70;
  reg [4-1:0] read_burst_stride_71;
  reg [33-1:0] read_burst_length_72;
  reg read_burst_rvalid_73;
  reg read_burst_rlast_74;
  assign xor_ram_0_addr = ((read_burst_fsm_1 == 1) && (!read_burst_rvalid_73 || (m_axis_xor_tready || !m_axis_xor_tvalid)))? read_burst_addr_70 : 
                          (th_ctrl == 9)? _th_ctrl_i_4 : 'hx;
  assign xor_ram_0_enable = ((read_burst_fsm_1 == 1) && (!read_burst_rvalid_73 || (m_axis_xor_tready || !m_axis_xor_tvalid)))? 1'd1 : 
                            (th_ctrl == 9)? 1'd1 : 0;
  localparam _tmp_75 = 1;
  wire [_tmp_75-1:0] _tmp_76;
  assign _tmp_76 = (read_burst_fsm_1 == 1) && (!read_burst_rvalid_73 || (m_axis_xor_tready || !m_axis_xor_tvalid));
  reg [_tmp_75-1:0] __tmp_76_1;
  wire [128-1:0] read_burst_rdata_77;
  assign read_burst_rdata_77 = xor_ram_0_rdata;
  reg _m_axis_xor_cond_0_1;
  reg _m_axis_aes_xor_cond_0_1;
  reg _maxi_xor_raddr_cond_0_1;
  reg signed [64-1:0] axim_rdata_78;
  assign _maxi_xor_rready_sb_0 = th_ctrl == 21;
  reg signed [32-1:0] _th_ctrl_v_5;

  xored
  uut
  (
    .CLK(CLK),
    .RST(RST),
    .axi_s_ctrl_xored_awaddr(axi_s_ctrl_xored_awaddr),
    .axi_s_ctrl_xored_awcache(axi_s_ctrl_xored_awcache),
    .axi_s_ctrl_xored_awprot(axi_s_ctrl_xored_awprot),
    .axi_s_ctrl_xored_awvalid(axi_s_ctrl_xored_awvalid),
    .axi_s_ctrl_xored_awready(axi_s_ctrl_xored_awready),
    .axi_s_ctrl_xored_wdata(axi_s_ctrl_xored_wdata),
    .axi_s_ctrl_xored_wstrb(axi_s_ctrl_xored_wstrb),
    .axi_s_ctrl_xored_wvalid(axi_s_ctrl_xored_wvalid),
    .axi_s_ctrl_xored_wready(axi_s_ctrl_xored_wready),
    .axi_s_ctrl_xored_bresp(axi_s_ctrl_xored_bresp),
    .axi_s_ctrl_xored_bvalid(axi_s_ctrl_xored_bvalid),
    .axi_s_ctrl_xored_bready(axi_s_ctrl_xored_bready),
    .axi_s_ctrl_xored_araddr(axi_s_ctrl_xored_araddr),
    .axi_s_ctrl_xored_arcache(axi_s_ctrl_xored_arcache),
    .axi_s_ctrl_xored_arprot(axi_s_ctrl_xored_arprot),
    .axi_s_ctrl_xored_arvalid(axi_s_ctrl_xored_arvalid),
    .axi_s_ctrl_xored_arready(axi_s_ctrl_xored_arready),
    .axi_s_ctrl_xored_rdata(axi_s_ctrl_xored_rdata),
    .axi_s_ctrl_xored_rresp(axi_s_ctrl_xored_rresp),
    .axi_s_ctrl_xored_rvalid(axi_s_ctrl_xored_rvalid),
    .axi_s_ctrl_xored_rready(axi_s_ctrl_xored_rready),
    .axis_in_xordata_tdata(axis_in_xordata_tdata),
    .axis_in_xordata_tvalid(axis_in_xordata_tvalid),
    .axis_in_xordata_tready(axis_in_xordata_tready),
    .axis_in_xordata_tlast(axis_in_xordata_tlast),
    .axis_out_xoreddata_tdata(axis_out_xoreddata_tdata),
    .axis_out_xoreddata_tvalid(axis_out_xoreddata_tvalid),
    .axis_out_xoreddata_tready(axis_out_xoreddata_tready),
    .axis_out_xoreddata_tlast(axis_out_xoreddata_tlast),
    .axis_in_aes_tdata(axis_in_aes_tdata),
    .axis_in_aes_tvalid(axis_in_aes_tvalid),
    .axis_in_aes_tready(axis_in_aes_tready),
    .axis_in_aes_tlast(axis_in_aes_tlast)
  );


  initial begin
    CLK = 0;
    forever begin
      #5 CLK = !CLK;
    end
  end


  initial begin
    RST = 0;
    maxi_xor_awaddr = 0;
    maxi_xor_awvalid = 0;
    _maxi_xor_wdata_sb_0 = 0;
    _maxi_xor_wstrb_sb_0 = 0;
    _maxi_xor_wvalid_sb_0 = 0;
    _sb_maxi_xor_writedata_data_5 = 0;
    _sb_maxi_xor_writedata_valid_6 = 0;
    _sb_maxi_xor_writedata_tmp_data_8 = 0;
    _sb_maxi_xor_writedata_tmp_valid_9 = 0;
    maxi_xor_araddr = 0;
    maxi_xor_arvalid = 0;
    _sb_maxi_xor_readdata_data_18 = 0;
    _sb_maxi_xor_readdata_valid_19 = 0;
    _sb_maxi_xor_readdata_tmp_data_21 = 0;
    _sb_maxi_xor_readdata_tmp_valid_22 = 0;
    _maxi_xor_outstanding_wcount = 0;
    m_axis_xor_tdata = 0;
    m_axis_xor_tvalid = 0;
    m_axis_xor_tlast = 0;
    count__m_axis_xor_write_req_fifo = 0;
    _m_axis_xor_write_op_sel_buf = 0;
    _m_axis_xor_write_local_addr_buf = 0;
    _m_axis_xor_write_local_stride_buf = 0;
    _m_axis_xor_write_size_buf = 0;
    _m_axis_xor_write_data_busy = 0;
    m_axis_aes_xor_tdata = 0;
    m_axis_aes_xor_tvalid = 0;
    m_axis_aes_xor_tlast = 0;
    count__m_axis_aes_xor_write_req_fifo = 0;
    _m_axis_aes_xor_write_op_sel_buf = 0;
    _m_axis_aes_xor_write_local_addr_buf = 0;
    _m_axis_aes_xor_write_local_stride_buf = 0;
    _m_axis_aes_xor_write_size_buf = 0;
    _m_axis_aes_xor_write_data_busy = 0;
    count__s_axis_xor_read_req_fifo = 0;
    _s_axis_xor_read_op_sel_buf = 0;
    _s_axis_xor_read_local_addr_buf = 0;
    _s_axis_xor_read_local_stride_buf = 0;
    _s_axis_xor_read_local_size_buf = 0;
    _s_axis_xor_read_data_busy = 0;
    otp_58 = 0;
    data_59 = 0;
    read_data_60 = 0;
    th_read = th_read_init;
    _th_read_i_2 = 0;
    axistreamin_tdata_61 = 0;
    axistreamin_tlast_62 = 0;
    _th_read_last_3 = 0;
    th_ctrl = th_ctrl_init;
    _maxi_xor_waddr_cond_0_1 = 0;
    _maxi_xor_wdata_cond_0_1 = 0;
    _th_ctrl_i_4 = 0;
    __tmp_69_1 = 0;
    _m_axis_xor_write_data_fsm = _m_axis_xor_write_data_fsm_init;
    read_burst_fsm_1 = read_burst_fsm_1_init;
    read_burst_addr_70 = 0;
    read_burst_stride_71 = 0;
    read_burst_length_72 = 0;
    read_burst_rvalid_73 = 0;
    read_burst_rlast_74 = 0;
    __tmp_76_1 = 0;
    _m_axis_xor_cond_0_1 = 0;
    _m_axis_aes_xor_cond_0_1 = 0;
    _maxi_xor_raddr_cond_0_1 = 0;
    axim_rdata_78 = 0;
    _th_ctrl_v_5 = 0;
    #100;
    RST = 1;
    #100;
    RST = 0;
    #1000000;
    $finish;
  end


  always @(posedge CLK) begin
    if(RST) begin
      maxi_xor_awaddr <= 0;
      maxi_xor_awvalid <= 0;
      _maxi_xor_waddr_cond_0_1 <= 0;
    end else begin
      if(_maxi_xor_waddr_cond_0_1) begin
        maxi_xor_awvalid <= 0;
      end 
      if((th_ctrl == 1) && ((_maxi_xor_outstanding_wcount == 0) && (maxi_xor_awready || !maxi_xor_awvalid))) begin
        maxi_xor_awaddr <= 0;
        maxi_xor_awvalid <= 1;
      end 
      _maxi_xor_waddr_cond_0_1 <= 1;
      if(maxi_xor_awvalid && !maxi_xor_awready) begin
        maxi_xor_awvalid <= maxi_xor_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _maxi_xor_wdata_sb_0 <= 0;
      _maxi_xor_wvalid_sb_0 <= 0;
      _maxi_xor_wstrb_sb_0 <= 0;
      _maxi_xor_wdata_cond_0_1 <= 0;
    end else begin
      if(_maxi_xor_wdata_cond_0_1) begin
        _maxi_xor_wvalid_sb_0 <= 0;
      end 
      if((th_ctrl == 3) && (_maxi_xor_wready_sb_0 || !_maxi_xor_wvalid_sb_0)) begin
        _maxi_xor_wdata_sb_0 <= 1;
        _maxi_xor_wvalid_sb_0 <= 1;
        _maxi_xor_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_xor_wdata_cond_0_1 <= 1;
      if(_maxi_xor_wvalid_sb_0 && !_maxi_xor_wready_sb_0) begin
        _maxi_xor_wvalid_sb_0 <= _maxi_xor_wvalid_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_xor_writedata_data_5 <= 0;
      _sb_maxi_xor_writedata_valid_6 <= 0;
      _sb_maxi_xor_writedata_tmp_data_8 <= 0;
      _sb_maxi_xor_writedata_tmp_valid_9 <= 0;
    end else begin
      if(_sb_maxi_xor_writedata_m_ready_4 || !_sb_maxi_xor_writedata_valid_6) begin
        _sb_maxi_xor_writedata_data_5 <= _sb_maxi_xor_writedata_next_data_10;
        _sb_maxi_xor_writedata_valid_6 <= _sb_maxi_xor_writedata_next_valid_11;
      end 
      if(!_sb_maxi_xor_writedata_tmp_valid_9 && _sb_maxi_xor_writedata_valid_6 && !_sb_maxi_xor_writedata_m_ready_4) begin
        _sb_maxi_xor_writedata_tmp_data_8 <= _sb_maxi_xor_writedata_s_data_2;
        _sb_maxi_xor_writedata_tmp_valid_9 <= _sb_maxi_xor_writedata_s_valid_3;
      end 
      if(_sb_maxi_xor_writedata_tmp_valid_9 && _sb_maxi_xor_writedata_m_ready_4) begin
        _sb_maxi_xor_writedata_tmp_valid_9 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      maxi_xor_araddr <= 0;
      maxi_xor_arvalid <= 0;
      _maxi_xor_raddr_cond_0_1 <= 0;
    end else begin
      if(_maxi_xor_raddr_cond_0_1) begin
        maxi_xor_arvalid <= 0;
      end 
      if((th_ctrl == 19) && (maxi_xor_arready || !maxi_xor_arvalid)) begin
        maxi_xor_araddr <= 0;
        maxi_xor_arvalid <= 1;
      end 
      _maxi_xor_raddr_cond_0_1 <= 1;
      if(maxi_xor_arvalid && !maxi_xor_arready) begin
        maxi_xor_arvalid <= maxi_xor_arvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_xor_readdata_data_18 <= 0;
      _sb_maxi_xor_readdata_valid_19 <= 0;
      _sb_maxi_xor_readdata_tmp_data_21 <= 0;
      _sb_maxi_xor_readdata_tmp_valid_22 <= 0;
    end else begin
      if(_sb_maxi_xor_readdata_m_ready_17 || !_sb_maxi_xor_readdata_valid_19) begin
        _sb_maxi_xor_readdata_data_18 <= _sb_maxi_xor_readdata_next_data_23;
        _sb_maxi_xor_readdata_valid_19 <= _sb_maxi_xor_readdata_next_valid_24;
      end 
      if(!_sb_maxi_xor_readdata_tmp_valid_22 && _sb_maxi_xor_readdata_valid_19 && !_sb_maxi_xor_readdata_m_ready_17) begin
        _sb_maxi_xor_readdata_tmp_data_21 <= _sb_maxi_xor_readdata_s_data_15;
        _sb_maxi_xor_readdata_tmp_valid_22 <= _sb_maxi_xor_readdata_s_valid_16;
      end 
      if(_sb_maxi_xor_readdata_tmp_valid_22 && _sb_maxi_xor_readdata_m_ready_17) begin
        _sb_maxi_xor_readdata_tmp_valid_22 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _maxi_xor_outstanding_wcount <= 0;
    end else begin
      if(maxi_xor_awvalid && maxi_xor_awready && !(maxi_xor_bvalid && maxi_xor_bready) && (_maxi_xor_outstanding_wcount < 7)) begin
        _maxi_xor_outstanding_wcount <= _maxi_xor_outstanding_wcount + 1;
      end 
      if(!(maxi_xor_awvalid && maxi_xor_awready) && (maxi_xor_bvalid && maxi_xor_bready) && (_maxi_xor_outstanding_wcount > 0)) begin
        _maxi_xor_outstanding_wcount <= _maxi_xor_outstanding_wcount - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      m_axis_xor_tdata <= 0;
      m_axis_xor_tvalid <= 0;
      m_axis_xor_tlast <= 0;
      _m_axis_xor_cond_0_1 <= 0;
    end else begin
      if(_m_axis_xor_cond_0_1) begin
        m_axis_xor_tvalid <= 0;
        m_axis_xor_tlast <= 0;
      end 
      if((_m_axis_xor_write_op_sel_buf == 1) && read_burst_rvalid_73 && (m_axis_xor_tready || !m_axis_xor_tvalid) && (m_axis_xor_tready || !m_axis_xor_tvalid)) begin
        m_axis_xor_tdata <= read_burst_rdata_77;
        m_axis_xor_tvalid <= 1;
        m_axis_xor_tlast <= read_burst_rlast_74;
      end 
      _m_axis_xor_cond_0_1 <= 1;
      if(m_axis_xor_tvalid && !m_axis_xor_tready) begin
        m_axis_xor_tvalid <= m_axis_xor_tvalid;
        m_axis_xor_tlast <= m_axis_xor_tlast;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _m_axis_xor_write_data_busy <= 0;
      _m_axis_xor_write_op_sel_buf <= 0;
      _m_axis_xor_write_local_addr_buf <= 0;
      _m_axis_xor_write_local_stride_buf <= 0;
      _m_axis_xor_write_size_buf <= 0;
    end else begin
      if((_m_axis_xor_write_data_fsm == 0) && (!_m_axis_xor_write_data_busy && !_m_axis_xor_write_req_fifo_empty && (_m_axis_xor_write_op_sel_fifo == 1))) begin
        _m_axis_xor_write_data_busy <= 1;
        _m_axis_xor_write_op_sel_buf <= _m_axis_xor_write_op_sel_fifo;
        _m_axis_xor_write_local_addr_buf <= _m_axis_xor_write_local_addr_fifo;
        _m_axis_xor_write_local_stride_buf <= _m_axis_xor_write_local_stride_fifo;
        _m_axis_xor_write_size_buf <= _m_axis_xor_write_size_fifo;
      end 
      if((_m_axis_xor_write_data_fsm == 2) && ((_m_axis_xor_write_op_sel_buf == 1) && read_burst_rvalid_73 && (m_axis_xor_tready || !m_axis_xor_tvalid))) begin
        _m_axis_xor_write_size_buf <= _m_axis_xor_write_size_buf - 1;
      end 
      if((_m_axis_xor_write_data_fsm == 2) && ((_m_axis_xor_write_op_sel_buf == 1) && read_burst_rvalid_73 && (m_axis_xor_tready || !m_axis_xor_tvalid)) && read_burst_rlast_74) begin
        _m_axis_xor_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__m_axis_xor_write_req_fifo <= 0;
      __tmp_69_1 <= 0;
    end else begin
      if(_m_axis_xor_write_req_fifo_enq && !_m_axis_xor_write_req_fifo_full && (_m_axis_xor_write_req_fifo_deq && !_m_axis_xor_write_req_fifo_empty)) begin
        count__m_axis_xor_write_req_fifo <= count__m_axis_xor_write_req_fifo;
      end else if(_m_axis_xor_write_req_fifo_enq && !_m_axis_xor_write_req_fifo_full) begin
        count__m_axis_xor_write_req_fifo <= count__m_axis_xor_write_req_fifo + 1;
      end else if(_m_axis_xor_write_req_fifo_deq && !_m_axis_xor_write_req_fifo_empty) begin
        count__m_axis_xor_write_req_fifo <= count__m_axis_xor_write_req_fifo - 1;
      end 
      __tmp_69_1 <= _tmp_69;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      m_axis_aes_xor_tdata <= 0;
      m_axis_aes_xor_tvalid <= 0;
      m_axis_aes_xor_tlast <= 0;
      _m_axis_aes_xor_cond_0_1 <= 0;
    end else begin
      if(_m_axis_aes_xor_cond_0_1) begin
        m_axis_aes_xor_tvalid <= 0;
        m_axis_aes_xor_tlast <= 0;
      end 
      if((th_ctrl == 16) && (m_axis_aes_xor_tready || !m_axis_aes_xor_tvalid)) begin
        m_axis_aes_xor_tdata <= otp_58;
        m_axis_aes_xor_tvalid <= 1;
        m_axis_aes_xor_tlast <= _th_ctrl_i_4 == 3;
      end 
      _m_axis_aes_xor_cond_0_1 <= 1;
      if(m_axis_aes_xor_tvalid && !m_axis_aes_xor_tready) begin
        m_axis_aes_xor_tvalid <= m_axis_aes_xor_tvalid;
        m_axis_aes_xor_tlast <= m_axis_aes_xor_tlast;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _m_axis_aes_xor_write_data_busy <= 0;
    end else begin
      if((th_ctrl == 15) && _m_axis_aes_xor_write_idle) begin
        _m_axis_aes_xor_write_data_busy <= 1;
      end 
      if((th_ctrl == 16) && (m_axis_aes_xor_tready || !m_axis_aes_xor_tvalid)) begin
        _m_axis_aes_xor_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__m_axis_aes_xor_write_req_fifo <= 0;
    end else begin
      if(_m_axis_aes_xor_write_req_fifo_enq && !_m_axis_aes_xor_write_req_fifo_full && (_m_axis_aes_xor_write_req_fifo_deq && !_m_axis_aes_xor_write_req_fifo_empty)) begin
        count__m_axis_aes_xor_write_req_fifo <= count__m_axis_aes_xor_write_req_fifo;
      end else if(_m_axis_aes_xor_write_req_fifo_enq && !_m_axis_aes_xor_write_req_fifo_full) begin
        count__m_axis_aes_xor_write_req_fifo <= count__m_axis_aes_xor_write_req_fifo + 1;
      end else if(_m_axis_aes_xor_write_req_fifo_deq && !_m_axis_aes_xor_write_req_fifo_empty) begin
        count__m_axis_aes_xor_write_req_fifo <= count__m_axis_aes_xor_write_req_fifo - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _s_axis_xor_read_data_busy <= 0;
    end else begin
      if((th_read == 3) && _s_axis_xor_read_idle) begin
        _s_axis_xor_read_data_busy <= 1;
      end 
      if((th_read == 4) && s_axis_xor_tvalid) begin
        _s_axis_xor_read_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__s_axis_xor_read_req_fifo <= 0;
    end else begin
      if(_s_axis_xor_read_req_fifo_enq && !_s_axis_xor_read_req_fifo_full && (_s_axis_xor_read_req_fifo_deq && !_s_axis_xor_read_req_fifo_empty)) begin
        count__s_axis_xor_read_req_fifo <= count__s_axis_xor_read_req_fifo;
      end else if(_s_axis_xor_read_req_fifo_enq && !_s_axis_xor_read_req_fifo_full) begin
        count__s_axis_xor_read_req_fifo <= count__s_axis_xor_read_req_fifo + 1;
      end else if(_s_axis_xor_read_req_fifo_deq && !_s_axis_xor_read_req_fifo_empty) begin
        count__s_axis_xor_read_req_fifo <= count__s_axis_xor_read_req_fifo - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      __tmp_76_1 <= 0;
    end else begin
      __tmp_76_1 <= _tmp_76;
    end
  end

  localparam th_read_1 = 1;
  localparam th_read_2 = 2;
  localparam th_read_3 = 3;
  localparam th_read_4 = 4;
  localparam th_read_5 = 5;
  localparam th_read_6 = 6;
  localparam th_read_7 = 7;
  localparam th_read_8 = 8;

  always @(posedge CLK) begin
    if(RST) begin
      th_read <= th_read_init;
      _th_read_i_2 <= 0;
      axistreamin_tdata_61 <= 0;
      axistreamin_tlast_62 <= 0;
      read_data_60 <= 0;
      _th_read_last_3 <= 0;
    end else begin
      case(th_read)
        th_read_init: begin
          th_read <= th_read_1;
        end
        th_read_1: begin
          _th_read_i_2 <= 0;
          th_read <= th_read_2;
        end
        th_read_2: begin
          if(_th_read_i_2 < 4) begin
            th_read <= th_read_3;
          end else begin
            th_read <= th_read_8;
          end
        end
        th_read_3: begin
          if(_s_axis_xor_read_idle) begin
            th_read <= th_read_4;
          end 
        end
        th_read_4: begin
          if(s_axis_xor_tvalid) begin
            axistreamin_tdata_61 <= s_axis_xor_tdata;
          end 
          if(s_axis_xor_tvalid) begin
            axistreamin_tlast_62 <= s_axis_xor_tlast;
          end 
          if(s_axis_xor_tvalid) begin
            th_read <= th_read_5;
          end 
        end
        th_read_5: begin
          read_data_60 <= axistreamin_tdata_61;
          _th_read_last_3 <= axistreamin_tlast_62;
          th_read <= th_read_6;
        end
        th_read_6: begin
          $display("Received chunk %d: %x (last=%d)", _th_read_i_2, read_data_60, _th_read_last_3);
          th_read <= th_read_7;
        end
        th_read_7: begin
          _th_read_i_2 <= _th_read_i_2 + 1;
          th_read <= th_read_2;
        end
      endcase
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

  always @(posedge CLK) begin
    if(RST) begin
      th_ctrl <= th_ctrl_init;
      _th_ctrl_i_4 <= 0;
      data_59 <= 0;
      otp_58 <= 0;
      axim_rdata_78 <= 0;
      _th_ctrl_v_5 <= 0;
    end else begin
      case(th_ctrl)
        th_ctrl_init: begin
          th_ctrl <= th_ctrl_1;
        end
        th_ctrl_1: begin
          if((_maxi_xor_outstanding_wcount == 0) && (maxi_xor_awready || !maxi_xor_awvalid)) begin
            th_ctrl <= th_ctrl_2;
          end 
        end
        th_ctrl_2: begin
          if(maxi_xor_awvalid && maxi_xor_awready) begin
            th_ctrl <= th_ctrl_3;
          end 
        end
        th_ctrl_3: begin
          if(_maxi_xor_wready_sb_0 || !_maxi_xor_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_4;
          end 
        end
        th_ctrl_4: begin
          if(_maxi_xor_wvalid_sb_0 && _maxi_xor_wready_sb_0) begin
            th_ctrl <= th_ctrl_5;
          end 
        end
        th_ctrl_5: begin
          if(!_maxi_xor_has_outstanding_write) begin
            th_ctrl <= th_ctrl_6;
          end 
        end
        th_ctrl_6: begin
          _th_ctrl_i_4 <= 0;
          th_ctrl <= th_ctrl_7;
        end
        th_ctrl_7: begin
          if(_th_ctrl_i_4 < 4) begin
            th_ctrl <= th_ctrl_8;
          end else begin
            th_ctrl <= th_ctrl_11;
          end
        end
        th_ctrl_8: begin
          data_59 <= _th_ctrl_i_4;
          th_ctrl <= th_ctrl_9;
        end
        th_ctrl_9: begin
          th_ctrl <= th_ctrl_10;
        end
        th_ctrl_10: begin
          _th_ctrl_i_4 <= _th_ctrl_i_4 + 1;
          th_ctrl <= th_ctrl_7;
        end
        th_ctrl_11: begin
          if(!_m_axis_xor_write_req_fifo_almost_full) begin
            th_ctrl <= th_ctrl_12;
          end 
        end
        th_ctrl_12: begin
          _th_ctrl_i_4 <= 0;
          th_ctrl <= th_ctrl_13;
        end
        th_ctrl_13: begin
          if(_th_ctrl_i_4 < 4) begin
            th_ctrl <= th_ctrl_14;
          end else begin
            th_ctrl <= th_ctrl_18;
          end
        end
        th_ctrl_14: begin
          otp_58 <= _th_ctrl_i_4 + 4096;
          th_ctrl <= th_ctrl_15;
        end
        th_ctrl_15: begin
          if(_m_axis_aes_xor_write_idle) begin
            th_ctrl <= th_ctrl_16;
          end 
        end
        th_ctrl_16: begin
          if(m_axis_aes_xor_tready || !m_axis_aes_xor_tvalid) begin
            th_ctrl <= th_ctrl_17;
          end 
        end
        th_ctrl_17: begin
          _th_ctrl_i_4 <= _th_ctrl_i_4 + 1;
          th_ctrl <= th_ctrl_13;
        end
        th_ctrl_18: begin
          if(1) begin
            th_ctrl <= th_ctrl_19;
          end else begin
            th_ctrl <= th_ctrl_26;
          end
        end
        th_ctrl_19: begin
          if(maxi_xor_arready || !maxi_xor_arvalid) begin
            th_ctrl <= th_ctrl_20;
          end 
        end
        th_ctrl_20: begin
          if(maxi_xor_arvalid && maxi_xor_arready) begin
            th_ctrl <= th_ctrl_21;
          end 
        end
        th_ctrl_21: begin
          if(_maxi_xor_rvalid_sb_0) begin
            axim_rdata_78 <= _maxi_xor_rdata_sb_0;
          end 
          if(_maxi_xor_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_22;
          end 
        end
        th_ctrl_22: begin
          _th_ctrl_v_5 <= axim_rdata_78;
          th_ctrl <= th_ctrl_23;
        end
        th_ctrl_23: begin
          if(_th_ctrl_v_5 == 0) begin
            th_ctrl <= th_ctrl_24;
          end else begin
            th_ctrl <= th_ctrl_25;
          end
        end
        th_ctrl_24: begin
          th_ctrl <= th_ctrl_26;
        end
        th_ctrl_25: begin
          th_ctrl <= th_ctrl_18;
        end
      endcase
    end
  end

  localparam _m_axis_xor_write_data_fsm_1 = 1;
  localparam _m_axis_xor_write_data_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _m_axis_xor_write_data_fsm <= _m_axis_xor_write_data_fsm_init;
    end else begin
      case(_m_axis_xor_write_data_fsm)
        _m_axis_xor_write_data_fsm_init: begin
          if(!_m_axis_xor_write_data_busy && !_m_axis_xor_write_req_fifo_empty && (_m_axis_xor_write_op_sel_fifo == 1)) begin
            _m_axis_xor_write_data_fsm <= _m_axis_xor_write_data_fsm_1;
          end 
        end
        _m_axis_xor_write_data_fsm_1: begin
          _m_axis_xor_write_data_fsm <= _m_axis_xor_write_data_fsm_2;
        end
        _m_axis_xor_write_data_fsm_2: begin
          if((_m_axis_xor_write_op_sel_buf == 1) && read_burst_rvalid_73 && (m_axis_xor_tready || !m_axis_xor_tvalid) && read_burst_rlast_74) begin
            _m_axis_xor_write_data_fsm <= _m_axis_xor_write_data_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam read_burst_fsm_1_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      read_burst_fsm_1 <= read_burst_fsm_1_init;
      read_burst_addr_70 <= 0;
      read_burst_stride_71 <= 0;
      read_burst_length_72 <= 0;
      read_burst_rvalid_73 <= 0;
      read_burst_rlast_74 <= 0;
    end else begin
      case(read_burst_fsm_1)
        read_burst_fsm_1_init: begin
          read_burst_addr_70 <= _m_axis_xor_write_local_addr_buf;
          read_burst_stride_71 <= _m_axis_xor_write_local_stride_buf;
          read_burst_length_72 <= _m_axis_xor_write_size_buf;
          read_burst_rvalid_73 <= 0;
          read_burst_rlast_74 <= 0;
          if((_m_axis_xor_write_data_fsm == 1) && (_m_axis_xor_write_op_sel_buf == 1) && (_m_axis_xor_write_size_buf > 0)) begin
            read_burst_fsm_1 <= read_burst_fsm_1_1;
          end 
        end
        read_burst_fsm_1_1: begin
          if((m_axis_xor_tready || !m_axis_xor_tvalid) && (read_burst_length_72 > 0)) begin
            read_burst_addr_70 <= read_burst_addr_70 + read_burst_stride_71;
            read_burst_length_72 <= read_burst_length_72 - 1;
            read_burst_rvalid_73 <= 1;
          end 
          if((m_axis_xor_tready || !m_axis_xor_tvalid) && (read_burst_length_72 <= 1)) begin
            read_burst_rlast_74 <= 1;
          end 
          if(read_burst_rlast_74 && read_burst_rvalid_73 && (m_axis_xor_tready || !m_axis_xor_tvalid)) begin
            read_burst_rvalid_73 <= 0;
            read_burst_rlast_74 <= 0;
          end 
          if(0) begin
            read_burst_rvalid_73 <= 0;
            read_burst_rlast_74 <= 0;
          end 
          if(read_burst_rlast_74 && read_burst_rvalid_73 && (m_axis_xor_tready || !m_axis_xor_tvalid)) begin
            read_burst_fsm_1 <= read_burst_fsm_1_init;
          end 
          if(0) begin
            read_burst_fsm_1 <= read_burst_fsm_1_init;
          end 
        end
      endcase
    end
  end


endmodule



module _m_axis_xor_write_req_fifo
(
  input CLK,
  input RST,
  input _m_axis_xor_write_req_fifo_enq,
  input [105-1:0] _m_axis_xor_write_req_fifo_wdata,
  output _m_axis_xor_write_req_fifo_full,
  output _m_axis_xor_write_req_fifo_almost_full,
  input _m_axis_xor_write_req_fifo_deq,
  output [105-1:0] _m_axis_xor_write_req_fifo_rdata,
  output _m_axis_xor_write_req_fifo_empty,
  output _m_axis_xor_write_req_fifo_almost_empty
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
  assign _m_axis_xor_write_req_fifo_full = is_full;
  assign _m_axis_xor_write_req_fifo_almost_full = is_almost_full || is_full;
  assign _m_axis_xor_write_req_fifo_empty = is_empty;
  assign _m_axis_xor_write_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _m_axis_xor_write_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_m_axis_xor_write_req_fifo_enq && !is_full) begin
        mem[head] <= _m_axis_xor_write_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_m_axis_xor_write_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _m_axis_aes_xor_write_req_fifo
(
  input CLK,
  input RST,
  input _m_axis_aes_xor_write_req_fifo_enq,
  input [105-1:0] _m_axis_aes_xor_write_req_fifo_wdata,
  output _m_axis_aes_xor_write_req_fifo_full,
  output _m_axis_aes_xor_write_req_fifo_almost_full,
  input _m_axis_aes_xor_write_req_fifo_deq,
  output [105-1:0] _m_axis_aes_xor_write_req_fifo_rdata,
  output _m_axis_aes_xor_write_req_fifo_empty,
  output _m_axis_aes_xor_write_req_fifo_almost_empty
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
  assign _m_axis_aes_xor_write_req_fifo_full = is_full;
  assign _m_axis_aes_xor_write_req_fifo_almost_full = is_almost_full || is_full;
  assign _m_axis_aes_xor_write_req_fifo_empty = is_empty;
  assign _m_axis_aes_xor_write_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _m_axis_aes_xor_write_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_m_axis_aes_xor_write_req_fifo_enq && !is_full) begin
        mem[head] <= _m_axis_aes_xor_write_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_m_axis_aes_xor_write_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _s_axis_xor_read_req_fifo
(
  input CLK,
  input RST,
  input _s_axis_xor_read_req_fifo_enq,
  input [105-1:0] _s_axis_xor_read_req_fifo_wdata,
  output _s_axis_xor_read_req_fifo_full,
  output _s_axis_xor_read_req_fifo_almost_full,
  input _s_axis_xor_read_req_fifo_deq,
  output [105-1:0] _s_axis_xor_read_req_fifo_rdata,
  output _s_axis_xor_read_req_fifo_empty,
  output _s_axis_xor_read_req_fifo_almost_empty
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
  assign _s_axis_xor_read_req_fifo_full = is_full;
  assign _s_axis_xor_read_req_fifo_almost_full = is_almost_full || is_full;
  assign _s_axis_xor_read_req_fifo_empty = is_empty;
  assign _s_axis_xor_read_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _s_axis_xor_read_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_s_axis_xor_read_req_fifo_enq && !is_full) begin
        mem[head] <= _s_axis_xor_read_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_s_axis_xor_read_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module xor_ram
(
  input CLK,
  input [2-1:0] xor_ram_0_addr,
  output [128-1:0] xor_ram_0_rdata,
  input [128-1:0] xor_ram_0_wdata,
  input xor_ram_0_wenable,
  input xor_ram_0_enable
);

  reg [128-1:0] xor_ram_0_rdata_out;
  assign xor_ram_0_rdata = xor_ram_0_rdata_out;
  reg [128-1:0] mem [0:4-1];

  always @(posedge CLK) begin
    if(xor_ram_0_enable) begin
      if(xor_ram_0_wenable) begin
        mem[xor_ram_0_addr] <= xor_ram_0_wdata;
        xor_ram_0_rdata_out <= xor_ram_0_wdata;
      end else begin
        xor_ram_0_rdata_out <= mem[xor_ram_0_addr];
      end
    end 
  end


endmodule



module xored
(
  input CLK,
  input RST,
  input [32-1:0] axi_s_ctrl_xored_awaddr,
  input [4-1:0] axi_s_ctrl_xored_awcache,
  input [3-1:0] axi_s_ctrl_xored_awprot,
  input axi_s_ctrl_xored_awvalid,
  output axi_s_ctrl_xored_awready,
  input [64-1:0] axi_s_ctrl_xored_wdata,
  input [8-1:0] axi_s_ctrl_xored_wstrb,
  input axi_s_ctrl_xored_wvalid,
  output axi_s_ctrl_xored_wready,
  output [2-1:0] axi_s_ctrl_xored_bresp,
  output reg axi_s_ctrl_xored_bvalid,
  input axi_s_ctrl_xored_bready,
  input [32-1:0] axi_s_ctrl_xored_araddr,
  input [4-1:0] axi_s_ctrl_xored_arcache,
  input [3-1:0] axi_s_ctrl_xored_arprot,
  input axi_s_ctrl_xored_arvalid,
  output axi_s_ctrl_xored_arready,
  output reg [64-1:0] axi_s_ctrl_xored_rdata,
  output [2-1:0] axi_s_ctrl_xored_rresp,
  output reg axi_s_ctrl_xored_rvalid,
  input axi_s_ctrl_xored_rready,
  input [128-1:0] axis_in_xordata_tdata,
  input axis_in_xordata_tvalid,
  output axis_in_xordata_tready,
  input axis_in_xordata_tlast,
  output reg [128-1:0] axis_out_xoreddata_tdata,
  output reg axis_out_xoreddata_tvalid,
  input axis_out_xoreddata_tready,
  output reg axis_out_xoreddata_tlast,
  input [128-1:0] axis_in_aes_tdata,
  input axis_in_aes_tvalid,
  output axis_in_aes_tready,
  input axis_in_aes_tlast
);

  assign axi_s_ctrl_xored_bresp = 0;
  assign axi_s_ctrl_xored_rresp = 0;
  reg signed [64-1:0] _axi_s_ctrl_xored_register_0;
  reg signed [64-1:0] _axi_s_ctrl_xored_register_1;
  reg _axi_s_ctrl_xored_flag_0;
  reg _axi_s_ctrl_xored_flag_1;
  reg signed [64-1:0] _axi_s_ctrl_xored_resetval_0;
  reg signed [64-1:0] _axi_s_ctrl_xored_resetval_1;
  localparam _axi_s_ctrl_xored_maskwidth = 1;
  localparam _axi_s_ctrl_xored_mask = { _axi_s_ctrl_xored_maskwidth{ 1'd1 } };
  localparam _axi_s_ctrl_xored_shift = 3;
  reg [32-1:0] _axi_s_ctrl_xored_register_fsm;
  localparam _axi_s_ctrl_xored_register_fsm_init = 0;
  reg [32-1:0] addr_0;
  reg writevalid_1;
  reg readvalid_2;
  reg prev_awvalid_3;
  reg prev_arvalid_4;
  assign axi_s_ctrl_xored_awready = (_axi_s_ctrl_xored_register_fsm == 0) && (!writevalid_1 && !readvalid_2 && !axi_s_ctrl_xored_bvalid && prev_awvalid_3);
  assign axi_s_ctrl_xored_arready = (_axi_s_ctrl_xored_register_fsm == 0) && (!readvalid_2 && !writevalid_1 && prev_arvalid_4 && !prev_awvalid_3);
  reg [_axi_s_ctrl_xored_maskwidth-1:0] axis_maskaddr_5;
  wire signed [64-1:0] axislite_rdata_6;
  assign axislite_rdata_6 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_xored_register_0 : 
                            (axis_maskaddr_5 == 1)? _axi_s_ctrl_xored_register_1 : 'hx;
  wire axislite_flag_7;
  assign axislite_flag_7 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_xored_flag_0 : 
                           (axis_maskaddr_5 == 1)? _axi_s_ctrl_xored_flag_1 : 'hx;
  wire signed [64-1:0] axislite_resetval_8;
  assign axislite_resetval_8 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_xored_resetval_0 : 
                               (axis_maskaddr_5 == 1)? _axi_s_ctrl_xored_resetval_1 : 'hx;
  reg _axi_s_ctrl_xored_rdata_cond_0_1;
  assign axi_s_ctrl_xored_wready = _axi_s_ctrl_xored_register_fsm == 3;
  wire _axis_in_xordata_read_req_fifo_enq;
  wire [105-1:0] _axis_in_xordata_read_req_fifo_wdata;
  wire _axis_in_xordata_read_req_fifo_full;
  wire _axis_in_xordata_read_req_fifo_almost_full;
  wire _axis_in_xordata_read_req_fifo_deq;
  wire [105-1:0] _axis_in_xordata_read_req_fifo_rdata;
  wire _axis_in_xordata_read_req_fifo_empty;
  wire _axis_in_xordata_read_req_fifo_almost_empty;
  assign _axis_in_xordata_read_req_fifo_enq = 0;
  assign _axis_in_xordata_read_req_fifo_wdata = 'hx;
  assign _axis_in_xordata_read_req_fifo_deq = 0;

  _axis_in_xordata_read_req_fifo
  inst__axis_in_xordata_read_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axis_in_xordata_read_req_fifo_enq(_axis_in_xordata_read_req_fifo_enq),
    ._axis_in_xordata_read_req_fifo_wdata(_axis_in_xordata_read_req_fifo_wdata),
    ._axis_in_xordata_read_req_fifo_full(_axis_in_xordata_read_req_fifo_full),
    ._axis_in_xordata_read_req_fifo_almost_full(_axis_in_xordata_read_req_fifo_almost_full),
    ._axis_in_xordata_read_req_fifo_deq(_axis_in_xordata_read_req_fifo_deq),
    ._axis_in_xordata_read_req_fifo_rdata(_axis_in_xordata_read_req_fifo_rdata),
    ._axis_in_xordata_read_req_fifo_empty(_axis_in_xordata_read_req_fifo_empty),
    ._axis_in_xordata_read_req_fifo_almost_empty(_axis_in_xordata_read_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axis_in_xordata_read_req_fifo;
  wire [8-1:0] _axis_in_xordata_read_op_sel_fifo;
  wire [32-1:0] _axis_in_xordata_read_local_addr_fifo;
  wire [32-1:0] _axis_in_xordata_read_local_stride_fifo;
  wire [33-1:0] _axis_in_xordata_read_local_size_fifo;
  wire [8-1:0] unpack_read_req_op_sel_9;
  wire [32-1:0] unpack_read_req_local_addr_10;
  wire [32-1:0] unpack_read_req_local_stride_11;
  wire [33-1:0] unpack_read_req_local_size_12;
  assign unpack_read_req_op_sel_9 = _axis_in_xordata_read_req_fifo_rdata[104:97];
  assign unpack_read_req_local_addr_10 = _axis_in_xordata_read_req_fifo_rdata[96:65];
  assign unpack_read_req_local_stride_11 = _axis_in_xordata_read_req_fifo_rdata[64:33];
  assign unpack_read_req_local_size_12 = _axis_in_xordata_read_req_fifo_rdata[32:0];
  assign _axis_in_xordata_read_op_sel_fifo = unpack_read_req_op_sel_9;
  assign _axis_in_xordata_read_local_addr_fifo = unpack_read_req_local_addr_10;
  assign _axis_in_xordata_read_local_stride_fifo = unpack_read_req_local_stride_11;
  assign _axis_in_xordata_read_local_size_fifo = unpack_read_req_local_size_12;
  reg [8-1:0] _axis_in_xordata_read_op_sel_buf;
  reg [32-1:0] _axis_in_xordata_read_local_addr_buf;
  reg [32-1:0] _axis_in_xordata_read_local_stride_buf;
  reg [33-1:0] _axis_in_xordata_read_local_size_buf;
  reg _axis_in_xordata_read_data_busy;
  wire _axis_in_xordata_read_data_idle;
  wire _axis_in_xordata_read_idle;
  assign _axis_in_xordata_read_data_idle = _axis_in_xordata_read_req_fifo_empty && !_axis_in_xordata_read_data_busy;
  assign _axis_in_xordata_read_idle = _axis_in_xordata_read_data_idle;
  wire _axis_out_xoreddata_write_req_fifo_enq;
  wire [105-1:0] _axis_out_xoreddata_write_req_fifo_wdata;
  wire _axis_out_xoreddata_write_req_fifo_full;
  wire _axis_out_xoreddata_write_req_fifo_almost_full;
  wire _axis_out_xoreddata_write_req_fifo_deq;
  wire [105-1:0] _axis_out_xoreddata_write_req_fifo_rdata;
  wire _axis_out_xoreddata_write_req_fifo_empty;
  wire _axis_out_xoreddata_write_req_fifo_almost_empty;

  _axis_out_xoreddata_write_req_fifo
  inst__axis_out_xoreddata_write_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axis_out_xoreddata_write_req_fifo_enq(_axis_out_xoreddata_write_req_fifo_enq),
    ._axis_out_xoreddata_write_req_fifo_wdata(_axis_out_xoreddata_write_req_fifo_wdata),
    ._axis_out_xoreddata_write_req_fifo_full(_axis_out_xoreddata_write_req_fifo_full),
    ._axis_out_xoreddata_write_req_fifo_almost_full(_axis_out_xoreddata_write_req_fifo_almost_full),
    ._axis_out_xoreddata_write_req_fifo_deq(_axis_out_xoreddata_write_req_fifo_deq),
    ._axis_out_xoreddata_write_req_fifo_rdata(_axis_out_xoreddata_write_req_fifo_rdata),
    ._axis_out_xoreddata_write_req_fifo_empty(_axis_out_xoreddata_write_req_fifo_empty),
    ._axis_out_xoreddata_write_req_fifo_almost_empty(_axis_out_xoreddata_write_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axis_out_xoreddata_write_req_fifo;
  wire [8-1:0] _axis_out_xoreddata_write_op_sel_fifo;
  wire [32-1:0] _axis_out_xoreddata_write_local_addr_fifo;
  wire [32-1:0] _axis_out_xoreddata_write_local_stride_fifo;
  wire [33-1:0] _axis_out_xoreddata_write_size_fifo;
  wire [8-1:0] unpack_write_req_op_sel_13;
  wire [32-1:0] unpack_write_req_local_addr_14;
  wire [32-1:0] unpack_write_req_local_stride_15;
  wire [33-1:0] unpack_write_req_local_size_16;
  assign unpack_write_req_op_sel_13 = _axis_out_xoreddata_write_req_fifo_rdata[104:97];
  assign unpack_write_req_local_addr_14 = _axis_out_xoreddata_write_req_fifo_rdata[96:65];
  assign unpack_write_req_local_stride_15 = _axis_out_xoreddata_write_req_fifo_rdata[64:33];
  assign unpack_write_req_local_size_16 = _axis_out_xoreddata_write_req_fifo_rdata[32:0];
  assign _axis_out_xoreddata_write_op_sel_fifo = unpack_write_req_op_sel_13;
  assign _axis_out_xoreddata_write_local_addr_fifo = unpack_write_req_local_addr_14;
  assign _axis_out_xoreddata_write_local_stride_fifo = unpack_write_req_local_stride_15;
  assign _axis_out_xoreddata_write_size_fifo = unpack_write_req_local_size_16;
  reg [8-1:0] _axis_out_xoreddata_write_op_sel_buf;
  reg [32-1:0] _axis_out_xoreddata_write_local_addr_buf;
  reg [32-1:0] _axis_out_xoreddata_write_local_stride_buf;
  reg [33-1:0] _axis_out_xoreddata_write_size_buf;
  reg _axis_out_xoreddata_write_data_busy;
  wire _axis_out_xoreddata_write_data_idle;
  wire _axis_out_xoreddata_write_idle;
  assign _axis_out_xoreddata_write_data_idle = _axis_out_xoreddata_write_req_fifo_empty && !_axis_out_xoreddata_write_data_busy;
  assign _axis_out_xoreddata_write_idle = _axis_out_xoreddata_write_data_idle;
  wire _axis_in_aes_read_req_fifo_enq;
  wire [105-1:0] _axis_in_aes_read_req_fifo_wdata;
  wire _axis_in_aes_read_req_fifo_full;
  wire _axis_in_aes_read_req_fifo_almost_full;
  wire _axis_in_aes_read_req_fifo_deq;
  wire [105-1:0] _axis_in_aes_read_req_fifo_rdata;
  wire _axis_in_aes_read_req_fifo_empty;
  wire _axis_in_aes_read_req_fifo_almost_empty;
  assign _axis_in_aes_read_req_fifo_enq = 0;
  assign _axis_in_aes_read_req_fifo_wdata = 'hx;
  assign _axis_in_aes_read_req_fifo_deq = 0;

  _axis_in_aes_read_req_fifo
  inst__axis_in_aes_read_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axis_in_aes_read_req_fifo_enq(_axis_in_aes_read_req_fifo_enq),
    ._axis_in_aes_read_req_fifo_wdata(_axis_in_aes_read_req_fifo_wdata),
    ._axis_in_aes_read_req_fifo_full(_axis_in_aes_read_req_fifo_full),
    ._axis_in_aes_read_req_fifo_almost_full(_axis_in_aes_read_req_fifo_almost_full),
    ._axis_in_aes_read_req_fifo_deq(_axis_in_aes_read_req_fifo_deq),
    ._axis_in_aes_read_req_fifo_rdata(_axis_in_aes_read_req_fifo_rdata),
    ._axis_in_aes_read_req_fifo_empty(_axis_in_aes_read_req_fifo_empty),
    ._axis_in_aes_read_req_fifo_almost_empty(_axis_in_aes_read_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axis_in_aes_read_req_fifo;
  wire [8-1:0] _axis_in_aes_read_op_sel_fifo;
  wire [32-1:0] _axis_in_aes_read_local_addr_fifo;
  wire [32-1:0] _axis_in_aes_read_local_stride_fifo;
  wire [33-1:0] _axis_in_aes_read_local_size_fifo;
  wire [8-1:0] unpack_read_req_op_sel_17;
  wire [32-1:0] unpack_read_req_local_addr_18;
  wire [32-1:0] unpack_read_req_local_stride_19;
  wire [33-1:0] unpack_read_req_local_size_20;
  assign unpack_read_req_op_sel_17 = _axis_in_aes_read_req_fifo_rdata[104:97];
  assign unpack_read_req_local_addr_18 = _axis_in_aes_read_req_fifo_rdata[96:65];
  assign unpack_read_req_local_stride_19 = _axis_in_aes_read_req_fifo_rdata[64:33];
  assign unpack_read_req_local_size_20 = _axis_in_aes_read_req_fifo_rdata[32:0];
  assign _axis_in_aes_read_op_sel_fifo = unpack_read_req_op_sel_17;
  assign _axis_in_aes_read_local_addr_fifo = unpack_read_req_local_addr_18;
  assign _axis_in_aes_read_local_stride_fifo = unpack_read_req_local_stride_19;
  assign _axis_in_aes_read_local_size_fifo = unpack_read_req_local_size_20;
  reg [8-1:0] _axis_in_aes_read_op_sel_buf;
  reg [32-1:0] _axis_in_aes_read_local_addr_buf;
  reg [32-1:0] _axis_in_aes_read_local_stride_buf;
  reg [33-1:0] _axis_in_aes_read_local_size_buf;
  reg _axis_in_aes_read_data_busy;
  wire _axis_in_aes_read_data_idle;
  wire _axis_in_aes_read_idle;
  assign _axis_in_aes_read_data_idle = _axis_in_aes_read_req_fifo_empty && !_axis_in_aes_read_data_busy;
  assign _axis_in_aes_read_idle = _axis_in_aes_read_data_idle;
  reg [128-1:0] data_21;
  reg [128-1:0] otp_22;
  reg [128-1:0] xored_23;
  wire [2-1:0] xor_ram_0_addr;
  wire [128-1:0] xor_ram_0_rdata;
  wire [128-1:0] xor_ram_0_wdata;
  wire xor_ram_0_wenable;
  wire xor_ram_0_enable;

  xor_ram
  inst_xor_ram
  (
    .CLK(CLK),
    .xor_ram_0_addr(xor_ram_0_addr),
    .xor_ram_0_rdata(xor_ram_0_rdata),
    .xor_ram_0_wdata(xor_ram_0_wdata),
    .xor_ram_0_wenable(xor_ram_0_wenable),
    .xor_ram_0_enable(xor_ram_0_enable)
  );

  reg [32-1:0] mac_buffer_thread;
  localparam mac_buffer_thread_init = 0;
  reg signed [32-1:0] _mac_buffer_thread_i_0;
  reg signed [128-1:0] axistreamin_tdata_24;
  reg axistreamin_tlast_25;
  assign axis_in_xordata_tready = mac_buffer_thread == 8;
  reg signed [32-1:0] _mac_buffer_thread_last_1;
  reg signed [128-1:0] axistreamin_tdata_26;
  reg axistreamin_tlast_27;
  assign axis_in_aes_tready = mac_buffer_thread == 11;
  assign xor_ram_0_wdata = (mac_buffer_thread == 14)? xored_23 : 'hx;
  assign xor_ram_0_wenable = (mac_buffer_thread == 14)? 1'd1 : 0;
  wire [8-1:0] pack_write_req_op_sel_28;
  wire [32-1:0] pack_write_req_local_addr_29;
  wire [32-1:0] pack_write_req_local_stride_30;
  wire [33-1:0] pack_write_req_local_size_31;
  assign pack_write_req_op_sel_28 = 1;
  assign pack_write_req_local_addr_29 = 0;
  assign pack_write_req_local_stride_30 = 1;
  assign pack_write_req_local_size_31 = 4;
  wire [105-1:0] pack_write_req_packed_32;
  assign pack_write_req_packed_32 = { pack_write_req_op_sel_28, pack_write_req_local_addr_29, pack_write_req_local_stride_30, pack_write_req_local_size_31 };
  assign _axis_out_xoreddata_write_req_fifo_wdata = ((mac_buffer_thread == 16) && !_axis_out_xoreddata_write_req_fifo_almost_full)? pack_write_req_packed_32 : 'hx;
  assign _axis_out_xoreddata_write_req_fifo_enq = ((mac_buffer_thread == 16) && !_axis_out_xoreddata_write_req_fifo_almost_full)? (mac_buffer_thread == 16) && !_axis_out_xoreddata_write_req_fifo_almost_full && !_axis_out_xoreddata_write_req_fifo_almost_full : 0;
  localparam _tmp_33 = 1;
  wire [_tmp_33-1:0] _tmp_34;
  assign _tmp_34 = !_axis_out_xoreddata_write_req_fifo_almost_full;
  reg [_tmp_33-1:0] __tmp_34_1;
  reg [32-1:0] _axis_out_xoreddata_write_data_fsm;
  localparam _axis_out_xoreddata_write_data_fsm_init = 0;
  assign _axis_out_xoreddata_write_req_fifo_deq = ((_axis_out_xoreddata_write_data_fsm == 0) && (!_axis_out_xoreddata_write_data_busy && !_axis_out_xoreddata_write_req_fifo_empty && (_axis_out_xoreddata_write_op_sel_fifo == 1)) && !_axis_out_xoreddata_write_req_fifo_empty)? 1 : 0;
  reg [32-1:0] read_burst_fsm_0;
  localparam read_burst_fsm_0_init = 0;
  reg [2-1:0] read_burst_addr_35;
  reg [2-1:0] read_burst_stride_36;
  reg [33-1:0] read_burst_length_37;
  reg read_burst_rvalid_38;
  reg read_burst_rlast_39;
  assign xor_ram_0_addr = ((read_burst_fsm_0 == 1) && (!read_burst_rvalid_38 || (axis_out_xoreddata_tready || !axis_out_xoreddata_tvalid)))? read_burst_addr_35 : 
                          (mac_buffer_thread == 14)? _mac_buffer_thread_i_0 : 'hx;
  assign xor_ram_0_enable = ((read_burst_fsm_0 == 1) && (!read_burst_rvalid_38 || (axis_out_xoreddata_tready || !axis_out_xoreddata_tvalid)))? 1'd1 : 
                            (mac_buffer_thread == 14)? 1'd1 : 0;
  localparam _tmp_40 = 1;
  wire [_tmp_40-1:0] _tmp_41;
  assign _tmp_41 = (read_burst_fsm_0 == 1) && (!read_burst_rvalid_38 || (axis_out_xoreddata_tready || !axis_out_xoreddata_tvalid));
  reg [_tmp_40-1:0] __tmp_41_1;
  wire [128-1:0] read_burst_rdata_42;
  assign read_burst_rdata_42 = xor_ram_0_rdata;
  reg _axis_out_xoreddata_cond_0_1;

  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_xored_rdata <= 0;
      axi_s_ctrl_xored_rvalid <= 0;
      _axi_s_ctrl_xored_rdata_cond_0_1 <= 0;
    end else begin
      if(_axi_s_ctrl_xored_rdata_cond_0_1) begin
        axi_s_ctrl_xored_rvalid <= 0;
      end 
      if((_axi_s_ctrl_xored_register_fsm == 1) && (axi_s_ctrl_xored_rready || !axi_s_ctrl_xored_rvalid)) begin
        axi_s_ctrl_xored_rdata <= axislite_rdata_6;
        axi_s_ctrl_xored_rvalid <= 1;
      end 
      _axi_s_ctrl_xored_rdata_cond_0_1 <= 1;
      if(axi_s_ctrl_xored_rvalid && !axi_s_ctrl_xored_rready) begin
        axi_s_ctrl_xored_rvalid <= axi_s_ctrl_xored_rvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_ctrl_xored_bvalid <= 0;
      prev_awvalid_3 <= 0;
      prev_arvalid_4 <= 0;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      addr_0 <= 0;
      _axi_s_ctrl_xored_register_0 <= 0;
      _axi_s_ctrl_xored_flag_0 <= 0;
      _axi_s_ctrl_xored_register_1 <= 0;
      _axi_s_ctrl_xored_flag_1 <= 0;
    end else begin
      if(axi_s_ctrl_xored_bvalid && axi_s_ctrl_xored_bready) begin
        axi_s_ctrl_xored_bvalid <= 0;
      end 
      if(axi_s_ctrl_xored_wvalid && axi_s_ctrl_xored_wready) begin
        axi_s_ctrl_xored_bvalid <= 1;
      end 
      prev_awvalid_3 <= axi_s_ctrl_xored_awvalid;
      prev_arvalid_4 <= axi_s_ctrl_xored_arvalid;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      if(axi_s_ctrl_xored_awready && axi_s_ctrl_xored_awvalid && !axi_s_ctrl_xored_bvalid) begin
        addr_0 <= axi_s_ctrl_xored_awaddr;
        writevalid_1 <= 1;
      end else if(axi_s_ctrl_xored_arready && axi_s_ctrl_xored_arvalid) begin
        addr_0 <= axi_s_ctrl_xored_araddr;
        readvalid_2 <= 1;
      end 
      if((_axi_s_ctrl_xored_register_fsm == 1) && (axi_s_ctrl_xored_rready || !axi_s_ctrl_xored_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 0)) begin
        _axi_s_ctrl_xored_register_0 <= axislite_resetval_8;
        _axi_s_ctrl_xored_flag_0 <= 0;
      end 
      if((_axi_s_ctrl_xored_register_fsm == 1) && (axi_s_ctrl_xored_rready || !axi_s_ctrl_xored_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 1)) begin
        _axi_s_ctrl_xored_register_1 <= axislite_resetval_8;
        _axi_s_ctrl_xored_flag_1 <= 0;
      end 
      if((_axi_s_ctrl_xored_register_fsm == 3) && axi_s_ctrl_xored_wvalid && (axis_maskaddr_5 == 0)) begin
        _axi_s_ctrl_xored_register_0 <= axi_s_ctrl_xored_wdata;
      end 
      if((_axi_s_ctrl_xored_register_fsm == 3) && axi_s_ctrl_xored_wvalid && (axis_maskaddr_5 == 1)) begin
        _axi_s_ctrl_xored_register_1 <= axi_s_ctrl_xored_wdata;
      end 
      if((mac_buffer_thread == 17) && 1) begin
        _axi_s_ctrl_xored_register_0 <= 0;
        _axi_s_ctrl_xored_flag_0 <= 0;
      end 
      if((mac_buffer_thread == 17) && 0) begin
        _axi_s_ctrl_xored_register_1 <= 0;
        _axi_s_ctrl_xored_flag_1 <= 0;
      end 
    end
  end

  localparam _axi_s_ctrl_xored_register_fsm_1 = 1;
  localparam _axi_s_ctrl_xored_register_fsm_2 = 2;
  localparam _axi_s_ctrl_xored_register_fsm_3 = 3;
  localparam _axi_s_ctrl_xored_register_fsm_4 = 4;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_s_ctrl_xored_register_fsm <= _axi_s_ctrl_xored_register_fsm_init;
      axis_maskaddr_5 <= 0;
    end else begin
      case(_axi_s_ctrl_xored_register_fsm)
        _axi_s_ctrl_xored_register_fsm_init: begin
          if(readvalid_2 || writevalid_1) begin
            axis_maskaddr_5 <= (addr_0 >> _axi_s_ctrl_xored_shift) & _axi_s_ctrl_xored_mask;
          end 
          if(readvalid_2) begin
            _axi_s_ctrl_xored_register_fsm <= _axi_s_ctrl_xored_register_fsm_1;
          end 
          if(writevalid_1) begin
            _axi_s_ctrl_xored_register_fsm <= _axi_s_ctrl_xored_register_fsm_3;
          end 
        end
        _axi_s_ctrl_xored_register_fsm_1: begin
          if(axi_s_ctrl_xored_rready || !axi_s_ctrl_xored_rvalid) begin
            _axi_s_ctrl_xored_register_fsm <= _axi_s_ctrl_xored_register_fsm_2;
          end 
        end
        _axi_s_ctrl_xored_register_fsm_2: begin
          if(axi_s_ctrl_xored_rready && axi_s_ctrl_xored_rvalid) begin
            _axi_s_ctrl_xored_register_fsm <= _axi_s_ctrl_xored_register_fsm_init;
          end 
        end
        _axi_s_ctrl_xored_register_fsm_3: begin
          if(axi_s_ctrl_xored_wvalid) begin
            _axi_s_ctrl_xored_register_fsm <= _axi_s_ctrl_xored_register_fsm_4;
          end 
        end
        _axi_s_ctrl_xored_register_fsm_4: begin
          if(axi_s_ctrl_xored_bready && axi_s_ctrl_xored_bvalid) begin
            _axi_s_ctrl_xored_register_fsm <= _axi_s_ctrl_xored_register_fsm_init;
          end 
        end
      endcase
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axis_in_xordata_read_data_busy <= 0;
    end else begin
      if((mac_buffer_thread == 7) && _axis_in_xordata_read_idle) begin
        _axis_in_xordata_read_data_busy <= 1;
      end 
      if((mac_buffer_thread == 8) && axis_in_xordata_tvalid) begin
        _axis_in_xordata_read_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_in_xordata_read_req_fifo <= 0;
    end else begin
      if(_axis_in_xordata_read_req_fifo_enq && !_axis_in_xordata_read_req_fifo_full && (_axis_in_xordata_read_req_fifo_deq && !_axis_in_xordata_read_req_fifo_empty)) begin
        count__axis_in_xordata_read_req_fifo <= count__axis_in_xordata_read_req_fifo;
      end else if(_axis_in_xordata_read_req_fifo_enq && !_axis_in_xordata_read_req_fifo_full) begin
        count__axis_in_xordata_read_req_fifo <= count__axis_in_xordata_read_req_fifo + 1;
      end else if(_axis_in_xordata_read_req_fifo_deq && !_axis_in_xordata_read_req_fifo_empty) begin
        count__axis_in_xordata_read_req_fifo <= count__axis_in_xordata_read_req_fifo - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axis_out_xoreddata_tdata <= 0;
      axis_out_xoreddata_tvalid <= 0;
      axis_out_xoreddata_tlast <= 0;
      _axis_out_xoreddata_cond_0_1 <= 0;
    end else begin
      if(_axis_out_xoreddata_cond_0_1) begin
        axis_out_xoreddata_tvalid <= 0;
        axis_out_xoreddata_tlast <= 0;
      end 
      if((_axis_out_xoreddata_write_op_sel_buf == 1) && read_burst_rvalid_38 && (axis_out_xoreddata_tready || !axis_out_xoreddata_tvalid) && (axis_out_xoreddata_tready || !axis_out_xoreddata_tvalid)) begin
        axis_out_xoreddata_tdata <= read_burst_rdata_42;
        axis_out_xoreddata_tvalid <= 1;
        axis_out_xoreddata_tlast <= read_burst_rlast_39;
      end 
      _axis_out_xoreddata_cond_0_1 <= 1;
      if(axis_out_xoreddata_tvalid && !axis_out_xoreddata_tready) begin
        axis_out_xoreddata_tvalid <= axis_out_xoreddata_tvalid;
        axis_out_xoreddata_tlast <= axis_out_xoreddata_tlast;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axis_out_xoreddata_write_data_busy <= 0;
      _axis_out_xoreddata_write_op_sel_buf <= 0;
      _axis_out_xoreddata_write_local_addr_buf <= 0;
      _axis_out_xoreddata_write_local_stride_buf <= 0;
      _axis_out_xoreddata_write_size_buf <= 0;
    end else begin
      if((_axis_out_xoreddata_write_data_fsm == 0) && (!_axis_out_xoreddata_write_data_busy && !_axis_out_xoreddata_write_req_fifo_empty && (_axis_out_xoreddata_write_op_sel_fifo == 1))) begin
        _axis_out_xoreddata_write_data_busy <= 1;
        _axis_out_xoreddata_write_op_sel_buf <= _axis_out_xoreddata_write_op_sel_fifo;
        _axis_out_xoreddata_write_local_addr_buf <= _axis_out_xoreddata_write_local_addr_fifo;
        _axis_out_xoreddata_write_local_stride_buf <= _axis_out_xoreddata_write_local_stride_fifo;
        _axis_out_xoreddata_write_size_buf <= _axis_out_xoreddata_write_size_fifo;
      end 
      if((_axis_out_xoreddata_write_data_fsm == 2) && ((_axis_out_xoreddata_write_op_sel_buf == 1) && read_burst_rvalid_38 && (axis_out_xoreddata_tready || !axis_out_xoreddata_tvalid))) begin
        _axis_out_xoreddata_write_size_buf <= _axis_out_xoreddata_write_size_buf - 1;
      end 
      if((_axis_out_xoreddata_write_data_fsm == 2) && ((_axis_out_xoreddata_write_op_sel_buf == 1) && read_burst_rvalid_38 && (axis_out_xoreddata_tready || !axis_out_xoreddata_tvalid)) && read_burst_rlast_39) begin
        _axis_out_xoreddata_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_out_xoreddata_write_req_fifo <= 0;
      __tmp_34_1 <= 0;
    end else begin
      if(_axis_out_xoreddata_write_req_fifo_enq && !_axis_out_xoreddata_write_req_fifo_full && (_axis_out_xoreddata_write_req_fifo_deq && !_axis_out_xoreddata_write_req_fifo_empty)) begin
        count__axis_out_xoreddata_write_req_fifo <= count__axis_out_xoreddata_write_req_fifo;
      end else if(_axis_out_xoreddata_write_req_fifo_enq && !_axis_out_xoreddata_write_req_fifo_full) begin
        count__axis_out_xoreddata_write_req_fifo <= count__axis_out_xoreddata_write_req_fifo + 1;
      end else if(_axis_out_xoreddata_write_req_fifo_deq && !_axis_out_xoreddata_write_req_fifo_empty) begin
        count__axis_out_xoreddata_write_req_fifo <= count__axis_out_xoreddata_write_req_fifo - 1;
      end 
      __tmp_34_1 <= _tmp_34;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axis_in_aes_read_data_busy <= 0;
    end else begin
      if((mac_buffer_thread == 10) && _axis_in_aes_read_idle) begin
        _axis_in_aes_read_data_busy <= 1;
      end 
      if((mac_buffer_thread == 11) && axis_in_aes_tvalid) begin
        _axis_in_aes_read_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_in_aes_read_req_fifo <= 0;
    end else begin
      if(_axis_in_aes_read_req_fifo_enq && !_axis_in_aes_read_req_fifo_full && (_axis_in_aes_read_req_fifo_deq && !_axis_in_aes_read_req_fifo_empty)) begin
        count__axis_in_aes_read_req_fifo <= count__axis_in_aes_read_req_fifo;
      end else if(_axis_in_aes_read_req_fifo_enq && !_axis_in_aes_read_req_fifo_full) begin
        count__axis_in_aes_read_req_fifo <= count__axis_in_aes_read_req_fifo + 1;
      end else if(_axis_in_aes_read_req_fifo_deq && !_axis_in_aes_read_req_fifo_empty) begin
        count__axis_in_aes_read_req_fifo <= count__axis_in_aes_read_req_fifo - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      __tmp_41_1 <= 0;
    end else begin
      __tmp_41_1 <= _tmp_41;
    end
  end

  localparam mac_buffer_thread_1 = 1;
  localparam mac_buffer_thread_2 = 2;
  localparam mac_buffer_thread_3 = 3;
  localparam mac_buffer_thread_4 = 4;
  localparam mac_buffer_thread_5 = 5;
  localparam mac_buffer_thread_6 = 6;
  localparam mac_buffer_thread_7 = 7;
  localparam mac_buffer_thread_8 = 8;
  localparam mac_buffer_thread_9 = 9;
  localparam mac_buffer_thread_10 = 10;
  localparam mac_buffer_thread_11 = 11;
  localparam mac_buffer_thread_12 = 12;
  localparam mac_buffer_thread_13 = 13;
  localparam mac_buffer_thread_14 = 14;
  localparam mac_buffer_thread_15 = 15;
  localparam mac_buffer_thread_16 = 16;
  localparam mac_buffer_thread_17 = 17;
  localparam mac_buffer_thread_18 = 18;
  localparam mac_buffer_thread_19 = 19;

  always @(posedge CLK) begin
    if(RST) begin
      mac_buffer_thread <= mac_buffer_thread_init;
      _mac_buffer_thread_i_0 <= 0;
      axistreamin_tdata_24 <= 0;
      axistreamin_tlast_25 <= 0;
      data_21 <= 0;
      _mac_buffer_thread_last_1 <= 0;
      axistreamin_tdata_26 <= 0;
      axistreamin_tlast_27 <= 0;
      otp_22 <= 0;
      xored_23 <= 0;
    end else begin
      case(mac_buffer_thread)
        mac_buffer_thread_init: begin
          mac_buffer_thread <= mac_buffer_thread_1;
        end
        mac_buffer_thread_1: begin
          if(1) begin
            mac_buffer_thread <= mac_buffer_thread_2;
          end else begin
            mac_buffer_thread <= mac_buffer_thread_19;
          end
        end
        mac_buffer_thread_2: begin
          if(_axi_s_ctrl_xored_register_0 == 0) begin
            mac_buffer_thread <= mac_buffer_thread_3;
          end else begin
            mac_buffer_thread <= mac_buffer_thread_5;
          end
        end
        mac_buffer_thread_3: begin
          mac_buffer_thread <= mac_buffer_thread_1;
        end
        mac_buffer_thread_4: begin
          mac_buffer_thread <= mac_buffer_thread_18;
        end
        mac_buffer_thread_5: begin
          _mac_buffer_thread_i_0 <= 0;
          mac_buffer_thread <= mac_buffer_thread_6;
        end
        mac_buffer_thread_6: begin
          if(_mac_buffer_thread_i_0 < 4) begin
            mac_buffer_thread <= mac_buffer_thread_7;
          end else begin
            mac_buffer_thread <= mac_buffer_thread_16;
          end
        end
        mac_buffer_thread_7: begin
          if(_axis_in_xordata_read_idle) begin
            mac_buffer_thread <= mac_buffer_thread_8;
          end 
        end
        mac_buffer_thread_8: begin
          if(axis_in_xordata_tvalid) begin
            axistreamin_tdata_24 <= axis_in_xordata_tdata;
          end 
          if(axis_in_xordata_tvalid) begin
            axistreamin_tlast_25 <= axis_in_xordata_tlast;
          end 
          if(axis_in_xordata_tvalid) begin
            mac_buffer_thread <= mac_buffer_thread_9;
          end 
        end
        mac_buffer_thread_9: begin
          data_21 <= axistreamin_tdata_24;
          _mac_buffer_thread_last_1 <= axistreamin_tlast_25;
          mac_buffer_thread <= mac_buffer_thread_10;
        end
        mac_buffer_thread_10: begin
          if(_axis_in_aes_read_idle) begin
            mac_buffer_thread <= mac_buffer_thread_11;
          end 
        end
        mac_buffer_thread_11: begin
          if(axis_in_aes_tvalid) begin
            axistreamin_tdata_26 <= axis_in_aes_tdata;
          end 
          if(axis_in_aes_tvalid) begin
            axistreamin_tlast_27 <= axis_in_aes_tlast;
          end 
          if(axis_in_aes_tvalid) begin
            mac_buffer_thread <= mac_buffer_thread_12;
          end 
        end
        mac_buffer_thread_12: begin
          otp_22 <= axistreamin_tdata_26;
          _mac_buffer_thread_last_1 <= axistreamin_tlast_27;
          mac_buffer_thread <= mac_buffer_thread_13;
        end
        mac_buffer_thread_13: begin
          xored_23 <= data_21 ^ otp_22;
          mac_buffer_thread <= mac_buffer_thread_14;
        end
        mac_buffer_thread_14: begin
          mac_buffer_thread <= mac_buffer_thread_15;
        end
        mac_buffer_thread_15: begin
          _mac_buffer_thread_i_0 <= _mac_buffer_thread_i_0 + 1;
          mac_buffer_thread <= mac_buffer_thread_6;
        end
        mac_buffer_thread_16: begin
          if(!_axis_out_xoreddata_write_req_fifo_almost_full) begin
            mac_buffer_thread <= mac_buffer_thread_17;
          end 
        end
        mac_buffer_thread_17: begin
          mac_buffer_thread <= mac_buffer_thread_18;
        end
        mac_buffer_thread_18: begin
          mac_buffer_thread <= mac_buffer_thread_1;
        end
      endcase
    end
  end

  localparam _axis_out_xoreddata_write_data_fsm_1 = 1;
  localparam _axis_out_xoreddata_write_data_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axis_out_xoreddata_write_data_fsm <= _axis_out_xoreddata_write_data_fsm_init;
    end else begin
      case(_axis_out_xoreddata_write_data_fsm)
        _axis_out_xoreddata_write_data_fsm_init: begin
          if(!_axis_out_xoreddata_write_data_busy && !_axis_out_xoreddata_write_req_fifo_empty && (_axis_out_xoreddata_write_op_sel_fifo == 1)) begin
            _axis_out_xoreddata_write_data_fsm <= _axis_out_xoreddata_write_data_fsm_1;
          end 
        end
        _axis_out_xoreddata_write_data_fsm_1: begin
          _axis_out_xoreddata_write_data_fsm <= _axis_out_xoreddata_write_data_fsm_2;
        end
        _axis_out_xoreddata_write_data_fsm_2: begin
          if((_axis_out_xoreddata_write_op_sel_buf == 1) && read_burst_rvalid_38 && (axis_out_xoreddata_tready || !axis_out_xoreddata_tvalid) && read_burst_rlast_39) begin
            _axis_out_xoreddata_write_data_fsm <= _axis_out_xoreddata_write_data_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam read_burst_fsm_0_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      read_burst_fsm_0 <= read_burst_fsm_0_init;
      read_burst_addr_35 <= 0;
      read_burst_stride_36 <= 0;
      read_burst_length_37 <= 0;
      read_burst_rvalid_38 <= 0;
      read_burst_rlast_39 <= 0;
    end else begin
      case(read_burst_fsm_0)
        read_burst_fsm_0_init: begin
          read_burst_addr_35 <= _axis_out_xoreddata_write_local_addr_buf;
          read_burst_stride_36 <= _axis_out_xoreddata_write_local_stride_buf;
          read_burst_length_37 <= _axis_out_xoreddata_write_size_buf;
          read_burst_rvalid_38 <= 0;
          read_burst_rlast_39 <= 0;
          if((_axis_out_xoreddata_write_data_fsm == 1) && (_axis_out_xoreddata_write_op_sel_buf == 1) && (_axis_out_xoreddata_write_size_buf > 0)) begin
            read_burst_fsm_0 <= read_burst_fsm_0_1;
          end 
        end
        read_burst_fsm_0_1: begin
          if((axis_out_xoreddata_tready || !axis_out_xoreddata_tvalid) && (read_burst_length_37 > 0)) begin
            read_burst_addr_35 <= read_burst_addr_35 + read_burst_stride_36;
            read_burst_length_37 <= read_burst_length_37 - 1;
            read_burst_rvalid_38 <= 1;
          end 
          if((axis_out_xoreddata_tready || !axis_out_xoreddata_tvalid) && (read_burst_length_37 <= 1)) begin
            read_burst_rlast_39 <= 1;
          end 
          if(read_burst_rlast_39 && read_burst_rvalid_38 && (axis_out_xoreddata_tready || !axis_out_xoreddata_tvalid)) begin
            read_burst_rvalid_38 <= 0;
            read_burst_rlast_39 <= 0;
          end 
          if(0) begin
            read_burst_rvalid_38 <= 0;
            read_burst_rlast_39 <= 0;
          end 
          if(read_burst_rlast_39 && read_burst_rvalid_38 && (axis_out_xoreddata_tready || !axis_out_xoreddata_tvalid)) begin
            read_burst_fsm_0 <= read_burst_fsm_0_init;
          end 
          if(0) begin
            read_burst_fsm_0 <= read_burst_fsm_0_init;
          end 
        end
      endcase
    end
  end


endmodule



module _axis_in_xordata_read_req_fifo
(
  input CLK,
  input RST,
  input _axis_in_xordata_read_req_fifo_enq,
  input [105-1:0] _axis_in_xordata_read_req_fifo_wdata,
  output _axis_in_xordata_read_req_fifo_full,
  output _axis_in_xordata_read_req_fifo_almost_full,
  input _axis_in_xordata_read_req_fifo_deq,
  output [105-1:0] _axis_in_xordata_read_req_fifo_rdata,
  output _axis_in_xordata_read_req_fifo_empty,
  output _axis_in_xordata_read_req_fifo_almost_empty
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
  assign _axis_in_xordata_read_req_fifo_full = is_full;
  assign _axis_in_xordata_read_req_fifo_almost_full = is_almost_full || is_full;
  assign _axis_in_xordata_read_req_fifo_empty = is_empty;
  assign _axis_in_xordata_read_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axis_in_xordata_read_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axis_in_xordata_read_req_fifo_enq && !is_full) begin
        mem[head] <= _axis_in_xordata_read_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axis_in_xordata_read_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _axis_out_xoreddata_write_req_fifo
(
  input CLK,
  input RST,
  input _axis_out_xoreddata_write_req_fifo_enq,
  input [105-1:0] _axis_out_xoreddata_write_req_fifo_wdata,
  output _axis_out_xoreddata_write_req_fifo_full,
  output _axis_out_xoreddata_write_req_fifo_almost_full,
  input _axis_out_xoreddata_write_req_fifo_deq,
  output [105-1:0] _axis_out_xoreddata_write_req_fifo_rdata,
  output _axis_out_xoreddata_write_req_fifo_empty,
  output _axis_out_xoreddata_write_req_fifo_almost_empty
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
  assign _axis_out_xoreddata_write_req_fifo_full = is_full;
  assign _axis_out_xoreddata_write_req_fifo_almost_full = is_almost_full || is_full;
  assign _axis_out_xoreddata_write_req_fifo_empty = is_empty;
  assign _axis_out_xoreddata_write_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axis_out_xoreddata_write_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axis_out_xoreddata_write_req_fifo_enq && !is_full) begin
        mem[head] <= _axis_out_xoreddata_write_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axis_out_xoreddata_write_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _axis_in_aes_read_req_fifo
(
  input CLK,
  input RST,
  input _axis_in_aes_read_req_fifo_enq,
  input [105-1:0] _axis_in_aes_read_req_fifo_wdata,
  output _axis_in_aes_read_req_fifo_full,
  output _axis_in_aes_read_req_fifo_almost_full,
  input _axis_in_aes_read_req_fifo_deq,
  output [105-1:0] _axis_in_aes_read_req_fifo_rdata,
  output _axis_in_aes_read_req_fifo_empty,
  output _axis_in_aes_read_req_fifo_almost_empty
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
  assign _axis_in_aes_read_req_fifo_full = is_full;
  assign _axis_in_aes_read_req_fifo_almost_full = is_almost_full || is_full;
  assign _axis_in_aes_read_req_fifo_empty = is_empty;
  assign _axis_in_aes_read_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axis_in_aes_read_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axis_in_aes_read_req_fifo_enq && !is_full) begin
        mem[head] <= _axis_in_aes_read_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axis_in_aes_read_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule

