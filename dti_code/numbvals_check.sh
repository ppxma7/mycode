#!/bin/bash

root="/Volumes/DRS-GBPerm/other/AFIRM_inputs/"

find "$root" -type f -name "*.bval" | while read -r bval; do
    nvals=$(wc -w < "$bval")
    echo "$bval : $nvals values"
done
