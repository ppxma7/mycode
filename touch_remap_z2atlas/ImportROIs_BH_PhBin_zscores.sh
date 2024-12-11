#!/bin/bash
cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh 
MOUNT='/Volumes/r15/DRS-TOUCHMAP/ma_ares_backup/TOUCH_REMAP/exp016/231108_share/'
export SUBJECTS_DIR=/Volumes/r15/DRS-TOUCHMAP/ma_ares_backup/TOUCH_REMAP/exp016/freesurfer/
#subjectlist="00393 00791_1mm_psir 03677 03942 13287 13172 13945 13382 13493 13654 13658 13695"
#subjectlist="00393 00791_1mm_psir 03677 03942 13172 13287 13382 13382_pre 13447 13493 13493_pre 13654 13654_pre 13658 13658_pre 13695 13695_pre 13945 14001_pre"
#subjectlist="13382_pre 13493_pre 13654_pre 13658_pre 13695_pre 14001_pre"
#subjectlist="006 009 011 013 014 015 020 023 024 028"
#subjectlist="021 022 030 032 033"
subjectlist="005 012 017 018 060"
study="sub016"

for subject in $subjectlist
do
    echo $subject
    #phase
    # mri_vol2surf --hemi lh --mov ${MOUNT}/${subject}/2mm/ph_RD_masked.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/${subject}/2mm/ph_RD_masked.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval ${MOUNT}/${subject}/2mm/ph_RD_masked.mgh --tval ${MOUNT}/${subject}/2mm/ph_RD_masked_fsaverage.mgh

    # mri_vol2surf --hemi rh --mov ${MOUNT}/${subject}/2mm/ph_LD_masked.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/${subject}/2mm/ph_LD_masked.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi rh --sval ${MOUNT}/${subject}/2mm/ph_LD_masked.mgh --tval ${MOUNT}/${subject}/2mm/ph_LD_masked_fsaverage.mgh

    # #coherence
    # mri_vol2surf --hemi lh --mov ${MOUNT}/${subject}/2mm/co_RD_masked.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/${subject}/2mm/co_RD_masked.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval ${MOUNT}/${subject}/2mm/co_RD_masked.mgh --tval ${MOUNT}/${subject}/2mm/co_RD_masked_fsaverage.mgh

    # mri_vol2surf --hemi rh --mov ${MOUNT}/${subject}/2mm/co_LD_masked.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/${subject}/2mm/co_LD_masked.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi rh --sval ${MOUNT}/${subject}/2mm/co_LD_masked.mgh --tval ${MOUNT}/${subject}/2mm/co_LD_masked_fsaverage.mgh

    #digits 1-5
    for (( k=1; k<=5; k++ ))
    do
    	mri_vol2surf --hemi lh --mov ${MOUNT}/${study}_${subject}/resultsSummary/atlas/RD${k}.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/${study}_${subject}/resultsSummary/atlas/RD${k}.mgh --surf white --out_type mgh
    	mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval ${MOUNT}/${study}_${subject}/resultsSummary/atlas/RD${k}.mgh --tval ${MOUNT}/${study}_${subject}/resultsSummary/atlas/RD${k}_fsaverage.mgh
    	mri_binarize --i  ${MOUNT}/${study}_${subject}/resultsSummary/atlas/RD${k}_fsaverage.mgh --min 0.1 --o ${MOUNT}/${study}_${subject}/resultsSummary/atlas/RD${k}_fsaverage.mgh

        mri_vol2surf --hemi rh --mov ${MOUNT}/${study}_${subject}/resultsSummary/atlas/LD${k}.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/${study}_${subject}/resultsSummary/atlas/LD${k}.mgh --surf white --out_type mgh
        mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi rh --sval ${MOUNT}/${study}_${subject}/resultsSummary/atlas/LD${k}.mgh --tval ${MOUNT}/${study}_${subject}/resultsSummary/atlas/LD${k}_fsaverage.mgh
        mri_binarize --i  ${MOUNT}/${study}_${subject}/resultsSummary/atlas/LD${k}_fsaverage.mgh --min 0.1 --o ${MOUNT}/${study}_${subject}/resultsSummary/atlas/LD${k}_fsaverage.mgh

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