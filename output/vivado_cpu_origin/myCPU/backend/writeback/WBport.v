// ============================================================
// WBport：写回级组合逻辑。valid 且非复位时透传 MEM_WB_reg 输出到 regfile；
// ============================================================
module WBport (
    input  wire        reset,            // 同步高有效复位
    input  wire        valid,            // WB 槽有效

    input  wire [31:0] wb_wdata_in,      // 写回数据
    input  wire [31:0] pc_in,            // 用以提交 PC（调试）
    input  wire [ 4:0] wb_reg_addr_in,   // 写回的目的寄存器号
    input  wire        wb_op_in,         // 写回指令使能，即wb_we = wb_op_in

    output wire        allowIn,          // 对上游允许写入（一直为1）

    output wire [31:0] wb_wdata_out,     // 送 regfile 的写数据
    output wire [31:0] pc_out,           // 送 debug 的 PC
    output wire [ 4:0] wb_reg_addr_out,  // 送 regfile 的写地址
    output wire        wb_op_out         // 送 regfile 的写使能
);

wire wb_we;
assign wb_we = wb_op_in;

assign allowIn         = 1'b1;
assign wb_wdata_out    = (reset || !valid) ? 32'b0 : wb_wdata_in;
assign pc_out          = (reset || !valid) ? 32'b0 : pc_in;
assign wb_reg_addr_out = (reset || !valid) ? 5'b0  : wb_reg_addr_in;
assign wb_op_out       = (reset || !valid) ? 1'b0  : wb_we;

endmodule
