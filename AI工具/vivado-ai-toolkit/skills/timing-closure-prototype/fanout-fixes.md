# High Fanout Fix Reference

## Decision Logic

For each path classified as High Fanout (`max_fanout > 1000` AND `route_pct > 80%`):

### Step 1 — Check DONT_TOUCH

```tcl
get_property DONT_TOUCH [get_cells <driver_cell>]
get_property DONT_TOUCH [get_nets <high_fanout_net>]
```

IF DONT_TOUCH is TRUE → remove it first:

```tcl
set_property DONT_TOUCH FALSE [get_cells <driver_cell>]
set_property DONT_TOUCH FALSE [get_nets <high_fanout_net>]
```

GUARDRAIL: NEVER use `set_property DONT_TOUCH 0` — the string "0" is truthy in Vivado (UG903). Use `FALSE`.

⚠️ **XDC COMPATIBILITY**: `reset_property` is **NOT supported** in XDC constraint files ([Designutils 20-1307]). Always use `set_property DONT_TOUCH FALSE` in XDC. `reset_property` only works in the Tcl console or sourced Tcl scripts (non-XDC).

### Step 2 — Apply MAX_FANOUT

```tcl
set_property MAX_FANOUT 256 [get_nets <high_fanout_net>]
```

### Alternative — CE replication

IF the high-fanout net is a clock enable (CE) driving sequential cells:

```tcl
# Post-placement option (not an XDC constraint, add as comment):
# phys_opt_design -force_replication_on_nets [get_nets <net>]
```

## Verification

Before applying, confirm `route_pct > 80%`. If route delay is <50% of path delay, high fanout is NOT the bottleneck — reclassify as Long Logic.

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc</sub></p>
<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
