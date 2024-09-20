#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=12gb
#SBATCH --time=48:00:00
#SBATCH --array=1

# set to 1 for a,b,c,d to test 

echo "Running on `hostname`"

STARTTIME=$(date +%s)
echo "Running on `hostname`"
echo "Started at: $(date +%F_%T)"
cd ${SLURM_SUBMIT_DIR}
subj=${SLURM_ARRAY_TASK_ID}

 
module load fsl-uon/binary/5.0.11/


batch_dir="/gpfs01/home/ppzma/zespri/code/"
#batch_dir="/Users/ppzma/Documents/MATLAB/nottingham/michael/"

bigmount="/gpfs01/home/ppzma/zespri/"
#bigmount="/Volumes/hermes/testing_grounds/"
endmount="/brand/Topup/"

#subj=4



# mypath=("zespri_${subj}A"\
# 	"zespri_${subj}B"\
#   	"zespri_${subj}C"\
#    	"zespri_${subj}D")

mypath=("zespri_${subj}D")

#echo ${mypath[@]}

filename=("brandapplytopup_command_subject_$subj.txt")

if [ ! -f "$batch_dir$filename" ]; then
	touch $batch_dir$filename
	echo "TOUCH"
elif [ -f "$batch_dir$filename" ]; then
	rm $batch_dir$filename
	echo "RM"
else
	echo "FAILED"
fi


for index in "${!mypath[@]}";
do

	cd $bigmount${mypath[$index]}$endmount

	#echo $bigmount${mypath[0]}$endmount

	SE_P=$(ls *WIPP_SE*.nii)
	SE_A=$(ls *WIPA_SE*.nii)
	fMRI_Data=$(ls *brand*14_ws*.nii)

	#echo $SE_P
	#echo $SE_A
	echo $fMRI_Data

	#SE_A="bloop"

	#echo $bigmount${mypath[$index]}$endmount$SE_P
	#echo $bigmount${mypath[$index]}$endmount$SE_A
	#echo $bigmount${mypath[$index]}$endmount$fMRI_Data

	SE_P_var=$(echo "${SE_P}" | cut -f 1 -d '.')
	SE_A_var=$(echo "${SE_A}" | cut -f 1 -d '.')
	fMRI_Data_var=$(echo "${fMRI_Data}" | cut -f 1 -d '.')

	#echo $bigmount${mypath[$index]}$endmount$fMRI_Data_var

	#echo $bigmount${mypath[$index]}$endmount
	#echo $index
	#echo $SE_A_var
	#echo $SE_P_var
	#echo $fMRI_Data_var


	#fslroi $SE_A_var ${SE_A_var}_clv 0 3
	#fslroi $SE_P_var ${SE_P_var}_clv 0 3
	fslroi $fMRI_Data_var ${fMRI_Data_var}_clv 0 210

	#topup_path=$bigmount${mypath[$index]}$endmount


	#cat ${template} | sed s:PATH:${subj}:g > ${batch_dir}/zespri_topup_${subj}.txt



	#thisCommand="sh /Users/ppzma/Documents/MATLAB/nottingham/bin/toppedup.sh $bigmount${mypath[$index]}$endmount ${SE_P_var} ${SE_A_var}"
	#thisCommand="sh /gpfs01/home/ppzma/zespri/code/toppedup.sh $bigmount${mypath[$index]}$endmount ${SE_P_var} ${SE_A_var}"
	#thisCommand="sh /gpfs01/home/ppzma/zespri/code/applytoppedup.sh $bigmount${mypath[$index]}$endmount ${fMRI_Data_var} ${SE_P_var}_merged"
	thisCommand="sh /gpfs01/home/ppzma/zespri/code/applytoppedup.sh $bigmount${mypath[$index]}$endmount ${fMRI_Data_var}_clv ${SE_P_var}_merged"
	echo $thisCommand >> $batch_dir$filename



done


module load parallel-uon

echo "Started parallel run"
parallel --jobs 4 < $batch_dir$filename

echo "Finished job now"

ENDTIME=$(date +%s)
Total_time=$(echo "scale=2; ($ENDTIME-$STARTTIME)/3600.0" | bc -l)
echo "Finished at $(date +%F_%T) after ${Total_time} hours"




