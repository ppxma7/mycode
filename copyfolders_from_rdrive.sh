#!/bin/bash
mountPoint="/Volumes/DRS-GBPerm/other/inputs/"
downPoint="/Volumes/nemosine/NEXPO/inputs/"

SUBJECTS=("17105_002" "12411_004" "16464_002" "16439_002" "16438_002" "16513_002" "17207_003" "17105_002")

# Loop through each subject's MPRAGE folder and sync it while preserving the directory structure
# for subject in ${mountPoint}*/MPRAGE; do
#   rsync -av --progress --relative "$subject/" "$downPoint"
# done

for subject in "${SUBJECTS[@]}"; do
  rsync -avR --progress ${mountPoint}${subject}/"MPRAGE/" ${downPoint}
done