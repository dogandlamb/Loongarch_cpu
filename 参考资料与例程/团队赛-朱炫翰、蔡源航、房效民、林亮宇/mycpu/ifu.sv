`ifndef IFU_SV
`define IFU_SV
`include "bpu_defines.sv"
`include "frontend_defines.sv"
`include "core_defines.sv"
`include "tlb_defines.sv"
`include "mycpu.vh"


module ifu
    import core_defines::*;
    import frontend_defines::*;
    import bpu_defines::*;
    import tlb_types::*;
(
    //输入时钟和复位
    input  logic         clk,
    input  logic         reset,

    // 指令缓冲
    input  logic         IB_full_stall_i,  // IB满停顿请求
    output logic         pre_decoder_ready_go_o, // 指令准备完毕
    output logic [$clog2(FETCH_WIDTH+1)-1:0] instr_buffer_length_o,  // 时机指令宽度
    output instr_info_t  instr_buffer_o[FETCH_WIDTH], // 输出指令信息
    
    // Flush相关
    input logic backend_flush_i,        // 后端冲刷 和 后端分支重定向
    input logic frontend_redirect_i,    // 前端预测器重定向

    // 指令Cache
    output logic         inst_sram_req_o,
    output logic         inst_uncache_en_o,
    output logic [ADDR_WIDTH-1:0] inst_sram_paddr_o, 
    input  logic         inst_sram_addr_ok_i,
    input  logic         inst_sram_data_ok_i, 
    input  logic         [ICACHELINE_WIDTH-1: 0] inst_sram_rdata_i, // 128

    // FTQ接口
    input   ftq_block_t  ftq_block_i,  // FTQ预测块输入
    input   logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_block_id_i, // FTQ ID
    output  logic        ftq_accept_o,  // FTQ接受信号（可以认为是取指请求成功发送）

    // Predecoder Redirect
    output logic predecoder_redirect_o,
    output logic [ADDR_WIDTH-1:0] predecoder_redirect_target_o,
    output logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] predecoder_redirect_ftq_id_o,
    output logic predecoder_wrong_predict_o,

    // <- Frontend <- CSR regs CSR寄存器的信息通过Frontend接到ifu
    input  ifu_csr_t  csr_i,

    // <-> Frontend <-> TLB
    output inst_tlb_t tlb_o,
    input  tlb_inst_t tlb_i
);

/*变量声明*/
logic read_FTQ_advance;         // 能接收FTQ块
logic pre_IF_ready_go;          // 握手成功
logic pre_IF_valid;             // 当前发请求的指令是否有效
logic pre_IF_allow_in;          // 允许读入FTQ块
logic IF_ready_go;              // 指令取回
logic IF_allow_in;              // 进入IF表示等待返回指令
logic backend_flush_r;          // 用来寄存器flush处理状态，表示当前IF阶段正在等待指令返回
logic backend_flush_stop_req;   // 接到flush，当IF等待指令返回的时候，用这个标记来暂停取指令

// Predecoder
logic [FETCH_WIDTH-1:0] predecoder_imm_jump;
logic [FETCH_WIDTH-1:0] predecoder_isBranch;
logic [FETCH_WIDTH-1:0][ADDR_WIDTH-1:0] predecoder_jump_target;
logic [ADDR_WIDTH-1 :0] predecoder_wrong_predict_pc;
logic [$clog2(FETCH_WIDTH)-1:0] predecoder_redirect_index;
logic predecoder_redirect;
logic predecoder_mispredict;
logic predecoder_wrong_predict;

// read_FTQ 为了预测器重定向处理简便===============================================
    // 后面可以考虑吧地址翻译放在这个了流水级，不过当前用了VIPT技术其实问题不大
    // 同时避免关键路径延迟叠加吧，比方说如果读出来直接发取指请求，并且还要单周期完成地址翻译
    // 那岂不是FTQ更新延迟+tlb翻译延迟叠加在一起，会很影响频率
        // 地址翻译逻辑--------------------------------------------------------------
    logic  da_mode;
    logic  pg_mode;
    logic  inst_uncache_en;
    assign da_mode = csr_i.da && !csr_i.pg; // 直接地址翻译模式
    assign pg_mode = csr_i.pg && !csr_i.da; // 映射地址翻译模式
    // 直接映射配置窗口，如果映射到了窗口上，就进行直接映射地址翻译
    assign tlb_o.inst_vaddr = ftq_block_i.start_pc;
    assign tlb_o.dmw0_en = ((csr_i.dmw0[`DMW_PLV0] && csr_i.plv == 2'd0) 
                         || (csr_i.dmw0[`DMW_PLV3] && csr_i.plv == 2'd3)) 
                         && (tlb_o.inst_vaddr[31:29] == csr_i.dmw0[`DMW_VSEG]) 
                         && pg_mode;
    assign tlb_o.dmw1_en = ((csr_i.dmw1[`DMW_PLV0] && csr_i.plv == 2'd0) 
                         || (csr_i.dmw1[`DMW_PLV3] && csr_i.plv == 2'd3)) 
                         && (tlb_o.inst_vaddr[31:29] == csr_i.dmw1[`DMW_VSEG]) 
                         && pg_mode;
    assign tlb_o.inst_addr_trans_en = pg_mode && !tlb_o.dmw0_en && !tlb_o.dmw1_en;// 告诉addr_trans进行页表地址翻译
    assign inst_uncache_en = (da_mode && (csr_i.datf == 2'b0))            ||
                         (tlb_o.dmw0_en && (csr_i.dmw0[`DMW_MAT] == 2'b0))  ||
                         (tlb_o.dmw1_en && (csr_i.dmw1[`DMW_MAT] == 2'b0))  ||
                         (tlb_o.inst_addr_trans_en && (tlb_i.tlb_mat == 2'b0)) ;
                         // 指令Cache Uncache访问判断
    assign read_FTQ_advance = pre_IF_allow_in && ftq_block_i.valid; 
    assign ftq_accept_o = read_FTQ_advance;

// pre_if 读取基本块发送取指令请求=================================================

    /*
    整理一下pre_IF需要的数据和控制信号,就不写成结构体了
    pre_IF_valid
    pre_IF_pc
    pre_IF_ftq_block 当有一个握手请求发送之后，就把ftq_block_i缓存下来，同时接收到预测器重定向时清空
    tlb_o 根据虚拟地址以及csr配置生成的输出给TLB的信号
    tlb_i TLB查询后返回的信号
    csr_i 这条指令准备取指时csr的配置
    pre_IF_ex 该指令在pre_IF的异常标记
    pre_IF_excp_num 指令在pre_IF的异常编号
    */

    // pre_IF PC & pre_IF_ftq_block----------------------------------------------
    ftq_block_t pre_IF_ftq_block;
    tlb_inst_t  pre_IF_tlb;
    logic       pre_IF_inst_trans_en;
    logic       pre_IF_uncache_en;
    logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] pre_IF_ftq_id;
    logic [ADDR_WIDTH-1:0] pre_IF_pc;
    assign pre_IF_pc = pre_IF_ftq_block.start_pc; // 用来取指令的pc
    always_ff @(posedge clk) begin : pre_IF_update // 也可以改成把valid置零减少硬件开销
        if (reset) begin
            pre_IF_ftq_block <= 0;
            pre_IF_ftq_id <= 0;
            pre_IF_tlb <=0;
            pre_IF_inst_trans_en <= 0;
            pre_IF_uncache_en <= 0;
        end else if(backend_flush_i | predecoder_redirect_o) begin
            pre_IF_ftq_block <= 0;
            pre_IF_ftq_id <= 0;
            pre_IF_tlb <=0;
            pre_IF_inst_trans_en <= 0;
            pre_IF_uncache_en <= 0;
        end else if(read_FTQ_advance & frontend_redirect_i) begin
            pre_IF_ftq_block <= 0;
            pre_IF_ftq_id <= 0;
            pre_IF_tlb <=0;
            pre_IF_inst_trans_en <= 0;
            pre_IF_uncache_en <= 0;
        end else if (read_FTQ_advance) begin
            pre_IF_ftq_block <= ftq_block_i;
            pre_IF_ftq_id <= ftq_block_id_i;
            pre_IF_tlb <= tlb_i;
            pre_IF_inst_trans_en <= tlb_o.inst_addr_trans_en;
            pre_IF_uncache_en <= inst_uncache_en;
        end else if (~read_FTQ_advance && pre_IF_allow_in) begin
            pre_IF_ftq_block <= 0;
            pre_IF_ftq_id <= 0;
            pre_IF_tlb <=0;
            pre_IF_inst_trans_en <= 0;
            pre_IF_uncache_en <= 0;
        end
    end

    assign inst_uncache_en_o = pre_IF_uncache_en;
    assign inst_sram_paddr_o = {pre_IF_tlb.tlb_trans_tag,pre_IF_pc[11:0]};



    // pre-IF阶段异常逻辑----------------------------------------------------------
    /*发生在pre-IF阶段的异常有（按优先级排）：
    1.取指地址错例外 ADEF
    2.TLB重填例外 TLBR
    3.取指操作页无效例外 PIF
    4.页特权等级不合规例外 PPI*/
    // 异常类型
    logic  excp_adef,excp_tlbrefill_inst,excp_pif,excp_ppi;
    logic  excp_tlb; // 包括tlb重填例外、load操作页无效例外、store操作页无效例外、取指操作页无效例外、页修改例外、页特权等级不合规例外
    assign excp_adef            = (pre_IF_pc[1:0] != 2'b00);
    assign excp_tlbrefill_inst  = pre_IF_inst_trans_en && ~pre_IF_tlb.tlb_found;                // 需要进行页表地址翻译时，查找tlb没有匹配项时，报tlb重填例外
    assign excp_pif             = pre_IF_inst_trans_en &&  pre_IF_tlb.tlb_found && ~pre_IF_tlb.tlb_v; // 需要进行页表地址翻译时，找到匹配项，但是匹配项的v位为0，报取指操作页无效例外
    assign excp_ppi             = pre_IF_inst_trans_en &&  pre_IF_tlb.tlb_found &&  pre_IF_tlb.tlb_v && (csr_i.plv > pre_IF_tlb.tlb_plv); // 需要进行页表地址翻译时，找到匹配项且匹配项的v位为1，但是特权等级不符合
    assign excp_tlb             = excp_tlbrefill_inst | excp_pif | excp_ppi;
    // pre-IF阶段的异常信号
    logic        pre_IF_ex;
    logic  [3:0] pre_IF_excp_num;
    assign pre_IF_ex    = excp_adef | excp_tlb;
    assign pre_IF_excp_num = {excp_ppi, excp_pif, excp_tlbrefill_inst, excp_adef};

    // 发起访存请求逻辑--------------------------------------------------------------
    // 发送访存请求,当IF完成取指,并且指令缓冲未满时
    assign inst_sram_req_o             = IF_allow_in && pre_IF_valid && !backend_flush_stop_req && !pre_IF_ex && !predecoder_redirect_o; 
    // 只有输入FTQ块有效并且IF阶段没有指令的时候才能发起取指请求

    // 流水线握手逻辑-----------------------------------------------------------------
    // flush出现的当周期，req信号会拉低，此时pre_if不可能ready_go
    // 如果flush信号到来是IF有传输事务，那么backend_flush_r会拉高，此时也禁止发起请求
    // 直到IF传输事务完毕后，下个周期backend_flush_r拉低，允许重新发起请求，但是需要基本快有效
    // 如果flush到来是IF没有传输事务，那么当周期也禁止发起请求，因为FTQ在下个周期才会改变，当前ifu指针指向的块是错误的但是却有效
    // 再经过一个时钟周期，预测器向FTQ中ifu指针位移但是指向的块无效，再进过一个时钟预测器向其中填充有效块之后才会重新发起取指请求

    assign pre_IF_ready_go = (inst_sram_req_o && inst_sram_addr_ok_i) || pre_IF_ex; // 后面要考虑pre_IF出现异常的情况，不允许发出取指请求并且直接向下流
    assign pre_IF_valid    = ~reset && pre_IF_ftq_block.valid;          // 用来控制当前发起访存的指令是否有效,出现后端flush的时候是无效指令，但是不确定主预测器重定向的时候是不是无效指令
    assign pre_IF_allow_in = !pre_IF_valid || (IF_allow_in && pre_IF_ready_go);

// IF 等待Icache将指令返回========================================================

    // IF数据结构--------------------------------------------------------------------
    typedef struct packed {
        logic                                   data_valid;
        logic                                   uncached;       // 非缓存访问标志
        logic                                   excp;           // 异常标志
        logic [15:0]                            excp_num;       // 异常号
        ftq_block_t                             IF_ftq_block;   // 预测块
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0]   ftq_id;         // FTQ ID
        logic                                   icache_rvalid_r;// ICache响应有效状态
        logic [ICACHELINE_WIDTH-1:0]            icache_rdata_r; // ICache数据,两行总共256位
    } IF_t;
    IF_t IF_data;

    // IF读取完成逻辑-----------------------------------------------------------------
    logic IF_read_done;
    logic IF_data_valid;
    logic [$clog2(FRONTEND_FTQ_SIZE)-1:0]   IF_ftq_id;
    assign IF_ftq_id = IF_data.ftq_id;
    logic  IF_in_read_transaction;
    ftq_block_t IF_ftq_block;
    assign IF_data_valid = IF_data.data_valid;
    assign IF_ftq_block = IF_data.IF_ftq_block;
    assign IF_read_done = IF_data.icache_rvalid_r;
    assign IF_in_read_transaction = !IF_read_done && !IF_data.excp && IF_data.data_valid;   //数据有效，没有发生异常，并且没有读完数据

    // 流水线握手和IF阶段缓存写入逻辑--------------------------------------------------
    assign IF_ready_go    =  (IF_read_done && IF_data.data_valid || IF_data.excp) && !backend_flush_stop_req;   // 发生异常让指令能直接向下流，当然前提是当前没有处理悬空指令请求
    assign IF_allow_in    = !IF_data.data_valid || (IF_ready_go && ~IB_full_stall_i);

    always_ff  @(posedge clk) begin : IF_update
        if (reset) begin
            // IF_data <= 0;
            IF_data.data_valid      <= 0;
            IF_data.uncached        <= 0;
            IF_data.excp            <= 0;
            IF_data.excp_num        <= 0;
            IF_data.IF_ftq_block    <= 0;
            IF_data.ftq_id          <= 0;

        end else if(backend_flush_i | predecoder_redirect_o) begin
            // IF_data <= 0;
            IF_data.data_valid      <= 0;
            IF_data.uncached        <= 0;
            IF_data.excp            <= 0;
            IF_data.excp_num        <= 0;
            IF_data.IF_ftq_block    <= 0;
            IF_data.ftq_id          <= 0;

        end else if(IF_allow_in) begin          // IF数据返回
            IF_data.data_valid      <= pre_IF_ready_go;
            IF_data.uncached        <= inst_uncache_en_o;
            IF_data.excp            <= pre_IF_ex;
            IF_data.excp_num        <= {12'b0,pre_IF_excp_num};
            IF_data.IF_ftq_block    <= pre_IF_ftq_block;
            IF_data.ftq_id          <= pre_IF_ftq_id;
        end
    end

    // Cache返回数据处理逻辑---------------------------------------------------------
    
        always_ff @(posedge clk) begin : read_transaction
        if (reset || IF_allow_in && pre_IF_ready_go || backend_flush_i) begin
            // 复位,以及取指请求刚进入IF阶段时初始化所有寄存器
            IF_data.icache_rdata_r  <= '0; // 所有位清零
            IF_data.icache_rvalid_r <= 1'b0;
        end else if(inst_sram_data_ok_i && IF_data.data_valid) begin
            IF_data.icache_rdata_r    <= inst_sram_rdata_i;
            IF_data.icache_rvalid_r   <= 1'b1;
        end else begin
            IF_data.icache_rdata_r  <= IF_data.icache_rdata_r;
            IF_data.icache_rvalid_r <= IF_data.icache_rvalid_r;
        end
    end

// pre_decoder 分割指令并预译码，目前还没有做预译码=================================

    // 告知IB指令已经准备完毕
    assign pre_decoder_ready_go_o = IF_ready_go;
    // 实际上是利用最后一行数据读完的下一个周期read_done的时间来分割指令，不算是一个单独的流水级
    logic [FETCH_WIDTH-1:0][DATA_WIDTH-1:0] cacheline_combined;
    assign cacheline_combined = IF_data.icache_rdata_r;

    // 指令分割------------------------------------------------------------------------
    logic [FETCH_WIDTH-1:0][DATA_WIDTH-1:0] fetch_insts;
    logic [FETCH_WIDTH-1:0][ADDR_WIDTH-1:0] fetch_pcs;
    always_comb begin : inst_cut
        for (int i = 0; i < FETCH_WIDTH; i++) begin
            fetch_insts[i] = cacheline_combined[IF_data.IF_ftq_block.start_pc[3:2] + i];
            fetch_pcs[i]   = IF_data.IF_ftq_block.start_pc + i * 4; // 每条指令+4字节
        end
    end

    // 指令缓冲输出生成-----------------------------------------------------------------
    always_comb begin : inst_buffer_out
        for (int i = 0; i < FETCH_WIDTH; i++) begin
            instr_buffer_o[i] = 0; // 默认信息全部清零
            
            if (i < IF_data.IF_ftq_block.length) begin
                // 有效指令
                instr_buffer_o[i].valid         = i < instr_buffer_length_o ? 1 :0;
                // instr_buffer_o[i].pc            = IF_data.IF_ftq_block.start_pc + i * 4;
                instr_buffer_o[i].instr         = IF_data.excp ? 0 : fetch_insts[i]; // 异常时指令清零
                instr_buffer_o[i].ex            = IF_data.excp;
                instr_buffer_o[i].excp_num      = IF_data.excp_num;
                instr_buffer_o[i].ftq_id        = IF_data.ftq_id;
                instr_buffer_o[i].ftq_block_idx = i[1:0];
                
                // 块内最后一条指令标记
                if (i == IF_data.IF_ftq_block.length - 1) begin
                    instr_buffer_o[i].is_last_in_block = 1;
                    // 分支预测信息传递
                    instr_buffer_o[i].special_info.predicted_taken = IF_data.IF_ftq_block.predicted_taken;
                    instr_buffer_o[i].special_info.predict_valid   = IF_data.IF_ftq_block.predict_valid;
                end

                // 预解码器信息标记，这里i == predecoder_redirect_index还是有待商榷的
                // 换成instr_buffer_length_o试试看，当出现预译码重定向时，输出给指令缓冲的最后一条指令被打上标记
                if (i == (instr_buffer_length_o - 1)) begin
                    instr_buffer_o[i].special_info.predecoder_redirect = predecoder_redirect;   
                    // 需要注意如果出现了误预测，那么这条非跳转指令也会被打上这个标记，但是这条指令不会进入BU所以应该不会有影响
                end
            end
        end
    end

    assign instr_buffer_length_o = predecoder_redirect &&  predecoder_wrong_predict                                   ? IF_data.IF_ftq_block.length  :
                                   predecoder_redirect && (predecoder_redirect_index+1 < IF_data.IF_ftq_block.length) ? predecoder_redirect_index +1 : IF_data.IF_ftq_block.length;
    // 预译码--------------------------------------------------------------------
    
    normal_priority_encoder #(
        .WIDTH(FETCH_WIDTH)
    ) u_predecoder_uncondtional_index_encoder (
        .priority_vector(predecoder_imm_jump),
        .encoded_result (predecoder_redirect_index)
    );
    generate
        for (genvar i = 0; i < FETCH_WIDTH; i++) begin
            PreDecoder u_PreDecoder (
                .instr_i              (instr_buffer_o[i].instr),
                // .pc_i                 (instr_buffer_o[i].pc),
                .pc_i                 (fetch_pcs[i]),
                .isBranch             (predecoder_isBranch[i]),
                .isImmjump_o          (predecoder_imm_jump[i]),
                .jumpTargetAddr_o     (predecoder_jump_target[i])
            );
        end
    endgenerate

    // 先对错误预测指令进行特判
    // 如果给出了预测块，但是块中最后一条指令并不是跳转指令，这时候也拉起预译码器重定向，并且优先级比一般的重定向要高
    assign predecoder_wrong_predict =  pre_decoder_ready_go_o && !IF_data.excp
                                    && (IF_data.IF_ftq_block.predict_valid && IF_data.IF_ftq_block.predicted_taken)
                                    && !predecoder_isBranch[IF_data.IF_ftq_block.length-1];
    assign predecoder_wrong_predict_pc = fetch_pcs[IF_data.IF_ftq_block.length-1] + 4;

    // 注意如果强制跳转指令恰好是块中最后一条指令，需要判断此时主预测器有没有进行预测
    assign predecoder_mispredict = (IF_data.IF_ftq_block.length == predecoder_redirect_index +1) && !IF_data.IF_ftq_block.predicted_taken;

    always_comb begin
        predecoder_redirect = 1'b0;
        if(predecoder_wrong_predict && !IF_data.excp && IF_data.data_valid) begin
            predecoder_redirect = 1'b1;
        end
        else if(|predecoder_imm_jump && !IF_data.excp && IF_data.data_valid) begin
            if(predecoder_redirect_index +1 < IF_data.IF_ftq_block.length) predecoder_redirect = 1'b1; // 一般的情况，发现强制跳转指令不是块最后一条指令
            if(predecoder_mispredict)                                      predecoder_redirect = 1'b1; // 强制跳转指令是块最后一条指令，但是没有进行预测
        end
    end
    always_comb begin
        predecoder_redirect_o = predecoder_redirect && pre_decoder_ready_go_o && !IB_full_stall_i;
        predecoder_redirect_target_o = predecoder_wrong_predict ? predecoder_wrong_predict_pc : predecoder_jump_target[predecoder_redirect_index];
        predecoder_redirect_ftq_id_o = predecoder_redirect ? IF_data.ftq_id : 0;
        predecoder_wrong_predict_o = predecoder_wrong_predict;
    end

// flush处理逻辑==================================================================

    assign backend_flush_stop_req = backend_flush_i | backend_flush_r;
    always_ff @(posedge clk) begin : flush_state
        if(reset) begin
            backend_flush_r <= 1'b0;
        end else if(backend_flush_i && IF_in_read_transaction && !inst_sram_data_ok_i) begin // IF still in transaction
            backend_flush_r <= 1'b1; // 当前还在读事务
        end else if( backend_flush_r && inst_sram_data_ok_i) begin // IF read done and then send flush req
            backend_flush_r <= 1'b0;    // 因为收到flush之后IF所有的信息都无效了所以只能用Cache返回的信号（在flush期间Cache不受影响）
        end
    end


endmodule

`endif