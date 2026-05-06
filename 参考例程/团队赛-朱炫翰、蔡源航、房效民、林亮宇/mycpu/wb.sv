`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module wb
    import pipeline_types::*;
    import core_defines::*;
(
    //输入时钟和复位
    input  logic     clk ,
    input  logic     reset,
    //================================ 模块准备信号 ================================
    output logic     WB_valid,
    output logic     wb_ready_go,
    input  logic     WB_ready_go, // WB阶段完成处理标志
    output logic     no_commit,
    //================================ 流水线握手信号 ================================
    //和MEM阶段的流水线握手信号
    input  logic     WB_allow_in,             //WB阶段可以输入
    //================================ 提交阶段的ROB端口 ================================   目前先一个一个退休，毕竟IPC也不高
    input  logic    dequeue_en, // 作为WB_valid，应该挺合理的
    input  ROB_t    ROB_data,   // 队头的数据，如果其状态为complete，则表示可以退休，dequeue_en为1；异常时有额外处理
    //================================ 寄存器文件接口 ================================
    //与寄存器进行通信的信号，将数据写回
    output logic         rf_we,      // 寄存器写使能
    output logic [4:0]   rf_waddr,   // 寄存器写地址
    output logic [31:0]  rf_wdata,   // 寄存器写数据
    //================================ 调试接口 ================================
    //别忘了用于调试的信号，要不然仿真文件没处采样
    output logic [31:0] debug_wb_pc,       // 调试PC
    output logic [3:0]  debug_wb_rf_we,    // 调试寄存器写使能
    output logic [4:0]  debug_wb_rf_wnum,  // 调试寄存器编号
    output logic [31:0] debug_wb_rf_wdata, // 调试寄存器数据
    /*(* mark_debug="true", keep="true" *)*/output logic [31:0] debug_wb_inst ,   
    //================================ 前递接口 ================================
    //输出当前阶段的目的寄存器,注意这个目的寄存器的生成逻辑，实际上包含了使能和流水段数据有效
    output logic [4 : 0] WB_to_ISS_dest,
    output logic [31: 0] WB_to_ISS_forward,
    //================================ 分支预测信号 ================================
    output logic [$clog2(FRONTEND_FTQ_SIZE)-1:0]   WB_ftq_id,   // FTQ块的索引
    output logic [$clog2(FETCH_WIDTH)-1:0]         WB_ftq_block_idx,  // 在FTQ块中的索引
    output logic                                   WB_is_last_in_block,  // 是否是块中的最后一条指令（决定后端在FTQ中提交）
    output branch_info_t                           WB_branch_info,
    //================================ pc查询 ================================
    output logic [$clog2(FRONTEND_FTQ_SIZE)-1:0]   ftq_id,
    input  logic [31:0]                            ftq_query_pc,
    //================================ CSR接口 ================================
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
    /*(* mark_debug="true", keep="true" *)*/output logic         WB_ertn_flush,    // ERTN指令标志
    /*(* mark_debug="true", keep="true" *)*/output logic [31: 0] WB_pc, // 不将其放进excp_bus中，是因为它还要传到IF阶段作为重取地址
    /*(* mark_debug="true", keep="true" *)*/output logic         WB_ex,
    output excp_bus_t    excp_bus,
    /*(* mark_debug="true", keep="true" *)*/output logic         WB_refetch_flush,  // 重取刷新标志
    //================================ 流水线控制 ================================
    // 异常和ertn到达WB阶段时，需要进行前递的清除流水线缓存的信号
    output logic         flush_sign,
    //debug
    output logic         debug_ws_valid         ,
    input  logic         debug_break_point 
    // difftest
`ifdef DIFFTEST_EN
    ,
    output        ws_valid_diff                    ,
    output        ws_cnt_inst_diff                 ,
    output [63:0] ws_timer_64_diff                 ,
    output [ 7:0] ws_inst_ld_en_diff               ,
    output [31:0] ws_ld_paddr_diff                 ,
    output [31:0] ws_ld_vaddr_diff                 ,
    output [ 7:0] ws_inst_st_en_diff               ,
    output [31:0] ws_st_paddr_diff                 ,
    output [31:0] ws_st_vaddr_diff                 ,
    output [31:0] ws_st_data_diff                  ,
    output        ws_csr_rstat_en_diff             ,
    output [31:0] ws_csr_data_diff
`endif
    );
`ifdef DIFFTEST_EN
logic WB_cnt_inst;
logic [7:0] WB_inst_ld_en;
logic [7:0] WB_inst_st_en;
logic [63:0] WB_timer_64;
logic [31:0] WB_st_data;
logic [31:0] WB_csr_rdata;
logic WB_csr_rstat_en;
`endif
//================================ 流水线寄存器 ================================
logic [31:0] WB_mem_addr;     // 访存地址（用于异常）
logic [31:0] WB_paddr;        // 访存物理地址
logic        WB_gr_we;        // 寄存器写使能
logic [4:0]  WB_dest;         // 目的寄存器
logic [31:0] WB_final_result; // 最终结果

// 原子访存指令
logic        WB_ll_w;        // ll.w指令
logic        WB_sc_w;        // sc.w指令
logic        WB_data_uncache_en; // dcache强序非缓存
/*CSR相关*/
logic  [16:0] nothing;
logic         csr_tlb_type;
logic         MEM_csr_we;
logic  [13:0] MEM_csr_num;
logic  [31:0] MEM_csr_wmask;
logic  [31:0] MEM_csr_wdata;
logic         MEM_csr_write_int;
/*TLB指令相关控制信号*/
logic         MEM_tlbwr_en;     // TLB写使能
logic         MEM_tlbfill_en;   // TLB填充使能
logic         MEM_tlbrd_en;     // TLB读使能
logic         MEM_refetch_flush; // 重取刷新标志

logic         MEM_ertn_flush; // ERTN指令标志

/*异常相关信号*/
logic         MEM_ex;         // 异常标志
logic  [15:0] MEM_excp_num;   // 异常号
logic  [15:0] WB_excp_num;    // 异常号
//================================ 主要逻辑实现 ================================
//================================ 流水线控制 ================================
assign wb_ready_go = 1'b1;
//================================ 与前后流水级的通信 ================================
// 143+2
assign WB_valid = dequeue_en;

assign WB_gr_we = ROB_data.gr_we;
assign WB_dest  = ROB_data.Areg;
assign WB_final_result = ROB_data.data;

assign WB_data_uncache_en = ROB_data.data_uncache_en;

assign csr_tlb_type = ROB_data.csr_tlb_type;

assign WB_ll_w = ROB_data.inst_ll_w;
assign WB_sc_w = ROB_data.inst_sc_w;

assign MEM_csr_write_int = '0;

assign MEM_ex = ROB_data.ex;
assign MEM_excp_num = ROB_data.excp_num;

assign MEM_csr_we = ROB_data.csr_we;
assign MEM_ertn_flush = ROB_data.ertn_flush;
assign MEM_refetch_flush = ROB_data.refetch_flush;
// 分支预测信号
assign WB_ftq_id = ROB_data.ftq_id;   // FTQ块的索引
assign WB_ftq_block_idx = ROB_data.ftq_block_idx;  // 在FTQ块中的索引
assign WB_is_last_in_block = ROB_data.is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）
assign WB_branch_info = ROB_data.branch_info;
// pc查询
assign ftq_id = WB_ftq_id;

assign WB_pc  = ftq_query_pc + (WB_ftq_block_idx << 2);

// difftest
`ifdef DIFFTEST_EN
assign WB_timer_64 = ROB_data.diff_timer_64_rdata;
assign debug_wb_inst = ROB_data.diff_inst;
assign WB_inst_ld_en = ROB_data.diff_inst_ld_en;
assign WB_inst_st_en = ROB_data.diff_inst_st_en;
assign WB_cnt_inst = ROB_data.diff_cnt_inst;
assign WB_csr_rstat_en = ROB_data.diff_csr_rstat_en;
assign WB_csr_rdata = ROB_data.diff_csr_rdata; // 
assign WB_st_data = ROB_data.diff_data_sram_wdata;
`endif

//================================ 访问寄存器文件 ================================
assign rf_we    = WB_gr_we && WB_valid && !WB_ex && !WB_refetch_flush; // 发生异常时，打上重取标记时，不能写寄存器
assign rf_waddr = WB_dest;
assign rf_wdata = WB_final_result;

//================================ 数据前递 ================================
/*输出给ISS阶段的目的寄存器编号*/
//注意这里同时和流水段数据有效信号和寄存器写使能信号进行与逻辑，如果数据无效或者寄存器写使能无效那么输出的寄存器编号就是0
assign WB_to_ISS_dest = WB_dest & {5{WB_valid}} & {5{WB_gr_we}};
assign WB_to_ISS_forward = WB_final_result;

//================================ 数据选择 ================================
always_comb begin : data_select1
    if (~csr_tlb_type | WB_ll_w | WB_sc_w) begin
        {
        nothing, // 用来补位
        WB_mem_addr,
        WB_paddr
        } = ROB_data.different_data;
    end
    else begin
        {
        nothing,
        WB_mem_addr,
        WB_paddr
        } = 0;
    end
end

always_comb begin : data_select2
    if (csr_tlb_type & ~WB_ll_w & ~WB_sc_w) begin
        {
        MEM_csr_num,
        MEM_csr_wmask,
        MEM_csr_wdata,
        MEM_tlbwr_en,
        MEM_tlbfill_en,
        MEM_tlbrd_en
        } = ROB_data.different_data;
    end
    else begin
        {
        MEM_csr_num,
        MEM_csr_wmask,
        MEM_csr_wdata,
        MEM_tlbwr_en,
        MEM_tlbfill_en,
        MEM_tlbrd_en
        } = 0;
    end
end

//================================ 调试接口 ================================
// pc和dest、wdata与上valid，为了debug的时候别出这么多xxxxxxxx
assign debug_wb_pc       = WB_pc & {32{WB_valid}};
assign debug_wb_rf_we    = {4{rf_we}};
assign debug_wb_rf_wnum  = WB_dest & {5{WB_valid}};
assign debug_wb_rf_wdata = WB_final_result & {32{WB_valid}};
assign debug_ws_valid    = WB_valid;

//================================ CSR控制 ================================
assign WB_csr_we = MEM_csr_we && WB_valid && !WB_ex && !WB_refetch_flush; // 发生异常时，打上重取标记时，不能写csr
assign WB_csr_num = MEM_csr_num;
assign WB_csr_wmask = MEM_csr_wmask;
assign WB_csr_wdata = MEM_csr_wdata;
assign WB_csr_write_int = MEM_csr_write_int;
//================================ 异常处理 ================================
assign WB_ertn_flush = MEM_ertn_flush && WB_valid && !WB_ex && !WB_refetch_flush;
assign WB_ex         = MEM_ex && WB_valid && !WB_refetch_flush; // 这个信号会往前传，需要保证是有效的
assign WB_excp_num   = MEM_excp_num; // 异常号
// 异常编码转换（根据优先级）
//  exception have piority, onle one exception is valid 
always_comb begin : excp_bus_sel 
    case (1'b1) 
        WB_excp_num[ 0] : excp_bus = {`ECODE_INT , 32'b0      , 9'b0          , 1'b0    , 1'b0    , 19'b0             };
        WB_excp_num[ 1] : excp_bus = {`ECODE_ADE , WB_pc      , `ESUBCODE_ADEF, 1'b0    , 1'b0    , 19'b0             };
        WB_excp_num[ 2] : excp_bus = {`ECODE_TLBR, WB_pc      , 9'b0          , WB_valid, WB_valid, WB_pc[31:13]      };
        WB_excp_num[ 3] : excp_bus = {`ECODE_PIF , WB_pc      , 9'b0          , 1'b0    , WB_valid, WB_pc[31:13]      };
        WB_excp_num[ 4] : excp_bus = {`ECODE_PPI , WB_pc      , 9'b0          , 1'b0    , WB_valid, WB_pc[31:13]      };
        WB_excp_num[ 5] : excp_bus = {`ECODE_SYS , 32'b0      , 9'b0          , 1'b0    , 1'b0    , 19'b0             };
        WB_excp_num[ 6] : excp_bus = {`ECODE_BRK , 32'b0      , 9'b0          , 1'b0    , 1'b0    , 19'b0             };
        WB_excp_num[ 7] : excp_bus = {`ECODE_INE , 32'b0      , 9'b0          , 1'b0    , 1'b0    , 19'b0             };
        WB_excp_num[ 8] : excp_bus = {`ECODE_IPE , 32'b0      , 9'b0          , 1'b0    , 1'b0    , 19'b0             };   //close ipe excp now
        WB_excp_num[ 9] : excp_bus = {`ECODE_ALE , WB_mem_addr, 9'b0          , 1'b0    , 1'b0    , 19'b0             };
        WB_excp_num[11] : excp_bus = {`ECODE_TLBR, WB_mem_addr, 9'b0          , WB_valid, WB_valid, WB_mem_addr[31:13]};
        WB_excp_num[12] : excp_bus = {`ECODE_PME , WB_mem_addr, 9'b0          , 1'b0    , WB_valid, WB_mem_addr[31:13]};
        WB_excp_num[13] : excp_bus = {`ECODE_PPI , WB_mem_addr, 9'b0          , 1'b0    , WB_valid, WB_mem_addr[31:13]};
        WB_excp_num[14] : excp_bus = {`ECODE_PIS , WB_mem_addr, 9'b0          , 1'b0    , WB_valid, WB_mem_addr[31:13]};
        WB_excp_num[15] : excp_bus = {`ECODE_PIL , WB_mem_addr, 9'b0          , 1'b0    , WB_valid, WB_mem_addr[31:13]};
        default         : excp_bus = 69'b0                                                                             ;
    endcase
end

/*(* mark_debug="true", keep="true" *)*/logic [5:0] WB_ecode;
assign WB_ecode = excp_bus.ecode;

//================================ TLB控制 ================================
assign WB_tlbwr_en   = MEM_tlbwr_en   && WB_valid && !WB_ex && !WB_refetch_flush; // 因为tlbwr在WB阶段要修改tlb，所以必须保证有效
assign WB_tlbfill_en = MEM_tlbfill_en && WB_valid && !WB_ex && !WB_refetch_flush; // 因为tlbfill在WB阶段要修改tlb，所以必须保证有效
assign WB_tlbrd_en   = MEM_tlbrd_en   && WB_valid && !WB_ex && !WB_refetch_flush; // 因为tlbrd在WB阶段要修改csr，所以必须保证有效

//================================ llbit处理逻辑 ================================
assign WB_llbit_set  = (WB_ll_w | WB_sc_w) && WB_valid && !WB_ex && !WB_refetch_flush; // 表示ll.w指令确实有效，要改llbit
/* openla抄来的，感觉逻辑有点奇怪，反正就是表示：
1.指令为ll.w时，当dcache一致可缓存时，把llbit置1；当dcache为强序非缓存时，执行结果不确定
2.指令为sc.w时，不赋值
*/
assign WB_llbit      = ((WB_ll_w && !WB_data_uncache_en) & 1'b1) | (WB_sc_w & 1'b0) ;
assign WB_lladdr_set = WB_ll_w && !WB_data_uncache_en && WB_valid && !WB_ex && !WB_refetch_flush;
assign WB_lladdr     = WB_paddr[31:4];
//================================ 流水线刷新 ================================
assign WB_refetch_flush = MEM_refetch_flush && WB_valid;
assign flush_sign       = (WB_ex || WB_ertn_flush || WB_refetch_flush) && WB_valid; // 这个信号会往前传，需要保证是有效的

logic  error_predict;
assign error_predict = ~WB_branch_info.is_branch && WB_is_last_in_block && 
                        WB_branch_info.predicted_taken && WB_branch_info.predict_valid && WB_branch_info.predecoder_redirect;

// 第一条提交指令没有异常且第二条提交指令有异常时，允许第二条指令提交
// ROB非空时，从ROB中获取出来的都是有效的数据
assign no_commit = MEM_ex || MEM_ertn_flush || MEM_refetch_flush ||
                   MEM_csr_we || MEM_tlbrd_en || MEM_tlbwr_en || MEM_tlbfill_en || 
                   WB_ll_w || WB_sc_w ||
                   error_predict ||  
                   WB_branch_info.is_branch; // 暂时先限制分支跳转指令只能在前一条指令提交

`ifdef DIFFTEST_EN

assign ws_valid_diff        = WB_valid & ~WB_ex & ~WB_refetch_flush;
assign ws_timer_64_diff     = WB_timer_64       ;
assign ws_cnt_inst_diff     = WB_cnt_inst       ;

assign ws_inst_ld_en_diff   = WB_inst_ld_en     ;
assign ws_ld_paddr_diff     = WB_paddr          ;
//assign ws_ld_paddr_diff     = WB_mem_addr          ;
assign ws_ld_vaddr_diff     = WB_mem_addr       ;

assign ws_inst_st_en_diff   = WB_inst_st_en     ;
assign ws_st_paddr_diff     = ws_ld_paddr_diff  ;
assign ws_st_vaddr_diff     = ws_ld_vaddr_diff  ;
assign ws_st_data_diff      = WB_st_data        ;

assign ws_csr_rstat_en_diff = WB_csr_rstat_en;
assign ws_csr_data_diff     = WB_csr_rdata       ;
`endif
endmodule