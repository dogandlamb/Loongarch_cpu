`timescale 1ns / 1ps

module mycpu_top(
    input  wire        cpu_rstn,
    input  wire        cpu_clk,
    input  wire        sram_uclk,

    // BUS Interface 0 (SRAM)
    output wire        sram_bus_en   ,
    output wire [31:0] sram_bus_addr ,
    output wire [ 3:0] sram_bus_we   ,
    output wire [31:0] sram_bus_wdata,
    input  wire [31:0] sram_bus_rdata,
    
    // BUS Interface 1 (Peripheral)
    output wire        peri_bus_en   ,
    output wire [31:0] peri_bus_addr ,
    output wire [ 3:0] peri_bus_we   ,
    output wire [31:0] peri_bus_wdata,
    input  wire [31:0] peri_bus_rdata
);

    // ICache Interface
    wire        cpu2ic_rreq  ;
    wire [31:0] cpu2ic_addr  ;
    wire        ic2cpu_valid ;
    wire [31:0] ic2cpu_inst  ;
    wire        cpu2ic_pderr ;

    wire        dev2ic_rrdy  ;
    wire [ 3:0] ic2dev_ren   ;
    wire [31:0] ic2dev_raddr ;
    wire        dev2ic_rvalid;
    wire [31:0] dev2ic_rdata ;

    // DCache Interface
    wire [ 3:0] cpu2dc_ren   ;
    wire [31:0] cpu2dc_addr  ;
    wire        dc2cpu_valid ;
    wire [31:0] dc2cpu_rdata ;
    wire [ 3:0] cpu2dc_wen   ;
    wire [31:0] cpu2dc_wdata ;
    wire        dc2cpu_wresp ;

    wire        dev2dc_wrdy  ;
    wire [ 3:0] dc2dev_wen   ;
    wire [31:0] dc2dev_waddr ;
    wire [31:0] dc2dev_wdata ;
    wire        dev2dc_rrdy  ;
    wire [ 3:0] dc2dev_ren   ;
    wire [31:0] dc2dev_raddr ;
    wire        dev2dc_rvalid;
    wire [31:0] dev2dc_rdata ;
    
    myCPU u_mycpu (
        .cpu_rstn       (cpu_rstn    ),
        .cpu_clk        (cpu_clk     ),
        // Instruction Fetch Interface
        .ifetch_rreq    (cpu2ic_rreq ),
        .ifetch_addr    (cpu2ic_addr ),
        .ifetch_valid   (ic2cpu_valid),
        .ifetch_inst    (ic2cpu_inst ),
        .pred_error     (cpu2ic_pderr),
        // Data Access Interface
        .daccess_ren    (cpu2dc_ren  ),
        .daccess_addr   (cpu2dc_addr ),
        .daccess_valid  (dc2cpu_valid),
        .daccess_rdata  (dc2cpu_rdata),
        .daccess_wen    (cpu2dc_wen  ),
        .daccess_wdata  (cpu2dc_wdata),
        .daccess_wresp  (dc2cpu_wresp)
    );

    ICache u_icache (
        .cpu_rstn       (cpu_rstn     ),
        .cpu_clk        (cpu_clk      ),
        // Interface to CPU
        .inst_rreq      (cpu2ic_rreq  ),
        .inst_addr      (cpu2ic_addr  ),
        .inst_valid     (ic2cpu_valid ),
        .inst_out       (ic2cpu_inst  ),
        .pred_error     (cpu2ic_pderr ),
        // Interface to Bus
        .dev_rrdy       (dev2ic_rrdy  ),
        .cpu_ren        (ic2dev_ren   ),
        .cpu_raddr      (ic2dev_raddr ),
        .dev_rvalid     (dev2ic_rvalid),
        .dev_rdata      (dev2ic_rdata )
    );

    DCache u_dcache (
        .cpu_rstn       (cpu_rstn     ),
        .cpu_clk        (cpu_clk      ),
        // Interface to CPU
        .data_ren       (cpu2dc_ren   ),
        .data_addr      (cpu2dc_addr  ),
        .data_valid     (dc2cpu_valid ),
        .data_rdata     (dc2cpu_rdata ),
        .data_wen       (cpu2dc_wen   ),
        .data_wdata     (cpu2dc_wdata ),
        .data_wresp     (dc2cpu_wresp ),
        // Interface to Bus
        .dev_wrdy       (dev2dc_wrdy  ),
        .cpu_wen        (dc2dev_wen   ),
        .cpu_waddr      (dc2dev_waddr ),
        .cpu_wdata      (dc2dev_wdata ),
        .dev_rrdy       (dev2dc_rrdy  ),
        .cpu_ren        (dc2dev_ren   ),
        .cpu_raddr      (dc2dev_raddr ),
        .dev_rvalid     (dev2dc_rvalid),
        .dev_rdata      (dev2dc_rdata )
    );

    sram_bus_master u_sram_bus (
        .cpu_rstn       (cpu_rstn      ),
        .cpu_clk        (cpu_clk       ),
        .sram_uclk      (sram_uclk     ),
        // ICache Interface
        .ic_dev_rrdy    (dev2ic_rrdy   ),
        .ic_cpu_ren     (|ic2dev_ren   ),
        .ic_cpu_raddr   (ic2dev_raddr  ),
        .ic_dev_rvalid  (dev2ic_rvalid ),
        .ic_dev_rdata   (dev2ic_rdata  ),
        // DCache Interface
        .dc_dev_wrdy    (dev2dc_wrdy   ),
        .dc_cpu_wen     (dc2dev_wen    ),
        .dc_cpu_waddr   (dc2dev_waddr  ),
        .dc_cpu_wdata   (dc2dev_wdata  ),
        .dc_dev_rrdy    (dev2dc_rrdy   ),
        .dc_cpu_ren     (|dc2dev_ren   ),
        .dc_cpu_raddr   (dc2dev_raddr  ),
        .dc_dev_rvalid  (dev2dc_rvalid ),
        .dc_dev_rdata   (dev2dc_rdata  ),
        // SRAM-BUS Interface 0 (SRAM)
        .bus_en0        (sram_bus_en   ),
        .bus_addr0      (sram_bus_addr ),
        .bus_we0        (sram_bus_we   ),
        .bus_wdata0     (sram_bus_wdata),
        .bus_rdata0     (sram_bus_rdata),
        // SRAM-BUS Interface 1 (Peripheral)
        .bus_en1        (peri_bus_en   ),
        .bus_addr1      (peri_bus_addr ),
        .bus_we1        (peri_bus_we   ),
        .bus_wdata1     (peri_bus_wdata),
        .bus_rdata1     (peri_bus_rdata)
    );

endmodule
