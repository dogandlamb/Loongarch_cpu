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
    set bp [get_value $cpu/u_bpu/pc]
    set fl [get_value $cpu/u_commit/flush_req_o]
    set ft [get_value $cpu/u_commit/flush_type_o]
    set fp [get_value $cpu/u_commit/flush_pc_o]
    set pr [get_value $cpu/u_ifu/predec_redirect_o]
    set pp [get_value $cpu/u_ifu/predec_redirect_pc_o]
    set d0v [get_value $cpu/u_commit/cmt0_valid_i]
    set d0p [get_value $cpu/u_commit/cmt0_pc_i]
    set d0c [get_value $cpu/u_commit/cmt0_complete_i]
    set mp [get_value $cpu/u_commit/selected_mispred]
    set bt [get_value $cpu/u_commit/cmt0_br_taken_i]
    set tg [get_value $cpu/u_commit/cmt0_br_target_i]
    set p1 [get_value $cpu/u_bpu/p1_diff]
    set p1t [get_value $cpu/u_bpu/p1_next]
    puts "[current_time] bpc=$bp fl=$fl t=$ft fpc=$fp mp=$mp | pd=$pr pdpc=$pp | c0 v=$d0v c=$d0c pc=$d0p bt=$bt tg=$tg | p1=$p1 p1n=$p1t"
}

run 291.8us
for {set i 0} {$i < 120} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
