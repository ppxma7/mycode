#!/usr/bin/env bash

# List of subject IDs
subjects=(
  "16517"
  "16911"
  "16544"
  "13676"
  "16279"
  "12294"
  "10469"
  "09849"
  "17080_002"
  "17076_002"
  "16569_002"
  "18094_002"
  "18076_002"
  "18038_002"
  "17930_002"
  "18031_002"
  "14342_003"
)

# Remote and local base paths
remote_base="ppzma@hpclogin01.ada.nottingham.ac.uk:/spmstore/project/NEXPO/NEXPO/t1mapping_out/"
local_base="$HOME/data/NEXPO/t1mapping_out/"

# Make sure the local directory exists
# mkdir -p "$local_base"

# # Loop over each subject and rsync
# for subj in "${subjects[@]}"; do
#   echo "===== Syncing subject: $subj ====="
#   rsync -azv \
#     --include='*/' \
#     --include='stats/**' \
#     --exclude='*' \
#     "$remote_base/$subj" \
#     "$local_base/"
#   echo "===== Finished: $subj ====="
# done


for subj in "${subjects[@]}"; do
  echo "===== Syncing subject: $subj ====="
  rsync -azv \
    "$remote_base/$subj" \
    "$local_base/"
  echo "===== Finished: $subj ====="
done

echo "✅ All subjects synced."
