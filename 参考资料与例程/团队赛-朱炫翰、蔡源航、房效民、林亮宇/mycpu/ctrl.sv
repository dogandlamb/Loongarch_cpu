`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module ctrl
    import pipeline_types::*;
    import core_defines::*;
(
    //输入时钟和复位
    input  logic                clk ,
    input  logic                reset,
    //================================ 流水线握手信号 ================================
    input  logic                            ROB_empty,
    input  logic                            ROB_one_left, // ROB中只有一个元素
    // to commit
    input  logic                            commit_queue_full,
    output commit_bus_t [COMMIT_WIDTH-1:0]  commit_bus,
    //================================ 寄存器文件接口 ================================
    //与寄存器进行通信的信号，将数据写回
    output logic [COMMIT_WIDTH-1:0]               rf_we,      // 寄存器写使能
    output logic [COMMIT_WIDTH-1:0][4:0]          rf_waddr,   // 寄存器写地址
    output logic [COMMIT_WIDTH-1:0][31:0]         rf_wdata,   // 寄存器写数据
    //================================ 提交阶段的ROB端口 ================================   目前先一个一个退休，毕竟IPC也不高
    output logic [COMMIT_WIDTH-1:0]               dequeue_en, // 出队使能
    input  ROB_t [COMMIT_WIDTH-1:0]               ROB_data,   // 队头的数据，如果其状态为complete，则表示可以退休，dequeue_en为1；异常时有额外处理
    //================================ 调试接口 ================================
    //别忘了用于调试的信号，要不然仿真文件没处采样
    output logic [COMMIT_WIDTH-1:0][31:0]         debug_wb_pc,       // 调试PC
    output logic [COMMIT_WIDTH-1:0][3:0]          debug_wb_rf_we,    // 调试寄存器写使能
    output logic [COMMIT_WIDTH-1:0][4:0]          debug_wb_rf_wnum,  // 调试寄存器编号
    output logic [COMMIT_WIDTH-1:0][31:0]         debug_wb_rf_wdata, // 调试寄存器数据
    output logic [COMMIT_WIDTH-1:0][31:0]         debug_wb_inst,   
    //================================ 分支预测信号 ================================
    output backend_commit_meta_t        backend_commit_meta_o,
    output logic [DECODER_WIDTH-1:0]    backend_commit_bitmask_o,
    output logic [DECODER_WIDTH-1:0]    backend_commit_block_bitmask_o,
    output logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] backend_commit_ftq_id_o,
    //================================ pc查询 ================================
    output logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id,
    input  logic [31:0]                          ftq_query_pc,
    //================================ CSR接口 ================================
    output logic [31: 0] WB_pc,
    output logic [31: 0] WB_bad_vaddr,    // 传给csr表示触发TLB相关例外的虚地址
    input  logic [31: 0] tlb_entry,
    input  logic [31: 0] ex_entry,
    input  logic [31: 0] ertn_entry,
    // csr指令相关的信号
    output logic         WB_csr_we,  // 还要数据前递
    output logic [13: 0] WB_csr_num, // 还要数据前递
    output logic         WB_csr_write_int, // 要数据前递
    output logic [31: 0] WB_csr_wmask,
    output logic [31: 0] WB_csr_wdata,
    // ll.w和sc.w指令相关的信号
    output logic         WB_llbit_set, // 使能，表示要修改llbit
    output logic         WB_llbit,     // llbit
    output logic         WB_lladdr_set,// 使能，表示要修改lladdr
    output logic [27: 0] WB_lladdr,    // lladdr 
    //================================ TLB接口 ================================
    output logic         WB_tlbrd_en,      // TLB读使能
    output logic         WB_tlbfill_en,    // TLB填充使能
    output logic         WB_tlbwr_en,      // TLB写使能
    //================================ 异常处理接口 ================================
    output logic         WB_ertn_flush,    // ERTN指令标志
    output logic         WB_ex,            // 异常标志
    output logic [5:0]   WB_ecode,         // 异常主编码
    output logic [8:0]   WB_esubcode,      // 异常子编码
    output logic         WB_excp_tlbrefill, // 传给csr表示存在TLB重填例外
    output logic         WB_excp_tlb,       // 传给csr表示存在TLB相关例外
    output logic [18: 0] WB_excp_tlb_vppn,  // 传给csr表示触发TLB相关例外的vppn
    output logic         WB_refetch_flush,  // 重取刷新标志
    //================================ 流水线控制 ================================
    // 异常和ertn到达WB阶段时，需要进行前递的清除流水线缓存的信号
    output logic         flush_sign,
    input  logic         backend_flush,
    output logic [31:0]  WB_flush_next_pc,
    output logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] backend_flush_ftq_id_o,
    //debug
    output        logic debug_ws_valid         ,
    input         logic debug_break_point 
    // difftest
`ifdef DIFFTEST_EN
    ,
    output        ws0_valid_diff                    ,
    output        ws0_cnt_inst_diff                 ,
    output [63:0] ws0_timer_64_diff                 ,
    output [ 7:0] ws0_inst_ld_en_diff               ,
    output [31:0] ws0_ld_paddr_diff                 ,
    output [31:0] ws0_ld_vaddr_diff                 ,
    output [ 7:0] ws0_inst_st_en_diff               ,
    output [31:0] ws0_st_paddr_diff                 ,
    output [31:0] ws0_st_vaddr_diff                 ,
    output [31:0] ws0_st_data_diff                  ,
    output        ws0_csr_rstat_en_diff             ,
    output [31:0] ws0_csr_data_diff
    ,
    output        ws1_valid_diff                    ,
    output        ws1_cnt_inst_diff                 ,
    output [63:0] ws1_timer_64_diff                 ,
    output [ 7:0] ws1_inst_ld_en_diff               ,
    output [31:0] ws1_ld_paddr_diff                 ,
    output [31:0] ws1_ld_vaddr_diff                 ,
    output [ 7:0] ws1_inst_st_en_diff               ,
    output [31:0] ws1_st_paddr_diff                 ,
    output [31:0] ws1_st_vaddr_diff                 ,
    output [31:0] ws1_st_data_diff                  ,
    output        ws1_csr_rstat_en_diff             ,
    output [31:0] ws1_csr_data_diff
`endif
    );
//================================ 信号定义 ================================
logic [COMMIT_WIDTH-1:0] WB_valid;
logic [COMMIT_WIDTH-1:0] wb_ready_go;
logic WB_ready_go;

logic                           no_commit_two;
logic [COMMIT_WIDTH-1:0]        no_commit;
logic [COMMIT_WIDTH-1:0][31:0]  wb_pc;
logic [COMMIT_WIDTH-1:0]        wb_ex;
excp_bus_t [COMMIT_WIDTH-1:0]   excp_bus;
logic [COMMIT_WIDTH-1:0]        wb_flush_sign;

logic [COMMIT_WIDTH-1:0][$clog2(FRONTEND_FTQ_SIZE)-1:0]   WB_ftq_id;   // FTQ块的索引
logic [COMMIT_WIDTH-1:0][$clog2(FETCH_WIDTH)-1:0]         WB_ftq_block_idx;  // 在FTQ块中的索引
logic [COMMIT_WIDTH-1:0]                                  WB_is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）
branch_info_t [COMMIT_WIDTH-1:0]                            WB_branch_info;

wb u_wb0(
    //输入时钟和复位
    .clk                (clk),
    .reset              (reset),
    //================================ 模块准备信号 ================================
    .WB_valid           (WB_valid[0]),
    .wb_ready_go        (wb_ready_go[0]),
    .WB_ready_go        (WB_ready_go),     // WB阶段完成处理标志
    .no_commit          (no_commit[0]),
    //================================ 流水线握手信号 ================================
    //和MEM阶段的流水线握手信号
    .WB_allow_in        (WB_allow_in),     //WB阶段可以输入
    //================================ 提交阶段的ROB端口 ================================
    .dequeue_en         (dequeue_en[0]),
    .ROB_data           (ROB_data[0]),     //EXE送至MEM阶段信号
    //================================ 寄存器文件接口 ================================
    //与寄存器进行通信的信号，将数据写回
    .rf_we              (rf_we[0]),     // 寄存器写使能
    .rf_waddr           (rf_waddr[0]),     // 寄存器写地址
    .rf_wdata           (rf_wdata[0]),     // 寄存器写数据
    //================================ 调试接口 ================================
    //别忘了用于调试的信号，要不然仿真文件没处采样
    .debug_wb_pc        (debug_wb_pc[0]),     // 调试PC
    .debug_wb_rf_we     (debug_wb_rf_we[0]),     // 调试寄存器写使能
    .debug_wb_rf_wnum   (debug_wb_rf_wnum[0]),     // 调试寄存器编号
    .debug_wb_rf_wdata  (debug_wb_rf_wdata[0]),     // 调试寄存器数据
    .debug_wb_inst      (debug_wb_inst[0]),   
    //================================ 前递接口 ================================
    //输出当前阶段的目的寄存器,注意这个目的寄存器的生成逻辑，实际上包含了使能和流水段数据有效
    .WB_to_ISS_dest     (),
    .WB_to_ISS_forward  (),
    //================================ 分支预测信号 ================================
    .WB_ftq_id          (WB_ftq_id[0]),   // FTQ块的索引
    .WB_ftq_block_idx   (WB_ftq_block_idx[0]),  // 在FTQ块中的索引
    .WB_is_last_in_block(WB_is_last_in_block[0]),  // 是否是块中的最后一条指令（决定后端在FTQ中提交）
    .WB_branch_info     (WB_branch_info[0]),
    //================================ pc查询 ================================
    .ftq_id             (ftq_id),
    .ftq_query_pc       (ftq_query_pc),
    //================================ CSR接口 ================================
    // csr指令相关的信号
    .WB_csr_we          (WB_csr_we),     // 还要数据前递
    .WB_csr_num         (WB_csr_num),     // 还要数据前递
    .WB_csr_write_int   (WB_csr_write_int),     // 要数据前递
    .WB_csr_wmask       (WB_csr_wmask),
    .WB_csr_wdata       (WB_csr_wdata),
    // ll.w和sc.w指令相关的信号
    .WB_llbit_set       (WB_llbit_set),     // 使能，表示要修改llbit
    .WB_llbit           (WB_llbit),     // llbit
    .WB_lladdr_set      (WB_lladdr_set),     // 使能，表示要修改lladdr
    .WB_lladdr          (WB_lladdr),     // lladdr 
    //================================ TLB接口 ================================
    .WB_tlbrd_en        (WB_tlbrd_en),     // TLB读使能
    .WB_tlbfill_en      (WB_tlbfill_en),     // TLB填充使能
    .WB_tlbwr_en        (WB_tlbwr_en),     // TLB写使能
    //================================ 异常处理接口 ================================
    .WB_ertn_flush      (WB_ertn_flush),     // ERTN指令标志
    .WB_pc              (wb_pc[0]),
    .WB_ex              (wb_ex[0]),
    .excp_bus           (excp_bus[0]),
    .WB_refetch_flush   (WB_refetch_flush),     // 重取刷新标志
    //================================ 流水线控制 ================================
    // 异常和ertn到达WB阶段时，需要进行前递的清除流水线缓存的信号
    .flush_sign         (wb_flush_sign[0]),
    //debug
    .debug_ws_valid     (debug_ws_valid),
    .debug_break_point  (debug_break_point)
    // difftest
`ifdef DIFFTEST_EN
    ,
    .ws_valid_diff          (ws0_valid_diff),
    .ws_cnt_inst_diff       (ws0_cnt_inst_diff),
    .ws_timer_64_diff       (ws0_timer_64_diff),
    .ws_inst_ld_en_diff     (ws0_inst_ld_en_diff),
    .ws_ld_paddr_diff       (ws0_ld_paddr_diff),
    .ws_ld_vaddr_diff       (ws0_ld_vaddr_diff),
    .ws_inst_st_en_diff     (ws0_inst_st_en_diff),
    .ws_st_paddr_diff       (ws0_st_paddr_diff),
    .ws_st_vaddr_diff       (ws0_st_vaddr_diff),
    .ws_st_data_diff        (ws0_st_data_diff),
    .ws_csr_rstat_en_diff   (ws0_csr_rstat_en_diff),
    .ws_csr_data_diff       (ws0_csr_data_diff)
`endif
);

wb u_wb1(
    //输入时钟和复位
    .clk                (clk),
    .reset              (reset),
    //================================ 模块准备信号 ================================
    .WB_valid           (WB_valid[1]),
    .wb_ready_go        (wb_ready_go[1]),
    .WB_ready_go        (WB_ready_go),     // WB阶段完成处理标志
    .no_commit          (no_commit[1]),
    //================================ 流水线握手信号 ================================
    //和MEM阶段的流水线握手信号
    .WB_allow_in        (WB_allow_in),     //WB阶段可以输入
    //================================ 提交阶段的ROB端口 ================================
    .dequeue_en         (dequeue_en[1]),
    .ROB_data           (ROB_data[1]),     //EXE送至MEM阶段信号
    //================================ 寄存器文件接口 ================================
    //与寄存器进行通信的信号，将数据写回
    .rf_we              (rf_we[1]),     // 寄存器写使能
    .rf_waddr           (rf_waddr[1]),     // 寄存器写地址
    .rf_wdata           (rf_wdata[1]),     // 寄存器写数据
    //================================ 调试接口 ================================
    //别忘了用于调试的信号，要不然仿真文件没处采样
    .debug_wb_pc        (debug_wb_pc[1]),     // 调试PC
    .debug_wb_rf_we     (debug_wb_rf_we[1]),     // 调试寄存器写使能
    .debug_wb_rf_wnum   (debug_wb_rf_wnum[1]),     // 调试寄存器编号
    .debug_wb_rf_wdata  (debug_wb_rf_wdata[1]),     // 调试寄存器数据
    .debug_wb_inst      (debug_wb_inst[1]),   
    //================================ 前递接口 ================================
    //输出当前阶段的目的寄存器,注意这个目的寄存器的生成逻辑，实际上包含了使能和流水段数据有效
    .WB_to_ISS_dest     (),
    .WB_to_ISS_forward  (),
    //================================ 分支预测信号 ================================
    .WB_ftq_id          (WB_ftq_id[1]),   // FTQ块的索引
    .WB_ftq_block_idx   (WB_ftq_block_idx[1]),  // 在FTQ块中的索引
    .WB_is_last_in_block(WB_is_last_in_block[1]),  // 是否是块中的最后一条指令（决定后端在FTQ中提交）
    .WB_branch_info     (WB_branch_info[1]),
    //================================ pc查询 ================================
    .ftq_id             (),
    .ftq_query_pc       (0),
    //================================ CSR接口 ================================
    // csr指令相关的信号
    .WB_csr_we          (),     // 还要数据前递
    .WB_csr_num         (),     // 还要数据前递
    .WB_csr_write_int   (),     // 要数据前递
    .WB_csr_wmask       (),
    .WB_csr_wdata       (),
    // ll.w和sc.w指令相关的信号
    .WB_llbit_set       (),     // 使能，表示要修改llbit
    .WB_llbit           (),     // llbit
    .WB_lladdr_set      (),     // 使能，表示要修改lladdr
    .WB_lladdr          (),     // lladdr 
    //================================ TLB接口 ================================
    .WB_tlbrd_en        (),     // TLB读使能
    .WB_tlbfill_en      (),     // TLB填充使能
    .WB_tlbwr_en        (),     // TLB写使能
    //================================ 异常处理接口 ================================
    .WB_ertn_flush      (),     // ERTN指令标志
    .WB_pc              (wb_pc[1]),
    .WB_ex              (wb_ex[1]),
    .excp_bus           (excp_bus[1]),
    .WB_refetch_flush   (),     // 重取刷新标志
    //================================ 流水线控制 ================================
    // 异常和ertn到达WB阶段时，需要进行前递的清除流水线缓存的信号
    .flush_sign         (wb_flush_sign[1]),
    //debug
    .debug_ws_valid     (),
    .debug_break_point  ()
    // difftest
`ifdef DIFFTEST_EN
    ,
    .ws_valid_diff          (ws1_valid_diff),
    .ws_cnt_inst_diff       (ws1_cnt_inst_diff),
    .ws_timer_64_diff       (ws1_timer_64_diff),
    .ws_inst_ld_en_diff     (ws1_inst_ld_en_diff),
    .ws_ld_paddr_diff       (ws1_ld_paddr_diff),
    .ws_ld_vaddr_diff       (ws1_ld_vaddr_diff),
    .ws_inst_st_en_diff     (ws1_inst_st_en_diff),
    .ws_st_paddr_diff       (ws1_st_paddr_diff),
    .ws_st_vaddr_diff       (ws1_st_vaddr_diff),
    .ws_st_data_diff        (ws1_st_data_diff),
    .ws_csr_rstat_en_diff   (ws1_csr_rstat_en_diff),
    .ws_csr_data_diff       (ws1_csr_data_diff)
`endif
);
//================================ 提交逻辑 ================================
/*后一条指令在以下情况不能提交：
1.前一条指令有异常
2.前一条指令是ertn指令
3.前一条指令打上重取标记
4.后一条指令是ertn指令
5.后一条指令打上重取标记
6.后一条指令写csr
7.后一条指令是tlb指令
8.后一条指令是ll_w、sc_w指令
9.后一条指令是分支跳转指令
10.ROB中只有一条指令
*/
assign no_commit_two = no_commit[1] || wb_ex[0] || WB_ertn_flush || WB_refetch_flush || ROB_one_left;
// dequeue_en可以作为WB_valid来用；backend_flush是延后一个周期的flush_sign，需要作用于dequeue_en来阻止下一周期的退休
assign dequeue_en[0] = ROB_data[0].complete && !ROB_empty && !commit_queue_full && ~backend_flush;
// dequeue_en[0]有效的时候，dequeue_en[1]才可以有效。这样保证了指令是顺序提交的
assign dequeue_en[1] = ROB_data[0].complete && ROB_data[1].complete && !ROB_empty && !commit_queue_full && !no_commit_two && ~backend_flush;

//================================ ROB数据逻辑 ================================
assign WB_pc = wb_pc[0];
assign WB_ex = wb_ex[0];            // 异常标志
assign WB_ecode = excp_bus[0].ecode;         // 异常主编码
assign WB_esubcode = excp_bus[0].esubcode;      // 异常子编码
assign WB_bad_vaddr = excp_bus[0].bad_vaddr;
assign WB_excp_tlbrefill = excp_bus[0].excp_tlbrefill; // 传给csr表示存在TLB重填例外
assign WB_excp_tlb = excp_bus[0].excp_tlb;       // 传给csr表示存在TLB相关例外
assign WB_excp_tlb_vppn = excp_bus[0].excp_tlb_vppn;  // 传给csr表示触发TLB相关例外的vppn

//================================ 流水线控制 ================================      但这两个信号实际上没有用
assign WB_ready_go  = (!WB_valid[0] || wb_ready_go[0]) && (!WB_valid[1] || wb_ready_go[1]);
// 不考虑ROB_full，因为填入ROB不是在提交阶段填入的，是在ISS阶段填入的。当提交队列没满时，WB_allow_in理论上为恒1
assign WB_allow_in  = (!WB_valid[0] || wb_ready_go[0]) && (!WB_valid[1] || wb_ready_go[1]) && !commit_queue_full;


assign flush_sign   = WB_ex || WB_ertn_flush || WB_refetch_flush;


//================================ 异常、ertn、refetch时的pc更新逻辑 ================================
/*这里是pc值更新的相关逻辑*/
// WB_pc是异常、ertn、refetch的指令的pc
always_comb begin
    case (1'b1)
        WB_excp_tlbrefill : WB_flush_next_pc = tlb_entry     ; // tlb重填例外地址，优先级在普通的例外之上
        WB_ex             : WB_flush_next_pc = ex_entry      ; // 异常程序入口地址
        WB_ertn_flush     : WB_flush_next_pc = ertn_entry    ; // 例外返回地址
        default           : WB_flush_next_pc = WB_pc         ; // 打上重取标记时，从WB阶段指令继续执行
    endcase
end

//================================ 提交逻辑 ================================
assign backend_commit_meta_o = {
    WB_branch_info[0].is_branch & ~wb_ex[0],
    WB_branch_info[0].branch_type,
    WB_branch_info[0].is_taken,
    WB_branch_info[0].predicted_taken
};
assign backend_commit_bitmask_o = WB_valid & (wb_ex[0] ? 2'b01 : {WB_is_last_in_block[1], WB_is_last_in_block[0] | WB_ertn_flush | WB_refetch_flush}) ;
                                    // 表示后端向前端提交结束一个块，当异常出现时提前结束一个块

// assign backend_commit_bitmask_o = WB_valid & (wb_ex[0] ? 2'b01 :
//                                   wb_ex[1] ? {1'b1, WB_is_last_in_block[0] | WB_ertn_flush | WB_refetch_flush} :
//                                   {WB_is_last_in_block[1], WB_is_last_in_block[0] | WB_ertn_flush | WB_refetch_flush}) ;
//                                     // 表示后端向前端提交结束一个块，当异常出现时提前结束一个块
assign backend_commit_block_bitmask_o = WB_valid & {WB_is_last_in_block[1], WB_is_last_in_block[0]};    // 用来表示一个正常的块结束，是否更新预测器信息就是看这个标记，目前只能看第零位，后面改一下让跳转指令允许走流水线1

assign backend_flush_ftq_id_o = (wb_ex[0] | WB_ertn_flush | WB_refetch_flush) ? WB_ftq_id[0] : 0;
assign backend_commit_ftq_id_o  = WB_ftq_id[0];

// 传给commit
assign commit_bus[0] = {
    debug_wb_pc[0],     // 调试PC
    debug_wb_rf_we[0],     // 调试寄存器写使能
    debug_wb_rf_wnum[0],     // 调试寄存器编号
    debug_wb_rf_wdata[0],     // 调试寄存器数据
    debug_wb_inst[0]
};
assign commit_bus[1] = {
    debug_wb_pc[1],     // 调试PC
    debug_wb_rf_we[1],     // 调试寄存器写使能
    debug_wb_rf_wnum[1],     // 调试寄存器编号
    debug_wb_rf_wdata[1],     // 调试寄存器数据
    debug_wb_inst[1]
};

endmodule