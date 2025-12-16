#!/bin/bash

SUBJECTS_DIR="/Volumes/DRS-GBPerm/other/outputs"
OUTDIR="${SUBJECTS_DIR}/group_thickness_nexpo"
MAPFILE="${SUBJECTS_DIR}/nexpo_200_id.txt"

mkdir -p "${OUTDIR}/group_means"

echo "--------------------------------------"
echo " Computing group-wise thickness means"
echo "--------------------------------------"

for group in 1 2 3 4; do
  echo "Processing Group ${group}"

  lh_inputs=()
  rh_inputs=()

  # Read mapping file
  while read -r sub grp; do
    [[ "$grp" != "$group" ]] && continue

    lh_file="${OUTDIR}/lh.thickness.${sub}.mgh"
    rh_file="${OUTDIR}/rh.thickness.${sub}.mgh"

    [[ -f "$lh_file" ]] && lh_inputs+=("--i" "$lh_file")
    [[ -f "$rh_file" ]] && rh_inputs+=("--i" "$rh_file")

  done < "$MAPFILE"

  # Output names
  lh_out="${OUTDIR}/group_means/lh.thickness.group${group}.mean.mgh"
  rh_out="${OUTDIR}/group_means/rh.thickness.group${group}.mean.mgh"

  # Compute means
  if [[ ${#lh_inputs[@]} -gt 0 ]]; then
    echo "  LH: ${#lh_inputs[@]} subjects"
    mri_concat "${lh_inputs[@]}" --mean --o "$lh_out"
  else
    echo "  LH: no inputs found"
  fi

  if [[ ${#rh_inputs[@]} -gt 0 ]]; then
    echo "  RH: ${#rh_inputs[@]} subjects"
    mri_concat "${rh_inputs[@]}" --mean --o "$rh_out"
  else
    echo "  RH: no inputs found"
  fi

done

echo "Done."
