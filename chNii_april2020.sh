#!/bin/sh
MOUNT='/Volumes/ares/nemosine/DigitAtlasv2/'
#export SUBJECTS_DIR=/Volumes/data/Research/TOUCHMAP/ma/subjects/
export SUBJECTS_DIR=/Volumes/ares/nemosine/subjects/
#subjectlist="00393 00791_1mm_psir 03677 03942 13172 13287 13382 13382_pre 13447 13493 13493_pre 13654 13654_pre 13658 13658_pre 13695 13695_pre 13945 14001_pre"
subjectlist="13382"
for subject in $subjectlist
do
    echo $subject
    fslchfiletype NIFTI_GZ ${MOUNT}/${subject}/motortopy/ph_RD_masked ${MOUNT}/${subject}/motortopy/ph_RD_masked
 #   fslchfiletype NIFTI_GZ ${MOUNT}/${subject}/2mm/ph_LD_masked ${MOUNT}/${subject}/2mm/ph_LD_masked
    fslchfiletype NIFTI_GZ ${MOUNT}/${subject}/motortopy/co_RD_masked ${MOUNT}/${subject}/motortopy/co_RD_masked
#    fslchfiletype NIFTI_GZ ${MOUNT}/${subject}/2mm/co_LD_masked ${MOUNT}/${subject}/2mm/co_LD_masked

    for (( k=1; k<=5; k++ ))
    do
#    	fslchfiletype NIFTI_GZ ${MOUNT}/${subject}/2mm/LD${k} ${MOUNT}/${subject}/2mm/LD${k}
    	fslchfiletype NIFTI_GZ ${MOUNT}/${subject}/motortopy/RD${k} ${MOUNT}/${subject}/motortopy/RD${k}
    done
done