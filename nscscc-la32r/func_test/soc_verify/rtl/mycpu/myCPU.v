`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rstn     ,
    input  wire         cpu_clk      ,

    // Instruction Fetch Interface
    output wire         ifetch_rreq  ,      // 取指请求, 取指时为1'b1
    output wire [31:0]  ifetch_addr  ,      // 指令地址
    input  wire         ifetch_valid ,      // 指令有效信号
    input  wire [31:0]  ifetch_inst  ,      // 指令机器码
    output wire         pred_error   ,      // 分支预测失败标志位信号
    
    // Data Access Interface
    output wire [ 3:0]  daccess_ren  ,      // 读使能, 发出读请求时置为4'hF
    output wire [31:0]  daccess_addr ,      // 读/写地址
    input  wire         daccess_valid,      // 读数据有效信号
    input  wire [31:0]  daccess_rdata,      // 读数据
    output wire [ 3:0]  daccess_wen  ,      // 写使能，支持字节使能
    output wire [31:0]  daccess_wdata,      // 写数据
    input  wire         daccess_wresp       // 写响应
);

    // pipeline control
    wire        pred_error   ;      // 分支预测失败标志位信号
    wire [31:0] pred_target  ;      // 分支预测目标地址
    wire        ldst_suspend ;      // 执行访存指令时的流水线暂停信号
    wire        ldst_done    ;      // 访存指令在MEM阶段访存完毕
    wire        ldst_unalign ;      // 访存指令的访存地址是否满足对齐条件
    wire [31:0] fd_rD1       ;      // 前递到ID阶段的源操作数1
    wire [31:0] fd_rD2       ;      // 前递到ID阶段的源操作数2
    wire        fd_rD1_sel   ;      // ID阶段的源操作数1选择信号（选择前递数据或源寄存器1的值）
    wire        fd_rD2_sel   ;      // ID阶段的源操作数2选择信号（选择前递数据或源寄存器2的值）
    
    // IF Stage
    wire        if_valid     ;      // IF阶段有效信号（有效表示当前有指令正处于IF阶段, 或IF阶段正在取指）
    wire [31:0] if_pc        ;      // IF阶段的PC值, 或取指的指令地址
    wire [31:0] if_npc       ;      // IF阶段的下一条指令PC值
    // ID stage
    wire        id_valid     ;      // ID阶段有效信号（有效表示当前有指令正处于ID阶段）
    wire [31:0] id_pc        ;      // ID阶段的PC值
    wire [ 1:0] id_npc_op    ;      // ID阶段的npc_op，用于控制下一条指令PC值的生成
    wire [ 4:0] id_rR1       ;      // 从指令码中解析出源寄存器1的编号/地址
    wire [ 4:0] id_rR2       ;      // 从指令码中解析出源寄存器2的编号/地址
    wire        id_rR1_re    ;      // ID阶段的源寄存器1读标志信号（有效时表示指令需要从源寄存器1读取操作数）
    wire        id_rR2_re    ;      // ID阶段的源寄存器2读标志信号（有效时表示指令需要从源寄存器2读取操作数）
    wire [31:0] id_ext       ;      // ID阶段的扩展后的立即数
    wire [31:0] id_real_rD1  ;      // ID阶段的源操作数1的实际值
    wire [31:0] id_real_rD2  ;      // ID阶段的源操作数2的实际值
    wire [ 4:0] id_alu_op    ;      // ID阶段的alu_op，用于控制ALU进行何种运算
    wire        id_alua_sel  ;      // ID阶段的ALU操作数A选择信号（选择源寄存器1的值或扩展后的立即数或其他）
    wire        id_alub_sel  ;      // ID阶段的ALU操作数B选择信号（选择源寄存器2的值或扩展后的立即数或其他）
    wire        id_rf_we     ;      // ID阶段的寄存器写使能（指令需要写回时rf_we为1）
    wire [ 4:0] id_wR        ;      // ID阶段的目标寄存器
    wire [ 1:0] id_wd_sel    ;      // ID阶段的写回数据选择（选择ALU执行结果写回，或选择访存数据写回，etc.）
    wire        id_is_ld_st  ;      // ID阶段是否是Load/Store指令
    wire [ 3:0] id_ram_we    ;      // ID阶段的主存写使能信号（针对store指令）
    wire [ 2:0] id_ram_ext_op;      // ID阶段的读主存数据扩展op，用于控制主存读回数据的扩展方式（针对load指令）
    wire        id_is_br_jmp ;      // ID阶段是否是条件分支或直接跳转指令
    // EX Stage
    wire        ex_valid     ;      // EX阶段有效信号（有效表示当前有指令正处于EX阶段）
    wire [31:0] ex_pc        ;      // EX阶段的PC值
    wire [ 1:0] ex_npc_op    ;      // EX阶段的npc_op，用于控制下一条指令PC值的生成
    wire [31:0] ex_rD1       ;      // EX阶段的源寄存器1的值
    wire [31:0] ex_rD2       ;      // EX阶段的源寄存器2的值
    wire [31:0] ex_ext       ;      // EX阶段的扩展后的立即数
    wire [31:0] ex_alu_C     ;      // EX阶段的ALU运算结果
    wire        ex_alu_f     ;      // EX阶段的标志位
    wire        ex_rf_we     ;      // EX阶段的寄存器写使能（指令需要写回时rf_we为1）
    wire [ 4:0] ex_wR        ;      // EX阶段的目的寄存器
    wire [ 1:0] ex_wd_sel    ;      // EX阶段的写回数据选择（选择ALU执行结果写回，或选择访存数据写回，etc.）
    wire [31:0] ex_wd        ;      // EX阶段的待写回数据
    wire        ex_is_ld_st  ;      // EX阶段是否是Load/Store指令
    wire [ 3:0] ex_ram_we    ;      // EX阶段的主存写使能信号（针对store指令）
    wire [ 2:0] ex_ram_ext_op;      // EX阶段的读主存数据扩展op，用于控制主存读回数据的扩展方式（针对load指令）
    wire        ex_sel_ram   ;      // EX阶段是否是访存指令 (特指Load指令, 用于Load-Use处理)
    wire        ex_is_br_jmp ;      // EX阶段是否是条件分支或直接跳转指令
    wire        ex_br_jmp_f  ;      // EX阶段分支跳转指令实际是否会发生跳转
    // MEM Stage
    wire        mem_valid    ;      // MEM阶段有效信号（有效表示当前有指令正处MEM阶段）
    wire [31:0] mem_pc       ;      // MEM阶段的PC值
    wire [31:0] mem_alu_C    ;      // MEM阶段的ALU运算结果
    wire [31:0] mem_ram_ext  ;      // MEM阶段经过扩展的读主存数据
    wire [31:0] mem_ext      ;      // MEM阶段的扩展后的立即数
    wire        mem_rf_we    ;      // MEM阶段的寄存器写使能（指令需要写回时rf_we为1）
    wire [ 4:0] mem_wR       ;      // MEM阶段的目的寄存器
    wire [ 1:0] mem_wd_sel   ;      // MEM阶段的写回数据选择（选择ALU执行结果写回，或选择访存数据写回，etc.）
    wire [31:0] mem_wd       ;      // MEM阶段的待写回数据
    // WB Stage
    wire        wb_valid     ;      // WB阶段有效信号（有效表示当前有指令正处于WB阶段）
    wire [31:0] wb_pc        ;      // WB阶段的PC值
    wire        wb_rf_we     ;      // WB阶段的寄存器写使能
    wire [ 4:0] wb_wR        ;      // WB阶段的目的寄存器
    wire [31:0] wb_wd        ;      // WB阶段的写回数据

    wire        pl_suspend    = ldst_suspend;       // 流水线暂停信号
    // 出现多周期指令(访存、乘除法)暂停取指, 多周期操作结束后继续取指
    wire        pause_ifetch  = (ldst_suspend | id_is_ld_st | ex_is_ld_st) & !ldst_done;
    wire        resume_ifetch = ldst_done;          // 恢复取指
    
    BPU u_BPU (
        .cpu_clk        (cpu_clk      ),
        .cpu_rstn       (cpu_rstn     ),
        .if_pc          (if_pc        ),
        .if_valid       (if_valid     ),
        .id_valid       (id_valid     ),
        .pl_suspend     (pl_suspend   ),
        // predicted branch dir. and target
        .pred_target    (pred_target  ),
        .pred_error     (pred_error   ),
        // real dir. and target
        .ex_valid       (ex_valid     ),
        .ex_is_bj       (ex_is_br_jmp ),
        .ex_pc          (ex_pc        ),
        .real_taken     (ex_br_jmp_f  ),
        .real_target    (if_npc       )
    );

    IF_stage IF (
        .cpu_rstn       (cpu_rstn     ),
        .cpu_clk        (cpu_clk      ),
        // pipeline control
        .pause_ifetch   (pause_ifetch ),
        .resume_ifetch  (resume_ifetch),
        .pl_suspend     (pl_suspend   ),
        // From BPU
        .pred_error     (pred_error   ),
        .pred_target    (pred_target  ),
        // From other stages
        .id_valid       (id_valid     ),
        .ex_valid       (ex_valid     ),
        .ex_npc_op      (ex_npc_op    ),
        .ex_pc          (ex_pc        ),
        .ex_rD1         (ex_rD1       ),
        .ex_ext         (ex_ext       ),
        .ex_alu_f       (ex_alu_f     ),
        // To ID
        .if_valid       (if_valid     ),
        .if_pc          (if_pc        ),
        .if_npc         (if_npc       ),
        // Instruction Fetch Interface
        .ifetch_rreq    (ifetch_rreq  ),
        .ifetch_addr    (ifetch_addr  ),
        .ifetch_valid   (ifetch_valid )
    );

    ID_stage ID (
        .cpu_rstn       (cpu_rstn     ),
        .cpu_clk        (cpu_clk      ),
        // pipeline control
        .pl_suspend     (pl_suspend   ),
        .pred_error     (pred_error   ),
        .fd_rD1_sel     (fd_rD1_sel   ),
        .fd_rD1         (fd_rD1       ),
        .fd_rD2_sel     (fd_rD2_sel   ),
        .fd_rD2         (fd_rD2       ),
        // From IF and WB
        .if_valid       (if_valid     ),
        .if_pc          (if_pc        ),
        .if_npc         (if_npc       ),
        .wb_rf_we       (wb_rf_we     ),
        .wb_wR          (wb_wR        ),
        .wb_wd          (wb_wd        ),
        // To IF
        .id_is_ld_st    (id_is_ld_st  ),
        // To EX
        .id_valid       (id_valid     ),
        .id_pc          (id_pc        ),
        .id_npc_op      (id_npc_op    ),
        .id_ext         (id_ext       ),
        .id_real_rD1    (id_real_rD1  ),
        .id_real_rD2    (id_real_rD2  ),
        .id_alu_op      (id_alu_op    ),
        .id_alua_sel    (id_alua_sel  ),
        .id_alub_sel    (id_alub_sel  ),
        .id_rf_we       (id_rf_we     ),
        .id_wR          (id_wR        ),
        .id_wd_sel      (id_wd_sel    ),
        .id_ram_we      (id_ram_we    ),
        .id_ram_ext_op  (id_ram_ext_op),
        .id_is_br_jmp   (id_is_br_jmp ),
        // Data Forward
        .id_rR1         (id_rR1       ),
        .id_rR1_re      (id_rR1_re    ),
        .id_rR2         (id_rR2       ),
        .id_rR2_re      (id_rR2_re    ),
        // Instruction Fetch Interface
        .ifetch_valid   (ifetch_valid ),
        .ifetch_inst    (ifetch_inst  )
    );

    EX_stage EX (
        .cpu_rstn       (cpu_rstn     ),
        .cpu_clk        (cpu_clk      ),
        // pipeline control
        .pl_suspend     (pl_suspend   ),
        .ldst_unalign   (ldst_unalign ),
        // From ID
        .id_valid       (id_valid     ),
        .id_pc          (id_pc        ),
        .id_npc_op      (id_npc_op    ),
        .id_ext         (id_ext       ),
        .id_real_rD1    (id_real_rD1  ),
        .id_real_rD2    (id_real_rD2  ),
        .id_alu_op      (id_alu_op    ),
        .id_alua_sel    (id_alua_sel  ),
        .id_alub_sel    (id_alub_sel  ),
        .id_rf_we       (id_rf_we     ),
        .id_wR          (id_wR        ),
        .id_wd_sel      (id_wd_sel    ),
        .id_ram_we      (id_ram_we    ),
        .id_ram_ext_op  (id_ram_ext_op),
        .id_is_br_jmp   (id_is_br_jmp ),
        // To IF
        .ex_npc_op      (ex_npc_op    ),
        .ex_alu_f       (ex_alu_f     ),
        .ex_is_ld_st    (ex_is_ld_st  ),
        .ex_is_br_jmp   (ex_is_br_jmp ),
        .ex_br_jmp_f    (ex_br_jmp_f  ),
        // To MEM
        .ex_valid       (ex_valid     ),
        .ex_wR          (ex_wR        ),
        .ex_pc          (ex_pc        ),
        .ex_alu_C       (ex_alu_C     ),
        .ex_rD1         (ex_rD1       ),
        .ex_rD2         (ex_rD2       ),
        .ex_ext         (ex_ext       ),
        .ex_rf_we       (ex_rf_we     ),
        .ex_wd_sel      (ex_wd_sel    ),
        .ex_ram_we      (ex_ram_we    ),
        .ex_ram_ext_op  (ex_ram_ext_op),
        // Data Forward
        .ex_wd          (ex_wd        ),
        .ex_sel_ram     (ex_sel_ram   )
    );

    MEM_stage MEM (
        .cpu_rstn       (cpu_rstn     ),
        .cpu_clk        (cpu_clk      ),
        // pipeline control
        .pl_suspend     (pl_suspend   ),
        .ldst_suspend   (ldst_suspend ),
        .ldst_done      (ldst_done    ),
        .ldst_unalign   (ldst_unalign ),
        // From EX
        .ex_valid       (ex_valid     ),
        .ex_pc          (ex_pc        ),
        .ex_rD2         (ex_rD2       ),
        .ex_ext         (ex_ext       ),
        .ex_alu_C       (ex_alu_C     ),
        .ex_rf_we       (ex_rf_we     ),
        .ex_wR          (ex_wR        ),
        .ex_wd_sel      (ex_wd_sel    ),
        .ex_ram_we      (ex_ram_we    ),
        .ex_ram_ext_op  (ex_ram_ext_op),
        // To WB
        .mem_valid      (mem_valid    ),
        .mem_pc         (mem_pc       ),
        .mem_ext        (mem_ext      ),
        .mem_alu_C      (mem_alu_C    ),
        .mem_ram_ext    (mem_ram_ext  ),
        .mem_rf_we      (mem_rf_we    ),
        .mem_wR         (mem_wR       ),
        .mem_wd_sel     (mem_wd_sel   ),
        // Data Forward
        .mem_wd         (mem_wd       ),
        // Data Access Interface
        .daccess_ren    (daccess_ren  ),
        .daccess_addr   (daccess_addr ),
        .daccess_valid  (daccess_valid),
        .daccess_rdata  (daccess_rdata),
        .daccess_wen    (daccess_wen  ),
        .daccess_wdata  (daccess_wdata),
        .daccess_wresp  (daccess_wresp)
    );

    WB_stage WB (
        .cpu_rstn       (cpu_rstn     ),
        .cpu_clk        (cpu_clk      ),
        // pipeline control
        .pl_suspend     (pl_suspend   ),
        // From MEM
        .mem_valid      (mem_valid    ),
        .mem_pc         (mem_pc       ),
        .mem_ext        (mem_ext      ),
        .mem_alu_C      (mem_alu_C    ),
        .mem_ram_ext    (mem_ram_ext  ),
        .mem_rf_we      (mem_rf_we    ),
        .mem_wR         (mem_wR       ),
        .mem_wd_sel     (mem_wd_sel   ),
        // To ID
        .wb_rf_we       (wb_rf_we     ),
        .wb_wR          (wb_wR        ),
        .wb_wd          (wb_wd        ),
        // Trace Debug
        .wb_valid       (wb_valid     ),
        .wb_pc          (wb_pc        )
    );

    // Data Hazard Detection & Data Forward
    data_forward u_DF (
        .id_rR1         (id_rR1       ),
        .id_rR2         (id_rR2       ),
        .id_rR1_re      (id_rR1_re    ),
        .id_rR2_re      (id_rR2_re    ),
        .ex_we          (ex_rf_we & ex_valid),
        .ex_wr          (ex_wR        ),
        .ex_wd          (ex_wd        ),
        .mem_we         (mem_rf_we    ),
        .mem_wr         (mem_wR       ),
        .mem_wd         (mem_wd       ),
        .wb_we          (wb_rf_we     ),
        .wb_wr          (wb_wR        ),
        .wb_wd          (wb_wd        ),

        .fd_rD1_sel     (fd_rD1_sel   ),
        .fd_rD1         (fd_rD1       ),
        .fd_rD2_sel     (fd_rD2_sel   ),
        .fd_rD2         (fd_rD2       )
    );


    ///////////////////////////////////////////////////////////////////////////
    // Trace Debug Interface
    // RegisterFile Write
    wire [31:0] debug_wb_pc       = wb_pc;              // WB阶段PC值
    wire [ 3:0] debug_wb_rf_we    = {4{wb_rf_we}};      // WB阶段的寄存器堆写使能
    wire [ 4:0] debug_wb_rf_rd    = wb_wR;              // WB阶段被写的寄存器的编号/地址
    wire [31:0] debug_wb_rf_wdata = wb_wd;              // WB阶段写入寄存器的数据值

    // Memory Data Write
    wire [31:0] debug_wdata_pc   = mem_pc;              // 发起写访存的流水线阶段的PC值（此处为MEM阶段）
    wire [ 3:0] debug_wdata_we   = daccess_wen;         // 写使能
    wire [31:0] debug_wdata_addr = daccess_addr;        // 写地址
    wire [31:0] debug_wdata      = daccess_wdata;       // 写数据

    // Branch & Jump
    wire [31:0] debug_bj_pc      = ex_pc;                       // 确定跳转方向和目标地址的阶段的PC值（此处为EX阶段）
    wire        debug_bj_taken   = ex_is_br_jmp & ex_br_jmp_f;  // 发生跳转时有效
    wire [31:0] debug_bj_target  = if_npc;                      // 跳转时的目标地址
    ///////////////////////////////////////////////////////////////////////////

endmodule
