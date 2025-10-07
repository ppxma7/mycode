#!/bin/bash

cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh

MOUNT='/Volumes/kratos/moveAtlas2MNI/'

for (( k=1; k<=5; k++ ))
do
  echo "Processing RD${k}"

  # Fill ROI into fsaverage ribbon (MNI305 space)
  mri_surf2vol \
    --so $FREESURFER_HOME/subjects/fsaverage/surf/lh.white ${MOUNT}/RD${k}_manual.mgz \
    --ribbon $FREESURFER_HOME/subjects/fsaverage/mri/ribbon.mgz \
    --subject fsaverage \
    --o ${MOUNT}/RD${k}_fsaverage_vol.mgz

  # Convert to nifti
  mri_convert ${MOUNT}/RD${k}_fsaverage_vol.mgz ${MOUNT}/RD${k}_fsaverage_vol.nii.gz

  # Binarize to keep it as mask
  mri_binarize --i ${MOUNT}/RD${k}_fsaverage_vol.nii.gz \
    --min 0.0001 \
    --o ${MOUNT}/RD${k}_fsaverage_vol_bin.nii.gz


  echo "Processing LD${k}"

  # Fill ROI into fsaverage ribbon (MNI305 space)
  mri_surf2vol \
    --so $FREESURFER_HOME/subjects/fsaverage/surf/rh.white ${MOUNT}/LD${k}_manual.mgz \
    --ribbon $FREESURFER_HOME/subjects/fsaverage/mri/ribbon.mgz \
    --subject fsaverage \
    --o ${MOUNT}/LD${k}_fsaverage_vol.mgz

  # Convert to nifti
  mri_convert ${MOUNT}/LD${k}_fsaverage_vol.mgz ${MOUNT}/LD${k}_fsaverage_vol.nii.gz

  # Binarize to keep it as mask
  mri_binarize --i ${MOUNT}/LD${k}_fsaverage_vol.nii.gz \
    --min 0.0001 \
    --o ${MOUNT}/LD${k}_fsaverage_vol_bin.nii.gz

done

echo "✅ Done – all 5 ROIs projected to MNI152 space."
