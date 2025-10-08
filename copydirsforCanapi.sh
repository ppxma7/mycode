#!/bin/bash

# --- Source and destination roots ---
SOURCE_ROOT="/Volumes/kratos"
DEST_ROOT="/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data"

# --- Datasets and matching sub-folders ---
datasets=("canapi_sub01_030225" "canapi_sub02_180325" "canapi_sub03_180325" \
"canapi_sub04_280425" "canapi_sub05_240625" "canapi_sub06_240625" \
"canapi_sub07_010725" "canapi_sub08_010725" "canapi_sub09_160725" \
"canapi_sub10_160725")

# --- Files to copy ---

myfiles=( \
"1barR_neg.csv" "1barL_neg_glassbrain.pdf" "1barL_neg.csv" \
"lowL_neg_glassbrain.pdf" "lowL_neg.csv" "lowR_neg_glassbrain.pdf" "lowR_neg.csv" \
"1barR_neg_glassbrain.pdf" "1barL_Rmask_glassbrain.pdf" "1barL_Rmask.csv" \
"1barL_Lmask_glassbrain.pdf" "1barL_Lmask.csv" "1barR_Rmask_glassbrain.pdf" "1barR_Rmask.csv" \
"1barR_Lmask.csv" "1barR_Lmask_glassbrain.pdf" "LvR_glassbrain.pdf" "LvR.csv" \
"RvL_glassbrain.pdf" "RvL.csv" "1barvslowL_glassbrain.pdf" "1barvslowL.csv" \
"1barvslowR_glassbrain.pdf" "1barvslowR.csv" "lowL_glassbrain.pdf" "lowL.csv" \
"1barL_glassbrain.pdf" "1barL.csv" "lowR_glassbrain.pdf" "lowR.csv" \
"1barR_glassbrain.pdf" "1barR.csv" \
)




# --- Loop over subjects ---
for i in "${!datasets[@]}"; do
    subj="${datasets[$i]}"
    subnum=$(printf "sub%02d" $((i+1)))  # → sub01, sub02, etc.

    echo "Processing $subj → $subnum"

    src="$SOURCE_ROOT/$subj/spm_analysis/first_level"
    dest="$DEST_ROOT/$subnum/boxcar"

    mkdir -p "$dest"

    for f in "${myfiles[@]}"; do
        if [ -f "$src/$f" ]; then
            cp "$src/$f" "$dest/"
            echo "  ✅ Copied $f"
        else
            echo "  ⚠️  Missing $f in $subj"
        fi
    done
done

echo "✅ All done. Files saved to: $DEST_ROOT"
