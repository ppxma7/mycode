#!/bin/bash

# === CONFIGURATION ===
SUBJECTS_DIR=/Volumes/DRS-GBPerm/other/outputs
ROOT_DIR=/Volumes/DRS-GBPerm/other/outputs/etiv_doss_wage_wafirm_wsashb_g2only
OUTPUT_ROOT="/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/nexpo_afirm_screenshots/etiv_doss_wage_wafirm_wsashb_g2only"

hemi_list=("lh" "rh")
measure_list=("thickness" "volume")
contrast_dirs=(
  Age_overall g2_vs_g5 g2_vs_g6 g5_vs_g6
)

# === MAIN LOOP ===
for hemi in "${hemi_list[@]}"; do
  for meas in "${measure_list[@]}"; do
    glm_dir="${ROOT_DIR}/${hemi}.${meas}.NexpoStudy_eTIV_wafirm_wsashb_g2only.10.glmdir"
    surf_file="${SUBJECTS_DIR}/fsaverage/surf/${hemi}.inflated"

    for contrast in "${contrast_dirs[@]}"; do
      contrast_dir="${glm_dir}/${contrast}"

      for polarity in pos neg; do
        overlay_file="${contrast_dir}/cache.th30.${polarity}.sig.masked.mgh"
        csvfile="${contrast_dir}/cacheth30${polarity}sigcluster.csv"

        # --- Check CSV for data rows (ignore header) ---
        if [[ -f "$csvfile" ]]; then
          rowcount=$(awk 'NR>1 && NF>0' "$csvfile" | wc -l)
        else
          rowcount=0
        fi

        echo "🔎 $csvfile → $rowcount data rows"
        if [[ $rowcount -eq 0 ]]; then
          echo "⏭ Skipping $contrast_dir ($polarity) — no significant clusters"
          continue
        fi

        # --- Generate screenshots only if overlay exists ---
        if [[ -f "$overlay_file" ]]; then

       		# Build output directory to mirror input structure
          outdir="${OUTPUT_ROOT}/${hemi}.${meas}.NexpoStudy_eTIV_wafirm_wsashb_g2only.10.glmdir/${contrast}"
          mkdir -p "$outdir"

          for view in lateral medial; do
            out_img="${outdir}/${hemi}_${meas}_${contrast}_${polarity}_${view}.png"
			freeview \
			  -f ${surf_file}:overlay=${overlay_file}:overlay_method=linearopaque:overlay_threshold=1.3,2.0,10.0 \
			  --viewport 3d \
			  --view $view \
			  --colorscale \
			  --screenshot "$out_img" 1 autotrim
			echo "✅ Saved $out_img"
          done
        else
          echo "⚠️  No overlay file for $contrast_dir ($polarity)"
        fi
      done
    done
  done
done
