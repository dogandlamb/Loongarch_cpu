# 单程序性能测试: PERF_COUNT探针输出IPC/cache命中/分支准确率.
# 计数窗口由testbench的confreg TIMER读(get_count)精确括住纯算法区.
set _sd [file normalize [file dirname [info script]]]
set prog [lindex $argv 0]
if {$prog eq ""} { set prog bitcount }

open_project $_sd/project/loongson.xpr
catch { set_property verilog_define {CPU_2CMT PERF_COUNT} [get_filesets sim_1] }

set src $_sd/../../../software/examples/nscscc_perf/obj/$prog/inst_data.bin
puts "=== PERF PROG = $prog ==="
# 拷到testbench会读的两个候选位置,确保命中
file copy -force $src $_sd/inst_data.bin
file copy -force $src $_sd/../inst_data.bin
puts "===     copied to run_vivado ([file size $_sd/inst_data.bin] bytes) ==="

# 不用 reset_simulation(会删被锁文件致崩). 直接 launch(首次编译或复用快照).
# testbench已改则需重编:靠launch_simulation自身增量检测. bin变化由restart+重读$fopen生效.
launch_simulation -simset sim_1 -mode behavioral
restart
puts "=== running perf sim ($prog);TIMER读括住算法区,触发 perf_report+finish ==="
run -all
close_sim -force
quit
