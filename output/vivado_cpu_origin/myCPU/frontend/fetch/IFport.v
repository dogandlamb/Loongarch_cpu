// ============================================================
// IFport：取指级。处理 BRAM 返回与 IF/ID 反压。
// - 下游不能收（IF_ID_reg_allowIn=0）时：若本拍仍有有效返回，先打入 hold_*，避免丢返回。
// - cancel_in（分支冲刷）后：流水线改走新 PC（redirect_pc_in）。已在途、但 pc_inst_in 仍等于
//   「冲刷前旧目标」的返回会被视为陈旧：stale_redirect_resp=1，本拍 resp_ok=0，从而丢弃该指令，
//   直到 BRAM 返回的 pc_inst_in 与 redirect_pc_pending（锁存的 nextpc）一致后再接受新流。
// ============================================================
module IFport (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,              // IF 槽有效

    input  wire [31:0] pc_req_in,          // 本拍发往 BRAM 的请求 PC
    input  wire [31:0] inst_in,            // BRAM 返回指令
    input  wire [31:0] pc_inst_in,         // 与 inst_in 对齐的返回 PC
    input  wire [31:0] redirect_pc_in,     // 分支重定向目标（用于丢弃陈旧返回）
    input  wire        inst_valid_in,      // 本拍返回是否有效
    input  wire        cancel_in,          // 本拍是否因分支丢弃返回
    input  wire        downstream_allowIn, // IF/ID 是否可接收
    input  wire        adef_valid_in,      //地址未对齐异常信号

    output wire        readyGo,            // 本级可向下游提交
    output wire        allowIn,            // 对上游允许（当前常 1）

    output wire [31:0] pc_req_out,         // 透传 pc_req_in
    output wire [31:0] inst_out,           // 送 IF/ID 的指令
    output wire [31:0] pc_inst_out,        // 送 IF/ID 的 PC（与 inst_out 对齐）
    output wire        adef_valid_req_out, // 送 BRAM 的地址未对齐异常请求信号
    output wire        adef_valid_out,     // 送 IF/ID 的指令地址未对齐异常信号
    output wire        exception_valid     // 向下传的异常有效信号（目前仅 adef_valid_out）
);
wire        adef_valid_req;
assign      adef_valid_req = (pc_req_in[1:0] != 2'b00);
assign      adef_valid_req_out = adef_valid_req;


wire        resp_ok;                       // 返回可用且非 cancel、非陈旧
reg         hold_valid;                    // 已缓存一拍返回待下游接收
reg  [31:0] hold_inst;
reg  [31:0] hold_pc;
reg         hold_adef;
reg         drop_next_resp;                // 重定向后丢弃直到 pc_inst_in 对齐
reg  [31:0] redirect_pc_pending;           // 分支重定向目标（用于丢弃陈旧返回）
wire        out_valid; 
wire [31:0] out_inst;
wire [31:0] out_pc;
wire        out_adef_valid;
wire        stale_redirect_resp;

assign stale_redirect_resp = drop_next_resp && (pc_inst_in != redirect_pc_pending);
assign resp_ok   = valid && inst_valid_in && !cancel_in && !stale_redirect_resp;
assign out_valid = hold_valid | resp_ok;
assign out_inst  = hold_valid ? hold_inst : inst_in;
assign out_pc    = hold_valid ? hold_pc   : pc_inst_in;
assign out_adef_valid = hold_valid ? hold_adef : adef_valid_in;

always @(posedge clk) begin
    if (reset) begin
        hold_valid <= 1'b0;
        hold_inst  <= 32'b0;
        hold_pc    <= 32'b0;
        hold_adef  <= 1'b0;
        drop_next_resp <= 1'b0;
        redirect_pc_pending <= 32'b0;
    end else if (cancel_in) begin
        hold_valid <= 1'b0;
        hold_inst  <= 32'b0;
        hold_pc    <= 32'b0;
        hold_adef  <= 1'b0;
        drop_next_resp <= 1'b1;
        redirect_pc_pending <= redirect_pc_in;
    end else begin
        if (drop_next_resp && inst_valid_in && (pc_inst_in == redirect_pc_pending))
            drop_next_resp <= 1'b0;
        if (hold_valid && downstream_allowIn) begin
            if (resp_ok) begin
                hold_valid <= 1'b1;
                hold_inst  <= inst_in;
                hold_pc    <= pc_inst_in;
                hold_adef  <= adef_valid_in;
            end else begin
                hold_valid <= 1'b0;
            end
        end
        else if (!hold_valid && !downstream_allowIn && resp_ok) begin
            hold_valid <= 1'b1;
            hold_inst  <= inst_in;
            hold_pc    <= pc_inst_in;
            hold_adef  <= adef_valid_in;
        end
    end
end

wire ifport_dbg_hit = 1'b0;

always @(posedge clk) begin
    if (!reset && ifport_dbg_hit) begin
        $display("IFPDBG t=%0t cancel=%0d drop=%0d redir=0x%08h pc_req=0x%08h pc_inst=0x%08h inst_v=%0d resp_ok=%0d stale=%0d hold_v=%0d out_v=%0d down_allow=%0d",
                 $time, cancel_in, drop_next_resp, redirect_pc_in, pc_req_in, pc_inst_in,
                 inst_valid_in, resp_ok, stale_redirect_resp, hold_valid, out_valid, downstream_allowIn);
    end
end

assign readyGo = out_valid;
assign allowIn = 1'b1;

assign pc_req_out   = pc_req_in;
assign inst_out     = out_valid ? out_inst : 32'b0;
assign pc_inst_out  = out_valid ? out_pc   : 32'b0;
assign adef_valid_out = out_valid ? out_adef_valid : 1'b0;
assign exception_valid = out_valid ? out_adef_valid : 1'b0;

endmodule
