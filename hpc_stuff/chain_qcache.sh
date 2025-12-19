#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=12gb
#SBATCH --time=168:00:00

echo "Running on $(hostname)"

module load extension/imaging/
module load brc-pipelines-img/1.7.2
module load freesurfer-img/7.4.1
module load fastsurfer-img/2.0

# point FREESURFER_HOME if not already set by the module
if [ -e "${FREESURFER_HOME}/SetUpFreeSurfer.sh" ]; then
    source "${FREESURFER_HOME}/SetUpFreeSurfer.sh"
fi

export OUTPUT_DIR="/gpfs01/home/ppzma/chain_dti/outputs/"

# your full subject list here

subjects=("CHN001_V6_C" "CHN002_V6_C" "CHN003_V6_C" \
"CHN005_v6_redo_C" "CHN006_V6_C" "CHN007_V6_C" \
"CHN008_V6_DTI_C" "CHN009_V6_C" "CHN010_V6_2_DTI_C" "CHN012"\
"CHN013_v6_classic" "CHN014_V6_DTI_C" "CHN015_V6_DTI_C" \
"CHN019_V6_C")

for subject in "${subjects[@]}"; do
    # this is where your existing FS output lives
    FS_OUT_DIR="${OUTPUT_DIR}/${subject}/analysis/anatMRI/T1/processed/FreeSurfer"
    echo "Checking ${FS_OUT_DIR} …"

    # make sure the folder exists and recon-all finished
    if [[ -d "${FS_OUT_DIR}" ]] && [[ -f "${FS_OUT_DIR}/scripts/recon-all.done" ]]; then
        # recon-all wants:   -sd <parent-of-subject-dir>   -s <subject-dir-name>
        PARENT_DIR="$(dirname "${FS_OUT_DIR}")"
        SUBJ_DIRNAME="$(basename "${FS_OUT_DIR}")"   # here this will be "FreeSurfer"

        echo "  → Running qcache on ${FS_OUT_DIR}"
        recon-all \
          -sd "${PARENT_DIR}" \
          -s  "${SUBJ_DIRNAME}" \
          -qcache
    else
        echo "  → Skipping ${subject}:"
        [[ ! -d "${FS_OUT_DIR}" ]]       && echo "       * no FreeSurfer folder"
        [[ -f "${FS_OUT_DIR}" ]] && \
        [[ ! -f "${FS_OUT_DIR}/scripts/recon-all.done" ]] && \
            echo "       * recon-all not complete"
    fi
done

echo "All done!"
