module imm_generator (
    input wire reset,        // 目前还用不到
    input wire [31:0] inst,
    input wire inst_add_w,
    input wire inst_addi_w,
    input wire inst_sub_w,
    input wire inst_ld_w,
    input wire inst_st_w,
    input wire inst_bne,
    input wire inst_slt,
    input wire inst_sltu,
    input wire inst_and,
    input wire inst_or,
    input wire inst_nor,
    input wire inst_xor,
    input wire inst_slli_w,
    input wire inst_srli_w,
    input wire inst_srai_w,
    input wire inst_b,
    input wire inst_bl,
    input wire inst_beq,
    input wire inst_jirl,
    input wire inst_lu12i_w,

    output wire [31:0] alu_imm,
    output wire [31:0] br_imm
);
    
    wire [4:0] ui5;
    wire [11:0] i12;
    wire [15:0] i16;
    wire [19:0] i20;
    wire [25:0] i26;
    
    wire need_ui5;
    wire need_si12;
    wire need_si16;
    wire need_si20;
    wire need_si26;
    wire src2_is_4;
    
    
    assign need_ui5  = inst_slli_w | inst_srli_w | inst_srai_w;
    assign need_si12 = inst_addi_w | inst_ld_w | inst_st_w;
    assign need_si16 = inst_jirl | inst_beq | inst_bne;
    assign need_si20 = inst_lu12i_w;
    assign need_si26 = inst_b | inst_bl;
    assign src2_is_4 = inst_jirl | inst_bl;
    
    assign ui5 = inst[14:10];
    assign i12 = inst[21:10];
    assign i16 = inst[25:10];
    assign i20 = inst[24: 5];
    assign i26 = {inst[9: 0] , inst[25:10]};
    
    assign alu_imm = src2_is_4 ? 32'h4               :
    need_si20 ? {i20[19:0] , 12'b0} :
    need_si12 ? {{20{i12[11]}} , i12[11:0]} :
    need_ui5  ? {27'b0 , ui5[4:0]} :
    need_si26 ? {{ 4{i26[25]}} , i26[25:0] , 2'b00}:
    need_si16 ? {{14{i16[15]}} , i16[15:0] , 2'b00}:
    32'b0;

    assign br_imm = need_si26 ? {{ 4{i26[25]}} , i26[25:0] , 2'b00}:
                    need_si16 ? {{14{i16[15]}} , i16[15:0] , 2'b00}:
                    32'b0;
    
    //todo:生成立即
endmodule
