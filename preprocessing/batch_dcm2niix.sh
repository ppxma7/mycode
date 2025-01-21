#!/bin/bash

# Define the base directory where the subject folders are located
BASE_DIR="/Volumes/hermes/zespri_tasks/trust"

# Loop through numbers 1 to 14
for num in {1..14}; do
  # Loop through letters A to D
  for letter in {A..D}; do
    # Construct the folder path
    FOLDER_PATH="${BASE_DIR}/${num}${letter}"
    
    # Check if the folder exists
    if [ -d "$FOLDER_PATH" ]; then
      echo "Processing folder: $FOLDER_PATH"
      
      # Run dcm2niix on the folder
      dcm2niix -z y -o "$FOLDER_PATH" "$FOLDER_PATH"
      #echo "testing $FOLDER_PATH"
    else
      echo "Folder does not exist: $FOLDER_PATH"
    fi
  done
done