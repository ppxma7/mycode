#!/bin/bash
cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh 
MOUNT='/Volumes/arianthe/prf_smoothed_1p5mm/'
export SUBJECTS_DIR=/Volumes/ares/subs/

#subjectlist=("11251")
subjectlist=("15874" "12778_psir_1mm" "15435_psir_1mm" "11251" "15252_psir_1mm" "11766" "14359")
#fMRIdatalist=("211011_prf7")
fMRIdatalist=("15874_prf13" "210922_prf3" "211004_prf6" "211011_prf7" "211207_prf10" "211215_prf11" "260821_prf_14359")

for index in ${!subjectlist[@]}
do
    echo ${MOUNT}${fMRIdatalist[$index]}/visualisation/
    echo ${SUBJECTS_DIR}${subjectlist[$index]}

    cd ${MOUNT}${fMRIdatalist[$index]}/visualisation/
    sh /Users/ppzma/Documents/MATLAB/nottingham/bin/chNii_all.sh


    mri_vol2surf --hemi lh --mov ${MOUNT}${fMRIdatalist[$index]}/visualisation/digitmap_ph_masked.nii.gz --regheader ${subjectlist[$index]} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}${fMRIdatalist[$index]}/visualisation/digitmap_ph_masked.mgh --surf white --out_type mgh
    mri_surf2surf --srcsubject ${subjectlist[$index]} --trgsubject fsaverage --hemi lh --sval ${MOUNT}${fMRIdatalist[$index]}/visualisation/digitmap_ph_masked.mgh --tval ${MOUNT}${fMRIdatalist[$index]}/visualisation/digitmap_ph_masked_fsaverage.mgh
    mri_vol2surf --hemi lh --mov ${MOUNT}${fMRIdatalist[$index]}/visualisation/digitmap_co_masked.nii.gz --regheader ${subjectlist[$index]} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}${fMRIdatalist[$index]}/visualisation/digitmap_co_masked.mgh --surf white --out_type mgh
    mri_surf2surf --srcsubject ${subjectlist[$index]} --trgsubject fsaverage --hemi lh --sval ${MOUNT}${fMRIdatalist[$index]}/visualisation/digitmap_co_masked.mgh --tval ${MOUNT}${fMRIdatalist[$index]}/visualisation/digitmap_co_masked_fsaverage.mgh

    mri_vol2surf --hemi lh --mov ${MOUNT}${fMRIdatalist[$index]}/visualisation/BA3a.nii.gz --regheader ${subjectlist[$index]} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}${fMRIdatalist[$index]}/visualisation/BA3a.mgh --surf white --out_type mgh
    mri_surf2surf --srcsubject ${subjectlist[$index]} --trgsubject fsaverage --hemi lh --sval ${MOUNT}${fMRIdatalist[$index]}/visualisation/BA3a.mgh --tval ${MOUNT}${fMRIdatalist[$index]}/visualisation/BA3a_fsaverage.mgh

    # mri_vol2surf --hemi lh --mov ${MOUNT}/digitmap_ph.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/digitmap_ph.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval ${MOUNT}/digitmap_ph.mgh --tval ${MOUNT}/digitmap_ph_fsaverage.mgh
    # mri_vol2surf --hemi lh --mov ${MOUNT}/digitmap_co.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/digitmap_co.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval ${MOUNT}/digitmap_co.mgh --tval ${MOUNT}/digitmap_co_fsaverage.mgh

    # mri_vol2surf --hemi lh --mov ${MOUNT}/BA3A.nii.gz --regheader ${subject} --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/BA3A.mgh --surf white --out_type mgh
    # mri_surf2surf --srcsubject $subject --trgsubject fsaverage --hemi lh --sval ${MOUNT}/BA3A.mgh --tval ${MOUNT}/BA3A_fsaverage.mgh
done
echo "Done!"

