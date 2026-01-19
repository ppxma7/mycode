#!/bin/bash

SMOOTH_SIGMA=2
groups=(group2 group5 group6)

for group in "${groups[@]}"; do
    echo "Processing ${group}..."

    mkdir -p smoothed/${group}

    n_smoothed=$(ls smoothed/${group}/*.nii* 2>/dev/null | wc -l)

    if (( n_smoothed > 0 )); then
        echo "  Found ${n_smoothed} smoothed files – skipping smoothing."
    else
        echo "  No smoothed files found – smoothing inputs."
        for f in ${group}/*.nii*; do
            fname=$(basename "$f")
            out="smoothed/${group}/${fname}"
            echo "    Smoothing $f -> $out"
            fslmaths "$f" -s $SMOOTH_SIGMA "$out"
        done
    fi

    echo "  Rebuilding ${group}_4D.nii.gz"
    fslmerge -t smoothed/${group}_4D.nii.gz smoothed/${group}/*.nii.gz
done

echo "Merging all groups into all_subjects_4D.nii.gz..."

fslmerge -t smoothed/all_subjects_4D.nii.gz \
    smoothed/group2_4D.nii.gz \
    smoothed/group5_4D.nii.gz \
    smoothed/group6_4D.nii.gz

echo "Done."


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





