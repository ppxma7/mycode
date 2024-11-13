#!/bin/bash
source $FREESURFER_HOME/SetUpFreeSurfer.sh 
export SUBJECTS_DIR=/Volumes/DRS-Touchmap/ma_ares_backup/subs/

# Define paths and file names
MOUNT='/Volumes/styx/prf_fsaverage/'
anatMOUNT='/Volumes/DRS-Touchmap/ma_ares_backup/subs/'

#anatMOUNT="/Volumes/DRS-7TfMRI/DigitAtlas/FreeSurferDigitAtlas/"
subjects=(
    "00393_LD_touchmap"
    "00393_RD_touchmap"
    "03677_LD"
    "03677_RD"
    "03942_LD"
    "03942_RD"
    "13172_LD"
    "13172_RD"
    "13493_Btx_LD"
    "13493_Btx_RD"
    "13493_NoBtx_LD"
    "13493_NoBtx_RD"
    "13658_Btx_LD"
    "13658_Btx_RD"
    "13658_NoBtx_LD"
    "13658_NoBtx_RD"
    "13695_Btx_LD"
    "13695_Btx_RD"
    "13695_NoBtx_LD"
    "13695_NoBtx_RD"
    "14001_Btx_LD"
    "14001_Btx_RD"
    "14001_NoBtx_LD"
    "14001_NoBtx_RD"
    )  # Adjust as needed

anatsubs=("00393"
    "00393"
    "03677"
    "03677"
    "03942"
    "03942"
    "13172"
    "13172"
    "13493"
    "13493"
    "13493"
    "13493"
    "13658"
    "13658"
    "13658"
    "13658"
    "13695"
    "13695"
    "13695"
    "13695"
    "14001"
    "14001"
    "14001"
    "14001"
  )


# subjects=("04217_LD"
#     "08740_RD"
#     "08966_RD"
#     "09621_RD"
#     "10301_LD"
#     "10301_RD"
#     "10875_RD"
#     "11120_LD"
#     "11120_RD"
#     "11240_LD"
#     "11240_RD"
#     "11251_LD"
#     "11251_RD"
#     "HB2_LD"
#     "HB2_RD"
#     "HB3_LD"
#     "HB3_RD"
#     "HB4_LD"
#     "HB4_RD"
#     "HB5_LD"
#     "HB5_RD"
#     )

# anatsubs=("04217_bis"
#   "08740"
#   "08966"
#   "09621"
#   "10301"
#   "10301"
#   "10875"
#   "11120"
#   "11120"
#   "11240"
#   "11240"
#   "11251"
#   "11251"
#   "HB2"
#   "HB2"
#   "HB3"
#   "HB3"
#   "HB4"
#   "HB4"
#   "HB5"
#   "HB5"
#   )

# subjects=("prf1"
#     "prf2"
#     "prf3"
#     "prf4"
#     "prf6"
#     "prf7"
#     "prf8"
#     "prf9"
#     "prf10"
#     "prf11" 
#     "prf12"
#     )

# anatsubs=("14359"
#   "03677"
#   "12778_psir_1mm"
#   "10925"
#   "15435_psir_1mm"
#   "11251"
#   "15123"
#   "14446"
#   "15252_psir_1mm"
#   "11766"
#   "13676"
#   )





# Define phase bin ranges and names
# phase_bins=("0_1_57" "1_57_3_14" "3_14_4_71" "4_71_6_28")
# phases=(0 1.57 3.14 4.71 6.28)

phase_bins=("0_1_256" "1_256_2_512" "2_512_3_768" "3_768_5_024" "5_024_6_28")
phases=(0 1.256 2.512 3.768 5.024 6.28)

### Now move everything to fsaverage

# Define paths to raw fMRI and anatomical images
#raw_fmri=${MOUNT}/${subject}/fwd_15_nordic_toppedup_crop.nii.gz  # Replace with actual raw fMRI filename
#anat_img=${anatMOUNT}/${anatsub}/surfRelax/14359_mprage_pp.nii   # Assuming the anatomical image is in mgz format

# Define additional overlays and phase-binned thresholded images
#additional_overlays=("adjr2.nii" "rfx.nii" "rfy.nii" "prefPD.nii" "prefDigit.nii")

additional_overlays=("adjr2.nii" "rf.nii" "prefPD.nii" "prefDigit.nii")

#phase_bins=("0_1_57" "1_57_3_14" "3_14_4_71" "4_71_6_28")

# # Step 1: Register raw fMRI to anatomical image and create registration file
# bbregister --s $anatsub --mov $raw_fmri --reg ${MOUNT}/${subject}/fmri2anat.dat --init-fsl --t2


# Loop through each subject and corresponding anatomical subject
for ((i=0; i<${#subjects[@]}; i++))
do
  subject="${subjects[i]}"
  anatsub="${anatsubs[i]}"

  echo "Processing subject: $subject"
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
  echo "STAGE 1 Finished processing subject: $subject with anatomical subject: $anatsub"

done

# # Step 3: Process phase-binned coherence-thresholded images

for ((i=0; i<${#subjects[@]}; i++))
do
  subject="${subjects[i]}"
  anatsub="${anatsubs[i]}"

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

  echo "STAGE 2 Finished processing subject: $subject with anatomical subject: $anatsub"

done
