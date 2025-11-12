#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=12gb
#SBATCH --time=48:00:00

STARTTIME=$(date +%s)
echo "Running on `hostname` at $(date +%F_%T)"

cd ${SLURM_SUBMIT_DIR}
#subj='SUB0'${SLURM_ARRAY_TASK_ID}

#module purge
module load matlab-uon/r2019b
dir=/gpfs01/home/ppzma/t1mapping/data/
#mkdir -p ${SLURM_SUBMIT_DIR}/$SLURM_JOB_ID

cd $dir

#matlab -nodesktop -nosplash -nodisplay -r "column_filter_hpc('${subj}',2000); quit"
#matlab -nodesktop -nosplash -nodisplay -r "column_pe_thresh_hpc('${subj}', 'EEG', 2000); quit"
#matlab -nodesktop -nosplash -nodisplay -r "NaNmask_columns_hpc('${subj}', 2000); quit"

#matlab -nodesktop -nosplash -nodisplay -r addpath(genpath('/gpfs01/home/ppzma/matlab/'));
#matlab -nodesktop -nosplash -nodisplay "startup";
matlab -nodesktop -nosplash -nodisplay -r "addpath(genpath('/gpfs01/home/ppzma/matlab/'));T1_3Dfit_hpc; quit"

#cd ${SLURM_SUBMIT_DIR}
#echo "Removing /${SLURM_JOB_ID}"
#rm -rf ${SLURM_SUBMIT_DIR}/$SLURM_JOB_ID

ENDTIME=$(date +%s)
Total_time=$(echo "scale=3; ($ENDTIME-$STARTTIME)/3600.0" | bc -l)
echo "Finished at $(date +%F_%T) after ${Total_time} hours"
