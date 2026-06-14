// 通用仿真宏：PASS/FAIL 打印（兼容 iverilog）
`define TB_PASS(msg) $display("PASS: %s", msg)
`define TB_FAIL(msg) $display("FAIL: %s", msg)
`define TB_CHECK(cond, msg) \
    if (!(cond)) begin `TB_FAIL(msg); $finish(1); end \
    else begin `TB_PASS(msg); end
