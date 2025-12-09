#!/bin/bash

TBSSDIR="/Volumes/kratos/dti_data/MD/nexpo"
#MAPFILE="/Volumes/kratos/dti_data/tbss_analysis_wchain/mapfile.txt"
MAPFILE=$TBSSDIR/mapfile.txt

# group_map.txt contains two columns: subjectID   groupNumber
# Example lines:
# 09376_062  2
# 15234-003B 5
# 16905_004  6

# Group name mapping
# Call with bash so avoids error wtih zsh not liking declare
# declare -A groupnames=(
#     [1]="CHAIN"
#     [5]="AFIRM"
#     [6]="SASHB"
# )
sed -n '1,20p' "$TBSSDIR/mapfile.txt" | cat -v
sed -i '' 's/\r$//' "$TBSSDIR/mapfile.txt"

# Loop through each line of mapping
while read -r subj group; do
    # Skip empty lines or comments
    [[ -z "$subj" || "$subj" == \#* ]] && continue

    # Map group number → group name
    case "$group" in
        1) groupname="NEXPO_G1" ;;
        2) groupname="NEXPO_G2" ;;
        3) groupname="NEXPO_G3" ;;
        4) groupname="NEXPO_G4" ;;
        *)
            echo "⚠️  Unknown group number $group for $subj, skipping."
            continue
            ;;
    esac

    src="${TBSSDIR}/${subj}_dti_MD.nii.gz"
    dest="${TBSSDIR}/${groupname}_${subj}_dti_MD.nii.gz"

    if [ -f "$src" ]; then
        echo "TEST"
        echo "📦 Renaming $src → $(basename "$dest")"
        mv -n "$src" "$dest"
        echo "Would move $src to $dest"
    else
        echo "⚠️  Missing MD file for $subj"
    fi

done < "$MAPFILE"

echo "✅ Renaming complete."

