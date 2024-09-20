#!/bin/sh
MOUNT='/Volumes/hades/201009_03677_tw_test/parrecjson/'

subjectlist="fph fma sc5 sc6 sc7 sc8 sc9"
for subject in $subjectlist
do
    echo $subject
    fslchfiletype NIFTI_PAIR ${MOUNT}${subject} ${MOUNT}${subject}
done