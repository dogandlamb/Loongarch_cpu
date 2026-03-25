module IFport (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,
    input  wire [31:0] inst_in,//输入的指令
    input  wire [31:0] pc_in,//输入的pc地址

    output reg         readyGo,
    output reg         allowIn,

    output reg  [31:0] inst_out,
    output reg  [31:0] pc_out
);
// ============================================================
// 模块功能：
// IF 取指阶段。根据 PC 从指令存储器中取出指令，处理分支跳转，
// 完成 PC 更新，并输出指令给 ID 译码阶段。
//
// 端口定义：
// - 时序与握手：
//   - clk     : 时钟信号。
//   - reset   : 复位信号(同步)。
//   - valid   : 当前 IF 级输入有效标志。
// - 地址、指令输入
//   - inst_in : 输入的指令。
//   - pc_in   : 输入的 PC 地址。
//
// - 控制信号输出（送往 IF_ID_reg）：
//   - readyGo : IF 级是否准备好把指令送到下一级。
//   - allowIn : IF 级是否允许上游写入（通常由下游反压）。
// - 指令输出（送往 IF_ID_reg）：
//   - inst_out : 取出的 32 位指令。
//   - pc_out   : 当前指令对应的 PC 值（供后续级使用）。
//
// - 工作流程!!!!!!!：
//   1. pc_in -> pc_out：将输入的 PC 地址传递给下一级。
//   2. pc_out -> 外部的指令存储器：根据 pc_out 从指令存储器读取指令，得到 inst_in。
//   3. inst_in -> inst_out：将读取到的指令传递给下一级。
//
// 工作流程：
// 1. 维护 PC 寄存器，初值为程序入口地址（通常为 0x0000_0000）。
// 2. 当接收到 br_taken 信号时，PC 更新为 br_addr（分支跳转）。
// 3. 否则 PC 递增 4（顺序执行）。
// 4. 根据当前 PC 从指令存储器（IMEM）读取指令。
// 5. 输出 inst 和 pc_out 给下一级，同时管理 readyGo/allowIn 握手。
//
// TODO ：
// 实现 PC 寄存器与更新逻辑（br_taken ? br_addr : pc + 4）。
// 实现指令存储器访问（与 ROM/IMEM 模块的接口）。
// 完成 readyGo/allowIn 握手逻辑（通常一个周期内 ready）。
// 处理 reset 时的 PC 初始化。
// ============================================================
endmodule
