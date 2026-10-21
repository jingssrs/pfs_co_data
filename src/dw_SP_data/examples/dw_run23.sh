#!/bin/bash

#for i in {1..34}
#do
#    wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d_preview/run23_July2025/pfsCoadd/10091/pfsCoadd_PFS_cosm_run23_10091_${i}_run23_July2025.fits"
#    echo "Finished downloading pfsCoadd for i: $i"
#
#    index=$(printf "%03d" $i)
#    wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/lam1d_preview/default_config/10091/run23_10091_${index}/data/pfsCoZcandidates-10091.fits"
#    wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/lam1d_preview/custom_config/10091/run23_10091_${index}/data/pfsCoZcandidates-10091.fits"
#    echo "Finished downloading pfsCoZcandidates for i: $index"
#done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "$script_dir/../.." && pwd)"
csv_file="$repo_dir/obslog/processed/date_visit_id_june2025.csv"

# Skip header and read each line
tail -n +2 "$csv_file" | while IFS=',' read -r date visit_id; do
    echo "Date: $date, Visit ID: $visit_id"

#    for i in {1..4}
#    do
#       wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d_preview/run23_July2025/detectorMap/${date}/${visit_id}/detectorMap_PFS_${visit_id}_b${i}_run23_July2025.fits"
#       wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d_preview/run23_July2025/detectorMap/${date}/${visit_id}/detectorMap_PFS_${visit_id}_r${i}_run23_July2025.fits"
#       wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d_preview/run23_July2025/detectorMap/${date}/${visit_id}/detectorMap_PFS_${visit_id}_n${i}_run23_July2025.fits"
#    done

#    echo "Finished downloading detectorMap for Date: $date, Visit ID: $visit_id"

#    wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d_preview/run23_July2025/pfsConfig/${date}/${visit_id}/pfsConfig_PFS_${visit_id}_run23_July2025.fits"
#    echo "Finished downloading pfsConfig for Date: $date, Visit ID: $visit_id"

#    for i in {1..4}
#    do
#       wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d_preview/run23_July2025/sky1d/${date}/${visit_id}/sky1d_PFS_${visit_id}_b${i}_run23_July2025.fits"
#       wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d_preview/run23_July2025/sky1d/${date}/${visit_id}/sky1d_PFS_${visit_id}_r${i}_run23_July2025.fits"
#       wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d_preview/run23_July2025/sky1d/${date}/${visit_id}/sky1d_PFS_${visit_id}_n${i}_run23_July2025.fits"
#    done
#    echo "Finished downloading sky1d for Date: $date, Visit ID: $visit_id"

#    wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d_preview/run23_July2025/pfsCalibrated/${date}/${visit_id}/pfsCalibrated_PFS_${visit_id}_run23_July2025.fits"
#    echo "Finished downloading pfsCalibrated for Date: $date, Visit ID: $visit_id"

done
