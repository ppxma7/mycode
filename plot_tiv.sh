#!/bin/bash

# Define the base directory where subject data is stored
BASE_DIR="/Users/spmic/data/IBD_structs_MNIspace_results/surfaces/"
OUTPUT_FILE="/Users/spmic/data/IBD_structs_MNIspace_results/TIV_volumes_IBD.csv"

# List of subjects
#SUBJECTS=(sub01 sub02 sub03 sub04 sub06 sub07 sub08 sub09 sub10)

SUBJECTS=("001_H08" "BL018" "BL016" "BL017" "BL012" "BL013" "BL014" \
  "BL015" "BL010" "BL011" "BL007" "BL008" "BL003" "BL004" "BL005" \
  "BL006" "004_P01" "BL002" "001_P44" "001_P45" "001_P42" "001_P43" \
  "001_P35" "001_P37" "001_P40" "001_P41" "001_P32" "001_P33" "001_P30" \
  "001_P31" "001_P27" "001_P28" "001_P22" "001_P23" "001_P24" "001_P26" \
  "001_P20" "001_P21" "001_P18" "001_P19" "001_P16" "001_P17" "001_P08" \
  "001_P12" "001_P13" "001_P15" "001_P05" "001_P06" "001_P02" "001_P04" \
  "001_H30" "001_P01" "001_H25" "001_H27" "001_H28" "001_H29" "001_H23" \
  "001_H24" "001_H17" "001_H19" "001_H15" "001_H16" "001_H09" "001_H11" \
  "001_H13" "001_H14" "001_H03" "001_H07")


# Write the header row to the CSV file
echo "Subject,GMV (mm3),WMV (mm3),CSF (mm3),TIV (mm3)" > $OUTPUT_FILE

# Iterate through each subject
for SUB in "${SUBJECTS[@]}"; do
    # Define the path to the segmentation directory
    SEG_DIR="$BASE_DIR/$SUB/analysis/anatMRI/T1/processed/seg/tissue/sing_chan"

    # Define the PVE files
    PVE_GM="$SEG_DIR/T1_pve_GM.nii.gz"
    PVE_WM="$SEG_DIR/T1_pve_WM.nii.gz"
    PVE_CSF="$SEG_DIR/T1_pve_CSF.nii.gz"

    # Check if all required files exist
    if [[ -f $PVE_GM && -f $PVE_WM && -f $PVE_CSF ]]; then
        # Calculate volumes using fslstats
        GMV=$(fslstats $PVE_GM -M -V | awk '{print $1 * $2}')
        WMV=$(fslstats $PVE_WM -M -V | awk '{print $1 * $2}')
        CSF=$(fslstats $PVE_CSF -M -V | awk '{print $1 * $2}')

        # Calculate Total Intracranial Volume (TIV)
        TIV=$(echo "$GMV + $WMV + $CSF" | bc)

        # Append the results to the CSV file
        echo "$SUB,$GMV,$WMV,$CSF,$TIV" >> $OUTPUT_FILE
    else
        echo "Missing PVE files for $SUB. Skipping..."
    fi
done

# Notify the user
echo "TIV calculation completed. Results saved in $OUTPUT_FILE."
