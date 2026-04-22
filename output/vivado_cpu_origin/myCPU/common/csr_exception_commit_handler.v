`include "cpu_defs.vh"

// ============================================================
// csr_exception_commit_handler（时序+组合）
// 1) 时序维护 CSR （CRMD/PRMD/ESTAT/ERA/EENTRY/SAVE0~3/ECFG/BADV/TID/TCFG/TVAL/TICLR）
// 2) 组合逻辑使用模块exception_Decoder译码异常标志信号为异常对应的Ecode、Esubcode
// 3) WB 提交 异常/中断/ERTN/CSR有关指令 给这个模块 
// 4) 输出流水线控制信号（flush_pipeline）、csr_next_pc + csr_redirect(给 npc)、csr读返回值
// 有些异常我还没加入！！！但现在不影响
// ============================================================
module csr_exception_commit_handler (
    input  wire        clk,
    input  wire        reset,
    input  wire [11:0] csr_rnum,


    // ---------------- CSR 访问（来自 csr 指令，在WB真正执行） ----------------------------
    input  wire [11:0] csr_num,    // CSR寄存器号
    input  wire        csr_we,     // CSR寄存器写使能
    input  wire [31:0] csr_wmask,  // CSR寄存器写掩码
    input  wire [31:0] csr_wvalue, // CSR寄存器写值


    // ---------------- 外部中断输入 ----------------------------
    // hw_int_in = hardware interrupt input
    input  wire [ 7:0] hw_int_in,  // 8位硬中断，在top接线（不过实际未input在top的端口，只是在内部置零，没用到。为什么？仿真也没用好吗-_-）
    input  wire        ipi_int_in, // 核间中断


    // ---------------- 来自 WB 的提交信息 ----------------
    input  wire        wb_valid,
    input  wire [31:0] wb_pc,
    input  wire        wb_is_ertn,    // ERTN指令要冲刷流水线
    input  wire [31:0] wb_vaddr,      // 用给BADV
    input  wire        wb_ex,         // 异常处理触发信号，在WB由那几个valid相或驱动
    input  wire [`TLB_OP_NUM-1:0] wb_tlb_op,
    input  wire                   tlbsrch_found,
    input  wire [3:0]             tlbsrch_index,
    input  wire [31:0]            tlbrd_tlbidx,
    input  wire [31:0]            tlbrd_tlbehi,
    input  wire [31:0]            tlbrd_tlbelo0,
    input  wire [31:0]            tlbrd_tlbelo1,
    input  wire [9:0]             tlbrd_asid,
    // 注意：有优先级，INT中断最大>IF检测出的异常>ID>EXE>MEM>WB
    input  wire        INT_valid,     // 中断是否触发，高电平即为有中断异常
    input  wire        ADEF_valid,    // 取指地址错位异常，特指pc
    input  wire [`TLB_EX_NUM-1:0] TLB_EX_valid,
    input  wire        ALE_valid,     // 地址非对齐异常，特指MEM的访存
    input  wire        SYS_valid,     // 系统调用异常，与指令syscall相关
    input  wire        BRK_valid,     // 断点异常，与指令break相关
    input  wire        INE_valid,     // 指令不存在异常，特指ID


    // ---------------- 输出：冲刷、pc重定向、ID中断、csr读返回与域输出 ----------------
    output wire        flush_pipeline,  // 异常或 ERTN 提交时冲刷
    output wire [31:0] csr_next_pc,     // 异常的EENTRY 或 ERTN的返回地址，判断是这两个的哪个，看csr_redirect
    output wire [1:0]  csr_redirect,    // 区分csr_next_pc类型的标志位信号，给npc仲裁，类型有`CSR_REDIRECT_EX、`CSR_REDIRECT_ERTN、`CSR_REDIRECT_NONE，具体看宏定义
    output wire        has_int,         // 送往ID的中断有效信号，将中断附着在ID指令上
    output wire [31:0] csr_rvalue,      // CSR寄存器读返回值
    output wire [31:0] csr_tid_out,     // csr的tid值，用于RDCNTID指令读取计时器ID号
    output wire        csr_crmd_da_out,
    output wire        csr_crmd_pg_out,
    output wire [1:0]  csr_crmd_plv_out,
    output wire [9:0]  csr_asid_out,
    output wire [31:0] csr_tlbidx_out,
    output wire [31:0] csr_tlbehi_out,
    output wire [31:0] csr_tlbelo0_out,
    output wire [31:0] csr_tlbelo1_out,
    output wire [31:0] csr_dmw0_out,
    output wire [31:0] csr_dmw1_out,
    output wire [7:0]  csr_estat_ecode_out
);

    // 默认异常入口为 0x1c000000，避免在软件初始化前中断/异常重定向到 0x00000000。
    localparam [25:0] CSR_EENTRY_RESET_VA = 26'h700000;

    // 异常译码出ecode、esubcode               
    wire [7:0] Ecode;   // 异常码
    wire Esubcode;      // 异常子码                  
    exception_Decoder u_exception_Decoder (
        .INT_valid(INT_valid),          
        .ADEF_valid(ADEF_valid),         
        .TLB_EX_valid(TLB_EX_valid),
        .ALE_valid(ALE_valid),          
        .SYS_valid(SYS_valid),          
        .BRK_valid(BRK_valid),          
        .INE_valid(INE_valid),         
        .Ecode(Ecode),        
        .Esubcode(Esubcode)     
    );


    reg [7:0] csr_estat_ecode; // 提前定义ESTAT 的 ECODE 域
    

    // CRMD 的 PLV 域
    reg [1:0] csr_crmd_plv;
    reg [1:0] csr_prmd_pplv;
    always @(posedge clk) begin
        if (reset) begin
            csr_crmd_plv <= 2'b0;
        end
        else if (wb_valid && wb_ex) begin
            csr_crmd_plv <= 2'b0;
        end
        else if (wb_valid && wb_is_ertn) begin
            csr_crmd_plv <= csr_prmd_pplv;
        end
        else if (csr_we && csr_num == `CSR_CRMD) begin
            csr_crmd_plv <= csr_wmask[`CSR_CRMD_PLV] & csr_wvalue[`CSR_CRMD_PLV] 
                            | ~csr_wmask[`CSR_CRMD_PLV] & csr_crmd_plv;
        // `CSR_CRMD_PLV 是 CRMD 在 32 位 CSR 数据里的位域范围，看手册可知CRMD PLV域为1:0
        // `define CSR_CRMD_PLV 1:0
        end
    end


    // CRMD 的 IE 域
    reg csr_crmd_ie;
    reg csr_prmd_pie;
    always @(posedge clk) begin
        if (reset) begin
            csr_crmd_ie <= 1'b0;
        end
        else if (wb_valid && wb_ex) begin
            csr_crmd_ie <= 1'b0;
        end
        else if (wb_valid && wb_is_ertn) begin
            csr_crmd_ie <= csr_prmd_pie;
        end
        else if (csr_we && csr_num == `CSR_CRMD) begin
            csr_crmd_ie <= csr_wmask[`CSR_CRMD_IE] & csr_wvalue[`CSR_CRMD_IE] 
                            | ~csr_wmask[`CSR_CRMD_IE] & csr_crmd_ie;
        end
    end


    // CRMD 的 DA、PG、DATF、DATM 域
    // 还没有实现MMU全部功能，暂时置为常值
    reg csr_crmd_da;
    reg csr_crmd_pg;
    reg [1:0] csr_crmd_datf;
    reg [1:0] csr_crmd_datm;
    always @(posedge clk) begin
        if (reset) begin
            csr_crmd_da   <= 1'b1;
            csr_crmd_pg   <= 1'b0;
            csr_crmd_datf <= 2'b00;
            csr_crmd_datm <= 2'b00;
        end
        else if (wb_valid && wb_ex && (Ecode == `TLBR_ECODE)) begin
            csr_crmd_da <= 1'b1;
            csr_crmd_pg <= 1'b0;
        end
        else if (wb_valid && wb_is_ertn && (csr_estat_ecode == `TLBR_ECODE)) begin
            csr_crmd_da <= 1'b0;
            csr_crmd_pg <= 1'b1;
        end
        else if (csr_we && csr_num == `CSR_CRMD) begin
            csr_crmd_da <= csr_wmask[`CSR_CRMD_DA] & csr_wvalue[`CSR_CRMD_DA]
                        | ~csr_wmask[`CSR_CRMD_DA] & csr_crmd_da;
            csr_crmd_pg <= csr_wmask[`CSR_CRMD_PG] & csr_wvalue[`CSR_CRMD_PG]
                        | ~csr_wmask[`CSR_CRMD_PG] & csr_crmd_pg;
            csr_crmd_datf <= csr_wmask[`CSR_CRMD_DATF] & csr_wvalue[`CSR_CRMD_DATF]
                          | ~csr_wmask[`CSR_CRMD_DATF] & csr_crmd_datf;
            csr_crmd_datm <= csr_wmask[`CSR_CRMD_DATM] & csr_wvalue[`CSR_CRMD_DATM]
                          | ~csr_wmask[`CSR_CRMD_DATM] & csr_crmd_datm;
        end
    end
    

    // PRMD 的 PPLV、PIE 域
    always @(posedge clk) begin
        if (reset) begin
            csr_prmd_pplv <= 2'b0;
            csr_prmd_pie  <= 1'b0;
        end
        else if (wb_valid && wb_ex) begin
            csr_prmd_pplv <= csr_crmd_plv;
            csr_prmd_pie <= csr_crmd_ie;
        end
        else if (csr_we && csr_num == `CSR_PRMD) begin
            csr_prmd_pplv <= csr_wmask[`CSR_PRMD_PPLV] & csr_wvalue[`CSR_PRMD_PPLV] 
                            | ~csr_wmask[`CSR_PRMD_PPLV] & csr_prmd_pplv;
            csr_prmd_pie <= csr_wmask[`CSR_PRMD_PIE] & csr_wvalue[`CSR_PRMD_PIE] 
                            | ~csr_wmask[`CSR_PRMD_PIE] & csr_prmd_pie;
        end
    end


    // ECFG 的 LIE 域
    reg [12:0] csr_ecfg_lie;
    always @(posedge clk) begin
        if (reset) begin
            csr_ecfg_lie <= 13'b0;
        end
        else if (csr_we && csr_num == `CSR_ECFG) begin
            csr_ecfg_lie <= csr_wmask[`CSR_ECFG_LIE] & 13'h1bff & csr_wvalue[`CSR_ECFG_LIE] 
                            | ~csr_wmask[`CSR_ECFG_LIE] & 13'h1bff & csr_ecfg_lie;
        end
    end


    // ESTAT 的 IS 域（timer_cnt 在本块使用，声明需前置）
    reg [12:0] csr_estat_is;
    reg [31:0] timer_cnt;
    always @(posedge clk) begin
        if (reset) begin
            // 必须整域复位，否则 IS[11] 等在首拍为 X → has_int 为 X → ID 译码条件失效、写回数据 X
            csr_estat_is <= 13'b0;
        end else begin
            if (csr_we && csr_num == `CSR_ESTAT) begin
                csr_estat_is[1:0] <= csr_wmask[`CSR_ESTAT_IS10] & csr_wvalue[`CSR_ESTAT_IS10] 
                                | ~csr_wmask[`CSR_ESTAT_IS10] & csr_estat_is[1:0];
            end
            csr_estat_is[9:2] <= hw_int_in[7:0];
            csr_estat_is[10] <= 1'b0;
            if (timer_cnt[31:0] == 32'b0) begin
                csr_estat_is[11] <= 1'b1;
            end else if (csr_we && csr_num == `CSR_TICLR && csr_wmask[`CSR_TICLR_CLR] 
                     && csr_wvalue[`CSR_TICLR_CLR]) begin
                csr_estat_is[11] <= 1'b0;
            end
            csr_estat_is[12] <= ipi_int_in;
        end
    end


    // ESTAT 的 ECODE、ESUBCODE 域
    // ESTAT 的 ECODE 已提前定义
    reg csr_estat_esubcode;
    always @(posedge clk) begin
        if (reset) begin
            csr_estat_ecode <= 8'b0;
            csr_estat_esubcode <= 1'b0;
        end
        else if (wb_valid && wb_ex) begin
            csr_estat_ecode <= Ecode[5:0];
            csr_estat_esubcode <= {8'b0,Esubcode};
        end
    end


    // ERA 的 PC 域
    reg [31:0] csr_era_pc;
    always @(posedge clk) begin
        if (wb_valid && wb_ex) begin
            // IF ADEF arrives one step advanced on current front-end timing;
            // record architectural fault PC for CSR visible state.
            csr_era_pc <= ADEF_valid ? (wb_pc - 32'd4) : wb_pc;
        end
        else if (csr_we && csr_num == `CSR_ERA) begin
            csr_era_pc <= csr_wmask[`CSR_ERA_PC] & csr_wvalue[`CSR_ERA_PC] 
                            | ~csr_wmask[`CSR_ERA_PC] & csr_era_pc;
        end
    end


    // BADV 的 VADDR 域
    reg [31:0] csr_badv_vaddr;
    wire wb_ex_addr_err = (Ecode == `ADEF_ECODE || Ecode == `ADEM_ECODE || Ecode == `ALE_ECODE
                        || Ecode == `TLBR_ECODE || Ecode == `PIF_ECODE || Ecode == `PIL_ECODE
                        || Ecode == `PIS_ECODE || Ecode == `PPI_ECODE || Ecode == `PME_ECODE);

    always @(posedge clk) begin
        if (wb_valid && wb_ex && wb_ex_addr_err) begin
            csr_badv_vaddr <= ((Ecode == `ADEF_ECODE || Ecode == `ADEM_ECODE) &&
                               Esubcode==`ADEF_ESUBCODE) ? (ADEF_valid ? (wb_pc - 32'd4) : wb_pc) : wb_vaddr;
        end
    end


    // EENTRY 的 VA 域
    reg [25:0] csr_eentry_va;
    always @(posedge clk) begin
        if (reset) begin
            csr_eentry_va <= CSR_EENTRY_RESET_VA;
        end
        else if (csr_we && csr_num == `CSR_EENTRY) begin
            csr_eentry_va <= csr_wmask[`CSR_EENTRY_VA] & csr_wvalue[`CSR_EENTRY_VA] 
                            | ~csr_wmask[`CSR_EENTRY_VA] & csr_eentry_va;
        end
    end


    // TLB 的 TLBIDX、TLBEHI、TLBELO0、TLBELO1、ASID、TLBRENTRY、DMW0、DMW1 域
    reg [31:0] csr_tlbidx;
    reg [31:0] csr_tlbehi;
    reg [31:0] csr_tlbelo0;
    reg [31:0] csr_tlbelo1;
    reg [31:0] csr_asid;
    reg [31:0] csr_tlbrentry;
    reg [31:0] csr_dmw0;
    reg [31:0] csr_dmw1;

    always @(posedge clk) begin
        if (reset) begin
            csr_tlbidx   <= 32'h0000_0000;
            csr_tlbehi   <= 32'h0000_0000;
            csr_tlbelo0  <= 32'h0000_0000;
            csr_tlbelo1  <= 32'h0000_0000;
            csr_asid     <= 32'h0000_0000;
            csr_tlbrentry<= 32'h0000_0000;
            csr_dmw0     <= 32'h0000_0000;
            csr_dmw1     <= 32'h0000_0000;
        end else begin
            if (csr_we && csr_num == `CSR_TLBIDX)
                csr_tlbidx <= (csr_wmask & csr_wvalue) | (~csr_wmask & csr_tlbidx);
            if (csr_we && csr_num == `CSR_TLBEHI)
                csr_tlbehi <= (csr_wmask & csr_wvalue) | (~csr_wmask & csr_tlbehi);
            if (csr_we && csr_num == `CSR_TLBELO0)
                csr_tlbelo0 <= (csr_wmask & csr_wvalue) | (~csr_wmask & csr_tlbelo0);
            if (csr_we && csr_num == `CSR_TLBELO1)
                csr_tlbelo1 <= (csr_wmask & csr_wvalue) | (~csr_wmask & csr_tlbelo1);
            if (csr_we && csr_num == `CSR_ASID)
                csr_asid <= (csr_wmask & csr_wvalue) | (~csr_wmask & csr_asid);
            if (csr_we && csr_num == `CSR_TLBRENTRY)
                csr_tlbrentry <= (csr_wmask & csr_wvalue) | (~csr_wmask & csr_tlbrentry);
            if (csr_we && csr_num == `CSR_DMW0)
                csr_dmw0 <= (csr_wmask & csr_wvalue) | (~csr_wmask & csr_dmw0);
            if (csr_we && csr_num == `CSR_DMW1)
                csr_dmw1 <= (csr_wmask & csr_wvalue) | (~csr_wmask & csr_dmw1);

            if (wb_valid && wb_tlb_op[`TLB_OP_TLBSRCH]) begin
                if (tlbsrch_found) begin
                    csr_tlbidx[3:0] <= tlbsrch_index;
                    csr_tlbidx[31]  <= 1'b0;
                end else begin
                    csr_tlbidx[31]  <= 1'b1;
                end
            end

            if (wb_valid && wb_tlb_op[`TLB_OP_TLBRD]) begin
                csr_tlbidx  <= tlbrd_tlbidx;
                csr_tlbehi  <= tlbrd_tlbehi;
                csr_tlbelo0 <= tlbrd_tlbelo0;
                csr_tlbelo1 <= tlbrd_tlbelo1;
                csr_asid[9:0] <= tlbrd_asid;
            end
        end
    end


    // SAVE0~3 的 DATA 域
    reg [31:0] csr_save0_data;
    reg [31:0] csr_save1_data;
    reg [31:0] csr_save2_data;
    reg [31:0] csr_save3_data;
    always @(posedge clk) begin
        if (csr_we && csr_num == `CSR_SAVE0) begin
            csr_save0_data <= csr_wmask[`CSR_SAVE_DATA] & csr_wvalue[`CSR_SAVE_DATA] 
                            | ~csr_wmask[`CSR_SAVE_DATA] & csr_save0_data;
        end
        if (csr_we && csr_num == `CSR_SAVE1) begin
            csr_save1_data <= csr_wmask[`CSR_SAVE_DATA] & csr_wvalue[`CSR_SAVE_DATA] 
                            | ~csr_wmask[`CSR_SAVE_DATA] & csr_save1_data;
        end
        if (csr_we && csr_num == `CSR_SAVE2) begin
            csr_save2_data <= csr_wmask[`CSR_SAVE_DATA] & csr_wvalue[`CSR_SAVE_DATA] 
                            | ~csr_wmask[`CSR_SAVE_DATA] & csr_save2_data;
        end
        if (csr_we && csr_num == `CSR_SAVE3) begin
            csr_save3_data <= csr_wmask[`CSR_SAVE_DATA] & csr_wvalue[`CSR_SAVE_DATA] 
                            | ~csr_wmask[`CSR_SAVE_DATA] & csr_save3_data;
        end
    end


    // TID 的 TID 域
    reg [31:0] csr_tid_tid;
    always @(posedge clk) begin
        if (reset) begin
            csr_tid_tid <= 32'b0;
        end
        else if (csr_we && csr_num == `CSR_TID) begin
            csr_tid_tid <= csr_wmask[`CSR_TID_TID] & csr_wvalue[`CSR_TID_TID] 
                            | ~csr_wmask[`CSR_TID_TID] & csr_tid_tid;
        end
    end


    // TCFG 的 EN、PERIODIC、InitVal 域
    reg csr_tcfg_en;
    reg csr_tcfg_periodic;
    reg [29:0] csr_tcfg_initval;
    always @(posedge clk) begin
        if (reset) begin
            csr_tcfg_en <= 1'b0;
            csr_tcfg_periodic <= 1'b0;
            csr_tcfg_initval <= 30'b0;
        end
        else if (csr_we && csr_num == `CSR_TCFG) begin
            csr_tcfg_en <= csr_wmask[`CSR_TCFG_EN] & csr_wvalue[`CSR_TCFG_EN] 
                            | ~csr_wmask[`CSR_TCFG_EN] & csr_tcfg_en;
        end

        if (csr_we && csr_num == `CSR_TCFG) begin
            csr_tcfg_periodic <= csr_wmask[`CSR_TCFG_PERIODIC] & csr_wvalue[`CSR_TCFG_PERIODIC] 
                            | ~csr_wmask[`CSR_TCFG_PERIODIC] & csr_tcfg_periodic;
            csr_tcfg_initval <= csr_wmask[`CSR_TCFG_INITVAL] & csr_wvalue[`CSR_TCFG_INITVAL] 
                            | ~csr_wmask[`CSR_TCFG_INITVAL] & csr_tcfg_initval;
        end
    end


    // TVAL 的 TimerVal 域
    wire [31:0] tcfg_next_value;
    wire [31:0] csr_tval;

    assign tcfg_next_value = csr_wmask[31:0] & csr_wvalue[31:0] 
                           | ~csr_wmask[31:0] & {csr_tcfg_initval, csr_tcfg_periodic, csr_tcfg_en};

    always @(posedge clk) begin
        if (reset) begin
            timer_cnt <= 32'hffffffff;
        end
        else if (csr_we && csr_num == `CSR_TCFG && tcfg_next_value[`CSR_TCFG_EN]) begin
            timer_cnt <= {tcfg_next_value[`CSR_TCFG_INITVAL], 2'b0};
        end
        else if (csr_tcfg_en && timer_cnt != 32'hffffffff) begin
            if (timer_cnt[31:0] == 32'b0 && csr_tcfg_periodic) begin
                timer_cnt <= {csr_tcfg_initval, 2'b0};
            end
            else begin
                timer_cnt <= timer_cnt - 1'b1;
            end
        end
    end

    assign csr_tval = timer_cnt[31:0];


    // TICLR 的 CLR 域
    wire csr_ticlr_clr = 1'b0;


    // csr处理类型的标志信号
    wire csr_take_ex   = (wb_valid === 1'b1) && (wb_ex === 1'b1); // 异常
    wire csr_take_ertn = (wb_valid === 1'b1) && (wb_is_ertn === 1'b1) && !csr_take_ex; // ERTN，异常优先于同拍 ERTN（规范上不应同时发生）


    // CSR 的读出逻辑
    wire [31:0] csr_crmd_rvalue = {23'b0, csr_crmd_datm, csr_crmd_datf, csr_crmd_pg, csr_crmd_da, csr_crmd_ie, csr_crmd_plv};
    wire [31:0] csr_prmd_rvalue = {29'b0, csr_prmd_pie, csr_prmd_pplv};
    wire [31:0] csr_ecfg_rvalue = {19'b0, csr_ecfg_lie};
    wire [31:0] csr_estat_rvalue = {1'b0, csr_estat_esubcode, csr_estat_ecode, 3'b0, csr_estat_is};
    wire [31:0] csr_era_rvalue = csr_era_pc;
    wire [31:0] csr_badv_rvalue = csr_badv_vaddr;
    wire [31:0] csr_eentry_rvalue = {csr_eentry_va, 6'b0};
    wire [31:0] csr_save0_rvalue = csr_save0_data;
    wire [31:0] csr_save1_rvalue = csr_save1_data;
    wire [31:0] csr_save2_rvalue = csr_save2_data;
    wire [31:0] csr_save3_rvalue = csr_save3_data;
    wire [31:0] csr_tid_rvalue = csr_tid_tid;
    wire [31:0] csr_tcfg_rvalue = {csr_tcfg_initval, csr_tcfg_periodic, csr_tcfg_en};
    wire [31:0] csr_tval_rvalue = csr_tval;
    wire [31:0] csr_ticlr_rvalue = 32'b0;
    wire [31:0] csr_tlbidx_rvalue = csr_tlbidx;
    wire [31:0] csr_tlbehi_rvalue = csr_tlbehi;
    wire [31:0] csr_tlbelo0_rvalue = csr_tlbelo0;
    wire [31:0] csr_tlbelo1_rvalue = csr_tlbelo1;
    wire [31:0] csr_asid_rvalue = csr_asid;
    wire [31:0] csr_tlbrentry_rvalue = csr_tlbrentry;
    wire [31:0] csr_dmw0_rvalue = csr_dmw0;
    wire [31:0] csr_dmw1_rvalue = csr_dmw1;
    
    assign csr_rvalue = {32{csr_rnum == `CSR_CRMD}} & csr_crmd_rvalue
                       | {32{csr_rnum == `CSR_PRMD}} & csr_prmd_rvalue
                       | {32{csr_rnum == `CSR_ECFG}} & csr_ecfg_rvalue
                       | {32{csr_rnum == `CSR_ESTAT}} & csr_estat_rvalue
                       | {32{csr_rnum == `CSR_ERA}} & csr_era_rvalue
                       | {32{csr_rnum == `CSR_BADV}} & csr_badv_rvalue
                       | {32{csr_rnum == `CSR_EENTRY}} & csr_eentry_rvalue
                       | {32{csr_rnum == `CSR_SAVE0}} & csr_save0_rvalue
                       | {32{csr_rnum == `CSR_SAVE1}} & csr_save1_rvalue
                       | {32{csr_rnum == `CSR_SAVE2}} & csr_save2_rvalue
                       | {32{csr_rnum == `CSR_SAVE3}} & csr_save3_rvalue
                       | {32{csr_rnum == `CSR_TID}} & csr_tid_rvalue
                       | {32{csr_rnum == `CSR_TCFG}} & csr_tcfg_rvalue
                       | {32{csr_rnum == `CSR_TVAL}} & csr_tval_rvalue
                       | {32{csr_rnum == `CSR_TICLR}} & csr_ticlr_rvalue
                       | {32{csr_rnum == `CSR_TLBIDX}} & csr_tlbidx_rvalue
                       | {32{csr_rnum == `CSR_TLBEHI}} & csr_tlbehi_rvalue
                       | {32{csr_rnum == `CSR_TLBELO0}} & csr_tlbelo0_rvalue
                       | {32{csr_rnum == `CSR_TLBELO1}} & csr_tlbelo1_rvalue
                       | {32{csr_rnum == `CSR_ASID}} & csr_asid_rvalue
                       | {32{csr_rnum == `CSR_TLBRENTRY}} & csr_tlbrentry_rvalue
                       | {32{csr_rnum == `CSR_DMW0}} & csr_dmw0_rvalue
                       | {32{csr_rnum == `CSR_DMW1}} & csr_dmw1_rvalue
                       | 32'b0;
    

    // has_int
    assign has_int = (((csr_estat_is[12:0] & csr_ecfg_lie[12:0]) != 13'b0) === 1'b1) && (csr_crmd_ie === 1'b1);

    // flush_pipeline
    assign flush_pipeline = csr_take_ex || csr_take_ertn;

    // csr_redirect
    assign csr_redirect = csr_take_ex   ? `CSR_REDIRECT_EX
                        : csr_take_ertn ? `CSR_REDIRECT_ERTN
                        : `CSR_REDIRECT_NONE;

    // csr_next_pc
    assign csr_next_pc = csr_take_ex   ? ((csr_estat_ecode == `TLBR_ECODE) ? csr_tlbrentry_rvalue : csr_eentry_rvalue)
                        : csr_take_ertn ? csr_era_rvalue
                        : 32'b0;

    // csr相关域读出逻辑，供外部使用
    assign csr_tid_out = csr_tid_rvalue;
    assign csr_crmd_da_out = csr_crmd_da;
    assign csr_crmd_pg_out = csr_crmd_pg;
    assign csr_crmd_plv_out = csr_crmd_plv;
    assign csr_asid_out = csr_asid[9:0];
    assign csr_tlbidx_out = csr_tlbidx;
    assign csr_tlbehi_out = csr_tlbehi;
    assign csr_tlbelo0_out = csr_tlbelo0;
    assign csr_tlbelo1_out = csr_tlbelo1;
    assign csr_dmw0_out = csr_dmw0;
    assign csr_dmw1_out = csr_dmw1;
    assign csr_estat_ecode_out = csr_estat_ecode;
    
endmodule
