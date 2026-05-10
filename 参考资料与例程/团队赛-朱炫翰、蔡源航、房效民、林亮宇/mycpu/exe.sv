`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module exe   // 目前exe唯一的写行为是tlbsrch指令在exe阶段结束的时候写
    import core_defines::*;
    import pipeline_types::*;
#(
    parameter TLBNUM = 8
) (
    //输入时钟和复位
    input  wire     clk ,
    input  wire     reset,
    //================================ 模块准备信号 ================================
    output reg      EXE_valid,
    output wire     exe_ready_go,
    input  wire     EXE_ready_go, // EXE阶段完成处理标志
    //================================ 流水线握手信号 ================================
    //和MEM阶段的流水线握手信号
    input  wire     REQ_allow_in,            //MEM阶段可以输入
    //EXE_stage生成EXE_allow_in输入
    input  wire     EXE_allow_in,            //EXE阶段可以输入
    input  wire     REQ_pause,
    //================================ 流水线间通信总线 ================================
    //EXE和MEM的通信
    output EXE_REQ_bus_t EXE_REQ_bus,        //送至MEM阶段信号
    //ISS和EXE的通信
    input  ISS_EXE_bus_t ISS_EXE_bus,
    //================================ 前递接口 ================================
    output wire        EXE_pause,          // EXE暂停信号
    //================================ CSR接口 ================================
    // 与csr通信的信号，只需要读相关信号
    output wire        EXE_csr_re,  // 实际上这个信号不需要，因为读是组合逻辑
    output wire [13:0] EXE_csr_num, // 这个还要数据前递
    input  wire [31:0] csr_rdata,
    input  wire [63:0] timer_64_rdata, // 从定时器读出的数据，定时器写在csr中
    input  wire        llbit,       // 用于原子访存指令sc.w
    input  wire [27:0] lladdr,      // 用于原子访存指令sc.w
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    input  wire        flush_sign,
    input  wire        redirect_flush,
    //================================ from csr ================================
    input  wire        csr_pg,             // 页模式使能
    input  wire        csr_da,             // 直接地址模式
    input  wire [31:0] csr_dmw0,           // 直接映射窗口0
    input  wire [31:0] csr_dmw1,           // 直接映射窗口1
    input  wire [1:0]  csr_plv,            // 当前特权级
    input  wire [1:0]  csr_datm,           // 数据地址翻译模式
    input  wire [31:0] csr_tlbehi,         // TLB项高位
    //================================ to addr trans  ================================
    output addr_trans_bus_t addr_trans_bus,
    //================================ TLB查询结果 ================================
    input  wire        data_tlb_found,     // TLB命中
    input  wire [2:0]  data_tlb_index,     // TLB索引
    input  wire        data_tlb_v,         // 有效位
    input  wire        data_tlb_d,         // 脏位
    input  wire [1:0]  data_tlb_mat,       // 存储类型
    input  wire [1:0]  data_tlb_plv,       // 特权级

    input wire [7:0]    data_index,          // 数据TLB匹配索引
    input wire [19:0]   data_tag,            // 数据物理地址标签
    input wire [3:0]    data_offset         // 数据页内偏移
    );

//================================ 前一流水级传过来的信号 ================================
logic [$clog2(ROB_DEPTH)-1:0] EXE_ROB_idx;
reg  [3 :0] EXE_alu_op;
reg  [2 :0] EXE_mul_op;
reg  [2 :0] EXE_div_op;
reg         EXE_gr_we;
reg  [4: 0] EXE_dest;
reg  [31:0] EXE_src1;
reg  [31:0] EXE_src2;
reg  [31:0] EXE_rkd_value;
reg  [2 :0] EXE_ld_en;
reg  [1 :0] EXE_st_en;
reg         EXE_ll_w;
reg         EXE_sc_w;

// CSR相关
reg         ISS_csr_re;
reg         ISS_csr_we;
reg  [13:0] ISS_csr_num;
reg         inst_csrxchg;
/*TLB指令相关控制信号*/
reg         ISS_tlbsrch_en;
reg         ISS_tlbwr_en;
reg         ISS_tlbfill_en;
reg         ISS_tlbrd_en;
reg         EXE_invtlb_en;
reg  [4 :0] EXE_invtlb_op;
reg         EXE_refetch_flush; // 重取刷新标志
reg         ISS_next_need_refetch; // 下条指令需重取

reg         EXE_cacop;
reg         ISS_ertn_flush; // ERTN指令标志

/*异常相关的信号*/
reg         ISS_ex;         // 异常标志
reg  [8:0]  ISS_excp_num;   // 异常号
reg  [1:0]  EXE_op_timer_64; // 定时器操作

/*分支预测信号*/
logic [$clog2(FRONTEND_FTQ_SIZE)-1:0]   EXE_ftq_id;   // FTQ块的索引
logic [$clog2(FETCH_WIDTH)-1:0]         EXE_ftq_block_idx;  // 在FTQ块中的索引
logic                                   ISS_is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）
//================================ difftest ================================
`ifdef DIFFTEST_EN
reg          EXE_cnt_inst;
reg  [31:0]  EXE_inst;
wire [7:0]   EXE_inst_ld_en;
wire [7:0]   EXE_inst_st_en;
reg          EXE_csr_rstat_en;
`endif
//================================ 功能单元信号 ================================
logic [31:0] mem_addr;
logic [31:0] final_result; // 传给MEM阶段的写进寄存器的数据
//================================ 访存控制 ================================
wire        EXE_res_from_mem;
wire        EXE_mem_we;
wire [1:0]  data_sram_saddr_low2bit;
wire [31:0] wstrb_mask ;
wire [3:0]  stb_wen;
wire [3:0]  sth_wen;
wire        access_mem;
wire        data_valid; // 该信号表示访存的数据是有效的


data_sram_bus_t data_sram_bus;

//================================ ll.w和sc.w指令的处理逻辑 ================================
wire [31:0] paddr; // 访存的物理地址
wire        sc_addr_eq;
wire        sc_cancel_req;
//================================ 异常相关信号 ================================
wire        EXE_ex;
wire [15:0] EXE_excp_num;
wire        EXE_ertn_flush;
wire        excp_ale; // ALE 异常，地址非对齐
wire        excp_tlbrefill_data; // 访存时触发的tlb重填例外
wire        excp_pil;
wire        excp_pis;
wire        excp_ppi;
wire        excp_pme;
wire        excp_tlb;
//================================ TLB指令相关控制信号 ================================
wire            EXE_tlbsrch_en;
wire            EXE_tlbwr_en;
wire            EXE_tlbfill_en;
wire            EXE_tlbrd_en;
//================================ cacop指令相关信号 ================================
wire [ 4:0] cacop_op;
wire        icacop_inst;
wire        dcacop_inst;
cache_bus_t cache_bus;
// 分支预测信号
wire        EXE_is_last_in_block;

//================================ 主要逻辑实现 ================================
reg nop; // 花费一个寄存器来空接信号，这样不是最好的做法但暂时想不到更好的方法了
//================================ 流水段控制逻辑 ================================
reg need_pause; // 后面的指令发现异常了，前递到exe，阻塞exe
always_ff @(posedge clk) begin
    if (reset | flush_sign) begin
        need_pause <= 1'b0;
    end else if (REQ_pause) begin
        need_pause <= 1'b1;
    end
end
assign exe_ready_go    = 1'b1 & ~REQ_pause & ~need_pause;
//================================ 与前后流水级的通信 ================================
always @(posedge clk) begin
    if (reset | flush_sign) begin
        EXE_valid <= 1'b0;
    end
    else if (EXE_allow_in) begin
        EXE_valid <= ISS_EXE_bus.valid;
    end

    if (ISS_EXE_bus.valid & EXE_allow_in) begin
    	{nop, // EXE_valid不能在两个条件下同时赋值

        EXE_ROB_idx,

    	EXE_alu_op,
        EXE_mul_op,
        EXE_div_op,
        EXE_src1,
        EXE_src2,
        EXE_rkd_value,
    	EXE_gr_we,
    	EXE_dest,
    	EXE_ld_en,
        EXE_st_en,
        EXE_ll_w,
        EXE_sc_w,

        ISS_csr_re,
        ISS_csr_we,
        ISS_csr_num,
        inst_csrxchg,

        EXE_cacop,
        ISS_ertn_flush,
        ISS_ex,
        ISS_excp_num,
        EXE_op_timer_64,
        /*TLB指令相关控制信号*/
        ISS_tlbsrch_en,
        ISS_tlbwr_en,
        ISS_tlbfill_en,
        ISS_tlbrd_en,
        EXE_invtlb_en,
        EXE_invtlb_op,

        ISS_next_need_refetch,
        EXE_refetch_flush,

        EXE_ftq_id,   // FTQ块的索引
        EXE_ftq_block_idx,  // 在FTQ块中的索引
        ISS_is_last_in_block  // 是否是块中的最后一条指令（决定后端在FTQ中提交）
        `ifdef DIFFTEST_EN
        ,
        EXE_inst,
        EXE_cnt_inst,
        EXE_csr_rstat_en
        `endif
         } <= ISS_EXE_bus;
    end
end

wire csr_tlb_type;
assign csr_tlb_type = EXE_csr_re | EXE_csr_we | EXE_tlbsrch_en | EXE_tlbrd_en | EXE_tlbwr_en | EXE_tlbfill_en | EXE_invtlb_en;

/*EXE和MEM阶段的通信总线*/
//注意mul和div的计算结果由MEM直接从端口获取
assign EXE_REQ_bus = {
                    EXE_valid & EXE_ready_go & ~redirect_flush,

                    EXE_ROB_idx,

					EXE_dest,//5位
					EXE_gr_we,//1位

                    EXE_src1, //32
                    EXE_src2, //32

                    mem_addr,//32位，作为访存地址往下传
                    paddr,
					final_result,//32位，作为写回寄存器的数据往下传

                    EXE_ld_en,//3
                    EXE_mem_we,//1
                    EXE_ll_w,//1位
                    EXE_sc_w,//1位

                    sc_cancel_req,
                    data_sram_bus,

                    csr_tlb_type,//1位
                    EXE_csr_we,//1位
                    EXE_csr_num,//14位
                    inst_csrxchg,

                    EXE_ertn_flush,//1位

                    EXE_ex,//1位
                    EXE_excp_num,//16位

                    /*TLB指令相关控制信号*/
                    EXE_tlbsrch_en,//1位
                    data_tlb_found,
                    data_tlb_index,
                    EXE_tlbwr_en,//1位
                    EXE_tlbfill_en,//1位
                    EXE_tlbrd_en,//1位
                    EXE_invtlb_en,
                    EXE_invtlb_op,

                    EXE_refetch_flush,//1位

                    // cacop指令相关信号
                    cache_bus,
                    // 分支预测信号
                    EXE_ftq_id,
                    EXE_ftq_block_idx,
                    EXE_is_last_in_block

                    // difftest
                    `ifdef DIFFTEST_EN
                    ,
                    timer_64_rdata,//64
                    EXE_inst,//32
                    EXE_inst_ld_en,//8
                    EXE_inst_st_en,//8
                    EXE_cnt_inst,//1
                    EXE_csr_rstat_en,//1
                    csr_rdata,//32
                    data_sram_bus.data_sram_wdata//32
                    `endif
};
//================================ 数据前递 ================================
assign EXE_pause = (EXE_ex | EXE_ertn_flush | EXE_refetch_flush) & EXE_valid; // 该信号要前递，需确保有效

//================================ 访存控制 ================================
assign EXE_res_from_mem = |EXE_ld_en; // |EXE_ld_en表示是访存指令
assign EXE_mem_we = |EXE_st_en | (EXE_sc_w & llbit); // 此时拿到的llbit是正确的，考虑过冒险了
assign mem_addr = EXE_src1 + EXE_src2;
/*向数据ram发送读取或者写入请求*/
assign data_sram_saddr_low2bit = {mem_addr[1],mem_addr[0]};
// 字节写使能生成
assign  stb_wen = { data_sram_saddr_low2bit==2'b11  ,
                    data_sram_saddr_low2bit==2'b10  ,
                    data_sram_saddr_low2bit==2'b01  ,
                    data_sram_saddr_low2bit==2'b00} ;
// 半字写使能生成
assign  sth_wen = { data_sram_saddr_low2bit==2'b10  ,
                    data_sram_saddr_low2bit==2'b10  ,
                    data_sram_saddr_low2bit==2'b00  ,
                    data_sram_saddr_low2bit==2'b00} ;

assign access_mem       = EXE_res_from_mem | EXE_mem_we; // 表示该指令可能需要访存，包括load和store指令、ll.w和sc.w指令
// 被flush_sign清空流水线时、发生异常时、打上重取标记时，表示访存请求已经无效了，不需要进行访存
assign data_valid       = EXE_valid & ~flush_sign & ~EXE_ex & ~EXE_refetch_flush;

assign wstrb_mask = 
    { {8{data_sram_bus.data_sram_wstrb[3]}}, 
      {8{data_sram_bus.data_sram_wstrb[2]}}, 
      {8{data_sram_bus.data_sram_wstrb[1]}},  
      {8{data_sram_bus.data_sram_wstrb[0]}} }; 

// sc.w写一个字的数据
assign data_sram_bus.data_sram_wstrb  =  {{4{EXE_st_en == ST_B}} & stb_wen| 
                            {4{EXE_st_en == ST_H}} & sth_wen|
                            {4{EXE_st_en == ST_W}} & 4'b1111|
                            {4{EXE_sc_w & llbit}} & 4'b1111}
                            & {4{EXE_valid}} & ~{4{EXE_ex}} & ~{4{EXE_refetch_flush}}; // 发生异常时，打上重取标记时，不能写存
assign data_sram_bus.data_sram_wr     = EXE_mem_we;//如果当前是访存指令,则由于EXE_mem_we正好为0,可以表示读操作
// sc.w写一个字的数据
assign data_sram_bus.data_sram_size   =  EXE_mem_we ? {(EXE_sc_w & llbit) | EXE_st_en == ST_W, EXE_st_en == ST_H} : //存储半字:2'b01,存储一个字:2'b10,存储1个字节:2'00,读取指令:2'10
                                                      {{EXE_ld_en == LD_W, (EXE_ld_en == LD_H | EXE_ld_en == LD_HU)}};

assign data_sram_bus.data_sram_wdata = (EXE_st_en == ST_B)  ? {4{EXE_rkd_value[ 7:0]}} & wstrb_mask :
                                       (EXE_st_en == ST_H)  ? {2{EXE_rkd_value[15:0]}} & wstrb_mask :
                                                              EXE_rkd_value ;


//================================ ll.w和sc.w指令的处理逻辑 ================================
assign paddr = {data_tag, data_index, data_offset}; // 地址翻译后的物理地址
assign sc_addr_eq = (lladdr == paddr[31:4]);     // sc.w指令存放数据的物理地址和ll.w指令访问的物理地址是否相等
assign sc_cancel_req = (~sc_addr_eq | cache_bus.data_uncache_en) & EXE_sc_w & access_mem; // 地址不匹配或dcache强序非缓存时，sc.w指令取消请求

//================================ 结果选择 ================================
always_comb begin : final_result_select
    unique case (1'b1)
        EXE_csr_re:         final_result = csr_rdata            ; // csrrd、csrwr、csrxchg、rdcntid_w指令
        EXE_op_timer_64[0]: final_result = timer_64_rdata[31:0] ; // rdcntvl_w指令
        EXE_op_timer_64[1]: final_result = timer_64_rdata[63:32]; // rdcntvh_w指令
        sc_cancel_req:      final_result = 32'b0                ; // sc.w指令取消，向rd写回全0
        default:            final_result = {31'b0, llbit}       ; // sc.w指令，正常进行
    endcase
end

//================================ CSR信号处理 ================================
assign EXE_csr_re = ISS_csr_re;
assign EXE_csr_we = ISS_csr_we & EXE_valid & ~EXE_ex & ~EXE_refetch_flush;// 发生异常时，不能写csr
assign EXE_csr_num = ISS_csr_num;
//================================ 异常处理 ================================
/*发生在EXE阶段的异常有：（按优先级排列）
1.要求地址对齐的访存指令因地址不对齐而产生的地址对齐错例外 ALE
2.tlb重填例外 TLBR
3.load操作页无效例外 PIL
4.store操作页无效例外 PIS
5.页特权等级不合规例外 PPI
6.页修改例外 PME
*/
assign excp_ale = ((EXE_ld_en == LD_H | EXE_ld_en == LD_HU | EXE_st_en == ST_H) & (data_sram_saddr_low2bit[0] != 1'b0)) // 传输半字的指令：ld_h,ld_hu,st_h
                | ((EXE_ld_en == LD_W | EXE_st_en == ST_W) & (data_sram_saddr_low2bit != 2'b00)) ; // 传输一个字的指令：ld_w,st_w,还有ll.w和sc.w指令没写
assign excp_tlbrefill_data  = addr_trans_bus.data_addr_trans_en & ~data_tlb_found & (access_mem | EXE_cacop);                                                   // 需要进行页表地址翻译时
assign excp_pil             = addr_trans_bus.data_addr_trans_en &  data_tlb_found & (EXE_res_from_mem | EXE_cacop) & ~data_tlb_v;                              // 需要进行页表地址翻译时
assign excp_pis             = addr_trans_bus.data_addr_trans_en &  data_tlb_found & EXE_mem_we       & ~data_tlb_v;                              // 需要进行页表地址翻译时
assign excp_ppi             = addr_trans_bus.data_addr_trans_en &  data_tlb_found & access_mem       &  data_tlb_v & (csr_plv > data_tlb_plv);  // 需要进行页表地址翻译时
assign excp_pme             = addr_trans_bus.data_addr_trans_en &  data_tlb_found & EXE_mem_we       &  data_tlb_v & (csr_plv <= data_tlb_plv) & ~data_tlb_d;// 需要进行页表地址翻译时
assign excp_tlb             = excp_tlbrefill_data | excp_pil | excp_pis | excp_ppi | excp_pme;

assign EXE_ertn_flush = ISS_ertn_flush & EXE_valid; 
assign EXE_ex         = (ISS_ex | excp_ale | excp_tlb) & EXE_valid; // 这个信号会往前传，需要保证是有效的
assign EXE_excp_num   = {excp_pil, excp_pis, excp_ppi, excp_pme, excp_tlbrefill_data, 1'b0, excp_ale, ISS_excp_num}; // openla是这么干的，不知道为什么第10位要空置一个0
//================================ TLB控制 ================================
/*TLB指令相关控制信号*/ // 指令走的时候才发tlbsrch_en
assign EXE_tlbsrch_en   = ISS_tlbsrch_en & EXE_valid & ~EXE_ex & ~EXE_refetch_flush & exe_ready_go; // 因为tlbsrch在EXE阶段要修改csr，所以必须保证有效
assign EXE_tlbwr_en     = ISS_tlbwr_en;
assign EXE_tlbfill_en   = ISS_tlbfill_en;
assign EXE_tlbrd_en     = ISS_tlbrd_en;
//================================ 地址翻译 ================================
/*传入addr_trans的地址翻译相关逻辑*/
wire   da_mode;
wire   pg_mode;
assign da_mode = csr_da & ~csr_pg; // 直接地址翻译模式
assign pg_mode = csr_pg & ~csr_da; // 映射地址翻译模式

// 直接映射配置窗口，如果映射到了窗口上，就进行直接映射地址翻译
assign addr_trans_bus.dmw0_en = ((csr_dmw0[`DMW_PLV0] & csr_plv == 2'd0) | (csr_dmw0[`DMW_PLV3] & csr_plv == 2'd3)) & (addr_trans_bus.data_vaddr[31:29] == csr_dmw0[`DMW_VSEG]) & pg_mode;
assign addr_trans_bus.dmw1_en = ((csr_dmw1[`DMW_PLV0] & csr_plv == 2'd0) | (csr_dmw1[`DMW_PLV3] & csr_plv == 2'd3)) & (addr_trans_bus.data_vaddr[31:29] == csr_dmw1[`DMW_VSEG]) & pg_mode;

/*
这里addr_trans_bus.data_fetch的生成逻辑很乱，不知道怎样写是最准确的。
addr_trans_bus.data_fetch表示需要进行tlb表项查找操作，这包含两种情况：
1.访存指令的虚地址进行地址翻译时；
2.tlbsrch指令进行tlb表项查找操作，复用了访存地址翻译的数据通路。
3.cacop对icache和dcache进行操作时，需要先进行地址翻译，复用
*/
assign addr_trans_bus.data_fetch = 1'b0; // 不用
assign addr_trans_bus.data_vaddr = ISS_tlbsrch_en ? csr_tlbehi : mem_addr; // 用的是ISS_tlbsrch_en，因为只需要确定这条指令是tlbsrch指令来确定vaddr
assign addr_trans_bus.data_addr_trans_en = pg_mode & ~addr_trans_bus.dmw0_en & ~addr_trans_bus.dmw1_en & ~cache_bus.cacop_op_mode_di;

//================================ 存储访问类型的判定 ================================
assign cache_bus.data_uncache_en = (da_mode & (csr_datm == 2'b0))                     | 
                         (addr_trans_bus.dmw0_en & (csr_dmw0[`DMW_MAT] == 2'b0))      |
                         (addr_trans_bus.dmw1_en & (csr_dmw1[`DMW_MAT] == 2'b0))      |
                         (addr_trans_bus.data_addr_trans_en & (data_tlb_mat == 2'b0)) ;

//================================ cacop指令的处理逻辑 ================================
assign cacop_op                 = EXE_dest; // cacop指令的code码，指示类型
assign icacop_inst              = EXE_cacop & (cacop_op[2:0] == 3'b0); // code操作码表示需要对icache进行操作
assign cache_bus.icacop_op_en   = icacop_inst & data_valid;            // 考虑了有效性后，表示确实需要对icache进行操作
assign dcacop_inst              = EXE_cacop & (cacop_op[2:0] == 3'b1); // code操作码表示需要对dcache进行操作
assign cache_bus.dcacop_op_en   = dcacop_inst & data_valid;            // 考虑了异常和有效性后，表示确实需要对dcache进行操作
assign cache_bus.cacop_op_mode  = cacop_op[4:3];                        // 指示要进行初始化还是一致性维护，以及索引方式

assign cache_bus.cacop_pa       = paddr;
assign cache_bus.cacop_op_mode_di=EXE_cacop & ((cache_bus.cacop_op_mode == 2'b0) | (cache_bus.cacop_op_mode == 2'b1));

// 分支预测信号
assign EXE_is_last_in_block = ISS_is_last_in_block;

// difftest
`ifdef DIFFTEST_EN
assign EXE_inst_ld_en = {2'b0, (EXE_ld_en == LL_W), (EXE_ld_en == LD_W), (EXE_ld_en == LD_HU), (EXE_ld_en == LD_H), (EXE_ld_en == LD_BU), (EXE_ld_en == LD_B)};
assign EXE_inst_st_en = {4'b0, (EXE_sc_w & llbit), (EXE_st_en == ST_W), (EXE_st_en == ST_H), (EXE_st_en == ST_B)};
`endif
endmodule