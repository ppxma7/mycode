#!/bin/bash

# Define the base directory where subject data is stored
BASE_DIR="/Users/spmic/data/CATALYST/GBPERM_subs/"
OUTPUT_FILE="/Users/spmic/data/CATALYST/GBPERM_subs/TIV_volumes.csv"

# List of subjects
SUBJECTS=(sub01 sub02 sub03 sub04 sub06 sub07 sub08 sub09 sub10)

# Write the header row to the CSV file
echo "Subject,GMV (mm3),WMV (mm3),CSF (mm3),TIV (mm3)" > $OUTPUT_FILE

# Iterate through each subject
for SUB in "${SUBJECTS[@]}"; do
    # Define the path to the segmentation directory
    SEG_DIR="$BASE_DIR/$SUB/seg/tissue/sing_chan"

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
