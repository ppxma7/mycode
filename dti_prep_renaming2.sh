#!/bin/sh

TBSSDIR="/Volumes/kratos/dti_data/tbss_analysis_justnexpo"
MAPFILE="/Volumes/kratos/dti_data/tbss_analysis_justnexpo/mapfilenexpo.txt"
OUTFILE="${TBSSDIR}/renamed_files.txt"
> "$OUTFILE"       # empty/overwrite the file before starting


while IFS='' read -r line || [ -n "$line" ]; do

    # Skip empty or comment lines
    [ -z "$line" ] && continue
    case "$line" in \#*) continue ;; esac

    # Extract two TAB-separated fields
    subj=$(printf "%s" "$line" | cut -f1)
    group=$(printf "%s" "$line" | cut -f2)

    # Remove CR if present (Windows line endings)
    subj=$(printf "%s" "$subj" | tr -d '\r')
    group=$(printf "%s" "$group" | tr -d '\r')

    echo "DEBUG: subj='$subj' group='$group'"

    # Map group numbers → names
    case "$group" in
        1) groupname="NEXPOG1" ;;
        2) groupname="NEXPOG2" ;;
        3) groupname="NEXPOG3" ;;
        4) groupname="NEXPOG4" ;;
        *)
            echo "⚠️ Unknown group '$group' for $subj — skipping."
            continue
            ;;
    esac

    src="${TBSSDIR}/origdata/${subj}_dti_FA.nii.gz"
    dest="${TBSSDIR}/origdata/${groupname}_${subj}_dti_FA.nii.gz"

    if [ -f "$src" ]; then
        #echo "📦 Would rename $(basename "$src") → $(basename "$dest")"
        mv -n "$src" "$dest"
        echo "$(basename "$dest")" >> "$OUTFILE"

    else
        echo "⚠️ Missing FA file for $subj"
    fi

done < "$MAPFILE"
echo "📄 Saved list of renamed files to: $OUTFILE"

echo "✅ Renaming complete."
