// ============================================================
// rs_alu 模块（ALU 保留站，`RS_ALU_SIZE=4 项，乱序发射，顶层例化 2 份）
// ------------------------------------------------------------
// 功能：
// - 缓存等待操作数的 ALU/分支指令；监听 4 路写回唤醒总线捕获操作数；
//   每拍从"两个操作数都就绪"的项中选出"最老的"一条发射给 fu_alu。
// - 乱序发射是本架构 IPC 的最大来源（mariver 实证 +17%）：
//   后进入的指令只要操作数先就绪就可以先执行。
// - "唤醒"与"数据"分离的概念（重要！）：
//   * 唤醒（wakeup）：得知"某 robid 的结果即将/已经可用"，置 ready 位；
//   * 数据捕获（capture）：从写回总线上把 32bit 数据真正存进本项。
//   一期两者同拍完成（写回唤醒）；二期提前唤醒时两者分离
//   （唤醒早 1~2 拍，数据靠发射时旁路网络补）。
//
// 端口：
// - push_*          ：dispatch 入站口（一拍最多 1 条）
// - can_accept/occupancy ：空位信息
// - wb0~3_*         ：4 路写回唤醒总线（alu0/alu1/mem/mdu）
// - early0~2_*      ：3 路提前唤醒总线（二期：alu0 发射/alu1 发射/lsu AGU）
// - issue_*         ：发射口（到 fu_alu，ALU 恒可接收）
// - flush_i         ：全局冲刷清空
// ============================================================
`include "mycpu.h"

module rs_alu(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // ---------------- 入站（dispatch）----------------
    input  wire                       push_valid_i,
    input  wire [`ROB_W-1:0]          push_robid_i,
    input  wire [31:0]                push_pc_i,
    input  wire [`ALU_OP_NUM-1:0]     push_alu_op_i,
    input  wire [`BR_OP_NUM-1:0]      push_br_op_i,
    input  wire                       push_src0_ready_i,
    input  wire [31:0]                push_src0_val_i,
    input  wire [`ROB_W-1:0]          push_src0_robid_i,
    input  wire                       push_src1_ready_i,
    input  wire [31:0]                push_src1_val_i,
    input  wire [`ROB_W-1:0]          push_src1_robid_i,
    input  wire [31:0]                push_imm_i,
    input  wire                       push_use_imm_i,
    input  wire [31:0]                push_br_offs_i,

    output wire                       can_accept_o,      // 有空位
    output wire [2:0]                 occupancy_o,       // 当前占用项数（dispatch 负载均衡）

    // ---------------- 写回唤醒总线 ×4（带数据）----------------
    input  wire                       wb0_valid_i,       // fu_alu0 写回
    input  wire [`ROB_W-1:0]          wb0_robid_i,
    input  wire [31:0]                wb0_data_i,
    input  wire                       wb1_valid_i,       // fu_alu1 写回
    input  wire [`ROB_W-1:0]          wb1_robid_i,
    input  wire [31:0]                wb1_data_i,
    input  wire                       wb2_valid_i,       // lsu 写回
    input  wire [`ROB_W-1:0]          wb2_robid_i,
    input  wire [31:0]                wb2_data_i,
    input  wire                       wb3_valid_i,       // fu_mdu 写回
    input  wire [`ROB_W-1:0]          wb3_robid_i,
    input  wire [31:0]                wb3_data_i,

    // ---------------- 提前唤醒总线 ×3（无数据，二期接入）----------------
    input  wire                       early0_valid_i,    // fu_alu0 发射拍唤醒
    input  wire [`ROB_W-1:0]          early0_robid_i,
    input  wire                       early1_valid_i,    // fu_alu1 发射拍唤醒
    input  wire [`ROB_W-1:0]          early1_robid_i,
    input  wire                       early2_valid_i,    // lsu AGU 级投机唤醒
    input  wire [`ROB_W-1:0]          early2_robid_i,

    // ---------------- 发射口（到 fu_alu，组合）----------------
    output wire                       issue_valid_o,
    output wire [`ROB_W-1:0]          issue_robid_o,
    output wire [31:0]                issue_pc_o,
    output wire [`ALU_OP_NUM-1:0]     issue_alu_op_o,
    output wire [`BR_OP_NUM-1:0]      issue_br_op_o,
    output wire [31:0]                issue_src0_o,      // 已捕获的最终操作数值
    output wire [31:0]                issue_src1_o,
    output wire [31:0]                issue_imm_o,
    output wire                       issue_use_imm_o,
    output wire [31:0]                issue_br_offs_o
);

//TODO: 实现 4 项乱序发射保留站（参考：mariver station.v 的 ALU 保留站部分，
//      含 prior 时间戳选择逻辑 388~398 行、唤醒 659~666 行、旁路 479~533 行）
//
//TODO: 存储结构（每项，全 reg）：
//      valid, robid[`ROB_W], pc[32], alu_op[21], br_op[9],
//      s0_ready, s0_val[32], s0_robid[`ROB_W],
//      s1_ready, s1_val[32], s1_robid[`ROB_W],
//      imm[32], use_imm, br_offs[32],
//      prior[1:0]   // 年龄时间戳：新入站项=3，有项发射后其余项-1（数值小=老）
//
//TODO: 入站：
//      can_accept_o = 有 valid=0 的空项；occupancy_o = valid 计数。
//      push 时写第一个空项，prior 置最大（最年轻）。
//
//TODO: 唤醒与数据捕获（每项每源监听 4 路 wb 总线）：
//      if (!sX_ready && wbN_valid && wbN_robid==sX_robid) begin
//          sX_ready <= 1;  sX_val <= wbN_data;
//      end
//      同拍入站+唤醒：push 数据进来的同拍总线上恰有它等的 robid ——
//      入站数据要先过一遍同样的旁路比较再写入（mariver 的 bypassin 逻辑），
//      否则错过唤醒永远等不到（经典死锁坑！）。
//
//TODO: 发射选择（组合，oldest-first）：
//      cand[i] = valid[i] && s0_ready[i] && s1_ready[i];
//      从 cand 中选 prior 最小（最老）的一项：4 项规模直接两两比较即可。
//      issue_valid_o = |cand；发射项的字段接到 issue_* 上。
//      发射成功（ALU 恒接收）当拍清该项 valid；其余项 prior 维护：
//      比发射项年轻的项 prior-1（或用"发射后全体未满最大值的项-1"的简化策略）。
//
//TODO: 提前唤醒（二期，顶层总线已连好）：
//      early 总线只置 sX_ready，不带数据；数据在"发射到执行"的路径上由
//      旁路网络补（fu_alu 入口处再比一次 4 路 wb 总线把值换进来）。
//      一期实现可直接忽略 early0~2 输入（fu/lsu 侧输出恒 0），功能完全正确。
//
//TODO: 冲刷：flush_i 时 valid 全清。
//
//TODO: 坑点提示：
//      1. 唤醒比较器数量 = 项数(4) × 源数(2) × 总线数(4) = 32 个 5bit 比较器/站，
//         这是乱序核的固有开销，注意写成 generate-for 保持代码整洁。
//      2. "选最老"不能用 robid 直接比大小（环形编号会回绕）！必须用 prior
//         时间戳（入站顺序计数），mariver 用 2bit prior 即可覆盖 4 项。
//      3. 发射口是组合输出，fu_alu 当拍锁存——发射项的 val 字段若本拍刚被
//         总线唤醒写入（非阻塞赋值未生效），需要把"本拍唤醒的新值"组合旁路
//         到 issue_src 上（即 issue 数据 = 旧值与本拍总线值的二选一）。

endmodule
