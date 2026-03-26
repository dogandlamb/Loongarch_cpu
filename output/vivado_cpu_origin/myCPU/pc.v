// ============================================================
// 模块功能：
// PC 寄存器。每拍在时钟上升沿更新当前 PC：
// - reset 时装载启动地址；
// - stall 时保持；
// - 其余情况下加载 nextpc。
//
// 端口定义：
// - clk/reset：时钟与同步复位。
// - stall    ：阻塞保持信号（来自 top 的 pc_stall）。
// - nextpc   ：下一拍 PC（来自 npc）。
// - pc       ：当前 PC 输出（送 IF 取指和调试路径）。
//
// 与 top 的联系：
// - 在 `mycpu_top` 中与 `npc` 闭环构成前端 PC 更新路径。
// ============================================================
module pc(
    input  wire        clk,
    input  wire        reset,
    input  wire        stall,
    input  wire [31:0] nextpc,
    output reg  [31:0] pc
);

// 阻塞时保持 PC；否则取 nextpc
always @ (posedge clk) begin
    if (reset) begin
        pc <= 32'h1bfffffc;
    end else if (stall) begin
        pc <= pc;
    end else begin
        pc <= nextpc;
    end
end

endmodule