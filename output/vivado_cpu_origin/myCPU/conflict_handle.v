// ============================================================
// 模块功能：
// 分支冲刷辅助模块。将分支命中信号打一拍后输出 `cancel_sig`。
//
// 端口定义：
// - clk/reset ：时钟与同步复位。
// - br_taken_q：输入分支命中信号。
// - cancel_sig：输出冲刷信号。
//
// 与 top 的联系：
// - 该模块可用于“分支后一拍冲刷”策略；当前工程中 top 采用组合冲刷，
//   本模块保留用于可选控制策略切换。
// ============================================================
// 分支后一拍产生 cancel，配合 pipeline_controller 冲刷 IF/ID
module conflict_handle(
    input  wire clk,
    input  wire reset,
    input  wire br_taken_q,//分支信号
    output reg  cancel_sig
);

always @(posedge clk) begin
    if (reset) begin
        cancel_sig <= 1'b0;
    end else begin
        cancel_sig <= br_taken_q;
    end
end

endmodule
