#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=12gb
#SBATCH --time=168:00:00

echo "Running on $(hostname)"

MOUNT="/imgshare/7tfmri/michael"

module load extension/imaging/
module load spm12-img/default
module load conn-img/22a
module load matlab-uon/r2022a  # Load MATLAB module

if [ $? -ne 0 ]; then
  echo "Failed to load MATLAB module"
  exit 1
fi

# Run the MATLAB script
#matlab -nodisplay -nosplash -r "run('${MOUNT}/conn_resting_state_separate_visits_preproc.m'); exit;"

matlab -nodisplay -nosplash -r "run('${MOUNT}/conn_resting_state_separate_visits_denoise.m'); exit;"


