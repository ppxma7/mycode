#!/bin/bash

export SUBJECTS_DIR=/Volumes/DRS-GBPerm/other/outputs/
for s in $(cat aseg_stats_list_justchain.txt); do
  mri_segstats \
    --seg $SUBJECTS_DIR/$s/mri/aseg.mgz \
    --sum aseg_${s}.stats
done