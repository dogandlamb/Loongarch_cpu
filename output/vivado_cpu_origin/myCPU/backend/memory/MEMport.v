`include "cpu_defs.vh"

module MEMport (
    input  wire         clk,
    input  wire         reset,
    input  wire         valid,

    input wire  [31:0]  data_sram_rdata, //from data memory, added by sssafridi
    
    input wire  [31:0]  exe_result, // renamed 
    input wire  [31:0]  pc_in,
    input wire  [ 4:0]  wb_reg_addr_in,
    input wire  [`MEM_OP_NUM-1:0]  mem_op,
    input wire          wb_op_in,
    input wire  [31:0]  mem_wdata_in, //由dogandlamb添加，对齐寄存器级的输出

    input wire  [31:0]  data_rdata_2MEM,

    input wire  [31:0]  data_raddr_from_EXE,  //added by sssafridi
    input wire  [31:0]  data_waddr_from_EXE,  //added by sssafridi

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
// ============================================================

wire   bram_re, bram_we;
assign bram_re = mem_op[`MEM_OP_LD_W] | mem_op[`MEM_OP_LD_H] | mem_op[`MEM_OP_LD_B]
               | mem_op[`MEM_OP_LD_HU] | mem_op[`MEM_OP_LD_BU];
assign bram_we = mem_op[`MEM_OP_ST_W] | mem_op[`MEM_OP_ST_H] | mem_op[`MEM_OP_ST_B];

wire [31:0] r_word_addr = {data_raddr_from_EXE[31:2], 2'b00};
wire [31:0] w_word_addr = {data_waddr_from_EXE[31:2], 2'b00};

// load 原始字：须在使用 r_byte_data/r_half_data 的 assign 之前声明
reg [31:0] load_rdata_hold;
always @(posedge clk) begin
    if (reset || !bram_re)
        load_rdata_hold <= 32'b0;
    else if (data_r_complete)
        load_rdata_hold <= data_sram_rdata;
end
wire [31:0] load_wdata_raw = data_r_complete ? data_sram_rdata : load_rdata_hold;

wire [ 7:0] r_byte_data;
wire [15:0] r_half_data;
wire [31:0] r_word_data;


assign r_byte_data = (r_word_addr[1:0] == 2'b00) ? load_wdata_raw[7:0] :
                     (r_word_addr[1:0] == 2'b01) ? load_wdata_raw[15:8] :
                     (r_word_addr[1:0] == 2'b10) ? load_wdata_raw[23:16] :
                                                   load_wdata_raw[31:24];

assign r_half_data = (r_word_addr[1:0] == 2'b00) ? load_wdata_raw[15:0] :
                     (r_word_addr[1:0] == 2'b10) ? load_wdata_raw[31:16] :
                                                   16'b0;

assign r_word_data = load_wdata_raw; 



wire [31:0] load_result;

assign load_result = (mem_op[`MEM_OP_LD_B])  ? {{24{r_byte_data[7]}}, r_byte_data[7:0]} :
                     (mem_op[`MEM_OP_LD_H])  ? {{16{r_half_data[15]}}, r_half_data[15:0]} :
                     (mem_op[`MEM_OP_LD_BU]) ? {24'b0, r_byte_data[7:0]} :
                     (mem_op[`MEM_OP_LD_HU]) ? {16'b0, r_half_data[15:0]} :
                     (mem_op[`MEM_OP_LD_W])  ? r_word_data :
                                               32'b0;

// 对当前 MEM 槽位做“完成后保持就绪”（按 pc+rd 精确匹配槽位）
reg        load_done_hold;
reg [31:0] load_done_pc;
reg [ 4:0] load_done_rd;
wire       load_done_match = load_done_hold
                           && (pc_in == load_done_pc)
                           && (wb_reg_addr_in == load_done_rd);
                           
always @(posedge clk) begin
    if (reset)
        load_done_hold <= 1'b0;
    else if (!valid || !bram_re)
        load_done_hold <= 1'b0;
    // hold 只用于补偿完成后的下一次推进；被消费后立即清掉，防止同一槽重复提交
    else if (load_done_match && !data_r_complete)
        load_done_hold <= 1'b0;
    else if (load_done_hold && !((pc_in == load_done_pc) && (wb_reg_addr_in == load_done_rd)))
        load_done_hold <= 1'b0;
    else if (data_r_complete) begin
        load_done_hold <= 1'b1;
        load_done_pc   <= pc_in;
        load_done_rd   <= wb_reg_addr_in;
    end
end

// load：未完成前不可推进；一旦完成，保持 ready 直到该 load 槽位离开 MEM
assign readyGo = bram_re ? (data_r_complete | load_done_match) : 1'b1;
assign allowIn = readyGo;

assign wb_wdata        = valid ? (bram_re ? load_result : exe_result) : 32'b0;
assign pc_out          = valid ? pc_in : 32'b0;
assign wb_reg_addr_out = valid ? wb_reg_addr_in : 5'b0;
assign wb_op_out       = valid ? wb_op_in : 1'b0;


endmodule