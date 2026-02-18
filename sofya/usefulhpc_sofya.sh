#!/bin/bash
# Michael Asghar 2026

SUBS=(16662 16728 16775 16788 16910 17324 17449 17581 17589 17610)
DEST="/Volumes/kratos/SOFYA/melodic_analysis/"

for s in "${SUBS[@]}"; do
    rsync -azvR "ppzma@hpclogin01.ada.nottingham.ac.uk:/spmstore/project/NEXPO/RESTING_STATE/output/${s}/structural/*MPRAGE*.nii.gz" "$DEST"
done
