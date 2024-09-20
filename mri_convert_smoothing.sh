#!/bin/bash
for f in *.nii
do
	echo "mri_convert smoothing to 2mm"

	f_var=$(echo "${f}" | cut -f 1 -d '.')
	echo $f_var
	mri_convert -vs 2 2 2 $f_var.nii ${f_var}_2mm.nii
	#echo $f_var.nii ${f_var}_2mm.nii

done
