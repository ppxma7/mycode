#! /bin/bash

# This script tries to streamline running FSL TOP UP on 4D fMRI data
#
# written by Michael Asghar, SPMIC, April 2019
#
#

#subjectlist="00393_HC 03942_HC 13287_HC 13945_HC 13382_post 13382_pre 13447_post 13493_post 13493_pre 13654_post 13658_post 13658_pre 13695_post 13695_pre 14001_post"

subjectlist="00393_HC"

mypath=/Volumes/TOUCHMAP/Daisie/restingState/fortopup/
cd $mypath

echo "batchTopup"

for subject in $subjectlist
do
	echo $subject
	echo "Running TOPUP"
	#sh toppedup.sh mypath ${subject} ${subject}_topup ${subject}_outputfMRI ${subject}_outputtopup 

	echo "Applying topup"
	applytopup --imain=${subject} --datain=acqparams.txt --topup=${subject}_merged --inindex=1 --out=${subject}_toppedup --method=jac

done


