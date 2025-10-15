

module test_axim
(

);

  reg CLK;
  reg RST;
  reg [32-1:0] axi_s_ctrl_axim_awaddr;
  reg [4-1:0] axi_s_ctrl_axim_awcache;
  reg [3-1:0] axi_s_ctrl_axim_awprot;
  reg axi_s_ctrl_axim_awvalid;
  wire axi_s_ctrl_axim_awready;
  reg [64-1:0] axi_s_ctrl_axim_wdata;
  reg [8-1:0] axi_s_ctrl_axim_wstrb;
  reg axi_s_ctrl_axim_wvalid;
  wire axi_s_ctrl_axim_wready;
  wire [2-1:0] axi_s_ctrl_axim_bresp;
  wire axi_s_ctrl_axim_bvalid;
  reg axi_s_ctrl_axim_bready;
  reg [32-1:0] axi_s_ctrl_axim_araddr;
  reg [4-1:0] axi_s_ctrl_axim_arcache;
  reg [3-1:0] axi_s_ctrl_axim_arprot;
  reg axi_s_ctrl_axim_arvalid;
  wire axi_s_ctrl_axim_arready;
  wire [64-1:0] axi_s_ctrl_axim_rdata;
  wire [2-1:0] axi_s_ctrl_axim_rresp;
  wire axi_s_ctrl_axim_rvalid;
  reg axi_s_ctrl_axim_rready;
  reg [128-1:0] axis_in_axim_tdata;
  reg axis_in_axim_tvalid;
  wire axis_in_axim_tready;
  reg axis_in_axim_tlast;
  wire [128-1:0] axis_out_axim_tdata;
  wire axis_out_axim_tvalid;
  reg axis_out_axim_tready;
  wire axis_out_axim_tlast;
  reg [32-1:0] axi_s_llc_awaddr;
  reg [8-1:0] axi_s_llc_awlen;
  reg [3-1:0] axi_s_llc_awsize;
  reg [2-1:0] axi_s_llc_awburst;
  reg [1-1:0] axi_s_llc_awlock;
  reg [4-1:0] axi_s_llc_awcache;
  reg [3-1:0] axi_s_llc_awprot;
  reg [4-1:0] axi_s_llc_awqos;
  reg [2-1:0] axi_s_llc_awuser;
  reg axi_s_llc_awvalid;
  wire axi_s_llc_awready;
  reg [128-1:0] axi_s_llc_wdata;
  reg [16-1:0] axi_s_llc_wstrb;
  reg axi_s_llc_wlast;
  reg axi_s_llc_wvalid;
  wire axi_s_llc_wready;
  wire [2-1:0] axi_s_llc_bresp;
  wire axi_s_llc_bvalid;
  reg axi_s_llc_bready;
  reg [32-1:0] axi_s_llc_araddr;
  reg [8-1:0] axi_s_llc_arlen;
  reg [3-1:0] axi_s_llc_arsize;
  reg [2-1:0] axi_s_llc_arburst;
  reg [1-1:0] axi_s_llc_arlock;
  reg [4-1:0] axi_s_llc_arcache;
  reg [3-1:0] axi_s_llc_arprot;
  reg [4-1:0] axi_s_llc_arqos;
  reg [2-1:0] axi_s_llc_aruser;
  reg axi_s_llc_arvalid;
  wire axi_s_llc_arready;
  wire [128-1:0] axi_s_llc_rdata;
  wire [2-1:0] axi_s_llc_rresp;
  wire axi_s_llc_rlast;
  wire axi_s_llc_rvalid;
  reg axi_s_llc_rready;
  reg [32-1:0] maxi_axim_awaddr;
  wire [4-1:0] maxi_axim_awcache;
  wire [3-1:0] maxi_axim_awprot;
  reg maxi_axim_awvalid;
  wire maxi_axim_awready;
  assign maxi_axim_awcache = 3;
  assign maxi_axim_awprot = 0;
  wire [64-1:0] maxi_axim_wdata;
  wire [8-1:0] maxi_axim_wstrb;
  wire maxi_axim_wvalid;
  wire maxi_axim_wready;
  reg [64-1:0] _maxi_axim_wdata_sb_0;
  reg [8-1:0] _maxi_axim_wstrb_sb_0;
  reg _maxi_axim_wvalid_sb_0;
  wire _maxi_axim_wready_sb_0;
  wire [8-1:0] _sb_maxi_axim_writedata_s_value_0;
  assign _sb_maxi_axim_writedata_s_value_0 = _maxi_axim_wstrb_sb_0;
  wire [64-1:0] _sb_maxi_axim_writedata_s_value_1;
  assign _sb_maxi_axim_writedata_s_value_1 = _maxi_axim_wdata_sb_0;
  wire [72-1:0] _sb_maxi_axim_writedata_s_data_2;
  assign _sb_maxi_axim_writedata_s_data_2 = { _sb_maxi_axim_writedata_s_value_0, _sb_maxi_axim_writedata_s_value_1 };
  wire _sb_maxi_axim_writedata_s_valid_3;
  assign _sb_maxi_axim_writedata_s_valid_3 = _maxi_axim_wvalid_sb_0;
  wire _sb_maxi_axim_writedata_m_ready_4;
  assign _sb_maxi_axim_writedata_m_ready_4 = maxi_axim_wready;
  reg [72-1:0] _sb_maxi_axim_writedata_data_5;
  reg _sb_maxi_axim_writedata_valid_6;
  wire _sb_maxi_axim_writedata_ready_7;
  reg [72-1:0] _sb_maxi_axim_writedata_tmp_data_8;
  reg _sb_maxi_axim_writedata_tmp_valid_9;
  wire [72-1:0] _sb_maxi_axim_writedata_next_data_10;
  wire _sb_maxi_axim_writedata_next_valid_11;
  assign _sb_maxi_axim_writedata_ready_7 = !_sb_maxi_axim_writedata_tmp_valid_9;
  assign _sb_maxi_axim_writedata_next_data_10 = (_sb_maxi_axim_writedata_tmp_valid_9)? _sb_maxi_axim_writedata_tmp_data_8 : _sb_maxi_axim_writedata_s_data_2;
  assign _sb_maxi_axim_writedata_next_valid_11 = _sb_maxi_axim_writedata_tmp_valid_9 || _sb_maxi_axim_writedata_s_valid_3;
  wire [8-1:0] _sb_maxi_axim_writedata_m_value_12;
  assign _sb_maxi_axim_writedata_m_value_12 = _sb_maxi_axim_writedata_data_5[71:64];
  wire [64-1:0] _sb_maxi_axim_writedata_m_value_13;
  assign _sb_maxi_axim_writedata_m_value_13 = _sb_maxi_axim_writedata_data_5[63:0];
  assign _maxi_axim_wready_sb_0 = _sb_maxi_axim_writedata_ready_7;
  assign maxi_axim_wdata = _sb_maxi_axim_writedata_m_value_13;
  assign maxi_axim_wstrb = _sb_maxi_axim_writedata_m_value_12;
  assign maxi_axim_wvalid = _sb_maxi_axim_writedata_valid_6;
  wire [2-1:0] maxi_axim_bresp;
  wire maxi_axim_bvalid;
  wire maxi_axim_bready;
  assign maxi_axim_bready = 1;
  reg [32-1:0] maxi_axim_araddr;
  wire [4-1:0] maxi_axim_arcache;
  wire [3-1:0] maxi_axim_arprot;
  reg maxi_axim_arvalid;
  wire maxi_axim_arready;
  assign maxi_axim_arcache = 3;
  assign maxi_axim_arprot = 0;
  wire [64-1:0] maxi_axim_rdata;
  wire [2-1:0] maxi_axim_rresp;
  wire maxi_axim_rvalid;
  wire maxi_axim_rready;
  wire [64-1:0] _maxi_axim_rdata_sb_0;
  wire _maxi_axim_rvalid_sb_0;
  wire _maxi_axim_rready_sb_0;
  wire [64-1:0] _sb_maxi_axim_readdata_s_value_14;
  assign _sb_maxi_axim_readdata_s_value_14 = maxi_axim_rdata;
  wire [64-1:0] _sb_maxi_axim_readdata_s_data_15;
  assign _sb_maxi_axim_readdata_s_data_15 = { _sb_maxi_axim_readdata_s_value_14 };
  wire _sb_maxi_axim_readdata_s_valid_16;
  assign _sb_maxi_axim_readdata_s_valid_16 = maxi_axim_rvalid;
  wire _sb_maxi_axim_readdata_m_ready_17;
  assign _sb_maxi_axim_readdata_m_ready_17 = _maxi_axim_rready_sb_0;
  reg [64-1:0] _sb_maxi_axim_readdata_data_18;
  reg _sb_maxi_axim_readdata_valid_19;
  wire _sb_maxi_axim_readdata_ready_20;
  reg [64-1:0] _sb_maxi_axim_readdata_tmp_data_21;
  reg _sb_maxi_axim_readdata_tmp_valid_22;
  wire [64-1:0] _sb_maxi_axim_readdata_next_data_23;
  wire _sb_maxi_axim_readdata_next_valid_24;
  assign _sb_maxi_axim_readdata_ready_20 = !_sb_maxi_axim_readdata_tmp_valid_22;
  assign _sb_maxi_axim_readdata_next_data_23 = (_sb_maxi_axim_readdata_tmp_valid_22)? _sb_maxi_axim_readdata_tmp_data_21 : _sb_maxi_axim_readdata_s_data_15;
  assign _sb_maxi_axim_readdata_next_valid_24 = _sb_maxi_axim_readdata_tmp_valid_22 || _sb_maxi_axim_readdata_s_valid_16;
  wire [64-1:0] _sb_maxi_axim_readdata_m_value_25;
  assign _sb_maxi_axim_readdata_m_value_25 = _sb_maxi_axim_readdata_data_18[63:0];
  assign _maxi_axim_rdata_sb_0 = _sb_maxi_axim_readdata_m_value_25;
  assign _maxi_axim_rvalid_sb_0 = _sb_maxi_axim_readdata_valid_19;
  assign maxi_axim_rready = _sb_maxi_axim_readdata_ready_20;
  reg [3-1:0] _maxi_axim_outstanding_wcount;
  wire _maxi_axim_has_outstanding_write;
  assign _maxi_axim_has_outstanding_write = (_maxi_axim_outstanding_wcount > 0) || maxi_axim_awvalid;
  reg [32-1:0] llc_maxi_axim_awaddr;
  reg [8-1:0] llc_maxi_axim_awlen;
  wire [3-1:0] llc_maxi_axim_awsize;
  wire [2-1:0] llc_maxi_axim_awburst;
  wire [1-1:0] llc_maxi_axim_awlock;
  wire [4-1:0] llc_maxi_axim_awcache;
  wire [3-1:0] llc_maxi_axim_awprot;
  wire [4-1:0] llc_maxi_axim_awqos;
  wire [2-1:0] llc_maxi_axim_awuser;
  reg llc_maxi_axim_awvalid;
  wire llc_maxi_axim_awready;
  assign llc_maxi_axim_awsize = 4;
  assign llc_maxi_axim_awburst = 1;
  assign llc_maxi_axim_awlock = 0;
  assign llc_maxi_axim_awcache = 3;
  assign llc_maxi_axim_awprot = 0;
  assign llc_maxi_axim_awqos = 0;
  assign llc_maxi_axim_awuser = 0;
  wire [128-1:0] llc_maxi_axim_wdata;
  wire [16-1:0] llc_maxi_axim_wstrb;
  wire llc_maxi_axim_wlast;
  wire llc_maxi_axim_wvalid;
  wire llc_maxi_axim_wready;
  reg [128-1:0] _llc_maxi_axim_wdata_sb_0;
  reg [16-1:0] _llc_maxi_axim_wstrb_sb_0;
  reg _llc_maxi_axim_wlast_sb_0;
  reg _llc_maxi_axim_wvalid_sb_0;
  wire _llc_maxi_axim_wready_sb_0;
  wire _sb_llc_maxi_axim_writedata_s_value_26;
  assign _sb_llc_maxi_axim_writedata_s_value_26 = _llc_maxi_axim_wlast_sb_0;
  wire [16-1:0] _sb_llc_maxi_axim_writedata_s_value_27;
  assign _sb_llc_maxi_axim_writedata_s_value_27 = _llc_maxi_axim_wstrb_sb_0;
  wire [128-1:0] _sb_llc_maxi_axim_writedata_s_value_28;
  assign _sb_llc_maxi_axim_writedata_s_value_28 = _llc_maxi_axim_wdata_sb_0;
  wire [145-1:0] _sb_llc_maxi_axim_writedata_s_data_29;
  assign _sb_llc_maxi_axim_writedata_s_data_29 = { _sb_llc_maxi_axim_writedata_s_value_26, _sb_llc_maxi_axim_writedata_s_value_27, _sb_llc_maxi_axim_writedata_s_value_28 };
  wire _sb_llc_maxi_axim_writedata_s_valid_30;
  assign _sb_llc_maxi_axim_writedata_s_valid_30 = _llc_maxi_axim_wvalid_sb_0;
  wire _sb_llc_maxi_axim_writedata_m_ready_31;
  assign _sb_llc_maxi_axim_writedata_m_ready_31 = llc_maxi_axim_wready;
  reg [145-1:0] _sb_llc_maxi_axim_writedata_data_32;
  reg _sb_llc_maxi_axim_writedata_valid_33;
  wire _sb_llc_maxi_axim_writedata_ready_34;
  reg [145-1:0] _sb_llc_maxi_axim_writedata_tmp_data_35;
  reg _sb_llc_maxi_axim_writedata_tmp_valid_36;
  wire [145-1:0] _sb_llc_maxi_axim_writedata_next_data_37;
  wire _sb_llc_maxi_axim_writedata_next_valid_38;
  assign _sb_llc_maxi_axim_writedata_ready_34 = !_sb_llc_maxi_axim_writedata_tmp_valid_36;
  assign _sb_llc_maxi_axim_writedata_next_data_37 = (_sb_llc_maxi_axim_writedata_tmp_valid_36)? _sb_llc_maxi_axim_writedata_tmp_data_35 : _sb_llc_maxi_axim_writedata_s_data_29;
  assign _sb_llc_maxi_axim_writedata_next_valid_38 = _sb_llc_maxi_axim_writedata_tmp_valid_36 || _sb_llc_maxi_axim_writedata_s_valid_30;
  wire _sb_llc_maxi_axim_writedata_m_value_39;
  assign _sb_llc_maxi_axim_writedata_m_value_39 = _sb_llc_maxi_axim_writedata_data_32[144:144];
  wire [16-1:0] _sb_llc_maxi_axim_writedata_m_value_40;
  assign _sb_llc_maxi_axim_writedata_m_value_40 = _sb_llc_maxi_axim_writedata_data_32[143:128];
  wire [128-1:0] _sb_llc_maxi_axim_writedata_m_value_41;
  assign _sb_llc_maxi_axim_writedata_m_value_41 = _sb_llc_maxi_axim_writedata_data_32[127:0];
  assign _llc_maxi_axim_wready_sb_0 = _sb_llc_maxi_axim_writedata_ready_34;
  assign llc_maxi_axim_wdata = _sb_llc_maxi_axim_writedata_m_value_41;
  assign llc_maxi_axim_wstrb = _sb_llc_maxi_axim_writedata_m_value_40;
  assign llc_maxi_axim_wlast = _sb_llc_maxi_axim_writedata_m_value_39;
  assign llc_maxi_axim_wvalid = _sb_llc_maxi_axim_writedata_valid_33;
  wire [2-1:0] llc_maxi_axim_bresp;
  wire llc_maxi_axim_bvalid;
  wire llc_maxi_axim_bready;
  assign llc_maxi_axim_bready = 1;
  reg [32-1:0] llc_maxi_axim_araddr;
  reg [8-1:0] llc_maxi_axim_arlen;
  wire [3-1:0] llc_maxi_axim_arsize;
  wire [2-1:0] llc_maxi_axim_arburst;
  wire [1-1:0] llc_maxi_axim_arlock;
  wire [4-1:0] llc_maxi_axim_arcache;
  wire [3-1:0] llc_maxi_axim_arprot;
  wire [4-1:0] llc_maxi_axim_arqos;
  wire [2-1:0] llc_maxi_axim_aruser;
  reg llc_maxi_axim_arvalid;
  wire llc_maxi_axim_arready;
  assign llc_maxi_axim_arsize = 4;
  assign llc_maxi_axim_arburst = 1;
  assign llc_maxi_axim_arlock = 0;
  assign llc_maxi_axim_arcache = 3;
  assign llc_maxi_axim_arprot = 0;
  assign llc_maxi_axim_arqos = 0;
  assign llc_maxi_axim_aruser = 0;
  wire [128-1:0] llc_maxi_axim_rdata;
  wire [2-1:0] llc_maxi_axim_rresp;
  wire llc_maxi_axim_rlast;
  wire llc_maxi_axim_rvalid;
  wire llc_maxi_axim_rready;
  wire [128-1:0] _llc_maxi_axim_rdata_sb_0;
  wire _llc_maxi_axim_rlast_sb_0;
  wire _llc_maxi_axim_rvalid_sb_0;
  wire _llc_maxi_axim_rready_sb_0;
  wire _sb_llc_maxi_axim_readdata_s_value_42;
  assign _sb_llc_maxi_axim_readdata_s_value_42 = llc_maxi_axim_rlast;
  wire [128-1:0] _sb_llc_maxi_axim_readdata_s_value_43;
  assign _sb_llc_maxi_axim_readdata_s_value_43 = llc_maxi_axim_rdata;
  wire [129-1:0] _sb_llc_maxi_axim_readdata_s_data_44;
  assign _sb_llc_maxi_axim_readdata_s_data_44 = { _sb_llc_maxi_axim_readdata_s_value_42, _sb_llc_maxi_axim_readdata_s_value_43 };
  wire _sb_llc_maxi_axim_readdata_s_valid_45;
  assign _sb_llc_maxi_axim_readdata_s_valid_45 = llc_maxi_axim_rvalid;
  wire _sb_llc_maxi_axim_readdata_m_ready_46;
  assign _sb_llc_maxi_axim_readdata_m_ready_46 = _llc_maxi_axim_rready_sb_0;
  reg [129-1:0] _sb_llc_maxi_axim_readdata_data_47;
  reg _sb_llc_maxi_axim_readdata_valid_48;
  wire _sb_llc_maxi_axim_readdata_ready_49;
  reg [129-1:0] _sb_llc_maxi_axim_readdata_tmp_data_50;
  reg _sb_llc_maxi_axim_readdata_tmp_valid_51;
  wire [129-1:0] _sb_llc_maxi_axim_readdata_next_data_52;
  wire _sb_llc_maxi_axim_readdata_next_valid_53;
  assign _sb_llc_maxi_axim_readdata_ready_49 = !_sb_llc_maxi_axim_readdata_tmp_valid_51;
  assign _sb_llc_maxi_axim_readdata_next_data_52 = (_sb_llc_maxi_axim_readdata_tmp_valid_51)? _sb_llc_maxi_axim_readdata_tmp_data_50 : _sb_llc_maxi_axim_readdata_s_data_44;
  assign _sb_llc_maxi_axim_readdata_next_valid_53 = _sb_llc_maxi_axim_readdata_tmp_valid_51 || _sb_llc_maxi_axim_readdata_s_valid_45;
  wire _sb_llc_maxi_axim_readdata_m_value_54;
  assign _sb_llc_maxi_axim_readdata_m_value_54 = _sb_llc_maxi_axim_readdata_data_47[128:128];
  wire [128-1:0] _sb_llc_maxi_axim_readdata_m_value_55;
  assign _sb_llc_maxi_axim_readdata_m_value_55 = _sb_llc_maxi_axim_readdata_data_47[127:0];
  assign _llc_maxi_axim_rdata_sb_0 = _sb_llc_maxi_axim_readdata_m_value_55;
  assign _llc_maxi_axim_rlast_sb_0 = _sb_llc_maxi_axim_readdata_m_value_54;
  assign _llc_maxi_axim_rvalid_sb_0 = _sb_llc_maxi_axim_readdata_valid_48;
  assign llc_maxi_axim_rready = _sb_llc_maxi_axim_readdata_ready_49;
  reg [3-1:0] _llc_maxi_axim_outstanding_wcount;
  wire _llc_maxi_axim_has_outstanding_write;
  assign _llc_maxi_axim_has_outstanding_write = (_llc_maxi_axim_outstanding_wcount > 0) || llc_maxi_axim_awvalid;
  wire [128-1:0] s_axis_axim_tdata;
  wire s_axis_axim_tvalid;
  wire s_axis_axim_tready;
  wire s_axis_axim_tlast;
  wire _s_axis_axim_read_req_fifo_enq;
  wire [105-1:0] _s_axis_axim_read_req_fifo_wdata;
  wire _s_axis_axim_read_req_fifo_full;
  wire _s_axis_axim_read_req_fifo_almost_full;
  wire _s_axis_axim_read_req_fifo_deq;
  wire [105-1:0] _s_axis_axim_read_req_fifo_rdata;
  wire _s_axis_axim_read_req_fifo_empty;
  wire _s_axis_axim_read_req_fifo_almost_empty;
  assign _s_axis_axim_read_req_fifo_enq = 0;
  assign _s_axis_axim_read_req_fifo_wdata = 'hx;
  assign _s_axis_axim_read_req_fifo_deq = 0;

  _s_axis_axim_read_req_fifo
  inst__s_axis_axim_read_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._s_axis_axim_read_req_fifo_enq(_s_axis_axim_read_req_fifo_enq),
    ._s_axis_axim_read_req_fifo_wdata(_s_axis_axim_read_req_fifo_wdata),
    ._s_axis_axim_read_req_fifo_full(_s_axis_axim_read_req_fifo_full),
    ._s_axis_axim_read_req_fifo_almost_full(_s_axis_axim_read_req_fifo_almost_full),
    ._s_axis_axim_read_req_fifo_deq(_s_axis_axim_read_req_fifo_deq),
    ._s_axis_axim_read_req_fifo_rdata(_s_axis_axim_read_req_fifo_rdata),
    ._s_axis_axim_read_req_fifo_empty(_s_axis_axim_read_req_fifo_empty),
    ._s_axis_axim_read_req_fifo_almost_empty(_s_axis_axim_read_req_fifo_almost_empty)
  );

  reg [4-1:0] count__s_axis_axim_read_req_fifo;
  wire [8-1:0] _s_axis_axim_read_op_sel_fifo;
  wire [32-1:0] _s_axis_axim_read_local_addr_fifo;
  wire [32-1:0] _s_axis_axim_read_local_stride_fifo;
  wire [33-1:0] _s_axis_axim_read_local_size_fifo;
  wire [8-1:0] unpack_read_req_op_sel_56;
  wire [32-1:0] unpack_read_req_local_addr_57;
  wire [32-1:0] unpack_read_req_local_stride_58;
  wire [33-1:0] unpack_read_req_local_size_59;
  assign unpack_read_req_op_sel_56 = _s_axis_axim_read_req_fifo_rdata[104:97];
  assign unpack_read_req_local_addr_57 = _s_axis_axim_read_req_fifo_rdata[96:65];
  assign unpack_read_req_local_stride_58 = _s_axis_axim_read_req_fifo_rdata[64:33];
  assign unpack_read_req_local_size_59 = _s_axis_axim_read_req_fifo_rdata[32:0];
  assign _s_axis_axim_read_op_sel_fifo = unpack_read_req_op_sel_56;
  assign _s_axis_axim_read_local_addr_fifo = unpack_read_req_local_addr_57;
  assign _s_axis_axim_read_local_stride_fifo = unpack_read_req_local_stride_58;
  assign _s_axis_axim_read_local_size_fifo = unpack_read_req_local_size_59;
  reg [8-1:0] _s_axis_axim_read_op_sel_buf;
  reg [32-1:0] _s_axis_axim_read_local_addr_buf;
  reg [32-1:0] _s_axis_axim_read_local_stride_buf;
  reg [33-1:0] _s_axis_axim_read_local_size_buf;
  reg _s_axis_axim_read_data_busy;
  wire _s_axis_axim_read_data_idle;
  wire _s_axis_axim_read_idle;
  assign _s_axis_axim_read_data_idle = _s_axis_axim_read_req_fifo_empty && !_s_axis_axim_read_data_busy;
  assign _s_axis_axim_read_idle = _s_axis_axim_read_data_idle;
  wire [32-1:0] _tmp_60;
  assign _tmp_60 = maxi_axim_awaddr;

  always @(*) begin
    axi_s_ctrl_axim_awaddr = _tmp_60;
  end

  wire [4-1:0] _tmp_61;
  assign _tmp_61 = maxi_axim_awcache;

  always @(*) begin
    axi_s_ctrl_axim_awcache = _tmp_61;
  end

  wire [3-1:0] _tmp_62;
  assign _tmp_62 = maxi_axim_awprot;

  always @(*) begin
    axi_s_ctrl_axim_awprot = _tmp_62;
  end

  wire _tmp_63;
  assign _tmp_63 = maxi_axim_awvalid;

  always @(*) begin
    axi_s_ctrl_axim_awvalid = _tmp_63;
  end

  assign maxi_axim_awready = axi_s_ctrl_axim_awready;
  wire [64-1:0] _tmp_64;
  assign _tmp_64 = maxi_axim_wdata;

  always @(*) begin
    axi_s_ctrl_axim_wdata = _tmp_64;
  end

  wire [8-1:0] _tmp_65;
  assign _tmp_65 = maxi_axim_wstrb;

  always @(*) begin
    axi_s_ctrl_axim_wstrb = _tmp_65;
  end

  wire _tmp_66;
  assign _tmp_66 = maxi_axim_wvalid;

  always @(*) begin
    axi_s_ctrl_axim_wvalid = _tmp_66;
  end

  assign maxi_axim_wready = axi_s_ctrl_axim_wready;
  assign maxi_axim_bresp = axi_s_ctrl_axim_bresp;
  assign maxi_axim_bvalid = axi_s_ctrl_axim_bvalid;
  wire _tmp_67;
  assign _tmp_67 = maxi_axim_bready;

  always @(*) begin
    axi_s_ctrl_axim_bready = _tmp_67;
  end

  wire [32-1:0] _tmp_68;
  assign _tmp_68 = maxi_axim_araddr;

  always @(*) begin
    axi_s_ctrl_axim_araddr = _tmp_68;
  end

  wire [4-1:0] _tmp_69;
  assign _tmp_69 = maxi_axim_arcache;

  always @(*) begin
    axi_s_ctrl_axim_arcache = _tmp_69;
  end

  wire [3-1:0] _tmp_70;
  assign _tmp_70 = maxi_axim_arprot;

  always @(*) begin
    axi_s_ctrl_axim_arprot = _tmp_70;
  end

  wire _tmp_71;
  assign _tmp_71 = maxi_axim_arvalid;

  always @(*) begin
    axi_s_ctrl_axim_arvalid = _tmp_71;
  end

  assign maxi_axim_arready = axi_s_ctrl_axim_arready;
  assign maxi_axim_rdata = axi_s_ctrl_axim_rdata;
  assign maxi_axim_rresp = axi_s_ctrl_axim_rresp;
  assign maxi_axim_rvalid = axi_s_ctrl_axim_rvalid;
  wire _tmp_72;
  assign _tmp_72 = maxi_axim_rready;

  always @(*) begin
    axi_s_ctrl_axim_rready = _tmp_72;
  end

  assign s_axis_axim_tdata = axis_out_axim_tdata;
  assign s_axis_axim_tvalid = axis_out_axim_tvalid;
  wire _tmp_73;
  assign _tmp_73 = s_axis_axim_tready;

  always @(*) begin
    axis_out_axim_tready = _tmp_73;
  end

  assign s_axis_axim_tlast = axis_out_axim_tlast;
  reg [128-1:0] read_data_74;
  wire [32-1:0] _tmp_75;
  assign _tmp_75 = llc_maxi_axim_awaddr;

  always @(*) begin
    axi_s_llc_awaddr = _tmp_75;
  end

  wire [8-1:0] _tmp_76;
  assign _tmp_76 = llc_maxi_axim_awlen;

  always @(*) begin
    axi_s_llc_awlen = _tmp_76;
  end

  wire [3-1:0] _tmp_77;
  assign _tmp_77 = llc_maxi_axim_awsize;

  always @(*) begin
    axi_s_llc_awsize = _tmp_77;
  end

  wire [2-1:0] _tmp_78;
  assign _tmp_78 = llc_maxi_axim_awburst;

  always @(*) begin
    axi_s_llc_awburst = _tmp_78;
  end

  wire [1-1:0] _tmp_79;
  assign _tmp_79 = llc_maxi_axim_awlock;

  always @(*) begin
    axi_s_llc_awlock = _tmp_79;
  end

  wire [4-1:0] _tmp_80;
  assign _tmp_80 = llc_maxi_axim_awcache;

  always @(*) begin
    axi_s_llc_awcache = _tmp_80;
  end

  wire [3-1:0] _tmp_81;
  assign _tmp_81 = llc_maxi_axim_awprot;

  always @(*) begin
    axi_s_llc_awprot = _tmp_81;
  end

  wire [4-1:0] _tmp_82;
  assign _tmp_82 = llc_maxi_axim_awqos;

  always @(*) begin
    axi_s_llc_awqos = _tmp_82;
  end

  wire [2-1:0] _tmp_83;
  assign _tmp_83 = llc_maxi_axim_awuser;

  always @(*) begin
    axi_s_llc_awuser = _tmp_83;
  end

  wire _tmp_84;
  assign _tmp_84 = llc_maxi_axim_awvalid;

  always @(*) begin
    axi_s_llc_awvalid = _tmp_84;
  end

  assign llc_maxi_axim_awready = axi_s_llc_awready;
  wire [128-1:0] _tmp_85;
  assign _tmp_85 = llc_maxi_axim_wdata;

  always @(*) begin
    axi_s_llc_wdata = _tmp_85;
  end

  wire [16-1:0] _tmp_86;
  assign _tmp_86 = llc_maxi_axim_wstrb;

  always @(*) begin
    axi_s_llc_wstrb = _tmp_86;
  end

  wire _tmp_87;
  assign _tmp_87 = llc_maxi_axim_wlast;

  always @(*) begin
    axi_s_llc_wlast = _tmp_87;
  end

  wire _tmp_88;
  assign _tmp_88 = llc_maxi_axim_wvalid;

  always @(*) begin
    axi_s_llc_wvalid = _tmp_88;
  end

  assign llc_maxi_axim_wready = axi_s_llc_wready;
  assign llc_maxi_axim_bresp = axi_s_llc_bresp;
  assign llc_maxi_axim_bvalid = axi_s_llc_bvalid;
  wire _tmp_89;
  assign _tmp_89 = llc_maxi_axim_bready;

  always @(*) begin
    axi_s_llc_bready = _tmp_89;
  end

  wire [32-1:0] _tmp_90;
  assign _tmp_90 = llc_maxi_axim_araddr;

  always @(*) begin
    axi_s_llc_araddr = _tmp_90;
  end

  wire [8-1:0] _tmp_91;
  assign _tmp_91 = llc_maxi_axim_arlen;

  always @(*) begin
    axi_s_llc_arlen = _tmp_91;
  end

  wire [3-1:0] _tmp_92;
  assign _tmp_92 = llc_maxi_axim_arsize;

  always @(*) begin
    axi_s_llc_arsize = _tmp_92;
  end

  wire [2-1:0] _tmp_93;
  assign _tmp_93 = llc_maxi_axim_arburst;

  always @(*) begin
    axi_s_llc_arburst = _tmp_93;
  end

  wire [1-1:0] _tmp_94;
  assign _tmp_94 = llc_maxi_axim_arlock;

  always @(*) begin
    axi_s_llc_arlock = _tmp_94;
  end

  wire [4-1:0] _tmp_95;
  assign _tmp_95 = llc_maxi_axim_arcache;

  always @(*) begin
    axi_s_llc_arcache = _tmp_95;
  end

  wire [3-1:0] _tmp_96;
  assign _tmp_96 = llc_maxi_axim_arprot;

  always @(*) begin
    axi_s_llc_arprot = _tmp_96;
  end

  wire [4-1:0] _tmp_97;
  assign _tmp_97 = llc_maxi_axim_arqos;

  always @(*) begin
    axi_s_llc_arqos = _tmp_97;
  end

  wire [2-1:0] _tmp_98;
  assign _tmp_98 = llc_maxi_axim_aruser;

  always @(*) begin
    axi_s_llc_aruser = _tmp_98;
  end

  wire _tmp_99;
  assign _tmp_99 = llc_maxi_axim_arvalid;

  always @(*) begin
    axi_s_llc_arvalid = _tmp_99;
  end

  assign llc_maxi_axim_arready = axi_s_llc_arready;
  assign llc_maxi_axim_rdata = axi_s_llc_rdata;
  assign llc_maxi_axim_rresp = axi_s_llc_rresp;
  assign llc_maxi_axim_rlast = axi_s_llc_rlast;
  assign llc_maxi_axim_rvalid = axi_s_llc_rvalid;
  wire _tmp_100;
  assign _tmp_100 = llc_maxi_axim_rready;

  always @(*) begin
    axi_s_llc_rready = _tmp_100;
  end

  reg [32-1:0] th_ctrl;
  localparam th_ctrl_init = 0;
  reg _maxi_axim_raddr_cond_0_1;
  reg signed [64-1:0] axim_rdata_101;
  assign _maxi_axim_rready_sb_0 = th_ctrl == 4;
  reg signed [32-1:0] _th_ctrl_v_1;
  reg [32-1:0] fsm;
  localparam fsm_init = 0;
  reg _llc_maxi_axim_waddr_cond_0_1;
  reg _llc_maxi_axim_wdata_cond_0_1;
  reg _llc_maxi_axim_wdata_cond_1_1;
  reg _llc_maxi_axim_wdata_cond_2_1;
  reg _llc_maxi_axim_wdata_cond_3_1;

  axim
  uut
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
    .axis_in_axim_tdata(axis_in_axim_tdata),
    .axis_in_axim_tvalid(axis_in_axim_tvalid),
    .axis_in_axim_tready(axis_in_axim_tready),
    .axis_in_axim_tlast(axis_in_axim_tlast),
    .axis_out_axim_tdata(axis_out_axim_tdata),
    .axis_out_axim_tvalid(axis_out_axim_tvalid),
    .axis_out_axim_tready(axis_out_axim_tready),
    .axis_out_axim_tlast(axis_out_axim_tlast),
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


  initial begin
    $dumpfile("axim.vcd");
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
    maxi_axim_awaddr = 0;
    maxi_axim_awvalid = 0;
    _maxi_axim_wdata_sb_0 = 0;
    _maxi_axim_wstrb_sb_0 = 0;
    _maxi_axim_wvalid_sb_0 = 0;
    _sb_maxi_axim_writedata_data_5 = 0;
    _sb_maxi_axim_writedata_valid_6 = 0;
    _sb_maxi_axim_writedata_tmp_data_8 = 0;
    _sb_maxi_axim_writedata_tmp_valid_9 = 0;
    maxi_axim_araddr = 0;
    maxi_axim_arvalid = 0;
    _sb_maxi_axim_readdata_data_18 = 0;
    _sb_maxi_axim_readdata_valid_19 = 0;
    _sb_maxi_axim_readdata_tmp_data_21 = 0;
    _sb_maxi_axim_readdata_tmp_valid_22 = 0;
    _maxi_axim_outstanding_wcount = 0;
    llc_maxi_axim_awaddr = 0;
    llc_maxi_axim_awlen = 0;
    llc_maxi_axim_awvalid = 0;
    _llc_maxi_axim_wdata_sb_0 = 0;
    _llc_maxi_axim_wstrb_sb_0 = 0;
    _llc_maxi_axim_wlast_sb_0 = 0;
    _llc_maxi_axim_wvalid_sb_0 = 0;
    _sb_llc_maxi_axim_writedata_data_32 = 0;
    _sb_llc_maxi_axim_writedata_valid_33 = 0;
    _sb_llc_maxi_axim_writedata_tmp_data_35 = 0;
    _sb_llc_maxi_axim_writedata_tmp_valid_36 = 0;
    llc_maxi_axim_araddr = 0;
    llc_maxi_axim_arlen = 0;
    llc_maxi_axim_arvalid = 0;
    _sb_llc_maxi_axim_readdata_data_47 = 0;
    _sb_llc_maxi_axim_readdata_valid_48 = 0;
    _sb_llc_maxi_axim_readdata_tmp_data_50 = 0;
    _sb_llc_maxi_axim_readdata_tmp_valid_51 = 0;
    _llc_maxi_axim_outstanding_wcount = 0;
    count__s_axis_axim_read_req_fifo = 0;
    _s_axis_axim_read_op_sel_buf = 0;
    _s_axis_axim_read_local_addr_buf = 0;
    _s_axis_axim_read_local_stride_buf = 0;
    _s_axis_axim_read_local_size_buf = 0;
    _s_axis_axim_read_data_busy = 0;
    read_data_74 = 0;
    th_ctrl = th_ctrl_init;
    _maxi_axim_raddr_cond_0_1 = 0;
    axim_rdata_101 = 0;
    _th_ctrl_v_1 = 0;
    fsm = fsm_init;
    _llc_maxi_axim_waddr_cond_0_1 = 0;
    _llc_maxi_axim_wdata_cond_0_1 = 0;
    _llc_maxi_axim_wdata_cond_1_1 = 0;
    _llc_maxi_axim_wdata_cond_2_1 = 0;
    _llc_maxi_axim_wdata_cond_3_1 = 0;
    #100;
    RST = 1;
    #100;
    RST = 0;
    #1000000;
    $finish;
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_axim_writedata_data_5 <= 0;
      _sb_maxi_axim_writedata_valid_6 <= 0;
      _sb_maxi_axim_writedata_tmp_data_8 <= 0;
      _sb_maxi_axim_writedata_tmp_valid_9 <= 0;
    end else begin
      if(_sb_maxi_axim_writedata_m_ready_4 || !_sb_maxi_axim_writedata_valid_6) begin
        _sb_maxi_axim_writedata_data_5 <= _sb_maxi_axim_writedata_next_data_10;
        _sb_maxi_axim_writedata_valid_6 <= _sb_maxi_axim_writedata_next_valid_11;
      end 
      if(!_sb_maxi_axim_writedata_tmp_valid_9 && _sb_maxi_axim_writedata_valid_6 && !_sb_maxi_axim_writedata_m_ready_4) begin
        _sb_maxi_axim_writedata_tmp_data_8 <= _sb_maxi_axim_writedata_s_data_2;
        _sb_maxi_axim_writedata_tmp_valid_9 <= _sb_maxi_axim_writedata_s_valid_3;
      end 
      if(_sb_maxi_axim_writedata_tmp_valid_9 && _sb_maxi_axim_writedata_m_ready_4) begin
        _sb_maxi_axim_writedata_tmp_valid_9 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      maxi_axim_araddr <= 0;
      maxi_axim_arvalid <= 0;
      _maxi_axim_raddr_cond_0_1 <= 0;
    end else begin
      if(_maxi_axim_raddr_cond_0_1) begin
        maxi_axim_arvalid <= 0;
      end 
      if((th_ctrl == 2) && (maxi_axim_arready || !maxi_axim_arvalid)) begin
        maxi_axim_araddr <= 0;
        maxi_axim_arvalid <= 1;
      end 
      _maxi_axim_raddr_cond_0_1 <= 1;
      if(maxi_axim_arvalid && !maxi_axim_arready) begin
        maxi_axim_arvalid <= maxi_axim_arvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_axim_readdata_data_18 <= 0;
      _sb_maxi_axim_readdata_valid_19 <= 0;
      _sb_maxi_axim_readdata_tmp_data_21 <= 0;
      _sb_maxi_axim_readdata_tmp_valid_22 <= 0;
    end else begin
      if(_sb_maxi_axim_readdata_m_ready_17 || !_sb_maxi_axim_readdata_valid_19) begin
        _sb_maxi_axim_readdata_data_18 <= _sb_maxi_axim_readdata_next_data_23;
        _sb_maxi_axim_readdata_valid_19 <= _sb_maxi_axim_readdata_next_valid_24;
      end 
      if(!_sb_maxi_axim_readdata_tmp_valid_22 && _sb_maxi_axim_readdata_valid_19 && !_sb_maxi_axim_readdata_m_ready_17) begin
        _sb_maxi_axim_readdata_tmp_data_21 <= _sb_maxi_axim_readdata_s_data_15;
        _sb_maxi_axim_readdata_tmp_valid_22 <= _sb_maxi_axim_readdata_s_valid_16;
      end 
      if(_sb_maxi_axim_readdata_tmp_valid_22 && _sb_maxi_axim_readdata_m_ready_17) begin
        _sb_maxi_axim_readdata_tmp_valid_22 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _maxi_axim_outstanding_wcount <= 0;
    end else begin
      if(maxi_axim_awvalid && maxi_axim_awready && !(maxi_axim_bvalid && maxi_axim_bready) && (_maxi_axim_outstanding_wcount < 7)) begin
        _maxi_axim_outstanding_wcount <= _maxi_axim_outstanding_wcount + 1;
      end 
      if(!(maxi_axim_awvalid && maxi_axim_awready) && (maxi_axim_bvalid && maxi_axim_bready) && (_maxi_axim_outstanding_wcount > 0)) begin
        _maxi_axim_outstanding_wcount <= _maxi_axim_outstanding_wcount - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      llc_maxi_axim_awaddr <= 0;
      llc_maxi_axim_awlen <= 0;
      llc_maxi_axim_awvalid <= 0;
      _llc_maxi_axim_waddr_cond_0_1 <= 0;
    end else begin
      if(_llc_maxi_axim_waddr_cond_0_1) begin
        llc_maxi_axim_awvalid <= 0;
      end 
      if((fsm == 1) && ((_llc_maxi_axim_outstanding_wcount < 6) && (llc_maxi_axim_awready || !llc_maxi_axim_awvalid))) begin
        llc_maxi_axim_awaddr <= 64;
        llc_maxi_axim_awlen <= 3;
        llc_maxi_axim_awvalid <= 1;
      end 
      if((fsm == 1) && ((_llc_maxi_axim_outstanding_wcount < 6) && (llc_maxi_axim_awready || !llc_maxi_axim_awvalid)) && 0) begin
        llc_maxi_axim_awvalid <= 0;
      end 
      _llc_maxi_axim_waddr_cond_0_1 <= 1;
      if(llc_maxi_axim_awvalid && !llc_maxi_axim_awready) begin
        llc_maxi_axim_awvalid <= llc_maxi_axim_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _llc_maxi_axim_wdata_sb_0 <= 0;
      _llc_maxi_axim_wvalid_sb_0 <= 0;
      _llc_maxi_axim_wlast_sb_0 <= 0;
      _llc_maxi_axim_wstrb_sb_0 <= 0;
      _llc_maxi_axim_wdata_cond_0_1 <= 0;
      _llc_maxi_axim_wdata_cond_1_1 <= 0;
      _llc_maxi_axim_wdata_cond_2_1 <= 0;
      _llc_maxi_axim_wdata_cond_3_1 <= 0;
    end else begin
      if(_llc_maxi_axim_wdata_cond_0_1) begin
        _llc_maxi_axim_wvalid_sb_0 <= 0;
        _llc_maxi_axim_wlast_sb_0 <= 0;
      end 
      if(_llc_maxi_axim_wdata_cond_1_1) begin
        _llc_maxi_axim_wvalid_sb_0 <= 0;
        _llc_maxi_axim_wlast_sb_0 <= 0;
      end 
      if(_llc_maxi_axim_wdata_cond_2_1) begin
        _llc_maxi_axim_wvalid_sb_0 <= 0;
        _llc_maxi_axim_wlast_sb_0 <= 0;
      end 
      if(_llc_maxi_axim_wdata_cond_3_1) begin
        _llc_maxi_axim_wvalid_sb_0 <= 0;
        _llc_maxi_axim_wlast_sb_0 <= 0;
      end 
      if((fsm == 3) && (_llc_maxi_axim_wready_sb_0 || !_llc_maxi_axim_wvalid_sb_0)) begin
        _llc_maxi_axim_wdata_sb_0 <= 48879;
        _llc_maxi_axim_wvalid_sb_0 <= 1;
        _llc_maxi_axim_wlast_sb_0 <= 0;
        _llc_maxi_axim_wstrb_sb_0 <= { 16{ 1'd1 } };
      end 
      _llc_maxi_axim_wdata_cond_0_1 <= 1;
      if(_llc_maxi_axim_wvalid_sb_0 && !_llc_maxi_axim_wready_sb_0) begin
        _llc_maxi_axim_wvalid_sb_0 <= _llc_maxi_axim_wvalid_sb_0;
        _llc_maxi_axim_wlast_sb_0 <= _llc_maxi_axim_wlast_sb_0;
      end 
      if((fsm == 4) && (_llc_maxi_axim_wready_sb_0 || !_llc_maxi_axim_wvalid_sb_0)) begin
        _llc_maxi_axim_wdata_sb_0 <= 48879;
        _llc_maxi_axim_wvalid_sb_0 <= 1;
        _llc_maxi_axim_wlast_sb_0 <= 0;
        _llc_maxi_axim_wstrb_sb_0 <= { 16{ 1'd1 } };
      end 
      _llc_maxi_axim_wdata_cond_1_1 <= 1;
      if(_llc_maxi_axim_wvalid_sb_0 && !_llc_maxi_axim_wready_sb_0) begin
        _llc_maxi_axim_wvalid_sb_0 <= _llc_maxi_axim_wvalid_sb_0;
        _llc_maxi_axim_wlast_sb_0 <= _llc_maxi_axim_wlast_sb_0;
      end 
      if((fsm == 5) && (_llc_maxi_axim_wready_sb_0 || !_llc_maxi_axim_wvalid_sb_0)) begin
        _llc_maxi_axim_wdata_sb_0 <= 48879;
        _llc_maxi_axim_wvalid_sb_0 <= 1;
        _llc_maxi_axim_wlast_sb_0 <= 0;
        _llc_maxi_axim_wstrb_sb_0 <= { 16{ 1'd1 } };
      end 
      _llc_maxi_axim_wdata_cond_2_1 <= 1;
      if(_llc_maxi_axim_wvalid_sb_0 && !_llc_maxi_axim_wready_sb_0) begin
        _llc_maxi_axim_wvalid_sb_0 <= _llc_maxi_axim_wvalid_sb_0;
        _llc_maxi_axim_wlast_sb_0 <= _llc_maxi_axim_wlast_sb_0;
      end 
      if((fsm == 6) && (_llc_maxi_axim_wready_sb_0 || !_llc_maxi_axim_wvalid_sb_0)) begin
        _llc_maxi_axim_wdata_sb_0 <= 48879;
        _llc_maxi_axim_wvalid_sb_0 <= 1;
        _llc_maxi_axim_wlast_sb_0 <= 1;
        _llc_maxi_axim_wstrb_sb_0 <= { 16{ 1'd1 } };
      end 
      _llc_maxi_axim_wdata_cond_3_1 <= 1;
      if(_llc_maxi_axim_wvalid_sb_0 && !_llc_maxi_axim_wready_sb_0) begin
        _llc_maxi_axim_wvalid_sb_0 <= _llc_maxi_axim_wvalid_sb_0;
        _llc_maxi_axim_wlast_sb_0 <= _llc_maxi_axim_wlast_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_llc_maxi_axim_writedata_data_32 <= 0;
      _sb_llc_maxi_axim_writedata_valid_33 <= 0;
      _sb_llc_maxi_axim_writedata_tmp_data_35 <= 0;
      _sb_llc_maxi_axim_writedata_tmp_valid_36 <= 0;
    end else begin
      if(_sb_llc_maxi_axim_writedata_m_ready_31 || !_sb_llc_maxi_axim_writedata_valid_33) begin
        _sb_llc_maxi_axim_writedata_data_32 <= _sb_llc_maxi_axim_writedata_next_data_37;
        _sb_llc_maxi_axim_writedata_valid_33 <= _sb_llc_maxi_axim_writedata_next_valid_38;
      end 
      if(!_sb_llc_maxi_axim_writedata_tmp_valid_36 && _sb_llc_maxi_axim_writedata_valid_33 && !_sb_llc_maxi_axim_writedata_m_ready_31) begin
        _sb_llc_maxi_axim_writedata_tmp_data_35 <= _sb_llc_maxi_axim_writedata_s_data_29;
        _sb_llc_maxi_axim_writedata_tmp_valid_36 <= _sb_llc_maxi_axim_writedata_s_valid_30;
      end 
      if(_sb_llc_maxi_axim_writedata_tmp_valid_36 && _sb_llc_maxi_axim_writedata_m_ready_31) begin
        _sb_llc_maxi_axim_writedata_tmp_valid_36 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_llc_maxi_axim_readdata_data_47 <= 0;
      _sb_llc_maxi_axim_readdata_valid_48 <= 0;
      _sb_llc_maxi_axim_readdata_tmp_data_50 <= 0;
      _sb_llc_maxi_axim_readdata_tmp_valid_51 <= 0;
    end else begin
      if(_sb_llc_maxi_axim_readdata_m_ready_46 || !_sb_llc_maxi_axim_readdata_valid_48) begin
        _sb_llc_maxi_axim_readdata_data_47 <= _sb_llc_maxi_axim_readdata_next_data_52;
        _sb_llc_maxi_axim_readdata_valid_48 <= _sb_llc_maxi_axim_readdata_next_valid_53;
      end 
      if(!_sb_llc_maxi_axim_readdata_tmp_valid_51 && _sb_llc_maxi_axim_readdata_valid_48 && !_sb_llc_maxi_axim_readdata_m_ready_46) begin
        _sb_llc_maxi_axim_readdata_tmp_data_50 <= _sb_llc_maxi_axim_readdata_s_data_44;
        _sb_llc_maxi_axim_readdata_tmp_valid_51 <= _sb_llc_maxi_axim_readdata_s_valid_45;
      end 
      if(_sb_llc_maxi_axim_readdata_tmp_valid_51 && _sb_llc_maxi_axim_readdata_m_ready_46) begin
        _sb_llc_maxi_axim_readdata_tmp_valid_51 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _llc_maxi_axim_outstanding_wcount <= 0;
    end else begin
      if(llc_maxi_axim_awvalid && llc_maxi_axim_awready && !(llc_maxi_axim_bvalid && llc_maxi_axim_bready) && (_llc_maxi_axim_outstanding_wcount < 7)) begin
        _llc_maxi_axim_outstanding_wcount <= _llc_maxi_axim_outstanding_wcount + 1;
      end 
      if(!(llc_maxi_axim_awvalid && llc_maxi_axim_awready) && (llc_maxi_axim_bvalid && llc_maxi_axim_bready) && (_llc_maxi_axim_outstanding_wcount > 0)) begin
        _llc_maxi_axim_outstanding_wcount <= _llc_maxi_axim_outstanding_wcount - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__s_axis_axim_read_req_fifo <= 0;
    end else begin
      if(_s_axis_axim_read_req_fifo_enq && !_s_axis_axim_read_req_fifo_full && (_s_axis_axim_read_req_fifo_deq && !_s_axis_axim_read_req_fifo_empty)) begin
        count__s_axis_axim_read_req_fifo <= count__s_axis_axim_read_req_fifo;
      end else if(_s_axis_axim_read_req_fifo_enq && !_s_axis_axim_read_req_fifo_full) begin
        count__s_axis_axim_read_req_fifo <= count__s_axis_axim_read_req_fifo + 1;
      end else if(_s_axis_axim_read_req_fifo_deq && !_s_axis_axim_read_req_fifo_empty) begin
        count__s_axis_axim_read_req_fifo <= count__s_axis_axim_read_req_fifo - 1;
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

  always @(posedge CLK) begin
    if(RST) begin
      th_ctrl <= th_ctrl_init;
      axim_rdata_101 <= 0;
      _th_ctrl_v_1 <= 0;
    end else begin
      case(th_ctrl)
        th_ctrl_init: begin
          th_ctrl <= th_ctrl_1;
        end
        th_ctrl_1: begin
          if(1) begin
            th_ctrl <= th_ctrl_2;
          end else begin
            th_ctrl <= th_ctrl_9;
          end
        end
        th_ctrl_2: begin
          if(maxi_axim_arready || !maxi_axim_arvalid) begin
            th_ctrl <= th_ctrl_3;
          end 
        end
        th_ctrl_3: begin
          if(maxi_axim_arvalid && maxi_axim_arready) begin
            th_ctrl <= th_ctrl_4;
          end 
        end
        th_ctrl_4: begin
          if(_maxi_axim_rvalid_sb_0) begin
            axim_rdata_101 <= _maxi_axim_rdata_sb_0;
          end 
          if(_maxi_axim_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_5;
          end 
        end
        th_ctrl_5: begin
          _th_ctrl_v_1 <= axim_rdata_101;
          th_ctrl <= th_ctrl_6;
        end
        th_ctrl_6: begin
          if(_th_ctrl_v_1 != 0) begin
            th_ctrl <= th_ctrl_7;
          end else begin
            th_ctrl <= th_ctrl_8;
          end
        end
        th_ctrl_7: begin
          th_ctrl <= th_ctrl_9;
        end
        th_ctrl_8: begin
          th_ctrl <= th_ctrl_1;
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
    end else begin
      case(fsm)
        fsm_init: begin
          fsm <= fsm_1;
        end
        fsm_1: begin
          if((_llc_maxi_axim_outstanding_wcount < 6) && (llc_maxi_axim_awready || !llc_maxi_axim_awvalid)) begin
            fsm <= fsm_2;
          end 
        end
        fsm_2: begin
          fsm <= fsm_3;
        end
        fsm_3: begin
          if(_llc_maxi_axim_wready_sb_0 || !_llc_maxi_axim_wvalid_sb_0) begin
            fsm <= fsm_4;
          end 
        end
        fsm_4: begin
          if(_llc_maxi_axim_wready_sb_0 || !_llc_maxi_axim_wvalid_sb_0) begin
            fsm <= fsm_5;
          end 
        end
        fsm_5: begin
          if(_llc_maxi_axim_wready_sb_0 || !_llc_maxi_axim_wvalid_sb_0) begin
            fsm <= fsm_6;
          end 
        end
        fsm_6: begin
          if(_llc_maxi_axim_wready_sb_0 || !_llc_maxi_axim_wvalid_sb_0) begin
            fsm <= fsm_7;
          end 
        end
      endcase
    end
  end


endmodule



module _s_axis_axim_read_req_fifo
(
  input CLK,
  input RST,
  input _s_axis_axim_read_req_fifo_enq,
  input [105-1:0] _s_axis_axim_read_req_fifo_wdata,
  output _s_axis_axim_read_req_fifo_full,
  output _s_axis_axim_read_req_fifo_almost_full,
  input _s_axis_axim_read_req_fifo_deq,
  output [105-1:0] _s_axis_axim_read_req_fifo_rdata,
  output _s_axis_axim_read_req_fifo_empty,
  output _s_axis_axim_read_req_fifo_almost_empty
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
  assign _s_axis_axim_read_req_fifo_full = is_full;
  assign _s_axis_axim_read_req_fifo_almost_full = is_almost_full || is_full;
  assign _s_axis_axim_read_req_fifo_empty = is_empty;
  assign _s_axis_axim_read_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _s_axis_axim_read_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_s_axis_axim_read_req_fifo_enq && !is_full) begin
        mem[head] <= _s_axis_axim_read_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_s_axis_axim_read_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module axim
(
  input CLK,
  input RST,
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
  input [128-1:0] axis_in_axim_tdata,
  input axis_in_axim_tvalid,
  output axis_in_axim_tready,
  input axis_in_axim_tlast,
  output reg [128-1:0] axis_out_axim_tdata,
  output reg axis_out_axim_tvalid,
  input axis_out_axim_tready,
  output reg axis_out_axim_tlast,
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
  input axi_s_llc_rready
);

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
  reg [32-1:0] addr_0;
  reg writevalid_1;
  reg readvalid_2;
  reg prev_awvalid_3;
  reg prev_arvalid_4;
  assign axi_s_ctrl_axim_awready = (_axi_s_ctrl_axim_register_fsm == 0) && (!writevalid_1 && !readvalid_2 && !axi_s_ctrl_axim_bvalid && prev_awvalid_3);
  assign axi_s_ctrl_axim_arready = (_axi_s_ctrl_axim_register_fsm == 0) && (!readvalid_2 && !writevalid_1 && prev_arvalid_4 && !prev_awvalid_3);
  reg [_axi_s_ctrl_axim_maskwidth-1:0] axis_maskaddr_5;
  wire signed [64-1:0] axislite_rdata_6;
  assign axislite_rdata_6 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_axim_register_0 : 
                            (axis_maskaddr_5 == 1)? _axi_s_ctrl_axim_register_1 : 
                            (axis_maskaddr_5 == 2)? _axi_s_ctrl_axim_register_2 : 
                            (axis_maskaddr_5 == 3)? _axi_s_ctrl_axim_register_3 : 
                            (axis_maskaddr_5 == 4)? _axi_s_ctrl_axim_register_4 : 
                            (axis_maskaddr_5 == 5)? _axi_s_ctrl_axim_register_5 : 'hx;
  wire axislite_flag_7;
  assign axislite_flag_7 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_axim_flag_0 : 
                           (axis_maskaddr_5 == 1)? _axi_s_ctrl_axim_flag_1 : 
                           (axis_maskaddr_5 == 2)? _axi_s_ctrl_axim_flag_2 : 
                           (axis_maskaddr_5 == 3)? _axi_s_ctrl_axim_flag_3 : 
                           (axis_maskaddr_5 == 4)? _axi_s_ctrl_axim_flag_4 : 
                           (axis_maskaddr_5 == 5)? _axi_s_ctrl_axim_flag_5 : 'hx;
  wire signed [64-1:0] axislite_resetval_8;
  assign axislite_resetval_8 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_axim_resetval_0 : 
                               (axis_maskaddr_5 == 1)? _axi_s_ctrl_axim_resetval_1 : 
                               (axis_maskaddr_5 == 2)? _axi_s_ctrl_axim_resetval_2 : 
                               (axis_maskaddr_5 == 3)? _axi_s_ctrl_axim_resetval_3 : 
                               (axis_maskaddr_5 == 4)? _axi_s_ctrl_axim_resetval_4 : 
                               (axis_maskaddr_5 == 5)? _axi_s_ctrl_axim_resetval_5 : 'hx;
  reg _axi_s_ctrl_axim_rdata_cond_0_1;
  assign axi_s_ctrl_axim_wready = _axi_s_ctrl_axim_register_fsm == 3;
  wire _axis_in_axim_read_req_fifo_enq;
  wire [105-1:0] _axis_in_axim_read_req_fifo_wdata;
  wire _axis_in_axim_read_req_fifo_full;
  wire _axis_in_axim_read_req_fifo_almost_full;
  wire _axis_in_axim_read_req_fifo_deq;
  wire [105-1:0] _axis_in_axim_read_req_fifo_rdata;
  wire _axis_in_axim_read_req_fifo_empty;
  wire _axis_in_axim_read_req_fifo_almost_empty;
  assign _axis_in_axim_read_req_fifo_enq = 0;
  assign _axis_in_axim_read_req_fifo_wdata = 'hx;
  assign _axis_in_axim_read_req_fifo_deq = 0;

  _axis_in_axim_read_req_fifo
  inst__axis_in_axim_read_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axis_in_axim_read_req_fifo_enq(_axis_in_axim_read_req_fifo_enq),
    ._axis_in_axim_read_req_fifo_wdata(_axis_in_axim_read_req_fifo_wdata),
    ._axis_in_axim_read_req_fifo_full(_axis_in_axim_read_req_fifo_full),
    ._axis_in_axim_read_req_fifo_almost_full(_axis_in_axim_read_req_fifo_almost_full),
    ._axis_in_axim_read_req_fifo_deq(_axis_in_axim_read_req_fifo_deq),
    ._axis_in_axim_read_req_fifo_rdata(_axis_in_axim_read_req_fifo_rdata),
    ._axis_in_axim_read_req_fifo_empty(_axis_in_axim_read_req_fifo_empty),
    ._axis_in_axim_read_req_fifo_almost_empty(_axis_in_axim_read_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axis_in_axim_read_req_fifo;
  wire [8-1:0] _axis_in_axim_read_op_sel_fifo;
  wire [32-1:0] _axis_in_axim_read_local_addr_fifo;
  wire [32-1:0] _axis_in_axim_read_local_stride_fifo;
  wire [33-1:0] _axis_in_axim_read_local_size_fifo;
  wire [8-1:0] unpack_read_req_op_sel_9;
  wire [32-1:0] unpack_read_req_local_addr_10;
  wire [32-1:0] unpack_read_req_local_stride_11;
  wire [33-1:0] unpack_read_req_local_size_12;
  assign unpack_read_req_op_sel_9 = _axis_in_axim_read_req_fifo_rdata[104:97];
  assign unpack_read_req_local_addr_10 = _axis_in_axim_read_req_fifo_rdata[96:65];
  assign unpack_read_req_local_stride_11 = _axis_in_axim_read_req_fifo_rdata[64:33];
  assign unpack_read_req_local_size_12 = _axis_in_axim_read_req_fifo_rdata[32:0];
  assign _axis_in_axim_read_op_sel_fifo = unpack_read_req_op_sel_9;
  assign _axis_in_axim_read_local_addr_fifo = unpack_read_req_local_addr_10;
  assign _axis_in_axim_read_local_stride_fifo = unpack_read_req_local_stride_11;
  assign _axis_in_axim_read_local_size_fifo = unpack_read_req_local_size_12;
  reg [8-1:0] _axis_in_axim_read_op_sel_buf;
  reg [32-1:0] _axis_in_axim_read_local_addr_buf;
  reg [32-1:0] _axis_in_axim_read_local_stride_buf;
  reg [33-1:0] _axis_in_axim_read_local_size_buf;
  reg _axis_in_axim_read_data_busy;
  wire _axis_in_axim_read_data_idle;
  wire _axis_in_axim_read_idle;
  assign _axis_in_axim_read_data_idle = _axis_in_axim_read_req_fifo_empty && !_axis_in_axim_read_data_busy;
  assign _axis_in_axim_read_idle = _axis_in_axim_read_data_idle;
  wire _axis_out_axim_write_req_fifo_enq;
  wire [105-1:0] _axis_out_axim_write_req_fifo_wdata;
  wire _axis_out_axim_write_req_fifo_full;
  wire _axis_out_axim_write_req_fifo_almost_full;
  wire _axis_out_axim_write_req_fifo_deq;
  wire [105-1:0] _axis_out_axim_write_req_fifo_rdata;
  wire _axis_out_axim_write_req_fifo_empty;
  wire _axis_out_axim_write_req_fifo_almost_empty;
  assign _axis_out_axim_write_req_fifo_enq = 0;
  assign _axis_out_axim_write_req_fifo_wdata = 'hx;
  assign _axis_out_axim_write_req_fifo_deq = 0;

  _axis_out_axim_write_req_fifo
  inst__axis_out_axim_write_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axis_out_axim_write_req_fifo_enq(_axis_out_axim_write_req_fifo_enq),
    ._axis_out_axim_write_req_fifo_wdata(_axis_out_axim_write_req_fifo_wdata),
    ._axis_out_axim_write_req_fifo_full(_axis_out_axim_write_req_fifo_full),
    ._axis_out_axim_write_req_fifo_almost_full(_axis_out_axim_write_req_fifo_almost_full),
    ._axis_out_axim_write_req_fifo_deq(_axis_out_axim_write_req_fifo_deq),
    ._axis_out_axim_write_req_fifo_rdata(_axis_out_axim_write_req_fifo_rdata),
    ._axis_out_axim_write_req_fifo_empty(_axis_out_axim_write_req_fifo_empty),
    ._axis_out_axim_write_req_fifo_almost_empty(_axis_out_axim_write_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axis_out_axim_write_req_fifo;
  wire [8-1:0] _axis_out_axim_write_op_sel_fifo;
  wire [32-1:0] _axis_out_axim_write_local_addr_fifo;
  wire [32-1:0] _axis_out_axim_write_local_stride_fifo;
  wire [33-1:0] _axis_out_axim_write_size_fifo;
  wire [8-1:0] unpack_write_req_op_sel_13;
  wire [32-1:0] unpack_write_req_local_addr_14;
  wire [32-1:0] unpack_write_req_local_stride_15;
  wire [33-1:0] unpack_write_req_local_size_16;
  assign unpack_write_req_op_sel_13 = _axis_out_axim_write_req_fifo_rdata[104:97];
  assign unpack_write_req_local_addr_14 = _axis_out_axim_write_req_fifo_rdata[96:65];
  assign unpack_write_req_local_stride_15 = _axis_out_axim_write_req_fifo_rdata[64:33];
  assign unpack_write_req_local_size_16 = _axis_out_axim_write_req_fifo_rdata[32:0];
  assign _axis_out_axim_write_op_sel_fifo = unpack_write_req_op_sel_13;
  assign _axis_out_axim_write_local_addr_fifo = unpack_write_req_local_addr_14;
  assign _axis_out_axim_write_local_stride_fifo = unpack_write_req_local_stride_15;
  assign _axis_out_axim_write_size_fifo = unpack_write_req_local_size_16;
  reg [8-1:0] _axis_out_axim_write_op_sel_buf;
  reg [32-1:0] _axis_out_axim_write_local_addr_buf;
  reg [32-1:0] _axis_out_axim_write_local_stride_buf;
  reg [33-1:0] _axis_out_axim_write_size_buf;
  reg _axis_out_axim_write_data_busy;
  wire _axis_out_axim_write_data_idle;
  wire _axis_out_axim_write_idle;
  assign _axis_out_axim_write_data_idle = _axis_out_axim_write_req_fifo_empty && !_axis_out_axim_write_data_busy;
  assign _axis_out_axim_write_idle = _axis_out_axim_write_data_idle;
  assign axi_s_llc_bresp = 0;
  assign axi_s_llc_rresp = 0;
  reg [64-1:0] req_addr;
  reg [64-1:0] req_id;
  reg [64-1:0] req_accept;
  reg [64-1:0] is_write;
  reg [64-1:0] req_complete;
  reg [128-1:0] write_data [0:4-1];
  reg [128-1:0] read_data [0:4-1];
  reg [64-1:0] counter;
  reg [64-1:0] status_17;
  reg [64-1:0] th_status_18;
  reg [128-1:0] tmp_data_19;
  reg [32-1:0] spm_thread;
  localparam spm_thread_init = 0;
  reg signed [32-1:0] _spm_thread_i_0;
  reg _axis_out_axim_cond_0_1;
  reg signed [128-1:0] axistreamin_tdata_20;
  reg axistreamin_tlast_21;
  assign axis_in_axim_tready = spm_thread == 30;
  reg [32-1:0] fsm;
  localparam fsm_init = 0;
  reg [32-1:0] addr_22;
  reg [9-1:0] length_23;
  reg writevalid_24;
  reg readvalid_25;
  reg prev_awvalid_26;
  reg prev_arvalid_27;
  assign axi_s_llc_awready = (fsm == 1) && (!writevalid_24 && !readvalid_25 && !axi_s_llc_bvalid && prev_awvalid_26);
  assign axi_s_llc_arready = (fsm == 1) && (!readvalid_25 && !writevalid_24 && prev_arvalid_27 && !prev_awvalid_26);
  reg _axi_s_llc_rdata_cond_0_1;
  assign axi_s_llc_wready = fsm == 201;

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
        axi_s_ctrl_axim_rdata <= axislite_rdata_6;
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
      prev_awvalid_3 <= 0;
      prev_arvalid_4 <= 0;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      addr_0 <= 0;
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
      prev_awvalid_3 <= axi_s_ctrl_axim_awvalid;
      prev_arvalid_4 <= axi_s_ctrl_axim_arvalid;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      if(axi_s_ctrl_axim_awready && axi_s_ctrl_axim_awvalid && !axi_s_ctrl_axim_bvalid) begin
        addr_0 <= axi_s_ctrl_axim_awaddr;
        writevalid_1 <= 1;
      end else if(axi_s_ctrl_axim_arready && axi_s_ctrl_axim_arvalid) begin
        addr_0 <= axi_s_ctrl_axim_araddr;
        readvalid_2 <= 1;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 1) && (axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 0)) begin
        _axi_s_ctrl_axim_register_0 <= axislite_resetval_8;
        _axi_s_ctrl_axim_flag_0 <= 0;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 1) && (axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 1)) begin
        _axi_s_ctrl_axim_register_1 <= axislite_resetval_8;
        _axi_s_ctrl_axim_flag_1 <= 0;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 1) && (axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 2)) begin
        _axi_s_ctrl_axim_register_2 <= axislite_resetval_8;
        _axi_s_ctrl_axim_flag_2 <= 0;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 1) && (axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 3)) begin
        _axi_s_ctrl_axim_register_3 <= axislite_resetval_8;
        _axi_s_ctrl_axim_flag_3 <= 0;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 1) && (axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 4)) begin
        _axi_s_ctrl_axim_register_4 <= axislite_resetval_8;
        _axi_s_ctrl_axim_flag_4 <= 0;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 1) && (axi_s_ctrl_axim_rready || !axi_s_ctrl_axim_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 5)) begin
        _axi_s_ctrl_axim_register_5 <= axislite_resetval_8;
        _axi_s_ctrl_axim_flag_5 <= 0;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 3) && axi_s_ctrl_axim_wvalid && (axis_maskaddr_5 == 0)) begin
        _axi_s_ctrl_axim_register_0 <= axi_s_ctrl_axim_wdata;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 3) && axi_s_ctrl_axim_wvalid && (axis_maskaddr_5 == 1)) begin
        _axi_s_ctrl_axim_register_1 <= axi_s_ctrl_axim_wdata;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 3) && axi_s_ctrl_axim_wvalid && (axis_maskaddr_5 == 2)) begin
        _axi_s_ctrl_axim_register_2 <= axi_s_ctrl_axim_wdata;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 3) && axi_s_ctrl_axim_wvalid && (axis_maskaddr_5 == 3)) begin
        _axi_s_ctrl_axim_register_3 <= axi_s_ctrl_axim_wdata;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 3) && axi_s_ctrl_axim_wvalid && (axis_maskaddr_5 == 4)) begin
        _axi_s_ctrl_axim_register_4 <= axi_s_ctrl_axim_wdata;
      end 
      if((_axi_s_ctrl_axim_register_fsm == 3) && axi_s_ctrl_axim_wvalid && (axis_maskaddr_5 == 5)) begin
        _axi_s_ctrl_axim_register_5 <= axi_s_ctrl_axim_wdata;
      end 
      if((spm_thread == 7) && 1) begin
        _axi_s_ctrl_axim_register_0 <= status_17;
        _axi_s_ctrl_axim_flag_0 <= 0;
      end 
      if((spm_thread == 7) && 0) begin
        _axi_s_ctrl_axim_register_1 <= status_17;
        _axi_s_ctrl_axim_flag_1 <= 0;
      end 
      if((spm_thread == 7) && 0) begin
        _axi_s_ctrl_axim_register_2 <= status_17;
        _axi_s_ctrl_axim_flag_2 <= 0;
      end 
      if((spm_thread == 7) && 0) begin
        _axi_s_ctrl_axim_register_3 <= status_17;
        _axi_s_ctrl_axim_flag_3 <= 0;
      end 
      if((spm_thread == 7) && 0) begin
        _axi_s_ctrl_axim_register_4 <= status_17;
        _axi_s_ctrl_axim_flag_4 <= 0;
      end 
      if((spm_thread == 7) && 0) begin
        _axi_s_ctrl_axim_register_5 <= status_17;
        _axi_s_ctrl_axim_flag_5 <= 0;
      end 
      if((spm_thread == 8) && 0) begin
        _axi_s_ctrl_axim_register_0 <= req_addr;
        _axi_s_ctrl_axim_flag_0 <= 0;
      end 
      if((spm_thread == 8) && 1) begin
        _axi_s_ctrl_axim_register_1 <= req_addr;
        _axi_s_ctrl_axim_flag_1 <= 0;
      end 
      if((spm_thread == 8) && 0) begin
        _axi_s_ctrl_axim_register_2 <= req_addr;
        _axi_s_ctrl_axim_flag_2 <= 0;
      end 
      if((spm_thread == 8) && 0) begin
        _axi_s_ctrl_axim_register_3 <= req_addr;
        _axi_s_ctrl_axim_flag_3 <= 0;
      end 
      if((spm_thread == 8) && 0) begin
        _axi_s_ctrl_axim_register_4 <= req_addr;
        _axi_s_ctrl_axim_flag_4 <= 0;
      end 
      if((spm_thread == 8) && 0) begin
        _axi_s_ctrl_axim_register_5 <= req_addr;
        _axi_s_ctrl_axim_flag_5 <= 0;
      end 
      if((spm_thread == 18) && 0) begin
        _axi_s_ctrl_axim_register_0 <= 1;
        _axi_s_ctrl_axim_flag_0 <= 0;
      end 
      if((spm_thread == 18) && 0) begin
        _axi_s_ctrl_axim_register_1 <= 1;
        _axi_s_ctrl_axim_flag_1 <= 0;
      end 
      if((spm_thread == 18) && 0) begin
        _axi_s_ctrl_axim_register_2 <= 1;
        _axi_s_ctrl_axim_flag_2 <= 0;
      end 
      if((spm_thread == 18) && 0) begin
        _axi_s_ctrl_axim_register_3 <= 1;
        _axi_s_ctrl_axim_flag_3 <= 0;
      end 
      if((spm_thread == 18) && 0) begin
        _axi_s_ctrl_axim_register_4 <= 1;
        _axi_s_ctrl_axim_flag_4 <= 0;
      end 
      if((spm_thread == 18) && 1) begin
        _axi_s_ctrl_axim_register_5 <= 1;
        _axi_s_ctrl_axim_flag_5 <= 0;
      end 
      if((spm_thread == 41) && 0) begin
        _axi_s_ctrl_axim_register_0 <= 0;
        _axi_s_ctrl_axim_flag_0 <= 0;
      end 
      if((spm_thread == 41) && 0) begin
        _axi_s_ctrl_axim_register_1 <= 0;
        _axi_s_ctrl_axim_flag_1 <= 0;
      end 
      if((spm_thread == 41) && 0) begin
        _axi_s_ctrl_axim_register_2 <= 0;
        _axi_s_ctrl_axim_flag_2 <= 0;
      end 
      if((spm_thread == 41) && 0) begin
        _axi_s_ctrl_axim_register_3 <= 0;
        _axi_s_ctrl_axim_flag_3 <= 0;
      end 
      if((spm_thread == 41) && 1) begin
        _axi_s_ctrl_axim_register_4 <= 0;
        _axi_s_ctrl_axim_flag_4 <= 0;
      end 
      if((spm_thread == 41) && 0) begin
        _axi_s_ctrl_axim_register_5 <= 0;
        _axi_s_ctrl_axim_flag_5 <= 0;
      end 
      if((spm_thread == 42) && 0) begin
        _axi_s_ctrl_axim_register_0 <= 0;
        _axi_s_ctrl_axim_flag_0 <= 0;
      end 
      if((spm_thread == 42) && 0) begin
        _axi_s_ctrl_axim_register_1 <= 0;
        _axi_s_ctrl_axim_flag_1 <= 0;
      end 
      if((spm_thread == 42) && 0) begin
        _axi_s_ctrl_axim_register_2 <= 0;
        _axi_s_ctrl_axim_flag_2 <= 0;
      end 
      if((spm_thread == 42) && 0) begin
        _axi_s_ctrl_axim_register_3 <= 0;
        _axi_s_ctrl_axim_flag_3 <= 0;
      end 
      if((spm_thread == 42) && 0) begin
        _axi_s_ctrl_axim_register_4 <= 0;
        _axi_s_ctrl_axim_flag_4 <= 0;
      end 
      if((spm_thread == 42) && 1) begin
        _axi_s_ctrl_axim_register_5 <= 0;
        _axi_s_ctrl_axim_flag_5 <= 0;
      end 
      if((spm_thread == 49) && 1) begin
        _axi_s_ctrl_axim_register_0 <= status_17;
        _axi_s_ctrl_axim_flag_0 <= 0;
      end 
      if((spm_thread == 49) && 0) begin
        _axi_s_ctrl_axim_register_1 <= status_17;
        _axi_s_ctrl_axim_flag_1 <= 0;
      end 
      if((spm_thread == 49) && 0) begin
        _axi_s_ctrl_axim_register_2 <= status_17;
        _axi_s_ctrl_axim_flag_2 <= 0;
      end 
      if((spm_thread == 49) && 0) begin
        _axi_s_ctrl_axim_register_3 <= status_17;
        _axi_s_ctrl_axim_flag_3 <= 0;
      end 
      if((spm_thread == 49) && 0) begin
        _axi_s_ctrl_axim_register_4 <= status_17;
        _axi_s_ctrl_axim_flag_4 <= 0;
      end 
      if((spm_thread == 49) && 0) begin
        _axi_s_ctrl_axim_register_5 <= status_17;
        _axi_s_ctrl_axim_flag_5 <= 0;
      end 
      if((spm_thread == 50) && 0) begin
        _axi_s_ctrl_axim_register_0 <= 0;
        _axi_s_ctrl_axim_flag_0 <= 0;
      end 
      if((spm_thread == 50) && 1) begin
        _axi_s_ctrl_axim_register_1 <= 0;
        _axi_s_ctrl_axim_flag_1 <= 0;
      end 
      if((spm_thread == 50) && 0) begin
        _axi_s_ctrl_axim_register_2 <= 0;
        _axi_s_ctrl_axim_flag_2 <= 0;
      end 
      if((spm_thread == 50) && 0) begin
        _axi_s_ctrl_axim_register_3 <= 0;
        _axi_s_ctrl_axim_flag_3 <= 0;
      end 
      if((spm_thread == 50) && 0) begin
        _axi_s_ctrl_axim_register_4 <= 0;
        _axi_s_ctrl_axim_flag_4 <= 0;
      end 
      if((spm_thread == 50) && 0) begin
        _axi_s_ctrl_axim_register_5 <= 0;
        _axi_s_ctrl_axim_flag_5 <= 0;
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
      axis_maskaddr_5 <= 0;
    end else begin
      case(_axi_s_ctrl_axim_register_fsm)
        _axi_s_ctrl_axim_register_fsm_init: begin
          if(readvalid_2 || writevalid_1) begin
            axis_maskaddr_5 <= (addr_0 >> _axi_s_ctrl_axim_shift) & _axi_s_ctrl_axim_mask;
          end 
          if(readvalid_2) begin
            _axi_s_ctrl_axim_register_fsm <= _axi_s_ctrl_axim_register_fsm_1;
          end 
          if(writevalid_1) begin
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
      _axis_in_axim_read_data_busy <= 0;
    end else begin
      if((spm_thread == 29) && _axis_in_axim_read_idle) begin
        _axis_in_axim_read_data_busy <= 1;
      end 
      if((spm_thread == 30) && axis_in_axim_tvalid) begin
        _axis_in_axim_read_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_in_axim_read_req_fifo <= 0;
    end else begin
      if(_axis_in_axim_read_req_fifo_enq && !_axis_in_axim_read_req_fifo_full && (_axis_in_axim_read_req_fifo_deq && !_axis_in_axim_read_req_fifo_empty)) begin
        count__axis_in_axim_read_req_fifo <= count__axis_in_axim_read_req_fifo;
      end else if(_axis_in_axim_read_req_fifo_enq && !_axis_in_axim_read_req_fifo_full) begin
        count__axis_in_axim_read_req_fifo <= count__axis_in_axim_read_req_fifo + 1;
      end else if(_axis_in_axim_read_req_fifo_deq && !_axis_in_axim_read_req_fifo_empty) begin
        count__axis_in_axim_read_req_fifo <= count__axis_in_axim_read_req_fifo - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axis_out_axim_tdata <= 0;
      axis_out_axim_tvalid <= 0;
      axis_out_axim_tlast <= 0;
      _axis_out_axim_cond_0_1 <= 0;
    end else begin
      if(_axis_out_axim_cond_0_1) begin
        axis_out_axim_tvalid <= 0;
        axis_out_axim_tlast <= 0;
      end 
      if((spm_thread == 23) && (axis_out_axim_tready || !axis_out_axim_tvalid)) begin
        axis_out_axim_tdata <= write_data[_spm_thread_i_0];
        axis_out_axim_tvalid <= 1;
        axis_out_axim_tlast <= _spm_thread_i_0 == 3;
      end 
      _axis_out_axim_cond_0_1 <= 1;
      if(axis_out_axim_tvalid && !axis_out_axim_tready) begin
        axis_out_axim_tvalid <= axis_out_axim_tvalid;
        axis_out_axim_tlast <= axis_out_axim_tlast;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axis_out_axim_write_data_busy <= 0;
    end else begin
      if((spm_thread == 22) && _axis_out_axim_write_idle) begin
        _axis_out_axim_write_data_busy <= 1;
      end 
      if((spm_thread == 23) && (axis_out_axim_tready || !axis_out_axim_tvalid)) begin
        _axis_out_axim_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_out_axim_write_req_fifo <= 0;
    end else begin
      if(_axis_out_axim_write_req_fifo_enq && !_axis_out_axim_write_req_fifo_full && (_axis_out_axim_write_req_fifo_deq && !_axis_out_axim_write_req_fifo_empty)) begin
        count__axis_out_axim_write_req_fifo <= count__axis_out_axim_write_req_fifo;
      end else if(_axis_out_axim_write_req_fifo_enq && !_axis_out_axim_write_req_fifo_full) begin
        count__axis_out_axim_write_req_fifo <= count__axis_out_axim_write_req_fifo + 1;
      end else if(_axis_out_axim_write_req_fifo_deq && !_axis_out_axim_write_req_fifo_empty) begin
        count__axis_out_axim_write_req_fifo <= count__axis_out_axim_write_req_fifo - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_llc_rdata <= 0;
      axi_s_llc_rvalid <= 0;
      axi_s_llc_rlast <= 0;
      _axi_s_llc_rdata_cond_0_1 <= 0;
    end else begin
      if(_axi_s_llc_rdata_cond_0_1) begin
        axi_s_llc_rvalid <= 0;
        axi_s_llc_rlast <= 0;
      end 
      if((fsm == 102) && (axi_s_llc_rready || !axi_s_llc_rvalid)) begin
        axi_s_llc_rdata <= read_data[counter];
        axi_s_llc_rvalid <= 1;
        axi_s_llc_rlast <= counter == 3;
      end 
      _axi_s_llc_rdata_cond_0_1 <= 1;
      if(axi_s_llc_rvalid && !axi_s_llc_rready) begin
        axi_s_llc_rvalid <= axi_s_llc_rvalid;
        axi_s_llc_rlast <= axi_s_llc_rlast;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_s_llc_bvalid <= 0;
      prev_awvalid_26 <= 0;
      prev_arvalid_27 <= 0;
      writevalid_24 <= 0;
      readvalid_25 <= 0;
      addr_22 <= 0;
      length_23 <= 0;
    end else begin
      if(axi_s_llc_bvalid && axi_s_llc_bready) begin
        axi_s_llc_bvalid <= 0;
      end 
      if(axi_s_llc_wvalid && axi_s_llc_wready && axi_s_llc_wlast) begin
        axi_s_llc_bvalid <= 1;
      end 
      prev_awvalid_26 <= axi_s_llc_awvalid;
      prev_arvalid_27 <= axi_s_llc_arvalid;
      writevalid_24 <= 0;
      readvalid_25 <= 0;
      if(axi_s_llc_awready && axi_s_llc_awvalid && !axi_s_llc_bvalid) begin
        addr_22 <= axi_s_llc_awaddr;
        length_23 <= axi_s_llc_awlen + 1;
        writevalid_24 <= 1;
      end else if(axi_s_llc_arready && axi_s_llc_arvalid) begin
        addr_22 <= axi_s_llc_araddr;
        length_23 <= axi_s_llc_arlen + 1;
        readvalid_25 <= 1;
      end 
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
  localparam spm_thread_46 = 46;
  localparam spm_thread_47 = 47;
  localparam spm_thread_48 = 48;
  localparam spm_thread_49 = 49;
  localparam spm_thread_50 = 50;
  localparam spm_thread_51 = 51;
  localparam spm_thread_52 = 52;

  always @(posedge CLK) begin
    if(RST) begin
      spm_thread <= spm_thread_init;
      req_complete <= 0;
      status_17 <= 0;
      th_status_18 <= 0;
      _spm_thread_i_0 <= 0;
      axistreamin_tdata_20 <= 0;
      axistreamin_tlast_21 <= 0;
      read_data[_spm_thread_i_0] <= (0 >> _spm_thread_i_0) & 1'd1;
    end else begin
      case(spm_thread)
        spm_thread_init: begin
          spm_thread <= spm_thread_1;
        end
        spm_thread_1: begin
          if(1) begin
            spm_thread <= spm_thread_2;
          end else begin
            spm_thread <= spm_thread_52;
          end
        end
        spm_thread_2: begin
          if(th_status_18 == 0) begin
            spm_thread <= spm_thread_3;
          end else begin
            spm_thread <= spm_thread_12;
          end
        end
        spm_thread_3: begin
          req_complete <= 0;
          spm_thread <= spm_thread_4;
        end
        spm_thread_4: begin
          if(req_accept != 0) begin
            spm_thread <= spm_thread_5;
          end else begin
            spm_thread <= spm_thread_11;
          end
        end
        spm_thread_5: begin
          $display("Request accepted: addr=%x id=%d write=%d", req_addr, req_id, is_write);
          spm_thread <= spm_thread_6;
        end
        spm_thread_6: begin
          status_17 <= (is_write << 1) | req_accept;
          spm_thread <= spm_thread_7;
        end
        spm_thread_7: begin
          spm_thread <= spm_thread_8;
        end
        spm_thread_8: begin
          spm_thread <= spm_thread_9;
        end
        spm_thread_9: begin
          req_complete <= 0;
          spm_thread <= spm_thread_10;
        end
        spm_thread_10: begin
          th_status_18 <= 1;
          spm_thread <= spm_thread_11;
        end
        spm_thread_11: begin
          spm_thread <= spm_thread_51;
        end
        spm_thread_12: begin
          if(th_status_18 == 1) begin
            spm_thread <= spm_thread_13;
          end else begin
            spm_thread <= spm_thread_44;
          end
        end
        spm_thread_13: begin
          $display("Waiting for command");
          spm_thread <= spm_thread_14;
        end
        spm_thread_14: begin
          if(1) begin
            spm_thread <= spm_thread_15;
          end else begin
            spm_thread <= spm_thread_18;
          end
        end
        spm_thread_15: begin
          if(_axi_s_ctrl_axim_register_4 != 0) begin
            spm_thread <= spm_thread_16;
          end else begin
            spm_thread <= spm_thread_17;
          end
        end
        spm_thread_16: begin
          spm_thread <= spm_thread_18;
        end
        spm_thread_17: begin
          spm_thread <= spm_thread_14;
        end
        spm_thread_18: begin
          spm_thread <= spm_thread_19;
        end
        spm_thread_19: begin
          if(_axi_s_ctrl_axim_register_4 == 1) begin
            spm_thread <= spm_thread_20;
          end else begin
            spm_thread <= spm_thread_26;
          end
        end
        spm_thread_20: begin
          _spm_thread_i_0 <= 0;
          spm_thread <= spm_thread_21;
        end
        spm_thread_21: begin
          if(_spm_thread_i_0 < 4) begin
            spm_thread <= spm_thread_22;
          end else begin
            spm_thread <= spm_thread_25;
          end
        end
        spm_thread_22: begin
          if(_axis_out_axim_write_idle) begin
            spm_thread <= spm_thread_23;
          end 
        end
        spm_thread_23: begin
          if(axis_out_axim_tready || !axis_out_axim_tvalid) begin
            spm_thread <= spm_thread_24;
          end 
        end
        spm_thread_24: begin
          _spm_thread_i_0 <= _spm_thread_i_0 + 1;
          spm_thread <= spm_thread_21;
        end
        spm_thread_25: begin
          spm_thread <= spm_thread_41;
        end
        spm_thread_26: begin
          if(_axi_s_ctrl_axim_register_4 == 16) begin
            spm_thread <= spm_thread_27;
          end else begin
            spm_thread <= spm_thread_36;
          end
        end
        spm_thread_27: begin
          _spm_thread_i_0 <= 0;
          spm_thread <= spm_thread_28;
        end
        spm_thread_28: begin
          if(_spm_thread_i_0 < 4) begin
            spm_thread <= spm_thread_29;
          end else begin
            spm_thread <= spm_thread_33;
          end
        end
        spm_thread_29: begin
          if(_axis_in_axim_read_idle) begin
            spm_thread <= spm_thread_30;
          end 
        end
        spm_thread_30: begin
          if(axis_in_axim_tvalid) begin
            axistreamin_tdata_20 <= axis_in_axim_tdata;
          end 
          if(axis_in_axim_tvalid) begin
            axistreamin_tlast_21 <= axis_in_axim_tlast;
          end 
          if(axis_in_axim_tvalid) begin
            spm_thread <= spm_thread_31;
          end 
        end
        spm_thread_31: begin
          read_data[_spm_thread_i_0] <= axistreamin_tdata_20;
          spm_thread <= spm_thread_32;
        end
        spm_thread_32: begin
          _spm_thread_i_0 <= _spm_thread_i_0 + 1;
          spm_thread <= spm_thread_28;
        end
        spm_thread_33: begin
          req_complete <= 1;
          spm_thread <= spm_thread_34;
        end
        spm_thread_34: begin
          th_status_18 <= 2;
          spm_thread <= spm_thread_35;
        end
        spm_thread_35: begin
          spm_thread <= spm_thread_41;
        end
        spm_thread_36: begin
          if(_axi_s_ctrl_axim_register_4 == 32) begin
            spm_thread <= spm_thread_37;
          end else begin
            spm_thread <= spm_thread_40;
          end
        end
        spm_thread_37: begin
          req_complete <= 1;
          spm_thread <= spm_thread_38;
        end
        spm_thread_38: begin
          th_status_18 <= 2;
          spm_thread <= spm_thread_39;
        end
        spm_thread_39: begin
          spm_thread <= spm_thread_41;
        end
        spm_thread_40: begin
          $display("Unknown command: %d", _axi_s_ctrl_axim_register_4);
          spm_thread <= spm_thread_41;
        end
        spm_thread_41: begin
          spm_thread <= spm_thread_42;
        end
        spm_thread_42: begin
          spm_thread <= spm_thread_43;
        end
        spm_thread_43: begin
          spm_thread <= spm_thread_51;
        end
        spm_thread_44: begin
          if(th_status_18 == 2) begin
            spm_thread <= spm_thread_45;
          end else begin
            spm_thread <= spm_thread_51;
          end
        end
        spm_thread_45: begin
          if(req_accept == 0) begin
            spm_thread <= spm_thread_46;
          end else begin
            spm_thread <= spm_thread_51;
          end
        end
        spm_thread_46: begin
          th_status_18 <= 0;
          spm_thread <= spm_thread_47;
        end
        spm_thread_47: begin
          req_complete <= 0;
          spm_thread <= spm_thread_48;
        end
        spm_thread_48: begin
          status_17 <= 0;
          spm_thread <= spm_thread_49;
        end
        spm_thread_49: begin
          spm_thread <= spm_thread_50;
        end
        spm_thread_50: begin
          spm_thread <= spm_thread_51;
        end
        spm_thread_51: begin
          spm_thread <= spm_thread_1;
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

  always @(posedge CLK) begin
    if(RST) begin
      fsm <= fsm_init;
      req_addr <= 0;
      is_write <= 0;
      req_accept <= 0;
      counter <= 0;
      req_id <= 0;
      write_data[counter] <= (0 >> counter) & 1'd1;
    end else begin
      case(fsm)
        fsm_init: begin
          fsm <= fsm_1;
        end
        fsm_1: begin
          req_addr <= addr_22;
          if(writevalid_24) begin
            is_write <= 1;
          end 
          if(writevalid_24) begin
            fsm <= fsm_200;
          end 
          if(readvalid_25) begin
            fsm <= fsm_100;
          end 
        end
        fsm_100: begin
          $display("Request received: addr=%x length=", addr_22);
          req_accept <= 1;
          fsm <= fsm_101;
        end
        fsm_101: begin
          if((req_complete == 1) && (th_status_18 == 2)) begin
            fsm <= fsm_102;
          end 
        end
        fsm_102: begin
          if(axi_s_llc_rready || !axi_s_llc_rvalid) begin
            counter <= counter + 1;
          end 
          if((axi_s_llc_rready || !axi_s_llc_rvalid) && (counter == 3)) begin
            fsm <= fsm_103;
          end 
        end
        fsm_103: begin
          req_accept <= 0;
          is_write <= 0;
          counter <= 0;
          req_addr <= 0;
          req_id <= 0;
          if(th_status_18 == 0) begin
            fsm <= fsm_104;
          end 
        end
        fsm_104: begin
          fsm <= fsm_init;
        end
        fsm_200: begin
          counter <= 0;
          fsm <= fsm_201;
        end
        fsm_201: begin
          write_data[counter] <= axi_s_llc_wdata;
          if(axi_s_llc_wvalid) begin
            counter <= counter + 1;
          end 
          if(axi_s_llc_wvalid && axi_s_llc_wlast) begin
            fsm <= fsm_202;
          end 
        end
        fsm_202: begin
          req_accept <= 1;
          is_write <= 1;
          fsm <= fsm_203;
        end
        fsm_203: begin
          if((req_complete == 1) && (th_status_18 == 2)) begin
            fsm <= fsm_204;
          end 
        end
        fsm_204: begin
          $display("Write completed");
          req_accept <= 0;
          is_write <= 0;
          counter <= 0;
          req_addr <= 0;
          req_id <= 0;
          if(th_status_18 == 0) begin
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



module _axis_in_axim_read_req_fifo
(
  input CLK,
  input RST,
  input _axis_in_axim_read_req_fifo_enq,
  input [105-1:0] _axis_in_axim_read_req_fifo_wdata,
  output _axis_in_axim_read_req_fifo_full,
  output _axis_in_axim_read_req_fifo_almost_full,
  input _axis_in_axim_read_req_fifo_deq,
  output [105-1:0] _axis_in_axim_read_req_fifo_rdata,
  output _axis_in_axim_read_req_fifo_empty,
  output _axis_in_axim_read_req_fifo_almost_empty
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
  assign _axis_in_axim_read_req_fifo_full = is_full;
  assign _axis_in_axim_read_req_fifo_almost_full = is_almost_full || is_full;
  assign _axis_in_axim_read_req_fifo_empty = is_empty;
  assign _axis_in_axim_read_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axis_in_axim_read_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axis_in_axim_read_req_fifo_enq && !is_full) begin
        mem[head] <= _axis_in_axim_read_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axis_in_axim_read_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _axis_out_axim_write_req_fifo
(
  input CLK,
  input RST,
  input _axis_out_axim_write_req_fifo_enq,
  input [105-1:0] _axis_out_axim_write_req_fifo_wdata,
  output _axis_out_axim_write_req_fifo_full,
  output _axis_out_axim_write_req_fifo_almost_full,
  input _axis_out_axim_write_req_fifo_deq,
  output [105-1:0] _axis_out_axim_write_req_fifo_rdata,
  output _axis_out_axim_write_req_fifo_empty,
  output _axis_out_axim_write_req_fifo_almost_empty
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
  assign _axis_out_axim_write_req_fifo_full = is_full;
  assign _axis_out_axim_write_req_fifo_almost_full = is_almost_full || is_full;
  assign _axis_out_axim_write_req_fifo_empty = is_empty;
  assign _axis_out_axim_write_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axis_out_axim_write_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axis_out_axim_write_req_fifo_enq && !is_full) begin
        mem[head] <= _axis_out_axim_write_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axis_out_axim_write_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule

