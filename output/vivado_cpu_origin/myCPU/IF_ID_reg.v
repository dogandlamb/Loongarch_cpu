module IF_ID_reg(
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,
    input  wire        readyGo,
    input  wire        allowIn,

    input  wire [31:0] inst_in,


    output reg  [31:0] inst_out
);
// ============================================================
// 模块功能：
// IF/ID 流水寄存器。用于在 IF 与 ID 之间锁存取指结果 inst，
// 依据 valid/readyGo/allowIn 控制更新时机，实现停顿时保持数据稳定。
//
// 端口定义：
// - 时序与握手输入：
//   - clk     : 时钟信号。
//   - reset   : 复位信号。
//   - valid   : IF 阶段输出有效标志。
//   - readyGo : 本级就绪标志。
//   - allowIn : 下一级允许写入标志。
// - 数据输入：
//   - inst_in : IF 阶段输出指令。
// - 数据输出：
//   - inst_out : 锁存后的指令，送入 ID 阶段。
//
// TODO ：
// 实现时序逻辑：valid && readyGo && allowIn 时更新 inst_out。
// 定义 reset 时 inst_out 的初值（也许是0）。
// ============================================================
endmodule