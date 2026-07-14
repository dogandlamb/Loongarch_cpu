set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
foreach t {5 8 10 12 15 20} {
    run ${t}us
    puts "=== ${t}us ==="
    puts "  cmt0_pc=[get_value /tb_top/u_soc_top/u_cpu/dbg_rob_cmt0_pc] complete=[get_value /tb_top/u_soc_top/u_cpu/dbg_rob_cmt0_complete]"
    puts "  rs_mem.count=[get_value /tb_top/u_soc_top/u_cpu/u_rs_mem/count] issue=[get_value /tb_top/u_soc_top/u_cpu/u_rs_mem/issue_valid_o]"
    puts "  mem_wb=[get_value /tb_top/u_soc_top/u_cpu/mem_wb_valid]"
    puts "  ib.count=[get_value /tb_top/u_soc_top/u_cpu/u_inst_buffer/count]"
}
close_sim -force
quit
