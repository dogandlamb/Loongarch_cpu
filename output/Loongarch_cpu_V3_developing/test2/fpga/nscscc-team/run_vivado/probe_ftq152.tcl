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
    set p0v [get_value $cpu/u_ftq/p0_valid_i]
    set p0p [get_value $cpu/u_ftq/p0_pc_i]
    set p0l [get_value $cpu/u_ftq/p0_length_i]
    set p0t [get_value $cpu/u_ftq/p0_taken_i]
    set p0g [get_value $cpu/u_ftq/p0_target_i]
    set p1v [get_value $cpu/u_ftq/p1_valid_i]
    set p1p [get_value $cpu/u_ftq/p1_pc_i]
    set p1l [get_value $cpu/u_ftq/p1_length_i]
    set p1t [get_value $cpu/u_ftq/p1_taken_i]
    set p1g [get_value $cpu/u_ftq/p1_target_i]
    set bp [get_value $cpu/u_ftq/bpu_ptr]
    set ip [get_value $cpu/u_ftq/ifu_ptr]
    set ac [get_value $cpu/u_ftq/ifu_accept_i]
    set apc [get_value $cpu/u_ftq/ifu_pc_o]
    set al [get_value $cpu/u_ftq/ifu_length_o]
    set at [get_value $cpu/u_ftq/ifu_taken_o]
    set ag [get_value $cpu/u_ftq/ifu_target_o]
    set fu [get_value $cpu/u_ftq/ftq_full_o]
    set pd [get_value $cpu/u_ifu/predec_redirect_o]
    set pdp [get_value $cpu/u_ifu/predec_redirect_pc_o]
    set fl [get_value $cpu/u_commit/flush_req_o]
    set flp [get_value $cpu/u_commit/flush_pc_o]
    set iv0 [get_value $cpu/u_ifu/ib_push0_valid_o]
    set ip0 [get_value $cpu/u_ifu/ib_push0_pc_o]
    set il [get_value $cpu/u_ifu/out_len]
    set it [get_value $cpu/u_ifu/if_taken]
    if {$p0v == 1 || $p1v == 1 || $ac == 1 || $pd == 1 || $fl == 1 || $iv0 == 1} {
        puts "[current_time] P0 v=$p0v $p0p l=$p0l t=$p0t g=$p0g | P1 v=$p1v $p1p l=$p1l t=$p1t g=$p1g | b=$bp i=$ip fu=$fu | acc=$ac $apc l=$al t=$at g=$ag | psh=$iv0 $ip0 ol=$il bt=$it | pd=$pd $pdp | fl=$fl $flp"
    }
}

run 151.4us
for {set i 0} {$i < 130} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
