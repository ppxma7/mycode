#!/bin/bash
# Define paths
FLIRT="/Users/spmic/fsl/bin/flirt"
IN_DIR="/Volumes/arianthe/PAIN/spmimport_redo_allsubs/sub08/thermode_hand_3t"


EPI_REG="/Users/spmic/fsl/bin/epi_reg"

# Define input files for epi_reg
# Need to run bet input output -R -m
EPI="/Volumes/arianthe/PAIN/spmimport_redo_allsubs/sub08/meanfMRI_3T.nii"
T1="/Volumes/arianthe/PAIN/spmimport_redo_allsubs/sub08/13676_mprage_pp.nii"
T1_BRAIN="/Volumes/arianthe/PAIN/spmimport_redo_allsubs/sub08/13676_mprage_brain.nii.gz"
OUT_BASE="/Volumes/arianthe/PAIN/spmimport_redo_allsubs/sub08/epi2struct"  # Base name for epi_reg outputs

# Run epi_reg to generate transformation matrix and aligned mean fMRI image
echo "Running epi_reg for functional-to-structural registration..."
$EPI_REG --epi="$EPI" \
         --t1="$T1" \
         --t1brain="$T1_BRAIN" \
         --out="$OUT_BASE"

# Define the transformation matrix file produced by epi_reg
TRANSFORM="${OUT_BASE}.mat"

# Check if the matrix file exists
if [ ! -f "$TRANSFORM" ]; then
    echo "Error: Transformation matrix $TRANSFORM not found."
    exit 1
fi

REF="$T1"  # Use the MPRAGE as the reference image for transformation
OUT_DIR="/Volumes/arianthe/PAIN/spmimport_redo_allsubs/sub08"


# Loop through spmT images 1 to 5
echo "Applying transformation to spmT images..."
for i in {1..5}; do
  # Format the index with leading zeros (e.g., 0001)
  infile=$(printf "%s/spmT_%04d.nii" "$IN_DIR" "$i")
  outfile=$(printf "%s/spmT2mprage_%04d.nii" "$OUT_DIR" "$i")
  
  echo "Transforming $infile -> $outfile"
  
  $FLIRT \
    -in "$infile" \
    -ref "$REF" \
    -applyxfm \
    -init "$TRANSFORM" \
    -out "$outfile" \
    -interp trilinear
done

echo "All spmT images have been transformed."
