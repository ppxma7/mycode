#!/bin/bash

export SUBJECTS_DIR=$(pwd)


echo "subject,atlas_icv" > icv_values.csv
for subj in $(ls $SUBJECTS_DIR); do
  if [ -d "$SUBJECTS_DIR/$subj/mri" ]; then
    icv=$(mri_segstats --subject "$subj" --etiv-only | grep atlas_icv | awk '{print $4}')
    echo "$subj,$icv" >> icv_values.csv
  fi
done

