/*------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Copyright (c) 2016, Loongson Technology Corporation Limited.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this 
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

3. Neither the name of Loongson Technology Corporation Limited nor the names of 
its contributors may be used to endorse or promote products derived from this 
software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL LOONGSON TECHNOLOGY CORPORATION LIMITED BE LIABLE
TO ANY PARTY FOR DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/
// 综合验证用 testbench（覆盖 exp11~exp16 功能测试与 AXI SoC 仿真）
// 可选：仿真前 `define TB_DUMP_VCD 以生成 dump.vcd
`timescale 1ns / 1ps

`define TRACE_REF_FILE "E:/Loongarch_cpu/output/vivado_cpu_origin/gettrace/golden_trace.txt"
`define CONFREG_NUM_REG      soc_lite.u_confreg.num_data
`define CONFREG_OPEN_TRACE   1'b1
`define CONFREG_NUM_MONITOR  1'b0
`define CONFREG_UART_DISPLAY soc_lite.u_confreg.write_uart_valid
`define CONFREG_UART_DATA    soc_lite.u_confreg.write_uart_data
`define END_PC 32'h1c000100

// exp13~16 测试集较大，可适当调大；若仍超时请再增大
`ifndef TB_TIMEOUT_CYCLES
`define TB_TIMEOUT_CYCLES 32'd8000000
`endif

module tb_top( );
reg resetn;
reg clk;
reg [31:0] cycle_cnt;
reg [31:0] commit_cnt;

//goio
wire [15:0] led;
wire [1 :0] led_rg0;
wire [1 :0] led_rg1;
wire [7 :0] num_csn;
wire [6 :0] num_a_g;
wire [7 :0] switch;
wire [3 :0] btn_key_col;
wire [3 :0] btn_key_row;
wire [1 :0] btn_step;
assign switch      = 8'hff;
assign btn_key_row = 4'd0;
assign btn_step    = 2'd3;

initial
begin
`ifdef TB_DUMP_VCD
    $dumpfile("dump.vcd");
    $dumpvars;
`endif
    clk = 1'b0;
    resetn = 1'b0;
    #2000;
    resetn = 1'b1;
end
always #5 clk=~clk;
soc_lite_top #(.SIMULATION(1'b1)) soc_lite
(
       .resetn      (resetn     ), 
       .clk         (clk        ),
    
        //------gpio-------
        .num_csn    (num_csn    ),
        .num_a_g    (num_a_g    ),
        .led        (led        ),
        .led_rg0    (led_rg0    ),
        .led_rg1    (led_rg1    ),
        .switch     (switch     ),
        .btn_key_col(btn_key_col),
        .btn_key_row(btn_key_row),
        .btn_step   (btn_step   )
    );   

//soc lite signals
//"soc_clk" means clk in cpu
//"wb" means write-back stage in pipeline
//"rf" means regfiles in cpu
//"w" in "wen/wnum/wdata" means writing
wire soc_clk;
wire [31:0] debug_wb_pc;
wire [3 :0] debug_wb_rf_we;
wire [4 :0] debug_wb_rf_wnum;
wire [31:0] debug_wb_rf_wdata;
assign soc_clk           = soc_lite.cpu_clk;
assign debug_wb_pc       = soc_lite.debug_wb_pc;
assign debug_wb_rf_we    = soc_lite.debug_wb_rf_we;
assign debug_wb_rf_wnum  = soc_lite.debug_wb_rf_wnum;
assign debug_wb_rf_wdata = soc_lite.debug_wb_rf_wdata;

always @(posedge soc_clk)
begin
    if (!resetn)
    begin
        cycle_cnt  <= 32'd0;
        commit_cnt <= 32'd0;
    end
    else
    begin
        cycle_cnt <= cycle_cnt + 1'b1;
        if(|debug_wb_rf_we && debug_wb_rf_wnum!=5'd0)
        begin
            commit_cnt <= commit_cnt + 1'b1;
        end
    end
end

always @(posedge soc_clk)
begin
    if (1'b0 && resetn && |debug_wb_rf_we && debug_wb_rf_wnum!=5'd0 && cycle_cnt < 32'd400)
    begin
        $display("WB c=%0d pc=0x%8h wnum=%0d wdata=0x%8h",
                 cycle_cnt, debug_wb_pc, debug_wb_rf_wnum, debug_wb_rf_wdata);
    end
end

always @(posedge soc_clk)
begin
    if (1'b1 && resetn && cycle_cnt < 32'd40)
    begin
        $display("EARLY c=%0d pc=0x%8h next=0x%8h pc_id=0x%8h pc_exe=0x%8h if_inst=0x%8h id_inst=0x%8h | id_b=%0d id_csrwr=%0d id_known=%0d rs1=%0d id1=0x%8h csr_w=0x%8h fw_wb=%0d wb_rd=%0d wb_data=0x%8h | br_taken=%0d br_op=0x%0h br_imm=0x%8h src1=0x%8h src2=0x%8h | csr_red=%0d csr_npc=0x%8h wb_ex=%0d ine=%0d int=%0d | v=%0d/%0d/%0d/%0d/%0d",
                 cycle_cnt,
                 soc_lite.u_cpu.pc,
                 soc_lite.u_cpu.nextpc,
                 soc_lite.u_cpu.pc_2ID,
                 soc_lite.u_cpu.pc_exe,
                 soc_lite.u_cpu.inst_rdata_2IF,
                 soc_lite.u_cpu.inst_2ID,
                 soc_lite.u_cpu.u_IDport.inst_b,
                 soc_lite.u_cpu.u_IDport.inst_csrwr,
                 soc_lite.u_cpu.u_IDport.inst_known,
                 soc_lite.u_cpu.rf_raddr1,
                 soc_lite.u_cpu.ID_src1_rdata,
                 soc_lite.u_cpu.csr_wvalue_fromID,
                 soc_lite.u_cpu.FD_WB_2rs1_sig,
                 soc_lite.u_cpu.wb_waddr,
                 soc_lite.u_cpu.wb_wdata,
                 soc_lite.u_cpu.br_taken_q,
                 soc_lite.u_cpu.br_op_2EXE,
                 soc_lite.u_cpu.br_imm_2EXE,
                 soc_lite.u_cpu.alu_src1_2EXE,
                 soc_lite.u_cpu.alu_src2_2EXE,
                 soc_lite.u_cpu.csr_redirect,
                 soc_lite.u_cpu.csr_next_pc,
                 soc_lite.u_cpu.wb_ex_2csr,
                 soc_lite.u_cpu.wb_ine_valid_2csr,
                 soc_lite.u_cpu.wb_int_valid_2csr,
                 soc_lite.u_cpu.IF_valid,
                 soc_lite.u_cpu.ID_valid,
                 soc_lite.u_cpu.EXE_valid,
                 soc_lite.u_cpu.MEM_valid,
                 soc_lite.u_cpu.WB_valid);
    end
end

// open the trace file;
integer trace_ref;
initial begin
    trace_ref = $fopen(`TRACE_REF_FILE, "r");
end

//get reference result in falling edge
reg        trace_cmp_flag;
reg        debug_end;

reg [31:0] ref_wb_pc;
reg [4 :0] ref_wb_rf_wnum;
reg [31:0] ref_wb_rf_wdata;

integer a;
always @(posedge soc_clk)
begin 
    #1;
    if(|debug_wb_rf_we && debug_wb_rf_wnum!=5'd0 && !debug_end && `CONFREG_OPEN_TRACE)
    begin
        trace_cmp_flag=1'b0;
        while (!trace_cmp_flag && !($feof(trace_ref)))
        begin
            a = $fscanf(trace_ref, "%h %h %h %h", trace_cmp_flag,
                    ref_wb_pc, ref_wb_rf_wnum, ref_wb_rf_wdata);
        end
    end
end

//wdata[i*8+7 : i*8] is valid, only wehile wen[i] is valid
wire [31:0] debug_wb_rf_wdata_v;
wire [31:0] ref_wb_rf_wdata_v;
assign debug_wb_rf_wdata_v[31:24] = debug_wb_rf_wdata[31:24] & {8{debug_wb_rf_we[3]}};
assign debug_wb_rf_wdata_v[23:16] = debug_wb_rf_wdata[23:16] & {8{debug_wb_rf_we[2]}};
assign debug_wb_rf_wdata_v[15: 8] = debug_wb_rf_wdata[15: 8] & {8{debug_wb_rf_we[1]}};
assign debug_wb_rf_wdata_v[7 : 0] = debug_wb_rf_wdata[7 : 0] & {8{debug_wb_rf_we[0]}};
assign   ref_wb_rf_wdata_v[31:24] =   ref_wb_rf_wdata[31:24] & {8{debug_wb_rf_we[3]}};
assign   ref_wb_rf_wdata_v[23:16] =   ref_wb_rf_wdata[23:16] & {8{debug_wb_rf_we[2]}};
assign   ref_wb_rf_wdata_v[15: 8] =   ref_wb_rf_wdata[15: 8] & {8{debug_wb_rf_we[1]}};
assign   ref_wb_rf_wdata_v[7 : 0] =   ref_wb_rf_wdata[7 : 0] & {8{debug_wb_rf_we[0]}};


//compare result in rsing edge 
reg debug_wb_err;
always @(posedge soc_clk)
begin
    #2;
    if(!resetn)
    begin
        debug_wb_err <= 1'b0;
    end
    else if(|debug_wb_rf_we && debug_wb_rf_wnum!=5'd0 && !debug_end && `CONFREG_OPEN_TRACE)
    begin
        if (  (debug_wb_pc!==ref_wb_pc) || (debug_wb_rf_wnum!==ref_wb_rf_wnum)
            ||(debug_wb_rf_wdata_v!==ref_wb_rf_wdata_v) )
        begin
            $display("--------------------------------------------------------------");
            $display("[%t] TRACE MISMATCH (WB) !!!",$time);
            $display("    cycle=%0d commit=%0d", cycle_cnt, commit_cnt);
            $display("    reference: PC = 0x%8h, wb_rf_wnum = 0x%2h, wb_rf_wdata = 0x%8h",
                      ref_wb_pc, ref_wb_rf_wnum, ref_wb_rf_wdata_v);
            $display("    mycpu    : PC = 0x%8h, wb_rf_wnum = 0x%2h, wb_rf_wdata = 0x%8h",
                      debug_wb_pc, debug_wb_rf_wnum, debug_wb_rf_wdata_v);
            $display("    pipe     : pc=0x%8h next=0x%8h pc_id=0x%8h pc_exe=0x%8h wb_pc=0x%8h",
                      soc_lite.u_cpu.pc, soc_lite.u_cpu.nextpc, soc_lite.u_cpu.pc_2ID,
                      soc_lite.u_cpu.pc_exe, soc_lite.u_cpu.wb_pc);
            $display("    inst     : if=0x%8h id=0x%8h id_b=%0d id_csrwr=%0d id_known=%0d",
                      soc_lite.u_cpu.inst_rdata_2IF, soc_lite.u_cpu.inst_2ID,
                      soc_lite.u_cpu.u_IDport.inst_b, soc_lite.u_cpu.u_IDport.inst_csrwr,
                      soc_lite.u_cpu.u_IDport.inst_known);
            $display("    branch   : taken=%0d op=0x%0h imm=0x%8h src1=0x%8h src2=0x%8h",
                      soc_lite.u_cpu.br_taken_q, soc_lite.u_cpu.br_op_2EXE,
                      soc_lite.u_cpu.br_imm_2EXE, soc_lite.u_cpu.alu_src1_2EXE,
                      soc_lite.u_cpu.alu_src2_2EXE);
            $display("    csr      : red=%0d npc=0x%8h rvalue=0x%8h crmd=0x%8h ex=%0d int=%0d",
                      soc_lite.u_cpu.csr_redirect, soc_lite.u_cpu.csr_next_pc,
                      soc_lite.u_cpu.csr_rvalue_unused,
                      soc_lite.u_cpu.u_csr_exception_commit_handler.csr_crmd_rvalue,
                      soc_lite.u_cpu.wb_ex_2csr, soc_lite.u_cpu.wb_int_valid_2csr);
            $display("    valid    : if/id/exe/mem/wb = %0d/%0d/%0d/%0d/%0d",
                      soc_lite.u_cpu.IF_valid, soc_lite.u_cpu.ID_valid, soc_lite.u_cpu.EXE_valid,
                      soc_lite.u_cpu.MEM_valid, soc_lite.u_cpu.WB_valid);
            $display("--------------------------------------------------------------");
            debug_wb_err <= 1'b1;
            #40;
            $finish;
        end
    end
end

//monitor numeric display
reg [7:0] err_count;
wire [31:0] confreg_num_reg = `CONFREG_NUM_REG;
reg  [31:0] confreg_num_reg_r;
always @(posedge soc_clk)
begin
    confreg_num_reg_r <= confreg_num_reg;
    if (!resetn)
    begin
        err_count <= 8'd0;
    end
    else if (confreg_num_reg_r != confreg_num_reg && `CONFREG_NUM_MONITOR)
    begin
        if(confreg_num_reg[7:0]!=confreg_num_reg_r[7:0]+1'b1)
        begin
            $display("--------------------------------------------------------------");
            $display("[%t] Error(%d)!!! Occurred in number 8'd%02d Functional Test Point!",$time, err_count, confreg_num_reg[31:24]);
            $display("--------------------------------------------------------------");
            err_count <= err_count + 1'b1;
        end
        else if(confreg_num_reg[31:24]!=confreg_num_reg_r[31:24]+1'b1)
        begin
            $display("--------------------------------------------------------------");
            $display("[%t] Error(%d)!!! Unknown, Functional Test Point numbers are unequal!",$time,err_count);
            $display("--------------------------------------------------------------");
            $display("==============================================================");
            err_count <= err_count + 1'b1;
        end
        else
        begin
            $display("----[%t] Number 8'd%02d Functional Test Point PASS!!!", $time, confreg_num_reg[31:24]);
        end
    end
end

//monitor test
initial
begin
    $timeformat(-9,0," ns",10);
    while(!resetn) #5;
    $display("==============================================================");
    $display("Test begin! (AXI SoC / exp16 unified TB: exp11~16 func + trace compare)");
    $display("TB_TIMEOUT_CYCLES=%0d  (override: +define+TB_TIMEOUT_CYCLES=<val>)", `TB_TIMEOUT_CYCLES);

    #10000;
    while(`CONFREG_NUM_MONITOR)
    begin
        #10000;
        $display ("        [%t] Test is running, debug_wb_pc = 0x%8h",$time, debug_wb_pc);
        $display ("        cycle=%0d commit=%0d open_trace=%0d num_data=0x%8h",
                  cycle_cnt, commit_cnt, `CONFREG_OPEN_TRACE, confreg_num_reg);
        $display ("        fetch_pc=0x%8h nextpc=0x%8h csr_redirect=%0d flush=%0d",
                  soc_lite.u_cpu.pc, soc_lite.u_cpu.nextpc,
                  soc_lite.u_cpu.csr_redirect, soc_lite.u_cpu.csr_flush_pipeline);
        $display ("        wb_ex=%0d int=%0d adef=%0d ale=%0d sys=%0d brk=%0d ine=%0d wb_pc=0x%8h id_inst=0x%8h",
                  soc_lite.u_cpu.wb_ex_2csr,
                  soc_lite.u_cpu.wb_int_valid_2csr,
                  soc_lite.u_cpu.wb_adef_valid_2csr,
                  soc_lite.u_cpu.wb_ale_valid_2csr,
                  soc_lite.u_cpu.wb_sys_valid_2csr,
                  soc_lite.u_cpu.wb_brk_valid_2csr,
                  soc_lite.u_cpu.wb_ine_valid_2csr,
                  soc_lite.u_cpu.wb_pc,
                  soc_lite.u_cpu.inst_2ID);
        $display ("        ctrl: stall=%0d block=%0d pc_stall=%0d cancel=%0d ifid_allow=%0d idexe_allow=%0d exemem_allow=%0d memwb_allow=%0d",
                  soc_lite.u_cpu.stall,
                  soc_lite.u_cpu.block_sig,
                  soc_lite.u_cpu.pc_stall,
                  soc_lite.u_cpu.cancel_sig,
                  soc_lite.u_cpu.IF_ID_reg_allowIn,
                  soc_lite.u_cpu.ID_EXE_reg_allowIn,
                  soc_lite.u_cpu.EXE_MEM_reg_allowIn,
                  soc_lite.u_cpu.MEM_WB_reg_allowIn);
        $display ("        stage: IF(v/r/a)=%0d/%0d/%0d ID(v/r/a)=%0d/%0d/%0d EXE(v/r/a)=%0d/%0d/%0d MEM(v/r/a)=%0d/%0d/%0d WB(v/a)=%0d/%0d",
                  soc_lite.u_cpu.IF_valid,  soc_lite.u_cpu.IF_readyGo,  soc_lite.u_cpu.IF_allowIn,
                  soc_lite.u_cpu.ID_valid,  soc_lite.u_cpu.ID_readyGo,  soc_lite.u_cpu.ID_allowIn,
                  soc_lite.u_cpu.EXE_valid, soc_lite.u_cpu.EXE_readyGo, soc_lite.u_cpu.EXE_allowIn,
                  soc_lite.u_cpu.MEM_valid, soc_lite.u_cpu.MEM_readyGo, soc_lite.u_cpu.MEM_allowIn,
                  soc_lite.u_cpu.WB_valid,  soc_lite.u_cpu.wb_allowIn);
        $display ("        memif: inst_r_complete=%0d axi_if_busy=%0d", 
                  soc_lite.u_cpu.inst_r_complete,
                  soc_lite.u_cpu.axi_if_busy);
    end
end

//模拟串口打印
wire uart_display;
wire [7:0] uart_data;
assign uart_display = `CONFREG_UART_DISPLAY;
assign uart_data    = `CONFREG_UART_DATA;

always @(posedge soc_clk)
begin
    if(uart_display)
    begin
        if(uart_data==8'hff)
        begin
            // 结束符由下方 test_end 统一处理
        end
        else
        begin
            $write("%c",uart_data);
        end
    end
end

//test end
wire global_err = debug_wb_err || (err_count!=8'd0);
wire test_end = (debug_wb_pc==`END_PC) || (uart_display && uart_data==8'hff);
always @(posedge soc_clk)
begin
    if (resetn && !debug_end && cycle_cnt != 32'd0 && (cycle_cnt % 32'd100000 == 32'd0))
    begin
        $display("[HB] cycle=%0d commit=%0d pc=0x%8h next=0x%8h wb_pc=0x%8h csr_red=%0d csr_npc=0x%8h br_taken=%0d br_op=0x%0h inst_r_complete=%0d axi_if_busy=%0d | st=%0d arv=%0d arr=%0d araddr=0x%8h rv=%0d rid=%0d ir1=%0d ir2=%0d iwait=%0d ipp=0x%8h rw=%0d rt=%0d sw=%0d",
                 cycle_cnt, commit_cnt, soc_lite.u_cpu.pc, soc_lite.u_cpu.nextpc, debug_wb_pc,
                 soc_lite.u_cpu.csr_redirect, soc_lite.u_cpu.csr_next_pc,
                 soc_lite.u_cpu.br_taken_q, soc_lite.u_cpu.br_op_2EXE,
                 soc_lite.u_cpu.inst_r_complete, soc_lite.u_cpu.axi_if_busy,
                 soc_lite.u_cpu.u_sram_AXI_bridge.state,
                 soc_lite.u_cpu.u_sram_AXI_bridge.arvalid,
                 soc_lite.u_cpu.u_sram_AXI_bridge.arready,
             soc_lite.u_cpu.u_sram_AXI_bridge.araddr,
                 soc_lite.u_cpu.u_sram_AXI_bridge.rvalid,
                 soc_lite.u_cpu.u_sram_AXI_bridge.rid,
                 soc_lite.u_cpu.u_sram_AXI_bridge.ir_pending,
                 soc_lite.u_cpu.u_sram_AXI_bridge.ir_pending2,
                 soc_lite.u_cpu.u_sram_AXI_bridge.inst_wait_data,
                 soc_lite.u_cpu.u_sram_AXI_bridge.inst_pc_pending,
                 soc_lite.u_cpu.u_sram_AXI_bridge.r_wait_cnt,
                 soc_lite.u_cpu.u_sram_AXI_bridge.inst_retry_cnt,
                 soc_lite.u_cpu.u_sram_AXI_bridge.inst_stall_cnt);
    end

    if(resetn && (cycle_cnt > `TB_TIMEOUT_CYCLES) && !debug_end)
    begin
        $display("==============================================================");
        $display("[%t] TIMEOUT!!! cycle=%0d commit=%0d pc=0x%8h",
                 $time, cycle_cnt, commit_cnt, debug_wb_pc);
        $display("last wb: we=0x%1h wnum=0x%2h wdata=0x%8h",
                 debug_wb_rf_we, debug_wb_rf_wnum, debug_wb_rf_wdata_v);
        $display("Hint: enlarge TB_TIMEOUT_CYCLES if test is still progressing.");
        $display("==============================================================");
        debug_end <= 1'b1;
        #40;
        $fclose(trace_ref);
        $finish;
    end
    else if (!resetn)
    begin
        debug_end <= 1'b0;
    end
    else if(test_end && !debug_end)
    begin
        debug_end <= 1'b1;
        $display("==============================================================");
        $display("Test end!");
        $display("final cycle=%0d commit=%0d", cycle_cnt, commit_cnt);
        #40;
        $fclose(trace_ref);
        if (global_err)
        begin
            $display("Fail!!!Total %d errors!",err_count);
        end
        else
        begin
            $display("----PASS!!!");
        end
	    $finish;
	end
end
endmodule
