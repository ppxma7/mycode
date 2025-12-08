#! /bin/bash

SECONDS=0  # Start timing


mypath="/Volumes/kratos/SOFYA/"
mysub="12185_004/"
mydata="topup/"

myscans=("12185_004_WIP_fMRI_RS_20220804125939_1001")

mergescan="12185_004_WIP_fMRI_RS_FOR_20220804125939_1101"

topupscan="12185_004_WIP_fMRI_RS_REV_20220804125939_1201"

numDyn=2

for sub in $mysub
do
	echo "Running toppedup first..."
	cd ${mypath}/$sub/${mydata}/
	sh /Users/ppzma/Documents/MATLAB/nottingham/fMRI_preproc/toppedup.sh \
		${mypath}/$sub/${mydata}/ \
		${mypath}/$sub/${mydata}/$mergescan \
		${mypath}/$sub/${mydata}/$topupscan \
		$numDyn
done


for sub in $mysub
do
	echo $sub
	for scan in "${myscans[@]}"; do
		echo "  Processing scan: $scan"
		echo "  Applying topup..."
		cd ${mypath}/$sub/${mydata}/
		sh /Users/ppzma/Documents/MATLAB/nottingham/fMRI_preproc/applytoppedup.sh \
			${mypath}/$sub/${mydata}/ \
			${mypath}/$sub/${mydata}/$scan \
			${mypath}/$sub/${mydata}/${mergescan}_merged

	done


done
echo "Task complete, shutting down..."

duration=$SECONDS
echo "Script ran for $(($duration / 60)) minutes and $(($duration % 60)) seconds."

# cd ${mypath}${mydata}/

# echo "running topup on the base scan"
# # Usage: sh toppedup.sh path fMRIdata topupdata outputfMRI outputtopup"	
# #sh /Users/ppzma/Documents/MATLAB/nottingham/bin/toppedup.sh ${mypath}${mydata} BASE400crop BASE400topupcrop input1 input2

# echo "applying base topup to labels"
# # Usage: sh applytoppedup.sh path fMRIdata mergeddata"	
# sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} BASE400crop BASE400crop_merged
# sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR1000_label1_nordic_clv BASE400crop_merged
# sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR2000_label1_nordic_clv BASE400crop_merged
# sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR3000_label1_nordic_clv BASE400crop_merged
# sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR4000_label1_nordic_clv BASE400crop_merged
# sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR1000_label2_nordic_clv BASE400crop_merged
# sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR2000_label2_nordic_clv BASE400crop_merged
# sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR3000_label2_nordic_clv BASE400crop_merged
# sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR4000_label2_nordic_clv BASE400crop_merged


# echo "cleaving the noise scan"
# fslroi FAIR1000_label1_nordic_toppedupabs FAIR1000_label1_nordic_toppedupabs_clv 0 30
# fslroi FAIR2000_label1_nordic_toppedupabs FAIR2000_label1_nordic_toppedupabs_clv 0 30
# fslroi FAIR3000_label1_nordic_toppedupabs FAIR3000_label1_nordic_toppedupabs_clv 0 30
# fslroi FAIR4000_label1_nordic_toppedupabs FAIR4000_label1_nordic_toppedupabs_clv 0 30

# fslroi FAIR1000_label2_nordic_toppedupabs FAIR1000_label2_nordic_toppedupabs_clv 0 30
# fslroi FAIR2000_label2_nordic_toppedupabs FAIR2000_label2_nordic_toppedupabs_clv 0 30
# fslroi FAIR3000_label2_nordic_toppedupabs FAIR3000_label2_nordic_toppedupabs_clv 0 30
# fslroi FAIR4000_label2_nordic_toppedupabs FAIR4000_label2_nordic_toppedupabs_clv 0 30

