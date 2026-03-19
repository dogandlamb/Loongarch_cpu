module div(
    input div_clk, reset,   
    input div,            
    input div_signed,        
    input [31:0] x, y,     
    output [31:0] s, r,     
    output complete     
);
reg [32:0] S;
reg [32:0] R;    
reg [32:0] tmp_r;      
reg [7:0] count;
wire delay;   
wire real_complete; 
wire [32:0] TmpS, TmpR;
wire real_x;
wire real_y;
wire [32:0] tmp_d;  
wire [32:0] result_r;  
wire [32:0] UnsignX, UnsignY; 
reg  signed_buffer;  
reg  x_buffer;        
reg  y_buffer;        
wire real_div_signed;  

assign delay = (count == 8'hf0);
assign real_complete = delay || complete;

always @(posedge div_clk) begin  
    if (reset) begin 
        count <= 8'd32;    
        tmp_r <= 33'b0;  
        S <= 33'b0; 
        R <= 33'b0; 
    end
    else if (~div || delay) begin 
        count <= 8'd32;     
        tmp_r <= 33'b0;
    end
    else if (~(count[7])) begin
        if (tmp_d[32]) begin  
            S <= {S[31:0], 1'b0};
            tmp_r <= result_r; 
        end 
        else begin  
            S <= {S[31:0], 1'b1};
            tmp_r <= tmp_d;  
        end
        count <= count - 8'd1; 
    end
    else begin 
        R <= tmp_r;
        count   <= 8'hf0;
    end
end

always @(posedge div_clk) begin 
    if (reset) begin 
        signed_buffer <= 1'b0;
        x_buffer <= 1'b0;
        y_buffer <= 1'b0;
    end 
    else if (div) begin 
        signed_buffer <= div_signed; 
        x_buffer <= x[31];  
        y_buffer <= y[31];  
    end
end
assign real_div_signed = real_complete ? signed_buffer : div_signed;
assign real_x = real_complete ? x_buffer : x[31];
assign real_y = real_complete ? y_buffer : y[31];
assign UnsignX = {1'b0, (real_div_signed ? (x[31] ? (~x + 32'b1) : x) : x)};
assign UnsignY = {1'b0, (real_div_signed ? (y[31] ? (~y + 32'b1) : y) : y)};
assign complete = (count == 8'hff);

assign result_r = {tmp_r[31:0], UnsignX[count]}; 
assign tmp_d = result_r - UnsignY;    
assign TmpS = (real_div_signed ? 
              ((real_x == real_y) ? S : ~(S - 1)) : 
              S); 

assign TmpR = (real_div_signed ? 
              (real_x ? ~(R - 1) : R) : 
              R);
assign s = TmpS[31:0]; 
assign r = TmpR[31:0]; 

endmodule