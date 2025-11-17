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
# subjects=(
# 16905_004 16905_005  \
# 17880001 17880002
# )

# subjects=(
# 05017_014 03143_174 17103_002 16728_005 18094_002 \
# 18076_002 18089_002 18031_002 18038_002 17769_002 \
# 17930_002 17765_002 17706_002 17723_002 17617_002 \
# 17698_002 17704_002 17607_002 17610_002 17596_002 \
# 17606_002 17589_002 17594_002 17580_002 17581_002 \
# 17532_002 17577_002 17456_002 17491_002 17492_002 \
# 17449_002 17453_002 17394_002 17395_002 17348_002 \
# 17364_002 17341_002 17342_002 17305_002 17324_002 \
# 17292_002 17293_002 17239_002 17243_002 17275_002 \
# 17210_002 17221_002 17207_002 17208_002 17178_002 \
# 17180_002 17173_002 17176_002 17129_002 17171_002 \
# 17127_002 17128_002 17108_002 17111_002 17104_002 \
# 17105_002 17102_002 17084_002 17086_002 17076_002 \
# 17080_002 17083_002 17074_002 17075_002 17072_002 \
# 17073_002 17040_002 17041_002 17007_002 17038_002 \
# 16986_002 16987_002 16911 16985_002 16878_002 \
# 16910_002 16866_002 16871_002 16874_002 16793_006 \
# 16824_002 16789_002 16791_002 16787_002 16788_002 \
# 16775_002 16725_002 16726_002 16701_002 16702_002 \
# 16693_002 16699_002 16663_002 16664_002 16661_002 \
# 16662_002 16623_002 16627_002 16618_002 16621_002 \
# 16613_002 16615_002 16569_002 16570_002 16544 \
# 16568_002 16542_002 16543_002 16517 16528_002 \
# 16513_002 16514_002 16511_002 16512_002 16467_002 \
# 16494_002 16465_002 16466_002 16463_002 16464_002 \
# 16439_002 16462_002 16437_002 16438_002 16419_002 \
# 16430_002 16404_004 16418_002 16389_002 16390_002 \
# 16388_002 16377_002 16303_002 16321_002 16322_002 \
# 16301_002 16302_002 16298_002 16299_002 16296_002 \
# 16297_002 16282_002 16283_002 16280_002 16281_002 \
# 16279 16277_002 16278_002 16176_002 16231_003 \
# 16175_002 16154_002 16174_002 16122_002 16133_002 \
# 16103_002 16121_002 16101_002 16102_002 16046_002 \
# 16058_002 16043_002 16044_002 16014_002 15955_002 \
# 15999_003 15721_009 15951_002 14007_003 14342_003 \
# 13673_015 13676 12969_004 13006_004 12929_004 \
# 12967_004 12838_004 12869_016 12578_004 12608_004 \
# 12428_005 12487_003 12411_004 12422_004 12219_006 \
# 12294 12305_004 12185_004 10760_130 12162_005 \
# 12181_004 09849 10469 06398_005 09376_062 \
# 16404_002 12294_004 12869_013 16544_002 \
# 10469_101 16279_002 16911_002 09849_006
# )

# I think this is nexpo group2 only
# subjects=(
# 09376_062 09849 10469 12162_005 12219_006 \
# 12294 12305_004 12428_005 12838_004 12869_016 \
# 12929_004 13006_004 13673_015 13676 14007_003 \
# 16133_002 16176_002 16278_002 16280_002 16281_002 \
# 16283_002 16321_002 16322_002 16388_002 16419_002 \
# 16437_002 16439_002 16463_002 16512_002 16514_002 \
# 16528_002 16544 16568_002 16618_002 16623_002 \
# 16627_002 16662_002 16664_002 16693_002 16702_002 \
# 16725_002 16728_005 16775_002 16866_002 16878_002 \
# 17171_002 17180_002 17239_002 17342_002 17364_002
# )

subjects=(
16905_005 17880002 156862_005 \
)




OUTDIR="${SUBJECTS_DIR}/group_thickness_sashb_postdialy"
mkdir -p "$OUTDIR"

echo "--------------------------------------"
echo " Projecting cortical thickness to fsaverage"
echo "--------------------------------------"

# --- Loop through subjects ---
for sub in "${subjects[@]}"; do

  # --- Skip empty entries ---
  if [[ -z "$sub" ]]; then
    echo "⚠️  Skipping empty subject entry"
    continue
  fi

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

# # mean ---
# lh_average_out="${OUTDIR}/lh.thickness.mean.mgh"
# rh_average_out="${OUTDIR}/rh.thickness.mean.mgh"
# # --- Skip averaging if both exist ---
# if [[ -f "$lh_average_out" && -f "$rh_average_out" ]]; then
#   echo "⏩ Skipping averaging (mean maps already exist)"
# else
#   if [[ ! -f "$lh_average_out" ]]; then
#     echo "Computing left hemisphere mean..."
#     mri_concat --i ${OUTDIR}/lh.thickness.*.mgh --mean --o "$lh_average_out"
#   fi

#   if [[ ! -f "$rh_average_out" ]]; then
#     echo "Computing right hemisphere mean..."
#     mri_concat --i ${OUTDIR}/rh.thickness.*.mgh --mean --o "$rh_average_out"
#   fi
# fi

# --- Left hemisphere mean ---
lh_average_out="${OUTDIR}/lh.thickness.mean_subset.mgh"
rh_average_out="${OUTDIR}/rh.thickness.mean_subset.mgh"

if [[ -f "$lh_average_out" && -f "$rh_average_out" ]]; then
  echo "⏩ Skipping averaging (subset mean maps already exist)"
else
  # Build input lists dynamically from chosen subjects
  lh_inputs=()
  rh_inputs=()

  for sub in "${subjects[@]}"; do
    lh_file="${OUTDIR}/lh.thickness.${sub}.mgh"
    rh_file="${OUTDIR}/rh.thickness.${sub}.mgh"
    [[ -f "$lh_file" ]] && lh_inputs+=("--i" "$lh_file")
    [[ -f "$rh_file" ]] && rh_inputs+=("--i" "$rh_file")
  done

  # Compute means only from listed subjects
  if [[ ${#lh_inputs[@]} -gt 0 ]]; then
    echo "Computing left hemisphere subset mean..."
    mri_concat "${lh_inputs[@]}" --mean --o "$lh_average_out"
  fi

  if [[ ${#rh_inputs[@]} -gt 0 ]]; then
    echo "Computing right hemisphere subset mean..."
    mri_concat "${rh_inputs[@]}" --mean --o "$rh_average_out"
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



