module mul(
    input mul_clk, reset,
    input mul_signed,
    input [31:0] x, y,
    output [63:0] result
    );
wire [63:0] X_cal;
wire [32:0] Y_cal;
assign X_cal = mul_signed ? {{32{x[31]}}, x} : {32'b0, x};
assign Y_cal = mul_signed ? {y[31], y} : {1'b0, y};
wire [16:0] Carry;
wire [63:0] BoothRes [16:0];
BoothInterBase fir(.y({Y_cal[1], Y_cal[0], 1'b0}), .X_in(X_cal), .X_out(BoothRes[0]), .Carry(Carry[0]));
generate
    genvar i;
    for (i=2; i<32; i=i+2) begin: boothfor
        BoothInterBase ai(
            .y(Y_cal[i+1:i-1]),
            .X_in(X_cal<<i),
            .X_out(BoothRes[i>>1]),
            .Carry(Carry[i>>1])
        );
    end
endgenerate
BoothInterBase las(.y({Y_cal[32], Y_cal[32], Y_cal[31]}), .X_in(X_cal<<32), .X_out(BoothRes[16]), .Carry(Carry[16]));
reg [16:0] SecStageCarry;
reg [63:0] SecStageBoothRes [16:0];
integer p;
always @(posedge mul_clk) begin
    if (~reset) begin
        SecStageCarry <= Carry;
        for(p=0; p<17; p=p+1) begin
            SecStageBoothRes[p] <= BoothRes[p];
        end
    end
end
wire [13:0] WallaceInter [64:0];
wire [63:0] C_o, SOut;
Wallace firs(
            .data_i({SecStageBoothRes[0][0], SecStageBoothRes[1][0], SecStageBoothRes[2][0], SecStageBoothRes[3][0], SecStageBoothRes[4][0], SecStageBoothRes[5][0], SecStageBoothRes[6][0],
            SecStageBoothRes[7][0], SecStageBoothRes[8][0], SecStageBoothRes[9][0], SecStageBoothRes[10][0], SecStageBoothRes[11][0], SecStageBoothRes[12][0], SecStageBoothRes[13][0], SecStageBoothRes[14][0],
            SecStageBoothRes[15][0], SecStageBoothRes[16][0]}),
            .C_i(SecStageCarry[13:0]),
            .C_o(WallaceInter[1]),
            .C(C_o[0]),
            .S(SOut[0])
        );
generate
    genvar n;
    for (n=1; n<64; n=n+1) begin: wallacefor
        Wallace bi(
            .data_i({SecStageBoothRes[0][n], SecStageBoothRes[1][n], SecStageBoothRes[2][n], SecStageBoothRes[3][n], SecStageBoothRes[4][n], SecStageBoothRes[5][n], SecStageBoothRes[6][n],
            SecStageBoothRes[7][n], SecStageBoothRes[8][n], SecStageBoothRes[9][n], SecStageBoothRes[10][n], SecStageBoothRes[11][n], SecStageBoothRes[12][n], SecStageBoothRes[13][n], SecStageBoothRes[14][n],
            SecStageBoothRes[15][n], SecStageBoothRes[16][n]}),
            .C_i(WallaceInter[n]),
            .C_o(WallaceInter[n+1]),
            .C(C_o[n]),
            .S(SOut[n])
        );
    end
endgenerate
assign result = SOut + {C_o[62:0], SecStageCarry[14]} + SecStageCarry[15];
endmodule

module BoothBase(
    input negx, x, neg2x, _2x,
    input X_in,                  
    input PosLastX, NegLastX,   
    output PosNextX, NegNextX,
    output X_out           
    );
assign X_out =  (negx & ~X_in)      |
                (x & X_in)          | 
                (neg2x & NegLastX)  | 
                (_2x & PosLastX);
assign PosNextX = X_in; 
assign NegNextX = ~X_in;
endmodule

module YDecoder(
    input c, b, a,
    output negx, x, neg2x, _2x
    );
assign negx = (c & b & ~a) | (c & ~b & a);    
assign x = (~c & ~b & a) | (~c & b & ~a);     
assign neg2x = (c & ~b & ~a);                    
assign _2x = (~c & b & a);
endmodule

module BoothInterBase(
    input [2:0] y,     
    input [63:0] X_in,
    output [63:0] X_out,
    output Carry     
);
wire negx, x, neg2x, _2x;
wire [1:0] CarrySig [64:0]; 
YDecoder uu(.c(y[2]), .b(y[1]), .a(y[0]), .negx(negx), .x(x), .neg2x(neg2x), ._2x(_2x));
BoothBase fir(.negx(negx), .x(x), .neg2x(neg2x), ._2x(_2x), .X_in(X_in[0]), .PosLastX(1'b0), .NegLastX(1'b1), .PosNextX(CarrySig[1][0]), .NegNextX(CarrySig[1][1]), .X_out(X_out[0]));
generate
    genvar i;
    for (i=1; i<64; i=i+1) begin: gfor
        BoothBase ui(
            .negx(negx),
            .x(x),
            .neg2x(neg2x),
            ._2x(_2x),
            .X_in(X_in[i]),
            .PosLastX(CarrySig[i][0]),
            .NegLastX(CarrySig[i][1]),
            .PosNextX(CarrySig[i+1][0]),
            .NegNextX(CarrySig[i+1][1]),
            .X_out(X_out[i])
        );
    end
endgenerate
assign Carry = negx || neg2x;
endmodule

module Cal(
    input A, B, C,
    output Carry, S
    );
assign S = ~A & ~B & C | ~A & B & ~C | A & ~B & ~C | A & B & C;
assign Carry = A & B | A & C | B & C;
endmodule

module Wallace(
    input [16:0] data_i,
    input [13:0] C_i,
    output [13:0] C_o,
    output C, S
    );
wire [4:0] Fir;
Cal fir_1(.A(data_i[4]), .B(data_i[3]), .C(data_i[2]), .Carry(C_o[0]), .S(Fir[0]));
Cal fir_2(.A(data_i[7]), .B(data_i[6]), .C(data_i[5]), .Carry(C_o[1]), .S(Fir[1]));
Cal fir_3(.A(data_i[10]), .B(data_i[9]), .C(data_i[8]), .Carry(C_o[2]), .S(Fir[2]));
Cal fir_4(.A(data_i[13]), .B(data_i[12]), .C(data_i[11]), .Carry(C_o[3]), .S(Fir[3]));
Cal fir_5(.A(data_i[16]), .B(data_i[15]), .C(data_i[14]), .Carry(C_o[4]), .S(Fir[4]));
wire [3:0] Sec;
Cal sec_1(.A(C_i[2]), .B(C_i[1]), .C(C_i[0]), .Carry(C_o[5]), .S(Sec[0]));
Cal sec_2(.A(data_i[0]), .B(C_i[4]), .C(C_i[3]), .Carry(C_o[6]), .S(Sec[1]));
Cal sec_3(.A(Fir[1]), .B(Fir[0]), .C(data_i[1]), .Carry(C_o[7]), .S(Sec[2]));
Cal sec_4(.A(Fir[4]), .B(Fir[3]), .C(Fir[2]), .Carry(C_o[8]), .S(Sec[3]));
wire [1:0] Thi;
Cal thi_1(.A(Sec[0]), .B(C_i[6]), .C(C_i[5]), .Carry(C_o[9]), .S(Thi[0]));
Cal thi_2(.A(Sec[3]), .B(Sec[2]), .C(Sec[1]), .Carry(C_o[10]), .S(Thi[1]));
wire [1:0] For;
Cal fou_1(.A(C_i[9]), .B(C_i[8]), .C(C_i[7]), .Carry(C_o[11]), .S(For[0]));
Cal fou_2(.A(Thi[1]), .B(Thi[0]), .C(C_i[10]), .Carry(C_o[12]), .S(For[1]));
wire Fif;
Cal fif_1(.A(For[1]), .B(For[0]), .C(C_i[11]), .Carry(C_o[13]), .S(Fif));
Cal six_1(.A(Fif), .B(C_i[13]), .C(C_i[12]), .Carry(C), .S(S));
endmodule
