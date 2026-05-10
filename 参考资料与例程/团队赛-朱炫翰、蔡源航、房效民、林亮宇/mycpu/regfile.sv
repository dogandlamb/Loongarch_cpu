`include "pipeline_types.sv"
`include "core_defines.sv"
module regfile
    import pipeline_types::*;
    import core_defines::*;
(
    input  wire        clk,
    // READ PORT 1
    input  wire [DECODER_WIDTH-1:0][ 4:0] raddr1,
    output wire [DECODER_WIDTH-1:0][31:0] rdata1,
    // READ PORT 2
    input  wire [DECODER_WIDTH-1:0][ 4:0] raddr2,
    output wire [DECODER_WIDTH-1:0][31:0] rdata2,
    // WRITE PORT
    input  wire [COMMIT_WIDTH-1:0]       we,       //write enable, HIGH valid
    input  wire [COMMIT_WIDTH-1:0][ 4:0] waddr,
    input  wire [COMMIT_WIDTH-1:0][31:0] wdata
    `ifdef DIFFTEST_EN
    ,
    output [31:0] rf_o [31:0]   // difftest
    `endif 
);
reg [31:0] rf[31:0];

// WRITE
always @(posedge clk) begin
    // 特殊情况：当双发射的两条指令都需要写回，且写回同一个寄存器时，就存后一条指令的数据（0是前一条，1是后一条）
    if (we[0] && we[1] && (waddr[0] == waddr[1])) rf[waddr[1]] <= wdata[1];
    else begin
        if (we[0]) rf[waddr[0]] <= wdata[0];
        if (we[1]) rf[waddr[1]] <= wdata[1];
    end
end
// // 换回单提交
// always @(posedge clk) begin
//     if (we) rf[waddr] <= wdata;
// end
for (genvar i = 0; i < DECODER_WIDTH; i++) begin
    //READ OUT 1
    assign rdata1[i] = (raddr1[i]==5'b0) ? 32'b0 : rf[raddr1[i]];

    //READ OUT 2
    assign rdata2[i] = (raddr2[i]==5'b0) ? 32'b0 : rf[raddr2[i]];
end
// difftest
`ifdef DIFFTEST_EN
assign rf_o = rf;
`endif
endmodule
