#!/bin/bash

# Define the base directories
source_base="/Volumes/DRS-7TfMRI/michael/ZESPRI/data/zespri_"
destination_base="/Volumes/DRS-7TfMRI/michael/ZESPRI/zespri_ASL"

# Create the destination base directory if it doesn't exist
mkdir -p "$destination_base"

# Loop through numbers 1 to 14
for num in {1..14}; do
  # Loop through letters A to D
  for letter in A B C D; do
    # Construct source and destination paths
    source_dir="${source_base}${num}${letter}/parrec/"
    destination_dir="${destination_base}/${num}${letter}/"
    
    # Dry run: Print the actions instead of copying
    # echo "Would create directory: $destination_dir"
    # for file in "${source_dir}"pCASL*.nii; do
    #   if [ -e "$file" ]; then
    #     echo "Would copy: $file to $destination_dir"
    #   fi
    # done

    #Actual run: Uncomment the following lines to perform the actual copy
    #Create the destination directory if it doesn't exist
    mkdir -p "$destination_dir"
    
    #Copy the files matching the pattern
    echo "Copying files to $destination_dir"
    cp "${source_dir}"*pCASL*.nii "$destination_dir"
  done
done

#echo "Dry run completed. Uncomment the actual run lines to copy files."
echo "Complete"
