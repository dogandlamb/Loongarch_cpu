onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib icache_way1_Bank0_ram_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {icache_way1_Bank0_ram.udo}

run 1000ns

quit -force
