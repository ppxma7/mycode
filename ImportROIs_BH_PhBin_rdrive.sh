#!/bin/bash

# author : rosa March 2017
#convert Digit ROIs into freeSurfer surface space
#subjectlist="00393 03677 10301 11120 11753"
cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh 

# temporarily set subjects dir to here
MOUNT="TOUCHMAP"
export SUBJECTS_DIR=/Volumes/$MOUNT/ma/subjects

#also remember to change the subjects directory name to the base, i.e. without any pre_ etc.

#subjectlist="14001_1mm_psir"
#subjectlist="03942 03677 00393 13945 13382 13493 13654 13658 13695 14001" 
#subjectlist="13695_pre 13493_pre 13382_pre 13658_pre 14001_pre 13654_pre"
#subjectlist="00393 00791 03677 03942 13287 13172 13945 13382 13493 13654 13658 13695 14001"
#subjectlist="13382_pre 13493_pre 13654_pre 13658_pre 13695_pre 14001_pre"
#subjectlist="13447"
subjectlist="14001"

for subject in $subjectlist
do
    echo $subject
     for (( k=1; k<=5; k++ ))
     do
     mri_vol2surf --hemi lh --mov /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/2mm/RD${k}.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/2mm/RD${k}.mgh --surf white --out_type mgh
     mri_vol2surf --hemi rh --mov /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/2mm/LD${k}.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/2mm/LD${k}.mgh --surf white --out_type mgh

     mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/2mm/RD${k}.mgh --tval /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_2mm/RD${k}_${subject}.mgh
     mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi rh --sval /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/2mm/LD${k}.mgh --tval /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_2mm/LD${k}_${subject}.mgh

     mri_binarize --i  /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_2mm/RD${k}_${subject}.mgh --min 0.1 --o /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_2mm/RD${k}_${subject}.mgh 
     mri_binarize --i  /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_2mm/LD${k}_${subject}.mgh --min 0.1 --o /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_2mm/LD${k}_${subject}.mgh  

    done
done

for subject in $subjectlist
do
    echo $subject
     for (( k=1; k<=5; k++ ))
     do
     mri_vol2surf --hemi lh --mov /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/RD${k}.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/RD${k}.mgh --surf white --out_type mgh
     mri_vol2surf --hemi rh --mov /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/LD${k}.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/LD${k}.mgh --surf white --out_type mgh

     mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/RD${k}.mgh --tval /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_somato/RD${k}_${subject}.mgh
     mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi rh --sval /Volumes/TOUCHMAP/ma/DigitAtlasv2/$subject/LD${k}.mgh --tval /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_somato/LD${k}_${subject}.mgh

     mri_binarize --i  /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_somato/RD${k}_${subject}.mgh --min 0.1 --o /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_somato/RD${k}_${subject}.mgh 
     mri_binarize --i  /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_somato/LD${k}_${subject}.mgh --min 0.1 --o /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_somato/LD${k}_${subject}.mgh  

    done
done

# FOR ONE GUY'S TW JUST TO SEE
# for subject in $subjectlist
# do
#     echo $subject
#      for (( k=1; k<=5; k++ ))
#      do
#      mri_vol2surf --hemi lh --mov /Volumes/TOUCHMAP/ma/$subject/RD${k}.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out /Volumes/TOUCHMAP/ma/$subject/RD${k}.mgh --surf white --out_type mgh
#      mri_vol2surf --hemi rh --mov /Volumes/TOUCHMAP/ma/$subject/LD${k}.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out /Volumes/TOUCHMAP/ma/$subject/LD${k}.mgh --surf white --out_type mgh

#      mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval /Volumes/TOUCHMAP/ma/$subject/RD${k}.mgh --tval /Volumes/TOUCHMAP/ma/fsaverage_test/RD${k}_${subject}.mgh
#      mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi rh --sval /Volumes/TOUCHMAP/ma/$subject/LD${k}.mgh --tval /Volumes/TOUCHMAP/ma/fsaverage_test/LD${k}_${subject}.mgh

#      # mri_binarize --i  /Volumes/TOUCHMAP/ma/fsaverage_test/RD${k}_${subject}.mgh --min 0.1 --o /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_test/RD${k}_${subject}.mgh 
#      # mri_binarize --i  /Volumes/TOUCHMAP/ma/fsaverage_test/LD${k}_${subject}.mgh --min 0.1 --o /Volumes/TOUCHMAP/ma/DigitAtlasv2/fsaverage_test/LD${k}_${subject}.mgh  

#     done

#     mri_vol2surf --hemi lh --mov /Volumes/TOUCHMAP/ma/$subject/index_RD.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out /Volumes/TOUCHMAP/ma/$subject/index_RD.mgh --surf white --out_type mgh
#     mri_vol2surf --hemi rh --mov /Volumes/TOUCHMAP/ma/$subject/index_LD.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out /Volumes/TOUCHMAP/ma/$subject/index_LD.mgh --surf white --out_type mgh
#     mri_vol2surf --hemi lh --mov /Volumes/TOUCHMAP/ma/$subject/ph_RD_masked.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out /Volumes/TOUCHMAP/ma/$subject/ph_RD_masked.mgh --surf white --out_type mgh
#     mri_vol2surf --hemi rh --mov /Volumes/TOUCHMAP/ma/$subject/ph_LD_masked.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out /Volumes/TOUCHMAP/ma/$subject/ph_LD_masked.mgh --surf white --out_type mgh

#     mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval /Volumes/TOUCHMAP/ma/$subject/index_RD.mgh --tval /Volumes/TOUCHMAP/ma/fsaverage_test/index_RD_${subject}.mgh
#     mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi rh --sval /Volumes/TOUCHMAP/ma/$subject/index_LD.mgh --tval /Volumes/TOUCHMAP/ma/fsaverage_test/index_LD_${subject}.mgh
#     mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval /Volumes/TOUCHMAP/ma/$subject/ph_RD_masked.mgh --tval /Volumes/TOUCHMAP/ma/fsaverage_test/ph_RD_masked_${subject}.mgh
#     mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi rh --sval /Volumes/TOUCHMAP/ma/$subject/ph_LD_masked.mgh --tval /Volumes/TOUCHMAP/ma/fsaverage_test/ph_LD_masked_${subject}.mgh
    

# done

###############################################################################
#      mri_vol2surf \
#              --hemi lh \
#              #--mov /data/projects/DigitAtlas/$subject/RD${k}.nii.gz \
#              --mov ~/data/DigitAtlas/$subject/RD${k}.nii.gz \
#              --regheader ${subject} \
#              --projfrac-avg  0.1 1 0.1 \
#              --surf-fwhm 1 \
#              #--out /data/projects/DigitAtlas/$subject/RD${k}.mgh \
#              --out ~/data/DigitAtlas/$subject/RD${k}.mgh \
#              --surf white \
#              --out_type mgh


#      mri_vol2surf \
#              --hemi rh \
#              #--mov /data/projects/DigitAtlas/$subject/LD${k}.nii.gz \
#              --mov ~/data/DigitAtlas/$subject/LD${k}.nii.gz \
#              --regheader ${subject} \
#              --projfrac-avg  0.1 1 0.1 \
#              --surf-fwhm 1 \
#              #--out /data/projects/DigitAtlas/$subject/LD${k}.mgh \
#              --out ~/data/DigitAtlas/$subject/LD${k}.mgh \
#              --surf white \
#              --out_type mgh


#      mri_surf2surf --srcsubject $subject \
#              --trgsubject fsaverage \
#              --hemi lh \
#              #--sval /data/projects/DigitAtlas/$subject/RD${k}.mgh \
#              #--tval /data/projects/DigitAtlas/fsaverage/RD${k}_${subject}.mgh     
#              --sval ~/data/DigitAtlas/$subject/RD${k}.mgh \
#              --tval ~/data/DigitAtlas/fsaverage/RD${k}_${subject}.mgh     

#      mri_surf2surf --srcsubject $subject \
#              --trgsubject fsaverage \
#              --hemi rh \
#              #--sval /data/projects/DigitAtlas/$subject/LD${k}.mgh \
#              #--tval /data/projects/DigitAtlas/fsaverage/LD${k}_${subject}.mgh
#              --sval ~/data/DigitAtlas/$subject/LD${k}.mgh \
#              --tval ~/data/DigitAtlas/fsaverage/LD${k}_${subject}.mgh


#      #mri_binarize --i  /data/projects/DigitAtlas/fsaverage/RD${k}_${subject}.mgh --min 0.1 --o /data/projects/DigitAtlas/fsaverage/RD${k}_${subject}.mgh 
#      #mri_binarize --i  /data/projects/DigitAtlas/fsaverage/LD${k}_${subject}.mgh --min 0.1 --o /data/projects/DigitAtlas/fsaverage/LD${k}_${subject}.mgh  
#      mri_binarize --i  ~/data/DigitAtlas/fsaverage/RD${k}_${subject}.mgh --min 0.1 --o ~/data/DigitAtlas/fsaverage/RD${k}_${subject}.mgh 
#      mri_binarize --i  ~/data/DigitAtlas/fsaverage/LD${k}_${subject}.mgh --min 0.1 --o ~/data/DigitAtlas/fsaverage/LD${k}_${subject}.mgh  



#      done

# #    Also for all digits 
#      # mri_vol2surf \
#      #          --hemi lh \
#      #          --mov /data/projects/DigitAtlas/$subject/RHand_Digits.nii.gz \
#      #          --regheader $subject \
#      #          --projfrac-avg  0.1 1 0.1 \
#      #          --surf-fwhm 1 \
#      #          --out /data/projects/DigitAtlas/$subject/RDigits.mgh \
#      #          --surf white \
#      #          --out_type mgh

#      #  mri_surf2surf --srcsubject $subject \
#      #          --trgsubject fsaverage \
#      #          --hemi lh \
#      #          --sval /data/projects/DigitAtlas/$subject/RDigits.mgh \
#      #          --tval /data/projects/DigitAtlas/fsaverage/RDigits_${subject}.mgh   

#      # mri_binarize --i  /data/projects/DigitAtlas/fsaverage/RDigits_${subject}.mgh --min 0.1 --o  /data/projects/DigitAtlas/fsaverage/RDigits_${subject}.mgh   

#      # mri_vol2surf \
#      #          --hemi rh \
#      #          --mov /data/projects/DigitAtlas/$subject/LHand_Digits.nii.gz \
#      #          --regheader $subject \
#      #          --projfrac-avg  0.1 1 0.1 \
#      #          --surf-fwhm 1 \
#      #          --out /data/projects/DigitAtlas/$subject/LDigits.mgh \
#      #          --surf white \
#      #          --out_type mgh

#      # mri_surf2surf --srcsubject $subject \
#      #         --trgsubject fsaverage \
#      #         --hemi rh \
#      #         --sval /data/projects/DigitAtlas/$subject/LDigits.mgh \
#      #         --tval /data/projects/DigitAtlas/fsaverage/LDigits_${subject}.mgh 

#      # mri_binarize --i  /data/projects/DigitAtlas/fsaverage/LDigits_${subject}.mgh  --min 0.1 --o /data/projects/DigitAtlas/fsaverage/LDigits_${subject}.mgh    

# done



#done