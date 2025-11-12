#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=12gb
#SBATCH --time=168:00:00

echo "Running on `hostname`"

module load extension/imaging/
module load brc-pipelines-img/1.6.6

export DATA_DIR="/imgshare/7tfmri/michael/ibd_subs/inputs/"
export OUTPUT_DIR="/imgshare/7tfmri/michael/ibd_subs/surfaces/"
output_folder="${OUTPUT_DIR}"

# Define the list of subjects
# subjects=("sub01" "sub02" "sub03" "sub04" "sub06" "sub07" "sub08" \
#   "sub09" "sub10")  # Add all subject IDs as needed


subjects=("001_H08" "BL018" "BL016" "BL017" "BL012" "BL013" "BL014" \
  "BL015" "BL010" "BL011" "BL007" "BL008" "BL003" "BL004" "BL005" \
  "BL006" "004_P01" "BL002" "001_P44" "001_P45" "001_P42" "001_P43" \
  "001_P35" "001_P37" "001_P40" "001_P41" "001_P32" "001_P33" "001_P30" \
  "001_P31" "001_P27" "001_P28" "001_P22" "001_P23" "001_P24" "001_P26" \
  "001_P20" "001_P21" "001_P18" "001_P19" "001_P16" "001_P17" "001_P08" \
  "001_P12" "001_P13" "001_P15" "001_P05" "001_P06" "001_P02" "001_P04" \
  "001_H30" "001_P01" "001_H25" "001_H27" "001_H28" "001_H29" "001_H23" \
  "001_H24" "001_H17" "001_H19" "001_H15" "001_H16" "001_H09" "001_H11" \
  "001_H13" "001_H14" "001_H03" "001_H07")

#struc_preproc.sh --subject Sub_001 --path /home/data/ --input /home/data/T1.nii.gz --t2 /home/data/T2.nii.gz --subseg --nodefacing --regtype 3 --freesurfer --fastsurfer

# Loop through each subject and run the command
for subject in "${subjects[@]}"; do
  #input_file="${DATA_DIR}/${subject}_mprage.nii"
  input_file="${DATA_DIR}/${subject}.nii"
  
  echo $input_file
  echo $subject
  echo $output_folder

  #struc_preproc.sh --subject "$subject" --path "$output_folder" --input "$input_file" --subseg --nodefacing --regtype 3 --freesurfer --fastsurfer
  struc_preproc.sh --subject "$subject" --path "$output_folder" --input "$input_file" --subseg --nodefacing --regtype 3 
done

echo done
