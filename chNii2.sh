#!/bin/sh
#subjectlist="00393 03677 10301 11120 11753"
#subjectlist="00393 03677 04217 08740 08966 09621 10289 10301 10320 10329 10654 10875 11120 11251 11753 HB3"
#subjectlist="06447 HB2 HB4 HB5"
subjectlist="00791"

for subject in $subjectlist
do
    echo $subject
    fslchfiletype NIFTI_GZ ${subject}/LD1 /Volumes/data/Research/TOUCHMAP/ma/DigitAtlasv2/${subject}/LD1
    fslchfiletype NIFTI_GZ ${subject}/LD2 /Volumes/data/Research/TOUCHMAP/ma/DigitAtlasv2/${subject}/LD2
    fslchfiletype NIFTI_GZ ${subject}/LD3 /Volumes/data/Research/TOUCHMAP/ma/DigitAtlasv2/${subject}/LD3
    fslchfiletype NIFTI_GZ ${subject}/LD4 /Volumes/data/Research/TOUCHMAP/ma/DigitAtlasv2/${subject}/LD4
    fslchfiletype NIFTI_GZ ${subject}/LD5 /Volumes/data/Research/TOUCHMAP/ma/DigitAtlasv2/${subject}/LD5
    #fslchfiletype NIFTI_GZ $subject/LHand_Digits


    fslchfiletype NIFTI_GZ ${subject}/RD1 /Volumes/data/Research/TOUCHMAP/ma/DigitAtlasv2/${subject}/RD1
    fslchfiletype NIFTI_GZ ${subject}/RD2 /Volumes/data/Research/TOUCHMAP/ma/DigitAtlasv2/${subject}/RD2
    fslchfiletype NIFTI_GZ ${subject}/RD3 /Volumes/data/Research/TOUCHMAP/ma/DigitAtlasv2/${subject}/RD3
    fslchfiletype NIFTI_GZ ${subject}/RD4 /Volumes/data/Research/TOUCHMAP/ma/DigitAtlasv2/${subject}/RD4
    fslchfiletype NIFTI_GZ ${subject}/RD5 /Volumes/data/Research/TOUCHMAP/ma/DigitAtlasv2/${subject}/RD5
    #fslchfiletype NIFTI_GZ ${subject}/RHand_Digits


  #if [ "$suibject" = "Tomato" ] || [ "$subject" = "Peach" ]
  #then
  #    echo "I like ${subject}es"
  # else 
  #    echo "I like ${subject}s"
  # fi
done