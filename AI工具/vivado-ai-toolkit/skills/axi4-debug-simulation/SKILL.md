---
name: axi4-debug
description: Debug AXI4 DUTs using Vivado simulation via MCP tools. Use this skill whenever the user asks to run simulations, find bugs, fix RTL, or debug AXI protocol violations — even if they don't use the word "simulation" explicitly. Also trigger when the user opens a Vivado project and asks why signals look wrong in a waveform, or asks to verify AXI4 protocol compliance.
---

# AXI4 Debug Workflow

## MCP Tools (never call in parallel — wait for each result)

| Tool | Purpose |
|------|---------|
| `mcp_vivado-mcp-se_vivado_start` | Launch Vivado session; returns `session_id` |
| `mcp_vivado-mcp-se_vivado_execute` | Run any TCL command |
| `mcp_vivado-mcp-se_vivado_stop` | Shut down the session |
| `mcp_vivado-mcp-se_vivado_log_messages` | Parse vivado.log for errors |
| `mcp_vivado-mcp-se_vivado_doc_search` | Search AMD/Xilinx docs |

## Essential TCL patterns

```tcl
open_project <path/to/project.xpr>
return [get_filesets]                                          # list filesets
set_property top <tb_name> [get_filesets <sim_set>]
launch_simulation -simset [get_filesets <sim_set>] -mode behavioral   # blocking
return [exec cat <proj>/<proj>.sim/<sim_set>/behav/xsim/simulate.log]
```

> `launch_simulation` is blocking — no `wait_on_run` needed. Use `wait_for_output=true`, generous `timeout_seconds`.

## Mandatory Per-Bug Checklist

> **EVERY bug MUST complete ALL steps below. No exceptions. No shortcuts.**
> Do NOT skip waveforms even if the log gives enough information to diagnose.
> Do NOT skip the PASS waveform even if the log says PASS.
> The waveform is a deliverable, not a debugging aid — it MUST exist for every bug.

For each testbench, complete this checklist in order:

- [ ] **Run simulation** — `launch_simulation`, read `simulate.log`
- [ ] **FAIL waveform** — `create_wave_config <tb>_FAIL`, add color-coded signals per assertion channel
- [ ] **PAUSE** — present assertion + waveform to user, wait for A/B/C
- [ ] **Read RTL** — only after user says "fix it"
- [ ] **Apply fix** — `replace_string_in_file`, minimal one-line change
- [ ] **Re-run simulation** — `close_sim`, `launch_simulation`, verify PASS in log
- [ ] **PASS waveform** — `create_wave_config <tb>_PASS`, same signals/colors as FAIL
- [ ] **PAUSE** — present fix summary, wait for A/B

Proceeding to the next testbench with any unchecked box is a workflow violation.

## Workflow

### Step 0: Start Vivado and open the project

1. `mcp_vivado-mcp-se_vivado_start` with `session_type="general"`, `working_dir`=project root, full Vivado path. Note `session_id`.
2. If `.xpr` path unknown: `find <working_dir> -name "*.xpr" -maxdepth 4` in terminal, then `open_project <path>`.
3. `return [get_filesets]` — present to user and confirm which sim fileset to run.

### Step 1: Run → waveform → pause (one testbench at a time)

> **CRITICAL: Never batch-run all testbenches. For each one: run → open waveform → STOP and ask the user before touching any RTL.**
> **NEVER read RTL source files before the user has seen the waveform and said "fix it".**

#### 1a. Run simulation
```tcl
set_property top <tb_name> [get_filesets <sim_set>]
launch_simulation -simset [get_filesets <sim_set>] -mode behavioral
```

#### 1b. Read log
```tcl
return [exec cat <proj>.sim/<sim_set>/behav/xsim/simulate.log]
```

From the log, extract:
- The **assertion name** (e.g. `AXI4_ERRM_AWVALID_RESET`)
- The **failure time** (e.g. `205 ns`)
- Which **AXI channel** is implicated (AW/W/B/AR/R) — this determines which signals to add in the next step

If the log shows no assertion errors, skip 1c–1d and go straight to Step 3 (_PASS).

#### 1c. Open _FAIL waveform — immediately while snapshot is live

> **MANDATORY** — This step MUST be executed for every failing testbench. Do NOT skip this step even if you already know the root cause from the log. The waveform is a required deliverable.

> ⚠️ Use `create_wave_config` after `launch_simulation`. `open_wave_database` is only for a static WDB in a fresh session with no running sim.

The `foreach` close **must be its own separate `mcp_vivado-mcp-se_vivado_execute` call** — combining it with other commands in one multi-line call causes `$wc` to fail:
```tcl
foreach wc [get_wave_configs] { close_wave_config -force $wc }
```
Then in the next call: create config + add signals.

**Choose signals based solely on the assertion channel from the log (see color table in Step 4). Do NOT read RTL files at this point.**

To find `<dut_inst>`, read only the TB file (not the RTL) and look for the DUT instantiation name. The skill does **not** assume anything about internal signal names — discover them from the live snapshot.
```tcl
# Call 1 — create the config
create_wave_config <tb_name>_FAIL
```
```tcl
# Call 2 — discover and add any FSM-like state signal (no assumption about name).
# Probes a few common patterns; adds the first one that exists. Silent if none.
foreach pat {*state_q *state_r *cur_state *state} {
    set hits [get_objects -quiet /<tb_name>/<dut_inst>/$pat]
    if {[llength $hits]} { add_wave -color white [lindex $hits 0]; break }
}
```
```tcl
# Call 3 — clocks/reset at top, then channel signals grouped by AXI channel.
# Use add_wave_group per channel so each is collapsible in the viewer.
# Add ONLY the groups for channels implicated by the assertion (per Step 4 table).
# IMPORTANT: capture the group object returned by add_wave_group into a var,
# and pass that var to `add_wave -into $g` — passing a quoted name like
# `-into "AW Channel"` fails ("expects a single object, but 2 were given")
# because Vivado tokenises the string. One group per execute call.
# Channel signals must be at TB top level — e.g. /<tb_name>/axi_awvalid —
# NOT /<tb_name>/<dut_inst>/m_axi_awvalid (DUT always_comb ports may be absent
# from XSim debug snapshot).
add_wave /<tb_name>/aclk; add_wave /<tb_name>/aresetn
```
```tcl
set g [add_wave_group {AW Channel}]
add_wave -into $g -color yellow /<tb_name>/axi_awvalid /<tb_name>/axi_awready /<tb_name>/axi_awaddr /<tb_name>/axi_awlen
```
```tcl
set g [add_wave_group {W Channel}]
add_wave -into $g -color orange /<tb_name>/axi_wvalid /<tb_name>/axi_wready /<tb_name>/axi_wdata /<tb_name>/axi_wlast /<tb_name>/axi_wstrb
```
```tcl
set g [add_wave_group {B Channel}]
add_wave -into $g -color cyan /<tb_name>/axi_bvalid /<tb_name>/axi_bready /<tb_name>/axi_bresp
```
```tcl
set g [add_wave_group {AR Channel}]
add_wave -into $g -color magenta /<tb_name>/axi_arvalid /<tb_name>/axi_arready /<tb_name>/axi_araddr /<tb_name>/axi_arlen
```
```tcl
set g [add_wave_group {R Channel}]
add_wave -into $g -color green /<tb_name>/axi_rvalid /<tb_name>/axi_rready /<tb_name>/axi_rdata /<tb_name>/axi_rlast
```

> ℹ️ **Wave groups** keep the viewer readable: each AXI channel becomes one expandable row (`AW Channel`, `W Channel`, ...) instead of 20+ flat signals. Use the same group names and colours in both `_FAIL` and `_PASS` configs so they look identical side by side. Existence-guard any signal that may not be present (same `get_objects -quiet` pattern as the FSM state) — wrap each `add_wave -into` line if you're unsure the wire exists at TB top level.

> ⚠️ **Why discovery, not a hardcoded name?** A generic skill cannot know whether the DUT has an FSM, what its state register is called, or whether it survives `--debug typical` optimization. The `foreach` probe handles all three cases silently:
> - Common name found and visible → added.
> - DUT has no FSM, or name doesn't match patterns → silently skipped, no console noise.
>
> Do **NOT** use `catch {add_wave ...}` for this — Vivado prints `[Wavedata 42-471] ERROR` to the TCL console *before* `catch` sees it (the message is emitted via Vivado's message system, not as a TCL error). Only `get_objects -quiet` actually suppresses the console error.
>
> Two critical rules:
> 1. **Create the wave config first** — `create_wave_config` must be in its own preceding execute call before any `add_wave`.
> 2. **Own execute call for the discovery loop** — send the `foreach` block as the only commands in one `mcp_vivado-mcp-se_vivado_execute` call. Don't combine with unrelated multi-line blocks.

#### 1d. Diagnose and pause

- From the **simulation log alone**, summarise: assertion name, failure time, which AXI rule was violated.
- Do **NOT** read RTL source at this stage. Do NOT speculate about the root cause beyond what the log says.
- **HARD STOP — MANDATORY PAUSE.** After printing the pause message below, you MUST wait for the user's explicit reply (A, B, or C). Do NOT read RTL, do NOT apply any change, do NOT proceed to any next step until the user responds:
```
Waveform open: <tb_name>_FAIL
Assertion: <assertion_name> at <T> ns
Violation: <one-line description from the assertion message, not from RTL reading>

What would you like to do?
  A) fix it   — read the RTL and apply the minimal fix
  B) skip     — leave this bug as-is and move to the next testbench
  C) details  — add more waveform signals before deciding

Reply A, B, or C.
```

### Step 2: Apply RTL fix (on "fix it" confirmation only)

Only on **"fix it"**: **now** read the RTL source file to locate the exact buggy line. Use the assertion name and AXI protocol rule (from Step 4 reference) to guide your diagnosis — identify which signal violates which rule, then trace the logic in RTL that drives that signal. Apply the minimal one-line change with `replace_string_in_file` (3–5 lines of context before/after). Do NOT apply speculative fixes — the root cause must be confirmed by reading the RTL.

### Step 3: Re-run and show _PASS waveform

> **MANDATORY** — This step MUST be executed after every fix. Do NOT just check the log and move on. The PASS waveform visually confirms the fix and is a required deliverable.

```tcl
close_sim -force
launch_simulation -simset [get_filesets <sim_set>] -mode behavioral
```

Verify PASS in `simulate.log`, then close stale _FAIL config (its snapshot is now overwritten by the re-run):
```tcl
foreach wc [get_wave_configs] { close_wave_config -force $wc }
```
Then create `<tb_name>_PASS` with the same signals and colors as the _FAIL config.

> ⚠️ **Side-by-side FAIL vs PASS via TCL is NOT possible.** `add_wave` always draws from the live snapshot — `open_wave_database` does not feed signals into `add_wave`. The correct workflow is sequential: show _FAIL while it's live → close → re-run → show _PASS.

Present the fix summary and **HARD STOP — MANDATORY PAUSE**: do NOT proceed to the next testbench until the user explicitly replies A or B:
```
✔ FIXED: <tb_name>
  Assertion: <name> | Was: <buggy line> | Now: <fixed line> | Result: PASS

What would you like to do next?
  A) continue      — proceed to the next testbench
  B) show signals  — re-open waveform with additional signals before continuing

Reply A or B.
```

### Step 4: AXI4 Assertion Reference (ARM DUI 0534B / PG101)

Common assertion names that may appear in simulation logs, organized by channel:

**Write Address Channel (AW)**
- `AXI4_ERRM_AWVALID_RESET` -- AWVALID must be LOW on the first cycle after reset de-assertion
- `AXI4_ERRM_AWVALID_STABLE` -- AWVALID must stay HIGH until AWREADY is asserted
- `AXI4_ERRM_AWADDR_STABLE` -- AWADDR must remain stable while AWVALID is HIGH and AWREADY is LOW
- `AXI4_ERRM_AWLEN_STABLE` -- AWLEN must remain stable while AWVALID is HIGH and AWREADY is LOW
- `AXI4_ERRM_AWADDR_BOUNDARY` -- A write burst cannot cross a 4 KB boundary
- `AXI4_ERRM_AWADDR_WRAP_ALIGN` -- WRAP bursts require an aligned start address
- `AXI4_ERRM_AWSIZE` -- Transfer size must not exceed the data bus width
- `AXI4_ERRM_AWBURST` -- AWBURST value 2'b11 is reserved and not permitted
- `AXI4_ERRM_AWLEN_WRAP` -- WRAP bursts must have length 2, 4, 8, or 16
- `AXI4_ERRM_AWLEN_FIXED` -- FIXED bursts cannot exceed 16 beats
- `AXI4_ERRM_AW*_X` -- X-propagation on any AW signal when AWVALID is HIGH
- `AXI4_ERRS_AWREADY_X` -- X on AWREADY when not in reset

**Write Data Channel (W)**
- `AXI4_ERRM_WVALID_RESET` -- WVALID must be LOW on the first cycle after reset de-assertion
- `AXI4_ERRM_WVALID_STABLE` -- WVALID must stay HIGH until WREADY is asserted
- `AXI4_ERRM_WDATA_STABLE` -- WDATA must remain stable while WVALID is HIGH and WREADY is LOW
- `AXI4_ERRM_WDATA_NUM` -- Number of write data beats must match AWLEN
- `AXI4_ERRM_WSTRB` -- Write strobes must only assert for valid byte lanes
- `AXI4_ERRM_WLAST_STABLE` -- WLAST must remain stable while WVALID is HIGH and WREADY is LOW
- `AXI4_ERRM_W*_X` -- X-propagation on any W signal when WVALID is HIGH
- `AXI4_ERRS_WREADY_X` -- X on WREADY when not in reset

**Write Response Channel (B)**
- `AXI4_ERRS_BVALID_RESET` -- BVALID must be LOW on the first cycle after reset de-assertion
- `AXI4_ERRS_BVALID_STABLE` -- BVALID must stay HIGH until BREADY is asserted
- `AXI4_ERRS_BRESP_STABLE` -- BRESP must remain stable while BVALID is HIGH and BREADY is LOW
- `AXI4_ERRS_BRESP_AW` -- Slave must not assert BVALID before the write address handshake
- `AXI4_ERRS_BRESP_WLAST` -- Slave must not assert BVALID before the last write data handshake
- `AXI4_ERRS_BRESP_EXOKAY` -- EXOKAY response only for exclusive write accesses
- `AXI4_ERRS_BRESP_ALL_DONE_EOS` -- All write addresses must have a matching response at end of simulation
- `AXI4_ERRS_B*_X` -- X-propagation on any B signal when BVALID is HIGH

**Read Address Channel (AR)**
- `AXI4_ERRM_ARVALID_RESET` -- ARVALID must be LOW on the first cycle after reset de-assertion
- `AXI4_ERRM_ARVALID_STABLE` -- ARVALID must stay HIGH until ARREADY is asserted
- `AXI4_ERRM_ARADDR_STABLE` -- ARADDR must remain stable while ARVALID is HIGH and ARREADY is LOW
- `AXI4_ERRM_ARADDR_BOUNDARY` -- A read burst cannot cross a 4 KB boundary
- `AXI4_ERRM_ARLEN_WRAP` -- WRAP bursts must have length 2, 4, 8, or 16
- `AXI4_ERRM_ARSIZE` -- Transfer size must not exceed the data bus width
- `AXI4_ERRM_AR*_X` -- X-propagation on any AR signal when ARVALID is HIGH
- `AXI4_ERRS_ARREADY_X` -- X on ARREADY when not in reset

**Read Data Channel (R)**
- `AXI4_ERRS_RVALID_RESET` -- RVALID must be LOW on the first cycle after reset de-assertion
- `AXI4_ERRS_RVALID_STABLE` -- RVALID must stay HIGH until RREADY is asserted
- `AXI4_ERRS_RDATA_STABLE` -- RDATA must remain stable while RVALID is HIGH and RREADY is LOW
- `AXI4_ERRS_RDATA_NUM` -- Number of read data beats must match ARLEN
- `AXI4_ERRS_RID` -- Read data ID must match an outstanding read transaction
- `AXI4_ERRS_RLAST_ALL_DONE_EOS` -- All outstanding read bursts must complete at end of simulation
- `AXI4_ERRS_R*_X` -- X-propagation on any R signal when RVALID is HIGH

**Recommendations (not errors, warnings)**
- `AXI4_RECS_AWREADY_MAX_WAIT` -- AWREADY should assert within MAXWAITS cycles
- `AXI4_RECS_WREADY_MAX_WAIT` -- WREADY should assert within MAXWAITS cycles
- `AXI4_RECS_ARREADY_MAX_WAIT` -- ARREADY should assert within MAXWAITS cycles
- `AXI4_RECM_BREADY_MAX_WAIT` -- BREADY should assert within MAXWAITS cycles
- `AXI4_RECM_RREADY_MAX_WAIT` -- RREADY should assert within MAXWAITS cycles

## Waveform signal color scheme

Add `aclk` and `aresetn` at the top, the FSM state (guarded with `get_objects -quiet`), and AXI channel signals **bundled into per-channel wave groups** using `add_wave_group` + `add_wave -into "<group>"`. Only add groups for channels implicated by the assertion. Do **not** use `add_wave -r`. Supported colors: `yellow`, `orange`, `cyan`, `magenta`, `red`, `green`, `white`.

> ⚠️ **Always add AXI channel signals at the TB top level** (e.g. `/tb_axi_master_bug1/axi_wlast`), not from the DUT sub-hierarchy (e.g. `/tb_axi_master_bug1/u_dut/m_axi_wlast`). XSim `--debug typical` does not capture `always_comb`-driven ports inside sub-modules, making them invisible in the wave config. Use the TB-level `wire` names (typically `axi_awvalid`, `axi_wlast`, etc.) which are always present.

| Assertion / channel | Group name | Signals | Color |
|---|---|---|---|
| `AW*` violations (incl. `AWVALID_RESET`) | `AW Channel` | `awvalid`, `awready`, `awaddr`, `awlen` | `yellow` |
| `W*` violations (incl. `WLAST`, `WDATA_X`) | `W Channel` | `wvalid`, `wready`, `wdata`, `wlast`, `wstrb` | `orange` |
| `B*` violations / `WCAM_OVERFLOW` | `B Channel` | `bvalid`, `bready`, `bresp` | `cyan` |
| `AR*` violations | `AR Channel` | `arvalid`, `arready`, `araddr`, `arlen` | `magenta` |
| `R*` violations | `R Channel` | `rvalid`, `rready`, `rdata`, `rlast` | `green` |
| FSM state (auto-discovered, may be absent) | _(top level, no group)_ | `<dut_inst>/*state*` | `white` |

## Step 5: Final summary table

After all testbenches pass, produce:

| # | Testbench | Assertion | Failure time | Root cause | Fix applied | Result |
|---|-----------|-----------|--------------|------------|-------------|--------|
| 1 | `<tb>` | `<assertion>` | `<T> ns` | `<root cause>` | `<change>` | ✔ PASS |

## Step 6: Stop Vivado

`mcp_vivado-mcp-se_vivado_stop` with the `session_id`.

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc</sub></p>
<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
