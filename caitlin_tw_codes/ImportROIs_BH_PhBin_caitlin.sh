#!/bin/bash

cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh

MOUNT='/Volumes/kratos/caitlin/subset/atlas/'
export SUBJECTS_DIR='/Volumes/kratos/caitlin/caitlin_subs/'

# Parallel arrays (same length, same order)
#subjectlist=("Map01" "Map02" "Map03" "Map04" "Map06" "Map07" "Map08" "Map09" "Map10" "Map11" "Map14")
#anatsubs=("Map01_3T" "Map02" "Map03" "Map04" "Map06" "Map07" "Map08" "Map09" "Map10" "Map11" "Map14")   # or Map01_3T Map01_3T if intentional


subjectlist=("TS279")
anatsubs=("TS279")   # or Map01_3T Map01_3T if intentional


modality=("3T" "7T")

for i in "${!subjectlist[@]}"; do
    subject="${subjectlist[i]}"
    anatsub="${anatsubs[i]}"

    echo "Processing $subject with anatomy $anatsub"

    for j in "${!modality[@]}"; do
        
        mod="${modality[j]}"

        for ((k=2; k<=5; k++)); do

            mri_vol2surf \
                --hemi lh \
                --mov "${MOUNT}/${subject}/${mod}/RD${k}.nii" \
                --regheader "$anatsub" \
                --projfrac-avg 0.1 1 0.1 \
                --surf-fwhm 1 \
                --surf white \
                --out "${MOUNT}/${subject}/${mod}/RD${k}.mgh" \
                --out_type mgh

            mri_surf2surf \
                --srcsubject "$anatsub" \
                --trgsubject fsaverage \
                --hemi lh \
                --sval "${MOUNT}/${subject}/${mod}/RD${k}.mgh" \
                --tval "${MOUNT}/${subject}/${mod}/RD${k}_fsaverage.mgh"

            mri_binarize \
                --i "${MOUNT}/${subject}/${mod}/RD${k}_fsaverage.mgh" \
                --min 0.1 \
                --o "${MOUNT}/${subject}/${mod}/RD${k}_fsaverage_bin.mgh"

        done

    done
done

echo "Done!"
