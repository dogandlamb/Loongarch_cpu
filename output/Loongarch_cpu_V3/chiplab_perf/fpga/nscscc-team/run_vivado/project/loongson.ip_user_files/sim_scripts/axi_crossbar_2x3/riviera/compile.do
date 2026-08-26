transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/generic_baseblocks_v2_1_1
vlib riviera/axi_infrastructure_v1_1_0
vlib riviera/axi_register_slice_v2_1_29
vlib riviera/fifo_generator_v13_2_9
vlib riviera/axi_data_fifo_v2_1_28
vlib riviera/axi_crossbar_v2_1_30
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap generic_baseblocks_v2_1_1 riviera/generic_baseblocks_v2_1_1
vmap axi_infrastructure_v1_1_0 riviera/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_29 riviera/axi_register_slice_v2_1_29
vmap fifo_generator_v13_2_9 riviera/fifo_generator_v13_2_9
vmap axi_data_fifo_v2_1_28 riviera/axi_data_fifo_v2_1_28
vmap axi_crossbar_v2_1_30 riviera/axi_crossbar_v2_1_30
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -incr "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" -l xpm -l generic_baseblocks_v2_1_1 -l axi_infrastructure_v1_1_0 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l xil_defaultlib \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work generic_baseblocks_v2_1_1  -incr -v2k5 "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" -l xpm -l generic_baseblocks_v2_1_1 -l axi_infrastructure_v1_1_0 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l xil_defaultlib \
"../../../ipstatic/gen/10ab/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_infrastructure_v1_1_0  -incr -v2k5 "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" -l xpm -l generic_baseblocks_v2_1_1 -l axi_infrastructure_v1_1_0 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l xil_defaultlib \
"../../../ipstatic/gen/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_29  -incr -v2k5 "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" -l xpm -l generic_baseblocks_v2_1_1 -l axi_infrastructure_v1_1_0 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l xil_defaultlib \
"../../../ipstatic/gen/ff9f/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_9  -incr -v2k5 "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" -l xpm -l generic_baseblocks_v2_1_1 -l axi_infrastructure_v1_1_0 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l xil_defaultlib \
"../../../ipstatic/gen/ac72/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_9 -93  -incr \
"../../../ipstatic/gen/ac72/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_9  -incr -v2k5 "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" -l xpm -l generic_baseblocks_v2_1_1 -l axi_infrastructure_v1_1_0 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l xil_defaultlib \
"../../../ipstatic/gen/ac72/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_28  -incr -v2k5 "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" -l xpm -l generic_baseblocks_v2_1_1 -l axi_infrastructure_v1_1_0 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l xil_defaultlib \
"../../../ipstatic/gen/279e/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_30  -incr -v2k5 "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" -l xpm -l generic_baseblocks_v2_1_1 -l axi_infrastructure_v1_1_0 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l xil_defaultlib \
"../../../ipstatic/gen/fb47/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" -l xpm -l generic_baseblocks_v2_1_1 -l axi_infrastructure_v1_1_0 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l xil_defaultlib \
"../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/sim/axi_crossbar_2x3.v" \

vlog -work xil_defaultlib \
"glbl.v"

