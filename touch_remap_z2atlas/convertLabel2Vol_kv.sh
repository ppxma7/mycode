#!/bin/bash

cd ~
source $FREESURFER_HOME/SetUpFreeSurfer.sh 
#MOUNT='/Volumes/nemosine/subs/'
MOUNT="/Volumes/arianthe/exp016/freesurfer/"
#export SUBJECTS_DIR=/Volumes/nemosine/subs/
export SUBJECTS_DIR=${MOUNT}
#subjectlist="03677 14359 12778_psir_1mm 10925 15435_psir_1mm 11251 15123 14446 15252_psir_1mm 11766"
#subjectlist="00393 03677 04217_bis 06447 08740 08966 09621 10289 10301 10320 10329 10654 10875 11120 11240 11251 11753 HB1 HB2 HB3 HB4 HB5"
#subjectlist="14001"


# subjectlist="005 006 008 009 011 012 013 014 015 017 018 019 020 021 022 023 024 025 026 027 028\
#     029 030 031 032 033 034 035 036 037 038 039 040 041 042 043 045 046 047 049 050 051 052 054\
#     055 056 059"

#subjectlist="009 011 012 013 014 015 017 018 020"
#subjectlist="026 034 039 046 063"
#subjectlist='057 060 061 063 064'
subjectlist='037 047 049 050 051 052 054 055 056 059 060 061 064'

for subject in $subjectlist
do
	echo $subject
	mri_label2vol --label ${MOUNT}/${subject}/label/lh.BA3a_exvivo.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/lh.BA3a_exvivo.label.volume.nii --identity
	mri_label2vol --label ${MOUNT}/${subject}/label/lh.BA3b_exvivo.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/lh.BA3b_exvivo.label.volume.nii --identity
    mri_label2vol --label ${MOUNT}/${subject}/label/lh.BA1_exvivo.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/lh.BA1_exvivo.label.volume.nii --identity
    mri_label2vol --label ${MOUNT}/${subject}/label/lh.BA2_exvivo.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/lh.BA2_exvivo.label.volume.nii --identity
    mri_label2vol --label ${MOUNT}/${subject}/label/lh.BA4a_exvivo.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/lh.BA4a_exvivo.label.volume.nii --identity
    mri_label2vol --label ${MOUNT}/${subject}/label/lh.BA4p_exvivo.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/lh.BA4p_exvivo.label.volume.nii --identity
    mri_label2vol --label ${MOUNT}/${subject}/label/lh.BA6_exvivo.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/lh.BA6_exvivo.label.volume.nii --identity

    mri_label2vol --label ${MOUNT}/${subject}/label/rh.BA3a_exvivo.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/rh.BA3a_exvivo.label.volume.nii --identity
    mri_label2vol --label ${MOUNT}/${subject}/label/rh.BA3b_exvivo.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/rh.BA3b_exvivo.label.volume.nii --identity
    mri_label2vol --label ${MOUNT}/${subject}/label/rh.BA1_exvivo.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/rh.BA1_exvivo.label.volume.nii --identity
    mri_label2vol --label ${MOUNT}/${subject}/label/rh.BA2_exvivo.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/rh.BA2_exvivo.label.volume.nii --identity
    mri_label2vol --label ${MOUNT}/${subject}/label/rh.BA4a_exvivo.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/rh.BA4a_exvivo.label.volume.nii --identity
    mri_label2vol --label ${MOUNT}/${subject}/label/rh.BA4p_exvivolabel --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/rh.BA4p_exvivo.label.volume.nii --identity
    mri_label2vol --label ${MOUNT}/${subject}/label/rh.BA6_exvivo.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/label/rh.BA6_exvivo.label.volume.nii --identity
done

for subject in $subjectlist
do
    echo $subject
    echo "Now we are building the ROIs using fslmaths"
    fslmaths ${MOUNT}/${subject}/label/lh.BA3a_exvivo.label.volume.nii -add ${MOUNT}/${subject}/label/lh.BA3b_exvivo.label.volume.nii -add ${MOUNT}/${subject}/label/lh.BA1_exvivo.label.volume.nii -add ${MOUNT}/${subject}/label/lh.BA2_exvivo.label.volume.nii ${MOUNT}/${subject}/label/lh_3ab12.nii
    fslmaths ${MOUNT}/${subject}/label/lh_3ab12.nii -div ${MOUNT}/${subject}/label/lh_3ab12.nii ${MOUNT}/${subject}/label/lh_3ab12_div.nii

    fslmaths ${MOUNT}/${subject}/label/rh.BA3a_exvivo.label.volume.nii -add ${MOUNT}/${subject}/label/rh.BA3b_exvivo.label.volume.nii -add ${MOUNT}/${subject}/label/rh.BA1_exvivo.label.volume.nii -add ${MOUNT}/${subject}/label/rh.BA2_exvivo.label.volume.nii ${MOUNT}/${subject}/label/rh_3ab12.nii
    fslmaths ${MOUNT}/${subject}/label/rh_3ab12.nii -div ${MOUNT}/${subject}/label/rh_3ab12.nii ${MOUNT}/${subject}/label/rh_3ab12_div.nii
done






# mri_annotation2label --subject ${subject}/ --hemi rh --outdir ${subject}/outputs/rh/ --annotation aparc --ctab FreeSurferColorLUT.txt
# mri_annotation2label --subject ${subject}/ --hemi lh --outdir ${subject}/outputs/lh/ --annotation aparc --ctab FreeSurferColorLUT.txt

# for subject in $subjectlist
# do
#     echo $subject
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.insula.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.insula.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.transversetemporal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.transversetemporal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.temporalpole.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.temporalpole.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.frontalpole.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.frontalpole.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.supramarginal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.supramarginal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.superiortemporal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.superiortemporal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.superiorparietal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.superiorparietal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.superiorfrontal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.superiorfrontal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.rostralmiddlefrontal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.rostralmiddlefrontal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.rostralanteriorcingulate.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.rostralanteriorcingulate.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.precuneus.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.precuneus.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.precentral.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.precentral.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.posteriorcingulate.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.posteriorcingulate.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.postcentral.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.postcentral.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.pericalcarine.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.pericalcarine.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.parstriangularis.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.parstriangularis.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.parsorbitalis.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.parsorbitalis.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.parsopercularis.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.parsopercularis.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.paracentral.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.paracentral.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.parahippocampal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.parahippocampal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.middletemporal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.middletemporal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.medialorbitofrontal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.medialorbitofrontal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.lingual.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.lingual.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.lateralorbitofrontal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.lateralorbitofrontal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.lateraloccipital.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.lateraloccipital.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.isthmuscingulate.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.isthmuscingulate.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.inferiortemporal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.inferiortemporal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.inferiorparietal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.inferiorparietal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.fusiform.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.fusiform.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.entorhinal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.entorhinal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.cuneus.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.cuneus.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.caudalmiddlefrontal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.caudalmiddlefrontal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.caudalanteriorcingulate.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.caudalanteriorcingulate.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/lh/lh.bankssts.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/lh/lh.bankssts.label.volume.nii --identity

#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.insula.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.insula.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.transversetemporal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.transversetemporal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.temporalpole.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.temporalpole.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.frontalpole.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.frontalpole.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.supramarginal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.supramarginal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.superiortemporal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.superiortemporal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.superiorparietal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.superiorparietal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.superiorfrontal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.superiorfrontal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.rostralmiddlefrontal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.rostralmiddlefrontal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.rostralanteriorcingulate.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.rostralanteriorcingulate.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.precuneus.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.precuneus.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.precentral.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.precentral.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.posteriorcingulate.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.posteriorcingulate.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.postcentral.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.postcentral.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.pericalcarine.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.pericalcarine.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.parstriangularis.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.parstriangularis.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.parsorbitalis.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.parsorbitalis.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.parsopercularis.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.parsopercularis.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.paracentral.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.paracentral.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.parahippocampal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.parahippocampal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.middletemporal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.middletemporal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.medialorbitofrontal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.medialorbitofrontal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.lingual.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.lingual.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.lateralorbitofrontal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.lateralorbitofrontal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.lateraloccipital.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.lateraloccipital.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.isthmuscingulate.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.isthmuscingulate.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.inferiortemporal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.inferiortemporal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.inferiorparietal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.inferiorparietal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.fusiform.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.fusiform.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.entorhinal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.entorhinal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.cuneus.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.cuneus.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.caudalmiddlefrontal.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.caudalmiddlefrontal.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.caudalanteriorcingulate.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.caudalanteriorcingulate.label.volume.nii --identity
#     mri_label2vol --label ${MOUNT}/${subject}/outputs/rh/rh.bankssts.label --temp ${MOUNT}/${subject}/mri/T1.mgz --o ${MOUNT}/${subject}/outputs/rh/rh.bankssts.label.volume.nii --identity
    
# done



# now more

















