#!/usr/bin/env bash

# -------- CONFIG --------
#SUBJECT="16789_002"
#MPRAGE_DIR="/Volumes/DRS-GBPerm/other/NEXPO_inputs/${SUBJECT}/MPRAGE"
#T1_DIR="/Volumes/DRS-GBPerm/other/t1mapping_out/${SUBJECT}"

# use these if calling as args
MPRAGE_DIR="$1"
T1_DIR="$2"
SUBJECT="$3"

MPRAGE_BRAIN="${MPRAGE_DIR}/${SUBJECT}_MPRAGE_brain.nii.gz"
T1MAP="${T1_DIR}/${SUBJECT}_T1_to_MPRAGE.nii.gz"
OUTPUT="${T1_DIR}/${SUBJECT}_T1_to_MPRAGE_noCSF.nii.gz"

# Check if already processed
if [[ -f "$OUTPUT" ]]; then
    echo "✅ $SUBJECT already processed, skipping."
    exit 0
fi

echo "🔹 Processing subject: $SUBJECT"

# -------- 1. Run FAST segmentation on MPRAGE --------
FAST_PREFIX="${MPRAGE_DIR}/${SUBJECT}_MPRAGE_brain"
if [[ ! -f "${FAST_PREFIX}_pve_0.nii.gz" ]]; then
    echo "🧠 Running FAST segmentation..."
    fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -o "$FAST_PREFIX" "$MPRAGE_BRAIN"
else
    echo "ℹ️ FAST outputs already exist, skipping segmentation."
fi

# -------- 2. Create GM+WM mask (exclude CSF) --------
PVE0="${FAST_PREFIX}_pve_0.nii.gz"  # CSF
PVE1="${FAST_PREFIX}_pve_1.nii.gz"  # GM
PVE2="${FAST_PREFIX}_pve_2.nii.gz"  # WM
MASK="${FAST_PREFIX}_gmwm_mask.nii.gz"


if [[ ! -f "$MASK" ]]; then
    echo "🧰 Creating GM+WM mask..."
    # Erode CSF map to shrink it
    fslmaths "$PVE0" -ero "$PVE0"_ero
    # Subtract CSF (eroded) from total brain tissue
    fslmaths "$PVE1" -add "$PVE2" -sub "$PVE0"_ero -thr 0.2 -bin "$MASK"
    #fslmaths "$PVE1" -add "$PVE2" -thr 0.2 -bin "$MASK"
else
    echo "ℹ️ GM+WM mask already exists."
fi

# -------- 3. Apply mask to T1 map --------
echo "✂️ Removing CSF from T1 map..."
fslmaths "$T1MAP" -mas "$MASK" "$OUTPUT"

echo "✅ Finished $SUBJECT"
echo "👉 Output: $OUTPUT"
