#!/bin/bash
set -e

# -------------------------
# Paths
# -------------------------

BASE="/Volumes/kratos/CANAPI/canapi_sub14"
STRUCT="${BASE}/structurals"
FUNC="${BASE}/spm_analysis"

MNI_REF="/usr/local/fsl/data/standard/MNI152_T1_2mm_brain"

T1="${STRUCT}/canapi_sub14_WIPMPRAGE_CS3_5_20260226121206_7_optiBET_brain.nii"
MEAN_FUNC="${FUNC}/meancanapi_sub14_WIP1bar_TAP_R_20260226121206_3_nordic_clv.nii"

T1_TO_MNI_MAT="${STRUCT}/T1_to_MNI.mat"
FUNC_TO_T1_MAT="${STRUCT}/FUNC_to_T1.mat"
FUNC_TO_MNI_MAT="${STRUCT}/FUNC_to_MNI.mat"

# -------------------------
# 1) T1 -> MNI (12 DOF)
# -------------------------

echo "Registering T1 to MNI..."

flirt \
  -in "$T1" \
  -ref "$MNI_REF" \
  -omat "$T1_TO_MNI_MAT" \
  -bins 256 \
  -cost corratio \
  -searchrx -180 180 \
  -searchry -180 180 \
  -searchrz -180 180 \
  -dof 12


# -------------------------
# 2) Mean fMRI -> T1
# -------------------------

echo "Registering mean fMRI to T1..."

flirt \
  -in "$MEAN_FUNC" \
  -ref "$T1" \
  -omat "$FUNC_TO_T1_MAT" \
  -bins 256 \
  -cost corratio \
  -searchrx -180 180 \
  -searchry -180 180 \
  -searchrz -180 180 \
  -dof 12


# -------------------------
# 3) Concatenate transforms
# -------------------------

echo "Concatenating transforms..."

convert_xfm \
  -omat "$FUNC_TO_MNI_MAT" \
  -concat "$T1_TO_MNI_MAT" \
  "$FUNC_TO_T1_MAT"


# -------------------------
# 4) Apply to ALL 4 runs
# -------------------------

echo "Applying transform to 4D fMRI runs..."

RUNS=(
  "rcanapi_sub14_WIP1bar_TAP_R_20260226121206_3_nordic_clv.nii"
  "rcanapi_sub14_WIPlow_TAP_L_20260226121206_6_nordic_clv.nii"
  "rcanapi_sub14_WIP1bar_TAP_L_20260226121206_5_nordic_clv.nii"
  "rcanapi_sub14_WIPlow_TAP_R_20260226121206_4_nordic_clv.nii"
)

for run in "${RUNS[@]}"; do

  infile="${FUNC}/${run}"
  outfile="${FUNC}/${run%.nii}_MNI.nii.gz"

  echo "Transforming $run"

  flirt \
    -in "$infile" \
    -ref "$MNI_REF" \
    -out "$outfile" \
    -applyxfm \
    -init "$FUNC_TO_MNI_MAT" \
    -interp trilinear

done

echo "All done."