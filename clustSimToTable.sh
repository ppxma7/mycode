#!/bin/bash

# Usage: ./extract_clusters.sh [base_directory]
BASE_DIR="${1:-.}"

find "$BASE_DIR" -name "cache.th30.pos.sig.cluster.summary" -print0 | while IFS= read -r -d '' file; do
  out="$(dirname "$file")/$(basename "$file" .summary | tr -d '.').csv"

  echo "Processing: $file"
  echo "Saving as:  $out"

  grep -v '^#' "$file" | awk '{$1=$1; gsub(/ +/, ","); print}' > "$out"
done

find "$BASE_DIR" -name "cache.th30.neg.sig.cluster.summary" -print0 | while IFS= read -r -d '' file; do
  out="$(dirname "$file")/$(basename "$file" .summary | tr -d '.').csv"

  echo "Processing: $file"
  echo "Saving as:  $out"

  grep -v '^#' "$file" | awk '{$1=$1; gsub(/ +/, ","); print}' > "$out"
done
