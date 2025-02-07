#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=12gb
#SBATCH --time=168:00:00

echo "Running on `hostname`"

module load extension/imaging/
module load brc-pipelines-img/1.6.6

export DATA_DIR="/imgshare/7tfmri/michael/project_test/AFIRM/inputs/"
export OUTPUT_DIR="/imgshare/7tfmri/michael/project_test/AFIRM/outputs/"

# List of subjects (update as necessary)
subjects=("16469-002A" "16500-002B" "16501-002b" \
          "16521-001b3" "16523_002b")

# Loop through each subject
for subject in "${subjects[@]}"; do
    # Define expected file paths
    T1_FILE=$(find "${DATA_DIR}/${subject}/MPRAGE/" -type f -iname "*MPRAGE*.nii" | head -n 1)
    T2_FILE=$(find "${DATA_DIR}/${subject}/FLAIR/" -type f -iname "*FLAIR*.nii" | head -n 1)
    
    # Check if both T1 and T2 files exist
    if [[ -f $T1_FILE && -f $T2_FILE ]]; then
        echo "Processing subject: $subject"
        echo "T1: $T1_FILE"
        echo "T2: $T2_FILE"

        # Run structural pipeline
        struc_preproc.sh --subject "$subject" --path "$OUTPUT_DIR" \
                         --input "$T1_FILE" --t2 "$T2_FILE" \
                         --subseg --nodefacing --regtype 3 --freesurfer --fastsurfer
    else
        echo "Skipping $subject: Missing required files."
        [[ ! -f $T1_FILE ]] && echo "  - Missing MPRAGE (T1) file."
        [[ ! -f $T2_FILE ]] && echo "  - Missing FLAIR (T2) file."
    fi
done

echo "Processing complete!"
