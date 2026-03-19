`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"


module id_3R
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
    output reg  reg_write_en,  //寄存器写使能信号
    output reg  [7:0]aluop,
    output reg  [2:0]alusel,
    output reg  [31:0]imm,
    output reg        is_div,
    output reg        is_mul,
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
    output reg  [4:0] invtlb_op,  //TLB无效操作

    output wire invtlb_exception
    
);
    reg [16:0] opcode;
    reg [4:0] rk;
    reg [4:0] rj;  
    reg [4:0] rd;
    reg [4:0] ui5;

    assign invtlb_exception = (opcode == `INVTLB_OPCODE) & !((rd==5'd0) | (rd==5'd1) |(rd==5'd2) |(rd==5'd3) |(rd==5'd4) |(rd==5'd5) |(rd==5'd6));
    always @(*) begin
        opcode = inst[31:15];
        rk = inst[14:10];
        rj = inst[9:5];
        rd = inst[4:0];
        ui5 = inst[14:10];

        is_exception = 3'b0;
        pc_exception_cause          = `EXCEPTION_INE;
        instbuffer_exception_cause  = `EXCEPTION_INE;
        decoder_exception_cause     = `EXCEPTION_INE;
        
        pc_out = pc;
        inst_out = inst;
        reg1_read_addr = rj;
        reg2_read_addr = rk;
        
        csr_read_en = 1'b0;
        csr_write_en = 1'b0;
        csr_addr = 14'b0;
        is_cnt = 1'b0;
    end

    always @(*) begin

        case(opcode)
            `ADDW_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_ADDW;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `SUBW_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_SUBW;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `AND_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_AND;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `SLT_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_SLT;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `SLTU_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_SLTU;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `OR_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_OR;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `XOR_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_XOR;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `NOR_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_NOR;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `SLLW_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_SLLW;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `SRLW_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_SRLW;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `SRAW_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_SRAW;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `SLLIW_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_SLLIW;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                imm = {27'b0,ui5};
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `SRLIW_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_SRLIW;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                imm = {27'b0,ui5};
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `SRAIW_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_SRAIW;
                alusel = `ALU_SEL_ARITHMETIC;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b0;
                imm = {27'b0,ui5};
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `MULW_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_MULW;
                alusel = `ALU_SEL_MUL;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b1; 
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `MULHW_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_MULHW;
                alusel = `ALU_SEL_MUL;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b1;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `MULHWU_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_MULHWU;
                alusel = `ALU_SEL_MUL;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b1;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `DIVW_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_DIVW;
                alusel = `ALU_SEL_DIV;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b1;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `DIVWU_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_DIVWU;
                alusel = `ALU_SEL_DIV;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b1;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `MODW_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_MODW;
                alusel = `ALU_SEL_DIV;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b1;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `MODWU_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b1;
                reg_write_addr = rd;
                aluop = `ALU_MODWU;
                alusel = `ALU_SEL_DIV;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b1;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `BREAK_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b0;
                reg_write_addr = 5'b0;
                aluop = `ALU_BREAK;
                alusel = `ALU_SEL_NOP;
                reg1_read_en = 1'b0;
                reg2_read_en = 1'b0;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `SYSCALL_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b0;
                reg_write_addr = 5'b0;
                aluop = `ALU_SYSCALL;
                alusel = `ALU_SEL_NOP;
                reg1_read_en = 1'b0;
                reg2_read_en = 1'b0;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `IDLE_OPCODE:begin
                is_privilege = 1'b1;
                reg_write_en = 1'b0;
                reg_write_addr = 5'b0;
                aluop = `ALU_IDLE;
                alusel = `ALU_SEL_NOP;
                reg1_read_en = 1'b0;
                reg2_read_en = 1'b0;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `INVTLB_OPCODE:begin
                is_privilege = 1'b1;
                reg_write_en = 1'b0;
                reg_write_addr = 5'b0;
                aluop = `ALU_INVTLB;
                alusel = `ALU_SEL_NOP;
                reg1_read_en = 1'b1;
                reg2_read_en = 1'b1;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = rd; // TLB invalidation operation
            end
            `DBAR_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b0;
                reg_write_addr = 5'b0;
                aluop = `ALU_NOP;
                alusel = `ALU_SEL_NOP;
                reg1_read_en = 1'b0;
                reg2_read_en = 1'b0;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            `IBAR_OPCODE:begin
                is_privilege = 1'b0;
                reg_write_en = 1'b0;
                reg_write_addr = 5'b0;
                aluop = `ALU_NOP;
                alusel = `ALU_SEL_NOP;
                reg1_read_en = 1'b0;
                reg2_read_en = 1'b0;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b1;
                invtlb_op = 5'b0;
            end
            default: begin
                is_privilege = 1'b0;
                reg_write_en = 1'b0;
                reg_write_addr = 5'b0;
                aluop = `ALU_NOP;
                alusel = `ALU_SEL_NOP;
                reg1_read_en = 1'b0;
                reg2_read_en = 1'b0;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                inst_valid = 1'b0;
                invtlb_op = 5'b0;
            end
        endcase
    end
endmodule