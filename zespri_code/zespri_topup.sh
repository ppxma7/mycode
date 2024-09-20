#! /bin/bash

#mypath="/Volumes/ares/ZESPRI/zespri_180523/zespri_1A/nback/Topup/"

bigmount="/Volumes/ares/ZESPRI/"
endmount="nback/Topup/"

mypath=("zespri_180523/zespri_2A/" \
	"zespri_190523/zespri_4A/")
#mysub="zespri_180523/"
#mydata="zespri_1A/nback/Topup/"


SE_A=("parrec_WIPA_SE-EPI_SENSE2_MB3_DE_EPI_20230518111912_16.nii"\
	"parrec_WIPA_SE-EPI_SENSE2_MB3_DE_EPI_20230519085309_16.nii")

SE_P=("parrec_WIPP_SE-EPI_SENSE2_MB3_DE_EPI_20230518111912_15.nii"\
	"parrec_WIPP_SE-EPI_SENSE2_MB3_DE_EPI_20230519085309_15.nii")

fMRI_data=("parrec_WIPN-BACK_SENSE2_MB3_DE_EPI_20230518111912_14_ws_map_RCR.nii"\
	"parrec_WIPN-BACK_SENSE2_MB3_DE_EPI_20230519085309_14_ws_map_RCR.nii")


for index in "${!mypath[@]}";
do
	cd ${bigmount}${mypath[$index]}${endmount}
	pwd
	echo ${bigmount}${mypath[$index]}${endmount}

	echo "${mypath[$index]}"

	echo "${SE_A[$index]}"
	echo "${SE_P[$index]}"
	echo "${fMRI_data[$index]}"


	SE_A_var=$(echo "${SE_A[$index]}" | cut -f 1 -d '.')
	SE_P_var=$(echo "${SE_P[$index]}" | cut -f 1 -d '.')
	fMRI_data_var=$(echo "${fMRI_data[$index]}" | cut -f 1 -d '.')

	echo $SE_A_var

	#fslroi $SE_A_var ${SE_A_var}_clv 0 3
	#fslroi $SE_P_var ${SE_P_var}_clv 0 3
	#fslroi $fMRI_data_var ${fMRI_data_var}_clv 0 282

	echo "running topup on the base scan"
	# Usage: sh toppedup.sh path fMRIdata topupdata outputfMRI outputtopup"	
	#sh /Users/ppzma/Documents/MATLAB/nottingham/bin/toppedup.sh ${mypath[$index]} ${SE_P_var}_clv ${SE_A_var}_clv
	echo "applying base topup to labels"

	#sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath[$index]} ${fMRI_data_var}_clv ${SE_P_var}_clv_merged
	echo "done"
done

#cd ${mypath}


#SE_A_var=$(echo "$SE_A" | cut -f 1 -d '.')
#SE_P_var=$(echo "$SE_P" | cut -f 1 -d '.')
#fMRI_data_var=$(echo "$fMRI_data" | cut -f 1 -d '.')

##echo $SE_A_var

#fslroi $SE_A_var ${SE_A_var}_clv 0 3
#fslroi $SE_P_var ${SE_P_var}_clv 0 3
#fslroi $fMRI_data_var ${fMRI_data_var}_clv 0 282

#echo "running topup on the base scan"
## Usage: sh toppedup.sh path fMRIdata topupdata outputfMRI outputtopup"	
#echo ${mypath}
#echo ${SE_P_var}_clv
#echo ${SE_A_var}_clv
#sh /Users/ppzma/Documents/MATLAB/nottingham/bin/toppedup.sh ${mypath} ${SE_P_var}_clv ${SE_A_var}_clv

##echo "applying base topup to labels"
## Usage: sh applytoppedup.sh path fMRIdata mergeddata"	
#sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath} ${fMRI_data_var}_clv ${SE_P_var}_clv_merged

