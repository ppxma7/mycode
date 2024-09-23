#!/bin/bash

# author : rosa March 2017
# Convert Digit ROIs into freeSurfer surface space and move MPRAGE into MNI space

cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh 

subjectlist="Map04"
MOUNT='/Users/spmic/data/caitlin/'

for subject in $subjectlist
do
    echo "Processing subject: $subject"

    # Create registration matrix using bbregister
    bbregister --s fs04 --mov $MOUNT/$subject/digitatlas_michael/fs04_mprage_pp.nii \
               --init-fsl --t1 --reg $MOUNT/$subject/digitatlas_michael/mni152.reg.dat

    # Move the subject's MPRAGE to MNI space
    mri_vol2vol --mov $MOUNT/$subject/digitatlas_michael/fs04_mprage_pp.nii \
                --targ $FREESURFER_HOME/subjects/fsaverage/mri/brain.mgz \
                --reg $MOUNT/$subject/digitatlas_michael/mni152.reg.dat \
                --o $MOUNT/$subject/digitatlas_michael/fs04_mprage_mni.nii.gz \
                --no-resample

    # Process each RD volume (k=2 to k=5)
    for (( k=2; k<=5; k++ ))
    do
        echo "Processing RD${k} for subject: $subject"

        # Move RD volume into MNI space
        mri_vol2vol --mov $MOUNT/$subject/digitatlas_michael/RD${k}.nii.gz \
                    --targ $FREESURFER_HOME/subjects/fsaverage/mri/brain.mgz \
                    --reg $MOUNT/$subject/digitatlas_michael/mni152.reg.dat \
                    --o $MOUNT/$subject/digitatlas_michael/RD${k}_mni.nii.gz \
                    --no-resample

        # Binarize the output
        mri_binarize --i $MOUNT/$subject/digitatlas_michael/RD${k}_mni.nii.gz \
                     --min 0.1 --o $MOUNT/$subject/digitatlas_michael/RD${k}_${subject}.nii
    done
donex