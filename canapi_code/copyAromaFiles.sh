#!/bin/bash

# Check for dry run flag
dry_run=false
if [[ "$1" == "--dry-run" ]]; then
    dry_run=true
    echo "🔍 Dry run enabled. No files will be copied or unzipped."
fi

# Define top path
top_path="/Volumes/kratos/CANAPI/canapi_sub12/spm_analysis"

# Define folder names
folders=(
    "rwrCANAPI12_WIPlow_TAP_R_20260224125628_4_nordic_clv_nonan_aroma"
    "rwrCANAPI12_WIP1bar_TAP_R_20260224125628_3_nordic_clv_nonan_aroma"
    "rwrCANAPI12_WIP1bar_TAP_L_20260224125628_5_nordic_clv_nonan_aroma"
    "rwrCANAPI12_WIPlow_TAP_L_20260224125628_6_nordic_clv_nonan_aroma"
)

# Define corresponding suffixes
suffixes=("1barR" "lowR" "1barL" "lowL")

# Loop through folders
for i in "${!folders[@]}"; do
    folder="${folders[$i]}"
    suffix="${suffixes[$i]}"
    source_file="${top_path}/${folder}/denoised_func_data_nonaggr.nii.gz"
    dest_file="${top_path}/denoised_func_data_nonaggr_${suffix}.nii.gz"

    if [ -f "$source_file" ]; then
        echo "Would copy: $source_file"
        echo "       to: $dest_file"
        echo "Would unzip: ${dest_file}"
        
        if ! $dry_run; then
            cp "$source_file" "$dest_file"
            gunzip -f "$dest_file"
        fi
    else
        echo "⚠️  File not found: $source_file"
    fi
done
