#!/bin/bash

# author : rosa March 2017
#convert Digit ROIs into freeSurfer surface space
#subjectlist="00393 03677 10301 11120 11753"
cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh 

#subjectlist="11240"
#subjectlist="00393 03677 04217 08740 08966 09621 10289 10301 10320 10329 10654 10875 11240 11120 11251 11753 HB1 HB2 HB3 HB4 HB5"
subjectlist="00393"

for subject in $subjectlist
do
    echo $subject
     for (( k=1; k<=5; k++ ))
     do
        mri_vol2vol --mov ~/data/DigitAtlas/atlas_subjects_vol2vol/$subject/LD${k}.nii.gz --mni152reg --o ~/data/DigitAtlas/atlas_subjects_vol2vol/$subject/LD${k}_mni.nii.gz
        mri_vol2vol --mov ~/data/DigitAtlas/atlas_subjects_vol2vol/$subject/RD${k}.nii.gz --mni152reg --o ~/data/DigitAtlas/atlas_subjects_vol2vol/$subject/RD${k}_mni.nii.gz 
        mri_binarize --i  ~/data/DigitAtlas/atlas_subjects_vol2vol/$subject/RD${k}_mni.nii.gz --min 0.1 --o ~/data/DigitAtlas/atlas_subjects_vol2vol/RD${k}_${subject}.nii
        mri_binarize --i  ~/data/DigitAtlas/atlas_subjects_vol2vol/$subject/LD${k}_mni.nii.gz --min 0.1 --o ~/data/DigitAtlas/atlas_subjects_vol2vol/LD${k}_${subject}.nii


    done
done

#bbregister --s 00393 --bold --init-fsl --mov LD1.nii.gz --reg register.dof6.dat
#mni152reg --s 00393
#mri_matrix_multiply -im register.dof6.dat -iim /Users/ppxma7/data/subjects/00393/mri/transforms/reg.mni152.2mm.dat -om reg.mni152.dat
#mri_vol2vol --targ /usr/local/fsl/data/standard/MNI152_T1_2mm.nii.gz --mov LD1.nii.gz --o test.nii --reg reg.mni152.dat
