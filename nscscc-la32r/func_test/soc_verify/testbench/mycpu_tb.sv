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
`timescale 1ns / 1ps

`include "mycpu_inst.vh"
`include "defines.vh"

`define SRAM_INIT_FILE        "../../../../../../../func/obj/inst_ram.mif"
`define TRACE_REF_FILE        "../../../../../../../gettrace/golden_trace.txt"
`define TRACE_REF_WDATA_FILE  "../../../../../../../gettrace/golden_trace_wdata.txt"
`define TRACE_REF_BJ_FILE     "../../../../../../../gettrace/golden_trace_bj.txt"
`define CONFREG_NUM_REG      soc_lite.u_confreg.num_data
`define CONFREG_OPEN_TRACE   soc_lite.u_confreg.open_trace
`define CONFREG_NUM_MONITOR  soc_lite.u_confreg.num_monitor
`define CONFREG_UART_DISPLAY soc_lite.u_confreg.write_uart_valid
`define CONFREG_UART_DATA    soc_lite.u_confreg.write_uart_data
`define END_PC 32'h1c000100

module tb_top( );
    reg resetn = 1'b0;
    reg clk = 1'b0;

    //sram
    wire [19:0] sram_addr;
    wire [31:0] sram_data;
    wire        sram_oen;
    wire        sram_cen;
    wire        sram_wen;
    wire [ 3:0] sram_ben;
    //goio
    wire [15:0] led;
    wire [1 :0] led_rg0;
    wire [1 :0] led_rg1;
    wire [7 :0] num_csn;
    wire [6 :0] num_a_g;
    wire [7 :0] switch      = 8'hff;
    wire [3 :0] btn_key_col;
    wire [3 :0] btn_key_row = 4'd0;
    wire [1 :0] btn_step    = 2'd3;    

    initial #2000 resetn = 1'b1;
    always #10 clk = ~clk;
    soc_lite_top #(.SIMULATION(1'b1)) soc_lite (
        .resetn     (resetn), 
        .clk        (clk   ),

        //------sram-------
        .sram_addr  (sram_addr),
        .sram_data  (sram_data),
        .sram_oen   (sram_oen ),      // output enable
        .sram_cen   (sram_cen ),      // chip select
        .sram_wen   (sram_wen ),      // write enable
        .sram_ben   (sram_ben ),      // byte enable
        
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

    // Upper half-word
    sram_model sram_uh (
        .Address    (sram_addr[19:0] ),     // input [19:0]
        .DataIO     (sram_data[31:16]),     // inout [15:0]
        .OE_n       (sram_oen        ),     // input [0:0]
        .CE_n       (sram_cen        ),     // input [0:0]
        .WE_n       (sram_wen        ),     // input [0:0]
        .UB_n       (sram_ben[3]     ),     // input [0:0]
        .LB_n       (sram_ben[2]     )      // input [0:0]
    );
    // Lower half-word
    sram_model sram_lh (
        .Address    (sram_addr[19:0] ),     // input [19:0]
        .DataIO     (sram_data[15:0] ),     // inout [15:0]
        .OE_n       (sram_oen        ),     // input [0:0]
        .CE_n       (sram_cen        ),     // input [0:0]
        .WE_n       (sram_wen        ),     // input [0:0]
        .UB_n       (sram_ben[1]     ),     // input [0:0]
        .LB_n       (sram_ben[0]     )      // input [0:0]
    );

    // initialize sram
    reg [31:0] tmp_data;
    integer sram_init_file, sram_file_size = 0;
    initial begin
        sram_init_file = $fopen(`SRAM_INIT_FILE, "r");
        if (!sram_init_file) begin
            $display("Failed to open SRAM init file");
            $finish;
        end else begin
            while (!$feof(sram_init_file)) begin
                if ($fscanf(sram_init_file, "%b", tmp_data) == 1) begin
                    sram_uh.mem_array1[sram_file_size] = tmp_data[31:24];
                    sram_uh.mem_array0[sram_file_size] = tmp_data[23:16];
                    sram_lh.mem_array1[sram_file_size] = tmp_data[15: 8];
                    sram_lh.mem_array0[sram_file_size] = tmp_data[ 7: 0];
                    sram_file_size = sram_file_size + 1;
                end
            end
            $fclose(sram_init_file);
            $display("SRAM Init Size(words): %d", sram_file_size);
        end
    end

    //soc lite signals
    //"soc_clk" means clk in cpu
    //"wb" means write-back stage in pipeline
    //"rf" means regfiles in cpu
    //"w" in "wen/wnum/wdata" means writing
    wire        soc_clk           = soc_lite.u_cpu.u_mycpu.cpu_clk;
`ifndef ENABLE_INCDEV
    wire [3 :0] debug_wb_rf_we    = soc_lite.u_cpu.u_mycpu.debug_wb_rf_we;
    wire [31:0] debug_wb_pc       = soc_lite.u_cpu.u_mycpu.debug_wb_pc;
    wire [4 :0] debug_wb_rf_wnum  = soc_lite.u_cpu.u_mycpu.debug_wb_rf_rd;
    wire [31:0] debug_wb_rf_wdata = soc_lite.u_cpu.u_mycpu.debug_wb_rf_wdata;

    wire [ 3:0] debug_wdata_we   = soc_lite.u_cpu.u_mycpu.debug_wdata_we;
    wire [31:0] debug_wdata_pc   = soc_lite.u_cpu.u_mycpu.debug_wdata_pc;
    wire [31:0] debug_wdata_addr = soc_lite.u_cpu.u_mycpu.debug_wdata_addr;
    wire [31:0] debug_wdata      = soc_lite.u_cpu.u_mycpu.debug_wdata;

    wire        debug_bj_taken   = soc_lite.u_cpu.u_mycpu.debug_bj_taken;
    wire [31:0] debug_bj_pc      = soc_lite.u_cpu.u_mycpu.debug_bj_pc;
    wire [31:0] debug_bj_target  = soc_lite.u_cpu.u_mycpu.debug_bj_target;
`else
    reg wb_rf_unimpl_r, mem_st_unimpl_r, ex_bj_unimpl_r;
    always @(posedge soc_clk) begin     // synchronize from negedge(incdev) to posedge(mycpu)
        wb_rf_unimpl_r  <= wb_rf_unimpl;
        mem_st_unimpl_r <= mem_st_unimpl;
        ex_bj_unimpl_r  <= ex_bj_unimpl_taken;
    end
    wire        wb_rf_unimpl_f    = wb_rf_unimpl_r & soc_lite.u_cpu.u_mycpu.wb_valid;
    wire [3 :0] debug_wb_rf_we    = {4{wb_rf_unimpl_f}} | soc_lite.u_cpu.u_mycpu.debug_wb_rf_we;
    wire [31:0] debug_wb_pc       = soc_lite.u_cpu.u_mycpu.debug_wb_pc;
    wire [4 :0] debug_wb_rf_wnum  = wb_rf_unimpl_f ? ref_wb_rf_wnum  : soc_lite.u_cpu.u_mycpu.debug_wb_rf_rd;
    wire [31:0] debug_wb_rf_wdata = wb_rf_unimpl_f ? ref_wb_rf_wdata : soc_lite.u_cpu.u_mycpu.debug_wb_rf_wdata;

    wire        mem_st_unimpl_f  = mem_st_unimpl_r & soc_lite.u_cpu.u_mycpu.mem_valid;
    wire [ 3:0] debug_wdata_we   = {4{mem_st_unimpl_f}} | soc_lite.u_cpu.u_mycpu.debug_wdata_we;
    wire [31:0] debug_wdata_pc   = soc_lite.u_cpu.u_mycpu.debug_wdata_pc;
    wire [31:0] debug_wdata_addr = mem_st_unimpl_f ? ref_wdata_addr : soc_lite.u_cpu.u_mycpu.debug_wdata_addr;
    wire [31:0] debug_wdata      = mem_st_unimpl_f ? ref_wdata      : soc_lite.u_cpu.u_mycpu.debug_wdata;

    wire        ex_bj_unimpl_f  = ex_bj_unimpl_r & soc_lite.u_cpu.u_mycpu.ex_valid;
    wire [31:0] mycpu_if_pc     = soc_lite.u_cpu.u_mycpu.if_pc;
    wire [31:0] mycpu_ex_pc     = soc_lite.u_cpu.u_mycpu.ex_pc;
    wire        debug_bj_taken  = ex_bj_unimpl_f | soc_lite.u_cpu.u_mycpu.debug_bj_taken;
    wire [31:0] debug_bj_pc     = ex_bj_unimpl_f ? mycpu_ex_pc : soc_lite.u_cpu.u_mycpu.debug_bj_pc;
    wire [31:0] debug_bj_target = ex_bj_unimpl_f ? mycpu_if_pc : soc_lite.u_cpu.u_mycpu.debug_bj_target;
`endif

    // open the trace file;
    integer trace_ref       = $fopen(`TRACE_REF_FILE      , "r");
    integer trace_ref_wdata = $fopen(`TRACE_REF_WDATA_FILE, "r");
    integer trace_ref_bj    = $fopen(`TRACE_REF_BJ_FILE   , "r");

    //get reference result in falling edge
    reg        trace_cmp_flag, trace_cmp_wdata_flag, trace_cmp_bj_flag;
    reg        debug_end;

    reg [31:0] ref_wb_pc      ;
    reg [ 4:0] ref_wb_rf_wnum ;
    reg [31:0] ref_wb_rf_wdata;

    reg [31:0] ref_wdata_pc  ;
    reg [31:0] ref_wdata_addr;
    reg [ 3:0] ref_wdata_we  ;
    reg [31:0] ref_wdata     ;

    reg [31:0] ref_bj_pc    ;
    reg [31:0] ref_bj_target;

    reg  resetn_r;
    wire first_rd = !resetn_r & resetn;
    always @(posedge soc_clk) begin
        resetn_r <= resetn;

        if (first_rd || |debug_wb_rf_we && debug_wb_rf_wnum!=5'd0 && !debug_end && `CONFREG_OPEN_TRACE) begin
            trace_cmp_flag = 1'b0;
            while (!trace_cmp_flag && !($feof(trace_ref)))
                $fscanf(trace_ref, "%h %h %h %h", trace_cmp_flag,
                        ref_wb_pc, ref_wb_rf_wnum, ref_wb_rf_wdata);
        end

        if (first_rd || |debug_wdata_we && !debug_end && `CONFREG_OPEN_TRACE) begin
            trace_cmp_wdata_flag = 1'b0;
            while (!trace_cmp_wdata_flag && !($feof(trace_ref_wdata)))
                $fscanf(trace_ref_wdata, "%h %h %h %h %h", trace_cmp_wdata_flag,
                        ref_wdata_pc, ref_wdata_addr, ref_wdata_we, ref_wdata);
        end

        if (first_rd || debug_bj_taken && !debug_end && `CONFREG_OPEN_TRACE) begin
            trace_cmp_bj_flag = 1'b0;
            while (!trace_cmp_bj_flag && !($feof(trace_ref_bj)))
                $fscanf(trace_ref_bj, "%h %h %h", trace_cmp_bj_flag, ref_bj_pc, ref_bj_target);
        end
    end

    //wdata[i*8+7 : i*8] is valid, only wehile wen[i] is valid
    wire [31:0] debug_wb_rf_wdata_v = {debug_wb_rf_wdata[31:24] & {8{debug_wb_rf_we[3]}},
                                       debug_wb_rf_wdata[23:16] & {8{debug_wb_rf_we[2]}},
                                       debug_wb_rf_wdata[15: 8] & {8{debug_wb_rf_we[1]}},
                                       debug_wb_rf_wdata[7 : 0] & {8{debug_wb_rf_we[0]}}};
    wire [31:0] ref_wb_rf_wdata_v   = {  ref_wb_rf_wdata[31:24] & {8{debug_wb_rf_we[3]}},
                                         ref_wb_rf_wdata[23:16] & {8{debug_wb_rf_we[2]}},
                                         ref_wb_rf_wdata[15: 8] & {8{debug_wb_rf_we[1]}},
                                         ref_wb_rf_wdata[7 : 0] & {8{debug_wb_rf_we[0]}}};
                                         
    wire [31:0] debug_wdata_v = {debug_wdata[31:24] & {8{debug_wdata_we[3]}},
                                 debug_wdata[23:16] & {8{debug_wdata_we[2]}},
                                 debug_wdata[15: 8] & {8{debug_wdata_we[1]}},
                                 debug_wdata[7 : 0] & {8{debug_wdata_we[0]}}};
    wire [31:0] ref_wdata_v   = {  ref_wdata[31:24] & {8{  ref_wdata_we[3]}},
                                   ref_wdata[23:16] & {8{  ref_wdata_we[2]}},
                                   ref_wdata[15: 8] & {8{  ref_wdata_we[1]}},
                                   ref_wdata[7 : 0] & {8{  ref_wdata_we[0]}}};

    //compare result in rsing edge 
    reg debug_wb_err;
    always @(posedge soc_clk) begin
        #2;
        if(!resetn) begin
            debug_wb_err <= 1'b0;
        end else begin
            if (|debug_wb_rf_we && debug_wb_rf_wnum!=5'd0 && !debug_end && `CONFREG_OPEN_TRACE) begin
                if (  (debug_wb_pc!==ref_wb_pc) || (debug_wb_rf_wnum!==ref_wb_rf_wnum)
                    ||(debug_wb_rf_wdata_v!==ref_wb_rf_wdata_v) ) begin
                    $display("--------------------------------------------------------------");
                    $display("[%t] Error!!! - Register Write",$time);
                    $display("    reference: PC = 0x%8h, wb_rf_wnum = 0x%2h, wb_rf_wdata = 0x%8h",
                            ref_wb_pc, ref_wb_rf_wnum, ref_wb_rf_wdata_v);
                    $display("    mycpu    : PC = 0x%8h, wb_rf_wnum = 0x%2h, wb_rf_wdata = 0x%8h",
                            debug_wb_pc, debug_wb_rf_wnum, debug_wb_rf_wdata_v);
                    $display("--------------------------------------------------------------");
                    debug_wb_err <= 1'b1;
                    #40;
                    $finish;
                end
            end

            if (|debug_wdata_we && !debug_end && `CONFREG_OPEN_TRACE) begin
                if (  (debug_wdata_pc!==ref_wdata_pc) || (debug_wdata_addr!==ref_wdata_addr)
                    ||(debug_wdata_v!==ref_wdata_v) ) begin
                    $display("--------------------------------------------------------------");
                    $display("[%t] Error!!! - Memory Write",$time);
                    $display("    reference: PC = 0x%8h, wdata_addr = 0x%8h, wdata = 0x%8h",
                            ref_wdata_pc, ref_wdata_addr, ref_wdata_v);
                    $display("    mycpu    : PC = 0x%8h, wdata_addr = 0x%8h, wdata = 0x%8h",
                            debug_wdata_pc, debug_wdata_addr, debug_wdata_v);
                    $display("--------------------------------------------------------------");
                    debug_wb_err <= 1'b1;
                    #40;
                    $finish;
                end
            end

            if (debug_bj_taken && !debug_end && `CONFREG_OPEN_TRACE) begin
                if ( (debug_bj_pc!==ref_bj_pc) || (debug_bj_target!==ref_bj_target) ) begin
                    $display("--------------------------------------------------------------");
                    $display("[%t] Error!!! - Branch or Jump",$time);
                    $display("    reference: PC = 0x%8h, bj_target = 0x%8h", ref_bj_pc, ref_bj_target);
                    $display("    mycpu    : PC = 0x%8h, bj_target = 0x%8h", debug_bj_pc, debug_bj_target);
                    $display("--------------------------------------------------------------");
                    debug_wb_err <= 1'b1;
                    #40;
                    $finish;
                end
            end
        end
    end

    //monitor numeric display
    reg [7:0] err_count;
    wire [31:0] confreg_num_reg = `CONFREG_NUM_REG;
    reg  [31:0] confreg_num_reg_r;
    always @(posedge soc_clk) begin
        confreg_num_reg_r <= confreg_num_reg;
        if (!resetn) begin
            err_count <= 8'd0;
        end else if (confreg_num_reg_r != confreg_num_reg && `CONFREG_NUM_MONITOR) begin
            if(confreg_num_reg[7:0]!=confreg_num_reg_r[7:0]+1'b1) begin
                $display("--------------------------------------------------------------");
                $display("[%t] Error(%d)!!! Occurred in number 8'd%02d Functional Test Point!",$time, err_count, confreg_num_reg[31:24]);
                $display("--------------------------------------------------------------");
                err_count <= err_count + 1'b1;
            end else if(confreg_num_reg[31:24]!=confreg_num_reg_r[31:24]+1'b1) begin
                $display("--------------------------------------------------------------");
                $display("[%t] Error(%d)!!! Unknown, Functional Test Point numbers are unequal!",$time,err_count);
                $display("--------------------------------------------------------------");
                $display("==============================================================");
                err_count <= err_count + 1'b1;
            end else
                $display("----[%t] Number 8'd%02d Functional Test Point PASS!!!", $time, confreg_num_reg[31:24]);
        end
    end

    //monitor test
    initial begin
        $timeformat(-9,0," ns",10);
        while(!resetn) #5;
        $display("==============================================================");
        $display("Test begin!");

        #10000;
        while(`CONFREG_NUM_MONITOR) begin
            #10000;
            $display ("        [%t] Test is running, debug_wb_pc = 0x%8h",$time, debug_wb_pc);
        end
    end

    //Ä£Äâ´®¿Ú´òÓ¡
    wire       uart_display = `CONFREG_UART_DISPLAY;
    wire [7:0] uart_data    = `CONFREG_UART_DATA;
    always @(posedge soc_clk) begin
        if (uart_display) begin
            if(uart_data==8'hff) begin
                ;//$finish;
            end else begin
                $write("%c",uart_data);
            end
        end
    end

    // Test hit rate of Cache
`ifdef ENABLE_ICACHE
    wire        ic_is_refill = soc_lite.u_cpu.u_icache.current_state == soc_lite.u_cpu.u_icache.REFILL;
    reg         ic_is_refill_r;
    reg  [31:0] ifetch_cnt = 0, ifetch_miss_cnt = 0;
    always @(posedge soc_clk or negedge resetn) begin
        ic_is_refill_r <= ic_is_refill;
        if (soc_lite.u_cpu.u_mycpu.id_valid) ifetch_cnt      <= ifetch_cnt      + 32'h1;
        if (!ic_is_refill_r & ic_is_refill)  ifetch_miss_cnt <= ifetch_miss_cnt + 32'h1;
    end
`endif

`ifdef ENABLE_DCACHE
    wire        dc_is_refill = soc_lite.u_cpu.u_dcache.current_state == soc_lite.u_cpu.u_dcache.REFILL;
    reg         dc_is_refill_r;
    reg  [31:0] dfetch_cnt = 0, dfetch_miss_cnt = 0;
    always @(posedge soc_clk or negedge resetn) begin
        dc_is_refill_r <= dc_is_refill;
        if (|(soc_lite.u_cpu.u_dcache.data_ren)) dfetch_cnt      <= dfetch_cnt      + 32'h1;
        if (!dc_is_refill_r & dc_is_refill)      dfetch_miss_cnt <= dfetch_miss_cnt + 32'h1;
    end
`endif

    // Test accuracy of BPU prediction
`ifdef ENABLE_BPU
    wire        ex_is_bj    = soc_lite.u_cpu.u_mycpu.u_BPU.ex_is_bj;
    wire        pred_taken  = soc_lite.u_cpu.u_mycpu.u_BPU.ex_pred_taken;
    wire [31:0] pred_target = soc_lite.u_cpu.u_mycpu.u_BPU.ex_pred_target;
    wire        real_taken  = soc_lite.u_cpu.u_mycpu.u_BPU.real_taken;
    wire [31:0] real_target = soc_lite.u_cpu.u_mycpu.u_BPU.real_target;
    wire [31:0] ex_pc       = soc_lite.u_cpu.u_mycpu.ex_pc;

    reg  [31:0] br_jmp_cnt  = 0, br_jmp_cnt1  = 0;
    reg  [31:0] dir_correct = 0, dir_correct1 = 0;
    reg  [31:0] tgt_correct = 0, tgt_correct1 = 0;

    reg  [31:0] b_valid_pc [1:0];
    reg  [ 1:0] b_hit;
    reg  [31:0] j_valid_pc [0:0];
    reg  [ 0:0] j_hit;
    wire        b_pc_valid = |b_hit & ex_is_bj;
    wire        j_pc_valid = |j_hit & ex_is_bj;

    initial begin
        b_valid_pc[ 0] = 32'h1c01025c;
        b_valid_pc[ 1] = 32'h1c010264;

        j_valid_pc[ 0] = 32'h1c010268;
    end

    integer i, j;
    always @(*) begin
        for (i = 0; i < 2; i = i + 1) b_hit[i] = (b_valid_pc[i] == ex_pc);
        for (j = 0; j < 1; j = j + 1) j_hit[j] = (j_valid_pc[j] == ex_pc);
    end

    always @(posedge soc_clk) begin
        if (ex_is_bj) begin
            br_jmp_cnt <= br_jmp_cnt + 1;
            if (pred_taken == real_taken) begin
                dir_correct <= dir_correct + 1;
                if (!real_taken | real_taken & (pred_target == real_target))
                    tgt_correct <= tgt_correct + 1;
            end
        end

        if (b_pc_valid | j_pc_valid) begin
            br_jmp_cnt1 <= br_jmp_cnt1 + 1;
            if (pred_taken == real_taken) begin
                dir_correct1 <= dir_correct1 + 1;
                if (!real_taken | real_taken & (pred_target == real_target))
                    tgt_correct1 <= tgt_correct1 + 1;
            end
        end
    end

    // wire     id_valid = soc_lite.u_cpu.u_mycpu.id_valid;
    // wire     id_is_b  = soc_lite.u_cpu.u_mycpu.ID.u_CU.is_branch;
    // wire     id_is_j  = soc_lite.u_cpu.u_mycpu.ID.u_CU.is_jump;
    // wire [31:0] id_pc = soc_lite.u_cpu.u_mycpu.id_pc;
    // integer bpu_track;
    // initial bpu_track = $fopen("bpu_track.txt", "w");
    // always @(posedge soc_clk) begin
    //     if (id_valid & id_is_b) begin
    //         $fwrite(bpu_track, "%c 0x%08h\n", "b", id_pc);
    //     end
    //     if (id_valid & id_is_j) begin
    //         $fwrite(bpu_track, "%c 0x%08h\n", "j", id_pc);
    //     end
    // end
`endif

    //test end
    wire global_err = debug_wb_err || (err_count!=8'd0);
    wire test_end = (debug_wb_pc==`END_PC) || (uart_display && uart_data==8'hff);
    always @(posedge soc_clk) begin
        if (!resetn) begin
            debug_end <= 1'b0;
        end else if(test_end && !debug_end) begin
            debug_end <= 1'b1;
            $display("==============================================================");
            $display("Test end!");
            #40;
            $fclose(trace_ref);
            $fclose(trace_ref_wdata);
            $fclose(trace_ref_bj);
            `ifdef ENABLE_INCDEV
                $fclose(trace_bj_pc);
                $fclose(trace_data_forward);
            `endif
            if (global_err)
                $display("Fail!!!Total %d errors!",err_count);
            else
                $display("----PASS!!!");

`ifdef ENABLE_ICACHE
            $display("==============================================================");
            // Print Cache hit rate
            $display("----ICache hit rate: %d / %d = %.03f%%", ifetch_cnt - ifetch_miss_cnt, ifetch_cnt,
                                        $itor(ifetch_cnt - ifetch_miss_cnt) * 100 / $itor(ifetch_cnt));
`endif
`ifdef ENABLE_DCACHE
            $display("----DCache read hit rate: %d / %d = %.03f%%", dfetch_cnt - dfetch_miss_cnt, dfetch_cnt,
                                        $itor(dfetch_cnt - dfetch_miss_cnt) * 100 / $itor(dfetch_cnt));
`endif
`ifdef ENABLE_BPU
            // Print BPU accuracy
            $display("----BPU accuracy: dir: %.03f%%, tgt: %.03f%%",
                                        $itor(dir_correct) * 100 / $itor(br_jmp_cnt),
                                        $itor(tgt_correct) * 100 / $itor(br_jmp_cnt));
            $display("----BPU accuracy1: dir: %.03f%%, tgt: %.03f%%",
                                        $itor(dir_correct1) * 100 / $itor(br_jmp_cnt1),
                                        $itor(tgt_correct1) * 100 / $itor(br_jmp_cnt1));
            $display("==============================================================");
            // $fclose(bpu_track);
`endif
            $finish;
        end
    end

`ifdef ENABLE_INCDEV    // incdev

    `include "utils.svh"

    reg [31:0] incdev_pc = `PC_INIT_VAL;    // half a cycle ahead of mycpu_id_pc
    reg [31:0] incdev_ex_pc, incdev_mem_pc, incdev_wb_pc;
    reg [31:0] tbj_pc, tbj_target;

    // Pre-loading id_pc from trace_bj file
    integer trace_bj_pc = $fopen(`TRACE_REF_BJ_FILE, "r");
    wire mycpu_id_valid = soc_lite.u_cpu.u_mycpu.id_valid;
    reg tbj;
    wire id_is_bubble  = ex_bj_unimpl_taken | ex_bj_unimpl_taken_r;
    wire mycpu_suspend = soc_lite.u_cpu.u_mycpu.pl_suspend;
    always @(negedge soc_clk) begin
        if (first_rd | mycpu_id_valid & !id_is_bubble & !mycpu_suspend & (tbj_pc == incdev_pc)) begin
            #1 tbj = 0;
            while (!tbj && !($feof(trace_bj_pc)))
                $fscanf(trace_bj_pc, "%h %h %h", tbj, tbj_pc, tbj_target);
        end
    end

    // Obtain ex_pc, mem_pc and wb_pc half a cycle ahead of time
    always @(negedge soc_clk) begin
        if (mycpu_id_valid & !id_is_bubble & !mycpu_suspend)
            incdev_pc <= (tbj_pc == incdev_pc) ? tbj_target : incdev_pc + 32'h4;
        incdev_ex_pc  <= mycpu_suspend ? incdev_ex_pc  : incdev_pc;
        incdev_mem_pc <= mycpu_suspend ? incdev_mem_pc : incdev_ex_pc;
        incdev_wb_pc  <= mycpu_suspend ? incdev_wb_pc  : incdev_mem_pc;
    end

    wire [31:0] inst_code = `READ_SRAM(incdev_pc);

    wire inst_implemented = (`IMPL_LU12I_W   & (inst_code[31:25] == 7'h0A)    ) |
                            (`IMPL_ADD_W     & (inst_code[31:15] == 17'h00020)) |
                            (`IMPL_ADDI_W    & (inst_code[31:22] == 10'h00A)  ) |
                            (`IMPL_SUB_W     & (inst_code[31:15] == 17'h00022)) |
                            (`IMPL_SLT       & (inst_code[31:15] == 17'h00024)) |
                            (`IMPL_SLTU      & (inst_code[31:15] == 17'h00025)) |
                            (`IMPL_AND       & (inst_code[31:15] == 17'h00029)) |
                            (`IMPL_OR        & (inst_code[31:15] == 17'h0002A)) |
                            (`IMPL_XOR       & (inst_code[31:15] == 17'h0002B)) |
                            (`IMPL_NOR       & (inst_code[31:15] == 17'h00028)) |
                            (`IMPL_SLLI_W    & (inst_code[31:15] == 17'h00081)) |
                            (`IMPL_SRLI_W    & (inst_code[31:15] == 17'h00089)) |
                            (`IMPL_SRAI_W    & (inst_code[31:15] == 17'h00091)) |
                            (`IMPL_LD_W      & (inst_code[31:22] == 10'h0A2)  ) |
                            (`IMPL_ST_W      & (inst_code[31:22] == 10'h0A6)  ) |
                            (`IMPL_BEQ       & (inst_code[31:26] == 6'h16)    ) |
                            (`IMPL_BNE       & (inst_code[31:26] == 6'h17)    ) |
                            (`IMPL_BL        & (inst_code[31:26] == 6'h15)    ) |
                            (`IMPL_JIRL      & (inst_code[31:26] == 6'h13)    ) |
                            (`IMPL_B         & (inst_code[31:26] == 6'h14)    ) |
                            (`IMPL_PCADDU12I & (inst_code[31:25] == 7'h0E)    ) |
                            (`IMPL_SLTI      & (inst_code[31:22] == 10'h008)  ) |
                            (`IMPL_SLTUI     & (inst_code[31:22] == 10'h009)  ) |
                            (`IMPL_ANDI      & (inst_code[31:22] == 10'h00D)  ) |
                            (`IMPL_ORI       & (inst_code[31:22] == 10'h00E)  ) |
                            (`IMPL_XORI      & (inst_code[31:22] == 10'h00F)  ) |
                            (`IMPL_SLL_W     & (inst_code[31:15] == 17'h0002E)) |
                            (`IMPL_SRA_W     & (inst_code[31:15] == 17'h00030)) |
                            (`IMPL_SRL_W     & (inst_code[31:15] == 17'h0002F)) |
                            (`IMPL_DIV_W     & (inst_code[31:15] == 17'h00040)) |
                            (`IMPL_DIV_WU    & (inst_code[31:15] == 17'h00042)) |
                            (`IMPL_MUL_W     & (inst_code[31:15] == 17'h00038)) |
                            (`IMPL_MULH_W    & (inst_code[31:15] == 17'h00039)) |
                            (`IMPL_MULH_WU   & (inst_code[31:15] == 17'h0003A)) |
                            (`IMPL_MOD_W     & (inst_code[31:15] == 17'h00041)) |
                            (`IMPL_MOD_WU    & (inst_code[31:15] == 17'h00043)) |
                            (`IMPL_BLT       & (inst_code[31:26] == 6'h18)    ) |
                            (`IMPL_BGE       & (inst_code[31:26] == 6'h19)    ) |
                            (`IMPL_BLTU      & (inst_code[31:26] == 6'h1A)    ) |
                            (`IMPL_BGEU      & (inst_code[31:26] == 6'h1B)    ) |
                            (`IMPL_LD_B      & (inst_code[31:22] == 10'h0A0)  ) |
                            (`IMPL_LD_H      & (inst_code[31:22] == 10'h0A1)  ) |
                            (`IMPL_LD_BU     & (inst_code[31:22] == 10'h0A8)  ) |
                            (`IMPL_LD_HU     & (inst_code[31:22] == 10'h0A9)  ) |
                            (`IMPL_ST_B      & (inst_code[31:22] == 10'h0A4)  ) |
                            (`IMPL_ST_H      & (inst_code[31:22] == 10'h0A5)  );
    reg  inst_implemented_r;
    wire id_inst_impled = inst_implemented_r & mycpu_id_valid;
    always @(posedge soc_clk) inst_implemented_r <= inst_implemented;

    wire inst_is_st = (inst_code[31:22] == 10'h0A4) |   // ST.B
                      (inst_code[31:22] == 10'h0A5) |   // ST.H
                      (inst_code[31:22] == 10'h0A6);    // ST.W
    
    wire inst_is_bj = (inst_code[31:26] == 6'h14) |     // B
                      (inst_code[31:26] == 6'h16) |     // BEQ
                      (inst_code[31:26] == 6'h17) |     // BNE
                      (inst_code[31:26] == 6'h18) |     // BLT
                      (inst_code[31:26] == 6'h19) |     // BGE
                      (inst_code[31:26] == 6'h1A) |     // BLTU
                      (inst_code[31:26] == 6'h1B);      // BGEU
    wire inst_JIRL  = (inst_code[31:26] == 6'h13);      // JIRL
    wire inst_BL    = (inst_code[31:26] == 6'h15);      // BL

    wire rd_not_r0  = inst_code[4:0] != 5'h0;

    wire id_rf_unimpl   = !inst_implemented & !inst_is_st & !inst_is_bj & (rd_not_r0 | inst_BL);
    wire id_rf_unimpl_v = mycpu_id_valid & id_rf_unimpl;
    wire id_st_unimpl   = mycpu_id_valid & !inst_implemented & inst_is_st;
    wire id_bj_unimpl   = mycpu_id_valid & !inst_implemented & (inst_is_bj | inst_JIRL | inst_BL);

    wire id_unimpl    = id_rf_unimpl_v | id_st_unimpl | id_bj_unimpl;
    wire id_impl      = mycpu_id_valid & !id_unimpl;
    reg  ex_unimpl   , mem_unimpl   , wb_unimpl;
    reg  ex_rf_unimpl, mem_rf_unimpl, wb_rf_unimpl;
    reg  ex_st_unimpl, mem_st_unimpl, wb_st_unimpl;
    wire id_bj_unimpl_taken = id_bj_unimpl & (incdev_pc == ref_bj_pc);
    reg  ex_bj_unimpl_taken;
    always @(negedge soc_clk or negedge resetn) begin
        ex_rf_unimpl  <= !resetn ? 1'b0 : mycpu_suspend ? ex_rf_unimpl  : id_rf_unimpl;
        ex_st_unimpl  <= !resetn ? 1'b0 : mycpu_suspend ? ex_st_unimpl  : id_st_unimpl;
        ex_unimpl     <= !resetn ? 1'b0 : mycpu_suspend ? ex_unimpl     : id_unimpl   ;
        mem_rf_unimpl <= !resetn ? 1'b0 : mycpu_suspend ? mem_rf_unimpl : ex_rf_unimpl;
        mem_st_unimpl <= !resetn ? 1'b0 : mycpu_suspend ? mem_st_unimpl : ex_st_unimpl;
        mem_unimpl    <= !resetn ? 1'b0 : mycpu_suspend ? mem_unimpl    : ex_unimpl;
        wb_rf_unimpl  <= !resetn ? 1'b0 : mycpu_suspend ? wb_rf_unimpl  : mem_rf_unimpl;
        wb_unimpl     <= !resetn ? 1'b0 : mycpu_suspend ? wb_unimpl     : mem_unimpl;
        wb_st_unimpl  <= !resetn ? 1'b0 : mycpu_suspend ? wb_st_unimpl  : mem_st_unimpl;
        ex_bj_unimpl_taken <= !resetn ? 1'b0 : mycpu_suspend ? ex_bj_unimpl_taken :
                                                               id_bj_unimpl_taken & !ex_bj_unimpl_taken_r;
    end

    `define MYCPU_RF    soc_lite.u_cpu.u_mycpu.ID.u_RF.r
    `define MYCPU_PC    soc_lite.u_cpu.u_mycpu.IF.u_PC.pc
    reg         mycpu_suspend_r;
    wire        sram_writing = soc_lite.u_cpu.sram_bus_en & (|(soc_lite.u_cpu.sram_bus_we));
    reg  [ 3:0] ref_wdata_we_r = 4'h0;
    reg  [31:0] ref_wdata_addr_r;
    reg  [31:0] ref_wdata_r;
    always @(negedge soc_clk) mycpu_suspend_r <= mycpu_suspend;
    always @(posedge soc_clk) begin
        // Update regfile when an unimpl. inst finished its write back
        if (wb_rf_unimpl & !mycpu_suspend_r) `MYCPU_RF[ref_wb_rf_wnum] <= ref_wb_rf_wdata;

        // Update memory cell when an unimpl. inst finished its memory access
        if (mem_st_unimpl & (ref_wdata_addr[31:16] != 16'hBFAF)) begin
            if (sram_writing) begin     // Wait for the unfinished writing
                ref_wdata_we_r   <= ref_wdata_we;
                ref_wdata_addr_r <= ref_wdata_addr;
                ref_wdata_r      <= ref_wdata;
            end else begin
                if (ref_wdata_we[3]) sram_uh.mem_array1[ref_wdata_addr[21:2]] <= ref_wdata[31:24];
                if (ref_wdata_we[2]) sram_uh.mem_array0[ref_wdata_addr[21:2]] <= ref_wdata[23:16];
                if (ref_wdata_we[1]) sram_lh.mem_array1[ref_wdata_addr[21:2]] <= ref_wdata[15: 8];
                if (ref_wdata_we[0]) sram_lh.mem_array0[ref_wdata_addr[21:2]] <= ref_wdata[ 7: 0];
            end
        end else if ((|ref_wdata_we_r) & !sram_writing) begin
            if (ref_wdata_we_r[3]) sram_uh.mem_array1[ref_wdata_addr_r[21:2]] <= ref_wdata_r[31:24];
            if (ref_wdata_we_r[2]) sram_uh.mem_array0[ref_wdata_addr_r[21:2]] <= ref_wdata_r[23:16];
            if (ref_wdata_we_r[1]) sram_lh.mem_array1[ref_wdata_addr_r[21:2]] <= ref_wdata_r[15: 8];
            if (ref_wdata_we_r[0]) sram_lh.mem_array0[ref_wdata_addr_r[21:2]] <= ref_wdata_r[ 7: 0];
            ref_wdata_we_r <= 4'h0;
        end

        // Update pc when mycpu fetch an unimpl. inst which will branch or jump
        if (ex_bj_unimpl_taken) `MYCPU_PC <= ref_bj_target;
    end

    `ifdef ENABLE_ICACHE

        /* Deal with the special condition when an implemented store inst. followed by an unimplemented one */
        reg  id_st_unimpl_r;
        always @(posedge soc_clk) begin
            if (!resetn | ex_st_unimpl) id_st_unimpl_r <= 1'b0;
            else if (id_st_unimpl)      id_st_unimpl_r <= 1'b1;     // hold id_st_unimpl in case of suspension
        end
        wire mycpu_mem_valid = soc_lite.u_cpu.u_mycpu.mem_valid;
        // MEM stage has an implemented store inst.(I1) while ID stage has an unimplemented store inst.(I2)
        // and they're consecutive considering pipeline suspension caused by the MEM inst.
        wire st_mem_impl_id_unimpl = mycpu_mem_valid & !mem_st_unimpl & id_st_unimpl_r &
                                                      (incdev_mem_pc + 32'h4 == incdev_pc);
        reg  st_mem_impl_id_unimpl_r;
        always @(negedge soc_clk) st_mem_impl_id_unimpl_r <= !resetn ? 1'b0 : st_mem_impl_id_unimpl;
        wire sram_WAW_may_happen_f = !st_mem_impl_id_unimpl_r & st_mem_impl_id_unimpl;
        
        reg  sram_WAW_warning_f, sram_WAW_f_r;
        // The predecessor inst.(I1) is an implemented store inst. and it has the same destination word-address
        // as the current inst.(I2) at MEM stage
        wire sram_WAW_f = sram_WAW_warning_f & mem_st_unimpl & (ref_wdata_addr[31:16] != 16'hBFAF) &
                                                               (WAW_mem_waddr_r[31:2] == ref_wdata_addr[31:2]);

        `define SRAM_BUS_WE     soc_lite.u_cpu.sram_bus_we
        `define SRAM_BUS_WADDR  soc_lite.u_cpu.sram_bus_addr
        `define SRAM_BUS_WDATA  soc_lite.u_cpu.sram_bus_wdata
        wire sram_bus_en = soc_lite.u_cpu.sram_bus_en;
        wire sram_WAW_en = sram_WAW_f_r & sram_bus_en & (|`SRAM_BUS_WE) & (`SRAM_BUS_WADDR == WAW_mem_waddr_r >> 2);
        reg  sram_WAW_en_r;
        wire sram_WAW_end = sram_WAW_en_r & !sram_WAW_en;   // negedge sram_WAW_en
        always @(negedge soc_clk) sram_WAW_en_r <= !resetn ? 1'b0 : sram_WAW_en;

        reg  [31:0]                  WAW_id_pc_r   ;
        reg  [ 3:0] WAW_mem_we_r   , WAW_id_we_r   ;
        reg  [31:0] WAW_mem_waddr_r, WAW_id_waddr_r;
        reg  [31:0] WAW_mem_wdata_r, WAW_id_wdata_r;
        reg         WAW_id_ifetch = 0;
        wire        WAW_id_icmiss = WAW_id_ifetch & !mycpu_ifetch_vld;
        wire        mycpu_ifetch_rreq = soc_lite.u_cpu.u_mycpu.ifetch_rreq;
        wire [31:0] mycpu_ifetch_addr = soc_lite.u_cpu.u_mycpu.ifetch_addr;
        always @(posedge soc_clk) WAW_id_ifetch <= mycpu_ifetch_rreq & (mycpu_ifetch_addr == WAW_id_pc_r);
        always @(negedge soc_clk) begin
            // buffer the memory write info. of the earlier implememted store inst.
            if (sram_WAW_may_happen_f) begin
                WAW_mem_we_r    <= ref_wdata_we;
                WAW_mem_waddr_r <= ref_wdata_addr;
                WAW_mem_wdata_r <= ref_wdata;
            end

            // buffer the pc of the later unimplemented store inst.
            if (st_mem_impl_id_unimpl) WAW_id_pc_r <= incdev_pc;
            // buffer the memory write info. of the later unimplemented store inst.
            if ((|debug_wdata_we) & (debug_wdata_pc == WAW_id_pc_r)) begin
                WAW_id_we_r    <= ref_wdata_we;
                WAW_id_waddr_r <= ref_wdata_addr;
                WAW_id_wdata_r <= ref_wdata;
            end else if (WAW_id_icmiss)     // The problem disappears if the successor inst.(I2) causes ICache miss
                WAW_id_we_r    <= 4'h0;

            // sram_WAW_may_happen_f and sram_WAW_warning_f indicate that memory Write-After-Write
            // may happen, but sram_WAW_f and sram_WAW_f_r indicate that memory WAW will happen
            if (!resetn | sram_WAW_f)       sram_WAW_warning_f <= 1'b0;
            else if (sram_WAW_may_happen_f) sram_WAW_warning_f <= 1'b1;
            if (!resetn | sram_WAW_end)     sram_WAW_f_r <= 1'b0;
            else if (sram_WAW_f)            sram_WAW_f_r <= 1'b1;
        end
        
        // Merge two memory write operation into one
        wire [ 3:0] sram_WAW_we    = WAW_mem_we_r | WAW_id_we_r;
        wire [31:0] sram_WAW_wdata = {WAW_id_we_r[3] ? WAW_id_wdata_r[31:24] : WAW_mem_wdata_r[31:24],
                                      WAW_id_we_r[2] ? WAW_id_wdata_r[23:16] : WAW_mem_wdata_r[23:16],
                                      WAW_id_we_r[1] ? WAW_id_wdata_r[15: 8] : WAW_mem_wdata_r[15: 8],
                                      WAW_id_we_r[0] ? WAW_id_wdata_r[ 7: 0] : WAW_mem_wdata_r[ 7: 0]};
        `FORCE_MODIFY(`SRAM_BUS_WE   , sram_WAW_en, sram_WAW_we   )
        `FORCE_MODIFY(`SRAM_BUS_WDATA, sram_WAW_en, sram_WAW_wdata)
        
    `endif

    // Update I/O interface when an unimpl. inst finished writing a peripheral
    wire update_confreg_f = mem_st_unimpl & (ref_wdata_addr[31:16] == 16'hBFAF);
    `define CONFREG_WE      soc_lite.u_confreg.conf_we
    `define CONFREG_WADDR   soc_lite.u_confreg.conf_addr
    `define CONFREG_WDATA   soc_lite.u_confreg.conf_wdata
    `FORCE_MODIFY(`CONFREG_WE   , update_confreg_f, 1'b1)
    `FORCE_MODIFY(`CONFREG_WADDR, update_confreg_f, ref_wdata_addr)
    `FORCE_MODIFY(`CONFREG_WDATA, update_confreg_f, ref_wdata)

    // Erase ID stage when an unimplemented inst. branch or jump at EX stage
    reg ex_bj_unimpl_taken_r, mem_bj_unimpl_taken;
    wire mycpu_ifetch_vld = soc_lite.u_cpu.u_mycpu.ifetch_valid;
    always @(posedge soc_clk or negedge resetn) begin
        if (!resetn)                 ex_bj_unimpl_taken_r <= 1'b0;
        else if (ex_bj_unimpl_taken) ex_bj_unimpl_taken_r <= 1'b1;
        else if (mycpu_ifetch_vld)   ex_bj_unimpl_taken_r <= 1'b0;

        mem_bj_unimpl_taken <= ex_bj_unimpl_taken_r;
    end

    `define MYCPU_IF_NPC    soc_lite.u_cpu.u_mycpu.IF.u_PC.din
    `define MYCPU_ID_RF_WE  soc_lite.u_cpu.u_mycpu.EX.u_ID_EX.rf_we_in
    `define MYCPU_ID_RAM_WE soc_lite.u_cpu.u_mycpu.EX.u_ID_EX.ram_we_in
    `define MYCPU_ID_JMP_F  soc_lite.u_cpu.u_mycpu.EX.u_ID_EX.is_br_jmp_in
    `define MYCPU_EX_VALID  soc_lite.u_cpu.u_mycpu.EX.ex_valid
    `FORCE_MODIFY(`MYCPU_IF_NPC   , ex_bj_unimpl_taken_r, `MYCPU_PC + 32'h4)
    `FORCE_MODIFY(`MYCPU_ID_RF_WE , ex_bj_unimpl_taken_r, 1'b0)
    `FORCE_MODIFY(`MYCPU_ID_RAM_WE, ex_bj_unimpl_taken_r, 4'h0)
    `FORCE_MODIFY(`MYCPU_ID_JMP_F , ex_bj_unimpl_taken_r, 1'b0)
    `FORCE_MODIFY(`MYCPU_EX_VALID , mem_bj_unimpl_taken , 1'b0)

    `ifdef ENABLE_BPU
        `define MYBPU_PRED_TAKEN    soc_lite.u_cpu.u_mycpu.u_BPU.pred_taken
        `FORCE_MODIFY(`MYBPU_PRED_TAKEN , ex_bj_unimpl_taken_r, 1'b0)
    `endif

    wire [31:0] ex_icode  = `READ_SRAM(incdev_ex_pc);
    wire [31:0] mem_icode = `READ_SRAM(incdev_mem_pc);
    wire [31:0] wb_icode  = `READ_SRAM(incdev_wb_pc);
    
    wire [ 2:0] id_ityp  = inst_type(inst_code);
    wire [ 2:0] ex_ityp  = inst_type(ex_icode);
    wire [ 2:0] mem_ityp = inst_type(mem_icode);
    wire [ 2:0] wb_ityp  = inst_type(wb_icode);

    // Read data from trace file that required for data-forwarding
    integer    trace_data_forward = $fopen(`TRACE_REF_FILE, "r");
    reg        tdf_flag;
    reg [31:0] df_id_pc;
    reg [ 4:0] df_id_wnum;
    reg [31:0] df_id_wdata, df_ex_wdata, df_mem_wdata, df_wb_wdata;
    wire       incdev_ex_is_BL = (ex_icode[31:26] == 6'h15);
    wire       dh_id_ex_BL     = incdev_ex_is_BL & id_is_bubble & (id_ex_dh != 2'h0);
    always @(negedge soc_clk) begin
        if (resetn & mycpu_id_valid & !id_is_bubble & !mycpu_suspend) begin
            if ((id_ityp != `ITyp_2R1) & (id_ityp != `ITyp_Nil) & (inst_code[4:0] != 5'h0) |
                (inst_code[31:26] == 6'h15)) begin      // id_inst will write back and rd != r0
                tdf_flag = 1'b0;
                while (!tdf_flag && !($feof(trace_data_forward)))
                    $fscanf(trace_data_forward, "%h %h %h %h", tdf_flag, df_id_pc, df_id_wnum, df_id_wdata);
            end
        
            df_ex_wdata  <= df_id_wdata ;
            df_mem_wdata <= df_ex_wdata ;
            df_wb_wdata  <= df_mem_wdata;
        end

        if (dh_id_ex_BL) df_mem_wdata <= df_ex_wdata;
    end

    // Data-forwarding
    wire [ 1:0] id_ex_dh  = data_hazard_detect(inst_code, id_ityp, ex_icode , ex_ityp );
    wire [ 1:0] id_mem_dh = data_hazard_detect(inst_code, id_ityp, mem_icode, mem_ityp);
    wire [ 1:0] id_wb_dh  = data_hazard_detect(inst_code, id_ityp, wb_icode , wb_ityp );
    wire [ 1:0] fd_id_ex  = {2{resetn & id_impl & ex_unimpl }} & id_ex_dh  ;
    wire [ 1:0] fd_id_mem = {2{resetn & id_impl & mem_unimpl}} & id_mem_dh & ~id_ex_dh;
    wire [ 1:0] fd_id_wb  = {2{resetn & id_impl & wb_unimpl }} & id_wb_dh  & ~id_mem_dh & ~id_ex_dh;
    reg  [ 1:0] fd_id_ex_r, fd_id_mem_r, fd_id_wb_r;
    reg  [31:0] df_ex_wdata_r, df_mem_wdata_r, df_wb_wdata_r;
    always @(posedge soc_clk or negedge resetn) begin
        fd_id_ex_r  <= !resetn ? 2'h0 : fd_id_ex ;
        fd_id_mem_r <= !resetn ? 2'h0 : fd_id_mem;
        fd_id_wb_r  <= !resetn ? 2'h0 : fd_id_wb ;
        df_ex_wdata_r  <= df_ex_wdata ;
        df_mem_wdata_r <= df_mem_wdata;
        df_wb_wdata_r  <= df_wb_wdata ;
    end

    wire        fm_src1_f     = fd_id_ex_r[0] | fd_id_mem_r[0] | fd_id_wb_r[0];
    wire        fm_src2_f     = fd_id_ex_r[1] | fd_id_mem_r[1] | fd_id_wb_r[1];
    wire [31:0] fm_src1_wdata = {32{fd_id_ex_r [0]}} & df_ex_wdata_r  |     // id.rs1 <- ex.rd
                                {32{fd_id_mem_r[0]}} & df_mem_wdata_r |     // id.rs1 <- mem.rd
                                {32{fd_id_wb_r [0]}} & df_wb_wdata_r;       // id.rs1 <- wb.rd
    wire [31:0] fm_src2_wdata = {32{fd_id_ex_r [1]}} & df_ex_wdata_r  |     // id.rs2 <- ex.rd
                                {32{fd_id_mem_r[1]}} & df_mem_wdata_r |     // id.rs2 <- mem.rd
                                {32{fd_id_wb_r [1]}} & df_wb_wdata_r;       // id.rs2 <- wb.rd

    `define MYCPU_SRC1  soc_lite.u_cpu.u_mycpu.EX.u_ID_EX.rD1_in
    `define MYCPU_SRC2  soc_lite.u_cpu.u_mycpu.EX.u_ID_EX.rD2_in
    `FORCE_MODIFY(`MYCPU_SRC1, fm_src1_f, fm_src1_wdata)
    `FORCE_MODIFY(`MYCPU_SRC2, fm_src2_f, fm_src2_wdata)

`endif

endmodule
