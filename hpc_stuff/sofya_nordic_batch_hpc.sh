#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=24gb
#SBATCH --time=48:00:00
#SBATCH --array=0-1

module load matlab-uon/r2025a

FILELIST=/gpfs01/home/ppzma/sofya_nexpo_data/sofya_inputs.txt

mapfile -t PARAMS < "$FILELIST"

index=${SLURM_ARRAY_TASK_ID}
sindex=$index
param=${PARAMS[$sindex]}

echo "Job array ID: $SLURM_ARRAY_TASK_ID"
echo "Input file: $param"

dir=$(dirname "$param")
base=$(basename "$param")
newfilename=${base%.nii}
newfilename=${newfilename%.nii.gz}

echo "Directory: $dir"
echo "Filename without extension: $newfilename"

#matlab -nodisplay -nosplash -nodesktop -r \
#"addpath(genpath('/gpfs01/home/ppzma/matlab')); run_nordic_hpc('${param}'); quit"
