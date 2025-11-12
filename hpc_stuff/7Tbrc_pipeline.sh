#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=12gb
#SBATCH --time=100:00:00

echo "Running on `hostname`"

module load extension/imaging/
module load brc-pipelines-img/1.6.6

export DATA_DIR="/gpfs01/home/ppzma/caitlinFS/7T/"
export OUTPUT_DIR="/gpfs01/home/ppzma/caitlinFS/surfaces/"
output_folder="${OUTPUT_DIR}"

# Define the list of subjects
#subjects=("Map01" "Map02" "Map03" "Map04" "Map05" "Map06" "Map07" "Map08" "Map09" "Map10" "Map11" "Map13" "Map14" "Map28" "TS087" "TS275" "TS279" "TS294" "TS308" "TS310" "TS313" "TS321" "TS322")  # Add all subject IDs as needed
#7T subjects "Map01" "Map02" "Map03" "Map04" "Map05" "Map06" "Map07" "Map08" "Map09" "Map10" "Map11" "Map13" "Map14" "Map28" "TS087" "TS275" "TS279" "TS294" "TS308" "TS310" "TS313" "TS321" "TS322"
subjects=("Map01")
#struc_preproc.sh --subject Sub_001 --path /home/data/ --input /home/data/T1.nii.gz --t2 /home/data/T2.nii.gz --subseg --nodefacing --regtype 3 --freesurfer --fastsurfer

# Loop through each subject and run the command
for subject in "${subjects[@]}"; do
  input_file="${DATA_DIR}/${subject}_PSIR.nii.gz"
  
  echo $input_file
  echo $subject
  echo $output_folder

  struc_preproc.sh --subject "$subject" --path "$output_folder" --input "$input_file" --subseg --nodefacing --regtype 3 --freesurfer --fastsurfer
done

echo done
