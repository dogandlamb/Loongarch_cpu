# Sample FTQ/IFU stall signals at 15us
set proj_dir [file normalize [file dirname [info script]]/project]
set _script_dir [file normalize [file dirname [info script]]]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
set func_bin [file normalize $_script_dir/../../../software/examples/nscscc_func/obj/main.bin]
file copy -force $func_bin [file normalize $_script_dir/../inst_data.bin]
restart
run 15us
set cpu /tb_top/u_soc_top/u_cpu
foreach sig {
    ftq_full fetch_stall ws_valid debug0_wb_pc
    dbg_rob_cmt0_valid dbg_rob_cmt0_pc
    ftq_ifu_pc bpu_p0_pc predec_redirect
} {
    catch {puts "$sig = [get_value ${cpu}/$sig]"}
}
foreach sig {
    bpu_ptr ifu_ptr cmt_ptr ifu_valid_o ftq_full_o
} {
    catch {puts "$sig = [get_value ${cpu}/u_ftq/$sig]"}
}
foreach sig {
    pre_v if_v if_wait_data ic_outstanding drop_rsp ftq_accept_o ic_req_o ic_data_ok_i
} {
    catch {puts "$sig = [get_value ${cpu}/u_ifu/$sig]"}
}
close_sim -force
quit
