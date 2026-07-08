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
    set v0 [get_value $cpu/u_ifu/ib_push0_valid_o]
    set p0 [get_value $cpu/u_ifu/ib_push0_pc_o]
    set t0 [get_value $cpu/u_ifu/ib_push0_pred_taken_o]
    set v1 [get_value $cpu/u_ifu/ib_push1_valid_o]
    set p1 [get_value $cpu/u_ifu/ib_push1_pc_o]
    set t1 [get_value $cpu/u_ifu/ib_push1_pred_taken_o]
    set v2 [get_value $cpu/u_ifu/ib_push2_valid_o]
    set p2 [get_value $cpu/u_ifu/ib_push2_pc_o]
    set t2 [get_value $cpu/u_ifu/ib_push2_pred_taken_o]
    set v3 [get_value $cpu/u_ifu/ib_push3_valid_o]
    set p3 [get_value $cpu/u_ifu/ib_push3_pc_o]
    set t3 [get_value $cpu/u_ifu/ib_push3_pred_taken_o]
    set pd [get_value $cpu/u_ifu/predec_redirect_o]
    set pdd [get_value $cpu/u_ifu/predec_is_direct]
    set pdp [get_value $cpu/u_ifu/predec_redirect_pc_o]
    set ift [get_value $cpu/u_ifu/if_taken]
    set iid [get_value $cpu/u_ifu/if_id]
    set acc [get_value $cpu/u_ifu/ftq_accept_o]
    set apc [get_value $cpu/u_ftq/ifu_pc_o]
    set fl [get_value $cpu/u_commit/flush_req_o]
    if {$v0 == 1 || $acc == 1 || $pd == 1 || $fl == 1} {
        puts "[current_time] psh v=$v0$v1$v2$v3 pc0=$p0 t=$t0$t1$t2$t3 blk_tkn=$ift id=$iid | pd=$pd dir=$pdd pdpc=$pdp | acc=$acc apc=$apc | fl=$fl"
    }
}

run 286us
for {set i 0} {$i < 200} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
