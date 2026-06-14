`include "mycpu.h"

// ============================================================
// axi_line_bridge 模块（cache 行请求 <-> 32bit AXI burst 转换桥）
// ------------------------------------------------------------
// 参考实现说明（按 32B 行改造，端口不变）：
// - 行读：ARLEN=7（8 拍 32bit INCR），凑满 16B 即向上回一拍 128b
//   （第 4 拍 ret_last=0、第 8 拍 ret_last=1，共 2 拍）；
// - 行写：上游 2 拍 128b 进（beat0 在 WR_IDLE 接受拍 ack，beat1 次拍直推），
//   缓冲整行后 AWLEN=7 突发写出，B 响应后写 FSM 才空闲；
// - 非行（uncached）：单拍传输，arsize/awsize 按真实宽度；写 rdy=B 完成；
// - 顺序保证：写 FSM 忙时读 FSM 不接受新请求（防"读越过在途写"）；
// - ic/dc 读通道 round-robin（当前顶层 ic 通道闲置接 0）。
// ============================================================
module axi_line_bridge (
    input  wire        clk,
    input  wire        resetn,

    input  wire        ic_rd_req,
    input  wire [2:0]  ic_rd_type,
    input  wire [31:0] ic_rd_addr,
    output wire        ic_rd_rdy,
    output wire        ic_ret_valid,
    output wire        ic_ret_last,
    output wire [127:0] ic_ret_data,

    input  wire        dc_rd_req,
    input  wire [2:0]  dc_rd_type,
    input  wire [31:0] dc_rd_addr,
    output wire        dc_rd_rdy,
    output wire        dc_ret_valid,
    output wire        dc_ret_last,
    output wire [127:0] dc_ret_data,

    input  wire        dc_wr_req,
    input  wire [2:0]  dc_wr_type,
    input  wire [31:0] dc_wr_addr,
    input  wire [15:0] dc_wr_strb,
    input  wire [127:0] dc_wr_data,
    output wire        dc_wr_rdy,

    output wire        axi_awvalid,
    output wire [31:0] axi_awaddr,
    output wire [2:0]  axi_awburst,
    output wire [3:0]  axi_awlen,
    output wire [2:0]  axi_awsize,
    input  wire        axi_awready,

    output wire        axi_wvalid,
    output wire [31:0] axi_wdata,
    output wire [3:0]  axi_wstrb,
    output wire        axi_wlast,
    input  wire        axi_wready,

    input  wire        axi_bvalid,
    input  wire [1:0]  axi_bresp,
    output wire        axi_bready,

    output wire        axi_arvalid,
    output wire [31:0] axi_araddr,
    output wire [2:0]  axi_arburst,
    output wire [3:0]  axi_arlen,
    output wire [2:0]  axi_arsize,
    input  wire        axi_arready,

    input  wire        axi_rvalid,
    input  wire [31:0] axi_rdata,
    input  wire [1:0]  axi_rresp,
    input  wire        axi_rlast,
    output wire        axi_rready
);

localparam RD_IDLE  = 2'd0;
localparam RD_AR    = 2'd1;
localparam RD_RDATA = 2'd2;

localparam WR_IDLE  = 3'd0;
localparam WR_CAP1  = 3'd1;   // 行写 beat1 捕获
localparam WR_AW    = 3'd2;
localparam WR_WDATA = 3'd3;
localparam WR_RESP  = 3'd4;

reg [1:0]  rd_state;
reg [2:0]  wr_state;

reg        rd_is_ic;
reg        rd_is_line;
reg [31:0] rd_addr_buf;
reg [2:0]  rd_axsize_buf;
reg [2:0]  rd_beat;          // 0~7
reg [95:0] rd_buf;           // 半行低 3 字暂存
reg        rd_ret_valid_r;
reg        rd_ret_last_r;
reg [127:0] rd_ret_data_r;
reg        rd_rr_dc;

reg [31:0]  wr_addr_buf;
reg [255:0] wr_line_buf;
reg [3:0]   wr_strb_buf;
reg         wr_is_line;
reg [2:0]   wr_axsize_buf;
reg [2:0]   wr_beat;

// 顺序保证：写 FSM 忙时不开始新读
wire wr_busy = (wr_state != WR_IDLE);

// 读仲裁（RR）
wire rd_grant_dc = dc_rd_req && (!ic_rd_req ||  rd_rr_dc);
wire rd_grant_ic = ic_rd_req && (!dc_rd_req || !rd_rr_dc);
wire dc_rd_fire = (rd_state == RD_IDLE) && !wr_busy && rd_grant_dc;
wire ic_rd_fire = (rd_state == RD_IDLE) && !wr_busy && rd_grant_ic;

// rd_rdy 在 AR 握手拍给出（上游据此进入收数状态）
wire rd_ar_hs = (rd_state == RD_AR) && axi_arready;

always @(posedge clk) begin
    if (!resetn) begin
        rd_state <= RD_IDLE;
        wr_state <= WR_IDLE;
        rd_ret_valid_r <= 1'b0;
        rd_ret_last_r  <= 1'b0;
        rd_rr_dc <= 1'b0;
        rd_beat  <= 3'b0;
        wr_beat  <= 3'b0;
    end else begin
        rd_ret_valid_r <= 1'b0;
        rd_ret_last_r  <= 1'b0;

        // ---------------- 读通道 ----------------
        case (rd_state)
            RD_IDLE: begin
                if (ic_rd_fire || dc_rd_fire) begin
                    rd_is_ic      <= ic_rd_fire;
                    rd_rr_dc      <= ic_rd_fire;     // 轮转
                    rd_addr_buf   <= ic_rd_fire ? ic_rd_addr : dc_rd_addr;
                    rd_axsize_buf <= ic_rd_fire ? ic_rd_type : dc_rd_type;
                    rd_is_line    <= (ic_rd_fire ? ic_rd_type : dc_rd_type) == 3'b100;
                    rd_beat       <= 3'b0;
                    rd_state      <= RD_AR;
                end
            end
            RD_AR: begin
                if (axi_arready) rd_state <= RD_RDATA;
            end
            RD_RDATA: begin
                if (axi_rvalid) begin
                    if (rd_is_line) begin
                        // 每凑满 4 个字回一拍 128b
                        if (rd_beat[1:0] == 2'd3) begin
                            rd_ret_data_r  <= {axi_rdata, rd_buf};
                            rd_ret_valid_r <= 1'b1;
                            rd_ret_last_r  <= (rd_beat == 3'd7);
                        end else begin
                            rd_buf[32*rd_beat[1:0] +: 32] <= axi_rdata;
                        end
                        rd_beat <= rd_beat + 3'd1;
                        if (axi_rlast) rd_state <= RD_IDLE;
                    end else begin
                        rd_ret_data_r  <= {96'b0, axi_rdata};
                        rd_ret_valid_r <= 1'b1;
                        rd_ret_last_r  <= 1'b1;
                        rd_state       <= RD_IDLE;
                    end
                end
            end
            default: rd_state <= RD_IDLE;
        endcase

        // ---------------- 写通道 ----------------
        case (wr_state)
            WR_IDLE: begin
                if (dc_wr_req) begin
                    wr_addr_buf   <= dc_wr_addr;
                    wr_axsize_buf <= dc_wr_type;
                    wr_is_line    <= (dc_wr_type == 3'b100);
                    wr_beat       <= 3'b0;
                    if (dc_wr_type == 3'b100) begin
                        wr_line_buf[127:0] <= dc_wr_data;   // beat0（本拍 rdy ack）
                        wr_state           <= WR_CAP1;
                    end else begin
                        wr_line_buf[127:0] <= dc_wr_data;
                        wr_strb_buf        <= dc_wr_strb[3:0];
                        wr_state           <= WR_AW;
                    end
                end
            end
            WR_CAP1: begin
                wr_line_buf[255:128] <= dc_wr_data;         // beat1 直推捕获
                wr_state             <= WR_AW;
            end
            WR_AW: begin
                if (axi_awready) wr_state <= WR_WDATA;
            end
            WR_WDATA: begin
                if (axi_wready) begin
                    if ((!wr_is_line) || (wr_beat == 3'd7)) begin
                        wr_state <= WR_RESP;
                    end else begin
                        wr_beat <= wr_beat + 3'd1;
                    end
                end
            end
            WR_RESP: begin
                if (axi_bvalid) wr_state <= WR_IDLE;
            end
            default: wr_state <= WR_IDLE;
        endcase
    end
end

// ---------------- 上行握手/返回 ----------------
assign ic_rd_rdy = rd_ar_hs && rd_is_ic;
assign dc_rd_rdy = rd_ar_hs && !rd_is_ic;

// 行写 beat0 接受 ack（mealy）；非行写 rdy = B 完成
assign dc_wr_rdy = ((wr_state == WR_IDLE) && dc_wr_req && (dc_wr_type == 3'b100))
                 | ((wr_state == WR_RESP) && axi_bvalid && !wr_is_line);

assign ic_ret_valid = rd_is_ic && rd_ret_valid_r;
assign ic_ret_last  = rd_is_ic && rd_ret_last_r;
assign ic_ret_data  = rd_ret_data_r;

assign dc_ret_valid = !rd_is_ic && rd_ret_valid_r;
assign dc_ret_last  = !rd_is_ic && rd_ret_last_r;
assign dc_ret_data  = rd_ret_data_r;

// ---------------- AXI 引脚 ----------------
assign axi_awvalid = (wr_state == WR_AW);
assign axi_awaddr  = wr_is_line ? {wr_addr_buf[31:`CACHE_LINE_W], {`CACHE_LINE_W{1'b0}}} : wr_addr_buf;
assign axi_awburst = 3'b001;
assign axi_awlen   = wr_is_line ? 4'd7 : 4'd0;
assign axi_awsize  = wr_is_line ? 3'b010 : wr_axsize_buf;

assign axi_wvalid = (wr_state == WR_WDATA);
assign axi_wdata  = wr_is_line ? wr_line_buf[32*wr_beat +: 32] : wr_line_buf[31:0];
assign axi_wstrb  = wr_is_line ? 4'hf : wr_strb_buf;
assign axi_wlast  = wr_is_line ? (wr_beat == 3'd7) : 1'b1;

assign axi_bready = (wr_state == WR_RESP);

assign axi_arvalid = (rd_state == RD_AR);
assign axi_araddr  = rd_is_line ? {rd_addr_buf[31:`CACHE_LINE_W], {`CACHE_LINE_W{1'b0}}} : rd_addr_buf;
assign axi_arburst = 3'b001;
assign axi_arlen   = rd_is_line ? 4'd7 : 4'd0;
assign axi_arsize  = rd_is_line ? 3'b010 : rd_axsize_buf;

assign axi_rready = (rd_state == RD_RDATA);

// lint 吸收
wire bridge_lint = (|axi_rresp) | (|axi_bresp);

endmodule