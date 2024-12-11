#!/bin/bash
source $FREESURFER_HOME/SetUpFreeSurfer.sh 
export SUBJECTS_DIR=/Volumes/DRS-7TfMRI/DigitAtlas/FreeSurferDigitAtlas/

# Define paths and subject folders
MOUNT='/Volumes/DRS-7TfMRI/DigitAtlas/TWmaps_masks/'
subjects=(00393_LD_extra 00393_RD_extra 03677_LD_extra 03677_RD_extra 04217_LD_extra 04217_RD_extra 06447_BH_LD_extra 06447_BH_RD_extra 08740_LD_extra 08740_RD_extra 08966_LD_extra 08966_RD_extra 09621_LD_extra 09621_RD_extra 10289_LD_extra 10289_RD_extra 10301_LD_extra 10301_RD_extra 10320_LD_extra 10320_RD_extra 10329_LD_extra 10329_RD_extra 10654_LD_extra 10654_RD_extra 10875_LD_extra 10875_RD_extra 11120_LD_extra 11120_RD_extra 11240_LD_extra 11240_RD_extra 11251_LD_extra 11251_RD_extra 11753_LD_extra 11753_RD_extra HB1_BH_LD_extra HB1_BH_RD_extra HB2_BH_LD_extra HB2_BH_RD_extra HB3_LD_extra HB3_RD_extra HB4_BH_LD_extra HB4_BH_RD_extra HB5_BH_LD_extra HB5_BH_RD_extra)
anatsubs=(00393 00393 03677 03677 04217_bis 04217_bis 06447 06447 08740 08740 08966 08966 09621 09621 10289 10289 10301 10301 10320 10320 10329 10329 10654 10654 10875 10875 11120 11120 11240 11240 11251 11251 11753 11753 HB1 HB1 HB2 HB2 HB3 HB3 HB4 HB4 HB5 HB5)


# Define phase bin ranges and names
#phase_bins=("0_1_57" "1_57_3_14" "3_14_4_71" "4_71_6_28")
#phases=(0 1.57 3.14 4.71 6.28)

phase_bins=("bin1" "bin2" "bin3" "bin4" "bin5")
phases=(0 1.256 2.512 3.768 5.024 6.28)

### Now move everything to fsaverage
# Step 1: Process phase-binned coherence-thresholded images

for ((i=0; i<${#subjects[@]}; i++))
do


  subject="${subjects[i]}"
  anatsub="${anatsubs[i]}"

  # Determine the hemisphere based on the subject string
  if [[ "$subject" == *_LD_* ]]; then
    hemi="rh"
  elif [[ "$subject" == *_RD_* ]]; then
    hemi="lh"
  else
    echo "Error: Unknown hemisphere designation for $subject"
    exit 1
  fi



  for phase_bin in "${phase_bins[@]}"
  do

    echo "Mapping volume to surface for subject: $subject, bin: $phase_bin, hemisphere: $hemi"
    
    input_file=${MOUNT}/${subject}/co_masked_${phase_bin}_co_thresh.nii.gz
    output_mgh=${MOUNT}/${subject}/co_masked_${phase_bin}_co_thresh.mgh
    fsaverage_mgh=${MOUNT}/${subject}/co_masked_${phase_bin}_co_thresh_fsaverage.mgh

    # Map volume to subject's surface in native space
    mri_vol2surf --hemi ${hemi} \
                 --mov $input_file \
                 --regheader ${anatsub} \
                 --projfrac-avg 0.1 1 0.1 \
                 --surf-fwhm 1 \
                 --out $output_mgh \
                 --surf white \
                 --out_type mgh

    # Map to fsaverage
    mri_surf2surf --srcsubject $anatsub \
                  --trgsubject fsaverage \
                  --hemi ${hemi} \
                  --sval $output_mgh \
                  --tval $fsaverage_mgh

  done

  echo "STAGE 1 Finished processing subject: $subject with anatomical subject: $anatsub"

done
