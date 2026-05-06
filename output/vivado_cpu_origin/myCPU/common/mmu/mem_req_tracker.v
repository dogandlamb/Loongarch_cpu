// ============================================================
// mem_req_tracker：跟踪 MEM 槽位与 dcache 的请求/接收状态。
// - 在 addr_ok 接收前保持请求 pending；
// - 记录“已被接收但尚未完成”的状态，避免完成脉冲误配到其他事务。
// ============================================================
module mem_req_tracker (
    input  wire clk,
    input  wire reset,
    input  wire ld_in_mem,
    input  wire st_in_mem,
    input  wire addr_ok,
    input  wire data_r_complete,
    input  wire data_w_complete,
    output reg  ld_req_pending,
    output reg  st_req_pending,
    output reg  ld_req_accepted_pending,
    output reg  st_req_accepted_pending,
    output wire data_re_issue_ld,
    output wire data_we_issue_st,
    output wire data_re_accept,
    output wire data_we_accept
);

    assign data_re_issue_ld = ld_in_mem & ld_req_pending;
    assign data_we_issue_st = st_in_mem & st_req_pending;
    assign data_re_accept   = data_re_issue_ld & addr_ok;
    assign data_we_accept   = data_we_issue_st & addr_ok;

    always @(posedge clk) begin
        if (reset) begin
            ld_req_pending <= 1'b0;
            st_req_pending <= 1'b0;
            ld_req_accepted_pending <= 1'b0;
            st_req_accepted_pending <= 1'b0;
        end else begin
            // Load request pending
            if (!ld_in_mem) ld_req_pending <= 1'b0;
            else if (!ld_req_pending) ld_req_pending <= 1'b1;
            else if (data_re_accept) ld_req_pending <= 1'b0; // accepted this cycle

            // Store request pending
            if (!st_in_mem) st_req_pending <= 1'b0;
            else if (!st_req_pending) st_req_pending <= 1'b1;
            else if (data_we_accept) st_req_pending <= 1'b0; // accepted this cycle

            // Track accepted requests so completion pulses cannot be borrowed from unrelated transactions.
            if (!ld_in_mem) ld_req_accepted_pending <= 1'b0;
            else if (data_re_accept) ld_req_accepted_pending <= 1'b1;
            else if (data_r_complete) ld_req_accepted_pending <= 1'b0;

            if (!st_in_mem) st_req_accepted_pending <= 1'b0;
            else if (data_we_accept) st_req_accepted_pending <= 1'b1;
            else if (data_w_complete) st_req_accepted_pending <= 1'b0;
        end
    end

endmodule
