`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"

module ex (
    input wire clk,
    input wire rst,

    input wire [18:0] vppn_in,
    output wire is_tlbsrch,

    // / 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚筩trl闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    input wire flush,
    input wire pause,

    // 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚箂table counter闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    input wire [63:0] cnt_i,

    // 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚筪ispatch闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    input wire [31:0] pc1_i,
    input wire [31:0] pc2_i,
    input wire sort1_i,
    input wire sort2_i,
    input wire [31:0] inst1_i,
    input wire [31:0] inst2_i,
    input wire [1:0] valid_i,

    input wire [3:0] is_exception1_i,
    input wire [3:0] is_exception2_i,
    input wire [6:0] pc_exception_cause1_i,     
    input wire [6:0] pc_exception_cause2_i,      
    input wire [6:0] instbuffer_exception_cause1_i,
    input wire [6:0] instbuffer_exception_cause2_i,
    input wire [6:0] decoder_exception_cause1_i,
    input wire [6:0] decoder_exception_cause2_i,
    input wire [6:0] dispatch_exception_cause1_i,
    input wire [6:0] dispatch_exception_cause2_i,

    input wire [1:0] is_privilege_i,

    input wire icacop_en1_i,
    input wire icacop_en2_i,
    input wire dcacop_en1_i,
    input wire dcacop_en2_i,
    input wire [4:0] cacop_opcode1_i,
    input wire [4:0] cacop_opcode2_i,

    input wire [7:0] aluop1_i,
    input wire [7:0] aluop2_i,
    input wire [2:0] alusel1_i,
    input wire [2:0] alusel2_i,

    input wire [1:0]  is_div_i,
    input wire [1:0]  is_mul_i,

    input wire [31:0] reg_data1_1_i,        // 闁跨喍鑼庢潏鐐闁跨喐鏋婚幏鐑芥晸缁愭牠娼婚幏鐑芥晸閺傘倖瀚归柨鐔惰寧绾板瀚?1闁跨喐鏋婚幏閿嬪瘹闁跨喐鏋婚幏鐑芥晸閿燂拷??????1闁跨喐鏋婚幏閿嬬爱闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    input wire [31:0] reg_data1_2_i,        // 闁跨喍鑼庢潏鐐闁跨喐鏋婚幏鐑芥晸缁愭牠娼婚幏鐑芥晸閺傘倖瀚归柨鐔惰寧绾板瀚?1闁跨喐鏋婚幏閿嬪瘹闁跨喐鏋婚幏鐑芥晸閿燂拷??????2闁跨喐鏋婚幏閿嬬爱闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    input wire [31:0] reg_data2_1_i,        // 闁跨喍鑼庢潏鐐闁跨喐鏋婚幏鐑芥晸缁愭牠娼婚幏鐑芥晸閺傘倖瀚归柨鐔惰寧绾板瀚?2闁跨喐鏋婚幏閿嬪瘹闁跨喐鏋婚幏鐑芥晸閿燂拷??????1闁跨喐鏋婚幏閿嬬爱闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    input wire [31:0] reg_data2_2_i,        // 闁跨喍鑼庢潏鐐闁跨喐鏋婚幏鐑芥晸缁愭牠娼婚幏鐑芥晸閺傘倖瀚归柨鐔惰寧绾板瀚?2闁跨喐鏋婚幏閿嬪瘹闁跨喐鏋婚幏鐑芥晸閿燂拷??????2闁跨喐鏋婚幏閿嬬爱闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    input wire [1:0] reg_write_en_i,           // 闁跨喍鑼庢潏鐐闁跨喐鏋婚幏宄板晸娴ｅ潡鏁撻弬銈嗗
    input wire [4:0] reg_write_addr1_i,        //  闁跨喍鑼庢潏鐐闁跨喐鏋婚幏宄板晸闁跨喐鏋婚幏宄版絻
    input wire [4:0] reg_write_addr2_i,        //闁跨喍鑼庢潏鐐闁跨喐鏋婚幏宄板晸闁跨喐鏋婚幏宄版絻

    input wire [31:0] csr_read_data1_i,     // csr闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    input wire [31:0] csr_read_data2_i,     // csr闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    input wire [1:0]  csr_write_en_i,       // csr閸愭瑤濞????
    input wire [13:0] csr_addr1_i,          // csr闁跨喐鏋婚幏宄版絻
    input wire [13:0] csr_addr2_i,          // csr闁跨喐鏋婚幏宄版絻


    input wire [4:0] invtlb_op1_i,
    input wire [4:0] invtlb_op2_i,

    input wire [1:0] pre_is_branch_taken_i,       //妫板嫰鏁撻弬銈嗗闁跨喕顢滄闂堚晜瀚归柨鐔告灮閹烽攱鐟洪柨鐔告灮閹风兘鏁撻梼璁规嫹
    input wire [31:0] pre_branch_addr1_i,         // 妫板嫰鏁撻弬銈嗗闁跨喕顢滄闂堚晜瀚归柨鐔告灮閹风兘鏁撻梼棰濅悍閹风兘鏁撶悰妤嬫嫹
    input wire [31:0] pre_branch_addr2_i,         // 妫板嫰鏁撻弬銈嗗闁跨喕顢滄闂堚晜瀚归柨鐔告灮閹风兘鏁撻梼棰濅悍閹风兘鏁撶悰妤嬫嫹

    
    // 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚筸em闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    input wire pause_mem_i,

    // 闁跨喐鏋婚幏绌宑ache闁跨喍鑼庨弬銈嗗???
    input wire dcache_pause_i,       // ???/闁跨喐鏋婚幏绌宎che 闁跨喐鏋婚幏宄颁粻闁跨喕鍓奸悮瀛樺 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚筪ache闁跨喐鏋婚幏绌ite_finish???          
      
    output wire ren_o,                // dcache闁跨喐鏋婚幏铚傚▏闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    output wire [3:0]  wstrb_o,              // dcache閸愭瑤濞囬柨鐔告灮閹风兘鏁撻弬銈嗗???
    output wire wen_o,
    output wire [31:0] virtual_addr_o,      // dcache闁跨喐鏋婚幏鐑芥晸閺傘倖瀚归柨鐔活敎閿燂拷???
    output wire [31:0] wdata_o,             // dcache閸愭瑩鏁撻弬銈嗗???
    output wire llw_to_dcache,
    output wire scw_to_dcache,


    // 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚归柨鐔活潡鐢喗瀚圭拠鎾晸閺傘倖瀚归挊鏇㈡晸閿燂拷???
    output wire [1:0]  ex_bpu_is_bj,
    output wire [31:0] ex_pc1,
    output wire [31:0] ex_pc2,
    output wire [1:0]  ex_bpu_taken_or_not_actual,
    output wire [31:0] ex_bpu_branch_actual_addr1,
    output wire [31:0] ex_bpu_branch_actual_addr2,
    output wire [31:0] ex_bpu_branch_pred_addr1,     // pred闁跨喕顫楃拠褎瀚归柨鐔活潡鐠囇勫鐟曚線鏁撻弬銈嗗
    output wire [31:0] ex_bpu_branch_pred_addr2,

    // 閿燂拷??????闁跨喐鏋婚幏绌宨spatch闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    output wire [7:0]  pre_ex_aluop1_o,
    output wire [7:0]  pre_ex_aluop2_o,
    output wire [1:0]  reg_write_en_o,
    output wire [4:0] reg_write_addr1_o,
    output wire [4:0] reg_write_addr2_o,
    output wire [31:0] reg_write_data1_o,
    output wire [31:0] reg_write_data2_o,
    
    // 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚归柨鐔虹trl闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    output wire   pause_ex_o,
    output wire   branch_flush_o,
    output wire   ex_excp_flush_o,
    output wire [31:0] branch_target_o,

    // 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚归柨鐔轰腹em闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    output reg [1:0] valid_mem,

    output reg [31:0] pc1_mem,
    output reg [31:0] pc2_mem,
    output reg [63:0] count_64_mem1,
    output reg [63:0] count_64_mem2,
    output reg [31:0] inst1_mem,
    output reg [31:0] inst2_mem,

    output reg [4:0] is_exception1_o,      
    output reg [4:0] is_exception2_o, 

    output reg [6:0] pc_exception_cause1_o, 
    output reg [6:0] pc_exception_cause2_o,
    output reg [6:0] instbuffer_exception_cause1_o,
    output reg [6:0] instbuffer_exception_cause2_o,
    output reg [6:0] decoder_exception_cause1_o,
    output reg [6:0] decoder_exception_cause2_o,
    output reg [6:0] dispatch_exception_cause1_o,
    output reg [6:0] dispatch_exception_cause2_o,
    output reg [6:0] execute_exception_cause1_o,
    output reg [6:0] execute_exception_cause2_o,

    output reg [7:0] aluop1_mem,
    output reg [7:0] aluop2_mem,

    output reg [1:0]  reg_write_en_mem,
    output reg [4:0]  reg_write_addr1_mem,
    output reg [4:0]  reg_write_addr2_mem,
    output reg [31:0] reg_write_data1_mem, 
    output reg [31:0] reg_write_data2_mem,

    output reg [31:0] addr1_mem,
    output reg [31:0] addr2_mem,
    output reg [31:0] data1_mem,
    output reg [31:0] data2_mem,

    output reg [1:0]  csr_write_en_mem,
    output reg [13:0] csr_addr1_mem,
    output reg [13:0] csr_addr2_mem,
    output reg [31:0] csr_write_data1_mem,
    output reg [31:0] csr_write_data2_mem,

    output reg [1:0] is_privilege_mem,
    output reg [1:0] is_ertn_mem,
    output reg [1:0] is_idle_mem,
    output reg [1:0] is_llw_scw_mem,
    output reg       is_llw_mem,        // to dcache & mem
    output reg       is_scw_mem,        // to dcache

    output reg [1:0] icacop_en_mem,

    //cacop
    output wire icacop_en, 
    output wire dcacop_en,
    output wire [1:0] cacop_mode,
    output wire [31:0] cache_cacop_vaddr,   // to addr_trans

    //tlb
    output reg [18:0] ex_invtlb_vpn,
    output reg [9:0]  ex_invtlb_asid,
    output reg ex_invtlb,
    output reg ex_tlbrd,
    output reg ex_tlbfill,
    output reg ex_tlbwr,
    output reg ex_tlbsrch,
    output reg [4:0]ex_invtlb_op,

    output reg [31:0] st_write_data1,     // to difftest
    output reg [31:0] st_write_data2
);

    wire [1:0] pause_alu;

    // 闁跨喖鍙洪崙銈嗗閺?顖烆暕闁跨喐鏋婚幏鐑芥晸閺傘倖瀚归柨鐔峰建閸忓磭顣幏鐑芥晸閺傘倖瀚????
    wire [1:0] branch_flush_alu_o;
    wire [1:0] branch_flush_alu;
    wire [31:0] branch_target_addr_alu1;
    wire [31:0] branch_target_addr_alu2;

    wire [1:0] update_en_alu;
    wire [1:0] taken_or_not_actual_alu;
    wire [31:0] branch_actual_addr_alu1;
    wire [31:0] branch_actual_addr_alu2;
    wire [31:0] pc_dispatch_alu1;
    wire [31:0] pc_dispatch_alu2;

    wire [18:0] invtlb_vpn;
    wire [9:0]  invtlb_asid;
    wire invtlb;
    wire tlbrd;
    wire tlbfill;
    wire tlbwr;
    wire tlbsrch;
    wire [4:0]invtlb_op;

/*************************************
    // 闁跨喐鏋婚幏绌媋che闁跨喎褰ㄩ崗宕囶暜閹风兘鏁撻弬銈嗗???
    wire [1:0] is_cacop_alu;
    wire [4:0] cacop_code_alu1;
    wire [4:0] cacop_code_alu2;
    wire [1:0] is_preld_alu;
    wire [1:0] hint_alu;
    wire [31:0] addr_alu;

*************************************/

    wire [1:0] valid_o;

    wire [1:0] op;
    wire addr_ok;
    wire [31:0] virtual_addr1;
    wire [31:0] virtual_addr2;
    wire [31:0] wdata1;
    wire [31:0] wdata2;
    wire ren1;
    wire ren2;
    wire [3:0] wstrb1;
    wire [3:0] wstrb2;
    wire wen1;
    wire wen2;

    // to mem
    wire [1:0] valid_mem_o;
    wire [31:0] pc1;
    wire [31:0] pc2;
    wire [31:0] inst1;
    wire [31:0] inst2;

    wire [4:0] is_exception1;
    wire [4:0] is_exception2;
    wire [6:0] pc_exception_cause1;
    wire [6:0] pc_exception_cause2;
    wire [6:0] instbuffer_exception_cause1;
    wire [6:0] instbuffer_exception_cause2;
    wire [6:0] decoder_exception_cause1;
    wire [6:0] decoder_exception_cause2;
    wire [6:0] dispatch_exception_cause1;
    wire [6:0] dispatch_exception_cause2;
    wire [6:0] execute_exception_cause1;
    wire [6:0] execute_exception_cause2;

    wire [1:0] is_privilege;
    wire [1:0] is_ert;
    wire [1:0] is_idle;
    wire is_llw_mem1;
    wire is_llw_mem2;   
    wire is_scw_mem1;
    wire is_scw_mem2;   

    wire [1:0] reg_write_en;
    wire [4:0] reg_write_addr1;
    wire [4:0] reg_write_addr2;
    wire [31:0] reg_write_data1; 
    wire [31:0] reg_write_data2; 

    wire [7:0] aluop1;
    wire [7:0] aluop2;

    wire [31:0] addr1;
    wire [31:0] addr2;
    wire [31:0] data1;
    wire [31:0] data2;

    wire [1:0] csr_write_en;
    wire [13:0] csr_addr1;
    wire [13:0] csr_addr2;
    wire [31:0] csr_write_data1;
    wire [31:0] csr_write_data2;

    wire [1:0] is_llw_scw;

    wire       dcache_pause;

    assign dcache_pause = dcache_pause_i;

    assign ren_o   = dcache_pause_i ? 1'b0 : (valid_o[0] ? ren1 : ren2);
    assign wstrb_o = dcache_pause_i ? 4'h0 : (valid_o[0] ? wstrb1 : wstrb2);
    assign wen_o   = dcache_pause_i ? 1'b0 : (valid_o[0] ? wen1 : wen2);
    assign virtual_addr_o = dcache_pause_i ? 32'h0 : (aluop1 == `ALU_TLBSRCH ? {vppn_in,13'b0} : virtual_addr1);
    assign wdata_o = dcache_pause_i ? 32'b0 : (valid_o[0] ? wdata1 : wdata2);

    assign is_tlbsrch = (aluop1 == `ALU_TLBSRCH) & valid_i[0];

/*
    reg [31:0] llw_scw_addr;
    always @(posedge clk) begin
        if (rst)                        llw_scw_addr <= 32'b0;
        else if (aluop1 == `ALU_LLW)    llw_scw_addr <= virtual_addr_o;
    end
*/  
    assign llw_to_dcache = is_llw_mem;
    assign scw_to_dcache = is_scw_mem;

    alu u_alu_1 (
        .dcache_pause(dcache_pause),
        // 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚?
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .pause_mem_i(pause_mem_i),

        // from dispatch
        .pc_i(pc1_i),
        .inst_i(inst1_i),

        .is_exception_i(is_exception1_i),
        .pc_exception_cause_i(pc_exception_cause1_i),
        .instbuffer_exception_cause_i(instbuffer_exception_cause1_i),
        .decoder_exception_cause_i(decoder_exception_cause1_i),
        .dispatch_exception_cause_i(dispatch_exception_cause1_i),

        .is_privilege_i(is_privilege_i[0]),
        
        .icacop_en_i(icacop_en1_i),
        .dcacop_en_i(dcacop_en1_i),
        
        .valid_i(valid_i[0]),

        .aluop_i(aluop1_i),
        .alusel_i(alusel1_i),

        .is_div_i(is_div_i[0]),
        .is_mul_i(is_mul_i[0]),

        .reg_data1_i(reg_data1_1_i),
        .reg_data2_i(reg_data1_2_i),
        .reg_write_en_i(reg_write_en_i[0]),
        .reg_write_addr_i(reg_write_addr1_i),

        .csr_read_data_i(csr_read_data1_i),
        .csr_write_en_i(csr_write_en_i[0]),
        .csr_addr_i(csr_addr1_i),

        .invtlb_op_i(invtlb_op1_i),

        .pre_is_branch_taken_i(pre_is_branch_taken_i[0]),
        .pre_branch_addr_i(pre_branch_addr1_i),


        // from stable counter
        .cnt_i(cnt_i),

        // 闁跨喐鏋婚幏鐑芥晸閿燂拷???
        // with dache
        .valid_o(valid_o[0]),
        .virtual_addr_o(virtual_addr1),
        .ren_o(ren1),
        .wdata_o(wdata1),
        .wstrb_o(wstrb1),
        .wen_o(wen1),

        // to bpu
        .taken_or_not_actual_o(taken_or_not_actual_alu[0]),
        .branch_actual_addr_o(branch_actual_addr_alu1),
        .pc_dispatch_o(pc_dispatch_alu1),

        // to ctrl
        .pause_alu_o(pause_alu[0]),
        .branch_flush_o(branch_flush_alu_o[0]),
        .branch_target_addr_o(branch_target_addr_alu1),
        
        // to dispatch
        .pre_ex_aluop_o(pre_ex_aluop1_o),
        
        /*to Cache*********************闁跨喐鏋婚幏铚傜闁跨喍绮欓柈鑺ョ梾闁跨喐鏋婚敓锟????****************************************
        .is_cacop_o(is_cacop_alu[0]),
        .cacop_code_o(cacop_code_alu[0]),
        .is_preld_o(is_preld_alu[0]),
        .hint_o(hint_alu[0]),
        .addr_o(addr_alu[0]),
        *******************************************************************************/
        // to mem
        .pc_mem(pc1),
        .inst_mem(inst1),

        .is_exception_o(is_exception1),
        .pc_exception_cause_o(pc_exception_cause1),
        .instbuffer_exception_cause_o(instbuffer_exception_cause1),
        .decoder_exception_cause_o(decoder_exception_cause1),
        .dispatch_exception_cause_o(dispatch_exception_cause1),
        .execute_exception_cause_o(execute_exception_cause1),

        .is_privilege_mem(is_privilege[0]),
        .is_ertn_mem(is_ert[0]),
        .is_idle_mem(is_idle[0]),
        .valid_mem(valid_mem_o[0]),
        .reg_write_en_mem(reg_write_en[0]),
        .reg_write_addr_mem(reg_write_addr1),
        .reg_write_data_mem(reg_write_data1),
        .aluop_mem(aluop1),
        .addr_mem(addr1),
        .data_mem(data1),
        .csr_write_en_mem(csr_write_en[0]),
        .csr_addr_mem(csr_addr1),
        .csr_write_data_mem(csr_write_data1),//////////////////////////////////
        .is_llw_scw_mem(is_llw_scw[0]),
        .is_llw_mem(is_llw_mem1),
        .is_scw_mem(is_scw_mem1)
    );

    alu u_alu_2 (
        .dcache_pause(dcache_pause),
        // 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚?
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .pause_mem_i(pause_mem_i),

        // from dispatch
        .pc_i(pc2_i),
        .inst_i(inst2_i),

        .is_exception_i(is_exception2_i),
        .pc_exception_cause_i(pc_exception_cause2_i),
        .instbuffer_exception_cause_i(instbuffer_exception_cause2_i),
        .decoder_exception_cause_i(decoder_exception_cause2_i),
        .dispatch_exception_cause_i(dispatch_exception_cause2_i),
        
        .is_privilege_i(is_privilege_i[1]),
        
        .icacop_en_i(icacop_en2_i),
        .dcacop_en_i(dcacop_en2_i),
        
        .valid_i(valid_i[1]),

        .aluop_i(aluop2_i),
        .alusel_i(alusel2_i),

        .reg_data1_i(reg_data2_1_i),
        .reg_data2_i(reg_data2_2_i),
        .reg_write_en_i(reg_write_en_i[1]),
        .reg_write_addr_i(reg_write_addr2_i),

        .csr_read_data_i(csr_read_data2_i),
        .csr_write_en_i(csr_write_en_i[1]),
        .csr_addr_i(csr_addr2_i),

        .invtlb_op_i(invtlb_op2_i),

        .pre_is_branch_taken_i(pre_is_branch_taken_i[1]),
        .pre_branch_addr_i(pre_branch_addr2_i),

        .is_div_i(is_div_i[1]),
        .is_mul_i(is_mul_i[1]),

        // from stable counter
        .cnt_i(cnt_i),

        // 闁跨喐鏋婚幏鐑芥晸閿燂拷???
        // with dache
        .valid_o(valid_o[1]),
        .virtual_addr_o(virtual_addr2),
        .ren_o(ren2),
        .wdata_o(wdata2),
        .wstrb_o(wstrb2),
        .wen_o(wen2),

        // to bpu
        .taken_or_not_actual_o(taken_or_not_actual_alu[1]),
        .branch_actual_addr_o(branch_actual_addr_alu2),
        .pc_dispatch_o(pc_dispatch_alu2),

        // to ctrl
        .pause_alu_o(pause_alu[1]),
        .branch_flush_o(branch_flush_alu_o[1]),
        .branch_target_addr_o(branch_target_addr_alu2),
        
        // to dispatch
        .pre_ex_aluop_o(pre_ex_aluop2_o),
        
        /* to Cache*****闁跨喐鏋婚幏鐑芥晸閻偅浜堕敓锟????***********************************************************

        .is_cacop_o(is_cacop_alu[1]),
        .cacop_code_o(cacop_code_alu[1]),
        .is_preld_o(is_preld_alu[1]),
        .hint_o(hint_alu[1]),
        .addr_o(addr_alu[1]),

        ***************************************************************************/
        // to mem
        .pc_mem(pc2),
        .inst_mem(inst2),

        .is_exception_o(is_exception2),
        .pc_exception_cause_o(pc_exception_cause2),
        .instbuffer_exception_cause_o(instbuffer_exception_cause2),
        .decoder_exception_cause_o(decoder_exception_cause2),
        .dispatch_exception_cause_o(dispatch_exception_cause2),
        .execute_exception_cause_o(execute_exception_cause2),

        .is_privilege_mem(is_privilege[1]),
        .is_ertn_mem(is_ert[1]),
        .is_idle_mem(is_idle[1]),
        .valid_mem(valid_mem_o[1]),
        .reg_write_en_mem(reg_write_en[1]),
        .reg_write_addr_mem(reg_write_addr2),
        .reg_write_data_mem(reg_write_data2),
        .aluop_mem(aluop2),
        .addr_mem(addr2),
        .data_mem(data2),
        .csr_write_en_mem(csr_write_en[1]),
        .csr_addr_mem(csr_addr2),
        .csr_write_data_mem(csr_write_data2),
        .is_llw_scw_mem(is_llw_scw[1]),
        .is_llw_mem(is_llw_mem2),
        .is_scw_mem(is_scw_mem2)
    );

    // 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚归柨鐔告灮閹峰嘲澧犻柨鐔峰绾板瀚归柨鐔告灮閿燂拷??????
    assign ex_bpu_is_bj[0] = alusel1_i == `ALU_SEL_JUMP_BRANCH;
    assign ex_bpu_is_bj[1] = alusel2_i == `ALU_SEL_JUMP_BRANCH;
    assign ex_pc1 = pc1_i;
    assign ex_pc2 = pc2_i;
    assign ex_bpu_taken_or_not_actual = taken_or_not_actual_alu;
    assign ex_bpu_branch_actual_addr1 = branch_actual_addr_alu1;
    assign ex_bpu_branch_actual_addr2 = branch_actual_addr_alu2;
    assign ex_bpu_branch_pred_addr1   = pre_branch_addr1_i;
    assign ex_bpu_branch_pred_addr2   = pre_branch_addr2_i;


    // 閿燂拷??????闁跨喐鏋婚敓锟???? dispatch 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    assign reg_write_en_o[0] = reg_write_en[0];
//    assign reg_write_en_o[1] = (branch_flush_alu[0] | (taken_or_not_actual_alu[0] & (pc2 != branch_target_addr_alu1))) ? 1'b0 : reg_write_en[1];
    assign reg_write_en_o[1] = (branch_actual_addr_alu1 != pc2) ? 1'b0 : reg_write_en[1];
    assign reg_write_addr1_o   = reg_write_addr1;
    assign reg_write_addr2_o   = reg_write_addr2;
    assign reg_write_data1_o   = reg_write_data1;
    assign reg_write_data2_o   = reg_write_data2;


    //cacop
    assign icacop_en         = icacop_en1_i | icacop_en2_i;
    assign dcacop_en         = dcacop_en1_i | dcacop_en2_i;
    assign cacop_mode        = (icacop_en1_i | dcacop_en1_i) ? cacop_opcode1_i[4:3] : cacop_opcode2_i[4:3];
    assign cache_cacop_vaddr = (icacop_en1_i | dcacop_en1_i) ? reg_write_data1 : reg_write_data2;


    assign invtlb_asid = reg_data1_1_i[9:0];
    assign invtlb_vpn  = reg_data1_2_i[31:13];
    assign invtlb = (aluop1_i == `ALU_INVTLB) ? 1'b1 : 1'b0;
    assign tlbrd = (aluop1_i == `ALU_TLBRD) ? 1'b1 : 1'b0;
    assign tlbfill = (aluop1_i == `ALU_TLBFILL) ? 1'b1 : 1'b0;
    assign tlbwr  = (aluop1_i == `ALU_TLBWR) ? 1'b1 : 1'b0;
    assign tlbsrch = (aluop1_i == `ALU_TLBSRCH) ? 1'b1 : 1'b0; 
    assign invtlb_op = inst1_i[4:0];


    // 闁跨喐鏋婚幏鐑芥晸閿燂拷?????? ctrl 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚????
    assign branch_flush_alu = dcacop_en ? 2'b0 : branch_flush_alu_o;

    assign pause_ex_o = |pause_alu;
    /*
    assign branch_flush_o = (((!sort2_i & taken_or_not_actual_alu[1]) | ((valid_i == 2'b01) && taken_or_not_actual_alu[0]) | branch_flush_alu[0] | (branch_flush_alu == 2'b10 & (pc2 == branch_target_addr_alu1)))) && !pause_ex_o && !pause_mem_i;

    assign branch_target_o =  (branch_flush_alu_o[0] | ((valid_i == 2'b01) && taken_or_not_actual_alu[0])) ? branch_target_addr_alu1 : branch_target_addr_alu2;
    */
    assign branch_flush_o = |branch_flush_alu && !pause_ex_o && !pause_mem_i;

    assign branch_target_o = branch_flush_alu[0] ? branch_target_addr_alu1 : branch_target_addr_alu2;
/*
    always @(*)
    begin
        case({taken_or_not_actual_alu,pre_is_branch_taken_i})
        4'b0000:begin
            branch_target_o = 32'b0;
            branch_flush_o = 1'b0;
        end
        4'b0001:begin
            branch_target_o = branch_target_addr_alu1;
            branch_flush_o = !pause_ex_o && !pause_mem_i;
        end
        4'b0010:begin
            branch_target_o = branch_target_addr_alu2;
            branch_flush_o = !pause_ex_o && !pause_mem_i;
        end
        4'b0100:begin
            branch_target_o = branch_target_addr_alu1;
            branch_flush_alu_o = !pause_ex_o && !pause_mem_i;
        end
        4'b0101:begin
            branch_target_o = branch_target_addr_alu1;
            branch_flush_alu_o = (pre_branch_addr1_i != branch_target_addr_alu1) && !pause_ex_o && !pause_mem_i;
        end
        4'b0110:begin
            branch_target_o = branch_target_addr_alu1;
            branch_flush_alu_o = !pause_ex_o && !pause_mem_i;
        end
        4'b0111:begin
            branch_target_o = pre_branch_addr1_i == branch_target_addr_alu1 ? branch_target_addr_alu2 : branch_target_addr_alu1;
            branch_flush_alu_o = (pre_branch_addr1_i != branch_target_addr_alu1) || () && !pause_ex_o && !pause_mem_i
        end
        4'b1000:branch_target_o = 32'b0;
        4'b1001:branch_target_o = branch_target_addr_alu1;
        4'b1010:branch_target_o = branch_target_addr_alu2;
        4'b1011:branch_target_o = branch_target_addr_alu1;

        4'b1100:branch_target_o = 32'b0;
        4'b1101:branch_target_o = branch_target_addr_alu1;
        4'b1110:branch_target_o = branch_target_addr_alu2;
        4'b1111:branch_target_o = branch_target_addr_alu1;
        endcase
    end
*/


/*********************************************************************
    always @(posedge clk) begin
        if (branch_flush_alu[0]) begin      
            update_en_o <= update_en_alu[0];
            taken_or_not_actual_o <= taken_or_not_actual_alu[0];
            branch_actual_addr_o <= branch_actual_addr_alu[0];
            pc_dispatch_o <= pc_dispatch_alu[0];
        end 
        else begin
            update_en_o <= update_en_alu[1];
            taken_or_not_actual_o <= taken_or_not_actual_alu[1];
            branch_actual_addr_o <= branch_actual_addr_alu[1];
            pc_dispatch_o <= pc_dispatch_alu[1];
        end
    end
*********************************************************************/
    wire [4:0] is_exception2_temp = branch_actual_addr_alu1 != pc2 ? 0 : is_exception2;
    assign ex_excp_flush_o = (is_exception1 != 0 || is_exception2_temp != 0 
                            || csr_write_en[0] || csr_write_en[1]
                            || aluop1 == `ALU_ERTN || aluop2 == `ALU_ERTN) 
                            && !pause_ex_o && !pause_mem_i;

    wire ex_mem_pause;
    assign ex_mem_pause = pause_ex_o && !pause_mem_i;

    // to mem
    always @(posedge clk) begin
        if (rst || ex_mem_pause || flush) 
        begin
            pc1_mem <= 32'b0;
            pc2_mem <= 32'b0;
            count_64_mem1 <= 64'b0;
            count_64_mem2 <= 64'b0;
            inst1_mem <= 32'b0;
            inst2_mem <= 32'b0;
            is_exception1_o <= 5'b0;
            is_exception2_o <= 5'b0;
            pc_exception_cause1_o <= 7'b0;    
            pc_exception_cause2_o <= 7'b0;
            instbuffer_exception_cause1_o <= 7'b0;
            instbuffer_exception_cause2_o <= 7'b0;
            decoder_exception_cause1_o <= 7'b0;
            decoder_exception_cause2_o <= 7'b0;
            dispatch_exception_cause1_o <= 7'b0;
            dispatch_exception_cause2_o <= 7'b0;
            execute_exception_cause1_o <= 7'b0;
            execute_exception_cause2_o <= 7'b0; 
            is_privilege_mem <= 2'b0;
            is_ertn_mem      <= 2'b0;
            is_idle_mem      <= 2'b0;
            valid_mem        <= 2'b0;
            reg_write_en_mem <= 2'b0;
            reg_write_addr1_mem <= 5'b0;
            reg_write_addr2_mem <= 5'b0;
            reg_write_data1_mem <= 32'b0;
            reg_write_data2_mem <= 32'b0;
            aluop1_mem <= 8'b0;
            aluop2_mem <= 8'b0;
            addr1_mem  <= 32'b0;
            addr2_mem  <= 32'b0;
            data1_mem  <= 32'b0;
            data2_mem  <= 32'b0;
            csr_write_en_mem <= 2'b0;
            csr_addr1_mem <= 14'b0;
            csr_addr2_mem <= 14'b0;
            csr_write_data1_mem <= 32'b0;
            csr_write_data2_mem <= 32'b0;
            is_llw_scw_mem <= 2'b0;
            is_llw_mem     <= 1'b0;
            is_scw_mem     <= 1'b0;
            icacop_en_mem  <= 2'b0;
            ex_invtlb_asid <= 10'b0;
            ex_invtlb_vpn  <= 19'b0;
            ex_invtlb <= 1'b0;
            ex_tlbrd <= 1'b0;
            ex_tlbfill <= 1'b0;
            ex_tlbwr  <= 1'b0;
            ex_tlbsrch <= 1'b0;

            st_write_data1 <= 32'b0;
            st_write_data2 <= 32'b0;
        end 
        else if (!pause) 
        begin
            if (branch_flush_alu[0] | branch_actual_addr_alu1!=pc2)   //branch_flush_alu[0] can be deleted?
            begin
                pc1_mem <= pc1;
                count_64_mem1 <= cnt_i;
                inst1_mem <= inst1;
                is_exception1_o <= is_exception1;
                pc_exception_cause1_o<= pc_exception_cause1;
                instbuffer_exception_cause1_o <= instbuffer_exception_cause1;
                decoder_exception_cause1_o <= decoder_exception_cause1;
                dispatch_exception_cause1_o <= decoder_exception_cause1;
                execute_exception_cause1_o <= execute_exception_cause1;
                is_privilege_mem[0] <= is_privilege[0];
                is_ertn_mem[0] <= aluop1 == `ALU_ERTN;
                is_idle_mem[0] <= aluop1 == `ALU_IDLE;
                valid_mem[0] <= valid_mem_o[0];
                reg_write_en_mem[0] <= reg_write_en[0];
                reg_write_addr1_mem <= reg_write_addr1;
                reg_write_data1_mem <= reg_write_data1;
                aluop1_mem <= aluop1;
                addr1_mem <= addr1;
                data1_mem <= data1;
                csr_write_en_mem[0] <= csr_write_en[0];
                csr_addr1_mem <= csr_addr1;
                csr_write_data1_mem <= csr_write_data1;
                is_llw_scw_mem[0] <= is_llw_scw[0];
                is_llw_mem        <= is_llw_mem1;
                is_scw_mem        <= is_scw_mem1;
                icacop_en_mem[0]  <= icacop_en1_i;
                st_write_data1 <= wdata1;

                pc2_mem <= 32'b0;
                count_64_mem2 <= 64'b0;
                inst2_mem <= 32'b0;
                is_exception2_o <= 5'b0;
                pc_exception_cause2_o <= 7'b0;
                instbuffer_exception_cause2_o <= 7'b0;
                decoder_exception_cause2_o <= 7'b0;
                dispatch_exception_cause2_o <= 7'b0;
                execute_exception_cause2_o <= 7'b0;
                is_privilege_mem[1] <= 1'b0;
                is_ertn_mem[1] <= 1'b0;
                is_idle_mem[1] <= 1'b0;
                valid_mem[1] <= 1'b0;
                reg_write_en_mem[1] <= 1'b0;
                reg_write_addr2_mem <= 5'b0;
                reg_write_data2_mem <= 32'b0;
                aluop2_mem <= 8'b0;
                addr2_mem <= 32'b0;
                data2_mem <= 32'b0;
                csr_write_en_mem[1] <= 1'b0;
                csr_addr2_mem <= 14'b0;
                csr_write_data2_mem <= 32'b0;
                is_llw_scw_mem[1] <= 1'b0;
                icacop_en_mem[1]  <= 1'b0;

                ex_invtlb_asid <= invtlb_asid;
                ex_invtlb_vpn  <= invtlb_vpn;
                ex_invtlb <= invtlb;
                ex_tlbrd <= tlbrd;
                ex_tlbfill <= tlbfill;
                ex_tlbwr  <= tlbwr;
                ex_tlbsrch <= tlbsrch;
                ex_invtlb_op <= invtlb_op;

                st_write_data2 <= 32'b0;
            end 
            else 
            begin
                pc1_mem <= pc1;
                pc2_mem <= pc2;
                count_64_mem1 <= cnt_i;
                count_64_mem2 <= cnt_i;
                inst1_mem <= inst1;
                inst2_mem <= inst2;
                is_exception1_o <= is_exception1;
                is_exception2_o <= is_exception2;
                pc_exception_cause1_o <= pc_exception_cause1;
                pc_exception_cause2_o <= pc_exception_cause2;
                instbuffer_exception_cause1_o <= instbuffer_exception_cause1;
                instbuffer_exception_cause2_o <= instbuffer_exception_cause2;
                decoder_exception_cause1_o <= decoder_exception_cause1;
                decoder_exception_cause2_o <= decoder_exception_cause2;
                dispatch_exception_cause1_o <= dispatch_exception_cause1;
                dispatch_exception_cause2_o <= dispatch_exception_cause2;
                execute_exception_cause1_o <= execute_exception_cause1;
                execute_exception_cause2_o <= execute_exception_cause2;
                is_privilege_mem[0] <= is_privilege[0];
                is_privilege_mem[1] <= is_privilege[1];
                is_ertn_mem[0] <= aluop1 == `ALU_ERTN;
                is_ertn_mem[1] <= aluop2 == `ALU_ERTN;
                is_idle_mem[0] <= aluop1 == `ALU_IDLE;
                is_idle_mem[1] <= aluop2 == `ALU_IDLE;
                valid_mem[0] <= valid_mem_o[0];
                valid_mem[1] <= valid_mem_o[1];
                reg_write_en_mem[0] <= reg_write_en[0];
                reg_write_en_mem[1] <= reg_write_en[1];
                reg_write_addr1_mem <= reg_write_addr1;
                reg_write_addr2_mem <= reg_write_addr2;
                reg_write_data1_mem <= reg_write_data1;
                reg_write_data2_mem <= reg_write_data2;
                aluop1_mem <= aluop1;
                aluop2_mem <= aluop2;
                addr1_mem <= addr1;
                addr2_mem <= addr2;
                data1_mem <= data1;
                data2_mem <= data2;
                csr_write_en_mem[0] <= csr_write_en[0];
                csr_write_en_mem[1] <= csr_write_en[1];
                csr_addr1_mem <= csr_addr1;
                csr_addr2_mem <= csr_addr2;
                csr_write_data1_mem <= csr_write_data1;
                csr_write_data2_mem <= csr_write_data2;
                is_llw_scw_mem[0] <= is_llw_scw[0];
                is_llw_scw_mem[1] <= is_llw_scw[1];
                is_llw_mem        <= is_llw_mem1;
                is_scw_mem        <= is_scw_mem1;
                icacop_en_mem[0]  <= icacop_en1_i;
                icacop_en_mem[1]  <= icacop_en2_i;
                
                ex_invtlb_asid <= invtlb_asid;
                ex_invtlb_vpn  <= invtlb_vpn;
                ex_invtlb <= invtlb;
                ex_tlbrd <= tlbrd;
                ex_tlbfill <= tlbfill;
                ex_tlbwr  <= tlbwr;
                ex_tlbsrch <= tlbsrch;
                ex_invtlb_op <= invtlb_op;
                
                st_write_data1 <= wdata1;
                st_write_data2 <= wdata2;
            end
        end 
        else 
        begin
            pc1_mem <= pc1_mem;
            pc2_mem <= pc2_mem;
            count_64_mem1 <= count_64_mem1;
            count_64_mem2 <= count_64_mem2;
            inst1_mem <= inst1_mem;
            inst2_mem <= inst2_mem;
            is_exception1_o <= is_exception1_o;
            is_exception2_o <= is_exception2_o;
            pc_exception_cause1_o <= pc_exception_cause1_o;
            pc_exception_cause2_o <= pc_exception_cause2_o;
            instbuffer_exception_cause1_o <= instbuffer_exception_cause1_o;
            instbuffer_exception_cause2_o <= instbuffer_exception_cause2_o;
            decoder_exception_cause1_o <= decoder_exception_cause1_o;
            decoder_exception_cause2_o <= decoder_exception_cause2_o;
            dispatch_exception_cause1_o <= dispatch_exception_cause1_o;
            dispatch_exception_cause2_o <= dispatch_exception_cause2_o;
            execute_exception_cause1_o <= execute_exception_cause1_o;
            execute_exception_cause2_o <= execute_exception_cause2_o;
            is_privilege_mem[0] <= is_privilege_mem[0];
            is_privilege_mem[1] <= is_privilege_mem[1];
            is_ertn_mem[0] <= is_ertn_mem[0];
            is_ertn_mem[1] <= is_ertn_mem[1];
            is_idle_mem[0] <= is_idle_mem[0];
            is_idle_mem[1] <= is_idle_mem[1];
            valid_mem[0] <= valid_mem[0];
            valid_mem[1] <= valid_mem[1];
            reg_write_en_mem[0] <= reg_write_en_mem[0];
            reg_write_en_mem[1] <= reg_write_en_mem[1];
            reg_write_addr1_mem <= reg_write_addr1_mem;
            reg_write_addr2_mem <= reg_write_addr2_mem;
            reg_write_data1_mem <= reg_write_data1_mem;
            reg_write_data2_mem <= reg_write_data2_mem;
            aluop1_mem <= aluop1_mem;
            aluop2_mem <= aluop2_mem;
            addr1_mem <= addr1_mem;
            addr2_mem <= addr2_mem;
            data1_mem <= data1_mem;
            data2_mem <= data2_mem;
            csr_write_en_mem[0] <= csr_write_en_mem[0];
            csr_write_en_mem[1] <= csr_write_en_mem[1];
            csr_addr1_mem <= csr_addr1_mem;
            csr_addr2_mem <= csr_addr2_mem;
            csr_write_data1_mem <= csr_write_data1_mem;
            csr_write_data2_mem <= csr_write_data2_mem;
            is_llw_scw_mem[0] <= is_llw_scw_mem[0];
            is_llw_scw_mem[1] <= is_llw_scw_mem[1];
            is_llw_mem        <= is_llw_mem;
            is_scw_mem        <= is_scw_mem;
            icacop_en_mem <= icacop_en_mem;
            ex_invtlb_asid <= ex_invtlb_asid;
            ex_invtlb_vpn  <= ex_invtlb_vpn;
            ex_invtlb <= ex_invtlb;
            ex_tlbrd <= ex_tlbrd;
            ex_tlbfill <= ex_tlbfill;
            ex_tlbwr  <= ex_tlbwr;
            ex_tlbsrch <= ex_tlbsrch;
            ex_invtlb_op <= ex_invtlb_op;
            st_write_data1 <= st_write_data1;
            st_write_data2 <= st_write_data2;
        end
    end
endmodule