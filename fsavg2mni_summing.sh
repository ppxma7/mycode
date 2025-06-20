#!/bin/bash

# Base path where glmdir directories are stored
BASE="/Volumes/DRS-GBPerm/other/outputs/etiv_doss"

# Output directory
OUTPUT_DIR="/Volumes/r15/DRS-GBPerm/other/t1_mprage_overlap"
mkdir -p "$OUTPUT_DIR"

# Hemisphere/measure directories
lh_dirs=(
  lh.thickness.NexpoStudy_eTIV.10.glmdir
  lh.volume.NexpoStudy_eTIV.10.glmdir
)
rh_dirs=(
  rh.thickness.NexpoStudy_eTIV.10.glmdir
  rh.volume.NexpoStudy_eTIV.10.glmdir
)

# Loop over lh directories
for i in "${!lh_dirs[@]}"; do
  lh_path="$BASE/${lh_dirs[$i]}"
  rh_path="$BASE/${rh_dirs[$i]}"
  label="${lh_dirs[$i]%%.NexpoStudy_eTIV.10.glmdir}"  # e.g., lh.volume

  echo "🔄 Matching: ${lh_dirs[$i]} ↔ ${rh_dirs[$i]}"

  for lh_subdir in "$lh_path"/*; do
    subname=$(basename "$lh_subdir")  # e.g., g1_vs_g2
    rh_subdir="$rh_path/$subname"

    lh_file="$lh_subdir/lh.cache.th30.mni.nii.gz"
    rh_file="$rh_subdir/rh.cache.th30.mni.nii.gz"

    # Output file with informative name
    out_file="${OUTPUT_DIR}/${label}.${subname}.both.cache.th30.mni.nii.gz"

    if [[ -f "$lh_file" && -f "$rh_file" ]]; then
      echo "✅ Combining $subname → $out_file"
      fslmaths "$lh_file" -add "$rh_file" "$out_file"
    else
      echo "⚠️  Skipping $subname — missing lh or rh file"
    fi
  done
done

echo "🎉 All combinations saved to: $OUTPUT_DIR"
