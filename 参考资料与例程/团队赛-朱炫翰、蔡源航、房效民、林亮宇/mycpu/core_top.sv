`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
`include "tlb_defines.sv"
`include "bpu_defines.sv"

module core_top
    import core_defines::*;
    import bpu_defines::*;
    import tlb_types::*;
    import pipeline_types::*;
#(
    parameter TLBNUM = 8
) (
    input  wire        aclk,
    input  wire        aresetn,
    input    [ 7:0] intrpt, 

    //与指令ram
    output wire [3 :0]  arid,
    output wire [31:0]  araddr,
    output wire [7 :0]  arlen,
    output wire [2 :0]  arsize,
    output wire [1 :0]  arburst,
    output wire [1 :0]  arlock,
    output wire [3 :0]  arcache,
    output wire [2 :0]  arprot,
    output wire         arvalid,
    input  wire         arready,
    //r
    input  wire  [3 :0] rid,
    input  wire  [31:0] rdata,
    input  wire  [1 :0] rresp,
    input  wire         rlast,
    input  wire         rvalid,
    output wire         rready,
    //aw
    output wire [3 :0]  awid,
    output wire [31:0]  awaddr,
    output wire [7 :0]  awlen,
    output wire [2 :0]  awsize,
    output wire [1 :0]  awburst,
    output wire [1 :0]  awlock,
    output wire [3 :0]  awcache,
    output wire [2 :0]  awprot,
    output wire         awvalid,
    input  wire         awready,
    //w
    output wire [3 :0]  wid,
    output wire [31:0]  wdata,
    output wire [3 :0]  wstrb,
    output wire         wlast,
    output wire         wvalid,
    input  wire         wready,
    //b
    input  wire [3 :0]  bid,
    input  wire [1 :0]  bresp,
    input  wire         bvalid,
    output wire         bready,

    input           break_point,
    input           infor_flag,
    input  [ 4:0]   reg_num,
    output          ws_valid,
    output [31:0]   rf_rdata


    //下面四个接口用来给gettrace提供debug信息
    //`ifdef DIFFTEST_EN
    ,
    output wire [31:0]  debug0_wb_pc,
    output wire [ 3:0]  debug0_wb_rf_wen,
    output wire [ 4:0]  debug0_wb_rf_wnum,
    output wire [31:0]  debug0_wb_rf_wdata,
    output wire [31:0]  debug0_wb_inst
   /* `else
    ,
    output wire [31:0]  debug_wb_pc,
    output wire [ 3:0]  debug_wb_rf_we,
    output wire [ 4:0]  debug_wb_rf_wnum,
    output wire [31:0]  debug_wb_rf_wdata
    `endif*/
);

//parameter DIFFTEST_EN = 0;

/*复位信号*/
/*(* mark_debug="true", keep="true" *)*/reg         reset;
/*(* mark_debug="true", keep="true" *)*/wire clk = aclk;
always @(posedge clk) reset <= ~aresetn;


/*流水线握手信号*/
wire                top_RA_allow_in;
wire [FU_NUM-1:0]   top_FU_allow_in;
wire                top_IF_to_ID_valid;

/*流水段通信总线*/
ID_RA_bus_t  [DECODER_WIDTH-1:0] top_ID_RA_bus;
ISS_EXE_bus_t[FU_NUM-BU_NUM-1:0] top_ISS_EXE_bus;
BU_bus_t                         top_BU_bus;
commit_bus_t [COMMIT_WIDTH-1:0]  top_commit_bus;

/*和寄存器通信的信号*/
wire [COMMIT_WIDTH-1:0]         rf_we;
wire [COMMIT_WIDTH-1:0] [4 : 0] rf_waddr;
wire [COMMIT_WIDTH-1:0] [31: 0] rf_wdata;
wire [DECODER_WIDTH-1:0][4 : 0] rf_raddr1;
wire [DECODER_WIDTH-1:0][31: 0] rf_rdata1;
wire [DECODER_WIDTH-1:0][4 : 0] rf_raddr2;
wire [DECODER_WIDTH-1:0][31: 0] rf_rdata2;

//================================ 前端信号 ================================
// 分支重定向以及冲刷
logic top_backend_redirect;
logic [ADDR_WIDTH-1:0] top_backend_redirect_next_pc;
logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] top_backend_redirect_ftq_id; 
logic top_backend_flush;
logic [ADDR_WIDTH-1:0] top_backend_flush_next_pc;
logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] top_backend_flush_ftq_id;
// 锁存重定向信息
/*(* mark_debug="true", keep="true" *)*/logic top_backend_redirect_r;
logic [ADDR_WIDTH-1:0] top_backend_redirect_next_pc_r;
logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] top_backend_redirect_ftq_id_r;
// 锁存冲刷信息
/*(* mark_debug="true", keep="true" *)*/logic top_backend_flush_r;
logic [ADDR_WIDTH-1:0] top_backend_flush_next_pc_r;
logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] top_backend_flush_ftq_id_r;
// 后端提交
logic [COMMIT_WIDTH-1:0] top_backend_commit_bitmask;              
logic [COMMIT_WIDTH-1:0] top_backend_commit_block_bitmask;        
logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] top_backend_commit_ftq_id;               
backend_commit_meta_t top_backend_commit_meta;
// 后端提交信息锁存
logic [COMMIT_WIDTH-1:0] top_backend_commit_bitmask_r;              
logic [COMMIT_WIDTH-1:0] top_backend_commit_block_bitmask_r;        
logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] top_backend_commit_ftq_id_r;               
backend_commit_meta_t top_backend_commit_meta_r;
always_ff @(posedge clk) begin  // 延迟提交方便布线
    top_backend_commit_bitmask_r <= top_backend_commit_bitmask;
    top_backend_commit_block_bitmask_r <= top_backend_commit_block_bitmask;
    top_backend_commit_ftq_id_r <= top_backend_commit_ftq_id;
    top_backend_commit_meta_r <= top_backend_commit_meta;
end
// ftq更新
backend_ftq_meta_updata_t top_backend_ftq_updata_info;
backend_ftq_meta_updata_t top_backend_ftq_updata_info_r;
always_ff @(posedge clk) begin  // 延迟提交方便布线
    top_backend_ftq_updata_info_r <= top_backend_ftq_updata_info;
end
// 指令缓冲
logic top_inst_buffer_full;          
logic top_pre_decoder_ready_go;   
instr_info_t top_instr_buffer[FETCH_WIDTH];           
logic [$clog2(FETCH_WIDTH+1)-1:0] top_instr_buffer_length;
assign top_IF_to_ID_valid = top_pre_decoder_ready_go;
// 后端查询pc
BU_ras_op_t top_BU_ras_data;
logic [ADDR_WIDTH-1:0] top_ex_query_pc;

logic [ISSUE_WIDTH-1:0][$clog2(FRONTEND_FTQ_SIZE)-1:0] top_iss_query_id;
logic [ISSUE_WIDTH-1:0][ADDR_WIDTH-1:0]                top_iss_pc_query;
logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] top_ctrl_query_id;
logic [ADDR_WIDTH-1:0] top_iss0_pc_query;
logic [ADDR_WIDTH-1:0] top_iss1_pc_query;
logic [ADDR_WIDTH-1:0] top_ctrl_pc_query;

// 地址翻译提前唤醒
logic [ADDR_WIDTH-1:0] inst_sram_paddr;

//================================ 与IQ、ROB的数据接口 ================================
logic [DECODER_WIDTH-1:0] top_IQ_ROB_enqueue_en ;
IQ_t  [DECODER_WIDTH-1:0] top_IQ_enqueue_data   ;
ROB_t [DECODER_WIDTH-1:0] top_ROB_enqueue_data  ;
//================================ 与RAT的接口 ================================
// 读
logic [DECODER_WIDTH-1:0][ 4:0]                 top_src1_addr  ;
logic [DECODER_WIDTH-1:0][ 4:0]                 top_src2_addr  ;
logic [DECODER_WIDTH-1:0]                       top_src1_valid ;
logic [DECODER_WIDTH-1:0]                       top_src2_valid ;
logic [DECODER_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0]top_src1_prf   ;
logic [DECODER_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0]top_src2_prf   ;
// 写
logic [DECODER_WIDTH-1:0]                       top_RAT_we        ;
logic [DECODER_WIDTH-1:0][ 4:0]                 top_RAT_waddr     ;
logic [DECODER_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0]top_RAT_wprf      ;
// retire时的无效化
logic [COMMIT_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0] top_invalid_ROB_idx ;
logic [COMMIT_WIDTH-1:0][ 4:0]                  top_invalid_addr    ;
//================================ 与ROB的接口 ================================
// 读
logic [$clog2(ROB_DEPTH) - 1:0]                 top_ROB_tail      ;
logic [$clog2(ROB_DEPTH) - 1:0]                 top_ROB_tail_plus ;
logic [ISSUE_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0]  top_ROB_raddr1  ;
logic [ISSUE_WIDTH-1:0]                         top_ROB_rvalid1 ;
logic [ISSUE_WIDTH-1:0][31:0]                   top_ROB_rdata1  ;
logic [ISSUE_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0]  top_ROB_raddr2  ;
logic [ISSUE_WIDTH-1:0]                         top_ROB_rvalid2 ;
logic [ISSUE_WIDTH-1:0][31:0]                   top_ROB_rdata2  ;
// 写
logic [FU_NUM-1:0]                              top_ROB_complete_en     ;
logic [FU_NUM-1:0][$clog2(ROB_DEPTH)-1:0]       top_ROB_complete_addr   ;
ROB_t [FU_NUM-1:0]                              top_ROB_complete_entry  ;
// 提交阶段的退休端口
logic [COMMIT_WIDTH-1:0]                        top_ROB_dequeue_en  ;
ROB_t [COMMIT_WIDTH-1:0]                        top_ROB_dequeue_data;
// 分支预测错误时的纠正
logic [$clog2(ROB_DEPTH)-1:0]                   top_ROB_error_index;
logic [$clog2(ROB_DEPTH)-1:0]                   top_ROB_error_index_r;
logic                                           top_ROB_redirect_state;
// csr指令暂停控制
logic                                           top_csr_increase_en;
logic                                           top_csr_pause;
// 状态
logic                                           top_ROB_full      ;
logic                                           top_ROB_one_left  ;
logic                                           top_ROB_empty     ;
logic                                           top_ROB_pause     ;
//================================ 与FU的接口 ================================
logic [FU_NUM-1:0] top_FU_pause;
logic              top_BU_pause;
//================================ 与commit_queue的接口 ================================
logic top_commit_queue_full;

/*连接乘除法模块信号*/
wire        top_mul_signed;
wire [31:0] top_mul_scr1;
wire [31:0] top_mul_scr2;
wire [63:0] top_mul_result;

wire        top_div_ctrl;   //当前EXE阶段是否是除法指令
wire        top_div_signed;
wire [31:0] top_div_scr1;
wire [31:0] top_div_scr2;
wire [63:0] top_div_result;
wire        top_div_complete;

/*各阶段的csr相关信号*/
// 与IF阶段连接的
wire [31:0] top_ex_entry;
wire [31:0] top_ertn_entry;
wire [31:0] top_tlb_entry;
// 与ISS阶段连接的
wire        top_has_int;
// 与EXE阶段连接的
wire        top_EXE_csr_re;
wire        top_EXE_csr_we; // 需要前递
wire [13:0] top_EXE_csr_num; // 需要前递
wire        top_EXE_csr_write_int; // 需要前递
wire [31:0] top_csr_rdata;
wire [63:0] top_timer_64_rdata;
wire        top_llbit;
wire [27:0] top_lladdr;
wire        top_EXE_tlbsrch_en;
wire        top_EXE_tlbsrch_found;
wire [ 2:0] top_EXE_tlbsrch_index;
wire [19:0] top_EXE_tag;
wire [ 7:0] top_EXE_index;
wire [ 3:0] top_EXE_offset;

// 与MEM阶段连接的
wire        top_MEM_csr_we; // 需要前递
wire [13:0] top_MEM_csr_num; // 需要前递
wire        top_MEM_csr_write_int; // 需要前递
// 与WB阶段连接的
wire [31:0] top_WB_pc;
wire [31:0] top_WB_bad_vaddr;
wire        top_WB_csr_we; // 需要前递
wire [13:0] top_WB_csr_num; // 需要前递
wire        top_WB_csr_write_int; // 需要前递
wire [31:0] top_WB_csr_wmask; // 传给csr
wire [31:0] top_WB_csr_wdata; // 传给csr
// // ll.w和sc.w指令相关的信号
wire        top_WB_llbit_set;
wire        top_WB_llbit;
wire        top_WB_lladdr_set;
wire [27:0] top_WB_lladdr;
wire        top_WB_tlbrd_en;

/*各阶段的异常相关信号*/
wire        top_WB_ex; // WB阶段的是要传给csr的
wire [ 5:0] top_WB_ecode;
wire [ 8:0] top_WB_esubcode;
wire        top_WB_excp_tlbrefill;
wire        top_WB_excp_tlb;
wire [18:0] top_WB_excp_tlb_vppn;
wire        top_WB_ertn_flush;
wire        top_WB_refetch_flush;

/*清除流水线缓存的信号*/
wire        top_flush_sign;
assign top_backend_flush = top_flush_sign;

/*类SRAM总线端口*/
wire inst_sram_req;
wire inst_sram_wr;
wire [ 1:0] inst_sram_size;
wire [ 3:0] inst_sram_wstrb;
wire [31:0] inst_sram_addr ;
wire [31:0] inst_sram_wdata;
wire [127:0] inst_sram_rdata;
wire inst_sram_addr_ok;
wire inst_sram_data_ok;

wire data_sram_req;
wire data_sram_wr;
wire [ 1:0] data_sram_size;
wire [ 3:0] data_sram_wstrb;
wire [31:0] data_sram_addr ;
wire [31:0] data_sram_wdata;
wire [31:0] data_sram_rdata;
wire data_sram_addr_ok;
wire data_sram_data_ok;

/*tlb相关信号*/
// addr_trans与pre-IF阶段交互的信号，用于取指时的地址翻译
wire [31:0] top_inst_vaddr;
wire        top_inst_addr_trans_en;
wire        top_inst_dmw0_en;
wire        top_inst_dmw1_en;

wire        top_inst_tlb_found;
wire        top_inst_tlb_v;
wire        top_inst_tlb_d;
wire [ 1:0] top_inst_tlb_mat;
wire [ 1:0] top_inst_tlb_plv;

// addr_trans与EXE阶段交互的信号，用于访存时的地址翻译
wire        top_data_fetch;
wire [31:0] top_data_vaddr;
wire        top_data_addr_trans_en;
wire        top_data_dmw0_en;
wire        top_data_dmw1_en;

wire        top_data_tlb_found;
wire [ 2:0] top_data_tlb_index;
wire        top_data_tlb_v;
wire        top_data_tlb_d;
wire [ 1:0] top_data_tlb_mat;
wire [ 1:0] top_data_tlb_plv;
wire [19:0] top_data_tlb_ppn;

// csr传给pre-IF和EXE阶段，用于地址翻译的信号
wire        top_csr_pg; // 还传给tlb
wire        top_csr_da; // 还传给tlb
wire [31:0] top_csr_dmw0; // 还传给tlb
wire [31:0] top_csr_dmw1; // 还传给tlb
wire [ 1:0] top_csr_plv;
wire [ 1:0] top_csr_datf;
wire [ 1:0] top_csr_datm;
//======================== TLB维护接口 ========================//  csr传给tlb的交互信号，与tlb指令相关
wire [ 9:0] top_csr_asid;
wire [ 2:0] top_csr_rand_index;
wire [31:0] top_csr_tlbehi;
wire [31:0] top_csr_tlbelo0;
wire [31:0] top_csr_tlbelo1;
wire [31:0] top_csr_tlbidx;
wire [ 5:0] top_csr_ecode;
//======================== TLB读取接口 ========================//  tlb传给csr的交互信号，与tlb指令相关
wire [ 9:0] top_tlb_asid;
wire [31:0] top_tlb_tlbehi;
wire [31:0] top_tlb_tlbelo0;
wire [31:0] top_tlb_tlbelo1;
wire [31:0] top_tlb_tlbidx;
// tlb指令相关的控制信号
wire        top_WB_tlbfill_en;
wire        top_WB_tlbwr_en;
wire        top_ISS_invtlb_en;
wire        top_EXE_invtlb_en;
wire [ 9:0] top_EXE_invtlb_asid;
wire [18:0] top_EXE_invtlb_vpn;
wire [ 4:0] top_EXE_invtlb_op;

//======================== cacop指令接口 ========================//  EXE阶段传给icache和dcache
wire        top_icacop_op_en;
wire        top_dcacop_op_en;
wire [ 1:0] top_cacop_op_mode;
wire [31:0] top_cacop_pa;
wire        top_icacop_ok;
wire        top_dcacop_ok;
wire        top_cacop_op_mode_di;

//房效民添加

wire        top_inst_rd_rdy;
wire        top_inst_ret_last;
wire        top_data_rd_rdy;
wire        top_data_ret_last;
wire [ 2:0] top_data_wr_type;
wire [31:0] top_data_wr_addr;
wire [ 3:0] top_data_wr_wstrb;
wire [127:0]top_data_wr_data;
wire        top_data_wr_rdy;
wire        top_write_buffer_empty;
wire        top_inst_uncache_en;
wire        top_data_uncache_en;



//
wire icache_inst_sram_req;
wire [31:0] icache_inst_sram_addr;
wire [3:0]   icache_inst_sram_wstrb;
wire [127:0]  icache_inst_sram_wdata;
wire [127:0]  icache_inst_sram_rdata;
wire [2:0]   icache_rd_type;
wire icache_rd_rdy;
wire icache_ret_valid;
wire icache_ret_last;
wire [31:0] icache_ret_data;
wire icache_wr_req;
wire [2:0] icache_wr_type;
wire [31:0] icache_wr_addr;
wire icache_wr_rdy;
wire [19:0]icache_tag;
wire [7:0]icache_index;
wire [3:0]icache_offset;





wire dcache_inst_sram_req;
wire [31:0] dcache_inst_sram_addr;
wire [3:0]   dcache_inst_sram_wstrb;
wire [127:0]  dcache_inst_sram_wdata;
wire [31:0]  dcache_inst_sram_rdata;
wire [2:0]   dcache_rd_type;
wire dcache_rd_rdy;
wire dcache_ret_valid;
wire dcache_ret_last;
wire [31:0] dcache_ret_data;

wire dcache_wr_req;
wire [2:0] dcache_wr_type;
wire [31:0] dcache_wr_addr;
wire dcache_wr_rdy;
wire [19:0]dcache_tag;
wire [7:0]dcache_index;
wire [3:0]dcache_offset;

`ifdef DIFFTEST_EN
// difftest
// from wb_stage
wire            ws_valid_diff       ;
wire            cnt_inst_diff       ;
wire    [63:0]  timer_64_diff       ;
wire    [ 7:0]  inst_ld_en_diff     ;
wire    [31:0]  ld_paddr_diff       ;
wire    [31:0]  ld_vaddr_diff       ;
wire    [ 7:0]  inst_st_en_diff     ;
wire    [31:0]  st_paddr_diff       ;
wire    [31:0]  st_vaddr_diff       ;
wire    [31:0]  st_data_diff        ;
wire            csr_rstat_en_diff   ;
wire    [31:0]  csr_data_diff       ;

wire inst_valid_diff = ws_valid_diff;
reg             cmt0_valid           ;
reg             cmt0_cnt_inst        ;
reg     [63:0]  cmt0_timer_64        ;
reg     [ 7:0]  cmt0_inst_ld_en      ;
reg     [31:0]  cmt0_ld_paddr        ;
reg     [31:0]  cmt0_ld_vaddr        ;
reg     [ 7:0]  cmt0_inst_st_en      ;
reg     [31:0]  cmt0_st_paddr        ;
reg     [31:0]  cmt0_st_vaddr        ;
reg     [31:0]  cmt0_st_data         ;
reg             cmt0_csr_rstat_en    ;
reg     [31:0]  cmt0_csr_data        ;

reg             cmt0_wen             ;
reg     [ 7:0]  cmt0_wdest           ;
reg     [31:0]  cmt0_wdata           ;
reg     [31:0]  cmt0_pc              ;
reg     [31:0]  cmt0_inst            ;

reg             cmt0_excp_flush      ;
reg             cmt0_ertn            ;
reg     [5:0]   cmt0_csr_ecode       ;
reg             cmt0_tlbfill_en      ;

reg             cmt1_valid           ;
reg             cmt1_cnt_inst        ;
reg     [63:0]  cmt1_timer_64        ;
reg     [ 7:0]  cmt1_inst_ld_en      ;
reg     [31:0]  cmt1_ld_paddr        ;
reg     [31:0]  cmt1_ld_vaddr        ;
reg     [ 7:0]  cmt1_inst_st_en      ;
reg     [31:0]  cmt1_st_paddr        ;
reg     [31:0]  cmt1_st_vaddr        ;
reg     [31:0]  cmt1_st_data         ;
reg             cmt1_csr_rstat_en    ;
reg     [31:0]  cmt1_csr_data        ;

reg             cmt1_wen             ;
reg     [ 7:0]  cmt1_wdest           ;
reg     [31:0]  cmt1_wdata           ;
reg     [31:0]  cmt1_pc              ;
reg     [31:0]  cmt1_inst            ;

reg             cmt1_excp_flush      ;
reg             cmt1_ertn            ;
reg     [5:0]   cmt1_csr_ecode       ;
reg             cmt1_tlbfill_en      ;


reg     [ 2:0]  cmt_rand_index      ;

// to difftest debug
reg             trap                ;
reg     [ 7:0]  trap_code           ;
reg     [63:0]  cycleCnt            ;
reg     [63:0]  instrCnt            ;

// from regfile
wire    [31:0]  regs[31:0]          ;

// from csr
wire    [31:0]  csr_crmd_diff_0     ;
wire    [31:0]  csr_prmd_diff_0     ;
wire    [31:0]  csr_ectl_diff_0     ;
wire    [31:0]  csr_estat_diff_0    ;
wire    [31:0]  csr_era_diff_0      ;
wire    [31:0]  csr_badv_diff_0     ;
wire	[31:0]  csr_eentry_diff_0   ;
wire 	[31:0]  csr_tlbidx_diff_0   ;
wire 	[31:0]  csr_tlbehi_diff_0   ;
wire 	[31:0]  csr_tlbelo0_diff_0  ;
wire 	[31:0]  csr_tlbelo1_diff_0  ;
wire 	[31:0]  csr_asid_diff_0     ;
wire 	[31:0]  csr_save0_diff_0    ;
wire 	[31:0]  csr_save1_diff_0    ;
wire 	[31:0]  csr_save2_diff_0    ;
wire 	[31:0]  csr_save3_diff_0    ;
wire 	[31:0]  csr_tid_diff_0      ;
wire 	[31:0]  csr_tcfg_diff_0     ;
wire 	[31:0]  csr_tval_diff_0     ;
wire 	[31:0]  csr_ticlr_diff_0    ;
wire 	[31:0]  csr_llbctl_diff_0   ;
wire 	[31:0]  csr_tlbrentry_diff_0;
wire 	[31:0]  csr_dmw0_diff_0     ;
wire 	[31:0]  csr_dmw1_diff_0     ;
wire 	[31:0]  csr_pgdl_diff_0     ;
wire 	[31:0]  csr_pgdh_diff_0     ;

wire            debug0_ws_valid_diff;
wire            debug0_cnt_inst_diff;
wire    [63:0]  debug0_timer_64_diff;
wire    [ 7:0]  debug0_inst_ld_en_diff;
wire    [31:0]  debug0_ld_paddr_diff;
wire    [31:0]  debug0_ld_vaddr_diff;
wire    [ 7:0]  debug0_inst_st_en_diff;
wire    [31:0]  debug0_st_paddr_diff;
wire    [31:0]  debug0_st_vaddr_diff;
wire    [31:0]  debug0_st_data_diff ;
wire            debug0_csr_rstat_en_diff;
wire    [31:0]  debug0_csr_data_diff;

wire            debug1_ws_valid_diff;
wire            debug1_cnt_inst_diff;
wire    [63:0]  debug1_timer_64_diff;
wire    [ 7:0]  debug1_inst_ld_en_diff;
wire    [31:0]  debug1_ld_paddr_diff;
wire    [31:0]  debug1_ld_vaddr_diff;
wire    [ 7:0]  debug1_inst_st_en_diff;
wire    [31:0]  debug1_st_paddr_diff;
wire    [31:0]  debug1_st_vaddr_diff;
wire    [31:0]  debug1_st_data_diff ;
wire            debug1_csr_rstat_en_diff;
wire    [31:0]  debug1_csr_data_diff;


logic [COMMIT_WIDTH-1:0][31:0]         debug_wb_pc;      
logic [COMMIT_WIDTH-1:0][3:0]          debug_wb_rf_we;   
logic [COMMIT_WIDTH-1:0][4:0]          debug_wb_rf_wnum; 
logic [COMMIT_WIDTH-1:0][31:0]         debug_wb_rf_wdata;
logic [COMMIT_WIDTH-1:0][31:0]         debug_wb_inst;   

`endif


// 重定向信号延后一个周期
always_ff @(posedge clk) begin
    if (reset | top_backend_flush) begin
        top_backend_redirect_r <= 1'b0;
    end
    else if (top_backend_redirect) begin
        top_backend_redirect_r <= 1'b1;
    end
    else if (top_backend_redirect_r) begin
        top_backend_redirect_r <= 1'b0;
    end
end

always_ff @(posedge clk) begin
    top_backend_redirect_next_pc_r <= top_backend_redirect_next_pc;
    top_backend_redirect_ftq_id_r  <= top_backend_redirect_ftq_id ;
end

// 冲刷信号延后一个周期
always_ff @(posedge clk) begin
    if (reset) begin
        top_backend_flush_r <= 1'b0;
    end
    else if (top_backend_flush) begin
        top_backend_flush_r <= 1'b1;
    end
    else if (top_backend_flush_r) begin
        top_backend_flush_r <= 1'b0;
    end
end

always_ff @(posedge clk) begin
    top_backend_flush_next_pc_r <= top_backend_flush_next_pc;
    top_backend_flush_ftq_id_r  <= top_backend_flush_ftq_id ;
end


/*对各个流水段例化*/

// 前端总模块
frontend frontend(
    //输入时钟和复位
    .clk                        (clk                        ),
    .rst                        (reset                      ),
    // <-> ICache
    .inst_sram_req_o            (inst_sram_req              ),
    .inst_uncache_en_o          (top_inst_uncache_en        ),
    .inst_sram_paddr_o          (inst_sram_paddr            ), 
    .inst_sram_addr_ok_i        (inst_sram_addr_ok          ),
    .inst_sram_data_ok_i        (inst_sram_data_ok          ),
    .inst_sram_rdata_i          (inst_sram_rdata            ),
    // <-> Backend flush & redirect
    .backend_redirect_i         (top_backend_redirect_r        ),
    .backend_redirect_next_pc_i (top_backend_redirect_next_pc_r),
    .backend_redirect_ftq_id_i  (top_backend_redirect_ftq_id_r ),
    .backend_flush_i            (top_backend_flush_r           ),
    .backend_flush_next_pc_i    (top_backend_flush_next_pc_r   ),
    .backend_flush_ftq_id_i     (top_backend_flush_ftq_id_r    ),
    // <-> Backend commit
    .backend_commit_bitmask_i       (top_backend_commit_bitmask_r      ),
    .backend_commit_block_bitmask_i (top_backend_commit_block_bitmask_r),
    .backend_commit_ftq_id_i        (top_backend_commit_ftq_id_r       ),
    .backend_commit_meta_i          (top_backend_commit_meta_r         ),
    // FTQ meta value
    .backend_ftq_updata_info    (top_backend_ftq_updata_info_r),
    // <-> Instruction buffer
    .IB_full_stall_i            (top_inst_buffer_full       ),
    .pre_decoder_ready_go_o     (top_pre_decoder_ready_go   ),
    .instr_buffer_o             (top_instr_buffer           ),
    .instr_buffer_length_o      (top_instr_buffer_length    ),
    // <-> EX
    .BU_ras_data                (top_BU_ras_data            ),
    .bu_pc_query_o              (top_ex_query_pc            ),
    .iss_query_id_i             (top_iss_query_id           ),
    .ctrl_query_id_i            (top_ctrl_query_id          ),
    .iss0_pc_query_o            (top_iss0_pc_query          ),
    .iss1_pc_query_o            (top_iss1_pc_query          ),
    .ctrl_pc_query_o            (top_ctrl_pc_query          ),
    // <- CSR
    .csr_pg                     (top_csr_pg                 ),
    .csr_da                     (top_csr_da                 ),
    .csr_dmw0                   (top_csr_dmw0               ),
    .csr_dmw1                   (top_csr_dmw1               ),
    .csr_plv                    (top_csr_plv                ),
    .csr_datf                   (top_csr_datf               ),
    // 
    .tlb_o                      ({top_inst_vaddr         
                                 ,top_inst_addr_trans_en 
                                 ,top_inst_dmw0_en       
                                 ,top_inst_dmw1_en         }),
    .tlb_i                      ({top_inst_tlb_found
                                 ,top_inst_tlb_v  
                                 ,top_inst_tlb_d  
                                 ,top_inst_tlb_mat
                                 ,top_inst_tlb_plv
                                 ,icache_tag                }) 
);

assign top_iss_pc_query = {top_iss1_pc_query, top_iss0_pc_query};

axi_bridge axi_bridge(
    .clk               (aclk             ),
    .reset            (reset         ),

    .arid              (arid             ),
    .araddr            (araddr           ),
    .arlen             (arlen            ),
    .arsize            (arsize           ),
    .arburst           (arburst          ),
    .arlock            (arlock           ),
    .arcache           (arcache          ),
    .arprot            (arprot           ),
    .arvalid           (arvalid          ),
    .arready           (arready          ),

    .rid               (rid              ),
    .rdata             (rdata            ),
    .rresp             (rresp            ),
    .rlast             (rlast            ),
    .rvalid            (rvalid           ),
    .rready            (rready           ),

    .awid              (awid             ),
    .awaddr            (awaddr           ),
    .awlen             (awlen            ),
    .awsize            (awsize           ),
    .awburst           (awburst          ),
    .awlock            (awlock           ),
    .awcache           (awcache          ),
    .awprot            (awprot           ),
    .awvalid           (awvalid          ),
    .awready           (awready          ),

    .wid               (wid              ),
    .wdata             (wdata            ),
    .wstrb             (wstrb            ),
    .wlast             (wlast            ),
    .wvalid            (wvalid           ),
    .wready            (wready           ),

    .bid               (bid              ),
    .bresp             (bresp            ),
    .bvalid            (bvalid           ),
    .bready            (bready           ),

    .inst_rd_req(icache_inst_sram_req),
    .inst_rd_type(icache_rd_type),
    .inst_rd_addr(icache_inst_sram_addr),
    .inst_rd_rdy(icache_rd_rdy),
    .inst_ret_valid(icache_ret_valid),
    .inst_ret_last(icache_ret_last),
    .inst_ret_data(icache_ret_data),
    .inst_wr_req(icache_wr_req),
    .inst_wr_type(icache_wr_type),
    .inst_wr_addr(icache_wr_addr),
    .inst_wr_wstrb(icache_inst_sram_wstrb),
    .inst_wr_data(icache_inst_sram_wdata),
    .inst_wr_rdy(icache_wr_rdy),

    .data_rd_req(dcache_inst_sram_req),
    .data_rd_type(dcache_rd_type),
    .data_rd_addr(dcache_inst_sram_addr),
    .data_rd_rdy(dcache_rd_rdy),
    .data_ret_valid(dcache_ret_valid),
    .data_ret_last(dcache_ret_last),
    .data_ret_data(dcache_ret_data),
    .data_wr_req(dcache_wr_req),
    .data_wr_type(dcache_wr_type),
    .data_wr_addr(dcache_wr_addr),
    .data_wr_wstrb(dcache_inst_sram_wstrb),
    .data_wr_data(dcache_inst_sram_wdata),
    .data_wr_rdy(dcache_wr_rdy),
    .write_buffer_empty()
);


icache icache(
    .clk(clk),
    .rst(reset),

    // cache - cpu
    .valid(inst_sram_req),
    .op(1'b0),
    .index(inst_sram_paddr[11:4]),
    .tag(inst_sram_paddr[31:12]),
    .offset(inst_sram_paddr[3:0]),
    .wstrb(inst_sram_wstrb),
    .wdata(inst_sram_wdata),

    .addr_ok(inst_sram_addr_ok),
    .data_ok(inst_sram_data_ok),
    .rdata(inst_sram_rdata),

    // cache - axi
    .rd_req(icache_inst_sram_req),
    .rd_type(icache_rd_type),
    .rd_addr(icache_inst_sram_addr),
    .rd_rdy(icache_rd_rdy),
    .ret_valid(icache_ret_valid),
    .ret_last(icache_ret_last),
    .ret_data(icache_ret_data),

    .wr_req(icache_wr_req),
    .wr_type(icache_wr_type),
    .wr_addr(icache_wr_addr),
    .wr_wstrb(icache_inst_sram_wstrb),
    .wr_data(icache_inst_sram_wdata),
    .wr_rdy(icache_wr_rdy),
    .uncache(top_inst_uncache_en),

    .cacop_en  (top_icacop_op_en),
    .cacop_op  (top_cacop_op_mode),
    .cacop_ok_o(top_icacop_ok),
    .cacop_pa  (top_cacop_pa)
);







dcache dcache(
    .clk(clk),
    .rst(reset),

    // cache - cpu
    .valid(data_sram_req),
    .op(data_sram_wr),
    .size(data_sram_size),
    .index  (top_EXE_index),
    .tag    (top_EXE_tag),
    .offset (top_EXE_offset),
    .wstrb(data_sram_wstrb),
    .wdata(data_sram_wdata),

    .addr_ok(data_sram_addr_ok),
    .data_ok(data_sram_data_ok),
    .rdata(data_sram_rdata),

    // cache - axi
    .rd_req(dcache_inst_sram_req),
    .rd_type(dcache_rd_type),
    .rd_addr(dcache_inst_sram_addr),
    .rd_rdy(dcache_rd_rdy),
    .ret_valid(dcache_ret_valid),
    .ret_last(dcache_ret_last),
    .ret_data(dcache_ret_data),

    .wr_req(dcache_wr_req),
    .wr_type(dcache_wr_type),
    .wr_addr(dcache_wr_addr),
    .wr_wstrb(dcache_inst_sram_wstrb),
    .wr_data(dcache_inst_sram_wdata),
    .wr_rdy(dcache_wr_rdy),
    .uncache(top_data_uncache_en),

    .cacop_en   (top_dcacop_op_en),
    .cacop_op   (top_cacop_op_mode),
    .cacop_ok_o (top_dcacop_ok),
    .cacop_pa   (top_cacop_pa)
);


logic top_issue_queue_full;
ID_stage ID_stage(
    //输入时钟和复位
    .clk                (clk                      ),
    .reset              (reset                    ),
    //================================ 流水线握手信号 ================================
    .inst_buffer_full   (top_inst_buffer_full     ),
    .IF_to_ID_valid     (top_pre_decoder_ready_go ),
    .RA_allow_in        (top_RA_allow_in          ),
    //================================ 流水线间通信总线 ================================
    .instr_buffer_length(top_instr_buffer_length),
    .IF_ID_bus          (top_instr_buffer         ),
    .ID_RA_bus          (top_ID_RA_bus            ),
    //================================ 与ROB的接口 ================================
    .ROB_redirect_state (top_ROB_redirect_state  ), // 标志ROB在分支预测错误时是否清空完成
    //================================ 流水线刷新 ================================
    .flush_sign         (top_backend_flush_r      ),
    .redirect           (top_backend_redirect_r   )  // 方向预测错误
);

RA_stage RA_stage(
    .clk                (clk                        ),
    .reset              (reset                      ),
    //================================ 流水线握手信号 ================================
    .RA_allow_in        (top_RA_allow_in            ),
    .issue_queue_full   (top_issue_queue_full       ),
    //================================ 流水线间通信总线 ================================
    .ID_RA_bus          (top_ID_RA_bus              ),
    .enqueue_en         (top_IQ_ROB_enqueue_en      ),
    .IQ_enqueue_data    (top_IQ_enqueue_data        ),
    .ROB_enqueue_data   (top_ROB_enqueue_data       ),
    //================================ 与RAT的接口 ================================
    .src1_addr          (top_src1_addr              ),
    .src2_addr          (top_src2_addr              ),
    .src1_valid         (top_src1_valid             ),
    .src2_valid         (top_src2_valid             ),
    .src1_prf           (top_src1_prf               ),
    .src2_prf           (top_src2_prf               ),
    .we                 (top_RAT_we                 ),
    .waddr              (top_RAT_waddr              ),
    .wprf               (top_RAT_wprf               ),
    //================================ 与ROB的接口 ================================
    .ROB_tail           (top_ROB_tail               ),
    .ROB_tail_plus      (top_ROB_tail_plus          ),
    .ROB_full           (top_ROB_full               ),
    //================================ 流水线刷新 ================================
    .flush_sign         (top_backend_flush_r        ),
    .redirect           (top_backend_redirect_r     )
);


wire top_ISS_to_EXE_valid;

ISS_stage ISS_stage(
    //输入时钟和复位
    .clk                    (clk                            ),
    .reset                  (reset                          ),
    //================================ 流水线握手信号 ================================
    .issue_queue_full       (top_issue_queue_full           ),
    .csr_buffer_full        (1'b0                           ),
    .FU_allow_in            (top_FU_allow_in                ),  //EXE阶段可以输入
    //================================ 流水线间通信总线 ================================
    .enqueue_en             (top_IQ_ROB_enqueue_en          ),
    .enqueue_data           (top_IQ_enqueue_data            ),
    .ISS_EXE_bus            (top_ISS_EXE_bus                ),
    .BU_bus                 (top_BU_bus                     ),
    //================================ 寄存器文件接口 ================================
    .rf_raddr1              (rf_raddr1                      ),
    .rf_rdata1              (rf_rdata1                      ),
    .rf_raddr2              (rf_raddr2                      ),
    .rf_rdata2              (rf_rdata2                      ),
    //================================ ROB的读端口 ================================
    .ROB_raddr1             (top_ROB_raddr1                 ),
    .ROB_rvalid1            (top_ROB_rvalid1                ),
    .ROB_rdata1             (top_ROB_rdata1                 ),
    .ROB_raddr2             (top_ROB_raddr2                 ),
    .ROB_rvalid2            (top_ROB_rvalid2                ),
    .ROB_rdata2             (top_ROB_rdata2                 ),
    //================================ pc查询 ================================
    .ftq_id                 (top_iss_query_id               ),
    .ftq_query_pc           (top_iss_pc_query               ),
    // csr暂停
    .csr_increase_en        (top_csr_increase_en            ),
    .csr_pause              (top_csr_pause                  ),
    //================================ 中断接口 ================================
    .has_int                (top_has_int                    ),
    //================================ 前递暂停信号 ================================
    .FU_pause               (top_FU_pause                   ),   // 在四个功能单元中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    .BU_pause               (top_BU_pause                   ),
    .ROB_pause              (top_ROB_pause                  ),   // 在ROB中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    //================================ 流水线刷新 ================================
    .flush_sign             (top_backend_flush_r            ),
    .redirect_flush         (top_backend_redirect_r         ),

    .infor_flag             (infor_flag                     ),
    .reg_num                (reg_num                        ),
    .debug_rf_rdata1        (rf_rdata                       )
    /*
    `ifdef DIFFTEST_EN
    ,
    .regs           (regs                )
    `endif*/
);

EXE_stage EXE_stage(
    //输入时钟和复位
    .clk              (clk                  ),
    .reset            (reset                ),
    //================================ 流水线握手信号 ================================
    .WB_allow_in      (1'b1                 ), // 指令进入ROB之后，就可以一直执行到完成
    .FU_allow_in      (top_FU_allow_in      ),
    //================================ 流水线间通信总线 ================================
    .ISS_EXE_bus      (top_ISS_EXE_bus      ),
    .BU_bus           (top_BU_bus           ),
    //================================ 执行阶段（结束时）的写ROB端口 ================================
    .complete_en      (top_ROB_complete_en  ),
    .complete_addr    (top_ROB_complete_addr),
    .FU_WB_bus        (top_ROB_complete_entry),
    //================================ 数据存储器接口 ================================
    //与数据ram进行通信的信号，向数据ram发送读取或者写入请求
    .data_sram_req    (data_sram_req        ),
    .dcache_tag       (top_EXE_tag          ),
    .dcache_index     (top_EXE_index        ),
    .dcache_offset    (top_EXE_offset       ),
    //感觉没用
    .data_sram_wr     (data_sram_wr         ),
    .data_sram_wstrb  (data_sram_wstrb      ),
    .data_sram_size   (data_sram_size       ),
    // .data_sram_addr   (data_sram_addr       ),       // tlb要进行地址翻译，不是EXE阶段直接把地址传给总线了
    .data_sram_wdata  (data_sram_wdata      ),
    .data_sram_addr_ok(data_sram_addr_ok    ),
    //================================ 连接乘除法模块接口 ================================
    .mul_signed             (top_mul_signed       ),
    .mul_scr1               (top_mul_scr1         ),
    .mul_scr2               (top_mul_scr2         ),
    .res_from_div           (top_div_ctrl         ),
    .div_signed             (top_div_signed       ),
    .div_scr1               (top_div_scr1         ),
    .div_scr2               (top_div_scr2         ),
    .div_complete           (top_div_complete     ),
    //================================ CSR接口 ================================
    // 与csr通信的信号，只需要读相关信号
    .EXE_csr_re       (top_EXE_csr_re       ),
    .EXE_csr_num      (top_EXE_csr_num      ),
    .csr_rdata        (top_csr_rdata        ),
    .timer_64_rdata   (top_timer_64_rdata   ),
    .llbit            (top_llbit            ),
    .lladdr           (top_lladdr           ),
    //================================ 前递暂停信号 ================================
    .FU_pause         (top_FU_pause         ),    // 在四个功能单元中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    .BU_pause         (top_BU_pause         ),
    //================================ 分支预测接口 ================================
    .redirect               (top_backend_redirect           ),
    .redirect_target        (top_backend_redirect_next_pc   ),
    .redirect_ftq_id        (top_backend_redirect_ftq_id    ), 
    .backend_ftq_meta_updata(top_backend_ftq_updata_info    ),
    .BU_ras_data            (top_BU_ras_data              ),
    .ftq_query_pc_i         (top_ex_query_pc                ),
    //================================ 分支预测错误指令的ROB索引 ================================
    .ROB_error_index        (top_ROB_error_index            ),
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    .flush_sign       (top_backend_flush_r      ),
    .redirect_flush   (top_backend_redirect_r   ),
    //================================ from csr ================================
    // 传给pre-IF和EXE阶段，用于地址翻译的信号
    .csr_pg           (top_csr_pg             ),
    .csr_da           (top_csr_da             ),
    .csr_dmw0         (top_csr_dmw0           ),
    .csr_dmw1         (top_csr_dmw1           ),
    .csr_plv          (top_csr_plv            ),
    .csr_datm         (top_csr_datm           ),
    .csr_tlbehi       (top_csr_tlbehi         ),
    //================================ to csr ================================
    .tlbsrch_en       (top_EXE_tlbsrch_en      ),         // TLB搜索使能
    .tlbsrch_found    (top_EXE_tlbsrch_found   ),
    .tlbsrch_index    (top_EXE_tlbsrch_index   ),
    //================================ to addr trans  ================================
    .data_fetch        (top_data_fetch         ),
    .data_vaddr        (top_data_vaddr         ),
    .data_addr_trans_en(top_data_addr_trans_en ),
    .dmw0_en           (top_data_dmw0_en       ),
    .dmw1_en           (top_data_dmw1_en       ),

    .invtlb_inst       (top_ISS_invtlb_en      ),
    .invtlb_en         (top_EXE_invtlb_en      ),
    .invtlb_op         (top_EXE_invtlb_op      ),
    .invtlb_asid       (top_EXE_invtlb_asid    ),
    .invtlb_vpn        (top_EXE_invtlb_vpn     ),
    //================================ TLB查询结果 ================================
    .data_tlb_found   (top_data_tlb_found     ),
    .data_tlb_index   (top_data_tlb_index     ),
    .data_tlb_v       (top_data_tlb_v         ),
    .data_tlb_d       (top_data_tlb_d         ),
    .data_tlb_mat     (top_data_tlb_mat       ),
    .data_tlb_plv     (top_data_tlb_plv       ),
    .data_tlb_ppn     (20'b0                  ),//////
    //================================ cache接口 ================================
    .icacop_op_en     (top_icacop_op_en       ),
    .dcacop_op_en     (top_dcacop_op_en       ),
    .cacop_op_mode    (top_cacop_op_mode      ),
    .cacop_pa         (top_cacop_pa           ),
    .cacop_op_mode_di (top_cacop_op_mode_di   ),
    // to dcache
    .data_uncache_en  (top_data_uncache_en    ),

    .data_index       (dcache_index           ), // 数据TLB匹配索引
    .data_tag         (dcache_tag             ), // 数据物理地址标签
    .data_offset      (dcache_offset          ), // 数据页内偏移
    //================================ 数据存储器接口 ================================
    //与数据ram进行通信的信号，获取数据ram读出的数据
    .data_sram_rdata  (data_sram_rdata      ),
    .data_sram_data_ok(data_sram_data_ok    ),
    //================================ 乘除模块接口 ================================
    //与乘除法模块进行通信，获取乘除法结果
    .MEM_mul_result   (top_mul_result      ),
    .MEM_div_result   (top_div_result      ),
    //================================ cacop指令接口 ================================
    // cacop接口
    .icacop_ok        (top_icacop_ok        ),
    .dcacop_ok        (top_dcacop_ok        )
);

mul u_mul(
    .mul_clk    (clk              ), 
    .reset      (reset            ), 
    .mul_signed (top_mul_signed   ), //高电平进行有符号乘法
    .x          (top_mul_scr1     ),
    .y          (top_mul_scr2     ), //x扩展至64位 y扩展至33位 区别有无符号
    .result     (top_mul_result   )
    );

div u_div(
    .div_clk    (clk                  ), 
    .reset      (reset                ),
    .div        (top_div_ctrl         ),
    .div_signed (top_div_signed       ),
    .x          (top_div_scr1         ),//被除数rj
    .y          (top_div_scr2         ),//除数rk
    .s          (top_div_result[63:32]),
    .r          (top_div_result[31: 0]),
    .complete   (top_div_complete     )
    );


RAT u_RAT(
    .clk                (clk                    ),
    .reset              (reset                  ),
    .flush_sign         (top_backend_flush_r    ),
    //================================ RA阶段的读写端口 ================================
    // 读
    .src1_addr          (top_src1_addr          ),
    .src2_addr          (top_src2_addr          ),
    .src1_valid         (top_src1_valid         ),
    .src2_valid         (top_src2_valid         ),
    .src1_prf           (top_src1_prf           ),
    .src2_prf           (top_src2_prf           ),
    // 写
    .we                 (top_RAT_we             ),
    .waddr              (top_RAT_waddr          ),
    .wprf               (top_RAT_wprf           ),
    //================================ 分支预测错误 ================================
    .redirect           (top_backend_redirect_r ),
    //================================ retire时的无效化 ================================
    .invalid            (top_ROB_dequeue_en     ),
    .invalid_ROB_idx    (top_invalid_ROB_idx    ),
    .invalid_addr       (top_invalid_addr       )
);

always_ff @ (posedge clk) begin
    if (top_backend_redirect) begin
        top_ROB_error_index_r <= top_ROB_error_index;
    end
end

ROB u_ROB(
    .clk                (clk                    ),
    .reset              (reset                  ),
    .flush_sign         (top_backend_flush_r    ),
    .csr_increase_en    (top_csr_increase_en    ),
    .csr_pause          (top_csr_pause          ),
    //================================ 重命名阶段（结束时）的写端口 ================================
    .enqueue_en         (top_IQ_ROB_enqueue_en  ),
    .enqueue_data       (top_ROB_enqueue_data   ),
    //================================ 重命名阶段的读端口 ================================
    .tail               (top_ROB_tail           ),
    .tail_plus          (top_ROB_tail_plus      ),
    //================================ 发射阶段的读端口 ================================
    .raddr1             (top_ROB_raddr1         ),
    .rvalid1            (top_ROB_rvalid1        ), // valid就是complete
    .rdata1             (top_ROB_rdata1         ),
    .raddr2             (top_ROB_raddr2         ),
    .rvalid2            (top_ROB_rvalid2        ),
    .rdata2             (top_ROB_rdata2         ),
    //================================ 执行阶段（结束时）的写端口 ================================
    .complete_en        (top_ROB_complete_en    ),
    .complete_addr      (top_ROB_complete_addr  ),
    .complete_entry     (top_ROB_complete_entry ),
    //================================ 提交阶段的退休端口 ================================   目前先一个一个退休，毕竟IPC也不高
    .dequeue_en         (top_ROB_dequeue_en     ),
    .dequeue_data       (top_ROB_dequeue_data   ),
    .invalid_ROB_idx    (top_invalid_ROB_idx    ),
    .invalid_addr       (top_invalid_addr       ),
    //================================ 分支预测错误时的纠正 ================================
    .redirect           (top_backend_redirect_r ),
    .ROB_error_index    (top_ROB_error_index_r  ),
    .ROB_redirect_state (top_ROB_redirect_state ),
    //================================ ROB的状态 ================================
    .full               (top_ROB_full           ),
    .one_left           (top_ROB_one_left       ),
    .empty              (top_ROB_empty          ),
    .ROB_pause          (top_ROB_pause          )
);


ctrl ctrl(
    //输入时钟和复位
    .clk              (clk                  ),
    .reset            (reset                ),
    //================================ 流水线握手信号 ================================
    .ROB_empty        (top_ROB_empty        ),
    .ROB_one_left     (top_ROB_one_left     ),
    .commit_queue_full(top_commit_queue_full),
    .commit_bus       (top_commit_bus       ),
    //================================ 寄存器文件接口 ================================
    //与寄存器进行通信的信号，将数据写回
    .rf_we            (rf_we                ),
    .rf_waddr         (rf_waddr             ),
    .rf_wdata         (rf_wdata             ),
    //================================ 提交阶段的ROB端口 ================================   目前先一个一个退休，毕竟IPC也不高
    .dequeue_en       (top_ROB_dequeue_en   ),   // 出队使能
    .ROB_data         (top_ROB_dequeue_data ),   // 队头的数据，如果其状态为complete，则表示可以退休，dequeue_en为1；异常时有额外处理
    //================================ 调试接口 ================================
    `ifdef DIFFTEST_EN
    .debug_wb_pc      (debug_wb_pc),
    .debug_wb_rf_we   (debug_wb_rf_we),
    .debug_wb_rf_wnum (debug_wb_rf_wnum),
    .debug_wb_rf_wdata(debug_wb_rf_wdata),
    .debug_wb_inst    (debug_wb_inst),
    `else
    .debug_wb_pc      (),
    .debug_wb_rf_we   (),
    .debug_wb_rf_wnum (),
    .debug_wb_rf_wdata(),
    `endif
    //================================ 分支预测信号 ================================
    .backend_commit_meta_o          (top_backend_commit_meta            ),
    .backend_commit_bitmask_o       (top_backend_commit_bitmask         ),
    .backend_commit_block_bitmask_o (top_backend_commit_block_bitmask   ),
    .backend_commit_ftq_id_o        (top_backend_commit_ftq_id          ),
    //================================ pc查询 ================================
    .ftq_id                         (top_ctrl_query_id                  ),
    .ftq_query_pc                   (top_ctrl_pc_query                  ),
    //================================ CSR接口 ================================
    .WB_pc             (top_WB_pc               ),
    .WB_bad_vaddr      (top_WB_bad_vaddr        ),
    .tlb_entry         (top_tlb_entry           ),
    .ex_entry          (top_ex_entry            ),
    .ertn_entry        (top_ertn_entry          ),

    // csr指令相关的信号
    .WB_csr_we        (top_WB_csr_we        ),
    .WB_csr_num       (top_WB_csr_num       ),
    .WB_csr_write_int (top_WB_csr_write_int ),
    .WB_csr_wmask     (top_WB_csr_wmask     ),
    .WB_csr_wdata     (top_WB_csr_wdata     ),
    // ll.w和sc.w指令相关的信号
    .WB_llbit_set     (top_WB_llbit_set     ),
    .WB_llbit         (top_WB_llbit         ),
    .WB_lladdr_set    (top_WB_lladdr_set    ),
    .WB_lladdr        (top_WB_lladdr        ),
    //================================ TLB接口 ================================
    .WB_tlbrd_en      (top_WB_tlbrd_en      ),
    .WB_tlbfill_en    (top_WB_tlbfill_en    ),
    .WB_tlbwr_en      (top_WB_tlbwr_en      ),
    //================================ 异常处理接口 ================================
    .WB_ertn_flush    (top_WB_ertn_flush    ),
    .WB_ex            (top_WB_ex            ),
    .WB_ecode         (top_WB_ecode         ),
    .WB_esubcode      (top_WB_esubcode      ),
    .WB_excp_tlbrefill(top_WB_excp_tlbrefill),
    .WB_excp_tlb      (top_WB_excp_tlb      ),
    .WB_excp_tlb_vppn (top_WB_excp_tlb_vppn ),
    .WB_refetch_flush (top_WB_refetch_flush ),

    //debug
    .debug_ws_valid    (ws_valid         ),
    .debug_break_point (break_point      ),
    //================================ 流水线控制 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    .flush_sign             (top_flush_sign             ),
    .backend_flush          (top_backend_flush_r        ),
    .WB_flush_next_pc       (top_backend_flush_next_pc  ),
    .backend_flush_ftq_id_o (top_backend_flush_ftq_id   )
    `ifdef DIFFTEST_EN
    ,
    .ws0_valid_diff        (debug0_ws_valid_diff     ),
    .ws0_cnt_inst_diff     (debug0_cnt_inst_diff     ),
    .ws0_timer_64_diff     (debug0_timer_64_diff     ),
    .ws0_inst_ld_en_diff   (debug0_inst_ld_en_diff   ),
    .ws0_ld_paddr_diff     (debug0_ld_paddr_diff     ),
    .ws0_ld_vaddr_diff     (debug0_ld_vaddr_diff     ),
    .ws0_inst_st_en_diff   (debug0_inst_st_en_diff   ),
    .ws0_st_paddr_diff     (debug0_st_paddr_diff     ),
    .ws0_st_vaddr_diff     (debug0_st_vaddr_diff     ),
    .ws0_st_data_diff      (debug0_st_data_diff      ),
    .ws0_csr_rstat_en_diff (debug0_csr_rstat_en_diff ),
    .ws0_csr_data_diff     (debug0_csr_data_diff     )

    ,
    .ws1_valid_diff        (debug1_ws_valid_diff     ),
    .ws1_cnt_inst_diff     (debug1_cnt_inst_diff     ),
    .ws1_timer_64_diff     (debug1_timer_64_diff     ),
    .ws1_inst_ld_en_diff   (debug1_inst_ld_en_diff   ),
    .ws1_ld_paddr_diff     (debug1_ld_paddr_diff     ),
    .ws1_ld_vaddr_diff     (debug1_ld_vaddr_diff     ),
    .ws1_inst_st_en_diff   (debug1_inst_st_en_diff   ),
    .ws1_st_paddr_diff     (debug1_st_paddr_diff     ),
    .ws1_st_vaddr_diff     (debug1_st_vaddr_diff     ),
    .ws1_st_data_diff      (debug1_st_data_diff      ),
    .ws1_csr_rstat_en_diff (debug1_csr_rstat_en_diff ),
    .ws1_csr_data_diff     (debug1_csr_data_diff     )
`endif
);

commit commit(
    .clk                (clk                    ),
    .reset              (reset                  ),
    //================================ 流水线握手信号 ================================
    .commit_queue_full  (top_commit_queue_full  ),
    //================================ 流水线间通信总线 ================================
    .commit_bus         (top_commit_bus         )
    //别忘了用于调试的信号，要不然仿真文件没处采样
    
    ,
    .debug_wb_pc      (debug0_wb_pc          ),
    .debug_wb_rf_we   (debug0_wb_rf_wen      ),
    .debug_wb_rf_wnum (debug0_wb_rf_wnum     ),
    .debug_wb_rf_wdata(debug0_wb_rf_wdata    )
    //.debug_wb_inst    (debug0_wb_inst       ),
    /*`ifdef DIFFTEST_EN
    `else
    ,
    .debug_wb_pc      (debug_wb_pc          ),
    .debug_wb_rf_we   (debug_wb_rf_we       ),
    .debug_wb_rf_wnum (debug_wb_rf_wnum     ),
    .debug_wb_rf_wdata(debug_wb_rf_wdata    )
    `endif*/
);

regfile u_regfile(
    .clk    (clk      ),
    .raddr1 (rf_raddr1),
    .rdata1 (rf_rdata1),
    .raddr2 (rf_raddr2),
    .rdata2 (rf_rdata2),
    .we     (rf_we    ),
    .waddr  (rf_waddr ),
    .wdata  (rf_wdata )
    `ifdef DIFFTEST_EN
    ,
    .rf_o   (regs)
    `endif
    );

csr u_csr(
    .clk            (clk                    ),
    .reset          (reset                  ),
    // 在EXE阶段读出数据
    .csr_re         (top_EXE_csr_re         ), // EXE阶段的读使能
    .csr_rnum       (top_EXE_csr_num        ), // EXE阶段的csr号
    .csr_rdata      (top_csr_rdata          ), // 给EXE阶段
    // 在WB阶段写入数据
    .csr_we         (top_WB_csr_we          ), // WB阶段写的使能
    .csr_wnum       (top_WB_csr_num         ), // WB阶段的csr号
    .csr_wmask      (top_WB_csr_wmask       ),
    .csr_wdata      (top_WB_csr_wdata       ),

    .ex_entry       (top_ex_entry           ), // 给WB阶段
    .ertn_entry     (top_ertn_entry         ), // 给WB阶段
    .tlb_entry      (top_tlb_entry          ), // 给WB阶段
    .has_int        (top_has_int            ), // 给ISS阶段
    .timer_64_rdata (top_timer_64_rdata     ), // 给EXE阶段
    // WB阶段传进来的异常相关信号
    .WB_pc          (top_WB_pc              ),
    .WB_bad_vaddr   (top_WB_bad_vaddr       ),
    .ertn_flush     (top_WB_ertn_flush      ),
    .WB_ex          (top_WB_ex              ),
    .WB_ecode       (top_WB_ecode           ),
    .WB_esubcode    (top_WB_esubcode        ),
    // 与tlb例外有关的信号
    .excp_tlbrefill (top_WB_excp_tlbrefill  ),
    .excp_tlb       (top_WB_excp_tlb        ),
    .excp_tlb_vppn  (top_WB_excp_tlb_vppn   ),
    // 暂时还不用
    .hw_int_in      (intrpt                  ), // 硬中断信号
    .ipi_int_in     (1'b0                   ), // 核间中断信号
    .coreid_in      (32'b0                  ), // 定时器号
    // 传给pre-IF和EXE阶段，用于地址翻译的信号
    .csr_pg         (top_csr_pg             ),
    .csr_da         (top_csr_da             ),
    .csr_dmw0       (top_csr_dmw0           ),
    .csr_dmw1       (top_csr_dmw1           ),
    .csr_plv        (top_csr_plv            ),
    .csr_datf       (top_csr_datf           ),
    .csr_datm       (top_csr_datm           ),
    // to tlb的交互信号，与tlb指令相关
    .csr_asid       (top_csr_asid           ),
    .csr_rand_index (top_csr_rand_index     ),
    .csr_tlbehi     (top_csr_tlbehi         ),
    .csr_tlbelo0    (top_csr_tlbelo0        ),
    .csr_tlbelo1    (top_csr_tlbelo1        ),
    .csr_tlbidx     (top_csr_tlbidx         ),
    .csr_ecode      (top_csr_ecode          ),
    // from tlb的信号，与tlb指令相关
    .tlbsrch_en     (top_EXE_tlbsrch_en     ), // from EXE
    .tlbsrch_found  (top_EXE_tlbsrch_found  ),
    .tlbsrch_index  (top_EXE_tlbsrch_index  ),
    .tlbrd_en       (top_WB_tlbrd_en        ), // from WB
    .tlbehi_in      (top_tlb_tlbehi         ),
    .tlbelo0_in     (top_tlb_tlbelo0        ),
    .tlbelo1_in     (top_tlb_tlbelo1        ),
    .tlbidx_in      (top_tlb_tlbidx         ),
    .asid_in        (top_tlb_asid           ),
    //================================ llbit逻辑接口 ================================
    .llbit_set_in   (top_WB_llbit_set       ),
    .llbit_in       (top_WB_llbit           ),
    .lladdr_set_in  (top_WB_lladdr_set      ),
    .lladdr_in      (top_WB_lladdr          ),
    .llbit_out      (top_llbit              ),
    .lladdr_out     (top_lladdr             )
        //difftest
`ifdef DIFFTEST_EN
    ,
    .csr_crmd_diff      (csr_crmd_diff_0    ),
    .csr_prmd_diff      (csr_prmd_diff_0    ),
    .csr_ectl_diff      (csr_ectl_diff_0    ),
    .csr_estat_diff     (csr_estat_diff_0   ),
    .csr_era_diff       (csr_era_diff_0     ),
    .csr_badv_diff      (csr_badv_diff_0    ),
    .csr_eentry_diff    (csr_eentry_diff_0  ),
    .csr_tlbidx_diff    (csr_tlbidx_diff_0  ),
    .csr_tlbehi_diff    (csr_tlbehi_diff_0  ),
    .csr_tlbelo0_diff   (csr_tlbelo0_diff_0 ),
    .csr_tlbelo1_diff   (csr_tlbelo1_diff_0 ),
    .csr_asid_diff      (csr_asid_diff_0    ),
    .csr_save0_diff     (csr_save0_diff_0   ),
    .csr_save1_diff     (csr_save1_diff_0   ),
    .csr_save2_diff     (csr_save2_diff_0   ),
    .csr_save3_diff     (csr_save3_diff_0   ),
    .csr_tid_diff       (csr_tid_diff_0     ),
    .csr_tcfg_diff      (csr_tcfg_diff_0    ),
    .csr_tval_diff      (csr_tval_diff_0    ),
    .csr_ticlr_diff     (csr_ticlr_diff_0   ),
    .csr_llbctl_diff    (csr_llbctl_diff_0  ),
    .csr_tlbrentry_diff (csr_tlbrentry_diff_0),
    .csr_dmw0_diff      (csr_dmw0_diff_0    ),
    .csr_dmw1_diff      (csr_dmw1_diff_0    ),
    .csr_pgdl_diff      (csr_pgdl_diff_0    ),
    .csr_pgdh_diff      (csr_pgdh_diff_0    )
`endif
    );

addr_trans u_addr_trans(
    //======================== 基础信号 ========================//
    .clk                (clk                        ),
    .asid               (top_csr_asid               ),
    //======================== 模式控制信号 ====================//
    .inst_addr_trans_en (top_inst_addr_trans_en     ),
    .data_addr_trans_en (top_data_addr_trans_en     ),
    //======================== 指令地址转换接口 ========================//
    .inst_fetch         (top_fetch_en               ), // 表示有指令要取
    .inst_vaddr         (top_inst_vaddr             ), // 指令的虚地址
    .inst_dmw0_en       (top_inst_dmw0_en           ),
    .inst_dmw1_en       (top_inst_dmw1_en           ),
    .inst_index         (icache_index               ),         // 指令TLB匹配索引
    .inst_tag           (icache_tag                 ),         // 指令物理地址标签
    .inst_offset        (icache_offset              ),         // 指令页内偏移（用于4KB页）
    .inst_tlb_found     (top_inst_tlb_found         ),
    .inst_tlb_v         (top_inst_tlb_v             ),
    .inst_tlb_d         (top_inst_tlb_d             ),
    .inst_tlb_mat       (top_inst_tlb_mat           ),
    .inst_tlb_plv       (top_inst_tlb_plv           ),
    //======================== 数据地址转换接口 ========================//
    .data_fetch         (top_data_fetch             ),
    .data_vaddr         (top_data_vaddr             ),
    .data_dmw0_en       (top_data_dmw0_en           ),
    .data_dmw1_en       (top_data_dmw1_en           ),
    .cacop_op_mode_di   (top_cacop_op_mode_di       ),
    .data_index         (dcache_index               ),         // 数据TLB匹配索引
    .data_tag           (dcache_tag                 ),         // 数据物理地址标签
    .data_offset        (dcache_offset              ),         // 数据页内偏移
    //.data_tran_addr     (data_sram_addr             ), // 转换后的物理地址传给总线
    .data_tlb_found     (top_data_tlb_found         ),
    .data_tlb_index     (top_data_tlb_index         ),
    .data_tlb_v         (top_data_tlb_v             ),
    .data_tlb_d         (top_data_tlb_d             ),
    .data_tlb_mat       (top_data_tlb_mat           ),
    .data_tlb_plv       (top_data_tlb_plv           ),
    .data_tlb_ppn       (top_data_tlb_ppn           ),
    //======================== TLB维护接口 ========================//
    .tlbfill_en         (top_WB_tlbfill_en          ),
    .tlbwr_en           (top_WB_tlbwr_en            ),
    .rand_index         (top_csr_rand_index         ),
    .tlbehi_in          (top_csr_tlbehi             ),
    .tlbelo0_in         (top_csr_tlbelo0            ),
    .tlbelo1_in         (top_csr_tlbelo1            ),
    .tlbidx_in          (top_csr_tlbidx             ),
    .ecode_in           (top_csr_ecode              ),
    //======================== TLB读取接口 ========================//
    .tlbehi_out         (top_tlb_tlbehi             ),
    .tlbelo0_out        (top_tlb_tlbelo0            ),
    .tlbelo1_out        (top_tlb_tlbelo1            ),
    .tlbidx_out         (top_tlb_tlbidx             ),
    .asid_out           (top_tlb_asid               ),
    //======================== TLB无效化接口 ========================//
    .invtlb_inst        (top_ISS_invtlb_en          ),
    .invtlb_en          (top_EXE_invtlb_en          ),
    .invtlb_asid        (top_EXE_invtlb_asid        ),
    .invtlb_vpn         (top_EXE_invtlb_vpn         ),
    .invtlb_op          (top_EXE_invtlb_op          ),
    //======================== CSR接口 ========================//
    .csr_dmw0           (top_csr_dmw0               ),
    .csr_dmw1           (top_csr_dmw1               ),
    .csr_da             (top_csr_da                 ),
    .csr_pg             (top_csr_pg                 )
);

`ifdef DIFFTEST_EN
// always @(posedge aclk) begin
//     if (reset) begin
//         {cmt_valid, cmt_cnt_inst, cmt_timer_64, cmt_inst_ld_en, cmt_ld_paddr, cmt_ld_vaddr, cmt_inst_st_en, cmt_st_paddr, cmt_st_vaddr, cmt_st_data, cmt_csr_rstat_en, cmt_csr_data} <= 0;
//         {cmt_wen, cmt_wdest, cmt_wdata, cmt_pc, cmt_inst} <= 0;
//         {trap, trap_code, cycleCnt, instrCnt} <= 0;
//     end else if (~trap) begin
//         cmt0_valid       <= inst_valid_diff          ;
//         cmt0_cnt_inst    <= cnt_inst_diff            ;
//         cmt0_timer_64    <= timer_64_diff            ;
//         cmt0_inst_ld_en  <= inst_ld_en_diff          ;
//         cmt0_ld_paddr    <= ld_paddr_diff            ;
//         cmt0_ld_vaddr    <= ld_vaddr_diff            ;
//         cmt0_inst_st_en  <= inst_st_en_diff          ;
//         cmt0_st_paddr    <= st_paddr_diff            ;
//         cmt0_st_vaddr    <= st_vaddr_diff            ;
//         cmt0_st_data     <= st_data_diff             ;
//         cmt0_csr_rstat_en<= csr_rstat_en_diff        ;
//         cmt0_csr_data    <= csr_data_diff            ;

//         cmt0_wen     <=  debug0_wb_rf_wen            ;
//         cmt0_wdest   <=  {3'd0, debug0_wb_rf_wnum}   ;
//         cmt0_wdata   <=  debug0_wb_rf_wdata          ;
//         cmt0_pc      <=  debug0_wb_pc                ;
//         cmt0_inst    <=  debug0_wb_inst              ;

//         cmt0_excp_flush  <= top_WB_ex               ;
//         cmt0_ertn        <= top_WB_ertn_flush               ;
//         cmt0_csr_ecode   <= top_WB_ecode             ;
//         cmt0_tlbfill_en  <= top_WB_tlbfill_en         ;


//         cmt1_valid       <= inst_valid_diff          ;
//         cmt1_cnt_inst    <= cnt_inst_diff            ;
//         cmt1_timer_64    <= timer_64_diff            ;
//         cmt1_inst_ld_en  <= inst_ld_en_diff          ;
//         cmt1_ld_paddr    <= ld_paddr_diff            ;
//         cmt1_ld_vaddr    <= ld_vaddr_diff            ;
//         cmt1_inst_st_en  <= inst_st_en_diff          ;
//         cmt1_st_paddr    <= st_paddr_diff            ;
//         cmt1_st_vaddr    <= st_vaddr_diff            ;
//         cmt1_st_data     <= st_data_diff             ;
//         cmt1_csr_rstat_en<= csr_rstat_en_diff        ;
//         cmt1_csr_data    <= csr_data_diff            ;

//         cmt1_wen     <=  debug0_wb_rf_wen            ;
//         cmt1_wdest   <=  {3'd0, debug0_wb_rf_wnum}   ;
//         cmt1_wdata   <=  debug0_wb_rf_wdata          ;
//         cmt1_pc      <=  debug0_wb_pc                ;
//         cmt1_inst    <=  debug0_wb_inst              ;

//         cmt1_excp_flush  <= top_WB_ex               ;
//         cmt1_ertn        <= top_WB_ertn_flush               ;
//         cmt1_csr_ecode   <= top_WB_ecode             ;
//         cmt1_tlbfill_en  <= top_WB_tlbfill_en         ;


//         trap            <= 0                        ;
//         trap_code       <= regs[10][7:0]            ;
//         cycleCnt        <= cycleCnt + 1             ;
//         instrCnt        <= instrCnt + inst_valid_diff;
        
        
//         cmt_rand_index  <= top_csr_rand_index        ;
//     end
// end

// DifftestInstrCommit DifftestInstrCommit(
//     .clock              (aclk           ),
//     .coreid             (0              ),
//     .index              (0              ),
//     .valid              (cmt_valid      ),
//     .pc                 (cmt_pc         ),
//     .instr              (cmt_inst       ),
//     .skip               (0              ),
//     .is_TLBFILL         (cmt_tlbfill_en ),
//     .TLBFILL_index      (cmt_rand_index ),
//     .is_CNTinst         (cmt_cnt_inst   ),
//     .timer_64_value     (cmt_timer_64   ),
//     .wen                (cmt_wen        ),
//     .wdest              (cmt_wdest      ),
//     .wdata              (cmt_wdata      ),
//     .csr_rstat          (cmt_csr_rstat_en),
//     .csr_data           (cmt_csr_data   )
// );

// DifftestExcpEvent DifftestExcpEvent(
//     .clock              (aclk           ),
//     .coreid             (0              ),
//     .excp_valid         (cmt_excp_flush ),
//     .eret               (cmt_ertn       ),
//     .intrNo             (csr_estat_diff_0[12:2]),
//     .cause              (cmt_csr_ecode  ),
//     .exceptionPC        (cmt_pc         ),
//     .exceptionInst      (cmt_inst       )
// );

// DifftestTrapEvent DifftestTrapEvent(
//     .clock              (aclk           ),
//     .coreid             (0              ),
//     .valid              (trap           ),
//     .code               (trap_code      ),
//     .pc                 (cmt_pc         ),
//     .cycleCnt           (cycleCnt       ),
//     .instrCnt           (instrCnt       )
// );

// DifftestStoreEvent DifftestStoreEvent(
//     .clock              (aclk           ),
//     .coreid             (0              ),
//     .index              (0              ),
//     .valid              (cmt_inst_st_en ),
//     .storePAddr         (cmt_st_paddr   ),
//     .storeVAddr         (cmt_st_vaddr   ),
//     .storeData          (cmt_st_data    )
// );

// DifftestLoadEvent DifftestLoadEvent(
//     .clock              (aclk           ),
//     .coreid             (0              ),
//     .index              (0              ),
//     .valid              (cmt_inst_ld_en ),
//     .paddr              (cmt_ld_paddr   ),
//     .vaddr              (cmt_ld_vaddr   )
// );

// DifftestCSRRegState DifftestCSRRegState(
//     .clock              (aclk               ),
//     .coreid             (0                  ),
//     .crmd               (csr_crmd_diff_0    ),
//     .prmd               (csr_prmd_diff_0    ),
//     .euen               (0                  ),
//     .ecfg               (csr_ectl_diff_0    ),
//     .estat              (csr_estat_diff_0   ),
//     .era                (csr_era_diff_0     ),
//     .badv               (csr_badv_diff_0    ),
//     .eentry             (csr_eentry_diff_0  ),
//     .tlbidx             (csr_tlbidx_diff_0  ),
//     .tlbehi             (csr_tlbehi_diff_0  ),
//     .tlbelo0            (csr_tlbelo0_diff_0 ),
//     .tlbelo1            (csr_tlbelo1_diff_0 ),
//     .asid               (csr_asid_diff_0    ),
//     .pgdl               (csr_pgdl_diff_0    ),
//     .pgdh               (csr_pgdh_diff_0    ),
//     .save0              (csr_save0_diff_0   ),
//     .save1              (csr_save1_diff_0   ),
//     .save2              (csr_save2_diff_0   ),
//     .save3              (csr_save3_diff_0   ),
//     .tid                (csr_tid_diff_0     ),
//     .tcfg               (csr_tcfg_diff_0    ),
//     .tval               (csr_tval_diff_0    ),
//     .ticlr              (csr_ticlr_diff_0   ),
//     .llbctl             (csr_llbctl_diff_0  ),
//     .tlbrentry          (csr_tlbrentry_diff_0),
//     .dmw0               (csr_dmw0_diff_0    ),
//     .dmw1               (csr_dmw1_diff_0    )
// );

// DifftestGRegState DifftestGRegState(
//     .clock              (aclk       ),
//     .coreid             (0          ),
//     .gpr_0              (0          ),
//     .gpr_1              (regs[1]    ),
//     .gpr_2              (regs[2]    ),
//     .gpr_3              (regs[3]    ),
//     .gpr_4              (regs[4]    ),
//     .gpr_5              (regs[5]    ),
//     .gpr_6              (regs[6]    ),
//     .gpr_7              (regs[7]    ),
//     .gpr_8              (regs[8]    ),
//     .gpr_9              (regs[9]    ),
//     .gpr_10             (regs[10]   ),
//     .gpr_11             (regs[11]   ),
//     .gpr_12             (regs[12]   ),
//     .gpr_13             (regs[13]   ),
//     .gpr_14             (regs[14]   ),
//     .gpr_15             (regs[15]   ),
//     .gpr_16             (regs[16]   ),
//     .gpr_17             (regs[17]   ),
//     .gpr_18             (regs[18]   ),
//     .gpr_19             (regs[19]   ),
//     .gpr_20             (regs[20]   ),
//     .gpr_21             (regs[21]   ),
//     .gpr_22             (regs[22]   ),
//     .gpr_23             (regs[23]   ),
//     .gpr_24             (regs[24]   ),
//     .gpr_25             (regs[25]   ),
//     .gpr_26             (regs[26]   ),
//     .gpr_27             (regs[27]   ),
//     .gpr_28             (regs[28]   ),
//     .gpr_29             (regs[29]   ),
//     .gpr_30             (regs[30]   ),
//     .gpr_31             (regs[31]   )
// );

    always @(posedge aclk) begin
        if (reset) begin
            {cmt0_valid, cmt0_cnt_inst, cmt0_timer_64, cmt0_inst_ld_en, cmt0_ld_paddr, cmt0_ld_vaddr, cmt0_inst_st_en, cmt0_st_paddr, cmt0_st_vaddr, cmt0_st_data, cmt0_csr_rstat_en, cmt0_csr_data} <= 0;
            {cmt0_wen, cmt0_wdest, cmt0_wdata, cmt0_pc, cmt0_inst} <= 0;
            {trap, trap_code, cycleCnt, instrCnt} <= 0;
        end
        else begin
            cmt0_valid       <= debug0_ws_valid_diff;
            cmt0_cnt_inst    <= debug0_cnt_inst_diff;
            cmt0_timer_64    <= debug0_timer_64_diff;
            cmt0_inst_ld_en  <= debug0_inst_ld_en_diff;
            cmt0_ld_paddr    <= debug0_ld_paddr_diff;
            cmt0_ld_vaddr    <= debug0_ld_vaddr_diff;
            cmt0_inst_st_en  <= debug0_inst_st_en_diff;
            cmt0_st_paddr    <= debug0_st_paddr_diff;
            cmt0_st_vaddr    <= debug0_st_vaddr_diff;
            cmt0_st_data     <= debug0_st_data_diff ;
            cmt0_csr_rstat_en<= debug0_csr_rstat_en_diff;
            cmt0_csr_data    <= debug0_csr_data_diff;
   
            cmt0_wen         <= debug_wb_rf_we[0];
            cmt0_wdest       <= {3'd0, debug_wb_rf_wnum[0]};

            cmt0_wdata       <= debug_wb_rf_wdata[0];
            cmt0_pc          <= debug_wb_pc[0];
            cmt0_inst        <= debug_wb_inst[0];

            cmt0_excp_flush  <= top_WB_ex              ;
            cmt0_ertn        <= top_WB_ertn_flush      ;
            cmt0_csr_ecode   <= top_WB_ecode           ;
            cmt0_tlbfill_en  <= top_WB_tlbfill_en      ;   

            cmt1_valid       <= debug1_ws_valid_diff;
            cmt1_cnt_inst    <= debug1_cnt_inst_diff;
            cmt1_timer_64    <= debug1_timer_64_diff;
            cmt1_inst_ld_en  <= debug1_inst_ld_en_diff;
            cmt1_ld_paddr    <= debug1_ld_paddr_diff;
            cmt1_ld_vaddr    <= debug1_ld_vaddr_diff;
            cmt1_inst_st_en  <= debug1_inst_st_en_diff;
            cmt1_st_paddr    <= debug1_st_paddr_diff;
            cmt1_st_vaddr    <= debug1_st_vaddr_diff;
            cmt1_st_data     <= debug1_st_data_diff ;
            cmt1_csr_rstat_en<= debug1_csr_rstat_en_diff;
            cmt1_csr_data    <= debug1_csr_data_diff;

            cmt1_wen         <= debug_wb_rf_we[1];
            cmt1_wdest       <= {3'd0, debug_wb_rf_wnum[1]};

            cmt1_wdata       <= debug_wb_rf_wdata[1];
            cmt1_pc          <= debug_wb_pc[1];
            cmt1_inst        <= debug_wb_inst[1];

            cmt1_excp_flush  <= 0'b0            ;
            cmt1_ertn        <= 0'b0            ;
            cmt1_csr_ecode   <= 0'b0            ;
            cmt1_tlbfill_en  <= 0'b0            ;


            cmt_rand_index   <= top_csr_rand_index;  
        end
          
    end
/*
    assign debug0_wb_inst = diff[0].debug_wb_inst;
    assign debug0_wb_pc = diff[0].debug_wb_pc;
    assign debug0_wb_rf_wen = diff[0].debug_wb_rf_wen;
    assign debug0_wb_rf_wnum = diff[0].debug_wb_rf_wnum;
    assign debug0_wb_rf_wdata = diff[0].debug_wb_rf_wdata;

    assign debug1_wb_inst = diff[1].debug_wb_inst;
    assign debug1_wb_pc = diff[1].debug_wb_pc;
    assign debug1_wb_rf_wen = diff[1].debug_wb_rf_wen;
    assign debug1_wb_rf_wnum = diff[1].debug_wb_rf_wnum;
    assign debug1_wb_rf_wdata = diff[1].debug_wb_rf_wdata;

    assign debug_wb_pc       = debug0_wb_pc      | debug1_wb_pc      ;
    assign debug_wb_rf_we    = debug0_wb_rf_wen  | debug1_wb_rf_wen  ;
    assign debug_wb_rf_wnum  = debug0_wb_rf_wnum | debug1_wb_rf_wnum ;
    assign debug_wb_rf_wdata = debug0_wb_rf_wdata| debug1_wb_rf_wdata;

*/

    logic [63:0] inst_num;
    always_ff @( posedge aclk ) begin
        if (reset) begin
            inst_num <= 0;
        end else if (debug0_ws_valid_diff && debug1_ws_valid_diff) begin
            inst_num <= inst_num + 2;
        end else if (debug0_ws_valid_diff || debug1_ws_valid_diff) begin
            inst_num <= inst_num + 1;
        end else begin
            inst_num <= inst_num;
        end
    end

    always @(posedge aclk) begin
        if (reset) begin
            {trap, trap_code, cycleCnt, instrCnt} <= 0;
        end else begin
            trap            <= 0                        ;
            trap_code       <= 0                        ;
            cycleCnt        <= cycleCnt + 1             ;
            instrCnt        <= instrCnt;
        end
    end

    logic excp_flush;
    logic [31:0] excp_pc;
    logic [31:0] excp_inst;
    
    always_comb begin
        if (cmt0_excp_flush) begin
            excp_flush = cmt0_excp_flush;
            excp_pc = cmt0_pc;
            excp_inst = cmt0_inst;
        end else begin
            excp_flush = cmt1_excp_flush;
            excp_pc = cmt1_pc;
            excp_inst = cmt1_inst;
        end
    end
    

    DifftestInstrCommit DifftestInstrCommit_0(
        .clock              (aclk           ),
        .coreid             (0              ),
        .index              (0     ),
        .valid              (cmt0_valid   ),
        .pc                 (cmt0_pc      ),
        .instr              (cmt0_inst    ),
        .skip               (0              ),
        .is_TLBFILL         (cmt0_tlbfill_en),
        .TLBFILL_index      (cmt_rand_index ),
        .is_CNTinst         (cmt0_cnt_inst),
        .timer_64_value     (cmt0_timer_64),
        .wen                (cmt0_wen     ),
        .wdest              (cmt0_wdest   ),
        .wdata              (cmt0_wdata   ),
        .csr_rstat          (cmt0_csr_rstat_en),
        .csr_data           (cmt0_csr_data)
    );

    DifftestInstrCommit DifftestInstrCommit_1(
        .clock              (aclk           ),
        .coreid             (0              ),
        .index              (1    ),
        .valid              (cmt1_valid   ),
        .pc                 (cmt1_pc      ),
        .instr              (cmt1_inst    ),
        .skip               (0              ),
        .is_TLBFILL         (cmt1_tlbfill_en),
        .TLBFILL_index      (cmt_rand_index ),
        .is_CNTinst         (cmt1_cnt_inst),
        .timer_64_value     (cmt1_timer_64),
        .wen                (cmt1_wen     ),
        .wdest              (cmt1_wdest   ),
        .wdata              (cmt1_wdata   ),
        .csr_rstat          (cmt1_csr_rstat_en),
        .csr_data           (cmt1_csr_data)
    );



    DifftestExcpEvent DifftestExcpEvent(
        .clock              (aclk           ),
        .coreid             (0              ),
        .excp_valid         (excp_flush     ),
        .eret               (cmt0_ertn      ),
        .intrNo             (csr_estat_diff_0[12:2]),
        .cause              (cmt0_csr_ecode ),
        .exceptionPC        (excp_pc        ),
        .exceptionInst      (excp_inst      )
    );

    DifftestTrapEvent DifftestTrapEvent(
        .clock              (aclk           ),
        .coreid             (0              ),
        .valid              (trap           ),
        .code               (trap_code      ),
        .pc                 (cmt0_pc        ),
        .cycleCnt           (cycleCnt       ),
        .instrCnt           (instrCnt       )
    );
     
    DifftestStoreEvent DifftestStoreEvent0(
        .clock              (aclk             ),
        .coreid             (0                ),
        .index              (0                ),
        .valid              (cmt0_inst_st_en),
        .storePAddr         (cmt0_st_paddr  ),
        .storeVAddr         (cmt0_st_vaddr  ),
        .storeData          (cmt0_st_data   )
    );

    DifftestStoreEvent DifftestStoreEvent1(
        .clock              (aclk             ),
        .coreid             (0                ),
        .index              (1                ),
        .valid              (cmt1_inst_st_en),
        .storePAddr         (cmt1_st_paddr  ),
        .storeVAddr         (cmt1_st_vaddr  ),
        .storeData          (cmt1_st_data   )
    );

    DifftestLoadEvent DifftestLoadEvent0(
        .clock              (aclk             ),
        .coreid             (0                ),
        .index              (0                ),
        .valid              (cmt0_inst_ld_en),
        .paddr              (cmt0_ld_paddr  ),
        .vaddr              (cmt0_ld_vaddr  )
    );

    DifftestLoadEvent DifftestLoadEvent1(
        .clock              (aclk             ),
        .coreid             (0                ),
        .index              (1                ),
        .valid              (cmt1_inst_ld_en),
        .paddr              (cmt1_ld_paddr  ),
        .vaddr              (cmt1_ld_vaddr  )
    );

    DifftestCSRRegState DifftestCSRRegState(
        .clock              (aclk               ),
        .coreid             (0                  ),
        .crmd               (csr_crmd_diff_0    ),
        .prmd               (csr_prmd_diff_0    ),
        .euen               (0                  ),
        .ecfg               (csr_ectl_diff_0    ),
        .estat              (csr_estat_diff_0   ),
        .era                (csr_era_diff_0     ),
        .badv               (csr_badv_diff_0    ),
        .eentry             (csr_eentry_diff_0  ),
        .tlbidx             (csr_tlbidx_diff_0  ),
        .tlbehi             (csr_tlbehi_diff_0  ),
        .tlbelo0            (csr_tlbelo0_diff_0 ),
        .tlbelo1            (csr_tlbelo1_diff_0 ),
        .asid               (csr_asid_diff_0    ),
        .pgdl               (csr_pgdl_diff_0    ),
        .pgdh               (csr_pgdh_diff_0    ),
        .save0              (csr_save0_diff_0   ),
        .save1              (csr_save1_diff_0   ),
        .save2              (csr_save2_diff_0   ),
        .save3              (csr_save3_diff_0   ),
        .tid                (csr_tid_diff_0     ),
        .tcfg               (csr_tcfg_diff_0    ),
        .tval               (csr_tval_diff_0    ),
        .ticlr              (csr_ticlr_diff_0   ),
        .llbctl             (csr_llbctl_diff_0  ),
        .tlbrentry          (csr_tlbrentry_diff_0),
        .dmw0               (csr_dmw0_diff_0    ),
        .dmw1               (csr_dmw1_diff_0    )
    );
    DifftestGRegState DifftestGRegState(
        .clock              (aclk       ),
        .coreid             (0          ),
        .gpr_0              (0          ),
        .gpr_1              (regs[1]   ),
        .gpr_2              (regs[2]   ),
        .gpr_3              (regs[3]   ),
        .gpr_4              (regs[4]   ),
        .gpr_5              (regs[5]   ),
        .gpr_6              (regs[6]   ),
        .gpr_7              (regs[7]   ),
        .gpr_8              (regs[8]   ),
        .gpr_9              (regs[9]   ),
        .gpr_10             (regs[10]   ),
        .gpr_11             (regs[11]   ),
        .gpr_12             (regs[12]   ),
        .gpr_13             (regs[13]   ),
        .gpr_14             (regs[14]   ),
        .gpr_15             (regs[15]   ),
        .gpr_16             (regs[16]   ),
        .gpr_17             (regs[17]   ),
        .gpr_18             (regs[18]   ),
        .gpr_19             (regs[19]   ),
        .gpr_20             (regs[20]   ),
        .gpr_21             (regs[21]   ),
        .gpr_22             (regs[22]   ),
        .gpr_23             (regs[23]   ),
        .gpr_24             (regs[24]   ),
        .gpr_25             (regs[25]   ),
        .gpr_26             (regs[26]   ),
        .gpr_27             (regs[27]   ),
        .gpr_28             (regs[28]   ),
        .gpr_29             (regs[29]   ),
        .gpr_30             (regs[30]   ),
        .gpr_31             (regs[31]   )
    );
`endif

endmodule