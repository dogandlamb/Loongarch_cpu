`timescale 1ns / 1ps

`include "defines.vh"

module BPU (
    input  wire         cpu_clk    ,
    input  wire         cpu_rstn   ,
    input  wire [31:0]  if_pc      ,    // IF阶段的PC值
    input  wire         if_valid   ,    // IF阶段的有效信号
    input  wire         id_valid   ,    // ID阶段的有效信号
    input  wire         pl_suspend ,    // 流水线暂停信号
    // predict branch direction and target
    output wire [31:0]  pred_target,    // 预测的下一条指令地址
    output wire         pred_error ,    // 预测是否失败
    // signals to correct BHT
    input  wire         ex_valid   ,    // EX阶段的有效信号
    input  wire         ex_is_bj   ,    // EX阶段是否是条件分支或直接跳转指令
    input  wire [31:0]  ex_pc      ,    // EX阶段的PC值
    input  wire         real_taken ,    // EX阶段指令实际是否发生跳转
    input  wire [31:0]  real_target     // EX阶段指令发生跳转时的目标地址
);

`ifdef ENABLE_BPU

    // TODO

`else

    assign pred_target = if_pc + 32'h4;

    wire taken_error  = ex_is_bj & real_taken;
    wire target_error = 1'b0;
    assign pred_error = ex_valid & (taken_error | target_error);

`endif

endmodule
