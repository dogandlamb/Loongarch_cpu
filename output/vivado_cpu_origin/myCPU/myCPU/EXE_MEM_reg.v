`include "cpu_defs.vh"

// ============================================================
// 模块功能：
// EXE/MEM 级间流水寄存器，承接 EXE 结果与访存/写回控制，
// 供 MEM 阶段访存与写回数据选择使用。
//
// 端口定义：
// - 时序控制：
//   - clk/reset    : 时钟与同步复位。
//   - valid/readyGo/allowIn：标准流水握手控制。
// - 数据输入（来自 EXE）：
//   - final_result_in：EXE 结果（地址或算术结果）。
//   - pc_in：指令 PC。
//   - wb_reg_addr_in：目的寄存器号。
//   - mem_op_in：访存控制（load/store）。
//   - wb_op_in：写回使能。
//   - mem_wdata_in：store 写数据。
// - 数据输出（送往 MEM）：
//   - 对应输入信号的 *_out 锁存版本。
//
// 与 top 的关系：
// - 上游连接 `EXEport`，下游连接 `MEMport`。
//
// 时序优先级（高 -> 低）：
// 1) reset 清空；2) 握手成功更新；3) valid=0 清空；4) 阻塞保持。
// ============================================================
module EXE_MEM_reg (
    input  wire                   clk,
    input  wire                   reset,
    input  wire                   valid,
    input  wire                   readyGo,
    input  wire                   allowIn,

    input  wire [31:0]            final_result_in,
    input  wire [31:0]            pc_in,
    input  wire [ 4:0]            wb_reg_addr_in,
    input  wire [`MEM_OP_NUM-1:0] mem_op_in,
    input  wire        wb_op_in,
    input  wire [31:0] mem_wdata_in,
    input  wire [31:0] data_raddr_from_EXE,  //added by sssafridi
    input  wire [31:0] data_waddr_from_EXE,  //added by sssafridi

    output reg  [31:0]            final_result_out,
    output reg  [31:0]            pc_out,
    output reg  [ 4:0]            wb_reg_addr_out,
    output reg  [`MEM_OP_NUM-1:0] mem_op_out,
    output reg         wb_op_out,
    output reg  [31:0] mem_wdata_out
    output reg  [31:0] data_raddr_out_from_EXE,  //added by sssafridi
    output reg  [31:0] data_waddr_out_from_EXE   //added by sssafridi
);

always @(posedge clk) begin
    // 复位：清空本级
    if(reset) begin
        final_result_out <= 32'h0;
        pc_out <= 32'h0;
        wb_reg_addr_out <= 5'h0;
        mem_op_out <= {`MEM_OP_NUM{1'b0}};
        wb_op_out <= 1'h0;
        mem_wdata_out <= 32'h0;
    // 握手成功：推进 EXE 输出到 MEM
    end
    else if(valid && readyGo && allowIn) begin
        final_result_out <= final_result_in;
        pc_out           <= pc_in;
        wb_reg_addr_out  <= wb_reg_addr_in;
        mem_op_out       <= mem_op_in;
        wb_op_out        <= wb_op_in;
        mem_wdata_out    <= mem_wdata_in;
    // 上游无效：输出清空
    end
    else if (!valid) begin
        final_result_out <= 32'h0;
        pc_out <= 32'h0;
        wb_reg_addr_out <= 5'h0;
        mem_op_out <= {`MEM_OP_NUM{1'b0}};
        wb_op_out <= 1'h0;
        mem_wdata_out <= 32'h0;
    // 下游反压或本级未就绪：保持当前值
    end
    else if (!readyGo | !allowIn) begin
        final_result_out <= final_result_out;
        pc_out           <= pc_out;
        wb_reg_addr_out  <= wb_reg_addr_out;
        mem_op_out       <= mem_op_out;
        wb_op_out        <= wb_op_out;
        mem_wdata_out    <= mem_wdata_out;
    // 兜底分支：保持安全清空语义
    end
    else begin
        final_result_out <= 32'h0;
        pc_out <= 32'h0;
        wb_reg_addr_out <= 5'h0;
        mem_op_out <= {`MEM_OP_NUM{1'b0}};
        wb_op_out <= 1'h0;
        mem_wdata_out <= 32'h0;
    end
end




endmodule