set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
set cpu /tb_top/u_soc_top/u_cpu
foreach t {5 10 15 20 30 50} {
    run ${t}us
    puts "=== ${t}us ==="
    foreach s {ws_valid debug0_wb_pc ftq_full} {
        puts "$s = [get_value $cpu/$s]"
    }
    foreach s {bpu_ptr ifu_ptr cmt_ptr} {
        puts "ftq.$s = [get_value $cpu/u_ftq/$s]"
    }
    foreach s {if_v if_wait_data ic_req_o pre_v ic_outstanding} {
        catch { puts "ifu.$s = [get_value $cpu/u_ifu/$s]" }
    }
    foreach s {count pop0_valid_o} {
        puts "ib.$s = [get_value $cpu/u_inst_buffer/$s]"
    }
    catch { puts "dis0_valid = [get_value $cpu/u_rename/dis0_valid_o]" }
}
close_sim -force
quit
