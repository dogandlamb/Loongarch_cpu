module MEMport (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,

    input wire  [31:0] data_sram_rdata, //from data memory, added by sssafridi
    
    input wire  [31:0] exe_result, // renamed 
    input wire  [ 4:0] wb_reg_addr_in,
    input wire  [ 1:0] mem_op,
    input wire         wb_op_in,
    input wire  [31:0] mem_wdata_in, //由dogandlamb添加，对齐寄存器级的输出

    output reg         readyGo,
    output reg         allowIn,

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
//   - readyGo : 本级已就绪，可向下一级传递数据。
//   - allowIn : 本级是否允许上一级写入新数据。
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
// TODO：
// 1) 访存：完善 mem_op 解码（load/store/旁路）。
// 2) 接口：补齐 data_sram 完整握手与字节写使能。
// 3) 验证：覆盖 load/store 与非访存指令透传（传给下一级）路径。
// ============================================================

wire   d_sram_re, d_sram_we;
assign d_sram_re = (mem_op == 2'b10);
assign d_sram_we = (mem_op == 2'b11);

always @(posedge clk) begin
    if (reset) begin
        data_sram_addr <= 32'b0;
    end else if (valid) begin
        data_sram_addr <= exe_result;
    end else if (!valid) begin
        data_sram_addr <= data_sram_addr;
    end else begin
        data_sram_addr <= 32'b0;
    end
        
end

always @(posedge clk) begin
    if (reset) begin
        data_sram_wdata <= 32'b0;
    end else if (valid) begin
        data_sram_wdata <= mem_wdata_in;
    end else if (!valid) begin
        data_sram_wdata <= data_sram_wdata;
    end else begin
        data_sram_wdata <= 32'b0;
    end
end

always @(posedge clk) begin
    if (reset) begin
        wb_reg_addr_out <= 5'b0;
    end else if (valid) begin
        wb_reg_addr_out <= wb_reg_addr_in;
    end else if (!valid) begin
        wb_reg_addr_out <= wb_reg_addr_in;
    end else begin
        wb_reg_addr_out <= 5'b0;
    end
end

always @(posedge clk) begin
    if (reset) begin
        wb_wdata <= 32'b0;
    end else if (valid && d_sram_re) begin
        wb_wdata <= data_sram_rdata;
    end else if (valid) begin
        wb_wdata <= exe_result;
    end else if (!valid) begin
        wb_wdata <= wb_wdata;
    end else begin
        wb_wdata <= 32'b0;
    end
end

always @(posedge clk) begin
    if (reset) begin
        wb_op_out <= 1'b0;
    end else if (valid) begin
        wb_op_out <= wb_op_in;
    end else if (!valid) begin
        wb_op_out <= wb_op_out;
    end else begin
        wb_op_out <= 1'b0;
    end
end

always @(posedge clk) begin
    if (reset) begin
        data_sram_we <= 1'b0;
    end else begin
        data_sram_we <= d_sram_we;
    end 
 end

 always @(posedge clk) begin
    if (reset) begin
        allowIn <= 1'b1;
    end else if (valid) begin
        allowIn <= 1'b1;
    end else if (!valid) begin
        allowIn <= 1'b0;
    end else begin
        allowIn <= 1'b0;
    end
end

 always @(posedge clk) begin
    if (reset) begin
        readyGo <= 1'b1;
    end else if (valid) begin
        readyGo <= 1'b1;
    end else if (!valid) begin
        readyGo <= 1'b0;
    end else begin
        readyGo <= 1'b0;
    end
end

endmodule