#!/bin/bash

MOUNT="/Volumes/nemosine/zespri_rs_smoothed_denoised_A/"
cd $MOUNT
# Loop through the subject numbers 1 to 14
for ii in {1..14}
do

  # Get the start time
  start_time=$(date +%s)

  # Construct the input filename
  input_filename="bdswurs_mrg_${ii}A.nii"
  
  # Construct the output filenames for the two halves
  output_filename_1="bdswurs_mrg_${ii}A_part1.nii"
  output_filename_2="bdswurs_mrg_${ii}A_part2.nii"

  #echo output_filename_1
  #echo output_filename_2
  
  # Use fslroi to extract the first 400 timepoints (indices 0 to 399)
  fslroi $input_filename $output_filename_1 0 400
  
  # Use fslroi to extract the next 400 timepoints (indices 400 to 799)
  fslroi $input_filename $output_filename_2 400 400

  # Get the end time
  end_time=$(date +%s)
  
  # Calculate the elapsed time
  elapsed_time=$((end_time - start_time))
  
  # Optionally, print a message indicating completion for the current file
  echo "Processed $input_filename into $output_filename_1 and $output_filename_2 in $elapsed_time seconds"
done