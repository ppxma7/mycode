#!/bin/bash
for f in *.nii
do
	echo "chNii"
#	echo $f

	f_var=$(echo "${f}" | cut -f 1 -d '.')
	echo $f_var
	#fslchfiletype NIFTI "${f%%.*}" "${f}_ch"
	fslchfiletype NIFTI_GZ $f_var ${f_var}


done
