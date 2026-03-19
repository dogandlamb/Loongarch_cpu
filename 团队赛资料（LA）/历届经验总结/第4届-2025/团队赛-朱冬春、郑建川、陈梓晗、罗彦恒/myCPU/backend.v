`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"

module backend (
    input wire clk,
    input wire rst,

    // from outer
    input wire [7:0] is_hwi,


    // 鏉ヨ嚜鍓嶇鐨勪俊锟�???
    input wire [31:0] pc_i1,
    input wire [31:0] pc_i2,
    input wire [31:0] inst_i1,
    input wire [31:0] inst_i2,
    input wire [1:0] valid_i,                           // 鍓嶇浼狅拷?锟界殑鏁版嵁鏈夋晥淇″彿
    input wire [1:0] pre_is_branch_taken_i,             // 鍓嶇浼狅拷?锟界殑鍒嗘敮棰勬祴缁撴灉
    input wire [31:0] pre_branch_addr_i1,          // 鍓嶇浼狅拷?锟界殑鍒嗘敮棰勬祴鐩爣鍦板�?
    input wire [31:0] pre_branch_addr_i2,

    input wire [1:0] is_exception1_i,              // 鍓嶇浼狅拷?锟界殑寮傚父鏍囧�?
    input wire [1:0] is_exception2_i,
    input wire [6:0] pc_exception_cause1_i,     // 寮傚父鍘熷洜
    input wire [6:0] pc_exception_cause2_i,
    input wire [6:0] instbuffer_exception_cause1_i,
    input wire [6:0] instbuffer_exception_cause2_i,

    input wire bpu_flush,      // 鍒嗘敮棰勬祴閿欒锛屾竻绌鸿瘧鐮�?槦鍒楋紙杩欎釜娌＄敤鍒帮紵锛燂級

    input wire [31:0] paddr,    // to difftest


/*****************************
    杩欎釜鎴戜滑娌℃�?
    // to pc
    output wire   is_interrupt,
    */
    output [31:0] new_pc,
    


      // 杈撳嚭缁欏墠绔殑淇″彿
    output wire [1:0]  ex_bpu_is_bj,     // 涓ゆ潯鎸囦护鏄惁鏄烦杞寚锟�???
    output wire [31:0] ex_pc1,            // ex 闃舵锟�??? pc 
    output wire [31:0] ex_pc2,
    output wire [1:0]  ex_valid,
    output wire [1:0]  ex_bpu_taken_or_not_actual,       // 涓ゆ潯鎸囦护瀹為檯鏄惁璺宠�?
    output wire  [31:0] ex_bpu_branch_actual_addr1,  //  涓ゆ潯鎸囦护瀹為檯璺宠浆鍦板�?
    output wire  [31:0] ex_bpu_branch_actual_addr2,
    output wire  [31:0] ex_bpu_branch_pred_addr1,    // 涓ゆ潯鎸囦护棰勬祴璺宠浆鍦板�?
    output wire  [31:0] ex_bpu_branch_pred_addr2,
    output wire get_data_req_o,     // 杈撳嚭缁欏墠绔殑鍙栨寚璇锋�?

    // 鍜宼lb鐨勬帴锟�???
    input wire         data_tlb_found,
    input wire [ 4:0]  data_tlb_index,
    input wire         data_tlb_v,
    input wire         data_tlb_d,
    input wire [ 1:0]  data_tlb_mat,          
    input wire [ 1:0]  data_tlb_plv,
    input wire [31:0] tlbehi_in,
    input wire [31:0] tlbelo0_in,
    input wire [31:0] tlbelo1_in,
    input wire [31:0] tlbidx_in,
    input wire [ 9:0] asid_in,
    input wire  inst_tlb_found,
    input wire  inst_tlb_v,
    input wire  inst_tlb_d,
    input wire [ 1:0] inst_tlb_mat,
    input wire [ 1:0] inst_tlb_plv,
    output wire [18:0] invtlb_vpn,
    output wire [9:0]  invtlb_asid,
    output wire invtlb,
    output wire tlbfill,
    output wire tlbwr,
    output wire [4:0]invtlb_op,
    output wire [31:0] tlbehi_out,
    output wire [31:0] tlbelo0_out,
    output wire [31:0] tlbelo1_out,
    output wire [31:0] tlbidx_out,
    output wire [5:0] ecode_out,
    output wire [9:0] asid_out,
    output wire [4:0] rand_index,
    output wire is_tlbsrch,


    output wire [31:0] csr_dmw0,    
    output wire [31:0] csr_dmw1,       
    output wire csr_da,
    output wire csr_pg,
    output wire [1:0] csr_plv,
    output wire [1:0] csr_datf,
    output wire [1:0] csr_datm,  

    // dcache 杩斿洖鐨勪俊锟�??
    output wire [4:0]  is_exception_execute1,

    input wire [31:0] rdata_i,
    input wire rdata_valid_i,      
    input wire sc_cancel_to_backend,   
    input wire uncache_i,      
    input wire dcache_pause_i,              
    input wire dcache_is_exception_i,
    input wire [6:0] dcache_exception_cause_i,
    // input wire [31:0] physical_addr_i,          //杩欎釜涓嶇煡閬撴帴Dcahce鐨勫摢涓俊锟�??
    
    // 杈撳嚭缁檇cache鐨勪俊锟�???
    output wire ren_o,
    output wire [3:0] wstrb_o,
    output wire [31:0] virtual_addr_o,
    output wire [31:0] wdata_o,
    output wire writen_o,
    output wire llw_to_dcache,
    output wire scw_to_dcache,

    // 锟�?? ctrl 杈撳嚭鐨勪俊锟�??
    output wire [7:0] flush_o,
    output wire [7:0] pause_o ,

    // cacop
    output wire icacop_en,
    output wire dcacop_en,
    output wire [1:0]  cacop_mode,
    output wire [31:0] cache_cacop_vaddr,


    //debug
    output wire debug_wb_valid1,
    output wire debug_wb_valid2,
    output wire debug_wb_we1,
    output wire debug_wb_we2,
    output wire [31:0] debug_pc1,
    output wire [31:0] debug_pc2,
    output wire [31:0] debug_inst1,
    output wire [31:0] debug_inst2,
    output wire [4:0] debug_reg_addr1,
    output wire [4:0] debug_reg_addr2,
    output wire [31:0] debug_wdata1,
    output wire [31:0] debug_wdata2


    `ifdef DIFF
    ,
    // difftest
    output wire [63:0] stable_counter,
    output wire [`DIFF_WIDTH-1:0] diff0,
    output wire [`DIFF_WIDTH-1:0] diff1,

    output wire [31:0] regs_diff[31:0],

    output wire [31:0] csr_crmd_diff,
    output wire [31:0] csr_prmd_diff,
    output wire [31:0] csr_ectl_diff,
    output wire [31:0] csr_estat_diff,
    output wire [31:0] csr_era_diff,
    output wire [31:0] csr_badv_diff,
    output wire [31:0] csr_eentry_diff,
    output wire [31:0] csr_tlbidx_diff,
    output wire [31:0] csr_tlbehi_diff,
    output wire [31:0] csr_tlbelo0_diff,
    output wire [31:0] csr_tlbelo1_diff,
    output wire [31:0] csr_asid_diff,
    output wire [31:0] csr_save0_diff,
    output wire [31:0] csr_save1_diff,
    output wire [31:0] csr_save2_diff,
    output wire [31:0] csr_save3_diff,
    output wire [31:0] csr_tid_diff,
    output wire [31:0] csr_tcfg_diff,
    output wire [31:0] csr_tval_diff,
    output wire [31:0] csr_ticlr_diff,
    output wire [31:0] csr_llbctl_diff,
    output wire [31:0] csr_tlbrentry_diff,
    output wire [31:0] csr_dmw0_diff,
    output wire [31:0] csr_dmw1_diff,
    output wire [31:0] csr_pgdl_diff,
    output wire [31:0] csr_pgdh_diff
    `endif
);

    /*************************

    assign pause_request.pause_buffer = pause_buffer;
    assign pause_decoder = pause_request.pause_decoder;

    **************************/

    assign ex_valid = valid_dispatch;

    // cnt
    wire [63:0] cnt;

    // difftest
    `ifdef DIFF
        wire [`DIFF_WIDTH-1:0] wb_diff0_i;
        wire [`DIFF_WIDTH-1:0] wb_diff1_i;
        wire [`DIFF_WIDTH-1:0] wb_diff0_o;
        wire [`DIFF_WIDTH-1:0] wb_diff1_o;
        assign stable_counter = count_64_o1;
    `endif

    // reg_files
    wire [31:0] reg_read_data1_1; //瀵勫瓨鍣ㄨ鏁版�?
    wire [31:0] reg_read_data1_2;
    wire [31:0] reg_read_data2_1;
    wire [31:0] reg_read_data2_2;

    wire [1:0] reg_write_en;            // 瀵勫瓨鍣ㄥ啓浣胯�?
    wire [4:0] reg_write_addr1;
    wire [4:0] reg_write_addr2;
    wire [31:0] reg_write_data1;
    wire [31:0] reg_write_data2;

    // csr
    wire [1:0] csr_read_en;             // csr 璇讳娇锟�???
    wire  csr_write_en;            // csr鍐欎娇锟�???
    wire [13:0] csr_read_addr1;
    wire [13:0] csr_read_addr2;
    wire [13:0] csr_write_addr ;        // csr 鍐欏湴锟�???
    wire [31:0] csr_read_data1;
    wire [31:0] csr_read_data2;
    wire [31:0] csr_write_data ;        // csr 鍐欐暟锟�???
    wire is_llw_scw_ctrl;               // 鏄惁锟�??? llw/scw 鎸囦�?
    // csr to ctrl
    wire [31:0] csr_eentry;         //寮傚父鍏ュ彛鍦板�?
    wire [31:0] csr_era;            //寮傚父杩斿洖鍦板�?
    wire [31:0] csr_crmd;           //鎺у埗瀵勫瓨锟�??? 
    wire [31:0] csr_tlbrentry;
    wire csr_is_interrupt;
    wire tlbsrch;
    wire tlbrd;
    wire tlb_found;
    wire [4:0] tlb_index;


    // ctrl
    wire pause_buffer;
    wire pause_decoder;
    wire pause_dispatch;
    wire pause_execute;
    wire pause_mem;
    wire branch_flush;
    wire [31:0] branch_addr;
    wire ex_excep_flush;            // 鎵ц闃舵寮傚父锟�?? flush 淇�?�彿

    wire csr_is_exception; //鏄惁鏄紓锟�??
    wire [6:0]  csr_exception_cause; //寮傚父鍘熷洜
    wire [31:0] csr_exception_pc; //寮傚父PC鍦板�?
    wire [31:0] csr_exception_addr; //寮傚父鍦板潃
    wire [5:0]  csr_ecode; //寮傚父ecode
    wire [8:0] csr_esubcode; //寮傚父�?�愮�?
    wire csr_is_ertn;
    wire csr_is_tlb_exception;
    wire csr_is_inst_tlb_exception;




    // decoder
    wire [31:0] pc_decoder1;
    wire [31:0] pc_decoder2;
    wire [31:0] inst_decoder1;
    wire [31:0] inst_decoder2;
    wire [2:0]  is_exception_decoder1;
    wire [2:0]  is_exception_decoder2;
    wire [6:0] pc_exception_cause_decoder1 ;
    wire [6:0] pc_exception_cause_decoder2 ;
    wire [6:0] instbuffer_exception_cause_decoder1;
    wire [6:0] instbuffer_exception_cause_decoder2;
    wire [6:0] decoder_exception_cause_decoder1;
    wire [6:0] decoder_exception_cause_decoder2;
    wire [1:0] is_privilege_decoder;
    wire [1:0] is_cnt_decoder;
    wire [1:0] valid_decoder;
    wire [7:0] aluop_decoder1;
    wire [7:0] aluop_decoder2;
    wire [2:0] alusel_decoder1;
    wire [2:0] alusel_decoder2;
    wire [31:0] imm_decoder1;
    wire [31:0] imm_decoder2;
    wire [1:0]  is_div_decoder;
    wire [1:0]  is_mul_decoder;
    wire [4:0] invtlb_op_decoder1;
    wire [4:0] invtlb_op_decoder2;
    wire [1:0] reg_read_en_decoder1;
    wire [1:0] reg_read_en_decoder2;
    wire [1:0] reg_write_en_decoder;
    wire [4:0] reg_read_addr_decoder1_1;
    wire [4:0] reg_read_addr_decoder1_2;
    wire [4:0] reg_read_addr_decoder2_1;
    wire [4:0] reg_read_addr_decoder2_2;
    wire [4:0] reg_write_addr_decoder1;
    wire [4:0] reg_write_addr_decoder2;
    wire [1:0] csr_read_en_decoder;
    wire [1:0] csr_write_en_decoder;
    wire [13:0] csr_addr_decoder1;
    wire [13:0] csr_addr_decoder2;
    wire [1:0] pre_is_branch_taken_decoder;
    wire [31:0] pre_branch_addr_decoder1;
    wire [31:0] pre_branch_addr_decoder2;


    // dispatch
    wire [1:0] reg_write_en_ex_pf;
    wire [4:0] reg_write_addr_ex_pf1;
    wire [4:0] reg_write_addr_ex_pf2;
    wire [31:0] reg_write_data_ex_pf1;
    wire [31:0] reg_write_data_ex_pf2;
    wire [1:0] reg_write_en_mem_pf;
    wire [4:0] reg_write_addr_mem_pf1;
    wire [4:0] reg_write_addr_mem_pf2;
    wire [31:0] reg_write_data_mem_pf1;
    wire [31:0] reg_write_data_mem_pf2;
    wire [1:0] reg_write_en_wb_pf;
    wire [4:0] reg_write_addr_wb_pf1;
    wire [4:0] reg_write_addr_wb_pf2;
    wire [31:0] reg_write_data_wb_pf1;
    wire [31:0] reg_write_data_wb_pf2;
    wire [7:0] pre_ex_aluop1;
    wire [7:0] pre_ex_aluop2;
    wire [31:0] pc_dispatch1;
    wire [31:0] pc_dispatch2;
    wire [31:0] inst_dispatch1;
    wire [31:0] inst_dispatch2;
    wire [1:0] valid_dispatch;
    wire [3:0]  is_exception_dispatch1;
    wire [3:0]  is_exception_dispatch2;
    wire [6:0] pc_exception_cause_dispatch1 ;
    wire [6:0] pc_exception_cause_dispatch2 ;
    wire [6:0] instbuffer_exception_cause_dispatch1;
    wire [6:0] instbuffer_exception_cause_dispatch2;
    wire [6:0] decoder_exception_cause_dispatch1;
    wire [6:0] decoder_exception_cause_dispatch2;
    wire [6:0] dispatch_exception_cause_dispatch1;
    wire [6:0] dispatch_exception_cause_dispatch2;
    wire [1:0] is_privilege_dispatch;
    wire       icacop_en_dispatch1;
    wire       icacop_en_dispatch2;
    wire       dcacop_en_dispatch1;
    wire       dcacop_en_dispatch2;
    wire [4:0] cacop_opcode_dispatch1;
    wire [4:0] cacop_opcode_dispatch2;
    wire [7:0] aluop_dispatch1;
    wire [7:0] aluop_dispatch2;
    wire [2:0] alusel_dispatch1;
    wire [2:0] alusel_dispatch2;
    wire [1:0] is_div_dispatch;
    wire [1:0] is_mul_dispatch;
    wire [31:0] reg_data_dispatch1_1;
    wire [31:0] reg_data_dispatch1_2;
    wire [31:0] reg_data_dispatch2_1;
    wire [31:0] reg_data_dispatch2_2;
    wire [1:0] reg_write_en_dispatch;                // 瀵勫瓨鍣ㄥ啓浣胯�?
    wire [4:0] reg_write_addr_dispatch1;
    wire [4:0] reg_write_addr_dispatch2;
    wire [31:0] csr_read_data_dispatch1;
    wire [31:0] csr_read_data_dispatch2;
    wire [1:0] csr_write_en_dispatch;              // csr鍐欎娇锟�???
    wire [13:0] csr_addr_dispatch1;
    wire [13:0] csr_addr_dispatch2;
    wire [4:0] invtlb_op_dispatch1;
    wire [4:0] invtlb_op_dispatch2;
    wire [1:0] pre_is_branch_taken_dispatch;     // 棰勬祴鍒嗘敮鎸囦护鏄惁璺宠�?
    wire [31:0] pre_branch_addr_dispatch1;
    wire [31:0] pre_branch_addr_dispatch2;
    wire [1:0] invalid_en_dispatch;



    // execute
    wire [31:0] pc_execute1;
    wire [31:0] pc_execute2;
    wire [63:0] count_64_execute1;
    wire [63:0] count_64_execute2;
    wire [31:0] inst_execute1;
    wire [31:0] inst_execute2;
    wire [4:0]  is_exception_execute2;
    wire [6:0] pc_exception_cause_execute1 ;
    wire [6:0] pc_exception_cause_execute2 ;
    wire [6:0] instbuffer_exception_cause_execute1;
    wire [6:0] instbuffer_exception_cause_execute2;
    wire [6:0] decoder_exception_cause_execute1;
    wire [6:0] decoder_exception_cause_execute2;
    wire [6:0] dispatch_exception_cause_execute1;
    wire [6:0] dispatch_exception_cause_execute2;
    wire [6:0] execute_exception_cause_execute1;
    wire [6:0] execute_exception_cause_execute2;
    wire [1:0] is_privilege_execute;
    wire [1:0] is_ertn_execute;
    wire [1:0] is_idle_execute;
    wire [1:0] valid_execute;
    wire [1:0] reg_write_en_execute;
    wire [4:0] reg_write_addr_execute1;
    wire [4:0] reg_write_addr_execute2;
    wire [31:0] reg_write_data_execute1;
    wire [31:0] reg_write_data_execute2;
    wire [7:0] aluop_execute1;
    wire [7:0] aluop_execute2;
    wire [31:0] addr_execute1;
    wire [31:0] addr_execute2;
    wire [31:0] data_execute1;
    wire [31:0] data_execute2;
    wire [1:0] csr_write_en_execute;
    wire [13:0] csr_addr_execute1;
    wire [13:0] csr_addr_execute2;
    wire [31:0] csr_write_data_execute1;
    wire [31:0] csr_write_data_execute2;
    wire [1:0] is_llw_scw_execute;  
    wire is_llw_execute;
    wire is_scw_execute;
    wire [1:0] icacop_en_execute;
    wire [18:0] ex_invtlb_vpn;
    wire [9:0]  ex_invtlb_asid;
    wire ex_invtlb;
    wire ex_tlbrd;
    wire ex_tlbfill;
    wire ex_tlbwr;
    wire ex_tlbsrch;
    wire [4:0]ex_invtlb_op;
    wire [31:0] ex_st_write_data1;
    wire [31:0] ex_st_write_data2;


    // mem
    wire [31:0] pc_mem1;
    wire [31:0] pc_mem2;
    wire [63:0] count_64_mem1;
    wire [63:0] count_64_mem2;
    wire [5:0]  is_exception_mem1;
    wire [5:0]  is_exception_mem2;
    wire [6:0] pc_exception_cause_mem1 ;
    wire [6:0] pc_exception_cause_mem2 ;
    wire [6:0] instbuffer_exception_cause_mem1;
    wire [6:0] instbuffer_exception_cause_mem2;
    wire [6:0] decoder_exception_cause_mem1;
    wire [6:0] decoder_exception_cause_mem2;
    wire [6:0] dispatch_exception_cause_mem1;
    wire [6:0] dispatch_exception_cause_mem2;
    wire [6:0] execute_exception_cause_mem1;
    wire [6:0] execute_exception_cause_mem2;
    wire [6:0] commit_exception_cause_mem1;
    wire [6:0] commit_exception_cause_mem2;
    wire [1:0] is_privilege_mem;
    wire [1:0] is_ertn_mem;
    wire [1:0] is_idle_mem;
    wire [1:0] valid_mem;
    wire [1:0] reg_write_en_mem;
    wire [4:0] reg_write_addr_mem1;
    wire [4:0] reg_write_addr_mem2;
    wire [31:0] reg_write_data_mem1;
    wire [31:0] reg_write_data_mem2;
    wire [1:0] csr_write_en_mem;
    wire [13:0] csr_write_addr_mem1;
    wire [13:0] csr_write_addr_mem2;
    wire [31:0] csr_write_data_mem1;
    wire [13:0] csr_write_data_mem2;
    wire [1:0] is_llw_scw_mem;
    wire is_llw_mem;
    wire [31:0] addr_mem1;
    wire [31:0] addr_mem2;
    wire [1:0] icacop_en_mem;
    wire [18:0] mem_invtlb_vpn;
    wire [9:0]  mem_invtlb_asid;
    wire mem_invtlb;
    wire mem_tlbrd;
    wire mem_tlbfill;
    wire mem_tlbwr;
    wire mem_tlbsrch;
    wire [4:0]mem_invtlb_op;
    wire mem_tlb_found;
    wire [4:0] mem_tlb_index;


    // wb
    wire [31:0] pc_wb1;
    wire [31:0] pc_wb2;
    wire [63:0] count_64_wb1;
    wire [63:0] count_64_wb2;
    wire [31:0] refetch_target_pc_wb;
    wire [5:0]  is_exception_wb1;
    wire [5:0]  is_exception_wb2;
    wire [6:0] pc_exception_cause_wb1 ;
    wire [6:0] pc_exception_cause_wb2 ;
    wire [6:0] instbuffer_exception_cause_wb1;
    wire [6:0] instbuffer_exception_cause_wb2;
    wire [6:0] decoder_exception_cause_wb1;
    wire [6:0] decoder_exception_cause_wb2;
    wire [6:0] dispatch_exception_cause_wb1;
    wire [6:0] dispatch_exception_cause_wb2;
    wire [6:0] execute_exception_cause_wb1;
    wire [6:0] execute_exception_cause_wb2;
    wire [6:0] commit_exception_cause_wb1;
    wire [6:0] commit_exception_cause_wb2;
    wire [1:0] is_privilege_wb;
    wire [1:0] icacop_en_wb;
    wire [1:0] is_ertn_wb;
    wire [1:0] is_idle_wb;
    wire [1:0] valid_wb;
    wire [1:0] reg_write_en_wb;
    wire [4:0] reg_write_addr_wb1;
    wire [4:0] reg_write_addr_wb2;
    wire [31:0] reg_write_data_wb1;
    wire [31:0] reg_write_data_wb2;
    wire [1:0] csr_write_en_wb;
    wire [13:0] csr_write_addr_wb1;
    wire [13:0] csr_write_addr_wb2;
    wire [31:0] csr_write_data_wb1;
    wire [31:0] csr_write_data_wb2;
    wire [1:0] is_llw_scw_wb;
    wire llbit_write_wb;
    wire [31:0] addr_wb [1:0];
    wire [31:0] addr_wb1;
    wire [31:0] addr_wb2;
    wire [18:0] wb_invtlb_vpn;
    wire [9:0]  wb_invtlb_asid;
    wire wb_invtlb;
    wire wb_tlbrd;
    wire wb_tlbfill;
    wire wb_tlbwr;
    wire wb_tlbsrch;
    wire [4:0]wb_invtlb_op;
    wire wb_tlb_found;
    wire [4:0] wb_tlb_index;


    wire [1:0] sort_to_dispatch;
    decoder u_decoder (
        .clk(clk),
        .rst(rst),

        .flush(flush_o[3]),

        .pc1(pc_i1),
        .pc2(pc_i2),
        .inst1(inst_i1),
        .inst2(inst_i2),
        .valid(valid_i),        
        .pretaken(pre_is_branch_taken_i),
        .pre_addr_in1(pre_branch_addr_i1) ,
        .pre_addr_in2(pre_branch_addr_i2) ,
        .is_exception_in1(is_exception1_i) ,
        .is_exception_in2(is_exception2_i) ,
        .pc_exception_cause_in1(pc_exception_cause1_i) ,
        .pc_exception_cause_in2(pc_exception_cause2_i) ,
        .instbuffer_exception_cause_in1(instbuffer_exception_cause1_i) ,
        .instbuffer_exception_cause_in2(instbuffer_exception_cause2_i) ,
        .invalid_en(invalid_en_dispatch),

        .get_data_req(get_data_req_o),
        .dispatch_id_valid(valid_decoder),
        .dispatch_pc_out1(pc_decoder1) ,
        .dispatch_pc_out2(pc_decoder2) ,
        .is_exception_o1(is_exception_decoder1) ,
        .is_exception_o2(is_exception_decoder2) ,
        .pc_exception_cause_o1(pc_exception_cause_decoder1) ,
        .pc_exception_cause_o2(pc_exception_cause_decoder2) ,
        .instbuffer_exception_cause_o1(instbuffer_exception_cause_decoder1) ,
        .instbuffer_exception_cause_o2(instbuffer_exception_cause_decoder2) ,
        .decoder_exception_cause_o1(decoder_exception_cause_decoder1) ,
        .decoder_exception_cause_o2(decoder_exception_cause_decoder2) ,
        .dispatch_inst_out1(inst_decoder1) ,
        .dispatch_inst_out2(inst_decoder2) ,
        .dispatch_aluop1(aluop_decoder1) ,
        .dispatch_aluop2(aluop_decoder2),
        .dispatch_alusel1(alusel_decoder1) ,
        .dispatch_alusel2(alusel_decoder2),
        .dispatch_imm1(imm_decoder1) ,
        .dispatch_imm2(imm_decoder2),
        .dispatch_is_div(is_div_decoder),
        .dispatch_is_mul(is_mul_decoder),
        .dispatch_reg_read_en1(reg_read_en_decoder1),  
        .dispatch_reg_read_en2(reg_read_en_decoder2),   
        .dispatch_reg_read_addr1_1(reg_read_addr_decoder1_1) ,
        .dispatch_reg_read_addr1_2(reg_read_addr_decoder1_2),
        .dispatch_reg_read_addr2_1(reg_read_addr_decoder2_1) ,
        .dispatch_reg_read_addr2_2(reg_read_addr_decoder2_2),
        .dispatch_reg_writen_en(reg_write_en_decoder),  
        .dispatch_reg_write_addr1(reg_write_addr_decoder1) ,
        .dispatch_reg_write_addr2(reg_write_addr_decoder2),
        .dispatch_id_pre_taken(pre_is_branch_taken_decoder),
        .dispatch_id_pre_addr1(pre_branch_addr_decoder1),
        .dispatch_id_pre_addr2(pre_branch_addr_decoder2),
        .dispatch_is_privilege(is_privilege_decoder), 
        .dispatch_csr_read_en(csr_read_en_decoder), 
        .dispatch_csr_write_en(csr_write_en_decoder),
        .dispatch_csr_addr1(csr_addr_decoder1),
        .dispatch_csr_addr2(csr_addr_decoder2), 
        .dispatch_is_cnt(is_cnt_decoder), 
        .dispatch_invtlb_op1(invtlb_op_decoder1),
        .dispatch_invtlb_op2(invtlb_op_decoder2),
        .pause_decoder(pause_decoder),
        .sort(sort_to_dispatch)
    );

    wire pause_to_dispatch = pause_o[4];
    wire pause_to_dispatch_ex_pause = pause_o[5];
    wire flush_to_dispatch = flush_o[4];

    wire sort1_to_ex;
    wire sort2_to_ex;

    dispatch u_dispatch (
        .clk(clk),
        .rst(rst),

    //鎺у埗鍗曞厓鐨勬殏鍋滃拰鍒锋柊淇�?�彿
        .pause(pause_to_dispatch),//pause_o[4]    //鍙戝皠鍣ㄦ殏鍋滀俊锟�???,褰撳彂鐢焞oad-use鍐掗櫓鏃堕渶瑕佹殏锟�???  
        .flush(flush_to_dispatch),//flush_o[4]    //鍙戝皠鍣ㄥ埛鏂颁俊锟�???,褰撳彂鐢熷垎�?娴嬮敊璇椂锟�??瑕佸埛锟�???

    // 鏉ヨ嚜decoder鐨勪俊锟�???
        .pc1_i(pc_decoder1),      //鎸囦护鍦板潃
        .pc2_i(pc_decoder2),
        .sort1_o(sort1_to_ex),
        .sort2_o(sort2_to_ex),
        .sort_i(sort_to_dispatch),

        .inst1_i(inst_decoder1),    //鎸囦护缂栫爜
        .inst2_i(inst_decoder2),
        .valid_i(valid_decoder),   //鎸囦护鏈夋晥鏍囧�?

        .is_exception_i1(is_exception_decoder1), //涓ゆ潯鎸囦护鐨勫紓甯告爣锟�??
        .is_exception_i2(is_exception_decoder2),
        .pc_exception_cause_i1(pc_exception_cause_decoder1), //涓ゆ潯鎸囦护鐨勫紓甯稿師锟�??,浼氬彉锟�???
        .pc_exception_cause_i2(pc_exception_cause_decoder2),
        .instbuffer_exception_cause_i1(instbuffer_exception_cause_decoder1), //涓ゆ潯鎸囦护鐨勫紓甯稿師锟�??,浼氬彉锟�???
        .instbuffer_exception_cause_i2(instbuffer_exception_cause_decoder2),
        .decoder_exception_cause_i1(decoder_exception_cause_decoder1), //涓ゆ潯鎸囦护鐨勫紓甯稿師锟�??,浼氬彉锟�???
        .decoder_exception_cause_i2(decoder_exception_cause_decoder2),

        .is_privilege_i(is_privilege_decoder), //涓ゆ潯鎸囦护鐨勭壒鏉冩寚浠ゆ爣锟�???
        .is_cnt_i(is_cnt_decoder),       //涓ゆ潯鎸囦护鐨勮鏁板櫒鎸囦护鏍囧織

        .alu_op_i1(aluop_decoder1),  //ALU鎿嶄綔锟�???
        .alu_op_i2(aluop_decoder2),
        .alu_sel_i1(alusel_decoder1), //ALU鍔熻兘閫夋嫨
        .alu_sel_i2(alusel_decoder2),
        .imm_i1(imm_decoder1),     //绔嬪嵆鏁帮拷??
        .imm_i2(imm_decoder2),

        .is_div_i(is_div_decoder),       //涓ゆ潯鎸囦护鐨勯櫎娉曟寚浠ゆ爣锟�???
        .is_mul_i(is_mul_decoder),       //涓ゆ潯鎸囦护鐨勯櫎娉曟寚浠ゆ爣锟�???

        .invtlb_op_i1(invtlb_op_decoder1),   //涓ゆ潯鎸囦护鐨勫垎鏀寚浠ゆ爣锟�???
        .invtlb_op_i2(invtlb_op_decoder2),
        
        .reg_read_en_i1(reg_read_en_decoder1),     //锟�??0鏉℃寚浠ょ殑涓や釜婧愬瘎瀛樺櫒婧愬瘎瀛樺櫒璇讳娇锟�??
        .reg_read_en_i2(reg_read_en_decoder2),     //锟�??1鏉℃寚浠ょ殑涓や釜婧愬瘎瀛樺櫒婧愬瘎瀛樺櫒璇讳娇锟�??   
        .reg_read_addr_i1_1(reg_read_addr_decoder1_1),  
        .reg_read_addr_i1_2(reg_read_addr_decoder1_2),
        .reg_read_addr_i2_1(reg_read_addr_decoder2_1),   
        .reg_read_addr_i2_2(reg_read_addr_decoder2_2),
        
        .reg_write_en_i(reg_write_en_decoder),    //鐨勫瘎�?�樺櫒鍐欎娇锟�??
        .reg_write_addr_i1(reg_write_addr_decoder1),  //鐩殑�?�勫瓨鍣ㄥ湴锟�??
        .reg_write_addr_i2(reg_write_addr_decoder2),

        .csr_read_en_i(csr_read_en_decoder),//csr鍐欎娇锟�???
        .csr_addr_i1(csr_addr_decoder1),
        .csr_addr_i2(csr_addr_decoder2),
        .csr_write_en_i(csr_write_en_decoder),//csrcsr鍐欐暟锟�???
        .pre_is_branch_taken_i(pre_is_branch_taken_decoder),// //鍓嶄竴鏉℃寚浠ゆ槸鍚︽槸鍒嗘敮鎸囦护
        .pre_branch_addr_i1(pre_branch_addr_decoder1), //鍓嶄竴鏉℃寚浠ょ殑鍒嗘敮鍦板�?
        .pre_branch_addr_i2(pre_branch_addr_decoder2),


        // 鏉ヨ嚜ex鍜宮em鐨勫墠閫掓暟锟�??
        .ex_pf_write_en(reg_write_en_ex_pf),     //浠巈x闃舵鍓嶏拷?锟藉嚭鏉ョ殑浣胯�?
        .ex_pf_write_addr1(reg_write_addr_ex_pf1),   //浠巈x闃舵鍓嶏拷?锟藉嚭鏉ョ殑鍦板�?
        .ex_pf_write_addr2(reg_write_addr_ex_pf2),
        .ex_pf_write_data1(reg_write_data_ex_pf1),   //浠巈x闃舵鍓嶏拷?锟藉嚭鏉ョ殑鏁版�?
        .ex_pf_write_data2(reg_write_data_ex_pf2),

        .mem_pf_write_en(reg_write_en_mem_pf),    //浠巑em闃舵鍓嶏拷?锟藉嚭鏉ョ殑浣胯�?
        .mem_pf_write_addr1(reg_write_addr_mem_pf1),  //浠巑em闃舵鍓嶏拷?锟藉嚭鏉ョ殑鍦板�?
        .mem_pf_write_addr2(reg_write_addr_mem_pf2),
        .mem_pf_write_data1(reg_write_data_mem1),
        .mem_pf_write_data2(reg_write_data_mem2),  //浠巑em闃舵鍓嶏拷?锟藉嚭鏉ョ殑鏁版�?

        .wb_pf_write_en(reg_write_en_wb_pf),     //浠巜b闃舵鍓嶏拷?锟藉嚭鏉ョ殑浣胯�?
        .wb_pf_write_addr1(reg_write_addr_wb_pf1),   //浠巜b闃舵鍓嶏拷?锟藉嚭鏉ョ殑鍦板�?
        .wb_pf_write_addr2(reg_write_addr_wb_pf2),
        .wb_pf_write_data1(reg_write_data_wb_pf1),
        .wb_pf_write_data2(reg_write_data_wb_pf2),   //浠巜b闃舵鍓嶏拷?锟藉嚭鏉ョ殑鏁版�?

        //鏉ヨ嚜ex闃舵鐨勶紝鐢ㄤ簬鍒ゆ柇ex杩愯鐨勬寚浠ゆ槸鍚︽槸load鎸囦�?
        .ex_pre_aluop1(pre_ex_aluop1),       //ex闃舵鐨刲oad鎸囦护鏍囧織
        .ex_pre_aluop2(pre_ex_aluop2),

        //鏉ヨ嚜ex闃舵鐨勶紝鍙兘鐢变簬涔橀櫎娉曠瓑鎸囦护寮曡捣鐨勬殏鍋�?俊锟�???
        .ex_pause(pause_to_dispatch_ex_pause),//pause_o[5]           //ex闃舵鐨勬殏鍋滀俊锟�???

        // 杈撳嚭缁檈xecute鐨勬暟锟�???
        .pc1_o(pc_dispatch1),  
        .pc2_o(pc_dispatch2),
        .inst1_o(inst_dispatch1),
        .inst2_o(inst_dispatch2),
        .valid_o(valid_dispatch),

        .is_exception_o1(is_exception_dispatch1), //涓ゆ潯鎸囦护鐨勫紓甯告爣锟�??
        .is_exception_o2(is_exception_dispatch2),

        .pc_exception_cause_o1(pc_exception_cause_dispatch1), 
        .pc_exception_cause_o2(pc_exception_cause_dispatch2),
        .instbuffer_exception_cause_o1(instbuffer_exception_cause_dispatch1),
        .instbuffer_exception_cause_o2(instbuffer_exception_cause_dispatch2),
        .decoder_exception_cause_o1(decoder_exception_cause_dispatch1), 
        .decoder_exception_cause_o2(decoder_exception_cause_dispatch2),
        .dispatch_exception_cause_o1(dispatch_exception_cause_dispatch1),
        .dispatch_exception_cause_o2(dispatch_exception_cause_dispatch2),

        .is_privilege_o(is_privilege_dispatch), //涓ゆ潯鎸囦护鐨勭壒鏉冩寚浠ゆ爣锟�???

        .icacop_en_o1(icacop_en_dispatch1),
        .icacop_en_o2(icacop_en_dispatch2), 
        .dcacop_en_o1(dcacop_en_dispatch1),
        .dcacop_en_o2(dcacop_en_dispatch2),
        .cacop_opcode_o1(cacop_opcode_dispatch1), 
        .cacop_opcode_o2(cacop_opcode_dispatch2),

        .alu_op_o1(aluop_dispatch1),
        .alu_op_o2(aluop_dispatch2),
        .alu_sel_o1(alusel_dispatch1),
        .alu_sel_o2(alusel_dispatch2),

        .is_div_o(is_div_dispatch), //涓ゆ潯鎸囦护鏄惁鏄櫎娉曟寚锟�???
        .is_mul_o(is_mul_dispatch), //涓ゆ潯鎸囦护鏄惁鏄箻娉曟寚锟�???

        .reg_read_data_o1_1(reg_data_dispatch1_1), //瀵勫瓨鍣ㄥ爢缁欏嚭鐨勭1鏉℃寚浠ょ殑涓や釜婧愭搷浣滄�?
        .reg_read_data_o1_2(reg_data_dispatch1_2),
        .reg_read_data_o2_1(reg_data_dispatch2_1), //瀵勫瓨鍣ㄥ爢缁欏嚭鐨勭2鏉℃寚浠ょ殑涓や釜婧愭搷浣滄�?
        .reg_read_data_o2_2(reg_data_dispatch2_2),

        .reg_write_en_o(reg_write_en_dispatch),    //鐩殑�?�勫瓨鍣ㄥ啓浣胯�?
        .reg_write_addr_o1(reg_write_addr_dispatch1),  //鐩殑�?�勫瓨鍣ㄥ湴锟�??
        .reg_write_addr_o2(reg_write_addr_dispatch2),

        .csr_read_data_o1(csr_read_data_dispatch1), 
        .csr_read_data_o2(csr_read_data_dispatch2),
        .csr_write_en_o(csr_write_en_dispatch), //瀛樺櫒鍫嗙殑csr璇讳娇锟�???
        .csr_addr_o1(csr_addr_dispatch1),
        .csr_addr_o2(csr_addr_dispatch2),

        .invtlb_op_o1(invtlb_op_dispatch1),   //涓ゆ潯鎸囦护鐨勫垎鏀寚浠ゆ爣锟�???
        .invtlb_op_o2(invtlb_op_dispatch2),

        .pre_is_branch_taken_o(pre_is_branch_taken_dispatch), //鍓嶄竴鏉℃寚浠ゆ槸鍚︽槸鍒嗘敮鎸囦护
        .pre_branch_addr_o1(pre_branch_addr_dispatch1),
        .pre_branch_addr_o2(pre_branch_addr_dispatch2),



         // 杈撳嚭锟�??? id 闃舵鐨勪俊锟�??
        .invalid_en(invalid_en_dispatch), //鎸囦护鍙戝皠鎺у埗淇�?�彿

        // 涓庡瘎�?�樺櫒鐨勬帴锟�??
        .from_reg_read_data_i1_1(reg_read_data1_1),
        .from_reg_read_data_i1_2(reg_read_data1_2),
        .from_reg_read_data_i2_1(reg_read_data2_1),       
        .from_reg_read_data_i2_2(reg_read_data2_2),

        .dispatch_pause(pause_dispatch),    //鍙戝皠鍣ㄦ殏鍋滀俊锟�???,褰撳彂鐢焞oad-use鍐掗櫓鏃堕渶瑕佹殏锟�???

        // 鍜宑sr鐨勬帴锟�???
        // 杈撳�?
        .csr_read_data_i1(csr_read_data1),
        .csr_read_data_i2(csr_read_data2),
        // 杈撳�?
        .csr_read_en_o(csr_read_en),
        .csr_read_addr_o1(csr_read_addr1),
        .csr_read_addr_o2(csr_read_addr2)

    );

    wire flush_to_execute = flush_o[5];
    wire pause_to_execute = pause_o[5];

    wire [18:0] vppn_out;
    

    ex u_ex 
    (
        .clk(clk),
        .rst(rst),
        .vppn_in(vppn_out),
        .is_tlbsrch(is_tlbsrch),

    // 鏉ヨ嚜ctrl鐨勪俊锟�???
        .flush(flush_to_execute),    // 鎵ц闃舵鍒锋柊淇�?�彿,褰撳彂鐢熷垎�?娴嬮敊璇椂锟�??瑕佸埛锟�???
        .pause(pause_to_execute),    // 鎵ц闃舵鏆傚仠淇�?�彿,褰撳彂鐢焞oad-use鍐掗櫓鏃堕渶瑕佹殏锟�???

    // 鏉ヨ嚜stable counter鐨勪俊锟�???
        .cnt_i(cnt), 

    // 鏉ヨ嚜dispatch鐨勬暟锟�???
        .pc1_i(pc_dispatch1),
        .pc2_i(pc_dispatch2),
        .sort1_i(sort1_to_ex),
        .sort2_i(sort2_to_ex),
        .inst1_i(inst_dispatch1),
        .inst2_i(inst_dispatch2),
        .valid_i(valid_dispatch),

        .is_exception1_i(is_exception_dispatch1), // 涓ゆ潯鎸囦护鐨勫紓甯告爣锟�??
        .is_exception2_i(is_exception_dispatch2),
        .pc_exception_cause1_i(pc_exception_cause_dispatch1), 
        .pc_exception_cause2_i(pc_exception_cause_dispatch2),
        .instbuffer_exception_cause1_i(instbuffer_exception_cause_dispatch1),
        .instbuffer_exception_cause2_i(instbuffer_exception_cause_dispatch2),
        .decoder_exception_cause1_i(decoder_exception_cause_dispatch1),
        .decoder_exception_cause2_i(decoder_exception_cause_dispatch2),
        .dispatch_exception_cause1_i(dispatch_exception_cause_dispatch1),
        .dispatch_exception_cause2_i(dispatch_exception_cause_dispatch2),

        .is_privilege_i(is_privilege_dispatch),

        .icacop_en1_i(icacop_en_dispatch1),
        .icacop_en2_i(icacop_en_dispatch2),
        .dcacop_en1_i(dcacop_en_dispatch1),
        .dcacop_en2_i(dcacop_en_dispatch2),
        .cacop_opcode1_i(cacop_opcode_dispatch1),
        .cacop_opcode2_i(cacop_opcode_dispatch2),

        .aluop1_i(aluop_dispatch1),
        .aluop2_i(aluop_dispatch2),
        .alusel1_i(alusel_dispatch1),//????涓轰粈涔堝師锟�??1
        .alusel2_i(alusel_dispatch2),

        .is_div_i(is_div_dispatch), // 涓ゆ潯鎸囦护鏄惁鏄櫎娉曟寚锟�???
        .is_mul_i(is_mul_dispatch), // 涓ゆ潯鎸囦护鏄惁鏄箻娉曟寚锟�???

        .reg_data1_1_i(reg_data_dispatch1_1),
        .reg_data1_2_i(reg_data_dispatch1_2),
        .reg_data2_1_i(reg_data_dispatch2_1),
        .reg_data2_2_i(reg_data_dispatch2_2),
        .reg_write_en_i(reg_write_en_dispatch),                // 瀵勫瓨鍣ㄥ啓浣胯�?
        .reg_write_addr1_i(reg_write_addr_dispatch1),        // 瀵勫瓨鍣ㄥ啓鍦板�?
        .reg_write_addr2_i(reg_write_addr_dispatch2),

        .csr_read_data1_i(csr_read_data_dispatch1),    // csr璇绘暟锟�???
        .csr_read_data2_i(csr_read_data_dispatch2),
        .csr_write_en_i(csr_write_en_dispatch),     // csr鍐欎娇锟�???
        .csr_addr1_i(csr_addr_dispatch1), 
        .csr_addr2_i(csr_addr_dispatch2),

        .invtlb_op1_i(invtlb_op_dispatch1),
        .invtlb_op2_i(invtlb_op_dispatch2),

        .pre_is_branch_taken_i(pre_is_branch_taken_dispatch),      // 棰勬祴鍒嗘敮鎸囦护鏄惁璺宠�?
        .pre_branch_addr1_i(pre_branch_addr_dispatch1), 
        .pre_branch_addr2_i(pre_branch_addr_dispatch2),


        .ex_bpu_is_bj(ex_bpu_is_bj),     // 涓ゆ潯鎸囦护鏄惁鏄烦杞寚锟�???
        .ex_pc1(ex_pc1),            // eex 闃舵锟�??? pc
        .ex_pc2(ex_pc2),
        .ex_bpu_taken_or_not_actual(ex_bpu_taken_or_not_actual),       // 涓ゆ潯鎸囦护瀹為檯鏄惁璺宠�?
        .ex_bpu_branch_actual_addr1(ex_bpu_branch_actual_addr1),  // 涓ゆ潯鎸囦护瀹為檯璺宠浆鍦板�?
        .ex_bpu_branch_actual_addr2(ex_bpu_branch_actual_addr2),
        .ex_bpu_branch_pred_addr1(ex_bpu_branch_pred_addr1),    // 涓ゆ潯鎸囦护棰勬祴璺宠浆鍦板�?
        .ex_bpu_branch_pred_addr2(ex_bpu_branch_pred_addr2),
    
    // 鏉ヨ嚜mem鐨勪俊锟�???
        .pause_mem_i(pause_mem),

    // 鍜宒cache鐨勬帴锟�???
        .dcache_pause_i(dcache_pause_i),    // 鏆傚仠dcache璁块棶淇″彿

        .ren_o(ren_o),          
        .wstrb_o(wstrb_o),
        .wen_o(writen_o),
        .virtual_addr_o(virtual_addr_o),
        .wdata_o(wdata_o),
        .llw_to_dcache(llw_to_dcache),
        .scw_to_dcache(scw_to_dcache),


    // 鍓嶏�??锟界粰dispatch鐨勬暟锟�???
        .pre_ex_aluop1_o(pre_ex_aluop1),
        .pre_ex_aluop2_o(pre_ex_aluop2),
        .reg_write_en_o(reg_write_en_ex_pf),
        .reg_write_addr1_o(reg_write_addr_ex_pf1),
        .reg_write_addr2_o(reg_write_addr_ex_pf2),
        .reg_write_data1_o(reg_write_data_ex_pf1),
        .reg_write_data2_o(reg_write_data_ex_pf2),
    
    // 杈撳嚭缁檆trl鐨勬暟锟�???
        .pause_ex_o(pause_execute),
        .branch_flush_o(branch_flush),
        .ex_excp_flush_o(ex_excep_flush),
        .branch_target_o(branch_addr),

    // 杈撳嚭缁檓em鐨勬暟锟�???
        .pc1_mem(pc_execute1),
        .pc2_mem(pc_execute2),
        .count_64_mem1(count_64_execute1),
        .count_64_mem2(count_64_execute2),
        .inst1_mem(inst_execute1),
        .inst2_mem(inst_execute2),

        .is_exception1_o(is_exception_execute1),
        .is_exception2_o(is_exception_execute2),
        .pc_exception_cause1_o(pc_exception_cause_execute1),
        .pc_exception_cause2_o(pc_exception_cause_execute2),
        .instbuffer_exception_cause1_o(instbuffer_exception_cause_execute1),
        .instbuffer_exception_cause2_o(instbuffer_exception_cause_execute2),
        .decoder_exception_cause1_o(decoder_exception_cause_execute1),
        .decoder_exception_cause2_o(decoder_exception_cause_execute2),
        .dispatch_exception_cause1_o(dispatch_exception_cause_execute1),
        .dispatch_exception_cause2_o(dispatch_exception_cause_execute2),
        .execute_exception_cause1_o(execute_exception_cause_execute1),
        .execute_exception_cause2_o(execute_exception_cause_execute2),

        .is_privilege_mem(is_privilege_execute),
        .is_ertn_mem(is_ertn_execute),
        .is_idle_mem(is_idle_execute),
        .valid_mem(valid_execute),

        .reg_write_en_mem(reg_write_en_execute),
        .reg_write_addr1_mem(reg_write_addr_execute1),
        .reg_write_addr2_mem(reg_write_addr_execute2),
        .reg_write_data1_mem(reg_write_data_execute1), 
        .reg_write_data2_mem(reg_write_data_execute2),

        .aluop1_mem(aluop_execute1),
        .aluop2_mem(aluop_execute2),

        .addr1_mem(addr_execute1),
        .addr2_mem(addr_execute2),
        .data1_mem(data_execute1),
        .data2_mem(data_execute2),

        .csr_write_en_mem(csr_write_en_execute),
        .csr_addr1_mem(csr_addr_execute1),
        .csr_addr2_mem(csr_addr_execute2),
        .csr_write_data1_mem(csr_write_data_execute1),
        .csr_write_data2_mem(csr_write_data_execute2),

        .is_llw_scw_mem(is_llw_scw_execute),
        .is_llw_mem(is_llw_execute),
        .is_scw_mem(is_scw_execute),
        .icacop_en_mem(icacop_en_execute),

        //cacop
        .icacop_en(icacop_en), 
        .dcacop_en(dcacop_en),
        .cacop_mode(cacop_mode),
        .cache_cacop_vaddr(cache_cacop_vaddr),    // to addr_trans

        //tlb
        .ex_invtlb_vpn(ex_invtlb_vpn),
        .ex_invtlb_asid(ex_invtlb_asid),
        .ex_invtlb(ex_invtlb),
        .ex_tlbrd(ex_tlbrd),
        .ex_tlbfill(ex_tlbfill),
        .ex_tlbwr(ex_tlbwr),
        .ex_tlbsrch(ex_tlbsrch),
        .ex_invtlb_op(ex_invtlb_op),

        .st_write_data1(ex_st_write_data1),
        .st_write_data2(ex_st_write_data2)
    );

    mem u_mem (
        .clk(clk),
        .rst(rst),

    // 鎵ц闃舵鐨勪俊锟�??
        .pc1(pc_execute1) ,
        .pc2(pc_execute2) ,
        .count_64_i1(count_64_execute1),
        .count_64_i2(count_64_execute2),
        .inst1(inst_execute1),
        .inst2(inst_execute2),

        .dcache_is_exception_i(dcache_is_exception_i),
        .dcache_exception_cause_i(dcache_exception_cause_i),

        .is_exception1_i(is_exception_execute1),  
        .is_exception2_i(is_exception_execute2),
        .pc_exception_cause1_i(pc_exception_cause_execute1) ,
        .pc_exception_cause2_i(pc_exception_cause_execute2) ,
        .instbuffer_exception_cause1_i(instbuffer_exception_cause_execute1),
        .instbuffer_exception_cause2_i(instbuffer_exception_cause_execute2),
        .decoder_exception_cause1_i(decoder_exception_cause_execute1),
        .decoder_exception_cause2_i(decoder_exception_cause_execute2),
        .dispatch_exception_cause1_i(dispatch_exception_cause_execute1),
        .dispatch_exception_cause2_i(dispatch_exception_cause_execute2),
        .execute_exception_cause1_i(execute_exception_cause_execute1),
        .execute_exception_cause2_i(execute_exception_cause_execute2),

        .is_privilege(is_privilege_execute), 
        .is_ertn(is_ertn_execute),
        .is_idle(is_idle_execute), 
        .valid(valid_execute),

        .reg_write_en(reg_write_en_execute),  //瀵勫瓨鍣ㄥ啓浣胯兘淇″彿
        .reg_write_addr1(reg_write_addr_execute1),
        .reg_write_addr2(reg_write_addr_execute2),
        .reg_write_data1(reg_write_data_execute1), 
        .reg_write_data2(reg_write_data_execute2),
        .aluop1(aluop_execute1),
        .aluop2(aluop_execute2),
        .mem_addr1(addr_execute1), //鍐呭瓨鍦板潃
        .mem_addr2(addr_execute2), 
        .mem_write_data1(data_execute1),
        .mem_write_data2(data_execute2),
        .csr_write_en(csr_write_en_execute), //CSR瀵勫瓨鍣ㄥ啓浣胯�?
        .csr_addr1(csr_addr_execute1), //CSR瀵勫瓨鍣ㄥ湴锟�??
        .csr_addr2(csr_addr_execute2),
        .csr_write_data_mem1(csr_write_data_execute1),
        .csr_write_data_mem2(csr_write_data_execute2),
        .is_llw_scw(is_llw_scw_execute), //鏄惁鏄疞LW/SCW鎸囦�?
        .is_llw(is_llw_execute),
        .icacop_en(icacop_en_execute),
        .st_write_data1(ex_st_write_data1),
        .st_write_data2(ex_st_write_data2),

    //tlb
        .ex_invtlb_vpn(ex_invtlb_vpn),
        .ex_invtlb_asid(ex_invtlb_asid),
        .ex_invtlb(ex_invtlb),
        .ex_tlbrd(ex_tlbrd),
        .ex_tlbfill(ex_tlbfill),
        .ex_tlbwr(ex_tlbwr),
        .ex_tlbsrch(ex_tlbsrch),
        .ex_invtlb_op(ex_invtlb_op),
        .data_tlb_found(data_tlb_found),
        .data_tlb_index(data_tlb_index),
        .mem_invtlb_vpn(mem_invtlb_vpn),
        .mem_invtlb_asid(mem_invtlb_asid),
        .mem_invtlb(mem_invtlb),
        .mem_tlbrd(mem_tlbrd),
        .mem_tlbfill(mem_tlbfill),
        .mem_tlbwr(mem_tlbwr),
        .mem_tlbsrch(mem_tlbsrch),
        .mem_invtlb_op(mem_invtlb_op),
        .mem_tlb_found(mem_tlb_found),
        .mem_tlb_index(mem_tlb_index),
    //dcache鐨勪俊锟�???
        .dcache_read_data(rdata_i), 

        .data_ok(rdata_valid_i),                //dcache
        .sc_cancel_i(sc_cancel_to_backend),
        .dcache_P_addr(32'b0),

        .paddr(paddr),              // to difftest
    
    // 杈撳嚭缁檇ispatcher鐨勪俊锟�???
        .mem_pf_reg_write_en(reg_write_en_mem_pf), 
        .mem_pf_reg_write_addr1(reg_write_addr_mem_pf1),
        .mem_pf_reg_write_addr2(reg_write_addr_mem_pf2),

    // 杈撳嚭缁檆trl鐨勪俊锟�???
        .pause_mem(pause_mem), //闁�??锟界煡鏆傚仠鍐呭瓨璁块棶淇�?�彿

    //杈撳嚭缁檞b鐨勪俊锟�???
        .wb_reg_write_en(reg_write_en_mem), 
        .wb_reg_write_addr1(reg_write_addr_mem1),
        .wb_reg_write_addr2(reg_write_addr_mem2),
        .wb_reg_write_data1(reg_write_data_mem1),
        .wb_reg_write_data2(reg_write_data_mem2),

        .wb_csr_write_en(csr_write_en_mem), //CSR瀵勫瓨鍣ㄥ啓浣胯�?
        .wb_csr_addr1(csr_write_addr_mem1), //CSR瀵勫瓨鍣ㄥ湴锟�??
        .wb_csr_addr2(csr_write_addr_mem2),
        .wb_csr_write_data1(csr_write_data_mem1),
        .wb_csr_write_data2(csr_write_data_mem2),
        .wb_is_llw_scw(is_llw_scw_mem), //鏄惁鏄疞LW/SCW鎸囦�?
        .wb_is_llw(is_llw_mem),

    //commit_ctrl鐨勪俊锟�???
        .commit_valid(valid_mem), //鎸囦护鏄惁鏈夋�?

        .is_exception1_o(is_exception_mem1),
        .is_exception2_o(is_exception_mem2), 
        .pc_exception_cause1_o(pc_exception_cause_mem1),
        .pc_exception_cause2_o(pc_exception_cause_mem2),
        .instbuffer_exception_cause1_o(instbuffer_exception_cause_mem1),
        .instbuffer_exception_cause2_o(instbuffer_exception_cause_mem2),
        .decoder_exception_cause1_o(decoder_exception_cause_mem1),
        .decoder_exception_cause2_o(decoder_exception_cause_mem2),
        .dispatch_exception_cause1_o(dispatch_exception_cause_mem1),
        .dispatch_exception_cause2_o(dispatch_exception_cause_mem2),
        .execute_exception_cause1_o(execute_exception_cause_mem1),
        .execute_exception_cause2_o(execute_exception_cause_mem2),
        .commit_exception_cause1_o(commit_exception_cause_mem1),
        .commit_exception_cause2_o(commit_exception_cause_mem2),

        .commit_pc1(pc_mem1),
        .commit_pc2(pc_mem2),
        .commit_count_64_o1(count_64_mem1),
        .commit_count_64_o2(count_64_mem2),
        .commit_addr1(addr_mem1), //鍐呭瓨鍦板潃
        .commit_addr2(addr_mem2),
        .commit_idle(is_idle_mem), //鏄惁鏄┖闂叉寚锟�???
        .commit_ertn(is_ertn_mem), //鏄惁鏄紓甯歌繑鍥炴寚锟�??
        .commit_is_privilege(is_privilege_mem), //鐗规潈鎸囦护
        .commit_icacop_en(icacop_en_mem)


        // difftest
        `ifdef DIFF
        ,

        .commit_diff0(wb_diff0_i),
        .commit_diff1(wb_diff1_i)

        `endif
    );

    wire [31:0] wb_inst1;
    wire [31:0] wb_inst2;
    wire flush_to_wb = flush_o[7];

    assign rand_index = count_64_wb1;
    wb u_wb (
        .clk(clk),
        .rst(rst),
        .flush(flush_to_wb),

   //   mem浼犲叆鐨勪俊锟�??
        .uncache_i(uncache_i),
        .wb_reg_write_en(reg_write_en_mem), 
        .wb_reg_write_addr1(reg_write_addr_mem1),
        .wb_reg_write_addr2(reg_write_addr_mem2),
        .wb_reg_write_data1(reg_write_data_mem1),
        .wb_reg_write_data2(reg_write_data_mem2),
        .wb_csr_write_en(csr_write_en_mem), //CSR瀵勫瓨鍣ㄥ啓浣胯�?
        .wb_csr_addr1(csr_write_addr_mem1), //CSR瀵勫瓨鍣ㄥ湴锟�??
        .wb_csr_addr2(csr_write_addr_mem2),
        .wb_csr_write_data1(csr_write_data_mem1),
        .wb_csr_write_data2(csr_write_data_mem2),
        .wb_is_llw_scw(is_llw_scw_mem), //鏄惁鏄疞LW/SCW鎸囦�?
        .wb_is_llw(is_llw_mem),

        .commit_valid(valid_mem), //鎸囦护鏄惁鏈夋�?

        .is_exception1_i(is_exception_mem1),
        .is_exception2_i(is_exception_mem2),
        .pc_exception_cause1_i(pc_exception_cause_mem1),
        .pc_exception_cause2_i(pc_exception_cause_mem2),
        .instbuffer_exception_cause1_i(instbuffer_exception_cause_mem1),
        .instbuffer_exception_cause2_i(instbuffer_exception_cause_mem2),
        .decoder_exception_cause1_i(decoder_exception_cause_mem1),
        .decoder_exception_cause2_i(decoder_exception_cause_mem2),
        .dispatch_exception_cause1_i(dispatch_exception_cause_mem1),
        .dispatch_exception_cause2_i(dispatch_exception_cause_mem2),
        .execute_exception_cause1_i(execute_exception_cause_mem1),
        .execute_exception_cause2_i(execute_exception_cause_mem2),
        .commit_exception_cause1_i(commit_exception_cause_mem1),
        .commit_exception_cause2_i(commit_exception_cause_mem2),

        .commit_pc1(pc_mem1),
        .commit_pc2(pc_mem2),
        .commit_count_64_i1(count_64_mem1),
        .commit_count_64_i2(count_64_mem2),
        .commit_addr1(addr_mem1), //鍐呭瓨鍦板潃
        .commit_addr2(addr_mem2), 
        .commit_idle(is_idle_mem), //鏄惁鏄┖闂叉寚锟�???
        .commit_ertn(is_ertn_mem), //鏄惁鏄紓甯歌繑鍥炴寚锟�??
        .commit_is_privilege(is_privilege_mem), //鐗规潈鎸囦护
        .commit_icacop_en(icacop_en_mem),
        .pause_mem(pause_mem),

        .wb_pf_reg_write_en(reg_write_en_wb_pf),    
        .wb_pf_reg_write_addr1(reg_write_addr_wb_pf1), 
        .wb_pf_reg_write_addr2(reg_write_addr_wb_pf2),   
        .wb_pf_reg_write_data1(reg_write_data_wb_pf1), 
        .wb_pf_reg_write_data2(reg_write_data_wb_pf2), 

    // to ctrl
        .ctrl_reg_write_en(reg_write_en_wb), 
        .ctrl_reg_write_addr1(reg_write_addr_wb1),
        .ctrl_reg_write_addr2(reg_write_addr_wb2),
        .ctrl_reg_write_data1(reg_write_data_wb1),
        .ctrl_reg_write_data2(reg_write_data_wb2),

        .ctrl_csr_write_en(csr_write_en_wb), //CSR瀵勫瓨鍣ㄥ啓浣胯�?
        .ctrl_csr_addr1(csr_write_addr_wb1), //CSR瀵勫瓨鍣ㄥ湴锟�??
        .ctrl_csr_addr2(csr_write_addr_wb2),
        .ctrl_csr_write_data1(csr_write_data_wb1),
        .ctrl_csr_write_data2(csr_write_data_wb2),
        .ctrl_is_llw_scw(is_llw_scw_wb), //鏄惁鏄疞LW/SCW鎸囦�?
        .commit_valid_out(valid_wb), //鎸囦护鏄惁鏈夋�?

        .is_exception1_o(is_exception_wb1),
        .is_exception2_o(is_exception_wb2),
        .pc_exception_cause1_o(pc_exception_cause_wb1),
        .pc_exception_cause2_o(pc_exception_cause_wb2),
        .instbuffer_exception_cause1_o(instbuffer_exception_cause_wb1),
        .instbuffer_exception_cause2_o(instbuffer_exception_cause_wb2),
        .decoder_exception_cause1_o(decoder_exception_cause_wb1),
        .decoder_exception_cause2_o(decoder_exception_cause_wb2),
        .dispatch_exception_cause1_o(dispatch_exception_cause_wb1),
        .dispatch_exception_cause2_o(dispatch_exception_cause_wb2),
        .execute_exception_cause1_o(execute_exception_cause_wb1),
        .execute_exception_cause2_o(execute_exception_cause_wb2),
        .commit_exception_cause1_o(commit_exception_cause_wb1),
        .commit_exception_cause2_o(commit_exception_cause_wb2),

        .commit_pc_out1(pc_wb1),
        .commit_pc_out2(pc_wb2),
        .commit_count_64_o1(count_64_wb1),
        .commit_count_64_o2(count_64_wb2),
        .commit_refetch_target_pc(refetch_target_pc_wb),
        .commit_addr_out1(addr_wb1), //鍐呭瓨鍦板潃
        .commit_addr_out2(addr_wb2),
        .commit_idle_out(is_idle_wb), //鏄惁鏄┖闂叉寚锟�???
        .commit_ertn_out(is_ertn_wb), //鏄惁鏄紓甯歌繑鍥炴寚锟�??
        .commit_is_privilege_out(is_privilege_wb), //鐗规潈鎸囦护
        .commit_icacop_en_out(icacop_en_wb),
        .mem_inst1(inst_execute1),
        .mem_inst2(inst_execute2),
        .wb_inst1(wb_inst1),
        .wb_inst2(wb_inst2),

        .llbit_write(llbit_write_wb),
        
        //tlb
        .mem_invtlb_vpn(mem_invtlb_vpn),
        .mem_invtlb_asid(mem_invtlb_asid),
        .mem_invtlb(mem_invtlb),
        .mem_tlbrd(mem_tlbrd),
        .mem_tlbfill(mem_tlbfill),
        .mem_tlbwr(mem_tlbwr),
        .mem_tlbsrch(mem_tlbsrch),
        .mem_invtlb_op(mem_invtlb_op),
        .mem_tlb_found(mem_tlb_found),
        .mem_tlb_index(mem_tlb_index),
        .wb_invtlb_vpn(wb_invtlb_vpn),
        .wb_invtlb_asid(wb_invtlb_asid),
        .wb_invtlb(wb_invtlb),
        .wb_tlbrd(wb_tlbrd),
        .wb_tlbfill(wb_tlbfill),
        .wb_tlbwr(wb_tlbwr),
        .wb_tlbsrch(wb_tlbsrch),
        .wb_invtlb_op(wb_invtlb_op),
        .wb_tlb_found(wb_tlb_found),
        .wb_tlb_index(wb_tlb_index)


        // difftest
        `ifdef DIFF
        ,
        .diff_flush(diff_flush),
        .wb_diff0_i(wb_diff0_i),
        .wb_diff1_i(wb_diff1_i),

        .wb_diff0_o(wb_diff0_o),
        .wb_diff1_o(wb_diff1_o)
        `endif
    );
    wire diff_flush;
    wire [63:0] count_64_o1;
    wire [63:0] count_64_o2;

    CU u_CU (
        .clk(clk),
        .rst(rst),
        .csr_tlbrentry_i(csr_tlbrentry),

        .pause_buffer(1'b0),//浠庡墠绔緭锟�??,涓嶇煡閬撴湁娌℃�?
        .pause_decode(pause_decoder),//浠巇ecoder杈撳�?,  鏆傛椂涔熸病锟�??
        .pause_dispatch(pause_dispatch),//浠巇ispatch杈撳�?
        .pause_execute(pause_execute),//浠巈xecute杈撳�?
        .pause_mem(pause_mem),//浠巑em杈撳�?

        .branch_flush(branch_flush),//鍒嗘敮璺宠浆鍒锋柊淇″彿
        .branch_target(branch_addr),//鍒嗘敮璺宠浆鍦板潃锛屼粠execute闃舵杈撳叆
        .ex_excp_flush(ex_excep_flush),//寮傚父鍒锋柊淇�?�彿,浠巈xecute闃舵杈撳叆

    //wb闃舵杈撳叆wb
        .reg_write_en_i(reg_write_en_wb),//鍐欏洖闃舵鍒锋柊淇″彿
        .reg_write_addr1_i(reg_write_addr_wb1),//鍐欏洖闃舵瀵勫瓨鍣ㄥ湴锟�??
        .reg_write_addr2_i(reg_write_addr_wb2),
        .reg_write_data1_i(reg_write_data_wb1),//鍐欏洖闃舵瀵勫瓨鍣ㄦ暟锟�??
        .reg_write_data2_i(reg_write_data_wb2),
        .is_llw_scw_i(is_llw_scw_wb),//鏄惁锟�??? llw/scw 鎸囦�?
        .csr_write_en_i(csr_write_en_wb),//csr鍐欎娇鑳戒俊锟�??
        .csr_write_addr1_i(csr_write_addr_wb1),//csr鍐欏湴锟�???
        .csr_write_addr2_i(csr_write_addr_wb2),
        .csr_write_data1_i(csr_write_data_wb1),//csr鍐欐暟锟�???
        .csr_write_data2_i(csr_write_data_wb2),

    //浠巜b闃舵杈撳叆commit
        .is_exception1_i(is_exception_wb1),//鏄惁鏈夊紓锟�??
        .is_exception2_i(is_exception_wb2),
        .pc_exception_cause1_i(pc_exception_cause_wb1),
        .pc_exception_cause2_i(pc_exception_cause_wb2),
        .instbuffer_exception_cause1_i(instbuffer_exception_cause_wb1),
        .instbuffer_exception_cause2_i(instbuffer_exception_cause_wb2),
        .decoder_exception_cause1_i(decoder_exception_cause_wb1),
        .decoder_exception_cause2_i(decoder_exception_cause_wb2),
        .dispatch_exception_cause1_i(dispatch_exception_cause_wb1),
        .dispatch_exception_cause2_i(dispatch_exception_cause_wb2),
        .execute_exception_cause1_i(execute_exception_cause_wb1),
        .execute_exception_cause2_i(execute_exception_cause_wb2),
        .commit_exception_cause1_i(commit_exception_cause_wb1),
        .commit_exception_cause2_i(commit_exception_cause_wb2),

        .pc1_i(pc_wb1),
        .pc2_i(pc_wb2),
        .count_64_i1(count_64_wb1),
        .count_64_i2(count_64_wb2),
        .refetch_target_pc_i(refetch_target_pc_wb),
        .mem_addr1_i(addr_wb1),
        .mem_addr2_i(addr_wb2),
        .is_idle_i(is_idle_wb),//鏄惁澶勪簬绌洪棽鐘讹拷??
        .is_ertn_i(is_ertn_wb),//鏄惁鏄紓甯歌繑鍥炴寚锟�??
        .is_privilege_i(is_privilege_wb),//鏄惁鏄壒鏉冩寚锟�???
        .icacop_en_i(icacop_en_wb),
        .valid_i(valid_wb),//鎸囦护鏄惁鏈夋�?
    //csr
        .is_ertn_o(csr_is_ertn),//鏄惁鏄紓甯歌繑鍥炴寚锟�??
    //
        .flush(flush_o),//鍒锋柊淇″彿
        .pause(pause_o),//鏆傚仠淇″彿


        .new_pc(new_pc),

    //to regfile
        .reg_write_en_o(reg_write_en),//鍐欏洖闃舵鍒锋柊淇″彿
        .reg_write_addr1_o(reg_write_addr1),//鍐欏洖闃舵瀵勫瓨鍣ㄥ湴锟�??
        .reg_write_addr2_o(reg_write_addr2),
        .reg_write_data1_o(reg_write_data1),//鍐欏洖闃舵瀵勫瓨鍣ㄦ暟锟�??
        .reg_write_data2_o(reg_write_data2),

    //to csr
        .is_llw_scw_o(is_llw_scw_ctrl),//鏄惁锟�??? llw/scw 鎸囦�?
        .csr_write_en_o(csr_write_en),//csr鍐欎娇鑳戒俊锟�??
        .csr_write_addr_o(csr_write_addr),//csr鍐欏湴锟�???
        .csr_write_data_o(csr_write_data),//csr鍐欐暟锟�???

    // with csr
        .csr_eentry_i(csr_eentry), //寮傚父鍏ュ彛鍦板�?
        .csr_era_i(csr_era), //寮傚父杩斿洖鍦板�?
        .csr_crmd_i(csr_crmd), //鎺у埗瀵勫瓨锟�???  
        .csr_is_interrupt_i(csr_is_interrupt), //鏄惁鏄腑锟�??
    
        .csr_is_exception_o(csr_is_exception), //鏄惁鏄紓锟�??
        .csr_exception_pc_o(csr_exception_pc), //寮傚父PC鍦板�?
        .csr_exception_addr_o(csr_exception_addr), //寮傚父鍦板潃
        .csr_ecode_o(csr_ecode), //寮傚父ecode
        .csr_exception_cause_o(csr_exception_cause), //寮傚父鍘熷洜
        .csr_esubcode_o(csr_esubcode), 

        .csr_is_inst_tlb_exception_o(csr_is_inst_tlb_exception), 
        .csr_is_tlb_exception_o(csr_is_tlb_exception),
    //tlb
        .wb_invtlb_vpn(wb_invtlb_vpn),
        .wb_invtlb_asid(wb_invtlb_asid),
        .wb_invtlb(wb_invtlb),
        .wb_tlbrd(wb_tlbrd),
        .wb_tlbfill(wb_tlbfill),
        .wb_tlbwr(wb_tlbwr),
        .wb_tlbsrch(wb_tlbsrch),
        .wb_invtlb_op(wb_invtlb_op),
        .wb_tlb_found(wb_tlb_found),
        .wb_tlb_index(wb_tlb_index),
        .invtlb_vpn(invtlb_vpn),
        .invtlb_asid(invtlb_asid),
        .invtlb(invtlb),
        .invtlb_op(invtlb_op),
        .tlbrd(tlbrd),
        .tlbfill(tlbfill),
        .tlbwr(tlbwr),
        .tlbsrch(tlbsrch),
        .tlb_found(tlb_found),
        .tlb_index(tlb_index),

        .count_64_o1(count_64_o1),   
        .count_64_o2(count_64_o2)

        // difftest
        `ifdef DIFF
        ,

        .ctrl_diff0_i(wb_diff0_o),
        .ctrl_diff1_i(wb_diff1_o),

        .ctrl_diff0_o(diff0),
        .ctrl_diff1_o(diff1),
        .diff_flush(diff_flush)
        `endif 
    );

    reg_files u_reg_files (
        // 杈撳�?
        .clk(clk),
        .rst(rst),
        .reg_read_en1(reg_read_en_decoder1),            // 绗竴鏉℃寚浠ょ殑涓や釜璇讳娇锟�???
        .reg_read_en2(reg_read_en_decoder2),            // 绗簩鏉℃寚浠ょ殑涓や釜璇讳娇锟�???
        .reg_read_addr1_1(reg_read_addr_decoder1_1), 
        .reg_read_addr1_2(reg_read_addr_decoder1_2), 
        .reg_read_addr2_1(reg_read_addr_decoder2_1), //瀵勫瓨鍣ㄨ鍦板�?
        .reg_read_addr2_2(reg_read_addr_decoder2_2),
        .reg_write_data1(reg_write_data1), 
        .reg_write_data2(reg_write_data2),
        .reg_write_en(reg_write_en), //瀵勫瓨鍣ㄥ啓浣胯兘淇″彿
        .reg_write_addr1(reg_write_addr1),
        .reg_write_addr2(reg_write_addr2),

        // 杈撳�?
        .reg_read_data1_1(reg_read_data1_1),  //瀵勫瓨鍣ㄨ鏁版�?
        .reg_read_data1_2(reg_read_data1_2), 
        .reg_read_data2_1(reg_read_data2_1),   //瀵勫瓨鍣ㄨ鏁版�?
        .reg_read_data2_2(reg_read_data2_2)


        `ifdef DIFF
        ,

        .regs_diff(regs_diff)
        `endif
    );

    csr u_csr (
        .clk(clk),
        .rst(rst),
        .vppn_out(vppn_out),

        // 鍜宒ispatch鐨勬帴锟�???
        // 杈撳�?
        .csr_read_en_i(csr_read_en),
        .csr_read_addr_i1(csr_read_addr1),
        .csr_read_addr_i2(csr_read_addr2),
        //  杈撳�?
        .csr_read_data_o1(csr_read_data1),
        .csr_read_data_o2(csr_read_data2),

        // 鏉ヨ嚜wb鐨勪俊锟�???
        .is_llw_scw_i(is_llw_scw_ctrl),
        .llbit_write(llbit_write_wb),
        .csr_write_en_i(csr_write_en),
        .csr_write_addr_i(csr_write_addr),
        .csr_write_data_i(csr_write_data),

        //tlb鐩稿叧杈撳叆
        .search_tlb_found_i(tlb_found),
        .search_tlb_index_i(tlb_index),
        .tlbrd_valid_i(tlbrd),
        .tlbehi_out_i(tlbehi_in),
        .tlbelo0_out_i(tlbelo0_in),
        .tlbelo1_out_i(tlbelo1_in),
        .tlbidx_out_i(tlbidx_in),
        .asid_out_i(asid_in),
        .tlbsrch_en(tlbsrch),
        .tlbrd_ret_i(1'b0),

        //tlb鐩稿叧杈撳嚭
        .tlbidx_o(tlbidx_out),  //7.5.1TLB绱㈠紩�?�勫瓨鍣紝鍖呭惈[4:0]涓篿ndex,[29:24]涓篜S锛孾31]涓篘E
        .tlbehi_o(tlbehi_out),  //7.5.2TLB琛ㄩ」楂樹綅锛屽寘鍚�?31:13]涓篤PPN
        .tlbelo0_o(tlbelo0_out),   //7.5.3TLB琛ㄩ」浣庝綅锛屽寘鍚啓鍏LB琛ㄩ」鐨勫唴锟�??
        .tlbelo1_o(tlbelo1_out),
        .asid_o(asid_out),  //7.5.4ASID鐨勪�?9锟�??
        //TLBFILL鍜孴LBWR鎸囦�?
        .ecode_o(ecode_out),//7.5.1瀵�?�簬NE鍙橀噺鐨勬弿杩颁腑璁插埌锛孋SR.ESTAT.Ecode   (澶ф浣胯兘淇″彿锛岃嫢锟�???111111鍒欏啓浣胯兘锛屽惁鍒欐牴鎹畉lbindex_in.NE鍒ゆ柇鏄惁鍐欎娇鑳斤紵
        //CSR淇�?�彿
        .csr_dmw0_o(csr_dmw0),//dmw0锛屾湁鏁堜綅鏄痆27:25]锛屽彲鑳戒細浣滀负锟�???鍚庤浆鎹㈠嚭鏉ョ殑鍦板潃鐨勬渶楂樹笁锟�??
        .csr_dmw1_o(csr_dmw1),//dmw1锛屾湁鏁堜綅鏄痆27:25]锛屽彲鑳戒細浣滀负锟�???鍚庤浆鎹㈠嚭鏉ョ殑鍦板潃鐨勬渶楂樹笁锟�??
        .csr_da_o(csr_da),
        .csr_pg_o(csr_pg),
        .csr_plv_o(csr_plv),
        .csr_datf_o(csr_datf),
        .csr_datm_o(csr_datm),
    
    
        // from outer锛堜笉鐭ラ亾鏄粈涔堬級
        .is_ipi(1'b0), //锟�??0
        .is_hwi(is_hwi),//mytop杈撳叆锟�???


        // 鍜宑trl鐨勬帴锟�???
        // 杈撳�?
        .is_exception_i(csr_is_exception), //鏄惁鏄紓锟�??
        .exception_cause_i(csr_exception_cause), //寮傚父鍘熷洜
        .exception_pc_i(csr_exception_pc), //寮傚父PC鍦板�?
        .exception_addr_i(csr_exception_addr), //寮傚父鍦板潃
        .ecode_i(csr_ecode), //寮傚父ecode
        .esubcode_i(csr_esubcode), //寮傚父�?�愮�?
        .is_ertn_i(csr_is_ertn),
        .is_inst_tlb_exception_i(csr_is_inst_tlb_exception), //鏄惁鏄寚浠LB寮傚�?
        .is_tlb_exception_i(csr_is_tlb_exception),
        // 杈撳�?
        .eentry_o(csr_eentry), //寮傚父鍏ュ彛鍦板�?
        .era_o(csr_era), //甯歌繑鍥炲湴锟�??
        .crmd_o(csr_crmd), //鎺у埗瀵勫瓨锟�???
        .is_interrupt_o(csr_is_interrupt), //鏄惁鏄腑锟�??
        .tlbrentry_o(csr_tlbrentry)


        // difftest 
        `ifdef DIFF
        ,

        // diff
        .csr_crmd_diff(csr_crmd_diff),
        .csr_prmd_diff(csr_prmd_diff),
        .csr_ectl_diff(csr_ectl_diff),
        .csr_estat_diff(csr_estat_diff),
        .csr_era_diff(csr_era_diff),
        .csr_badv_diff(csr_badv_diff),
        .csr_eentry_diff(csr_eentry_diff),
        .csr_tlbidx_diff(csr_tlbidx_diff),
        .csr_tlbehi_diff(csr_tlbehi_diff),
        .csr_tlbelo0_diff(csr_tlbelo0_diff),
        .csr_tlbelo1_diff(csr_tlbelo1_diff),
        .csr_asid_diff(csr_asid_diff),
        .csr_save0_diff(csr_save0_diff),
        .csr_save1_diff(csr_save1_diff),
        .csr_save2_diff(csr_save2_diff),
        .csr_save3_diff(csr_save3_diff),
        .csr_tid_diff(csr_tid_diff),
        .csr_tcfg_diff(csr_tcfg_diff),
        .csr_tval_diff(csr_tval_diff),
        .csr_ticlr_diff(csr_ticlr_diff),
        .csr_llbctl_diff(csr_llbctl_diff),
        .csr_tlbrentry_diff(csr_tlbrentry_diff),
        .csr_dmw0_diff(csr_dmw0_diff),
        .csr_dmw1_diff(csr_dmw1_diff),
        .csr_pgdl_diff(csr_pgdl_diff),
        .csr_pgdh_diff(csr_pgdh_diff)        

        `endif
    );
    
    clock u_clock 
    (
        .clk(clk),
        .rst(rst),

        .count_64(cnt)
    );

    assign debug_wb_valid1 = valid_wb[0];
    assign debug_wb_valid2 = valid_wb[1];
    assign debug_pc1 = !is_exception_wb1[1] ? pc_wb1 : 32'b0;
    assign debug_pc2 = !is_exception_wb2[1] ? pc_wb2 : 32'b0;
    assign  debug_inst1 = wb_inst1;
    assign debug_inst2 = wb_inst2;
    assign  debug_reg_addr1 = !is_exception_wb1[1] ? reg_write_addr_wb1 : 5'b0;
    assign  debug_reg_addr2 = !is_exception_wb2[1] ? reg_write_addr_wb2 : 5'b0;
    assign  debug_wdata1 = !is_exception_wb1[1] ? reg_write_data_wb1 : 32'b0;
    assign  debug_wdata2 = !is_exception_wb2[1] ? reg_write_data_wb2 : 32'b0; 
    assign debug_wb_we1 = reg_write_en_wb[0];
    assign debug_wb_we2 = reg_write_en_wb[1];

endmodule