#!/bin/bash

# Loop through all .nii files in the current directory
for file in *.nii; do
  # Extract the base name of the file (without extension)
  base_name="${file%.nii}"
  
  # Convert the file to .nii.gz using fslchfiletype
  fslchfiletype NIFTI_GZ "$file" "${base_name}.nii.gz"
  
  echo "Converted $file to ${base_name}.nii.gz"
done

echo "All files converted to .nii.gz!"
