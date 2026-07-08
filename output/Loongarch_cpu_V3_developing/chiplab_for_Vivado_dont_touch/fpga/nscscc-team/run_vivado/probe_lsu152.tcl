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
    set iv [get_value $cpu/u_lsu/issue_valid_i]
    set ib [get_value $cpu/u_lsu/issue_base_i]
    set ii [get_value $cpu/u_lsu/issue_imm_i]
    set ir [get_value $cpu/u_lsu/issue_robid_i]
    set ip [get_value $cpu/u_lsu/issue_pc_i]
    set av [get_value $cpu/u_lsu/a_valid]
    set ab [get_value $cpu/u_lsu/a_base]
    set ai [get_value $cpu/u_lsu/a_imm]
    set avad [get_value $cpu/u_lsu/a_vaddr]
    set arob [get_value $cpu/u_lsu/a_robid]
    set ale [get_value $cpu/u_lsu/a_ale]
    set wbv [get_value $cpu/u_lsu/wb_valid_o]
    set wbr [get_value $cpu/u_lsu/wb_robid_o]
    set wbe [get_value $cpu/u_lsu/wb_excp_o]
    set wbva [get_value $cpu/u_lsu/wb_vaddr_o]
    if {$iv == 1 || $wbv == 1} {
        puts "[current_time] iss=$iv pc=$ip rob=$ir base=$ib imm=$ii | a v=$av base=$ab imm=$ai vad=$avad rob=$arob ale=$ale | wb v=$wbv rob=$wbr excp=$wbe vad=$wbva"
    }
}

run 151.9us
for {set i 0} {$i < 80} {incr i} {
    run 10ns
    fine
}
close_sim -force
quit
