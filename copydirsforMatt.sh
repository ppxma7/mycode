#!/bin/bash

# Root where your full data live
SOURCE_ROOT="/Volumes/kratos"
# Where you want to create the lightweight version
DEST_ROOT="/Volumes/kratos/CANAPI_csv_subset"

# List of datasets
datasets=("canapi_sub01_030225" "canapi_sub02_180325" "canapi_sub03_180325" \
"canapi_sub04_280425" "canapi_sub05_240625" "canapi_sub06_240625" \
"canapi_sub07_010725" "canapi_sub08_010725" "canapi_sub09_160725" \
"canapi_sub10_160725")

# Files of interest
csvfiles=("1barR_Lmask.csv" "1barR_Rmask.csv" "1barL_Rmask.csv" "1barL_Lmask.csv")

for subj in "${datasets[@]}"; do
    echo "Processing $subj"

    # Define source and destination folders
    src="$SOURCE_ROOT/$subj/spm_analysis/first_level"
    dest="$DEST_ROOT/$subj/spm_analysis/first_level"

    # Create the destination folder structure
    mkdir -p "$dest"

    # Copy only the selected CSVs if they exist
    for f in "${csvfiles[@]}"; do
        if [ -f "$src/$f" ]; then
            cp "$src/$f" "$dest/"
            echo "  ✅ Copied $f"
        else
            echo "  ⚠️  Missing $f"
        fi
    done
done

echo "Done! Files saved under: $DEST_ROOT"
