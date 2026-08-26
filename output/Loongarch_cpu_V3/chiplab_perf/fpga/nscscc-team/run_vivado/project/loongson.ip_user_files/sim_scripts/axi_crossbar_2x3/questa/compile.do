vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/generic_baseblocks_v2_1_1
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_register_slice_v2_1_29
vlib questa_lib/msim/fifo_generator_v13_2_9
vlib questa_lib/msim/axi_data_fifo_v2_1_28
vlib questa_lib/msim/axi_crossbar_v2_1_30
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap generic_baseblocks_v2_1_1 questa_lib/msim/generic_baseblocks_v2_1_1
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_29 questa_lib/msim/axi_register_slice_v2_1_29
vmap fifo_generator_v13_2_9 questa_lib/msim/fifo_generator_v13_2_9
vmap axi_data_fifo_v2_1_28 questa_lib/msim/axi_data_fifo_v2_1_28
vmap axi_crossbar_v2_1_30 questa_lib/msim/axi_crossbar_v2_1_30
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"D:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work generic_baseblocks_v2_1_1  -incr -mfcu  "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" \
"../../../ipstatic/gen/10ab/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_infrastructure_v1_1_0  -incr -mfcu  "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" \
"../../../ipstatic/gen/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_29  -incr -mfcu  "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" \
"../../../ipstatic/gen/ff9f/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_9  -incr -mfcu  "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" \
"../../../ipstatic/gen/ac72/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_9  -93  \
"../../../ipstatic/gen/ac72/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_9  -incr -mfcu  "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" \
"../../../ipstatic/gen/ac72/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_28  -incr -mfcu  "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" \
"../../../ipstatic/gen/279e/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_30  -incr -mfcu  "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" \
"../../../ipstatic/gen/fb47/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../ipstatic/gen/ec67/hdl" "+incdir+../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/gen/ec67/hdl" \
"../../../../../../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen/sim/axi_crossbar_2x3.v" \

vlog -work xil_defaultlib \
"glbl.v"

