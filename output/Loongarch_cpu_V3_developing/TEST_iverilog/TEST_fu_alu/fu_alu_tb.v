`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module fu_alu_tb;
  reg  clk;
  reg  reset;
  reg  flush_i;
  reg  issue_valid_i;
  reg [`ROB_W-1:0] issue_robid_i;
  reg [31:0] issue_pc_i;
  reg [`ALU_OP_NUM-1:0] issue_alu_op_i;
  reg [`BR_OP_NUM-1:0] issue_br_op_i;
  reg [31:0] issue_src0_i;
  reg [31:0] issue_src1_i;
  reg [31:0] issue_imm_i;
  reg  issue_use_imm_i;
  reg [31:0] issue_br_offs_i;
  wire  wb_valid_o;
  wire [`ROB_W-1:0] wb_robid_o;
  wire [31:0] wb_data_o;
  wire  wb_br_taken_o;
  wire [31:0] wb_br_target_o;
  wire  early_wakeup_valid_o;
  wire [`ROB_W-1:0] early_wakeup_robid_o;
  wire  ex_redirect_valid_o;
  wire [31:0] ex_redirect_pc_o;
  fu_alu uut(
    .clk(clk),
    .reset(reset),
    .flush_i(flush_i),
    .issue_valid_i(issue_valid_i),
    .issue_robid_i(issue_robid_i),
    .issue_pc_i(issue_pc_i),
    .issue_alu_op_i(issue_alu_op_i),
    .issue_br_op_i(issue_br_op_i),
    .issue_src0_i(issue_src0_i),
    .issue_src1_i(issue_src1_i),
    .issue_imm_i(issue_imm_i),
    .issue_use_imm_i(issue_use_imm_i),
    .issue_br_offs_i(issue_br_offs_i),
    .wb_valid_o(wb_valid_o),
    .wb_robid_o(wb_robid_o),
    .wb_data_o(wb_data_o),
    .wb_br_taken_o(wb_br_taken_o),
    .wb_br_target_o(wb_br_target_o),
    .early_wakeup_valid_o(early_wakeup_valid_o),
    .early_wakeup_robid_o(early_wakeup_robid_o),
    .ex_redirect_valid_o(ex_redirect_valid_o),
    .ex_redirect_pc_o(ex_redirect_pc_o)
  );
  initial clk=0; always #5 clk=~clk;

  task set_alu_op;
    output [`ALU_OP_NUM-1:0] op;
    input integer bit_idx;
    begin
      op = {`ALU_OP_NUM{1'b0}};
      op[bit_idx] = 1'b1;
    end
  endtask

  task set_br_op;
    output [`BR_OP_NUM-1:0] op;
    input integer bit_idx;
    begin
      op = {`BR_OP_NUM{1'b0}};
      op[bit_idx] = 1'b1;
    end
  endtask

  task run_case;
    input [`ROB_W-1:0] robid;
    input [31:0] pc;
    input [`ALU_OP_NUM-1:0] alu_op;
    input [`BR_OP_NUM-1:0] br_op;
    input [31:0] src0;
    input [31:0] src1;
    input [31:0] imm;
    input use_imm;
    input [31:0] br_offs;
    input [31:0] exp_data;
    input exp_taken;
    input [31:0] exp_target;
    input [255:0] msg;
    begin
      @(negedge clk);
      issue_robid_i = robid;
      issue_pc_i = pc;
      issue_alu_op_i = alu_op;
      issue_br_op_i = br_op;
      issue_src0_i = src0;
      issue_src1_i = src1;
      issue_imm_i = imm;
      issue_use_imm_i = use_imm;
      issue_br_offs_i = br_offs;
      issue_valid_i = 1'b1;
      #1;
      `TB_CHECK(early_wakeup_valid_o && early_wakeup_robid_o == robid, "fu_alu early wakeup");

      @(posedge clk); #1;
      issue_valid_i = 1'b0;
      `TB_CHECK(wb_valid_o && wb_robid_o == robid, "fu_alu wb valid");
      `TB_CHECK(wb_data_o == exp_data &&
                wb_br_taken_o == exp_taken &&
                wb_br_target_o == exp_target, msg);

      @(posedge clk); #1;
      `TB_CHECK(!wb_valid_o, "fu_alu wb one-cycle pulse");
    end
  endtask

  reg [`ALU_OP_NUM-1:0] alu_op;
  reg [`BR_OP_NUM-1:0] br_op;

  initial begin
    flush_i=0; issue_valid_i=0; issue_robid_i=0; issue_pc_i=0;
    issue_alu_op_i=0; issue_br_op_i=0; issue_src0_i=0; issue_src1_i=0;
    issue_imm_i=0; issue_use_imm_i=0; issue_br_offs_i=0;
    reset=1; @(posedge clk); #1; reset=0;

    set_alu_op(alu_op, `ALU_OP_ADD);
    run_case(5'd1, 32'h1000, alu_op, 0,
             32'd10, 32'd0, 32'd32, 1'b1, 32'b0,
             32'd42, 1'b0, 32'b0, "fu_alu addi");

    set_br_op(br_op, `BR_OP_BL);
    run_case(5'd2, 32'h1000, 0, br_op,
             32'b0, 32'b0, 32'b0, 1'b0, 32'h20,
             32'h1004, 1'b1, 32'h1020, "fu_alu bl link");

    set_br_op(br_op, `BR_OP_JIRL);
    run_case(5'd3, 32'h1000, 0, br_op,
             32'h2003, 32'b0, 32'b0, 1'b0, 32'h4,
             32'h1004, 1'b1, 32'h2006, "fu_alu jirl target");

    set_br_op(br_op, `BR_OP_BLT);
    run_case(5'd4, 32'h3000, 0, br_op,
             32'hffff_ffff, 32'd1, 32'b0, 1'b0, 32'h10,
             32'b0, 1'b1, 32'h3010, "fu_alu signed branch");

    flush_i = 1'b1;
    @(negedge clk);
    issue_valid_i = 1'b1;
    #1;
    `TB_CHECK(!early_wakeup_valid_o, "fu_alu early gated by flush");
    @(posedge clk); #1;
    issue_valid_i = 1'b0;
    flush_i = 1'b0;
    `TB_CHECK(!wb_valid_o, "fu_alu flush kills in-flight");

    $display("ALL TESTS DONE"); $finish;
  end
endmodule
