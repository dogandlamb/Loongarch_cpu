`include "cpu_defs.vh"

/**
 * Cache Control Unit
 * - Routes CACOP/IBAR instructions from pipeline to ICache/DCache
 * - Handles cache invalidation/cleaning
 * - Manages cache coherency
 */

module cache_control_unit (
    input  wire        clk,
    input  wire        resetn,
    
    // From pipeline WB stage
    input  wire        wb_valid,
    input  wire        wb_inst_cacop,  // CACOP instruction
    input  wire        wb_inst_ibar,   // IBAR instruction
    input  wire [1:0]  wb_cacop_op,    // CACOP operation
    input  wire [31:0] wb_cacop_addr,  // CACOP address
    input  wire [1:0]  wb_cacop_mat,   // CACOP MAT value
    input  wire [4:0]  wb_cacop_cd,    // CACOP cache descriptor (0: I-cache, 1: D-cache)
    
    // To ICache
    output wire        icache_cacop_en,
    output wire [1:0]  icache_cacop_op,
    output wire [31:0] icache_cacop_addr,
    output wire [1:0]  icache_cacop_mat,
    
    // To DCache
    output wire        dcache_cacop_en,
    output wire [1:0]  dcache_cacop_op,
    output wire [31:0] dcache_cacop_addr,
    output wire [1:0]  dcache_cacop_mat
);

    // CACOP modes (from instruction encoding)
    // cd[2:0]:
    //   0x0: I-cache address-based operation
    //   0x1: D-cache address-based operation
    //   0x8: All I-cache line invalidation
    //   0x9: All D-cache line invalidation
    
    wire is_icache_op = (wb_cacop_cd == 5'd0);
    wire is_dcache_op = (wb_cacop_cd == 5'd1);
    wire is_icache_all = (wb_cacop_cd == 5'd8);
    wire is_dcache_all = (wb_cacop_cd == 5'd9);
    
    // Routing logic
    assign icache_cacop_en = wb_valid && wb_inst_cacop && (is_icache_op || is_icache_all);
    assign dcache_cacop_en = wb_valid && wb_inst_cacop && (is_dcache_op || is_dcache_all);
    
    // CACOP operation codes (from opcode analysis)
    // op[1:0]:
    //   0b00: Index-based invalidate (or all-invalidate if cd=8/9)
    //   0b01: Hit-based invalidate
    //   0b10: Hit-based write-back (data cache only)
    
    assign icache_cacop_op = (is_icache_all && wb_cacop_op[1:0] == `CACOP_OP_IDX_INV) ? `CACOP_OP_IDX_INV :
                             (is_icache_all && wb_cacop_op[1:0] == `CACOP_OP_HIT_INV) ? `CACOP_OP_HIT_INV :
                             (is_icache_op && wb_cacop_op[1:0] == `CACOP_OP_IDX_INV) ? `CACOP_OP_IDX_INV :
                             (is_icache_op && wb_cacop_op[1:0] == `CACOP_OP_HIT_INV) ? `CACOP_OP_HIT_INV : `CACOP_OP_IDX_INV;
    
    assign dcache_cacop_op = (is_dcache_all && wb_cacop_op[1:0] == `CACOP_OP_IDX_INV) ? `CACOP_OP_IDX_INV :
                             (is_dcache_all && wb_cacop_op[1:0] == `CACOP_OP_HIT_INV) ? `CACOP_OP_HIT_INV :
                             (is_dcache_op && wb_cacop_op[1:0] == `CACOP_OP_IDX_INV) ? `CACOP_OP_IDX_INV :
                             (is_dcache_op && wb_cacop_op[1:0] == `CACOP_OP_HIT_INV) ? `CACOP_OP_HIT_INV :
                             (is_dcache_op && wb_cacop_op[1:0] == `CACOP_OP_HIT_WB) ? `CACOP_OP_HIT_WB : `CACOP_OP_IDX_INV;
    
    assign icache_cacop_addr = wb_cacop_addr;
    assign dcache_cacop_addr = wb_cacop_addr;
    assign icache_cacop_mat = wb_cacop_mat;
    assign dcache_cacop_mat = wb_cacop_mat;

endmodule
