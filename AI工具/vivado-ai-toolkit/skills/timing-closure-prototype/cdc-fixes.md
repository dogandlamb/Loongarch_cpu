# CDC Fix Reference

## Decision Logic

For each pair of clocks with failing CDC paths, inspect `report_clock_interaction` and `report_cdc`:

### Option A — Clock groups (fully asynchronous or exclusive)

**When:** ALL paths between two clocks need to be excluded from timing. No existing `set_max_delay -datapath_only` between them.

Choose the correct flavor based on how the clocks are related:

#### A1 — Asynchronous clocks (most common)

**When:** Clocks exist simultaneously but have no frequency or phase relationship (e.g., independent oscillators, unrelated PLLs).

```tcl
set_clock_groups -asynchronous \
  -group [get_clocks -include_generated_clocks {clk1}] \
  -group [get_clocks -include_generated_clocks {clk2}]
```

#### A2 — Physically exclusive clocks

**When:** Two clocks are defined on the **same source point** via `create_clock -add` (e.g., multi-mode application clocks). Timing paths between them do not physically exist.

```tcl
set_clock_groups -physically_exclusive \
  -group [get_clocks -include_generated_clocks {clk_mode0}] \
  -group [get_clocks -include_generated_clocks {clk_mode1}]
```

#### A3 — Logically exclusive clocks (MUX-selected)

**When:** Clocks are defined on **different source roots** but are selected by a MUX. Paths physically exist but are logically false because only one clock propagates at a time.

**Simple case** — clk0/clk1 only interact downstream of the MUX:
```tcl
set_clock_groups -logically_exclusive -group clk0 -group clk1
```

**Complex case** — clk0/clk1 also interact upstream of the MUX. Apply constraints only to the post-MUX portion:
```tcl
create_generated_clock -name clk0mux -divide_by 1 \
  -source [get_pins mux/I0] [get_pins mux/O]
create_generated_clock -name clk1mux -divide_by 1 \
  -add -master_clock clk1 \
  -source [get_pins mux/I1] [get_pins mux/O]
set_clock_groups -physically_exclusive -group clk0mux -group clk1mux
```

#### Option A — Best practices

- **Always use `-include_generated_clocks`** when applying to master clocks. Any generated clock not included in the constraint is treated as synchronous to all other clocks.
- **Single-group shorthand**: `set_clock_groups -asynchronous -group {jtag_tck}` cuts one clock (and its group) from all other clocks in the design. Useful for debug/JTAG clocks.
- **All three flavors have identical FPGA timing impact** (paths become false paths), but correct semantics improve constraint readability and are meaningful for ASIC/SI crosstalk analysis.
- A clock cannot appear in more than one `-group` within a single `set_clock_groups` constraint.

### Option B — Bounded latency (gray-coded FIFO, handshake)

**When:** Some paths need bounded data transfer latency.

```tcl
# Max delay value: use source clock period to ensure no more than one data
# transition is present on the CDC path at any given time.
# When clock period ratio is high, use min(src_period, dst_period) to reduce latency.
set_max_delay -datapath_only <src_period_ns> \
  -from [get_cells <src_reg>] -to [get_cells <dst_sync_reg>]
# Remaining async paths — use false_path, NOT clock_groups
set_false_path -from [get_cells <other_src>] -to [get_cells <other_dst>]
```

GUARDRAIL: `set_clock_groups` **silently overrides** `set_max_delay -datapath_only` between the same clocks. If ANY path uses Option B, all other async paths between those clocks must use `set_false_path`, not `set_clock_groups`.

VALIDATION: Run `report_methodology` after constraint application to detect when `set_max_delay -datapath_only` is overridden by a `set_clock_groups` or `set_false_path` constraint (methodology check TIMING-56).

### Option C — Bus skew

**When:** `report_bus_skew` or `report_cdc` shows multi-bit CDC bus.

```tcl
# Gray-coded bus: skew = destination clock period
set_bus_skew -from [get_cells <src_gray_reg>*] \
  -to [get_cells {<dst_graysync_reg>[0]*}] <dest_period_ns>

# Handshake bus with CE path: skew = num_sync_stages × dest_period
set_bus_skew -from [get_cells <src_hs_reg>*] \
  -to [get_cells <dst_hs_reg>*] <stages_x_period_ns>
```

`set_bus_skew` is a timing assertion (not an exception). Important pairing rules:

- **Pair with `set_max_delay -datapath_only`** for placement control. `set_bus_skew` alone constrains bit-to-bit skew but does not prevent source/destination registers from being placed far apart. Per AMD docs: "For completeness, the CDC needs an additional `set_max_delay` constraint to ensure that the source and destination registers are not placed too far apart."
- For gray-coded buses, `set_bus_skew` can be used **instead of** `set_max_delay -datapath_only` for skew-only control, but AMD recommends using both.
- When using `set_bus_skew` with `set_max_delay -datapath_only` between a clock pair, use `set_false_path` for remaining paths (not `set_clock_groups` — same guardrail as Option B).

### Option D — Synchronizer registers (ASYNC_REG)

**When:** `report_cdc` shows missing synchronizer, or `report_synchronizer_mtbf` shows low MTBF, or TIMING-10 DRC fires.

```tcl
set_property ASYNC_REG TRUE [get_cells -hier -filter {NAME =~ "*<sync_reg_pattern>*"}]
```

#### ASYNC_REG behavior (per UG912, UG574, UG903)

- **Synthesis**: Acts like `DONT_TOUCH` — prevents optimization, absorption into SRL/DSP/BRAM, and removes logic insertion between synchronizer stages.
- **Placement**: Forces directly-connected ASYNC_REG registers into the **same SLICE/CLB** (given compatible control sets), maximizing MTBF.
- **Simulation**: Suppresses X-propagation on timing violations — register outputs last known value instead of `X`.
- **Applicable objects**: CLB and IOB registers only (FDCE, FDPE, FDRE, FDSE). NOT applicable to RAM, SRL, DSP, or other synchronous elements. Must be applied to **cells**, not nets.
- **IOB conflict**: If both `ASYNC_REG` and `IOB` are set on the same register, IOB takes precedence (register goes to ILOGIC, not SLICE).
- **DRC**: TIMING-10 violation fires if the first two registers in a detected synchronizer chain are missing `ASYNC_REG`.
- **Validation**: Use `report_synchronizer_mtbf` (UltraScale/UltraScale+) to verify MTBF after placement.

### Option E — Synchronous clocks (multicycle)

**When:** Clocks are frequency-related (e.g., 1x/2x from same MMCM). These are NOT async — do NOT apply Options A–D.

```tcl
set_multicycle_path <N> -setup -from [get_clocks <slow_clk>] -to [get_clocks <fast_clk>]
set_multicycle_path <N-1> -hold -from [get_clocks <slow_clk>] -to [get_clocks <fast_clk>]
```

## Precedence Rules

1. Check `report_clock_interaction` "Common Primary Clock" column. If non-empty → synchronous (Option E only).
2. If asynchronous: check if any path needs bounded latency. If yes → Option B for those, `set_false_path` for remainder. **Never mix `set_clock_groups` and `set_max_delay -datapath_only` between the same clock pair.**
3. If ALL paths are fully async → Option A (pick the correct A1/A2/A3 variant).
4. Multi-bit buses always get Option C **paired with `set_max_delay -datapath_only`** for placement control, in addition to B or `set_false_path`.
5. Missing synchronizers always get Option D in addition to A/B/C.
6. After applying constraints, run `report_methodology` to detect constraint collisions.

## Validation Checklist

After applying CDC constraints, verify correctness:

| Command | What to check |
|---------|---------------|
| `report_clock_interaction -delay_type min_max` | All async pairs show "User Set Clock Groups" or "Timed (Unsafe)" replaced by constraint coverage |
| `report_cdc -details` | No unsafe CDCs remain; all CDC paths show appropriate synchronizer structure |
| `report_methodology` | No TIMING-56 (overridden `set_max_delay -datapath_only`) or other CDC-related methodology violations |
| `report_synchronizer_mtbf` | MTBF values are acceptable (typically >100 years) for all synchronizer chains |
| `report_bus_skew` | All `set_bus_skew` constraints met with positive slack |

## RTL Recommendation

Flag to user: AMD recommends XPM_CDC macros (`xpm_cdc_single`, `xpm_cdc_gray`, `xpm_cdc_handshake`, `xpm_cdc_array_single`, `xpm_cdc_pulse`) for new CDC circuits. These include built-in constraints and are architecture-optimized. For UltraScale+ devices, consider the `HARD_SYNC` primitive for metastability-hardened single-bit synchronization (2 or 3 stage, must be manually placed with LOC constraint).

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc</sub></p>
<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
