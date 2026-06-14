

module lacc_demo(
    input                       clk,
    input                       reset,

    input                       lacc_flush,

    input                       lacc_req_valid,
    input [`LACC_OP_WIDTH-1: 0] lacc_req_command,
    input [6: 0]                lacc_req_imm,
    input [31: 0]               lacc_req_rj,
    input [31: 0]               lacc_req_rk,

    output                      lacc_rsp_valid,
    output [31: 0]              lacc_rsp_rdat,

    output                      lacc_data_valid,
    input                       lacc_data_ready,
    output [31: 0]              lacc_data_addr,
    output                      lacc_data_read,
    output [31: 0]              lacc_data_wdata,
    output [1: 0]               lacc_data_size,

    input                       lacc_drsp_valid,
    input [31: 0]               lacc_drsp_rdata
);

    wire op_lmadd;
    wire op_cfg;

    reg [31: 0] req_addr1, req_addr2, waddr;
    reg [6: 0] req_size;
    wire [31: 0] nxt_req_addr1, nxt_req_addr2, req_addr1_n4, req_addr2_n4;
    wire [31: 0] nxt_waddr, waddr_n4;
    wire [6: 0] nxt_req_size, req_size_p1;
    wire req_addr1_en, req_addr2_en, req_size_en, waddr_en;
    wire req_size_nz = |req_size;

    reg [31: 0] conv_data;
    wire [31: 0] add_data;
    /*********************************
    * func:
    * rj and rk are addr
    * read from rj and rk and add them
    * write back to waddr
    * then write add res to rd
    **********************************/
    assign op_lmadd     = lacc_req_command == 0;
    // rj is size of read, rk is waddr
    assign op_cfg       = lacc_req_command == 1;


    parameter FSM_WIDTH    = 2;
    parameter IDLE          = 'b0;
    parameter REQ_ADDR1     = 'b1;
    parameter REQ_ADDR2     = 'd2;
    parameter FINAL         = 'd3;
    reg  [FSM_WIDTH-1: 0]   state_r;
    wire [FSM_WIDTH-1: 0]   state_n;
    wire [FSM_WIDTH-1: 0]   state_final_n;
    wire state_idle         = state_r == IDLE;
    wire state_req_addr1    = state_r == REQ_ADDR1;
    wire state_req_addr2    = state_r == REQ_ADDR2;
    wire state_final        = state_r == FINAL;
    wire data_hsk       = lacc_data_valid & lacc_data_ready;
    wire idle_exit      = state_idle & lacc_req_valid & op_lmadd & req_size_nz;
    wire req_addr1_exit = state_req_addr1 & data_hsk;
    wire req_addr2_exit = state_req_addr2 & data_hsk;
    wire final_exit     = state_final & data_hsk;
    wire exit2idle      = final_exit & ~req_size_nz;

    assign state_final_n = ~req_size_nz ? IDLE : REQ_ADDR1;

    wire state_en       = idle_exit | req_addr1_exit | req_addr2_exit | final_exit;
    assign state_n      = {FSM_WIDTH{idle_exit}} & REQ_ADDR1 |
                          {FSM_WIDTH{req_addr1_exit}} & REQ_ADDR2 |
                          {FSM_WIDTH{req_addr2_exit}} & FINAL |
                          {FSM_WIDTH{final_exit}} & state_final_n;



    assign req_addr1_en = state_idle & lacc_req_valid & op_lmadd | req_addr1_exit;
    assign req_addr2_en = state_idle & lacc_req_valid & op_lmadd | req_addr2_exit;
    assign req_size_en  = lacc_req_valid & op_cfg | req_addr2_exit;
    assign waddr_en     = lacc_req_valid & op_cfg | final_exit;
    assign req_addr1_n4 = req_addr1 + 4;
    assign req_addr2_n4 = req_addr2 + 4;
    assign req_size_p1  = req_size - 1;
    assign waddr_n4     = waddr + 4;
    assign nxt_req_addr1  = {32{lacc_req_valid & state_idle & op_lmadd}} & lacc_req_rj |
                            {32{req_addr1_exit}} & req_addr1_n4;
    assign nxt_req_addr2  = {32{lacc_req_valid & state_idle & op_lmadd}} & lacc_req_rk |
                            {32{req_addr2_exit}} & req_addr2_n4;
    assign nxt_req_size   = {7{lacc_req_valid & op_cfg}} & lacc_req_rj |
                            {7{req_addr2_exit}} & req_size_p1;
    assign nxt_waddr      = {32{lacc_req_valid & op_cfg}} & lacc_req_rk |
                            {32{final_exit}} & waddr_n4;

    reg data_req;
    wire data_req_en;
    wire nxt_data_req;

    assign data_req_en = idle_exit | req_addr1_exit | req_addr2_exit | final_exit;
    assign nxt_data_req = ~exit2idle & ~req_addr2_exit;

    reg buffer_valid, wdata_valid, wdata_valid_n;
    reg [31: 0] buffer_data;
    reg [31: 0] buffer_wdata;

    always @(posedge clk)begin
        if(req_addr1_en) req_addr1 <= nxt_req_addr1;
        if(req_addr2_en) req_addr2 <= nxt_req_addr2;
        if(waddr_en) waddr <= nxt_waddr;
        if(~buffer_valid) buffer_data <= lacc_drsp_rdata;
        if(buffer_valid & lacc_drsp_valid) begin
            buffer_wdata <= lacc_drsp_rdata + buffer_data;
        end
        wdata_valid_n <= wdata_valid;
        if(reset | lacc_flush)begin
            req_size <= 7'b0;
            state_r  <= IDLE;
            data_req <= 1'b0;
            buffer_valid <= 1'b0;
            wdata_valid <= 1'b0;
        end
        else begin
            if(req_size_en) req_size <= nxt_req_size;
            if(state_en) state_r <= state_n;
            if(data_req_en) data_req <= nxt_data_req;

            if(final_exit) buffer_valid <= 1'b0;
            else if(lacc_drsp_valid & ~wdata_valid_n) buffer_valid <= 1'b1;

            if(final_exit) wdata_valid <= 1'b0;
            else if(buffer_valid & lacc_drsp_valid) wdata_valid <= 1'b1;
        end
    end

    assign lacc_data_valid  = data_req | wdata_valid;
    assign lacc_data_read   = ~wdata_valid;
    assign lacc_data_addr   = {32{state_req_addr1}} & req_addr1 |
                              {32{state_req_addr2}} & req_addr2 |
                              {32{state_final}}     & waddr;
    assign lacc_data_size   = 2'b10;
    assign lacc_data_wdata  = buffer_wdata;


    assign add_data = conv_data + lacc_drsp_rdata;

    always @(posedge clk)begin
        if(idle_exit)begin
            conv_data <= 0;
        end
        else begin
            if(lacc_drsp_valid)begin
                conv_data <= add_data;
            end
        end
    end

    assign lacc_rsp_valid = exit2idle | lacc_req_valid & state_idle & ((op_lmadd & ~req_size_nz) | op_cfg);
    assign lacc_rsp_rdat  = conv_data;


endmodule