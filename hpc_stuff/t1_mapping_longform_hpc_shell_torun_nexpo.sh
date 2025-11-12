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
export DATA_DIR="/spmstore/project/NEXPO/NEXPO/inputs"  # Change to your actual data path
export OUTPUT_DIR="/spmstore/project/NEXPO/NEXPO/t1mapping_out"

# List of subjects (update as necessary)
SUBJECT=("14342_003" "18031_002" "17930_002" "18038_002" "18076_002" \
          "18094_002" "16569_002" "17076_002" "17080_002" \
	  "09849" "10469" "12294" "16279" "13676" "16544" "16911" "16517")

# SUBJECT=("16469-002A")

# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    python3 t1_mapping_longform_hpc.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
done

echo "Processing complete!"
