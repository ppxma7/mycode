#!/bin/bash

# Define source and destination paths
SRC_BASE="ppzma@hpclogin01.ada.nottingham.ac.uk:/imgshare/7tfmri/michael/catalyst_subs/surfaces"
DST_BASE="/Users/spmic/data/CATALYST/GBPERM_subs"

# List of subject IDs
SUBJECTS=("sub01" "sub02" "sub03" "sub04" "sub06" "sub07" "sub08" "sub09" "sub10")

# Loop over subjects
for SUB in "${SUBJECTS[@]}"; do
  SRC_PATH="$SRC_BASE/$SUB/analysis/anatMRI/T1/processed/seg/"
  DST_PATH="$DST_BASE/$SUB/"
  
  echo "Copying data for $SUB..."
  
  # Check if the destination directory exists
#   if [ ! -d "$DST_PATH" ]; then
#     mkdir -p "$DST_PATH"  # Create destination directory if it doesn't exist
#   fi
  
  # Perform the SCP copy, skipping existing files
  scp -r "$SRC_PATH" "$DST_PATH"
  
  # Check if the SCP command was successful
  if [ $? -eq 0 ]; then
    echo "Data successfully copied for $SUB."
  else
    echo "Error copying data for $SUB."
  fi
done

echo "All done!"
