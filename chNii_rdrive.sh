#!/bin/sh
#subjectlist="00393 03677 10301 11120 11753"
#subjectlist="00393 03677 04217 08740 08966 09621 10289 10301 10320 10329 10654 10875 11120 11251 11753 HB3"
#subjectlist="06447 HB2 HB4 HB5"
subjectlist="14001_showonsurface"
#subjectlist="00393 00791 03677 03942 13287 13172 13945 13382 13382_pre 13447 13493 13493_pre 13654 13654_pre 13658 13658_pre 13695 13695_pre 14001 14001_pre"
MOUNT="TOUCHMAP"
for subject in $subjectlist
do
    echo $subject
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/LD1 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/LD1
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/LD2 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/LD2
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/LD3 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/LD3
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/LD4 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/LD4
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/LD5 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/LD5

    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/RD1 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/RD1
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/RD2 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/RD2
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/RD3 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/RD3
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/RD4 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/RD4
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/RD5 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/RD5

    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/LD1 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/LD1
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/LD2 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/LD2
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/LD3 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/LD3
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/LD4 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/LD4
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/LD5 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/LD5

    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/RD1 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/RD1
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/RD2 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/RD2
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/RD3 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/RD3
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/RD4 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/RD4
    fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/RD5 /Volumes/$MOUNT/ma/DigitAtlasv2/${subject}/2mm/RD5

    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/LD1 /Volumes/$MOUNT/ma/${subject}/LD1
    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/LD2 /Volumes/$MOUNT/ma/${subject}/LD2
    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/LD3 /Volumes/$MOUNT/ma/${subject}/LD3
    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/LD4 /Volumes/$MOUNT/ma/${subject}/LD4
    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/LD5 /Volumes/$MOUNT/ma/${subject}/LD5
    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/index_LD /Volumes/$MOUNT/ma/${subject}/index_LD
    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/ph_LD_masked /Volumes/$MOUNT/ma/${subject}/ph_LD_masked

    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/RD1 /Volumes/$MOUNT/ma/${subject}/RD1
    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/RD2 /Volumes/$MOUNT/ma/${subject}/RD2
    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/RD3 /Volumes/$MOUNT/ma/${subject}/RD3
    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/RD4 /Volumes/$MOUNT/ma/${subject}/RD4
    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/RD5 /Volumes/$MOUNT/ma/${subject}/RD5
    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/index_RD /Volumes/$MOUNT/ma/${subject}/index_RD
    # fslchfiletype NIFTI_GZ /Volumes/$MOUNT/ma/${subject}/ph_RD_masked /Volumes/$MOUNT/ma/${subject}/ph_RD_masked

    #fslchfiletype NIFTI_GZ $subject/LHand_Digits


    # fslchfiletype NIFTI_GZ ${subject}/motortopy/RD1 /Volumes/TOUCHMAP/ma/DigitAtlasv2/${subject}/motortopy/RD1
    # fslchfiletype NIFTI_GZ ${subject}/motortopy/RD2 /Volumes/TOUCHMAP/ma/DigitAtlasv2/${subject}/motortopy/RD2
    # fslchfiletype NIFTI_GZ ${subject}/motortopy/RD3 /Volumes/TOUCHMAP/ma/DigitAtlasv2/${subject}/motortopy/RD3
    # fslchfiletype NIFTI_GZ ${subject}/motortopy/RD4 /Volumes/TOUCHMAP/ma/DigitAtlasv2/${subject}/motortopy/RD4
    # fslchfiletype NIFTI_GZ ${subject}/motortopy/RD5 /Volumes/TOUCHMAP/ma/DigitAtlasv2/${subject}/motortopy/RD5
    #fslchfiletype NIFTI_GZ ${subject}/RHand_Digits


  #if [ "$suibject" = "Tomato" ] || [ "$subject" = "Peach" ]
  #then
  #    echo "I like ${subject}es"
  # else 
  #    echo "I like ${subject}s"
  # fi
done