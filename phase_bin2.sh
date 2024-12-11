#!/bin/bash
source $FREESURFER_HOME/SetUpFreeSurfer.sh 
export SUBJECTS_DIR=/Volumes/DRS-7TfMRI/DigitAtlas/FreeSurferDigitAtlas/

# Define paths and subject folders
MOUNT='/Volumes/DRS-7TfMRI/DigitAtlas/TWmaps_masks/'
subject_folders=(00393_LD_extra 00393_RD_extra 03677_LD_extra 03677_RD_extra 04217_LD_extra 04217_RD_extra 06447_BH_LD_extra 06447_BH_RD_extra 08740_LD_extra 08740_RD_extra 08966_LD_extra 08966_RD_extra 09621_LD_extra 09621_RD_extra 10289_LD_extra 10289_RD_extra 10301_LD_extra 10301_RD_extra 10320_LD_extra 10320_RD_extra 10329_LD_extra 10329_RD_extra 10654_LD_extra 10654_RD_extra 10875_LD_extra 10875_RD_extra 11120_LD_extra 11120_RD_extra 11240_LD_extra 11240_RD_extra 11251_LD_extra 11251_RD_extra 11753_LD_extra 11753_RD_extra HB1_BH_LD_extra HB1_BH_RD_extra HB2_BH_LD_extra HB2_BH_RD_extra HB3_LD_extra HB3_RD_extra HB4_BH_LD_extra HB4_BH_RD_extra HB5_BH_LD_extra HB5_BH_RD_extra)




# Iterate over each subject folder
for subject in "${subject_folders[@]}"; do
    # Determine the suffix based on subject type
    if [[ "$subject" == *_LD_* ]]; then
        suffix="LD"
    elif [[ "$subject" == *_RD_* ]]; then
        suffix="RD"
    else
        echo "Skipping unsupported subject: $subject"
        continue
    fi

    # Reset timer for this subject
    SECONDSsub=0

    echo "Processing subject: $subject, suffix: $suffix"

    # Mask "co.nii" and "ph.nii" with "mask.nii"
    fslmaths ${MOUNT}/${subject}/co_${suffix}.hdr -mas ${MOUNT}/${subject}/DigitsMask_${suffix}.hdr ${MOUNT}/${subject}/co_masked.nii
    fslmaths ${MOUNT}/${subject}/ph_${suffix}.hdr -mas ${MOUNT}/${subject}/DigitsMask_${suffix}.hdr ${MOUNT}/${subject}/ph_masked.nii
    fslmaths ${MOUNT}/${subject}/co_masked.nii -nan ${MOUNT}/${subject}/co_masked_no_nan.nii
    fslmaths ${MOUNT}/${subject}/ph_masked.nii -nan ${MOUNT}/${subject}/ph_masked_no_nan.nii

    # Define five equal phase bins and ranges
    phase_bins=("bin1" "bin2" "bin3" "bin4" "bin5")
    phases=(0 1.256 2.512 3.768 5.024 6.28)

    for ((i=0; i<5; i++)); do
        lower=${phases[$i]}
        upper=${phases[$i+1]}
        phase_bin=${phase_bins[$i]}

        # Create phase-specific mask (preserving phase values)
        fslmaths ${MOUNT}/${subject}/ph_masked_no_nan.nii -thr $lower -uthr $upper ${MOUNT}/${subject}/ph_binned_${phase_bin}.nii

        # Apply the phase-specific mask to coherence data
        fslmaths ${MOUNT}/${subject}/co_masked_no_nan.nii -mas ${MOUNT}/${subject}/ph_binned_${phase_bin}.nii ${MOUNT}/${subject}/co_masked_${phase_bin}.nii
    done

    # Threshold each phase bin image based on coherence level of 0.3
    for phase_bin in "${phase_bins[@]}"; do
        fslmaths ${MOUNT}/${subject}/co_masked_no_nan.nii -thr 0.3 -bin -mul ${MOUNT}/${subject}/ph_binned_${phase_bin}.nii ${MOUNT}/${subject}/ph_binned_${phase_bin}_co_thresh.nii
        fslmaths ${MOUNT}/${subject}/co_masked_no_nan.nii -thr 0.3 -bin -mul ${MOUNT}/${subject}/co_masked_${phase_bin}.nii ${MOUNT}/${subject}/co_masked_${phase_bin}_co_thresh.nii
    done

    echo "Finished processing subject: $subject, suffix: $suffix in $SECONDSsub seconds."
done

# Completion message
echo "File processing completed."
