// ============================================================
// get_reg_read_addr：按指令类型产生 regfile 两读口地址。rj 类指令读 rj→raddr1；
// rk 类读 rk→raddr2；beq/st 等第二源为 rd 时 raddr2←rd。无读口时地址 0。
// grra_unused_inputs：归约读入部分 inst 位，为了解决run linter报错，不影响原有逻辑
// ============================================================
module get_reg_read_addr(
    input  wire        reset,
    input  wire [31:0] inst,
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
    input  wire        inst_mul_w,     // 乘法
    input  wire        inst_mulh_w,    // 有符号乘法高位结果
    input  wire        inst_mulh_wu,   // 有符号/无符号混合乘法高位结果
    input  wire        inst_div_w,     // 有符号除法
    input  wire        inst_div_wu,    // 无符号除法
    input  wire        inst_mod_w,     // 有符号取余
    input  wire        inst_mod_wu,    // 无符号取余
    input  wire        inst_ertn,      // 例外返回
    input  wire        inst_syscall,   // 系统调用
    input  wire        inst_break,     // 断点
    input  wire        inst_rdcntvl_w, // 读时间戳计
    input  wire        inst_rdcntvh_w, // 读时间戳计高位
    input  wire        inst_rdcntid,   // 读时间戳计器 ID
    input  wire        inst_csrrd,     // CSR 读
    input  wire        inst_csrwr,     // CSR 写
    input  wire        inst_csrxchg,   // CSR 读写交换
    output wire [ 4:0] rf_raddr1,
    output wire [ 4:0] rf_raddr2
);

wire [4:0] rd;
wire [4:0] rj;
wire [4:0] rk;
wire       need_rj;
wire       need_rk;
wire       src_reg_is_rd;
wire       grra_unused_inputs; // get_reg_read_addr的开头字母合成的

assign rd = inst[ 4: 0];
assign rj = inst[ 9: 5];
assign rk = inst[14:10];

assign grra_unused_inputs = reset | inst_lu12i_w | inst_pcaddu12i | (|inst); // 为了解决run linter报错，不影响原有逻辑

assign need_rj = inst_add_w  | inst_addi_w | inst_slti | inst_sltui
               | inst_andi   | inst_ori    | inst_xori | inst_sub_w
               | inst_ld_w   | inst_ld_h   | inst_ld_b | inst_ld_hu | inst_ld_bu
               | inst_st_w   | inst_st_b   | inst_st_h
               | inst_slt    | inst_sltu   | inst_and   | inst_or   | inst_nor
               | inst_xor    | inst_slli_w | inst_srli_w| inst_srai_w
               | inst_sll_w  | inst_srl_w  | inst_sra_w
               | inst_beq    | inst_bne    | inst_jirl
               | inst_blt    | inst_bge
               | inst_bltu   | inst_bgeu
               | inst_mul_w  | inst_mulh_w | inst_mulh_wu
               | inst_div_w  | inst_div_wu | inst_mod_w | inst_mod_wu
               | inst_csrwr  | inst_csrxchg | inst_rdcntid;

assign need_rk = inst_add_w | inst_sub_w | inst_slt | inst_sltu
               | inst_and   | inst_or    | inst_nor | inst_xor
               | inst_sll_w | inst_srl_w | inst_sra_w
               | inst_mul_w | inst_mulh_w | inst_mulh_wu
               | inst_div_w | inst_div_wu | inst_mod_w | inst_mod_wu | inst_csrxchg;

assign src_reg_is_rd = inst_st_w | inst_beq | inst_bne | inst_st_b | inst_st_h
                    | inst_blt | inst_bge | inst_bltu | inst_bgeu; // 第二源来自 rd 的指令

assign rf_raddr1 = need_rj ? rj : (5'd0 | (5'd0 & {5{grra_unused_inputs}}));
assign rf_raddr2 = src_reg_is_rd ? rd : (need_rk ? rk : (5'd0 | (5'd0 & {5{grra_unused_inputs}})));

endmodule
