`include "../../common/cpu_defs.vh"

// ============================================================
// MEMport：访存级。load 需等待 data_r_complete；完成后 load_done_match 保持 ready 直至读回的数据离开。
// data_r_complete -> load_done_match -> readyGo -> allowIn
// ============================================================
module MEMport (
    input  wire                   clk,
    input  wire                   reset,
    input  wire                   valid,
    input  wire                   slot_tag_in,

    input  wire [31:0]            data_sram_rdata,
    input  wire [31:0]            exe_result,
    input  wire [31:0]            pc_in,
    input  wire [ 4:0]            wb_reg_addr_in,
    input  wire [`MEM_OP_NUM-1:0] mem_op,
    input  wire                   wb_op_in,
    input  wire [31:0]            mem_wdata_in,

    input  wire [31:0]            data_raddr_from_EXE,
    input  wire [31:0]            data_waddr_from_EXE,
    input  wire                   data_w_complete,
    input  wire                   data_r_complete,

    input wire  [`CSR_OP_NUM-1:0] csr_op_in,
    input wire  [11:0]            csr_num_in,
    input wire  [31:0]            csr_wmask_in,
    input wire  [31:0]            csr_wvalue_in,
    input wire  [`WB_SRC_NUM-1:0] wb_src_op_in,

    input wire  [`TLB_OP_NUM-1:0] tlb_op_in,
    input wire  [9:0]             invtlb_asid_in,
    input wire  [18:0]            invtlb_vpn_in,

    input wire  [`CACHE_OP_NUM-1:0] cache_op_valid_in,
    input wire  [1:0]             cache_cacop_op_in,
    input wire  [31:0]            cache_cacop_addr_in,
    input wire  [1:0]             cache_cacop_mat_in,
    input wire  [4:0]             cache_cacop_cd_in,
    input wire                    refetch_tag_in,

    input wire                    ertn_op_in,
    input wire                    sys_valid_in,
    input wire                    brk_valid_in,
    input wire                    ine_valid_in,
    input wire                    adef_valid_in,
    input wire                    int_valid_in,
    input wire                    ale_valid_in,
    input wire                    exception_valid_in,
    input wire  [31:0]            if_vaddr_in,
    input wire  [31:0]            ale_vaddr_in,

    input wire  [`TLB_EX_NUM-1:0] tlb_ex_valid_in,
    input wire  [31:0]            tlb_vaddr_in,

    output wire [`CSR_OP_NUM-1:0] csr_op_out,
    output wire [11:0]            csr_num_out,
    output wire [31:0]            csr_wmask_out,
    output wire [31:0]            csr_wvalue_out,
    output wire [`WB_SRC_NUM-1:0] wb_src_op_out,

    output wire [`TLB_OP_NUM-1:0] tlb_op_out,
    output wire [9:0]             invtlb_asid_out,
    output wire [18:0]            invtlb_vpn_out,

    output wire                   readyGo,
    output wire                   allowIn,
    output wire                   load_pending_for_hazard,

    output wire [31:0]            wb_wdata,
    output wire [31:0]            pc_out,
    output wire [ 4:0]            wb_reg_addr_out,
    output wire                   wb_op_out,

    output wire                   ertn_op_out,
    output wire                   sys_valid_out,
    output wire                   brk_valid_out,
    output wire                   ine_valid_out,
    output wire                   adef_valid_out,
    output wire                   ale_valid_out,
    output wire                   int_valid_out,
    output wire                   exception_valid_out,
    output wire [31:0]            if_vaddr_out,
    output wire [31:0]            ale_vaddr_out,

    output wire [`TLB_EX_NUM-1:0] tlb_ex_valid_out,
    output wire [31:0]            tlb_vaddr_out,

    output wire  [`CACHE_OP_NUM-1:0] cache_op_valid_out,
    output wire  [1:0]             cache_cacop_op_out,
    output wire  [31:0]            cache_cacop_addr_out,
    output wire  [1:0]             cache_cacop_mat_out,
    output wire  [4:0]             cache_cacop_cd_out,
    output wire                    refetch_tag_out
);

wire   mem_valid = valid && !refetch_tag_in; 
wire   bram_re;
wire   bram_we;

wire   exception_valid_w;
assign exception_valid_w = exception_valid_in;

assign bram_re = (exception_valid_w || !mem_valid) ? 1'b0 :
                 (mem_op[`MEM_OP_LD_W] | mem_op[`MEM_OP_LD_H] | mem_op[`MEM_OP_LD_B]
                | mem_op[`MEM_OP_LD_HU] | mem_op[`MEM_OP_LD_BU]);
assign bram_we = (exception_valid_w || !mem_valid) ? 1'b0 :
                 (mem_op[`MEM_OP_ST_W] | mem_op[`MEM_OP_ST_H] | mem_op[`MEM_OP_ST_B]);

wire [31:0] r_word_addr   = {data_raddr_from_EXE[31:2], 2'b00};
wire [31:0] w_word_addr   = {data_waddr_from_EXE[31:2], 2'b00};
wire [ 1:0] load_addr_off = data_raddr_from_EXE[1:0];

reg [31:0] load_rdata_hold;
always @(posedge clk) begin
    if (reset || !bram_re)
        load_rdata_hold <= 32'b0;
    else if (data_r_complete)
        load_rdata_hold <= data_sram_rdata;
end

wire [31:0] load_wdata_raw = data_r_complete ? data_sram_rdata : load_rdata_hold;

wire [ 7:0] r_byte_data;
wire [15:0] r_half_data;
wire [31:0] r_word_data;

assign r_byte_data = (load_addr_off == 2'b00) ? load_wdata_raw[7:0] :
                     (load_addr_off == 2'b01) ? load_wdata_raw[15:8] :
                     (load_addr_off == 2'b10) ? load_wdata_raw[23:16] :
                     load_wdata_raw[31:24];

assign r_half_data = (load_addr_off == 2'b00) ? load_wdata_raw[15:0] :
                     (load_addr_off == 2'b10) ? load_wdata_raw[31:16] :
                     16'b0;

assign r_word_data = load_wdata_raw;

wire [31:0] load_result;

assign load_result = (mem_op[`MEM_OP_LD_B])  ? {{24{r_byte_data[7]}}, r_byte_data[7:0]} :
                     (mem_op[`MEM_OP_LD_H])  ? {{16{r_half_data[15]}}, r_half_data[15:0]} :
                     (mem_op[`MEM_OP_LD_BU]) ? {24'b0, r_byte_data[7:0]} :
                     (mem_op[`MEM_OP_LD_HU]) ? {16'b0, r_half_data[15:0]} :
                     (mem_op[`MEM_OP_LD_W])  ? r_word_data :
                                               32'b0;

reg load_done_hold;
reg load_done_tag;
wire load_done_match = load_done_hold
                     && mem_valid
                     && bram_re
                     && (slot_tag_in == load_done_tag);

always @(posedge clk) begin
    if (reset)
        load_done_hold <= 1'b0;
    else if (!mem_valid || !bram_re)
        load_done_hold <= 1'b0;
    else if (load_done_match && !data_r_complete)
        load_done_hold <= 1'b0;
    else if (load_done_hold && (slot_tag_in != load_done_tag))
        load_done_hold <= 1'b0;
    else if (data_r_complete) begin
        load_done_hold <= 1'b1;
        load_done_tag  <= slot_tag_in;
    end
end

assign readyGo = bram_re ? (data_r_complete | load_done_match) : 1'b1;
assign allowIn = readyGo;
assign load_pending_for_hazard = mem_valid & bram_re & ~(data_r_complete | load_done_match);

wire memport_in_lint = data_w_complete | (|mem_wdata_in) | (|data_waddr_from_EXE)
                      | bram_we | (|r_word_addr) | (|w_word_addr);
assign wb_wdata        = !exception_valid_w && mem_valid ? ((bram_re ? load_result : exe_result)
                                 ^ ({32{memport_in_lint}} ^ {32{memport_in_lint}})) : 32'b0;
assign pc_out          = mem_valid ? pc_in : 32'b0;
assign wb_reg_addr_out = !exception_valid_w && mem_valid ? wb_reg_addr_in : 5'b0;
assign wb_op_out       = !exception_valid_w && mem_valid ? wb_op_in : 1'b0;

assign csr_op_out = mem_valid ? csr_op_in : {`CSR_OP_NUM{1'b0}};
assign csr_num_out = mem_valid ? csr_num_in : 12'b0;
assign csr_wmask_out = mem_valid ? csr_wmask_in : 32'b0;
assign csr_wvalue_out = mem_valid ? csr_wvalue_in : 32'b0;
assign wb_src_op_out = mem_valid ? wb_src_op_in : {`WB_SRC_NUM{1'b0}};

assign ertn_op_out = mem_valid ? ertn_op_in : 1'b0;
assign sys_valid_out = mem_valid ? sys_valid_in : 1'b0;
assign brk_valid_out = mem_valid ? brk_valid_in : 1'b0;
assign ine_valid_out = mem_valid ? ine_valid_in : 1'b0;
assign adef_valid_out = mem_valid ? adef_valid_in : 1'b0;
assign ale_valid_out = mem_valid ? ale_valid_in : 1'b0;
assign int_valid_out = mem_valid ? int_valid_in : 1'b0;
assign exception_valid_out = mem_valid ? exception_valid_in : 1'b0;
assign if_vaddr_out = mem_valid && adef_valid_in ? if_vaddr_in : 32'b0;
assign ale_vaddr_out = mem_valid && ale_valid_in ? ale_vaddr_in : 32'b0;

assign tlb_op_out = mem_valid ? tlb_op_in : {`TLB_OP_NUM{1'b0}};
assign invtlb_asid_out = mem_valid ? invtlb_asid_in : 10'b0;
assign invtlb_vpn_out = mem_valid ? invtlb_vpn_in : 19'b0;
assign tlb_ex_valid_out = mem_valid ? tlb_ex_valid_in : {`TLB_EX_NUM{1'b0}};
assign tlb_vaddr_out = mem_valid && tlb_ex_valid_in ? tlb_vaddr_in : 32'b0;

assign cache_op_valid_out = valid ? cache_op_valid_in : {`CACHE_OP_NUM{1'b0}};
assign cache_cacop_op_out = valid ? cache_cacop_op_in : 2'b0;
assign cache_cacop_addr_out = valid ? cache_cacop_addr_in : 32'b0;
assign cache_cacop_mat_out = valid ? cache_cacop_mat_in : 2'b0;
assign cache_cacop_cd_out = valid ? cache_cacop_cd_in : 5'b0;
assign refetch_tag_out = valid ? refetch_tag_in : 1'b0;


endmodule
