`timescale 1ns / 1ps
`include "defines.vh"

module tlb
(
    input        clk,
    // search port 0
    input   [31:0]               s0_vaddr     ,  ////////////
    input   [31:0]               s0_vaddr_plus,
    input   [ 9:0]               s0_asid     ,

    output                       same_page   ,
    output                       s0_found    ,
//    output  [ 4:0]               s0_index    ,
    output  [ 5:0]               s0_ps       ,
    output  [19:0]               s0_ppn      ,
    output                       s0_v        ,
    output                       s0_d        ,
    output  [ 1:0]               s0_mat      ,
    output  [ 1:0]               s0_plv      ,
    //search port 1
    input   [31:0]               s1_vaddr     ,   /////////////
    input   [ 9:0]               s1_asid     ,

    output                       s1_found    ,
    output  [ 4:0]               s1_index    ,
    output  [ 5:0]               s1_ps       ,
    output  [19:0]               s1_ppn      ,
    output                       s1_v        ,
    output                       s1_d        ,
    output  [ 1:0]               s1_mat      ,
    output  [ 1:0]               s1_plv      ,

    // write port   写端口
    input                       we          ,
    input  [4:0]                w_index     ,
    input  [18:0]               w_vppn      ,
    input  [ 9:0]               w_asid      ,
    input                       w_g         ,
    input  [ 5:0]               w_ps        ,
    input                       w_e         ,
    input                       w_v0        ,
    input                       w_d0        ,
    input  [ 1:0]               w_mat0      ,
    input  [ 1:0]               w_plv0      ,
    input  [19:0]               w_ppn0      ,
    input                       w_v1        ,
    input                       w_d1        ,
    input  [ 1:0]               w_mat1      ,
    input  [ 1:0]               w_plv1      ,
    input  [19:0]               w_ppn1      ,

    // read port    读端口
    input  [4:0]                r_index     ,
    output [18:0]               r_vppn      ,
    output [ 9:0]               r_asid      ,
    output                      r_g         ,
    output [ 5:0]               r_ps        ,
    output                      r_e         ,
    output                      r_v0        ,
    output                      r_d0        ,
    output [ 1:0]               r_mat0      ,
    output [ 1:0]               r_plv0      ,
    output [19:0]               r_ppn0      ,
    output                      r_v1        ,
    output                      r_d1        ,
    output [ 1:0]               r_mat1      ,
    output [ 1:0]               r_plv1      ,
    output [19:0]               r_ppn1      ,
    
    // invalid port  无效处理端口 
    input                       inv_en      ,
    input  [ 4:0]               inv_op      ,
    input  [ 9:0]               inv_asid    ,
    input  [18:0]               inv_vpn
);

// tlb存储结构
reg [18:0] tlb_vppn     [31:0];
reg        tlb_e        [31:0];       
reg [ 9:0] tlb_asid     [31:0];      
reg        tlb_g        [31:0];     
reg [ 5:0] tlb_ps       [31:0];      

reg [19:0] tlb_ppn0     [31:0];       
reg [ 1:0] tlb_plv0     [31:0];      
reg [ 1:0] tlb_mat0     [31:0];       
reg        tlb_d0       [31:0];      
reg        tlb_v0       [31:0];      

reg [19:0] tlb_ppn1     [31:0];       
reg [ 1:0] tlb_plv1     [31:0];       
reg [ 1:0] tlb_mat1     [31:0];       
reg        tlb_d1       [31:0];      
reg        tlb_v1       [31:0];       


wire [31:0] match0;
wire [31:0] match1;

wire [4:0] match0_en;
wire [4:0] match1_en;

wire [31:0] s0_is_odd_page;
wire [31:0] s1_is_odd_page;

genvar i;
generate
    for (i = 0; i < 32; i = i + 1)
        begin:match
            assign s0_is_odd_page[i] = (tlb_ps[i] == 6'd12) ? s0_vaddr[12] : s0_vaddr[21];
            assign match0[i] = tlb_e[i] & ((tlb_ps[i] == 6'd12) ? s0_vaddr[31:13] == tlb_vppn[i] : s0_vaddr[31:22] == tlb_vppn[i][18: 9]) && ((s0_asid == tlb_asid[i]) || tlb_g[i]);
            assign s1_is_odd_page[i] = (tlb_ps[i] == 6'd12) ? s1_vaddr[12] : s1_vaddr[21];
            assign match1[i] = tlb_e[i] & ((tlb_ps[i] == 6'd12) ? s1_vaddr[31:13] == tlb_vppn[i] : s1_vaddr[31:22] == tlb_vppn[i][18: 9]) && ((s1_asid == tlb_asid[i]) || tlb_g[i]);
        end
endgenerate


encoder encoder0
(
    .data(match0),
    .code(match0_en)
);

encoder encoder1
(
    .data(match1),
    .code(match1_en)
);


assign s0_found = |match0;
//assign s0_index = match0_en;
assign s0_ps    = tlb_ps[match0_en];
assign s0_ppn   = s0_is_odd_page[match0_en] ? tlb_ppn1[match0_en] : tlb_ppn0[match0_en];
assign s0_v     = s0_is_odd_page[match0_en] ? tlb_v1[match0_en]   : tlb_v0[match0_en]  ;
assign s0_d     = s0_is_odd_page[match0_en] ? tlb_d1[match0_en]   : tlb_d0[match0_en]  ;
assign s0_mat   = s0_is_odd_page[match0_en] ? tlb_mat1[match0_en] : tlb_mat0[match0_en];
assign s0_plv   = s0_is_odd_page[match0_en] ? tlb_plv1[match0_en] : tlb_plv0[match0_en];

assign s1_found = |match1;
assign s1_index = match1_en;
assign s1_ps    = tlb_ps[match1_en];
assign s1_ppn   = s1_is_odd_page[match1_en] ? tlb_ppn1[match1_en] : tlb_ppn0[match1_en];
assign s1_v     = s1_is_odd_page[match1_en] ? tlb_v1[match1_en]   : tlb_v0[match1_en]  ;
assign s1_d     = s1_is_odd_page[match1_en] ? tlb_d1[match1_en]   : tlb_d0[match1_en]  ;
assign s1_mat   = s1_is_odd_page[match1_en] ? tlb_mat1[match1_en] : tlb_mat0[match1_en];
assign s1_plv   = s1_is_odd_page[match1_en] ? tlb_plv1[match1_en] : tlb_plv0[match1_en];

assign same_page = s0_ps == 6'd12 ? (s0_vaddr[31:13] == s0_vaddr_plus[31:13]) : (s0_vaddr[31:22] == s0_vaddr_plus[31:22]);

always @(posedge clk) 
begin
    if (we) begin
        tlb_vppn [w_index] <= w_vppn;
        tlb_asid [w_index] <= w_asid;
        tlb_g    [w_index] <= w_g; 
        tlb_ps   [w_index] <= w_ps;  
        tlb_ppn0 [w_index] <= w_ppn0;
        tlb_plv0 [w_index] <= w_plv0;
        tlb_mat0 [w_index] <= w_mat0;
        tlb_d0   [w_index] <= w_d0;
        tlb_v0   [w_index] <= w_v0; 
        tlb_ppn1 [w_index] <= w_ppn1;
        tlb_plv1 [w_index] <= w_plv1;
        tlb_mat1 [w_index] <= w_mat1;
        tlb_d1   [w_index] <= w_d1;
        tlb_v1   [w_index] <= w_v1; 
    end
end

assign r_vppn  =  tlb_vppn [r_index]; 
assign r_asid  =  tlb_asid [r_index]; 
assign r_g     =  tlb_g    [r_index]; 
assign r_ps    =  tlb_ps   [r_index]; 
assign r_e     =  tlb_e    [r_index]; 
assign r_v0    =  tlb_v0   [r_index]; 
assign r_d0    =  tlb_d0   [r_index]; 
assign r_mat0  =  tlb_mat0 [r_index]; 
assign r_plv0  =  tlb_plv0 [r_index]; 
assign r_ppn0  =  tlb_ppn0 [r_index]; 
assign r_v1    =  tlb_v1   [r_index]; 
assign r_d1    =  tlb_d1   [r_index]; 
assign r_mat1  =  tlb_mat1 [r_index]; 
assign r_plv1  =  tlb_plv1 [r_index]; 
assign r_ppn1  =  tlb_ppn1 [r_index]; 

//tlb entry invalid 
generate 
    for (i = 0; i < 32; i = i + 1) 
        begin: invalid_tlb_entry 
            always @(posedge clk) 
            begin
                if (we && (w_index == i)) 
                begin
                    tlb_e[i] <= w_e;
                end
                else if (inv_en) 
                begin
                    if (inv_op == 5'd0 || inv_op == 5'd1) 
                    begin
                        tlb_e[i] <= 1'b0;
                    end
                    else if (inv_op == 5'd2) 
                    begin
                        if (tlb_g[i]) 
                        begin
                            tlb_e[i] <= 1'b0;
                        end
                    end
                    else if (inv_op == 5'd3) 
                    begin
                        if (!tlb_g[i]) 
                        begin
                            tlb_e[i] <= 1'b0;
                        end
                    end
                    else if (inv_op == 5'd4) 
                    begin
                        if (!tlb_g[i] && (tlb_asid[i] == inv_asid)) 
                        begin
                            tlb_e[i] <= 1'b0;
                        end
                    end
                    else if (inv_op == 5'd5) 
                    begin
                        if (!tlb_g[i] && (tlb_asid[i] == inv_asid) && 
                           ((tlb_ps[i] == 6'd12) ? (tlb_vppn[i] == inv_vpn) : (tlb_vppn[i][18:9] == inv_vpn[18:9]))) 
                           begin
                            tlb_e[i] <= 1'b0;
                        end
                    end
                    else if (inv_op == 5'd6) 
                    begin
                        if ((tlb_g[i] || (tlb_asid[i] == inv_asid)) && 
                           ((tlb_ps[i] == 6'd12) ? (tlb_vppn[i] == inv_vpn) : (tlb_vppn[i][18:9] == inv_vpn[18:9]))) 
                           begin
                            tlb_e[i] <= 1'b0;
                        end
                    end
                end
            end
        end 
endgenerate

endmodule
