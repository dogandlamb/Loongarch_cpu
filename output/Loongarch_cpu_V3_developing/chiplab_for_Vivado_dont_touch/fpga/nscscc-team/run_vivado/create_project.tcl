# SET PROJECT NAME
set  project_name loongson
set  project_path ./project
set project_part xc7a200tfbg676-2
# CLEAR
file delete -force $project_path
file delete -force ../../../chip/soc_demo/nscscc-team/xilinx_ip/clk_pll/gen
file delete -force ../../../chip/soc_demo/nscscc-team/xilinx_ip/clk_pll_ddr/gen
file delete -force ../../../chip/soc_demo/nscscc-team/xilinx_ip/vio/gen
file delete -force ../../../chip/soc_demo/nscscc-team/xilinx_ip/axi_crossbar_2x3/gen
file delete -force ../../../chip/soc_demo/nscscc-team/xilinx_ip/jtag_axi/gen
file delete -force ../../../chip/soc_demo/nscscc-team/xilinx_ip/mig_axi_32/gen

create_project -force $project_name $project_path -part $project_part

# Add conventional sources
add_files -scan_for_includes ../../../chip/soc_demo/nscscc-team
add_files -scan_for_includes ../../../IP/AXI_SRAM_BRIDGE
add_files -scan_for_includes ../../../IP/APB_DEV/URT
add_files -norecurse "../../../IP/APB_DEV/apb_dev_top_no_nand.v"
add_files -norecurse "../../../IP/APB_DEV/apb_mux2.v"
add_files -norecurse "../../../IP/AMBA/axi2apb.v"

# Add IPs
add_files -quiet [glob -nocomplain ../../../chip/soc_demo/nscscc-team/xilinx_ip/*/*.xci]

# Add simulation files
add_files -fileset sim_1 ../testbench

# Add myCPU
add_files -scan_for_includes ../../../IP/myCPU

# Add xilinx_ip in myCPU
add_files -quiet [glob -nocomplain ../../../IP/myCPU/xilinx_ip/*/*.xci]
add_files -quiet [glob -nocomplain ../../../IP/myCPU/xilinx_ip/*/*.xcix]

# Upgrade IPs
upgrade_ip -quiet [get_ips]

# Add constraints
add_files -fileset constrs_1 -quiet ../constraints

set_property top soc_top [current_fileset]
set_property -name "top" -value "tb_top" -objects  [get_filesets sim_1]
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]
set_property strategy Flow_PerfOptimized_high [get_runs synth_1]
set_property strategy Performance_Explore [get_runs impl_1]
