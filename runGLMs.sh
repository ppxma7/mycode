#!/bin/bash

study=$1

for hemi in lh rh; do
  for smoothness in 10; do
    for meas in volume thickness; do
      # Start building the command
      cmd="mri_glmfit \
        --y ${hemi}.${meas}.${study}.${smoothness}.mgh \
        --fsgd FSGD/${study}.fsgd doss \
        --surf fsaverage ${hemi} \
        --cortex"

      # Append all contrast files
      for contrast in Contrasts/*.mtx; do
        cmd="${cmd} --C ${contrast}"
      done

      # Append output directory
      cmd="${cmd} --glmdir ${hemi}.${meas}.${study}.${smoothness}.glmdir"

      # Just print the full command (dry run)
      echo "$cmd"
      eval $cmd
    done
  done
done
