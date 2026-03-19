`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"


module branch_alu (
    input wire [31:0] pc,          // ????????
    input wire [31:0] inst,        // ????????
    input wire [7:0]  aluop,       // ALU????????

    input wire [31:0] reg1,        // ??????1???
    input wire [31:0] reg2,        // ??????2???

    input wire pre_is_branch_taken,     // ?????????????????
    input wire [31:0] pre_branch_addr,  // ????????????????

    output wire update_en,                  // ??????????????????
    output reg taken_or_not_actual,        // ??????????????????
    output reg [31:0] branch_actual_addr,  // ??????????????????
    output wire [31:0] pc_dispatch,         // ????dispatch??pc

    output reg branch_flush,             // ??????????????
    output wire [31:0] branch_alu_res,     // ALU?????? 

    input wire icacop_en,
    input wire dcacop_en
);

    wire reg1_eq_reg2;          // ??????1???????2??????
    wire reg1_lt_reg2;          // ??????1???��???????2

    assign reg1_eq_reg2 = (reg1 == reg2);

    wire [31:0] reg2_i_mux;     // ??????2?????
    
    wire [31:0] sum_result;     // ????????

    assign reg2_i_mux = ((aluop == `ALU_BLT) || (aluop == `ALU_BGE)) ? ~reg2 + 1 : reg2;
    assign sum_result = reg1 + reg2_i_mux;

    assign reg1_lt_reg2 = ((aluop == `ALU_BLT) || (aluop == `ALU_BGE)) ? 
                          ((reg1[31] && !reg2[31]) ||                      // ????????reg1???
                           (!reg1[31] && !reg2[31] && sum_result[31]) ||   // ??????????????
                           (reg1[31] && reg2[31] && sum_result[31])        // ??????????????
                          ) : (reg1 < reg2);  // ???????

    wire [31:0] branch16_addr = {{14{inst[25]}}, inst[25:10], 2'b00};           // ???????16��????????
    wire [31:0] branch26_addr = {{4{inst[9]}}, inst[9:0], inst[25:10], 2'b00};  // ???????26?????????

    reg is_branch;                 // ?????????? 
    reg is_branch_taken;           // ????????????
    reg [31:0] branch_target_addr; // ???????????

    assign branch_alu_res = pc + 32'h4;

    always @(*) begin
        case (aluop) 
            `ALU_BEQ: begin
                is_branch           =  1'b1;
                is_branch_taken     =  reg1_eq_reg2 ? 1'b1 : 1'b0;
                branch_target_addr  =  pc + branch16_addr;
            end
            
            `ALU_BNE: begin
                is_branch           =  1'b1;
                is_branch_taken     =  !reg1_eq_reg2 ? 1'b1 : 1'b0;
                branch_target_addr  =  pc + branch16_addr;
            end

            `ALU_BLT, `ALU_BLTU: begin
                is_branch = 1'b1;
                is_branch_taken     =  reg1_lt_reg2 ? 1'b1 : 1'b0;
                branch_target_addr  =  pc + branch16_addr;
            end

            `ALU_BGE, `ALU_BGEU: begin
                is_branch           =  1'b1;
                is_branch_taken     =  !reg1_lt_reg2 ? 1'b1 : 1'b0;
                branch_target_addr  =  pc + branch16_addr;
            end

            `ALU_B: begin
                is_branch           =  1'b1;
                is_branch_taken     =  (pc + branch26_addr) != (pc + 4);
                branch_target_addr  =  pc + branch26_addr;
            end

            `ALU_BL: begin
                is_branch           =  1'b1;
                is_branch_taken     =  (pc + branch26_addr) != (pc + 4);
                branch_target_addr  =  pc + branch26_addr;
            end

            `ALU_JIRL: begin
                is_branch           =  1'b1;
                is_branch_taken     =  (reg1 + branch16_addr) != (pc + 4);
                branch_target_addr  =  reg1 + branch16_addr;
            end

            `ALU_CACOP: begin
                is_branch           =  1'b0;
                is_branch_taken     =  1'b0;
                branch_target_addr  =  pc + 4;//icacop_en ? (pc + 4) : (pc + 8) ;
            end

            default: begin
                is_branch           =  1'b0;
                is_branch_taken     =  1'b0;
                branch_target_addr  =  32'b0; // ???????
            end
        endcase
    end

    wire [2:0] branch_pre_vec;      // ??????????????????��?????????
    assign branch_pre_vec = {is_branch, is_branch_taken, pre_is_branch_taken};

    // ???????????????
    always @(*) 
    begin
        case (branch_pre_vec)
            // ???1????????????????????????????
            3'b111: begin
                branch_flush = pre_branch_addr != branch_actual_addr;     // ????????????????????????????
            end
            3'b110,3'b101: begin
                branch_flush = pre_branch_addr != branch_actual_addr;
            end
            3'b001: begin
                branch_flush = 1'b1; // ????????��???????  
            end
            // ?????????????????????????
            default: begin
                branch_flush = 1'b0;
            end
        endcase
    end

    always @(*) begin
        case (branch_pre_vec)
            3'b111: begin
                taken_or_not_actual = 1'b1;
                branch_actual_addr  = branch_target_addr;
            end
            3'b101:begin
                taken_or_not_actual = 1'b0;
                branch_actual_addr  = pc + 32'h4;
            end
            3'b110:begin
                taken_or_not_actual = 1'b1;
                branch_actual_addr  = branch_target_addr; 
            end
            3'b001:begin
                taken_or_not_actual = 1'b0;
                branch_actual_addr  = pc + 32'h4; 
            end
            default: begin   //100  000
                taken_or_not_actual = 1'b0;
                branch_actual_addr  = pc + 32'h4; 
            end
        endcase    
    end

    assign pc_dispatch = pc;
    assign update_en   = is_branch && (aluop != `ALU_B || aluop != `ALU_BL); 

endmodule