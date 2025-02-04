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
export DATA_DIR="/spmstore/project/SASHB/inputs"  # Change to your actual data path
export OUTPUT_DIR="/spmstore/project/SASHB/t1mapping_out"

# List of subjects (update as necessary)
# SUBJECT=("16469-002A" "16500-002B" "16501-002b" \
#           "16521-001b3" "16523_002b")

SUBJECT=("16905_004" "16905_005" "17880001" \
         "17880002")

# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    python3 /gpfs01/home/ppzma/code/register_t1_to_mni_standalone.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
done

echo "Processing complete!"