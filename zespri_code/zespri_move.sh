#!/bin/bash

cd /Volumes/ares/ZESPRI/

days="zespri_180523 zespri_190523 zespri_220523 zespri_230523 zespri_250523 zespri_260523 zespri_300523 zespri_310523 zespri_010623"

subjectlist="zespri_1A zespri_2A zespri_3A zespri_4A zespri_5A zespri_6A 
	zespri_1B zespri_3B zespri_9A "
#subjectlist="03942"
for subject in $subjectlist
do
	echo $subject
	cd /Volumes/Nemosine/ma/restingState/$subject/${subject}_toppedup_mcf.feat/
	gunzip filtered_func_data.nii.gz 
	mv filtered_func_data.nii /Volumes/Nemosine/ma/restingState/$subject/2mm/
done

