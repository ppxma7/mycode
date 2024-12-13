#!/bin/bash

# Define the folder path
folder_path="/Volumes/hermes/canapi_051224/aroma_mni_space/"

# Define the files to process
files=(
    "rwrparrec_WIP50prc_20241205082447_8_nordic_clv.nii"
    "rwrparrec_WIP50prc_20241205082447_4_nordic_clv.nii"
    "rwrparrec_WIP30prc_20241205082447_9_nordic_clv.nii"
    "rwrparrec_WIP30prc_20241205082447_5_nordic_clv.nii"
    "rwrparrec_WIP1bar_20241205082447_6_nordic_clv.nii"
    "rwrparrec_WIP1bar_20241205082447_10_nordic_clv.nii"
)

# Loop through each file and run the bet command
for file in "${files[@]}"; do
    input="$folder_path/$file"
    output_brain="${input%.nii}_brain"
    echo "Processing: $input"
    bet "$input" "$output_brain" -R -m -F
    echo "Output: $output_brain"
done

echo "All files processed."
