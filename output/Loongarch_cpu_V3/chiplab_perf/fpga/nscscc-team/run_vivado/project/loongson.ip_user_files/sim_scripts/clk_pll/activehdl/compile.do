transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib activehdl/xpm
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../ipstatic/gen/c2c6" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/clk_pll/gen/gen/c2c6" -l xpm -l xil_defaultlib \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93  \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic/gen/c2c6" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/clk_pll/gen/gen/c2c6" -l xpm -l xil_defaultlib \
"../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/clk_pll/gen/clk_pll_clk_wiz.v" \
"../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/clk_pll/gen/clk_pll.v" \

vlog -work xil_defaultlib \
"glbl.v"

