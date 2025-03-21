#!/bin/bash
cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh
MOUNT='/Users/spmic/data/ken_surf_testig/'
ANATMOUNT='/Users/spmic/data/subs/'
export SUBJECTS_DIR=$ANATMOUNT

subjectlist="atlas"
anatsub="020"

for subject in $subjectlist
do
   echo "Native subject: ${anatsub}"
   echo "ROI folder: ${subject}"

   # Process digits 1-5
   for (( k=1; k<=5; k++ ))
   do
      #Transform the ROI from fsaverage surface to the native subject's surface
      mri_surf2surf --srcsubject fsaverage \
         --trgsubject ${anatsub} \
         --hemi lh \
         --sval ${MOUNT}/${subject}/RD${k}_manual.mgz \
         --tval ${MOUNT}/${subject}/RD${k}_${anatsub}.mgz

      # Method One: Convert the surface ROI into the volume space,
      # using the subject's lh.white surface and filling via the ribbon.
      mri_surf2vol --so ${SUBJECTS_DIR}/${anatsub}/surf/lh.white ${MOUNT}/${subject}/RD${k}_${anatsub}.mgz \
         --ribbon ${SUBJECTS_DIR}/${anatsub}/mri/ribbon.mgz \
         --subject ${anatsub} \
         --o ${MOUNT}/${subject}/RD${k}_${anatsub}_vol_method1.mgz

      mri_convert ${MOUNT}/${subject}/RD${k}_${anatsub}_vol_method1.mgz ${MOUNT}/${subject}/RD${k}_${anatsub}_vol_method1.nii.gz

      #binarise
      mri_binarize --i ${MOUNT}/${subject}/RD${k}_${anatsub}_vol_method1.nii.gz \
         --min 0.0001 --o ${MOUNT}/${subject}/RD${k}_${anatsub}_vol_method1_bin.nii.gz


      # Method Two: 
      # This method is the option to now not fill the ribbon. 
      # The ribbon fill uses projection instead of construction and so this can leave some holes.
      # Project the native surface ROI into the subject's volume space
      mri_surf2vol --surfval ${MOUNT}/${subject}/RD${k}_${anatsub}.mgz \
         --hemi lh \
         --projfrac 0.5 \
         --identity ${anatsub} \
         --template ${SUBJECTS_DIR}/${anatsub}/mri/brain.mgz \
         --o ${MOUNT}/${subject}/RD${k}_${anatsub}_vol_method2.mgz

      mri_convert ${MOUNT}/${subject}/RD${k}_${anatsub}_vol_method2.mgz ${MOUNT}/${subject}/RD${k}_${anatsub}_vol_method2.nii.gz

      #binarise
      mri_binarize --i ${MOUNT}/${subject}/RD${k}_${anatsub}_vol_method2.nii.gz \
         --min 0.0001 --o ${MOUNT}/${subject}/RD${k}_${anatsub}_vol_method2_bin.nii.gz


   done
done
echo "Done!"
