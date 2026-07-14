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
    set pop [get_value $cpu/u_rob/cmt_pop_i]
    if {$pop == 1} {
        set h [get_value $cpu/u_rob/head]
        set v0 [get_value $cpu/u_rob/cmt0_valid_o]
        set p0 [get_value $cpu/u_rob/cmt0_pc_o]
        set v1 [get_value $cpu/u_rob/cmt1_valid_o]
        set p1 [get_value $cpu/u_rob/cmt1_pc_o]
        puts "[current_time] POP h=$h s0 v=$v0 $p0 | s1 v=$v1 $p1"
    }
}

run 151.5us
for {set i 0} {$i < 120} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
