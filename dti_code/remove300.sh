#!/bin/bash

root="/Volumes/r15/DRS-GBPerm/other/CHAIN_inputs_less300/"

folders=(
CHN003_V6_C_less300
CHN005_v6_redo_C_less300
CHN006_V6_C_less300
CHN007_V6_C_less300
CHN008_V6_DTI_C_less300
CHN009_V6_C_less300
CHN010_V6_2_DTI_C_less300
CHN012_less300
CHN013_v6_classic_less300
CHN014_V6_DTI_C_less300
CHN015_V6_DTI_C_less300
CHN019_V6_C_less300
)

for folder in "${folders[@]}"; do
    fullpath="$root/$folder"
    echo "Processing $folder"
    cd "$fullpath" || { echo "Folder $fullpath not found"; continue; }

    # Create old/ folder if it doesn't exist
    mkdir -p old

    # Find the .nii file without 'blip' in the name
    nii_file=$(ls *.nii | grep -v blip)
    if [ -z "$nii_file" ]; then
        echo "No .nii file found in $folder"
        cd ..
        continue
    fi

    # Define temporary part names
    part1="part1.nii.gz"
    part2="part2.nii.gz"
    part3="part3.nii.gz"

    # Run fslroi commands
    fslroi "$nii_file" "$part1" 0 1
    fslroi "$nii_file" "$part2" 7 -1

    # Merge parts
    fslmerge -t "$part3" "$part1" "$part2"

    echo "Checking $part3:"
    fslinfo "$part3" | grep ^dim4

    # Move original to old/
    mv "$nii_file" old/

    # Rename merged file to original name and gunzip
    mv "$part3" "$nii_file.gz"
    gunzip -f "$nii_file.gz"

    # Clean up temporary parts
    rm -f "$part1" "$part2"

    cd ..
done
