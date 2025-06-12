#!/bin/bash
set -euo pipefail

iter=6
# --- USER EDIT THESE ---
TSTAT="t1_rand_results_tstat${iter}.nii.gz"
CORRP="t1_rand_results_tfce_corrp_tstat${iter}.nii.gz"
#ATLAS_NAME="$FSLDIR/data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr25-1mm.nii.gz"
ATLAS_NAME="Harvard-Oxford Cortical Structural Atlas"
P_THRESH=0.95   # corrp > 0.95  => p < 0.05
# ------------------------

# ATLAS_IMG="$FSLDIR/data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr0-1mm.nii.gz"
# LABELS_XML="$FSLDIR/data/atlases/HarvardOxford-Cortical.xml"

# Filenames
MASK="sig_mask_tstat${iter}.nii.gz"
MASKED_STAT="masked_tstat${iter}.nii.gz"
PEAKS="cluster_peaks_tstat${iter}.txt"
OUTPUT="cluster_region_table_tstat${iter}.txt"

echo "1) Thresholding corrp map at p<0.05 (corrp>0.95) → $MASK"
fslmaths "$CORRP" -thr $P_THRESH -bin "$MASK"

echo "2) Masking stat map → $MASKED_STAT"
fslmaths "$TSTAT" -mas "$MASK" "$MASKED_STAT"

echo "3) Running cluster on masked stat map → peaks in $PEAKS"
# threshold >0 picks up any non-zero voxel as cluster
cluster --in="$MASKED_STAT" --thresh=0.0001 --olmax="$PEAKS" --mm

# Write header
printf 'Cluster\tPeakTFCE\tX\tY\tZ\tRegion\n' > "$OUTPUT"

# === PROCESS ===
tail -n +2 "$PEAKS" | while read -r CLUST STAT X Y Z; do
  # Build coordinate string
  COORD="${X},${Y},${Z}"
  echo $COORD

  # Query atlas and extract full region info after <br>
  # Try cortical atlas first
  echo "cortical atlas"
  # Try cortical atlas first
  RAW_OUTPUT=$(atlasquery -a "Harvard-Oxford Cortical Structural Atlas" -c "$COORD" 2>/dev/null)
  REGION=$(echo "$RAW_OUTPUT" | sed -n 's/^.*<br>//p')

  # Check if the output says "No label found!" (case-insensitive, safe for various FSL versions)
  if [[ "$REGION" == *"No label found!"* ]]; then
    echo "subcortical atlas"
    # Try subcortical atlas
    RAW_OUTPUT=$(atlasquery -a "Harvard-Oxford Subcortical Structural Atlas" -c "$COORD" 2>/dev/null)
    REGION=$(echo "$RAW_OUTPUT" | sed -n 's/^.*<br>//p')
  fi

  # Fallback if nothing useful
  [[ -z "$REGION" ]] && REGION="Unknown"



  # Append result
  printf "%s\t%s\t%s\t%s\t%s\t%s\n" \
    "$CLUST" "$STAT" "$X" "$Y" "$Z" "$REGION" >> "$OUTPUT"
done

echo "Done! See $OUTPUT"


echo "Done! See $OUTPUT for cluster table."

