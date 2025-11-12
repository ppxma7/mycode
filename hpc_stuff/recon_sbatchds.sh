#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=8g
#SBATCH --time=168:00:00

echo "Running on `hostname`"

module load freesurfer-uon/6.0.0

export SUBJECTS_DIR=/home/ppzma/subjects_dir/

if [ -e ${FREESURFER_HOME}/SetUpFreeSurfer.sh ]; then
	source $FREESURFER_HOME/SetUpFreeSurfer.sh
fi

dir=${SUBJECTS_DIR}
f=16227_psir_1mm.nii.gz
sub=$(echo "$f" | cut -f 1 -d '.')
echo ${sub}.freesurfer
echo $f
cd $dir

#recon-all -autorecon2-cp -autorecon3 -s ${sub}.freesurfer -hires -openmp 8
#recon-all -all -i $f -s ${sub}.freesurfer -hires -expert expert.opts -openmp 8
#recon-all -all -i $f -s ${sub}.freesurfer -openmp 8
recon-all -autorecon2 -autorecon3 -s ${sub}.freesurfer 

# going to do a sanity check to see if a folder exists already, if not recon!
#if [ ! -d "$dir/$sub" ]; then
	#echo attempting to recon subject $sub
	#recon-all -all -i $f -s ${sub}.freesurfer -openmp 8
	#recon-all -autorecon1 -i $f -s $sub -openmp 8
	#recon-all -autorecon2 -hires -s $sub -openmp 8
	#recon-all -autorecon3 -hires -s $sub -openmp 8
	#recon-all -all -hires -i $f -s $sub -expert expert.opts -openmp 8
	#recon-all -autorecon2 -autorecon3 -s $sub -hires -openmp 8
	#recon-all -autorecon2-cp -autorecon3 -s $sub
	#echo completed $sub 
#fi

echo done


