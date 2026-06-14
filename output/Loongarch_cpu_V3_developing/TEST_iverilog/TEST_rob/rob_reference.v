// ============================================================
// rob 模块（重排序缓冲：奇偶双体环形队列，队列式重命名的核心）
// ------------------------------------------------------------
// 参考实现说明（mariver 同款设计）：
// - 32 项平铺存储，编号 = {奇偶位(槽位), 对指针}；恒成对分配；
// - 满判据 head == tail + `ROB_GUARD（5 对安全间距，保证已提交项的
//   result 在 dispatch 读口仍可读，绝不可省）；
// - 4 路 FU 写回口并行写动态区；dispatch 4 读口带同拍写回旁路；
// - NOP 消除：分配时 is_nop 直接 complete；
// - head_robid0_o 编码约定（与 lsu 配合的 uncached 许可）：
//   [`ROB_PAIR_W-1:0] = head 对指针；[`ROB_W-1] = 队头槽 0 是否仍未提交
//   （1=槽0还在，0=槽0已提交/无效）。lsu 据此判断"自己是最老未提交指令"。
// ============================================================
`include "mycpu.h"

module rob(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,            // 全局冲刷：head/tail/valid 全清

    // =============== 分配口（rename，恒成对） ===============
    input  wire                       alloc_en_i,         // 本拍分配一对
    output wire [`ROB_PAIR_W-1:0]     rob_tail_o,         // 当前队尾对指针
    output wire                       rob_full_o,         // 满（含安全间距）
    output wire                       rob_empty_o,

    // ---- 槽 0 静态信息 ----
    input  wire                       a0_valid_i,
    input  wire [31:0]                a0_pc_i,
    input  wire [31:0]                a0_inst_i,
    input  wire                       a0_rf_we_i,
    input  wire [4:0]                 a0_rd_i,
    input  wire [`FU_NUM-1:0]         a0_futype_i,
    input  wire                       a0_is_load_i,
    input  wire                       a0_is_store_i,
    input  wire                       a0_is_branch_i,
    input  wire [`BR_TYPE_W-1:0]      a0_br_type_i,
    input  wire                       a0_pred_taken_i,
    input  wire                       a0_is_last_i,
    input  wire [`FTQ_W-1:0]          a0_ftq_id_i,
    input  wire [`PRIV_NUM-1:0]       a0_priv_vec_i,
    input  wire [13:0]                a0_csr_num_i,
    input  wire [`TLB_OP_NUM-1:0]     a0_tlb_op_i,        // TLB 维护类型（提交级落地）
    input  wire [4:0]                 a0_cacop_code_i,
    input  wire [`EXCP_NUM-1:0]       a0_excp_i,          // 静态异常（取指/译码）
    input  wire                       a0_is_nop_i,

    // ---- 槽 1 静态信息 ----
    input  wire                       a1_valid_i,
    input  wire [31:0]                a1_pc_i,
    input  wire [31:0]                a1_inst_i,
    input  wire                       a1_rf_we_i,
    input  wire [4:0]                 a1_rd_i,
    input  wire [`FU_NUM-1:0]         a1_futype_i,
    input  wire                       a1_is_load_i,
    input  wire                       a1_is_store_i,
    input  wire                       a1_is_branch_i,
    input  wire [`BR_TYPE_W-1:0]      a1_br_type_i,
    input  wire                       a1_pred_taken_i,
    input  wire                       a1_is_last_i,
    input  wire [`FTQ_W-1:0]          a1_ftq_id_i,
    input  wire [`PRIV_NUM-1:0]       a1_priv_vec_i,
    input  wire [13:0]                a1_csr_num_i,
    input  wire [`TLB_OP_NUM-1:0]     a1_tlb_op_i,
    input  wire [4:0]                 a1_cacop_code_i,
    input  wire [`EXCP_NUM-1:0]       a1_excp_i,
    input  wire                       a1_is_nop_i,

    // =============== dispatch 操作数读口 ×4（组合，带同拍写回旁路） ===============
    input  wire [`ROB_W-1:0]          raddr0_i,
    output wire                       rrdy0_o,            // 该编号已写回（含本拍正在写回）
    output wire [31:0]                rdata0_o,
    input  wire [`ROB_W-1:0]          raddr1_i,
    output wire                       rrdy1_o,
    output wire [31:0]                rdata1_o,
    input  wire [`ROB_W-1:0]          raddr2_i,
    output wire                       rrdy2_o,
    output wire [31:0]                rdata2_o,
    input  wire [`ROB_W-1:0]          raddr3_i,
    output wire                       rrdy3_o,
    output wire [31:0]                rdata3_o,

    // =============== FU 写回口 ×4 ===============
    // ---- fu_alu0 ----
    input  wire                       alu0_wb_valid_i,
    input  wire [`ROB_W-1:0]          alu0_wb_robid_i,
    input  wire [31:0]                alu0_wb_data_i,
    input  wire                       alu0_wb_br_taken_i,
    input  wire [31:0]                alu0_wb_br_target_i,
    // ---- fu_alu1 ----
    input  wire                       alu1_wb_valid_i,
    input  wire [`ROB_W-1:0]          alu1_wb_robid_i,
    input  wire [31:0]                alu1_wb_data_i,
    input  wire                       alu1_wb_br_taken_i,
    input  wire [31:0]                alu1_wb_br_target_i,
    // ---- lsu ----
    input  wire                       mem_wb_valid_i,
    input  wire [`ROB_W-1:0]          mem_wb_robid_i,
    input  wire [31:0]                mem_wb_data_i,
    input  wire [31:0]                mem_wb_paddr_i,
    input  wire [31:0]                mem_wb_vaddr_i,
    input  wire [3:0]                 mem_wb_wstrb_i,
    input  wire [2:0]                 mem_wb_size_i,
    input  wire                       mem_wb_uncached_i,
    input  wire [`EXCP_NUM-1:0]       mem_wb_excp_i,      // 动态异常（与静态按位或）
    // ---- fu_mdu ----
    input  wire                       mdu_wb_valid_i,
    input  wire [`ROB_W-1:0]          mdu_wb_robid_i,
    input  wire [31:0]                mdu_wb_data_i,
    input  wire [31:0]                mdu_wb_data2_i,     // CSR 新值 / invtlb {vppn,asid} 打包

    // RS 操作数唤醒：valid&complete 向量 + 扁平化结果总线
    output wire [`ROB_SIZE-1:0]       done_vec_o,
    output wire [32*`ROB_SIZE-1:0]    result_flat_o,

    // =============== 提交口：队头一对的全部信息 ===============
    output wire [`ROB_W-1:0]          head_robid0_o,      // 见头注编码约定（lsu uncached 许可用）
    // ---- 槽 0 ----
    output wire                       cmt0_valid_o,
    output wire                       cmt0_complete_o,
    output wire [31:0]                cmt0_pc_o,
    output wire [31:0]                cmt0_inst_o,
    output wire                       cmt0_rf_we_o,
    output wire [4:0]                 cmt0_rd_o,
    output wire [31:0]                cmt0_result_o,      // 写回 ARF 的值
    output wire [31:0]                cmt0_result2_o,     // CSR 新值/invtlb 打包/…
    output wire                       cmt0_is_load_o,
    output wire                       cmt0_is_store_o,
    output wire [31:0]                cmt0_paddr_o,
    output wire [31:0]                cmt0_vaddr_o,
    output wire [3:0]                 cmt0_wstrb_o,
    output wire [2:0]                 cmt0_size_o,
    output wire                       cmt0_uncached_o,
    output wire                       cmt0_is_branch_o,
    output wire [`BR_TYPE_W-1:0]      cmt0_br_type_o,
    output wire                       cmt0_pred_taken_o,
    output wire                       cmt0_br_taken_o,    // 实际方向（FU 写回）
    output wire [31:0]                cmt0_br_target_o,   // 实际目标
    output wire                       cmt0_is_last_o,
    output wire [`FTQ_W-1:0]          cmt0_ftq_id_o,
    output wire [`PRIV_NUM-1:0]       cmt0_priv_vec_o,
    output wire [13:0]                cmt0_csr_num_o,
    output wire [`TLB_OP_NUM-1:0]     cmt0_tlb_op_o,
    output wire [4:0]                 cmt0_cacop_code_o,
    output wire [`EXCP_NUM-1:0]       cmt0_excp_o,        // 静态|动态 合并后
    // ---- 槽 1 ----
    output wire                       cmt1_valid_o,
    output wire                       cmt1_complete_o,
    output wire [31:0]                cmt1_pc_o,
    output wire [31:0]                cmt1_inst_o,
    output wire                       cmt1_rf_we_o,
    output wire [4:0]                 cmt1_rd_o,
    output wire [31:0]                cmt1_result_o,
    output wire [31:0]                cmt1_result2_o,
    output wire                       cmt1_is_load_o,
    output wire                       cmt1_is_store_o,
    output wire [31:0]                cmt1_paddr_o,
    output wire [31:0]                cmt1_vaddr_o,
    output wire [3:0]                 cmt1_wstrb_o,
    output wire [2:0]                 cmt1_size_o,
    output wire                       cmt1_uncached_o,
    output wire                       cmt1_is_branch_o,
    output wire [`BR_TYPE_W-1:0]      cmt1_br_type_o,
    output wire                       cmt1_pred_taken_o,
    output wire                       cmt1_br_taken_o,
    output wire [31:0]                cmt1_br_target_o,
    output wire                       cmt1_is_last_o,
    output wire [`FTQ_W-1:0]          cmt1_ftq_id_o,
    output wire [`PRIV_NUM-1:0]       cmt1_priv_vec_o,
    output wire [13:0]                cmt1_csr_num_o,
    output wire [`TLB_OP_NUM-1:0]     cmt1_tlb_op_o,
    output wire [4:0]                 cmt1_cacop_code_o,
    output wire [`EXCP_NUM-1:0]       cmt1_excp_o,

    // ---- 提交推进控制（commit 仲裁结果）----
    input  wire                       cmt_pop_i,          // head++（队头对处理完毕）
    input  wire                       cmt_clear0_i,       // 槽 0 已提交（清 valid，可早于 pop）
    input  wire                       cmt_clear1_i        // 槽 1 已提交
);

// ---------------- 指针与满空 ----------------
reg [`ROB_PAIR_W-1:0] head, tail;

assign rob_tail_o  = tail;
assign rob_full_o  = (head == tail + `ROB_GUARD);   // 保留 GUARD 对安全间距
assign rob_empty_o = (head == tail);

always @(posedge clk) begin
    if (reset || flush_i) begin
        head <= {`ROB_PAIR_W{1'b0}};
        tail <= {`ROB_PAIR_W{1'b0}};
    end else begin
        if (alloc_en_i) tail <= tail + 1'b1;
        // 空队列保护：commit 的 pop 条件在"队头对全空"时恒真，这里拦下
        if (cmt_pop_i && (head != tail)) head <= head + 1'b1;
    end
end

// ---------------- 存储（32 项平铺，编号 = {槽位, 对指针}）----------------
reg                     valid    [0:`ROB_SIZE-1];
reg                     complete [0:`ROB_SIZE-1];
// 静态区
reg [31:0]              e_pc       [0:`ROB_SIZE-1];
reg [31:0]              e_inst     [0:`ROB_SIZE-1];
reg                     e_rf_we    [0:`ROB_SIZE-1];
reg [4:0]               e_rd       [0:`ROB_SIZE-1];
reg [`FU_NUM-1:0]       e_futype   [0:`ROB_SIZE-1];
reg                     e_is_load  [0:`ROB_SIZE-1];
reg                     e_is_store [0:`ROB_SIZE-1];
reg                     e_is_branch[0:`ROB_SIZE-1];
reg [`BR_TYPE_W-1:0]    e_br_type  [0:`ROB_SIZE-1];
reg                     e_pred_tk  [0:`ROB_SIZE-1];
reg                     e_is_last  [0:`ROB_SIZE-1];
reg [`FTQ_W-1:0]        e_ftq_id   [0:`ROB_SIZE-1];
reg [`PRIV_NUM-1:0]     e_priv     [0:`ROB_SIZE-1];
reg [13:0]              e_csr_num  [0:`ROB_SIZE-1];
reg [`TLB_OP_NUM-1:0]   e_tlb_op   [0:`ROB_SIZE-1];
reg [4:0]               e_cacop    [0:`ROB_SIZE-1];
reg [`EXCP_NUM-1:0]     e_excp_s   [0:`ROB_SIZE-1];
// 动态区
reg [31:0]              e_result   [0:`ROB_SIZE-1];
reg [31:0]              e_result2  [0:`ROB_SIZE-1];
reg [31:0]              e_paddr    [0:`ROB_SIZE-1];
reg [31:0]              e_vaddr    [0:`ROB_SIZE-1];
reg [3:0]               e_wstrb    [0:`ROB_SIZE-1];
reg [2:0]               e_size     [0:`ROB_SIZE-1];
reg                     e_uncached [0:`ROB_SIZE-1];
reg                     e_br_taken [0:`ROB_SIZE-1];
reg [31:0]              e_br_target[0:`ROB_SIZE-1];
reg [`EXCP_NUM-1:0]     e_excp_d   [0:`ROB_SIZE-1];

wire [`ROB_W-1:0] idx_a0 = {1'b0, tail};
wire [`ROB_W-1:0] idx_a1 = {1'b1, tail};
wire [`ROB_W-1:0] idx_h0 = {1'b0, head};
wire [`ROB_W-1:0] idx_h1 = {1'b1, head};

integer k;

// ---------------- valid / complete（分配清、写回置、提交清、冲刷全清）----------------
always @(posedge clk) begin
    if (reset || flush_i) begin
        for (k = 0; k < `ROB_SIZE; k = k + 1) begin
            valid[k]    <= 1'b0;
            complete[k] <= 1'b0;
        end
    end else begin
        // 写回置 complete（必须在分配之前，避免 tail 复用项同拍被旧 wb 误置 complete）
        if (alu0_wb_valid_i && valid[alu0_wb_robid_i]) complete[alu0_wb_robid_i] <= 1'b1;
        if (alu1_wb_valid_i && valid[alu1_wb_robid_i]) complete[alu1_wb_robid_i] <= 1'b1;
        if (mem_wb_valid_i  && valid[mem_wb_robid_i])  complete[mem_wb_robid_i]  <= 1'b1;
        if (mdu_wb_valid_i  && valid[mdu_wb_robid_i])  complete[mdu_wb_robid_i]  <= 1'b1;
        if (alloc_en_i) begin
            valid[idx_a0]    <= a0_valid_i;
            valid[idx_a1]    <= a1_valid_i;
            if (a0_valid_i)
                complete[idx_a0] <= a0_is_nop_i;
            else
                complete[idx_a0] <= 1'b1;
            if (a1_valid_i)
                complete[idx_a1] <= a1_is_nop_i;
            else
                complete[idx_a1] <= 1'b1;
        end
        // 提交清 valid（防止 head 绕回后重复提交）；e_result 保留至 tail 复写
        if (cmt_clear0_i) valid[idx_h0] <= 1'b0;
        if (cmt_clear1_i) valid[idx_h1] <= 1'b0;
    end
end

// ---------------- 静态区（分配写）----------------
always @(posedge clk) begin
    if (alloc_en_i) begin
        e_pc[idx_a0]       <= a0_pc_i;        e_pc[idx_a1]       <= a1_pc_i;
        e_inst[idx_a0]     <= a0_inst_i;      e_inst[idx_a1]     <= a1_inst_i;
        e_rf_we[idx_a0]    <= a0_rf_we_i;     e_rf_we[idx_a1]    <= a1_rf_we_i;
        e_rd[idx_a0]       <= a0_rd_i;        e_rd[idx_a1]       <= a1_rd_i;
        e_futype[idx_a0]   <= a0_futype_i;    e_futype[idx_a1]   <= a1_futype_i;
        e_is_load[idx_a0]  <= a0_is_load_i;   e_is_load[idx_a1]  <= a1_is_load_i;
        e_is_store[idx_a0] <= a0_is_store_i;  e_is_store[idx_a1] <= a1_is_store_i;
        e_is_branch[idx_a0]<= a0_is_branch_i; e_is_branch[idx_a1]<= a1_is_branch_i;
        e_br_type[idx_a0]  <= a0_br_type_i;   e_br_type[idx_a1]  <= a1_br_type_i;
        e_pred_tk[idx_a0]  <= a0_pred_taken_i;e_pred_tk[idx_a1]  <= a1_pred_taken_i;
        e_is_last[idx_a0]  <= a0_is_last_i;   e_is_last[idx_a1]  <= a1_is_last_i;
        e_ftq_id[idx_a0]   <= a0_ftq_id_i;    e_ftq_id[idx_a1]   <= a1_ftq_id_i;
        e_priv[idx_a0]     <= a0_priv_vec_i;  e_priv[idx_a1]     <= a1_priv_vec_i;
        e_csr_num[idx_a0]  <= a0_csr_num_i;   e_csr_num[idx_a1]  <= a1_csr_num_i;
        e_tlb_op[idx_a0]   <= a0_tlb_op_i;    e_tlb_op[idx_a1]   <= a1_tlb_op_i;
        e_cacop[idx_a0]    <= a0_cacop_code_i;e_cacop[idx_a1]    <= a1_cacop_code_i;
        e_excp_s[idx_a0]   <= a0_excp_i;      e_excp_s[idx_a1]   <= a1_excp_i;
    end
end

// ---------------- 动态区（4 路写回口各写各的；分配时清动态异常）----------------
always @(posedge clk) begin
    // 分配清动态区残留（excp_d/br_taken 防上一轮旧值）
    if (alloc_en_i) begin
        e_excp_d[idx_a0]   <= {`EXCP_NUM{1'b0}};
        e_excp_d[idx_a1]   <= {`EXCP_NUM{1'b0}};
        e_br_taken[idx_a0] <= 1'b0;
        e_br_taken[idx_a1] <= 1'b0;
        e_result[idx_a0]   <= 32'b0;
        e_result[idx_a1]   <= 32'b0;
        e_result2[idx_a0]  <= 32'b0;
        e_result2[idx_a1]  <= 32'b0;
    end
    if (alu0_wb_valid_i) begin
        e_result[alu0_wb_robid_i]    <= alu0_wb_data_i;
        e_br_taken[alu0_wb_robid_i]  <= alu0_wb_br_taken_i;
        e_br_target[alu0_wb_robid_i] <= alu0_wb_br_target_i;
    end
    if (alu1_wb_valid_i) begin
        e_result[alu1_wb_robid_i]    <= alu1_wb_data_i;
        e_br_taken[alu1_wb_robid_i]  <= alu1_wb_br_taken_i;
        e_br_target[alu1_wb_robid_i] <= alu1_wb_br_target_i;
    end
    if (mem_wb_valid_i) begin
        e_result[mem_wb_robid_i]   <= mem_wb_data_i;
        e_paddr[mem_wb_robid_i]    <= mem_wb_paddr_i;
        e_vaddr[mem_wb_robid_i]    <= mem_wb_vaddr_i;
        e_wstrb[mem_wb_robid_i]    <= mem_wb_wstrb_i;
        e_size[mem_wb_robid_i]     <= mem_wb_size_i;
        e_uncached[mem_wb_robid_i] <= mem_wb_uncached_i;
        e_excp_d[mem_wb_robid_i]   <= mem_wb_excp_i;
    end
    if (mdu_wb_valid_i) begin
        e_result[mdu_wb_robid_i]  <= mdu_wb_data_i;
        e_result2[mdu_wb_robid_i] <= mdu_wb_data2_i;
    end
end

// ---------------- dispatch 读口（组合 + 同拍写回旁路）----------------
function rob_rrdy;
    input [`ROB_W-1:0] raddr;
    begin
        rob_rrdy = (valid[raddr] && complete[raddr])
                 | (alu0_wb_valid_i && (alu0_wb_robid_i == raddr))
                 | (alu1_wb_valid_i && (alu1_wb_robid_i == raddr))
                 | (mem_wb_valid_i  && (mem_wb_robid_i  == raddr))
                 | (mdu_wb_valid_i  && (mdu_wb_robid_i  == raddr));
    end
endfunction

function [31:0] rob_rdata;
    input [`ROB_W-1:0] raddr;
    begin
        if      (alu0_wb_valid_i && (alu0_wb_robid_i == raddr)) rob_rdata = alu0_wb_data_i;
        else if (alu1_wb_valid_i && (alu1_wb_robid_i == raddr)) rob_rdata = alu1_wb_data_i;
        else if (mem_wb_valid_i  && (mem_wb_robid_i  == raddr)) rob_rdata = mem_wb_data_i;
        else if (mdu_wb_valid_i  && (mdu_wb_robid_i  == raddr)) rob_rdata = mdu_wb_data_i;
        else if (valid[raddr])                                  rob_rdata = e_result[raddr];
        else                                                    rob_rdata = 32'b0;
    end
endfunction

assign rrdy0_o  = rob_rrdy(raddr0_i);
assign rdata0_o = rob_rdata(raddr0_i);
assign rrdy1_o  = rob_rrdy(raddr1_i);
assign rdata1_o = rob_rdata(raddr1_i);
assign rrdy2_o  = rob_rrdy(raddr2_i);
assign rdata2_o = rob_rdata(raddr2_i);
assign rrdy3_o  = rob_rrdy(raddr3_i);
assign rdata3_o = rob_rdata(raddr3_i);

// ---------------- 提交口 ----------------
// 编码约定见头注：高位 = 槽 0 是否仍未提交（供 lsu 判断槽 1 uncached 许可）
assign head_robid0_o = {valid[idx_h0], head};

assign cmt0_valid_o    = valid[idx_h0];
assign cmt0_complete_o = complete[idx_h0];
assign cmt0_pc_o       = e_pc[idx_h0];
assign cmt0_inst_o     = e_inst[idx_h0];
assign cmt0_rf_we_o    = e_rf_we[idx_h0];
assign cmt0_rd_o       = e_rd[idx_h0];
assign cmt0_result_o   = e_result[idx_h0];
assign cmt0_result2_o  = e_result2[idx_h0];
assign cmt0_is_load_o  = e_is_load[idx_h0];
assign cmt0_is_store_o = e_is_store[idx_h0];
assign cmt0_paddr_o    = e_paddr[idx_h0];
assign cmt0_vaddr_o    = e_vaddr[idx_h0];
assign cmt0_wstrb_o    = e_wstrb[idx_h0];
assign cmt0_size_o     = e_size[idx_h0];
assign cmt0_uncached_o = e_uncached[idx_h0];
assign cmt0_is_branch_o= e_is_branch[idx_h0];
assign cmt0_br_type_o  = e_br_type[idx_h0];
assign cmt0_pred_taken_o = e_pred_tk[idx_h0];
assign cmt0_br_taken_o = e_br_taken[idx_h0];
assign cmt0_br_target_o= e_br_target[idx_h0];
assign cmt0_is_last_o  = e_is_last[idx_h0];
assign cmt0_ftq_id_o   = e_ftq_id[idx_h0];
assign cmt0_priv_vec_o = e_priv[idx_h0];
assign cmt0_csr_num_o  = e_csr_num[idx_h0];
assign cmt0_tlb_op_o   = e_tlb_op[idx_h0];
assign cmt0_cacop_code_o = e_cacop[idx_h0];
assign cmt0_excp_o     = e_excp_s[idx_h0] | e_excp_d[idx_h0];

assign cmt1_valid_o    = valid[idx_h1];
assign cmt1_complete_o = complete[idx_h1];
assign cmt1_pc_o       = e_pc[idx_h1];
assign cmt1_inst_o     = e_inst[idx_h1];
assign cmt1_rf_we_o    = e_rf_we[idx_h1];
assign cmt1_rd_o       = e_rd[idx_h1];
assign cmt1_result_o   = e_result[idx_h1];
assign cmt1_result2_o  = e_result2[idx_h1];
assign cmt1_is_load_o  = e_is_load[idx_h1];
assign cmt1_is_store_o = e_is_store[idx_h1];
assign cmt1_paddr_o    = e_paddr[idx_h1];
assign cmt1_vaddr_o    = e_vaddr[idx_h1];
assign cmt1_wstrb_o    = e_wstrb[idx_h1];
assign cmt1_size_o     = e_size[idx_h1];
assign cmt1_uncached_o = e_uncached[idx_h1];
assign cmt1_is_branch_o= e_is_branch[idx_h1];
assign cmt1_br_type_o  = e_br_type[idx_h1];
assign cmt1_pred_taken_o = e_pred_tk[idx_h1];
assign cmt1_br_taken_o = e_br_taken[idx_h1];
assign cmt1_br_target_o= e_br_target[idx_h1];
assign cmt1_is_last_o  = e_is_last[idx_h1];
assign cmt1_ftq_id_o   = e_ftq_id[idx_h1];
assign cmt1_priv_vec_o = e_priv[idx_h1];
assign cmt1_csr_num_o  = e_csr_num[idx_h1];
assign cmt1_tlb_op_o   = e_tlb_op[idx_h1];
assign cmt1_cacop_code_o = e_cacop[idx_h1];
assign cmt1_excp_o     = e_excp_s[idx_h1] | e_excp_d[idx_h1];

genvar gi;
generate
    for (gi = 0; gi < `ROB_SIZE; gi = gi + 1) begin : gen_rs_wake
        assign done_vec_o[gi]   = valid[gi] & complete[gi];
        assign result_flat_o[32*gi +: 32] = e_result[gi];
    end
endgenerate

endmodule
