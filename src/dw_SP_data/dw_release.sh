#!/usr/bin/env bash
set -eo pipefail

# General downloader for PFS release products.
#
# Examples matching the existing scripts:
#
#   ./dw_release.sh --release run21_June2025 --csv ../../obslog/processed/date_visit_id_march2025.csv --products pfsMerged
#
#   ./dw_release.sh --release run22_July2025 --csv ../../obslog/processed/date_visit_id_may2025.csv --products pfsMerged
#
#   ./dw_release.sh --release run23_July2025 --csv ../../obslog/processed/date_visit_id_june2025.csv \
#       --drp2d-root 2d_preview --products detectorMap,pfsConfig,sky1d,pfsCalibrated \
#       --coadd-count 34 --coadd-pattern 'pfsCoadd_PFS_cosm_run23_{field}_{i}_{release}.fits' \
#       --lam1d-mode preview --lam1d-root lam1d_preview \
#       --lam1d-configs default_config,custom_config --run-short run23
#
#   ./dw_release.sh --release S25A_November2025 --csv ../../obslog/processed/date_visit_id_S25A.csv \
#       --products detectorMap,pfsConfig,sky1d,pfsCalibrated --object-group-map \
#       --coadd-count 70 --coadd-pattern 'pfsCoadd_PFS_selected_S25A_{field}_{i}_{release}.fits' \
#       --lam1d-mode release --lam1d-configs default,modified
#
#   ./dw_release.sh --program S25B-OT02 --release run25_February2026 \
#       --csv ../../obslog/processed/date_visit_id_nov2025.csv --products all --object-group-map \
#       --coadd-count 82 --coadd-pattern 'pfsCoadd_PFS_selected_run25_{field}_{i}_{release}.fits' \
#       --lam1d-mode release --lam1d-configs modified
#
# Files are saved under --out-dir (default /lustre/work/jingjing.shi/PFS_SSP).
# Add --dry-run to print wget commands without downloading.

usage() {
    sed -n '4,29p' "$0" | sed 's/^# \{0,1\}//'
    cat <<'EOF'

Required:
  --release RELEASE             Release/run label used in paths and filenames.

Usually required:
  --csv FILE                    CSV with date,visit_id columns for visit products.

Common options:
  --out-dir DIR                 Where downloads are saved (wget -r tree goes here).
                                Default: /lustre/work/jingjing.shi/PFS_SSP
  --program NAME                Program directory. Default: S25A-OT02.
  --drp2d-root NAME             2d directory name. Default: 2d. Use 2d_preview for preview releases.
  --field ID                    Field/program id used below pfsCoadd and lam1d. Default: 10091.
  --products LIST               Visit products to download. Default: pfsMerged.
                                Use comma-separated names, "all", or "none".
                                Names: detectorMap,pfsConfig,sky1d,pfsCalibrated,pfsMerged
  --slots N                     Spectrograph slots for detectorMap/sky1d. Default: 4.
  --object-group-map            Download objectGroupMap for --release.
  --object-group-releases LIST  Extra objectGroupMap release labels, comma-separated.
  --dry-run                     Print commands only.

pfsCoadd options:
  --coadd-count N               Download pfsCoadd files from i=1..N.
  --coadd-pattern PATTERN       Filename pattern for pfsCoadd.
                                Placeholders: {release}, {field}, {i}, {index}, {run_short}

lam1d / pfsCoZcandidates options:
  --lam1d-mode MODE             none, release, preview, or pfscoadd. Default: none.
  --lam1d-root NAME             lam1d directory name. Default: lam1d.
  --lam1d-configs LIST          Config directories. Default: default,modified.
  --run-short NAME              Short run prefix, e.g. run23. Default: text before first "_".

MODE meanings:
  release   lam1d/RELEASE/CONFIG/FIELD_i/data/pfsCoZcandidates-FIELD.fits
  preview   lam1d_preview/CONFIG/FIELD/RUNSHORT_FIELD_iii/data/pfsCoZcandidates-FIELD.fits
  pfscoadd  2d/RELEASE/pfsCoadd/FIELD/RUNSHORT_FIELD_iii/data/pfsCoZcandidates-FIELD.fits

Historical run21 lam1d URLs contain per-coadd timestamp directories, so keep those
as explicit URLs if you still need them.
EOF
}

trim() {
    local value="${1:-}"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    printf '%s' "$value"
}

program="${PROGRAM:-S25A-OT02}"
release="${RELEASE:-}"
csv_file="${CSV_FILE:-}"
out_dir="${OUT_DIR:-/lustre/work/jingjing.shi/PFS_SSP}"
base_url="${BASE_URL:-https://hscpfs.mtk.nao.ac.jp/fileaccess/pfs}"
wget_config="${WGET_CONFIG:-$HOME/.pfs-scienceplatform.wgetrc}"
drp2d_root="${DRP2D_ROOT:-2d}"
field="${FIELD:-10091}"
products_csv="${PRODUCTS:-pfsMerged}"
slots="${SLOTS:-4}"
coadd_count="${COADD_COUNT:-0}"
coadd_pattern="${COADD_PATTERN:-}"
lam1d_mode="${LAM1D_MODE:-none}"
lam1d_root="${LAM1D_ROOT:-lam1d}"
lam1d_configs_csv="${LAM1D_CONFIGS:-default,modified}"
run_short="${RUN_SHORT:-}"
object_group_map=true
object_group_releases_csv="${OBJECT_GROUP_RELEASES:-}"
dry_run=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --program)
            program="$2"
            shift 2
            ;;
        --release)
            release="$2"
            shift 2
            ;;
        --csv)
            csv_file="$2"
            shift 2
            ;;
        --out-dir)
            out_dir="$2"
            shift 2
            ;;
        --base-url)
            base_url="$2"
            shift 2
            ;;
        --wget-config)
            wget_config="$2"
            shift 2
            ;;
        --drp2d-root)
            drp2d_root="$2"
            shift 2
            ;;
        --field)
            field="$2"
            shift 2
            ;;
        --products)
            products_csv="$2"
            shift 2
            ;;
        --slots)
            slots="$2"
            shift 2
            ;;
        --coadd-count)
            coadd_count="$2"
            shift 2
            ;;
        --coadd-pattern)
            coadd_pattern="$2"
            shift 2
            ;;
        --lam1d-mode)
            lam1d_mode="$2"
            shift 2
            ;;
        --lam1d-root)
            lam1d_root="$2"
            shift 2
            ;;
        --lam1d-configs)
            lam1d_configs_csv="$2"
            shift 2
            ;;
        --run-short)
            run_short="$2"
            shift 2
            ;;
        --object-group-map)
            object_group_map=true
            shift
            ;;
        --object-group-releases)
            object_group_releases_csv="$2"
            shift 2
            ;;
        --dry-run)
            dry_run=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

if [[ -z "$release" ]]; then
    echo "ERROR: --release is required." >&2
    usage >&2
    exit 2
fi

if [[ -z "$run_short" ]]; then
    run_short="${release%%_*}"
fi

products=()
if [[ -n "$products_csv" && "$products_csv" != "none" ]]; then
    if [[ "$products_csv" == "all" ]]; then
        products=(detectorMap pfsConfig sky1d pfsCalibrated pfsMerged)
    else
        old_ifs="$IFS"
        IFS=','
        for product in $products_csv; do
            products+=("$(trim "$product")")
        done
        IFS="$old_ifs"
    fi
fi

lam1d_configs=()
if [[ -n "$lam1d_configs_csv" ]]; then
    old_ifs="$IFS"
    IFS=','
    for config in $lam1d_configs_csv; do
        lam1d_configs+=("$(trim "$config")")
    done
    IFS="$old_ifs"
fi

object_group_releases=()
if [[ "$object_group_map" == true ]]; then
    object_group_releases+=("$release")
fi
if [[ -n "$object_group_releases_csv" ]]; then
    old_ifs="$IFS"
    IFS=','
    for og_release in $object_group_releases_csv; do
        object_group_releases+=("$(trim "$og_release")")
    done
    IFS="$old_ifs"
fi

for product in "${products[@]}"; do
    case "$product" in
        detectorMap|pfsConfig|sky1d|pfsCalibrated|pfsMerged)
            ;;
        *)
            echo "ERROR: unsupported product '$product'." >&2
            exit 2
            ;;
    esac
done

case "$lam1d_mode" in
    none|release|preview|pfscoadd)
        ;;
    *)
        echo "ERROR: unsupported --lam1d-mode '$lam1d_mode'." >&2
        exit 2
        ;;
esac

if [[ ${#products[@]} -gt 0 ]]; then
    if [[ -z "$csv_file" ]]; then
        echo "ERROR: --csv is required when --products is not none." >&2
        exit 2
    fi
    if [[ ! -f "$csv_file" ]]; then
        echo "ERROR: CSV file not found: $csv_file" >&2
        exit 2
    fi
    # Make the CSV path absolute before we cd into out_dir.
    csv_file="$(cd "$(dirname "$csv_file")" && pwd)/$(basename "$csv_file")"
fi

if [[ "$coadd_count" -gt 0 && -z "$coadd_pattern" ]]; then
    echo "ERROR: --coadd-pattern is required when --coadd-count is greater than 0." >&2
    exit 2
fi

if [[ "$lam1d_mode" != "none" && "$coadd_count" -le 0 ]]; then
    echo "ERROR: --lam1d-mode requires --coadd-count so the coadd index range is known." >&2
    exit 2
fi

program_url="${base_url}/programs/${program}"
drp_url="${program_url}/${drp2d_root}/${release}"

print_command() {
    printf 'wget'
    local arg
    for arg in "$@"; do
        printf ' %q' "$arg"
    done
    printf '\n'
}

run_wget() {
    local url="$1"
    local args=(-r -k -np --config "$wget_config" "$url")

    if [[ "$dry_run" == true ]]; then
        print_command "${args[@]}"
    else
        wget "${args[@]}"
    fi
}

run_wget_object_group() {
    local url="$1"
    local args=(-r -k -np -nH --config "$wget_config" --cut-dirs=1 "$url")

    if [[ "$dry_run" == true ]]; then
        print_command "${args[@]}"
    else
        wget "${args[@]}"
    fi
}

render_template() {
    local template="$1"
    local i="$2"
    local index
    index="$(printf "%03d" "$i")"

    local value="$template"
    value="${value//\{release\}/$release}"
    value="${value//\{field\}/$field}"
    value="${value//\{run_short\}/$run_short}"
    value="${value//\{index\}/$index}"
    value="${value//\{i\}/$i}"
    printf '%s' "$value"
}

download_pfs_coadds() {
    if [[ "$coadd_count" -le 0 ]]; then
        return
    fi

    local i filename url
    for i in $(seq 1 "$coadd_count"); do
        filename="$(render_template "$coadd_pattern" "$i")"
        url="${drp_url}/pfsCoadd/${field}/${filename}"
        run_wget "$url"
        echo "Finished pfsCoadd index: $i"
    done
}

download_lam1d() {
    if [[ "$lam1d_mode" == "none" ]]; then
        return
    fi

    local i index config url
    for i in $(seq 1 "$coadd_count"); do
        index="$(printf "%03d" "$i")"

        if [[ "$lam1d_mode" == "pfscoadd" ]]; then
            url="${drp_url}/pfsCoadd/${field}/${run_short}_${field}_${index}/data/pfsCoZcandidates-${field}.fits"
            run_wget "$url"
            echo "Finished pfsCoZcandidates index: $i"
            continue
        fi

        for config in "${lam1d_configs[@]}"; do
            case "$lam1d_mode" in
                release)
                    url="${program_url}/${lam1d_root}/${release}/${config}/${field}_${i}/data/pfsCoZcandidates-${field}.fits"
                    ;;
                preview)
                    url="${program_url}/${lam1d_root}/${config}/${field}/${run_short}_${field}_${index}/data/pfsCoZcandidates-${field}.fits"
                    ;;
            esac
            run_wget "$url"
        done
        echo "Finished pfsCoZcandidates index: $i"
    done
}

download_object_group_maps() {
    local og_release url
    for og_release in "${object_group_releases[@]}"; do
        [[ -z "$og_release" ]] && continue
        url="${program_url}/${drp2d_root}/${og_release}/objectGroupMap/"
        run_wget_object_group "$url"
        echo "Finished objectGroupMap for release: $og_release"
    done
}

download_visit_product() {
    local product="$1"
    local date="$2"
    local visit_id="$3"
    local slot arm url

    case "$product" in
        detectorMap)
            for slot in $(seq 1 "$slots"); do
                for arm in b r n; do
                    url="${drp_url}/detectorMap/${date}/${visit_id}/detectorMap_PFS_${visit_id}_${arm}${slot}_${release}.fits"
                    run_wget "$url"
                done
            done
            ;;
        pfsConfig)
            url="${drp_url}/pfsConfig/${date}/${visit_id}/pfsConfig_PFS_${visit_id}_${release}.fits"
            run_wget "$url"
            ;;
        sky1d)
            for slot in $(seq 1 "$slots"); do
                for arm in b r n; do
                    url="${drp_url}/sky1d/${date}/${visit_id}/sky1d_PFS_${visit_id}_${arm}${slot}_${release}.fits"
                    run_wget "$url"
                done
            done
            ;;
        pfsCalibrated)
            url="${drp_url}/pfsCalibrated/${date}/${visit_id}/pfsCalibrated_PFS_${visit_id}_${release}.fits"
            run_wget "$url"
            ;;
        pfsMerged)
            url="${drp_url}/pfsMerged/${date}/${visit_id}/pfsMerged_PFS_${visit_id}_${release}.fits"
            run_wget "$url"
            ;;
    esac
}

download_visit_products() {
    if [[ ${#products[@]} -eq 0 ]]; then
        return
    fi

    local date visit_id rest first_line product
    first_line=true
    while IFS=',' read -r date visit_id rest; do
        if [[ "$first_line" == true ]]; then
            first_line=false
            continue
        fi

        date="$(trim "$date")"
        visit_id="$(trim "$visit_id")"
        [[ -z "$date" || -z "$visit_id" ]] && continue

        echo "Date: $date, Visit ID: $visit_id"
        for product in "${products[@]}"; do
            download_visit_product "$product" "$date" "$visit_id"
            echo "Finished ${product} for Date: $date, Visit ID: $visit_id"
        done
    done < "$csv_file"
}

echo "Program: ${program}"
echo "Release: ${release}"
echo "2d root: ${drp2d_root}"
echo "Field: ${field}"
echo "Output dir: ${out_dir}"
if [[ "$dry_run" == true ]]; then
    echo "Mode: dry run"
else
    mkdir -p "$out_dir"
    cd "$out_dir"
fi

download_pfs_coadds
download_lam1d
download_object_group_maps
download_visit_products
