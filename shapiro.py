import nibabel as nib
import numpy as np
from scipy.stats import shapiro
import os

rootfolder="/Users/spmic/data/NEXPO/t1mnispace/smoothed/"
fslpath="/Users/spmic/fsl/data/standard/"
# This script tests the normality of T1-weighted MRI data across subjects using the Shapiro-Wilk test.
datafile = os.path.join(rootfolder, "all_subjects_4D.nii.gz")
maskfile = os.path.join(fslpath,"MNI152_T1_1mm_brain_mask.nii.gz")

# Load your 4D image
img = nib.load(datafile)
data = img.get_fdata()  # Shape: (x, y, z, subjects)

# Load or define a binary mask (e.g. brain mask or ROI)
mask = nib.load(maskfile).get_fdata() > 0

# Collapse over 3D space to get mean T1 per subject within the mask
masked_data = data[mask]  # shape: (voxels, subjects)
mean_t1_per_subject = masked_data.mean(axis=0)  # shape: (subjects,)

# Now test for normality across subjects:
# The value of this statistic tends to be high (close to 1) for samples drawn 
# from a normal distribution. The test is performed by comparing the 
# observed value of the statistic against the null distribution: 
# the distribution of statistic values formed under the null hypothesis 
# that the weights were drawn from a normal distribution. 

# If the p-value is “small” - that is, if there is a low probability 
# of sampling data from a normally distributed population that produces 
# such an extreme value of the statistic - this may be taken as evidence 
# against the null hypothesis in favor of the alternative: the weights 
# were not drawn from a normal distribution

stat, pval = shapiro(mean_t1_per_subject)
print(f"Shapiro-Wilk p-value: {pval:.20f}")
print(f"Shapiro-Wilk statistic: {stat:.20f}")

