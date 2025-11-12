#!/bin/bash

# Set input and output directories
#INPUT_DIR="/Users/spmic/data/NEXPO"  # Change to actual path
#OUTPUT_DIR="/Users/spmic/data/NEXPO/outputs"  # Change as needed

INPUT_DIR="/Volumes/nemosine/SAN/afirm_new"  # Change to actual path
OUTPUT_DIR="/Volumes/nemosine/SAN/afirm_new_outs"  # Change as needed

# Loop through each subfolder inside INPUT_DIR
for folder in "$INPUT_DIR"/*/; do
    folder_name=$(basename "$folder")  # Extract the folder name
    echo "Processing $folder_name..."
    
    # Run dcm2niix and output to a temporary folder
    TEMP_DIR="${OUTPUT_DIR}/${folder_name}_tmp"
    mkdir -p "$TEMP_DIR"
    /Applications/MRIcron.app/Contents/Resources/dcm2niix -o "$TEMP_DIR" -f "%p_%s" "$folder"
    
    # Create modality-specific folders
    mkdir -p "$OUTPUT_DIR/$folder_name/MPRAGE"
    mkdir -p "$OUTPUT_DIR/$folder_name/T1mapping"
    mkdir -p "$OUTPUT_DIR/$folder_name/FLAIR"
    mkdir -p "$OUTPUT_DIR/$folder_name/DTI"
    
    # Move files based on their names
    # for file in "$TEMP_DIR"/*; do
    #     if [[ "$file" == *MPRAGE* ]]; then
    #         mv "$file" "$OUTPUT_DIR/$folder_name/MPRAGE/"
    #     elif [[ "$file" == *wh_1mm* ]]; then
    #         mv "$file" "$OUTPUT_DIR/$folder_name/T1mapping/"
    #     elif [[ "$file" == *FLAIR* ]]; then
    #         mv "$file" "$OUTPUT_DIR/$folder_name/FLAIR/"
    #     fi
    # done

    for file in "$TEMP_DIR"/*; do
        if [[ "$file" == *MPRAGE* ]]; then
            mv "$file" "$OUTPUT_DIR/$folder_name/MPRAGE/"
        elif [[ "$file" == *wh_1mm* || "$file" == *T1mapping* ]]; then
            mv "$file" "$OUTPUT_DIR/$folder_name/T1mapping/"
        elif [[ "$file" == *FLAIR* ]]; then
            mv "$file" "$OUTPUT_DIR/$folder_name/FLAIR/"
        elif [[ "$file" == *DTI* ]]; then
            mv "$file" "$OUTPUT_DIR/$folder_name/DTI/"
        fi
    done

    
    # Remove temporary directory
    rmdir "$TEMP_DIR" 2>/dev/null  # Will remove only if empty
done

echo "Processing complete!"
