// ============================================================
// 模块功能：
// PC 寄存器。每拍在时钟上升沿更新当前 PC：
// - reset 时装载复位启动地址 32'h1bfffffc；
// - stall_in=1 时保持；
// - 其余情况下加载 nextpc_in。
//
// 端口定义：
// - clk/reset：时钟与同步复位。
// - stall_in ：阻塞保持信号（来自 top 的 pc_stall）。
// - nextpc_in：下一拍 PC（来自 npc）。
// - pc_out   ：当前 PC 输出（送 IF 取指路径）。
//
// 与 top 的联系：
// - 在 `mycpu_top` 中与 `npc` 闭环构成前端 PC 更新路径。
// ============================================================
module pc(
    input  wire        clk,
    input  wire        reset,
    input  wire        stall_in,
    input  wire [31:0] nextpc_in,
    output reg  [31:0] pc_out
);

// 阻塞时保持 PC；否则取 nextpc
always @ (posedge clk) begin
    if (reset) begin
        pc_out <= 32'h1bfffffc;
    end else if (stall_in) begin
        pc_out <= pc_out;
    end else begin
        pc_out <= nextpc_in;
    end
end

endmodule