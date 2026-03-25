module WBport (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,

    input  wire [31:0] wb_wdata_in,
    input  wire [ 4:0] wb_reg_addr_in,
    input  wire        wb_op_in,

    output  reg        allowIn,

    output  reg [31:0] wb_wdata_out,
    output  reg [ 4:0] wb_reg_addr_out,
    output  reg        wb_op_out
);
// ============================================================
// 模块功能：
// WB 写回阶段。对接寄存器堆写端口，输出最终写回数据与目标寄存器地址。
// 通常作为流水线末级，负责提交阶段结果。
//
// 端口定义：
// - 时序与握手：
//   - clk     : 时钟信号。
//   - reset   : 复位信号。
//   - valid   : WB 级输入有效标志。
//   - allowIn : WB 级对上游的允许信号（末级通常可常开）。
// - 输入（来自 MEM_WB_reg）：
//   - wb_wdata_in    : 待写回寄存器数据。
//   - wb_reg_addr_in : 待写回寄存器地址。
//   - wb_op_in       : 写回使能标志。
// - 输出（连接寄存器堆/提交总线）：
//   - wb_wdata_out    : 实际写回数据。
//   - wb_reg_addr_out : 实际写回地址。
//   - wb_op_out       : 实际提交写回使能。
//
// TODO：
// 1) 提交：明确 wb_op_out 门控规则（如 wb_op_in & valid）。
// 2) 接口：确认 allowIn 在末级是否固定 1。
// 3) 验证：覆盖空写回、有写回与非法地址场景。
// ============================================================






endmodule