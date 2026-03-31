// ============================================================
// 模块功能：
// 32x32 通用寄存器堆（双读单写）：
// - 写口在时钟上升沿写入；
// - 读口组合输出；
// - 对 r0 恒为 0；
// - 支持同拍写后读旁路（RAW bypass）。
//
// 端口定义：
// - clk         ：写端口时钟。
// - raddr1/2    ：两路读地址。
// - rdata1/2    ：两路读数据。
// - we/waddr/wdata：写使能、写地址、写数据。
//
// 与 top 的联系：
// - 在 `mycpu_top` 中由 ID 阶段提供读地址，WB 阶段提供写回三元组。
// ============================================================
module regfile(
    input  wire        clk,
    // READ PORT 1
    input  wire [ 4:0] raddr1,
    output wire [31:0] rdata1,
    // READ PORT 2
    input  wire [ 4:0] raddr2,
    output wire [31:0] rdata2,
    // WRITE PORT
    input  wire        we,       //write enable, HIGH valid
    input  wire [ 4:0] waddr,
    input  wire [31:0] wdata
);
reg [31:0] rf[31:0];
integer i;

initial begin
    for (i = 0; i < 32; i = i + 1) begin
        rf[i] = 32'b0;
    end
end

//WRITE
always @(posedge clk) begin
    if (we && (waddr != 5'b0)) rf[waddr] <= wdata;
end

//READ OUT 1
assign rdata1 = (raddr1==5'b0) ? 32'b0 :
                ((we && (waddr == raddr1) && (waddr != 5'b0)) ? wdata : rf[raddr1]);

//READ OUT 2
assign rdata2 = (raddr2==5'b0) ? 32'b0 :
                ((we && (waddr == raddr2) && (waddr != 5'b0)) ? wdata : rf[raddr2]);

endmodule
