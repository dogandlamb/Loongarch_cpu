# =============================================================================
# NSCSCC func test simulation + VCD export (one-shot)
# -----------------------------------------------------------------------------
# Usage (Vivado Tcl Console):
#   cd [get_property DIRECTORY [current_project]]
#   cd ..
#   source run_func_test_vcd.tcl
#
# Optional (before source):
#   set ::VCD_SCOPE "/tb_top/u_soc_top/u_cpu/*"
#   set ::VCD_SCOPE "/tb_top/u_soc_top/*"
#   set ::VCD_RUN_CHUNK_US 100    ;# run 100us per slice (Cancel-friendly)
#   set ::VCD_RUN_CHUNK_US 0      ;# use single "run all" (faster, Cancel may skip close_vcd)
#
# Note: Vivado has NO "onbreak". Chunked run + catch lets Stop/Cancel return to Tcl
#       so close_vcd runs. After Cancel, partial VCD is still usable in GTKWave.
# Manual rescue: flush_vcd; close_vcd
# =============================================================================

namespace eval ::func_test_vcd {
    variable opened 0
    variable vcd_path ""
}

proc ::func_test_vcd::release_vcd_handle {} {
    variable opened
    catch {flush_vcd}
    catch {close_vcd}
    set opened 0
}

proc ::func_test_vcd::close_safe {reason} {
    variable opened
    variable vcd_path
    if {!$opened} {
        return
    }
    catch {flush_vcd}
    if {[catch {close_vcd} err]} {
        puts "WARN: close_vcd failed ($reason): $err"
    } else {
        set opened 0
        puts "INFO: VCD saved ($reason): $vcd_path"
    }
}

proc ::func_test_vcd::prepare_vcd_path {path} {
    ::func_test_vcd::release_vcd_handle
    after 100

    if {![file exists $path]} {
        return $path
    }

    if {![catch {file delete -force $path}]} {
        return $path
    }

    set alt [file normalize [file join [file dirname $path] \
        "tb_top_func_[clock format [clock seconds] -format %Y%m%d_%H%M%S].vcd"]]
    puts "WARN: cannot delete locked VCD:"
    puts "       $path"
    puts "WARN: close GTKWave, or use the alternate path below."
    puts "INFO: alternate VCD:"
    puts "       $alt"
    return $alt
}

# Chunked run: Stop/Cancel returns here so we can close_vcd (Vivado has no onbreak).
proc ::func_test_vcd::run_sim {chunk_us} {
    set sim_ok 1
    if {$chunk_us > 0} {
        puts "INFO: chunked run, ${chunk_us} us per step (Stop saves partial VCD) ..."
        while {$sim_ok} {
            if {[catch {run ${chunk_us}us} err]} {
                set sim_ok 0
                puts "INFO: run stopped: $err"
                break
            }
            catch {flush_vcd}
        }
    } else {
        puts "INFO: run all (single shot) ..."
        if {[catch {run all} err]} {
            set sim_ok 0
            puts "WARN: run all ended early: $err"
        }
    }
    return $sim_ok
}

set _script_dir [file normalize [file dirname [info script]]]

if {[catch {get_property DIRECTORY [current_project]} proj_dir]} {
    puts "ERROR: open loongson.xpr first"
    return -code error "no project"
}
set proj_dir [file normalize $proj_dir]

set func_bin [file normalize $_script_dir/../../../software/examples/nscscc_func/obj/main.bin]
set inst_bin [file normalize $_script_dir/../inst_data.bin]
if {[info exists ::VCD_FILE]} {
    set vcd_default [file normalize $::VCD_FILE]
} else {
    set vcd_default [file normalize $proj_dir/tb_top_func.vcd]
}

if {![file exists $func_bin]} {
    puts "ERROR: main.bin not found: $func_bin"
    puts "Build: cd software/examples/nscscc_func && make"
    return -code error "main.bin not found"
}

if {![info exists ::VCD_SCOPE]} {
    set ::VCD_SCOPE "/tb_top/u_soc_top/u_cpu/*"
}

if {![info exists ::VCD_RUN_CHUNK_US]} {
    set ::VCD_RUN_CHUNK_US 100
}

file copy -force $func_bin $inst_bin
puts "INFO: inst_data.bin <- $func_bin"

if {[catch {current_sim}]} {
    puts "INFO: no active sim, launch_simulation ..."
    launch_simulation -simset sim_1 -mode behavioral
} else {
    puts "INFO: reusing active simulation"
}

restart

set vcd_file [::func_test_vcd::prepare_vcd_path $vcd_default]
set ::func_test_vcd::vcd_path $vcd_file

if {[catch {open_vcd $vcd_file} err]} {
    puts "ERROR: open_vcd failed: $err"
    return -code error "open_vcd failed"
}
set ::func_test_vcd::opened 1

puts "INFO: VCD -> $vcd_file"
puts "INFO: scope -> $::VCD_SCOPE"

if {[catch {log_vcd $::VCD_SCOPE} err]} {
    ::func_test_vcd::close_safe "log_vcd_failed"
    puts "ERROR: log_vcd failed: $err"
    return -code error "log_vcd failed"
}

set sim_ok [::func_test_vcd::run_sim $::VCD_RUN_CHUNK_US]
::func_test_vcd::close_safe [expr {$sim_ok ? "complete" : "stopped"}]

puts "=============================================="
if {$sim_ok} {
    puts " DONE: func test + VCD"
    puts " expect: Number 8'd58 Functional Test Point PASS!!!"
} else {
    puts " DONE: partial VCD (sim stopped early)"
}
puts " VCD: $vcd_file"
puts " GTKWave: gtkwave \"$vcd_file\""
puts "=============================================="
