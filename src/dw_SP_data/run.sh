#!/bin/bash
# Process obslog -> download release -> verify.
# Edit the settings below, then run:  ./run.sh
set -e
cd "$(dirname "$0")"

# ---- settings ----
RUN=S25A-S25B                       # obslog run name (obslog/config_$RUN.json)
PROGRAM=S25A-OT02
RELEASE=S25A-S25B_October2026
OUT_DIR=/lustre/work/jingjing.shi/PFS_SSP
N_COADD=738                       # number of pfsCoadd files (different every run)
COADD_PATTERN='pfsCoadd_PFS_brn_10091_{i}_{release}.fits'

CSV=../../obslog/processed/date_visit_id_$RUN.csv

# 1. make the visit list
#python3 ../../obslog/process_obslog.py --config ../../obslog/config_$RUN.json

# 2. download pfsCoadd only
./dw_release.sh --out-dir $OUT_DIR --program $PROGRAM --release $RELEASE \
    --products none --no-object-group-map \
    --coadd-count $N_COADD --coadd-pattern "$COADD_PATTERN"

# full download (visits, objectGroupMap, lam1d) - use this instead of the line above
#./dw_release.sh --out-dir $OUT_DIR --program $PROGRAM --release $RELEASE \
#    --csv $CSV --products all \
#    --coadd-count $N_COADD --coadd-pattern "$COADD_PATTERN" \
#    --lam1d-mode release --lam1d-configs brn_modified_updated

# 2b. butler registry (re-downloaded every time, so it is always up to date)
#for f in butler.yaml gen3.sqlite3; do
#    wget -r -np -P $OUT_DIR --config ~/.pfs-scienceplatform.wgetrc \
#        https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/$PROGRAM/2d/$f
#done

# 3. verify
#python3 verify_dw.py --csv $CSV --run $RELEASE \
#    --base-dir $OUT_DIR/hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/$PROGRAM/2d \
#    > verify_dw_log/verify_dw_$RELEASE.log
#tail -n 2 verify_dw_log/verify_dw_$RELEASE.log
