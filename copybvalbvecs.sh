#!/bin/bash

root="/Volumes/kratos/NEXPODTIS/ppzma-20250923_145236/not_in_line"

find "$root" -type f -path "*/DTI/*.nii" | while read -r nifti; do
    dir=$(dirname "$nifti")
    base=$(basename "$nifti" .nii)

    bval="$dir/${base}.bval"
    bvec="$dir/${base}.bvec"

    # Only create if they don't exist
    if [ ! -f "$bval" ]; then
        echo "0" > "$bval"
        echo "✅ Created $bval"
    else
        echo "⏭️ Skipping existing $bval"
    fi

    if [ ! -f "$bvec" ]; then
        printf "0\n0\n0\n" > "$bvec"
        echo "✅ Created $bvec"
    else
        echo "⏭️ Skipping existing $bvec"
    fi
done

echo "🎯 Done generating missing bval/bvec files."
