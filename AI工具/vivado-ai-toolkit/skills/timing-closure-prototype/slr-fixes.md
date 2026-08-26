# SLR Crossing Fix Reference

## Decision Logic

For each failing cross-SLR path, check pblock constraints first:

```tcl
get_property PBLOCK [get_cells <src_cell>]
get_property PBLOCK [get_cells <dst_cell>]
```

**Key question:** Do the pblocks represent functional placement (i.e., they contain a meaningful processing block with multiple interconnected cells), or were they created solely to force SLR separation?

- **Functional pblocks** (>4 cells with a real datapath): keep the pblocks.  Fix the crossing with Option E (USER_SLL_REG) or Option B (trim pblock).
- **Artificial/demo-only pblocks** (1-2 cells, no datapath purpose): Option A (delete) is acceptable.

### Option E — USER_SLL_REG (preferred for functional pblocks)

**When:** Source and destination are in different SLRs due to intentional functional placement (pblocks represent real blocks like packet engines, memory interfaces, etc.). The crossing registers exist but are placed far from the SLR boundary or without dedicated SLL routing.

**Especially effective for diagonal crossings** where source and destination are offset horizontally across SLR columns — the SLL (Super Long Line) dedicated routing at the Laguna column handles the vertical crossing efficiently.

```tcl
# Step 1: Free crossing registers from their pblocks so Vivado can place
#         them at Laguna sites (which may be outside the pblock region).
remove_cells_from_pblock [get_pblocks <src_pblock>] [get_cells <src_crossing_reg>]
remove_cells_from_pblock [get_pblocks <dst_pblock>] [get_cells <dst_crossing_reg>]

# Step 2: Apply USER_SLL_REG to place on dedicated Laguna SLL column.
set_property USER_SLL_REG TRUE [get_cells {<src_crossing_reg> <dst_crossing_reg>}]
```

If the crossing cells are NOT in pblocks, skip Step 1.

### Option A — Remove pblock (if pblock is root cause, single-purpose)

**When:** A pblock forces cells into separate SLRs and serves no other purpose (e.g., a demo-only constraint with 1–2 cells).

```tcl
delete_pblocks [get_pblocks <pblock_name>]
```

### Option B — Expand or trim pblock

**When:** Pblock serves another purpose (power/thermal/PR) but splits critical path across SLRs.

```tcl
# Expand to span both SLRs
resize_pblock [get_pblocks <pblock_name>] -add {CLOCKREGION_X0Y4:CLOCKREGION_X5Y5}
# OR remove only critical-path cells
remove_cells_from_pblock [get_pblocks <pblock_name>] [get_cells -hier -filter {NAME =~ "*<pattern>*"}]
```

### Option C — Soft SLR assignment

**When:** No pblock issue. Placer split a hierarchy across SLRs.

**Limitation:** `USER_SLR_ASSIGNMENT` only works on hierarchical cells. Vivado silently ignores it on leaf cells (e.g., individual register bits). If the crossing cells are leaf-level, skip to Option D or B.

```tcl
set_property USER_SLR_ASSIGNMENT SLR<n> [get_cells <hierarchy>]
```

### Option D — Crossing net control

**When:** Pipeline chain zigzags across SLR boundaries unnecessarily.

```tcl
set_property USER_CROSSING_SLR FALSE [get_pins -leaf -of [get_nets <net_stay>]]
set_property USER_CROSSING_SLR TRUE  [get_pins -leaf -of [get_nets <net_cross>]]
```

### Option F — Hard Laguna LOC+BEL (last resort)

**When:** All softer constraints tried and failed. UltraScale+ only.

```tcl
set_property BEL TX_REG<n> [get_cells <src_reg>]
set_property BEL RX_REG<n> [get_cells <dst_reg>]
set_property LOC LAGUNA_X<col>Y<row_tx> [get_cells <src_reg>]
set_property LOC LAGUNA_X<col>Y<row_rx> [get_cells <dst_reg>]
```

BEL position must match between TX and RX.

## Escalation Order (UG949)

Soft → Medium → Hard. Always prefer softer constraints:

1. **Soft**: Option C (USER_SLR_ASSIGNMENT)
2. **Medium**: Options E, D, B (USER_SLL_REG, USER_CROSSING_SLR, pblock resize)
3. **Hard**: Option F (Laguna LOC+BEL)

Option A (delete pblock) is a special case — only when pblocks serve no functional purpose.

## Wide Bus Note

For buses >250 MHz crossing SLRs: recommend AXI Register Slice IP in Multi-SLR-Crossing mode or at least 3 pipeline stages per crossing. Flag to user as RTL recommendation.

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc</sub></p>
<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
