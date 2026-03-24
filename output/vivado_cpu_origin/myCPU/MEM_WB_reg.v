module MEM_WB_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,
    input  wire        readyGo,
    input  wire        allowIn,

    input  wire [31:0] wb_wdata_in,
    input  wire [ 4:0] wb_reg_addr_in,
    input  wire        wb_op_in,

    output  reg [31:0] wb_wdata_out,
    output  reg [ 4:0] wb_reg_addr_out,
    output  reg        wb_op_out
);
// ============================================================
// 模块功能：
// MEM/WB 流水寄存器。锁存 MEM 阶段输出的写回数据与控制信息，
// 并向 WB 阶段提供稳定输入。
//
// 端口定义：
// - 时序与握手输入：
//   - clk     : 时钟信号。
//   - reset   : 复位信号。
//   - valid   : MEM 输出有效标志。
//   - readyGo : 本级就绪标志。
//   - allowIn : WB 级允许写入标志。
// - 输入（来自 MEM）：
//   - wb_wdata_in    : 待写回寄存器的数据。
//   - wb_reg_addr_in : 待写回寄存器地址。
//   - wb_op_in       : 写回使能标志。
// - 输出（送往 WB）：
//   - wb_wdata_out    : 锁存后的写回数据。
//   - wb_reg_addr_out : 锁存后的写回地址。
//   - wb_op_out       : 锁存后的写回使能。
//
// TODO ：
//  实现锁存逻辑（握手成功更新，阻塞保持，复位清零）
// ============================================================
endmodule