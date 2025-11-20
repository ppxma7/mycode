#!/bin/bash

# Set smoothing kernel (σ in mm)
SMOOTH_SIGMA=2

# Output folder for smoothed files
# mkdir -p smoothed

# List of group folders (update if your folder names differ)
#groups=(group2 group5 group6)
groups=(group1 group2 group3 group4)
#groups=(group2)
# Process each group
for group in "${groups[@]}"; do
    echo "Processing $group..."

    mkdir -p smoothed/${group}
    for f in ${group}/*.nii*; do
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
# fslmerge -t smoothed/all_subjects_4D.nii.gz \
#     smoothed/group2_4D.nii.gz \
#     smoothed/group5_4D.nii.gz \
#     smoothed/group6_4D.nii.gz \

fslmerge -t smoothed/all_subjects_4D.nii.gz \
    smoothed/group1_4D.nii.gz \
    smoothed/group2_4D.nii.gz \
    smoothed/group3_4D.nii.gz \
    smoothed/group4_4D.nii.gz \


echo "Done! Final file: smoothed/all_subjects_4D.nii.gz"

# #!/bin/bash
# set -euo pipefail

# # --- SETTINGS ---
# SMOOTH_SIGMA=2
# groups=(group2 group5 group6)

# # 1) Smooth ONLY group5
# group="group6"
# echo "Smoothing $group..."
# mkdir -p smoothed/${group}
# for f in ${group}/*.nii; do
#     fname=$(basename "$f" .nii)
#     out="smoothed/${group}/${fname}.nii.gz"
#     echo "Smoothing $f -> $out"
#     fslmaths "$f" -s $SMOOTH_SIGMA "$out"
# done

# # 2) Merge group5 after smoothing
# fslmerge -t smoothed/group6_4D.nii.gz smoothed/group6/*.nii.gz

# # 3) Merge all groups (1–4 already smoothed)
# echo "Merging all groups into smoothed/all_subjects_4D.nii.gz..."
# # fslmerge -t smoothed/all_subjects_4D.nii.gz \
# #     smoothed/group1_4D.nii.gz \
# #     smoothed/group2_4D.nii.gz \
# #     smoothed/group3_4D.nii.gz \
# #     smoothed/group4_4D.nii.gz \
# #     smoothed/group5_4D.nii.gz

# fslmerge -t smoothed/all_subjects_4D.nii.gz \
#     smoothed/group2_4D.nii.gz \
#     smoothed/group5_4D.nii.gz \
#     smoothed/group6_4D.nii.gz

# echo "Done!"





