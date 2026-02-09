#!/bin/bash



# This code looks inside a source folder, and finds all dti_FA files in all subj folders and copies them to a new 
# destination folder, renaming them "SUBJ_dti_FA"

# Source and destination directories
#SRC="/Volumes/kratos/dti_data/sashbdatasets"
#SRC="/Volumes/DRS-CHAIN-Study/dti_data/outputs/"
SRC="/Volumes/kratos/dti_data/chaindatasets/less300/"
#DST="/Volumes/kratos/dti_data/tbss_analysis_wchain"
#DST="/Volumes/DRS-CHAIN-Study/dti_data/dti_md/"
DST="/Volumes/kratos/dti_data/tbss_analysis_wchain_less300/MD/origMD/"

#DST="/Volumes/kratos/dti_data/tbss_analysis_wchain"

# Make sure destination exists
mkdir -p "$DST"

# Loop through all subjects
for d in "$SRC"/*/analysis/dMRI/processed/data/data.dti; do
    subj=$(basename "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$d") )") )")")")") # Extract subject ID
    echo $subj

    

    src_file="${d}/dti_MD.nii.gz"
    dest_file="${DST}/${subj}_dti_MD.nii.gz"
    #src_file="${d}/dti_MD.nii.gz"
    #dest_file="${DST}/${subj}_dti_MD.nii.gz"

    echo $src_file
    echo $dest_file

    #exit 0

    if [ -f "$src_file" ]; then
        echo "📦 Copying $subj → $dest_file"
        cp -n "$src_file" "$dest_file"
        echo "Would copy $src_file → $dest_file"
    else
        echo "⚠️ Missing MD file for $subj"
    fi
done

echo "✅ All available MD maps copied to $DST"
