`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"

module id_1R_I26
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
    output wire is_div,
    output wire is_mul,
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
    output reg  [4:0] invtlb_op //TLB无效操作
);

    assign is_div = 1'b0; 
    assign is_mul = 1'b0; 

    reg [21:0] opcode;
    reg [4:0] rj;
    reg [4:0] rd;

    always @(*) begin
        opcode = inst[31:10];
        rj = inst[9:5];
        rd = inst[4:0];
    end

    always @(*) begin
        pc_out = pc;
        inst_out = inst;

        is_exception = 3'b0;
        pc_exception_cause          = `EXCEPTION_INE;
        instbuffer_exception_cause  = `EXCEPTION_INE;
        decoder_exception_cause     = `EXCEPTION_INE;
        
        reg1_read_en = 1'b0;
        reg2_read_en = 1'b0;
        reg1_read_addr = 5'b0;
        reg2_read_addr = 5'b0;
        imm = 32'b0;
        invtlb_op = 5'b0;
    end
        
    always @(*) begin
        case(opcode)
            `ERTN_OPCODE: begin
                is_privilege = 1'b1;
                is_cnt = 1'b0;
                reg_writen_en = 1'b0;
                aluop = `ALU_ERTN;
                alusel = `ALU_SEL_NOP;
                inst_valid = 1'b1;
                reg_write_addr = 5'b0;
                
                csr_read_en = 1'b0;
                csr_addr = `CSR_TID;
                csr_write_en = 1'b0;
            end
            `RDCNTID_OPCODE:begin
                is_privilege = 1'b0;
                is_cnt = 1'b1;
                reg_writen_en = 1'b1;
                alusel = `ALU_SEL_CSR;
                inst_valid = 1'b1;

                csr_addr = `CSR_TID;
                csr_write_en = 1'b0;
                if(rj == 5'b0) begin
                    aluop = `ALU_RDCNTVLW;
                    reg_write_addr = rd;
                    csr_read_en = 1'b0;
                end else begin
                    aluop = `ALU_RDCNTID;
                    reg_write_addr = rj;
                    csr_read_en = 1'b1;
                end
            end
            `RDCNTVHW_OPCODE: begin
                is_cnt = 1'b1;
                is_privilege = 1'b0;
                reg_writen_en = 1'b1;
                aluop = `ALU_RDCNTVHW;
                alusel = `ALU_SEL_CSR;
                inst_valid = 1'b1;
                reg_write_addr = rd;

                csr_read_en = 1'b0;
                csr_addr = `CSR_TID;
                csr_write_en = 1'b0;
            end
            `TLBSRCH_OPCODE: begin
                is_privilege = 1'b1;
                is_cnt = 1'b0;
                reg_writen_en = 1'b0;
                aluop = `ALU_TLBSRCH;
                alusel = `ALU_SEL_CSR;
                inst_valid = 1'b1;
                reg_write_addr = 5'b0;

                csr_read_en = 1'b0;
                csr_addr = 14'b11_1111_1111_1111;
                csr_write_en = 1'b1;
            end
            `TLBRD_OPCODE: begin
                is_privilege = 1'b1;
                is_cnt = 1'b0;
                reg_writen_en = 1'b1;
                aluop = `ALU_TLBRD;
                alusel = `ALU_SEL_CSR;
                inst_valid = 1'b1;
                reg_write_addr = 5'b0;

                csr_read_en = 1'b0;
                csr_addr = 14'b11_1111_1111_1111;
                csr_write_en = 1'b1;
            end
            `TLBWR_OPCODE: begin
                is_privilege = 1'b1;
                is_cnt = 1'b0;
                reg_writen_en = 1'b0;
                aluop = `ALU_TLBWR;
                alusel = `ALU_SEL_CSR;
                inst_valid = 1'b1;
                reg_write_addr = 5'b0;

                csr_read_en = 1'b0;
                csr_addr = 14'b11_1111_1111_1111;
                csr_write_en = 1'b1;
            end
            `TLBFILL_OPCODE: begin
                is_privilege = 1'b1;
                is_cnt = 1'b0;
                reg_writen_en = 1'b0;
                aluop = `ALU_TLBFILL;
                alusel = `ALU_SEL_CSR;
                inst_valid = 1'b1;
                reg_write_addr = 5'b0;

                csr_read_en = 1'b0;
                csr_addr = 14'b11_1111_1111_1111;
                csr_write_en = 1'b1;
            end
            default: begin
                is_privilege = 1'b0;
                is_cnt = 1'b0;
                reg_writen_en = 1'b0;
                aluop = `ALU_NOP;
                alusel = `ALU_SEL_NOP;
                inst_valid = 1'b0;
                reg_write_addr = 5'b0;

                csr_read_en = 1'b0;
                csr_addr = `CSR_TID;
                csr_write_en = 1'b0;
            end
        endcase
    end
endmodule
