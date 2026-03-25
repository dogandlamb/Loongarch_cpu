// ============================================================
// 模块功能：
// ID/EXE 流水寄存器。负责将 ID 阶段译码得到的操作数和控制信号
// 在握手成功时锁存并传递给 EXE 阶段。
//
// 端口定义：
// - 时序与握手输入：
//   - clk     : 时钟信号。
//   - reset   : 复位信号。
//   - valid   : ID 输出有效标志。
//   - readyGo : 本级已就绪，可向下一级传递数据。
//   - allowIn : 下一级允许本级写入标志。
// - 输入（来自 ID）：
//   - wb_reg_addr_in : 目的寄存器地址。
//   - alu_src1_in    : ALU 源操作数 1。
//   - alu_src2_in    : ALU 源操作数 2。
//   - br_imm_in      : 分支立即数/偏移量。
//   - alu_op_in      : ALU 操作控制码。
//   - br_op_in       : 分支操作控制码。
// - 输出（送往 EXE）：
//   - wb_reg_addr_out : 锁存后的目的寄存器地址。
//   - alu_src1_out    : 锁存后的 ALU 源操作数 1。
//   - alu_src2_out    : 锁存后的 ALU 源操作数 2。
//   - br_imm_out      : 锁存后的分支立即数。
//   - alu_op_out      : 锁存后的 ALU 操作控制码。
//   - br_op_out       : 锁存后的分支操作控制码。
//
// TODO：
// 1) 时序：补齐握手更新和保持策略。
// 2) 控制：统一新增 mem_op/wb_op 的复位与透传（传给下一级的意思）规范。
// 3) 验证： ID->EXE 控制/数据一致性。
// ============================================================

module ID_EXE_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,
    input  wire        readyGo,
    input  wire        allowIn,

    input wire  [4:0]  wb_reg_addr_in,
    input wire  [31:0] alu_src1_in,
    input wire  [31:0] alu_src2_in,
    input wire  [31:0] br_imm_in,
    input wire  [11:0] alu_op_in,
    input wire  [ 4:0] br_op_in,
    input wire  [31:0] mem_wdata_in,
    input wire  [ 1:0] mem_op_in,
    input wire         wb_op_in,

    output reg  [4:0]  wb_reg_addr_out,
    output reg  [31:0] alu_src1_out,
    output reg  [31:0] alu_src2_out,
    output reg  [31:0] br_imm_out,
    output reg  [11:0] alu_op_out,
    output reg  [31:0] mem_wdata_out,

    output reg  [ 4:0] br_op_out,
    output reg  [ 1:0] mem_op_out,
    output reg         wb_op_out
);

always @(posedge clk) begin
    if(reset) begin
        wb_reg_addr_out <= 5'h0;
        alu_src1_out <= 32'h0;
        alu_src2_out <= 32'h0;
        br_imm_out <= 32'h0;
        alu_op_out <= 12'h0;
        mem_wdata_out <= 32'b0;
        br_op_out <= 5'h0;
        mem_op_out <= 2'h0;
        wb_op_out <= 1'h0; 
    end
    else if(valid && readyGo && allowIn) begin
        wb_reg_addr_out <= wb_reg_addr_in;
        alu_src1_out <= alu_src1_in;
        alu_src2_out <= alu_src2_in;
        br_imm_out <= br_imm_in;
        alu_op_out <= alu_op_in;
        mem_wdata_out <= mem_wdata_in;
        br_op_out <= br_op_in;
        mem_op_out <= mem_op_in;
        wb_op_out <= wb_op_in;
    end
    else if(!valid) begin
        wb_reg_addr_out <= 5'h0;
        alu_src1_out <= 32'h0;
        alu_src2_out <= 32'h0;
        br_imm_out <= 32'h0;
        alu_op_out <= 12'h0;
        mem_wdata_out <= 32'b0;
        br_op_out <= 5'h0;
        mem_op_out <= 2'h0;
        wb_op_out <= 1'h0; 
    end
    else if(!readyGo | !allowIn) begin
        wb_reg_addr_out <= wb_reg_addr_out;
        alu_src1_out <= alu_src1_out;
        alu_src2_out <= alu_src2_out;
        br_imm_out <= br_imm_out;
        alu_op_out <= alu_op_out;
        mem_wdata_out <= mem_wdata_out;
        br_op_out <= br_op_out;
        mem_op_out <= mem_op_out;
        wb_op_out <= wb_op_out;
    end
    else begin
        wb_reg_addr_out <= 5'h0;
        alu_src1_out <= 32'h0;
        alu_src2_out <= 32'h0;
        br_imm_out <= 32'h0;
        alu_op_out <= 12'h0;
        mem_wdata_out <= 32'b0;
        br_op_out <= 5'h0;
        mem_op_out <= 2'h0;
        wb_op_out <= 1'h0; 
    end
end


endmodule