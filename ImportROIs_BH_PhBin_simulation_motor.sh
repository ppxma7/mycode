#!/bin/bash
cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh 
MOUNT='/Volumes/ares/nemosine/DigitAtlasv2/'
export SUBJECTS_DIR=/Volumes/ares/nemosine/subjects/
#subjectlist="00393 00791_1mm_psir 03677 03942 13287 13172 13945 13382 13493 13654 13658 13695"
#subjectlist="00393 00791_1mm_psir 03677 03942 13172 13287 13382 13382_pre 13447 13493 13493_pre 13654 13654_pre 13658 13658_pre 13695 13695_pre 13945 14001_pre"
#subjectlist="13382_pre 13493_pre 13654_pre 13658_pre 13695_pre 14001_pre"
subjectlist="13382"
for subject in $subjectlist
do
    echo $subject
    #phase
    mri_vol2surf --hemi lh --mov ${MOUNT}/${subject}/motortopy/ph_RD_masked.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/${subject}/motortopy/ph_RD_masked.mgh --surf white --out_type mgh
    mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval ${MOUNT}/${subject}/motortopy/ph_RD_masked.mgh --tval ${MOUNT}/${subject}/motortopy/ph_RD_masked_fsaverage.mgh

    # mri_vol2surf --hemi rh --mov ${MOUNT}/${subject}/2mm/ph_LD_masked.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/${subject}/2mm/ph_LD_masked.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi rh --sval ${MOUNT}/${subject}/2mm/ph_LD_masked.mgh --tval ${MOUNT}/${subject}/2mm/ph_LD_masked_fsaverage.mgh

    #coherence
    mri_vol2surf --hemi lh --mov ${MOUNT}/${subject}/motortopy/co_RD_masked.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/${subject}/motortopy/co_RD_masked.mgh --surf white --out_type mgh
    mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval ${MOUNT}/${subject}/motortopy/co_RD_masked.mgh --tval ${MOUNT}/${subject}/motortopy/co_RD_masked_fsaverage.mgh

    # mri_vol2surf --hemi rh --mov ${MOUNT}/${subject}/2mm/co_LD_masked.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/${subject}/2mm/co_LD_masked.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi rh --sval ${MOUNT}/${subject}/2mm/co_LD_masked.mgh --tval ${MOUNT}/${subject}/2mm/co_LD_masked_fsaverage.mgh

    #digits 1-5
    for (( k=1; k<=5; k++ ))
    do
    	mri_vol2surf --hemi lh --mov ${MOUNT}/${subject}/motortopy/RD${k}.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/${subject}/motortopy/RD${k}.mgh --surf white --out_type mgh
    	mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval ${MOUNT}/${subject}/motortopy/RD${k}.mgh --tval ${MOUNT}/${subject}/motortopy/RD${k}_fsaverage.mgh
    	mri_binarize --i  ${MOUNT}/${subject}/motortopy/RD${k}_fsaverage.mgh --min 0.1 --o ${MOUNT}/${subject}/motortopy/RD${k}_fsaverage.mgh

    	# mri_vol2surf --hemi rh --mov ${MOUNT}/${subject}/2mm/LD${k}.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/${subject}/2mm/LD${k}.mgh --surf white --out_type mgh
    	# mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi rh --sval ${MOUNT}/${subject}/2mm/LD${k}.mgh --tval ${MOUNT}/${subject}/2mm/LD${k}_fsaverage.mgh
    	# mri_binarize --i  ${MOUNT}/${subject}/2mm/LD${k}_fsaverage.mgh --min 0.1 --o ${MOUNT}/${subject}/2mm/LD${k}_fsaverage.mgh

    done
done
echo "Done!"

# for subject in $subjectlist
# do
#     echo $subject
#      for (( k=1; k<=5; k++ ))
#      do
#      mri_vol2surf --hemi lh --mov /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/2mm/RD${k}.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/2mm/RD${k}.mgh --surf white --out_type mgh
#      mri_vol2surf --hemi rh --mov /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/2mm/LD${k}.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/2mm/LD${k}.mgh --surf white --out_type mgh

#      mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/2mm/RD${k}.mgh --tval /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_2mm/RD${k}_${subject}.mgh
#      mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi rh --sval /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/2mm/LD${k}.mgh --tval /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_2mm/LD${k}_${subject}.mgh

#      mri_binarize --i  /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_2mm/RD${k}_${subject}.mgh --min 0.1 --o /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_2mm/RD${k}_${subject}.mgh 
#      mri_binarize --i  /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_2mm/LD${k}_${subject}.mgh --min 0.1 --o /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_2mm/LD${k}_${subject}.mgh  

#     done
# done