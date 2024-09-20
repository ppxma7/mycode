#!/bin/sh
#subjectlist="00393 03677 10301 11120 11753"
subjectlist="not cam car gla oxf"


for subject in $subjectlist
do
    echo $subject
    fslchfiletype NIFTI_GZ co_RD_masked_$subject co_RD_masked_$subject
    fslchfiletype NIFTI_GZ ph_RD_masked_$subject ph_RD_masked_$subject


done