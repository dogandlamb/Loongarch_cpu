---
name: bd-vio-insertion
description: >
  Inserts VIO (Virtual Input/Output) debug cores into Vivado IP integrator Block Designs
  to enable real-time control and monitoring of internal signals via JTAG. VIO output probes
  drive control signals (enables, resets, mux selects) into the design; VIO input probes
  read status signals (counters, flags, fill levels) out. Supports VIO v3.0 (PG159) for
  7 Series/UltraScale/UltraScale+/Zynq and AXIS-VIO (PG364) for Versal. Use when user
  asks to "add VIO to block design", "insert virtual I/O", "control signals from JTAG",
  "add debug switches/buttons/LEDs to BD", "drive internal signals", "monitor status with
  VIO", "add VIO probes", or "replace board I/O with VIO". Also trigger for "need to
  control a reset from hardware manager", "toggle enable signal remotely", or "read back
  counter value in hardware".
---

# BD VIO Insertion

## Overview

**Purpose:** Insert VIO (Virtual Input/Output) debug cores into Vivado IP integrator Block Designs, connecting output probes to drive control signals and input probes to monitor status signals — replacing or augmenting physical board I/O (buttons, switches, LEDs) with JTAG-accessible virtual controls.

**Why VIO instead of ILA?** ILA captures high-speed waveforms into trace buffers (read-only observation). VIO provides **bidirectional real-time interaction**: you can both read design status AND write control values from the Vivado Hardware Manager, with no trace buffer or BRAM required.

**Output:** `vivado_agentic_ai_reports/bd-vio-insertion/`
- `bd_vio_summary.rpt` — summary of VIO cores added and probe connections
- `REPORT.md` — markdown report with **copy-pasteable Tcl** for reproducing the VIO insertion

**Prerequisites:** An open Vivado project with a Block Design containing signals the user wants to control or monitor.

**Output format:** The REPORT.md **must** include copy-pasteable Tcl commands that reproduce the exact VIO insertion performed, using ACTUAL design names from the BD.

---

## Prerequisites

| Requirement | Details |
|---|---|
| Vivado version | 2020.2+ (2023.1+ recommended for Versal AXIS-VIO) |
| Target family | 7 Series, UltraScale, UltraScale+, Zynq, Zynq MPSoC, Versal |
| Design state | Block Design must be open in IP integrator (pre-synthesis) |
| Open project | A Vivado project with at least one Block Design |
| Vivado session | Connected via MCP Vivado bridge |

---

## Parameter Discovery (MANDATORY FIRST STEP)

⚠️ **You MUST execute the discovery commands below BEFORE configuring VIO IPs — do NOT skip this step.** The parameter tables in this skill are a baseline reference only. Your Vivado version and target device may have different valid values, additional parameters, or different defaults.

**For VIO (non-Versal):**

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 temp_vio_discover; report_property [get_bd_cells temp_vio_discover] CONFIG.*
```

**For AXIS-VIO (Versal):**

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_vio:1.0 temp_vio_discover; report_property [get_bd_cells temp_vio_discover] CONFIG.*
```

To probe valid values for any enum parameter:

```tcl
catch {set_property CONFIG.<PARAM_NAME> __PROBE__ [get_bd_cells temp_vio_discover]} msg; puts $msg
```

After discovery, query actual ports to verify pin names before connecting:

```tcl
foreach pin [get_bd_pins -of_objects [get_bd_cells temp_vio_discover]] { puts "$pin | [get_property DIR $pin] | [get_property LEFT $pin]:[get_property RIGHT $pin]" }
```

Delete the temporary cell after discovery:

```tcl
delete_bd_objs [get_bd_cells temp_vio_discover]
```

---

## Efficiency Guidelines

- **Pass `session_id`** to every `vivado_execute` call.
- **Write reports to file** — give a short summary in chat only.
- **Read reports efficiently** — use `grep`/`head` via terminal for large outputs.
- **Use single-line semicolon-chained Tcl** for `vivado_execute` calls.
- **Do NOT** retry failed Tcl with different syntax. Report the error and stop.

---

## Key Concepts

### VIO vs ILA — When to Use Which

| Feature | VIO | ILA |
|---|---|---|
| **Direction** | Bidirectional (read + write) | Read-only (capture) |
| **Speed** | Low bandwidth (refreshes periodically via JTAG) | High-speed waveform capture |
| **Storage** | No BRAM/URAM required | Requires BRAM/URAM for trace buffer |
| **Use case** | Virtual buttons, switches, LEDs, enables, resets, mux selects | Protocol analysis, timing debug, signal waveforms |
| **Probes** | `probe_in` (design→VIO, read status), `probe_out` (VIO→design, drive control) | `probe` (design→ILA, capture only) |

### VIO Probe Types

| Probe | Direction | Purpose | Examples |
|---|---|---|---|
| **probe_in** | Design → VIO (input to VIO) | Monitor status signals | Counter values, FIFO fill levels, FSM states, error flags |
| **probe_out** | VIO → Design (output from VIO) | Drive control signals | Enables, resets, mux selects, pattern generators, threshold values |

### Device Family → IP Selection

| Device Family | IP Name | VLNV | Product Guide |
|---|---|---|---|
| 7 Series, UltraScale, UltraScale+, Zynq, Zynq MPSoC | VIO v3.0 | `xilinx.com:ip:vio:3.0` | PG159 |
| Versal | AXIS-VIO | `xilinx.com:ip:axis_vio:1.0` | PG364 |

### Debug Hub Requirement (Versal Only)

On Versal, AXIS-VIO requires an **AXI Debug Hub** (`axi_dbg_hub:2.0`) connected to the processing system (CIPS) via NoC or directly. The debug hub bridges all debug cores (ILA + VIO) to the JTAG scan chain. It is NOT auto-instantiated — you must add it explicitly. If a debug hub already exists for an ILA core, the same hub can serve VIO cores too (just connect the additional AXI-Stream port).

---

## Decision Tree

```
User wants to control/monitor BD signals via VIO
  ├─ Versal device?
  │   ├─ YES → Use AXIS-VIO (axis_vio:1.0) + AXI Debug Hub (axi_dbg_hub:2.0)
  │   └─ NO → Use VIO (vio:3.0)
  ├─ What signals to control? (probe_out — VIO drives into design)
  │   └─ Identify enable, reset, mux select, threshold signals
  ├─ What signals to monitor? (probe_in — design drives into VIO)
  │   └─ Identify counter, status, flag, fill-level signals
  └─ Follow Workflow A: VIO Instantiation
```

---

## Workflow A: VIO Instantiation Flow

**⚠️ CRITICAL: Execute steps SEQUENTIALLY. Wait for each command to complete.**

**⚠️ The workflow is incomplete until REPORT.md exists.** Do not end your turn before calling the write tool to create the file.

```
BD VIO Insertion Progress:
- [ ] Step 1: Open BD, identify control and status signals
- [ ] Step 2: Run parameter discovery, add VIO to BD, configure probes
- [ ] Step 3: Connect VIO probes to target signals
- [ ] Step 4: Validate BD, create report directory
- [ ] Step 5: Generate REPORT.md (call write tool), then short summary in chat
```

### Step 1: Open BD, Identify Control and Status Signals

Open (or query) the block design and identify signals suitable for VIO control/monitoring.

```tcl
set bd_name [current_bd_design]; puts "BD: $bd_name"; puts "--- Cells ---"; foreach c [get_bd_cells -hierarchical] { puts "  $c ([get_property VLNV $c])" }; puts "--- Nets ---"; foreach n [get_bd_nets] { set pins [get_bd_pins -of_objects $n]; set left [get_property LEFT [lindex $pins 0]]; set right [get_property RIGHT [lindex $pins 0]]; puts "  $n  width=[$left:$right]  pins=$pins" }
```

**Classify signals into control (probe_out) vs status (probe_in):**

| Signal Type | VIO Probe | Reasoning |
|---|---|---|
| Enable/disable | `probe_out` | Agent drives enable on/off |
| Reset | `probe_out` | Agent asserts/deasserts reset |
| Mux select | `probe_out` | Agent selects data path |
| Pattern/mode select | `probe_out` | Agent selects operating mode |
| Threshold value | `probe_out` | Agent sets comparison threshold |
| Counter value | `probe_in` | Agent reads current count |
| FIFO fill level | `probe_in` | Agent monitors queue depth |
| FSM state | `probe_in` | Agent reads current state |
| Error/status flags | `probe_in` | Agent checks for errors |
| Done/busy signals | `probe_in` | Agent polls completion |

**Ask the user** which signals to control/monitor if not specified.

### Step 2: Add VIO to BD and Configure Probes

**Run parameter discovery first** (see Parameter Discovery section above).

**For non-Versal (VIO v3.0):**

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0; set_property -dict [list CONFIG.C_NUM_PROBE_IN {<num_inputs>} CONFIG.C_NUM_PROBE_OUT {<num_outputs>} CONFIG.C_PROBE_OUT0_WIDTH {<width>} CONFIG.C_PROBE_OUT0_INIT_VAL {<hex_value>} CONFIG.C_PROBE_IN0_WIDTH {<width>}] [get_bd_cells vio_0]; puts "VIO created: vio_0"
```

**For Versal (AXIS-VIO):**

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_vio:1.0 axis_vio_0; set_property -dict [list CONFIG.C_NUM_PROBE_IN {<num_inputs>} CONFIG.C_NUM_PROBE_OUT {<num_outputs>} CONFIG.C_PROBE_OUT0_WIDTH {<width>} CONFIG.C_PROBE_OUT0_INIT_VAL {<hex_value>} CONFIG.C_PROBE_IN0_WIDTH {<width>}] [get_bd_cells axis_vio_0]; puts "AXIS-VIO created: axis_vio_0"
```

**Key configuration parameters (VIO v3.0 / AXIS-VIO share the same parameter names):**

| Parameter | Description | Valid Range | Notes |
|---|---|---|---|
| `CONFIG.C_NUM_PROBE_IN` | Number of input probe ports | 0–64 (up to 256 via Tcl) | At least one probe (in or out) required |
| `CONFIG.C_NUM_PROBE_OUT` | Number of output probe ports | 0–64 (up to 256 via Tcl) | At least one probe (in or out) required |
| `CONFIG.C_PROBE_IN<n>_WIDTH` | Width of input probe `n` | 1–256 | Replace `<n>` with probe index (0, 1, ...) |
| `CONFIG.C_PROBE_OUT<n>_WIDTH` | Width of output probe `n` | 1–256 | Replace `<n>` with probe index (0, 1, ...) |
| `CONFIG.C_PROBE_OUT<n>_INIT_VAL` | Initial value of output probe `n` | Hex with "0x" prefix | Value driven after device config/startup |
| `CONFIG.C_EN_PROBE_IN_ACTIVITY` | Enable activity detectors on inputs | 0, 1 | Detects transitions between JTAG samples |

**Setting initial values for output probes** — use this to define safe startup state:

```tcl
set_property CONFIG.C_PROBE_OUT0_INIT_VAL {0x1} [get_bd_cells vio_0]; puts "probe_out0 initializes to 1 (enabled at startup)"
```

### Step 3: Connect VIO Probes to Target Signals

**Connect output probes (VIO → design):**

VIO output probes are **source** pins. The target signal in the design must accept a driver. If the target signal already has a driver, you must disconnect it first or insert the VIO between the driver and load.

```tcl
# Connect VIO output probe to an unconnected input pin
connect_bd_net [get_bd_pins vio_0/probe_out0] [get_bd_pins <target_cell>/<input_pin>]; puts "probe_out0 → <target_cell>/<input_pin>"
```

**If the target pin already has a driver** (common for enable/reset signals that have constants or other sources), disconnect the existing driver first:

```tcl
# Find and disconnect existing net
set existing_net [get_bd_nets -of_objects [get_bd_pins <target_cell>/<input_pin>] -quiet]; if {$existing_net != ""} { delete_bd_objs $existing_net; puts "Disconnected existing net: $existing_net" }; connect_bd_net [get_bd_pins vio_0/probe_out0] [get_bd_pins <target_cell>/<input_pin>]; puts "probe_out0 now drives <target_cell>/<input_pin>"
```

**Connect input probes (design → VIO):**

VIO input probes are **sink** pins. Connect them to existing net drivers in the design.

```tcl
# Connect design signal to VIO input probe
connect_bd_net [get_bd_pins <source_cell>/<output_pin>] [get_bd_pins vio_0/probe_in0]; puts "<source_cell>/<output_pin> → probe_in0"
```

**Multi-bit signals:** Ensure the probe width matches the signal width. If widths don't match, use a Slice IP (`xlslice`) or Concat IP (`xlconcat`) to adapt.

**Connect clock:**

```tcl
connect_bd_net [get_bd_pins <clock_source>/<clk_pin>] [get_bd_pins vio_0/clk]; puts "VIO clk connected"
```

The VIO clock must be the same clock domain as the connected probe signals. All probe_in signals should be synchronous to this clock — asynchronous inputs cause unreliable readings.

### Step 4: Validate BD, Create Report Directory

```tcl
file mkdir vivado_agentic_ai_reports/bd-vio-insertion; validate_bd_design; save_bd_design; puts "BD validated and saved"
```

Use `timeout_seconds: 120` for `validate_bd_design`.

**Generate summary report:**

```tcl
set rpt_file "vivado_agentic_ai_reports/bd-vio-insertion/bd_vio_summary.rpt"; set fp [open $rpt_file w]; puts $fp "=== BD VIO Insertion Summary ==="; puts $fp "BD: [current_bd_design]"; puts $fp "Date: [clock format [clock seconds]]"; puts $fp ""; puts $fp "VIO Cores Added:"; foreach c [get_bd_cells -hierarchical -filter {VLNV =~ *vio*}] { puts $fp "  $c ([get_property VLNV $c])"; puts $fp "    probe_in count: [get_property CONFIG.C_NUM_PROBE_IN $c]"; puts $fp "    probe_out count: [get_property CONFIG.C_NUM_PROBE_OUT $c]" }; puts $fp ""; puts $fp "Probe Connections:"; foreach c [get_bd_cells -hierarchical -filter {VLNV =~ *vio*}] { foreach p [get_bd_pins -of_objects $c -filter {NAME =~ probe_*}] { set net [get_bd_nets -of_objects $p -quiet]; if {$net != ""} { set other_pins [get_bd_pins -of_objects $net -filter "NAME != [get_property NAME $p]"]; puts $fp "  $p <-> $net ($other_pins)" } } }; close $fp; puts "Report: $rpt_file"
```

### Step 5: Generate REPORT.md with Copy-Pasteable Tcl

**Action:** Call the write tool to create `vivado_agentic_ai_reports/bd-vio-insertion/REPORT.md`.

**MANDATORY contents:**
1. Summary of VIO cores added (instance name, probe counts, initial values)
2. Probe mapping table (which probe connects to which design signal, with purpose)
3. Clock connection
4. Complete copy-pasteable Tcl to reproduce the insertion from scratch
5. Hardware Manager interaction section (how to read/write probes at runtime)
6. Next steps (generate output products, synthesize, implement, generate bitstream/PDI)

**REPORT.md must include a Hardware Manager runtime section:**

```tcl
# ─── Runtime: Reading VIO Input Probes ───
refresh_hw_vio [get_hw_vios hw_vio_1]
get_property INPUT_VALUE [get_hw_probes <probe_name> -of_objects [get_hw_vios hw_vio_1]]

# ─── Runtime: Writing VIO Output Probes ───
set_property OUTPUT_VALUE <value> [get_hw_probes <probe_name> -of_objects [get_hw_vios hw_vio_1]]
commit_hw_vio [get_hw_probes {<probe_name>} -of_objects [get_hw_vios hw_vio_1]]
```

---

## Critical Parameter Relationships

### C_NUM_PROBE_IN / C_NUM_PROBE_OUT control port availability
- Setting `C_NUM_PROBE_IN {N}` creates ports `probe_in0` through `probe_in(N-1)`
- Setting `C_NUM_PROBE_OUT {N}` creates ports `probe_out0` through `probe_out(N-1)`
- At least one probe (input or output) must be specified — zero total is invalid

### C_PROBE_IN/OUT<n>_WIDTH must match connected signal width
- Width mismatch causes `connect_bd_net` to fail with width incompatibility error
- If widths don't match, insert `xlslice` (to extract bits) or `xlconcat` (to combine signals) between the design signal and the VIO probe

### C_PROBE_OUT<n>_INIT_VAL defines startup behavior
- Value is driven immediately after device configuration completes
- Format: hexadecimal with "0x" prefix (e.g., `0x1` for enable, `0x0` for disable)
- Choose safe defaults: enables typically start at 0 (off), resets at 1 (asserted)

### Clock domain must be consistent
- All probe_in signals should be synchronous to the VIO `clk` port
- Probe_out signals are driven synchronous to `clk`
- Connecting signals from a different clock domain creates a CDC crossing at the VIO probe port — this can cause metastability in the readings

### No BRAM or URAM required
- Unlike ILA, VIO uses no trace buffer storage
- Resource cost is minimal: primarily LUTs and FFs for probe registers and JTAG interface

---

## ⚠️ MANDATORY: Design-Specific Fix Rules

**All Tcl commands MUST use ACTUAL names from the design. NO generic placeholders.**

| Rule | ❌ WRONG | ✅ CORRECT |
|------|----------|------------|
| Cell names | `vio`, `my_vio` | `vio_0`, `axis_vio_0` |
| Target pins | `enable` | `/axis_filter_0/bypass_enable` |
| Clock pins | `clk` | `/versal_cips_0/pl0_ref_clk` |
| Net names | `signal` | `axis_filter_0_packet_count` |
| Probe widths | `<width>` | `32` |
| Init values | `<value>` | `0x0` |

---

## Versal-Specific: Debug Hub Setup

If no AXI Debug Hub exists in the BD (check with `get_bd_cells -filter {VLNV =~ *axi_dbg_hub*}`), add one before or alongside the VIO:

```tcl
# Check if debug hub already exists
set dbg_hubs [get_bd_cells -hierarchical -filter {VLNV =~ *axi_dbg_hub*} -quiet]; if {$dbg_hubs == ""} { puts "No debug hub found — adding one"; create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dbg_hub:2.0 axi_dbg_hub_0 } else { puts "Debug hub exists: $dbg_hubs" }
```

The debug hub must be connected to CIPS via NoC for JTAG access. If the BD already has a debug hub from an ILA insertion, reuse it — the hub supports multiple debug cores.

---

## Hardware Manager Runtime Interaction

After programming the device, interact with VIO probes in the Vivado Hardware Manager:

### Reading Input Probes (Design → Host)

```tcl
# Refresh all VIO values from hardware
refresh_hw_vio [get_hw_vios hw_vio_1]

# Read a specific input probe value
get_property INPUT_VALUE [get_hw_probes <probe_name> -of_objects [get_hw_vios hw_vio_1]]

# Set display radix for readability
set_property INPUT_VALUE_RADIX UNSIGNED [get_hw_probes <probe_name> -of_objects [get_hw_vios hw_vio_1]]
```

### Writing Output Probes (Host → Design)

```tcl
# Set a new output value (does NOT take effect until commit)
set_property OUTPUT_VALUE <value> [get_hw_probes <probe_name> -of_objects [get_hw_vios hw_vio_1]]

# Commit the value to hardware — this is when the signal actually changes
commit_hw_vio [get_hw_probes {<probe_name>} -of_objects [get_hw_vios hw_vio_1]]

# Reset all outputs to their initial values
reset_hw_vio_outputs [get_hw_vios hw_vio_1]
```

### Activity Detectors

```tcl
# Check if input probe had transitions since last read
get_property ACTIVITY_VALUE [get_hw_probes <probe_name> -of_objects [get_hw_vios hw_vio_1]]

# Reset activity detectors
reset_hw_vio_activity [get_hw_vios hw_vio_1]
```

### VIO Core Status

| Status | Meaning | Action |
|---|---|---|
| `OK – Outputs Reset` | Outputs at initial values, in sync with IDE | None |
| `OK` | Outputs in sync but not at initial values | None |
| `Outputs out-of-sync` | IDE values differ from hardware | `commit_hw_vio` to push IDE values, or `refresh` to pull hardware values |

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc</sub></p>
<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
