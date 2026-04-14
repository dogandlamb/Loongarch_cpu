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

    // sram_AXI_bridge：IF/MEM ↔ sram-AXI
    wire [31:0] inst_rdata_2IF;
    wire [31:0] data_rdata_2MEM;
    wire        inst_r_complete;
    wire [31:0] pc_2ID_from_bram;
    wire        adef_valid_2IF;
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

    // CSR相关信号
    wire        csr_flush_pipeline;   // 异常或 ERTN（csr_exception_commit_handler → conflict_handle.csr_flush）
    wire [31:0] csr_next_pc;          // CSR → npc：EENTRY 或 ERTN的返回地址
    wire [1:0]  csr_redirect;         // CSR → npc：区分csr_next_pc类型的标志位信号，给npc仲裁，类型有`CSR_REDIRECT_EX、`CSR_REDIRECT_ERTN、`CSR_REDIRECT_NONE，具体看宏定义
    wire        csr_has_int;          // CSR 中断附着（后续接 ID）
    wire [31:0] csr_rvalue_unused;    // CSR 读返回值（后续接 WB csr 读）
    wire [31:0] csr_tid_to_exe;       // RDCNTID 等：CSR 模块输出的 TID


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
    wire        if_adef_to_ifid;          // IF输出到IF_ID_reg的地址未对齐异常信号ADEF
    wire        if_exception_to_ifid;     // IF输出到IF_ID_reg的异常有效信号EXCEPTION
    wire        adef_ifid_to_id;          // IF_ID_reg输出到ID的地址未对齐异常信号ADEF
    wire        exception_ifid_to_id;     // IF_ID_reg输出到ID的异常有效信号EXCEPTION

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
        .adef_valid_req_out (adef_valid_req_fromIF),
        .adef_valid_in      (adef_valid_2IF),
        .adef_valid_out     (if_adef_to_ifid),
        .exception_valid    (if_exception_to_ifid)
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
        .inst_out              (inst_2ID),
        .pc_out                (pc_2ID),
        .adef_valid_out        (adef_ifid_to_id),
        .exception_valid_out   (exception_ifid_to_id)
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
    wire                   ertn_op_fromID;
    wire                   sys_valid_fromID;
    wire                   brk_valid_fromID;
    wire                   ine_valid_fromID;
    wire [`WB_SRC_NUM-1:0] wb_src_op_fromID;
    wire                   adef_valid_fromID;
    wire [31:0]            if_vaddr_fromID;
    wire                   int_valid_fromID;
    wire                   exception_valid_fromID;

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
        .sys_valid  (sys_valid_fromID),
        .brk_valid  (brk_valid_fromID),
        .ine_valid  (ine_valid_fromID),
        .wb_src_op  (wb_src_op_fromID),
        .adef_valid (adef_valid_fromID),
        .if_vaddr   (if_vaddr_fromID),
        .int_valid  (int_valid_fromID),
        .exception_valid (exception_valid_fromID)
    );

    // IDport 内部通过 get_reg_read_addr 生成读地址，直接驱动 regfile 读端口
    assign rf_raddr1 = id_src1_addr;
    assign rf_raddr2 = id_src2_addr;

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
    wire [`WB_SRC_NUM-1:0] wb_src_op_2EXE;
    wire                   ertn_op_2EXE;
    wire                   sys_valid_2EXE;
    wire                   brk_valid_2EXE;
    wire                   ine_valid_2EXE;
    wire                   adef_valid_2EXE;
    wire [31:0]            if_vaddr_2EXE;
    wire                   int_valid_2EXE;
    wire                   exception_valid_2EXE;

    // 阻塞时在 ID/EXE 边界注入气泡（气泡就是置为0）
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
    wire [`WB_SRC_NUM-1:0]   id2exe_wb_src_op   = block_sig ? {`WB_SRC_NUM{1'b0}} : wb_src_op_fromID;
    wire                     id2exe_ertn_op     = block_sig ? 1'b0 : ertn_op_fromID;
    wire                     id2exe_sys_valid   = block_sig ? 1'b0 : sys_valid_fromID;
    wire                     id2exe_brk_valid   = block_sig ? 1'b0 : brk_valid_fromID;
    wire                     id2exe_ine_valid   = block_sig ? 1'b0 : ine_valid_fromID;
    wire                     id2exe_adef_valid   = block_sig ? 1'b0 : adef_valid_fromID;
    wire [31:0]              id2exe_if_vaddr    = block_sig ? 32'b0 : if_vaddr_fromID;
    wire                     id2exe_int_valid   = block_sig ? 1'b0 : int_valid_fromID;
    wire                     id2exe_exception_valid = block_sig ? 1'b0 : exception_valid_fromID;

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
        .wb_src_op_in    (id2exe_wb_src_op),
        .ertn_op_in      (id2exe_ertn_op),
        .sys_valid_in    (id2exe_sys_valid),
        .brk_valid_in    (id2exe_brk_valid),
        .ine_valid_in    (id2exe_ine_valid),
        .adef_valid_in   (id2exe_adef_valid),
        .int_valid_in    (id2exe_int_valid),
        .exception_valid_in (id2exe_exception_valid),
        .if_vaddr_in     (id2exe_if_vaddr),
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
        .wb_src_op_out   (wb_src_op_2EXE),
        .ertn_op_out     (ertn_op_2EXE),
        .sys_valid_out   (sys_valid_2EXE),
        .brk_valid_out   (brk_valid_2EXE),
        .ine_valid_out   (ine_valid_2EXE),
        .adef_valid_out  (adef_valid_2EXE),
        .if_vaddr_out    (if_vaddr_2EXE),
        .int_valid_out   (int_valid_2EXE),
        .exception_valid_out (exception_valid_2EXE)
    );

    wire br_taken_q;             // EXE 组合分支命中（要冲刷 IF/ID 、要重定向 npc）

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
        .csr_next_pc       (csr_next_pc),
        .csr_redirect      (csr_redirect),
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
        .csr_tid_from_csr (csr_tid_to_exe),
        .wb_src_op_in    (wb_src_op_2EXE),
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
        .ertn_op_out     (exe_ertn_op_to_mem),
        .sys_valid_out   (exe_sys_valid_to_mem),
        .brk_valid_out   (exe_brk_valid_to_mem),
        .ine_valid_out   (exe_ine_valid_to_mem),
        .adef_valid_out  (exe_adef_valid_to_mem),
        .ale_valid_out   (exe_ale_valid_to_mem),
        .int_valid_out   (exe_int_valid_to_mem),
        .exception_valid_out (exe_exception_valid_to_mem),
        .if_vaddr_out    (exe_if_vaddr_to_mem),
        .ale_vaddr_out   (exe_ale_vaddr_to_mem)
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

    wire [31:0] em_data_wdata;

    wire [`CSR_OP_NUM-1:0] em_csr_op;
    wire [11:0]            em_csr_num;
    wire [31:0]            em_csr_wmask;
    wire [31:0]            em_csr_wvalue;
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
        .wb_src_op_in    (exe_wb_src_op_to_mem),
        .ertn_op_in      (exe_ertn_op_to_mem),
        .sys_valid_in    (exe_sys_valid_to_mem),
        .brk_valid_in    (exe_brk_valid_to_mem),
        .ine_valid_in    (exe_ine_valid_to_mem),
        .adef_valid_in   (exe_adef_valid_to_mem),
        .ale_valid_in    (exe_ale_valid_to_mem),
        .int_valid_in    (exe_int_valid_to_mem),
        .exception_valid_in (exe_exception_valid_to_mem),
        .if_vaddr_in     (exe_if_vaddr_to_mem),
        .ale_vaddr_in    (exe_ale_vaddr_to_mem),
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
        .wb_src_op_out   (em_wb_src_op),
        .ertn_op_out     (em_ertn_op),
        .sys_valid_out   (em_sys_valid),
        .brk_valid_out   (em_brk_valid),
        .ine_valid_out   (em_ine_valid),
        .adef_valid_out  (em_adef_valid),
        .ale_valid_out   (em_ale_valid),
        .int_valid_out   (em_int_valid),
        .exception_valid_out (em_exception_valid),
        .if_vaddr_out    (em_if_vaddr),
        .ale_vaddr_out   (em_ale_vaddr)
    );

    wire        MEM_readyGo;      // MEM 阶段就绪
    wire        mem_load_hazard;   // MEMport：load 槽尚未就绪，供 RAW（勿用顶层 ~MEM_readyGo 与反馈环）
    wire [31:0] mem_wb_wdata;     // MEM 输出到 WB 的写回数据
    wire [31:0] mem_pc_2WB;       // MEM 输出到 WB 的 PC
    wire [4:0]  mem_wb_regaddr;   // MEM 输出到 WB 的目的寄存器号
    wire        mem_wb_op;        // MEM 输出到 WB 的写回使能

    wire data_w_complete;   // 数据写完成脉冲
    wire data_r_complete;   // 数据读完成脉冲

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

    wire [`CSR_OP_NUM-1:0] mem_csr_op;
    wire [11:0]            mem_csr_num;
    wire [31:0]            mem_csr_wmask;
    wire [31:0]            mem_csr_wvalue;
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
        .data_rdata_2MEM(data_rdata_2MEM),
        .data_raddr_from_EXE(em_data_raddr),
        .data_waddr_from_EXE(em_data_waddr),
        .data_w_complete(data_w_complete),
        .data_r_complete(data_r_complete),
        .csr_op_in      (em_csr_op),
        .csr_num_in     (em_csr_num),
        .csr_wmask_in   (em_csr_wmask),
        .csr_wvalue_in  (em_csr_wvalue),
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
        .csr_op_out     (mem_csr_op),
        .csr_num_out    (mem_csr_num),
        .csr_wmask_out  (mem_csr_wmask),
        .csr_wvalue_out (mem_csr_wvalue),
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
        .ale_vaddr_out  (mem_ale_vaddr)
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
    wire        WB_valid;          // WB 阶段有效位
    wire [31:0] mwb_wdata;         // MEM_WB_reg 输出写回数据
    wire [4:0]  mwb_waddr;         // MEM_WB_reg 输出写回寄存器号
    wire        mwb_we;            // MEM_WB_reg 输出写回使能
    wire [31:0] mwb_pc;            // MEM_WB_reg 输出提交 PC
    wire [`CSR_OP_NUM-1:0] mwb_csr_op;
    wire [11:0]            mwb_csr_num;
    wire [31:0]            mwb_csr_wmask;
    wire [31:0]            mwb_csr_wvalue;
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
        .wb_src_op_in    (mem_wb_src_op),
        .ertn_op_in      (mem_ertn_op),
        .sys_valid_in    (mem_sys_valid),
        .brk_valid_in    (mem_brk_valid),
        .ine_valid_in    (mem_ine_valid),
        .adef_valid_in   (mem_adef_valid),
        .int_valid_in    (mem_int_valid),
        .ale_valid_in    (mem_ale_valid),
        .exception_valid_in (mem_exception_valid),
        .if_vaddr_in     (mem_if_vaddr),
        .ale_vaddr_in    (mem_ale_vaddr),
        .wb_wdata_out    (mwb_wdata),
        .wb_reg_addr_out (mwb_waddr),
        .wb_op_out       (mwb_we),
        .pc_out          (mwb_pc),
        .csr_op_out      (mwb_csr_op),
        .csr_num_out     (mwb_csr_num),
        .csr_wmask_out   (mwb_csr_wmask),
        .csr_wvalue_out  (mwb_csr_wvalue),
        .wb_src_op_out   (mwb_wb_src_op),
        .ertn_op_out     (mwb_ertn_op),
        .sys_valid_out   (mwb_sys_valid),
        .brk_valid_out   (mwb_brk_valid),
        .ine_valid_out   (mwb_ine_valid),
        .adef_valid_out  (mwb_adef_valid),
        .ale_valid_out   (mwb_ale_valid),
        .int_valid_out   (mwb_int_valid),
        .exception_valid_out (mwb_exception_valid),
        .if_vaddr_out    (mwb_if_vaddr),
        .ale_vaddr_out   (mwb_ale_vaddr)
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
        .allowIn       (wb_allowIn),
        .wb_wdata_out  (wb_wdata),
        .pc_out        (wb_pc),
        .wb_reg_addr_out(wb_waddr),
        .wb_op_out     (wb_we),
        .csr_op_out    (wb_csr_op_csr),
        .csr_num_out   (wb_csr_num_csr),
        .csr_wmask_out (wb_csr_wmask_csr),
        .csr_wvalue_out(wb_csr_wvalue_csr),
        .wb_ex_2csr    (wb_ex_2csr),
        .wb_valid_2csr (wb_valid_2csr),
        .wb_is_ertn_2csr(wb_is_ertn_2csr),
        .wb_vaddr_out  (wb_vaddr_2csr),
        .int_valid_out_2csr (wb_int_valid_2csr),
        .adef_valid_out_2csr(wb_adef_valid_2csr),
        .ale_valid_out_2csr (wb_ale_valid_2csr),
        .sys_valid_out_2csr (wb_sys_valid_2csr),
        .brk_valid_out_2csr (wb_brk_valid_2csr),
        .ine_valid_out_2csr (wb_ine_valid_2csr)
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
        .hit_exe_rs1   (hit_exe_rs1),
        .hit_mem_rs1   (hit_mem_rs1),
        .hit_wb_rs1    (hit_wb_rs1),
        .hit_exe_rs2   (hit_exe_rs2),
        .hit_mem_rs2   (hit_mem_rs2),
        .hit_wb_rs2    (hit_wb_rs2)
    );

    wire mem_stage_is_load = mem_load_hazard;
    wire exe_stage_is_load = EXE_valid
                              & (exe_mem_op[`MEM_OP_LD_W] | exe_mem_op[`MEM_OP_LD_H] | exe_mem_op[`MEM_OP_LD_B]
                              |  exe_mem_op[`MEM_OP_LD_HU] | exe_mem_op[`MEM_OP_LD_BU]);
                              
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
        .RAW_hazard  (RAW_hazard),
        .block_sig   (block_sig),
        .stall       (stall),
        .cancel_sig  (cancel_sig),
        .FD_EXE_2rs1_sig  (FD_EXE_2rs1_sig),
        .FD_MEM_2rs1_sig  (FD_MEM_2rs1_sig),
        .FD_WB_2rs1_sig   (FD_WB_2rs1_sig),
        .FD_EXE_2rs2_sig  (FD_EXE_2rs2_sig),
        .FD_MEM_2rs2_sig  (FD_MEM_2rs2_sig),
        .FD_WB_2rs2_sig   (FD_WB_2rs2_sig)
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
        .IF_readyGo         (IF_readyGo),
        .ID_readyGo         (ID_readyGo),
        .EXE_readyGo        (EXE_readyGo),
        .MEM_readyGo        (MEM_readyGo),
        .WB_allowIn         (wb_allowIn),
        .ID_allowIn         (ID_allowIn),
        .EXE_allowIn        (EXE_allowIn),
        .MEM_allowIn        (MEM_allowIn),
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

    // sram_AXI_bridge：IF 发起取指 / MEM 访存 → AXI；指令与 PC 在 AR/R 完成后交回（多拍延迟）
    sram_AXI_bridge u_sram_AXI_bridge (
        .clk                  (clk),
        .reset                (reset),
        .inst_re_in_from_IF   (IF_valid & IF_ID_reg_allowIn),
        .data_we_in_from_EXE  (data_we_issue_st),
        .data_re_in_from_EXE  (data_re_issue_ld),
        .pc_in_from_IF        (pc_2ram_data_controller),
        .data_raddr_from_EXE  (em_data_raddr),
        .data_waddr_from_EXE  (em_data_waddr),
        .data_wdata_from_EXE  (em_data_wdata),
        .data_byte_en_from_EXE(em_data_wbyte_en),
        .adef_valid_in_from_IF(adef_valid_req_fromIF),
        .inst_rdata_2IF       (inst_rdata_2IF),
        .adef_valid_2IF       (adef_valid_2IF),
        .data_rdata_2MEM      (data_rdata_2MEM),
        .data_w_wrong         (data_w_wrong),
        .data_r_wrong         (data_r_wrong),
        .inst_r_wrong         (inst_r_wrong),
        .axi_if_busy          (axi_if_busy),
        .data_w_complete      (data_w_complete),
        .data_r_complete      (data_r_complete),
        .inst_r_complete      (inst_r_complete),
        .pc_out_2ID           (pc_2ID_from_bram),
        .arid                 (arid),
        .araddr               (araddr),
        .arlen                (arlen),
        .arsize               (arsize),
        .arburst              (arburst),
        .arlock               (arlock),
        .arcache              (arcache),
        .arprot               (arprot),
        .arvalid              (arvalid),
        .arready              (arready),
        .rid                  (rid),
        .rdata                (rdata),
        .rresp                (rresp),
        .rlast                (rlast),
        .rvalid               (rvalid),
        .rready               (rready),
        .awid                 (awid),
        .awaddr               (awaddr),
        .awlen                (awlen),
        .awsize               (awsize),
        .awburst              (awburst),
        .awlock               (awlock),
        .awcache              (awcache),
        .awprot               (awprot),
        .awvalid              (awvalid),
        .awready              (awready),
        .wid                  (wid),
        .wdata                (wdata),
        .wstrb                (wstrb),
        .wlast                (wlast),
        .wvalid               (wvalid),
        .wready               (wready),
        .bid                  (bid),
        .bresp                (bresp),
        .bvalid               (bvalid),
        .bready               (bready)
    );


    csr_exception_commit_handler u_csr_exception_commit_handler (
        .clk           (clk),
        .reset         (reset),
        .csr_num       (wb_csr_num_csr),
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
        .ALE_valid     (wb_ale_valid_2csr),
        .SYS_valid     (wb_sys_valid_2csr),
        .BRK_valid     (wb_brk_valid_2csr),
        .INE_valid     (wb_ine_valid_2csr),
        .flush_pipeline (csr_flush_pipeline),
        .csr_next_pc   (csr_next_pc),
        .csr_redirect  (csr_redirect),
        .has_int       (csr_has_int),
        .csr_rvalue    (csr_rvalue_unused),
        .csr_tid_out   (csr_tid_to_exe)
    );


    //------------------------------------------------------------------
    // 调试：与参考核一致，报告 WB 级提交（含该指令 PC）
    //------------------------------------------------------------------
    // 由于 WB 级流水寄存器在时钟沿更新，debug 输出需要再寄存一拍，
    // 否则测试平台在 #2 采样时会读到“下一拍”的 WB 内容。
    wire raw_debug_commit = rf_commit_we;

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

    // 定点观测已知失配窗口的 load/use、取指返回与访存握手行为
    wire mycpu_dbg_hit = (pc_2ID >= 32'h1c010380 && pc_2ID <= 32'h1c01039c)
                      || (pc_2ID >= 32'h1c018360 && pc_2ID <= 32'h1c0183a0)
                      || (pc_2ID >= 32'h1c02e7f0 && pc_2ID <= 32'h1c02e830)
                      || (pc_2ID >= 32'h1c0671f0 && pc_2ID <= 32'h1c067260)
                      || (pc_2ID >= 32'h1c06e020 && pc_2ID <= 32'h1c06e140)
                      || (wb_pc >= 32'h1c010390 && wb_pc <= 32'h1c01039c)
                      || (wb_pc >= 32'h1c018360 && wb_pc <= 32'h1c0183a0)
                      || (wb_pc >= 32'h1c02e7f0 && wb_pc <= 32'h1c02e830)
                      || (wb_pc >= 32'h1c0671f0 && wb_pc <= 32'h1c067260)
                      || (wb_pc >= 32'h1c06e020 && wb_pc <= 32'h1c06e140)
                      || (em_pc >= 32'h1c010390 && em_pc <= 32'h1c01039c)
                      || (em_pc >= 32'h1c018360 && em_pc <= 32'h1c0183a0)
                      || (em_pc >= 32'h1c02e7f0 && em_pc <= 32'h1c02e830)
                      || (em_pc >= 32'h1c0671f0 && em_pc <= 32'h1c067260)
                      || (em_pc >= 32'h1c06e020 && em_pc <= 32'h1c06e140);

        always @(posedge clk) begin
            if (!reset && mycpu_dbg_hit) begin
                        $display("IDMEMDBG pc2id=0x%8h inst=0x%8h rs1=%0d rs2=%0d rf1=0x%8h rf2=0x%8h id1=0x%8h id2=0x%8h | idmw=0x%8h i2e_mw=0x%8h e_mw=0x%8h em_mw=0x%8h em_dw=0x%8h | hitE=%0d/%0d hitM=%0d/%0d hitW=%0d/%0d stall=%0d block=%0d exLd=%0d memLd=%0d | em_pc=0x%8h em_rd=%0d em_wb=%0d em_ld=%0d em_mop=0x%2h em_raddr=0x%8h em_waddr=0x%8h slot=%0d ldreq=%0d ldmatch=%0d mvalid=%0d mready=%0d mallow=%0d mem_wb=0x%8h dcmp=%0d dr=0x%8h | wb_pc=0x%8h wb_rd=%0d wb_we=%0d wb_data=0x%8h | ifret_pc=0x%8h ifret_inst=0x%8h ifret_ok=%0d ifid_allow=%0d if_pc=0x%8h if_npc=0x%8h | v=%0d/%0d/%0d/%0d/%0d ex_pc=0x%8h",
                                         pc_2ID, inst_2ID, rf_raddr1, rf_raddr2,
                                         rf_rdata1, rf_rdata2, ID_src1_rdata, ID_src2_rdata,
                                         mem_wdata_fromID, id2exe_mem_wdata, mem_wdata_2EXE, exe_mem_wdata, em_data_wdata,
                                         hit_exe_rs1, hit_exe_rs2,
                                         hit_mem_rs1, hit_mem_rs2,
                                         hit_wb_rs1, hit_wb_rs2,
                                         stall, block_sig,
                                         exe_stage_is_load, mem_stage_is_load,
                                         em_pc, em_wb_reg, em_wb_op, ld_in_mem, em_mem_op,
                                         em_data_raddr, em_data_waddr, em_slot_tag, data_re_issue_ld, ld_slot_match,
                                         MEM_valid, MEM_readyGo, MEM_allowIn, mem_wb_wdata,
                                         data_r_complete, data_rdata_2MEM,
                                         wb_pc, wb_waddr, rf_commit_we, wb_wdata,
                                         pc_2ID_from_bram, inst_rdata_2IF, inst_r_complete, IF_ID_reg_allowIn,
                                         pc, nextpc,
                                         IF_valid, ID_valid, EXE_valid, MEM_valid, WB_valid, exe_pc_2MEM);
                end
        end

        always @(posedge clk) begin
            if (!reset && raw_debug_commit && (wb_waddr == 5'd14) && (wb_wdata[31:16] == 16'hb4f0)) begin
                $display("R14WDBG wb_pc=0x%8h wb_data=0x%8h em_pc=0x%8h em_rd=%0d em_wb=%0d em_memwb=0x%8h",
                         wb_pc, wb_wdata, em_pc, em_wb_reg, em_wb_op, mem_wb_wdata);
            end
        end

    // Spyglass：读未参与 BRAM 控制逻辑的观测/调试用 wire
    wire mycpu_lint_sink;
    assign mycpu_lint_sink = valid | RAW_hazard | IF_allowIn
                            | data_r_wrong | data_w_wrong | inst_r_wrong
                            | data_re_from_EXE | data_we_from_EXE
                            | mem_load_req_sent 
                            | arvalid | awvalid
                            | csr_has_int | (|csr_rvalue_unused);

endmodule
