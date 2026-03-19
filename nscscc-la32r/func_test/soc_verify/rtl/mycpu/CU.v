`timescale 1ns / 1ps

`include "mycpu_inst.vh"
`include "defines.vh"

module CU (
    input  wire [31:15] inst_31_15,
    output wire [ 1: 0] npc_op    ,
    output wire         is_br_jmp ,
    output wire [ 2: 0] ext_op    ,
    output wire         r2_sel    ,
    output wire         rR1_re    ,
    output wire         rR2_re    ,
    output wire         alua_sel  ,
    output wire         alub_sel  ,
    output wire [ 4: 0] alu_op    ,
    output wire [ 2: 0] ram_ext_op,
    output wire [ 3: 0] ram_we    ,
    output wire         rf_we     ,
    output wire         wr_sel    ,
    output wire [ 1: 0] wd_sel    
);

    wire ADD_W     = (inst_31_15[31:15] == 17'h00020);
    wire PCADDU12I = (inst_31_15[31:25] == 7'h0E    );
    wire LD_H      = (inst_31_15[31:22] == 10'h0A1  );

    wire TYPE_3R    = ADD_W;
    wire LOAD       = LD_H;
    wire STORE      = 1'b0;

    wire NPC_OP_PC4  = TYPE_3R | PCADDU12I | LOAD | STORE;

    wire EXT_OP_12  = LOAD | STORE;
    wire EXT_OP_20  = PCADDU12I;

    wire ALU_OP_ADD  = ADD_W | PCADDU12I | LOAD | STORE;

    wire WD_SEL_ALU = TYPE_3R | PCADDU12I;
    wire WD_SEL_RAM = LOAD | STORE;

    assign npc_op = {2{NPC_OP_PC4 }} & `NPC_PC4; 

    assign is_br_jmp = 1'b0;

    assign ext_op = {3{EXT_OP_12 }} & `EXT_12  |
                    {3{EXT_OP_20 }} & `EXT_20  ;

    assign r2_sel = STORE ? `R2_RD : `R2_RK;

    assign rR1_re = !PCADDU12I;

    assign rR2_re = TYPE_3R | STORE;

    assign alua_sel = PCADDU12I ? `ALUA_PC : `ALUA_R1;

    assign alub_sel = (PCADDU12I | LOAD | STORE) ? `ALUB_EXT : `ALUB_R2;

    assign alu_op = {5{ALU_OP_ADD}} & `ALU_ADD;
    
    assign ram_ext_op = {3{LD_H}} & `RAM_EXT_H;

    assign ram_we = {4{1'b0}} & `RAM_WE_N;

    assign rf_we = NPC_OP_PC4 & !STORE;

    assign wr_sel = `WR_RD;

    assign wd_sel = {2{WD_SEL_ALU}} & `WD_ALU |
                    {2{WD_SEL_RAM}} & `WD_RAM ;

endmodule
