vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv "+incdir+../../../ipstatic/gen/c2c6" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/clk_pll_ddr/gen/gen/c2c6" \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm  -93  \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../ipstatic/gen/c2c6" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/clk_pll_ddr/gen/gen/c2c6" \
"../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/clk_pll_ddr/gen/clk_pll_ddr_clk_wiz.v" \
"../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/clk_pll_ddr/gen/clk_pll_ddr.v" \

vlog -work xil_defaultlib \
"glbl.v"

