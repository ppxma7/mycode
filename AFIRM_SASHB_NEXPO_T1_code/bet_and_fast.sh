#!/bin/bash

# ---------------- CONFIG ----------------
OPTIBET="/Users/ppzma/Documents/MATLAB/optibet.sh"

# -------- INPUTS (as args) --------
# $1 = MPRAGE directory
# $2 = SUBJECT ID

MPRAGE_DIR="$1"
SUBJECT="$2"

# -------- Find MPRAGE (simple) --------
MPRAGE_IN=$(ls "$MPRAGE_DIR"/*MPRAGE*.nii* 2>/dev/null | head -n 1)

if [[ -z "$MPRAGE_IN" ]]; then
    echo "❌ No MPRAGE NIfTI found in $MPRAGE_DIR"
    exit 1
fi

echo "📂 Using MPRAGE: $(basename "$MPRAGE_IN")"


# optiBET output naming convention
MPRAGE_BRAIN="${MPRAGE_DIR}/${SUBJECT}_MPRAGE_optibrain.nii.gz"

echo "🔹 Processing subject: $SUBJECT"
echo "📂 MPRAGE: $MPRAGE_IN"

# ---------------- 1. Run optiBET ----------------
if [[ ! -f "$MPRAGE_BRAIN" ]]; then
    echo "🧠 Running optiBET..."
    sh "$OPTIBET" -i "$MPRAGE_IN"
else
    echo "ℹ️ optiBET output already exists, skipping."
fi

# -------- Rename optiBET outputs to canonical names --------

# Strip .nii or .nii.gz safely
base="$(basename "$MPRAGE_IN")"
base="${base%.nii.gz}"
base="${base%.nii}"

OPTI_BRAIN_SRC="${MPRAGE_DIR}/${base}_optiBET_brain.nii.gz"
OPTI_MASK_SRC="${MPRAGE_DIR}/${base}_optiBET_brain_mask.nii.gz"

MPRAGE_BRAIN="${MPRAGE_DIR}/${SUBJECT}_MPRAGE_optibrain.nii.gz"
MPRAGE_MASK="${MPRAGE_DIR}/${SUBJECT}_MPRAGE_optibrain_mask.nii.gz"

if [[ ! -f "$OPTI_BRAIN_SRC" ]]; then
    echo "❌ Expected optiBET brain not found:"
    echo "   $OPTI_BRAIN_SRC"
    exit 1
fi

echo "📝 Renaming optiBET outputs → subject-based names"
mv "$OPTI_BRAIN_SRC" "$MPRAGE_BRAIN"
mv "$OPTI_MASK_SRC"  "$MPRAGE_MASK"


# ---------------- 2. FAST segmentation ----------------
FAST_PREFIX="${MPRAGE_DIR}/${SUBJECT}_MPRAGE_brain"

if [[ ! -f "${FAST_PREFIX}_pve_0.nii.gz" ]]; then
    echo "🧠 Running FAST segmentation..."
    fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 \
        -o "$FAST_PREFIX" "$MPRAGE_BRAIN"
else
    echo "ℹ️ FAST outputs already exist, skipping."
fi

# ---------------- 3. GM + WM mask (exclude CSF) ----------------
PVE0="${FAST_PREFIX}_pve_0.nii.gz"  # CSF
PVE1="${FAST_PREFIX}_pve_1.nii.gz"  # GM
PVE2="${FAST_PREFIX}_pve_2.nii.gz"  # WM

ERO0="${FAST_PREFIX}_pve_0_ero.nii.gz"
MASK="${FAST_PREFIX}_gmwm_mask.nii.gz"

if [[ ! -f "$MASK" ]]; then
    echo "🧰 Creating GM+WM (no CSF) mask..."
    fslmaths "$PVE0" -ero "$ERO0"
    fslmaths "$PVE1" -add "$PVE2" -sub "$ERO0" -thr 0.2 -bin "$MASK"
else
    echo "ℹ️ GM+WM mask already exists."
fi

echo "✅ Finished $SUBJECT"
echo "👉 Brain: $MPRAGE_BRAIN"
echo "👉 Mask:  $MASK"
