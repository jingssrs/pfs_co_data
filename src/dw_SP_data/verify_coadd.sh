#!/bin/bash
# Check that every pfsCoadd file was downloaded and is a real FITS file.
# Uses the settings in run.sh.  Run:  ./verify_coadd.sh
cd "$(dirname "$0")"
source <(sed -n '/^# ---- settings ----/,/^COADD_PATTERN=/p' run.sh)

DIR=$OUT_DIR/hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/$PROGRAM/2d/$RELEASE/pfsCoadd/10091
LOG=verify_dw_log/verify_coadd_$RELEASE.log
> $LOG

for i in $(seq 1 $N_COADD); do
    f=${COADD_PATTERN//\{field\}/10091}
    f=${f//\{i\}/$i}
    f=$DIR/${f//\{release\}/$RELEASE}

    if [ ! -s $f ]; then
        echo "MISSING  $f" >> $LOG
    elif [ "$(head -c 6 $f)" != "SIMPLE" ]; then
        echo "NOT_FITS $f" >> $LOG
    fi
done

echo "Checked $N_COADD files, $(wc -l < $LOG) bad (list in $LOG)"
