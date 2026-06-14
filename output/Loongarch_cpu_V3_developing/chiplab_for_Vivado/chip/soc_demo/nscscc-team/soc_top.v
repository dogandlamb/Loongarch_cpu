/*------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Copyright (c) 2016, Loongson Technology Corporation Limited.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this 
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

3. Neither the name of Loongson Technology Corporation Limited nor the names of 
its contributors may be used to endorse or promote products derived from this 
software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL LOONGSON TECHNOLOGY CORPORATION LIMITED BE LIABLE
TO ANY PARTY FOR DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

//*************************************************************************
//   > File Name   : soc_top.v
//   > Description : SoC, included cpu, 2 x 3 bridge,
//                   inst ram, confreg, data ram
// 
//           -------------------------
//           |           cpu         |
//           -------------------------
//                       | axi
//                       | 
//             ---------------------
//             |    1 x 2 bridge   |
//             ---------------------
//                  |            |           
//                  |            |           
//             -----------   -----------
//             | axi ram |   | confreg |
//             -----------   -----------
//
//   > Author      : LOONGSON
//   > Date        : 2017-08-04
//*************************************************************************
`include "soc_config.vh"

module soc_top #(parameter SIMULATION=1'b0)
(
    input         resetn_fpga, 
    input         clk,

    //------DDR3 interface------
    inout  [15:0] ddr3_dq,
    output [12:0] ddr3_addr,
    output [2 :0] ddr3_ba,
    output        ddr3_ras_n,
    output        ddr3_cas_n,
    output        ddr3_we_n,
    output        ddr3_odt,
    output        ddr3_reset_n,
    output        ddr3_cke,
    output [1:0]  ddr3_dm,
    inout  [1:0]  ddr3_dqs_p,
    inout  [1:0]  ddr3_dqs_n,
    output        ddr3_ck_p,
    output        ddr3_ck_n,

    //------gpio-------
    output [15:0] led,
    output [1 :0] led_rg0,
    output [1 :0] led_rg1,
    output [7 :0] num_csn,
    output [6 :0] num_a_g,
    input  [7 :0] switch_fpga, 
    output [3 :0] btn_key_col,
    input  [3 :0] btn_key_row,
    input  [1 :0] btn_step_fpga,

    //------uart-------
    inout         UART_RX,
    inout         UART_TX
);

wire [31:0] num_data;
wire resetn_vio;
wire resetn;
wire [7:0] switch_vio;
wire [7:0] switch;
wire [1:0] btn_step_vio;
wire [1:0] btn_step;
reg        virtual_flag;

assign resetn = resetn_fpga & resetn_vio;
always @ (posedge clk) begin
	if      (!resetn_vio ) virtual_flag <= 1'b1;
	else if (!resetn_fpga) virtual_flag <= 1'b0;
end

assign switch   = virtual_flag ? switch_vio   : switch_fpga;
assign btn_step = virtual_flag ? btn_step_vio : btn_step_fpga;


vio_0 vio (
        .clk       (clk),
        .probe_out0(resetn_vio),
        .probe_out1(switch_vio),
        .probe_out2(btn_step_vio),
        .probe_in0 (led),
        .probe_in1 (num_data),
        .probe_in2 (led_rg0 ),
        .probe_in3 (led_rg1 )
    );

//debug signals
wire [31:0] debug_wb_pc;
wire [3 :0] debug_wb_rf_wen;
wire [4 :0] debug_wb_rf_wnum;
wire [31:0] debug_wb_rf_wdata;

//clk and resetn
reg clk_91m;
reg clk_200m;
wire cpu_clk;
wire sys_clk;
wire ddr_clk_ref;
wire core_rst_n;
wire pll_locked;
wire pll_locked_ddr;
wire cpu_resetn;
wire sys_resetn;
wire confreg_resetn;
wire jtag_axi_resetn;
wire ddr_aresetn;
wire ddr_data_init;

generate if(SIMULATION && `SIMU_USE_PLL==0) begin: sim_clk
    //simulation clk.
    initial begin 
        clk_91m = 1'b0;
        clk_200m = 1'b0;
    end
    always #5.5 clk_91m = ~clk_91m;
    always #2.5 clk_200m = ~clk_200m;

    assign cpu_clk = clk_91m;
    assign sys_clk = clk;
    assign ddr_clk_ref = clk_200m;
    rst_sync u_rst_sys(
        .clk(sys_clk),
        .rst_n_in(resetn & ddr_data_init),
        .rst_n_out(sys_resetn)
    );
    rst_sync u_rst_cpu(
        .clk(cpu_clk),
        .rst_n_in(sys_resetn),
        .rst_n_out(cpu_resetn)
    );
    assign jtag_axi_resetn = 1'b0;
    assign confreg_resetn    = sys_resetn;
end
else if(SIMULATION && `SIMU_USE_PLL==1) begin: sim_pll_clk
    clk_pll u_clk_pll(
        .cpu_clk    (cpu_clk),
        .sys_clk    (sys_clk),
        .resetn     (resetn),
        .locked     (pll_locked),
        .clk_in1    (clk)
    );
    clk_pll_ddr u_clk_pll_ddr(
        .ddr_clk    (ddr_clk_ref),
        .resetn     (resetn),
        .locked     (pll_locked_ddr),
        .clk_in1    (clk)
    );
    rst_sync u_rst_sys(
        .clk(sys_clk),
        .rst_n_in(pll_locked & pll_locked_ddr & ddr_data_init),
        .rst_n_out(sys_resetn)
    );
    rst_sync u_rst_cpu(
        .clk(cpu_clk),
        .rst_n_in(sys_resetn),
        .rst_n_out(cpu_resetn)
    );
    assign jtag_axi_resetn = 1'b0;
    assign confreg_resetn    = sys_resetn;
end
else begin: fpga_pll
    clk_pll u_clk_pll(
        .cpu_clk    (cpu_clk),
        .sys_clk    (sys_clk),
        .resetn     (resetn),
        .locked     (pll_locked),
        .clk_in1    (clk)
    );
    clk_pll_ddr u_clk_pll_ddr(
        .ddr_clk    (ddr_clk_ref),
        .resetn     (resetn),
        .locked     (pll_locked_ddr),
        .clk_in1    (clk)
    );
    rst_sync u_rst_sys(
        .clk(sys_clk),
        .rst_n_in(pll_locked & pll_locked_ddr & ddr_aresetn),
        .rst_n_out(sys_resetn)
    );
    rst_sync u_rst_cpu(
        .clk(cpu_clk),
        .rst_n_in(core_rst_n),
        .rst_n_out(cpu_resetn)
    );
    assign jtag_axi_resetn = sys_resetn;
    assign confreg_resetn    = core_rst_n;
end
endgenerate

//cpu axi
wire [3 :0] cpu_arid   ;
wire [31:0] cpu_araddr ;
wire [3 :0] cpu_arlen  ;
wire [2 :0] cpu_arsize ;
wire [1 :0] cpu_arburst;
wire [1 :0] cpu_arlock ;
wire [3 :0] cpu_arcache;
wire [2 :0] cpu_arprot ;
wire        cpu_arvalid;
wire        cpu_arready;
wire [3 :0] cpu_rid    ;
wire [31:0] cpu_rdata  ;
wire [1 :0] cpu_rresp  ;
wire        cpu_rlast  ;
wire        cpu_rvalid ;
wire        cpu_rready ;
wire [3 :0] cpu_awid   ;
wire [31:0] cpu_awaddr ;
wire [3 :0] cpu_awlen  ;
wire [2 :0] cpu_awsize ;
wire [1 :0] cpu_awburst;
wire [1 :0] cpu_awlock ;
wire [3 :0] cpu_awcache;
wire [2 :0] cpu_awprot ;
wire        cpu_awvalid;
wire        cpu_awready;
wire [3 :0] cpu_wid    ;
wire [31:0] cpu_wdata  ;
wire [3 :0] cpu_wstrb  ;
wire        cpu_wlast  ;
wire        cpu_wvalid ;
wire        cpu_wready ;
wire [3 :0] cpu_bid    ;
wire [1 :0] cpu_bresp  ;
wire        cpu_bvalid ;
wire        cpu_bready ;

//cpu axi4
wire [3 :0] cpu_axi4_arid   ;
wire [31:0] cpu_axi4_araddr ;
wire [7 :0] cpu_axi4_arlen  ;
wire [2 :0] cpu_axi4_arsize ;
wire [1 :0] cpu_axi4_arburst;
wire        cpu_axi4_arlock ;
wire [3 :0] cpu_axi4_arcache;
wire [2 :0] cpu_axi4_arprot ;
wire        cpu_axi4_arvalid;
wire        cpu_axi4_arready;
wire [3 :0] cpu_axi4_rid    ;
wire [31:0] cpu_axi4_rdata  ;
wire [1 :0] cpu_axi4_rresp  ;
wire        cpu_axi4_rlast  ;
wire        cpu_axi4_rvalid ;
wire        cpu_axi4_rready ;
wire [3 :0] cpu_axi4_awid   ;
wire [31:0] cpu_axi4_awaddr ;
wire [7 :0] cpu_axi4_awlen  ;
wire [2 :0] cpu_axi4_awsize ;
wire [1 :0] cpu_axi4_awburst;
wire        cpu_axi4_awlock ;
wire [3 :0] cpu_axi4_awcache;
wire [2 :0] cpu_axi4_awprot ;
wire        cpu_axi4_awvalid;
wire        cpu_axi4_awready;
wire [31:0] cpu_axi4_wdata  ;
wire [3 :0] cpu_axi4_wstrb  ;
wire        cpu_axi4_wlast  ;
wire        cpu_axi4_wvalid ;
wire        cpu_axi4_wready ;
wire [3 :0] cpu_axi4_bid    ;
wire [1 :0] cpu_axi4_bresp  ;
wire        cpu_axi4_bvalid ;
wire        cpu_axi4_bready ;

//cpu axi sync
wire [3 :0] cpu_sync_arid   ;
wire [31:0] cpu_sync_araddr ;
wire [7 :0] cpu_sync_arlen  ;
wire [2 :0] cpu_sync_arsize ;
wire [1 :0] cpu_sync_arburst;
wire        cpu_sync_arlock ;
wire [3 :0] cpu_sync_arcache;
wire [2 :0] cpu_sync_arprot ;
wire        cpu_sync_arvalid;
wire        cpu_sync_arready;
wire [3 :0] cpu_sync_rid    ;
wire [31:0] cpu_sync_rdata  ;
wire [1 :0] cpu_sync_rresp  ;
wire        cpu_sync_rlast  ;
wire        cpu_sync_rvalid ;
wire        cpu_sync_rready ;
wire [3 :0] cpu_sync_awid   ;
wire [31:0] cpu_sync_awaddr ;
wire [7 :0] cpu_sync_awlen  ;
wire [2 :0] cpu_sync_awsize ;
wire [1 :0] cpu_sync_awburst;
wire        cpu_sync_awlock ;
wire [3 :0] cpu_sync_awcache;
wire [2 :0] cpu_sync_awprot ;
wire        cpu_sync_awvalid;
wire        cpu_sync_awready;
wire [3 :0] cpu_sync_wid    ;
wire [31:0] cpu_sync_wdata  ;
wire [3 :0] cpu_sync_wstrb  ;
wire        cpu_sync_wlast  ;
wire        cpu_sync_wvalid ;
wire        cpu_sync_wready ;
wire [3 :0] cpu_sync_bid    ;
wire [1 :0] cpu_sync_bresp  ;
wire        cpu_sync_bvalid ;
wire        cpu_sync_bready ;

//axi ram
wire [3 :0] ram_arid   ;
wire [31:0] ram_araddr ;
wire [7 :0] ram_arlen  ;
wire [2 :0] ram_arsize ;
wire [1 :0] ram_arburst;
wire        ram_arlock ;
wire [3 :0] ram_arcache;
wire [2 :0] ram_arprot ;
wire        ram_arvalid;
wire        ram_arready;
wire [3 :0] ram_rid    ;
wire [31:0] ram_rdata  ;
wire [1 :0] ram_rresp  ;
wire        ram_rlast  ;
wire        ram_rvalid ;
wire        ram_rready ;
wire [3 :0] ram_awid   ;
wire [31:0] ram_awaddr ;
wire [7 :0] ram_awlen  ;
wire [2 :0] ram_awsize ;
wire [1 :0] ram_awburst;
wire        ram_awlock ;
wire [3 :0] ram_awcache;
wire [2 :0] ram_awprot ;
wire        ram_awvalid;
wire        ram_awready;
wire [31:0] ram_wdata  ;
wire [3 :0] ram_wstrb  ;
wire        ram_wlast  ;
wire        ram_wvalid ;
wire        ram_wready ;
wire [3 :0] ram_bid    ;
wire [1 :0] ram_bresp  ;
wire        ram_bvalid ;
wire        ram_bready ;

//conf
wire [3 :0] conf_arid   ;
wire [31:0] conf_araddr ;
wire [7 :0] conf_arlen  ;
wire [2 :0] conf_arsize ;
wire [1 :0] conf_arburst;
wire        conf_arlock ;
wire [3 :0] conf_arcache;
wire [2 :0] conf_arprot ;
wire        conf_arvalid;
wire        conf_arready;
wire [3 :0] conf_rid    ;
wire [31:0] conf_rdata  ;
wire [1 :0] conf_rresp  ;
wire        conf_rlast  ;
wire        conf_rvalid ;
wire        conf_rready ;
wire [3 :0] conf_awid   ;
wire [31:0] conf_awaddr ;
wire [7 :0] conf_awlen  ;
wire [2 :0] conf_awsize ;
wire [1 :0] conf_awburst;
wire        conf_awlock ;
wire [3 :0] conf_awcache;
wire [2 :0] conf_awprot ;
wire        conf_awvalid;
wire        conf_awready;
wire [3 :0] conf_wid    ;
wire [31:0] conf_wdata  ;
wire [3 :0] conf_wstrb  ;
wire        conf_wlast  ;
wire        conf_wvalid ;
wire        conf_wready ;
wire [3 :0] conf_bid    ;
wire [1 :0] conf_bresp  ;
wire        conf_bvalid ;
wire        conf_bready ;

//jtag_axi
wire            jtag_axi_arready;
wire  [ 3:0]    jtag_axi_rid;
wire  [31:0]    jtag_axi_rdata;
wire  [ 1:0]    jtag_axi_rresp;
wire            jtag_axi_rlast;
wire            jtag_axi_rvalid;
wire            jtag_axi_awready;
wire            jtag_axi_wready;
wire  [ 3:0]    jtag_axi_bid;
wire  [ 1:0]    jtag_axi_bresp;
wire            jtag_axi_bvalid;
wire  [ 3:0]    jtag_axi_arid;
wire  [31:0]    jtag_axi_araddr;
wire  [ 7:0]    jtag_axi_arlen;
wire  [ 2:0]    jtag_axi_arsize;
wire  [ 1:0]    jtag_axi_arburst;
wire            jtag_axi_arlock;
wire  [ 3:0]    jtag_axi_arcache;
wire  [ 2:0]    jtag_axi_arprot;
wire            jtag_axi_arvalid;
wire            jtag_axi_rready;
wire  [ 3:0]    jtag_axi_awid;
wire  [31:0]    jtag_axi_awaddr;
wire  [ 7:0]    jtag_axi_awlen;
wire  [ 2:0]    jtag_axi_awsize;
wire  [ 1:0]    jtag_axi_awburst;
wire            jtag_axi_awlock;
wire  [ 3:0]    jtag_axi_awcache;
wire  [ 2:0]    jtag_axi_awprot;
wire            jtag_axi_awvalid;
wire  [31:0]    jtag_axi_wdata;
wire  [ 3:0]    jtag_axi_wstrb;
wire            jtag_axi_wlast;
wire            jtag_axi_wvalid;
wire            jtag_axi_bready;

//uart axi
wire  uart_arready;
wire  [ 3:0]  uart_rid;
wire  [31:0]  uart_rdata;
wire  [ 1:0]  uart_rresp;
wire  uart_rlast;
wire  uart_rvalid;
wire  uart_awready;
wire  uart_wready;
wire  [ 3:0]  uart_bid;
wire  [ 1:0]  uart_bresp;
wire  uart_bvalid;
wire  [ 3:0]  uart_arid;
wire  [31:0]  uart_araddr;
wire  [ 7:0]  uart_arlen;
wire  [ 2:0]  uart_arsize;
wire  [ 1:0]  uart_arburst;
wire          uart_arlock;
wire  [ 3:0]  uart_arcache;
wire  [ 2:0]  uart_arprot;
wire  uart_arvalid;
wire  uart_rready;
wire  [ 3:0]  uart_awid;
wire  [31:0]  uart_awaddr;
wire  [ 7:0]  uart_awlen;
wire  [ 2:0]  uart_awsize;
wire  [ 1:0]  uart_awburst;
wire          uart_awlock;
wire  [ 3:0]  uart_awcache;
wire  [ 2:0]  uart_awprot;
wire  uart_awvalid;
wire  [ 3:0]  uart_wid;
wire  [31:0]  uart_wdata;
wire  [ 3:0]  uart_wstrb;
wire  uart_wlast;
wire  uart_wvalid;
wire  uart_bready;
wire  irq_rx;

//uart
wire UART_CTS,   UART_RTS;
wire UART_DTR,   UART_DSR;
wire UART_RI,    UART_DCD;
assign UART_CTS = 1'b0;
assign UART_DSR = 1'b0;
assign UART_DCD = 1'b0;
assign UART_RI  = 1'b0;
wire uart0_int   ;
wire uart0_txd_o ;
wire uart0_txd_i ;
wire uart0_txd_oe;
wire uart0_rxd_o ;
wire uart0_rxd_i ;
wire uart0_rxd_oe;
wire uart0_rts_o ;
wire uart0_cts_i ;
wire uart0_dsr_i ;
wire uart0_dcd_i ;
wire uart0_dtr_o ;
wire uart0_ri_i  ;
assign     UART_RX     = uart0_rxd_oe ? 1'bz : uart0_rxd_o ;
assign     UART_TX     = uart0_txd_oe ? 1'bz : uart0_txd_o ;
assign     UART_RTS    = uart0_rts_o ;
assign     UART_DTR    = uart0_dtr_o ;
assign     uart0_txd_i = UART_TX;
assign     uart0_rxd_i = UART_RX;
assign     uart0_cts_i = UART_CTS;
assign     uart0_dcd_i = UART_DCD;
assign     uart0_dsr_i = UART_DSR;
assign     uart0_ri_i  = UART_RI ;

//for lab6
wire [4 :0] ram_random_mask;

//cpu axi
//debug_*
core_top u_cpu(
    .intrpt    (8'd0          ),   //high active

    .aclk      (cpu_clk       ),
    .aresetn   (cpu_resetn    ),   //low active

    .arid      (cpu_arid      ),
    .araddr    (cpu_araddr    ),
    .arlen     (cpu_arlen     ),
    .arsize    (cpu_arsize    ),
    .arburst   (cpu_arburst   ),
    .arlock    (cpu_arlock    ),
    .arcache   (cpu_arcache   ),
    .arprot    (cpu_arprot    ),
    .arvalid   (cpu_arvalid   ),
    .arready   (cpu_arready   ),
                
    .rid       (cpu_rid       ),
    .rdata     (cpu_rdata     ),
    .rresp     (cpu_rresp     ),
    .rlast     (cpu_rlast     ),
    .rvalid    (cpu_rvalid    ),
    .rready    (cpu_rready    ),
               
    .awid      (cpu_awid      ),
    .awaddr    (cpu_awaddr    ),
    .awlen     (cpu_awlen     ),
    .awsize    (cpu_awsize    ),
    .awburst   (cpu_awburst   ),
    .awlock    (cpu_awlock    ),
    .awcache   (cpu_awcache   ),
    .awprot    (cpu_awprot    ),
    .awvalid   (cpu_awvalid   ),
    .awready   (cpu_awready   ),
    
    .wid       (cpu_wid       ),
    .wdata     (cpu_wdata     ),
    .wstrb     (cpu_wstrb     ),
    .wlast     (cpu_wlast     ),
    .wvalid    (cpu_wvalid    ),
    .wready    (cpu_wready    ),
    
    .bid       (cpu_bid       ),
    .bresp     (cpu_bresp     ),
    .bvalid    (cpu_bvalid    ),
    .bready    (cpu_bready    ),

    //debug interface
    .break_point        (1'b0               ),
    .infor_flag         (1'b0               ),
    .reg_num            (5'b0               ),
    .ws_valid           (                   ),
    .rf_rdata           (                   ),

    .debug0_wb_pc       (debug_wb_pc        ),
    .debug0_wb_rf_wen   (debug_wb_rf_wen    ),
    .debug0_wb_rf_wnum  (debug_wb_rf_wnum   ),
    .debug0_wb_rf_wdata (debug_wb_rf_wdata  )
);

axi3_to_axi4_bridge #(
    .ADDR_WIDTH         ( 32 ),
    .DATA_WIDTH         ( 32 ),
    .ID_WIDTH           ( 4  ),
    .W_Burst_Length_MAX ( 16 ))
 u_axi3_to_axi4_bridge (
    .clk                     ( cpu_clk            ),
    .rst_n                   ( cpu_resetn         ),
    .s_axi3_awid             ( cpu_awid           ),
    .s_axi3_awaddr           ( cpu_awaddr         ),
    .s_axi3_awlen            ( cpu_awlen          ),
    .s_axi3_awsize           ( cpu_awsize         ),
    .s_axi3_awburst          ( cpu_awburst        ),
    .s_axi3_awlock           ( cpu_awlock         ),
    .s_axi3_awcache          ( cpu_awcache        ),
    .s_axi3_awprot           ( cpu_awprot         ),
    .s_axi3_awvalid          ( cpu_awvalid        ),
    .s_axi3_wid              ( cpu_wid            ),
    .s_axi3_wdata            ( cpu_wdata          ),
    .s_axi3_wstrb            ( cpu_wstrb          ),
    .s_axi3_wlast            ( cpu_wlast          ),
    .s_axi3_wvalid           ( cpu_wvalid         ),
    .s_axi3_bready           ( cpu_bready         ),
    .s_axi3_arid             ( cpu_arid           ),
    .s_axi3_araddr           ( cpu_araddr         ),
    .s_axi3_arlen            ( cpu_arlen          ),
    .s_axi3_arsize           ( cpu_arsize         ),
    .s_axi3_arburst          ( cpu_arburst        ),
    .s_axi3_arlock           ( cpu_arlock         ),
    .s_axi3_arcache          ( cpu_arcache        ),
    .s_axi3_arprot           ( cpu_arprot         ),
    .s_axi3_arvalid          ( cpu_arvalid        ),
    .s_axi3_rready           ( cpu_rready         ),
    .m_axi4_awready          ( cpu_axi4_awready   ),
    .m_axi4_wready           ( cpu_axi4_wready    ),
    .m_axi4_bid              ( cpu_axi4_bid       ),
    .m_axi4_bresp            ( cpu_axi4_bresp     ),
    .m_axi4_bvalid           ( cpu_axi4_bvalid    ),
    .m_axi4_arready          ( cpu_axi4_arready   ),
    .m_axi4_rid              ( cpu_axi4_rid       ),
    .m_axi4_rdata            ( cpu_axi4_rdata     ),
    .m_axi4_rresp            ( cpu_axi4_rresp     ),
    .m_axi4_rlast            ( cpu_axi4_rlast     ),
    .m_axi4_rvalid           ( cpu_axi4_rvalid    ),

    .s_axi3_awready          ( cpu_awready        ),
    .s_axi3_wready           ( cpu_wready         ),
    .s_axi3_bid              ( cpu_bid            ),
    .s_axi3_bresp            ( cpu_bresp          ),
    .s_axi3_bvalid           ( cpu_bvalid         ),
    .s_axi3_arready          ( cpu_arready        ),
    .s_axi3_rid              ( cpu_rid            ),
    .s_axi3_rdata            ( cpu_rdata          ),
    .s_axi3_rresp            ( cpu_rresp          ),
    .s_axi3_rlast            ( cpu_rlast          ),
    .s_axi3_rvalid           ( cpu_rvalid         ),
    .m_axi4_awid             ( cpu_axi4_awid      ),
    .m_axi4_awaddr           ( cpu_axi4_awaddr    ),
    .m_axi4_awlen            ( cpu_axi4_awlen     ),
    .m_axi4_awsize           ( cpu_axi4_awsize    ),
    .m_axi4_awburst          ( cpu_axi4_awburst   ),
    .m_axi4_awlock           ( cpu_axi4_awlock    ),
    .m_axi4_awcache          ( cpu_axi4_awcache   ),
    .m_axi4_awprot           ( cpu_axi4_awprot    ),
    .m_axi4_awvalid          ( cpu_axi4_awvalid   ),
    .m_axi4_wdata            ( cpu_axi4_wdata     ),
    .m_axi4_wstrb            ( cpu_axi4_wstrb     ),
    .m_axi4_wlast            ( cpu_axi4_wlast     ),
    .m_axi4_wvalid           ( cpu_axi4_wvalid    ),
    .m_axi4_bready           ( cpu_axi4_bready    ),
    .m_axi4_arid             ( cpu_axi4_arid      ),
    .m_axi4_araddr           ( cpu_axi4_araddr    ),
    .m_axi4_arlen            ( cpu_axi4_arlen     ),
    .m_axi4_arsize           ( cpu_axi4_arsize    ),
    .m_axi4_arburst          ( cpu_axi4_arburst   ),
    .m_axi4_arlock           ( cpu_axi4_arlock    ),
    .m_axi4_arcache          ( cpu_axi4_arcache   ),
    .m_axi4_arprot           ( cpu_axi4_arprot    ),
    .m_axi4_arvalid          ( cpu_axi4_arvalid   ),
    .m_axi4_rready           ( cpu_axi4_rready    )
);

//clock sync: from CPU to AXI_Crossbar
Axi_CDC  u_axi_clock_sync (
    .axiInClk                ( cpu_clk              ),
    .axiInRst                ( cpu_resetn           ),
    .axiOutClk               ( sys_clk              ),
    .axiOutRst               ( sys_resetn           ),

    .axiIn_awvalid           ( cpu_axi4_awvalid     ),
    .axiIn_awaddr            ( cpu_axi4_awaddr      ),
    .axiIn_awid              ( cpu_axi4_awid        ),
    .axiIn_awlen             ( cpu_axi4_awlen       ),
    .axiIn_awsize            ( cpu_axi4_awsize      ),
    .axiIn_awburst           ( cpu_axi4_awburst     ),
    .axiIn_awlock            ( cpu_axi4_awlock      ),
    .axiIn_awcache           ( cpu_axi4_awcache     ),
    .axiIn_awprot            ( cpu_axi4_awprot      ),
    .axiIn_wvalid            ( cpu_axi4_wvalid      ),
    .axiIn_wdata             ( cpu_axi4_wdata       ),
    .axiIn_wstrb             ( cpu_axi4_wstrb       ),
    .axiIn_wlast             ( cpu_axi4_wlast       ),
    .axiIn_bready            ( cpu_axi4_bready      ),
    .axiIn_arvalid           ( cpu_axi4_arvalid     ),
    .axiIn_araddr            ( cpu_axi4_araddr      ),
    .axiIn_arid              ( cpu_axi4_arid        ),
    .axiIn_arlen             ( cpu_axi4_arlen       ),
    .axiIn_arsize            ( cpu_axi4_arsize      ),
    .axiIn_arburst           ( cpu_axi4_arburst     ),
    .axiIn_arlock            ( cpu_axi4_arlock      ),
    .axiIn_arcache           ( cpu_axi4_arcache     ),
    .axiIn_arprot            ( cpu_axi4_arprot      ),
    .axiIn_rready            ( cpu_axi4_rready      ),
    .axiOut_awready          ( cpu_sync_awready     ),
    .axiOut_wready           ( cpu_sync_wready      ),
    .axiOut_bvalid           ( cpu_sync_bvalid      ),
    .axiOut_bid              ( cpu_sync_bid         ),
    .axiOut_bresp            ( cpu_sync_bresp       ),
    .axiOut_arready          ( cpu_sync_arready     ),
    .axiOut_rvalid           ( cpu_sync_rvalid      ),
    .axiOut_rdata            ( cpu_sync_rdata       ),
    .axiOut_rid              ( cpu_sync_rid         ),
    .axiOut_rresp            ( cpu_sync_rresp       ),
    .axiOut_rlast            ( cpu_sync_rlast       ),

    .axiIn_awready           ( cpu_axi4_awready     ),
    .axiIn_wready            ( cpu_axi4_wready      ),
    .axiIn_bvalid            ( cpu_axi4_bvalid      ),
    .axiIn_bid               ( cpu_axi4_bid         ),
    .axiIn_bresp             ( cpu_axi4_bresp       ),
    .axiIn_arready           ( cpu_axi4_arready     ),
    .axiIn_rvalid            ( cpu_axi4_rvalid      ),
    .axiIn_rdata             ( cpu_axi4_rdata       ),
    .axiIn_rid               ( cpu_axi4_rid         ),
    .axiIn_rresp             ( cpu_axi4_rresp       ),
    .axiIn_rlast             ( cpu_axi4_rlast       ),
    .axiOut_awvalid          ( cpu_sync_awvalid     ),
    .axiOut_awaddr           ( cpu_sync_awaddr      ),
    .axiOut_awid             ( cpu_sync_awid        ),
    .axiOut_awlen            ( cpu_sync_awlen       ),
    .axiOut_awsize           ( cpu_sync_awsize      ),
    .axiOut_awburst          ( cpu_sync_awburst     ),
    .axiOut_awlock           ( cpu_sync_awlock      ),
    .axiOut_awcache          ( cpu_sync_awcache     ),
    .axiOut_awprot           ( cpu_sync_awprot      ),
    .axiOut_wvalid           ( cpu_sync_wvalid      ),
    .axiOut_wdata            ( cpu_sync_wdata       ),
    .axiOut_wstrb            ( cpu_sync_wstrb       ),
    .axiOut_wlast            ( cpu_sync_wlast       ),
    .axiOut_bready           ( cpu_sync_bready      ),
    .axiOut_arvalid          ( cpu_sync_arvalid     ),
    .axiOut_araddr           ( cpu_sync_araddr      ),
    .axiOut_arid             ( cpu_sync_arid        ),
    .axiOut_arlen            ( cpu_sync_arlen       ),
    .axiOut_arsize           ( cpu_sync_arsize      ),
    .axiOut_arburst          ( cpu_sync_arburst     ),
    .axiOut_arlock           ( cpu_sync_arlock      ),
    .axiOut_arcache          ( cpu_sync_arcache     ),
    .axiOut_arprot           ( cpu_sync_arprot      ),
    .axiOut_rready           ( cpu_sync_rready      )
);

jtag_axi_wrap  u_jtag_axi_wrap (
    .aclk                    ( sys_clk            ),
    .aresetn                 ( jtag_axi_resetn    ),
    .m_axi_arready           ( jtag_axi_arready   ),
    .m_axi_rid               ( jtag_axi_rid       ),
    .m_axi_rdata             ( jtag_axi_rdata     ),
    .m_axi_rresp             ( jtag_axi_rresp     ),
    .m_axi_rlast             ( jtag_axi_rlast     ),
    .m_axi_rvalid            ( jtag_axi_rvalid    ),
    .m_axi_awready           ( jtag_axi_awready   ),
    .m_axi_wready            ( jtag_axi_wready    ),
    .m_axi_bid               ( jtag_axi_bid       ),
    .m_axi_bresp             ( jtag_axi_bresp     ),
    .m_axi_bvalid            ( jtag_axi_bvalid    ),

    .m_axi_arid              ( jtag_axi_arid      ),
    .m_axi_araddr            ( jtag_axi_araddr    ),
    .m_axi_arlen             ( jtag_axi_arlen     ),
    .m_axi_arsize            ( jtag_axi_arsize    ),
    .m_axi_arburst           ( jtag_axi_arburst   ),
    .m_axi_arlock            ( jtag_axi_arlock    ),
    .m_axi_arcache           ( jtag_axi_arcache   ),
    .m_axi_arprot            ( jtag_axi_arprot    ),
    .m_axi_arvalid           ( jtag_axi_arvalid   ),
    .m_axi_rready            ( jtag_axi_rready    ),
    .m_axi_awid              ( jtag_axi_awid      ),
    .m_axi_awaddr            ( jtag_axi_awaddr    ),
    .m_axi_awlen             ( jtag_axi_awlen     ),
    .m_axi_awsize            ( jtag_axi_awsize    ),
    .m_axi_awburst           ( jtag_axi_awburst   ),
    .m_axi_awlock            ( jtag_axi_awlock    ),
    .m_axi_awcache           ( jtag_axi_awcache   ),
    .m_axi_awprot            ( jtag_axi_awprot    ),
    .m_axi_awvalid           ( jtag_axi_awvalid   ),
    .m_axi_wdata             ( jtag_axi_wdata     ),
    .m_axi_wstrb             ( jtag_axi_wstrb     ),
    .m_axi_wlast             ( jtag_axi_wlast     ),
    .m_axi_wvalid            ( jtag_axi_wvalid    ),
    .m_axi_bready            ( jtag_axi_bready    ),
    .core_rst_n              ( core_rst_n         )
);

axi_crossbar_2x3 u_axi_crossbar_2x3 (
    .aclk               (sys_clk), 
    .aresetn            (sys_resetn), 

    .s_axi_awid         ( {jtag_axi_awid      ,cpu_sync_awid}),        
    .s_axi_awaddr       ( {jtag_axi_awaddr    ,cpu_sync_awaddr}),    
    .s_axi_awlen        ( {jtag_axi_awlen     ,cpu_sync_awlen}),      
    .s_axi_awsize       ( {jtag_axi_awsize    ,cpu_sync_awsize}),    
    .s_axi_awburst      ( {jtag_axi_awburst   ,cpu_sync_awburst}), 
    .s_axi_awlock       ( {jtag_axi_awlock    ,cpu_sync_awlock}),    
    .s_axi_awcache      ( {jtag_axi_awcache   ,cpu_sync_awcache}), 
    .s_axi_awprot       ( {jtag_axi_awprot    ,cpu_sync_awprot}),    
    .s_axi_awqos        ( 8'h0),     
    .s_axi_awvalid      ( {jtag_axi_awvalid   ,cpu_sync_awvalid}),  
    .s_axi_awready      ( {jtag_axi_awready   ,cpu_sync_awready}),          
    .s_axi_wdata        ( {jtag_axi_wdata     ,cpu_sync_wdata}),     
    .s_axi_wstrb        ( {jtag_axi_wstrb     ,cpu_sync_wstrb}),     
    .s_axi_wlast        ( {jtag_axi_wlast     ,cpu_sync_wlast}),     
    .s_axi_wvalid       ( {jtag_axi_wvalid    ,cpu_sync_wvalid}),  
    .s_axi_wready       ( {jtag_axi_wready    ,cpu_sync_wready}),  
    .s_axi_bid          ( {jtag_axi_bid       ,cpu_sync_bid}),          
    .s_axi_bresp        ( {jtag_axi_bresp     ,cpu_sync_bresp}),     
    .s_axi_bvalid       ( {jtag_axi_bvalid    ,cpu_sync_bvalid}),  
    .s_axi_bready       ( {jtag_axi_bready    ,cpu_sync_bready}),  
    .s_axi_arid         ( {jtag_axi_arid      ,cpu_sync_arid}),        
    .s_axi_araddr       ( {jtag_axi_araddr    ,cpu_sync_araddr}),    
    .s_axi_arlen        ( {jtag_axi_arlen     ,cpu_sync_arlen}),      
    .s_axi_arsize       ( {jtag_axi_arsize    ,cpu_sync_arsize}),    
    .s_axi_arburst      ( {jtag_axi_arburst   ,cpu_sync_arburst} ), 
    .s_axi_arlock       ( {jtag_axi_arlock    ,cpu_sync_arlock} ),    
    .s_axi_arcache      ( {jtag_axi_arcache   ,cpu_sync_arcache} ), 
    .s_axi_arprot       ( {jtag_axi_arprot    ,cpu_sync_arprot} ),    
    .s_axi_arqos        ( 8'h0),      
    .s_axi_arvalid      ( {jtag_axi_arvalid    ,cpu_sync_arvalid} ), 
    .s_axi_arready      ( {jtag_axi_arready    ,cpu_sync_arready} ), 
    .s_axi_rid          ( {jtag_axi_rid        ,cpu_sync_rid} ),          
    .s_axi_rdata        ( {jtag_axi_rdata      ,cpu_sync_rdata} ),    
    .s_axi_rresp        ( {jtag_axi_rresp      ,cpu_sync_rresp} ),    
    .s_axi_rlast        ( {jtag_axi_rlast      ,cpu_sync_rlast} ),    
    .s_axi_rvalid       ( {jtag_axi_rvalid     ,cpu_sync_rvalid} ), 
    .s_axi_rready       ( {jtag_axi_rready     ,cpu_sync_rready} ), 

    .m_axi_arid         ( {uart_arid    ,ram_arid   ,conf_arid   } ),
    .m_axi_araddr       ( {uart_araddr  ,ram_araddr ,conf_araddr } ),
    .m_axi_arlen        ( {uart_arlen   ,ram_arlen  ,conf_arlen  } ),
    .m_axi_arsize       ( {uart_arsize  ,ram_arsize ,conf_arsize } ),
    .m_axi_arburst      ( {uart_arburst ,ram_arburst,conf_arburst} ),
    .m_axi_arlock       ( {uart_arlock  ,ram_arlock ,conf_arlock } ),
    .m_axi_arcache      ( {uart_arcache ,ram_arcache,conf_arcache} ),
    .m_axi_arprot       ( {uart_arprot  ,ram_arprot ,conf_arprot } ),
    .m_axi_arqos        (                            ),
    .m_axi_arvalid      ( {uart_arvalid ,ram_arvalid,conf_arvalid} ),
    .m_axi_arready      ( {uart_arready ,ram_arready,conf_arready} ),
    .m_axi_rid          ( {uart_rid     ,ram_rid    ,conf_rid    } ),
    .m_axi_rdata        ( {uart_rdata   ,ram_rdata  ,conf_rdata  } ),
    .m_axi_rresp        ( {uart_rresp   ,ram_rresp  ,conf_rresp  } ),
    .m_axi_rlast        ( {uart_rlast   ,ram_rlast  ,conf_rlast  } ),
    .m_axi_rvalid       ( {uart_rvalid  ,ram_rvalid ,conf_rvalid } ),
    .m_axi_rready       ( {uart_rready  ,ram_rready ,conf_rready } ),
    .m_axi_awid         ( {uart_awid    ,ram_awid   ,conf_awid   } ),
    .m_axi_awaddr       ( {uart_awaddr  ,ram_awaddr ,conf_awaddr } ),
    .m_axi_awlen        ( {uart_awlen   ,ram_awlen  ,conf_awlen  } ),
    .m_axi_awsize       ( {uart_awsize  ,ram_awsize ,conf_awsize } ),
    .m_axi_awburst      ( {uart_awburst ,ram_awburst,conf_awburst} ),
    .m_axi_awlock       ( {uart_awlock  ,ram_awlock ,conf_awlock } ),
    .m_axi_awcache      ( {uart_awcache ,ram_awcache,conf_awcache} ),
    .m_axi_awprot       ( {uart_awprot  ,ram_awprot ,conf_awprot } ),
    .m_axi_awqos        (                            ),
    .m_axi_awvalid      ( {uart_awvalid ,ram_awvalid,conf_awvalid} ),
    .m_axi_awready      ( {uart_awready ,ram_awready,conf_awready} ),
    .m_axi_wdata        ( {uart_wdata   ,ram_wdata  ,conf_wdata  } ),
    .m_axi_wstrb        ( {uart_wstrb   ,ram_wstrb  ,conf_wstrb  } ),
    .m_axi_wlast        ( {uart_wlast   ,ram_wlast  ,conf_wlast  } ),
    .m_axi_wvalid       ( {uart_wvalid  ,ram_wvalid ,conf_wvalid } ),
    .m_axi_wready       ( {uart_wready  ,ram_wready ,conf_wready } ),
    .m_axi_bid          ( {uart_bid     ,ram_bid    ,conf_bid    } ),
    .m_axi_bresp        ( {uart_bresp   ,ram_bresp  ,conf_bresp  } ),
    .m_axi_bvalid       ( {uart_bvalid  ,ram_bvalid ,conf_bvalid } ),
    .m_axi_bready       ( {uart_bready  ,ram_bready ,conf_bready } )
);

generate if(SIMULATION && `SIMU_USE_DDR==0) begin: sim_ram
//axi ram
axi_wrap_ram u_axi_ram
(
    .aclk          ( sys_clk          ),
    .aresetn       ( sys_resetn       ),
    //ar
    .axi_arid      ( ram_arid         ),
    .axi_araddr    ( ram_araddr       ),
    .axi_arlen     ( ram_arlen        ),
    .axi_arsize    ( ram_arsize       ),
    .axi_arburst   ( ram_arburst      ),
    .axi_arlock    ( ram_arlock       ),
    .axi_arcache   ( ram_arcache      ),
    .axi_arprot    ( ram_arprot       ),
    .axi_arvalid   ( ram_arvalid      ),
    .axi_arready   ( ram_arready      ),
    //r             
    .axi_rid       ( ram_rid          ),
    .axi_rdata     ( ram_rdata        ),
    .axi_rresp     ( ram_rresp        ),
    .axi_rlast     ( ram_rlast        ),
    .axi_rvalid    ( ram_rvalid       ),
    .axi_rready    ( ram_rready       ),
    //aw           
    .axi_awid      ( ram_awid         ),
    .axi_awaddr    ( ram_awaddr       ),
    .axi_awlen     ( ram_awlen        ),
    .axi_awsize    ( ram_awsize       ),
    .axi_awburst   ( ram_awburst      ),
    .axi_awlock    ( ram_awlock       ),
    .axi_awcache   ( ram_awcache      ),
    .axi_awprot    ( ram_awprot       ),
    .axi_awvalid   ( ram_awvalid      ),
    .axi_awready   ( ram_awready      ),
    //w          
    .axi_wdata     ( ram_wdata        ),
    .axi_wstrb     ( ram_wstrb        ),
    .axi_wlast     ( ram_wlast        ),
    .axi_wvalid    ( ram_wvalid       ),
    .axi_wready    ( ram_wready       ),
    //b              ram
    .axi_bid       ( ram_bid          ),
    .axi_bresp     ( ram_bresp        ),
    .axi_bvalid    ( ram_bvalid       ),
    .axi_bready    ( ram_bready       ),

    //random mask
    .ram_random_mask ( ram_random_mask )
);
end
else begin : ddr3

axi_wrap_ddr  u_axi_wrap_ddr (
    .aclk                    ( sys_clk           ),
    .aresetn                 ( sys_resetn        ),
    .xtal_clk                ( clk               ),
    .button_resetn           ( resetn            ),
    .ddr_clk_ref             ( ddr_clk_ref       ),
    .axi_arid                ( ram_arid          ),
    .axi_araddr              ( ram_araddr        ),
    .axi_arlen               ( ram_arlen         ),
    .axi_arsize              ( ram_arsize        ),
    .axi_arburst             ( ram_arburst       ),
    .axi_arlock              ( ram_arlock        ),
    .axi_arcache             ( ram_arcache       ),
    .axi_arprot              ( ram_arprot        ),
    .axi_arvalid             ( ram_arvalid       ),
    .axi_rready              ( ram_rready        ),
    .axi_awid                ( ram_awid          ),
    .axi_awaddr              ( ram_awaddr        ),
    .axi_awlen               ( ram_awlen         ),
    .axi_awsize              ( ram_awsize        ),
    .axi_awburst             ( ram_awburst       ),
    .axi_awlock              ( ram_awlock        ),
    .axi_awcache             ( ram_awcache       ),
    .axi_awprot              ( ram_awprot        ),
    .axi_awvalid             ( ram_awvalid       ),
    .axi_wdata               ( ram_wdata         ),
    .axi_wstrb               ( ram_wstrb         ),
    .axi_wlast               ( ram_wlast         ),
    .axi_wvalid              ( ram_wvalid        ),
    .axi_bready              ( ram_bready        ),
    .ram_random_mask         ( ram_random_mask   ),

    .ddr_aresetn             ( ddr_aresetn       ),
    .axi_arready             ( ram_arready       ),
    .axi_rid                 ( ram_rid           ),
    .axi_rdata               ( ram_rdata         ),
    .axi_rresp               ( ram_rresp         ),
    .axi_rlast               ( ram_rlast         ),
    .axi_rvalid              ( ram_rvalid        ),
    .axi_awready             ( ram_awready       ),
    .axi_wready              ( ram_wready        ),
    .axi_bid                 ( ram_bid           ),
    .axi_bresp               ( ram_bresp         ),
    .axi_bvalid              ( ram_bvalid        ),
    .ddr3_addr               ( ddr3_addr         ),
    .ddr3_ba                 ( ddr3_ba           ),
    .ddr3_ras_n              ( ddr3_ras_n        ),
    .ddr3_cas_n              ( ddr3_cas_n        ),
    .ddr3_we_n               ( ddr3_we_n         ),
    .ddr3_odt                ( ddr3_odt          ),
    .ddr3_reset_n            ( ddr3_reset_n      ),
    .ddr3_cke                ( ddr3_cke          ),
    .ddr3_dm                 ( ddr3_dm           ),
    .ddr3_ck_p               ( ddr3_ck_p         ),
    .ddr3_ck_n               ( ddr3_ck_n         ),

    .ddr3_dq                 ( ddr3_dq           ),
    .ddr3_dqs_p              ( ddr3_dqs_p        ),
    .ddr3_dqs_n              ( ddr3_dqs_n        )
);

end
endgenerate

//confreg
confreg #(.SIMULATION(SIMULATION)) u_confreg
(
    .timer_clk   ( sys_clk          ),  // i, 1   
    .aclk        ( sys_clk          ),  // i, 1   
    .aresetn     ( confreg_resetn   ),  // i, 1   
    .sys_resetn  ( sys_resetn       ),    

    .arid        (conf_arid    ),
    .araddr      (conf_araddr  ),
    .arlen       (conf_arlen   ),
    .arsize      (conf_arsize  ),
    .arburst     (conf_arburst ),
    .arlock      (conf_arlock  ),
    .arcache     (conf_arcache ),
    .arprot      (conf_arprot  ),
    .arvalid     (conf_arvalid ),
    .arready     (conf_arready ),
    .rid         (conf_rid     ),
    .rdata       (conf_rdata   ),
    .rresp       (conf_rresp   ),
    .rlast       (conf_rlast   ),
    .rvalid      (conf_rvalid  ),
    .rready      (conf_rready  ),
    .awid        (conf_awid    ),
    .awaddr      (conf_awaddr  ),
    .awlen       (conf_awlen   ),
    .awsize      (conf_awsize  ),
    .awburst     (conf_awburst ),
    .awlock      (conf_awlock  ),
    .awcache     (conf_awcache ),
    .awprot      (conf_awprot  ),
    .awvalid     (conf_awvalid ),
    .awready     (conf_awready ),
    .wdata       (conf_wdata   ),
    .wstrb       (conf_wstrb   ),
    .wlast       (conf_wlast   ),
    .wvalid      (conf_wvalid  ),
    .wready      (conf_wready  ),
    .bid         (conf_bid     ),
    .bresp       (conf_bresp   ),
    .bvalid      (conf_bvalid  ),
    .bready      (conf_bready  ), 

    .ram_random_mask ( ram_random_mask ),
    .led         ( led        ),  // o, 16   
    .led_rg0     ( led_rg0    ),  // o, 2      
    .led_rg1     ( led_rg1    ),  // o, 2      
    .num_csn     ( num_csn    ),  // o, 8      
    .num_a_g     ( num_a_g    ),  // o, 7
    .num_data    ( num_data   ),  // o, 32      
    .switch      ( switch     ),  // i, 8     
    .btn_key_col ( btn_key_col),  // o, 4          
    .btn_key_row ( btn_key_row),  // i, 4           
    .btn_step    ( btn_step   )   // i, 2   
);

//AXI2APB
axi2apb_misc APB_DEV 
(
    .clk                (sys_clk                ),
    .rst_n              (sys_resetn             ),

    .axi_s_awid         (uart_awid              ),
    .axi_s_awaddr       (uart_awaddr            ),
    .axi_s_awlen        (uart_awlen             ),
    .axi_s_awsize       (uart_awsize            ),
    .axi_s_awburst      (uart_awburst           ),
    .axi_s_awlock       (uart_awlock            ),
    .axi_s_awcache      (uart_awcache           ),
    .axi_s_awprot       (uart_awprot            ),
    .axi_s_awvalid      (uart_awvalid           ),
    .axi_s_awready      (uart_awready           ),
    .axi_s_wid          (uart_awid              ),
    .axi_s_wdata        (uart_wdata             ),
    .axi_s_wstrb        (uart_wstrb             ),
    .axi_s_wlast        (uart_wlast             ),
    .axi_s_wvalid       (uart_wvalid            ),
    .axi_s_wready       (uart_wready            ),
    .axi_s_bid          (uart_bid               ),
    .axi_s_bresp        (uart_bresp             ),
    .axi_s_bvalid       (uart_bvalid            ),
    .axi_s_bready       (uart_bready            ),
    .axi_s_arid         (uart_arid              ),
    .axi_s_araddr       (uart_araddr            ),
    .axi_s_arlen        (uart_arlen             ),
    .axi_s_arsize       (uart_arsize            ),
    .axi_s_arburst      (uart_arburst           ),
    .axi_s_arlock       (uart_arlock            ),
    .axi_s_arcache      (uart_arcache           ),
    .axi_s_arprot       (uart_arprot            ),
    .axi_s_arvalid      (uart_arvalid           ),
    .axi_s_arready      (uart_arready           ),
    .axi_s_rid          (uart_rid               ),
    .axi_s_rdata        (uart_rdata             ),
    .axi_s_rresp        (uart_rresp             ),
    .axi_s_rlast        (uart_rlast             ),
    .axi_s_rvalid       (uart_rvalid            ),
    .axi_s_rready       (uart_rready            ),

    .apb_rw_dma         (1'b0                   ),
    .apb_psel_dma       (1'b0                   ),
    .apb_enab_dma       (1'b0                   ),
    .apb_addr_dma       (20'b0                  ),
    .apb_valid_dma      (1'b0                   ),
    .apb_wdata_dma      (32'b0                  ),
    .apb_rdata_dma      (                       ),
    .apb_ready_dma      (                       ), 
    .dma_grant          (                       ),

    .dma_req_o          (                       ),
    .dma_ack_i          (1'b0                   ),

    //UART0
    .uart0_txd_i        (uart0_txd_i            ),
    .uart0_txd_o        (uart0_txd_o            ),
    .uart0_txd_oe       (uart0_txd_oe           ),
    .uart0_rxd_i        (uart0_rxd_i            ),
    .uart0_rxd_o        (uart0_rxd_o            ),
    .uart0_rxd_oe       (uart0_rxd_oe           ),
    .uart0_rts_o        (uart0_rts_o            ),
    .uart0_dtr_o        (uart0_dtr_o            ),
    .uart0_cts_i        (uart0_cts_i            ),
    .uart0_dsr_i        (uart0_dsr_i            ),
    .uart0_dcd_i        (uart0_dcd_i            ),
    .uart0_ri_i         (uart0_ri_i             ),
    .uart0_int          (uart0_int              )
);

endmodule

