#!/bin/bash

# Source and destination
SRC="/Volumes/DRS-GBPerm/other/outputs"
DST="/Volumes/kratos/dti_data/datasets"

# Create destination if it doesn't exist
mkdir -p "$DST"

# Subject list
subjects=(
16521-001b 16500-002B 17311-002b 17059-002a 17058-002A 17057-002C
16999-002B 16994-002A 16885-002A 1688-002C 16835-002A 16821-002A
16798-002A 16797-002C 16708-03A 16707-002A 16602-002B 16523_002b
16501-002b 16498-002A 16469-002A 15234-003B 156862_005 156862_004
17880002 17880001 16905_005 16905_004
)

# Loop through each subject and copy only the dMRI folder
for subj in "${subjects[@]}"; do
    src_path="${SRC}/${subj}/analysis/dMRI"
    dest_path="${DST}/${subj}/analysis"
    if [ -d "$src_path" ]; then
        echo "📦 Copying $subj..."
        mkdir -p "$dest_path"
        rsync -av --progress "$src_path" "$dest_path/"
    else
        echo "⚠️ Skipping $subj — no dMRI folder found"
    fi
done

echo "✅ Done copying all available dMRI folders."
