// ============================================================
// 模块功能：
// IF/ID 级间流水寄存器，锁存 IF 阶段输出的 `inst/pc` 并送入 ID 阶段。
// 支持分支冲刷（cancel）、握手更新、阻塞保持与无效清空。
//
// 端口定义：
// - 时序控制：
//   - clk/reset    : 时钟与同步复位。
//   - cancel_sig   : 冲刷信号（分支重定向时清空本级）。
//   - valid        : 上游 IF 输出是否有效。
//   - readyGo      : 本级数据是否可向下传递。
//   - allowIn      : 下游是否允许本级写入。
// - 数据输入：
//   - pc_in/inst_in：IF 输出 PC 与指令。
// - 数据输出：
//   - pc_out/inst_out：送往 ID 的锁存结果。
//
// 与 top 的关系：
// - 上游连接 `IFport`，下游连接 `IDport`。
// - `cancel_sig` 来自 `mycpu_top` 的分支命中路径。
//
// 时序优先级（高 -> 低）：
// 1) reset/cancel 清空；2) 握手成功更新；3) valid=0 清空；4) 阻塞保持。
// ============================================================

module IF_ID_reg(
    input  wire        clk,
    input  wire        reset,
    input  wire        cancel_sig,
    input  wire        valid,
    input  wire        readyGo,
    input  wire        allowIn,
    input  wire [31:0] pc_in,

    input  wire [31:0] inst_in,


    output reg  [31:0] inst_out,
    output reg  [31:0] pc_out
);

always @(posedge clk) begin
    // 分支冲刷或复位：清空错误路径指令
    if (reset || cancel_sig) begin
        inst_out <= 32'h0;
        pc_out   <= 32'h0;
    // 握手成功：锁存来自 IF 的新指令与 PC
    end else if (valid && readyGo && allowIn) begin
        inst_out <= inst_in;
        pc_out   <= pc_in;
    // 上游无效：输出清空，避免脏值向后传播
    end else if (!valid) begin
        inst_out <= 32'b0;
        pc_out   <= 32'b0;
    // 下游反压或本级未就绪：保持当前寄存值
    end else if (!readyGo | !allowIn) begin
        inst_out <= inst_out;
        pc_out   <= pc_out;
    end
end

endmodule