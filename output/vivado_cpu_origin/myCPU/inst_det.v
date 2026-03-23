module inst_det(
    input  wire        reset,
    input  wire [31:0] inst,
    output wire        inst_add_w,
    output wire        inst_addi_w,
    output wire        inst_sub_w,
    output wire        inst_ld_w,
    output wire        inst_st_w,
    output wire        inst_bne,
    output wire        inst_slt,
    output wire        inst_sltu,
    output wire        inst_and,
    output wire        inst_or,
    output wire        inst_nor,
    output wire        inst_xor,
    output wire        inst_slli_w,
    output wire        inst_srli_w,
    output wire        inst_srai_w,
    output wire        inst_b,
    output wire        inst_bl,
    output wire        inst_beq,
    output wire        inst_jirl,
    output wire        inst_lu12i_w
);
//todo:指令译码，输出指令标志位
endmodule