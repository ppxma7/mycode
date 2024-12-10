import os
import numpy as np
import nibabel as nib
import matplotlib.pyplot as plt
from scipy.signal import welch

# Paths
rootFold = "/Volumes/hermes/canapi_051224/fslanalysis/"



pre_files = [
    "parrec_WIP1bar_20241205082447_6_nordic_clv",
    "parrec_WIP1bar_20241205082447_10_nordic_clv",
    "parrec_WIP30prc_20241205082447_5_nordic_clv",
    "parrec_WIP30prc_20241205082447_9_nordic_clv",
    "parrec_WIP50prc_20241205082447_4_nordic_clv",
    "parrec_WIP50prc_20241205082447_8_nordic_clv"
]

# pre_files = [
#     "parrec_WIP1bar_20241205082447_6_nordic_clv"
# ]


# post_file = "parrec_WIP1bar_20241205082447_6_nordic_clv_nuisance_regressed.nii.gz"
# pre_file = "parrec_WIP1bar_20241205082447_6_nordic_clv_aroma/denoised_func_data_nonaggr.nii.gz"

for thisFile in pre_files:
    aromaRoot = os.path.join(rootFold,thisFile + "_aroma/")
    print(f"Aroma folder: {aromaRoot}")
    pre_file = os.path.join(aromaRoot,"denoised_func_data_nonaggr.nii.gz")
    post_file = os.path.join(rootFold, f"{thisFile}_nuisance_regressed.nii.gz")

    output_folder = os.path.join(rootFold, f"{thisFile}_nuisance_diagnostic_images/")

    os.makedirs(output_folder, exist_ok=True)


    wm_mask_func = os.path.join(rootFold, "fast_out_pve_2_func_space.nii.gz")
    csf_mask_func = os.path.join(rootFold, "fast_out_pve_0_func_space.nii.gz")

    # Load files
    pre_img = nib.load(os.path.join(rootFold, pre_file))
    pre_data = pre_img.get_fdata()

    post_img = nib.load(os.path.join(rootFold, post_file))
    post_data = post_img.get_fdata()

    wm_mask = nib.load(wm_mask_func).get_fdata()
    csf_mask = nib.load(csf_mask_func).get_fdata()

    # Extract WM and CSF signals
    wm_timeseries_pre = pre_data[wm_mask > 0.9, :].mean(axis=0)
    csf_timeseries_pre = pre_data[csf_mask > 0.9, :].mean(axis=0)

    wm_timeseries_post = post_data[wm_mask > 0.9, :].mean(axis=0)
    csf_timeseries_post = post_data[csf_mask > 0.9, :].mean(axis=0)

    # Calculate correlations
    wm_corr = np.corrcoef(wm_timeseries_pre, wm_timeseries_post)[0, 1]
    csf_corr = np.corrcoef(csf_timeseries_pre, csf_timeseries_post)[0, 1]

    print(f"Correlation between original and residual WM signals: {wm_corr:.4f}")
    print(f"Correlation between original and residual CSF signals: {csf_corr:.4f}")

    # Plot individual correction
    plt.figure(figsize=(12, 6))
    plt.plot(wm_timeseries_post, label="WM Post-Regression (Residual)", color='red', linestyle='--')
    plt.title("White Matter Signal: Post Regression")
    plt.xlabel("Timepoints")
    plt.ylabel("Signal")
    plt.legend()
    plt.savefig(os.path.join(output_folder, "wm_signal.png"))
    plt.close()

    plt.figure(figsize=(12, 6))
    plt.plot(csf_timeseries_post, label="CSF Post-Regression (Residual)", color='red', linestyle='--')
    plt.title("CSF Signal: Post Regression")
    plt.xlabel("Timepoints")
    plt.ylabel("Signal")
    plt.legend()
    plt.savefig(os.path.join(output_folder, "csf_signal.png"))
    plt.close()



    # Plot comparisons
    plt.figure(figsize=(12, 6))
    plt.plot(wm_timeseries_pre, label="WM Pre-Regression", color='blue')
    plt.plot(wm_timeseries_post, label="WM Post-Regression (Residual)", color='red', linestyle='--')
    plt.title("White Matter Signal: Pre vs Post Regression")
    plt.xlabel("Timepoints")
    plt.ylabel("Signal")
    plt.legend()
    plt.savefig(os.path.join(output_folder, "wm_signal_comparison.png"))
    plt.close()

    plt.figure(figsize=(12, 6))
    plt.plot(csf_timeseries_pre, label="CSF Pre-Regression", color='blue')
    plt.plot(csf_timeseries_post, label="CSF Post-Regression (Residual)", color='red', linestyle='--')
    plt.title("CSF Signal: Pre vs Post Regression")
    plt.xlabel("Timepoints")
    plt.ylabel("Signal")
    plt.legend()
    plt.savefig(os.path.join(output_folder, "csf_signal_comparison.png"))
    plt.close()

    # Power Spectrum Comparison
    fs = 1 / 2.0  # Assuming TR = 2 seconds

    # WM Power Spectrum
    freqs_wm_pre, power_wm_pre = welch(wm_timeseries_pre, fs=fs, nperseg=64)
    freqs_wm_post, power_wm_post = welch(wm_timeseries_post, fs=fs, nperseg=64)

    plt.figure(figsize=(10, 5))
    plt.semilogy(freqs_wm_pre, power_wm_pre, label="WM Pre-Regression", color='blue')
    plt.semilogy(freqs_wm_post, power_wm_post, label="WM Post-Regression (Residual)", color='red', linestyle='--')
    plt.title("WM Power Spectrum: Pre vs Post Regression")
    plt.xlabel("Frequency (Hz)")
    plt.ylabel("Power")
    plt.legend()
    plt.savefig(os.path.join(output_folder, "wm_power_spectrum_comparison.png"))
    plt.close()

    # CSF Power Spectrum
    freqs_csf_pre, power_csf_pre = welch(csf_timeseries_pre, fs=fs, nperseg=64)
    freqs_csf_post, power_csf_post = welch(csf_timeseries_post, fs=fs, nperseg=64)

    plt.figure(figsize=(10, 5))
    plt.semilogy(freqs_csf_pre, power_csf_pre, label="CSF Pre-Regression", color='blue')
    plt.semilogy(freqs_csf_post, power_csf_post, label="CSF Post-Regression (Residual)", color='red', linestyle='--')
    plt.title("CSF Power Spectrum: Pre vs Post Regression")
    plt.xlabel("Frequency (Hz)")
    plt.ylabel("Power")
    plt.legend()
    plt.savefig(os.path.join(output_folder, "csf_power_spectrum_comparison.png"))
    plt.close()


    # Step 5: Variance Maps
    pre_data_variance = pre_data.var(axis=-1)
    post_data_variance = post_data.var(axis=-1)
    # Determine shared color scale
    vmin = 0
    vmax = max(
        np.percentile(pre_data_variance, 95),  # 99th percentile of original variance
        np.percentile(post_data_variance, 95)  # 99th percentile of residual variance
    )
    # Plot original variance map
    plt.figure(figsize=(10, 5))
    plt.imshow(pre_data_variance[:, :, pre_data_variance.shape[2] // 2], cmap="hot", vmin=vmin, vmax=vmax)
    plt.title("Original Variance Map")
    plt.colorbar()
    plt.savefig(os.path.join(output_folder, "original_variance_map.png"))
    plt.close()

    # Plot residual variance map
    plt.figure(figsize=(10, 5))
    plt.imshow(post_data_variance[:, :, post_data_variance.shape[2] // 2], cmap="hot", vmin=vmin, vmax=vmax)
    plt.title("Residual Variance Map")
    plt.colorbar()
    plt.savefig(os.path.join(output_folder, "residual_variance_map.png"))
    plt.close()

    print(f"Processing file: {thisFile}")
    print(f"Saving diagnostic images to: {output_folder}")


