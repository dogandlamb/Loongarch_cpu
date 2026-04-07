iverilog : gettrace.sim/sim_1/behav/iverilog/gettrace
	cd gettrace.sim/sim_1/behav/iverilog && vvp ./gettrace

gettrace.sim/sim_1/behav/iverilog/gettrace:
	mkdir -p gettrace.sim/sim_1/behav/iverilog && iverilog -Wall -o ./gettrace.sim/sim_1/behav/iverilog/gettrace ./src/*.v ./src/*/*.v 

# 生成当前 EXP 的 golden_trace.txt，并另存为 golden_trace_exp$(EXP).txt
trace_one:
	make clean
	make iverilog
	cp -f golden_trace.txt golden_trace_exp$(EXP).txt

# 依次生成 exp11~exp16 的参考迹（需在 WSL/Linux 下先编译 ../func）
trace_exp11_16:
	make -C ../func EXP=11 clean all
	make EXP=11 trace_one
	make -C ../func EXP=12 clean all
	make EXP=12 trace_one
	make -C ../func EXP=13 clean all
	make EXP=13 trace_one
	make -C ../func EXP=14 clean all
	make EXP=14 trace_one
	make -C ../func EXP=15 clean all
	make EXP=15 trace_one
	make -C ../func EXP=16 clean all
	make EXP=16 trace_one
	@echo "Generated golden_trace_exp11.txt ~ golden_trace_exp16.txt"

clean : 
	rm -rf gettrace.sim
	rm -f golden_trace.txt
