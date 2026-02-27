#!/bin/bash
set -e

# Define base path
BASE_PATH="/Volumes/kratos/CANAPI/"
optibetPath="/Users/ppzma/Documents/MATLAB/optibet.sh"
# List of subjects
SUBJECTS=(
  "canapi_sub15"
  "canapi_sub16"
)

for subj in "${SUBJECTS[@]}"; do
	echo "Now running optibet on subject $subj"
	mprageFile=${BASE_PATH}/${subj}/structurals/*MPRAGE*.nii
	echo $mprageFile

	sh "$optibetPath" -i "$mprageFile"

done
