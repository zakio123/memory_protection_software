

module test_mac
(

);

  reg CLK;
  reg RST;
  reg [32-1:0] axi_s_ctrl_mac_awaddr;
  reg [4-1:0] axi_s_ctrl_mac_awcache;
  reg [3-1:0] axi_s_ctrl_mac_awprot;
  reg axi_s_ctrl_mac_awvalid;
  wire axi_s_ctrl_mac_awready;
  reg [64-1:0] axi_s_ctrl_mac_wdata;
  reg [8-1:0] axi_s_ctrl_mac_wstrb;
  reg axi_s_ctrl_mac_wvalid;
  wire axi_s_ctrl_mac_wready;
  wire [2-1:0] axi_s_ctrl_mac_bresp;
  wire axi_s_ctrl_mac_bvalid;
  reg axi_s_ctrl_mac_bready;
  reg [32-1:0] axi_s_ctrl_mac_araddr;
  reg [4-1:0] axi_s_ctrl_mac_arcache;
  reg [3-1:0] axi_s_ctrl_mac_arprot;
  reg axi_s_ctrl_mac_arvalid;
  wire axi_s_ctrl_mac_arready;
  wire [64-1:0] axi_s_ctrl_mac_rdata;
  wire [2-1:0] axi_s_ctrl_mac_rresp;
  wire axi_s_ctrl_mac_rvalid;
  reg axi_s_ctrl_mac_rready;
  reg [128-1:0] axis_in_mac_tdata;
  reg axis_in_mac_tvalid;
  wire axis_in_mac_tready;
  reg axis_in_mac_tlast;
  reg [32-1:0] maxi_mac_awaddr;
  wire [4-1:0] maxi_mac_awcache;
  wire [3-1:0] maxi_mac_awprot;
  reg maxi_mac_awvalid;
  wire maxi_mac_awready;
  assign maxi_mac_awcache = 3;
  assign maxi_mac_awprot = 0;
  wire [64-1:0] maxi_mac_wdata;
  wire [8-1:0] maxi_mac_wstrb;
  wire maxi_mac_wvalid;
  wire maxi_mac_wready;
  reg [64-1:0] _maxi_mac_wdata_sb_0;
  reg [8-1:0] _maxi_mac_wstrb_sb_0;
  reg _maxi_mac_wvalid_sb_0;
  wire _maxi_mac_wready_sb_0;
  wire [8-1:0] _sb_maxi_mac_writedata_s_value_0;
  assign _sb_maxi_mac_writedata_s_value_0 = _maxi_mac_wstrb_sb_0;
  wire [64-1:0] _sb_maxi_mac_writedata_s_value_1;
  assign _sb_maxi_mac_writedata_s_value_1 = _maxi_mac_wdata_sb_0;
  wire [72-1:0] _sb_maxi_mac_writedata_s_data_2;
  assign _sb_maxi_mac_writedata_s_data_2 = { _sb_maxi_mac_writedata_s_value_0, _sb_maxi_mac_writedata_s_value_1 };
  wire _sb_maxi_mac_writedata_s_valid_3;
  assign _sb_maxi_mac_writedata_s_valid_3 = _maxi_mac_wvalid_sb_0;
  wire _sb_maxi_mac_writedata_m_ready_4;
  assign _sb_maxi_mac_writedata_m_ready_4 = maxi_mac_wready;
  reg [72-1:0] _sb_maxi_mac_writedata_data_5;
  reg _sb_maxi_mac_writedata_valid_6;
  wire _sb_maxi_mac_writedata_ready_7;
  reg [72-1:0] _sb_maxi_mac_writedata_tmp_data_8;
  reg _sb_maxi_mac_writedata_tmp_valid_9;
  wire [72-1:0] _sb_maxi_mac_writedata_next_data_10;
  wire _sb_maxi_mac_writedata_next_valid_11;
  assign _sb_maxi_mac_writedata_ready_7 = !_sb_maxi_mac_writedata_tmp_valid_9;
  assign _sb_maxi_mac_writedata_next_data_10 = (_sb_maxi_mac_writedata_tmp_valid_9)? _sb_maxi_mac_writedata_tmp_data_8 : _sb_maxi_mac_writedata_s_data_2;
  assign _sb_maxi_mac_writedata_next_valid_11 = _sb_maxi_mac_writedata_tmp_valid_9 || _sb_maxi_mac_writedata_s_valid_3;
  wire [8-1:0] _sb_maxi_mac_writedata_m_value_12;
  assign _sb_maxi_mac_writedata_m_value_12 = _sb_maxi_mac_writedata_data_5[71:64];
  wire [64-1:0] _sb_maxi_mac_writedata_m_value_13;
  assign _sb_maxi_mac_writedata_m_value_13 = _sb_maxi_mac_writedata_data_5[63:0];
  assign _maxi_mac_wready_sb_0 = _sb_maxi_mac_writedata_ready_7;
  assign maxi_mac_wdata = _sb_maxi_mac_writedata_m_value_13;
  assign maxi_mac_wstrb = _sb_maxi_mac_writedata_m_value_12;
  assign maxi_mac_wvalid = _sb_maxi_mac_writedata_valid_6;
  wire [2-1:0] maxi_mac_bresp;
  wire maxi_mac_bvalid;
  wire maxi_mac_bready;
  assign maxi_mac_bready = 1;
  reg [32-1:0] maxi_mac_araddr;
  wire [4-1:0] maxi_mac_arcache;
  wire [3-1:0] maxi_mac_arprot;
  reg maxi_mac_arvalid;
  wire maxi_mac_arready;
  assign maxi_mac_arcache = 3;
  assign maxi_mac_arprot = 0;
  wire [64-1:0] maxi_mac_rdata;
  wire [2-1:0] maxi_mac_rresp;
  wire maxi_mac_rvalid;
  wire maxi_mac_rready;
  wire [64-1:0] _maxi_mac_rdata_sb_0;
  wire _maxi_mac_rvalid_sb_0;
  wire _maxi_mac_rready_sb_0;
  wire [64-1:0] _sb_maxi_mac_readdata_s_value_14;
  assign _sb_maxi_mac_readdata_s_value_14 = maxi_mac_rdata;
  wire [64-1:0] _sb_maxi_mac_readdata_s_data_15;
  assign _sb_maxi_mac_readdata_s_data_15 = { _sb_maxi_mac_readdata_s_value_14 };
  wire _sb_maxi_mac_readdata_s_valid_16;
  assign _sb_maxi_mac_readdata_s_valid_16 = maxi_mac_rvalid;
  wire _sb_maxi_mac_readdata_m_ready_17;
  assign _sb_maxi_mac_readdata_m_ready_17 = _maxi_mac_rready_sb_0;
  reg [64-1:0] _sb_maxi_mac_readdata_data_18;
  reg _sb_maxi_mac_readdata_valid_19;
  wire _sb_maxi_mac_readdata_ready_20;
  reg [64-1:0] _sb_maxi_mac_readdata_tmp_data_21;
  reg _sb_maxi_mac_readdata_tmp_valid_22;
  wire [64-1:0] _sb_maxi_mac_readdata_next_data_23;
  wire _sb_maxi_mac_readdata_next_valid_24;
  assign _sb_maxi_mac_readdata_ready_20 = !_sb_maxi_mac_readdata_tmp_valid_22;
  assign _sb_maxi_mac_readdata_next_data_23 = (_sb_maxi_mac_readdata_tmp_valid_22)? _sb_maxi_mac_readdata_tmp_data_21 : _sb_maxi_mac_readdata_s_data_15;
  assign _sb_maxi_mac_readdata_next_valid_24 = _sb_maxi_mac_readdata_tmp_valid_22 || _sb_maxi_mac_readdata_s_valid_16;
  wire [64-1:0] _sb_maxi_mac_readdata_m_value_25;
  assign _sb_maxi_mac_readdata_m_value_25 = _sb_maxi_mac_readdata_data_18[63:0];
  assign _maxi_mac_rdata_sb_0 = _sb_maxi_mac_readdata_m_value_25;
  assign _maxi_mac_rvalid_sb_0 = _sb_maxi_mac_readdata_valid_19;
  assign maxi_mac_rready = _sb_maxi_mac_readdata_ready_20;
  reg [3-1:0] _maxi_mac_outstanding_wcount;
  wire _maxi_mac_has_outstanding_write;
  assign _maxi_mac_has_outstanding_write = (_maxi_mac_outstanding_wcount > 0) || maxi_mac_awvalid;
  reg [128-1:0] s_axis_mac_tdata;
  reg s_axis_mac_tvalid;
  wire s_axis_mac_tready;
  reg s_axis_mac_tlast;
  wire _s_axis_mac_write_req_fifo_enq;
  wire [105-1:0] _s_axis_mac_write_req_fifo_wdata;
  wire _s_axis_mac_write_req_fifo_full;
  wire _s_axis_mac_write_req_fifo_almost_full;
  wire _s_axis_mac_write_req_fifo_deq;
  wire [105-1:0] _s_axis_mac_write_req_fifo_rdata;
  wire _s_axis_mac_write_req_fifo_empty;
  wire _s_axis_mac_write_req_fifo_almost_empty;
  assign _s_axis_mac_write_req_fifo_enq = 0;
  assign _s_axis_mac_write_req_fifo_wdata = 'hx;
  assign _s_axis_mac_write_req_fifo_deq = 0;

  _s_axis_mac_write_req_fifo
  inst__s_axis_mac_write_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._s_axis_mac_write_req_fifo_enq(_s_axis_mac_write_req_fifo_enq),
    ._s_axis_mac_write_req_fifo_wdata(_s_axis_mac_write_req_fifo_wdata),
    ._s_axis_mac_write_req_fifo_full(_s_axis_mac_write_req_fifo_full),
    ._s_axis_mac_write_req_fifo_almost_full(_s_axis_mac_write_req_fifo_almost_full),
    ._s_axis_mac_write_req_fifo_deq(_s_axis_mac_write_req_fifo_deq),
    ._s_axis_mac_write_req_fifo_rdata(_s_axis_mac_write_req_fifo_rdata),
    ._s_axis_mac_write_req_fifo_empty(_s_axis_mac_write_req_fifo_empty),
    ._s_axis_mac_write_req_fifo_almost_empty(_s_axis_mac_write_req_fifo_almost_empty)
  );

  reg [4-1:0] count__s_axis_mac_write_req_fifo;
  wire [8-1:0] _s_axis_mac_write_op_sel_fifo;
  wire [32-1:0] _s_axis_mac_write_local_addr_fifo;
  wire [32-1:0] _s_axis_mac_write_local_stride_fifo;
  wire [33-1:0] _s_axis_mac_write_size_fifo;
  wire [8-1:0] unpack_write_req_op_sel_26;
  wire [32-1:0] unpack_write_req_local_addr_27;
  wire [32-1:0] unpack_write_req_local_stride_28;
  wire [33-1:0] unpack_write_req_local_size_29;
  assign unpack_write_req_op_sel_26 = _s_axis_mac_write_req_fifo_rdata[104:97];
  assign unpack_write_req_local_addr_27 = _s_axis_mac_write_req_fifo_rdata[96:65];
  assign unpack_write_req_local_stride_28 = _s_axis_mac_write_req_fifo_rdata[64:33];
  assign unpack_write_req_local_size_29 = _s_axis_mac_write_req_fifo_rdata[32:0];
  assign _s_axis_mac_write_op_sel_fifo = unpack_write_req_op_sel_26;
  assign _s_axis_mac_write_local_addr_fifo = unpack_write_req_local_addr_27;
  assign _s_axis_mac_write_local_stride_fifo = unpack_write_req_local_stride_28;
  assign _s_axis_mac_write_size_fifo = unpack_write_req_local_size_29;
  reg [8-1:0] _s_axis_mac_write_op_sel_buf;
  reg [32-1:0] _s_axis_mac_write_local_addr_buf;
  reg [32-1:0] _s_axis_mac_write_local_stride_buf;
  reg [33-1:0] _s_axis_mac_write_size_buf;
  reg _s_axis_mac_write_data_busy;
  wire _s_axis_mac_write_data_idle;
  wire _s_axis_mac_write_idle;
  assign _s_axis_mac_write_data_idle = _s_axis_mac_write_req_fifo_empty && !_s_axis_mac_write_data_busy;
  assign _s_axis_mac_write_idle = _s_axis_mac_write_data_idle;
  wire [32-1:0] _tmp_30;
  assign _tmp_30 = maxi_mac_awaddr;

  always @(*) begin
    axi_s_ctrl_mac_awaddr = _tmp_30;
  end

  wire [4-1:0] _tmp_31;
  assign _tmp_31 = maxi_mac_awcache;

  always @(*) begin
    axi_s_ctrl_mac_awcache = _tmp_31;
  end

  wire [3-1:0] _tmp_32;
  assign _tmp_32 = maxi_mac_awprot;

  always @(*) begin
    axi_s_ctrl_mac_awprot = _tmp_32;
  end

  wire _tmp_33;
  assign _tmp_33 = maxi_mac_awvalid;

  always @(*) begin
    axi_s_ctrl_mac_awvalid = _tmp_33;
  end

  assign maxi_mac_awready = axi_s_ctrl_mac_awready;
  wire [64-1:0] _tmp_34;
  assign _tmp_34 = maxi_mac_wdata;

  always @(*) begin
    axi_s_ctrl_mac_wdata = _tmp_34;
  end

  wire [8-1:0] _tmp_35;
  assign _tmp_35 = maxi_mac_wstrb;

  always @(*) begin
    axi_s_ctrl_mac_wstrb = _tmp_35;
  end

  wire _tmp_36;
  assign _tmp_36 = maxi_mac_wvalid;

  always @(*) begin
    axi_s_ctrl_mac_wvalid = _tmp_36;
  end

  assign maxi_mac_wready = axi_s_ctrl_mac_wready;
  assign maxi_mac_bresp = axi_s_ctrl_mac_bresp;
  assign maxi_mac_bvalid = axi_s_ctrl_mac_bvalid;
  wire _tmp_37;
  assign _tmp_37 = maxi_mac_bready;

  always @(*) begin
    axi_s_ctrl_mac_bready = _tmp_37;
  end

  wire [32-1:0] _tmp_38;
  assign _tmp_38 = maxi_mac_araddr;

  always @(*) begin
    axi_s_ctrl_mac_araddr = _tmp_38;
  end

  wire [4-1:0] _tmp_39;
  assign _tmp_39 = maxi_mac_arcache;

  always @(*) begin
    axi_s_ctrl_mac_arcache = _tmp_39;
  end

  wire [3-1:0] _tmp_40;
  assign _tmp_40 = maxi_mac_arprot;

  always @(*) begin
    axi_s_ctrl_mac_arprot = _tmp_40;
  end

  wire _tmp_41;
  assign _tmp_41 = maxi_mac_arvalid;

  always @(*) begin
    axi_s_ctrl_mac_arvalid = _tmp_41;
  end

  assign maxi_mac_arready = axi_s_ctrl_mac_arready;
  assign maxi_mac_rdata = axi_s_ctrl_mac_rdata;
  assign maxi_mac_rresp = axi_s_ctrl_mac_rresp;
  assign maxi_mac_rvalid = axi_s_ctrl_mac_rvalid;
  wire _tmp_42;
  assign _tmp_42 = maxi_mac_rready;

  always @(*) begin
    axi_s_ctrl_mac_rready = _tmp_42;
  end

  wire [128-1:0] _tmp_43;
  assign _tmp_43 = s_axis_mac_tdata;

  always @(*) begin
    axis_in_mac_tdata = _tmp_43;
  end

  wire _tmp_44;
  assign _tmp_44 = s_axis_mac_tvalid;

  always @(*) begin
    axis_in_mac_tvalid = _tmp_44;
  end

  assign s_axis_mac_tready = axis_in_mac_tready;
  wire _tmp_45;
  assign _tmp_45 = s_axis_mac_tlast;

  always @(*) begin
    axis_in_mac_tlast = _tmp_45;
  end

  reg [128-1:0] read_data_46;
  reg [32-1:0] th_ctrl;
  localparam th_ctrl_init = 0;
  reg signed [32-1:0] _th_ctrl_i_4;
  reg _s_axis_mac_cond_0_1;
  reg _maxi_mac_waddr_cond_0_1;
  reg _maxi_mac_wdata_cond_0_1;
  reg _maxi_mac_raddr_cond_0_1;
  reg signed [64-1:0] axim_rdata_47;
  reg _maxi_mac_waddr_cond_1_1;
  reg _maxi_mac_wdata_cond_1_1;
  reg _maxi_mac_waddr_cond_2_1;
  reg _maxi_mac_wdata_cond_2_1;
  reg _maxi_mac_waddr_cond_3_1;
  reg _maxi_mac_wdata_cond_3_1;
  reg _maxi_mac_raddr_cond_1_1;
  reg signed [64-1:0] axim_rdata_48;
  reg _s_axis_mac_cond_1_1;
  reg _maxi_mac_raddr_cond_2_1;
  reg signed [64-1:0] axim_rdata_49;
  reg _maxi_mac_waddr_cond_4_1;
  reg _maxi_mac_wdata_cond_4_1;
  reg _maxi_mac_waddr_cond_5_1;
  reg _maxi_mac_wdata_cond_5_1;
  reg _maxi_mac_waddr_cond_6_1;
  reg _maxi_mac_wdata_cond_6_1;
  reg _maxi_mac_raddr_cond_3_1;
  reg signed [64-1:0] axim_rdata_50;
  reg _maxi_mac_waddr_cond_7_1;
  reg _maxi_mac_wdata_cond_7_1;
  reg _maxi_mac_raddr_cond_4_1;
  reg signed [64-1:0] axim_rdata_51;
  reg _maxi_mac_raddr_cond_5_1;
  reg signed [64-1:0] axim_rdata_52;
  assign _maxi_mac_rready_sb_0 = (th_ctrl == 14) || (th_ctrl == 36) || (th_ctrl == 48) || (th_ctrl == 70) || (th_ctrl == 82) || (th_ctrl == 88);

  mac
  uut
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


  initial begin
    CLK = 0;
    forever begin
      #5 CLK = !CLK;
    end
  end


  initial begin
    RST = 0;
    maxi_mac_awaddr = 0;
    maxi_mac_awvalid = 0;
    _maxi_mac_wdata_sb_0 = 0;
    _maxi_mac_wstrb_sb_0 = 0;
    _maxi_mac_wvalid_sb_0 = 0;
    _sb_maxi_mac_writedata_data_5 = 0;
    _sb_maxi_mac_writedata_valid_6 = 0;
    _sb_maxi_mac_writedata_tmp_data_8 = 0;
    _sb_maxi_mac_writedata_tmp_valid_9 = 0;
    maxi_mac_araddr = 0;
    maxi_mac_arvalid = 0;
    _sb_maxi_mac_readdata_data_18 = 0;
    _sb_maxi_mac_readdata_valid_19 = 0;
    _sb_maxi_mac_readdata_tmp_data_21 = 0;
    _sb_maxi_mac_readdata_tmp_valid_22 = 0;
    _maxi_mac_outstanding_wcount = 0;
    s_axis_mac_tdata = 0;
    s_axis_mac_tvalid = 0;
    s_axis_mac_tlast = 0;
    count__s_axis_mac_write_req_fifo = 0;
    _s_axis_mac_write_op_sel_buf = 0;
    _s_axis_mac_write_local_addr_buf = 0;
    _s_axis_mac_write_local_stride_buf = 0;
    _s_axis_mac_write_size_buf = 0;
    _s_axis_mac_write_data_busy = 0;
    read_data_46 = 0;
    th_ctrl = th_ctrl_init;
    _th_ctrl_i_4 = 0;
    _s_axis_mac_cond_0_1 = 0;
    _maxi_mac_waddr_cond_0_1 = 0;
    _maxi_mac_wdata_cond_0_1 = 0;
    _maxi_mac_raddr_cond_0_1 = 0;
    axim_rdata_47 = 0;
    _maxi_mac_waddr_cond_1_1 = 0;
    _maxi_mac_wdata_cond_1_1 = 0;
    _maxi_mac_waddr_cond_2_1 = 0;
    _maxi_mac_wdata_cond_2_1 = 0;
    _maxi_mac_waddr_cond_3_1 = 0;
    _maxi_mac_wdata_cond_3_1 = 0;
    _maxi_mac_raddr_cond_1_1 = 0;
    axim_rdata_48 = 0;
    _s_axis_mac_cond_1_1 = 0;
    _maxi_mac_raddr_cond_2_1 = 0;
    axim_rdata_49 = 0;
    _maxi_mac_waddr_cond_4_1 = 0;
    _maxi_mac_wdata_cond_4_1 = 0;
    _maxi_mac_waddr_cond_5_1 = 0;
    _maxi_mac_wdata_cond_5_1 = 0;
    _maxi_mac_waddr_cond_6_1 = 0;
    _maxi_mac_wdata_cond_6_1 = 0;
    _maxi_mac_raddr_cond_3_1 = 0;
    axim_rdata_50 = 0;
    _maxi_mac_waddr_cond_7_1 = 0;
    _maxi_mac_wdata_cond_7_1 = 0;
    _maxi_mac_raddr_cond_4_1 = 0;
    axim_rdata_51 = 0;
    _maxi_mac_raddr_cond_5_1 = 0;
    axim_rdata_52 = 0;
    #100;
    RST = 1;
    #100;
    RST = 0;
    #1000000;
    $finish;
  end


  always @(posedge CLK) begin
    if(RST) begin
      maxi_mac_awaddr <= 0;
      maxi_mac_awvalid <= 0;
      _maxi_mac_waddr_cond_0_1 <= 0;
      _maxi_mac_waddr_cond_1_1 <= 0;
      _maxi_mac_waddr_cond_2_1 <= 0;
      _maxi_mac_waddr_cond_3_1 <= 0;
      _maxi_mac_waddr_cond_4_1 <= 0;
      _maxi_mac_waddr_cond_5_1 <= 0;
      _maxi_mac_waddr_cond_6_1 <= 0;
      _maxi_mac_waddr_cond_7_1 <= 0;
    end else begin
      if(_maxi_mac_waddr_cond_0_1) begin
        maxi_mac_awvalid <= 0;
      end 
      if(_maxi_mac_waddr_cond_1_1) begin
        maxi_mac_awvalid <= 0;
      end 
      if(_maxi_mac_waddr_cond_2_1) begin
        maxi_mac_awvalid <= 0;
      end 
      if(_maxi_mac_waddr_cond_3_1) begin
        maxi_mac_awvalid <= 0;
      end 
      if(_maxi_mac_waddr_cond_4_1) begin
        maxi_mac_awvalid <= 0;
      end 
      if(_maxi_mac_waddr_cond_5_1) begin
        maxi_mac_awvalid <= 0;
      end 
      if(_maxi_mac_waddr_cond_6_1) begin
        maxi_mac_awvalid <= 0;
      end 
      if(_maxi_mac_waddr_cond_7_1) begin
        maxi_mac_awvalid <= 0;
      end 
      if((th_ctrl == 6) && ((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid))) begin
        maxi_mac_awaddr <= 16;
        maxi_mac_awvalid <= 1;
      end 
      _maxi_mac_waddr_cond_0_1 <= 1;
      if(maxi_mac_awvalid && !maxi_mac_awready) begin
        maxi_mac_awvalid <= maxi_mac_awvalid;
      end 
      if((th_ctrl == 18) && ((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid))) begin
        maxi_mac_awaddr <= 32;
        maxi_mac_awvalid <= 1;
      end 
      _maxi_mac_waddr_cond_1_1 <= 1;
      if(maxi_mac_awvalid && !maxi_mac_awready) begin
        maxi_mac_awvalid <= maxi_mac_awvalid;
      end 
      if((th_ctrl == 23) && ((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid))) begin
        maxi_mac_awaddr <= 40;
        maxi_mac_awvalid <= 1;
      end 
      _maxi_mac_waddr_cond_2_1 <= 1;
      if(maxi_mac_awvalid && !maxi_mac_awready) begin
        maxi_mac_awvalid <= maxi_mac_awvalid;
      end 
      if((th_ctrl == 28) && ((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid))) begin
        maxi_mac_awaddr <= 16;
        maxi_mac_awvalid <= 1;
      end 
      _maxi_mac_waddr_cond_3_1 <= 1;
      if(maxi_mac_awvalid && !maxi_mac_awready) begin
        maxi_mac_awvalid <= maxi_mac_awvalid;
      end 
      if((th_ctrl == 52) && ((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid))) begin
        maxi_mac_awaddr <= 32;
        maxi_mac_awvalid <= 1;
      end 
      _maxi_mac_waddr_cond_4_1 <= 1;
      if(maxi_mac_awvalid && !maxi_mac_awready) begin
        maxi_mac_awvalid <= maxi_mac_awvalid;
      end 
      if((th_ctrl == 57) && ((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid))) begin
        maxi_mac_awaddr <= 40;
        maxi_mac_awvalid <= 1;
      end 
      _maxi_mac_waddr_cond_5_1 <= 1;
      if(maxi_mac_awvalid && !maxi_mac_awready) begin
        maxi_mac_awvalid <= maxi_mac_awvalid;
      end 
      if((th_ctrl == 62) && ((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid))) begin
        maxi_mac_awaddr <= 16;
        maxi_mac_awvalid <= 1;
      end 
      _maxi_mac_waddr_cond_6_1 <= 1;
      if(maxi_mac_awvalid && !maxi_mac_awready) begin
        maxi_mac_awvalid <= maxi_mac_awvalid;
      end 
      if((th_ctrl == 74) && ((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid))) begin
        maxi_mac_awaddr <= 16;
        maxi_mac_awvalid <= 1;
      end 
      _maxi_mac_waddr_cond_7_1 <= 1;
      if(maxi_mac_awvalid && !maxi_mac_awready) begin
        maxi_mac_awvalid <= maxi_mac_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _maxi_mac_wdata_sb_0 <= 0;
      _maxi_mac_wvalid_sb_0 <= 0;
      _maxi_mac_wstrb_sb_0 <= 0;
      _maxi_mac_wdata_cond_0_1 <= 0;
      _maxi_mac_wdata_cond_1_1 <= 0;
      _maxi_mac_wdata_cond_2_1 <= 0;
      _maxi_mac_wdata_cond_3_1 <= 0;
      _maxi_mac_wdata_cond_4_1 <= 0;
      _maxi_mac_wdata_cond_5_1 <= 0;
      _maxi_mac_wdata_cond_6_1 <= 0;
      _maxi_mac_wdata_cond_7_1 <= 0;
    end else begin
      if(_maxi_mac_wdata_cond_0_1) begin
        _maxi_mac_wvalid_sb_0 <= 0;
      end 
      if(_maxi_mac_wdata_cond_1_1) begin
        _maxi_mac_wvalid_sb_0 <= 0;
      end 
      if(_maxi_mac_wdata_cond_2_1) begin
        _maxi_mac_wvalid_sb_0 <= 0;
      end 
      if(_maxi_mac_wdata_cond_3_1) begin
        _maxi_mac_wvalid_sb_0 <= 0;
      end 
      if(_maxi_mac_wdata_cond_4_1) begin
        _maxi_mac_wvalid_sb_0 <= 0;
      end 
      if(_maxi_mac_wdata_cond_5_1) begin
        _maxi_mac_wvalid_sb_0 <= 0;
      end 
      if(_maxi_mac_wdata_cond_6_1) begin
        _maxi_mac_wvalid_sb_0 <= 0;
      end 
      if(_maxi_mac_wdata_cond_7_1) begin
        _maxi_mac_wvalid_sb_0 <= 0;
      end 
      if((th_ctrl == 8) && (_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0)) begin
        _maxi_mac_wdata_sb_0 <= 1;
        _maxi_mac_wvalid_sb_0 <= 1;
        _maxi_mac_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_mac_wdata_cond_0_1 <= 1;
      if(_maxi_mac_wvalid_sb_0 && !_maxi_mac_wready_sb_0) begin
        _maxi_mac_wvalid_sb_0 <= _maxi_mac_wvalid_sb_0;
      end 
      if((th_ctrl == 20) && (_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0)) begin
        _maxi_mac_wdata_sb_0 <= 0;
        _maxi_mac_wvalid_sb_0 <= 1;
        _maxi_mac_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_mac_wdata_cond_1_1 <= 1;
      if(_maxi_mac_wvalid_sb_0 && !_maxi_mac_wready_sb_0) begin
        _maxi_mac_wvalid_sb_0 <= _maxi_mac_wvalid_sb_0;
      end 
      if((th_ctrl == 25) && (_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0)) begin
        _maxi_mac_wdata_sb_0 <= 64;
        _maxi_mac_wvalid_sb_0 <= 1;
        _maxi_mac_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_mac_wdata_cond_2_1 <= 1;
      if(_maxi_mac_wvalid_sb_0 && !_maxi_mac_wready_sb_0) begin
        _maxi_mac_wvalid_sb_0 <= _maxi_mac_wvalid_sb_0;
      end 
      if((th_ctrl == 30) && (_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0)) begin
        _maxi_mac_wdata_sb_0 <= 2;
        _maxi_mac_wvalid_sb_0 <= 1;
        _maxi_mac_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_mac_wdata_cond_3_1 <= 1;
      if(_maxi_mac_wvalid_sb_0 && !_maxi_mac_wready_sb_0) begin
        _maxi_mac_wvalid_sb_0 <= _maxi_mac_wvalid_sb_0;
      end 
      if((th_ctrl == 54) && (_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0)) begin
        _maxi_mac_wdata_sb_0 <= 0;
        _maxi_mac_wvalid_sb_0 <= 1;
        _maxi_mac_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_mac_wdata_cond_4_1 <= 1;
      if(_maxi_mac_wvalid_sb_0 && !_maxi_mac_wready_sb_0) begin
        _maxi_mac_wvalid_sb_0 <= _maxi_mac_wvalid_sb_0;
      end 
      if((th_ctrl == 59) && (_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0)) begin
        _maxi_mac_wdata_sb_0 <= 7;
        _maxi_mac_wvalid_sb_0 <= 1;
        _maxi_mac_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_mac_wdata_cond_5_1 <= 1;
      if(_maxi_mac_wvalid_sb_0 && !_maxi_mac_wready_sb_0) begin
        _maxi_mac_wvalid_sb_0 <= _maxi_mac_wvalid_sb_0;
      end 
      if((th_ctrl == 64) && (_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0)) begin
        _maxi_mac_wdata_sb_0 <= 2;
        _maxi_mac_wvalid_sb_0 <= 1;
        _maxi_mac_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_mac_wdata_cond_6_1 <= 1;
      if(_maxi_mac_wvalid_sb_0 && !_maxi_mac_wready_sb_0) begin
        _maxi_mac_wvalid_sb_0 <= _maxi_mac_wvalid_sb_0;
      end 
      if((th_ctrl == 76) && (_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0)) begin
        _maxi_mac_wdata_sb_0 <= 4;
        _maxi_mac_wvalid_sb_0 <= 1;
        _maxi_mac_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_mac_wdata_cond_7_1 <= 1;
      if(_maxi_mac_wvalid_sb_0 && !_maxi_mac_wready_sb_0) begin
        _maxi_mac_wvalid_sb_0 <= _maxi_mac_wvalid_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_mac_writedata_data_5 <= 0;
      _sb_maxi_mac_writedata_valid_6 <= 0;
      _sb_maxi_mac_writedata_tmp_data_8 <= 0;
      _sb_maxi_mac_writedata_tmp_valid_9 <= 0;
    end else begin
      if(_sb_maxi_mac_writedata_m_ready_4 || !_sb_maxi_mac_writedata_valid_6) begin
        _sb_maxi_mac_writedata_data_5 <= _sb_maxi_mac_writedata_next_data_10;
        _sb_maxi_mac_writedata_valid_6 <= _sb_maxi_mac_writedata_next_valid_11;
      end 
      if(!_sb_maxi_mac_writedata_tmp_valid_9 && _sb_maxi_mac_writedata_valid_6 && !_sb_maxi_mac_writedata_m_ready_4) begin
        _sb_maxi_mac_writedata_tmp_data_8 <= _sb_maxi_mac_writedata_s_data_2;
        _sb_maxi_mac_writedata_tmp_valid_9 <= _sb_maxi_mac_writedata_s_valid_3;
      end 
      if(_sb_maxi_mac_writedata_tmp_valid_9 && _sb_maxi_mac_writedata_m_ready_4) begin
        _sb_maxi_mac_writedata_tmp_valid_9 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      maxi_mac_araddr <= 0;
      maxi_mac_arvalid <= 0;
      _maxi_mac_raddr_cond_0_1 <= 0;
      _maxi_mac_raddr_cond_1_1 <= 0;
      _maxi_mac_raddr_cond_2_1 <= 0;
      _maxi_mac_raddr_cond_3_1 <= 0;
      _maxi_mac_raddr_cond_4_1 <= 0;
      _maxi_mac_raddr_cond_5_1 <= 0;
    end else begin
      if(_maxi_mac_raddr_cond_0_1) begin
        maxi_mac_arvalid <= 0;
      end 
      if(_maxi_mac_raddr_cond_1_1) begin
        maxi_mac_arvalid <= 0;
      end 
      if(_maxi_mac_raddr_cond_2_1) begin
        maxi_mac_arvalid <= 0;
      end 
      if(_maxi_mac_raddr_cond_3_1) begin
        maxi_mac_arvalid <= 0;
      end 
      if(_maxi_mac_raddr_cond_4_1) begin
        maxi_mac_arvalid <= 0;
      end 
      if(_maxi_mac_raddr_cond_5_1) begin
        maxi_mac_arvalid <= 0;
      end 
      if((th_ctrl == 12) && (maxi_mac_arready || !maxi_mac_arvalid)) begin
        maxi_mac_araddr <= 24;
        maxi_mac_arvalid <= 1;
      end 
      _maxi_mac_raddr_cond_0_1 <= 1;
      if(maxi_mac_arvalid && !maxi_mac_arready) begin
        maxi_mac_arvalid <= maxi_mac_arvalid;
      end 
      if((th_ctrl == 34) && (maxi_mac_arready || !maxi_mac_arvalid)) begin
        maxi_mac_araddr <= 24;
        maxi_mac_arvalid <= 1;
      end 
      _maxi_mac_raddr_cond_1_1 <= 1;
      if(maxi_mac_arvalid && !maxi_mac_arready) begin
        maxi_mac_arvalid <= maxi_mac_arvalid;
      end 
      if((th_ctrl == 46) && (maxi_mac_arready || !maxi_mac_arvalid)) begin
        maxi_mac_araddr <= 24;
        maxi_mac_arvalid <= 1;
      end 
      _maxi_mac_raddr_cond_2_1 <= 1;
      if(maxi_mac_arvalid && !maxi_mac_arready) begin
        maxi_mac_arvalid <= maxi_mac_arvalid;
      end 
      if((th_ctrl == 68) && (maxi_mac_arready || !maxi_mac_arvalid)) begin
        maxi_mac_araddr <= 24;
        maxi_mac_arvalid <= 1;
      end 
      _maxi_mac_raddr_cond_3_1 <= 1;
      if(maxi_mac_arvalid && !maxi_mac_arready) begin
        maxi_mac_arvalid <= maxi_mac_arvalid;
      end 
      if((th_ctrl == 80) && (maxi_mac_arready || !maxi_mac_arvalid)) begin
        maxi_mac_araddr <= 24;
        maxi_mac_arvalid <= 1;
      end 
      _maxi_mac_raddr_cond_4_1 <= 1;
      if(maxi_mac_arvalid && !maxi_mac_arready) begin
        maxi_mac_arvalid <= maxi_mac_arvalid;
      end 
      if((th_ctrl == 86) && (maxi_mac_arready || !maxi_mac_arvalid)) begin
        maxi_mac_araddr <= 48;
        maxi_mac_arvalid <= 1;
      end 
      _maxi_mac_raddr_cond_5_1 <= 1;
      if(maxi_mac_arvalid && !maxi_mac_arready) begin
        maxi_mac_arvalid <= maxi_mac_arvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_mac_readdata_data_18 <= 0;
      _sb_maxi_mac_readdata_valid_19 <= 0;
      _sb_maxi_mac_readdata_tmp_data_21 <= 0;
      _sb_maxi_mac_readdata_tmp_valid_22 <= 0;
    end else begin
      if(_sb_maxi_mac_readdata_m_ready_17 || !_sb_maxi_mac_readdata_valid_19) begin
        _sb_maxi_mac_readdata_data_18 <= _sb_maxi_mac_readdata_next_data_23;
        _sb_maxi_mac_readdata_valid_19 <= _sb_maxi_mac_readdata_next_valid_24;
      end 
      if(!_sb_maxi_mac_readdata_tmp_valid_22 && _sb_maxi_mac_readdata_valid_19 && !_sb_maxi_mac_readdata_m_ready_17) begin
        _sb_maxi_mac_readdata_tmp_data_21 <= _sb_maxi_mac_readdata_s_data_15;
        _sb_maxi_mac_readdata_tmp_valid_22 <= _sb_maxi_mac_readdata_s_valid_16;
      end 
      if(_sb_maxi_mac_readdata_tmp_valid_22 && _sb_maxi_mac_readdata_m_ready_17) begin
        _sb_maxi_mac_readdata_tmp_valid_22 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _maxi_mac_outstanding_wcount <= 0;
    end else begin
      if(maxi_mac_awvalid && maxi_mac_awready && !(maxi_mac_bvalid && maxi_mac_bready) && (_maxi_mac_outstanding_wcount < 7)) begin
        _maxi_mac_outstanding_wcount <= _maxi_mac_outstanding_wcount + 1;
      end 
      if(!(maxi_mac_awvalid && maxi_mac_awready) && (maxi_mac_bvalid && maxi_mac_bready) && (_maxi_mac_outstanding_wcount > 0)) begin
        _maxi_mac_outstanding_wcount <= _maxi_mac_outstanding_wcount - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      s_axis_mac_tdata <= 0;
      s_axis_mac_tvalid <= 0;
      s_axis_mac_tlast <= 0;
      _s_axis_mac_cond_0_1 <= 0;
      _s_axis_mac_cond_1_1 <= 0;
    end else begin
      if(_s_axis_mac_cond_0_1) begin
        s_axis_mac_tvalid <= 0;
        s_axis_mac_tlast <= 0;
      end 
      if(_s_axis_mac_cond_1_1) begin
        s_axis_mac_tvalid <= 0;
        s_axis_mac_tlast <= 0;
      end 
      if((th_ctrl == 4) && (s_axis_mac_tready || !s_axis_mac_tvalid)) begin
        s_axis_mac_tdata <= _th_ctrl_i_4;
        s_axis_mac_tvalid <= 1;
        s_axis_mac_tlast <= _th_ctrl_i_4 == 3;
      end 
      _s_axis_mac_cond_0_1 <= 1;
      if(s_axis_mac_tvalid && !s_axis_mac_tready) begin
        s_axis_mac_tvalid <= s_axis_mac_tvalid;
        s_axis_mac_tlast <= s_axis_mac_tlast;
      end 
      if((th_ctrl == 43) && (s_axis_mac_tready || !s_axis_mac_tvalid)) begin
        s_axis_mac_tdata <= _th_ctrl_i_4 << 1;
        s_axis_mac_tvalid <= 1;
        s_axis_mac_tlast <= _th_ctrl_i_4 == 3;
      end 
      _s_axis_mac_cond_1_1 <= 1;
      if(s_axis_mac_tvalid && !s_axis_mac_tready) begin
        s_axis_mac_tvalid <= s_axis_mac_tvalid;
        s_axis_mac_tlast <= s_axis_mac_tlast;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _s_axis_mac_write_data_busy <= 0;
    end else begin
      if((th_ctrl == 3) && _s_axis_mac_write_idle) begin
        _s_axis_mac_write_data_busy <= 1;
      end 
      if((th_ctrl == 4) && (s_axis_mac_tready || !s_axis_mac_tvalid)) begin
        _s_axis_mac_write_data_busy <= 0;
      end 
      if((th_ctrl == 42) && _s_axis_mac_write_idle) begin
        _s_axis_mac_write_data_busy <= 1;
      end 
      if((th_ctrl == 43) && (s_axis_mac_tready || !s_axis_mac_tvalid)) begin
        _s_axis_mac_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__s_axis_mac_write_req_fifo <= 0;
    end else begin
      if(_s_axis_mac_write_req_fifo_enq && !_s_axis_mac_write_req_fifo_full && (_s_axis_mac_write_req_fifo_deq && !_s_axis_mac_write_req_fifo_empty)) begin
        count__s_axis_mac_write_req_fifo <= count__s_axis_mac_write_req_fifo;
      end else if(_s_axis_mac_write_req_fifo_enq && !_s_axis_mac_write_req_fifo_full) begin
        count__s_axis_mac_write_req_fifo <= count__s_axis_mac_write_req_fifo + 1;
      end else if(_s_axis_mac_write_req_fifo_deq && !_s_axis_mac_write_req_fifo_empty) begin
        count__s_axis_mac_write_req_fifo <= count__s_axis_mac_write_req_fifo - 1;
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

  always @(posedge CLK) begin
    if(RST) begin
      th_ctrl <= th_ctrl_init;
      _th_ctrl_i_4 <= 0;
      axim_rdata_47 <= 0;
      axim_rdata_48 <= 0;
      axim_rdata_49 <= 0;
      axim_rdata_50 <= 0;
      axim_rdata_51 <= 0;
      axim_rdata_52 <= 0;
    end else begin
      case(th_ctrl)
        th_ctrl_init: begin
          th_ctrl <= th_ctrl_1;
        end
        th_ctrl_1: begin
          _th_ctrl_i_4 <= 0;
          th_ctrl <= th_ctrl_2;
        end
        th_ctrl_2: begin
          if(_th_ctrl_i_4 < 4) begin
            th_ctrl <= th_ctrl_3;
          end else begin
            th_ctrl <= th_ctrl_6;
          end
        end
        th_ctrl_3: begin
          if(_s_axis_mac_write_idle) begin
            th_ctrl <= th_ctrl_4;
          end 
        end
        th_ctrl_4: begin
          if(s_axis_mac_tready || !s_axis_mac_tvalid) begin
            th_ctrl <= th_ctrl_5;
          end 
        end
        th_ctrl_5: begin
          _th_ctrl_i_4 <= _th_ctrl_i_4 + 1;
          th_ctrl <= th_ctrl_2;
        end
        th_ctrl_6: begin
          if((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid)) begin
            th_ctrl <= th_ctrl_7;
          end 
        end
        th_ctrl_7: begin
          if(maxi_mac_awvalid && maxi_mac_awready) begin
            th_ctrl <= th_ctrl_8;
          end 
        end
        th_ctrl_8: begin
          if(_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_9;
          end 
        end
        th_ctrl_9: begin
          if(_maxi_mac_wvalid_sb_0 && _maxi_mac_wready_sb_0) begin
            th_ctrl <= th_ctrl_10;
          end 
        end
        th_ctrl_10: begin
          if(!_maxi_mac_has_outstanding_write) begin
            th_ctrl <= th_ctrl_11;
          end 
        end
        th_ctrl_11: begin
          if(1) begin
            th_ctrl <= th_ctrl_12;
          end else begin
            th_ctrl <= th_ctrl_18;
          end
        end
        th_ctrl_12: begin
          if(maxi_mac_arready || !maxi_mac_arvalid) begin
            th_ctrl <= th_ctrl_13;
          end 
        end
        th_ctrl_13: begin
          if(maxi_mac_arvalid && maxi_mac_arready) begin
            th_ctrl <= th_ctrl_14;
          end 
        end
        th_ctrl_14: begin
          if(_maxi_mac_rvalid_sb_0) begin
            axim_rdata_47 <= _maxi_mac_rdata_sb_0;
          end 
          if(_maxi_mac_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_15;
          end 
        end
        th_ctrl_15: begin
          if(axim_rdata_47 == 0) begin
            th_ctrl <= th_ctrl_16;
          end else begin
            th_ctrl <= th_ctrl_17;
          end
        end
        th_ctrl_16: begin
          th_ctrl <= th_ctrl_18;
        end
        th_ctrl_17: begin
          th_ctrl <= th_ctrl_11;
        end
        th_ctrl_18: begin
          if((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid)) begin
            th_ctrl <= th_ctrl_19;
          end 
        end
        th_ctrl_19: begin
          if(maxi_mac_awvalid && maxi_mac_awready) begin
            th_ctrl <= th_ctrl_20;
          end 
        end
        th_ctrl_20: begin
          if(_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_21;
          end 
        end
        th_ctrl_21: begin
          if(_maxi_mac_wvalid_sb_0 && _maxi_mac_wready_sb_0) begin
            th_ctrl <= th_ctrl_22;
          end 
        end
        th_ctrl_22: begin
          if(!_maxi_mac_has_outstanding_write) begin
            th_ctrl <= th_ctrl_23;
          end 
        end
        th_ctrl_23: begin
          if((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid)) begin
            th_ctrl <= th_ctrl_24;
          end 
        end
        th_ctrl_24: begin
          if(maxi_mac_awvalid && maxi_mac_awready) begin
            th_ctrl <= th_ctrl_25;
          end 
        end
        th_ctrl_25: begin
          if(_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_26;
          end 
        end
        th_ctrl_26: begin
          if(_maxi_mac_wvalid_sb_0 && _maxi_mac_wready_sb_0) begin
            th_ctrl <= th_ctrl_27;
          end 
        end
        th_ctrl_27: begin
          if(!_maxi_mac_has_outstanding_write) begin
            th_ctrl <= th_ctrl_28;
          end 
        end
        th_ctrl_28: begin
          if((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid)) begin
            th_ctrl <= th_ctrl_29;
          end 
        end
        th_ctrl_29: begin
          if(maxi_mac_awvalid && maxi_mac_awready) begin
            th_ctrl <= th_ctrl_30;
          end 
        end
        th_ctrl_30: begin
          if(_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_31;
          end 
        end
        th_ctrl_31: begin
          if(_maxi_mac_wvalid_sb_0 && _maxi_mac_wready_sb_0) begin
            th_ctrl <= th_ctrl_32;
          end 
        end
        th_ctrl_32: begin
          if(!_maxi_mac_has_outstanding_write) begin
            th_ctrl <= th_ctrl_33;
          end 
        end
        th_ctrl_33: begin
          if(1) begin
            th_ctrl <= th_ctrl_34;
          end else begin
            th_ctrl <= th_ctrl_40;
          end
        end
        th_ctrl_34: begin
          if(maxi_mac_arready || !maxi_mac_arvalid) begin
            th_ctrl <= th_ctrl_35;
          end 
        end
        th_ctrl_35: begin
          if(maxi_mac_arvalid && maxi_mac_arready) begin
            th_ctrl <= th_ctrl_36;
          end 
        end
        th_ctrl_36: begin
          if(_maxi_mac_rvalid_sb_0) begin
            axim_rdata_48 <= _maxi_mac_rdata_sb_0;
          end 
          if(_maxi_mac_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_37;
          end 
        end
        th_ctrl_37: begin
          if(axim_rdata_48 == 0) begin
            th_ctrl <= th_ctrl_38;
          end else begin
            th_ctrl <= th_ctrl_39;
          end
        end
        th_ctrl_38: begin
          th_ctrl <= th_ctrl_40;
        end
        th_ctrl_39: begin
          th_ctrl <= th_ctrl_33;
        end
        th_ctrl_40: begin
          _th_ctrl_i_4 <= 0;
          th_ctrl <= th_ctrl_41;
        end
        th_ctrl_41: begin
          if(_th_ctrl_i_4 < 4) begin
            th_ctrl <= th_ctrl_42;
          end else begin
            th_ctrl <= th_ctrl_45;
          end
        end
        th_ctrl_42: begin
          if(_s_axis_mac_write_idle) begin
            th_ctrl <= th_ctrl_43;
          end 
        end
        th_ctrl_43: begin
          if(s_axis_mac_tready || !s_axis_mac_tvalid) begin
            th_ctrl <= th_ctrl_44;
          end 
        end
        th_ctrl_44: begin
          _th_ctrl_i_4 <= _th_ctrl_i_4 + 1;
          th_ctrl <= th_ctrl_41;
        end
        th_ctrl_45: begin
          if(1) begin
            th_ctrl <= th_ctrl_46;
          end else begin
            th_ctrl <= th_ctrl_52;
          end
        end
        th_ctrl_46: begin
          if(maxi_mac_arready || !maxi_mac_arvalid) begin
            th_ctrl <= th_ctrl_47;
          end 
        end
        th_ctrl_47: begin
          if(maxi_mac_arvalid && maxi_mac_arready) begin
            th_ctrl <= th_ctrl_48;
          end 
        end
        th_ctrl_48: begin
          if(_maxi_mac_rvalid_sb_0) begin
            axim_rdata_49 <= _maxi_mac_rdata_sb_0;
          end 
          if(_maxi_mac_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_49;
          end 
        end
        th_ctrl_49: begin
          if(axim_rdata_49 == 0) begin
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
          if((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid)) begin
            th_ctrl <= th_ctrl_53;
          end 
        end
        th_ctrl_53: begin
          if(maxi_mac_awvalid && maxi_mac_awready) begin
            th_ctrl <= th_ctrl_54;
          end 
        end
        th_ctrl_54: begin
          if(_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_55;
          end 
        end
        th_ctrl_55: begin
          if(_maxi_mac_wvalid_sb_0 && _maxi_mac_wready_sb_0) begin
            th_ctrl <= th_ctrl_56;
          end 
        end
        th_ctrl_56: begin
          if(!_maxi_mac_has_outstanding_write) begin
            th_ctrl <= th_ctrl_57;
          end 
        end
        th_ctrl_57: begin
          if((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid)) begin
            th_ctrl <= th_ctrl_58;
          end 
        end
        th_ctrl_58: begin
          if(maxi_mac_awvalid && maxi_mac_awready) begin
            th_ctrl <= th_ctrl_59;
          end 
        end
        th_ctrl_59: begin
          if(_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_60;
          end 
        end
        th_ctrl_60: begin
          if(_maxi_mac_wvalid_sb_0 && _maxi_mac_wready_sb_0) begin
            th_ctrl <= th_ctrl_61;
          end 
        end
        th_ctrl_61: begin
          if(!_maxi_mac_has_outstanding_write) begin
            th_ctrl <= th_ctrl_62;
          end 
        end
        th_ctrl_62: begin
          if((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid)) begin
            th_ctrl <= th_ctrl_63;
          end 
        end
        th_ctrl_63: begin
          if(maxi_mac_awvalid && maxi_mac_awready) begin
            th_ctrl <= th_ctrl_64;
          end 
        end
        th_ctrl_64: begin
          if(_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_65;
          end 
        end
        th_ctrl_65: begin
          if(_maxi_mac_wvalid_sb_0 && _maxi_mac_wready_sb_0) begin
            th_ctrl <= th_ctrl_66;
          end 
        end
        th_ctrl_66: begin
          if(!_maxi_mac_has_outstanding_write) begin
            th_ctrl <= th_ctrl_67;
          end 
        end
        th_ctrl_67: begin
          if(1) begin
            th_ctrl <= th_ctrl_68;
          end else begin
            th_ctrl <= th_ctrl_74;
          end
        end
        th_ctrl_68: begin
          if(maxi_mac_arready || !maxi_mac_arvalid) begin
            th_ctrl <= th_ctrl_69;
          end 
        end
        th_ctrl_69: begin
          if(maxi_mac_arvalid && maxi_mac_arready) begin
            th_ctrl <= th_ctrl_70;
          end 
        end
        th_ctrl_70: begin
          if(_maxi_mac_rvalid_sb_0) begin
            axim_rdata_50 <= _maxi_mac_rdata_sb_0;
          end 
          if(_maxi_mac_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_71;
          end 
        end
        th_ctrl_71: begin
          if(axim_rdata_50 == 0) begin
            th_ctrl <= th_ctrl_72;
          end else begin
            th_ctrl <= th_ctrl_73;
          end
        end
        th_ctrl_72: begin
          th_ctrl <= th_ctrl_74;
        end
        th_ctrl_73: begin
          th_ctrl <= th_ctrl_67;
        end
        th_ctrl_74: begin
          if((_maxi_mac_outstanding_wcount == 0) && (maxi_mac_awready || !maxi_mac_awvalid)) begin
            th_ctrl <= th_ctrl_75;
          end 
        end
        th_ctrl_75: begin
          if(maxi_mac_awvalid && maxi_mac_awready) begin
            th_ctrl <= th_ctrl_76;
          end 
        end
        th_ctrl_76: begin
          if(_maxi_mac_wready_sb_0 || !_maxi_mac_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_77;
          end 
        end
        th_ctrl_77: begin
          if(_maxi_mac_wvalid_sb_0 && _maxi_mac_wready_sb_0) begin
            th_ctrl <= th_ctrl_78;
          end 
        end
        th_ctrl_78: begin
          if(!_maxi_mac_has_outstanding_write) begin
            th_ctrl <= th_ctrl_79;
          end 
        end
        th_ctrl_79: begin
          if(1) begin
            th_ctrl <= th_ctrl_80;
          end else begin
            th_ctrl <= th_ctrl_86;
          end
        end
        th_ctrl_80: begin
          if(maxi_mac_arready || !maxi_mac_arvalid) begin
            th_ctrl <= th_ctrl_81;
          end 
        end
        th_ctrl_81: begin
          if(maxi_mac_arvalid && maxi_mac_arready) begin
            th_ctrl <= th_ctrl_82;
          end 
        end
        th_ctrl_82: begin
          if(_maxi_mac_rvalid_sb_0) begin
            axim_rdata_51 <= _maxi_mac_rdata_sb_0;
          end 
          if(_maxi_mac_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_83;
          end 
        end
        th_ctrl_83: begin
          if(axim_rdata_51 == 0) begin
            th_ctrl <= th_ctrl_84;
          end else begin
            th_ctrl <= th_ctrl_85;
          end
        end
        th_ctrl_84: begin
          th_ctrl <= th_ctrl_86;
        end
        th_ctrl_85: begin
          th_ctrl <= th_ctrl_79;
        end
        th_ctrl_86: begin
          if(maxi_mac_arready || !maxi_mac_arvalid) begin
            th_ctrl <= th_ctrl_87;
          end 
        end
        th_ctrl_87: begin
          if(maxi_mac_arvalid && maxi_mac_arready) begin
            th_ctrl <= th_ctrl_88;
          end 
        end
        th_ctrl_88: begin
          if(_maxi_mac_rvalid_sb_0) begin
            axim_rdata_52 <= _maxi_mac_rdata_sb_0;
          end 
          if(_maxi_mac_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_89;
          end 
        end
        th_ctrl_89: begin
          $display("MAC Result: %x", axim_rdata_52);
          th_ctrl <= th_ctrl_90;
        end
      endcase
    end
  end


endmodule



module _s_axis_mac_write_req_fifo
(
  input CLK,
  input RST,
  input _s_axis_mac_write_req_fifo_enq,
  input [105-1:0] _s_axis_mac_write_req_fifo_wdata,
  output _s_axis_mac_write_req_fifo_full,
  output _s_axis_mac_write_req_fifo_almost_full,
  input _s_axis_mac_write_req_fifo_deq,
  output [105-1:0] _s_axis_mac_write_req_fifo_rdata,
  output _s_axis_mac_write_req_fifo_empty,
  output _s_axis_mac_write_req_fifo_almost_empty
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
  assign _s_axis_mac_write_req_fifo_full = is_full;
  assign _s_axis_mac_write_req_fifo_almost_full = is_almost_full || is_full;
  assign _s_axis_mac_write_req_fifo_empty = is_empty;
  assign _s_axis_mac_write_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _s_axis_mac_write_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_s_axis_mac_write_req_fifo_enq && !is_full) begin
        mem[head] <= _s_axis_mac_write_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_s_axis_mac_write_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module mac
(
  input CLK,
  input RST,
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
  input [128-1:0] axis_in_mac_tdata,
  input axis_in_mac_tvalid,
  output axis_in_mac_tready,
  input axis_in_mac_tlast
);

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
  reg [32-1:0] addr_0;
  reg writevalid_1;
  reg readvalid_2;
  reg prev_awvalid_3;
  reg prev_arvalid_4;
  assign axi_s_ctrl_mac_awready = (_axi_s_ctrl_mac_register_fsm == 0) && (!writevalid_1 && !readvalid_2 && !axi_s_ctrl_mac_bvalid && prev_awvalid_3);
  assign axi_s_ctrl_mac_arready = (_axi_s_ctrl_mac_register_fsm == 0) && (!readvalid_2 && !writevalid_1 && prev_arvalid_4 && !prev_awvalid_3);
  reg [_axi_s_ctrl_mac_maskwidth-1:0] axis_maskaddr_5;
  wire signed [64-1:0] axislite_rdata_6;
  assign axislite_rdata_6 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_mac_register_0 : 
                            (axis_maskaddr_5 == 1)? _axi_s_ctrl_mac_register_1 : 
                            (axis_maskaddr_5 == 2)? _axi_s_ctrl_mac_register_2 : 
                            (axis_maskaddr_5 == 3)? _axi_s_ctrl_mac_register_3 : 
                            (axis_maskaddr_5 == 4)? _axi_s_ctrl_mac_register_4 : 
                            (axis_maskaddr_5 == 5)? _axi_s_ctrl_mac_register_5 : 
                            (axis_maskaddr_5 == 6)? _axi_s_ctrl_mac_register_6 : 'hx;
  wire axislite_flag_7;
  assign axislite_flag_7 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_mac_flag_0 : 
                           (axis_maskaddr_5 == 1)? _axi_s_ctrl_mac_flag_1 : 
                           (axis_maskaddr_5 == 2)? _axi_s_ctrl_mac_flag_2 : 
                           (axis_maskaddr_5 == 3)? _axi_s_ctrl_mac_flag_3 : 
                           (axis_maskaddr_5 == 4)? _axi_s_ctrl_mac_flag_4 : 
                           (axis_maskaddr_5 == 5)? _axi_s_ctrl_mac_flag_5 : 
                           (axis_maskaddr_5 == 6)? _axi_s_ctrl_mac_flag_6 : 'hx;
  wire signed [64-1:0] axislite_resetval_8;
  assign axislite_resetval_8 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_mac_resetval_0 : 
                               (axis_maskaddr_5 == 1)? _axi_s_ctrl_mac_resetval_1 : 
                               (axis_maskaddr_5 == 2)? _axi_s_ctrl_mac_resetval_2 : 
                               (axis_maskaddr_5 == 3)? _axi_s_ctrl_mac_resetval_3 : 
                               (axis_maskaddr_5 == 4)? _axi_s_ctrl_mac_resetval_4 : 
                               (axis_maskaddr_5 == 5)? _axi_s_ctrl_mac_resetval_5 : 
                               (axis_maskaddr_5 == 6)? _axi_s_ctrl_mac_resetval_6 : 'hx;
  reg _axi_s_ctrl_mac_rdata_cond_0_1;
  assign axi_s_ctrl_mac_wready = _axi_s_ctrl_mac_register_fsm == 3;
  wire _axis_in_mac_read_req_fifo_enq;
  wire [105-1:0] _axis_in_mac_read_req_fifo_wdata;
  wire _axis_in_mac_read_req_fifo_full;
  wire _axis_in_mac_read_req_fifo_almost_full;
  wire _axis_in_mac_read_req_fifo_deq;
  wire [105-1:0] _axis_in_mac_read_req_fifo_rdata;
  wire _axis_in_mac_read_req_fifo_empty;
  wire _axis_in_mac_read_req_fifo_almost_empty;
  assign _axis_in_mac_read_req_fifo_enq = 0;
  assign _axis_in_mac_read_req_fifo_wdata = 'hx;
  assign _axis_in_mac_read_req_fifo_deq = 0;

  _axis_in_mac_read_req_fifo
  inst__axis_in_mac_read_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axis_in_mac_read_req_fifo_enq(_axis_in_mac_read_req_fifo_enq),
    ._axis_in_mac_read_req_fifo_wdata(_axis_in_mac_read_req_fifo_wdata),
    ._axis_in_mac_read_req_fifo_full(_axis_in_mac_read_req_fifo_full),
    ._axis_in_mac_read_req_fifo_almost_full(_axis_in_mac_read_req_fifo_almost_full),
    ._axis_in_mac_read_req_fifo_deq(_axis_in_mac_read_req_fifo_deq),
    ._axis_in_mac_read_req_fifo_rdata(_axis_in_mac_read_req_fifo_rdata),
    ._axis_in_mac_read_req_fifo_empty(_axis_in_mac_read_req_fifo_empty),
    ._axis_in_mac_read_req_fifo_almost_empty(_axis_in_mac_read_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axis_in_mac_read_req_fifo;
  wire [8-1:0] _axis_in_mac_read_op_sel_fifo;
  wire [32-1:0] _axis_in_mac_read_local_addr_fifo;
  wire [32-1:0] _axis_in_mac_read_local_stride_fifo;
  wire [33-1:0] _axis_in_mac_read_local_size_fifo;
  wire [8-1:0] unpack_read_req_op_sel_9;
  wire [32-1:0] unpack_read_req_local_addr_10;
  wire [32-1:0] unpack_read_req_local_stride_11;
  wire [33-1:0] unpack_read_req_local_size_12;
  assign unpack_read_req_op_sel_9 = _axis_in_mac_read_req_fifo_rdata[104:97];
  assign unpack_read_req_local_addr_10 = _axis_in_mac_read_req_fifo_rdata[96:65];
  assign unpack_read_req_local_stride_11 = _axis_in_mac_read_req_fifo_rdata[64:33];
  assign unpack_read_req_local_size_12 = _axis_in_mac_read_req_fifo_rdata[32:0];
  assign _axis_in_mac_read_op_sel_fifo = unpack_read_req_op_sel_9;
  assign _axis_in_mac_read_local_addr_fifo = unpack_read_req_local_addr_10;
  assign _axis_in_mac_read_local_stride_fifo = unpack_read_req_local_stride_11;
  assign _axis_in_mac_read_local_size_fifo = unpack_read_req_local_size_12;
  reg [8-1:0] _axis_in_mac_read_op_sel_buf;
  reg [32-1:0] _axis_in_mac_read_local_addr_buf;
  reg [32-1:0] _axis_in_mac_read_local_stride_buf;
  reg [33-1:0] _axis_in_mac_read_local_size_buf;
  reg _axis_in_mac_read_data_busy;
  wire _axis_in_mac_read_data_idle;
  wire _axis_in_mac_read_idle;
  assign _axis_in_mac_read_data_idle = _axis_in_mac_read_req_fifo_empty && !_axis_in_mac_read_data_busy;
  assign _axis_in_mac_read_idle = _axis_in_mac_read_data_idle;
  reg [512-1:0] buffer_13;
  reg [64-1:0] mac_result_14;
  reg [128-1:0] data_15;
  reg [64-1:0] start_bit_16;
  reg [64-1:0] end_bit_17;
  reg [512-1:0] mask_18;
  reg [32-1:0] mac_buffer_thread;
  localparam mac_buffer_thread_init = 0;
  reg signed [32-1:0] _mac_buffer_thread_i_0;
  reg signed [128-1:0] axistreamin_tdata_19;
  reg axistreamin_tlast_20;
  assign axis_in_mac_tready = mac_buffer_thread == 5;
  reg signed [32-1:0] _mac_buffer_thread_last_1;
  reg [32-1:0] spm_thread;
  localparam spm_thread_init = 0;
  reg signed [32-1:0] _spm_thread_i_2;
  reg signed [32-1:0] _spm_thread_byte_3;

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
        axi_s_ctrl_mac_rdata <= axislite_rdata_6;
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
      prev_awvalid_3 <= 0;
      prev_arvalid_4 <= 0;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      addr_0 <= 0;
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
      prev_awvalid_3 <= axi_s_ctrl_mac_awvalid;
      prev_arvalid_4 <= axi_s_ctrl_mac_arvalid;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      if(axi_s_ctrl_mac_awready && axi_s_ctrl_mac_awvalid && !axi_s_ctrl_mac_bvalid) begin
        addr_0 <= axi_s_ctrl_mac_awaddr;
        writevalid_1 <= 1;
      end else if(axi_s_ctrl_mac_arready && axi_s_ctrl_mac_arvalid) begin
        addr_0 <= axi_s_ctrl_mac_araddr;
        readvalid_2 <= 1;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 0)) begin
        _axi_s_ctrl_mac_register_0 <= axislite_resetval_8;
        _axi_s_ctrl_mac_flag_0 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 1)) begin
        _axi_s_ctrl_mac_register_1 <= axislite_resetval_8;
        _axi_s_ctrl_mac_flag_1 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 2)) begin
        _axi_s_ctrl_mac_register_2 <= axislite_resetval_8;
        _axi_s_ctrl_mac_flag_2 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 3)) begin
        _axi_s_ctrl_mac_register_3 <= axislite_resetval_8;
        _axi_s_ctrl_mac_flag_3 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 4)) begin
        _axi_s_ctrl_mac_register_4 <= axislite_resetval_8;
        _axi_s_ctrl_mac_flag_4 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 5)) begin
        _axi_s_ctrl_mac_register_5 <= axislite_resetval_8;
        _axi_s_ctrl_mac_flag_5 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 1) && (axi_s_ctrl_mac_rready || !axi_s_ctrl_mac_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 6)) begin
        _axi_s_ctrl_mac_register_6 <= axislite_resetval_8;
        _axi_s_ctrl_mac_flag_6 <= 0;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_5 == 0)) begin
        _axi_s_ctrl_mac_register_0 <= axi_s_ctrl_mac_wdata;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_5 == 1)) begin
        _axi_s_ctrl_mac_register_1 <= axi_s_ctrl_mac_wdata;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_5 == 2)) begin
        _axi_s_ctrl_mac_register_2 <= axi_s_ctrl_mac_wdata;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_5 == 3)) begin
        _axi_s_ctrl_mac_register_3 <= axi_s_ctrl_mac_wdata;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_5 == 4)) begin
        _axi_s_ctrl_mac_register_4 <= axi_s_ctrl_mac_wdata;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_5 == 5)) begin
        _axi_s_ctrl_mac_register_5 <= axi_s_ctrl_mac_wdata;
      end 
      if((_axi_s_ctrl_mac_register_fsm == 3) && axi_s_ctrl_mac_wvalid && (axis_maskaddr_5 == 6)) begin
        _axi_s_ctrl_mac_register_6 <= axi_s_ctrl_mac_wdata;
      end 
      if((spm_thread == 6) && 0) begin
        _axi_s_ctrl_mac_register_0 <= 1;
        _axi_s_ctrl_mac_flag_0 <= 0;
      end 
      if((spm_thread == 6) && 0) begin
        _axi_s_ctrl_mac_register_1 <= 1;
        _axi_s_ctrl_mac_flag_1 <= 0;
      end 
      if((spm_thread == 6) && 0) begin
        _axi_s_ctrl_mac_register_2 <= 1;
        _axi_s_ctrl_mac_flag_2 <= 0;
      end 
      if((spm_thread == 6) && 1) begin
        _axi_s_ctrl_mac_register_3 <= 1;
        _axi_s_ctrl_mac_flag_3 <= 0;
      end 
      if((spm_thread == 6) && 0) begin
        _axi_s_ctrl_mac_register_4 <= 1;
        _axi_s_ctrl_mac_flag_4 <= 0;
      end 
      if((spm_thread == 6) && 0) begin
        _axi_s_ctrl_mac_register_5 <= 1;
        _axi_s_ctrl_mac_flag_5 <= 0;
      end 
      if((spm_thread == 6) && 0) begin
        _axi_s_ctrl_mac_register_6 <= 1;
        _axi_s_ctrl_mac_flag_6 <= 0;
      end 
      if((spm_thread == 21) && 0) begin
        _axi_s_ctrl_mac_register_0 <= mac_result_14;
        _axi_s_ctrl_mac_flag_0 <= 0;
      end 
      if((spm_thread == 21) && 0) begin
        _axi_s_ctrl_mac_register_1 <= mac_result_14;
        _axi_s_ctrl_mac_flag_1 <= 0;
      end 
      if((spm_thread == 21) && 0) begin
        _axi_s_ctrl_mac_register_2 <= mac_result_14;
        _axi_s_ctrl_mac_flag_2 <= 0;
      end 
      if((spm_thread == 21) && 0) begin
        _axi_s_ctrl_mac_register_3 <= mac_result_14;
        _axi_s_ctrl_mac_flag_3 <= 0;
      end 
      if((spm_thread == 21) && 0) begin
        _axi_s_ctrl_mac_register_4 <= mac_result_14;
        _axi_s_ctrl_mac_flag_4 <= 0;
      end 
      if((spm_thread == 21) && 0) begin
        _axi_s_ctrl_mac_register_5 <= mac_result_14;
        _axi_s_ctrl_mac_flag_5 <= 0;
      end 
      if((spm_thread == 21) && 1) begin
        _axi_s_ctrl_mac_register_6 <= mac_result_14;
        _axi_s_ctrl_mac_flag_6 <= 0;
      end 
      if((spm_thread == 22) && 0) begin
        _axi_s_ctrl_mac_register_0 <= 0;
        _axi_s_ctrl_mac_flag_0 <= 0;
      end 
      if((spm_thread == 22) && 0) begin
        _axi_s_ctrl_mac_register_1 <= 0;
        _axi_s_ctrl_mac_flag_1 <= 0;
      end 
      if((spm_thread == 22) && 1) begin
        _axi_s_ctrl_mac_register_2 <= 0;
        _axi_s_ctrl_mac_flag_2 <= 0;
      end 
      if((spm_thread == 22) && 0) begin
        _axi_s_ctrl_mac_register_3 <= 0;
        _axi_s_ctrl_mac_flag_3 <= 0;
      end 
      if((spm_thread == 22) && 0) begin
        _axi_s_ctrl_mac_register_4 <= 0;
        _axi_s_ctrl_mac_flag_4 <= 0;
      end 
      if((spm_thread == 22) && 0) begin
        _axi_s_ctrl_mac_register_5 <= 0;
        _axi_s_ctrl_mac_flag_5 <= 0;
      end 
      if((spm_thread == 22) && 0) begin
        _axi_s_ctrl_mac_register_6 <= 0;
        _axi_s_ctrl_mac_flag_6 <= 0;
      end 
      if((spm_thread == 23) && 0) begin
        _axi_s_ctrl_mac_register_0 <= 0;
        _axi_s_ctrl_mac_flag_0 <= 0;
      end 
      if((spm_thread == 23) && 0) begin
        _axi_s_ctrl_mac_register_1 <= 0;
        _axi_s_ctrl_mac_flag_1 <= 0;
      end 
      if((spm_thread == 23) && 0) begin
        _axi_s_ctrl_mac_register_2 <= 0;
        _axi_s_ctrl_mac_flag_2 <= 0;
      end 
      if((spm_thread == 23) && 1) begin
        _axi_s_ctrl_mac_register_3 <= 0;
        _axi_s_ctrl_mac_flag_3 <= 0;
      end 
      if((spm_thread == 23) && 0) begin
        _axi_s_ctrl_mac_register_4 <= 0;
        _axi_s_ctrl_mac_flag_4 <= 0;
      end 
      if((spm_thread == 23) && 0) begin
        _axi_s_ctrl_mac_register_5 <= 0;
        _axi_s_ctrl_mac_flag_5 <= 0;
      end 
      if((spm_thread == 23) && 0) begin
        _axi_s_ctrl_mac_register_6 <= 0;
        _axi_s_ctrl_mac_flag_6 <= 0;
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
      axis_maskaddr_5 <= 0;
    end else begin
      case(_axi_s_ctrl_mac_register_fsm)
        _axi_s_ctrl_mac_register_fsm_init: begin
          if(readvalid_2 || writevalid_1) begin
            axis_maskaddr_5 <= (addr_0 >> _axi_s_ctrl_mac_shift) & _axi_s_ctrl_mac_mask;
          end 
          if(readvalid_2) begin
            _axi_s_ctrl_mac_register_fsm <= _axi_s_ctrl_mac_register_fsm_1;
          end 
          if(writevalid_1) begin
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
      _axis_in_mac_read_data_busy <= 0;
    end else begin
      if((mac_buffer_thread == 4) && _axis_in_mac_read_idle) begin
        _axis_in_mac_read_data_busy <= 1;
      end 
      if((mac_buffer_thread == 5) && axis_in_mac_tvalid) begin
        _axis_in_mac_read_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_in_mac_read_req_fifo <= 0;
    end else begin
      if(_axis_in_mac_read_req_fifo_enq && !_axis_in_mac_read_req_fifo_full && (_axis_in_mac_read_req_fifo_deq && !_axis_in_mac_read_req_fifo_empty)) begin
        count__axis_in_mac_read_req_fifo <= count__axis_in_mac_read_req_fifo;
      end else if(_axis_in_mac_read_req_fifo_enq && !_axis_in_mac_read_req_fifo_full) begin
        count__axis_in_mac_read_req_fifo <= count__axis_in_mac_read_req_fifo + 1;
      end else if(_axis_in_mac_read_req_fifo_deq && !_axis_in_mac_read_req_fifo_empty) begin
        count__axis_in_mac_read_req_fifo <= count__axis_in_mac_read_req_fifo - 1;
      end 
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

  always @(posedge CLK) begin
    if(RST) begin
      mac_buffer_thread <= mac_buffer_thread_init;
      _mac_buffer_thread_i_0 <= 0;
      axistreamin_tdata_19 <= 0;
      axistreamin_tlast_20 <= 0;
      data_15 <= 0;
      _mac_buffer_thread_last_1 <= 0;
      mask_18 <= 0;
      buffer_13 <= 0;
    end else begin
      case(mac_buffer_thread)
        mac_buffer_thread_init: begin
          mac_buffer_thread <= mac_buffer_thread_1;
        end
        mac_buffer_thread_1: begin
          if(1) begin
            mac_buffer_thread <= mac_buffer_thread_2;
          end else begin
            mac_buffer_thread <= mac_buffer_thread_12;
          end
        end
        mac_buffer_thread_2: begin
          _mac_buffer_thread_i_0 <= 0;
          mac_buffer_thread <= mac_buffer_thread_3;
        end
        mac_buffer_thread_3: begin
          if(_mac_buffer_thread_i_0 < 4) begin
            mac_buffer_thread <= mac_buffer_thread_4;
          end else begin
            mac_buffer_thread <= mac_buffer_thread_11;
          end
        end
        mac_buffer_thread_4: begin
          if(_axis_in_mac_read_idle) begin
            mac_buffer_thread <= mac_buffer_thread_5;
          end 
        end
        mac_buffer_thread_5: begin
          if(axis_in_mac_tvalid) begin
            axistreamin_tdata_19 <= axis_in_mac_tdata;
          end 
          if(axis_in_mac_tvalid) begin
            axistreamin_tlast_20 <= axis_in_mac_tlast;
          end 
          if(axis_in_mac_tvalid) begin
            mac_buffer_thread <= mac_buffer_thread_6;
          end 
        end
        mac_buffer_thread_6: begin
          data_15 <= axistreamin_tdata_19;
          _mac_buffer_thread_last_1 <= axistreamin_tlast_20;
          mac_buffer_thread <= mac_buffer_thread_7;
        end
        mac_buffer_thread_7: begin
          mask_18 <= ~(512'd340282366920938463463374607431768211455 << (_mac_buffer_thread_i_0 << 7));
          mac_buffer_thread <= mac_buffer_thread_8;
        end
        mac_buffer_thread_8: begin
          // $display(" read: %x", data_15);
          mac_buffer_thread <= mac_buffer_thread_9;
        end
        mac_buffer_thread_9: begin
          buffer_13 <= buffer_13 & mask_18 | (data_15 << (_mac_buffer_thread_i_0 << 7));
          mac_buffer_thread <= mac_buffer_thread_10;
        end
        mac_buffer_thread_10: begin
          _mac_buffer_thread_i_0 <= _mac_buffer_thread_i_0 + 1;
          mac_buffer_thread <= mac_buffer_thread_3;
        end
        mac_buffer_thread_11: begin
          mac_buffer_thread <= mac_buffer_thread_1;
        end
      endcase
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

  always @(posedge CLK) begin
    if(RST) begin
      spm_thread <= spm_thread_init;
      mac_result_14 <= 0;
      start_bit_16 <= 0;
      end_bit_17 <= 0;
      _spm_thread_i_2 <= 0;
      _spm_thread_byte_3 <= 0;
    end else begin
      case(spm_thread)
        spm_thread_init: begin
          spm_thread <= spm_thread_1;
        end
        spm_thread_1: begin
          if(1) begin
            spm_thread <= spm_thread_2;
          end else begin
            spm_thread <= spm_thread_25;
          end
        end
        spm_thread_2: begin
          if(1) begin
            spm_thread <= spm_thread_3;
          end else begin
            spm_thread <= spm_thread_6;
          end
        end
        spm_thread_3: begin
          if(_axi_s_ctrl_mac_register_2 != 0) begin
            spm_thread <= spm_thread_4;
          end else begin
            spm_thread <= spm_thread_5;
          end
        end
        spm_thread_4: begin
          spm_thread <= spm_thread_6;
        end
        spm_thread_5: begin
          spm_thread <= spm_thread_2;
        end
        spm_thread_6: begin
          spm_thread <= spm_thread_7;
        end
        spm_thread_7: begin
          if(_axi_s_ctrl_mac_register_2 == 1) begin
            spm_thread <= spm_thread_8;
          end else begin
            spm_thread <= spm_thread_10;
          end
        end
        spm_thread_8: begin
          mac_result_14 <= 64'd14695981039346656037;
          spm_thread <= spm_thread_9;
        end
        spm_thread_9: begin
          spm_thread <= spm_thread_22;
        end
        spm_thread_10: begin
          if(_axi_s_ctrl_mac_register_2 == 2) begin
            spm_thread <= spm_thread_11;
          end else begin
            spm_thread <= spm_thread_21;
          end
        end
        spm_thread_11: begin
          start_bit_16 <= _axi_s_ctrl_mac_register_4;
          spm_thread <= spm_thread_12;
        end
        spm_thread_12: begin
          end_bit_17 <= _axi_s_ctrl_mac_register_5;
          spm_thread <= spm_thread_13;
        end
        spm_thread_13: begin
          // $display("buffer: %x", buffer_13);
          spm_thread <= spm_thread_14;
        end
        spm_thread_14: begin
          _spm_thread_i_2 <= start_bit_16 >>> 3;
          spm_thread <= spm_thread_15;
        end
        spm_thread_15: begin
          if(_spm_thread_i_2 < (end_bit_17 >>> 3) + 1) begin
            spm_thread <= spm_thread_16;
          end else begin
            spm_thread <= spm_thread_20;
          end
        end
        spm_thread_16: begin
          _spm_thread_byte_3 <= (buffer_13 >>> (_spm_thread_i_2 << 3)) & 255;
          spm_thread <= spm_thread_17;
        end
        spm_thread_17: begin
          mac_result_14 <= mac_result_14 ^ _spm_thread_byte_3;
          spm_thread <= spm_thread_18;
        end
        spm_thread_18: begin
          mac_result_14 <= mac_result_14 * 64'd1099511628211;
          spm_thread <= spm_thread_19;
        end
        spm_thread_19: begin
          _spm_thread_i_2 <= _spm_thread_i_2 + 1;
          spm_thread <= spm_thread_15;
        end
        spm_thread_20: begin
          spm_thread <= spm_thread_22;
        end
        spm_thread_21: begin
          spm_thread <= spm_thread_22;
        end
        spm_thread_22: begin
          spm_thread <= spm_thread_23;
        end
        spm_thread_23: begin
          spm_thread <= spm_thread_24;
        end
        spm_thread_24: begin
          spm_thread <= spm_thread_1;
        end
      endcase
    end
  end


endmodule



module _axis_in_mac_read_req_fifo
(
  input CLK,
  input RST,
  input _axis_in_mac_read_req_fifo_enq,
  input [105-1:0] _axis_in_mac_read_req_fifo_wdata,
  output _axis_in_mac_read_req_fifo_full,
  output _axis_in_mac_read_req_fifo_almost_full,
  input _axis_in_mac_read_req_fifo_deq,
  output [105-1:0] _axis_in_mac_read_req_fifo_rdata,
  output _axis_in_mac_read_req_fifo_empty,
  output _axis_in_mac_read_req_fifo_almost_empty
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
  assign _axis_in_mac_read_req_fifo_full = is_full;
  assign _axis_in_mac_read_req_fifo_almost_full = is_almost_full || is_full;
  assign _axis_in_mac_read_req_fifo_empty = is_empty;
  assign _axis_in_mac_read_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axis_in_mac_read_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axis_in_mac_read_req_fifo_enq && !is_full) begin
        mem[head] <= _axis_in_mac_read_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axis_in_mac_read_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule

