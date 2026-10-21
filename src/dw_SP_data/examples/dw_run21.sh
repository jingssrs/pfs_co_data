#!/bin/bash

#for i in {1..7}
#do
#    wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/run21_June2025/pfsCoadd/10091/pfsCoadd_PFS_S25A_run21_10091_${i}_run21_June2025.fits"
#    echo "Finished downloading pfsCoadd for i: $i"
#done

#wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/lam1d/10091/pfsCoadd_PFS_S25A_run21_10091_1_PFS_science_run21_S25A_run21_20250513_20250531T000607Z/drp1d_spectra_20250623T134255Z/data/pfsCoZcandidates-10091.fits"
#wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/lam1d/10091/pfsCoadd_PFS_S25A_run21_10091_2_PFS_science_run21_S25A_run21_20250513_20250531T000607Z/drp1d_spectra_20250623T171254Z/data/pfsCoZcandidates-10091.fits"
#wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/lam1d/10091/pfsCoadd_PFS_S25A_run21_10091_3_PFS_science_run21_S25A_run21_20250513_20250531T000607Z/drp1d_spectra_20250623T204644Z/data/pfsCoZcandidates-10091.fits"
#wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/lam1d/10091/pfsCoadd_PFS_S25A_run21_10091_4_PFS_science_run21_S25A_run21_20250513_20250531T000607Z/drp1d_spectra_20250624T002247Z/data/pfsCoZcandidates-10091.fits"
#wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/lam1d/10091/pfsCoadd_PFS_S25A_run21_10091_5_PFS_science_run21_S25A_run21_20250513_20250531T000607Z/drp1d_spectra_20250624T032935Z/data/pfsCoZcandidates-10091.fits"
#wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/lam1d/10091/pfsCoadd_PFS_S25A_run21_10091_6_PFS_science_run21_S25A_run21_20250513_20250531T000607Z/drp1d_spectra_20250624T065914Z/data/pfsCoZcandidates-10091.fits"
#wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/lam1d/10091/pfsCoadd_PFS_S25A_run21_10091_7_PFS_science_run21_S25A_run21_20250513_20250531T000607Z/drp1d_spectra_20250624T102724Z/data/pfsCoZcandidates-10091.fits"


script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "$script_dir/../.." && pwd)"
csv_file="$repo_dir/obslog/processed/date_visit_id_march2025.csv"

# Skip header and read each line
tail -n +2 "$csv_file" | while IFS=',' read -r date visit_id; do
    echo "Date: $date, Visit ID: $visit_id"

    #for i in {1..4}
    #do
    #   wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/run21_June2025/detectorMap/${date}/${visit_id}/detectorMap_PFS_${visit_id}_b${i}_run21_June2025.fits"
    #   wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/run21_June2025/detectorMap/${date}/${visit_id}/detectorMap_PFS_${visit_id}_r${i}_run21_June2025.fits"
    #   wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/run21_June2025/detectorMap/${date}/${visit_id}/detectorMap_PFS_${visit_id}_n${i}_run21_June2025.fits"
    #done

    #echo "Finished downloading detectorMap for Date: $date, Visit ID: $visit_id"

    #wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/run21_June2025/pfsConfig/${date}/${visit_id}/pfsConfig_PFS_${visit_id}_run21_June2025.fits"
    #echo "Finished downloading pfsConfig for Date: $date, Visit ID: $visit_id"

    #for i in {1..4}
    #do
    #   wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/run21_June2025/sky1d/${date}/${visit_id}/sky1d_PFS_${visit_id}_b${i}_run21_June2025.fits"
    #   wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/run21_June2025/sky1d/${date}/${visit_id}/sky1d_PFS_${visit_id}_r${i}_run21_June2025.fits"
    #   wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/run21_June2025/sky1d/${date}/${visit_id}/sky1d_PFS_${visit_id}_n${i}_run21_June2025.fits"
    #done
    #echo "Finished downloading sky1d for Date: $date, Visit ID: $visit_id"

    #wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/run21_June2025/pfsCalibrated/${date}/${visit_id}/pfsCalibrated_PFS_${visit_id}_run21_June2025.fits"
    #echo "Finished downloading pfsCalibrated for Date: $date, Visit ID: $visit_id"

    wget -r -k -np --config ~/.pfs-scienceplatform.wgetrc "https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/run21_June2025/pfsMerged/${date}/${visit_id}/pfsMerged_PFS_${visit_id}_run21_June2025.fits"
    echo "Finished downloading pfsMerged for Date: $date, Visit ID: $visit_id"


done
