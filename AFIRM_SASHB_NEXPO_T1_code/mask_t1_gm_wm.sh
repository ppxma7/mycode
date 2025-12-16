#!/usr/bin/env bash

# -------- CONFIG --------
# Args
MPRAGE_DIR="$1"
T1_DIR="$2"
SUBJECT="$3"

MPRAGE_BRAIN="${MPRAGE_DIR}/${SUBJECT}_MPRAGE_brain.nii.gz"
FAST_PREFIX="${MPRAGE_DIR}/${SUBJECT}_MPRAGE_brain"

T1MAP="${T1_DIR}/${SUBJECT}_T1_to_MPRAGE.nii.gz"

# Outputs
OUTPUT_GM="${T1_DIR}/${SUBJECT}_T1_to_MPRAGE_GM.nii.gz"
OUTPUT_WM="${T1_DIR}/${SUBJECT}_T1_to_MPRAGE_WM.nii.gz"

PVE1="${FAST_PREFIX}_pve_1.nii.gz"  # GM
PVE2="${FAST_PREFIX}_pve_2.nii.gz"  # WM


echo "🔹 Processing subject: $SUBJECT"

# -------- Sanity checks --------
for f in "$T1MAP" "$PVE1" "$PVE2"; do
    if [[ ! -f "$f" ]]; then
        echo "❌ Missing required file: $f"
        exit 1
    fi
done

# -------- GM mask --------
if [[ ! -f "$OUTPUT_GM" ]]; then
    echo "🧠 Creating GM-masked T1..."
    fslmaths "$PVE1" -thr 0.5 -bin tmp_gm_mask
    fslmaths "$T1MAP" -mas tmp_gm_mask "$OUTPUT_GM"
else
    echo "ℹ️ GM-masked T1 already exists, skipping."
fi

# -------- WM mask --------
if [[ ! -f "$OUTPUT_WM" ]]; then
    echo "🧠 Creating WM-masked T1..."
    fslmaths "$PVE2" -thr 0.5 -bin tmp_wm_mask
    fslmaths "$T1MAP" -mas tmp_wm_mask "$OUTPUT_WM"
else
    echo "ℹ️ WM-masked T1 already exists, skipping."
fi

echo "✅ Finished $SUBJECT"
echo "👉 Outputs:"
echo "   GM: $OUTPUT_GM"
echo "   WM: $OUTPUT_WM"
