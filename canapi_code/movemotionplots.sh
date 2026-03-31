#!/bin/bash

SRC_BASE="/Volumes/kratos/CANAPI"
DST="/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/motionplots"

SUBS=(
    "canapi_sub01_030225"
    "canapi_sub02_180325"
    "canapi_sub03_180325"
    "canapi_sub04_280425"
    "canapi_sub05_240625"
    "canapi_sub06_240625"
    "canapi_sub07_010725"
    "canapi_sub08_010725"
    "canapi_sub09_160725"
    "canapi_sub10_160725"
    "canapi_sub11"
    "canapi_sub12"
    "canapi_sub13"
    "canapi_sub14"
    "canapi_sub15"
    "canapi_sub16"
)

mkdir -p "$DST"

for sub in "${SUBS[@]}"; do
    src_dir="$SRC_BASE/$sub/motion_plots"
    if [ -d "$src_dir" ]; then
        pngs=("$src_dir"/*.png)
        if [ -e "${pngs[0]}" ]; then
            cp "${pngs[@]}" "$DST/"
            echo "Copied PNGs from $sub"
        else
            echo "No PNGs found in $sub/motion_plots"
        fi
    else
        echo "motion_plots not found for $sub"
    fi
done

echo "Done."