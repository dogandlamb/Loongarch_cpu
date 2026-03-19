`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
`include "bpu_defines.sv"
module EXE_stage // store指令、TLB指令、cacop指令放到WB阶段执行
    import pipeline_types::*;
    import core_defines::*;
    import bpu_defines::*;
#(
    parameter TLBNUM = 8
) (
    //输入时钟和复位
    input  logic     clk ,
    input  logic     reset,
    //================================ 流水线握手信号 ================================
    input  logic                WB_allow_in,             //WB阶段可以输入
    output logic [FU_NUM-1:0]   FU_allow_in,             //EXE阶段可以输入
    //================================ 流水线间通信总线 ================================
    //ISS和EXE的通信
    input  ISS_EXE_bus_t [FU_NUM-BU_NUM-1:0]ISS_EXE_bus ,
    input  BU_bus_t                         BU_bus,
    //================================ 执行阶段（结束时）的写ROB端口 ================================
    output logic [FU_NUM-1:0]                           complete_en,
    output logic [FU_NUM-1:0][$clog2(ROB_DEPTH)-1:0]    complete_addr,
    output ROB_t [FU_NUM-1:0]                           FU_WB_bus,
    //================================ 数据存储器接口 ================================
    //与数据ram进行通信的信号，向数据ram发送读取或者写入请求
 	output logic        data_sram_req,     // 数据SRAM请求
    output logic [19:0] dcache_tag,
    output logic [ 7:0] dcache_index,
    output logic [ 3:0] dcache_offset,
    output logic        data_sram_wr,      // 数据SRAM写使能
    output logic [3:0]  data_sram_wstrb,   // 字节写使能
    output logic [1:0]  data_sram_size,    // 访问大小(00:1B, 01:2B, 10:4B)
    output logic [31:0] data_sram_wdata,   // 写数据
    input  logic        data_sram_addr_ok, // 地址接收就绪
    //================================ 连接乘除法模块接口 ================================
    output logic        mul_signed,    // 有符号乘法
    output logic [31:0] mul_scr1,      // 乘法操作数1
    output logic [31:0] mul_scr2,      // 乘法操作数2
    output logic        res_from_div,   // 结果来自除法
    output logic        div_signed,     // 有符号除法
    output logic [31:0] div_scr1,      // 除法操作数1
    output logic [31:0] div_scr2,      // 除法操作数2
    input  logic        div_complete,   // 除法完成
    //================================ CSR接口 ================================
    // 与csr通信的信号，只需要读相关信号
    output logic        EXE_csr_re,  // 实际上这个信号不需要，因为读是组合逻辑
    output logic [13:0] EXE_csr_num, // 这个还要数据前递
    input  logic [31:0] csr_rdata,
    input  logic [63:0] timer_64_rdata, // 从定时器读出的数据，定时器写在csr中
    input  logic        llbit,       // 用于原子访存指令sc.w
    input  logic [27:0] lladdr,      // 用于原子访存指令sc.w
    //================================ 前递暂停信号 ================================
    output logic [FU_NUM-1:0] FU_pause,    // 在四个功能单元中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    output logic              BU_pause,
    //================================ 分支预测接口 ================================
    output logic                          redirect, // 错误刷新标志
    output logic [31:0]                   redirect_target, // 错误目标地址
    output logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] redirect_ftq_id,
    output backend_ftq_meta_updata_t      backend_ftq_meta_updata,
    output logic [$clog2(FRONTEND_FTQ_SIZE)-1:0]  ftq_query_addr_o,
    output BU_ras_op_t                    BU_ras_data,
    input  logic [ADDR_WIDTH-1:0]         ftq_query_pc_i,
    //================================ 分支预测错误指令的ROB索引 ================================
    output logic [$clog2(ROB_DEPTH)-1:0]  ROB_error_index,
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    input  logic        flush_sign,
    input  logic        redirect_flush,
    //================================ from csr ================================
    input  logic        csr_pg,             // 页模式使能
    input  logic        csr_da,             // 直接地址模式
    input  logic [31:0] csr_dmw0,           // 直接映射窗口0
    input  logic [31:0] csr_dmw1,           // 直接映射窗口1
    input  logic [1:0]  csr_plv,            // 当前特权级
    input  logic [1:0]  csr_datm,           // 数据地址翻译模式
    input  logic [31:0] csr_tlbehi,         // TLB项高位
    //================================ to csr ================================
    output logic        tlbsrch_en,         // TLB搜索使能
    output logic        tlbsrch_found,
    output logic [ 2:0] tlbsrch_index,
    //================================ to addr trans  ================================
    output logic        data_fetch,         // 数据请求
    output logic [31:0] data_vaddr,         // 虚拟地址
    output logic        data_addr_trans_en, // 地址翻译使能
    output logic        dmw0_en,            // 直接映射窗口0使能
    output logic        dmw1_en,            // 直接映射窗口1使能

    output logic        invtlb_inst,        // 该信号表示ISS阶段传过来的指令是invtlb指令，但不表示这个指令一定执行
    output logic        invtlb_en,          // 该信号表示EXE阶段的指令为invtlb指令，并且一定执行（高电平有效）
    output logic [4:0]  invtlb_op,          // INVTLB操作类型
    output logic [9:0]  invtlb_asid,        // ASID
    output logic [18:0] invtlb_vpn,         // 虚拟页号
    //================================ TLB查询结果 ================================
    input  logic        data_tlb_found,     // TLB命中
    input  logic [ 2:0] data_tlb_index,     // TLB索引
    input  logic        data_tlb_v,         // 有效位
    input  logic        data_tlb_d,         // 脏位
    input  logic [1:0]  data_tlb_mat,       // 存储类型
    input  logic [1:0]  data_tlb_plv,       // 特权级
    input  logic [19:0] data_tlb_ppn,       // 物理页号
    //================================ cache接口 ================================
    output logic        icacop_op_en    ,
    output logic        dcacop_op_en    ,
    output logic [ 1:0] cacop_op_mode   ,
    output logic [31:0] cacop_pa        ,
    output logic        cacop_op_mode_di,
    // to dcache
    output logic        data_uncache_en,

    input logic [ 7:0]  data_index,          // 数据TLB匹配索引
    input logic [19:0]  data_tag,            // 数据物理地址标签
    input logic [ 3:0]  data_offset,         // 数据页内偏移
    //================================ 原MEM阶段的接口 ================================
    //================================ 数据存储器接口 ================================
    input  wire [31: 0] data_sram_rdata,
    input  wire         data_sram_data_ok,
    //================================ 乘除模块接口 ================================
    input  wire [63: 0] MEM_mul_result,
    input  wire [63: 0] MEM_div_result,
    //================================ cacop指令接口 ================================
    input  wire                     icacop_ok,
    input  wire                     dcacop_ok
    );

// 普通指令走的流水线
FU0 u_FU0 (
    //输入时钟和复位
    .clk            (clk),
    .reset          (reset),
    //================================ 流水线握手信号 ================================
    .WB_allow_in    (WB_allow_in),             //WB阶段可以输入
    .FU_allow_in    (FU_allow_in[0]),             //EXE阶段可以输入
    //================================ 流水线间通信总线 ================================
    .FU_WB_bus      (FU_WB_bus[0]),   //送至WB阶段信号
    .data_i         (ISS_EXE_bus[0]),
    //================================ 执行阶段（结束时）的写ROB端口 ================================
    .complete_en    (complete_en[0]),
    .complete_addr  (complete_addr[0]),
    //================================ 前递暂停信号 ================================
    .FU_pause       (FU_pause[0]),    // 在四个功能单元中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    .flush_sign     (flush_sign),
    .redirect_flush (redirect_flush)
);
// 普通指令走的流水级
FU1 u_FU1 (
    //输入时钟和复位
    .clk            (clk),
    .reset          (reset),
    //================================ 流水线握手信号 ================================
    .WB_allow_in    (WB_allow_in),             //WB阶段可以输入
    .FU_allow_in    (FU_allow_in[1]),             //EXE阶段可以输入
    //================================ 流水线间通信总线 ================================
    .FU_WB_bus      (FU_WB_bus[1]),   //送至WB阶段信号
    .data_i         (ISS_EXE_bus[1]),
    //================================ 执行阶段（结束时）的写ROB端口 ================================
    .complete_en    (complete_en[1]),
    .complete_addr  (complete_addr[1]),
    //================================ 前递暂停信号 ================================
    .FU_pause       (FU_pause[1]),    // 在四个功能单元中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    .flush_sign     (flush_sign),
    .redirect_flush (redirect_flush)
);
// 访存指令和特权指令走的流水线
FU2 u_FU2 (
    //输入时钟和复位
    .clk                    (clk),
    .reset                  (reset),
    //================================ 流水线握手信号 ================================
    .WB_allow_in            (WB_allow_in),             //WB阶段可以输入
    .FU_allow_in            (FU_allow_in[2]),             //EXE阶段可以输入
    //================================ 流水线间通信总线 ================================
    .FU_WB_bus              (FU_WB_bus[2]),   //送至WB阶段信号
    .data_i                 (ISS_EXE_bus[2]),
    //================================ 执行阶段（结束时）的写端口 ================================
    .complete_en            (complete_en[2]),
    .complete_addr          (complete_addr[2]),
    //================================ 数据存储器接口 ================================
    //与数据ram进行通信的信号，向数据ram发送读取或者写入请求
 	.data_sram_req          (data_sram_req),     // 数据SRAM请求
    .dcache_tag             (dcache_tag   ),
    .dcache_index           (dcache_index ),
    .dcache_offset          (dcache_offset),
    .data_sram_wr           (data_sram_wr),      // 数据SRAM写使能
    .data_sram_wstrb        (data_sram_wstrb),   // 字节写使能
    .data_sram_size         (data_sram_size),    // 访问大小(00:1B, 01:2B, 10:4B)
    .data_sram_wdata        (data_sram_wdata),   // 写数据
    .data_sram_addr_ok      (data_sram_addr_ok), // 地址接收就绪
    //================================ CSR接口 ================================
    // 与csr通信的信号，只需要读相关信号
    .EXE_csr_re             (EXE_csr_re),  // 实际上这个信号不需要，因为读是组合逻辑
    .EXE_csr_num            (EXE_csr_num), // 这个还要数据前递
    .csr_rdata              (csr_rdata),
    .timer_64_rdata         (timer_64_rdata), // 从定时器读出的数据，定时器写在csr中
    .llbit                  (llbit),       // 用于原子访存指令sc.w
    .lladdr                 (lladdr),      // 用于原子访存指令sc.w
    //================================ 前递暂停信号 ================================
    .FU_pause               (FU_pause[2]),    // 在四个功能单元中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    .flush_sign             (flush_sign),
    //================================ from csr ================================
    .csr_pg                 (csr_pg),             // 页模式使能
    .csr_da                 (csr_da),             // 直接地址模式
    .csr_dmw0               (csr_dmw0),           // 直接映射窗口0
    .csr_dmw1               (csr_dmw1),           // 直接映射窗口1
    .csr_plv                (csr_plv),            // 当前特权级
    .csr_datm               (csr_datm),           // 数据地址翻译模式
    .csr_tlbehi             (csr_tlbehi),         // TLB项高位
    //================================ to csr ================================
    .tlbsrch_en             (tlbsrch_en),         // TLB搜索使能
    .tlbsrch_found          (tlbsrch_found),
    .tlbsrch_index          (tlbsrch_index),
    //================================ to addr trans  ================================
    .data_fetch             (data_fetch),         // 数据请求
    .data_vaddr             (data_vaddr),         // 虚拟地址
    .data_addr_trans_en     (data_addr_trans_en), // 地址翻译使能
    .dmw0_en                (dmw0_en),            // 直接映射窗口0使能
    .dmw1_en                (dmw1_en),            // 直接映射窗口1使能

    .invtlb_inst            (invtlb_inst),        // 该信号表示ISS阶段传过来的指令是invtlb指令，但不表示这个指令一定执行
    .invtlb_en              (invtlb_en),          // 该信号表示EXE阶段的指令为invtlb指令，并且一定执行（高电平有效）
    .invtlb_op              (invtlb_op),          // INVTLB操作类型
    .invtlb_asid            (invtlb_asid),        // ASID
    .invtlb_vpn             (invtlb_vpn),         // 虚拟页号
    //================================ TLB查询结果 ================================
    .data_tlb_found         (data_tlb_found),     // TLB命中
    .data_tlb_index         (data_tlb_index),     // TLB索引
    .data_tlb_v             (data_tlb_v),         // 有效位
    .data_tlb_d             (data_tlb_d),         // 脏位
    .data_tlb_mat           (data_tlb_mat),       // 存储类型
    .data_tlb_plv           (data_tlb_plv),       // 特权级
    .data_tlb_ppn           (data_tlb_ppn),       // 物理页号
    //================================ cache接口 ================================
    .icacop_op_en           (icacop_op_en)    ,
    .dcacop_op_en           (dcacop_op_en)    ,
    .cacop_op_mode          (cacop_op_mode)   ,
    .cacop_pa               (cacop_pa)        ,
    .cacop_op_mode_di       (cacop_op_mode_di),
    // to dcache
    .data_uncache_en        (data_uncache_en),

    .data_index             (data_index),          // 数据TLB匹配索引
    .data_tag               (data_tag),            // 数据物理地址标签
    .data_offset            (data_offset),         // 数据页内偏移
    //================================ 原MEM阶段的接口 ================================
    //================================ 数据存储器接口 ================================
    .data_sram_rdata        (data_sram_rdata),
    .data_sram_data_ok      (data_sram_data_ok),
    //================================ cacop指令接口 ================================
    .icacop_ok              (icacop_ok),
    .dcacop_ok              (dcacop_ok)
);
// 乘除指令走的流水线
FU3 u_FU3 (
    //输入时钟和复位
    .clk                (clk) ,
    .reset              (reset),
    //================================ 流水线握手信号 ================================
    .WB_allow_in        (WB_allow_in),             //WB阶段可以输入
    .FU_allow_in        (FU_allow_in[3]),             //EXE阶段可以输入
    //================================ 流水线间通信总线 ================================
    .FU_WB_bus          (FU_WB_bus[3]),   //送至WB阶段信号
    .data_i             (ISS_EXE_bus[3]),
    //================================ 执行阶段（结束时）的写端口 ================================
    .complete_en        (complete_en[3]),
    .complete_addr      (complete_addr[3]),
    //================================ 连接乘除法模块接口 ================================
    .mul_signed         (),    // 有符号乘法
    .mul_scr1           (),      // 乘法操作数1
    .mul_scr2           (),      // 乘法操作数2
    .res_from_div       (res_from_div),   // 结果来自除法
    .div_signed         (div_signed),     // 有符号除法
    .div_scr1           (div_scr1),      // 除法操作数1
    .div_scr2           (div_scr2),      // 除法操作数2
    .div_complete       (div_complete),   // 除法完成
    //================================ 前递暂停信号 ================================
    .FU_pause           (FU_pause[3]),    // 在四个功能单元中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    .flush_sign         (flush_sign),
    //================================ 原MEM阶段的接口 ================================
    //================================ 乘除模块接口 ================================
    .MEM_mul_result     (0),
    .MEM_div_result     (MEM_div_result)
);
// 分支跳转指令走的流水线
BU u_BU (
    //输入时钟和复位
    .clk            (clk),
    .reset          (reset),
    //================================ 流水线握手信号 ================================
    .WB_allow_in    (WB_allow_in),             //WB阶段可以输入
    .BU_allow_in    (FU_allow_in[4]),             //EXE阶段可以输入
    //================================ 流水线间通信总线 ================================
    .FU_WB_bus      (FU_WB_bus[4]),   //送至WB阶段信号
    .data_i         (BU_bus),
    //================================ 执行阶段（结束时）的写ROB端口 ================================
    .complete_en    (complete_en[4]),
    .complete_addr  (complete_addr[4]),
    //================================ 前递暂停信号 ================================
    .BU_pause       (BU_pause),
    .FU_pause       (FU_pause[4]),    // 在四个功能单元中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    //================================ 分支预测接口 ================================
    .redirect               (redirect), // 错误刷新标志
    .redirect_target        (redirect_target), // 错误目标地址
    .redirect_ftq_id        (redirect_ftq_id),
    .backend_ftq_meta_updata(backend_ftq_meta_updata),
    .BU_ras_data            (BU_ras_data),
    .ftq_query_pc_i         (ftq_query_pc_i),
    //================================ 分支预测错误指令的ROB索引 ================================
    .ROB_error_index        (ROB_error_index),
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    .flush_sign     (flush_sign),
    .redirect_flush (redirect_flush)
);

endmodule