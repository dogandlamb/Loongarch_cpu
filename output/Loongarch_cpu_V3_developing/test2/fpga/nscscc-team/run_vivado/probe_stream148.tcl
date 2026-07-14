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
    set pd [get_value $cpu/u_ifu/predec_redirect_o]
    set pdp [get_value $cpu/u_ifu/predec_redirect_pc_o]
    set fl [get_value $cpu/u_commit/flush_req_o]
    set flt [get_value $cpu/u_commit/flush_type_o]
    set flp [get_value $cpu/u_commit/flush_pc_o]
    set pop [get_value $cpu/u_rob/cmt_pop_i]
    set hp [get_value $cpu/u_rob/cmt0_pc_o]
    set h1p [get_value $cpu/u_rob/cmt1_pc_o]
    set h1v [get_value $cpu/u_rob/cmt1_valid_o]
    set acc [get_value $cpu/u_ifu/ftq_accept_o]
    set apc [get_value $cpu/u_ftq/ifu_pc_o]
    set ipt [get_value $cpu/u_ftq/ifu_ptr]
    set ibc [get_value $cpu/u_inst_buffer/count]
    set cg [get_value $cpu/u_rename/can_go]
    set i0p [get_value $cpu/u_rename/ib0_pc_i]
    set out ""
    if {$iv0 == 1} { append out " PUSH $ip0 l=$il" }
    if {$pd == 1} { append out " PREDEC->$pdp" }
    if {$acc == 1} { append out " ACC $apc ptr=$ipt" }
    if {$fl == 1} { append out " FLUSH t=$flt pc=$flp" }
    if {$pop == 1} { append out " POP $hp/$h1v:$h1p" }
    if {$cg == 1} { append out " RN $i0p ib=$ibc" }
    if {$out != ""} { puts "[current_time]$out" }
}

run 148us
for {set i 0} {$i < 460} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
