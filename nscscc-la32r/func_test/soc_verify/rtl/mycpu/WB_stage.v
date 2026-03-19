`timescale 1ns / 1ps

`include "defines.vh"

module WB_stage (
    input  wire         cpu_rstn     ,
    input  wire         cpu_clk      ,
    // pipeline control
    input  wire         pl_suspend   ,      // 流水线暂停信号
    // From MEM
    input  wire         mem_valid    ,      // MEM阶段有效信号
    input  wire [31:0]  mem_pc       ,      // MEM阶段的PC值
    input  wire [31:0]  mem_ext      ,      // MEM阶段的扩展后的立即数
    input  wire [31:0]  mem_alu_C    ,      // MEM阶段的ALU运算结果
    input  wire [31:0]  mem_ram_ext  ,      // MEM阶段经过扩展的读主存数据
    input  wire         mem_rf_we    ,      // MEM阶段的寄存器写使能（指令需要写回时rf_we为1）
    input  wire [ 4:0]  mem_wR       ,      // MEM阶段的目的寄存器
    input  wire [ 1:0]  mem_wd_sel   ,      // MEM阶段的写回数据选择（选择ALU执行结果写回，或选择访存数据写回，etc.）
    // To ID
    output wire         wb_rf_we     ,      // WB阶段的寄存器写使能（指令需要写回时rf_we为1）
    output wire [ 4:0]  wb_wR        ,      // WB阶段的目的寄存器
    output reg  [31:0]  wb_wd        ,      // WB阶段的待写回数据
    // Debug
    output wire         wb_valid     ,      // WB阶段有效信号
    output wire [31:0]  wb_pc               // WB阶段的PC值
);

    wire [31:0] wb_alu_C;
    wire [31:0] wb_ram_ext;
    wire [31:0] wb_ext;
    wire [ 1:0] wb_wd_sel;

    MEM_WB u_MEM_WB(
        .cpu_clk        (cpu_clk),
        .cpu_rstn       (cpu_rstn),
        .suspend        (pl_suspend),
        .valid_in       (mem_valid),

        .wR_in          (mem_wR),
        .pc_in          (mem_pc),
        .alu_C_in       (mem_alu_C),
        .ram_ext_in     (mem_ram_ext),
        .ext_in         (mem_ext),

        .rf_we_in       (mem_rf_we),
        .wd_sel_in      (mem_wd_sel),

        .valid_out      (wb_valid),
        .wR_out         (wb_wR),
        .pc_out         (wb_pc),
        .alu_C_out      (wb_alu_C),
        .ram_ext_out    (wb_ram_ext),
        .ext_out        (wb_ext),

        .rf_we_out      (wb_rf_we),
        .wd_sel_out     (wb_wd_sel)
    );

    always @(*) begin
        case (wb_wd_sel)
            `WD_RAM: wb_wd = wb_ram_ext;
            `WD_ALU: wb_wd = wb_alu_C;
            default: wb_wd = 32'haabbccdd;
        endcase
    end

endmodule
