

module test_memreq
(

);

  reg CLK;
  reg RST;
  reg [32-1:0] axi_s_ctrl_memreq_awaddr;
  reg [4-1:0] axi_s_ctrl_memreq_awcache;
  reg [3-1:0] axi_s_ctrl_memreq_awprot;
  reg axi_s_ctrl_memreq_awvalid;
  wire axi_s_ctrl_memreq_awready;
  reg [64-1:0] axi_s_ctrl_memreq_wdata;
  reg [8-1:0] axi_s_ctrl_memreq_wstrb;
  reg axi_s_ctrl_memreq_wvalid;
  wire axi_s_ctrl_memreq_wready;
  wire [2-1:0] axi_s_ctrl_memreq_bresp;
  wire axi_s_ctrl_memreq_bvalid;
  reg axi_s_ctrl_memreq_bready;
  reg [32-1:0] axi_s_ctrl_memreq_araddr;
  reg [4-1:0] axi_s_ctrl_memreq_arcache;
  reg [3-1:0] axi_s_ctrl_memreq_arprot;
  reg axi_s_ctrl_memreq_arvalid;
  wire axi_s_ctrl_memreq_arready;
  wire [64-1:0] axi_s_ctrl_memreq_rdata;
  wire [2-1:0] axi_s_ctrl_memreq_rresp;
  wire axi_s_ctrl_memreq_rvalid;
  reg axi_s_ctrl_memreq_rready;
  wire [32-1:0] axi_m_llc_awaddr;
  wire [8-1:0] axi_m_llc_awlen;
  wire [3-1:0] axi_m_llc_awsize;
  wire [2-1:0] axi_m_llc_awburst;
  wire [1-1:0] axi_m_llc_awlock;
  wire [4-1:0] axi_m_llc_awcache;
  wire [3-1:0] axi_m_llc_awprot;
  wire [4-1:0] axi_m_llc_awqos;
  wire [2-1:0] axi_m_llc_awuser;
  wire axi_m_llc_awvalid;
  reg axi_m_llc_awready;
  wire [128-1:0] axi_m_llc_wdata;
  wire [16-1:0] axi_m_llc_wstrb;
  wire axi_m_llc_wlast;
  wire axi_m_llc_wvalid;
  reg axi_m_llc_wready;
  reg [2-1:0] axi_m_llc_bresp;
  reg axi_m_llc_bvalid;
  wire axi_m_llc_bready;
  wire [32-1:0] axi_m_llc_araddr;
  wire [8-1:0] axi_m_llc_arlen;
  wire [3-1:0] axi_m_llc_arsize;
  wire [2-1:0] axi_m_llc_arburst;
  wire [1-1:0] axi_m_llc_arlock;
  wire [4-1:0] axi_m_llc_arcache;
  wire [3-1:0] axi_m_llc_arprot;
  wire [4-1:0] axi_m_llc_arqos;
  wire [2-1:0] axi_m_llc_aruser;
  wire axi_m_llc_arvalid;
  reg axi_m_llc_arready;
  reg [128-1:0] axi_m_llc_rdata;
  reg [2-1:0] axi_m_llc_rresp;
  reg axi_m_llc_rlast;
  reg axi_m_llc_rvalid;
  wire axi_m_llc_rready;
  reg [32-1:0] maxi_memreq_awaddr;
  wire [4-1:0] maxi_memreq_awcache;
  wire [3-1:0] maxi_memreq_awprot;
  reg maxi_memreq_awvalid;
  wire maxi_memreq_awready;
  assign maxi_memreq_awcache = 3;
  assign maxi_memreq_awprot = 0;
  wire [64-1:0] maxi_memreq_wdata;
  wire [8-1:0] maxi_memreq_wstrb;
  wire maxi_memreq_wvalid;
  wire maxi_memreq_wready;
  reg [64-1:0] _maxi_memreq_wdata_sb_0;
  reg [8-1:0] _maxi_memreq_wstrb_sb_0;
  reg _maxi_memreq_wvalid_sb_0;
  wire _maxi_memreq_wready_sb_0;
  wire [8-1:0] _sb_maxi_memreq_writedata_s_value_0;
  assign _sb_maxi_memreq_writedata_s_value_0 = _maxi_memreq_wstrb_sb_0;
  wire [64-1:0] _sb_maxi_memreq_writedata_s_value_1;
  assign _sb_maxi_memreq_writedata_s_value_1 = _maxi_memreq_wdata_sb_0;
  wire [72-1:0] _sb_maxi_memreq_writedata_s_data_2;
  assign _sb_maxi_memreq_writedata_s_data_2 = { _sb_maxi_memreq_writedata_s_value_0, _sb_maxi_memreq_writedata_s_value_1 };
  wire _sb_maxi_memreq_writedata_s_valid_3;
  assign _sb_maxi_memreq_writedata_s_valid_3 = _maxi_memreq_wvalid_sb_0;
  wire _sb_maxi_memreq_writedata_m_ready_4;
  assign _sb_maxi_memreq_writedata_m_ready_4 = maxi_memreq_wready;
  reg [72-1:0] _sb_maxi_memreq_writedata_data_5;
  reg _sb_maxi_memreq_writedata_valid_6;
  wire _sb_maxi_memreq_writedata_ready_7;
  reg [72-1:0] _sb_maxi_memreq_writedata_tmp_data_8;
  reg _sb_maxi_memreq_writedata_tmp_valid_9;
  wire [72-1:0] _sb_maxi_memreq_writedata_next_data_10;
  wire _sb_maxi_memreq_writedata_next_valid_11;
  assign _sb_maxi_memreq_writedata_ready_7 = !_sb_maxi_memreq_writedata_tmp_valid_9;
  assign _sb_maxi_memreq_writedata_next_data_10 = (_sb_maxi_memreq_writedata_tmp_valid_9)? _sb_maxi_memreq_writedata_tmp_data_8 : _sb_maxi_memreq_writedata_s_data_2;
  assign _sb_maxi_memreq_writedata_next_valid_11 = _sb_maxi_memreq_writedata_tmp_valid_9 || _sb_maxi_memreq_writedata_s_valid_3;
  wire [8-1:0] _sb_maxi_memreq_writedata_m_value_12;
  assign _sb_maxi_memreq_writedata_m_value_12 = _sb_maxi_memreq_writedata_data_5[71:64];
  wire [64-1:0] _sb_maxi_memreq_writedata_m_value_13;
  assign _sb_maxi_memreq_writedata_m_value_13 = _sb_maxi_memreq_writedata_data_5[63:0];
  assign _maxi_memreq_wready_sb_0 = _sb_maxi_memreq_writedata_ready_7;
  assign maxi_memreq_wdata = _sb_maxi_memreq_writedata_m_value_13;
  assign maxi_memreq_wstrb = _sb_maxi_memreq_writedata_m_value_12;
  assign maxi_memreq_wvalid = _sb_maxi_memreq_writedata_valid_6;
  wire [2-1:0] maxi_memreq_bresp;
  wire maxi_memreq_bvalid;
  wire maxi_memreq_bready;
  assign maxi_memreq_bready = 1;
  reg [32-1:0] maxi_memreq_araddr;
  wire [4-1:0] maxi_memreq_arcache;
  wire [3-1:0] maxi_memreq_arprot;
  reg maxi_memreq_arvalid;
  wire maxi_memreq_arready;
  assign maxi_memreq_arcache = 3;
  assign maxi_memreq_arprot = 0;
  wire [64-1:0] maxi_memreq_rdata;
  wire [2-1:0] maxi_memreq_rresp;
  wire maxi_memreq_rvalid;
  wire maxi_memreq_rready;
  wire [64-1:0] _maxi_memreq_rdata_sb_0;
  wire _maxi_memreq_rvalid_sb_0;
  wire _maxi_memreq_rready_sb_0;
  wire [64-1:0] _sb_maxi_memreq_readdata_s_value_14;
  assign _sb_maxi_memreq_readdata_s_value_14 = maxi_memreq_rdata;
  wire [64-1:0] _sb_maxi_memreq_readdata_s_data_15;
  assign _sb_maxi_memreq_readdata_s_data_15 = { _sb_maxi_memreq_readdata_s_value_14 };
  wire _sb_maxi_memreq_readdata_s_valid_16;
  assign _sb_maxi_memreq_readdata_s_valid_16 = maxi_memreq_rvalid;
  wire _sb_maxi_memreq_readdata_m_ready_17;
  assign _sb_maxi_memreq_readdata_m_ready_17 = _maxi_memreq_rready_sb_0;
  reg [64-1:0] _sb_maxi_memreq_readdata_data_18;
  reg _sb_maxi_memreq_readdata_valid_19;
  wire _sb_maxi_memreq_readdata_ready_20;
  reg [64-1:0] _sb_maxi_memreq_readdata_tmp_data_21;
  reg _sb_maxi_memreq_readdata_tmp_valid_22;
  wire [64-1:0] _sb_maxi_memreq_readdata_next_data_23;
  wire _sb_maxi_memreq_readdata_next_valid_24;
  assign _sb_maxi_memreq_readdata_ready_20 = !_sb_maxi_memreq_readdata_tmp_valid_22;
  assign _sb_maxi_memreq_readdata_next_data_23 = (_sb_maxi_memreq_readdata_tmp_valid_22)? _sb_maxi_memreq_readdata_tmp_data_21 : _sb_maxi_memreq_readdata_s_data_15;
  assign _sb_maxi_memreq_readdata_next_valid_24 = _sb_maxi_memreq_readdata_tmp_valid_22 || _sb_maxi_memreq_readdata_s_valid_16;
  wire [64-1:0] _sb_maxi_memreq_readdata_m_value_25;
  assign _sb_maxi_memreq_readdata_m_value_25 = _sb_maxi_memreq_readdata_data_18[63:0];
  assign _maxi_memreq_rdata_sb_0 = _sb_maxi_memreq_readdata_m_value_25;
  assign _maxi_memreq_rvalid_sb_0 = _sb_maxi_memreq_readdata_valid_19;
  assign maxi_memreq_rready = _sb_maxi_memreq_readdata_ready_20;
  reg [3-1:0] _maxi_memreq_outstanding_wcount;
  wire _maxi_memreq_has_outstanding_write;
  assign _maxi_memreq_has_outstanding_write = (_maxi_memreq_outstanding_wcount > 0) || maxi_memreq_awvalid;
  wire [32-1:0] _tmp_26;
  assign _tmp_26 = maxi_memreq_awaddr;

  always @(*) begin
    axi_s_ctrl_memreq_awaddr = _tmp_26;
  end

  wire [4-1:0] _tmp_27;
  assign _tmp_27 = maxi_memreq_awcache;

  always @(*) begin
    axi_s_ctrl_memreq_awcache = _tmp_27;
  end

  wire [3-1:0] _tmp_28;
  assign _tmp_28 = maxi_memreq_awprot;

  always @(*) begin
    axi_s_ctrl_memreq_awprot = _tmp_28;
  end

  wire _tmp_29;
  assign _tmp_29 = maxi_memreq_awvalid;

  always @(*) begin
    axi_s_ctrl_memreq_awvalid = _tmp_29;
  end

  assign maxi_memreq_awready = axi_s_ctrl_memreq_awready;
  wire [64-1:0] _tmp_30;
  assign _tmp_30 = maxi_memreq_wdata;

  always @(*) begin
    axi_s_ctrl_memreq_wdata = _tmp_30;
  end

  wire [8-1:0] _tmp_31;
  assign _tmp_31 = maxi_memreq_wstrb;

  always @(*) begin
    axi_s_ctrl_memreq_wstrb = _tmp_31;
  end

  wire _tmp_32;
  assign _tmp_32 = maxi_memreq_wvalid;

  always @(*) begin
    axi_s_ctrl_memreq_wvalid = _tmp_32;
  end

  assign maxi_memreq_wready = axi_s_ctrl_memreq_wready;
  assign maxi_memreq_bresp = axi_s_ctrl_memreq_bresp;
  assign maxi_memreq_bvalid = axi_s_ctrl_memreq_bvalid;
  wire _tmp_33;
  assign _tmp_33 = maxi_memreq_bready;

  always @(*) begin
    axi_s_ctrl_memreq_bready = _tmp_33;
  end

  wire [32-1:0] _tmp_34;
  assign _tmp_34 = maxi_memreq_araddr;

  always @(*) begin
    axi_s_ctrl_memreq_araddr = _tmp_34;
  end

  wire [4-1:0] _tmp_35;
  assign _tmp_35 = maxi_memreq_arcache;

  always @(*) begin
    axi_s_ctrl_memreq_arcache = _tmp_35;
  end

  wire [3-1:0] _tmp_36;
  assign _tmp_36 = maxi_memreq_arprot;

  always @(*) begin
    axi_s_ctrl_memreq_arprot = _tmp_36;
  end

  wire _tmp_37;
  assign _tmp_37 = maxi_memreq_arvalid;

  always @(*) begin
    axi_s_ctrl_memreq_arvalid = _tmp_37;
  end

  assign maxi_memreq_arready = axi_s_ctrl_memreq_arready;
  assign maxi_memreq_rdata = axi_s_ctrl_memreq_rdata;
  assign maxi_memreq_rresp = axi_s_ctrl_memreq_rresp;
  assign maxi_memreq_rvalid = axi_s_ctrl_memreq_rvalid;
  wire _tmp_38;
  assign _tmp_38 = maxi_memreq_rready;

  always @(*) begin
    axi_s_ctrl_memreq_rready = _tmp_38;
  end

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
  wire [128-1:0] pack_write_data_wdata_39;
  wire [16-1:0] pack_write_data_wstrb_40;
  wire [1-1:0] pack_write_data_wlast_41;
  assign pack_write_data_wdata_39 = memory_wdata;
  assign pack_write_data_wstrb_40 = memory_wstrb;
  assign pack_write_data_wlast_41 = memory_wlast;
  wire [145-1:0] pack_write_data_packed_42;
  assign pack_write_data_packed_42 = { pack_write_data_wlast_41, pack_write_data_wstrb_40, pack_write_data_wdata_39 };
  assign _memory_wdata_fifo_wdata = (memory_wvalid && memory_wready)? pack_write_data_packed_42 : 'hx;
  assign _memory_wdata_fifo_enq = (memory_wvalid && memory_wready)? memory_wvalid && memory_wready && !_memory_wdata_fifo_almost_full : 0;
  localparam _tmp_43 = 1;
  wire [_tmp_43-1:0] _tmp_44;
  assign _tmp_44 = !_memory_wdata_fifo_almost_full;
  reg [_tmp_43-1:0] __tmp_44_1;
  reg [8-1:0] _memory_mem [0:2**20-1];

  initial begin
    $readmemh("/home/ozaki/rocket/rocket-chip/mmio_project/rocket_simulation/mmio_module/src/memimg_gi8ovg3k.out", _memory_mem);
  end

  reg [33-1:0] _write_count;
  reg [32-1:0] _write_addr;
  reg [33-1:0] _read_count;
  reg [32-1:0] _read_addr;
  reg [33-1:0] _sleep_interval_count;
  reg [33-1:0] _keep_sleep_count;
  wire [32-1:0] pack_write_req_global_addr_45;
  wire [9-1:0] pack_write_req_size_46;
  assign pack_write_req_global_addr_45 = memory_awaddr;
  assign pack_write_req_size_46 = memory_awlen + 1;
  wire [41-1:0] pack_write_req_packed_47;
  assign pack_write_req_packed_47 = { pack_write_req_global_addr_45, pack_write_req_size_46 };
  assign _memory_wreq_fifo_wdata = ((_memory_waddr_fsm == 11) && memory_awvalid && memory_awready)? pack_write_req_packed_47 : 'hx;
  assign _memory_wreq_fifo_enq = ((_memory_waddr_fsm == 11) && memory_awvalid && memory_awready)? (_memory_waddr_fsm == 11) && memory_awvalid && memory_awready && !_memory_wreq_fifo_almost_full : 0;
  localparam _tmp_48 = 1;
  wire [_tmp_48-1:0] _tmp_49;
  assign _tmp_49 = !_memory_wreq_fifo_almost_full;
  reg [_tmp_48-1:0] __tmp_49_1;
  wire [32-1:0] unpack_write_req_global_addr_50;
  wire [9-1:0] unpack_write_req_size_51;
  assign unpack_write_req_global_addr_50 = _memory_wreq_fifo_rdata[40:9];
  assign unpack_write_req_size_51 = _memory_wreq_fifo_rdata[8:0];
  assign _memory_wreq_fifo_deq = ((_memory_wdata_fsm == 0) && !_memory_wreq_fifo_empty && !_memory_wreq_fifo_empty)? 1 : 0;
  wire [128-1:0] pack_write_data_wdata_52;
  wire [16-1:0] pack_write_data_wstrb_53;
  wire [1-1:0] pack_write_data_wlast_54;
  assign pack_write_data_wdata_52 = _memory_wdata_fifo_rdata[127:0];
  assign pack_write_data_wstrb_53 = _memory_wdata_fifo_rdata[143:128];
  assign pack_write_data_wlast_54 = _memory_wdata_fifo_rdata[144];
  wire write_data_wvalid_55;
  assign write_data_wvalid_55 = !_memory_wdata_fifo_empty;
  wire write_data_wready_56;
  assign write_data_wready_56 = (_memory_wdata_fsm == 1) && (_sleep_interval_count != 15);
  assign _memory_wdata_fifo_deq = (write_data_wready_56 && !_memory_wdata_fifo_empty && !_memory_wdata_fifo_empty)? 1 : 0;
  wire [32-1:0] pack_read_req_global_addr_57;
  wire [9-1:0] pack_read_req_size_58;
  assign pack_read_req_global_addr_57 = memory_araddr;
  assign pack_read_req_size_58 = memory_arlen + 1;
  wire [41-1:0] pack_read_req_packed_59;
  assign pack_read_req_packed_59 = { pack_read_req_global_addr_57, pack_read_req_size_58 };
  assign _memory_rreq_fifo_wdata = ((_memory_raddr_fsm == 1) && memory_arvalid && memory_arready)? pack_read_req_packed_59 : 'hx;
  assign _memory_rreq_fifo_enq = ((_memory_raddr_fsm == 1) && memory_arvalid && memory_arready)? (_memory_raddr_fsm == 1) && memory_arvalid && memory_arready && !_memory_rreq_fifo_almost_full : 0;
  localparam _tmp_60 = 1;
  wire [_tmp_60-1:0] _tmp_61;
  assign _tmp_61 = !_memory_rreq_fifo_almost_full;
  reg [_tmp_60-1:0] __tmp_61_1;
  wire [32-1:0] unpack_read_req_global_addr_62;
  wire [9-1:0] unpack_read_req_size_63;
  assign unpack_read_req_global_addr_62 = _memory_rreq_fifo_rdata[40:9];
  assign unpack_read_req_size_63 = _memory_rreq_fifo_rdata[8:0];
  assign _memory_rreq_fifo_deq = ((_memory_rdata_fsm == 0) && !_memory_rreq_fifo_empty && !_memory_rreq_fifo_empty)? 1 : 0;
  reg [32-1:0] _d1__memory_rdata_fsm;
  reg __memory_rdata_fsm_cond_11_0_1;
  assign memory_awaddr = axi_m_llc_awaddr;
  assign memory_awlen = axi_m_llc_awlen;
  assign memory_awsize = axi_m_llc_awsize;
  assign memory_awburst = axi_m_llc_awburst;
  assign memory_awlock = axi_m_llc_awlock;
  assign memory_awcache = axi_m_llc_awcache;
  assign memory_awprot = axi_m_llc_awprot;
  assign memory_awqos = axi_m_llc_awqos;
  assign memory_awuser = axi_m_llc_awuser;
  assign memory_awvalid = axi_m_llc_awvalid;
  wire _tmp_64;
  assign _tmp_64 = memory_awready;

  always @(*) begin
    axi_m_llc_awready = _tmp_64;
  end

  assign memory_wdata = axi_m_llc_wdata;
  assign memory_wstrb = axi_m_llc_wstrb;
  assign memory_wlast = axi_m_llc_wlast;
  assign memory_wvalid = axi_m_llc_wvalid;
  wire _tmp_65;
  assign _tmp_65 = memory_wready;

  always @(*) begin
    axi_m_llc_wready = _tmp_65;
  end

  wire [2-1:0] _tmp_66;
  assign _tmp_66 = memory_bresp;

  always @(*) begin
    axi_m_llc_bresp = _tmp_66;
  end

  wire _tmp_67;
  assign _tmp_67 = memory_bvalid;

  always @(*) begin
    axi_m_llc_bvalid = _tmp_67;
  end

  assign memory_bready = axi_m_llc_bready;
  assign memory_araddr = axi_m_llc_araddr;
  assign memory_arlen = axi_m_llc_arlen;
  assign memory_arsize = axi_m_llc_arsize;
  assign memory_arburst = axi_m_llc_arburst;
  assign memory_arlock = axi_m_llc_arlock;
  assign memory_arcache = axi_m_llc_arcache;
  assign memory_arprot = axi_m_llc_arprot;
  assign memory_arqos = axi_m_llc_arqos;
  assign memory_aruser = axi_m_llc_aruser;
  assign memory_arvalid = axi_m_llc_arvalid;
  wire _tmp_68;
  assign _tmp_68 = memory_arready;

  always @(*) begin
    axi_m_llc_arready = _tmp_68;
  end

  wire [128-1:0] _tmp_69;
  assign _tmp_69 = memory_rdata;

  always @(*) begin
    axi_m_llc_rdata = _tmp_69;
  end

  wire [2-1:0] _tmp_70;
  assign _tmp_70 = memory_rresp;

  always @(*) begin
    axi_m_llc_rresp = _tmp_70;
  end

  wire _tmp_71;
  assign _tmp_71 = memory_rlast;

  always @(*) begin
    axi_m_llc_rlast = _tmp_71;
  end

  wire _tmp_72;
  assign _tmp_72 = memory_rvalid;

  always @(*) begin
    axi_m_llc_rvalid = _tmp_72;
  end

  assign memory_rready = axi_m_llc_rready;
  reg [32-1:0] th_ctrl;
  localparam th_ctrl_init = 0;
  reg _maxi_memreq_waddr_cond_0_1;
  reg _maxi_memreq_wdata_cond_0_1;
  reg _maxi_memreq_waddr_cond_1_1;
  reg _maxi_memreq_wdata_cond_1_1;

  memreq
  uut
  (
    .CLK(CLK),
    .RST(RST),
    .axi_s_ctrl_memreq_awaddr(axi_s_ctrl_memreq_awaddr),
    .axi_s_ctrl_memreq_awcache(axi_s_ctrl_memreq_awcache),
    .axi_s_ctrl_memreq_awprot(axi_s_ctrl_memreq_awprot),
    .axi_s_ctrl_memreq_awvalid(axi_s_ctrl_memreq_awvalid),
    .axi_s_ctrl_memreq_awready(axi_s_ctrl_memreq_awready),
    .axi_s_ctrl_memreq_wdata(axi_s_ctrl_memreq_wdata),
    .axi_s_ctrl_memreq_wstrb(axi_s_ctrl_memreq_wstrb),
    .axi_s_ctrl_memreq_wvalid(axi_s_ctrl_memreq_wvalid),
    .axi_s_ctrl_memreq_wready(axi_s_ctrl_memreq_wready),
    .axi_s_ctrl_memreq_bresp(axi_s_ctrl_memreq_bresp),
    .axi_s_ctrl_memreq_bvalid(axi_s_ctrl_memreq_bvalid),
    .axi_s_ctrl_memreq_bready(axi_s_ctrl_memreq_bready),
    .axi_s_ctrl_memreq_araddr(axi_s_ctrl_memreq_araddr),
    .axi_s_ctrl_memreq_arcache(axi_s_ctrl_memreq_arcache),
    .axi_s_ctrl_memreq_arprot(axi_s_ctrl_memreq_arprot),
    .axi_s_ctrl_memreq_arvalid(axi_s_ctrl_memreq_arvalid),
    .axi_s_ctrl_memreq_arready(axi_s_ctrl_memreq_arready),
    .axi_s_ctrl_memreq_rdata(axi_s_ctrl_memreq_rdata),
    .axi_s_ctrl_memreq_rresp(axi_s_ctrl_memreq_rresp),
    .axi_s_ctrl_memreq_rvalid(axi_s_ctrl_memreq_rvalid),
    .axi_s_ctrl_memreq_rready(axi_s_ctrl_memreq_rready),
    .axi_m_llc_awaddr(axi_m_llc_awaddr),
    .axi_m_llc_awlen(axi_m_llc_awlen),
    .axi_m_llc_awsize(axi_m_llc_awsize),
    .axi_m_llc_awburst(axi_m_llc_awburst),
    .axi_m_llc_awlock(axi_m_llc_awlock),
    .axi_m_llc_awcache(axi_m_llc_awcache),
    .axi_m_llc_awprot(axi_m_llc_awprot),
    .axi_m_llc_awqos(axi_m_llc_awqos),
    .axi_m_llc_awuser(axi_m_llc_awuser),
    .axi_m_llc_awvalid(axi_m_llc_awvalid),
    .axi_m_llc_awready(axi_m_llc_awready),
    .axi_m_llc_wdata(axi_m_llc_wdata),
    .axi_m_llc_wstrb(axi_m_llc_wstrb),
    .axi_m_llc_wlast(axi_m_llc_wlast),
    .axi_m_llc_wvalid(axi_m_llc_wvalid),
    .axi_m_llc_wready(axi_m_llc_wready),
    .axi_m_llc_bresp(axi_m_llc_bresp),
    .axi_m_llc_bvalid(axi_m_llc_bvalid),
    .axi_m_llc_bready(axi_m_llc_bready),
    .axi_m_llc_araddr(axi_m_llc_araddr),
    .axi_m_llc_arlen(axi_m_llc_arlen),
    .axi_m_llc_arsize(axi_m_llc_arsize),
    .axi_m_llc_arburst(axi_m_llc_arburst),
    .axi_m_llc_arlock(axi_m_llc_arlock),
    .axi_m_llc_arcache(axi_m_llc_arcache),
    .axi_m_llc_arprot(axi_m_llc_arprot),
    .axi_m_llc_arqos(axi_m_llc_arqos),
    .axi_m_llc_aruser(axi_m_llc_aruser),
    .axi_m_llc_arvalid(axi_m_llc_arvalid),
    .axi_m_llc_arready(axi_m_llc_arready),
    .axi_m_llc_rdata(axi_m_llc_rdata),
    .axi_m_llc_rresp(axi_m_llc_rresp),
    .axi_m_llc_rlast(axi_m_llc_rlast),
    .axi_m_llc_rvalid(axi_m_llc_rvalid),
    .axi_m_llc_rready(axi_m_llc_rready)
  );


  initial begin
    CLK = 0;
    forever begin
      #5 CLK = !CLK;
    end
  end


  initial begin
    RST = 0;
    maxi_memreq_awaddr = 0;
    maxi_memreq_awvalid = 0;
    _maxi_memreq_wdata_sb_0 = 0;
    _maxi_memreq_wstrb_sb_0 = 0;
    _maxi_memreq_wvalid_sb_0 = 0;
    _sb_maxi_memreq_writedata_data_5 = 0;
    _sb_maxi_memreq_writedata_valid_6 = 0;
    _sb_maxi_memreq_writedata_tmp_data_8 = 0;
    _sb_maxi_memreq_writedata_tmp_valid_9 = 0;
    maxi_memreq_araddr = 0;
    maxi_memreq_arvalid = 0;
    _sb_maxi_memreq_readdata_data_18 = 0;
    _sb_maxi_memreq_readdata_valid_19 = 0;
    _sb_maxi_memreq_readdata_tmp_data_21 = 0;
    _sb_maxi_memreq_readdata_tmp_valid_22 = 0;
    _maxi_memreq_outstanding_wcount = 0;
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
    __tmp_44_1 = 0;
    _write_count = 0;
    _write_addr = 0;
    _read_count = 0;
    _read_addr = 0;
    _sleep_interval_count = 0;
    _keep_sleep_count = 0;
    __tmp_49_1 = 0;
    __tmp_61_1 = 0;
    _d1__memory_rdata_fsm = _memory_rdata_fsm_init;
    __memory_rdata_fsm_cond_11_0_1 = 0;
    th_ctrl = th_ctrl_init;
    _maxi_memreq_waddr_cond_0_1 = 0;
    _maxi_memreq_wdata_cond_0_1 = 0;
    _maxi_memreq_waddr_cond_1_1 = 0;
    _maxi_memreq_wdata_cond_1_1 = 0;
    #100;
    RST = 1;
    #100;
    RST = 0;
    #1000000;
    $finish;
  end


  always @(posedge CLK) begin
    if(RST) begin
      maxi_memreq_awaddr <= 0;
      maxi_memreq_awvalid <= 0;
      _maxi_memreq_waddr_cond_0_1 <= 0;
      _maxi_memreq_waddr_cond_1_1 <= 0;
    end else begin
      if(_maxi_memreq_waddr_cond_0_1) begin
        maxi_memreq_awvalid <= 0;
      end 
      if(_maxi_memreq_waddr_cond_1_1) begin
        maxi_memreq_awvalid <= 0;
      end 
      if((th_ctrl == 1) && ((_maxi_memreq_outstanding_wcount == 0) && (maxi_memreq_awready || !maxi_memreq_awvalid))) begin
        maxi_memreq_awaddr <= 0;
        maxi_memreq_awvalid <= 1;
      end 
      _maxi_memreq_waddr_cond_0_1 <= 1;
      if(maxi_memreq_awvalid && !maxi_memreq_awready) begin
        maxi_memreq_awvalid <= maxi_memreq_awvalid;
      end 
      if((th_ctrl == 6) && ((_maxi_memreq_outstanding_wcount == 0) && (maxi_memreq_awready || !maxi_memreq_awvalid))) begin
        maxi_memreq_awaddr <= 8;
        maxi_memreq_awvalid <= 1;
      end 
      _maxi_memreq_waddr_cond_1_1 <= 1;
      if(maxi_memreq_awvalid && !maxi_memreq_awready) begin
        maxi_memreq_awvalid <= maxi_memreq_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _maxi_memreq_wdata_sb_0 <= 0;
      _maxi_memreq_wvalid_sb_0 <= 0;
      _maxi_memreq_wstrb_sb_0 <= 0;
      _maxi_memreq_wdata_cond_0_1 <= 0;
      _maxi_memreq_wdata_cond_1_1 <= 0;
    end else begin
      if(_maxi_memreq_wdata_cond_0_1) begin
        _maxi_memreq_wvalid_sb_0 <= 0;
      end 
      if(_maxi_memreq_wdata_cond_1_1) begin
        _maxi_memreq_wvalid_sb_0 <= 0;
      end 
      if((th_ctrl == 3) && (_maxi_memreq_wready_sb_0 || !_maxi_memreq_wvalid_sb_0)) begin
        _maxi_memreq_wdata_sb_0 <= 1024;
        _maxi_memreq_wvalid_sb_0 <= 1;
        _maxi_memreq_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_memreq_wdata_cond_0_1 <= 1;
      if(_maxi_memreq_wvalid_sb_0 && !_maxi_memreq_wready_sb_0) begin
        _maxi_memreq_wvalid_sb_0 <= _maxi_memreq_wvalid_sb_0;
      end 
      if((th_ctrl == 8) && (_maxi_memreq_wready_sb_0 || !_maxi_memreq_wvalid_sb_0)) begin
        _maxi_memreq_wdata_sb_0 <= 16;
        _maxi_memreq_wvalid_sb_0 <= 1;
        _maxi_memreq_wstrb_sb_0 <= { 8{ 1'd1 } };
      end 
      _maxi_memreq_wdata_cond_1_1 <= 1;
      if(_maxi_memreq_wvalid_sb_0 && !_maxi_memreq_wready_sb_0) begin
        _maxi_memreq_wvalid_sb_0 <= _maxi_memreq_wvalid_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_memreq_writedata_data_5 <= 0;
      _sb_maxi_memreq_writedata_valid_6 <= 0;
      _sb_maxi_memreq_writedata_tmp_data_8 <= 0;
      _sb_maxi_memreq_writedata_tmp_valid_9 <= 0;
    end else begin
      if(_sb_maxi_memreq_writedata_m_ready_4 || !_sb_maxi_memreq_writedata_valid_6) begin
        _sb_maxi_memreq_writedata_data_5 <= _sb_maxi_memreq_writedata_next_data_10;
        _sb_maxi_memreq_writedata_valid_6 <= _sb_maxi_memreq_writedata_next_valid_11;
      end 
      if(!_sb_maxi_memreq_writedata_tmp_valid_9 && _sb_maxi_memreq_writedata_valid_6 && !_sb_maxi_memreq_writedata_m_ready_4) begin
        _sb_maxi_memreq_writedata_tmp_data_8 <= _sb_maxi_memreq_writedata_s_data_2;
        _sb_maxi_memreq_writedata_tmp_valid_9 <= _sb_maxi_memreq_writedata_s_valid_3;
      end 
      if(_sb_maxi_memreq_writedata_tmp_valid_9 && _sb_maxi_memreq_writedata_m_ready_4) begin
        _sb_maxi_memreq_writedata_tmp_valid_9 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_maxi_memreq_readdata_data_18 <= 0;
      _sb_maxi_memreq_readdata_valid_19 <= 0;
      _sb_maxi_memreq_readdata_tmp_data_21 <= 0;
      _sb_maxi_memreq_readdata_tmp_valid_22 <= 0;
    end else begin
      if(_sb_maxi_memreq_readdata_m_ready_17 || !_sb_maxi_memreq_readdata_valid_19) begin
        _sb_maxi_memreq_readdata_data_18 <= _sb_maxi_memreq_readdata_next_data_23;
        _sb_maxi_memreq_readdata_valid_19 <= _sb_maxi_memreq_readdata_next_valid_24;
      end 
      if(!_sb_maxi_memreq_readdata_tmp_valid_22 && _sb_maxi_memreq_readdata_valid_19 && !_sb_maxi_memreq_readdata_m_ready_17) begin
        _sb_maxi_memreq_readdata_tmp_data_21 <= _sb_maxi_memreq_readdata_s_data_15;
        _sb_maxi_memreq_readdata_tmp_valid_22 <= _sb_maxi_memreq_readdata_s_valid_16;
      end 
      if(_sb_maxi_memreq_readdata_tmp_valid_22 && _sb_maxi_memreq_readdata_m_ready_17) begin
        _sb_maxi_memreq_readdata_tmp_valid_22 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _maxi_memreq_outstanding_wcount <= 0;
    end else begin
      if(maxi_memreq_awvalid && maxi_memreq_awready && !(maxi_memreq_bvalid && maxi_memreq_bready) && (_maxi_memreq_outstanding_wcount < 7)) begin
        _maxi_memreq_outstanding_wcount <= _maxi_memreq_outstanding_wcount + 1;
      end 
      if(!(maxi_memreq_awvalid && maxi_memreq_awready) && (maxi_memreq_bvalid && maxi_memreq_bready) && (_maxi_memreq_outstanding_wcount > 0)) begin
        _maxi_memreq_outstanding_wcount <= _maxi_memreq_outstanding_wcount - 1;
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
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[0]) begin
        _memory_mem[_write_addr + 0] <= pack_write_data_wdata_52[7:0];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[1]) begin
        _memory_mem[_write_addr + 1] <= pack_write_data_wdata_52[15:8];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[2]) begin
        _memory_mem[_write_addr + 2] <= pack_write_data_wdata_52[23:16];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[3]) begin
        _memory_mem[_write_addr + 3] <= pack_write_data_wdata_52[31:24];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[4]) begin
        _memory_mem[_write_addr + 4] <= pack_write_data_wdata_52[39:32];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[5]) begin
        _memory_mem[_write_addr + 5] <= pack_write_data_wdata_52[47:40];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[6]) begin
        _memory_mem[_write_addr + 6] <= pack_write_data_wdata_52[55:48];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[7]) begin
        _memory_mem[_write_addr + 7] <= pack_write_data_wdata_52[63:56];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[8]) begin
        _memory_mem[_write_addr + 8] <= pack_write_data_wdata_52[71:64];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[9]) begin
        _memory_mem[_write_addr + 9] <= pack_write_data_wdata_52[79:72];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[10]) begin
        _memory_mem[_write_addr + 10] <= pack_write_data_wdata_52[87:80];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[11]) begin
        _memory_mem[_write_addr + 11] <= pack_write_data_wdata_52[95:88];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[12]) begin
        _memory_mem[_write_addr + 12] <= pack_write_data_wdata_52[103:96];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[13]) begin
        _memory_mem[_write_addr + 13] <= pack_write_data_wdata_52[111:104];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[14]) begin
        _memory_mem[_write_addr + 14] <= pack_write_data_wdata_52[119:112];
      end 
      if((_memory_wdata_fsm == 1) && write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wstrb_53[15]) begin
        _memory_mem[_write_addr + 15] <= pack_write_data_wdata_52[127:120];
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
            _write_addr <= unpack_write_req_global_addr_50;
            _write_count <= unpack_write_req_size_51;
          end 
          if(!_memory_wreq_fifo_empty) begin
            _memory_wdata_fsm <= _memory_wdata_fsm_1;
          end 
        end
        _memory_wdata_fsm_1: begin
          if(write_data_wvalid_55 && write_data_wready_56) begin
            _write_addr <= _write_addr + 16;
            _write_count <= _write_count - 1;
          end 
          if(write_data_wvalid_55 && write_data_wready_56 && (_write_count == 1)) begin
            memory_bvalid <= 1;
          end 
          if(write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wlast_54) begin
            memory_bvalid <= 1;
          end 
          if(write_data_wvalid_55 && write_data_wready_56 && (_write_count == 1)) begin
            _memory_wdata_fsm <= _memory_wdata_fsm_init;
          end 
          if(write_data_wvalid_55 && write_data_wready_56 && pack_write_data_wlast_54) begin
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
            _read_addr <= unpack_read_req_global_addr_62;
            _read_count <= unpack_read_req_size_63;
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
      __tmp_49_1 <= 0;
    end else begin
      if(_memory_wreq_fifo_enq && !_memory_wreq_fifo_full && (_memory_wreq_fifo_deq && !_memory_wreq_fifo_empty)) begin
        count__memory_wreq_fifo <= count__memory_wreq_fifo;
      end else if(_memory_wreq_fifo_enq && !_memory_wreq_fifo_full) begin
        count__memory_wreq_fifo <= count__memory_wreq_fifo + 1;
      end else if(_memory_wreq_fifo_deq && !_memory_wreq_fifo_empty) begin
        count__memory_wreq_fifo <= count__memory_wreq_fifo - 1;
      end 
      __tmp_49_1 <= _tmp_49;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__memory_rreq_fifo <= 0;
      __tmp_61_1 <= 0;
    end else begin
      if(_memory_rreq_fifo_enq && !_memory_rreq_fifo_full && (_memory_rreq_fifo_deq && !_memory_rreq_fifo_empty)) begin
        count__memory_rreq_fifo <= count__memory_rreq_fifo;
      end else if(_memory_rreq_fifo_enq && !_memory_rreq_fifo_full) begin
        count__memory_rreq_fifo <= count__memory_rreq_fifo + 1;
      end else if(_memory_rreq_fifo_deq && !_memory_rreq_fifo_empty) begin
        count__memory_rreq_fifo <= count__memory_rreq_fifo - 1;
      end 
      __tmp_61_1 <= _tmp_61;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__memory_wdata_fifo <= 0;
      __tmp_44_1 <= 0;
    end else begin
      if(_memory_wdata_fifo_enq && !_memory_wdata_fifo_full && (_memory_wdata_fifo_deq && !_memory_wdata_fifo_empty)) begin
        count__memory_wdata_fifo <= count__memory_wdata_fifo;
      end else if(_memory_wdata_fifo_enq && !_memory_wdata_fifo_full) begin
        count__memory_wdata_fifo <= count__memory_wdata_fifo + 1;
      end else if(_memory_wdata_fifo_deq && !_memory_wdata_fifo_empty) begin
        count__memory_wdata_fifo <= count__memory_wdata_fifo - 1;
      end 
      __tmp_44_1 <= _tmp_44;
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

  always @(posedge CLK) begin
    if(RST) begin
      th_ctrl <= th_ctrl_init;
    end else begin
      case(th_ctrl)
        th_ctrl_init: begin
          th_ctrl <= th_ctrl_1;
        end
        th_ctrl_1: begin
          if((_maxi_memreq_outstanding_wcount == 0) && (maxi_memreq_awready || !maxi_memreq_awvalid)) begin
            th_ctrl <= th_ctrl_2;
          end 
        end
        th_ctrl_2: begin
          if(maxi_memreq_awvalid && maxi_memreq_awready) begin
            th_ctrl <= th_ctrl_3;
          end 
        end
        th_ctrl_3: begin
          if(_maxi_memreq_wready_sb_0 || !_maxi_memreq_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_4;
          end 
        end
        th_ctrl_4: begin
          if(_maxi_memreq_wvalid_sb_0 && _maxi_memreq_wready_sb_0) begin
            th_ctrl <= th_ctrl_5;
          end 
        end
        th_ctrl_5: begin
          if(!_maxi_memreq_has_outstanding_write) begin
            th_ctrl <= th_ctrl_6;
          end 
        end
        th_ctrl_6: begin
          if((_maxi_memreq_outstanding_wcount == 0) && (maxi_memreq_awready || !maxi_memreq_awvalid)) begin
            th_ctrl <= th_ctrl_7;
          end 
        end
        th_ctrl_7: begin
          if(maxi_memreq_awvalid && maxi_memreq_awready) begin
            th_ctrl <= th_ctrl_8;
          end 
        end
        th_ctrl_8: begin
          if(_maxi_memreq_wready_sb_0 || !_maxi_memreq_wvalid_sb_0) begin
            th_ctrl <= th_ctrl_9;
          end 
        end
        th_ctrl_9: begin
          if(_maxi_memreq_wvalid_sb_0 && _maxi_memreq_wready_sb_0) begin
            th_ctrl <= th_ctrl_10;
          end 
        end
        th_ctrl_10: begin
          if(!_maxi_memreq_has_outstanding_write) begin
            th_ctrl <= th_ctrl_11;
          end 
        end
      endcase
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



module memreq
(
  input CLK,
  input RST,
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
  input axi_s_ctrl_memreq_rready,
  output reg [32-1:0] axi_m_llc_awaddr,
  output reg [8-1:0] axi_m_llc_awlen,
  output [3-1:0] axi_m_llc_awsize,
  output [2-1:0] axi_m_llc_awburst,
  output [1-1:0] axi_m_llc_awlock,
  output [4-1:0] axi_m_llc_awcache,
  output [3-1:0] axi_m_llc_awprot,
  output [4-1:0] axi_m_llc_awqos,
  output [2-1:0] axi_m_llc_awuser,
  output reg axi_m_llc_awvalid,
  input axi_m_llc_awready,
  output [128-1:0] axi_m_llc_wdata,
  output [16-1:0] axi_m_llc_wstrb,
  output axi_m_llc_wlast,
  output axi_m_llc_wvalid,
  input axi_m_llc_wready,
  input [2-1:0] axi_m_llc_bresp,
  input axi_m_llc_bvalid,
  output axi_m_llc_bready,
  output reg [32-1:0] axi_m_llc_araddr,
  output reg [8-1:0] axi_m_llc_arlen,
  output [3-1:0] axi_m_llc_arsize,
  output [2-1:0] axi_m_llc_arburst,
  output [1-1:0] axi_m_llc_arlock,
  output [4-1:0] axi_m_llc_arcache,
  output [3-1:0] axi_m_llc_arprot,
  output [4-1:0] axi_m_llc_arqos,
  output [2-1:0] axi_m_llc_aruser,
  output reg axi_m_llc_arvalid,
  input axi_m_llc_arready,
  input [128-1:0] axi_m_llc_rdata,
  input [2-1:0] axi_m_llc_rresp,
  input axi_m_llc_rlast,
  input axi_m_llc_rvalid,
  output axi_m_llc_rready
);

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
  reg [32-1:0] addr_0;
  reg writevalid_1;
  reg readvalid_2;
  reg prev_awvalid_3;
  reg prev_arvalid_4;
  assign axi_s_ctrl_memreq_awready = (_axi_s_ctrl_memreq_register_fsm == 0) && (!writevalid_1 && !readvalid_2 && !axi_s_ctrl_memreq_bvalid && prev_awvalid_3);
  assign axi_s_ctrl_memreq_arready = (_axi_s_ctrl_memreq_register_fsm == 0) && (!readvalid_2 && !writevalid_1 && prev_arvalid_4 && !prev_awvalid_3);
  reg [_axi_s_ctrl_memreq_maskwidth-1:0] axis_maskaddr_5;
  wire signed [64-1:0] axislite_rdata_6;
  assign axislite_rdata_6 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_memreq_register_0 : 
                            (axis_maskaddr_5 == 1)? _axi_s_ctrl_memreq_register_1 : 
                            (axis_maskaddr_5 == 2)? _axi_s_ctrl_memreq_register_2 : 
                            (axis_maskaddr_5 == 3)? _axi_s_ctrl_memreq_register_3 : 
                            (axis_maskaddr_5 == 4)? _axi_s_ctrl_memreq_register_4 : 
                            (axis_maskaddr_5 == 5)? _axi_s_ctrl_memreq_register_5 : 
                            (axis_maskaddr_5 == 6)? _axi_s_ctrl_memreq_register_6 : 'hx;
  wire axislite_flag_7;
  assign axislite_flag_7 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_memreq_flag_0 : 
                           (axis_maskaddr_5 == 1)? _axi_s_ctrl_memreq_flag_1 : 
                           (axis_maskaddr_5 == 2)? _axi_s_ctrl_memreq_flag_2 : 
                           (axis_maskaddr_5 == 3)? _axi_s_ctrl_memreq_flag_3 : 
                           (axis_maskaddr_5 == 4)? _axi_s_ctrl_memreq_flag_4 : 
                           (axis_maskaddr_5 == 5)? _axi_s_ctrl_memreq_flag_5 : 
                           (axis_maskaddr_5 == 6)? _axi_s_ctrl_memreq_flag_6 : 'hx;
  wire signed [64-1:0] axislite_resetval_8;
  assign axislite_resetval_8 = (axis_maskaddr_5 == 0)? _axi_s_ctrl_memreq_resetval_0 : 
                               (axis_maskaddr_5 == 1)? _axi_s_ctrl_memreq_resetval_1 : 
                               (axis_maskaddr_5 == 2)? _axi_s_ctrl_memreq_resetval_2 : 
                               (axis_maskaddr_5 == 3)? _axi_s_ctrl_memreq_resetval_3 : 
                               (axis_maskaddr_5 == 4)? _axi_s_ctrl_memreq_resetval_4 : 
                               (axis_maskaddr_5 == 5)? _axi_s_ctrl_memreq_resetval_5 : 
                               (axis_maskaddr_5 == 6)? _axi_s_ctrl_memreq_resetval_6 : 'hx;
  reg _axi_s_ctrl_memreq_rdata_cond_0_1;
  assign axi_s_ctrl_memreq_wready = _axi_s_ctrl_memreq_register_fsm == 3;
  assign axi_m_llc_awsize = 4;
  assign axi_m_llc_awburst = 1;
  assign axi_m_llc_awlock = 0;
  assign axi_m_llc_awcache = 3;
  assign axi_m_llc_awprot = 0;
  assign axi_m_llc_awqos = 0;
  assign axi_m_llc_awuser = 0;
  reg [128-1:0] _axi_m_llc_wdata_sb_0;
  reg [16-1:0] _axi_m_llc_wstrb_sb_0;
  reg _axi_m_llc_wlast_sb_0;
  reg _axi_m_llc_wvalid_sb_0;
  wire _axi_m_llc_wready_sb_0;
  wire _sb_axi_m_llc_writedata_s_value_9;
  assign _sb_axi_m_llc_writedata_s_value_9 = _axi_m_llc_wlast_sb_0;
  wire [16-1:0] _sb_axi_m_llc_writedata_s_value_10;
  assign _sb_axi_m_llc_writedata_s_value_10 = _axi_m_llc_wstrb_sb_0;
  wire [128-1:0] _sb_axi_m_llc_writedata_s_value_11;
  assign _sb_axi_m_llc_writedata_s_value_11 = _axi_m_llc_wdata_sb_0;
  wire [145-1:0] _sb_axi_m_llc_writedata_s_data_12;
  assign _sb_axi_m_llc_writedata_s_data_12 = { _sb_axi_m_llc_writedata_s_value_9, _sb_axi_m_llc_writedata_s_value_10, _sb_axi_m_llc_writedata_s_value_11 };
  wire _sb_axi_m_llc_writedata_s_valid_13;
  assign _sb_axi_m_llc_writedata_s_valid_13 = _axi_m_llc_wvalid_sb_0;
  wire _sb_axi_m_llc_writedata_m_ready_14;
  assign _sb_axi_m_llc_writedata_m_ready_14 = axi_m_llc_wready;
  reg [145-1:0] _sb_axi_m_llc_writedata_data_15;
  reg _sb_axi_m_llc_writedata_valid_16;
  wire _sb_axi_m_llc_writedata_ready_17;
  reg [145-1:0] _sb_axi_m_llc_writedata_tmp_data_18;
  reg _sb_axi_m_llc_writedata_tmp_valid_19;
  wire [145-1:0] _sb_axi_m_llc_writedata_next_data_20;
  wire _sb_axi_m_llc_writedata_next_valid_21;
  assign _sb_axi_m_llc_writedata_ready_17 = !_sb_axi_m_llc_writedata_tmp_valid_19;
  assign _sb_axi_m_llc_writedata_next_data_20 = (_sb_axi_m_llc_writedata_tmp_valid_19)? _sb_axi_m_llc_writedata_tmp_data_18 : _sb_axi_m_llc_writedata_s_data_12;
  assign _sb_axi_m_llc_writedata_next_valid_21 = _sb_axi_m_llc_writedata_tmp_valid_19 || _sb_axi_m_llc_writedata_s_valid_13;
  wire _sb_axi_m_llc_writedata_m_value_22;
  assign _sb_axi_m_llc_writedata_m_value_22 = _sb_axi_m_llc_writedata_data_15[144:144];
  wire [16-1:0] _sb_axi_m_llc_writedata_m_value_23;
  assign _sb_axi_m_llc_writedata_m_value_23 = _sb_axi_m_llc_writedata_data_15[143:128];
  wire [128-1:0] _sb_axi_m_llc_writedata_m_value_24;
  assign _sb_axi_m_llc_writedata_m_value_24 = _sb_axi_m_llc_writedata_data_15[127:0];
  assign _axi_m_llc_wready_sb_0 = _sb_axi_m_llc_writedata_ready_17;
  assign axi_m_llc_wdata = _sb_axi_m_llc_writedata_m_value_24;
  assign axi_m_llc_wstrb = _sb_axi_m_llc_writedata_m_value_23;
  assign axi_m_llc_wlast = _sb_axi_m_llc_writedata_m_value_22;
  assign axi_m_llc_wvalid = _sb_axi_m_llc_writedata_valid_16;
  assign axi_m_llc_bready = 1;
  assign axi_m_llc_arsize = 4;
  assign axi_m_llc_arburst = 1;
  assign axi_m_llc_arlock = 0;
  assign axi_m_llc_arcache = 3;
  assign axi_m_llc_arprot = 0;
  assign axi_m_llc_arqos = 0;
  assign axi_m_llc_aruser = 0;
  wire [128-1:0] _axi_m_llc_rdata_sb_0;
  wire _axi_m_llc_rlast_sb_0;
  wire _axi_m_llc_rvalid_sb_0;
  wire _axi_m_llc_rready_sb_0;
  wire _sb_axi_m_llc_readdata_s_value_25;
  assign _sb_axi_m_llc_readdata_s_value_25 = axi_m_llc_rlast;
  wire [128-1:0] _sb_axi_m_llc_readdata_s_value_26;
  assign _sb_axi_m_llc_readdata_s_value_26 = axi_m_llc_rdata;
  wire [129-1:0] _sb_axi_m_llc_readdata_s_data_27;
  assign _sb_axi_m_llc_readdata_s_data_27 = { _sb_axi_m_llc_readdata_s_value_25, _sb_axi_m_llc_readdata_s_value_26 };
  wire _sb_axi_m_llc_readdata_s_valid_28;
  assign _sb_axi_m_llc_readdata_s_valid_28 = axi_m_llc_rvalid;
  wire _sb_axi_m_llc_readdata_m_ready_29;
  assign _sb_axi_m_llc_readdata_m_ready_29 = _axi_m_llc_rready_sb_0;
  reg [129-1:0] _sb_axi_m_llc_readdata_data_30;
  reg _sb_axi_m_llc_readdata_valid_31;
  wire _sb_axi_m_llc_readdata_ready_32;
  reg [129-1:0] _sb_axi_m_llc_readdata_tmp_data_33;
  reg _sb_axi_m_llc_readdata_tmp_valid_34;
  wire [129-1:0] _sb_axi_m_llc_readdata_next_data_35;
  wire _sb_axi_m_llc_readdata_next_valid_36;
  assign _sb_axi_m_llc_readdata_ready_32 = !_sb_axi_m_llc_readdata_tmp_valid_34;
  assign _sb_axi_m_llc_readdata_next_data_35 = (_sb_axi_m_llc_readdata_tmp_valid_34)? _sb_axi_m_llc_readdata_tmp_data_33 : _sb_axi_m_llc_readdata_s_data_27;
  assign _sb_axi_m_llc_readdata_next_valid_36 = _sb_axi_m_llc_readdata_tmp_valid_34 || _sb_axi_m_llc_readdata_s_valid_28;
  wire _sb_axi_m_llc_readdata_m_value_37;
  assign _sb_axi_m_llc_readdata_m_value_37 = _sb_axi_m_llc_readdata_data_30[128:128];
  wire [128-1:0] _sb_axi_m_llc_readdata_m_value_38;
  assign _sb_axi_m_llc_readdata_m_value_38 = _sb_axi_m_llc_readdata_data_30[127:0];
  assign _axi_m_llc_rdata_sb_0 = _sb_axi_m_llc_readdata_m_value_38;
  assign _axi_m_llc_rlast_sb_0 = _sb_axi_m_llc_readdata_m_value_37;
  assign _axi_m_llc_rvalid_sb_0 = _sb_axi_m_llc_readdata_valid_31;
  assign axi_m_llc_rready = _sb_axi_m_llc_readdata_ready_32;
  reg [3-1:0] _axi_m_llc_outstanding_wcount;
  wire _axi_m_llc_has_outstanding_write;
  assign _axi_m_llc_has_outstanding_write = (_axi_m_llc_outstanding_wcount > 0) || axi_m_llc_awvalid;
  reg _axi_m_llc_read_start;
  reg [8-1:0] _axi_m_llc_read_op_sel;
  reg [32-1:0] _axi_m_llc_read_global_addr;
  reg [33-1:0] _axi_m_llc_read_global_size;
  reg [32-1:0] _axi_m_llc_read_local_addr;
  reg [32-1:0] _axi_m_llc_read_local_stride;
  reg [33-1:0] _axi_m_llc_read_local_size;
  reg [32-1:0] _axi_m_llc_read_local_blocksize;
  wire _axi_m_llc_read_req_fifo_enq;
  wire [137-1:0] _axi_m_llc_read_req_fifo_wdata;
  wire _axi_m_llc_read_req_fifo_full;
  wire _axi_m_llc_read_req_fifo_almost_full;
  wire _axi_m_llc_read_req_fifo_deq;
  wire [137-1:0] _axi_m_llc_read_req_fifo_rdata;
  wire _axi_m_llc_read_req_fifo_empty;
  wire _axi_m_llc_read_req_fifo_almost_empty;

  _axi_m_llc_read_req_fifo
  inst__axi_m_llc_read_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axi_m_llc_read_req_fifo_enq(_axi_m_llc_read_req_fifo_enq),
    ._axi_m_llc_read_req_fifo_wdata(_axi_m_llc_read_req_fifo_wdata),
    ._axi_m_llc_read_req_fifo_full(_axi_m_llc_read_req_fifo_full),
    ._axi_m_llc_read_req_fifo_almost_full(_axi_m_llc_read_req_fifo_almost_full),
    ._axi_m_llc_read_req_fifo_deq(_axi_m_llc_read_req_fifo_deq),
    ._axi_m_llc_read_req_fifo_rdata(_axi_m_llc_read_req_fifo_rdata),
    ._axi_m_llc_read_req_fifo_empty(_axi_m_llc_read_req_fifo_empty),
    ._axi_m_llc_read_req_fifo_almost_empty(_axi_m_llc_read_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axi_m_llc_read_req_fifo;
  wire [8-1:0] _axi_m_llc_read_op_sel_fifo;
  wire [32-1:0] _axi_m_llc_read_local_addr_fifo;
  wire [32-1:0] _axi_m_llc_read_local_stride_fifo;
  wire [33-1:0] _axi_m_llc_read_local_size_fifo;
  wire [32-1:0] _axi_m_llc_read_local_blocksize_fifo;
  wire [8-1:0] unpack_read_req_op_sel_39;
  wire [32-1:0] unpack_read_req_local_addr_40;
  wire [32-1:0] unpack_read_req_local_stride_41;
  wire [33-1:0] unpack_read_req_local_size_42;
  wire [32-1:0] unpack_read_req_local_blocksize_43;
  assign unpack_read_req_op_sel_39 = _axi_m_llc_read_req_fifo_rdata[136:129];
  assign unpack_read_req_local_addr_40 = _axi_m_llc_read_req_fifo_rdata[128:97];
  assign unpack_read_req_local_stride_41 = _axi_m_llc_read_req_fifo_rdata[96:65];
  assign unpack_read_req_local_size_42 = _axi_m_llc_read_req_fifo_rdata[64:32];
  assign unpack_read_req_local_blocksize_43 = _axi_m_llc_read_req_fifo_rdata[31:0];
  assign _axi_m_llc_read_op_sel_fifo = unpack_read_req_op_sel_39;
  assign _axi_m_llc_read_local_addr_fifo = unpack_read_req_local_addr_40;
  assign _axi_m_llc_read_local_stride_fifo = unpack_read_req_local_stride_41;
  assign _axi_m_llc_read_local_size_fifo = unpack_read_req_local_size_42;
  assign _axi_m_llc_read_local_blocksize_fifo = unpack_read_req_local_blocksize_43;
  reg [8-1:0] _axi_m_llc_read_op_sel_buf;
  reg [32-1:0] _axi_m_llc_read_local_addr_buf;
  reg [32-1:0] _axi_m_llc_read_local_stride_buf;
  reg [33-1:0] _axi_m_llc_read_local_size_buf;
  reg [32-1:0] _axi_m_llc_read_local_blocksize_buf;
  reg _axi_m_llc_read_req_busy;
  reg _axi_m_llc_read_data_busy;
  wire _axi_m_llc_read_req_idle;
  wire _axi_m_llc_read_data_idle;
  wire _axi_m_llc_read_idle;
  assign _axi_m_llc_read_req_idle = !_axi_m_llc_read_start && !_axi_m_llc_read_req_busy;
  assign _axi_m_llc_read_data_idle = _axi_m_llc_read_req_fifo_empty && !_axi_m_llc_read_data_busy;
  assign _axi_m_llc_read_idle = _axi_m_llc_read_req_idle && _axi_m_llc_read_data_idle;
  reg _axi_m_llc_write_start;
  reg [8-1:0] _axi_m_llc_write_op_sel;
  reg [32-1:0] _axi_m_llc_write_global_addr;
  reg [33-1:0] _axi_m_llc_write_global_size;
  reg [32-1:0] _axi_m_llc_write_local_addr;
  reg [32-1:0] _axi_m_llc_write_local_stride;
  reg [33-1:0] _axi_m_llc_write_local_size;
  reg [32-1:0] _axi_m_llc_write_local_blocksize;
  wire _axi_m_llc_write_req_fifo_enq;
  wire [137-1:0] _axi_m_llc_write_req_fifo_wdata;
  wire _axi_m_llc_write_req_fifo_full;
  wire _axi_m_llc_write_req_fifo_almost_full;
  wire _axi_m_llc_write_req_fifo_deq;
  wire [137-1:0] _axi_m_llc_write_req_fifo_rdata;
  wire _axi_m_llc_write_req_fifo_empty;
  wire _axi_m_llc_write_req_fifo_almost_empty;

  _axi_m_llc_write_req_fifo
  inst__axi_m_llc_write_req_fifo
  (
    .CLK(CLK),
    .RST(RST),
    ._axi_m_llc_write_req_fifo_enq(_axi_m_llc_write_req_fifo_enq),
    ._axi_m_llc_write_req_fifo_wdata(_axi_m_llc_write_req_fifo_wdata),
    ._axi_m_llc_write_req_fifo_full(_axi_m_llc_write_req_fifo_full),
    ._axi_m_llc_write_req_fifo_almost_full(_axi_m_llc_write_req_fifo_almost_full),
    ._axi_m_llc_write_req_fifo_deq(_axi_m_llc_write_req_fifo_deq),
    ._axi_m_llc_write_req_fifo_rdata(_axi_m_llc_write_req_fifo_rdata),
    ._axi_m_llc_write_req_fifo_empty(_axi_m_llc_write_req_fifo_empty),
    ._axi_m_llc_write_req_fifo_almost_empty(_axi_m_llc_write_req_fifo_almost_empty)
  );

  reg [4-1:0] count__axi_m_llc_write_req_fifo;
  wire [8-1:0] _axi_m_llc_write_op_sel_fifo;
  wire [32-1:0] _axi_m_llc_write_local_addr_fifo;
  wire [32-1:0] _axi_m_llc_write_local_stride_fifo;
  wire [33-1:0] _axi_m_llc_write_size_fifo;
  wire [32-1:0] _axi_m_llc_write_local_blocksize_fifo;
  wire [8-1:0] unpack_write_req_op_sel_44;
  wire [32-1:0] unpack_write_req_local_addr_45;
  wire [32-1:0] unpack_write_req_local_stride_46;
  wire [33-1:0] unpack_write_req_size_47;
  wire [32-1:0] unpack_write_req_local_blocksize_48;
  assign unpack_write_req_op_sel_44 = _axi_m_llc_write_req_fifo_rdata[136:129];
  assign unpack_write_req_local_addr_45 = _axi_m_llc_write_req_fifo_rdata[128:97];
  assign unpack_write_req_local_stride_46 = _axi_m_llc_write_req_fifo_rdata[96:65];
  assign unpack_write_req_size_47 = _axi_m_llc_write_req_fifo_rdata[64:32];
  assign unpack_write_req_local_blocksize_48 = _axi_m_llc_write_req_fifo_rdata[31:0];
  assign _axi_m_llc_write_op_sel_fifo = unpack_write_req_op_sel_44;
  assign _axi_m_llc_write_local_addr_fifo = unpack_write_req_local_addr_45;
  assign _axi_m_llc_write_local_stride_fifo = unpack_write_req_local_stride_46;
  assign _axi_m_llc_write_size_fifo = unpack_write_req_size_47;
  assign _axi_m_llc_write_local_blocksize_fifo = unpack_write_req_local_blocksize_48;
  reg [8-1:0] _axi_m_llc_write_op_sel_buf;
  reg [32-1:0] _axi_m_llc_write_local_addr_buf;
  reg [32-1:0] _axi_m_llc_write_local_stride_buf;
  reg [33-1:0] _axi_m_llc_write_size_buf;
  reg [32-1:0] _axi_m_llc_write_local_blocksize_buf;
  reg _axi_m_llc_write_req_busy;
  reg _axi_m_llc_write_data_busy;
  wire _axi_m_llc_write_req_idle;
  wire _axi_m_llc_write_data_idle;
  wire _axi_m_llc_write_idle;
  assign _axi_m_llc_write_req_idle = !_axi_m_llc_write_start && !_axi_m_llc_write_req_busy;
  assign _axi_m_llc_write_data_idle = _axi_m_llc_write_req_fifo_empty && !_axi_m_llc_write_data_busy;
  assign _axi_m_llc_write_idle = _axi_m_llc_write_req_idle && _axi_m_llc_write_data_idle;
  reg [64-1:0] num_49;
  reg [64-1:0] mem_range_50;
  reg [64-1:0] addr_51;
  reg [64-1:0] memreq_range_52;
  wire [20-1:0] request_ram_0_addr;
  wire [128-1:0] request_ram_0_rdata;
  wire [128-1:0] request_ram_0_wdata;
  wire request_ram_0_wenable;
  wire request_ram_0_enable;

  request_ram
  inst_request_ram
  (
    .CLK(CLK),
    .request_ram_0_addr(request_ram_0_addr),
    .request_ram_0_rdata(request_ram_0_rdata),
    .request_ram_0_wdata(request_ram_0_wdata),
    .request_ram_0_wenable(request_ram_0_wenable),
    .request_ram_0_enable(request_ram_0_enable)
  );

  wire [20-1:0] receive_ram_0_addr;
  wire [128-1:0] receive_ram_0_rdata;
  wire [128-1:0] receive_ram_0_wdata;
  wire receive_ram_0_wenable;
  wire receive_ram_0_enable;

  receive_ram
  inst_receive_ram
  (
    .CLK(CLK),
    .receive_ram_0_addr(receive_ram_0_addr),
    .receive_ram_0_rdata(receive_ram_0_rdata),
    .receive_ram_0_wdata(receive_ram_0_wdata),
    .receive_ram_0_wenable(receive_ram_0_wenable),
    .receive_ram_0_enable(receive_ram_0_enable)
  );

  reg [128-1:0] read_llc_data_53;
  reg [64-1:0] a_54;
  reg [64-1:0] c_55;
  reg [64-1:0] N_56;
  reg [64-1:0] x_57;
  reg [64-1:0] y_58;
  reg [32-1:0] memreq_thread;
  localparam memreq_thread_init = 0;
  reg signed [32-1:0] _memreq_thread_i_0;
  assign request_ram_0_wdata = (memreq_thread == 14)? _memreq_thread_i_0 << 1 : 'hx;
  assign request_ram_0_wenable = (memreq_thread == 14)? 1'd1 : 0;
  wire [32-1:0] mask_addr_shifted_59;
  assign mask_addr_shifted_59 = addr_51 >> 4;
  wire [32-1:0] mask_addr_masked_60;
  assign mask_addr_masked_60 = mask_addr_shifted_59 << 4;
  reg [32-1:0] _axi_m_llc_write_req_fsm;
  localparam _axi_m_llc_write_req_fsm_init = 0;
  reg [33-1:0] _axi_m_llc_write_cur_global_size;
  reg _axi_m_llc_write_cont;
  wire [8-1:0] pack_write_req_op_sel_61;
  wire [32-1:0] pack_write_req_local_addr_62;
  wire [32-1:0] pack_write_req_local_stride_63;
  wire [33-1:0] pack_write_req_size_64;
  wire [32-1:0] pack_write_req_local_blocksize_65;
  assign pack_write_req_op_sel_61 = _axi_m_llc_write_op_sel;
  assign pack_write_req_local_addr_62 = _axi_m_llc_write_local_addr;
  assign pack_write_req_local_stride_63 = _axi_m_llc_write_local_stride;
  assign pack_write_req_size_64 = _axi_m_llc_write_local_size;
  assign pack_write_req_local_blocksize_65 = _axi_m_llc_write_local_blocksize;
  wire [137-1:0] pack_write_req_packed_66;
  assign pack_write_req_packed_66 = { pack_write_req_op_sel_61, pack_write_req_local_addr_62, pack_write_req_local_stride_63, pack_write_req_size_64, pack_write_req_local_blocksize_65 };
  localparam _tmp_67 = 1;
  wire [_tmp_67-1:0] _tmp_68;
  assign _tmp_68 = !_axi_m_llc_write_req_fifo_almost_full;
  reg [_tmp_67-1:0] __tmp_68_1;
  wire [32-1:0] mask_addr_shifted_69;
  assign mask_addr_shifted_69 = _axi_m_llc_write_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_70;
  assign mask_addr_masked_70 = mask_addr_shifted_69 << 4;
  wire [32-1:0] mask_addr_shifted_71;
  assign mask_addr_shifted_71 = _axi_m_llc_write_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_72;
  assign mask_addr_masked_72 = mask_addr_shifted_71 << 4;
  wire [32-1:0] mask_addr_shifted_73;
  assign mask_addr_shifted_73 = _axi_m_llc_write_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_74;
  assign mask_addr_masked_74 = mask_addr_shifted_73 << 4;
  wire [32-1:0] mask_addr_shifted_75;
  assign mask_addr_shifted_75 = _axi_m_llc_write_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_76;
  assign mask_addr_masked_76 = mask_addr_shifted_75 << 4;
  wire [32-1:0] mask_addr_shifted_77;
  assign mask_addr_shifted_77 = _axi_m_llc_write_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_78;
  assign mask_addr_masked_78 = mask_addr_shifted_77 << 4;
  wire [32-1:0] mask_addr_shifted_79;
  assign mask_addr_shifted_79 = _axi_m_llc_write_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_80;
  assign mask_addr_masked_80 = mask_addr_shifted_79 << 4;
  wire [8-1:0] pack_write_req_op_sel_81;
  wire [32-1:0] pack_write_req_local_addr_82;
  wire [32-1:0] pack_write_req_local_stride_83;
  wire [33-1:0] pack_write_req_size_84;
  wire [32-1:0] pack_write_req_local_blocksize_85;
  assign pack_write_req_op_sel_81 = _axi_m_llc_write_op_sel;
  assign pack_write_req_local_addr_82 = _axi_m_llc_write_local_addr;
  assign pack_write_req_local_stride_83 = _axi_m_llc_write_local_stride;
  assign pack_write_req_size_84 = _axi_m_llc_write_cur_global_size;
  assign pack_write_req_local_blocksize_85 = _axi_m_llc_write_local_blocksize;
  wire [137-1:0] pack_write_req_packed_86;
  assign pack_write_req_packed_86 = { pack_write_req_op_sel_81, pack_write_req_local_addr_82, pack_write_req_local_stride_83, pack_write_req_size_84, pack_write_req_local_blocksize_85 };
  assign _axi_m_llc_write_req_fifo_wdata = ((_axi_m_llc_write_req_fsm == 1) && !_axi_m_llc_write_req_fifo_almost_full && (axi_m_llc_awready || !axi_m_llc_awvalid) && (_axi_m_llc_outstanding_wcount < 6))? pack_write_req_packed_86 : 
                                           ((_axi_m_llc_write_req_fsm == 0) && _axi_m_llc_write_start && !_axi_m_llc_write_req_fifo_almost_full)? pack_write_req_packed_66 : 'hx;
  assign _axi_m_llc_write_req_fifo_enq = ((_axi_m_llc_write_req_fsm == 1) && !_axi_m_llc_write_req_fifo_almost_full && (axi_m_llc_awready || !axi_m_llc_awvalid) && (_axi_m_llc_outstanding_wcount < 6))? (_axi_m_llc_write_req_fsm == 1) && !_axi_m_llc_write_req_fifo_almost_full && (axi_m_llc_awready || !axi_m_llc_awvalid) && (_axi_m_llc_outstanding_wcount < 6) && !_axi_m_llc_write_req_fifo_almost_full : 
                                         ((_axi_m_llc_write_req_fsm == 0) && _axi_m_llc_write_start && !_axi_m_llc_write_req_fifo_almost_full)? (_axi_m_llc_write_req_fsm == 0) && _axi_m_llc_write_start && !_axi_m_llc_write_req_fifo_almost_full && !_axi_m_llc_write_req_fifo_almost_full : 0;
  localparam _tmp_87 = 1;
  wire [_tmp_87-1:0] _tmp_88;
  assign _tmp_88 = !_axi_m_llc_write_req_fifo_almost_full;
  reg [_tmp_87-1:0] __tmp_88_1;
  reg _axi_m_llc_waddr_cond_0_1;
  reg [32-1:0] _axi_m_llc_write_data_fsm;
  localparam _axi_m_llc_write_data_fsm_init = 0;
  reg [32-1:0] read_burst_fsm_0;
  localparam read_burst_fsm_0_init = 0;
  reg [20-1:0] read_burst_addr_89;
  reg [20-1:0] read_burst_stride_90;
  reg [33-1:0] read_burst_length_91;
  reg read_burst_rvalid_92;
  reg read_burst_rlast_93;
  assign request_ram_0_addr = ((read_burst_fsm_0 == 1) && (!read_burst_rvalid_92 || (_axi_m_llc_wready_sb_0 || !_axi_m_llc_wvalid_sb_0) && (_axi_m_llc_write_size_buf > 0)))? read_burst_addr_89 : 
                              (memreq_thread == 14)? _memreq_thread_i_0 : 'hx;
  assign request_ram_0_enable = ((read_burst_fsm_0 == 1) && (!read_burst_rvalid_92 || (_axi_m_llc_wready_sb_0 || !_axi_m_llc_wvalid_sb_0) && (_axi_m_llc_write_size_buf > 0)))? 1'd1 : 
                                (memreq_thread == 14)? 1'd1 : 0;
  localparam _tmp_94 = 1;
  wire [_tmp_94-1:0] _tmp_95;
  assign _tmp_95 = (read_burst_fsm_0 == 1) && (!read_burst_rvalid_92 || (_axi_m_llc_wready_sb_0 || !_axi_m_llc_wvalid_sb_0) && (_axi_m_llc_write_size_buf > 0));
  reg [_tmp_94-1:0] __tmp_95_1;
  wire [128-1:0] read_burst_rdata_96;
  assign read_burst_rdata_96 = request_ram_0_rdata;
  assign _axi_m_llc_write_req_fifo_deq = ((_axi_m_llc_write_data_fsm == 2) && (!_axi_m_llc_write_req_fifo_empty && (_axi_m_llc_write_size_buf == 0)) && !_axi_m_llc_write_req_fifo_empty)? 1 : 
                                         ((_axi_m_llc_write_data_fsm == 0) && (!_axi_m_llc_write_data_busy && !_axi_m_llc_write_req_fifo_empty && (_axi_m_llc_write_op_sel_fifo == 1)) && !_axi_m_llc_write_req_fifo_empty)? 1 : 0;
  reg _axi_m_llc_wdata_cond_0_1;
  wire [32-1:0] mask_addr_shifted_97;
  assign mask_addr_shifted_97 = y_58 * memreq_range_52 >> 4;
  wire [32-1:0] mask_addr_masked_98;
  assign mask_addr_masked_98 = mask_addr_shifted_97 << 4;
  reg [32-1:0] _axi_m_llc_read_req_fsm;
  localparam _axi_m_llc_read_req_fsm_init = 0;
  reg [33-1:0] _axi_m_llc_read_cur_global_size;
  reg _axi_m_llc_read_cont;
  wire [8-1:0] pack_read_req_op_sel_99;
  wire [32-1:0] pack_read_req_local_addr_100;
  wire [32-1:0] pack_read_req_local_stride_101;
  wire [33-1:0] pack_read_req_local_size_102;
  wire [32-1:0] pack_read_req_local_blocksize_103;
  assign pack_read_req_op_sel_99 = _axi_m_llc_read_op_sel;
  assign pack_read_req_local_addr_100 = _axi_m_llc_read_local_addr;
  assign pack_read_req_local_stride_101 = _axi_m_llc_read_local_stride;
  assign pack_read_req_local_size_102 = _axi_m_llc_read_local_size;
  assign pack_read_req_local_blocksize_103 = _axi_m_llc_read_local_blocksize;
  wire [137-1:0] pack_read_req_packed_104;
  assign pack_read_req_packed_104 = { pack_read_req_op_sel_99, pack_read_req_local_addr_100, pack_read_req_local_stride_101, pack_read_req_local_size_102, pack_read_req_local_blocksize_103 };
  assign _axi_m_llc_read_req_fifo_wdata = ((_axi_m_llc_read_req_fsm == 0) && _axi_m_llc_read_start && !_axi_m_llc_read_req_fifo_almost_full)? pack_read_req_packed_104 : 'hx;
  assign _axi_m_llc_read_req_fifo_enq = ((_axi_m_llc_read_req_fsm == 0) && _axi_m_llc_read_start && !_axi_m_llc_read_req_fifo_almost_full)? (_axi_m_llc_read_req_fsm == 0) && _axi_m_llc_read_start && !_axi_m_llc_read_req_fifo_almost_full && !_axi_m_llc_read_req_fifo_almost_full : 0;
  localparam _tmp_105 = 1;
  wire [_tmp_105-1:0] _tmp_106;
  assign _tmp_106 = !_axi_m_llc_read_req_fifo_almost_full;
  reg [_tmp_105-1:0] __tmp_106_1;
  wire [32-1:0] mask_addr_shifted_107;
  assign mask_addr_shifted_107 = _axi_m_llc_read_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_108;
  assign mask_addr_masked_108 = mask_addr_shifted_107 << 4;
  wire [32-1:0] mask_addr_shifted_109;
  assign mask_addr_shifted_109 = _axi_m_llc_read_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_110;
  assign mask_addr_masked_110 = mask_addr_shifted_109 << 4;
  wire [32-1:0] mask_addr_shifted_111;
  assign mask_addr_shifted_111 = _axi_m_llc_read_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_112;
  assign mask_addr_masked_112 = mask_addr_shifted_111 << 4;
  wire [32-1:0] mask_addr_shifted_113;
  assign mask_addr_shifted_113 = _axi_m_llc_read_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_114;
  assign mask_addr_masked_114 = mask_addr_shifted_113 << 4;
  wire [32-1:0] mask_addr_shifted_115;
  assign mask_addr_shifted_115 = _axi_m_llc_read_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_116;
  assign mask_addr_masked_116 = mask_addr_shifted_115 << 4;
  wire [32-1:0] mask_addr_shifted_117;
  assign mask_addr_shifted_117 = _axi_m_llc_read_global_addr >> 4;
  wire [32-1:0] mask_addr_masked_118;
  assign mask_addr_masked_118 = mask_addr_shifted_117 << 4;
  reg _axi_m_llc_raddr_cond_0_1;
  reg [32-1:0] _axi_m_llc_read_data_fsm;
  localparam _axi_m_llc_read_data_fsm_init = 0;
  assign _axi_m_llc_read_req_fifo_deq = ((_axi_m_llc_read_data_fsm == 0) && (!_axi_m_llc_read_data_busy && !_axi_m_llc_read_req_fifo_empty && (_axi_m_llc_read_op_sel_fifo == 1)) && !_axi_m_llc_read_req_fifo_empty)? 1 : 0;
  reg [32-1:0] write_burst_fsm_1;
  localparam write_burst_fsm_1_init = 0;
  reg [20-1:0] write_burst_addr_119;
  reg [20-1:0] write_burst_stride_120;
  reg [33-1:0] write_burst_length_121;
  reg write_burst_done_122;
  assign receive_ram_0_wdata = ((write_burst_fsm_1 == 1) && _axi_m_llc_rvalid_sb_0)? _axi_m_llc_rdata_sb_0 : 'hx;
  assign receive_ram_0_wenable = ((write_burst_fsm_1 == 1) && _axi_m_llc_rvalid_sb_0)? 1'd1 : 0;
  assign _axi_m_llc_rready_sb_0 = _axi_m_llc_read_data_fsm == 2;
  assign receive_ram_0_addr = (memreq_thread == 35)? _memreq_thread_i_0 : 
                              ((write_burst_fsm_1 == 1) && _axi_m_llc_rvalid_sb_0)? write_burst_addr_119 : 'hx;
  assign receive_ram_0_enable = (memreq_thread == 35)? 1'd1 : 
                                ((write_burst_fsm_1 == 1) && _axi_m_llc_rvalid_sb_0)? 1'd1 : 0;
  localparam _tmp_123 = 1;
  wire [_tmp_123-1:0] _tmp_124;
  assign _tmp_124 = memreq_thread == 35;
  reg [_tmp_123-1:0] __tmp_124_1;
  reg signed [128-1:0] read_rdata_125;

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
        axi_s_ctrl_memreq_rdata <= axislite_rdata_6;
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
      prev_awvalid_3 <= 0;
      prev_arvalid_4 <= 0;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      addr_0 <= 0;
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
      prev_awvalid_3 <= axi_s_ctrl_memreq_awvalid;
      prev_arvalid_4 <= axi_s_ctrl_memreq_arvalid;
      writevalid_1 <= 0;
      readvalid_2 <= 0;
      if(axi_s_ctrl_memreq_awready && axi_s_ctrl_memreq_awvalid && !axi_s_ctrl_memreq_bvalid) begin
        addr_0 <= axi_s_ctrl_memreq_awaddr;
        writevalid_1 <= 1;
      end else if(axi_s_ctrl_memreq_arready && axi_s_ctrl_memreq_arvalid) begin
        addr_0 <= axi_s_ctrl_memreq_araddr;
        readvalid_2 <= 1;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 0)) begin
        _axi_s_ctrl_memreq_register_0 <= axislite_resetval_8;
        _axi_s_ctrl_memreq_flag_0 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 1)) begin
        _axi_s_ctrl_memreq_register_1 <= axislite_resetval_8;
        _axi_s_ctrl_memreq_flag_1 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 2)) begin
        _axi_s_ctrl_memreq_register_2 <= axislite_resetval_8;
        _axi_s_ctrl_memreq_flag_2 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 3)) begin
        _axi_s_ctrl_memreq_register_3 <= axislite_resetval_8;
        _axi_s_ctrl_memreq_flag_3 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 4)) begin
        _axi_s_ctrl_memreq_register_4 <= axislite_resetval_8;
        _axi_s_ctrl_memreq_flag_4 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 5)) begin
        _axi_s_ctrl_memreq_register_5 <= axislite_resetval_8;
        _axi_s_ctrl_memreq_flag_5 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 1) && (axi_s_ctrl_memreq_rready || !axi_s_ctrl_memreq_rvalid) && axislite_flag_7 && (axis_maskaddr_5 == 6)) begin
        _axi_s_ctrl_memreq_register_6 <= axislite_resetval_8;
        _axi_s_ctrl_memreq_flag_6 <= 0;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_5 == 0)) begin
        _axi_s_ctrl_memreq_register_0 <= axi_s_ctrl_memreq_wdata;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_5 == 1)) begin
        _axi_s_ctrl_memreq_register_1 <= axi_s_ctrl_memreq_wdata;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_5 == 2)) begin
        _axi_s_ctrl_memreq_register_2 <= axi_s_ctrl_memreq_wdata;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_5 == 3)) begin
        _axi_s_ctrl_memreq_register_3 <= axi_s_ctrl_memreq_wdata;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_5 == 4)) begin
        _axi_s_ctrl_memreq_register_4 <= axi_s_ctrl_memreq_wdata;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_5 == 5)) begin
        _axi_s_ctrl_memreq_register_5 <= axi_s_ctrl_memreq_wdata;
      end 
      if((_axi_s_ctrl_memreq_register_fsm == 3) && axi_s_ctrl_memreq_wvalid && (axis_maskaddr_5 == 6)) begin
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
      axis_maskaddr_5 <= 0;
    end else begin
      case(_axi_s_ctrl_memreq_register_fsm)
        _axi_s_ctrl_memreq_register_fsm_init: begin
          if(readvalid_2 || writevalid_1) begin
            axis_maskaddr_5 <= (addr_0 >> _axi_s_ctrl_memreq_shift) & _axi_s_ctrl_memreq_mask;
          end 
          if(readvalid_2) begin
            _axi_s_ctrl_memreq_register_fsm <= _axi_s_ctrl_memreq_register_fsm_1;
          end 
          if(writevalid_1) begin
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


  always @(posedge CLK) begin
    if(RST) begin
      axi_m_llc_awaddr <= 0;
      axi_m_llc_awlen <= 0;
      axi_m_llc_awvalid <= 0;
      _axi_m_llc_waddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_llc_waddr_cond_0_1) begin
        axi_m_llc_awvalid <= 0;
      end 
      if((_axi_m_llc_write_req_fsm == 1) && !_axi_m_llc_write_req_fifo_almost_full && (_axi_m_llc_outstanding_wcount < 6) && ((_axi_m_llc_outstanding_wcount < 6) && (axi_m_llc_awready || !axi_m_llc_awvalid))) begin
        axi_m_llc_awaddr <= _axi_m_llc_write_global_addr;
        axi_m_llc_awlen <= _axi_m_llc_write_cur_global_size - 1;
        axi_m_llc_awvalid <= 1;
      end 
      if((_axi_m_llc_write_req_fsm == 1) && !_axi_m_llc_write_req_fifo_almost_full && (_axi_m_llc_outstanding_wcount < 6) && ((_axi_m_llc_outstanding_wcount < 6) && (axi_m_llc_awready || !axi_m_llc_awvalid)) && (_axi_m_llc_write_cur_global_size == 0)) begin
        axi_m_llc_awvalid <= 0;
      end 
      _axi_m_llc_waddr_cond_0_1 <= 1;
      if(axi_m_llc_awvalid && !axi_m_llc_awready) begin
        axi_m_llc_awvalid <= axi_m_llc_awvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_llc_wdata_sb_0 <= 0;
      _axi_m_llc_wvalid_sb_0 <= 0;
      _axi_m_llc_wlast_sb_0 <= 0;
      _axi_m_llc_wstrb_sb_0 <= 0;
      _axi_m_llc_wdata_cond_0_1 <= 0;
    end else begin
      if(_axi_m_llc_wdata_cond_0_1) begin
        _axi_m_llc_wvalid_sb_0 <= 0;
        _axi_m_llc_wlast_sb_0 <= 0;
      end 
      if((_axi_m_llc_write_op_sel_buf == 1) && read_burst_rvalid_92 && ((_axi_m_llc_wready_sb_0 || !_axi_m_llc_wvalid_sb_0) && (_axi_m_llc_write_size_buf > 0)) && (_axi_m_llc_wready_sb_0 || !_axi_m_llc_wvalid_sb_0)) begin
        _axi_m_llc_wdata_sb_0 <= read_burst_rdata_96;
        _axi_m_llc_wvalid_sb_0 <= 1;
        _axi_m_llc_wlast_sb_0 <= read_burst_rlast_93 || (_axi_m_llc_write_size_buf == 1);
        _axi_m_llc_wstrb_sb_0 <= { 16{ 1'd1 } };
      end 
      _axi_m_llc_wdata_cond_0_1 <= 1;
      if(_axi_m_llc_wvalid_sb_0 && !_axi_m_llc_wready_sb_0) begin
        _axi_m_llc_wvalid_sb_0 <= _axi_m_llc_wvalid_sb_0;
        _axi_m_llc_wlast_sb_0 <= _axi_m_llc_wlast_sb_0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_llc_writedata_data_15 <= 0;
      _sb_axi_m_llc_writedata_valid_16 <= 0;
      _sb_axi_m_llc_writedata_tmp_data_18 <= 0;
      _sb_axi_m_llc_writedata_tmp_valid_19 <= 0;
    end else begin
      if(_sb_axi_m_llc_writedata_m_ready_14 || !_sb_axi_m_llc_writedata_valid_16) begin
        _sb_axi_m_llc_writedata_data_15 <= _sb_axi_m_llc_writedata_next_data_20;
        _sb_axi_m_llc_writedata_valid_16 <= _sb_axi_m_llc_writedata_next_valid_21;
      end 
      if(!_sb_axi_m_llc_writedata_tmp_valid_19 && _sb_axi_m_llc_writedata_valid_16 && !_sb_axi_m_llc_writedata_m_ready_14) begin
        _sb_axi_m_llc_writedata_tmp_data_18 <= _sb_axi_m_llc_writedata_s_data_12;
        _sb_axi_m_llc_writedata_tmp_valid_19 <= _sb_axi_m_llc_writedata_s_valid_13;
      end 
      if(_sb_axi_m_llc_writedata_tmp_valid_19 && _sb_axi_m_llc_writedata_m_ready_14) begin
        _sb_axi_m_llc_writedata_tmp_valid_19 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      axi_m_llc_araddr <= 0;
      axi_m_llc_arlen <= 0;
      axi_m_llc_arvalid <= 0;
      _axi_m_llc_raddr_cond_0_1 <= 0;
    end else begin
      if(_axi_m_llc_raddr_cond_0_1) begin
        axi_m_llc_arvalid <= 0;
      end 
      if((_axi_m_llc_read_req_fsm == 1) && (axi_m_llc_arready || !axi_m_llc_arvalid)) begin
        axi_m_llc_araddr <= _axi_m_llc_read_global_addr;
        axi_m_llc_arlen <= _axi_m_llc_read_cur_global_size - 1;
        axi_m_llc_arvalid <= 1;
      end 
      _axi_m_llc_raddr_cond_0_1 <= 1;
      if(axi_m_llc_arvalid && !axi_m_llc_arready) begin
        axi_m_llc_arvalid <= axi_m_llc_arvalid;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _sb_axi_m_llc_readdata_data_30 <= 0;
      _sb_axi_m_llc_readdata_valid_31 <= 0;
      _sb_axi_m_llc_readdata_tmp_data_33 <= 0;
      _sb_axi_m_llc_readdata_tmp_valid_34 <= 0;
    end else begin
      if(_sb_axi_m_llc_readdata_m_ready_29 || !_sb_axi_m_llc_readdata_valid_31) begin
        _sb_axi_m_llc_readdata_data_30 <= _sb_axi_m_llc_readdata_next_data_35;
        _sb_axi_m_llc_readdata_valid_31 <= _sb_axi_m_llc_readdata_next_valid_36;
      end 
      if(!_sb_axi_m_llc_readdata_tmp_valid_34 && _sb_axi_m_llc_readdata_valid_31 && !_sb_axi_m_llc_readdata_m_ready_29) begin
        _sb_axi_m_llc_readdata_tmp_data_33 <= _sb_axi_m_llc_readdata_s_data_27;
        _sb_axi_m_llc_readdata_tmp_valid_34 <= _sb_axi_m_llc_readdata_s_valid_28;
      end 
      if(_sb_axi_m_llc_readdata_tmp_valid_34 && _sb_axi_m_llc_readdata_m_ready_29) begin
        _sb_axi_m_llc_readdata_tmp_valid_34 <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_llc_outstanding_wcount <= 0;
      _axi_m_llc_read_start <= 0;
      _axi_m_llc_write_start <= 0;
      _axi_m_llc_write_op_sel <= 0;
      _axi_m_llc_write_global_addr <= 0;
      _axi_m_llc_write_global_size <= 0;
      _axi_m_llc_write_local_addr <= 0;
      _axi_m_llc_write_local_stride <= 0;
      _axi_m_llc_write_local_size <= 0;
      _axi_m_llc_write_local_blocksize <= 0;
      _axi_m_llc_write_req_busy <= 0;
      _axi_m_llc_write_cur_global_size <= 0;
      _axi_m_llc_write_data_busy <= 0;
      _axi_m_llc_write_op_sel_buf <= 0;
      _axi_m_llc_write_local_addr_buf <= 0;
      _axi_m_llc_write_local_stride_buf <= 0;
      _axi_m_llc_write_size_buf <= 0;
      _axi_m_llc_write_local_blocksize_buf <= 0;
      _axi_m_llc_read_op_sel <= 0;
      _axi_m_llc_read_global_addr <= 0;
      _axi_m_llc_read_global_size <= 0;
      _axi_m_llc_read_local_addr <= 0;
      _axi_m_llc_read_local_stride <= 0;
      _axi_m_llc_read_local_size <= 0;
      _axi_m_llc_read_local_blocksize <= 0;
      _axi_m_llc_read_req_busy <= 0;
      _axi_m_llc_read_cur_global_size <= 0;
      _axi_m_llc_read_data_busy <= 0;
      _axi_m_llc_read_op_sel_buf <= 0;
      _axi_m_llc_read_local_addr_buf <= 0;
      _axi_m_llc_read_local_stride_buf <= 0;
      _axi_m_llc_read_local_size_buf <= 0;
      _axi_m_llc_read_local_blocksize_buf <= 0;
    end else begin
      if(axi_m_llc_awvalid && axi_m_llc_awready && !(axi_m_llc_bvalid && axi_m_llc_bready) && (_axi_m_llc_outstanding_wcount < 7)) begin
        _axi_m_llc_outstanding_wcount <= _axi_m_llc_outstanding_wcount + 1;
      end 
      if(!(axi_m_llc_awvalid && axi_m_llc_awready) && (axi_m_llc_bvalid && axi_m_llc_bready) && (_axi_m_llc_outstanding_wcount > 0)) begin
        _axi_m_llc_outstanding_wcount <= _axi_m_llc_outstanding_wcount - 1;
      end 
      _axi_m_llc_read_start <= 0;
      _axi_m_llc_write_start <= 0;
      if((memreq_thread == 19) && _axi_m_llc_write_req_idle) begin
        _axi_m_llc_write_start <= 1;
        _axi_m_llc_write_op_sel <= 1;
        _axi_m_llc_write_global_addr <= mask_addr_masked_60;
        _axi_m_llc_write_global_size <= 4;
        _axi_m_llc_write_local_addr <= _memreq_thread_i_0 << 2;
        _axi_m_llc_write_local_stride <= 1;
        _axi_m_llc_write_local_size <= 4;
        _axi_m_llc_write_local_blocksize <= 1;
      end 
      if((_axi_m_llc_write_req_fsm == 0) && _axi_m_llc_write_start) begin
        _axi_m_llc_write_req_busy <= 1;
      end 
      if(_axi_m_llc_write_start && _axi_m_llc_write_req_fifo_almost_full) begin
        _axi_m_llc_write_start <= 1;
      end 
      if((_axi_m_llc_write_req_fsm == 0) && (_axi_m_llc_write_start || _axi_m_llc_write_cont) && !_axi_m_llc_write_req_fifo_almost_full && (_axi_m_llc_write_global_size <= 256) && ((mask_addr_masked_70 & 4095) + (_axi_m_llc_write_global_size << 4) >= 4096)) begin
        _axi_m_llc_write_cur_global_size <= 4096 - (mask_addr_masked_72 & 4095) >> 4;
        _axi_m_llc_write_global_size <= _axi_m_llc_write_global_size - (4096 - (mask_addr_masked_74 & 4095) >> 4);
      end else if((_axi_m_llc_write_req_fsm == 0) && (_axi_m_llc_write_start || _axi_m_llc_write_cont) && !_axi_m_llc_write_req_fifo_almost_full && (_axi_m_llc_write_global_size <= 256)) begin
        _axi_m_llc_write_cur_global_size <= _axi_m_llc_write_global_size;
        _axi_m_llc_write_global_size <= 0;
      end else if((_axi_m_llc_write_req_fsm == 0) && (_axi_m_llc_write_start || _axi_m_llc_write_cont) && !_axi_m_llc_write_req_fifo_almost_full && ((mask_addr_masked_76 & 4095) + 4096 >= 4096)) begin
        _axi_m_llc_write_cur_global_size <= 4096 - (mask_addr_masked_78 & 4095) >> 4;
        _axi_m_llc_write_global_size <= _axi_m_llc_write_global_size - (4096 - (mask_addr_masked_80 & 4095) >> 4);
      end else if((_axi_m_llc_write_req_fsm == 0) && (_axi_m_llc_write_start || _axi_m_llc_write_cont) && !_axi_m_llc_write_req_fifo_almost_full) begin
        _axi_m_llc_write_cur_global_size <= 256;
        _axi_m_llc_write_global_size <= _axi_m_llc_write_global_size - 256;
      end 
      if((_axi_m_llc_write_req_fsm == 1) && ((_axi_m_llc_write_req_fsm == 1) && !_axi_m_llc_write_req_fifo_almost_full && (axi_m_llc_awready || !axi_m_llc_awvalid) && (_axi_m_llc_outstanding_wcount < 6))) begin
        _axi_m_llc_write_global_addr <= _axi_m_llc_write_global_addr + (_axi_m_llc_write_cur_global_size << 4);
      end 
      if((_axi_m_llc_write_req_fsm == 1) && ((_axi_m_llc_write_req_fsm == 1) && !_axi_m_llc_write_req_fifo_almost_full && (axi_m_llc_awready || !axi_m_llc_awvalid) && (_axi_m_llc_outstanding_wcount < 6)) && (_axi_m_llc_write_global_size == 0)) begin
        _axi_m_llc_write_req_busy <= 0;
      end 
      if((_axi_m_llc_write_data_fsm == 0) && (!_axi_m_llc_write_data_busy && !_axi_m_llc_write_req_fifo_empty && (_axi_m_llc_write_op_sel_fifo == 1))) begin
        _axi_m_llc_write_data_busy <= 1;
        _axi_m_llc_write_op_sel_buf <= _axi_m_llc_write_op_sel_fifo;
        _axi_m_llc_write_local_addr_buf <= _axi_m_llc_write_local_addr_fifo;
        _axi_m_llc_write_local_stride_buf <= _axi_m_llc_write_local_stride_fifo;
        _axi_m_llc_write_size_buf <= _axi_m_llc_write_size_fifo;
        _axi_m_llc_write_local_blocksize_buf <= _axi_m_llc_write_local_blocksize_fifo;
      end 
      if(_axi_m_llc_write_data_fsm == 1) begin
        _axi_m_llc_write_size_buf <= 0;
      end 
      if((_axi_m_llc_write_data_fsm == 2) && (!_axi_m_llc_write_req_fifo_empty && (_axi_m_llc_write_size_buf == 0))) begin
        _axi_m_llc_write_size_buf <= _axi_m_llc_write_size_fifo;
      end 
      if((_axi_m_llc_write_data_fsm == 2) && read_burst_rvalid_92 && ((_axi_m_llc_wready_sb_0 || !_axi_m_llc_wvalid_sb_0) && (_axi_m_llc_write_size_buf > 0))) begin
        _axi_m_llc_write_size_buf <= _axi_m_llc_write_size_buf - 1;
      end 
      if((_axi_m_llc_write_data_fsm == 2) && ((_axi_m_llc_write_op_sel_buf == 1) && read_burst_rvalid_92 && ((_axi_m_llc_wready_sb_0 || !_axi_m_llc_wvalid_sb_0) && (_axi_m_llc_write_size_buf > 0))) && read_burst_rlast_93) begin
        _axi_m_llc_write_data_busy <= 0;
      end 
      if((memreq_thread == 30) && _axi_m_llc_read_req_idle) begin
        _axi_m_llc_read_start <= 1;
        _axi_m_llc_read_op_sel <= 1;
        _axi_m_llc_read_global_addr <= mask_addr_masked_98;
        _axi_m_llc_read_global_size <= 4;
        _axi_m_llc_read_local_addr <= y_58 << 2;
        _axi_m_llc_read_local_stride <= 1;
        _axi_m_llc_read_local_size <= 4;
        _axi_m_llc_read_local_blocksize <= 1;
      end 
      if((_axi_m_llc_read_req_fsm == 0) && _axi_m_llc_read_start) begin
        _axi_m_llc_read_req_busy <= 1;
      end 
      if(_axi_m_llc_read_start && _axi_m_llc_read_req_fifo_almost_full) begin
        _axi_m_llc_read_start <= 1;
      end 
      if((_axi_m_llc_read_req_fsm == 0) && (_axi_m_llc_read_start || _axi_m_llc_read_cont) && !_axi_m_llc_read_req_fifo_almost_full && (_axi_m_llc_read_global_size <= 256) && ((mask_addr_masked_108 & 4095) + (_axi_m_llc_read_global_size << 4) >= 4096)) begin
        _axi_m_llc_read_cur_global_size <= 4096 - (mask_addr_masked_110 & 4095) >> 4;
        _axi_m_llc_read_global_size <= _axi_m_llc_read_global_size - (4096 - (mask_addr_masked_112 & 4095) >> 4);
      end else if((_axi_m_llc_read_req_fsm == 0) && (_axi_m_llc_read_start || _axi_m_llc_read_cont) && !_axi_m_llc_read_req_fifo_almost_full && (_axi_m_llc_read_global_size <= 256)) begin
        _axi_m_llc_read_cur_global_size <= _axi_m_llc_read_global_size;
        _axi_m_llc_read_global_size <= 0;
      end else if((_axi_m_llc_read_req_fsm == 0) && (_axi_m_llc_read_start || _axi_m_llc_read_cont) && !_axi_m_llc_read_req_fifo_almost_full && ((mask_addr_masked_114 & 4095) + 4096 >= 4096)) begin
        _axi_m_llc_read_cur_global_size <= 4096 - (mask_addr_masked_116 & 4095) >> 4;
        _axi_m_llc_read_global_size <= _axi_m_llc_read_global_size - (4096 - (mask_addr_masked_118 & 4095) >> 4);
      end else if((_axi_m_llc_read_req_fsm == 0) && (_axi_m_llc_read_start || _axi_m_llc_read_cont) && !_axi_m_llc_read_req_fifo_almost_full) begin
        _axi_m_llc_read_cur_global_size <= 256;
        _axi_m_llc_read_global_size <= _axi_m_llc_read_global_size - 256;
      end 
      if((_axi_m_llc_read_req_fsm == 1) && (axi_m_llc_arready || !axi_m_llc_arvalid)) begin
        _axi_m_llc_read_global_addr <= _axi_m_llc_read_global_addr + (_axi_m_llc_read_cur_global_size << 4);
      end 
      if((_axi_m_llc_read_req_fsm == 1) && (axi_m_llc_arready || !axi_m_llc_arvalid) && (_axi_m_llc_read_global_size == 0)) begin
        _axi_m_llc_read_req_busy <= 0;
      end 
      if((_axi_m_llc_read_data_fsm == 0) && (!_axi_m_llc_read_data_busy && !_axi_m_llc_read_req_fifo_empty && (_axi_m_llc_read_op_sel_fifo == 1))) begin
        _axi_m_llc_read_data_busy <= 1;
        _axi_m_llc_read_op_sel_buf <= _axi_m_llc_read_op_sel_fifo;
        _axi_m_llc_read_local_addr_buf <= _axi_m_llc_read_local_addr_fifo;
        _axi_m_llc_read_local_stride_buf <= _axi_m_llc_read_local_stride_fifo;
        _axi_m_llc_read_local_size_buf <= _axi_m_llc_read_local_size_fifo;
        _axi_m_llc_read_local_blocksize_buf <= _axi_m_llc_read_local_blocksize_fifo;
      end 
      if((_axi_m_llc_read_data_fsm == 2) && _axi_m_llc_rvalid_sb_0) begin
        _axi_m_llc_read_local_size_buf <= _axi_m_llc_read_local_size_buf - 1;
      end 
      if((_axi_m_llc_read_data_fsm == 2) && _axi_m_llc_rvalid_sb_0 && (_axi_m_llc_read_local_size_buf <= 1)) begin
        _axi_m_llc_read_data_busy <= 0;
      end 
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axi_m_llc_read_req_fifo <= 0;
      __tmp_106_1 <= 0;
    end else begin
      if(_axi_m_llc_read_req_fifo_enq && !_axi_m_llc_read_req_fifo_full && (_axi_m_llc_read_req_fifo_deq && !_axi_m_llc_read_req_fifo_empty)) begin
        count__axi_m_llc_read_req_fifo <= count__axi_m_llc_read_req_fifo;
      end else if(_axi_m_llc_read_req_fifo_enq && !_axi_m_llc_read_req_fifo_full) begin
        count__axi_m_llc_read_req_fifo <= count__axi_m_llc_read_req_fifo + 1;
      end else if(_axi_m_llc_read_req_fifo_deq && !_axi_m_llc_read_req_fifo_empty) begin
        count__axi_m_llc_read_req_fifo <= count__axi_m_llc_read_req_fifo - 1;
      end 
      __tmp_106_1 <= _tmp_106;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      count__axi_m_llc_write_req_fifo <= 0;
      __tmp_68_1 <= 0;
      __tmp_88_1 <= 0;
    end else begin
      if(_axi_m_llc_write_req_fifo_enq && !_axi_m_llc_write_req_fifo_full && (_axi_m_llc_write_req_fifo_deq && !_axi_m_llc_write_req_fifo_empty)) begin
        count__axi_m_llc_write_req_fifo <= count__axi_m_llc_write_req_fifo;
      end else if(_axi_m_llc_write_req_fifo_enq && !_axi_m_llc_write_req_fifo_full) begin
        count__axi_m_llc_write_req_fifo <= count__axi_m_llc_write_req_fifo + 1;
      end else if(_axi_m_llc_write_req_fifo_deq && !_axi_m_llc_write_req_fifo_empty) begin
        count__axi_m_llc_write_req_fifo <= count__axi_m_llc_write_req_fifo - 1;
      end 
      __tmp_68_1 <= _tmp_68;
      __tmp_88_1 <= _tmp_88;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      __tmp_95_1 <= 0;
    end else begin
      __tmp_95_1 <= _tmp_95;
    end
  end


  always @(posedge CLK) begin
    if(RST) begin
      __tmp_124_1 <= 0;
    end else begin
      __tmp_124_1 <= _tmp_124;
    end
  end

  localparam memreq_thread_1 = 1;
  localparam memreq_thread_2 = 2;
  localparam memreq_thread_3 = 3;
  localparam memreq_thread_4 = 4;
  localparam memreq_thread_5 = 5;
  localparam memreq_thread_6 = 6;
  localparam memreq_thread_7 = 7;
  localparam memreq_thread_8 = 8;
  localparam memreq_thread_9 = 9;
  localparam memreq_thread_10 = 10;
  localparam memreq_thread_11 = 11;
  localparam memreq_thread_12 = 12;
  localparam memreq_thread_13 = 13;
  localparam memreq_thread_14 = 14;
  localparam memreq_thread_15 = 15;
  localparam memreq_thread_16 = 16;
  localparam memreq_thread_17 = 17;
  localparam memreq_thread_18 = 18;
  localparam memreq_thread_19 = 19;
  localparam memreq_thread_20 = 20;
  localparam memreq_thread_21 = 21;
  localparam memreq_thread_22 = 22;
  localparam memreq_thread_23 = 23;
  localparam memreq_thread_24 = 24;
  localparam memreq_thread_25 = 25;
  localparam memreq_thread_26 = 26;
  localparam memreq_thread_27 = 27;
  localparam memreq_thread_28 = 28;
  localparam memreq_thread_29 = 29;
  localparam memreq_thread_30 = 30;
  localparam memreq_thread_31 = 31;
  localparam memreq_thread_32 = 32;
  localparam memreq_thread_33 = 33;
  localparam memreq_thread_34 = 34;
  localparam memreq_thread_35 = 35;
  localparam memreq_thread_36 = 36;
  localparam memreq_thread_37 = 37;
  localparam memreq_thread_38 = 38;
  localparam memreq_thread_39 = 39;
  localparam memreq_thread_40 = 40;
  localparam memreq_thread_41 = 41;

  always @(posedge CLK) begin
    if(RST) begin
      memreq_thread <= memreq_thread_init;
      mem_range_50 <= 0;
      num_49 <= 0;
      memreq_range_52 <= 0;
      _memreq_thread_i_0 <= 0;
      addr_51 <= 0;
      a_54 <= 0;
      c_55 <= 0;
      N_56 <= 0;
      x_57 <= 0;
      y_58 <= 0;
      read_rdata_125 <= 0;
      read_llc_data_53 <= 0;
    end else begin
      case(memreq_thread)
        memreq_thread_init: begin
          memreq_thread <= memreq_thread_1;
        end
        memreq_thread_1: begin
          if(1) begin
            memreq_thread <= memreq_thread_2;
          end else begin
            memreq_thread <= memreq_thread_12;
          end
        end
        memreq_thread_2: begin
          mem_range_50 <= _axi_s_ctrl_memreq_register_0;
          memreq_thread <= memreq_thread_3;
        end
        memreq_thread_3: begin
          num_49 <= _axi_s_ctrl_memreq_register_1;
          memreq_thread <= memreq_thread_4;
        end
        memreq_thread_4: begin
          if((num_49 != 0) && (mem_range_50 != 0)) begin
            memreq_thread <= memreq_thread_5;
          end else begin
            memreq_thread <= memreq_thread_11;
          end
        end
        memreq_thread_5: begin
          memreq_range_52 <= mem_range_50 / num_49;
          memreq_thread <= memreq_thread_6;
        end
        memreq_thread_6: begin
          if(memreq_range_52 < 64) begin
            memreq_thread <= memreq_thread_7;
          end else begin
            memreq_thread <= memreq_thread_8;
          end
        end
        memreq_thread_7: begin
          memreq_range_52 <= 64;
          memreq_thread <= memreq_thread_8;
        end
        memreq_thread_8: begin
          memreq_range_52 <= (memreq_range_52 >>> 6) << 6;
          memreq_thread <= memreq_thread_9;
        end
        memreq_thread_9: begin
          $display("MEMREQ start: range %d, num %d, each %d", mem_range_50, num_49, memreq_range_52);
          memreq_thread <= memreq_thread_10;
        end
        memreq_thread_10: begin
          memreq_thread <= memreq_thread_12;
        end
        memreq_thread_11: begin
          memreq_thread <= memreq_thread_1;
        end
        memreq_thread_12: begin
          _memreq_thread_i_0 <= 0;
          memreq_thread <= memreq_thread_13;
        end
        memreq_thread_13: begin
          if(_memreq_thread_i_0 < (num_49 << 2)) begin
            memreq_thread <= memreq_thread_14;
          end else begin
            memreq_thread <= memreq_thread_16;
          end
        end
        memreq_thread_14: begin
          memreq_thread <= memreq_thread_15;
        end
        memreq_thread_15: begin
          _memreq_thread_i_0 <= _memreq_thread_i_0 + 1;
          memreq_thread <= memreq_thread_13;
        end
        memreq_thread_16: begin
          _memreq_thread_i_0 <= 0;
          memreq_thread <= memreq_thread_17;
        end
        memreq_thread_17: begin
          if(_memreq_thread_i_0 < num_49) begin
            memreq_thread <= memreq_thread_18;
          end else begin
            memreq_thread <= memreq_thread_22;
          end
        end
        memreq_thread_18: begin
          addr_51 <= _memreq_thread_i_0 * memreq_range_52;
          memreq_thread <= memreq_thread_19;
        end
        memreq_thread_19: begin
          if(_axi_m_llc_write_req_idle) begin
            memreq_thread <= memreq_thread_20;
          end 
        end
        memreq_thread_20: begin
          if(_axi_m_llc_write_idle && !_axi_m_llc_has_outstanding_write) begin
            memreq_thread <= memreq_thread_21;
          end 
        end
        memreq_thread_21: begin
          _memreq_thread_i_0 <= _memreq_thread_i_0 + 1;
          memreq_thread <= memreq_thread_17;
        end
        memreq_thread_22: begin
          a_54 <= 1664525;
          memreq_thread <= memreq_thread_23;
        end
        memreq_thread_23: begin
          c_55 <= 1013904223;
          memreq_thread <= memreq_thread_24;
        end
        memreq_thread_24: begin
          N_56 <= num_49;
          memreq_thread <= memreq_thread_25;
        end
        memreq_thread_25: begin
          _memreq_thread_i_0 <= 0;
          memreq_thread <= memreq_thread_26;
        end
        memreq_thread_26: begin
          if(_memreq_thread_i_0 < N_56) begin
            memreq_thread <= memreq_thread_27;
          end else begin
            memreq_thread <= memreq_thread_33;
          end
        end
        memreq_thread_27: begin
          x_57 <= _memreq_thread_i_0;
          memreq_thread <= memreq_thread_28;
        end
        memreq_thread_28: begin
          memreq_thread <= memreq_thread_29;
        end
        memreq_thread_29: begin
          y_58 <= (x_57 * a_54 + c_55) % N_56;
          memreq_thread <= memreq_thread_30;
        end
        memreq_thread_30: begin
          if(_axi_m_llc_read_req_idle) begin
            memreq_thread <= memreq_thread_31;
          end 
        end
        memreq_thread_31: begin
          if(_axi_m_llc_read_idle) begin
            memreq_thread <= memreq_thread_32;
          end 
        end
        memreq_thread_32: begin
          _memreq_thread_i_0 <= _memreq_thread_i_0 + 1;
          memreq_thread <= memreq_thread_26;
        end
        memreq_thread_33: begin
          _memreq_thread_i_0 <= 0;
          memreq_thread <= memreq_thread_34;
        end
        memreq_thread_34: begin
          if(_memreq_thread_i_0 < (num_49 << 2)) begin
            memreq_thread <= memreq_thread_35;
          end else begin
            memreq_thread <= memreq_thread_40;
          end
        end
        memreq_thread_35: begin
          if(__tmp_124_1) begin
            read_rdata_125 <= receive_ram_0_rdata;
          end 
          if(__tmp_124_1) begin
            memreq_thread <= memreq_thread_36;
          end 
        end
        memreq_thread_36: begin
          read_llc_data_53 <= read_rdata_125;
          memreq_thread <= memreq_thread_37;
        end
        memreq_thread_37: begin
          if(read_llc_data_53 != (_memreq_thread_i_0 << 1)) begin
            memreq_thread <= memreq_thread_38;
          end else begin
            memreq_thread <= memreq_thread_39;
          end
        end
        memreq_thread_38: begin
          $display("LLC data mismatch %d: %x", _memreq_thread_i_0, read_llc_data_53);
          memreq_thread <= memreq_thread_39;
        end
        memreq_thread_39: begin
          _memreq_thread_i_0 <= _memreq_thread_i_0 + 1;
          memreq_thread <= memreq_thread_34;
        end
        memreq_thread_40: begin
          $display("MEMREQ done");
          memreq_thread <= memreq_thread_41;
        end
      endcase
    end
  end

  localparam _axi_m_llc_write_req_fsm_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_llc_write_req_fsm <= _axi_m_llc_write_req_fsm_init;
      _axi_m_llc_write_cont <= 0;
    end else begin
      case(_axi_m_llc_write_req_fsm)
        _axi_m_llc_write_req_fsm_init: begin
          if((_axi_m_llc_write_req_fsm == 0) && (_axi_m_llc_write_start || _axi_m_llc_write_cont) && !_axi_m_llc_write_req_fifo_almost_full) begin
            _axi_m_llc_write_req_fsm <= _axi_m_llc_write_req_fsm_1;
          end 
        end
        _axi_m_llc_write_req_fsm_1: begin
          if((_axi_m_llc_write_req_fsm == 1) && !_axi_m_llc_write_req_fifo_almost_full && (axi_m_llc_awready || !axi_m_llc_awvalid) && (_axi_m_llc_outstanding_wcount < 6)) begin
            _axi_m_llc_write_cont <= 1;
          end 
          if((_axi_m_llc_write_req_fsm == 1) && !_axi_m_llc_write_req_fifo_almost_full && (axi_m_llc_awready || !axi_m_llc_awvalid) && (_axi_m_llc_outstanding_wcount < 6) && (_axi_m_llc_write_global_size == 0)) begin
            _axi_m_llc_write_cont <= 0;
          end 
          if((_axi_m_llc_write_req_fsm == 1) && !_axi_m_llc_write_req_fifo_almost_full && (axi_m_llc_awready || !axi_m_llc_awvalid) && (_axi_m_llc_outstanding_wcount < 6)) begin
            _axi_m_llc_write_req_fsm <= _axi_m_llc_write_req_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam _axi_m_llc_write_data_fsm_1 = 1;
  localparam _axi_m_llc_write_data_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_llc_write_data_fsm <= _axi_m_llc_write_data_fsm_init;
    end else begin
      case(_axi_m_llc_write_data_fsm)
        _axi_m_llc_write_data_fsm_init: begin
          if(!_axi_m_llc_write_data_busy && !_axi_m_llc_write_req_fifo_empty && (_axi_m_llc_write_op_sel_fifo == 1)) begin
            _axi_m_llc_write_data_fsm <= _axi_m_llc_write_data_fsm_1;
          end 
        end
        _axi_m_llc_write_data_fsm_1: begin
          _axi_m_llc_write_data_fsm <= _axi_m_llc_write_data_fsm_2;
        end
        _axi_m_llc_write_data_fsm_2: begin
          if((_axi_m_llc_write_op_sel_buf == 1) && read_burst_rvalid_92 && ((_axi_m_llc_wready_sb_0 || !_axi_m_llc_wvalid_sb_0) && (_axi_m_llc_write_size_buf > 0)) && read_burst_rlast_93) begin
            _axi_m_llc_write_data_fsm <= _axi_m_llc_write_data_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam read_burst_fsm_0_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      read_burst_fsm_0 <= read_burst_fsm_0_init;
      read_burst_addr_89 <= 0;
      read_burst_stride_90 <= 0;
      read_burst_length_91 <= 0;
      read_burst_rvalid_92 <= 0;
      read_burst_rlast_93 <= 0;
    end else begin
      case(read_burst_fsm_0)
        read_burst_fsm_0_init: begin
          read_burst_addr_89 <= _axi_m_llc_write_local_addr_buf;
          read_burst_stride_90 <= _axi_m_llc_write_local_stride_buf;
          read_burst_length_91 <= _axi_m_llc_write_size_buf;
          read_burst_rvalid_92 <= 0;
          read_burst_rlast_93 <= 0;
          if((_axi_m_llc_write_data_fsm == 1) && (_axi_m_llc_write_op_sel_buf == 1) && (_axi_m_llc_write_size_buf > 0)) begin
            read_burst_fsm_0 <= read_burst_fsm_0_1;
          end 
        end
        read_burst_fsm_0_1: begin
          if((_axi_m_llc_wready_sb_0 || !_axi_m_llc_wvalid_sb_0) && (_axi_m_llc_write_size_buf > 0) && (read_burst_length_91 > 0)) begin
            read_burst_addr_89 <= read_burst_addr_89 + read_burst_stride_90;
            read_burst_length_91 <= read_burst_length_91 - 1;
            read_burst_rvalid_92 <= 1;
          end 
          if((_axi_m_llc_wready_sb_0 || !_axi_m_llc_wvalid_sb_0) && (_axi_m_llc_write_size_buf > 0) && (read_burst_length_91 <= 1)) begin
            read_burst_rlast_93 <= 1;
          end 
          if(read_burst_rlast_93 && read_burst_rvalid_92 && ((_axi_m_llc_wready_sb_0 || !_axi_m_llc_wvalid_sb_0) && (_axi_m_llc_write_size_buf > 0))) begin
            read_burst_rvalid_92 <= 0;
            read_burst_rlast_93 <= 0;
          end 
          if(0) begin
            read_burst_rvalid_92 <= 0;
            read_burst_rlast_93 <= 0;
          end 
          if(read_burst_rlast_93 && read_burst_rvalid_92 && ((_axi_m_llc_wready_sb_0 || !_axi_m_llc_wvalid_sb_0) && (_axi_m_llc_write_size_buf > 0))) begin
            read_burst_fsm_0 <= read_burst_fsm_0_init;
          end 
          if(0) begin
            read_burst_fsm_0 <= read_burst_fsm_0_init;
          end 
        end
      endcase
    end
  end

  localparam _axi_m_llc_read_req_fsm_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_llc_read_req_fsm <= _axi_m_llc_read_req_fsm_init;
      _axi_m_llc_read_cont <= 0;
    end else begin
      case(_axi_m_llc_read_req_fsm)
        _axi_m_llc_read_req_fsm_init: begin
          if((_axi_m_llc_read_req_fsm == 0) && (_axi_m_llc_read_start || _axi_m_llc_read_cont) && !_axi_m_llc_read_req_fifo_almost_full) begin
            _axi_m_llc_read_req_fsm <= _axi_m_llc_read_req_fsm_1;
          end 
        end
        _axi_m_llc_read_req_fsm_1: begin
          if(axi_m_llc_arready || !axi_m_llc_arvalid) begin
            _axi_m_llc_read_cont <= 1;
          end 
          if((axi_m_llc_arready || !axi_m_llc_arvalid) && (_axi_m_llc_read_global_size == 0)) begin
            _axi_m_llc_read_cont <= 0;
          end 
          if(axi_m_llc_arready || !axi_m_llc_arvalid) begin
            _axi_m_llc_read_req_fsm <= _axi_m_llc_read_req_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam _axi_m_llc_read_data_fsm_1 = 1;
  localparam _axi_m_llc_read_data_fsm_2 = 2;

  always @(posedge CLK) begin
    if(RST) begin
      _axi_m_llc_read_data_fsm <= _axi_m_llc_read_data_fsm_init;
    end else begin
      case(_axi_m_llc_read_data_fsm)
        _axi_m_llc_read_data_fsm_init: begin
          if(!_axi_m_llc_read_data_busy && !_axi_m_llc_read_req_fifo_empty && (_axi_m_llc_read_op_sel_fifo == 1)) begin
            _axi_m_llc_read_data_fsm <= _axi_m_llc_read_data_fsm_1;
          end 
        end
        _axi_m_llc_read_data_fsm_1: begin
          _axi_m_llc_read_data_fsm <= _axi_m_llc_read_data_fsm_2;
        end
        _axi_m_llc_read_data_fsm_2: begin
          if(_axi_m_llc_rvalid_sb_0 && (_axi_m_llc_read_local_size_buf <= 1)) begin
            _axi_m_llc_read_data_fsm <= _axi_m_llc_read_data_fsm_init;
          end 
        end
      endcase
    end
  end

  localparam write_burst_fsm_1_1 = 1;

  always @(posedge CLK) begin
    if(RST) begin
      write_burst_fsm_1 <= write_burst_fsm_1_init;
      write_burst_addr_119 <= 0;
      write_burst_stride_120 <= 0;
      write_burst_length_121 <= 0;
      write_burst_done_122 <= 0;
    end else begin
      case(write_burst_fsm_1)
        write_burst_fsm_1_init: begin
          write_burst_addr_119 <= _axi_m_llc_read_local_addr_buf;
          write_burst_stride_120 <= _axi_m_llc_read_local_stride_buf;
          write_burst_length_121 <= _axi_m_llc_read_local_size_buf;
          write_burst_done_122 <= 0;
          if((_axi_m_llc_read_data_fsm == 1) && (_axi_m_llc_read_op_sel_buf == 1) && (_axi_m_llc_read_local_size_buf > 0)) begin
            write_burst_fsm_1 <= write_burst_fsm_1_1;
          end 
        end
        write_burst_fsm_1_1: begin
          if(_axi_m_llc_rvalid_sb_0) begin
            write_burst_addr_119 <= write_burst_addr_119 + write_burst_stride_120;
            write_burst_length_121 <= write_burst_length_121 - 1;
            write_burst_done_122 <= 0;
          end 
          if(_axi_m_llc_rvalid_sb_0 && (write_burst_length_121 <= 1)) begin
            write_burst_done_122 <= 1;
          end 
          if(_axi_m_llc_rvalid_sb_0 && 0) begin
            write_burst_done_122 <= 1;
          end 
          if(_axi_m_llc_rvalid_sb_0 && (write_burst_length_121 <= 1)) begin
            write_burst_fsm_1 <= write_burst_fsm_1_init;
          end 
          if(_axi_m_llc_rvalid_sb_0 && 0) begin
            write_burst_fsm_1 <= write_burst_fsm_1_init;
          end 
          if(0) begin
            write_burst_fsm_1 <= write_burst_fsm_1_init;
          end 
        end
      endcase
    end
  end


endmodule



module _axi_m_llc_read_req_fifo
(
  input CLK,
  input RST,
  input _axi_m_llc_read_req_fifo_enq,
  input [137-1:0] _axi_m_llc_read_req_fifo_wdata,
  output _axi_m_llc_read_req_fifo_full,
  output _axi_m_llc_read_req_fifo_almost_full,
  input _axi_m_llc_read_req_fifo_deq,
  output [137-1:0] _axi_m_llc_read_req_fifo_rdata,
  output _axi_m_llc_read_req_fifo_empty,
  output _axi_m_llc_read_req_fifo_almost_empty
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
  assign _axi_m_llc_read_req_fifo_full = is_full;
  assign _axi_m_llc_read_req_fifo_almost_full = is_almost_full || is_full;
  assign _axi_m_llc_read_req_fifo_empty = is_empty;
  assign _axi_m_llc_read_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axi_m_llc_read_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axi_m_llc_read_req_fifo_enq && !is_full) begin
        mem[head] <= _axi_m_llc_read_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axi_m_llc_read_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module _axi_m_llc_write_req_fifo
(
  input CLK,
  input RST,
  input _axi_m_llc_write_req_fifo_enq,
  input [137-1:0] _axi_m_llc_write_req_fifo_wdata,
  output _axi_m_llc_write_req_fifo_full,
  output _axi_m_llc_write_req_fifo_almost_full,
  input _axi_m_llc_write_req_fifo_deq,
  output [137-1:0] _axi_m_llc_write_req_fifo_rdata,
  output _axi_m_llc_write_req_fifo_empty,
  output _axi_m_llc_write_req_fifo_almost_empty
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
  assign _axi_m_llc_write_req_fifo_full = is_full;
  assign _axi_m_llc_write_req_fifo_almost_full = is_almost_full || is_full;
  assign _axi_m_llc_write_req_fifo_empty = is_empty;
  assign _axi_m_llc_write_req_fifo_almost_empty = is_almost_empty || is_empty;
  assign rdata = mem[tail];
  assign _axi_m_llc_write_req_fifo_rdata = rdata;

  always @(posedge CLK) begin
    if(RST) begin
      head <= 0;
      tail <= 0;
    end else begin
      if(_axi_m_llc_write_req_fifo_enq && !is_full) begin
        mem[head] <= _axi_m_llc_write_req_fifo_wdata;
        head <= head + 1;
      end 
      if(_axi_m_llc_write_req_fifo_deq && !is_empty) begin
        tail <= tail + 1;
      end 
    end
  end


endmodule



module request_ram
(
  input CLK,
  input [20-1:0] request_ram_0_addr,
  output [128-1:0] request_ram_0_rdata,
  input [128-1:0] request_ram_0_wdata,
  input request_ram_0_wenable,
  input request_ram_0_enable
);

  reg [128-1:0] request_ram_0_rdata_out;
  assign request_ram_0_rdata = request_ram_0_rdata_out;
  reg [128-1:0] mem [0:1048576-1];

  always @(posedge CLK) begin
    if(request_ram_0_enable) begin
      if(request_ram_0_wenable) begin
        mem[request_ram_0_addr] <= request_ram_0_wdata;
        request_ram_0_rdata_out <= request_ram_0_wdata;
      end else begin
        request_ram_0_rdata_out <= mem[request_ram_0_addr];
      end
    end 
  end


endmodule



module receive_ram
(
  input CLK,
  input [20-1:0] receive_ram_0_addr,
  output [128-1:0] receive_ram_0_rdata,
  input [128-1:0] receive_ram_0_wdata,
  input receive_ram_0_wenable,
  input receive_ram_0_enable
);

  reg [128-1:0] receive_ram_0_rdata_out;
  assign receive_ram_0_rdata = receive_ram_0_rdata_out;
  reg [128-1:0] mem [0:1048576-1];

  always @(posedge CLK) begin
    if(receive_ram_0_enable) begin
      if(receive_ram_0_wenable) begin
        mem[receive_ram_0_addr] <= receive_ram_0_wdata;
        receive_ram_0_rdata_out <= receive_ram_0_wdata;
      end else begin
        receive_ram_0_rdata_out <= mem[receive_ram_0_addr];
      end
    end 
  end


endmodule

