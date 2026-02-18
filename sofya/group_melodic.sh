#!/bin/bash
# Michael Asghar 2026

set -e

# -------- SETTINGS --------
ROOT=/Volumes/kratos/SOFYA/melodic_analysis
SUBS=(16662 16728)        # <- your test subjects
OUTDIR=$ROOT/groupICA_test
TR=1.5

mkdir -p $OUTDIR
cd $OUTDIR

echo "---- Collect masks ----"
mask_list=""
func_list=""

for s in "${SUBS[@]}"; do

    #FUNC=$(ls $ROOT/$s/outputs/*_brain_mc_MNI.nii.gz)
    FUNC=$(ls $ROOT/$s/outputs/${s}.ica/filtered_func_data_clean.nii.gz)
    MASK=$(ls $ROOT/$s/outputs/*_brain_mc_MNI_mean_mask.nii.gz)

    echo "Found $s"
    echo "  func: $FUNC"
    echo "  mask: $MASK"

    func_list="$func_list $FUNC"
    mask_list="$mask_list $MASK"
done


echo "---- Build group mask ----"
fslmerge -t all_masks $mask_list
fslmaths all_masks -Tmean -thr 0.8 -bin group_mask


echo "---- Concatenate subjects ----"
fslmerge -t group_func $func_list


echo "---- Run MELODIC ----"
melodic \
    -i group_func.nii.gz \
    -o melodic_output \
    --mask=group_mask.nii.gz \
    --tr=$TR \
    --nobet \
    --report \
    --Oall

echo "DONE"
