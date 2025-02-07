#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=12gb
#SBATCH --time=168:00:00

echo "Running on `hostname`"

module load extension/imaging/
module load brc-pipelines-img/1.6.6

# Directory
export DATA_DIR="/spmstore/project/SASHB/NEXPO/inputs"  # Change to your actual data path
export OUTPUT_DIR="/spmstore/project/SASHB/NEXPO/t1mapping_out"

# List of subjects (update as necessary)
SUBJECT=("16154_002" "16174_002" "16175_002" "16176_002" "16231_003" "16277_002" "16278_002" "16280_002" "16281_002" "16282_002" \
         "16283_002" "16296_002" "16297_002" "16298_002" "16299_002" "16301_002" "16302_002" "16303_002" "16321_002" "16322_002" \
         "16377_002" "16388_002" "16389_002" "16390_002" "16404_002" "16404_004" "16418_002" "16419_002" "16430_002" "16437_002" \
         "16438_002" "16439_002" "16462_002" "16463_002" "16464_002" "16465_002" "16466_002" "16467_002" "16494_002" "16511_002")

# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    python3 t1_mapping_longform_hpc.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
done

echo "Processing complete!"