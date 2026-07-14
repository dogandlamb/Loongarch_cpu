# Recompile + run func test 200us, capture pass/fail
set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
reset_simulation sim_1
launch_simulation -simset sim_1 -mode behavioral
restart
run 200us
quit
