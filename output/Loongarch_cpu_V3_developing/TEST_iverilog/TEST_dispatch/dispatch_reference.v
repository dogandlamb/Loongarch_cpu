// ============================================================
// dispatch 模块（分发级：读 ROB 补操作数 + 按 FU 类型路由进保留站）
// ------------------------------------------------------------
// 参考实现说明（纯组合）：
// - 4 个源操作数用 robid 读 ROB：已写回则补值（ready=1），否则带标签等唤醒；
// - 路由：ALU 双站负载均衡（占用少者优先）；MEM/MDU 每拍最多 1 条
//   （rename 已保证两槽不同时同为 MEM/MDU）；
// - "全收或全停"：所有有效槽都能入站才放行（dispatch_ready_o），
//   否则全部 push_valid=0，rename 流水寄存器保持重试。
// ============================================================
`include "mycpu.h"

module dispatch(
    // =============== 槽 0 输入（rename 流水寄存器） ===============
    input  wire                       dis0_valid_i,
    input  wire [`ROB_W-1:0]          dis0_robid_i,
    input  wire [31:0]                dis0_pc_i,
    input  wire [`FU_NUM-1:0]         dis0_futype_i,
    input  wire [`ALU_OP_NUM-1:0]     dis0_alu_op_i,
    input  wire [`BR_OP_NUM-1:0]      dis0_br_op_i,
    input  wire [`MEM_OP_NUM-1:0]     dis0_mem_op_i,
    input  wire [`CSR_OP_NUM-1:0]     dis0_csr_op_i,
    input  wire [`TLB_OP_NUM-1:0]     dis0_tlb_op_i,
    input  wire [`WB_SRC_NUM-1:0]     dis0_wb_src_op_i,
    input  wire [13:0]                dis0_csr_num_i,
    input  wire                       dis0_is_cacop_i,
    input  wire                       dis0_src0_ready_i,
    input  wire [31:0]                dis0_src0_val_i,
    input  wire [`ROB_W-1:0]          dis0_src0_robid_i,
    input  wire [4:0]                 dis0_src0_addr_i,
    input  wire                       dis0_src1_ready_i,
    input  wire [31:0]                dis0_src1_val_i,
    input  wire [`ROB_W-1:0]          dis0_src1_robid_i,
    input  wire [4:0]                 dis0_src1_addr_i,
    input  wire [31:0]                dis0_imm_i,
    input  wire                       dis0_use_imm_i,
    input  wire [31:0]                dis0_br_offs_i,

    // =============== 槽 1 输入 ===============
    input  wire                       dis1_valid_i,
    input  wire [`ROB_W-1:0]          dis1_robid_i,
    input  wire [31:0]                dis1_pc_i,
    input  wire [`FU_NUM-1:0]         dis1_futype_i,
    input  wire [`ALU_OP_NUM-1:0]     dis1_alu_op_i,
    input  wire [`BR_OP_NUM-1:0]      dis1_br_op_i,
    input  wire [`MEM_OP_NUM-1:0]     dis1_mem_op_i,
    input  wire [`CSR_OP_NUM-1:0]     dis1_csr_op_i,
    input  wire [`TLB_OP_NUM-1:0]     dis1_tlb_op_i,
    input  wire [`WB_SRC_NUM-1:0]     dis1_wb_src_op_i,
    input  wire [13:0]                dis1_csr_num_i,
    input  wire                       dis1_is_cacop_i,
    input  wire                       dis1_src0_ready_i,
    input  wire [31:0]                dis1_src0_val_i,
    input  wire [`ROB_W-1:0]          dis1_src0_robid_i,
    input  wire [4:0]                 dis1_src0_addr_i,
    input  wire                       dis1_src1_ready_i,
    input  wire [31:0]                dis1_src1_val_i,
    input  wire [`ROB_W-1:0]          dis1_src1_robid_i,
    input  wire [4:0]                 dis1_src1_addr_i,
    input  wire [31:0]                dis1_imm_i,
    input  wire                       dis1_use_imm_i,
    input  wire [31:0]                dis1_br_offs_i,

    output wire                       dispatch_ready_o,    // 两条都能入站（反压 rename）
    output wire                       dis_handed_o,        // 本拍 dis 至少一条已送入 RS
    output wire                       dis0_handed_o,
    output wire                       dis1_handed_o,

    // =============== ROB 操作数读口 ×4（组合） ===============
    output wire [`ROB_W-1:0]          rob_raddr0_o,        // 槽0 src0
    input  wire                       rob_rrdy0_i,         // 该编号已写回
    input  wire [31:0]                rob_rdata0_i,
    output wire [`ROB_W-1:0]          rob_raddr1_o,        // 槽0 src1
    input  wire                       rob_rrdy1_i,
    input  wire [31:0]                rob_rdata1_i,
    output wire [`ROB_W-1:0]          rob_raddr2_o,        // 槽1 src0
    input  wire                       rob_rrdy2_i,
    input  wire [31:0]                rob_rdata2_i,
    output wire [`ROB_W-1:0]          rob_raddr3_o,        // 槽1 src1
    input  wire                       rob_rrdy3_i,
    input  wire [31:0]                rob_rdata3_i,

    // 提交拍唤醒（dis 仍挂 robid 标签、ROB 项已提交时补就绪/数据）
    input  wire                       cmt_wake0_valid_i,
    input  wire [`ROB_W-1:0]          cmt_wake0_robid_i,
    input  wire [31:0]                cmt_wake0_data_i,
    input  wire [4:0]                 cmt_wake0_rd_i,
    input  wire                       cmt_wake1_valid_i,
    input  wire [`ROB_W-1:0]          cmt_wake1_robid_i,
    input  wire [31:0]                cmt_wake1_data_i,
    input  wire [4:0]                 cmt_wake1_rd_i,

    // RAT/ARF 回读（producer 已提交、RAT 已释放，dis 仍挂 robid 时取最新 ARF）
    input  wire                       rat_rbusy4_i,
    input  wire [`ROB_W-1:0]          rat_rnum4_i,
    input  wire [31:0]                arf_rdata4_i,
    input  wire                       rat_rbusy5_i,
    input  wire [`ROB_W-1:0]          rat_rnum5_i,
    input  wire [31:0]                arf_rdata5_i,
    input  wire                       rat_rbusy6_i,
    input  wire [`ROB_W-1:0]          rat_rnum6_i,
    input  wire [31:0]                arf_rdata6_i,
    input  wire                       rat_rbusy7_i,
    input  wire [`ROB_W-1:0]          rat_rnum7_i,
    input  wire [31:0]                arf_rdata7_i,

    // =============== rs_alu0 入站口 ===============
    input  wire                       rs_alu0_can_accept_i,
    input  wire [2:0]                 rs_alu0_occupancy_i,   // 占用项数（负载均衡用）
    output wire                       rs_alu0_push_valid_o,
    output wire [`ROB_W-1:0]          rs_alu0_push_robid_o,
    output wire [31:0]                rs_alu0_push_pc_o,
    output wire [`ALU_OP_NUM-1:0]     rs_alu0_push_alu_op_o,
    output wire [`BR_OP_NUM-1:0]      rs_alu0_push_br_op_o,
    output wire                       rs_alu0_push_src0_ready_o,
    output wire [31:0]                rs_alu0_push_src0_val_o,
    output wire [`ROB_W-1:0]          rs_alu0_push_src0_robid_o,
    output wire                       rs_alu0_push_src1_ready_o,
    output wire [31:0]                rs_alu0_push_src1_val_o,
    output wire [`ROB_W-1:0]          rs_alu0_push_src1_robid_o,
    output wire [31:0]                rs_alu0_push_imm_o,
    output wire                       rs_alu0_push_use_imm_o,
    output wire [31:0]                rs_alu0_push_br_offs_o,

    // =============== rs_alu1 入站口 ===============
    input  wire                       rs_alu1_can_accept_i,
    input  wire [2:0]                 rs_alu1_occupancy_i,
    output wire                       rs_alu1_push_valid_o,
    output wire [`ROB_W-1:0]          rs_alu1_push_robid_o,
    output wire [31:0]                rs_alu1_push_pc_o,
    output wire [`ALU_OP_NUM-1:0]     rs_alu1_push_alu_op_o,
    output wire [`BR_OP_NUM-1:0]      rs_alu1_push_br_op_o,
    output wire                       rs_alu1_push_src0_ready_o,
    output wire [31:0]                rs_alu1_push_src0_val_o,
    output wire [`ROB_W-1:0]          rs_alu1_push_src0_robid_o,
    output wire                       rs_alu1_push_src1_ready_o,
    output wire [31:0]                rs_alu1_push_src1_val_o,
    output wire [`ROB_W-1:0]          rs_alu1_push_src1_robid_o,
    output wire [31:0]                rs_alu1_push_imm_o,
    output wire                       rs_alu1_push_use_imm_o,
    output wire [31:0]                rs_alu1_push_br_offs_o,

    // =============== rs_mem 入站口 ===============
    input  wire                       rs_mem_can_accept_i,
    output wire                       rs_mem_push_valid_o,
    output wire [`ROB_W-1:0]          rs_mem_push_robid_o,
    output wire [31:0]                rs_mem_push_pc_o,
    output wire [`MEM_OP_NUM-1:0]     rs_mem_push_mem_op_o,
    output wire                       rs_mem_push_is_cacop_o,
    output wire                       rs_mem_push_src0_ready_o,
    output wire [31:0]                rs_mem_push_src0_val_o,
    output wire [`ROB_W-1:0]          rs_mem_push_src0_robid_o,
    output wire                       rs_mem_push_src1_ready_o,
    output wire [31:0]                rs_mem_push_src1_val_o,
    output wire [`ROB_W-1:0]          rs_mem_push_src1_robid_o,
    output wire [31:0]                rs_mem_push_imm_o,

    // =============== rs_mdu 入站口 ===============
    input  wire                       rs_mdu_can_accept_i,
    output wire                       rs_mdu_push_valid_o,
    output wire [`ROB_W-1:0]          rs_mdu_push_robid_o,
    output wire [`ALU_OP_NUM-1:0]     rs_mdu_push_alu_op_o,    // 乘除位有效
    output wire [`CSR_OP_NUM-1:0]     rs_mdu_push_csr_op_o,
    output wire [13:0]                rs_mdu_push_csr_num_o,
    output wire [`TLB_OP_NUM-1:0]     rs_mdu_push_tlb_op_o,
    output wire [`WB_SRC_NUM-1:0]     rs_mdu_push_wb_src_op_o,
    output wire                       rs_mdu_push_src0_ready_o,
    output wire [31:0]                rs_mdu_push_src0_val_o,
    output wire [`ROB_W-1:0]          rs_mdu_push_src0_robid_o,
    output wire                       rs_mdu_push_src1_ready_o,
    output wire [31:0]                rs_mdu_push_src1_val_o,
    output wire [`ROB_W-1:0]          rs_mdu_push_src1_robid_o
);

// ---------------- 第一步：读 ROB 补操作数 ----------------
assign rob_raddr0_o = dis0_src0_robid_i;
assign rob_raddr1_o = dis0_src1_robid_i;
assign rob_raddr2_o = dis1_src0_robid_i;
assign rob_raddr3_o = dis1_src1_robid_i;

function cmt_hit;
    input [`ROB_W-1:0] id;
    begin
        cmt_hit = (cmt_wake0_valid_i && (cmt_wake0_robid_i == id))
                | (cmt_wake1_valid_i && (cmt_wake1_robid_i == id));
    end
endfunction

function [31:0] cmt_data;
    input [`ROB_W-1:0] id;
    begin
        if (cmt_wake0_valid_i && (cmt_wake0_robid_i == id)) cmt_data = cmt_wake0_data_i;
        else                                              cmt_data = cmt_wake1_data_i;
    end
endfunction

function [31:0] arf_read_fwd;
    input [4:0]  raddr;
    input [31:0] arf_raw;
    begin
        if (raddr === 5'b0)
            arf_read_fwd = 32'b0;
        else if (cmt_wake0_valid_i && (cmt_wake0_rd_i === raddr))
            arf_read_fwd = cmt_wake0_data_i;
        else if (cmt_wake1_valid_i && (cmt_wake1_rd_i === raddr))
            arf_read_fwd = cmt_wake1_data_i;
        else
            arf_read_fwd = arf_raw;
    end
endfunction

wire        s00_cmt = cmt_hit(dis0_src0_robid_i);
wire        s01_cmt = cmt_hit(dis0_src1_robid_i);
wire        s10_cmt = cmt_hit(dis1_src0_robid_i);
wire        s11_cmt = cmt_hit(dis1_src1_robid_i);

wire        s00_use_arf = !dis0_src0_ready_i && !s00_cmt && !rob_rrdy0_i
                        && (!rat_rbusy4_i || (rat_rnum4_i != dis0_src0_robid_i));
wire        s01_use_arf = !dis0_src1_ready_i && !s01_cmt && !rob_rrdy1_i
                        && (!rat_rbusy5_i || (rat_rnum5_i != dis0_src1_robid_i));
wire        s10_use_arf = !dis1_src0_ready_i && !s10_cmt && !rob_rrdy2_i
                        && (!rat_rbusy6_i || (rat_rnum6_i != dis1_src0_robid_i));
wire        s11_use_arf = !dis1_src1_ready_i && !s11_cmt && !rob_rrdy3_i
                        && (!rat_rbusy7_i || (rat_rnum7_i != dis1_src1_robid_i));

wire        s00_rdy = dis0_src0_ready_i | rob_rrdy0_i | s00_cmt | s00_use_arf;
wire [31:0] s00_val = s00_cmt           ? cmt_data(dis0_src0_robid_i)
                    : rob_rrdy0_i       ? rob_rdata0_i
                    : s00_use_arf       ? arf_read_fwd(dis0_src0_addr_i, arf_rdata4_i)
                    : dis0_src0_ready_i ? arf_read_fwd(dis0_src0_addr_i, arf_rdata4_i)
                    :                     32'b0;
wire        s01_rdy = dis0_src1_ready_i | rob_rrdy1_i | s01_cmt | s01_use_arf;
wire [31:0] s01_val = s01_cmt           ? cmt_data(dis0_src1_robid_i)
                    : rob_rrdy1_i       ? rob_rdata1_i
                    : s01_use_arf       ? arf_read_fwd(dis0_src1_addr_i, arf_rdata5_i)
                    : dis0_src1_ready_i ? arf_read_fwd(dis0_src1_addr_i, arf_rdata5_i)
                    :                     32'b0;
wire        s10_rdy = dis1_src0_ready_i | rob_rrdy2_i | s10_cmt | s10_use_arf;
wire [31:0] s10_val = s10_cmt           ? cmt_data(dis1_src0_robid_i)
                    : rob_rrdy2_i       ? rob_rdata2_i
                    : s10_use_arf       ? arf_read_fwd(dis1_src0_addr_i, arf_rdata6_i)
                    : dis1_src0_ready_i ? arf_read_fwd(dis1_src0_addr_i, arf_rdata6_i)
                    :                     32'b0;
wire        s11_rdy = dis1_src1_ready_i | rob_rrdy3_i | s11_cmt | s11_use_arf;
wire [31:0] s11_val = s11_cmt           ? cmt_data(dis1_src1_robid_i)
                    : rob_rrdy3_i       ? rob_rdata3_i
                    : s11_use_arf       ? arf_read_fwd(dis1_src1_addr_i, arf_rdata7_i)
                    : dis1_src1_ready_i ? arf_read_fwd(dis1_src1_addr_i, arf_rdata7_i)
                    :                     32'b0;

// ---------------- 第二步：路由决策 ----------------
wire slot0_alu = dis0_valid_i && dis0_futype_i[`FU_ALU];
wire slot0_mem = dis0_valid_i && dis0_futype_i[`FU_MEM];
wire slot0_mdu = dis0_valid_i && dis0_futype_i[`FU_MDU];
wire slot1_alu = dis1_valid_i && dis1_futype_i[`FU_ALU];
wire slot1_mem = dis1_valid_i && dis1_futype_i[`FU_MEM];
wire slot1_mdu = dis1_valid_i && dis1_futype_i[`FU_MDU];

// ALU 负载均衡：占用少的站优先（相等取 rs_alu0）
wire alu0_lighter = (rs_alu0_occupancy_i <= rs_alu1_occupancy_i);
wire both_alu     = slot0_alu && slot1_alu;
// 两条 ALU：槽 0 进轻站、槽 1 进另一站；一条 ALU：进可收且较轻的站
wire single_alu_sel0 = (rs_alu0_can_accept_i && rs_alu1_can_accept_i) ? alu0_lighter
                                                                      : rs_alu0_can_accept_i;
// 槽 X 进 rs_alu0 / rs_alu1 的选择
wire slot0_to_a0 = slot0_alu && ( both_alu ?  alu0_lighter : single_alu_sel0);
wire slot0_to_a1 = slot0_alu && ( both_alu ? !alu0_lighter : !single_alu_sel0);
wire slot1_to_a0 = slot1_alu && ( both_alu ? !alu0_lighter : single_alu_sel0);
wire slot1_to_a1 = slot1_alu && ( both_alu ?  alu0_lighter : !single_alu_sel0);

// ---------------- 第三步：按槽放行（mem/mdu 与 alu 互不阻塞） ----------------
wire mem_ok = (slot0_mem || slot1_mem) ? rs_mem_can_accept_i : 1'b1;
wire mdu_ok = (slot0_mdu || slot1_mdu) ? rs_mdu_can_accept_i : 1'b1;
wire go_both_alu = both_alu && rs_alu0_can_accept_i && rs_alu1_can_accept_i;
wire alu_one_ok  = rs_alu0_can_accept_i || rs_alu1_can_accept_i;

wire go_slot0 = dis0_valid_i && (
                    (slot0_mem && mem_ok) ||
                    (slot0_mdu && mdu_ok) ||
                    (slot0_alu && both_alu && go_both_alu) ||
                    (slot0_alu && !both_alu && alu_one_ok)
                );
wire go_slot1 = dis1_valid_i && (
                    (slot1_mem && mem_ok) ||
                    (slot1_mdu && mdu_ok) ||
                    (slot1_alu && both_alu && go_both_alu) ||
                    (slot1_alu && !both_alu && alu_one_ok)
                );

// rename 反压：dis 中每条有效指令各自 RS 可收才整体 ready
assign dispatch_ready_o = (!dis0_valid_i || go_slot0) && (!dis1_valid_i || go_slot1);

// ---------------- 第四步：push 信号拼装 ----------------
// rs_alu0
wire a0_sel1 = slot1_to_a0;   // 进 rs_alu0 的是槽 1
assign rs_alu0_push_valid_o      = (go_slot0 && slot0_to_a0) || (go_slot1 && slot1_to_a0);
assign rs_alu0_push_robid_o      = a0_sel1 ? dis1_robid_i  : dis0_robid_i;
assign rs_alu0_push_pc_o         = a0_sel1 ? dis1_pc_i     : dis0_pc_i;
assign rs_alu0_push_alu_op_o     = a0_sel1 ? dis1_alu_op_i : dis0_alu_op_i;
assign rs_alu0_push_br_op_o      = a0_sel1 ? dis1_br_op_i  : dis0_br_op_i;
assign rs_alu0_push_src0_ready_o = a0_sel1 ? s10_rdy : s00_rdy;
assign rs_alu0_push_src0_val_o   = a0_sel1 ? s10_val : s00_val;
assign rs_alu0_push_src0_robid_o = a0_sel1 ? dis1_src0_robid_i : dis0_src0_robid_i;
assign rs_alu0_push_src1_ready_o = a0_sel1 ? s11_rdy : s01_rdy;
assign rs_alu0_push_src1_val_o   = a0_sel1 ? s11_val : s01_val;
assign rs_alu0_push_src1_robid_o = a0_sel1 ? dis1_src1_robid_i : dis0_src1_robid_i;
assign rs_alu0_push_imm_o        = a0_sel1 ? dis1_imm_i     : dis0_imm_i;
assign rs_alu0_push_use_imm_o    = a0_sel1 ? dis1_use_imm_i : dis0_use_imm_i;
assign rs_alu0_push_br_offs_o    = a0_sel1 ? dis1_br_offs_i : dis0_br_offs_i;

// rs_alu1
wire a1_sel1 = slot1_to_a1;
assign rs_alu1_push_valid_o      = (go_slot0 && slot0_to_a1) || (go_slot1 && slot1_to_a1);
assign rs_alu1_push_robid_o      = a1_sel1 ? dis1_robid_i  : dis0_robid_i;
assign rs_alu1_push_pc_o         = a1_sel1 ? dis1_pc_i     : dis0_pc_i;
assign rs_alu1_push_alu_op_o     = a1_sel1 ? dis1_alu_op_i : dis0_alu_op_i;
assign rs_alu1_push_br_op_o      = a1_sel1 ? dis1_br_op_i  : dis0_br_op_i;
assign rs_alu1_push_src0_ready_o = a1_sel1 ? s10_rdy : s00_rdy;
assign rs_alu1_push_src0_val_o   = a1_sel1 ? s10_val : s00_val;
assign rs_alu1_push_src0_robid_o = a1_sel1 ? dis1_src0_robid_i : dis0_src0_robid_i;
assign rs_alu1_push_src1_ready_o = a1_sel1 ? s11_rdy : s01_rdy;
assign rs_alu1_push_src1_val_o   = a1_sel1 ? s11_val : s01_val;
assign rs_alu1_push_src1_robid_o = a1_sel1 ? dis1_src1_robid_i : dis0_src1_robid_i;
assign rs_alu1_push_imm_o        = a1_sel1 ? dis1_imm_i     : dis0_imm_i;
assign rs_alu1_push_use_imm_o    = a1_sel1 ? dis1_use_imm_i : dis0_use_imm_i;
assign rs_alu1_push_br_offs_o    = a1_sel1 ? dis1_br_offs_i : dis0_br_offs_i;

// rs_mem（至多一条）
wire m_sel1 = slot1_mem;
assign rs_mem_push_valid_o      = (go_slot0 && slot0_mem) || (go_slot1 && slot1_mem);
assign rs_mem_push_robid_o      = m_sel1 ? dis1_robid_i  : dis0_robid_i;
assign rs_mem_push_pc_o         = m_sel1 ? dis1_pc_i     : dis0_pc_i;
assign rs_mem_push_mem_op_o     = m_sel1 ? dis1_mem_op_i : dis0_mem_op_i;
assign rs_mem_push_is_cacop_o   = m_sel1 ? dis1_is_cacop_i : dis0_is_cacop_i;
assign rs_mem_push_src0_ready_o = m_sel1 ? s10_rdy : s00_rdy;
assign rs_mem_push_src0_val_o   = m_sel1 ? s10_val : s00_val;
assign rs_mem_push_src0_robid_o = m_sel1 ? dis1_src0_robid_i : dis0_src0_robid_i;
assign rs_mem_push_src1_ready_o = m_sel1 ? s11_rdy : s01_rdy;
assign rs_mem_push_src1_val_o   = m_sel1 ? s11_val : s01_val;
assign rs_mem_push_src1_robid_o = m_sel1 ? dis1_src1_robid_i : dis0_src1_robid_i;
assign rs_mem_push_imm_o        = m_sel1 ? dis1_imm_i : dis0_imm_i;

// rs_mdu（至多一条）
wire d_sel1 = slot1_mdu;
assign rs_mdu_push_valid_o      = (go_slot0 && slot0_mdu) || (go_slot1 && slot1_mdu);
assign rs_mdu_push_robid_o      = d_sel1 ? dis1_robid_i  : dis0_robid_i;
assign rs_mdu_push_alu_op_o     = d_sel1 ? dis1_alu_op_i : dis0_alu_op_i;
assign rs_mdu_push_csr_op_o     = d_sel1 ? dis1_csr_op_i : dis0_csr_op_i;
assign rs_mdu_push_csr_num_o    = d_sel1 ? dis1_csr_num_i : dis0_csr_num_i;
assign rs_mdu_push_tlb_op_o     = d_sel1 ? dis1_tlb_op_i : dis0_tlb_op_i;
assign rs_mdu_push_wb_src_op_o  = d_sel1 ? dis1_wb_src_op_i : dis0_wb_src_op_i;
assign rs_mdu_push_src0_ready_o = d_sel1 ? s10_rdy : s00_rdy;
assign rs_mdu_push_src0_val_o   = d_sel1 ? s10_val : s00_val;
assign rs_mdu_push_src0_robid_o = d_sel1 ? dis1_src0_robid_i : dis0_src0_robid_i;
assign rs_mdu_push_src1_ready_o = d_sel1 ? s11_rdy : s01_rdy;
assign rs_mdu_push_src1_val_o   = d_sel1 ? s11_val : s01_val;
assign rs_mdu_push_src1_robid_o = d_sel1 ? dis1_src1_robid_i : dis0_src1_robid_i;

wire dis0_hand = go_slot0;
wire dis1_hand = go_slot1;
assign dis0_handed_o = dis0_hand;
assign dis1_handed_o = dis1_hand;
assign dis_handed_o  = dis0_hand || dis1_hand;

endmodule
