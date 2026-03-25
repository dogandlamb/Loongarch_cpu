module IDport (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,


    input  wire [31:0] inst,
    input  wire [31:0] src1_rdata,
    input  wire [31:0] src2_rdata,

    input  wire [31:0] reg_rdata1,
    input  wire [31:0] reg_rdata2,

    output reg         allowIn,
    output reg         readyGo,
    
    output reg  [4:0]  src1_addr,
    output reg  [4:0]  src2_addr,

    output reg  [ 4:0] wb_reg_addr,
    output reg  [ 4:0] alu_src1,
    output reg  [ 4:0] alu_src2,
    output reg  [31:0] br_imm,
    output reg  [11:0] alu_op,
    output reg  [ 4:0] br_op,
    output reg  [ 1:0] mem_op,  //memory operation, added by sssafridi
    output reg  [31:0] mem_wdata,
    output reg         wb_op

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
//   - allowIn : 本级是否允许上一级写入新数据。
//   - readyGo : 本级是否已就绪，可向下一级传递数据。
// - 输入：
//   - inst : 待译码的 32 位指令。
//   - src1_rdata : 源寄存器 1 读数据（来自 regfile）。
//   - src2_rdata : 源寄存器 2 读数据（来自 regfile）。
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
//   - wb_op       : 写回使能控制。
//
// TODO：
// 1) 译码：补全指令覆盖并维护 inst_dec/op_dec 对齐关系（就是位宽对齐）。
// 2) 数据：完善 mem_op/wb_op 编码规范文档。
// 3) 流水：在需要时接入真实反压（当前可先常开）。
// 4) 验证：指令到控制信号的一致性。
// ============================================================
endmodule