`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"

module dispatch
(
    input wire clk,
    input wire rst,

    //鎺у埗鍗曞厓鐨勬殏鍋滃拰鍒锋柊淇″彿
    input wire pause,
    input wire flush,


    // 鏉ヨ嚜dispatch鐨勮緭鍏ヤ俊锟�???
    input wire [31:0] pc1_i,      //鎸囦护鍦板潃
    input wire [31:0] pc2_i,      //鎸囦护鍦板潃
    input wire [1:0] sort_i,

    input wire [31:0] inst1_i,    //鎸囦护缂栫爜
    input wire [31:0] inst2_i,    //鎸囦护缂栫爜
    input wire [1:0]  valid_i,   //鎸囦护鏈夋晥鏍囧織

    input wire [2:0]  is_exception_i1, //锟�???1鏉℃寚浠ょ殑寮傚父鏍囧織
    input wire [2:0]  is_exception_i2, //锟�???2鏉℃寚浠ょ殑寮傚父鏍囧織
    
    input wire [6:0] pc_exception_cause_i1,
    input wire [6:0] instbuffer_exception_cause_i1,
    input wire [6:0] decoder_exception_cause_i1,
    input wire [6:0] pc_exception_cause_i2,
    input wire [6:0] instbuffer_exception_cause_i2,
    input wire [6:0] decoder_exception_cause_i2,

    input wire [1:0]  is_privilege_i, //涓ゆ潯鎸囦护鐨勭壒鏉冩寚浠ゆ爣锟�???
    input wire [1:0]  is_cnt_i,       //涓ゆ潯鎸囦护鐨勮鏁板櫒鎸囦护鏍囧織

    input wire [7:0]  alu_op_i1,  //ALU鎿嶄綔锟�???
    input wire [7:0]  alu_op_i2,  //ALU鎿嶄綔锟�???
    input wire [2:0]  alu_sel_i1, //ALU鍔熻兘閫夋嫨
    input wire [2:0]  alu_sel_i2, //ALU鍔熻兘閫夋嫨
    input wire [31:0] imm_i1,     //绔嬪嵆鏁帮拷??
    input wire [31:0] imm_i2,     //绔嬪嵆鏁帮拷??

    input wire [1:0]   is_div_i,
    input wire [1:0]   is_mul_i,

    input wire [4:0]  invtlb_op_i1,   //锟�???1鏉℃寚浠ょ殑鍒嗘敮鎸囦护鏍囧織
    input wire [4:0]  invtlb_op_i2,   //锟�???2鏉℃寚浠ょ殑鍒嗘敮鎸囦护鏍囧織

    input wire [1:0]  reg_read_en_i1,     //锟�???1鏉℃寚浠ょ殑涓や釜婧愬瘎瀛樺櫒婧愬瘎瀛樺櫒璇讳娇锟�???
    input wire [1:0]  reg_read_en_i2,     //锟�???2鏉℃寚浠ょ殑涓や釜婧愬瘎瀛樺櫒婧愬瘎瀛樺櫒璇讳娇锟�???   
    input wire [4:0]  reg_read_addr_i1_1, //锟�???1鏉℃寚浠ょ殑锟�???1涓簮瀵勫瓨鍣ㄥ湴锟�???
    input wire [4:0]  reg_read_addr_i1_2, //锟�???1鏉℃寚浠ょ殑锟�???2涓簮瀵勫瓨鍣ㄥ湴锟�???
    input wire [4:0]  reg_read_addr_i2_1, //锟�???2鏉℃寚浠ょ殑锟�???1涓簮瀵勫瓨鍣ㄥ湴锟�???
    input wire [4:0]  reg_read_addr_i2_2, //锟�???2鏉℃寚浠ょ殑锟�???2涓簮瀵勫瓨鍣ㄥ湴锟�???

    input wire [1:0]  reg_write_en_i,    //涓ゆ潯鎸囦护鐩殑瀵勫瓨鍣ㄥ啓浣胯兘
    input wire [4:0]  reg_write_addr_i1,  //鎸囦护1鐩殑瀵勫瓨鍣ㄥ湴锟�???
    input wire [4:0]  reg_write_addr_i2,  //鎸囦护2鐩殑瀵勫瓨鍣ㄥ湴锟�???

    input wire [1:0]   csr_read_en_i,   //csr璇讳娇锟�???
    input wire [13:0]  csr_addr_i1,     //锟�???1鏉℃寚浠sr鍦板潃
    input wire [13:0]  csr_addr_i2,     //锟�???2鏉℃寚浠sr鍦板潃
    input wire [1:0]   csr_write_en_i,  //csr鍐欎娇锟�???
    input wire [1:0]   pre_is_branch_taken_i,//鍓嶄竴鏉℃寚浠ゆ槸鍚︽槸鍒嗘敮鎸囦护
    input wire [31:0]  pre_branch_addr_i1, 
    input wire [31:0]  pre_branch_addr_i2, 


    // 鏉ヨ嚜ex鍜宮em鐨勫墠閫掓暟锟�???
    input wire [1:0]   ex_pf_write_en,     //浠巈x闃舵鍓嶏拷?锟藉嚭鏉ョ殑浣胯兘
    input wire [4:0]   ex_pf_write_addr1,   //浠巈x闃舵鍓嶏拷?锟藉嚭鏉ョ殑鍦板潃
    input wire [4:0]   ex_pf_write_addr2,   //浠巈x闃舵鍓嶏拷?锟藉嚭鏉ョ殑鍦板潃
    input wire [31:0]  ex_pf_write_data1,   //浠巈x闃舵鍓嶏拷?锟藉嚭鏉ョ殑鏁版嵁
    input wire [31:0]  ex_pf_write_data2,   //浠巈x闃舵鍓嶏拷?锟藉嚭鏉ョ殑鏁版嵁

    input wire [1:0]   mem_pf_write_en,    //浠巑em闃舵鍓嶏拷?锟藉嚭鏉ョ殑浣胯兘
    input wire [4:0]   mem_pf_write_addr1,  //浠巑em闃舵鍓嶏拷?锟藉嚭鏉ョ殑鍦板潃
    input wire [4:0]   mem_pf_write_addr2,  //浠巑em闃舵鍓嶏拷?锟藉嚭鏉ョ殑鍦板潃
    input wire [31:0]  mem_pf_write_data1,  //浠巑em闃舵鍓嶏拷?锟藉嚭鏉ョ殑鏁版嵁
    input wire [31:0]  mem_pf_write_data2,  //浠巑em闃舵鍓嶏拷?锟藉嚭鏉ョ殑鏁版嵁

    input wire [1:0]   wb_pf_write_en,     //浠巜b闃舵鍓嶏拷?锟藉嚭鏉ョ殑浣胯兘
    input wire [4:0]   wb_pf_write_addr1,   //浠巜b闃舵鍓嶏拷?锟藉嚭鏉ョ殑鍦板潃
    input wire [4:0]   wb_pf_write_addr2,   //浠巜b闃舵鍓嶏拷?锟藉嚭鏉ョ殑鍦板潃
    input wire [31:0]  wb_pf_write_data1,   //浠巜b闃舵鍓嶏拷?锟藉嚭鏉ョ殑鏁版嵁
    input wire [31:0]  wb_pf_write_data2,   //浠巜b闃舵鍓嶏拷?锟藉嚭鏉ョ殑鏁版嵁

    //鏉ヨ嚜ex闃舵鐨勶紝鐢ㄤ簬鍒ゆ柇ex杩愯鐨勬寚浠ゆ槸鍚︽槸load鎸囦护
    input wire [7:0]   ex_pre_aluop1,       //ex闃舵鐨刲oad鎸囦护鏍囧織
    input wire [7:0]   ex_pre_aluop2,       //ex闃舵鐨刲oad鎸囦护鏍囧織
    //鏉ヨ嚜ex闃舵鐨勶紝鍙兘鐢变簬涔橀櫎娉曠瓑鎸囦护寮曡捣鐨勬殏鍋滀俊锟�???
    input wire         ex_pause,           //ex闃舵鐨勬殏鍋滀俊锟�???


    // 杈撳嚭缁檈xecute鐨勬暟锟�???
    output reg [31:0] pc1_o,  
    output reg [31:0] pc2_o,  
    output reg      sort1_o, //杞腑鏂爣蹇�
    output reg      sort2_o,
    output reg [31:0] inst1_o,
    output reg [31:0] inst2_o,
    output reg [1:0]  valid_o,

    output reg [3:0]  is_exception_o1, //锟�???1鏉℃寚浠ょ殑寮傚父鏍囧織
    output reg [3:0]  is_exception_o2, //锟�???2鏉℃寚浠ょ殑寮傚父锟�???

    output reg [6:0] pc_exception_cause_o1,
    output reg [6:0] instbuffer_exception_cause_o1,
    output reg [6:0] decoder_exception_cause_o1,
    output reg [6:0] dispatch_exception_cause_o1,
    output reg [6:0] pc_exception_cause_o2,
    output reg [6:0] instbuffer_exception_cause_o2,
    output reg [6:0] decoder_exception_cause_o2,
    output reg [6:0] dispatch_exception_cause_o2,

    output reg [1:0]  is_privilege_o, //涓ゆ潯鎸囦护鐨勭壒鏉冩寚浠ゆ爣锟�???

    output reg icacop_en_o1,
    output reg icacop_en_o2,
    output reg dcacop_en_o1,
    output reg dcacop_en_o2,
    output reg [4:0] cacop_opcode_o1,
    output reg [4:0] cacop_opcode_o2,

    output reg [7:0]  alu_op_o1,
    output reg [7:0]  alu_op_o2,
    output reg [2:0]  alu_sel_o1,
    output reg [2:0]  alu_sel_o2,

    output reg [1:0]   is_div_o, //涓ゆ潯鎸囦护鐨勯櫎娉曟爣锟�?
    output reg [1:0]   is_mul_o, //涓ゆ潯鎸囦护鐨勪箻娉曟爣锟�?

    output reg [31:0] reg_read_data_o1_1, //瀵勫瓨鍣ㄥ爢缁欏嚭鐨勭1鏉℃寚浠ょ殑锟�???1涓簮鎿嶄綔锟�???
    output reg [31:0] reg_read_data_o1_2, //瀵勫瓨鍣ㄥ爢缁欏嚭鐨勭1鏉℃寚浠ょ殑锟�???2涓簮鎿嶄綔锟�???
    output reg [31:0] reg_read_data_o2_1, //瀵勫瓨鍣ㄥ爢缁欏嚭鐨勭2鏉℃寚浠ょ殑锟�???1涓簮鎿嶄綔锟�???
    output reg [31:0] reg_read_data_o2_2, //瀵勫瓨鍣ㄥ爢缁欏嚭鐨勭2鏉℃寚浠ょ殑锟�???2涓簮鎿嶄綔锟�???
    
    output reg [1:0]  reg_write_en_o,     //鐩殑瀵勫瓨鍣ㄥ啓浣胯兘
    output reg [4:0]  reg_write_addr_o1,  //鐩殑瀵勫瓨鍣ㄥ湴锟�???
    output reg [4:0]  reg_write_addr_o2,  //鐩殑瀵勫瓨鍣ㄥ湴锟�???

    output reg [31:0]  csr_read_data_o1, //瀵勫瓨鍣ㄥ爢鐨刢sr璇绘暟锟�???
    output reg [31:0]  csr_read_data_o2, //瀵勫瓨鍣ㄥ爢鐨刢sr璇绘暟锟�???
    output reg [1:0]   csr_write_en_o, //瀵勫瓨鍣ㄥ爢鐨刢sr鍐欎娇锟�???
    output reg [13:0]  csr_addr_o1,     //瀵勫瓨鍣ㄥ爢鐨刢sr鍦板潃
    output reg [13:0]  csr_addr_o2,     //瀵勫瓨鍣ㄥ爢鐨刢sr鍦板潃
    
    output reg [4:0]  invtlb_op_o1,   //锟�???1鏉℃寚浠ょ殑鍒嗘敮鎸囦护鏍囧織
    output reg [4:0]  invtlb_op_o2,   //锟�???2鏉℃寚浠ょ殑鍒嗘敮鎸囦护鏍囧織
    
    output reg [1:0]   pre_is_branch_taken_o, //鍓嶄竴鏉℃寚浠ゆ槸鍚︽槸鍒嗘敮鎸囦护
    output reg [31:0]  pre_branch_addr_o1, //鍓嶄竴鏉℃寚浠ょ殑鍒嗘敮鍦板潃
    output reg [31:0]  pre_branch_addr_o2,  //鍓嶄竴鏉℃寚浠ょ殑鍒嗘敮鍦板潃


    
    // 杈撳嚭锟�??? id 闃舵鐨勪俊锟�???
    output wire [1:0] invalid_en, //鎸囦护鍙戝皠鎺у埗淇″彿

    //涓庡瘎瀛樺櫒鐨勬帴锟�???
    input wire [31:0] from_reg_read_data_i1_1, //瀵勫瓨鍣ㄧ粰鍑虹殑锟�???1鏉℃寚浠ょ殑锟�???1涓簮鎿嶄綔锟�???
    input wire [31:0] from_reg_read_data_i1_2, //瀵勫瓨鍣ㄧ粰鍑虹殑锟�???1鏉℃寚浠ょ殑锟�???2涓簮鎿嶄綔锟�???
    input wire [31:0] from_reg_read_data_i2_1, //瀵勫瓨鍣ㄧ粰鍑虹殑锟�???2鏉℃寚浠ょ殑锟�???1涓簮鎿嶄綔锟�???
    input wire [31:0] from_reg_read_data_i2_2, //瀵勫瓨鍣ㄧ粰鍑虹殑锟�???2鏉℃寚浠ょ殑锟�???2涓簮鎿嶄綔锟�???

    output wire dispatch_pause ,//鍙戝皠鍣ㄦ殏鍋滀俊锟�???,褰撳彂鐢焞oad-use鍐掗櫓鏃堕渶瑕佹殏锟�???


    // 鍜宑sr鐨勬帴锟�???
    input wire  [31:0]  csr_read_data_i1,   // csr璇绘暟锟�???
    input wire  [31:0]  csr_read_data_i2,   // csr璇绘暟锟�???

    output wire [1:0]   csr_read_en_o,      // csr璇讳娇锟�???
    output wire [13:0]   csr_read_addr_o1,   // csr璇诲湴锟�???
    output wire [13:0]   csr_read_addr_o2   // csr璇诲湴锟�???
);

    wire [1:0] send_en;     //鍐呴儴鍙戝皠淇″彿锛岀粰invalid_en璧嬶拷??
    wire       send_double; //鍒ゆ柇鏄惁涓哄弻鍙戝皠鐨勪俊锟�??? 
    
    wire [1:0] inst_valid;  //鍐呴儴鎸囦护鏈夋晥鏍囧織

    wire       cnt_inst; //璁℃暟鍣ㄦ寚浠ゆ爣蹇楋紝鍒ゆ柇鍙戝皠鐨勪袱鏉℃寚浠や腑鏈夋病鏈夎鏁板櫒鎸囦护
    wire       privilege_inst; //鐗规潈鎸囦护鏍囧織锛屽垽鏂彂灏勭殑涓ゆ潯鎸囦护涓湁娌℃湁鐗规潈鎸囦护
    wire       mem_inst;//璁垮瓨淇″彿鏍囧織锛屽垽鏂彂灏勭殑涓ゆ潯鎸囦护涓湁娌℃湁load鍜宻tore绫诲瀷
    wire       data_hazard_inst;//鏁版嵁鍐掗櫓鏍囧織锛屽垽鏂槸鍚﹀嚭鐜颁簡鏁版嵁鍐掗櫓

    reg  [31:0] pc1_temp;       //涓存椂瀵勫瓨鍣紝瀛樺偍鎸囦护鍦板潃
    reg  [31:0] pc2_temp;       //涓存椂瀵勫瓨鍣紝瀛樺偍鎸囦护鍦板潃
    reg  [31:0] inst1_temp;     //涓存椂瀵勫瓨鍣紝瀛樺偍鎸囦护缂栫爜
    reg  [31:0] inst2_temp;     //涓存椂瀵勫瓨鍣紝瀛樺偍鎸囦护缂栫爜
    reg  [1:0]  valid_temp;     //涓存椂瀵勫瓨鍣紝瀛樺偍鎸囦护鏈夋晥鏍囧織
    reg  [7:0]  alu_op1_temp;   //涓存椂瀵勫瓨鍣紝瀛樺偍ALU鎿嶄綔锟�???
    reg  [7:0]  alu_op2_temp;   //涓存椂瀵勫瓨鍣紝瀛樺偍ALU鎿嶄綔锟�???
    reg  [2:0]  alu_sel1_temp;  //涓存椂瀵勫瓨鍣紝瀛樺偍ALU鍔熻兘閫夋嫨
    reg  [2:0]  alu_sel2_temp;  //涓存椂瀵勫瓨鍣紝瀛樺偍ALU鍔熻兘閫夋嫨
    reg  [1:0]  is_div_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍涓ゆ潯鎸囦护鐨勯櫎娉曟爣锟�?
    reg  [1:0]  is_mul_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍涓ゆ潯鎸囦护鐨勪箻娉曟爣锟�?
    reg  [1:0]  reg_write_en_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍鐩殑瀵勫瓨鍣ㄥ啓浣胯兘
    reg  [4:0]  reg_write_addr1_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍鐩殑瀵勫瓨鍣ㄥ湴锟�???
    reg  [4:0]  reg_write_addr2_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍鐩殑瀵勫瓨鍣ㄥ湴锟�???
    reg  [31:0] reg_read_data1_1_temp; //瀵勫瓨鍣ㄥ爢缁欏嚭鐨勭1鏉℃寚浠ょ殑锟�???1涓簮鎿嶄綔锟�???
    reg  [31:0] reg_read_data1_2_temp; //瀵勫瓨鍣ㄥ爢缁欏嚭鐨勭1鏉℃寚浠ょ殑锟�???2涓簮鎿嶄綔锟�???
    reg  [31:0] reg_read_data2_1_temp; //瀵勫瓨鍣ㄥ爢缁欏嚭鐨勭2鏉℃寚浠ょ殑锟�???1涓簮鎿嶄綔锟�???
    reg  [31:0] reg_read_data2_2_temp; //瀵勫瓨鍣ㄥ爢缁欏嚭鐨勭2鏉℃寚浠ょ殑锟�???2涓簮鎿嶄綔锟�???
    reg  [1:0]  is_privilege_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍鐗规潈鎸囦护鏍囧織
    reg  [3:0]  is_exception1_temp; //锟�???1鏉℃寚浠ょ殑寮傚父鏍囧織
    reg  [3:0]  is_exception2_temp; //锟�???2鏉℃寚浠ょ殑寮傚父鏍囧織

    reg  [6:0] pc_exception_cause1_temp; //锟�???1鏉℃寚浠ょ殑寮傚父鍘熷洜
    reg  [6:0] instbuffer_exception_cause1_temp; //锟�???1鏉℃寚浠ょ殑寮傚父鍘熷洜
    reg  [6:0] id_exception_cause1_temp; //锟�???1鏉℃寚浠ょ殑寮傚父鍘熷洜
    reg  [6:0] dispatch_exception_cause1_temp; //锟�???1鏉℃寚浠ょ殑寮傚父鍘熷洜
    reg  [6:0] pc_exception_cause2_temp; //锟�???2鏉℃寚浠ょ殑寮傚父鍘熷洜
    reg  [6:0] instbuffer_exception_cause2_temp; //锟�???2鏉℃寚浠ょ殑寮傚父鍘熷洜
    reg  [6:0] id_exception_cause2_temp; //锟�???2鏉℃寚浠ょ殑寮傚父鍘熷洜
    reg  [6:0] dispatch_exception_cause2_temp; //锟�???2鏉℃寚浠ょ殑寮傚父鍘熷洜

    reg  [4:0]  invtlb_op1_temp;   //锟�???1鏉℃寚浠ょ殑鍒嗘敮鎸囦护鏍囧織
    reg  [4:0]  invtlb_op2_temp;   //锟�???2鏉℃寚浠ょ殑鍒嗘敮鎸囦护鏍囧織
    reg  [1:0]  csr_write_en_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍csr鍐欎娇锟�???
    reg  [13:0] csr_addr1_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍csr鍐欏湴锟�???
    reg  [13:0] csr_addr2_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍csr鍐欏湴锟�???
    reg  [1:0]  pre_is_branch_taken_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍鍓嶄竴鏉℃寚浠ゆ槸鍚︽槸鍒嗘敮鎸囦护
    reg  [31:0] pre_branch_addr1_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍鍓嶄竴鏉℃寚浠ょ殑鍒嗘敮鍦板潃
    reg  [31:0] pre_branch_addr2_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍鍓嶄竴鏉℃寚浠ょ殑鍒嗘敮鍦板潃
    reg  [31:0] csr_read_data1_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍csr璇绘暟锟�???
    reg  [31:0] csr_read_data2_temp; //涓存椂瀵勫瓨鍣紝瀛樺偍csr璇绘暟锟�???

    assign invalid_en = pause ? 2'b00 : send_en;//鍙戝皠鎺у埗淇″彿璧嬶拷??

    assign inst_valid = valid_i;//鍐呴儴鏈夋晥鏍囧織璧嬶拷??
    

    assign privilege_inst = (is_privilege_i[0] || is_privilege_i[1]);//鍒ゆ柇鍙戝皠鐨勪袱鏉℃寚浠や腑鏈夋病鏈夌壒鏉冩寚锟�???
    assign mem_inst = (alu_sel_i1 == `ALU_SEL_LOAD_STORE || alu_sel_i2 == `ALU_SEL_LOAD_STORE);//鍒ゆ柇鍙戝皠鐨勪袱鏉℃寚浠や腑鏈夋病鏈塴oad鍜宻tore绫诲瀷鐨勬寚锟�???
    //涓嬮潰杩欐潯璇彞锛屾楠屼簡灏嗚鍙屽彂灏勭殑杩欎袱鏉℃寚浠ら棿鏄惁瀛樺湪鏁版嵁鐩稿叧鍐掗櫓
    assign data_hazard_inst = (reg_write_en_i[0] && reg_write_addr_i1 != 5'b0) //锟�???1鏉℃寚浠ゆ湁鍐欏瘎瀛樺櫒鐨勫姛锟�???
                            &&((reg_write_addr_i1 == reg_read_addr_i2_1 && reg_read_en_i2[0]) //锟�???1鏉℃寚浠ょ殑鍐欏瘎瀛樺櫒鐨勫湴锟�???涓庣2鏉℃寚浠ょ1涓簮瀵勫瓨鍣ㄧ浉锟�???
                            ||(reg_write_addr_i1 == reg_read_addr_i2_2 && reg_read_en_i2[1])); //锟�???1鏉℃寚浠ょ殑鍐欏瘎瀛樺櫒鐨勫湴锟�???涓庣2鏉℃寚浠ょ2涓簮瀵勫瓨鍣ㄧ浉锟�???
    assign cnt_inst = (is_cnt_i[0] || is_cnt_i[1]);//鍒ゆ柇鍙戝皠鐨勪袱鏉℃寚浠や腑鏈夋病鏈夎鏁板櫒鎸囦护

    assign send_double = (!mem_inst) && (!data_hazard_inst) && (!cnt_inst) && (!privilege_inst) && (&inst_valid); //鍒ゆ柇杩欎袱鏉℃寚浠よ兘鍚﹀悓鏃跺彂锟�???
    assign send_en = (send_double == 1'b1) ? 2'b11 : (inst_valid[0] ? 2'b01 : (inst_valid[1] ? 2'b10 : 2'b00));//褰撴寚浠や笉鑳藉弻鍙戝皠鏃朵紭鍏堝彂绗竴锟�???

    reg sort1_temp;
    reg sort2_temp;
    //淇″彿浼犺緭
    always @(*) begin
        pc1_temp = pc1_i;
        pc2_temp = pc2_i;
        sort1_temp = sort_i[0];
        sort2_temp = sort_i[1];
        inst1_temp = inst1_i;
        inst2_temp = inst2_i;
        valid_temp = valid_i;
        alu_op1_temp = alu_op_i1;
        alu_op2_temp = alu_op_i2;
        alu_sel1_temp = alu_sel_i1;
        alu_sel2_temp = alu_sel_i2;
        is_div_temp = is_div_i;
        is_mul_temp = is_mul_i;
        reg_write_en_temp = reg_write_en_i;
        reg_write_addr1_temp = reg_write_addr_i1;
        reg_write_addr2_temp = reg_write_addr_i2;
        is_privilege_temp = is_privilege_i;
        is_exception1_temp = {is_exception_i1, 1'b0};
        is_exception2_temp = {is_exception_i2, 1'b0};
        pc_exception_cause1_temp = pc_exception_cause_i1;
        instbuffer_exception_cause1_temp = instbuffer_exception_cause_i1;
        id_exception_cause1_temp = decoder_exception_cause_i1;
        dispatch_exception_cause1_temp = `EXCEPTION_NOP;
        pc_exception_cause2_temp = pc_exception_cause_i2;
        instbuffer_exception_cause2_temp = instbuffer_exception_cause_i2;
        id_exception_cause2_temp = decoder_exception_cause_i2;
        dispatch_exception_cause2_temp = `EXCEPTION_NOP;
        invtlb_op1_temp = invtlb_op_i1;
        invtlb_op2_temp = invtlb_op_i2;
        csr_write_en_temp = csr_write_en_i;
        csr_addr1_temp = csr_addr_i1;
        csr_addr2_temp = csr_addr_i2;
        pre_is_branch_taken_temp = pre_is_branch_taken_i;
        pre_branch_addr1_temp = pre_branch_addr_i1;
        pre_branch_addr2_temp = pre_branch_addr_i2;
    end
    
    always @(*) begin
        //姝ｅ父鐨勮鏁版嵁
        //锟�???1鏉℃寚锟�???
        if(reg_read_en_i1[0]) begin
            reg_read_data1_1_temp = from_reg_read_data_i1_1;
        end else begin
            reg_read_data1_1_temp = imm_i1; //濡傛灉娌℃湁璇讳娇鑳斤紝鍒欒祴鍊肩珛鍗虫暟
        end
        if(reg_read_en_i1[1]) begin
            reg_read_data1_2_temp = from_reg_read_data_i1_2;
        end else begin
            reg_read_data1_2_temp = imm_i1; //濡傛灉娌℃湁璇讳娇鑳斤紝鍒欒祴鍊肩珛鍗虫暟
        end
        
        //锟�???2鏉℃寚锟�???
        if(reg_read_en_i2[0]) begin
            reg_read_data2_1_temp = from_reg_read_data_i2_1;
        end else begin
            reg_read_data2_1_temp = imm_i2; //濡傛灉娌℃湁璇讳娇鑳斤紝鍒欒祴鍊肩珛鍗虫暟
        end
        if(reg_read_en_i2[1]) begin
            reg_read_data2_2_temp = from_reg_read_data_i2_2;
        end else begin
            reg_read_data2_2_temp = imm_i2; //濡傛灉娌℃湁璇讳娇鑳斤紝鍒欒祴鍊肩珛鍗虫暟
        end
        
        //涓庡啓鍥為樁娈垫湁鏁版嵁鍐茬獊杩涜鏁版嵁鍓嶏拷??
        //锟�???1鏉℃寚浠ょ殑锟�???1
        if(wb_pf_write_en[0] && reg_read_en_i1[0] && (reg_read_addr_i1_1 == wb_pf_write_addr1)) 
            reg_read_data1_1_temp = wb_pf_write_data1;
        else if(wb_pf_write_en[1] && reg_read_en_i1[0] && (reg_read_addr_i1_1 == wb_pf_write_addr2)) 
            reg_read_data1_1_temp = wb_pf_write_data2;
        
        //锟�???1鏉℃寚浠ょ殑锟�???2
        if(wb_pf_write_en[0] && reg_read_en_i1[1] && (reg_read_addr_i1_2 == wb_pf_write_addr1)) 
            reg_read_data1_2_temp = wb_pf_write_data1;
        else if(wb_pf_write_en[1] && reg_read_en_i1[1] && (reg_read_addr_i1_2 == wb_pf_write_addr2)) 
            reg_read_data1_2_temp = wb_pf_write_data2;
        
        //锟�???2鏉℃寚浠ょ殑锟�???1
        if(wb_pf_write_en[0] && reg_read_en_i2[0] && (reg_read_addr_i2_1 == wb_pf_write_addr1)) 
            reg_read_data2_1_temp = wb_pf_write_data1;
        else if(wb_pf_write_en[1] && reg_read_en_i2[0] && (reg_read_addr_i2_1 == wb_pf_write_addr2)) 
            reg_read_data2_1_temp = wb_pf_write_data2;
        
        //锟�???2鏉℃寚浠ょ殑锟�???2
        if(wb_pf_write_en[0] && reg_read_en_i2[1] && (reg_read_addr_i2_2 == wb_pf_write_addr1)) 
            reg_read_data2_2_temp = wb_pf_write_data1;
        else if(wb_pf_write_en[1] && reg_read_en_i2[1] && (reg_read_addr_i2_2 == wb_pf_write_addr2)) 
            reg_read_data2_2_temp = wb_pf_write_data2;
        
        //涓庤瀛橀樁娈垫湁鏁版嵁鍐茬獊杩涜鏁版嵁鍓嶏拷??
        //锟�???1鏉℃寚浠ょ殑锟�???1
        if(mem_pf_write_en[0] && reg_read_en_i1[0] && (reg_read_addr_i1_1 == mem_pf_write_addr1)) 
            reg_read_data1_1_temp = mem_pf_write_data1;
        else if(mem_pf_write_en[1] && reg_read_en_i1[0] && (reg_read_addr_i1_1 == mem_pf_write_addr2)) 
            reg_read_data1_1_temp = mem_pf_write_data2;
        
        //锟�???1鏉℃寚浠ょ殑锟�???2
        if(mem_pf_write_en[0] && reg_read_en_i1[1] && (reg_read_addr_i1_2 == mem_pf_write_addr1)) 
            reg_read_data1_2_temp = mem_pf_write_data1;
        else if(mem_pf_write_en[1] && reg_read_en_i1[1] && (reg_read_addr_i1_2 == mem_pf_write_addr2)) 
            reg_read_data1_2_temp = mem_pf_write_data2;
        
        //锟�???2鏉℃寚浠ょ殑锟�???1
        if(mem_pf_write_en[0] && reg_read_en_i2[0] && (reg_read_addr_i2_1 == mem_pf_write_addr1)) 
            reg_read_data2_1_temp = mem_pf_write_data1;
        else if(mem_pf_write_en[1] && reg_read_en_i2[0] && (reg_read_addr_i2_1 == mem_pf_write_addr2)) 
            reg_read_data2_1_temp = mem_pf_write_data2;
        
        //锟�???2鏉℃寚浠ょ殑锟�???2
        if(mem_pf_write_en[0] && reg_read_en_i2[1] && (reg_read_addr_i2_2 == mem_pf_write_addr1)) 
            reg_read_data2_2_temp = mem_pf_write_data1;
        else if(mem_pf_write_en[1] && reg_read_en_i2[1] && (reg_read_addr_i2_2 == mem_pf_write_addr2)) 
            reg_read_data2_2_temp = mem_pf_write_data2;
        
        //涓庢墽琛岄樁娈垫湁鏁版嵁鍐茬獊杩涜鏁版嵁鍓嶏拷??
        //锟�???1鏉℃寚浠ょ殑锟�???1
        if(ex_pf_write_en[0] && reg_read_en_i1[0] && (reg_read_addr_i1_1 == ex_pf_write_addr1)) 
            reg_read_data1_1_temp = ex_pf_write_data1;
        else if(ex_pf_write_en[1] && reg_read_en_i1[0] && (reg_read_addr_i1_1 == ex_pf_write_addr2)) 
            reg_read_data1_1_temp = ex_pf_write_data2;
        
        //锟�???1鏉℃寚浠ょ殑锟�???2
        if(ex_pf_write_en[0] && reg_read_en_i1[1] && (reg_read_addr_i1_2 == ex_pf_write_addr1)) 
            reg_read_data1_2_temp = ex_pf_write_data1;
        else if(ex_pf_write_en[1] && reg_read_en_i1[1] && (reg_read_addr_i1_2 == ex_pf_write_addr2)) 
            reg_read_data1_2_temp = ex_pf_write_data2;
        
        //锟�???2鏉℃寚浠ょ殑锟�???1
        if(ex_pf_write_en[0] && reg_read_en_i2[0] && (reg_read_addr_i2_1 == ex_pf_write_addr1)) 
            reg_read_data2_1_temp = ex_pf_write_data1;
        else if(ex_pf_write_en[1] && reg_read_en_i2[0] && (reg_read_addr_i2_1 == ex_pf_write_addr2)) 
            reg_read_data2_1_temp = ex_pf_write_data2;
        
        //锟�???2鏉℃寚浠ょ殑锟�???2
        if(ex_pf_write_en[0] && reg_read_en_i2[1] && (reg_read_addr_i2_2 == ex_pf_write_addr1)) 
            reg_read_data2_2_temp = ex_pf_write_data1;
        else if(ex_pf_write_en[1] && reg_read_en_i2[1] && (reg_read_addr_i2_2 == ex_pf_write_addr2)) 
            reg_read_data2_2_temp = ex_pf_write_data2;
        
        //濡傛灉婧愬瘎瀛樺櫒鍦板潃锟�???0锛屽垯璧嬶拷?锟戒负0
        if(reg_read_en_i1[0] && reg_read_addr_i1_1 == 5'b0) 
            reg_read_data1_1_temp = 32'b0;
        if(reg_read_en_i1[1] && reg_read_addr_i1_2 == 5'b0) 
            reg_read_data1_2_temp = 32'b0;
        if(reg_read_en_i2[0] && reg_read_addr_i2_1 == 5'b0) 
            reg_read_data2_1_temp = 32'b0;
        if(reg_read_en_i2[1] && reg_read_addr_i2_2 == 5'b0) 
            reg_read_data2_2_temp = 32'b0;
        
        //澶勭悊PCADDU12I鎸囦护
        if(alu_op_i1 == `ALU_PCADDU12I) begin
            if(reg_read_en_i1[0]) reg_read_data1_1_temp = pc1_i;
            if(reg_read_en_i1[1]) reg_read_data1_2_temp = pc1_i;
        end
        if(alu_op_i2 == `ALU_PCADDU12I) begin
            if(reg_read_en_i2[0]) reg_read_data2_1_temp = pc2_i;
            if(reg_read_en_i2[1]) reg_read_data2_2_temp = pc2_i;
        end
    end

    reg [13:0] cpucfg_addr1;
    reg [13:0] cpucfg_addr2;
    always @(*) begin
        if (alu_op_i1 == `ALU_CPUCFG) begin
            case (reg_read_data1_1_temp) 
                    32'h1:       cpucfg_addr1 = `CSR_CPUCFG1;
                    32'h2:       cpucfg_addr1 = `CSR_CPUCFG2;
                    32'h10:      cpucfg_addr1 = `CSR_CPUCFG10;
                    32'h11:      cpucfg_addr1 = `CSR_CPUCFG11;
                    32'h12:      cpucfg_addr1 = `CSR_CPUCFG12;
                    32'h13:      cpucfg_addr1 = `CSR_CPUCFG13;
                    default:     cpucfg_addr1 = 14'b0;
            endcase
        end
        else if (alu_op_i2 == `ALU_CPUCFG) begin
            case (reg_read_data2_1_temp) 
                    32'h1:       cpucfg_addr2 = `CSR_CPUCFG1;
                    32'h2:       cpucfg_addr2 = `CSR_CPUCFG2;
                    32'h10:      cpucfg_addr2 = `CSR_CPUCFG10;
                    32'h11:      cpucfg_addr2 = `CSR_CPUCFG11;
                    32'h12:      cpucfg_addr2 = `CSR_CPUCFG12;
                    32'h13:      cpucfg_addr2 = `CSR_CPUCFG13;
                    default:     cpucfg_addr2 = 14'b0;
            endcase
        end
    end
    assign csr_read_en_o = csr_read_en_i;
    assign csr_read_addr_o1 = (alu_op_i1 == `ALU_CPUCFG) ? cpucfg_addr1 : csr_addr_i1;
    assign csr_read_addr_o2 = (alu_op_i2 == `ALU_CPUCFG) ? cpucfg_addr2 : csr_addr_i2;


    // cacop
    wire [4:0] cacop_opcode1;
    wire [4:0] cacop_opcode2;
    assign cacop_opcode1 = reg_write_addr_i1;
    assign cacop_opcode2 = reg_write_addr_i2;

    wire cacop_valid1;
    wire cacop_valid2;
    assign cacop_valid1 = (alu_op_i1 == `ALU_CACOP) & valid_i[0];
    assign cacop_valid2 = (alu_op_i2 == `ALU_CACOP) & valid_i[1];

    wire icacop_en1;
    wire dcacop_en1;
    wire icacop_en2;
    wire dcacop_en2;
    assign icacop_en1  = (cacop_opcode1[2:0] == 3'b000) & cacop_valid1;
    assign dcacop_en1  = (cacop_opcode1[2:0] == 3'b001) & cacop_valid1;
    assign icacop_en2  = (cacop_opcode2[2:0] == 3'b000) & cacop_valid2;
    assign dcacop_en2  = (cacop_opcode2[2:0] == 3'b001) & cacop_valid2;


    //csr
    always @(*) begin
        if(csr_read_en_i[0]) 
            csr_read_data1_temp = csr_read_data_i1;
        else 
            csr_read_data1_temp = 32'b0;
            
        if(csr_read_en_i[1]) 
            csr_read_data2_temp = csr_read_data_i2;
        else 
            csr_read_data2_temp = 32'b0;
    end


    //load-use鍐掗櫓姣旇捣锟�???鑸殑鏁版嵁鍐掗櫓鏇翠弗閲嶏拷??
    //锟�???鑸殑鏁版嵁鍐掗櫓鍦ㄦ墽琛岄樁娈靛氨鍙緱鍒扮粨锟�???
    //load-use鍐掗櫓鍒欓渶瑕佸湪璁垮瓨闃舵鍚庢墠鑳界粨锟�???

    wire        pre_load; //鍒ゆ柇鍏堝墠鐨勬寚浠ゆ槸鍚︽槸load鎸囦护
    wire        reg_relate_i1_1;//锟�???1鏉℃寚浠ょ殑锟�???1涓庡墠锟�???鏉oad鎸囦护鐩稿叧
    wire        reg_relate_i1_2;//锟�???1鏉℃寚浠ょ殑锟�???2涓庡墠锟�???鏉oad鎸囦护鐩稿叧
    wire        reg_relate_i2_1;//锟�???2鏉℃寚浠ょ殑锟�???1涓庡墠锟�???鏉oad鎸囦护鐩稿叧
    wire        reg_relate_i2_2;//锟�???2鏉℃寚浠ょ殑锟�???2涓庡墠锟�???鏉oad鎸囦护鐩稿叧

    //鍒ゆ柇杩欐椂鍊欏湪ex闃舵鐨勬寚浠ゆ槸鍚︽槸load鎸囦护
    assign pre_load = (ex_pre_aluop1 == `ALU_LDB) 
                    || (ex_pre_aluop1 == `ALU_LDH) 
                    || (ex_pre_aluop1 == `ALU_LDW) 
                    || (ex_pre_aluop1 == `ALU_LDBU) 
                    || (ex_pre_aluop1 == `ALU_LDHU) 
                    || (ex_pre_aluop1 == `ALU_LLW)
                    || (ex_pre_aluop1 == `ALU_SCW)
                    || (ex_pre_aluop2 == `ALU_LDB) 
                    || (ex_pre_aluop2 == `ALU_LDH) 
                    || (ex_pre_aluop2 == `ALU_LDW) 
                    || (ex_pre_aluop2 == `ALU_LDBU) 
                    || (ex_pre_aluop2 == `ALU_LDHU) 
                    || (ex_pre_aluop2 == `ALU_LLW)
                    || (ex_pre_aluop2 == `ALU_SCW);

    //鍒ゆ柇鍙戝皠鍣ㄤ腑鐨勪袱鏉℃寚浠ゆ槸鍚︿笌褰撳墠ex闃舵鐨刲oad鎸囦护鐩稿叧锛坙oad鎸囦护锟�???娆″彧鍙戜竴鏉★級
    assign reg_relate_i1_1 = pre_load && reg_read_en_i1[0] && (reg_read_addr_i1_1 == ex_pf_write_addr1);
    assign reg_relate_i1_2 = pre_load && reg_read_en_i1[1] && (reg_read_addr_i1_2 == ex_pf_write_addr1);
    assign reg_relate_i2_1 = pre_load && reg_read_en_i2[0] && (reg_read_addr_i2_1 == ex_pf_write_addr1);
    assign reg_relate_i2_2 = pre_load && reg_read_en_i2[1] && (reg_read_addr_i2_2 == ex_pf_write_addr1);

    assign dispatch_pause = reg_relate_i1_1 | reg_relate_i1_2 | reg_relate_i2_1 | reg_relate_i2_2; //鑻ュ瓨鍦╨oad-use鍐掗櫓锛屽垯鏆傚仠鍙戝皠锟�???

    reg [31:0] ex_pc1_temp;             
    reg [31:0] ex_pc2_temp;   
    reg        ex_sort1_temp;
    reg        ex_sort2_temp;          
    reg [31:0] ex_inst1_temp;           
    reg [31:0] ex_inst2_temp;           
    reg        ex_valid1_temp;          
    reg        ex_valid2_temp;          
    reg [7:0]  ex_alu_op1_temp;         
    reg [7:0]  ex_alu_op2_temp;         
    reg [2:0]  ex_alu_sel1_temp;        
    reg [2:0]  ex_alu_sel2_temp;   
    reg [1:0]  ex_is_div_temp; 
    reg [1:0]  ex_is_mul_temp;      
    reg        ex_reg_write_en1_temp; 
    reg        ex_reg_write_en2_temp; 
    reg [4:0]  ex_reg_write_addr1_temp; 
    reg [4:0]  ex_reg_write_addr2_temp; 
    reg [31:0] ex_reg_read_data1_1_temp; 
    reg [31:0] ex_reg_read_data1_2_temp; 
    reg [31:0] ex_reg_read_data2_1_temp; 
    reg [31:0] ex_reg_read_data2_2_temp; 
    reg        ex_is_privilege1_temp; 
    reg        ex_is_privilege2_temp; 

    reg        ex_icacop_en1_temp;
    reg        ex_icacop_en2_temp;
    reg        ex_dcacop_en1_temp;
    reg        ex_dcacop_en2_temp;
    reg [4:0]  ex_cacop_opcode1_temp;
    reg [4:0]  ex_cacop_opcode2_temp;

    reg [3:0]  ex_is_exception1_temp; 
    reg [3:0]  ex_is_exception2_temp; 

    reg [6:0] ex_pc_exception_cause1_temp; 
    reg [6:0] ex_instbuffer_exception_cause1_temp;
    reg [6:0] ex_id_exception_cause1_temp;
    reg [6:0] ex_dispatch_exception_cause1_temp;
    reg [6:0] ex_pc_exception_cause2_temp;
    reg [6:0] ex_instbuffer_exception_cause2_temp;
    reg [6:0] ex_id_exception_cause2_temp;
    reg [6:0] ex_dispatch_exception_cause2_temp;

    reg [4:0]  ex_invtlb_op1_temp;   
    reg [4:0]  ex_invtlb_op2_temp;   
    reg        ex_csr_write_en1_temp; 
    reg        ex_csr_write_en2_temp; 
    reg [13:0] ex_csr_addr1_temp; 
    reg [13:0] ex_csr_addr2_temp; 
    reg        ex_pre_is_branch_taken1_temp; 
    reg        ex_pre_is_branch_taken2_temp; 
    reg [31:0] ex_pre_branch_addr1_temp; 
    reg [31:0] ex_pre_branch_addr2_temp; 
    reg [31:0] ex_csr_read_data1_temp; 
    reg [31:0] ex_csr_read_data2_temp; 

    always @(*) begin
        if(send_en[0])begin
            ex_pc1_temp = pc1_temp;
            ex_sort1_temp = sort1_temp;
            ex_inst1_temp = inst1_temp;
            ex_valid1_temp = valid_temp[0];
            ex_alu_op1_temp = alu_op1_temp;
            ex_alu_sel1_temp = alu_sel1_temp;
            ex_is_div_temp[0] = is_div_temp[0];
            ex_is_mul_temp[0] = is_mul_temp[0];
            ex_reg_write_en1_temp = reg_write_en_temp[0];
            ex_reg_write_addr1_temp = reg_write_addr1_temp;
            ex_reg_read_data1_1_temp = reg_read_data1_1_temp;
            ex_reg_read_data1_2_temp = reg_read_data1_2_temp;
            ex_is_privilege1_temp = is_privilege_temp[0];

            ex_icacop_en1_temp    = icacop_en1;
            ex_dcacop_en1_temp    = dcacop_en1;
            ex_cacop_opcode1_temp = cacop_opcode1;

            ex_is_exception1_temp = is_exception1_temp;

            ex_pc_exception_cause1_temp = pc_exception_cause1_temp;
            ex_instbuffer_exception_cause1_temp = instbuffer_exception_cause1_temp;
            ex_id_exception_cause1_temp = id_exception_cause1_temp;
            ex_dispatch_exception_cause1_temp = dispatch_exception_cause1_temp;

            ex_invtlb_op1_temp = invtlb_op1_temp;
            ex_csr_write_en1_temp = csr_write_en_temp[0];
            ex_csr_addr1_temp = csr_addr1_temp;
            ex_pre_is_branch_taken1_temp = pre_is_branch_taken_temp[0];
            ex_pre_branch_addr1_temp = pre_branch_addr1_temp;
            ex_csr_read_data1_temp = csr_read_data1_temp;
        end 
        else begin
            ex_pc1_temp = 32'b0;
            ex_sort1_temp = 1'b0;
            ex_inst1_temp = 32'b0;    
            ex_valid1_temp = 1'b0;
            ex_alu_op1_temp = 8'b0;
            ex_alu_sel1_temp = 3'b0;
            ex_is_div_temp[0] = 1'b0;
            ex_is_mul_temp[0] = 1'b0;
            ex_reg_write_en1_temp = 1'b0;
            ex_reg_write_addr1_temp = 5'b0;
            ex_reg_read_data1_1_temp = 32'b0;
            ex_reg_read_data1_2_temp = 32'b0;
            ex_is_privilege1_temp = 1'b0;

            ex_icacop_en1_temp    = 1'b0;
            ex_dcacop_en1_temp    = 1'b0;
            ex_cacop_opcode1_temp = 5'b0;

            
            ex_is_exception1_temp = 4'b0;

            ex_pc_exception_cause1_temp = 7'b0;
            ex_instbuffer_exception_cause1_temp = 7'b0;
            ex_id_exception_cause1_temp = 7'b0;
            ex_dispatch_exception_cause1_temp = 7'b0;

            ex_invtlb_op1_temp = 5'b0;
            ex_csr_write_en1_temp = 1'b0;
            ex_csr_addr1_temp = 14'b0;
            ex_pre_is_branch_taken1_temp = 1'b0;
            ex_pre_branch_addr1_temp = 32'b0;
            ex_csr_read_data1_temp = 32'b0;
        end
        if(send_en[1]) begin
            ex_pc2_temp = pc2_temp;
            ex_sort2_temp = sort2_temp; 
            ex_inst2_temp = inst2_temp;
            ex_valid2_temp = valid_temp[1];
            ex_alu_op2_temp = alu_op2_temp;
            ex_alu_sel2_temp = alu_sel2_temp;
            ex_is_div_temp[1] = is_div_temp[1];
            ex_is_mul_temp[1] = is_mul_temp[1];
            ex_reg_write_en2_temp = reg_write_en_temp[1];
            ex_reg_write_addr2_temp = reg_write_addr2_temp;
            ex_reg_read_data2_1_temp = reg_read_data2_1_temp;
            ex_reg_read_data2_2_temp = reg_read_data2_2_temp;
            ex_is_privilege2_temp = is_privilege_temp[1];

            ex_icacop_en2_temp    = icacop_en2;
            ex_dcacop_en2_temp    = dcacop_en2;
            ex_cacop_opcode2_temp = cacop_opcode2;

            ex_is_exception2_temp = is_exception2_temp;

            ex_pc_exception_cause2_temp = pc_exception_cause2_temp;
            ex_instbuffer_exception_cause2_temp = instbuffer_exception_cause2_temp;
            ex_id_exception_cause2_temp = id_exception_cause2_temp;
            ex_dispatch_exception_cause2_temp = dispatch_exception_cause2_temp;

            ex_invtlb_op2_temp = invtlb_op2_temp;
            ex_csr_write_en2_temp = csr_write_en_temp[1];
            ex_csr_addr2_temp = csr_addr2_temp;
            ex_pre_is_branch_taken2_temp = pre_is_branch_taken_temp[1];
            ex_pre_branch_addr2_temp = pre_branch_addr2_temp;
            ex_csr_read_data2_temp = csr_read_data2_temp;
        end
        else begin
            ex_pc2_temp = 32'b0;
            ex_sort2_temp = 1'b0;
            ex_inst2_temp = 32'b0;    
            ex_valid2_temp = 1'b0;
            ex_alu_op2_temp = 8'b0;
            ex_alu_sel2_temp = 3'b0;
            ex_is_div_temp[1] = 1'b0;
            ex_is_mul_temp[1] = 1'b0;
            ex_reg_write_en2_temp = 1'b0;
            ex_reg_write_addr2_temp = 5'b0;
            ex_reg_read_data2_1_temp = 32'b0;
            ex_reg_read_data2_2_temp = 32'b0;
            ex_is_privilege2_temp = 1'b0;

            ex_icacop_en2_temp    = 1'b0;
            ex_dcacop_en2_temp    = 1'b0;
            ex_cacop_opcode2_temp = 5'b0;

            ex_is_exception2_temp = 4'b0;

            ex_pc_exception_cause2_temp = 7'b0;
            ex_instbuffer_exception_cause2_temp = 7'b0;
            ex_id_exception_cause2_temp = 7'b0;
            ex_dispatch_exception_cause2_temp = 7'b0;

            ex_invtlb_op2_temp = 5'b0;
            ex_csr_write_en2_temp = 1'b0;
            ex_csr_addr2_temp = 14'b0;
            ex_pre_is_branch_taken2_temp = 1'b0;
            ex_pre_branch_addr2_temp = 32'b0;
            ex_csr_read_data2_temp = 32'b0;
        end
    end
    
    wire dispatch_current_pause;//褰撳墠鍙戝皠鍣ㄧ殑鏆傚仠淇″彿
    assign dispatch_current_pause =  !ex_pause && dispatch_pause;//濡傛灉ex闃舵娌℃湁鏆傚仠涓斿彂鐢焞oad-use鍐掗櫓锛屽垯鍙戝皠鍣ㄦ殏锟�??? 

    always @(posedge clk) begin
        if(rst || flush || dispatch_current_pause) begin
            pc1_o <= 32'b0;
            pc2_o <= 32'b0;
            inst1_o <= 32'b0;
            inst2_o <= 32'b0;
            valid_o <= 2'b0;
            reg_write_en_o <= 2'b0;
            reg_write_addr_o1 <= 5'b0;
            reg_write_addr_o2 <= 5'b0;
            alu_op_o1 <= 8'b0;
            alu_op_o2 <= 8'b0;
            alu_sel_o1 <= 3'b0;
            alu_sel_o2 <= 3'b0;
            is_div_o <= 2'b0;
            is_mul_o <= 2'b0;
            reg_read_data_o1_1 <= 32'b0;
            reg_read_data_o1_2 <= 32'b0;
            reg_read_data_o2_1 <= 32'b0;
            reg_read_data_o2_2 <= 32'b0;

            is_privilege_o <= 2'b0;

            icacop_en_o1 <= 1'b0;
            icacop_en_o2 <= 1'b0;
            dcacop_en_o1 <= 1'b0;
            dcacop_en_o2 <= 1'b0;
            cacop_opcode_o1 <= 5'b0;
            cacop_opcode_o2 <= 5'b0;

            is_exception_o1 <= 4'b0;
            is_exception_o2 <= 4'b0;

            pc_exception_cause_o1 <= 7'b0;
            instbuffer_exception_cause_o1 <= 7'b0;
            decoder_exception_cause_o1 <= 7'b0;
            dispatch_exception_cause_o1 <= 7'b0;
            pc_exception_cause_o2 <= 7'b0;
            instbuffer_exception_cause_o2 <= 7'b0;
            decoder_exception_cause_o2 <= 7'b0;
            dispatch_exception_cause_o2 <= 7'b0;

            invtlb_op_o1 <= 5'b0;
            invtlb_op_o2 <= 5'b0;
            csr_write_en_o <= 2'b0;
            csr_addr_o1 <= 14'b0;
            csr_addr_o2 <= 14'b0;
            csr_read_data_o1 <= 32'b0;
            csr_read_data_o2 <= 32'b0;
            pre_is_branch_taken_o <= 2'b0;
            pre_branch_addr_o1 <= 32'b0;
            pre_branch_addr_o2 <= 32'b0;
        end 
        else if( !pause ) begin
            pc1_o <= ex_pc1_temp;
            pc2_o <= ex_pc2_temp;
            sort1_o <= ex_sort1_temp;
            sort2_o <= ex_sort2_temp;
            inst1_o <= ex_inst1_temp;
            inst2_o <= ex_inst2_temp;
            valid_o <= {ex_valid2_temp, ex_valid1_temp};
            reg_write_en_o <= {ex_reg_write_en2_temp, ex_reg_write_en1_temp};
            reg_write_addr_o1 <= ex_reg_write_addr1_temp;
            reg_write_addr_o2 <= ex_reg_write_addr2_temp;
            alu_op_o1 <= ex_alu_op1_temp;
            alu_op_o2 <= ex_alu_op2_temp;
            alu_sel_o1 <= ex_alu_sel1_temp;
            alu_sel_o2 <= ex_alu_sel2_temp;
            is_div_o <= {ex_is_div_temp[1], ex_is_div_temp[0]};
            is_mul_o <= {ex_is_mul_temp[1], ex_is_mul_temp[0]};
            reg_read_data_o1_1 <= ex_reg_read_data1_1_temp;
            reg_read_data_o1_2 <= ex_reg_read_data1_2_temp;
            reg_read_data_o2_1 <= ex_reg_read_data2_1_temp;
            reg_read_data_o2_2 <= ex_reg_read_data2_2_temp;
            is_privilege_o <= {ex_is_privilege2_temp, ex_is_privilege1_temp};

            icacop_en_o1 <= ex_icacop_en1_temp;
            icacop_en_o2 <= ex_icacop_en2_temp;
            dcacop_en_o1 <= ex_dcacop_en1_temp;
            dcacop_en_o2 <= ex_dcacop_en2_temp;
            cacop_opcode_o1 <= ex_cacop_opcode1_temp;
            cacop_opcode_o2 <= ex_cacop_opcode2_temp;

            is_exception_o1 <= ex_is_exception1_temp;
            is_exception_o2 <= ex_is_exception2_temp;

            pc_exception_cause_o1 <= ex_pc_exception_cause1_temp;
            instbuffer_exception_cause_o1 <= ex_instbuffer_exception_cause1_temp;
            decoder_exception_cause_o1  <= ex_id_exception_cause1_temp;
            dispatch_exception_cause_o1 <= ex_dispatch_exception_cause1_temp;
            pc_exception_cause_o2 <= ex_pc_exception_cause2_temp;
            instbuffer_exception_cause_o2 <= ex_instbuffer_exception_cause2_temp;
            decoder_exception_cause_o2  <= ex_id_exception_cause2_temp;
            dispatch_exception_cause_o2 <= ex_dispatch_exception_cause2_temp;

            invtlb_op_o1 <= ex_invtlb_op1_temp;
            invtlb_op_o2 <= ex_invtlb_op2_temp;
            csr_write_en_o <= {ex_csr_write_en2_temp, ex_csr_write_en1_temp};
            csr_addr_o1 <= ex_csr_addr1_temp;
            csr_addr_o2 <= ex_csr_addr2_temp;
            csr_read_data_o1 <= ex_csr_read_data1_temp;
            csr_read_data_o2 <= ex_csr_read_data2_temp;
            pre_is_branch_taken_o <= {ex_pre_is_branch_taken2_temp, ex_pre_is_branch_taken1_temp};
            pre_branch_addr_o1 <= ex_pre_branch_addr1_temp;
            pre_branch_addr_o2 <= ex_pre_branch_addr2_temp;
        end
        else begin
            //鏆傚仠鏃朵笉鍋氫换浣曟搷锟�???
            //淇濈暀锟�???鏈夎緭鍑轰笉锟�???
            pc1_o <= pc1_o;
            pc2_o <= pc2_o;
            sort1_o <= sort1_o;
            sort2_o <= sort2_o;
            inst1_o <= inst1_o;
            inst2_o <= inst2_o;
            valid_o <= valid_o;
            reg_write_en_o <= reg_write_en_o;
            reg_write_addr_o1 <= reg_write_addr_o1;
            reg_write_addr_o2 <= reg_write_addr_o2;
            alu_op_o1 <= alu_op_o1;
            alu_op_o2 <= alu_op_o2;
            alu_sel_o1 <= alu_sel_o1;
            alu_sel_o2 <= alu_sel_o2;
            is_div_o <= is_div_o;
            is_mul_o <= is_mul_o;
            reg_read_data_o1_1 <= reg_read_data_o1_1;
            reg_read_data_o1_2 <= reg_read_data_o1_2;
            reg_read_data_o2_1 <= reg_read_data_o2_1;
            reg_read_data_o2_2 <= reg_read_data_o2_2;
            is_privilege_o <= is_privilege_o;

            icacop_en_o1 <= icacop_en_o1;
            icacop_en_o2 <= icacop_en_o2;
            dcacop_en_o1 <= dcacop_en_o1;
            dcacop_en_o2 <= dcacop_en_o2;
            cacop_opcode_o1 <= cacop_opcode_o1;
            cacop_opcode_o2 <= cacop_opcode_o2;

            is_exception_o1 <= is_exception_o1;
            is_exception_o2 <= is_exception_o2;

            pc_exception_cause_o1 <= pc_exception_cause_o1;
            instbuffer_exception_cause_o1 <= instbuffer_exception_cause_o1;
            decoder_exception_cause_o1  <= decoder_exception_cause_o1;
            dispatch_exception_cause_o1 <= dispatch_exception_cause_o1;
            pc_exception_cause_o2 <= pc_exception_cause_o2;
            instbuffer_exception_cause_o2 <= instbuffer_exception_cause_o2;
            decoder_exception_cause_o2  <= decoder_exception_cause_o2;
            dispatch_exception_cause_o2 <= dispatch_exception_cause_o2;
            invtlb_op_o1 <= invtlb_op_o1;
            invtlb_op_o2 <= invtlb_op_o2;
            
            csr_write_en_o <= csr_write_en_o;
            csr_addr_o1 <= csr_addr_o1;
            csr_addr_o2 <= csr_addr_o2;
            csr_read_data_o1 <= csr_read_data_o1;
            csr_read_data_o2 <= csr_read_data_o2;
            pre_is_branch_taken_o <= pre_is_branch_taken_o;
            pre_branch_addr_o1 <= pre_branch_addr_o1;
            pre_branch_addr_o2 <= pre_branch_addr_o2;
        end
    end
    
endmodule