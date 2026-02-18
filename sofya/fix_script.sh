#!/bin/bash
# Michael Asghar 2026
set -e

# -------- USER SETTINGS --------
ICA_DIR=/Volumes/kratos/SOFYA/melodic_analysis/groupICA_test/melodic_output.ica
MODEL=Standard
THRESH=20

cd $(dirname $ICA_DIR)

echo "=== STEP 1: Feature extraction ==="
fix -f $ICA_DIR

echo "=== STEP 2: Classification ==="
fix -c $ICA_DIR $MODEL $THRESH

LABELFILE=$ICA_DIR/fix4melview_${MODEL}_thr${THRESH}.txt

echo "=== STEP 3: Cleanup ==="
fix -a $LABELFILE -m -h 200

echo "=== DONE: FIX cleaning complete ==="
