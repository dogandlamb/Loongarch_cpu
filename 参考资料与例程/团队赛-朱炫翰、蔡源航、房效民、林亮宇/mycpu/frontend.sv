`include "bpu_defines.sv"
`include "frontend_defines.sv"
`include "core_defines.sv"
`include "tlb_defines.sv"
module frontend
    import core_defines::*;
    import frontend_defines::*;
    import bpu_defines::*;
    import tlb_types::*;
(
    input logic clk,
    input logic rst,

    // ICache
    output logic  inst_sram_req_o,
    output logic  inst_uncache_en_o,
    output logic  [ADDR_WIDTH-1:0]inst_sram_paddr_o, 
    input  logic  inst_sram_addr_ok_i,
    input  logic  inst_sram_data_ok_i, 
    input  logic  [ICACHELINE_WIDTH-1: 0] inst_sram_rdata_i,

    // 后端冲刷&重定向
    input  logic backend_redirect_i,
    input  logic [ADDR_WIDTH-1:0] backend_redirect_next_pc_i,
    input  logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] backend_redirect_ftq_id_i,
    input  logic backend_flush_i,
    input  logic [ADDR_WIDTH-1:0] backend_flush_next_pc_i,
    input  logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] backend_flush_ftq_id_i,

    // 后端提交
    input  logic [COMMIT_WIDTH-1:0] backend_commit_bitmask_i,
    input  logic [COMMIT_WIDTH-1:0] backend_commit_block_bitmask_i,
    input  logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] backend_commit_ftq_id_i,
    input  backend_commit_meta_t backend_commit_meta_i,

    // FTQ原数据更新
    input ftq_updata_t backend_ftq_updata_info,

    // 后端查询PC以及RAS栈的维护
    input  BU_ras_op_t  BU_ras_data,
    input  logic [ISSUE_WIDTH-1:0][$clog2(FRONTEND_FTQ_SIZE)-1:0] iss_query_id_i,
    input  logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ctrl_query_id_i,
    output logic [ADDR_WIDTH-1:0] bu_pc_query_o,
    output logic [ADDR_WIDTH-1:0] iss0_pc_query_o,
    output logic [ADDR_WIDTH-1:0] iss1_pc_query_o,
    output logic [ADDR_WIDTH-1:0] ctrl_pc_query_o,

    // 指令缓冲输出
    input  logic IB_full_stall_i,
    output logic pre_decoder_ready_go_o,
    output instr_info_t instr_buffer_o[FETCH_WIDTH],
    output logic [$clog2(FETCH_WIDTH+1)-1:0] instr_buffer_length_o,

    // CSR数据读入
    input  logic csr_pg,
    input  logic csr_da,
    input  logic [31:0]  csr_dmw0,
    input  logic [31:0]  csr_dmw1,
    input  logic [1 :0]  csr_plv,
    input  logic [1 :0]  csr_datf,

    // TLB数据读入
    output inst_tlb_t tlb_o,
    input  tlb_inst_t tlb_i
);

    // redirect & flush
    logic backend_flush;
    logic [ADDR_WIDTH-1:0] backend_flush_next_pc;
    logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] backend_flush_ftq_id;



    assign backend_flush = backend_flush_i | backend_redirect_i;
    assign backend_flush_next_pc = backend_flush_i ? backend_flush_next_pc_i : backend_redirect_next_pc_i;
    assign backend_flush_ftq_id = backend_flush_i ? backend_flush_ftq_id_i : backend_redirect_ftq_id_i;


    // 后端提交信号也改为时序接收，缩短关键路径

    logic main_redirect;
    logic [ADDR_WIDTH-1:0] pc, next_pc, seqc_pc, main_redirect_pc;
    assign seqc_pc = pc + 4 * base_ftq_block.length;

    // BPU
    ftq_block_t base_ftq_block;
    ftq_block_t main_ftq_block;
    bpu_ftq_meta_t bpu_to_ftq_info;
    ftq_bpu_meta_t ftq_to_bpu_info;
    bpu_ras_op_t bpu_ras_train_info;
    logic ras_to_bpu_ras_empty;
    logic [ADDR_WIDTH-1:0] pre_train_ras_top_addr;
    logic [ADDR_WIDTH-1:0] ras_pc_query,BU_call_addr;
    assign BU_call_addr = ras_pc_query + 4 * BU_ras_data.push_idx;

    // FTQ
    ftq_block_t ftq_ifu_block;
    logic ifu_frontend_redirect;
    logic ifu_to_ftq_accept;
    logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_to_ifu_id;
    logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] bu_query_id;
    assign bu_query_id = BU_ras_data.push_ftq_id;

    // IFU
    logic ifu_redirect;
    logic [ADDR_WIDTH-1:0] ifu_redirect_target;
    logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ifu_redirect_ftq_id;
    logic ifu_redirect_dirty;   // 出现分支误预测的时候拉高

    logic ftq_to_bpu_full, ftq_to_bpu_full_delay;

    always_ff @(posedge clk) begin
        ftq_to_bpu_full_delay <= ftq_to_bpu_full;
    end

    // PC 更新逻辑
    always_ff @(posedge clk) begin : pc_ff
        if (rst) begin
            pc <= 32'h1c000000;
        end else begin
            pc <= next_pc;
        end
    end
    always_comb begin : next_pc_comb
        if (backend_flush) begin
            next_pc = backend_flush_next_pc;
        end else if (ifu_redirect) begin
            next_pc = ifu_redirect_target;
        end else if (main_redirect) begin
            next_pc = main_redirect_pc;
        end else if (ftq_to_bpu_full_delay & ftq_to_bpu_full) begin
            next_pc = pc;
        end else begin
            next_pc = seqc_pc;
        end
    end

    bpu u_bpu (
        .clk                (clk),
        .rst                (rst),

        // 后端重定向&冲刷
        .backend_flush_i    (backend_flush | ifu_redirect),

        .pc_i               (pc),
        // FTQ
        .ftq_queue_full_i    (ftq_to_bpu_full),
        .ftq_base_pre_block_o(base_ftq_block),
        .ftq_main_pre_block_o(main_ftq_block),
        .to_ftq_bpu_info_o  (bpu_to_ftq_info),
        // Train
        .ftq_train_info_i   (ftq_to_bpu_info),

        // PC
        .main_redirect_o    (main_redirect),
        .main_redirect_pc_o (main_redirect_pc),

        // RAS提前训练
        .bpu_ras_train_info_o (bpu_ras_train_info),
        .pre_train_ras_top_i  (pre_train_ras_top_addr),
        .ras_empty_i           (ras_to_bpu_ras_empty)

    );

    ftq u_ftq (
        .clk(clk),
        .rst(rst),

        // 冲刷
        .backend_flush_i        (backend_flush),
        .backend_flush_ftq_id_i (backend_flush_ftq_id),

        // 重定向
        .ifu_redirect_i         (ifu_redirect),
        .ifu_redirect_ftq_id_i  (ifu_redirect_ftq_id),
        .ifu_redirect_dirty_i   (ifu_redirect_dirty),

        // BPU
        .bpu_base_ftq_block_i   (base_ftq_block),
        .bpu_main_ftq_block_i   (main_ftq_block),
        .bpu_to_ftq_info_i      (bpu_to_ftq_info),
        .main_redirect_i        (main_redirect),
        .to_bpu_full_o          (ftq_to_bpu_full),
        .to_bpu_train_info_o    (ftq_to_bpu_info),

        // 后端提交
        .backend_commit_i               (backend_commit_bitmask_i),
        .backend_commit_ftq_id_i        (backend_commit_ftq_id_i),
        
        .backend_branch_commit_i        (backend_commit_block_bitmask_i),
        .backend_commit_branch_info_i   (backend_commit_meta_i),


        .ftq_updata_info_i(backend_ftq_updata_info),
        
        // 后端查询PC端口
        .bu_query_id_i          (bu_query_id),
        .iss_query_id_i         (iss_query_id_i),
        .ctrl_query_id_i        (ctrl_query_id_i),
        .bu_pc_query_o          (bu_pc_query_o),
        .ras_pc_query_o         (ras_pc_query),
        .iss0_pc_query_o        (iss0_pc_query_o),
        .iss1_pc_query_o        (iss1_pc_query_o),
        .ctrl_pc_query_o        (ctrl_pc_query_o),

        // IFU
        .to_ifu_block_o         (ftq_ifu_block),
        .to_ifu_redirect_o      (ifu_frontend_redirect),
        .to_ifu_id_o            (ftq_to_ifu_id),
        .ifu_accept_block_i     (ifu_to_ftq_accept)
    );

    // 线已经接好了但是冲刷和重定向逻辑还没写
    ifu u_ifu (
        .clk(clk),
        .reset(rst),

        // 冲刷&重定向
        .backend_flush_i            (backend_flush              ),
        .frontend_redirect_i        (ifu_frontend_redirect      ),// 预测器发出重定向

        // FTQ
        .ftq_block_i                (ftq_ifu_block              ),
        .ftq_block_id_i             (ftq_to_ifu_id                 ),
        .ftq_accept_o               (ifu_to_ftq_accept             ),

        .csr_i({csr_pg, csr_da, csr_dmw0, csr_dmw1, csr_plv, csr_datf}),
        .tlb_i                      (tlb_i                      ),
        .tlb_o                      (tlb_o                      ),

        // 指令Cache
        .inst_sram_req_o            (inst_sram_req_o            ),
        .inst_uncache_en_o          (inst_uncache_en_o          ),
        .inst_sram_paddr_o          (inst_sram_paddr_o          ),
        .inst_sram_addr_ok_i        (inst_sram_addr_ok_i        ),
        .inst_sram_data_ok_i        (inst_sram_data_ok_i        ),
        .inst_sram_rdata_i          (inst_sram_rdata_i          ),

        // 指令缓冲
        .IB_full_stall_i            (IB_full_stall_i            ),
        .pre_decoder_ready_go_o     (pre_decoder_ready_go_o     ),
        .instr_buffer_o             (instr_buffer_o             ),
        .instr_buffer_length_o      (instr_buffer_length_o      ),
        // 预解码器重定向
        .predecoder_redirect_o          (ifu_redirect),
        .predecoder_redirect_target_o   (ifu_redirect_target),
        .predecoder_redirect_ftq_id_o   (ifu_redirect_ftq_id),
        .predecoder_wrong_predict_o     (ifu_redirect_dirty)
    );

    ras_pre_train u_ras_pre_train(
    .clk(clk),
    .rst(rst),

    .backend_redirect_i(backend_redirect_i), // 恢复的标志
    .backend_flush_i(backend_flush_i),    // 栈清空标志

    // BPU
    .bpu_pre_train_info_i(bpu_ras_train_info),
    .pre_train_top_addr_o(pre_train_ras_top_addr),
    .to_bpu_ras_empty(ras_to_bpu_ras_empty),

    // Backend BU
    .BU_train_info_i(BU_ras_data),
    .BU_call_addr_i(BU_call_addr)
    );


endmodule