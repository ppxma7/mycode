#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=8g
#SBATCH --time=168:00:00

echo "Running on `hostname`"

module load extension/imaging/
module load brc-pipelines-img/1.7.2

export DATA_DIR="/gpfs01/home/ppzma/chain_dti/inputs/"
export OUTPUT_DIR="/gpfs01/home/ppzma/chain_dti/outputs/"


# subjects=("CHN002_V6" "CHN003_V6" "CHN005_V6" "CHN006_V6" \
# "CHN007_V6" "CHN008_V6" "CHN009_V6" "CHN010_V6" "CHN012_V6" \
# "CHN013_V6" "CHN014_V6" "CHN015_V6" "CHN019_V6")

subjects=("CHN001_V6_C" "CHN002_V6_C" "CHN003_V6_C" \
"CHN005_v6_redo_C" "CHN006_V6_C" "CHN007_V6_C" \
"CHN008_V6_DTI_C" "CHN009_V6_C" "CHN010_V6_2_DTI_C" \
"CHN013_v6_classic" "CHN014_V6_DTI_C" "CHN015_V6_DTI_C" \
"CHN019_V6_C")


for subject in "${subjects[@]}"; do
    echo "==========================================="
    echo "Processing subject: ${subject}"

    # Find files
    DTI_FILE=$(find "${DATA_DIR}/${subject}/DTI/" -type f -iname "*_WIP_MB3_sDTI_SPMICopt_*.nii*" ! -iname "*_ph.nii" | head -n 1)
    BLIP_FILE=$(find "${DATA_DIR}/${subject}/DTI/" -type f -iname "*_WIP_blipMB3_sDTI_SPMICopt_*.nii*" ! -iname "*_ph.nii" | head -n 1)

    # Validate presence of files
    if [[ -z "$DTI_FILE" ]]; then
        echo "❌ ERROR: No DTI file found for ${subject}, skipping."
        continue
    fi
    if [[ -z "$BLIP_FILE" ]]; then
        echo "⚠️ WARNING: No BLIP file found for ${subject}, using NONE."
        BLIP_FILE="NONE"
    fi

    echo "  DTI_FILE : ${DTI_FILE}"
    echo "  BLIP_FILE: ${BLIP_FILE}"

    # Run pipeline
    dMRI_preproc.sh \
        --input "${DTI_FILE}" \
        --input_2 "${BLIP_FILE}" \
        --path "${OUTPUT_DIR}" \
        --subject "${subject}" \
        --echospacing 0.00044 \
        --pe_dir 2
done

echo "All done."


