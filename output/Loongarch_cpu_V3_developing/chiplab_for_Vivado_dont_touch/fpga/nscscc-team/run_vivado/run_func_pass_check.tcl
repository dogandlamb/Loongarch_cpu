# Func test: recompile, run 5ms, grep PASS in simulate.log
set proj_dir [file normalize [file dirname [info script]]/project]
set _script_dir [file normalize [file dirname [info script]]]

open_project $proj_dir/loongson.xpr
reset_simulation sim_1
launch_simulation -simset sim_1 -mode behavioral

set func_bin [file normalize $_script_dir/../../../software/examples/nscscc_func/obj/main.bin]
set inst_bin [file normalize $_script_dir/../inst_data.bin]
file copy -force $func_bin $inst_bin

restart
puts "INFO: running 5ms func test..."
run 5ms
close_sim -force
quit
