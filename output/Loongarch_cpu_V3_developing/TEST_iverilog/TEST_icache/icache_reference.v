`include "mycpu.h"

// ============================================================
// icache 模块（L1 指令缓存，新架构端口：整行取指）
// ------------------------------------------------------------
// 参考实现说明（全新模块体）：
// - `L1_NWAY(4) 路 × `L1_NSET(128) 组 × `CACHE_LINE_BYTES(32B) 行，VIPT；
// - 命中 2 拍出整行（IDLE 收请求 -> LOOKUP 比对+出数）；
// - miss：整行读 L2（2 拍 128b，ret_last 末拍），重填后 RESP 拍出行；
// - uncached 取指：从块起始字到行末逐字单拍读（设备/未开 cache 期间），
//   拼成"部分有效行"返回——IFU 按块偏移切割，恰好只用有效部分；
// - cacop：op0=StoreTag 无效化、op1=Index 无效化、op2=Hit 无效化（I$ 无脏行，
//   一拍完成）；commit 一拍脉冲先暂存再插队处理；
// - ifu_cancel_i 忽略：IFU 用在途配对自行丢弃过期返回（语义已约定）。
// ============================================================
module icache (
    input  wire        clk,
    input  wire        resetn,

    // ---------------- IFU 取指口 ----------------
    input  wire        ifu_req_i,        // 取指请求（保持至 addr_ok）
    input  wire [31:0] ifu_vaddr_i,      // 虚地址（VIPT 索引）
    input  wire [31:0] ifu_paddr_i,      // 物理地址（tag 比对）
    input  wire        ifu_uncached_i,   // 非缓存取指
    output wire        ifu_addr_ok_o,    // 请求被接收
    output wire        ifu_data_ok_o,    // 整行数据有效（一拍）
    output wire [`CACHE_LINE_BITS-1:0] ifu_rline_o, // 整行指令数据
    input  wire        ifu_cancel_i,     // 冲刷：作废在途请求/返回（本实现忽略）

    // ---------------- cache 维护口（commit 提交级驱动）----------------
    input  wire        cacop_en_i,
    input  wire [1:0]  cacop_op_i,       // `CACOP_OP_IDX_INV / HIT_INV
    input  wire [31:0] cacop_addr_i,     // 物理地址

    // ---------------- 下层 L2 接口（原样保留）----------------
    output wire        axi_rd_req,
    output wire [2:0]  axi_rd_type,
    output wire [31:0] axi_rd_addr,
    input  wire        axi_rd_rdy,
    input  wire        axi_ret_valid,
    input  wire        axi_ret_last,
    input  wire [127:0] axi_ret_data
);

localparam NWAY  = `L1_NWAY;
localparam NSET  = `L1_NSET;
localparam IDXW  = `L1_INDEX_W;
localparam TAGW  = `L1_TAG_W;
localparam LINEW = `CACHE_LINE_BITS;

localparam S_IDLE     = 3'd0;
localparam S_LOOKUP   = 3'd1;
localparam S_RREQ     = 3'd2;
localparam S_RDATA    = 3'd3;
localparam S_RESP     = 3'd4;
localparam S_UC_RREQ  = 3'd5;
localparam S_UC_RDATA = 3'd6;

reg [2:0] state;

// ---------------- 存储阵列 ----------------
reg [NSET-1:0] valid_arr [0:NWAY-1];
reg [TAGW-1:0] tag_arr   [0:NWAY-1][0:NSET-1];   // LUTRAM

wire [LINEW-1:0] data_out [0:NWAY-1];
reg  [IDXW-1:0]  ram_addr;
reg  [NWAY-1:0]  ram_we;
reg  [LINEW-1:0] ram_wline;
wire             ram_re;

// ---------------- 请求锁存 ----------------
reg [31:0] req_paddr;
reg        req_uncached;

// cacop 暂存
reg        cacop_pend;
reg [1:0]  cacop_pend_op;
reg [31:0] cacop_pend_addr;

reg [1:0]        victim_way;
reg [127:0]      refill_b0;
reg [LINEW-1:0]  resp_line;
reg [2:0]        uc_word;            // uncached 当前取的字偏移
reg [LINEW-1:0]  uc_line;

wire [IDXW-1:0] req_set = req_paddr[IDXW+`CACHE_LINE_W-1:`CACHE_LINE_W];
wire [TAGW-1:0] req_tag = req_paddr[31:IDXW+`CACHE_LINE_W];

// ---------------- 命中判定 ----------------
wire [NWAY-1:0] way_hit;
genvar gw;
generate
for (gw = 0; gw < NWAY; gw = gw + 1) begin : gen_hit
    assign way_hit[gw] = valid_arr[gw][req_set] && (tag_arr[gw][req_set] == req_tag);
end
endgenerate
wire       hit_any = |way_hit;
wire [1:0] hit_way = way_hit[1] ? 2'd1 : way_hit[2] ? 2'd2 : way_hit[3] ? 2'd3 : 2'd0;

// victim：无效路优先，否则轮转
reg [1:0] rr_ptr [0:NSET-1];
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

// cacop set/way 解码
wire [IDXW-1:0] cac_set = req_paddr[IDXW+`CACHE_LINE_W-1:`CACHE_LINE_W];
wire [1:0]      cac_way = req_paddr[1:0];

// ---------------- 接受仲裁 ----------------
wire cacop_take = (state == S_IDLE) && cacop_pend;
wire req_take   = (state == S_IDLE) && !cacop_pend && ifu_req_i;
assign ifu_addr_ok_o = req_take;

reg req_is_cacop;
reg [1:0] req_cacop_op;

// ---------------- 响应 ----------------
wire lookup_hit = (state == S_LOOKUP) && !req_is_cacop && !req_uncached && hit_any;
assign ifu_data_ok_o = lookup_hit | (state == S_RESP);
assign ifu_rline_o   = lookup_hit ? data_out[hit_way] : resp_line;

// ---------------- L2 接口 ----------------
assign axi_rd_req  = (state == S_RREQ) || (state == S_UC_RREQ);
assign axi_rd_type = (state == S_RREQ) ? 3'b100 : 3'b010;
assign axi_rd_addr = (state == S_RREQ) ? {req_paddr[31:`CACHE_LINE_W], {`CACHE_LINE_W{1'b0}}}
                                       : {req_paddr[31:`CACHE_LINE_W], uc_word, 2'b00};

// ---------------- BRAM ----------------
wire [IDXW-1:0] rd_set_idle = cacop_take ? cacop_pend_addr[IDXW+`CACHE_LINE_W-1:`CACHE_LINE_W]
                                         : ifu_vaddr_i[IDXW+`CACHE_LINE_W-1:`CACHE_LINE_W];
assign ram_re = cacop_take || req_take;

wire [LINEW-1:0] refill_line = {axi_ret_data, refill_b0};
wire refill_wr = (state == S_RDATA) && axi_ret_valid && axi_ret_last;

always @(*) begin
    ram_we    = {NWAY{1'b0}};
    ram_addr  = rd_set_idle;
    ram_wline = refill_line;
    if (refill_wr) begin
        ram_we[victim_way] = 1'b1;
        ram_addr           = req_set;
    end
end

genvar gr;
generate
for (gr = 0; gr < NWAY; gr = gr + 1) begin : gen_iram
    icache_way_ram u_way_ram(
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
        for (s = 0; s < NWAY; s = s + 1)
            valid_arr[s] <= {NSET{1'b0}};
    end else begin
        if (cacop_en_i) begin
            cacop_pend      <= 1'b1;
            cacop_pend_op   <= cacop_op_i;
            cacop_pend_addr <= cacop_addr_i;
        end

        case (state)
            S_IDLE: begin
                if (cacop_take) begin
                    req_is_cacop <= 1'b1;
                    req_cacop_op <= cacop_pend_op;
                    req_paddr    <= cacop_pend_addr;
                    cacop_pend   <= 1'b0;
                    state        <= S_LOOKUP;
                end else if (req_take) begin
                    req_is_cacop <= 1'b0;
                    req_paddr    <= ifu_paddr_i;
                    req_uncached <= ifu_uncached_i;
                    state        <= S_LOOKUP;
                end
            end

            S_LOOKUP: begin
                if (req_is_cacop) begin
                    // I$ 无脏行：三种 cacop 都是无效化，一拍完成
                    if (req_cacop_op == `CACOP_OP_HIT_WB) begin
                        if (hit_any) valid_arr[hit_way][req_set] <= 1'b0;
                    end else begin
                        valid_arr[cac_way][cac_set] <= 1'b0;
                    end
                    state <= S_IDLE;
                end else if (req_uncached) begin
                    uc_word <= req_paddr[4:2];
                    uc_line <= {LINEW{1'b0}};
                    state   <= S_UC_RREQ;
                end else if (hit_any) begin
                    state <= S_IDLE;          // 本拍 data_ok + 整行输出
                end else begin
                    victim_way      <= pick_way;
                    rr_ptr[req_set] <= rr_ptr[req_set] + 2'd1;
                    state           <= S_RREQ;
                end
            end

            S_RREQ: if (axi_rd_rdy) state <= S_RDATA;
            S_RDATA: begin
                if (axi_ret_valid) begin
                    if (axi_ret_last) begin
                        tag_arr[victim_way][req_set]   <= req_tag;
                        valid_arr[victim_way][req_set] <= 1'b1;
                        resp_line <= refill_line;
                        state     <= S_RESP;
                    end else begin
                        refill_b0 <= axi_ret_data;
                    end
                end
            end
            S_RESP: state <= S_IDLE;

            // uncached：逐字读到行末
            S_UC_RREQ: if (axi_rd_rdy) state <= S_UC_RDATA;
            S_UC_RDATA: begin
                if (axi_ret_valid) begin
                    uc_line[32*uc_word +: 32] <= axi_ret_data[31:0];
                    if (uc_word == 3'd7) begin
                        resp_line <= uc_line | ({{(LINEW-32){1'b0}}, axi_ret_data[31:0]} << (32*uc_word));
                        state     <= S_RESP;
                    end else begin
                        uc_word <= uc_word + 3'd1;
                        state   <= S_UC_RREQ;
                    end
                end
            end

            default: state <= S_IDLE;
        endcase
    end
end

integer ri;
initial begin
    for (ri = 0; ri < NSET; ri = ri + 1) rr_ptr[ri] = 2'b0;
end

// lint 吸收
wire icache_lint = ifu_cancel_i;

endmodule

// ------------------------------------------------------------
// icache_way_ram：单口同步 RAM 模板（128 x 256b，推断 BRAM）
// ------------------------------------------------------------
module icache_way_ram(
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