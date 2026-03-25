module EXE_MEM_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,
    input  wire        readyGo,
    input  wire        allowIn,

    input  wire [31:0] final_result_in,
    input  wire [ 4:0] wb_reg_addr_in,
    input  wire [ 1:0] mem_op_in,
    input  wire        wb_op_in,
    input  wire [31:0] mem_wdata_in, 

    output reg  [31:0] final_result_out,
    output reg  [ 4:0] wb_reg_addr_out,
    output reg  [ 1:0] mem_op_out,
    output reg  [31:0] mem_wdata_out,
    output reg         wb_op_out
);
//============================================================
// 模块功能：
// EXE/MEM 流水寄存器。用于在 EXE 阶段与 MEM 阶段之间锁存执行结果及写回相关控制信息，
// 并结合 valid/readyGo/allowIn 完成阶段间握手与数据保持。
//
// 端口定义：
// - 时序与握手输入：
//   - clk        : 时钟信号。
//   - reset      : 复位信号。
//   - valid      : 本级输入数据有效标志。
//   - readyGo    : 本级已就绪，可向下一级传递数据。
//   - allowIn    : 下一级允许本级写入（本级可更新）的标志。
// - 数据与控制输入（来自 EXE）：
//   - final_result_in : EXE 阶段最终计算结果（ALU/分支相关结果）。
//   - wb_reg_addr_in  : 目的寄存器编号(地址，寄存器堆端口)。
//   - mem_op_in       : 访存操作类型编码，load/store。
//   - wb_op_in        : 是否执行写回操作标志。
// - 数据与控制输出（送往 MEM）：
//   - final_result_out : 锁存后的最终结果。
//   - wb_reg_addr_out  : 锁存后的目的寄存器编号。
//   - mem_op_out       : 锁存后的访存操作类型。
//   - wb_op_out        : 锁存后的写回使能。
//
// TODO：
// 1) 时序：实现 reset 清零、valid&&readyGo&&allowIn 更新、否则保持。
// 2) 控制：确认 mem_op/wb_op 的复位安全值定义。
// 3) 验证：连续更新、阻塞保持、复位恢复。
//============================================================





endmodule