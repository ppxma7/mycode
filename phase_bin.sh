#!/bin/bash
source $FREESURFER_HOME/SetUpFreeSurfer.sh 
export SUBJECTS_DIR=/Volumes/DRS-Touchmap/ma_ares_backup/subs/

# Define paths and file names
MOUNT='/Volumes/styx/'
anatMOUNT='/Volumes/DRS-Touchmap/ma_ares_backup/subs/'
subject="prf2/"  # Adjust as needed
anatsub="03677/"

# Mask "co.nii" and "ph.nii" with "mask.nii"
fslmaths ${MOUNT}/${subject}/co.nii -mas ${MOUNT}/${subject}/mask.nii ${MOUNT}/${subject}/co_masked.nii
fslmaths ${MOUNT}/${subject}/ph.nii -mas ${MOUNT}/${subject}/mask.nii ${MOUNT}/${subject}/ph_masked.nii

fslmaths ${MOUNT}/${subject}/co_masked.nii -nan ${MOUNT}/${subject}/co_masked_no_nan.nii
fslmaths ${MOUNT}/${subject}/ph_masked.nii -nan ${MOUNT}/${subject}/ph_masked_no_nan.nii


# Define phase bin ranges and names
phase_bins=("0_1_57" "1_57_3_14" "3_14_4_71" "4_71_6_28")
phases=(0 1.57 3.14 4.71 6.28)

for ((i=0; i<4; i++))
do
    lower=${phases[$i]}
    upper=${phases[$i+1]}
    phase_bin=${phase_bins[$i]}
    
    # Create phase-specific mask (preserving phase values)
    fslmaths ${MOUNT}/${subject}/ph_masked_no_nan.nii -thr $lower -uthr $upper ${MOUNT}/${subject}/ph_binned_${phase_bin}.nii
    
    # Apply the phase-specific mask to coherence data (preserving coherence values within the phase bin)
    fslmaths ${MOUNT}/${subject}/co_masked_no_nan.nii -mas ${MOUNT}/${subject}/ph_binned_${phase_bin}.nii ${MOUNT}/${subject}/co_masked_${phase_bin}.nii

done

# Threshold each phase bin image based on coherence level of 0.3
for phase_bin in "${phase_bins[@]}"
do
    # Apply coherence threshold to each phase-binned image and co-binned images
    fslmaths ${MOUNT}/${subject}/co_masked_no_nan.nii -thr 0.3 -bin -mul ${MOUNT}/${subject}/ph_binned_${phase_bin}.nii ${MOUNT}/${subject}/ph_binned_${phase_bin}_co_thresh.nii
    fslmaths ${MOUNT}/${subject}/co_masked_no_nan.nii -thr 0.3 -bin -mul ${MOUNT}/${subject}/co_masked_${phase_bin}.nii ${MOUNT}/${subject}/co_masked_${phase_bin}_co_thresh.nii
done