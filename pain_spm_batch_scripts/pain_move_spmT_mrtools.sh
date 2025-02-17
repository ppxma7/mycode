#!/bin/bash

# This is a script for moving spmT contrast files that are generated in SPM (native space) to the mrtools mprage, so that it can be imported correctly in mrTools space. 
mount="/Volumes/arianthe/PAIN/tgi_sub_01_13676_221124/processed_data_mrtools/spmimport_redo/"

# Define input files
OLD_MPRAGE="${mount}13676_mprage_pp_masked_SPM.nii"
NEW_MPRAGE="${mount}13676_mrtools.nii"

# Define transformation file output
TRANSFORM_MAT="${mount}structural_to_new.mat"

# Define output directory
OUTPUT_DIR="${mount}transformed_spmT"
OUTPUT_mprage="${mount}registered_mprage.nii"
mkdir -p "$OUTPUT_DIR"

# Step 1: Transform spm images to spm mprage
for FILE in "${mount}"spmT_*.nii; do
    if [ -f "$FILE" ]; then
        echo "Processing: $FILE"
        
        # Extract filename without path and extension
        BASENAME=$(basename "$FILE" .nii)
        OUTPUT_FILE="$OUTPUT_DIR/${BASENAME}_registered_to_spm.nii"
        
        flirt -in "$FILE" -ref "$OLD_MPRAGE" -out "$OUTPUT_FILE" \
              -bins 256 -cost mutualinfo -searchrx -90 90 -searchry \
              -90 90 -searchrz -90 90 -dof 6  -interp trilinear
        echo "Transformed: $FILE -> $OUTPUT_FILE"
    fi
done


# Step 2: Compute FLIRT transformation from old structural to new structural

if [ ! -f "$OUTPUT_mprage" ]; then
    echo "File does not exist, proceeding..."
    flirt -in "$OLD_MPRAGE" -ref "$NEW_MPRAGE" -omat "$TRANSFORM_MAT" -out "$OUTPUT_mprage" \
          -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 \
          -dof 6 -interp trilinear
else  
    echo "File exists, skipping..."
fi

# Step 3: Apply transformation to all spmT images
for FILE in "$OUTPUT_DIR/"spmT_*.nii.gz; do
        echo "Processing: $FILE"
        
        # Extract filename without path and extension
        BASENAME=$(basename "$FILE" .nii.gz)
        OUTPUT_FILE="$OUTPUT_DIR/${BASENAME}_MR.nii"
        
        flirt -in "$FILE" -ref "$NEW_MPRAGE" -applyxfm -init "$TRANSFORM_MAT" -out "$OUTPUT_FILE" \
              -interp trilinear
        echo "Transformed: $FILE -> $OUTPUT_FILE"
done

echo "All transformations completed. Results are in $OUTPUT_DIR"
