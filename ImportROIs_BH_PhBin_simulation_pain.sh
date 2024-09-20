#!/bin/bash
cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh 
MOUNT='/Volumes/arianthe/PAIN/'
export SUBJECTS_DIR=/Volumes/ares/subs/

subjectlist=("15874")
#subjectlist=("12778_psir_1mm" "15435_psir_1mm" "11251" "14359" "11766" "15252_psir_1mm" "15874")
fMRIdatalist=("tgi_sub_05_15874_230622")
#fMRIdatalist=("pain_01_12778_221117" "pain_02_15435_221117" "pain_03_11251_221129" "pain_04_14359_230110" "pain_05_11766_230123" "pain_06_15252_230126" "pain_07_15874_230213")

for index in ${!subjectlist[@]}
do
    echo ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/
    echo ${SUBJECTS_DIR}${subjectlist[$index]}

    cd ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/
    sh /Users/ppzma/Documents/MATLAB/nottingham/bin/chNii_all.sh


    mri_vol2surf --hemi lh --mov ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/hand.nii.gz --regheader ${subjectlist[$index]} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/hand.mgh --surf white --out_type mgh
    mri_surf2surf --srcsubject ${subjectlist[$index]} --trgsubject fsaverage --hemi lh --sval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/hand.mgh --tval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/hand_fsaverage.mgh

    # mri_vol2surf --hemi lh --mov ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/hand_pos.nii.gz --regheader ${subjectlist[$index]} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/hand_pos.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject ${subjectlist[$index]} --trgsubject fsaverage --hemi lh --sval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/hand_pos.mgh --tval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/hand_pos_fsaverage.mgh

    # mri_vol2surf --hemi lh --mov ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/hand_neg.nii.gz --regheader ${subjectlist[$index]} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/hand_neg.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject ${subjectlist[$index]} --trgsubject fsaverage --hemi lh --sval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/hand_neg.mgh --tval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/hand_neg_fsaverage.mgh

    # mri_vol2surf --hemi lh --mov ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/arm_pos.nii.gz --regheader ${subjectlist[$index]} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/arm_pos.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject ${subjectlist[$index]} --trgsubject fsaverage --hemi lh --sval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/arm_pos.mgh --tval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/arm_pos_fsaverage.mgh

    # mri_vol2surf --hemi lh --mov ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/arm_neg.nii.gz --regheader ${subjectlist[$index]} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/arm_neg.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject ${subjectlist[$index]} --trgsubject fsaverage --hemi lh --sval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/arm_neg.mgh --tval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/arm_neg_fsaverage.mgh

    mri_vol2surf --hemi lh --mov ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/arm.nii.gz --regheader ${subjectlist[$index]} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/arm.mgh --surf white --out_type mgh
    mri_surf2surf --srcsubject ${subjectlist[$index]} --trgsubject fsaverage --hemi lh --sval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/arm.mgh --tval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/arm_fsaverage.mgh

    # mri_vol2surf --hemi lh --mov ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/armpost.nii.gz --regheader ${subjectlist[$index]} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/armpost.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject ${subjectlist[$index]} --trgsubject fsaverage --hemi lh --sval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/armpost.mgh --tval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/armpost_fsaverage.mgh

    # mri_vol2surf --hemi lh --mov ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/armpost_pos.nii.gz --regheader ${subjectlist[$index]} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/armpost_pos.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject ${subjectlist[$index]} --trgsubject fsaverage --hemi lh --sval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/armpost_pos.mgh --tval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/armpost_pos_fsaverage.mgh

    # mri_vol2surf --hemi lh --mov ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/armpost_neg.nii.gz --regheader ${subjectlist[$index]} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/armpost_neg.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject ${subjectlist[$index]} --trgsubject fsaverage --hemi lh --sval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/armpost_neg.mgh --tval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/armpost_neg_fsaverage.mgh

    mri_vol2surf --hemi lh --mov ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/BA3a.nii.gz --regheader ${subjectlist[$index]} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/BA3a.mgh --surf white --out_type mgh
    mri_surf2surf --srcsubject ${subjectlist[$index]} --trgsubject fsaverage --hemi lh --sval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/BA3a.mgh --tval ${MOUNT}${fMRIdatalist[$index]}/processed_data_mrtools/visualisation/BA3a_fsaverage.mgh

    # mri_vol2surf --hemi lh --mov ${MOUNT}/digitmap_ph.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/digitmap_ph.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval ${MOUNT}/digitmap_ph.mgh --tval ${MOUNT}/digitmap_ph_fsaverage.mgh
    # mri_vol2surf --hemi lh --mov ${MOUNT}/digitmap_co.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/digitmap_co.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval ${MOUNT}/digitmap_co.mgh --tval ${MOUNT}/digitmap_co_fsaverage.mgh

    # mri_vol2surf --hemi lh --mov ${MOUNT}/BA3A.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/BA3A.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval ${MOUNT}/BA3A.mgh --tval ${MOUNT}/BA3A_fsaverage.mgh
done
echo "Done!"

