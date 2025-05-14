#!/bin/bash

# Set base directory containing the glmdir folders
base_dir="/Volumes/r15/DRS-GBPerm/other/outputs/etiv_doss/"  # Change this to the actual path

# Set export directory
export_dir="/Users/ppzma/Library/CloudStorage/OneDrive-TheUniversityofNottingham/stage/nexpo_screenshots/eTIV_groups_doss"

# List of GLM folders
glmdir_list=(
  "lh.thickness.NexpoStudy_eTIV.10.glmdir"
  "lh.volume.NexpoStudy_eTIV.10.glmdir"
  "rh.thickness.NexpoStudy_eTIV.10.glmdir"
  "rh.volume.NexpoStudy_eTIV.10.glmdir"
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

    # Make sure destination folder exists
    mkdir -p "${export_dir}/${contrast_name}"

    # Copy with renamed filename
    if [ -f "$src" ]; then
      cp "$src" "$dest"
      echo "Copied: $src → $dest"
    else
      echo "Missing: $src"
    fi
  done
done
