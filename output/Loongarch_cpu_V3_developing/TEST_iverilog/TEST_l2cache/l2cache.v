`include "mycpu.h"

// ============================================================
// l2cache 模块（L2 统一缓存：I$/D$ 共享的第二级缓存）
// ------------------------------------------------------------
// 功能（新架构下端口与接入方式不变）：
// - 上游：icache 的 axi_ic_* 读口 + dcache 的 axi_dc_* 读/写口；
// - 下游：mem_* 接 axi_line_bridge 转 AXI；
// - 仲裁：D$ 写 > D$ 读 > I$ 读（读口 round-robin）。
//
//TODO: 保留复用 + 以下改造/优化点：
//      1) 行大小参数化：上游 L1 行改 32B 后，rd_type/wr_type 的"行"语义
//         对应 2 拍 128bit 传输（接口已有 ret_last 支持多拍），本模块的
//         行缓冲与计数按 `CACHE_LINE_BYTES 宏改；几何参数建议扩到
//         `L2_NWAY(2) × `L2_NSET(512) × 32B = 32KB。
//      2) 重新启用预取：旧实现的 next-line 预取被 pf_can_start=1'b0 禁用
//        （与 D$ 写回有竞态）；二期修复竞态后打开，或改做"FTQ 引导的
//         I 侧预取"（收益更稳）。
//      3) victim cache（可选三期）：在 L2 旁挂 4~8 项全相联 victim buffer，
//         存 L1 被替换的行，L1 miss 时先查 victim 再查 L2。
//      4) 双 outstanding（AXI 优化二期）：I/D 读各占一个 AXI ID 并行在飞，
//         需要 bridge 配合（见 axi_line_bridge.v TODO）。
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

localparam SETS  = 512;
localparam IDX_W = 9;
localparam TAG_W = 19;

localparam TAG_VALID_BIT = 20;
localparam TAG_DIRTY_BIT = 19;

localparam S_INIT      = 3'd0;
localparam S_IDLE      = 3'd1;
localparam S_LOOKUP    = 3'd2;
localparam S_WB        = 3'd3;
localparam S_REFILL    = 3'd4;
localparam S_BYPASS_RD = 3'd5;
localparam S_BYPASS_WR = 3'd6;
localparam S_WAIT_MSHR = 3'd7;

reg [2:0]       state;
reg [IDX_W-1:0] init_set;
reg             rd_issued;
reg             rr_dc;

reg             req_is_ic;
reg             req_is_read;
reg             req_is_prefetch;
reg             req_wr_through;
reg [2:0]       req_type;
reg [31:0]      req_addr;
reg [15:0]      req_strb;
reg [127:0]     req_data;
reg [IDX_W-1:0] req_set;
reg [TAG_W-1:0] req_tag;
reg             req_way;
reg             req_hit;
reg             req_hit_way;
reg             req_way0_hit;
reg             req_way1_hit;
reg [127:0]     req_hit_line;
reg             victim_way;
reg [127:0]     victim_line;
reg [TAG_W-1:0] victim_tag;

reg             ret_valid_r;
reg             ret_is_ic_r;
reg [127:0]     ret_data_r;
reg             pf_valid;
reg [31:0]      pf_addr;

reg             pf_mshr_valid;
reg             pf_mshr_issued;
reg [31:0]      pf_mshr_addr;
reg [IDX_W-1:0] pf_mshr_set;
reg [TAG_W-1:0] pf_mshr_tag;
reg             pf_mshr_way;

reg [SETS-1:0]  lru_way1;

wire dc_rd_grant = dc_rd_req && ((ic_rd_req !== 1'b1) || (rr_dc === 1'b1));
wire ic_rd_grant = ic_rd_req && ((dc_rd_req !== 1'b1) || (rr_dc !== 1'b1));
wire pf_mshr_install = pf_mshr_valid && mem_ret_valid;
wire ram_port_busy = pf_mshr_install;
wire l2_req_idle = (state == S_IDLE) || (state == S_WAIT_MSHR);
// D$ store-buffer line writeback must not stall behind S_WAIT_MSHR or memset/boot deadlocks.
wire sel_dc_wr = l2_req_idle && (ram_port_busy !== 1'b1) && (dc_wr_req === 1'b1);
wire sel_dc_rd = (state == S_IDLE) && (ram_port_busy !== 1'b1) && (dc_wr_req !== 1'b1) && (dc_rd_grant === 1'b1);
wire sel_ic_rd = (state == S_IDLE) && (ram_port_busy !== 1'b1) && (dc_wr_req !== 1'b1) && (dc_rd_grant !== 1'b1) && (ic_rd_grant === 1'b1);

wire sel_any = sel_dc_wr || sel_dc_rd || sel_ic_rd;
wire sel_is_read = sel_ic_rd || sel_dc_rd;
wire sel_is_ic = sel_ic_rd;
wire [2:0] sel_type = sel_dc_wr ? dc_wr_type : (sel_dc_rd ? dc_rd_type : ic_rd_type);
wire [31:0] sel_addr = sel_dc_wr ? dc_wr_addr : (sel_dc_rd ? dc_rd_addr : ic_rd_addr);
wire [15:0] sel_strb = sel_dc_wr ? dc_wr_strb : 16'b0;
wire [127:0] sel_data = sel_dc_wr ? dc_wr_data : 128'b0;
wire sel_line = (sel_type == 3'b100);
wire [IDX_W-1:0] sel_set = sel_addr[IDX_W+3:4];
wire [TAG_W-1:0] sel_tag = sel_addr[31:IDX_W+4];
wire [31:0] sel_next_line_addr = {sel_addr[31:4], 4'b0000} + 32'h10;
wire sel_can_prefetch_next = sel_is_ic && sel_line && (sel_addr[11:4] != 8'hff);

wire [IDX_W-1:0] pf_set = pf_addr[IDX_W+3:4];
wire [TAG_W-1:0] pf_tag = pf_addr[31:IDX_W+4];
// Boot/Linux: disable next-line I$ prefetch MSHR to avoid S_WAIT_MSHR starving D$ writeback.
wire pf_can_start = 1'b0;

wire [IDX_W-1:0] ram_idle_set = sel_any ? sel_set : (pf_can_start ? pf_set : req_set);
wire [IDX_W-1:0] ram_addr = pf_mshr_install ? pf_mshr_set
                         : ((state == S_INIT) ? init_set
                         : ((state == S_IDLE) ? ram_idle_set : req_set));

wire [127:0] way0_data_q;
wire [127:0] way1_data_q;
wire [31:0]  way0_tagv_q;
wire [31:0]  way1_tagv_q;

wire way0_valid_q = way0_tagv_q[TAG_VALID_BIT];
wire way0_dirty_q = way0_tagv_q[TAG_DIRTY_BIT];
wire [TAG_W-1:0] way0_tag_q = way0_tagv_q[TAG_W-1:0];
wire way1_valid_q = way1_tagv_q[TAG_VALID_BIT];
wire way1_dirty_q = way1_tagv_q[TAG_DIRTY_BIT];
wire [TAG_W-1:0] way1_tag_q = way1_tagv_q[TAG_W-1:0];

wire lookup_line = (req_type == 3'b100);
wire lookup_cacheable = lookup_line && ((req_is_read === 1'b1) || (req_wr_through !== 1'b1));
wire lookup_way0_raw_hit = way0_valid_q && (way0_tag_q == req_tag);
wire lookup_way1_raw_hit = way1_valid_q && (way1_tag_q == req_tag);
wire lookup_raw_hit = lookup_way0_raw_hit || lookup_way1_raw_hit;
wire lookup_hit = lookup_cacheable && lookup_raw_hit;
wire lookup_hit_way = lookup_way1_raw_hit;
wire lookup_victim_way = (way0_valid_q !== 1'b1) ? 1'b0
                       : ((way1_valid_q !== 1'b1) ? 1'b1 : lru_way1[req_set]);
wire lookup_victim_dirty = lookup_victim_way ? (way1_valid_q && way1_dirty_q)
                                             : (way0_valid_q && way0_dirty_q);
wire [127:0] lookup_victim_line = lookup_victim_way ? way1_data_q : way0_data_q;
wire [TAG_W-1:0] lookup_victim_tag = lookup_victim_way ? way1_tag_q : way0_tag_q;
wire [127:0] lookup_hit_line = lookup_hit_way ? way1_data_q : way0_data_q;

wire lookup_read_hit = (state == S_LOOKUP) && (req_is_read === 1'b1)
                    && (req_is_prefetch !== 1'b1) && lookup_hit;
wire lookup_write_fast = (state == S_LOOKUP) && (req_is_read !== 1'b1)
                      && lookup_line && (req_wr_through !== 1'b1)
                      && (pf_mshr_valid !== 1'b1)
                      && (lookup_raw_hit || (lookup_victim_dirty !== 1'b1));

assign ic_rd_rdy = (lookup_read_hit && (req_is_ic === 1'b1))
                || ((state == S_REFILL) && (req_is_ic === 1'b1) && (req_is_prefetch !== 1'b1) && (rd_issued !== 1'b1) && mem_rd_rdy)
                || ((state == S_BYPASS_RD) && (req_is_ic === 1'b1) && (rd_issued !== 1'b1) && mem_rd_rdy);
assign dc_rd_rdy = (lookup_read_hit && (req_is_ic !== 1'b1))
                || ((state == S_REFILL) && (req_is_ic !== 1'b1) && (req_is_prefetch !== 1'b1) && (rd_issued !== 1'b1) && mem_rd_rdy)
                || ((state == S_BYPASS_RD) && (req_is_ic !== 1'b1) && (rd_issued !== 1'b1) && mem_rd_rdy);
assign dc_wr_rdy = lookup_write_fast
                || ((state == S_WB) && (req_is_read !== 1'b1) && (req_wr_through !== 1'b1) && mem_wr_rdy)
                || ((state == S_BYPASS_WR) && mem_wr_rdy);

assign ic_ret_valid = ret_valid_r && ret_is_ic_r;
assign ic_ret_last  = ic_ret_valid;
assign ic_ret_data  = ret_data_r;
assign dc_ret_valid = ret_valid_r && !ret_is_ic_r;
assign dc_ret_last  = dc_ret_valid;
assign dc_ret_data  = ret_data_r;

wire blocking_rd_req = ((state == S_REFILL) || (state == S_BYPASS_RD)) && (rd_issued !== 1'b1);
wire mshr_rd_req = pf_mshr_valid && (pf_mshr_issued !== 1'b1);
wire use_mshr_rd = (blocking_rd_req !== 1'b1) && mshr_rd_req;

assign mem_rd_req  = blocking_rd_req || use_mshr_rd;
assign mem_rd_type = use_mshr_rd ? 3'b100 : req_type;
assign mem_rd_addr = use_mshr_rd ? {pf_mshr_addr[31:4], 4'b0000}
                   : ((state == S_REFILL) ? {req_addr[31:4], 4'b0000} : req_addr);

assign mem_wr_req  = (state == S_WB) || (state == S_BYPASS_WR);
assign mem_wr_type = (state == S_WB) ? 3'b100 : req_type;
assign mem_wr_addr = (state == S_WB) ? {victim_tag, req_set, 4'b0000} : req_addr;
assign mem_wr_strb = (state == S_WB) ? 16'hffff : req_strb;
assign mem_wr_data = (state == S_WB) ? victim_line : req_data;

wire l2_hit_event = (state == S_LOOKUP) && (req_is_prefetch !== 1'b1)
                 && lookup_cacheable && lookup_raw_hit;
wire l2_miss_event = (state == S_LOOKUP) && (req_is_prefetch !== 1'b1)
                  && lookup_cacheable && (lookup_raw_hit !== 1'b1);
wire l2_refill_event = ((state == S_REFILL) && mem_ret_valid) || pf_mshr_install;
wire l2_wb_event = (state == S_WB) && mem_wr_rdy;
wire l2_bypass_rd_event = (state == S_BYPASS_RD) && mem_ret_valid;
wire l2_bypass_wr_event = (state == S_BYPASS_WR) && mem_wr_rdy;
wire l2_prefetch_hit_event = (state == S_LOOKUP) && (req_is_prefetch === 1'b1) && lookup_raw_hit;
wire l2_prefetch_req_event = (state == S_LOOKUP) && (req_is_prefetch === 1'b1) && (lookup_raw_hit !== 1'b1);
wire l2_prefetch_fill_event = ((state == S_REFILL) && (req_is_prefetch === 1'b1) && mem_ret_valid)
                            || pf_mshr_install;
wire l2_mshr_alloc_event = (state == S_LOOKUP) && (req_is_prefetch === 1'b1)
                         && lookup_line && (lookup_raw_hit !== 1'b1)
                         && (lookup_victim_dirty !== 1'b1);
wire l2_mshr_hit_event = (state == S_LOOKUP) && (pf_mshr_valid === 1'b1)
                      && (req_is_read === 1'b1) && (req_is_prefetch !== 1'b1) && lookup_hit;
wire l2_mshr_fill_event = pf_mshr_install;

function [127:0] merge_line;
    input [127:0] old_line;
    input [127:0] new_line;
    input [15:0] strb;
    integer b;
    begin
        merge_line = old_line;
        for (b = 0; b < 16; b = b + 1) begin
            if (strb[b]) begin
                merge_line[b*8 +: 8] = new_line[b*8 +: 8];
            end
        end
    end
endfunction

function [31:0] make_tagv;
    input [TAG_W-1:0] tag;
    input             dirty;
    begin
        make_tagv = {11'b0, 1'b1, dirty, tag};
    end
endfunction

wire lookup_install_way = lookup_raw_hit ? lookup_hit_way : lookup_victim_way;
wire [127:0] lookup_install_data = lookup_raw_hit ? merge_line(lookup_hit_line, req_data, req_strb) : req_data;
wire wb_store_install = (state == S_WB) && mem_wr_rdy && (req_is_read !== 1'b1) && (req_wr_through !== 1'b1);
wire refill_install = (state == S_REFILL) && mem_ret_valid;
wire mshr_refill_install = pf_mshr_install;
wire bypass_line_update = (state == S_BYPASS_WR) && mem_wr_rdy && (req_type == 3'b100) && req_hit;
wire bypass_line_inval = (state == S_BYPASS_WR) && mem_wr_rdy && (req_type != 3'b100) && req_hit;

wire line_install_valid = mshr_refill_install || lookup_write_fast || wb_store_install || refill_install || bypass_line_update;
wire line_install_way = mshr_refill_install ? pf_mshr_way
                     : (lookup_write_fast ? lookup_install_way
                     : (wb_store_install ? req_way
                     : (refill_install ? req_way : req_hit_way)));
wire [TAG_W-1:0] line_install_tag = mshr_refill_install ? pf_mshr_tag : req_tag;
wire line_install_dirty = (lookup_write_fast || wb_store_install);
wire [127:0] line_install_data = mshr_refill_install ? mem_ret_data
                               : (lookup_write_fast ? lookup_install_data
                               : (wb_store_install ? req_data
                               : (refill_install ? mem_ret_data
                               : merge_line(req_hit_line, req_data, req_strb))));

wire init_tag_write = (state == S_INIT);
wire way0_line_write = line_install_valid && (line_install_way !== 1'b1);
wire way1_line_write = line_install_valid && (line_install_way === 1'b1);
wire way0_tag_clear = init_tag_write || (bypass_line_inval && req_way0_hit);
wire way1_tag_clear = init_tag_write || (bypass_line_inval && req_way1_hit);

wire [15:0] way0_data_we = way0_line_write ? 16'hffff : 16'h0000;
wire [15:0] way1_data_we = way1_line_write ? 16'hffff : 16'h0000;
wire [3:0] way0_tag_we = (way0_tag_clear || way0_line_write) ? 4'hf : 4'h0;
wire [3:0] way1_tag_we = (way1_tag_clear || way1_line_write) ? 4'hf : 4'h0;
wire [31:0] tag_write_data = make_tagv(line_install_tag, line_install_dirty);
wire [31:0] way0_tag_din = way0_line_write ? tag_write_data : 32'b0;
wire [31:0] way1_tag_din = way1_line_write ? tag_write_data : 32'b0;

l2_way0_data_ram u_l2_way0_data_ram (
    .clka(clk),
    .ena(1'b1),
    .wea(way0_data_we),
    .addra(ram_addr),
    .dina(line_install_data),
    .douta(way0_data_q)
);

l2_way1_data_ram u_l2_way1_data_ram (
    .clka(clk),
    .ena(1'b1),
    .wea(way1_data_we),
    .addra(ram_addr),
    .dina(line_install_data),
    .douta(way1_data_q)
);

l2_way0_tag_ram u_l2_way0_tag_ram (
    .clka(clk),
    .ena(1'b1),
    .wea(way0_tag_we),
    .addra(ram_addr),
    .dina(way0_tag_din),
    .douta(way0_tagv_q)
);

l2_way1_tag_ram u_l2_way1_tag_ram (
    .clka(clk),
    .ena(1'b1),
    .wea(way1_tag_we),
    .addra(ram_addr),
    .dina(way1_tag_din),
    .douta(way1_tagv_q)
);

always @(posedge clk) begin
    if (!resetn) begin
        state <= S_INIT;
        init_set <= {IDX_W{1'b0}};
        rd_issued <= 1'b0;
        rr_dc <= 1'b0;
        req_is_ic <= 1'b0;
        req_is_read <= 1'b0;
        req_is_prefetch <= 1'b0;
        req_wr_through <= 1'b0;
        req_type <= 3'b0;
        req_addr <= 32'b0;
        req_strb <= 16'b0;
        req_data <= 128'b0;
        req_set <= {IDX_W{1'b0}};
        req_tag <= {TAG_W{1'b0}};
        req_way <= 1'b0;
        req_hit <= 1'b0;
        req_hit_way <= 1'b0;
        req_way0_hit <= 1'b0;
        req_way1_hit <= 1'b0;
        req_hit_line <= 128'b0;
        victim_way <= 1'b0;
        victim_line <= 128'b0;
        victim_tag <= {TAG_W{1'b0}};
        ret_valid_r <= 1'b0;
        ret_is_ic_r <= 1'b0;
        ret_data_r <= 128'b0;
        pf_valid <= 1'b0;
        pf_addr <= 32'b0;
        pf_mshr_valid <= 1'b0;
        pf_mshr_issued <= 1'b0;
        pf_mshr_addr <= 32'b0;
        pf_mshr_set <= {IDX_W{1'b0}};
        pf_mshr_tag <= {TAG_W{1'b0}};
        pf_mshr_way <= 1'b0;
        lru_way1 <= {SETS{1'b0}};
    end else begin
        ret_valid_r <= 1'b0;
        if (use_mshr_rd && mem_rd_rdy) begin
            pf_mshr_issued <= 1'b1;
        end
        if (pf_mshr_install) begin
            pf_mshr_valid <= 1'b0;
            pf_mshr_issued <= 1'b0;
            if (pf_mshr_way) begin
                lru_way1[pf_mshr_set] <= 1'b0;
            end else begin
                lru_way1[pf_mshr_set] <= 1'b1;
            end
        end

        case (state)
            S_INIT: begin
                init_set <= init_set + {{(IDX_W-1){1'b0}}, 1'b1};
                if (init_set == {IDX_W{1'b1}}) begin
                    state <= S_IDLE;
                end
            end

            S_IDLE: begin
                if (sel_any) begin
                    req_is_ic <= sel_is_ic;
                    req_is_read <= sel_is_read;
                    req_is_prefetch <= 1'b0;
                    req_wr_through <= sel_dc_wr && ((dc_wr_cacop === 1'b1) || (sel_line !== 1'b1));
                    req_type <= sel_type;
                    req_addr <= sel_addr;
                    req_strb <= sel_strb;
                    req_data <= sel_data;
                    req_set <= sel_set;
                    req_tag <= sel_tag;
                    req_way <= 1'b0;
                    req_hit <= 1'b0;
                    req_hit_way <= 1'b0;
                    req_way0_hit <= 1'b0;
                    req_way1_hit <= 1'b0;
                    req_hit_line <= 128'b0;
                    victim_way <= 1'b0;
                    victim_line <= 128'b0;
                    victim_tag <= {TAG_W{1'b0}};
                    if (pf_valid && sel_line && (pf_addr[31:4] == sel_addr[31:4])) begin
                        pf_valid <= 1'b0;
                    end

                    if (sel_ic_rd) begin
                        rr_dc <= 1'b1;
                    end else if (sel_dc_rd) begin
                        rr_dc <= 1'b0;
                    end

                    state <= S_LOOKUP;
                end else if (pf_can_start) begin
                    req_is_ic <= 1'b1;
                    req_is_read <= 1'b1;
                    req_is_prefetch <= 1'b1;
                    req_wr_through <= 1'b0;
                    req_type <= 3'b100;
                    req_addr <= pf_addr;
                    req_strb <= 16'b0;
                    req_data <= 128'b0;
                    req_set <= pf_set;
                    req_tag <= pf_tag;
                    req_way <= 1'b0;
                    req_hit <= 1'b0;
                    req_hit_way <= 1'b0;
                    req_way0_hit <= 1'b0;
                    req_way1_hit <= 1'b0;
                    req_hit_line <= 128'b0;
                    victim_way <= 1'b0;
                    victim_line <= 128'b0;
                    victim_tag <= {TAG_W{1'b0}};
                    rd_issued <= 1'b0;
                    pf_valid <= 1'b0;
                    state <= S_LOOKUP;
                end
            end

            S_LOOKUP: begin
                req_way <= lookup_raw_hit ? lookup_hit_way : lookup_victim_way;
                req_hit <= lookup_raw_hit;
                req_hit_way <= lookup_hit_way;
                req_way0_hit <= lookup_way0_raw_hit;
                req_way1_hit <= lookup_way1_raw_hit;
                req_hit_line <= lookup_hit_line;
                victim_way <= lookup_victim_way;
                victim_line <= lookup_victim_line;
                victim_tag <= lookup_victim_tag;

                if (req_is_read && lookup_line && lookup_hit) begin
                    if (req_is_prefetch !== 1'b1) begin
                        ret_valid_r <= 1'b1;
                        ret_is_ic_r <= req_is_ic;
                        ret_data_r <= lookup_hit_line;
                        if ((req_is_ic === 1'b1) && (req_addr[11:4] != 8'hff)) begin
                            pf_valid <= 1'b1;
                            pf_addr <= {req_addr[31:4], 4'b0000} + 32'h10;
                        end
                    end
                    if (lookup_hit_way) begin
                        lru_way1[req_set] <= 1'b0;
                    end else begin
                        lru_way1[req_set] <= 1'b1;
                    end
                    req_is_prefetch <= 1'b0;
                    state <= S_IDLE;
                    end else if (req_is_read && lookup_line) begin
                    rd_issued <= 1'b0;
                    if (pf_mshr_valid === 1'b1) begin
                        state <= S_WAIT_MSHR;
                    end else begin
                        state <= (lookup_victim_dirty === 1'b1) ? S_WB : S_REFILL;
                    end
                end else if (req_is_read) begin
                    rd_issued <= 1'b0;
                    state <= (pf_mshr_valid === 1'b1) ? S_WAIT_MSHR : S_BYPASS_RD;
                end else if (lookup_line && (req_wr_through !== 1'b1)) begin
                    if (pf_mshr_valid === 1'b1) begin
                        state <= S_WAIT_MSHR;
                    end else if (lookup_raw_hit || (lookup_victim_dirty !== 1'b1)) begin
                        if (lookup_install_way) begin
                            lru_way1[req_set] <= 1'b0;
                        end else begin
                            lru_way1[req_set] <= 1'b1;
                        end
                        state <= S_IDLE;
                    end else begin
                        state <= S_WB;
                    end
                end else begin
                    state <= (pf_mshr_valid === 1'b1) ? S_WAIT_MSHR : S_BYPASS_WR;
                end
            end

            S_WB: begin
                if (mem_wr_rdy) begin
                    if (req_is_read) begin
                        rd_issued <= 1'b0;
                        state <= S_REFILL;
                    end else begin
                        if (req_way) begin
                            lru_way1[req_set] <= 1'b0;
                        end else begin
                            lru_way1[req_set] <= 1'b1;
                        end
                        state <= S_IDLE;
                    end
                end
            end

            S_REFILL: begin
                if ((rd_issued !== 1'b1) && mem_rd_rdy) begin
                    rd_issued <= 1'b1;
                end
                if (mem_ret_valid) begin
                    if (req_way) begin
                        lru_way1[req_set] <= 1'b0;
                    end else begin
                        lru_way1[req_set] <= 1'b1;
                    end
                    if (req_is_prefetch !== 1'b1) begin
                        ret_valid_r <= 1'b1;
                        ret_is_ic_r <= req_is_ic;
                        ret_data_r <= mem_ret_data;
                        if ((req_is_ic === 1'b1) && (req_type == 3'b100) && (req_addr[11:4] != 8'hff)) begin
                            pf_valid <= 1'b1;
                            pf_addr <= {req_addr[31:4], 4'b0000} + 32'h10;
                        end
                    end
                    req_is_prefetch <= 1'b0;
                    rd_issued <= 1'b0;
                    state <= S_IDLE;
                end
            end

            S_BYPASS_RD: begin
                if ((rd_issued !== 1'b1) && mem_rd_rdy) begin
                    rd_issued <= 1'b1;
                end
                if (mem_ret_valid) begin
                    ret_valid_r <= 1'b1;
                    ret_is_ic_r <= req_is_ic;
                    ret_data_r <= mem_ret_data;
                    rd_issued <= 1'b0;
                    state <= S_IDLE;
                end
            end

            S_BYPASS_WR: begin
                if (mem_wr_rdy) begin
                    if (req_type != 3'b100) begin
                        if (pf_valid && (pf_addr[31:4] == req_addr[31:4])) begin
                            pf_valid <= 1'b0;
                        end
                    end
                    state <= S_IDLE;
                end
            end

            S_WAIT_MSHR: begin
                if (sel_dc_wr) begin
                    req_is_ic <= 1'b0;
                    req_is_read <= 1'b0;
                    req_is_prefetch <= 1'b0;
                    req_wr_through <= 1'b0;
                    req_type <= dc_wr_type;
                    req_addr <= dc_wr_addr;
                    req_strb <= dc_wr_strb;
                    req_data <= dc_wr_data;
                    req_set <= dc_wr_addr[IDX_W+3:4];
                    req_tag <= dc_wr_addr[31:IDX_W+4];
                    req_way <= 1'b0;
                    victim_tag <= dc_wr_addr[31:IDX_W+4];
                    victim_line <= dc_wr_data;
                    state <= (dc_wr_type == 3'b100) ? S_WB : S_BYPASS_WR;
                end else if ((pf_mshr_valid !== 1'b1) || pf_mshr_install) begin
                    state <= S_IDLE;
                end
            end

            default: begin
                state <= S_INIT;
                init_set <= {IDX_W{1'b0}};
                rd_issued <= 1'b0;
                req_is_prefetch <= 1'b0;
            end
        endcase
    end
end

endmodule
