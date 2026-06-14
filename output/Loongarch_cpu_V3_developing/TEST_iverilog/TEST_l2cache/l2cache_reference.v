`include "mycpu.h"

// ============================================================
// l2cache 模块（L2 统一缓存：I$/D$ 共享的第二级缓存）
// ------------------------------------------------------------
// 参考实现说明（按 32B 行重写模块体，端口不变）：
// - `L2_NWAY(2) 路 × `L2_NSET(512) 组 × 32B 行 = 32KB，写回法 + 脏位；
// - 行协议（与 L1/axi_line_bridge 一致）：
//   * 读 type=100：rd_rdy 接受后 2 拍 128b 返回（ret_last 末拍）；
//   * 写 type=100：beat0 持 req 等 wr_rdy（接受拍），beat1 次拍直推；
//   * 非行（uncached）：单拍旁路下层，写的 rdy=完成；
// - 行写命中 -> 更新行置脏；行写 miss -> 直通下层内存（不分配）；
// - 行读 miss：victim 脏先写回（2 拍）-> 整行读内存（2 拍）-> 重填+返回；
// - 仲裁：dc_wr > dc_rd/ic_rd 轮转；
// - tag/data 均用推断 BRAM（IDLE 拍发地址，LOOKUP 拍比对）。
// ============================================================
module l2cache (
    input  wire         clk,
    input  wire         resetn,

    input  wire         ic_rd_req,
    input  wire [2:0]   ic_rd_type,
    input  wire [31:0]  ic_rd_addr,
    output wire         ic_rd_rdy,
    output wire         ic_ret_valid,
    output wire         ic_ret_last,
    output wire [127:0] ic_ret_data,

    input  wire         dc_rd_req,
    input  wire [2:0]   dc_rd_type,
    input  wire [31:0]  dc_rd_addr,
    output wire         dc_rd_rdy,
    output wire         dc_ret_valid,
    output wire         dc_ret_last,
    output wire [127:0] dc_ret_data,

    input  wire         dc_wr_req,
    input  wire [2:0]   dc_wr_type,
    input  wire [31:0]  dc_wr_addr,
    input  wire [15:0]  dc_wr_strb,
    input  wire [127:0] dc_wr_data,
    input  wire         dc_wr_cacop,
    output wire         dc_wr_rdy,

    output wire         mem_rd_req,
    output wire [2:0]   mem_rd_type,
    output wire [31:0]  mem_rd_addr,
    input  wire         mem_rd_rdy,
    input  wire         mem_ret_valid,
    input  wire         mem_ret_last,
    input  wire [127:0] mem_ret_data,

    output wire         mem_wr_req,
    output wire [2:0]   mem_wr_type,
    output wire [31:0]  mem_wr_addr,
    output wire [15:0]  mem_wr_strb,
    output wire [127:0] mem_wr_data,
    input  wire         mem_wr_rdy
);

localparam NWAY  = `L2_NWAY;     // 2
localparam NSET  = `L2_NSET;     // 512
localparam IDXW  = `L2_INDEX_W;  // 9
localparam TAGW  = `L2_TAG_W;    // 18
localparam LINEW = `CACHE_LINE_BITS;

localparam S_IDLE     = 4'd0;
localparam S_WCAP     = 4'd1;    // 行写 beat1 捕获 + 发 BRAM 地址
localparam S_LOOKUP   = 4'd2;
localparam S_MWB0     = 4'd3;    // victim 写回 beat0
localparam S_MWB1     = 4'd4;
localparam S_MRREQ    = 4'd5;    // 整行读内存
localparam S_MRDATA   = 4'd6;
localparam S_RET0     = 4'd7;    // 上行返回 2 拍
localparam S_RET1     = 4'd8;
localparam S_WFWD0    = 4'd9;    // 行写 miss 直通内存
localparam S_WFWD1    = 4'd10;
localparam S_BYP_RREQ = 4'd11;   // uncached 读旁路
localparam S_BYP_RDATA= 4'd12;
localparam S_BYP_RET  = 4'd13;
localparam S_BYP_WREQ = 4'd14;   // uncached 写旁路（rdy=完成）

reg [3:0] state;

// ---------------- 存储（推断 BRAM：每路 tag + data）----------------
// tag 条目：{valid, dirty, tag[17:0]}
wire [TAGW+1:0]  tag_out  [0:NWAY-1];
wire [LINEW-1:0] data_out [0:NWAY-1];
reg  [IDXW-1:0]  ram_addr;
reg  [NWAY-1:0]  tag_we, data_we;
reg  [TAGW+1:0]  tag_wdata;
reg  [LINEW-1:0] data_wdata;
reg              ram_re;

genvar gr;
generate
for (gr = 0; gr < NWAY; gr = gr + 1) begin : gen_l2ram
    l2_tag_ram_t u_tag_ram(
        .clk(clk), .en(ram_re | tag_we[gr]), .we(tag_we[gr]),
        .addr(ram_addr), .wdata(tag_wdata), .rdata(tag_out[gr])
    );
    l2_data_ram_t u_data_ram(
        .clk(clk), .en(ram_re | data_we[gr]), .we(data_we[gr]),
        .addr(ram_addr), .wdata(data_wdata), .rdata(data_out[gr])
    );
end
endgenerate

// 复位期间逐组清 tag valid（上电 BRAM 内容未知）
reg            initing;
reg [IDXW-1:0] init_set;

// ---------------- 请求锁存 ----------------
reg        req_is_ic;       // 读请求来源
reg        req_is_rd;       // 1=读 0=写
reg        req_is_line;
reg [31:0] req_addr;
reg [2:0]  req_type;
reg [255:0] req_wline;      // 行写数据（2 拍拼）
reg [15:0]  req_strb_lo;
reg [127:0] uc_wdata;
reg [3:0]   uc_strb;

wire [IDXW-1:0] req_set = req_addr[IDXW+`CACHE_LINE_W-1:`CACHE_LINE_W];
wire [TAGW-1:0] req_tag = req_addr[31:IDXW+`CACHE_LINE_W];

// ---------------- 命中判定（LOOKUP 拍）----------------
wire [NWAY-1:0] way_hit;
generate
for (gr = 0; gr < NWAY; gr = gr + 1) begin : gen_l2hit
    assign way_hit[gr] = tag_out[gr][TAGW+1] && (tag_out[gr][TAGW-1:0] == req_tag);
end
endgenerate
wire hit_any = |way_hit;
wire hit_way = way_hit[1];

// victim：无效路优先，否则轮转位
reg rr_bit;
wire pick_way = !tag_out[0][TAGW+1] ? 1'b0 :
                !tag_out[1][TAGW+1] ? 1'b1 : rr_bit;

reg        victim_way_r;
reg [TAGW-1:0] victim_tag_r;
reg [LINEW-1:0] victim_line_r;
reg        victim_dirty_r;

reg [127:0] refill_b0;
reg [LINEW-1:0] ret_line;
reg         ret_is_ic;
reg [127:0] byp_data;

// ---------------- 仲裁（IDLE，dc_wr > rd 轮转）----------------
reg rr_rd_dc;
wire grant_wr = (state == S_IDLE) && !initing && dc_wr_req;
wire grant_dc_rd = (state == S_IDLE) && !initing && !dc_wr_req && dc_rd_req
                 && (!ic_rd_req || rr_rd_dc);
wire grant_ic_rd = (state == S_IDLE) && !initing && !dc_wr_req && ic_rd_req
                 && (!dc_rd_req || !rr_rd_dc);

// 行写 beat0 接受 ack（mealy）；uncached 写的 rdy 在 BYP_WREQ 完成时
assign dc_wr_rdy = (grant_wr && (dc_wr_type == 3'b100))
                 | ((state == S_BYP_WREQ) && mem_wr_rdy);
assign dc_rd_rdy = grant_dc_rd;
assign ic_rd_rdy = grant_ic_rd;

// ---------------- 上行返回（按请求来源路由，含旁路）----------------
wire ret_beat  = (state == S_RET0) || (state == S_RET1);
wire byp_beat  = (state == S_BYP_RET);
wire [127:0] ret_data_mux = byp_beat ? byp_data
                          : (state == S_RET0) ? ret_line[127:0] : ret_line[255:128];

assign ic_ret_valid = req_is_ic && (ret_beat || byp_beat);
assign ic_ret_last  = req_is_ic && ((state == S_RET1) || byp_beat);
assign ic_ret_data  = ret_data_mux;

assign dc_ret_valid = !req_is_ic && (ret_beat || byp_beat);
assign dc_ret_last  = !req_is_ic && ((state == S_RET1) || byp_beat);
assign dc_ret_data  = ret_data_mux;

// ---------------- 下行内存接口 ----------------
assign mem_rd_req  = (state == S_MRREQ) || (state == S_BYP_RREQ);
assign mem_rd_type = (state == S_MRREQ) ? 3'b100 : req_type;
assign mem_rd_addr = (state == S_MRREQ) ? {req_addr[31:`CACHE_LINE_W], {`CACHE_LINE_W{1'b0}}}
                                        : req_addr;

assign mem_wr_req  = (state == S_MWB0) || (state == S_MWB1)
                   || (state == S_WFWD0) || (state == S_WFWD1)
                   || (state == S_BYP_WREQ);
assign mem_wr_type = (state == S_BYP_WREQ) ? req_type : 3'b100;
assign mem_wr_addr = ((state == S_WFWD0) || (state == S_WFWD1)) ? {req_addr[31:`CACHE_LINE_W], {`CACHE_LINE_W{1'b0}}}
                   : (state == S_BYP_WREQ) ? req_addr
                   : {victim_tag_r, req_set, {`CACHE_LINE_W{1'b0}}};
assign mem_wr_data = (state == S_MWB0)  ? victim_line_r[127:0]
                   : (state == S_MWB1)  ? victim_line_r[255:128]
                   : (state == S_WFWD0) ? req_wline[127:0]
                   : (state == S_WFWD1) ? req_wline[255:128]
                   : uc_wdata;
assign mem_wr_strb = (state == S_BYP_WREQ) ? {12'b0, uc_strb} : 16'hffff;

// ---------------- BRAM 控制 ----------------
wire [IDXW-1:0] idle_set = grant_wr    ? dc_wr_addr[IDXW+`CACHE_LINE_W-1:`CACHE_LINE_W]
                         : grant_dc_rd ? dc_rd_addr[IDXW+`CACHE_LINE_W-1:`CACHE_LINE_W]
                                       : ic_rd_addr[IDXW+`CACHE_LINE_W-1:`CACHE_LINE_W];

wire refill_wr_en = (state == S_MRDATA) && mem_ret_valid && mem_ret_last;
wire whit_wr_en   = (state == S_LOOKUP) && !req_is_rd && req_is_line && hit_any;

always @(*) begin
    ram_re     = 1'b0;
    ram_addr   = idle_set;
    tag_we     = {NWAY{1'b0}};
    data_we    = {NWAY{1'b0}};
    tag_wdata  = {1'b1, 1'b0, req_tag};
    data_wdata = {mem_ret_data, refill_b0};
    if (initing) begin
        ram_addr  = init_set;
        tag_we    = {NWAY{1'b1}};
        tag_wdata = {(TAGW+2){1'b0}};
    end else if (whit_wr_en) begin
        // 行写命中：整行更新 + 置脏
        ram_addr            = req_set;
        data_we[hit_way]    = 1'b1;
        data_wdata          = req_wline;
        tag_we[hit_way]     = 1'b1;
        tag_wdata           = {1'b1, 1'b1, req_tag};
    end else if (refill_wr_en) begin
        // 重填：写新行（读 miss 分配，干净）
        ram_addr             = req_set;
        data_we[victim_way_r]= 1'b1;
        data_wdata           = {mem_ret_data, refill_b0};
        tag_we[victim_way_r] = 1'b1;
        tag_wdata            = {1'b1, 1'b0, req_tag};
    end else if ((grant_wr && (dc_wr_type == 3'b100)) || grant_dc_rd || grant_ic_rd) begin
        // 接受新行请求拍发读（uncached 不需要查表）
        ram_re   = (grant_wr && (dc_wr_type == 3'b100))
                 | (grant_dc_rd && (dc_rd_type == 3'b100))
                 | (grant_ic_rd && (ic_rd_type == 3'b100));
        ram_addr = idle_set;
    end else if (state == S_WCAP) begin
        // 行写 beat1 拍重发 BRAM 读（LOOKUP 拍比对）
        ram_re   = 1'b1;
        ram_addr = req_set;
    end
end

// ---------------- 主 FSM ----------------
always @(posedge clk) begin
    if (!resetn) begin
        state    <= S_IDLE;
        initing  <= 1'b1;
        init_set <= {IDXW{1'b0}};
        rr_bit   <= 1'b0;
        rr_rd_dc <= 1'b0;
    end else if (initing) begin
        init_set <= init_set + 1'b1;
        if (init_set == {IDXW{1'b1}}) initing <= 1'b0;
    end else begin
        case (state)
            S_IDLE: begin
                if (grant_wr) begin
                    req_is_rd   <= 1'b0;
                    req_is_line <= (dc_wr_type == 3'b100);
                    req_addr    <= dc_wr_addr;
                    req_type    <= dc_wr_type;
                    if (dc_wr_type == 3'b100) begin
                        req_wline[127:0] <= dc_wr_data;
                        req_strb_lo      <= dc_wr_strb;
                        state            <= S_WCAP;
                    end else begin
                        uc_wdata <= dc_wr_data;
                        uc_strb  <= dc_wr_strb[3:0];
                        state    <= S_BYP_WREQ;
                    end
                end else if (grant_dc_rd || grant_ic_rd) begin
                    req_is_rd   <= 1'b1;
                    req_is_ic   <= grant_ic_rd;
                    rr_rd_dc    <= grant_ic_rd;       // 轮转
                    req_is_line <= grant_ic_rd ? (ic_rd_type == 3'b100) : (dc_rd_type == 3'b100);
                    req_addr    <= grant_ic_rd ? ic_rd_addr : dc_rd_addr;
                    req_type    <= grant_ic_rd ? ic_rd_type : dc_rd_type;
                    if (grant_ic_rd ? (ic_rd_type == 3'b100) : (dc_rd_type == 3'b100))
                        state <= S_LOOKUP;
                    else
                        state <= S_BYP_RREQ;
                end
            end

            S_WCAP: begin
                req_wline[255:128] <= dc_wr_data;     // beat1 直推捕获
                state <= S_LOOKUP;
            end

            S_LOOKUP: begin
                if (!req_is_rd) begin
                    // 行写：命中已在组合块写入；miss 直通内存
                    state <= hit_any ? S_IDLE : S_WFWD0;
                end else if (hit_any) begin
                    ret_line  <= data_out[hit_way];
                    ret_is_ic <= req_is_ic;
                    state     <= S_RET0;
                end else begin
                    victim_way_r   <= pick_way;
                    victim_tag_r   <= pick_way ? tag_out[1][TAGW-1:0] : tag_out[0][TAGW-1:0];
                    victim_line_r  <= data_out[pick_way];
                    victim_dirty_r <= pick_way ? tag_out[1][TAGW] : tag_out[0][TAGW];
                    rr_bit         <= ~rr_bit;
                    if ((pick_way ? tag_out[1][TAGW+1] : tag_out[0][TAGW+1])
                        && (pick_way ? tag_out[1][TAGW] : tag_out[0][TAGW]))
                        state <= S_MWB0;
                    else
                        state <= S_MRREQ;
                end
            end

            S_MWB0: if (mem_wr_rdy) state <= S_MWB1;
            S_MWB1: state <= S_MRREQ;

            S_MRREQ: if (mem_rd_rdy) state <= S_MRDATA;
            S_MRDATA: begin
                if (mem_ret_valid) begin
                    if (mem_ret_last) begin
                        ret_line  <= {mem_ret_data, refill_b0};
                        ret_is_ic <= req_is_ic;
                        state     <= S_RET0;
                    end else begin
                        refill_b0 <= mem_ret_data;
                    end
                end
            end

            S_RET0: state <= S_RET1;
            S_RET1: state <= S_IDLE;

            S_WFWD0: if (mem_wr_rdy) state <= S_WFWD1;
            S_WFWD1: state <= S_IDLE;

            S_BYP_RREQ: if (mem_rd_rdy) state <= S_BYP_RDATA;
            S_BYP_RDATA: begin
                if (mem_ret_valid) begin
                    byp_data <= mem_ret_data;
                    state    <= S_BYP_RET;
                end
            end
            S_BYP_RET: state <= S_IDLE;

            S_BYP_WREQ: if (mem_wr_rdy) state <= S_IDLE;

            default: state <= S_IDLE;
        endcase
    end
end

// lint 吸收（cacop 写按普通行写处理；victim_dirty_r 已并入判断）
wire l2_lint = dc_wr_cacop | victim_dirty_r | (|req_strb_lo);

endmodule

// ------------------------------------------------------------
// l2_tag_ram_t / l2_data_ram_t：单口同步 RAM 模板（推断 BRAM）
// ------------------------------------------------------------
module l2_tag_ram_t(
    input  wire                     clk,
    input  wire                     en,
    input  wire                     we,
    input  wire [`L2_INDEX_W-1:0]   addr,
    input  wire [`L2_TAG_W+1:0]     wdata,
    output reg  [`L2_TAG_W+1:0]     rdata
);
reg [`L2_TAG_W+1:0] mem [0:`L2_NSET-1];
always @(posedge clk) begin
    if (en) begin
        if (we) mem[addr] <= wdata;
        else    rdata <= mem[addr];
    end
end
endmodule

module l2_data_ram_t(
    input  wire                          clk,
    input  wire                          en,
    input  wire                          we,
    input  wire [`L2_INDEX_W-1:0]        addr,
    input  wire [`CACHE_LINE_BITS-1:0]   wdata,
    output reg  [`CACHE_LINE_BITS-1:0]   rdata
);
reg [`CACHE_LINE_BITS-1:0] mem [0:`L2_NSET-1];
always @(posedge clk) begin
    if (en) begin
        if (we) mem[addr] <= wdata;
        else    rdata <= mem[addr];
    end
end
endmodule