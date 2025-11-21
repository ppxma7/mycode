#!/bin/bash

# Source and destination directories
SRC="/Volumes/kratos/dti_data/datasets"
DST="/Volumes/kratos/dti_data/tbss_analysis_justnexpo"

# Make sure destination exists
mkdir -p "$DST"

# Loop through all subjects
for d in "$SRC"/*/analysis/dMRI/processed/data/data.dti; do
    subj=$(basename "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$d") )") )")")")") # Extract subject ID
    echo $subj

    

    src_file="${d}/dti_FA.nii.gz"
    dest_file="${DST}/${subj}_dti_FA.nii.gz"

    echo $src_file
    echo $dest_file

    #exit 0

    if [ -f "$src_file" ]; then
        echo "📦 Copying $subj → $dest_file"
        cp -n "$src_file" "$dest_file"
        #echo "Would copy $src_file → $dest_file"
    else
        echo "⚠️ Missing FA file for $subj"
    fi
done

echo "✅ All available FA maps copied to $DST"
