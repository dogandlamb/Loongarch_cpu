`ifndef TLB_DEFINES_SV
`define TLB_DEFINES_SV

`include "core_defines.sv"

package tlb_types;
    import core_defines::*;

    // Frontend -> TLB
    typedef struct packed {
        logic [31:0] inst_vaddr;
        logic inst_addr_trans_en;
        logic dmw0_en;
        logic dmw1_en;
    } inst_tlb_t;

    typedef struct packed {
        logic         tlb_found;
        logic         tlb_v;
        logic         tlb_d;
        logic [1 : 0] tlb_mat;
        logic [1 : 0] tlb_plv;
        logic [19: 0] tlb_trans_tag;
    } tlb_inst_t;

endpackage
`endif