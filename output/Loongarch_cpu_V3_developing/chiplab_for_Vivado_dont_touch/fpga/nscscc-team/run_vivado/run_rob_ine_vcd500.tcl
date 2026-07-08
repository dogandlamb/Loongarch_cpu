# VCD 500us for stall diagnosis
set ::VCD_SCOPE "/tb_top/u_soc_top/u_cpu/*"
set ::VCD_RUN_ONCE_US 500
set ::VCD_FILE [file normalize [file dirname [info script]]/project/tb_top_rob500.vcd]

set _script_dir [file normalize [file dirname [info script]]]
set proj_dir [file normalize $_script_dir/project]

open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral

set func_bin [file normalize $_script_dir/../../../software/examples/nscscc_func/obj/main.bin]
set inst_bin [file normalize $_script_dir/../inst_data.bin]
file copy -force $func_bin $inst_bin

restart
set vcd_file $::VCD_FILE
catch {close_vcd}
catch {file delete -force $vcd_file}
open_vcd $vcd_file
log_vcd $::VCD_SCOPE
puts "INFO: VCD -> $vcd_file, run ${::VCD_RUN_ONCE_US}us"
run ${::VCD_RUN_ONCE_US}us
catch {flush_vcd}
catch {close_vcd}
puts "INFO: VCD saved: $vcd_file"
quit
