#!/bin/bash

# Directory
DATA_DIR="/Volumes/nemosine/NEXPO/inputs"  # Change to your actual data path
OUTPUT_DIR="/Volumes/nemosine/NEXPO/t1mapping_out/"

# List of subjects (update as necessary)
# SUBJECT=("16469-002A" "16500-002B" "16501-002b" \
#           "16521-001b3" "16523_002b")
#SUBJECT=("16521-001b3")


# SUBJECT=("17105_002" "12411_004" "16464_002" \
#          "16439_002" "16438_002" "16513_002" \
#          "17207_003" "17105_002")

SUBJECT=("17105_002")


# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    #python3 /gpfs01/home/ppzma/code/register_t1_to_mni_standalone.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
    python3 /Users/spmic/Documents/MATLAB/mycode/register_t1_to_mni_standalone_fixing.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
    #python3 /Users/spmic/Documents/MATLAB/mycode/apply_extract_atlas_t1.py -o "$OUTPUT_DIR" -s "$subject"

done

echo "Processing complete!"