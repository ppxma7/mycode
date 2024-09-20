#!/bin/bash


sub="230117_prf12"
anatsub="15874"
rpath="/Volumes/DRS-Touchmap/ma_ares_backup/"
lpath="/Volumes/arianthe/"
anatpath="/Volumes/arianthe/freesurfer/"
fwdscan="parrec_fwd_20230117095811_7_nordic_clv_toppedupabs.nii"
revscan="parrec_rev_20230117095811_8_nordic_clv_toppedupabs.nii"
#matfile=""


cd ${lpath}
if [ ! -d "$sub" ]
	then 
		echo "Making func dirs..."
		mkdir "${lpath}${sub}"
		mkdir "${lpath}${sub}"/Raw/""
		mkdir "${lpath}${sub}"/Raw/TSeries/""
		mkdir "${lpath}${sub}"/ROIs/""
		mkdir "${lpath}${sub}"/misc/""
		#mkdir "${lpath}${sub}"/correctedAvg/""
		rsync -azv ${rpath}${sub}/Raw/TSeries/${fwdscan} ${lpath}${sub}/Raw/TSeries/
		rsync -azv ${rpath}${sub}/Raw/TSeries/${revscan} ${lpath}${sub}/Raw/TSeries/
		#rsync -azv ${rpath}${sub}/Raw/TSeries/${matfile} ${lpath}${sub}/Raw/TSeries/
		rsync -azv ${rpath}${sub}/ROIs/ ${lpath}${sub}/ROIs/
		rsync -azv ${rpath}${sub}/misc/ ${lpath}${sub}/misc/
		#rsync -azv ${rpath}${sub}/correctedAvg_fwd/ ${lpath}${sub}/correctedAvg_fwd/
		rsync -azv ${rpath}${sub}/mrSession.mat ${lpath}${sub}/
		rsync -azv ${rpath}${sub}/mrLastView.mat ${lpath}${sub}/
fi

cd ${anatpath}
if [ ! -d "$anatsub" ]
	then
		echo "Making anat dirs..."
		mkdir "${anatpath}${anatsub}"
		mkdir "${anatpath}${anatsub}"/surf/""
		mkdir "${anatpath}${anatsub}"/surfRelax/""
		mkdir "${anatpath}${anatsub}"/label/""
		rsync -azv ${rpath}subs/${anatsub}/surf/ ${anatpath}${anatsub}/surf/
		rsync -azv ${rpath}subs/${anatsub}/surfRelax/ ${anatpath}${anatsub}/surfRelax/
		rsync -azv ${rpath}subs/${anatsub}/label/ ${anatpath}${anatsub}/label/
fi












