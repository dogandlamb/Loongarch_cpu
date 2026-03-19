`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"


module id_2RI12
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
    
    reg [9:0] opcode;
    reg [4:0] rj;
    reg [4:0] rd;
    reg [11:0] ui12;
    reg [11:0] si12;

    always @(*) begin
        opcode = inst[31:22];
        rj = inst[9:5];
        rd = inst[4:0];

        is_exception = 3'b0;
        pc_exception_cause          = `EXCEPTION_INE;
        instbuffer_exception_cause  = `EXCEPTION_INE;
        decoder_exception_cause     = `EXCEPTION_INE;
        
        ui12 = inst[21:10];
        si12 = inst[21:10];
        pc_out = pc;
        inst_out = inst;
        
        csr_read_en = 1'b0;
        csr_write_en = 1'b0;
        csr_addr = 14'b0;
        is_cnt = 1'b0;
        invtlb_op = 5'b0;
    end

    always @(*) begin
        case(opcode)
            `ORI_OPCODE:begin
                reg_writen_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_ORI;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                reg1_read_addr = rj;
                reg2_read_addr = 5'b0;
                imm = {20'b0,ui12};
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `SLTI_OPCODE:begin
                reg_writen_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_SLTI;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                reg1_read_addr = rj;
                reg2_read_addr = 5'b0;
                imm = {{20{si12[11]}},si12};
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `SLTUI_OPCODE:begin
                reg_writen_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_SLTUI;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                reg1_read_addr = rj;
                reg2_read_addr = 5'b0;
                imm = {{20{si12[11]}},si12};
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `ADDIW_OPCODE:begin
                reg_writen_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_ADDIW;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                reg1_read_addr = rj;
                reg2_read_addr = 5'b0;
                imm = {{20{si12[11]}},si12};
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `ANDI_OPCODE:begin
                reg_writen_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_ANDI;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                reg1_read_addr = rj;
                reg2_read_addr = 5'b0;
                imm = {20'b0,ui12};
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `XORI_OPCODE: begin
                reg_writen_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_XORI;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                reg1_read_addr = rj;
                reg2_read_addr = 5'b0;
                imm = {20'b0, ui12};
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `LDB_OPCODE: begin
                reg_writen_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_LDB;
                alusel = `ALU_SEL_LOAD_STORE;
                reg1_read_en= 1'b1;
                reg2_read_en = 1'b0;
                reg1_read_addr = rj;
                reg2_read_addr = 5'b0;
                imm = {{20{si12[11]}}, si12};
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `LDH_OPCODE: begin
                reg_writen_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_LDH;
                alusel = `ALU_SEL_LOAD_STORE;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                reg1_read_addr = rj;
                reg2_read_addr = 5'b0;
                imm = {{20{si12[11]}}, si12};
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `LDW_OPCODE: begin
                reg_writen_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_LDW;
                alusel = `ALU_SEL_LOAD_STORE;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                reg1_read_addr = rj;
                reg2_read_addr = 5'b0;
                imm = {{20{si12[11]}}, si12};
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `LDBU_OPCODE: begin
                reg_writen_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_LDBU;
                alusel = `ALU_SEL_LOAD_STORE;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                reg1_read_addr = rj;
                reg2_read_addr = 5'b0;
                imm = {{20{si12[11]}}, si12};
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `LDHU_OPCODE: begin
                reg_writen_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_LDHU;
                alusel = `ALU_SEL_LOAD_STORE;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                reg1_read_addr = rj;
                reg2_read_addr = 5'b0;
                imm = {{20{si12[11]}}, si12};
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `STB_OPCODE: begin
                reg_writen_en = 1'b0;
                reg_write_addr = 5'b0;
                aluop = `ALU_STB;
                alusel = `ALU_SEL_LOAD_STORE;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                reg1_read_addr = rj;
                reg2_read_addr = rd;
                imm = 32'b0;
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `STH_OPCODE: begin
                reg_writen_en = 1'b0;
                reg_write_addr = 5'b0;
                aluop = `ALU_STH;
                alusel = `ALU_SEL_LOAD_STORE;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                reg1_read_addr = rj;
                reg2_read_addr = rd;
                imm = 32'b0;
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `STW_OPCODE: begin
                reg_writen_en = 1'b0;
                reg_write_addr = 5'b0;
                aluop = `ALU_STW;
                alusel = `ALU_SEL_LOAD_STORE;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                reg1_read_addr = rj;
                reg2_read_addr = rd;
                imm = 32'b0;
                inst_valid = 1'b1;
                is_privilege = 1'b0;
            end
            `CACOP_OPCODE: begin
                reg_writen_en = 1'b0;
                reg_write_addr = rd;
                aluop = ((rd[2:0]!=3'b0 && rd[2:0]!=3'b1)||(rd[4:3]==2'd3))?  `ALU_NOP : `ALU_CACOP;
                alusel = ((rd[2:0]!=3'b0&&rd[2:0]!=3'b1)||(rd[4:3]==2'd3)) ? `ALU_SEL_NOP  :  `ALU_SEL_ARITHMETIC;
                is_privilege = (rd[2:0]==3'b0||rd[2:0]==3'b1)&&(rd[4:3]!=2'd3);
                inst_valid = (rd[2:0]==3'b0||rd[2:0]==3'b1)&&(rd[4:3]==2'd0||rd[4:3]==2'd1||rd[4:3]==2'd2);
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                reg1_read_addr = rj;
                reg2_read_addr = 5'b0;
                imm = {{20{si12[11]}},si12}; 

                
            end
            default:begin
                aluop = `ALU_NOP;
                alusel = `ALU_SEL_NOP;
                reg_writen_en = 1'b0;
                reg_write_addr = 5'b0;
                reg1_read_en  = 1'b0;
                reg2_read_en  = 1'b0;
                reg1_read_addr= 5'b0;
                reg2_read_addr= 5'b0;
                imm = 32'b0;
                inst_valid = 1'b0;
            end
        endcase
    end
endmodule