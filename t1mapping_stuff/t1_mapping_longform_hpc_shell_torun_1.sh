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
# SUBJECT=("03143_174" "05017_014" "06398_005" "09376_062" "10760_130" "12162_005" "12181_004" "12185_004" "12219_006" "12305_004" \
#          "12411_004" "12422_004" "12428_005" "12487_003" "12578_004" "12608_004" "12838_004" "12869_013" "12869_016" "12929_004" \
#          "12967_004" "12969_004" "13006_004" "13673_015" "14007_003" "15721_009" "15951_002" "15955_002" "15999_003" "16014_002" \
#          "16043_002" "16044_002" "16046_002" "16058_002" "16101_002" "16102_002" "16103_002" "16121_002" "16122_002" "16133_002")

SUBJECTS=("16044_002" "16043_002" "15721_009" "12967_004" "12869_013" "12428_005" "12422_004" \
    "10760_130" "16437_002" "16430_002" "16322_002" "16302_002" "16282_002" "16281_002" "16231_003" \
    "16174_002" "16154_002" "16871_002" "16793_006" "16725_002" "16664_002" "16662_002" "16615_002" \
    "16613_002" "17341_002" "17305_002" "17293_002" "17243_002" "17041_002" "17038_002" "17706_002" \
    "17698_002" "17617_002" "17532_002" "17492_002" "17491_002" "17456_002")

# Loop through each subject
for subject in "${SUBJECT[@]}"; do
    python3 /gpfs01/home/ppzma/code/t1_mapping_longform_hpc.py -d "$DATA_DIR" -o "$OUTPUT_DIR" -s "$subject"
done

echo "Processing complete!"