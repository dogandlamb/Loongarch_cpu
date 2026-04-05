`include "../../common/cpu_defs.vh"

// ============================================================
// ID_EXE_reg：ID 与 EXE 间流水寄存器。
// ============================================================
module ID_EXE_reg (
    input  wire                   clk,
    input  wire                   reset,
    input  wire                   cancel_sig,
    input  wire                   valid,
    input  wire                   readyGo,
    input  wire                   allowIn,

    input wire  [4:0]             wb_reg_addr_in,   // 目的寄存器地址
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
    // 复位或cancel信号：清空
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
    end

    // 握手成功：在流水级寄存器锁存 ID 输出，推进到 EXE
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
    end

    // 上游无效（即valid为0）：清空
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
    end

    // 下游反压（即readyGo为0）或ID未就绪（即allowIn为0）：保持当前值
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
    end

    // 兜底分支：就是else，没啥
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