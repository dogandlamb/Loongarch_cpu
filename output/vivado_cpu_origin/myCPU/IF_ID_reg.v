// ============================================================
// 模块功能：
// IF/ID 流水寄存器。用于在 IF 与 ID 之间锁存取指结果 inst，
// 依据 valid/readyGo/allowIn 控制更新时机，实现停顿时保持数据稳定。
//
// 端口定义：
// - 时序与握手输入：
//   - clk     : 时钟信号。
//   - reset   : 复位信号。
//   - valid   : IF 阶段输出有效标志。
//   - readyGo : 本级已就绪，可向下一级传递数据。
//   - allowIn : 下一级允许本级写入标志。
// - 数据输入：
//   - inst_in : IF 阶段输出指令。
// - 数据输出：
//   - inst_out : 锁存后的指令，送入 ID 阶段。
//
// TODO：
// 1) 时序：实现 valid&&readyGo&&allowIn 更新，其他情况保持。
// 2) 架构：确定 reset 后输出为 0 。
// ============================================================

module IF_ID_reg(
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,
    input  wire        readyGo,
    input  wire        allowIn,

    input  wire [31:0] inst_in,


    output reg  [31:0] inst_out
);

always @(posedge clk) begin
    if(reset) inst_out <= 32'h0;
    else if(valid && readyGo && allowIn) inst_out <= inst_in;
    else if(!valid) inst_out <= 32'b0;
    else if(!readyGo | !allowIn) inst_out <= inst_out;
    else inst_out <= inst_out;
end

endmodule