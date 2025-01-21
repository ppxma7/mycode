# CANAPI pipeline

## Preproc

- NORDIC denoise using `/Users/spmic/Documents/MATLAB/mycode/preprocessing`
- Run QA using `/Users/spmic/Documents/MATLAB/qa/fMRI_report_python/`
- Check QA using `/Users/spmic/Documents/MATLAB/mycode/tsnr_read_general.py`
- Run through normal SPM12 preprocessing:
	- Realign (Estimate & Reslice
	- Coregister (Estimate & Reslice)
		- Reference image = DEP Realign Mean
		- Source image = mprage
	- Segment
		- DEP Coreg Resliced images
		- Save field and corrected and FWD deformations
	- Normalize (Write)
		- DEP Segment FWD def
		- DEP Realign Resliced images

- Now, check mean fMRI image matches to rMPRAGE image
- Also check that wrfMRI image matches canonical MNI space image from `SPM/canonical/`
- Coregister (Reslice) wrfMRI images to MNI 152 space, using FSL 152
- Now you can run ICA Aroma using `/Users/spmic/Documents/MATLAB/mycode/fsl_analysis_code/fsl_justaroma2.py`
- Now smooth data in SPM.

## First level 

- 