#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=12gb
#SBATCH --time=168:00:00

echo "Running on $(hostname)"

module load extension/imaging/
module load brc-pipelines-img/1.6.6
module load freesurfer-img/7.4.1
module load fastsurfer-img/2.0

# point FREESURFER_HOME if not already set by the module
if [ -e "${FREESURFER_HOME}/SetUpFreeSurfer.sh" ]; then
    source "${FREESURFER_HOME}/SetUpFreeSurfer.sh"
fi

export OUTPUT_DIR="/spmstore/project/SASHB/SASHB/outputs/"

# your full subject list here

subjects=("16905_004" "16905_005" "17880001" "17880002")

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
