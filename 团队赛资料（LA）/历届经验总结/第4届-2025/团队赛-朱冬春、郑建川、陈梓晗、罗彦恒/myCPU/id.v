`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"


module id
(   
    input wire   valid,

    input wire [31:0] pc,
    input wire [31:0] inst,

    input wire  pre_taken,          // 閸掑棙鏁０鍕ゴ缂佹挻鐏夐敍鍫熸Ц閸氾箒鐑︽潪顒婄礆
    input wire [31:0] pre_addr,     // 妫板嫭绁撮崚鍡樻暜鐠哄疇娴嗛惄顔界垼閸︽澘娼�
    input wire [1:0] is_exception,
    input wire [6:0] pc_exception_cause,
    input wire [6:0] instbuffer_exception_cause,


    output reg  id_valid,

    output reg  [31:0] pc_out,
    output reg  [31:0] inst_out,

    output reg  [2:0] is_exception_out,                 //閺勵垰鎯佸鍌氱埗
    output reg  [6:0] pc_exception_cause_out,           //瀵倸鐖堕崢鐔锋礈
    output reg  [6:0] instbuffer_exception_cause_out, 
    output reg  [6:0] decoder_exception_cause_out,

    output reg  [7:0]aluop,
    output reg  [2:0]alusel,
    output reg  [31:0]imm,

    output reg          is_div,
    output reg          is_mul,

    output reg  reg1_read_en,       //rR1鐎靛嫬鐡ㄩ崳銊嚢娴ｈ儻鍏�
    output reg  reg2_read_en,       //rR2鐎靛嫬鐡ㄩ崳銊嚢娴ｈ儻鍏�
    output reg  [4:0]reg1_read_addr,
    output reg  [4:0]reg2_read_addr,
    output reg  reg_writen_en,          //鐎靛嫬鐡ㄩ崳銊ュ晸娴ｈ儻鍏樻穱鈥冲娇
    output reg  [4:0]reg_write_addr,    //閻╊喚娈戠€靛嫬鐡ㄩ崳銊ユ勾閿燂拷?

    output reg  id_pre_taken,
    output reg  [31:0] id_pre_addr,

    output reg  is_privilege,       //閻楄娼堥幐鍥︽姢閺嶅洤绻�
    output reg  csr_read_en,        //CSR鐎靛嫬鐡ㄩ崳銊嚢娴ｈ儻鍏�
    output reg  csr_write_en,       //CSR鐎靛嫬鐡ㄩ崳銊ュ晸娴ｈ儻鍏�
    output reg  [13:0] csr_addr,    //CSR
    output reg  is_cnt,             //閺勵垰鎯侀弰顖濐吀閺佹澘娅掔€靛嫬鐡ㄩ敓锟�?
    output reg  [4:0]invtlb_op           //TLB閺冪姵鏅ラ幙宥勭稊

);
    wire  [6:0]  id_valid_o;
    
    wire  [31:0] id_pc_out0;
    wire  [31:0] id_pc_out1;
    wire  [31:0] id_pc_out2;
    wire  [31:0] id_pc_out3;
    wire  [31:0] id_pc_out4;
    wire  [31:0] id_pc_out5;
    wire  [31:0] id_pc_out6;

    wire  [2:0]  id_is_exception0;           //閺勵垰鎯佸鍌氱埗
    wire  [2:0]  id_is_exception1;
    wire  [2:0]  id_is_exception2;
    wire  [2:0]  id_is_exception3;
    wire  [2:0]  id_is_exception4;
    wire  [2:0]  id_is_exception5;          // 鏉╂瑤閲滄總钘夊剼濞岋紕鏁ら敓锟�?
    wire  [2:0]  id_is_exception6;

    wire  [6:0]  id_pc_exception_cause0;    //瀵倸鐖堕崢鐔锋礈 
    wire  [6:0]  id_pc_exception_cause1;
    wire  [6:0]  id_pc_exception_cause2;
    wire  [6:0]  id_pc_exception_cause3;
    wire  [6:0]  id_pc_exception_cause4;
    wire  [6:0]  id_pc_exception_cause5;
    wire  [6:0]  id_pc_exception_cause6;

    wire  [6:0]  id_instbuffer_exception_cause0; 
    wire  [6:0]  id_instbuffer_exception_cause1; 
    wire  [6:0]  id_instbuffer_exception_cause2; 
    wire  [6:0]  id_instbuffer_exception_cause3; 
    wire  [6:0]  id_instbuffer_exception_cause4; 
    wire  [6:0]  id_instbuffer_exception_cause5; 
    wire  [6:0]  id_instbuffer_exception_cause6; 

    wire  [6:0]  id_decoder_exception_cause0;
    wire  [6:0]  id_decoder_exception_cause1;
    wire  [6:0]  id_decoder_exception_cause2;
    wire  [6:0]  id_decoder_exception_cause3;
    wire  [6:0]  id_decoder_exception_cause4;
    wire  [6:0]  id_decoder_exception_cause5;
    wire  [6:0]  id_decoder_exception_cause6;

    wire  [31:0] id_inst_out0;
    wire  [31:0] id_inst_out1;
    wire  [31:0] id_inst_out2;
    wire  [31:0] id_inst_out3;
    wire  [31:0] id_inst_out4;
    wire  [31:0] id_inst_out5;
    wire  [31:0] id_inst_out6;

    wire  [6:0]  id_reg_writen_en; 

    wire  [7:0]  id_aluop0;
    wire  [7:0]  id_aluop1;
    wire  [7:0]  id_aluop2;
    wire  [7:0]  id_aluop3;
    wire  [7:0]  id_aluop4;
    wire  [7:0]  id_aluop5;
    wire  [7:0]  id_aluop6;

    wire  [2:0]  id_alusel0;
    wire  [2:0]  id_alusel1;
    wire  [2:0]  id_alusel2;
    wire  [2:0]  id_alusel3;
    wire  [2:0]  id_alusel4;
    wire  [2:0]  id_alusel5;
    wire  [2:0]  id_alusel6;

    wire  [31:0] id_imm0;
    wire  [31:0] id_imm1;
    wire  [31:0] id_imm2;
    wire  [31:0] id_imm3;
    wire  [31:0] id_imm4;
    wire  [31:0] id_imm5;
    wire  [31:0] id_imm6;

    wire  [6:0]  id_is_div;        
    wire  [6:0]  id_is_mul;

    wire  [6:0]  id_reg1_read_en;   
    wire  [6:0]  id_reg2_read_en;   

    wire  [4:0]  id_reg1_read_addr0;
    wire  [4:0]  id_reg1_read_addr1;
    wire  [4:0]  id_reg1_read_addr2;
    wire  [4:0]  id_reg1_read_addr3;
    wire  [4:0]  id_reg1_read_addr4;
    wire  [4:0]  id_reg1_read_addr5;
    wire  [4:0]  id_reg1_read_addr6;

    wire  [4:0]  id_reg2_read_addr0;
    wire  [4:0]  id_reg2_read_addr1;
    wire  [4:0]  id_reg2_read_addr2;
    wire  [4:0]  id_reg2_read_addr3;
    wire  [4:0]  id_reg2_read_addr4;
    wire  [4:0]  id_reg2_read_addr5;
    wire  [4:0]  id_reg2_read_addr6;

    wire  [4:0]  id_reg_write_addr0;
    wire  [4:0]  id_reg_write_addr1;
    wire  [4:0]  id_reg_write_addr2;
    wire  [4:0]  id_reg_write_addr3;
    wire  [4:0]  id_reg_write_addr4;
    wire  [4:0]  id_reg_write_addr5;
    wire  [4:0]  id_reg_write_addr6;

    wire  [6:0]  id_is_privilege;   //閻楄娼堥幐鍥︽姢閺嶅洤绻�
    wire  [6:0]  id_csr_read_en;    //CSR鐎靛嫬鐡ㄩ崳銊嚢娴ｈ儻鍏�
    wire  [6:0]  id_csr_write_en;   //CSR鐎靛嫬鐡ㄩ崳銊ュ晸娴ｈ儻鍏�

    wire  [13:0] id_csr_addr0;      //CSR
    wire  [13:0] id_csr_addr1;
    wire  [13:0] id_csr_addr2;
    wire  [13:0] id_csr_addr3;
    wire  [13:0] id_csr_addr4;
    wire  [13:0] id_csr_addr5;
    wire  [13:0] id_csr_addr6;

    wire  [6:0]  id_is_cnt;         //閺勵垰鎯侀弰顖濐吀閺佹澘娅掔€靛嫬鐡ㄩ敓锟�?

    wire  [4:0]  id_invtlb_op0;     //TLB閺冪姵鏅ラ幙宥勭稊  
    wire  [4:0]  id_invtlb_op1;
    wire  [4:0]  id_invtlb_op2;
    wire  [4:0]  id_invtlb_op3;
    wire  [4:0]  id_invtlb_op4;
    wire  [4:0]  id_invtlb_op5;
    wire  [4:0]  id_invtlb_op6;

    wire invtlb_exception;

    wire [6:0]  id_valid_vec;       //鏉╂瑤閲�6娴ｅ秶娈戦崥鎴﹀櫤鐞涖劎銇氶崫顏冮嚋鐟欙絿鐖滈崳銊ф畱鏉堟挸鍤弰顖涙箒閺佸牏娈�

    id_1R_I26 u_id_1R_I26 (
        .pc(pc),
        .inst(inst),

        .inst_valid(id_valid_vec[0]),
        .pc_out(id_pc_out0),
        .is_exception(id_is_exception0),
        .pc_exception_cause(id_pc_exception_cause0),
        .instbuffer_exception_cause(id_instbuffer_exception_cause0),
        .decoder_exception_cause(id_decoder_exception_cause0),
        .inst_out(id_inst_out0),
        .reg_writen_en(id_reg_writen_en[0]), 
        .aluop(id_aluop0),
        .alusel(id_alusel0),
        .imm(id_imm0),
        .is_div(id_is_div[0]),
        .is_mul(id_is_mul[0]),
        .reg1_read_en(id_reg1_read_en[0]),   
        .reg2_read_en(id_reg2_read_en[0]),  
        .reg1_read_addr(id_reg1_read_addr0),
        .reg2_read_addr(id_reg2_read_addr0),
        .reg_write_addr(id_reg_write_addr0),
        .is_privilege(id_is_privilege[0]),
        .csr_read_en(id_csr_read_en[0]),
        .csr_write_en(id_csr_write_en[0]),
        .csr_addr(id_csr_addr0),
        .is_cnt(id_is_cnt[0]),
        .invtlb_op(id_invtlb_op0)
    ); 

    id_1RI20 u_id_1RI20 (
        .pc(pc),
        .inst(inst),

        .inst_valid(id_valid_vec[1]),
        .pc_out(id_pc_out1),
        .is_exception(id_is_exception1),
        .pc_exception_cause(id_pc_exception_cause1),
        .instbuffer_exception_cause(id_instbuffer_exception_cause1),
        .decoder_exception_cause(id_decoder_exception_cause1),
        .inst_out(id_inst_out1),
        .reg_writen_en(id_reg_writen_en[1]),
        .aluop(id_aluop1),
        .alusel(id_alusel1),
        .imm(id_imm1),
        .is_div(id_is_div[1]),
        .is_mul(id_is_mul[1]),
        .reg1_read_en(id_reg1_read_en[1]),  
        .reg2_read_en(id_reg2_read_en[1]),   
        .reg1_read_addr(id_reg1_read_addr1),
        .reg2_read_addr(id_reg2_read_addr1),
        .reg_write_addr(id_reg_write_addr1),
        .is_privilege(id_is_privilege[1]),
        .csr_read_en(id_csr_read_en[1]),
        .csr_write_en(id_csr_write_en[1]),
        .csr_addr(id_csr_addr1),
        .is_cnt(id_is_cnt[1]),
        .invtlb_op(id_invtlb_op1)
    ); 

    id_2RI12 u_id_2RI12 (
        .pc(pc),
        .inst(inst),

        .inst_valid(id_valid_vec[2]),
        .pc_out(id_pc_out2),
        .is_exception(id_is_exception2),
        .pc_exception_cause(id_pc_exception_cause2),
        .instbuffer_exception_cause(id_instbuffer_exception_cause2),
        .decoder_exception_cause(id_decoder_exception_cause2),
        .inst_out(id_inst_out2),
        .reg_writen_en(id_reg_writen_en[2]), 
        .aluop(id_aluop2),
        .alusel(id_alusel2),
        .imm(id_imm2),
        .is_div(id_is_div[2]),
        .is_mul(id_is_mul[2]),
        .reg1_read_en(id_reg1_read_en[2]),   
        .reg2_read_en(id_reg2_read_en[2]),   
        .reg1_read_addr(id_reg1_read_addr2),
        .reg2_read_addr(id_reg2_read_addr2),
        .reg_write_addr(id_reg_write_addr2),
        .is_privilege(id_is_privilege[2]),
        .csr_read_en(id_csr_read_en[2]),
        .csr_write_en(id_csr_write_en[2]),
        .csr_addr(id_csr_addr2),
        .is_cnt(id_is_cnt[2]),
        .invtlb_op(id_invtlb_op2)
    ); 

    id_2RI14 u_id_2RI14 (
        .pc(pc),
        .inst(inst),

        .inst_valid(id_valid_vec[3]),
        .pc_out(id_pc_out3),
        .is_exception(id_is_exception3),
        .pc_exception_cause(id_pc_exception_cause3),
        .instbuffer_exception_cause(id_instbuffer_exception_cause3),
        .decoder_exception_cause(id_decoder_exception_cause3),
        .inst_out(id_inst_out3),
        .reg_write_en(id_reg_writen_en[3]),
        .aluop(id_aluop3),
        .alusel(id_alusel3),
        .imm(id_imm3),
        .is_div(id_is_div[3]),
        .is_mul(id_is_mul[3]),
        .reg1_read_en(id_reg1_read_en[3]),  
        .reg2_read_en(id_reg2_read_en[3]),  
        .reg1_read_addr(id_reg1_read_addr3),
        .reg2_read_addr(id_reg2_read_addr3),
        .reg_write_addr(id_reg_write_addr3),
        .is_privilege(id_is_privilege[3]),
        .csr_read_en(id_csr_read_en[3]),
        .csr_write_en(id_csr_write_en[3]),
        .csr_addr(id_csr_addr3),
        .is_cnt(id_is_cnt[3]),
        .invtlb_op(id_invtlb_op3)
    ); 

    id_2RI16 u_id_2RI16 (
        .pc(pc),
        .inst(inst),

        .inst_valid(id_valid_vec[4]),
        .pc_out(id_pc_out4),
        .is_exception(id_is_exception4),
        .pc_exception_cause(id_pc_exception_cause4),
        .instbuffer_exception_cause(id_instbuffer_exception_cause4),
        .decoder_exception_cause(id_decoder_exception_cause4),
        .inst_out(id_inst_out4),
        .reg_writen_en(id_reg_writen_en[4]), 
        .aluop(id_aluop4),
        .alusel(id_alusel4),
        .imm(id_imm4),
        .is_div(id_is_div[4]),
        .is_mul(id_is_mul[4]),
        .reg1_read_en(id_reg1_read_en[4]),   
        .reg2_read_en(id_reg2_read_en[4]),   
        .reg1_read_addr(id_reg1_read_addr4),
        .reg2_read_addr(id_reg2_read_addr4),
        .reg_write_addr(id_reg_write_addr4),
        .is_privilege(id_is_privilege[4]),
        .csr_read_en(id_csr_read_en[4]),
        .csr_write_en(id_csr_write_en[4]),
        .csr_addr(id_csr_addr4),
        .is_cnt(id_is_cnt[4]),
        .invtlb_op(id_invtlb_op4)
    ); 

    id_3R u_id_3R (
        .pc(pc),
        .inst(inst),

        .inst_valid(id_valid_vec[5]),
        .pc_out(id_pc_out5),
        .is_exception(id_is_exception5),
        .pc_exception_cause(id_pc_exception_cause5),
        .instbuffer_exception_cause(id_instbuffer_exception_cause5),
        .decoder_exception_cause(id_decoder_exception_cause5),
        .inst_out(id_inst_out5),
        .reg_write_en(id_reg_writen_en[5]), 
        .aluop(id_aluop5),
        .alusel(id_alusel5),
        .imm(id_imm5),
        .is_div(id_is_div[5]),
        .is_mul(id_is_mul[5]),
        .reg1_read_en(id_reg1_read_en[5]),  
        .reg2_read_en(id_reg2_read_en[5]),   
        .reg1_read_addr(id_reg1_read_addr5),
        .reg2_read_addr(id_reg2_read_addr5),
        .reg_write_addr(id_reg_write_addr5),
        .is_privilege(id_is_privilege[5]),
        .csr_read_en(id_csr_read_en[5]),
        .csr_write_en(id_csr_write_en[5]),
        .csr_addr(id_csr_addr5),
        .is_cnt(id_is_cnt[5]),
        .invtlb_op(id_invtlb_op5),
        .invtlb_exception(invtlb_exception)
    ); 
    
    id_2R u_id_2R (
        .pc(pc),
        .inst(inst),

        .inst_valid(id_valid_vec[6]),
        .pc_out(id_pc_out6),
        .is_exception(id_is_exception6),
        .pc_exception_cause(id_pc_exception_cause6),
        .instbuffer_exception_cause(id_instbuffer_exception_cause6),
        .decoder_exception_cause(id_decoder_exception_cause6),
        .inst_out(id_inst_out6),
        .reg_write_en(id_reg_writen_en[6]), 
        .aluop(id_aluop6),
        .alusel(id_alusel6),
        .imm(id_imm6),
        .is_div(id_is_div[6]),
        .is_mul(id_is_mul[6]),
        .reg1_read_en(id_reg1_read_en[6]),   
        .reg2_read_en(id_reg2_read_en[6]),  
        .reg1_read_addr(id_reg1_read_addr6),
        .reg2_read_addr(id_reg2_read_addr6),
        .reg_write_addr(id_reg_write_addr6),
        .is_privilege(id_is_privilege[6]),
        .csr_read_en(id_csr_read_en[6]),
        .csr_write_en(id_csr_write_en[6]),
        .csr_addr(id_csr_addr6),
        .is_cnt(id_is_cnt[6]),
        .invtlb_op(id_invtlb_op6)
    ); 


    wire sys_exception;
    wire brk_exception;
    assign sys_exception = aluop == `ALU_SYSCALL;
    assign brk_exception = aluop == `ALU_BREAK;
    reg  [6:0]id_exception_cause_else;

    always  @(*) begin
        if (sys_exception) begin
            id_exception_cause_else = `EXCEPTION_SYS;
        end else if (brk_exception) begin
            id_exception_cause_else = `EXCEPTION_BRK;
        end else if (invtlb_exception) begin
            id_exception_cause_else = `EXCEPTION_INE;
        end else begin
            id_exception_cause_else = `EXCEPTION_NOP;
        end
    end


    always  @(*) begin
        case(id_valid_vec)
            7'b0000001: begin
                pc_out = id_pc_out0;
                is_exception_out = {is_exception,1'b0};
                pc_exception_cause_out = pc_exception_cause;
                instbuffer_exception_cause_out = id_instbuffer_exception_cause0;
                decoder_exception_cause_out = id_decoder_exception_cause0;
                inst_out = id_inst_out0;
                reg_writen_en = id_reg_writen_en[0]; 
                aluop = id_aluop0;
                alusel = id_alusel0;
                imm = id_imm0;
                is_div = id_is_div[0];
                is_mul = id_is_mul[0];
                reg1_read_en = id_reg1_read_en[0];   
                reg2_read_en = id_reg2_read_en[0];   
                reg1_read_addr = id_reg1_read_addr0;
                reg2_read_addr = id_reg2_read_addr0;
                reg_write_addr = id_reg_write_addr0;
                is_privilege = id_is_privilege[0];
                csr_read_en = id_csr_read_en[0];
                csr_write_en = id_csr_write_en[0];
                csr_addr = id_csr_addr0;
                is_cnt = id_is_cnt[0];
                invtlb_op = id_invtlb_op0;
            end
            7'b0000010: begin
                pc_out = id_pc_out1;
                is_exception_out = {is_exception,1'b0};
                pc_exception_cause_out = pc_exception_cause;
                instbuffer_exception_cause_out = id_instbuffer_exception_cause1;
                decoder_exception_cause_out = id_decoder_exception_cause1;
                inst_out = id_inst_out1;
                reg_writen_en = id_reg_writen_en[1]; 
                aluop = id_aluop1;
                alusel = id_alusel1;
                imm = id_imm1;
                is_div = id_is_div[1];
                is_mul = id_is_mul[1];
                reg1_read_en = id_reg1_read_en[1];   
                reg2_read_en = id_reg2_read_en[1];   
                reg1_read_addr = id_reg1_read_addr1;
                reg2_read_addr = id_reg2_read_addr1;
                reg_write_addr = id_reg_write_addr1;
                is_privilege = id_is_privilege[1];
                csr_read_en = id_csr_read_en[1];    
                csr_write_en = id_csr_write_en[1];
                csr_addr = id_csr_addr1;
                is_cnt = id_is_cnt[1];
                invtlb_op = id_invtlb_op1;
            end
            7'b0000100: begin
                pc_out = id_pc_out2;
                is_exception_out = {is_exception,1'b0};
                pc_exception_cause_out = pc_exception_cause;
                instbuffer_exception_cause_out = id_instbuffer_exception_cause2;
                decoder_exception_cause_out = id_decoder_exception_cause2;
                inst_out = id_inst_out2;
                reg_writen_en = id_reg_writen_en[2]; 
                aluop = id_aluop2;
                alusel = id_alusel2;
                imm = id_imm2;
                is_div = id_is_div[2];
                is_mul = id_is_mul[2];
                reg1_read_en = id_reg1_read_en[2];   
                reg2_read_en = id_reg2_read_en[2];   
                reg1_read_addr = id_reg1_read_addr2;
                reg2_read_addr = id_reg2_read_addr2;
                reg_write_addr = id_reg_write_addr2;
                is_privilege = id_is_privilege[2];
                csr_read_en = id_csr_read_en[2];
                csr_write_en = id_csr_write_en[2];
                csr_addr = id_csr_addr2;
                is_cnt = id_is_cnt[2];
                invtlb_op = id_invtlb_op2;
            end
            7'b0001000: begin
                pc_out = id_pc_out3;
                is_exception_out = {is_exception,1'b0};
                pc_exception_cause_out = pc_exception_cause;
                instbuffer_exception_cause_out = id_instbuffer_exception_cause3;
                decoder_exception_cause_out = id_decoder_exception_cause3;
                inst_out = id_inst_out3;
                reg_writen_en = id_reg_writen_en[3]; 
                aluop = id_aluop3;
                alusel = id_alusel3;
                imm = id_imm3;
                is_div = id_is_div[3];
                is_mul = id_is_mul[3];
                reg1_read_en = id_reg1_read_en[3];   
                reg2_read_en = id_reg2_read_en[3];   
                reg1_read_addr = id_reg1_read_addr3;
                reg2_read_addr = id_reg2_read_addr3;
                reg_write_addr = id_reg_write_addr3;
                is_privilege = id_is_privilege[3];
                csr_read_en = id_csr_read_en[3];
                csr_write_en = id_csr_write_en[3];
                csr_addr = id_csr_addr3;
                is_cnt = id_is_cnt[3];
                invtlb_op = id_invtlb_op3;
            end
            7'b0010000: begin
                pc_out = id_pc_out4;
                is_exception_out = {is_exception,1'b0};
                pc_exception_cause_out = pc_exception_cause;
                instbuffer_exception_cause_out = id_instbuffer_exception_cause4;
                decoder_exception_cause_out = id_decoder_exception_cause4;
                inst_out = id_inst_out4;
                reg_writen_en = id_reg_writen_en[4]; 
                aluop = id_aluop4;
                alusel = id_alusel4;
                imm = id_imm4;
                is_div = id_is_div[4];
                is_mul = id_is_mul[4];
                reg1_read_en = id_reg1_read_en[4];   
                reg2_read_en = id_reg2_read_en[4];   
                reg1_read_addr = id_reg1_read_addr4;
                reg2_read_addr = id_reg2_read_addr4;
                reg_write_addr = id_reg_write_addr4;
                is_privilege = id_is_privilege[4];
                csr_read_en = id_csr_read_en[4];
                csr_write_en = id_csr_write_en[4];
                csr_addr = id_csr_addr4;
                is_cnt = id_is_cnt[4];
                invtlb_op = id_invtlb_op4;
            end
            7'b0100000: begin
                pc_out = id_pc_out5;
                is_exception_out = {is_exception,sys_exception | brk_exception | invtlb_exception};
                pc_exception_cause_out = pc_exception_cause;  
                instbuffer_exception_cause_out = instbuffer_exception_cause;
                decoder_exception_cause_out = id_exception_cause_else;
                inst_out = id_inst_out5;
                reg_writen_en = id_reg_writen_en[5]; 
                aluop = id_aluop5;
                alusel = id_alusel5;
                imm = id_imm5;
                is_div = id_is_div[5];
                is_mul = id_is_mul[5];
                reg1_read_en = id_reg1_read_en[5];   
                reg2_read_en = id_reg2_read_en[5];   
                reg1_read_addr = id_reg1_read_addr5;
                reg2_read_addr = id_reg2_read_addr5;
                reg_write_addr = id_reg_write_addr5;
                is_privilege = id_is_privilege[5];
                csr_read_en = id_csr_read_en[5];
                csr_write_en = id_csr_write_en[5];
                csr_addr = id_csr_addr5;
                is_cnt = id_is_cnt[5];
                invtlb_op = id_invtlb_op5;
            end
            7'b1000000: begin
                pc_out = id_pc_out6;
                is_exception_out = {is_exception,1'b0};
                pc_exception_cause_out = pc_exception_cause;
                instbuffer_exception_cause_out = id_instbuffer_exception_cause6;
                decoder_exception_cause_out = id_decoder_exception_cause6;
                inst_out = id_inst_out6;
                reg_writen_en = id_reg_writen_en[6]; 
                aluop = id_aluop6;
                alusel = id_alusel6;
                imm = id_imm6;
                is_div = id_is_div[6];
                is_mul = id_is_mul[6];
                reg1_read_en = id_reg1_read_en[6];   
                reg2_read_en = id_reg2_read_en[6];   
                reg1_read_addr = id_reg1_read_addr6;
                reg2_read_addr = id_reg2_read_addr6;
                reg_write_addr = id_reg_write_addr6;
                is_privilege = id_is_privilege[6];
                csr_read_en = id_csr_read_en[6];
                csr_write_en = id_csr_write_en[6];
                csr_addr = id_csr_addr6;
                is_cnt = id_is_cnt[6];
                invtlb_op = id_invtlb_op6;
            end
            default: begin
                pc_out = pc;
                is_exception_out = {is_exception, 1'b1};
                pc_exception_cause_out = pc_exception_cause;  
                instbuffer_exception_cause_out = instbuffer_exception_cause;
                decoder_exception_cause_out = `EXCEPTION_INE;
                inst_out = 32'b0;
                reg_writen_en = 0; 
                aluop = 8'b0;
                alusel = 3'b0;
                imm = 32'b0;
                is_div = 1'b0;
                is_mul = 1'b0;
                reg1_read_en = 0;   
                reg2_read_en = 0;   
                reg1_read_addr = 0;
                reg2_read_addr = 0;
                reg_write_addr = 0;
                is_privilege = 0;
                csr_read_en = 0;
                csr_write_en = 0;
                csr_addr = 14'b0;
                is_cnt = 0;
                invtlb_op = 0;
            end
        endcase
     end

        always @(*) begin
            id_pre_taken = pre_taken;
            id_pre_addr  = pre_addr;
            id_valid     = valid;
        end
endmodule