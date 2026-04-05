// =====================================================
// MEM_WB_reg：MEM 与 WB 之间的流水寄存器。
// =====================================================
module MEM_WB_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,
    input  wire        readyGo,
    input  wire        allowIn,

    input  wire [31:0] wb_wdata_in,
    input  wire [31:0] pc_in,
    input  wire [ 4:0] wb_reg_addr_in,
    input  wire        wb_op_in,

    output reg  [31:0] wb_wdata_out,
    output reg  [31:0] pc_out,
    output reg  [ 4:0] wb_reg_addr_out,
    output reg         wb_op_out
);

always @(posedge clk) begin
    if (reset) begin
        wb_wdata_out    <= 32'b0;
        pc_out          <= 32'b0;
        wb_reg_addr_out <= 5'b0;
        wb_op_out       <= 1'b0;
    end else if (valid && readyGo && allowIn) begin
        wb_wdata_out    <= wb_wdata_in;
        pc_out          <= pc_in;
        wb_reg_addr_out <= wb_reg_addr_in;
        wb_op_out       <= wb_op_in;
    end else if (!valid) begin
        wb_wdata_out    <= 32'b0;
        pc_out          <= 32'b0;
        wb_reg_addr_out <= 5'b0;
        wb_op_out       <= 1'b0;
    end else begin
        wb_wdata_out    <= wb_wdata_out;
        pc_out          <= pc_out;
        wb_reg_addr_out <= wb_reg_addr_out;
        wb_op_out       <= wb_op_out;
    end
end

endmodule
