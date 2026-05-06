`include "../top/cpu_defs.vh"

// ============================================================
// MEMport：访存级。完成 load/store 数据整形与写回选择，并向后级透传控制/异常元信息。
// - load：等待 data_r_complete，命中后由内部完成标记维持 readyGo，确保本槽位正确出队；
// - store：等待 data_w_complete；
// - 非访存：组合直通。
// 典型握手链路：data_*_complete -> readyGo -> allowIn。
// ============================================================
module MEMport (
    // input
    // 基本控制
    input  wire                    clk,
    input  wire                    reset,
    input  wire                    valid,                 // MEM 槽有效
    input  wire                    slot_tag_in,           // 由 EXE/MEM 锁存下来的槽位标签：标识“当前 MEM 槽”对应的那次访存事务；用于与 data_r_complete/data_w_complete 完成脉冲做同槽配对，避免把其他事务的返回误记到本槽位

    // EXE 结果与访存相关输入
    input  wire [31:0]             data_sram_rdata,       // load 读回数据
    input  wire [31:0]             exe_result,            // EXE 计算结果/访存地址
    input  wire [31:0]             pc_in,
    input  wire [ 4:0]             wb_reg_addr_in,
    input  wire [`MEM_OP_NUM-1:0]  mem_op,
    input  wire                    wb_op_in,
    input  wire [31:0]             mem_wdata_in,
    input  wire [31:0]             data_raddr_from_EXE,
    input  wire [31:0]             data_waddr_from_EXE,
    input  wire                    data_w_complete,       // store 完成脉冲
    input  wire                    data_r_complete,       // load 完成脉冲

    // CSR/TLB 控制透传输入
    input  wire [`CSR_OP_NUM-1:0]  csr_op_in,
    input  wire [11:0]             csr_num_in,
    input  wire [31:0]             csr_wmask_in,
    input  wire [31:0]             csr_wvalue_in,
    input  wire [`WB_SRC_NUM-1:0]  wb_src_op_in,
    input  wire [`TLB_OP_NUM-1:0]  tlb_op_in,
    input  wire [9:0]              invtlb_asid_in,
    input  wire [18:0]             invtlb_vpn_in,

    // cache 维护与 refetch 输入
    input  wire [`CACHE_OP_NUM-1:0] cache_op_valid_in,
    input  wire [1:0]              cache_cacop_op_in,
    input  wire [31:0]             cache_cacop_addr_in,
    input  wire [1:0]              cache_cacop_mat_in,
    input  wire [4:0]              cache_cacop_cd_in,
    input  wire                    refetch_tag_in,

    // 异常元信息输入
    input  wire                    ertn_op_in,
    input  wire                    sys_valid_in,
    input  wire                    brk_valid_in,
    input  wire                    ine_valid_in,
    input  wire                    adef_valid_in,
    input  wire                    int_valid_in,
    input  wire                    ale_valid_in,
    input  wire                    exception_valid_in,
    input  wire [31:0]             if_vaddr_in,
    input  wire [31:0]             ale_vaddr_in,
    input  wire [`TLB_EX_NUM-1:0]  tlb_ex_valid_in,
    input  wire [31:0]             tlb_vaddr_in,


    // output
    // 与流水握手
    output wire                    readyGo,
    output wire                    allowIn,
    output wire                    load_pending_for_hazard, // 暴露给 hazard 的 load 未完成状态

    // 写回主通路输出
    output wire [31:0]             wb_wdata,
    output wire [31:0]             pc_out,
    output wire [ 4:0]             wb_reg_addr_out,
    output wire                    wb_op_out,

    // 透传到后级的 CSR/TLB 控制
    output wire [`CSR_OP_NUM-1:0]  csr_op_out,
    output wire [11:0]             csr_num_out,
    output wire [31:0]             csr_wmask_out,
    output wire [31:0]             csr_wvalue_out,
    output wire [`WB_SRC_NUM-1:0]  wb_src_op_out,
    output wire [`TLB_OP_NUM-1:0]  tlb_op_out,
    output wire [9:0]              invtlb_asid_out,
    output wire [18:0]             invtlb_vpn_out,

    // 异常元信息输出
    output wire                    ertn_op_out,
    output wire                    sys_valid_out,
    output wire                    brk_valid_out,
    output wire                    ine_valid_out,
    output wire                    adef_valid_out,
    output wire                    ale_valid_out,
    output wire                    int_valid_out,
    output wire                    exception_valid_out,
    output wire [31:0]             if_vaddr_out,
    output wire [31:0]             ale_vaddr_out,
    output wire [`TLB_EX_NUM-1:0]  tlb_ex_valid_out,
    output wire [31:0]             tlb_vaddr_out,

    // cache 维护与 refetch 透传
    output wire [`CACHE_OP_NUM-1:0] cache_op_valid_out,
    output wire [1:0]              cache_cacop_op_out,
    output wire [31:0]             cache_cacop_addr_out,
    output wire [1:0]              cache_cacop_mat_out,
    output wire [4:0]              cache_cacop_cd_out,
    output wire                    refetch_tag_out
);

    // 仅「纯重取泡」（refetch 且无 TLB 且无 GPR 写意图）抑制 MEM；真实 load/store（wb_op）须发起访存。
    // 勿用 |tlb_op_in：任一位为 X 时 ~(|vec) 为 X，会使 mem_valid 与 wb_wdata 条件为 X。
    wire any_tlb_op_bus = (tlb_op_in[0] === 1'b1) | (tlb_op_in[1] === 1'b1) | (tlb_op_in[2] === 1'b1)
                        | (tlb_op_in[3] === 1'b1) | (tlb_op_in[4] === 1'b1) | (tlb_op_in[5] === 1'b1)
                        | (tlb_op_in[6] === 1'b1) | (tlb_op_in[7] === 1'b1) | (tlb_op_in[8] === 1'b1)
                        | (tlb_op_in[9] === 1'b1) | (tlb_op_in[10] === 1'b1);
    wire no_mem_op_bus = (mem_op === {`MEM_OP_NUM{1'b0}});
    wire refetch_squash_mem = (refetch_tag_in === 1'b1) && (!any_tlb_op_bus) && (wb_op_in === 1'b0)
                           && no_mem_op_bus
                           && !((tlb_ex_valid_in[0] === 1'b1) | (tlb_ex_valid_in[1] === 1'b1) | (tlb_ex_valid_in[2] === 1'b1)
                             |  (tlb_ex_valid_in[3] === 1'b1) | (tlb_ex_valid_in[4] === 1'b1) | (tlb_ex_valid_in[5] === 1'b1));
    wire   mem_valid = (valid === 1'b1) && !refetch_squash_mem;
    wire   bram_re;
    wire   bram_we;
    
    // 勿用 |tlb_ex_valid_in：任一位为 X 时归约或结果为 X，会经 exception_valid_w 把 wb_wdata 污染成 X。
    wire tlb_ex_any = (tlb_ex_valid_in[0] === 1'b1) | (tlb_ex_valid_in[1] === 1'b1) | (tlb_ex_valid_in[2] === 1'b1)
                    | (tlb_ex_valid_in[3] === 1'b1) | (tlb_ex_valid_in[4] === 1'b1) | (tlb_ex_valid_in[5] === 1'b1);
    wire   tlb_exception_valid_w = tlb_ex_any;
    wire   exception_valid_w;
    assign exception_valid_w = (exception_valid_in === 1'b1) | tlb_exception_valid_w;
    
    wire mem_bypass_bram = (exception_valid_w === 1'b1) || (mem_valid !== 1'b1);
    wire want_ld_w = (mem_op[`MEM_OP_LD_W] === 1'b1);
    wire want_ld_h = (mem_op[`MEM_OP_LD_H] === 1'b1);
    wire want_ld_b = (mem_op[`MEM_OP_LD_B] === 1'b1);
    wire want_ld_hu = (mem_op[`MEM_OP_LD_HU] === 1'b1);
    wire want_ld_bu = (mem_op[`MEM_OP_LD_BU] === 1'b1);
    wire want_st_w = (mem_op[`MEM_OP_ST_W] === 1'b1);
    wire want_st_h = (mem_op[`MEM_OP_ST_H] === 1'b1);
    wire want_st_b = (mem_op[`MEM_OP_ST_B] === 1'b1);
    assign bram_re = mem_bypass_bram ? 1'b0 : (want_ld_w | want_ld_h | want_ld_b | want_ld_hu | want_ld_bu);
    assign bram_we = mem_bypass_bram ? 1'b0 : (want_st_w | want_st_h | want_st_b);
    
    wire [31:0] r_word_addr   = {data_raddr_from_EXE[31:2], 2'b00};
    wire [31:0] w_word_addr   = {data_waddr_from_EXE[31:2], 2'b00};
    wire [ 1:0] load_addr_off = data_raddr_from_EXE[1:0];
    
    reg [31:0] load_rdata_hold;
    always @(posedge clk) begin
        if (reset || !bram_re)
            load_rdata_hold <= 32'b0;
        else if (data_r_complete)
            load_rdata_hold <= data_sram_rdata;
    end
    
    wire [31:0] load_wdata_raw = data_r_complete ? data_sram_rdata : load_rdata_hold;
    
    wire [ 7:0] r_byte_data;
    wire [15:0] r_half_data;
    wire [31:0] r_word_data;
    
    assign r_byte_data = (load_addr_off == 2'b00) ? load_wdata_raw[7:0] :
                         (load_addr_off == 2'b01) ? load_wdata_raw[15:8] :
                         (load_addr_off == 2'b10) ? load_wdata_raw[23:16] :
                         load_wdata_raw[31:24];
    
    assign r_half_data = (load_addr_off == 2'b00) ? load_wdata_raw[15:0] :
                         (load_addr_off == 2'b10) ? load_wdata_raw[31:16] :
                         16'b0;
    
    assign r_word_data = load_wdata_raw;
    
    wire [31:0] load_result;
    
    assign load_result = want_ld_b  ? {{24{r_byte_data[7]}}, r_byte_data[7:0]} :
                         want_ld_h  ? {{16{r_half_data[15]}}, r_half_data[15:0]} :
                         want_ld_bu ? {24'b0, r_byte_data[7:0]} :
                         want_ld_hu ? {16'b0, r_half_data[15:0]} :
                         want_ld_w  ? r_word_data :
                                      32'b0;
    
    wire load_done_match = 1'b0;
    
    // For memory operations, MEM must wait for cache completion.
    // - load: wait for data_r_complete (or held load_done_match)
    // - store: wait for data_w_complete
    assign readyGo = bram_re ? data_r_complete
                   : bram_we ? data_w_complete
                   : 1'b1;
    assign allowIn = readyGo;
    assign load_pending_for_hazard = mem_valid & bram_re & ~data_r_complete;
    
    wire memport_in_lint = data_w_complete | (|mem_wdata_in) | (|data_waddr_from_EXE)
                          | bram_we | (|r_word_addr) | (|w_word_addr);
    wire mem_commit_wdata = (exception_valid_w !== 1'b1) && (mem_valid === 1'b1);
    assign wb_wdata        = mem_commit_wdata ? ((bram_re ? load_result : exe_result)
                                     ^ ({32{memport_in_lint}} ^ {32{memport_in_lint}})) : 32'b0;
    assign pc_out          = valid ? pc_in : 32'b0;
    assign wb_reg_addr_out = mem_commit_wdata ? wb_reg_addr_in : 5'b0;
    assign wb_op_out       = mem_commit_wdata ? wb_op_in : 1'b0;
    
    assign csr_op_out = mem_valid ? csr_op_in : {`CSR_OP_NUM{1'b0}};
    assign csr_num_out = mem_valid ? csr_num_in : 12'b0;
    assign csr_wmask_out = mem_valid ? csr_wmask_in : 32'b0;
    assign csr_wvalue_out = mem_valid ? csr_wvalue_in : 32'b0;
    assign wb_src_op_out = mem_valid ? wb_src_op_in : {`WB_SRC_NUM{1'b0}};
    
    assign ertn_op_out = mem_valid ? ertn_op_in : 1'b0;
    assign sys_valid_out = mem_valid ? sys_valid_in : 1'b0;
    assign brk_valid_out = mem_valid ? brk_valid_in : 1'b0;
    assign ine_valid_out = mem_valid ? ine_valid_in : 1'b0;
    assign adef_valid_out = mem_valid ? adef_valid_in : 1'b0;
    assign ale_valid_out = mem_valid ? ale_valid_in : 1'b0;
    assign int_valid_out = mem_valid ? int_valid_in : 1'b0;
    assign exception_valid_out = mem_valid ? exception_valid_w : 1'b0;
    assign if_vaddr_out = mem_valid && adef_valid_in ? if_vaddr_in : 32'b0;
    assign ale_vaddr_out = mem_valid && ale_valid_in ? ale_vaddr_in : 32'b0;
    
    assign tlb_op_out = mem_valid ? tlb_op_in : {`TLB_OP_NUM{1'b0}};
    assign invtlb_asid_out = mem_valid ? invtlb_asid_in : 10'b0;
    assign invtlb_vpn_out = mem_valid ? invtlb_vpn_in : 19'b0;
    assign tlb_ex_valid_out = mem_valid ? tlb_ex_valid_in : {`TLB_EX_NUM{1'b0}};
    assign tlb_vaddr_out = mem_valid && tlb_ex_any ? tlb_vaddr_in : 32'b0;
    
    assign cache_op_valid_out = valid ? cache_op_valid_in : {`CACHE_OP_NUM{1'b0}};
    assign cache_cacop_op_out = valid ? cache_cacop_op_in : 2'b0;
    assign cache_cacop_addr_out = valid ? cache_cacop_addr_in : 32'b0;
    assign cache_cacop_mat_out = valid ? cache_cacop_mat_in : 2'b0;
    assign cache_cacop_cd_out = valid ? cache_cacop_cd_in : 5'b0;
    assign refetch_tag_out = valid ? refetch_tag_in : 1'b0;


endmodule
