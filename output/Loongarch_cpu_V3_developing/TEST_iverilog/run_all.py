#!/usr/bin/env python3
"""运行全部模块 iverilog 测试。USE_REF=1 时测 reference 实现。"""
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
USE_REF = os.environ.get("USE_REF", "0") == "1"
ONLY = os.environ.get("ONLY", "").strip()

tests = sorted(p for p in ROOT.glob("TEST_*") if p.is_dir())
if ONLY:
    tests = [p for p in tests if p.name == ONLY or p.name == f"TEST_{ONLY}"]

passed = []
failed = []

for td in tests:
    mod = td.name.replace("TEST_", "", 1)
    run_py = td / "run.py"
    if not run_py.is_file():
        print(f"SKIP {td.name}: no run.py")
        continue
    print(f"=== {td.name} ===")
    env = os.environ.copy()
    env["USE_REF"] = "1" if USE_REF else "0"
    r = subprocess.run([sys.executable, str(run_py)], cwd=str(td), env=env)
    if r.returncode == 0:
        passed.append(td.name)
    else:
        failed.append(td.name)

print("\n======== SUMMARY ========")
print(f"PASS: {len(passed)}  FAIL: {len(failed)}  REF={USE_REF}")
for n in passed:
    print(f"  OK   {n}")
for n in failed:
    print(f"  FAIL {n}")

sys.exit(1 if failed else 0)
