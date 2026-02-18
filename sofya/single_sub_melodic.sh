#!/bin/bash
# Single-subject MELODIC + FIX
set -e

ROOT=/Volumes/kratos/SOFYA/melodic_analysis
SUBS=(16662 16728)
TR=1.5
MODEL=Standard
THRESH=20

for s in "${SUBS[@]}"; do
    echo "=============================="
    echo "Processing subject $s"
    echo "=============================="

    SUBDIR=$ROOT/$s/outputs
    STRUCT=$ROOT/$s/structural

    FUNC=$(ls $SUBDIR/*_brain_mc_MNI.nii.gz)
    ICADIR=$SUBDIR/${s}.ica
    
    # ---- Run MELODIC if not done ----
    if [ ! -d "$ICADIR" ]; then
        echo "Running MELODIC..."
        melodic \
            -i $FUNC \
            -o $ICADIR \
            --tr=$TR \
            --nobet \
            --report
    else
        echo "MELODIC already exists — skipping"
    fi

    # ---- Skip FIX if already done ----
    if [ -f "$ICADIR/filtered_func_data_clean.nii.gz" ]; then
        echo "FIX already run — skipping"
    else

        # ---- ) Reorganize .ica folder for FIX ----
        mkdir -p $ICADIR/filtered_func_data.ica
        mkdir -p $ICADIR/mc
        mkdir -p $ICADIR/reg

        echo "Moving melodic outputs into filtered_func_data.ica..."
        mv $ICADIR/melodic_* $ICADIR/filtered_func_data.ica/ 2>/dev/null || true

        echo "Copying 4D BOLD..."
        cp $FUNC $ICADIR/filtered_func_data.nii.gz

        echo "Copying mean and mask..."
        MEAN=$(ls $SUBDIR/*_MNI_mean.nii.gz)
        MASK=$(ls $SUBDIR/*_MNI_mean_mask.nii.gz)
        cp $MEAN $ICADIR/mean_func.nii.gz
        cp $MASK $ICADIR/mask.nii.gz

        echo "Setting example_func..."
        cp $ICADIR/mean_func.nii.gz $ICADIR/reg/example_func.nii.gz

        echo "Copying structural..."
        T1=$(ls $STRUCT/*optibrain.nii.gz)
        cp $T1 $ICADIR/reg/highres.nii.gz

        echo "Setting FLIRT transform..."
        FLIRTMAT=$(ls $SUBDIR/*_fMRI2MNI.mat 2>/dev/null || echo "")
        if [ -f "$FLIRTMAT" ]; then
            cp $FLIRTMAT $ICADIR/reg/highres2example_func.mat
        else
            flirt -in $T1 -ref $ICADIR/filtered_func_data.nii.gz -omat $ICADIR/reg/highres2example_func.mat
        fi

        echo "Copying motion parameters..."
        PAR=$(ls $SUBDIR/*_brain_mc.par)
        cp $PAR $ICADIR/mc/prefiltered_func_data_mcf.par
        
        # ---- Run FIX ----
        echo "Running FIX..."
        TRAINING_FILE="/usr/local/fsl/lib/python3.12/site-packages/pyfix/resources/models"

        fix $ICADIR $TRAINING_FILE/$MODEL.pyfix_model $THRESH

        echo "Subject $s DONE"
    fi


done
