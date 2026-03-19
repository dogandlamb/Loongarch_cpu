`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"

module id_2RI16
(
    input  wire [31:0] pc,
    input  wire [31:0] inst,

    output reg  [2:0] is_exception,
    output reg  [6:0] pc_exception_cause,
    output reg  [6:0] instbuffer_exception_cause, 
    output reg  [6:0] decoder_exception_cause,

    output reg  inst_valid,
    output reg  [31:0] pc_out,
    output reg  [31:0] inst_out,
    output reg  reg_writen_en,  //寄存器写使能信号
    output reg  [7:0]aluop,
    output reg  [2:0]alusel,
    output reg  [31:0]imm,
    output wire        is_div,
    output wire        is_mul,
    output reg  reg1_read_en,   //rR1寄存器读使能
    output reg  reg2_read_en,   //rR2寄存器读使能
    output reg  [4:0]reg1_read_addr,
    output reg  [4:0]reg2_read_addr,
    output reg  [4:0]reg_write_addr,  //目的寄存器地址
    output reg  is_privilege, //特权指令标志
    output reg  csr_read_en, //CSR寄存器读使能
    output reg  csr_write_en, //CSR寄存器写使能
    output reg  [13:0] csr_addr, //CSR
    output reg  is_cnt, //是否是计数器寄存器
    output reg  [4:0] invtlb_op  //TLB无效操作
);

    assign is_div = 1'b0; 
    assign is_mul = 1'b0; 

    reg [5:0] opcode;
    reg [4:0] rj;
    reg [4:0] rd;
    
    always @(*) begin
        opcode = inst[31:26];
        rj = inst[9:5];
        rd = inst[4:0];

        is_exception = 3'b0;
        pc_exception_cause          = `EXCEPTION_INE;
        instbuffer_exception_cause  = `EXCEPTION_INE;
        decoder_exception_cause     = `EXCEPTION_INE;
        
        pc_out = pc;
        inst_out = inst;
        imm = 32'b0;
        reg1_read_addr = rj;
        reg2_read_addr = rd;
        is_privilege = 1'b0;
        csr_read_en = 1'b0;
        csr_write_en = 1'b0;
        csr_addr = 14'b0;
        is_cnt = 1'b0;
        invtlb_op = 1'b0;
    end

    always @(*) begin
        case (opcode)
            `BEQ_OPCODE: begin
                reg_writen_en = 1'b0;
                aluop = `ALU_BEQ;
                alusel = `ALU_SEL_JUMP_BRANCH;
                reg_write_addr = 5'b0;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                inst_valid = 1'b1;
            end
            `BNE_OPCODE: begin
                reg_writen_en = 1'b0;
                aluop = `ALU_BNE;
                alusel = `ALU_SEL_JUMP_BRANCH;
                reg_write_addr = 5'b0;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                inst_valid = 1'b1;
            end
            `BLT_OPCODE: begin
                reg_writen_en = 1'b0;
                aluop = `ALU_BLT;
                alusel = `ALU_SEL_JUMP_BRANCH;
                reg_write_addr = 5'b0;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                inst_valid = 1'b1;
            end
            `BGE_OPCODE: begin
                reg_writen_en = 1'b0;
                aluop = `ALU_BGE;
                alusel = `ALU_SEL_JUMP_BRANCH;
                reg_write_addr = 5'b0;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                inst_valid = 1'b1;
            end
            `BLTU_OPCODE: begin
                reg_writen_en = 1'b0;
                aluop = `ALU_BLTU;
                alusel = `ALU_SEL_JUMP_BRANCH;
                reg_write_addr = 5'b0;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                inst_valid = 1'b1;
            end
            `BGEU_OPCODE: begin
                reg_writen_en = 1'b0;
                aluop = `ALU_BGEU;
                alusel = `ALU_SEL_JUMP_BRANCH;
                reg_write_addr = 5'b0;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                inst_valid = 1'b1;
            end
            `B_OPCODE: begin
                reg_writen_en = 1'b0;
                aluop = `ALU_B;
                alusel = `ALU_SEL_JUMP_BRANCH;
                reg_write_addr = 5'b0;
                reg1_read_en = 1'b0;
                reg2_read_en = 1'b0;
                inst_valid = 1'b1;
            end
            `BL_OPCODE: begin
                reg_writen_en = 1'b1;
                aluop = `ALU_BL;
                alusel = `ALU_SEL_JUMP_BRANCH;
                reg_write_addr = 5'b1;
                reg1_read_en = 1'b0;
                reg2_read_en = 1'b0;
                inst_valid = 1'b1;
            end 
            `JIRL_OPCODE: begin
                reg_writen_en = 1'b1;
                aluop = `ALU_JIRL;
                alusel = `ALU_SEL_JUMP_BRANCH;
                reg_write_addr = rd;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                inst_valid = 1'b1;
            end
            default: begin
                reg_writen_en = 1'b0;
                reg_write_addr = 5'b0;
                aluop = `ALU_NOP;
                alusel = `ALU_SEL_NOP;
                reg1_read_en = 1'b0;
                reg2_read_en = 1'b0;
                inst_valid = 1'b0;
            end
        endcase
    end
endmodule