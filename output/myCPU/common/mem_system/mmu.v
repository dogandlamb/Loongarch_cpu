module mmu (
    input  wire        clk,
    input  wire        reset,

    input  wire        inst_req_in,
    input  wire [31:0] inst_vaddr_in,
    input  wire        inst_adef_in,

    input  wire        data_re_in,
    input  wire        data_we_in,
    input  wire [31:0] data_vaddr_r_in,
    input  wire [31:0] data_vaddr_w_in,
    input  wire [31:0] data_wdata_in,
    input  wire [3:0]  data_wstrb_in,

    input  wire [31:0] bridge_inst_rdata_in,
    input  wire [31:0] bridge_data_rdata_in,
    input  wire        bridge_inst_complete_in,
    input  wire        bridge_data_r_complete_in,
    input  wire        bridge_data_w_complete_in,

    input  wire [1:0]  csr_crmd_datf_in,
    input  wire [1:0]  csr_crmd_datm_in,
    input  wire [31:0] csr_dmw0_in,
    input  wire [31:0] csr_dmw1_in,

    input  wire [31:0] tlbm_inst_paddr,
    input  wire [31:0] tlbm_data_paddr,
    input  wire        tlbm_inst_ex_tlbr,
    input  wire        tlbm_inst_ex_pif,
    input  wire        tlbm_inst_ex_ppi,
    input  wire        tlbm_data_ex_tlbr,
    input  wire        tlbm_data_ex_pil,
    input  wire        tlbm_data_ex_pis,
    input  wire        tlbm_data_ex_ppi,
    input  wire        tlbm_data_ex_pme,
    input  wire [1:0]  tlbm_inst_mat,
    input  wire [1:0]  tlbm_data_mat,

    output wire        inst_req_out,
    output wire [31:0] inst_paddr_out,
    output wire        inst_adef_out,
    output wire        inst_tlbr_out,
    output wire        inst_pif_out,
    output wire        inst_ppi_out,
    output wire [1:0]  inst_mat_out,

    output wire        data_re_out,
    output wire        data_we_out,
    output wire [31:0] data_paddr_r_out,
    output wire [31:0] data_paddr_w_out,
    output wire [31:0] data_wdata_out,
    output wire [3:0]  data_wstrb_out,
    output wire        data_tlbr_out,
    output wire        data_pil_out,
    output wire        data_pis_out,
    output wire        data_ppi_out,
    output wire        data_pme_out,
    output wire        data_tlb_excp_cancel_out,
    output wire [1:0]  data_mat_out,

    output wire [31:0] inst_rdata_out,
    output wire [31:0] data_rdata_out,
    output wire        inst_complete_out,
    output wire        data_r_complete_out,
    output wire        data_w_complete_out
);

wire data_req_any = data_re_in | data_we_in;
wire data_has_tlb_ex = tlbm_data_ex_tlbr | tlbm_data_ex_pil | tlbm_data_ex_pis | tlbm_data_ex_ppi | tlbm_data_ex_pme;
wire inst_has_tlb_ex = tlbm_inst_ex_tlbr | tlbm_inst_ex_pif | tlbm_inst_ex_ppi;

assign inst_req_out   = inst_req_in & !inst_adef_in & !inst_has_tlb_ex;
assign inst_paddr_out = tlbm_inst_paddr;
assign inst_adef_out  = inst_adef_in;
assign inst_tlbr_out  = inst_req_in & tlbm_inst_ex_tlbr;
assign inst_pif_out   = inst_req_in & tlbm_inst_ex_pif;
assign inst_ppi_out   = inst_req_in & tlbm_inst_ex_ppi;

assign data_re_out      = data_re_in & !data_has_tlb_ex;
assign data_we_out      = data_we_in & !data_has_tlb_ex;
assign data_paddr_r_out = tlbm_data_paddr;
assign data_paddr_w_out = tlbm_data_paddr;
assign data_wdata_out   = data_wdata_in;
assign data_wstrb_out   = data_wstrb_in;
assign data_tlbr_out    = data_req_any & tlbm_data_ex_tlbr;
assign data_pil_out     = data_req_any & tlbm_data_ex_pil;
assign data_pis_out     = data_req_any & tlbm_data_ex_pis;
assign data_ppi_out     = data_req_any & tlbm_data_ex_ppi;
assign data_pme_out     = data_req_any & tlbm_data_ex_pme;
assign data_tlb_excp_cancel_out = data_req_any & data_has_tlb_ex;

assign inst_rdata_out       = bridge_inst_rdata_in;
assign data_rdata_out       = bridge_data_rdata_in;
assign inst_complete_out    = bridge_inst_complete_in;
assign data_r_complete_out  = bridge_data_r_complete_in;
assign data_w_complete_out  = bridge_data_w_complete_in;
assign inst_mat_out         = tlbm_inst_mat;
assign data_mat_out         = tlbm_data_mat;

wire mmu_lint_sink;
assign mmu_lint_sink = clk ^ reset;

endmodule
