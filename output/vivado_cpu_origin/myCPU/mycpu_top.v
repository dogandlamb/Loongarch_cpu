module mycpu_top(
    input  wire        clk,
    input  wire        resetn,

    //指令RAM相关接口
    output wire        inst_sram_we,
    output wire [31:0] inst_sram_addr,
    output wire [31:0] inst_sram_wdata,
    input  wire [31:0] inst_sram_rdata,

    //数据RAM相关接口
    output wire        data_sram_we,
    output wire [31:0] data_sram_addr,
    output wire [31:0] data_sram_wdata,
    input  wire [31:0] data_sram_rdata,

    //debug 接口
    output wire [31:0] debug_wb_pc,
    output wire [ 3:0] debug_wb_rf_we,
    output wire [ 4:0] debug_wb_rf_wnum,
    output wire [31:0] debug_wb_rf_wdata 
);

reg         reset;//高电平有效
always @ (posedge clk) reset <= ~resetn;

reg         valid;//valid时整个cpu才有效
always @ (posedge clk) begin
    if( reset ) begin
        valid<=1'b0;
    end
    else begin
        valid <= 1'b1;
    end
end

wire [31:0] pc;//目标指令的地址
wire [31:0] nextpc;//下一次目标指令的地址
//wire [31:0] seq_pc;//pc+4的值，顺序执行时的下一条指令地址


/////////////////////////////////////////////////////
//指令和分解的指令
wire [31:0] inst;//IF阶段取回的指令码

// wire [ 5:0] op_31_26;//若干位操作码，来自inst
// wire [ 3:0] op_25_22;
// wire [ 1:0] op_21_20;
// wire [ 4:0] op_19_15;

// wire [63:0] op_31_26_d;//译码后的操作码
// wire [15:0] op_25_22_d;
// wire [ 3:0] op_21_20_d;
// wire [31:0] op_19_15_d;
// has been moved to inst_dec by sssafridi

wire [ 4:0] rd;//rd寄存器地址
// wire [ 4:0] rj;//rj寄存器地址
// wire [ 4:0] rk;//rk寄存器地址
// has been moved to get_reg_read_addr

wire [4:0]  ui5;
wire [11:0] i12;//12位立即数
wire [15:0] i16;//16位立即数
wire [19:0] i20;
wire [25:0] i26;




////////////////////////////////////////////////
//alu_op、load_op等控制信号
wire [11:0] alu_op;//alu要执行的操作
wire        load_op;
wire [ 4:0] br_op;    



////////////////////////////////////////////////
//以下为指令标志
wire inst_add_w;//rj+rk写入rd
wire inst_addi_w;//rj+12位立即数扩展为32位，写入rd
wire inst_sub_w;
wire inst_ld_w;//从内存中取出32位，存入rd
wire inst_st_w;//word访问内存，32位数据，目标地址为rj寄存器数据加上12位立即数扩展到32位的结果之和，储存数据为rd寄存器的数据
wire inst_bne;
wire inst_slt;//有符号数比较，src1<src2为1，否则为0
wire inst_sltu;//无符号数比较，同上

wire inst_and;//与
wire inst_or;//或
wire inst_nor;//同或
wire inst_xor;//异或

wire inst_slli_w;//rj数据逻辑左移ui5，存入rd
wire inst_srli_w;//rj数据逻辑右移ui5，存入rd
wire inst_srai_w;//rj数据算术右移ui5，存入rd

wire inst_b;//无条件跳转到目标地址，地址偏移值为i26offs26逻辑左移两位再符号拓展
wire inst_bl;//无条件跳转到目标地址，偏移值同上，同时将该指令的pc＋4存到rl
wire inst_beq;//rjrd相等跳转目标地址
wire inst_jirl;//无条件跳转到目标地址，将pc值加＋存到rd，目标地址为i16offs16逻辑左移两位后再符号拓展加rj的值
wire inst_lu12i_w;//用于将20位bit立即数链接上12bit0后写入rd




////////////////////////////////////////////////
//指令的标志位
wire        src2_is_4;
wire        src1_is_pc;
wire        src2_is_imm;//源操作数为立即数的标志位
wire        dst_is_r1;
wire        res_from_mem;
wire        gr_we;
wire        rf_we;//寄存器写入使能
wire        mem_we;//内存写入使能
// wire        src_reg_is_rd;
//has been moved to get_reg_read_addr

wire        rj_eq_rd;
wire        br_taken;//需要跳转的标志位

// wire        need_ui5;
// wire        need_si12;
// wire        need_si16;
// wire        need_si20;
// wire        need_si26; // has been moved to imm_generator



////////////////////////////////////////////////
//寄存器堆相关数据地址与结果
wire [ 4:0] rf_raddr1;
wire [ 4:0] rf_raddr2;
wire [ 4:0] rf_waddr;

wire [ 4:0] dest;

wire [31:0] rf_wdata;//写入寄存器的数据



////////////////////////////////////////////////
//分支跳转
wire [31:0] br_offs;
//wire        br_taken;
//需要跳转的标志位

//wire [31:0] jirl_offs;


////////////////////////////////////////////////
//ALU相关计算数据、访存数据(load)、寄存器数据
wire [31:0] alu_imm;//扩展到32位的ALU立即数
wire [31:0] alu_src1;//计算的源操作数1
wire [31:0] alu_src2;//计算的源操作数2
wire [31:0] alu_result;//计算结果

wire [31:0] br_imm;

wire [31:0] mem_result;
wire [31:0] final_result;

wire [31:0] rf_rdata1;
wire [31:0] rf_rdata2;

wire [31:0] rj_value;
wire [31:0] rkd_value;


///////////////////////////////////////////////////
//IF阶段的指令寄存器和PC寄存器

//指令的移动控制
// always @ (posedge clk) begin
//     if( reset ) begin
//         pc <= 32'h1bfffffc;
//     end
//     else begin
//         pc <= nextpc;
//     end
// end

//下一指令地址赋值
// assign seq_pc = pc + 32'h4;
//assign nextpc = br_taken ? br_target : pc + 4;//每个指令占32位，四个字节

assign inst_sram_we     = 1'b0;//指令写入使能
assign inst_sram_addr   = pc;//输出指令地址
assign inst_sram_wdata  = 32'b0;
assign inst             = inst_sram_rdata;//获得指令



//////////////////////////////////////////////////
//ID阶段的指令译码和控制信号生成

//进行指令的分解
// assign op_31_26 = inst[31:26];
// assign op_25_22 = inst[25:22];
// assign op_21_20 = inst[21:20];
// assign op_19_15 = inst[19:15];
// has been moved to inst_dec

assign rd       = inst[ 4: 0];
// assign rj       = inst[ 9: 5];
// assign rk       = inst[14:10];
//has been moved to get_reg_read_addr

// assign ui5      = inst[14:10];
// assign i12      = inst[21:10];
// assign i16      = inst[25:10];
// assign i20      = inst[24: 5];
// assign i26      = {inst[ 9: 0] , inst[25:10]}; 
//sssafridi has moved these signals to imm_generator

//操作码译码
// decoder_6_64 u_dec0(.in(op_31_26 ), .co(op_31_26_d ));
// decoder_4_16 u_dec1(.in(op_25_22 ), .co(op_25_22_d ));
// decoder_2_4  u_dec2(.in(op_21_20 ), .co(op_21_20_d ));
// decoder_5_32 u_dec3(.in(op_19_15 ), .co(op_19_15_d ));
// have been moved to inst_dec


//指令激活，即标志位
//如果对应位为1，代表是某一类的指令，将对应指令的标志位置1
// assign inst_add_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h00];
// assign inst_addi_w  = op_31_26_d[6'h00] & op_25_22_d[4'ha];
// assign inst_sub_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h02];

// assign inst_slt     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h04];
// assign inst_sltu    = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h05];

// assign inst_nor     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h08];
// assign inst_and     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h09];
// assign inst_or      = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0a];
// assign inst_xor     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0b];

// assign inst_slli_w  = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h01];
// assign inst_srli_w  = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h09];
// assign inst_srai_w  = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h11];

// assign inst_ld_w    = op_31_26_d[6'h0a] & op_25_22_d[4'h2];
// assign inst_st_w    = op_31_26_d[6'h0a] & op_25_22_d[4'h6];

// assign inst_jirl    = op_31_26_d[6'h13];
// assign inst_b       = op_31_26_d[6'h14];
// assign inst_bl      = op_31_26_d[6'h15];
// assign inst_beq     = op_31_26_d[6'h16];
// assign inst_bne     = op_31_26_d[6'h17];

// assign inst_lu12i_w = op_31_26_d[6'h05] & ~inst[25];
// have been moved tp inst_dec by sssafridi

///////////////////////////////////////////////////////////////////
//控制信号生成
// assign need_ui5      = inst_slli_w | inst_srli_w | inst_srai_w;
// assign need_si12     = inst_addi_w | inst_ld_w | inst_st_w;
// assign need_si16     = inst_jirl | inst_beq | inst_bne;
// assign need_si20     = inst_lu12i_w;
// assign need_si26     = inst_b | inst_bl;
// assign src2_is_4     = inst_jirl | inst_bl; //sssafridi has moved these signals to imm_generator


// assign src2_is_imm   = inst_slli_w
//                      | inst_srli_w
//                      | inst_srai_w
//                      | inst_addi_w 
//                      | inst_ld_w 
//                      | inst_st_w
//                      | inst_lu12i_w
//                      | inst_jirl
//                      | inst_bl;//要用立即数的指令标志位相或 //sssafridi has moved this signal to ALU_srcGenerator
assign res_from_mem  = inst_ld_w;//从内存中读取数据的标志
assign gr_we         = ~(inst_st_w | inst_beq | inst_bne | inst_b);//只要有一个生效，就不需要写入
assign rf_we         = gr_we & valid;
assign mem_we        = inst_st_w;
assign rj_eq_rd  = (rj_value == rkd_value);
// assign src1_is_pc = inst_jirl | inst_bl; //sssafridi has moved this signal to ALU_srcGenerator  
assign dst_is_r1  = inst_bl;
assign data_sram_we    = mem_we & valid;//指令需要储存时，mem_we=1,向内存中写入数据
assign br_taken  = ((br_op[1] &  rj_eq_rd)
                 |  (br_op[0] & !rj_eq_rd)
                 |   br_op[4]
                 |   br_op[2]
                 |   br_op[3])
                 & valid;//bne比较rj和rd的值，如果不相等跳转到指定地址




//////////////////////////////////////////////////////////////////////
//寄存器读地址和写地址的生成
// assign rf_raddr1 = rj;
// assign rf_raddr2 = src_reg_is_rd ? rd   : rk;  // has been moved to get_reg_read_addr
assign dest      = dst_is_r1     ? 5'd1 : rd;  



/////////////////////////////////////////////////////////////////////
//EX:分支跳转地址的计算
assign br_offs =br_imm;
// assign br_offs   = need_si26 ?  {{ 4{i26[25]}} , i26[25:0] , 2'b00}:
//                                 {{14{i16[15]}} , i16[15:0] , 2'b00};
// assign jirl_offs = {{14{i16[15]}} , i16[15:0] , 2'b00};
// assign br_target = (inst_beq | inst_bne | inst_bl | inst_b) ? (pc + br_offs)
//                     : (rj_value + jirl_offs);




/////////////////////////////////////////////////////////
//EX:ALU操作数和ALU结果

//alu所需立即数的生成
// assign imm       =  src2_is_4 ? 32'h4               : 
//                     need_si20 ? {i20[19:0] , 12'b0} :
//                     need_si12 ? {{20{i12[11]}} , i12[11:0]} :
//                     need_ui5  ? {27'b0 , ui5[4:0]} :    
//                     need_si26 ? {{ 4{i26[25]}} , i26[25:0] , 2'b00}:
//                     need_si16 ? {{14{i16[15]}} , i16[15:0] , 2'b00}:
//                     32'b0;
//has been moved to imm_generator

//寄存器数据的读取和ALU操作数的选择
assign rj_value  = rf_rdata1;
assign rkd_value = rf_rdata2;

// assign alu_src1  = src1_is_pc  ? pc : rj_value;
// assign alu_src2  = src2_is_imm ? imm : rf_rdata2;

// alu_result 由 alu 单元输出

assign data_sram_addr  = alu_result;//store
assign data_sram_wdata = rkd_value;





/////////////////////////////////////////////////////////
//MEM
assign mem_result      = data_sram_rdata;



/////////////////////////////////////////////////////////
//WB阶段的结果选择和写回
assign final_result    = res_from_mem ? mem_result : alu_result;
//写回寄存器的数据
assign rf_waddr = dest;
assign rf_wdata = final_result;


//////////////////////////////////////////////////////////////////
//调试接口
assign debug_wb_pc       = pc;
assign debug_wb_rf_we    = {4{rf_we}};
assign debug_wb_rf_wnum  = dest;
assign debug_wb_rf_wdata = final_result;



regfile u_regfile(
    .clk    (clk       ),
    .raddr1 (rf_raddr1 ),    
    .rdata1 (rf_rdata1 ),
    .raddr2 (rf_raddr2 ),
    .rdata2 (rf_rdata2 ),
    .we     (rf_we     ),
    .waddr  (rf_waddr  ),
    .wdata  (rf_wdata  )
);


// alu u_alu(
//     .alu_op    (alu_op),
//     .alu_src1  (alu_src1),
//     .alu_src2  (alu_src2),
//     .alu_result(alu_result)
// );

pc u_pc(
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .nextpc(nextpc),
    .pc(pc)
);

npc u_npc(
    .valid(valid),
    .br_taken(br_taken),
    .br_op(br_op),
    .br_offs(br_offs),
    .rj_value(rj_value),
    .pc(pc2IF),
    .nextpc(nextpc)
);

wire [31:0] pc_2IF;
wire IF_readyGo;
wire [31:0]  pc_fromIF;
wire [31:0]  inst_fromIF;
IFport u_IFport(
    .clk(clk),
    .reset(reset),
    .valid(IF_valid),
    .inst_in(inst_sram_rdata),
    .pc_in(pc_2IF),
    .readyGo(IF_readyGo),
    .allowIn(IF_allowIn),
    .inst_out(inst_fromIF),
    .pc_out(pc_fromIF)
);

wire [31:0] inst_2ID;
wire [31:0] pc_2ID;
IF_ID_reg u_IF_ID_reg(
    .clk(clk),
    .reset(reset),
    .valid(IF_ID_reg_valid),
    .readyGo(IF_readyGo),
    .allowIn(IF_ID_reg_allowIn),
    .pc_in(pc_fromIF),
    .inst_in(inst_fromIF),
    .inst_out(inst_2ID),
    .pc_out(pc_2ID)
);

wire ID_readyGo;
wire [4:0] wb_reg_addr_fromID;
wire [31:0] alu_src1_fromID;
wire [31:0] alu_src2_fromID;
wire [31:0] br_imm_fromID;
wire [11:0] alu_op_fromID;
wire [4:0]  br_op_fromID;
wire [1:0]  mem_op_fromID;
wire [31:0] mem_wdata_fromID;
wire        wb_op_fromID;
ID_port u_ID_port(
    .clk(clk),
    .reset(reset),
    .valid(ID_valid),
    .inst(inst_2ID),
    .src1_rdata(src1_rdata),
    .src2_rdata(src2_rdata),
    .allowIn(ID_allowIn),
    .readyGo(ID_readyGo),
    .src1_addr(src1_addr),
    .src2_addr(src2_addr),
    .wb_reg_addr(wb_reg_addr_fromID),
    .alu_src1(alu_src1_fromID),
    .alu_src2(alu_src2_fromID),
    .br_imm(br_imm_fromID),
    .alu_op(alu_op_fromID),
    .br_op(br_op_fromID),
    .mem_op(mem_op_fromID),  
    .mem_wdata(mem_wdata_fromID),
    .wb_op(wb_op_fromID)
);

wire [4:0] wb_reg_addr_2EXE;
wire [31:0] alu_src1_2EXE;
wire [31:0] alu_src2_2EXE;
wire [31:0] br_imm_2EXE;
wire [11:0] alu_op_2EXE;
wire [31:0] mem_wdata_2EXE;
wire [4:0]  br_op_2EXE;
wire [1:0]  mem_op_2EXE;
wire wb_op_2EXE;
ID_EXE_reg u_ID_EXE_reg(
    .clk(clk),
    .reset(reset),
    .valid(ID_EXE_reg_valid),
    .readyGo(ID_readyGo),
    .allowIn(ID_EXE_reg_allowIn),
    .wb_reg_addr_in(wb_reg_addr_fromID),
    .alu_src1_in(alu_src1_fromID),
    .alu_src2_in(alu_src2_fromID),
    .br_imm_in(br_imm_fromID),
    .alu_op_in(alu_op_fromID),
    .br_op_in(br_op_fromID),
    .mem_wdata_in(mem_wdata_fromID),
    .mem_op_in(mem_op_fromID),
    .wb_op_in(wb_op_fromID),
    .wb_reg_addr_out(wb_reg_addr_2EXE),
    .alu_src1_out(alu_src1_2EXE),
    .alu_src2_out(alu_src2_2EXE),
    .br_imm_out(br_imm_2EXE),
    .alu_op_out(alu_op_2EXE),
    .mem_wdata_out(mem_wdata_2EXE),
    .br_op_out(br_op_2EXE),
    .mem_op_out(mem_op_2EXE),
    .wb_op_out(wb_op_2EXE)
);

wire EXE_readyGo;
wire [31:0] final_result_fromEXE;
EXEport u_EXEport(
    .clk(clk),
    .reset(clk),
    .valid(EXE_valid),
    . wb_reg_addr(wb_reg_addr_2EXE),
    . alu_src1(alu_src1_2EXE),
    . alu_src2(alu_src2_2EXE),
    . br_imm(br_imm_2EXE),
    . alu_op(alu_op_2EXE),
    . br_op(br_op_2EXE),
    . mem_wdata_in(mem_wdata_2EXE),
    . mem_op_in(mem_op_2EXE),
    . wb_op_in(wb_op_2EXE),
    . readyGo(EXE_readyGo),
    . allowIn(EXE_allowIn),
    . br_taken(br_taken),

    .final_result,
    .wb_reg_addr_out,
    .mem_op,
    .mem_wdata_out,
    .wb_op
);


wire IF_allowIn;
wire WB_allowIn;
wire ID_allowIn;
wire MEM_allowIn;
wire EXE_allowIn;
wire IF_ID_reg_allowIn;
wire ID_EXE_reg_allowIn;
wire EXE_MEM_reg_allowIn;
wire MEM_WB_reg_allowIn;
wire IF_ID_reg_valid;
wire ID_EXE_reg_valid;
wire EXE_MEM_reg_valid;
wire MEM_WB_reg_valid;
wire IF_valid;
wire ID_valid;
wire EXE_valid;
wire MEM_valid;
wire WB_valid;
pipeline_controller u_pipeline_controller(
    .clk(clk),
    .reset(reset),
    .block_sig(block_sig),
    .cancel_sig(cancel_sig),
    .IF_allowIn(IF_allowIn)
    .WB_allowIn(WB_allowIn),
    .ID_allowIn(ID_allowIn),
    .EXE_allowIn(EXE_allowIn),
    .MEM_allowIn(MEM_allowIn),
    .IF_ID_reg_allowIn(IF_ID_reg_allowIn),
    .ID_EXE_reg_allowIn(ID_EXE_reg_allowIn),
    .EXE_MEM_reg_allowIn(EXE_MEM_reg_allowIn),
    .MEM_WB_reg_allowIn(MEM_WB_reg_allowIn),
    .IF_ID_reg_valid(IF_ID_reg_valid),
    .ID_EXE_reg_valid(ID_EXE_reg_valid),
    .EXE_MEM_reg_valid(EXE_MEM_reg_valid),
    .MEM_WB_reg_valid(MEM_WB_reg_allowIn),
    .IF_valid(IF_valid),
    .ID_valid(ID_valid),
    .EXE_valid(EXE_valid),
    .MEM_valid(MEM_valid),
    .WB_valid(WB_valid)
);

wire cancel_sig;
wire forward_delivery_sig;
wire block_sig;
conflict_handle u_coflict_hanle(
    .clk                            (clk),
    .reset                          (reset),
    .br_conflict                    (br_conflict),
    .data_conflict_between_ID_EXE   (data_conflict_between_ID_EXE),
    .data_conflict_between_ID_MEM   (data_conflict_between_ID_MEM),
    .data_conflict_between_ID_WB    (data_conflict_between_ID_WB),
    .block_sig                      (block_sig),
    .forward_delivery_sig           (forward_delivery_sig),
    .cancel_sig                     (cancel_sig)
);


wire [4:0] exe_reg_dest;
wire [4:0] mem_reg_dest;
wire [4:0] wb_reg_dest;
wire br_conflict
wire data_conflict_between_ID_EXE;
wire data_conflict_between_ID_MEM;
wire data_conflict_between_ID_WB;
conflict_detector u_conflictdetector(
    .clk            (clk),
    .reset          (reset),
    .alu_src1_addr  (alu_src1_addr),
    .alu_src2_addr  (alu_src2_addr),
    .br_taken       (br_taken),
    .exe_reg_dest   (exe_reg_dest),
    .mem_reg_dest   (mem_reg_dest),
    .wb_reg_dest    (wb_reg_dest),
    .br_conflict    (br_conflict),
    .data_conflict_between_ID_EXE   (data_conflict_between_ID_EXE),
    .data_conflict_between_ID_MEM   (data_conflict_between_ID_MEM),
    .data_conflict_between_ID_WB    (data_conflict_between_ID_WB)
);
/////////////////////////////////////////////////////////////
//生成alu操作码和分支跳转操作码

// op_dec u_op_dec(
//     .reset        	(reset         ),
//     .inst_add_w   	(inst_add_w    ),
//     .inst_addi_w  	(inst_addi_w   ),
//     .inst_sub_w   	(inst_sub_w    ),
//     .inst_ld_w    	(inst_ld_w     ),
//     .inst_st_w    	(inst_st_w     ),
//     .inst_bne     	(inst_bne      ),
//     .inst_slt     	(inst_slt      ),
//     .inst_sltu    	(inst_sltu     ),
//     .inst_and     	(inst_and      ),
//     .inst_or      	(inst_or       ),
//     .inst_nor     	(inst_nor      ),
//     .inst_xor     	(inst_xor      ),
//     .inst_slli_w  	(inst_slli_w   ),
//     .inst_srli_w  	(inst_srli_w   ),
//     .inst_srai_w  	(inst_srai_w   ),
//     .inst_b       	(inst_b        ),
//     .inst_bl      	(inst_bl       ),
//     .inst_beq     	(inst_beq      ),
//     .inst_jirl    	(inst_jirl     ),
//     .inst_lu12i_w 	(inst_lu12i_w  ),
//     .alu_op       	(alu_op        ),
//     .br_op        	(br_op         )
// );


// ALU_srcGenerator u_ALU_srcGenerator(
//     .reset(reset),
//     .inst_add_w(inst_add_w),
//     .inst_addi_w(inst_addi_w),
//     .inst_sub_w(inst_sub_w),
//     .inst_ld_w(inst_ld_w),
//     .inst_st_w(inst_st_w),
//     .inst_bne(inst_bne),
//     .inst_slt(inst_slt),
//     .inst_sltu(inst_sltu),
//     .inst_and(inst_and),
//     .inst_or(inst_or),
//     .inst_nor(inst_nor),
//     .inst_xor(inst_xor),
//     .inst_slli_w(inst_slli_w),
//     .inst_srli_w(inst_srli_w),
//     .inst_srai_w(inst_srai_w),
//     .inst_b(inst_b),
//     .inst_bl(inst_bl),
//     .inst_beq(inst_beq),
//     .inst_jirl(inst_jirl),
//     .inst_lu12i_w(inst_lu12i_w),



//     .rj_value(rj_value),
//     .rkd_value(rkd_value),
//     .imm(alu_imm),
//     .pc(pc),
//     .alu_src1(alu_src1),
//     .alu_src2(alu_src2)
// );


// get_reg_read_addr u_get_reg_read_addr(
//     .reset(reset),
//     .inst(inst),
//     .inst_add_w(inst_add_w),
//     .inst_addi_w(inst_addi_w),
//     .inst_sub_w(inst_sub_w),
//     .inst_ld_w(inst_ld_w),
//     .inst_st_w(inst_st_w),
//     .inst_bne(inst_bne),
//     .inst_slt(inst_slt),
//     .inst_sltu(inst_sltu),
//     .inst_and(inst_and),
//     .inst_or(inst_or),
//     .inst_nor(inst_nor),
//     .inst_xor(inst_xor),
//     .inst_slli_w(inst_slli_w),
//     .inst_srli_w(inst_srli_w),
//     .inst_srai_w(inst_srai_w),
//     .inst_b(inst_b),
//     .inst_bl(inst_bl),
//     .inst_beq(inst_beq),
//     .inst_jirl(inst_jirl),
//     .inst_lu12i_w(inst_lu12i_w),
//     .rf_raddr1(rf_raddr1),
//     .rf_raddr2(rf_raddr2)
// );

// imm_generator u_imm_generator(
//     .reset(reset),
//     .inst(inst),
//     .inst_add_w(inst_add_w),
//     .inst_addi_w(inst_addi_w),
//     .inst_sub_w(inst_sub_w),
//     .inst_ld_w(inst_ld_w),
//     .inst_st_w(inst_st_w),
//     .inst_bne(inst_bne),
//     .inst_slt(inst_slt),
//     .inst_sltu(inst_sltu),
//     .inst_and(inst_and),
//     .inst_or(inst_or),
//     .inst_nor(inst_nor),
//     .inst_xor(inst_xor),
//     .inst_slli_w(inst_slli_w),
//     .inst_srli_w(inst_srli_w),
//     .inst_srai_w(inst_srai_w),
//     .inst_b(inst_b),
//     .inst_bl(inst_bl),
//     .inst_beq(inst_beq),
//     .inst_jirl(inst_jirl),
//     .inst_lu12i_w(inst_lu12i_w),
//     .alu_imm(alu_imm),
//     .br_imm(br_imm)
// );

// inst_dec u_inst_dec(
//     .reset(reset),
//     .inst(inst),
//     .inst_add_w(inst_add_w),
//     .inst_addi_w(inst_addi_w),
//     .inst_sub_w(inst_sub_w),
//     .inst_ld_w(inst_ld_w),
//     .inst_st_w(inst_st_w),
//     .inst_bne(inst_bne),
//     .inst_slt(inst_slt),
//     .inst_sltu(inst_sltu),
//     .inst_and(inst_and),
//     .inst_or(inst_or),
//     .inst_nor(inst_nor),
//     .inst_xor(inst_xor),
//     .inst_slli_w(inst_slli_w),
//     .inst_srli_w(inst_srli_w),
//     .inst_srai_w(inst_srai_w),
//     .inst_b(inst_b),
//     .inst_bl(inst_bl),
//     .inst_beq(inst_beq),
//     .inst_jirl(inst_jirl),
//     .inst_lu12i_w(inst_lu12i_w),
// );




endmodule