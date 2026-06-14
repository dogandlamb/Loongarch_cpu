`include "mycpu.h"

// ============================================================
// dcache 模块（L1 数据缓存，新架构端口：load/store 分离双口）
// ------------------------------------------------------------
// 参考实现说明（全新模块体）：
// - `L1_NWAY(4) 路 × `L1_NSET(128) 组 × `CACHE_LINE_BYTES(32B) 行；
//   VIPT（index+offset=12 位，页内）；写回法 + 写分配；
// - 单 FSM 一次服务一个请求：store(SB) > load(LSU) > cacop（cacop 为
//   提交级一拍脉冲，内部寄存暂存后插队处理）；
// - 数据阵列：每路一块推断 BRAM（128×256b，字节写使能）；tag 用 LUTRAM，
//   valid/dirty 用触发器（支持一拍判定）；
// - L2 接口协议（与 l2cache/axi_line_bridge 同约定）：
//   * 读：rd_type=100 整行（2 拍 128b 返回，ret_last 标末拍）；其余单拍；
//   * 写：wr_type=100 整行 2 拍——beat0 持 req 等 wr_rdy，beat1 次拍直推
//     （接收方保证连续接收）；非行写单拍，wr_rdy=完成（含 AXI B）；
// - uncached：load/store 单字旁路（按真实 size），保持设备访问宽度；
// - cacop：op0=StoreTag(无写回无效)，op1=Index 写回无效，op2=Hit 写回无效。
// ============================================================
module dcache (
    input  wire        clk,
    input  wire        resetn,

    // ---------------- LSU load 口 ----------------
    input  wire        ld_req_i,         // load 请求（保持至 addr_ok）
    input  wire [31:0] ld_vaddr_i,       // 虚地址（VIPT 索引）
    input  wire [31:0] ld_paddr_i,       // 物理地址（tag 比对）
    input  wire [2:0]  ld_size_i,        // 0=B 1=H 2=W（uncached 精确宽度）
    input  wire        ld_uncached_i,
    output wire        ld_addr_ok_o,
    output wire        ld_data_ok_o,
    output wire [31:0] ld_rdata_o,
    input  wire        ld_cancel_i,      // 冲刷取消在途 load（本实现忽略，LSU 自行丢弃）

    // ---------------- store_buffer 写出口 ----------------
    input  wire        st_req_i,         // store 写请求（保持至 addr_ok）
    input  wire [31:0] st_paddr_i,
    input  wire [31:0] st_data_i,
    input  wire [3:0]  st_strb_i,
    input  wire [2:0]  st_size_i,
    input  wire        st_uncached_i,
    output wire        st_addr_ok_o,
    output wire        st_done_o,        // 写完成（写命中可快速完成）

    // ---------------- cache 维护口（commit 提交级驱动）----------------
    input  wire        cacop_en_i,
    input  wire [1:0]  cacop_op_i,       // IDX_INV / HIT_INV / HIT_WB
    input  wire [31:0] cacop_addr_i,

    // ---------------- 下层 L2 接口（原样保留）----------------
    output wire        axi_rd_req,
    output wire [2:0]  axi_rd_type,
    output wire [31:0] axi_rd_addr,
    input  wire        axi_rd_rdy,
    input  wire        axi_ret_valid,
    input  wire        axi_ret_last,
    input  wire [127:0] axi_ret_data,
    output wire        axi_wr_req,
    output wire [2:0]  axi_wr_type,
    output wire [31:0] axi_wr_addr,
    output wire [15:0] axi_wr_strb,
    output wire [127:0] axi_wr_data,
    output wire        axi_wr_cacop,
    input  wire        axi_wr_rdy
);

localparam NWAY  = `L1_NWAY;
localparam NSET  = `L1_NSET;
localparam IDXW  = `L1_INDEX_W;        // 7
localparam TAGW  = `L1_TAG_W;          // 20
localparam LINEW = `CACHE_LINE_BITS;   // 256

// FSM
localparam S_IDLE    = 4'd0;
localparam S_LOOKUP  = 4'd1;
localparam S_WB_B0   = 4'd2;   // 写回 beat0（等 wr_rdy）
localparam S_WB_B1   = 4'd3;   // 写回 beat1（直推一拍）
localparam S_RREQ    = 4'd4;   // 整行读请求
localparam S_RDATA   = 4'd5;   // 收 2 拍重填数据
localparam S_RESP    = 4'd6;   // 重填后响应一拍
localparam S_UC_RREQ = 4'd7;   // uncached 读请求
localparam S_UC_RDATA= 4'd8;
localparam S_UC_RESP = 4'd9;
localparam S_UC_WREQ = 4'd10;  // uncached 写（等完成）
localparam S_CAC_WB0 = 4'd11;  // cacop 写回 beat0
localparam S_CAC_WB1 = 4'd12;

reg [3:0] state;

// ---------------- 存储阵列 ----------------
reg [NSET-1:0] valid_arr [0:NWAY-1];
reg [NSET-1:0] dirty_arr [0:NWAY-1];
reg [TAGW-1:0] tag_arr   [0:NWAY-1][0:NSET-1];   // LUTRAM（异步读）

// 数据 BRAM：每路一块单口 RAM（读 1 拍；读/写分别发生在不同状态拍）
wire [LINEW-1:0] data_out [0:NWAY-1];
reg  [IDXW-1:0]  ram_addr;          // 共用地址（读在 IDLE 拍，写在 LOOKUP/RDATA 拍）
reg  [NWAY-1:0]  ram_we;
reg  [LINEW-1:0] ram_wline;
wire             ram_re;

// 每组替换计数器（伪随机轮转）
reg [1:0] rr_ptr [0:NSET-1];

// ---------------- 请求锁存 ----------------
reg        req_is_st;       // 1=store 0=load
reg        req_is_cacop;
reg [1:0]  req_cacop_op;
reg [31:0] req_paddr;
reg [31:0] req_wdata;
reg [3:0]  req_wstrb;
reg [2:0]  req_size;
reg        req_uncached;

// cacop 暂存（commit 一拍脉冲，FSM 忙时排队）
reg        cacop_pend;
reg [1:0]  cacop_pend_op;
reg [31:0] cacop_pend_addr;

// 重填/写回中间量
reg [1:0]        victim_way;
reg [TAGW-1:0]   victim_tag;
reg [LINEW-1:0]  victim_line;
reg [127:0]      refill_b0;
reg [31:0]       uc_rdata;
reg              resp_is_st;

wire [IDXW-1:0] req_set = req_paddr[IDXW+`CACHE_LINE_W-1:`CACHE_LINE_W];
wire [TAGW-1:0] req_tag = req_paddr[31:IDXW+`CACHE_LINE_W];
wire [2:0]      req_word= req_paddr[4:2];

// ---------------- 命中判定（LOOKUP 拍，tag LUTRAM 异步读）----------------
wire [NWAY-1:0] way_hit;
genvar gw;
generate
for (gw = 0; gw < NWAY; gw = gw + 1) begin : gen_hit
    assign way_hit[gw] = valid_arr[gw][req_set] && (tag_arr[gw][req_set] == req_tag);
end
endgenerate
wire        hit_any = |way_hit;
wire [1:0]  hit_way = way_hit[1] ? 2'd1 : way_hit[2] ? 2'd2 : way_hit[3] ? 2'd3 : 2'd0;

// cacop 的 set/way 解码
wire [IDXW-1:0] cac_set = req_paddr[IDXW+`CACHE_LINE_W-1:`CACHE_LINE_W];
wire [1:0]      cac_way = req_paddr[1:0];

// victim 选择：先找无效路，否则轮转
wire [NWAY-1:0] way_invalid;
generate
for (gw = 0; gw < NWAY; gw = gw + 1) begin : gen_inv
    assign way_invalid[gw] = !valid_arr[gw][req_set];
end
endgenerate
wire [1:0] pick_way = way_invalid[0] ? 2'd0 :
                      way_invalid[1] ? 2'd1 :
                      way_invalid[2] ? 2'd2 :
                      way_invalid[3] ? 2'd3 : rr_ptr[req_set];

// ---------------- 接受仲裁（IDLE）----------------
wire cacop_take = (state == S_IDLE) && cacop_pend;
wire st_take    = (state == S_IDLE) && !cacop_pend && st_req_i;
wire ld_take    = (state == S_IDLE) && !cacop_pend && !st_req_i && ld_req_i;

assign st_addr_ok_o = st_take;
assign ld_addr_ok_o = ld_take;

// ---------------- 命中通路输出 ----------------
wire [LINEW-1:0] hit_line = data_out[hit_way];
wire [31:0] hit_word = hit_line[32*req_word +: 32];

// store 命中合并写
wire [31:0] st_word_strb = { {8{req_wstrb[3]}}, {8{req_wstrb[2]}},
                             {8{req_wstrb[1]}}, {8{req_wstrb[0]}} };

// 重填行（2 拍拼接 + store 合并）
wire [LINEW-1:0] refill_line_raw = {axi_ret_data, refill_b0};
wire [31:0] refill_word_old = refill_line_raw[32*req_word +: 32];
wire [31:0] refill_word_new = (refill_word_old & ~st_word_strb) | (req_wdata & st_word_strb);
reg  [LINEW-1:0] refill_line_merged;
integer wi;
always @(*) begin
    refill_line_merged = refill_line_raw;
    if (resp_is_st)
        refill_line_merged[32*req_word +: 32] = refill_word_new;
end

reg [LINEW-1:0] resp_line;   // 重填完成后的行（RESP 拍输出 load 数据）

// ---------------- 响应输出 ----------------
// load 命中：LOOKUP 拍组合给出；重填：RESP 拍；uncached：UC_RESP 拍
wire lookup_ld_hit = (state == S_LOOKUP) && !req_is_st && !req_is_cacop && !req_uncached && hit_any;
wire lookup_st_hit = (state == S_LOOKUP) &&  req_is_st && !req_is_cacop && !req_uncached && hit_any;

assign ld_data_ok_o = lookup_ld_hit
                    | ((state == S_RESP)    && !resp_is_st)
                    | (state == S_UC_RESP);
assign ld_rdata_o   = lookup_ld_hit       ? hit_word
                    : (state == S_UC_RESP) ? uc_rdata
                    : resp_line[32*req_word +: 32];

assign st_done_o    = lookup_st_hit
                    | ((state == S_RESP) && resp_is_st)
                    | ((state == S_UC_WREQ) && axi_wr_rdy);

// ---------------- L2 接口驱动 ----------------
assign axi_rd_req  = (state == S_RREQ) || (state == S_UC_RREQ);
assign axi_rd_type = (state == S_RREQ) ? 3'b100 : req_size;
assign axi_rd_addr = (state == S_RREQ) ? {req_paddr[31:`CACHE_LINE_W], {`CACHE_LINE_W{1'b0}}}
                                       : req_paddr;

assign axi_wr_req  = (state == S_WB_B0) || (state == S_WB_B1)
                   || (state == S_CAC_WB0) || (state == S_CAC_WB1)
                   || (state == S_UC_WREQ);
assign axi_wr_type = (state == S_UC_WREQ) ? req_size : 3'b100;
assign axi_wr_addr = (state == S_UC_WREQ) ? req_paddr
                                          : {victim_tag, req_set, {`CACHE_LINE_W{1'b0}}};
assign axi_wr_data = (state == S_UC_WREQ) ? {96'b0, req_wdata}
                   : ((state == S_WB_B0) || (state == S_CAC_WB0)) ? victim_line[127:0]
                                                                  : victim_line[255:128];
assign axi_wr_strb = (state == S_UC_WREQ) ? {12'b0, req_wstrb} : 16'hffff;
assign axi_wr_cacop= (state == S_CAC_WB0) || (state == S_CAC_WB1);

// ---------------- BRAM 读写控制 ----------------
// 读：IDLE 接受请求拍（地址 = 新请求 set）；
// 写：LOOKUP store 命中（读改写整行）/ RDATA 末拍重填 —— 与读不同拍，单口共用
wire [IDXW-1:0] rd_set_idle = cacop_take ? cacop_pend_addr[IDXW+`CACHE_LINE_W-1:`CACHE_LINE_W]
                            : st_take    ? st_paddr_i[IDXW+`CACHE_LINE_W-1:`CACHE_LINE_W]
                                         : ld_vaddr_i[IDXW+`CACHE_LINE_W-1:`CACHE_LINE_W];
assign ram_re = cacop_take || st_take || ld_take;

// store 命中合并行（读改写：用 LOOKUP 拍已读出的整行）
reg [LINEW-1:0] st_merge_line;
always @(*) begin
    st_merge_line = data_out[hit_way];
    st_merge_line[32*req_word +: 32] =
        (data_out[hit_way][32*req_word +: 32] & ~st_word_strb) | (req_wdata & st_word_strb);
end

wire refill_wr = (state == S_RDATA) && axi_ret_valid && axi_ret_last;

always @(*) begin
    ram_we    = {NWAY{1'b0}};
    ram_addr  = rd_set_idle;
    ram_wline = st_merge_line;
    if (lookup_st_hit) begin
        ram_we[hit_way] = 1'b1;
        ram_addr        = req_set;
        ram_wline       = st_merge_line;
    end else if (refill_wr) begin
        ram_we[victim_way] = 1'b1;
        ram_addr           = req_set;
        ram_wline          = refill_line_merged;
    end
end

genvar gr;
generate
for (gr = 0; gr < NWAY; gr = gr + 1) begin : gen_dram
    dcache_way_ram u_way_ram(
        .clk   (clk),
        .en    (ram_re | ram_we[gr]),
        .we    (ram_we[gr]),
        .addr  (ram_addr),
        .wdata (ram_wline),
        .rdata (data_out[gr])
    );
end
endgenerate

// ---------------- 主 FSM ----------------
integer s;
always @(posedge clk) begin
    if (!resetn) begin
        state      <= S_IDLE;
        cacop_pend <= 1'b0;
        for (s = 0; s < NWAY; s = s + 1) begin
            valid_arr[s] <= {NSET{1'b0}};
            dirty_arr[s] <= {NSET{1'b0}};
        end
    end else begin
        // cacop 暂存（一拍脉冲随时到来）
        if (cacop_en_i) begin
            cacop_pend      <= 1'b1;
            cacop_pend_op   <= cacop_op_i;
            cacop_pend_addr <= cacop_addr_i;
        end

        case (state)
            S_IDLE: begin
                if (cacop_take) begin
                    req_is_cacop <= 1'b1;
                    req_is_st    <= 1'b0;
                    req_cacop_op <= cacop_pend_op;
                    req_paddr    <= cacop_pend_addr;
                    cacop_pend   <= 1'b0;
                    state        <= S_LOOKUP;
                end else if (st_take) begin
                    req_is_cacop <= 1'b0;
                    req_is_st    <= 1'b1;
                    req_paddr    <= st_paddr_i;
                    req_wdata    <= st_data_i;
                    req_wstrb    <= st_strb_i;
                    req_size     <= st_size_i;
                    req_uncached <= st_uncached_i;
                    state        <= S_LOOKUP;
                end else if (ld_take) begin
                    req_is_cacop <= 1'b0;
                    req_is_st    <= 1'b0;
                    req_paddr    <= ld_paddr_i;
                    req_size     <= ld_size_i;
                    req_uncached <= ld_uncached_i;
                    state        <= S_LOOKUP;
                end
            end

            S_LOOKUP: begin
                if (req_is_cacop) begin
                    case (req_cacop_op)
                        `CACOP_OP_IDX_INV: begin
                            // StoreTag：直接无效化（无写回）
                            valid_arr[cac_way][cac_set] <= 1'b0;
                            dirty_arr[cac_way][cac_set] <= 1'b0;
                            state <= S_IDLE;
                        end
                        `CACOP_OP_HIT_INV: begin
                            // Index 写回无效（op=1）
                            if (valid_arr[cac_way][cac_set] && dirty_arr[cac_way][cac_set]) begin
                                victim_way  <= cac_way;
                                victim_tag  <= tag_arr[cac_way][cac_set];
                                victim_line <= data_out[cac_way];
                                valid_arr[cac_way][cac_set] <= 1'b0;
                                dirty_arr[cac_way][cac_set] <= 1'b0;
                                state <= S_CAC_WB0;
                            end else begin
                                valid_arr[cac_way][cac_set] <= 1'b0;
                                dirty_arr[cac_way][cac_set] <= 1'b0;
                                state <= S_IDLE;
                            end
                        end
                        default: begin
                            // Hit 写回无效（op=2）：按物理地址查命中
                            if (hit_any) begin
                                if (dirty_arr[hit_way][req_set]) begin
                                    victim_way  <= hit_way;
                                    victim_tag  <= tag_arr[hit_way][req_set];
                                    victim_line <= data_out[hit_way];
                                    valid_arr[hit_way][req_set] <= 1'b0;
                                    dirty_arr[hit_way][req_set] <= 1'b0;
                                    state <= S_CAC_WB0;
                                end else begin
                                    valid_arr[hit_way][req_set] <= 1'b0;
                                    state <= S_IDLE;
                                end
                            end else begin
                                state <= S_IDLE;
                            end
                        end
                    endcase
                end else if (req_uncached) begin
                    state <= req_is_st ? S_UC_WREQ : S_UC_RREQ;
                end else if (hit_any) begin
                    // 命中：load 出数 / store 合并写（本拍完成）
                    if (req_is_st) dirty_arr[hit_way][req_set] <= 1'b1;
                    state <= S_IDLE;
                end else begin
                    // miss：选 victim，脏则先写回
                    victim_way  <= pick_way;
                    victim_tag  <= tag_arr[pick_way][req_set];
                    victim_line <= data_out[pick_way];
                    rr_ptr[req_set] <= rr_ptr[req_set] + 2'd1;
                    if (valid_arr[pick_way][req_set] && dirty_arr[pick_way][req_set])
                        state <= S_WB_B0;
                    else
                        state <= S_RREQ;
                end
            end

            S_WB_B0:   if (axi_wr_rdy) state <= S_WB_B1;
            S_WB_B1:   state <= S_RREQ;                       // beat1 直推一拍

            S_RREQ:    if (axi_rd_rdy) state <= S_RDATA;
            S_RDATA: begin
                if (axi_ret_valid) begin
                    if (axi_ret_last) begin
                        // 整行到齐：写阵列 + 更新 tag/valid/dirty
                        tag_arr[victim_way][req_set]   <= req_tag;
                        valid_arr[victim_way][req_set] <= 1'b1;
                        dirty_arr[victim_way][req_set] <= req_is_st;
                        resp_line  <= refill_line_merged;
                        resp_is_st <= req_is_st;
                        state      <= S_RESP;
                    end else begin
                        refill_b0 <= axi_ret_data;
                    end
                end
            end
            S_RESP:    state <= S_IDLE;

            S_UC_RREQ: if (axi_rd_rdy) state <= S_UC_RDATA;
            S_UC_RDATA: begin
                if (axi_ret_valid) begin
                    uc_rdata <= axi_ret_data[31:0];
                    state    <= S_UC_RESP;
                end
            end
            S_UC_RESP: state <= S_IDLE;

            S_UC_WREQ: if (axi_wr_rdy) state <= S_IDLE;

            S_CAC_WB0: if (axi_wr_rdy) state <= S_CAC_WB1;
            S_CAC_WB1: state <= S_IDLE;

            default: state <= S_IDLE;
        endcase
    end
end

// rr_ptr 无复位（伪随机即可）；仿真防 X 上电清零
integer ri;
initial begin
    for (ri = 0; ri < NSET; ri = ri + 1) rr_ptr[ri] = 2'b0;
end

// lint 吸收
wire dcache_lint = ld_cancel_i | (|ld_vaddr_i);

endmodule

// ------------------------------------------------------------
// dcache_way_ram：单口同步 RAM 模板（128 x 256b，推断 BRAM）
// ------------------------------------------------------------
module dcache_way_ram(
    input  wire                          clk,
    input  wire                          en,
    input  wire                          we,
    input  wire [`L1_INDEX_W-1:0]        addr,
    input  wire [`CACHE_LINE_BITS-1:0]   wdata,
    output reg  [`CACHE_LINE_BITS-1:0]   rdata
);
reg [`CACHE_LINE_BITS-1:0] mem [0:`L1_NSET-1];
always @(posedge clk) begin
    if (en) begin
        if (we) mem[addr] <= wdata;
        else    rdata <= mem[addr];
    end
end
endmodule
