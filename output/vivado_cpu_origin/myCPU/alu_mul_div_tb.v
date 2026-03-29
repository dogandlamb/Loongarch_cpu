`timescale 1ns / 1ps
`include "cpu_defs.vh"

module mult_gen_0(
    input  wire        CLK,
    input  wire [32:0] A,
    input  wire [32:0] B,
    output reg  [65:0] P
);
always @(posedge CLK) begin
    P <= $signed(A) * $signed(B);
end
endmodule

module div_gen_0(
    input  wire        aclk,
    input  wire        s_axis_divisor_tvalid,
    input  wire [31:0] s_axis_divisor_tdata,
    input  wire        s_axis_dividend_tvalid,
    input  wire [31:0] s_axis_dividend_tdata,
    output reg         m_axis_dout_tvalid,
    output reg  [63:0] m_axis_dout_tdata
);
reg  [3:0]   valid_pipe;
reg  [63:0]  data_pipe [0:3];
integer i;
reg signed [31:0] s_dividend;
reg signed [31:0] s_divisor;
reg signed [31:0] s_quot;
reg signed [31:0] s_rem;

initial begin
    valid_pipe = 4'b0;
    m_axis_dout_tvalid = 1'b0;
    m_axis_dout_tdata  = 64'b0;
    for (i = 0; i < 4; i = i + 1) begin
        data_pipe[i] = 64'b0;
    end
end

always @(posedge aclk) begin
    valid_pipe[0] <= s_axis_divisor_tvalid & s_axis_dividend_tvalid;
    if (s_axis_divisor_tvalid & s_axis_dividend_tvalid) begin
        s_dividend = $signed(s_axis_dividend_tdata);
        s_divisor  = $signed(s_axis_divisor_tdata);
        if (s_axis_divisor_tdata == 32'b0) begin
            data_pipe[0] <= 64'b0;
        end
        else begin
            s_quot = s_dividend / s_divisor;
            s_rem  = s_dividend % s_divisor;
            data_pipe[0] <= {s_rem[31:0], s_quot[31:0]};
        end
    end
    else begin
        data_pipe[0] <= 64'b0;
    end

    for (i = 1; i < 4; i = i + 1) begin
        valid_pipe[i] <= valid_pipe[i-1];
        data_pipe[i]  <= data_pipe[i-1];
    end

    m_axis_dout_tvalid <= valid_pipe[3];
    m_axis_dout_tdata  <= data_pipe[3];
end
endmodule

module alu_mul_div_tb;
reg                  clk;
reg  [`ALU_OP_NUM-1:0] alu_op;
reg  [31:0]          alu_src1;
reg  [31:0]          alu_src2;
wire [31:0]          alu_result;
wire                 alu_result_valid;

integer              cycle_wait;

function [`ALU_OP_NUM-1:0] op_mask;
    input integer idx;
    integer j;
begin
    op_mask = {`ALU_OP_NUM{1'b0}};
    for (j = 0; j < `ALU_OP_NUM; j = j + 1) begin
        if (j == idx) begin
            op_mask[j] = 1'b1;
        end
    end
end
endfunction

alu u_alu(
    .clk             (clk),
    .alu_op          (alu_op),
    .alu_src1        (alu_src1),
    .alu_src2        (alu_src2),
    .alu_result      (alu_result),
    .alu_result_valid(alu_result_valid)
);

always #5 clk = ~clk;

task run_case;
    input [`ALU_OP_NUM-1:0] op;
    input [31:0] src1;
    input [31:0] src2;
    input [31:0] expected;
    input [127:0] case_name;
begin
    @(negedge clk);
    alu_op   = op;
    alu_src1 = src1;
    alu_src2 = src2;

    cycle_wait = 0;
    while (!alu_result_valid && cycle_wait < 100) begin
        @(posedge clk);
        cycle_wait = cycle_wait + 1;
    end

    if (!alu_result_valid) begin
        $display("[FAIL] %0s timeout waiting result", case_name);
        $finish;
    end

    #1;
    if (alu_result !== expected) begin
        $display("[FAIL] %0s exp=0x%08h got=0x%08h", case_name, expected, alu_result);
        $finish;
    end
    else begin
        $display("[PASS] %0s result=0x%08h", case_name, alu_result);
    end

    @(posedge clk);
    alu_op = {`ALU_OP_NUM{1'b0}};
end
endtask

initial begin
    clk      = 1'b0;
    alu_op   = {`ALU_OP_NUM{1'b0}};
    alu_src1 = 32'b0;
    alu_src2 = 32'b0;

    run_case(op_mask(`ALU_OP_MUL_W),   32'hFFFF_FFFE, 32'h0000_0003, 32'hFFFF_FFFA, "mul.w");
    run_case(op_mask(`ALU_OP_MULH_W),  32'hFFFF_FFFF, 32'h0000_0002, 32'hFFFF_FFFF, "mulh.w");
    run_case(op_mask(`ALU_OP_MULH_WU), 32'hFFFF_FFFF, 32'h0000_0002, 32'h0000_0001, "mulh.wu");
    run_case(op_mask(`ALU_OP_DIV_W),   32'hFFFF_FFEC, 32'h0000_0003, 32'hFFFF_FFFA, "div.w");
    run_case(op_mask(`ALU_OP_DIV_WU),  32'hFFFF_FFF0, 32'h0000_0010, 32'h0FFF_FFFF, "div.wu");

    $display("ALL CASES PASSED.");
    $finish;
end
endmodule
