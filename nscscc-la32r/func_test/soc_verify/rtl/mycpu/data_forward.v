`timescale 1ns / 1ps

`include "defines.vh"

module data_forward (
    input  wire [ 4:0]  id_rR1   ,      // ID阶段是源寄存器1
    input  wire [ 4:0]  id_rR2   ,      // ID阶段是源寄存器2
    input  wire         id_rR1_re,      // ID阶段是否读取了源寄存器1
    input  wire         id_rR2_re,      // ID阶段是否读取了源寄存器2

    input  wire         ex_we    ,      // EX阶段的寄存器堆写使能信号
    input  wire [ 4:0]  ex_wr    ,      // EX阶段的目的寄存器
    input  wire [31:0]  ex_wd    ,      // EX阶段的写回数据

    input  wire         mem_we   ,      // MEM阶段的寄存器堆写使能信号
    input  wire [ 4:0]  mem_wr   ,      // MEM阶段的目的寄存器
    input  wire [31:0]  mem_wd   ,      // MEM阶段的写回数据

    input  wire         wb_we    ,      // WB阶段的寄存器堆写使能信号
    input  wire [ 4:0]  wb_wr    ,      // WB阶段的目的寄存器
    input  wire [31:0]  wb_wd    ,      // WB阶段的写回数据

    // input  wire         ex_sel_ram    ,     // EX阶段是否是Load指令
    // input  wire         suspend_finish,     // 流水线暂停结束
    // output wire         load_use      ,     // 检测到Load-Use冒险的标志位

    output wire         fd_rD1_sel,     // 前递到ID阶段的源操作数1的数据选择信号
    output reg  [31:0]  fd_rD1    ,     // 前递到ID阶段的源操作数1
    output wire         fd_rD2_sel,     // 前递到ID阶段的源操作数2的数据选择信号
    output reg  [31:0]  fd_rD2          // 前递到ID阶段的源操作数2
);

    // rR1 RAW
    wire raw_rR1_id_ex  = (id_rR1 == ex_wr ) & id_rR1_re & ex_we  & (id_rR1 != 5'h0);
    wire raw_rR1_id_mem = (id_rR1 == mem_wr) & id_rR1_re & mem_we & (id_rR1 != 5'h0);
    wire raw_rR1_id_wb  = (id_rR1 == wb_wr ) & id_rR1_re & wb_we  & (id_rR1 != 5'h0);

    // rR2 RAW
    wire raw_rR2_id_ex  = (id_rR2 == ex_wr ) & id_rR2_re & ex_we  & (id_rR2 != 5'h0);
    wire raw_rR2_id_mem = (id_rR2 == mem_wr) & id_rR2_re & mem_we & (id_rR2 != 5'h0);
    wire raw_rR2_id_wb  = (id_rR2 == wb_wr ) & id_rR2_re & wb_we  & (id_rR2 != 5'h0);

    assign fd_rD1_sel   = raw_rR1_id_ex | raw_rR1_id_mem | raw_rR1_id_wb;
    assign fd_rD2_sel   = raw_rR2_id_ex | raw_rR2_id_mem | raw_rR2_id_wb;

    always @(*) begin
        if      (id_rR1 == 5'h0) fd_rD1 = 32'h0;
        // else if (raw_rR1_id_ex ) fd_rD1 = ex_sel_ram ? (suspend_finish ? mem_wd : 32'h0) : ex_wd;
        // else if (raw_rR1_id_ex ) fd_rD1 = ex_sel_ram ? mem_wd : ex_wd;
        else if (raw_rR1_id_ex ) fd_rD1 = ex_wd;
        else if (raw_rR1_id_mem) fd_rD1 = mem_wd;
        else if (raw_rR1_id_wb ) fd_rD1 = wb_wd;
        else                     fd_rD1 = 32'h0;
    end

    always @(*) begin
        if      (id_rR2 == 5'h0) fd_rD2 = 32'h0;
        // else if (raw_rR2_id_ex ) fd_rD2 = ex_sel_ram ? (suspend_finish ? mem_wd : 32'h0) : ex_wd;
        // else if (raw_rR2_id_ex ) fd_rD2 = ex_sel_ram ? mem_wd : ex_wd;
        else if (raw_rR2_id_ex ) fd_rD2 = ex_wd;
        else if (raw_rR2_id_mem) fd_rD2 = mem_wd;
        else if (raw_rR2_id_wb ) fd_rD2 = wb_wd;
        else                     fd_rD2 = 32'h0;
    end

    // Load-Use
    // wire rR1_load_use = raw_rR1_id_ex & ex_sel_ram;
    // wire rR2_load_use = raw_rR2_id_ex & ex_sel_ram;

    // assign load_use   = rR1_load_use | rR2_load_use;

endmodule