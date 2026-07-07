`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module fu_mdu_tb;
  reg  clk;
  reg  reset;
  reg  flush_i;
  reg  issue_valid_i;
  reg [`ROB_W-1:0] issue_robid_i;
  reg [`ALU_OP_NUM-1:0] issue_alu_op_i;
  reg [`CSR_OP_NUM-1:0] issue_csr_op_i;
  reg [13:0] issue_csr_num_i;
  reg [`TLB_OP_NUM-1:0] issue_tlb_op_i;
  reg [`WB_SRC_NUM-1:0] issue_wb_src_op_i;
  reg [31:0] issue_src0_i;
  reg [31:0] issue_src1_i;
  wire  mdu_ready_o;
  wire [13:0] csr_raddr_o;
  reg [31:0] csr_rdata_i;
  reg [63:0] timer_64_i;
  reg [31:0] csr_tid_i;
  wire  wb_valid_o;
  wire [`ROB_W-1:0] wb_robid_o;
  wire [31:0] wb_data_o;
  wire [31:0] wb_data2_o;
  fu_mdu uut(
    .clk(clk),
    .reset(reset),
    .flush_i(flush_i),
    .issue_valid_i(issue_valid_i),
    .issue_robid_i(issue_robid_i),
    .issue_alu_op_i(issue_alu_op_i),
    .issue_csr_op_i(issue_csr_op_i),
    .issue_csr_num_i(issue_csr_num_i),
    .issue_tlb_op_i(issue_tlb_op_i),
    .issue_wb_src_op_i(issue_wb_src_op_i),
    .issue_src0_i(issue_src0_i),
    .issue_src1_i(issue_src1_i),
    .mdu_ready_o(mdu_ready_o),
    .csr_raddr_o(csr_raddr_o),
    .csr_rdata_i(csr_rdata_i),
    .timer_64_i(timer_64_i),
    .csr_tid_i(csr_tid_i),
    .wb_valid_o(wb_valid_o),
    .wb_robid_o(wb_robid_o),
    .wb_data_o(wb_data_o),
    .wb_data2_o(wb_data2_o)
  );
  initial clk=0; always #5 clk=~clk;

  task run_case;
    input [`ROB_W-1:0] robid;
    input [`ALU_OP_NUM-1:0] alu_op;
    input [`CSR_OP_NUM-1:0] csr_op;
    input [13:0] csr_num;
    input [`TLB_OP_NUM-1:0] tlb_op;
    input [`WB_SRC_NUM-1:0] wb_src_op;
    input [31:0] src0;
    input [31:0] src1;
    input [31:0] exp_data;
    input [31:0] exp_data2;
    input integer max_wait;
    input [255:0] msg;
    integer k;
    reg got;
    begin
      @(negedge clk);
      `TB_CHECK(mdu_ready_o, "fu_mdu ready before issue");
      issue_robid_i = robid;
      issue_alu_op_i = alu_op;
      issue_csr_op_i = csr_op;
      issue_csr_num_i = csr_num;
      issue_tlb_op_i = tlb_op;
      issue_wb_src_op_i = wb_src_op;
      issue_src0_i = src0;
      issue_src1_i = src1;
      issue_valid_i = 1'b1;

      @(posedge clk); #1;
      issue_valid_i = 1'b0;
      got = 1'b0;
      for (k = 0; k < max_wait; k = k + 1) begin
        if (!got) begin
          if (wb_valid_o) begin
            got = 1'b1;
            `TB_CHECK(wb_robid_o == robid, "fu_mdu wb robid");
            `TB_CHECK(wb_data_o == exp_data && wb_data2_o == exp_data2, msg);
          end else begin
            @(posedge clk); #1;
          end
        end
      end
      `TB_CHECK(got, "fu_mdu wb observed");
      @(posedge clk); #1;
      `TB_CHECK(!wb_valid_o, "fu_mdu wb one-cycle pulse");
    end
  endtask

  task set_alu_op;
    output [`ALU_OP_NUM-1:0] op;
    input integer bit_idx;
    begin
      op = {`ALU_OP_NUM{1'b0}};
      op[bit_idx] = 1'b1;
    end
  endtask

  task set_csr_op;
    output [`CSR_OP_NUM-1:0] op;
    input integer bit_idx;
    begin
      op = {`CSR_OP_NUM{1'b0}};
      op[bit_idx] = 1'b1;
    end
  endtask

  task set_wb_src;
    output [`WB_SRC_NUM-1:0] op;
    input integer bit_idx;
    begin
      op = {`WB_SRC_NUM{1'b0}};
      op[bit_idx] = 1'b1;
    end
  endtask

  task set_tlb_op;
    output [`TLB_OP_NUM-1:0] op;
    input integer bit_idx;
    begin
      op = {`TLB_OP_NUM{1'b0}};
      op[bit_idx] = 1'b1;
    end
  endtask

  reg [`ALU_OP_NUM-1:0] alu_op;
  reg [`CSR_OP_NUM-1:0] csr_op;
  reg [`WB_SRC_NUM-1:0] wb_src_op;
  reg [`TLB_OP_NUM-1:0] tlb_op;

  initial begin
    flush_i=0; issue_valid_i=0; issue_robid_i=0; issue_alu_op_i=0;
    issue_csr_op_i=0; issue_csr_num_i=0; issue_tlb_op_i=0;
    issue_wb_src_op_i=0; issue_src0_i=0; issue_src1_i=0;
    csr_rdata_i=32'h1234_5678; timer_64_i=64'h8877_6655_4433_2211;
    csr_tid_i=32'hcaf0_0001;
    reset=1; @(posedge clk); #1; reset=0;

    set_alu_op(alu_op, `ALU_OP_MULH_W);
    run_case(5'd3, alu_op, 0, 14'h0, 0, 0,
             32'hffff_ffff, 32'd2, 32'hffff_ffff, 32'b0, 12,
             "fu_mdu mulh.w signed");

    set_alu_op(alu_op, `ALU_OP_MULH_WU);
    run_case(5'd4, alu_op, 0, 14'h0, 0, 0,
             32'hffff_ffff, 32'd2, 32'h0000_0001, 32'b0, 12,
             "fu_mdu mulh.wu unsigned");

    set_alu_op(alu_op, `ALU_OP_DIV_W);
    run_case(5'd5, alu_op, 0, 14'h0, 0, 0,
             32'hffff_fff9, 32'd3, 32'hffff_fffe, 32'b0, 40,
             "fu_mdu div.w signed");

    set_alu_op(alu_op, `ALU_OP_MOD_W);
    run_case(5'd6, alu_op, 0, 14'h0, 0, 0,
             32'hffff_fff9, 32'd3, 32'hffff_ffff, 32'b0, 40,
             "fu_mdu mod.w signed");

    set_csr_op(csr_op, `CSR_OP_CSRWR);
    run_case(5'd7, 0, csr_op, 14'h12, 0, 0,
             32'b0, 32'hdead_beef, 32'h1234_5678, 32'hdead_beef, 4,
             "fu_mdu csrwr old/new");
    `TB_CHECK(csr_raddr_o == 14'h12, "fu_mdu csr raddr held");

    set_csr_op(csr_op, `CSR_OP_CSRXCHG);
    csr_rdata_i = 32'haaaa_5555;
    run_case(5'd8, 0, csr_op, 14'h13, 0, 0,
             32'h00ff_00ff, 32'h1234_5678,
             32'haaaa_5555,
             ((32'haaaa_5555 & ~32'h00ff_00ff) | (32'h1234_5678 & 32'h00ff_00ff)),
             4, "fu_mdu csrxchg");

    set_wb_src(wb_src_op, `WB_SRC_CNTVH);
    run_case(5'd9, 0, 0, 14'h0, 0, wb_src_op,
             32'b0, 32'b0, 32'h8877_6655, 32'b0, 4,
             "fu_mdu rdcntvh");

    set_tlb_op(tlb_op, `TLB_OP_INVTLB_5);
    run_case(5'd10, 0, 0, 14'h0, tlb_op, 0,
             32'h0000_03ab, 32'h8765_4321, 32'b0,
             32'h8765_43ab, 4,
             "fu_mdu invtlb pack");

    set_wb_src(wb_src_op, `WB_SRC_ALU);
    run_case(5'd11, 0, 0, 14'h0, 0, wb_src_op,
             32'd1, 32'b0, 32'h0001_f1f4, 32'b0, 4,
             "fu_mdu cpucfg");

    $display("ALL TESTS DONE"); $finish;
  end
endmodule
