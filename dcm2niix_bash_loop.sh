#!/bin/bash

# Root folder containing subject directories
rootfolder="/Volumes/kratos/NEXPODTIS/ppzma-20250923_145236"

# Loop through all subject directories
for subjdir in "$rootfolder"/*/; do
    # Get just the subject folder name (e.g. XXX_sub01)
    subj=$(basename "$subjdir")
    
    echo "Processing subject: $subj"

    # Run dcm2niix on the subject folder
    /Applications/MRIcron.app/Contents/Resources/dcm2niix "$subjdir"

    echo "Completed subject: $subj"
    echo "----------------------------"
done
