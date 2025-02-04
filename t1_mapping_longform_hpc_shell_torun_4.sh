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
SUBJECT=("17007_002" "17038_002" "17040_002" "17041_002" "17072_002" "17073_002" "17074_002" "17075_002" "17083_002" "17084_002" \
         "17086_002" "17102_002" "17103_002" "17104_002" "17105_002" "17108_002" "17111_002" "17127_002" "17128_002" "17129_002" \
         "17171_002" "17173_002" "17176_002" "17178_002" "17180_002" "17207_003" "17208_002" "17210_002" "17221_002" "17239_002" \
         "17243_002" "17275_002" "17293_002" "17305_002" "17324_002" "17341_002" "17342_002" "17348_002" "17364_002" "17394_002")


# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    python3 t1_mapping_longform_hpc.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
done

echo "Processing complete!"