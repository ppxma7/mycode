#!/bin/bash
set -e

# Define base path
BASE_PATH="/Volumes/kratos/CANAPI/"
optibetPath="/Users/ppzma/Documents/MATLAB/optibet.sh"
# List of subjects
SUBJECTS=(
  "canapi_sub13"
  "canapi_sub14"
)

for subj in "${SUBJECTS[@]}"; do
	echo "Now running optibet on subject $subj"
	mprageFile=${BASE_PATH}/${subj}/structurals/*MPRAGE*.nii
	echo $mprageFile

	sh "$optibetPath" -i "$mprageFile"
	
	# Check that file exists
    # if [ -f "$mprageFile" ]; then
    #     echo "Found $mprageFile"
    #     #sh "$optibetPath" -i "$mprageFile"
    #     echo "optibet complete for subject $subj"
    # else
    #     echo "No MPRAGE file found for $subj"
    # fi

done
