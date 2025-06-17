#!/bin/bash
set -euo pipefail

iter=6

OUTPUT="cluster_region_table_tstat${iter}.txt"



gawk -F'\t' '
BEGIN {
    IGNORECASE = 1
}
NR == 1 {
    print; next
}
{
    # Extract region name after percentage
    match($6, /[0-9]+%[ ]*([^,]+)/, arr)
    region = tolower(arr[1])
    if (!(region in seen)) {
        seen[region] = 1
        print
    }
}' "$OUTPUT" > "${OUTPUT%.txt}_norepeats.txt"


echo "Done! See $OUTPUT"