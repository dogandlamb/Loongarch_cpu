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
        .pc_req_out         (pc_2ram_data_controller), // 发往sram_AXI_bridge的请求 PC
        .inst_out           (inst_fromIF),             // 送 IF_ID_reg 的指令
        .pc_inst_out        (pc_fromIF)                // 送 IF_ID_reg 的 PC
    );          

    wire [31:0] inst_2ID;        // IF_ID_reg 输出到 ID 的指令
    wire [31:0] pc_2ID;          // IF_ID_reg 输出到 ID 的 PC

    IF_ID_reg u_IF_ID_reg(
        .clk     (clk),
        .reset   (reset),
        .cancel_sig(cancel_sig),
        .valid   (IF_ID_reg_valid),
        .readyGo (IF_readyGo),
        .allowIn (IF_ID_reg_allowIn),
        .pc_in   (pc_fromIF),
        .inst_in (inst_fromIF),
        .inst_out(inst_2ID),
        .pc_out  (pc_2ID)
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

    //由前递模块返回的读取数据，可能为寄存器读取或者前递的数据
    wire [31:0] ID_src1_rdata;
    wire [31:0] ID_src2_rdata;

    IDport u_IDport(
        .reset      (reset),
        .valid      (ID_valid),
        .stall      (stall),
        .inst       (inst_2ID),
        .pc_in      (pc_2ID),
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
        .wb_op      (wb_op_fromID)
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
        .wb_reg_addr_out (wb_reg_addr_2EXE),
        .alu_src1_out    (alu_src1_2EXE),
        .alu_src2_out    (alu_src2_2EXE),
        .br_imm_out      (br_imm_2EXE),
        .alu_op_out      (alu_op_2EXE),
        .mem_wdata_out   (mem_wdata_2EXE),
        .br_op_out       (br_op_2EXE),
        .mem_op_out      (mem_op_2EXE),
        .wb_op_out       (wb_op_2EXE),
        .pc_out          (pc_exe)
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

    EXEport u_EXEport(
        .clk             (clk),
        .reset           (reset),
        .valid           (EXE_valid),
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
        .readyGo         (EXE_readyGo),
        .allowIn         (EXE_allowIn),
        .br_taken        (br_taken_q),
        .exe_alu_or_addr (exe_alu_or_addr),
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
        .data_wbyte_en_from_EXE (data_wbyte_en_from_EXE) 
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
        .pc_out          (em_pc)
    );

    wire        MEM_readyGo;      // MEM 阶段就绪
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

    MEMport u_MEMport(
        .clk            (clk),
        .reset          (reset),
        .valid          (MEM_valid),
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
        .readyGo        (MEM_readyGo),
        .allowIn        (MEM_allowIn),
        .wb_wdata       (mem_wb_wdata),
        .pc_out         (mem_pc_2WB),
        .wb_reg_addr_out(mem_wb_regaddr),
        .wb_op_out      (mem_wb_op)
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
        .wb_wdata_out    (mwb_wdata),
        .wb_reg_addr_out (mwb_waddr),
        .wb_op_out       (mwb_we),
        .pc_out          (mwb_pc)
    );

    wire wb_allowIn;              // WB 阶段 allowIn（常 1）
    wire [31:0] wb_wdata;         // WB 最终写回数据（到 regfile/debug）
    wire [31:0] wb_pc;            // WB 最终提交 PC（到 debug）
    wire [4:0]  wb_waddr;         // WB 最终写回寄存器号
    wire        wb_we;            // WB 最终写回使能

    WBport u_WBport(
        .reset         (reset),
        .valid         (WB_valid),
        .wb_wdata_in   (mwb_wdata),
        .pc_in         (mwb_pc),
        .wb_reg_addr_in(mwb_waddr),
        .wb_op_in      (mwb_we),
        .allowIn       (wb_allowIn),
        .wb_wdata_out  (wb_wdata),
        .pc_out        (wb_pc),
        .wb_reg_addr_out(wb_waddr),
        .wb_op_out     (wb_we)
    );

    wire rf_we = wb_we & (wb_waddr != 5'd0); // 屏蔽对 r0 的写入

    //连续两拍同一PC且都写寄存器时，认为是重复提交，第二拍 rf_commit_we 拉低，避免 regfile 被写两次（与 debug 去重思路一致）
    reg  last_wb_commit; //记录「上一拍是否写寄存器」
    reg  [31:0] last_wb_pc; //记录「上一拍写寄存器的 PC」
    wire wb_commit_dup = rf_we && last_wb_commit && (wb_pc == last_wb_pc); // 连续两拍同一PC且都写寄存器时，认为是重复提交
    wire rf_commit_we = rf_we && !wb_commit_dup; // 排除重复提交后，允许写寄存器

    always @(posedge clk) begin
        if (reset) begin
            last_wb_commit <= 1'b0;
            last_wb_pc     <= 32'b0;
        end else begin
            last_wb_commit <= rf_we;
            if (rf_we) begin
                last_wb_pc <= wb_pc;
            end
        end
    end

    regfile u_regfile(
        .clk    (clk),
        .raddr1 (rf_raddr1),
        .rdata1 (rf_rdata1),
        .raddr2 (rf_raddr2),
        .rdata2 (rf_rdata2),
        .we     (rf_commit_we), // 用的就是排除重复提交后，允许写寄存器的rf_commit_we信号
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
        .wb_wb         (rf_commit_we),
        .hit_exe_rs1   (hit_exe_rs1),
        .hit_mem_rs1   (hit_mem_rs1),
        .hit_wb_rs1    (hit_wb_rs1),
        .hit_exe_rs2   (hit_exe_rs2),
        .hit_mem_rs2   (hit_mem_rs2),
        .hit_wb_rs2    (hit_wb_rs2)
    );

    wire mem_stage_is_load = MEM_valid
                              & (em_mem_op[`MEM_OP_LD_W] | em_mem_op[`MEM_OP_LD_H] | em_mem_op[`MEM_OP_LD_B]
                              |  em_mem_op[`MEM_OP_LD_HU] | em_mem_op[`MEM_OP_LD_BU])
                              & ~data_r_complete;
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


    // SRAM_AXI_bridge数据交互：
    // IF 在允许时发起取指请求；
    // 指令与PC 由桥在 AR/R 完成后 通过 inst_r_complete / inst_rdata_2IF / pc_out_2ID 交回
    // 会有多拍延迟
    wire data_w_wrong;
    wire data_r_wrong;
    wire inst_r_wrong;

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
        .inst_rdata_2IF       (inst_rdata_2IF),
        .data_rdata_2MEM      (data_rdata_2MEM),
        .data_w_wrong         (data_w_wrong),
        .data_r_wrong         (data_r_wrong),
        .inst_r_wrong         (inst_r_wrong),
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

    // CSR / 异常提交：WB 异常与 ERTN 等信号后续从译码/提交逻辑接入；现默认无异常无 ERTN
    csr_exception_commit_handler u_csr_exception_commit_handler (
        .clk           (clk),
        .reset         (reset),
        .csr_num       (12'b0),
        .csr_we        (1'b0),
        .csr_wmask     (32'b0),
        .csr_wvalue    (32'b0),
        .hw_int_in     (8'b0),
        .ipi_int_in    (1'b0),
        .wb_valid      (WB_valid),
        .wb_pc         (wb_pc),
        .wb_is_ertn    (1'b0),
        .wb_vaddr      (32'b0),
        .wb_ex         (1'b0),
        .INT_valid     (1'b0),
        .ADEF_valid    (1'b0),
        .ALE_valid     (1'b0),
        .SYS_valid     (1'b0),
        .BRK_valid     (1'b0),
        .INE_valid     (1'b0),
        .flush_pipeline (csr_flush_pipeline),
        .csr_next_pc   (csr_next_pc),
        .csr_redirect  (csr_redirect),
        .has_int       (csr_has_int),
        .csr_rvalue    (csr_rvalue_unused)
    );


    //------------------------------------------------------------------
    // 调试：与参考核一致，报告 WB 级提交（含该指令 PC）
    //------------------------------------------------------------------
    // 可以不用管，毕竟只是调试用的
    wire raw_debug_commit = rf_commit_we;
    reg  last_debug_commit;
    reg  [31:0] last_debug_pc;
    wire debug_commit_dup = raw_debug_commit && last_debug_commit
                          && (wb_pc == last_debug_pc);

    always @(posedge clk) begin
        if (reset) begin
            last_debug_commit <= 1'b0;
            last_debug_pc     <= 32'b0;
        end else begin
            last_debug_commit <= raw_debug_commit;
            if (raw_debug_commit)
                last_debug_pc <= wb_pc;
        end
    end

    assign debug_wb_pc       = wb_pc & {32{raw_debug_commit & !debug_commit_dup}};
    assign debug_wb_rf_we    = {4{raw_debug_commit & !debug_commit_dup}};
    assign debug_wb_rf_wnum  = wb_waddr & {5{raw_debug_commit & !debug_commit_dup}};
    assign debug_wb_rf_wdata = wb_wdata & {32{raw_debug_commit & !debug_commit_dup}};

    // Spyglass：读未参与 BRAM 控制逻辑的观测/调试用 wire
    wire mycpu_lint_sink;
    assign mycpu_lint_sink = valid | RAW_hazard | IF_allowIn
                            | data_r_wrong | data_w_wrong | inst_r_wrong
                            | data_re_from_EXE | data_we_from_EXE
                            | mem_load_req_sent 
                            | arvalid | awvalid
                            | csr_has_int | (|csr_rvalue_unused);

endmodule
