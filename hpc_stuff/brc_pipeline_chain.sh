#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=12gb
#SBATCH --time=168:00:00

echo "Running on `hostname`"

module load extension/imaging/
module load brc-pipelines-img/1.7.2

export DATA_DIR="/gpfs01/home/ppzma/chain_dti/inputs/"
export OUTPUT_DIR="/gpfs01/home/ppzma/chain_dti/outputs/"

subjects=("CHN001_V6_C" "CHN002_V6_C" "CHN003_V6_C" \
"CHN005_v6_redo_C" "CHN006_V6_C" "CHN007_V6_C" \
"CHN008_V6_DTI_C" "CHN009_V6_C" "CHN010_V6_2_DTI_C" "CHN012"\
"CHN013_v6_classic" "CHN014_V6_DTI_C" "CHN015_V6_DTI_C" \
"CHN019_V6_C")

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