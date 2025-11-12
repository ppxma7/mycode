#!/bin/bash
set -e
shopt -s nullglob extglob

# === Create directories if they don't exist ===
dirs=( "MPRAGE" "MPRAGE_sodium" "FLAIR" "T1mapping" "sodium" "DTI" )
for dir in "${dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ Directory '$dir' already exists."
    else
        mkdir "$dir"
        echo "📁 Created directory: $dir"
    fi
done
echo

# === Move DTI files ===
dtifiles=( *DTI*.nii *DTI*.json *DTI*.bval *DTI*.bvec)
if (( ${#dtifiles[@]} )); then
    echo "📦 Moving ${#dtifiles[@]} DTI ..."
    #echo ${dtifiles[@]}
    mv -i "${dtifiles[@]}" DTI/
else
    echo "⚠️ No DTI  found."
fi


t1files=( *T1mapping*.nii *T1mapping*.json)
if (( ${#t1files[@]} )); then
    echo "📦 Moving ${#t1files[@]}  ..."
    mv -i "${t1files[@]}" T1mapping/
else
    echo "⚠️ No T1  found."
fi


# === Move FLAIR files ===
sods=( *23Na*.nii *23Na*.json)
if (( ${#sods[@]} )); then
    echo "📦 Moving ${#sods[@]} sods files..."
    mv -i "${sods[@]}" sodium/
else
    echo "⚠️ No sods files found."
fi
echo

# === Move SODIUM files ===
flairs=( *FLAIR*.nii *FLAIR*.json)
if (( ${#flairs[@]} )); then
    echo "📦 Moving ${#flairs[@]} FLAIR files..."
    mv -i "${flairs[@]}" FLAIR/
else
    echo "⚠️ No FLAIR files found."
fi
echo

# === Move MPRAGE files (with CS3.5 fix) ===
mprage_cs3=( *MPRAGE_CS3*.nii *MPRAGE_CS3*.json)
if (( ${#mprage_cs3[@]} )); then
    echo "📦 Moving and renaming ${#mprage_cs3[@]} MPRAGE (CS3.x) files..."
    for f in "${mprage_cs3[@]}"; do
        newname="${f//CS3./CS3p}"   # replace 'CS3.' → 'CS3p'
        if [[ "$f" != "$newname" ]]; then
            mv -i "$f" "$newname"
        fi
        mv -i "$newname" MPRAGE/
    done
else
    echo "⚠️ No MPRAGE CS3.x files found."
fi
echo

# === Move other MPRAGE files (non-CS3) ===
mprage_other=( *MPRAGE*.nii *MPRAGE*.json )
# Exclude ones already moved (CS3x)
mprage_filtered=()
for f in "${mprage_other[@]}"; do
    [[ "$f" == *CS3* ]] || mprage_filtered+=("$f")
done

if (( ${#mprage_filtered[@]} )); then
    echo "📦 Moving ${#mprage_filtered[@]} other MPRAGE files..."
    mv -i "${mprage_filtered[@]}" MPRAGE_sodium/
else
    echo "⚠️ No other MPRAGE files found."
fi
echo




shopt -u nullglob extglob
echo "✅ All done!"
