set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
foreach t {20 50 100 200 500} {
    run ${t}us
    puts "=== ${t}us === ws_valid=[get_value /tb_top/u_soc_top/u_cpu/ws_valid] cmt0_complete=[get_value /tb_top/u_soc_top/u_cpu/dbg_rob_cmt0_complete] cmt0_pc=[get_value /tb_top/u_soc_top/u_cpu/dbg_rob_cmt0_pc] ftq_full=[get_value /tb_top/u_soc_top/u_cpu/ftq_full] cmt_ptr=[get_value /tb_top/u_soc_top/u_cpu/u_ftq/cmt_ptr]"
}
close_sim -force
quit
