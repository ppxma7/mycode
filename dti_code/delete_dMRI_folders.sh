#!/bin/bash

root="/Volumes/DRS-GBPerm/other/outputs/"

# # loop through all folders directly inside $root
# for subj in "$root"/*/; do
#     target="$subj/analysis/dMRI"

#     if [ -d "$target" ]; then
#         echo "Deleting: $target"
#         rm -rf "$target"
#         #echo "Would delete $target"
#     else
#         echo "Skipping (not found): $target"
#     fi
# done



#root="/Volumes/DRS-GBPerm/other/outputs/"

# loop through all folders directly inside $root
for subj in "$root"/*/; do
    target="${subj%/}/analysis/anatMRI/T1/processed/FastSurfer"

    if [ -d "$target" ]; then
        echo "Deleting: $target"
        rm -rf "$target"
        #echo "Would delete $target"
    else
        echo "Skipping (not found): $target"
    fi
done

