iverilog : gettrace.sim/sim_1/behav/iverilog/gettrace
	cd gettrace.sim/sim_1/behav/iverilog && vvp ./gettrace

gettrace.sim/sim_1/behav/iverilog/gettrace:
	mkdir -p gettrace.sim/sim_1/behav/iverilog && iverilog -Wall -o ./gettrace.sim/sim_1/behav/iverilog/gettrace ./src/*.v ./src/*/*.v 

trace_one:
	make clean
	make iverilog
	cp -f golden_trace.txt golden_trace_exp$(EXP).txt

trace_exp8_11:
	make -C ../func EXP=8 clean all
	make EXP=8 trace_one
	make -C ../func EXP=9 clean all
	make EXP=9 trace_one
	make -C ../func EXP=10 clean all
	make EXP=10 trace_one
	make -C ../func EXP=11 clean all
	make EXP=11 trace_one
	@echo "Generated golden_trace_exp8.txt ~ golden_trace_exp11.txt"

clean : 
	rm -rf gettrace.sim
	rm -f golden_trace.txt
