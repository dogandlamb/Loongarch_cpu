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
`include "soc_config.vh"

module axi_wrap_ddr(
    input         aclk,
    input         aresetn,
    input         xtal_clk,
    input         button_resetn,
    input         ddr_clk_ref,
    output reg    ddr_aresetn,

    //ar
    input  [3 :0] axi_arid   ,
    input  [31:0] axi_araddr ,
    input  [7 :0] axi_arlen  ,
    input  [2 :0] axi_arsize ,
    input  [1 :0] axi_arburst,
    input         axi_arlock ,
    input  [3 :0] axi_arcache,
    input  [2 :0] axi_arprot ,
    input         axi_arvalid,
    output        axi_arready,
    //r
    output [3 :0] axi_rid    ,
    output [31:0] axi_rdata  ,
    output [1 :0] axi_rresp  ,
    output        axi_rlast  ,
    output        axi_rvalid ,
    input         axi_rready ,
    //aw
    input  [3 :0] axi_awid   ,
    input  [31:0] axi_awaddr ,
    input  [7 :0] axi_awlen  ,
    input  [2 :0] axi_awsize ,
    input  [1 :0] axi_awburst,
    input         axi_awlock ,
    input  [3 :0] axi_awcache,
    input  [2 :0] axi_awprot ,
    input         axi_awvalid,
    output        axi_awready,
    //w
    input  [31:0] axi_wdata  ,
    input  [3 :0] axi_wstrb  ,
    input         axi_wlast  ,
    input         axi_wvalid ,
    output        axi_wready ,
    //b
    output [3 :0] axi_bid    ,
    output [1 :0] axi_bresp  ,
    output        axi_bvalid ,
    input         axi_bready ,

    //from confreg
    input  [4 :0] ram_random_mask,

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
    output        ddr3_ck_n
);

//延迟倍数
localparam Delay_Multiple     = 5;

wire axi_arvalid_m_masked;
wire axi_rready_m_masked;
wire axi_awvalid_m_masked;
wire axi_wvalid_m_masked;
wire axi_bready_m_masked;

wire axi_arready_s_unmasked;
wire axi_rvalid_s_unmasked;
wire axi_awready_s_unmasked;
wire axi_wready_s_unmasked;
wire axi_bvalid_s_unmasked;

wire ar_and;
wire  r_and;
wire aw_and;
wire  w_and;
wire  b_and;
reg ar_nomask;
reg aw_nomask;
reg w_nomask;
reg [4:0] pf_r2r;
reg [1:0] pf_b2b;
wire pf_r2r_nomask= pf_r2r==5'd0;
wire pf_b2b_nomask= pf_b2b==2'd0;
reg pf_r_and;
reg pf_b_and;

//mask
`ifdef RUN_PERF_TEST
    assign ar_and = 1'b1;
    assign aw_and = 1'b1;
    assign  w_and = 1'b1;
    `ifdef RUN_PERF_NO_DELAY
        assign  r_and = 1'b1;
        assign  b_and = 1'b1;
    `else
        assign  r_and = pf_r_and;
        assign  b_and = pf_b_and;
    `endif
`else
    assign ar_and = ram_random_mask[4] | ar_nomask;
    assign  r_and = ram_random_mask[3]            ;
    assign aw_and = ram_random_mask[2] | aw_nomask;
    assign  w_and = ram_random_mask[1] |  w_nomask;
    assign  b_and = ram_random_mask[0]            ;
`endif
always @(posedge aclk)
begin
    //for func test, random mask
    ar_nomask <= !aresetn             ? 1'b0 :
                 axi_arvalid_m_masked&&axi_arready ? 1'b0 :
                 axi_arvalid_m_masked ? 1'b1 : ar_nomask;

    aw_nomask <= !aresetn             ? 1'b0 :
                 axi_awvalid_m_masked&&axi_awready ? 1'b0 :
                 axi_awvalid_m_masked ? 1'b1 : aw_nomask;

    w_nomask  <= !aresetn             ? 1'b0 :
                 axi_wvalid_m_masked&&axi_wready ? 1'b0 :
                 axi_wvalid_m_masked  ? 1'b1 : w_nomask;
    //for perf test
    pf_r2r    <= !aresetn             ? 5'd0 : 
                 axi_arvalid_m_masked&&axi_arready ? 5'd25 :
                 !pf_r2r_nomask       ? pf_r2r-1'b1 : pf_r2r;
    pf_b2b    <= !aresetn             ? 2'd0 : 
                 axi_awvalid_m_masked&&axi_awready ? 2'd3 :
                 !pf_b2b_nomask       ? pf_b2b-1'b1 : pf_b2b;
end

/*********************************************************************************************/
//R通道延迟展宽 Delay_Multiple 倍

localparam S_R_IDLE           = 3'h0; //空闲
localparam S_WAIT_R           = 3'h1; //等待自己的R从slave返回
localparam S_WAIT_LAST_R      = 3'h2; //等待上一个AR的R给到master
localparam S_DELAY_R          = 3'h3; //等到计数器到达目标值再将R发给master


reg [2:0] rstate [3:0];
reg [2:0] next_rstate [3:0];

wire [3:0] state_ridle;
wire [3:0] state_wait_r;
wire [3:0] state_wait_lastr;
wire [3:0] state_delay_r;

//find state first one
wire [3:0] state_ridle_one;
wire [3:0] state_wait_lastr_one;

first_one_4_4 u_sel_ridle (.in(state_ridle), .out(state_ridle_one));
first_one_4_4 u_sel_wait_lastr (.in(state_wait_lastr), .out(state_wait_lastr_one));

reg [31:0] r_countcmp;
reg [31:0] r_count [3:0];

//解决ar和rlast同时握手引发的状态机卡死
reg r_with_no_wait;
always @(posedge aclk or negedge aresetn) begin
    if(~aresetn)
        r_with_no_wait <= 1'b0;
    else begin
        r_with_no_wait <= (!(|state_wait_lastr)) & axi_rvalid & axi_rready & axi_rlast;
    end
end

genvar i;
generate 
for(i=0; i<4;i=i+1) begin
    assign state_ridle[i]           = (rstate[i] == S_R_IDLE        );
    assign state_wait_r[i]          = (rstate[i] == S_WAIT_R        );
    assign state_wait_lastr[i]      = (rstate[i] == S_WAIT_LAST_R   );
    assign state_delay_r[i]         = (rstate[i] == S_DELAY_R       );

    always @(posedge aclk or negedge aresetn) begin
        if(~aresetn)
            rstate[i] <= S_R_IDLE;
        else begin
            rstate[i] <= next_rstate[i];
        end
    end

    //状态跳转控制
    always @(*) begin
        case(rstate[i])
            S_R_IDLE : begin
                if(state_ridle_one[i] & axi_arvalid_m_masked & axi_arready)begin
                    if(&state_ridle)
                        next_rstate[i] = S_WAIT_R;
                    else
                        next_rstate[i] = S_WAIT_LAST_R;
                end
                else
                    next_rstate[i] = S_R_IDLE;
            end
            S_WAIT_R : begin
                if(axi_rvalid_s_unmasked)
                    next_rstate[i] = S_DELAY_R;
                else
                    next_rstate[i] = S_WAIT_R;
            end
            S_WAIT_LAST_R : begin
                if(state_wait_lastr_one[i] & ((axi_rvalid & axi_rready & axi_rlast) | r_with_no_wait))
                    next_rstate[i] = S_DELAY_R;
                else
                    next_rstate[i] = S_WAIT_LAST_R;
            end
            S_DELAY_R : begin
                if((r_count[i] >= r_countcmp) & axi_rvalid & axi_rready & axi_rlast)
                    next_rstate[i] = S_R_IDLE;
                else
                    next_rstate[i] = S_DELAY_R;
            end
            default     :begin
                next_rstate[i] = S_R_IDLE;
            end
        endcase
    end

    always @(posedge aclk or negedge aresetn) begin
        if(~aresetn)begin
            r_count[i] <= 32'h0;
        end
        else begin
            if(state_wait_r[i] | state_delay_r[i])
                r_count[i] <= r_count[i] + 1'b1;
            else
                r_count[i] <= 32'h0;
        end
    end

end
endgenerate

always @(posedge aclk or negedge aresetn) begin
    if(~aresetn) begin
        r_countcmp <= 32'h0;
    end
    else begin
        case(state_wait_r)
            4'b0001: begin
                if(axi_rvalid_s_unmasked)
                    r_countcmp <= (r_count[0]+1'b1) * Delay_Multiple;
            end
            4'b0010: begin
                if(axi_rvalid_s_unmasked)
                    r_countcmp <= (r_count[1]+1'b1) * Delay_Multiple;
            end
            4'b0100: begin
                if(axi_rvalid_s_unmasked)
                    r_countcmp <= (r_count[2]+1'b1) * Delay_Multiple;
            end
            4'b1000: begin
                if(axi_rvalid_s_unmasked)
                    r_countcmp <= (r_count[3]+1'b1) * Delay_Multiple;
            end
            default: begin
                    r_countcmp <= r_countcmp;
            end
        endcase
    end
end

always @(posedge aclk or negedge aresetn) begin
    if(~aresetn) begin
        pf_r_and <= 1'b0;
    end
    else begin
        case (state_delay_r)
            4'b0001: begin
                if((r_count[0] >= r_countcmp) & (~(axi_rvalid & axi_rready & axi_rlast)))
                    pf_r_and <= 1'b1;
                else
                    pf_r_and <= 1'b0;
            end
            4'b0010: begin
                if((r_count[1] >= r_countcmp) & (~(axi_rvalid & axi_rready & axi_rlast)))
                    pf_r_and <= 1'b1;
                else
                    pf_r_and <= 1'b0;
            end
            4'b0100: begin
                if((r_count[2] >= r_countcmp) & (~(axi_rvalid & axi_rready & axi_rlast)))
                    pf_r_and <= 1'b1;
                else
                    pf_r_and <= 1'b0;
            end
            4'b1000: begin
                if((r_count[3] >= r_countcmp) & (~(axi_rvalid & axi_rready & axi_rlast)))
                    pf_r_and <= 1'b1;
                else
                    pf_r_and <= 1'b0;
            end
            default: begin
                    pf_r_and <= 1'b0;
            end
        endcase
    end
end

/*********************************************************************************************/

/*********************************************************************************************/
//B通道延迟展宽 Delay_Multiple 倍

localparam S_B_IDLE           = 3'h0; //空闲
localparam S_WAIT_B           = 3'h1; //等待自己的B从slave返回
localparam S_WAIT_LAST_B      = 3'h2; //等待上一个W的B给到master
localparam S_DELAY_B          = 3'h3; //等到计数器到达目标值再将B发给master

reg [2:0] bstate [3:0];
reg [2:0] next_bstate [3:0];

wire [3:0] state_bidle;
wire [3:0] state_wait_b;
wire [3:0] state_wait_lastb;
wire [3:0] state_delay_b;

//find state first one
wire [3:0] state_bidle_one;
wire [3:0] state_wait_lastb_one;

first_one_4_4 u_sel_bidle (.in(state_bidle), .out(state_bidle_one));
first_one_4_4 u_sel_wait_lastb (.in(state_wait_lastb), .out(state_wait_lastb_one));

reg [31:0] b_countcmp;
reg [31:0] b_count [3:0];

//解决w和b同时握手引发的状态机卡死
reg b_with_no_wait;
always @(posedge aclk or negedge aresetn) begin
    if(~aresetn)
        b_with_no_wait <= 1'b0;
    else begin
        b_with_no_wait <= (!(|state_wait_lastb)) & axi_bvalid & axi_bready;
    end
end

genvar j;
generate 
for(j=0; j<4;j=j+1) begin
    assign state_bidle[j]           = (bstate[j] == S_B_IDLE        );
    assign state_wait_b[j]          = (bstate[j] == S_WAIT_B        );
    assign state_wait_lastb[j]      = (bstate[j] == S_WAIT_LAST_B   );
    assign state_delay_b[j]         = (bstate[j] == S_DELAY_B       );

    always @(posedge aclk or negedge aresetn) begin
        if(~aresetn)
            bstate[j] <= S_B_IDLE;
        else begin
            bstate[j] <= next_bstate[j];
        end
    end

    //状态跳转控制
    always @(*) begin
        case(bstate[j])
            S_B_IDLE : begin
                if(state_bidle_one[j] & axi_wvalid_m_masked & axi_wready & axi_wlast)begin
                    if(&state_bidle)
                        next_bstate[j] = S_WAIT_B;
                    else
                        next_bstate[j] = S_WAIT_LAST_B;
                end
                else
                    next_bstate[j] = S_B_IDLE;
            end
            S_WAIT_B : begin
                if(axi_bvalid_s_unmasked)
                    next_bstate[j] = S_DELAY_B;
                else
                    next_bstate[j] = S_WAIT_B;
            end
            S_WAIT_LAST_B : begin
                if(state_wait_lastb_one[j] & ((axi_bvalid & axi_bready) | b_with_no_wait))
                    next_bstate[j] = S_DELAY_B;
                else
                    next_bstate[j] = S_WAIT_LAST_B;
            end
            S_DELAY_B : begin
                if((b_count[j] >= b_countcmp) & axi_bvalid & axi_bready)
                    next_bstate[j] = S_B_IDLE;
                else
                    next_bstate[j] = S_DELAY_B;
            end
            default     :begin
                next_bstate[j] = S_B_IDLE;
            end
        endcase
    end

    always @(posedge aclk or negedge aresetn) begin
        if(~aresetn)begin
            b_count[j] <= 32'h0;
        end
        else begin
            if(state_wait_b[j] | state_delay_b[j])
                b_count[j] <= b_count[j] + 1'b1;
            else
                b_count[j] <= 32'h0;
        end
    end

end
endgenerate

always @(posedge aclk or negedge aresetn) begin
    if(~aresetn) begin
        b_countcmp <= 32'h0;
    end
    else begin
        case(state_wait_b)
            4'b0001: begin
                if(axi_bvalid_s_unmasked)
                    b_countcmp <= (b_count[0]+1'b1) * Delay_Multiple;
            end
            4'b0010: begin
                if(axi_bvalid_s_unmasked)
                    b_countcmp <= (b_count[1]+1'b1) * Delay_Multiple;
            end
            4'b0100: begin
                if(axi_bvalid_s_unmasked)
                    b_countcmp <= (b_count[2]+1'b1) * Delay_Multiple;
            end
            4'b1000: begin
                if(axi_bvalid_s_unmasked)
                    b_countcmp <= (b_count[3]+1'b1) * Delay_Multiple;
            end
            default: begin
                    b_countcmp <= b_countcmp;
            end
        endcase
    end
end

always @(posedge aclk or negedge aresetn) begin
    if(~aresetn) begin
        pf_b_and <= 1'b0;
    end
    else begin
        case (state_delay_b)
            4'b0001: begin
                if((b_count[0] >= b_countcmp) & (~(axi_bvalid & axi_bready)))
                    pf_b_and <= 1'b1;
                else
                    pf_b_and <= 1'b0;
            end
            4'b0010: begin
                if((b_count[1] >= b_countcmp) & (~(axi_bvalid & axi_bready)))
                    pf_b_and <= 1'b1;
                else
                    pf_b_and <= 1'b0;
            end
            4'b0100: begin
                if((b_count[2] >= b_countcmp) & (~(axi_bvalid & axi_bready)))
                    pf_b_and <= 1'b1;
                else
                    pf_b_and <= 1'b0;
            end
            4'b1000: begin
                if((b_count[3] >= b_countcmp) & (~(axi_bvalid & axi_bready)))
                    pf_b_and <= 1'b1;
                else
                    pf_b_and <= 1'b0;
            end
            default: begin
                    pf_b_and <= 1'b0;
            end
        endcase
    end
end

/*********************************************************************************************/


//-----{master -> slave}-----
assign axi_arvalid_m_masked = axi_arvalid & ar_and;
assign axi_rready_m_masked  = axi_rready  &  r_and;
assign axi_awvalid_m_masked = axi_awvalid & aw_and;
assign axi_wvalid_m_masked  = axi_wvalid  &  w_and;
assign axi_bready_m_masked  = axi_bready  &  b_and;

//-----{slave -> master}-----
assign axi_arready = axi_arready_s_unmasked & ar_and;
assign axi_rvalid  = axi_rvalid_s_unmasked  &  r_and;
assign axi_awready = axi_awready_s_unmasked & aw_and;
assign axi_wready  = axi_wready_s_unmasked  &  w_and;
assign axi_bvalid  = axi_bvalid_s_unmasked  &  b_and;
     
//ram axi
//ar
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
//r
wire [3 :0] ram_rid    ;
wire [31:0] ram_rdata  ;
wire [1 :0] ram_rresp  ;
wire        ram_rlast  ;
wire        ram_rvalid ;
wire        ram_rready ;
//aw
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
//w
wire [31:0] ram_wdata  ;
wire [3 :0] ram_wstrb  ;
wire        ram_wlast  ;
wire        ram_wvalid ;
wire        ram_wready ;
//b
wire [3 :0] ram_bid    ;
wire [1 :0] ram_bresp  ;
wire        ram_bvalid ;
wire        ram_bready ;

//ddr axi
//ar
wire [3 :0] mig_arid   ;
wire [31:0] mig_araddr ;
wire [7 :0] mig_arlen  ;
wire [2 :0] mig_arsize ;
wire [1 :0] mig_arburst;
wire        mig_arlock ;
wire [3 :0] mig_arcache;
wire [2 :0] mig_arprot ;
wire        mig_arvalid;
wire        mig_arready;
//r
wire [3 :0] mig_rid    ;
wire [31:0] mig_rdata  ;
wire [1 :0] mig_rresp  ;
wire        mig_rlast  ;
wire        mig_rvalid ;
wire        mig_rready ;
//aw
wire [3 :0] mig_awid   ;
wire [31:0] mig_awaddr ;
wire [7 :0] mig_awlen  ;
wire [2 :0] mig_awsize ;
wire [1 :0] mig_awburst;
wire        mig_awlock ;
wire [3 :0] mig_awcache;
wire [2 :0] mig_awprot ;
wire        mig_awvalid;
wire        mig_awready;
//w
wire [31:0] mig_wdata  ;
wire [3 :0] mig_wstrb  ;
wire        mig_wlast  ;
wire        mig_wvalid ;
wire        mig_wready ;
//b
wire [3 :0] mig_bid    ;
wire [1 :0] mig_bresp  ;
wire        mig_bvalid ;
wire        mig_bready ;

wire ui_clk;
wire ui_clk_sync_rst;
wire init_calib_complete;

Axi_CDC  u_Axi_CDC (
    .axiInClk                ( aclk                 ),
    .axiInRst                ( aresetn              ),
    .axiOutClk               ( ui_clk               ),
    .axiOutRst               ( ddr_aresetn          ),

    .axiIn_awvalid           ( ram_awvalid         ),
    .axiIn_awaddr            ( ram_awaddr          ),
    .axiIn_awid              ( ram_awid            ),
    .axiIn_awlen             ( ram_awlen           ),
    .axiIn_awsize            ( ram_awsize          ),
    .axiIn_awburst           ( ram_awburst         ),
    .axiIn_awlock            ( ram_awlock          ),
    .axiIn_awcache           ( ram_awcache         ),
    .axiIn_awprot            ( ram_awprot          ),
    .axiIn_wvalid            ( ram_wvalid          ),
    .axiIn_wdata             ( ram_wdata           ),
    .axiIn_wstrb             ( ram_wstrb           ),
    .axiIn_wlast             ( ram_wlast           ),
    .axiIn_bready            ( ram_bready          ),
    .axiIn_arvalid           ( ram_arvalid         ),
    .axiIn_araddr            ( ram_araddr          ),
    .axiIn_arid              ( ram_arid            ),
    .axiIn_arlen             ( ram_arlen           ),
    .axiIn_arsize            ( ram_arsize          ),
    .axiIn_arburst           ( ram_arburst         ),
    .axiIn_arlock            ( ram_arlock          ),
    .axiIn_arcache           ( ram_arcache         ),
    .axiIn_arprot            ( ram_arprot          ),
    .axiIn_rready            ( ram_rready          ),
    .axiOut_awready          ( mig_awready         ),
    .axiOut_wready           ( mig_wready          ),
    .axiOut_bvalid           ( mig_bvalid          ),
    .axiOut_bid              ( mig_bid             ),
    .axiOut_bresp            ( mig_bresp           ),
    .axiOut_arready          ( mig_arready         ),
    .axiOut_rvalid           ( mig_rvalid          ),
    .axiOut_rdata            ( mig_rdata           ),
    .axiOut_rid              ( mig_rid             ),
    .axiOut_rresp            ( mig_rresp           ),
    .axiOut_rlast            ( mig_rlast           ),

    .axiIn_awready           ( ram_awready         ),
    .axiIn_wready            ( ram_wready          ),
    .axiIn_bvalid            ( ram_bvalid          ),
    .axiIn_bid               ( ram_bid             ),
    .axiIn_bresp             ( ram_bresp           ),
    .axiIn_arready           ( ram_arready         ),
    .axiIn_rvalid            ( ram_rvalid          ),
    .axiIn_rdata             ( ram_rdata           ),
    .axiIn_rid               ( ram_rid             ),
    .axiIn_rresp             ( ram_rresp           ),
    .axiIn_rlast             ( ram_rlast           ),
    .axiOut_awvalid          ( mig_awvalid         ),
    .axiOut_awaddr           ( mig_awaddr          ),
    .axiOut_awid             ( mig_awid            ),
    .axiOut_awlen            ( mig_awlen           ),
    .axiOut_awsize           ( mig_awsize          ),
    .axiOut_awburst          ( mig_awburst         ),
    .axiOut_awlock           ( mig_awlock          ),
    .axiOut_awcache          ( mig_awcache         ),
    .axiOut_awprot           ( mig_awprot          ),
    .axiOut_wvalid           ( mig_wvalid          ),
    .axiOut_wdata            ( mig_wdata           ),
    .axiOut_wstrb            ( mig_wstrb           ),
    .axiOut_wlast            ( mig_wlast           ),
    .axiOut_bready           ( mig_bready          ),
    .axiOut_arvalid          ( mig_arvalid         ),
    .axiOut_araddr           ( mig_araddr          ),
    .axiOut_arid             ( mig_arid            ),
    .axiOut_arlen            ( mig_arlen           ),
    .axiOut_arsize           ( mig_arsize          ),
    .axiOut_arburst          ( mig_arburst         ),
    .axiOut_arlock           ( mig_arlock          ),
    .axiOut_arcache          ( mig_arcache         ),
    .axiOut_arprot           ( mig_arprot          ),
    .axiOut_rready           ( mig_rready          )
);

always @ (posedge ui_clk) begin
    ddr_aresetn <= ~ui_clk_sync_rst && init_calib_complete;
end

//ddr3 controller
mig_axi_32 mig_axi (
    // Inouts
    .ddr3_dq             (ddr3_dq         ),  
    .ddr3_dqs_p          (ddr3_dqs_p      ),
    .ddr3_dqs_n          (ddr3_dqs_n      ),
    // Outputs
    .ddr3_addr           (ddr3_addr       ),  
    .ddr3_ba             (ddr3_ba         ),
    .ddr3_ras_n          (ddr3_ras_n      ),                        
    .ddr3_cas_n          (ddr3_cas_n      ),                        
    .ddr3_we_n           (ddr3_we_n       ),                          
    .ddr3_reset_n        (ddr3_reset_n    ),
    .ddr3_ck_p           (ddr3_ck_p       ),                          
    .ddr3_ck_n           (ddr3_ck_n       ),       
    .ddr3_cke            (ddr3_cke        ),                          
    .ddr3_dm             (ddr3_dm         ),
    .ddr3_odt            (ddr3_odt        ),
    
	.ui_clk              (ui_clk          ),
    .ui_clk_sync_rst     (ui_clk_sync_rst ),
 
    .sys_clk_i           (xtal_clk        ),
    .sys_rst             (button_resetn   ),                        
    .init_calib_complete (init_calib_complete),
    .clk_ref_i           (ddr_clk_ref     ),
    .mmcm_locked         (                ),
	
	.app_sr_active       (                ),
    .app_ref_ack         (                ),
    .app_zq_ack          (                ),
    .app_sr_req          (1'b0            ),
    .app_ref_req         (1'b0            ),
    .app_zq_req          (1'b0            ),
    
    .aresetn             (ddr_aresetn     ),
    .s_axi_awid          (mig_awid        ),
    .s_axi_awaddr        (mig_awaddr[26:0]),
    .s_axi_awlen         (mig_awlen       ),
    .s_axi_awsize        (mig_awsize      ),
    .s_axi_awburst       (mig_awburst     ),
    .s_axi_awlock        (mig_awlock      ),
    .s_axi_awcache       (mig_awcache     ),
    .s_axi_awprot        (mig_awprot      ),
    .s_axi_awqos         (4'b0            ),
    .s_axi_awvalid       (mig_awvalid     ),
    .s_axi_awready       (mig_awready     ),
    .s_axi_wdata         (mig_wdata       ),
    .s_axi_wstrb         (mig_wstrb       ),
    .s_axi_wlast         (mig_wlast       ),
    .s_axi_wvalid        (mig_wvalid      ),
    .s_axi_wready        (mig_wready      ),
    .s_axi_bid           (mig_bid         ),
    .s_axi_bresp         (mig_bresp       ),
    .s_axi_bvalid        (mig_bvalid      ),
    .s_axi_bready        (mig_bready      ),
    .s_axi_arid          (mig_arid        ),
    .s_axi_araddr        (mig_araddr[26:0]),
    .s_axi_arlen         (mig_arlen       ),
    .s_axi_arsize        (mig_arsize      ),
    .s_axi_arburst       (mig_arburst     ),
    .s_axi_arlock        (mig_arlock      ),
    .s_axi_arcache       (mig_arcache     ),
    .s_axi_arprot        (mig_arprot      ),
    .s_axi_arqos         (4'b0            ),
    .s_axi_arvalid       (mig_arvalid     ),
    .s_axi_arready       (mig_arready     ),
    .s_axi_rid           (mig_rid         ),
    .s_axi_rdata         (mig_rdata       ),
    .s_axi_rresp         (mig_rresp       ),
    .s_axi_rlast         (mig_rlast       ),
    .s_axi_rvalid        (mig_rvalid      ),
    .s_axi_rready        (mig_rready      )
);

//ar
assign ram_arid    = axi_arid   ;
`ifdef RUN_PERF_TEST
assign ram_araddr  = axi_araddr ;
`else
assign ram_araddr  = (axi_araddr[31:28] == 4'h0 ||
                      axi_araddr[31:28] == 4'h1 ||
                      axi_araddr[31:28] == 4'h7) ? axi_araddr :
                      {12'b0, 4'hf, axi_araddr[31:28], axi_araddr[11:0]};
`endif
assign ram_arlen   = axi_arlen  ;
assign ram_arsize  = axi_arsize ;
assign ram_arburst = axi_arburst;
assign ram_arlock  = axi_arlock ;
assign ram_arcache = axi_arcache;
assign ram_arprot  = axi_arprot ;
assign ram_arvalid = axi_arvalid_m_masked;
assign axi_arready_s_unmasked = ram_arready;
//r
assign axi_rid    = axi_rvalid ? ram_rid   :  4'd0 ;
assign axi_rdata  = axi_rvalid ? ram_rdata : 32'd0 ;
assign axi_rresp  = axi_rvalid ? ram_rresp :  2'd0 ;
assign axi_rlast  = axi_rvalid ? ram_rlast :  1'd0 ;
assign axi_rvalid_s_unmasked = ram_rvalid;
assign ram_rready = axi_rready_m_masked;
//aw
assign ram_awid    = axi_awid   ;
`ifdef RUN_PERF_TEST
assign ram_awaddr  = axi_awaddr ;
`else
assign ram_awaddr  = (axi_awaddr[31:28] == 4'h0 ||
                      axi_awaddr[31:28] == 4'h1 ||
                      axi_awaddr[31:28] == 4'h7) ? axi_awaddr :
                      {12'b0, 4'hf, axi_awaddr[31:28], axi_awaddr[11:0]};
`endif
assign ram_awlen   = axi_awlen  ;
assign ram_awsize  = axi_awsize ;
assign ram_awburst = axi_awburst;
assign ram_awlock  = axi_awlock ;
assign ram_awcache = axi_awcache;
assign ram_awprot  = axi_awprot ;
assign ram_awvalid = axi_awvalid_m_masked;
assign axi_awready_s_unmasked = ram_awready;
//w
assign ram_wdata  = axi_wdata  ;
assign ram_wstrb  = axi_wstrb  ;
assign ram_wlast  = axi_wlast  ;
assign ram_wvalid = axi_wvalid_m_masked;
assign axi_wready_s_unmasked = ram_wready ;
//b
assign axi_bid    = axi_bvalid ? ram_bid   : 4'd0 ;
assign axi_bresp  = axi_bvalid ? ram_bresp : 2'd0 ;
assign axi_bvalid_s_unmasked = ram_bvalid ;
assign ram_bready = axi_bready_m_masked;
endmodule
