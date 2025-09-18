#!/usr/bin/env bash
# rsync_t1_to_group5.sh
# Copies *_T1_to_MNI_linear_1mm.nii.gz files into /Volumes/DRS-GBPerm/other/t1mnispace/group5/
# using rsync (safe, resumable, verbose)

src_dir="/Volumes/DRS-GBPerm/other/t1mapping_out"
dst_dir="/Volumes/DRS-GBPerm/other/t1mnispace/group5"

mkdir -p "$dst_dir"

# subjects=(
#   16500-002B 16498-002A 16469-002A 15234-003B 17311-002b
#   16521-001b 17059-002a 17058-002A 17057-002C 16999-002B
#   16994-002A 16885-002A 16835-002A 16821-002A 16798-002A
#   16797-002C 16708-03A 16707-002A 16602-002B 16523_002b
#   16501-002b 1688-002C
# )


subjects=("1688-002C" "15234-003B" "16469-002A" "16498-002A" \
"16500-002B" "16501-002b" "16521-001b" "16523_002b" \
"16602-002B" "16707-002A" "16708-03A" "16797-002C" \
"16798-002A" "16821-002A" "16835-002A" "16885-002A" \
"16994-002A" "16999-002B" "17057-002C" "17058-002A" "17059-002a" \
"17311-002b")

count=0
total=${#subjects[@]}

for subj in "${subjects[@]}"; do
    file="$src_dir/$subj/${subj}_T1_to_MNI_linear_1mm.nii.gz"
    if [[ -f "$file" ]]; then
        count=$((count+1))
        echo "[$count/$total] Copying $file → $dst_dir/"
        rsync -avh "$file" "$dst_dir/"
    else
        echo "⚠️  Missing file for $subj"
    fi
done

echo "✅ Rsync copy complete. $count of $total files copied."
