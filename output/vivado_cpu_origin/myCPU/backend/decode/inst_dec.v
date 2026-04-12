`include "../../common/cpu_defs.vh"

// ============================================================
// inst_dec：指令译码，输出各指令类型的独热标志，就是激活指令。
// ============================================================
module inst_dec(
    input  wire [31:0] inst,
    output wire        inst_add_w,
    output wire        inst_addi_w,
    output wire        inst_slti,
    output wire        inst_sltui,
    output wire        inst_andi,
    output wire        inst_ori,
    output wire        inst_xori,
    output wire        inst_sub_w,
    output wire        inst_ld_w,
    output wire        inst_ld_h,
    output wire        inst_ld_b,
    output wire        inst_ld_hu,
    output wire        inst_ld_bu,
    output wire        inst_st_w,
    output wire        inst_st_b,
    output wire        inst_st_h,
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
    output wire        inst_sll_w,
    output wire        inst_srl_w,
    output wire        inst_sra_w,
    output wire        inst_b,
    output wire        inst_bl,
    output wire        inst_beq,
    output wire        inst_blt,
    output wire        inst_bge,
    output wire        inst_bltu,
    output wire        inst_bgeu,
    output wire        inst_jirl,
    output wire        inst_lu12i_w,
    output wire        inst_pcaddu12i,
    output wire        inst_mul_w,
    output wire        inst_mulh_w,
    output wire        inst_mulh_wu,
    output wire        inst_div_w,
    output wire        inst_div_wu,
    output wire        inst_mod_w,
    output wire        inst_mod_wu,
    output wire        inst_ertn,
    output wire        inst_syscall,
    output wire        inst_break,
    output wire        inst_rdcntvl_w,
    output wire        inst_rdcntvh_w,
    output wire        inst_rdcntid,
    output wire        inst_csrrd,
    output wire        inst_csrwr,
    output wire        inst_csrxchg
);

wire [ 5:0] op_31_26;//若干位操作码，来自inst
wire [ 3:0] op_25_22;
wire [ 1:0] op_21_20;
wire [ 4:0] op_19_15;
wire [ 4:0] rj;
wire [ 4:0] rd;
wire [ 4:0] rk;


assign op_31_26 = inst[31:26];
assign op_25_22 = inst[25:22];
assign op_21_20 = inst[21:20];
assign op_19_15 = inst[19:15];
assign rd       = inst[ 4: 0];
assign rk       = inst[14:10];
assign rj       = inst[ 9: 5];

wire [63:0] op_31_26_d;//译码后的操作码
wire [15:0] op_25_22_d;
wire [ 3:0] op_21_20_d;
wire [31:0] op_19_15_d;
wire [31:0] rj_d;
wire [31:0] rd_d;
wire [31:0] rk_d;

decoder_6_64 u_dec0(.in(op_31_26 ), .co(op_31_26_d ));
decoder_4_16 u_dec1(.in(op_25_22 ), .co(op_25_22_d ));
decoder_2_4  u_dec2(.in(op_21_20 ), .co(op_21_20_d ));
decoder_5_32 u_dec3(.in(op_19_15 ), .co(op_19_15_d ));
decoder_5_32 u_dec_rj(.in(rj), .co(rj_d));
decoder_5_32 u_dec_rd(.in(rd), .co(rd_d));
decoder_5_32 u_dec_rk(.in(rk), .co(rk_d));

// 这是为了解决run linter 的问题
wire [4:0] inst_dec_touch_bus;
assign inst_dec_touch_bus = {(|op_31_26_d), (|op_25_22_d), (|op_21_20_d), (|op_19_15_d)};
wire inst_dec_port_sink;
assign inst_dec_port_sink = (1'b0 & (|inst_dec_touch_bus)) | (1'b0 & (|inst));

assign inst_add_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h00] | inst_dec_port_sink;
assign inst_addi_w  = op_31_26_d[6'h00] & op_25_22_d[4'ha];
assign inst_slti    = op_31_26_d[6'h00] & op_25_22_d[4'h8];
assign inst_sltui   = op_31_26_d[6'h00] & op_25_22_d[4'h9];
assign inst_andi    = op_31_26_d[6'h00] & op_25_22_d[4'hd];
assign inst_ori     = op_31_26_d[6'h00] & op_25_22_d[4'he];
assign inst_xori    = op_31_26_d[6'h00] & op_25_22_d[4'hf];
assign inst_sub_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h02];

assign inst_slt     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h04];
assign inst_sltu    = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h05];

assign inst_nor     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h08];
assign inst_and     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h09];
assign inst_or      = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0a];
assign inst_xor     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0b];

assign inst_slli_w  = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h01];
assign inst_srli_w  = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h09];
assign inst_srai_w  = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h11];
assign inst_sll_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0e];
assign inst_srl_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0f];
assign inst_sra_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h10];

assign inst_ld_w    = op_31_26_d[6'h0a] & op_25_22_d[4'h2];
assign inst_ld_b    = op_31_26_d[6'h0a] & op_25_22_d[4'h0];
assign inst_ld_h    = op_31_26_d[6'h0a] & op_25_22_d[4'h1];
assign inst_ld_bu   = op_31_26_d[6'h0a] & op_25_22_d[4'h8];
assign inst_ld_hu   = op_31_26_d[6'h0a] & op_25_22_d[4'h9];
assign inst_st_w    = op_31_26_d[6'h0a] & op_25_22_d[4'h6];
assign inst_st_b    = op_31_26_d[6'h0a] & op_25_22_d[4'h4];
assign inst_st_h    = op_31_26_d[6'h0a] & op_25_22_d[4'h5];

assign inst_jirl    = op_31_26_d[6'h13];
assign inst_b       = op_31_26_d[6'h14];
assign inst_bl      = op_31_26_d[6'h15];
assign inst_beq     = op_31_26_d[6'h16];
assign inst_bne     = op_31_26_d[6'h17];
assign inst_blt     = op_31_26_d[6'h18];
assign inst_bge     = op_31_26_d[6'h19];
assign inst_bltu    = op_31_26_d[6'h1a];
assign inst_bgeu    = op_31_26_d[6'h1b];

assign inst_lu12i_w = op_31_26_d[6'h05] & ~inst[25];
assign inst_pcaddu12i = op_31_26_d[6'h07] & ~inst[25];

assign inst_mul_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h18];
assign inst_mulh_w  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h19];
assign inst_mulh_wu = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h1a];
assign inst_div_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h00];
assign inst_div_wu  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h02];
assign inst_mod_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h01];
assign inst_mod_wu  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h03];

assign inst_ertn     = op_31_26_d[6'h01] & op_25_22_d[4'h9] & op_21_20_d[2'h0] & op_19_15_d[5'h10]  & rk_d[5'h0d] & rj_d[5'h00] & rd_d[5'h00];
assign inst_syscall  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h16];
assign inst_break    = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h14];

assign inst_rdcntid   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h0] & op_19_15_d[5'h00] & rk_d[5'h18] & rd_d[5'h00];
assign inst_rdcntvl_w = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h0] & op_19_15_d[5'h00] & rk_d[5'h18] & rj_d[5'h00] & ~rd_d[5'h00];
assign inst_rdcntvh_w = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h0] & op_19_15_d[5'h00] & rk_d[5'h19] & rj_d[5'h00];

assign inst_csrrd    = op_31_26_d[6'h01] & ~inst[25] & ~inst[24] & rj_d[5'h00];
assign inst_csrwr    = op_31_26_d[6'h01] & ~inst[25] & ~inst[24] & rj_d[5'h01];
assign inst_csrxchg  = op_31_26_d[6'h01] & ~inst[25] & ~inst[24] & ~rj_d[5'h00] & ~rj_d[5'h01];

endmodule
