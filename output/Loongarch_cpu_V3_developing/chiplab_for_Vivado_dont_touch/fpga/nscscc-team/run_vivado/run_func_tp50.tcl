set proj_dir [file normalize [file dirname [info script]]/project]
set _script_dir [file normalize [file dirname [info script]]]

open_project $proj_dir/loongson.xpr
catch { set_property verilog_define {CPU_2CMT} [get_filesets sim_1] }

set func_bin [file normalize $_script_dir/../../../software/examples/nscscc_func/obj/main.bin]
set inst_bin [file normalize $_script_dir/../inst_data.bin]
if {[file exists $func_bin]} {
    file copy -force $func_bin $inst_bin
}

reset_simulation sim_1
launch_simulation -simset sim_1 -mode behavioral
restart
puts "INFO: running 50ms func test (covers test points 35-46)..."
run 50ms
close_sim -force
quit
