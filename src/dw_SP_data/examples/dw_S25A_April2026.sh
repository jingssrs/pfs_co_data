#!/bin/bash

release="S25A_November2025"

for i in {1..70}
do
    wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/${release}/pfsCoadd/10091/pfsCoadd_PFS_selected_S25A_10091_${i}_${release}.fits"
    echo "Finished downloading pfsCoadd for i: $i"

    wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/lam1d/${release}/default/10091_${i}/data/pfsCoZcandidates-10091.fits"
    wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/lam1d/${release}/modified/10091_${i}/data/pfsCoZcandidates-10091.fits"
    echo "Finished downloading pfsCoZcandidates for i: $i"

done

wget -r -k -np -nH --config ~/.pfs-scienceplatform.wgetrc --cut-dirs=1 "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/${release}/objectGroupMap/"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "$script_dir/../.." && pwd)"
csv_file="$repo_dir/obslog/processed/date_visit_id_S25A.csv"

# Skip header and read each line
tail -n +2 "$csv_file" | while IFS=',' read -r date visit_id
do
    echo "Date: $date, Visit ID: $visit_id"

    for i in {1..4}
    do
       wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/${release}/detectorMap/${date}/${visit_id}/detectorMap_PFS_${visit_id}_b${i}_${release}.fits"
       wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/${release}/detectorMap/${date}/${visit_id}/detectorMap_PFS_${visit_id}_r${i}_${release}.fits"
       wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/${release}/detectorMap/${date}/${visit_id}/detectorMap_PFS_${visit_id}_n${i}_${release}.fits"
    done

    echo "Finished downloading detectorMap for Date: $date, Visit ID: $visit_id"

    wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/${release}/pfsConfig/${date}/${visit_id}/pfsConfig_PFS_${visit_id}_${release}.fits"
    echo "Finished downloading pfsConfig for Date: $date, Visit ID: $visit_id"

    for i in {1..4}
    do
       wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/${release}/sky1d/${date}/${visit_id}/sky1d_PFS_${visit_id}_b${i}_${release}.fits"
       wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/${release}/sky1d/${date}/${visit_id}/sky1d_PFS_${visit_id}_r${i}_${release}.fits"
       wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/${release}/sky1d/${date}/${visit_id}/sky1d_PFS_${visit_id}_n${i}_${release}.fits"
    done
    echo "Finished downloading sky1d for Date: $date, Visit ID: $visit_id"

    wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/${release}/pfsCalibrated/${date}/${visit_id}/pfsCalibrated_PFS_${visit_id}_${release}.fits"
    echo "Finished downloading pfsCalibrated for Date: $date, Visit ID: $visit_id"

done
