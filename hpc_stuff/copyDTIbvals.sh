#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=4g
#SBATCH --time=1:00:00

echo "Running on $(hostname)"

topPath="/spmstore/project/AFIRMBRAIN/AFIRM/inputs"

subjects=("1688-002C" "15234-003B" "16469-002A" "16498-002A" \
"16500-002B" "16501-002b" "16521-001b" "16523_002b" \
"16602-002B" "16707-002A" "16708-03A" "16797-002C" \
"16798-002A" "16821-002A" "16835-002A" "16885-002A" \
"16994-002A" "16999-002B" "17057-002C" "17058-002A" "17059-002a" \
"17311-002b")

echo "Total subjects: ${#subjects[@]}"

for subj in "${subjects[@]}"; do
    echo "Processing subject: ${subj}"

    file1=$(find "$topPath/$subj/DTI/" -type f -iname "*blipMB3*sDTI*_ph.bval" | head -n 1)
    file2=$(find "$topPath/$subj/DTI/" -type f -iname "*blipMB3*sDTI*_ph.bvec" | head -n 1)

    if [[ -f "$file1" && -f "$file2" ]]; then
        file1out="${file1/_ph/}"
        file2out="${file2/_ph/}"

        echo "Copying:"
        echo "  $file1 -> $file1out"
        echo "  $file2 -> $file2out"

        #cp "$file1" "$file1out"
        #cp "$file2" "$file2out"
    else
        echo "⚠️  Missing files for subject $subj"
    fi
done



