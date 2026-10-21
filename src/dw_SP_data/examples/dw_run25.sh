#!/bin/bash

#for i in {1..82}
#do
    #wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25B-OT02/2d/run25_February2026/pfsCoadd/10091/pfsCoadd_PFS_selected_run25_10091_${i}_run25_February2026.fits"
    #echo "Finished downloading pfsCoadd for i: $i"

    #wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25B-OT02/lam1d/run25_February2026/modified/10091_${i}/data/pfsCoZcandidates-10091.fits"
    #echo "Finished downloading pfsCoZcandidates for i: $i"

#done


#wget -r -k -np -nH --config ~/.pfs-scienceplatform.wgetrc --cut-dirs=1 "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25B-OT02/2d/run25_February2026/objectGroupMap/"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "$script_dir/../.." && pwd)"
csv_file="$repo_dir/obslog/processed/date_visit_id_nov2025.csv"

# Skip header and read each line
tail -n +2 "$csv_file" | while IFS=',' read -r date visit_id
do
    echo "Date: $date, Visit ID: $visit_id"

    #for i in {1..4}
    #do
    #   wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25B-OT02/2d/run25_February2026/detectorMap/${date}/${visit_id}/detectorMap_PFS_${visit_id}_b${i}_run25_February2026.fits"
    #   wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25B-OT02/2d/run25_February2026/detectorMap/${date}/${visit_id}/detectorMap_PFS_${visit_id}_r${i}_run25_February2026.fits"
    #   wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25B-OT02/2d/run25_February2026/detectorMap/${date}/${visit_id}/detectorMap_PFS_${visit_id}_n${i}_run25_February2026.fits"
    #done

    #echo "Finished downloading detectorMap for Date: $date, Visit ID: $visit_id"

    #wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25B-OT02/2d/run25_February2026/pfsConfig/${date}/${visit_id}/pfsConfig_PFS_${visit_id}_run25_February2026.fits"
    #echo "Finished downloading pfsConfig for Date: $date, Visit ID: $visit_id"

    #for i in {1..4}
    #do
    #   wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25B-OT02/2d/run25_February2026/sky1d/${date}/${visit_id}/sky1d_PFS_${visit_id}_b${i}_run25_February2026.fits"
    #   wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25B-OT02/2d/run25_February2026/sky1d/${date}/${visit_id}/sky1d_PFS_${visit_id}_r${i}_run25_February2026.fits"
    #   wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25B-OT02/2d/run25_February2026/sky1d/${date}/${visit_id}/sky1d_PFS_${visit_id}_n${i}_run25_February2026.fits"
    #done
    #echo "Finished downloading sky1d for Date: $date, Visit ID: $visit_id"

    #wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25B-OT02/2d/run25_February2026/pfsCalibrated/${date}/${visit_id}/pfsCalibrated_PFS_${visit_id}_run25_February2026.fits"
    #echo "Finished downloading pfsCalibrated for Date: $date, Visit ID: $visit_id"

    wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25B-OT02/2d/run25_February2026/pfsMerged/${date}/${visit_id}/pfsMerged_PFS_${visit_id}_run25_February2026.fits"
    echo "Finished downloading pfsMerged for Date: $date, Visit ID: $visit_id"

done
