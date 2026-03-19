`timescale 1ns / 1ps
`include "defines.vh"

module  div_alu 
(
    input wire clk,
    input wire rst,

    input wire op, //操作类型：0表示无符号除法，1表示有符号除法
    input wire [31:0] dividend, //被除数
    input wire [31:0] divisor,  //除数
    input wire start,   //启动信号，开始除法运算

    output wire is_running, //表示除法运算正在进行
    output reg [31:0] remainder_out, //最终余数结果
    output reg [31:0] quotient_out, //最终商结果
    output wire done  //除法完成标志
);
    localparam CLZ_W = 5; //前导零计数器的位宽（32位数据需log2(32)=5位）
    wire [CLZ_W:0] CLZ_delta; // 除数和被除数前导零数量的差值（带符号）

    wire divisor_greater_than_dividend;// 标识除数是否大于被除数
    reg [31:0] shifted_divisor;// 动态移位调整的除数

    wire [1:0] new_quotient_bits;// 每次迭代产生的新商位（2位）
    wire [31:0] sub_1x;// 减去1倍移位除数的结果
    wire [31:0] sub_2x;// 减去2倍移位除数的结果
    wire sub_1x_overflow;// 1倍减法溢出（结果为负）
    wire sub_2x_overflow;// 2倍减法溢出（结果为负）

    reg [CLZ_W-2:0] cycles_remaining; // 剩余迭代次数计数器
    wire [CLZ_W-2:0] cycles_remaining_next;// 下一周期的迭代次数

    reg running;// 内部运行状态标志
    wire terminate;// 终止迭代标志

    wire signed_divop;// 当前是否为有符号运算
    wire negate_dividend;// 被除数是否需要取负
    wire negate_divisor;// 除数是否需要取负
    wire negate_quotient;// 商是否需要取负
    wire negate_remainder;// 余数是否需要取负
    wire [31: 0] unsigned_dividend;// 预处理后的无符号被除数
    wire [31: 0] unsigned_divisor;// 预处理后的无符号除数

    reg [31: 0] quotient;// 迭代过程中的商寄存器
    reg [31: 0] remainder;// 迭代过程中的余数寄存器
    wire [$clog2(32)-1:0] dividend_CLZ;// 被除数前导零数量
    wire [$clog2(32)-1:0] divisor_CLZ;// 除数前导零数量


    assign signed_divop = op;

// 确定操作数是否需要取负（有符号运算且为负数时）
    assign negate_dividend = signed_divop & dividend[31];
    assign negate_divisor = signed_divop & divisor[31];

 // 确定结果是否需要取负（商：异或符号；余数：与被除数同号）
    assign negate_quotient = signed_divop & (dividend[31] ^ divisor[31]);
    assign negate_remainder = signed_divop & (dividend[31]);

// 条件取负函数：当b=1时对a取补码
    function [31:0] negate_if;
        input [31:0] a;
        input b;
        begin
            negate_if = ({32{b}} ^ a) + b;
        end
    endfunction
// 生成无符号操作数
assign unsigned_dividend = negate_if(dividend, negate_dividend);
assign unsigned_divisor  = negate_if(divisor, negate_divisor);

// 前导零计数模块实例化
    clz dividend_clz_block (
        .clz_input(unsigned_dividend),// 输入无符号被除数
        .clz_out  (dividend_CLZ)// 输出前导零数量
    );
    clz divisor_clz_block (
        .clz_input(unsigned_divisor),// 输入无符号除数
        .clz_out  (divisor_CLZ)// 输出前导零数量
    );

     // 计算前导零差值并判断大小关系（除数>被除数时直接结束）
    assign {divisor_greater_than_dividend, CLZ_delta} = divisor_CLZ - dividend_CLZ;


     // 除数移位寄存器
    always @(posedge clk) begin
        if (rst)
            shifted_divisor <= 32'b0;
        else if (running) 
            shifted_divisor <= {2'b0, shifted_divisor[31:2]}; // 运行状态：每次迭代右移2位（相当于除4）
        else
            // 初始化：左移使除数对齐被除数最高有效位
            shifted_divisor <= unsigned_divisor << {CLZ_delta[CLZ_W-1:1], 1'b0};
    end

 /* 非恢复除法算法步骤：
       1. 先尝试减去2倍移位除数
       2. 若结果为负（溢出），则尝试减去1倍移位除数
       3. 根据减法结果生成商位 */

// 计算 remainder - (shifted_divisor << 1) [即2倍]
    wire sub2x_toss;
    assign {sub_2x_overflow, sub2x_toss, sub_2x} = {1'b0, remainder} - {shifted_divisor, 1'b0};
// 根据2倍减法结果选择1倍减法操作
    assign {sub_1x_overflow, sub_1x} = sub_2x_overflow ? {sub2x_toss, sub_2x} + {1'b0, shifted_divisor} : {sub2x_toss, sub_2x} - {1'b0, shifted_divisor};

// 商位生成规则：
    //   sub_2x_overflow=0 -> 可减2倍，商位为11 (二进制)
    //   sub_2x_overflow=1 且 sub_1x_overflow=0 -> 可减1倍，商位为10
    //   sub_1x_overflow=1 -> 不减，商位为00
    assign new_quotient_bits[1] = ~sub_2x_overflow;
    assign new_quotient_bits[0] = ~sub_1x_overflow;

// 商寄存器更新逻辑
    always @(posedge clk) begin
        if (rst)         quotient <= 32'b0;
        else if (start)  quotient <= 32'b0; //启动时清零
        else if (running) 
        // 运行状态：将新商位移入寄存器低2位
        quotient <= {quotient[29:0], new_quotient_bits};
    end

// 余数寄存器更新逻辑
    always @(posedge clk) begin
        if (rst)    remainder <= 32'b0;
        else if (start | (running & |new_quotient_bits)) begin 
            case ({
                ~running, sub_1x_overflow
            })
                2'b00: remainder <= sub_1x;// 正常情况：使用1倍减法结果
                2'b01: remainder <= sub_2x;// 特殊情况：使用2倍减法结果
                default:
                remainder <= unsigned_dividend;// 初始化：加载被除数
            endcase
        end
    end

// 迭代次数控制器
    assign {terminate, cycles_remaining_next} = cycles_remaining - 1;
    always @(posedge clk) begin
        if (rst) cycles_remaining <= 4'b0;      // 不知道是不是这样写
        else cycles_remaining <= running ? cycles_remaining_next : CLZ_delta[CLZ_W-1:1];
    end

// 运行状态机控制
    always @(posedge clk) begin
        if (rst) running <= 1'b0;// 同步复位
        else 
        // 状态转换：
            //   保持运行直到终止 | 新启动且除数不大于被除数
        running <= (running & ~terminate) | (start & ~divisor_greater_than_dividend);
    end

    assign is_running = running;// 输出运行状态

// 输出结果处理
 /* 结果处理步骤：
       1. 延迟关键信号用于输出时序控制
       2. 处理除数为零的特殊情况（已隐含处理）
       3. 对有符号结果进行补码转换 */
    
    // 延迟寄存器（用于输出时序对齐）
    reg running_delay;
    reg terminate_delay;
    reg start_delay;
    reg divisor_greater_than_dividend_delay;

    always @(posedge clk) begin
        if (rst) begin
            running_delay <= 1'b0;
            terminate_delay <= 1'b0;
            start_delay <= 1'b0;
            divisor_greater_than_dividend_delay <= 1'b0;
        end
        else begin
            running_delay <= running;
            terminate_delay <= terminate;
            start_delay <= start;
            divisor_greater_than_dividend_delay <= divisor_greater_than_dividend;
        end
    end

// 结果输出组合逻辑
    always @(*)begin// 被除数为零的特殊处理
        if (dividend == 0) begin
            quotient_out  = 0;
            remainder_out = 0;
        end else begin
            // 根据符号标志对结果取补码
            quotient_out  = negate_quotient ? ~quotient + 1'b1 : quotient;
            remainder_out = negate_remainder ? ~remainder + 1'b1 : remainder;
        end
    end
    // 完成标志生成：正常结束或提前结束（除数>被除数）
    assign done = (running_delay & terminate_delay) | (start_delay & divisor_greater_than_dividend_delay);


endmodule