#! /bin/bash

subjectlist="sub-17"
MOUNT="/Volumes/hermes/fRAT_analysis/"

for subject in $subjectlist
do
	echo ${subject}
    cd ${MOUNT}/${subject}/

    fslchfiletype NIFTI touchmap_pa_WIP_TW_forward_MB3_SENSE_9_1_RCR P17_RS1p5_fwd_grp0_btx1_rh
    fslchfiletype NIFTI touchmap_pa_WIP_TW_reverse_MB3_SENSE_10_1_RCR P17_RS1p5_rev_grp0_btx1_rh
    fslchfiletype NIFTI touchmap_pa_WIP_TW_forward_MB3_SENSE_11_1_RCR P17_RS1p5_fwd_grp0_btx1_lh
    fslchfiletype NIFTI touchmap_pa_WIP_TW_reverse_MB3_SENSE_12_1_RCR P17_RS1p5_rev_grp0_btx1_lh
    fslchfiletype NIFTI tw1_toppedup P17_RS1p5_fwd_grp0_btx2_rh
    fslchfiletype NIFTI tw2_toppedup P17_RS1p5_rev_grp0_btx2_rh
    fslchfiletype NIFTI tw3_toppedup P17_RS1p5_fwd_grp0_btx2_lh
    fslchfiletype NIFTI tw4_toppedup P17_RS1p5_rev_grp0_btx2_lh

done



