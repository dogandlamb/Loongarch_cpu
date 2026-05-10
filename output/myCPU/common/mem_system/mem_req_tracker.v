// ============================================================
// mem_req_tracker：跟踪 MEM 槽位与 dcache 的请求/接收状态。
// - 在 addr_ok 接收前保持请求 pending；
// - 记录“已被接收但尚未完成”的状态，避免完成脉冲误配到其他事务。
// ============================================================
module mem_req_tracker (
    input  wire clk,
    input  wire reset,
    input  wire slot_tag,
    input  wire ld_in_mem,
    input  wire st_in_mem,
    input  wire ld_addr_ok,
    input  wire st_addr_ok,
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

    reg ld_req_slot_tag;
    reg st_req_slot_tag;

    wire ld_req_active = ld_req_pending | ld_req_accepted_pending;
    wire st_req_active = st_req_pending | st_req_accepted_pending;
    wire ld_new_slot   = ld_in_mem & (!ld_req_active | (slot_tag != ld_req_slot_tag));
    wire st_new_slot   = st_in_mem & (!st_req_active | (slot_tag != st_req_slot_tag));

    assign data_re_issue_ld = ld_in_mem & ld_req_pending & (slot_tag == ld_req_slot_tag);
    assign data_we_issue_st = st_in_mem & st_req_pending & (slot_tag == st_req_slot_tag);
    assign data_re_accept   = data_re_issue_ld & ld_addr_ok;
    assign data_we_accept   = data_we_issue_st & st_addr_ok;

    always @(posedge clk) begin
        if (reset) begin
            ld_req_pending <= 1'b0;
            st_req_pending <= 1'b0;
            ld_req_accepted_pending <= 1'b0;
            st_req_accepted_pending <= 1'b0;
            ld_req_slot_tag <= 1'b0;
            st_req_slot_tag <= 1'b0;
        end else begin
            // Keep one request per MEM slot. After addr_ok accepts it, do not
            // re-raise pending until EXE/MEM presents a different slot tag.
            if (!ld_in_mem) begin
                ld_req_pending <= 1'b0;
            end else if (ld_new_slot) begin
                ld_req_slot_tag <= slot_tag;
                ld_req_pending <= 1'b1;
            end else if (data_re_accept) begin
                ld_req_pending <= 1'b0;
            end else if (!ld_req_pending && !ld_req_accepted_pending) begin
                ld_req_pending <= 1'b1;
            end

            if (!st_in_mem) begin
                st_req_pending <= 1'b0;
            end else if (st_new_slot) begin
                st_req_slot_tag <= slot_tag;
                st_req_pending <= 1'b1;
            end else if (data_we_accept) begin
                st_req_pending <= 1'b0;
            end else if (!st_req_pending && !st_req_accepted_pending) begin
                st_req_pending <= 1'b1;
            end

            // Track accepted requests so completion pulses cannot be borrowed from unrelated transactions.
            if (!ld_in_mem) begin
                ld_req_accepted_pending <= 1'b0;
            end else if (ld_new_slot) begin
                ld_req_accepted_pending <= 1'b0;
            end else if (data_r_complete) begin
                ld_req_accepted_pending <= 1'b0;
            end else if (data_re_accept) begin
                ld_req_accepted_pending <= 1'b1;
            end

            if (!st_in_mem) begin
                st_req_accepted_pending <= 1'b0;
            end else if (st_new_slot) begin
                st_req_accepted_pending <= 1'b0;
            end else if (data_w_complete) begin
                st_req_accepted_pending <= 1'b0;
            end else if (data_we_accept) begin
                st_req_accepted_pending <= 1'b1;
            end
        end
    end

endmodule
