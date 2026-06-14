// ============================================================
// div 模块（CLZ 快速移位除法器，迭代式）
// ------------------------------------------------------------
// 功能：
// - 完成 32/32 位有符号/无符号除法与取模，供 div.w/div.wu/mod.w/mod.wu。
// - 核心优化（满洋/mariver 实证路线）：朴素恢复余数除法固定 32 拍；
//   先用 CLZ（前导零计数）把除数对齐到被除数的最高位，跳过无效迭代，
//   则迭代次数 = clz(divisor) - clz(dividend) + 1 ——
//   竞赛 benchmark 中操作数普遍很小，常见 5~10 拍出结果，IPC 收益明显。
//
// 端口：
// - valid_i / 操作数 / is_signed_i ：启动一次除法
// - quotient_o / remainder_o / done_o / busy_o
// - flush_i：全局冲刷时打断迭代（必须支持！）
// ============================================================

module div(
    input  wire          clk,
    input  wire          reset,
    input  wire          flush_i,        // 冲刷打断（作废当前迭代）

    input  wire          valid_i,        // 启动
    input  wire [31:0]   dividend_i,     // 被除数
    input  wire [31:0]   divisor_i,      // 除数
    input  wire          is_signed_i,    // 1=有符号

    output wire [31:0]   quotient_o,     // 商
    output wire [31:0]   remainder_o,    // 余数
    output wire          done_o,         // 结果有效一拍
    output wire          busy_o          // 迭代中
);

//TODO: 实现 CLZ 快速除法（参考：满洋 muldiv/div_unit.sv + clz.sv 的思路）
//
//TODO: 第一步——符号预处理：
//      有符号除法转无符号：记下商/余数的符号（商符号 = 两操作数符号异或，
//      余数符号 = 被除数符号），操作数取绝对值后按无符号迭代，结束后修正符号。
//
//TODO: 第二步——CLZ 对齐：
//      shift = clz(divisor_abs) - clz(dividend_abs)（<0 则商=0 余=被除数，直接完成）；
//      divisor 左移 shift 位对齐，迭代次数 = shift+1。
//      clz 用 5 级组合（16/8/4/2/1 分段）实现，写成 function。
//
//TODO: 第三步——迭代（每拍 1 位，标准恢复余数法）：
//      余数试减对齐后的除数：减得动 -> 商位 1，否则商位 0；除数右移一位；
//      计数到 0 -> done。可选每拍 2 位（radix-4）再砍一半拍数（二期）。
//
//TODO: 特殊情况（LA 规范：除 0 不触发异常，结果为无定义值，但要和 NEMU 对齐！）：
//      除 0：商 = 0xFFFFFFFF（无符号）/ -1（有符号），余数 = 被除数
//      （与 chiplab difftest 的 NEMU 行为对齐，旧 alu.v 中有现成的特殊值处理
//        逻辑可以参考/搬运——见旧文件 git 历史或直接按上述规则写）。
//      有符号溢出：0x80000000 / -1 -> 商 = 0x80000000，余 = 0。
//
//TODO: flush_i：迭代立即作废（busy 清 0，不产生 done），fu_mdu 状态机同步复位。
//
//TODO: 保底方案：先用 Vivado div_gen IP（固定长延迟）顶上跑通功能，
//      再换本实现提性能——但注意 IP 在 verilator 下仿真很麻烦，
//      建议直接写朴素 32 拍迭代版（很简单）作为第一版，再加 CLZ 优化。

endmodule
