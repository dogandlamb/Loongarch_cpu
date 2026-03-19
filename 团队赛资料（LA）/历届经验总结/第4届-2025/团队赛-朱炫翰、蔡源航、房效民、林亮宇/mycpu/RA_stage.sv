`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module RA_stage
    import pipeline_types::*;
    import core_defines::*;
(
    //输入时钟和复位
    input  wire         clk ,
    input  wire         reset,
    //================================ 流水线握手信号 ================================
    output wire         RA_allow_in,
    input  wire         issue_queue_full,       // 指令发射队列已满，未满的时候就可以一直塞指令
    //================================ 流水线间通信总线 ================================
    input  ID_RA_bus_t  [DECODER_WIDTH-1:0] ID_RA_bus,    //ID送至RA阶段信号
    output logic        [DECODER_WIDTH-1:0] enqueue_en,   // 指令进入发射队列的使能，同时进入ROB，既给ISS，也给ROB
    output IQ_t         [DECODER_WIDTH-1:0] IQ_enqueue_data,
    output ROB_t        [DECODER_WIDTH-1:0] ROB_enqueue_data,
    //================================ 与RAT的接口 ================================
    // 读
    output logic [DECODER_WIDTH-1:0][ 4:0] src1_addr,
    output logic [DECODER_WIDTH-1:0][ 4:0] src2_addr,
    input  logic [DECODER_WIDTH-1:0]                        src1_valid,
    input  logic [DECODER_WIDTH-1:0]                        src2_valid,
    input  logic [DECODER_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0] src1_prf,
    input  logic [DECODER_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0] src2_prf,
    // 写
    output logic [DECODER_WIDTH-1:0]                         we,       //write enable, HIGH valid
    output logic [DECODER_WIDTH-1:0][ 4:0]                   waddr,
    output logic [DECODER_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0]  wprf,
    //================================ 与ROB的接口 ================================
    input  logic [$clog2(ROB_DEPTH) - 1:0] ROB_tail, // ROB的下一个空位
    input  logic [$clog2(ROB_DEPTH) - 1:0] ROB_tail_plus, // ROB的下下一个空位
    input  logic                           ROB_full, // ROB是否已满
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    input  wire         flush_sign,
    input  wire         redirect
    );

logic [DECODER_WIDTH-1:0] RA_valid;
logic [DECODER_WIDTH-1:0] ra_ready_go;
logic                     RA_ready_go;

ra u_ra0 (
    //输入时钟和复位
    .clk                (clk),
    .reset              (reset),
    //================================ 模块准备信号 ================================
    .RA_valid           (RA_valid[0]),
    .ra_ready_go        (ra_ready_go[0]),
    .RA_ready_go        (RA_ready_go),
    //================================ 流水线握手信号 ================================
    .RA_allow_in        (RA_allow_in),
    //================================ 流水线间通信总线 ================================
    .ID_RA_bus          (ID_RA_bus[0]),    //ID送至RA阶段信号
    .IQ_enqueue_data    (IQ_enqueue_data[0]),
    .ROB_enqueue_data   (ROB_enqueue_data[0]),
    //================================ 与RAT的接口 ================================
    // 读
    .src1_addr          (src1_addr[0]),
    .src2_addr          (src2_addr[0]),
    .src1_valid         (src1_valid[0]),
    .src2_valid         (src2_valid[0]),
    .src1_prf           (src1_prf[0]),
    .src2_prf           (src2_prf[0]),
    // 写
    .we                 (we[0]),       //write enable, HIGH valid
    .waddr              (waddr[0]),
    .wprf               (wprf[0]),
    //================================ 与ROB的接口 ================================
    .ROB_idx            (ROB_tail),
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    .flush_sign         (flush_sign),
    .redirect           (redirect)
);

ra u_ra1 (
    //输入时钟和复位
    .clk                (clk),
    .reset              (reset),
    //================================ 模块准备信号 ================================
    .RA_valid           (RA_valid[1]),
    .ra_ready_go        (ra_ready_go[1]),
    .RA_ready_go        (RA_ready_go),
    //================================ 流水线握手信号 ================================
    .RA_allow_in        (RA_allow_in),
    //================================ 流水线间通信总线 ================================
    .ID_RA_bus          (ID_RA_bus[1]),    //ID送至RA阶段信号
    .IQ_enqueue_data    (IQ_enqueue_data[1]),
    .ROB_enqueue_data   (ROB_enqueue_data[1]),
    //================================ 与RAT的接口 ================================
    // 读
    .src1_addr          (src1_addr[1]),
    .src2_addr          (src2_addr[1]),
    .src1_valid         (src1_valid[1]),
    .src2_valid         (src2_valid[1]),
    .src1_prf           (src1_prf[1]),
    .src2_prf           (src2_prf[1]),
    // 写
    .we                 (we[1]),       //write enable, HIGH valid
    .waddr              (waddr[1]),
    .wprf               (wprf[1]),
    //================================ 与ROB的接口 ================================
    .ROB_idx            (ROB_tail_plus),
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    .flush_sign         (flush_sign),
    .redirect           (redirect)
);

assign RA_ready_go = (~RA_valid[0] | ra_ready_go[0]) & (~RA_valid[1] | ra_ready_go[1]);
// 第一条指令无效或者ready_go，且第二条指令无效或者ready_go，且后一阶段允许进入时，RA阶段允许进入
assign RA_allow_in = RA_ready_go & ~issue_queue_full & ~ROB_full;

// IQ_enqueue_data.valid:输出的数据中的valid信号，valid信号附在指令数据上
assign enqueue_en[0] = IQ_enqueue_data[0].valid & RA_allow_in; // 数据有效且队列不满时入队
assign enqueue_en[1] = IQ_enqueue_data[1].valid & RA_allow_in; // 数据有效且队列不满时入队

endmodule