#!/bin/bash

# Define full paths
MPRAGE="/Volumes/nemosine/fMRI_airstim_pilot01_080725/veinmasking/backup/15519_MPRAGE_masked.nii"
FLASH="/Volumes/nemosine/fMRI_airstim_pilot01_080725/veinmasking/backup/flash_fixed.nii"
FLASH_PH="/Volumes/nemosine/fMRI_airstim_pilot01_080725/veinmasking/backup/flash_fixed_ph.nii"
OUTPUT="/Volumes/nemosine/fMRI_airstim_pilot01_080725/veinmasking/backup/MPRAGE2FLASH.nii.gz"

# Output directory
OUTDIR="/Volumes/nemosine/fMRI_airstim_pilot01_080725/veinmasking/backup/"

# Check if output already exists
if [ -f "$OUTPUT" ]; then
    echo "FLIRT output $OUTPUT already exists — skipping registration."
else
    echo "Running FLIRT registration..."
    flirt -in "$MPRAGE" -ref "$FLASH" -out "$OUTPUT" -omat "$OUTDIR/MPRAGE2FLASH.mat"
fi

# Apply mask to FLASH image
echo "Masking FLASH image..."
fslmaths "$FLASH" -mas "$OUTPUT" "$OUTDIR/flash_fixed_masked"

# Apply mask to FLASH phase image
echo "Masking FLASH phase image..."
fslmaths "$FLASH_PH" -mas "$OUTPUT" "$OUTDIR/flash_fixed_masked_ph"

# Create thresholded mask
echo "Creating thresholded mask..."
fslmaths "$OUTDIR/flash_fixed_masked" -thr 10 "$OUTDIR/premask"

# Binarize the mask
echo "Binarizing the mask..."
fslmaths "$OUTDIR/premask.nii.gz" -bin "$OUTDIR/flash_fixed_masked_mask"

# Binarize the mask
echo "Change to regular niftis..."
fslchfiletype NIFTI "$OUTDIR/flash_fixed_masked"
fslchfiletype NIFTI "$OUTDIR/flash_fixed_masked_ph"
fslchfiletype NIFTI "$OUTDIR/flash_fixed_masked_mask"

echo "All steps completed successfully."
