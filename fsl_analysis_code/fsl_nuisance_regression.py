import os
import subprocess
import numpy as np
import nibabel as nib
from scipy.stats import linregress
from scipy.signal import butter, filtfilt
from sklearn.linear_model import LinearRegression

# Paths to input and output folders
rootFold = "/Volumes/hermes/canapi_111224/fslanalysis/"
strucFold = "/Volumes/hermes/canapi_111224/structural/"
input_folder = rootFold
output_folder = rootFold
ica_aroma_path = "/Users/ppzma/Documents/MATLAB/ICA-AROMA/ICA_AROMA.py"
brain_mask = os.path.join(rootFold, "brainmask_mask.nii.gz")
structural_image = os.path.join(strucFold,"canapi_111224_WIPMPRAGE_CS3_5_20241211155413_4_masked.nii")

os.makedirs(output_folder, exist_ok=True)

# input_files = [
#     "parrec_WIP1bar_20241205082447_6_nordic_clv.nii",
#     "parrec_WIP1bar_20241205082447_10_nordic_clv.nii",
#     "parrec_WIP30prc_20241205082447_5_nordic_clv.nii",
#     "parrec_WIP30prc_20241205082447_9_nordic_clv.nii",
#     "parrec_WIP50prc_20241205082447_4_nordic_clv.nii",
#     "parrec_WIP50prc_20241205082447_8_nordic_clv.nii"
# ]

input_files = [
    "canapi_111224_WIP1bar_20241211155413_3_nordic_clv.nii"
]

firstFile = "canapi_111224_WIP1bar_20241211155413_3_nordic_clv.nii"

# input_files = ["parrec_WIP1bar_20241205082447_6_nordic_clv.nii",
# ]

# Define paths for FAST outputs
fast_output_prefix = os.path.join(output_folder, "fast_out")
wm_mask_struct = fast_output_prefix + "_pve_2.nii.gz"
csf_mask_struct = fast_output_prefix + "_pve_0.nii.gz"

# Check if FAST outputs exist
if not all(os.path.exists(f) for f in [wm_mask_struct, csf_mask_struct]):
    print("FAST outputs not found. Running FAST...")
    subprocess.run([
        "fast", "-t", "1", "-n", "3", "-H", "0.1", "-I", "4", "-l", "20.0",
        "-o", fast_output_prefix, structural_image
    ])
    print("FAST completed.")
else:
    print("FAST outputs found. Skipping FAST step.")

print(f"Using WM mask: {wm_mask_struct}, CSF mask: {csf_mask_struct}")

# need to move WM and CSF to functional space
# Align masks to functional space
wm_mask_func = os.path.join(output_folder, "fast_out_pve_2_func_space.nii.gz")
csf_mask_func = os.path.join(output_folder, "fast_out_pve_0_func_space.nii.gz")

if not all(os.path.exists(f) for f in [wm_mask_func, csf_mask_func]):
    print("Aligning WM and CSF masks to functional space...")
    for file, output in zip([wm_mask_struct, csf_mask_struct], [wm_mask_func, csf_mask_func]):
        subprocess.run([
            "flirt", "-in", file,
            "-ref", os.path.join(output_folder, firstFile),
            "-applyxfm", "-usesqform",
            "-out", output
        ])
    print("Mask alignment completed.")


# Helper functions
def regress_nuisance(data, nuisance):
    """Regress nuisance signals from the data."""
    if nuisance.shape[0] != data.shape[1]:
        raise ValueError(f"Incompatible dimensions: data ({data.shape}) and nuisance ({nuisance.shape})")
    betas = np.linalg.lstsq(nuisance, data.T, rcond=None)[0]  # Transpose data for regression
    residuals = data - (nuisance @ betas).T  # Transpose back
    return residuals

def regress_nuisance2(data, nuisance):
    """Robust nuisance regression."""
    residuals = np.zeros_like(data)
    model = LinearRegression()  # Ordinary least squares regression
    for i in range(data.shape[0]):  # Loop through voxels
        model.fit(nuisance, data[i, :])
        predicted = model.predict(nuisance)
        residuals[i, :] = data[i, :] - predicted
    return residuals




def detrend(data):
    """Remove linear trends from the data."""
    n_timepoints = data.shape[0]
    x = np.arange(n_timepoints)
    slope, intercept, _, _, _ = linregress(x, data)
    trend = slope * x + intercept
    return data - trend

def detrend_vectorized(data):
    """Remove linear trends from the data (vectorized)."""
    n_timepoints = data.shape[-1]
    x = np.arange(n_timepoints)
    x = (x - x.mean()) / x.std()  # Standardize x for numerical stability
    X = np.column_stack((x, np.ones_like(x)))  # Design matrix for linear regression
    betas = np.linalg.lstsq(X, data.T, rcond=None)[0]  # Fit the model
    trend = X @ betas  # Compute the trend
    return (data - trend.T)  # Subtract the trend


def high_pass_filter(data, cutoff, fs):
    """Apply high-pass filter to the data."""
    nyquist = 0.5 * fs
    low = cutoff / nyquist
    b, a = butter(1, low, btype='high')
    return filtfilt(b, a, data, axis=0)

# Main loop for processing files
for file in input_files:
    base_name = os.path.splitext(file)[0]
    aroma_out = os.path.join(output_folder, base_name + "_aroma/denoised_func_data_nonaggr.nii.gz")
    nuisance_reg_out = os.path.join(output_folder, base_name + "_nuisance_regressed.nii.gz")
    #detrended_out = os.path.join(output_folder, base_name + "_detrended.nii.gz")
    #highpass_out = os.path.join(output_folder, base_name + "_highpass.nii.gz")

    # Load fMRI data
    img = nib.load(aroma_out)
    data = img.get_fdata()
    affine = img.affine

    # Extract WM and CSF time series
    wm_data = nib.load(wm_mask_func).get_fdata()
    csf_data = nib.load(csf_mask_func).get_fdata()


    # Debugging: Check shapes
    print(f"Shape of fMRI data: {data.shape}")
    print(f"Shape of WM mask: {wm_data.shape}, CSF mask: {csf_data.shape}")

    # Extract WM and CSF time series
    wm_timeseries = data[wm_data > 0.9, :].mean(axis=0)
    csf_timeseries = data[csf_data > 0.9, :].mean(axis=0)

    print(f"Shape of WM timeseries: {wm_timeseries.shape}, CSF timeseries: {csf_timeseries.shape}")
    print(f"WM timeseries mean: {wm_timeseries.mean()}, std: {wm_timeseries.std()}")
    print(f"CSF timeseries mean: {csf_timeseries.mean()}, std: {csf_timeseries.std()}")

    # Ensure nuisance signals and data_flat have compatible dimensions
    nuisance_signals = np.column_stack([wm_timeseries, csf_timeseries])
    
    # centers each regressor to have a mean of 0
    nuisance_signals -= nuisance_signals.mean(axis=0)
    # scales each regressor to have a standard deviation of 1, avoiding division by zero
    nuisance_signals /= nuisance_signals.std(axis=0) + 1e-8  # Standardize
    print(f"Shape of nuisance_signals: {nuisance_signals.shape}")

    #Many operations (e.g., linear regression, detrending) expect the data to be in a 2D matrix form:
    #Rows: Observations (voxels).
    #Columns: Features (timepoints).
    # (-1,...) tells numpy to infer size of the flattened spatial dim
    # (..., data.shape[-1]) keeps time dim unchanged
    data_flat = data.reshape(-1, data.shape[-1])  # (num_voxels, num_timepoints)
    print(f"Shape of data_flat: {data_flat.shape}")
    print(f"Original data mean: {data_flat.mean()}, Original data std: {data_flat.std()}")

    # Transpose nuisance_signals if needed
    if nuisance_signals.shape[0] != data_flat.shape[1]:
        raise ValueError(f"Mismatch in timepoints: data ({data_flat.shape[1]}) and nuisance ({nuisance_signals.shape[0]})")


    # This step scales the fMRI data (optional, must undo before saving)
    original_mean = np.mean(data_flat, axis=-1, keepdims=True)  # Voxel-wise mean
    original_std = np.std(data_flat, axis=-1, keepdims=True) + 1e-8  # Voxel-wise std
    data_flat -= original_mean  # Demean the data
    data_flat /= original_std  # Normalize to unit variance


    # Perform nuisance regression
    #data_regressed = regress_nuisance(data_flat, nuisance_signals)
    data_regressed = regress_nuisance2(data_flat, nuisance_signals) #try ridge regression
    data_regressed = data_regressed.reshape(data.shape)

    # Restore original scaling to the regressed data
    data_regressed = data_regressed.reshape(-1, data_regressed.shape[-1])  # Flatten again
    data_regressed *= original_std  # Restore original standard deviation
    data_regressed += original_mean  # Restore original mean
    data_regressed = data_regressed.reshape(data.shape)  # Reshape back to 4D

    print(f"Data regressed mean: {data_regressed.mean()}, std: {data_regressed.std()}")

    nib.save(nib.Nifti1Image(data_regressed, affine), nuisance_reg_out)
    print(f"Nuisance regression completed: {nuisance_reg_out}")


    # ## Perform linear detrending
    # data_detrended = detrend_vectorized(data_regressed.reshape(-1, data_regressed.shape[-1]))
    # data_detrended = data_detrended.reshape(data_regressed.shape)
    # nib.save(nib.Nifti1Image(data_detrended, affine), detrended_out)
    # print(f"Linear detrending completed: {detrended_out}")


    # ## Apply high-pass filter (0.01 Hz cutoff, TR=2s as an example)
    # TR = 1.5  # Replace with actual TR
    # cutoff = 0.01  # High-pass filter cutoff in Hz
    # fs = 1 / TR  # Sampling frequency in Hz
    # data_filtered = np.apply_along_axis(high_pass_filter, axis=-1, arr=data_detrended, cutoff=cutoff, fs=fs)
    # nib.save(nib.Nifti1Image(data_filtered, affine), highpass_out)
    # print(f"High-pass filtering completed: {highpass_out}")
