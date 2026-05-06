`include "mycpu.vh"
`include "pipeline_types.sv"
module decoder
    import pipeline_types::*;
    import core_defines::*;
(
    input  wire [31:0] ID_inst,
    input  wire        IF_ex,
    input  wire [ 3:0] IF_excp_num,

    input  wire ID_ready_go,
    input  wire dequeue_en,
    input  instr_info_t data_fifo,
    output ID_RA_bus_t ID_RA_bus
    );
//================================ 指令译码信号 ================================
/*对指令进行分解的信号*/
logic [ 5:0] op_31_26;
logic [ 3:0] op_25_22;
logic [ 1:0] op_21_20;
logic [ 4:0] op_19_15;
logic [ 4:0] rd;
logic [ 4:0] rj;
logic [ 4:0] rk;
logic [11:0] i12;
logic [13:0] i14;
logic [19:0] i20;
logic [15:0] i16;
logic [25:0] i26;
/*通过decoder解码指令*/
logic [63:0] op_31_26_d;
logic [15:0] op_25_22_d;
logic [ 3:0] op_21_20_d;
logic [31:0] op_19_15_d;
logic [31:0] rd_d;
logic [31:0] rj_d;
logic [31:0] rk_d;

// 具体指令译码信号
// 算术指令
logic  inst_add_w;
logic  inst_addi_w;
logic  inst_sub_w;
logic  inst_slt;
logic  inst_slti;
logic  inst_sltu;
logic  inst_sltui;
logic  inst_nor;
logic  inst_and;
logic  inst_andi;
logic  inst_or;
logic  inst_ori;
logic  inst_xor;
logic  inst_xori;
logic  inst_sll_w;
logic  inst_slli_w;
logic  inst_srl_w;
logic  inst_srli_w;
logic  inst_sra_w;
logic  inst_srai_w;
// 乘除指令
logic  inst_mul_w;
logic  inst_mulh_w;
logic  inst_mulh_wu;
logic  inst_div_w;
logic  inst_mod_w;
logic  inst_div_wu;
logic  inst_mod_wu;
// 栅障指令，没实现，归到nop指令
logic  inst_dbar;
logic  inst_ibar;
// preld
logic  inst_preld;
// 访存、写存指令
logic  inst_ld_b;
logic  inst_ld_bu;
logic  inst_ld_h;
logic  inst_ld_hu;
logic  inst_ld_w;
logic  inst_st_b;
logic  inst_st_h;
logic  inst_st_w;
// 原子访存指令
logic  inst_ll_w;
logic  inst_sc_w;
// 跳转指令
logic  inst_jirl;
logic  inst_b;
logic  inst_bl;
logic  inst_beq;
logic  inst_bne;
logic  inst_blt;
logic  inst_bge;
logic  inst_bltu;
logic  inst_bgeu;

logic  inst_lu12i_w;
logic  inst_pcaddu12i;
/*特权指令*/
// CSR指令
logic  inst_csrrd;
logic  inst_csrwr;
logic  inst_csrxchg;
// Cache维护指令
logic  inst_cacop;
logic  inst_valid_cacop; // 表示cacop指令的操作码让该cacop指令进行一定的操作，而不是无操作
// TLB指令
logic  inst_tlbsrch;
logic  inst_tlbrd;
logic  inst_tlbwr;
logic  inst_tlbfill;
logic  inst_invtlb;
// 其他杂项指令
logic  inst_idle;
logic  inst_ertn;
/*特权指令结束*/

// 异常指令
logic  inst_syscall;
logic  inst_break;
// 计时器指令
logic  inst_rdcntid_w;
logic  inst_rdcntvl_w;
logic  inst_rdcntvh_w;

// nop，包含无操作的指令和没实现的指令
logic  inst_nop;

// cpucfg
logic  inst_cpucfg;

// 数据压缩，指令类型分类
logic  inst_type;
logic  alu_type;
logic  mul_type;
logic  div_type;
logic  branch_type;
logic  load_type;
logic  store_type;
logic  csr_type;
logic  tlb_type;
logic  special_type;

//================================ 功能单元控制信号 ================================

/*生成的各种控制信号还有参与运算的数据*/
logic [3 :0] alu_op; // ALU操作码
logic [2 :0] mul_op; // 乘法器操作码
logic [2 :0] div_op; // 除法器操作码
logic [2 :0] inst_ld_en; // 加载类型使能
logic [1 :0] inst_st_en; // 存储类型使能
// 操作数选择信号
logic        src_reg_is_rd;  // 源寄存器使用rd
logic        dst_is_r1;      // 目标寄存器为r1
logic        dst_is_rj;      // 目标寄存器为rj
logic        src1_is_pc;     // 源1为PC
logic        src2_is_imm;    // 源2为立即数
logic        src2_is_4;      // 源2为常数4
logic        res_from_mem;   // 结果来自内存
logic        gr_we;          // 通用寄存器写使能
logic        mem_we;         // 内存写使能
logic [4:0]  dest;           // 目标寄存器编号
/*立即数相关信号*/
logic        need_ui5;
logic        need_si12;
logic        need_ui12;
logic        need_si14;
logic        need_si16;
logic        need_si20;
logic        need_si26;
// 立即数值
logic [31:0] imm;
//================================ 分支处理逻辑 ================================
/*跳转指令的偏移地址*/
logic [31:0] br_offs;        // 分支偏移量
/*跳转指令信号*/
logic [ 8:0] br_inst_sel; // 跳转指令使能，不同位表示不同的跳转指令
//================================ CSR控制信号 ================================
/*在ID阶段产生，但是在EXE阶段读出数据，在WB阶段写入数据。所以需要随流水线往下传*/
logic         csr_re;     // 读使能
logic [13: 0] csr_num;    // 寄存器号
logic         csr_we;     // 写使能
//================================ 异常处理信号 ================================
/*异常相关的信号*/
logic        ertn_flush; // 该指令为ertn指令，到达WB阶段时清空流水线
logic        ID_ex;      // 该指令有异常
logic [ 7:0] ID_excp_num;// 异常号，每一位代表一种异常
logic [ 1:0] op_timer_64;// 定时器操作类型
logic        inst_valid; // 用于判断ine异常（指令不存在异常）
logic        excp_ine;   // 指令不存在例外（INE）
logic        excp_ipe;   // 指令特权等级错例外（IPE）    目前还不需要实现
//================================ TLB控制信号 ================================
/*TLB指令相关控制信号*/
logic        tlbsrch_en;     // TLB搜索使能
logic        tlbwr_en;       // TLB写使能
logic        tlbfill_en;     // TLB填充使能
logic        tlbrd_en;       // TLB读使能
logic        invtlb_en;      // TLB无效使能
logic [ 4:0] invtlb_op;      // TLB无效操作类型

logic        rj_is_r0;       // 用于invtlb指令，当invtlb_op不为4、5、6时，不需要用ASID，应该让rj为0
logic        rk_is_r0;       // 用于invtlb指令，当invtlb_op不为5、6时，不需要用VA，应该让rk为0


//================================ 主要逻辑实现 ================================

//================================ 指令译码逻辑 ================================
/*指令译码*/
assign op_31_26  = ID_inst[31:26];
assign op_25_22  = ID_inst[25:22];
assign op_21_20  = ID_inst[21:20];
assign op_19_15  = ID_inst[19:15];
// 不知道这样写会不会对延迟影响很大
assign rd   = ID_inst[ 4: 0];
assign rj   = ~{5{rj_is_r0}} & ID_inst[ 9: 5]; // 特殊处理invtlb指令
assign rk   = ~{5{rk_is_r0}} & ID_inst[14:10]; // 特殊处理invtlb指令

assign i12  = ID_inst[21:10];
assign i14  = ID_inst[23:10];
assign i20  = ID_inst[24: 5];
assign i16  = ID_inst[25:10];
assign i26  = {ID_inst[ 9: 0], ID_inst[25:10]};

// 指令译码器实例化
decoder_6_64 u_dec0(.in(op_31_26 ), .out(op_31_26_d ));
decoder_4_16 u_dec1(.in(op_25_22 ), .out(op_25_22_d ));
decoder_2_4  u_dec2(.in(op_21_20 ), .out(op_21_20_d ));
decoder_5_32 u_dec3(.in(op_19_15 ), .out(op_19_15_d ));
decoder_5_32 u_dec4(.in(rd  ), .out(rd_d  ));
decoder_5_32 u_dec5(.in(rj  ), .out(rj_d  ));
decoder_5_32 u_dec6(.in(rk  ), .out(rk_d  ));
// 具体指令译码
assign inst_add_w     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h00];
assign inst_sub_w     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h02];
assign inst_slt       = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h04];
assign inst_slti      = op_31_26_d[6'h00] & op_25_22_d[4'h8];
assign inst_sltu      = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h05];
assign inst_sltui     = op_31_26_d[6'h00] & op_25_22_d[4'h9];
assign inst_nor       = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h08];
assign inst_and       = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h09];
assign inst_or        = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0a];
assign inst_xor       = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0b];
assign inst_andi      = op_31_26_d[6'h00] & op_25_22_d[4'hD];
assign inst_ori       = op_31_26_d[6'h00] & op_25_22_d[4'hE];
assign inst_xori      = op_31_26_d[6'h00] & op_25_22_d[4'hF];
assign inst_slli_w    = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h01];
assign inst_srli_w    = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h09];
assign inst_srai_w    = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h11];
assign inst_sll_w     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0E];
assign inst_srl_w     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0F];
assign inst_sra_w     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h10];
assign inst_addi_w    = op_31_26_d[6'h00] & op_25_22_d[4'ha];
// 访存指令
assign inst_ld_w      = op_31_26_d[6'h0a] & op_25_22_d[4'h2];
assign inst_ld_b      = op_31_26_d[6'h0a] & op_25_22_d[4'h0];
assign inst_ld_bu     = op_31_26_d[6'h0a] & op_25_22_d[4'h8];
assign inst_ld_h      = op_31_26_d[6'h0a] & op_25_22_d[4'h1];
assign inst_ld_hu     = op_31_26_d[6'h0a] & op_25_22_d[4'h9];
// 写存指令
assign inst_st_w      = op_31_26_d[6'h0a] & op_25_22_d[4'h6];
assign inst_st_b      = op_31_26_d[6'h0a] & op_25_22_d[4'h4];
assign inst_st_h      = op_31_26_d[6'h0a] & op_25_22_d[4'h5];
// 原子访存指令
assign inst_ll_w       = op_31_26_d[6'h08] & ~ID_inst[25] & ~ID_inst[24];
assign inst_sc_w       = op_31_26_d[6'h08] & ~ID_inst[25] &  ID_inst[24];
// 跳转指令
assign inst_jirl      = op_31_26_d[6'h13];
assign inst_b         = op_31_26_d[6'h14];
assign inst_bl        = op_31_26_d[6'h15];
assign inst_beq       = op_31_26_d[6'h16];
assign inst_bne       = op_31_26_d[6'h17];
assign inst_blt       = op_31_26_d[6'h18];
assign inst_bltu      = op_31_26_d[6'h1A];
assign inst_bge       = op_31_26_d[6'h19];
assign inst_bgeu      = op_31_26_d[6'h1B];
assign inst_lu12i_w   = op_31_26_d[6'h05] & ~ID_inst[25];
assign inst_pcaddu12i = op_31_26_d[6'h07] & ~ID_inst[25];
assign inst_mul_w     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h18];
assign inst_mulh_w    = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h19];
assign inst_mulh_wu   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h1A];
assign inst_div_w     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h00]; 
assign inst_div_wu    = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h02]; 
assign inst_mod_w     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h01];
assign inst_mod_wu    = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h03];
// 栅障指令，没实现，归到nop指令
assign inst_dbar       = op_31_26_d[6'h0e] & op_25_22_d[4'h1] & op_21_20_d[2'h3] & op_19_15_d[5'h04];
assign inst_ibar       = op_31_26_d[6'h0e] & op_25_22_d[4'h1] & op_21_20_d[2'h3] & op_19_15_d[5'h05];
// preld
assign inst_preld      = op_31_26_d[6'h0a] & op_25_22_d[4'hb];

/*特权指令*/
// CSR指令
assign inst_csrrd     = op_31_26_d[6'h01] & ~ID_inst[25] & ~ID_inst[24] & rj_d[5'h00];
assign inst_csrwr     = op_31_26_d[6'h01] & ~ID_inst[25] & ~ID_inst[24] & rj_d[5'h01];
assign inst_csrxchg   = op_31_26_d[6'h01] & ~ID_inst[25] & ~ID_inst[24] & (~rj_d[5'h00] & ~rj_d[5'h01]);
// Cache维护指令
assign inst_cacop       = op_31_26_d[6'h01] & op_25_22_d[4'h8];
assign inst_valid_cacop = inst_cacop & (dest[2:0]==3'b0 | dest[2:0]==3'b1) & (dest[4:3]==2'd0 | dest[4:3]==2'd1 | dest[4:3]==2'd2); // dest为低5位，表示code
// TLB指令
assign inst_tlbsrch    = op_31_26_d[6'h01] & op_25_22_d[4'h9] & op_21_20_d[2'h0] & op_19_15_d[5'h10] & rk_d[5'h0a] & rj_d[5'h00] & rd_d[5'h00];
assign inst_tlbrd      = op_31_26_d[6'h01] & op_25_22_d[4'h9] & op_21_20_d[2'h0] & op_19_15_d[5'h10] & rk_d[5'h0b] & rj_d[5'h00] & rd_d[5'h00];
assign inst_tlbwr      = op_31_26_d[6'h01] & op_25_22_d[4'h9] & op_21_20_d[2'h0] & op_19_15_d[5'h10] & rk_d[5'h0c] & rj_d[5'h00] & rd_d[5'h00];
assign inst_tlbfill    = op_31_26_d[6'h01] & op_25_22_d[4'h9] & op_21_20_d[2'h0] & op_19_15_d[5'h10] & rk_d[5'h0d] & rj_d[5'h00] & rd_d[5'h00];
assign inst_invtlb     = op_31_26_d[6'h01] & op_25_22_d[4'h9] & op_21_20_d[2'h0] & op_19_15_d[5'h13];
// 其他杂项指令
assign inst_idle       = op_31_26_d[6'h01] & op_25_22_d[4'h9] & op_21_20_d[2'h0] & op_19_15_d[5'h11];
assign inst_ertn       = op_31_26_d[6'h01] & op_25_22_d[4'h9] & op_21_20_d[2'h0] & op_19_15_d[5'h10] & rk_d[5'h0e] & rj_d[5'h00] & rd_d[5'h00];
/*特权指令结束*/

// 异常指令
assign inst_syscall   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h16];
assign inst_break     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h14];

// 定时器指令
assign inst_rdcntid_w = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h0] & op_19_15_d[5'h00] & rk_d[5'h18] & rd_d[5'h00];
assign inst_rdcntvl_w = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h0] & op_19_15_d[5'h00] & rk_d[5'h18] & rj_d[5'h00] & !rd_d[5'h00];
assign inst_rdcntvh_w = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h0] & op_19_15_d[5'h00] & rk_d[5'h19] & rj_d[5'h00];

// nop，包含无操作的指令和没实现的指令
assign inst_nop = (inst_cacop && ((dest[2:0]!=3'b0 && dest[2:0]!=3'b1) || (dest[4:3]==2'd3))) || inst_dbar || inst_ibar || inst_preld;

// cpucfg
assign inst_cpucfg     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h0] & op_19_15_d[5'h00] & rk_d[5'h1b];


///////////////////////////////////////////////////////////////////////////////添加指令时注意修改
// 指令有效性判断，用于判断ine异常（指令不存在异常）
assign inst_valid      = inst_add_w | inst_sub_w | inst_slt | inst_sltu | inst_nor | inst_and | inst_or | inst_xor | inst_slli_w | inst_srli_w | inst_srai_w | inst_addi_w
                       | inst_jirl | inst_b | inst_bl | inst_beq | inst_bne | inst_lu12i_w | inst_slti | inst_sltui | inst_andi | inst_ori | inst_xori | inst_sll_w 
                       | inst_srl_w | inst_sra_w | inst_pcaddu12i | inst_mul_w | inst_mulh_w | inst_mulh_wu | inst_div_w | inst_mod_w | inst_div_wu | inst_mod_wu 
                       | inst_blt | inst_bge | inst_bltu | inst_bgeu 
                       | inst_ld_b | inst_ld_h | inst_ld_w | inst_st_b | inst_st_h | inst_st_w | inst_ld_bu | inst_ld_hu
                       | inst_ll_w | inst_sc_w
                       | inst_csrrd | inst_csrwr | inst_csrxchg
                       | inst_ertn  | inst_idle
                       | inst_syscall | inst_break
                       | inst_rdcntid_w | inst_rdcntvl_w | inst_rdcntvh_w
                       | inst_tlbsrch | inst_tlbrd | inst_tlbwr | inst_tlbfill 
                       | (inst_invtlb & (invtlb_op == 5'h0 | invtlb_op == 5'h1 | invtlb_op == 5'h2 | invtlb_op == 5'h3 | invtlb_op == 5'h4 | invtlb_op == 5'h5 | invtlb_op == 5'h6 )) // 当invtlb_op不为这些值的时候，触发指令不存在例外
                       | inst_valid_cacop | inst_nop | inst_cpucfg;

// assign alu_type  = inst_add_w | inst_sub_w | inst_slt | inst_sltu | inst_nor | inst_and | inst_or | inst_xor | inst_slli_w | inst_srli_w | inst_srai_w | inst_addi_w
//                  | inst_lu12i_w | inst_slti | inst_sltui | inst_andi | inst_ori | inst_xori | inst_sll_w 
//                  | inst_srl_w | inst_sra_w | inst_pcaddu12i;

// assign mul_type     = inst_mul_w | inst_mulh_w | inst_mulh_wu;
// assign div_type     = inst_div_w | inst_mod_w | inst_div_wu | inst_mod_wu;
// assign branch_type  = inst_jirl | inst_b | inst_bl | inst_beq | inst_bne | inst_blt | inst_bge | inst_bltu | inst_bgeu ;
// assign load_type    = inst_ld_b | inst_ld_bu | inst_ld_h | inst_ld_hu | inst_ld_w;
// assign store_type   = inst_st_b | inst_st_h | inst_st_w;
// assign csr_type     = inst_csrrd | inst_csrwr | inst_csrxchg | inst_rdcntid_w | inst_rdcntvl_w | inst_rdcntvh_w;
// assign tlb_type     = inst_tlbsrch | inst_tlbrd | inst_tlbwr | inst_tlbfill
//                     | (inst_invtlb & (invtlb_op == 5'h0 | invtlb_op == 5'h1 | invtlb_op == 5'h2 | invtlb_op == 5'h3 | invtlb_op == 5'h4 | invtlb_op == 5'h5 | invtlb_op == 5'h6 )); // 当invtlb_op不为这些值的时候，触发指令不存在例外;

// assign special_type = inst_ertn  | inst_idle | inst_syscall | inst_break | inst_valid_cacop | inst_nop;

//================================ 控制信号生成 ================================
/*alu_op信号生成*/
// assign alu_op[ 0] = inst_add_w | inst_addi_w  
//                     | inst_jirl | inst_bl | inst_pcaddu12i
//                     | inst_ld_w | inst_ld_b | inst_ld_bu | inst_ld_h | inst_ld_hu
//                     | inst_st_w | inst_st_h | inst_st_b
//                     | inst_ll_w | inst_sc_w
//                     | inst_valid_cacop ;
// assign alu_op[ 1] = inst_sub_w;
// assign alu_op[ 2] = inst_slt | inst_slti;
// assign alu_op[ 3] = inst_sltu | inst_sltui;
// assign alu_op[ 4] = inst_and |inst_andi;
// assign alu_op[ 5] = inst_nor;
// assign alu_op[ 6] = inst_or | inst_ori;
// assign alu_op[ 7] = inst_xor | inst_xori;
// assign alu_op[ 8] = inst_slli_w | inst_sll_w;
// assign alu_op[ 9] = inst_srli_w | inst_srl_w;
// assign alu_op[10] = inst_srai_w | inst_sra_w;
// assign alu_op[11] = inst_lu12i_w;

assign alu_op = {4{inst_add_w | inst_addi_w  
                | inst_jirl | inst_bl | inst_pcaddu12i
                | inst_ld_w | inst_ld_b | inst_ld_bu | inst_ld_h | inst_ld_hu
                | inst_st_w | inst_st_h | inst_st_b
                | inst_ll_w | inst_sc_w
                | inst_valid_cacop}}            & ADD |
                {4{inst_sub_w}}                 & SUB |
                {4{inst_slt | inst_slti}}       & SLT |
                {4{inst_sltu | inst_sltui}}     & SLTU |
                {4{inst_and | inst_andi}}       & AND |
                {4{inst_nor}}                   & NOR |
                {4{inst_or | inst_ori}}         & OR |
                {4{inst_xor | inst_xori}}       & XOR |
                {4{inst_slli_w | inst_sll_w}}   & SLL |
                {4{inst_srli_w | inst_srl_w}}   & SRL |
                {4{inst_srai_w | inst_sra_w}}   & SRA |
                {4{inst_lu12i_w}}               & LUI ;


/*mul_div_op信号生成*/
assign mul_op[0] = inst_mul_w | inst_mulh_w | inst_mulh_wu;//1表示进行乘法运算
assign mul_op[1] = inst_mul_w | inst_mulh_w;    //1表示有符号，0为无符号
assign mul_op[2] = inst_mulh_wu | inst_mulh_w;  //1表示高位，0为低位

assign div_op[0] = inst_div_w | inst_div_wu | inst_mod_w | inst_mod_wu; //1表示要进行除法运算
assign div_op[1] = inst_div_w | inst_mod_w;//1表示有符号，0为无符号
assign div_op[2] = inst_div_w | inst_div_wu;//1表示取商，0表示取余数

/*生成立即数*/
assign need_ui5     = inst_slli_w | inst_srli_w | inst_srai_w;
assign need_si12    = inst_addi_w | inst_slti | inst_sltui |
                      inst_ld_w |inst_ld_b | inst_ld_bu | inst_ld_h | inst_ld_hu |
                      inst_st_w | inst_st_b | inst_st_h |
                      inst_valid_cacop;
assign need_ui12    = inst_andi | inst_ori | inst_xori;
assign need_si14    = inst_ll_w | inst_sc_w;
assign need_si16    = inst_jirl | inst_beq | inst_bne | inst_blt | inst_bltu | inst_bge | inst_bgeu;
assign need_si20    = inst_lu12i_w | inst_pcaddu12i;
assign need_si26    = inst_b | inst_bl;
assign src2_is_4    = inst_jirl | inst_bl;

always_comb begin
    unique case (1'b1)
        src2_is_4 : imm = 32'h4                      ;
        need_si20 : imm = {i20[19:0], 12'b0}         ;
        need_ui12 : imm = {20'b0, i12[11:0]}         ; // 立即数作零扩展
        need_si14 : imm = {{16{i14[13]}}, i14, 2'b0} ;
        default   : imm = {{20{i12[11]}}, i12[11:0]} ; // 立即数作符号扩展;need_ui5 | need_si12
    endcase
end

/*生成跳转地址计算操作数*/
assign br_offs = {32{need_si26}}  & {{ 4{i26[25]}}, i26[25:0], 2'b0} | 
                 {32{~need_si26}} & {{14{i16[15]}}, i16[15:0], 2'b0} ;

assign br_inst_sel = {inst_beq, inst_bne, inst_blt, inst_bltu, inst_bge, inst_bgeu, inst_jirl, inst_bl, inst_b};

/*生成各个控制信号*/
assign src_reg_is_rd = inst_beq | inst_bne |  inst_blt | inst_bltu | inst_bge | inst_bgeu |
                       inst_st_w | inst_st_h | inst_st_b | inst_sc_w |
                       inst_csrwr | inst_csrxchg;

assign src1_is_pc    = inst_jirl | inst_bl | inst_pcaddu12i;

assign src2_is_imm   = inst_slli_w      |
                       inst_srli_w      |
                       inst_srai_w      |
                       inst_addi_w      |
                       inst_ld_w        |
                       inst_ld_h        |
                       inst_ld_hu       |
                       inst_ld_b        |
                       inst_ld_bu       |
                       inst_st_w        |
                       inst_st_h        |
                       inst_st_b        |
                       inst_ll_w        |
                       inst_sc_w        |
                       inst_lu12i_w     |
                       inst_jirl        |
                       inst_bl          |
                       inst_andi        |
                       inst_ori         |
                       inst_xori        |
                       inst_slti        |
                       inst_sltui       |
                       inst_pcaddu12i   |
                       inst_valid_cacop ;

///////////////////////////////////////////////////////////////// 添加指令时注意修改，不写回的指令写进去
assign gr_we         = ~inst_st_w & ~inst_st_h & ~inst_st_b &
                       ~inst_beq & ~inst_bne & ~inst_b & ~inst_blt & ~inst_bltu & ~inst_bge & ~inst_bgeu &
                       ~inst_ertn & ~inst_idle &
                       ~inst_syscall & ~inst_break &
                       ~inst_tlbsrch & ~inst_tlbrd & ~inst_tlbwr & ~inst_tlbfill & ~inst_invtlb &
                       ~inst_valid_cacop & ~inst_nop;

assign dst_is_r1     = inst_bl;
assign dst_is_rj     = inst_rdcntid_w; // 该指令以rj为目的寄存器
assign dest          = {5{dst_is_r1}}               & 5'd1 |
                       {5{dst_is_rj}}               & rj   |
                       {5{~dst_is_r1 & ~dst_is_rj}} & rd   ;

//访存控制信号的生成
// assign mem_we        = inst_st_w | inst_st_h | inst_st_b;   //内存写使能信号，sc.w指令还不能确定是否要写内存，在EXE阶段进行判断
// assign res_from_mem  = inst_ld_w | inst_ld_h | inst_ld_hu | inst_ld_b | inst_ld_bu | inst_ll_w; // 访存读使能信号   
// assign inst_ld_en    = {1'b0, inst_ll_w, inst_ld_bu, inst_ld_b, inst_ld_hu, inst_ld_h, inst_ld_w, res_from_mem};
// assign inst_st_en    = {4'b0, inst_st_b, inst_st_h, inst_st_w, mem_we};

assign inst_ld_en    = {3{inst_ld_b}} & LD_B  |
                       {3{inst_ld_bu}}& LD_BU |
                       {3{inst_ld_h}} & LD_H  |
                       {3{inst_ld_hu}}& LD_HU |
                       {3{inst_ld_w}} & LD_W  |
                       {3{inst_ll_w}} & LL_W  ;

assign inst_st_en    = {2{inst_st_b}} & ST_B  |
                       {2{inst_st_h}} & ST_H  |
                       {2{inst_st_w}} & ST_W  ;

/*对csr的读写控制信号*/
assign csr_re     = inst_csrrd | inst_csrwr | inst_csrxchg | inst_rdcntid_w | inst_sc_w | inst_cpucfg; // 把sc.w指令也归到读csr的指令中，是因为该指令会读llbit的值，根据读的值来判断是否写内存
assign csr_we     = inst_csrwr | inst_csrxchg | inst_ll_w; // 把ll.w指令也归到写csr的指令中，是因为该指令执行会将llbit置1，相当于写CSR了
assign csr_num    = inst_rdcntid_w          ? `TID : 
                    (inst_ll_w | inst_sc_w) ? `LLBCTL :
                    inst_cpucfg             ? `CPUCFG :
                                            ID_inst[23:10]; // inst_rdcntid_w读tid的值

/*定时器指令的信号*/
assign op_timer_64[0] = inst_rdcntvl_w;
assign op_timer_64[1] = inst_rdcntvh_w;

/*TLB指令相关控制信号*/
assign tlbsrch_en = inst_tlbsrch;
assign tlbwr_en   = inst_tlbwr;
assign tlbfill_en = inst_tlbfill;
assign tlbrd_en   = inst_tlbrd;
assign invtlb_en  = inst_invtlb;
assign invtlb_op  = ID_inst[4:0];
// 当invtlb_op不为4、5、6时，不需要用ASID，应该让rj为0；当invtlb_op不为5、6时，不需要用VA，应该让rk为0
// rj_is_r0和rk_is_r0在rj和rk的生成逻辑中使用了
assign rj_is_r0   = invtlb_en & ~((invtlb_op == 5'h4) | (invtlb_op == 5'h5) | (invtlb_op == 5'h6));
assign rk_is_r0   = invtlb_en & ~((invtlb_op == 5'h5) | (invtlb_op == 5'h6));

///////////////////////////////////////////////////////////////////////////////////// 添加指令时注意修改

//首先是判断rj、rk、rd是不是源操作数，如果是源操作数再来比对其他阶段的目的寄存器
assign src_no_rj    = inst_b | inst_bl | inst_lu12i_w | inst_pcaddu12i |
                      inst_csrrd | inst_csrwr |
                      inst_ertn | inst_idle |
                      inst_syscall | inst_break |
                      inst_rdcntid_w | inst_rdcntvl_w | inst_rdcntvh_w |
                      inst_tlbsrch | inst_tlbwr | inst_tlbfill | inst_tlbrd | // invtlb指令要用rj
                      inst_nop;

assign src_no_rk    = inst_bl | inst_b | inst_beq | inst_bne  | inst_blt | inst_bltu | inst_bge | inst_bgeu | inst_jirl | src2_is_imm | //所有有立即数的指令和分支跳转类型指令都没有rk
                      inst_csrrd | inst_csrwr | inst_csrxchg |
                      inst_ertn | inst_idle |
                      inst_syscall | inst_break |
                      inst_rdcntid_w | inst_rdcntvl_w | inst_rdcntvh_w |
                      inst_tlbsrch | inst_tlbwr | inst_tlbfill | inst_tlbrd | // invtlb指令要用rk
                      inst_cacop | inst_nop | inst_cpucfg;

//================================ 异常处理 ================================
assign ertn_flush = inst_ertn;
// 指令不存在例外（INE）
// 指令特权等级错例外（IPE）    目前还不需要实现
assign excp_ine    = ~inst_valid;
assign excp_ipe    = 1'b0;
assign ID_ex       = IF_ex | excp_ipe | excp_ine | inst_syscall | inst_break;
assign ID_excp_num = {excp_ipe, excp_ine, inst_break, inst_syscall, IF_excp_num};

//================================ difftest ================================
`ifdef DIFFTEST_EN
logic cnt_inst;
logic csr_rstat_en;
assign cnt_inst = inst_rdcntvl_w | inst_rdcntvh_w | inst_rdcntid_w ; 
assign csr_rstat_en = (inst_csrrd | inst_csrwr | inst_csrxchg) & (csr_num == `ESTAT);
`endif

//================================ 输出逻辑 ================================
// valid还要与上dequeue_en，因为只有真正出队的时候才是有效的
assign ID_RA_bus.valid          = data_fifo.valid && ID_ready_go && dequeue_en; // ID_valid是存起来的valid,但输出的valid是要与上ready_go的
assign ID_RA_bus.ftq_id         = data_fifo.ftq_id;
assign ID_RA_bus.ftq_block_idx  = data_fifo.ftq_block_idx;
assign ID_RA_bus.is_last_in_block = data_fifo.is_last_in_block;
assign ID_RA_bus.branch_info    = data_fifo.branch_info;

assign ID_RA_bus.rj    = rj;
assign ID_RA_bus.rk    = rk;
assign ID_RA_bus.rd    = rd;

/*寄存器读地址*/
assign ID_RA_bus.rf_raddr1 = rj;
assign ID_RA_bus.rf_raddr2 = {5{src_reg_is_rd}} & rd | {5{~src_reg_is_rd}} & rk;
assign ID_RA_bus.rf_raddr1_valid = ~src_no_rj & (rj != 5'b0);
assign ID_RA_bus.rf_raddr2_valid = (~src_no_rk & (rk != 5'b0)) | (src_reg_is_rd & (rd != 5'b0));

assign ID_RA_bus.alu_op = alu_op;
assign ID_RA_bus.mul_op = mul_op;
assign ID_RA_bus.div_op = div_op;

assign ID_RA_bus.inst_ld_en = inst_ld_en;
assign ID_RA_bus.inst_st_en = inst_st_en;

assign ID_RA_bus.src_reg_is_rd = src_reg_is_rd;
assign ID_RA_bus.src1_is_pc = src1_is_pc;
assign ID_RA_bus.src2_is_imm = src2_is_imm;

assign ID_RA_bus.gr_we = gr_we;
assign ID_RA_bus.dest = dest;
assign ID_RA_bus.imm = imm;

assign ID_RA_bus.csr_re = csr_re;
assign ID_RA_bus.csr_num = csr_num;
assign ID_RA_bus.csr_we = csr_we;

assign ID_RA_bus.ertn_flush = ertn_flush;
assign ID_RA_bus.ex = ID_ex;
assign ID_RA_bus.excp_num = ID_excp_num;

assign ID_RA_bus.op_timer_64 = op_timer_64;

assign ID_RA_bus.tlbsrch_en = tlbsrch_en;
assign ID_RA_bus.tlbwr_en = tlbwr_en;
assign ID_RA_bus.tlbfill_en = tlbfill_en;
assign ID_RA_bus.tlbrd_en = tlbrd_en;
assign ID_RA_bus.invtlb_en = invtlb_en;
assign ID_RA_bus.invtlb_op = invtlb_op;

assign ID_RA_bus.inst_ll_w = inst_ll_w;
assign ID_RA_bus.inst_sc_w = inst_sc_w;

assign ID_RA_bus.inst_valid_cacop = inst_valid_cacop;

assign ID_RA_bus.inst_idle = inst_idle;

assign ID_RA_bus.inst_jirl = inst_jirl;
assign ID_RA_bus.inst_bl   = inst_bl;
assign ID_RA_bus.br_offs = br_offs;
assign ID_RA_bus.br_inst_sel = br_inst_sel;

assign ID_RA_bus.src_no_rj = src_no_rj;
assign ID_RA_bus.src_no_rk = src_no_rk;

assign ID_RA_bus.inst_csrxchg = inst_csrxchg;
`ifdef DIFFTEST_EN
assign ID_RA_bus.inst  = ID_inst;
assign ID_RA_bus.cnt_inst = cnt_inst;
assign ID_RA_bus.csr_rstat_en = csr_rstat_en;
`endif
endmodule