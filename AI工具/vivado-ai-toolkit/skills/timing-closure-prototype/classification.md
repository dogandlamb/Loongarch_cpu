# Path Classification Reference

## Step 1 — Collect reports

Run all of these via `vivado-mcp:vivado_execute`:

```tcl
report_timing_summary -max_paths 1000 -report_unconstrained -name timing_summary
report_clock_interaction -delay_type max -significant_digits 3 -name clock_interaction
report_cdc -name cdc_report
report_bus_skew -name bus_skew_report
report_design_analysis -logic_level_distribution -logic_level_dist_paths 5000 -name logic_levels
report_qor_suggestions -name qor_suggestions
```

## Step 1.5 — DONT_TOUCH census

Before classifying paths, inventory all DONT_TOUCH properties in the design.
This informs Phase 2 fix generation — DONT_TOUCH on registers bounding long-logic
paths blocks `opt_design` remap even when the combinational logic itself has no DT.

```tcl
set dt_seq   [llength [get_cells -hier -quiet -filter {DONT_TOUCH == TRUE && IS_SEQUENTIAL == TRUE}]]
set dt_combo [llength [get_cells -hier -quiet -filter {DONT_TOUCH == TRUE && IS_SEQUENTIAL == FALSE}]]
set dt_nets  [llength [get_nets  -hier -quiet -filter {DONT_TOUCH == TRUE}]]
puts "DONT_TOUCH census: $dt_seq sequential, $dt_combo combinational, $dt_nets nets"
```

Report this census in the USER GATE 1 analysis summary so the user sees it before
constraint generation. Flag any sequential DT cells that appear as startpoints or
endpoints of long-logic paths — these will need DT removal for remap to work.

## Step 2 — Extract per-path attributes

```tcl
set paths [get_timing_paths -max_paths 1000 -slack_lesser_than 0]
foreach p $paths {
    set slack       [get_property SLACK $p]
    set levels      [get_property LOGIC_LEVELS $p]
    set src_clock   [get_property STARTPOINT_CLOCK $p]
    set dst_clock   [get_property ENDPOINT_CLOCK $p]
    set startpoint  [get_property STARTPOINT_PIN $p]
    set endpoint    [get_property ENDPOINT_PIN $p]

    # Max fanout across all nets on the path
    set nets [get_nets -of_objects $p]
    set max_fo 0
    foreach n $nets {
        set fo [get_property FLAT_PIN_COUNT $n]
        if {$fo > $max_fo} { set max_fo $fo }
    }

    # SLR indices
    set src_cell [get_cells -of_objects [get_pins $startpoint]]
    set dst_cell [get_cells -of_objects [get_pins $endpoint]]
    set src_slr  [get_slrs -of_objects $src_cell]
    set dst_slr  [get_slrs -of_objects $dst_cell]

    # Route delay percentage
    set data_delay  [get_property DATAPATH_DELAY $p]
    set net_delay   [get_property DATAPATH_NET_DELAY $p]
    set route_pct   [expr {$data_delay > 0 ? ($net_delay / $data_delay) * 100.0 : 0}]
}
```

## Step 3 — Classify (first match wins)

Apply these rules in priority order. Each path gets exactly one category:

| Priority | Category | Condition |
|---|---|---|
| 1 | **CDC** | `src_clock` != `dst_clock` AND `report_clock_interaction` shows "Timed (unsafe)" or "No Common Clock" |
| 2 | **SLR Crossing** | `src_slr` != `dst_slr` AND `src_clock` == `dst_clock` |
| 3 | **High Fanout** | `max_fo` > 1000 AND `route_pct` > 80% |
| 4 | **Long Logic** | `levels` > threshold (see below) |

### Logic level thresholds

| Clock frequency | Threshold |
|---|---|
| > 250 MHz | > 6 levels |
| 100–250 MHz | > 8 levels |
| < 100 MHz | > 15 levels |

## Verification

Every failing path MUST be classified. If a path matches no category, tag it as:
```
# UNCLASSIFIED: <startpoint> -> <endpoint> slack=<slack>
```

Return the full classified list to the orchestrator (SKILL.md Phase 2).

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc</sub></p>
<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
