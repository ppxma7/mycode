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
SUBJECT=("03143_174" "05017_014" "06398_005" "09376_062" "10760_130" "12162_005" "12181_004" "12185_004" "12219_006" "12305_004" \
         "12411_004" "12422_004" "12428_005" "12487_003" "12578_004" "12608_004" "12838_004" "12869_013" "12869_016" "12929_004" \
         "12967_004" "12969_004" "13006_004" "13673_015" "14007_003" "15721_009" "15951_002" "15955_002" "15999_003" "16014_002" \
         "16043_002" "16044_002" "16046_002" "16058_002" "16101_002" "16102_002" "16103_002" "16121_002" "16122_002" "16133_002")


# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    python3 t1_mapping_longform_hpc.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
done

echo "Processing complete!"