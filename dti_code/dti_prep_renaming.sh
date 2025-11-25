#!/bin/bash

TBSSDIR="/Volumes/kratos/dti_data/tbss_analysis"
MAPFILE="/Volumes/kratos/dti_data/tbss_analysis/mapfile.txt"

# group_map.txt contains two columns: subjectID   groupNumber
# Example lines:
# 09376_062  2
# 15234-003B 5
# 16905_004  6

# Group name mapping
# Call with bash so avoids error wtih zsh not liking declare
declare -A groupnames=(
    [2]="NEXPO"
    [5]="AFIRM"
    [6]="SASHB"
)

# Loop through each line of mapping
while read -r subj group; do
    # Skip empty lines or comments
    [[ -z "$subj" || "$subj" == \#* ]] && continue

    groupname=${groupnames[$group]}
    if [ -z "$groupname" ]; then
        echo "⚠️  Unknown group number $group for $subj, skipping."
        continue
    fi

    src="${TBSSDIR}/${subj}_dti_FA.nii.gz"
    dest="${TBSSDIR}/${groupname}_${subj}_dti_FA.nii.gz"

    if [ -f "$src" ]; then
        echo "📦 Renaming $src → $(basename "$dest")"
        mv -n "$src" "$dest"
        #echo "Would move $src to $dest"
    else
        echo "⚠️  Missing FA file for $subj"
    fi
done < "$MAPFILE"

echo "✅ Renaming complete."
