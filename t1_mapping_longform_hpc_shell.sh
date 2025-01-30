#!/bin/bash

# Directory
DATA_DIR="/Users/spmic/data/AFIRM/inputs"  # Change to your actual data path
OUTPUT_DIR="/Users/spmic/data/AFIRM/t1mapping_out"

# List of subjects (update as necessary)
# SUBJECT=("16469-002A" "16500-002B" "16501-002b" \
#           "16521-001b3" "16523_002b")

SUBJECT=("16469-002A")

# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    python3 t1_mapping_longform_hpc.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
done

echo "Processing complete!"