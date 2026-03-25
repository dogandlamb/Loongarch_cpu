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
//   - valid      : 当前级（就是EXE_MEM_reg这一寄存器级）输入数据有效标志。
//   - readyGo    : 当前级数据已准备好可向后传递标志。
//   - allowIn    : 下一级允许本级写入标志。
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
// TODO ：
// 实现时序锁存逻辑：reset 清零、握手成功时更新、否则保持。
//============================================================
endmodule