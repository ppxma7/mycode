#!/usr/bin/env bash

for sub in /Volumes/kratos/SOFYA/melodic_analysis/*/structural/; do
    for f in "$sub"*MPRAGE*.nii.gz; do
        base="${f%.nii.gz}"
        ext=".nii.gz"
        newname="${base//./p}$ext"
        mv "$f" "$newname"
    done
done
