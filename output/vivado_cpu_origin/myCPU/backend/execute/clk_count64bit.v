// ============================================================
// clk_count64bit（时序，时钟计数器，不可能被修改）
// 用于指令rdcntvl.w rdcntvh.w 读取时钟计数器
// 例化在EXE
// ============================================================
module clk_count64bit (
    input wire clk,
    input wire reset,
    output reg [63:0] clk_count_64
);

always @(posedge clk) begin
    if (reset) begin
        clk_count_64 <= 0;
    end
    else begin
        clk_count_64 <= clk_count_64 + 1'b1;
    end
end

endmodule