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
SUBJECT=("16512_002" "16513_002" "16514_002" "16528_002" "16542_002" "16543_002" "16568_002" "16570_002" "16613_002" "16615_002" \
         "16618_002" "16621_002" "16623_002" "16627_002" "16661_002" "16662_002" "16663_002" "16664_002" "16693_002" "16699_002" \
         "16701_002" "16702_002" "16725_002" "16726_002" "16728_005" "16775_002" "16787_002" "16788_002" "16789_002" "16791_002" \
         "16793_006" "16824_002" "16866_002" "16871_002" "16874_002" "16878_002" "16910_002" "16985_002" "16986_002" "16987_002")


# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    python3 t1_mapping_longform_hpc.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
done

echo "Processing complete!"