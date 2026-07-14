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
    set w0e [get_value $cpu/u_regfile/we0]
    set w0a [get_value $cpu/u_regfile/waddr0]
    set w0d [get_value $cpu/u_regfile/wdata0]
    set w1e [get_value $cpu/u_regfile/we1]
    set w1a [get_value $cpu/u_regfile/waddr1]
    set w1d [get_value $cpu/u_regfile/wdata1]
    set p0 [get_value $cpu/u_commit/cmt0_pc_i]
    set p1 [get_value $cpu/u_commit/cmt1_pc_i]
    set hit0 [expr {$w0e == 1 && $w0a == "0c"}]
    set hit1 [expr {$w1e == 1 && $w1a == "0c"}]
    if {$hit0 || $hit1} {
        puts "[current_time] W0 e=$w0e a=$w0a d=$w0d pc=$p0 | W1 e=$w1e a=$w1a d=$w1d pc=$p1"
    }
}

run 150us
for {set i 0} {$i < 300} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
