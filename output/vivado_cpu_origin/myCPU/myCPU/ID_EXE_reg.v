// ============================================================
// 模块功能：
// ID/EXE 级间流水寄存器，锁存 ID 阶段生成的操作数、控制信号与 PC，
// 在 EXE 阶段使用。支持冲刷、握手更新、阻塞保持与无效清空。
//
// 端口定义：
// - 时序控制：
//   - clk/reset    : 时钟与同步复位。
//   - cancel_sig   : 分支冲刷信号（清空本级，防止错路指令进入 EXE）。
//   - valid/readyGo/allowIn：标准流水握手控制。
// - 数据输入（来自 ID）：
//   - wb_reg_addr_in：目的寄存器号。
//   - alu_src1_in/alu_src2_in：ALU 两路输入。
//   - br_imm_in/br_op_in：分支偏移与分支类型。
//   - alu_op_in：ALU 操作码。
//   - mem_wdata_in/mem_op_in：访存写数据与访存控制。
//   - wb_op_in：写回使能。
//   - pc_in：当前指令 PC。
// - 数据输出（送往 EXE）：
//   - 对应输入信号的 *_out 锁存版本。
//
// 与 top 的关系：
// - 上游连接 `IDport`（经 top 的 stall 插泡 mux）。
// - 下游连接 `EXEport`。
//
// 时序优先级（高 -> 低）：
// 1) reset/cancel 清空；2) 握手成功更新；3) valid=0 清空；4) 阻塞保持。
// ============================================================

`include "cpu_defs.vh"

module ID_EXE_reg (
    input  wire                   clk,
    input  wire                   reset,
    input  wire                   cancel_sig,
    input  wire                   valid,
    input  wire                   readyGo,
    input  wire                   allowIn,

    input wire  [4:0]             wb_reg_addr_in,
    input wire  [31:0]            alu_src1_in,
    input wire  [31:0]            alu_src2_in,
    input wire  [31:0]            br_imm_in,
    input wire  [31:0]            pc_in,
    input wire  [`ALU_OP_NUM-1:0] alu_op_in,
    input wire  [`BR_OP_NUM-1:0]  br_op_in,
    input wire  [31:0]            mem_wdata_in,
    input wire  [`MEM_OP_NUM-1:0] mem_op_in,
    input wire                    wb_op_in,
        
    output reg  [4:0]             wb_reg_addr_out,
    output reg  [31:0]            alu_src1_out,
    output reg  [31:0]            alu_src2_out,
    output reg  [31:0]            br_imm_out,
    output reg  [31:0]            pc_out,
    output reg  [`ALU_OP_NUM-1:0] alu_op_out,
    output reg  [31:0]            mem_wdata_out,   

    output reg  [`BR_OP_NUM-1:0]  br_op_out,
    output reg  [`MEM_OP_NUM-1:0] mem_op_out,
    output reg                    wb_op_out
);

always @(posedge clk) begin
    // 复位或冲刷：将本级清空为 NOP
    if(reset || cancel_sig) begin
        wb_reg_addr_out   <= 5'h0;
        alu_src1_out      <= 32'h0;
        alu_src2_out      <= 32'h0;
        br_imm_out        <= 32'h0;
        pc_out            <= 32'h0;
        alu_op_out        <= {`ALU_OP_NUM{1'b0}};
        mem_wdata_out     <= 32'b0;
        br_op_out         <= {`BR_OP_NUM{1'b0}};
        mem_op_out        <= {`MEM_OP_NUM{1'b0}};
        wb_op_out         <= 1'h0;
    // 握手成功：锁存 ID 输出，推进到 EXE
    end
    else if(valid && readyGo && allowIn) begin
        wb_reg_addr_out   <= wb_reg_addr_in;
        alu_src1_out      <= alu_src1_in;
        alu_src2_out      <= alu_src2_in;
        br_imm_out        <= br_imm_in;
        pc_out            <= pc_in;
        alu_op_out        <= alu_op_in;
        mem_wdata_out     <= mem_wdata_in;
        br_op_out         <= br_op_in;
        mem_op_out        <= mem_op_in;
        wb_op_out         <= wb_op_in;
    // 上游无效：清空，防止无效数据传播
    end
    else if(!valid) begin
        wb_reg_addr_out  <= 5'h0;
        alu_src1_out     <= 32'h0;
        alu_src2_out     <= 32'h0;
        br_imm_out       <= 32'h0;
        pc_out           <= 32'h0;
        alu_op_out       <= {`ALU_OP_NUM{1'b0}};
        mem_wdata_out    <= 32'b0;
        br_op_out        <= {`BR_OP_NUM{1'b0}};
        mem_op_out       <= {`MEM_OP_NUM{1'b0}};
        wb_op_out        <= 1'h0;
    // 下游反压或本级未就绪：保持当前值
    end
    else if(!readyGo | !allowIn) begin
        wb_reg_addr_out  <= wb_reg_addr_out;
        alu_src1_out     <= alu_src1_out;
        alu_src2_out     <= alu_src2_out;
        br_imm_out       <= br_imm_out;
        pc_out           <= pc_out;
        alu_op_out       <= alu_op_out;
        mem_wdata_out    <= mem_wdata_out;
        br_op_out        <= br_op_out;
        mem_op_out       <= mem_op_out;
        wb_op_out        <= wb_op_out;
    // 兜底分支：保持安全清空语义
    end
    else begin
        wb_reg_addr_out  <= 5'h0;
        alu_src1_out     <= 32'h0;
        alu_src2_out     <= 32'h0;
        br_imm_out       <= 32'h0;
        pc_out           <= 32'h0;
        alu_op_out       <= {`ALU_OP_NUM{1'b0}};
        mem_wdata_out    <= 32'h0;
        br_op_out        <= {`BR_OP_NUM{1'b0}};
        mem_op_out       <= {`MEM_OP_NUM{1'b0}};
        wb_op_out        <= 1'h0;
    end
end


endmodule