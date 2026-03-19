`timescale 1ps/1ps
`include "defines.vh"

module front
(
    input wire cpu_clk,
    input wire cpu_rst,
    input wire not_same_page,
    
    input wire       pi_icache_is_exception1,            //闁圭ǹ娲弫鎾剁驳鐎ｎ剛澶勯梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢閻忕偛锕ら悥鍫曟煥閻旇澹栭柣姘摠鐎氾拷
    input wire       pi_icache_is_exception2,          
    input wire [6:0] pi_icache_exception_cause1,    //闁圭ǹ娲弫鎾剁驳鐎ｎ剛澶勯梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢閻忕偛锕ら悥鍫曞储閻斿吋鏅搁柡鍌樺€栫€氾拷
    input wire [6:0] pi_icache_exception_cause2,
    input wire [31:0] pc_for_buffer1,               //pc闂佽法鍠愰弸濠氬箯闁垮鐦归梺璺ㄥ枔閻℃梻绱撻幘缁樻櫢闁哄倶鍊栫€氬綊鏌ㄩ悢鍛婄伄闁归鏌夊Λ鏃堟煥閻曞倹瀚�
    input wire [31:0] pc_for_buffer2,               
    input wire [31:0] pred_addr1_for_buffer,
    input wire [31:0] pred_addr2_for_buffer,
    input wire [1:0] pred_taken_for_buffer,
    input wire icache_pc_suspend,
    input wire [31:0] inst_for_buffer1,
    input wire [31:0] inst_for_buffer2,
    input wire icache_inst_valid1,       //闁圭ǹ娲弫鎾剁驳鐎ｎ剛澶勯梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢缂備胶鍋熷▍銏ゅ箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悤鍌涘??
    input wire icache_inst_valid2,
    input wire icache_valid_in,

    //*******************
    input wire [1:0] fb_flush,
    input wire [1:0] fb_pause,
    input wire fb_interrupt,            //闂佽法鍠庤ぐ銊ф媼鐟欏嫬顏堕梺璺ㄥ枙閸撳ジ宕ｉ崙銈囩Ф闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枔閻擃偅瀵煎▎鎰伓闁绘粠鍋婇弫鎾诲棘閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁跨噦鎷�??
//    input wire [31:0] fb_new_pc,        //闂佽法鍠庤ぐ銊╁棘椤撶姴鐨戦柟椋庡厴閺佹捇鏌ч幍顕呮殰闁归顭穋闂佽法鍠愰弸濠氬箯瀹勭増绲�
    
    //闂佽法鍠愰弸濠氬箯缁屾妽ache闂佽法鍠嶉懠搴ㄥ棘閵堝棗顏�??
    output wire BPU_flush,
    output reg [31:0] pi_pc1,                //闁告挸绉归弫鎾诲礈閸ф浜ら柟椋庘扛cache闂佽法鍠愰弸濠氬箯缁屾瓭闂佽法鍠愰弸濠氬箯瀹勭増绲�
    output reg [31:0] pi_pc2,
    output wire [31:0] if_pred_addr1,
    output wire [31:0] if_pred_addr2,
    output wire [1:0] pred_taken,
    output wire inst_rreq_to_icache,            //闁告挸绉归弫鎾诲礈閸ф浜ら柟椋庘扛cache闂佽法鍠愰弸濠氬箯闁垮鐦归梺璺ㄥ枑閺嬪骞忛摎鍌氣枏闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氾拷??
    output reg pi_is_exception,             //闁告挸绉归弫鎾诲礈閸ф浜ら柟椋庘扛cache闂佽法鍠愰弸濠氬箯閻戣姤鏅搁悘鐐诧工閻栧爼鏌ㄩ悢鍛婄伄闁瑰嚖鎷�??
    output reg [6:0] pi_exception_cause,    //闁告挸绉归弫鎾诲礈閸ф浜ら柟椋庘扛cache闂佽法鍠愰弸濠氬箯閻戣姤鏅搁悘鐐诧工閻栧爼宕㈤敓锟�??

    //闂佽法鍠愰弸濠氬箯缁屽ケckend闂佽法鍠嶉懠搴ㄥ棘閵堝棗顏�??
    output wire fb_pred_taken1,
    output wire fb_pred_taken2,
    output wire [31:0] fb_pc_out1,              //闁告挸绉归弫鎾诲礈閸ф浜ら柟椋庡厴閺佹捇寮妶鍡楊伓閻犲洦鎸抽弫鎾跺緤椤晠鏌ㄩ悢鍛婄伄闁瑰嘲鍢插锟�
    output wire [31:0] fb_pc_out2,              
    output wire [31:0] fb_inst_out1,            //闁告挸绉归弫鎾诲礈閸ф浜ら柟椋庡厴閺佹捇寮妶鍡楊伓閻犲洦鎸抽弫鎾舵偘濡ゅ懏浜ら柟椋庡厴閺佹捇鏁撻敓锟�
    output wire [31:0] fb_inst_out2,           
    output wire [1:0] fb_valid,                           //闁告挸绉归弫鎾诲礈閸ф浜ら柟椋庡厴閺佹捇寮妶鍡楊伓閻犲洦鎸抽弫鎾舵偘濡ゅ懏浜ら柟椋庡厴閺佹挾绱掗悙鍨仧闁归鍏橀弫鎾诲棘閵堝棗顏堕柦妯绘礋閺佹捇鏁撻敓锟�
    output wire [31:0] fb_pre_branch_addr1,         //闁告挸绉归弫鎾诲礈閸ф浜ら柟椋庡厴閺佹捇寮妶鍡楊伓閻犲洦娼欓～瀣煥閻旀椿鏁庣憸婵嬪箯閻戣姤鏅搁悶娑欘殣閹凤拷
    output wire [31:0] fb_pre_branch_addr2,

    output wire [1:0] fb_is_exception1,                 // 闂佽法鍠愰弸濠氬箯閾氬倻顏遍梺璺ㄥ枑閺嬪骞忛柨瀣樄闂佽法鍠愰弸濠氬箯閻戣姤鏅搁悷娆愬笒閸ゆ牠骞忛悜鑺ユ櫢闁哄倶鍊栫€氾拷??
    output wire [6:0] fb_pc_exception_cause1,           // 闂佽法鍠愰弸濠氬箯閾氬倻顏遍梺璺ㄥ枑閺嬪骞忛柨瀣樄闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氱c闂佽法鍠愰弸濠氬箯閻戣姤鏅搁悘鐐诧工閻栧爼宕㈤敓锟�??
    output wire [6:0] fb_instbuffer_exception_cause1,   // 闂佽法鍠愰弸濠氬箯閾氬倻顏遍梺璺ㄥ枑閺嬪骞忛柨瀣樄闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氱nstbuffer闂佽法鍠愰弸濠氬箯閻戣姤鏅搁悘鐐诧工閻栧爼宕㈤敓锟�??
    
    output wire [1:0] fb_is_exception2,               
    output wire [6:0] fb_pc_exception_cause2,
    output wire [6:0] fb_instbuffer_exception_cause2,



    //闂佽法鍠愰弸濠氬箯閻戣姤鏅搁梺鐐緲婵偟鍠婃径瀣伓闂佽法鍠曢崜濂告偖鐎涙ê顏�**************************
    input  wire [31:0]          new_pc,
    input  wire [1:0]           ex_is_bj ,          // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊骞愰崶顒佹櫢闁哄倶鍊栫€氬綊鏌ㄩ悢娲绘健闁告垯鍊栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏堕弶鐑嗗墯鐎碉拷??
    input  wire [31:0]          ex_pc1 ,            // ex 闂佽法鍠栧Ο浣烘媼鐟欏嫬顏�?? pc
    input  wire [31:0]          ex_pc2 ,             
    input  wire [1:0]           ex_valid ,        
    input  wire [1:0]           real_taken ,        // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊骞愰崶顒佹櫢闁哄倶鍊栫€氬湱鈧湱鍋ら弫鎾诲棘閵堝棗顏堕梺璺ㄥ枙椤宕欓妶鍡楊伓闂佽法鍠愰弸濠氬箯閻ゎ垱绁�
    input  wire [31:0]          real_addr1 ,        // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊骞愰崶顒佹櫢闁哄倶鍊栫€氬湱鈧湱鍋ら弫鎾诲棘閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛悿顖涚ギ闂佽法鍠愰弸濠氬箯瀹勭増绲�
    input  wire [31:0]          real_addr2 ,
    input  wire [31:0]          pred_addr1 ,         // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊骞愰崶顒佹櫢闁哄倶鍊栫€氳锛愰崟顖涙櫢闁哄倶鍊栫€氬綊鏌ㄩ悢鍛婄伄闁归鏌夊ù鍡涙煥閻斿憡鐏柟宄板槻濞硷拷
    input  wire [31:0]          pred_addr2 ,
    input  wire                 get_data_req     
    //*************************************
);
    reg [1:0] is_branch;            // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柣顓у亗缁鳖噣骞忔搴＄細闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柨鐕傛嫹??
    wire [31:0] pre_addr;
    wire [31:0] pc_out1;
    wire [31:0] pc_out2;
    wire is_exception;
    wire [6:0] exception_cause;
    reg inst_en1;           // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柣顓у亗缁鳖噣骞忔搴＄細闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柨鐕傛嫹??
    reg inst_en2;           // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柣顓у亗缁鳖噣骞忔搴＄細闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柨鐕傛嫹??
    //闂佽法鍠愰弸濠氬箯閻戣姤鏅搁梺鐐緲婵偟鍠婃径瀣伓闂佽法鍠曢崜濂告偖鐎涙ê顏�**********************************
    wire instbuffer_stall;      // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柣顓у亗缁鳖噣骞忔搴＄細闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柨鐕傛嫹??
    wire [105:0] data_out1;
    wire [105:0] data_out2;
    
    wire BPU_pred_taken;
    //***************************************
    assign fb_pred_taken1 = data_out1[104];
    assign fb_pred_taken2 = data_out2[104];
    assign fb_pre_branch_addr1 = data_out1[103:72];
    assign fb_pre_branch_addr2 = data_out2[103:72];
    assign fb_pc_out1 = data_out1[71:40];
    assign fb_pc_out2 = data_out2[71:40];
    assign fb_inst_out1 = data_out1[39:8];
    assign fb_inst_out2 = data_out2[39:8];
    assign fb_is_exception1 = {data_out1[7], 1'b0};
    assign fb_is_exception2 = {data_out2[7], 1'b0};
    assign fb_pc_exception_cause1 = data_out1[6:0];
    assign fb_pc_exception_cause2 = data_out2[6:0];
    assign fb_instbuffer_exception_cause1 = 7'b1111111;
    assign fb_instbuffer_exception_cause2 = 7'b1111111;

    //********************************
    always @(*) 
    begin
        pi_pc1 = pc_out1;
        pi_pc2 = pc_out2;
        pi_is_exception = is_exception;
        pi_exception_cause = exception_cause;
    end

    assign BPU_pred_taken = pred_taken[0] | pred_taken[1];
    
    wire stall;
    
    pc u_pc 
    (
        .clk(cpu_clk),
        .rst(cpu_rst),    
        .not_same_page(not_same_page),
        .stall(stall),
        .flush(fb_flush[0]),
        .new_pc(new_pc),       //闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柨鐕傛嫹??閻熸洑绶氶弫鎾诲棘閵堝棗顏�??闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柤瀛樻皑鐏忋劑骞忛敓锟�???闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏秔c闂佽法鍠愰弸濠氬箯闁垮鐖遍梺璺ㄥ枎瑜般劎鎷嬬憴鍕伓闂佽法鍠愰弸濠氬箯缁屽彻闂佽法鍠栧Ο浣糕枔闂堟稑娈╅柟鐑芥敱閺侇喗锛愰崟顖涙櫢闁哄倶鍊栫€氬綊鏌ㄩ悢鍛婄伄闁归鏌夐悗浼搭敄瀹ュ鏅搁柡鍌樺€栫€氬綊鎮抽锔芥櫢闁哄倶鍊栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枍閼煎酣宕犻埄鍐伓闂佽法鍠撻幒绔庨梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁哄倶鍊栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枙琚欓柨娑樼焸閺佹捇寮妶鍡楊伓闂佽法鍠愰弸濠氬箯閻戣姤鏅搁悷娆欑到椤︹晠鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢濞撴哎鍎弫褏鎷犺鐎氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲箵椤撗傛倣闁圭兘鏀遍惃顓㈡煥閻斿憡鐏柟椋庡厴閺佹捇寮妶鍡楊伓闂佽法鍠曠欢婵堝枈婢跺顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢閻炴稒顨愰幏锟�??
        .pause(fb_pause[0] | icache_pc_suspend),
        .pre_addr(pre_addr),  
        .pred_taken(pred_taken[0] | pred_taken[1]),  
        .pc_out1(pc_out1),
        .pc_out2(pc_out2),
        .pc_is_exception(is_exception),
        .pc_exception_cause(exception_cause),
        .inst_rreq_to_icache(inst_rreq_to_icache)
    );

    wire ex_valid1 = ex_valid[0];
    wire ex_valid2 = ex_valid[1];
    wire BPU_pred_taken1;
    wire BPU_pred_taken2;
    assign pred_taken = {BPU_pred_taken2,BPU_pred_taken1};
    
    BPU u_BPU
    (
        .cpu_clk(cpu_clk),
        .cpu_rstn(cpu_rst),    //low active???
        .if_pc1(pc_out1),
        .if_pc2(pc_out2),

        .pred_taken1(BPU_pred_taken1),
        .pred_taken2(BPU_pred_taken2),
        .pred_addr(pre_addr),
        .if_pred_addr1(if_pred_addr1),
        .if_pred_addr2(if_pred_addr2),

        .BPU_flush(BPU_flush),
//        .new_pc(new_pc),

        .ex_is_bj_1(ex_is_bj[0]),     //闂佽法鍠栭妶娲偖鐎涙ê顏堕柣鎴滅窔閺佹捇寮妶鍡楊伓濞戞挻宀搁弫鎾诲棘閵堝棗顏堕柦妯绘礈婢т即鏌ㄩ悢铏诡洸x闂佽法鍠栧Ο浣糕枔閻㈡鏆滈柟鐑芥敱鐎垫岸鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾舵喆閹烘垵娈╅柟椋庡厴閺佹捇寮妶鍡楊伓闂佽法鍠愰弸濠氬箯閻ゎ垱绁柟绋挎喘閺佹捇寮妶鍡楊伓
        .ex_pc_1(ex_pc1),
        .ex_valid1(ex_valid1),
        .ex_is_bj_2(ex_is_bj[1]),
        .ex_pc_2(ex_pc2),
        .ex_valid2(ex_valid2),
        .real_taken1(real_taken[0]),
        .real_taken2(real_taken[1]),
        .real_addr1(real_addr1),
        .real_addr2(real_addr2),
        .pred_addr1(pred_addr1),
        .pred_addr2(pred_addr2)
    );

    instbuffer u_instbuffer 
    (
        .clk(cpu_clk),
        .rst(cpu_rst),
        .flush(fb_flush[1]),
        .get_data_req(get_data_req),   //闂佽法鍠愰弸濠氬箯缁屾姧stbuffer闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鎸婇弴銏℃櫢缂佽尙鍨攕tbuffer闂佽法鍠曢崜鍏煎濞嗘劕顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁哄倶鍊栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾跺緤閻栧t闂佽法鍠愰弸濠氬箯閻戣姤鏅搁悘鐐诧攻椤掔偤鏌ㄩ悢鍛婄伄闁瑰嚖鎷�??
        .inst_valid1(icache_inst_valid1),
        .inst_valid2(icache_inst_valid2),
        .icache_valid_in(icache_valid_in),
        .pc1(pc_for_buffer1),
        .pc2(pc_for_buffer2),

        .inst1(inst_for_buffer1),
        .inst2(inst_for_buffer2),
        .pred_addr1(pred_addr1_for_buffer),
        .pred_addr2(pred_addr2_for_buffer),
        .pred_taken(pred_taken_for_buffer),

        .pc_is_exception_in1(pi_icache_is_exception1),
        .pc_is_exception_in2(pi_icache_is_exception2),
        .pc_exception_cause_in1(pi_icache_exception_cause1),
        .pc_exception_cause_in2(pi_icache_exception_cause2),
        .data_out1(data_out1),

        .data_out2(data_out2),
        .data_valid(fb_valid),

        .stall(stall)
    );


endmodule