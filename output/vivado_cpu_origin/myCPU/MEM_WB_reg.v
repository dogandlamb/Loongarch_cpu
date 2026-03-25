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
//   - readyGo : 本级已就绪，可向下一级传递数据。
//   - allowIn : 下一级（WB）允许本级写入标志。
// - 输入（来自 MEM）：
//   - wb_wdata_in    : 待写回寄存器的数据。
//   - wb_reg_addr_in : 待写回寄存器地址。
//   - wb_op_in       : 写回使能标志。
// - 输出（送往 WB）：
//   - wb_wdata_out    : 锁存后的写回数据。
//   - wb_reg_addr_out : 锁存后的写回地址。
//   - wb_op_out       : 锁存后的写回使能。
//
// TODO：
// 1) 时序：实现复位清零、握手更新、阻塞保持。
// 2) 验证：检查 wb_op 与地址/数据在阻塞时不抖动。
// ============================================================
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

always @(posedge clk) begin
    if (reset) begin
        wb_wdata_out <= 32'b0;
        wb_reg_addr_out <= 5'b0;
        wb_op_out <= 1'b0;
    end
    else if (valid && readyGo && allowIn) begin
        wb_wdata_out <= wb_wdata_in;
        wb_reg_addr_out <= wb_reg_addr_in;
        wb_op_out <= wb_op_in;
    end
    else if (!valid) begin
        wb_wdata_out <= 32'b0;
        wb_reg_addr_out <= 5'b0;
        wb_op_out <= 1'b0;
    end
    else if (!readyGo | !allowIn) begin
        wb_wdata_out <= wb_wdata_out;
        wb_reg_addr_out <= wb_reg_addr_out;
        wb_op_out <= wb_op_out;
    end
    else begin
        wb_wdata_out <= 32'b0;
        wb_reg_addr_out <= 5'b0;
        wb_op_out <= 1'b0;
    end
end



endmodule