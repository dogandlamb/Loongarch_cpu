module tlb
#(
    parameter TLBNUM = 8
) (
input wire clk,

//search port 0, for fetch
input  wire [              18:0] inst_s0_vppn,
input  wire                      inst_s0_va_bit12,
input  wire [               9:0] inst_s0_asid,
output wire                      inst_s0_found,
output logic[$clog2(TLBNUM)-1:0] inst_s0_index,
output wire [              19:0] inst_s0_ppn,
output wire [               5:0] inst_s0_ps,
output wire [               1:0] inst_s0_plv,
output wire [               1:0] inst_s0_mat,
output wire                      inst_s0_d,
output wire                      inst_s0_v,

//search port 1, for load/store and INVTLB
input  wire [              18:0] data_s1_vppn,
input  wire                      data_s1_va_bit12,
input  wire [               9:0] data_s1_asid,
output wire                      data_s1_found,
output logic[$clog2(TLBNUM)-1:0] data_s1_index,
output wire [              19:0] data_s1_ppn,
output wire [               5:0] data_s1_ps,
output wire [               1:0] data_s1_plv,
output wire [               1:0] data_s1_mat,
output wire                      data_s1_d,
output wire                      data_s1_v,

//invtlb opcode
input  wire                      invtlb_valid,
input  wire [               4:0] invtlb_op,

//write port
input  wire                      we,//高电平有�?
input  wire [$clog2(TLBNUM)-1:0] w_tlb_index,
input  wire                      w_tlb_e,
input  wire [              18:0] w_tlb_vppn,
input  wire [               5:0] w_tlb_ps,
input  wire [               9:0] w_tlb_asid,
input  wire                      w_tlb_g,
input  wire [              19:0] w_tlb_ppn0,
input  wire [               1:0] w_tlb_plv0,   
input  wire [               1:0] w_tlb_mat0,
input  wire                      w_tlb_d0,
input  wire                      w_tlb_v0,
input  wire [              19:0] w_tlb_ppn1,
input  wire [               1:0] w_tlb_plv1,
input  wire [               1:0] w_tlb_mat1,
input  wire                      w_tlb_d1,
input  wire                      w_tlb_v1,

//read port
input  wire [$clog2(TLBNUM)-1:0] r_tlb_index,
output wire                      r_tlb_e,
output wire [              18:0] r_tlb_vppn,
output wire [               5:0] r_tlb_ps,
output wire [               9:0] r_tlb_asid,
output wire                      r_tlb_g,
output wire [              19:0] r_tlb_ppn0,
output wire [               1:0] r_tlb_plv0,
output wire [               1:0] r_tlb_mat0,
output wire                      r_tlb_d0,
output wire                      r_tlb_v0,
output wire [              19:0] r_tlb_ppn1,
output wire [               1:0] r_tlb_plv1,
output wire [               1:0] r_tlb_mat1,
output wire                      r_tlb_d1,
output wire                      r_tlb_v1
);



wire inst_s0_lowest_bit;
wire data_s1_lowest_bit;
wire [TLBNUM-1:0] match0;
wire [TLBNUM-1:0] match1;
wire [TLBNUM-1:0] inv_match;







reg  [TLBNUM-1:0] tlb_e;
reg  [TLBNUM-1:0] tlb_ps4MB; //pagesize 1:4MB  0:4KB
reg  [      18:0] tlb_vppn [TLBNUM-1:0];
reg  [       9:0] tlb_asid [TLBNUM-1:0];
reg               tlb_g    [TLBNUM-1:0];
reg  [      19:0] tlb_ppn0 [TLBNUM-1:0];
reg  [       1:0] tlb_plv0 [TLBNUM-1:0];
reg  [       1:0] tlb_mat0 [TLBNUM-1:0];
reg               tlb_d0   [TLBNUM-1:0];
reg               tlb_v0   [TLBNUM-1:0];
reg  [      19:0] tlb_ppn1 [TLBNUM-1:0];
reg  [       1:0] tlb_plv1 [TLBNUM-1:0];
reg  [       1:0] tlb_mat1 [TLBNUM-1:0];
reg               tlb_d1   [TLBNUM-1:0];
reg               tlb_v1   [TLBNUM-1:0];



//inv_match部分
wire [TLBNUM-1:0] G_is_0;
wire [TLBNUM-1:0] data_s1_asid_eq_ASID;
wire [TLBNUM-1:0] data_s1_vppn_match; //判断虚拟地址是否匹配�?要同时参考vppn与ps�?


//TLBRD部分
assign r_tlb_g    = tlb_g     [r_tlb_index];
assign r_tlb_ppn0 = tlb_ppn0  [r_tlb_index];
assign r_tlb_plv0 = tlb_plv0  [r_tlb_index];
assign r_tlb_mat0 = tlb_mat0  [r_tlb_index];
assign r_tlb_d0   = tlb_d0    [r_tlb_index];
assign r_tlb_v0   = tlb_v0    [r_tlb_index];
assign r_tlb_ppn1 = tlb_ppn1  [r_tlb_index];
assign r_tlb_plv1 = tlb_plv1  [r_tlb_index];
assign r_tlb_mat1 = tlb_mat1  [r_tlb_index];
assign r_tlb_d1   = tlb_d1    [r_tlb_index];
assign r_tlb_v1   = tlb_v1    [r_tlb_index];
assign r_tlb_e    = tlb_e     [r_tlb_index];
assign r_tlb_vppn = tlb_vppn  [r_tlb_index];
assign r_tlb_ps   = tlb_ps4MB [r_tlb_index] ? 6'd21 : 6'd12; //4MB:21 4KB:12
assign r_tlb_asid = tlb_asid  [r_tlb_index];


//TLBWR与TLBFILL
integer k;
always @(posedge clk) begin
    if (we) begin
        tlb_e     [w_tlb_index] <= w_tlb_e; //注意此处tlb_e的赋值与写tlb事件冲突,但实际不会同时发生tlbinv与tlbwr事件
        tlb_ps4MB [w_tlb_index] <= w_tlb_ps[0];
        tlb_vppn  [w_tlb_index] <= w_tlb_vppn;
        tlb_asid  [w_tlb_index] <= w_tlb_asid;
        tlb_g     [w_tlb_index] <= w_tlb_g;
        tlb_ppn0  [w_tlb_index] <= w_tlb_ppn0;
        tlb_plv0  [w_tlb_index] <= w_tlb_plv0;
        tlb_mat0  [w_tlb_index] <= w_tlb_mat0;
        tlb_d0    [w_tlb_index] <= w_tlb_d0;
        tlb_v0    [w_tlb_index] <= w_tlb_v0;
        tlb_ppn1  [w_tlb_index] <= w_tlb_ppn1;
        tlb_plv1  [w_tlb_index] <= w_tlb_plv1;
        tlb_mat1  [w_tlb_index] <= w_tlb_mat1;
        tlb_d1    [w_tlb_index] <= w_tlb_d1;
        tlb_v1    [w_tlb_index] <= w_tlb_v1;
    end else if(invtlb_valid)begin
        for (k = 0; k < TLBNUM; k=k+1) begin
            if  (inv_match[k])tlb_e[k] <= 1'b0; //注意此处tlb_e的赋值与写tlb事件冲突,但实际不会同时发生tlbinv与tlbwr事件
        end
    end
end

//INVTLB

//TLB命中判断
//s0部分
assign inst_s0_found = |match0;
/*assign s0_index = match0[ 0] ?  0 :
                  match0[ 1] ?  1 :
                  match0[ 2] ?  2 :
                  match0[ 3] ?  3 :
                  match0[ 4] ?  4 :
                  match0[ 5] ?  5 :
                  match0[ 6] ?  6 :
                  match0[ 7] ?  7 :
                  match0[ 8] ?  8 :
                  match0[ 9] ?  9 :
                  match0[10] ? 10 :
                  match0[11] ? 11 :
                  match0[12] ? 12 :
                  match0[13] ? 13 :
                  match0[14] ? 14 : 15; //若未找到使用15*/

//always_comb begin
//    unique case (1'b1)
//        match0[ 0] : inst_s0_index = 0;
//        match0[ 1] : inst_s0_index = 1;
//        match0[ 2] : inst_s0_index = 2;
//        match0[ 3] : inst_s0_index = 3;
//        match0[ 4] : inst_s0_index = 4;
//        match0[ 5] : inst_s0_index = 5;
//        match0[ 6] : inst_s0_index = 6;
//        match0[ 7] : inst_s0_index = 7;
//        default    : inst_s0_index = 0;
//    endcase
//end

 assign inst_s0_index = match0[ 0] ?  0 :
                   match0[ 1] ?  1 :
                   match0[ 2] ?  2 :
                   match0[ 3] ?  3 :
                   match0[ 4] ?  4 :
                   match0[ 5] ?  5 :
                   match0[ 6] ?  6 :
                   match0[ 7] ?  7 : 0 ;/*
                   match0[ 8] ?  8 :
                   match0[ 9] ?  9 :
                   match0[10] ? 10 :
                   match0[11] ? 11 :
                   match0[12] ? 12 :
                   match0[13] ? 13 :
                   match0[14] ? 14 :
                   match0[15] ?  15 :0;
                   match0[16] ?  16 :
                   match0[ 17] ? 17 :
                   match0[18] ? 18 :
                   match0[19] ? 19 :
                   match0[20] ? 20 :
                   match0[21] ? 21 :
                   match0[22] ? 22 :
                   match0[23] ? 23 :
                   match0[24] ? 24 :
                   match0[25] ? 25 :
                   match0[26] ? 26 :
                   match0[27] ? 27 :
                   match0[28] ? 28 :
                   match0[29] ? 29 :
                   match0[30] ? 30 :
                   match0[31] ? 31 :0;*/


assign data_s1_lowest_bit = tlb_ps4MB[data_s1_index] ? data_s1_vppn[8] : data_s1_va_bit12; //页号实际�?低位与页大小相关
assign data_s1_ppn        = data_s1_lowest_bit ? tlb_ppn1[data_s1_index] : tlb_ppn0[data_s1_index];
assign data_s1_ps         = tlb_ps4MB[data_s1_index] ? 6'd21 : 6'd12; //4MB:21 4KB:12
assign data_s1_plv        = data_s1_lowest_bit ? tlb_plv1[data_s1_index] : tlb_plv0[data_s1_index];
assign data_s1_mat        = data_s1_lowest_bit ? tlb_mat1[data_s1_index] : tlb_mat0[data_s1_index];
assign data_s1_d          = data_s1_lowest_bit ? tlb_d1  [data_s1_index] : tlb_d0  [data_s1_index];
assign data_s1_v          = data_s1_lowest_bit ? tlb_v1  [data_s1_index] : tlb_v0  [data_s1_index];


assign inst_s0_lowest_bit = tlb_ps4MB[inst_s0_index] ? inst_s0_vppn[8] : inst_s0_va_bit12; //页号实际�?低位与页大小相关
assign inst_s0_ppn        = inst_s0_lowest_bit ? tlb_ppn1[inst_s0_index] : tlb_ppn0[inst_s0_index];
assign inst_s0_ps         = tlb_ps4MB[inst_s0_index] ? 6'd21 : 6'd12; //4MB:21 4KB:12
assign inst_s0_plv        = inst_s0_lowest_bit ? tlb_plv1[inst_s0_index] : tlb_plv0[inst_s0_index];
assign inst_s0_mat        = inst_s0_lowest_bit ? tlb_mat1[inst_s0_index] : tlb_mat0[inst_s0_index];
assign inst_s0_d          = inst_s0_lowest_bit ? tlb_d1  [inst_s0_index] : tlb_d0  [inst_s0_index];
assign inst_s0_v          = inst_s0_lowest_bit ? tlb_v1  [inst_s0_index] : tlb_v0  [inst_s0_index];

//s1部分
assign data_s1_found = |match1;
/*assign s1_index = match1[ 0] ?  0 :
                  match1[ 1] ?  1 :
                  match1[ 2] ?  2 :
                  match1[ 3] ?  3 :
                  match1[ 4] ?  4 :
                  match1[ 5] ?  5 :
                  match1[ 6] ?  6 :
                  match1[ 7] ?  7 :
                  match1[ 8] ?  8 :
                  match1[ 9] ?  9 :
                  match1[10] ? 10 :
                  match1[11] ? 11 :
                  match1[12] ? 12 :
                  match1[13] ? 13 :
                  match1[14] ? 14 : 15; //若未找到使用15*/


//always_comb begin
//    unique case (1'b1)
//        match1[ 0] : data_s1_index = 0;
//        match1[ 1] : data_s1_index = 1;
//        match1[ 2] : data_s1_index = 2;
//        match1[ 3] : data_s1_index = 3;
//        match1[ 4] : data_s1_index = 4;
//        match1[ 5] : data_s1_index = 5;
//        match1[ 6] : data_s1_index = 6;
//        match1[ 7] : data_s1_index = 7;
//        default    : data_s1_index = 0;
//    endcase
//end

 assign data_s1_index = match1[ 0] ?  0 :
                   match1[ 1] ?  1 :
                   match1[ 2] ?  2 :
                   match1[ 3] ?  3 :
                   match1[ 4] ?  4 :
                   match1[ 5] ?  5 :
                   match1[ 6] ?  6 :
                   match1[ 7] ?  7 : 0 ;/*
                   match1[ 8] ?  8 :
                   match1[ 9] ?  9 :
                   match1[10] ? 10 :
                   match1[11] ? 11 :
                   match1[12] ? 12 :
                   match1[13] ? 13 :
                   match1[14] ? 14 :
                   match1[15] ?  15 :0;
                   match1[16] ?  16 :
                   match1[ 17] ? 17 :
                   match1[18] ? 18 :
                   match1[19] ? 19 :
                   match1[20] ? 20 :
                   match1[21] ? 21 :
                   match1[22] ? 22 :
                   match1[23] ? 23 :
                   match1[24] ? 24 :
                   match1[25] ? 25 :
                   match1[26] ? 26 :
                   match1[27] ? 27 :
                   match1[28] ? 28 :
                   match1[29] ? 29 :
                   match1[30] ? 30 :
                   match1[31] ? 31 :0;*/



//match部分
genvar i;

for (i = 0; i < TLBNUM; i=i+1) begin
    assign match0[i] = (inst_s0_vppn[18:9] == tlb_vppn[i][18:9]) //先�?�虑满足4MB的条件（�?9�?+省略的奇偶构�?10位）
                    && (tlb_ps4MB[i] || inst_s0_vppn[8:0] == tlb_vppn[i][8:0]) //再�?�虑满足4KB的条�?
                    && ((inst_s0_asid == tlb_asid[i]) || tlb_g[i]) && tlb_e[i]; //满足asid相同或�?�tlb_g�?1，最后�?�虑当前位是否有效，tlb_e�?1
    assign match1[i] = (data_s1_vppn[18:9] == tlb_vppn[i][18:9])
                    && (tlb_ps4MB[i] || data_s1_vppn[8:0] == tlb_vppn[i][8:0])
                    && ((data_s1_asid == tlb_asid[i]) || tlb_g[i]) && tlb_e[i];
end



genvar j;
for (j = 0; j < TLBNUM; j=j+1) begin
    assign G_is_0[j]           = !tlb_g[j];
    assign data_s1_asid_eq_ASID[j]  = (data_s1_asid == tlb_asid[j]); //判断asid是否相同
    assign data_s1_vppn_match[j] = tlb_ps4MB[j] ? data_s1_vppn[18:9] == tlb_vppn[j][18:9] :
                                             data_s1_vppn[18:0] == tlb_vppn[j][18:0];
    assign inv_match[j] = ((invtlb_op == 5'd0 || invtlb_op == 5'd1)
                        || (invtlb_op == 5'd2 && !G_is_0[j])
                        || (invtlb_op == 5'd3 &&  G_is_0[j])
                        || (invtlb_op == 5'd4 &&  G_is_0[j] && data_s1_asid_eq_ASID[j])
                        || (invtlb_op == 5'd5 &&   G_is_0[j] && data_s1_asid_eq_ASID[j]  && data_s1_vppn_match[j])
                        || (invtlb_op == 5'd6 && (!G_is_0[j] || data_s1_asid_eq_ASID[j]) && data_s1_vppn_match[j]))
                        && invtlb_valid;
end



endmodule

