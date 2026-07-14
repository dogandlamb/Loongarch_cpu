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
    set b12 [get_value $cpu/u_rat/busy\[12\]]
    set n12 [get_value $cpu/u_rat/num\[12\]]
    set a12 [get_value $cpu/u_regfile/rf\[12\]]
    set pv [get_value $cpu/u_rs_mem/push_valid_i]
    set pr [get_value $cpu/u_rs_mem/push_robid_i]
    set ps0r [get_value $cpu/u_rs_mem/push_src0_ready_i]
    set ps0v [get_value $cpu/u_rs_mem/push_src0_val_i]
    set ps0i [get_value $cpu/u_rs_mem/push_src0_robid_i]
    set iv [get_value $cpu/u_rs_mem/issue_valid_o]
    set ir [get_value $cpu/u_rs_mem/issue_robid_o]
    set is0 [get_value $cpu/u_rs_mem/issue_base_o]
    puts "[current_time] rat12 b=$b12 n=$n12 arf12=$a12 | push v=$pv rob=$pr s0 rdy=$ps0r val=$ps0v tag=$ps0i | iss v=$iv rob=$ir base=$is0"
}

run 152.2us
for {set i 0} {$i < 25} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
