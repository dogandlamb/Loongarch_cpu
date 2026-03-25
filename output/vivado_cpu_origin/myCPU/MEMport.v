module MEMport (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,

    output reg       readyGo,
    output reg       allowIn,

    input wire  [31:0] data_sram_rdata, //from data memory, added by sssafridi
    

    input wire  [31:0] exe_result, // renamed 
    input wire  [ 4:0] wb_reg_addr_in,
    input wire  [ 1:0] mem_op,
    input wire         wb_op_in,

    output reg  [31:0] wb_wdata,
    output reg  [ 4:0] wb_reg_addr_out,
    output reg  [31:0] data_sram_wdata,
    output reg  [31:0] data_sram_addr,
    output reg         data_sram_we,
    output reg         wb_op_out
);
// ============================================================
// 模块功能：
// MEM 访存阶段。根据 EXE 给出的 mem_op 对数据存储器进行访问（或旁路），
// 形成最终写回数据并输出到 WB 前级寄存器。
//
// 端口定义：
// - 时序与握手：
//   - clk     : 时钟信号。
//   - reset   : 复位信号。
//   - valid   : MEM 级输入有效标志。
//   - readyGo : MEM 级就绪标志。
//   - allowIn : MEM 级允许上游写入标志。
// - 输入（来自 EXE/MEM_reg）：
//   - exe_result  : EXE 结果（地址或算术结果）。
//   - wb_reg_addr_in: 目的寄存器地址。
//   - mem_op        : 访存操作控制码。
//   - wb_op_in      : 写回使能输入。
//   - data_sram_rdata : 从数据存储器来的数据。
// - 输出（送往 MEM/WB_reg）：
//   - wb_wdata      : 最终写回数据（访存读出或透传结果）。
//   - wb_reg_addr_out : 写回寄存器地址。
//   - wb_op_out       : 写回使能输出。
//
// TODO ：
// 完成 mem_op 解码与访存路径选择（load/store/旁路）。
// 接入数据存储器接口（地址、写使能、字节使能、读数据）。
// ============================================================



endmodule