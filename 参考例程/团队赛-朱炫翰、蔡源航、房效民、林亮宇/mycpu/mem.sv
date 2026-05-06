`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module mem
    import pipeline_types::*;
    import core_defines::*;
(
    //输入时钟和复位
    input  logic     clk ,
    input  logic     reset,
    //================================ 模块准备信号 ================================
    output reg       MEM_valid,
    output logic     mem_ready_go,
    input  logic     MEM_ready_go, // MEM阶段完成处理标志
    //================================ 流水线握手信号 ================================
    input  logic     MEM_allow_in,           //MEM阶段可以输入
    input  logic     WB_allow_in,            //WB阶段可以输入
    //================================ 流水线间通信总线 ================================
    //EXE和MEM的通信
    input  REQ_MEM_bus_t REQ_MEM_bus,          //EXE送至MEM阶段信号
    //MEM和WB的通信
    output MEM_WB_bus_t  MEM_WB_bus,           //MEM送至WB的信号
    //================================ 数据存储器接口 ================================
    input  logic [31: 0] data_sram_rdata,
    input  logic         data_sram_data_ok,
    //================================ 乘除模块接口 ================================
    input  logic [63: 0] MEM_mul_result,
    input  logic [63: 0] MEM_div_result,
    //================================ 前递接口 ================================
    //输出当前阶段的目的寄存器,注意这个目的寄存器的生成逻辑，实际上包含了使能和流水段数据有效
    output logic [4 : 0] MEM_to_ISS_dest,
    output logic [31: 0] MEM_to_ISS_forward,
    // 新增的数据前递信号
    output logic         MEM_csr_we,
    output logic [13: 0] MEM_csr_num,
    output logic         MEM_pause,
    //================================ cacop指令接口 ================================
    input  logic         icacop_ok,
    input  logic         dcacop_ok,
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    input  logic         flush_sign
    );
`ifdef DIFFTEST_EN
reg  MEM_cnt_inst;
reg  [31:0] MEM_inst;
reg  [63:0] MEM_timer_64;
reg  [7:0] MEM_inst_ld_en;
reg  [7:0] MEM_inst_st_en;
reg  MEM_csr_rstat_en;
reg  [31:0] MEM_csr_rdata;
reg  [31:0] MEM_st_data;
`endif
//================================ 前一流水级传过来的信号 ================================
reg          MEM_gr_we;       // 寄存器写使能
logic [$clog2(ROB_DEPTH)-1:0]   MEM_ROB_idx;
reg   [4:0]  MEM_dest;        // 目的寄存器编号
reg   [31:0] MEM_mem_addr;    // 访存地址
reg   [31:0] MEM_paddr;       // 物理地址
reg   [31:0] EXE_final_result; // EXE阶段计算结果
reg   [2:0]  MEM_ld_en;       // 加载类型使能
reg          MEM_mem_we;       // 存储类型使能
reg          MEM_ll_w;        // ll.w指令
reg          MEM_sc_w;        // sc.w指令
reg          MEM_data_uncache_en; // dcache强序非缓存
/*CSR相关*/
reg          csr_tlb_type;
reg          EXE_csr_we;
reg   [13:0] EXE_csr_num;
reg   [31:0] EXE_csr_wmask;
reg   [31:0] EXE_csr_wdata;
/*TLB指令相关控制信号*/
reg          MEM_tlbwr_en;
reg          MEM_tlbfill_en;
reg          MEM_tlbrd_en;
reg          MEM_refetch_flush;

reg          EXE_ertn_flush;

/*异常相关信号*/
reg          EXE_ex;
reg   [15:0] EXE_excp_num;

/*cacop指令信号*/
reg          MEM_icacop_op_en;
reg          MEM_dcacop_op_en;
logic         cacop_pause; // 表示对于cacop指令，cache操作未完成时暂停流水线

/*分支预测信号*/
logic [$clog2(FRONTEND_FTQ_SIZE)-1:0]   MEM_ftq_id;   // FTQ块的索引
logic [$clog2(FETCH_WIDTH)-1:0]         MEM_ftq_block_idx;  // 在FTQ块中的索引
logic                                   MEM_is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

//================================ 访存相关的信号 ================================
logic        MEM_res_from_mem;
logic        access_mem;
logic [1 :0] MEM_size;
logic        MEM_sign_exted;
logic [1 :0] data_sram_addr_low2bit; // 地址低2位
logic [31:0] MEM_result;     //访存指令的最终结果
logic [31:0] MEM_wordload;
logic [7 :0] MEM_byteLoaded;
logic [15:0] MEM_halfLoaded;
reg  [31:0] data_rd_buff;  // 数据读取缓冲
reg         data_buff_enable; // 缓冲有效标志
//================================ 结果信号 ================================
logic [31:0] MEM_final_result;
//================================ csr指令相关信号 ================================
logic [31:0] MEM_csr_wmask;
logic [31:0] MEM_csr_wdata;
//================================ 异常相关信号 ================================
logic        MEM_ex;
logic [15:0] MEM_excp_num;
logic        MEM_ertn_flush;


//================================ 主要逻辑实现 ================================
reg         nop;
//================================ 流水段控制逻辑 ================================
assign cacop_pause  = (MEM_icacop_op_en && !icacop_ok) || (MEM_dcacop_op_en && !dcacop_ok) ; // 对于cacop指令，若操作icache，则等待icacop_ok返回

// 改成store指令不阻塞MEM阶段，而是允许继续
assign mem_ready_go = ((data_sram_data_ok || data_buff_enable || ~MEM_res_from_mem) // or ~MEM_res_from_mem
                        && !cacop_pause)
                        || MEM_ex || MEM_refetch_flush; // 发生异常时，打上重取标记时，允许继续


// assign mem_ready_go = ((data_sram_data_ok || data_buff_enable || !access_mem)
//                         && !cacop_pause)
//                         || MEM_ex || MEM_refetch_flush; // 发生异常时，打上重取标记时，允许继续

//================================ 与前后流水级的通信 ================================
always @(posedge clk) begin
    if (reset || flush_sign) begin
        MEM_valid <= 1'b0;
    end
    else if (MEM_allow_in) begin
        MEM_valid <= REQ_MEM_bus.valid;
    end

    if (REQ_MEM_bus.valid && MEM_allow_in) begin
    	{nop,
        MEM_ROB_idx,
		MEM_dest,
        MEM_gr_we,

		MEM_mem_addr, // 访存地址
        MEM_paddr,    // 访存物理地址
        EXE_final_result, // EXE阶段产生的写回寄存器的数据
        MEM_ld_en,
        MEM_mem_we,
        MEM_ll_w,
        MEM_sc_w,
        MEM_data_uncache_en,
        
        csr_tlb_type,
        EXE_csr_we,
        EXE_csr_num,
        EXE_csr_wmask,
        EXE_csr_wdata,
        
        EXE_ertn_flush,
        EXE_ex,
        EXE_excp_num,
        /*TLB指令相关控制信号*/
        MEM_tlbwr_en,
        MEM_tlbfill_en,
        MEM_tlbrd_en,
        MEM_refetch_flush,
        /*cacop指令信号*/
        MEM_icacop_op_en,
        MEM_dcacop_op_en,
        // 分支预测信号
        MEM_ftq_id,   // FTQ块的索引
        MEM_ftq_block_idx,  // 在FTQ块中的索引
        MEM_is_last_in_block  // 是否是块中的最后一条指令（决定后端在FTQ中提交）
        /*difftest*/
        `ifdef DIFFTEST_EN
        ,
        MEM_timer_64,
        MEM_inst,
        MEM_inst_ld_en,
        MEM_inst_st_en,
        MEM_cnt_inst,
        MEM_csr_rstat_en,
        MEM_csr_rdata,
        MEM_st_data
        `endif
        } <= REQ_MEM_bus;
    end
end

/*传输给WB阶段的信号*/
assign MEM_WB_bus = {
                    MEM_valid && MEM_ready_go,

                    MEM_ROB_idx,
                    MEM_mem_addr,//32位
                    MEM_paddr,//32位
					MEM_gr_we,//1位
					MEM_dest,//5位
					MEM_final_result,//32位

                    MEM_ll_w,//1位
                    MEM_sc_w,//1位
                    MEM_data_uncache_en,//1位

                    csr_tlb_type,//1位
                    MEM_csr_we,//1位
                    MEM_csr_num,//14位
                    MEM_csr_wmask,//32位
                    MEM_csr_wdata,//32位

                    MEM_ertn_flush,//1位
                    MEM_ex,//1位
                    MEM_excp_num,//16位
                    /*TLB指令相关控制信号*/
                    MEM_tlbwr_en,//1位
                    MEM_tlbfill_en,//1位
                    MEM_tlbrd_en,//1位
                    MEM_refetch_flush, //1位
                    // 分支预测信号
                    MEM_ftq_id,   // FTQ块的索引
                    MEM_ftq_block_idx,  // 在FTQ块中的索引
                    MEM_is_last_in_block  // 是否是块中的最后一条指令（决定后端在FTQ中提交）
                    `ifdef DIFFTEST_EN
                    ,
                    MEM_timer_64,//64
                    MEM_inst,//32
                    MEM_inst_ld_en,//8
                    MEM_inst_st_en,//8
                    MEM_cnt_inst,//1
                    MEM_csr_rstat_en,//1
                    MEM_csr_rdata,//32
                    MEM_st_data //32
                    `endif
};

//================================ 数据前递 ================================
/*输出给ISS阶段的目的寄存器编号*/
//注意这里同时和流水段数据有效信号和寄存器写使能信号进行与逻辑，如果数据无效或者寄存器写使能无效那么输出的寄存器编号就是0
assign MEM_to_ISS_dest = MEM_dest & {5{MEM_valid}} & {5{MEM_gr_we}};
assign MEM_to_ISS_forward = MEM_final_result;
assign MEM_pause = (MEM_ex || MEM_ertn_flush || MEM_refetch_flush) && MEM_valid;

//================================ 访存处理 ==============================
assign MEM_res_from_mem = |MEM_ld_en;
assign access_mem = MEM_mem_we || MEM_res_from_mem;
assign data_sram_addr_low2bit = {MEM_mem_addr[1],MEM_mem_addr[0]};
// 加载数据对齐处理
assign MEM_size = {MEM_ld_en == LD_H | MEM_ld_en == LD_HU ,MEM_ld_en == LD_B | MEM_ld_en == LD_BU};
assign MEM_sign_exted = MEM_ld_en == LD_H | MEM_ld_en == LD_B;
// 数据选择：使用缓冲或直接读取
assign MEM_wordload = data_buff_enable ? data_rd_buff : data_sram_rdata;
// 字节加载
always_comb begin
    unique case (data_sram_addr_low2bit)
        2'b00 : MEM_byteLoaded = MEM_wordload[ 7: 0];
        2'b01 : MEM_byteLoaded = MEM_wordload[15: 8];
        2'b10 : MEM_byteLoaded = MEM_wordload[23:16];
        default:MEM_byteLoaded = MEM_wordload[31:24];
    endcase
end

// assign MEM_byteLoaded = ({8{data_sram_addr_low2bit==2'b00}} & MEM_wordload[ 7: 0]) |
//                         ({8{data_sram_addr_low2bit==2'b01}} & MEM_wordload[15: 8]) |
//                         ({8{data_sram_addr_low2bit==2'b10}} & MEM_wordload[23:16]) |
//                         ({8{data_sram_addr_low2bit==2'b11}} & MEM_wordload[31:24]) ; 

// 半字加载
assign MEM_halfLoaded = data_sram_addr_low2bit == 2'b00 ? MEM_wordload[15: 0] : MEM_wordload[31:16] ;

// assign MEM_halfLoaded = ({16{data_sram_addr_low2bit==2'b00}} & MEM_wordload[15: 0]) |
//                         ({16{data_sram_addr_low2bit==2'b10}} & MEM_wordload[31:16]) ;

// 数据缓冲管理
always @(posedge clk) begin
    if (reset || (MEM_ready_go && WB_allow_in) || flush_sign) begin
        data_rd_buff <= 32'b0;
        data_buff_enable <= 1'b0;
    end
    else if (data_sram_data_ok && !WB_allow_in) begin
        data_rd_buff <= data_sram_rdata;
        data_buff_enable <= 1'b1;
    end
end
//================================ 结果选择 ================================
// 最终加载结果（含符号扩展）

always_comb begin
    unique case (1'b1)
        MEM_size[0] &&  MEM_sign_exted : MEM_result = {{24{MEM_byteLoaded[ 7]}}, MEM_byteLoaded};
        MEM_size[0] && ~MEM_sign_exted : MEM_result = { 24'b0                  , MEM_byteLoaded};
        MEM_size[1] &&  MEM_sign_exted : MEM_result = {{16{MEM_halfLoaded[15]}}, MEM_halfLoaded};
        MEM_size[1] && ~MEM_sign_exted : MEM_result = { 16'b0                  , MEM_halfLoaded};
        default                        : MEM_result = MEM_wordload                              ;
    endcase
end

// assign MEM_result = ({32{MEM_size[0] &&  MEM_sign_exted}} & {{24{MEM_byteLoaded[ 7]}}, MEM_byteLoaded}) |
//                     ({32{MEM_size[0] && ~MEM_sign_exted}} & { 24'b0                  , MEM_byteLoaded}) |
//                     ({32{MEM_size[1] &&  MEM_sign_exted}} & {{16{MEM_halfLoaded[15]}}, MEM_halfLoaded}) |
//                     ({32{MEM_size[1] && ~MEM_sign_exted}} & { 16'b0                  , MEM_halfLoaded}) |
//                     ({32{!MEM_size}}                         &   MEM_wordload                                  ) ;

/*访存阶段选择最终的结果*/
always_comb begin
    unique case (1'b1)
        MEM_res_from_mem : MEM_final_result = MEM_result        ;  
        default          : MEM_final_result = EXE_final_result  ;
    endcase
end

//================================ CSR控制 ================================
assign MEM_csr_we = EXE_csr_we && MEM_valid && !MEM_ex && !MEM_refetch_flush; // 发生异常时，打上重取标记时，不能写csr
assign MEM_csr_num = EXE_csr_num;
assign MEM_csr_wmask = EXE_csr_wmask;
assign MEM_csr_wdata = EXE_csr_wdata;

//================================ 异常处理 ================================
assign MEM_ertn_flush = EXE_ertn_flush && MEM_valid;
assign MEM_ex         = EXE_ex && MEM_valid; // 这个信号会往前传，需要保证是有效的
assign MEM_excp_num   = EXE_excp_num;


endmodule