#!/usr/bin/env python3
"""Quick VCD probe for func-test debug signals + INE commit report."""
import re
import sys
from collections import defaultdict

VCD_DEFAULT = (
    r"E:\Loongarch_cpu\output\Loongarch_cpu_V3_developing"
    r"\chiplab_for_Vivado_dont_touch\fpga\nscscc-team\run_vivado\project\tb_top_rob.vcd"
)

EXCP_INE_BIT = 4

NAMES = {
    "debug0_wb_pc",
    "debug0_wb_inst",
    "arvalid",
    "arready",
    "rvalid",
    "rready",
    "ws_valid",
    "fetch_stall",
    "araddr",
    "rdata",
    "ftq_ifu_pc",
    "bpu_p0_pc",
    "flush",
    "flush_pc",
    "cmt_flush_req",
    "cmt_flush_type",
    "cmt_flush_pc",
    "cmt_excp_adef",
    "cmt_excp_ine",
    "cmt_excp_ipe",
    "cmt_excp_int",
    "cmt_csr_ex",
    "ex_redirect_req",
    "ex_redirect_pc",
    "predec_redirect",
    "predec_redirect_pc",
    "ftq_cmt_mispred",
    "ftq_train_mispred",
    "csr_crmd_da_out",
    "csr_crmd_pg_out",
    # ROB / rename INE probes
    "dbg_rob_cmt0_valid",
    "dbg_rob_cmt0_complete",
    "dbg_rob_cmt0_pc",
    "dbg_rob_cmt0_inst",
    "dbg_rob_cmt0_excp",
    "dbg_ib_pop0_pc",
    "dbg_ib_pop0_inst",
    "dbg_ib_pop0_excp",
    "dbg_dec0_excp",
    "dbg_dec0_excp_eff",
    "dbg_rn_ib0_excp",
    "dbg_ib0_null_bubble",
}


def dedupe(events: list[tuple[int, int]]) -> list[tuple[int, int]]:
    ded: list[tuple[int, int]] = []
    for t, v in events:
        if not ded or ded[-1][1] != v:
            ded.append((t, v))
    return ded


def fmt_val(v: int, width: int = 32) -> str:
    if width == 1:
        return str(v)
    return f"0x{v:0{width // 4}x}"


def parse_vcd(path: str, max_us: float = 200.0) -> dict[str, list[tuple[int, int]]]:
    sym2name: dict[str, tuple[str, int]] = {}
    in_cpu = False

    with open(path, "r", errors="ignore") as f:
        for line in f:
            if line.startswith("$scope module u_cpu"):
                in_cpu = True
                continue
            if line.startswith("$upscope"):
                if in_cpu:
                    in_cpu = False
                continue
            if in_cpu and line.startswith("$var"):
                parts = line.strip().split()
                width = int(parts[2])
                sym = parts[3]
                name = parts[4]
                if name in NAMES:
                    sym2name[sym] = (name, width)
            if line.startswith("$enddefinitions"):
                break

    print("Symbols:", {v[0]: k for k, v in sym2name.items()})

    cur = 0
    max_t = int(max_us * 1_000_000)
    vals: dict[str, int] = {}
    events: dict[str, list[tuple[int, int]]] = defaultdict(list)

    def emit(sym: str) -> None:
        name, _ = sym2name[sym]
        events[name].append((cur, vals[sym]))

    in_body = False
    with open(path, "r", errors="ignore") as f:
        for line in f:
            if line.startswith("$enddefinitions"):
                in_body = True
                continue
            if not in_body:
                continue
            if line.startswith("#"):
                cur = int(line[1:].strip())
                if cur > max_t:
                    break
                continue
            s = line.strip()
            if not s:
                continue
            if s[0] == "b":
                bits, sym = s.rsplit(" ", 1)
                if sym in sym2name:
                    b = bits[1:]
                    if re.search(r"[xzXZ]", b):
                        continue
                    vals[sym] = int(b, 2)
                    emit(sym)
            else:
                sym = s[1:]
                if sym in sym2name:
                    vals[sym] = 1 if s[0] == "1" else 0
                    emit(sym)

    for name in sorted(NAMES):
        ded = dedupe(events.get(name, []))
        print(f"\n=== {name} ({len(ded)} changes) ===")
        width = next((w for n, w in sym2name.values() if n == name), 32)
        for t, v in ded[:20]:
            print(f"  {t / 1e6:8.3f} us  {fmt_val(v, width)}")
        if len(ded) > 20:
            last_t, last_v = ded[-1]
            print(f"  ... +{len(ded) - 20} more, last @ {last_t / 1e6:.3f}us = {fmt_val(last_v, width)}")

    return {k: dedupe(v) for k, v in events.items()}


def report_ine(events: dict[str, list[tuple[int, int]]]) -> None:
    print("\n" + "=" * 60)
    print("INE COMMIT REPORT")
    print("=" * 60)

    rob_valid = events.get("dbg_rob_cmt0_valid", [])
    rob_pc = events.get("dbg_rob_cmt0_pc", [])
    rob_inst = events.get("dbg_rob_cmt0_inst", [])
    rob_excp = events.get("dbg_rob_cmt0_excp", [])
    cmt_ine = events.get("cmt_excp_ine", [])
    flush_req = events.get("cmt_flush_req", [])

    def val_at(ev: list[tuple[int, int]], t: int, default: int = 0) -> int:
        v = default
        for ts, val in ev:
            if ts > t:
                break
            v = val
        return v

    # ROB commits with INE bit set
    ine_commits = []
    for t, excp in rob_excp:
        if not ((excp >> EXCP_INE_BIT) & 1):
            continue
        if val_at(rob_valid, t) and val_at(events.get("dbg_rob_cmt0_complete", []), t):
            ine_commits.append((
                t,
                val_at(rob_pc, t),
                val_at(rob_inst, t),
                excp,
            ))

    if ine_commits:
        print(f"\nROB cmt0 with INE (valid & complete): {len(ine_commits)}")
        for t, pc, inst, excp in ine_commits[:15]:
            print(
                f"  {t / 1e6:8.3f} us  pc={pc:08x} inst={inst:08x} "
                f"excp=0x{excp:04x} null_bubble={val_at(events.get('dbg_ib0_null_bubble', []), t)}"
            )
    else:
        print("\nNo ROB cmt0 INE commits found (check probe names in VCD).")

    # cmt_excp_ine rising edges near flush
    print("\ncmt_excp_ine / flush correlation:")
    prev_ine = 0
    for t, ine in cmt_ine:
        if ine and not prev_ine:
            flush_t = next((ft for ft, fv in flush_req if fv and abs(ft - t) < 50000), None)
            pc = val_at(rob_pc, t)
            inst = val_at(rob_inst, t)
            excp = val_at(rob_excp, t)
            dec = val_at(events.get("dbg_dec0_excp", []), t)
            dec_eff = val_at(events.get("dbg_dec0_excp_eff", []), t)
            rn = val_at(events.get("dbg_rn_ib0_excp", []), t)
            ib_ex = val_at(events.get("dbg_ib_pop0_excp", []), t)
            print(
                f"  {t / 1e6:8.3f} us  ine=1 flush@{flush_t / 1e6 if flush_t else 0:.3f}us "
                f"rob_pc={pc:08x} rob_inst={inst:08x} rob_excp=0x{excp:04x} "
                f"ib_excp=0x{ib_ex:04x} dec=0x{dec:04x} dec_eff=0x{dec_eff:04x} rn=0x{rn:04x}"
            )
        prev_ine = ine


if __name__ == "__main__":
    vcd = sys.argv[1] if len(sys.argv) > 1 else VCD_DEFAULT
    max_us = float(sys.argv[2]) if len(sys.argv) > 2 else 20.0
    ev = parse_vcd(vcd, max_us)
    report_ine(ev)
