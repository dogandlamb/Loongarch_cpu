`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"

module decoder (
    input wire clk,
    input wire rst,


    input wire flush, //鐎殿喗妞介弫鎾绘偑閿熺姵浜ら柟椋庡厴閺佹捇寮妶鍡楊伓闂佽法鍠曢崜濂告偖鐎涙ê顏�

    // 闁告挸绉归弫鎾诲礈閼愁垱褰ч柟椋庡厴閺佹捇骞戞搴殰闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛敓锟�
    input wire [31:0] pc1,
    input wire [31:0] pc2,
    input wire [31:0] inst1,
    input wire [31:0] inst2,
    input wire [1:0]  valid,                        //  闁告挸绉归弫鎾诲礈閼愁垱褰ч柟椋庡厴閺佹捇骞戞搴殰闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁哄倶鍊栫€氬綊寮崼銉︽櫢闁煎瓨姘ㄧ亸銊╁箯閿燂拷
    input wire [1:0]  pretaken,                     // 闂佽法鍠曢～妤冩暜椤旇棄顏堕柤鍛婄矒閺佹捇寮妶鍡楊伓闁煎墽枪椤鏌ㄩ悢娲绘晭鐠嬫劙濡惰箛鏂款伓闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢鍛婄伄闁圭兘鏀遍悷娲煥閻斿憡鐏柟椋庡厴閺佹捇姊兼０婵呮倣闁归鍏橀弫鎾绘晸閿燂拷
    input wire [31:0] pre_addr_in1 ,           // 闁告挸绉归弫鎾诲礈閼愁垱褰ч柟椋庡厴閺佹捇骞戞搴㈢暠闁告垯鍊栫€氬綊寮ㄩ鐑嗘殨闂佽法鍠愰弸濠氬箯妞嬪孩绐楅梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢閻炴稒顨愰幏锟�
    input wire [31:0] pre_addr_in2 ,

    input wire [1:0]  is_exception_in1 ,          // 闂佽法鍠愰弸濠氬箯閾氬倻顏遍梺璺ㄥ枑閺嬪骞忛柨瀣樄闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊寮幇鍓佺Ф闁归鏌夊Λ鏃堟煥閻曞倹瀚�
    input wire [1:0]  is_exception_in2 ,          // 闂佽法鍠曟俊顓犳媼鐟欏嫬顏堕梺璺ㄥ枑閺嬪骞忛柨瀣樄闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊寮幇鍓佺Ф闁归鏌夊Λ鏃堟煥閻曞倹瀚�

    input wire [6:0]  pc_exception_cause_in1 ,        // 闂佽法鍠庨惇鍓ф暜缁嬪灝鏂ч梺璺ㄥ枑閺嬪骞忛敓锟�
    input wire [6:0]  pc_exception_cause_in2 ,        

    input wire [6:0]  instbuffer_exception_cause_in1 ,   
    input wire [6:0]  instbuffer_exception_cause_in2 ,

    //闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氾拷 dispatch 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柤瀛樻皑鐏忋劑骞忛敓锟�
    input wire [1:0] invalid_en,  // 闂佽法鍠愰弸濠氬箯闁垮娅忛梺璺ㄥ枙閸撳ジ鎮€涙ê顏�


    // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢娲绘健閻㈩垼鍠楃€氬湱鎷犻幘顔芥櫢濡ゆ銆€婢ф妫冮埡鍌氼伓闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鎸婇弴銏℃櫢闁跨噦鎷�
    output wire get_data_req,   
    output wire pause_decoder,


    //  闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悤鍌涘 dispatch 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柤瀛樻皑鐏忋劑骞忛敓锟�
    output reg  [1:0]  dispatch_id_valid,       // pc闂佽法鍠愰弸濠氬箯闁垮娅忛梺璺ㄥ枙閸撳ジ鎮€涙ê顏�

    output reg  [31:0] dispatch_pc_out1 ,
    output reg  [31:0] dispatch_pc_out2 ,
    output reg  [31:0] dispatch_inst_out1 ,
    output reg  [31:0] dispatch_inst_out2 ,


    output reg  [2:0]  is_exception_o1 ,            //  闂佽法鍠曢～妤呭礄閵堝棗顏堕梺璺ㄥ枎閻墽鏁敓锟�
    output reg  [2:0]  is_exception_o2 ,         
    output reg  [6:0]  pc_exception_cause_o1 ,         // 闂佽法鍠愰弸濠氬箯瀹勬澘鏂ч梺璺ㄥ枑閺嬪骞忛敓锟�
    output reg  [6:0]  pc_exception_cause_o2 ,
    output reg  [6:0]  instbuffer_exception_cause_o1,
    output reg  [6:0]  instbuffer_exception_cause_o2,
    output reg  [6:0]  decoder_exception_cause_o1,
    output reg  [6:0]  decoder_exception_cause_o2, 

    output reg  [7:0]  dispatch_aluop1 ,
    output reg  [7:0]  dispatch_aluop2 ,
    output reg  [2:0]  dispatch_alusel1 ,
    output reg  [2:0]  dispatch_alusel2 ,
    output reg  [31:0] dispatch_imm1 ,
    output reg  [31:0] dispatch_imm2 ,

    output reg  [1:0]  dispatch_is_div,
    output reg  [1:0]  dispatch_is_mul,

    output reg  [1:0]  dispatch_reg_read_en1,           // 闂佽法鍠愰弸濠氬箯閾氬倻顏遍梺璺ㄥ枑閺嬪骞忛柨瀣樄闂佽法鍠愰弸濠氬箯閾氬倹鍟梺璺ㄥ枔缁悂鎯傞崨濠傤伓闂佽法鍣﹂幏锟�
    output reg  [1:0]  dispatch_reg_read_en2,           // 闂佽法鍠曟俊顓犳媼鐟欏嫬顏堕梺璺ㄥ枑閺嬪骞忛柨瀣樄闂佽法鍠愰弸濠氬箯閾氬倹鍟梺璺ㄥ枔缁悂鎯傞崨濠傤伓闂佽法鍣﹂幏锟�
    output reg  [4:0]  dispatch_reg_read_addr1_1 ,      // 闂佽法鍠愰弸濠氬箯閾氬倻顏遍梺璺ㄥ枑閺嬪骞忛柨瀣樄闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢閻炴稒顨愰幏锟�
    output reg  [4:0]  dispatch_reg_read_addr1_2 ,
    output reg  [4:0]  dispatch_reg_read_addr2_1 ,      // 闂佽法鍠曟俊顓犳媼鐟欏嫬顏堕梺璺ㄥ枑閺嬪骞忛柨瀣樄闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢閻炴稒顨愰幏锟�
    output reg  [4:0]  dispatch_reg_read_addr2_2,
    output reg  [1:0]  dispatch_reg_writen_en,          // 闂佽法鍠嶉懠搴㈡綇閻愵剙顏堕梺璺ㄥ枑閺嬪骞忓畡鏉挎櫢濞达絽娼￠弫鎾诲棘閵堝棗顏堕梺璺ㄥ枙閸撳ジ宕ｉ崙銈囩Ф闁瑰嚖鎷�2濞达絽绉归弫鎾诲棘閵堝棗顏�
    output reg  [4:0]  dispatch_reg_write_addr1 ,       // 闂佽法鍠嶉懠搴㈡綇閻愵剙顏堕梺璺ㄥ枑閺嬪骞忓畡鏉挎櫢闂佽法鍠愰弸濠氬箯瀹勭増绲�
    output reg  [4:0]  dispatch_reg_write_addr2 ,

    output reg  [1:0]  dispatch_id_pre_taken,           // 闂佽法鍠愰弸濠氬箯闁垮鏆滃Λ鏉垮閺佹捇寮妶鍡楊伓闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢娲绘健闁告垯鍊栫€氬綊鏌ㄩ悢鍛婄伄闁归鏌夊ù鍡涙煥閻斿憡鐏柟鍑ゆ嫹
    output reg  [31:0] dispatch_id_pre_addr1,       // 闂佽法鍠愰弸濠氬箯闁垮鏆滃Λ鏉垮閺佹捇寮妶鍡楊伓闁烩晩鍣ｉ弫鎾诲棘閵堝棗顏堕梺璺ㄥ枙椤㈡粓鏁撻敓锟�
    output reg  [31:0] dispatch_id_pre_addr2,

    output reg  [1:0]  dispatch_is_privilege,           //闂佽法鍠曢～妤呭礄閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁哄倶鍊栫€氬綊寮堕崘鈺佺樄闂佽法鍠愰弸濠氬箯閿燂拷
    output reg  [1:0]  dispatch_csr_read_en,            //CSR闂佽法鍠愰弸濠氬箯閾氬倸鈻忛梺璺ㄥ枑閺嬪骞忛敓锟�
    output reg  [1:0]  dispatch_csr_write_en,           //CSR闁告劖鐟ゆ繛鍥煥閻斿憡鐏柟鍑ゆ嫹
    output reg  [13:0] dispatch_csr_addr1,          //CSR闂佽法鍠愰弸濠氬箯瀹勭増绲�
    output reg  [13:0] dispatch_csr_addr2,
    output reg  [1:0]  dispatch_is_cnt,                 //闂佽法鍠曢～妤呭礄閵堝棗顏堕梺璺ㄥ枙椤娑甸柨瀣伓闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氾拷
    output reg  [4:0]  dispatch_invtlb_op1,               //TLB闂佽法鍠愰弸濠氬箯闁垮娅忛梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁哄倶鍊栫€氾拷
    output reg  [4:0]  dispatch_invtlb_op2,
    output reg  [1:0]  sort
);

    //闂佽法鍠曟俊顓犳嫚瑜庣€氬綊鏌ㄩ悢璇插闁绘艾鐡ㄧ€氾拷
    wire  id_valid1;       //ID闂佽法鍠栧Ο浣烘媼鐟欏嫬顏堕梺璺ㄥ枑閺嬪骞忛柨瀣珡闂佽法鍠曢崜濂告偖鐎涙ê顏�
    wire  id_valid2;

    wire  valid1_i ;
    assign valid1_i = valid[0];
    wire  valid2_i ;
    assign valid2_i = valid[1];

    wire pre_taken1_i;
    assign pre_taken1_i = pretaken[0];
    wire pre_taken2_i;
    assign pre_taken2_i = pretaken[1];

    wire  [31:0] pc_out1;
    wire  [31:0] pc_out2;
    wire  [31:0] inst_out1;
    wire  [31:0] inst_out2;

    wire  [2:0] is_exception1;               //闂佽法鍠曢～妤呭礄閵堝棗顏堕梺璺ㄥ枎閻墽鏁敓锟�
    wire  [2:0] is_exception2;              
    wire  [6:0] pc_exception_cause1;         //闂佽法鍠庨惇鍓ф暜缁嬪灝鏂ч梺璺ㄥ枑閺嬪骞忛敓锟�
    wire  [6:0] pc_exception_cause2;
    wire  [6:0] instbuffer_exception_cause1; 
    wire  [6:0] instbuffer_exception_cause2;
    wire  [6:0] decoder_exception_cause1;
    wire  [6:0] decoder_exception_cause2;

    wire  [7:0]  aluop1;
    wire  [7:0]  aluop2;
    wire  [2:0]  alusel1;
    wire  [2:0]  alusel2;
    wire  [31:0] imm1;
    wire  [31:0] imm2;

    wire  [1:0]  is_div;
    wire  [1:0]  is_mul;

    wire  [1:0]  reg_read_en1;          // 闂佽法鍠愰弸濠氬箯閾氬倻顏遍梺璺ㄥ枑閺嬪骞忛柨瀣樄闂佽法鍠愰弸濠氬箯閾氬倹鍟梺璺ㄥ枔缁悂鎯傞崨濠傤伓闂佽法鍣﹂幏锟�
    wire  [1:0]  reg_read_en2;          // 闂佽法鍠曟俊顓犳媼鐟欏嫬顏堕梺璺ㄥ枑閺嬪骞忛柨瀣樄闂佽法鍠愰弸濠氬箯閾氬倹鍟梺璺ㄥ枔缁悂鎯傞崨濠傤伓闂佽法鍣﹂幏锟�
    wire  [4:0]  reg_read_addr1_1;      // 闂佽法鍠愰弸濠氬箯閾氬倻顏遍梺璺ㄥ枑閺嬪骞忛柨瀣樄闂佽法鍠愰弸濠氬箯閾氬倹鍟梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢閻炴稒顨愰幏锟�
    wire  [4:0]  reg_read_addr1_2;
    wire  [4:0]  reg_read_addr2_1;      // 闂佽法鍠曟俊顓犳媼鐟欏嫬顏堕梺璺ㄥ枑閺嬪骞忛柨瀣樄闂佽法鍠愰弸濠氬箯閾氬倹鍟梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢閻炴稒顨愰幏锟�
    wire  [4:0]  reg_read_addr2_2;
    wire  [1:0]  reg_writen_en; 
    wire  [4:0]  reg_write_addr1;
    wire  [4:0]  reg_write_addr2;

    wire  id_pre_taken1;       // ID 闂佽法鍠栧Ο浣烘媼鐟欏嫬顏跺Λ鏉垮閺佹捇寮妶鍡楊伓闂佽法鍠曢、婊嗩檪闁圭兘鏀遍悷娲煥閻斿憡鐏柟椋庡厴閺佹捇姊肩拋瑙勫
    wire  id_pre_taken2;
    wire  [31:0] pre_addr1;     // ID 闂佽法鍠栧Ο浣烘媼鐟欏嫬顏跺Λ鏉垮閺佹捇寮妶鍡楊伓闂佽法鍠曢、婊嗩檪闁归鍏橀弫鎾绘⒓妫版繀鎮嶉柟椋庡厴閺佹挾鎮板Δ瀣
    wire  [31:0] pre_addr2;

    wire  is_privilege1;       // 闂佽法鍠曢～妤呭礄閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁哄倶鍊栫€氬綊寮堕崘鈺佺樄闂佽法鍠愰弸濠氬箯閿燂拷
    wire  is_privilege2;
    wire  csr_read_en1 ;        // CSR闂佽法鍠愰弸濠氬箯閾氬倸鈻忛梺璺ㄥ枑閺嬪骞忛敓锟�
    wire  csr_read_en2 ;
    wire  csr_write_en1;       //CSR闁告劖鐟ゆ繛鍥煥閻斿憡鐏柟鍑ゆ嫹
    wire  csr_write_en2;
    wire  [13:0] csr_addr1;     // CSR
    wire  [13:0] csr_addr2;
    wire  is_cnt1;             // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁悷娆愬笧閵嗗骞忛悜鑺ユ櫢闁哄倶鍊栫€氬綊鏌ㄩ悢鍛婄伄闁瑰嚖鎷�
    wire  is_cnt2;
    wire  [4:0]  invtlb_op1;         // TLB闂佽法鍠愰弸濠氬箯闁垮娅廫
    wire  [4:0]  invtlb_op2;

    id u_id_0 (
        // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢璇插闁绘艾鐡ㄧ€氾拷
        .valid(valid1_i),

        .pre_taken(pre_taken1_i),
        .pre_addr(pre_addr_in1),

        .pc(pc1),
        .inst(inst1),
        
        .is_exception(is_exception_in1),
        .pc_exception_cause(pc_exception_cause_in1),
        .instbuffer_exception_cause(instbuffer_exception_cause_in1),


        // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鎸婇弴銏℃櫢闁跨噦鎷�
        .id_valid(id_valid1),

        .pc_out(pc_out1),
        .inst_out(inst_out1),

        .is_exception_out(is_exception1),
        .pc_exception_cause_out(pc_exception_cause1),
        .instbuffer_exception_cause_out(instbuffer_exception_cause1),
        .decoder_exception_cause_out(decoder_exception_cause1),

        .aluop(aluop1),
        .alusel(alusel1),
        .imm(imm1),

        .is_div(is_div[0]),
        .is_mul(is_mul[0]),

        .reg1_read_en(reg_read_en1[0]),   
        .reg2_read_en(reg_read_en1[1]),   
        .reg1_read_addr(reg_read_addr1_1),
        .reg2_read_addr(reg_read_addr1_2),
        .reg_writen_en (reg_writen_en[0]),  
        .reg_write_addr(reg_write_addr1),  

        .id_pre_taken(id_pre_taken1), 
        .id_pre_addr(pre_addr1), 

        .is_privilege(is_privilege1), 
        .csr_read_en(csr_read_en1), 
        .csr_write_en(csr_write_en1), 
        .csr_addr(csr_addr1), 
        .is_cnt(is_cnt1), 
        .invtlb_op(invtlb_op1) 
    );

    id u_id_1 (
        .valid(valid2_i),

        .pre_taken(pre_taken2_i),
        .pre_addr(pre_addr_in2),

        .pc(pc2),
        .inst(inst2),
        
        .is_exception(is_exception_in2),
        .pc_exception_cause(pc_exception_cause_in2),
        .instbuffer_exception_cause(instbuffer_exception_cause_in2),


        .id_valid(id_valid2),

        .pc_out(pc_out2),
        .inst_out(inst_out2),

        .is_exception_out(is_exception2),
        .pc_exception_cause_out(pc_exception_cause2),
        .instbuffer_exception_cause_out(instbuffer_exception_cause2),
        .decoder_exception_cause_out(decoder_exception_cause2),

        .aluop(aluop2),
        .alusel(alusel2),
        .imm(imm2),

        .is_div(is_div[1]),
        .is_mul(is_mul[1]),

        .reg1_read_en(reg_read_en2[0]),   
        .reg2_read_en(reg_read_en2[1]),   
        .reg1_read_addr(reg_read_addr2_1),
        .reg2_read_addr(reg_read_addr2_2),
        .reg_writen_en (reg_writen_en[1]),  
        .reg_write_addr(reg_write_addr2),  

        .id_pre_taken(id_pre_taken2), 
        .id_pre_addr(pre_addr2), 
        
        .is_privilege(is_privilege2), 
        .csr_read_en(csr_read_en2), 
        .csr_write_en(csr_write_en2), 
        .csr_addr(csr_addr2), 
        .is_cnt(is_cnt2), 
        .invtlb_op(invtlb_op2) 
    );
    


    /////////////////////////////////////////////
    // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢鍛婄伄闁归鏌夊畷娲煥閻斿憡鐏柟椋庡厴閺佹捇寮妶鍡楊伓閻熸洑绶氶弫鎾诲棘閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁煎瓨鑹捐ぐ鍧楁晲韫囨柨顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁煎瓨鑹捐ぐ璺ㄦ兜闁垮顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁哄倶鍊栫€氬綊宕滃澶嬫櫢闁兼亽鍎遍懟鐔兼煥閻斿憡鐏柟椋庡厴閺佹捇鎯堥锔戒氦闁归锕獶ECODE_DATA_WIDTH闂佽法鍠愰弸濠氬箯瀹勬壋鍋撻敓锟�
    wire [`DECODE_DATA_WIDTH - 1:0] enqueue_data1;
    wire [`DECODE_DATA_WIDTH - 1:0] enqueue_data2;
    assign  enqueue_data1 =  {  
                                1'b0,                         // 208
                                is_mul[0],                    // 207
                                is_div[0],                    // 206
                                decoder_exception_cause1,     // 205:199     
                                instbuffer_exception_cause1,  // 198:192
                                pc_exception_cause1,          // 191:185      
                                is_exception1,    // 184:182

                                invtlb_op1,           // 181:177
                                is_cnt1,              // 176
                                csr_addr1,            // 175:162
                                csr_write_en1,        // 161
                                csr_read_en1,         // 160
                                is_privilege1,        // 159    
                                pre_addr1,            // 158:127
                                (aluop1 == `ALU_CACOP) ? 1'b1 :id_pre_taken1,        // 126
                                
                                reg_write_addr1,      // 125:121
                                reg_writen_en[0],     // 120
                                reg_read_addr1_2,     // 119:115
                                reg_read_addr1_1,     // 114:110
                                reg_read_en1,         // 109:108

                                imm1,                 // 107:76
                                alusel1,              // 75:73
                                aluop1,               // 72:65
                                
                                inst_out1,            // 64:33
                                pc_out1,              // 32:1

                                id_valid1};           // 0

    assign  enqueue_data2 =  {  
                                1'b1,
                                is_mul[1],                    // 207
                                is_div[1],                    // 206
                                decoder_exception_cause2,     // 205:199     
                                instbuffer_exception_cause2,  // 198:192
                                pc_exception_cause2,          // 191:185    
                                is_exception2,    // 184:182

                                invtlb_op2,           // 181:177
                                is_cnt2,              // 176
                                csr_addr2,            // 175:162
                                csr_write_en2,        // 161
                                csr_read_en2,         // 160
                                is_privilege2,        // 159    
                                pre_addr2,            // 158:127
                                (aluop2 == `ALU_CACOP) ? 1'b1 :id_pre_taken2,        // 126
                                
                                reg_write_addr2,      // 125:121
                                reg_writen_en[1],     // 120
                                reg_read_addr2_2,     // 119:115
                                reg_read_addr2_1,     // 114:110
                                reg_read_en2,         // 109:108

                                imm2,                 // 107:76
                                alusel2,              // 75:73
                                aluop2,               // 72:65
                                
                                inst_out2,            // 64:33
                                pc_out2,              // 32:1

                                id_valid2};           // 0      

    // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏�
    wire [`DECODE_DATA_WIDTH - 1:0] dequeue_data1;
    wire [`DECODE_DATA_WIDTH - 1:0] dequeue_data2;

    wire fifo_rst;
    assign fifo_rst = rst || flush;
    reg [1:0] enqueue_en;   //闂佽法鍠愰弸濠氬箯閻戣姤鏅哥紓浣哄仧濞呫垽骞忛悜鑺ユ櫢闁哄倶鍊栫€氬綊鎸婇弴銏℃櫢闁跨噦鎷�
    wire get_data_req_o;
    wire full;
    wire empty;

    dram_fifo u_queue(
        .clk(clk),
        .rst(fifo_rst),
        .flush(flush),

        .enqueue_en(enqueue_en),
        .enqueue_data1(enqueue_data1),
        .enqueue_data2(enqueue_data2),

        .invalid_en(invalid_en),
        .dequeue_data1(dequeue_data1),
        .dequeue_data2(dequeue_data2),

        .get_data_req(get_data_req_o),
        .full(full),
        .empty(empty)
    );
    
    // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柟鍦厴濞煎骞忓畡鏉款枀闂佽法鍠庢竟娆戝枈婢跺顏堕柛娆愮墬鐎垫岸鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枙閸撳ジ鎮€涙ê顏�
    assign get_data_req = get_data_req_o;

    always @(*) begin
        enqueue_en[0] = !full && valid[0];
        enqueue_en[1] = !full && valid[1];
    end


    // 闂佽法鍠曢、婊堝棘閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁哄倶鍊栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾绘晸閿燂拷
    always @(*) begin
        dispatch_id_valid[0]        =   dequeue_data1[0];
        dispatch_id_valid[1]        =   dequeue_data2[0];
        dispatch_pc_out1            =   dequeue_data1[32:1];
        dispatch_pc_out2            =   dequeue_data2[32:1];
        dispatch_inst_out1          =   dequeue_data1[64:33];
        dispatch_inst_out2          =   dequeue_data2[64:33];
        dispatch_aluop1             =   dequeue_data1[72:65];
        dispatch_aluop2             =   dequeue_data2[72:65];
        dispatch_alusel1            =   dequeue_data1[75:73];
        dispatch_alusel2            =   dequeue_data2[75:73];
        dispatch_imm1               =   dequeue_data1[107:76];
        dispatch_imm2               =   dequeue_data2[107:76];
        dispatch_reg_read_en1       =   dequeue_data1[109:108];   
        dispatch_reg_read_en2       =   dequeue_data2[109:108];     
        dispatch_reg_read_addr1_1   =   dequeue_data1[114:110];
        dispatch_reg_read_addr1_2   =   dequeue_data1[119:115];
        dispatch_reg_read_addr2_1   =   dequeue_data2[114:110];
        dispatch_reg_read_addr2_2   =   dequeue_data2[119:115];
        dispatch_reg_writen_en[0]   =   dequeue_data1[120];
        dispatch_reg_writen_en[1]   =   dequeue_data2[120];  
        dispatch_reg_write_addr1    =   dequeue_data1[125:121];
        dispatch_reg_write_addr2    =   dequeue_data2[125:121];
        dispatch_id_pre_taken[0]    =   dequeue_data1[126];
        dispatch_id_pre_taken[1]    =   dequeue_data2[126];
        dispatch_id_pre_addr1       =   dequeue_data1[158:127];
        dispatch_id_pre_addr2       =   dequeue_data2[158:127];
        dispatch_is_privilege[0]    =   dequeue_data1[159];
        dispatch_is_privilege[1]    =   dequeue_data2[159];
        dispatch_csr_read_en[0]     =   dequeue_data1[160];
        dispatch_csr_read_en[1]     =   dequeue_data2[160];
        dispatch_csr_write_en[0]    =   dequeue_data1[161];
        dispatch_csr_write_en[1]    =   dequeue_data2[161];
        dispatch_csr_addr1          =   dequeue_data1[175:162];
        dispatch_csr_addr2          =   dequeue_data2[175:162];
        dispatch_is_cnt[0]          =   dequeue_data1[176];
        dispatch_is_cnt[1]          =   dequeue_data2[176];
        dispatch_invtlb_op1         =   dequeue_data1[181:177];
        dispatch_invtlb_op2         =   dequeue_data2[181:177];
        
        is_exception_o1                 =   dequeue_data1[184:182];
        is_exception_o2                 =   dequeue_data2[184:182];
        pc_exception_cause_o1           =   dequeue_data1[191:185];
        pc_exception_cause_o2           =   dequeue_data2[191:185];
        instbuffer_exception_cause_o1   =   dequeue_data1[198:192];
        instbuffer_exception_cause_o2   =   dequeue_data2[198:192];
        decoder_exception_cause_o1      =   dequeue_data1[205:199];
        decoder_exception_cause_o2      =   dequeue_data2[205:199];

        dispatch_is_div[0]              =   dequeue_data1[206];
        dispatch_is_div[1]              =   dequeue_data2[206];
        dispatch_is_mul[0]              =   dequeue_data1[207];
        dispatch_is_mul[1]              =   dequeue_data2[207];

        sort[0]                         =   dequeue_data1[208];
        sort[1]                         =   dequeue_data2[208];

    end

    assign pause_decoder = full;


endmodule