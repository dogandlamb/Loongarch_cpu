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
    set fl [get_value $cpu/u_commit/flush_req_o]
    set ft [get_value $cpu/u_commit/flush_type_o]
    set fp [get_value $cpu/u_commit/flush_pc_o]
    set ex [get_value $cpu/u_commit/selected_excp_take]
    set mp [get_value $cpu/u_commit/selected_mispred]
    set pv [get_value $cpu/u_commit/selected_priv_flush]
    set it [get_value $cpu/u_commit/int_take]
    set v0 [get_value $cpu/u_commit/cmt0_valid_i]
    set p0 [get_value $cpu/u_commit/cmt0_pc_i]
    set i0 [get_value $cpu/u_commit/cmt0_inst_i]
    set e0 [get_value $cpu/u_commit/cmt0_excp_i]
    set pr0 [get_value $cpu/u_commit/cmt0_priv_vec_i]
    set np [get_value $cpu/u_commit/csr_next_pc_i]
    set bt [get_value $cpu/u_commit/cmt0_br_taken_i]
    set tg [get_value $cpu/u_commit/cmt0_br_target_i]
    set pt [get_value $cpu/u_commit/cmt0_pred_taken_i]
    set ib [get_value $cpu/u_commit/cmt0_is_branch_i]
    set qt [get_value $cpu/u_commit/ftq_blk_target_i]
    puts "[current_time] fl=$fl t=$ft fpc=$fp ex=$ex mp=$mp pv=$pv int=$it | c0 v=$v0 pc=$p0 inst=$i0 excp=$e0 priv=$pr0 | brnch=$ib bt=$bt pt=$pt tg=$tg qtgt=$qt | csrnpc=$np"
}

run 286.5us
for {set i 0} {$i < 80} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
