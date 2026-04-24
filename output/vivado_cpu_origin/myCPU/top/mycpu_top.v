// ============================================================
// 顶层模块：mycpu_top
// ------------------------------------------------------------
// 功能：
// - 组织 IF/ID/EXE/MEM/WB 五级流水，连接各级端口模块与级间流水寄存器。
// - 统一管理阻塞与冲刷：RAW 冲突阻塞 + 分支重定向冲刷。
// - 流水与 sram_AXI_bridge 相连（类 SRAM 握手时序），桥接为单 AXI4 主端口接 SoC。
//
// 端口（与 output/vivado_cpu_origin/soc_verify/soc_axi/rtl/soc_lite_top.v 中 u_cpu 一致）：
// - aclk / aresetn：CPU 时钟与低有效异步复位（内部同步为高有效 reset）。
// - AXI4 Master：AR/R、AW/W/B 由 sram_AXI_bridge 驱动。
// - debug_wb_*：WB 提交调试（与 func 测试参考 trace 对齐）。
//
// AXI 由 sram_AXI_bridge 驱动（单次突发、arid/awid 区分取指与数据）。
// ============================================================
`timescale 1ns / 1ps
`include "../common/cpu_defs.vh"

module mycpu_top(
    input  wire        aclk,
    input  wire        aresetn,

    // AR —— 读地址（Master → Slave）
    output wire [3:0]  arid,
    output wire [31:0] araddr,
    output wire [7:0]  arlen,
    output wire [2:0]  arsize,
    output wire [1:0]  arburst,
    output wire [1:0]  arlock,
    output wire [3:0]  arcache,
    output wire [2:0]  arprot,
    output wire        arvalid,
    input  wire        arready,

    // R —— 读数据（Slave → Master）
    input  wire [3:0]  rid,
    input  wire [31:0] rdata,
    input  wire [1:0]  rresp,
    input  wire        rlast,
    input  wire        rvalid,
    output wire        rready,

    // AW —— 写地址（Master → Slave）
    output wire [3:0]  awid,
    output wire [31:0] awaddr,
    output wire [7:0]  awlen,
    output wire [2:0]  awsize,
    output wire [1:0]  awburst,
    output wire [1:0]  awlock,
    output wire [3:0]  awcache,
    output wire [2:0]  awprot,
    output wire        awvalid,
    input  wire        awready,

    // W —— 写数据（Master → Slave）
    output wire [3:0]  wid,
    output wire [31:0] wdata,
    output wire [3:0]  wstrb,
    output wire        wlast,
    output wire        wvalid,
    input  wire        wready,

    // B —— 写响应（Slave → Master）
    input  wire [3:0]  bid,
    input  wire [1:0]  bresp,
    input  wire        bvalid,
    output wire        bready,

    output wire [31:0] debug_wb_pc,
    output wire [3:0]  debug_wb_rf_we,
    output wire [4:0]  debug_wb_rf_wnum,
    output wire [31:0] debug_wb_rf_wdata
);

    // 与原有内部逻辑一致：时钟与复位的别名
    wire clk    = aclk;
    wire resetn = aresetn;

    // 同步高有效复位（resetn 翻转得到）
    reg reset;
    always @(posedge clk) reset <= ~resetn;

    // 顶层保留全局 valid（当前不直接参与流水控制，也就是现在还没用到）
    reg valid;
    always @(posedge clk) begin
        if (reset) valid <= 1'b0;
        else       valid <= 1'b1;
    end

    // IF/MEM ↔ mmu
    wire [31:0] inst_rdata_2IF; //?
    wire [31:0] data_rdata_2MEM;//?
    wire        inst_r_complete;
    wire        cache_inst_r_complete;
    wire        cache_data_r_complete;
    wire        cache_data_w_complete;
    wire        mmu_data_tlb_excp_cancel;
    wire [31:0] pc_2ID_from_bram; // pc_2ID_from_bram 不应该经过 mmu。它是 icache 返回的“与指令对齐的 PC”，语义在 IF/cache 通路。
    wire        adef_valid_2IF; // axi_if_busy 也不属于 mmu，它是 cache/axi 忙信号聚合（icache_stall_if 与 dcache_stall_mem）。
    wire        data_w_wrong;
    wire        data_r_wrong;
    wire        inst_r_wrong;
    wire        axi_if_busy;

    // 前递选择信号（来自 conflict_handle -> forward_deliver）
    wire FD_EXE_2rs1_sig;
    wire FD_MEM_2rs1_sig;
    wire FD_WB_2rs1_sig;
    wire FD_EXE_2rs2_sig;
    wire FD_MEM_2rs2_sig;
    wire FD_WB_2rs2_sig;

    // 流水线控制信号:阻塞、冲刷
    wire        stall;           // 顶层统一阻塞信号（当前等价于 block_sig）
    wire        pc_stall;        // 由 npc 输出：阻塞且本拍不跳转、或 IF/ID 不可收且非跳转时保持 PC
    wire        hit_exe_rs1;     // 执行阶段冲突1
    wire        hit_mem_rs1;     // 访存阶段冲突1
    wire        hit_wb_rs1;      // 写回阶段冲突1
    wire        hit_exe_rs2;     // 执行阶段冲突2
    wire        hit_mem_rs2;     // 访存阶段冲突2
    wire        hit_wb_rs2;      // 写回阶段冲突2
    wire        RAW_hazard;      // conflict_handle 给出的 RAW 冲突检测结果
    wire        block_sig;       // 送入 pipeline_controller/npc 的阻塞主信号
    wire        cancel_sig;      // 冲刷：分支命中或 csr_flush（conflict_handle 内相或）

    // CSR相关输出信号
    wire        csr_flush_pipeline;   // 异常或 ERTN（csr_exception_commit_handler → conflict_handle.csr_flush）
    wire [31:0] csr_next_pc;          // CSR → npc：EENTRY 或 ERTN的返回地址
    wire [1:0]  csr_redirect;         // CSR → npc：区分csr_next_pc类型的标志位信号，给npc仲裁，类型有`CSR_REDIRECT_EX、`CSR_REDIRECT_ERTN、`CSR_REDIRECT_NONE，具体看宏定义
    wire        csr_has_int;          // CSR 中断附着（后续接 ID）
    wire [31:0] csr_rvalue_unused;    // CSR 读返回值（后续接 WB csr 读）
    wire [31:0] csr_tid_to_exe;       // RDCNTID 等：CSR 模块输出的 TID
    wire        csr_crmd_da;
    wire        csr_crmd_pg;
    wire [1:0]  csr_crmd_datf;
    wire [1:0]  csr_crmd_datm;
    wire [1:0]  csr_crmd_plv;
    wire [9:0]  csr_asid;
    wire [31:0] csr_tlbidx;
    wire [31:0] csr_tlbehi;
    wire [31:0] csr_tlbelo0;
    wire [31:0] csr_tlbelo1;
    wire [31:0] csr_dmw0;
    wire [31:0] csr_dmw1;
    wire [7:0]  csr_estat_ecode;

    // 输入CSR的相关信号
    // TLB -> CSR
    wire [31:0] tlbrd_tlbidx;
    wire [31:0] tlbrd_tlbehi;
    wire [31:0] tlbrd_tlbelo0;
    wire [31:0] tlbrd_tlbelo1;
    wire [9:0]  tlbrd_asid;
    wire        tlbsrch_found;
    wire [3:0]  tlbsrch_index;

    // (WB提交cacop->) cache_control_unit->cache
    wire        icache_cacop_en;
    wire [1:0]  icache_cacop_op;
    wire [31:0] icache_cacop_addr;
    wire [1:0]  icache_cacop_mat;
    wire        dcache_cacop_en;
    wire [1:0]  dcache_cacop_op;
    wire [31:0] dcache_cacop_addr;
    wire [1:0]  dcache_cacop_mat;
    wire        wb_cache_cacop_valid;
    wire        wb_cache_ibar_valid;
    wire [1:0]  wb_cache_cacop_op;
    wire [31:0] wb_cache_cacop_addr;
    wire [1:0]  wb_cache_cacop_mat;
    wire [4:0]  wb_cache_cacop_cd;


    wire        mmu_inst_req; // mmu -> icache
    wire [31:0] mmu_inst_paddr; // if_pc 和 tlb_paddr 都接 mmu_inst_paddr,语义上是重复输入但不冲突。当前 tlb_valid 固定 1，tlb_paddr 等价于 if_pc。这是接口保留型设计，便于未来切换到 cache 内部再做地址选择时不改接口。

    wire        mmu_inst_adef; // 接入 IF 异常输入链路

    wire        mmu_inst_tlbr; // ?
    wire        mmu_inst_pif; // ?
    wire        mmu_inst_ppi; // ?

    wire        mmu_data_re;
    wire        mmu_data_we;
    wire [31:0] mmu_data_paddr_r; // mmu_data_paddr_r 与 mmu_data_paddr_w 在 dcache 里都等于同一个 tlbm_data_paddr,为后续扩展保留接口
    wire [31:0] mmu_data_paddr_w; 
    wire [31:0] mmu_data_wdata; // mmu -> dcache
    wire [3:0]  mmu_data_wstrb;

    wire        mmu_data_tlbr;// mmu_data_tlbr/pil/pis/ppi/pme通过 data_tlb_ex_vec 并入 exe_tlb_ex_valid_to_mem
    wire        mmu_data_pil;
    wire        mmu_data_pis;
    wire        mmu_data_ppi;
    wire        mmu_data_pme;
    wire [1:0]  mmu_inst_mat; // mmu -> icache
    wire [1:0]  mmu_data_mat; // mmu -> dcache

    // cache -> if/mem
    wire        icache_if_addr_ok; // 没用到，保留接口
    wire        icache_if_data_ok; // 没用到，保留接口
    wire [31:0] icache_if_pc;
    wire [31:0] icache_if_data;
    wire        icache_stall_if;
    wire        dcache_mem_addr_ok; // ?
    wire        dcache_mem_data_ok;
    wire [31:0] dcache_mem_rdata;
    wire        dcache_stall_mem;
    wire        icache_tlb_excp_cancel_req;
    wire        dcache_tlb_excp_cancel_req;
    wire        dcache_sc_cancel_req; // 暂时还没用到，赋给常值
    wire [4:0]  dcache_preld_hint; // 暂时还没用到，赋给常值
    wire        dcache_preld_en; // 暂时还没用到，赋给常值

    // cache <-> axi转接桥
    wire        axi_ic_rd_req;
    wire [2:0]  axi_ic_rd_type;
    wire [31:0] axi_ic_rd_addr;
    wire        axi_ic_rd_rdy;
    wire        axi_ic_ret_valid;
    wire        axi_ic_ret_last;
    wire [127:0] axi_ic_ret_data;
    wire        axi_dc_rd_req;
    wire [2:0]  axi_dc_rd_type;
    wire [31:0] axi_dc_rd_addr;
    wire        axi_dc_rd_rdy;
    wire        axi_dc_ret_valid;
    wire        axi_dc_ret_last;
    wire [127:0] axi_dc_ret_data;
    wire        axi_dc_wr_req;
    wire [2:0]  axi_dc_wr_type;
    wire [31:0] axi_dc_wr_addr;
    wire [15:0] axi_dc_wr_strb;
    wire [127:0] axi_dc_wr_data;
    wire        axi_dc_wr_rdy;

    // axi转接桥 <-> top的顶层接口
    wire        axi_awvalid_line;
    wire [31:0] axi_awaddr_line;
    wire [2:0]  axi_awburst_line;
    wire [3:0]  axi_awlen_line;
    wire [2:0]  axi_awsize_line;
    wire        axi_wvalid_line;
    wire [31:0] axi_wdata_line;
    wire [3:0]  axi_wstrb_line;
    wire        axi_wlast_line;
    wire        axi_bready_line;
    wire        axi_arvalid_line;
    wire [31:0] axi_araddr_line;
    wire [2:0]  axi_arburst_line;
    wire [3:0]  axi_arlen_line;
    wire [2:0]  axi_arsize_line;
    wire        axi_rready_line;

    // tlb与mmu的交互信号
    wire [31:0] tlbm_inst_paddr;
    wire [31:0] tlbm_data_paddr;
    wire [1:0]  tlbm_inst_mat;
    wire [1:0]  tlbm_data_mat;
    wire        tlbm_inst_ex_tlbr;
    wire        tlbm_inst_ex_pif;
    wire        tlbm_inst_ex_ppi;
    wire        tlbm_data_ex_tlbr;
    wire        tlbm_data_ex_pil;
    wire        tlbm_data_ex_pis;
    wire        tlbm_data_ex_ppi;
    wire        tlbm_data_ex_pme;


    //------------------------------------------------------------------
    // IF
    //------------------------------------------------------------------
    wire [31:0] pc;              // 当前取指 PC（pc 模块输出）
    wire [31:0] nextpc;          // npc 计算得到的下一拍 PC
    wire [31:0] pc_exe;          // EXE 级当前指令 PC（用于分支重定向）

    pc u_pc(
        .clk    (clk),
        .reset  (reset),
        .stall  (pc_stall),
        .nextpc (nextpc),
        .pc     (pc)
    );

    wire        IF_readyGo;      // IF 阶段就绪
    wire        IF_allowIn;      // IF 阶段允许接收（当前 IFport 常 1）

    wire [31:0] pc_2ram_data_controller;  // IF 当前请求 PC
    wire [31:0] inst_fromIF;              // IF 输出指令（对齐PC）
    wire [31:0] pc_fromIF;                // IF 输出 PC（对齐inst）
    wire        adef_valid_req_fromIF;
    wire        if_is_CACOP;
    wire        if_adef_to_ifid;          // IF输出到IF_ID_reg的地址未对齐异常信号ADEF
    wire        if_exception_to_ifid;     // IF输出到IF_ID_reg的异常有效信号EXCEPTION
    wire [`TLB_EX_NUM-1:0] if_tlb_ex_valid_to_ifid;
    wire [31:0]            if_tlb_vaddr_to_ifid;
    wire        adef_ifid_to_id;          // IF_ID_reg输出到ID的地址未对齐异常信号ADEF
    wire        exception_ifid_to_id;     // IF_ID_reg输出到ID的异常有效信号EXCEPTION
    wire        IF_refetch_tag;           // pipeline controller 输出给 IF/ID 的重取标志
    wire        refetch_tag_ifid_to_id;
    wire [`TLB_EX_NUM-1:0] ifid_tlb_ex_valid_to_id;
    wire [31:0]            ifid_tlb_vaddr_to_id;

    wire        IF_valid;                 // IF 阶段有效位（controller 输出）
    wire        IF_ID_reg_valid;          // IF_ID_reg 输入 valid
    wire        IF_ID_reg_allowIn;        // IF_ID_reg 允许写入

    IFport u_IFport(
        .clk                (clk),
        .reset              (reset),
        .valid              (IF_valid),
        .pc_req_in          (pc),                      // 本拍发往 BRAM 的请求 PC（原pc1）
        .inst_in            (inst_rdata_2IF),
        .pc_inst_in         (pc_2ID_from_bram),        // 与返回指令对齐的 PC（原pc2）
        .redirect_pc_in     (nextpc),
        .inst_valid_in      (inst_r_complete),
        .cancel_in          (cancel_sig),
        .downstream_allowIn (IF_ID_reg_allowIn),
        .readyGo            (IF_readyGo),
        .allowIn            (IF_allowIn),
        .pc_req_out         (pc_2ram_data_controller),    // 发往bram_data_stream_controller的请求 PC
        .inst_out           (inst_fromIF),                // 送 IF_ID_reg 的指令
        .pc_inst_out        (pc_fromIF),
        .tlb_ex_valid_out   (if_tlb_ex_valid_to_ifid),
        .tlb_vaddr_out      (if_tlb_vaddr_to_ifid),
        .adef_valid_req_out (adef_valid_req_fromIF),
        .adef_valid_in      (adef_valid_2IF | mmu_inst_adef),
        .tlb_ex_valid_in    ({mmu_inst_tlbr, mmu_inst_pif, mmu_inst_ppi, 3'b0}),
        .adef_valid_out     (if_adef_to_ifid),
        .exception_valid    (if_exception_to_ifid),
        .if_is_CACOP        (if_is_CACOP)
    );

    wire [31:0] inst_2ID;        // IF_ID_reg 输出到 ID 的指令
    wire [31:0] pc_2ID;          // IF_ID_reg 输出到 ID 的 PC

    IF_ID_reg u_IF_ID_reg(
        .clk                   (clk),
        .reset                 (reset),
        .cancel_sig            (cancel_sig),
        .valid                 (IF_ID_reg_valid),
        .readyGo               (IF_readyGo),
        .allowIn               (IF_ID_reg_allowIn),
        .pc_in                 (pc_fromIF),
        .inst_in               (inst_fromIF),
        .adef_valid_in         (if_adef_to_ifid),
        .exception_valid_in    (if_exception_to_ifid),
        .refetch_tag_in        (IF_refetch_tag),
        .tlb_ex_valid_in       (if_tlb_ex_valid_to_ifid),
        .tlb_vaddr_in          (if_tlb_vaddr_to_ifid),
        .inst_out              (inst_2ID),
        .pc_out                (pc_2ID),
        .adef_valid_out        (adef_ifid_to_id),
        .exception_valid_out   (exception_ifid_to_id),
        .refetch_tag_out       (refetch_tag_ifid_to_id),
        .tlb_ex_valid_out      (ifid_tlb_ex_valid_to_id),
        .tlb_vaddr_out         (ifid_tlb_vaddr_to_id)
    );

    //------------------------------------------------------------------
    // ID
    //------------------------------------------------------------------
    wire [4:0]  rf_raddr1;       // regfile 读端口1地址（来自 IDport）
    wire [4:0]  rf_raddr2;       // regfile 读端口2地址（来自 IDport）

    wire [31:0] rf_rdata1;       // regfile 读端口1数据
    wire [31:0] rf_rdata2;       // regfile 读端口2数据

    wire        ID_readyGo;      // ID 阶段就绪
    wire        ID_allowIn;      // ID 阶段允许接收
    wire        ID_valid;        // ID 阶段有效位
    wire [4:0]  id_src1_addr;    // IDport 输出读寄存器地址，与 rf_raddr1 直连
    wire [4:0]  id_src2_addr;    // 同上，rf_raddr2
    wire [4:0]  wb_reg_addr_fromID;// ID 生成的目的寄存器号
    wire [31:0] alu_src1_fromID; // ID 生成的 EXE 源操作数1
    wire [31:0] alu_src2_fromID; // ID 生成的 EXE 源操作数2
    wire [31:0] id_pc_fromID;    // ID 透传 PC
    wire [31:0] br_imm_fromID;   // ID 生成的分支偏移
    wire [`ALU_OP_NUM-1:0] alu_op_fromID;   // ID 生成 ALU 操作码
    wire [`BR_OP_NUM-1:0]  br_op_fromID;    // ID 生成分支操作码
    wire [`MEM_OP_NUM-1:0] mem_op_fromID;   // ID 生成访存操作码
    wire [31:0] mem_wdata_fromID;// ID 输出 store 写数据
    wire        wb_op_fromID;    // ID 输出写回使能
    wire [`CSR_OP_NUM-1:0] csr_op_fromID;
    wire [11:0]            csr_num_fromID;
    wire [31:0]            csr_wmask_fromID;
    wire [31:0]            csr_wvalue_fromID;
    wire [`TLB_OP_NUM-1:0] tlb_op_fromID;
    wire [9:0]             invtlb_asid_fromID;
    wire [18:0]            invtlb_vpn_fromID;
    wire                   ertn_op_fromID;
    wire                   sys_valid_fromID;
    wire                   brk_valid_fromID;
    wire                   ine_valid_fromID;
    wire [`WB_SRC_NUM-1:0] wb_src_op_fromID;
    wire                   adef_valid_fromID;
    wire [31:0]            if_vaddr_fromID;
    wire                   int_valid_fromID;
    wire                   exception_valid_fromID;
    wire [`TLB_EX_NUM-1:0] tlb_ex_valid_fromID;
    wire [31:0]            tlb_vaddr_fromID;
    wire                   id_is_CACOP;

    wire        id_inst_cacop;
    wire        id_inst_ibar;
    wire [1:0]  id_cacop_op;
    wire [31:0] id_cacop_addr;
    wire [1:0]  id_cacop_mat;
    wire [4:0]  id_cacop_cd;

    //由前递模块返回的读取数据，可能为寄存器读取或者前递的数据
    wire [31:0] ID_src1_rdata;
    wire [31:0] ID_src2_rdata;

    IDport u_IDport(
        .reset      (reset),
        .valid      (ID_valid),
        .stall      (stall),
        .inst       (inst_2ID),
        .pc_in      (pc_2ID),
        .adef_valid_in      (adef_ifid_to_id),
        .has_int            (csr_has_int),
        .exception_valid_in (exception_ifid_to_id),
        .tlb_ex_valid_in    (ifid_tlb_ex_valid_to_id),
        .tlb_vaddr_in       (ifid_tlb_vaddr_to_id),
        .src1_rdata (ID_src1_rdata),
        .src2_rdata (ID_src2_rdata),
        .allowIn    (ID_allowIn),
        .readyGo    (ID_readyGo),
        .src1_addr  (id_src1_addr),
        .src2_addr  (id_src2_addr),
        .wb_reg_addr(wb_reg_addr_fromID),
        .alu_src1   (alu_src1_fromID),
        .alu_src2   (alu_src2_fromID),
        .pc_out     (id_pc_fromID),
        .br_imm     (br_imm_fromID),
        .alu_op     (alu_op_fromID),
        .br_op      (br_op_fromID),
        .mem_op     (mem_op_fromID),
        .mem_wdata  (mem_wdata_fromID),
        .wb_op      (wb_op_fromID),
        .csr_op     (csr_op_fromID),
        .csr_num    (csr_num_fromID),
        .csr_wmask  (csr_wmask_fromID),
        .csr_wvalue (csr_wvalue_fromID),
        .ertn_op    (ertn_op_fromID),
        .tlb_op     (tlb_op_fromID),
        .invtlb_asid(invtlb_asid_fromID),
        .invtlb_vpn (invtlb_vpn_fromID),
        .inst_cacop (id_inst_cacop),
        .inst_ibar  (id_inst_ibar),
        .cacop_op   (id_cacop_op),
        .cacop_addr (id_cacop_addr),
        .cacop_mat  (id_cacop_mat),
        .cacop_cd   (id_cacop_cd),
        .sys_valid  (sys_valid_fromID),
        .brk_valid  (brk_valid_fromID),
        .ine_valid  (ine_valid_fromID),
        .wb_src_op  (wb_src_op_fromID),
        .adef_valid (adef_valid_fromID),
        .if_vaddr   (if_vaddr_fromID),
        .int_valid  (int_valid_fromID),
        .exception_valid (exception_valid_fromID),
        .tlb_ex_valid (tlb_ex_valid_fromID),
        .tlb_vaddr   (tlb_vaddr_fromID),
        .id_is_CACOP  (id_is_CACOP)
    );

    // IDport 内部通过 get_reg_read_addr 生成读地址，直接驱动 regfile 读端口
    assign rf_raddr1 = id_src1_addr;
    assign rf_raddr2 = id_src2_addr;

    // cache_control_unit：仅由WB阶段已提交的维护指令统一驱动ICache/DCache
    cache_control_unit u_cache_control_unit(
        .clk            (clk),
        .resetn         (resetn),
        .wb_valid       (WB_valid),
        .wb_inst_cacop  (wb_cache_cacop_valid),
        .wb_inst_ibar   (wb_cache_ibar_valid),
        .wb_cacop_op    (wb_cache_cacop_op),
        .wb_cacop_addr  (wb_cache_cacop_addr),
        .wb_cacop_mat   (wb_cache_cacop_mat),
        .wb_cacop_cd    (wb_cache_cacop_cd),
        .icache_cacop_en (icache_cacop_en),
        .icache_cacop_op (icache_cacop_op),
        .icache_cacop_addr (icache_cacop_addr),
        .icache_cacop_mat (icache_cacop_mat),
        .dcache_cacop_en (dcache_cacop_en),
        .dcache_cacop_op (dcache_cacop_op),
        .dcache_cacop_addr (dcache_cacop_addr),
        .dcache_cacop_mat (dcache_cacop_mat)
    );

    wire        ID_EXE_reg_valid;       // ID_EXE_reg 输入 valid
    wire        ID_EXE_reg_allowIn;     // ID_EXE_reg 允许写入
    wire [4:0]  wb_reg_addr_2EXE;       // ID_EXE_reg 输出目的寄存器号
    wire [31:0] alu_src1_2EXE;          // ID_EXE_reg 输出 EXE 源1
    wire [31:0] alu_src2_2EXE;          // ID_EXE_reg 输出 EXE 源2
    wire [31:0] br_imm_2EXE;            // ID_EXE_reg 输出分支偏移
    wire [`ALU_OP_NUM-1:0] alu_op_2EXE; // ID_EXE_reg 输出 ALU 操作码
    wire [31:0] mem_wdata_2EXE;         // ID_EXE_reg 输出 store 数据
    wire [`BR_OP_NUM-1:0]  br_op_2EXE;  // ID_EXE_reg 输出分支控制
    wire [`MEM_OP_NUM-1:0] mem_op_2EXE; // ID_EXE_reg 输出访存控制
    wire        wb_op_2EXE;             // ID_EXE_reg 输出写回使能
    wire [`CSR_OP_NUM-1:0] csr_op_2EXE;
    wire [11:0]            csr_num_2EXE;
    wire [31:0]            csr_wmask_2EXE;
    wire [31:0]            csr_wvalue_2EXE;
    wire [`TLB_OP_NUM-1:0] tlb_op_2EXE;
    wire [9:0]             invtlb_asid_2EXE;
    wire [18:0]            invtlb_vpn_2EXE;
    wire [`WB_SRC_NUM-1:0] wb_src_op_2EXE;
    wire                   ertn_op_2EXE;
    wire                   sys_valid_2EXE;
    wire                   brk_valid_2EXE;
    wire                   ine_valid_2EXE;
    wire                   adef_valid_2EXE;
    wire [31:0]            if_vaddr_2EXE;
    wire                   int_valid_2EXE;
    wire                   exception_valid_2EXE;
    wire [`TLB_EX_NUM-1:0] tlb_ex_valid_2EXE;
    wire [31:0]            tlb_vaddr_2EXE;
    wire                   cache_cacop_valid_2EXE;
    wire                   cache_ibar_valid_2EXE;
    wire [1:0]             cache_cacop_op_2EXE;
    wire [31:0]            cache_cacop_addr_2EXE;
    wire [1:0]             cache_cacop_mat_2EXE;
    wire [4:0]             cache_cacop_cd_2EXE;
    wire                   refetch_tag_2EXE;

    // 阻塞时在 ID/EXE 边界注入气泡（气泡就是置为0）
    // id2exe_* 这些是不是应由 ID_EXE_reg 驱动
    // 现在这种写法是标准写法。id2exe_* 是“送进 ID_EXE_reg 的预处理输入”（用于 block 注气泡），真正寄存后的输出是 *_2EXE。
    // 所以不是反了，而是前后级信号命名分层。
    wire [4:0]               id2exe_wb_reg_addr = block_sig ? 5'b0 : wb_reg_addr_fromID;
    wire [31:0]              id2exe_alu_src1    = block_sig ? 32'b0 : alu_src1_fromID;
    wire [31:0]              id2exe_alu_src2    = block_sig ? 32'b0 : alu_src2_fromID;
    wire [31:0]              id2exe_br_imm      = block_sig ? 32'b0 : br_imm_fromID;
    wire [31:0]              id2exe_mem_wdata   = block_sig ? 32'b0 : mem_wdata_fromID;
    wire [`ALU_OP_NUM-1:0]   id2exe_alu_op      = block_sig ? {`ALU_OP_NUM{1'b0}} : alu_op_fromID;
    wire [`BR_OP_NUM-1:0]    id2exe_br_op       = block_sig ? {`BR_OP_NUM{1'b0}} : br_op_fromID;
    wire [`MEM_OP_NUM-1:0]   id2exe_mem_op      = block_sig ? {`MEM_OP_NUM{1'b0}} : mem_op_fromID;
    wire                     id2exe_wb_op       = block_sig ? 1'b0 : wb_op_fromID;
    wire [31:0]              id2exe_pc          = block_sig ? 32'b0 : id_pc_fromID;
    wire [`CSR_OP_NUM-1:0]   id2exe_csr_op      = block_sig ? {`CSR_OP_NUM{1'b0}} : csr_op_fromID;
    wire [11:0]              id2exe_csr_num     = block_sig ? 12'b0 : csr_num_fromID;
    wire [31:0]              id2exe_csr_wmask   = block_sig ? 32'b0 : csr_wmask_fromID;
    wire [31:0]              id2exe_csr_wvalue  = block_sig ? 32'b0 : csr_wvalue_fromID;
    wire [`TLB_OP_NUM-1:0]   id2exe_tlb_op      = block_sig ? {`TLB_OP_NUM{1'b0}} : tlb_op_fromID;
    wire [9:0]               id2exe_invtlb_asid = block_sig ? 10'b0 : invtlb_asid_fromID;
    wire [18:0]              id2exe_invtlb_vpn  = block_sig ? 19'b0 : invtlb_vpn_fromID;
    wire [`WB_SRC_NUM-1:0]   id2exe_wb_src_op   = block_sig ? {`WB_SRC_NUM{1'b0}} : wb_src_op_fromID;
    wire                     id2exe_ertn_op     = block_sig ? 1'b0 : ertn_op_fromID;
    wire                     id2exe_sys_valid   = block_sig ? 1'b0 : sys_valid_fromID;
    wire                     id2exe_brk_valid   = block_sig ? 1'b0 : brk_valid_fromID;
    wire                     id2exe_ine_valid   = block_sig ? 1'b0 : ine_valid_fromID;
    wire                     id2exe_adef_valid   = block_sig ? 1'b0 : adef_valid_fromID;
    wire [31:0]              id2exe_if_vaddr    = block_sig ? 32'b0 : if_vaddr_fromID;
    wire                     id2exe_int_valid   = block_sig ? 1'b0 : int_valid_fromID;
    wire                     id2exe_exception_valid = block_sig ? 1'b0 : exception_valid_fromID;
    wire [`TLB_EX_NUM-1:0]   id2exe_tlb_ex_valid = block_sig ? {`TLB_EX_NUM{1'b0}} : tlb_ex_valid_fromID;
    wire [31:0]              id2exe_tlb_vaddr   = block_sig ? 32'b0 : tlb_vaddr_fromID;
    wire                     id2exe_cache_cacop_valid = block_sig ? 1'b0 : id_inst_cacop;
    wire                     id2exe_cache_ibar_valid  = block_sig ? 1'b0 : id_inst_ibar;
    wire [1:0]               id2exe_cache_cacop_op    = block_sig ? 2'b0 : id_cacop_op;
    wire [31:0]              id2exe_cache_cacop_addr  = block_sig ? 32'b0 : id_cacop_addr;
    wire [1:0]               id2exe_cache_cacop_mat   = block_sig ? 2'b0 : id_cacop_mat;
    wire [4:0]               id2exe_cache_cacop_cd    = block_sig ? 5'b0 : id_cacop_cd;
    wire                     id2exe_refetch_tag = block_sig ? 1'b0 : refetch_tag_ifid_to_id;

    ID_EXE_reg u_ID_EXE_reg(
        .clk             (clk),
        .reset           (reset),
        .cancel_sig      (cancel_sig),
        .valid           (ID_EXE_reg_valid),
        .readyGo         (ID_readyGo),
        .allowIn         (ID_EXE_reg_allowIn),
        .wb_reg_addr_in  (id2exe_wb_reg_addr),
        .alu_src1_in     (id2exe_alu_src1),
        .alu_src2_in     (id2exe_alu_src2),
        .br_imm_in       (id2exe_br_imm),
        .alu_op_in       (id2exe_alu_op),
        .br_op_in        (id2exe_br_op),
        .mem_wdata_in    (id2exe_mem_wdata),
        .mem_op_in       (id2exe_mem_op),
        .wb_op_in        (id2exe_wb_op),
        .pc_in           (id2exe_pc),
        .csr_op_in       (id2exe_csr_op),
        .csr_num_in      (id2exe_csr_num),
        .csr_wmask_in    (id2exe_csr_wmask),
        .csr_wvalue_in   (id2exe_csr_wvalue),
        .tlb_op_in       (id2exe_tlb_op),
        .invtlb_asid_in  (id2exe_invtlb_asid),
        .invtlb_vpn_in   (id2exe_invtlb_vpn),
        .wb_src_op_in    (id2exe_wb_src_op),
        .ertn_op_in      (id2exe_ertn_op),
        .sys_valid_in    (id2exe_sys_valid),
        .brk_valid_in    (id2exe_brk_valid),
        .ine_valid_in    (id2exe_ine_valid),
        .adef_valid_in   (id2exe_adef_valid),
        .int_valid_in    (id2exe_int_valid),
        .exception_valid_in (id2exe_exception_valid),
        .cache_cacop_valid_in (id2exe_cache_cacop_valid),
        .cache_ibar_valid_in  (id2exe_cache_ibar_valid),
        .cache_cacop_op_in    (id2exe_cache_cacop_op),
        .cache_cacop_addr_in  (id2exe_cache_cacop_addr),
        .cache_cacop_mat_in   (id2exe_cache_cacop_mat),
        .cache_cacop_cd_in    (id2exe_cache_cacop_cd),
        .refetch_tag_in    (id2exe_refetch_tag),
        .if_vaddr_in     (id2exe_if_vaddr),
        .tlb_ex_valid_in (id2exe_tlb_ex_valid),
        .tlb_vaddr_in    (id2exe_tlb_vaddr),
        .wb_reg_addr_out (wb_reg_addr_2EXE),
        .alu_src1_out    (alu_src1_2EXE),
        .alu_src2_out    (alu_src2_2EXE),
        .br_imm_out      (br_imm_2EXE),
        .alu_op_out      (alu_op_2EXE),
        .mem_wdata_out   (mem_wdata_2EXE),
        .br_op_out       (br_op_2EXE),
        .mem_op_out      (mem_op_2EXE),
        .wb_op_out       (wb_op_2EXE),
        .pc_out          (pc_exe),
        .csr_op_out      (csr_op_2EXE),
        .csr_num_out     (csr_num_2EXE),
        .csr_wmask_out   (csr_wmask_2EXE),
        .csr_wvalue_out  (csr_wvalue_2EXE),
        .tlb_op_out      (tlb_op_2EXE),
        .invtlb_asid_out (invtlb_asid_2EXE),
        .invtlb_vpn_out  (invtlb_vpn_2EXE),
        .wb_src_op_out   (wb_src_op_2EXE),
        .ertn_op_out     (ertn_op_2EXE),
        .sys_valid_out   (sys_valid_2EXE),
        .brk_valid_out   (brk_valid_2EXE),
        .ine_valid_out   (ine_valid_2EXE),
        .adef_valid_out  (adef_valid_2EXE),
        .if_vaddr_out    (if_vaddr_2EXE),
        .int_valid_out   (int_valid_2EXE),
        .exception_valid_out (exception_valid_2EXE),
        .cache_cacop_valid_out (cache_cacop_valid_2EXE),
        .cache_ibar_valid_out  (cache_ibar_valid_2EXE),
        .cache_cacop_op_out    (cache_cacop_op_2EXE),
        .cache_cacop_addr_out  (cache_cacop_addr_2EXE),
        .cache_cacop_mat_out   (cache_cacop_mat_2EXE),
        .cache_cacop_cd_out    (cache_cacop_cd_2EXE),
        .refetch_tag_out (refetch_tag_2EXE),
        .tlb_ex_valid_out (tlb_ex_valid_2EXE),
        .tlb_vaddr_out   (tlb_vaddr_2EXE)
    );

    wire br_taken_q;             // EXE 组合分支命中（要冲刷 IF/ID 、要重定向 npc）
    wire wb_is_invtlb;
    wire refetch_req_2conflict_handler;
    wire [31:0] tlb_refetch_pc;
    wire [31:0] csr_next_pc_mux;
    wire [1:0]  csr_redirect_mux;

    npc u_npc(
        .IF_valid          (IF_valid),
        .br_taken          (br_taken_q),
        .br_op             (br_op_2EXE),
        .br_offs           (br_imm_2EXE),
        .rj_value          (alu_src1_2EXE),
        .pc_fetch          (pc),
        .pc_branch_base    (pc_exe),
        .block_sig         (block_sig),
        .IF_ID_reg_allowIn (IF_ID_reg_allowIn),
        .axi_if_busy       (axi_if_busy),
        .csr_next_pc       (csr_next_pc_mux),
        .csr_redirect      (csr_redirect_mux),
        .nextpc            (nextpc),
        .pc_stall          (pc_stall)
    );

    //------------------------------------------------------------------
    // EXE
    //------------------------------------------------------------------
    wire        EXE_readyGo;      // EXE 阶段就绪
    wire        EXE_allowIn;      // EXE 阶段允许接收
    wire        EXE_valid;        // EXE 阶段有效位
    wire [31:0] exe_alu_or_addr;  // EXE：ALU/链寄存器结果或访存地址
    wire [31:0] exe_pc_2MEM;      // EXE 透传到 MEM 的 PC
    wire [4:0]  exe_wb_reg_addr;  // EXE 输出目的寄存器号
    wire [`MEM_OP_NUM-1:0]  exe_mem_op;       // EXE 输出访存控制
    wire [31:0] exe_mem_wdata;    // EXE 输出 store 写数据
    wire        exe_wb_op;        // EXE 输出写回使能
    wire        exe_is_CACOP;
    
    // EXE 对 BRAM 控制器的访存请求输出
    wire        data_we_from_EXE;
    wire        data_re_from_EXE;
    wire [31:0] data_raddr_from_EXE;
    wire [31:0] data_waddr_from_EXE;
    wire [31:0] data_wdata_from_EXE;
    wire [ 3:0] data_wbyte_en_from_EXE;

    wire [`CSR_OP_NUM-1:0] exe_csr_op_to_mem;
    wire [11:0]            exe_csr_num_to_mem;
    wire [31:0]            exe_csr_wmask_to_mem;
    wire [31:0]            exe_csr_wvalue_to_mem;
    wire [`TLB_OP_NUM-1:0] exe_tlb_op_to_mem;
    wire [9:0]             exe_invtlb_asid_to_mem;
    wire [18:0]            exe_invtlb_vpn_to_mem;
    wire [`WB_SRC_NUM-1:0] exe_wb_src_op_to_mem;
    wire                   exe_ertn_op_to_mem;
    wire                   exe_sys_valid_to_mem;
    wire                   exe_brk_valid_to_mem;
    wire                   exe_ine_valid_to_mem;
    wire                   exe_adef_valid_to_mem;
    wire                   exe_ale_valid_to_mem;
    wire                   exe_int_valid_to_mem;
    wire                   exe_exception_valid_to_mem;
    wire [31:0]            exe_if_vaddr_to_mem;
    wire [31:0]            exe_ale_vaddr_to_mem;
    wire [`TLB_EX_NUM-1:0] exe_tlb_ex_valid_to_mem;
    wire [31:0]            exe_tlb_vaddr_to_mem;
    wire [`TLB_EX_NUM-1:0] data_tlb_ex_vec;
    wire [31:0]            data_tlb_ex_vaddr;

    EXEport u_EXEport(
        .clk             (clk),
        .reset           (reset),
        .valid           (EXE_valid),
        .stall           (stall),
        .wb_reg_addr     (wb_reg_addr_2EXE),
        .alu_src1        (alu_src1_2EXE),
        .alu_src2        (alu_src2_2EXE),
        .pc_in           (pc_exe),
        .br_imm          (br_imm_2EXE),
        .alu_op          (alu_op_2EXE),
        .br_op           (br_op_2EXE),
        .mem_wdata_in    (mem_wdata_2EXE),
        .mem_op_in       (mem_op_2EXE),
        .wb_op_in        (wb_op_2EXE),
        .csr_op_in       (csr_op_2EXE),
        .csr_num_in      (csr_num_2EXE),
        .csr_wmask_in    (csr_wmask_2EXE),
        .csr_wvalue_in   (csr_wvalue_2EXE),
        .csr_rvalue_from_csr (csr_rvalue_unused),
        .csr_tid_from_csr (csr_tid_to_exe),
        .wb_src_op_in    (wb_src_op_2EXE),
        .tlb_op_in       (tlb_op_2EXE),
        .invtlb_asid_in  (invtlb_asid_2EXE),
        .invtlb_vpn_in   (invtlb_vpn_2EXE),
        .ertn_op_in      (ertn_op_2EXE),
        .sys_valid_in    (sys_valid_2EXE),
        .brk_valid_in    (brk_valid_2EXE),
        .ine_valid_in    (ine_valid_2EXE),
        .adef_valid_in   (adef_valid_2EXE),
        .int_valid_in    (int_valid_2EXE),
        .exception_valid_in (exception_valid_2EXE),
        .if_vaddr_in     (if_vaddr_2EXE),
        .readyGo         (EXE_readyGo),
        .allowIn         (EXE_allowIn),
        .br_taken        (br_taken_q),
        .exe_alu_or_addr_or_cnt (exe_alu_or_addr),
        .pc_out          (exe_pc_2MEM),
        .wb_reg_addr_out (exe_wb_reg_addr),
        .mem_op          (exe_mem_op),
        .mem_wdata_out   (exe_mem_wdata),
        .wb_op           (exe_wb_op),
        .data_we_from_EXE (data_we_from_EXE),
        .data_re_from_EXE (data_re_from_EXE),
        .data_raddr_from_EXE (data_raddr_from_EXE),
        .data_waddr_from_EXE (data_waddr_from_EXE),
        .data_wdata_from_EXE (data_wdata_from_EXE),
        .data_wbyte_en_from_EXE (data_wbyte_en_from_EXE),
        .csr_op_out      (exe_csr_op_to_mem),
        .csr_num_out     (exe_csr_num_to_mem),
        .csr_wmask_out   (exe_csr_wmask_to_mem),
        .csr_wvalue_out  (exe_csr_wvalue_to_mem),
        .wb_src_op_out   (exe_wb_src_op_to_mem),
        .tlb_op_out      (exe_tlb_op_to_mem),
        .invtlb_asid_out (exe_invtlb_asid_to_mem),
        .invtlb_vpn_out  (exe_invtlb_vpn_to_mem),
        .ertn_op_out     (exe_ertn_op_to_mem),
        .sys_valid_out   (exe_sys_valid_to_mem),
        .brk_valid_out   (exe_brk_valid_to_mem),
        .ine_valid_out   (exe_ine_valid_to_mem),
        .adef_valid_out  (exe_adef_valid_to_mem),
        .ale_valid_out   (exe_ale_valid_to_mem),
        .int_valid_out   (exe_int_valid_to_mem),
        .exception_valid_out (exe_exception_valid_to_mem),
        .if_vaddr_out    (exe_if_vaddr_to_mem),
        .ale_vaddr_out   (exe_ale_vaddr_to_mem),
        .exe_is_CACOP    (exe_is_CACOP)
    );

    //------------------------------------------------------------------
    // MEM
    //------------------------------------------------------------------
    wire        EXE_MEM_reg_valid; // EXE_MEM_reg 输入 valid
    wire        EXE_MEM_reg_allowIn;// EXE_MEM_reg 允许写入
    wire        MEM_allowIn;       // MEM 阶段允许接收
    wire        MEM_valid;         // MEM 阶段有效位
    wire [31:0] em_result;         // EXE_MEM_reg 输出结果
    wire [4:0]  em_wb_reg;         // EXE_MEM_reg 输出目的寄存器号
    wire [`MEM_OP_NUM-1:0]  em_mem_op;         // EXE_MEM_reg 输出访存控制
    wire        em_wb_op;          // EXE_MEM_reg 输出写回使能
    wire [31:0] em_mem_wdata;      // EXE_MEM_reg 输出 store 数据
    wire [31:0] em_pc;             // EXE_MEM_reg 输出 PC
    wire [31:0] em_data_raddr;     // EXE/MEM 锁存的读地址
    wire [31:0] em_data_waddr;     // EXE/MEM 锁存的写地址
    wire [ 3:0] em_data_wbyte_en;  // EXE/MEM 锁存的写字节使能
    wire        em_slot_tag;       // EXE/MEM 槽位标签，供 WB 去重
    wire        mem_is_CACOP;

    wire [31:0] em_data_wdata;

    wire [`CSR_OP_NUM-1:0] em_csr_op;
    wire [11:0]            em_csr_num;
    wire [31:0]            em_csr_wmask;
    wire [31:0]            em_csr_wvalue;
    wire [`TLB_OP_NUM-1:0] em_tlb_op;
    wire [9:0]             em_invtlb_asid;
    wire [18:0]            em_invtlb_vpn;
    wire [`WB_SRC_NUM-1:0] em_wb_src_op;
    wire                   em_ertn_op;
    wire                   em_sys_valid;
    wire                   em_brk_valid;
    wire                   em_ine_valid;
    wire                   em_adef_valid;
    wire                   em_ale_valid;
    wire                   em_int_valid;
    wire                   em_exception_valid;
    wire [31:0]            em_if_vaddr;
    wire [31:0]            em_ale_vaddr;
    wire [`TLB_EX_NUM-1:0] em_tlb_ex_valid;
    wire [31:0]            em_tlb_vaddr;
    wire                   refetch_tag_em;

    EXE_MEM_reg u_EXE_MEM_reg(
        .clk             (clk),
        .reset           (reset),
        .valid           (EXE_MEM_reg_valid),
        .readyGo         (EXE_readyGo),
        .allowIn         (EXE_MEM_reg_allowIn),
        .exe_alu_or_addr_in (exe_alu_or_addr),
        .wb_reg_addr_in  (exe_wb_reg_addr),
        .mem_op_in       (exe_mem_op),
        .wb_op_in        (exe_wb_op),
        .mem_wdata_in    (exe_mem_wdata),
        .data_raddr_from_EXE(data_raddr_from_EXE),
        .data_waddr_from_EXE(data_waddr_from_EXE),
        .data_wdata_from_EXE(data_wdata_from_EXE),
        .data_wbyte_en_from_EXE(data_wbyte_en_from_EXE),
        .csr_op_in       (exe_csr_op_to_mem),
        .csr_num_in      (exe_csr_num_to_mem),
        .csr_wmask_in    (exe_csr_wmask_to_mem),
        .csr_wvalue_in   (exe_csr_wvalue_to_mem),
        .tlb_op_in       (exe_tlb_op_to_mem),
        .invtlb_asid_in  (exe_invtlb_asid_to_mem),
        .invtlb_vpn_in   (exe_invtlb_vpn_to_mem),
        .wb_src_op_in    (exe_wb_src_op_to_mem),
        .ertn_op_in      (exe_ertn_op_to_mem),
        .sys_valid_in    (exe_sys_valid_to_mem),
        .brk_valid_in    (exe_brk_valid_to_mem),
        .ine_valid_in    (exe_ine_valid_to_mem),
        .adef_valid_in   (exe_adef_valid_to_mem),
        .ale_valid_in    (exe_ale_valid_to_mem),
        .int_valid_in    (exe_int_valid_to_mem),
        .exception_valid_in (exe_exception_valid_to_mem),
        .refetch_tag_in  (refetch_tag_2EXE),
        .if_vaddr_in     (exe_if_vaddr_to_mem),
        .ale_vaddr_in    (exe_ale_vaddr_to_mem),
        .tlb_ex_valid_in (exe_tlb_ex_valid_to_mem),
        .tlb_vaddr_in    (exe_tlb_vaddr_to_mem),
        .pc_in           (exe_pc_2MEM),
        .exe_alu_or_addr_out(em_result),
        .wb_reg_addr_out (em_wb_reg),
        .mem_op_out      (em_mem_op),
        .wb_op_out       (em_wb_op),
        .mem_wdata_out   (em_mem_wdata),
        .data_raddr_out_from_EXE(em_data_raddr),
        .data_waddr_out_from_EXE(em_data_waddr),
        .data_wdata_out_from_EXE(em_data_wdata),
        .data_wbyte_en_out_from_EXE(em_data_wbyte_en),
        .slot_tag_out    (em_slot_tag),
        .pc_out          (em_pc),
        .csr_op_out      (em_csr_op),
        .csr_num_out     (em_csr_num),
        .csr_wmask_out   (em_csr_wmask),
        .csr_wvalue_out  (em_csr_wvalue),
        .tlb_op_out      (em_tlb_op),
        .invtlb_asid_out (em_invtlb_asid),
        .invtlb_vpn_out  (em_invtlb_vpn),
        .wb_src_op_out   (em_wb_src_op),
        .ertn_op_out     (em_ertn_op),
        .sys_valid_out   (em_sys_valid),
        .brk_valid_out   (em_brk_valid),
        .ine_valid_out   (em_ine_valid),
        .adef_valid_out  (em_adef_valid),
        .ale_valid_out   (em_ale_valid),
        .int_valid_out   (em_int_valid),
        .exception_valid_out (em_exception_valid),
        .refetch_tag_out (refetch_tag_em),
        .if_vaddr_out    (em_if_vaddr),
        .ale_vaddr_out   (em_ale_vaddr),
        .tlb_ex_valid_out (em_tlb_ex_valid),
        .tlb_vaddr_out   (em_tlb_vaddr)
    );

    wire        MEM_readyGo;      // MEM 阶段就绪
    wire        mem_load_hazard;   // MEMport：load 槽尚未就绪，供 RAW（勿用顶层 ~MEM_readyGo 与反馈环）
    wire [31:0] mem_wb_wdata;     // MEM 输出到 WB 的写回数据
    wire [31:0] mem_pc_2WB;       // MEM 输出到 WB 的 PC
    wire [4:0]  mem_wb_regaddr;   // MEM 输出到 WB 的目的寄存器号
    wire        mem_wb_op;        // MEM 输出到 WB 的写回使能

    wire data_w_complete;   // 数据写完成脉冲
    wire data_r_complete;   // 数据读完成脉冲
    reg  dcache_req_is_store;

    reg        ld_req_issued; //记录「本 MEM 槽是否已发过 data_re」
    reg [31:0] ld_req_pc;     //记录「本 MEM 槽的 PC」
    reg [4:0]  ld_req_reg;    //记录「本 MEM 槽的目的寄存器号」

    // ld_in_mem：当前 MEM 槽有效且为 load
    wire       ld_in_mem = (em_mem_op[`MEM_OP_LD_W] | em_mem_op[`MEM_OP_LD_H] | em_mem_op[`MEM_OP_LD_B]
                         |  em_mem_op[`MEM_OP_LD_HU] | em_mem_op[`MEM_OP_LD_BU]) & MEM_valid;

    // ld_slot_match：仍是 同一槽（同 PC、同 rd）
    wire       ld_slot_match = ld_req_issued & ld_in_mem
                               & (em_pc == ld_req_pc) & (em_wb_reg == ld_req_reg);

    // 是 load 且 还没对该槽发过读 → 允许向 BRAM 发 data_re
    wire       data_re_issue_ld = ld_in_mem & ~ld_slot_match; 

    // 本槽已发过读（给别处观测用）
    wire       mem_load_req_sent = ld_slot_match; 

    // 有效 store 槽 → 发写请求。
    wire       data_we_issue_st = (em_mem_op[`MEM_OP_ST_W] | em_mem_op[`MEM_OP_ST_B] | em_mem_op[`MEM_OP_ST_H]) & MEM_valid;
    assign data_tlb_ex_vec = {mmu_data_tlbr, 1'b0, mmu_data_ppi, mmu_data_pil, mmu_data_pis, mmu_data_pme};
    assign data_tlb_ex_vaddr = data_we_issue_st ? em_data_waddr : em_data_raddr;
    assign exe_tlb_ex_valid_to_mem = tlb_ex_valid_2EXE | data_tlb_ex_vec;
    assign exe_tlb_vaddr_to_mem = (|data_tlb_ex_vec) ? data_tlb_ex_vaddr : tlb_vaddr_2EXE;

    wire [`CSR_OP_NUM-1:0] mem_csr_op;
    wire [11:0]            mem_csr_num;
    wire [31:0]            mem_csr_wmask;
    wire [31:0]            mem_csr_wvalue;
    wire [`TLB_OP_NUM-1:0] mem_tlb_op;
    wire [9:0]             mem_invtlb_asid;
    wire [18:0]            mem_invtlb_vpn;
    wire [`WB_SRC_NUM-1:0] mem_wb_src_op;
    wire                   mem_ertn_op;
    wire                   mem_sys_valid;
    wire                   mem_brk_valid;
    wire                   mem_ine_valid;
    wire                   mem_adef_valid;
    wire                   mem_ale_valid;
    wire                   mem_int_valid;
    wire                   mem_exception_valid;
    wire [31:0]            mem_if_vaddr;
    wire [31:0]            mem_ale_vaddr;
    wire [`TLB_EX_NUM-1:0] mem_tlb_ex_valid;
    wire [31:0]            mem_tlb_vaddr;

    MEMport u_MEMport(
        .clk            (clk),
        .reset          (reset),
        .valid          (MEM_valid),
        .slot_tag_in    (em_slot_tag),
        .data_sram_rdata(data_rdata_2MEM),
        .exe_result     (em_result),
        .pc_in          (em_pc),
        .wb_reg_addr_in (em_wb_reg),
        .mem_op         (em_mem_op),
        .wb_op_in       (em_wb_op),
        .mem_wdata_in   (em_mem_wdata),
        .data_raddr_from_EXE(em_data_raddr),
        .data_waddr_from_EXE(em_data_waddr),
        .data_w_complete(data_w_complete),
        .data_r_complete(data_r_complete),
        .csr_op_in      (em_csr_op),
        .csr_num_in     (em_csr_num),
        .csr_wmask_in   (em_csr_wmask),
        .csr_wvalue_in  (em_csr_wvalue),
        .tlb_op_in      (em_tlb_op),
        .invtlb_asid_in (em_invtlb_asid),
        .invtlb_vpn_in  (em_invtlb_vpn),
        .wb_src_op_in   (em_wb_src_op),
        .ertn_op_in     (em_ertn_op),
        .sys_valid_in   (em_sys_valid),
        .brk_valid_in   (em_brk_valid),
        .ine_valid_in   (em_ine_valid),
        .adef_valid_in  (em_adef_valid),
        .int_valid_in   (em_int_valid),
        .ale_valid_in   (em_ale_valid),
        .exception_valid_in (em_exception_valid),
        .if_vaddr_in    (em_if_vaddr),
        .ale_vaddr_in   (em_ale_vaddr),
        .tlb_ex_valid_in (em_tlb_ex_valid),
        .tlb_vaddr_in   (em_tlb_vaddr),
        .csr_op_out     (mem_csr_op),
        .csr_num_out    (mem_csr_num),
        .csr_wmask_out  (mem_csr_wmask),
        .csr_wvalue_out (mem_csr_wvalue),
        .tlb_op_out     (mem_tlb_op),
        .invtlb_asid_out(mem_invtlb_asid),
        .invtlb_vpn_out (mem_invtlb_vpn),
        .wb_src_op_out  (mem_wb_src_op),
        .readyGo        (MEM_readyGo),
        .allowIn        (MEM_allowIn),
        .load_pending_for_hazard (mem_load_hazard),
        .wb_wdata       (mem_wb_wdata),
        .pc_out         (mem_pc_2WB),
        .wb_reg_addr_out(mem_wb_regaddr),
        .wb_op_out      (mem_wb_op),
        .ertn_op_out    (mem_ertn_op),
        .sys_valid_out  (mem_sys_valid),
        .brk_valid_out  (mem_brk_valid),
        .ine_valid_out  (mem_ine_valid),
        .adef_valid_out (mem_adef_valid),
        .ale_valid_out  (mem_ale_valid),
        .int_valid_out  (mem_int_valid),
        .exception_valid_out (mem_exception_valid),
        .if_vaddr_out   (mem_if_vaddr),
        .ale_vaddr_out  (mem_ale_vaddr),
        .tlb_ex_valid_out (mem_tlb_ex_valid),
        .tlb_vaddr_out  (mem_tlb_vaddr),
        .mem_is_CACOP   (mem_is_CACOP)
    );

    // load 请求跟踪：同一 MEM 槽位只发一次 data_re，直到槽位离开 MEM 才允许新槽位再发
    always @(posedge clk) begin
        if (reset)
            ld_req_issued <= 1'b0;
        // 槽位离开（非 load / 无效 / pc或rd变化）后再清 issued，避免同槽重复发读请求
        else if (ld_req_issued && (!ld_in_mem || (em_pc != ld_req_pc) || (em_wb_reg != ld_req_reg)))
            ld_req_issued <= 1'b0;
        else if (!ld_req_issued && data_re_issue_ld) begin
            ld_req_issued   <= 1'b1;
            ld_req_pc       <= em_pc;
            ld_req_reg      <= em_wb_reg;
        end
    end

    //------------------------------------------------------------------
    // WB
    //------------------------------------------------------------------
    wire        MEM_WB_reg_valid;  // MEM_WB_reg 输入 valid
    wire        MEM_WB_reg_allowIn;// MEM_WB_reg 允许写入
    wire [31:0] mwb_wdata;         // MEM_WB_reg 输出写回数据
    wire [4:0]  mwb_waddr;         // MEM_WB_reg 输出写回寄存器号
    wire        mwb_we;            // MEM_WB_reg 输出写回使能
    wire [31:0] mwb_pc;            // MEM_WB_reg 输出提交 PC
    wire [`CSR_OP_NUM-1:0] mwb_csr_op;
    wire [11:0]            mwb_csr_num;
    wire [31:0]            mwb_csr_wmask;
    wire [31:0]            mwb_csr_wvalue;
    wire [`TLB_OP_NUM-1:0] mwb_tlb_op;
    wire [9:0]             mwb_invtlb_asid;
    wire [18:0]            mwb_invtlb_vpn;
    wire [`WB_SRC_NUM-1:0] mwb_wb_src_op;
    wire                   mwb_ertn_op;
    wire                   mwb_sys_valid;
    wire                   mwb_brk_valid;
    wire                   mwb_ine_valid;
    wire                   mwb_adef_valid;
    wire                   mwb_ale_valid;
    wire                   mwb_int_valid;
    wire                   mwb_exception_valid;
    wire [31:0]            mwb_if_vaddr;
    wire [31:0]            mwb_ale_vaddr;
    wire [`TLB_EX_NUM-1:0] mwb_tlb_ex_valid;
    wire [31:0]            mwb_tlb_vaddr;
    wire                   mwb_refetch_tag;

    MEM_WB_reg u_MEM_WB_reg(
        .clk             (clk),
        .reset           (reset),
        .valid           (MEM_WB_reg_valid),
        .readyGo         (MEM_readyGo),
        .allowIn         (MEM_WB_reg_allowIn),
        .wb_wdata_in     (mem_wb_wdata),
        .wb_reg_addr_in  (mem_wb_regaddr),
        .wb_op_in        (mem_wb_op),
        .pc_in           (mem_pc_2WB),
        .csr_op_in       (mem_csr_op),
        .csr_num_in      (mem_csr_num),
        .csr_wmask_in    (mem_csr_wmask),
        .csr_wvalue_in   (mem_csr_wvalue),
        .tlb_op_in       (mem_tlb_op),
        .invtlb_asid_in  (mem_invtlb_asid),
        .invtlb_vpn_in   (mem_invtlb_vpn),
        .wb_src_op_in    (mem_wb_src_op),
        .ertn_op_in      (mem_ertn_op),
        .sys_valid_in    (mem_sys_valid),
        .brk_valid_in    (mem_brk_valid),
        .ine_valid_in    (mem_ine_valid),
        .adef_valid_in   (mem_adef_valid),
        .int_valid_in    (mem_int_valid),
        .ale_valid_in    (mem_ale_valid),
        .exception_valid_in (mem_exception_valid),
        .refetch_tag_in  (refetch_tag_em),
        .if_vaddr_in     (mem_if_vaddr),
        .ale_vaddr_in    (mem_ale_vaddr),
        .tlb_ex_valid_in (mem_tlb_ex_valid),
        .tlb_vaddr_in    (mem_tlb_vaddr),
        .wb_wdata_out    (mwb_wdata),
        .wb_reg_addr_out (mwb_waddr),
        .wb_op_out       (mwb_we),
        .pc_out          (mwb_pc),
        .csr_op_out      (mwb_csr_op),
        .csr_num_out     (mwb_csr_num),
        .csr_wmask_out   (mwb_csr_wmask),
        .csr_wvalue_out  (mwb_csr_wvalue),
        .tlb_op_out      (mwb_tlb_op),
        .invtlb_asid_out (mwb_invtlb_asid),
        .invtlb_vpn_out  (mwb_invtlb_vpn),
        .wb_src_op_out   (mwb_wb_src_op),
        .ertn_op_out     (mwb_ertn_op),
        .sys_valid_out   (mwb_sys_valid),
        .brk_valid_out   (mwb_brk_valid),
        .ine_valid_out   (mwb_ine_valid),
        .adef_valid_out  (mwb_adef_valid),
        .ale_valid_out   (mwb_ale_valid),
        .int_valid_out   (mwb_int_valid),
        .exception_valid_out (mwb_exception_valid),
        .cache_cacop_valid_out (mwb_cache_cacop_valid),
        .cache_ibar_valid_out  (mwb_cache_ibar_valid),
        .cache_cacop_op_out    (mwb_cache_cacop_op),
        .cache_cacop_addr_out  (mwb_cache_cacop_addr),
        .cache_cacop_mat_out   (mwb_cache_cacop_mat),
        .cache_cacop_cd_out    (mwb_cache_cacop_cd),
        .refetch_tag_out (mwb_refetch_tag),
        .if_vaddr_out    (mwb_if_vaddr),
        .ale_vaddr_out   (mwb_ale_vaddr),
        .tlb_ex_valid_out (mwb_tlb_ex_valid),
        .tlb_vaddr_out   (mwb_tlb_vaddr)
    );

    wire wb_allowIn;              // WB 阶段 allowIn（常 1）
    wire [31:0] wb_wdata;         // WB 最终写回数据（到 regfile/debug）
    wire [31:0] wb_pc;            // WB 最终提交 PC（到 debug）
    wire [4:0]  wb_waddr;         // WB 最终写回寄存器号
    wire        wb_we;            // WB 最终写回使能

    wire [`CSR_OP_NUM-1:0] wb_csr_op_csr;
    wire [11:0]            wb_csr_num_csr;
    wire [31:0]            wb_csr_wmask_csr;
    wire [31:0]            wb_csr_wvalue_csr;
    wire [`TLB_OP_NUM-1:0] wb_tlb_op;
    wire [9:0]             wb_invtlb_asid;
    wire [18:0]            wb_invtlb_vpn;
    wire [`TLB_EX_NUM-1:0] wb_tlb_ex_valid;
    wire                   wb_ex_2csr;
    wire                   wb_valid_2csr;
    wire                   wb_is_ertn_2csr;
    wire [31:0]            wb_vaddr_2csr;
    wire                   wb_int_valid_2csr;
    wire                   wb_adef_valid_2csr;
    wire                   wb_ale_valid_2csr;
    wire                   wb_sys_valid_2csr;
    wire                   wb_brk_valid_2csr;
    wire                   wb_ine_valid_2csr;
    wire                   wb_is_CACOP;
    wire                   wb_refetch_tag_to_npc;

    assign wb_is_CACOP = wb_cache_cacop_valid | wb_cache_ibar_valid;

    // WB 提交时才让 TLB 维护类指令“落地”；refetch_req 由 conflict_detector 统一检测。
    assign wb_is_invtlb = wb_tlb_op[`TLB_OP_INVTLB_0] | wb_tlb_op[`TLB_OP_INVTLB_1] | wb_tlb_op[`TLB_OP_INVTLB_2]
                        | wb_tlb_op[`TLB_OP_INVTLB_3] | wb_tlb_op[`TLB_OP_INVTLB_4] | wb_tlb_op[`TLB_OP_INVTLB_5]
                        | wb_tlb_op[`TLB_OP_INVTLB_6];
    assign wb_refetch_tag_to_npc = WB_valid & mwb_refetch_tag;
    assign csr_next_pc_mux = wb_refetch_tag_to_npc ? (wb_pc + 32'd4) : csr_next_pc;
    assign csr_redirect_mux = wb_refetch_tag_to_npc ? `CSR_REDIRECT_EX : csr_redirect;

    wire csr_commit_we = WB_valid
        & (wb_csr_op_csr[`CSR_OP_CSRWR] | wb_csr_op_csr[`CSR_OP_CSRXCHG]);

    WBport u_WBport(
        .reset         (reset),
        .valid         (WB_valid),
        .wb_wdata_in   (mwb_wdata),
        .pc_in         (mwb_pc),
        .wb_reg_addr_in(mwb_waddr),
        .wb_op_in      (mwb_we),
        .csr_op_in     (mwb_csr_op),
        .csr_num_in    (mwb_csr_num),
        .csr_wmask_in  (mwb_csr_wmask),
        .csr_wvalue_in (mwb_csr_wvalue),
        .wb_src_op_in  (mwb_wb_src_op),
        .tlb_op_in     (mwb_tlb_op),
        .invtlb_asid_in(mwb_invtlb_asid),
        .invtlb_vpn_in (mwb_invtlb_vpn),
        .ertn_op_in    (mwb_ertn_op),
        .sys_valid_in  (mwb_sys_valid),
        .brk_valid_in  (mwb_brk_valid),
        .ine_valid_in  (mwb_ine_valid),
        .adef_valid_in (mwb_adef_valid),
        .int_valid_in  (mwb_int_valid),
        .ale_valid_in  (mwb_ale_valid),
        .exception_valid_in (mwb_exception_valid),
        .if_vaddr_in   (mwb_if_vaddr),
        .ale_vaddr_in  (mwb_ale_vaddr),
        .tlb_ex_valid_in (mwb_tlb_ex_valid),
        .tlb_vaddr_in  (mwb_tlb_vaddr),
        .cache_cacop_valid_in (mwb_cache_cacop_valid),
        .cache_ibar_valid_in  (mwb_cache_ibar_valid),
        .cache_cacop_op_in    (mwb_cache_cacop_op),
        .cache_cacop_addr_in  (mwb_cache_cacop_addr),
        .cache_cacop_mat_in   (mwb_cache_cacop_mat),
        .cache_cacop_cd_in    (mwb_cache_cacop_cd),
        .allowIn       (wb_allowIn),
        .wb_wdata_out  (wb_wdata),
        .pc_out        (wb_pc),
        .wb_reg_addr_out(wb_waddr),
        .wb_op_out     (wb_we),
        .csr_op_out    (wb_csr_op_csr),
        .csr_num_out   (wb_csr_num_csr),
        .csr_wmask_out (wb_csr_wmask_csr),
        .csr_wvalue_out(wb_csr_wvalue_csr),
        .tlb_op_out    (wb_tlb_op),
        .invtlb_asid_out(wb_invtlb_asid),
        .invtlb_vpn_out(wb_invtlb_vpn),
        .wb_ex_2csr    (wb_ex_2csr),
        .wb_valid_2csr (wb_valid_2csr),
        .wb_is_ertn_2csr(wb_is_ertn_2csr),
        .wb_vaddr_out  (wb_vaddr_2csr),
        .int_valid_out_2csr (wb_int_valid_2csr),
        .adef_valid_out_2csr(wb_adef_valid_2csr),
        .ale_valid_out_2csr (wb_ale_valid_2csr),
        .sys_valid_out_2csr (wb_sys_valid_2csr),
        .brk_valid_out_2csr (wb_brk_valid_2csr),
        .ine_valid_out_2csr (wb_ine_valid_2csr),
        .tlb_ex_valid_out_2csr(wb_tlb_ex_valid),
        .cache_cacop_valid_out (wb_cache_cacop_valid),
        .cache_ibar_valid_out  (wb_cache_ibar_valid),
        .cache_cacop_op_out    (wb_cache_cacop_op),
        .cache_cacop_addr_out  (wb_cache_cacop_addr),
        .cache_cacop_mat_out   (wb_cache_cacop_mat),
        .cache_cacop_cd_out    (wb_cache_cacop_cd)
    );

    wire rf_we = wb_we
               & (wb_waddr != 5'd0);

    wire rf_commit_we = rf_we
                      & (wb_pc[31:28] == 4'h1); // 仅用于 debug/trace 采样过滤

    regfile u_regfile(
        .clk    (clk),
        .raddr1 (rf_raddr1),
        .rdata1 (rf_rdata1),
        .raddr2 (rf_raddr2),
        .rdata2 (rf_rdata2),
        .we     (rf_we),
        .waddr  (wb_waddr),
        .wdata  (wb_wdata)
    );


    //------------------------------------------------------------------
    // 冲突检测与处理、前递、流水线控制器、sram_AXI_bridge、CSR/异常提交
    //------------------------------------------------------------------
    conflict_detector u_conflict_detector(
        .id_rs1        (rf_raddr1),
        .id_rs2        (rf_raddr2),
        .exe_rd        (wb_reg_addr_2EXE),
        .exe_wb        (wb_op_2EXE),
        .mem_rd        (em_wb_reg),
        .mem_wb        (em_wb_op),
        .wb_rd         (wb_waddr),
        .wb_wb         (rf_we),
        .id_valid      (ID_valid),
        .id_tlb_op     (tlb_op_fromID),
        .id_is_CACOP   (id_is_CACOP),
        .exe_valid     (EXE_valid),
        .exe_tlb_op    (tlb_op_2EXE),
        .exe_is_CACOP  (exe_is_CACOP),
        .mem_valid     (MEM_valid),
        .mem_tlb_op    (em_tlb_op),
        .mem_is_CACOP  (mem_is_CACOP),
        .wb_valid      (WB_valid),
        .wb_tlb_op     (wb_tlb_op),
        .wb_is_CACOP   (wb_is_CACOP),
        .hit_exe_rs1   (hit_exe_rs1),
        .hit_mem_rs1   (hit_mem_rs1),
        .hit_wb_rs1    (hit_wb_rs1),
        .hit_exe_rs2   (hit_exe_rs2),
        .hit_mem_rs2   (hit_mem_rs2),
        .hit_wb_rs2    (hit_wb_rs2),
        .refetch_req   (refetch_req_2conflict_handler)
    );

    wire mem_stage_is_load = mem_load_hazard;
    wire exe_stage_is_load = EXE_valid
                              & !exception_valid_2EXE
                              & (mem_op_2EXE[`MEM_OP_LD_W] | mem_op_2EXE[`MEM_OP_LD_H] | mem_op_2EXE[`MEM_OP_LD_B]
                              |  mem_op_2EXE[`MEM_OP_LD_HU] | mem_op_2EXE[`MEM_OP_LD_BU]);
    wire refetch_req_2pipeline_controller;

    conflict_handle u_conflict_handle(
        .hit_exe_rs1   (hit_exe_rs1),
        .hit_mem_rs1   (hit_mem_rs1),
        .hit_wb_rs1    (hit_wb_rs1),
        .hit_exe_rs2   (hit_exe_rs2),
        .hit_mem_rs2   (hit_mem_rs2),
        .hit_wb_rs2    (hit_wb_rs2),
        .exe_stage_is_load(exe_stage_is_load),
        .mem_stage_is_load(mem_stage_is_load),
        .br_taken_comb(br_taken_q),
        .csr_flush   (csr_flush_pipeline),
        .refetch_req_in (refetch_req_2conflict_handler),
        .RAW_hazard  (RAW_hazard),
        .block_sig   (block_sig),
        .stall       (stall),
        .cancel_sig  (cancel_sig),
        .FD_EXE_2rs1_sig  (FD_EXE_2rs1_sig),
        .FD_MEM_2rs1_sig  (FD_MEM_2rs1_sig),
        .FD_WB_2rs1_sig   (FD_WB_2rs1_sig),
        .FD_EXE_2rs2_sig  (FD_EXE_2rs2_sig),
        .FD_MEM_2rs2_sig  (FD_MEM_2rs2_sig),
        .FD_WB_2rs2_sig   (FD_WB_2rs2_sig),
        .refetch_req_out  (refetch_req_2pipeline_controller)
    );

    forward_deliver u_forward_deliver(
        .FD_EXE_2rs1_sig  (FD_EXE_2rs1_sig),
        .FD_MEM_2rs1_sig  (FD_MEM_2rs1_sig),
        .FD_WB_2rs1_sig   (FD_WB_2rs1_sig),
        .FD_EXE_2rs2_sig  (FD_EXE_2rs2_sig),
        .FD_MEM_2rs2_sig  (FD_MEM_2rs2_sig),
        .FD_WB_2rs2_sig   (FD_WB_2rs2_sig),
        .rf_rdata1        (rf_rdata1),
        .rf_rdata2        (rf_rdata2),
        .EXE_data         (exe_alu_or_addr),
        .MEM_data         (mem_wb_wdata),
        .WB_data          (mwb_wdata),
        .ID_src1_rdata    (ID_src1_rdata),
        .ID_src2_rdata    (ID_src2_rdata)
    );

    pipeline_controller u_pipeline_controller(
        .clk                (clk),
        .reset              (reset),
        .block_sig          (block_sig),
        .cancel_sig         (cancel_sig),
        .csr_flush          (csr_flush_pipeline),
        .IF_readyGo         (IF_readyGo),
        .ID_readyGo         (ID_readyGo),
        .EXE_readyGo        (EXE_readyGo),
        .MEM_readyGo        (MEM_readyGo),
        .WB_allowIn         (wb_allowIn),
        .ID_allowIn         (ID_allowIn),
        .EXE_allowIn        (EXE_allowIn),
        .MEM_allowIn        (MEM_allowIn),
        .refetch_req        (refetch_req_2pipeline_controller),
        .wb_refetch_tag     (mwb_refetch_tag),
        .refetch_tag        (IF_refetch_tag),
        .IF_ID_reg_allowIn  (IF_ID_reg_allowIn),
        .ID_EXE_reg_allowIn (ID_EXE_reg_allowIn),
        .EXE_MEM_reg_allowIn(EXE_MEM_reg_allowIn),
        .MEM_WB_reg_allowIn (MEM_WB_reg_allowIn),
        .IF_ID_reg_valid    (IF_ID_reg_valid),
        .ID_EXE_reg_valid   (ID_EXE_reg_valid),
        .EXE_MEM_reg_valid  (EXE_MEM_reg_valid),
        .MEM_WB_reg_valid   (MEM_WB_reg_valid),
        .IF_valid           (IF_valid),
        .ID_valid           (ID_valid),
        .EXE_valid          (EXE_valid),
        .MEM_valid          (MEM_valid),
        .WB_valid           (WB_valid)
    );

    // tlb_manager：组合产生 TLB 翻译结果、页表异常、TLBSRCH/TLBRD 回读结果。
    tlb_manager #(.TLBNUM(16)) u_tlb_manager (
        .clk            (clk),
        .reset          (reset),
        .inst_req       (IF_valid & IF_ID_reg_allowIn),
        .inst_vaddr     (pc_2ram_data_controller),
        .data_req       (data_we_issue_st | data_re_issue_ld),
        .data_is_store  (data_we_issue_st),
        .data_vaddr     (data_we_issue_st ? em_data_waddr : em_data_raddr),
        .csr_crmd_da    (csr_crmd_da),
        .csr_crmd_pg    (csr_crmd_pg),
        .csr_crmd_plv   (csr_crmd_plv),
        .csr_crmd_datf  (csr_crmd_datf),
        .csr_crmd_datm  (csr_crmd_datm),
        .csr_asid       (csr_asid),
        .csr_tlbidx     (csr_tlbidx),
        .csr_tlbehi     (csr_tlbehi),
        .csr_tlbelo0    (csr_tlbelo0),
        .csr_tlbelo1    (csr_tlbelo1),
        .csr_dmw0       (csr_dmw0),
        .csr_dmw1       (csr_dmw1),
        .csr_estat_ecode(csr_estat_ecode),
        .tlb_op         (wb_tlb_op),
        .invtlb_asid    (wb_invtlb_asid),
        .invtlb_vpn     (wb_invtlb_vpn),
        .inst_paddr     (tlbm_inst_paddr),
        .inst_mat       (tlbm_inst_mat),
        .inst_ex_tlbr   (tlbm_inst_ex_tlbr),
        .inst_ex_pif    (tlbm_inst_ex_pif),
        .inst_ex_ppi    (tlbm_inst_ex_ppi),
        .data_paddr     (tlbm_data_paddr),
        .data_mat       (tlbm_data_mat),
        .data_ex_tlbr   (tlbm_data_ex_tlbr),
        .data_ex_pil    (tlbm_data_ex_pil),
        .data_ex_pis    (tlbm_data_ex_pis),
        .data_ex_ppi    (tlbm_data_ex_ppi),
        .data_ex_pme    (tlbm_data_ex_pme),
        .tlbsrch_found  (tlbsrch_found),
        .tlbsrch_index  (tlbsrch_index),
        .tlbrd_tlbidx   (tlbrd_tlbidx),
        .tlbrd_tlbehi   (tlbrd_tlbehi),
        .tlbrd_tlbelo0  (tlbrd_tlbelo0),
        .tlbrd_tlbelo1  (tlbrd_tlbelo1),
        .tlbrd_asid     (tlbrd_asid)
    );

    mmu u_mmu (
        .clk                    (clk),
        .reset                  (reset),
        .inst_req_in            (IF_valid & IF_ID_reg_allowIn),
        .inst_vaddr_in          (pc_2ram_data_controller),
        .inst_adef_in           (adef_valid_req_fromIF),
        .data_re_in             (data_re_issue_ld),
        .data_we_in             (data_we_issue_st),
        .data_vaddr_r_in        (em_data_raddr),
        .data_vaddr_w_in        (em_data_waddr),
        .data_wdata_in          (em_data_wdata),
        .data_wstrb_in          (em_data_wbyte_en),
        .bridge_inst_rdata_in   (icache_if_data),
        .bridge_data_rdata_in   (dcache_mem_rdata),
        .bridge_inst_complete_in(cache_inst_r_complete),
        .bridge_data_r_complete_in(cache_data_r_complete),
        .bridge_data_w_complete_in(cache_data_w_complete),
        .csr_crmd_datf_in       (csr_crmd_datf),
        .csr_crmd_datm_in       (csr_crmd_datm),
        .csr_dmw0_in            (csr_dmw0),
        .csr_dmw1_in            (csr_dmw1),
        .tlbm_inst_paddr        (tlbm_inst_paddr),
        .tlbm_inst_mat          (tlbm_inst_mat),
        .tlbm_data_paddr        (tlbm_data_paddr),
        .tlbm_data_mat          (tlbm_data_mat),
        .tlbm_inst_ex_tlbr      (tlbm_inst_ex_tlbr),
        .tlbm_inst_ex_pif       (tlbm_inst_ex_pif),
        .tlbm_inst_ex_ppi       (tlbm_inst_ex_ppi),
        .tlbm_data_ex_tlbr      (tlbm_data_ex_tlbr),
        .tlbm_data_ex_pil       (tlbm_data_ex_pil),
        .tlbm_data_ex_pis       (tlbm_data_ex_pis),
        .tlbm_data_ex_ppi       (tlbm_data_ex_ppi),
        .tlbm_data_ex_pme       (tlbm_data_ex_pme),
        .inst_req_out           (mmu_inst_req),
        .inst_paddr_out         (mmu_inst_paddr),
        .inst_adef_out          (mmu_inst_adef),
        .inst_tlbr_out          (mmu_inst_tlbr),
        .inst_pif_out           (mmu_inst_pif),
        .inst_ppi_out           (mmu_inst_ppi),
        .data_re_out            (mmu_data_re),
        .data_we_out            (mmu_data_we),
        .data_paddr_r_out       (mmu_data_paddr_r),
        .data_paddr_w_out       (mmu_data_paddr_w),
        .data_wdata_out         (mmu_data_wdata),
        .data_wstrb_out         (mmu_data_wstrb),
        .data_tlbr_out          (mmu_data_tlbr),
        .data_pil_out           (mmu_data_pil),
        .data_pis_out           (mmu_data_pis),
        .data_ppi_out           (mmu_data_ppi),
        .data_pme_out           (mmu_data_pme),
        .data_tlb_excp_cancel_out(mmu_data_tlb_excp_cancel),
        .inst_mat_out           (mmu_inst_mat),
        .data_mat_out           (mmu_data_mat),
        .inst_rdata_out         (inst_rdata_2IF),
        .data_rdata_out         (data_rdata_2MEM),
        .inst_complete_out      (inst_r_complete),
        .data_r_complete_out    (data_r_complete),
        .data_w_complete_out    (data_w_complete)
    );

    icache u_icache (
        .clk        (clk),
        .resetn     (resetn),
        .if_valid   (mmu_inst_req),
        .if_pc      (mmu_inst_paddr),
        .if_mat     (mmu_inst_mat),
        .if_addr_ok (icache_if_addr_ok),
        .if_data_ok (icache_if_data_ok),
        .if_data    (icache_if_data),
        .cacop_en   (icache_cacop_en),
        .cacop_op   (icache_cacop_op),
        .cacop_addr (icache_cacop_addr),
        .cacop_mat  (icache_cacop_mat),
        .tlb_excp_cancel_req(icache_tlb_excp_cancel_req),
        .tlb_valid  (1'b1),
        .tlb_paddr  (mmu_inst_paddr),
        .axi_rd_req (axi_ic_rd_req),
        .axi_rd_type(axi_ic_rd_type),
        .axi_rd_addr(axi_ic_rd_addr),
        .axi_rd_rdy  (axi_ic_rd_rdy),
        .axi_ret_valid (axi_ic_ret_valid),
        .axi_ret_last  (axi_ic_ret_last),
        .axi_ret_data  (axi_ic_ret_data),
        .if_pc_out   (icache_if_pc),
        .stall_if    (icache_stall_if)
    );

    dcache u_dcache (
        .clk        (clk),
        .resetn     (resetn),
        .mem_valid  (mmu_data_re | mmu_data_we),
        .mem_op     (mmu_data_we),
        .mem_addr   (mmu_data_we ? mmu_data_paddr_w : mmu_data_paddr_r),
        .mem_mat    (mmu_data_mat),
        .mem_wstrb  (mmu_data_wstrb),
        .mem_wdata  (mmu_data_wdata),
        .mem_addr_ok(dcache_mem_addr_ok),
        .mem_data_ok(dcache_mem_data_ok),
        .mem_rdata  (dcache_mem_rdata),
        .cacop_en   (dcache_cacop_en),
        .cacop_op   (dcache_cacop_op),
        .cacop_addr (dcache_cacop_addr),
        .cacop_mat  (dcache_cacop_mat),
        .preld_hint (dcache_preld_hint),
        .preld_en   (dcache_preld_en),
        .tlb_excp_cancel_req(dcache_tlb_excp_cancel_req),
        .sc_cancel_req(dcache_sc_cancel_req),
        .tlb_valid  (1'b1),
        .tlb_paddr  (mmu_data_we ? mmu_data_paddr_w : mmu_data_paddr_r),
        .axi_rd_req (axi_dc_rd_req),
        .axi_rd_type(axi_dc_rd_type),
        .axi_rd_addr(axi_dc_rd_addr),
        .axi_rd_rdy (axi_dc_rd_rdy),
        .axi_ret_valid(axi_dc_ret_valid),
        .axi_ret_last (axi_dc_ret_last),
        .axi_ret_data (axi_dc_ret_data),
        .axi_wr_req (axi_dc_wr_req),
        .axi_wr_type(axi_dc_wr_type),
        .axi_wr_addr(axi_dc_wr_addr),
        .axi_wr_strb(axi_dc_wr_strb),
        .axi_wr_data(axi_dc_wr_data),
        .axi_wr_rdy (axi_dc_wr_rdy),
        .stall_mem  (dcache_stall_mem)
    );

    assign cache_inst_r_complete  = icache_if_data_ok;
    assign pc_2ID_from_bram = icache_if_pc;
    always @(posedge clk) begin
        if (reset) begin
            dcache_req_is_store <= 1'b0;
        end else if (mmu_data_re | mmu_data_we) begin
            dcache_req_is_store <= mmu_data_we;
        end
    end

    assign cache_data_r_complete  = dcache_mem_data_ok & ~dcache_req_is_store;
    assign cache_data_w_complete  = dcache_mem_data_ok &  dcache_req_is_store;
    assign axi_if_busy      = icache_stall_if | dcache_stall_mem;
    assign icache_tlb_excp_cancel_req = mmu_inst_tlbr | mmu_inst_pif | mmu_inst_ppi | cancel_sig;
    assign dcache_tlb_excp_cancel_req = mmu_data_tlb_excp_cancel | cancel_sig;
    assign dcache_sc_cancel_req = 1'b0;
    assign dcache_preld_hint = 5'b0;
    assign dcache_preld_en = 1'b0;

    axi_line_bridge u_axi_line_bridge (
        .clk           (clk),
        .resetn        (resetn),
        .ic_rd_req     (axi_ic_rd_req),
        .ic_rd_type    (axi_ic_rd_type),
        .ic_rd_addr    (axi_ic_rd_addr),
        .ic_rd_rdy     (axi_ic_rd_rdy),
        .ic_ret_valid  (axi_ic_ret_valid),
        .ic_ret_last   (axi_ic_ret_last),
        .ic_ret_data   (axi_ic_ret_data),
        .dc_rd_req     (axi_dc_rd_req),
        .dc_rd_type    (axi_dc_rd_type),
        .dc_rd_addr    (axi_dc_rd_addr),
        .dc_rd_rdy     (axi_dc_rd_rdy),
        .dc_ret_valid  (axi_dc_ret_valid),
        .dc_ret_last   (axi_dc_ret_last),
        .dc_ret_data   (axi_dc_ret_data),
        .dc_wr_req     (axi_dc_wr_req),
        .dc_wr_type    (axi_dc_wr_type),
        .dc_wr_addr    (axi_dc_wr_addr),
        .dc_wr_strb    (axi_dc_wr_strb),
        .dc_wr_data    (axi_dc_wr_data),
        .dc_wr_rdy     (axi_dc_wr_rdy),
        .axi_awvalid   (axi_awvalid_line),
        .axi_awaddr    (axi_awaddr_line),
        .axi_awburst   (axi_awburst_line),
        .axi_awlen     (axi_awlen_line),
        .axi_awsize    (axi_awsize_line),
        .axi_awready   (awready),
        .axi_wvalid    (axi_wvalid_line),
        .axi_wdata     (axi_wdata_line),
        .axi_wstrb     (axi_wstrb_line),
        .axi_wlast     (axi_wlast_line),
        .axi_wready    (wready),
        .axi_bvalid    (bvalid),
        .axi_bresp     (bresp),
        .axi_bready    (axi_bready_line),
        .axi_arvalid   (axi_arvalid_line),
        .axi_araddr    (axi_araddr_line),
        .axi_arburst   (axi_arburst_line),
        .axi_arlen     (axi_arlen_line),
        .axi_arsize    (axi_arsize_line),
        .axi_arready   (arready),
        .axi_rvalid    (rvalid),
        .axi_rdata     (rdata),
        .axi_rresp     (rresp),
        .axi_rlast     (rlast),
        .axi_rready    (axi_rready_line)
    );

    assign arid    = 4'b0000;
    assign araddr  = axi_araddr_line;
    assign arlen   = {4'b0000, axi_arlen_line};
    assign arsize  = axi_arsize_line;
    assign arburst = 2'b01;
    assign arlock  = 2'b00;
    assign arcache = 4'b0011;
    assign arprot  = 3'b000;
    assign arvalid = axi_arvalid_line;
    assign rready  = axi_rready_line;

    assign awid    = 4'b0000;
    assign awaddr  = axi_awaddr_line;
    assign awlen   = {4'b0000, axi_awlen_line};
    assign awsize  = axi_awsize_line;
    assign awburst = 2'b01;
    assign awlock  = 2'b00;
    assign awcache = 4'b0011;
    assign awprot  = 3'b000;
    assign awvalid = axi_awvalid_line;

    assign wid     = 4'b0000;
    assign wdata   = axi_wdata_line;
    assign wstrb   = axi_wstrb_line;
    assign wlast   = axi_wlast_line;
    assign wvalid  = axi_wvalid_line;

    assign bready  = axi_bready_line;


    // CSR 异常/提交路径在 WB 同拍采样 tlb_manager 的查询结果，并在同拍更新 TLB 相关 CSR 域。
    csr_exception_commit_handler u_csr_exception_commit_handler (
        .clk           (clk),
        .reset         (reset),
        .csr_num       (wb_csr_num_csr),
        .csr_rnum      (csr_num_2EXE),
        .csr_we        (csr_commit_we),
        .csr_wmask     (wb_csr_wmask_csr),
        .csr_wvalue    (wb_csr_wvalue_csr),
        .hw_int_in     (8'b0),
        .ipi_int_in    (1'b0),
        .wb_valid      (wb_valid_2csr),
        .wb_pc         (wb_pc),
        .wb_is_ertn    (wb_is_ertn_2csr),
        .wb_vaddr      (wb_vaddr_2csr),
        .wb_ex         (wb_ex_2csr),
        .INT_valid     (wb_int_valid_2csr),
        .ADEF_valid    (wb_adef_valid_2csr),
        .TLB_EX_valid  (wb_tlb_ex_valid),
        .ALE_valid     (wb_ale_valid_2csr),
        .SYS_valid     (wb_sys_valid_2csr),
        .BRK_valid     (wb_brk_valid_2csr),
        .INE_valid     (wb_ine_valid_2csr),
        .wb_tlb_op     (wb_tlb_op),
        .tlbsrch_found (tlbsrch_found),
        .tlbsrch_index (tlbsrch_index),
        .tlbrd_tlbidx  (tlbrd_tlbidx),
        .tlbrd_tlbehi  (tlbrd_tlbehi),
        .tlbrd_tlbelo0 (tlbrd_tlbelo0),
        .tlbrd_tlbelo1 (tlbrd_tlbelo1),
        .tlbrd_asid    (tlbrd_asid),
        .flush_pipeline (csr_flush_pipeline),
        .csr_next_pc   (csr_next_pc),
        .csr_redirect  (csr_redirect),
        .has_int       (csr_has_int),
        .csr_rvalue    (csr_rvalue_unused),
        .csr_tid_out   (csr_tid_to_exe),
        .csr_crmd_da_out(csr_crmd_da),
        .csr_crmd_pg_out(csr_crmd_pg),
        .csr_crmd_plv_out(csr_crmd_plv),
        .csr_asid_out  (csr_asid),
        .csr_tlbidx_out(csr_tlbidx),
        .csr_tlbehi_out(csr_tlbehi),
        .csr_tlbelo0_out(csr_tlbelo0),
        .csr_tlbelo1_out(csr_tlbelo1),
        .csr_dmw0_out  (csr_dmw0),
        .csr_dmw1_out  (csr_dmw1),
        .csr_crmd_datf_out(csr_crmd_datf),
        .csr_crmd_datm_out(csr_crmd_datm),
        .csr_estat_ecode_out(csr_estat_ecode)
    );


    //------------------------------------------------------------------
    // 调试：与参考核一致，报告 WB 级提交（含该指令 PC）
    //------------------------------------------------------------------
    // 由于 WB 级流水寄存器在时钟沿更新，debug 输出需要再寄存一拍，
    // 否则测试平台在 #2 采样时会读到“下一拍”的 WB 内容。
    wire suppress_boot_crmd_trace = WB_valid
        && mwb_we
        && (mwb_pc == 32'h1c00000c)
        && mwb_csr_op[`CSR_OP_CSRWR]
        && (mwb_csr_num == `CSR_CRMD);

    wire raw_debug_commit = rf_commit_we && !suppress_boot_crmd_trace;

    reg [31:0] debug_wb_pc_r;
    reg [3:0]  debug_wb_rf_we_r;
    reg [4:0]  debug_wb_rf_wnum_r;
    reg [31:0] debug_wb_rf_wdata_r;

    always @(posedge clk) begin
        if (reset) begin
            debug_wb_pc_r       <= 32'b0;
            debug_wb_rf_we_r    <= 4'b0;
            debug_wb_rf_wnum_r  <= 5'b0;
            debug_wb_rf_wdata_r <= 32'b0;
        end else if (raw_debug_commit) begin
            debug_wb_pc_r       <= wb_pc;
            debug_wb_rf_we_r    <= {4{1'b1}};
            debug_wb_rf_wnum_r  <= wb_waddr;
            debug_wb_rf_wdata_r <= wb_wdata;
        end else begin
            debug_wb_pc_r       <= 32'b0;
            debug_wb_rf_we_r    <= 4'b0;
            debug_wb_rf_wnum_r  <= 5'b0;
            debug_wb_rf_wdata_r <= 32'b0;
        end
    end

    assign debug_wb_pc       = debug_wb_pc_r;
    assign debug_wb_rf_we    = debug_wb_rf_we_r;
    assign debug_wb_rf_wnum  = debug_wb_rf_wnum_r;
    assign debug_wb_rf_wdata = debug_wb_rf_wdata_r;

    // Spyglass：读未参与 BRAM 控制逻辑的观测/调试用 wire
    wire mycpu_lint_sink;
    assign mycpu_lint_sink = valid | RAW_hazard | IF_allowIn
                            | data_r_wrong | data_w_wrong | inst_r_wrong
                            | data_re_from_EXE | data_we_from_EXE
                            | mem_load_req_sent 
                            | arvalid | awvalid
                            | csr_has_int | (|csr_rvalue_unused);

endmodule
