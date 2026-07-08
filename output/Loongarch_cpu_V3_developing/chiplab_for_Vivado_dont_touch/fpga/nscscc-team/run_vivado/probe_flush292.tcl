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
    set fr [get_value $cpu/u_commit/flush_req_o]
    set ft [get_value $cpu/u_commit/flush_type_o]
    set fp [get_value $cpu/u_commit/flush_pc_o]
    set ex [get_value $cpu/u_commit/selected_excp_take]
    set mp [get_value $cpu/u_commit/selected_mispred]
    set hv [get_value $cpu/u_rob/cmt0_valid_o]
    set hc [get_value $cpu/u_rob/cmt0_complete_o]
    set hp [get_value $cpu/u_rob/cmt0_pc_o]
    set bt [get_value $cpu/u_commit/cmt0_br_taken_i]
    set tg [get_value $cpu/u_commit/cmt0_br_target_i]
    set pt [get_value $cpu/u_commit/cmt0_pred_taken_i]
    set ib [get_value $cpu/u_commit/cmt0_is_branch_i]
    set qt [get_value $cpu/u_commit/ftq_blk_target_i]
    puts "[current_time] flush=$fr type=$ft fpc=$fp excp=$ex mp=$mp | head v=$hv c=$hc pc=$hp | br=$ib taken=$bt pred=$pt tgt=$tg qtgt=$qt"
}

run 291us
for {set i 0} {$i < 40} {incr i} {
    run 100ns
    fine
}
close_sim -force
quit
