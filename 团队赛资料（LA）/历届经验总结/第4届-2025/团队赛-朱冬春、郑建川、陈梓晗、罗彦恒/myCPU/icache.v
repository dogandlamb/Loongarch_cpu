`timescale 1ns / 1ps
`include "defines.vh"

module icache
(
    input  wire         clk,
    input  wire         rst,       // low active
    input  wire         flush,
    // Interface to CPU
    input  wire         inst_rreq,  
    input  wire         not_same_page,  
    input  wire         iuncache_en,  
    input  wire [31:0]  inst_addr1,      
    input  wire [31:0]  inst_addr2,
    input  wire [31:0]  paddr,
    input  wire [31:0]  if_pred_addr1,
    input  wire [31:0]  if_pred_addr2,
    input  wire [1:0]   BPU_pred_taken,

    input wire          icacop_en,
    input wire [1:0]    cacop_mode,
    input wire [31:0]   cache_cacop_vaddr,

    input  wire         pi_is_exception,
    input  wire [6:0]   pi_exception_cause, 

    input  wire         inst_addr_trans_en,
    input  wire         inst_tlb_found,
    input  wire         inst_tlb_v,
    input  wire [1:0]   inst_tlb_plv,
    input  wire [1:0]   csr_plv, 

    output wire [31:0]  pred_addr1,
    output wire [31:0]  pred_addr2,
    output wire [1:0]   pred_taken,
    output reg          inst_valid1,     
    output reg          inst_valid2,
    output reg          valid_out,
    output reg  [31:0]  inst_out1,       // 
    output reg  [31:0]  inst_out2,
    output reg  [31:0]  pc1,
    output reg  [31:0]  pc2,
    output reg          pc_is_exception_out1,
    output reg          pc_is_exception_out2,
    output reg  [6:0]   pc_exception_cause_out1,
    output reg  [6:0]   pc_exception_cause_out2,
    output wire         pc_suspend,  
    // Interface to Read Bus
    input  wire         dev_rrdy,       
    output reg          cpu_ren,        // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枍閼煎海鎷嬬憴鍕伓濞达絽娼￠弫鎾诲棘閵堝棗顏堕梺璺ㄥ枙閸撳ジ鎮€涙ê顏?
    output reg  [31:0]  cpu_raddr,      // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枍閼煎海鎷嬬憴鍕伓闂佽法鍠愰弸濠氬箯瀹勭増绲?
    input  wire         dev_rvalid,     // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁哄倶鍊栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲矗椤愬骸绉电€氬綊鎸婇弴銏℃櫢闁跨噦鎷??
    input  wire [255:0] dev_rdata,   // 闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏跺ù婧炬櫊閺佹捇寮妶鍡楊伓闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柨鐕傛嫹?  128
    input  wire         ren_received,
    input  wire         flush_flag_valid,

    input wire uncache_rvalid,
    input wire [63:0] uncache_rdata,
    output wire uncache_ren,
    output wire [31:0] uncache_raddr
);
    
    localparam IDLE = 3'b000;
    localparam DEALING1 = 3'b001;
    localparam DEALING2 = 3'b010;
    localparam REFILL = 3'b011;
    localparam UNCACHE = 3'b100;
    reg [2:0] state;
    reg [2:0] next_state;

    wire [31:0] vaddr_1_1 = inst_addr1;
    wire [31:0] vaddr_2_1 = inst_addr2;
    wire [6:0]  index_1_1 = vaddr_1_1[11:5];
    wire [6:0]  index_2_1 = vaddr_2_1[11:5];
    wire [20:0] tag_1_1 = {1'b1,vaddr_1_1[31:12]};
    wire [20:0] tag_2_1 = {1'b1,vaddr_2_1[31:12]};
    wire [2:0] offset1_1 = vaddr_1_1[4:2];
    wire [2:0] offset2_1 = vaddr_2_1[4:2];

    wire [6:0] cacop_index_1 = cache_cacop_vaddr[11:5];

    wire [31:0] paddr_1_2 = paddr;
    wire [31:0] paddr_2_2 = paddr + 4;
    reg [31:0] pc1_2;
    reg [31:0] pc2_2;

    reg [2:0] offset1_2;
    reg [2:0] offset2_2;
    wire [20:0] tag_1_2 = {1'b1,paddr_1_2[31:12]};
    wire [20:0] tag_2_2 = {1'b1,paddr_2_2[31:12]};
    reg req1_2;
    reg req2_2;
    reg uncache_2;
    reg pi_is_exception_2;
    reg [6:0] pi_exception_cause_2;

    reg [31:0] pred_addr1_2;
    reg [31:0] pred_addr2_2;
    reg [1:0]  pred_taken_2;   

    wire [255:0] ram1_data_block1;
    wire [255:0] ram1_data_block2;
    wire [255:0] ram2_data_block1;
    wire [255:0] ram2_data_block2;

    wire [20:0] ram1_tag_block1;
    wire [20:0] ram1_tag_block2;
    wire [20:0] ram2_tag_block1;
    wire [20:0] ram2_tag_block2;

    reg use_bit [127:0];

    wire [20:0] refill_tag = state == DEALING1 ? {1'b1,paddr_1_2[31:12]} :  {1'b1,paddr_2_2[31:12]};


    wire [6:0] index1 = pc_suspend ? paddr_1_2[11:5] : index_1_1;
    wire [6:0] index2 = pc_suspend ? paddr_2_2[11:5] : index_2_1;
    reg [6:0] index1_delay;
    reg [6:0] index2_delay;

    wire [255:0] refill_data = dev_rdata;

    //闂佽法鍠愰弸濠氬箯閾氬倻顏遍梺璺ㄥ枑閺嬪鏁撻敓锟??1闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氱畞am1闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柤鍝勫€介鎰板箯閻戣姤鏅搁柡鍌樺€栫€氾拷1闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氱ndex1
    wire hit_ram1_index1 = (tag_1_2==ram1_tag_block1);  
    wire hit_ram2_index1 = (tag_1_2==ram2_tag_block1);
    wire hit_index1 = hit_ram1_index1 | hit_ram2_index1;    //index1
    wire hit_ram1_index2 = (tag_2_2==ram1_tag_block2);
    wire hit_ram2_index2 = (tag_2_2==ram2_tag_block2);
    wire hit_index2 = hit_ram1_index2 | hit_ram2_index2;    //index2

    wire [255:0] hit1_data = {256{hit_ram1_index1}}&ram1_data_block1 | {256{hit_ram2_index1}}&ram2_data_block1;
    wire [255:0] hit2_data = {256{hit_ram1_index2}}&ram1_data_block2 | {256{hit_ram2_index2}}&ram2_data_block2;
    
    wire we_ram1_index1 = dev_rvalid & (!use_bit[index1]) & state == DEALING1 & !flush_flag;
    wire we_ram1_index2 = dev_rvalid & (!use_bit[index2]) & state == DEALING2 & !flush_flag;
    wire we_ram2_index1 = dev_rvalid & (use_bit[index1] ) & state == DEALING1 & !flush_flag;
    wire we_ram2_index2 = dev_rvalid & (use_bit[index2] ) & state == DEALING2 & !flush_flag;

    assign pc_suspend = next_state != IDLE | state == REFILL | state == UNCACHE;
    integer i;
    reg flush_flag;

    wire excp_tlbr = !inst_tlb_found & inst_addr_trans_en;
    wire excp_pif  = !inst_tlb_v & inst_addr_trans_en;
    wire excp_ppi  = (csr_plv > inst_tlb_plv) & inst_addr_trans_en;
    wire tlb_excp = (!inst_tlb_found | !inst_tlb_v | (csr_plv > inst_tlb_plv)) & inst_addr_trans_en;

    always @(posedge clk)
    begin
        if(rst | flush) state <= IDLE;
        else state <= next_state;
    end

    always @(*)
    begin
        case(state)
        IDLE:begin
            if(uncache_2) next_state = UNCACHE;
            else if(!hit_index1 & req1_2) next_state = DEALING1;
            else if(!hit_index2 & req2_2) next_state = DEALING2;
            else next_state = IDLE;
        end
        DEALING1:begin
            if(dev_rvalid & (index1 == index2 | hit_index2 | !req2_2) & !flush_flag) next_state = REFILL;
            else if(dev_rvalid & !flush_flag) next_state = DEALING2;
            else next_state = DEALING1; 
        end
        DEALING2:begin
            if(dev_rvalid & !flush_flag) next_state = REFILL;
            else next_state = DEALING2;
        end
        REFILL:begin
            next_state = IDLE;
        end
        UNCACHE:begin
            if(uncache_rvalid & !flush_flag) next_state = IDLE;
            else next_state = UNCACHE;
        end
        endcase
    end
        always @(posedge clk)
        begin
            if(rst | flush)
            begin
            req1_2 <= 1'b0;
            req2_2 <= 1'b0;
            uncache_2 <= 1'b0;
            offset1_2 <= 2'b0;
            offset2_2 <= 2'b0;
            pred_addr1_2 <= 32'b0;
            pred_addr2_2 <= 32'b0;
            pred_taken_2 <= 2'b0;

            pc1_2 <= 32'b0;
            pc2_2 <= 32'b0;

            pi_is_exception_2 <= 1'b0;
            pi_exception_cause_2 <= 7'b0;
            cpu_ren <= 1'b0;
            cpu_raddr <= 32'b0;
            if(flush)
            begin
                case(state)
                IDLE:begin
                    if(dev_rvalid | uncache_rvalid) flush_flag <= 1'b0;
                end
                DEALING1:begin
                    if(!dev_rvalid & flush_flag_valid)
                    begin
                        flush_flag <= 1'b1;     //flush闂佽法鍠愰弸濠氬箯閻戣姤鏅搁柡鍌樺€栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁哄倶鍊栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏堕梺璺ㄥ枑閺嬪骞忛悜鑺ユ櫢闁哄倶鍊栫€氬綊鏌ㄩ悢鍛婄伄闁归鍏橀弫鎾诲棘閵堝棗顏跺☉鎿冩緛閹风兘鏌ㄩ悢鍛婄伄闁归饪瞖v_rvalid
                    end
                end
                DEALING2:begin
                    if(!dev_rvalid & flush_flag_valid)
                    begin
                        flush_flag <= 1'b1;
                    end
                end
                UNCACHE:begin
                    if(!uncache_rvalid & flush_flag_valid)
                    begin
                        flush_flag <= 1'b1;
                    end
                end
                default:;
                endcase
            end
            if(rst)
            begin
                flush_flag <= 1'b0;
                for(i=0;i<128;i=i+1)
                begin
                    use_bit[i] <= 1'b0;
                end
            end
            end
            else
            begin
                case(state)
                IDLE,REFILL:begin
                    if(dev_rvalid | uncache_rvalid) flush_flag <= 1'b0;
                    if(next_state == IDLE & state != REFILL)
                    begin
                    req1_2 <= inst_rreq;
                    req2_2 <= inst_rreq & (if_pred_addr1 == inst_addr2) & !not_same_page;
                    uncache_2 <= iuncache_en & inst_rreq;

                    pc1_2 <= vaddr_1_1;
                    pc2_2 <= vaddr_2_1;

                    offset1_2 <= offset1_1;
                    offset2_2 <= offset2_1;

                    pred_addr1_2 <= if_pred_addr1;  
                    pred_addr2_2 <= if_pred_addr2;
                    pred_taken_2 <= BPU_pred_taken;

                    pi_is_exception_2 <= pi_is_exception;
                    pi_exception_cause_2 <= pi_exception_cause;
                    end
                    else if(next_state == DEALING1)
                    begin
                        cpu_ren <= 1'b1;
                        cpu_raddr <= {paddr_1_2[31:5],5'b0};
                    end
                    else if(next_state == DEALING2)
                    begin
                        cpu_ren <= 1'b1;
                        cpu_raddr <= {paddr_2_2[31:5],5'b0};
                    end
                    if(hit_ram1_index1) use_bit[index1_delay] <= 1'b1;
                    else if(hit_ram2_index1) use_bit[index1_delay] <= 1'b0;
                    if(index1_delay != index2_delay)
                    begin
                        if(hit_ram1_index2) use_bit[index2_delay] <= 1'b1;
                        else if(hit_ram2_index2) use_bit[index2_delay] <= 1'b0;
                    end
                end
                DEALING1:begin
                    if(dev_rvalid | uncache_rvalid) flush_flag <= 1'b0;
                    if(ren_received)
                    begin
                        cpu_ren <= 1'b0;
                    end
                    else if(next_state == DEALING2)
                    begin
                        cpu_ren <= 1'b1;
                        cpu_raddr <= {paddr_2_2[31:5],5'b0};
                    end
                end
                DEALING2:begin
                    if(dev_rvalid | uncache_rvalid) flush_flag <= 1'b0;
                    if(ren_received)
                    begin
                        cpu_ren <= 1'b0;
                    end
                end
                UNCACHE:begin
                    if(uncache_rvalid)
                    begin
                        flush_flag <= 1'b0;
                        if(!flush_flag)
                        begin
                            uncache_2 <= 1'b0;
                            req1_2 <= 1'b0;
                            req2_2 <= 1'b0;
                        end
                    end
                end
                endcase
            end
        end

    always @(posedge clk)
    begin
        if(rst | flush)
        begin
            index1_delay <= 7'b0;
            index2_delay <= 7'b0;
        end
        else
        begin
            index1_delay <= index1;
            index2_delay <= index2;
        end
    end
    
    assign pred_addr1 = pred_addr1_2;
    assign pred_addr2 = pred_addr2_2;

    assign pred_taken = pred_taken_2;

    always @(*)
    begin
        inst_valid1 = (hit_index1 | uncache_rvalid) & req1_2;
        inst_valid2 = (hit_index2 | uncache_rvalid) & req2_2;
        valid_out = req1_2 & (hit_index1 & (hit_index2 | !req2_2) & !uncache_2 | (uncache_rvalid & !flush_flag));
        pc1 = pc1_2;
        pc2 = pc2_2;

        pc_is_exception_out1 = pi_is_exception_2 | tlb_excp;
        pc_is_exception_out2 = pi_is_exception_2 | tlb_excp;
        casez({pi_is_exception_2,excp_tlbr,excp_pif,excp_ppi})
        4'b1???:begin
            pc_exception_cause_out1 = pi_exception_cause_2;
            pc_exception_cause_out2 = pi_exception_cause_2;
        end
        4'b01??:begin
            pc_exception_cause_out1 = 7'b1111110;   //EXCEPTION_TLBR 7'b1111110
            pc_exception_cause_out2 = 7'b1111110;
        end
        4'b001?:begin
            pc_exception_cause_out1 = 7'b0000110;  //EXCEPTION_PIF 7'b0000110
            pc_exception_cause_out2 = 7'b0000110;
        end
        4'b0001:begin
            pc_exception_cause_out1 = 7'b0001110;  //EXCEPTION_PPI 7'b0001110 
            pc_exception_cause_out2 = 7'b0001110;
        end
        default:begin
            pc_exception_cause_out1 = pi_exception_cause_2;
            pc_exception_cause_out2 = pi_exception_cause_2;
        end
        endcase

        case(offset1_2)
        3'b000:inst_out1 = uncache_rvalid ? uncache_rdata[31:0] : hit1_data[31:0];
        3'b001:inst_out1 = uncache_rvalid ? uncache_rdata[31:0] : hit1_data[63:32];
        3'b010:inst_out1 = uncache_rvalid ? uncache_rdata[31:0] : hit1_data[95:64];
        3'b011:inst_out1 = uncache_rvalid ? uncache_rdata[31:0] : hit1_data[127:96];  
        3'b100:inst_out1 = uncache_rvalid ? uncache_rdata[31:0] : hit1_data[159:128];
        3'b101:inst_out1 = uncache_rvalid ? uncache_rdata[31:0] : hit1_data[191:160];
        3'b110:inst_out1 = uncache_rvalid ? uncache_rdata[31:0] : hit1_data[223:192];
        3'b111:inst_out1 = uncache_rvalid ? uncache_rdata[31:0] : hit1_data[255:224];
        default:inst_out1 = 32'b0;  
        endcase
        case(offset2_2)
        3'b000:inst_out2 = uncache_rvalid ? uncache_rdata[63:32] : hit2_data[31:0];
        3'b001:inst_out2 = uncache_rvalid ? uncache_rdata[63:32] : hit2_data[63:32];
        3'b010:inst_out2 = uncache_rvalid ? uncache_rdata[63:32] : hit2_data[95:64];
        3'b011:inst_out2 = uncache_rvalid ? uncache_rdata[63:32] : hit2_data[127:96];
        3'b100:inst_out2 = uncache_rvalid ? uncache_rdata[63:32] : hit2_data[159:128];
        3'b101:inst_out2 = uncache_rvalid ? uncache_rdata[63:32] : hit2_data[191:160];
        3'b110:inst_out2 = uncache_rvalid ? uncache_rdata[63:32] : hit2_data[223:192];
        3'b111:inst_out2 = uncache_rvalid ? uncache_rdata[63:32] : hit2_data[255:224];  
        default:inst_out2 = 32'b0;   
        endcase
    end
    /*
    icache_data_ram ram1
    (
        .clk(clk),
        .we1(we_ram1_index1),
        .we2(we_ram1_index2),
        .rst(rst),
        .index1(index1),
        .index2(index2),
        .data_in(refill_data),
        .data_out1(ram1_data_block1),
        .data_out2(ram1_data_block2)
    );

    icache_data_ram ram2
    (
        .clk(clk),
        .we1(we_ram2_index1),
        .we2(we_ram2_index2),
        .index1(index1),
        .index2(index2),
        .rst(rst),
        .data_in(refill_data),
        .data_out1(ram2_data_block1),
        .data_out2(ram2_data_block2)
    );
    */
    icache_tag_ram tag_ram1
    (
        .clk(clk),
        .we1(we_ram1_index1),
        .we2(we_ram1_index2),
        .rst(rst),
        .index1(index1),
        .index2(index2),
        .cacop_index(cacop_index_1),
        .cacop_flush(icacop_en),
        .data_in(refill_tag),
        .data_out1(ram1_tag_block1),
        .data_out2(ram1_tag_block2)
    );

    icache_tag_ram tag_ram2
    (
        .clk(clk),
        .we1(we_ram2_index1),
        .we2(we_ram2_index2),
        .index1(index1),
        .index2(index2),
        .cacop_index(cacop_index_1),
        .cacop_flush(icacop_en),
        .rst(rst),
        .data_in(refill_tag),
        .data_out1(ram2_tag_block1),
        .data_out2(ram2_tag_block2)
    );

    data_bram data_ram1
    (
        .clka(clk),
        .addra(index1),
        .dina(refill_data),
        .douta(ram1_data_block1),
        .wea(we_ram1_index1),

        .clkb(clk),
        .addrb(index2),
        .dinb(refill_data),
        .doutb(ram1_data_block2),
        .web(we_ram1_index2)
    );

    data_bram data_ram2
    (
        .clka(clk),
        .addra(index1),
        .dina(refill_data),
        .douta(ram2_data_block1),
        .wea(we_ram2_index1),

        .clkb(clk),
        .addrb(index2),
        .dinb(refill_data),
        .doutb(ram2_data_block2),
        .web(we_ram2_index2)
    );

    assign uncache_ren = (state == UNCACHE) & dev_rrdy & req1_2 & !uncache_rvalid;
    assign uncache_raddr = paddr_1_2;

/*
    //***************************************************
    reg [31:0] req_count;
    reg [31:0] hit_count;
    reg inst_rreq_delay;

    always @(posedge clk)
    begin
        if(rst)
        begin
            req_count <= 0;
            hit_count <= 0;
            inst_rreq_delay <= 0;
        end
        else
        begin
            inst_rreq_delay <= inst_rreq;
            if(inst_rreq_delay & inst_valid) hit_count <= hit_count + 1;
            if(inst_rreq_delay) req_count <= req_count + 1;
        end
    end
    //***************************************************
    */
    endmodule