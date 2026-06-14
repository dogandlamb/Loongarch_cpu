// ============================================================
// mul 模块（32x32 流水乘法器，DSP 实现，2~3 级流水）
// ------------------------------------------------------------
// 功能：
// - 完成 32x32 -> 64 位有符号/无符号乘法，供 mul.w / mulh.w / mulh.wu 使用。
// - 用 FPGA 的 DSP48 硬核：要么直接写 `a*b` 让综合器推断 DSP 并手动
//   打 2~3 级流水寄存器，要么例化 Vivado mult_gen IP（两种都可以，
//   推断写法对 chiplab/verilator 仿真更友好，推荐）。
//
// 端口：
// - valid_i / a_i / b_i / is_signed_i ：启动一次乘法
// - result_o / done_o                 ：固定 N 拍后结果有效一拍
// ============================================================

module mul(
    input  wire          clk,
    input  wire          reset,

    input  wire          valid_i,       // 启动（fu_mdu 保证 busy 期间不重复启动）
    input  wire [31:0]   a_i,
    input  wire [31:0]   b_i,
    input  wire          is_signed_i,   // 1=有符号（mul.w/mulh.w），0=无符号（mulh.wu）

    output wire [63:0]   result_o,      // 64 位全乘积
    output wire          done_o         // 结果有效（启动后固定拍数）
);

//TODO: 推荐实现（综合器推断 DSP + 流水寄存器，约 30 行）：
//      1) 符号扩展到 33 位：a33 = {is_signed & a[31], a}; b33 同理；
//      2) 一级寄存输入，二级算 prod <= $signed(a33_r) * $signed(b33_r)，
//         三级寄存输出 —— 共 3 拍延迟，Vivado 会自动映射 DSP48 级联；
//      3) done_o 用一个 2~3 位移位寄存器跟踪 valid_i 延迟拍数。
//
//TODO: 替代实现（Vivado IP）：
//      例化 mult_gen（配置 33x33 有符号、流水级 3），端口对接即可；
//      注意 chiplab/verilator 仿真需要 IP 仿真模型，麻烦，故不推荐。
//
//TODO: 坑点提示：
//      1. mulh.wu 必须按无符号算——用"33 位带符号位扩展"统一处理有/无符号
//         （无符号时符号位补 0），一个乘法器搞定三条指令。
//      2. 流水期间 fu_mdu 不会发新请求（非流水包装），不必处理背靠背。

endmodule
