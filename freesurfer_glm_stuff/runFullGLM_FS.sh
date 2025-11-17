#!/bin/bash

#study=$1
study=SASHBStudy_prevpost
export SUBJECTS_DIR=$(pwd)

echo $study
#exit 0

for hemi in lh rh; do
  for smoothing in 10; do
    for meas in volume thickness; do
      mris_preproc --fsgd FSGD/${study}.fsgd \
        --cache-in ${meas}.fwhm${smoothing}.fsaverage \
        --target fsaverage \
        --hemi ${hemi} \
        --out ${hemi}.${meas}.${study}.${smoothing}.mgh
    done
  done
done

echo "MRI preproc complete"
sleep 5

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

echo "GLM complete"
sleep 5


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

for meas in thickness volume; do
  for hemi in lh rh; do
    for smoothness in 10; do
      dir="${hemi}.${meas}.${study}.${smoothness}.glmdir"
      mri_glmfit-sim \
        --glmdir "${dir}" \
        --cache 3 pos \
        --cwp 0.05 \
        --2spaces
    done
  done
done

echo "Clust sim complete"
