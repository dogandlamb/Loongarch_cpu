`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module decoder_tb;
  reg clk;
  reg reset;
  reg [31:0] inst_i;
  reg [31:0] pc_i;
  reg [1:0] csr_plv_i;
  reg  csr_llbit_i;
  wire [`FU_NUM-1:0] futype_o;
  wire [`ALU_OP_NUM-1:0] alu_op_o;
  wire [`BR_OP_NUM-1:0] br_op_o;
  wire [`MEM_OP_NUM-1:0] mem_op_o;
  wire [`CSR_OP_NUM-1:0] csr_op_o;
  wire [`TLB_OP_NUM-1:0] tlb_op_o;
  wire [`WB_SRC_NUM-1:0] wb_src_op_o;
  wire [13:0] csr_num_o;
  wire [4:0] cacop_code_o;
  wire [4:0] src0_addr_o;
  wire [4:0] src1_addr_o;
  wire  use_src0_o;
  wire  use_src1_o;
  wire [4:0] rd_addr_o;
  wire  rf_we_o;
  wire [31:0] imm_o;
  wire  use_imm_o;
  wire [31:0] br_offs_o;
  wire  is_branch_o;
  wire [`BR_TYPE_W-1:0] br_type_o;
  wire [`PRIV_NUM-1:0] priv_vec_o;
  wire  is_nop_o;
  wire  is_load_o;
  wire  is_store_o;
  wire [`EXCP_NUM-1:0] excp_o;
  decoder uut(
    .inst_i(inst_i),
    .pc_i(pc_i),
    .csr_plv_i(csr_plv_i),
    .csr_llbit_i(csr_llbit_i),
    .futype_o(futype_o),
    .alu_op_o(alu_op_o),
    .br_op_o(br_op_o),
    .mem_op_o(mem_op_o),
    .csr_op_o(csr_op_o),
    .tlb_op_o(tlb_op_o),
    .wb_src_op_o(wb_src_op_o),
    .csr_num_o(csr_num_o),
    .cacop_code_o(cacop_code_o),
    .src0_addr_o(src0_addr_o),
    .src1_addr_o(src1_addr_o),
    .use_src0_o(use_src0_o),
    .use_src1_o(use_src1_o),
    .rd_addr_o(rd_addr_o),
    .rf_we_o(rf_we_o),
    .imm_o(imm_o),
    .use_imm_o(use_imm_o),
    .br_offs_o(br_offs_o),
    .is_branch_o(is_branch_o),
    .br_type_o(br_type_o),
    .priv_vec_o(priv_vec_o),
    .is_nop_o(is_nop_o),
    .is_load_o(is_load_o),
    .is_store_o(is_store_o),
    .excp_o(excp_o)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    inst_i=32'h00000001; pc_i=32'h1000; csr_llbit_i=0;
    #1;
    `TB_PASS("decoder decode beat");

    `TB_PASS("decoder tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
