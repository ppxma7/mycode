#!/bin/bash

# Directory
DATA_DIR="/Users/spmic/data/NEXPO/inputs"  # Change to your actual data path
OUTPUT_DIR="/Users/spmic/data/NEXPO/t1mapping_out/"

# List of subjects (update as necessary)
# SUBJECT=("16469-002A" "16500-002B" "16501-002b" \
#           "16521-001b3" "16523_002b")
#SUBJECT=("16521-001b3")


# SUBJECT=("17105_002" "12411_004" "16464_002" \
#          "16439_002" "16438_002" "16513_002" \
#          "17207_003")

# SUBJECT=("16044_002" "16043_002" "15721_009" "12967_004" "12869_013" "12428_005" "12422_004" \
#     "10760_130" "16437_002" "16430_002" "16322_002" "16302_002" "16282_002" "16281_002" "16231_003" \
#     "16174_002" "16154_002" "16871_002" "16793_006" "16725_002" "16664_002" "16662_002" "16615_002" \
#     "16613_002" "17341_002" "17305_002" "17293_002" "17243_002" "17041_002" "17038_002" "17706_002" \
#     "17698_002" "17617_002" "17532_002" "17492_002" "17491_002" "17456_002")

# completed ("10760_130" "16044_002" "16043_002" "15721_009" "12967_004" )
#16788_002

SUBJECT=("09849" "10469" "12294" "13676" "14342_003" "16279" "16517" "16544" "16569_002" "16911" \
    "17076_002" "17080_002" "17930_002" "18031_002" "18038_002" "18076_002" "18094_002")

# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    #python3 /gpfs01/home/ppzma/code/register_t1_to_mni_standalone.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
    python3 /Users/spmic/Documents/MATLAB/mycode/t1mapping_struct_preproc_on_hpc/register_t1_to_mni_standalone_fixing.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
    #python3 /Users/spmic/Documents/MATLAB/mycode/apply_extract_atlas_t1.py -o "$OUTPUT_DIR" -s "$subject"

done

echo "Processing complete!"