module ALU_srcGenerator(
    input  wire        reset, //暂时用不到
    input  wire        inst_add_w,
    input  wire        inst_addi_w,
    input  wire        inst_slti,
    input  wire        inst_sltui,
    input  wire        inst_andi,
    input  wire        inst_ori,
    input  wire        inst_xori,
    input  wire        inst_sub_w,
    input  wire        inst_ld_w,
    input  wire        inst_ld_h,
    input  wire        inst_ld_b,
    input  wire        inst_ld_hu,
    input  wire        inst_ld_bu,
    input  wire        inst_st_w,
    input  wire        inst_st_b,
    input  wire        inst_st_h,
    input  wire        inst_bne,
    input  wire        inst_slt,
    input  wire        inst_sltu,
    input  wire        inst_and,
    input  wire        inst_or,
    input  wire        inst_nor,
    input  wire        inst_xor,
    input  wire        inst_slli_w,
    input  wire        inst_srli_w,
    input  wire        inst_srai_w,
    input  wire        inst_sll_w,
    input  wire        inst_srl_w,
    input  wire        inst_sra_w,
    input  wire        inst_b,
    input  wire        inst_bl,
    input  wire        inst_beq,
    input  wire        inst_blt,
    input  wire        inst_bge,
    input  wire        inst_bltu,
    input  wire        inst_bgeu,
    input  wire        inst_jirl,
    input  wire        inst_lu12i_w,
    input  wire        inst_pcaddu12i,
    input  wire [31:0] rj_value,
    input  wire [31:0] rkd_value,
    input  wire [31:0] imm,

    input  wire [31:0] pc,

    output wire [31:0] alu_src1,
    output wire [31:0] alu_src2
);

//生成alu的两个操作数
wire src1_is_pc;
wire src2_is_imm;

assign src1_is_pc = inst_bl | inst_pcaddu12i;
assign src2_is_imm   = inst_slli_w
                     | inst_srli_w
                     | inst_srai_w
                     | inst_addi_w 
                     | inst_slti
                     | inst_sltui
                     | inst_andi
                     | inst_ori
                     | inst_xori
                     | inst_ld_w 
                     | inst_ld_h
                     | inst_ld_b
                     | inst_ld_hu
                     | inst_ld_bu
                     | inst_st_w
                     | inst_st_b
                     | inst_st_h
                     | inst_lu12i_w
                     | inst_pcaddu12i
                     | inst_jirl
                     | inst_bl;

assign alu_src1  = src1_is_pc  ? pc : rj_value;
assign alu_src2  = src2_is_imm ? imm : rkd_value;


endmodule