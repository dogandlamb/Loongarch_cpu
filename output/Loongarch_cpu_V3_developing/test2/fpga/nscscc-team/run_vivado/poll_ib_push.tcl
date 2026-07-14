set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
set cpu /tb_top/u_soc_top/u_cpu
for {set t 0} {$t < 20000} {incr t 200} {
    run 200ns
    set push0 [get_value $cpu/u_ifu/ib_push0_valid_o]
    set ibc [get_value $cpu/u_inst_buffer/count]
    set ifv [get_value $cpu/u_ifu/if_v]
    if {$push0 == 1 || $ibc != 0} {
        puts "[format %6d $t]ns push0=$push0 ib=$ibc if_v=$ifv"
    }
}
close_sim -force
quit
