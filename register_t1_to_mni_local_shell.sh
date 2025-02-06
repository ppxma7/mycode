#!/bin/bash

# Directory
DATA_DIR="/Users/spmic/data/AFIRM/inputs"  # Change to your actual data path
OUTPUT_DIR="/Users/spmic/data/AFIRM/"

# List of subjects (update as necessary)
# SUBJECT=("16469-002A" "16500-002B" "16501-002b" \
#           "16521-001b3" "16523_002b")
SUBJECT=("16469-002A")

# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    #python3 /gpfs01/home/ppzma/code/register_t1_to_mni_standalone.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
    python3 /Users/spmic/Documents/MATLAB/mycode/register_t1_to_mni_standalone.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
done

echo "Processing complete!"