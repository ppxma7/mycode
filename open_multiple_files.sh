#!/bin/bash

# Set the main directory where subject folders are located
MAIN_DIR="/Volumes/nemosine/NEXPO/t1mapping_out/"

# List of subject IDs
# SUBJECTS=("16044_002" "16043_002" "15721_009" "12967_004" "12869_013" "12428_005" "12422_004" \
#     "10760_130" "16437_002" "16430_002" "16322_002" "16302_002" "16282_002" "16281_002" "16231_003" \
#     "16174_002" "16154_002" "16871_002" "16793_006" "16725_002" "16664_002" "16662_002" "16615_002" \
#     "16613_002" "17341_002" "17305_002" "17293_002" "17243_002" "17041_002" "17038_002" "17706_002" \
#     "17698_002" "17617_002" "17532_002" "17492_002" "17491_002" "17456_002")

#SUBJECTS=("17105_002" "17105_002" "12411_004" "16464_002" "16439_002" "16438_002" "16513_002" "17207_003" "17105_002")

SUBJECTS=("17698_002" "17617_002" "17532_002" "17492_002" "17491_002" "17456_002")



# Store valid file paths
FILES=()

# Collect valid file paths
for SUBJ in "${SUBJECTS[@]}"; do
    FILE_PATH="$MAIN_DIR/$SUBJ/${SUBJ}_T1_MNI_1mm.nii.gz"
    if [[ -f "$FILE_PATH" ]]; then
        FILES+=("$FILE_PATH")
        echo "found files"
    else
        echo "WARNING: File not found for subject $SUBJ: $FILE_PATH"
    fi
done

# Open all files in a single FSLeyes instance
if [[ ${#FILES[@]} -gt 0 ]]; then
    echo "opening lots of stuff"
    fsleyes "${FILES[@]}" &
else
    echo "No valid files found. Exiting."
fi
