// 头文件包含：定义了CSR（控制状态寄存器）相关宏
`include "./mycpu.vh"

// TLB地址转换模块
// 参数：
//   TLBNUM = 32  - TLB条目总数
module addr_trans #(
    parameter TLBNUM = 8
)(
    //======================== 基础信号 ========================//
    input wire         clk,                 // 主时钟
    input wire [9:0]   asid,                // 地址空间标识符（Address Space ID）,连接csr_asid
    


    input wire         data_fetch,           // 数据访问请求
    input wire [31:0]  data_vaddr,           // 数据虚拟地址
    input wire         data_dmw0_en,        // 数据使用直接映射窗口0
    input wire         data_dmw1_en,        // 数据使用直接映射窗口1
    input wire         cacop_op_mode_di,    // Cache操作模式（直写/回写）
    output wire [7:0]  data_index,          // 数据TLB匹配索引
    output wire [19:0] data_tag,            // 数据物理地址标签
    output wire [3:0]  data_offset,         // 数据页内偏移
    //output wire  [31:0] data_tran_addr,     //连接总线

    output wire        data_tlb_found,      // 数据TLB命中标志
    output wire [2:0]  data_tlb_index,      // 数据TLB索引（用于读写操作）
    output wire        data_tlb_v,          // 数据页表项有效位
    output wire        data_tlb_d,          // 数据页表项脏位
    output wire [1:0]  data_tlb_mat,         // 数据存储访问类型
    output wire [1:0]  data_tlb_plv,         // 数据访问权限等级
    output wire [19:0] data_tlb_ppn,         // 数据页表项物理页号
    



    //======================== 模式控制信号 ========================//
    input wire         inst_addr_trans_en,  // 指令地址转换使能
    input wire         data_addr_trans_en,  // 数据地址转换使能
    
    //======================== 指令地址转换接口 ========================//
    input wire         inst_fetch,          // 指令取指请求
    input wire [31:0]  inst_vaddr,          // 指令虚拟地址（Virtual Address），是nextpc
    input wire         inst_dmw0_en,        // 指令使用直接映射窗口0（Direct Map Window）
    input wire         inst_dmw1_en,        // 指令使用直接映射窗口1
    output wire [7:0]  inst_index,          // 指令TLB匹配索引
    output wire [19:0] inst_tag,            // 指令物理地址标签
    output wire [3:0]  inst_offset,         // 指令页内偏移（用于4KB页）
    //output wire [31:0] inst_tran_addr,     //连接总线

    output wire        inst_tlb_found,      // 指令TLB命中标志
    output wire        inst_tlb_v,          // 指令页表项有效位（Valid）
    output wire        inst_tlb_d,          // 指令页表项脏位（Dirty）
    output wire [1:0]  inst_tlb_mat,         // 指令存储访问类型（Memory Access Type）
    output wire [1:0]  inst_tlb_plv,         // 指令访问权限等级（Privilege Level）
    

     //======================== TLB维护接口 ========================//
    //======================== 数据地址转换接口 ========================//
    
    //======================== TLB读取接口 ========================//
    output wire [31:0] tlbehi_out,          // 输出的TLB EntryHi值，tlbr_tlbehi
    output wire [31:0] tlbelo0_out,         // 输出的TLB EntryLo0值，tlbr_tlbelo0
    output wire [31:0] tlbelo1_out,         // 输出的TLB EntryLo1值，tlbr_tlbelo1
    output wire [31:0] tlbidx_out,          // 输出的TLB Index值，tlbr_tlbidx
    output wire [9:0]  asid_out,            // 输出的ASID值，tlbr_asid
    
    //======================== TLB无效化接口 ========================//
    input wire         invtlb_inst,         // 表示有invtlb指令，但是该指令不一定执行，该信号作为复用原来的数据通路的选择信号
    input wire         invtlb_en,           // TLB无效化使能，该信号表示有invtlb指令并且该指令需要执行
    input wire [9:0]   invtlb_asid,         // 无效化目标的ASID
    input wire [18:0]  invtlb_vpn,          // 无效化目标的虚拟页号（VPN）
    input wire [4:0]   invtlb_op,           // 无效化操作类型（按ASID/VPN等）


    input wire         tlbfill_en,          // TLB填充使能（来自TLB指令）
    input wire         tlbwr_en,            // TLB随机写入使能
    input wire [2:0]   rand_index,          // 随机替换索引（由硬件生成）
    input wire [31:0]  tlbehi_in,           // 输入的TLB EntryHi值（VPN & ASID）,连接tlbw_tlbehi
    input wire [31:0]  tlbelo0_in,          // 输入的TLB EntryLo0值（PPN0 & 属性），连接tlbw_tlbelo0
    input wire [31:0]  tlbelo1_in,          // 输入的TLB EntryLo1值（PPN1 & 属性），连接tlbw_tlbelo1
    input wire [31:0]  tlbidx_in,           // 输入的TLB Index值（索引 & 属性），连接tlbw_r_tlbidx
    input wire [5:0]   ecode_in,            // 异常编码（用于TLB异常处理），连接tlbw_ecode
    
    //======================== CSR接口 ========================//
    input wire [31:0]  csr_dmw0,            // 直接映射窗口0配置寄存器
    input wire [31:0]  csr_dmw1,            // 直接映射窗口1配置寄存器
    input wire         csr_da,              // 直接地址模式（禁用地址转换）
    input wire         csr_pg               // 分页模式使能
);

//======================== 内部信号定义 ========================//
// TLB查找阶段信号
wire [18:0] inst_s0_vppn;     // 阶段0：虚拟页号（Virtual Page Number）
wire        inst_s0_va_bit12; // 阶段0：奇偶页标志（用于大页）
wire [5:0]  inst_s0_ps;       // 阶段0：页大小（Page Size）
wire [19:0] inst_s0_ppn;      // 阶段0：物理页号（Physical Page Number）

wire [18:0] data_s1_vppn;     // 阶段1：虚拟页号
wire        data_s1_va_bit12; 
wire [ 9:0] data_s1_asid;
wire [ 5:0] data_s1_ps;       
wire [19:0] data_s1_ppn;      

// TLB读写接口信号
wire        we;           // TLB写使能
wire [ 2:0] w_tlb_index;      // 写入的TLB索引
wire [18:0] w_tlb_vppn;       // 写入的虚拟页号
wire        w_tlb_g;          // 全局标志（Global）
wire [5:0]  w_tlb_ps;         // 写入的页大小
wire        w_tlb_e;          // 异常标志（Exception）
wire        w_tlb_v0;         // 页表项0有效位
wire        w_tlb_d0;         // 页表项0脏位
wire [1:0] w_tlb_mat0;        // 页表项0存储类型
wire [1:0] w_tlb_plv0;        // 页表项0权限等级
wire [19:0] w_tlb_ppn0;       // 页表项0物理页号
wire        w_tlb_v1;         // 页表项1有效位
wire        w_tlb_d1;         // 页表项1脏位
wire [1:0] w_tlb_mat1;        
wire [1:0] w_tlb_plv1;        
wire [19:0] w_tlb_ppn1;       


wire        r_tlb_d1;         
wire [1:0] r_tlb_mat1;        
wire [1:0] r_tlb_plv1;        
wire [19:0] r_tlb_ppn1;
wire [ 2:0] r_tlb_index;      // 读取的TLB索引
wire [18:0] r_tlb_vppn;       // 读取的虚拟页号
wire [9:0]  r_tlb_asid;  
wire        r_tlb_d0;         
wire [1:0] r_tlb_mat0;        
wire [1:0] r_tlb_plv0;        
wire [19:0] r_tlb_ppn0;       
wire        r_tlb_v1;              // 读取的ASID
wire        r_tlb_g;          
wire [5:0]  r_tlb_ps;         
wire        r_tlb_e;          
wire        r_tlb_v0;         
       

// 地址转换信号定义
//wire [ 7:0] inst_index;          // 指令TLB匹配索引
//wire [19:0] inst_tag;            // 指令物理地址标签
//wire [ 3:0] inst_offset;         // 指令页内偏移（用于4KB页）
//wire [ 7:0] data_index;          // 数据TLB匹配索引
//wire [19:0] data_tag;            // 数据物理地址标签
//wire [ 3:0] data_offset;         // 数据页内偏移



// 物理地址输出（示例信号，可能需要连接到其他模块）
wire [31:0] inst_paddr;   // 转换后的指令物理地址
wire [31:0] data_paddr;   // 转换后的数据物理地址

// 模式信号
wire        pg_mode;      // 分页模式（来自csr_pg）
wire        da_mode;      // 直接地址模式（来自csr_da）



//======================== 注释说明 ========================//
// 功能概述：
//   本模块实现基于TLB的虚拟地址到物理地址转换，支持两种模式：
//   1. 分页模式（通过TLB查询转换地址）
//   2. 直接映射模式（通过DMW窗口绕过TLB）
//   
// 关键流程：
//   1. 根据csr_pg和csr_da判断当前地址转换模式
//   2. 若启用分页模式，进行TLB查询：
//      - 阶段0（s0）：生成VPN、页大小等参数
//      - 阶段1（s1）：匹配TLB条目并生成物理地址
//   3. 若启用直接映射，使用DMW窗口计算物理地址
//   
// TLB维护操作：
//   - tlbfill_en: 通过TLB指令填充条目
//   - tlbwr_en:   随机替换TLB条目
//   - invtlb_en:  根据操作类型无效化TLB条目
//===========================================================//


// 转换查找端口信号定义
// 指令地址转换相关信号提取
assign inst_s0_vppn     = inst_vaddr[31:13];  // 指令虚拟地址的虚拟页号（VPN）[31:13]
assign inst_s0_va_bit12 = inst_vaddr[12];     // 指令地址的奇偶页标志（用于大页对齐）

// 数据地址转换相关信号提取
// invtlb指令的数据通路复用数据端的搜索端口
//assign s1_vppn     = data_vaddr[31:13];  // 数据虚拟地址的虚拟页号（VPN）[31:13]
assign data_s1_vppn    =   {19{invtlb_inst}} & invtlb_vpn | {19{!invtlb_inst}} & data_vaddr[31:13];
//assign s1_va_bit12 = data_vaddr[12];     // 数据地址的奇偶页标志
assign data_s1_va_bit12 = !invtlb_inst && data_vaddr[12];
assign data_s1_asid = {10{invtlb_inst}} & invtlb_asid  |  {10{!invtlb_inst}} & asid;



assign we      = tlbfill_en || tlbwr_en;  // TLB写使能（填充或随机写入）
assign w_tlb_index = ({3{tlbfill_en}} & rand_index) |  // 填充时使用随机索引
                 ({3{tlbwr_en}} & tlbidx_in[`TLBIDX_INDEX]); // 写入时使用指定索引
assign w_tlb_vppn  = tlbehi_in[`TLBEHI_VPPN];       // 写入的虚拟页号（来自EntryHi）
assign w_tlb_g     = tlbelo0_in[`TLBELO_G] && tlbelo1_in[`TLBELO_G]; // 全局条目标志（双页均全局）
assign w_tlb_ps    = tlbidx_in[`TLBIDX_PS];         // 页大小（Page Size）
assign w_tlb_e     = (ecode_in == 6'h3f) ? 1'b1 : !tlbidx_in[`TLBIDX_NE]; // 异常标志处理

//====================== TLB读端口信号生成 ======================//
assign r_tlb_index      = tlbidx_in[`TLBIDX_INDEX]; // 读取的TLB索引
assign tlbehi_out   = {r_tlb_vppn, 13'b0};   // 输出EntryHi寄存器值（VPN + 填充）
assign tlbelo0_out  = {4'b0, r_tlb_ppn0, 1'b0, r_tlb_g, r_tlb_mat0, r_tlb_plv0, r_tlb_d0, r_tlb_v0}; // 组合EntryLo0
assign tlbelo1_out  = {4'b0, r_tlb_ppn1, 1'b0, r_tlb_g, r_tlb_mat1, r_tlb_plv1, r_tlb_d1, r_tlb_v1}; // 组合EntryLo1
assign tlbidx_out   = {!r_tlb_e, 1'b0, r_tlb_ps, 24'b0}; // 输出TLB Index寄存器（注意不写索引）
assign asid_out     = r_tlb_asid;            // 输出当前ASID



//====================== TLB写端口信号生成 ======================//
assign w_tlb_v0    = tlbelo0_in[`TLBELO_V];     // 页表项0有效位
assign w_tlb_d0    = tlbelo0_in[`TLBELO_D];     // 页表项0脏位
assign w_tlb_plv0  = tlbelo0_in[`TLBELO_PLV];   // 页表项0权限等级
assign w_tlb_mat0  = tlbelo0_in[`TLBELO_MAT];   // 页表项0存储类型
assign w_tlb_ppn0  = tlbelo0_in[`TLBELO_PPN];// 页表项0物理页号
assign w_tlb_v1    = tlbelo1_in[`TLBELO_V];     // 页表项1有效位
assign w_tlb_d1    = tlbelo1_in[`TLBELO_D];     // 页表项1脏位
assign w_tlb_plv1  = tlbelo1_in[`TLBELO_PLV];   // 页表项1权限等级
assign w_tlb_mat1  = tlbelo1_in[`TLBELO_MAT];   // 页表项1存储类型
assign w_tlb_ppn1  = tlbelo1_in[`TLBELO_PPN];// 页表项1物理页号






//====================== 物理地址生成逻辑 ======================//
assign pg_mode = !csr_da &&  csr_pg;  // 分页模式使能（非直接地址且分页使能）
assign da_mode =  csr_da && !csr_pg;  // 直接地址模式

// 指令物理地址生成，本来是inst_vaddr_buffer的，我感觉不用锁存所以删掉了，看看这样对不对
assign inst_paddr = (pg_mode && inst_dmw0_en) ? {csr_dmw0[`DMW_PSEG], inst_vaddr[28:0]} :  // DMW0直接映射
                    (pg_mode && inst_dmw1_en) ? {csr_dmw1[`DMW_PSEG], inst_vaddr[28:0]} :  // DMW1直接映射
                    inst_vaddr;  // 直接地址模式或未命中DMW

// 指令侧地址分解
assign inst_offset = inst_vaddr[3:0];   // 页内偏移（4KB页）
assign inst_index  = inst_vaddr[11:4];  // TLB索引位
assign inst_tag    = inst_addr_trans_en ? 
                    ((inst_s0_ps == 6'd12) ? inst_s0_ppn : {inst_s0_ppn[19:10], inst_paddr[21:12]}) :  // 分页模式标签
                    inst_paddr[31:12];  // 直接地址模式标签

//assign inst_tran_addr={inst_tag,inst_index,inst_offset};

// 数据物理地址生成
assign data_paddr = (pg_mode && data_dmw0_en && !cacop_op_mode_di) ? {csr_dmw0[`DMW_PSEG], data_vaddr[28:0]} : 
                    (pg_mode && data_dmw1_en && !cacop_op_mode_di) ? {csr_dmw1[`DMW_PSEG], data_vaddr[28:0]} : 
                    data_vaddr;


// 数据侧地址分解
assign data_offset = data_vaddr[3:0];   // 页内偏移
assign data_index  = data_vaddr[11:4];  // TLB索引位
assign data_tag    = data_addr_trans_en ? 
                    ((data_s1_ps == 6'd12) ? data_s1_ppn : {data_s1_ppn[19:10], data_paddr[21:12]}) :  // 分页模式标签
                    data_paddr[31:12];  // 直接地址模式标签


//assign data_tran_addr={data_tag,data_index,data_offset};



//====================== TLB条目实例化 ======================//
tlb u_tlb(
    .clk            (clk            ),   // 主时钟
    // 搜索端口0（指令侧）
    //.s0_fetch       (inst_fetch     ),   // 指令地址转换请求
    .inst_s0_vppn        (inst_s0_vppn        ),   // 指令虚拟页号
    .inst_s0_va_bit12    (inst_s0_va_bit12    ),   // 指令奇偶页标志
    .inst_s0_asid        (asid           ),   // 当前ASID
    .inst_s0_found       (inst_tlb_found ),   // 指令TLB命中标志
    .inst_s0_index       (),                  // 未连接的指令索引
    .inst_s0_ps          (inst_s0_ps          ),   // 指令页大小
    .inst_s0_ppn         (inst_s0_ppn         ),   // 指令物理页号
    .inst_s0_v           (inst_tlb_v     ),   // 指令页表项有效位
    .inst_s0_d           (inst_tlb_d     ),   // 指令页表项脏位
    .inst_s0_mat         (inst_tlb_mat   ),   // 指令存储类型
    .inst_s0_plv         (inst_tlb_plv   ),   // 指令权限等级
    // 搜索端口1（数据侧）
    //.s1_fetch       (data_fetch     ),   // 数据地址转换请求
    .data_s1_vppn        (data_s1_vppn        ),   // 数据虚拟页号
    .data_s1_va_bit12    (data_s1_va_bit12    ),   // 数据奇偶页标志
    .data_s1_asid        (data_s1_asid        ),   // 当前ASID
    .data_s1_found       (data_tlb_found ),   // 数据TLB命中标志
    .data_s1_index       (data_tlb_index ),   // 数据TLB索引
    .data_s1_ps          (data_s1_ps          ),   // 数据页大小
    .data_s1_ppn         (data_s1_ppn         ),   // 数据物理页号
    .data_s1_v           (data_tlb_v     ),   // 数据页表项有效位
    .data_s1_d           (data_tlb_d     ),   // 数据页表项脏位
    .data_s1_mat         (data_tlb_mat   ),   // 数据存储类型
    .data_s1_plv         (data_tlb_plv   ),   // 数据权限等级
    // 写端口
    // 读端口
    .r_tlb_index        (r_tlb_index        ),   // 读取索引
    .r_tlb_vppn         (r_tlb_vppn         ),   // 读取虚拟页号
    .r_tlb_asid         (r_tlb_asid         ),   // 读取ASID
    .r_tlb_g            (r_tlb_g            ),   // 全局标志
    .r_tlb_ps           (r_tlb_ps           ),   // 读取页大小
    .r_tlb_e            (r_tlb_e            ),   // 异常标志
    .r_tlb_v0           (r_tlb_v0           ),   // 页表项0有效位
    .r_tlb_d0           (r_tlb_d0           ),   // 页表项0脏位
    .r_tlb_mat0         (r_tlb_mat0         ),   // 页表项0存储类型
    .r_tlb_plv0         (r_tlb_plv0         ),   // 页表项0权限
    .r_tlb_ppn0         (r_tlb_ppn0         ),   // 页表项0物理页号
    .r_tlb_v1           (r_tlb_v1           ),   // 页表项1有效位
    .r_tlb_d1           (r_tlb_d1           ),   // 页表项1脏位
    .r_tlb_mat1         (r_tlb_mat1         ),   // 页表项1存储类型
    .r_tlb_plv1         (r_tlb_plv1         ),   // 页表项1权限
    .r_tlb_ppn1         (r_tlb_ppn1         ),   // 页表项1物理页号



    .we             (we             ),   // TLB写使能
    .w_tlb_index        (w_tlb_index        ),   // 写入索引
    .w_tlb_vppn         (w_tlb_vppn         ),   // 写入虚拟页号
    .w_tlb_asid         (asid           ),   // 写入ASID
    .w_tlb_g            (w_tlb_g            ),   // 全局标志
    .w_tlb_ps           (w_tlb_ps           ),   // 写入页大小
    .w_tlb_e            (w_tlb_e            ),   // 异常标志
    .w_tlb_v0           (w_tlb_v0           ),   // 页表项0有效位
    .w_tlb_d0           (w_tlb_d0           ),   // 页表项0脏位
    .w_tlb_plv0         (w_tlb_plv0         ),   // 页表项0权限
    .w_tlb_mat0         (w_tlb_mat0         ),   // 页表项0存储类型
    .w_tlb_ppn0         (w_tlb_ppn0         ),   // 页表项0物理页号
    .w_tlb_v1           (w_tlb_v1           ),   // 页表项1有效位
    .w_tlb_d1           (w_tlb_d1           ),   // 页表项1脏位
    .w_tlb_plv1         (w_tlb_plv1         ),   // 页表项1权限
    .w_tlb_mat1         (w_tlb_mat1         ),   // 页表项1存储类型
    .w_tlb_ppn1         (w_tlb_ppn1         ),   // 页表项1物理页号
    // 无效化端口
    .invtlb_valid   (invtlb_en      ),   // TLB无效化使能
    .invtlb_op      (invtlb_op      )   // 无效化操作类型
);


endmodule
