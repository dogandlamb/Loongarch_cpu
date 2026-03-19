`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"


module alu (
    input wire clk,
    input wire rst,
    input wire flush,           // 濞翠焦鎸夌痪鍨煕閺傞淇婇敓锟�?

    input wire pause_mem_i,       // 鐠佸灝鐡ㄩ梼鑸殿唽閺嗗倸浠犳穱鈥冲娇

    // 閺夈儴鍤渄ispatch閻ㄥ嫭瀵氭禒銈勪繆閿燂拷?
    input wire [31:0] pc_i,
    input wire [31:0] inst_i,

    input wire [3:0] is_exception_i,
    input wire [6:0] pc_exception_cause_i,
    input wire [6:0] instbuffer_exception_cause_i,
    input wire [6:0] decoder_exception_cause_i,
    input wire [6:0] dispatch_exception_cause_i,

    input wire is_privilege_i,
    
    input wire icacop_en_i,
    input wire dcacop_en_i,
    
    input wire valid_i,

    input wire [7:0] aluop_i,
    input wire [2:0] alusel_i,

    input wire       is_div_i,
    input wire       is_mul_i,

    input wire [31:0] reg_data1_i,
    input wire [31:0] reg_data2_i,  

    input wire reg_write_en_i,                // 鐎靛嫬鐡ㄩ崳銊ュ晸娴ｈ儻鍏�
    input wire [4:0] reg_write_addr_i,        // 鐎靛嫬鐡ㄩ崳銊ュ晸閸︽澘娼�

    input wire [31:0] csr_read_data_i,      // csr鐠囩粯鏆熼敓锟�?
    input wire csr_write_en_i,              // csr閸愭瑤濞囬敓锟�?
    input wire [13:0] csr_addr_i,           // csr閸︽澘娼� 

    input wire [4:0] invtlb_op_i,

    input wire pre_is_branch_taken_i,      // 妫板嫭绁撮崚鍡樻暜閹稿洣鎶ら弰顖氭儊鐠哄疇娴�
    input wire [31:0] pre_branch_addr_i,   // 妫板嫭绁撮崚鍡樻暜閹稿洣鎶ょ捄瀹犳祮閸︽澘娼�


    // 閺夈儴鍤� stable counter 閻ㄥ嫯顓搁弫鏉挎珤
    input wire [63:0] cnt_i,

    // 閸滃畳cache閻ㄥ嫭甯撮敓锟�?
    input wire dcache_pause,

    output wire valid_o,
    output wire [31:0] virtual_addr_o,
    output reg ren_o,
    output reg [31:0] wdata_o,
    output reg [3:0] wstrb_o,          // 鐠佸灝鐡ㄩ崷鏉挎絻鐎涙濡崑蹇曅�
    output reg wen_o,

    // 鏉堟挸鍤敓锟�? bpu 閻ㄥ嫪淇婇敓锟�?, 閸掓澘鍨庨弨顖烆暕濞村宕熼崗鍐畱閺囧瓨鏌�
    output wire taken_or_not_actual_o,
    output wire [31:0] branch_actual_addr_o,
    output wire [31:0] pc_dispatch_o,         // 閸欐垵鐨犻梼鑸殿唽閻ㄥ埦c

    // 鏉堟挸鍤敓锟�? ctrl 閻ㄥ嫪淇婇敓锟�?
    output wire pause_alu_o,                    // alu閺嗗倸浠犳穱鈥冲娇
    output wire branch_flush_o,                 // 閸掑棙鏁崚閿嬫煀娣団€冲娇
    output wire [31:0] branch_target_addr_o,    // 閸掑棙鏁惄顔界垼閸︽澘娼�

    // 鏉堟挸鍤敓锟�? dispatch 閻ㄥ嫪淇婇敓锟�?
    output wire [7:0] pre_ex_aluop_o,     // 閸掓澘褰傜亸鍕▉濞堢數娈慳luop閿涘瞼鏁ゆ禍搴″灲閺傜挱x闂冭埖顔岄惃鍕瘹娴犮倖妲搁崥锔芥Цload

    // 鏉堟挸鍤敓锟�? mem 閻ㄥ嫪淇婇敓锟�?
    output wire [31:0] pc_mem,
    output wire [31:0] inst_mem,

    output wire [4:0] is_exception_o,
    output wire [6:0] pc_exception_cause_o,
    output wire [6:0] instbuffer_exception_cause_o,
    output wire [6:0] decoder_exception_cause_o,
    output wire [6:0] dispatch_exception_cause_o,
    output wire [6:0] execute_exception_cause_o,
    
    output wire is_privilege_mem,
    output wire is_ertn_mem,
    output wire is_idle_mem,
    output wire valid_mem,

    output wire reg_write_en_mem, 
    output wire [4:0] reg_write_addr_mem,
    output reg [31:0] reg_write_data_mem,
    
    output wire [7:0] aluop_mem,         
    output reg [31:0] addr_mem,
    output wire [31:0] data_mem,

    output reg csr_write_en_mem,
    output reg [13:0] csr_addr_mem,
    output reg [31:0] csr_write_data_mem,

    output reg is_llw_scw_mem,
    output wire is_llw_mem,
    output wire is_scw_mem
);

    wire [31:0] reg_data1;
    wire [31:0] reg_data2;
    assign reg_data1 = reg_data1_i;   // 濠ф劖鎼锋担婊勬殶1
    assign reg_data2 = reg_data2_i;   // 濠ф劖鎼锋担婊勬殶2

    assign pc_mem      = pc_i;
    assign inst_mem    = inst_i;
    assign valid_mem   = valid_i;
    assign is_privilege_mem = is_privilege_i;
    assign aluop_mem   = aluop_i;
    assign is_ertn_mem = (aluop_i == `ALU_ERTN);
    assign is_idle_mem = (aluop_i == `ALU_IDLE);

    //瀵倸鐖舵径鍕倞
    reg ex_mem_exception;
    assign is_exception_o = {is_exception_i, ex_mem_exception};  
    assign pc_exception_cause_o = pc_exception_cause_i;
    assign instbuffer_exception_cause_o = instbuffer_exception_cause_i;
    assign decoder_exception_cause_o = decoder_exception_cause_i;
    assign dispatch_exception_cause_o = dispatch_exception_cause_i;
    assign execute_exception_cause_o = `EXCEPTION_ALE;      // 閹笛嗩攽闂冭埖顔岄惃鍕磽鐢ǹ甯敓锟�?

    
    // 妫板嫭澧界悰瀹巐u閹垮秳缍旂猾璇茬€�
    assign pre_ex_aluop_o = aluop_i;

    // regular alu 
    wire [31:0] regular_alu_res;

    regular_alu u_regular_alu (
        .aluop(aluop_i),
        .reg1(reg_data1),
        .reg2(reg_data2),
        .result(regular_alu_res)
    );

    // mul alu
    reg [31:0] mul_alu_res;    // 娑旀ɑ纭堕崳銊ㄧ翻閸戣櫣绮ㄩ敓锟�?
    wire pause_ex_mul;
    reg start_mul;
    wire signed_mul;
    wire mul_done;
    wire [63:0] mul_result;
    reg [31:0] mul_data1;
    reg [31:0] mul_data2;

    assign pause_ex_mul = is_mul_i && !mul_done;      // 娑旀ɑ纭堕張顏勭暚閹存劖妞傞弳鍌氫粻

    always @(posedge clk) begin
        if (rst) begin
            start_mul <= 1'b0 ;
            mul_data1 <= 32'b0;
            mul_data2 <= 32'b0;
        end else if (start_mul) begin
            start_mul <= 1'b0;
        end else if (pause_ex_mul) begin
            start_mul <= 1'b1;
            mul_data1 <= reg_data1;
            mul_data2 <= reg_data2;
        end else begin
            start_mul <= 1'b0;
        end
    end

    assign signed_mul = (aluop_i == `ALU_MULW || aluop_i == `ALU_MULHW);      // 閺堝顑侀崣铚傜閿燂拷?

    mul_alu u_mul_alu (
        .clk(clk),
        .rst(rst),
        .start(start_mul),
        .signed_op(signed_mul),
        .reg1(mul_data1),
        .reg2(mul_data2),
        .done(mul_done),
        .result(mul_result)
    );

    // 缂佹挻鐏夐柅澶嬪
    always @(*) begin
        case (aluop_i)
            `ALU_MULW: begin
                mul_alu_res = mul_result[31:0];     // 閿燂拷?32閿燂拷?
            end

            `ALU_MULHW, `ALU_MULHWU: begin
                mul_alu_res = mul_result[63:32];    // 閿燂拷?32閿燂拷?
            end

            default: begin
                mul_alu_res = 32'b0;
            end
        endcase
    end

    // div alu
    reg [31:0] div_alu_res;
    wire pause_ex_div;
    reg start_div;          // 鏉╂瑤閲滈崷鐗堟煙鐎涳箓鏆遍張澶夐嚋logic is_running閿涘本鍨滄潻娆撳櫡閸掔姵甯€閿燂拷?
    wire signed_div;
    wire div_done;
    wire [31:0] remainder;
    wire [31:0] quotient;
    reg [31:0] div_data1;
    reg [31:0] div_data2;
    wire is_running;


    assign pause_ex_div = is_div_i && !div_done;  // 闂勩倖纭堕張顏勭暚閹存劖妞傞弳鍌氫粻

    assign signed_div = aluop_i == `ALU_DIVW || aluop_i == `ALU_MODW;

    always @(posedge clk) 
    begin
        if (rst) begin
            start_div <= 1'b0 ;
            div_data1 <= 32'b0;
            div_data2 <= 32'b0;
        end
        else if (start_div)
        begin
            start_div <= 1'b0;
        end 
        else if(pause_ex_div && !is_running)
        begin
            start_div <= 1'b1;
            div_data1 <= reg_data1;
            div_data2 <= reg_data2;
        end
        else begin
            start_div <= 1'b0;
        end
    end 

    div_alu u_div_alu 
    (
        .clk(clk),
        .rst(rst),
        .op(signed_div),
        .dividend(div_data1),
        .divisor(div_data2),
        .start(start_div),

        .is_running(is_running),
        .quotient_out(quotient),
        .remainder_out(remainder),
        .done(div_done)
    );

    // 缂佹挻鐏夐柅澶嬪
    always @(*) begin
        case (aluop_i) 
            `ALU_DIVW, `ALU_DIVWU: begin
                div_alu_res = quotient;  // 閿燂拷?
            end

            `ALU_MODW, `ALU_MODWU: begin
                div_alu_res = remainder;  // 娴ｆ瑦鏆�
            end

            default: begin
                div_alu_res = 32'b0;      // 閸忔湹绮幆鍛枌
            end
        endcase
    end
    // branch alu
    wire [31:0] branch_alu_res;

    wire icacop_en;
    wire dcacop_en;
    assign icacop_en  = icacop_en_i & valid_i;
    assign dcacop_en  = dcacop_en_i & valid_i;

    branch_alu u_branch_alu (
        .pc(pc_i),
        .inst(inst_i),
        .aluop(aluop_i),

        .reg1(reg_data1),
        .reg2(reg_data2),

        .pre_is_branch_taken(pre_is_branch_taken_i),
        .pre_branch_addr(pre_branch_addr_i),

        .taken_or_not_actual(taken_or_not_actual_o),
        .branch_actual_addr(branch_actual_addr_o),
        .pc_dispatch(pc_dispatch_o),
        .branch_flush(branch_flush_o),
        .branch_alu_res(branch_alu_res),
        .icacop_en(icacop_en),  // icacop娴ｈ儻鍏�
        .dcacop_en(dcacop_en)   // dcacop娴ｈ儻鍏�
    );

    assign branch_target_addr_o = branch_actual_addr_o;

    // load & store alu
    wire LLbit;
    assign LLbit = csr_read_data_i[0];  // 娴犲穯sr娑擃叀顕伴崣鏈橪bit

    wire [31:0] load_store_alu_res;
    assign load_store_alu_res = (aluop_i == `ALU_SCW) ? {31'b0, LLbit} : 32'b0;

    wire is_mem;
    assign is_mem =    aluop_i == `ALU_LDB || aluop_i == `ALU_LDBU 
                    || aluop_i == `ALU_LDH || aluop_i == `ALU_LDHU 
                    || aluop_i == `ALU_LDW
                    || aluop_i == `ALU_STB || aluop_i == `ALU_STH 
                    || aluop_i == `ALU_STW 
                    || aluop_i == `ALU_LLW || aluop_i == `ALU_SCW
                    || aluop_i == `ALU_PRELD;
    wire pause_ex_mem;
    assign pause_ex_mem = dcache_pause;  

    wire [11:0] si12;
    wire [13:0] si14;
    assign si12 = inst_i[21:10];  // 12娴ｅ秶鐝涢崡铏殶
    assign si14 = inst_i[23:10];  // 14娴ｅ秶鐝涢崡铏殶

    always @(*) begin
        case (aluop_i) 
            `ALU_LDB, `ALU_LDBU, `ALU_LDH, `ALU_LDHU, `ALU_LDW, `ALU_LLW, `ALU_PRELD, `ALU_CACOP: begin
                addr_mem = reg_data1 + reg_data2;
            end

            `ALU_STB, `ALU_STH, `ALU_STW: begin
                addr_mem = reg_data1 + {{20{si12[11]}}, si12};
            end
            
            `ALU_SCW: begin
                addr_mem = reg_data1 + {{16{si14[13]}}, si14, 2'b00};
            end

            default: begin
                addr_mem = 32'b0;        
            end 
                       
        endcase
    end

    assign virtual_addr_o = addr_mem;  // 鏉堟挸鍤紒妾嘽ache閻ㄥ嫯娅勯幏鐔锋勾閿燂拷?

    reg mem_is_valid;
    assign valid_o = mem_is_valid && !flush && !pause_mem_i && !is_exception_o;

    always @(*) begin
        case (aluop_i)
            `ALU_LDB, `ALU_LDBU: begin
                ren_o = 1'b1;
                wstrb_o = 4'b0;
                wen_o = 1'b0;
                ex_mem_exception = 1'b0;
                mem_is_valid = 1'b1;
                wdata_o = 32'b0;
            end

            `ALU_LDH, `ALU_LDHU: begin
                ren_o = (addr_mem[1:0] == 2'b00) || (addr_mem[1:0] == 2'b10);
                ex_mem_exception = (addr_mem[1:0] == 2'b01) || (addr_mem[1:0] == 2'b11);
                mem_is_valid = 1'b1;
                wdata_o = 32'b0;
                wstrb_o = 4'b0;
                wen_o   = 1'b0;
            end

            `ALU_LDW, `ALU_LLW: begin
                ren_o = (addr_mem[1:0] == 2'b00);
                ex_mem_exception = (addr_mem[1:0] != 2'b00);
                mem_is_valid = 1'b1;
                wdata_o = 32'b0;
                wstrb_o = 4'b0;
                wen_o   = 1'b0;
            end

            `ALU_STB: begin
                ex_mem_exception = 1'b0;
                mem_is_valid = 1'b1;
                ren_o = 1'b0;
                case (addr_mem[1: 0])
                    2'b00: begin
                        wstrb_o = 4'b0001;
                        wen_o   = 1'b1;
                        wdata_o = {24'b0, reg_data2[7: 0]};
                    end 
                    2'b01: begin
                        wstrb_o = 4'b0010;
                        wen_o   = 1'b1;
                        wdata_o = {16'b0, reg_data2[7: 0], 8'b0};
                    end
                    2'b10: begin
                        wstrb_o = 4'b0100;
                        wen_o   = 1'b1;
                        wdata_o = {8'b0, reg_data2[7: 0], 16'b0};
                    end
                    2'b11: begin
                        wstrb_o = 4'b1000;
                        wen_o   = 1'b1;
                        wdata_o = {reg_data2[7: 0], 24'b0};
                    end
                    default: begin
                        wstrb_o = 4'b0000;          
                        wen_o   = 1'b0;
                        wdata_o = 32'b0;           
                    end
                endcase
            end

            `ALU_STH: begin
                ren_o = 1'b0;
                mem_is_valid = 1'b1;
                case (addr_mem[1: 0])
                    2'b00: begin
                        wstrb_o = 4'b0011;
                        wen_o   = 1'b1;
                        wdata_o = {16'b0, reg_data2[15: 0]};
                        ex_mem_exception = 1'b0;
                    end 
                    2'b10: begin
                        wstrb_o = 4'b1100;
                        wen_o   = 1'b1;
                        wdata_o = {reg_data2[15: 0], 16'b0};
                        ex_mem_exception = 1'b0;
                    end
                    2'b01, 2'b11: begin
                        wstrb_o = 4'b0000;
                        wen_o   = 1'b0;
                        wdata_o = 32'b0;
                        ex_mem_exception = 1'b1;
                    end
                    default: begin
                        wstrb_o = 4'b0000; 
                        wen_o   = 1'b0;
                        wdata_o = 32'b0;    
                        ex_mem_exception = 1'b0;        
                    end
                endcase
            end

            `ALU_STW: begin
                ren_o = 1'b0;
                ex_mem_exception = (addr_mem[1: 0] != 2'b00);
                mem_is_valid = 1'b1;
                wdata_o = reg_data2;
                wstrb_o = (addr_mem[1: 0] == 2'b00) ? 4'b1111 : 4'b0000;
                wen_o   = addr_mem[1: 0] == 2'b00;
            end

            `ALU_SCW: begin
                ren_o = 1'b0;
                ex_mem_exception = (addr_mem[1:0] != 2'b00);
                if (LLbit & (addr_mem[1:0] == 2'b00)) begin
                    mem_is_valid = 1'b1;
                    wstrb_o = 4'b1111;
                    wen_o   = 1'b1;
                    wdata_o = reg_data2;
                end else begin
                    mem_is_valid = 1'b0;
                    wstrb_o = 4'b0000;
                    wen_o   = 1'b0;
                    wdata_o = 32'b0;
                end
            end

            default: begin
                ex_mem_exception = 1'b0;
                mem_is_valid = 1'b0;
                ren_o   = 1'b0;
                wdata_o = 32'b0;
                wstrb_o = 4'b0000;
                wen_o   = 1'b0;
            end
        endcase
    end

    // csr alu
    reg [31:0] csr_alu_res;
    wire [31:0] mask_data;
    assign mask_data = ((csr_read_data_i & ~reg_data2) | (reg_data1 & reg_data2));

    assign is_llw_mem = (aluop_i == `ALU_LLW);
    assign is_scw_mem = (aluop_i == `ALU_SCW);

    always @(*) begin
        if (aluop_i == `ALU_LLW) begin
            csr_write_en_mem = 1'b0;  
            csr_addr_mem = `CSR_LLBCTL;
            csr_write_data_mem = 32'b1;
            is_llw_scw_mem = 1'b1;
        end
        else if (aluop_i == `ALU_SCW && LLbit) begin
            csr_write_en_mem = 1'b0;
            csr_addr_mem = `CSR_LLBCTL;
            csr_write_data_mem = 32'b0;
            is_llw_scw_mem = 1'b1;
        end
        else begin
            csr_write_en_mem = csr_write_en_i;
            csr_addr_mem = csr_addr_i;
            csr_write_data_mem = (aluop_i == `ALU_CSRXCHG) ? mask_data : reg_data1;
            is_llw_scw_mem = 1'b0;
        end
    end

    always @(*) begin
        case (aluop_i)
            `ALU_CSRRD, `ALU_CSRWR, `ALU_CSRXCHG: begin
                csr_alu_res = csr_read_data_i;  // 鐠囩抱sr鐎靛嫬鐡ㄩ敓锟�?
            end

            `ALU_RDCNTID: begin
                csr_alu_res = csr_read_data_i;   // 鐠囩抱sr鐎靛嫬鐡ㄩ敓锟�?
            end

            `ALU_RDCNTVLW: begin
                csr_alu_res = cnt_i[31:0];      // 鐠囨槒顓搁弫鏉挎珤閿燂拷?32閿燂拷?
            end

            `ALU_RDCNTVHW: begin
                csr_alu_res = cnt_i[63:32];       // 鐠囨槒顓搁弫鏉挎珤閿燂拷?32閿燂拷?
            end

            `ALU_CPUCFG: begin
                csr_alu_res = csr_read_data_i;
            end
            default: begin
                csr_alu_res = 32'b0;            // 閸忔湹绮幆鍛枌
            end
        endcase
    end
    
    // 鐎靛嫬鐡ㄩ崳銊︽殶閿燂拷?
    assign reg_write_en_mem = !ex_mem_exception ? reg_write_en_i : 1'b0;
    assign reg_write_addr_mem = reg_write_addr_i;

    always @(*) begin
        case (alusel_i) 
            `ALU_SEL_ARITHMETIC: begin
                reg_write_data_mem = regular_alu_res;    // 閺咁噯鎷�?閿熺晫鐣婚張顖濈箥閿燂拷?
            end

            `ALU_SEL_MUL: begin
                reg_write_data_mem = mul_alu_res;        // 娑旀ɑ纭�
            end

            `ALU_SEL_DIV: begin
                reg_write_data_mem = div_alu_res;        // 闂勩倖纭�
            end

            `ALU_SEL_JUMP_BRANCH: begin
                reg_write_data_mem = branch_alu_res;     // 閸掑棙鏁幐鍥︽姢
            end

            `ALU_SEL_LOAD_STORE: begin
                reg_write_data_mem = load_store_alu_res; // 鐠佸灝鐡ㄩ幐鍥︽姢
            end

            `ALU_SEL_CSR: begin
                reg_write_data_mem = csr_alu_res;        // csr閹垮秳缍�
            end

            default: begin
                reg_write_data_mem = 32'b0;              // 姒涙ǹ顓婚幆鍛枌
            end
        endcase
    end

    // 閺嗗倸浠犳穱鈥冲娇
    assign pause_alu_o = pause_ex_mul || pause_ex_div || pause_ex_mem;

endmodule