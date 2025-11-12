#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=12gb
#SBATCH --time=168:00:00

echo "Running on `hostname`"

module load extension/imaging/
module load brc-pipelines-img/1.7.2

# Directory
export DATA_DIR="/spmstore/project/SASHB/SASHB/inputs"  # Change to your actual data path
export OUTPUT_DIR="/spmstore/project/SASHB/SASHB/t1mapping_out"

# List of subjects (update as necessary)
#SUBJECT=("16905_004" "16905_005" "17880001" \
#          "17880002")
SUBJECT=("156862_004")

# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    python3 t1_mapping_longform_hpc.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
done

echo "Processing complete!"
