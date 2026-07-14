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
    set ex [get_value $cpu/u_commit/selected_excp_take]
    set t1 [get_value $cpu/u_commit/take_slot1_for_csr]
    set v1 [get_value $cpu/u_commit/cmt1_valid_i]
    set c1 [get_value $cpu/u_commit/cmt1_complete_i]
    set p1 [get_value $cpu/u_commit/cmt1_pc_i]
    set i1 [get_value $cpu/u_commit/cmt1_inst_i]
    set e1 [get_value $cpu/u_commit/cmt1_excp_i]
    set v0 [get_value $cpu/u_commit/cmt0_valid_i]
    set p0 [get_value $cpu/u_commit/cmt0_pc_i]
    set e0 [get_value $cpu/u_commit/cmt0_excp_i]
    set np [get_value $cpu/u_commit/csr_next_pc_i]
    set hr [get_value $cpu/u_commit/cmt1_head_retire]
    set he [get_value $cpu/u_commit/cmt1_ready]
    puts "[current_time] ex=$ex sl1=$t1 | c1 v=$v1 c=$c1 rdy=$he pc=$p1 inst=$i1 excp=$e1 | c0 v=$v0 pc=$p0 excp=$e0 | npc=$np hr=$hr"
}

run 286.9us
for {set i 0} {$i < 30} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
