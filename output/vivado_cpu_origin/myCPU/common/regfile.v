// ============================================================
// 32x32 通用寄存器堆：
// 在 `mycpu_top` 中由 ID 阶段提供读地址，WB 阶段提供写使能、写地址、写数据。
// ============================================================
module regfile(
    input  wire        clk,              // 写端口时钟
    input  wire [ 4:0] raddr1,           // 读地址1
    output wire [31:0] rdata1,           // 读数据1（组合）
    input  wire [ 4:0] raddr2,           // 读地址2
    output wire [31:0] rdata2,           // 读数据2（组合）
    input  wire        we,               // 写使能，高有效
    input  wire [ 4:0] waddr,            // 写地址（r0 不可写）
    input  wire [31:0] wdata             // 写数据
);
reg [31:0] rf[31:0];
integer i;

initial begin
    for (i = 0; i < 32; i = i + 1) begin
        rf[i] = 32'b0;
    end
end

always @(posedge clk) begin
    if (we && (waddr != 5'b0)) rf[waddr] <= wdata;
end

assign rdata1 = (raddr1==5'b0) ? 32'b0 :
                ((we && (waddr == raddr1) && (waddr != 5'b0)) ? wdata : rf[raddr1]);

assign rdata2 = (raddr2==5'b0) ? 32'b0 :
                ((we && (waddr == raddr2) && (waddr != 5'b0)) ? wdata : rf[raddr2]);

endmodule
