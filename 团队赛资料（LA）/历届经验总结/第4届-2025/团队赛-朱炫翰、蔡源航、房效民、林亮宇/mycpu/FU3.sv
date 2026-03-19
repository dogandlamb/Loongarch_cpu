`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module FU3
    import pipeline_types::*;
    import core_defines::*;
(
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
    //================================ 连接乘除法模块接口 ================================
    output logic        mul_signed,    // 有符号乘法
    output logic [31:0] mul_scr1,      // 乘法操作数1
    output logic [31:0] mul_scr2,      // 乘法操作数2
    output logic        res_from_div,   // 结果来自除法
    output logic        div_signed,     // 有符号除法
    output logic [31:0] div_scr1,      // 除法操作数1
    output logic [31:0] div_scr2,      // 除法操作数2
    input  logic        div_complete,   // 除法完成
    //================================ 前递暂停信号 ================================
    output logic        FU_pause,    // 在四个功能单元中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    input  logic        flush_sign,
    //================================ 原MEM阶段的接口 ================================
    //================================ 乘除模块接口 ================================
    input  wire [63: 0] MEM_mul_result,
    input  wire [63: 0] MEM_div_result

    );
//================================ 信号定义 ================================
logic EXE_valid;
logic MEM_valid;
logic EXE_ready_go;
logic MEM_ready_go;
logic MEM_allow_in;

assign FU_allow_in  = !EXE_valid || EXE_ready_go && MEM_allow_in;
assign MEM_allow_in = !MEM_valid || MEM_ready_go && WB_allow_in ;

// 用来生成FU_pause
logic EXE_pause;
logic MEM_pause;

FU3_bus_t    FU3_bus;
MEM_WB_bus_t MEM_WB_bus;

//================================ EXE stage ================================
ISS_EXE_bus_t FU3_exe_data;
//================================ 信号定义 ================================
wire        EXE_ex;
wire [15:0] EXE_excp_num;
wire        EXE_refetch_flush;

// 分支预测信号
wire        EXE_is_last_in_block;

wire        res_from_mul;
logic signed [63:0] signed_result;
logic [63:0] unsigned_result;
logic [63:0] mul_result;
logic [31:0] mul_final_result;

//================================ 主要逻辑实现 ================================
assign EXE_ready_go    = ~(res_from_div & ~div_complete)  //除法没做完需要阻塞一下，乘法能直接继续流动不需要阻塞
                          | EXE_ex | EXE_refetch_flush; // 发生异常时，打上重取标记时，允许继续
//================================ 与前后流水级的通信 ================================
always @(posedge clk) begin
    if (reset | flush_sign) begin
        EXE_valid <= 1'b0;
    end
    else if (FU_allow_in) begin
        EXE_valid <= data_i.valid;
    end

    if (data_i.valid & FU_allow_in) begin
        FU3_exe_data <= data_i;
    end
end

/*EXE和MEM阶段的通信总线*/
//注意mul和div的计算结果由MEM直接从端口获取
assign FU3_bus = {
                    EXE_valid & EXE_ready_go,

                    FU3_exe_data.ROB_idx,

					FU3_exe_data.dest,//5位
					FU3_exe_data.gr_we,//1位

                    mul_final_result,//32位
                    FU3_exe_data.div_op,//3位

                    EXE_ex,//1位
                    EXE_excp_num,//16位

                    EXE_refetch_flush,//1位

                    // 分支预测信号
                    FU3_exe_data.ftq_id,
                    FU3_exe_data.ftq_block_idx,
                    EXE_is_last_in_block

                    `ifdef DIFFTEST_EN
                    ,
                    64'b0,
                    FU3_exe_data.diff_inst,
                    8'b0,
                    8'b0,
                    1'b0,
                    1'b0,
                    32'b0,
                    32'b0
                    `endif
};
//================================ 异常信息 ================================
assign EXE_ex            = FU3_exe_data.ex & EXE_valid; // 这个信号会往前传，需要保证是有效的
assign EXE_excp_num      = {7'b0, FU3_exe_data.excp_num};
assign EXE_refetch_flush = FU3_exe_data.refetch_flush & EXE_valid;
// 分支预测信号
assign EXE_is_last_in_block = FU3_exe_data.is_last_in_block;

assign EXE_pause = (EXE_ex | EXE_refetch_flush) & EXE_valid; // 该信号要前递，需确保有效

assign res_from_mul = FU3_exe_data.mul_op[0] & EXE_valid;
assign mul_signed   = FU3_exe_data.mul_op[1];
assign res_from_div = FU3_exe_data.div_op[0] & EXE_valid;
assign div_signed   = FU3_exe_data.div_op[1];

// //下面这段代码在实际电路实现的时候可以去掉，这里添加选择器可以提高非乘除法指令的仿真速度
// assign mul_scr1 = res_from_mul ? FU3_exe_data.src1 : 32'b0;
// assign mul_scr2 = res_from_mul ? FU3_exe_data.src2 : 32'b0;

assign mul_scr1         = res_from_mul ? FU3_exe_data.src1 : 32'b0;
assign mul_scr2         = res_from_mul ? FU3_exe_data.src2 : 32'b0;
assign signed_result    = $signed(mul_scr1) * $signed(mul_scr2);
assign unsigned_result  = mul_scr1 * mul_scr2;
assign mul_result       = mul_signed ? signed_result : unsigned_result;
assign mul_final_result = FU3_exe_data.mul_op[2] ? mul_result[63:32] : mul_result[31:0];


assign div_scr1 = res_from_div ? FU3_exe_data.src1 : 32'b0;
assign div_scr2 = res_from_div ? FU3_exe_data.src2 : 32'b1;  //被除数设置为1先，怕出现什么乱七八糟的错误


//================================ MEM stage ================================
FU3_bus_t   FU3_mem_data;
//================================ 信号定义 ================================
wire        MEM_ex;
wire [15:0] MEM_excp_num;
wire        MEM_refetch_flush;
//================================ 结果信号 ================================
logic [31:0] div_final_result;
logic [31:0] MEM_final_result;
//================================ 与前后流水级的通信 ================================
always @(posedge clk) begin
    if (reset | flush_sign) begin
        MEM_valid <= 1'b0;
    end
    else if (MEM_allow_in) begin
        MEM_valid <= FU3_bus.valid;
    end

    if (FU3_bus.valid & MEM_allow_in) begin
        FU3_mem_data <= FU3_bus;
    end
end

assign MEM_ready_go = 1'b1;
//================================ 结果选择 ================================
//根据指令选择乘除法模块相应的输出
assign div_final_result = FU3_mem_data.div_op[2] ? MEM_div_result[63:32] : MEM_div_result[31:0];
always_comb begin
    case (1'b1)
        FU3_mem_data.div_op[0]    : MEM_final_result = div_final_result             ;
        default                   : MEM_final_result = FU3_mem_data.mul_final_result;
    endcase
end

assign MEM_ex            = FU3_mem_data.ex & MEM_valid; // 这个信号会往前传，需要保证是有效的
assign MEM_excp_num      = FU3_mem_data.excp_num;
assign MEM_refetch_flush = FU3_mem_data.refetch_flush & MEM_valid;

assign MEM_pause = (MEM_ex | MEM_refetch_flush) & MEM_valid; // 该信号要前递，需确保有效


assign complete_en   = MEM_allow_in && MEM_ready_go && MEM_valid; // 数据有效且指令允许流入下个流水级时，给ROB填入完成信号
assign complete_addr = FU3_mem_data.ROB_idx;

//================================ 数据输出 ================================
assign FU_WB_bus.complete = 1'b1;
assign FU_WB_bus.Areg     = FU3_mem_data.dest;
assign FU_WB_bus.ex = FU3_mem_data.ex;
assign FU_WB_bus.excp_num = FU3_mem_data.excp_num;
assign FU_WB_bus.data = MEM_final_result;

assign FU_WB_bus.gr_we = FU3_mem_data.gr_we;

// 乘除法应该用不到uncache
assign FU_WB_bus.data_uncache_en = 0;

assign FU_WB_bus.csr_tlb_type = 0;

assign FU_WB_bus.inst_ll_w = 0;
assign FU_WB_bus.inst_sc_w = 0;

assign FU_WB_bus.different_data = 0;

assign FU_WB_bus.csr_we = 0;
assign FU_WB_bus.ertn_flush = 0;
assign FU_WB_bus.refetch_flush = MEM_refetch_flush;

// 指令位于前端的信息
assign FU_WB_bus.ftq_id = FU3_mem_data.ftq_id;   // FTQ块的索引
assign FU_WB_bus.ftq_block_idx = FU3_mem_data.ftq_block_idx;  // 在FTQ块中的索引
assign FU_WB_bus.is_last_in_block = FU3_mem_data.is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

// 指令具体执行信息
assign FU_WB_bus.branch_info = 0;
// difftest
`ifdef DIFFTEST_EN
assign FU_WB_bus.diff_timer_64_rdata = FU3_mem_data.diff_timer_64_rdata;
assign FU_WB_bus.diff_inst = FU3_mem_data.diff_inst;
assign FU_WB_bus.diff_inst_ld_en = FU3_mem_data.diff_inst_ld_en;
assign FU_WB_bus.diff_inst_st_en = FU3_mem_data.diff_inst_st_en;
assign FU_WB_bus.diff_cnt_inst = FU3_mem_data.diff_cnt_inst;
assign FU_WB_bus.diff_csr_rstat_en = FU3_mem_data.diff_csr_rstat_en;
assign FU_WB_bus.diff_csr_rdata = FU3_mem_data.diff_csr_rdata;
assign FU_WB_bus.diff_data_sram_wdata = FU3_mem_data.diff_data_sram_wdata;
`endif
//================================ 前递暂停信号 ================================
assign FU_pause = EXE_pause || MEM_pause;

endmodule