# Compile sim without reset_simulation (avoid locked simulate.log)
set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
compile_simulation -simset sim_1 -mode behavioral -force
quit
