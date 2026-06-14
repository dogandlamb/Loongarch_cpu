`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module rename_tb;
  reg  clk;
  reg  reset;
  reg  flush_i;
  reg  ib0_valid_i;
  reg [31:0] ib0_pc_i;
  reg [31:0] ib0_inst_i;
  reg  ib0_pred_taken_i;
  reg  ib0_is_last_i;
  reg [`FTQ_W-1:0] ib0_ftq_id_i;
  reg [`EXCP_NUM-1:0] ib0_excp_i;
  reg [`FU_NUM-1:0] ib0_futype_i;
  reg [`ALU_OP_NUM-1:0] ib0_alu_op_i;
  reg [`BR_OP_NUM-1:0] ib0_br_op_i;
  reg [`MEM_OP_NUM-1:0] ib0_mem_op_i;
  reg [`CSR_OP_NUM-1:0] ib0_csr_op_i;
  reg [`TLB_OP_NUM-1:0] ib0_tlb_op_i;
  reg [`WB_SRC_NUM-1:0] ib0_wb_src_op_i;
  reg [13:0] ib0_csr_num_i;
  reg [4:0] ib0_cacop_code_i;
  reg [4:0] ib0_src0_addr_i;
  reg [4:0] ib0_src1_addr_i;
  reg  ib0_use_src0_i;
  reg  ib0_use_src1_i;
  reg [4:0] ib0_rd_addr_i;
  reg  ib0_rf_we_i;
  reg [31:0] ib0_imm_i;
  reg  ib0_use_imm_i;
  reg [31:0] ib0_br_offs_i;
  reg  ib0_is_branch_i;
  reg [`BR_TYPE_W-1:0] ib0_br_type_i;
  reg [`PRIV_NUM-1:0] ib0_priv_vec_i;
  reg  ib0_is_nop_i;
  reg  ib0_is_load_i;
  reg  ib0_is_store_i;
  wire  ib0_ready_o;
  reg  ib1_valid_i;
  reg [31:0] ib1_pc_i;
  reg [31:0] ib1_inst_i;
  reg  ib1_pred_taken_i;
  reg  ib1_is_last_i;
  reg [`FTQ_W-1:0] ib1_ftq_id_i;
  reg [`EXCP_NUM-1:0] ib1_excp_i;
  reg [`FU_NUM-1:0] ib1_futype_i;
  reg [`ALU_OP_NUM-1:0] ib1_alu_op_i;
  reg [`BR_OP_NUM-1:0] ib1_br_op_i;
  reg [`MEM_OP_NUM-1:0] ib1_mem_op_i;
  reg [`CSR_OP_NUM-1:0] ib1_csr_op_i;
  reg [`TLB_OP_NUM-1:0] ib1_tlb_op_i;
  reg [`WB_SRC_NUM-1:0] ib1_wb_src_op_i;
  reg [13:0] ib1_csr_num_i;
  reg [4:0] ib1_cacop_code_i;
  reg [4:0] ib1_src0_addr_i;
  reg [4:0] ib1_src1_addr_i;
  reg  ib1_use_src0_i;
  reg  ib1_use_src1_i;
  reg [4:0] ib1_rd_addr_i;
  reg  ib1_rf_we_i;
  reg [31:0] ib1_imm_i;
  reg  ib1_use_imm_i;
  reg [31:0] ib1_br_offs_i;
  reg  ib1_is_branch_i;
  reg [`BR_TYPE_W-1:0] ib1_br_type_i;
  reg [`PRIV_NUM-1:0] ib1_priv_vec_i;
  reg  ib1_is_nop_i;
  reg  ib1_is_load_i;
  reg  ib1_is_store_i;
  wire  ib1_ready_o;
  wire [4:0] rat_raddr0_o;
  reg  rat_rbusy0_i;
  reg [`ROB_W-1:0] rat_rnum0_i;
  wire [4:0] rat_raddr1_o;
  reg  rat_rbusy1_i;
  reg [`ROB_W-1:0] rat_rnum1_i;
  wire [4:0] rat_raddr2_o;
  reg  rat_rbusy2_i;
  reg [`ROB_W-1:0] rat_rnum2_i;
  wire [4:0] rat_raddr3_o;
  reg  rat_rbusy3_i;
  reg [`ROB_W-1:0] rat_rnum3_i;
  wire  rat_wen0_o;
  wire [4:0] rat_waddr0_o;
  wire [`ROB_W-1:0] rat_wnum0_o;
  wire  rat_wen1_o;
  wire [4:0] rat_waddr1_o;
  wire [`ROB_W-1:0] rat_wnum1_o;
  wire [4:0] arf_raddr0_o;
  reg [31:0] arf_rdata0_i;
  wire [4:0] arf_raddr1_o;
  reg [31:0] arf_rdata1_i;
  wire [4:0] arf_raddr2_o;
  reg [31:0] arf_rdata2_i;
  wire [4:0] arf_raddr3_o;
  reg [31:0] arf_rdata3_i;
  wire  rob_alloc_en_o;
  reg [`ROB_PAIR_W-1:0] rob_tail_i;
  reg  rob_full_i;
  wire  rob_a0_valid_o;
  wire [31:0] rob_a0_pc_o;
  wire [31:0] rob_a0_inst_o;
  wire  rob_a0_rf_we_o;
  wire [4:0] rob_a0_rd_o;
  wire [`FU_NUM-1:0] rob_a0_futype_o;
  wire  rob_a0_is_load_o;
  wire  rob_a0_is_store_o;
  wire  rob_a0_is_branch_o;
  wire [`BR_TYPE_W-1:0] rob_a0_br_type_o;
  wire  rob_a0_pred_taken_o;
  wire  rob_a0_is_last_o;
  wire [`FTQ_W-1:0] rob_a0_ftq_id_o;
  wire [`PRIV_NUM-1:0] rob_a0_priv_vec_o;
  wire [13:0] rob_a0_csr_num_o;
  wire [`TLB_OP_NUM-1:0] rob_a0_tlb_op_o;
  wire [4:0] rob_a0_cacop_code_o;
  wire [`EXCP_NUM-1:0] rob_a0_excp_o;
  wire  rob_a0_is_nop_o;
  wire  rob_a1_valid_o;
  wire [31:0] rob_a1_pc_o;
  wire [31:0] rob_a1_inst_o;
  wire  rob_a1_rf_we_o;
  wire [4:0] rob_a1_rd_o;
  wire [`FU_NUM-1:0] rob_a1_futype_o;
  wire  rob_a1_is_load_o;
  wire  rob_a1_is_store_o;
  wire  rob_a1_is_branch_o;
  wire [`BR_TYPE_W-1:0] rob_a1_br_type_o;
  wire  rob_a1_pred_taken_o;
  wire  rob_a1_is_last_o;
  wire [`FTQ_W-1:0] rob_a1_ftq_id_o;
  wire [`PRIV_NUM-1:0] rob_a1_priv_vec_o;
  wire [13:0] rob_a1_csr_num_o;
  wire [`TLB_OP_NUM-1:0] rob_a1_tlb_op_o;
  wire [4:0] rob_a1_cacop_code_o;
  wire [`EXCP_NUM-1:0] rob_a1_excp_o;
  wire  rob_a1_is_nop_o;
  reg  rs_alu0_can_accept_i;
  reg  rs_alu1_can_accept_i;
  reg [2:0] rs_alu0_occupancy_i;
  reg [2:0] rs_alu1_occupancy_i;
  reg  rs_mem_can_accept_i;
  reg  rs_mdu_can_accept_i;
  reg  cmt_wake0_valid_i;
  reg [4:0] cmt_wake0_rd_i;
  reg [31:0] cmt_wake0_data_i;
  reg  cmt_wake1_valid_i;
  reg [4:0] cmt_wake1_rd_i;
  reg [31:0] cmt_wake1_data_i;
  reg  dispatch_ready_i;
  reg  dis_handed_i;
  reg  dis0_handed_i;
  reg  dis1_handed_i;
  wire  dis0_valid_o;
  wire [`ROB_W-1:0] dis0_robid_o;
  wire [31:0] dis0_pc_o;
  wire [`FU_NUM-1:0] dis0_futype_o;
  wire [`ALU_OP_NUM-1:0] dis0_alu_op_o;
  wire [`BR_OP_NUM-1:0] dis0_br_op_o;
  wire [`MEM_OP_NUM-1:0] dis0_mem_op_o;
  wire [`CSR_OP_NUM-1:0] dis0_csr_op_o;
  wire [`TLB_OP_NUM-1:0] dis0_tlb_op_o;
  wire [`WB_SRC_NUM-1:0] dis0_wb_src_op_o;
  wire [13:0] dis0_csr_num_o;
  wire  dis0_is_cacop_o;
  wire  dis0_src0_ready_o;
  wire [31:0] dis0_src0_val_o;
  wire [`ROB_W-1:0] dis0_src0_robid_o;
  wire [4:0] dis0_src0_addr_o;
  wire  dis0_src1_ready_o;
  wire [31:0] dis0_src1_val_o;
  wire [`ROB_W-1:0] dis0_src1_robid_o;
  wire [4:0] dis0_src1_addr_o;
  wire [31:0] dis0_imm_o;
  wire  dis0_use_imm_o;
  wire [31:0] dis0_br_offs_o;
  wire  dis1_valid_o;
  wire [`ROB_W-1:0] dis1_robid_o;
  wire [31:0] dis1_pc_o;
  wire [`FU_NUM-1:0] dis1_futype_o;
  wire [`ALU_OP_NUM-1:0] dis1_alu_op_o;
  wire [`BR_OP_NUM-1:0] dis1_br_op_o;
  wire [`MEM_OP_NUM-1:0] dis1_mem_op_o;
  wire [`CSR_OP_NUM-1:0] dis1_csr_op_o;
  wire [`TLB_OP_NUM-1:0] dis1_tlb_op_o;
  wire [`WB_SRC_NUM-1:0] dis1_wb_src_op_o;
  wire [13:0] dis1_csr_num_o;
  wire  dis1_is_cacop_o;
  wire  dis1_src0_ready_o;
  wire [31:0] dis1_src0_val_o;
  wire [`ROB_W-1:0] dis1_src0_robid_o;
  wire [4:0] dis1_src0_addr_o;
  wire  dis1_src1_ready_o;
  wire [31:0] dis1_src1_val_o;
  wire [`ROB_W-1:0] dis1_src1_robid_o;
  wire [4:0] dis1_src1_addr_o;
  wire [31:0] dis1_imm_o;
  wire  dis1_use_imm_o;
  wire [31:0] dis1_br_offs_o;
  rename uut(
    .clk(clk),
    .reset(reset),
    .flush_i(flush_i),
    .ib0_valid_i(ib0_valid_i),
    .ib0_pc_i(ib0_pc_i),
    .ib0_inst_i(ib0_inst_i),
    .ib0_pred_taken_i(ib0_pred_taken_i),
    .ib0_is_last_i(ib0_is_last_i),
    .ib0_ftq_id_i(ib0_ftq_id_i),
    .ib0_excp_i(ib0_excp_i),
    .ib0_futype_i(ib0_futype_i),
    .ib0_alu_op_i(ib0_alu_op_i),
    .ib0_br_op_i(ib0_br_op_i),
    .ib0_mem_op_i(ib0_mem_op_i),
    .ib0_csr_op_i(ib0_csr_op_i),
    .ib0_tlb_op_i(ib0_tlb_op_i),
    .ib0_wb_src_op_i(ib0_wb_src_op_i),
    .ib0_csr_num_i(ib0_csr_num_i),
    .ib0_cacop_code_i(ib0_cacop_code_i),
    .ib0_src0_addr_i(ib0_src0_addr_i),
    .ib0_src1_addr_i(ib0_src1_addr_i),
    .ib0_use_src0_i(ib0_use_src0_i),
    .ib0_use_src1_i(ib0_use_src1_i),
    .ib0_rd_addr_i(ib0_rd_addr_i),
    .ib0_rf_we_i(ib0_rf_we_i),
    .ib0_imm_i(ib0_imm_i),
    .ib0_use_imm_i(ib0_use_imm_i),
    .ib0_br_offs_i(ib0_br_offs_i),
    .ib0_is_branch_i(ib0_is_branch_i),
    .ib0_br_type_i(ib0_br_type_i),
    .ib0_priv_vec_i(ib0_priv_vec_i),
    .ib0_is_nop_i(ib0_is_nop_i),
    .ib0_is_load_i(ib0_is_load_i),
    .ib0_is_store_i(ib0_is_store_i),
    .ib0_ready_o(ib0_ready_o),
    .ib1_valid_i(ib1_valid_i),
    .ib1_pc_i(ib1_pc_i),
    .ib1_inst_i(ib1_inst_i),
    .ib1_pred_taken_i(ib1_pred_taken_i),
    .ib1_is_last_i(ib1_is_last_i),
    .ib1_ftq_id_i(ib1_ftq_id_i),
    .ib1_excp_i(ib1_excp_i),
    .ib1_futype_i(ib1_futype_i),
    .ib1_alu_op_i(ib1_alu_op_i),
    .ib1_br_op_i(ib1_br_op_i),
    .ib1_mem_op_i(ib1_mem_op_i),
    .ib1_csr_op_i(ib1_csr_op_i),
    .ib1_tlb_op_i(ib1_tlb_op_i),
    .ib1_wb_src_op_i(ib1_wb_src_op_i),
    .ib1_csr_num_i(ib1_csr_num_i),
    .ib1_cacop_code_i(ib1_cacop_code_i),
    .ib1_src0_addr_i(ib1_src0_addr_i),
    .ib1_src1_addr_i(ib1_src1_addr_i),
    .ib1_use_src0_i(ib1_use_src0_i),
    .ib1_use_src1_i(ib1_use_src1_i),
    .ib1_rd_addr_i(ib1_rd_addr_i),
    .ib1_rf_we_i(ib1_rf_we_i),
    .ib1_imm_i(ib1_imm_i),
    .ib1_use_imm_i(ib1_use_imm_i),
    .ib1_br_offs_i(ib1_br_offs_i),
    .ib1_is_branch_i(ib1_is_branch_i),
    .ib1_br_type_i(ib1_br_type_i),
    .ib1_priv_vec_i(ib1_priv_vec_i),
    .ib1_is_nop_i(ib1_is_nop_i),
    .ib1_is_load_i(ib1_is_load_i),
    .ib1_is_store_i(ib1_is_store_i),
    .ib1_ready_o(ib1_ready_o),
    .rat_raddr0_o(rat_raddr0_o),
    .rat_rbusy0_i(rat_rbusy0_i),
    .rat_rnum0_i(rat_rnum0_i),
    .rat_raddr1_o(rat_raddr1_o),
    .rat_rbusy1_i(rat_rbusy1_i),
    .rat_rnum1_i(rat_rnum1_i),
    .rat_raddr2_o(rat_raddr2_o),
    .rat_rbusy2_i(rat_rbusy2_i),
    .rat_rnum2_i(rat_rnum2_i),
    .rat_raddr3_o(rat_raddr3_o),
    .rat_rbusy3_i(rat_rbusy3_i),
    .rat_rnum3_i(rat_rnum3_i),
    .rat_wen0_o(rat_wen0_o),
    .rat_waddr0_o(rat_waddr0_o),
    .rat_wnum0_o(rat_wnum0_o),
    .rat_wen1_o(rat_wen1_o),
    .rat_waddr1_o(rat_waddr1_o),
    .rat_wnum1_o(rat_wnum1_o),
    .arf_raddr0_o(arf_raddr0_o),
    .arf_rdata0_i(arf_rdata0_i),
    .arf_raddr1_o(arf_raddr1_o),
    .arf_rdata1_i(arf_rdata1_i),
    .arf_raddr2_o(arf_raddr2_o),
    .arf_rdata2_i(arf_rdata2_i),
    .arf_raddr3_o(arf_raddr3_o),
    .arf_rdata3_i(arf_rdata3_i),
    .rob_alloc_en_o(rob_alloc_en_o),
    .rob_tail_i(rob_tail_i),
    .rob_full_i(rob_full_i),
    .rob_a0_valid_o(rob_a0_valid_o),
    .rob_a0_pc_o(rob_a0_pc_o),
    .rob_a0_inst_o(rob_a0_inst_o),
    .rob_a0_rf_we_o(rob_a0_rf_we_o),
    .rob_a0_rd_o(rob_a0_rd_o),
    .rob_a0_futype_o(rob_a0_futype_o),
    .rob_a0_is_load_o(rob_a0_is_load_o),
    .rob_a0_is_store_o(rob_a0_is_store_o),
    .rob_a0_is_branch_o(rob_a0_is_branch_o),
    .rob_a0_br_type_o(rob_a0_br_type_o),
    .rob_a0_pred_taken_o(rob_a0_pred_taken_o),
    .rob_a0_is_last_o(rob_a0_is_last_o),
    .rob_a0_ftq_id_o(rob_a0_ftq_id_o),
    .rob_a0_priv_vec_o(rob_a0_priv_vec_o),
    .rob_a0_csr_num_o(rob_a0_csr_num_o),
    .rob_a0_tlb_op_o(rob_a0_tlb_op_o),
    .rob_a0_cacop_code_o(rob_a0_cacop_code_o),
    .rob_a0_excp_o(rob_a0_excp_o),
    .rob_a0_is_nop_o(rob_a0_is_nop_o),
    .rob_a1_valid_o(rob_a1_valid_o),
    .rob_a1_pc_o(rob_a1_pc_o),
    .rob_a1_inst_o(rob_a1_inst_o),
    .rob_a1_rf_we_o(rob_a1_rf_we_o),
    .rob_a1_rd_o(rob_a1_rd_o),
    .rob_a1_futype_o(rob_a1_futype_o),
    .rob_a1_is_load_o(rob_a1_is_load_o),
    .rob_a1_is_store_o(rob_a1_is_store_o),
    .rob_a1_is_branch_o(rob_a1_is_branch_o),
    .rob_a1_br_type_o(rob_a1_br_type_o),
    .rob_a1_pred_taken_o(rob_a1_pred_taken_o),
    .rob_a1_is_last_o(rob_a1_is_last_o),
    .rob_a1_ftq_id_o(rob_a1_ftq_id_o),
    .rob_a1_priv_vec_o(rob_a1_priv_vec_o),
    .rob_a1_csr_num_o(rob_a1_csr_num_o),
    .rob_a1_tlb_op_o(rob_a1_tlb_op_o),
    .rob_a1_cacop_code_o(rob_a1_cacop_code_o),
    .rob_a1_excp_o(rob_a1_excp_o),
    .rob_a1_is_nop_o(rob_a1_is_nop_o),
    .rs_alu0_can_accept_i(rs_alu0_can_accept_i),
    .rs_alu1_can_accept_i(rs_alu1_can_accept_i),
    .rs_alu0_occupancy_i(rs_alu0_occupancy_i),
    .rs_alu1_occupancy_i(rs_alu1_occupancy_i),
    .rs_mem_can_accept_i(rs_mem_can_accept_i),
    .rs_mdu_can_accept_i(rs_mdu_can_accept_i),
    .cmt_wake0_valid_i(cmt_wake0_valid_i),
    .cmt_wake0_rd_i(cmt_wake0_rd_i),
    .cmt_wake0_data_i(cmt_wake0_data_i),
    .cmt_wake1_valid_i(cmt_wake1_valid_i),
    .cmt_wake1_rd_i(cmt_wake1_rd_i),
    .cmt_wake1_data_i(cmt_wake1_data_i),
    .dispatch_ready_i(dispatch_ready_i),
    .dis_handed_i(dis_handed_i),
    .dis0_handed_i(dis0_handed_i),
    .dis1_handed_i(dis1_handed_i),
    .dis0_valid_o(dis0_valid_o),
    .dis0_robid_o(dis0_robid_o),
    .dis0_pc_o(dis0_pc_o),
    .dis0_futype_o(dis0_futype_o),
    .dis0_alu_op_o(dis0_alu_op_o),
    .dis0_br_op_o(dis0_br_op_o),
    .dis0_mem_op_o(dis0_mem_op_o),
    .dis0_csr_op_o(dis0_csr_op_o),
    .dis0_tlb_op_o(dis0_tlb_op_o),
    .dis0_wb_src_op_o(dis0_wb_src_op_o),
    .dis0_csr_num_o(dis0_csr_num_o),
    .dis0_is_cacop_o(dis0_is_cacop_o),
    .dis0_src0_ready_o(dis0_src0_ready_o),
    .dis0_src0_val_o(dis0_src0_val_o),
    .dis0_src0_robid_o(dis0_src0_robid_o),
    .dis0_src0_addr_o(dis0_src0_addr_o),
    .dis0_src1_ready_o(dis0_src1_ready_o),
    .dis0_src1_val_o(dis0_src1_val_o),
    .dis0_src1_robid_o(dis0_src1_robid_o),
    .dis0_src1_addr_o(dis0_src1_addr_o),
    .dis0_imm_o(dis0_imm_o),
    .dis0_use_imm_o(dis0_use_imm_o),
    .dis0_br_offs_o(dis0_br_offs_o),
    .dis1_valid_o(dis1_valid_o),
    .dis1_robid_o(dis1_robid_o),
    .dis1_pc_o(dis1_pc_o),
    .dis1_futype_o(dis1_futype_o),
    .dis1_alu_op_o(dis1_alu_op_o),
    .dis1_br_op_o(dis1_br_op_o),
    .dis1_mem_op_o(dis1_mem_op_o),
    .dis1_csr_op_o(dis1_csr_op_o),
    .dis1_tlb_op_o(dis1_tlb_op_o),
    .dis1_wb_src_op_o(dis1_wb_src_op_o),
    .dis1_csr_num_o(dis1_csr_num_o),
    .dis1_is_cacop_o(dis1_is_cacop_o),
    .dis1_src0_ready_o(dis1_src0_ready_o),
    .dis1_src0_val_o(dis1_src0_val_o),
    .dis1_src0_robid_o(dis1_src0_robid_o),
    .dis1_src0_addr_o(dis1_src0_addr_o),
    .dis1_src1_ready_o(dis1_src1_ready_o),
    .dis1_src1_val_o(dis1_src1_val_o),
    .dis1_src1_robid_o(dis1_src1_robid_o),
    .dis1_src1_addr_o(dis1_src1_addr_o),
    .dis1_imm_o(dis1_imm_o),
    .dis1_use_imm_o(dis1_use_imm_o),
    .dis1_br_offs_o(dis1_br_offs_o)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    `TB_PASS("rename tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
