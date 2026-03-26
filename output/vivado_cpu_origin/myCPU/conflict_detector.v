// ============================================================
// 模块功能：
// RAW 冲突检测器。比较 ID 级两个源寄存器与 EXE/MEM/WB 级目的寄存器，
// 命中则输出 `raw_hazard`，用于顶层触发阻塞/插泡。
//
// 端口定义：
// - id_rs1/id_rs2：ID 级源寄存器地址。
// - exe_rd/mem_rd/wb_rd：各级目的寄存器地址。
// - exe_wb/mem_wb/wb_wb：各级是否会写回。
// - raw_hazard：任一级命中 RAW 冲突时置 1。
//
// 与 top 的联系：
// - 在 `mycpu_top` 中与 `raw_hazard_extra` 共同组成最终 `raw_hazard`。
// ============================================================
// 组合逻辑：ID 段源寄存器与 EXE/MEM/WB 将写回的寄存器冲突则阻塞
module conflict_detector(
    input  wire [ 4:0] id_rs1,
    input  wire [ 4:0] id_rs2,
    input  wire [ 4:0] exe_rd,
    input  wire        exe_wb,
    input  wire [ 4:0] mem_rd,
    input  wire        mem_wb,
    input  wire [ 4:0] wb_rd,
    input  wire        wb_wb,

    output wire        raw_hazard//阻塞信号
);

wire hit_exe = exe_wb && (exe_rd != 5'd0)
    && ((exe_rd == id_rs1) || (exe_rd == id_rs2));
wire hit_mem = mem_wb && (mem_rd != 5'd0)
    && ((mem_rd == id_rs1) || (mem_rd == id_rs2));
wire hit_wb  = wb_wb  && (wb_rd  != 5'd0)
    && ((wb_rd  == id_rs1) || (wb_rd  == id_rs2));

assign raw_hazard = hit_exe | hit_mem | hit_wb;

endmodule
