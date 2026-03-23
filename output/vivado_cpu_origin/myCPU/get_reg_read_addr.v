module get_reg_read_addr(
    input  wire        reset,
    input  wire [31:0] inst,
    input  wire        inst_add_w,
    input  wire        inst_addi_w,
    input  wire        inst_sub_w,
    input  wire        inst_ld_w,
    input  wire        inst_st_w,
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
    input  wire        inst_b,
    input  wire        inst_bl,
    input  wire        inst_beq,
    input  wire        inst_jirl,
    input  wire        inst_lu12i_w,
    output wire [ 4:0] rf_raddr1,
    output wire [ 4:0] rf_raddr2
);
//todo:得到reg的两个地址
endmodule