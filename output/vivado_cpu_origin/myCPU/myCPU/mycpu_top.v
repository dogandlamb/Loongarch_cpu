// ============================================================
// 顶层模块：mycpu_top
// ------------------------------------------------------------
// 功能：
// - 组织 IF/ID/EXE/MEM/WB 五级流水，连接各级端口模块与级间流水寄存器。
// - 统一管理阻塞与冲刷：RAW 冲突阻塞 + 分支重定向冲刷。
// - 对接指令 SRAM / 数据 SRAM 接口，并输出 WB 提交调试总线。
//
// 端口定义：
// - 时钟复位：
//   - clk/resetn：系统时钟与低有效复位。
// - 指令存储接口：
//   - inst_sram_*：IF 阶段取指地址与读数据接口。
// - 数据存储接口：
//   - data_sram_*：MEM 阶段读写数据与地址接口。
// - 调试提交接口：
//   - debug_wb_*：与参考核对齐的 WB 提交通道（PC/写使能/写寄存器/写数据）。
//
// 与其他模块关系：
// - 前端：pc + npc + IFport + IF_ID_reg。
// - 译码：IDport（内部含 inst_dec/get_reg_read_addr/imm_generator/op_dec）+ regfile。
// - 执行：ID_EXE_reg + EXEport + alu。
// - 访存：EXE_MEM_reg + MEMport。
// - 写回：MEM_WB_reg + WBport。
// - 控制：conflict_detector + pipeline_controller（配合 top 的 stall/bubble mux）。
// ============================================================
`include "cpu_defs.vh"

module mycpu_top(
    input  wire        clk,
    input  wire        resetn,

    output wire        inst_sram_en,   //改成bram后新增的输出
    output wire [3:0]  inst_sram_we,
    output wire [31:0] inst_sram_addr,
    output wire [31:0] inst_sram_wdata,
    input  wire [31:0] inst_sram_rdata,

    output wire        data_sram_en,   //改成bram后新增的输出
    output wire [3:0]  data_sram_we,
    output wire [31:0] data_sram_addr,
    output wire [31:0] data_sram_wdata,
    input  wire [31:0] data_sram_rdata,

    output wire [31:0] debug_wb_pc,
    output wire [ 3:0] debug_wb_rf_we,
    output wire [ 4:0] debug_wb_rf_wnum,
    output wire [31:0] debug_wb_rf_wdata
);
    parameter BR_OP_NUM = 5;
    parameter ALU_OP_NUM = 12;
    // 同步高有效复位（由外部低有效复位 resetn 翻转得到）
    reg reset;
    always @(posedge clk) reset <= ~resetn;

    // 顶层保留全局 valid（当前不直接参与流水控制，供后续扩展）
    reg valid;
    always @(posedge clk) begin
        if (reset) valid <= 1'b0;
        else       valid <= 1'b1;
    end

    //------------------------------------------------------------------
    // IF
    //------------------------------------------------------------------
    // ---------------- 信号速查（IF/控制） ----------------
    wire [31:0] pc;              // 当前取指 PC（pc 模块输出）
    wire [31:0] nextpc;          // npc 计算得到的下一拍 PC
    wire [31:0] pc_exe;          // EXE 级当前指令 PC（分支重定向基准）

    wire        stall;           // 顶层统一阻塞信号（当前等价于 block_sig）
    wire        pc_stall;        // PC 寄存器保持信号（阻塞且非分支重定向时拉高）
    wire        hit_exe_rs1;         // 执行阶段冲突1
    wire        hit_mem_rs1;         // 访存阶段冲突1
    wire        hit_wb_rs1;          // 写回阶段冲突1
    wire        hit_exe_rs2;         // 执行阶段冲突2
    wire        hit_mem_rs2;         // 访存阶段冲突2
    wire        hit_wb_rs2;          // 写回阶段冲突2
    wire        raw_hazard;      // conflict_handle 给出的 RAW 冲突检测结果
    wire        block_sig;       // 送入 controller/npc 的阻塞主信号
    wire        cancel_sig;      // 分支冲刷信号（清 IF/ID、ID/EXE）

    pc u_pc(
        .clk    (clk),
        .reset  (reset),
        .stall  (pc_stall),
        .nextpc (nextpc),
        .pc     (pc)
    );

    // bram_data_stream_controller 相关信号（统一管理 IF/MEM 访问 BRAM）
    wire        bram_inst_re;
    wire        bram_data_we;
    wire        bram_data_re;
    wire [31:0] bram_inst_addr;
    wire [31:0] bram_data_raddr;
    wire [31:0] bram_data_waddr;
    wire [31:0] bram_data_wdata;
    wire [31:0] inst_rdata_2IF;
    wire [31:0] data_rdata_2MEM;
    wire        inst_r_complete;
    wire [31:0] pc_2ID_from_bram;

    wire        IF_readyGo;      // IF 阶段就绪
    wire        IF_allowIn;      // IF 阶段允许接收（当前 IFport 常 1）

    wire [31:0] pc_2ram_data_controller;       // IF 当前请求 PC（pc1）
    wire [31:0] inst_fromIF;     // IF 输出指令（送 IF_ID_reg, pc2对齐）
    wire [31:0] pc_fromIF;       // IF 输出 PC（送 IF_ID_reg, pc2对齐）

    wire        IF_valid;        // IF 阶段有效位（controller 输出）
    wire        IF_ID_reg_valid; // IF_ID_reg 输入 valid
    wire        IF_ID_reg_allowIn;// IF_ID_reg 允许写入

    IFport u_IFport(
        .clk     (clk),
        .reset   (reset),
        .valid   (IF_valid),

        .pc_1in  (pc),            // 本拍要发起取指请求对应的 PC（pc1）
        .inst_in (inst_rdata_2IF),// 控制器返回的指令数据
        .pc_2in  (pc_2ID_from_bram),
        .inst_valid_in(inst_r_complete),
        .cancel_in(cancel_sig),
        .downstream_allowIn(IF_ID_reg_allowIn),
        .readyGo (IF_readyGo),
        .allowIn (IF_allowIn),
        .pc_1out  (pc_2ram_data_controller),    // 发往bram_data_stream_controller的请求 PC（pc1）
        .inst_out (inst_fromIF),                // 送 IF_ID_reg 的指令（与 pc2 对齐）
        .pc_2out  (pc_fromIF)                   // 送 IF_ID_reg 的 PC（pc2）
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
    wire [4:0] rf_raddr1;        // regfile 读端口1地址（来自 IDport）
    wire [4:0] rf_raddr2;        // regfile 读端口2地址（来自 IDport）

    wire [31:0] rf_rdata1;       // regfile 读端口1数据
    wire [31:0] rf_rdata2;       // regfile 读端口2数据

    wire        ID_readyGo;      // ID 阶段就绪
    wire        ID_allowIn;      // ID 阶段允许接收
    wire        ID_valid;        // ID 阶段有效位
    wire [4:0]  id_src1_addr;    // ID 实际使用的 src1 地址（调试/观测）
    wire [4:0]  id_src2_addr;    // ID 实际使用的 src2 地址（调试/观测）
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

    wire [31:0] ID_src1_rdata;
    wire [31:0] ID_src2_rdata;//由前递模块返回的读取数据，可能为寄存器读取或者前递的数据

    IDport u_IDport(
        .clk        (clk),
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


    wire        ID_EXE_reg_valid; // ID_EXE_reg 输入 valid
    wire        ID_EXE_reg_allowIn;// ID_EXE_reg 允许写入
    wire [4:0]  wb_reg_addr_2EXE; // ID_EXE_reg 输出目的寄存器号
    wire [31:0] alu_src1_2EXE;    // ID_EXE_reg 输出 EXE 源1
    wire [31:0] alu_src2_2EXE;    // ID_EXE_reg 输出 EXE 源2
    wire [31:0] br_imm_2EXE;      // ID_EXE_reg 输出分支偏移
    wire [`ALU_OP_NUM-1:0] alu_op_2EXE;      // ID_EXE_reg 输出 ALU 操作码
    wire [31:0] mem_wdata_2EXE;   // ID_EXE_reg 输出 store 数据
    wire [`BR_OP_NUM-1:0]  br_op_2EXE;       // ID_EXE_reg 输出分支控制
    wire [`MEM_OP_NUM-1:0]  mem_op_2EXE;      // ID_EXE_reg 输出访存控制
    wire        wb_op_2EXE;       // ID_EXE_reg 输出写回使能

    // 阻塞时在 ID/EXE 边界注入气泡，打断 load-use 自阻塞环
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

    wire br_taken_q;             // EXE 组合分支命中（用于重定向/冲刷）
    wire npc_br_taken;           // 送 npc 的分支命中信号
    wire npc_br_taken_safe;      // 对 X 容错后的分支命中
    wire [`BR_OP_NUM-1:0]  npc_br_op;       // 送 npc 的分支类型编码
    wire [31:0] npc_br_offs;     // 送 npc 的分支偏移
    wire [31:0] npc_rj_value;    // 送 npc 的 jirl 基址（rj）
    wire [31:0] npc_pc_in;       // 送 npc 的分支/顺序执行基准 PC

    assign npc_br_taken = br_taken_q;
    assign npc_br_taken_safe = (npc_br_taken === 1'b1);
    assign npc_br_op    = br_op_2EXE;
    assign npc_br_offs  = br_imm_2EXE;
    assign npc_rj_value = alu_src1_2EXE;
    assign pc_stall     = ((block_sig === 1'b1) && (!npc_br_taken_safe))
                    || (IF_ID_reg_allowIn === 1'b0);

    // 通过 npc 统一做 nextpc 选择，阻塞时保持当前 pc。
    assign npc_pc_in = npc_br_taken_safe ? pc_exe : pc;

    npc u_npc(
        .valid    (IF_valid),
        .br_taken (npc_br_taken),
        .br_op    (npc_br_op),
        .br_offs  (npc_br_offs),
        .rj_value (npc_rj_value),
        .pc       (npc_pc_in),
        .block_sig(block_sig),
        .nextpc   (nextpc)
    );

    //------------------------------------------------------------------
    // EXE
    //------------------------------------------------------------------
    wire        EXE_readyGo;      // EXE 阶段就绪
    wire        EXE_allowIn;      // EXE 阶段允许接收
    wire        EXE_valid;        // EXE 阶段有效位
    wire [31:0] exe_final_result; // EXE 结果（ALU 或 link pc+4）
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

    EXEport u_EXEport(
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
        .final_result    (exe_final_result),
        .pc_out          (exe_pc_2MEM),
        .wb_reg_addr_out (exe_wb_reg_addr),
        .mem_op          (exe_mem_op),
        .mem_wdata_out   (exe_mem_wdata),
        .wb_op           (exe_wb_op),
        .data_we_from_EXE (data_we_from_EXE),
        .data_re_from_EXE (data_re_from_EXE),
        .data_raddr_from_EXE (data_raddr_from_EXE),
        .data_waddr_from_EXE (data_waddr_from_EXE),
        .data_wdata_from_EXE (data_wdata_from_EXE)
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

    EXE_MEM_reg u_EXE_MEM_reg(
        .clk             (clk),
        .reset           (reset),
        .valid           (EXE_MEM_reg_valid),
        .readyGo         (EXE_readyGo),
        .allowIn         (EXE_MEM_reg_allowIn),
        .final_result_in (exe_final_result),
        .wb_reg_addr_in  (exe_wb_reg_addr),
        .mem_op_in       (exe_mem_op),
        .wb_op_in        (exe_wb_op),
        .mem_wdata_in    (exe_mem_wdata),
        .pc_in           (exe_pc_2MEM),
        .final_result_out(em_result),
        .wb_reg_addr_out (em_wb_reg),
        .mem_op_out      (em_mem_op),
        .wb_op_out       (em_wb_op),
        .mem_wdata_out   (em_mem_wdata),
        .pc_out          (em_pc)
    );

    wire        MEM_readyGo;      // MEM 阶段就绪
    wire [31:0] mem_wb_wdata;     // MEM 输出到 WB 的写回数据
    wire [31:0] mem_pc_2WB;       // MEM 输出到 WB 的 PC
    wire [4:0]  mem_wb_regaddr;   // MEM 输出到 WB 的目的寄存器号
    wire        mem_wb_op;        // MEM 输出到 WB 的写回使能
    wire [31:0] mem_dsram_wdata;  // 数据 SRAM 写数据
    wire [31:0] mem_dsram_addr;   // 数据 SRAM 地址
    wire        mem_dsram_we;     // 数据 SRAM 写使能

    wire data_w_complete;   // 数据写完成脉冲
    wire data_r_complete;   // 数据读完成脉冲
    // 每个 EXE/MEM 槽 (pc, 目的寄存器) 只发一次 data_re；不依赖 exe_mem_shift 清忙（EXE_readyGo 恒 1 时易与 MEM_allowIn 组合出假推进）
    reg        ld_req_issued;
    reg [31:0] ld_req_pc;
    reg [4:0]  ld_req_reg;
    wire       ld_in_mem = em_mem_op[`MEM_OP_LD_W] & MEM_valid;
    wire       ld_slot_match = ld_req_issued & ld_in_mem
                               & (em_pc == ld_req_pc) & (em_wb_reg == ld_req_reg);
    wire       data_re_issue_ld = ld_in_mem & ~ld_slot_match;
    wire       mem_load_req_sent = ld_slot_match; // 本槽已发过读

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

    wire wb_allowIn;              // WB 阶段 allowIn（末级常开）
    wire [31:0] wb_wdata;         // WB 最终写回数据（到 regfile/debug）
    wire [31:0] wb_pc;            // WB 最终提交 PC（到 debug）
    wire [4:0]  wb_waddr;         // WB 最终写回寄存器号
    wire        wb_we;            // WB 最终写回使能

    WBport u_WBport(
        .clk           (clk),
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
    // 冲突检测与处理、前递、流水线控制器、bram数据交互
    //------------------------------------------------------------------


    conflict_detector u_conflict_detector(
        .id_rs1        (rf_raddr1),
        .id_rs2        (rf_raddr2),
        .exe_rd        (wb_reg_addr_2EXE),
        .exe_wb        (wb_op_2EXE),
        .mem_rd        (em_wb_reg),
        .mem_wb        (em_wb_op),
        .memwb_rd      (mem_wb_regaddr),
        .memwb_wb      (mem_wb_op),
        .wb_rd         (wb_waddr),
        .wb_wb         (wb_we),
        .hit_exe_rs1   (hit_exe_rs1),
        .hit_mem_rs1   (hit_mem_rs1),
        .hit_wb_rs1    (hit_wb_rs1),
        .hit_exe_rs2   (hit_exe_rs2),
        .hit_mem_rs2   (hit_mem_rs2),
        .hit_wb_rs2    (hit_wb_rs2)
    );

    wire mem_stage_is_load = MEM_valid
                              & em_mem_op[`MEM_OP_LD_W]
                              & ~data_r_complete;

    conflict_handle u_conflict_handle(
        .hit_exe_rs1   (hit_exe_rs1),
        .hit_mem_rs1   (hit_mem_rs1),
        .hit_wb_rs1    (hit_wb_rs1),
        .hit_exe_rs2   (hit_exe_rs2),
        .hit_mem_rs2   (hit_mem_rs2),
        .hit_wb_rs2    (hit_wb_rs2),
        .mem_stage_is_load(mem_stage_is_load),
        .br_taken_comb(br_taken_q),
        .raw_hazard  (raw_hazard),
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
        .EXE_data         (exe_final_result),
        .MEM_data         (em_result),
        .WB_data          (mwb_wdata),
        .ID_src1_rdata    (ID_src1_rdata),
        .ID_src2_rdata    (ID_src2_rdata)

    );

    pipeline_controller u_pipeline_controller(
        .clk                (clk),
        .reset              (reset),
        .block_sig          (block_sig),
        .cancel_sig         (cancel_sig),
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

    // BRAM 数据交互：
    // - IF 连续发起读请求（pc1）；
    // - 下一拍返回上一拍请求对应的指令与 PC（pc2）。
    wire data_w_wrong;      // 数据写异常（当前未参与流水控制，仅保留观测）
    wire data_r_wrong;      // 数据读异常（当前未参与流水控制，仅保留观测）
    wire inst_r_wrong;      // 取指异常（当前未参与流水控制，仅保留观测）
    bram_data_stream_controller u_bram_data_stream_controller(
        .clk                 (clk),                    // 时钟
        .reset               (reset),                  // 同步复位
        .inst_re_in_from_IF  (IF_valid & IF_ID_reg_allowIn), // 仅在 IF/ID 可接收时发取指，避免停顿期错位/跳读
        .data_we_in_from_EXE (em_mem_op[`MEM_OP_ST_W] & MEM_valid), // MEM 发起数据写请求
        .data_re_in_from_EXE (data_re_issue_ld),
        .pc_in_from_IF       (pc_2ram_data_controller),// IF 本拍请求 PC（pc1）
        .data_raddr_from_EXE (em_result),              // MEM 读地址
        .data_waddr_from_EXE (em_result),              // MEM 写地址
        .data_wdata_from_EXE (em_mem_wdata),           // MEM 写数据
        .inst_rdata_from_bram(inst_sram_rdata),        // BRAM 返回指令数据
        .data_rdata_from_bram(data_sram_rdata),        // BRAM 返回数据读数据
        // 下列 *_in_from_bram 端口在当前控制器实现中未使用，先常 1 保持接口兼容
        .inst_re_in_from_bram(1'b1),
        .data_we_in_from_bram(1'b1),
        .data_re_in_from_bram(1'b1),
        .inst_re_out_2bram   (bram_inst_re),           // 发往 BRAM 的指令读使能
        .data_we_out_2bram   (bram_data_we),           // 发往 BRAM 的数据写使能
        .data_re_out_2bram   (bram_data_re),           // 发往 BRAM 的数据读使能
        .inst_raddr_2bram    (bram_inst_addr),         // 发往 BRAM 的指令地址
        .data_raddr_2bram    (bram_data_raddr),        // 发往 BRAM 的数据读地址
        .data_waddr_2bram    (bram_data_waddr),        // 发往 BRAM 的数据写地址
        .data_wdata_2bram    (bram_data_wdata),        // 发往 BRAM 的数据写数据
        .inst_rdata_2IF      (inst_rdata_2IF),         // IF 使用的返回指令
        .data_rdata_2MEM     (data_rdata_2MEM),        // MEM 使用的数据读结果
        .data_w_wrong        (data_w_wrong),           // 数据写异常
        .data_r_wrong        (data_r_wrong),           // 数据读异常
        .inst_r_wrong        (inst_r_wrong),           // 取指异常
        .data_w_complete     (data_w_complete),        // 数据写完成
        .data_r_complete     (data_r_complete),        // 数据读完成
        .inst_r_complete     (inst_r_complete),        // 取指完成（对应上一拍请求）
        .pc_out_2ID          (pc_2ID_from_bram)        // 返回 PC（pc2，对齐返回指令）
    );


    assign inst_sram_en    = bram_inst_re;
    assign inst_sram_we    = 4'b0000;
    assign inst_sram_addr  = bram_inst_addr;
    assign inst_sram_wdata = 32'b0;

    assign data_sram_en    = bram_data_we | bram_data_re;
    assign data_sram_we    = bram_data_we ? 4'b1111 : 4'b0000;
    assign data_sram_addr  = bram_data_we ? bram_data_waddr : bram_data_raddr;
    assign data_sram_wdata = bram_data_wdata;



    //------------------------------------------------------------------
    // 调试：与参考核一致，报告 WB 级提交（含该指令 PC）
    //------------------------------------------------------------------
    assign debug_wb_pc       = wb_pc & {32{WB_valid}};
    assign debug_wb_rf_we    = {4{wb_we & WB_valid & (wb_waddr != 5'd0)}};
    assign debug_wb_rf_wnum  = wb_waddr & {5{WB_valid}};
    assign debug_wb_rf_wdata = wb_wdata & {32{WB_valid}};

endmodule
