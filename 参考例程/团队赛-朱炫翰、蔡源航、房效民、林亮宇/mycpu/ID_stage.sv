`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module ID_stage
    import pipeline_types::*;
    import core_defines::*;
(
    //输入时钟和复位
    input  wire         clk ,
    input  wire         reset,
    //================================ 流水线握手信号 ================================
    //和IF阶段的流水线握手信号
    output wire         inst_buffer_full,       // 指令缓存队列已满，未满的时候就可以一直塞指令
    //和ISS阶段的流水线握手信号
    input  wire         RA_allow_in,       // 指令发射队列已满，未满的时候就可以一直塞指令
    //================================ 流水线间通信总线 ================================
    input  instr_info_t                     IF_ID_bus[FETCH_WIDTH],    //IF送至ID阶段信号
    input  logic                            IF_to_ID_valid,
    input  logic [$clog2(FETCH_WIDTH+1)-1:0]instr_buffer_length,
    output ID_RA_bus_t [DECODER_WIDTH-1:0]  ID_RA_bus,
    //================================ 与ROB的接口 ================================
    input  logic                            ROB_redirect_state, // 标志ROB在分支预测错误时是否清空完成
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    input  wire         flush_sign,
    input  wire         redirect
    );
//================================ 流水线控制寄存器 ================================
wire ID_ready_go; // ID阶段完成处理标志

//================================ 与前后流水级的通信 ================================
wire            [FETCH_WIDTH-1:0] enqueue_en;    // 暂时不用了，只用enqueue_length
instr_info_t    [FETCH_WIDTH-1:0] enqueue_data;
wire            [DECODER_WIDTH-1:0] dequeue_en;
instr_info_t    [DECODER_WIDTH-1:0] dequeue_data;
wire                                empty;
wire                                one_left;

logic [$clog2(FETCH_WIDTH+1)-1:0] enqueue_length;
assign enqueue_length = instr_buffer_length & {$clog2(FETCH_WIDTH+1){IF_to_ID_valid}} & {$clog2(FETCH_WIDTH+1){~inst_buffer_full}}; // 当valid为0时，enqueue_length为0

assign enqueue_en[0] = IF_ID_bus[0].valid & ~inst_buffer_full; // 数据有效且指令缓存队列不满时入队
assign enqueue_en[1] = IF_ID_bus[1].valid & ~inst_buffer_full; // 数据有效且指令缓存队列不满时入队
assign enqueue_en[2] = IF_ID_bus[2].valid & ~inst_buffer_full; // 数据有效且指令缓存队列不满时入队
assign enqueue_en[3] = IF_ID_bus[3].valid & ~inst_buffer_full; // 数据有效且指令缓存队列不满时入队


assign enqueue_data[0] = IF_ID_bus[0];
assign enqueue_data[1] = IF_ID_bus[1];
assign enqueue_data[2] = IF_ID_bus[2];
assign enqueue_data[3] = IF_ID_bus[3];

// 当前阶段可以走，并且后一个阶段可以进，并且指令缓存队列非空，数据出队列
assign dequeue_en[0]    = ID_ready_go & RA_allow_in & ~empty; // 可以与原来的ISS_allow_in生成逻辑对照
assign dequeue_en[1]    = ID_ready_go & RA_allow_in & ~empty & ~one_left;

//================================ FIFO，流水线控制寄存器 ================================ 
/*用发射队列作为流水线寄存器
1.队列没满时允许填入指令，并且填入的是有效数据，无效数据不填入
2.队列为空时输出数据无效，当ID_ready_go为1、指令发射队列未满且指令缓存队列非空时，输出数据
*/
inst_buffer #(
    .DATA_WIDTH($size(instr_info_t)),
    .DEPTH(16)
) u_inst_buffer (
    .clk            (clk),
    .reset          (reset),
    .flush          (flush_sign),
    .redirect       (redirect),

    .enqueue_en     (enqueue_en),
    .enqueue_data   (enqueue_data),
    .enqueue_length (enqueue_length),
    .instr_buffer_length (instr_buffer_length),

    .dequeue_data   (dequeue_data),
    .dequeue_en     (dequeue_en),

    .empty          (empty),
    .one_left       (one_left),
    .full           (inst_buffer_full)
);

instr_info_t [DECODER_WIDTH-1:0] data_fifo; // 输出的数据
assign data_fifo[0] = dequeue_data[0] & {$size(instr_info_t){~empty}}; // 当队列为空时，输出的数据无效
assign data_fifo[1] = dequeue_data[1] & {$size(instr_info_t){~empty}} & {$size(instr_info_t){~one_left}}; // 当队列为空时，输出的数据无效

//================================ 指令译码逻辑 ================================
decoder u_decoder0 (
    .ID_inst(data_fifo[0].inst),
    .IF_ex(data_fifo[0].ex),
    .IF_excp_num(data_fifo[0].excp_num),

    .ID_ready_go(ID_ready_go),
    .dequeue_en(dequeue_en[0]),
    .data_fifo(data_fifo[0]),
    .ID_RA_bus(ID_RA_bus[0])
);
decoder u_decoder1 (
    .ID_inst(data_fifo[1].inst),
    .IF_ex(data_fifo[1].ex),
    .IF_excp_num(data_fifo[1].excp_num),

    .ID_ready_go(ID_ready_go),
    .dequeue_en(dequeue_en[1]),
    .data_fifo(data_fifo[1]),
    .ID_RA_bus(ID_RA_bus[1])
);
//================================ 流水线控制 ================================

/* 阻塞情况：
1.当分支预测错误时，ID阶段的指令不能进入ISS阶段，于是阻塞ID阶段并在下一个周期清空ID阶段的数据
2.ROB在分支预测错误时还没清空完成，就阻塞ID阶段，不让指令进入RA阶段进行重命名和分发
*/
assign ID_ready_go     = 1'b1 && !redirect && ROB_redirect_state;

endmodule