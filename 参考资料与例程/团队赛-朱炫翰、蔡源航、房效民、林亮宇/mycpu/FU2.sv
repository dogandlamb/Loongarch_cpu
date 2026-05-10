`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module FU2 // store指令、TLB指令、cacop指令放到WB阶段执行
    import pipeline_types::*;
    import core_defines::*;
#(
    parameter TLBNUM = 8
) (
    //输入时钟和复位
    input  logic    clk ,
    input  logic    reset,
    //================================ 流水线握手信号 ================================
    input  logic    WB_allow_in,             //WB阶段可以输入
    output logic    FU_allow_in,             //EXE阶段可以输入
    //================================ 流水线间通信总线 ================================
    output ROB_t         FU_WB_bus,   //送至WB阶段信号
    input  ISS_EXE_bus_t data_i,
    //================================ 执行阶段（结束时）的写端口 ================================
    output logic                            complete_en,
    output logic [$clog2(ROB_DEPTH)-1:0]    complete_addr,
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
    //================================ CSR接口 ================================
    // 与csr通信的信号，只需要读相关信号
    output logic        EXE_csr_re,  // 实际上这个信号不需要，因为读是组合逻辑
    output logic [13:0] EXE_csr_num, // 这个还要数据前递
    input  logic [31:0] csr_rdata,
    input  logic [63:0] timer_64_rdata, // 从定时器读出的数据，定时器写在csr中
    input  logic        llbit,       // 用于原子访存指令sc.w
    input  logic [27:0] lladdr,      // 用于原子访存指令sc.w
    //================================ 前递暂停信号 ================================
    output logic        FU_pause,    // 在四个功能单元中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    input  logic        flush_sign,
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
    //================================ cacop指令接口 ================================
    input  wire         icacop_ok,
    input  wire         dcacop_ok
    );
//================================ 信号定义 ================================
logic EXE_valid;
logic REQ_valid;
logic MEM_valid;
logic exe_ready_go;
logic EXE_ready_go;
logic req_ready_go;
logic REQ_ready_go;
logic mem_ready_go;
logic MEM_ready_go;
logic REQ_allow_in;
logic MEM_allow_in;

assign EXE_ready_go = exe_ready_go;
assign REQ_ready_go = req_ready_go;
assign MEM_ready_go = mem_ready_go;
assign FU_allow_in  = !EXE_valid || EXE_ready_go && REQ_allow_in;
assign REQ_allow_in = !REQ_valid || REQ_ready_go && MEM_allow_in;
assign MEM_allow_in = !MEM_valid || MEM_ready_go && WB_allow_in ;

// 用来生成FU_pause
logic EXE_pause;
logic REQ_pause;
logic MEM_pause;

EXE_REQ_bus_t    EXE_REQ_bus;
REQ_MEM_bus_t    REQ_MEM_bus;
MEM_WB_bus_t     MEM_WB_bus;
addr_trans_bus_t addr_trans_bus;
data_sram_bus_t  data_sram_bus;
invtlb_bus_t     invtlb_bus;
cache_bus_t      cache_bus;


exe u_exe(
    //输入时钟和复位
    .clk              (clk                  ),
    .reset            (reset                ),
    //================================ 模块准备信号 ================================
    .EXE_valid        (EXE_valid            ),
    .exe_ready_go     (exe_ready_go         ), // EXE阶段完成处理标志
    .EXE_ready_go     (EXE_ready_go         ),
    //和MEM阶段的流水线握手信号
    .REQ_allow_in     (REQ_allow_in         ),        //MEM阶段可以输入
    //和ISS阶段的流水线握手信号
    .EXE_allow_in     (FU_allow_in          ),            //EXE阶段可以输入
    .REQ_pause        (REQ_pause            ),
    //EXE和MEM的通信
    .EXE_REQ_bus      (EXE_REQ_bus          ),         //送至MEM阶段信号
    //ISS和EXE的通信
    .ISS_EXE_bus      (data_i               ),
    //用于数据前递
    .EXE_pause        (EXE_pause            ),
    // 与csr通信的信号，只需要读相关信号
    .EXE_csr_re       (EXE_csr_re       ),
    .EXE_csr_num      (EXE_csr_num      ),
    .csr_rdata        (csr_rdata        ),
    .timer_64_rdata   (timer_64_rdata   ),
    .llbit            (llbit            ),
    .lladdr           (lladdr           ),
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    .flush_sign       (flush_sign       ),
    .redirect_flush   (1'b0             ),
    // 传给pre-IF和EXE阶段，用于地址翻译的信号
    .csr_pg           (csr_pg             ),
    .csr_da           (csr_da             ),
    .csr_dmw0         (csr_dmw0           ),
    .csr_dmw1         (csr_dmw1           ),
    .csr_plv          (csr_plv            ),
    .csr_datm         (csr_datm           ),
    .csr_tlbehi       (csr_tlbehi         ),
    // to addr_trans
    .addr_trans_bus     (addr_trans_bus     ),
    // from tlb
    .data_tlb_found   (data_tlb_found     ),
    .data_tlb_index   (data_tlb_index     ),
    .data_tlb_v       (data_tlb_v         ),
    .data_tlb_d       (data_tlb_d         ),
    .data_tlb_mat     (data_tlb_mat       ),
    .data_tlb_plv     (data_tlb_plv       ),

    .data_index       (data_index         ),        // 数据TLB匹配索引
    .data_tag         (data_tag           ),        // 数据物理地址标签
    .data_offset      (data_offset        )         // 数据页内偏移
);

req u_req(
    //输入时钟和复位
    .clk              (clk                  ),
    .reset            (reset                ),
    //================================ 模块准备信号 ================================
    .REQ_valid        (REQ_valid            ),
    .req_ready_go     (req_ready_go         ), // EXE阶段完成处理标志
    .REQ_ready_go     (REQ_ready_go         ),
    //和MEM阶段的流水线握手信号
    .MEM_allow_in     (MEM_allow_in         ),        //MEM阶段可以输入
    //和ISS阶段的流水线握手信号
    .REQ_allow_in     (REQ_allow_in         ),            //EXE阶段可以输入
    //EXE和MEM的通信
    .REQ_MEM_bus      (REQ_MEM_bus          ),         //送至MEM阶段信号
    //ISS和EXE的通信
    .EXE_REQ_bus      (EXE_REQ_bus          ),
    //与数据ram进行通信的信号，向数据ram发送读取或者写入请求
    .data_sram_req    (data_sram_req        ),
    .dcache_tag       (dcache_tag           ),
    .dcache_index     (dcache_index         ),
    .dcache_offset    (dcache_offset        ),
    .data_sram_bus    (data_sram_bus        ),
    .data_sram_addr_ok(data_sram_addr_ok    ),
    //用于数据前递
    .REQ_pause        (REQ_pause),
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    .flush_sign       (flush_sign       ),
    //================================ to csr ================================
    .tlbsrch_en       (tlbsrch_en       ),         // TLB搜索使能
    .tlbsrch_found    (tlbsrch_found    ),
    .tlbsrch_index    (tlbsrch_index    ),
    // to addr_trans
    .invtlb_bus       (invtlb_bus         ),
    //================================ cache接口 ================================
    .cache_bus        (cache_bus        )
);

mem u_mem(
    .clk                    (clk),
    .reset                  (reset),
    //================================ 模块准备信号 ================================
    .MEM_valid              (MEM_valid),
    .mem_ready_go           (mem_ready_go),
    .MEM_ready_go           (MEM_ready_go),
    //================================ 流水线握手信号 ================================
    .MEM_allow_in           (MEM_allow_in),           //MEM阶段可以输入
    .WB_allow_in            (WB_allow_in),            //WB阶段可以输入
    //================================ 流水线间通信总线 ================================
    //EXE和MEM的通信
    .REQ_MEM_bus            (REQ_MEM_bus),          //EXE送至MEM阶段信号
    //MEM和WB的通信
    .MEM_WB_bus             (MEM_WB_bus),           //MEM送至WB的信号
    //================================ 数据存储器接口 ================================
    .data_sram_rdata        (data_sram_rdata),
    .data_sram_data_ok      (data_sram_data_ok),
    //================================ 乘除模块接口 ================================
    .MEM_mul_result         ('0),
    .MEM_div_result         ('0),
    //================================ 前递接口 ================================
    //输出当前阶段的目的寄存器,注意这个目的寄存器的生成逻辑，实际上包含了使能和流水段数据有效
    .MEM_to_ISS_dest        (),
    .MEM_to_ISS_forward     (),
    // 新增的数据前递信号
    .MEM_csr_we             (),
    .MEM_csr_num            (),
    .MEM_pause              (MEM_pause),
    //================================ cacop指令接口 ================================
    .icacop_ok              (icacop_ok),
    .dcacop_ok              (dcacop_ok),
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    .flush_sign             (flush_sign)
);
always_comb begin : addr_trans_bus_sel
    if (EXE_valid) begin
        data_fetch = addr_trans_bus.data_fetch;         // 数据请求
        data_vaddr = addr_trans_bus.data_vaddr;         // 虚拟地址
        data_addr_trans_en = addr_trans_bus.data_addr_trans_en; // 地址翻译使能
        dmw0_en = addr_trans_bus.dmw0_en;            // 直接映射窗口0使能
        dmw1_en = addr_trans_bus.dmw1_en;            // 直接映射窗口1使能
    end
    else begin
        data_fetch = 1'b0;
        data_vaddr = 32'b0;
        data_addr_trans_en = 1'b0;
        dmw0_en = 1'b0;
        dmw1_en = 1'b0;
    end
end

always_comb begin : data_sram_bus_sel
    if (REQ_valid) begin
        data_sram_wr = data_sram_bus.data_sram_wr;      // 数据SRAM写使能
        data_sram_wstrb = data_sram_bus.data_sram_wstrb;   // 字节写使能
        data_sram_size = data_sram_bus.data_sram_size;    // 访问大小(00:1B, 01:2B, 10:4B)
        data_sram_wdata = data_sram_bus.data_sram_wdata;   // 写数据
    end
    else begin
        data_sram_wr = 0;
        data_sram_wstrb = 0;
        data_sram_size = 0;
        data_sram_wdata = 0;
    end
end

always_comb begin : invtlb_bus_sel
    if (REQ_valid) begin
        invtlb_inst = invtlb_bus.invtlb_inst;    // 该信号表示ISS阶段传过来的指令是invtlb指令，但不表示这个指令一定执行
        invtlb_en = invtlb_bus.invtlb_en;      // 该信号表示EXE阶段的指令为invtlb指令，并且一定执行（高电平有效）
        invtlb_op = invtlb_bus.invtlb_op;      // INVTLB操作类型
        invtlb_asid = invtlb_bus.invtlb_asid;    // ASID
        invtlb_vpn = invtlb_bus.invtlb_vpn;     // 虚拟页号
    end
    else begin
        invtlb_inst = 0;
        invtlb_en = 0;
        invtlb_op = 0;
        invtlb_asid = 0;
        invtlb_vpn = 0;
    end
end

always_comb begin : cache_bus_sel
    if (REQ_valid) begin
        icacop_op_en     = cache_bus.icacop_op_en       ;
        dcacop_op_en     = cache_bus.dcacop_op_en       ;
        cacop_op_mode    = cache_bus.cacop_op_mode      ;
        cacop_pa         = cache_bus.cacop_pa           ;
        cacop_op_mode_di = cache_bus.cacop_op_mode_di   ;
        data_uncache_en  = cache_bus.data_uncache_en    ;
    end
    else begin
        icacop_op_en     = 0;
        dcacop_op_en     = 0;
        cacop_op_mode    = 0;
        cacop_pa         = 0;
        cacop_op_mode_di = 0;
        data_uncache_en  = 0;
    end
end

assign complete_en   = MEM_allow_in && MEM_WB_bus.valid; // 数据有效且指令允许流入下个流水级时，给ROB填入完成信号
assign complete_addr = MEM_WB_bus.ROB_idx;

//================================ 数据输出 ================================
assign FU_WB_bus.complete = 1'b1;
assign FU_WB_bus.Areg     = MEM_WB_bus.dest;
assign FU_WB_bus.ex = MEM_WB_bus.ex;
assign FU_WB_bus.excp_num = MEM_WB_bus.excp_num;
assign FU_WB_bus.data = MEM_WB_bus.final_result; // final_result

assign FU_WB_bus.gr_we = MEM_WB_bus.gr_we;

assign FU_WB_bus.data_uncache_en = MEM_WB_bus.data_uncache_en;

assign FU_WB_bus.csr_tlb_type = MEM_WB_bus.csr_tlb_type;

assign FU_WB_bus.inst_ll_w = MEM_WB_bus.inst_ll_w;
assign FU_WB_bus.inst_sc_w = MEM_WB_bus.inst_sc_w;

always_comb begin
    if (MEM_WB_bus.csr_tlb_type & ~MEM_WB_bus.inst_ll_w & ~MEM_WB_bus.inst_sc_w) begin
        FU_WB_bus.different_data = {
            MEM_WB_bus.csr_num,
            MEM_WB_bus.csr_wmask,
            MEM_WB_bus.csr_wdata,
            MEM_WB_bus.tlbwr_en,
            MEM_WB_bus.tlbfill_en,
            MEM_WB_bus.tlbrd_en
        };
    end
    else begin
        FU_WB_bus.different_data = { // 81-64=17
            17'b0,
            MEM_WB_bus.mem_addr,
            MEM_WB_bus.paddr
        };
    end
end

assign FU_WB_bus.csr_we = MEM_WB_bus.csr_we;
assign FU_WB_bus.ertn_flush = MEM_WB_bus.ertn_flush;
assign FU_WB_bus.refetch_flush = MEM_WB_bus.refetch_flush;

// 指令位于前端的信息
assign FU_WB_bus.ftq_id = MEM_WB_bus.ftq_id;   // FTQ块的索引
assign FU_WB_bus.ftq_block_idx = MEM_WB_bus.ftq_block_idx;  // 在FTQ块中的索引
assign FU_WB_bus.is_last_in_block = MEM_WB_bus.is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

// 指令具体执行信息
assign FU_WB_bus.branch_info = 0;

// difftest
`ifdef DIFFTEST_EN
assign FU_WB_bus.diff_timer_64_rdata = MEM_WB_bus.diff_timer_64_rdata;
assign FU_WB_bus.diff_inst = MEM_WB_bus.diff_inst;
assign FU_WB_bus.diff_inst_ld_en = MEM_WB_bus.diff_inst_ld_en;
assign FU_WB_bus.diff_inst_st_en = MEM_WB_bus.diff_inst_st_en;
assign FU_WB_bus.diff_cnt_inst = MEM_WB_bus.diff_cnt_inst;
assign FU_WB_bus.diff_csr_rstat_en = MEM_WB_bus.diff_csr_rstat_en;
assign FU_WB_bus.diff_csr_rdata = MEM_WB_bus.diff_csr_rdata;
assign FU_WB_bus.diff_data_sram_wdata = MEM_WB_bus.diff_data_sram_wdata;
`endif
//================================ 前递暂停信号 ================================
assign FU_pause = REQ_pause || MEM_pause;
endmodule