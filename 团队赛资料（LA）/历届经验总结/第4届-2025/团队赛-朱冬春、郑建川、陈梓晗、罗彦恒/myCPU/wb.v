`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"

module wb
(
    input wire clk,
    input wire rst,
    input wire flush,
    input wire uncache_i,

   //   mem浼犲叆鐨勪俊�??
    input wire  [1:0]wb_reg_write_en, 
    input wire  [4:0] wb_reg_write_addr1,
    input wire  [4:0] wb_reg_write_addr2,
    input wire  [31:0] wb_reg_write_data1,
    input wire  [31:0] wb_reg_write_data2,
    input wire  [1:0]wb_csr_write_en, //CSR瀵勫瓨鍣ㄥ啓浣胯�?
    input wire  [13:0] wb_csr_addr1, //CSR瀵勫瓨鍣ㄥ湴�??
    input wire  [13:0] wb_csr_addr2,
    input wire  [31:0] wb_csr_write_data1,
    input wire  [31:0] wb_csr_write_data2,
    input wire  [1:0]  wb_is_llw_scw, //鏄惁鏄疞LW/SCW鎸囦�?
    input wire  wb_is_llw,

    input wire  [1:0] commit_valid, //鎸囦护鏄惁鏈夋�?
    input wire  [5:0]  is_exception1_i,
    input wire  [5:0]  is_exception2_i,
    input wire  [6:0]  pc_exception_cause1_i,
    input wire  [6:0]  pc_exception_cause2_i, 
    input wire  [6:0]  instbuffer_exception_cause1_i,
    input wire  [6:0]  instbuffer_exception_cause2_i,
    input wire  [6:0]  decoder_exception_cause1_i,
    input wire  [6:0]  decoder_exception_cause2_i,
    input wire  [6:0]  dispatch_exception_cause1_i,
    input wire  [6:0]  dispatch_exception_cause2_i,
    input wire  [6:0]  execute_exception_cause1_i,
    input wire  [6:0]  execute_exception_cause2_i,
    input wire  [6:0]  commit_exception_cause1_i,
    input wire  [6:0]  commit_exception_cause2_i,


    input wire  [31:0] commit_pc1,
    input wire  [31:0] commit_pc2,
    input wire  [63:0] commit_count_64_i1,
    input wire  [63:0] commit_count_64_i2,
    input wire  [31:0] commit_addr1, //鍐呭瓨鍦板潃
    input wire  [31:0] commit_addr2,
    input wire  [1:0]  commit_idle, //鏄惁鏄┖闂叉寚浠?
    input wire  [1:0]  commit_ertn, //鏄惁鏄紓甯歌繑鍥炴寚�??
    input wire  [1:0]  commit_is_privilege, //鐗规潈鎸囦护
    input wire  [1:0]  commit_icacop_en,

    input wire pause_mem,

    output reg [1:0]  wb_pf_reg_write_en, //杈撳嚭鐨勫瘎瀛樺櫒鍐欎娇�??
    output reg [4:0]  wb_pf_reg_write_addr1, //杈撳嚭鐨勫瘎瀛樺櫒鍐欏湴�??
    output reg [4:0]  wb_pf_reg_write_addr2,
    output reg [31:0] wb_pf_reg_write_data1,
    output reg [31:0] wb_pf_reg_write_data2, 

    // to ctrl
    output reg  [1:0]  ctrl_reg_write_en, 
    output reg  [4:0]  ctrl_reg_write_addr1,
    output reg  [4:0]  ctrl_reg_write_addr2,
    output reg  [31:0] ctrl_reg_write_data1,
    output reg  [31:0] ctrl_reg_write_data2,

    output reg  [1:0]ctrl_csr_write_en, //CSR瀵勫瓨鍣ㄥ啓浣胯�?
    output reg  [13:0] ctrl_csr_addr1, //CSR瀵勫瓨鍣ㄥ湴�??
    output reg  [13:0] ctrl_csr_addr2,
    output reg  [31:0] ctrl_csr_write_data1,
    output reg  [31:0] ctrl_csr_write_data2,
    output reg  [1:0]  ctrl_is_llw_scw, //鏄惁鏄疞LW/SCW鎸囦�?
    output reg         llbit_write,
    output reg  [1:0]  commit_valid_out, //鎸囦护鏄惁鏈夋�?
    output reg  [5:0]  is_exception1_o,
    output reg  [5:0]  is_exception2_o,
    output reg  [6:0]  pc_exception_cause1_o, //寮傚父鍘熷洜
    output reg  [6:0]  pc_exception_cause2_o,
    output reg  [6:0]  instbuffer_exception_cause1_o,
    output reg  [6:0]  instbuffer_exception_cause2_o,
    output reg  [6:0]  decoder_exception_cause1_o,
    output reg  [6:0]  decoder_exception_cause2_o,
    output reg  [6:0]  dispatch_exception_cause1_o,
    output reg  [6:0]  dispatch_exception_cause2_o,
    output reg  [6:0]  execute_exception_cause1_o,
    output reg  [6:0]  execute_exception_cause2_o,
    output reg  [6:0]  commit_exception_cause1_o,
    output reg  [6:0]  commit_exception_cause2_o,

    output reg  [31:0] commit_pc_out1,
    output reg  [31:0] commit_pc_out2,
    output reg  [63:0] commit_count_64_o1,
    output reg  [63:0] commit_count_64_o2,
    output reg  [31:0] commit_refetch_target_pc, //閲嶅彇鎸囦护鐨勭洰鏍囧湴�??
    output reg  [31:0] commit_addr_out1, //鍐呭瓨鍦板潃
    output reg  [31:0] commit_addr_out2,
    output reg  [1:0] commit_idle_out, //鏄惁鏄┖闂叉寚浠?
    output reg  [1:0] commit_ertn_out, //鏄惁鏄紓甯歌繑鍥炴寚�??
    output reg  [1:0] commit_is_privilege_out, //鐗规潈鎸囦护
    output reg  [1:0] commit_icacop_en_out,

    //tlb
    input wire [18:0] mem_invtlb_vpn,
    input wire [9:0]  mem_invtlb_asid,
    input wire mem_invtlb,
    input wire mem_tlbrd,
    input wire mem_tlbfill,
    input wire mem_tlbwr,
    input wire mem_tlbsrch,
    input wire [4:0]mem_invtlb_op,
    input wire mem_tlb_found,
    input wire [4:0]mem_tlb_index,
    output reg [18:0] wb_invtlb_vpn,
    output reg [9:0]  wb_invtlb_asid,
    output reg wb_invtlb,
    output reg wb_tlbrd,
    output reg wb_tlbfill,
    output reg wb_tlbwr,
    output reg wb_tlbsrch,
    output reg [4:0]wb_invtlb_op,
    output reg wb_tlb_found,
    output reg [4:0] wb_tlb_index,

//debug
    input wire [31:0] mem_inst1,
    input wire [31:0] mem_inst2,
    
    output reg [31:0] wb_inst1,
    output reg [31:0] wb_inst2


    // difftest
    `ifdef DIFF
    ,
    input wire diff_flush,
    input wire [`DIFF_WIDTH-1:0] wb_diff0_i,
    input wire [`DIFF_WIDTH-1:0] wb_diff1_i,

    output reg [`DIFF_WIDTH-1:0] wb_diff0_o,
    output reg [`DIFF_WIDTH-1:0] wb_diff1_o

    `endif
);


    always @(posedge clk) begin
        if(rst || pause_mem || flush) begin
            ctrl_reg_write_en    <= 2'b0;
            ctrl_reg_write_addr1 <= 5'b0;
            ctrl_reg_write_addr2 <= 5'b0; 
            ctrl_reg_write_data1 <= 32'b0;
            ctrl_reg_write_data2 <= 32'b0;
            ctrl_csr_write_en    <= 2'b0;
            ctrl_csr_addr1 <= 14'b0;
            ctrl_csr_addr2 <= 14'b0;
            ctrl_csr_write_data1 <= 32'b0;
            ctrl_csr_write_data2 <= 32'b0;
            ctrl_is_llw_scw     <= 2'b0;
            llbit_write         <= 1'b0;
            commit_valid_out    <= 2'b0;
            is_exception1_o <= 6'b0;
            is_exception2_o <= 6'b0;
            pc_exception_cause1_o <= 7'b0;
            pc_exception_cause2_o <= 7'b0;
            instbuffer_exception_cause1_o <= 7'b0;
            instbuffer_exception_cause2_o <= 7'b0;
            decoder_exception_cause1_o <= 7'b0;
            decoder_exception_cause2_o <= 7'b0;
            dispatch_exception_cause1_o <= 7'b0;
            dispatch_exception_cause2_o <= 7'b0;
            execute_exception_cause1_o <= 7'b0;
            execute_exception_cause2_o <= 7'b0;
            commit_exception_cause1_o <= 7'b0;
            commit_exception_cause2_o <= 7'b0;
            commit_pc_out1 <= 32'b0;
            commit_pc_out2 <= 32'b0;
            commit_count_64_o1 <= 64'b0;
            commit_count_64_o2 <= 64'b0;
            commit_refetch_target_pc <= 32'b0;
            commit_addr_out1 <= 32'b0;
            commit_addr_out2 <= 32'b0;
            commit_idle_out  <= 2'b0;
            commit_ertn_out  <= 2'b0;
            commit_is_privilege_out <= 2'b0;
            commit_icacop_en_out <= 2'b0;
            wb_invtlb_asid <= 10'b0;
            wb_invtlb_vpn  <= 19'b0;
            wb_invtlb <= 1'b0;
            wb_tlbrd <= 1'b0;
            wb_tlbfill <= 1'b0;
            wb_tlbwr  <= 1'b0;
            wb_tlbsrch <= 1'b0;
            wb_invtlb_op <= 5'b0;
            wb_tlb_found <= 1'b0;
            wb_tlb_index <= 5'b0;
        end 
        else begin
            wb_inst1 <= mem_inst1;
            wb_inst2 <= mem_inst2;
            ctrl_reg_write_en[0] <= wb_reg_write_en[0];
            ctrl_reg_write_en[1] <= wb_reg_write_en[1];
            ctrl_reg_write_addr1 <= wb_reg_write_addr1;
            ctrl_reg_write_addr2 <= wb_reg_write_addr2; 
            ctrl_reg_write_data1 <= wb_reg_write_data1;
            ctrl_reg_write_data2 <= wb_reg_write_data2;
            ctrl_csr_write_en[0] <= wb_csr_write_en[0];
            ctrl_csr_write_en[1] <= wb_csr_write_en[1]; 
            ctrl_csr_addr1 <= wb_csr_addr1;
            ctrl_csr_addr2 <= wb_csr_addr2;
            ctrl_csr_write_data1 <= wb_csr_write_data1;
            ctrl_csr_write_data2 <= wb_csr_write_data2;
            ctrl_is_llw_scw[0] <= wb_is_llw_scw[0];
            ctrl_is_llw_scw[1] <= wb_is_llw_scw[1];
            llbit_write        <= wb_is_llw && (!uncache_i);
            commit_valid_out[0] <= commit_valid[0];
            commit_valid_out[1] <= commit_valid[1];
            is_exception1_o <= is_exception1_i;
            is_exception2_o <= is_exception2_i;
            pc_exception_cause1_o <= pc_exception_cause1_i;
            pc_exception_cause2_o <= pc_exception_cause2_i;
            instbuffer_exception_cause1_o <= instbuffer_exception_cause1_i;
            instbuffer_exception_cause2_o <= instbuffer_exception_cause2_i;
            decoder_exception_cause1_o <= decoder_exception_cause1_i;
            decoder_exception_cause2_o <= decoder_exception_cause2_i;
            dispatch_exception_cause1_o <= dispatch_exception_cause1_i;
            dispatch_exception_cause2_o <= dispatch_exception_cause2_i;
            execute_exception_cause1_o <= execute_exception_cause1_i;
            execute_exception_cause2_o <= execute_exception_cause2_i;
            commit_exception_cause1_o <= commit_exception_cause1_i;
            commit_exception_cause2_o <= commit_exception_cause2_i;
            commit_pc_out1 <= commit_pc1;
            commit_pc_out2 <= commit_pc2;
            commit_count_64_o1 <= commit_count_64_i1;
            commit_count_64_o2 <= commit_count_64_i2;
            commit_refetch_target_pc <= (commit_pc1 | commit_pc2) + 32'h4;
            commit_addr_out1 <= commit_addr1;
            commit_addr_out2 <= commit_addr2;
            commit_idle_out[0] <= commit_idle[0];
            commit_idle_out[1] <= commit_idle[1];
            commit_ertn_out[0] <= commit_ertn[0];
            commit_ertn_out[1] <= commit_ertn[1];
            commit_is_privilege_out[0] <= commit_is_privilege[0];
            commit_is_privilege_out[1] <= commit_is_privilege[1];
            commit_icacop_en_out   <= commit_icacop_en;
            wb_invtlb_asid <= mem_invtlb_asid;
            wb_invtlb_vpn  <= mem_invtlb_vpn;
            wb_invtlb <= mem_invtlb;
            wb_tlbrd <= mem_tlbrd;
            wb_tlbfill <= mem_tlbfill;
            wb_tlbwr  <= mem_tlbwr;
            wb_tlbsrch <= mem_tlbsrch;
            wb_invtlb_op <= mem_invtlb_op;
            wb_tlb_found <= mem_tlb_found;
            wb_tlb_index <= mem_tlb_index;
        end
    end

    always @(*) begin
        wb_pf_reg_write_en[0] = ctrl_reg_write_en[0];
        wb_pf_reg_write_en[1] = ctrl_reg_write_en[1];
        wb_pf_reg_write_addr1 = ctrl_reg_write_addr1;
        wb_pf_reg_write_addr2 = ctrl_reg_write_addr2;
        wb_pf_reg_write_data1 = ctrl_reg_write_data1;
        wb_pf_reg_write_data2 = ctrl_reg_write_data2;
        end

    `ifdef DIFF
    // diff
    always @(posedge clk) begin
        if (rst || pause_mem || diff_flush) begin
            wb_diff0_o <= 0;
            wb_diff1_o <= 0;
        end else begin
            wb_diff0_o <= wb_diff0_i;
            wb_diff1_o <= wb_diff1_i;
        end 
    end
    `endif

endmodule