#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=12gb
#SBATCH --time=168:00:00

echo "Running on `hostname`"

module load extension/imaging/
module load brc-pipelines-img/1.6.6

export DATA_DIR="/gpfs01/home/ppzma/subjects_dir/inputs"  # Change to your actual data path
export OUTPUT_DIR="/gpfs01/home/ppzma/subjects_dir/outputs"

# List of subjects (update as necessary
#subjects=("03143_174" "05017_014" "06398_005" "09376_062" "10760_130" "12162_005" "12181_004" "12185_004" "12219_006" "12305_004" \
#         "12411_004" "12422_004" "12428_005" "12487_003" "12578_004" "12608_004" "12838_004" "12869_013" "12869_016" "12929_004" \
#         "12967_004" "12969_004" "13006_004" "13673_015" "14007_003" "15721_009" "15951_002" "15955_002" "15999_003" "16014_002" \
#         "16043_002" "16044_002" "16046_002" "16058_002" "16101_002" "16102_002" "16103_002" "16121_002" "16122_002" "16133_002" \
#         "16154_002" "16174_002" "16175_002" "16176_002" "16231_003" "16277_002" "16278_002" "16280_002" "16281_002" "16282_002" \
#         "16283_002" "16296_002" "16297_002" "16298_002" "16299_002" "16301_002" "16302_002" "16303_002" "16321_002" "16322_002" \
#         "16377_002" "16388_002" "16389_002" "16390_002" "16404_002" "16404_004" "16418_002" "16419_002" "16430_002" "16437_002" \
#         "16438_002" "16439_002" "16462_002" "16463_002" "16464_002" "16465_002" "16466_002" "16467_002" "16494_002" "16511_002" \
#         "16512_002" "16513_002" "16514_002" "16528_002" "16542_002" "16543_002" "16568_002" "16570_002" "16613_002" "16615_002" \

#subjects=("14342_003" "17930_002" "18031_002" "18038_002" "18076_002" "18094_002")
#subjects=("16911" "16544" "13676" "16517" "16279" "12294" "10469" "09849")
subjects=("14359")

# Loop through each subject
for subject in "${subjects[@]}"; do
    # Define expected file paths
    T1_FILE=$(find "${DATA_DIR}/${subject}/MPRAGE/" -type f -iname "*MPRAGE*.nii" | head -n 1)
    #T2_FILE=$(find "${DATA_DIR}/${subject}/FLAIR/" -type f -iname "*FLAIR*.nii" | head -n 1)
    
    # Check if both T1 and T2 files exist
    if [[ -f $T1_FILE ]]; then
        echo "Processing subject: $subject"
        echo "T1: $T1_FILE"
        #echo "T2: $T2_FILE"

        # Run structural pipeline
        struc_preproc.sh --subject "$subject" --path "$OUTPUT_DIR" \
                         --input "$T1_FILE" \
                         --subseg --nodefacing --regtype 3 --freesurfer --fastsurfer
    else
        echo "Skipping $subject: Missing required files."
        [[ ! -f $T1_FILE ]] && echo "  - Missing MPRAGE (T1) file."
        #[[ ! -f $T2_FILE ]] && echo "  - Missing FLAIR (T2) file."
    fi
done

echo "Processing complete!"
