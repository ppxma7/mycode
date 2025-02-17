#!/bin/bash

# Base mount directory
base_mount="/Volumes/arianthe/PAIN/spmimport_redo_allsubs/"

# List of subjects
subjects=("12778" "15435" "11251" "14359" "11766" "15252" "15874")
subject_folders=("sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07")
# List of folders to process
folders=("thermode_arm_3t" "thermode_hand_3t" "thermode_hand_7t" "thermode_arm_7t" "thermode_arm_post_7t")

# Loop over subjects
for idx in "${!subjects[@]}"; do
    subject="${subjects[$idx]}"
    subject_folder="${subject_folders[$idx]}"
    
    echo "Processing subject: $subject"

    # Define subject-specific paths
    OLD_MPRAGE="${base_mount}${subject_folder}/${subject}_spm.nii"
    NEW_MPRAGE="${base_mount}${subject_folder}/${subject}_mrtools.nii"
    
    # Define subject output paths for the transformation files
    TRANSFORM_MAT="${base_mount}${subject_folder}/structural_to_new.mat"
    
    OUTPUT_MPRAGE="${base_mount}${subject_folder}/registered_mprage.nii.gz"

    # Step 1: Transform spmT images to spm mprage
    for folder in "${folders[@]}"; do
        folder_path="${base_mount}${subject_folder}/${folder}"
        if [ -d "$folder_path" ]; then
            echo "Processing folder: $folder"

            # Loop through spmT images in the folder
            for FILE in "${folder_path}"/spmT_*.nii; do
                if [ -f "$FILE" ]; then
                    echo "Processing: $FILE"
                    
                    # Extract filename without path and extension
                    BASENAME=$(basename "$FILE" .nii)
                    OUTPUT_FILE="$folder_path/${BASENAME}_registered_to_spm.nii"
                    
                    flirt -in "$FILE" -ref "$OLD_MPRAGE" -out "$OUTPUT_FILE" \
                          -bins 256 -cost mutualinfo -searchrx -90 90 -searchry \
                          -90 90 -searchrz -90 90 -dof 6  -interp trilinear
                    echo "Transformed: $FILE -> $OUTPUT_FILE"
                fi
            done
        else
            echo "Folder $folder does not exist for subject $subject, skipping..."
        fi
    done

    # Step 2: Compute FLIRT transformation from old structural to new structural
    if [ ! -f "$OUTPUT_MPRAGE" ]; then
        echo "File does not exist, proceeding with FLIRT transformation..."
        flirt -in "$OLD_MPRAGE" -ref "$NEW_MPRAGE" -omat "$TRANSFORM_MAT" -out "$OUTPUT_MPRAGE" \
              -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 \
              -dof 6 -interp trilinear
    else  
        echo "File $OUTPUT_MPRAGE exists, skipping FLIRT transformation..."
    fi

    # Step 3: Apply transformation to all spmT images
    for folder in "${folders[@]}"; do
        folder_path="${base_mount}${subject_folder}/${folder}"

        if [ -d "$folder_path" ]; then
            for FILE in "$folder_path"/spmT_*.nii; do
                if [ -f "$FILE" ]; then
                    echo "Processing: $FILE"
                    
                    # Extract filename without path and extension
                    BASENAME=$(basename "$FILE" .nii)
                    OUTPUT_FILE="$folder_path/${BASENAME}_MR.nii"
                    
                    flirt -in "$FILE" -ref "$NEW_MPRAGE" -applyxfm -init "$TRANSFORM_MAT" -out "$OUTPUT_FILE" \
                          -interp trilinear
                    echo "Transformed: $FILE -> $OUTPUT_FILE"
                fi
            done
        else
            echo "Folder $folder does not exist for subject $subject, skipping..."
        fi
    done
done

echo "All transformations completed. Results are in $base_mount"
