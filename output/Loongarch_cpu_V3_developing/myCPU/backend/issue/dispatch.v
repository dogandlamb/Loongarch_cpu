// ============================================================
// dispatch 模块（分发级：读 ROB 补操作数 + 按 FU 类型路由进保留站）
// ------------------------------------------------------------
// 功能：
// - 接收 rename 流水寄存器中的两条指令，做两件事：
//   1) 操作数补全：源操作数 ready=0 的，用其 ROB 编号读 ROB ——
//      若该编号的指令已写回（ROB ready），直接取到值（ready 变 1）；
//      仍未写回的，带着编号进保留站等唤醒。
//   2) 按 futype 路由进 4 个保留站：
//      FU_ALU -> rs_alu0 / rs_alu1（双 ALU 负载均衡：选剩余容量大的）
//      FU_MEM -> rs_mem（一拍最多进 1 条）
//      FU_MDU -> rs_mdu（一拍最多进 1 条）
// - 本级纯组合（rename 的流水寄存器就是本级的输入寄存器）。
//
// 端口：
// - dis0/dis1_*      ：rename 流水寄存器输出（两槽指令）
// - rob_raddr/rrdy/rdata ：ROB 4 个操作数读口
// - rs_alu0/1、rs_mem、rs_mdu 的入站口（bundle 见各 RS 模块）
// - rs_*_can_accept / occupancy ：各 RS 空位信息
// - dispatch_ready_o ：本拍两条是否都能入站（反压 rename）
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
    input  wire                       dis0_src1_ready_i,
    input  wire [31:0]                dis0_src1_val_i,
    input  wire [`ROB_W-1:0]          dis0_src1_robid_i,
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
    input  wire                       dis1_src1_ready_i,
    input  wire [31:0]                dis1_src1_val_i,
    input  wire [`ROB_W-1:0]          dis1_src1_robid_i,
    input  wire [31:0]                dis1_imm_i,
    input  wire                       dis1_use_imm_i,
    input  wire [31:0]                dis1_br_offs_i,

    output wire                       dispatch_ready_o,    // 两条都能入站（反压 rename）

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

//TODO: 实现分发逻辑（纯组合；参考：mariver dispatch.v 137~243 行）
//
//TODO: 第一步——读 ROB 补操作数：
//      rob_raddr0~3 直接接 4 个源的 robid；
//      最终就绪/值（以槽0 src0 为例）：
//        ready = dis0_src0_ready_i | rob_rrdy0_i;
//        val   = dis0_src0_ready_i ? dis0_src0_val_i : rob_rdata0_i;
//        robid 原样带走（没 ready 的在 RS 里等唤醒）。
//      注意 ROB 读口内部已带"同拍 FU 写回旁路"（rob.v 实现），这里无需再旁路。
//
//TODO: 第二步——路由决策（组合）：
//      slot0_is_alu/mem/mdu = dis0_futype_i 独热位；slot1 同理。
//      ALU 负载均衡（两条都是 ALU 时）：槽0 进占用少的那个 RS，槽1 进另一个；
//      只有一条 ALU 时：进占用少且 can_accept 的 RS（mariver alucap 比较）。
//      MEM/MDU：每拍每站最多 1 条；两条同类时本拍只发槽 0（槽 1 等下一拍，
//      见第三步的"全收或全停"约定——一期从简）。
//
//TODO: 第三步——dispatch_ready_o（一期"全收或全停"约定，最简单且无半发状态）：
//      dispatch_ready_o = 所有 valid 槽都能在本拍入站：
//        - 两条 ALU：rs_alu0_can_accept && rs_alu1_can_accept
//        - 一条 ALU：rs_alu0/1 至少一个 can_accept
//        - MEM/MDU 槽：对应 RS can_accept，且两槽不同类（两条同 MEM/同 MDU -> not ready）
//      ready=0 时所有 push_valid 必须为 0（rename 流水寄存器保持，下拍重试）。
//      //二期优化 TODO：mask 部分分发（mariver mask0/mask1 机制——先发能发的，
//        记录已发标记，剩下的下拍再发；能提升 RS 利用率，但要在 rename 流水
//        寄存器加 per-slot issued 标记，建议框架跑通后再做）。
//
//TODO: 第四步——push 信号拼装：
//      把对应槽的字段（含第一步补全后的 src ready/val）按路由结果接到
//      rs_*_push_* 上；未选中的 RS push_valid=0。
//
//TODO: 坑点提示：
//      1. 本级为纯组合，dispatch_ready_o 会反压 rename 的 can_go ——
//         不要在该环路里引入 RS 的 issue 信号（用"项数<容量"判 can_accept，
//         不要用"本拍发射后会空出一项"做超前判断，避免组合环）。
//      2. 两槽指令路由进两个 ALU RS 时，槽 0（更老）建议进占用多的站也可以——
//         顺序无关紧要，RS 内部按 robid 年龄选择发射；负载均衡只为吞吐。

endmodule
