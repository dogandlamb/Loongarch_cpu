//*************************************************************************
//   > File Name   : soc_lite_top.v
//   > Description : SoC, include CPU, BUS, SRAM, confreg
//   > Architecture: 
//           ------------------------
//           |         myCPU        |
//           ------------------------
//              |                 | 
//        ------------      ------------
//        |  ICache  |      |  DCache  |
//        ------------      ------------
//              | read            | read/write
//              |                 | 
//        ------------------------------
//        |           SRAM BUS         |
//        ------------------------------
//           | interface0           | interface1
//           |                      | 
//   ----------------------    -------------
//   | SRAM (inst & data) |    |  confreg  |
//   ----------------------    -------------
//
//*************************************************************************

`include "mycpu_inst.vh"
`default_nettype none

//for simulation:
//1. if define SIMU_USE_PLL = 1, will use clk_pll to generate cpu_clk/timer_clk,
//   and simulation will be very slow.
//2. usually, please define SIMU_USE_PLL=0 to speed up simulation by assign
//   cpu_clk/timer_clk = clk.
//   at this time, cpu_clk/timer_clk frequency are both 100MHz, same as clk.
`define SIMU_USE_PLL 0 //set 0 to speed up simulation

module soc_lite_top #(parameter SIMULATION=1'b0)
(
    input  wire        resetn, 
    input  wire        clk,

    //------sram-------
    output wire [19:0]  sram_addr,
    inout  wire [31:0]  sram_data,
    output wire         sram_oen,       // output enable
    output wire         sram_cen,       // chip select
    output wire         sram_wen,       // write enable
    output wire [ 3:0]  sram_ben,       // byte enable

    //------gpio-------
    output wire [15:0] led,
    output wire [1 :0] led_rg0,
    output wire [1 :0] led_rg1,
    output wire [7 :0] num_csn,
    output wire [6 :0] num_a_g,
    output wire [31:0] num_data,
    input  wire [7 :0] switch, 
    output wire [3 :0] btn_key_col,
    input  wire [3 :0] btn_key_row,
    input  wire [1 :0] btn_step
);

    //clk and resetn
    wire cpu_clk;
    wire timer_clk;
    wire sram_uclk, sram_wclk;
    generate
        if (SIMULATION && `SIMU_USE_PLL==0) begin: speedup_simulation
            real DUT_CPU_CLK_FREQ      = 200;       // CPU  Clock (MHz)
            real DUT_SRAM_CLK_FREQ     = 70;        // SRAM Clock (MHz)
            real DUT_CPU_CLK_CYCLE     = 1000 / DUT_CPU_CLK_FREQ;
            real DUT_SRAM_CLK_CYCLE    = 1000 / DUT_SRAM_CLK_FREQ;
            real PHASE_SHIFT_IN_DEGREE = 90;        // 0~360
            real TIME_SHIFT_IN_NS      = (PHASE_SHIFT_IN_DEGREE / 360.0) * DUT_SRAM_CLK_CYCLE;

            reg sim_cpu_clk = 0, sim_sram_uclk = 0, sim_sram_wclk = 0;
            always #(DUT_CPU_CLK_CYCLE /2) sim_cpu_clk   = !sim_cpu_clk;
            always #(DUT_SRAM_CLK_CYCLE/2) sim_sram_uclk = !sim_sram_uclk;
            initial #TIME_SHIFT_IN_NS forever #(DUT_SRAM_CLK_CYCLE/2) sim_sram_wclk = !sim_sram_wclk;
            // assign cpu_clk   = clk;
            assign timer_clk = clk;
            assign cpu_clk   = sim_cpu_clk;
            assign sram_uclk = sim_sram_uclk;
            assign sram_wclk = sim_sram_wclk;
        end else begin: pll
            clk_pll clk_pll(
                .clk_in1    (clk),
                .cpu_clk    (cpu_clk),
                .timer_clk  (timer_clk),
                .clk_out3   (sram_uclk),
                .clk_out4   (sram_wclk)
            );
        end
    endgenerate

    // SRAM
    wire        sram_bus_en;
    wire [31:0] sram_bus_addr;
    wire [ 3:0] sram_bus_we;
    wire [31:0] sram_bus_wdata;
    wire [31:0] sram_bus_rdata;
    // Peripheral
    wire        peri_bus_en;
    wire [31:0] peri_bus_addr;
    wire [ 3:0] peri_bus_we;
    wire [31:0] peri_bus_wdata;
    wire [31:0] peri_bus_rdata;

    wire [4 :0] ram_random_mask;

    // Your CPU
    mycpu_top u_cpu(
        .cpu_rstn       (resetn        ),   //low active
        .cpu_clk        (cpu_clk       ),
        .sram_uclk      (sram_uclk     ),

        // BUS Interface 0 (SRAM)
        .sram_bus_en    (sram_bus_en   ),
        .sram_bus_addr  (sram_bus_addr ),
        .sram_bus_we    (sram_bus_we   ),
        .sram_bus_wdata (sram_bus_wdata),
        .sram_bus_rdata (sram_bus_rdata),
        
        // BUS Interface 1 (Peripheral)
        .peri_bus_en    (peri_bus_en   ),
        .peri_bus_addr  (peri_bus_addr ),
        .peri_bus_we    (peri_bus_we   ),
        .peri_bus_wdata (peri_bus_wdata),
        .peri_bus_rdata (peri_bus_rdata)
    );

    // SRAM
    sram_ctrl #(20) u_sram_ctrl (
        .rstn           (resetn        ),
        .usr_clk        (sram_uclk     ),
        .wen_clk        (sram_wclk     ),
        // User Interface
        .usr_en         (sram_bus_en   ),
        .usr_addr       (sram_bus_addr ),
        .usr_we         (sram_bus_we   ),
        .usr_wdata      (sram_bus_wdata),
        .usr_rdata      (sram_bus_rdata),
        // SRAM Interface
        .sram_addr      (sram_addr     ),   // read/write address
        .sram_data      (sram_data     ),   // read/write data
        .sram_oen       (sram_oen      ),   // output enable
        .sram_cen       (sram_cen      ),   // chip select
        .sram_wen       (sram_wen      ),   // write enable
        .sram_ben       (sram_ben      )
    );

    // Peripheral
    confreg #(.SIMULATION(SIMULATION)) u_confreg (
        .timer_clk   ( timer_clk  ),  // i, 1   
        .aclk        ( cpu_clk    ),  // i, 1   
        .aresetn     ( resetn     ),  // i, 1    

        // SRAM-BUS Interface
        .bus_en      (peri_bus_en   ),
        .bus_addr    (peri_bus_addr ),
        .bus_we      (peri_bus_we   ),
        .bus_wdata   (peri_bus_wdata),
        .bus_rdata   (peri_bus_rdata),

        .ram_random_mask ( ram_random_mask ),
        .led         ( led        ),  // o, 16   
        .led_rg0     ( led_rg0    ),  // o, 2      
        .led_rg1     ( led_rg1    ),  // o, 2      
        .num_csn     ( num_csn    ),  // o, 8      
        .num_a_g     ( num_a_g    ),  // o, 7      
        .num_data    ( num_data   ),  // o, 32
        .switch      ( switch     ),  // i, 8     
        .btn_key_col ( btn_key_col),  // o, 4          
        .btn_key_row ( btn_key_row),  // i, 4           
        .btn_step    ( btn_step   )   // i, 2   
    );

endmodule

