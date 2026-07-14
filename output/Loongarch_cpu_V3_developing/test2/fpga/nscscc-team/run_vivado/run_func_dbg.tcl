set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
catch { set_property verilog_define {CPU_2CMT} [get_filesets sim_1] }
reset_simulation sim_1
launch_simulation -simset sim_1 -mode behavioral
restart
run 72ms
close_sim -force
quit
