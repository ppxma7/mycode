#!/bin/bash

# Dry run: just print what would be moved
find . -type d -path "*/analysis/anatMRI/T1/processed/FreeSurfer" | while read -r fsdir; do
  subjdir=$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$fsdir")")")")")  # Goes back to subject top-level dir
  echo "Would move contents of:"
  echo "  From: $fsdir/"
  echo "  To:   $subjdir/"
  
  # List files and folders that would be moved
  find "$fsdir" -mindepth 1 -maxdepth 1
  echo "---"

  # comment this to dry run
  mv "$fsdir"/* "$subjdir"/
done
