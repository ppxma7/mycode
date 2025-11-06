#!/bin/bash
shopt -s nullglob extglob

# === Create directories if they don't exist ===
dirs=("json" "magnitude" "phase" "parrec" "structurals" "DTI" "qa_outputs" "spm_analysis")
for dir in "${dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "Directory '$dir' already exists. Skipping creation."
    else
        mkdir "$dir" && echo "Directory '$dir' created."
    fi
done


# === Move JSON files ===
json_files=( *.json )
if (( ${#json_files[@]} )); then
    echo "Moving ${#json_files[@]} JSON files..."
    mv -i "${json_files[@]}" json/
else
    echo "No JSON files to move."
fi


# === Move structural and DTI NIFTIs ===
for prefix in MPRAGE FLAIR DTI; do
    struct_files=( *${prefix}*.nii *${prefix}*.nii.gz )
    if (( ${#struct_files[@]} )); then
        echo "Moving ${#struct_files[@]} ${prefix} files..."
        mv -i "${struct_files[@]}" "$( [[ $prefix == DTI ]] && echo DTI || echo structurals )"/
    else
        echo "No ${prefix} files to move."
    fi
done


# === Move phase files (_ph.nii or _ph.nii.gz) ===
phase_files=(*_ph.nii *_ph.nii.gz)
if (( ${#phase_files[@]} )); then
    echo "Moving ${#phase_files[@]} phase files..."
    mv -i "${phase_files[@]}" phase/
else
    echo "No phase files to move."
fi


# === Move magnitude files (everything else .nii/.nii.gz, excluding _ph) ===
mag_files=(!(*_ph).nii !(*_ph).nii.gz)
if (( ${#mag_files[@]} )); then
    echo "Moving ${#mag_files[@]} magnitude files..."
    mv -i "${mag_files[@]}" magnitude/
else
    echo "No magnitude files to move."
fi


# === Move PAR/REC files ===
for ext in PAR REC; do
    pr_files=( *.${ext} )
    if (( ${#pr_files[@]} )); then
        echo "Moving ${#pr_files[@]} ${ext} files..."
        mv -i "${pr_files[@]}" parrec/
    else
        echo "No ${ext} files to move."
    fi
done

shopt -u nullglob extglob
