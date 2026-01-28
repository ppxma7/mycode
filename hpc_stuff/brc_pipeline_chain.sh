#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=12gb
#SBATCH --time=168:00:00

echo "Running on `hostname`"

module load extension/imaging/
module load brc-pipelines-img/1.7.2

export DATA_DIR="/gpfs01/home/ppzma/chain_mprage/inputs/"
export OUTPUT_DIR="/gpfs01/home/ppzma/chain_mprage/outputs/"

# subjects=("CHN001_V6_C" "CHN002_V6_C" "CHN003_V6_C" \
# "CHN005_v6_redo_C" "CHN006_V6_C" "CHN007_V6_C" \
# "CHN008_V6_DTI_C" "CHN009_V6_C" "CHN010_V6_2_DTI_C" "CHN012"\
# "CHN013_v6_classic" "CHN014_V6_DTI_C" "CHN015_V6_DTI_C" \
# "CHN019_V6_C")


subjects=("CHN001_V6" "CHN001_V13" "CHN001_V20" "CHN001_V33" \
"CHN002_V6" "CHN002_v13" "CHN002_v20" "CHN002_V33" \
"CHN003_V6" "CHN003_V13" "CHN003_V20_E" "CHN005_v6_redo" \
"CHN005_v13" "CHN006_V6" "CHN006_V13" "CHN006_v20_E" \
"CHN006_V33E" "CHN007_V6" "CHN007_v13" "CHN007_V20" \
"CHN007_V33" "CHN008_V6" "CHN008_V13" "CHN008_V20" \
"CHN008_V33" "CHN009_V6" "CHN009_V13" "CHN009_v20" \
"CHN009_V33" "CHN010_v6_classic" "CHN010_V13" "CHN010_V20_E" \
"CHN010_v33" "CHN012_V6" "CHN013_v6" "CHN013_v13" "CHN013_V20_C" \
"CHN013_v33" "CHN014_V6" "CHN014_V13_E" "CHN014_v20" "CHN014_v33" \
"CHN015_V6" "CHN015_V13_classic" "CHN015_v20_E" "CHN015_v33" \
"CHN019_V6" "CHN019_V13" "CHN019_V20")

# Loop through each subject
for subject in "${subjects[@]}"; do
    # Define expected file paths
    T1_FILE=$(find "${DATA_DIR}/${subject}/MPRAGE/" -type f -iname "*MPRAGE*.nii" | head -n 1)
    T2_FILE=$(find "${DATA_DIR}/${subject}/FLAIR/" -type f -iname "*FLAIR*.nii" | head -n 1)
    
    # Check if both T1 and T2 files exist
    if [[ -f $T1_FILE ]]; then
        echo "Processing subject: $subject"
        echo "T1: $T1_FILE"
        echo "T2: $T2_FILE"

        # Run structural pipeline
        struc_preproc.sh --subject "$subject" --path "$OUTPUT_DIR" \
                         --input "$T1_FILE" --t2 "$T2_FILE" \
                         --subseg --nodefacing --regtype 3 --freesurfer
    else
        echo "Skipping $subject: Missing required files."
        [[ ! -f $T1_FILE ]] && echo "  - Missing MPRAGE (T1) file."
        [[ ! -f $T2_FILE ]] && echo "  - Missing FLAIR (T2) file."
    fi
done

echo "Processing complete!"