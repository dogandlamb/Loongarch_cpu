module pc(
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,
    input  wire [31:0] nextpc,
    output reg  [31:0] pc
);

//指令的移动控制
always @ (posedge clk) begin
    if( reset ) begin
        pc <= 32'h1bfffffc;
    end
    else begin
        pc <= nextpc;
    end
end

endmodule