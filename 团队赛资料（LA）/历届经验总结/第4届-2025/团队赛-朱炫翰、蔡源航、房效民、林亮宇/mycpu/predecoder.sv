`ifndef PreDecoder_SV
`define PreDecoder_SV
`include "core_defines.sv"
`include "tlb_defines.sv"
`include "mycpu.vh"

module PreDecoder 
    import core_defines::*;
    import frontend_defines::*;
    import bpu_defines::*;
    import tlb_types::*;
(
    input  logic [31:0] pc_i,      // pc_i
    input  logic [31:0] instr_i,   // 指令码
    output logic        isBranch,
    output logic        isImmjump_o,     // 是否立刻跳转
    output logic [31:0] jumpTargetAddr_o// 跳转目标
);

// 指令操作码定义
localparam [5:0] 
    B_OPCODE   = 6'b010100,  // b
    BL_OPCODE  = 6'b010101,  // bl
    JIRL_OPCODE= 6'b010011,  // jirl
    BEQ_OPCODE = 6'b010110,  // beq
    BNE_OPCODE = 6'b010111,  // bne
    BLT_OPCODE = 6'b011000,  // blt
    BGE_OPCODE = 6'b011001,  // bge
    BLTU_OPCODE= 6'b011010,  // bltu
    BGEU_OPCODE= 6'b011011;  // bgeu

// 分解指令
logic [5:0] opcode;
logic [31:0] imm26Sext;
logic [31:0] imm26SextShift2;

assign opcode = instr_i[31:26];

// 立即数
assign imm26Sext = {{6{instr_i[9]}},instr_i[9:0],instr_i[25:10]}; // 26位立即数带符号扩展
assign imm26SextShift2 = {imm26Sext[29:0], 2'b00}; // 左移2位

always_comb begin
        isBranch         = 1'b0;   
        isImmjump_o      = 1'b0;   // 前端立即重定向
        jumpTargetAddr_o = 32'b0;
    case (opcode)
        B_OPCODE: begin
            isBranch         = 1'b1;
            isImmjump_o      = 1'b1; // 暂时只启用B指令的预解码器重定向
            jumpTargetAddr_o = imm26SextShift2 + pc_i;
        end
        BL_OPCODE,JIRL_OPCODE,BEQ_OPCODE, BNE_OPCODE, BLT_OPCODE, BGE_OPCODE, BLTU_OPCODE, BGEU_OPCODE: begin
            isBranch         = 1'b1;
        end
    endcase
end

endmodule

`endif