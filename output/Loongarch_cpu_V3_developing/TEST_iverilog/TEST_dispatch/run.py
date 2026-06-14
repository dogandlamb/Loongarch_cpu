#!/usr/bin/env python3
import os, subprocess, sys
from pathlib import Path

MOD = "dispatch"
DIR = Path(__file__).resolve().parent
ROOT = DIR.parent
COMMON = ROOT / "common"
USE_REF = os.environ.get("USE_REF", "0") == "1"
dut = DIR / (f"{MOD}_reference.v" if USE_REF else f"{MOD}.v")
tb = DIR / f"{MOD}_tb.v"
out = DIR / "sim.vvp"

if not dut.is_file():
    print(f"MISSING DUT: {dut}")
    sys.exit(1)
if not tb.is_file():
    print(f"MISSING TB: {tb}")
    sys.exit(2)

extra = []
extra_file = DIR / "extra_sources.txt"
if extra_file.is_file():
    for line in extra_file.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line and not line.startswith("#"):
            extra.append(str(DIR / line))

cmd = [
    "iverilog", "-g2005",
    "-I", str(COMMON), "-I", str(DIR),
    "-o", str(out),
    str(dut), str(tb),
] + extra
print(" ".join(cmd))
if subprocess.run(cmd).returncode != 0:
    sys.exit(1)
r = subprocess.run(["vvp", str(out)], capture_output=True, text=True)
print(r.stdout, end="")
if r.stderr:
    print(r.stderr, file=sys.stderr, end="")
if "FAIL:" in r.stdout or r.returncode != 0:
    sys.exit(1)
print(f"ALL PASS: {MOD}")
