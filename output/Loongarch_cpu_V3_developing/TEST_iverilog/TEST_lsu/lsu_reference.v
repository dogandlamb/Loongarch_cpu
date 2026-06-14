// ============================================================
// lsu 模块（访存单元：AGU + DC 两级流水）
// ------------------------------------------------------------
// 参考实现说明：
// - AGU 级：vaddr=base+imm -> MMU 组合翻译 -> ALE/TLB 异常 -> store 数据对齐；
// - DC 级：store/cacop/异常直接写回；load 先查 SB 前递，再访 DCache；
// - 顺序保护（关键正确性逻辑）：store 经 LSU 写回后要等提交才入 SB，
//   该窗口内更年轻 load 既查不到 SB 也不能读 DCache（会读到旧值）。
//   处理：记录最近一条 store 的 robid（in-order LSU 下它是所有未决 store
//   中最年轻者），load 在它提交前不发起最终 SB 查询/DCache 访问。
//   提交判定用 rob.head_robid0_o 的约定编码：
//   [`ROB_W-1]=队头槽0是否未提交，低位=head 对指针；
//   robid 对距离 d=(R-head)&15，d>=12 视为已被 head 越过（已提交）。
// - uncached load：等到自己成为最老未提交指令才发（同上编码判定），
//   期间 uncached_ld_inflight_o 置位（commit 屏蔽中断附着）。
// - 冲刷：清两级 + 在途 DCache 返回用 drop 标志丢弃。
// ============================================================
`include "mycpu.h"

module lsu(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // ---------------- 发射入口（来自 rs_mem）----------------
    input  wire                       issue_valid_i,
    input  wire [`ROB_W-1:0]          issue_robid_i,
    input  wire [31:0]                issue_pc_i,
    input  wire [`MEM_OP_NUM-1:0]     issue_mem_op_i,
    input  wire                       issue_is_cacop_i,
    input  wire [31:0]                issue_base_i,        // rj 值
    input  wire [31:0]                issue_wdata_i,       // rd 值（store 数据）
    input  wire [31:0]                issue_imm_i,         // 偏移
    output wire                       lsu_ready_o,         // AGU 级空闲

    // ---------------- D 侧地址翻译（连 mmu D 通道，组合）----------------
    output wire                       mmu_d_req_o,
    output wire [31:0]                mmu_d_vaddr_o,
    output wire                       mmu_d_is_store_o,    // 区分 PIL/PIS 与 PME
    input  wire [31:0]                mmu_d_paddr_i,
    input  wire [1:0]                 mmu_d_mat_i,
    input  wire [`TLB_EX_NUM-1:0]     mmu_d_tlb_ex_i,      // TLBR/PIL/PIS/PPI/PME
    input  wire                       mmu_d_excp_adem_i,

    // ---------------- DCache load 访问口 ----------------
    output wire                       dc_req_o,            // load 请求（保持至 addr_ok）
    output wire [31:0]                dc_vaddr_o,          // 虚地址（VIPT 索引）
    output wire [31:0]                dc_paddr_o,          // 物理地址（tag 比对）
    output wire [2:0]                 dc_size_o,           // 0=B 1=H 2=W
    output wire                       dc_uncached_o,
    input  wire                       dc_addr_ok_i,
    input  wire                       dc_data_ok_i,
    input  wire [31:0]                dc_rdata_i,
    output wire                       dc_cancel_o,         // 冲刷取消在途请求

    // ---------------- store buffer 前递查询（AGU/DC 级组合）----------------
    output wire [31:0]                sb_query_paddr_o,
    input  wire                       sb_query_hit_i,      // 全字节命中可前递
    input  wire [31:0]                sb_query_data_i,
    input  wire                       sb_query_partial_i,  // 部分命中：load 必须等 SB 排空重试

    // ---------------- uncached load 许可（与 ROB head 比较）----------------
    input  wire [`ROB_W-1:0]          rob_head_robid_i,    // 编码约定见头注
    input  wire                       rob_head_valid_i,
    output wire                       uncached_ld_inflight_o, // 有 uncached load 在飞（commit 屏蔽中断用）

    // ---------------- 写回 ROB ----------------
    output wire                       wb_valid_o,
    output wire [`ROB_W-1:0]          wb_robid_o,
    output wire [31:0]                wb_data_o,           // load 整形后数据 / store 写数据
    output wire [31:0]                wb_paddr_o,          // 访存物理地址（store/cacop/difftest 用）
    output wire [31:0]                wb_vaddr_o,          // 访存虚地址（BADV/difftest 用）
    output wire [3:0]                 wb_wstrb_o,          // store 字节使能（已按地址对齐移位）
    output wire [2:0]                 wb_size_o,           // 访问宽度
    output wire                       wb_uncached_o,       // 非缓存访问
    output wire [`EXCP_NUM-1:0]       wb_excp_o,           // 动态异常（ALE/ADEM/TLBR_M/PIL/PIS/PPI_M/PME）

    // ---------------- AGU 级投机唤醒（二期）----------------
    output wire                       early_wakeup_valid_o,
    output wire [`ROB_W-1:0]          early_wakeup_robid_o
);

// =====================================================================
// AGU 级
// =====================================================================
reg                    a_valid;
reg [`ROB_W-1:0]       a_robid;
reg [`MEM_OP_NUM-1:0]  a_mem_op;
reg                    a_is_cacop;
reg [31:0]             a_base, a_wdata, a_imm;

wire [31:0] a_vaddr = a_base + a_imm;

wire a_is_store_op = a_mem_op[`MEM_OP_ST_W] | a_mem_op[`MEM_OP_ST_B]
                   | a_mem_op[`MEM_OP_ST_H] | a_mem_op[`MEM_OP_SC_W];
wire a_is_load_op  = a_mem_op[`MEM_OP_LD_W] | a_mem_op[`MEM_OP_LD_B]
                   | a_mem_op[`MEM_OP_LD_H] | a_mem_op[`MEM_OP_LD_BU]
                   | a_mem_op[`MEM_OP_LD_HU]| a_mem_op[`MEM_OP_LL_W];

// MMU 翻译（组合）
assign mmu_d_req_o      = a_valid;
assign mmu_d_vaddr_o    = a_vaddr;
assign mmu_d_is_store_o = a_is_store_op;

wire a_uncached = (mmu_d_mat_i != 2'b01);

// ALE 检测
wire a_size_h = a_mem_op[`MEM_OP_LD_H] | a_mem_op[`MEM_OP_LD_HU] | a_mem_op[`MEM_OP_ST_H];
wire a_size_w = a_mem_op[`MEM_OP_LD_W] | a_mem_op[`MEM_OP_ST_W]
              | a_mem_op[`MEM_OP_LL_W] | a_mem_op[`MEM_OP_SC_W];
wire a_ale = (a_size_h && (a_vaddr[0] != 1'b0))
           | (a_size_w && (a_vaddr[1:0] != 2'b00));

// 异常合并（idx 类 cacop 不做地址翻译异常）
wire a_cacop_idx = a_is_cacop && 1'b0;   // 占位：cacop code 不在 LSU，统一按翻译处理
wire [`EXCP_NUM-1:0] a_excp =
      ({{(`EXCP_NUM-1){1'b0}}, a_ale}                          << `EXCP_ALE)
    | ({{(`EXCP_NUM-1){1'b0}}, mmu_d_excp_adem_i}              << `EXCP_ADEM)
    | ({{(`EXCP_NUM-1){1'b0}}, mmu_d_tlb_ex_i[`TLB_EX_TLBR]}   << `EXCP_TLBR_M)
    | ({{(`EXCP_NUM-1){1'b0}}, mmu_d_tlb_ex_i[`TLB_EX_PIL]}    << `EXCP_PIL)
    | ({{(`EXCP_NUM-1){1'b0}}, mmu_d_tlb_ex_i[`TLB_EX_PIS]}    << `EXCP_PIS)
    | ({{(`EXCP_NUM-1){1'b0}}, mmu_d_tlb_ex_i[`TLB_EX_PPI]}    << `EXCP_PPI_M)
    | ({{(`EXCP_NUM-1){1'b0}}, mmu_d_tlb_ex_i[`TLB_EX_PME]}    << `EXCP_PME);

// store 数据按地址对齐 + wstrb
wire [1:0] a_off = a_vaddr[1:0];
reg [31:0] a_st_data;
reg [3:0]  a_st_strb;
always @(*) begin
    if (a_mem_op[`MEM_OP_ST_B]) begin
        a_st_data = {4{a_wdata[7:0]}};
        a_st_strb = 4'b0001 << a_off;
    end else if (a_mem_op[`MEM_OP_ST_H]) begin
        a_st_data = {2{a_wdata[15:0]}};
        a_st_strb = a_off[1] ? 4'b1100 : 4'b0011;
    end else begin
        a_st_data = a_wdata;
        a_st_strb = 4'b1111;
    end
end

wire [2:0] a_size = a_mem_op[`MEM_OP_ST_B] | a_mem_op[`MEM_OP_LD_B] | a_mem_op[`MEM_OP_LD_BU] ? 3'd0
                  : a_mem_op[`MEM_OP_ST_H] | a_mem_op[`MEM_OP_LD_H] | a_mem_op[`MEM_OP_LD_HU] ? 3'd1
                  : 3'd2;

// =====================================================================
// DC 级
// =====================================================================
reg                    d_valid;
reg [`ROB_W-1:0]       d_robid;
reg [`MEM_OP_NUM-1:0]  d_mem_op;
reg                    d_is_cacop;
reg                    d_is_store, d_is_load;
reg [31:0]             d_vaddr, d_paddr;
reg [31:0]             d_st_data;
reg [3:0]              d_st_strb;
reg [2:0]              d_size;
reg                    d_uncached;
reg [`EXCP_NUM-1:0]    d_excp;
reg                    d_req_sent;      // DCache 已收下请求，等 data_ok
reg                    d_drop;          // 冲刷后丢弃下一个 data_ok

// ---------------- 顺序保护：最近一条未决 store ----------------
reg                  st_pend;           // 有 store 写回后尚未确认提交
reg [`ROB_W-1:0]     st_pend_robid;

wire [`ROB_PAIR_W-1:0] head_pair   = rob_head_robid_i[`ROB_PAIR_W-1:0];
wire                   head_s0_live= rob_head_robid_i[`ROB_W-1];

// robid R 已提交判定（约定编码，见头注）
function robid_committed;
    input [`ROB_W-1:0] r;
    reg [`ROB_PAIR_W-1:0] d;
    begin
        d = r[`ROB_PAIR_W-1:0] - head_pair;
        if (d >= `ROB_PAIR_W'd12)
            robid_committed = 1'b1;                      // head 已越过该对
        else if ((d == {`ROB_PAIR_W{1'b0}}) && (r[`ROB_W-1] == 1'b0) && !head_s0_live)
            robid_committed = 1'b1;                      // 槽 0 已提交
        else
            robid_committed = 1'b0;
    end
endfunction

wire st_pend_clear = st_pend && (!rob_head_valid_i || robid_committed(st_pend_robid));
wire store_order_block = st_pend && !st_pend_clear;     // 仍有未决 store

// ---------------- DC 级行为 ----------------
wire d_excp_any = |d_excp;

// SB 前递查询（DC 级持续驱动）
assign sb_query_paddr_o = d_paddr;

// uncached load 许可：自己是最老未提交指令
wire d_at_head = (d_robid[`ROB_PAIR_W-1:0] == head_pair)
              && ((d_robid[`ROB_W-1] == 1'b0) || !head_s0_live)
              && rob_head_valid_i;

wire d_is_unc_load = d_valid && d_is_load && d_uncached && !d_excp_any;
assign uncached_ld_inflight_o = d_is_unc_load;

// load 可以发起最终访问（SB 终查/DCache）的条件
// uncached load 额外等：1) 到 ROB 头；2) SB 排空 uncached 写（query_partial
// 在 SB 有 uncached 项时恒 1，保证设备"先写后读"顺序）
wire d_ld_gate = !store_order_block
              && (!d_uncached || (d_at_head && !sb_query_partial_i));

// load 处理分支
wire d_sb_hit     = d_valid && d_is_load && !d_excp_any && !d_uncached && sb_query_hit_i;
wire d_sb_partial = d_valid && d_is_load && !d_excp_any && !d_uncached && sb_query_partial_i;

wire d_need_dc = d_valid && d_is_load && !d_excp_any && !d_sb_hit && !d_sb_partial;

// DCache 请求（保持至 addr_ok）
assign dc_req_o      = d_need_dc && d_ld_gate && !d_req_sent && !d_drop && !flush_i;
assign dc_vaddr_o    = d_vaddr;
assign dc_paddr_o    = d_paddr;
assign dc_size_o     = d_size;
assign dc_uncached_o = d_uncached;
assign dc_cancel_o   = flush_i;

wire dc_fire   = dc_req_o && dc_addr_ok_i;
wire dc_return = d_req_sent && dc_data_ok_i && !d_drop;

// ---------------- load 数据整形 ----------------
function [31:0] shape_load;
    input [31:0] word;
    input [`MEM_OP_NUM-1:0] op;
    input [1:0] off;
    reg [7:0]  b;
    reg [15:0] h;
    begin
        b = word[8*off +: 8];
        h = off[1] ? word[31:16] : word[15:0];
        if (op[`MEM_OP_LD_B])       shape_load = {{24{b[7]}}, b};
        else if (op[`MEM_OP_LD_BU]) shape_load = {24'b0, b};
        else if (op[`MEM_OP_LD_H])  shape_load = {{16{h[15]}}, h};
        else if (op[`MEM_OP_LD_HU]) shape_load = {16'b0, h};
        else                        shape_load = word;
    end
endfunction

// ---------------- 写回仲裁（D 级一拍一条）----------------
// 1) 异常：直接写回；2) store/cacop：直接写回；3) load：SB 命中或 DCache 返回
wire wb_excp_case  = d_valid && d_excp_any;
wire wb_st_case    = d_valid && !d_excp_any && (d_is_store || d_is_cacop);
wire wb_ld_sb_case = d_sb_hit && d_ld_gate;
wire wb_ld_dc_case = dc_return;

assign wb_valid_o = (wb_excp_case || wb_st_case || wb_ld_sb_case || wb_ld_dc_case) && !flush_i;
assign wb_robid_o = d_robid;
assign wb_data_o  = wb_ld_sb_case ? shape_load(sb_query_data_i, d_mem_op, d_vaddr[1:0])
                  : wb_ld_dc_case ? shape_load(dc_rdata_i,      d_mem_op, d_vaddr[1:0])
                  : d_st_data;
assign wb_paddr_o = d_paddr;
assign wb_vaddr_o = d_vaddr;
assign wb_wstrb_o = (d_is_store && !d_excp_any) ? d_st_strb : 4'b0;
assign wb_size_o  = d_size;
assign wb_uncached_o = d_uncached;
assign wb_excp_o  = d_excp;

// ---------------- 流水推进 ----------------
wire d_done  = wb_valid_o;                       // D 级本拍完成
wire d_free  = !d_valid || d_done;
wire a_go    = a_valid && d_free;                // AGU -> DC
assign lsu_ready_o = (!a_valid || a_go) && !flush_i;

always @(posedge clk) begin
    if (reset) begin
        a_valid    <= 1'b0;
        d_valid    <= 1'b0;
        d_drop     <= 1'b0;
        d_req_sent <= 1'b0;
        st_pend    <= 1'b0;
    end else if (flush_i) begin
        a_valid    <= 1'b0;
        d_valid    <= 1'b0;
        // 在途 DCache 返回作废（已被接收但数据未回的请求）
        d_drop     <= d_req_sent && !dc_data_ok_i;
        d_req_sent <= 1'b0;
        st_pend    <= 1'b0;
    end else begin
        // drop 标志：等到被丢弃的 data_ok 到来后清除
        if (d_drop && dc_data_ok_i) d_drop <= 1'b0;

        // ---- 顺序保护寄存器 ----
        if (wb_st_case && d_is_store) begin
            st_pend       <= 1'b1;
            st_pend_robid <= d_robid;
        end else if (st_pend_clear) begin
            st_pend <= 1'b0;
        end

        // ---- DC 级 ----
        if (d_done) d_valid <= 1'b0;
        if (dc_fire) d_req_sent <= 1'b1;
        if (dc_return) d_req_sent <= 1'b0;

        // ---- AGU -> DC ----
        if (a_go) begin
            d_valid    <= 1'b1;
            d_robid    <= a_robid;
            d_mem_op   <= a_mem_op;
            d_is_cacop <= a_is_cacop;
            d_is_store <= a_is_store_op && !a_is_cacop;
            d_is_load  <= a_is_load_op  && !a_is_cacop;
            d_vaddr    <= a_vaddr;
            d_paddr    <= mmu_d_paddr_i;
            d_st_data  <= a_st_data;
            d_st_strb  <= a_st_strb;
            d_size     <= a_size;
            d_uncached <= a_uncached;
            d_excp     <= a_excp;
            d_req_sent <= 1'b0;
        end
        if (a_go && !issue_valid_i) a_valid <= 1'b0;

        // ---- 发射 -> AGU ----
        if (issue_valid_i && lsu_ready_o) begin
            a_valid    <= 1'b1;
            a_robid    <= issue_robid_i;
            a_mem_op   <= issue_mem_op_i;
            a_is_cacop <= issue_is_cacop_i;
            a_base     <= issue_base_i;
            a_wdata    <= issue_wdata_i;
            a_imm      <= issue_imm_i;
        end
    end
end

// 一期恒 0
assign early_wakeup_valid_o = 1'b0;
assign early_wakeup_robid_o = {`ROB_W{1'b0}};

// lint 吸收
wire lsu_lint = (|issue_pc_i) | a_cacop_idx;

endmodule
