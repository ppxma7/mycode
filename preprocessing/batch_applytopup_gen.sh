#! /bin/bash

echo "Hey, you. You're finally awake..."

mypath="/Volumes/ares"
mysub="pain_07_15874_230213"
mydata="topup/topup_rs_2"
# myscans="parrec_FAST_rsfMRI_20221117112738_6_nordic.nii
#     parrec_FAST_rsfMRI_20221117112738_7_nordic.nii
#     parrec_FAST_rsfMRI_20221117112738_22_nordic.nii
#     parrec_PTSarm_20221117112738_13_nordic.nii
#     parrec_PTSarm_20221117112738_27_nordic.nii
#     parrec_PTShand_20221117112738_17_nordic.nii
#     parrec_thermode_armblock1_20221117112738_15_nordic.nii
#     parrec_thermode_armblock1_20221117112738_24_nordic.nii
#     parrec_thermode_armblock2_20221117112738_16_nordic.nii
#     parrec_thermode_armblock2_20221117112738_25_nordic.nii
#     parrec_thermode_block1_20221117112738_9_nordic.nii
#     parrec_thermode_block2_20221117112738_10_nordic.nii
#     parrec_FAST_rsfMRI_TOPUP_20221117112738_8.nii
#     parrec_FAST_rsfMRI_TOPUP_20221117112738_23.nii
#     parrec_thermode_TOPUP_20221117112738_11.nii
#     parrec_thermode_TOPUP_20221117112738_26.nii"
myscans="parrec_FAST_rsfMRI_20230213101502_23_nordic_clv"


# myscans="parrec_thermode_block1_20221117112738_9_nordic_clv
# 	parrec_thermode_block2_20221117112738_10_nordic_clv
# 	parrec_PTSarm_20221117112738_13_nordic_clv
# 	parrec_thermode_armblock1_20221117112738_15_nordic_clv
# 	parrec_thermode_armblock2_20221117112738_16_nordic_clv
# 	parrec_PTShand_20221117112738_17_nordic_clv"

#myscans="parrec_thermode_armblock1_20221129122548_8_nordic_clv
#parrec_thermode_armblock2_20221129122548_9_nordic_clv
#parrec_PTSarm_20221129122548_11_nordic_clv"

# myscans="tgi_sub_04_12778_221124_WIPThermode-fMRI1_20221124145248_8_nordic_clv
# tgi_sub_04_12778_221124_WIPThermode-fMRI1_20221124145248_11_nordic_clv
# tgi_sub_04_12778_221124_WIPThermode-fMRI1_20221124145248_9_nordic_clv
# tgi_sub_04_12778_221124_WIPThermode-fMRI1_20221124145248_10_nordic_clv
# tgi_sub_04_12778_221124_WIPTGI1_20221124145248_4_nordic_clv
# tgi_sub_04_12778_221124_WIPTGI2_20221124145248_5_nordic_clv"

topupscan="parrec_FAST_rsfMRI_TOPUP_20230213101502_24_clv"
mergescan="parrec_FAST_rsfMRI_20230213101502_23_nordic_clv"

for sub in $mysub
do
	echo "Running toppedup first..."
	cd ${mypath}/$sub/${mydata}/
	sh /Users/ppzma/Documents/MATLAB/nottingham/bin/toppedup.sh ${mypath}/$sub/${mydata}/ ${mypath}/$sub/${mydata}/$mergescan ${mypath}/$sub/${mydata}/$topupscan
done


for sub in $mysub
do
	echo $sub
	for scan in $myscans
	do

		echo $scan
		echo "Applying those topups..."
		cd ${mypath}/$sub/${mydata}/
		sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}/$sub/${mydata}/ ${mypath}/$sub/${mydata}/$scan ${mypath}/$sub/${mydata}/${mergescan}_merged

	done


done
echo "Task complete, shutting down..."

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

