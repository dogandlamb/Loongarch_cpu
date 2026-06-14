// ============================================================
// fu_alu 模块（ALU 执行单元，单周期，含分支判断；顶层例化 2 份）
// ------------------------------------------------------------
// 功能：
// - 接收 rs_alu 发射的指令，一拍完成：
//   * 普通算术逻辑运算（内部例化原有 alu.v 组合核，乘除已迁出到 fu_mdu）
//   * 分支：判方向（beq/bne/blt/bge/bltu/bgeu）、算目标
//     （条件分支/B/BL: pc+offs；jirl: src0+offs）、算链接值（pc+4）
// - 写回 ROB：结果 + 分支实际方向/实际目标（提交级据此判误预测）。
// - 发射拍对外广播提前唤醒（robid），缩短背靠背 RAW 延迟（二期接通）。
// - 二期预留执行级重定向输出（误预测当拍冲前端，配合 RAT 检查点）。
//
// 端口：
// - issue_*     ：rs_alu 发射口直连（组合进入，本模块内部锁存一拍执行）
// - wb_*        ：写回 ROB（含分支实际行为）
// - early_wakeup_* ：发射拍唤醒广播（二期）
// - ex_redirect_*  ：执行级重定向（二期，一期恒 0）
// ============================================================
`include "mycpu.h"

module fu_alu(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // ---------------- 发射入口（来自 rs_alu，组合）----------------
    input  wire                       issue_valid_i,
    input  wire [`ROB_W-1:0]          issue_robid_i,
    input  wire [31:0]                issue_pc_i,
    input  wire [`ALU_OP_NUM-1:0]     issue_alu_op_i,
    input  wire [`BR_OP_NUM-1:0]      issue_br_op_i,
    input  wire [31:0]                issue_src0_i,
    input  wire [31:0]                issue_src1_i,
    input  wire [31:0]                issue_imm_i,
    input  wire                       issue_use_imm_i,
    input  wire [31:0]                issue_br_offs_i,

    // ---------------- 写回 ROB ----------------
    output wire                       wb_valid_o,
    output wire [`ROB_W-1:0]          wb_robid_o,
    output wire [31:0]                wb_data_o,         // 运算结果 / 链接值(pc+4)
    output wire                       wb_br_taken_o,     // 分支实际方向（非分支恒 0）
    output wire [31:0]                wb_br_target_o,    // 分支实际目标（taken 时有效）

    // ---------------- 提前唤醒广播（发射拍，二期接入 RS）----------------
    output wire                       early_wakeup_valid_o,
    output wire [`ROB_W-1:0]          early_wakeup_robid_o,

    // ---------------- 二期：执行级重定向（一期输出恒 0）----------------
    output wire                       ex_redirect_valid_o,
    output wire [31:0]                ex_redirect_pc_o
);

//TODO: 实现单周期 ALU 执行单元（参考：mariver fu_alu.v 的 Issue/Execute 流水组织）
//
//TODO: 推荐流水组织（一级执行寄存器）：
//      发射拍：issue_* 组合到来 -> 当拍锁存进执行寄存器（ex_valid/ex_robid/操作数...）；
//      执行拍：用执行寄存器组合计算 -> wb_* 输出（wb 即执行寄存器+组合云的输出）。
//      flush_i 时清 ex_valid（在飞的这条作废——它属于错误路径或已无意义，
//      提交级冲刷语义下 ROB 也清了，写回丢弃无害，但干脆不写最干净）。
//
//TODO: 运算核：
//      例化原有 alu.v 做普通运算（注意 alu.v 的乘除逻辑已声明迁出，见其 TODO；
//      本模块只用它的组合结果口）：
//        alu u_alu(.alu_op(ex_alu_op), .alu_src1(ex_src0),
//                  .alu_src2(ex_use_imm ? ex_imm : ex_src1), .alu_result(...) ...);
//      链接类（bl/jirl 写 rd = pc+4）：结果选择 pc+4（原设计在 alu_op 里有对应处理，
//      或者在本模块直接旁路：is_link ? ex_pc+4 : alu_result）。
//
//TODO: 分支处理（ex 拍组合）：
//      方向：beq: src0==src1；bne: !=；blt/bge: 有符号比较；bltu/bgeu: 无符号；
//            b/bl/jirl: 恒 taken。
//      目标：jirl: (src0 + br_offs) & ~1；其余: pc + br_offs。
//      wb_br_taken_o / wb_br_target_o 随写回送 ROB 存储，提交级与预测比对。
//
//TODO: 提前唤醒（二期）：
//      early_wakeup_valid_o = issue_valid_i（发射拍即广播 robid）；
//      顶层总线已连到各保留站的 early 输入；一期本模块可先输出恒 0
//      （RS 侧也按恒 0 处理），二期两端同时启用即可，不影响正确性。
//
//TODO: 坑点提示：
//      1. wb 与 RS 唤醒/ROB 写回是同一组信号（顶层广播），位宽/时序保持一拍有效。
//      2. 两个 fu_alu 实例完全相同，分支可能在任意一个里执行（dispatch 负载均衡），
//         提交级不关心是哪个 ALU 算的（ROB 写回口分 alu0/alu1 两路）。

endmodule
