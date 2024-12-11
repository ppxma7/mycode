#!/bin/bash

# Define the base path
base_path="/Volumes/DRS-7TfMRI/DigitAtlas/TWmaps"

# List of subject folders
subject_folders=(
    00393_LD 00393_RD 03677_LD 03677_RD 04217_LD 04217_RD 06447_BH 08740_LD 08740_RD
    08966_LD 08966_RD 09621_LD 09621_RD 10289_LD 10289_RD 10301_LD 10301_RD
    10320_LD 10320_RD 10329_LD 10329_RD 10654_LD 10654_RD 10875_LD 10875_RD
    11120_LD 11120_RD 11240_LD 11240_RD 11251_LD 11251_RD 11753_LD 11753_RD
    HB1_BH HB2_BH HB3_LD HB3_RD HB4_BH HB5_BH
)

# Iterate over each subject folder
for subject in "${subject_folders[@]}"; do

    echo " running $subject"
    # Define the source and destination paths
    subject_path="$base_path/$subject"

    # Check if the folder is BH (both LD and RD) or specific to LD/RD
    if [[ "$subject" == *_BH ]]; then
        # Handle both LD and RD for BH folders
        for suffix in LD RD; do
            new_folder="${base_path}/${subject}_${suffix}_extra"
            mkdir -p "$new_folder"

            files_to_copy=(
                "co_${suffix}.hdr" "co_${suffix}.img" "ph_${suffix}.hdr" "ph_${suffix}.img"
                "DigitsMask_${suffix}.hdr" "DigitsMask_${suffix}.img"
            )

            for file in "${files_to_copy[@]}"; do
                if [[ -f "$subject_path/$file" ]]; then
                    cp "$subject_path/$file" "$new_folder/"
                else
                    echo "File not found: $subject_path/$file"
                fi
            done
        done
    else
        # Handle specific LD or RD folders
        new_folder="${base_path}/${subject}_extra"
        mkdir -p "$new_folder"

        if [[ "$subject" == *_RD ]]; then
            files_to_copy=(
                "co_RD.hdr" "co_RD.img" "ph_RD.hdr" "ph_RD.img"
                "DigitsMask_RD.hdr" "DigitsMask_RD.img"
            )
        elif [[ "$subject" == *_LD ]]; then
            files_to_copy=(
                "co_LD.hdr" "co_LD.img" "ph_LD.hdr" "ph_LD.img"
                "DigitsMask_LD.hdr" "DigitsMask_LD.img"
            )
        else
            echo "Skipping folder with no LD or RD designation: $subject"
            continue
        fi

        for file in "${files_to_copy[@]}"; do
            if [[ -f "$subject_path/$file" ]]; then
                cp "$subject_path/$file" "$new_folder/"
            else
                echo "File not found: $subject_path/$file"
            fi
        done
    fi

done

echo "File copying completed."
