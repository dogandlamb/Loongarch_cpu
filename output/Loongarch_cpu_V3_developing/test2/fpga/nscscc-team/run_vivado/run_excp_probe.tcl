# Probe ROB commit + INE on flush (batch, 20us, polling — no interactive "when")
set proj_dir [file normalize [file dirname [info script]]/project]
set _script_dir [file normalize [file dirname [info script]]]

open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral

set func_bin [file normalize $_script_dir/../../../software/examples/nscscc_func/obj/main.bin]
set inst_bin [file normalize $_script_dir/../inst_data.bin]
file copy -force $func_bin $inst_bin

restart

set cpu /tb_top/u_soc_top/u_cpu
set step_ns 100
set total_ns 20000
set prev_flush 0
set prev_ine 0

proc ::probe_bit1 {sig} {
    set v [get_value $sig]
    if {[catch {expr {$v == 1}} ok]} { return 0 }
    return $ok
}

proc ::probe_uint {sig} {
    set v [get_value $sig]
    if {[catch {expr {int($v)}} u]} { return 0 }
    return $u
}

puts "=== INE probe: step ${step_ns}ns x [expr {$total_ns / $step_ns}] ==="

for {set t 0} {$t < $total_ns} {incr t $step_ns} {
    run ${step_ns}ns
    set flush [probe_bit1 ${cpu}/cmt_flush_req]
    set ine   [probe_bit1 ${cpu}/cmt_excp_ine]
    set rob_v [probe_bit1 ${cpu}/dbg_rob_cmt0_valid]
    set rob_c [probe_bit1 ${cpu}/dbg_rob_cmt0_complete]
    set rob_ex [probe_uint ${cpu}/dbg_rob_cmt0_excp]

    if {$rob_v && $rob_c && ($rob_ex != 0)} {
        set pc  [get_value ${cpu}/dbg_rob_cmt0_pc]
        set ins [get_value ${cpu}/dbg_rob_cmt0_inst]
        set dec [get_value ${cpu}/dbg_dec0_excp]
        set deff [get_value ${cpu}/dbg_dec0_excp_eff]
        set rn  [get_value ${cpu}/dbg_rn_ib0_excp]
        set ibx [get_value ${cpu}/dbg_ib_pop0_excp]
        set nb  [get_value ${cpu}/dbg_ib0_null_bubble]
        puts "ROB_EXCP t=${t}ns pc=$pc inst=$ins excp=$rob_ex ib_ex=$ibx dec=$dec dec_eff=$deff rn=$rn null=$nb"
    }

    if {$ine && !$prev_ine} {
        set pc  [get_value ${cpu}/dbg_rob_cmt0_pc]
        set ins [get_value ${cpu}/dbg_rob_cmt0_inst]
        set ex  [get_value ${cpu}/dbg_rob_cmt0_excp]
        set dec [get_value ${cpu}/dbg_dec0_excp]
        set deff [get_value ${cpu}/dbg_dec0_excp_eff]
        set rn  [get_value ${cpu}/dbg_rn_ib0_excp]
        set ibx [get_value ${cpu}/dbg_ib_pop0_excp]
        set nb  [get_value ${cpu}/dbg_ib0_null_bubble]
        puts "INE_RISE t=${t}ns rob_pc=$pc rob_inst=$ins rob_ex=$ex ib_ex=$ibx dec=$dec dec_eff=$deff rn=$rn null=$nb"
    }

    if {$flush && !$prev_flush} {
        set ft  [get_value ${cpu}/cmt_flush_type]
        set pc  [get_value ${cpu}/dbg_rob_cmt0_pc]
        set ins [get_value ${cpu}/dbg_rob_cmt0_inst]
        set ex  [get_value ${cpu}/dbg_rob_cmt0_excp]
        set rn  [get_value ${cpu}/dbg_rn_ib0_excp]
        set nb  [get_value ${cpu}/dbg_ib0_null_bubble]
        puts "FLUSH t=${t}ns type=$ft ine=$ine rob_pc=$pc rob_inst=$ins rob_ex=$ex rn=$rn null=$nb"
    }

    set prev_flush $flush
    set prev_ine $ine
}

puts "=== probe done ==="
close_sim -force
quit
