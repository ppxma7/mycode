#!/bin/bash

# =========================
# Project cortical thickness to fsaverage
# and compute group average maps
# =========================

export SUBJECTS_DIR="/Volumes/DRS-GBPerm/other/outputs"

# --- Subject list ---
# subjects=(
# 16521-001b 16500-002B 17311-002b 17059-002a \
# 17058-002A 17057-002C 16999-002B 16994-002A \
# 16885-002A 1688-002C 16835-002A 16821-002A \
# 16798-002A 16797-002C 16708-03A 16707-002A \
# 16602-002B 16523_002b 16501-002b 16498-002A \
# 16469-002A 15234-003B
# )
subjects=(
16905_004 16905_005  \
17880001 17880002
)


OUTDIR="${SUBJECTS_DIR}/group_thickness_sashb"
mkdir -p "$OUTDIR"

echo "--------------------------------------"
echo " Projecting cortical thickness to fsaverage"
echo "--------------------------------------"

# --- Loop through subjects ---
for sub in "${subjects[@]}"; do
  echo "🧩 Processing subject: $sub"

  lh_out="${OUTDIR}/lh.thickness.${sub}.mgh"
  rh_out="${OUTDIR}/rh.thickness.${sub}.mgh"

  # --- Skip if both hemispheres already exist ---
  if [[ -f "$lh_out" && -f "$rh_out" ]]; then
    echo "⏩ Skipping $sub (already projected)"
    continue
  fi

  # --- Left hemisphere ---
  if [[ ! -f "$lh_out" ]]; then
    mris_preproc --s "$sub" --target fsaverage --hemi lh --meas thickness --out "$lh_out"
  fi

  # --- Right hemisphere ---
  if [[ ! -f "$rh_out" ]]; then
    mris_preproc --s "$sub" --target fsaverage --hemi rh --meas thickness --out "$rh_out"
  fi

done

echo "--------------------------------------"
echo " Averaging thickness maps across subjects"
echo "--------------------------------------"

# --- Left hemisphere mean ---
lh_average_out="${OUTDIR}/lh.thickness.mean.mgh"
rh_average_out="${OUTDIR}/rh.thickness.mean.mgh"
# --- Skip averaging if both exist ---
if [[ -f "$lh_average_out" && -f "$rh_average_out" ]]; then
  echo "⏩ Skipping averaging (mean maps already exist)"
else
  if [[ ! -f "$lh_average_out" ]]; then
    echo "Computing left hemisphere mean..."
    mri_concat --i ${OUTDIR}/lh.thickness.*.mgh --mean --o "$lh_average_out"
  fi

  if [[ ! -f "$rh_average_out" ]]; then
    echo "Computing right hemisphere mean..."
    mri_concat --i ${OUTDIR}/rh.thickness.*.mgh --mean --o "$rh_average_out"
  fi
fi

# echo "--------------------------------------"
# echo " View group mean maps in Freeview"
# echo "--------------------------------------"

# freeview -f \
#   $SUBJECTS_DIR/fsaverage/surf/lh.inflated:overlay=${OUTDIR}/lh.thickness.mean.mgh \
#   $SUBJECTS_DIR/fsaverage/surf/rh.inflated:overlay=${OUTDIR}/rh.thickness.mean.mgh \
#   --viewport 3d

# echo "Done! Files saved in: $OUTDIR"

# freeview -f \
#   $SUBJECTS_DIR/fsaverage/surf/lh.pial:overlay=${OUTDIR}/lh.thickness.mean.mgh:overlay_method=linear:overlay_color=jet \
#   $SUBJECTS_DIR/fsaverage/surf/rh.pial:overlay=${OUTDIR}/rh.thickness.mean.mgh:overlay_method=linear:overlay_color=jet \
#   --viewport 3d \
#   --layout 1 \
#   --zoom 1.3



