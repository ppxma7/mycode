#!/bin/bash

# Set the root output directory where MPRAGE folders are located
OUTPUT_DIR="/Volumes/nemosine/SAN/AFIRM/afirm_new_ins/"

# Find all MPRAGE folders and process files inside
find "$OUTPUT_DIR" -type d -name "MPRAGE" | while read mprage_folder; do
    echo "Processing MPRAGE folder: $mprage_folder"

    # Loop through all files inside the MPRAGE folder
    for file in "$mprage_folder"/*; do
        # Extract file name and extension
        filename=$(basename -- "$file")


        if [[ "$filename" == *.nii.gz ]]; then
            extension="nii.gz"
            name_without_ext="${filename%.nii.gz}"
        else
            extension="${filename##*.}"
            name_without_ext="${filename%.*}"
        fi

        #extension="${filename##*.}"
        #name_without_ext="${filename%.*}"

        # Replace dots with 'p' in the filename (excluding the extension)
        new_name="${name_without_ext//./p}.${extension}"

        # Rename only if the new name is different
        if [[ "$filename" != "$new_name" ]]; then
            mv "$file" "$mprage_folder/$new_name"
            echo "Renamed: $filename -> $new_name"
        fi
    done
done

echo "Renaming complete!"
