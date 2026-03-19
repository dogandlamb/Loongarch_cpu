`include "defines.vh"
`include "csr_defines.vh"
module addr_trans

(
    input                  clk                  ,
    input  [ 9:0]          asid                 ,       // 地址空间标识符，用于区分不同进程的地址空间

    //inst addr trans   指令地址转换
    input                  inst_fetch           ,
    input  [31:0]          inst_vaddr           ,
    input  [31:0]          inst_vaddr_plus      ,

    output wire            not_same_page            ,
    output wire            inst_uncache_en      ,
    output reg [31:0]      inst_paddr_out           ,
    output reg             inst_tlb_found_out       ,
    output reg             inst_tlb_v_out           ,
    output reg             inst_tlb_d_out           ,
    output reg [ 1:0]      inst_tlb_mat_out         ,
    output reg [ 1:0]      inst_tlb_plv_out         ,
    output reg             inst_addr_trans_en_out   ,

    //data addr trans   数据地址转换
    input                  data_fetch           ,
    input  [31:0]          data_vaddr           ,   //need to be chose data_vaddr or cache_cacop_vaddr in mycpu_top
    input                  dcacop_en            ,     // waiting to be connected**
    input  [1:0]           cacop_mode           ,    // waiting to be connected**

    output wire            data_uncache_en      ,
    output reg [31:0]      data_paddr_out       ,
    output reg             data_tlb_found_out   ,
    output reg [ 4:0]      data_tlb_index_out   ,
    output reg             data_tlb_v_out       ,
    output reg             data_tlb_d_out       ,
    output reg [ 1:0]      data_tlb_mat_out     ,           
    output reg [ 1:0]      data_tlb_plv_out     ,
    output reg             data_addr_trans_en_out,
    
    //tlbwi tlbwr tlb write
    input                  tlbfill_en           ,
    input                  tlbwr_en             ,
    input  [ 4:0]          rand_index           ,
    input  [31:0]          tlbehi_in            ,
    input  [31:0]          tlbelo0_in           ,
    input  [31:0]          tlbelo1_in           ,
    input  [31:0]          tlbidx_in            , 
    input  [ 5:0]          ecode_in             ,
    //tlbr tlb read
    output [31:0]          tlbehi_out           ,
    output [31:0]          tlbelo0_out          ,
    output [31:0]          tlbelo1_out          ,
    output [31:0]          tlbidx_out           ,
    output [ 9:0]          asid_out             ,
    //invtlb 
    input                  invtlb_en            ,
    input  [ 9:0]          invtlb_asid          ,
    input  [18:0]          invtlb_vpn           ,
    input  [ 4:0]          invtlb_op            ,
    //from csr
    input  [ 1:0]          csr_plv              ,
    input  [31:0]          csr_dmw0             ,
    input  [31:0]          csr_dmw1             ,
    input                  csr_da               ,
    input                  csr_pg ,
    input  [1:0]           csr_datm              ,
    input  [1:0]           csr_datf                    // waiting to be connected************************
);

wire [ 5:0] s0_ps       ;
wire [19:0] s0_ppn      ;

wire [ 5:0] s1_ps       ;
wire [19:0] s1_ppn      ;  

wire        we          ;
wire [ 4:0] w_index     ;
wire [18:0] w_vppn      ;
wire        w_g         ;
wire [ 5:0] w_ps        ;
wire        w_e         ;
wire        w_v0        ;
wire        w_d0        ;
wire [ 1:0] w_mat0      ;
wire [ 1:0] w_plv0      ;
wire [19:0] w_ppn0      ;
wire        w_v1        ;
wire        w_d1        ;
wire [ 1:0] w_mat1      ;
wire [ 1:0] w_plv1      ;
wire [19:0] w_ppn1      ;

wire [ 4:0] r_index     ;
wire [18:0] r_vppn      ;
wire [ 9:0] r_asid      ;
wire        r_g         ;
wire [ 5:0] r_ps        ;
wire        r_e         ;
wire        r_v0        ;
wire        r_d0        ; 
wire [ 1:0] r_mat0      ;
wire [ 1:0] r_plv0      ;
wire [19:0] r_ppn0      ;
wire        r_v1        ;
wire        r_d1        ;
wire [ 1:0] r_mat1      ;
wire [ 1:0] r_plv1      ;
wire [19:0] r_ppn1      ;

wire [31:0] inst_addr_temp;
wire [31:0] data_addr_temp;

wire        pg_mode;
wire        da_mode;

wire [19:0] inst_tag;

wire [19:0] data_tag;

//trans write port sig
assign we      = tlbfill_en || tlbwr_en;
assign w_index = ({5{tlbfill_en}} & rand_index) | ({5{tlbwr_en}} & tlbidx_in[`INDEX]);
assign w_vppn  = tlbehi_in[`VPPN];
assign w_g     = tlbelo0_in[`TLB_G] && tlbelo1_in[`TLB_G];
assign w_ps    = tlbidx_in[`PS];
assign w_e     = (ecode_in == 6'h3f) ? 1'b1 : !tlbidx_in[`NE];
assign w_v0    = tlbelo0_in[`TLB_V];
assign w_d0    = tlbelo0_in[`TLB_D];
assign w_plv0  = tlbelo0_in[`TLB_PLV];
assign w_mat0  = tlbelo0_in[`TLB_MAT];
assign w_ppn0  = tlbelo0_in[`TLB_PPN_EN];
assign w_v1    = tlbelo1_in[`TLB_V];
assign w_d1    = tlbelo1_in[`TLB_D];
assign w_plv1  = tlbelo1_in[`TLB_PLV];
assign w_mat1  = tlbelo1_in[`TLB_MAT];
assign w_ppn1  = tlbelo1_in[`TLB_PPN_EN];

//trans read port sig
assign r_index      = tlbidx_in[`INDEX];
assign tlbehi_out   = {r_vppn, 13'b0};
assign tlbelo0_out  = {4'b0, r_ppn0, 1'b0, r_g, r_mat0, r_plv0, r_d0, r_v0};
assign tlbelo1_out  = {4'b0, r_ppn1, 1'b0, r_g, r_mat1, r_plv1, r_d1, r_v1};
assign tlbidx_out   = {!r_e, 1'b0, r_ps, 24'b0}; //note do not write index
assign asid_out     = r_asid;

wire [31:0] inst_paddr;
wire inst_tlb_found;
wire inst_tlb_v;
wire inst_tlb_d;
wire [1:0] inst_tlb_mat;
wire [1:0] inst_tlb_plv;

wire [31:0] data_paddr;
wire data_tlb_found;
wire [4:0] data_tlb_index;
wire data_tlb_v;
wire data_tlb_d;
wire [1:0] data_tlb_mat;
wire [1:0] data_tlb_plv;

wire tlb_same_page_out;
tlb u_tlb
(
    .clk            (clk            ),

    // search port 0
    .s0_vaddr       (inst_vaddr     ),
    .s0_vaddr_plus  (inst_vaddr_plus),
    .s0_asid        (asid           ),

    .same_page      (tlb_same_page_out),
    .s0_found       (inst_tlb_found ),
//    .s0_index       (               ),                 //not useful?
    .s0_ps          (s0_ps          ),
    .s0_ppn         (s0_ppn         ),
    .s0_v           (inst_tlb_v     ),
    .s0_d           (inst_tlb_d     ),
    .s0_mat         (inst_tlb_mat   ),
    .s0_plv         (inst_tlb_plv   ),
    // search port 1
    .s1_vaddr       (data_vaddr     ),
    .s1_asid        (asid           ),

    .s1_found       (data_tlb_found ),
    .s1_index       (data_tlb_index ),
    .s1_ps          (s1_ps          ),
    .s1_ppn         (s1_ppn         ),
    .s1_v           (data_tlb_v     ),
    .s1_d           (data_tlb_d     ),
    .s1_mat         (data_tlb_mat   ),
    .s1_plv         (data_tlb_plv   ),

    // write port 
    .we             (we             ),     
    .w_index        (w_index        ),
    .w_vppn         (w_vppn         ),
    .w_asid         (asid           ),
    .w_g            (w_g            ),
    .w_ps           (w_ps           ),
    .w_e            (w_e            ),
    .w_v0           (w_v0           ),
    .w_d0           (w_d0           ),
    .w_plv0         (w_plv0         ),
    .w_mat0         (w_mat0         ),
    .w_ppn0         (w_ppn0         ),
    .w_v1           (w_v1           ),
    .w_d1           (w_d1           ),
    .w_plv1         (w_plv1         ),
    .w_mat1         (w_mat1         ),
    .w_ppn1         (w_ppn1         ),
    //read port 
    .r_index        (r_index        ),
    .r_vppn         (r_vppn         ),
    .r_asid         (r_asid         ),
    .r_g            (r_g            ),
    .r_ps           (r_ps           ),
    .r_e            (r_e            ),
    .r_v0           (r_v0           ),
    .r_d0           (r_d0           ),
    .r_mat0         (r_mat0         ),
    .r_plv0         (r_plv0         ),
    .r_ppn0         (r_ppn0         ),
    .r_v1           (r_v1           ),
    .r_d1           (r_d1           ),
    .r_mat1         (r_mat1         ),
    .r_plv1         (r_plv1         ),
    .r_ppn1         (r_ppn1         ),
    //invalid port
    .inv_en         (invtlb_en      ),
    .inv_op         (invtlb_op      ),
    .inv_asid       (invtlb_asid    ),
    .inv_vpn        (invtlb_vpn     )
);

wire cacop_op_mode_di = dcacop_en & ((cacop_mode == 2'b0) || (cacop_mode == 2'b1));
assign pg_mode = !csr_da &&  csr_pg;
assign da_mode =  csr_da && !csr_pg;

wire inst_dmw0_en = ((csr_dmw0[0] & csr_plv == 2'd0) | (csr_dmw0[3] & csr_plv == 2'd3)) & (inst_vaddr[31:29] == csr_dmw0[31:29]) & pg_mode;
wire inst_dmw1_en = ((csr_dmw1[0] & csr_plv == 2'd0) | (csr_dmw1[3] & csr_plv == 2'd3)) & (inst_vaddr[31:29] == csr_dmw1[31:29]) & pg_mode;
wire data_dmw0_en = ((csr_dmw0[0] & csr_plv == 2'd0) | (csr_dmw0[3] & csr_plv == 2'd3)) & (data_vaddr[31:29] == csr_dmw0[31:29]) & pg_mode;
wire data_dmw1_en = ((csr_dmw1[0] & csr_plv == 2'd0) | (csr_dmw1[3] & csr_plv == 2'd3)) & (data_vaddr[31:29] == csr_dmw1[31:29]) & pg_mode;

wire inst_addr_trans_en = pg_mode && !inst_dmw0_en && !inst_dmw1_en;
assign inst_addr_temp = (pg_mode & inst_dmw0_en) ? {csr_dmw0[27:25], inst_vaddr[28:0]} :
                        (pg_mode & inst_dmw1_en) ? {csr_dmw1[27:25], inst_vaddr[28:0]} : inst_vaddr;

assign not_same_page = inst_addr_trans_en & !tlb_same_page_out;
assign inst_tag = inst_addr_trans_en ? ((s0_ps == 6'd12) ? s0_ppn : {s0_ppn[19:10], inst_addr_temp[21:12]}) : inst_addr_temp[31:12];
assign inst_paddr = {inst_tag,inst_vaddr[11:0]};
assign inst_uncache_en = (da_mode && (csr_datf == 2'b0))                 ||
                         (inst_dmw0_en && (csr_dmw0[`DMW_MAT] == 2'b0))  ||
                         (inst_dmw1_en && (csr_dmw1[`DMW_MAT] == 2'b0))  ||
                         (inst_addr_trans_en && (inst_tlb_mat == 2'b0));

wire data_addr_trans_en = pg_mode && !data_dmw0_en && !data_dmw1_en && !cacop_op_mode_di;
assign data_addr_temp = (pg_mode & data_dmw0_en & !cacop_op_mode_di) ? {csr_dmw0[27:25], data_vaddr[28:0]} : 
                        (pg_mode & data_dmw1_en & !cacop_op_mode_di) ? {csr_dmw1[27:25], data_vaddr[28:0]} : data_vaddr;

assign data_tag = data_addr_trans_en ? ((s1_ps == 6'd12) ? s1_ppn : {s1_ppn[19:10], data_addr_temp[21:12]}) : data_addr_temp[31:12];
assign data_paddr = {data_tag,data_vaddr[11:0]};

assign data_uncache_en = (da_mode && (csr_datm == 2'b0))                 || 
                         (data_dmw0_en && (csr_dmw0[`DMW_MAT] == 2'b0))  ||
                         (data_dmw1_en && (csr_dmw1[`DMW_MAT] == 2'b0))  ||
                         (data_addr_trans_en && (data_tlb_mat == 2'b0))  ||
                         (data_vaddr[31:16] == 16'hbfaf);  //this can not be found in openla,I am not sure whenever it is necessary?

//there is a csr_reg in the code of openla.but I didn't find it in our own csr module
//maybe it is not significant,so I deleted it.

always @(posedge clk)
begin
    if(inst_fetch)
    begin
        inst_paddr_out <= inst_paddr;
        inst_tlb_found_out <= inst_tlb_found;
        inst_tlb_v_out <= inst_tlb_v;
        inst_tlb_d_out <= inst_tlb_d;
        inst_tlb_mat_out <= inst_tlb_mat;
        inst_tlb_plv_out <= inst_tlb_plv;
        inst_addr_trans_en_out <= inst_addr_trans_en;
    end
end
always @(posedge clk)
begin
    if(data_fetch)
    begin
        data_paddr_out <= data_paddr;
        data_tlb_found_out <= data_tlb_found;
        data_tlb_index_out <= data_tlb_index;
        data_tlb_v_out <= data_tlb_v;
        data_tlb_d_out <= data_tlb_d;
        data_tlb_mat_out <= data_tlb_mat;
        data_tlb_plv_out <= data_tlb_plv;
        data_addr_trans_en_out <= data_addr_trans_en;
    end
end
endmodule
