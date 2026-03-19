`timescale 1ns / 1ps

`include "defines.vh"

module MEM_stage (
    input  wire         cpu_rstn     ,
    input  wire         cpu_clk      ,
    // pipeline control
    input  wire         pl_suspend   ,      // 流水线暂停信号
    output wire         ldst_suspend ,      // 访存引起的流水线暂停信号
    output wire         ldst_done    ,      // 访存完成的标志位信号
    input  wire         ldst_unalign ,      // 访存地址是否满足对齐条件
    // From EX
    input  wire         ex_valid     ,      // EX阶段有效信号
    input  wire [31:0]  ex_pc        ,      // EX阶段PC值
    input  wire [31:0]  ex_rD2       ,      // EX阶段的源寄存器2的值
    input  wire [31:0]  ex_ext       ,      // EX阶段的扩展后的立即数
    input  wire [31:0]  ex_alu_C     ,      // EX阶段的ALU运算结果
    input  wire         ex_rf_we     ,      // EX阶段的寄存器写使能（指令需要写回时rf_we为1）
    input  wire [ 4:0]  ex_wR        ,      // EX阶段的目的寄存器
    input  wire [ 1:0]  ex_wd_sel    ,      // EX阶段的写回数据选择（选择ALU执行结果写回，或选择访存数据写回，etc.）
    input  wire [ 3:0]  ex_ram_we    ,      // EX阶段的主存写使能信号（针对store指令）
    input  wire [ 2:0]  ex_ram_ext_op,      // EX阶段的读主存数据扩展op，用于控制主存读回数据的扩展方式（针对load指令）
    // To WB
    output wire         mem_valid    ,      // MEM阶段有效信号
    output wire [31:0]  mem_pc       ,      // MEM阶段PC值
    output wire [31:0]  mem_ext      ,      // MEM阶段的扩展后的立即数
    output wire [31:0]  mem_alu_C    ,      // MEM阶段的ALU运算结果
    output wire [31:0]  mem_ram_ext  ,      // MEM阶段经过扩展的读主存数据
    output wire         mem_rf_we    ,      // MEM阶段的寄存器写使能（指令需要写回时rf_we为1）
    output wire [ 4:0]  mem_wR       ,      // MEM阶段的目的寄存器
    output wire [ 1:0]  mem_wd_sel   ,      // MEM阶段的写回数据选择（选择ALU执行结果写回，或选择访存数据写回，etc.）
    // Data Forward
    output reg  [31:0]  mem_wd       ,      // MEM阶段的待写回数据
    // Data Access Interface
    output wire [ 3:0]  daccess_ren  ,      // 读使能, 发出读请求时置为4'hF
    output wire [31:0]  daccess_addr ,      // 读/写地址
    input  wire         daccess_valid,      // 读数据有效信号
    input  wire [31:0]  daccess_rdata,      // 读数据
    output wire [ 3:0]  daccess_wen  ,      // 写使能，支持字节使能
    output wire [31:0]  daccess_wdata,      // 写数据
    input  wire         daccess_wresp       // 写响应
);

    wire [31:0] mem_rD2;
    wire [ 2:0] mem_ram_ext_op;
    wire [ 3:0] mem_ram_we;

    reg    mem_is_ld_st;    // MEM Stage is load or store
    assign ldst_done    = mem_is_ld_st & (daccess_valid | daccess_wresp);
    assign ldst_suspend = mem_is_ld_st & !ldst_done;

    always @(posedge cpu_clk or negedge cpu_rstn) begin
        if (!cpu_rstn)
            mem_is_ld_st <= 1'b0;
        else if (daccess_valid | daccess_wresp)
            mem_is_ld_st <= 1'b0;
        else if (ex_valid & (ex_wd_sel == `WD_RAM) & !ldst_unalign)
            mem_is_ld_st <= 1'b1;
    end

    EX_MEM u_EX_MEM (
        .cpu_clk        (cpu_clk),
        .cpu_rstn       (cpu_rstn),
        .suspend        (pl_suspend),
        .valid_in       (ex_valid),

        .wR_in          (ex_wR),
        .pc_in          (ex_pc),
        .alu_C_in       (ex_alu_C & {32{ex_valid}}),
        .rD2_in         (ex_rD2),
        .ext_in         (ex_ext),

        .rf_we_in       (ex_rf_we & !ldst_unalign),
        .wd_sel_in      (ex_wd_sel),
        .ram_we_in      (ex_ram_we),
        .ram_ext_op_in  (ex_ram_ext_op),

        .valid_out      (mem_valid),
        .wR_out         (mem_wR),
        .pc_out         (mem_pc),
        .alu_C_out      (mem_alu_C),
        .rD2_out        (mem_rD2),
        .ext_out        (mem_ext),

        .rf_we_out      (mem_rf_we),
        .wd_sel_out     (mem_wd_sel),
        .ram_we_out     (mem_ram_we),
        .ram_ext_op_out (mem_ram_ext_op)
    );

    // Extend memory read data
    RAM_EXT u_RAM_EXT (
        .ram_ext_op     (mem_ram_ext_op),
        .byte_offset    (mem_alu_C[1:0]),
        .din            (daccess_rdata ),
        .ext_out        (mem_ram_ext   )
    );
    
    always @(*) begin
        case (mem_wd_sel)
            `WD_RAM: mem_wd = mem_ram_ext;
            `WD_ALU: mem_wd = mem_alu_C;
            default: mem_wd = 32'h87654321;
        endcase
    end

    // Generate load/store requests
    MEM_REQ u_MEM_REQ (
        .clk            (cpu_clk       ),
        .rstn           (cpu_rstn      ),
        .ex_valid       (ex_valid      ),
        .ldst_suspend   (ldst_suspend  ),
        .mem_wd_sel     (mem_wd_sel    ),
        .mem_ram_addr   (mem_alu_C     ),

        .mem_ram_ext_op (mem_ram_ext_op),
        .da_ren         (daccess_ren   ),
        .da_addr        (daccess_addr  ),

        .mem_ram_we     (mem_ram_we    ),
        .mem_ram_wdata  (mem_rD2       ),
        .da_wen         (daccess_wen   ),
        .da_wdata       (daccess_wdata )
    );

endmodule
