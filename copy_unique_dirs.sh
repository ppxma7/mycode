#!/bin/bash

SRC="/Volumes/DRS-Touchmap/ma_ares_backup/nemosine/subjects"
DEST="/Volumes/DRS-Touchmap/ma_ares_backup/subs"

echo "Starting selective folder copy from:"
echo "  Source: $SRC"
echo "  Dest:   $DEST"
echo

for dir in "$SRC"/*; do
    name=$(basename "$dir")
    dest_dir="$DEST/$name"
    
    if [ ! -d "$dest_dir" ]; then
        echo "Copying $name..."
        rsync -azv "$dir" "$DEST/"
    else
        echo "Skipping $name (already exists)"
    fi
done

echo
echo "Done."
