# 诊断: 打印每个TIMER写0/读+CR1写,看boot延迟循环 vs benchmark计时区
set _sd [file normalize [file dirname [info script]]]
set prog [lindex $argv 0]
if {$prog eq ""} { set prog bitcount }

open_project $_sd/project/loongson.xpr
catch { set_property verilog_define {CPU_2CMT PERF_COUNT PERF_DIAG} [get_filesets sim_1] }

set src $_sd/../../../software/examples/nscscc_perf/obj/$prog/inst_data.bin
puts "=== PERF DIAG PROG = $prog ==="
file copy -force $src $_sd/inst_data.bin
file copy -force $src $_sd/../inst_data.bin

reset_simulation sim_1
launch_simulation -simset sim_1 -mode behavioral
restart
puts "=== running perf DIAG ($prog); 35ms bounded ==="
run 35ms
close_sim -force
quit
