#!/bin/sh

# code to stick together parts1 and 2 of resting state data from kiwi study

mainpath="/Volumes/ares/ZESPRI/spm_analysis/"
visit="B C D"


for thisvisit in $visit;
do

	thispath="${mainpath}session_${thisvisit}/rs/"
	cd "$thispath" || exit 1

	echo $thispath
	for (( k=1; k<=14; k++ ));
	do
	 	echo rs1_${k}${thisvisit}.nii.gz

	 	fslmerge -t rs_mrg_${k}${thisvisit}.nii.gz rs1_${k}${thisvisit}.nii.gz rs2_${k}${thisvisit}.nii.gz


	done
done