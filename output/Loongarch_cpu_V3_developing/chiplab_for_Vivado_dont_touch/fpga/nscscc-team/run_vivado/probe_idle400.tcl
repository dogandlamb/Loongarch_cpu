# Probe idle_1s region (~393us PASS #01, then idle loop @ 0x1c0102b0)
set proj_dir [file normalize [file dirname [info script]]/project]
set _script_dir [file normalize [file dirname [info script]]]
open_project $proj_dir/loongson.xpr
reset_simulation sim_1
launch_simulation -simset sim_1 -mode behavioral
set func_bin [file normalize $_script_dir/../../../software/examples/nscscc_func/obj/main.bin]
set inst_bin [file normalize $_script_dir/../inst_data.bin]
file copy -force $func_bin $inst_bin
restart
set cpu /tb_top/u_soc_top/u_cpu
set soc /tb_top/u_soc_top
set outf [open [file normalize [file dirname [info script]]/probe_idle400_out.txt] w]

proc snap {} {
    global cpu soc outf
    set dpc [get_value $soc/debug_wb_pc]
    set iv  [get_value $cpu/u_lsu/issue_valid_i]
    set ip  [get_value $cpu/u_lsu/issue_pc_i]
    set ib  [get_value $cpu/u_lsu/issue_base_i]
    set ii  [get_value $cpu/u_lsu/issue_imm_i]
    set av  [get_value $cpu/u_lsu/a_valid]
    set vad [get_value $cpu/u_lsu/a_vaddr]
    set ale [get_value $cpu/u_lsu/a_ale]
    set wbv [get_value $cpu/u_lsu/wb_valid_o]
    set wbd [get_value $cpu/u_lsu/wb_data_o]
    set wbe [get_value $cpu/u_lsu/wb_excp_o]
    set wbva [get_value $cpu/u_lsu/wb_vaddr_o]
    set wbro [get_value $cpu/u_lsu/wb_robid_o]
    # t0=r12 t2=r14 t3=r15
    set r12 [get_value $cpu/u_regfile/rf\[12\]]
    set r14 [get_value $cpu/u_regfile/rf\[14\]]
    set r15 [get_value $cpu/u_regfile/rf\[15\]]
    set sw  [get_value $soc/u_confreg/sw_inter_data]
    set ibn [scan $ib %x]
    set iin [scan $ii %x]
    set vadn [expr {$ibn + $iin}]
    set vadhn [scan $vad %x]
    set dpch [scan $dpc %x]
    if {$iv == 1 || $wbv == 1 || ($dpch >= 0x1c010280 && $dpch <= 0x1c0102e0) || ($vadhn >= 0xbfaff000 && $vadhn <= 0xbfafffff)} {
        puts $outf "[current_time] wbpc=$dpc iss=$iv pc=$ip base=$ib imm=$ii vad=[format 0x%08x $vadn] | a v=$av vad=$vad ale=$ale | wb v=$wbv data=$wbd excp=$wbe vad=$wbva | r12=$r12 r14=$r14 r15=$r15 sw=$sw"
        flush $outf
    }
}

run 420us
for {set i 0} {$i < 800} {incr i} {
    run 10ns
    snap
}
close $outf
close_sim -force
quit
