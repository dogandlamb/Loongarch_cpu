`include "../top/cpu_defs.vh"

// ============================================================
// IDport：译码级。对 IF/ID 输入指令进行译码，组合产生：
// - 寄存器读地址、ALU/BR/MEM/CSR/TLB 控制与写回控制；
// - 异常元信息（ADEF/INT/TLB/INE/SYS/BRK）与 refetch 标志；
// - cache 维护指令元信息（CACOP/IBAR）。
//
// 级内例化：inst_dec / op_dec / imm_generator / ALU_srcGenerator / get_reg_read_addr。
// stall = RAW 插泡：清本条送 EXE 的执行控制，保留寄存器读地址。
// ============================================================
module IDport (
    // input
    // 基本控制
    input  wire                   reset,
    input  wire                   valid,              // ID 槽有效
    input  wire                   stall,              // RAW 插泡：清执行控制，保留 src* 地址
    input  wire                   tlb_inst_stall,     // TLBSRCH/TLBRD 在 EXE/MEM/WB 时阻塞 ID→EXE

    // 上游数据与前递读数
    input  wire [31:0]            inst,               // IF/ID 传来的 32 位指令
    input  wire [31:0]            src1_rdata,         // 源操作数1（已含前递结果）
    input  wire [31:0]            src2_rdata,         // 源操作数2（已含前递结果）
    input  wire [31:0]            pc_in,              // 本条指令 PC

    // 上游异常/重取指元信息
    input  wire                   adef_valid_in,      // IF 阶段 ADEF
    input  wire                   has_int,            // 中断挂起
    input  wire                   exception_valid_in, // IF 阶段异常有效
    input  wire [`TLB_EX_NUM-1:0] tlb_ex_valid_in,    // IF 阶段 TLB 异常向量
    input  wire [31:0]            tlb_vaddr_in,       // IF 阶段 TLB 异常虚地址
    input  wire                   refetch_tag_in,     // 上游重取指标志


    // output
    // 与流水握手
    output reg                    allowIn,            // 对 IF/ID 寄存器级允许（当前常 1）
    output reg                    readyGo,            // ID 可前推；tlb_inst_stall 时拉低

    // 译码主控制与数据
    output reg  [4:0]             src1_addr,          // regfile 读口1地址
    output reg  [4:0]             src2_addr,          // regfile 读口2地址
    output reg  [4:0]             wb_reg_addr,        // 写回寄存器号
    output reg  [31:0]            alu_src1,
    output reg  [31:0]            alu_src2,
    output reg  [31:0]            br_imm,
    output reg  [`ALU_OP_NUM-1:0] alu_op,
    output reg  [`BR_OP_NUM-1:0]  br_op,
    output reg  [`MEM_OP_NUM-1:0] mem_op,
    output reg  [31:0]            mem_wdata,          // store 写数据
    output reg                    wb_op,              // 是否写回寄存器
    output reg  [`WB_SRC_NUM-1:0] wb_src_op,          // 写回数据来源
    output reg  [31:0]            pc_out,             // 透传 pc_in

    // CSR/TLB 控制
    output reg  [`CSR_OP_NUM-1:0] csr_op,             // CSR 操作编码
    output reg  [11:0]            csr_num,            // CSR 编号
    output reg  [31:0]            csr_wmask,          // CSR 写掩码
    output reg  [31:0]            csr_wvalue,         // CSR 写值
    output reg  [`TLB_OP_NUM-1:0] tlb_op,             // TLB 操作编码
    output reg  [9:0]             invtlb_asid,
    output reg  [18:0]            invtlb_vpn,

    // cache 维护指令信息
    output reg  [`CACHE_OP_NUM-1:0] cache_op_valid,   // cache 维护类型：bit0=CACOP，bit1=IBAR
    output reg  [1:0]             cacop_op,
    output reg  [31:0]            cacop_addr,
    output reg  [1:0]             cacop_mat,
    output reg  [4:0]             cacop_cd,

    // 异常/重取指标志
    output reg                    ertn_op,
    output reg                    sys_valid,
    output reg                    brk_valid,
    output reg                    ine_valid,
    output reg  [`TLB_EX_NUM-1:0] tlb_ex_valid,
    output reg  [31:0]            tlb_vaddr,
    output reg                    adef_valid,         // 送 ID_EXE_reg 的 ADEF
    output reg  [31:0]            if_vaddr,           // IF 异常虚地址（当前主要用于 ADEF）
    output reg                    int_valid,          // 送 ID_EXE_reg 的中断有效
    output reg                    exception_valid,    // 送 ID_EXE_reg 的异常总有效
    output reg                    refetch_tag_out     // 送下游的重取指标志
);

    // inst_dec 输出的one-hot指令
    wire inst_add_w, inst_addi_w, inst_slti, inst_sltui, inst_andi, inst_ori, inst_xori;
    wire inst_sub_w;
    wire inst_ld_w, inst_ld_h, inst_ld_b, inst_ld_hu, inst_ld_bu;
    wire inst_st_w, inst_st_b, inst_st_h;
    wire inst_bne, inst_slt, inst_sltu, inst_and, inst_or, inst_nor, inst_xor;
    wire inst_slli_w, inst_srli_w, inst_srai_w, inst_sll_w, inst_srl_w, inst_sra_w;
    wire inst_b, inst_bl, inst_beq, inst_blt, inst_bge, inst_bltu, inst_bgeu, inst_jirl;
    wire inst_lu12i_w, inst_pcaddu12i;
    wire inst_mul_w, inst_mulh_w, inst_mulh_wu, inst_div_w, inst_div_wu, inst_mod_w, inst_mod_wu;
    wire inst_ertn, inst_syscall, inst_break;
    wire inst_rdcntvl_w, inst_rdcntvh_w, inst_rdcntid;
    wire inst_csrrd, inst_csrwr, inst_csrxchg;
    wire inst_tlbsrch, inst_tlbrd, inst_tlbwr, inst_tlbfill;
    wire inst_invtlb_0, inst_invtlb_1, inst_invtlb_2, inst_invtlb_3, inst_invtlb_4, inst_invtlb_5, inst_invtlb_6;
    wire inst_cacop, inst_ibar;

    wire [`ALU_OP_NUM-1:0]   alu_op_inner;     //内部ALU操作码，后续看条件赋值给output alu_op
    wire [`BR_OP_NUM-1:0]    br_op_inner;      //内部分支跳转操作码，后续看条件赋值给output br_op
    wire [`MEM_OP_NUM-1:0]   mem_op_inner;     //内部访存操作码，后续看条件赋值给output mem_op
    wire [`CSR_OP_NUM-1:0]   csr_op_inner;     //内部CSR操作码，后续看条件赋值给output csr_op
    //wire [`RDCNT_OP_NUM-1:0] rdcnt_op_inner; //内部读时间戳计数器操作码，后续看条件赋值给output rdcnt_op
    wire [`WB_SRC_NUM-1:0]   wb_src_op_inner;  //内部写回数据来源操作码，后续看条件赋值给output wb_src_op_inner
    wire [`TLB_OP_NUM-1:0]   tlb_op_inner;     //内部TLB操作码，后续看条件赋值给output tlb_op
    wire [`CACHE_OP_NUM-1:0] cache_op_inner;   //cache_op,后续看条件赋值给cache_op_inner
    wire [31:0]              alu_imm_w;
    wire [31:0]              br_imm_w;
    wire [31:0]              alu_src1_w;
    wire [31:0]              alu_src2_w;
    wire [ 4:0]              rf_raddr1_w;
    wire [ 4:0]              rf_raddr2_w;
    wire [11:0]              csr_num_w;
    wire [31:0]              csr_wmask_w;
    wire [31:0]              csr_wvalue_w;
    
    wire wb_op_w;
    assign wb_op_w = inst_add_w | inst_addi_w | inst_sub_w | inst_ld_w
                   | inst_slt   | inst_sltu   | inst_and   | inst_or
                   | inst_nor   | inst_xor    | inst_slli_w| inst_srli_w
                   | inst_srai_w| inst_sll_w  | inst_srl_w | inst_sra_w
                   | inst_lu12i_w| inst_pcaddu12i | inst_bl | inst_jirl
                   | inst_slti  | inst_sltui  | inst_andi  | inst_xori
                   | inst_ori    | inst_mul_w  | inst_mulh_w
                   | inst_mulh_wu| inst_div_w  | inst_div_wu
                   | inst_mod_w | inst_mod_wu
                   | inst_ld_h   | inst_ld_b   | inst_ld_hu  | inst_ld_bu; 
    wire   inst_csr_all;
    wire   inst_rdcnt_all;
    //wire   inst_priv_all;// 所有特权指令的总信号，包括ertn/syscall/break/读写CSR/读时间戳计数器等
    assign inst_csr_all = inst_csrrd | inst_csrwr | inst_csrxchg;
    assign inst_rdcnt_all = inst_rdcntvl_w | inst_rdcntvh_w | inst_rdcntid;
    //assign inst_priv_all = inst_ertn | inst_syscall | inst_break | inst_rdcnt_all | inst_csr_all;
    wire   inst_known;//指令识别信号，输入的指令在指令集内为 1，否则为 0。用于异常处理模块识别非法指令  写错了，这里少了一个n
    wire   has_int_attach;// 对本条指令是否附着中断异常（ERTN 不附着，先返回再处理中断）
    wire   exception_valid_w;//译码阶段的异常有效信号，指令异常或中断时为 1，用于送到 ID_EXE_reg 再传到 EXE 级的异常处理模块
    // 4-state safe: avoid X on exception_valid_w (which would skip all decode branches and zero pc_out).
    assign has_int_attach = (has_int === 1'b1) && (inst_ertn !== 1'b1);
    wire   inst_tlb_all;
    assign inst_tlb_all = inst_tlbsrch | inst_tlbrd | inst_tlbwr | inst_tlbfill 
                        | inst_invtlb_0 | inst_invtlb_1 | inst_invtlb_2 | inst_invtlb_3 | inst_invtlb_4 | inst_invtlb_5 | inst_invtlb_6;
    wire   fetch_exception;//IF 阶段已经发现的异常
    wire   decode_exception;//ID 阶段自己译码发现的异常
    assign fetch_exception  = (exception_valid_in === 1'b1);
    wire dec_sys   = (inst_syscall === 1'b1);
    wire dec_brk   = (inst_break   === 1'b1);
    wire dec_ine   = (inst_known   === 1'b0);
    wire dec_int   = (has_int_attach === 1'b1);
    assign decode_exception = (refetch_tag_in !== 1'b1) && (dec_sys | dec_brk | dec_ine | dec_int);
    wire   inst_cache_all;
    assign inst_cache_all = inst_cacop | inst_ibar;
    assign exception_valid_w = fetch_exception | decode_exception;

    inst_dec u_inst_dec(
        .inst         (inst),
        .inst_add_w   (inst_add_w),
        .inst_addi_w  (inst_addi_w),
        .inst_slti    (inst_slti),
        .inst_sltui   (inst_sltui),
        .inst_andi    (inst_andi),
        .inst_ori     (inst_ori),
        .inst_xori    (inst_xori),
        .inst_sub_w   (inst_sub_w),
        .inst_ld_w    (inst_ld_w),
        .inst_ld_h    (inst_ld_h),
        .inst_ld_b    (inst_ld_b),
        .inst_ld_hu   (inst_ld_hu),
        .inst_ld_bu   (inst_ld_bu),
        .inst_st_w    (inst_st_w),
        .inst_bne     (inst_bne),
        .inst_slt     (inst_slt),
        .inst_sltu    (inst_sltu),
        .inst_and     (inst_and),
        .inst_or      (inst_or),
        .inst_nor     (inst_nor),
        .inst_xor     (inst_xor),
        .inst_slli_w  (inst_slli_w),
        .inst_srli_w  (inst_srli_w),
        .inst_srai_w  (inst_srai_w),
        .inst_sll_w   (inst_sll_w),
        .inst_srl_w   (inst_srl_w),
        .inst_sra_w   (inst_sra_w),
        .inst_b       (inst_b),
        .inst_bl      (inst_bl),
        .inst_beq     (inst_beq),
        .inst_jirl    (inst_jirl),
        .inst_lu12i_w (inst_lu12i_w),
        .inst_pcaddu12i(inst_pcaddu12i),
        .inst_mul_w   (inst_mul_w),
        .inst_mulh_w  (inst_mulh_w),
        .inst_mulh_wu (inst_mulh_wu),
        .inst_div_w   (inst_div_w),
        .inst_div_wu  (inst_div_wu),
        .inst_mod_w   (inst_mod_w),
        .inst_mod_wu  (inst_mod_wu),
        .inst_blt     (inst_blt),
        .inst_bge     (inst_bge),
        .inst_bltu    (inst_bltu),
        .inst_bgeu    (inst_bgeu),
        .inst_st_b    (inst_st_b),
        .inst_st_h    (inst_st_h),
        .inst_ertn     (inst_ertn),
        .inst_syscall  (inst_syscall),
        .inst_break    (inst_break),
        .inst_rdcntvl_w (inst_rdcntvl_w),
        .inst_rdcntvh_w (inst_rdcntvh_w),
        .inst_rdcntid   (inst_rdcntid),
        .inst_csrrd    (inst_csrrd),
        .inst_csrwr    (inst_csrwr),
        .inst_csrxchg  (inst_csrxchg),
        .inst_tlbsrch  (inst_tlbsrch),
        .inst_tlbrd    (inst_tlbrd),
        .inst_tlbwr    (inst_tlbwr),
        .inst_tlbfill  (inst_tlbfill),
        .inst_invtlb_0 (inst_invtlb_0),
        .inst_invtlb_1 (inst_invtlb_1),
        .inst_invtlb_2 (inst_invtlb_2),
        .inst_invtlb_3 (inst_invtlb_3),
        .inst_invtlb_4 (inst_invtlb_4),
        .inst_invtlb_5 (inst_invtlb_5),
        .inst_invtlb_6 (inst_invtlb_6),
        .inst_cacop    (inst_cacop),
        .inst_ibar     (inst_ibar)
    );

    op_dec u_op_dec(
        .inst_add_w     	(inst_add_w      ),
        .inst_addi_w    	(inst_addi_w     ),
        .inst_slti      	(inst_slti       ),
        .inst_sltui     	(inst_sltui      ),
        .inst_andi      	(inst_andi       ),
        .inst_ori       	(inst_ori        ),
        .inst_xori      	(inst_xori       ),
        .inst_sub_w     	(inst_sub_w      ),
        .inst_ld_w      	(inst_ld_w       ),
        .inst_ld_h      	(inst_ld_h       ),
        .inst_ld_b      	(inst_ld_b       ),
        .inst_ld_hu     	(inst_ld_hu      ),
        .inst_ld_bu     	(inst_ld_bu      ),
        .inst_st_w      	(inst_st_w       ),
        .inst_st_b      	(inst_st_b       ),
        .inst_st_h      	(inst_st_h       ),
        .inst_bne       	(inst_bne        ),
        .inst_slt       	(inst_slt        ),
        .inst_sltu      	(inst_sltu       ),
        .inst_and       	(inst_and        ),
        .inst_or        	(inst_or         ),
        .inst_nor       	(inst_nor        ),
        .inst_xor       	(inst_xor        ),
        .inst_slli_w    	(inst_slli_w     ),
        .inst_srli_w    	(inst_srli_w     ),
        .inst_srai_w    	(inst_srai_w     ),
        .inst_sll_w     	(inst_sll_w      ),
        .inst_srl_w     	(inst_srl_w      ),
        .inst_sra_w     	(inst_sra_w      ),
        .inst_b         	(inst_b          ),
        .inst_bl        	(inst_bl         ),
        .inst_beq       	(inst_beq        ),
        .inst_blt       	(inst_blt        ),
        .inst_bge       	(inst_bge        ),
        .inst_bltu      	(inst_bltu       ),
        .inst_bgeu      	(inst_bgeu       ),
        .inst_jirl      	(inst_jirl       ),
        .inst_lu12i_w   	(inst_lu12i_w    ),
        .inst_pcaddu12i 	(inst_pcaddu12i  ),
        .inst_mul_w     	(inst_mul_w      ),
        .inst_mulh_w    	(inst_mulh_w     ),
        .inst_mulh_wu   	(inst_mulh_wu    ),
        .inst_div_w     	(inst_div_w      ),
        .inst_div_wu    	(inst_div_wu     ),
        .inst_mod_w     	(inst_mod_w      ),
        .inst_mod_wu    	(inst_mod_wu     ),
        .inst_csrrd     	(inst_csrrd      ),
        .inst_csrwr     	(inst_csrwr      ),
        .inst_csrxchg   	(inst_csrxchg    ),
        .inst_rdcntvl_w 	(inst_rdcntvl_w  ),
        .inst_rdcntvh_w 	(inst_rdcntvh_w  ),
        .inst_rdcntid   	(inst_rdcntid    ),
        .inst_ertn      	(inst_ertn       ),
        .inst_syscall   	(inst_syscall    ),
        .inst_break     	(inst_break      ),
        .inst_tlbsrch       (inst_tlbsrch),
        .inst_tlbrd         (inst_tlbrd),
        .inst_tlbwr         (inst_tlbwr),
        .inst_tlbfill       (inst_tlbfill),
        .inst_invtlb_0      (inst_invtlb_0),
        .inst_invtlb_1      (inst_invtlb_1),
        .inst_invtlb_2      (inst_invtlb_2),
        .inst_invtlb_3      (inst_invtlb_3),
        .inst_invtlb_4      (inst_invtlb_4),
        .inst_invtlb_5      (inst_invtlb_5),
        .inst_invtlb_6      (inst_invtlb_6),
        .alu_op           	(alu_op_inner    ),
        .br_op          	(br_op_inner     ),
        .mem_op         	(mem_op_inner    ),
        .csr_op     	    (csr_op_inner    ),
        .wb_src_op    	    (wb_src_op_inner ),
        .tlb_op             (tlb_op_inner    ),
        .inst_cacop         (inst_cacop      ),
        .inst_ibar          (inst_ibar       ),
        .cache_op           (cache_op_inner  ),
        .inst_known         (inst_known      )
    );

    imm_generator u_imm_generator(
        .inst         (inst),
        .inst_add_w   (inst_add_w),
        .inst_addi_w  (inst_addi_w),
        .inst_slti    (inst_slti),
        .inst_sltui   (inst_sltui),
        .inst_andi    (inst_andi),
        .inst_ori     (inst_ori),
        .inst_xori    (inst_xori),
        .inst_sub_w   (inst_sub_w),
        .inst_ld_w    (inst_ld_w),
        .inst_ld_h    (inst_ld_h),
        .inst_ld_b    (inst_ld_b),
        .inst_ld_hu   (inst_ld_hu),
        .inst_ld_bu   (inst_ld_bu),
        .inst_st_w    (inst_st_w),
        .inst_st_b    (inst_st_b),
        .inst_st_h    (inst_st_h),
        .inst_bne     (inst_bne),
        .inst_slt     (inst_slt),
        .inst_sltu    (inst_sltu),
        .inst_and     (inst_and),
        .inst_or      (inst_or),
        .inst_nor     (inst_nor),
        .inst_xor     (inst_xor),
        .inst_slli_w  (inst_slli_w),
        .inst_srli_w  (inst_srli_w),
        .inst_srai_w  (inst_srai_w),
        .inst_b       (inst_b),
        .inst_bl      (inst_bl),
        .inst_beq     (inst_beq),
        .inst_blt     (inst_blt),
        .inst_bge     (inst_bge),
        .inst_bltu    (inst_bltu),
        .inst_bgeu    (inst_bgeu),
        .inst_jirl    (inst_jirl),
        .inst_lu12i_w (inst_lu12i_w),
        .inst_pcaddu12i(inst_pcaddu12i),
        .alu_imm      (alu_imm_w),
        .br_imm       (br_imm_w)
    );

    ALU_srcGenerator u_ALU_srcGenerator(
        .reset        (reset),
        .inst_add_w   (inst_add_w),
        .inst_addi_w  (inst_addi_w),
        .inst_slti    (inst_slti),
        .inst_sltui   (inst_sltui),
        .inst_andi    (inst_andi),
        .inst_ori     (inst_ori),
        .inst_xori    (inst_xori),
        .inst_sub_w   (inst_sub_w),
        .inst_ld_w    (inst_ld_w),
        .inst_ld_h    (inst_ld_h),
        .inst_ld_b    (inst_ld_b),
        .inst_ld_hu   (inst_ld_hu),
        .inst_ld_bu   (inst_ld_bu),
        .inst_st_w    (inst_st_w),
        .inst_st_b    (inst_st_b),
        .inst_st_h    (inst_st_h),
        .inst_bne     (inst_bne),
        .inst_slt     (inst_slt),
        .inst_sltu    (inst_sltu),
        .inst_and     (inst_and),
        .inst_or      (inst_or),
        .inst_nor     (inst_nor),
        .inst_xor     (inst_xor),
        .inst_slli_w  (inst_slli_w),
        .inst_srli_w  (inst_srli_w),
        .inst_srai_w  (inst_srai_w),
        .inst_sll_w   (inst_sll_w),
        .inst_srl_w   (inst_srl_w),
        .inst_sra_w   (inst_sra_w),
        .inst_b       (inst_b),
        .inst_bl      (inst_bl),
        .inst_beq     (inst_beq),
        .inst_blt     (inst_blt),
        .inst_bge     (inst_bge),
        .inst_bltu    (inst_bltu),
        .inst_bgeu    (inst_bgeu),
        .inst_jirl    (inst_jirl),
        .inst_lu12i_w (inst_lu12i_w),
        .inst_pcaddu12i(inst_pcaddu12i),
        .inst_csrrd    (inst_csrrd),
        .inst_csrwr    (inst_csrwr),
        .inst_csrxchg  (inst_csrxchg),
        .inst_rdcntvl_w (inst_rdcntvl_w),
        .inst_rdcntvh_w (inst_rdcntvh_w),
        .inst_rdcntid   (inst_rdcntid),
        .inst_ertn      (inst_ertn),
        .inst_syscall   (inst_syscall),
        .inst_break     (inst_break),  
        .rj_value     (src1_rdata),
        .rkd_value    (src2_rdata),
        .imm          (alu_imm_w),
        .pc           (pc_in),
        .alu_src1     (alu_src1_w),
        .alu_src2     (alu_src2_w)
    );

    // 读寄存器地址由 get_reg_read_addr 生成
    get_reg_read_addr u_get_reg_read_addr(
        .reset          	(reset           ),
        .inst           	(inst            ),
        .inst_add_w     	(inst_add_w      ),
        .inst_addi_w    	(inst_addi_w     ),
        .inst_slti      	(inst_slti       ),
        .inst_sltui     	(inst_sltui      ),
        .inst_andi      	(inst_andi       ),
        .inst_ori       	(inst_ori        ),
        .inst_xori      	(inst_xori       ),
        .inst_sub_w     	(inst_sub_w      ),
        .inst_ld_w      	(inst_ld_w       ),
        .inst_ld_h      	(inst_ld_h       ),
        .inst_ld_b      	(inst_ld_b       ),
        .inst_ld_hu     	(inst_ld_hu      ),
        .inst_ld_bu     	(inst_ld_bu      ),
        .inst_st_w      	(inst_st_w       ),
        .inst_st_b      	(inst_st_b       ),
        .inst_st_h      	(inst_st_h       ),
        .inst_bne       	(inst_bne        ),
        .inst_slt       	(inst_slt        ),
        .inst_sltu      	(inst_sltu       ),
        .inst_and       	(inst_and        ),
        .inst_or        	(inst_or         ),
        .inst_nor       	(inst_nor        ),
        .inst_xor       	(inst_xor        ),
        .inst_slli_w    	(inst_slli_w     ),
        .inst_srli_w    	(inst_srli_w     ),
        .inst_srai_w    	(inst_srai_w     ),
        .inst_sll_w     	(inst_sll_w      ),
        .inst_srl_w     	(inst_srl_w      ),
        .inst_sra_w     	(inst_sra_w      ),
        .inst_b         	(inst_b          ),
        .inst_bl        	(inst_bl         ),
        .inst_beq       	(inst_beq        ),
        .inst_blt       	(inst_blt        ),
        .inst_bge       	(inst_bge        ),
        .inst_bltu      	(inst_bltu       ),
        .inst_bgeu      	(inst_bgeu       ),
        .inst_jirl      	(inst_jirl       ),
        .inst_lu12i_w   	(inst_lu12i_w    ),
        .inst_pcaddu12i 	(inst_pcaddu12i  ),
        .inst_mul_w     	(inst_mul_w      ),
        .inst_mulh_w    	(inst_mulh_w     ),
        .inst_mulh_wu   	(inst_mulh_wu    ),
        .inst_div_w     	(inst_div_w      ),
        .inst_div_wu    	(inst_div_wu     ),
        .inst_mod_w     	(inst_mod_w      ),
        .inst_mod_wu    	(inst_mod_wu     ),
        .inst_ertn      	(inst_ertn       ),
        .inst_syscall   	(inst_syscall    ),
        .inst_break     	(inst_break      ),
        .inst_rdcntvl_w 	(inst_rdcntvl_w  ),
        .inst_rdcntvh_w 	(inst_rdcntvh_w  ),
        .inst_rdcntid   	(inst_rdcntid    ),
        .inst_csrrd     	(inst_csrrd      ),
        .inst_csrwr     	(inst_csrwr      ),
        .inst_csrxchg   	(inst_csrxchg    ),
        .inst_tlbsrch       (inst_tlbsrch),
        .inst_tlbrd         (inst_tlbrd),
        .inst_tlbwr         (inst_tlbwr),
        .inst_tlbfill       (inst_tlbfill),
        .inst_invtlb_0      (inst_invtlb_0),
        .inst_invtlb_1      (inst_invtlb_1),
        .inst_invtlb_2      (inst_invtlb_2),
        .inst_invtlb_3      (inst_invtlb_3),
        .inst_invtlb_4      (inst_invtlb_4),
        .inst_invtlb_5      (inst_invtlb_5),
        .inst_invtlb_6      (inst_invtlb_6),
        .inst_cacop         (inst_cacop),
        .rf_raddr1      	(rf_raddr1_w     ),
        .rf_raddr2      	(rf_raddr2_w     )
    );

    always @(*) begin
        allowIn     = 1'b1; 
        readyGo     = ~tlb_inst_stall;
        src1_addr   = 5'b0;
        src2_addr   = 5'b0;
        wb_reg_addr = 5'b0;
        alu_src1    = 32'b0;
        alu_src2    = 32'b0;
        br_imm      = 32'b0;
        alu_op      = {`ALU_OP_NUM{1'b0}};
        br_op       = {`BR_OP_NUM{1'b0}};
        mem_op      = {`MEM_OP_NUM{1'b0}};
        csr_op      = {`CSR_OP_NUM{1'b0}};
        csr_num     = 12'b0;
        csr_wmask   = 32'b0;
        csr_wvalue  = 32'b0;
        wb_src_op   = {`WB_SRC_NUM{1'b0}};
        tlb_op      = {`TLB_OP_NUM{1'b0}};
        tlb_ex_valid = {`TLB_EX_NUM{1'b0}};
        tlb_vaddr    = 32'b0;
        invtlb_asid  = 10'b0;
        invtlb_vpn   = 19'b0;
        ertn_op     = 1'b0;
        sys_valid      = 1'b0;
        brk_valid      = 1'b0;
        ine_valid      = 1'b0;
        adef_valid     = 1'b0;
        int_valid      = 1'b0;
        exception_valid = 1'b0;
        mem_wdata   = 32'b0;
        wb_op       = 1'b0;
        pc_out      = 32'b0;
        if_vaddr    = 32'b0;
        cache_op_valid = {`CACHE_OP_NUM{1'b0}};
        refetch_tag_out = 1'b0;
        cacop_op   = 2'b0;
        cacop_addr = 32'b0;
        cacop_mat  = 2'b0;
        cacop_cd   = 5'b0;
        // 4-state safe gating: treat signals as asserted only when strictly 1.
        // Avoid `!x` turning into X and disabling the whole decode path.
        if ((reset !== 1'b1) && (valid === 1'b1) && (exception_valid_w !== 1'b1)
            && (inst_csr_all !== 1'b1) && (inst_rdcnt_all !== 1'b1) && (inst_ertn !== 1'b1)
            && (inst_tlb_all !== 1'b1) && (inst_cache_all !== 1'b1) && (refetch_tag_in !== 1'b1)) begin
            src1_addr   = rf_raddr1_w;
            src2_addr   = rf_raddr2_w;
            // 注意：stall 只对送 EXE 的控制/数据插泡，不影响读寄存器地址。
            wb_reg_addr = (stall === 1'b1) ? 5'd0  : (inst_bl ? 5'd1 : inst[4:0]);
            alu_src1    = (stall === 1'b1) ? 32'd0 : alu_src1_w;
            alu_src2    = (stall === 1'b1) ? 32'd0 : alu_src2_w;
            br_imm      = (stall === 1'b1) ? 32'd0 : br_imm_w;
            alu_op      = (stall === 1'b1) ? {`ALU_OP_NUM{1'b0}} : alu_op_inner;
            br_op       = (stall === 1'b1) ? {`BR_OP_NUM{1'b0}}  : br_op_inner;
            mem_op      = (stall === 1'b1) ? {`MEM_OP_NUM{1'b0}} : mem_op_inner; // 注意 mem_op 的编码规范
            wb_src_op   = (stall === 1'b1) ? {`WB_SRC_NUM{1'b0}} : wb_src_op_inner;// 注意 wb_src_op 的编码规范
            mem_wdata   = (stall === 1'b1) ? 32'd0 : src2_rdata;
            wb_op       = (stall === 1'b1) ? 1'b0  : wb_op_w;
            pc_out      = (stall === 1'b1) ? 32'd0 : pc_in;

            // ori 专用路径：使用零扩展 ui12
            if (inst_ori) begin
                src1_addr   = rf_raddr1_w;
                src2_addr   = rf_raddr2_w;
                wb_reg_addr = (stall === 1'b1) ? 5'd0  : inst[4:0];
                alu_src1    = (stall === 1'b1) ? 32'd0 : src1_rdata;
                alu_src2    = (stall === 1'b1) ? 32'd0 : {20'b0, inst[21:10]};
                br_imm      = 32'b0;
                alu_op      = (stall === 1'b1) ? {`ALU_OP_NUM{1'b0}} : ({`ALU_OP_NUM{1'b0}} | ({{(`ALU_OP_NUM-1){1'b0}},1'b1} << `ALU_OP_OR)); // op_or
                br_op       = {`BR_OP_NUM{1'b0}};
                mem_op      = {`MEM_OP_NUM{1'b0}};
                mem_wdata   = 32'b0;
                wb_op       = (stall === 1'b1) ? 1'b0 : 1'b1;
                wb_src_op   = (stall === 1'b1) ?  {`WB_SRC_NUM{1'b0}} : wb_src_op_inner;
                pc_out      = (stall === 1'b1) ? 32'd0 : pc_in;
            end
        end
        else if (exception_valid_w) begin
            src1_addr   = rf_raddr1_w;
            src2_addr   = rf_raddr2_w;
            wb_reg_addr = 5'b0;
            alu_src1    = 32'b0;
            alu_src2    = 32'b0;
            br_imm      = 32'b0;
            alu_op      = {`ALU_OP_NUM{1'b0}};
            br_op       = {`BR_OP_NUM{1'b0}};
            mem_op      = {`MEM_OP_NUM{1'b0}};
            csr_op      = {`CSR_OP_NUM{1'b0}};
            tlb_op      = {`TLB_OP_NUM{1'b0}};
            csr_num     = 12'b0;
            csr_wmask   = 32'b0;
            csr_wvalue  = 32'b0;
            mem_wdata   = 32'b0;
            wb_op       = 1'b0;
            wb_src_op   = {`WB_SRC_NUM{1'b0}};
            cache_op_valid = {`CACHE_OP_NUM{1'b0}};
            pc_out      = pc_in;
            ertn_op     = 1'b0;
            // 异常槽在 stall 拍也必须保持异常元信息，避免 IF-TLB 异常被冲掉导致 ERA/BADV 错写。
            adef_valid  = adef_valid_in;
            if_vaddr    = adef_valid_in ? pc_in : 32'b0;
            sys_valid   = inst_syscall;
            brk_valid   = inst_break;
            ine_valid   = !fetch_exception && !inst_known;
            int_valid   = has_int_attach;
            tlb_ex_valid = tlb_ex_valid_in;
            tlb_vaddr    = (((tlb_ex_valid_in[0]===1'b1)|(tlb_ex_valid_in[1]===1'b1)|(tlb_ex_valid_in[2]===1'b1)|(tlb_ex_valid_in[3]===1'b1)|(tlb_ex_valid_in[4]===1'b1)|(tlb_ex_valid_in[5]===1'b1)) ? tlb_vaddr_in : 32'b0);
            exception_valid = exception_valid_w;
        end
        // CSRRD 仅读 CSR，异常入口在 TLBR 重取窗口内需仍能读到 BADV/TLBEHI 等；写类 CSR 仍避开 refetch 泡。
        else if (inst_csr_all && ((refetch_tag_in !== 1'b1) || inst_csrrd)) begin
            src1_addr   = rf_raddr1_w;
            src2_addr   = rf_raddr2_w;
            wb_reg_addr = (stall === 1'b1) ? 5'd0 : inst[4:0];
            alu_src1    = 32'b0;
            alu_src2    = 32'b0;
            br_imm      = 32'b0;
            alu_op      = {`ALU_OP_NUM{1'b0}};
            br_op       = {`BR_OP_NUM{1'b0}};
            mem_op      = {`MEM_OP_NUM{1'b0}};
            mem_wdata   = 32'b0;
            wb_op       = (stall === 1'b1) ? 1'b0 : 1'b1;
            wb_src_op   = (stall === 1'b1) ? {`WB_SRC_NUM{1'b0}} : wb_src_op_inner;
            pc_out      = (stall === 1'b1) ? 32'b0 : pc_in;
            csr_num     = (stall === 1'b1) ? 12'b0 : inst[23:10];
            if (inst_csrrd) begin
                csr_op     = (stall === 1'b1) ? {`CSR_OP_NUM{1'b0}} :
                             ({`CSR_OP_NUM{1'b0}} | ({{(`CSR_OP_NUM-1){1'b0}},1'b1} << `CSR_OP_CSRRD));
                csr_wmask  = 32'b0;
                csr_wvalue = 32'b0;
            end
            else if (inst_csrwr) begin
                csr_op     = (stall === 1'b1) ? {`CSR_OP_NUM{1'b0}} :
                             ({`CSR_OP_NUM{1'b0}} | ({{(`CSR_OP_NUM-1){1'b0}},1'b1} << `CSR_OP_CSRWR));
                csr_wmask  = (stall === 1'b1) ? 32'b0 : 32'hffff_ffff;
                csr_wvalue = (stall === 1'b1) ? 32'b0 : src1_rdata;
            end
            else begin
                csr_op     = (stall === 1'b1) ? {`CSR_OP_NUM{1'b0}} :
                             ({`CSR_OP_NUM{1'b0}} | ({{(`CSR_OP_NUM-1){1'b0}},1'b1} << `CSR_OP_CSRXCHG));
                csr_wmask  = (stall === 1'b1) ? 32'b0 : src1_rdata;
                csr_wvalue = (stall === 1'b1) ? 32'b0 : src2_rdata;
            end
        end
        else if (inst_rdcnt_all && (refetch_tag_in !== 1'b1)) begin
            src1_addr   = rf_raddr1_w;
            src2_addr   = rf_raddr2_w;
            // rdcntid 的目的寄存器在 rj 字段，rdcntvl/rdcntvh 在 rd 字段
            wb_reg_addr = (stall === 1'b1) ? 5'd0 : (inst_rdcntid ? inst[9:5] : inst[4:0]);
            alu_src1    = 32'b0;
            alu_src2    = 32'b0;
            br_imm      = 32'b0;
            alu_op      = {`ALU_OP_NUM{1'b0}};
            br_op       = {`BR_OP_NUM{1'b0}};
            mem_op      = {`MEM_OP_NUM{1'b0}};
            mem_wdata   = 32'b0;
            wb_op       = (stall === 1'b1) ? 1'b0 : 1'b1;
            wb_src_op   = (stall === 1'b1) ? {`WB_SRC_NUM{1'b0}} : wb_src_op_inner;
            pc_out      = (stall === 1'b1) ? 32'b0 : pc_in;
        end
        else if (inst_ertn && (refetch_tag_in !== 1'b1)) begin
            src1_addr   = rf_raddr1_w;
            src2_addr   = rf_raddr2_w;
            wb_reg_addr = 5'b0;
            alu_src1    = 32'b0;
            alu_src2    = 32'b0;
            br_imm      = 32'b0;
            alu_op      = {`ALU_OP_NUM{1'b0}};
            br_op       = {`BR_OP_NUM{1'b0}};
            mem_op      = {`MEM_OP_NUM{1'b0}};
            mem_wdata   = 32'b0;
            wb_op       = 1'b0;
            wb_src_op   = {`WB_SRC_NUM{1'b0}};
            pc_out      = (stall === 1'b1) ? 32'b0 : pc_in;
            ertn_op     = (stall === 1'b0);
        end
        else if (inst_tlb_all) begin
            src1_addr   = rf_raddr1_w;
            src2_addr   = rf_raddr2_w;
            wb_reg_addr = 5'b0;
            alu_src1    = 32'b0;
            alu_src2    = 32'b0;
            br_imm      = 32'b0;
            alu_op      = {`ALU_OP_NUM{1'b0}};
            br_op       = {`BR_OP_NUM{1'b0}};
            mem_op      = {`MEM_OP_NUM{1'b0}};
            csr_op      = {`CSR_OP_NUM{1'b0}};
            mem_wdata   = 32'b0;
            wb_op       = 1'b0;
            wb_src_op   = {`WB_SRC_NUM{1'b0}};
            pc_out      = (stall === 1'b1) ? 32'b0 : pc_in;
            tlb_op      = (stall === 1'b1) ? {`TLB_OP_NUM{1'b0}} : tlb_op_inner;
            invtlb_asid = (stall === 1'b1) ? 10'b0 : src1_rdata[9:0];
            invtlb_vpn  = (stall === 1'b1) ? 19'b0 : src2_rdata[31:13];
            // TLB 维护后触发重取，保证后续访存/取指观察到最新的 TLB 状态。
            // INVTLB 也必须参与，否则会在切换映射窗口后读到旧翻译路径下的数据。
            refetch_tag_out = (stall === 1'b1) ? 1'b0
                             : ((inst_tlbwr | inst_tlbfill | inst_tlbrd
                               | inst_invtlb_0 | inst_invtlb_1 | inst_invtlb_2
                               | inst_invtlb_3 | inst_invtlb_4 | inst_invtlb_5 | inst_invtlb_6) ? 1'b1 : 1'b0);
        end
        else if (inst_cache_all && (refetch_tag_in !== 1'b1)) begin
            src1_addr   = rf_raddr1_w;
            src2_addr   = rf_raddr2_w;
            wb_reg_addr = 5'b0;
            alu_src1    = 32'b0;
            alu_src2    = 32'b0;
            br_imm      = 32'b0;
            alu_op      = {`ALU_OP_NUM{1'b0}};
            br_op       = {`BR_OP_NUM{1'b0}};
            mem_op      = {`MEM_OP_NUM{1'b0}};
            csr_op      = {`CSR_OP_NUM{1'b0}};
            mem_wdata   = 32'b0;
            wb_op       = 1'b0;
            wb_src_op   = {`WB_SRC_NUM{1'b0}};
            pc_out      = (stall === 1'b1) ? 32'b0 : pc_in;
            // cache 维护指令在 stall 拍不能清零，否则 CACOP 元信息会在入 EXE 前丢失。
            cache_op_valid = cache_op_inner;
            // Cache 维护指令提交后需要触发 IF 重取（与 TLB 维护同类语义），
            // 否则自修改代码场景可能继续执行旧 ICache 行。
            refetch_tag_out = 1'b1;
            cacop_op    = inst_cacop ? inst[4:3] : 2'b0;
            cacop_addr  = inst_cacop ? (src1_rdata + {{20{inst[21]}}, inst[21:10]}) : 32'b0;
            cacop_mat   = 2'b0;
            cacop_cd    = inst_cacop ? inst[4:0] : 5'b0;
        end
        else if (refetch_tag_in) begin
            src1_addr = 5'b0;
            src2_addr = 5'b0;
            wb_reg_addr = 5'b0;
            alu_src1 = 32'b0;
            alu_src2 = 32'b0;
            br_imm = 32'b0;
            alu_op = {`ALU_OP_NUM{1'b0}};
            br_op = {`BR_OP_NUM{1'b0}};
            mem_op = {`MEM_OP_NUM{1'b0}};
            csr_op = {`CSR_OP_NUM{1'b0}};
            tlb_op = {`TLB_OP_NUM{1'b0}};
            cache_op_valid = {`CACHE_OP_NUM{1'b0}};
            wb_op = 1'b0;
            wb_src_op = {`WB_SRC_NUM{1'b0}};
            exception_valid = 1'b0;
            pc_out = (stall === 1'b1) ? 32'b0 : pc_in;
            // refetch tag 在该分支仅用于“消费并注入气泡”，不能继续向后级级联传播。
            refetch_tag_out = 1'b0;
        end
    end

endmodule
