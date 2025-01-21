#! /bin/bash

mypath="/Volumes/styx/"
mysub="fMRI_benchmark_v2_161023/"
#mysub="230117_prf12"
mydata="fRAT_analysis/sub-01/func/"
# myscans="tgi_sub_04_12778_221124_WIPThermode-fMRI1_20221124145248_8_nordic.nii
#     tgi_sub_04_12778_221124_WIPThermode-fMRI1_20221124145248_11_nordic.nii
#     tgi_sub_04_12778_221124_WIPThermode-fMRI1_20221124145248_9_nordic.nii
#     tgi_sub_04_12778_221124_WIPThermode-fMRI1_20221124145248_10_nordic.nii
#     tgi_sub_04_12778_221124_WIPTGI1_20221124145248_4_nordic.nii
#     tgi_sub_04_12778_221124_WIPTGI2_20221124145248_5_nordic.nii
#     tgi_sub_04_12778_221124_WIPThermode-TOPUP_20221124145248_6"
# myscans="parrec_fwd_20230117095811_7_nordic.nii
#     parrec_rev_20230117095811_8_nordic.nii
#     parrec_up_20230117095811_9_nordic.nii
#     parrec_dwn_20230117095811_10_nordic.nii
#     parrec_up_20230117095811_11_nordic.nii
#     parrec_dwn_20230117095811_12_nordic.nii
#     parrec_up_20230117095811_14_nordic.nii
#     parrec_dwn_20230117095811_15_nordic.nii
#     parrec_topupa_20230117095811_13.nii"

#myscans="leftover_thermode_armblock1_20230213101502_25_nordic"

myscans="CO2_NORD2_mtx_RET2_inotopy_1p5mm_iso_TR2_perpcalc_20231016151649_15_nordic.nii
	CO2_NORD2_mtx_S2_ensorimotor_1p25mm_iso_TR2_20231016151649_19_nordic.nii
	CO2_NORD2_mtx_WH2_holeHead_rsfMRI_2mm_iso_TR1p5_20231016151649_14_nordic.nii
	CO2_NORD2_mtx_PH2_artialHead_rsfMRI_1p25mm_iso_TR1_20231016151649_18_nordic.nii
	CO2_NORD2_mtx_M2_otor_TW_fwd_20231016151649_21_nordic.nii
	CO1_NORD2_classic_WH1_holeHead_rsfMRI_2mm_iso_TR1p5_20231016140529_9_nordic.nii
	CO1_NORD2_classic_S1_ensorimotor_1p25mm_iso_TR2_20231016140529_14_nordic.nii
	CO1_NORD2_classic_RET1_inotopy_1p5mm_iso_TR2_perpcalc_20231016140529_10_nordic.nii
	CO1_NORD2_classic_PH1_artialHead_rsfMRI_1p25mm_iso_TR1_20231016140529_13_nordic.nii
	CO1_NORD2_classic_M1_otor_TW_fwd_20231016140529_18_nordic.nii
	CO2_NORD1_mtx_M2_otor_TW_fwd_20231016151649_21.nii
	CO2_NORD1_mtx_PH2_artialHead_rsfMRI_1p25mm_iso_TR1_20231016151649_18.nii
	CO2_NORD1_mtx_WH2_holeHead_rsfMRI_2mm_iso_TR1p5_20231016151649_14.nii
	CO2_NORD1_mtx_S2_ensorimotor_1p25mm_iso_TR2_20231016151649_19.nii
	CO2_NORD1_mtx_RET2_inotopy_1p5mm_iso_TR2_perpcalc_20231016151649_15.nii
	CO1_NORD1_classic_M1_otor_TW_fwd_20231016140529_18.nii
	CO1_NORD1_classic_PH1_artialHead_rsfMRI_1p25mm_iso_TR1_20231016140529_13.nii
	CO1_NORD1_classic_RET1_inotopy_1p5mm_iso_TR2_perpcalc_20231016140529_10.nii
	CO1_NORD1_classic_WH1_holeHead_rsfMRI_2mm_iso_TR1p5_20231016140529_9.nii
	CO1_NORD1_classic_S1_ensorimotor_1p25mm_iso_TR2_20231016140529_14.nii"

#sizes=(96 96 96 96 96 96 96 96 300 300 150 150 155 150 150 155 300 150 155 5 4 4 4 4)
sizes=(20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20)
#sizes=(96 96 96 96 96 96 96 96 5)
#sizes=(310 310 310 310 308 308 4)
#sizes=(155 150 150 4)
COUNTER=0

echo "cleaving the noise scan"

for subject in $mysub
do
	cd ${mypath}/${subject}/${mydata}/

	for scan in $myscans
	do

		#echo $scan
		trimmed=$(echo "$scan" | cut -f 1 -d '.')
		echo $trimmed
		#fslroi $scan ${trimmed}_clv 0 
		echo ${sizes[$COUNTER]}

		fslroi $scan ${trimmed}_clv 0 ${sizes[$COUNTER]}


		COUNTER=$[$COUNTER+1]
	done



done


