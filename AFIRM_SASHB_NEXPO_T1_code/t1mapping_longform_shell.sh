#!/bin/bash

# Directory
DATA_DIR="/Volumes/nemosine/NEXPO/inputs"  # Change to your actual data path
OUTPUT_DIR="/Volumes/nemosine/NEXPO/t1mapping_out/"


SUBJECT=("16788_002" "16986_002")

# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    python3 /Users/ppzma/Documents/MATLAB/mycode/t1mapping_struct_preproc_on_hpc/t1_mapping_longform_hpc.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
done

echo "Processing complete!"