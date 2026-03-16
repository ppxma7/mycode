#!/bin/bash

BASE="/Volumes/kratos/CANAPI"
DEST="${BASE}/saved_images"

SUBJECTS=(
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

FILES=(
    "1barR_Lmask.csv"
    "1barL_Rmask_glassbrain.pdf"
    "1barL_Rmask.csv"
    "1barR_Rmask_glassbrain.pdf"
    "1barR_Rmask.csv"
    "1barL_Lmask_glassbrain.pdf"
    "1barL_Lmask.csv"
    "1barR_Lmask_glassbrain.pdf"
)

mkdir -p "$DEST"

for sub in "${SUBJECTS[@]}"; do
    src_dir="${BASE}/${sub}/spm_analysis/first_level_waccel"
    sub_dest="${DEST}/${sub}"
    mkdir -p "$sub_dest"
    
    for f in "${FILES[@]}"; do
        src="${src_dir}/${f}"
        if [ -f "$src" ]; then
            cp "$src" "$sub_dest/"
            echo "Copied: ${sub}/${f}"
        else
            echo "MISSING: ${sub}/${f}"
        fi
    done
done

echo "Done."