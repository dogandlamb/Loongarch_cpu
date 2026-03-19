`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module commit
    import pipeline_types::*;
    import core_defines::*;
(
    //输入时钟和复位
    input  logic         clk ,
    input  logic         reset,
    //================================ 流水线握手信号 ================================
    output logic         commit_queue_full,
    //================================ 流水线间通信总线 ================================
    input  commit_bus_t [COMMIT_WIDTH-1:0] commit_bus,          //EXE送至MEM阶段信号

    //别忘了用于调试的信号，要不然仿真文件没处采样
    output logic [31:0] debug_wb_pc,       // 调试PC
    output logic [3:0]  debug_wb_rf_we,    // 调试寄存器写使能
    output logic [4:0]  debug_wb_rf_wnum,  // 调试寄存器编号
    output logic [31:0] debug_wb_rf_wdata, // 调试寄存器数据
    output logic [31:0] debug_wb_inst
);

wire            [COMMIT_WIDTH-1:0] enqueue_en;
commit_bus_t    [COMMIT_WIDTH-1:0] enqueue_data;
wire            [COMMIT_WIDTH-1:0] dequeue_en;
commit_bus_t    [COMMIT_WIDTH-1:0] dequeue_data;
wire                               empty;

assign enqueue_en[0]    = commit_bus[0].rf_we && !commit_queue_full; // 写回且队列不满时入队
assign enqueue_en[1]    = commit_bus[1].rf_we && !commit_queue_full; // 写回且队列不满时入队

assign enqueue_data[0]  = commit_bus[0];
assign enqueue_data[1]  = commit_bus[1];

ctrl_fifo #(
    .DATA_WIDTH($size(commit_bus_t))
) u_commit_queue (
    .clk           (clk),
    .reset         (reset),

    .enqueue_en     (enqueue_en),
    .enqueue_data   (enqueue_data),
    .dequeue_data   (dequeue_data),
    .dequeue_en     (dequeue_en),

    .empty          (empty),
    .full           (commit_queue_full)
);

assign dequeue_en[0] = !empty;
assign dequeue_en[1] = 1'b0;

commit_bus_t data_fifo; // 指令发射队列输出的数据，目前是单提交
assign data_fifo = dequeue_data[0] & {$size(commit_bus_t){!empty}}; // 当队列为空时，输出的数据无效
assign {
    debug_wb_pc,
    debug_wb_rf_we,
    debug_wb_rf_wnum,
    debug_wb_rf_wdata,
    debug_wb_inst
} = data_fifo;


endmodule