#!/usr/bin/env python3
"""将 chiplab 参考实现同步到各 TEST_*/*_reference.v"""
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parent
REF_CPU = ROOT.parent / "chiplab_for_Vivado" / "IP" / "myCPU"

if not REF_CPU.is_dir():
    raise SystemExit(f"参考 CPU 目录不存在: {REF_CPU}")

count = 0
for test_dir in sorted(ROOT.glob("TEST_*")):
    mod = test_dir.name.replace("TEST_", "", 1)
    src = REF_CPU / f"{mod}.v"
    dst = test_dir / f"{mod}_reference.v"
    if not src.is_file():
        print(f"SKIP (no ref): {mod}")
        continue
    shutil.copy2(src, dst)
    count += 1
    print(f"sync {dst.name}")

print(f"done: {count} files")
