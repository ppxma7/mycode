#!/bin/bash
cd ~
MOUNT='/Volumes/r15/DRS-TOUCHMAP/ma_ares_backup/TOUCH_REMAP/exp016/231108_share/'
#export SUBJECTS_DIR=/Volumes/r15/DRS-TOUCHMAP/ma_ares_backup/TOUCH_REMAP/exp016//
#subjectlist=("005" "006" "008" "009" "011" "012" "013" "014" "015" "017" "018" "020" "021" "022" "023" "024" "025" "026" "028" "029" "030" "031" "032" "033" "034" "035" "036" "037" "038" "039" "040" "041" "042" "043" "045" "046" "047" "049" "050" "051" "052" "054" "055" "056" "057" "059" "060" "061" "063" "064")
#subjectlist="005 006 008 009 011 012 013 014 015 017 018 020 021 022 023 024 025 026 028 029 030 031 032 033 034 035 036 037 038 039 040 041 042 043 045 046 047 049 050 051 052 054 055 056 057 059 060 061 063 064"
subjectlist="025 031 035 038 039 040 046 057 060 063"

#subjectlist=("005")
study="sub016"



for subject in $subjectlist
do
    echo $subject
    maskDir=$MOUNT/${study}_${subject}/masked_zstats/
    mkdir -p $maskDir

    for k in {1..5}
    do
        thisMask=$MOUNT/${study}_${subject}/resultsSummary/atlas/RD${k}.nii
        thisZstat=$MOUNT/${study}_${subject}/resultsSummary/r${subject}_aveRightHand_Cope${k}zstat_2highres.nii
        thisOutput=$maskDir/zstat_masked_${k}

        fslmaths $thisZstat -mul $thisMask $thisOutput

    done


done
