# OOC synthesis of core_top at 100MHz to measure CPU-core Fmax and critical paths.
# Isolates the CPU from DDR/AXI SoC infra + PLL (cpu_clk is normally 32.7MHz).
set part xc7a200tfbg676-2
set cpu_dir e:/Loongarch_cpu/output/Loongarch_cpu_V3_developing/chiplab_for_Vivado_dont_touch/IP/myCPU
set out_dir e:/Loongarch_cpu/timing_ooc

read_verilog -sv [glob $cpu_dir/mycpu.h]
foreach f {
    backend/commit/commit.v backend/commit/ctrl.v backend/commit/regfile.v backend/commit/rob.v
    backend/decode/decode_tools.v backend/decode/decoder.v backend/decode/get_reg_read_addr.v
    backend/decode/imm_generator.v backend/decode/inst_dec.v backend/decode/op_dec.v
    backend/execute/alu.v backend/execute/div.v backend/execute/fu_alu.v backend/execute/fu_mdu.v
    backend/execute/lsu.v backend/execute/mul.v
    backend/issue/dispatch.v backend/issue/rs_alu.v backend/issue/rs_mdu.v backend/issue/rs_mem.v
    backend/rename/rat.v backend/rename/rename.v
    frontend/bpu.v frontend/ftb.v frontend/ftq.v frontend/icache.v frontend/ifu.v
    frontend/inst_buffer.v frontend/ras.v frontend/tage.v frontend/ubtb.v
    memory/axi_line_bridge.v memory/dcache.v memory/l2cache.v memory/store_buffer.v
    mycpu_top.v
    priv/csr_exception_commit_handler.v priv/exception_Decoder.v priv/l1_tlb.v
    priv/mmu.v priv/tlb.v priv/tlb_manager.v
} {
    read_verilog $cpu_dir/$f
}

set_property include_dirs $cpu_dir [current_fileset]
synth_design -top core_top -part $part -mode out_of_context -include_dirs $cpu_dir

# 100MHz on the CPU clock
create_clock -name aclk -period 10.000 [get_ports aclk]
set_input_delay  -clock aclk 2.0 [all_inputs]
set_output_delay -clock aclk 2.0 [all_outputs]

report_timing_summary -max_paths 20 -file $out_dir/timing_summary.rpt
report_timing -max_paths 30 -sort_by group -input_pins -file $out_dir/timing_detail.rpt
report_utilization -file $out_dir/util.rpt
puts "=== WNS ==="
puts [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]
