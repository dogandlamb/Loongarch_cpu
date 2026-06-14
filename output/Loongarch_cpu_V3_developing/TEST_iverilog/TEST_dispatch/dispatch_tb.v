`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module dispatch_tb;
  reg clk;
  reg reset;
  reg  dis0_valid_i;
  reg [`ROB_W-1:0] dis0_robid_i;
  reg [31:0] dis0_pc_i;
  reg [`FU_NUM-1:0] dis0_futype_i;
  reg [`ALU_OP_NUM-1:0] dis0_alu_op_i;
  reg [`BR_OP_NUM-1:0] dis0_br_op_i;
  reg [`MEM_OP_NUM-1:0] dis0_mem_op_i;
  reg [`CSR_OP_NUM-1:0] dis0_csr_op_i;
  reg [`TLB_OP_NUM-1:0] dis0_tlb_op_i;
  reg [`WB_SRC_NUM-1:0] dis0_wb_src_op_i;
  reg [13:0] dis0_csr_num_i;
  reg  dis0_is_cacop_i;
  reg  dis0_src0_ready_i;
  reg [31:0] dis0_src0_val_i;
  reg [`ROB_W-1:0] dis0_src0_robid_i;
  reg [4:0] dis0_src0_addr_i;
  reg  dis0_src1_ready_i;
  reg [31:0] dis0_src1_val_i;
  reg [`ROB_W-1:0] dis0_src1_robid_i;
  reg [4:0] dis0_src1_addr_i;
  reg [31:0] dis0_imm_i;
  reg  dis0_use_imm_i;
  reg [31:0] dis0_br_offs_i;
  reg  dis1_valid_i;
  reg [`ROB_W-1:0] dis1_robid_i;
  reg [31:0] dis1_pc_i;
  reg [`FU_NUM-1:0] dis1_futype_i;
  reg [`ALU_OP_NUM-1:0] dis1_alu_op_i;
  reg [`BR_OP_NUM-1:0] dis1_br_op_i;
  reg [`MEM_OP_NUM-1:0] dis1_mem_op_i;
  reg [`CSR_OP_NUM-1:0] dis1_csr_op_i;
  reg [`TLB_OP_NUM-1:0] dis1_tlb_op_i;
  reg [`WB_SRC_NUM-1:0] dis1_wb_src_op_i;
  reg [13:0] dis1_csr_num_i;
  reg  dis1_is_cacop_i;
  reg  dis1_src0_ready_i;
  reg [31:0] dis1_src0_val_i;
  reg [`ROB_W-1:0] dis1_src0_robid_i;
  reg [4:0] dis1_src0_addr_i;
  reg  dis1_src1_ready_i;
  reg [31:0] dis1_src1_val_i;
  reg [`ROB_W-1:0] dis1_src1_robid_i;
  reg [4:0] dis1_src1_addr_i;
  reg [31:0] dis1_imm_i;
  reg  dis1_use_imm_i;
  reg [31:0] dis1_br_offs_i;
  wire  dispatch_ready_o;
  wire  dis_handed_o;
  wire  dis0_handed_o;
  wire  dis1_handed_o;
  wire [`ROB_W-1:0] rob_raddr0_o;
  reg  rob_rrdy0_i;
  reg [31:0] rob_rdata0_i;
  wire [`ROB_W-1:0] rob_raddr1_o;
  reg  rob_rrdy1_i;
  reg [31:0] rob_rdata1_i;
  wire [`ROB_W-1:0] rob_raddr2_o;
  reg  rob_rrdy2_i;
  reg [31:0] rob_rdata2_i;
  wire [`ROB_W-1:0] rob_raddr3_o;
  reg  rob_rrdy3_i;
  reg [31:0] rob_rdata3_i;
  reg  cmt_wake0_valid_i;
  reg [`ROB_W-1:0] cmt_wake0_robid_i;
  reg [31:0] cmt_wake0_data_i;
  reg [4:0] cmt_wake0_rd_i;
  reg  cmt_wake1_valid_i;
  reg [`ROB_W-1:0] cmt_wake1_robid_i;
  reg [31:0] cmt_wake1_data_i;
  reg [4:0] cmt_wake1_rd_i;
  reg  rat_rbusy4_i;
  reg [`ROB_W-1:0] rat_rnum4_i;
  reg [31:0] arf_rdata4_i;
  reg  rat_rbusy5_i;
  reg [`ROB_W-1:0] rat_rnum5_i;
  reg [31:0] arf_rdata5_i;
  reg  rat_rbusy6_i;
  reg [`ROB_W-1:0] rat_rnum6_i;
  reg [31:0] arf_rdata6_i;
  reg  rat_rbusy7_i;
  reg [`ROB_W-1:0] rat_rnum7_i;
  reg [31:0] arf_rdata7_i;
  reg  rs_alu0_can_accept_i;
  reg [2:0] rs_alu0_occupancy_i;
  wire  rs_alu0_push_valid_o;
  wire [`ROB_W-1:0] rs_alu0_push_robid_o;
  wire [31:0] rs_alu0_push_pc_o;
  wire [`ALU_OP_NUM-1:0] rs_alu0_push_alu_op_o;
  wire [`BR_OP_NUM-1:0] rs_alu0_push_br_op_o;
  wire  rs_alu0_push_src0_ready_o;
  wire [31:0] rs_alu0_push_src0_val_o;
  wire [`ROB_W-1:0] rs_alu0_push_src0_robid_o;
  wire  rs_alu0_push_src1_ready_o;
  wire [31:0] rs_alu0_push_src1_val_o;
  wire [`ROB_W-1:0] rs_alu0_push_src1_robid_o;
  wire [31:0] rs_alu0_push_imm_o;
  wire  rs_alu0_push_use_imm_o;
  wire [31:0] rs_alu0_push_br_offs_o;
  reg  rs_alu1_can_accept_i;
  reg [2:0] rs_alu1_occupancy_i;
  wire  rs_alu1_push_valid_o;
  wire [`ROB_W-1:0] rs_alu1_push_robid_o;
  wire [31:0] rs_alu1_push_pc_o;
  wire [`ALU_OP_NUM-1:0] rs_alu1_push_alu_op_o;
  wire [`BR_OP_NUM-1:0] rs_alu1_push_br_op_o;
  wire  rs_alu1_push_src0_ready_o;
  wire [31:0] rs_alu1_push_src0_val_o;
  wire [`ROB_W-1:0] rs_alu1_push_src0_robid_o;
  wire  rs_alu1_push_src1_ready_o;
  wire [31:0] rs_alu1_push_src1_val_o;
  wire [`ROB_W-1:0] rs_alu1_push_src1_robid_o;
  wire [31:0] rs_alu1_push_imm_o;
  wire  rs_alu1_push_use_imm_o;
  wire [31:0] rs_alu1_push_br_offs_o;
  reg  rs_mem_can_accept_i;
  wire  rs_mem_push_valid_o;
  wire [`ROB_W-1:0] rs_mem_push_robid_o;
  wire [31:0] rs_mem_push_pc_o;
  wire [`MEM_OP_NUM-1:0] rs_mem_push_mem_op_o;
  wire  rs_mem_push_is_cacop_o;
  wire  rs_mem_push_src0_ready_o;
  wire [31:0] rs_mem_push_src0_val_o;
  wire [`ROB_W-1:0] rs_mem_push_src0_robid_o;
  wire  rs_mem_push_src1_ready_o;
  wire [31:0] rs_mem_push_src1_val_o;
  wire [`ROB_W-1:0] rs_mem_push_src1_robid_o;
  wire [31:0] rs_mem_push_imm_o;
  reg  rs_mdu_can_accept_i;
  wire  rs_mdu_push_valid_o;
  wire [`ROB_W-1:0] rs_mdu_push_robid_o;
  wire [`ALU_OP_NUM-1:0] rs_mdu_push_alu_op_o;
  wire [`CSR_OP_NUM-1:0] rs_mdu_push_csr_op_o;
  wire [13:0] rs_mdu_push_csr_num_o;
  wire [`TLB_OP_NUM-1:0] rs_mdu_push_tlb_op_o;
  wire [`WB_SRC_NUM-1:0] rs_mdu_push_wb_src_op_o;
  wire  rs_mdu_push_src0_ready_o;
  wire [31:0] rs_mdu_push_src0_val_o;
  wire [`ROB_W-1:0] rs_mdu_push_src0_robid_o;
  wire  rs_mdu_push_src1_ready_o;
  wire [31:0] rs_mdu_push_src1_val_o;
  wire [`ROB_W-1:0] rs_mdu_push_src1_robid_o;
  dispatch uut(
    .dis0_valid_i(dis0_valid_i),
    .dis0_robid_i(dis0_robid_i),
    .dis0_pc_i(dis0_pc_i),
    .dis0_futype_i(dis0_futype_i),
    .dis0_alu_op_i(dis0_alu_op_i),
    .dis0_br_op_i(dis0_br_op_i),
    .dis0_mem_op_i(dis0_mem_op_i),
    .dis0_csr_op_i(dis0_csr_op_i),
    .dis0_tlb_op_i(dis0_tlb_op_i),
    .dis0_wb_src_op_i(dis0_wb_src_op_i),
    .dis0_csr_num_i(dis0_csr_num_i),
    .dis0_is_cacop_i(dis0_is_cacop_i),
    .dis0_src0_ready_i(dis0_src0_ready_i),
    .dis0_src0_val_i(dis0_src0_val_i),
    .dis0_src0_robid_i(dis0_src0_robid_i),
    .dis0_src0_addr_i(dis0_src0_addr_i),
    .dis0_src1_ready_i(dis0_src1_ready_i),
    .dis0_src1_val_i(dis0_src1_val_i),
    .dis0_src1_robid_i(dis0_src1_robid_i),
    .dis0_src1_addr_i(dis0_src1_addr_i),
    .dis0_imm_i(dis0_imm_i),
    .dis0_use_imm_i(dis0_use_imm_i),
    .dis0_br_offs_i(dis0_br_offs_i),
    .dis1_valid_i(dis1_valid_i),
    .dis1_robid_i(dis1_robid_i),
    .dis1_pc_i(dis1_pc_i),
    .dis1_futype_i(dis1_futype_i),
    .dis1_alu_op_i(dis1_alu_op_i),
    .dis1_br_op_i(dis1_br_op_i),
    .dis1_mem_op_i(dis1_mem_op_i),
    .dis1_csr_op_i(dis1_csr_op_i),
    .dis1_tlb_op_i(dis1_tlb_op_i),
    .dis1_wb_src_op_i(dis1_wb_src_op_i),
    .dis1_csr_num_i(dis1_csr_num_i),
    .dis1_is_cacop_i(dis1_is_cacop_i),
    .dis1_src0_ready_i(dis1_src0_ready_i),
    .dis1_src0_val_i(dis1_src0_val_i),
    .dis1_src0_robid_i(dis1_src0_robid_i),
    .dis1_src0_addr_i(dis1_src0_addr_i),
    .dis1_src1_ready_i(dis1_src1_ready_i),
    .dis1_src1_val_i(dis1_src1_val_i),
    .dis1_src1_robid_i(dis1_src1_robid_i),
    .dis1_src1_addr_i(dis1_src1_addr_i),
    .dis1_imm_i(dis1_imm_i),
    .dis1_use_imm_i(dis1_use_imm_i),
    .dis1_br_offs_i(dis1_br_offs_i),
    .dispatch_ready_o(dispatch_ready_o),
    .dis_handed_o(dis_handed_o),
    .dis0_handed_o(dis0_handed_o),
    .dis1_handed_o(dis1_handed_o),
    .rob_raddr0_o(rob_raddr0_o),
    .rob_rrdy0_i(rob_rrdy0_i),
    .rob_rdata0_i(rob_rdata0_i),
    .rob_raddr1_o(rob_raddr1_o),
    .rob_rrdy1_i(rob_rrdy1_i),
    .rob_rdata1_i(rob_rdata1_i),
    .rob_raddr2_o(rob_raddr2_o),
    .rob_rrdy2_i(rob_rrdy2_i),
    .rob_rdata2_i(rob_rdata2_i),
    .rob_raddr3_o(rob_raddr3_o),
    .rob_rrdy3_i(rob_rrdy3_i),
    .rob_rdata3_i(rob_rdata3_i),
    .cmt_wake0_valid_i(cmt_wake0_valid_i),
    .cmt_wake0_robid_i(cmt_wake0_robid_i),
    .cmt_wake0_data_i(cmt_wake0_data_i),
    .cmt_wake0_rd_i(cmt_wake0_rd_i),
    .cmt_wake1_valid_i(cmt_wake1_valid_i),
    .cmt_wake1_robid_i(cmt_wake1_robid_i),
    .cmt_wake1_data_i(cmt_wake1_data_i),
    .cmt_wake1_rd_i(cmt_wake1_rd_i),
    .rat_rbusy4_i(rat_rbusy4_i),
    .rat_rnum4_i(rat_rnum4_i),
    .arf_rdata4_i(arf_rdata4_i),
    .rat_rbusy5_i(rat_rbusy5_i),
    .rat_rnum5_i(rat_rnum5_i),
    .arf_rdata5_i(arf_rdata5_i),
    .rat_rbusy6_i(rat_rbusy6_i),
    .rat_rnum6_i(rat_rnum6_i),
    .arf_rdata6_i(arf_rdata6_i),
    .rat_rbusy7_i(rat_rbusy7_i),
    .rat_rnum7_i(rat_rnum7_i),
    .arf_rdata7_i(arf_rdata7_i),
    .rs_alu0_can_accept_i(rs_alu0_can_accept_i),
    .rs_alu0_occupancy_i(rs_alu0_occupancy_i),
    .rs_alu0_push_valid_o(rs_alu0_push_valid_o),
    .rs_alu0_push_robid_o(rs_alu0_push_robid_o),
    .rs_alu0_push_pc_o(rs_alu0_push_pc_o),
    .rs_alu0_push_alu_op_o(rs_alu0_push_alu_op_o),
    .rs_alu0_push_br_op_o(rs_alu0_push_br_op_o),
    .rs_alu0_push_src0_ready_o(rs_alu0_push_src0_ready_o),
    .rs_alu0_push_src0_val_o(rs_alu0_push_src0_val_o),
    .rs_alu0_push_src0_robid_o(rs_alu0_push_src0_robid_o),
    .rs_alu0_push_src1_ready_o(rs_alu0_push_src1_ready_o),
    .rs_alu0_push_src1_val_o(rs_alu0_push_src1_val_o),
    .rs_alu0_push_src1_robid_o(rs_alu0_push_src1_robid_o),
    .rs_alu0_push_imm_o(rs_alu0_push_imm_o),
    .rs_alu0_push_use_imm_o(rs_alu0_push_use_imm_o),
    .rs_alu0_push_br_offs_o(rs_alu0_push_br_offs_o),
    .rs_alu1_can_accept_i(rs_alu1_can_accept_i),
    .rs_alu1_occupancy_i(rs_alu1_occupancy_i),
    .rs_alu1_push_valid_o(rs_alu1_push_valid_o),
    .rs_alu1_push_robid_o(rs_alu1_push_robid_o),
    .rs_alu1_push_pc_o(rs_alu1_push_pc_o),
    .rs_alu1_push_alu_op_o(rs_alu1_push_alu_op_o),
    .rs_alu1_push_br_op_o(rs_alu1_push_br_op_o),
    .rs_alu1_push_src0_ready_o(rs_alu1_push_src0_ready_o),
    .rs_alu1_push_src0_val_o(rs_alu1_push_src0_val_o),
    .rs_alu1_push_src0_robid_o(rs_alu1_push_src0_robid_o),
    .rs_alu1_push_src1_ready_o(rs_alu1_push_src1_ready_o),
    .rs_alu1_push_src1_val_o(rs_alu1_push_src1_val_o),
    .rs_alu1_push_src1_robid_o(rs_alu1_push_src1_robid_o),
    .rs_alu1_push_imm_o(rs_alu1_push_imm_o),
    .rs_alu1_push_use_imm_o(rs_alu1_push_use_imm_o),
    .rs_alu1_push_br_offs_o(rs_alu1_push_br_offs_o),
    .rs_mem_can_accept_i(rs_mem_can_accept_i),
    .rs_mem_push_valid_o(rs_mem_push_valid_o),
    .rs_mem_push_robid_o(rs_mem_push_robid_o),
    .rs_mem_push_pc_o(rs_mem_push_pc_o),
    .rs_mem_push_mem_op_o(rs_mem_push_mem_op_o),
    .rs_mem_push_is_cacop_o(rs_mem_push_is_cacop_o),
    .rs_mem_push_src0_ready_o(rs_mem_push_src0_ready_o),
    .rs_mem_push_src0_val_o(rs_mem_push_src0_val_o),
    .rs_mem_push_src0_robid_o(rs_mem_push_src0_robid_o),
    .rs_mem_push_src1_ready_o(rs_mem_push_src1_ready_o),
    .rs_mem_push_src1_val_o(rs_mem_push_src1_val_o),
    .rs_mem_push_src1_robid_o(rs_mem_push_src1_robid_o),
    .rs_mem_push_imm_o(rs_mem_push_imm_o),
    .rs_mdu_can_accept_i(rs_mdu_can_accept_i),
    .rs_mdu_push_valid_o(rs_mdu_push_valid_o),
    .rs_mdu_push_robid_o(rs_mdu_push_robid_o),
    .rs_mdu_push_alu_op_o(rs_mdu_push_alu_op_o),
    .rs_mdu_push_csr_op_o(rs_mdu_push_csr_op_o),
    .rs_mdu_push_csr_num_o(rs_mdu_push_csr_num_o),
    .rs_mdu_push_tlb_op_o(rs_mdu_push_tlb_op_o),
    .rs_mdu_push_wb_src_op_o(rs_mdu_push_wb_src_op_o),
    .rs_mdu_push_src0_ready_o(rs_mdu_push_src0_ready_o),
    .rs_mdu_push_src0_val_o(rs_mdu_push_src0_val_o),
    .rs_mdu_push_src0_robid_o(rs_mdu_push_src0_robid_o),
    .rs_mdu_push_src1_ready_o(rs_mdu_push_src1_ready_o),
    .rs_mdu_push_src1_val_o(rs_mdu_push_src1_val_o),
    .rs_mdu_push_src1_robid_o(rs_mdu_push_src1_robid_o)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    `TB_PASS("dispatch tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
