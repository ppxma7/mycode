#!/bin/bash
source $FREESURFER_HOME/SetUpFreeSurfer.sh 
export SUBJECTS_DIR=/Volumes/DRS-Touchmap/ma_ares_backup/subs/

# Define paths and file names
MOUNT='/Volumes/styx/prf_fsaverage/'
anatMOUNT='/Volumes/DRS-Touchmap/ma_ares_backup/subs/'
# subjects=("00393_LD"
#     "00393_LD_touchmap"
#     "00393_RD"
#     "00393_RD_touchmap"
#     "03677_LD"
#     "03677_RD"
#     "03942_LD"
#     "03942_RD"
#     "04217_LD"
#     "08740_RD"
#     "08966_RD"
#     "09621_RD"
#     "10301_LD"
#     "10301_RD"
#     "10875_RD"
#     "11120_LD"
#     "11120_RD"
#     "11240_LD"
#     "11240_RD"
#     "11251_LD"
#     "11251_RD"
#     "13172_LD"
#     "13172_RD"
#     "13493_Btx_LD"
#     "13493_Btx_RD"
#     "13493_NoBtx_LD"
#     "13493_NoBtx_RD"
#     "13658_Btx_LD"
#     "13658_Btx_RD"
#     "13658_NoBtx_LD"
#     "13658_NoBtx_RD"
#     "13695_Btx_LD"
#     "13695_Btx_RD"
#     "13695_NoBtx_LD"
#     "13695_NoBtx_RD"
#     "14001_Btx_LD"
#     "14001_Btx_RD"
#     "14001_NoBtx_LD"
#     "14001_NoBtx_RD"
#     "HB2_LD"
#     "HB2_RD"
#     "HB3_LD"
#     "HB3_RD"
#     "HB4_LD"
#     "HB4_RD"
#     "HB5_LD"
#     "HB5_RD"
#     )  # Adjust as needed

subjects=("prf1"
    "prf2"
    "prf3"
    "prf4"
    "prf6"
    "prf7"
    "prf8"
    "prf9"
    "prf10"
    "prf11" 
    "prf12")


# Start overall timer
overall_start=$SECONDS

# Start timer for this subject
SECONDS=0


for subject in "${subjects[@]}"
do

    # Start timer for this subject
    SECONDSsub=0

    echo "Processing subject: $subject"
    # Mask "co.nii" and "ph.nii" with "mask.nii"
    fslmaths ${MOUNT}/${subject}/co.nii -mas ${MOUNT}/${subject}/mask.nii ${MOUNT}/${subject}/co_masked.nii
    fslmaths ${MOUNT}/${subject}/ph.nii -mas ${MOUNT}/${subject}/mask.nii ${MOUNT}/${subject}/ph_masked.nii
    fslmaths ${MOUNT}/${subject}/co_masked.nii -nan ${MOUNT}/${subject}/co_masked_no_nan.nii
    fslmaths ${MOUNT}/${subject}/ph_masked.nii -nan ${MOUNT}/${subject}/ph_masked_no_nan.nii

    # Define 4 phase bin ranges and names
    phase_bins=("0_1_57" "1_57_3_14" "3_14_4_71" "4_71_6_28")
    phases=(0 1.57 3.14 4.71 6.28)

    # Define five equal phase bins and ranges
    #phase_bins=("0_1_256" "1_256_2_512" "2_512_3_768" "3_768_5_024" "5_024_6_28")
    #phases=(0 1.256 2.512 3.768 5.024 6.28)


    for ((i=0; i<4; i++))
    do
        lower=${phases[$i]}
        upper=${phases[$i+1]}
        phase_bin=${phase_bins[$i]}

        # Create phase-specific mask (preserving phase values)
        fslmaths ${MOUNT}/${subject}/ph_masked_no_nan.nii -thr $lower -uthr $upper ${MOUNT}/${subject}/ph_binned_${phase_bin}.nii

        # Apply the phase-specific mask to coherence data (preserving coherence values within the phase bin)

        fslmaths ${MOUNT}/${subject}/co_masked_no_nan.nii -mas ${MOUNT}/${subject}/ph_binned_${phase_bin}.nii ${MOUNT}/${subject}/co_masked_${phase_bin}.nii
    done

    # Threshold each phase bin image based on coherence level of 0.3

    for phase_bin in "${phase_bins[@]}"
    do
        # Apply coherence threshold to each phase-binned image and co-binned images
        fslmaths ${MOUNT}/${subject}/co_masked_no_nan.nii -thr 0.3 -bin -mul ${MOUNT}/${subject}/ph_binned_${phase_bin}.nii ${MOUNT}/${subject}/ph_binned_${phase_bin}_co_thresh.nii
        fslmaths ${MOUNT}/${subject}/co_masked_no_nan.nii -thr 0.3 -bin -mul ${MOUNT}/${subject}/co_masked_${phase_bin}.nii ${MOUNT}/${subject}/co_masked_${phase_bin}_co_thresh.nii
    done

    echo "Finished processing subject: $subject"
    # Display elapsed time for this subject
    echo "Finished processing subject: $subject in $SECONDSsub seconds."
done

# Display total time for the entire loop
overall_time=$(( SECONDS - overall_start ))
echo "Total processing time for all subjects: $overall_time seconds."



