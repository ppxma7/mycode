#!/bin/bash

# Folder to search
# TARGET="/Volumes/DRS-Touchmap/ma_ares_backup/"

# # Output file
# OUTPUT="par_summary.txt"

# echo "Searching for .PAR files in $TARGET ..." | tee "$OUTPUT"
# echo >> "$OUTPUT"

# # Count number of .PAR files
# NUM_FILES=$(find "$TARGET" -type f -name "*.PAR" | wc -l)
# echo "Number of .PAR files found: $NUM_FILES" | tee -a "$OUTPUT"

# # Total size of all .PAR files
# echo "Calculating total size..." | tee -a "$OUTPUT"
# TOTAL_SIZE=$(find "$TARGET" -type f -name "*.PAR" -exec du -ch {} + | tail -n 1)
# echo "Total size of .PAR files: $TOTAL_SIZE" | tee -a "$OUTPUT"
# echo >> "$OUTPUT"

# # List top 20 largest .PAR files
# echo "Top 20 largest .PAR files:" | tee -a "$OUTPUT"
# find "$TARGET" -type f -name "*.PAR" -exec ls -lh {} + | sort -k5 -hr | head -20 | tee -a "$OUTPUT"

# echo >> "$OUTPUT"
# echo "Full list of .PAR file paths saved to par_files_full.txt" | tee -a "$OUTPUT"

# # Save full list of file paths
# find "$TARGET" -type f -name "*.PAR" > par_files_full.txt


#!/bin/bash

# Input list of .PAR files
PAR_LIST="par_files_full.txt"

# Output files
OUTPUT_SUMMARY="rec_summary.txt"
OUTPUT_FULL_LIST="rec_files_full.txt"

# Set DRY_RUN=true to avoid deleting files
DRY_RUN=true

echo "Finding corresponding .REC files..." | tee "$OUTPUT_SUMMARY"

# Generate list of existing .REC files
> "$OUTPUT_FULL_LIST"
while read parfile; do
    recfile="${parfile%.PAR}.REC"
    if [ -f "$recfile" ]; then
        echo "$recfile" >> "$OUTPUT_FULL_LIST"
    fi
done < "$PAR_LIST"

# Count number of .REC files
NUM_REC=$(wc -l < "$OUTPUT_FULL_LIST")
echo "Number of .REC files found: $NUM_REC" | tee -a "$OUTPUT_SUMMARY"

# Calculate total size of .REC files
echo "Calculating total size of .REC files..." | tee -a "$OUTPUT_SUMMARY"
TOTAL_SIZE=$(du -ch $(cat "$OUTPUT_FULL_LIST") 2>/dev/null | tail -n 1)
echo "Total size of .REC files: $TOTAL_SIZE" | tee -a "$OUTPUT_SUMMARY"
echo >> "$OUTPUT_SUMMARY"

# Top 20 largest .REC files
echo "Top 20 largest .REC files:" | tee -a "$OUTPUT_SUMMARY"
ls -lh $(cat "$OUTPUT_FULL_LIST") 2>/dev/null | sort -k5 -hr | head -20 | tee -a "$OUTPUT_SUMMARY"
echo >> "$OUTPUT_SUMMARY"

# Delete files if DRY_RUN=false
if [ "$DRY_RUN" = false ]; then
    echo "Deleting all .REC files..." | tee -a "$OUTPUT_SUMMARY"
    while read file; do
        rm -v "$file" | tee -a "$OUTPUT_SUMMARY"
    done < "$OUTPUT_FULL_LIST"
    echo "Deletion complete." | tee -a "$OUTPUT_SUMMARY"
else
    echo "Dry run mode: no files deleted." | tee -a "$OUTPUT_SUMMARY"
fi

echo >> "$OUTPUT_SUMMARY"
echo "Full list of files is saved in $OUTPUT_FULL_LIST" | tee -a "$OUTPUT_SUMMARY"
