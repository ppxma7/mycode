# Order of operations

- Pull from XNAT
- Rearrange and dcm2niix folders using `loop_convert_folder.sh`
- Remove . from mprage `loop_convert_remove_dots.sh`
- Correct XNAT data (DICOM / philips rescale issue) `checkMagPhase_loop.m`, which calls `checkMagPhase_noprompt.m`
- Send to HPC (rsync / scp)
- For MPRAGE, `7Tbrc_pipeline_loop_2.sh` will call the BRC pipeline which runs fastsurfer/freesurfer, ignore T2 flag if that's not there
- Run t1mapping using `t1_mapping_longform_hpc_shell_torun.sh`. This calls `t1_mapping_longform_hpc.py`
- Bring everything back locally
- Check registration locally using `register_t1_to_mni_local_shell.sh`. This calls `register_t1_to_mni_standalone_fixing.py`.
- Now get read CSV / plot
- Run `fs_stats.py` (twice for l and r)
- Then you will need to run `mergecsv.py` to stick csvs together from different groups (AFIRM, SASHB etc)
- `fs_stats_allsubs.py` will plot
- Do the same for T1 mapping
- `apply_extract_atlas_t1_short.py` for each group, then `merge_csv.py`
- `t1_stats_allsubs.py` will plot



- example of copying from hpc to local:
`rsync -azv ppzma@hpclogin01.ada.nottingham.ac.uk:/spmstore/project/AFIRMBRAIN/AFIRM/outputs /Volumes/nemosine/SAN/AFIRM/afirm_new_outs/`



- slurm2text.sh moves slurm files to new folder and convert to text
- moveBuriedToTop.sh moves the FreeSurfer directories to the top subject level.

- For the FreeSurfer data, you need to run runMrisPreproc.sh, runGLMs.sh, runClustSims.sh and clustSimToTable.sh
- You need to check your FSGD and Contrast files - https://andysbrainbook.readthedocs.io/en/latest/FreeSurfer/FS_ShortCourse/FS_07_FSGD.html

- For the t1 analysis, you should use fsl_randomise https://chatgpt.com/share/68b9ac1e-f01c-800c-8bf0-598a54ad6ac4
- Look at fslrandomise_notes.txt for help
