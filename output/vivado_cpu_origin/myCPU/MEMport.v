module MEMport (
    input  wire        valid,

    input wire  [31:0]  data_bram_rdata, //from data memory, added by sssafridi
    
    input wire  [31:0]  exe_result, // renamed 
    input wire  [31:0]  pc_in,
    input wire  [ 4:0]  wb_reg_addr_in,
    input wire  [ 1:0]  mem_op,
    input wire          wb_op_in,
    input wire  [31:0]  mem_wdata_in, //由dogandlamb添加，对齐寄存器级的输出

    input wire  [31:0]  data_rdata_2MEM,

    input wire          data_w_complete,
    input wire          data_r_complete,


    output wire         readyGo,
    output wire         allowIn,

    output wire  [31:0] wb_wdata,
    output wire  [31:0] pc_out,
    output wire  [ 4:0] wb_reg_addr_out,
    output wire         wb_op_out
);
// ============================================================
// 模块功能：
// MEM 访存阶段。根据 EXE 给出的 mem_op 对数据存储器进行访问（或旁路），
// 形成最终写回数据并输出到 WB 前级寄存器。
//
// 端口定义：
// - 时序与握手：
//   - valid   : MEM 级输入有效标志。
//   - readyGo : 本级已就绪，可向下一级传递数据。
//   - allowIn : 本级是否允许上一级写入新数据。
// - 输入（来自 EXE/MEM_reg）：
//   - exe_result  : EXE 结果（地址或算术结果）。
//   - wb_reg_addr_in: 目的寄存器地址。
//   - mem_op        : 访存操作控制码。
//   - wb_op_in      : 写回使能输入。
//   - data_bram_rdata : 从数据存储器来的数据。
//   - data_r_complete : 内存交互模块发回的内存读取数据有效的标志位
//   - data_w_complete : 内存交互模块发回的内存写入数据有效的标志位
// - 输出（送往 MEM/WB_reg）：
//   - wb_wdata      : 最终写回数据（访存读出或透传结果）。
//   - wb_reg_addr_out : 写回寄存器地址。
//   - wb_op_out       : 写回使能输出。
//
// TODO：
// 1) 访存：完善 mem_op 解码（load/store/旁路）。
// 2) 接口：补齐 data_sram 完整握手与字节写使能。
// 3) 验证：覆盖 load/store 与非访存指令透传（传给下一级）路径。
// ============================================================

wire   bram_re, bram_we;
assign bram_re = mem_op[MEM_OP_LD_W];
assign bram_we = mem_op[MEM_OP_ST_W];

assign readyGo = 1'b1;
assign allowIn = 1'b1;

assign wb_wdata        = valid ? (data_r_complete ? data_sram_rdata : exe_result) : 32'b0;
assign pc_out          = valid ? pc_in : 32'b0;
assign wb_reg_addr_out = valid ? wb_reg_addr_in : 5'b0;
assign wb_op_out       = valid ? wb_op_in : 1'b0;


endmodule