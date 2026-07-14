# First idle_1s entry: lu12i/addi commit chain @ 0x1c010290 (400-403.5us)
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
set ib  $cpu/u_inst_buffer
set rn  $cpu/u_rename
set outf [open [file normalize [file dirname [info script]]/probe_idle290_first_out.txt] w]

proc inst_eq {inst val} {
    if {[catch {set x [scan $inst %x]} err]} { return 0 }
    return [expr {$x == $val}]
}

proc snap {} {
    global cpu ib rn outf
    set cnt   [get_value $ib/count]
    set head  [get_value $ib/head]
    set tail  [get_value $ib/tail]
    set p0v   [get_value $ib/pop0_valid_o]
    set p0pc  [get_value $ib/pop0_pc_o]
    set p0i   [get_value $ib/pop0_inst_o]
    set p0r   [get_value $ib/pop0_ready_i]
    set p1v   [get_value $ib/pop1_valid_o]
    set p1pc  [get_value $ib/pop1_pc_o]
    set p1i   [get_value $ib/pop1_inst_o]
    set p1r   [get_value $ib/pop1_ready_i]
    set i0v   [get_value $rn/ib0_valid_i]
    set i0pc  [get_value $rn/ib0_pc_i]
    set i0i   [get_value $rn/ib0_inst_i]
    set i0rdy [get_value $rn/ib0_ready_o]
    set i1v   [get_value $rn/ib1_valid_i]
    set i1pc  [get_value $rn/ib1_pc_i]
    set i1i   [get_value $rn/ib1_inst_i]
    set i1rdy [get_value $rn/ib1_ready_o]
    set can   [get_value $rn/can_go]
    set dio   [get_value $rn/dual_issue_ok]
    set cv0   [get_value $cpu/u_commit/debug0_valid_o]
    set cp0   [get_value $cpu/u_commit/debug0_pc_o]
    set ci0   [get_value $cpu/u_commit/debug0_inst_o]
    set cn0   [get_value $cpu/u_commit/debug0_rf_wnum_o]
    set cd0   [get_value $cpu/u_commit/debug0_rf_wdata_o]
    set ce0   [get_value $cpu/u_commit/debug0_rf_wen_o]
    set cv1   [get_value $cpu/u_commit/debug1_valid_o]
    set cp1   [get_value $cpu/u_commit/debug1_pc_o]
    set ci1   [get_value $cpu/u_commit/debug1_inst_o]
    set cn1   [get_value $cpu/u_commit/debug1_rf_wnum_o]
    set cd1   [get_value $cpu/u_commit/debug1_rf_wdata_o]
    set ce1   [get_value $cpu/u_commit/debug1_rf_wen_o]
    set r12   [get_value $cpu/u_regfile/rf\[12\]]

    set hit_li [expr {[inst_eq $p0i 0x157f5fec] || [inst_eq $p1i 0x157f5fec] || [inst_eq $i0i 0x157f5fec] || [inst_eq $i1i 0x157f5fec] || [inst_eq $ci0 0x157f5fec] || [inst_eq $ci1 0x157f5fec] || [inst_eq $p0i 0x0282418c] || [inst_eq $p1i 0x0282418c] || [inst_eq $i0i 0x0282418c] || [inst_eq $i1i 0x0282418c] || [inst_eq $ci0 0x0282418c] || [inst_eq $ci1 0x0282418c]}]
    set hit_r12 [expr {($cv0 == 1 && $cn0 == 12 && $ce0 == 1) || ($cv1 == 1 && $cn1 == 12 && $ce1 == 1)}]
    set hit_pop [expr {($p0v == 1 && $p0r == 1) || ($p1v == 1 && $p1r == 1)}]
    set p0px [scan $p0pc %x]
    set hit_idle [expr {($p0v == 1 && $p0px >= 0x1c010280 && $p0px <= 0x1c0102c0) || ($p1v == 1 && [scan $p1pc %x] >= 0x1c010280 && [scan $p1pc %x] <= 0x1c0102c0)}]

    if {$hit_li || $hit_r12 || $hit_pop || $hit_idle} {
        puts $outf "[current_time] IB cnt=$cnt head=$head tail=$tail pop0 v=$p0v r=$p0r pc=$p0pc i=$p0i | pop1 v=$p1v r=$p1r pc=$p1pc i=$p1i"
        puts $outf "  RN ib0 v=$i0v rdy=$i0rdy pc=$i0pc i=$i0i | ib1 v=$i1v rdy=$i1rdy pc=$i1pc i=$i1i | can=$can dio=$dio"
        if {$cv0 == 1 || $cv1 == 1} {
            puts $outf "  CMT C0 v=$cv0 pc=$cp0 i=$ci0 en=$ce0 r$cn0=$cd0 | C1 v=$cv1 pc=$cp1 i=$ci1 en=$ce1 r$cn1=$cd1 | r12=$r12"
        }
        puts $outf ""
        flush $outf
    }
}

run 393us
for {set i 0} {$i < 1200} {incr i} {
    run 10ns
    snap
}
close $outf
close_sim -force
quit
