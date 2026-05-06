`ifndef MYCPU_H
    `define MYCPU_H

//    `define BR_BUS_WD       33  //bug5 32->33
//    `define FS_TO_DS_BUS_WD 109
//    `define DS_TO_ES_BUS_WD 236
//    `define ES_TO_MS_BUS_WD 215
//    `define MS_TO_WS_BUS_WD 218
//    `define WS_TO_RF_BUS_WD 38
//    `define ES_TO_DS_FORWARD_BUS 39
//    `define MS_TO_DS_FORWARD_BUS 39

    // `define HAS_LACC
    `define LACC_OP_SIZE 3
    `define LACC_OP_WIDTH $clog2(`LACC_OP_SIZE)
    `define BR_BUS_WD       33  //bug5 32->33
    `define FS_TO_DS_BUS_WD 109
    `define DS_TO_ES_BUS_WD (350 \
    `ifdef HAS_LACC \
    +`LACC_OP_WIDTH+1 \
    `endif \
    )

    `define ES_TO_MS_BUS_WD 425

    `define MS_TO_WS_BUS_WD 493
    `define WS_TO_RF_BUS_WD 38
    `define ES_TO_DS_FORWARD_BUS 39
    `define MS_TO_DS_FORWARD_BUS 39
`endif

//`define SIMU
