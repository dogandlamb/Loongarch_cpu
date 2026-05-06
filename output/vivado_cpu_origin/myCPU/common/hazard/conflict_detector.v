`include "../../top/cpu_defs.vh"

// ============================================================
// conflict_detector：ID 级 rs1/rs2 与 EXE/MEM/WB 目的寄存器比较，
// 输出各级 RAW 命中，供 conflict_handle 决定是否阻塞或前递。
// ============================================================
module conflict_detector(
    input  wire [ 4:0] id_rs1,         // ID 源1
    input  wire [ 4:0] id_rs2,         // ID 源2
    input  wire [ 4:0] exe_rd,         // EXE 目的
    input  wire        exe_wb,         // EXE 是否写回
    input  wire [ 4:0] mem_rd,         // MEM 目的
    input  wire        mem_wb,         // MEM 是否写回
    input  wire [ 4:0] wb_rd,          // WB 目的
    input  wire        wb_wb,          // WB 是否写回

    input  wire        id_valid,
    input  wire [`TLB_OP_NUM-1:0] id_tlb_op,
    input  wire        id_is_CACOP,
    input  wire        exe_valid,
    input  wire [`TLB_OP_NUM-1:0] exe_tlb_op,
    input  wire        exe_is_CACOP,
    input  wire        mem_valid,
    input  wire [`TLB_OP_NUM-1:0] mem_tlb_op,
    input  wire        mem_is_CACOP,
    input  wire        wb_valid,
    input  wire [`TLB_OP_NUM-1:0] wb_tlb_op,
    input  wire        wb_is_CACOP,

    output wire        hit_exe_rs1,
    output wire        hit_mem_rs1,
    output wire        hit_wb_rs1,
    output wire        hit_exe_rs2,
    output wire        hit_mem_rs2,
    output wire        hit_wb_rs2,

    output wire        refetch_req
);

// Qualify hits with stage valid to avoid forwarding from bubbles/held registers.
assign hit_exe_rs1 = (exe_valid && exe_wb && (exe_rd != 5'd0) && (exe_rd == id_rs1));
assign hit_exe_rs2 = (exe_valid && exe_wb && (exe_rd != 5'd0) && (exe_rd == id_rs2));
assign hit_mem_rs1 = (mem_valid && mem_wb && (mem_rd != 5'd0) && (mem_rd == id_rs1));
assign hit_mem_rs2 = (mem_valid && mem_wb && (mem_rd != 5'd0) && (mem_rd == id_rs2));
assign hit_wb_rs1  = (wb_valid  && wb_wb  && (wb_rd  != 5'd0) && (wb_rd  == id_rs1));
assign hit_wb_rs2  = (wb_valid  && wb_wb  && (wb_rd  != 5'd0) && (wb_rd  == id_rs2));

wire id_need_refetch  = id_valid  && ((|id_tlb_op) || id_is_CACOP);
wire exe_need_refetch = exe_valid && ((|exe_tlb_op) || exe_is_CACOP);
wire mem_need_refetch = mem_valid && ((|mem_tlb_op) || mem_is_CACOP);
wire wb_need_refetch  = wb_valid  && ((|wb_tlb_op) || wb_is_CACOP);

assign refetch_req = id_need_refetch
                  || exe_need_refetch
                  || mem_need_refetch
                  || wb_need_refetch;

endmodule
