#!/bin/bash
# Process obslog -> download release -> verify.
# Edit the settings below, then run:  ./run.sh
set -e
cd "$(dirname "$0")"

# ---- settings ----
RUN=jan2026                       # obslog run name (obslog/config_$RUN.json)
PROGRAM=S25B-OT02
RELEASE=run26_June2026
OUT_DIR=/lustre/work/jingjing.shi/PFS_SSP
N_COADD=33                        # number of pfsCoadd files (different every run)
COADD_PATTERN='pfsCoadd_PFS_brn_run26_{field}_{i}_{release}.fits'

CSV=../../obslog/processed/date_visit_id_$RUN.csv

# 1. make the visit list
#python3 ../../obslog/process_obslog.py --config ../../obslog/config_$RUN.json

# 2. download
./dw_release.sh --out-dir $OUT_DIR --program $PROGRAM --release $RELEASE \
    --csv $CSV --products all --object-group-map \
    --coadd-count $N_COADD --coadd-pattern "$COADD_PATTERN" \
    --lam1d-mode release --lam1d-configs brn_modified_updated

# 3. verify
#python3 verify_dw.py --csv $CSV --run $RELEASE \
#    --base-dir $OUT_DIR/hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/$PROGRAM/2d \
#    > verify_dw_log/verify_dw_$RELEASE.log
#tail -n 2 verify_dw_log/verify_dw_$RELEASE.log
