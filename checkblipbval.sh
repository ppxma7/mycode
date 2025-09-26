#!/bin/bash

# Base path
base_dir="/Volumes/kratos/NEXPODTIS/ppzma-20250923_145236"
not_in_line="${base_dir}/not_in_line"

# Create 'not_in_line' folder if it doesn't exist
mkdir -p "$not_in_line"

# Loop through each subject folder inside base_dir
for subj_dir in "$base_dir"/*/; do
    # Skip the 'not_in_line' folder itself
    if [[ "$subj_dir" == "$not_in_line/" ]]; then
        continue
    fi

    dti_dir="${subj_dir}/DTI"

    if [[ -d "$dti_dir" ]]; then
        # Look for files containing 'blip' and ending with '.bval' inside DTI/
        blip_bval_files=$(find "$dti_dir" -maxdepth 1 -type f -name "*blip*.bval")
    else
        blip_bval_files=""
    fi

    if [[ -z "$blip_bval_files" ]]; then
        echo "⚠️ No blip .bval file found in $dti_dir — moving subject folder to not_in_line/"
        mv "$subj_dir" "$not_in_line"/
    else
        echo "✅ Found blip .bval file in $dti_dir"
    fi
done
