#!/usr/bin/env python3
"""
This script computes DVARS before and after ICA-AROMA for a list of subject folders
and then plots the DVARS curves side-by-side.
It assumes each subject folder contains:
    - The denoised data: denoised_func_data_nonaggr.nii.gz
    - The pre-denoising data inside the melodic.ica folder: melodic.ica/filtered_func_data.nii.gz
FSL must be installed, and the command 'fsl_motion_outliers' should be available in your PATH.
"""

import os
import sys
import subprocess
import numpy as np
import matplotlib.pyplot as plt

# Define the parent folder where the subject folders and pre-denoising file reside.
parent_path = "/Volumes/nemosine/canapi_sub03_180325/spm_analysis"

# List of subject folder names (exactly as they appear in the parent folder)
subjects = [
    "rwrcanapi_sub03_180325_WIP1bar_TAP_R_20250318163243_8_nordic_clv", 
    "rwrcanapi_sub03_180325_WIPlow_TAP_R_20250318163243_9_nordic_clv", 
    "rwrcanapi_sub03_180325_WIP1bar_TAP_L_20250318163243_10_nordic_clv", 
    "rwrcanapi_sub03_180325_WIPlow_TAP_L_20250318163243_11_nordic_clv"
]


for subj in subjects:
    print(f"\nProcessing subject: {subj}")
    subj_path = os.path.join(parent_path, subj + "_nonan_aroma")
    # The post-denoising file is inside the subject folder.
    data_before = os.path.join(parent_path, subj + "_nonan.nii.gz")
    data_after = os.path.join(subj_path, "denoised_func_data_nonaggr.nii.gz")

    print(f"data before: {data_before}")
    print(f"data after: {data_after}")
    
    # Check file existence:
    if not os.path.exists(data_before):
        print(f"  [WARNING] Pre-denoising file not found: {data_before}\n  Skipping subject.")
        continue
    if not os.path.exists(data_after):
        print(f"  [WARNING] Denoised file not found: {data_after}\n  Skipping subject.")
        continue

    # Define output file names within the subject folder.
    dvars_raw_file   = os.path.join(subj_path, "dvars_raw.txt")
    dvars_aroma_file = os.path.join(subj_path, "dvars_aroma.txt")
    
    # Run fsl_motion_outliers to compute DVARS for the pre-denoised data.
    try:
        subprocess.run([
            "fsl_motion_outliers",
            "-i", data_before,
            "-o", os.path.join(subj_path, "outliers_raw.txt"),
            "--dvars",
            "-s", dvars_raw_file
        ], check=True)
        print("  Computed DVARS (pre-denoising).")
    except subprocess.CalledProcessError as e:
        print("  Error computing DVARS before ICA-AROMA:", e)
        continue

    # Run fsl_motion_outliers for the post-denoising data.
    try:
        subprocess.run([
            "fsl_motion_outliers",
            "-i", data_after,
            "-o", os.path.join(subj_path, "outliers_aroma.txt"),
            "--dvars",
            "-s", dvars_aroma_file
        ], check=True)
        print("  Computed DVARS (post-denoising).")
    except subprocess.CalledProcessError as e:
        print("  Error computing DVARS after ICA-AROMA:", e)
        continue

    # Load the DVARS values from the text files.
    try:
        dvars_raw = np.loadtxt(dvars_raw_file)
        dvars_aroma = np.loadtxt(dvars_aroma_file)
    except Exception as e:
        print("  Error reading DVARS files:", e)
        continue

    # Plot DVARS for this subject.
    plt.figure(figsize=(10, 4))
    plt.plot(dvars_raw, label='Before ICA-AROMA', linewidth=1.5)
    plt.plot(dvars_aroma, label='After ICA-AROMA', linewidth=1.5)
    plt.title(f'DVARS Before vs. After ICA-AROMA: {subj}')
    plt.xlabel('Volume')
    plt.ylabel('DVARS')
    plt.legend()
    plt.grid(alpha=0.3)
    
    # Save the plot in the subject folder.
    plot_file = os.path.join(subj_path, f'{subj}_DVARS_plot.png')
    plt.savefig(plot_file, dpi=300)
    plt.close()
    print(f"  Plot saved to: {plot_file}")

print("\nAll subjects processed. DVARS plots generated.")
