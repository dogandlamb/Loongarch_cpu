`include "../top/cpu_defs.vh"

// ============================================================
// IFport：取指级。处理 icache/mmu 返回与 IF/ID 反压。
// - 下游不能收（IF_ID_reg_allowIn=0）时：若本拍仍有有效返回，先打入 hold_*，避免丢返回。
// - cancel_in（分支冲刷/重取指）后：流水线改走新 PC（redirect_pc_in）。在 drop window 期间，
//   已在途且不匹配 redirect_pc_pending 的返回会被视为陈旧并丢弃，直到命中新目标返回后再放行。
// ============================================================
module IFport (
    // input
    // 基本输入信号：clk、reset、valid
    input  wire                   clk,
    input  wire                   reset,
    input  wire                   valid,              // IF 槽有效

    // 与bram、下游交互的输入信号（bram≈sram），流水线内部只需考虑bram，AXI交互由转接桥做
    input  wire [31:0]            pc_req_in,          // 本拍发往 BRAM 的请求 PC
    input  wire [31:0]            inst_in,            // BRAM 返回指令
    input  wire [31:0]            pc_inst_in,         // 与 inst_in 对齐的返回 PC
    input  wire [31:0]            redirect_pc_in,     // cancel 后的新目标 PC；用于判定并丢弃陈旧返回
    input  wire                   inst_valid_in,      // 本拍指令返回是否有效
    input  wire                   cancel_in,          // 本拍是否因分支冲刷/重取指，而丢弃返回的指令
    input  wire                   clr_last_resp_dedup,// 清 IF 重复返回去重窗口（refetch 后允许同 PC 新返回重新进入）
    input  wire                   downstream_allowIn, // IF/ID 是否可接收

    // 与异常有关的输入信号（算上特殊的重取指）
    input  wire                   adef_valid_in,      // 地址未对齐异常信号
    input  wire [`TLB_EX_NUM-1:0] tlb_ex_valid_in,    // IF 侧取指 TLB 异常向量（top 经 mmu 整理后给入）
    input  wire                   refetch_tag_in,     // 其实可以当异常看，不过不影响csr


    // output
    // 下游交互
    output wire                   readyGo,            // 本级可向下游提交
    output wire                   allowIn,            // 对上游允许（当前常 1）
    output wire                   filter_stall,       // IFport 丢弃旧/重复返回时，必要时反压 PC

    // 与bram交互
    output wire [31:0]            pc_req_out,         // 透传 pc_req_in
    output wire [31:0]            inst_out,           // 送 IF/ID 的指令
    output wire [31:0]            pc_inst_out,        // 送 IF/ID 的 PC（与 inst_out 对齐）

    // 与异常有关（算上特殊的重取指）
    output wire                   adef_valid_req_out, // 送 BRAM 的地址未对齐异常请求信号
    output wire                   adef_valid_out,     // 送 IF/ID 的指令地址未对齐异常信号
    output wire                   exception_valid,    // 向下传的异常有效信号（adef_valid_out或上tlb）
    output wire [`TLB_EX_NUM-1:0] tlb_ex_valid_out,   // 送 IF/ID 的 tlb异常信号，注意exception_valid要有|tlb_ex_valid_out的驱动
    output wire [31:0]            tlb_vaddr_out,      // 送 IF/ID 的异常虚地址；IF 异常槽位时取 pc_req，对正常返回为0
    output wire                   refetch_tag_out     // 送 IF/ID 的重取指信号
);

// 看这里！ 'o'
// 注意：cancel_in信号包括了分支跳转与重取指(refetch)
// 而redirect_pc_in虽然写的是redirect（重定向），但也可以是refetch（重取指）的PC或分支跳转的PC
// 注意redirect与refetch的哦！！！！！！！！

    wire                   adef_valid_req;

    wire                   resp_ok;               // 返回可用且非 cancel、非陈旧
    reg                    hold_valid;            // 已缓存一拍返回待下游接收
    reg  [31:0]            hold_inst;
    reg  [31:0]            hold_pc;
    reg                    hold_adef;
    reg                    drop_next_resp;        // 重定向后丢弃直到 pc_inst_in 对齐
    reg  [31:0]            redirect_pc_pending;   // 分支重定向目标（用于丢弃陈旧返回）
    reg  [`TLB_EX_NUM-1:0] hold_tlb_ex_valid;
    reg  [31:0]            hold_tlb_vaddr;
    reg                    hold_refetch_tag;
    reg                    last_resp_valid;
    reg  [31:0]            last_resp_pc;
    reg                    dedup_mask_once;
    reg  [1:0]             refetch_drop_guard;


    wire                   stale_redirect_resp;
    wire                   redirect_pc_match;
    wire                   cancel_redirect_pc_match;
    wire                   if_tlb_ex;
    wire                   if_ex_ok;              //这拍发生取指异常，也可以往下交付
    wire                   duplicated_resp;
    wire                   dedup_bypass_hotspot;
    wire                   cancel_redirect_resp_match;
    wire                   cancel_resp_hold;
    wire                   cancel_adef_hold;
    wire                   waiting_redirect_resp;

    //新槽位内容
    wire                   new_slot_ok;
    wire [31:0]            new_inst;
    wire [31:0]            new_pc;
    wire                   new_adef_valid;
    wire [`TLB_EX_NUM-1:0] new_tlb_ex_valid;
    wire [31:0]            new_tlb_vaddr;
    
    wire                   out_valid; 
    wire [31:0]            out_inst;
    wire [31:0]            out_pc;
    wire                   out_adef_valid;
    wire [`TLB_EX_NUM-1:0] out_tlb_ex_valid;
    wire [31:0]            out_tlb_vaddr;
    wire                   new_refetch_tag;
    wire                   out_refetch_tag;


    assign adef_valid_req = (pc_req_in[1:0] != 2'b00);
    assign adef_valid_req_out = adef_valid_req;

    // 4-state safe redirect drop:
    // Use strict equality to avoid X turning the whole handshake into X, which
    // would poison inst/pc with unknowns and break decode.
    assign redirect_pc_match = (pc_inst_in === redirect_pc_pending);
    // DMW/直映窗口下，取指返回 PC 可能与请求 PC 在高位别名（如 e000_xxxx <-> c000_xxxx），
    // 仅按全 32 位比较会导致 drop window 无法清除而卡死。
    wire redirect_pc_alias_match = (pc_inst_in[28:0] === redirect_pc_pending[28:0])
                                && (redirect_pc_pending[31:29] === 3'b111)
                                && (pc_inst_in[31:29] === 3'b110);
    wire redirect_resp_match = (redirect_pc_match === 1'b1) || (redirect_pc_alias_match === 1'b1);
    assign cancel_redirect_pc_match = (pc_inst_in === redirect_pc_in);
    wire cancel_redirect_pc_alias_match = (pc_inst_in[28:0] === redirect_pc_in[28:0])
                                       && (redirect_pc_in[31:29] === 3'b111)
                                       && (pc_inst_in[31:29] === 3'b110);
    assign cancel_redirect_resp_match = (cancel_redirect_pc_match === 1'b1) || (cancel_redirect_pc_alias_match === 1'b1);
    // cancel 同拍若已经返回重定向目标，不能再直接丢弃；先压入 hold，下一拍交付。
    assign cancel_resp_hold = (inst_valid_in === 1'b1) && (cancel_redirect_resp_match === 1'b1);
    // JIRL/分支重定向到非对齐地址时没有真实 inst_valid 返回，也必须把目标 ADEF 槽保住。
    assign cancel_adef_hold = (redirect_pc_in[1:0] === 2'b01)
                            || (redirect_pc_in[1:0] === 2'b10)
                            || (redirect_pc_in[1:0] === 2'b11);
    // drop window 等重定向目标时，目标 PC 已经发出但同步 ICache 尚未返回，需要停一拍避免顺序 PC 越过目标。
    assign waiting_redirect_resp = (drop_next_resp === 1'b1)
                                && (pc_req_in === redirect_pc_pending)
                                && (inst_valid_in !== 1'b1);
    // For locally completed ADEF fetches, allow the response through even if
    // redirect drop window is active, otherwise IF can livelock at TP51.
    assign stale_redirect_resp = (drop_next_resp === 1'b1)
                              && (inst_valid_in === 1'b1)
                              && ((refetch_drop_guard != 2'b00) || (redirect_resp_match !== 1'b1))
                              && (adef_valid_in !== 1'b1);
    // If frontend keeps re-observing the same response PC while request PC is also
    // still that value, consume it only once to avoid replaying one instruction.
    assign dedup_bypass_hotspot = 1'b0;
    assign duplicated_resp = (last_resp_valid === 1'b1)
                          && (pc_inst_in === last_resp_pc)
                          && (dedup_bypass_hotspot !== 1'b1)
                          && (dedup_mask_once !== 1'b1)
                          && (clr_last_resp_dedup !== 1'b1);// 同周期与时序 clr 对齐，避免误判 duplicate 卡住 refetch PC
    assign resp_ok   = (valid === 1'b1) && (inst_valid_in === 1'b1)
                    && (cancel_in !== 1'b1) && (stale_redirect_resp !== 1'b1)
                    && (duplicated_resp !== 1'b1);
    // 异常返回：ADEF/TLB 取指异常不一定会有 inst_valid_in，
    // 所以要允许 IF 直接构造一个异常槽位往下传。
    assign if_tlb_ex = ((|tlb_ex_valid_in) === 1'b1);
    assign if_ex_ok  = (valid === 1'b1)
                    && ((adef_valid_in === 1'b1) || (if_tlb_ex === 1'b1))
                    && (inst_valid_in !== 1'b1)
                    && (cancel_in !== 1'b1);
    // 新槽位内容。
    // 异常槽位没有真实指令，inst 给 0 只是占位。
    // pc/tlb_vaddr 用 pc_req_in，表示本次取指出错的虚地址。
    assign new_slot_ok = (resp_ok === 1'b1) || (if_ex_ok === 1'b1);
    assign new_inst = if_ex_ok ? 32'b0 : inst_in;
    assign new_pc   = if_ex_ok ? pc_req_in : pc_inst_in;
    assign new_adef_valid = if_ex_ok ? adef_valid_in : 1'b0;
    assign new_tlb_ex_valid = if_ex_ok ? tlb_ex_valid_in: {`TLB_EX_NUM{1'b0}};
    assign new_tlb_vaddr = if_ex_ok ? pc_req_in : 32'b0;
    assign new_refetch_tag = if_ex_ok ? refetch_tag_in : 1'b0;
    // 输出优先发之前 hold 的槽位；没有 hold 才发本拍新槽位。
    assign out_valid = hold_valid | new_slot_ok;
    assign out_inst = hold_valid ? hold_inst : new_inst;
    assign out_pc   = hold_valid ? hold_pc   : new_pc;
    assign out_adef_valid = hold_valid ? hold_adef : new_adef_valid;
    assign out_tlb_ex_valid = hold_valid ? hold_tlb_ex_valid : new_tlb_ex_valid;
    assign out_tlb_vaddr = hold_valid ? hold_tlb_vaddr : new_tlb_vaddr;
    assign out_refetch_tag = hold_valid ? hold_refetch_tag : new_refetch_tag;

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
            hold_refetch_tag  <= 1'b0;
            last_resp_valid   <= 1'b0;
            last_resp_pc      <= 32'b0;
            dedup_mask_once   <= 1'b0;
            refetch_drop_guard <= 2'b00;
        end else if (cancel_in) begin
            if (cancel_resp_hold || cancel_adef_hold) begin
                hold_valid <= 1'b1;
                hold_inst  <= cancel_adef_hold ? 32'b0 : inst_in;
                hold_pc    <= cancel_adef_hold ? redirect_pc_in : pc_inst_in;
                hold_adef  <= cancel_adef_hold;
                drop_next_resp <= 1'b0;
                redirect_pc_pending <= 32'b0;
                hold_tlb_ex_valid <= {`TLB_EX_NUM{1'b0}};
                hold_tlb_vaddr    <= cancel_adef_hold ? redirect_pc_in : 32'b0;
                hold_refetch_tag  <= 1'b0;
            end else begin
                hold_valid <= 1'b0;
                hold_inst  <= 32'b0;
                hold_pc    <= 32'b0;
                hold_adef  <= 1'b0;
                drop_next_resp <= 1'b1;
                redirect_pc_pending <= redirect_pc_in;
                hold_tlb_ex_valid <= {`TLB_EX_NUM{1'b0}};
                hold_tlb_vaddr    <= 32'b0;
                hold_refetch_tag  <= 1'b0;
            end
            last_resp_valid   <= 1'b0;
            last_resp_pc      <= 32'b0;
            dedup_mask_once   <= 1'b0;
            // WB refetch 合并到 cancel 时，丢弃一拍同步 ICache 的旧返回，避免旧响应提前清空 drop window。
            refetch_drop_guard <= ((refetch_tag_in === 1'b1)
                                && (cancel_resp_hold !== 1'b1)
                                && (cancel_adef_hold !== 1'b1)) ? 2'b01 : 2'b00;
        end else begin
            if (refetch_drop_guard != 2'b00) begin
                refetch_drop_guard <= refetch_drop_guard - 2'b01;
            end
            dedup_mask_once <= (clr_last_resp_dedup === 1'b1);
            if ((clr_last_resp_dedup === 1'b1) || (dedup_mask_once === 1'b1) || (refetch_tag_in === 1'b1)) begin
                last_resp_valid <= 1'b0;
                last_resp_pc      <= 32'b0;
            end else if (resp_ok === 1'b1) begin
                last_resp_valid <= 1'b1;
                last_resp_pc    <= pc_inst_in;
            end else if ((last_resp_valid === 1'b1) && (inst_valid_in === 1'b1) && (pc_inst_in !== last_resp_pc)) begin
                // Unlock dedup window once a different response PC shows up.
                last_resp_valid <= 1'b0;
            end
            // 保护计数归零后，收到重定向目标返回（或 ADEF 返回）再关闭 drop。
            if ((drop_next_resp === 1'b1)
                && (inst_valid_in === 1'b1)
                && (refetch_drop_guard == 2'b00)
                && (redirect_resp_match || (adef_valid_in === 1'b1))) begin
                drop_next_resp <= 1'b0;
                redirect_pc_pending <= 32'b0;
            end
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
                    hold_refetch_tag  <= new_refetch_tag;
                end else begin
                    hold_valid        <= 1'b0;
                    hold_inst         <= 32'b0;
                    hold_pc           <= 32'b0;
                    hold_adef         <= 1'b0;
                    hold_tlb_ex_valid <= {`TLB_EX_NUM{1'b0}};
                    hold_tlb_vaddr    <= 32'b0;
                    hold_refetch_tag  <= 1'b0;
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
                hold_refetch_tag  <= new_refetch_tag;
            end
        end
    end

    assign readyGo = out_valid;
    assign allowIn = 1'b1;
    assign filter_stall = (stale_redirect_resp === 1'b1)
                        || (waiting_redirect_resp === 1'b1)
                        || ((duplicated_resp === 1'b1) && (pc_req_in !== pc_inst_in));
    assign pc_req_out = pc_req_in;
    assign inst_out = out_valid ? out_inst : 32'b0;
    assign pc_inst_out = out_valid ? out_pc : 32'b0;
    assign adef_valid_out = out_valid ? out_adef_valid : 1'b0;
    assign tlb_ex_valid_out = out_valid ? out_tlb_ex_valid: {`TLB_EX_NUM{1'b0}};
    assign tlb_vaddr_out = out_valid ? out_tlb_vaddr : 32'b0;
    assign exception_valid = out_valid? (out_adef_valid | (|out_tlb_ex_valid)): 1'b0;
    assign refetch_tag_out = out_valid ? out_refetch_tag : 1'b0;

endmodule
