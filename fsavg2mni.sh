#!/bin/bash

# Base path where glmdir directories are stored
BASE="/Volumes/DRS-GBPerm/other/outputs/etiv_doss"

# List of top-level hemisphere/measure directories
hemi_dirs=(
  lh.thickness.NexpoStudy_eTIV.10.glmdir
  lh.volume.NexpoStudy_eTIV.10.glmdir
  rh.thickness.NexpoStudy_eTIV.10.glmdir
  rh.volume.NexpoStudy_eTIV.10.glmdir
)

# Input MGH filename
INPUT_NAME="cache.th30.pos.sig.masked.mgh"

# Set FreeSurfer subject and templates
SUBJECT=fsaverage
TEMPLATE="$SUBJECTS_DIR/$SUBJECT/mri/brain.mgz"
MNI_TEMPLATE="$FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz"

# Loop over all glmdir directories
for topdir in "${hemi_dirs[@]}"; do
  hemi=${topdir:0:2}  # extract 'lh' or 'rh' from directory name
  echo "🔄 Processing top-level directory: $topdir (hemisphere: $hemi)"

  for subdir in "$BASE/$topdir"/*; do
    if [[ -d "$subdir" && -f "$subdir/$INPUT_NAME" ]]; then
      echo "▶️  Found input in: $subdir"

      # Define paths
      input_mgh="$subdir/$INPUT_NAME"
      out_mgz="$subdir/${hemi}.cache.th30.vol.mgz"
      out_nii="$subdir/${hemi}.cache.th30.vol.nii.gz"
      out_mni="$subdir/${hemi}.cache.th30.mni.nii.gz"

      # Step 1: Project from surface to volume
      mri_surf2vol \
        --surfval "$input_mgh" \
        --hemi $hemi \
        --identity $SUBJECT \
        --projfrac 0.5 \
        --template $TEMPLATE \
        --fillribbon \
        --subject $SUBJECT \
        --o "$out_mgz"

      # Step 2: Convert MGZ to NIfTI
      mri_convert "$out_mgz" "$out_nii"

      # Step 3: Project to MNI152 space
      mri_vol2vol \
        --mov "$out_nii" \
        --targ "$MNI_TEMPLATE" \
        --o "$out_mni" \
        --regheader \
        --interp trilinear

      echo "✅ Finished: $subdir → ${out_mni}"

    else
      echo "⚠️  Skipping $subdir (no $INPUT_NAME found)"
    fi
  done
done

echo "🎉 All done!"
