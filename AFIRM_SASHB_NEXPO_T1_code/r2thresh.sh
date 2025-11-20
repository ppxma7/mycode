#!/bin/bash
set -e

rootFolder="/Volumes/nemosine/SAN/AFIRM/t1mapping_out"
outFile="${rootFolder}/R2_stats.txt"

#echo "subject,meanR2,medianR2" > "$outFile"


# --- Skip creation if the file already exists ---
if [[ -f "$outFile" ]]; then
    echo "📄 R2_stats.txt already exists — skipping creation."
else
    echo "subject,meanR2,medianR2" > "$outFile"
    echo "📄 Created new R2_stats.txt"

    for subjdir in "$rootFolder"/*/; do
	    subj=$(basename "$subjdir")
	    r2file="${subjdir}/${subj}_R2.nii.gz"

	    echo "Processing subject: $subj"

	    if [[ ! -f "$r2file" ]]; then
	        echo "⚠️  No R2 file for $subj — expected: $r2file"
	        continue
	    fi

	    # --- Compute stats ---
	    #meanR2=$(fslstats "$r2file" -M)

	    r2clean="${subjdir}/${subj}_R2_nonan.nii.gz"
		fslmaths "$r2file" -nan "$r2clean"

		meanR2=$(fslstats "$r2clean" -M)
		medianR2=$(fslstats "$r2clean" -P 50)


	    #medianR2=$(fslstats "$r2file" -P 50)

	    echo "$subj,$meanR2,$medianR2" >> "$outFile"

	    echo "Completed subject: $subj"
	    echo "----------------------------"
	done

	echo "✅ Saved stats to $outFile"

fi


python /Users/ppzma/Documents/MATLAB/mycode/AFIRM_SASHB_NEXPO_T1_code/r2thresh_plot.py "$rootFolder"
