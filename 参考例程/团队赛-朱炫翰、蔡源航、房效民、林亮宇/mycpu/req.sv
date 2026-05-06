`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module req
    import core_defines::*;
    import pipeline_types::*;
#(
    parameter TLBNUM = 8
) (
    //输入时钟和复位
    input  wire     clk ,
    input  wire     reset,
    //================================ 模块准备信号 ================================
    output reg      REQ_valid,
    output wire     req_ready_go,
    input  wire     REQ_ready_go, // REQ阶段完成处理标志
    //================================ 流水线握手信号 ================================
    //和MEM阶段的流水线握手信号
    input  wire     MEM_allow_in,            //MEM阶段可以输入
    //REQ_stage生成REQ_allow_in输入
    input  wire     REQ_allow_in,            //REQ阶段可以输入
    //================================ 流水线间通信总线 ================================
    //REQ和MEM的通信
    output REQ_MEM_bus_t REQ_MEM_bus,        //送至MEM阶段信号
    //EXE和REQ的通信
    input  EXE_REQ_bus_t EXE_REQ_bus,
    //================================ 数据存储器接口 ================================
    //与数据ram进行通信的信号，向数据ram发送读取或者写入请求
    output wire            data_sram_req,
    output wire [19:0]     dcache_tag,
    output wire [ 7:0]     dcache_index,
    output wire [ 3:0]     dcache_offset,
    output data_sram_bus_t data_sram_bus,
    input  wire            data_sram_addr_ok, // 地址接收就绪
    //================================ 前递接口 ================================
    output wire        REQ_pause,          // REQ暂停信号
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    input  wire        flush_sign,
    //================================ to csr ================================
    output logic            tlbsrch_en,     // TLB搜索使能
    output logic            tlbsrch_found,
    output logic [ 2:0]     tlbsrch_index,
    //================================ to addr trans  ================================
    output invtlb_bus_t     invtlb_bus,
    //================================ cache接口 ================================
    output cache_bus_t      cache_bus
    );

//================================ 前一流水级传过来的信号 ================================
logic [$clog2(ROB_DEPTH)-1:0] REQ_ROB_idx;
reg  [4: 0] REQ_dest;
reg         REQ_gr_we;

reg  [31:0] REQ_src1;
reg  [31:0] REQ_src2;

reg  [31:0] alu_result;
reg  [31:0] paddr;
reg  [31:0] final_result;

reg  [2 :0] REQ_ld_en;
reg         REQ_mem_we;

reg         REQ_ll_w;
reg         REQ_sc_w;
reg         sc_cancel_req;

// CSR相关
reg         csr_tlb_type;
reg         REQ_csr_we;
reg  [13:0] REQ_csr_num;
reg         inst_csrxchg;
//================================ TLB控制信号 ================================
/*TLB指令相关控制信号*/
logic [ 9:0] invtlb_asid;    // ASID
logic [18:0] invtlb_vpn;     // 虚拟页号
reg          REQ_tlbwr_en;
reg          REQ_tlbfill_en;
reg          REQ_tlbrd_en;
reg          REQ_invtlb_en;
reg   [ 4:0] REQ_invtlb_op;

reg         REQ_refetch_flush; // 重取刷新标志

reg         REQ_ertn_flush; // ERTN指令标志

/*异常相关的信号*/
reg         REQ_ex;         // 异常标志
reg  [15:0] REQ_excp_num;   // 异常号

/*分支预测信号*/
logic [$clog2(FRONTEND_FTQ_SIZE)-1:0]   REQ_ftq_id;   // FTQ块的索引
logic [$clog2(FETCH_WIDTH)-1:0]         REQ_ftq_block_idx;  // 在FTQ块中的索引
logic                                   REQ_is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

wire access_mem;
wire data_valid;

wire [31:0] REQ_csr_wmask;
wire [31:0] REQ_csr_wdata;

//================================ difftest ================================
`ifdef DIFFTEST_EN
logic [63:0] diff_timer_64_rdata;
logic [31:0] diff_inst;
logic [ 7:0] diff_inst_ld_en;
logic [ 7:0] diff_inst_st_en;
logic        diff_cnt_inst;
logic        diff_csr_rstat_en;
logic [31:0] diff_csr_rdata;
logic [31:0] diff_data_sram_wdata;
`endif

//================================ 主要逻辑实现 ================================
reg nop; // 花费一个寄存器来空接信号，这样不是最好的做法但暂时想不到更好的方法了
//================================ 流水段控制逻辑 ================================

// 一条指令为访存指令，另一条为除法指令把流水线阻塞住时，可能会漏过addr_ok，这时怎么办
assign req_ready_go    = ~(access_mem & ~data_sram_addr_ok) // 访存时，要等addr_ok，即请求响应后才能继续
                          | REQ_ex | REQ_refetch_flush; // 发生异常时，打上重取标记时，允许继续

//================================ 与前后流水级的通信 ================================
always @(posedge clk) begin
    if (reset | flush_sign) begin
        REQ_valid <= 1'b0;
    end
    else if (REQ_allow_in) begin
        REQ_valid <= EXE_REQ_bus.valid;
    end

    if (EXE_REQ_bus.valid & REQ_allow_in) begin
    	{nop, // REQ_valid不能在两个条件下同时赋值
        REQ_ROB_idx,

        REQ_dest,
        REQ_gr_we,

        REQ_src1,
        REQ_src2,

        alu_result,
        paddr,
        final_result,

    	REQ_ld_en,
        REQ_mem_we,

        REQ_ll_w,
        REQ_sc_w,

        sc_cancel_req,
        data_sram_bus,

        csr_tlb_type,
        REQ_csr_we,
        REQ_csr_num,
        inst_csrxchg,

        REQ_ertn_flush,
        REQ_ex,
        REQ_excp_num,

        /*TLB指令相关控制信号*/
        tlbsrch_en,
        tlbsrch_found,
        tlbsrch_index,
        REQ_tlbwr_en,
        REQ_tlbfill_en,
        REQ_tlbrd_en,
        REQ_invtlb_en,
        REQ_invtlb_op,

        REQ_refetch_flush,

        cache_bus,

        REQ_ftq_id,   // FTQ块的索引
        REQ_ftq_block_idx,  // 在FTQ块中的索引
        REQ_is_last_in_block  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

        `ifdef DIFFTEST_EN
        ,
        diff_timer_64_rdata,
        diff_inst,
        diff_inst_ld_en,
        diff_inst_st_en,
        diff_cnt_inst,
        diff_csr_rstat_en,
        diff_csr_rdata,
        diff_data_sram_wdata 
        `endif
        } <= EXE_REQ_bus;
    end
end

/*REQ和MEM阶段的通信总线*/
//注意mul和div的计算结果由MEM直接从端口获取
assign REQ_MEM_bus = {
                    REQ_valid & REQ_ready_go,

                    REQ_ROB_idx,
					REQ_dest,//5位
					REQ_gr_we,//1位

                    alu_result,//32位，作为访存地址往下传
                    paddr,//32位,作为访存物理地址往下传
					final_result,//32位，作为写回寄存器的数据往下传
                    REQ_ld_en,//8
                    REQ_mem_we,//8
                    REQ_ll_w,//1位
                    REQ_sc_w,//1位
                    cache_bus.data_uncache_en,//1位

                    csr_tlb_type,//1位
                    REQ_csr_we,//1位
                    REQ_csr_num,//14位
                    REQ_csr_wmask,//32位
                    REQ_csr_wdata,//32位

                    REQ_ertn_flush,//1位
                    REQ_ex,//1位
                    REQ_excp_num,//16位
                    /*TLB指令相关控制信号*/
                    REQ_tlbwr_en,//1位
                    REQ_tlbfill_en,//1位
                    REQ_tlbrd_en,//1位
                    REQ_refetch_flush,//1位
                    // cacop指令相关信号
                    cache_bus.icacop_op_en,//1位
                    cache_bus.dcacop_op_en,//1位
                    // 分支预测信号
                    REQ_ftq_id,
                    REQ_ftq_block_idx,
                    REQ_is_last_in_block
                    // difftest
                    `ifdef DIFFTEST_EN
                    ,
                    diff_timer_64_rdata,
                    diff_inst,
                    diff_inst_ld_en,
                    diff_inst_st_en,
                    diff_cnt_inst,
                    diff_csr_rstat_en,
                    diff_csr_rdata,
                    diff_data_sram_wdata
                    `endif
};

//================================ 访存控制 ================================
assign access_mem    = |REQ_ld_en | REQ_mem_we;
assign data_valid    = REQ_valid & ~flush_sign & ~REQ_ex & ~REQ_refetch_flush;
assign data_sram_req = access_mem & data_valid & ~sc_cancel_req; // 表示真正要访问内存。访存指令不能在异常发生时进行，也不在打上重取标记时进行

assign {dcache_tag, dcache_index, dcache_offset} = paddr;

/*csr指令相关控制信号*/
assign REQ_csr_wmask  = {32{inst_csrxchg}}              & REQ_src1     |
                        {32{REQ_ll_w}}                  & 32'b1        | // 由于ll.w指令只写llbit，所以把wmask设置为只有最低一位可以写 
                        {32{~inst_csrxchg & ~REQ_ll_w}} & 32'hffffffff ;
assign REQ_csr_wdata  = {32{REQ_ll_w}} & 32'b0 | {32{~REQ_ll_w}} & REQ_src2; // 在csr内部进行掩码操作

/*TLB指令相关控制信号*/
// 当invtlb_op不为4、5、6时，不需要用ASID，应该让rj为0；当invtlb_op不为5、6时，不需要用VA，应该让rk为0
// rj_is_r0和rk_is_r0在rj和rk的生成逻辑中使用了
assign invtlb_asid= REQ_src1[ 9:0];
assign invtlb_vpn = REQ_src2[31:13];

assign invtlb_bus.invtlb_inst  = REQ_invtlb_en;
assign invtlb_bus.invtlb_en    = REQ_invtlb_en & REQ_valid & ~REQ_ex & ~REQ_refetch_flush; // 因为invtlb在REQ阶段要修改csr，所以必须保证有效
assign invtlb_bus.invtlb_op    = REQ_invtlb_op;
assign invtlb_bus.invtlb_asid  = invtlb_asid;
assign invtlb_bus.invtlb_vpn   = invtlb_vpn;

//================================ 数据前递 ================================
assign REQ_pause = (REQ_ex | REQ_ertn_flush | REQ_refetch_flush) & REQ_valid; // 该信号要前递，需确保有效

endmodule