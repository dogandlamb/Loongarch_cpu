# Long Logic Fix Reference

## Decision Logic

For each path classified as Long Logic (`logic_levels > 8`):

### Step 1 — Check DONT_TOUCH

> **⚠️ Remap regions are bounded by FFs.** `opt_design` remap defines optimization
> regions between sequential elements (flip-flops). DONT_TOUCH on the **bounding
> registers** (startpoint/endpoint FFs, or any register driving sideband inputs to
> the chain) makes the entire combinational cone "constrained." The remap engine
> will skip all logic in that region — even if the LUTs themselves have no
> DONT_TOUCH. You must check and remove DONT_TOUCH from bounding registers, not
> just from the combinational cells on the path.

#### Step 1a — Check cells directly on the path (combinational and sequential)

```tcl
set path [get_timing_paths -from <startpoint> -to <endpoint>]
foreach c [get_cells -of_objects $path] {
    set dt [get_property DONT_TOUCH $c]
    if {$dt == 1} { puts "DONT_TOUCH blocking: $c (seq=[get_property IS_SEQUENTIAL $c])" }
}
```

#### Step 1b — Check bounding registers and sideband drivers

The startpoint and endpoint registers define the remap region boundary. Also check
all registers that drive inputs to the combinational cells on the path — these are
sideband inputs that also form the remap region boundary.

```tcl
# Bounding registers (startpoint and endpoint)
set sp_cell [get_cells -of [get_pins [get_property STARTPOINT_PIN $path]]]
set ep_cell [get_cells -of [get_pins [get_property ENDPOINT_PIN $path]]]
foreach reg [list $sp_cell $ep_cell] {
    if {[get_property DONT_TOUCH $reg] == 1} {
        puts "DONT_TOUCH on bounding register: $reg — will block remap of entire region"
    }
}

# Sideband driver registers (regs feeding combo cells on the path but not the startpoint)
set combo_on_path [get_cells -filter {IS_SEQUENTIAL == FALSE} -of_objects $path]
foreach c $combo_on_path {
    foreach ipin [get_pins -filter {DIRECTION==IN} -of $c] {
        set drv [get_cells -quiet -of [get_pins -quiet -filter {DIRECTION==OUT} \
                 -of [get_nets -of $ipin]]]
        if {$drv ne "" && [get_property IS_SEQUENTIAL $drv] == 1 && \
            [get_property DONT_TOUCH $drv] == 1} {
            puts "DONT_TOUCH on sideband driver: $drv — add to removal list"
        }
    }
}
```

#### Step 1c — Remove DONT_TOUCH from cells AND nets

For ALL cells and nets identified above (combinational and sequential):

```tcl
set_property DONT_TOUCH FALSE [get_cells <cell>]
set_property DONT_TOUCH FALSE [get_nets <net>]
```

⚠️ **XDC COMPATIBILITY**: `reset_property` is **NOT supported** in XDC constraint files ([Designutils 20-1307]). Always use `set_property DONT_TOUCH FALSE` in XDC. `reset_property` only works in the Tcl console or sourced Tcl scripts (non-XDC).

**Critical — cells AND nets:** RTL attributes like `(* DONT_TOUCH = "true" *)` set
DONT_TOUCH on **both** the cell AND its output net independently. You must remove
DONT_TOUCH from both. If you only clear cell DONT_TOUCH but leave net DONT_TOUCH
intact, `opt_design -remap` will still report "constrained objects preventing
optimization" and remap 0 cells — even when LUT_REMAP TRUE is set on every target.

When many cells/nets have DONT_TOUCH (e.g., designs with pervasive DT attributes),
use blanket removal before applying LUT_REMAP:

```tcl
set_property DONT_TOUCH FALSE [get_cells -hier -quiet -filter {DONT_TOUCH == TRUE}]
set_property DONT_TOUCH FALSE [get_nets -hier -quiet -filter {DONT_TOUCH == TRUE}]
```

GUARDRAIL: KEEP is synthesis-only — no XDC syntax exists (UG912). KEEP does NOT persist to the post-synthesis netlist. If long logic was caused by KEEP, the cells exist but have no KEEP property to remove. Proceed to cell-type fixes below.

### Step 2 — Cell-type fixes (additive, apply all that match)

#### Option A — LUT remapping

**When:** Cascaded small LUTs (LUT1–LUT4) that could merge into fewer LUT6s. Also effective for chains originally created by KEEP.

```tcl
set_property LUT_REMAP TRUE [get_cells {<lut1> <lut2> <lut3> ...}]
```

#### Option B — CARRY remapping

**When:** Short CARRY8 chains (1–2 cells, non-cascaded).

```tcl
set_property CARRY_REMAP 2 [get_cells <carry_cell>]
```

#### Option C — SRL input register extraction

**When:** Path ends at an SRL with high delay.

```tcl
set_property SRL_STAGES_TO_REG_INPUT 1 [get_cells <srl_cell>]
```

#### Option D — Control set remapping

**When:** Path ends at a CE, S, or R pin (not D) with high route delay.

```tcl
set_property CONTROL_SET_REMAP ALL [get_cells <endpoint_reg>]
```

After setting any property-based fix, add to the XDC header:
```
# Run after sourcing: opt_design -property_opt_only
```

#### Option E — QoR suggestions

**When:** `report_qor_suggestions` proposed fixes for cells on this path.

Include those property settings directly.

#### Option F — Multicycle path

**When:** Logic depth is correct but timing is met with a multi-cycle protocol (RTL enable/valid handshake).

```tcl
# Always constrain pins, not cells, to avoid affecting CE/EN paths (UG1292)
set_multicycle_path 2 -setup -from [get_pins <source_reg>/C] -to [get_pins <dest_reg>/D]
set_multicycle_path 1 -hold  -from [get_pins <source_reg>/C] -to [get_pins <dest_reg>/D]
```

### Step 3 — `opt_design` switches for logic depth reduction

After sourcing property-based fixes, select the appropriate `opt_design` invocation.
These switches are **not** XDC constraints — they are Tcl commands to run after sourcing the XDC.

**IMPORTANT — Rerun integration:** The property-only and full re-implementation flows in
[reference/rerun-strategy.md](rerun-strategy.md) must include `opt_design` with the
appropriate directive when LUT_REMAP or CARRY_REMAP properties are set. Setting these
properties without running `opt_design` does nothing — the cascaded LUTs remain unchanged.
For the project flow, configure the run before launching:
```tcl
set_property -name {STEPS.OPT_DESIGN.ARGS.DIRECTIVE} -value {ExploreWithRemap} -objects [get_runs impl_1]
```

**IMPORTANT:** When any specific switch is passed to `opt_design`, all default optimizations
(retarget, propconst, sweep, bram_power_opt) are **disabled** unless explicitly included.
Use `-property_opt_only` to run only property-driven fixes, or a `-directive` for a curated preset.

#### Property-only (safest, narrowest scope)

When you only set cell properties (LUT_REMAP, CARRY_REMAP, CONTROL_SET_REMAP, etc.):

```tcl
opt_design -property_opt_only
```

Runs *only* the optimizations triggered by properties on design objects (UG912).
Cannot be combined with any other switch.

#### Targeted switches (when property-only is insufficient)

| Switch | Effect | When to use |
|--------|--------|-------------|
| `-remap` | Combines cascaded LUTs into fewer LUT6s to reduce logic depth | Primary choice for long-logic LUT chains |
| `-aggressive_remap` | More exhaustive version of `-remap`; deeper LUT merging at expense of runtime (UG904) | When `-remap` alone doesn't reduce enough levels |
| `-resynth_remap` | Timing-driven re-synthesis: replicates LUTs with fanout and collapses small LUTs into larger functions to reduce critical-path depth (UG904) | Best single switch for timing-critical long logic paths |
| `-carry_remap` | Converts CARRY primitives into LUTs | When short CARRY8 chains inflate level count |
| `-muxf_remap` | Converts MUXFs to LUT3s for improved routeability | When MUXF cells inflate level count (not on Versal) |
| `-control_set_merge` | Merges logically-equivalent control set drivers | When control-set fanout contributes to logic depth |

Combine desired switches in a single call. Example for long-logic with LUT chains:

```tcl
opt_design -remap -aggressive_remap -resynth_remap
```

#### Directives (curated presets, mutually exclusive with switches)

| Directive | Included optimizations | Best for |
|-----------|----------------------|----------|
| `ExploreWithRemap` | Explore + aggressive_remap | **Recommended first choice** for long logic. Multiple opt passes plus LUT remapping |
| `Explore` | Multiple passes of all default + extra optimizations | General improvement, no explicit remap |
| `ExploreArea` | Explore + resynth_area | Area reduction (fewer LUTs) — may also reduce depth |
| `ExploreSequentialArea` | Explore + resynth_seq_area | Reduces registers and related combinational logic |
| `RQS` | Applies suggestion from `report_qor_suggestions` | When QoR suggestions file is available |

```tcl
opt_design -directive ExploreWithRemap
```

**Note:** Directives cannot be combined with individual switches — they are mutually exclusive.

## Synthesis Recommendations (flag to user)

Not applicable as XDC constraints, but recommend for next synthesis run:
- Retiming: `BLOCK_SYNTH.RETIMING`, `RETIMING_FORWARD/BACKWARD`
- Synthesis directive: `synth_design -directive PerformanceOptimized` (logic level reduction at expense of area)
- `opt_design -directive ExploreWithRemap` or `-resynth_remap`

## Cascaded CARRY/MUXF Note

These inflate logic level counts but have low per-level delay. Verify with `report_design_analysis` before applying fixes — the path may not actually be the bottleneck.

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc</sub></p>
<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
