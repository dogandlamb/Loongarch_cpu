// ============================================================
// ifu 模块（取指单元，含预译码）
// ------------------------------------------------------------
// 参考实现说明：
// - 2 段流水：PRE（收 FTQ 块 + MMU 翻译 + 发 ICache）/ IF（等返回 + 切割 + 入 IB）；
// - 取指异常整块占位（inst=0，不打 ICache）；冲刷用 drop_rsp 丢弃过期 data_ok；
// - 预译码识别 B/BL 直接跳转，漏预测时截断块并 predec_redirect；
// - ic_cancel_o 恒 0（I$ 忽略 cancel，本模块自行丢弃）。
// ============================================================
`include "mycpu.h"

module ifu(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    input  wire                       ftq_valid_i,
    input  wire [31:0]                ftq_pc_i,
    input  wire [`BLK_LEN_W-1:0]      ftq_length_i,
    input  wire                       ftq_taken_i,
    input  wire [31:0]                ftq_target_i,
    input  wire [`FTQ_W-1:0]          ftq_ftq_id_i,
    output wire                       ftq_accept_o,

    output wire                       mmu_i_req_o,
    output wire [31:0]                mmu_i_vaddr_o,
    input  wire [31:0]                mmu_i_paddr_i,
    input  wire [1:0]                 mmu_i_mat_i,
    input  wire                       mmu_i_excp_adef_i,
    input  wire [`TLB_EX_NUM-1:0]     mmu_i_tlb_ex_i,

    output wire                       ic_req_o,
    output wire [31:0]                ic_vaddr_o,
    output wire [31:0]                ic_paddr_o,
    output wire                       ic_uncached_o,
    input  wire                       ic_addr_ok_i,
    input  wire                       ic_data_ok_i,
    input  wire [`CACHE_LINE_BITS-1:0] ic_rline_i,
    output wire                       ic_cancel_o,

    output wire                       predec_redirect_o,
    output wire [31:0]                predec_redirect_pc_o,
    output wire [`FTQ_W-1:0]          predec_redirect_id_o,
    output wire [`BLK_LEN_W-1:0]      predec_length_o,
    output wire                       predec_taken_o,
    output wire [31:0]                predec_target_o,
    output wire [`BR_TYPE_W-1:0]      predec_br_type_o,

    output wire                       ib_push0_valid_o,
    output wire [31:0]                ib_push0_pc_o,
    output wire [31:0]                ib_push0_inst_o,
    output wire                       ib_push0_pred_taken_o,
    output wire                       ib_push0_is_last_o,
    output wire [`FTQ_W-1:0]          ib_push0_ftq_id_o,
    output wire [`EXCP_NUM-1:0]       ib_push0_excp_o,

    output wire                       ib_push1_valid_o,
    output wire [31:0]                ib_push1_pc_o,
    output wire [31:0]                ib_push1_inst_o,
    output wire                       ib_push1_pred_taken_o,
    output wire                       ib_push1_is_last_o,
    output wire [`FTQ_W-1:0]          ib_push1_ftq_id_o,
    output wire [`EXCP_NUM-1:0]       ib_push1_excp_o,

    output wire                       ib_push2_valid_o,
    output wire [31:0]                ib_push2_pc_o,
    output wire [31:0]                ib_push2_inst_o,
    output wire                       ib_push2_pred_taken_o,
    output wire                       ib_push2_is_last_o,
    output wire [`FTQ_W-1:0]          ib_push2_ftq_id_o,
    output wire [`EXCP_NUM-1:0]       ib_push2_excp_o,

    output wire                       ib_push3_valid_o,
    output wire [31:0]                ib_push3_pc_o,
    output wire [31:0]                ib_push3_inst_o,
    output wire                       ib_push3_pred_taken_o,
    output wire                       ib_push3_is_last_o,
    output wire [`FTQ_W-1:0]          ib_push3_ftq_id_o,
    output wire [`EXCP_NUM-1:0]       ib_push3_excp_o,

    input  wire                       ib_can_push_i
);

assign ic_cancel_o = 1'b0;

function [`EXCP_NUM-1:0] pack_if_excp;
    input adef;
    input [`TLB_EX_NUM-1:0] tlb_ex;
    begin
        pack_if_excp = {(`EXCP_NUM){1'b0}};
        if (adef)
            pack_if_excp[`EXCP_ADEF] = 1'b1;
        if (tlb_ex[`TLB_EX_TLBR])
            pack_if_excp[`EXCP_TLBR_F] = 1'b1;
        if (tlb_ex[`TLB_EX_PIF])
            pack_if_excp[`EXCP_PIF] = 1'b1;
        if (tlb_ex[`TLB_EX_PPI])
            pack_if_excp[`EXCP_PPI_F] = 1'b1;
    end
endfunction

// ---------------- PRE 级 ----------------
reg        pre_v;
reg [31:0] pre_pc;
reg [`BLK_LEN_W-1:0] pre_len;
reg        pre_taken;
reg [31:0] pre_target;
reg [`FTQ_W-1:0] pre_id;
reg [31:0] pre_paddr;
reg        pre_uncached;
reg        pre_excp;
reg [`EXCP_NUM-1:0] pre_excp_vec;
reg        pre_ic_sent;

initial begin
    pre_v       = 1'b0;
    pre_ic_sent = 1'b0;
end

// ---------------- IF 级 ----------------
reg        if_v;
reg [31:0] if_pc;
reg [`BLK_LEN_W-1:0] if_len;
reg        if_taken;
reg [31:0] if_target;
reg [`FTQ_W-1:0] if_id;
reg        if_excp;
reg [`EXCP_NUM-1:0] if_excp_vec;
reg        if_wait_data;
reg [`CACHE_LINE_BITS-1:0] if_rline;

initial begin
    if_rline = {`CACHE_LINE_BITS{1'b0}};
end

reg drop_rsp;
reg ic_outstanding;

initial begin
    drop_rsp       = 1'b0;
    ic_outstanding = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        drop_rsp       <= 1'b0;
        ic_outstanding <= 1'b0;
    end else if (flush_i) begin
        // 冲刷后 IF/PRE 已清空，不必保留 drop_rsp；否则可能出现：
        // flush 置 drop_rsp -> 旧 data_ok 仅清 drop_rsp 而不喂 IF ->
        // 新取指 if_wait_data=1 但 I$ 不再回第二次 data_ok -> 前端永久死锁
        drop_rsp       <= 1'b0;
        ic_outstanding <= 1'b0;
    end else begin
        if (ftq_accept_o)
            drop_rsp <= 1'b0;
        if (ic_req_o && (ic_addr_ok_i === 1'b1))
            ic_outstanding <= 1'b1;
        if (ic_data_ok_i === 1'b1) begin
            ic_outstanding <= 1'b0;
            if (drop_rsp)
                drop_rsp <= 1'b0;
        end
    end
end

wire pre_excp_now = mmu_i_excp_adef_i || |mmu_i_tlb_ex_i;
wire [`EXCP_NUM-1:0] pre_excp_vec_now = pack_if_excp(mmu_i_excp_adef_i, mmu_i_tlb_ex_i);

wire pre_ready_go = (pre_v === 1'b1) && (pre_excp || (pre_ic_sent === 1'b1));

wire pre_allow_in = (pre_v !== 1'b1) && (pre_ready_go !== 1'b1);
wire if_block_ftq = (if_v === 1'b1) && (if_wait_data === 1'b1);
wire if_allow_in  = (if_v !== 1'b1)
                  || ((if_ready_go === 1'b1) && (predec_redirect_o !== 1'b1));
wire if_allow_in_eff = if_allow_in && !if_block_ftq;

assign ftq_accept_o = (ftq_valid_i === 1'b1) && pre_allow_in && if_allow_in_eff && (flush_i !== 1'b1);

function [`BLK_LEN_W-1:0] safe_blk_len;
    input [`BLK_LEN_W-1:0] len;
    begin
        if (len === 3'd0 || len === 3'bx || len === 3'dz)
            safe_blk_len = 3'd1;
        else
            safe_blk_len = len;
    end
endfunction

wire [`BLK_LEN_W-1:0] if_len_eff = safe_blk_len(if_len);
wire ib_can_push = (ib_can_push_i === 1'b1);
wire if_ic_hit   = (if_wait_data === 1'b1) && (ic_data_ok_i === 1'b1) && (drop_rsp !== 1'b1);
wire if_line_ready = (if_excp === 1'b1)
                  || if_ic_hit
                  || ((if_wait_data !== 1'b1) && (if_v === 1'b1) && (|if_rline));
wire if_ready_go = (if_v === 1'b1) && ib_can_push && if_line_ready;

assign mmu_i_req_o   = (ftq_accept_o || (pre_v === 1'b1)) && (flush_i !== 1'b1);
assign mmu_i_vaddr_o = ftq_accept_o ? ftq_pc_i : pre_pc;

assign ic_req_o     = pre_v && !pre_excp && !pre_ic_sent && !flush_i;
assign ic_vaddr_o   = pre_pc;
assign ic_paddr_o   = pre_paddr;
assign ic_uncached_o= pre_uncached;

always @(posedge clk) begin
    if (reset || flush_i) begin
        pre_v        <= 1'b0;
        pre_ic_sent  <= 1'b0;
        if_v         <= 1'b0;
        if_wait_data <= 1'b0;
        if_rline     <= {`CACHE_LINE_BITS{1'b0}};
        if_pc        <= 32'b0;
    end else begin
        if (pre_ready_go) begin
            pre_v       <= 1'b0;
            pre_ic_sent <= 1'b0;
        end else if (ftq_accept_o) begin
            pre_v        <= 1'b1;
            pre_pc       <= ftq_pc_i;
            pre_len      <= safe_blk_len(ftq_length_i);
            pre_taken    <= ftq_taken_i;
            pre_target   <= ftq_target_i;
            pre_id       <= ftq_ftq_id_i;
            pre_paddr    <= mmu_i_paddr_i;
            pre_uncached <= (mmu_i_mat_i != 2'd1);
            pre_excp     <= pre_excp_now;
            pre_excp_vec <= pre_excp_vec_now;
            pre_ic_sent  <= 1'b0;
        end else if (pre_v && !pre_excp && ic_req_o && (ic_addr_ok_i === 1'b1)) begin
            pre_ic_sent <= 1'b1;
        end

        if (pre_ready_go) begin
            if_v         <= 1'b1;
            if_pc        <= pre_pc;
            if_len       <= pre_len;
            if_taken     <= pre_taken;
            if_target    <= pre_target;
            if_id        <= pre_id;
            if_excp      <= pre_excp;
            if_excp_vec  <= pre_excp_vec;
            if (pre_excp) begin
                if_wait_data <= 1'b0;
            end else if ((ic_data_ok_i === 1'b1) && !drop_rsp) begin
                if_rline     <= ic_rline_i;
                if_wait_data <= 1'b0;
            end else begin
                if_wait_data <= 1'b1;
            end
        end else begin
            if (if_ready_go === 1'b1) begin
                if_v         <= 1'b0;
                if_wait_data <= 1'b0;
            end else if (if_v && if_wait_data && (ic_data_ok_i === 1'b1) && !drop_rsp) begin
                if_rline     <= ic_rline_i;
                if_wait_data <= 1'b0;
            end
            if (predec_redirect_o) begin
                pre_v       <= 1'b0;
                pre_ic_sent <= 1'b0;
            end
        end
    end
end

// ---------------- 指令切割 ----------------
wire [`CACHE_LINE_W-1:0] line_off = if_pc[`CACHE_LINE_W-1:2];
wire [`CACHE_LINE_BITS-1:0] if_rline_eff = (if_v && if_wait_data && ic_data_ok_i && !drop_rsp)
                                           ? ic_rline_i : if_rline;

wire [31:0] cut_inst [0:3];
wire [31:0] cut_pc   [0:3];
genvar gi;
generate
for (gi = 0; gi < 4; gi = gi + 1) begin : gen_cut
    assign cut_inst[gi] = if_excp ? 32'b0 :
                          if_rline_eff[(line_off + gi) * 32 +: 32];
    assign cut_pc[gi]   = if_pc + {29'b0, gi[1:0], 2'b00};
end
endgenerate

// ---------------- 预译码：B(010100) / BL(010101) ----------------
wire [5:0] opc0 = cut_inst[0][31:26];
wire [5:0] opc1 = cut_inst[1][31:26];
wire [5:0] opc2 = cut_inst[2][31:26];
wire [5:0] opc3 = cut_inst[3][31:26];

function is_direct_br;
    input [5:0] opc;
    begin
        is_direct_br = (opc == 6'b010100) || (opc == 6'b010101);
    end
endfunction

function [31:0] br_target;
    input [31:0] pc;
    input [31:0] inst;
    begin
        br_target = pc + {{4{inst[9]}}, inst[9:0], inst[25:10], 2'b00}; // si26 << 2, MSB=inst[9]
    end
endfunction

wire [3:0] imm_br;
assign imm_br[0] = is_direct_br(opc0);
assign imm_br[1] = is_direct_br(opc1);
assign imm_br[2] = is_direct_br(opc2);
assign imm_br[3] = is_direct_br(opc3);

wire [31:0] imm_tgt [0:3];
assign imm_tgt[0] = br_target(cut_pc[0], cut_inst[0]);
assign imm_tgt[1] = br_target(cut_pc[1], cut_inst[1]);
assign imm_tgt[2] = br_target(cut_pc[2], cut_inst[2]);
assign imm_tgt[3] = br_target(cut_pc[3], cut_inst[3]);

// 找最早漏预测的直接跳转
reg [1:0] predec_idx;
reg       predec_found;
integer pi;
always @(*) begin
    predec_found = 1'b0;
    predec_idx   = 2'd0;
    for (pi = 0; pi < 4; pi = pi + 1) begin
        if (!predec_found && (pi < if_len_eff) && imm_br[pi]) begin
            // 无延迟槽：无条件 B/BL 必须在块内截断（n49 TEST_TI_EX 的 b 1b = 0x50000000）
            predec_found = 1'b1;
            predec_idx   = pi[1:0];
        end
    end
end

wire [`BLK_LEN_W-1:0] out_len = predec_found ? (predec_idx + 1'b1) : if_len_eff;
wire push_en = if_ready_go;

// pred_taken 只标在推送块末指令：直接 B/BL 或 FTQ 块级 taken（非 predec 截断）
function slot_pred_taken;
    input [1:0] idx;
    input [`BLK_LEN_W-1:0] olen;
    begin
        slot_pred_taken = 1'b0;
        if ((idx + 1'b1) == olen[`BLK_LEN_W-1:0]) begin
            if (imm_br[idx])
                slot_pred_taken = 1'b1;
            else if (if_taken && !predec_found && ((idx + 1'b1) == if_len_eff))
                slot_pred_taken = 1'b1;
        end
    end
endfunction

assign predec_redirect_o    = push_en && predec_found && !if_excp;
assign predec_redirect_pc_o = imm_tgt[predec_idx];
assign predec_redirect_id_o = if_id;
assign predec_length_o      = out_len;
assign predec_taken_o       = 1'b1;
assign predec_target_o      = imm_tgt[predec_idx];
assign predec_br_type_o     = (cut_inst[predec_idx][31:26] == 6'b010101) ?
                              `BR_TYPE_CALL : `BR_TYPE_UNCOND;

// ---------------- IB 输出 ----------------
assign ib_push0_valid_o     = push_en && (out_len >= 3'd1);
assign ib_push0_pc_o        = cut_pc[0];
assign ib_push0_inst_o      = cut_inst[0];
assign ib_push0_pred_taken_o= push_en && (out_len >= 3'd1) && slot_pred_taken(2'd0, out_len);
assign ib_push0_is_last_o   = (out_len == 3'd1);
assign ib_push0_ftq_id_o    = if_id;
assign ib_push0_excp_o      = if_excp_vec;

assign ib_push1_valid_o     = push_en && (out_len >= 3'd2);
assign ib_push1_pc_o        = cut_pc[1];
assign ib_push1_inst_o      = cut_inst[1];
assign ib_push1_pred_taken_o= push_en && (out_len >= 3'd2) && slot_pred_taken(2'd1, out_len);
assign ib_push1_is_last_o   = (out_len == 3'd2);
assign ib_push1_ftq_id_o    = if_id;
assign ib_push1_excp_o      = if_excp_vec;

assign ib_push2_valid_o     = push_en && (out_len >= 3'd3);
assign ib_push2_pc_o        = cut_pc[2];
assign ib_push2_inst_o      = cut_inst[2];
assign ib_push2_pred_taken_o= push_en && (out_len >= 3'd3) && slot_pred_taken(2'd2, out_len);
assign ib_push2_is_last_o   = (out_len == 3'd3);
assign ib_push2_ftq_id_o    = if_id;
assign ib_push2_excp_o      = if_excp_vec;

assign ib_push3_valid_o     = push_en && (out_len >= 3'd4);
assign ib_push3_pc_o        = cut_pc[3];
assign ib_push3_inst_o      = cut_inst[3];
assign ib_push3_pred_taken_o= push_en && (out_len >= 3'd4) && slot_pred_taken(2'd3, out_len);
assign ib_push3_is_last_o   = (out_len >= 3'd4);
assign ib_push3_ftq_id_o    = if_id;
assign ib_push3_excp_o      = if_excp_vec;

endmodule
