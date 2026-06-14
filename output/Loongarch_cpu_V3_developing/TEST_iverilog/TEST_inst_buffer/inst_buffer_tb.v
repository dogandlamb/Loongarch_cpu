`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"

module inst_buffer_tb;
    reg clk, reset, flush;
    reg p0v,p1v,p2v,p3v;
    reg [31:0] p0pc,p1pc,p2pc,p3pc,p0inst,p1inst,p2inst,p3inst;
    reg pop0r, pop1r;
    wire cp;
    wire o0v,o1v;
    wire [31:0] o0pc,o1pc,o0inst,o1inst;

    inst_buffer uut(
        .clk(clk), .reset(reset), .flush_i(flush),
        .push0_valid_i(p0v), .push0_pc_i(p0pc), .push0_inst_i(p0inst),
        .push0_pred_taken_i(1'b0), .push0_is_last_i(1'b0),
        .push0_ftq_id_i(3'd1), .push0_excp_i(15'b0),
        .push1_valid_i(p1v), .push1_pc_i(p1pc), .push1_inst_i(p1inst),
        .push1_pred_taken_i(1'b0), .push1_is_last_i(1'b0),
        .push1_ftq_id_i(3'd1), .push1_excp_i(15'b0),
        .push2_valid_i(p2v), .push2_pc_i(p2pc), .push2_inst_i(p2inst),
        .push2_pred_taken_i(1'b0), .push2_is_last_i(1'b0),
        .push2_ftq_id_i(3'd1), .push2_excp_i(15'b0),
        .push3_valid_i(p3v), .push3_pc_i(p3pc), .push3_inst_i(p3inst),
        .push3_pred_taken_i(1'b0), .push3_is_last_i(1'b0),
        .push3_ftq_id_i(3'd1), .push3_excp_i(15'b0),
        .can_push_o(cp),
        .pop0_valid_o(o0v), .pop0_pc_o(o0pc), .pop0_inst_o(o0inst),
        .pop0_pred_taken_o(), .pop0_is_last_o(), .pop0_ftq_id_o(), .pop0_excp_o(),
        .pop0_ready_i(pop0r),
        .pop1_valid_o(o1v), .pop1_pc_o(o1pc), .pop1_inst_o(o1inst),
        .pop1_pred_taken_o(), .pop1_is_last_o(), .pop1_ftq_id_o(), .pop1_excp_o(),
        .pop1_ready_i(pop1r)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset=1; flush=0; p0v=0; p1v=0; p2v=0; p3v=0; pop0r=0; pop1r=0;
        @(posedge clk); reset=0;
        p0v=1; p0pc=32'h1000; p0inst=32'h1;
        p1v=1; p1pc=32'h1004; p1inst=32'h2;
        @(posedge clk); p0v=0; p1v=0;
        pop0r=1; pop1r=1;
        @(posedge clk); pop0r=0; pop1r=0; #1;
        `TB_CHECK(o0v && o1v && (o0inst==32'h1) && (o1inst==32'h2), "push2 pop2");

        flush=1; @(posedge clk); flush=0; @(posedge clk); #1;
        `TB_CHECK(!o0v && !o1v, "flush clears buffer");

        $display("ALL TESTS DONE");
        $finish;
    end
endmodule
