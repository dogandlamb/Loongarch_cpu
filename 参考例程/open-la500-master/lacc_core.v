`include "mycpu.h" 
`include "csr.h"

`ifdef HAS_LACC
module lacc_core(
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

    // wreq will also send valid sign
    output                      lacc_data_valid,
    input                       lacc_data_ready,
    output [31: 0]              lacc_data_addr,
    output                      lacc_data_read,
    output [31: 0]              lacc_data_wdata,
    output [1: 0]               lacc_data_size,

    input                       lacc_drsp_valid,
    input [31: 0]               lacc_drsp_rdata
);

    lacc_demo demo(
        .clk(clk),
        .reset(reset),
        .lacc_flush     (lacc_flush),
        .lacc_req_valid (lacc_req_valid),
        .lacc_req_command(lacc_req_command),
        .lacc_req_imm   (lacc_req_imm),
        .lacc_req_rj    (lacc_req_rj),
        .lacc_req_rk    (lacc_req_rk),
        .lacc_rsp_valid (lacc_rsp_valid),
        .lacc_rsp_rdat  (lacc_rsp_rdat),
        .lacc_data_valid(lacc_data_valid),
        .lacc_data_ready(lacc_data_ready),
        .lacc_data_addr (lacc_data_addr),
        .lacc_data_read (lacc_data_read),
        .lacc_data_wdata(lacc_data_wdata),
        .lacc_data_size (lacc_data_size),
        .lacc_drsp_valid(lacc_drsp_valid),
        .lacc_drsp_rdata(lacc_drsp_rdata)
    );
endmodule
`endif