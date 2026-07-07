# Batch: open project, launch sim, export 50us VCD for exception debug
set ::VCD_SCOPE "/tb_top/u_soc_top/u_cpu/*"
set ::VCD_RUN_CHUNK_US 50
set ::VCD_FILE [file normalize [file dirname [info script]]/project/tb_top_ecode.vcd]

set _script_dir [file normalize [file dirname [info script]]]
set proj_dir [file normalize $_script_dir/project]

open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral

source [file join $_script_dir run_func_test_vcd.tcl]
quit
