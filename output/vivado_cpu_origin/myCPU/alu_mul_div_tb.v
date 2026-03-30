`timescale 1ns / 1ps
`include "cpu_defs.vh"

// ---------------------------------------------------------------------------
// 仿真 IP 说明
//
// 1) 默认（未定义 NO_IP_STUB）：编译本文件中的行为级 mult_gen_0 / div_gen_0，
//    接口与 alu.v 中例化一致，用于 iverilog 等不加载 Vivado IP 仿真库时仍能跑通，
//    且除法延迟参数 DIV_LATENCY 可与 Vivado div_gen 的 Latency 对齐（工程 xci 为 37）。
//
// 2) 使用 Vivado 生成的真实 IP 仿真模型时：
//    - 编译选项增加：+define+NO_IP_STUB
//    - 仿真文件列表加入 Vivado 为 mult_gen_0、div_gen_0 生成的仿真源（及依赖），
//      且顶层不得再定义同名 module。
//    - 若 Vivado 输出的端口位宽与 alu 中连线不一致（例如 tdata 为 40/80 位），
//      需在 alu 侧按 IP 封装做零扩展/截位后再仿真综合工程。
// ---------------------------------------------------------------------------

`ifndef NO_IP_STUB
// 与 mult_gen（33×33 有符号，1 拍流水）行为一致
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

// 与 div_gen AXI 流行为近似：握手后 DIV_LATENCY 拍出结果，{余数, 商} = tdata[63:32],[31:0]
module div_gen_0(
    input  wire        aclk,
    input  wire        s_axis_divisor_tvalid,
    input  wire [31:0] s_axis_divisor_tdata,
    input  wire        s_axis_dividend_tvalid,
    input  wire [31:0] s_axis_dividend_tdata,
    output reg         m_axis_dout_tvalid,
    output reg  [63:0] m_axis_dout_tdata
);
    parameter integer DIV_LATENCY = 37;

    reg [63:0] dout_pipe [0:DIV_LATENCY-1];
    reg        vld_pipe  [0:DIV_LATENCY-1];
    integer i;

    reg signed [31:0] s_dividend;
    reg signed [31:0] s_divisor;
    reg signed [31:0] s_quot;
    reg signed [31:0] s_rem;

    initial begin
        m_axis_dout_tvalid = 1'b0;
        m_axis_dout_tdata  = 64'b0;
        for (i = 0; i < DIV_LATENCY; i = i + 1) begin
            vld_pipe[i]  = 1'b0;
            dout_pipe[i] = 64'b0;
        end
    end

    always @(posedge aclk) begin
        for (i = DIV_LATENCY - 1; i > 0; i = i - 1) begin
            dout_pipe[i] <= dout_pipe[i-1];
            vld_pipe[i]  <= vld_pipe[i-1];
        end
        if (s_axis_divisor_tvalid & s_axis_dividend_tvalid) begin
            s_dividend = $signed(s_axis_dividend_tdata);
            s_divisor  = $signed(s_axis_divisor_tdata);
            if (s_axis_divisor_tdata == 32'b0) begin
                dout_pipe[0] <= 64'b0;
            end
            else begin
                s_quot = s_dividend / s_divisor;
                s_rem  = s_dividend % s_divisor;
                dout_pipe[0] <= {s_rem[31:0], s_quot[31:0]};
            end
            vld_pipe[0] <= 1'b1;
        end
        else begin
            vld_pipe[0]  <= 1'b0;
            dout_pipe[0] <= dout_pipe[0];
        end

        m_axis_dout_tvalid <= vld_pipe[DIV_LATENCY-1];
        m_axis_dout_tdata  <= dout_pipe[DIV_LATENCY-1];
    end
endmodule
`endif

module alu_mul_div_tb;
    localparam integer MAX_WAIT_CYCLES = 200;

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
        while (!alu_result_valid && cycle_wait < MAX_WAIT_CYCLES) begin
            @(posedge clk);
            cycle_wait = cycle_wait + 1;
        end

        if (!alu_result_valid) begin
            $display("[FAIL] %0s timeout waiting result (>%0d cycles)", case_name, MAX_WAIT_CYCLES);
            $finish;
        end

        #1;
        if (alu_result !== expected) begin
            $display("[FAIL] %0s exp=0x%08h got=0x%08h", case_name, expected, alu_result);
            $finish;
        end
        else begin
            $display("[PASS] %0s result=0x%08h (waited %0d clk edges)", case_name, alu_result, cycle_wait);
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

`ifdef NO_IP_STUB
        $display("alu_mul_div_tb: NO_IP_STUB defined — 使用 Vivado IP 仿真模型（勿与本文件内 stub 同编）");
`else
        $display("alu_mul_div_tb: 使用本文件内行为级 mult_gen_0/div_gen_0（与 alu 中 IP 接口一致，div 延迟可配）");
`endif

        run_case(op_mask(`ALU_OP_MUL_W),   32'hFFFF_FFFE, 32'h0000_0003, 32'hFFFF_FFFA, "mul.w");
        run_case(op_mask(`ALU_OP_MULH_W),  32'hFFFF_FFFF, 32'h0000_0002, 32'hFFFF_FFFF, "mulh.w");
        run_case(op_mask(`ALU_OP_MULH_WU), 32'hFFFF_FFFF, 32'h0000_0002, 32'h0000_0001, "mulh.wu");
        run_case(op_mask(`ALU_OP_DIV_W),   32'hFFFF_FFEC, 32'h0000_0003, 32'hFFFF_FFFA, "div.w");
        run_case(op_mask(`ALU_OP_DIV_WU),  32'hFFFF_FFF0, 32'h0000_0010, 32'h0FFF_FFFF, "div.wu");

        $display("ALL CASES PASSED.");
        $finish;
    end
endmodule
