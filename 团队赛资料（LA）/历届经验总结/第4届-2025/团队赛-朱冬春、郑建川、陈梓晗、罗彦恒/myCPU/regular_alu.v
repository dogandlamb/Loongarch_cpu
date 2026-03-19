`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"

// 常规加法器
module regular_alu (
    input wire [7:0] aluop,     // ALU操作码（8位）

    input wire [31:0] reg1,     // 操作数1
    input wire [31:0] reg2,     // 操作数2

    output reg [31:0] result    // 计算结果
);

    wire reg1_lt_reg2;          // 有符号数/无符号数比较
    wire [31:0] reg2_i_mux;     // 选择后的操作数2  
    wire [31:0] sum_result;     // 加法器结果

    // 操作数2选择：减法/SLT、SLTI指令时取补码，其余指令用原来的值
    assign reg2_i_mux = ((aluop == `ALU_SUBW) || (aluop == `ALU_SLT) || (aluop == `ALU_SLTI))
                        ? ~reg2 + 32'b1
                        : reg2;

    // 加法器输出
    assign sum_result = reg1 + reg2_i_mux;

    // 操作数比较逻辑
    assign reg1_lt_reg2 = ((aluop == `ALU_SLT) || (aluop == `ALU_SLTI)) ?   // 有符号比较
                          ( (reg1[31] && !reg2[31]) ||                      // 符号不同且reg1为负
                            (!reg1[31] && !reg2[31] && sum_result[31]) ||   // 同正且相减结果为负
                            (reg1[31] && reg2[31] && sum_result[31])        // 同负且相减结果为负
                          ) : (reg1 < reg2);  // 无符号比较（SLTU/SLTUI）

    // 主ALU计算逻辑
    always @(*) begin
        case(aluop)
            `ALU_ADDW, `ALU_SUBW, `ALU_ADDIW, `ALU_PCADDU12I,`ALU_CACOP: begin
                result = sum_result;
            end
            `ALU_AND, `ALU_ANDI: begin
                result = reg1 & reg2;
            end
            `ALU_OR, `ALU_ORI, `ALU_LU12I: begin
                result = reg1 | reg2;       // 对于lu12i指令，因为只要将立即数赋值给目的寄存器即可，因此将两个操作数按位或
            end
            `ALU_XOR, `ALU_XORI : begin
                result = reg1 ^ reg2;
            end
            `ALU_NOR : begin
                result = ~(reg1 | reg2);
            end
            `ALU_SLLW, `ALU_SLLIW: begin
                result = reg1 << reg2[4:0];
            end
            `ALU_SRLW, `ALU_SRLIW: begin
                result = reg1 >> reg2[4:0];
            end
            `ALU_SRAW, `ALU_SRAIW: begin
                result = ({32{reg1[31]}} << (6'd32 - {1'b0, reg2[4:0]})) | reg1 >> reg2[4:0];
            end
            `ALU_SLT, `ALU_SLTU, `ALU_SLTI, `ALU_SLTUI: begin
                result = {31'b0, reg1_lt_reg2};
            end
            default : begin
                result = 32'b0;
            end
        endcase
    end

endmodule