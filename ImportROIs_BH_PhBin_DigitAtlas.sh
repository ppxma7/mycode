#!/bin/bash

# author : rosa March 2017
#convert Digit ROIs into freeSurfer surface space
subjectlist="00393 03677 10301 11120 11753"


for subject in $subjectlist
do
    echo $subject
     for (( k=1; k<=5; k++ ))
     do	

     mri_vol2surf \
             --hemi lh \
             --mov /data/projects/DigitAtlas/$subject/RD${k}.nii.gz \
             --regheader ${subject} \
             --projfrac-avg  0.1 1 0.1 \
             --surf-fwhm 1 \
             --out /data/projects/DigitAtlas/$subject/RD${k}.mgh \
             --surf white \
             --out_type mgh


     mri_vol2surf \
             --hemi rh \
             --mov /data/projects/DigitAtlas/$subject/LD${k}.nii.gz \
             --regheader ${subject} \
             --projfrac-avg  0.1 1 0.1 \
             --surf-fwhm 1 \
             --out /data/projects/DigitAtlas/$subject/LD${k}.mgh \
             --surf white \
             --out_type mgh


     mri_surf2surf --srcsubject $subject \
             --trgsubject fsaverage \
             --hemi lh \
             --sval /data/projects/DigitAtlas/$subject/RD${k}.mgh \
             --tval /data/projects/DigitAtlas/fsaverage/RD${k}_${subject}.mgh     

     mri_surf2surf --srcsubject $subject \
             --trgsubject fsaverage \
             --hemi rh \
             --sval /data/projects/DigitAtlas/$subject/LD${k}.mgh \
             --tval /data/projects/DigitAtlas/fsaverage/LD${k}_${subject}.mgh

     mri_binarize --i  /data/projects/DigitAtlas/fsaverage/RD${k}_${subject}.mgh --min 0.1 --o /data/projects/DigitAtlas/fsaverage/RD${k}_${subject}.mgh 
     mri_binarize --i  /data/projects/DigitAtlas/fsaverage/LD${k}_${subject}.mgh --min 0.1 --o /data/projects/DigitAtlas/fsaverage/LD${k}_${subject}.mgh        

     done

#    Also for all digits 
     # mri_vol2surf \
     #          --hemi lh \
     #          --mov /data/projects/DigitAtlas/$subject/RHand_Digits.nii.gz \
     #          --regheader $subject \
     #          --projfrac-avg  0.1 1 0.1 \
     #          --surf-fwhm 1 \
     #          --out /data/projects/DigitAtlas/$subject/RDigits.mgh \
     #          --surf white \
     #          --out_type mgh

     #  mri_surf2surf --srcsubject $subject \
     #          --trgsubject fsaverage \
     #          --hemi lh \
     #          --sval /data/projects/DigitAtlas/$subject/RDigits.mgh \
     #          --tval /data/projects/DigitAtlas/fsaverage/RDigits_${subject}.mgh   

     # mri_binarize --i  /data/projects/DigitAtlas/fsaverage/RDigits_${subject}.mgh --min 0.1 --o  /data/projects/DigitAtlas/fsaverage/RDigits_${subject}.mgh   

     # mri_vol2surf \
     #          --hemi rh \
     #          --mov /data/projects/DigitAtlas/$subject/LHand_Digits.nii.gz \
     #          --regheader $subject \
     #          --projfrac-avg  0.1 1 0.1 \
     #          --surf-fwhm 1 \
     #          --out /data/projects/DigitAtlas/$subject/LDigits.mgh \
     #          --surf white \
     #          --out_type mgh

     # mri_surf2surf --srcsubject $subject \
     #         --trgsubject fsaverage \
     #         --hemi rh \
     #         --sval /data/projects/DigitAtlas/$subject/LDigits.mgh \
     #         --tval /data/projects/DigitAtlas/fsaverage/LDigits_${subject}.mgh 

     # mri_binarize --i  /data/projects/DigitAtlas/fsaverage/LDigits_${subject}.mgh  --min 0.1 --o /data/projects/DigitAtlas/fsaverage/LDigits_${subject}.mgh    

done



#done