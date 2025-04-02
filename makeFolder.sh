#!/bin/bash

# Array of directories to be created
dirs=("json" "magnitude" "phase" "parrec")

# Create directories if they don't exist
for dir in "${dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "Directory '$dir' already exists. Skipping creation."
    else
        mkdir "$dir" && echo "Directory '$dir' created."
    fi
done

# Move JSON files
if ls *.json &>/dev/null; then
    mv -i *.json json/
else
    echo "No JSON files to move."
fi

# Move phase files (*_ph.nii.gz)
if ls *_ph.nii.gz &>/dev/null; then
    mv -i *_ph.nii.gz phase/
else
    echo "No phase files to move."
fi

# Move remaining magnitude NIFTI files (*.nii.gz, excluding *_ph.nii.gz)
shopt -s extglob
if ls !(*_ph).nii.gz &>/dev/null; then
    mv -i !(*_ph).nii.gz magnitude/
else
    echo "No magnitude files to move."
fi
shopt -u extglob

# Move PAR/REC files
if ls *.PAR &>/dev/null; then
    mv -i *.PAR parrec/
else
    echo "No PAR files to move."
fi

# Move PAR/REC files
if ls *.REC &>/dev/null; then
    mv -i *.REC parrec/
else
    echo "No REC files to move."
fi
