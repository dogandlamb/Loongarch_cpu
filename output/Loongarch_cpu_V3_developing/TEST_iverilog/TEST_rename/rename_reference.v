// ============================================================
// rename 模块（重命名级：查 RAT / 读 ARF / 分配 ROB / 锁存到分发级）
// ------------------------------------------------------------
// 参考实现说明：
// - can_go 放行 -> 恒成对分配 ROB（{0,tail}/{1,tail}）；
// - 源操作数：RAT busy=0 读 ARF（ready=1）；busy=1 带 ROB 标签等唤醒；
// - 同拍 RAW 旁路：槽 1 源 == 槽 0 目的 -> 直接用槽 0 新 ROB 编号；
// - 结构冲突避让：两槽同为 MEM/MDU/ALU（均非 NOP）时只收槽 0，
//   槽 1 留待下一拍（保证 dispatch"全收或全停"不死锁）；
// - can_go 还需 incoming_dispatch_ok：IB 新指令必须能立刻入 RS，
//   避免 ROB 已分配但指令卡在 dis 寄存器导致 RS 永久等唤醒。
// - NOP 消除：is_nop 只入 ROB（分配即完成），不送分发级。
// ============================================================
`include "mycpu.h"

module rename(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // =============== 槽 0 输入（IB pop0 + decoder0，组合送入） ===============
    input  wire                       ib0_valid_i,
    input  wire [31:0]                ib0_pc_i,
    input  wire [31:0]                ib0_inst_i,
    input  wire                       ib0_pred_taken_i,
    input  wire                       ib0_is_last_i,
    input  wire [`FTQ_W-1:0]          ib0_ftq_id_i,
    input  wire [`EXCP_NUM-1:0]       ib0_excp_i,        // 取指异常+译码异常（顶层已并好）
    // decoder0 输出
    input  wire [`FU_NUM-1:0]         ib0_futype_i,
    input  wire [`ALU_OP_NUM-1:0]     ib0_alu_op_i,
    input  wire [`BR_OP_NUM-1:0]      ib0_br_op_i,
    input  wire [`MEM_OP_NUM-1:0]     ib0_mem_op_i,
    input  wire [`CSR_OP_NUM-1:0]     ib0_csr_op_i,
    input  wire [`TLB_OP_NUM-1:0]     ib0_tlb_op_i,
    input  wire [`WB_SRC_NUM-1:0]     ib0_wb_src_op_i,
    input  wire [13:0]                ib0_csr_num_i,
    input  wire [4:0]                 ib0_cacop_code_i,
    input  wire [4:0]                 ib0_src0_addr_i,
    input  wire [4:0]                 ib0_src1_addr_i,
    input  wire                       ib0_use_src0_i,
    input  wire                       ib0_use_src1_i,
    input  wire [4:0]                 ib0_rd_addr_i,
    input  wire                       ib0_rf_we_i,
    input  wire [31:0]                ib0_imm_i,
    input  wire                       ib0_use_imm_i,
    input  wire [31:0]                ib0_br_offs_i,
    input  wire                       ib0_is_branch_i,
    input  wire [`BR_TYPE_W-1:0]      ib0_br_type_i,
    input  wire [`PRIV_NUM-1:0]       ib0_priv_vec_i,
    input  wire                       ib0_is_nop_i,
    input  wire                       ib0_is_load_i,
    input  wire                       ib0_is_store_i,
    output wire                       ib0_ready_o,       // 本拍收走槽 0

    // =============== 槽 1 输入（IB pop1 + decoder1） ===============
    input  wire                       ib1_valid_i,
    input  wire [31:0]                ib1_pc_i,
    input  wire [31:0]                ib1_inst_i,
    input  wire                       ib1_pred_taken_i,
    input  wire                       ib1_is_last_i,
    input  wire [`FTQ_W-1:0]          ib1_ftq_id_i,
    input  wire [`EXCP_NUM-1:0]       ib1_excp_i,
    input  wire [`FU_NUM-1:0]         ib1_futype_i,
    input  wire [`ALU_OP_NUM-1:0]     ib1_alu_op_i,
    input  wire [`BR_OP_NUM-1:0]      ib1_br_op_i,
    input  wire [`MEM_OP_NUM-1:0]     ib1_mem_op_i,
    input  wire [`CSR_OP_NUM-1:0]     ib1_csr_op_i,
    input  wire [`TLB_OP_NUM-1:0]     ib1_tlb_op_i,
    input  wire [`WB_SRC_NUM-1:0]     ib1_wb_src_op_i,
    input  wire [13:0]                ib1_csr_num_i,
    input  wire [4:0]                 ib1_cacop_code_i,
    input  wire [4:0]                 ib1_src0_addr_i,
    input  wire [4:0]                 ib1_src1_addr_i,
    input  wire                       ib1_use_src0_i,
    input  wire                       ib1_use_src1_i,
    input  wire [4:0]                 ib1_rd_addr_i,
    input  wire                       ib1_rf_we_i,
    input  wire [31:0]                ib1_imm_i,
    input  wire                       ib1_use_imm_i,
    input  wire [31:0]                ib1_br_offs_i,
    input  wire                       ib1_is_branch_i,
    input  wire [`BR_TYPE_W-1:0]      ib1_br_type_i,
    input  wire [`PRIV_NUM-1:0]       ib1_priv_vec_i,
    input  wire                       ib1_is_nop_i,
    input  wire                       ib1_is_load_i,
    input  wire                       ib1_is_store_i,
    output wire                       ib1_ready_o,

    // =============== RAT 接口 ===============
    output wire [4:0]                 rat_raddr0_o,      // 槽0 src0
    input  wire                       rat_rbusy0_i,
    input  wire [`ROB_W-1:0]          rat_rnum0_i,
    output wire [4:0]                 rat_raddr1_o,      // 槽0 src1
    input  wire                       rat_rbusy1_i,
    input  wire [`ROB_W-1:0]          rat_rnum1_i,
    output wire [4:0]                 rat_raddr2_o,      // 槽1 src0
    input  wire                       rat_rbusy2_i,
    input  wire [`ROB_W-1:0]          rat_rnum2_i,
    output wire [4:0]                 rat_raddr3_o,      // 槽1 src1
    input  wire                       rat_rbusy3_i,
    input  wire [`ROB_W-1:0]          rat_rnum3_i,

    output wire                       rat_wen0_o,        // 槽0 目的占用
    output wire [4:0]                 rat_waddr0_o,
    output wire [`ROB_W-1:0]          rat_wnum0_o,
    output wire                       rat_wen1_o,        // 槽1 目的占用
    output wire [4:0]                 rat_waddr1_o,
    output wire [`ROB_W-1:0]          rat_wnum1_o,

    // =============== ARF 4 读口 ===============
    output wire [4:0]                 arf_raddr0_o,
    input  wire [31:0]                arf_rdata0_i,
    output wire [4:0]                 arf_raddr1_o,
    input  wire [31:0]                arf_rdata1_i,
    output wire [4:0]                 arf_raddr2_o,
    input  wire [31:0]                arf_rdata2_i,
    output wire [4:0]                 arf_raddr3_o,
    input  wire [31:0]                arf_rdata3_i,

    // =============== ROB 成对分配口（静态信息） ===============
    output wire                       rob_alloc_en_o,        // 本拍分配一对
    input  wire [`ROB_PAIR_W-1:0]     rob_tail_i,            // 当前队尾（编号={奇偶位,tail}）
    input  wire                       rob_full_i,

    output wire                       rob_a0_valid_o,        // 槽 0 静态信息
    output wire [31:0]                rob_a0_pc_o,
    output wire [31:0]                rob_a0_inst_o,
    output wire                       rob_a0_rf_we_o,
    output wire [4:0]                 rob_a0_rd_o,
    output wire [`FU_NUM-1:0]         rob_a0_futype_o,
    output wire                       rob_a0_is_load_o,
    output wire                       rob_a0_is_store_o,
    output wire                       rob_a0_is_branch_o,
    output wire [`BR_TYPE_W-1:0]      rob_a0_br_type_o,
    output wire                       rob_a0_pred_taken_o,
    output wire                       rob_a0_is_last_o,
    output wire [`FTQ_W-1:0]          rob_a0_ftq_id_o,
    output wire [`PRIV_NUM-1:0]       rob_a0_priv_vec_o,
    output wire [13:0]                rob_a0_csr_num_o,
    output wire [`TLB_OP_NUM-1:0]     rob_a0_tlb_op_o,       // TLB 维护类型（提交级落地用）
    output wire [4:0]                 rob_a0_cacop_code_o,
    output wire [`EXCP_NUM-1:0]       rob_a0_excp_o,
    output wire                       rob_a0_is_nop_o,       // 分配时即标完成

    output wire                       rob_a1_valid_o,        // 槽 1 静态信息
    output wire [31:0]                rob_a1_pc_o,
    output wire [31:0]                rob_a1_inst_o,
    output wire                       rob_a1_rf_we_o,
    output wire [4:0]                 rob_a1_rd_o,
    output wire [`FU_NUM-1:0]         rob_a1_futype_o,
    output wire                       rob_a1_is_load_o,
    output wire                       rob_a1_is_store_o,
    output wire                       rob_a1_is_branch_o,
    output wire [`BR_TYPE_W-1:0]      rob_a1_br_type_o,
    output wire                       rob_a1_pred_taken_o,
    output wire                       rob_a1_is_last_o,
    output wire [`FTQ_W-1:0]          rob_a1_ftq_id_o,
    output wire [`PRIV_NUM-1:0]       rob_a1_priv_vec_o,
    output wire [13:0]                rob_a1_csr_num_o,
    output wire [`TLB_OP_NUM-1:0]     rob_a1_tlb_op_o,
    output wire [4:0]                 rob_a1_cacop_code_o,
    output wire [`EXCP_NUM-1:0]       rob_a1_excp_o,
    output wire                       rob_a1_is_nop_o,

    // =============== RS 反压预览（与 dispatch 路由一致，用于 incoming 检查） ===============
    input  wire                       rs_alu0_can_accept_i,
    input  wire                       rs_alu1_can_accept_i,
    input  wire [2:0]                 rs_alu0_occupancy_i,
    input  wire [2:0]                 rs_alu1_occupancy_i,
    input  wire                       rs_mem_can_accept_i,
    input  wire                       rs_mdu_can_accept_i,

    // 提交拍 ARF 写回旁路（rename 读 ARF 早于 commit 写口生效时用）
    input  wire                       cmt_wake0_valid_i,
    input  wire [4:0]                 cmt_wake0_rd_i,
    input  wire [31:0]                cmt_wake0_data_i,
    input  wire                       cmt_wake1_valid_i,
    input  wire [4:0]                 cmt_wake1_rd_i,
    input  wire [31:0]                cmt_wake1_data_i,

    // =============== 到分发级的流水寄存器输出（执行所需信息） ===============
    input  wire                       dispatch_ready_i,      // 当前 dis 内容本拍可全部入 RS
    input  wire                       dis_handed_i,          // dispatch 本拍至少 push 一条
    input  wire                       dis0_handed_i,
    input  wire                       dis1_handed_i,

    output reg                        dis0_valid_o,
    output reg  [`ROB_W-1:0]          dis0_robid_o,
    output reg  [31:0]                dis0_pc_o,
    output reg  [`FU_NUM-1:0]         dis0_futype_o,
    output reg  [`ALU_OP_NUM-1:0]     dis0_alu_op_o,
    output reg  [`BR_OP_NUM-1:0]      dis0_br_op_o,
    output reg  [`MEM_OP_NUM-1:0]     dis0_mem_op_o,
    output reg  [`CSR_OP_NUM-1:0]     dis0_csr_op_o,
    output reg  [`TLB_OP_NUM-1:0]     dis0_tlb_op_o,
    output reg  [`WB_SRC_NUM-1:0]     dis0_wb_src_op_o,
    output reg  [13:0]                dis0_csr_num_o,
    output reg                        dis0_is_cacop_o,
    output reg                        dis0_src0_ready_o,     // 1=val 有效；0=等 robid 唤醒
    output reg  [31:0]                dis0_src0_val_o,
    output reg  [`ROB_W-1:0]          dis0_src0_robid_o,
    output reg  [4:0]                 dis0_src0_addr_o,
    output reg                        dis0_src1_ready_o,
    output reg  [31:0]                dis0_src1_val_o,
    output reg  [`ROB_W-1:0]          dis0_src1_robid_o,
    output reg  [4:0]                 dis0_src1_addr_o,
    output reg  [31:0]                dis0_imm_o,
    output reg                        dis0_use_imm_o,
    output reg  [31:0]                dis0_br_offs_o,

    output reg                        dis1_valid_o,
    output reg  [`ROB_W-1:0]          dis1_robid_o,
    output reg  [31:0]                dis1_pc_o,
    output reg  [`FU_NUM-1:0]         dis1_futype_o,
    output reg  [`ALU_OP_NUM-1:0]     dis1_alu_op_o,
    output reg  [`BR_OP_NUM-1:0]      dis1_br_op_o,
    output reg  [`MEM_OP_NUM-1:0]     dis1_mem_op_o,
    output reg  [`CSR_OP_NUM-1:0]     dis1_csr_op_o,
    output reg  [`TLB_OP_NUM-1:0]     dis1_tlb_op_o,
    output reg  [`WB_SRC_NUM-1:0]     dis1_wb_src_op_o,
    output reg  [13:0]                dis1_csr_num_o,
    output reg                        dis1_is_cacop_o,
    output reg                        dis1_src0_ready_o,
    output reg  [31:0]                dis1_src0_val_o,
    output reg  [`ROB_W-1:0]          dis1_src0_robid_o,
    output reg  [4:0]                 dis1_src0_addr_o,
    output reg                        dis1_src1_ready_o,
    output reg  [31:0]                dis1_src1_val_o,
    output reg  [`ROB_W-1:0]          dis1_src1_robid_o,
    output reg  [4:0]                 dis1_src1_addr_o,
    output reg  [31:0]                dis1_imm_o,
    output reg                        dis1_use_imm_o,
    output reg  [31:0]                dis1_br_offs_o
);

// ---------------- 放行条件 ----------------
// 结构冲突避让：两槽同为 MEM 或同为 MDU（均非 NOP）时本拍只收槽 0
wire ib0_ok = (ib0_valid_i === 1'b1);
wire ib1_ok = (ib1_valid_i === 1'b1);
wire ib0_good = ib0_ok && !((ib0_inst_i === 32'h0) && (ib0_pc_i === 32'h0));
wire ib1_good = ib1_ok && !((ib1_inst_i === 32'h0) && (ib1_pc_i === 32'h0));
wire slot0_use_rs = ib0_good && !(ib0_is_nop_i === 1'b1);
wire slot1_use_rs = ib1_good && !(ib1_is_nop_i === 1'b1);
wire same_mem = slot0_use_rs && slot1_use_rs
              && (ib0_futype_i[`FU_MEM] === 1'b1) && (ib1_futype_i[`FU_MEM] === 1'b1);
wire same_mdu = slot0_use_rs && slot1_use_rs
              && (ib0_futype_i[`FU_MDU] === 1'b1) && (ib1_futype_i[`FU_MDU] === 1'b1);
wire same_alu = slot0_use_rs && slot1_use_rs
              && (ib0_futype_i[`FU_ALU] === 1'b1) && (ib1_futype_i[`FU_ALU] === 1'b1);
wire take1    = ib1_good && !(same_mem === 1'b1) && !(same_mdu === 1'b1)
              && !(same_alu === 1'b1);

// 预览 IB 入 dis 后 dispatch 能否全收（与 dispatch.v 路由一致）
wire in_dis0_valid = ib0_good && !(ib0_is_nop_i === 1'b1);
wire in_dis1_valid = take1 && ib1_good && !(ib1_is_nop_i === 1'b1);
wire in_slot0_alu  = in_dis0_valid && (ib0_futype_i[`FU_ALU] === 1'b1);
wire in_slot0_mem  = in_dis0_valid && (ib0_futype_i[`FU_MEM] === 1'b1);
wire in_slot0_mdu  = in_dis0_valid && (ib0_futype_i[`FU_MDU] === 1'b1);
wire in_slot1_alu  = in_dis1_valid && (ib1_futype_i[`FU_ALU] === 1'b1);
wire in_slot1_mem  = in_dis1_valid && (ib1_futype_i[`FU_MEM] === 1'b1);
wire in_slot1_mdu  = in_dis1_valid && (ib1_futype_i[`FU_MDU] === 1'b1);
wire in_alu0_lighter = (rs_alu0_occupancy_i <= rs_alu1_occupancy_i);
wire in_both_alu     = in_slot0_alu && in_slot1_alu;
wire in_mem_ok = (in_slot0_mem || in_slot1_mem) ? rs_mem_can_accept_i : 1'b1;
wire in_mdu_ok = (in_slot0_mdu || in_slot1_mdu) ? rs_mdu_can_accept_i : 1'b1;
wire in_go_both_alu  = in_both_alu && rs_alu0_can_accept_i && rs_alu1_can_accept_i;
wire in_alu_one_ok   = rs_alu0_can_accept_i || rs_alu1_can_accept_i;
wire in_go_slot0 = in_dis0_valid && (
                       (in_slot0_mem && in_mem_ok) ||
                       (in_slot0_mdu && in_mdu_ok) ||
                       (in_slot0_alu && in_both_alu && in_go_both_alu) ||
                       (in_slot0_alu && !in_both_alu && in_alu_one_ok)
                   );
wire in_go_slot1 = in_dis1_valid && (
                       (in_slot1_mem && in_mem_ok) ||
                       (in_slot1_mdu && in_mdu_ok) ||
                       (in_slot1_alu && in_both_alu && in_go_both_alu) ||
                       (in_slot1_alu && !in_both_alu && in_alu_one_ok)
                   );
wire incoming_dispatch_ok = (!in_dis0_valid || in_go_slot0) && (!in_dis1_valid || in_go_slot1);

wire dis_empty = !(dis0_valid_o === 1'b1) && !(dis1_valid_o === 1'b1);

// rename 仅在 dis 空且 incoming 可入 RS 时放行；dispatch 清空 dis 后下一拍再装 IB
wire can_go = ib0_good && !(rob_full_i === 1'b1)
            && incoming_dispatch_ok && dis_empty
            && !(flush_i === 1'b1) && (reset !== 1'b1);

assign ib0_ready_o    = can_go && ib0_good;
assign ib1_ready_o    = can_go && take1;
assign rob_alloc_en_o = can_go;

wire [`ROB_W-1:0] robid0 = {1'b0, rob_tail_i};
wire [`ROB_W-1:0] robid1 = {1'b1, rob_tail_i};

// ---------------- RAT / ARF 读地址（共用）----------------
assign rat_raddr0_o = ib0_src0_addr_i;
assign rat_raddr1_o = ib0_src1_addr_i;
assign rat_raddr2_o = ib1_src0_addr_i;
assign rat_raddr3_o = ib1_src1_addr_i;
assign arf_raddr0_o = ib0_src0_addr_i;
assign arf_raddr1_o = ib0_src1_addr_i;
assign arf_raddr2_o = ib1_src0_addr_i;
assign arf_raddr3_o = ib1_src1_addr_i;

function [31:0] arf_read_fwd;
    input [4:0]  raddr;
    input [31:0] raw;
    begin
        if (cmt_wake0_valid_i && (cmt_wake0_rd_i == raddr) && (raddr != 5'd0))
            arf_read_fwd = cmt_wake0_data_i;
        else if (cmt_wake1_valid_i && (cmt_wake1_rd_i == raddr) && (raddr != 5'd0))
            arf_read_fwd = cmt_wake1_data_i;
        else
            arf_read_fwd = raw;
    end
endfunction

// ---------------- 源操作数就绪判定 ----------------
// 槽 0：直接查 RAT/ARF
wire s0a_ready = !ib0_use_src0_i || !rat_rbusy0_i;
wire [31:0]       s0a_val   = ib0_use_src0_i ? arf_read_fwd(ib0_src0_addr_i, arf_rdata0_i) : 32'b0;
wire [`ROB_W-1:0] s0a_robid = rat_rnum0_i;
wire s0b_ready = !ib0_use_src1_i || !rat_rbusy1_i;
wire [31:0]       s0b_val   = ib0_use_src1_i ? arf_read_fwd(ib0_src1_addr_i, arf_rdata1_i) : 32'b0;
wire [`ROB_W-1:0] s0b_robid = rat_rnum1_i;

// 槽 1：先做同拍 RAW 旁路（槽 1 源 == 槽 0 目的）
wire slot0_writes = ib0_valid_i && ib0_rf_we_i && (ib0_rd_addr_i != 5'd0);
wire raw_s1a = slot0_writes && (ib1_src0_addr_i == ib0_rd_addr_i) && ib1_use_src0_i;
wire raw_s1b = slot0_writes && (ib1_src1_addr_i == ib0_rd_addr_i) && ib1_use_src1_i;

wire s1a_ready = !ib1_use_src0_i || (!raw_s1a && !rat_rbusy2_i);
wire [31:0]       s1a_val   = ib1_use_src0_i ? arf_read_fwd(ib1_src0_addr_i, arf_rdata2_i) : 32'b0;
wire [`ROB_W-1:0] s1a_robid = raw_s1a ? robid0 : rat_rnum2_i;
wire s1b_ready = !ib1_use_src1_i || (!raw_s1b && !rat_rbusy3_i);
wire [31:0]       s1b_val   = ib1_use_src1_i ? arf_read_fwd(ib1_src1_addr_i, arf_rdata3_i) : 32'b0;
wire [`ROB_W-1:0] s1b_robid = raw_s1b ? robid0 : rat_rnum3_i;

// ---------------- RAT 占用写 ----------------
assign rat_wen0_o   = can_go && ib0_valid_i && ib0_rf_we_i && (ib0_rd_addr_i != 5'd0);
assign rat_waddr0_o = ib0_rd_addr_i;
assign rat_wnum0_o  = robid0;
assign rat_wen1_o   = can_go && take1 && ib1_rf_we_i && (ib1_rd_addr_i != 5'd0);
assign rat_waddr1_o = ib1_rd_addr_i;
assign rat_wnum1_o  = robid1;

// ---------------- ROB 静态信息（组合直通）----------------
assign rob_a0_valid_o     = can_go && ib0_good;
assign rob_a0_pc_o        = ib0_pc_i;
assign rob_a0_inst_o      = ib0_inst_i;
assign rob_a0_rf_we_o     = ib0_rf_we_i && (ib0_rd_addr_i != 5'd0);
assign rob_a0_rd_o        = ib0_rd_addr_i;
assign rob_a0_futype_o    = ib0_futype_i;
assign rob_a0_is_load_o   = ib0_is_load_i;
assign rob_a0_is_store_o  = ib0_is_store_i;
assign rob_a0_is_branch_o = ib0_is_branch_i;
assign rob_a0_br_type_o   = ib0_br_type_i;
assign rob_a0_pred_taken_o= ib0_pred_taken_i;
assign rob_a0_is_last_o   = ib0_is_last_i;
assign rob_a0_ftq_id_o    = ib0_ftq_id_i;
assign rob_a0_priv_vec_o  = ib0_priv_vec_i;
assign rob_a0_csr_num_o   = ib0_csr_num_i;
assign rob_a0_tlb_op_o    = ib0_tlb_op_i;
assign rob_a0_cacop_code_o= ib0_cacop_code_i;
assign rob_a0_excp_o      = ib0_excp_i;
assign rob_a0_is_nop_o    = ib0_is_nop_i;

assign rob_a1_valid_o     = can_go && take1 && ib1_good;
assign rob_a1_pc_o        = ib1_pc_i;
assign rob_a1_inst_o      = ib1_inst_i;
assign rob_a1_rf_we_o     = ib1_rf_we_i && (ib1_rd_addr_i != 5'd0);
assign rob_a1_rd_o        = ib1_rd_addr_i;
assign rob_a1_futype_o    = ib1_futype_i;
assign rob_a1_is_load_o   = ib1_is_load_i;
assign rob_a1_is_store_o  = ib1_is_store_i;
assign rob_a1_is_branch_o = ib1_is_branch_i;
assign rob_a1_br_type_o   = ib1_br_type_i;
assign rob_a1_pred_taken_o= ib1_pred_taken_i;
assign rob_a1_is_last_o   = ib1_is_last_i;
assign rob_a1_ftq_id_o    = ib1_ftq_id_i;
assign rob_a1_priv_vec_o  = ib1_priv_vec_i;
assign rob_a1_csr_num_o   = ib1_csr_num_i;
assign rob_a1_tlb_op_o    = ib1_tlb_op_i;
assign rob_a1_cacop_code_o= ib1_cacop_code_i;
assign rob_a1_excp_o      = ib1_excp_i;
assign rob_a1_is_nop_o    = ib1_is_nop_i;

// ---------------- rename/dispatch 流水寄存器 ----------------
always @(posedge clk) begin
    if (reset || flush_i) begin
        dis0_valid_o <= 1'b0;
        dis1_valid_o <= 1'b0;
    end else if (dis0_handed_i || dis1_handed_i) begin
        if (dis0_handed_i)
            dis0_valid_o <= 1'b0;
        if (dis1_handed_i)
            dis1_valid_o <= 1'b0;
    end else if (can_go) begin
        dis0_valid_o <= ib0_good && (ib0_is_nop_i !== 1'b1);
        dis1_valid_o <= take1 && ib1_good && (ib1_is_nop_i !== 1'b1);
        dis0_robid_o      <= robid0;
            dis0_pc_o         <= ib0_pc_i;
            dis0_futype_o     <= ib0_futype_i;
            dis0_alu_op_o     <= ib0_alu_op_i;
            dis0_br_op_o      <= ib0_br_op_i;
            dis0_mem_op_o     <= ib0_mem_op_i;
            dis0_csr_op_o     <= ib0_csr_op_i;
            dis0_tlb_op_o     <= ib0_tlb_op_i;
            dis0_wb_src_op_o  <= ib0_wb_src_op_i;
            dis0_csr_num_o    <= ib0_csr_num_i;
            dis0_is_cacop_o   <= ib0_priv_vec_i[`PRIV_CACOP];
            dis0_src0_ready_o <= s0a_ready;
            dis0_src0_val_o   <= s0a_val;
            dis0_src0_robid_o <= s0a_robid;
            dis0_src0_addr_o  <= ib0_src0_addr_i;
            dis0_src1_ready_o <= s0b_ready;
            dis0_src1_val_o   <= s0b_val;
            dis0_src1_robid_o <= s0b_robid;
            dis0_src1_addr_o  <= ib0_src1_addr_i;
            dis0_imm_o        <= ib0_imm_i;
            dis0_use_imm_o    <= ib0_use_imm_i;
            dis0_br_offs_o    <= ib0_br_offs_i;

            dis1_robid_o      <= robid1;
            dis1_pc_o         <= ib1_pc_i;
            dis1_futype_o     <= ib1_futype_i;
            dis1_alu_op_o     <= ib1_alu_op_i;
            dis1_br_op_o      <= ib1_br_op_i;
            dis1_mem_op_o     <= ib1_mem_op_i;
            dis1_csr_op_o     <= ib1_csr_op_i;
            dis1_tlb_op_o     <= ib1_tlb_op_i;
            dis1_wb_src_op_o  <= ib1_wb_src_op_i;
            dis1_csr_num_o    <= ib1_csr_num_i;
            dis1_is_cacop_o   <= ib1_priv_vec_i[`PRIV_CACOP];
            dis1_src0_ready_o <= s1a_ready;
            dis1_src0_val_o   <= s1a_val;
            dis1_src0_robid_o <= s1a_robid;
            dis1_src0_addr_o  <= ib1_src0_addr_i;
            dis1_src1_ready_o <= s1b_ready;
            dis1_src1_val_o   <= s1b_val;
            dis1_src1_robid_o <= s1b_robid;
            dis1_src1_addr_o  <= ib1_src1_addr_i;
            dis1_imm_o        <= ib1_imm_i;
            dis1_use_imm_o    <= ib1_use_imm_i;
            dis1_br_offs_o    <= ib1_br_offs_i;
    end
    // dispatch 未就绪时 dis 保持
end

endmodule
