#!/bin/bash


for s in $(cat aseg_stats_list.txt); do
  mri_segstats \
    --seg $SUBJECTS_DIR/$s/mri/aseg.mgz \
    --sum aseg_${s}.stats
done