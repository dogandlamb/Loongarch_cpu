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

wire [ 4:0] rd;//rd寄存器地址
wire [ 4:0] rj;//rj寄存器地址
wire [ 4:0] rk;//rk寄存器地址
wire need_rj;
wire need_rk;
wire src_reg_is_rd;
wire inst_ori;

assign rd       = inst[ 4: 0];
assign rj       = inst[ 9: 5];
assign rk       = inst[14:10];
assign inst_ori = (inst[31:26] == 6'h00) && (inst[25:22] == 4'he);

assign need_rj = inst_add_w  | inst_addi_w | inst_sub_w | inst_ld_w | inst_st_w
               | inst_slt    | inst_sltu   | inst_and   | inst_or   | inst_nor
               | inst_xor    | inst_slli_w | inst_srli_w| inst_srai_w
               | inst_beq    | inst_bne    | inst_jirl  | inst_ori;

assign need_rk = inst_add_w | inst_sub_w | inst_slt | inst_sltu
               | inst_and   | inst_or    | inst_nor | inst_xor;

assign src_reg_is_rd = inst_st_w | inst_beq | inst_bne;

assign rf_raddr1 = need_rj ? rj : 5'd0;
assign rf_raddr2 = src_reg_is_rd ? rd : (need_rk ? rk : 5'd0);

//得到reg的两个地址
endmodule