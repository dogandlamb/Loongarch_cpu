transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -incr "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/gen/e2ba/hdl/verilog" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/gen/a29c/hdl/verilog" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/gen/1ba3/hdl" -l xpm -l xil_defaultlib \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/gen/e2ba/hdl/verilog" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/gen/a29c/hdl/verilog" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/gen/1ba3/hdl" -l xpm -l xil_defaultlib \
"../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/sim/vio_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

