`timescale 1ns / 1ps
`include "defines.vh"

module clz (
    input  [31:0] clz_input,
    output reg [4:0] clz_out
);

    // 每个4位组内的前导零计数（0-3）
    reg [1:0] low_order_clz_0;
    reg [1:0] low_order_clz_1;
    reg [1:0] low_order_clz_2;
    reg [1:0] low_order_clz_3;
    reg [1:0] low_order_clz_4;
    reg [1:0] low_order_clz_5;
    reg [1:0] low_order_clz_6;
    reg [1:0] low_order_clz_7;
    
    // 每个4位组是否全零（1表示全零）
    wire [7:0] sub_clz;
    
    // 每8位块（两个4位组）的最终前导零数
    reg [1:0] upper_lower_0;
    reg [1:0] upper_lower_1;
    reg [1:0] upper_lower_2;
    reg [1:0] upper_lower_3;

    // 生成sub_clz信号
    assign sub_clz[7] = (clz_input[3:0] == 4'b0);  
    assign sub_clz[6] = (clz_input[7:4] == 4'b0); 
    assign sub_clz[5] = (clz_input[11:8] == 4'b0);  
    assign sub_clz[4] = (clz_input[15:12] == 4'b0);  
    assign sub_clz[3] = (clz_input[19:16] == 4'b0);  
    assign sub_clz[2] = (clz_input[23:20]  == 4'b0); 
    assign sub_clz[1] = (clz_input[27:24]   == 4'b0);  
    assign sub_clz[0] = (clz_input[31:28]   == 4'b0); 

    // 计算每个4位组内的前导零数量
    always @* begin
        // 组0: bits 31-28
        casez (clz_input[31:28])
            4'b1???: low_order_clz_0 = 2'd0;
            4'b01??: low_order_clz_0 = 2'd1;
            4'b001?: low_order_clz_0 = 2'd2;
            4'b0001: low_order_clz_0 = 2'd3;
            default: low_order_clz_0 = 2'd3; // 全零
        endcase
        
        // 组6: bits 27-24
        casez (clz_input[27:24])
            4'b1???: low_order_clz_1 = 2'd0;
            4'b01??: low_order_clz_1 = 2'd1;
            4'b001?: low_order_clz_1 = 2'd2;
            4'b0001: low_order_clz_1 = 2'd3;
            default: low_order_clz_1 = 2'd3;
        endcase
        
        // 组5: bits 23-20
        casez (clz_input[23:20])
            4'b1???: low_order_clz_2 = 2'd0;
            4'b01??: low_order_clz_2 = 2'd1;
            4'b001?: low_order_clz_2 = 2'd2;
            4'b0001: low_order_clz_2 = 2'd3;
            default: low_order_clz_2 = 2'd3;
        endcase
        
        // 组4: bits 19-16
        casez (clz_input[19:16])
            4'b1???: low_order_clz_3 = 2'd0;
            4'b01??: low_order_clz_3 = 2'd1;
            4'b001?: low_order_clz_3 = 2'd2;
            4'b0001: low_order_clz_3 = 2'd3;
            default: low_order_clz_3 = 2'd3;
        endcase
        
        // 组3: bits 15-12
        casez (clz_input[15:12])
            4'b1???: low_order_clz_4 = 2'd0;
            4'b01??: low_order_clz_4 = 2'd1;
            4'b001?: low_order_clz_4 = 2'd2;
            4'b0001: low_order_clz_4 = 2'd3;
            default: low_order_clz_4 = 2'd3;
        endcase
        
        // 组2: bits 11-8
        casez (clz_input[11:8])
            4'b1???: low_order_clz_5 = 2'd0;
            4'b01??: low_order_clz_5 = 2'd1;
            4'b001?: low_order_clz_5 = 2'd2;
            4'b0001: low_order_clz_5 = 2'd3;
            default: low_order_clz_5 = 2'd3;
        endcase
        
        // 组1: bits 7-4
        casez (clz_input[7:4])
            4'b1???: low_order_clz_6 = 2'd0;
            4'b01??: low_order_clz_6 = 2'd1;
            4'b001?: low_order_clz_6 = 2'd2;
            4'b0001: low_order_clz_6 = 2'd3;
            default: low_order_clz_6 = 2'd3;
        endcase
        
        // 组0: bits 3-0
        casez (clz_input[3:0])
            4'b1???: low_order_clz_7 = 2'd0;
            4'b01??: low_order_clz_7 = 2'd1;
            4'b001?: low_order_clz_7 = 2'd2;
            4'b0001: low_order_clz_7 = 2'd3;
            default: low_order_clz_7 = 2'd3;
        endcase

        clz_out[4] = &sub_clz[3:0];  //高16位
        clz_out[3] = clz_out[4] ? &sub_clz[5:4] : &sub_clz[1:0];  //高24位或高8位
        clz_out[2] =
            (sub_clz[0] & ~sub_clz[1]) |
            (&sub_clz[2:0] & ~sub_clz[3]) |
            (&sub_clz[4:0] & ~sub_clz[5]) |
            (&sub_clz[6:0]);//高4位|高12位|高20位|高28位

        // 选择每个8位块的前导零数
        upper_lower_0 = sub_clz[0] ? low_order_clz_1 : low_order_clz_0; // 块0: 3-0
        upper_lower_1 = sub_clz[2] ? low_order_clz_3 : low_order_clz_2; // 块1: 11-8
        upper_lower_2 = sub_clz[4] ? low_order_clz_5 : low_order_clz_4; // 块2: 19-16
        upper_lower_3 = sub_clz[6] ? low_order_clz_7 : low_order_clz_6; // 块3: 27-24


        case (clz_out[4:3])
            2'b11:begin
                clz_out[1:0] = upper_lower_3;
            end 
            2'b10:begin
                clz_out[1:0] = upper_lower_2;
            end 
            2'b01:begin
                clz_out[1:0] = upper_lower_1;
            end 
            2'b00:begin
                clz_out[1:0] = upper_lower_0;
            end 
            default: clz_out[1:0] = 2'b0; 
        endcase

       end

endmodule