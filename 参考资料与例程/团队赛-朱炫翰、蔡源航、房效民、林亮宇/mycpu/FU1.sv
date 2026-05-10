`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module FU1
    import pipeline_types::*;
    import core_defines::*;
(
    //输入时钟和复位
    input  logic    clk ,
    input  logic    reset,
    //================================ 流水线握手信号 ================================
    input  logic    WB_allow_in,             //WB阶段可以输入
    output logic    FU_allow_in,             //EXE阶段可以输入
    //================================ 流水线间通信总线 ================================
    output ROB_t         FU_WB_bus,   //送至WB阶段信号
    input  ISS_EXE_bus_t data_i,
    //================================ 执行阶段（结束时）的写ROB端口 ================================
    output logic                            complete_en,
    output logic [$clog2(ROB_DEPTH)-1:0]    complete_addr,
    //================================ 前递暂停信号 ================================
    output logic        FU_pause,    // 在四个功能单元中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    input  logic        flush_sign,
    input  logic        redirect_flush
    );
//================================ 信号定义 ================================
logic EXE_valid;
logic EXE_ready_go;

// 此时指令无效，或者指令下一周期就可以进入下一个流水级
assign FU_allow_in = !EXE_valid || EXE_ready_go && WB_allow_in;
//================================ 前一流水级传过来的信号 ================================
logic [$clog2(ROB_DEPTH)-1:0] EXE_ROB_idx;
reg  [3 :0] EXE_alu_op;
reg  [2 :0] EXE_mul_op;
reg  [2 :0] EXE_div_op;
reg         EXE_gr_we;
reg  [4: 0] EXE_dest;
reg  [31:0] EXE_src1;
reg  [31:0] EXE_src2;
reg  [31:0] EXE_rkd_value;
reg  [2 :0] EXE_ld_en;
reg  [1 :0] EXE_st_en;
reg         EXE_ll_w;
reg         EXE_sc_w;

// CSR相关
reg         ISS_csr_re;
reg         ISS_csr_we;
reg  [13:0] ISS_csr_num;
reg         inst_csrxchg;
/*TLB指令相关控制信号*/
reg         ISS_tlbsrch_en;
reg         ISS_tlbwr_en;
reg         ISS_tlbfill_en;
reg         ISS_tlbrd_en;
reg         EXE_invtlb_en;
reg  [4 :0] EXE_invtlb_op;
reg         EXE_refetch_flush; // 重取刷新标志
reg         ISS_next_need_refetch; // 下条指令需重取

reg         EXE_cacop;
reg         ISS_ertn_flush; // ERTN指令标志

/*异常相关的信号*/
reg         ISS_ex;         // 异常标志
reg  [8:0]  ISS_excp_num;   // 异常号
reg  [1:0]  EXE_op_timer_64; // 定时器操作

/*分支预测信号*/
logic [$clog2(FRONTEND_FTQ_SIZE)-1:0]   EXE_ftq_id;   // FTQ块的索引
logic [$clog2(FETCH_WIDTH)-1:0]         EXE_ftq_block_idx;  // 在FTQ块中的索引
logic                                   ISS_is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）
//================================ difftest ================================
`ifdef DIFFTEST_EN
reg          EXE_cnt_inst;
reg  [31:0]  EXE_inst;
reg          EXE_csr_rstat_en;
`endif
//================================ 功能单元信号 ================================
logic [31:0] alu_result;
//================================ 异常相关信号 ================================
wire        EXE_ex;
wire [15:0] EXE_excp_num;
// 分支预测信号
wire        EXE_is_last_in_block;
//================================ 主要逻辑实现 ================================
reg nop; // 花费一个寄存器来空接信号，这样不是最好的做法但暂时想不到更好的方法了
//================================ 流水段控制逻辑 ================================
assign EXE_ready_go    = 1'b1;
//================================ 与前后流水级的通信 ================================
always @(posedge clk) begin
    if (reset | flush_sign) begin
        EXE_valid <= 1'b0;
    end
    else if (FU_allow_in) begin
        EXE_valid <= data_i.valid;
    end

    if (data_i.valid & FU_allow_in) begin
    	{nop, // EXE_valid不能在两个条件下同时赋值

        EXE_ROB_idx,

    	EXE_alu_op,
        EXE_mul_op,
        EXE_div_op,
        EXE_src1,
        EXE_src2,
        EXE_rkd_value,
    	EXE_gr_we,
    	EXE_dest,
    	EXE_ld_en,
        EXE_st_en,
        EXE_ll_w,
        EXE_sc_w,

        ISS_csr_re,
        ISS_csr_we,
        ISS_csr_num,
        inst_csrxchg,

        EXE_cacop,
        ISS_ertn_flush,
        ISS_ex,
        ISS_excp_num,
        EXE_op_timer_64,
        /*TLB指令相关控制信号*/
        ISS_tlbsrch_en,
        ISS_tlbwr_en,
        ISS_tlbfill_en,
        ISS_tlbrd_en,
        EXE_invtlb_en,
        EXE_invtlb_op,

        ISS_next_need_refetch,
        EXE_refetch_flush,

        EXE_ftq_id,   // FTQ块的索引
        EXE_ftq_block_idx,  // 在FTQ块中的索引
        ISS_is_last_in_block  // 是否是块中的最后一条指令（决定后端在FTQ中提交）
        `ifdef DIFFTEST_EN
        ,
        EXE_inst,
        EXE_cnt_inst,
        EXE_csr_rstat_en
        `endif
         } <= data_i;
    end
end
//================================ 功能单元信号 ================================
/*连接alu模块*/
alu u_alu(
    .alu_op     (EXE_alu_op),
    .alu_src1   (EXE_src1  ),
    .alu_src2   (EXE_src2  ),
    .alu_result (alu_result)
    );
//================================ 数据前递 ================================
assign FU_pause = (EXE_ex | EXE_refetch_flush) & EXE_valid; // 该信号要前递，需确保有效

assign EXE_ex         = ISS_ex & EXE_valid; // 这个信号会往前传，需要保证是有效的
assign EXE_excp_num   = {7'b0, ISS_excp_num}; // openla是这么干的，不知道为什么第10位要空置一个0


// 分支预测信号
assign EXE_is_last_in_block = ISS_is_last_in_block;

assign complete_en = FU_allow_in & EXE_valid & EXE_ready_go & ~redirect_flush; // 数据有效且指令允许流入下个流水级时，给ROB填入完成信号
assign complete_addr = EXE_ROB_idx;

//================================ 数据输出 ================================
assign FU_WB_bus.complete = 1'b1;
assign FU_WB_bus.Areg     = EXE_dest;
assign FU_WB_bus.ex = EXE_ex;
assign FU_WB_bus.excp_num = EXE_excp_num;
assign FU_WB_bus.data = alu_result; // final_result

assign FU_WB_bus.gr_we = EXE_gr_we;

assign FU_WB_bus.data_uncache_en = 0;

assign FU_WB_bus.csr_tlb_type = 0;

assign FU_WB_bus.inst_ll_w = 0;
assign FU_WB_bus.inst_sc_w = 0;

assign FU_WB_bus.different_data = 0;

assign FU_WB_bus.csr_we = 0;
assign FU_WB_bus.ertn_flush = 0;
assign FU_WB_bus.refetch_flush = EXE_refetch_flush;

// 指令位于前端的信息
assign FU_WB_bus.ftq_id = EXE_ftq_id;   // FTQ块的索引
assign FU_WB_bus.ftq_block_idx = EXE_ftq_block_idx;  // 在FTQ块中的索引
assign FU_WB_bus.is_last_in_block = EXE_is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

// 指令具体执行信息
assign FU_WB_bus.branch_info = 0;

// difftest
`ifdef DIFFTEST_EN
assign FU_WB_bus.diff_timer_64_rdata = 0;
assign FU_WB_bus.diff_inst = EXE_inst;
assign FU_WB_bus.diff_inst_ld_en = 0;
assign FU_WB_bus.diff_inst_st_en = 0;
assign FU_WB_bus.diff_cnt_inst = 0;
assign FU_WB_bus.diff_csr_rstat_en = 0;
assign FU_WB_bus.diff_csr_rdata = 0;
assign FU_WB_bus.diff_data_sram_wdata = 0;
`endif
endmodule