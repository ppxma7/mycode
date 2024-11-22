#!/bin/bash
source $FREESURFER_HOME/SetUpFreeSurfer.sh 
export SUBJECTS_DIR=/Volumes/DRS-7TfMRI/DigitAtlas/FreeSurferDigitAtlas/
MOUNT='/Volumes/styx/prf_fsaverage/'
subjects=("test_LD")
anatsubs=("10301")
additional_overlays=("LD1_manual.nii.gz")

for ((i=0; i<${#subjects[@]}; i++))
do

	overlay_base=$(basename "$additional_overlays" .nii.gz)

	subject="${subjects[i]}"
	anatsub="${anatsubs[i]}"

	mri_vol2surf --hemi rh \
	--mov ${MOUNT}/$subject/${overlay_base}.nii.gz \
	--regheader ${anatsub} \
	--projfrac-avg 0.1 1 0.1 \
	--surf-fwhm 1 \
	--out ${MOUNT}/test_LD/${overlay_base}.mgh \
	--surf white \
	--out_type mgh
done


#Loop through each subject and corresponding anatomical subject
# for ((i=0; i<${#subjects[@]}; i++))
# do
#   subject="${subjects[i]}"
#   anatsub="${anatsubs[i]}"

#   hemi="rh"

#   echo "Processing subject: $subject"
#   # # Step 2: Process additional overlays using the registration
#   for overlay in "${additional_overlays[@]}"
#   do
#     overlay_base=$(basename "$overlay" .nii.gz)
#     #fslmaths ${MOUNT}/${subject}/${overlay} -nan ${MOUNT}/${subject}/${overlay_base}_no_nan.nii.gz

#     # Map volume to subject's surface in native space
#     mri_vol2surf --hemi ${hemi} \
#                  --mov ${MOUNT}/${subject}/${overlay_base}.nii.gz \
#                  --regheader ${anatsub} \
#                  --projfrac-avg 0.1 1 0.1 \
#                  --surf-fwhm 1 \
#                  --out ${MOUNT}/${subject}/${overlay_base}.mgh \
#                  --surf white \
#                  --out_type mgh

#     # Map to fsaverage
#     mri_surf2surf --srcsubject ${anatsub} \
#                   --trgsubject fsaverage \
#                   --hemi ${hemi} \
#                   --sval ${MOUNT}/${subject}/${overlay_base}.mgh \
#                   --tval ${MOUNT}/${subject}/${overlay_base}_fsaverage.mgh

#   done
#   echo "STAGE 1 Finished processing subject: $subject with anatomical subject: $anatsub"

# done


