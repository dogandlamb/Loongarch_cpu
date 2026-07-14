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
    set iv0 [get_value $cpu/u_ifu/ib_push0_valid_o]
    set ip0 [get_value $cpu/u_ifu/ib_push0_pc_o]
    set il [get_value $cpu/u_ifu/out_len]
    set it [get_value $cpu/u_ifu/if_taken]
    set itg [get_value $cpu/u_ifu/if_target]
    set pd [get_value $cpu/u_ifu/predec_redirect_o]
    set pdp [get_value $cpu/u_ifu/predec_redirect_pc_o]
    set p1v [get_value $cpu/u_ftq/p1_valid_i]
    set p1p [get_value $cpu/u_ftq/p1_pc_i]
    set p1l [get_value $cpu/u_ftq/p1_length_i]
    set p1t [get_value $cpu/u_ftq/p1_taken_i]
    set p1g [get_value $cpu/u_ftq/p1_target_i]
    set fl [get_value $cpu/u_commit/flush_req_o]
    set pop [get_value $cpu/u_rob/cmt_pop_i]
    set hp [get_value $cpu/u_rob/cmt0_pc_o]
    set out ""
    if {$iv0 == 1} { append out " PUSH $ip0 len=$il tkn=$it tgt=$itg" }
    if {$pd == 1} { append out " PREDEC->$pdp" }
    if {$p1v == 1} { append out " P1 $p1p l=$p1l t=$p1t g=$p1g" }
    if {$fl == 1} { append out " FLUSH" }
    if {$pop == 1} { append out " POP $hp" }
    if {$out != ""} { puts "[current_time]$out" }
}

run 149.5us
for {set i 0} {$i < 300} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
