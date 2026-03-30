#!/bin/bash

# Define base path
BASE_PATH="/Volumes/kratos/CANAPI/"

# List of subjects
SUBJECTS=(
  "canapi_sub02_180325"
  "canapi_sub03_180325"
  "canapi_sub04_280425"
  "canapi_sub05_240625"
  "canapi_sub06_240625"
  "canapi_sub07_010725"
  "canapi_sub08_010725"
  "canapi_sub09_160725"
  "canapi_sub10_160725"
  "canapi_sub11"
  "canapi_sub12"
  "canapi_sub13"
  "canapi_sub14"
  "canapi_sub15"
  "canapi_sub16"
)

# List of subfolders
# FOLDERS=(
#   "first_level"
#   "first_level_accel"
#   "first_level_wemg"
# )

FOLDERS=(
  "first_level_waccel"
)

# Loop through each subject and subfolder
for subj in "${SUBJECTS[@]}"; do
  for folder in "${FOLDERS[@]}"; do
    # Construct path
    SUBJ_PATH="$BASE_PATH/$subj/spm_analysis/$folder"
    INPUT_FILE="$SUBJ_PATH/con_0002.nii"
    OUTPUT_FILE="$SUBJ_PATH/con_0002_flipped.nii.gz"

    # Check file exists
    if [[ -f "$INPUT_FILE" ]]; then
      echo "Flipping: $INPUT_FILE"
      fslswapdim "$INPUT_FILE" -x y z "$OUTPUT_FILE"
      fslchfiletype NIFTI "$OUTPUT_FILE"
    else
      echo "Missing file: $INPUT_FILE"
    fi
  done
done
