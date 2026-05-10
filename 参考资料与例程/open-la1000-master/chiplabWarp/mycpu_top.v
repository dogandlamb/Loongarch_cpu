`define AXI_DATA_WIDTH 64
`define AXI_STRB_WIDTH (`AXI_DATA_WIDTH / 8)
module core_top(
    input           aclk,
    input           aresetn,
    input    [ 7:0] intrpt, 
    //AXI interface 
    //read reqest
    output   [ 3:0] arid,
    output   [31:0] araddr,
    output   [ 7:0] arlen,
    output   [ 2:0] arsize,
    output   [ 1:0] arburst,
    output   [ 1:0] arlock,
    output   [ 3:0] arcache,
    output   [ 2:0] arprot,
    output          arvalid,
    input           arready,
    //read back
    input    [ 3:0] rid,
    input    [`AXI_DATA_WIDTH-1:0] rdata,
    input    [ 1:0] rresp,
    input           rlast,
    input           rvalid,
    output          rready,
    //write request
    output   [ 3:0] awid,
    output   [31:0] awaddr,
    output   [ 7:0] awlen,
    output   [ 2:0] awsize,
    output   [ 1:0] awburst,
    output   [ 1:0] awlock,
    output   [ 3:0] awcache,
    output   [ 2:0] awprot,
    output          awvalid,
    input           awready,
    //write data
    output   [ 3:0] wid,
    output   [`AXI_DATA_WIDTH-1:0] wdata,
    output   [`AXI_STRB_WIDTH-1:0] wstrb,
    output          wlast,
    output          wvalid,
    input           wready,
    //write back
    input    [ 3:0] bid,
    input    [ 1:0] bresp,
    input           bvalid,
    output          bready,

    output [31:0] debug0_wb_pc,
    output [ 3:0] debug0_wb_rf_wen,
    output [ 4:0] debug0_wb_rf_wnum,
    output [31:0] debug0_wb_rf_wdata,
    output [31:0] debug0_wb_inst
);
reg         reset;
initial reset <= 1'b1;
always @(posedge aclk) reset <= ~aresetn; 

wire        inst_0_valid;
wire [31:0] inst_0_pc;
wire [31:0] inst_0_instr;
wire        inst_0_is_TLBFILL;
wire [3:0]  inst_0_TLBFILL_index;
wire        inst_0_is_CNTinst;
wire [63:0] inst_0_timer_64_value;
wire        inst_0_wen;
wire [4:0]  inst_0_wdest;
wire [31:0] inst_0_wdata;
wire        inst_0_csr_rstat;
wire [31:0] inst_0_csr_data;
wire        inst_1_valid;
wire [31:0] inst_1_pc;
wire [31:0] inst_1_instr;
wire        inst_1_is_TLBFILL;
wire [3:0]  inst_1_TLBFILL_index;
wire        inst_1_is_CNTinst;
wire [63:0] inst_1_timer_64_value;
wire        inst_1_wen;
wire [4:0]  inst_1_wdest;
wire [31:0] inst_1_wdata;
wire        inst_1_csr_rstat;
wire [31:0] inst_1_csr_data;
wire        inst_2_valid;
wire [31:0] inst_2_pc;
wire [31:0] inst_2_instr;
wire        inst_2_is_TLBFILL;
wire [3:0]  inst_2_TLBFILL_index;
wire        inst_2_is_CNTinst;
wire [63:0] inst_2_timer_64_value;
wire        inst_2_wen;
wire [4:0]  inst_2_wdest;
wire [31:0] inst_2_wdata;
wire        inst_2_csr_rstat;
wire [31:0] inst_2_csr_data;
wire        excp_excp_valid;
wire        excp_eret;
wire [10:0] excp_intrNo;
wire [5:0]  excp_cause;
wire [31:0] excp_exceptionPC;
wire [31:0] excp_exceptionInst;
wire [7:0]  store_valid;
wire [31:0] store_storePAddr;
wire [31:0] store_storeVAddr;
wire [31:0] store_storeData;
wire [7:0]  load_valid;
wire [31:0] load_paddr;
wire [31:0] load_vaddr;
wire [31:0] csr_crmd;
wire [31:0] csr_prmd;
wire [31:0] csr_euen;
wire [31:0] csr_ecfg;
wire [31:0] csr_estat;
wire [31:0] csr_era;
wire [31:0] csr_badv;
wire [31:0] csr_eentry;
wire [31:0] csr_tlbidx;
wire [31:0] csr_tlbehi;
wire [31:0] csr_tlbelo0;
wire [31:0] csr_tlbelo1;
wire [31:0] csr_asid;
wire [31:0] csr_pgdl;
wire [31:0] csr_pgdh;
wire [31:0] csr_save0;
wire [31:0] csr_save1;
wire [31:0] csr_save2;
wire [31:0] csr_save3;
wire [31:0] csr_tid;
wire [31:0] csr_tcfg;
wire [31:0] csr_tval;
wire [31:0] csr_ticlr;
wire [31:0] csr_llbctl;
wire [31:0] csr_tlbrentry;
wire [31:0] csr_dmw0;
wire [31:0] csr_dmw1;
wire [31:0] reg_0;
wire [31:0] reg_1;
wire [31:0] reg_2;
wire [31:0] reg_3;
wire [31:0] reg_4;
wire [31:0] reg_5;
wire [31:0] reg_6;
wire [31:0] reg_7;
wire [31:0] reg_8;
wire [31:0] reg_9;
wire [31:0] reg_10;
wire [31:0] reg_11;
wire [31:0] reg_12;
wire [31:0] reg_13;
wire [31:0] reg_14;
wire [31:0] reg_15;
wire [31:0] reg_16;
wire [31:0] reg_17;
wire [31:0] reg_18;
wire [31:0] reg_19;
wire [31:0] reg_20;
wire [31:0] reg_21;
wire [31:0] reg_22;
wire [31:0] reg_23;
wire [31:0] reg_24;
wire [31:0] reg_25;
wire [31:0] reg_26;
wire [31:0] reg_27;
wire [31:0] reg_28;
wire [31:0] reg_29;
wire [31:0] reg_30;
wire [31:0] reg_31;

AXITop AXITop(
    .clk                          (aclk),
    .reset                          (reset),
    .interrupt                   (intrpt),
    .diff_inst_0_valid             (inst_0_valid),
    .diff_inst_0_pc                (inst_0_pc),
    .diff_inst_0_instr             (inst_0_instr),
    .diff_inst_0_is_TLBFILL        (inst_0_is_TLBFILL),
    .diff_inst_0_TLBFILL_index     (inst_0_TLBFILL_index),
    .diff_inst_0_is_CNTinst        (inst_0_is_CNTinst),
    .diff_inst_0_timer_64_value    (inst_0_timer_64_value),
    .diff_inst_0_wen               (inst_0_wen),
    .diff_inst_0_wdest             (inst_0_wdest),
    .diff_inst_0_wdata             (inst_0_wdata),
    .diff_inst_0_csr_rstat         (inst_0_csr_rstat),
    .diff_inst_0_csr_data          (inst_0_csr_data),
    .diff_inst_1_valid             (inst_1_valid),
    .diff_inst_1_pc                (inst_1_pc),
    .diff_inst_1_instr             (inst_1_instr),
    .diff_inst_1_is_TLBFILL        (inst_1_is_TLBFILL),
    .diff_inst_1_TLBFILL_index     (inst_1_TLBFILL_index),
    .diff_inst_1_is_CNTinst        (inst_1_is_CNTinst),
    .diff_inst_1_timer_64_value    (inst_1_timer_64_value),
    .diff_inst_1_wen               (inst_1_wen),
    .diff_inst_1_wdest             (inst_1_wdest),
    .diff_inst_1_wdata             (inst_1_wdata),
    .diff_inst_1_csr_rstat         (inst_1_csr_rstat),
    .diff_inst_1_csr_data          (inst_1_csr_data),
    .diff_inst_2_valid             (inst_2_valid),
    .diff_inst_2_pc                (inst_2_pc),
    .diff_inst_2_instr             (inst_2_instr),
    .diff_inst_2_is_TLBFILL        (inst_2_is_TLBFILL),
    .diff_inst_2_TLBFILL_index     (inst_2_TLBFILL_index),
    .diff_inst_2_is_CNTinst        (inst_2_is_CNTinst),
    .diff_inst_2_timer_64_value    (inst_2_timer_64_value),
    .diff_inst_2_wen               (inst_2_wen),
    .diff_inst_2_wdest             (inst_2_wdest),
    .diff_inst_2_wdata             (inst_2_wdata),
    .diff_inst_2_csr_rstat         (inst_2_csr_rstat),
    .diff_inst_2_csr_data          (inst_2_csr_data),
    .diff_excp_excp_valid        (excp_excp_valid),
    .diff_excp_eret              (excp_eret),
    .diff_excp_intrNo            (excp_intrNo),
    .diff_excp_cause             (excp_cause),
    .diff_excp_exceptionPC       (excp_exceptionPC),
    .diff_excp_exceptionInst     (excp_exceptionInst),
    .diff_store_valid            (store_valid),
    .diff_store_storePAddr       (store_storePAddr),
    .diff_store_storeVAddr       (store_storeVAddr),
    .diff_store_storeData        (store_storeData),
    .diff_load_valid             (load_valid),
    .diff_load_paddr             (load_paddr),
    .diff_load_vaddr             (load_vaddr),
    .diff_csr_crmd               (csr_crmd),
    .diff_csr_prmd               (csr_prmd),
    .diff_csr_euen               (csr_euen),
    .diff_csr_ecfg               (csr_ecfg),
    .diff_csr_estat              (csr_estat),
    .diff_csr_era                (csr_era),
    .diff_csr_badv               (csr_badv),
    .diff_csr_eentry             (csr_eentry),
    .diff_csr_tlbidx             (csr_tlbidx),
    .diff_csr_tlbehi             (csr_tlbehi),
    .diff_csr_tlbelo0            (csr_tlbelo0),
    .diff_csr_tlbelo1            (csr_tlbelo1),
    .diff_csr_asid               (csr_asid),
    .diff_csr_pgdl               (csr_pgdl),
    .diff_csr_pgdh               (csr_pgdh),
    .diff_csr_save0              (csr_save0),
    .diff_csr_save1              (csr_save1),
    .diff_csr_save2              (csr_save2),
    .diff_csr_save3              (csr_save3),
    .diff_csr_tid                (csr_tid),
    .diff_csr_tcfg               (csr_tcfg),
    .diff_csr_tval               (csr_tval),
    .diff_csr_ticlr              (csr_ticlr),
    .diff_csr_llbctl             (csr_llbctl),
    .diff_csr_tlbrentry          (csr_tlbrentry),
    .diff_csr_dmw0               (csr_dmw0),
    .diff_csr_dmw1               (csr_dmw1),
    .diff_reg_0                  (reg_0),
    .diff_reg_1                  (reg_1),
    .diff_reg_2                  (reg_2),
    .diff_reg_3                  (reg_3),
    .diff_reg_4                  (reg_4),
    .diff_reg_5                  (reg_5),
    .diff_reg_6                  (reg_6),
    .diff_reg_7                  (reg_7),
    .diff_reg_8                  (reg_8),
    .diff_reg_9                  (reg_9),
    .diff_reg_10                 (reg_10),
    .diff_reg_11                 (reg_11),
    .diff_reg_12                 (reg_12),
    .diff_reg_13                 (reg_13),
    .diff_reg_14                 (reg_14),
    .diff_reg_15                 (reg_15),
    .diff_reg_16                 (reg_16),
    .diff_reg_17                 (reg_17),
    .diff_reg_18                 (reg_18),
    .diff_reg_19                 (reg_19),
    .diff_reg_20                 (reg_20),
    .diff_reg_21                 (reg_21),
    .diff_reg_22                 (reg_22),
    .diff_reg_23                 (reg_23),
    .diff_reg_24                 (reg_24),
    .diff_reg_25                 (reg_25),
    .diff_reg_26                 (reg_26),
    .diff_reg_27                 (reg_27),
    .diff_reg_28                 (reg_28),
    .diff_reg_29                 (reg_29),
    .diff_reg_30                 (reg_30),
    .diff_reg_31                 (reg_31),
    .axi_aw_ready                (awready),
    .axi_aw_valid                (awvalid),
    .axi_aw_payload_id              (awid   ),
    .axi_aw_payload_addr            (awaddr ),
    .axi_aw_payload_len             (awlen  ),
    .axi_aw_payload_size            (awsize ),
    .axi_aw_payload_burst           (awburst),
    .axi_aw_payload_lock            (awlock ),
    .axi_aw_payload_cache           (awcache),
    .axi_aw_payload_prot            (awprot ),
    .axi_w_ready                 (wready ),
    .axi_w_valid                 (wvalid ),
    .axi_w_payload_id               (wid    ),
    .axi_w_payload_data             (wdata  ),
    .axi_w_payload_strb             (wstrb  ),
    .axi_w_payload_last             (wlast  ),
    .axi_b_ready                 (bready ),
    .axi_b_valid                 (bvalid ),
    .axi_b_payload_id               (bid    ),
    .axi_b_payload_resp             (bresp  ),
    .axi_ar_ready                (arready),
    .axi_ar_valid                (arvalid),
    .axi_ar_payload_id              (arid   ),
    .axi_ar_payload_addr            (araddr ),
    .axi_ar_payload_len             (arlen  ),
    .axi_ar_payload_size            (arsize ),
    .axi_ar_payload_burst           (arburst),
    .axi_ar_payload_lock            (arlock ),
    .axi_ar_payload_cache           (arcache),
    .axi_ar_payload_prot            (arprot ),
    .axi_r_ready                 (rready ),
    .axi_r_valid                 (rvalid ),
    .axi_r_payload_id               (rid    ),
    .axi_r_payload_data             (rdata  ),
    .axi_r_payload_resp             (rresp  ),
    .axi_r_payload_last             (rlast  )
);

DifftestInstrCommit DifftestInstrCommit0(
    .clock              (aclk           ),
    .coreid             (0              ),
    .index              (0              ),
    .valid              (inst_0_valid),
    .pc                 (inst_0_pc),
    .instr              (inst_0_instr),
    .skip               (0              ),
    .is_TLBFILL         (inst_0_is_TLBFILL),
    .TLBFILL_index      (inst_0_TLBFILL_index),
    .is_CNTinst         (inst_0_is_CNTinst),
    .timer_64_value     (inst_0_timer_64_value),
    .wen                (inst_0_wen),
    .wdest              (inst_0_wdest),
    .wdata              (inst_0_wdata),
    .csr_rstat          (inst_0_csr_rstat),
    .csr_data           (inst_0_csr_data)
);
DifftestInstrCommit DifftestInstrCommit1(
    .clock              (aclk           ),
    .coreid             (0              ),
    .index              (1              ),
    .valid              (inst_1_valid),
    .pc                 (inst_1_pc),
    .instr              (inst_1_instr),
    .skip               (0              ),
    .is_TLBFILL         (inst_1_is_TLBFILL),
    .TLBFILL_index      (inst_1_TLBFILL_index),
    .is_CNTinst         (inst_1_is_CNTinst),
    .timer_64_value     (inst_1_timer_64_value),
    .wen                (inst_1_wen),
    .wdest              (inst_1_wdest),
    .wdata              (inst_1_wdata),
    .csr_rstat          (inst_1_csr_rstat),
    .csr_data           (inst_1_csr_data)
);
DifftestInstrCommit DifftestInstrCommit2(
    .clock              (aclk           ),
    .coreid             (0              ),
    .index              (2              ),
    .valid              (inst_2_valid),
    .pc                 (inst_2_pc),
    .instr              (inst_2_instr),
    .skip               (0              ),
    .is_TLBFILL         (inst_2_is_TLBFILL),
    .TLBFILL_index      (inst_2_TLBFILL_index),
    .is_CNTinst         (inst_2_is_CNTinst),
    .timer_64_value     (inst_2_timer_64_value),
    .wen                (inst_2_wen),
    .wdest              (inst_2_wdest),
    .wdata              (inst_2_wdata),
    .csr_rstat          (inst_2_csr_rstat),
    .csr_data           (inst_2_csr_data)
);

DifftestExcpEvent DifftestExcpEvent(
    .clock              (aclk           ),
    .coreid             (0              ),
    .excp_valid         (excp_excp_valid),
    .eret               (excp_eret),
    .intrNo             (csr_estat[12:2]),
    .cause              (excp_cause),
    .exceptionPC        (excp_exceptionPC),
    .exceptionInst      (excp_exceptionInst)
);

DifftestTrapEvent DifftestTrapEvent(
    .clock              (aclk           ),
    .coreid             (0              ),
    .valid              (0              ),
    .code               (0              ),
    .pc                 (0              ),
    .cycleCnt           (0              ),
    .instrCnt           (0              )
);

DifftestStoreEvent DifftestStoreEvent(
    .clock              (aclk           ),
    .coreid             (0              ),
    .index              (0              ),
    .valid              (store_valid),
    .storePAddr         (store_storePAddr),
    .storeVAddr         (store_storeVAddr),
    .storeData          (store_storeData)
);

DifftestLoadEvent DifftestLoadEvent(
    .clock              (aclk           ),
    .coreid             (0              ),
    .index              (0              ),
    .valid              (load_valid),
    .paddr              (load_paddr),
    .vaddr              (load_vaddr)
);

DifftestCSRRegState DifftestCSRRegState(
    .clock              (aclk               ),
    .coreid             (0                  ),
    .crmd               (csr_crmd),
    .prmd               (csr_prmd),
    .euen               (csr_euen),
    .ecfg               (csr_ecfg),
    .estat              (csr_estat),
    .era                (csr_era),
    .badv               (csr_badv),
    .eentry             (csr_eentry),
    .tlbidx             (csr_tlbidx),
    .tlbehi             (csr_tlbehi),
    .tlbelo0            (csr_tlbelo0),
    .tlbelo1            (csr_tlbelo1),
    .asid               (csr_asid),
    .pgdl               (csr_pgdl),
    .pgdh               (csr_pgdh),
    .save0              (csr_save0),
    .save1              (csr_save1),
    .save2              (csr_save2),
    .save3              (csr_save3),
    .tid                (csr_tid),
    .tcfg               (csr_tcfg),
    .tval               (csr_tval),
    .ticlr              (csr_ticlr),
    .llbctl             (csr_llbctl),
    .tlbrentry          (csr_tlbrentry),
    .dmw0               (csr_dmw0),
    .dmw1               (csr_dmw1)
);

DifftestGRegState DifftestGRegState(
    .clock              (aclk       ),
    .coreid             (0          ),
    .gpr_0              (reg_0),
    .gpr_1              (reg_1),
    .gpr_2              (reg_2),
    .gpr_3              (reg_3),
    .gpr_4              (reg_4),
    .gpr_5              (reg_5),
    .gpr_6              (reg_6),
    .gpr_7              (reg_7),
    .gpr_8              (reg_8),
    .gpr_9              (reg_9),
    .gpr_10             (reg_10),
    .gpr_11             (reg_11),
    .gpr_12             (reg_12),
    .gpr_13             (reg_13),
    .gpr_14             (reg_14),
    .gpr_15             (reg_15),
    .gpr_16             (reg_16),
    .gpr_17             (reg_17),
    .gpr_18             (reg_18),
    .gpr_19             (reg_19),
    .gpr_20             (reg_20),
    .gpr_21             (reg_21),
    .gpr_22             (reg_22),
    .gpr_23             (reg_23),
    .gpr_24             (reg_24),
    .gpr_25             (reg_25),
    .gpr_26             (reg_26),
    .gpr_27             (reg_27),
    .gpr_28             (reg_28),
    .gpr_29             (reg_29),
    .gpr_30             (reg_30),
    .gpr_31             (reg_31)
);

endmodule
