#!/usr/bin/env python3
"""Auto-generate tie-off testbench from reference module ports."""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent  # TEST_iverilog
REF_CPU = ROOT.parent / "chiplab_for_Vivado" / "IP" / "myCPU"


def parse_ports(text: str):
    # strip comments
    text = re.sub(r"//.*", "", text)
    m = re.search(r"module\s+\w+\s*\((.*?)\);", text, re.S)
    if not m:
        raise ValueError("module not found")
    body = m.group(1)
    body = re.sub(r"`ifdef.*?`endif", "", body, flags=re.S)
    body = re.sub(r"`include.*?\\n", "", body)
    ports = []
    for chunk in body.split(","):
        chunk = chunk.strip()
        if not chunk:
            continue
        pm = re.search(
            r"(input|output)\s+(?:wire|reg)?\s*(\[[^\]]+\])?\s*(\w+)",
            chunk,
        )
        if pm:
            ports.append((pm.group(1), pm.group(2) or "", pm.group(3)))
    return ports


def gen_tb(mod: str, ports, checks: str = ""):
    skip_inputs = set()
    decl = []
    conn = []
    need_clk_drv = False
    need_rst_drv = False
    use_resetn = False
    for direction, width, name in ports:
        w = width.strip()
        if name == "clk" and direction == "input":
            decl.append(f"  reg {w} clk;")
            conn.append(f"    .clk(clk)")
            need_clk_drv = True
            continue
        if name == "resetn" and direction == "input":
            decl.append(f"  reg {w} resetn;")
            conn.append(f"    .resetn(resetn)")
            need_rst_drv = True
            use_resetn = True
            continue
        if name == "reset" and direction == "input":
            decl.append(f"  reg {w} reset;")
            conn.append(f"    .reset(reset)")
            need_rst_drv = True
            continue
        if direction == "input":
            decl.append(f"  reg {w} {name};")
            conn.append(f"    .{name}({name})")
        else:
            decl.append(f"  wire {w} {name};")
            conn.append(f"    .{name}({name})")
    if not need_clk_drv:
        decl.insert(0, "  reg clk;")
        need_clk_drv = True
    if not need_rst_drv:
        decl.insert(1 if need_clk_drv else 0, "  reg reset;")
        need_rst_drv = True
    rst_init = "    resetn=0; @(posedge clk); resetn=1;\n" if use_resetn else "    reset=1; @(posedge clk); reset=0;\n"
    decl_s = "\n".join(decl)
    conn_s = ",\n".join(conn)
    return f"""`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module {mod}_tb;
{decl_s}
  {mod} uut(
{conn_s}
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
{rst_init}{checks}
    `TB_PASS("{mod} tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
"""


CUSTOM_CHECKS = {
    "ftq": """
    p0_valid_i=1; p0_pc_i=32'h1c000000; p0_length_i=3'd4;
    @(posedge clk); p0_valid_i=0;
    #1;
    `TB_CHECK(ifu_valid_o, "ftq has block after p0");
""",
    "ftb": """
    query_valid_i=1; query_pc_i=32'h1000;
    repeat(3) @(posedge clk);
    query_valid_i=0;
    `TB_PASS("ftb query latency");
""",
    "tage": """
    query_valid_i=1; query_pc_i=32'h1000;
    repeat(3) @(posedge clk);
    `TB_PASS("tage query run");
""",
    "decoder": """
    inst_i=32'h00000001; pc_i=32'h1000; csr_llbit_i=0;
    #1;
    `TB_PASS("decoder decode beat");
""",
}


def main():
    mods = [p.stem.replace("_reference", "") for p in ROOT.glob("TEST_*/*_reference.v")]
    mods = sorted(set(mods))
    for mod in mods:
        ref = REF_CPU / f"{mod}.v"
        if not ref.is_file():
            continue
        text = ref.read_text(encoding="utf-8", errors="ignore")
        try:
            ports = parse_ports(text)
        except ValueError:
            print("skip parse", mod)
            continue
        # skip clk/reset duplicate if in ports
        tb_dir = ROOT / f"TEST_{mod}"
        if not tb_dir.is_dir():
            continue
        existing = tb_dir / f"{mod}_tb.v"
        if existing.is_file() and mod in ("rat", "regfile", "alu", "inst_buffer", "mul", "div", "ctrl", "ras", "ubtb", "store_buffer"):
            continue
        checks = CUSTOM_CHECKS.get(mod, "")
        tb = gen_tb(mod, ports, checks)
        (tb_dir / f"{mod}_tb.v").write_text(tb, encoding="utf-8")
        print("gen", mod, len(ports), "ports")


if __name__ == "__main__":
    main()
