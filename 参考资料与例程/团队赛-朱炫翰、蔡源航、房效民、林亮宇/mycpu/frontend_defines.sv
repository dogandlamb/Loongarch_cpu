`ifndef FRONTEND_DEFINES_SV
`define FRONTEND_DEFINES_SV
`include "core_defines.sv"


package frontend_defines;
    import core_defines::*;

    typedef struct packed {
        logic ftq_update_valid;
        logic ftq_ftb_dirty;
        logic [ADDR_WIDTH-1:0] jump_target;
        logic [ADDR_WIDTH-1:0] fall_through;
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;
    } ftq_updata_t;


    typedef struct packed {
        logic valid;                //FTQ块有效
        logic is_cross_cacheline;   //这个基本块中的指令是否跨缓存行
        logic [$clog2(FETCH_WIDTH+1)-1:0] length;  //应该是这个基本块中的指令条数？？？
        // BPU info：下面三条信息
        logic predicted_taken;  //预测跳转
        logic predict_valid;    //预测有效
        logic [ADDR_WIDTH-1:0] start_pc;  //32位
    } ftq_block_t;


    //后端提交的更新信息，先给FTQ然后再由FTQ给预测器
    typedef struct packed {
        logic is_branch;    //是否分支跳转
        logic [1:0] branch_type;    //分支跳转类型
        logic is_taken;             //是否真的跳转了
        logic predicted_taken;      // BPU给出的预测结果
    } backend_commit_meta_t;


    // Instruction info types
    typedef struct packed {
        // Instruction modify IF logic, any instr after it may be totaly wrong
        logic redirect;
        logic is_branch;
        logic [1:0] branch_type;
        logic is_taken;
        // Comes from BPU
        logic predecoder_redirect; // dont redirect but mispredict
        logic predicted_taken;
        logic predict_valid;  // BPU performance measurement
    } branch_info_t;


    typedef struct packed {
        // 有效位
        logic valid;
        // Exception info 
        logic ex;
        // {excp_ppi, excp_pif, excp_tlbr, excp_adef}
        logic [3:0] excp_num;

        // 指令位于前端的信息
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;   // FTQ块的索引
        logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
        logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

        // 指令具体执行信息
        branch_info_t special_info;

        // PC和指令编码
        // logic [ADDR_WIDTH-1:0] pc;
        logic [INST_WIDTH-1:0] instr;
    } instr_info_t;

    typedef struct packed {
        logic pg;
        logic da;
        logic [31: 0] dmw0;
        logic [31: 0] dmw1;
        logic [1 : 0] plv;
        logic [1 : 0] datf;
    } ifu_csr_t;

    typedef struct packed {
        logic pg;
        logic da;
        logic [31: 0] dmw0;
        logic [31: 0] dmw1;
        logic [1 : 0] plv;
        logic [1 : 0] datf;
        logic [31: 0] ex_entry;
        logic [31: 0] ertn_entry;
        logic [31: 0] tlb_entry;
    } frontend_csr_t;

endpackage

`endif
