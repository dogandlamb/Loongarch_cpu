// ============================================================
// 模块功能：
// 冲突控制汇总模块。统一组合生成：
// - raw_hazard：综合 RAW 冲突
// - block_sig ：流水阻塞主信号
// - stall     ：插泡控制（当前等价 block_sig）
// - cancel_sig：分支冲刷信号
//
// 端口定义：
// - raw_hazard_in ：来自 conflict_detector 的 RAW 冲突。
// - br_taken_comb ：EXE 组合分支命中。
// - raw_hazard    ：综合 RAW 冲突输出（当前透传 raw_hazard_in）。
// - block_sig     ：阻塞主信号。
// - stall         ：阻塞插泡信号。
// - cancel_sig    ：冲刷信号（组合分支命中）。
//
// 与 top 的联系：
// - 在 `mycpu_top` 中替代原先分散的 assign 组合逻辑，便于控制逻辑集中维护。
// ============================================================
module conflict_handle(
    input  wire raw_hazard_in,
    input  wire br_taken_comb,
    output wire raw_hazard,
    output wire block_sig,
    output wire stall,
    output wire cancel_sig
);

assign raw_hazard = raw_hazard_in;
assign block_sig  = raw_hazard;
assign stall      = block_sig;
assign cancel_sig = br_taken_comb;

endmodule
