#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=8g
#SBATCH --time=128:00:00

echo "Running on `hostname`"
#module load ants-uon/binary/2.1.0
module load ants-uoneasy/2.3.5-foss-2021a
export SUBJECTS_DIR=/gpfs01/home/ppzma/subjects_dir/
export DATA_DIR=/gpfs01/home/ppzma/gbperm01/
export FAIR_DIR1=/FAIR1000_aslpp/
export FAIR_DIR2=/FAIR2000_aslpp/
export FAIR_DIR3=/FAIR3000_aslpp/
export FAIR_DIR4=/FAIR4000_aslpp/

echo "Now running ${FAIR_DIR1}"
subjectlist="10"
echo ${subject}

for subject in $subjectlist
do

	antsRegistration \
	--verbose 1 \
	--dimensionality 3 \
	--float 1 \
	--output [${DATA_DIR}/${FAIR_DIR1}/registered_,${DATA_DIR}/${FAIR_DIR1}/registered_Warped.nii.gz,${DATA_DIR}/${FAIR_DIR1}/registered_InverseWarped.nii.gz] \
	--interpolation Linear \
	--use-histogram-matching 0 \
	--winsorize-image-intensities [0.005,0.995] \
	--initial-moving-transform ${DATA_DIR}/${FAIR_DIR1}/itk_manual.txt \
	--transform Rigid[0.05] \
	--metric CC[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR1}/diffav.nii.gz,0.7,32,Regular,0.1] \
	--convergence [1000x500,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \
	--transform Affine[0.1] \
	--metric MI[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR1}/diffav.nii.gz,0.7,32,Regular,0.1] \
	--convergence [1000x500,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \
	--transform SyN[0.1,2,0] \
	--metric CC[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR1}/diffav.nii.gz,1,2] \
	--convergence [500x100,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \

done

echo "FAIR1000_aslpp completed"
echo "Now running ${FAIR_DIR2}"

for subject in $subjectlist
do

	antsRegistration \
	--verbose 1 \
	--dimensionality 3 \
	--float 1 \
	--output [${DATA_DIR}/${FAIR_DIR2}/registered_,${DATA_DIR}/${FAIR_DIR2}/registered_Warped.nii.gz,${DATA_DIR}/${FAIR_DIR2}/registered_InverseWarped.nii.gz] \
	--interpolation Linear \
	--use-histogram-matching 0 \
	--winsorize-image-intensities [0.005,0.995] \
	--initial-moving-transform ${DATA_DIR}/${FAIR_DIR2}/itk_manual.txt \
	--transform Rigid[0.05] \
	--metric CC[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR2}/diffav.nii.gz,0.7,32,Regular,0.1] \
	--convergence [1000x500,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \
	--transform Affine[0.1] \
	--metric MI[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR2}/diffav.nii.gz,0.7,32,Regular,0.1] \
	--convergence [1000x500,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \
	--transform SyN[0.1,2,0] \
	--metric CC[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR2}/diffav.nii.gz,1,2] \
	--convergence [500x100,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \

done

echo "FAIR2000_aslpp completed"
echo "Now running ${FAIR_DIR3}"


for subject in $subjectlist
do

	antsRegistration \
	--verbose 1 \
	--dimensionality 3 \
	--float 1 \
	--output [${DATA_DIR}/${FAIR_DIR3}/registered_,${DATA_DIR}/${FAIR_DIR3}/registered_Warped.nii.gz,${DATA_DIR}/${FAIR_DIR3}/registered_InverseWarped.nii.gz] \
	--interpolation Linear \
	--use-histogram-matching 0 \
	--winsorize-image-intensities [0.005,0.995] \
	--initial-moving-transform ${DATA_DIR}/${FAIR_DIR3}/itk_manual.txt \
	--transform Rigid[0.05] \
	--metric CC[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR3}/diffav.nii.gz,0.7,32,Regular,0.1] \
	--convergence [1000x500,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \
	--transform Affine[0.1] \
	--metric MI[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR3}/diffav.nii.gz,0.7,32,Regular,0.1] \
	--convergence [1000x500,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \
	--transform SyN[0.1,2,0] \
	--metric CC[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR3}/diffav.nii.gz,1,2] \
	--convergence [500x100,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \

done

echo "FAIR3000_aslpp completed"
echo "Now running ${FAIR_DIR4}"


for subject in $subjectlist
do

	antsRegistration \
	--verbose 1 \
	--dimensionality 3 \
	--float 1 \
	--output [${DATA_DIR}/${FAIR_DIR4}/registered_,${DATA_DIR}/${FAIR_DIR4}/registered_Warped.nii.gz,${DATA_DIR}/${FAIR_DIR4}/registered_InverseWarped.nii.gz] \
	--interpolation Linear \
	--use-histogram-matching 0 \
	--winsorize-image-intensities [0.005,0.995] \
	--initial-moving-transform ${DATA_DIR}/${FAIR_DIR4}/itk_manual.txt \
	--transform Rigid[0.05] \
	--metric CC[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR4}/diffav.nii.gz,0.7,32,Regular,0.1] \
	--convergence [1000x500,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \
	--transform Affine[0.1] \
	--metric MI[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR4}/diffav.nii.gz,0.7,32,Regular,0.1] \
	--convergence [1000x500,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \
	--transform SyN[0.1,2,0] \
	--metric CC[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR4}/diffav.nii.gz,1,2] \
	--convergence [500x100,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \

done

echo "FAIR4000_aslpp completed"



