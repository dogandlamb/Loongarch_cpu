`ifndef PIPELINE_TYPES_SV
`define PIPELINE_TYPES_SV
`include "core_defines.sv"
package pipeline_types;
    import core_defines::*;

    // Instruction info types
    typedef struct packed {
        // Instruction modify IF logic, any instr after it may be totaly wrong
        logic redirect;
        logic is_branch;
        logic [1:0] branch_type;
        logic is_taken;
        // Comes from BPU
        logic predecoder_redirect; // dont redirect but mispredict
        logic predicted_taken;
        logic predict_valid;  // BPU performance measurement
    } branch_info_t;

    typedef struct packed { // 扔进inst buffer的数据
        // 有效位
        logic valid;
        // Exception info 
        logic ex;
        // {excp_ppi, excp_pif, excp_tlbr, excp_adef}
        logic [3:0] excp_num;

        // 指令位于前端的信息
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;   // FTQ块的索引
        logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
        logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

        // 指令具体执行信息
        branch_info_t branch_info;

        // 前面说了一大堆，这才是本体哈哈哈，PC和指令编码
        logic [INST_WIDTH-1:0] inst;
    } instr_info_t;

    typedef struct packed {
        logic valid; // valid表示这个映射关系是否有效，有效则数据在ROB中，无效则数据在ARF中
        logic [$clog2(ROB_DEPTH)-1:0] prf;
    } PRF_t;

    typedef struct packed {
        logic valid;

        logic [ 4:0] rj;
        logic [ 4:0] rk;
        logic [ 4:0] rd;

        logic [ 4:0] rf_raddr1;
        logic [ 4:0] rf_raddr2;
        logic        rf_raddr1_valid;
        logic        rf_raddr2_valid;

        logic [ 3:0] alu_op;
        logic [ 2:0] mul_op;
        logic [ 2:0] div_op;

        logic [ 2:0] inst_ld_en;
        logic [ 1:0] inst_st_en;

        logic src_reg_is_rd;
        logic src1_is_pc;
        logic src2_is_imm;

        logic gr_we;
        logic [ 4:0] dest;
        logic [31:0] imm;

        logic csr_re;
        logic [13:0] csr_num;
        logic csr_we;

        logic ertn_flush;
        logic ex;
        logic [7:0] excp_num;

        logic [ 1:0] op_timer_64;

        logic tlbsrch_en;
        logic tlbwr_en;
        logic tlbfill_en;
        logic tlbrd_en;
        logic invtlb_en;
        logic [ 4:0] invtlb_op;

        logic inst_ll_w;
        logic inst_sc_w;

        logic inst_valid_cacop;

        logic inst_idle;

        logic inst_jirl;
        logic inst_bl;
        logic [31:0] br_offs;
        logic [ 8:0] br_inst_sel; // br_inst_sel = {inst_beq, inst_bne, inst_blt, inst_bltu, inst_bge, inst_bgeu, inst_jirl, inst_bl, inst_b}

        logic src_no_rj;
        logic src_no_rk;

        logic inst_csrxchg;

        // 指令位于前端的信息
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;   // FTQ块的索引
        logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
        logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

        // 指令具体执行信息
        branch_info_t branch_info;
        `ifdef DIFFTEST_EN
        logic [31:0] inst;
        logic cnt_inst;
        logic csr_rstat_en;
        `endif
    } ID_RA_bus_t;

    typedef struct packed {
        logic valid;
        logic [$clog2(ROB_DEPTH)-1:0] ROB_idx;

        logic [ 4:0] rf_raddr1;
        logic [ 4:0] rf_raddr2;
        logic        rf_raddr1_valid; // 表示指令是否会用到源寄存器1
        logic        rf_raddr2_valid; // 表示指令是否会用到源寄存器2
        PRF_t        rprf1;
        PRF_t        rprf2;

        logic [ 3:0] alu_op;
        logic [ 2:0] mul_op;
        logic [ 2:0] div_op;

        logic [ 2:0] inst_ld_en;
        logic [ 1:0] inst_st_en;

        logic src1_is_pc;
        logic src2_is_imm;

        logic gr_we;
        logic [ 4:0] dest;
        logic [31:0] imm;

        logic csr_re;
        logic [13:0] csr_num;
        logic csr_we;

        logic ertn_flush;
        logic ex;
        logic [7:0] excp_num;

        logic [ 1:0] op_timer_64;

        logic tlbsrch_en;
        logic tlbwr_en;
        logic tlbfill_en;
        logic tlbrd_en;
        logic invtlb_en;
        logic [ 4:0] invtlb_op;

        logic inst_ll_w;
        logic inst_sc_w;

        logic inst_valid_cacop;

        logic inst_idle;

        logic inst_jirl;
        logic inst_bl;
        logic [31:0] br_offs;
        logic [ 8:0] br_inst_sel; // br_inst_sel = {inst_beq, inst_bne, inst_blt, inst_bltu, inst_bge, inst_bgeu, inst_jirl, inst_bl, inst_b}

        logic inst_csrxchg;

        // 指令位于前端的信息
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;   // FTQ块的索引
        logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
        logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

        // 指令具体执行信息
        branch_info_t branch_info;
        // difftest
        `ifdef DIFFTEST_EN
        logic [31:0] inst;
        logic cnt_inst;
        logic csr_rstat_en;
        `endif
    } IQ_t;

    typedef struct packed {
        logic backend_ftq_meta_update_valid;
        logic backend_ftq_meta_update_ftb_dirty;
        logic [ADDR_WIDTH-1:0] backend_ftq_meta_update_jump_target;
        logic [ADDR_WIDTH-1:0] backend_ftq_meta_update_fall_through;
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] backend_ftq_update_meta_id;
    } backend_ftq_meta_updata_t;

    //后端提交的更新信息，先给FTQ然后再由FTQ给预测器
    typedef struct packed {
        logic is_branch;    //是否分支跳转
        logic [1:0] branch_type;    //分支跳转类型
        logic is_taken;             //是否真的跳转了
        logic predicted_taken;      // BPU给出的预测结果
    } backend_commit_meta_t;

    typedef struct packed {
        logic [$clog2(ROB_DEPTH)-1:0]  ROB_error_index;
        logic                          redirect; // 错误刷新标志
        logic [31:0]                   redirect_target; // 错误目标地址
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] redirect_ftq_id;
        backend_ftq_meta_updata_t      backend_ftq_meta_updata;
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0]  ftq_query_addr_o;
    } branch_bus_t;

    typedef struct packed {
        logic valid;
        logic [$clog2(ROB_DEPTH)-1:0] ROB_idx;

        logic [ 3:0] alu_op;
        logic [ 2:0] mul_op;
        logic [ 2:0] div_op;

        logic [31:0] src1;
        logic [31:0] src2;
        logic [31:0] rkd_value;

        logic gr_we;
        logic [ 4:0] dest;
        logic [ 2:0] inst_ld_en;
        logic [ 1:0] inst_st_en;
        logic inst_ll_w;
        logic inst_sc_w;

        logic csr_re;
        logic csr_we;
        logic [13:0] csr_num;
        logic inst_csrxchg;

        logic inst_valid_cacop;
        logic ertn_flush;

        logic ex;
        logic [ 8:0] excp_num;

        logic [ 1:0] op_timer_64;

        logic tlbsrch_en;
        logic tlbwr_en;
        logic tlbfill_en;
        logic tlbrd_en;
        logic invtlb_en;
        logic [ 4:0] invtlb_op;

        logic next_need_refetch;
        logic refetch_flush;

        // 指令位于前端的信息
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;   // FTQ块的索引
        logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
        logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

        // difftest
        `ifdef DIFFTEST_EN
        logic [31:0] diff_inst;
        logic        diff_cnt_inst;
        logic        diff_csr_rstat_en;
        `endif
    } ISS_EXE_bus_t;

    typedef struct packed {
        logic valid;
        logic [31:0] pc;
        logic [$clog2(ROB_DEPTH)-1:0] ROB_idx;

        logic gr_we;
        logic [ 4:0] dest;

        logic [31:0] rj_value;
        logic [31:0] rkd_value;
        logic [31:0] br_offs;
        logic [ 8:0] br_inst_sel;

        logic ertn_flush;

        logic ex;
        logic [ 8:0] excp_num;

        logic refetch_flush;

        // 指令位于前端的信息
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;   // FTQ块的索引
        logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
        logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

        // 指令具体执行信息
        branch_info_t branch_info;
        // difftest
        `ifdef DIFFTEST_EN
        logic [31:0] diff_inst;
        logic        diff_cnt_inst;
        logic        diff_csr_rstat_en;
        `endif
    } BU_bus_t;

    typedef struct packed {
        logic        data_sram_wr;      // 数据SRAM写使能
        logic [3:0]  data_sram_wstrb;   // 字节写使能
        logic [1:0]  data_sram_size;    // 访问大小(00:1B, 01:2B, 10:4B)
        logic [31:0] data_sram_wdata;   // 写数据
    } data_sram_bus_t;

    typedef struct packed {
        logic        res_from_mul;  // 结果来自乘法
        logic        mul_signed;    // 有符号乘法
        logic [31:0] mul_scr1;      // 乘法操作数1
        logic [31:0] mul_scr2;      // 乘法操作数2
    } mul_bus_t;

    typedef struct packed {
        logic        res_from_div;   // 结果来自除法
        logic        div_signed;     // 有符号除法
        logic [31:0] div_scr1;      // 除法操作数1
        logic [31:0] div_scr2;      // 除法操作数2
    } div_bus_t;

    typedef struct packed {
        logic        data_fetch;         // 数据请求
        logic [31:0] data_vaddr;         // 虚拟地址
        logic        data_addr_trans_en; // 地址翻译使能
        logic        dmw0_en;            // 直接映射窗口0使能
        logic        dmw1_en;            // 直接映射窗口1使能
    } addr_trans_bus_t;

    typedef struct packed {
        logic        invtlb_inst;    // 该信号表示ISS阶段传过来的指令是invtlb指令，但不表示这个指令一定执行
        logic        invtlb_en;      // 该信号表示EXE阶段的指令为invtlb指令，并且一定执行（高电平有效）
        logic [4:0]  invtlb_op;      // INVTLB操作类型
        logic [9:0]  invtlb_asid;    // ASID
        logic [18:0] invtlb_vpn;     // 虚拟页号
    } invtlb_bus_t;

    typedef struct packed {
        logic         icacop_op_en    ;
        logic         dcacop_op_en    ;
        logic [ 1:0]  cacop_op_mode   ;
        logic [31:0]  cacop_pa        ;
        logic         cacop_op_mode_di;
        logic         data_uncache_en ;
    } cache_bus_t;

    typedef struct packed {
        logic valid;
        logic [$clog2(ROB_DEPTH)-1:0] ROB_idx;

        logic [ 4:0] dest;
        logic gr_we;

        logic [31:0] src1;
        logic [31:0] src2;

        logic [31:0] alu_result;
        logic [31:0] paddr;
        logic [31:0] final_result;

        logic [ 2:0] inst_ld_en;
        logic        mem_we;
        logic inst_ll_w;
        logic inst_sc_w;

        logic sc_cancel_req;
        data_sram_bus_t data_sram_bus;

        logic csr_tlb_type;
        logic csr_we;
        logic [13:0] csr_num;
        logic inst_csrxchg;

        logic ertn_flush;

        logic ex;
        logic [15:0] excp_num;

        logic tlbsrch_en;
        logic tlbsrch_found;
        logic [2:0] tlbsrch_index;
        logic tlbwr_en;
        logic tlbfill_en;
        logic tlbrd_en;
        logic invtlb_en;
        logic [4:0] invtlb_op;

        logic refetch_flush;

        cache_bus_t cache_bus;

        // 指令位于前端的信息
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;   // FTQ块的索引
        logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
        logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

        // difftest
        `ifdef DIFFTEST_EN
        logic [63:0] diff_timer_64_rdata;
        logic [31:0] diff_inst;
        logic [ 7:0] diff_inst_ld_en;
        logic [ 7:0] diff_inst_st_en;
        logic        diff_cnt_inst;
        logic        diff_csr_rstat_en;
        logic [31:0] diff_csr_rdata;
        logic [31:0] diff_data_sram_wdata;
        `endif
    } EXE_REQ_bus_t;

    typedef struct packed {
        logic valid;
        logic [$clog2(ROB_DEPTH)-1:0] ROB_idx;

        logic [ 4:0] dest;
        logic gr_we;

        logic [31:0] mul_final_result;
        logic [ 2:0] div_op;

        logic ex;
        logic [15:0] excp_num;

        logic refetch_flush;

        // 指令位于前端的信息
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;   // FTQ块的索引
        logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
        logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

        // difftest
        `ifdef DIFFTEST_EN
        logic [63:0] diff_timer_64_rdata;
        logic [31:0] diff_inst;
        logic [ 7:0] diff_inst_ld_en;
        logic [ 7:0] diff_inst_st_en;
        logic        diff_cnt_inst;
        logic        diff_csr_rstat_en;
        logic [31:0] diff_csr_rdata;
        logic [31:0] diff_data_sram_wdata;
        `endif
    } FU3_bus_t;

    typedef struct packed {
        logic valid;
        logic [$clog2(ROB_DEPTH)-1:0] ROB_idx;

        logic [ 4:0] dest;
        logic gr_we;

        logic [31:0] alu_result;
        logic [31:0] paddr;
        logic [31:0] final_result;

        logic [ 2:0] inst_ld_en;
        logic        mem_we;
        logic inst_ll_w;
        logic inst_sc_w;

        logic data_uncache_en;

        logic csr_tlb_type;
        logic csr_we;
        logic [13:0] csr_num;
        logic [31:0] csr_wmask;
        logic [31:0] csr_wdata;

        logic ertn_flush;

        logic ex;
        logic [15:0] excp_num;

        logic tlbwr_en;
        logic tlbfill_en;
        logic tlbrd_en;

        logic refetch_flush;

        logic icacop_op_en;
        logic dcacop_op_en;

        // 指令位于前端的信息
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;   // FTQ块的索引
        logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
        logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

        // difftest
        `ifdef DIFFTEST_EN
        logic [63:0] diff_timer_64_rdata;
        logic [31:0] diff_inst;
        logic [ 7:0] diff_inst_ld_en;
        logic [ 7:0] diff_inst_st_en;
        logic        diff_cnt_inst;
        logic        diff_csr_rstat_en;
        logic [31:0] diff_csr_rdata;
        logic [31:0] diff_data_sram_wdata;
        `endif
    } REQ_MEM_bus_t;

    typedef struct packed {
        logic valid;
        logic [$clog2(ROB_DEPTH)-1:0] ROB_idx;

        logic [31:0] mem_addr;
        logic [31:0] paddr;

        logic gr_we;
        logic [ 4:0] dest;
        logic [31:0] final_result;

        logic inst_ll_w;
        logic inst_sc_w;

        logic data_uncache_en;

        logic csr_tlb_type;
        logic csr_we;
        logic [13:0] csr_num;
        logic [31:0] csr_wmask;
        logic [31:0] csr_wdata;

        logic ertn_flush;

        logic ex;
        logic [15:0] excp_num;

        logic tlbwr_en;
        logic tlbfill_en;
        logic tlbrd_en;

        logic refetch_flush;

        // 指令位于前端的信息
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;   // FTQ块的索引
        logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
        logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

        // difftest
        `ifdef DIFFTEST_EN
        logic [63:0] diff_timer_64_rdata;
        logic [31:0] diff_inst;
        logic [ 7:0] diff_inst_ld_en;
        logic [ 7:0] diff_inst_st_en;
        logic        diff_cnt_inst;
        logic        diff_csr_rstat_en;
        logic [31:0] diff_csr_rdata;
        logic [31:0] diff_data_sram_wdata;
        `endif
    } MEM_WB_bus_t;

    typedef struct packed {
        logic [5:0]   ecode;         // 异常主编码
        logic [31:0]  bad_vaddr;
        logic [8:0]   esubcode;      // 异常子编码
        logic         excp_tlbrefill; // 传给csr表示存在TLB重填例外
        logic         excp_tlb;       // 传给csr表示存在TLB相关例外
        logic [18: 0] excp_tlb_vppn;  // 传给csr表示触发TLB相关例外的vppn
    } excp_bus_t;

    typedef struct packed {
        logic [31:0] pc;       // 调试PC
        logic [3:0]  rf_we;    // 调试寄存器写使能
        logic [4:0]  rf_wnum;  // 调试寄存器编号
        logic [31:0] rf_wdata; // 调试寄存器数据
        logic [31:0] inst;   
    } commit_bus_t;

    typedef struct packed { // 32+32+1+1+=66
        logic complete;
        logic [ 4:0] Areg; // dest
        logic gr_we;
        logic [31:0] data; // final_result
        logic ex;
        logic [15:0] excp_num;

        logic        csr_tlb_type;

        logic inst_ll_w;
        logic inst_sc_w;

        logic [80:0] different_data; // 81

        logic csr_we;

        logic ertn_flush;

        logic data_uncache_en;

        logic refetch_flush;

        // 指令位于前端的信息
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;   // FTQ块的索引
        logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
        logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

        // 指令具体执行信息
        branch_info_t branch_info;

        // difftest
        `ifdef DIFFTEST_EN
        logic [63:0] diff_timer_64_rdata;
        logic [31:0] diff_inst;
        logic [ 7:0] diff_inst_ld_en;
        logic [ 7:0] diff_inst_st_en;
        logic        diff_cnt_inst;
        logic        diff_csr_rstat_en;
        logic [31:0] diff_csr_rdata;
        logic [31:0] diff_data_sram_wdata;
        `endif
    } ROB_t;

    typedef struct packed {
        logic [13:0] csr_num;
    } csr_buffer_t;

    parameter ALU_TYPE = 4'b0000;
    parameter MUL_TYPE = 4'b0001;
    parameter DIV_TYPE = 4'b0010;
    parameter BRANCH_TYPE = 4'b0011;
    parameter LOAD_TYPE = 4'b0100;
    parameter STORE_TYPE = 4'b0101;
    parameter CSR_TYPE = 4'b0110;

    parameter ADD  = 4'b0000;
    parameter SUB  = 4'b0001;
    parameter SLT  = 4'b0010;
    parameter SLTU = 4'b0011;
    parameter AND  = 4'b0100;
    parameter NOR  = 4'b0101;
    parameter OR   = 4'b0110;
    parameter XOR  = 4'b0111;
    parameter SLL  = 4'b1000;
    parameter SRL  = 4'b1001;
    parameter SRA  = 4'b1010;
    parameter LUI  = 4'b1011;

    parameter LD_B  = 3'b001;
    parameter LD_BU = 3'b010;
    parameter LD_H  = 3'b011;
    parameter LD_HU = 3'b100;
    parameter LD_W  = 3'b101;
    parameter LL_W  = 3'b110;

    parameter ST_B  = 2'b01;
    parameter ST_H  = 2'b10;
    parameter ST_W  = 2'b11;

// 用来数据压缩
    typedef struct packed { // 171
        logic valid;
        logic [31:0] pc;
        logic [31:0] inst; // difftest
        logic [$clog2(ROB_DEPTH)-1:0] ROB_idx;

        logic [ 4:0] rf_raddr1;
        logic [ 4:0] rf_raddr2;
        logic        rf_raddr1_valid; // 表示指令是否会用到源寄存器1
        logic        rf_raddr2_valid; // 表示指令是否会用到源寄存器2
        PRF_t        rprf1;
        PRF_t        rprf2;

        logic [ 3:0] alu_op;
        logic [ 2:0] mul_op;
        logic [ 2:0] div_op;

        logic src1_is_pc;
        logic src2_is_imm;

        logic gr_we;
        logic [ 4:0] dest;
        logic [31:0] imm;

        logic ex;
        logic [7:0] excp_num;
    } alu_type_t;

    typedef struct packed { // 219
        logic valid;
        logic [31:0] pc;
        logic [31:0] inst; // difftest
        logic [$clog2(ROB_DEPTH)-1:0] ROB_idx;

        logic [ 4:0] rf_raddr1;
        logic [ 4:0] rf_raddr2;
        logic        rf_raddr1_valid; // 表示指令是否会用到源寄存器1
        logic        rf_raddr2_valid; // 表示指令是否会用到源寄存器2
        PRF_t        rprf1;
        PRF_t        rprf2;

        logic        alu_op_0;
        logic [31:0] br_offs;

        logic src1_is_pc;
        logic src2_is_imm;

        logic gr_we;
        logic [ 4:0] dest;
        logic [31:0] imm;

        logic ex;
        logic [7:0] excp_num;

        logic [ 8:0] br_inst_sel; // br_inst_sel = {inst_beq, inst_bne, inst_blt, inst_bltu, inst_bge, inst_bgeu, inst_jirl, inst_bl, inst_b}
        // 指令位于前端的信息
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;   // FTQ块的索引
        logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
        logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）
        // 指令具体执行信息
        branch_info_t branch_info;
    } branch_type_t;

    typedef struct packed {
        logic valid;
        logic [31:0] pc;
        logic [31:0] inst;
        logic [$clog2(ROB_DEPTH)-1:0] ROB_idx;

        logic [ 4:0] rf_raddr1;
        logic [ 4:0] rf_raddr2;
        logic        rf_raddr1_valid; // 表示指令是否会用到源寄存器1
        logic        rf_raddr2_valid; // 表示指令是否会用到源寄存器2
        PRF_t        rprf1;
        PRF_t        rprf2;

        logic [ 3:0] alu_op;

        logic [ 2:0] inst_ld_en;
        logic [ 1:0] inst_st_en;

        logic src1_is_pc;
        logic src2_is_imm;

        logic gr_we;
        logic [ 4:0] dest;
        logic [31:0] imm;

        logic ex;
        logic [7:0] excp_num;

        logic inst_ll_w;
        logic inst_sc_w;
    } load_type_t;

    typedef struct packed { // 14+32+32+3 = 81
        logic [13:0] csr_num;
        logic [31:0] csr_wmask;
        logic [31:0] csr_wdata;
        logic tlbwr_en;
        logic tlbfill_en;
        logic tlbrd_en;
    } csr_tlb_data_t;

endpackage
`endif