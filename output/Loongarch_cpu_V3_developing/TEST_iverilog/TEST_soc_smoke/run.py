#!/usr/bin/env python3
import os, subprocess, sys
from pathlib import Path

DIR = Path(__file__).resolve().parent
ROOT = DIR.parent
COMMON = ROOT / "common"
DEPS = COMMON / "deps"
USE_REF = True

sources = [
    DEPS / "ubtb.v", DEPS / "ftb.v", DEPS / "tage.v", DEPS / "ras.v",
    ROOT / "TEST_bpu" / "bpu_reference.v",
    ROOT / "TEST_ftq" / "ftq_reference.v",
    ROOT / "TEST_inst_buffer" / "inst_buffer_reference.v",
    DIR / "soc_smoke_tb.v",
]
out = DIR / "sim.vvp"
cmd = ["iverilog", "-g2005", "-I", str(COMMON), "-I", str(DIR), "-o", str(out)] + [str(s) for s in sources]
print(" ".join(cmd))
if subprocess.run(cmd).returncode != 0:
    sys.exit(1)
r = subprocess.run(["vvp", str(out)], capture_output=True, text=True)
print(r.stdout, end="")
if "FAIL:" in r.stdout:
    sys.exit(1)
print("SOC SMOKE PASS")
