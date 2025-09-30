# Running the sodium registration pipeline
#### Michael Asghar 2025
-

This is a pipeline to do 2 things:

1) Move the sodium image to MNI space

2) Move the Harvard Oxford atlas into sodium image native space

### Prerequisities

- This is a python script that is called using a bash wrapper `run_sodium_pipeline.sh` e.g. `sh run_sodium_pipeline.sh 16905_005`

- You must have a specific folder setup to run this pipeline. Make a participant folder, e.g. 16905_005. Inside this folder, have a folder called `MPRAGE/`, `MPRAGE_sodium/` and `sodium/`. Place the high resolution MPRAGE into `MPRAGE/`. Place the low-res MPRAGE that is matched to the sodium image in `MPRAGE_sodium/` and place the sodium file, e.g. `16905_005_WIP_23Na_TFE-UTE_20240718141756_401.nii` in `sodium/`.

- You will need to set paths in `run_sodium_pipeline.sh`: Set your ROOTDIR to where the participant folders are. And give the correct path to where the python code is.

- Inside `run_sodium_pipeline.py`, you must also set some paths specific to you. You will need to check the FSLDIR is correct, as it needs to find the MNI152 brain. You will need a specific config dir where FSL looks for `bb_fnirt.cnf`. This is not the default config dir because we need to edit a line in the .cnf file, such that we look for the 1mm brain, not the 2mm brain.


- You will need to install `optibet.sh`: https://montilab.psych.ucla.edu/fmri-wiki/optibet/

### What does the script do

- It runs optibet (skull stripping) on both MPRAGEs.
- It then registers the sodium MPRAGE to the high res MPRAGE.
- It registers the sodium image to the sodium MPRAGE (it should already be virtually aligned but we need this step to get a transformation matrix)
- It then registers the sodium image to the high res MPRAGE using the transform from the sodium MPRAGE -> high res MPRAGE.
- It registers the high res MPRAGE to MNI space. Do this linearly and also non-linearly (FNIRT).
- Register the sodium MPRAGE to MNI space using the above transform, linearly and non-linearly.
- Register the sodium image to MNI space using the above transform, linearly and non-linearly.
- **RESULT**: Sodium image in MNI space.

- Given all those forward transforms, we can now move the atlas (already in standard space) backwards into sodium native space. We have to invert some transforms, then concatenate them and apply them to the atlas.
- **RESULT**: Harvard Oxford cortical atlas in sodium space, linearly and non-linearly.