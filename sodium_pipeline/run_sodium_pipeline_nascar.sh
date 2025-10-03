#!/bin/bash
# Wrapper for run_sodium_pipeline.py
# Usage: ./run_sodium_pipeline.sh SUBJECT_ID

if [ $# -ne 2 ]; then
    echo "Usage: $0 SUBJECT_ID REF_BASENAME"
    echo "Example: $0 Subject1 floret"
    exit 1
fi

SUBJECT=$1
REF_BASENAME=$2

# Root directory where subject folders live
ROOTDIR="/Volumes/nemosine/SAN/SASHB/inputs/NASCAR/"

# Build paths
ARG1="${ROOTDIR}/${SUBJECT}/site2/pipeline/proton"
ARG2="${ROOTDIR}/${SUBJECT}/site2/pipeline/reference_sodium/"
ARG3="${ROOTDIR}/${SUBJECT}/site2/pipeline/other_sodium"

# then send to mni script
ARG4="${ROOTDIR}/${SUBJECT}/site2/outputs/"


# Check that all three paths exist
for d in "$ARG1" "$ARG2" "$ARG3"; do
    if [ ! -d "$d" ]; then
        echo "Error: directory $d does not exist."
        exit 1
    fi
done

echo "Running sodium NASCAR pipeline for $SUBJECT (reference=${REF_BASENAME}.nii)"
python3 /Users/ppzma/Documents/MATLAB/mycode/sodium_pipeline/run_sodium_pipeline_nascar.py "$ARG1" "$ARG2" "$ARG3" "$REF_BASENAME"

# Check that all three paths exist
for d in "$ARG4"; do
    if [ ! -d "$d" ]; then
        echo "Error: directory $d does not exist."
        exit 1
    fi
done

echo "Running sodium NASCAR MNI pipeline for $SUBJECT"
python3 /Users/ppzma/Documents/MATLAB/mycode/sodium_pipeline/run_sodium_pipeline_nascar_to_mni.py "$ARG4" "$REF_BASENAME"

#echo "atlas rois"
#python3 /Users/ppzma/Documents/MATLAB/mycode/sodium_pipeline/run_sodium_pipeline_atlasread.py




