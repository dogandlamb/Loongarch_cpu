module IDport (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,


    input  wire [31:0] inst,

    output reg         allowIn,
    output reg         readyGo,
    
    output reg  [4:0]  src1_addr,
    output reg  [4:0]  src2_addr,

    output reg  [4:0]  wb_reg_addr,
    output reg  [31:0] alu_src1,
    output reg  [31:0] alu_src2,
    output reg  [31:0] br_imm,
    output reg  [11:0] alu_op,
    output reg  [ 4:0] br_op,
    output reg  [ 1:0] mem_op  //memory operation, added by sssafridi

);
// ============================================================
// 模块功能：
// ID 译码阶段。输入指令后完成寄存器地址解析、立即数/分支信息生成、
// ALU 控制信号生成，并输出给 EXE 前级寄存器。
//
// 端口定义：
// - 时序与握手：
//   - clk     : 时钟信号。
//   - reset   : 复位信号。
//   - valid   : 当前 ID 级输入有效标志。
//   - allowIn : ID 级是否允许上游写入。
//   - readyGo : ID 级是否可向下游传递。
// - 输入：
//   - inst : 待译码的 32 位指令。
// - 输出（寄存器读地址）：
//   - src1_addr : 源寄存器 1 地址（读寄存器堆端口 A）。
//   - src2_addr : 源寄存器 2 地址（读寄存器堆端口 B）。
// - 输出（送往 EXE）：
//   - wb_reg_addr : 目的寄存器地址。
//   - alu_src1    : ALU 源操作数 1。
//   - alu_src2    : ALU 源操作数 2。
//   - br_imm      : 分支立即数/偏移量。
//   - alu_op      : ALU 操作控制码。
//   - br_op       : 分支控制码。
//   - mem_op      : 访存控制。
//
// TODO 清单（可分工）：
// 完成指令字段拆解（opcode、func、寄存器号、立即数）。
// 完成控制信号译码表（alu_op / br_op / wb_reg_addr）。
// 完成 alu_src1/alu_src2 选择逻辑（寄存器值、PC、立即数等来源）。
// 实现 readyGo/allowIn 
// ============================================================
endmodule