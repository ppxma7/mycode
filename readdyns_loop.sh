#!/bin/bash

rootfolder="/Volumes/kratos/CHAIN_inputs_mricrogl/v6/"
outcsv="$rootfolder/dti_dynamics.csv"

# Create / reset CSV and write header
echo "subject,filename,dim4" > "$outcsv"

for subjdir in "$rootfolder"/*/; do
    subj=$(basename "$subjdir")
    echo "Processing subject: $subj"

    find "$subjdir" -maxdepth 1 -type f \
        \( -name "*_WIP_MB3_sDTI_SPMICopt_*.nii" -o -name "*_WIP_MB3_sDTI_SPMICopt_*.nii.gz" \) \
        ! -iname "*blip*" \
        ! -iname "*_ph.nii" \
        ! -iname "*_ph.nii.gz" | while read -r nifti; do

        fname=$(basename "$nifti")

        ndyn=$(fslinfo "$nifti" | awk '/^dim4/ {print $2}')

        echo "  $fname → $ndyn dynamics"

        # Append row to CSV
        echo "$subj,$fname,$ndyn" >> "$outcsv"
    done

    echo "----------------------------"
done

echo "CSV written to: $outcsv"
