#! /bin/bash

for f in *.nii; do
    #myfile=$(echo "${f}" | cut -f 1 -d '.')
    #cp "$f" "${f%.nii}_head.nii"

    myfile=$(echo "${f}" | cut -f 1 -d '.')
    sh /Users/spmic/Documents/MATLAB/nottingham/michael/optiBET.sh -i $f ${f%.nii}_optiBET.nii

done

