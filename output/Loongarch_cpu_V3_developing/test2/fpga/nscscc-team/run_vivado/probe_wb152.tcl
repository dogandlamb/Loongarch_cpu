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
    set v0 [get_value $cpu/cmt_dbg0_valid]
    set p0 [get_value $cpu/cmt_dbg0_pc]
    set w0 [get_value $cpu/cmt_dbg0_wnum]
    set d0 [get_value $cpu/cmt_dbg0_wdata]
    set v1 [get_value $cpu/cmt_dbg1_valid]
    set p1 [get_value $cpu/cmt_dbg1_pc]
    set w1 [get_value $cpu/cmt_dbg1_wnum]
    set d1 [get_value $cpu/cmt_dbg1_wdata]
    if {$v0 == 1 || $v1 == 1} {
        puts "[current_time] C0 v=$v0 pc=$p0 r$w0=$d0 | C1 v=$v1 pc=$p1 r$w1=$d1"
    }
}

run 151.6us
for {set i 0} {$i < 100} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
