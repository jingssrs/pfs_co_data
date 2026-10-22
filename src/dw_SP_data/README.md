# dw_SP_data — downloading PFS Science Platform release products

This folder holds the scripts that download PFS CO release products (pfsCoadd,
pfsCoZcandidates, objectGroupMap and per-visit 2D products) from the Science
Platform at `https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs`.

Downloads are saved under **`/lustre/work/jingjing.shi/PFS_SSP/`** by default.

```
dw_SP_data/
├── run.sh             # end-to-end: process obslog -> download -> verify
├── dw_release.sh      # general downloader
├── verify_dw.py       # check that per-visit downloads are complete
├── verify_dw_log/     # saved verification logs
└── examples/          # older one-off scripts for each release (reference only)
```

Paths below assume the repository layout `pfs_co_data/src/dw_SP_data/` and
`pfs_co_data/obslog/`.

---

## 0. Quick start: `run.sh` (all steps in one go)

`run.sh` processes the obslog, downloads the release to `OUT_DIR`, and writes
a check of the download to `verify_dw_log/verify_dw_<RELEASE>.log`.

1. Add the raw obslog CSVs and `obslog/config_<run>.json` (see section 1).
2. Edit the settings at the top of `run.sh`: `RUN`, `PROGRAM`, `RELEASE`,
   `OUT_DIR`, and `N_COADD` / `COADD_PATTERN`, which change every run. Look up
   the number of pfsCoadd files on the Science Platform under
   `programs/<PROGRAM>/2d/<RELEASE>/pfsCoadd/10091/`.
3. Run it:

```bash
cd pfs_co_data/src/dw_SP_data
./run.sh
```

To see the wget commands first, add `--dry-run` to the `dw_release.sh` line.
Step 1 needs `python3` with `pandas`. For long downloads, start `screen` first
and run `./run.sh` inside it, or use `nohup ./run.sh > run.log 2>&1 &`.

---

## 1. Generate the processed obslog

`dw_release.sh` needs a CSV with `date,visit_id` columns listing the visits to
download. These come from the raw observation logs in `pfs_co_data/obslog/`.

### 1a. Add the raw logs

Put the night-by-night obslog CSVs for the new run into a new folder, e.g.

```
pfs_co_data/obslog/obslog_sep2026/obslog_S26B_SSP_2026-09-07.csv
pfs_co_data/obslog/obslog_sep2026/obslog_S26B_SSP_2026-09-08.csv
```

### 1b. Write a config for the run

Create `pfs_co_data/obslog/config_<run>.json` (copy an existing one, e.g.
`config_sep2026.json`):

```json
{
  "run_configs": {
    "sep2026": {
      "folder": "obslog_sep2026",
      "sequence_prefix": "SSP_CO_",
      "dropna_eet_r": true,
      "time_zone": "US/Hawaii"
    }
  },
  "combined_date_visit_runs": {}
}
```

| Key | Meaning |
|---|---|
| run name (`sep2026`) | Label used in the output filenames |
| `folder` | Subfolder of `obslog/` with the raw CSVs |
| `sequence_prefix` | Keep only rows whose `sequence_name` starts with this (CO visits) |
| `dropna_eet_r` | Drop rows with no `eet_r` (effective exposure time) |
| `time_zone` | Time zone of `issued_at` in the raw log; dates are converted to UTC |
| `combined_date_visit_runs` | Optional, e.g. `{"S25A": ["march2025", "may2025"]}` writes one merged visit list |

### 1c. Run the processing script

From `pfs_co_data/`:

```bash
cd pfs_co_data
python obslog/process_obslog.py --config obslog/config_sep2026.json
```

Useful options: `--runs sep2026` (process only some runs from the config),
`--skip-combined`, `--obslog-dir`, `--output-dir`. Without `--config` the
built-in S25A runs (march2025 … nov2025) are processed.
`../read_obslog.ipynb` does the same thing interactively.

### Output (in `pfs_co_data/obslog/processed/`)

- `co_<run>.csv` — filtered CO rows of the obslog, with `issued_at_UTC` and `date`.
- `date_visit_id_<run>.csv` — the visit list used by `dw_release.sh`:

```
date,visit_id
20260908,149485
20260908,149482
```

`date` is the **UTC** date (`YYYYMMDD`), which matches the directory names on
the Science Platform.

---

## 2. Run `dw_release.sh`

### Prerequisites

- `wget`
- A Science Platform wget config with your credentials at
  `~/.pfs-scienceplatform.wgetrc` (or pass `--wget-config FILE`).
- Files are saved under `--out-dir` (default `/lustre/work/jingjing.shi/PFS_SSP`).
  The directory is created if needed. Because `wget -r` mirrors the URL, files
  land in `<out-dir>/hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/<program>/...`.
  objectGroupMap goes to `<out-dir>/fileaccess/pfs/...` (`-nH --cut-dirs=1`).

### Basic usage

```bash
./dw_release.sh --help                                  # full option list
./dw_release.sh --release <RELEASE> --csv <date_visit_id.csv> [options] --dry-run
```

Always try `--dry-run` first: it prints the `wget` commands without downloading.
Note that a relative `--csv` path is resolved from your current directory;
from `src/dw_SP_data/` the processed lists are at `../../obslog/processed/`.

### Main options

| Option | Default | Meaning |
|---|---|---|
| `--release` | (required) | Release label, e.g. `run25_February2026`, `S25A_November2025` |
| `--csv` | — | `date,visit_id` CSV (required unless `--products none`) |
| `--out-dir` | `/lustre/work/jingjing.shi/PFS_SSP` | Where downloads are saved |
| `--program` | `S25A-OT02` | Program directory, e.g. `S25B-OT02` |
| `--products` | `pfsMerged` | Comma list of `detectorMap,pfsConfig,sky1d,pfsCalibrated,pfsMerged`, or `all` / `none` |
| `--drp2d-root` | `2d` | Use `2d_preview` for preview releases |
| `--field` | `10091` | Field id used in pfsCoadd / lam1d paths |
| `--slots` | `4` | Spectrograph slots for detectorMap / sky1d (arms b, r, n) |
| `--object-group-map` | off | Also download objectGroupMap for this release |
| `--coadd-count N` | `0` | Download pfsCoadd files `i = 1..N` |
| `--coadd-pattern` | — | pfsCoadd filename; placeholders `{release} {field} {i} {index} {run_short}` |
| `--lam1d-mode` | `none` | `release`, `preview` or `pfscoadd` (needs `--coadd-count`) |
| `--lam1d-configs` | `default,modified` | lam1d config directories |
| `--lam1d-root` | `lam1d` | Use `lam1d_preview` for preview releases |
| `--run-short` | text before first `_` of release | e.g. `run23` |
| `--dry-run` | off | Print commands only |

### Examples

run25 (S25B-OT02), everything:

```bash
./dw_release.sh --program S25B-OT02 --release run25_February2026 \
    --csv ../../obslog/processed/date_visit_id_nov2025.csv --products all --object-group-map \
    --coadd-count 82 --coadd-pattern 'pfsCoadd_PFS_selected_run25_{field}_{i}_{release}.fits' \
    --lam1d-mode release --lam1d-configs modified
```

S25A November 2025 release:

```bash
./dw_release.sh --release S25A_November2025 --csv ../../obslog/processed/date_visit_id_S25A.csv \
    --products detectorMap,pfsConfig,sky1d,pfsCalibrated --object-group-map \
    --coadd-count 70 --coadd-pattern 'pfsCoadd_PFS_selected_S25A_{field}_{i}_{release}.fits' \
    --lam1d-mode release --lam1d-configs default,modified
```

Preview release (run23):

```bash
./dw_release.sh --release run23_July2025 --csv ../../obslog/processed/date_visit_id_june2025.csv \
    --drp2d-root 2d_preview --products detectorMap,pfsConfig,sky1d,pfsCalibrated \
    --coadd-count 34 --coadd-pattern 'pfsCoadd_PFS_cosm_run23_{field}_{i}_{release}.fits' \
    --lam1d-mode preview --lam1d-root lam1d_preview \
    --lam1d-configs default_config,custom_config --run-short run23
```

Only per-visit pfsMerged:

```bash
./dw_release.sh --release run22_July2025 --csv ../../obslog/processed/date_visit_id_may2025.csv
```

For long downloads on idark, use `screen`/`tmux` or
`nohup ./dw_release.sh ... > dw_<release>.log 2>&1 &`.

---

## 3. Verify the download

`run.sh` does this automatically. To run it by hand: `verify_dw.py` checks that
every expected detectorMap, pfsConfig, sky1d and pfsCalibrated file exists and
is non-empty for each visit in the CSV. `--base-dir` defaults to
`/lustre/work/jingjing.shi/PFS_SSP/hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d`:

```bash
python verify_dw.py --csv ../../obslog/processed/date_visit_id_S25A.csv --run S25A_April2026 \
    > verify_dw_log/verify_dw_S25A_April2026.log 2>&1
```

Use `--base-dir` if the program is not `S25A-OT02`, e.g.
`--base-dir /lustre/work/jingjing.shi/PFS_SSP/hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25B-OT02/2d`, and
`--max-slot` to match `--slots`. To fill gaps, re-run `dw_release.sh` with a CSV
that lists only the missing visits (re-running the full list downloads everything again).
