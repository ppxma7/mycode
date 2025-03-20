#Details 

`checkMagPhase_loop.m`
`checkMagPhase_noprompt.m`

->These two check the magnitude and phase values of your nifti, in case they are dicom then the mag/phase might be odd, so it will read a relevant json file and apply the correction. Run checkMagPhase_loop.m which calls checkMagPhase_noprompt in a loop of subjects.

`T1map_MS-EPI_latest-michael.ipynb`
-> This is the OG t1 mapping code from Olivier. Just edit your paths etc, and create a mask. This works one subject at a time. Call it using jupyter notebook or jupyter lab.

`t1_mapping_longform_hpc_shell_torun_1.sh`
`t1_mapping_longform_hpc.py`
-> Here are batch versions of the t1 mapping code. Remove sections relevant to the hpc to run. You run the bash script which calls the python script in a loop. The python script is condensed and also runs a transformation to MNI space. This requires certain files like `bb_fnirt.cnf` for FNIRT, etc. If you want to skip this, then just comment out the line 455 after the t1mapping has run. 

