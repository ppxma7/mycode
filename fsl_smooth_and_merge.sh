#!/bin/bash

# Set smoothing kernel (σ in mm)
SMOOTH_SIGMA=2

# Output folder for smoothed files
mkdir -p smoothed

# List of group folders (update if your folder names differ)
groups=(group1 group2 group3 group4)

# Process each group
for group in "${groups[@]}"; do
    echo "Processing $group..."

    mkdir -p smoothed/${group}
    for f in ${group}/*.nii; do
        fname=$(basename "$f")
        out="smoothed/${group}/${fname}"
        echo "Smoothing $f -> $out"
        fslmaths "$f" -s $SMOOTH_SIGMA "$out"
    done

    # Merge smoothed group into 4D
    fslmerge -t smoothed/${group}_4D.nii.gz smoothed/${group}/*.nii.gz
    echo "Created smoothed/${group}_4D.nii.gz"
done

# Merge all groups into a single 4D file
echo "Merging all groups into all_subjects_4D.nii.gz..."
fslmerge -t smoothed/all_subjects_4D.nii.gz \
    smoothed/group1_4D.nii.gz \
    smoothed/group2_4D.nii.gz \
    smoothed/group3_4D.nii.gz \
    smoothed/group4_4D.nii.gz

echo "Done! Final file: smoothed/all_subjects_4D.nii.gz"
