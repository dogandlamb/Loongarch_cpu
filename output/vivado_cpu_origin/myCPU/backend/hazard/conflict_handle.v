// ============================================================
// conflict_handle：组合逻辑，汇总 RAW 相关阻塞与前递命中
// ============================================================
module conflict_handle(
    input  wire hit_exe_rs1,             // EXE 写回与 rs1 同名
    input  wire hit_mem_rs1,
    input  wire hit_wb_rs1,
    input  wire hit_exe_rs2,
    input  wire hit_mem_rs2,
    input  wire hit_wb_rs2,
    input  wire exe_stage_is_load,       // EXE 槽为 load（需阻塞至结果可用）
    input  wire mem_stage_is_load,       // MEM 槽为 load 且读未完成
    input  wire br_taken_comb,           // EXE 组合分支成立
    input  wire csr_flush,               // CSR：异常 / ERTN 等提交时冲刷流水
    output wire RAW_hazard,
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

wire hit_exe;
wire hit_mem;
wire hit_wb;

assign hit_exe = (hit_exe_rs1 == 1'b1) | (hit_exe_rs2 == 1'b1);
assign hit_mem = (hit_mem_rs1 == 1'b1) | (hit_mem_rs2 == 1'b1);
assign hit_wb  = (hit_wb_rs1  == 1'b1) | (hit_wb_rs2  == 1'b1);

assign RAW_hazard = (hit_exe & exe_stage_is_load) | (hit_mem & mem_stage_is_load) | (hit_wb ^ hit_wb);
assign block_sig  = BLOCK_MODE_ENABLE ? RAW_hazard : 1'b0;
assign stall      = BLOCK_MODE_ENABLE ? block_sig  : 1'b0;

assign FD_EXE_2rs1_sig = FD_MODE_ENABLE ? hit_exe_rs1 : 1'b0;
assign FD_MEM_2rs1_sig = FD_MODE_ENABLE ? hit_mem_rs1 : 1'b0;
assign FD_WB_2rs1_sig  = FD_MODE_ENABLE ? hit_wb_rs1  : 1'b0;
assign FD_EXE_2rs2_sig = FD_MODE_ENABLE ? hit_exe_rs2 : 1'b0;
assign FD_MEM_2rs2_sig = FD_MODE_ENABLE ? hit_mem_rs2 : 1'b0;
assign FD_WB_2rs2_sig  = FD_MODE_ENABLE ? hit_wb_rs2  : 1'b0;

wire br_cancel = (br_taken_comb == 1'b1);
assign cancel_sig = br_cancel | csr_flush;//cancel_sig = 分支命中 | csr_flush。

endmodule
