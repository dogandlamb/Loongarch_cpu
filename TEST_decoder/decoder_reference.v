// ============================================================
// decoder 模块（单条指令译码器，纯组合，顶层例化 `MACHINE_WIDTH 份）
// ------------------------------------------------------------
// 参考实现说明：
// - 内部例化旧译码工具（inst_dec/op_dec/imm_generator/get_reg_read_addr）；
// - FU 分类：MDU = 乘除/CSR/rdcnt/invtlb；MEM = ld/st/ll/sc(真store)/cacop；
//   其余 ALU（含分支）；tlbsrch/rd/wr/fill 与 ertn/idle/ibar/dbar/syscall/
//   break/INE 等"无需执行"指令一律 is_nop（分配 ROB 即完成，提交级落地）；
// - sc.w 译码期定性：llbit=1 -> 真 store（写回值由 commit 旁路为 1）；
//   llbit=0 -> 退化为"写 rd=0 的 ALU 指令"（alu_op 全 0 -> 结果 0）；
// - pcaddu12i/pcaddi 的 PC 加法在译码期完成（imm = pc + offs，op 改 LUI 直通）；
// - cacop 的 si12 偏移 imm_generator 未覆盖，本模块补；
// - csrwr 写值约定走 src1（覆盖 get_reg_read_addr 的 raddr1=rd 老约定）。
// ============================================================
`include "mycpu.h"

module decoder(
    input  wire [31:0]                inst_i,
    input  wire [31:0]                pc_i,
    input  wire [1:0]                 csr_plv_i,         // 当前特权级（CRMD.PLV）
    input  wire                       csr_llbit_i,       // 当前 LLBIT（sc.w 行为选择）

    // ---------------- FU 类型与操作码 ----------------
    output wire [`FU_NUM-1:0]         futype_o,          // 独热：进哪个保留站
    output wire [`ALU_OP_NUM-1:0]     alu_op_o,
    output wire [`BR_OP_NUM-1:0]      br_op_o,
    output wire [`MEM_OP_NUM-1:0]     mem_op_o,
    output wire [`CSR_OP_NUM-1:0]     csr_op_o,
    output wire [`TLB_OP_NUM-1:0]     tlb_op_o,
    output wire [`WB_SRC_NUM-1:0]     wb_src_op_o,
    output wire [13:0]                csr_num_o,         // CSR 号（高位补 0 到 14 位）
    output wire [4:0]                 cacop_code_o,      // cacop 的 code 域（inst[4:0]）

    // ---------------- 寄存器与立即数 ----------------
    output wire [4:0]                 src0_addr_o,       // 源 0 读地址（rj 类）
    output wire [4:0]                 src1_addr_o,       // 源 1 读地址（rk/rd 类，store 数据/csr 写值）
    output wire                       use_src0_o,        // 是否真正使用源 0
    output wire                       use_src1_o,        // 是否真正使用源 1
    output wire [4:0]                 rd_addr_o,         // 目的寄存器
    output wire                       rf_we_o,           // 是否写回（r0 恒不写，内部处理）
    output wire [31:0]                imm_o,             // ALU 立即数（已扩展）
    output wire                       use_imm_o,         // ALU 第二操作数取 imm
    output wire [31:0]                br_offs_o,         // 分支偏移（已扩展对齐）

    // ---------------- 分支属性 ----------------
    output wire                       is_branch_o,       // 任意分支/跳转
    output wire [`BR_TYPE_W-1:0]      br_type_o,         // COND/UNCOND/CALL/RET

    // ---------------- 提交特殊处理类 ----------------
    output wire [`PRIV_NUM-1:0]       priv_vec_o,        // 独热特权/特殊类标记
    output wire                       is_nop_o,          // 真 NOP/无需执行类：不占 FU

    // ---------------- 访存属性 ----------------
    output wire                       is_load_o,
    output wire                       is_store_o,

    // ---------------- 译码异常 ----------------
    output wire [`EXCP_NUM-1:0]       excp_o             // INE/SYS/BRK/IPE 四位可能置位
);

// ---------------- 第一步：例化译码工具 ----------------
wire inst_add_w, inst_addi_w, inst_slti, inst_sltui, inst_andi, inst_ori, inst_xori;
wire inst_sub_w, inst_ld_w, inst_ld_h, inst_ld_b, inst_ld_hu, inst_ld_bu;
wire inst_st_w, inst_st_b, inst_st_h, inst_bne, inst_slt, inst_sltu;
wire inst_and, inst_or, inst_nor, inst_xor, inst_slli_w, inst_srli_w, inst_srai_w;
wire inst_sll_w, inst_srl_w, inst_sra_w, inst_b, inst_bl, inst_beq, inst_blt;
wire inst_bge, inst_bltu, inst_bgeu, inst_jirl, inst_lu12i_w, inst_pcaddu12i;
wire inst_mul_w, inst_mulh_w, inst_mulh_wu, inst_div_w, inst_div_wu, inst_mod_w, inst_mod_wu;
wire inst_ertn, inst_syscall, inst_break, inst_rdcntvl_w, inst_rdcntvh_w, inst_rdcntid;
wire inst_csrrd, inst_csrwr, inst_csrxchg, inst_tlbsrch, inst_tlbrd, inst_tlbwr, inst_tlbfill;
wire inst_invtlb_0, inst_invtlb_1, inst_invtlb_2, inst_invtlb_3, inst_invtlb_4;
wire inst_invtlb_5, inst_invtlb_6, inst_cacop, inst_ibar, inst_ll_w, inst_sc_w;
wire inst_pcaddi, inst_andn, inst_orn, inst_dbar, inst_idle, inst_preld, inst_cpucfg;

inst_dec u_inst_dec(
    .inst        (inst_i),
    .inst_add_w  (inst_add_w),   .inst_addi_w (inst_addi_w), .inst_slti   (inst_slti),
    .inst_sltui  (inst_sltui),   .inst_andi   (inst_andi),   .inst_ori    (inst_ori),
    .inst_xori   (inst_xori),    .inst_sub_w  (inst_sub_w),  .inst_ld_w   (inst_ld_w),
    .inst_ld_h   (inst_ld_h),    .inst_ld_b   (inst_ld_b),   .inst_ld_hu  (inst_ld_hu),
    .inst_ld_bu  (inst_ld_bu),   .inst_st_w   (inst_st_w),   .inst_st_b   (inst_st_b),
    .inst_st_h   (inst_st_h),    .inst_bne    (inst_bne),    .inst_slt    (inst_slt),
    .inst_sltu   (inst_sltu),    .inst_and    (inst_and),    .inst_or     (inst_or),
    .inst_nor    (inst_nor),     .inst_xor    (inst_xor),    .inst_slli_w (inst_slli_w),
    .inst_srli_w (inst_srli_w),  .inst_srai_w (inst_srai_w), .inst_sll_w  (inst_sll_w),
    .inst_srl_w  (inst_srl_w),   .inst_sra_w  (inst_sra_w),  .inst_b      (inst_b),
    .inst_bl     (inst_bl),      .inst_beq    (inst_beq),    .inst_blt    (inst_blt),
    .inst_bge    (inst_bge),     .inst_bltu   (inst_bltu),   .inst_bgeu   (inst_bgeu),
    .inst_jirl   (inst_jirl),    .inst_lu12i_w(inst_lu12i_w),.inst_pcaddu12i(inst_pcaddu12i),
    .inst_mul_w  (inst_mul_w),   .inst_mulh_w (inst_mulh_w), .inst_mulh_wu(inst_mulh_wu),
    .inst_div_w  (inst_div_w),   .inst_div_wu (inst_div_wu), .inst_mod_w  (inst_mod_w),
    .inst_mod_wu (inst_mod_wu),  .inst_ertn   (inst_ertn),   .inst_syscall(inst_syscall),
    .inst_break  (inst_break),   .inst_rdcntvl_w(inst_rdcntvl_w), .inst_rdcntvh_w(inst_rdcntvh_w),
    .inst_rdcntid(inst_rdcntid), .inst_csrrd  (inst_csrrd),  .inst_csrwr  (inst_csrwr),
    .inst_csrxchg(inst_csrxchg), .inst_tlbsrch(inst_tlbsrch),.inst_tlbrd  (inst_tlbrd),
    .inst_tlbwr  (inst_tlbwr),   .inst_tlbfill(inst_tlbfill),.inst_invtlb_0(inst_invtlb_0),
    .inst_invtlb_1(inst_invtlb_1),.inst_invtlb_2(inst_invtlb_2),.inst_invtlb_3(inst_invtlb_3),
    .inst_invtlb_4(inst_invtlb_4),.inst_invtlb_5(inst_invtlb_5),.inst_invtlb_6(inst_invtlb_6),
    .inst_cacop  (inst_cacop),   .inst_ibar   (inst_ibar),   .inst_ll_w   (inst_ll_w),
    .inst_sc_w   (inst_sc_w),    .inst_pcaddi (inst_pcaddi), .inst_andn   (inst_andn),
    .inst_orn    (inst_orn),     .inst_dbar   (inst_dbar),   .inst_idle   (inst_idle),
    .inst_preld  (inst_preld),   .inst_cpucfg (inst_cpucfg)
);

wire [`ALU_OP_NUM-1:0]   od_alu_op;
wire [`BR_OP_NUM-1:0]    od_br_op;
wire [`MEM_OP_NUM-1:0]   od_mem_op;
wire [`CSR_OP_NUM-1:0]   od_csr_op;
wire [`WB_SRC_NUM-1:0]   od_wb_src_op;
wire [`TLB_OP_NUM-1:0]   od_tlb_op;
wire [`CACHE_OP_NUM-1:0] od_cache_op;
wire                     inst_known;

op_dec u_op_dec(
    .inst_add_w  (inst_add_w),   .inst_addi_w (inst_addi_w), .inst_slti   (inst_slti),
    .inst_sltui  (inst_sltui),   .inst_andi   (inst_andi),   .inst_ori    (inst_ori),
    .inst_xori   (inst_xori),    .inst_sub_w  (inst_sub_w),  .inst_ld_w   (inst_ld_w),
    .inst_ld_h   (inst_ld_h),    .inst_ld_b   (inst_ld_b),   .inst_ld_hu  (inst_ld_hu),
    .inst_ld_bu  (inst_ld_bu),   .inst_st_w   (inst_st_w),   .inst_st_b   (inst_st_b),
    .inst_st_h   (inst_st_h),    .inst_bne    (inst_bne),    .inst_slt    (inst_slt),
    .inst_sltu   (inst_sltu),    .inst_and    (inst_and),    .inst_or     (inst_or),
    .inst_nor    (inst_nor),     .inst_xor    (inst_xor),    .inst_slli_w (inst_slli_w),
    .inst_srli_w (inst_srli_w),  .inst_srai_w (inst_srai_w), .inst_sll_w  (inst_sll_w),
    .inst_srl_w  (inst_srl_w),   .inst_sra_w  (inst_sra_w),  .inst_b      (inst_b),
    .inst_bl     (inst_bl),      .inst_beq    (inst_beq),    .inst_blt    (inst_blt),
    .inst_bge    (inst_bge),     .inst_bltu   (inst_bltu),   .inst_bgeu   (inst_bgeu),
    .inst_jirl   (inst_jirl),    .inst_lu12i_w(inst_lu12i_w),.inst_pcaddu12i(inst_pcaddu12i),
    .inst_mul_w  (inst_mul_w),   .inst_mulh_w (inst_mulh_w), .inst_mulh_wu(inst_mulh_wu),
    .inst_div_w  (inst_div_w),   .inst_div_wu (inst_div_wu), .inst_mod_w  (inst_mod_w),
    .inst_mod_wu (inst_mod_wu),  .inst_csrrd  (inst_csrrd),  .inst_csrwr  (inst_csrwr),
    .inst_csrxchg(inst_csrxchg), .inst_rdcntvl_w(inst_rdcntvl_w), .inst_rdcntvh_w(inst_rdcntvh_w),
    .inst_rdcntid(inst_rdcntid), .inst_ertn   (inst_ertn),   .inst_syscall(inst_syscall),
    .inst_break  (inst_break),   .inst_tlbsrch(inst_tlbsrch),.inst_tlbrd  (inst_tlbrd),
    .inst_tlbwr  (inst_tlbwr),   .inst_tlbfill(inst_tlbfill),.inst_invtlb_0(inst_invtlb_0),
    .inst_invtlb_1(inst_invtlb_1),.inst_invtlb_2(inst_invtlb_2),.inst_invtlb_3(inst_invtlb_3),
    .inst_invtlb_4(inst_invtlb_4),.inst_invtlb_5(inst_invtlb_5),.inst_invtlb_6(inst_invtlb_6),
    .inst_cacop  (inst_cacop),   .inst_ibar   (inst_ibar),   .inst_ll_w   (inst_ll_w),
    .inst_sc_w   (inst_sc_w),    .inst_pcaddi (inst_pcaddi), .inst_andn   (inst_andn),
    .inst_orn    (inst_orn),     .inst_dbar   (inst_dbar),   .inst_idle   (inst_idle),
    .inst_preld  (inst_preld),   .inst_cpucfg (inst_cpucfg),
    .alu_op      (od_alu_op),
    .br_op       (od_br_op),
    .mem_op      (od_mem_op),
    .csr_op      (od_csr_op),
    .wb_src_op   (od_wb_src_op),
    .tlb_op      (od_tlb_op),
    .cache_op    (od_cache_op),
    .inst_known  (inst_known)
);

wire [31:0] ig_alu_imm, ig_br_imm;
imm_generator u_imm_generator(
    .inst        (inst_i),
    .inst_add_w  (inst_add_w),   .inst_addi_w (inst_addi_w), .inst_slti   (inst_slti),
    .inst_sltui  (inst_sltui),   .inst_andi   (inst_andi),   .inst_ori    (inst_ori),
    .inst_xori   (inst_xori),    .inst_sub_w  (inst_sub_w),  .inst_ld_w   (inst_ld_w),
    .inst_ld_h   (inst_ld_h),    .inst_ld_b   (inst_ld_b),   .inst_ld_hu  (inst_ld_hu),
    .inst_ld_bu  (inst_ld_bu),   .inst_st_w   (inst_st_w),   .inst_st_b   (inst_st_b),
    .inst_st_h   (inst_st_h),    .inst_bne    (inst_bne),    .inst_slt    (inst_slt),
    .inst_sltu   (inst_sltu),    .inst_and    (inst_and),    .inst_or     (inst_or),
    .inst_nor    (inst_nor),     .inst_xor    (inst_xor),    .inst_slli_w (inst_slli_w),
    .inst_srli_w (inst_srli_w),  .inst_srai_w (inst_srai_w), .inst_b      (inst_b),
    .inst_bl     (inst_bl),      .inst_beq    (inst_beq),    .inst_blt    (inst_blt),
    .inst_bge    (inst_bge),     .inst_bltu   (inst_bltu),   .inst_bgeu   (inst_bgeu),
    .inst_jirl   (inst_jirl),    .inst_lu12i_w(inst_lu12i_w),.inst_pcaddu12i(inst_pcaddu12i),
    .inst_ll_w   (inst_ll_w),    .inst_sc_w   (inst_sc_w),   .inst_pcaddi (inst_pcaddi),
    .inst_preld  (inst_preld),
    .alu_imm     (ig_alu_imm),
    .br_imm      (ig_br_imm)
);

wire [4:0] gra_raddr1, gra_raddr2;
get_reg_read_addr u_get_reg_read_addr(
    .reset       (1'b0),
    .inst        (inst_i),
    .inst_add_w  (inst_add_w),   .inst_addi_w (inst_addi_w), .inst_slti   (inst_slti),
    .inst_sltui  (inst_sltui),   .inst_andi   (inst_andi),   .inst_ori    (inst_ori),
    .inst_xori   (inst_xori),    .inst_sub_w  (inst_sub_w),  .inst_ld_w   (inst_ld_w),
    .inst_ld_h   (inst_ld_h),    .inst_ld_b   (inst_ld_b),   .inst_ld_hu  (inst_ld_hu),
    .inst_ld_bu  (inst_ld_bu),   .inst_st_w   (inst_st_w),   .inst_st_b   (inst_st_b),
    .inst_st_h   (inst_st_h),    .inst_bne    (inst_bne),    .inst_slt    (inst_slt),
    .inst_sltu   (inst_sltu),    .inst_and    (inst_and),    .inst_or     (inst_or),
    .inst_nor    (inst_nor),     .inst_xor    (inst_xor),    .inst_slli_w (inst_slli_w),
    .inst_srli_w (inst_srli_w),  .inst_srai_w (inst_srai_w), .inst_sll_w  (inst_sll_w),
    .inst_srl_w  (inst_srl_w),   .inst_sra_w  (inst_sra_w),  .inst_b      (inst_b),
    .inst_bl     (inst_bl),      .inst_beq    (inst_beq),    .inst_blt    (inst_blt),
    .inst_bge    (inst_bge),     .inst_bltu   (inst_bltu),   .inst_bgeu   (inst_bgeu),
    .inst_jirl   (inst_jirl),    .inst_lu12i_w(inst_lu12i_w),.inst_pcaddu12i(inst_pcaddu12i),
    .inst_mul_w  (inst_mul_w),   .inst_mulh_w (inst_mulh_w), .inst_mulh_wu(inst_mulh_wu),
    .inst_div_w  (inst_div_w),   .inst_div_wu (inst_div_wu), .inst_mod_w  (inst_mod_w),
    .inst_mod_wu (inst_mod_wu),  .inst_ertn   (inst_ertn),   .inst_syscall(inst_syscall),
    .inst_break  (inst_break),   .inst_rdcntvl_w(inst_rdcntvl_w), .inst_rdcntvh_w(inst_rdcntvh_w),
    .inst_rdcntid(inst_rdcntid), .inst_csrrd  (inst_csrrd),  .inst_csrwr  (inst_csrwr),
    .inst_csrxchg(inst_csrxchg), .inst_tlbsrch(inst_tlbsrch),.inst_tlbrd  (inst_tlbrd),
    .inst_tlbwr  (inst_tlbwr),   .inst_tlbfill(inst_tlbfill),.inst_invtlb_0(inst_invtlb_0),
    .inst_invtlb_1(inst_invtlb_1),.inst_invtlb_2(inst_invtlb_2),.inst_invtlb_3(inst_invtlb_3),
    .inst_invtlb_4(inst_invtlb_4),.inst_invtlb_5(inst_invtlb_5),.inst_invtlb_6(inst_invtlb_6),
    .inst_cacop  (inst_cacop),   .inst_ll_w   (inst_ll_w),   .inst_sc_w   (inst_sc_w),
    .inst_andn   (inst_andn),    .inst_orn    (inst_orn),    .inst_preld  (inst_preld),
    .inst_cpucfg (inst_cpucfg),
    .rf_raddr1   (gra_raddr1),
    .rf_raddr2   (gra_raddr2)
);

wire [4:0] rd = inst_i[4:0];
wire [4:0] rj = inst_i[9:5];

// ---------------- sc.w 译码期定性 ----------------
wire sc_as_store = inst_sc_w &&  csr_llbit_i;   // 真 store
wire sc_as_nopwr = inst_sc_w && ~csr_llbit_i;   // 退化为写 rd=0 的 ALU

// ---------------- 操作码输出（带 sc/idle 修正）----------------
// idle 别名（0x50000000 同时命中 inst_b）：按 idle 处理，压掉分支语义
wire idle_kill_br = inst_idle;

assign alu_op_o = (inst_pcaddu12i | inst_pcaddi) ? ({{(`ALU_OP_NUM-1){1'b0}}, 1'b1} << `ALU_OP_LUI)
                : sc_as_nopwr                    ? {`ALU_OP_NUM{1'b0}}
                : od_alu_op;
assign br_op_o  = idle_kill_br ? {`BR_OP_NUM{1'b0}} : od_br_op;
assign mem_op_o = sc_as_nopwr ? {`MEM_OP_NUM{1'b0}} : od_mem_op;
assign csr_op_o = od_csr_op;
assign tlb_op_o = od_tlb_op;
assign wb_src_op_o = od_wb_src_op;
assign csr_num_o   = inst_i[23:10];
assign cacop_code_o= inst_i[4:0];

// ---------------- FU 分类 ----------------
wire is_muldiv = inst_mul_w | inst_mulh_w | inst_mulh_wu
               | inst_div_w | inst_div_wu | inst_mod_w | inst_mod_wu;
wire is_csr    = inst_csrrd | inst_csrwr | inst_csrxchg;
wire is_rdcnt  = inst_rdcntvl_w | inst_rdcntvh_w | inst_rdcntid;
wire is_invtlb = inst_invtlb_0 | inst_invtlb_1 | inst_invtlb_2 | inst_invtlb_3
               | inst_invtlb_4 | inst_invtlb_5 | inst_invtlb_6;
wire is_memop  = inst_ld_w | inst_ld_h | inst_ld_b | inst_ld_hu | inst_ld_bu
               | inst_st_w | inst_st_b | inst_st_h | inst_ll_w | sc_as_store;

wire fu_mdu_sel = is_muldiv | is_csr | is_rdcnt | is_invtlb;
wire fu_mem_sel = is_memop | inst_cacop;
wire fu_alu_sel = ~fu_mdu_sel & ~fu_mem_sel;

assign futype_o = {fu_mdu_sel, fu_mem_sel, fu_alu_sel};   // {FU_MDU, FU_MEM, FU_ALU}

// ---------------- 寄存器读写 ----------------
// 写回：op_dec 的 wb_src 分类已覆盖 ALU/MEM/CSR/rdcnt；补 bl/jirl 链接
wire rf_we_raw = od_wb_src_op[`WB_SRC_ALU] | od_wb_src_op[`WB_SRC_MEM]
               | od_wb_src_op[`WB_SRC_CSR] | od_wb_src_op[`WB_SRC_CNTVL]
               | od_wb_src_op[`WB_SRC_CNTVH] | od_wb_src_op[`WB_SRC_TID]
               | inst_bl | inst_jirl;
assign rd_addr_o = inst_bl ? 5'd1 : inst_rdcntid ? rj : rd;
assign rf_we_o   = rf_we_raw && (rd_addr_o != 5'd0);

// 源使用判定（自维护列表，注意 rdcntid 不读 rj、csrwr 写值走 src1）
assign use_src0_o = inst_add_w | inst_sub_w | inst_slt | inst_sltu | inst_and | inst_or
                  | inst_nor | inst_xor | inst_sll_w | inst_srl_w | inst_sra_w
                  | inst_andn | inst_orn
                  | inst_addi_w | inst_slti | inst_sltui | inst_andi | inst_ori | inst_xori
                  | inst_slli_w | inst_srli_w | inst_srai_w
                  | inst_ld_w | inst_ld_h | inst_ld_b | inst_ld_hu | inst_ld_bu
                  | inst_st_w | inst_st_b | inst_st_h | inst_ll_w | sc_as_store
                  | inst_beq | inst_bne | inst_blt | inst_bge | inst_bltu | inst_bgeu
                  | inst_jirl
                  | is_muldiv
                  | inst_csrxchg
                  | inst_invtlb_4 | inst_invtlb_5 | inst_invtlb_6
                  | inst_cacop;
assign use_src1_o = inst_add_w | inst_sub_w | inst_slt | inst_sltu | inst_and | inst_or
                  | inst_nor | inst_xor | inst_sll_w | inst_srl_w | inst_sra_w
                  | inst_andn | inst_orn
                  | inst_st_w | inst_st_b | inst_st_h | sc_as_store
                  | inst_beq | inst_bne | inst_blt | inst_bge | inst_bltu | inst_bgeu
                  | is_muldiv
                  | inst_csrwr | inst_csrxchg
                  | inst_invtlb_5 | inst_invtlb_6;

// 读地址：csrwr 的写值（rd）按新约定走 src1（旧工具放 raddr1，覆盖之）
assign src0_addr_o = inst_csrwr ? 5'd0 : gra_raddr1;
assign src1_addr_o = inst_csrwr ? rd   : gra_raddr2;

// ---------------- 立即数 ----------------
// pcaddu12i/pcaddi：译码期完成 PC 加法（op 已改 LUI 直通 imm）；
// cacop：imm_generator 未覆盖 si12，此处补
wire [31:0] cacop_si12 = {{20{inst_i[21]}}, inst_i[21:10]};
assign imm_o = (inst_pcaddu12i | inst_pcaddi) ? (pc_i + ig_alu_imm)
             : inst_cacop                     ? cacop_si12
             : ig_alu_imm;
assign use_imm_o = inst_addi_w | inst_slti | inst_sltui | inst_andi | inst_ori | inst_xori
                 | inst_slli_w | inst_srli_w | inst_srai_w
                 | inst_ld_w | inst_ld_h | inst_ld_b | inst_ld_hu | inst_ld_bu
                 | inst_st_w | inst_st_b | inst_st_h | inst_ll_w | sc_as_store
                 | inst_lu12i_w | inst_pcaddu12i | inst_pcaddi
                 | inst_cacop | inst_jirl | inst_bl;
assign br_offs_o = ig_br_imm;

// ---------------- 分支属性 ----------------
assign is_branch_o = (|br_op_o);
assign br_type_o = (inst_bl || (inst_jirl && rd == 5'd1))                 ? `BR_TYPE_CALL
                 : (inst_jirl && (rd == 5'd0) && (rj == 5'd1))            ? `BR_TYPE_RET
                 : (inst_b || inst_jirl)                                  ? `BR_TYPE_UNCOND
                 : `BR_TYPE_COND;

// ---------------- 特权/特殊提交类 ----------------
wire is_tlbmaint = inst_tlbsrch | inst_tlbrd | inst_tlbwr | inst_tlbfill | is_invtlb;
assign priv_vec_o[`PRIV_CSR_WR] = inst_csrwr | inst_csrxchg;
assign priv_vec_o[`PRIV_ERTN]   = inst_ertn;
assign priv_vec_o[`PRIV_TLB]    = is_tlbmaint;
assign priv_vec_o[`PRIV_CACOP]  = inst_cacop;
assign priv_vec_o[`PRIV_IDLE]   = inst_idle;
assign priv_vec_o[`PRIV_LL]     = inst_ll_w;
assign priv_vec_o[`PRIV_SC]     = inst_sc_w;
assign priv_vec_o[`PRIV_IBAR]   = inst_ibar | inst_dbar;

// ---------------- NOP 消除（不占 FU 的指令）----------------
// ALU 类且不写寄存器且非分支：nop/dbar/ibar/ertn/idle/syscall/break/INE/preld/
// tlbsrch/tlbrd/tlbwr/tlbfill（这些在提交级落地，无需执行）
assign is_nop_o = fu_alu_sel && !is_branch_o && !rf_we_o;

// ---------------- 访存属性 ----------------
assign is_load_o  = inst_ld_w | inst_ld_h | inst_ld_b | inst_ld_hu | inst_ld_bu | inst_ll_w;
assign is_store_o = inst_st_w | inst_st_b | inst_st_h | sc_as_store;

// ---------------- 译码异常 ----------------
wire is_priv_inst = is_csr | inst_ertn | is_tlbmaint | inst_cacop | inst_idle;
assign excp_o = ({`EXCP_NUM{1'b0}})
              | ({{(`EXCP_NUM-1){1'b0}}, ~inst_known}                << `EXCP_INE)
              | ({{(`EXCP_NUM-1){1'b0}}, inst_syscall}               << `EXCP_SYS)
              | ({{(`EXCP_NUM-1){1'b0}}, inst_break}                 << `EXCP_BRK)
              | ({{(`EXCP_NUM-1){1'b0}}, is_priv_inst && (csr_plv_i == 2'b11)} << `EXCP_IPE);

// lint 吸收
wire dec_lint = (|od_cache_op) | (|pc_i);

endmodule
