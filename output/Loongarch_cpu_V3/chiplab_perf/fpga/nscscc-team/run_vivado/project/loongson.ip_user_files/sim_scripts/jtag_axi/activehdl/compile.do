transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib activehdl/xpm
vlib activehdl/jtag_axi
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap jtag_axi activehdl/jtag_axi
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/jtag_axi/gen/gen/e2ba/hdl/verilog" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/jtag_axi/gen/gen/a29c/hdl/verilog" -l xpm -l jtag_axi -l xil_defaultlib \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work jtag_axi  -v2k5 "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/jtag_axi/gen/gen/e2ba/hdl/verilog" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/jtag_axi/gen/gen/a29c/hdl/verilog" -l xpm -l jtag_axi -l xil_defaultlib \
"../../../ipstatic/gen/b140/hdl/jtag_axi_v1_2_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/jtag_axi/gen/gen/e2ba/hdl/verilog" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/jtag_axi/gen/gen/a29c/hdl/verilog" -l xpm -l jtag_axi -l xil_defaultlib \
"../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/jtag_axi/gen/sim/jtag_axi.v" \

vlog -work xil_defaultlib \
"glbl.v"

