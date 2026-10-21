#!/usr/bin/env python3
import argparse
import csv
from pathlib import Path

ARMS = ("b", "r", "n")  # blue, red, NIR

def expected_paths(base_dir: Path, run_label: str, date: str, visit_id: str, max_slot: int):
    """Yield all expected Paths for a given (date, visit_id) based on your bash loops."""
    date = str(date).strip()
    visit_id = str(visit_id).strip()

    run_root = base_dir / run_label

    # detectorMap: brn x 1..max_slot
    for arm in ARMS:
        for i in range(1, max_slot + 1):
            yield run_root / "detectorMap" / date / visit_id / f"detectorMap_PFS_{visit_id}_{arm}{i}_{run_label}.fits"

    # pfsConfig: one per visit
    yield run_root / "pfsConfig" / date / visit_id / f"pfsConfig_PFS_{visit_id}_{run_label}.fits"

    # sky1d: brn x 1..max_slot
    for arm in ARMS:
        for i in range(1, max_slot + 1):
            yield run_root / "sky1d" / date / visit_id / f"sky1d_PFS_{visit_id}_{arm}{i}_{run_label}.fits"

    # pfsCalibrated: one per visit
    yield run_root / "pfsCalibrated" / date / visit_id / f"pfsCalibrated_PFS_{visit_id}_{run_label}.fits"

def is_ok(path: Path) -> bool:
    try:
        return path.is_file() and path.stat().st_size > 0
    except Exception:
        return False

def check_csv(csv_file: Path, base_dir: Path, run_label: str, max_slot: int):
    total_expected = 0
    total_found = 0
    per_visit = []
    missing_all = []

    with csv_file.open(newline="") as f:
        reader = csv.reader(f)
        header = next(reader, None)  # skip header
        for row in reader:
            if not row or len(row) < 2:
                continue
            date, visit_id = row[0].strip(), row[1].strip()

            exp_paths = list(expected_paths(base_dir, run_label, date, visit_id, max_slot))
            found = [p for p in exp_paths if is_ok(p)]
            missing = [p for p in exp_paths if p not in found]

            total_expected += len(exp_paths)
            total_found += len(found)

            per_visit.append((date, visit_id, len(found), len(exp_paths)))
            if missing:
                missing_all.append((date, visit_id, missing))

    # summaries
    print("\n=== Per-visit summary ===")
    for date, visit_id, found_cnt, exp_cnt in per_visit:
        status = "OK" if found_cnt == exp_cnt else "MISSING"
        print(f"{date} / {visit_id}: {found_cnt}/{exp_cnt} [{status}]")

    if missing_all:
        print("\n=== Missing files (list) ===")
        for date, visit_id, missing in missing_all:
            print(f"\n{date} / {visit_id}  (missing {len(missing)})")
            for p in missing:
                print(f"  - {p}")

    print("\n=== Totals ===")
    print(f"Found {total_found} / {total_expected} files")
    if total_found == total_expected:
        print("✅ All expected files are present and non-empty.")
    else:
        print("❌ Some files are missing or zero-size (see above).")

def main():
    parser = argparse.ArgumentParser(description="Verify PFS downloads mirrored by wget -r.")
    parser.add_argument("--csv", required=True, type=Path,
                        help="CSV with header, columns: date,visit_id")
    parser.add_argument("--run", required=True,
                        help="Run label used in paths and filenames (e.g., run21_June2025, run22_July2025)")
    parser.add_argument("--max-slot", type=int, default=4,
                        help="Max spectrograph slot you looped over (e.g., 4)")
    parser.add_argument("--base-dir", type=Path, default=Path("./hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d"),
                        help="Local mirrored base dir (default assumes wget -r layout)")
    args = parser.parse_args()

    check_csv(args.csv, args.base_dir, args.run, args.max_slot)

if __name__ == "__main__":
    main()

# Example usage:
# python3.10 verify_dw.py --csv date_visit_id_s25a.csv --run S25A_April2026 > verify_dw_log/verify_dw_S25A_April2026.log 2>&1
