`include "./mycpu.vh"
module csr
#(
	parameter TLBNUM = 8
)
(
    input wire clk,
    input wire reset,

    //================================ CSR接口 ================================
    input  wire csr_re, // 读使能
    input  wire [13:0] csr_rnum, // 读寄存器号
    output logic[31:0] csr_rdata, // 寄存器读返回值
    input  wire csr_we, // 写使能
    input  wire [13:0] csr_wnum, // 写寄存器号
    input  wire [31:0] csr_wmask, // 写掩码
    input  wire [31:0] csr_wdata, // 写数据。可能的改进方法，但还没验证：写数据是已经进行了掩码操作的，掩码操作在EXE阶段进行。这样做的好处是避免了csr内部大量的逻辑门使用

    //================================ 入口地址接口 ================================
    output wire [31:0] ex_entry, // 送往pre-IF流水级的异常处理入口地址
    output wire [31:0] ertn_entry, // 送往pre-IF流水级的例外处理返回地址
    output wire [31:0] tlb_entry, // 送往pre-IF流水级的tlb重填例外入口地址

    output wire has_int, // 送往ID流水级的中断有效信号
    output wire [63:0] timer_64_rdata,
    //================================ 异常信号接口 ================================
    input  wire [31:0] WB_pc, // 来自写回流水级的PC值
    input  wire [31:0] WB_bad_vaddr, // 来自写回流水级的出错虚地址
    input  wire ertn_flush, // 来自写回流水级的ertn指令执行的有效信号v
    input  wire WB_ex, // 来自写回流水级的异常处理触发信号
    input  wire [ 5:0] WB_ecode, // 来自写回流水级的异常类型
    input  wire [ 8:0] WB_esubcode, // 来自写回流水级的异常类型
    // 与tlb例外有关的信号
    input  wire excp_tlbrefill, // TLB重填例外，WB阶段传入
    input  wire excp_tlb, // tlb重填例外、load操作页无效例外、store操作页无效例外、取指操作页无效例外、页修改例外、页特权等级不合规例外
    input  wire [18:0] excp_tlb_vppn,
    //================================ 中断接口 ================================
    input  wire [ 7:0] hw_int_in, // 硬中断信号
    input  wire ipi_int_in, // 核间中断信号
    input  wire [31:0] coreid_in, // 定时器号
    //================================ 地址翻译接口 ================================
    // 传给pre-IF和EXE阶段，用于地址翻译的信号
    output wire        csr_pg  ,
    output wire        csr_da  ,
    output wire [31:0] csr_dmw0,
    output wire [31:0] csr_dmw1,
    output wire [ 1:0] csr_plv ,
    output wire [ 1:0] csr_datf,
    output wire [ 1:0] csr_datm,
    output wire        disable_cache,
    //================================ 与tlb的交互信号，与tlb指令相关 ================================
    output wire [ 9:0] csr_asid      ,
    output wire [ 2:0] csr_rand_index, // 因为tlbfill填入哪个tlb表项是不确定的，指令手册说由硬件随机选择，那可以用timer_64的低5位来决定tlb_index
    output wire [31:0] csr_tlbehi    ,
    output wire [31:0] csr_tlbelo0   ,
    output wire [31:0] csr_tlbelo1   ,
    output wire [31:0] csr_tlbidx    ,
    output wire [ 5:0] csr_ecode     ,
    //================================ from addr trans ================================
    input  wire        tlbsrch_en   , // from EXE，表示有tlbsrch指令
    input  wire        tlbsrch_found,
    input  wire [ 2:0] tlbsrch_index,
    input  wire        tlbrd_en     , // from WB，表示有tlbrd指令
    input  wire [31:0] tlbehi_in    ,
    input  wire [31:0] tlbelo0_in   ,
    input  wire [31:0] tlbelo1_in   ,
    input  wire [31:0] tlbidx_in    ,
    input  wire [ 9:0] asid_in      ,
    //================================ llbit逻辑接口 ================================
    input  wire        llbit_set_in , // WB阶段传进来的llbit设置使能
    input  wire        llbit_in     , // WB阶段传进来的llbit
    input  wire        lladdr_set_in, // WB阶段传进来的lladdr设置使能
    input  wire [27:0] lladdr_in    , // WB阶段传进来的lladdr
    output wire        llbit_out    , // 传给EXE阶段的llbit
    output wire [27:0] lladdr_out     // 传给EXE阶段的lladdr
    `ifdef DIFFTEST_EN
    ,
    output [31:0]                   csr_crmd_diff,
    output [31:0]                   csr_prmd_diff,
    output [31:0]                   csr_ectl_diff,
    output [31:0]                   csr_estat_diff,
    output [31:0]                   csr_era_diff,
    output [31:0]                   csr_badv_diff,
    output [31:0]                   csr_eentry_diff,
    output [31:0]                   csr_tlbidx_diff,
    output [31:0]                   csr_tlbehi_diff,
    output [31:0]                   csr_tlbelo0_diff,
    output [31:0]                   csr_tlbelo1_diff,
    output [31:0]                   csr_asid_diff,
    output [31:0]                   csr_save0_diff,
    output [31:0]                   csr_save1_diff,
    output [31:0]                   csr_save2_diff,
    output [31:0]                   csr_save3_diff,
    output [31:0]                   csr_tid_diff,
    output [31:0]                   csr_tcfg_diff,
    output [31:0]                   csr_tval_diff,
    output [31:0]                   csr_ticlr_diff,
    output [31:0]                   csr_llbctl_diff,
    output [31:0]                   csr_tlbrentry_diff,
    output [31:0]                   csr_dmw0_diff,
    output [31:0]                   csr_dmw1_diff,
    output [31:0]                   csr_pgdl_diff,
    output [31:0]                   csr_pgdh_diff,
    output   wire                   special_init
`endif
    );

// CRMD 当前模式信息
reg [ 1:0]  csr_crmd_plv;
reg         csr_crmd_ie; // 全局中断使能
reg         csr_crmd_da;
reg         csr_crmd_pg;
reg [ 1:0]  csr_crmd_datf;
reg [ 1:0]  csr_crmd_datm;


// PRMD 例外前模式信息
reg [ 1:0] csr_prmd_pplv;
reg        csr_prmd_pie;


// ECFG 例外控制，局部中断使能
reg [12:0] csr_ecfg_lie;


// ESTAT 例外状态,是否有中断请求
reg [12:0] csr_estat_is;
reg [ 5:0] csr_estat_ecode;
reg [ 8:0] csr_estat_esubcode;


// ERA 例外返回地址
reg [31:0] csr_era_pc;


// BADV 出错虚地址
reg [31:0] csr_badv_vaddr;


// EENTRY 例外入口地址
reg [25:0] csr_eentry_va;

// CPUID  the id of the cpu,remain 32'b0
reg [31:0] csr_cpuid;


// SAVE0~3 数据保存
reg [31:0] csr_save0_data;
reg [31:0] csr_save1_data;
reg [31:0] csr_save2_data;
reg [31:0] csr_save3_data;

// LLBCTL LLBit控制
reg        csr_llbctl_wcllb;
reg        csr_llbctl_klo;
reg        llbit;
reg [27:0] lladdr;

// TID 定时器编号
reg [31:0] csr_tid_tid;


// TCFG 定时器配置
reg csr_tcfg_en;
reg csr_tcfg_periodic;
reg [29:0] csr_tcfg_initval;


// TVAL 计时器数值
reg  [31:0] timer_cnt;
wire [31:0] csr_tval;

// CNTC
reg  [31:0] csr_cntc;


// TICLR 定时中断清除
wire csr_ticlr_clr;

// TLBIDX TLB索引
reg  [ 2:0] csr_tlbidx_index;
reg  [ 5:0] csr_tlbidx_ps;
reg         csr_tlbidx_ne;

// TLBEHI TLB表项高位
reg  [18:0] csr_tlbehi_vppn;

// TLBELO0,TLBELO1 TLB表项低位
reg         csr_tlbelo0_v;
reg         csr_tlbelo0_d;
reg  [ 1:0] csr_tlbelo0_plv;
reg  [ 1:0] csr_tlbelo0_mat;
reg         csr_tlbelo0_g;
reg  [19:0] csr_tlbelo0_ppn; // PALEN = 32 物理地址的有效位数

reg         csr_tlbelo1_v;
reg         csr_tlbelo1_d;
reg  [ 1:0] csr_tlbelo1_plv;
reg  [ 1:0] csr_tlbelo1_mat;
reg         csr_tlbelo1_g;
reg  [19:0] csr_tlbelo1_ppn;

// ASID 地址空间标识符
reg  [ 9:0] csr_asid_asid;

// PGDL 低半地址空间全局目录基址
// PGDH 高半地址空间全局目录基址
// PGD  全局目录基址
reg  [19:0] csr_pgdl_base;
reg  [19:0] csr_pgdh_base;
wire [19:0] csr_pgd_base ;

// TLBRENTRY TLB重填例外入口地址
reg  [25:0] csr_tlbrentry_pa;

// DMW0、DMW1 直接映射配置窗口
reg         csr_dmw0_plv0;
reg         csr_dmw0_plv3;
reg  [ 1:0] csr_dmw0_mat;
reg  [ 2:0] csr_dmw0_pseg;
reg  [ 2:0] csr_dmw0_vseg;

reg         csr_dmw1_plv0;
reg         csr_dmw1_plv3;
reg  [ 1:0] csr_dmw1_mat;
reg  [ 2:0] csr_dmw1_pseg;
reg  [ 2:0] csr_dmw1_vseg;

// disable cache
reg  [31:0] csr_disable_cache;

// CPUCFG
reg  [31:0] csr_cpucfg1;
reg  [31:0] csr_cpucfg2;
reg  [31:0] csr_cpucfg10;
reg  [31:0] csr_cpucfg11;
reg  [31:0] csr_cpucfg12;
reg  [31:0] csr_cpucfg13;

/*tlb传给csr的信号
tlbsrch_en, // 指令为tlbsrch； 1位
tlbrd_en, // 指令为tlbrd； 1位
tlbsrch_found, // tlbsrch命中； 1位
tlbsrch_index, // 命中项的索引值； 4位
tlbidx_in, // tlb输入的用来更新tlbidx的数据； {!r_e, 1'b0, r_ps, 24'b0} 32位
tlbehi_in, // tlb输入的用来更新tlbehi的数据； {r_vppn, 13'b0} 32位
asid_in, // tlb输入的用来更新asid的数据； 10位
tlbelo0_in, // tlb输入的用来更新tlbelo0的数据； {4'b0, r_ppn0, 1'b0, r_g, r_mat0, r_plv0, r_d0, r_v0} 32位
tlbelo1_in, // tlb输入的用来更新tlbelo1的数据； {4'b0, r_ppn1, 1'b0, r_g, r_mat1, r_plv1, r_d1, r_v1} 32位
excp_tlb, // tlb重填例外、load操作页无效例外（PIL）、store操作页无效例外(PIS)、取指操作页无效例外(PIF)、页修改例外(PME)、页特权等级不合规例外(PPI) 1位
excp_tlb_vppn // 触发例外的虚地址的[31:13]位 19位
*/

////////////////////////////////////////////////////////////////////////////////////////////////////

// CRMD 当前模式信息
always @(posedge clk) begin
    if (reset) begin
        csr_crmd_plv  <= 2'b0;
        csr_crmd_ie   <= 1'b0;
        csr_crmd_da   <= 1'b1;
        csr_crmd_pg   <= 1'b0;
        csr_crmd_datf <= 2'b00;
        csr_crmd_datm <= 2'b00;
    end
    else if (WB_ex) begin
        csr_crmd_plv <= 2'b0;
        csr_crmd_ie <= 1'b0;
        if (excp_tlbrefill) begin // 触发TLB重填例外
            csr_crmd_da <= 1'b1;
            csr_crmd_pg <= 1'b0;
        end
    end
    else if (ertn_flush) begin
        csr_crmd_plv <= csr_prmd_pplv;
        csr_crmd_ie <= csr_prmd_pie;
        if (csr_estat_ecode == 6'h3f) begin
            csr_crmd_da <= 1'b0;
            csr_crmd_pg <= 1'b1;
        end
    end
    else if (csr_we && csr_wnum == `CRMD) begin // 掩码为1的位置才更新，为0的位置保持不变
        csr_crmd_plv   <= csr_wmask[`CRMD_PLV]   & csr_wdata[`CRMD_PLV]   | ~csr_wmask[`CRMD_PLV]   & csr_crmd_plv;
        csr_crmd_ie    <= csr_wmask[`CRMD_IE]    & csr_wdata[`CRMD_IE]    | ~csr_wmask[`CRMD_IE]    & csr_crmd_ie;
        csr_crmd_da    <= csr_wmask[`CRMD_DA]    & csr_wdata[`CRMD_DA]    | ~csr_wmask[`CRMD_DA]    & csr_crmd_da;
        csr_crmd_pg    <= csr_wmask[`CRMD_PG]    & csr_wdata[`CRMD_PG]    | ~csr_wmask[`CRMD_PG]    & csr_crmd_pg;
        csr_crmd_datf  <= csr_wmask[`CRMD_DATF]  & csr_wdata[`CRMD_DATF]  | ~csr_wmask[`CRMD_DATF]  & csr_crmd_datf;
        csr_crmd_datm  <= csr_wmask[`CRMD_DATM]  & csr_wdata[`CRMD_DATM]  | ~csr_wmask[`CRMD_DATM]  & csr_crmd_datm;
    end
end


// PRMD 例外前模式信息
always @(posedge clk) begin
    if (WB_ex) begin
        csr_prmd_pplv <= csr_crmd_plv;
        csr_prmd_pie <= csr_crmd_ie;
    end
    else if (csr_we && csr_wnum == `PRMD) begin // 掩码为1的位置才更新，为0的位置保持不变
        csr_prmd_pplv <= csr_wmask[`PRMD_PPLV] & csr_wdata[`PRMD_PPLV] | ~csr_wmask[`PRMD_PPLV] & csr_prmd_pplv;
        csr_prmd_pie  <= csr_wmask[`PRMD_PIE]  & csr_wdata[`PRMD_PIE]  | ~csr_wmask[`PRMD_PIE]  & csr_prmd_pie;
    end
end


// ECFG 例外控制，局部中断使能
always @(posedge clk) begin
    if (reset) begin
        csr_ecfg_lie <= 13'b0;
    end
    else if (csr_we && csr_wnum == `ECFG) begin // 13'h1bff用于保证第10位为0
        csr_ecfg_lie <= csr_wmask[`ECFG_LIE] & 13'h1bff & csr_wdata[`ECFG_LIE] | ~csr_wmask[`ECFG_LIE] & 13'h1bff & csr_ecfg_lie;
    end
end


// ESTAT 例外状态,是否有中断请求
always @(posedge clk) begin
    if (reset) begin
        csr_estat_is[1:0] <= 2'b00;
    end
    else if (csr_we && csr_wnum == `ESTAT) begin // 因为只有is[1:0]两位是可写的，其他位是不可写的
        csr_estat_is[1:0] <= csr_wmask[`ESTAT_IS10] & csr_wdata[`ESTAT_IS10] | ~csr_wmask[`ESTAT_IS10] & csr_estat_is[1:0];
    end

    csr_estat_is[9:2] <= hw_int_in[7:0]; // 目前都是0

    csr_estat_is[10]  <= 1'b0;// 保留域。读返回0，且软件不允许改变其值

    if (csr_tcfg_en && timer_cnt[31:0] == 32'b0) begin
        csr_estat_is[11] <= 1'b1;
    end
    else if (csr_we && csr_wnum == `TICLR && csr_wmask[`TICLR_CLR] && csr_wdata[`TICLR_CLR]) begin // 对csr_ticlr_clr进行写1的这一操作，表示清除定时器中断
        csr_estat_is[11] <= 1'b0;
    end

    csr_estat_is[12]  <= ipi_int_in; // 目前是0
end

always @(posedge clk) begin
    if (WB_ex) begin
        csr_estat_ecode    <= WB_ecode;
        csr_estat_esubcode <= WB_esubcode;
    end
end


// ERA 例外返回地址
always @(posedge clk) begin
    if (WB_ex) begin
        csr_era_pc <= WB_pc;
    end
    else if (csr_we && csr_wnum == `ERA) begin
        csr_era_pc <= csr_wmask[`ERA_PC] & csr_wdata[`ERA_PC] | ~csr_wmask[`ERA_PC] & csr_era_pc;
    end
end

// BADV 出错虚地址
/*什么情况下记录： 但是还需要确认：是只有ADEF的情况下记录pc值吗？
1.ADEF 取值地址错例外，此时记录该指令的PC
2.ALE
3.tlb重填例外、load操作页无效例外（PIL）、store操作页无效例外(PIS)、取指操作页无效例外(PIF)、页修改例外(PME)、页特权等级不合规例外(PPI)，也即excp_tlb
*/

wire WB_ex_addr_err; // 需要记录出错虚地址
assign WB_ex_addr_err = (WB_ecode == `ECODE_ADE && WB_esubcode == `ESUBCODE_ADEF) || (WB_ecode == `ECODE_ALE) || excp_tlb;

always @(posedge clk) begin
    if (WB_ex && WB_ex_addr_err) begin
        csr_badv_vaddr <= WB_bad_vaddr;
    end
    else if (csr_we && csr_wnum == `BADV) begin
        csr_badv_vaddr <= csr_wmask & csr_wdata | ~csr_wmask & csr_badv_vaddr;
    end
end

// EENTRY 例外入口地址
always @(posedge clk) begin
    if (csr_we && csr_wnum == `EENTRY) begin
        csr_eentry_va <= csr_wmask[`EENTRY_VA] & csr_wdata[`EENTRY_VA] | ~csr_wmask[`EENTRY_VA] & csr_eentry_va;
    end
end


// SAVE0~3 数据保存
always @(posedge clk) begin
    if (csr_we && csr_wnum == `SAVE0) begin
        csr_save0_data <= csr_wmask[`SAVE_DATA] & csr_wdata[`SAVE_DATA] | ~csr_wmask[`SAVE_DATA] & csr_save0_data;
    end
    if (csr_we && csr_wnum == `SAVE1) begin
        csr_save1_data <= csr_wmask[`SAVE_DATA] & csr_wdata[`SAVE_DATA] | ~csr_wmask[`SAVE_DATA] & csr_save1_data;
    end
    if (csr_we && csr_wnum == `SAVE2) begin
        csr_save2_data <= csr_wmask[`SAVE_DATA] & csr_wdata[`SAVE_DATA] | ~csr_wmask[`SAVE_DATA] & csr_save2_data;
    end
    if (csr_we && csr_wnum == `SAVE3) begin
        csr_save3_data <= csr_wmask[`SAVE_DATA] & csr_wdata[`SAVE_DATA] | ~csr_wmask[`SAVE_DATA] & csr_save3_data;
    end
end

// CPUID
always @(posedge clk) begin
    if (reset) begin
        csr_cpuid <= 32'b0;
    end 
end

// LLBCTL LLBit控制
always @(posedge clk) begin
    if (reset) begin
        csr_llbctl_wcllb    <= 1'b0;
		csr_llbctl_klo      <= 1'b0;
        llbit               <= 1'b0;
    end 
    else if (ertn_flush) begin
        if (csr_llbctl_klo) begin
            csr_llbctl_klo <= 1'b0;
        end
        else begin
            llbit <= 1'b0;
        end
    end
    else if (llbit_set_in) begin
        llbit <= llbit_in;
    end
    else if (csr_we && csr_wnum == `LLBCTL) begin 
        csr_llbctl_klo <= csr_wmask[`LLBCTL_KLO] & csr_wdata[`LLBCTL_KLO] | ~csr_wmask[`LLBCTL_KLO] & csr_llbctl_klo;
        if (csr_wmask[`LLBCTL_WCLLB] & csr_wdata[`LLBCTL_WCLLB]) begin // 对WCLLB写1时，将LLBIT清零
            llbit <= 1'b0;
        end
    end

end

always @(posedge clk) begin
    if (reset) begin
        lladdr <= 28'b0;
    end
    else if (lladdr_set_in) begin
        lladdr <= lladdr_in;
    end
end





// TID 定时器编号
always @(posedge clk) begin
    if (reset) begin
        csr_tid_tid <= coreid_in;
    end
    else if (csr_we && csr_wnum == `TID) begin
        csr_tid_tid <= csr_wmask[`TID_TID] & csr_wdata[`TID_TID] | ~csr_wmask[`TID_TID] & csr_tid_tid;
    end
end


// TCFG 定时器配置 ， 同时更新TVAL 计时器数值
wire [31:0] tcfg_next_data;

assign tcfg_next_data = csr_wmask[31:0] & csr_wdata[31:0] | ~csr_wmask[31:0] & {csr_tcfg_initval, csr_tcfg_periodic, csr_tcfg_en};

always @(posedge clk) begin
    if (reset) begin
        csr_tcfg_en <= 1'b0;
    end
    else if (csr_we && csr_wnum == `TCFG) begin
        csr_tcfg_en <= csr_wmask[`TCFG_EN] & csr_wdata[`TCFG_EN] | ~csr_wmask[`TCFG_EN] & csr_tcfg_en;
    end
    
    if (csr_we && csr_wnum == `TCFG) begin
        csr_tcfg_periodic <= csr_wmask[`TCFG_PERIODIC] & csr_wdata[`TCFG_PERIODIC] | ~csr_wmask[`TCFG_PERIODIC] & csr_tcfg_periodic;
        csr_tcfg_initval  <= csr_wmask[`TCFG_INITVAL] & csr_wdata[`TCFG_INITVAL] | ~csr_wmask[`TCFG_INITVAL] & csr_tcfg_initval;
    end
end

always @(posedge clk) begin
    if (reset) begin
        timer_cnt <= 32'hffffffff;
    end
    else if (csr_we && csr_wnum == `TCFG && tcfg_next_data[`TCFG_EN]) begin
        timer_cnt <= {tcfg_next_data[`TCFG_INITVAL], 2'b0};
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

// TVAL
assign csr_tval = timer_cnt[31:0];

// CNTC
always @(posedge clk) begin
    if (reset) begin
        csr_cntc <= 32'b0;
    end
    else if (csr_we && csr_wnum == `CNTC) begin
        csr_cntc <= csr_wmask & csr_wdata | ~csr_wmask & csr_wdata; // because it's 32 bits
    end
end

// TICLR 定时中断清除
assign csr_ticlr_clr = 1'b0;


//timer_64
reg [63:0] timer_64;
always @(posedge clk) begin
    if (reset) begin
        timer_64 <= 64'b0;
    end
    else begin
        timer_64 <= timer_64 + 1'b1;
    end
end

wire    tlbrd_valid; // 目标tlb表项有效
wire    tlbrd_invalid; // 目标tlb表项无效
assign  tlbrd_valid   = tlbrd_en && !tlbidx_in[`TLBIDX_NE];
assign  tlbrd_invalid = tlbrd_en &&  tlbidx_in[`TLBIDX_NE];
// TLBIDX TLB索引           
always @(posedge clk) begin
    if (reset) begin
        csr_tlbidx_index <= 3'b0;
        csr_tlbidx_ne    <= 1'b0;
    end
    else if (csr_we && csr_wnum == `TLBIDX) begin
        csr_tlbidx_index[ 2:0] <= csr_wmask[`TLBIDX_INDEX] & csr_wdata[`TLBIDX_INDEX] | ~csr_wmask[`TLBIDX_INDEX] & csr_tlbidx_index[ 2:0];
        csr_tlbidx_ps <= csr_wmask[`TLBIDX_PS] & csr_wdata[`TLBIDX_PS] | ~csr_wmask[`TLBIDX_PS] & csr_tlbidx_ps;
        csr_tlbidx_ne <= csr_wmask[`TLBIDX_NE] & csr_wdata[`TLBIDX_NE] | ~csr_wmask[`TLBIDX_NE] & csr_tlbidx_ne;
    end
    else if (tlbsrch_en) begin // tlbsrch指令
        if (tlbsrch_found) begin
            csr_tlbidx_index <= tlbsrch_index;
            csr_tlbidx_ne <= 1'b0;
        end
        else begin
            csr_tlbidx_ne <= 1'b1;
        end
    end
    else if (tlbrd_valid) begin // tlbrd指令
        csr_tlbidx_ps <= tlbidx_in[`TLBIDX_PS];
        csr_tlbidx_ne <= tlbidx_in[`TLBIDX_NE]; // 在tlb取反后输入进来
    end
    else if (tlbrd_invalid) begin
        csr_tlbidx_ps <= 6'b0;
        csr_tlbidx_ne <= tlbidx_in[`TLBIDX_NE];
    end
end

// TLBEHI TLB表项高位
always @(posedge clk) begin
    if (csr_we && csr_wnum == `TLBEHI) begin
        csr_tlbehi_vppn <= csr_wmask[`TLBEHI_VPPN] & csr_wdata[`TLBEHI_VPPN] | ~csr_wmask[`TLBEHI_VPPN] & csr_tlbehi_vppn;
    end
    else if (tlbrd_valid) begin
        csr_tlbehi_vppn <= tlbehi_in[`TLBEHI_VPPN];
    end
    else if (tlbrd_invalid) begin
        csr_tlbehi_vppn <= 19'b0;
    end
    else if (excp_tlb) begin // tlb重填例外、load操作页无效例外、store操作页无效例外、取指操作页无效例外、页修改例外、页特权等级不合规例外时，记录触发例外的虚地址的[31:13]位
        csr_tlbehi_vppn <= excp_tlb_vppn;
    end
end

// TLBELO0,TLBELO1 TLB表项低位
always @(posedge clk) begin
    if (csr_we && csr_wnum == `TLBELO0) begin
        csr_tlbelo0_v   <= csr_wmask[`TLBELO_V]   & csr_wdata[`TLBELO_V]   | ~csr_wmask[`TLBELO_V]   & csr_tlbelo0_v;
        csr_tlbelo0_d   <= csr_wmask[`TLBELO_D]   & csr_wdata[`TLBELO_D]   | ~csr_wmask[`TLBELO_D]   & csr_tlbelo0_d;
        csr_tlbelo0_plv <= csr_wmask[`TLBELO_PLV] & csr_wdata[`TLBELO_PLV] | ~csr_wmask[`TLBELO_PLV] & csr_tlbelo0_plv;
        csr_tlbelo0_mat <= csr_wmask[`TLBELO_MAT] & csr_wdata[`TLBELO_MAT] | ~csr_wmask[`TLBELO_MAT] & csr_tlbelo0_mat;
        csr_tlbelo0_g   <= csr_wmask[`TLBELO_G]   & csr_wdata[`TLBELO_G]   | ~csr_wmask[`TLBELO_G]   & csr_tlbelo0_g;
        csr_tlbelo0_ppn <= csr_wmask[`TLBELO_PPN] & csr_wdata[`TLBELO_PPN] | ~csr_wmask[`TLBELO_PPN] & csr_tlbelo0_ppn;
    end
    else if (tlbrd_valid) begin
        csr_tlbelo0_v   <= tlbelo0_in[`TLBELO_V];
        csr_tlbelo0_d   <= tlbelo0_in[`TLBELO_D];
        csr_tlbelo0_plv <= tlbelo0_in[`TLBELO_PLV];
        csr_tlbelo0_mat <= tlbelo0_in[`TLBELO_MAT];
        csr_tlbelo0_g   <= tlbelo0_in[`TLBELO_G];
        csr_tlbelo0_ppn <= tlbelo0_in[`TLBELO_PPN];
    end
    else if (tlbrd_invalid) begin
        csr_tlbelo0_v   <= 1'b0;
        csr_tlbelo0_d   <= 1'b0;
        csr_tlbelo0_plv <= 2'b0;
        csr_tlbelo0_mat <= 2'b0;
        csr_tlbelo0_g   <= 1'b0;
        csr_tlbelo0_ppn <= 20'b0;
    end
end

always @(posedge clk) begin
    if (csr_we && csr_wnum == `TLBELO1) begin
        csr_tlbelo1_v   <= csr_wmask[`TLBELO_V]   & csr_wdata[`TLBELO_V]   | ~csr_wmask[`TLBELO_V]   & csr_tlbelo1_v;
        csr_tlbelo1_d   <= csr_wmask[`TLBELO_D]   & csr_wdata[`TLBELO_D]   | ~csr_wmask[`TLBELO_D]   & csr_tlbelo1_d;
        csr_tlbelo1_plv <= csr_wmask[`TLBELO_PLV] & csr_wdata[`TLBELO_PLV] | ~csr_wmask[`TLBELO_PLV] & csr_tlbelo1_plv;
        csr_tlbelo1_mat <= csr_wmask[`TLBELO_MAT] & csr_wdata[`TLBELO_MAT] | ~csr_wmask[`TLBELO_MAT] & csr_tlbelo1_mat;
        csr_tlbelo1_g   <= csr_wmask[`TLBELO_G]   & csr_wdata[`TLBELO_G]   | ~csr_wmask[`TLBELO_G]   & csr_tlbelo1_g;
        csr_tlbelo1_ppn <= csr_wmask[`TLBELO_PPN] & csr_wdata[`TLBELO_PPN] | ~csr_wmask[`TLBELO_PPN] & csr_tlbelo1_ppn;
    end
    else if (tlbrd_valid) begin
        csr_tlbelo1_v   <= tlbelo1_in[`TLBELO_V];
        csr_tlbelo1_d   <= tlbelo1_in[`TLBELO_D];
        csr_tlbelo1_plv <= tlbelo1_in[`TLBELO_PLV];
        csr_tlbelo1_mat <= tlbelo1_in[`TLBELO_MAT];
        csr_tlbelo1_g   <= tlbelo1_in[`TLBELO_G];
        csr_tlbelo1_ppn <= tlbelo1_in[`TLBELO_PPN];
    end
    else if (tlbrd_invalid) begin
        csr_tlbelo1_v   <= 1'b0;
        csr_tlbelo1_d   <= 1'b0;
        csr_tlbelo1_plv <= 2'b0;
        csr_tlbelo1_mat <= 2'b0;
        csr_tlbelo1_g   <= 1'b0;
        csr_tlbelo1_ppn <= 20'b0;
    end
end

// ASID 地址空间标识符
always @(posedge clk) begin
    if (csr_we && csr_wnum == `ASID) begin
        csr_asid_asid <= csr_wmask[`ASID_ASID] & csr_wdata[`ASID_ASID] | ~csr_wmask[`ASID_ASID] & csr_asid_asid;
    end
    else if (tlbrd_valid) begin
        csr_asid_asid <= asid_in;
    end
    else if (tlbrd_invalid) begin
        csr_asid_asid <= 10'b0;
    end
end

// PGDL 低半地址空间全局目录基址
always @(posedge clk) begin
    if (csr_we && csr_wnum == `PGDL) begin
        csr_pgdl_base <= csr_wmask[`BASE] & csr_wdata[`BASE] | ~csr_wmask[`BASE] & csr_pgdl_base;
    end
end

// PGDH 高半地址空间全局目录基址
always @(posedge clk) begin
    if (csr_we && csr_wnum == `PGDH) begin
        csr_pgdh_base <= csr_wmask[`BASE] & csr_wdata[`BASE] | ~csr_wmask[`BASE] & csr_pgdh_base;
    end
end

// PGD  全局目录基址
assign csr_pgd_base = csr_badv_vaddr[31] ? csr_pgdh_base : csr_pgdl_base;

// TLBRENTRY TLB重填例外入口地址
always @(posedge clk) begin
    if (csr_we && csr_wnum == `TLBRENTRY) begin
        csr_tlbrentry_pa <= csr_wmask[`TLBRENTRY_PA] & csr_wdata[`TLBRENTRY_PA] | ~csr_wmask[`TLBRENTRY_PA] & csr_tlbrentry_pa;
    end
end

// DMW0、DMW1 直接映射配置窗口
always @(posedge clk) begin
    // if (reset) begin
    //     csr_dmw0_plv0 <= 1'b0;
    //     csr_dmw0_plv3 <= 1'b0;
    // end
    // else 
    if (csr_we && csr_wnum == `DMW0) begin
        csr_dmw0_plv0 <= csr_wmask[`DMW_PLV0] & csr_wdata[`DMW_PLV0] | ~csr_wmask[`DMW_PLV0] & csr_dmw0_plv0;
        csr_dmw0_plv3 <= csr_wmask[`DMW_PLV3] & csr_wdata[`DMW_PLV3] | ~csr_wmask[`DMW_PLV3] & csr_dmw0_plv3;
        csr_dmw0_mat  <= csr_wmask[`DMW_MAT]  & csr_wdata[`DMW_MAT]  | ~csr_wmask[`DMW_MAT]  & csr_dmw0_mat ;
        csr_dmw0_pseg <= csr_wmask[`DMW_PSEG] & csr_wdata[`DMW_PSEG] | ~csr_wmask[`DMW_PSEG] & csr_dmw0_pseg;
        csr_dmw0_vseg <= csr_wmask[`DMW_VSEG] & csr_wdata[`DMW_VSEG] | ~csr_wmask[`DMW_VSEG] & csr_dmw0_vseg;
    end
end

always @(posedge clk) begin
    // if (reset) begin
    //     csr_dmw1_plv0 <= 1'b0;
    //     csr_dmw1_plv3 <= 1'b0;
    // end
    // else 
    if (csr_we && csr_wnum == `DMW1) begin
        csr_dmw1_plv0 <= csr_wmask[`DMW_PLV0] & csr_wdata[`DMW_PLV0] | ~csr_wmask[`DMW_PLV0] & csr_dmw1_plv0;
        csr_dmw1_plv3 <= csr_wmask[`DMW_PLV3] & csr_wdata[`DMW_PLV3] | ~csr_wmask[`DMW_PLV3] & csr_dmw1_plv3;
        csr_dmw1_mat  <= csr_wmask[`DMW_MAT]  & csr_wdata[`DMW_MAT]  | ~csr_wmask[`DMW_MAT]  & csr_dmw1_mat ;
        csr_dmw1_pseg <= csr_wmask[`DMW_PSEG] & csr_wdata[`DMW_PSEG] | ~csr_wmask[`DMW_PSEG] & csr_dmw1_pseg;
        csr_dmw1_vseg <= csr_wmask[`DMW_VSEG] & csr_wdata[`DMW_VSEG] | ~csr_wmask[`DMW_VSEG] & csr_dmw1_vseg;
    end
end

//use for disable cache or enable cache
always @(posedge clk) begin
    if (reset) begin
        csr_disable_cache <= 32'b0;
    end
    if (csr_we && csr_wnum == `DISABLE_CACHE) begin
        csr_disable_cache <= csr_wmask & csr_wdata | ~csr_wmask & csr_disable_cache;
    end
end

//cpucfg1
always @(posedge clk) begin
    if (reset) begin
        csr_cpucfg1 <= 32'h1f1f4;
    end 
end

//cpucfg2
always @(posedge clk) begin
    if (reset) begin
        csr_cpucfg2 <= 32'h0;
    end 
end

//cpucfg10
always @(posedge clk) begin
    if (reset) begin
        csr_cpucfg10 <= 32'h5;
    end 
end

//cpucfg11
always @(posedge clk) begin
    if (reset) begin
        csr_cpucfg11 <= 32'h04080003;
    end 
end

//cpucfg12
always @(posedge clk) begin
    if (reset) begin
        csr_cpucfg12 <= 32'h04080003;
    end 
end

//cpucfg13
always @(posedge clk) begin
    if (reset) begin
        csr_cpucfg13 <= 32'h0;
    end 
end


//================================ CSR读出逻辑 ================================
wire [31:0] csr_crmd_rdata      = {23'b0, csr_crmd_datm, csr_crmd_datf, csr_crmd_pg, csr_crmd_da, csr_crmd_ie, csr_crmd_plv};
wire [31:0] csr_prmd_rdata      = {29'b0, csr_prmd_pie, csr_prmd_pplv};
wire [31:0] csr_ecfg_rdata      = {19'b0, csr_ecfg_lie};
wire [31:0] csr_estat_rdata     = {1'b0, csr_estat_esubcode, csr_estat_ecode, 3'b0, csr_estat_is};
wire [31:0] csr_era_rdata       = csr_era_pc;
wire [31:0] csr_badv_rdata      = csr_badv_vaddr;
wire [31:0] csr_eentry_rdata    = {csr_eentry_va, 6'b0};
wire [31:0] csr_save0_rdata     = csr_save0_data;
wire [31:0] csr_save1_rdata     = csr_save1_data;
wire [31:0] csr_save2_rdata     = csr_save2_data;
wire [31:0] csr_save3_rdata     = csr_save3_data;
wire [31:0] csr_cpuid_rdata     = csr_cpuid;
wire [31:0] csr_llbctl_rdata    = {29'b0, csr_llbctl_klo, csr_llbctl_wcllb, llbit};
wire [31:0] csr_tid_rdata       = csr_tid_tid;
wire [31:0] csr_tcfg_rdata      = {csr_tcfg_initval, csr_tcfg_periodic, csr_tcfg_en};
wire [31:0] csr_tval_rdata      = csr_tval;
wire [31:0] csr_cntc_rdata      = csr_cntc;
wire [31:0] csr_ticlr_rdata     = {31'b0, csr_ticlr_clr};
// tlb相关寄存器
wire [31:0] csr_tlbidx_rdata    = {csr_tlbidx_ne, 1'b0, csr_tlbidx_ps, 21'b0, csr_tlbidx_index};
wire [31:0] csr_tlbehi_rdata    = {csr_tlbehi_vppn, 13'b0};
wire [31:0] csr_tlbelo0_rdata   = {4'b0, csr_tlbelo0_ppn, 1'b0, csr_tlbelo0_g, csr_tlbelo0_mat, csr_tlbelo0_plv, csr_tlbelo0_d, csr_tlbelo0_v};
wire [31:0] csr_tlbelo1_rdata   = {4'b0, csr_tlbelo1_ppn, 1'b0, csr_tlbelo1_g, csr_tlbelo1_mat, csr_tlbelo1_plv, csr_tlbelo1_d, csr_tlbelo1_v};
wire [31:0] csr_asid_rdata      = {22'h280, csr_asid_asid}; // ASIDBITS = 10
wire [31:0] csr_pgdl_rdata      = {csr_pgdl_base, 12'b0};
wire [31:0] csr_pgdh_rdata      = {csr_pgdh_base, 12'b0};
wire [31:0] csr_pgd_rdata       = {csr_pgd_base , 12'b0};
wire [31:0] csr_tlbrentry_rdata = {csr_tlbrentry_pa, 6'b0};
wire [31:0] csr_dmw0_rdata      = {csr_dmw0_vseg, 1'b0, csr_dmw0_pseg, 19'b0, csr_dmw0_mat, csr_dmw0_plv3, 2'b0, csr_dmw0_plv0};
wire [31:0] csr_dmw1_rdata      = {csr_dmw1_vseg, 1'b0, csr_dmw1_pseg, 19'b0, csr_dmw1_mat, csr_dmw1_plv3, 2'b0, csr_dmw1_plv0};
// cpucfg
wire [31:0] csr_cpucfg1_rdata   = csr_cpucfg1;
wire [31:0] csr_cpucfg2_rdata   = csr_cpucfg2;
wire [31:0] csr_cpucfg10_rdata  = csr_cpucfg10;
wire [31:0] csr_cpucfg11_rdata  = csr_cpucfg11;
wire [31:0] csr_cpucfg12_rdata  = csr_cpucfg12;
wire [31:0] csr_cpucfg13_rdata  = csr_cpucfg13;

assign timer_64_rdata = timer_64 + {{32{csr_cntc[31]}}, csr_cntc};

// 读数据为组合逻辑，即异步读
// assign csr_rdata = {32{csr_rnum == `CRMD}}       & csr_crmd_rdata
//                   | {32{csr_rnum == `PRMD}}      & csr_prmd_rdata
//                   | {32{csr_rnum == `ECFG}}      & csr_ecfg_rdata
//                   | {32{csr_rnum == `ESTAT}}     & csr_estat_rdata
//                   | {32{csr_rnum == `ERA}}       & csr_era_rdata
//                   | {32{csr_rnum == `BADV}}      & csr_badv_rdata
//                   | {32{csr_rnum == `EENTRY}}    & csr_eentry_rdata
//                   | {32{csr_rnum == `SAVE0}}     & csr_save0_rdata
//                   | {32{csr_rnum == `SAVE1}}     & csr_save1_rdata
//                   | {32{csr_rnum == `SAVE2}}     & csr_save2_rdata
//                   | {32{csr_rnum == `SAVE3}}     & csr_save3_rdata
//                   | {32{csr_rnum == `CPUID}}     & csr_cpuid_rdata
//                   | {32{csr_rnum == `LLBCTL}}    & csr_llbctl_rdata
//                   | {32{csr_rnum == `TID}}       & csr_tid_rdata
//                   | {32{csr_rnum == `TCFG}}      & csr_tcfg_rdata
//                   | {32{csr_rnum == `TVAL}}      & csr_tval_rdata
//                   | {32{csr_rnum == `CNTC}}      & csr_cntc_rdata
//                   | {32{csr_rnum == `TICLR}}     & csr_ticlr_rdata
//                   | {32{csr_rnum == `TLBIDX}}    & csr_tlbidx_rdata
//                   | {32{csr_rnum == `TLBEHI}}    & csr_tlbehi_rdata
//                   | {32{csr_rnum == `TLBELO0}}   & csr_tlbelo0_rdata
//                   | {32{csr_rnum == `TLBELO1}}   & csr_tlbelo1_rdata
//                   | {32{csr_rnum == `ASID}}      & csr_asid_rdata
//                   | {32{csr_rnum == `PGDL}}      & csr_pgdl_rdata
//                   | {32{csr_rnum == `PGDH}}      & csr_pgdh_rdata
//                   | {32{csr_rnum == `PGD }}      & csr_pgd_rdata
//                   | {32{csr_rnum == `TLBRENTRY}} & csr_tlbrentry_rdata
//                   | {32{csr_rnum == `DMW0}}      & csr_dmw0_rdata
//                   | {32{csr_rnum == `DMW1}}      & csr_dmw1_rdata
//                   | {32{csr_rnum == `CPUCFG1}}   & csr_cpucfg1_rdata
//                   | {32{csr_rnum == `CPUCFG2}}   & csr_cpucfg2_rdata
//                   | {32{csr_rnum == `CPUCFG10}}  & csr_cpucfg10_rdata
//                   | {32{csr_rnum == `CPUCFG11}}  & csr_cpucfg11_rdata
//                   | {32{csr_rnum == `CPUCFG12}}  & csr_cpucfg12_rdata
//                   | {32{csr_rnum == `CPUCFG13}}  & csr_cpucfg13_rdata ;

always_comb begin
    unique case (csr_rnum)
        `CRMD      : csr_rdata =  csr_crmd_rdata ;
        `PRMD      : csr_rdata =  csr_prmd_rdata ;
        `ECFG      : csr_rdata =  csr_ecfg_rdata ;
        `ESTAT     : csr_rdata =  csr_estat_rdata ;
        `ERA       : csr_rdata =  csr_era_rdata ;
        `BADV      : csr_rdata =  csr_badv_rdata ;
        `EENTRY    : csr_rdata =  csr_eentry_rdata ;
        `SAVE0     : csr_rdata =  csr_save0_rdata ;
        `SAVE1     : csr_rdata =  csr_save1_rdata ;
        `SAVE2     : csr_rdata =  csr_save2_rdata ;
        `SAVE3     : csr_rdata =  csr_save3_rdata ;
        `CPUID     : csr_rdata =  csr_cpuid_rdata ;
        `LLBCTL    : csr_rdata =  csr_llbctl_rdata ;
        `TID       : csr_rdata =  csr_tid_rdata ;
        `TCFG      : csr_rdata =  csr_tcfg_rdata ;
        `TVAL      : csr_rdata =  csr_tval_rdata ;
        `CNTC      : csr_rdata =  csr_cntc_rdata ;
        `TICLR     : csr_rdata =  csr_ticlr_rdata ;
        `TLBIDX    : csr_rdata =  csr_tlbidx_rdata ;
        `TLBEHI    : csr_rdata =  csr_tlbehi_rdata ;
        `TLBELO0   : csr_rdata =  csr_tlbelo0_rdata ;
        `TLBELO1   : csr_rdata =  csr_tlbelo1_rdata ;
        `ASID      : csr_rdata =  csr_asid_rdata ;
        `PGDL      : csr_rdata =  csr_pgdl_rdata ;
        `PGDH      : csr_rdata =  csr_pgdh_rdata ;
        `PGD       : csr_rdata =  csr_pgd_rdata ;
        `TLBRENTRY : csr_rdata =  csr_tlbrentry_rdata ;
        `DMW0      : csr_rdata =  csr_dmw0_rdata ;
        `DMW1      : csr_rdata =  csr_dmw1_rdata ;
        `CPUCFG1   : csr_rdata =  csr_cpucfg1_rdata ;
        `CPUCFG2   : csr_rdata =  csr_cpucfg2_rdata ;
        `CPUCFG10  : csr_rdata =  csr_cpucfg10_rdata ;
        `CPUCFG11  : csr_rdata =  csr_cpucfg11_rdata ;
        `CPUCFG12  : csr_rdata =  csr_cpucfg12_rdata ;
        `CPUCFG13  : csr_rdata =  csr_cpucfg13_rdata ;
        default    : csr_rdata =  32'b0;
    endcase
end

assign has_int = ((csr_estat_is[12:0] & csr_ecfg_lie[12:0]) != 13'b0) && (csr_crmd_ie == 1'b1);

assign special_init = csr_estat_is[11] & csr_ecfg_lie[11] & (csr_crmd_ie == 1'b1) ;
//================================ 部分寄存器值读出的选择逻辑 ================================

assign ex_entry   = csr_eentry_rdata;
assign ertn_entry = csr_era_rdata;
assign tlb_entry  = csr_tlbrentry_rdata;

// 传给pre-IF和EXE阶段，用于地址翻译的信号
assign csr_pg   = csr_crmd_pg;

assign csr_da   = csr_crmd_da;

assign csr_dmw0 = csr_dmw0_rdata;
assign csr_dmw1 = csr_dmw1_rdata;

assign csr_plv  = csr_crmd_plv;

assign csr_datf = csr_crmd_datf;
assign csr_datm = csr_crmd_datm;

// 与tlb的交互信号，与tlb指令相关
assign csr_asid         = csr_asid_asid;
assign csr_rand_index   = timer_64[ 2:0];
// 改的时候如果要读，立马读出要修改的数
assign csr_tlbehi       = csr_tlbehi_rdata;
assign csr_tlbelo0      = csr_tlbelo0_rdata;
assign csr_tlbelo1      = csr_tlbelo1_rdata;
assign csr_tlbidx       = csr_tlbidx_rdata;
assign csr_ecode        = csr_estat_ecode;

assign llbit_out        = llbit;
assign lladdr_out       = lladdr;

// disable cache
assign disable_cache    = csr_disable_cache[0];


`ifdef DIFFTEST_EN
assign csr_crmd_diff        = csr_crmd_rdata;
assign csr_prmd_diff        = csr_prmd_rdata;
assign csr_ectl_diff        = csr_ecfg_rdata;
assign csr_estat_diff       = csr_estat_rdata;
assign csr_era_diff         = csr_era_rdata;
assign csr_badv_diff        = csr_badv_rdata;
assign csr_eentry_diff      = csr_eentry_rdata;
assign csr_tlbidx_diff      = csr_tlbidx_rdata;
assign csr_tlbehi_diff      = csr_tlbehi_rdata;
assign csr_tlbelo0_diff     = csr_tlbelo0_rdata;
assign csr_tlbelo1_diff     = csr_tlbelo1_rdata;
assign csr_asid_diff        = csr_asid_rdata;
assign csr_save0_diff       = csr_save0_rdata;
assign csr_save1_diff       = csr_save1_rdata;
assign csr_save2_diff       = csr_save2_rdata;
assign csr_save3_diff       = csr_save3_rdata;
assign csr_tid_diff         = csr_tid_rdata;
assign csr_tcfg_diff        = csr_tcfg_rdata;
assign csr_tval_diff        = csr_tval_rdata;
assign csr_ticlr_diff       = csr_ticlr_rdata;
assign csr_llbctl_diff      = csr_llbctl_rdata;
assign csr_tlbrentry_diff   = csr_tlbrentry_rdata;
assign csr_dmw0_diff        = csr_dmw0_rdata;
assign csr_dmw1_diff        = csr_dmw1_rdata;
assign csr_pgdl_diff        = csr_pgdl_rdata;
assign csr_pgdh_diff        = csr_pgdh_rdata;
`endif
endmodule
