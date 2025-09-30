#!/bin/bash

# Set base directory containing the glmdir folders
base_dir="/Volumes/DRS-GBPerm/other/outputs/etiv_doss_wage_wafirm_wsashb/"  # Change this to the actual path

# Set export directory
export_dir="/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/nexpo_afirm_screenshots/etiv_doss_wage_wafirm_wsashb"

# List of GLM folders
glmdir_list=(
  "lh.thickness.NexpoStudy_eTIV_wafirm_wsashb.10.glmdir"
  "lh.volume.NexpoStudy_eTIV_wafirm_wsashb.10.glmdir"
  "rh.thickness.NexpoStudy_eTIV_wafirm_wsashb.10.glmdir"
  "rh.volume.NexpoStudy_eTIV_wafirm_wsashb.10.glmdir"
)

# Loop through each GLM dir
for glmdir in "${glmdir_list[@]}"; do
  # Derive suffix like "lh_thickness" from the folder name
  suffix=$(echo "$glmdir" | cut -d'.' -f1,2 | tr '.' '_')

  # Full path to GLM dir
  full_glm_path="${base_dir}/${glmdir}"

  # Loop through each contrast folder inside the GLM dir
  for contrast_dir in "${full_glm_path}"/*/; do
    # Get just the contrast name (e.g., g1_vs_g2)
    contrast_name=$(basename "$contrast_dir")

    # Define source and destination
    src="${contrast_dir}/cacheth30possigcluster.csv"
    dest="${export_dir}/${contrast_name}/cacheth30possigcluster__${suffix}.csv"

    src2="${contrast_dir}/cacheth30negsigcluster.csv"
    dest2="${export_dir}/${contrast_name}/cacheth30negsigcluster__${suffix}.csv"

    # Make sure destination folder exists
    mkdir -p "${export_dir}/${contrast_name}"

    # Copy with renamed filename
    if [ -f "$src" ] && [ "$(wc -l < "$src")" -gt 1 ]; then
      cp "$src" "$dest"
      echo "Copied: $src → $dest"
    else
      echo "Skipped empty or missing: $src"
    fi

    if [ -f "$src2" ] && [ "$(wc -l < "$src2")" -gt 1 ]; then
      cp "$src2" "$dest2"
      echo "Copied: $src2 → $dest2"
    else
      echo "Skipped empty or missing: $src2"
    fi
  done
done





