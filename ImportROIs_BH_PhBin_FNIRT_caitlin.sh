#!/bin/bash

cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh

subjectlist="Map04"
MOUNT='/Users/spmic/data/caitlin/'

for subject in $subjectlist
do
    echo "Processing subject: $subject"

    # Linear registration with FLIRT
    flirt -in $MOUNT/$subject/fmri_data/fs04_mprage_pp.nii \
          -ref $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz \
          -omat $MOUNT/$subject/fmri_data/fs04_mprage_flirt.mat \
          -out $MOUNT/$subject/fmri_data/fs04_mprage_flirt.nii.gz

    # Nonlinear registration with FNIRT
    fnirt --in=$MOUNT/$subject/fmri_data/fs04_mprage_pp.nii \
          --aff=$MOUNT/$subject/fmri_data/fs04_mprage_flirt.mat \
          --ref=$FSLDIR/data/standard/MNI152_T1_1mm.nii.gz \
          --cout=$MOUNT/$subject/fmri_data/fs04_mprage_fnirt_warp.nii.gz \
          --iout=$MOUNT/$subject/fmri_data/fs04_mprage_fnirt.nii.gz

    # Apply nonlinear warp to MPRAGE
    applywarp --in=$MOUNT/$subject/fmri_data/fs04_mprage_pp.nii \
              --ref=$FSLDIR/data/standard/MNI152_T1_1mm.nii.gz \
              --warp=$MOUNT/$subject/fmri_data/fs04_mprage_fnirt_warp.nii.gz \
              --out=$MOUNT/$subject/fmri_data/fs04_mprage_mni_fnirt.nii.gz

    # Process each RD volume (k=2 to k=5)
    for (( k=2; k<=5; k++ ))
    do
        echo "Processing RD${k} for subject: $subject"

        # Apply nonlinear warp to RD volumes
        applywarp --in=$MOUNT/$subject/fmri_data/RD${k}.nii.gz \
                  --ref=$FSLDIR/data/standard/MNI152_T1_1mm.nii.gz \
                  --warp=$MOUNT/$subject/fmri_data/fs04_mprage_fnirt_warp.nii.gz \
                  --out=$MOUNT/$subject/fmri_data/RD${k}_mni_fnirt.nii.gz

        # Binarize the output
        mri_binarize --i $MOUNT/$subject/fmri_data/RD${k}_mni_fnirt.nii.gz \
                     --min 0.1 --o $MOUNT/$subject/fmri_data/RD${k}_${subject}_fnirt.nii
    done
done