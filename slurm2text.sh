#!/bin/bash

# Make folders for organization
mkdir -p "raw_slurms"
mkdir -p "text_slurms"

# Clear / create summary file
summary_file="slurm_tail_summary.txt"
> "$summary_file"

# Loop through all slurm*.out files
for f in slurm*.out; do
    # Skip if no matching files
    [ -e "$f" ] || continue

    # New filename with .txt extension
    newname="${f%.out}.txt"

    # Copy content to .txt in text_slurms
    cp "$f" "text_slurms/$newname"

    # Move original .out file into raw_slurms
    mv "$f" raw_slurms/

    # Append last 5 lines to summary
    echo "===== $newname =====" >> "$summary_file"
    tail -n 5 "text_slurms/$newname" >> "$summary_file"
    echo "" >> "$summary_file"

    echo "Processed: $f -> text_slurms/$newname, moved original, appended last 5 lines"
done
