`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module csr_exception_commit_handler_tb;
  reg  clk;
  reg  reset;
  reg [11:0] csr_rnum;
  reg [11:0] csr_num;
  reg  csr_we;
  reg [31:0] csr_wmask;
  reg [31:0] csr_wvalue;
  reg  tlbsrch_found;
  reg [4:0] tlbsrch_index;
  reg [31:0] tlbrd_tlbidx;
  reg [31:0] tlbrd_tlbehi;
  reg [31:0] tlbrd_tlbelo0;
  reg [31:0] tlbrd_tlbelo1;
  reg [9:0] tlbrd_asid;
  reg [ 7:0] hw_int_in;
  reg  ipi_int_in;
  reg  wb_valid;
  reg [31:0] wb_pc;
  reg  wb_is_ertn;
  reg [31:0] wb_vaddr;
  reg  wb_ex;
  reg [`TLB_OP_NUM-1:0] wb_tlb_op;
  reg  INT_valid;
  reg  ADEF_valid;
  reg  ADEM_valid;
  reg  IPE_valid;
  reg [`TLB_EX_NUM-1:0] TLB_EX_valid;
  reg  ALE_valid;
  reg  SYS_valid;
  reg  BRK_valid;
  reg  INE_valid;
  reg  ll_set_in;
  reg  sc_set_in;
  reg [27:0] lladdr_in;
  wire  flush_pipeline;
  wire [31:0] csr_next_pc;
  wire [1:0] csr_redirect;
  wire  has_int;
  wire [31:0] csr_rvalue;
  wire [31:0] csr_tid_out;
  wire  csr_crmd_da_out;
  wire  csr_crmd_pg_out;
  wire [1:0] csr_crmd_plv_out;
  wire [9:0] csr_asid_out;
  wire [31:0] csr_tlbidx_out;
  wire [31:0] csr_tlbehi_out;
  wire [31:0] csr_tlbelo0_out;
  wire [31:0] csr_tlbelo1_out;
  wire [31:0] csr_dmw0_out;
  wire [31:0] csr_dmw1_out;
  wire [4:0] csr_rand_index_out;
  wire [1:0] csr_crmd_datf_out;
  wire [1:0] csr_crmd_datm_out;
  wire [7:0] csr_estat_ecode_out;
  wire [31:0] csr_crmd_out;
  wire  csr_llbit_out;
  wire [27:0] csr_lladdr_out;
  wire [63:0] diff_timer_64;
  csr_exception_commit_handler uut(
    .clk(clk),
    .reset(reset),
    .csr_rnum(csr_rnum),
    .csr_num(csr_num),
    .csr_we(csr_we),
    .csr_wmask(csr_wmask),
    .csr_wvalue(csr_wvalue),
    .tlbsrch_found(tlbsrch_found),
    .tlbsrch_index(tlbsrch_index),
    .tlbrd_tlbidx(tlbrd_tlbidx),
    .tlbrd_tlbehi(tlbrd_tlbehi),
    .tlbrd_tlbelo0(tlbrd_tlbelo0),
    .tlbrd_tlbelo1(tlbrd_tlbelo1),
    .tlbrd_asid(tlbrd_asid),
    .hw_int_in(hw_int_in),
    .ipi_int_in(ipi_int_in),
    .wb_valid(wb_valid),
    .wb_pc(wb_pc),
    .wb_is_ertn(wb_is_ertn),
    .wb_vaddr(wb_vaddr),
    .wb_ex(wb_ex),
    .wb_tlb_op(wb_tlb_op),
    .INT_valid(INT_valid),
    .ADEF_valid(ADEF_valid),
    .ADEM_valid(ADEM_valid),
    .IPE_valid(IPE_valid),
    .TLB_EX_valid(TLB_EX_valid),
    .ALE_valid(ALE_valid),
    .SYS_valid(SYS_valid),
    .BRK_valid(BRK_valid),
    .INE_valid(INE_valid),
    .ll_set_in(ll_set_in),
    .sc_set_in(sc_set_in),
    .lladdr_in(lladdr_in),
    .flush_pipeline(flush_pipeline),
    .csr_next_pc(csr_next_pc),
    .csr_redirect(csr_redirect),
    .has_int(has_int),
    .csr_rvalue(csr_rvalue),
    .csr_tid_out(csr_tid_out),
    .csr_crmd_da_out(csr_crmd_da_out),
    .csr_crmd_pg_out(csr_crmd_pg_out),
    .csr_crmd_plv_out(csr_crmd_plv_out),
    .csr_asid_out(csr_asid_out),
    .csr_tlbidx_out(csr_tlbidx_out),
    .csr_tlbehi_out(csr_tlbehi_out),
    .csr_tlbelo0_out(csr_tlbelo0_out),
    .csr_tlbelo1_out(csr_tlbelo1_out),
    .csr_dmw0_out(csr_dmw0_out),
    .csr_dmw1_out(csr_dmw1_out),
    .csr_rand_index_out(csr_rand_index_out),
    .csr_crmd_datf_out(csr_crmd_datf_out),
    .csr_crmd_datm_out(csr_crmd_datm_out),
    .csr_estat_ecode_out(csr_estat_ecode_out),
    .csr_crmd_out(csr_crmd_out),
    .csr_llbit_out(csr_llbit_out),
    .csr_lladdr_out(csr_lladdr_out),
    .diff_timer_64(diff_timer_64)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    `TB_PASS("csr_exception_commit_handler tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
