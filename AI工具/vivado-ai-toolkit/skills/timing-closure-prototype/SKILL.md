---
name: timing-closure-prototype
description: Analyzes a post-route Vivado design checkpoint, classifies failing timing paths, generates fix constraints, reruns implementation, and validates results. Iterates up to 3 times until timing closes or escalation is needed. Use when a user asks to fix timing violations, close timing, or analyze a routed DCP.
---

# Timing Closure

Three-phase iterative flow executed via `vivado-mcp:vivado_execute`.

```
Task Progress:
- [ ] Phase 1: Analyze post-route DCP
- [ ] Phase 2: Generate timing_fixes.xdc
- [ ] Phase 3: Rerun implementation & validate
```

## Phase 1 — Analyze

### 1.1 Open design

```tcl
open_run impl_1
# Non-project: open_checkpoint <path_to_routed.dcp>
```

VERIFY: Design is routed before proceeding.

### 1.2 Capture baseline

Before any fixes, record baseline metrics for later comparison:

```tcl
set baseline_wns  [get_property SLACK [get_timing_paths -max_paths 1]]
set paths_neg [get_timing_paths -max_paths 1000 -slack_lesser_than 0]
set baseline_fail [llength $paths_neg]
set baseline_tns 0.0
foreach p $paths_neg {
    set baseline_tns [expr {$baseline_tns + [get_property SLACK $p]}]
}
```

Store: `baseline_wns`, `baseline_tns`, `baseline_fail`.

EARLY EXIT: If `baseline_wns` >= 0 → report "No timing violations" and stop.

### 1.3 Collect reports & classify

Read [reference/classification.md](reference/classification.md) for detailed Tcl and classification rules.

Output: a list of failing paths, each tagged with exactly one category (CDC / SLR / High Fanout / Long Logic / Unclassified).

### USER GATE 1 — Analysis review

Present to the user:
- Baseline metrics (WNS, TNS, failing path count)
- Classification summary table: category, path count, worst slack, representative path per category
- Any unclassified paths flagged for attention

Then ask: **"Proceed to generate constraints for these violations?"**

Do NOT continue to Phase 2 until the user confirms.

---

## Phase 2 — Generate constraints

For each category with classified paths, read the corresponding reference and apply decision logic:

| Category | Reference |
|---|---|
| CDC | [reference/cdc-fixes.md](reference/cdc-fixes.md) |
| SLR Crossing | [reference/slr-fixes.md](reference/slr-fixes.md) |
| High Fanout | [reference/fanout-fixes.md](reference/fanout-fixes.md) |
| Long Logic | [reference/logic-fixes.md](reference/logic-fixes.md) |

Read ONLY the references for categories that have failing paths.

### Write timing_fixes.xdc

Use this exact structure:

```tcl
# ==============================================================================
# timing_fixes.xdc — Auto-generated constraints for timing closure
#
# BASELINE: WNS=<baseline_wns> | TNS=<baseline_tns> | Failing paths=<baseline_fail>
# ITERATION: <N> of 3
#
# VIOLATIONS FIXED:
#   CDC: N paths | SLR: N paths | Fanout: N paths | Logic: N paths | Unclassified: N
# ==============================================================================

# --- CDC Fixes ----------------------------------------------------------------

# --- SLR Crossing Fixes ------------------------------------------------------

# --- High Fanout Fixes --------------------------------------------------------

# --- Long Logic Fixes ---------------------------------------------------------

# --- Unclassified (manual review) ---------------------------------------------
```

Use real cell/net/clock names. No `<placeholder>` syntax.

VERIFY: `read_xdc -unmanaged timing_fixes.xdc` succeeds without Tcl errors.

### USER GATE 2 — Constraint review

Present to the user:
- The full contents of `timing_fixes.xdc`
- Summary: constraint count per category, rerun strategy that will be used

Then ask: **"Review the constraints above. Proceed to rerun implementation?"**

Do NOT continue to Phase 3 until the user confirms.

---

## Phase 3 — Rerun & validate

Read [reference/rerun-strategy.md](reference/rerun-strategy.md) to select and execute the rerun approach based on which fix types were generated.

After rerun completes, read [reference/validate.md](reference/validate.md) to compare results against baseline and decide next action:

- **Timing met** → report success, stop.
- **Improved but still failing** → iterate (back to Phase 1, max 3 iterations).
- **No improvement or regression** → escalate to user with RTL recommendations.

---

## Guardrails

Inviolable rules:

1. **DONT_TOUCH syntax**: Use `set_property DONT_TOUCH FALSE`. NEVER `set_property DONT_TOUCH 0`.
2. **DONT_TOUCH on bounding registers blocks remap**: Check and remove DONT_TOUCH from bounding registers when applying LUT_REMAP.
3. **KEEP is synthesis-only**: No XDC syntax exists. Cannot remove post-synthesis.
4. **CDC precedence**: `set_clock_groups` silently overrides `set_max_delay -datapath_only`. Use per-path `set_false_path` instead.
5. **Synchronous clocks**: Never apply async exceptions between frequency-related clocks. Use `set_multicycle_path`.
6. **Pblock intent**: Check purpose before deleting. Prefer expanding or removing specific cells.
7. **Multicycle pins**: Target `get_pins .../C` and `get_pins .../D`, not cells.
8. **SLR escalation**: Soft → Medium → Hard. Never skip to Laguna LOC+BEL.
9. **No placeholders**: Every constraint must use real design names.
10. **Iteration limit**: Maximum 3 iterations. After 3, escalate to user.

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc</sub></p>
