set script_dir     [file dirname [file normalize [info script]]]
set repo_root      [file normalize [file join $script_dir .. .. .. .. ..]]
set mycpu_root     [file join $repo_root output vivado_cpu_origin myCPU]
set rtl_root       [file join $repo_root output vivado_cpu_origin soc_verify soc_bram rtl]
set run_vivado_dir [file join $repo_root output vivado_cpu_origin soc_verify soc_bram run_vivado]
set out_dir        [file join $run_vivado_dir non_project_build_dcp]

file mkdir $out_dir

proc require_single_cell {ref_name} {
    set cells [get_cells -hier -filter "REF_NAME == $ref_name"]
    if {[llength $cells] != 1} {
        error "Expected exactly one cell with REF_NAME=$ref_name, got [llength $cells]: $cells"
    }
    return [lindex $cells 0]
}

create_project -in_memory non_project_build_dcp -part xc7a200tfbg676-1
set_param general.maxThreads 1
set_property target_language Verilog [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property include_dirs [list [file join $mycpu_root common]] [current_fileset]
set_msg_config -id {Synth 8-7129} -suppress
set_msg_config -id {Synth 8-6014} -suppress
set_msg_config -id {Synth 8-589}  -suppress

read_verilog [file join $mycpu_root common cpu_defs.vh]
read_verilog -library xil_defaultlib {
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/decode/ALU_srcGenerator.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/execute/EXE_MEM_reg.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/execute/EXEport.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/execute/ID_EXE_reg.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/decode/IDport.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/frontend/fetch/IF_ID_reg.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/frontend/fetch/IFport.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/memory/MEM_WB_reg.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/memory/MEMport.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/writeback/WBport.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/execute/alu.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/common/bram_data_stream_controller.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/rtl/BRIDGE/bridge_1x2.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/hazard/conflict_detector.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/hazard/conflict_handle.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/rtl/CONFREG/confreg.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/control/forward_deliver.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/decode/get_reg_read_addr.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/decode/imm_generator.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/decode/inst_dec.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/top/mycpu_top.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/frontend/fetch/npc.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/decode/op_dec.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/frontend/fetch/pc.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/backend/control/pipeline_controller.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/common/regfile.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/myCPU/common/tools.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/rtl/soc_lite_top.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/rtl/xilinx_ip/clk_pll/clk_pll_stub.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/rtl/xilinx_ip/data_ram/data_ram_stub.v
  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/rtl/xilinx_ip/inst_ram/inst_ram_stub.v
}

read_ip -quiet D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/run_vivado/project/loongson.srcs/sources_1/ip/div_gen_0/div_gen_0.xci
read_ip -quiet D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/run_vivado/project/loongson.srcs/sources_1/ip/mult_gen_0/mult_gen_0.xci

set_property generate_synth_checkpoint false [get_files D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/run_vivado/project/loongson.srcs/sources_1/ip/div_gen_0/div_gen_0.xci]
set_property generate_synth_checkpoint false [get_files D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/run_vivado/project/loongson.srcs/sources_1/ip/mult_gen_0/mult_gen_0.xci]

if {[llength [get_files -quiet -all D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/run_vivado/project/loongson.gen/sources_1/ip/div_gen_0/div_gen_0_ooc.xdc]] > 0} {
    set_property used_in_implementation false [get_files -quiet -all D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/run_vivado/project/loongson.gen/sources_1/ip/div_gen_0/div_gen_0_ooc.xdc]
}
if {[llength [get_files -quiet -all D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/run_vivado/project/loongson.gen/sources_1/ip/mult_gen_0/mult_gen_0_ooc.xdc]] > 0} {
    set_property used_in_implementation false [get_files -quiet -all D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/run_vivado/project/loongson.gen/sources_1/ip/mult_gen_0/mult_gen_0_ooc.xdc]
}

generate_target all [get_ips]

read_xdc D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/run_vivado/constraints/soc_lite_top.xdc

puts "INFO: starting synth_design"
synth_design -top soc_lite_top -part xc7a200tfbg676-1

puts "INFO: stitching IP DCPs"
set clk_pll_cell  [require_single_cell clk_pll]
set inst_ram_cell [require_single_cell inst_ram]
set data_ram_cell [require_single_cell data_ram]

read_checkpoint -cell $clk_pll_cell  D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/rtl/xilinx_ip/clk_pll/clk_pll.dcp
read_checkpoint -cell $inst_ram_cell D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/rtl/xilinx_ip/inst_ram/inst_ram.dcp
read_checkpoint -cell $data_ram_cell D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/rtl/xilinx_ip/data_ram/data_ram.dcp

write_checkpoint -force [file join $out_dir soc_lite_top_synth_stitched.dcp]
report_utilization -file [file join $out_dir utilization_synth.rpt]

puts "INFO: starting opt/place/route"
opt_design
place_design
phys_opt_design
route_design

write_checkpoint -force [file join $out_dir soc_lite_top_route.dcp]
report_timing_summary -delay_type max -report_unconstrained -check_timing_verbose -max_paths 20 -input_pins -file [file join $out_dir timing_summary_impl.rpt]
report_timing -delay_type max -max_paths 50 -sort_by group -input_pins -file [file join $out_dir timing_paths_impl.rpt]
report_utilization -file [file join $out_dir utilization_impl.rpt]
report_clock_utilization -file [file join $out_dir clock_util_impl.rpt]
report_route_status -file [file join $out_dir route_status_impl.rpt]
report_drc -file [file join $out_dir drc_impl.rpt]

write_bitstream -force [file join $out_dir soc_lite_top.bit]

puts "INFO: bitstream written to [file join $out_dir soc_lite_top.bit]"
puts "INFO: timing summary report = [file join $out_dir timing_summary_impl.rpt]"
