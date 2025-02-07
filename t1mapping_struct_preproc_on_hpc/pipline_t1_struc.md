# Order of operations

- Pull from XNAT
- Rearrange and dcm2niix folders using `loop_convert_folder.sh`
- Remove . from mprate `loop_convert_remove_dots.sh`
- Correct XNAT data (DICOM / philips rescale issue) `checkMagPhase_loop.m`, which calls `checkMagPhase_noprompt.m`
- Send to HPC (rsync / scp)
- For MPRAGE, `7Tbrc_pipeline_loop_2.sh` will call the BRC pipeline which runs fastsurfer/freesurfer, ignore T2 flag if that's not there
- Run t1mapping using `t1_mapping_longform_hpc_shell_torun.sh`. This calls `t1_mapping_longform_hpc.py`
- Bring everything back locally
- Check registration locally using `register_t1_to_mni_local_shell.sh`. This calls `register_t1_to_mni_standalone_fixing.py`.
- Now get read CSV / plot
- Run `fs_stats.py`
- Then you will need to run `mergecsv.py` to stick csvs together from different groups (AFIRM, SASHB etc)
- `fs_stats_allsubs.py` will plot
- Do the same for T1 mapping
- `apply_extract_atlas_t1_short.py` for each group, then `merge_csv.py`
- `t1_stats_allsubs.py` will plot