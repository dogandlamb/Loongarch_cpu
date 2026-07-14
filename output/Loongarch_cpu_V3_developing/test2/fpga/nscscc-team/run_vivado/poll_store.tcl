set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
set cpu /tb_top/u_soc_top/u_cpu
for {set t 0} {$t < 20000} {incr t 50} {
    run 50ns
    set dpc [get_value $cpu/u_rename/dis0_pc_o]
    if {[string match *1c01003* $dpc] || [string match *1c01004* $dpc]} {
        set dis [get_value $cpu/u_rename/dis0_valid_o]
        set ft [get_value $cpu/u_rename/dis0_futype_o]
        set mp [get_value $cpu/u_dispatch/rs_mem_push_valid_o]
        set ap0 [get_value $cpu/u_dispatch/rs_alu0_push_valid_o]
        set rmc [get_value $cpu/u_rs_mem/count]
        puts "[format %7d $t]ns pc=$dpc dis=$dis ft=$ft mem_push=$mp alu_push=$ap0 rs_mem=$rmc"
    }
}
close_sim -force
quit
