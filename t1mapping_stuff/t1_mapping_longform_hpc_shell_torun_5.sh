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
SUBJECT=("17395_002" "17449_002" "17453_002" "17456_002" "17491_002" "17492_002" "17532_002" "17577_002" "17580_002" "17581_002" \
         "17589_002" "17594_002" "17596_002" "17606_002" "17607_002" "17610_002" "17617_002" "17698_002" "17704_002" "17706_002" \
         "17723_002" "17765_002" "17769_002")


# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    python3 t1_mapping_longform_hpc.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
done

echo "Processing complete!"