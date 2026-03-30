// ============================================================
// 模块功能：
// 冲突控制汇总模块。统一组合生成：
// - hit_exe   : 执行阶段冲突
// - hit_mem   : 访存阶段冲突
// - hit_wb    : 访存阶段冲突
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
// - FD_EXE_sig    : EXE阶段数据前递信号
// - FD_MEM_sig    : MEM阶段数据前递信号       
// - FD_WB_sig     : WB阶段数据前递信号
//
// 与 top 的联系：
// - 在 `mycpu_top` 中替代原先分散的 assign 组合逻辑，便于控制逻辑集中维护。
// ============================================================
//todo:注释还没有完全修改，待修改
module conflict_handle(
    input  wire hit_exe_rs1,
    input  wire hit_mem_rs1,
    input  wire hit_wb_rs1,
    input  wire hit_exe_rs2,
    input  wire hit_mem_rs2,
    input  wire hit_wb_rs2,
    // MEM 级为 load 时不能把 em_result 当数据前递，必须阻塞到数据就绪
    input  wire mem_stage_is_load,
    input  wire br_taken_comb,
    output wire raw_hazard,
    output wire block_sig,
    output wire stall,
    output wire cancel_sig,
    output wire FD_EXE_2rs1_sig,
    output wire FD_MEM_2rs1_sig,
    output wire FD_WB_2rs1_sig,
    output wire FD_EXE_2rs2_sig,
    output wire FD_MEM_2rs2_sig,
    output wire FD_WB_2rs2_sig
);

parameter BLOCK_MODE_ENABLE = 1'b1;
parameter FD_MODE_ENABLE    = 1'b1;

wire hit_exe = (hit_exe_rs1 === 1'b1) | (hit_exe_rs2 === 1'b1);
wire hit_mem = (hit_mem_rs1 === 1'b1) | (hit_mem_rs2 === 1'b1);
wire hit_wb  = (hit_wb_rs1  === 1'b1) | (hit_wb_rs2  === 1'b1);

// EXE 级 RAW 必须阻塞；MEM 级 load 不能以前递地址冒充数据，亦需阻塞；非 load 的 MEM 仍走前递
assign raw_hazard = hit_exe | (hit_mem & mem_stage_is_load);
assign block_sig  = BLOCK_MODE_ENABLE ? raw_hazard : 1'b0;
assign stall      = BLOCK_MODE_ENABLE ? block_sig  : 1'b0;

assign FD_EXE_2rs1_sig = FD_MODE_ENABLE ? hit_exe_rs1 : 1'b0;
assign FD_MEM_2rs1_sig = FD_MODE_ENABLE ? hit_mem_rs1 : 1'b0;
assign FD_WB_2rs1_sig  = FD_MODE_ENABLE ? hit_wb_rs1  : 1'b0;
assign FD_EXE_2rs2_sig = FD_MODE_ENABLE ? hit_exe_rs2 : 1'b0;
assign FD_MEM_2rs2_sig = FD_MODE_ENABLE ? hit_mem_rs2 : 1'b0;
assign FD_WB_2rs2_sig  = FD_MODE_ENABLE ? hit_wb_rs2  : 1'b0;

assign cancel_sig = (br_taken_comb === 1'b1);

endmodule
