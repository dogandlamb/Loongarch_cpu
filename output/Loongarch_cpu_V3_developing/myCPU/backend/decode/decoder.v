// ============================================================
// decoder 模块（单条指令译码器，纯组合，顶层例化 `MACHINE_WIDTH 份）
// ------------------------------------------------------------
// 功能：
// - 把一条 32bit 指令译成乱序后端所需的统一 uop 信息：
//   * FU 类型（决定进哪个保留站）：FU_ALU / FU_MEM / FU_MDU
//   * 各类操作码（alu_op/br_op/mem_op/csr_op/tlb_op/wb_src_op，沿用原独热体系）
//   * 源/目的寄存器（src0=rj 类，src1=rk/rd 类）、是否使用、是否写回
//   * 立即数与分支偏移
//   * 特权/特殊提交类标记 priv_vec（csr写/ertn/tlb维护/cacop/idle/ll/sc/ibar）
//   * 译码异常（INE/SYS/BRK/IPE）
// - 内部例化并复用旧五级流水的译码工具（inst_dec / op_dec /
//   imm_generator / get_reg_read_addr），这些模块的指令识别逻辑可整体复用。
//
// 端口：
// - inst_i / pc_i      ：指令与 PC
// - csr_plv_i          ：当前特权级（检测 IPE：用户态执行特权指令）
// - csr_llbit_i        ：LLBIT 当前值（sc.w 译码期决定行为，见 TODO）
// - 输出 uop 各字段（全组合）
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
    output wire                       is_nop_o,          // 真 NOP（andi r0,r0,0 等）/dbar/preld：不占 FU

    // ---------------- 访存属性 ----------------
    output wire                       is_load_o,
    output wire                       is_store_o,

    // ---------------- 译码异常 ----------------
    output wire [`EXCP_NUM-1:0]       excp_o             // INE/SYS/BRK/IPE 四位可能置位
);

//TODO: 本模块为纯组合译码器，实现步骤：
//
//TODO: 第一步——例化旧译码工具（指令识别逻辑全部白拿，省大量工作）：
//      inst_dec  u_inst_dec (.inst(inst_i), .inst_add_w(...), ...);   // 输出 80+ 个 inst_* 独热
//      op_dec    u_op_dec   (.inst_*(...), .alu_op(alu_op_o), .br_op(br_op_o),
//                            .mem_op(mem_op_o), .csr_op(csr_op_o), ...);
//      imm_generator u_imm  (.inst(inst_i), .inst_*(...), .alu_imm(imm_o), .br_imm(br_offs_o));
//      get_reg_read_addr u_gra(.inst(inst_i), .inst_*(...), ...);     // 生成 src0/src1 读地址
//      （这些模块端口很长，照旧五级流水里 IDport 的接法连即可；op_dec 还输出
//        tlb_op/wb_src_op/inst_known 等，inst_known 取反即 INE。）
//
//TODO: 第二步——FU 类型划分（独热 futype_o）：
//      FU_MDU：mul/mulh/mulh_u/div/div_u/mod/mod_u（alu_op[12..18]）、
//              csrrd/csrwr/csrxchg（CSR 读旧值在 MDU 做）、rdcntvl/vh/id、
//              tlbsrch/tlbrd/tlbwr/tlbfill/invtlb（执行级只算 invtlb 的 asid/vpn 打包，
//              真正落地在提交级）、cpucfg
//      FU_MEM：ld/st 全部、ll.w/sc.w、cacop（借 LSU 的 AGU 算地址+翻译）、preld(可当nop)
//      FU_ALU：其余全部（含分支：分支在 ALU 执行单元里判方向算目标）
//      注意每条指令必须恰好属于一类；is_nop 的指令 futype 给 FU_ALU 但不会入 RS。
//
//TODO: 第三步——use_src0/use_src1 与写回：
//      use_src0：使用 rj 的指令（算术/访存/分支比较/jirl/csrxchg(mask)/invtlb(asid) 等）
//      use_src1：使用 rk 或 rd 数据的指令（三寄存器算术、store 数据、beq/bne 比较、
//                csrwr/csrxchg 写值（来自 rd）、invtlb(vpn 来自 rk)、sc.w 数据）
//      rf_we_o：写 rd 的指令；rd==r0 时强制 rf_we=0（r0 恒零，且避免占用 RAT 表项）。
//      注意 bl 写 r1、jirl 写 rd、rdcnt 写 rd、csr 类写 rd、sc.w 写 rd（成败标志）。
//
//TODO: 第四步——分支属性：
//      is_branch_o = beq/bne/blt/bge/bltu/bgeu/b/bl/jirl
//      br_type_o：bl 或 (jirl && rd==r1) -> CALL；(jirl && rd==r0 && rj==r1) -> RET；
//                 b -> UNCOND；其余条件分支 -> COND；普通 jirl -> UNCOND（间接跳转）
//
//TODO: 第五步——priv_vec_o（这些指令在 commit 单提交 + 提交后 FLUSH_REFETCH）：
//      PRIV_CSR_WR：csrwr/csrxchg     PRIV_ERTN：ertn      PRIV_TLB：tlb_op 任一位
//      PRIV_CACOP：cacop              PRIV_IDLE：idle      PRIV_LL：ll.w
//      PRIV_SC：sc.w                  PRIV_IBAR：ibar/dbar
//
//TODO: 第六步——sc.w 的"译码期定性"技巧（mariver 方案，必读！）：
//      因为 ll.w/ertn/csrwr(LLBCTL) 提交时都会 FLUSH_REFETCH 重取后续指令，
//      所以任何 sc.w 被译码时，csr_llbit_i 一定是"最终值"（不会再被在飞指令改变）。
//      于是：csr_llbit_i==1 -> sc.w 按真 store 处理（mem_op[SC_W]=1，写回值恒 1）；
//            csr_llbit_i==0 -> sc.w 退化为"写 rd=0 的 ALU 指令"（futype=FU_ALU，
//                              alu_op 造一个结果恒 0 的操作，不进访存）。
//      两种情况 priv_vec[PRIV_SC] 都要置位（提交时清 LLBIT + refetch）。
//
//TODO: 第七步——is_nop 与异常：
//      is_nop_o：andi r0,r0,0（标准 nop）、dbar/ibar（占位+priv 标记）、preld；
//                nop 在 rename 直接标 ROB 完成，不进保留站（mariver NOP 消除，IPC+2%）。
//      excp_o[`EXCP_INE] = ~inst_known（op_dec 有"识别出任意指令"信号，取反）；
//      excp_o[`EXCP_SYS] = inst_syscall；excp_o[`EXCP_BRK] = inst_break；
//      excp_o[`EXCP_IPE] = 特权指令（csr/tlb/cacop/ertn/idle）&& csr_plv_i==2'b11。
//
//TODO: 坑点提示：
//      1. csrxchg 的两个源：mask=rj、写值=rd —— src0=rj、src1=rd，注意 get_reg_read_addr
//         已处理这个特例（csrwr 源在 rd），照搬其结果。
//      2. rdcntid 写 rj 而不是 rd（LA 手册特例），rd_addr 要选对。
//      3. cacop 的"目的寄存器"不存在（code 在 rd 位置），rf_we 必须为 0。

endmodule
