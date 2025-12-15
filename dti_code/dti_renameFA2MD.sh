#!/usr/bin/env bash
# set -euo pipefail

# # Rename *_MD.nii.gz → *_FA.nii.gz in the current directory
# for f in *_MD.nii.gz; do
#     # Skip if no files match
#     [[ -e "$f" ]] || continue

#     new="${f/_MD.nii.gz/_FA.nii.gz}"

#     # Safety check: don't overwrite existing files
#     if [[ -e "$new" ]]; then
#         echo "Skipping (target exists): $new"
#     else
#         cp "$f" "$new"
#     fi
# done


# DO THIS FOR NEXPO, due to underscore of FA maps - 
# when you want to run TBSS for non FA images, you have 
# to use the exact same file name

for f in NEXPO_*_dti_MD.nii.gz; do
    [[ -e "$f" ]] || continue

    # 1) remove underscore after NEXPO
    # 2) change _MD → _FA
    new="$(echo "$f" | sed 's/^NEXPO_/NEXPO/; s/_MD\.nii\.gz$/_FA.nii.gz/')"

    if [[ -e "$new" ]]; then
        echo "Skipping (target exists): $new"
    else
        mv "$f" "$new"
    fi
done

