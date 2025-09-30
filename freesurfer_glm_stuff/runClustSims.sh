#!/bin/bash

study=$1

for meas in thickness volume; do
  for hemi in lh rh; do
    for smoothness in 10; do
      dir="${hemi}.${meas}.${study}.${smoothness}.glmdir"
      mri_glmfit-sim \
        --glmdir "${dir}" \
        --cache 3 neg \
        --cwp 0.05 \
        --2spaces
    done
  done
done
