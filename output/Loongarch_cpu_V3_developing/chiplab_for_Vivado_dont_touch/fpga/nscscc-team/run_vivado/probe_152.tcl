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
    set v0 [get_value $cpu/u_commit/cmt0_valid_i]
    set c0 [get_value $cpu/u_commit/cmt0_complete_i]
    set p0 [get_value $cpu/u_commit/cmt0_pc_i]
    set i0 [get_value $cpu/u_commit/cmt0_inst_i]
    set e0 [get_value $cpu/u_commit/cmt0_excp_i]
    set v1 [get_value $cpu/u_commit/cmt1_valid_i]
    set c1 [get_value $cpu/u_commit/cmt1_complete_i]
    set p1 [get_value $cpu/u_commit/cmt1_pc_i]
    set i1 [get_value $cpu/u_commit/cmt1_inst_i]
    set e1 [get_value $cpu/u_commit/cmt1_excp_i]
    set d0 [get_value $soc/debug_wb_pc]
    set fl [get_value $cpu/u_commit/flush_req_o]
    set ft [get_value $cpu/u_commit/flush_type_o]
    set mp [get_value $cpu/u_commit/selected_mispred]
    if {$v0 == 1 || $v1 == 1 || $fl == 1} {
        puts "[current_time] fl=$fl t=$ft ex=$ex mp=$mp sl1=$t1 | c0 v=$v0 c=$c0 pc=$p0 i=$i0 e=$e0 | c1 v=$v1 c=$c1 pc=$p1 i=$i1 e=$e1 | wb=$d0"
    }
}

run 151.3us
for {set i 0} {$i < 130} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
