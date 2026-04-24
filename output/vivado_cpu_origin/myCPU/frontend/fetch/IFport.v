`include "../../common/cpu_defs.vh"

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
    input  wire        adef_valid_in,      // 地址未对齐异常信号
    input  wire [`TLB_EX_NUM-1:0] tlb_ex_valid_in, // tlb异常信号，由top tlb manager给入

    input wire refetch_tag_in,
    output wire refetch_tag_out,//其实可以当异常看，不过不影响csr

    output wire        readyGo,            // 本级可向下游提交
    output wire        allowIn,            // 对上游允许（当前常 1）

    output wire [31:0] pc_req_out,         // 透传 pc_req_in
    output wire [31:0] inst_out,           // 送 IF/ID 的指令
    output wire [31:0] pc_inst_out,        // 送 IF/ID 的 PC（与 inst_out 对齐）
    output wire        adef_valid_req_out, // 送 BRAM 的地址未对齐异常请求信号
    output wire        adef_valid_out,     // 送 IF/ID 的指令地址未对齐异常信号
    output wire        exception_valid,     // 向下传的异常有效信号（adef_valid_out//tlb）
    output wire [`TLB_EX_NUM-1:0] tlb_ex_valid_out, // 送 IF/ID 的 tlb异常信号，注意驱动exception_valid=|tlb_ex_valid_out
    output wire [31:0] tlb_vaddr_out      // 送IF/ID,其驱动与pc_inst_out有关
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
reg  [`TLB_EX_NUM-1:0] hold_tlb_ex_valid;
reg  [31:0] hold_tlb_vaddr;

wire        stale_redirect_resp;
wire        if_tlb_ex;
wire        if_ex_ok;//这拍发生取指异常，也可以往下交付
//新槽位内容
wire        new_slot_ok;
wire [31:0] new_inst;
wire [31:0] new_pc;
wire        new_adef_valid;
wire [`TLB_EX_NUM-1:0] new_tlb_ex_valid;
wire [31:0] new_tlb_vaddr;
//
wire        out_valid; 
wire [31:0] out_inst;
wire [31:0] out_pc;
wire        out_adef_valid;
wire [`TLB_EX_NUM-1:0] out_tlb_ex_valid;
wire [31:0] out_tlb_vaddr;

// For locally completed ADEF fetches, allow the response through even if
// redirect drop window is active, otherwise IF can livelock at TP51.
assign stale_redirect_resp = drop_next_resp && (pc_inst_in != redirect_pc_pending) && !adef_valid_in;
assign resp_ok   = valid && inst_valid_in && !cancel_in && !stale_redirect_resp;
// 异常返回：ADEF/TLB 取指异常不一定会有 inst_valid_in，
// 所以要允许 IF 直接构造一个异常槽位往下传。
assign if_tlb_ex = |tlb_ex_valid_in;
assign if_ex_ok  = valid && (adef_valid_in || if_tlb_ex) && !cancel_in;
// 新槽位内容。
// 异常槽位没有真实指令，inst 给 0 只是占位。
// pc/tlb_vaddr 用 pc_req_in，表示本次取指出错的虚地址。
assign new_slot_ok = resp_ok | if_ex_ok;
assign new_inst = if_ex_ok ? 32'b0 : inst_in;
assign new_pc   = if_ex_ok ? pc_req_in : pc_inst_in;
assign new_adef_valid = if_ex_ok ? adef_valid_in : 1'b0;
assign new_tlb_ex_valid = if_ex_ok ? tlb_ex_valid_in: {`TLB_EX_NUM{1'b0}};
assign new_tlb_vaddr = if_ex_ok ? pc_req_in : 32'b0;
// 输出优先发之前 hold 的槽位；没有 hold 才发本拍新槽位。
assign out_valid = hold_valid | new_slot_ok;
assign out_inst = hold_valid ? hold_inst : new_inst;
assign out_pc   = hold_valid ? hold_pc   : new_pc;
assign out_adef_valid = hold_valid ? hold_adef : new_adef_valid;
assign out_tlb_ex_valid = hold_valid ? hold_tlb_ex_valid : new_tlb_ex_valid;
assign out_tlb_vaddr = hold_valid ? hold_tlb_vaddr : new_tlb_vaddr;

always @(posedge clk) begin
    if (reset) begin
        hold_valid <= 1'b0;
        hold_inst  <= 32'b0;
        hold_pc    <= 32'b0;
        hold_adef  <= 1'b0;
        drop_next_resp <= 1'b0;
        redirect_pc_pending <= 32'b0;
        hold_tlb_ex_valid <= {`TLB_EX_NUM{1'b0}};
        hold_tlb_vaddr    <= 32'b0;
    end else if (cancel_in) begin
        hold_valid <= 1'b0;
        hold_inst  <= 32'b0;
        hold_pc    <= 32'b0;
        hold_adef  <= 1'b0;
        drop_next_resp <= 1'b1;
        redirect_pc_pending <= redirect_pc_in;
        hold_tlb_ex_valid <= {`TLB_EX_NUM{1'b0}};
        hold_tlb_vaddr    <= 32'b0;
    end else begin
        if (drop_next_resp && inst_valid_in && ((pc_inst_in == redirect_pc_pending) || adef_valid_in))
            drop_next_resp <= 1'b0;
        // 情况 1：hold 的旧槽位本拍被下游接收。
        // 如果同时又来了一个新槽位，需要继续 hold 住新槽位。
        if (hold_valid && downstream_allowIn) begin
            if (new_slot_ok) begin
                hold_valid        <= 1'b1;
                hold_inst         <= new_inst;
                hold_pc           <= new_pc;
                hold_adef         <= new_adef_valid;
                hold_tlb_ex_valid <= new_tlb_ex_valid;
                hold_tlb_vaddr    <= new_tlb_vaddr;
            end else begin
                hold_valid        <= 1'b0;
                hold_inst         <= 32'b0;
                hold_pc           <= 32'b0;
                hold_adef         <= 1'b0;
                hold_tlb_ex_valid <= {`TLB_EX_NUM{1'b0}};
                hold_tlb_vaddr    <= 32'b0;
            end
        end
        // 情况 2：当前没有 hold，但下游不接收，而本拍来了新槽位。
        // 需要把新槽位缓存起来，避免丢指令或丢异常。
        else if (!hold_valid && !downstream_allowIn && new_slot_ok) begin
            hold_valid        <= 1'b1;
            hold_inst         <= new_inst;
            hold_pc           <= new_pc;
            hold_adef         <= new_adef_valid;
            hold_tlb_ex_valid <= new_tlb_ex_valid;
            hold_tlb_vaddr    <= new_tlb_vaddr;
        end
    end
end

assign readyGo = out_valid;
assign allowIn = 1'b1;
assign pc_req_out = pc_req_in;
assign inst_out = out_valid ? out_inst : 32'b0;
assign pc_inst_out = out_valid ? out_pc : 32'b0;
assign adef_valid_out = out_valid ? out_adef_valid : 1'b0;
assign tlb_ex_valid_out = out_valid ? out_tlb_ex_valid: {`TLB_EX_NUM{1'b0}};
assign tlb_vaddr_out = out_valid ? out_tlb_vaddr : 32'b0;
assign exception_valid = out_valid? (out_adef_valid | (|out_tlb_ex_valid)): 1'b0;

endmodule
