

module test_aes
(

);

  reg CLK;
  reg RST;
  reg [32-1:0] axi_s_ctrl_aes_awaddr;
  reg [4-1:0] axi_s_ctrl_aes_awcache;
  reg [3-1:0] axi_s_ctrl_aes_awprot;
  reg axi_s_ctrl_aes_awvalid;
  wire axi_s_ctrl_aes_awready;
  reg [64-1:0] axi_s_ctrl_aes_wdata;
  reg [8-1:0] axi_s_ctrl_aes_wstrb;
  reg axi_s_ctrl_aes_wvalid;
  wire axi_s_ctrl_aes_wready;
  wire [2-1:0] axi_s_ctrl_aes_bresp;
  wire axi_s_ctrl_aes_bvalid;
  reg axi_s_ctrl_aes_bready;
  reg [32-1:0] axi_s_ctrl_aes_araddr;
  reg [4-1:0] axi_s_ctrl_aes_arcache;
  reg [3-1:0] axi_s_ctrl_aes_arprot;
  reg axi_s_ctrl_aes_arvalid;
  wire axi_s_ctrl_aes_arready;
  wire [64-1:0] axi_s_ctrl_aes_rdata;
  wire [2-1:0] axi_s_ctrl_aes_rresp;
  wire axi_s_ctrl_aes_rvalid;
  reg axi_s_ctrl_aes_rready;
  wire [128-1:0] axis_out_aes_tdata;
  wire axis_out_aes_tvalid;
  reg axis_out_aes_tready;
  wire axis_out_aes_tlast;
  reg [32-1:0] maxi_aes_awaddr;
  wire [4-1:0] maxi_aes_awcache;
  wire [3-1:0] maxi_aes_awprot;
  reg maxi_aes_awvalid;
  wire maxi_aes_awready;
  assign maxi_aes_awcache = 3;
  assign maxi_aes_awprot = 0;
  wire [64-1:0] maxi_aes_wdata;
  wire [8-1:0] maxi_aes_wstrb;
  wire maxi_aes_wvalid;
  wire maxi_aes_wready;
  reg [64-1:0] _maxi_aes_wdata_sb_0;
  reg [8-1:0] _maxi_aes_wstrb_sb_0;
  reg _maxi_aes_wvalid_sb_0;
  wire _maxi_aes_wready_sb_0;
  wire [8-1:0] _sb_maxi_aes_writedata_s_value_0;
  assign _sb_maxi_aes_writedata_s_value_0 = _maxi_aes_wstrb_sb_0;
  wire [64-1:0] _sb_maxi_aes_writedata_s_value_1;
  assign _sb_maxi_aes_writedata_s_value_1 = _maxi_aes_wdata_sb_0;
  wire [72-1:0] _sb_maxi_aes_writedata_s_data_2;
  assign _sb_maxi_aes_writedata_s_data_2 = { _sb_maxi_aes_writedata_s_value_0, _sb_maxi_aes_writedata_s_value_1 };
  wire _sb_maxi_aes_writedata_s_valid_3;
  assign _sb_maxi_aes_writedata_s_valid_3 = _maxi_aes_wvalid_sb_0;
  wire _sb_maxi_aes_writedata_m_ready_4;
  assign _sb_maxi_aes_writedata_m_ready_4 = maxi_aes_wready;
  reg [72-1:0] _sb_maxi_aes_writedata_data_5;
  reg _sb_maxi_aes_writedata_valid_6;
  wire _sb_maxi_aes_writedata_ready_7;
  reg [72-1:0] _sb_maxi_aes_writedata_tmp_data_8;
  reg _sb_maxi_aes_writedata_tmp_valid_9;
  wire [72-1:0] _sb_maxi_aes_writedata_next_data_10;
  wire _sb_maxi_aes_writedata_next_valid_11;
  assign _sb_maxi_aes_writedata_ready_7 = !_sb_maxi_aes_writedata_tmp_valid_9;
  assign _sb_maxi_aes_writedata_next_data_10 = (_sb_maxi_aes_writedata_tmp_valid_9)? _sb_maxi_aes_writedata_tmp_data_8 : _sb_maxi_aes_writedata_s_data_2;
  assign _sb_maxi_aes_writedata_next_valid_11 = _sb_maxi_aes_writedata_tmp_valid_9 || _sb_maxi_aes_writedata_s_valid_3;
  wire [8-1:0] _sb_maxi_aes_writedata_m_value_12;
  assign _sb_maxi_aes_writedata_m_value_12 = _sb_maxi_aes_writedata_data_5[71:64];
  wire [64-1:0] _sb_maxi_aes_writedata_m_value_13;
  assign _sb_maxi_aes_writedata_m_value_13 = _sb_maxi_aes_writedata_data_5[63:0];
  assign _maxi_aes_wready_sb_0 = _sb_maxi_aes_writedata_ready_7;
  assign maxi_aes_wdata = _sb_maxi_aes_writedata_m_value_13;
  assign maxi_aes_wstrb = _sb_maxi_aes_writedata_m_value_12;
  assign maxi_aes_wvalid = _sb_maxi_aes_writedata_valid_6;
  wire [2-1:0] maxi_aes_bresp;
  wire maxi_aes_bvalid;
  wire maxi_aes_bready;
  assign maxi_aes_bready = 1;
  reg [32-1:0] maxi_aes_araddr;
  wire [4-1:0] maxi_aes_arcache;
  wire [3-1:0] maxi_aes_arprot;
  reg maxi_aes_arvalid;
  wire maxi_aes_arready;
  assign maxi_aes_arcache = 3;
  assign maxi_aes_arprot = 0;
  wire [64-1:0] maxi_aes_rdata;
  wire [2-1:0] maxi_aes_rresp;
  wire maxi_aes_rvalid;
  wire maxi_aes_rready;
  wire [64-1:0] _maxi_aes_rdata_sb_0;
  wire _maxi_aes_rvalid_sb_0;
  wire _maxi_aes_rready_sb_0;
  wire [64-1:0] _sb_maxi_aes_readdata_s_value_14;
  assign _sb_maxi_aes_readdata_s_value_14 = maxi_aes_rdata;
  wire [64-1:0] _sb_maxi_aes_readdata_s_data_15;
  assign _sb_maxi_aes_readdata_s_data_15 = { _sb_maxi_aes_readdata_s_value_14 };
  wire _sb_maxi_aes_readdata_s_valid_16;
  assign _sb_maxi_aes_readdata_s_valid_16 = maxi_aes_rvalid;
  wire _sb_maxi_aes_readdata_m_ready_17;
  assign _sb_maxi_aes_readdata_m_ready_17 = _maxi_aes_rready_sb_0;
  reg [64-1:0] _sb_maxi_aes_readdata_data_18;
  reg _sb_maxi_aes_readdata_valid_19;
  wire _sb_maxi_aes_readdata_ready_20;
  reg [64-1:0] _sb_maxi_aes_readdata_tmp_data_21;
  reg _sb_maxi_aes_readdata_tmp_valid_22;
  wire [64-1:0] _sb_maxi_aes_readdata_next_data_23;
  wire _sb_maxi_aes_readdata_next_valid_24;
  assign _sb_maxi_aes_readdata_ready_20 = !_sb_maxi_aes_readdata_tmp_valid_22;
  assign _sb_maxi_aes_readdata_next_data_23 = (_sb_maxi_aes_readdata_tmp_valid_22)? _sb_maxi_aes_readdata_tmp_data_21 : _sb_maxi_aes_readdata_s_data_15;
  assign _sb_maxi_aes_readdata_next_valid_24 = _sb_maxi_aes_readdata_tmp_valid_22 || _sb_maxi_aes_readdata_s_valid_16;
  wire [64-1:0] _sb_maxi_aes_readdata_m_value_25;
  assign _sb_maxi_aes_readdata_m_value_25 = _sb_maxi_aes_readdata_data_18[63:0];
  assign _maxi_aes_rdata_sb_0 = _sb_maxi_aes_readdata_m_value_25;
  assign _maxi_aes_rvalid_sb_0 = _sb_maxi_aes_readdata_valid_19;
  assign maxi_aes_rready = _sb_maxi_aes_readdata_ready_20;
  reg [3-1:0] _maxi_aes_outstanding_wcount;
  wire _maxi_aes_has_outstanding_write;
  assign _maxi_aes_has_outstanding_write = (_maxi_aes_outstanding_wcount > 0) || maxi_aes_awvalid;
  wire [128-1:0] s_axis_aes_tdata;
  wire s_axis_aes_tvalid;
  wire s_axis_aes_tready;
  wire s_axis_aes_tlast;
  wire _s_axis_aes_read_req_fifo_enq;
  wire [105-1:0] _s_axis_aes_read_req_fifo_wdata;
  wire _s_axis_aes_read_req_fifo_full;
  wire _s_axis_aes_read_req_fifo_almost_full;
  wire _s_axis_aes_read_req_fifo_deq;
  wire [105-1:0] _s_axis_aes_read_req_fifo_rdata;
  wire _s_axis_aes_read_req_fifo_empty;
  wire _s_axis_aes_read_req_fifo_almost_empty;
  assign _s_axis_aes_read_req_fifo_enq = 0;
  assign _s_axis_aes_read_req_fifo_wdata = 'hx;
  assign _s_axis_aes_read_req_fifo_deq = 0;

  _s_axis_aes_read_req_fifo
  inst__s_axis_aes_read_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._s_axis_aes_read_req_fifo_enq(_s_axis_aes_read_req_fifo_enq),
    ._s_axis_aes_read_req_fifo_wdata(_s_axis_aes_read_req_fifo_wdata),
    ._s_axis_aes_read_req_fifo_full(_s_axis_aes_read_req_fifo_full),
    ._s_axis_aes_read_req_fifo_almost_full(_s_axis_aes_read_req_fifo_almost_full),
    ._s_axis_aes_read_req_fifo_deq(_s_axis_aes_read_req_fifo_deq),
    ._s_axis_aes_read_req_fifo_rdata(_s_axis_aes_read_req_fifo_rdata),
    ._s_axis_aes_read_req_fifo_empty(_s_axis_aes_read_req_fifo_empty),
    ._s_axis_aes_read_req_fifo_almost_empty(_s_axis_aes_read_req_fifo_almost_empty)
  );

  reg [4-1:0] count__s_axis_aes_read_req_fifo;
  wire [8-1:0] _s_axis_aes_read_op_sel_fifo;
  wire [32-1:0] _s_axis_aes_read_local_addr_fifo;
  wire [32-1:0] _s_axis_aes_read_local_stride_fifo;
  wire [33-1:0] _s_axis_aes_read_local_size_fifo;
  wire [8-1:0] unpack_read_req_op_sel_26;
  wire [32-1:0] unpack_read_req_local_addr_27;
  wire [32-1:0] unpack_read_req_local_stride_28;
  wire [33-1:0] unpack_read_req_local_size_29;
  assign unpack_read_req_op_sel_26 = _s_axis_aes_read_req_fifo_rdata[104:97];
  assign unpack_read_req_local_addr_27 = _s_axis_aes_read_req_fifo_rdata[96:65];
  assign unpack_read_req_local_stride_28 = _s_axis_aes_read_req_fifo_rdata[64:33];
  assign unpack_read_req_local_size_29 = _s_axis_aes_read_req_fifo_rdata[32:0];
  assign _s_axis_aes_read_op_sel_fifo = unpack_read_req_op_sel_26;
  assign _s_axis_aes_read_local_addr_fifo = unpack_read_req_local_addr_27;
  assign _s_axis_aes_read_local_stride_fifo = unpack_read_req_local_stride_28;
  assign _s_axis_aes_read_local_size_fifo = unpack_read_req_local_size_29;
  reg [8-1:0] _s_axis_aes_read_op_sel_buf;
  reg [32-1:0] _s_axis_aes_read_local_addr_buf;
  reg [32-1:0] _s_axis_aes_read_local_stride_buf;
  reg [33-1:0] _s_axis_aes_read_local_size_buf;
  reg _s_axis_aes_read_data_busy;
  wire _s_axis_aes_read_data_idle;
  wire _s_axis_aes_read_idle;
  assign _s_axis_aes_read_data_idle = _s_axis_aes_read_req_fifo_empty && !_s_axis_aes_read_data_busy;
  assign _s_axis_aes_read_idle = _s_axis_aes_read_data_idle;
  wire [32-1:0] _tmp_30;
  assign _tmp_30 = maxi_aes_awaddr;

  always @(*) begin
    axi_s_ctrl_aes_awaddr = _tmp_30;
  end

  wire [4-1:0] _tmp_31;
  assign _tmp_31 = maxi_aes_awcache;

  always @(*) begin
    axi_s_ctrl_aes_awcache = _tmp_31;
  end

  wire [3-1:0] _tmp_32;
  assign _tmp_32 = maxi_aes_awprot;

  always @(*) begin
    axi_s_ctrl_aes_awprot = _tmp_32;
  end

  wire _tmp_33;
  assign _tmp_33 = maxi_aes_awvalid;

  always @(*) begin
    axi_s_ctrl_aes_awvalid = _tmp_33;
  end

  assign maxi_aes_awready = axi_s_ctrl_aes_awready;
  wire [64-1:0] _tmp_34;
  assign _tmp_34 = maxi_aes_wdata;

  always @(*) begin
    axi_s_ctrl_aes_wdata = _tmp_34;
  end

  wire [8-1:0] _tmp_35;
  assign _tmp_35 = maxi_aes_wstrb;

  always @(*) begin
    axi_s_ctrl_aes_wstrb = _tmp_35;
  end

  wire _tmp_36;
  assign _tmp_36 = maxi_aes_wvalid;

  always @(*) begin
    axi_s_ctrl_aes_wvalid = _tmp_36;
  end

  assign maxi_aes_wready = axi_s_ctrl_aes_wready;
  assign maxi_aes_bresp = axi_s_ctrl_aes_bresp;
  assign maxi_aes_bvalid = axi_s_ctrl_aes_bvalid;
  wire _tmp_37;
  assign _tmp_37 = maxi_aes_bready;

  always @(*) begin
    axi_s_ctrl_aes_bready = _tmp_37;
  end

  wire [32-1:0] _tmp_38;
  assign _tmp_38 = maxi_aes_araddr;

  always @(*) begin
    axi_s_ctrl_aes_araddr = _tmp_38;
  end

  wire [4-1:0] _tmp_39;
  assign _tmp_39 = maxi_aes_arcache;

  always @(*) begin
    axi_s_ctrl_aes_arcache = _tmp_39;
  end

  wire [3-1:0] _tmp_40;
  assign _tmp_40 = maxi_aes_arprot;

  always @(*) begin
    axi_s_ctrl_aes_arprot = _tmp_40;
  end

  wire _tmp_41;
  assign _tmp_41 = maxi_aes_arvalid;

  always @(*) begin
    axi_s_ctrl_aes_arvalid = _tmp_41;
  end

  assign maxi_aes_arready = axi_s_ctrl_aes_arready;
  assign maxi_aes_rdata = axi_s_ctrl_aes_rdata;
  assign maxi_aes_rresp = axi_s_ctrl_aes_rresp;
  assign maxi_aes_rvalid = axi_s_ctrl_aes_rvalid;
  wire _tmp_42;
  assign _tmp_42 = maxi_aes_rready;

  always @(*) begin
    axi_s_ctrl_aes_rready = _tmp_42;
  end

  assign s_axis_aes_tdata = axis_out_aes_tdata;
  assign s_axis_aes_tvalid = axis_out_aes_tvalid;
  wire _tmp_43;
  assign _tmp_43 = s_axis_aes_tready;

  always @(*) begin
    axis_out_aes_tready = _tmp_43;
  end

  assign s_axis_aes_tlast = axis_out_aes_tlast;
  reg [128-1:0] read_data_44;
  reg [32-1:0] th_ctrl;
  localparam th_ctrl_init = 0;
  reg signed [32-1:0] _th_ctrl_i_1;
  reg _maxi_aes_waddr_cond_0_1;
  reg _maxi_aes_wdata_cond_0_1;
  reg _maxi_aes_waddr_cond_1_1;
  reg _maxi_aes_wdata_cond_1_1;
  reg signed [128-1:0] axistreamin_tdata_45;
  reg axistreamin_tlast_46;
  reg signed [32-1:0] _th_ctrl_last_2;
  reg _maxi_aes_raddr_cond_0_1;
  reg signed [64-1:0] axim_rdata_47;
  reg signed [32-1:0] _th_ctrl_v_3;
  reg _maxi_aes_waddr_cond_2_1;
  reg _maxi_aes_wdata_cond_2_1;
  reg _maxi_aes_waddr_cond_3_1;
  reg _maxi_aes_wdata_cond_3_1;
  reg signed [128-1:0] axistreamin_tdata_48;
  reg axistreamin_tlast_49;
  assign s_axis_aes_tready = (th_ctrl == 17) || (th_ctrl == 44);
  reg _maxi_aes_raddr_cond_1_1;
  reg signed [64-1:0] axim_rdata_50;
  assign _maxi_aes_rready_sb_0 = (th_ctrl == 23) || (th_ctrl == 50);

  aes
  uut
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
    .axis_out_aes_tdata(axis_out_aes_tdata),
    .axis_out_aes_tvalid(axis_out_aes_tvalid),
    .axis_out_aes_tready(axis_out_aes_tready),
    .axis_out_aes_tlast(axis_out_aes_tlast)
  );


  initial begin
    CLK = 0;
    forever begin
      #5 CLK = !CLK;
    end
  end


  initial begin
    RST = 0;
    maxi_aes_awaddr = 0;
    maxi_aes_awvalid = 0;
    _maxi_aes_wdata_sb_0 = 0;
    _maxi_aes_wstrb_sb_0 = 0;
    _maxi_aes_wvalid_sb_0 = 0;
    _sb_maxi_aes_writedata_data_5 = 0;
    _sb_maxi_aes_writedata_valid_6 = 0;
    _sb_maxi_aes_writedata_tmp_data_8 = 0;
    _sb_maxi_aes_writedata_tmp_valid_9 = 0;
    maxi_aes_araddr = 0;
    maxi_aes_arvalid = 0;
    _sb_maxi_aes_readdata_data_18 = 0;
    _sb_maxi_aes_readdata_valid_19 = 0;
    _sb_maxi_aes_readdata_tmp_data_21 = 0;
    _sb_maxi_aes_readdata_tmp_valid_22 = 0;
    _maxi_aes_outstanding_wcount = 0;
    count__s_axis_aes_read_req_fifo = 0;
    _s_axis_aes_read_op_sel_buf = 0;
    _s_axis_aes_read_local_addr_buf = 0;
    _s_axis_aes_read_local_stride_buf = 0;
    _s_axis_aes_read_local_size_buf = 0;
    _s_axis_aes_read_data_busy = 0;
    read_data_44 = 0;
    th_ctrl = th_ctrl_init;
    _th_ctrl_i_1 = 0;
    _maxi_aes_waddr_cond_0_1 = 0;
    _maxi_aes_wdata_cond_0_1 = 0;
    _maxi_aes_waddr_cond_1_1 = 0;
    _maxi_aes_wdata_cond_1_1 = 0;
    axistreamin_tdata_45 = 0;
    axistreamin_tlast_46 = 0;
    _th_ctrl_last_2 = 0;
    _maxi_aes_raddr_cond_0_1 = 0;
    axim_rdata_47 = 0;
    _th_ctrl_v_3 = 0;
    _maxi_aes_waddr_cond_2_1 = 0;
    _maxi_aes_wdata_cond_2_1 = 0;
    _maxi_aes_waddr_cond_3_1 = 0;
    _maxi_aes_wdata_cond_3_1 = 0;
    axistreamin_tdata_48 = 0;
    axistreamin_tlast_49 = 0;
    _maxi_aes_raddr_cond_1_1 = 0;
    axim_rdata_50 = 0;
    #100;
    RST = 1;
    #100;
    RST = 0;
    #1000000;
    $finish;
  end


  always @(posedge CLK) begin
    if(RST) begin
      maxi_aes_awaddr <= 0;
      maxi_aes_awvalid <= 0;
      _maxi_aes_waddr_cond_0_1 <= 0;
      _maxi_aes_waddr_cond_1_1 <= 0;
      _maxi_aes_waddr_cond_2_1 <= 0;
      _maxi_aes_waddr_cond_3_1 <= 0;
    end else begin
      if(_maxi_aes_waddr_cond_0_1) begin
        maxi_aes_awvalid <= 0;
      end 
      if(_maxi_aes_waddr_cond_1_1) begin
        maxi_aes_awvalid <= 0;
      end 
      if(_maxi_aes_waddr_cond_2_1) begin
        maxi_aes_awvalid <= 0;
      end 
      if(_maxi_aes_waddr_cond_3_1) begin
        maxi_aes_awvalid <= 0;
      end 
      if((th_ctrl == 3) && ((_maxi_aes_outstanding_wcount == 0) && (maxi_aes_awready || !maxi_aes_awvalid))) begin
        maxi_aes_awaddr <= _th_ctrl_i_1 << 3;
        maxi_aes_awvalid <= 1;
      end 
      _maxi_aes_waddr_cond_0_1 <= 1;
      if(maxi_aes_awvalid && !maxi_aes_awready) begin
        maxi_aes_awvalid <= maxi_aes_awvalid;
      end 
      if((th_ctrl == 9) && ((_maxi_aes_outstanding_wcount == 0) && (maxi_aes_awready || !maxi_aes_awvalid))) begin
        maxi_aes_awaddr <= 64;
        maxi_aes_awvalid <= 1;
      end 
      _maxi_aes_waddr_cond_1_1 <= 1;
      if(maxi_aes_awvalid && !maxi_aes_awready) begin
        maxi_aes_awvalid <= maxi_aes_awvalid;
      end 
      if((th_ctrl == 30) && ((_maxi_aes_outstanding_wcount == 0) && (maxi_aes_awready || !maxi_aes_awvalid))) begin
        maxi_aes_awaddr <= _th_ctrl_i_1 << 3;
        maxi_aes_awvalid <= 1;
      end 
      _maxi_aes_waddr_cond_2_1 <= 1;
      if(maxi_aes_awvalid && !maxi_aes_awready) begin
        maxi_aes_awvalid <= maxi_aes_awvalid;
      end 
      if((th_ctrl == 36) && ((_maxi_aes_outstanding_wcount == 0) && (maxi_aes_awready || !maxi_aes_awvalid))) begin
        maxi_aes_awaddr <= 64;
        maxi_aes_awvalid <= 1;
      end 
      _maxi_aes_waddr_cond_3_1 <= 1;
      if(maxi_aes_awvalid && !maxi_aes_awready) begin
        maxi_aes_awvalid <= maxi_aes_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _maxi_aes_wdata_sb_0 <= 0;
      _maxi_aes_wvalid_sb_0 <= 0;
      _maxi_aes_wstrb_sb_0 <= 0;
      _maxi_aes_wdata_cond_0_1 <= 0;
      _maxi_aes_wdata_cond_1_1 <= 0;
      _maxi_aes_wdata_cond_2_1 <= 0;
      _maxi_aes_wdata_cond_3_1 <= 0;
    end else begin
      if(_maxi_aes_wdata_cond_0_1) begin
        _maxi_aes_wvalid_sb_0 <= 0;
      end 
      if(_maxi_aes_wdata_cond_1_1) begin
        _maxi_aes_wvalid_sb_0 <= 0;
      end 
      if(_maxi_aes_wdata_cond_2_1) begin
        _maxi_aes_wvalid_sb_0 <= 0;
      end 
      if(_maxi_aes_wdata_cond_3_1) begin
        _maxi_aes_wvalid_sb_0 <= 0;
      end 
      if((th_ctrl == 5) && (_maxi_aes_wready_sb_0 || !_maxi_aes_wvalid_sb_0)) begin
        _maxi_aes_wdata_sb_0 <= _th_ctrl_i_1;
        _maxi_aes_wvalid_sb_0 <= 1;
        _maxi_aes_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_aes_wdata_cond_0_1 <= 1;
      if(_maxi_aes_wvalid_sb_0 && !_maxi_aes_wready_sb_0) begin
        _maxi_aes_wvalid_sb_0 <= _maxi_aes_wvalid_sb_0;
      end 
      if((th_ctrl == 11) && (_maxi_aes_wready_sb_0 || !_maxi_aes_wvalid_sb_0)) begin
        _maxi_aes_wdata_sb_0 <= 1;
        _maxi_aes_wvalid_sb_0 <= 1;
        _maxi_aes_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_aes_wdata_cond_1_1 <= 1;
      if(_maxi_aes_wvalid_sb_0 && !_maxi_aes_wready_sb_0) begin
        _maxi_aes_wvalid_sb_0 <= _maxi_aes_wvalid_sb_0;
      end 
      if((th_ctrl == 32) && (_maxi_aes_wready_sb_0 || !_maxi_aes_wvalid_sb_0)) begin
        _maxi_aes_wdata_sb_0 <= _th_ctrl_i_1 + 10;
        _maxi_aes_wvalid_sb_0 <= 1;
        _maxi_aes_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_aes_wdata_cond_2_1 <= 1;
      if(_maxi_aes_wvalid_sb_0 && !_maxi_aes_wready_sb_0) begin
        _maxi_aes_wvalid_sb_0 <= _maxi_aes_wvalid_sb_0;
      end 
      if((th_ctrl == 38) && (_maxi_aes_wready_sb_0 || !_maxi_aes_wvalid_sb_0)) begin
        _maxi_aes_wdata_sb_0 <= 1;
        _maxi_aes_wvalid_sb_0 <= 1;
        _maxi_aes_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_aes_wdata_cond_3_1 <= 1;
      if(_maxi_aes_wvalid_sb_0 && !_maxi_aes_wready_sb_0) begin
        _maxi_aes_wvalid_sb_0 <= _maxi_aes_wvalid_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_aes_writedata_data_5 <= 0;
      _sb_maxi_aes_writedata_valid_6 <= 0;
      _sb_maxi_aes_writedata_tmp_data_8 <= 0;
      _sb_maxi_aes_writedata_tmp_valid_9 <= 0;
    end else begin
      if(_sb_maxi_aes_writedata_m_ready_4 || !_sb_maxi_aes_writedata_valid_6) begin
        _sb_maxi_aes_writedata_data_5 <= _sb_maxi_aes_writedata_next_data_10;
        _sb_maxi_aes_writedata_valid_6 <= _sb_maxi_aes_writedata_next_valid_11;
      end 
      if(!_sb_maxi_aes_writedata_tmp_valid_9 && _sb_maxi_aes_writedata_valid_6 && !_sb_maxi_aes_writedata_m_ready_4) begin
        _sb_maxi_aes_writedata_tmp_data_8 <= _sb_maxi_aes_writedata_s_data_2;
        _sb_maxi_aes_writedata_tmp_valid_9 <= _sb_maxi_aes_writedata_s_valid_3;
      end 
      if(_sb_maxi_aes_writedata_tmp_valid_9 && _sb_maxi_aes_writedata_m_ready_4) begin
        _sb_maxi_aes_writedata_tmp_valid_9 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      maxi_aes_araddr <= 0;
      maxi_aes_arvalid <= 0;
      _maxi_aes_raddr_cond_0_1 <= 0;
      _maxi_aes_raddr_cond_1_1 <= 0;
    end else begin
      if(_maxi_aes_raddr_cond_0_1) begin
        maxi_aes_arvalid <= 0;
      end 
      if(_maxi_aes_raddr_cond_1_1) begin
        maxi_aes_arvalid <= 0;
      end 
      if((th_ctrl == 21) && (maxi_aes_arready || !maxi_aes_arvalid)) begin
        maxi_aes_araddr <= 64;
        maxi_aes_arvalid <= 1;
      end 
      _maxi_aes_raddr_cond_0_1 <= 1;
      if(maxi_aes_arvalid && !maxi_aes_arready) begin
        maxi_aes_arvalid <= maxi_aes_arvalid;
      end 
      if((th_ctrl == 48) && (maxi_aes_arready || !maxi_aes_arvalid)) begin
        maxi_aes_araddr <= 64;
        maxi_aes_arvalid <= 1;
      end 
      _maxi_aes_raddr_cond_1_1 <= 1;
      if(maxi_aes_arvalid && !maxi_aes_arready) begin
        maxi_aes_arvalid <= maxi_aes_arvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_aes_readdata_data_18 <= 0;
      _sb_maxi_aes_readdata_valid_19 <= 0;
      _sb_maxi_aes_readdata_tmp_data_21 <= 0;
      _sb_maxi_aes_readdata_tmp_valid_22 <= 0;
    end else begin
      if(_sb_maxi_aes_readdata_m_ready_17 || !_sb_maxi_aes_readdata_valid_19) begin
        _sb_maxi_aes_readdata_data_18 <= _sb_maxi_aes_readdata_next_data_23;
        _sb_maxi_aes_readdata_valid_19 <= _sb_maxi_aes_readdata_next_valid_24;
      end 
      if(!_sb_maxi_aes_readdata_tmp_valid_22 && _sb_maxi_aes_readdata_valid_19 && !_sb_maxi_aes_readdata_m_ready_17) begin
        _sb_maxi_aes_readdata_tmp_data_21 <= _sb_maxi_aes_readdata_s_data_15;
        _sb_maxi_aes_readdata_tmp_valid_22 <= _sb_maxi_aes_readdata_s_valid_16;
      end 
      if(_sb_maxi_aes_readdata_tmp_valid_22 && _sb_maxi_aes_readdata_m_ready_17) begin
        _sb_maxi_aes_readdata_tmp_valid_22 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _maxi_aes_outstanding_wcount <= 0;
    end else begin
      if(maxi_aes_awvalid && maxi_aes_awready && !(maxi_aes_bvalid && maxi_aes_bready) && (_maxi_aes_outstanding_wcount < 7)) begin
        _maxi_aes_outstanding_wcount <= _maxi_aes_outstanding_wcount + 1;
      end 
      if(!(maxi_aes_awvalid && maxi_aes_awready) && (maxi_aes_bvalid && maxi_aes_bready) && (_maxi_aes_outstanding_wcount > 0)) begin
        _maxi_aes_outstanding_wcount <= _maxi_aes_outstanding_wcount - 1;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _s_axis_aes_read_data_busy <= 0;
    end else begin
      if((th_ctrl == 16) && _s_axis_aes_read_idle) begin
        _s_axis_aes_read_data_busy <= 1;
      end 
      if((th_ctrl == 17) && s_axis_aes_tvalid) begin
        _s_axis_aes_read_data_busy <= 0;
      end 
      if((th_ctrl == 43) && _s_axis_aes_read_idle) begin
        _s_axis_aes_read_data_busy <= 1;
      end 
      if((th_ctrl == 44) && s_axis_aes_tvalid) begin
        _s_axis_aes_read_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__s_axis_aes_read_req_fifo <= 0;
    end else begin
      if(_s_axis_aes_read_req_fifo_enq && !_s_axis_aes_read_req_fifo_full && (_s_axis_aes_read_req_fifo_deq && !_s_axis_aes_read_req_fifo_empty)) begin
        count__s_axis_aes_read_req_fifo <= count__s_axis_aes_read_req_fifo;
      end else if(_s_axis_aes_read_req_fifo_enq && !_s_axis_aes_read_req_fifo_full) begin
        count__s_axis_aes_read_req_fifo <= count__s_axis_aes_read_req_fifo + 1;
      end else if(_s_axis_aes_read_req_fifo_deq && !_s_axis_aes_read_req_fifo_empty) begin
        count__s_axis_aes_read_req_fifo <= count__s_axis_aes_read_req_fifo - 1;
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

  always @(posedge CLK) begin
    if(RST) begin
      th_ctrl <= th_ctrl_init;
      _th_ctrl_i_1 <= 0;
      axistreamin_tdata_45 <= 0;
      axistreamin_tlast_46 <= 0;
      read_data_44 <= 0;
      _th_ctrl_last_2 <= 0;
      axim_rdata_47 <= 0;
      _th_ctrl_v_3 <= 0;
      axistreamin_tdata_48 <= 0;
      axistreamin_tlast_49 <= 0;
      axim_rdata_50 <= 0;
    end else begin
      case(th_ctrl)
        th_ctrl_init: begin
          th_ctrl <= th_ctrl_1;
        end
        th_ctrl_1: begin
          _th_ctrl_i_1 <= 0;
          th_ctrl <= th_ctrl_2;
        end
        th_ctrl_2: begin
          if(_th_ctrl_i_1 < 8) begin
            th_ctrl <= th_ctrl_3;
          end else begin
            th_ctrl <= th_ctrl_9;
          end
        end
        th_ctrl_3: begin
          if((_maxi_aes_outstanding_wcount == 0) && (maxi_aes_awready || !maxi_aes_awvalid)) begin
            th_ctrl <= th_ctrl_4;
          end 
        end
        th_ctrl_4: begin
          if(maxi_aes_awvalid && maxi_aes_awready) begin
            th_ctrl <= th_ctrl_5;
          end 
        end
        th_ctrl_5: begin
          if(_maxi_aes_wready_sb_0 || !_maxi_aes_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_6;
          end 
        end
        th_ctrl_6: begin
          if(_maxi_aes_wvalid_sb_0 && _maxi_aes_wready_sb_0) begin
            th_ctrl <= th_ctrl_7;
          end 
        end
        th_ctrl_7: begin
          if(!_maxi_aes_has_outstanding_write) begin
            th_ctrl <= th_ctrl_8;
          end 
        end
        th_ctrl_8: begin
          _th_ctrl_i_1 <= _th_ctrl_i_1 + 1;
          th_ctrl <= th_ctrl_2;
        end
        th_ctrl_9: begin
          if((_maxi_aes_outstanding_wcount == 0) && (maxi_aes_awready || !maxi_aes_awvalid)) begin
            th_ctrl <= th_ctrl_10;
          end 
        end
        th_ctrl_10: begin
          if(maxi_aes_awvalid && maxi_aes_awready) begin
            th_ctrl <= th_ctrl_11;
          end 
        end
        th_ctrl_11: begin
          if(_maxi_aes_wready_sb_0 || !_maxi_aes_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_12;
          end 
        end
        th_ctrl_12: begin
          if(_maxi_aes_wvalid_sb_0 && _maxi_aes_wready_sb_0) begin
            th_ctrl <= th_ctrl_13;
          end 
        end
        th_ctrl_13: begin
          if(!_maxi_aes_has_outstanding_write) begin
            th_ctrl <= th_ctrl_14;
          end 
        end
        th_ctrl_14: begin
          _th_ctrl_i_1 <= 0;
          th_ctrl <= th_ctrl_15;
        end
        th_ctrl_15: begin
          if(_th_ctrl_i_1 < 4) begin
            th_ctrl <= th_ctrl_16;
          end else begin
            th_ctrl <= th_ctrl_20;
          end
        end
        th_ctrl_16: begin
          if(_s_axis_aes_read_idle) begin
            th_ctrl <= th_ctrl_17;
          end 
        end
        th_ctrl_17: begin
          if(s_axis_aes_tvalid) begin
            axistreamin_tdata_45 <= s_axis_aes_tdata;
          end 
          if(s_axis_aes_tvalid) begin
            axistreamin_tlast_46 <= s_axis_aes_tlast;
          end 
          if(s_axis_aes_tvalid) begin
            th_ctrl <= th_ctrl_18;
          end 
        end
        th_ctrl_18: begin
          read_data_44 <= axistreamin_tdata_45;
          _th_ctrl_last_2 <= axistreamin_tlast_46;
          th_ctrl <= th_ctrl_19;
        end
        th_ctrl_19: begin
          _th_ctrl_i_1 <= _th_ctrl_i_1 + 1;
          th_ctrl <= th_ctrl_15;
        end
        th_ctrl_20: begin
          if(1) begin
            th_ctrl <= th_ctrl_21;
          end else begin
            th_ctrl <= th_ctrl_28;
          end
        end
        th_ctrl_21: begin
          if(maxi_aes_arready || !maxi_aes_arvalid) begin
            th_ctrl <= th_ctrl_22;
          end 
        end
        th_ctrl_22: begin
          if(maxi_aes_arvalid && maxi_aes_arready) begin
            th_ctrl <= th_ctrl_23;
          end 
        end
        th_ctrl_23: begin
          if(_maxi_aes_rvalid_sb_0) begin
            axim_rdata_47 <= _maxi_aes_rdata_sb_0;
          end 
          if(_maxi_aes_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_24;
          end 
        end
        th_ctrl_24: begin
          _th_ctrl_v_3 <= axim_rdata_47;
          th_ctrl <= th_ctrl_25;
        end
        th_ctrl_25: begin
          if(_th_ctrl_v_3 == 0) begin
            th_ctrl <= th_ctrl_26;
          end else begin
            th_ctrl <= th_ctrl_27;
          end
        end
        th_ctrl_26: begin
          th_ctrl <= th_ctrl_28;
        end
        th_ctrl_27: begin
          th_ctrl <= th_ctrl_20;
        end
        th_ctrl_28: begin
          _th_ctrl_i_1 <= 0;
          th_ctrl <= th_ctrl_29;
        end
        th_ctrl_29: begin
          if(_th_ctrl_i_1 < 8) begin
            th_ctrl <= th_ctrl_30;
          end else begin
            th_ctrl <= th_ctrl_36;
          end
        end
        th_ctrl_30: begin
          if((_maxi_aes_outstanding_wcount == 0) && (maxi_aes_awready || !maxi_aes_awvalid)) begin
            th_ctrl <= th_ctrl_31;
          end 
        end
        th_ctrl_31: begin
          if(maxi_aes_awvalid && maxi_aes_awready) begin
            th_ctrl <= th_ctrl_32;
          end 
        end
        th_ctrl_32: begin
          if(_maxi_aes_wready_sb_0 || !_maxi_aes_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_33;
          end 
        end
        th_ctrl_33: begin
          if(_maxi_aes_wvalid_sb_0 && _maxi_aes_wready_sb_0) begin
            th_ctrl <= th_ctrl_34;
          end 
        end
        th_ctrl_34: begin
          if(!_maxi_aes_has_outstanding_write) begin
            th_ctrl <= th_ctrl_35;
          end 
        end
        th_ctrl_35: begin
          _th_ctrl_i_1 <= _th_ctrl_i_1 + 1;
          th_ctrl <= th_ctrl_29;
        end
        th_ctrl_36: begin
          if((_maxi_aes_outstanding_wcount == 0) && (maxi_aes_awready || !maxi_aes_awvalid)) begin
            th_ctrl <= th_ctrl_37;
          end 
        end
        th_ctrl_37: begin
          if(maxi_aes_awvalid && maxi_aes_awready) begin
            th_ctrl <= th_ctrl_38;
          end 
        end
        th_ctrl_38: begin
          if(_maxi_aes_wready_sb_0 || !_maxi_aes_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_39;
          end 
        end
        th_ctrl_39: begin
          if(_maxi_aes_wvalid_sb_0 && _maxi_aes_wready_sb_0) begin
            th_ctrl <= th_ctrl_40;
          end 
        end
        th_ctrl_40: begin
          if(!_maxi_aes_has_outstanding_write) begin
            th_ctrl <= th_ctrl_41;
          end 
        end
        th_ctrl_41: begin
          _th_ctrl_i_1 <= 0;
          th_ctrl <= th_ctrl_42;
        end
        th_ctrl_42: begin
          if(_th_ctrl_i_1 < 4) begin
            th_ctrl <= th_ctrl_43;
          end else begin
            th_ctrl <= th_ctrl_47;
          end
        end
        th_ctrl_43: begin
          if(_s_axis_aes_read_idle) begin
            th_ctrl <= th_ctrl_44;
          end 
        end
        th_ctrl_44: begin
          if(s_axis_aes_tvalid) begin
            axistreamin_tdata_48 <= s_axis_aes_tdata;
          end 
          if(s_axis_aes_tvalid) begin
            axistreamin_tlast_49 <= s_axis_aes_tlast;
          end 
          if(s_axis_aes_tvalid) begin
            th_ctrl <= th_ctrl_45;
          end 
        end
        th_ctrl_45: begin
          read_data_44 <= axistreamin_tdata_48;
          _th_ctrl_last_2 <= axistreamin_tlast_49;
          th_ctrl <= th_ctrl_46;
        end
        th_ctrl_46: begin
          _th_ctrl_i_1 <= _th_ctrl_i_1 + 1;
          th_ctrl <= th_ctrl_42;
        end
        th_ctrl_47: begin
          if(1) begin
            th_ctrl <= th_ctrl_48;
          end else begin
            th_ctrl <= th_ctrl_55;
          end
        end
        th_ctrl_48: begin
          if(maxi_aes_arready || !maxi_aes_arvalid) begin
            th_ctrl <= th_ctrl_49;
          end 
        end
        th_ctrl_49: begin
          if(maxi_aes_arvalid && maxi_aes_arready) begin
            th_ctrl <= th_ctrl_50;
          end 
        end
        th_ctrl_50: begin
          if(_maxi_aes_rvalid_sb_0) begin
            axim_rdata_50 <= _maxi_aes_rdata_sb_0;
          end 
          if(_maxi_aes_rvalid_sb_0) begin
            th_ctrl <= th_ctrl_51;
          end 
        end
        th_ctrl_51: begin
          _th_ctrl_v_3 <= axim_rdata_50;
          th_ctrl <= th_ctrl_52;
        end
        th_ctrl_52: begin
          if(_th_ctrl_v_3 == 0) begin
            th_ctrl <= th_ctrl_53;
          end else begin
            th_ctrl <= th_ctrl_54;
          end
        end
        th_ctrl_53: begin
          th_ctrl <= th_ctrl_55;
        end
        th_ctrl_54: begin
          th_ctrl <= th_ctrl_47;
        end
      endcase
    end
  end


endmodule



module _s_axis_aes_read_req_fifo
(
  input CLK,
  input RST,
  input _s_axis_aes_read_req_fifo_enq,
  input [105-1:0] _s_axis_aes_read_req_fifo_wdata,
  output _s_axis_aes_read_req_fifo_full,
  output _s_axis_aes_read_req_fifo_almost_full,
  input _s_axis_aes_read_req_fifo_deq,
  output [105-1:0] _s_axis_aes_read_req_fifo_rdata,
  output _s_axis_aes_read_req_fifo_empty,
  output _s_axis_aes_read_req_fifo_almost_empty
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
  assign _s_axis_aes_read_req_fifo_full = is_full;
  assign _s_axis_aes_read_req_fifo_almost_full = is_almost_full || is_full;
  assign _s_axis_aes_read_req_fifo_empty = is_empty;
  assign _s_axis_aes_read_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _s_axis_aes_read_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_s_axis_aes_read_req_fifo_enq && !is_full) begin
        mem[head] <= _s_axis_aes_read_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_s_axis_aes_read_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module aes
(
  input CLK,
  input RST,
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
  output reg [128-1:0] axis_out_aes_tdata,
  output reg axis_out_aes_tvalid,
  input axis_out_aes_tready,
  output reg axis_out_aes_tlast
);

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
  reg [32-1:0] addr_0;
  reg writevalid_1;
  reg readvalid_2;
  reg prev_awvalid_3;
  reg prev_arvalid_4;
  assign axi_s_ctrl_aes_awready = (_axi_s_ctrl_aes_register_fsm == 0) && (!writevalid_1 && !readvalid_2 && !axi_s_ctrl_aes_bvalid && prev_awvalid_3);
  assign axi_s_ctrl_aes_arready = (_axi_s_ctrl_aes_register_fsm == 0) && (!readvalid_2 && !writevalid_1 && prev_arvalid_4 && !prev_awvalid_3);
  reg [_axi_s_ctrl_aes_maskwidth-1:0] axis_maskaddr_5;
  wire signed [64-1:0] axislite_rdata_6;
  assign axislite_rdata_6 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_aes_register_0 : 
                            (axis_maskaddr_5 == 1)? _axi_s_ctrl_aes_register_1 : 
                            (axis_maskaddr_5 == 2)? _axi_s_ctrl_aes_register_2 : 
                            (axis_maskaddr_5 == 3)? _axi_s_ctrl_aes_register_3 : 
                            (axis_maskaddr_5 == 4)? _axi_s_ctrl_aes_register_4 : 
                            (axis_maskaddr_5 == 5)? _axi_s_ctrl_aes_register_5 : 
                            (axis_maskaddr_5 == 6)? _axi_s_ctrl_aes_register_6 : 
                            (axis_maskaddr_5 == 7)? _axi_s_ctrl_aes_register_7 : 
                            (axis_maskaddr_5 == 8)? _axi_s_ctrl_aes_register_8 : 'hx;
  wire axislite_flag_7;
  assign axislite_flag_7 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_aes_flag_0 : 
                           (axis_maskaddr_5 == 1)? _axi_s_ctrl_aes_flag_1 : 
                           (axis_maskaddr_5 == 2)? _axi_s_ctrl_aes_flag_2 : 
                           (axis_maskaddr_5 == 3)? _axi_s_ctrl_aes_flag_3 : 
                           (axis_maskaddr_5 == 4)? _axi_s_ctrl_aes_flag_4 : 
                           (axis_maskaddr_5 == 5)? _axi_s_ctrl_aes_flag_5 : 
                           (axis_maskaddr_5 == 6)? _axi_s_ctrl_aes_flag_6 : 
                           (axis_maskaddr_5 == 7)? _axi_s_ctrl_aes_flag_7 : 
                           (axis_maskaddr_5 == 8)? _axi_s_ctrl_aes_flag_8 : 'hx;
  wire signed [64-1:0] axislite_resetval_8;
  assign axislite_resetval_8 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_aes_resetval_0 : 
                               (axis_maskaddr_5 == 1)? _axi_s_ctrl_aes_resetval_1 : 
                               (axis_maskaddr_5 == 2)? _axi_s_ctrl_aes_resetval_2 : 
                               (axis_maskaddr_5 == 3)? _axi_s_ctrl_aes_resetval_3 : 
                               (axis_maskaddr_5 == 4)? _axi_s_ctrl_aes_resetval_4 : 
                               (axis_maskaddr_5 == 5)? _axi_s_ctrl_aes_resetval_5 : 
                               (axis_maskaddr_5 == 6)? _axi_s_ctrl_aes_resetval_6 : 
                               (axis_maskaddr_5 == 7)? _axi_s_ctrl_aes_resetval_7 : 
                               (axis_maskaddr_5 == 8)? _axi_s_ctrl_aes_resetval_8 : 'hx;
  reg _axi_s_ctrl_aes_rdata_cond_0_1;
  assign axi_s_ctrl_aes_wready = _axi_s_ctrl_aes_register_fsm == 3;
  wire _axis_out_aes_write_req_fifo_enq;
  wire [105-1:0] _axis_out_aes_write_req_fifo_wdata;
  wire _axis_out_aes_write_req_fifo_full;
  wire _axis_out_aes_write_req_fifo_almost_full;
  wire _axis_out_aes_write_req_fifo_deq;
  wire [105-1:0] _axis_out_aes_write_req_fifo_rdata;
  wire _axis_out_aes_write_req_fifo_empty;
  wire _axis_out_aes_write_req_fifo_almost_empty;

  _axis_out_aes_write_req_fifo
  inst__axis_out_aes_write_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axis_out_aes_write_req_fifo_enq(_axis_out_aes_write_req_fifo_enq),
    ._axis_out_aes_write_req_fifo_wdata(_axis_out_aes_write_req_fifo_wdata),
    ._axis_out_aes_write_req_fifo_full(_axis_out_aes_write_req_fifo_full),
    ._axis_out_aes_write_req_fifo_almost_full(_axis_out_aes_write_req_fifo_almost_full),
    ._axis_out_aes_write_req_fifo_deq(_axis_out_aes_write_req_fifo_deq),
    ._axis_out_aes_write_req_fifo_rdata(_axis_out_aes_write_req_fifo_rdata),
    ._axis_out_aes_write_req_fifo_empty(_axis_out_aes_write_req_fifo_empty),
    ._axis_out_aes_write_req_fifo_almost_empty(_axis_out_aes_write_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axis_out_aes_write_req_fifo;
  wire [8-1:0] _axis_out_aes_write_op_sel_fifo;
  wire [32-1:0] _axis_out_aes_write_local_addr_fifo;
  wire [32-1:0] _axis_out_aes_write_local_stride_fifo;
  wire [33-1:0] _axis_out_aes_write_size_fifo;
  wire [8-1:0] unpack_write_req_op_sel_9;
  wire [32-1:0] unpack_write_req_local_addr_10;
  wire [32-1:0] unpack_write_req_local_stride_11;
  wire [33-1:0] unpack_write_req_local_size_12;
  assign unpack_write_req_op_sel_9 = _axis_out_aes_write_req_fifo_rdata[104:97];
  assign unpack_write_req_local_addr_10 = _axis_out_aes_write_req_fifo_rdata[96:65];
  assign unpack_write_req_local_stride_11 = _axis_out_aes_write_req_fifo_rdata[64:33];
  assign unpack_write_req_local_size_12 = _axis_out_aes_write_req_fifo_rdata[32:0];
  assign _axis_out_aes_write_op_sel_fifo = unpack_write_req_op_sel_9;
  assign _axis_out_aes_write_local_addr_fifo = unpack_write_req_local_addr_10;
  assign _axis_out_aes_write_local_stride_fifo = unpack_write_req_local_stride_11;
  assign _axis_out_aes_write_size_fifo = unpack_write_req_local_size_12;
  reg [8-1:0] _axis_out_aes_write_op_sel_buf;
  reg [32-1:0] _axis_out_aes_write_local_addr_buf;
  reg [32-1:0] _axis_out_aes_write_local_stride_buf;
  reg [33-1:0] _axis_out_aes_write_size_buf;
  reg _axis_out_aes_write_data_busy;
  wire _axis_out_aes_write_data_idle;
  wire _axis_out_aes_write_idle;
  assign _axis_out_aes_write_data_idle = _axis_out_aes_write_req_fifo_empty && !_axis_out_aes_write_data_busy;
  assign _axis_out_aes_write_idle = _axis_out_aes_write_data_idle;
  reg [64-1:0] data_13;
  reg [64-1:0] data_14;
  reg [128-1:0] data_15;
  reg [128-1:0] otp_data_16;
  wire [2-1:0] aes_ram_0_addr;
  wire [128-1:0] aes_ram_0_rdata;
  wire [128-1:0] aes_ram_0_wdata;
  wire aes_ram_0_wenable;
  wire aes_ram_0_enable;

  aes_ram
  inst_aes_ram
  (
    .CLK(CLK),
    .aes_ram_0_addr(aes_ram_0_addr),
    .aes_ram_0_rdata(aes_ram_0_rdata),
    .aes_ram_0_wdata(aes_ram_0_wdata),
    .aes_ram_0_wenable(aes_ram_0_wenable),
    .aes_ram_0_enable(aes_ram_0_enable)
  );

  reg [1-1:0] start;
  reg [128-1:0] plaintext;
  wire [1-1:0] busy;
  wire [1-1:0] done;
  wire [128-1:0] ciphertext;

  aes128_enc_fixedkey
  aes_inst
  (
    .CLK(CLK),
    .RST(RST),
    .start(start),
    .plaintext(plaintext),
    .busy(busy),
    .done(done),
    .ciphertext(ciphertext)
  );

  reg [32-1:0] aes_thread;
  localparam aes_thread_init = 0;
  reg signed [32-1:0] _aes_thread_i_0;
  assign aes_ram_0_wdata = (aes_thread == 15)? otp_data_16 : 'hx;
  assign aes_ram_0_wenable = (aes_thread == 15)? 1'd1 : 0;
  wire [8-1:0] pack_write_req_op_sel_17;
  wire [32-1:0] pack_write_req_local_addr_18;
  wire [32-1:0] pack_write_req_local_stride_19;
  wire [33-1:0] pack_write_req_local_size_20;
  assign pack_write_req_op_sel_17 = 1;
  assign pack_write_req_local_addr_18 = 0;
  assign pack_write_req_local_stride_19 = 1;
  assign pack_write_req_local_size_20 = 4;
  wire [105-1:0] pack_write_req_packed_21;
  assign pack_write_req_packed_21 = { pack_write_req_op_sel_17, pack_write_req_local_addr_18, pack_write_req_local_stride_19, pack_write_req_local_size_20 };
  assign _axis_out_aes_write_req_fifo_wdata = ((aes_thread == 17) && !_axis_out_aes_write_req_fifo_almost_full)? pack_write_req_packed_21 : 'hx;
  assign _axis_out_aes_write_req_fifo_enq = ((aes_thread == 17) && !_axis_out_aes_write_req_fifo_almost_full)? (aes_thread == 17) && !_axis_out_aes_write_req_fifo_almost_full && !_axis_out_aes_write_req_fifo_almost_full : 0;
  localparam _tmp_22 = 1;
  wire [_tmp_22-1:0] _tmp_23;
  assign _tmp_23 = !_axis_out_aes_write_req_fifo_almost_full;
  reg [_tmp_22-1:0] __tmp_23_1;
  reg [32-1:0] _axis_out_aes_write_data_fsm;
  localparam _axis_out_aes_write_data_fsm_init = 0;
  assign _axis_out_aes_write_req_fifo_deq = ((_axis_out_aes_write_data_fsm == 0) && (!_axis_out_aes_write_data_busy && !_axis_out_aes_write_req_fifo_empty && (_axis_out_aes_write_op_sel_fifo == 1)) && !_axis_out_aes_write_req_fifo_empty)? 1 : 0;
  reg [32-1:0] read_burst_fsm_0;
  localparam read_burst_fsm_0_init = 0;
  reg [2-1:0] read_burst_addr_24;
  reg [2-1:0] read_burst_stride_25;
  reg [33-1:0] read_burst_length_26;
  reg read_burst_rvalid_27;
  reg read_burst_rlast_28;
  assign aes_ram_0_addr = ((read_burst_fsm_0 == 1) && (!read_burst_rvalid_27 || (axis_out_aes_tready || !axis_out_aes_tvalid)))? read_burst_addr_24 : 
                          (aes_thread == 15)? _aes_thread_i_0 : 'hx;
  assign aes_ram_0_enable = ((read_burst_fsm_0 == 1) && (!read_burst_rvalid_27 || (axis_out_aes_tready || !axis_out_aes_tvalid)))? 1'd1 : 
                            (aes_thread == 15)? 1'd1 : 0;
  localparam _tmp_29 = 1;
  wire [_tmp_29-1:0] _tmp_30;
  assign _tmp_30 = (read_burst_fsm_0 == 1) && (!read_burst_rvalid_27 || (axis_out_aes_tready || !axis_out_aes_tvalid));
  reg [_tmp_29-1:0] __tmp_30_1;
  wire [128-1:0] read_burst_rdata_31;
  assign read_burst_rdata_31 = aes_ram_0_rdata;
  reg _axis_out_aes_cond_0_1;

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
        axi_s_ctrl_aes_rdata <= axislite_rdata_6;
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
      prev_awvalid_3 <= 0;
      prev_arvalid_4 <= 0;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      addr_0 <= 0;
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
      prev_awvalid_3 <= axi_s_ctrl_aes_awvalid;
      prev_arvalid_4 <= axi_s_ctrl_aes_arvalid;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      if(axi_s_ctrl_aes_awready && axi_s_ctrl_aes_awvalid && !axi_s_ctrl_aes_bvalid) begin
        addr_0 <= axi_s_ctrl_aes_awaddr;
        writevalid_1 <= 1;
      end else if(axi_s_ctrl_aes_arready && axi_s_ctrl_aes_arvalid) begin
        addr_0 <= axi_s_ctrl_aes_araddr;
        readvalid_2 <= 1;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 0)) begin
        _axi_s_ctrl_aes_register_0 <= axislite_resetval_8;
        _axi_s_ctrl_aes_flag_0 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 1)) begin
        _axi_s_ctrl_aes_register_1 <= axislite_resetval_8;
        _axi_s_ctrl_aes_flag_1 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 2)) begin
        _axi_s_ctrl_aes_register_2 <= axislite_resetval_8;
        _axi_s_ctrl_aes_flag_2 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 3)) begin
        _axi_s_ctrl_aes_register_3 <= axislite_resetval_8;
        _axi_s_ctrl_aes_flag_3 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 4)) begin
        _axi_s_ctrl_aes_register_4 <= axislite_resetval_8;
        _axi_s_ctrl_aes_flag_4 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 5)) begin
        _axi_s_ctrl_aes_register_5 <= axislite_resetval_8;
        _axi_s_ctrl_aes_flag_5 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 6)) begin
        _axi_s_ctrl_aes_register_6 <= axislite_resetval_8;
        _axi_s_ctrl_aes_flag_6 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 7)) begin
        _axi_s_ctrl_aes_register_7 <= axislite_resetval_8;
        _axi_s_ctrl_aes_flag_7 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 1) && (axi_s_ctrl_aes_rready || !axi_s_ctrl_aes_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 8)) begin
        _axi_s_ctrl_aes_register_8 <= axislite_resetval_8;
        _axi_s_ctrl_aes_flag_8 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_5 == 0)) begin
        _axi_s_ctrl_aes_register_0 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_5 == 1)) begin
        _axi_s_ctrl_aes_register_1 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_5 == 2)) begin
        _axi_s_ctrl_aes_register_2 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_5 == 3)) begin
        _axi_s_ctrl_aes_register_3 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_5 == 4)) begin
        _axi_s_ctrl_aes_register_4 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_5 == 5)) begin
        _axi_s_ctrl_aes_register_5 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_5 == 6)) begin
        _axi_s_ctrl_aes_register_6 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_5 == 7)) begin
        _axi_s_ctrl_aes_register_7 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_fsm == 3) && axi_s_ctrl_aes_wvalid && (axis_maskaddr_5 == 8)) begin
        _axi_s_ctrl_aes_register_8 <= axi_s_ctrl_aes_wdata;
      end 
      if((_axi_s_ctrl_aes_register_8 == 1) && (aes_thread == 2) && 0) begin
        _axi_s_ctrl_aes_register_0 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_8 == 1) && (aes_thread == 2) && 0) begin
        _axi_s_ctrl_aes_register_1 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_8 == 1) && (aes_thread == 2) && 0) begin
        _axi_s_ctrl_aes_register_2 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_8 == 1) && (aes_thread == 2) && 0) begin
        _axi_s_ctrl_aes_register_3 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_8 == 1) && (aes_thread == 2) && 0) begin
        _axi_s_ctrl_aes_register_4 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_8 == 1) && (aes_thread == 2) && 0) begin
        _axi_s_ctrl_aes_register_5 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_8 == 1) && (aes_thread == 2) && 0) begin
        _axi_s_ctrl_aes_register_6 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_8 == 1) && (aes_thread == 2) && 0) begin
        _axi_s_ctrl_aes_register_7 <= 0;
      end 
      if((_axi_s_ctrl_aes_register_8 == 1) && (aes_thread == 2) && 1) begin
        _axi_s_ctrl_aes_register_8 <= 0;
      end 
      if((aes_thread == 18) && 0) begin
        _axi_s_ctrl_aes_register_0 <= 0;
        _axi_s_ctrl_aes_flag_0 <= 0;
      end 
      if((aes_thread == 18) && 0) begin
        _axi_s_ctrl_aes_register_1 <= 0;
        _axi_s_ctrl_aes_flag_1 <= 0;
      end 
      if((aes_thread == 18) && 0) begin
        _axi_s_ctrl_aes_register_2 <= 0;
        _axi_s_ctrl_aes_flag_2 <= 0;
      end 
      if((aes_thread == 18) && 0) begin
        _axi_s_ctrl_aes_register_3 <= 0;
        _axi_s_ctrl_aes_flag_3 <= 0;
      end 
      if((aes_thread == 18) && 0) begin
        _axi_s_ctrl_aes_register_4 <= 0;
        _axi_s_ctrl_aes_flag_4 <= 0;
      end 
      if((aes_thread == 18) && 0) begin
        _axi_s_ctrl_aes_register_5 <= 0;
        _axi_s_ctrl_aes_flag_5 <= 0;
      end 
      if((aes_thread == 18) && 0) begin
        _axi_s_ctrl_aes_register_6 <= 0;
        _axi_s_ctrl_aes_flag_6 <= 0;
      end 
      if((aes_thread == 18) && 0) begin
        _axi_s_ctrl_aes_register_7 <= 0;
        _axi_s_ctrl_aes_flag_7 <= 0;
      end 
      if((aes_thread == 18) && 1) begin
        _axi_s_ctrl_aes_register_8 <= 0;
        _axi_s_ctrl_aes_flag_8 <= 0;
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
      axis_maskaddr_5 <= 0;
    end else begin
      case(_axi_s_ctrl_aes_register_fsm)
        _axi_s_ctrl_aes_register_fsm_init: begin
          if(readvalid_2 || writevalid_1) begin
            axis_maskaddr_5 <= (addr_0 >> _axi_s_ctrl_aes_shift) & _axi_s_ctrl_aes_mask;
          end 
          if(readvalid_2) begin
            _axi_s_ctrl_aes_register_fsm <= _axi_s_ctrl_aes_register_fsm_1;
          end 
          if(writevalid_1) begin
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
      axis_out_aes_tdata <= 0;
      axis_out_aes_tvalid <= 0;
      axis_out_aes_tlast <= 0;
      _axis_out_aes_cond_0_1 <= 0;
    end else begin
      if(_axis_out_aes_cond_0_1) begin
        axis_out_aes_tvalid <= 0;
        axis_out_aes_tlast <= 0;
      end 
      if((_axis_out_aes_write_op_sel_buf == 1) && read_burst_rvalid_27 && (axis_out_aes_tready || !axis_out_aes_tvalid) && (axis_out_aes_tready || !axis_out_aes_tvalid)) begin
        axis_out_aes_tdata <= read_burst_rdata_31;
        axis_out_aes_tvalid <= 1;
        axis_out_aes_tlast <= read_burst_rlast_28;
      end 
      _axis_out_aes_cond_0_1 <= 1;
      if(axis_out_aes_tvalid && !axis_out_aes_tready) begin
        axis_out_aes_tvalid <= axis_out_aes_tvalid;
        axis_out_aes_tlast <= axis_out_aes_tlast;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axis_out_aes_write_data_busy <= 0;
      _axis_out_aes_write_op_sel_buf <= 0;
      _axis_out_aes_write_local_addr_buf <= 0;
      _axis_out_aes_write_local_stride_buf <= 0;
      _axis_out_aes_write_size_buf <= 0;
    end else begin
      if((_axis_out_aes_write_data_fsm == 0) && (!_axis_out_aes_write_data_busy && !_axis_out_aes_write_req_fifo_empty && (_axis_out_aes_write_op_sel_fifo == 1))) begin
        _axis_out_aes_write_data_busy <= 1;
        _axis_out_aes_write_op_sel_buf <= _axis_out_aes_write_op_sel_fifo;
        _axis_out_aes_write_local_addr_buf <= _axis_out_aes_write_local_addr_fifo;
        _axis_out_aes_write_local_stride_buf <= _axis_out_aes_write_local_stride_fifo;
        _axis_out_aes_write_size_buf <= _axis_out_aes_write_size_fifo;
      end 
      if((_axis_out_aes_write_data_fsm == 2) && ((_axis_out_aes_write_op_sel_buf == 1) && read_burst_rvalid_27 && (axis_out_aes_tready || !axis_out_aes_tvalid))) begin
        _axis_out_aes_write_size_buf <= _axis_out_aes_write_size_buf - 1;
      end 
      if((_axis_out_aes_write_data_fsm == 2) && ((_axis_out_aes_write_op_sel_buf == 1) && read_burst_rvalid_27 && (axis_out_aes_tready || !axis_out_aes_tvalid)) && read_burst_rlast_28) begin
        _axis_out_aes_write_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axis_out_aes_write_req_fifo <= 0;
      __tmp_23_1 <= 0;
    end else begin
      if(_axis_out_aes_write_req_fifo_enq && !_axis_out_aes_write_req_fifo_full && (_axis_out_aes_write_req_fifo_deq && !_axis_out_aes_write_req_fifo_empty)) begin
        count__axis_out_aes_write_req_fifo <= count__axis_out_aes_write_req_fifo;
      end else if(_axis_out_aes_write_req_fifo_enq && !_axis_out_aes_write_req_fifo_full) begin
        count__axis_out_aes_write_req_fifo <= count__axis_out_aes_write_req_fifo + 1;
      end else if(_axis_out_aes_write_req_fifo_deq && !_axis_out_aes_write_req_fifo_empty) begin
        count__axis_out_aes_write_req_fifo <= count__axis_out_aes_write_req_fifo - 1;
      end 
      __tmp_23_1 <= _tmp_23;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      __tmp_30_1 <= 0;
    end else begin
      __tmp_30_1 <= _tmp_30;
    end
  end

  localparam aes_thread_1 = 1;
  localparam aes_thread_2 = 2;
  localparam aes_thread_3 = 3;
  localparam aes_thread_4 = 4;
  localparam aes_thread_5 = 5;
  localparam aes_thread_6 = 6;
  localparam aes_thread_7 = 7;
  localparam aes_thread_8 = 8;
  localparam aes_thread_9 = 9;
  localparam aes_thread_10 = 10;
  localparam aes_thread_11 = 11;
  localparam aes_thread_12 = 12;
  localparam aes_thread_13 = 13;
  localparam aes_thread_14 = 14;
  localparam aes_thread_15 = 15;
  localparam aes_thread_16 = 16;
  localparam aes_thread_17 = 17;
  localparam aes_thread_18 = 18;
  localparam aes_thread_19 = 19;
  localparam aes_thread_20 = 20;

  always @(posedge CLK) begin
    if(RST) begin
      aes_thread <= aes_thread_init;
      _aes_thread_i_0 <= 0;
      data_13 <= 0;
      data_14 <= 0;
      plaintext <= 0;
      start <= 0;
      otp_data_16 <= 0;
    end else begin
      case(aes_thread)
        aes_thread_init: begin
          aes_thread <= aes_thread_1;
        end
        aes_thread_1: begin
          if(1) begin
            aes_thread <= aes_thread_2;
          end else begin
            aes_thread <= aes_thread_20;
          end
        end
        aes_thread_2: begin
          if(_axi_s_ctrl_aes_register_8 == 1) begin
            aes_thread <= aes_thread_3;
          end 
        end
        aes_thread_3: begin
          _aes_thread_i_0 <= 0;
          aes_thread <= aes_thread_4;
        end
        aes_thread_4: begin
          if(_aes_thread_i_0 < 4) begin
            aes_thread <= aes_thread_5;
          end else begin
            aes_thread <= aes_thread_17;
          end
        end
        aes_thread_5: begin
          data_13 <= ((_aes_thread_i_0 << 1) == 0)? _axi_s_ctrl_aes_register_0 : 
                     ((_aes_thread_i_0 << 1) == 1)? _axi_s_ctrl_aes_register_1 : 
                     ((_aes_thread_i_0 << 1) == 2)? _axi_s_ctrl_aes_register_2 : 
                     ((_aes_thread_i_0 << 1) == 3)? _axi_s_ctrl_aes_register_3 : 
                     ((_aes_thread_i_0 << 1) == 4)? _axi_s_ctrl_aes_register_4 : 
                     ((_aes_thread_i_0 << 1) == 5)? _axi_s_ctrl_aes_register_5 : 
                     ((_aes_thread_i_0 << 1) == 6)? _axi_s_ctrl_aes_register_6 : 
                     ((_aes_thread_i_0 << 1) == 7)? _axi_s_ctrl_aes_register_7 : 
                     ((_aes_thread_i_0 << 1) == 8)? _axi_s_ctrl_aes_register_8 : 'hx;
          aes_thread <= aes_thread_6;
        end
        aes_thread_6: begin
          data_14 <= ((_aes_thread_i_0 << 1) + 1 == 0)? _axi_s_ctrl_aes_register_0 : 
                     ((_aes_thread_i_0 << 1) + 1 == 1)? _axi_s_ctrl_aes_register_1 : 
                     ((_aes_thread_i_0 << 1) + 1 == 2)? _axi_s_ctrl_aes_register_2 : 
                     ((_aes_thread_i_0 << 1) + 1 == 3)? _axi_s_ctrl_aes_register_3 : 
                     ((_aes_thread_i_0 << 1) + 1 == 4)? _axi_s_ctrl_aes_register_4 : 
                     ((_aes_thread_i_0 << 1) + 1 == 5)? _axi_s_ctrl_aes_register_5 : 
                     ((_aes_thread_i_0 << 1) + 1 == 6)? _axi_s_ctrl_aes_register_6 : 
                     ((_aes_thread_i_0 << 1) + 1 == 7)? _axi_s_ctrl_aes_register_7 : 
                     ((_aes_thread_i_0 << 1) + 1 == 8)? _axi_s_ctrl_aes_register_8 : 'hx;
          aes_thread <= aes_thread_7;
        end
        aes_thread_7: begin
          plaintext <= (data_14 << 64) | data_13;
          aes_thread <= aes_thread_8;
        end
        aes_thread_8: begin
          start <= 1;
          aes_thread <= aes_thread_9;
        end
        aes_thread_9: begin
          start <= 0;
          aes_thread <= aes_thread_10;
        end
        aes_thread_10: begin
          if(1) begin
            aes_thread <= aes_thread_11;
          end else begin
            aes_thread <= aes_thread_14;
          end
        end
        aes_thread_11: begin
          if(done == 1) begin
            aes_thread <= aes_thread_12;
          end else begin
            aes_thread <= aes_thread_13;
          end
        end
        aes_thread_12: begin
          aes_thread <= aes_thread_14;
        end
        aes_thread_13: begin
          aes_thread <= aes_thread_10;
        end
        aes_thread_14: begin
          otp_data_16 <= ciphertext;
          aes_thread <= aes_thread_15;
        end
        aes_thread_15: begin
          aes_thread <= aes_thread_16;
        end
        aes_thread_16: begin
          _aes_thread_i_0 <= _aes_thread_i_0 + 1;
          aes_thread <= aes_thread_4;
        end
        aes_thread_17: begin
          if(!_axis_out_aes_write_req_fifo_almost_full) begin
            aes_thread <= aes_thread_18;
          end 
        end
        aes_thread_18: begin
          aes_thread <= aes_thread_19;
        end
        aes_thread_19: begin
          aes_thread <= aes_thread_1;
        end
      endcase
    end
  end

  localparam _axis_out_aes_write_data_fsm_1 = 1;
  localparam _axis_out_aes_write_data_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axis_out_aes_write_data_fsm <= _axis_out_aes_write_data_fsm_init;
    end else begin
      case(_axis_out_aes_write_data_fsm)
        _axis_out_aes_write_data_fsm_init: begin
          if(!_axis_out_aes_write_data_busy && !_axis_out_aes_write_req_fifo_empty && (_axis_out_aes_write_op_sel_fifo == 1)) begin
            _axis_out_aes_write_data_fsm <= _axis_out_aes_write_data_fsm_1;
          end 
        end
        _axis_out_aes_write_data_fsm_1: begin
          _axis_out_aes_write_data_fsm <= _axis_out_aes_write_data_fsm_2;
        end
        _axis_out_aes_write_data_fsm_2: begin
          if((_axis_out_aes_write_op_sel_buf == 1) && read_burst_rvalid_27 && (axis_out_aes_tready || !axis_out_aes_tvalid) && read_burst_rlast_28) begin
            _axis_out_aes_write_data_fsm <= _axis_out_aes_write_data_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam read_burst_fsm_0_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      read_burst_fsm_0 <= read_burst_fsm_0_init;
      read_burst_addr_24 <= 0;
      read_burst_stride_25 <= 0;
      read_burst_length_26 <= 0;
      read_burst_rvalid_27 <= 0;
      read_burst_rlast_28 <= 0;
    end else begin
      case(read_burst_fsm_0)
        read_burst_fsm_0_init: begin
          read_burst_addr_24 <= _axis_out_aes_write_local_addr_buf;
          read_burst_stride_25 <= _axis_out_aes_write_local_stride_buf;
          read_burst_length_26 <= _axis_out_aes_write_size_buf;
          read_burst_rvalid_27 <= 0;
          read_burst_rlast_28 <= 0;
          if((_axis_out_aes_write_data_fsm == 1) && (_axis_out_aes_write_op_sel_buf == 1) && (_axis_out_aes_write_size_buf > 0)) begin
            read_burst_fsm_0 <= read_burst_fsm_0_1;
          end 
        end
        read_burst_fsm_0_1: begin
          if((axis_out_aes_tready || !axis_out_aes_tvalid) && (read_burst_length_26 > 0)) begin
            read_burst_addr_24 <= read_burst_addr_24 + read_burst_stride_25;
            read_burst_length_26 <= read_burst_length_26 - 1;
            read_burst_rvalid_27 <= 1;
          end 
          if((axis_out_aes_tready || !axis_out_aes_tvalid) && (read_burst_length_26 <= 1)) begin
            read_burst_rlast_28 <= 1;
          end 
          if(read_burst_rlast_28 && read_burst_rvalid_27 && (axis_out_aes_tready || !axis_out_aes_tvalid)) begin
            read_burst_rvalid_27 <= 0;
            read_burst_rlast_28 <= 0;
          end 
          if(0) begin
            read_burst_rvalid_27 <= 0;
            read_burst_rlast_28 <= 0;
          end 
          if(read_burst_rlast_28 && read_burst_rvalid_27 && (axis_out_aes_tready || !axis_out_aes_tvalid)) begin
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



module _axis_out_aes_write_req_fifo
(
  input CLK,
  input RST,
  input _axis_out_aes_write_req_fifo_enq,
  input [105-1:0] _axis_out_aes_write_req_fifo_wdata,
  output _axis_out_aes_write_req_fifo_full,
  output _axis_out_aes_write_req_fifo_almost_full,
  input _axis_out_aes_write_req_fifo_deq,
  output [105-1:0] _axis_out_aes_write_req_fifo_rdata,
  output _axis_out_aes_write_req_fifo_empty,
  output _axis_out_aes_write_req_fifo_almost_empty
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
  assign _axis_out_aes_write_req_fifo_full = is_full;
  assign _axis_out_aes_write_req_fifo_almost_full = is_almost_full || is_full;
  assign _axis_out_aes_write_req_fifo_empty = is_empty;
  assign _axis_out_aes_write_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axis_out_aes_write_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axis_out_aes_write_req_fifo_enq && !is_full) begin
        mem[head] <= _axis_out_aes_write_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axis_out_aes_write_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module aes_ram
(
  input CLK,
  input [2-1:0] aes_ram_0_addr,
  output [128-1:0] aes_ram_0_rdata,
  input [128-1:0] aes_ram_0_wdata,
  input aes_ram_0_wenable,
  input aes_ram_0_enable
);

  reg [128-1:0] aes_ram_0_rdata_out;
  assign aes_ram_0_rdata = aes_ram_0_rdata_out;
  reg [128-1:0] mem [0:4-1];

  always @(posedge CLK) begin
    if(aes_ram_0_enable) begin
      if(aes_ram_0_wenable) begin
        mem[aes_ram_0_addr] <= aes_ram_0_wdata;
        aes_ram_0_rdata_out <= aes_ram_0_wdata;
      end else begin
        aes_ram_0_rdata_out <= mem[aes_ram_0_addr];
      end
    end 
  end


endmodule



module aes128_enc_fixedkey
(
  input wire CLK,
  input wire RST,
  input wire start,
  input wire [127:0] plaintext,
  output reg busy,
  output reg done,
  output reg [127:0] ciphertext
);

  wire [127:0] RK [0:10];
  assign RK[0] = 128'h2b7e151628aed2a6abf7158809cf4f3c;
  assign RK[1] = 128'ha0fafe1788542cb123a339392a6c7605;
  assign RK[2] = 128'hf2c295f27a96b9435935807a7359f67f;
  assign RK[3] = 128'h3d80477d4716fe3e1e237e446d7a883b;
  assign RK[4] = 128'hef44a541a8525b7fb671253bdb0bad00;
  assign RK[5] = 128'hd4d1c6f87c839d87caf2b8bc11f915bc;
  assign RK[6] = 128'h6d88a37a110b3efddbf98641ca0093fd;
  assign RK[7] = 128'h4e54f70e5f5fc9f384a64fb24ea6dc4f;
  assign RK[8] = 128'head27321b58dbad2312bf5607f8d292f;
  assign RK[9] = 128'hac7766f319fadc2128d12941575c006e;
  assign RK[10] = 128'hd014f9a8c9ee2589e13f0cc8b6630ca6;
  localparam S_IDLE = 2'd0;localparam S_RUN = 2'd1;localparam S_DONE = 2'd2;
  reg [1:0] st;
  reg [3:0] round;
  reg [127:0] state;
  wire [7:0] sb [0:15];

  aes_sbox
  u0
  (
    .in(state[127:120]),
    .out(sb[0])
  );


  aes_sbox
  u1
  (
    .in(state[119:112]),
    .out(sb[1])
  );


  aes_sbox
  u2
  (
    .in(state[111:104]),
    .out(sb[2])
  );


  aes_sbox
  u3
  (
    .in(state[103:96]),
    .out(sb[3])
  );


  aes_sbox
  u4
  (
    .in(state[95:88]),
    .out(sb[4])
  );


  aes_sbox
  u5
  (
    .in(state[87:80]),
    .out(sb[5])
  );


  aes_sbox
  u6
  (
    .in(state[79:72]),
    .out(sb[6])
  );


  aes_sbox
  u7
  (
    .in(state[71:64]),
    .out(sb[7])
  );


  aes_sbox
  u8
  (
    .in(state[63:56]),
    .out(sb[8])
  );


  aes_sbox
  u9
  (
    .in(state[55:48]),
    .out(sb[9])
  );


  aes_sbox
  u10
  (
    .in(state[47:40]),
    .out(sb[10])
  );


  aes_sbox
  u11
  (
    .in(state[39:32]),
    .out(sb[11])
  );


  aes_sbox
  u12
  (
    .in(state[31:24]),
    .out(sb[12])
  );


  aes_sbox
  u13
  (
    .in(state[23:16]),
    .out(sb[13])
  );


  aes_sbox
  u14
  (
    .in(state[15:8]),
    .out(sb[14])
  );


  aes_sbox
  u15
  (
    .in(state[7:0]),
    .out(sb[15])
  );

  wire [127:0] subbytes_state;assign subbytes_state = { sb[0], sb[1], sb[2], sb[3], sb[4], sb[5], sb[6], sb[7], sb[8], sb[9], sb[10], sb[11], sb[12], sb[13], sb[14], sb[15] };
  wire [127:0] shiftrows_state;
  assign shiftrows_state = { subbytes_state[127:120], subbytes_state[95:88], subbytes_state[63:56], subbytes_state[31:24], subbytes_state[119:112], subbytes_state[87:80], subbytes_state[55:48], subbytes_state[23:16], subbytes_state[111:104], subbytes_state[79:72], subbytes_state[47:40], subbytes_state[15:8], subbytes_state[103:96], subbytes_state[71:64], subbytes_state[39:32], subbytes_state[7:0] };
  wire [127:0] mixcolumns_state;
  wire [7:0] s [0:15];
  assign s[0] = shiftrows_state[127:120];
  assign s[1] = shiftrows_state[119:112];
  assign s[2] = shiftrows_state[111:104];
  assign s[3] = shiftrows_state[103:96];
  assign s[4] = shiftrows_state[95:88];
  assign s[5] = shiftrows_state[87:80];
  assign s[6] = shiftrows_state[79:72];
  assign s[7] = shiftrows_state[71:64];
  assign s[8] = shiftrows_state[63:56];
  assign s[9] = shiftrows_state[55:48];
  assign s[10] = shiftrows_state[47:40];
  assign s[11] = shiftrows_state[39:32];
  assign s[12] = shiftrows_state[31:24];
  assign s[13] = shiftrows_state[23:16];
  assign s[14] = shiftrows_state[15:8];
  assign s[15] = shiftrows_state[7:0];
  wire [7:0] xtime_s [0:15];
  assign xtime_s[0] = { s[0][6:0], 1'b0 } ^ 8'h1b & { 8{ s[0][7] } };
  assign xtime_s[1] = { s[1][6:0], 1'b0 } ^ 8'h1b & { 8{ s[1][7] } };
  assign xtime_s[2] = { s[2][6:0], 1'b0 } ^ 8'h1b & { 8{ s[2][7] } };
  wire [7:0] d [0:15];
  assign d[0] = { s[0][6:0], 1'b0 } ^ 8'h1b & { 8{ s[0][7] } } ^ s[1] ^ s[2] ^ ({ s[2][6:0], 1'b0 } ^ 8'h1b & { 8{ s[2][7] } }) ^ s[3];
  assign d[1] = s[0] ^ ({ s[1][6:0], 1'b0 } ^ 8'h1b & { 8{ s[1][7] } }) ^ s[2] ^ ({ s[2][6:0], 1'b0 } ^ 8'h1b & { 8{ s[2][7] } }) ^ s[3];
  assign d[2] = s[0] ^ s[1] ^ ({ s[2][6:0], 1'b0 } ^ 8'h1b & { 8{ s[2][7] } }) ^ s[3] ^ ({ s[3][6:0], 1'b0 } ^ 8'h1b & { 8{ s[3][7] } });
  assign d[3] = s[0] ^ ({ s[0][6:0], 1'b0 } ^ 8'h1b & { 8{ s[0][7] } }) ^ s[1] ^ s[2] ^ ({ s[3][6:0], 1'b0 } ^ 8'h1b & { 8{ s[3][7] } });
  assign d[4] = { s[4][6:0], 1'b0 } ^ 8'h1b & { 8{ s[4][7] } } ^ s[5] ^ s[6] ^ ({ s[6][6:0], 1'b0 } ^ 8'h1b & { 8{ s[6][7] } }) ^ s[7];
  assign d[5] = s[4] ^ ({ s[5][6:0], 1'b0 } ^ 8'h1b & { 8{ s[5][7] } }) ^ s[6] ^ ({ s[6][6:0], 1'b0 } ^ 8'h1b & { 8{ s[6][7] } }) ^ s[7];
  assign d[6] = s[4] ^ s[5] ^ ({ s[6][6:0], 1'b0 } ^ 8'h1b & { 8{ s[6][7] } }) ^ s[7] ^ ({ s[7][6:0], 1'b0 } ^ 8'h1b & { 8{ s[7][7] } });
  assign d[7] = s[4] ^ ({ s[4][6:0], 1'b0 } ^ 8'h1b & { 8{ s[4][7] } }) ^ s[5] ^ s[6] ^ ({ s[7][6:0], 1'b0 } ^ 8'h1b & { 8{ s[7][7] } });
  assign d[8] = { s[8][6:0], 1'b0 } ^ 8'h1b & { 8{ s[8][7] } } ^ s[9] ^ s[10] ^ ({ s[10][6:0], 1'b0 } ^ 8'h1b & { 8{ s[10][7] } }) ^ s[11];
  assign d[9] = s[8] ^ ({ s[9][6:0], 1'b0 } ^ 8'h1b & { 8{ s[9][7] } }) ^ s[10] ^ ({ s[10][6:0], 1'b0 } ^ 8'h1b & { 8{ s[10][7] } }) ^ s[11];
  assign d[10] = s[8] ^ s[9] ^ ({ s[10][6:0], 1'b0 } ^ 8'h1b & { 8{ s[10][7] } }) ^ s[11] ^ ({ s[11][6:0], 1'b0 } ^ 8'h1b & { 8{ s[11][7] } });
  assign d[11] = s[8] ^ ({ s[8][6:0], 1'b0 } ^ 8'h1b & { 8{ s[8][7] } }) ^ s[9] ^ s[10] ^ ({ s[11][6:0], 1'b0 } ^ 8'h1b & { 8{ s[11][7] } });
  assign d[12] = { s[12][6:0], 1'b0 } ^ 8'h1b & { 8{ s[12][7] } } ^ s[13] ^ s[14] ^ ({ s[14][6:0], 1'b0 } ^ 8'h1b & { 8{ s[14][7] } }) ^ s[15];
  assign d[13] = s[12] ^ ({ s[13][6:0], 1'b0 } ^ 8'h1b & { 8{ s[13][7] } }) ^ s[14] ^ ({ s[14][6:0], 1'b0 } ^ 8'h1b & { 8{ s[14][7] } }) ^ s[15];
  assign d[14] = s[12] ^ s[13] ^ ({ s[14][6:0], 1'b0 } ^ 8'h1b & { 8{ s[14][7] } }) ^ s[15] ^ ({ s[15][6:0], 1'b0 } ^ 8'h1b & { 8{ s[15][7] } });
  assign d[15] = s[12] ^ ({ s[12][6:0], 1'b0 } ^ 8'h1b & { 8{ s[12][7] } }) ^ s[13] ^ s[14] ^ ({ s[15][6:0], 1'b0 } ^ 8'h1b & { 8{ s[15][7] } });
  assign mixcolumns_state = { d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7], d[8], d[9], d[10], d[11], d[12], d[13], d[14], d[15] };

  always @(posedge CLK or posedge RST) begin
    if(RST) begin
      st <= S_IDLE;
      busy <= 1'b0;
      done <= 1'b0;
      round <= 4'd0;
      state <= 128'd0;
      ciphertext <= 128'd0;
    end else begin
      case(st)
        S_IDLE: begin
          round <= 4'd0;
          if(start) begin
            state <= plaintext ^ RK[0];
            done <= 1'b0;
            busy <= 1'b1;
            st <= S_RUN;
          end 
        end
        S_RUN: begin
          if(round == 4'd0) begin
            state <= state;
            round <= 4'd1;
          end else if(round <= 4'd9) begin
            state <= mixcolumns_state ^ RK[round];
            round <= round + 4'd1;
          end else begin
            ciphertext <= shiftrows_state ^ RK[10];
            st <= S_DONE;
          end
        end
        S_DONE: begin
          busy <= 1'b0;
          done <= 1'b1;
          st <= S_IDLE;
          state <= 128'd0;
        end
        default: st <= st;
      endcase
    end
  end


endmodule

