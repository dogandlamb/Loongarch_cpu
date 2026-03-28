// ============================================================
// 模块功能：
// RAW 冲突检测器。比较 ID 级两个源寄存器与 EXE/MEM/WB 级目的寄存器，
// 命中则输出 `raw_hazard`，用于顶层触发阻塞/插泡。
//
// 端口定义：
// - id_rs1/id_rs2：ID 级源寄存器地址。
// - exe_rd/mem_rd/memwb_rd/wb_rd：各级目的寄存器地址。
// - exe_wb/mem_wb/memwb_wb/wb_wb：各级是否会写回。
// - hit_exe:执行阶段冲突。
// - hit_mem:访存阶段冲突
// - hit_wb: 写回阶段冲突(rs1与源1冲突)
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
    input  wire [ 4:0] memwb_rd,
    input  wire        memwb_wb,
    input  wire [ 4:0] wb_rd,
    input  wire        wb_wb,

    output wire        hit_exe_rs1,//阻塞信号
    output wire        hit_mem_rs1,
    output wire        hit_wb_rs1,
    output wire        hit_exe_rs2,
    output wire        hit_mem_rs2,
    output wire        hit_wb_rs2
);

assign hit_exe_rs1 = exe_wb && (exe_rd != 5'd0) && (exe_rd == id_rs1);
assign hit_exe_rs2 = exe_wb && (exe_rd != 5'd0) && (exe_rd == id_rs2);
assign hit_mem_rs1 = mem_wb && (mem_rd != 5'd0) && (mem_rd == id_rs1);
assign hit_mem_rs2 = mem_wb && (mem_rd != 5'd0) && (mem_rd == id_rs2);
// wire hit_memwb = memwb_wb && (memwb_rd != 5'd0)
//     && ((memwb_rd == id_rs1) || (memwb_rd == id_rs2));看不懂，先注释了
assign hit_wb_rs1  = wb_wb  && (wb_rd  != 5'd0) && (wb_rd  == id_rs1);
assign hit_wb_rs1  = wb_wb  && (wb_rd  != 5'd0) && (wb_rd  == id_rs1);

endmodule
