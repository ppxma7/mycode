#!/bin/bash

rootfolder="/Volumes/kratos/CHAIN_inputs_mricrogl/v6/"
outcsv="$rootfolder/dti_dynamics.csv"

# Create / reset CSV
echo "subject,filename,dim4,n_bvals" > "$outcsv"

for subjdir in "$rootfolder"/*/; do
    subj=$(basename "$subjdir")
    echo "Processing subject: $subj"

    find "$subjdir" -maxdepth 1 -type f \
        \( -name "*_WIP_MB3_sDTI_SPMICopt_*.nii" -o -name "*_WIP_MB3_sDTI_SPMICopt_*.nii.gz" \) \
        ! -iname "*blip*" \
        ! -iname "*_ph.nii" \
        ! -iname "*_ph.nii.gz" | while read -r nifti; do

        fname=$(basename "$nifti")

        # --- dim4 from NIfTI ---
        ndyn=$(fslinfo "$nifti" | awk '/^dim4/ {print $2}')
        ndyn=${ndyn:-NA}

        # --- corresponding .bval ---
        bval="${nifti%.nii}"
        bval="${bval%.gz}.bval"

        if [ -f "$bval" ]; then
            nbval=$(wc -w < "$bval")
        else
            nbval="NA"
        fi

        echo "  $fname → dim4=$ndyn | bvals=$nbval"

        echo "$subj,$fname,$ndyn,$nbval" >> "$outcsv"
    done

    echo "----------------------------"
done

echo "CSV written to: $outcsv"
