//功能测试与性能测试二选一
// `define RUN_FUNC_TEST
`define RUN_PERF_TEST

//性能测试中，选择是否打开内存的延时倍增机制，开启宏后无额外延迟
`ifdef RUN_PERF_TEST
// `define RUN_PERF_NO_DELAY
`endif

//for simulation:
//1. if define SIMU_USE_PLL = 1, will use clk_pll to generate cpu_clk/sys_clk,
//   and simulation will be very slow.
//2. usually, please define SIMU_USE_PLL=0 to speed up simulation by assign
//   cpu_clk=clk, sys_clk = clk.
//   at this time, frequency of cpu_clk is 91MHz.
`define SIMU_USE_PLL 0 //set 0 to speed up simulation

`define SIMU_USE_DDR 0 //set 0 to speed up simulation