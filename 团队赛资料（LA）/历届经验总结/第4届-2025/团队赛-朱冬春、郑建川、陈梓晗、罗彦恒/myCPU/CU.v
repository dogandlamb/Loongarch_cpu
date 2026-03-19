`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"

module CU
(   
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] csr_tlbrentry_i,

    input  wire        pause_buffer,//娴犲骸澧犵粩顖濈翻閿燂拷?
    input  wire        pause_decode,//娴犲穱ecoder鏉堟挸鍙?
    input  wire        pause_dispatch,//娴犲穱ispatch鏉堟挸鍙?
    input  wire        pause_execute,//娴犲穲xecute鏉堟挸鍙?
    input  wire        pause_mem,//娴犲窇em鏉堟挸鍙?

    input  wire        branch_flush,//閸掑棙鏁捄瀹犳祮閸掗攱鏌婃穱鈥冲娇
    input  wire [31:0] branch_target,//閸掑棙鏁捄瀹犳祮閸︽澘娼冮敍灞肩矤execute闂冭埖顔屾潏鎾冲弳 
    input  wire        ex_excp_flush,//瀵倸鐖堕崚閿嬫煀娣団?冲娇,娴犲穲xecute闂冭埖顔屾潏鎾冲弳

    //wb闂冭埖顔屾潏鎾冲弳wb
    input  wire [1:0]        reg_write_en_i,//閸愭瑥娲栭梼鑸殿唽閸掗攱鏌婃穱鈥冲娇
    input  wire [4:0]        reg_write_addr1_i,//閸愭瑥娲栭梼鑸殿唽鐎靛嫬鐡ㄩ崳銊ユ勾閿燂拷?
    input  wire [4:0]        reg_write_addr2_i,//閸愭瑥娲栭梼鑸殿唽鐎靛嫬鐡ㄩ崳銊ユ勾閿燂拷?
    input  wire [31:0]       reg_write_data1_i,//閸愭瑥娲栭梼鑸殿唽鐎靛嫬鐡ㄩ崳銊︽殶閿燂拷?
    input  wire [31:0]       reg_write_data2_i,//閸愭瑥娲栭梼鑸殿唽鐎靛嫬鐡ㄩ崳銊︽殶閿燂拷?
    input  wire [1:0]        is_llw_scw_i,//閺勵垰鎯侀敓锟?? llw/scw 閹稿洣鎶? 
    input  wire [1:0]        csr_write_en_i,//csr閸愭瑤濞囬懗鎴掍繆閿燂拷?
    input  wire [13:0]       csr_write_addr1_i,//csr閸愭瑥婀撮敓锟??
    input  wire [13:0]       csr_write_addr2_i,//csr閸愭瑥婀撮敓锟??
    input  wire [31:0]       csr_write_data1_i,//csr閸愭瑦鏆熼敓锟??
    input  wire [31:0]       csr_write_data2_i,//csr閸愭瑦鏆熼敓锟??

    //娴犲窚b闂冭埖顔屾潏鎾冲弳commit
    input wire  [5:0]  is_exception1_i,
    input wire  [5:0]  is_exception2_i,
    input wire  [6:0]  pc_exception_cause1_i,
    input wire  [6:0]  pc_exception_cause2_i, 
    input wire  [6:0]  instbuffer_exception_cause1_i,
    input wire  [6:0]  instbuffer_exception_cause2_i,
    input wire  [6:0]  decoder_exception_cause1_i,
    input wire  [6:0]  decoder_exception_cause2_i,
    input wire  [6:0]  dispatch_exception_cause1_i,
    input wire  [6:0]  dispatch_exception_cause2_i,
    input wire  [6:0]  execute_exception_cause1_i,
    input wire  [6:0]  execute_exception_cause2_i,
    input wire  [6:0]  commit_exception_cause1_i,
    input wire  [6:0]  commit_exception_cause2_i,

    input  wire [31:0]       pc1_i,
    input  wire [31:0]       pc2_i,
    input  wire [63:0]       count_64_i1,
    input  wire [63:0]       count_64_i2,
    input  wire [31:0]       refetch_target_pc_i,
    input  wire [31:0]       mem_addr1_i,
    input  wire [31:0]       mem_addr2_i,
    input  wire [1:0]        is_idle_i,//閺勵垰鎯佹径鍕艾缁屾椽妫介悩璁规嫹??
    input  wire [1:0]        is_ertn_i,//閺勵垰鎯侀弰顖氱磽鐢瓕绻戦崶鐐村瘹閿燂拷?
    input  wire [1:0]        is_privilege_i,//閺勵垰鎯侀弰顖滃閺夊啯瀵氶敓锟??
    input  wire [1:0]        icacop_en_i,
    input  wire [1:0]        valid_i,//閹稿洣鎶ら弰顖氭儊閺堝鏅?
    //csr
    output wire              is_ertn_o,//閺勵垰鎯侀弰顖氱磽鐢瓕绻戦崶鐐村瘹閿燂拷?
    //
    output wire [7:0]  flush,//閸掗攱鏌婃穱鈥冲娇
    output wire [7:0]  pause,//閺嗗倸浠犳穱鈥冲娇
    output wire [31:0] new_pc,//閺傛壆娈慞C閸︽澘娼?

    //to regfile
    output reg  [1:0]  reg_write_en_o,//閸愭瑥娲栭梼鑸殿唽閸掗攱鏌婃穱鈥冲娇
    output reg  [4:0]  reg_write_addr1_o,//閸愭瑥娲栭梼鑸殿唽鐎靛嫬鐡ㄩ崳銊ユ勾閿燂拷?
    output reg  [4:0]  reg_write_addr2_o,//閸愭瑥娲栭梼鑸殿唽鐎靛嫬鐡ㄩ崳銊ユ勾閿燂拷?
    output reg  [31:0] reg_write_data1_o,//閸愭瑥娲栭梼鑸殿唽鐎靛嫬鐡ㄩ崳銊︽殶閿燂拷?
    output reg  [31:0] reg_write_data2_o,//閸愭瑥娲栭梼鑸殿唽鐎靛嫬鐡ㄩ崳銊︽殶閿燂拷?

    //to csr
    output wire is_llw_scw_o,//閺勵垰鎯侀敓锟?? llw/scw 閹稿洣鎶?
    output wire  csr_write_en_o,//csr閸愭瑤濞囬懗鎴掍繆閿燂拷?
    output wire [13:0] csr_write_addr_o,//csr閸愭瑥婀撮敓锟??
    output wire [31:0] csr_write_data_o,//csr閸愭瑦鏆熼敓锟??

    // with csr
    input wire [31:0] csr_eentry_i, //瀵倸鐖堕崗銉ュ經閸︽澘娼?
    input wire [31:0] csr_era_i, //瀵倸鐖舵潻鏂挎礀閸︽澘娼?
    input wire [31:0] csr_crmd_i, //閹貉冨煑鐎靛嫬鐡ㄩ敓锟?? 
    input wire        csr_is_interrupt_i, //閺勵垰鎯侀弰顖欒厬閿燂拷?
    
    output wire        csr_is_exception_o, //閺勵垰鎯侀弰顖氱磽閿燂拷?
    output wire [31:0] csr_exception_pc_o, //瀵倸鐖禤C閸︽澘娼?
    output wire [31:0] csr_exception_addr_o, //瀵倸鐖堕崷鏉挎絻
    output reg  [5:0]  csr_ecode_o, //瀵倸鐖秂code
    output wire [6:0]  csr_exception_cause_o, //瀵倸鐖堕崢鐔锋礈
    output reg  [8:0]  csr_esubcode_o, //瀵倸鐖剁?涙劗鐖?

    output wire csr_is_inst_tlb_exception_o, 
    output wire csr_is_tlb_exception_o,

    input wire [18:0] wb_invtlb_vpn,
    input wire [9:0]  wb_invtlb_asid,
    input wire wb_invtlb,
    input wire wb_tlbrd,
    input wire wb_tlbfill,
    input wire wb_tlbwr,
    input wire wb_tlbsrch,
    input wire [4:0]wb_invtlb_op,
    input wire wb_tlb_found,
    input wire [4:0] wb_tlb_index,
    output wire [18:0] invtlb_vpn,
    output wire [9:0]  invtlb_asid,
    output wire invtlb,
    output wire tlbrd,
    output wire tlbfill,
    output wire tlbwr,
    output wire tlbsrch,
    output wire [4:0]invtlb_op,
    output wire tlb_found,
    output wire [4:0] tlb_index,

    output reg [63:0] count_64_o1,
    output reg [63:0] count_64_o2

    // difftest
    `ifdef DIFF
    ,
    input wire [`DIFF_WIDTH-1:0] ctrl_diff0_i,
    input wire [`DIFF_WIDTH-1:0] ctrl_diff1_i,

    output reg [`DIFF_WIDTH-1:0] ctrl_diff0_o,
    output reg [`DIFF_WIDTH-1:0] ctrl_diff1_o,
    output wire diff_flush
    `endif
);
    //ertn
    wire ertn_flush;
    assign ertn_flush = is_ertn_i[0]; //娑撹桨绮堟稊鍫濆涧鐟曚胶顑?0閺夆剝瀵氶敓锟??
    assign is_ertn_o = ertn_flush;

    //閺傛壆娈憈arget,refetch闁插秵鏌婇崣鏍ф絻閿燂拷?
    wire refetch_flush;
    wire [31:0] refetch_target;
    assign refetch_target = refetch_target_pc_i; 
    reg [1:0] is_exception;
    assign new_pc = (|is_exception) ? (exception_cause_out == `EXCEPTION_TLBR ? csr_tlbrentry_i : csr_eentry_i) : (ertn_flush ? csr_era_i : (refetch_flush ? refetch_target : branch_target));

    always @(*) begin
        is_exception[0] = valid_i[0] && (is_exception1_i != 6'b0 || csr_is_interrupt_i);
        is_exception[1] = valid_i[1] && (is_exception2_i != 6'b0 || csr_is_interrupt_i);
    end

    assign csr_is_exception_o = |is_exception;

    // cacop
    wire icacop_flush;
    assign icacop_flush =  (icacop_en_i[0] & valid_i[0]) || (icacop_en_i[1] & valid_i[1]);

    //鐠佸墽鐤嗛崥鎴﹀櫤flush
    // flush[0] PC, flush[1] icache, flush[2] instbuffer, flush[3] id
    // flush[4] dispatch, flush[5] ex, flush[6] mem, flush[7] wb
    assign diff_flush = |is_exception || ertn_flush || refetch_flush;
    wire flush_ex_mem = |is_exception || ertn_flush || refetch_flush;
    wire flush_id_dispatch = |is_exception || ertn_flush || branch_flush || ex_excp_flush || refetch_flush;
    wire flush_buffer_icache_pc = |is_exception || ertn_flush || branch_flush || refetch_flush;
    assign flush = {
        flush_ex_mem,
        flush_ex_mem,   //mem
        flush_ex_mem,   //ex
        flush_id_dispatch,  //dispatch
        flush_id_dispatch, //id
        flush_buffer_icache_pc,     //instbuffer
        flush_buffer_icache_pc,     //icache
        flush_buffer_icache_pc    //pc
    };

    always @(*) begin
        reg_write_addr1_o = reg_write_addr1_i;
        reg_write_addr2_o = reg_write_addr2_i;
        reg_write_data1_o = reg_write_data1_i;
        reg_write_data2_o = reg_write_data2_i;
    end

    wire [1:0] reg_write_en_out;
    assign reg_write_en_out[0] = (is_exception[0] || pause[7]) ? 1'b0 : reg_write_en_i[0];
    assign reg_write_en_out[1] = (|is_exception || pause[7]) ? 1'b0 : reg_write_en_i[1];

    always @(*) begin
        if(reg_write_addr1_i == reg_write_addr2_i) begin
            reg_write_en_o[0] = 1'b0;
            reg_write_en_o[1] = reg_write_en_out[1];
        end
        else begin
            reg_write_en_o[0] = reg_write_en_out[0];
            reg_write_en_o[1] = reg_write_en_out[1];
        end
    end

    assign is_llw_scw_o = |is_exception ? 1'b0 : (is_llw_scw_i[0] | is_llw_scw_i[1]);
    assign csr_write_en_o = |is_exception ? 1'b0 : (csr_write_en_i[0] | csr_write_en_i[1]);
    assign csr_write_addr_o = (csr_write_en_i[0] ? csr_write_addr1_i : csr_write_addr2_i);
    assign csr_write_data_o = (csr_write_en_i[0] ? csr_write_data1_i : csr_write_data2_i);
    assign refetch_flush = csr_write_en_o || is_idle_i[0] || is_llw_scw_i[0];

    assign csr_exception_pc_o = is_exception[0] ? pc1_i : pc2_i;
    assign csr_exception_addr_o = is_exception[0] ? mem_addr1_i : mem_addr2_i;

    assign csr_is_inst_tlb_exception_o =  is_exception1_i[5] & valid_i[0] & (pc_exception_cause1_i != `EXCEPTION_ADEF);
    assign csr_is_tlb_exception_o =  csr_is_inst_tlb_exception_o | (is_exception1_i[0] & valid_i[0]);
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    //瀵倸鐖堕柅鐘冲灇閻ㄥ嫬甯敓锟??
    reg  [6:0] exception_cause1;
    reg  [6:0] exception_cause2;

    wire [5:0] inst_is_exception1;
    wire [5:0] inst_is_exception2;

    assign inst_is_exception1 = is_exception1_i;
    assign inst_is_exception2 = is_exception2_i;

    wire [6:0] inst_exception_cause1 [5:0]; 
    wire [6:0] inst_exception_cause2 [5:0];
    assign inst_exception_cause1 [0] = commit_exception_cause1_i;
    assign inst_exception_cause1 [1] = execute_exception_cause1_i;
    assign inst_exception_cause1 [2] = dispatch_exception_cause2_i;
    assign inst_exception_cause1 [3] = decoder_exception_cause1_i;
    assign inst_exception_cause1 [4] = instbuffer_exception_cause1_i; 
    assign inst_exception_cause1 [5] = pc_exception_cause1_i;
    assign inst_exception_cause2 [0] = commit_exception_cause2_i;
    assign inst_exception_cause2 [1] = execute_exception_cause2_i;
    assign inst_exception_cause2 [2] = dispatch_exception_cause2_i;
    assign inst_exception_cause2 [3] = decoder_exception_cause2_i;
    assign inst_exception_cause2 [4] = instbuffer_exception_cause2_i;
    assign inst_exception_cause2 [5] = pc_exception_cause2_i;

    assign  invtlb_vpn = wb_invtlb_vpn;
    assign  invtlb_asid = wb_invtlb_asid;
    assign  invtlb = wb_invtlb;
    assign  tlbrd = wb_tlbrd;
    assign  tlbfill = wb_tlbfill;
    assign  tlbwr = wb_tlbwr;
    assign  tlbsrch = wb_tlbsrch;
    assign  invtlb_op = wb_invtlb_op;
    assign  tlb_found = wb_tlb_found;
    assign  tlb_index = wb_tlb_index;

    wire [6:0] excp_vec1;
    wire [6:0] excp_vec2;
    assign excp_vec1 = {csr_is_interrupt_i, inst_is_exception1};
    assign excp_vec2 = {csr_is_interrupt_i, inst_is_exception2};

    always @(*) begin
        casez(excp_vec1) 
            7'b1??????: exception_cause1 = `EXCEPTION_INT; 
            7'b01?????: exception_cause1 = inst_exception_cause1[5]; 
            7'b001????: exception_cause1 = inst_exception_cause1[4];
            7'b0001???: exception_cause1 = (is_privilege_i[0] && csr_crmd_i[1:0] != 2'b00) ? `EXCEPTION_IPE : inst_exception_cause1[3];
            7'b00001??: exception_cause1 = inst_exception_cause1[2];
            7'b000001?: exception_cause1 = inst_exception_cause1[1];
            7'b0000001: exception_cause1 = inst_exception_cause1[0];
            default:    exception_cause1 = `EXCEPTION_NOP; 
        endcase
    end
    /*
    always @(*) 
    begin
        if (excp_vec1[6])       exception_cause1 = `EXCEPTION_INT; 
        else if (excp_vec1[5])  exception_cause1 = inst_exception_cause1[5]; 
        else if (excp_vec1[4])  exception_cause1 = inst_exception_cause1[4];
        else if (excp_vec1[3])  exception_cause1 = (is_privilege_i[0] && csr_crmd_i[1:0] != 2'b00) ? `EXCEPTION_IPE : inst_exception_cause1[3];
        else if (excp_vec1[2])  exception_cause1 = inst_exception_cause1[2];
        else if (excp_vec1[1])  exception_cause1 = inst_exception_cause1[1];
        else if (excp_vec1[0])  exception_cause1 = inst_exception_cause1[0];
        else                    exception_cause1 = `EXCEPTION_NOP; 
    end
*/
    always @(*) begin
        casez(excp_vec2) 
            7'b1??????: exception_cause2 = `EXCEPTION_INT; 
            7'b01?????: exception_cause2 = inst_exception_cause2[5]; 
            7'b001????: exception_cause2 = inst_exception_cause2[4];
            7'b0001???: exception_cause2 = (is_privilege_i[1] && csr_crmd_i[1:0] != 2'b00) ? `EXCEPTION_IPE : inst_exception_cause2[3];
            7'b00001??: exception_cause2 = inst_exception_cause2[2];
            7'b000001?: exception_cause2 = inst_exception_cause2[1];
            7'b0000001: exception_cause2 = inst_exception_cause2[0];
            default:    exception_cause2 = `EXCEPTION_NOP; 
        endcase
    end
  
    /*
    always @(*) 
    begin
    if (excp_vec2[6]) exception_cause2 = `EXCEPTION_INT;  // 閿燂拷?妤傛ü绱崗鍫㈤獓閿涘潌it6=1閿燂拷?
    else if (excp_vec2[5]) exception_cause2 = inst_exception_cause2[5];  // 濞嗭繝鐝导妯哄帥缁狙嶇礄bit5=1閿燂拷?
    else if (excp_vec2[4]) exception_cause2 = inst_exception_cause2[4];  // bit4=1
    else if (excp_vec2[3]) exception_cause2 = (is_privilege_i[1] && csr_crmd_i[1:0] != 2'b00) ? `EXCEPTION_IPE : inst_exception_cause2[3];
    else if (excp_vec2[2]) exception_cause2 = inst_exception_cause2[2];  // bit2=1
    else if (excp_vec2[1]) exception_cause2 = inst_exception_cause2[1];  // bit1=1
    else if (excp_vec2[0]) exception_cause2 = inst_exception_cause2[0];  // bit0=1
    else exception_cause2 = `EXCEPTION_NOP;  // 姒涙ǹ顓婚幆鍛枌閿涘牊妫ゅ鍌氱埗閿燂拷?
    end
*/
    //瀵倸鐖堕崢鐔锋礈缂傛牜鐖?
    wire [6:0] exception_cause_out;
    assign exception_cause_out = is_exception[0] ? exception_cause1 : exception_cause2;
    assign csr_exception_cause_o = exception_cause_out;

    always @(*) begin
        case (exception_cause_out)
             `EXCEPTION_INT: begin
                csr_ecode_o = 6'h0;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_PIL: begin
                csr_ecode_o = 6'h1;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_PIS: begin
                csr_ecode_o = 6'h2;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_PIF: begin
                csr_ecode_o = 6'h3;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_PME: begin
                csr_ecode_o = 6'h4;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_PPI: begin
                csr_ecode_o = 6'h7;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_ADEF: begin
                csr_ecode_o = 6'h8;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_ADEM: begin
                csr_ecode_o = 6'h8;
                csr_esubcode_o = 9'b1;
            end
            `EXCEPTION_ALE: begin
                csr_ecode_o = 6'h9;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_SYS: begin
                csr_ecode_o = 6'hb;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_BRK: begin
                csr_ecode_o = 6'hc;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_INE: begin
                csr_ecode_o = 6'hd;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_IPE: begin
                csr_ecode_o = 6'he;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_FPD: begin
                csr_ecode_o = 6'hf;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_FPE: begin
                csr_ecode_o = 6'h12;
                csr_esubcode_o = 9'b0;
            end
            `EXCEPTION_TLBR: begin
                csr_ecode_o = 6'h3f;
                csr_esubcode_o = 9'b0;
            end
            default: begin
                csr_ecode_o = 6'h0;
                csr_esubcode_o = 9'b0;
            end
        endcase
    end

    reg idle_lock;
    always @(posedge clk)
    begin
        if(rst) idle_lock <= 1'b0;
        else if(is_idle_i[0] & !csr_is_interrupt_i) idle_lock <= 1'b1;
        else if(csr_is_interrupt_i) idle_lock <= 1'b0;
    end 

    reg [4:0] pause_back;
    wire pause_buffer_temp;
    wire [1:0] pause_front;

    always @(*) begin
        if(pause_mem) begin
            pause_back = 5'b01111;
        end 
        else if (pause_execute) begin
            pause_back = 5'b00111;
        end 
        else if (pause_dispatch) begin
            pause_back = 5'b00011;
        end 
        else if (pause_decode) begin
            pause_back = 5'b00001;
        end 
        else begin
            pause_back = 5'b00000;
        end
    end

    assign pause_buffer_temp = pause_decode ? 1'b1 : 1'b0;
    assign pause_front = idle_lock ? 2'b11 : 2'b00;

    assign pause = {pause_back, pause_buffer_temp, pause_front[1] && !flush[1], pause_front[0]};


    // difftest
    `ifdef DIFF
            wire [31:0] debug_wb_pc1;
            wire [31:0] debug_wb_inst1;
            wire [3:0] debug_wb_rf_wen1;
            wire [4:0] debug_wb_rf_wnum1;
            wire [31:0] debug_wb_rf_wdata1;

            wire inst_valid1;
            wire cnt_inst1;
            wire csr_rstat_en1;
            wire [31:0] csr_data1;

            wire excp_flush1;
            wire ertn_flush1;
            wire [5:0] ecode1;

            wire [7:0] inst_st_en1;
            wire [31:0] st_paddr1;
            wire [31:0] st_vaddr1;
            wire [31:0] st_data1;

            wire [7:0] inst_ld_en1;
            wire [31:0] ld_paddr1;
            wire [31:0] ld_vaddr1;

            wire tlbfill_en1;


            wire [31:0] debug_wb_pc2;
            wire [31:0] debug_wb_inst2;
            wire [3:0] debug_wb_rf_wen2;
            wire [4:0] debug_wb_rf_wnum2;
            wire [31:0] debug_wb_rf_wdata2;

            wire inst_valid2;
            wire cnt_inst2;
            wire csr_rstat_en2;
            wire [31:0] csr_data2;

            wire excp_flush2;
            wire ertn_flush2;
            wire [5:0] ecode2;

            wire [7:0] inst_st_en2;
            wire [31:0] st_paddr2;
            wire [31:0] st_vaddr2;
            wire [31:0] st_data2;

            wire [7:0] inst_ld_en2;
            wire [31:0] ld_paddr2;
            wire [31:0] ld_vaddr2;

            wire tlbfill_en2;

            wire [3:0] debug_wb_rf_wen1_null;
            wire [4:0] debug_wb_rf_wnum1_null;
            wire [31:0] debug_wb_rf_wdata1_null;
            wire inst_valid1_null;
            wire excp_flush1_null;
            wire ertn_flush1_null;
            wire [5:0] ecode1_null;

            wire [3:0] debug_wb_rf_wen2_null;
            wire [4:0] debug_wb_rf_wnum2_null;
            wire [31:0] debug_wb_rf_wdata2_null;
            wire inst_valid2_null;
            wire excp_flush2_null;
            wire ertn_flush2_null;
            wire [5:0] ecode2_null;

            assign {
                    debug_wb_pc1,
                    debug_wb_inst1,
                    debug_wb_rf_wen1_null,
                    debug_wb_rf_wnum1_null,
                    debug_wb_rf_wdata1_null,

                    inst_valid1_null,
                    cnt_inst1,
                    csr_rstat_en1,
                    csr_data1,

                    excp_flush1_null,
                    ertn_flush1_null,
                    ecode1_null,

                    inst_st_en1,
                    st_paddr1,
                    st_vaddr1,
                    st_data1,

                    inst_ld_en1,
                    ld_paddr1,
                    ld_vaddr1,

                    tlbfill_en1} = ctrl_diff0_i;

            assign {
                    debug_wb_pc2,
                    debug_wb_inst2,
                    debug_wb_rf_wen2_null,
                    debug_wb_rf_wnum2_null,
                    debug_wb_rf_wdata2_null,

                    inst_valid2_null,
                    cnt_inst2,
                    csr_rstat_en2,
                    csr_data2,

                    excp_flush2_null,
                    ertn_flush2_null,
                    ecode2,

                    inst_st_en2,
                    st_paddr2,
                    st_vaddr2,
                    st_data2,

                    inst_ld_en2,
                    ld_paddr2,
                    ld_vaddr2,

                    tlbfill_en2} = ctrl_diff1_i;

            assign debug_wb_rf_wen1 = {4{reg_write_en_out[0]}};
            assign debug_wb_rf_wnum1 = reg_write_addr1_o;
            assign debug_wb_rf_wdata1 = reg_write_data1_o;
            assign inst_valid1 = is_exception[0]? 1'b0 : inst_valid1_null;
            assign excp_flush1 = is_exception[0];
            assign ertn_flush1 = ertn_flush;
            assign ecode1 = csr_ecode_o;

            assign debug_wb_rf_wen2 = {4{reg_write_en_out[1]}};
            assign debug_wb_rf_wnum2 = reg_write_addr2_o;
            assign debug_wb_rf_wdata2 = reg_write_data2_o;
            assign inst_valid2 = |is_exception? 1'b0 : inst_valid2_null;
            assign excp_flush2 = is_exception[1];
            assign ertn_flush2 = ertn_flush;
            assign ecode2 = csr_ecode_o;


            wire [`DIFF_WIDTH-1:0] ctrl_diff0_delay;
            wire [`DIFF_WIDTH-1:0] ctrl_diff1_delay;

            assign ctrl_diff0_delay = { debug_wb_pc1,
                                    debug_wb_inst1,
                                    debug_wb_rf_wen1,
                                    debug_wb_rf_wnum1,
                                    debug_wb_rf_wdata1,

                                    inst_valid1,
                                    cnt_inst1,
                                    csr_rstat_en1,
                                    csr_data1,

                                    excp_flush1,
                                    ertn_flush1,
                                    ecode1,

                                    inst_st_en1,
                                    st_paddr1,
                                    st_vaddr1,
                                    st_data1,

                                    inst_ld_en1,
                                    ld_paddr1,
                                    ld_vaddr1,

                                    tlbfill_en1};

            assign ctrl_diff1_delay = { debug_wb_pc2,
                                    debug_wb_inst2,
                                    debug_wb_rf_wen2,
                                    debug_wb_rf_wnum2,
                                    debug_wb_rf_wdata2,

                                    inst_valid2,
                                    cnt_inst2,
                                    csr_rstat_en2,
                                    csr_data2,

                                    excp_flush2,
                                    ertn_flush2,
                                    ecode2,

                                    inst_st_en2,
                                    st_paddr2,
                                    st_vaddr2,
                                    st_data2,

                                    inst_ld_en2,
                                    ld_paddr2,
                                    ld_vaddr2,

                                    tlbfill_en2};


            always @(posedge clk) begin
                if (rst)    begin
                    ctrl_diff0_o <= 0;
                    ctrl_diff1_o <= 0;
                    count_64_o1 <= 0;
                    count_64_o2 <= 0;
                end 
                else begin
                    ctrl_diff0_o <= ctrl_diff0_delay;
                    ctrl_diff1_o <= ctrl_diff1_delay;
                    count_64_o1 <= count_64_i1;
                    count_64_o2 <= count_64_i2;
                end
            end
    `endif 
endmodule