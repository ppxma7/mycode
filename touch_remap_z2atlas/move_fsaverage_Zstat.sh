#!/bin/bash
cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh 
export SUBJECTS_DIR=/Volumes/r15/DRS-TOUCHMAP/ma_ares_backup/TOUCH_REMAP/exp016/freesurfer/
MOUNT='/Volumes/r15/DRS-TOUCHMAP/ma_ares_backup/TOUCH_REMAP/exp016/231108_share/'
#export SUBJECTS_DIR=/Volumes/r15/DRS-TOUCHMAP/ma_ares_backup/TOUCH_REMAP/exp016//
#subjectlist=("005" "006" "008" "009" "011" "012" "013" "014" "015" "017" "018" "020" "021" "022" "023" "024" "025" "026" "028" "029" "030" "031" "032" "033" "034" "035" "036" "037" "038" "039" "040" "041" "042" "043" "045" "046" "047" "049" "050" "051" "052" "054" "055" "056" "057" "059" "060" "061" "063" "064")
subjectlist="005 006 008 009 011 012 013 014 015 017 018 020 021 022 023 024 025 026 028 029 030 031 032 033 034 035 036 037 038 039 040 041 042 043 045 046 047 049 050 051 052 054 055 056 057 059 060 061 063 064"
#subjectlist="025 031 035 038 039 040 046 057 060 063"

#subjectlist=("005")
study="sub016"

for subject in $subjectlist
do

	echo "running subject $subject ..."

	for k in {1..5}
	do
		thisZstat=$MOUNT/${study}_${subject}/masked_zstats/zstat_masked_${k}.nii.gz
		thisZstatSurf=$MOUNT/${study}_${subject}/masked_zstats/zstat_masked_${k}.mgh
		thisZstatFSSurf=$MOUNT/${study}_${subject}/masked_zstats/zstat_masked_${k}_fsaverage.mgh
		echo "running zstat $thisZstat ..."

		mri_vol2surf --hemi lh --mov $thisZstat --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out $thisZstatSurf --surf white --out_type mgh
    	mri_surf2surf --srcsubject ${subject} --trgsubject fsaverage --hemi lh --sval $thisZstatSurf --tval $thisZstatFSSurf


    	echo "Finished vol2surf2surf for subject $subject ..."




	done
done