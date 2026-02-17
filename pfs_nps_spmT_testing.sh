#!/usr/bin/env bash
set -e

echo "====  Threshold SPM at 2.3 and 3.1 ===="
fslmaths spmT_0003.nii.gz -thr 2.3 spmT_2p3.nii.gz
fslmaths spmT_0003.nii.gz -thr 3.1 spmT_3p1.nii.gz
fslmaths spmT_0003.nii.gz -thr 1.96 spmT_1p96.nii.gz

echo "==== Binary SPM maps ===="
fslmaths spmT_2p3.nii.gz -bin spmT_2p3_bin.nii.gz
fslmaths spmT_3p1.nii.gz -bin spmT_3p1_bin.nii.gz
fslmaths spmT_1p96.nii.gz -bin spmT_1p96_bin.nii.gz

echo "==== Create NPS positive and negative maps ===="
# Positive weights
fslmaths weights_NSF_grouppred_cvpcr.nii -thr 0 nps_pos.nii.gz

# Negative weights
fslmaths weights_NSF_grouppred_cvpcr.nii -uthr 0 nps_neg.nii.gz
fslmaths nps_neg.nii.gz -abs nps_neg_abs.nii.gz

echo "==== Binarise NPS maps ===="
fslmaths nps_pos.nii.gz -bin nps_pos_bin.nii.gz
fslmaths nps_neg_abs.nii.gz -bin nps_neg_bin.nii.gz

sleep 2 
echo "====  Resample NPS to SPM (2mm grid) ===="

# Positive

flirt -in nps_pos_bin.nii.gz \
-ref spmT_2p3_bin.nii.gz \
-applyxfm -usesqform \
-interp nearestneighbour \
-out nps_pos_bin_2mm.nii.gz

# Negative

flirt -in nps_neg_bin.nii.gz \
-ref spmT_2p3_bin.nii.gz \
-applyxfm -usesqform \
-interp nearestneighbour \
-out nps_neg_bin_2mm.nii.gz

echo "====  Subtract NPS from SPM (2.3 threshold) ===="
# remove positive NPS from SPM
fslmaths spmT_2p3_bin.nii.gz -sub nps_pos_bin_2mm.nii.gz spm2p3_minus_pos.nii.gz

# remove negative NPS from SPM
fslmaths spmT_2p3_bin.nii.gz -sub nps_neg_bin_2mm.nii.gz spm2p3_minus_neg.nii.gz

# remove both NPS from SPM
fslmaths spm2p3_minus_pos.nii.gz -sub nps_neg_bin_2mm.nii.gz spm2p3_minus_posneg.nii.gz

# binarise cleaned results

fslmaths spm2p3_minus_pos.nii.gz -thr 0.5 -bin spm2p3_minus_pos_bin.nii.gz
fslmaths spm2p3_minus_neg.nii.gz -thr 0.5 -bin spm2p3_minus_neg_bin.nii.gz
fslmaths spm2p3_minus_posneg.nii.gz -thr 0.5 -bin spm2p3_minus_posneg_bin.nii.gz

echo "====  Subtract NPS from SPM (3.1 threshold) ===="

fslmaths spmT_3p1_bin.nii.gz -sub nps_pos_bin_2mm.nii.gz spm3p1_minus_pos.nii.gz
fslmaths spmT_3p1_bin.nii.gz -sub nps_neg_bin_2mm.nii.gz spm3p1_minus_neg.nii.gz
fslmaths spm3p1_minus_pos.nii.gz -sub nps_neg_bin_2mm.nii.gz spm3p1_minus_posneg.nii.gz

fslmaths spm3p1_minus_pos.nii.gz -thr 0.5 -bin spm3p1_minus_pos_bin.nii.gz
fslmaths spm3p1_minus_neg.nii.gz -thr 0.5 -bin spm3p1_minus_neg_bin.nii.gz
fslmaths spm3p1_minus_posneg.nii.gz -thr 0.5 -bin spm3p1_minus_posneg_bin.nii.gz

echo "====  Mask the OG :) ===="

fslmaths spmT_2p3.nii.gz -mas spm2p3_minus_posneg_bin.nii.gz spm2p3_masked
fslmaths spmT_3p1.nii.gz -mas spm3p1_minus_posneg_bin.nii.gz spm3p1_masked


# Should also do the opposite way
fslmaths nps_pos_bin_2mm.nii.gz -sub spmT_1p96_bin.nii.gz NPS_pos_minus_spmT_1p96.nii.gz
fslmaths nps_pos_bin_2mm.nii.gz -sub spmT_2p3_bin.nii.gz NPS_pos_minus_spmT_2p3.nii.gz
fslmaths nps_pos_bin_2mm.nii.gz -sub spmT_3p1_bin.nii.gz NPS_pos_minus_spmT_3p1.nii.gz
fslmaths NPS_pos_minus_spmT_1p96.nii.gz -thr 0.5 -bin NPS_pos_minus_spmT_1p96_bin
fslmaths NPS_pos_minus_spmT_2p3.nii.gz -thr 0.5 -bin NPS_pos_minus_spmT_2p3_bin
fslmaths NPS_pos_minus_spmT_3p1.nii.gz -thr 0.5 -bin NPS_pos_minus_spmT_3p1_bin








echo "DONE"
