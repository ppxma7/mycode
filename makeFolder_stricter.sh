#!/bin/bash

# Loop through all subject directories in the current folder
for subj in */; do
    echo "Processing subject: $subj"

    # Create a DTI folder if it doesn't already exist
    mkdir -p "${subj}DTI"

    # Move *DTI*.nii files into DTI folder (only from the top level of subj dir)
    #find "$subj" -maxdepth 1 -type f -name "*DTI*" -exec mv -i {} "${subj}DTI/" \;

    echo "The following items would be removed from ${subj}:"
    find "$subj" -mindepth 1 -maxdepth 1 ! -name "DTI" -print

    # Remove all other items inside subject dir except DTI folder
    sudo find "$subj" -mindepth 1 -maxdepth 1 ! -name "DTI" -exec rm -rf {} +
done
