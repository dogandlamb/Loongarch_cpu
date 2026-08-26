# Validation Reference

After rerun completes, compare results against baseline and decide next action.

## Step 1 — Collect post-run metrics

```tcl
open_run impl_1
# Non-project: open_checkpoint <path_to_routed.dcp>

set post_wns  [get_property SLACK [get_timing_paths -max_paths 1]]
set post_tns  [expr {[join [get_property SLACK [get_timing_paths -max_paths 1000 -slack_lesser_than 0]] +]}]
set post_fail [llength [get_timing_paths -max_paths 1000 -slack_lesser_than 0]]
```

## Step 2 — Compare against baseline

| Metric | Baseline | Post-run | Delta |
|---|---|---|---|
| WNS (ns) | `baseline_wns` | `post_wns` | `post_wns - baseline_wns` |
| TNS (ns) | `baseline_tns` | `post_tns` | `post_tns - baseline_tns` |
| Failing paths | `baseline_fail` | `post_fail` | `post_fail - baseline_fail` |

## Step 3 — Check for methodology warnings

```tcl
report_methodology -name post_fix_methodology
```

Flag these critical warnings:
- **TIMING-6**: `set_max_delay` silently overridden by `set_clock_groups` or `set_false_path`
- **TIMING-7**: Conflicting timing exceptions
- **Any constraint referencing non-existent cells/nets** (typos in generated names)

## Step 4 — Check for regressions

```tcl
# New violations that didn't exist before
set new_paths [get_timing_paths -max_paths 1000 -slack_lesser_than 0]
```

Compare endpoint names against the original failing set. IF new endpoints appear that were not in the baseline → flag as regressions.

## Step 5 — Decide next action

| Condition | Action |
|---|---|
| `post_wns` >= 0 | **SUCCESS** — report to user, stop |
| `post_wns` improved AND iteration < 3 | **ITERATE** — back to Phase 1 with updated baseline |
| `post_wns` improved < 0.050 ns from previous | **PLATEAU** — escalate to user |
| `post_wns` worse than baseline | **REGRESSION** — revert constraints, escalate to user |
| Iteration == 3 AND still failing | **MAX ITERATIONS** — escalate to user |

### Plateau / regression escalation

Report to user:
1. Summary table (baseline vs. each iteration)
2. Remaining failing paths with categories
3. RTL recommendations:
   - CDC: XPM_CDC macros (`xpm_cdc_single`, `xpm_cdc_gray`, `xpm_cdc_handshake`)
   - SLR: AXI Register Slice IP in Multi-SLR-Crossing mode, add pipeline stages
   - Long Logic: retiming (`BLOCK_SYNTH.RETIMING`), re-architect combinational paths
   - High Fanout: restructure fanout tree in RTL, use dedicated CE fabric

## Report format

Present to the user after each iteration:

```
Timing Closure — Iteration <N>
──────────────────────────────
           Baseline    Current     Delta
WNS:       <val> ns    <val> ns    <+/-val> ns
TNS:       <val> ns    <val> ns    <+/-val> ns
Failing:   <N>         <N>         <+/-N>

Methodology warnings: <count>
Regressions detected: <yes/no>
Next action: <SUCCESS | ITERATE | ESCALATE>
```

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc</sub></p>
<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
