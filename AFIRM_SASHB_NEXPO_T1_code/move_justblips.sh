#!/bin/bash

# Source and destination directories
SRC_DIR="/Users/ppzma/Downloads/ppzma-20250904_143044/outs"
DST_DIR="/Volumes/nemosine/SAN/AFIRM/afirm_new_ins"

# Loop over all *_tmp folders in the source directory
for folder in "$SRC_DIR"/*_tmp; do
    # Get the base folder name without _tmp
    base_name=$(basename "$folder" "_tmp")
    
    # Destination DTI folder
    dest="$DST_DIR/$base_name/DTI"
    
    # Create destination folder if it doesn't exist
    mkdir -p "$dest"
    
    # Move all contents from the _tmp folder to the destination DTI folder
    mv "$folder"/* "$dest"/
    
    echo "Moved contents of $folder to $dest"
done

echo "All done!"
