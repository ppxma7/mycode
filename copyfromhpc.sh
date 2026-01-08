#!/usr/bin/env bash

subjects=(
  "CHN001_V6_C"
  "CHN002_V6_C"
  "CHN003_V6_C"
  "CHN005_v6_redo_C"
  "CHN006_V6_C"
  "CHN007_V6_C"
  "CHN008_V6_DTI_C"
  "CHN009_V6_C"
  "CHN010_V6_2_DTI_C"
  "CHN012"
  "CHN013_v6_classic"
  "CHN014_V6_DTI_C"
  "CHN015_V6_DTI_C"
  "CHN019_V6_C"
)


remote_root="ppzma@hpclogin01.ada.nottingham.ac.uk:/gpfs01/home/ppzma/chain_dti/outputs"
local_root="/Volumes/DRS-GBPerm/other/outputs"

for subj in "${subjects[@]}"; do
  echo "===== Syncing T2 for subject: $subj ====="

  # Ensure local parent exists
  mkdir -p "$local_root/$subj/analysis/anatMRI"

  rsync -avz \
    "$remote_root/$subj/analysis/anatMRI/T2/" \
    "$local_root/$subj/analysis/anatMRI/T2/"

  echo "===== Finished: $subj ====="
done

echo "All subjects synced."
