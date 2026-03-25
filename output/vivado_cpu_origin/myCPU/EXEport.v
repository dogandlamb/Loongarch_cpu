module EXEport (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,

    output reg         readyGo,
    output reg         allowIn,

    output reg         br_taken,

    input wire  [4:0]  wb_reg_addr,
    input wire  [31:0] alu_src1,
    input wire  [31:0] alu_src2,
    input wire  [31:0] br_imm,
    input wire  [11:0] alu_op,
    input wire  [ 4:0] br_op,
    input wire  [31:0] mem_wdata_in,

    output reg [31:0] final_result,
    output reg [ 4:0] wb_reg_addr_out,
    output reg [ 1:0] mem_op,
    output reg [31:0] mem_wdata_out,
    output reg        wb_op
);
// ============================================================
// 模块功能：
// EXE 执行阶段。根据译码阶段给出的 ALU/分支控制信息完成运算，
// 生成执行结果、分支是否跳转信号，以及后续 MEM/WB 所需控制信息。
//
// 端口定义：
// - 时序与握手：
//   - clk     : 时钟信号。
//   - reset   : 复位信号。
//   - valid   : 当前 EXE 级输入有效。
//   - readyGo : EXE 级是否准备好把数据送到下一级。
//   - allowIn : EXE 级是否允许上一级写入。
// - 分支输出：
//   - br_taken : 分支是否成立（供前端重定向 PC 参考）。
// - 输入（来自 ID/ID_EXE_reg）：
//   - wb_reg_addr : 目的寄存器地址。
//   - alu_src1    : ALU 源操作数 1。
//   - alu_src2    : ALU 源操作数 2。
//   - br_imm      : 分支立即数/偏移量。
//   - alu_op      : ALU 操作控制码。
//   - br_op       : 分支类型控制码。
// - 输出（送往 EXE_MEM_reg）：
//   - final_result   : 执行阶段输出结果。
//   - wb_reg_addr_out: 目的寄存器地址透传/修正值。
//   - mem_op         : 访存操作类型（供 MEM 阶段使用）。
//   - wb_op          : 写回使能标志。
//
// TODO ：
// 完成 ALU 运算组合逻辑（按 alu_op 编码）。
// 完成分支判定逻辑（按 br_op 编码）并驱动 br_taken。
// 定义并生成 mem_op/wb_op 输出策略（算术、访存、无写回指令）。
// 完成 readyGo/allowIn 策略（是否单周期 ready 或支持多周期运算）。
// EXE 阶段：算术、逻辑、比较、分支边界。
// ============================================================
endmodule