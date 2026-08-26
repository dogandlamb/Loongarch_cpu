# Rerun Strategy Reference

Select the rerun approach based on the fix types in `timing_fixes.xdc`.

## Decision Table

| Fixes present | Rerun approach |
|---|---|
| ONLY property-based (`LUT_REMAP`, `CARRY_REMAP`, `SRL_STAGES_TO_REG_INPUT`, `CONTROL_SET_REMAP`, `MAX_FANOUT`, `DONT_TOUCH`) | **Property-only reopt** |
| ONLY timing exceptions (`set_clock_groups`, `set_false_path`, `set_max_delay`, `set_bus_skew`, `set_multicycle_path`) | **Constraint-only re-impl** |
| Mix of both | **Full re-implementation** |
| Pblock changes (`delete_pblocks`, `resize_pblock`, `remove_cells_from_pblock`) | **Full re-implementation** |
| SLR placement (`USER_SLR_ASSIGNMENT`, `USER_SLL_REG`, Laguna LOC/BEL) | **Full re-implementation** |

## Property-only reopt

Fastest path. Applies cell property changes and re-implements from the post-opt checkpoint.

**IMPORTANT:** If the XDC sets any remapping properties (`LUT_REMAP`, `CARRY_REMAP`,
`SRL_STAGES_TO_REG_INPUT`, `CONTROL_SET_REMAP`), an `opt_design` step is **required**
after sourcing the XDC. These properties are annotations — they do nothing until
`opt_design` processes them. Skipping `opt_design` means the cascaded LUTs/CARRYs
stay unchanged and the long-logic violation persists.

```tcl
# 1. Close any open design (may be post-route or post-place from analysis)
close_design -quiet

# 2. Open the post-opt checkpoint as the clean starting point
open_checkpoint [get_property DIRECTORY [get_runs impl_1]]/<top>_opt.dcp

# 3. Apply the property-based constraints (read_xdc preserves ordering in DCP; source does not)
read_xdc -unmanaged timing_fixes.xdc

# 4. Run opt_design to act on the properties
#    - If ONLY MAX_FANOUT / DONT_TOUCH changes (no remap properties): skip this step.
#    - If ANY remap property is set (LUT_REMAP, CARRY_REMAP, etc.):
opt_design -property_opt_only
#    - For deeper optimization (recommended when LUT_REMAP is present):
#      opt_design -directive ExploreWithRemap

# 5. Place and route with the new properties applied
place_design
phys_opt_design
route_design
```

## Constraint-only re-impl

Timing exceptions change the timing engine's view but not the netlist. Need re-place + re-route from the post-opt checkpoint.

```tcl
# 1. Close any open design to free memory and avoid conflicts with launch_runs
close_design -quiet

# 2. Add XDC to constraint set
add_files -fileset constrs_1 timing_fixes.xdc

# 3. Reset and rerun from placement (starts from post-opt DCP)
reset_run impl_1 -from_step place_design

# 4. Launch
launch_runs impl_1 -to_step route_design
wait_on_run impl_1
```

## Full re-implementation

When the netlist or floorplan changes. This is the safest approach for mixed fixes.

```tcl
# 1. Close any open design to free memory and avoid conflicts with launch_runs
close_design -quiet

# 2. Add XDC to constraint set
add_files -fileset constrs_1 timing_fixes.xdc

# 3. If Long Logic fixes include LUT_REMAP → configure opt_design directive
#    Default opt_design honours cell-level LUT_REMAP, but ExploreWithRemap is
#    far more effective (multiple passes + aggressive remap). Skip for non-logic fixes.
set_property -name {STEPS.OPT_DESIGN.ARGS.DIRECTIVE} -value {ExploreWithRemap} \
  -objects [get_runs impl_1]

# 4. Reset the full implementation run
reset_run impl_1

# 5. Launch full implementation
launch_runs impl_1 -to_step route_design
wait_on_run impl_1
```

### Non-project flow equivalent

```tcl
# 1. Close the current (routed) design
close_design -quiet

# 2. Open the post-opt checkpoint as the starting point
open_checkpoint <path_to_opt.dcp>

# 3. Apply fix constraints (read_xdc preserves ordering in DCP; source does not)
read_xdc -unmanaged timing_fixes.xdc

# 3.5 Pre-flight: verify no residual DONT_TOUCH blocks remap
#     DONT_TOUCH exists on BOTH cells AND nets independently. RTL attributes
#     like (* DONT_TOUCH = "true" *) set DT on both. Remap regions are bounded
#     by sequential elements — DONT_TOUCH on bounding registers OR their nets
#     makes the entire combinational cone "constrained." opt_design will skip
#     remap even if the LUTs themselves have no DONT_TOUCH.
set dt_cell_count [llength [get_cells -hier -quiet -filter {DONT_TOUCH == TRUE}]]
set dt_net_count [llength [get_nets -hier -quiet -filter {DONT_TOUCH == TRUE}]]
if {$dt_cell_count > 0} {
    puts "WARNING: $dt_cell_count cells with DONT_TOUCH remain — remap may be blocked"
}
if {$dt_net_count > 0} {
    puts "WARNING: $dt_net_count nets with DONT_TOUCH remain — remap WILL be blocked"
    puts "  Net DONT_TOUCH is set independently of cell DONT_TOUCH."
    puts "  Add to timing_fixes.xdc: set_property DONT_TOUCH FALSE \[get_nets -hier -quiet -filter {DONT_TOUCH == TRUE}]"
}

# 4. Run opt_design — choose directive based on fix types:
#    - No LUT_REMAP/CARRY_REMAP properties → opt_design (default)
#    - LUT_REMAP present → opt_design -directive ExploreWithRemap
opt_design -directive ExploreWithRemap

place_design
phys_opt_design
route_design
```

IMPORTANT: The `<path_to_opt.dcp>` must be the post-synthesis/post-opt checkpoint,
not the routed checkpoint. Starting from a routed DCP would skip optimization
opportunities for the new constraints.

## Post-rerun

After the run completes, proceed to [reference/validate.md](validate.md) for result comparison.

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc</sub></p>
<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
