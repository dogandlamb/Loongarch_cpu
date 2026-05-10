onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib dcache_way1_TAGV_ram_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {dcache_way1_TAGV_ram.udo}

run 1000ns

quit -force
