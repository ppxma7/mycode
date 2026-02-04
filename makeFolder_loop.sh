#!/bin/bash
set -e
shopt -s nullglob

ROOT=$(pwd)

for subj in */; do
    [[ -d "$subj" ]] || continue

    echo "===================================="
    echo "▶ Processing: ${subj%/}"
    echo "===================================="

    cd "$subj" || continue

    # ---- Create directories ----
    [[ -d MPRAGE ]] || mkdir MPRAGE
    [[ -d FLAIR  ]] || mkdir FLAIR

    # ---- Move MPRAGE ----
    mprage_files=( *MPRAGE*.nii *MPRAGE*.json )
    if (( ${#mprage_files[@]} )); then
        echo "📦 Moving ${#mprage_files[@]} MPRAGE files"
        mv -i "${mprage_files[@]}" MPRAGE/
    else
        echo "⚠️ No MPRAGE files found"
    fi

    # ---- Move T2 FLAIR ----
    flair_files=( *FLAIR*.nii *FLAIR*.json )
    if (( ${#flair_files[@]} )); then
        echo "📦 Moving ${#flair_files[@]} FLAIR files"
        mv -i "${flair_files[@]}" FLAIR/
    else
        echo "⚠️ No FLAIR files found"
    fi

    cd "$ROOT"
done

shopt -u nullglob
echo "✅ MPRAGE and T2-FLAIR organisation complete."
