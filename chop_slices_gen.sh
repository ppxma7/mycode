#!/bin/bash

# Iterate over all NIfTI files in the current directory
for full_file_path in *.nii; do

    # Extract the base name without the extension
    base_name=$(basename "$full_file_path" .nii)


    # Check if the filename contains "_ph"
    if [[ "$base_name" == *_ph ]]; then
        # Insert _clipped before _ph.nii.gz
        output_file="${base_name%_ph}_clipped_ph.nii.gz"
    else
        # Default case: append _clipped to the filename
        output_file="${base_name}_clipped.nii"
    fi
        
    # Define the output file name
    #output_file="${base_name}_clipped.nii.gz"
    
    # Get the number of slices (dim3) using fslhd
    dim3=$(fslhd "$full_file_path" | grep ^dim3 | awk '{print $2}')
    
    # Determine the appropriate slice range based on the number of slices
    if [ "$dim3" -eq 36 ]; then
        # For 36 slices, remove top 6 and bottom 6
        fslroi "$full_file_path" "$output_file" 0 -1 0 -1 6 24
    elif [ "$dim3" -eq 30 ]; then
        # For 30 slices, remove top 3 and bottom 3
        fslroi "$full_file_path" "$output_file" 0 -1 0 -1 3 24
    else
        echo "Unexpected slice count ($dim3) for $full_file_path. Skipping."
        cp "$full_file_path" "$output_file"
        fslchfiletype NIFTI_GZ "$output_file" "$output_file"
        continue
    fi
    
    # Check if the command was successful
    if [ $? -eq 0 ]; then
        echo "Processed $full_file_path -> $output_file"
    else
        echo "Error processing $full_file_path"
    fi
done
