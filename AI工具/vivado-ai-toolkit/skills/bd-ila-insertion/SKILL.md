---
name: bd-ila-insertion
description: >
  Inserts ILA/System ILA debug cores into Vivado IP integrator Block Designs to enable
  in-system debugging of AXI interfaces and signals. Supports both instantiation
  (adding System ILA/ILA IP directly into BD) and insertion (marking nets with
  HDL_ATTRIBUTE.DEBUG for post-synthesis debug setup). Use when user asks to "add ILA
  to block design", "insert debug core in BD", "debug AXI interface", "add System ILA",
  "probe BD signals", "mark BD nets for debug", "insert ILA in IP integrator", or
  "add debug to block design". Also trigger for "monitor AXI transactions", "debug
  block design signals", or "add chipscope to BD".
---

# BD ILA Insertion

## Overview

**Purpose:** Insert ILA or System ILA debug cores into Vivado IP integrator Block Designs, connecting them to user-specified signals or AXI interfaces for in-system hardware debugging.

**Output:** `vivado_agentic_ai_reports/bd-ila-insertion/`
- `bd_debug_summary.rpt` — summary of debug cores added and connections made
- `REPORT.md` — markdown report with **copy-pasteable Tcl** for reproducing the ILA insertion

**Prerequisites:** An open Vivado project with a Block Design, or a BD Tcl script. The BD should have signals/interfaces that the user wants to debug.

**Output format:** The REPORT.md **must** include copy-pasteable Tcl commands that reproduce the exact ILA insertion performed, using ACTUAL design names from the BD.

---

## Prerequisites

| Requirement | Details |
|---|---|
| Vivado version | 2020.2 or later (2023.1+ recommended for Versal ILA support) |
| Target family | 7 Series, UltraScale, UltraScale+, Zynq, Zynq UltraScale+ MPSoC, Versal |
| Design state | Block Design must be open in IP integrator (pre-synthesis for instantiation flow; post-synthesis for netlist insertion flow) |
| Open project | A Vivado project (.xpr) with at least one Block Design (.bd) |
| Vivado session | Connected via the MCP Vivado bridge (`mcp_vivado_connect`) or interactive Tcl console |

---

## Parameter Discovery (MANDATORY FIRST STEP)

⚠️ **You MUST execute the discovery commands below BEFORE configuring ILA/System ILA IPs — do NOT skip this step.** The parameter tables in this skill are a baseline reference only. Your Vivado version and target device may have different valid values, additional parameters, or different defaults. After creating the IP cell, also query `get_bd_intf_pins -of_objects [get_bd_cells <cell>]` to verify actual port/pin names before writing connection commands.

**For System ILA (non-Versal):**

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 temp_discover; report_property [get_bd_cells temp_discover] CONFIG.*
```

**For AXIS-ILA (Versal):**

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.0 temp_discover; report_property [get_bd_cells temp_discover] CONFIG.*
```

To locate the IP's `component.xml` (authoritative parameter definitions, valid values, dependencies):

```tcl
puts [get_property IP_DIR [get_ipdefs xilinx.com:ip:system_ila:*]]
```

**After creating the IP cell, verify actual interface pins and valid enum values before connecting:**

```tcl
# List all interface pins with direction (critical for correct connections)
foreach pin [get_bd_intf_pins -of_objects [get_bd_cells <cell_name>]] { puts "$pin | [get_property MODE $pin] | [get_property VLNV $pin]" }

# Probe valid values for any enum parameter (error message reveals the valid set)
catch {set_property CONFIG.<PARAM_NAME> __PROBE__ [get_bd_cells <cell_name>]} msg; puts $msg
```

Delete the temporary cell after discovery:

```tcl
delete_bd_objs [get_bd_cells temp_discover]
```

---

## Efficiency Guidelines

- **Pass `session_id`** to every `vivado_execute` call when a Vivado session is active.
- **Write reports to file** — do not output full report content in chat; give a short summary only.
- **Read reports efficiently** — use `grep`, `sed`, or `awk` via terminal to extract specific sections instead of reading entire files into context. Use `wc -l` + `head` to check size first. Full `read_file` is fine only for small reports (<200 lines).
- **Do NOT** use `shell ls`, `shell find`, or `shell glob` to locate files.
- **Do NOT** use Vivado Tcl (`exec cat`, `open`, `read`) to read files. Use `grep`/`sed` via terminal or `read_file` with line ranges.
- **Do NOT** retry a failed Tcl command with different syntax. Report the error and stop or proceed.
- **Use single-line semicolon-chained Tcl** for all `vivado_execute` calls. The MCP server executes each call as one atomic command — multi-line blocks fragment into separate calls that lose variable state.

---

## Key Concepts

### Two Debug Flows in Block Design

| Flow | When to Use | How It Works |
|---|---|---|
| **Instantiation** (recommended) | Pre-synthesis; when you know which interfaces/signals to debug | Add System ILA (or ILA) IP directly into BD, connect to nets/interfaces, validate, then synthesize |
| **Insertion** | Pre-synthesis marking + post-synthesis setup | Mark BD nets with `HDL_ATTRIBUTE.DEBUG true`, synthesize, then use Set Up Debug wizard to configure ILA cores |

### System ILA vs ILA in Block Design

| Core | Use Case | Notes |
|---|---|---|
| **System ILA** (`system_ila`) | AXI interface monitoring + signal probing (non-Versal) | Recommended for new BD designs on 7 Series, UltraScale, UltraScale+, Zynq |
| **ILA** (`ila`) | Signal probing only (legacy BD flow) | Still works but System ILA is preferred for new designs |
| **Versal ILA** (AXIS-ILA, `axis_ila`) | Interface + signal monitoring on Versal | On Versal, System ILA is obsolete; use AXIS-ILA with Interface mode instead |

### Debug Hub Requirement (Versal)

On Versal devices, ILA/AXIS-ILA requires an **AXI Debug Hub** (`axi_dbg_hub`) connected to the CIPS IP via NoC. The debug hub is NOT auto-instantiated in BD — it must be explicitly added and connected.

---

## Decision Tree

```
User wants to debug BD signals/interfaces
  ├─ Versal device?
  │   ├─ YES → Use AXIS-ILA (axis_ila) + AXI Debug Hub (axi_dbg_hub)
  │   │         Must connect debug hub to CIPS via NoC
  │   └─ NO (7 Series / UltraScale / UltraScale+ / Zynq)
  │       └─ Debugging AXI interfaces?
  │           ├─ YES → Use System ILA (system_ila) in INTERFACE mode
  │           └─ NO (individual signals only) → Use System ILA in NATIVE mode
  │               (or ILA with Monitor Type = Native)
  ├─ User wants instantiation flow (add IP to BD now)?
  │   └─ Follow Workflow A: Instantiation
  └─ User wants insertion flow (mark now, configure after synthesis)?
      └─ Follow Workflow B: Insertion
```

---

## Workflow A: Instantiation Flow (Recommended)

**⚠️ CRITICAL: Execute steps SEQUENTIALLY. Wait for each command to complete.**

**⚠️ The workflow is incomplete until REPORT.md exists.** Do not end your turn before calling the write tool to create the file. Do not narrate ("Now generating...") or summarize before writing — invoke the write tool first. Only after the file is written, give a short summary.

```
BD ILA Insertion (Instantiation) Progress:
- [ ] Step 1: Open BD, discover available nets/interfaces
- [ ] Step 2: Add System ILA (or AXIS-ILA) to BD and configure
- [ ] Step 3: Connect ILA to target signals/interfaces
- [ ] Step 4: Validate BD and create report directory
- [ ] Step 5: Generate REPORT.md (call write tool), then short summary in chat
```

### Step 1: Open BD, Discover Available Nets/Interfaces

Open the block design and list available nets, interface nets, and cells to identify debug targets.

```tcl
open_bd_design [lindex [glob -nocomplain *.bd] 0]; set bd_name [current_bd_design]; puts "BD: $bd_name"; puts "--- Cells ---"; foreach c [get_bd_cells -hierarchical] { puts "  $c ([get_property VLNV $c])" }; puts "--- Interface Nets ---"; foreach n [get_bd_intf_nets] { puts "  $n" }; puts "--- Nets ---"; foreach n [get_bd_nets] { puts "  $n" }
```

**If the BD is already open**, skip `open_bd_design` and just query cells/nets:

```tcl
set bd_name [current_bd_design]; puts "BD: $bd_name"; puts "Cells: [llength [get_bd_cells -hierarchical]]"; puts "Intf Nets: [llength [get_bd_intf_nets]]"; puts "Nets: [llength [get_bd_nets]]"
```

**For large designs**, limit output to AXI interface nets (most common debug targets):

```tcl
puts "AXI Interface Nets:"; foreach n [get_bd_intf_nets -filter {VLNV =~ *axi*}] { set pins [get_bd_intf_pins -of_objects $n]; puts "  $n : $pins" }
```

Use `timeout_seconds: 120` if the design is large.

**Ask the user** which nets or interfaces they want to debug if not already specified.

### Step 2: Add System ILA (or AXIS-ILA) to BD and Configure

**For non-Versal devices (System ILA with AXI interface monitoring):**

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0; set_property -dict [list CONFIG.C_DATA_DEPTH {1024} CONFIG.C_NUM_MONITOR_SLOTS {1} CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0}] [get_bd_cells system_ila_0]; puts "System ILA created: system_ila_0"
```

**For non-Versal devices (System ILA with native/signal probing):**

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0; set_property -dict [list CONFIG.C_DATA_DEPTH {1024} CONFIG.C_NUM_MONITOR_SLOTS {0} CONFIG.C_NUM_OF_PROBES {[num_probes]}] [get_bd_cells system_ila_0]; puts "System ILA created with [num_probes] probes"
```

**For non-Versal devices (System ILA with BOTH AXI interface + native probes — MIX mode):**

> **⚠️ CRITICAL:** When combining AXI interface monitoring with native signal probes, you **must** set `CONFIG.C_MON_TYPE {MIX}` after creating the cell. Without this, probe pins (`probe0`, `probe1`, ...) will not appear on the System ILA cell.

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0; set_property -dict [list CONFIG.C_DATA_DEPTH {1024} CONFIG.C_NUM_MONITOR_SLOTS {1} CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} CONFIG.C_NUM_OF_PROBES {2}] [get_bd_cells system_ila_0]; set_property CONFIG.C_MON_TYPE {MIX} [get_bd_cells system_ila_0]; puts "System ILA created in MIX mode (interface + native probes)"
```

**For Versal devices (AXIS-ILA in Interface Monitor mode):**

> **⚠️ CRITICAL:** The AXIS-ILA (`axis_ila`) uses `CONFIG.C_MON_TYPE` (NOT `C_MONITOR_TYPE` — that parameter does NOT exist). You **must** set `C_MON_TYPE` to `Interface_Monitor` for the `SLOT_0_AXIS` interface pin to appear. Without this, the ILA defaults to `Net_Probes` mode and only has native probe pins.

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.0 axis_ila_0; set_property -dict [list CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} CONFIG.C_DATA_DEPTH {1024}] [get_bd_cells axis_ila_0]; set_property CONFIG.C_MON_TYPE {Interface_Monitor} [get_bd_cells axis_ila_0]; puts "AXIS-ILA created in Interface Monitor mode: axis_ila_0"
```

**For Versal devices (AXIS-ILA in Native/probe mode):**

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.0 axis_ila_0; set_property -dict [list CONFIG.C_DATA_DEPTH {1024} CONFIG.C_NUM_OF_PROBES {[num_probes]}] [get_bd_cells axis_ila_0]; puts "AXIS-ILA created in Net_Probes mode: axis_ila_0"
```

**Key configuration parameters:**

| Parameter | Description | Typical Values |
|---|---|---|
| `CONFIG.C_DATA_DEPTH` | Sample depth (trace buffer size) | 1024, 2048, 4096, 8192, 16384 |
| `CONFIG.C_BRAM_CNT` | BRAM resource budget | 6 (small), 12 (medium), 36 (large) |
| `CONFIG.C_NUM_MONITOR_SLOTS` | Number of AXI interface slots | 1–16 |
| `CONFIG.C_NUM_OF_PROBES` | Number of native probe ports | 1–1024 |
| `CONFIG.C_PROBE0_WIDTH` | Width of probe port 0 | 1–4096 |
| `CONFIG.C_SLOT_0_INTF_TYPE` | Interface type for slot 0 | `xilinx.com:interface:aximm_rtl:1.0` (AXI-MM), `xilinx.com:interface:axis_rtl:1.0` (AXI-Stream) |
| `CONFIG.C_MON_TYPE` | Monitor type — controls which probe pins appear | **System ILA:** `INTERFACE` (default when slots > 0), `NATIVE` (probes only), `MIX` (interface + probes). **AXIS-ILA (Versal):** `Interface_Monitor` (exposes SLOT_0_AXIS pin), `Net_Probes` (default, native probes only) |
| `CONFIG.C_SLOT_0_APC_EN` | Enable AXI Protocol Checker on slot | 0 (off), 1 (on) |

---

## Critical Parameter Relationships (DRC-Enforced)

### C_MON_TYPE depends on: C_NUM_MONITOR_SLOTS, C_NUM_OF_PROBES
- **System ILA (non-Versal):** Defaults to `INTERFACE` when `C_NUM_MONITOR_SLOTS > 0`; defaults to `NATIVE` when `C_NUM_MONITOR_SLOTS = 0` and `C_NUM_OF_PROBES > 0`; **must be explicitly set to `MIX`** to combine interface slots with native probes — without this, `probe0`, `probe1`, ... pins will not appear on the cell
- **AXIS-ILA (Versal):** Uses parameter name `C_MON_TYPE` (NOT `C_MONITOR_TYPE` — that parameter does NOT exist on axis_ila). Defaults to `Net_Probes` (native probes). **Must be set to `Interface_Monitor`** for the `SLOT_0_AXIS` interface pin to appear. Set `C_MON_TYPE` as a **separate** `set_property` call after setting `C_SLOT_0_INTF_TYPE`.
- Set `C_MON_TYPE` as a **separate** `set_property` call after the initial `set_property -dict`

### C_BRAM_CNT is auto-locked
- Computed from connected interfaces and probe widths
- Do NOT set before connections are made — the value will be silently ignored
- Query after connections: `get_property CONFIG.C_BRAM_CNT [get_bd_cells system_ila_0]`

### C_PROBEn_WIDTH is auto-locked
- Auto-sized from the connected net width
- Do NOT set explicitly — will be overwritten on connection

### C_SLOT_n_INTF_TYPE constrains: interface connections
- Must match the VLNV of the interface being monitored
- Common values: `xilinx.com:interface:aximm_rtl:1.0` (AXI-MM), `xilinx.com:interface:axis_rtl:1.0` (AXI-Stream)
- Mismatched VLNV causes `ERROR: Cannot connect interface ... incompatible VLNV`

### C_NUM_MONITOR_SLOTS constrains: SLOT pin availability
- Setting `C_NUM_MONITOR_SLOTS {N}` creates `SLOT_0_AXI` through `SLOT_(N-1)_AXI` interface pins
- Each slot needs a corresponding `C_SLOT_n_INTF_TYPE`

### C_DATA_DEPTH constrains: C_BRAM_CNT (auto)
- Deeper samples = more BRAM; formula: BRAM ≈ ceil(total_probe_bits × sample_depth / 36864)

---

## Workflow A (continued): Connect, Validate, Report

### Step 3: Connect ILA to Target Signals/Interfaces

**Connect AXI interface to System ILA slot:**

```tcl
connect_bd_intf_net [get_bd_intf_pins [actual_source_cell]/[actual_intf_pin]] [get_bd_intf_pins system_ila_0/SLOT_0_AXI]; puts "Connected [actual_interface] to system_ila_0/SLOT_0_AXI"
```

**Connect clock and reset to System ILA:**

```tcl
connect_bd_net [get_bd_pins [actual_clock_source]/[actual_clk_pin]] [get_bd_pins system_ila_0/clk]; connect_bd_net [get_bd_pins [actual_reset_source]/[actual_resetn_pin]] [get_bd_pins system_ila_0/resetn]; puts "Clock and reset connected"
```

**Connect native signal probes:**

```tcl
connect_bd_net [get_bd_pins [actual_cell]/[actual_signal]] [get_bd_pins system_ila_0/probe0]; puts "probe0 connected to [actual_signal]"
```

**Alternative — use `apply_bd_automation` for automatic connection (when available):**

```tcl
apply_bd_automation -rule xilinx.com:bd_rule:debug -dict [list \
  [get_bd_intf_nets [actual_intf_net_name]] {SLOT_0_AXI} \
] [get_bd_cells system_ila_0]
```

> **Note:** `apply_bd_automation` with debug rules automates clock/reset connections and interface stitching, but not all BD configurations support it. If it fails, fall back to manual `connect_bd_intf_net` / `connect_bd_net`.

### Step 4: Validate BD and Create Report Directory

```tcl
file mkdir vivado_agentic_ai_reports/bd-ila-insertion; validate_bd_design; save_bd_design; puts "BD validated and saved"
```

Use `timeout_seconds: 120` for `validate_bd_design`.

**Check for validation errors:**

If `validate_bd_design` produces CRITICAL WARNINGs or ERRORs, report them to the user. Common issues:
- Clock domain mismatch between ILA and monitored interface
- Missing clock/reset connections to ILA
- Interface type mismatch (e.g., AXI4-Lite connected to AXI4-Full slot)

**Generate a summary report:**

```tcl
set rpt_file "vivado_agentic_ai_reports/bd-ila-insertion/bd_debug_summary.rpt"; set fp [open $rpt_file w]; puts $fp "=== BD ILA Insertion Summary ==="; puts $fp "BD: [current_bd_design]"; puts $fp "Date: [clock format [clock seconds]]"; puts $fp ""; puts $fp "Debug Cores Added:"; foreach c [get_bd_cells -hierarchical -filter {VLNV =~ *ila*}] { puts $fp "  $c ([get_property VLNV $c])" }; puts $fp ""; puts $fp "ILA Connections:"; foreach c [get_bd_cells -hierarchical -filter {VLNV =~ *ila*}] { foreach p [get_bd_intf_pins -of_objects $c -filter {MODE == Slave}] { set net [get_bd_intf_nets -of_objects $p]; puts $fp "  $p <- $net" }; foreach p [get_bd_pins -of_objects $c -filter {DIR == I}] { set net [get_bd_nets -of_objects $p -quiet]; if {$net != ""} { puts $fp "  $p <- $net" } } }; close $fp; puts "Report: $rpt_file"
```

### Step 5: Generate Report with Copy-Pasteable Tcl

**Action:** Call the write tool to create `vivado_agentic_ai_reports/bd-ila-insertion/REPORT.md`.

**MANDATORY:** Include **📋 Copy-Paste Tcl** blocks with ACTUAL cell names, interface names, pin names, and net names from the design. The user must be able to source this Tcl to reproduce the exact ILA insertion on a clean copy of the BD.

**Order:** (1) Invoke the write tool with the full report content. (2) Only after the write succeeds, give a short summary. Do NOT output the report as response text. Do NOT say "Now generating..." without immediately invoking the write tool.

**REPORT.md must include:**
1. Summary of what was added (core type, instance name, configuration)
2. Connections made (which interfaces/signals probed, clock/reset sources)
3. Resource estimate (BRAM usage based on `C_DATA_DEPTH` and probe widths)
4. Complete copy-pasteable Tcl to reproduce the insertion from scratch
5. Next steps (generate output products, synthesize, implement, generate bitstream)

---

## Workflow B: Insertion Flow (Mark for Debug)

**⚠️ CRITICAL: Execute steps SEQUENTIALLY. Wait for each command to complete.**

**⚠️ The workflow is incomplete until REPORT.md exists.** Do not end your turn before calling the write tool to create the file.

```
BD ILA Insertion (Mark Debug) Progress:
- [ ] Step 1: Open BD, identify nets to mark for debug
- [ ] Step 2: Mark BD nets/interface nets with HDL_ATTRIBUTE.DEBUG
- [ ] Step 3: Validate and save BD
- [ ] Step 4: Generate REPORT.md with next steps (call write tool), then short summary
```

### Step 1: Open BD, Identify Nets to Mark

Same as Workflow A, Step 1. Open the BD and list available nets and interfaces.

### Step 2: Mark BD Nets with HDL_ATTRIBUTE.DEBUG

**Mark individual BD nets for debug:**

```tcl
set_property HDL_ATTRIBUTE.DEBUG true [get_bd_nets {[actual_net_name]}]; puts "Marked [actual_net_name] for debug"
```

**Mark multiple nets:**

```tcl
foreach net_name {[net1] [net2] [net3]} { set_property HDL_ATTRIBUTE.DEBUG true [get_bd_nets $net_name]; puts "Marked $net_name for debug" }
```

**Mark interface nets for debug:**

```tcl
set_property HDL_ATTRIBUTE.DEBUG true [get_bd_intf_nets {[actual_intf_net_name]}]; puts "Marked interface [actual_intf_net_name] for debug"
```

### Step 3: Validate and Save BD

```tcl
file mkdir vivado_agentic_ai_reports/bd-ila-insertion; validate_bd_design; save_bd_design; puts "BD validated and saved with debug marks"
```

### Step 4: Generate Report with Next Steps

Create REPORT.md documenting which nets were marked and what the user needs to do next:

1. Generate BD output products
2. Run synthesis
3. Open Synthesized Design
4. Use Set Up Debug wizard (or Tcl commands) to configure ILA cores
5. Save, implement, generate bitstream

---

## ⚠️ MANDATORY: Design-Specific Fix Rules

**All Tcl commands MUST use ACTUAL names from the design. NO generic placeholders.**

| Rule | ❌ WRONG | ✅ CORRECT |
|------|----------|------------|
| Cell names | `ila_0`, `system_ila` | `system_ila_0`, `axis_ila_0` |
| Interface nets | `axi_net` | `microblaze_0_axi_periph_M01_AXI` |
| Interface pins | `M_AXI` | `/microblaze_0_axi_periph/M01_AXI` |
| Clock pins | `clk` | `/clk_wiz_1/clk_out1` |
| Reset pins | `resetn` | `/rst_clk_wiz_1_100M/peripheral_aresetn` |
| BD net names | `signal` | `c_counter_binary_0_Q` |
| Probe widths | `<width>` | `32` |

---

## Resource Estimation

ILA cores consume BRAM/URAM. Provide an estimate based on configuration:

| Sample Depth | Probe Width | Approx. BRAM (36Kb) |
|---|---|---|
| 1024 | 32-bit | 1 |
| 1024 | 128-bit | 4 |
| 1024 | 512-bit | 16 |
| 4096 | 32-bit | 4 |
| 4096 | 128-bit | 16 |
| 4096 | 512-bit | 64 |
| 16384 | 32-bit | 16 |

**AXI interface monitoring** adds significant probe width: a full AXI4 memory-mapped interface can be 200+ bits (address + data + control channels). A 64-bit data AXI4-MM interface at 4096 depth uses approximately 36 BRAMs.

**Formula:** BRAM ≈ ceil(total_probe_bits × sample_depth / 36864)

---

## Quick-Reference Command Table

| Task | Tcl Command |
|---|---|
| Open BD | `open_bd_design [get_files *.bd]` |
| List cells | `get_bd_cells -hierarchical` |
| List nets | `get_bd_nets` |
| List interface nets | `get_bd_intf_nets` |
| List pins of cell | `get_bd_pins -of_objects [get_bd_cells cell_name]` |
| List interface pins | `get_bd_intf_pins -of_objects [get_bd_cells cell_name]` |
| Create System ILA | `create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0` |
| Create AXIS-ILA (Versal) | `create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.0 axis_ila_0` |
| Create AXI Debug Hub (Versal) | `create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dbg_hub:2.0 axi_dbg_hub_0` |
| Configure ILA properties | `set_property -dict [list CONFIG.key val ...] [get_bd_cells ila_name]` |
| Connect interface | `connect_bd_intf_net [get_bd_intf_pins src] [get_bd_intf_pins dst]` |
| Connect signal | `connect_bd_net [get_bd_pins src] [get_bd_pins dst]` |
| Mark net for debug | `set_property HDL_ATTRIBUTE.DEBUG true [get_bd_nets net]` |
| Mark interface for debug | `set_property HDL_ATTRIBUTE.DEBUG true [get_bd_intf_nets intf_net]` |
| Validate BD | `validate_bd_design` |
| Save BD | `save_bd_design` |
| Auto-connect debug | `apply_bd_automation -rule xilinx.com:bd_rule:debug ...` |
| Regenerate layout | `regenerate_bd_layout` |
| Generate output products | `generate_target all [get_files *.bd]` |

---

## Troubleshooting: REPORT.md Not Created

**Symptom:** Steps complete but REPORT.md never appears.

**Root cause:** The agent outputs text ("Now I'll generate REPORT.md...") instead of invoking the write tool. A text-only response may end the turn before the file is written.

**Prevention:** Follow the step order strictly — invoke the write tool first, then summarize. Do not narrate before acting.

---

## Error Handling

| Error | Symptom | Action |
|-------|---------|--------|
| No BD open | `ERROR: No current design` or `ERROR: Can't find a Block Design` | `open_bd_design [get_files *.bd]` |
| BD not in project | No `.bd` files found | Ask user to open or create a Block Design |
| IP not found | `ERROR: Could not find IP: xilinx.com:ip:system_ila` | Check IP catalog; update IP catalog with `update_ip_catalog`; verify Vivado version supports the IP |
| Interface type mismatch | `ERROR: Cannot connect interface ... incompatible VLNV` | Verify `C_SLOT_0_INTF_TYPE` matches the target interface VLNV |
| Clock domain mismatch | CRITICAL WARNING during `validate_bd_design` | Ensure ILA `clk` pin is connected to the same clock domain as the monitored interface |
| Missing reset connection | WARNING during `validate_bd_design` | Connect `resetn` pin for System ILA; for ILA, reset is optional |
| Net already has debug | Property already set | Skip — net is already marked, no action needed |
| Versal: missing Debug Hub | ILA not detected in hardware | Add `axi_dbg_hub` IP and connect to CIPS via NoC |
| `validate_bd_design` timeout | Command exceeds timeout | Increase `timeout_seconds` to 300; suggest simplifying BD or closing unused designs |

---

## Validation

```tcl
set ila_cells [get_bd_cells -hierarchical -quiet -filter {VLNV =~ *ila*}]; if {[llength $ila_cells] > 0} { puts "✓ ILA cores found in BD: $ila_cells" } else { puts "✗ No ILA cores found in BD" }; if {[file exists "vivado_agentic_ai_reports/bd-ila-insertion/bd_debug_summary.rpt"]} { puts "✓ Debug summary report generated" }
```

Success: ILA core(s) exist in BD, connections are valid (no CRITICAL WARNINGs from `validate_bd_design`), REPORT.md exists with copy-pasteable Tcl using ACTUAL design names.

---

## Versal-Specific Notes

On **Versal** devices, the debug infrastructure differs significantly:

1. **System ILA is obsolete** — use AXIS-ILA (`axis_ila`) instead
2. **Debug Hub must be explicit** — add `axi_dbg_hub` IP and connect to CIPS via NoC
3. **AXIS-ILA uses `C_MON_TYPE` (NOT `C_MONITOR_TYPE`)** — set to `Interface_Monitor` for AXI interface debugging. The `SLOT_0_AXIS` interface pin only appears AFTER `C_MON_TYPE` is set to `Interface_Monitor`. Default is `Net_Probes` (native probe mode).
4. **Storage options** — AXIS-ILA supports both BRAM and URAM storage targets
5. **CIPS connection required** — Debug Hub needs an AXI connection to the Processing System via NoC for JTAG communication

**Versal debug infrastructure setup (single Tcl block):**

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dbg_hub:2.0 axi_dbg_hub_0; create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.0 axis_ila_0; set_property -dict [list CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} CONFIG.C_DATA_DEPTH {1024}] [get_bd_cells axis_ila_0]; set_property CONFIG.C_MON_TYPE {Interface_Monitor} [get_bd_cells axis_ila_0]; puts "Versal debug infrastructure created — connect axi_dbg_hub_0 to CIPS via NoC, SLOT_0_AXIS to target interface"
```

---

## References

- **UG908**: Vivado Design Suite User Guide: Programming and Debugging (ILA, System ILA, debug flows)
- **UG994**: Vivado Design Suite User Guide: Designing IP Subsystems Using IP Integrator (BD debug flows)
- **UG949**: UltraFast Design Methodology (debug best practices)
- **PG261**: System Integrated Logic Analyzer LogiCORE IP Product Guide (System ILA configuration)
- **PG172**: Integrated Logic Analyzer LogiCORE IP Product Guide (ILA configuration)
- **PG357**: AXI4-Stream ILA Product Guide (Versal ILA/AXIS-ILA)
- **UG909**: Vivado Design Suite User Guide: Dynamic Function eXchange (DFX debug with ILA insertion)

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc</sub></p>
<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
