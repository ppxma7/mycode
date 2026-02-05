#!/bin/bash

cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh

MOUNT='/Volumes/nemosine/caitlin_data/atlas/'
export SUBJECTS_DIR='/Volumes/nemosine/caitlin_subs/'

# Parallel arrays (same length, same order)
subjectlist=("3T" "7T")
anatsubs=("Map01_3T" "Map01_3T")   # or Map01_3T Map01_3T if intentional

for i in "${!subjectlist[@]}"; do
    subject="${subjectlist[i]}"
    anatsub="${anatsubs[i]}"

    echo "Processing $subject with anatomy $anatsub"

    for ((k=2; k<=5; k++)); do

        mri_vol2surf \
            --hemi lh \
            --mov "${MOUNT}/${subject}/RD${k}.nii.gz" \
            --regheader "$anatsub" \
            --projfrac-avg 0.1 1 0.1 \
            --surf-fwhm 1 \
            --surf white \
            --out "${MOUNT}/${subject}/RD${k}.mgh" \
            --out_type mgh

        mri_surf2surf \
            --srcsubject "$anatsub" \
            --trgsubject fsaverage \
            --hemi lh \
            --sval "${MOUNT}/${subject}/RD${k}.mgh" \
            --tval "${MOUNT}/${subject}/RD${k}_fsaverage.mgh"

        mri_binarize \
            --i "${MOUNT}/${subject}/RD${k}_fsaverage.mgh" \
            --min 0.1 \
            --o "${MOUNT}/${subject}/RD${k}_fsaverage.mgh"

        # mri_vol2surf \
        #     --hemi rh \
        #     --mov "${MOUNT}/${subject}/LD${k}.nii.gz" \
        #     --regheader "$anatsub" \
        #     --projfrac-avg 0.1 1 0.1 \
        #     --surf-fwhm 1 \
        #     --surf white \
        #     --out "${MOUNT}/${subject}/LD${k}.mgh" \
        #     --out_type mgh

        # mri_surf2surf \
        #     --srcsubject "$anatsub" \
        #     --trgsubject fsaverage \
        #     --hemi rh \
        #     --sval "${MOUNT}/${subject}/LD${k}.mgh" \
        #     --tval "${MOUNT}/${subject}/LD${k}_fsaverage.mgh"

        # mri_binarize \
        #     --i "${MOUNT}/${subject}/LD${k}_fsaverage.mgh" \
        #     --min 0.1 \
        #     --o "${MOUNT}/${subject}/LD${k}_fsaverage.mgh"

    done
done

echo "Done!"
