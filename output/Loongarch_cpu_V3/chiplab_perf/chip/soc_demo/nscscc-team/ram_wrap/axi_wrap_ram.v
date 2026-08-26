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

module axi_wrap_ram(
  input         aclk,
  input         aresetn,
  //ar
  input  [3 :0] axi_arid   ,
  input  [31:0] axi_araddr ,
  input  [7 :0] axi_arlen  ,
  input  [2 :0] axi_arsize ,
  input  [1 :0] axi_arburst,
  input  [1 :0] axi_arlock ,
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
  input  [1 :0] axi_awlock ,
  input  [3 :0] axi_awcache,
  input  [2 :0] axi_awprot ,
  input         axi_awvalid,
  output        axi_awready,
  //w
  input  [3 :0] axi_wid    ,
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
  input  [4 :0] ram_random_mask
);

//延迟倍数
localparam R_Delay_Multiple   = 85;  //R通道 延迟170周期
localparam B_Delay_Multiple   = 30;  //B通道 延迟60周期

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
//R通道延迟展宽 R_Delay_Multiple 倍

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
                    r_countcmp <= (r_count[0]+1'b1) * R_Delay_Multiple;
            end
            4'b0010: begin
                if(axi_rvalid_s_unmasked)
                    r_countcmp <= (r_count[1]+1'b1) * R_Delay_Multiple;
            end
            4'b0100: begin
                if(axi_rvalid_s_unmasked)
                    r_countcmp <= (r_count[2]+1'b1) * R_Delay_Multiple;
            end
            4'b1000: begin
                if(axi_rvalid_s_unmasked)
                    r_countcmp <= (r_count[3]+1'b1) * R_Delay_Multiple;
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
//B通道延迟展宽 B_Delay_Multiple 倍

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
                    b_countcmp <= (b_count[0]+1'b1) * B_Delay_Multiple;
            end
            4'b0010: begin
                if(axi_bvalid_s_unmasked)
                    b_countcmp <= (b_count[1]+1'b1) * B_Delay_Multiple;
            end
            4'b0100: begin
                if(axi_bvalid_s_unmasked)
                    b_countcmp <= (b_count[2]+1'b1) * B_Delay_Multiple;
            end
            4'b1000: begin
                if(axi_bvalid_s_unmasked)
                    b_countcmp <= (b_count[3]+1'b1) * B_Delay_Multiple;
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
wire [1 :0] ram_arlock ;
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
wire [1 :0] ram_awlock ;
wire [3 :0] ram_awcache;
wire [2 :0] ram_awprot ;
wire        ram_awvalid;
wire        ram_awready;
//w
wire [3 :0] ram_wid    ;
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

wire  [31:0]    fpga_sram_raddr;
wire  [31:0]    fpga_sram_rdata;
wire            fpga_sram_ren;
wire  [31:0]    fpga_sram_waddr;
wire  [31:0]    fpga_sram_wdata;
wire  [3:0]     fpga_sram_wen;

soc_axi_sram_bridge #(
    .BUS_WIDTH  ( 32 ),
    .DATA_WIDTH ( 32 ),
    .CPU_WIDTH  ( 32 ))
 u_axi_inst_sram_bridge (
    .aclk                    ( aclk         ),
    .aresetn                 ( aresetn      ),

    .m_araddr                ( ram_araddr   ),
    .m_arburst               ( ram_arburst  ),
    .m_arcache               ( 4'h0         ),
    .m_arid                  ( ram_arid     ),
    .m_arlen                 ( ram_arlen    ),
    .m_arlock                ( 2'h0         ),
    .m_arprot                ( 3'h0         ),
    .m_arsize                ( ram_arsize   ),
    .m_arvalid               ( ram_arvalid  ),
    .m_arready               ( ram_arready  ),

    .m_rready                ( ram_rready   ),
    .m_rdata                 ( ram_rdata    ),
    .m_rid                   ( ram_rid      ),
    .m_rlast                 ( ram_rlast    ),
    .m_rresp                 ( ram_rresp    ),
    .m_rvalid                ( ram_rvalid   ),

    .m_awaddr                ( ram_awaddr   ),
    .m_awburst               ( ram_awburst  ),
    .m_awcache               ( 4'h0         ),
    .m_awid                  ( ram_awid     ),
    .m_awlen                 ( ram_awlen    ),
    .m_awlock                ( 2'h0         ),
    .m_awprot                ( 3'h0         ),
    .m_awsize                ( ram_awsize   ),
    .m_awvalid               ( ram_awvalid  ),
    .m_awready               ( ram_awready  ),

    .m_wdata                 ( ram_wdata    ),
    .m_wid                   ( ram_wid      ),
    .m_wlast                 ( ram_wlast    ),
    .m_wstrb                 ( ram_wstrb    ),
    .m_wvalid                ( ram_wvalid   ),
    .m_wready                ( ram_wready   ),

    .m_bready                ( ram_bready   ),
    .m_bid                   ( ram_bid      ),
    .m_bresp                 ( ram_bresp    ),
    .m_bvalid                ( ram_bvalid   ),

    .ram_raddr               ( fpga_sram_raddr  ),
    .ram_ren                 ( fpga_sram_ren    ),
    .ram_waddr               ( fpga_sram_waddr  ),
    .ram_wdata               ( fpga_sram_wdata  ),
    .ram_wen                 ( fpga_sram_wen    ),
    .ram_rdata               ( fpga_sram_rdata  )
);

//1MByte SRAM
fpga_sram_dp #(
.AW ( 18 )
)u_fpga_sram (
    .CLK                     ( aclk              ),
    .ram_raddr               ( fpga_sram_raddr[19:2]   ),
    .ram_ren                 ( fpga_sram_ren     ),
    .ram_rdata               ( fpga_sram_rdata   ),
    .ram_waddr               ( fpga_sram_waddr[19:2]   ),
    .ram_wdata               ( fpga_sram_wdata   ),
    .ram_wen                 ( fpga_sram_wen     )
    
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
assign ram_wid    = axi_wid    ;
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
