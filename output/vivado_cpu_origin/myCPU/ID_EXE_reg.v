module ID_EXE_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,
    input  wire        readyGo,
    input  wire        allowIn,

    input wire  [4:0]  wb_reg_addr_in,
    input wire  [31:0] alu_src1_in,
    input wire  [31:0] alu_src2_in,
    input wire  [31:0] br_imm_in,
    input wire  [11:0] alu_op_in,
    input wire  [ 4:0] br_op_in,
    input wire  [31:0] mem_wdata_in,

    output reg  [4:0]  wb_reg_addr_out,
    output reg  [31:0] alu_src1_out,
    output reg  [31:0] alu_src2_out,
    output reg  [31:0] br_imm_out,
    output reg  [11:0] alu_op_out,
    output reg  [31:0] mem_wdata_out,
    output reg  [ 4:0] br_op_out

);
// ============================================================
// 模块功能：
// ID/EXE 流水寄存器。负责将 ID 阶段译码得到的操作数和控制信号
// 在握手成功时锁存并传递给 EXE 阶段。
//
// 端口定义：
// - 时序与握手输入：
//   - clk     : 时钟信号。
//   - reset   : 复位信号。
//   - valid   : ID 输出有效标志。
//   - readyGo : 本级就绪标志。
//   - allowIn : 下级允许写入标志。
// - 输入（来自 ID）：
//   - wb_reg_addr_in : 目的寄存器地址。
//   - alu_src1_in    : ALU 源操作数 1。
//   - alu_src2_in    : ALU 源操作数 2。
//   - br_imm_in      : 分支立即数/偏移量。
//   - alu_op_in      : ALU 操作控制码。
//   - br_op_in       : 分支操作控制码。
// - 输出（送往 EXE）：
//   - wb_reg_addr_out : 锁存后的目的寄存器地址。
//   - alu_src1_out    : 锁存后的 ALU 源操作数 1。
//   - alu_src2_out    : 锁存后的 ALU 源操作数 2。
//   - br_imm_out      : 锁存后的分支立即数。
//   - alu_op_out      : 锁存后的 ALU 操作控制码。
//   - br_op_out       : 锁存后的分支操作控制码。
//
// TODO ：
// 实现寄存器锁存与保持策略（握手成功更新、否则保持）。
// 复位值策略统一（控制信号清零、数据清零或安全值）。
// ============================================================
endmodule