// ============================================================
// 模块功能：
// MEM/WB 级间流水寄存器，锁存 MEM 阶段形成的最终写回信息，
// 交给 WB 阶段提交到寄存器堆与调试总线。
//
// 端口定义：
// - 时序控制：
//   - clk/reset    : 时钟与同步复位。
//   - valid/readyGo/allowIn：标准流水握手控制。
// - 数据输入（来自 MEM）：
//   - wb_wdata_in：写回数据。
//   - pc_in：提交 PC。
//   - wb_reg_addr_in：写回寄存器号。
//   - wb_op_in：写回使能。
// - 数据输出（送往 WB）：
//   - wb_wdata_out/pc_out/wb_reg_addr_out/wb_op_out。
//
// 与 top 的关系：
// - 上游连接 `MEMport`，下游连接 `WBport`。
//
// 时序优先级（高 -> 低）：
// 1) reset 清空；2) 握手成功更新；3) valid=0 清空；4) 阻塞保持。
// ============================================================
module MEM_WB_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,
    input  wire        readyGo,
    input  wire        allowIn,

    input  wire [31:0] wb_wdata_in,
    input  wire [31:0] pc_in,
    input  wire [ 4:0] wb_reg_addr_in,
    input  wire        wb_op_in,

    output  reg [31:0] wb_wdata_out,
    output  reg [31:0] pc_out,
    output  reg [ 4:0] wb_reg_addr_out,
    output  reg        wb_op_out
);

always @(posedge clk) begin
    // 复位：清空本级提交信息
    if (reset) begin
        wb_wdata_out <= 32'b0;
        pc_out <= 32'b0;
        wb_reg_addr_out <= 5'b0;
        wb_op_out <= 1'b0;
    // 握手成功：推进 MEM 输出到 WB
    end
    else if (valid && readyGo && allowIn) begin
        wb_wdata_out <= wb_wdata_in;
        pc_out <= pc_in;
        wb_reg_addr_out <= wb_reg_addr_in;
        wb_op_out <= wb_op_in;
    // 上游无效：清空输出
    end
    else if (!valid) begin
        wb_wdata_out <= 32'b0;
        pc_out <= 32'b0;
        wb_reg_addr_out <= 5'b0;
        wb_op_out <= 1'b0;
    // 下游反压或本级未就绪：保持当前值
    end
    else if (!readyGo | !allowIn) begin
        wb_wdata_out <= wb_wdata_out;
        pc_out <= pc_out;
        wb_reg_addr_out <= wb_reg_addr_out;
        // 停顿拍禁止重复提交，避免同一条指令被 testbench 计为多次写回
        wb_op_out <= 1'b0;
    // 兜底分支：保持安全清空语义
    end
    else begin
        wb_wdata_out <= 32'b0;
        pc_out <= 32'b0;
        wb_reg_addr_out <= 5'b0;
        wb_op_out <= 1'b0;
    end
end



endmodule