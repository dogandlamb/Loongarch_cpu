`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module ISS_stage
    import pipeline_types::*;
    import core_defines::*;
(
    //输入时钟和复位
    input  logic        clk ,
    input  logic        reset,
    //================================ 流水线握手信号 ================================
    output logic        issue_queue_full,        //发射队列已满
    input  logic        csr_buffer_full,         //csr_buffer已满，不用
    input  logic        [FU_NUM-1:0] FU_allow_in,            //EXE阶段可以输入
    //================================ 流水线间通信总线 ================================
    // from RA
    input  logic        [DECODER_WIDTH-1:0] enqueue_en, // 入队使能，发射队列什么时候添加指令，就什么时候入队
    input  IQ_t         [DECODER_WIDTH-1:0] enqueue_data, // 入队数据
    // to EXE
    output ISS_EXE_bus_t [FU_NUM-BU_NUM-1:0]ISS_EXE_bus,
    output BU_bus_t                         BU_bus,
    //================================ 寄存器文件接口 ================================
    output logic [DECODER_WIDTH-1:0][4:0]  rf_raddr1,   // 寄存器读地址1
    input  logic [DECODER_WIDTH-1:0][31:0] rf_rdata1,   // 寄存器读数据1
    output logic [DECODER_WIDTH-1:0][4:0]  rf_raddr2,   // 寄存器读地址2
    input  logic [DECODER_WIDTH-1:0][31:0] rf_rdata2,   // 寄存器读数据2
    //================================ ROB的读端口 ================================
    output logic [ISSUE_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0] ROB_raddr1,
    input  logic [ISSUE_WIDTH-1:0]                        ROB_rvalid1,
    input  logic [ISSUE_WIDTH-1:0][31:0]                  ROB_rdata1,
    output logic [ISSUE_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0] ROB_raddr2,
    input  logic [ISSUE_WIDTH-1:0]                        ROB_rvalid2,
    input  logic [ISSUE_WIDTH-1:0][31:0]                  ROB_rdata2,
    //================================ pc查询 ================================
    output logic [ISSUE_WIDTH-1:0][$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id,
    input  logic [ISSUE_WIDTH-1:0][31:0]                          ftq_query_pc,
    output logic                          csr_increase_en,
    input  logic                          csr_pause,
    //================================ 中断接口 ================================
    input  logic         has_int,    // 是否有中断
    //================================ 前递暂停信号 ================================
    input  logic [FU_NUM-1:0] FU_pause,    // 在四个功能单元中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    input  logic              BU_pause,
    input  logic              ROB_pause,   // 在ROB中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    input  logic                         flush_sign,
    input  logic                         redirect_flush, // 延后一周期的flush_sign
    //debug
    input                               infor_flag,
    input  [ 4:0]                       reg_num,
    output [31:0]                       debug_rf_rdata1

    `ifdef DIFFTEST_EN
    ,
    // difftest
    output [31:0]                       rf_to_diff [31:0]
    `endif
    );
// assign debug_rf_rdata1 = rf_raddr1;

logic ISS_ready_go; // ISS阶段完成处理标志，这是总的ready_go
//=================================================== 主要逻辑实现 ===================================================

//================================ 与前后流水级的通信 ================================
logic [DECODER_WIDTH-1:0] dequeue_en;
IQ_t [DECODER_WIDTH-1:0] dequeue_data;
logic                    empty;
logic                    one_left;

//================================ FIFO，流水线控制寄存器 ================================ 
/*用发射队列作为流水线寄存器
1.队列没满时允许填入指令，并且填入的是有效数据，无效数据不填入
2.队列为空时输出数据无效，当ISS_ready_go为1、FU_allow_in为1且队列非空时，输出数据
*/
issue_queue #(
    .DATA_WIDTH($size(IQ_t))
) u_issue_queue (
    .clk            (clk),
    .reset          (reset),
    .flush          (flush_sign),
    .redirect       (redirect_flush),

    .enqueue_en     (enqueue_en),
    .enqueue_data   (enqueue_data),
    .dequeue_data   (dequeue_data),
    .dequeue_en     (dequeue_en),

    .empty          (empty),
    .one_left       (one_left),
    .full           (issue_queue_full)
);
//================================ 信号定义 ================================
IQ_t [DECODER_WIDTH-1:0] data_fifo; // 指令发射队列输出的数据
assign data_fifo[0] = dequeue_data[0] & {$size(IQ_t){!empty}}; // 当队列为空时，输出的数据无效
assign data_fifo[1] = dequeue_data[1] & {$size(IQ_t){!empty}}; // 当队列为空时，输出的数据无效

logic       [DECODER_WIDTH-1:0] ISS_valid;
branch_bus_t[DECODER_WIDTH-1:0] branch_bus;

logic [DECODER_WIDTH-1:0] iss_ready_go;     // 表示该指令ready go了
logic [FU_NUM-1:0]        iss0_select_FU;   // 前一条指令选择了哪个FU
logic [FU_NUM-1:0]        iss1_select_FU;   // 后一条指令选择了哪个FU
logic [DECODER_WIDTH-1:0] is_privilege;
ISS_EXE_bus_t [DECODER_WIDTH-1:0] data_o;   // 输出的数据，给EXE阶段

logic   [DECODER_WIDTH-1:0] is_branch;
BU_bus_t[DECODER_WIDTH-1:0] BU_data_o;

// 作为EXE_next_need_refetch传进iss中
logic refetch_state;

logic no_dispatch_two; // 表示不能进行双发射
logic csr_HAZARD;
logic int_HAZARD;
logic tlbsrch_HAZARD;

//================================ 主要逻辑实现 ================================

iss u_iss0(
    .reset          (reset),
    //================================ 模块准备信号 ================================
    .ISS_valid      (ISS_valid[0]),
    .iss_ready_go   (iss_ready_go[0]),
    .ISS_ready_go   (ISS_ready_go ),
    //================================ 流水线握手信号 ================================
    .dequeue_en     (dequeue_en[0]),
    //================================ 内外数据传输 ================================
    .is_privilege   (is_privilege[0]),
    .data_i         (data_fifo[0]),
    .data_o         (data_o[0]),
    .BU_data_o      (BU_data_o[0]),
    //================================ 寄存器文件接口 ================================
    .rf_raddr1      (rf_raddr1[0]),   // 寄存器读地址1
    .rf_rdata1      (rf_rdata1[0]),   // 寄存器读数据1
    .rf_raddr2      (rf_raddr2[0]),   // 寄存器读地址2
    .rf_rdata2      (rf_rdata2[0]),   // 寄存器读数据2
    //================================ ROB的读端口 ================================
    .ROB_raddr1     (ROB_raddr1[0]),
    .ROB_rvalid1    (ROB_rvalid1[0]),
    .ROB_rdata1     (ROB_rdata1[0]),
    .ROB_raddr2     (ROB_raddr2[0]),
    .ROB_rvalid2    (ROB_rvalid2[0]),
    .ROB_rdata2     (ROB_rdata2[0]),
    //================================ pc查询 ================================
    .ftq_id         (ftq_id[0]),
    .ftq_query_pc   (ftq_query_pc[0]),
    //================================ 中断接口 ================================
    .has_int                (has_int),                // 是否有中断

    .EXE_next_need_refetch(refetch_state)
);

iss u_iss1(
    .reset          (reset),
    //================================ 模块准备信号 ================================
    .ISS_valid      (ISS_valid[1]),
    .iss_ready_go   (iss_ready_go[1]),
    .ISS_ready_go   (ISS_ready_go ),
    //================================ 流水线握手信号 ================================
    .dequeue_en     (dequeue_en[1]),
    //================================ 内外数据传输 ================================
    .is_privilege   (is_privilege[1]),
    .data_i         (data_fifo[1]),
    .data_o         (data_o[1]),
    .BU_data_o      (BU_data_o[1]),
    //================================ 寄存器文件接口 ================================
    .rf_raddr1      (rf_raddr1[1]),   // 寄存器读地址1
    .rf_rdata1      (rf_rdata1[1]),   // 寄存器读数据1
    .rf_raddr2      (rf_raddr2[1]),   // 寄存器读地址2
    .rf_rdata2      (rf_rdata2[1]),   // 寄存器读数据2
    //================================ ROB的读端口 ================================
    .ROB_raddr1     (ROB_raddr1[1]),
    .ROB_rvalid1    (ROB_rvalid1[1]),
    .ROB_rdata1     (ROB_rdata1[1]),
    .ROB_raddr2     (ROB_raddr2[1]),
    .ROB_rvalid2    (ROB_rvalid2[1]),
    .ROB_rdata2     (ROB_rdata2[1]),
    //================================ pc查询 ================================
    .ftq_id         (ftq_id[1]),
    .ftq_query_pc   (ftq_query_pc[1]),
    //================================ 中断接口 ================================
    .has_int              (1'b0   ),                // 中断只附在流水线的前一条指令，不附在后一条指令

    .EXE_next_need_refetch(refetch_state)      // 让下一条指令打上重取标记的指令是特权指令，所以后一条指令肯定不会被打上重取标记，只可能是前一条指令被打上重取标记
);

assign is_branch[0] = |data_fifo[0].br_inst_sel;
assign is_branch[1] = |data_fifo[1].br_inst_sel;

/*ISS_ready_go的含义：
相当于iss_ready_go[0]了
当其为1时，说明发射阶段可以发射指令了，可能发射一条可能发射两条，但总之是可以发射指令了
*/

assign ISS_ready_go = iss_ready_go[0] && ~(|FU_pause) && ~ROB_pause /*&& ~csr_pause*/;   // 是不是只要有一条可以发射就行

//================================ 双发射判断逻辑 ================================ // 不对不对，还是不对，当单发射时，就应该让第二条指令直接无效，不然第二条指令也会造成阻塞
// 决定单发射还是双发射，看dequeue_en
// 当前阶段可以走，并且后一个阶段可以进，并且队列非空，数据出队列
/*想法：
第一条指令肯定要发射
遇到特权指令，就单发射，这样也确保了特权指令一定只会在第一条流水线（前一条指令）
*/

/* 目前遇到特权指令就单发射，因此无需考虑这两条指令间的csr冒险、中断冒险和tlbsrch冒险
csr冒险判断：前一条指令写csr，后一条指令读csr，且csr_num相同时，单发射
assign csr_HAZARD = (data_o[0].csr_num == data_o[1].csr_num) && data_o[0].csr_we && data_o[1].csr_re;

中断冒险判断：前一条指令写csr，并且csr_num为与中断相关的寄存器时，单发射
assign int_HAZARD = data_o[0].csr_write_int && data_o[0].csr_we;

tlbsrch冒险判断：前一条指令写ASID、TLBEHI，且后一条指令为tlbsrch时，把指令阻塞在ISS阶段
assign tlbsrch_HAZARD = data_o[0].csr_we && (data_o[0].csr_num == `ASID || data_o[0].csr_num == `TLBEHI) && data_o[1].tlbsrch_en;
*/

assign no_dispatch_two = //(data_o[0].mul_op[0] | data_o[0].div_op[0]) & (data_o[1].mul_op[0] | data_o[1].div_op[0]) | // 两条指令都是乘法指令或者除法指令
                         //(|data_fifo[0].br_inst_sel && |data_fifo[1].br_inst_sel) | // 同时有两条分支指令
                         //(branch_bus[0].redirect)  | // 第一条指令为分支跳转指令且分支预测错误时
                         (|is_branch[0]) | // 第一条指令为分支跳转指令时
                         (|is_privilege) | // 遇到特权指令，就单发射（ertn_flush的情况包含在内）
                         (data_o[0].ex | data_o[0].refetch_flush) // 第一条指令有异常、是ertn指令、打上重取标记时
                         ;

// assign dequeue_en[0] = ISS_ready_go && FU_allow_in && !empty; // 可以与原来的ISS_allow_in生成逻辑对照
// assign dequeue_en[1] = ISS_ready_go && FU_allow_in && !empty && !no_dispatch_two && iss_ready_go[1];
//================================ 出队使能逻辑 ================================
/*csr_buffer满的时候，不允许出队，当然这种情况基本没有可能出现
如果重取逻辑加上csr写指令的后一条指令都重取的话，那csr_buffer就反而没有作用了
*/
assign dequeue_en[0] = ISS_ready_go && (iss0_select_FU & FU_allow_in) && !empty && !redirect_flush;
// 后一条指令需要在前一条指令后发射，所以需要当dequeue_en[0]为1的时候，即前一条指令真发射的时候，后一条指令才可能发射，                写太长了！
assign dequeue_en[1] = ISS_ready_go && iss_ready_go[1] && (iss0_select_FU & FU_allow_in) && (iss1_select_FU & FU_allow_in)
                        && !empty & !no_dispatch_two && !one_left && !redirect_flush; // 队列中只有一条指令时，只允许一个指令发射

assign ISS_valid[0] = dequeue_en[0];
assign ISS_valid[1] = dequeue_en[1];
//================================ 输出数据生成逻辑 ================================
/*ISS和EXE通信总线*/
// assign ISS_EXE_bus[0] = data_o[0] & {$size(ISS_EXE_bus_t){dequeue_en[0]}};
// assign ISS_EXE_bus[1] = data_o[1] & {$size(ISS_EXE_bus_t){dequeue_en[1]}};
// 指令选择了几号FU & 指令是否出队，这个逻辑应该还有简化空间
assign ISS_EXE_bus[0] = (data_o[0] & {$size(ISS_EXE_bus_t){iss0_select_FU[0]}}) | (data_o[1] & {$size(ISS_EXE_bus_t){iss1_select_FU[0]}});
assign ISS_EXE_bus[1] = (data_o[0] & {$size(ISS_EXE_bus_t){iss0_select_FU[1]}}) | (data_o[1] & {$size(ISS_EXE_bus_t){iss1_select_FU[1]}});
assign ISS_EXE_bus[2] = (data_o[0] & {$size(ISS_EXE_bus_t){iss0_select_FU[2]}}) | (data_o[1] & {$size(ISS_EXE_bus_t){iss1_select_FU[2]}});
assign ISS_EXE_bus[3] = (data_o[0] & {$size(ISS_EXE_bus_t){iss0_select_FU[3]}}) | (data_o[1] & {$size(ISS_EXE_bus_t){iss1_select_FU[3]}});

logic [ISSUE_WIDTH-1:0] FU2_only;
assign FU2_only[0] = |data_o[0].inst_ld_en || |data_o[0].inst_st_en || is_privilege[0] || data_o[0].inst_ll_w || data_o[0].inst_sc_w || |data_o[0].op_timer_64; // 定时器指令需要读timer64的值，只能走FU2
assign FU2_only[1] = |data_o[1].inst_ld_en || |data_o[1].inst_st_en || is_privilege[1] || data_o[1].inst_ll_w || data_o[1].inst_sc_w || |data_o[1].op_timer_64; // 定时器指令需要读timer64的值，只能走FU2

assign BU_bus         = (BU_data_o[0] & {$size(BU_bus_t){iss0_select_FU[4]}}) | (BU_data_o[1] & {$size(BU_bus_t){iss1_select_FU[4]}});

always_comb begin
    if (FU2_only[0]) begin // 前一条指令是访存指令或特权指令或ll_w或sc_w指令或定时器指令
        if (~BU_pause) begin // BU中有指令时，不允许进入FU2
            iss0_select_FU = 5'b00100;
        end
        else begin
            iss0_select_FU = 5'b00000;
        end
    end
    else if (is_branch[0]) begin
        iss0_select_FU = 5'b10000;
    end
    else if (data_o[0].mul_op[0] || data_o[0].div_op[0]) begin // 前一条指令是乘除法指令
        if (~BU_pause) begin // BU中有指令时，不允许进入FU3
            iss0_select_FU = 5'b01000;
        end
        else begin
            iss0_select_FU = 5'b00000;
        end
    end
    else if (FU_allow_in[0]) begin // 0号FU可用
        iss0_select_FU = 5'b00001;
    end
    else if (FU_allow_in[1]) begin // 1号FU可用
        iss0_select_FU = 5'b00010;
    end
    else begin
        iss0_select_FU = 5'b00000;
    end
end

always_comb begin
    if (FU2_only[1]) begin // 后一条指令是访存指令或特权指令或ll_w或sc_w指令
        if (iss0_select_FU != 5'b00100 && ~BU_pause) begin // 规避了同时使用2号FU的情况（如同时两个访存指令）
            iss1_select_FU = 5'b00100;
        end
        else begin
            iss1_select_FU = 5'b00000;
        end
    end
    else if (is_branch[1]) begin
        if (iss0_select_FU != 5'b10000) begin
            iss1_select_FU = 5'b10000;
        end
        else begin
            iss1_select_FU = 5'b00000;
        end
    end
    else if (data_o[1].mul_op[0] || data_o[1].div_op[0]) begin
        if (iss0_select_FU != 5'b01000 && ~BU_pause) begin
            iss1_select_FU = 5'b01000;
        end
        else begin
            iss1_select_FU = 5'b00000;
        end
    end
    // else if (FU_allow_in[0]) begin // 0号FU不用看，因为如果0号FU可用，那肯定是给前一条指令用
    //     iss1_select_FU = 5'b00001;
    // end
    else if (FU_allow_in[1] && (iss0_select_FU != 5'b0010)) begin // 前一条指令选了1号FU，后一条指令就不能用了
        iss1_select_FU = 5'b00010;
    end
    else begin
        iss1_select_FU = 5'b00000;
    end
end
//================================ 重取控制逻辑 ================================
// 添加了状态机，在发射的时候检测next_need_refetch，检测到其为1时，状态进入REFETCH，让后面的指令打上重取标记
parameter IDLE      = 1'b0;
parameter REFETCH   = 1'b1;
always_ff @(posedge clk) begin : refetch_state_change
    if (reset || flush_sign) begin
        refetch_state <= IDLE;
    end
    else begin
        case (refetch_state)
            IDLE : begin
                if (dequeue_en[0] && data_o[0].next_need_refetch) begin // 指令流走时进行状态切换，只看0号指令，因为特权指令必定单发
                    refetch_state <= REFETCH;
                end
                else begin
                    refetch_state <= refetch_state;
                end
            end
            REFETCH : begin
                if (dequeue_en[0] && ISS_valid[0]) begin // 只看0号指令，因为refetch_flush也只打在0号指令
                    refetch_state <= IDLE;
                end
                else begin
                    refetch_state <= refetch_state;
                end
            end
        endcase
    end
end

// csr_cnt逻辑
// assign csr_increase_en = (dequeue_en[0] && data_o[0].csr_we) || (dequeue_en[1] && data_o[1].csr_we);

endmodule