`include "../common/cpu_defs.vh"

module tlb_manager #(
    parameter TLBNUM = 16
) (
    input  wire                         clk,
    input  wire                         reset,

    input  wire                         inst_req,
    input  wire [31:0]                  inst_vaddr,
    input  wire                         data_req,
    input  wire                         data_is_store,
    input  wire [31:0]                  data_vaddr,

    input  wire                         csr_crmd_da,
    input  wire                         csr_crmd_pg,
    input  wire [1:0]                   csr_crmd_plv,
    input  wire [9:0]                   csr_asid,
    input  wire [31:0]                  csr_tlbidx,
    input  wire [31:0]                  csr_tlbehi,
    input  wire [31:0]                  csr_tlbelo0,
    input  wire [31:0]                  csr_tlbelo1,
    input  wire [31:0]                  csr_dmw0,
    input  wire [31:0]                  csr_dmw1,
    input  wire [7:0]                   csr_estat_ecode,

    input  wire [`TLB_OP_NUM-1:0]       tlb_op,

    input  wire [9:0]                   invtlb_asid,
    input  wire [18:0]                  invtlb_vpn,

    output wire [31:0]                  inst_paddr,
    output wire                         inst_ex_tlbr,
    output wire                         inst_ex_pif,
    output wire                         inst_ex_ppi,

    output wire [31:0]                  data_paddr,
    output wire                         data_ex_tlbr,
    output wire                         data_ex_pil,
    output wire                         data_ex_pis,
    output wire                         data_ex_ppi,
    output wire                         data_ex_pme,

    output wire                         tlbsrch_found,
    output wire [$clog2(TLBNUM)-1:0]    tlbsrch_index,

    output wire [31:0]                  tlbrd_tlbidx,
    output wire [31:0]                  tlbrd_tlbehi,
    output wire [31:0]                  tlbrd_tlbelo0,
    output wire [31:0]                  tlbrd_tlbelo1,
    output wire [9:0]                   tlbrd_asid
);

localparam [5:0] PS_4KB = 6'd12;
localparam IDXW = $clog2(TLBNUM);

wire pg_mode = !csr_crmd_da && csr_crmd_pg;
wire da_mode = csr_crmd_da && !csr_crmd_pg;

wire inst_dmw0_hit = pg_mode && ((inst_vaddr[31:29] == csr_dmw0[31:29]) && ((csr_crmd_plv == 2'b00 && csr_dmw0[0]) || (csr_crmd_plv == 2'b11 && csr_dmw0[3])));
wire inst_dmw1_hit = pg_mode && ((inst_vaddr[31:29] == csr_dmw1[31:29]) && ((csr_crmd_plv == 2'b00 && csr_dmw1[0]) || (csr_crmd_plv == 2'b11 && csr_dmw1[3])));
wire data_dmw0_hit = pg_mode && ((data_vaddr[31:29] == csr_dmw0[31:29]) && ((csr_crmd_plv == 2'b00 && csr_dmw0[0]) || (csr_crmd_plv == 2'b11 && csr_dmw0[3])));
wire data_dmw1_hit = pg_mode && ((data_vaddr[31:29] == csr_dmw1[31:29]) && ((csr_crmd_plv == 2'b00 && csr_dmw1[0]) || (csr_crmd_plv == 2'b11 && csr_dmw1[3])));

wire [18:0] s0_vppn = inst_vaddr[31:13];
wire [18:0] s1_vppn = data_vaddr[31:13];
wire        s0_va_bit12 = inst_vaddr[12];
wire        s1_va_bit12 = data_vaddr[12];

wire                        s0_found;
wire [IDXW-1:0]            s0_index;
wire [19:0]                s0_ppn;
wire [5:0]                 s0_ps;
wire [1:0]                 s0_plv;
wire [1:0]                 s0_mat;
wire                       s0_d;
wire                       s0_v;
wire                        s1_found;
wire [IDXW-1:0]            s1_index;
wire [19:0]                s1_ppn;
wire [5:0]                 s1_ps;
wire [1:0]                 s1_plv;
wire [1:0]                 s1_mat;
wire                       s1_d;
wire                       s1_v;

wire                        r_e;
wire [18:0]                 r_vppn;
wire [5:0]                  r_ps;
wire [9:0]                  r_asid;
wire                        r_g;
wire [19:0]                 r_ppn0;
wire [1:0]                  r_plv0;
wire [1:0]                  r_mat0;
wire                        r_d0;
wire                        r_v0;
wire [19:0]                 r_ppn1;
wire [1:0]                  r_plv1;
wire [1:0]                  r_mat1;
wire                        r_d1;
wire                        r_v1;

reg [IDXW-1:0] rand_idx;
always @(posedge clk) begin
    if (reset) begin
        rand_idx <= {IDXW{1'b0}};
    end else begin
        rand_idx <= rand_idx + {{(IDXW-1){1'b0}}, 1'b1};
    end
end

wire do_tlbsrch = tlb_op[`TLB_OP_TLBSRCH];
wire do_tlbrd   = tlb_op[`TLB_OP_TLBRD];
wire do_tlbwr   = tlb_op[`TLB_OP_TLBWR];
wire do_tlbfill = tlb_op[`TLB_OP_TLBFILL];
wire do_invtlb  = tlb_op[`TLB_OP_INVTLB_0] | tlb_op[`TLB_OP_INVTLB_1] | tlb_op[`TLB_OP_INVTLB_2]
                | tlb_op[`TLB_OP_INVTLB_3] | tlb_op[`TLB_OP_INVTLB_4] | tlb_op[`TLB_OP_INVTLB_5]
                | tlb_op[`TLB_OP_INVTLB_6];

wire w_e = (csr_estat_ecode == `TLBR_ECODE) ? 1'b1 : ~csr_tlbidx[31];
wire [5:0] w_ps = csr_tlbidx[29:24];
wire [IDXW-1:0] w_index = do_tlbfill ? rand_idx : csr_tlbidx[IDXW-1:0];

wire [19:0] w_ppn0 = csr_tlbelo0[27:8];
wire [1:0]  w_plv0 = csr_tlbelo0[3:2];
wire [1:0]  w_mat0 = csr_tlbelo0[5:4];
wire        w_d0   = csr_tlbelo0[1];
wire        w_v0   = csr_tlbelo0[0];
wire [19:0] w_ppn1 = csr_tlbelo1[27:8];
wire [1:0]  w_plv1 = csr_tlbelo1[3:2];
wire [1:0]  w_mat1 = csr_tlbelo1[5:4];
wire        w_d1   = csr_tlbelo1[1];
wire        w_v1   = csr_tlbelo1[0];
wire        w_g    = csr_tlbelo0[6] & csr_tlbelo1[6];

tlb #(.TLBNUM(TLBNUM)) u_tlb (
    .clk          (clk),
    .s0_vppn      (do_tlbsrch ? csr_tlbehi[31:13] : s0_vppn),
    .s0_va_bit12  (do_tlbsrch ? 1'b0 : s0_va_bit12),
    .s0_asid      (csr_asid),
    .s0_found     (s0_found),
    .s0_index     (s0_index),
    .s0_ppn       (s0_ppn),
    .s0_ps        (s0_ps),
    .s0_plv       (s0_plv),
    .s0_mat       (s0_mat),
    .s0_d         (s0_d),
    .s0_v         (s0_v),
    .s1_vppn      (s1_vppn),
    .s1_va_bit12  (s1_va_bit12),
    .s1_asid      (csr_asid),
    .s1_found     (s1_found),
    .s1_index     (s1_index),
    .s1_ppn       (s1_ppn),
    .s1_ps        (s1_ps),
    .s1_plv       (s1_plv),
    .s1_mat       (s1_mat),
    .s1_d         (s1_d),
    .s1_v         (s1_v),
    .invtlb_valid (do_invtlb),
    .invtlb_op    (invtlb_op),
    .invtlb_asid  (invtlb_asid),
    .invtlb_vpn   (invtlb_vpn),
    .we           (do_tlbwr | do_tlbfill),
    .w_index      (w_index),
    .w_e          (w_e),
    .w_vppn       (csr_tlbehi[31:13]),
    .w_ps         (w_ps),
    .w_asid       (csr_asid),
    .w_g          (w_g),
    .w_ppn0       (w_ppn0),
    .w_plv0       (w_plv0),
    .w_mat0       (w_mat0),
    .w_d0         (w_d0),
    .w_v0         (w_v0),
    .w_ppn1       (w_ppn1),
    .w_plv1       (w_plv1),
    .w_mat1       (w_mat1),
    .w_d1         (w_d1),
    .w_v1         (w_v1),
    .r_index      (csr_tlbidx[IDXW-1:0]),
    .r_e          (r_e),
    .r_vppn       (r_vppn),
    .r_ps         (r_ps),
    .r_asid       (r_asid),
    .r_g          (r_g),
    .r_ppn0       (r_ppn0),
    .r_plv0       (r_plv0),
    .r_mat0       (r_mat0),
    .r_d0         (r_d0),
    .r_v0         (r_v0),
    .r_ppn1       (r_ppn1),
    .r_plv1       (r_plv1),
    .r_mat1       (r_mat1),
    .r_d1         (r_d1),
    .r_v1         (r_v1)
);

wire [31:0] inst_tlb_paddr = (s0_ps == PS_4KB) ? {s0_ppn, inst_vaddr[11:0]} : {s0_ppn[19:10], inst_vaddr[21:0]};
wire [31:0] data_tlb_paddr = (s1_ps == PS_4KB) ? {s1_ppn, data_vaddr[11:0]} : {s1_ppn[19:10], data_vaddr[21:0]};

wire inst_need_tlb = pg_mode && !inst_dmw0_hit && !inst_dmw1_hit;
wire data_need_tlb = pg_mode && !data_dmw0_hit && !data_dmw1_hit;

assign inst_ex_tlbr = inst_req && inst_need_tlb && !s0_found;
assign inst_ex_pif  = inst_req && inst_need_tlb && s0_found && !s0_v;
assign inst_ex_ppi  = inst_req && inst_need_tlb && s0_found && s0_v && (csr_crmd_plv > s0_plv);

assign data_ex_tlbr = data_req && data_need_tlb && !s1_found;
assign data_ex_pil  = data_req && !data_is_store && data_need_tlb && s1_found && !s1_v;
assign data_ex_pis  = data_req && data_is_store  && data_need_tlb && s1_found && !s1_v;
assign data_ex_ppi  = data_req && data_need_tlb && s1_found && s1_v && (csr_crmd_plv > s1_plv);
assign data_ex_pme  = data_req && data_is_store && data_need_tlb && s1_found && s1_v && (csr_crmd_plv <= s1_plv) && !s1_d;

assign inst_paddr = da_mode ? inst_vaddr :
                    inst_dmw0_hit ? {csr_dmw0[27:25], inst_vaddr[28:0]} :
                    inst_dmw1_hit ? {csr_dmw1[27:25], inst_vaddr[28:0]} :
                    inst_tlb_paddr;

assign data_paddr = da_mode ? data_vaddr :
                    data_dmw0_hit ? {csr_dmw0[27:25], data_vaddr[28:0]} :
                    data_dmw1_hit ? {csr_dmw1[27:25], data_vaddr[28:0]} :
                    data_tlb_paddr;

assign tlbsrch_found = s0_found;
assign tlbsrch_index = s0_index;

assign tlbrd_tlbidx  = {~r_e, 1'b0, r_ps, 24'b0};
assign tlbrd_tlbehi  = {r_vppn, 13'b0};
assign tlbrd_tlbelo0 = {4'b0, r_ppn0, 1'b0, r_g, r_mat0, r_plv0, r_d0, r_v0};
assign tlbrd_tlbelo1 = {4'b0, r_ppn1, 1'b0, r_g, r_mat1, r_plv1, r_d1, r_v1};
assign tlbrd_asid    = r_asid;

endmodule
