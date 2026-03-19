`ifndef UTILS_SVH
`define UTILS_SVH

`define ITyp_3R  3'b001     // src1 + src2 + dst
`define ITyp_2R0 3'b010     // src1        + dst
`define ITyp_2R1 3'b011     // src1 + src2
`define ITyp_1R  3'b100     //               dst
`define ITyp_Nil 3'b000

`define READ_SRAM(addr) \
    {sram_uh.mem_array1[addr[21:2]], \
     sram_uh.mem_array0[addr[21:2]], \
     sram_lh.mem_array1[addr[21:2]], \
     sram_lh.mem_array0[addr[21:2]]}

// `define FM_DEBUG
`define FORCE_MODIFY(target, condition, value) \
    initial forever begin \
        `ifdef FM_DEBUG $timeformat(-9, 3, " ns", 12); `endif \
        wait(condition); \
        force target = value; \
        `ifdef FM_DEBUG $display("[%t] %s forced", $realtime, `"target`"); `endif \
        wait(!(condition)); \
        release target; \
        `ifdef FM_DEBUG $display("[%t] %s released", $realtime, `"target`"); `endif \
    end

function automatic logic [2:0] inst_type(
    input  logic [31:0] inst_code
);

    logic LU12I_W   = (inst_code[31:25] == 7'h0A)    ;
    logic ADD_W     = (inst_code[31:15] == 17'h00020);
    logic ADDI_W    = (inst_code[31:22] == 10'h00A)  ;
    logic SUB_W     = (inst_code[31:15] == 17'h00022);
    logic SLT       = (inst_code[31:15] == 17'h00024);
    logic SLTU      = (inst_code[31:15] == 17'h00025);
    logic AND       = (inst_code[31:15] == 17'h00029);
    logic OR        = (inst_code[31:15] == 17'h0002A);
    logic XOR       = (inst_code[31:15] == 17'h0002B);
    logic NOR       = (inst_code[31:15] == 17'h00028);
    logic SLLI_W    = (inst_code[31:15] == 17'h00081);
    logic SRLI_W    = (inst_code[31:15] == 17'h00089);
    logic SRAI_W    = (inst_code[31:15] == 17'h00091);
    logic LD_W      = (inst_code[31:22] == 10'h0A2)  ;
    logic ST_W      = (inst_code[31:22] == 10'h0A6)  ;
    logic BEQ       = (inst_code[31:26] == 6'h16)    ;
    logic BNE       = (inst_code[31:26] == 6'h17)    ;
    logic BL        = (inst_code[31:26] == 6'h15)    ;
    logic JIRL      = (inst_code[31:26] == 6'h13)    ;
    // logic B         = (inst_code[31:26] == 6'h14)    ;
    logic PCADDU12I = (inst_code[31:25] == 7'h0E)    ;
    logic SLTI      = (inst_code[31:22] == 10'h008)  ;
    logic SLTUI     = (inst_code[31:22] == 10'h009)  ;
    logic ANDI      = (inst_code[31:22] == 10'h00D)  ;
    logic ORI       = (inst_code[31:22] == 10'h00E)  ;
    logic XORI      = (inst_code[31:22] == 10'h00F)  ;
    logic SLL_W     = (inst_code[31:15] == 17'h0002E);
    logic SRA_W     = (inst_code[31:15] == 17'h00030);
    logic SRL_W     = (inst_code[31:15] == 17'h0002F);
    logic DIV_W     = (inst_code[31:15] == 17'h00040);
    logic DIV_WU    = (inst_code[31:15] == 17'h00042);
    logic MUL_W     = (inst_code[31:15] == 17'h00038);
    logic MULH_W    = (inst_code[31:15] == 17'h00039);
    logic MULH_WU   = (inst_code[31:15] == 17'h0003A);
    logic MOD_W     = (inst_code[31:15] == 17'h00041);
    logic MOD_WU    = (inst_code[31:15] == 17'h00043);
    logic BLT       = (inst_code[31:26] == 6'h18)    ;
    logic BGE       = (inst_code[31:26] == 6'h19)    ;
    logic BLTU      = (inst_code[31:26] == 6'h1A)    ;
    logic BGEU      = (inst_code[31:26] == 6'h1B)    ;
    logic LD_B      = (inst_code[31:22] == 10'h0A0)  ;
    logic LD_H      = (inst_code[31:22] == 10'h0A1)  ;
    logic LD_BU     = (inst_code[31:22] == 10'h0A8)  ;
    logic LD_HU     = (inst_code[31:22] == 10'h0A9)  ;
    logic ST_B      = (inst_code[31:22] == 10'h0A4)  ;
    logic ST_H      = (inst_code[31:22] == 10'h0A5)  ;

    logic type_3R  = ADD_W | SUB_W | SLT | SLTU | AND | OR | XOR | NOR | SLL_W | SRA_W |
                     SRL_W | DIV_W | DIV_WU | MUL_W | MULH_W | MULH_WU | MOD_W | MOD_WU;
    logic type_2R0 = ADDI_W | SLLI_W | SRLI_W | SRAI_W | LD_W | JIRL | SLTI | SLTUI |
                     ANDI | ORI | XORI | LD_B | LD_H | LD_BU | LD_HU;
    logic type_2R1 = ST_W | BEQ | BNE | BLT | BGE | BLTU | BGEU | ST_B | ST_H;
    logic type_1R  = LU12I_W | BL | PCADDU12I;
    logic type_Nil = !type_3R & !type_2R0 & !type_2R1 & !type_1R;

    return {3{type_3R }} & `ITyp_3R  |
           {3{type_2R0}} & `ITyp_2R0 |
           {3{type_2R1}} & `ITyp_2R1 |
           {3{type_1R }} & `ITyp_1R  |
           {3{type_Nil}} & `ITyp_Nil;

endfunction

function automatic logic [1:0] data_hazard_detect(
    input  logic [31:0] id_icode,
    input  logic [ 2:0] id_ityp,
    input  logic [31:0] ya_icode,
    input  logic [ 2:0] ya_ityp
);

    logic id_rs1_valid = (id_ityp == `ITyp_3R) | (id_ityp == `ITyp_2R0) | (id_ityp == `ITyp_2R1);
    logic [4:0] id_rs1 = {5{id_rs1_valid}} & id_icode[9:5];
    logic [4:0] id_rs2 = {5{(id_ityp == `ITyp_3R)}} & id_icode[14:10] |
                         {5{(id_ityp == `ITyp_2R1)}} & id_icode[4:0];

    logic ya_is_BL    = (ya_icode[31:26] == 6'h15) ? 1'b1 : 1'b0;
    logic [4:0] ya_rd = ya_is_BL ? 5'h1 : ya_icode[4:0];
    logic ya_rd_valid = (ya_ityp != `ITyp_2R1) & (ya_ityp != `ITyp_Nil) & (ya_rd != 5'h0) | ya_is_BL;

    logic id_rs1_flag = ya_rd_valid & (ya_rd == id_rs1);    // id_rs1 exists data hazard or not
    logic id_rs2_flag = ya_rd_valid & (ya_rd == id_rs2);    // id_rs2 exists data hazard or not

    return {id_rs2_flag, id_rs1_flag};

endfunction

`endif
