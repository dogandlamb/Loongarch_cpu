`include "../top/cpu_defs.vh"

// ============================================================
// EXEport：执行级。例化 ALU，完成执行结果与访存地址/写掩码生成，并向后级透传控制元信息。
// - 组合产生：br_taken、访存请求(data_re/data_we)、访存地址与字节使能、异常补充信息(ALE)。
// - 时序相关：仅 mul/div 等多周期 ALU 路径会影响 readyGo（由 alu_result_valid 驱动）。
// ============================================================
module EXEport (
    // input
    // 基本控制
    input wire                     clk,                    // ALU mul/div 时序使用
    input wire                     reset,                  // ALU mul/div 时序复位
    input wire                     valid,                  // EXE 槽有效
    input wire                     stall,                  // 由上游插泡控制

    // 译码/执行主数据与控制
    input wire  [ 4:0]             wb_reg_addr,
    input wire  [31:0]             alu_src1,
    input wire  [31:0]             alu_src2,
    input wire  [31:0]             pc_in,
    input wire  [31:0]             br_imm,
    input wire  [`ALU_OP_NUM-1:0]  alu_op,
    input wire  [`BR_OP_NUM-1:0]   br_op,
    input wire  [31:0]             mem_wdata_in,          // store 写数据
    input wire  [`MEM_OP_NUM-1:0]  mem_op_in,
    input wire                     wb_op_in,
    input wire  [`WB_SRC_NUM-1:0]  wb_src_op_in,          // 写回数据来源选择

    // CSR/TLB 维护控制
    input wire  [`CSR_OP_NUM-1:0]  csr_op_in,
    input wire  [11:0]             csr_num_in,
    input wire  [31:0]             csr_wmask_in,
    input wire  [31:0]             csr_wvalue_in,
    input wire  [31:0]             csr_rvalue_from_csr,
    input wire  [31:0]             csr_tid_from_csr,      // CSR 输出的 tid 值
    input wire  [`TLB_OP_NUM-1:0]  tlb_op_in,
    input wire  [9:0]              invtlb_asid_in,
    input wire  [18:0]             invtlb_vpn_in,

    // cache 维护与 refetch 标记
    input wire  [`CACHE_OP_NUM-1:0] cache_op_valid_in,
    input wire  [1:0]              cache_cacop_op_in,
    input wire  [31:0]             cache_cacop_addr_in,
    input wire  [1:0]              cache_cacop_mat_in,
    input wire  [4:0]              cache_cacop_cd_in,
    input wire                     refetch_tag_in,

    // 异常元信息输入
    input wire                     ertn_op_in,
    input wire                     sys_valid_in,
    input wire                     brk_valid_in,
    input wire                     ine_valid_in,
    input wire                     adef_valid_in,         // 来自 ID_EXE_reg 的 ADEF
    input wire                     int_valid_in,          // 来自 ID_EXE_reg 的中断有效
    input wire                     exception_valid_in,    // 来自 ID_EXE_reg 的异常总有效
    input wire  [31:0]             if_vaddr_in,           // 来自 IF 异常链的虚地址
    input wire  [`TLB_EX_NUM-1:0]  tlb_ex_valid_in,
    input wire  [31:0]             tlb_vaddr_in,


    // output
    // 与流水握手
    output wire                    readyGo,
    output wire                    allowIn,

    // EXE 结果与分支信息
    output wire                    br_taken,
    output wire [31:0]             exe_alu_or_addr_or_cnt,// ALU/地址/计数结果共享通路
    output wire [31:0]             pc_out,
    output wire [ 4:0]             wb_reg_addr_out,
    output wire [`MEM_OP_NUM-1:0]  mem_op,
    output wire [31:0]             mem_wdata_out,
    output wire                    wb_op,

    // 发往 dcache/mmu 的访存请求
    output wire                    data_we_from_EXE,
    output wire                    data_re_from_EXE,
    output wire [31:0]             data_raddr_from_EXE,
    output wire [31:0]             data_waddr_from_EXE,
    output wire [31:0]             data_wdata_from_EXE,
    output wire [ 3:0]             data_wbyte_en_from_EXE,

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
    output wire                    adef_valid_out,        // 送 MEM 的 ADEF
    output wire                    ale_valid_out,         // EXE 新生成的 ALE（地址非对齐）
    output wire                    int_valid_out,
    output wire                    exception_valid_out,
    output wire [31:0]             if_vaddr_out,          // 送 MEM 的 IF 异常虚地址
    output wire [31:0]             ale_vaddr_out,         // ALE 对应虚地址
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

    wire [31:0] alu_result_w;           // ALU 组合结果
    wire        alu_result_valid_w;     // 多周期指令完成
    wire        br_taken_w;             // 组合分支条件满足
    wire [31:0] br_target_w;            // EXE 级分支目标
    wire [31:0] seq_target_w;           // EXE 级顺序目标（pc+4）
    wire        br_to_seq_w;            // 分支目标与顺序目标相同（无需重定向）
    wire [31:0] link_pc4_w;             // jirl/bl 链路：pc+4

    wire [ 7:0] w_byte_data;            // 写一个字节的数据
    wire [15:0] w_half_data;
    wire [31:0] w_word_data;
    wire [31:0] wdata_2bram;            // 对齐到字宽后的写数据

    // 仅纯重取泡（refetch + 无 TLB + 无 wb）在 EXE 视为无效；带 wb 的 load/ALU 仍须发 data_re/ALU。
    wire any_tlb_op_exe = (tlb_op_in[0] === 1'b1) | (tlb_op_in[1] === 1'b1) | (tlb_op_in[2] === 1'b1)
                        | (tlb_op_in[3] === 1'b1) | (tlb_op_in[4] === 1'b1) | (tlb_op_in[5] === 1'b1)
                        | (tlb_op_in[6] === 1'b1) | (tlb_op_in[7] === 1'b1) | (tlb_op_in[8] === 1'b1)
                        | (tlb_op_in[9] === 1'b1) | (tlb_op_in[10] === 1'b1);
    wire no_mem_op_exe = (mem_op_in === {`MEM_OP_NUM{1'b0}});
    wire refetch_squash_exe = (refetch_tag_in === 1'b1) && (!any_tlb_op_exe)
                           && (wb_op_in === 1'b0) && no_mem_op_exe;
    wire ex_valid = (valid === 1'b1) && !refetch_squash_exe;
    wire addr_error;
    wire int_valid_w;
    wire exception_valid_w;

    wire [63:0] cnt_full;

    clk_count64bit u_clk_count64bit(
        .clk             (clk),
        .reset           (reset),
        .clk_count_64    (cnt_full)
    );

    wire [31:0] cnt_low = cnt_full[31:0];
    wire [31:0] cnt_high = cnt_full[63:32];


    assign addr_error = (mem_op_in[`MEM_OP_LD_H] || mem_op_in[`MEM_OP_ST_H] || mem_op_in[`MEM_OP_LD_HU]) && (alu_result_w[0] != 1'b0)
                       || (mem_op_in[`MEM_OP_LD_W] || mem_op_in[`MEM_OP_ST_W]) && (alu_result_w[1:0] != 2'b00);

    assign int_valid_w = (int_valid_in === 1'b1);
    assign exception_valid_w = (exception_valid_in === 1'b1) || ((addr_error === 1'b1) && (valid === 1'b1));

    assign w_byte_data = mem_wdata_in[7:0];
    assign w_half_data = mem_wdata_in[15:0];
    assign w_word_data = mem_wdata_in;

    assign wdata_2bram = mem_op_in[`MEM_OP_ST_B] ? {4{w_byte_data}} :
                         mem_op_in[`MEM_OP_ST_H] ? {2{w_half_data}} :
                         mem_op_in[`MEM_OP_ST_W] ? w_word_data : 32'b0;



    alu u_alu(
        .clk             (clk         ),
        .reset           (reset       ),
        .alu_op     	 (alu_op      ),
        .alu_src1   	 (alu_src1    ),
        .alu_src2   	 (alu_src2    ),
        .alu_result 	 (alu_result_w),
        .alu_result_valid(alu_result_valid_w)
    );


    assign br_taken_w = (((br_op[`BR_OP_BEQ]  == 1'b1) && (alu_src1 == alu_src2))
                      || ((br_op[`BR_OP_BNE]  == 1'b1) && (alu_src1 != alu_src2))
                      || ((br_op[`BR_OP_BLT]  == 1'b1) && ($signed(alu_src1) < $signed(alu_src2)))
                      || ((br_op[`BR_OP_BGE]  == 1'b1) && ($signed(alu_src1) >= $signed(alu_src2)))
                      || ((br_op[`BR_OP_BLTU] == 1'b1) && (alu_src1 < alu_src2))
                      || ((br_op[`BR_OP_BGEU] == 1'b1) && (alu_src1 >= alu_src2))
                      ||  (br_op[`BR_OP_JIRL] == 1'b1)
                      ||  (br_op[`BR_OP_BL]   == 1'b1)
                      ||  (br_op[`BR_OP_B]    == 1'b1));

    assign seq_target_w = pc_in + 32'd4;
    assign br_target_w  = br_op[`BR_OP_JIRL] ? (alu_src1 + br_imm) : (pc_in + br_imm);
    assign br_to_seq_w  = (br_target_w == seq_target_w);

    assign readyGo       = !valid || alu_result_valid_w || ~(|alu_op);
    /** 
    * readyGo 赋值解释：
    *(1) !valid：本级无有效槽 → 不必等 ALU，当作「可推进」。
    *(2) alu_result_valid_w：多周期 ALU（乘除）完成。
    *(3) ~(|alu_op)：alu_op 全 0 → 无 ALU 操作（例如纯分支/泡）→ 不需要等 ALU。
    */
    assign allowIn       = 1'b1;

    assign br_taken        = valid && !stall && br_taken_w && !br_to_seq_w;
    assign link_pc4_w      = pc_in + 32'd4;

    // ex_valid/stall 用 !== / ===，避免 valid 或 stall 为 X 时 `!ex_valid`/`stall?` 把整链污染成 X。
    // stall 拍勿把 CSR/CNT/TID 读回数据打成 0：否则握手当下若仍 stall，MEM/WB 会锁存错误写回（如 csrrd ERA=0）。
    assign  exe_alu_or_addr_or_cnt = (ex_valid !== 1'b1) ? 32'b0 :
                                    (stall === 1'b1) ? (
                                        ((br_op[`BR_OP_JIRL] === 1'b1) || (br_op[`BR_OP_BL] === 1'b1)) ? link_pc4_w :
                                        (wb_src_op_in[`WB_SRC_CSR] === 1'b1)   ? csr_rvalue_from_csr :
                                        (wb_src_op_in[`WB_SRC_CNTVL] === 1'b1) ? cnt_low :
                                        (wb_src_op_in[`WB_SRC_CNTVH] === 1'b1) ? cnt_high :
                                        (wb_src_op_in[`WB_SRC_TID] === 1'b1)   ? csr_tid_from_csr :
                                        32'b0
                                    ) :
                                    ((br_op[`BR_OP_JIRL] === 1'b1) || (br_op[`BR_OP_BL] === 1'b1)) ? link_pc4_w :
                                    (wb_src_op_in[`WB_SRC_CSR] === 1'b1)   ? csr_rvalue_from_csr :
                                    (wb_src_op_in[`WB_SRC_CNTVL] === 1'b1) ? cnt_low :
                                    (wb_src_op_in[`WB_SRC_CNTVH] === 1'b1) ? cnt_high :
                                    (wb_src_op_in[`WB_SRC_TID] === 1'b1)   ? csr_tid_from_csr :
                                    (alu_result_valid_w === 1'b1)          ? alu_result_w : 32'b0;

    assign  pc_out          = valid ? !stall ? pc_in : 32'b0 : 32'b0;
    assign  wb_reg_addr_out = valid && !exception_valid_w ? !stall ? wb_reg_addr : 5'b0 : 5'b0;
    assign  mem_op          = valid && !exception_valid_w ? !stall ? mem_op_in : {`MEM_OP_NUM{1'b0}} : {`MEM_OP_NUM{1'b0}};
    assign  mem_wdata_out   = valid && !exception_valid_w ? !stall ? mem_wdata_in : 32'b0 : 32'b0;
    assign  wb_op           = valid && !exception_valid_w ? !stall ? wb_op_in : 1'b0 : 1'b0;

    assign data_we_from_EXE = (ex_valid && !exception_valid_w) ? 
                            (!stall ? (mem_op[`MEM_OP_ST_W] | mem_op[`MEM_OP_ST_B] | mem_op[`MEM_OP_ST_H]) : 1'b0 )
                            : 1'b0;
    assign data_re_from_EXE = (ex_valid && !exception_valid_w) ? 
                            (!stall ? (mem_op[`MEM_OP_LD_W] | mem_op[`MEM_OP_LD_H] | mem_op[`MEM_OP_LD_B] | mem_op[`MEM_OP_LD_HU] | mem_op[`MEM_OP_LD_BU]) : 1'b0 )
                            : 1'b0;


    assign data_raddr_from_EXE = (ex_valid && !exception_valid_w) ?
                                (!stall ? alu_result_w : 32'b0)
                                : 32'b0;
    assign data_waddr_from_EXE = (ex_valid && !exception_valid_w) ?
                                (!stall ? alu_result_w : 32'b0)
                                 : 32'b0;
    assign data_wdata_from_EXE = (ex_valid && !exception_valid_w) ? 
                                (!stall ? wdata_2bram : 32'b0) 
                                : 32'b0;

    assign data_wbyte_en_from_EXE = (ex_valid && !exception_valid_w) ? (!stall ? ((mem_op[`MEM_OP_ST_W]) ? 4'b1111 :
                                        (mem_op[`MEM_OP_ST_H]) ? ((alu_result_w[1] ? 4'b1100 : 4'b0011)) :
                                        (mem_op[`MEM_OP_ST_B]) ? (4'b0001 << alu_result_w[1:0]) : 4'b0000) : 4'b0000) : 4'b0000;

    assign csr_op_out = ex_valid ? (!stall ? csr_op_in : {`CSR_OP_NUM{1'b0}}) : {`CSR_OP_NUM{1'b0}};
    assign csr_num_out = ex_valid ? !stall ? csr_num_in : 12'b0 : 12'b0;
    assign csr_wmask_out = ex_valid ? !stall ? csr_wmask_in : 32'b0 : 32'b0;
    assign csr_wvalue_out = ex_valid ? !stall ? csr_wvalue_in : 32'b0 : 32'b0;
    assign wb_src_op_out = ex_valid ? !stall ? wb_src_op_in : {`WB_SRC_NUM{1'b0}} : {`WB_SRC_NUM{1'b0}};

    assign ertn_op_out = ex_valid ? !stall ? ertn_op_in : 1'b0 : 1'b0;
    assign sys_valid_out = ex_valid ? !stall ? sys_valid_in : 1'b0 : 1'b0;
    assign brk_valid_out = ex_valid ? !stall ? brk_valid_in : 1'b0 : 1'b0;
    assign ine_valid_out = ex_valid ? !stall ? ine_valid_in : 1'b0 : 1'b0;
    assign adef_valid_out = ex_valid ? !stall ? adef_valid_in : 1'b0 : 1'b0;
    assign int_valid_out = ex_valid ? !stall ? int_valid_in : 1'b0 : 1'b0;
    assign ale_valid_out = ex_valid ? !stall ? addr_error : 1'b0 : 1'b0;
    assign exception_valid_out = ex_valid ? !stall ? exception_valid_w : 1'b0 : 1'b0;
    assign if_vaddr_out = ex_valid && adef_valid_in ? !stall ? if_vaddr_in : 32'b0 : 32'b0;
    assign ale_vaddr_out = ex_valid && ale_valid_out ? (!stall ? alu_result_w : 32'b0) : 32'b0;

    assign tlb_op_out = ex_valid ? !stall ? tlb_op_in : {`TLB_OP_NUM{1'b0}} : {`TLB_OP_NUM{1'b0}};
    assign invtlb_asid_out = ex_valid ? !stall ? invtlb_asid_in : 10'b0 : 10'b0;
    assign invtlb_vpn_out = ex_valid ? !stall ? invtlb_vpn_in : 19'b0 : 19'b0;
    assign tlb_ex_valid_out = ex_valid ? !stall ? tlb_ex_valid_in : {`TLB_EX_NUM{1'b0}} : {`TLB_EX_NUM{1'b0}};
    wire tlb_ex_any_exe = (tlb_ex_valid_in[0] === 1'b1) | (tlb_ex_valid_in[1] === 1'b1) | (tlb_ex_valid_in[2] === 1'b1)
                        | (tlb_ex_valid_in[3] === 1'b1) | (tlb_ex_valid_in[4] === 1'b1) | (tlb_ex_valid_in[5] === 1'b1);
    assign tlb_vaddr_out = ex_valid && tlb_ex_any_exe ? (!stall ? tlb_vaddr_in : 32'b0) : 32'b0;

    // cache op 元信息在 stall 拍必须保持，否则会把 CACOP/IBAR 指令“消隐”为普通泡，
    // 导致 icache 失效/重取缺失（自修改代码场景会直接跑到旧指令）。
    assign cache_op_valid_out = valid ? cache_op_valid_in : {`CACHE_OP_NUM{1'b0}};
    assign cache_cacop_op_out = valid ? cache_cacop_op_in : 2'b0;
    assign cache_cacop_addr_out = valid ? cache_cacop_addr_in : 32'b0;
    assign cache_cacop_mat_out = valid ? cache_cacop_mat_in : 2'b0;
    assign cache_cacop_cd_out = valid ? cache_cacop_cd_in : 5'b0;
    // refetch 标记必须随槽保持，勿在 stall 拍清零：否则 EXE_MEM 若在边沿采样会丢失重取属性，
    // 导致下游误把“重取泡”或应抑制提交的指令当成普通提交（或与 debug 门控不一致）。
    assign refetch_tag_out = valid ? refetch_tag_in : 1'b0;




endmodule
