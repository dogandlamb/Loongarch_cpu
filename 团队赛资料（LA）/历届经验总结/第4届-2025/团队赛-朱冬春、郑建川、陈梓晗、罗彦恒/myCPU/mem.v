`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"

module mem
(
    input  wire clk,
    input  wire rst,

    // 鎵ц闃舵鐨勪俊鍙?
    input  wire [31:0] pc1 ,
    input  wire [31:0] pc2 ,
    input  wire [63:0] count_64_i1,
    input  wire [63:0] count_64_i2,
    input  wire [31:0] inst1,
    input  wire [31:0] inst2,

    input  wire dcache_is_exception_i,
    input  wire [6:0] dcache_exception_cause_i,

    input  wire [4:0] is_exception1_i,   //寮傚父鏍囧織
    input  wire [4:0] is_exception2_i,   
    input  wire [6:0] pc_exception_cause1_i, //寮傚父鍘熷洜
    input  wire [6:0] pc_exception_cause2_i,
    input  wire [6:0] instbuffer_exception_cause1_i,
    input  wire [6:0] instbuffer_exception_cause2_i,
    input  wire [6:0] decoder_exception_cause1_i,
    input  wire [6:0] decoder_exception_cause2_i,
    input  wire [6:0] dispatch_exception_cause1_i,
    input  wire [6:0] dispatch_exception_cause2_i,
    input  wire [6:0] execute_exception_cause1_i,
    input  wire [6:0] execute_exception_cause2_i,

    input  wire [1:0]is_privilege, //鐗规潈鎸囦护鏍囧織
    input  wire [1:0]is_ertn, //鏄惁鏄紓甯歌繑鍥炴寚浠?
    input  wire [1:0]is_idle, //鏄惁鏄┖闂叉寚浠?
    input  wire [1:0]valid, //鎸囦护鏄惁鏈夋晥
    input  wire [1:0]reg_write_en,  //瀵勫瓨鍣ㄥ啓浣胯兘淇″彿
    input  wire [4:0]reg_write_addr1,
    input  wire [4:0]reg_write_addr2,
    input  wire [31:0] reg_write_data1, //瀵勫瓨鍣ㄥ啓鏁版嵁
    input  wire [31:0] reg_write_data2,
    input  wire [7:0]aluop1,
    input  wire [7:0]aluop2,
    input  wire [31:0]mem_addr1, //鍐呭瓨鍦板潃
    input  wire [31:0]mem_addr2,
    input  wire [31:0]mem_write_data1, //鍐呭瓨鍐欐暟鎹?
    input  wire [31:0]mem_write_data2,
    input  wire [1:0]csr_write_en, //CSR瀵勫瓨鍣ㄥ啓浣胯兘
    input  wire [13:0] csr_addr1, //CSR瀵勫瓨鍣ㄥ湴鍧?
    input  wire [13:0] csr_addr2,
    input  wire [31:0] csr_write_data_mem1,
    input  wire [31:0] csr_write_data_mem2, 
    input  wire [1:0]is_llw_scw, //鏄惁鏄疞LW/SCW鎸囦护
    input  wire is_llw,
    input  wire [1:0] icacop_en,
    input  wire [31:0] st_write_data1,
    input  wire [31:0] st_write_data2,

    //dcache鐨勪俊鍙?
    input  wire [31:0] dcache_read_data, 
    input  wire data_ok,                    
    input  wire sc_cancel_i,
    input  wire [31:0] dcache_P_addr,       // 杩欎釜瀛樼枒锛燂紵

    input  wire [31:0] paddr,       // to difftest 
    
    // 杈撳嚭缁檇ispatch鐨勪俊鍙?
    output wire  [1:0]  mem_pf_reg_write_en, 
    output wire  [4:0]  mem_pf_reg_write_addr1,
    output wire  [4:0]  mem_pf_reg_write_addr2,


    // 杈撳嚭缁檆trl鐨勪俊鍙?
    output wire   pause_mem, //閫氱煡鏆傚仠鍐呭瓨璁块棶淇″彿

    //杈撳嚭缁檞b鐨勪俊鍙?
    output wire  [1:0]  wb_reg_write_en, 
    output wire  [4:0]  wb_reg_write_addr1,
    output wire  [4:0]  wb_reg_write_addr2,
    output reg   [31:0] wb_reg_write_data1,
    output reg   [31:0] wb_reg_write_data2,

    output wire  [1:0]  wb_csr_write_en, //CSR瀵勫瓨鍣ㄥ啓浣胯兘
    output wire  [13:0] wb_csr_addr1, //CSR瀵勫瓨鍣ㄥ湴鍧?
    output wire  [13:0] wb_csr_addr2,
    output wire  [31:0] wb_csr_write_data1,
    output wire  [31:0] wb_csr_write_data2,
    output wire  [1:0]  wb_is_llw_scw, //鏄惁鏄疞LW/SCW鎸囦护
    output wire  wb_is_llw,

    //commit_ctrl鐨勪俊鍙?
    output wire  [1:0] commit_valid, //鎸囦护鏄惁鏈夋晥
    output wire  [5:0]  is_exception1_o,
    output wire  [5:0]  is_exception2_o, 
    output wire  [6:0]  pc_exception_cause1_o, 
    output wire  [6:0]  pc_exception_cause2_o,
    output wire  [6:0]  instbuffer_exception_cause1_o,
    output wire  [6:0]  instbuffer_exception_cause2_o,
    output wire  [6:0]  decoder_exception_cause1_o,
    output wire  [6:0]  decoder_exception_cause2_o,
    output wire  [6:0]  dispatch_exception_cause1_o,
    output wire  [6:0]  dispatch_exception_cause2_o,
    output wire  [6:0]  execute_exception_cause1_o,
    output wire  [6:0]  execute_exception_cause2_o,
    output wire  [6:0]  commit_exception_cause1_o,
    output wire  [6:0]  commit_exception_cause2_o,

    output wire  [31:0] commit_pc1,
    output wire  [31:0] commit_pc2,
    output wire  [63:0] commit_count_64_o1,
    output wire  [63:0] commit_count_64_o2,
    output wire  [31:0] commit_addr1, //鍐呭瓨鍦板潃
    output wire  [31:0] commit_addr2,
    output wire  [1:0] commit_idle, //鏄惁鏄┖闂叉寚浠?
    output wire  [1:0] commit_ertn, //鏄惁鏄紓甯歌繑鍥炴寚浠?
    output wire  [1:0] commit_is_privilege, //鐗规潈鎸囦护
    output wire  [1:0] commit_icacop_en,

    //tlb
    input wire [18:0] ex_invtlb_vpn,
    input wire [9:0]  ex_invtlb_asid,
    input wire ex_invtlb,
    input wire ex_tlbrd,
    input wire ex_tlbfill,
    input wire ex_tlbwr,
    input wire ex_tlbsrch,
    input wire [4:0]ex_invtlb_op,
    input wire data_tlb_found,
    input wire [4:0]data_tlb_index,
    output wire [18:0] mem_invtlb_vpn,
    output wire [9:0]  mem_invtlb_asid,
    output wire mem_invtlb,
    output wire mem_tlbrd,
    output wire mem_tlbfill,
    output wire mem_tlbwr,
    output wire mem_tlbsrch,
    output wire [4:0] mem_invtlb_op,
    output wire mem_tlb_found,
    output wire [4:0] mem_tlb_index


    // difftest
   `ifdef DIFF
    ,
    output wire [`DIFF_WIDTH-1:0] commit_diff0,
    output wire [`DIFF_WIDTH-1:0] commit_diff1

    `endif 

);

    assign mem_pf_reg_write_en[0] = reg_write_en[0];
    assign mem_pf_reg_write_en[1] = reg_write_en[1];
    assign mem_pf_reg_write_addr1 = reg_write_addr1;
    assign mem_pf_reg_write_addr2 = reg_write_addr2;

    assign wb_reg_write_en[0] = reg_write_en[0];
    assign wb_reg_write_en[1] = reg_write_en[1];
    assign wb_reg_write_addr1 = reg_write_addr1;
    assign wb_reg_write_addr2 = reg_write_addr2;
    assign wb_is_llw_scw[0] = is_llw_scw[0];
    assign wb_is_llw_scw[1] = is_llw_scw[1];
    assign wb_is_llw = is_llw;
    assign wb_csr_write_en[0] = csr_write_en[0];
    assign wb_csr_write_en[1] = csr_write_en[1];
    assign wb_csr_addr1 = csr_addr1;
    assign wb_csr_addr2 = csr_addr2;
    assign wb_csr_write_data1 = csr_write_data_mem1;
    assign wb_csr_write_data2 = csr_write_data_mem2;


    assign is_exception1_o = {is_exception1_i,dcache_is_exception_i};
    assign is_exception2_o = {is_exception2_i,dcache_is_exception_i};
    assign pc_exception_cause1_o = pc_exception_cause1_i;
    assign pc_exception_cause2_o = pc_exception_cause2_i;
    assign instbuffer_exception_cause1_o = instbuffer_exception_cause1_i;
    assign instbuffer_exception_cause2_o = instbuffer_exception_cause2_i;
    assign decoder_exception_cause1_o = decoder_exception_cause1_i;
    assign decoder_exception_cause2_o = decoder_exception_cause2_i;
    assign dispatch_exception_cause1_o = dispatch_exception_cause1_i;
    assign dispatch_exception_cause2_o = dispatch_exception_cause2_i;
    assign execute_exception_cause1_o = execute_exception_cause1_i;
    assign execute_exception_cause2_o = execute_exception_cause2_i;
    assign commit_exception_cause1_o = dcache_exception_cause_i;
    assign commit_exception_cause2_o = dcache_exception_cause_i;


    assign commit_pc1 = pc1;
    assign commit_pc2 = pc2;
    assign commit_count_64_o1 = count_64_i1;
    assign commit_count_64_o2 = count_64_i2;
    assign commit_addr1 = mem_addr1;
    assign commit_addr2 = mem_addr2;
    assign commit_is_privilege[0] = is_privilege[0];
    assign commit_is_privilege[1] = is_privilege[1];
    assign commit_valid[0] = valid[0];
    assign commit_valid[1] = valid[1];
    assign commit_ertn[0] = is_ertn[0];
    assign commit_ertn[1] = is_ertn[1];
    assign commit_idle[0] = is_idle[0];
    assign commit_idle[1] = is_idle[1];

    assign  mem_invtlb_vpn = ex_invtlb_vpn;
    assign  mem_invtlb_asid = ex_invtlb_asid;
    assign  mem_invtlb = ex_invtlb;
    assign  mem_tlbrd = ex_tlbrd;
    assign  mem_tlbfill = ex_tlbfill;
    assign  mem_tlbwr = ex_tlbwr;
    assign  mem_tlbsrch = ex_tlbsrch;
    assign  mem_invtlb_op = ex_invtlb_op;
    assign  mem_tlb_found = data_tlb_found;
    assign  mem_tlb_index = data_tlb_index;

    assign commit_icacop_en = icacop_en;

    reg [1:0] pause_uncache;
    wire [31:0] mem_addr_reg [1:0];
    
    assign mem_addr_reg[0] = mem_addr1;
    assign mem_addr_reg[1] = mem_addr2;

    always @(*) begin
        case(aluop1)
            `ALU_LDB:begin
                if(data_ok) begin
                    pause_uncache[0] = 1'b0;
                    case(mem_addr_reg[0][1:0])
                        2'b00: begin
                            wb_reg_write_data1 = {{24{dcache_read_data[7]}},dcache_read_data[7:0]};
                        end
                        2'b01: begin
                            wb_reg_write_data1 = {{24{dcache_read_data[15]}},dcache_read_data[15:8]};
                        end
                        2'b10: begin
                            wb_reg_write_data1 = {{24{dcache_read_data[23]}},dcache_read_data[23:16]};
                        end
                        2'b11: begin
                            wb_reg_write_data1 = {{24{dcache_read_data[31]}},dcache_read_data[31:24]};
                        end
                        default: begin
                            wb_reg_write_data1 = 32'b0;
                        end
                    endcase
                end
                else begin
                    pause_uncache[0] = 1'b1;
                    wb_reg_write_data1 = 32'b0;
                end
            end
            `ALU_LDBU:begin
                if(data_ok) begin
                    pause_uncache[0] = 1'b0;
                    case(mem_addr_reg[0][1:0])
                        2'b00: begin
                            wb_reg_write_data1 = {24'b0,dcache_read_data[7:0]};
                        end
                        2'b01: begin
                            wb_reg_write_data1 = {24'b0,dcache_read_data[15:8]};
                        end
                        2'b10: begin
                            wb_reg_write_data1 = {24'b0,dcache_read_data[23:16]};
                        end
                        2'b11: begin
                            wb_reg_write_data1 = {24'b0,dcache_read_data[31:24]};
                        end
                        default: begin
                            wb_reg_write_data1 = 32'b0;
                        end
                    endcase
                end
                else begin
                    pause_uncache[0] = 1'b1;
                    wb_reg_write_data1 = 32'b0;
                end
            end
            `ALU_LDH:begin
                if(data_ok) begin
                    pause_uncache[0] = 1'b0;
                    case(mem_addr_reg[0][1:0])
                        2'b00: begin
                            wb_reg_write_data1 = {{16{dcache_read_data[15]}},dcache_read_data[15:0]};
                        end
                        2'b10: begin
                            wb_reg_write_data1 = {{16{dcache_read_data[31]}},dcache_read_data[31:16]};
                        end
                        default: begin
                            wb_reg_write_data1 = 32'b0;
                        end
                    endcase
                end
                else begin
                    pause_uncache[0] = 1'b1;
                    wb_reg_write_data1 = 32'b0;
                end
            end
            `ALU_LDHU:begin
                if(data_ok) begin
                    pause_uncache[0] = 1'b0;
                    case(mem_addr_reg[0][1:0])
                        2'b00: begin
                            wb_reg_write_data1 = {16'b0,dcache_read_data[15:0]};
                        end
                        2'b10: begin
                            wb_reg_write_data1 = {16'b0,dcache_read_data[31:16]};
                        end
                        default: begin
                            wb_reg_write_data1 = 32'b0;
                        end
                    endcase
                end
                else begin
                    pause_uncache[0] = 1'b1;
                    wb_reg_write_data1 = 32'b0;
                end
            end
            `ALU_LDW:begin
                if(data_ok) begin
                    pause_uncache[0] = 1'b0;
                    wb_reg_write_data1 = dcache_read_data;
                end
                else begin
                    pause_uncache[0] = 1'b1;
                    wb_reg_write_data1 = 32'b0;
                end
            end
            `ALU_LLW:begin
                if(data_ok) begin
                    pause_uncache[0] = 1'b0;
                    wb_reg_write_data1 = dcache_read_data;
                end
                else begin
                    pause_uncache[0] = 1'b1;
                    wb_reg_write_data1 = 32'b0;
                end
            end
            default: begin
                pause_uncache[0] = 1'b0;
                wb_reg_write_data1 = reg_write_data1 & {32{!sc_cancel_i}};
            end
        endcase
    end


    always @(*) begin
        case(aluop2)
            `ALU_LDB:begin
                if(data_ok) begin
                    pause_uncache[1] = 1'b0;
                    case(mem_addr_reg[1][1:0])
                        2'b00: begin
                            wb_reg_write_data2 = {{24{dcache_read_data[7]}},dcache_read_data[7:0]};
                        end
                        2'b01: begin
                            wb_reg_write_data2 = {{24{dcache_read_data[15]}},dcache_read_data[15:8]};
                        end
                        2'b10: begin
                            wb_reg_write_data2 = {{24{dcache_read_data[23]}},dcache_read_data[23:16]};
                        end
                        2'b11: begin
                            wb_reg_write_data2 = {{24{dcache_read_data[31]}},dcache_read_data[31:24]};
                        end
                        default: begin
                            wb_reg_write_data2 = 32'b0;
                        end
                    endcase
                end
                else begin
                    pause_uncache[1] = 1'b1;
                    wb_reg_write_data2 = 32'b0;
                end
            end
            `ALU_LDBU:begin
                if(data_ok) begin
                    pause_uncache[1] = 1'b0;
                    case(mem_addr_reg[1][1:0])
                        2'b00: begin
                            wb_reg_write_data2 = {24'b0,dcache_read_data[7:0]};
                        end
                        2'b01: begin
                            wb_reg_write_data2 = {24'b0,dcache_read_data[15:8]};
                        end
                        2'b10: begin
                            wb_reg_write_data2 = {24'b0,dcache_read_data[23:16]};
                        end
                        2'b11: begin
                            wb_reg_write_data2 = {24'b0,dcache_read_data[31:24]};
                        end
                        default: begin
                            wb_reg_write_data2 = 32'b0;
                        end
                    endcase
                end
                else begin
                    pause_uncache[1] = 1'b1;
                    wb_reg_write_data2 = 32'b0;
                end
            end
            `ALU_LDH:begin
                if(data_ok) begin
                    pause_uncache[1] = 1'b0;
                    case(mem_addr_reg[1][1:0])
                        2'b00: begin
                            wb_reg_write_data2 = {{16{dcache_read_data[15]}},dcache_read_data[15:0]};
                        end
                        2'b10: begin
                            wb_reg_write_data2 = {{16{dcache_read_data[31]}},dcache_read_data[31:16]};
                        end
                        default: begin
                            wb_reg_write_data2= 32'b0;
                        end
                    endcase
                end
                else begin
                    pause_uncache[1] = 1'b1;
                    wb_reg_write_data2 = 32'b0;
                end
            end
            `ALU_LDHU:begin
                if(data_ok) begin
                    pause_uncache[1] = 1'b0;
                    case(mem_addr_reg[1][1:0])
                        2'b00: begin
                            wb_reg_write_data2 = {16'b0,dcache_read_data[15:0]};
                        end
                        2'b10: begin
                            wb_reg_write_data2 = {16'b0,dcache_read_data[31:16]};
                        end
                        default: begin
                            wb_reg_write_data2 = 32'b0;
                        end
                    endcase
                end
                else begin
                    pause_uncache[1] = 1'b1;
                    wb_reg_write_data2 = 32'b0;
                end
            end
            `ALU_LDW:begin
                if(data_ok) begin
                    pause_uncache[1] = 1'b0;
                    wb_reg_write_data2 = dcache_read_data;
                end
                else begin
                    pause_uncache[1] = 1'b1;
                    wb_reg_write_data2 = 32'b0;
                end
            end
            `ALU_LLW:begin
                if(data_ok) begin
                    pause_uncache[1] = 1'b0;
                    wb_reg_write_data2 = dcache_read_data;
                end
                else begin
                    pause_uncache[1] = 1'b1;
                    wb_reg_write_data2 = 32'b0;
                end
            end
            default: begin
                pause_uncache[1] = 1'b0;
                wb_reg_write_data2 = reg_write_data2;
            end
        endcase
    end

    assign pause_mem = (pause_uncache[0] || pause_uncache[1]) && (is_exception1_o == 0 && is_exception2_o == 0);


    // difftest
    `ifdef DIFF
        assign commit_diff0 = { pc1,
                                inst1,
                                4'b0,
                                5'b0,
                                32'b0,

                                valid[0],
                                (aluop1 == `ALU_RDCNTID || aluop1 == `ALU_RDCNTVLW || aluop1 == `ALU_RDCNTVHW),

                                1'b0,
                                32'b0,

                                1'b0,
                                1'b0,
                                6'b0,

                                {4'b0, (is_llw_scw[0] && (aluop1 == `ALU_SCW)), aluop1 == `ALU_STW,
                                aluop1 == `ALU_STH, aluop1 == `ALU_STB},

                                paddr,          // 物理地址，不知道填什么
                                mem_addr1,
                                st_write_data1 ,      // 这个是写数据（暂时没有）
                                
                                {2'b0, aluop1 == `ALU_LLW, aluop1 == `ALU_LDW, aluop1 == `ALU_LDHU,
                                aluop1 == `ALU_LDH, aluop1 == `ALU_LDBU, aluop1 == `ALU_LDB},

                                paddr,            // 物理地址，不知道填什么
                                mem_addr1,

                                (aluop1 == `ALU_TLBFILL)};

        assign commit_diff1 = { pc2,
                                inst2,
                                4'b0,
                                5'b0,
                                32'b0,

                                valid[1],
                                (aluop2 == `ALU_RDCNTID || aluop2 == `ALU_RDCNTVLW || aluop2 == `ALU_RDCNTVHW),

                                1'b0,
                                32'b0,

                                1'b0,
                                1'b0,
                                6'b0,

                                {4'b0, (is_llw_scw[1] && (aluop2 == `ALU_SCW)), aluop2 == `ALU_STW,
                                aluop2 == `ALU_STH, aluop2 == `ALU_STB},

                                paddr,          // 物理地址，不知道填什么
                                mem_addr2,
                                st_write_data2 ,      // 这个是写数据（暂时没有）
                                
                                {2'b0, aluop2 == `ALU_LLW, aluop2 == `ALU_LDW, aluop2 == `ALU_LDHU,
                                aluop2 == `ALU_LDH, aluop2 == `ALU_LDBU, aluop2 == `ALU_LDB},

                                paddr,            // 物理地址，不知道填什么
                                mem_addr2,

                                (aluop2 == `ALU_TLBFILL)};
    `endif 
endmodule