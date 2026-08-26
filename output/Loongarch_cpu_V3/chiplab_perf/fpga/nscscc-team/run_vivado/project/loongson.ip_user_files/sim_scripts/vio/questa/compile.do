vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/gen/e2ba/hdl/verilog" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/gen/a29c/hdl/verilog" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/gen/1ba3/hdl" \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/gen/e2ba/hdl/verilog" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/gen/a29c/hdl/verilog" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/gen/1ba3/hdl" \
"../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen/sim/vio_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

