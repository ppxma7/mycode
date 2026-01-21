#!/bin/bash

rootfolder="/Volumes/kratos/CHAIN/"

for subjdir in "$rootfolder"/*/; do
    subj=$(basename "$subjdir")

    echo "Processing subject: $subj"

    # Define output directory INSIDE subject folder
    outdir="${subjdir}/phasefiles"

    echo $outdir

    # Create it if it doesn't exist
    mkdir -p "$outdir"

    # Move files (only if they exist)
    mv "$subjdir"/*_ph* "$outdir"/ 
    #mv "$subjdir"/*.json "$outdir"/ 2>/dev/null

    echo "Completed subject: $subj"
    echo "----------------------------"
done
