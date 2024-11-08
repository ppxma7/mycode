#!/bin/bash
source $FREESURFER_HOME/SetUpFreeSurfer.sh 
export SUBJECTS_DIR=/Volumes/DRS-Touchmap/ma_ares_backup/subs/

# Define paths and file names
MOUNT='/Volumes/styx/'
anatMOUNT='/Volumes/DRS-Touchmap/ma_ares_backup/subs/'
subject="prf2/"  # Adjust as needed
anatsub="03677/"

# Define phase bin ranges and names
phase_bins=("0_1_57" "1_57_3_14" "3_14_4_71" "4_71_6_28")
phases=(0 1.57 3.14 4.71 6.28)

### Now move everything to fsaverage

# Define paths to raw fMRI and anatomical images
#raw_fmri=${MOUNT}/${subject}/fwd_15_nordic_toppedup_crop.nii.gz  # Replace with actual raw fMRI filename
#anat_img=${anatMOUNT}/${anatsub}/surfRelax/14359_mprage_pp.nii   # Assuming the anatomical image is in mgz format

# Define additional overlays and phase-binned thresholded images
additional_overlays=("adjr2.nii" "rfx.nii" "rfy.nii" "prefPD.nii" "prefDigit.nii")
phase_bins=("0_1_57" "1_57_3_14" "3_14_4_71" "4_71_6_28")

# # Step 1: Register raw fMRI to anatomical image and create registration file
# bbregister --s $anatsub --mov $raw_fmri --reg ${MOUNT}/${subject}/fmri2anat.dat --init-fsl --t2

# # Step 2: Process additional overlays using the registration
for overlay in "${additional_overlays[@]}"
do
    overlay_base=$(basename "$overlay" .nii)

    fslmaths ${MOUNT}/${subject}/${overlay} -nan ${MOUNT}/${subject}/${overlay_base}_no_nan.nii.gz

    # Map volume to subject's surface in native space
    mri_vol2surf --hemi lh \
                 --mov ${MOUNT}/${subject}/${overlay_base}_no_nan.nii.gz \
                 --regheader ${anatsub} \
                 --projfrac-avg 0.1 1 0.1 \
                 --surf-fwhm 1 \
                 --out ${MOUNT}/${subject}/${overlay_base}.mgh \
                 --surf white \
                 --out_type mgh

    # Map to fsaverage
    mri_surf2surf --srcsubject ${anatsub} \
                  --trgsubject fsaverage \
                  --hemi lh \
                  --sval ${MOUNT}/${subject}/${overlay_base}.mgh \
                  --tval ${MOUNT}/${subject}/${overlay_base}_fsaverage.mgh
done

# # Step 3: Process phase-binned coherence-thresholded images
for phase_bin in "${phase_bins[@]}"
do
    input_file=${MOUNT}/${subject}/ph_binned_${phase_bin}_co_thresh.nii.gz
    output_mgh=${MOUNT}/${subject}/ph_binned_${phase_bin}_co_thresh.mgh
    fsaverage_mgh=${MOUNT}/${subject}/ph_binned_${phase_bin}_co_thresh_fsaverage.mgh

    input_file2=${MOUNT}/${subject}/co_masked_${phase_bin}_co_thresh.nii.gz
    output_mgh2=${MOUNT}/${subject}/co_masked_${phase_bin}_co_thresh.mgh
    fsaverage_mgh2=${MOUNT}/${subject}/co_masked_${phase_bin}_co_thresh_fsaverage.mgh

    # Map volume to subject's surface in native space
    mri_vol2surf --hemi lh \
                 --mov $input_file \
                 --regheader ${anatsub} \
                 --projfrac-avg 0.1 1 0.1 \
                 --surf-fwhm 1 \
                 --out $output_mgh \
                 --surf white \
                 --out_type mgh

    # Map to fsaverage
    mri_surf2surf --srcsubject $anatsub \
                  --trgsubject fsaverage \
                  --hemi lh \
                  --sval $output_mgh \
                  --tval $fsaverage_mgh

    # Map volume to subject's surface in native space
    mri_vol2surf --hemi lh \
                 --mov $input_file2 \
                 --regheader ${anatsub} \
                 --projfrac-avg 0.1 1 0.1 \
                 --surf-fwhm 1 \
                 --out $output_mgh2 \
                 --surf white \
                 --out_type mgh

    # Map to fsaverage
    mri_surf2surf --srcsubject $anatsub \
                  --trgsubject fsaverage \
                  --hemi lh \
                  --sval $output_mgh2 \
                  --tval $fsaverage_mgh2
done
