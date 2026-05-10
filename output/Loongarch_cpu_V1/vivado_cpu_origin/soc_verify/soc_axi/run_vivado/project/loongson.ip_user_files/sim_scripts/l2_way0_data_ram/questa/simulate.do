onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib l2_way0_data_ram_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {l2_way0_data_ram.udo}

run 1000ns

quit -force
