#!/bin/bash
mountPoint="/Volumes/DRS-GBPerm/other/inputs/"
downPoint="/Volumes/nemosine/NEXPO/inputs/"

#SUBJECTS=("17105_002" "12411_004" "16464_002" "16439_002" "16438_002" "16513_002" "17207_003" "17105_002")

SUBJECTS=("16044_002" "16043_002" "15721_009" "12967_004" "12869_013" "12428_005" "12422_004" \
    "10760_130" "16437_002" "16430_002" "16322_002" "16302_002" "16282_002" "16281_002" "16231_003" \
    "16174_002" "16154_002" "16871_002" "16793_006" "16725_002" "16664_002" "16662_002" "16615_002" \
    "16613_002" "17341_002" "17305_002" "17293_002" "17243_002" "17041_002" "17038_002" "17706_002" \
    "17698_002" "17617_002" "17532_002" "17492_002" "17491_002" "17456_002")

# Loop through each subject's MPRAGE folder and sync it while preserving the directory structure
# for subject in ${mountPoint}*/MPRAGE; do
#   rsync -av --progress --relative "$subject/" "$downPoint"
# done

for subject in "${SUBJECTS[@]}"; do
  rsync -avR --progress ${mountPoint}${subject}/"MPRAGE/" ${downPoint}
done