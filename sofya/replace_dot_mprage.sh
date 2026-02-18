#!/usr/bin/env bash
# Michael Asghar 2026

for sub in /Volumes/kratos/SOFYA/melodic_analysis/*/structural/; do
    for f in "$sub"*MPRAGE*.nii.gz; do
        base="${f%.nii.gz}"
        ext=".nii.gz"
        newname="${base//./p}$ext"
        mv "$f" "$newname"
    done
done
