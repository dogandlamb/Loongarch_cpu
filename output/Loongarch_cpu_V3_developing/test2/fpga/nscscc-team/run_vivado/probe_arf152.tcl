set proj_dir [file normalize [file dirname [info script]]/project]
set _script_dir [file normalize [file dirname [info script]]]
open_project $proj_dir/loongson.xpr
launch_simulation -simset sim_1 -mode behavioral
set func_bin [file normalize $_script_dir/../../../software/examples/nscscc_func/obj/main.bin]
set inst_bin [file normalize $_script_dir/../inst_data.bin]
file copy -force $func_bin $inst_bin
restart
set cpu /tb_top/u_soc_top/u_cpu
set soc /tb_top/u_soc_top

proc fine {} {
    global cpu soc
    set v0 [get_value $cpu/u_commit/debug0_valid_o]
    set p0 [get_value $cpu/u_commit/debug0_pc_o]
    set i0 [get_value $cpu/u_commit/debug0_inst_o]
    set n0 [get_value $cpu/u_commit/debug0_rf_wnum_o]
    set d0 [get_value $cpu/u_commit/debug0_rf_wdata_o]
    set e0 [get_value $cpu/u_commit/debug0_rf_wen_o]
    set v1 [get_value $cpu/u_commit/debug1_valid_o]
    set p1 [get_value $cpu/u_commit/debug1_pc_o]
    set i1 [get_value $cpu/u_commit/debug1_inst_o]
    set n1 [get_value $cpu/u_commit/debug1_rf_wnum_o]
    set d1 [get_value $cpu/u_commit/debug1_rf_wdata_o]
    set e1 [get_value $cpu/u_commit/debug1_rf_wen_o]
    if {$v0 == 1 || $v1 == 1} {
        puts "[current_time] C0 v=$v0 pc=$p0 i=$i0 en=$e0 r$n0=$d0 | C1 v=$v1 pc=$p1 i=$i1 en=$e1 r$n1=$d1"
    }
}

run 151.9us
for {set i 0} {$i < 120} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
