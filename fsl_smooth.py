import os
import subprocess

# Paths to input and output folders
rootFold = "/Volumes/hermes/canapi_051224/fslanalysis/"
input_folder = rootFold  # Replace with your input folder path
output_folder = rootFold  # Replace with your output folder path
ica_aroma_path = "/Users/ppzma/Documents/MATLAB/ICA-AROMA/ICA_AROMA.py"  # Path to ICA-AROMA script
brain_mask = os.path.join(rootFold,"brain_mask.nii.gz")  # Optional brain mask
structural_image = os.path.join(rootFold,"parrec_WIPMPRAGE_CS3_5_20241205082447_2_masked.nii")

os.makedirs(output_folder, exist_ok=True)

# List of input files
# input_files = [
#     "parrec_WIP1bar_20241205082447_6_nordic_clv.nii",
#     "parrec_WIP1bar_20241205082447_10_nordic_clv.nii",
#     "parrec_WIP30prc_20241205082447_5_nordic_clv.nii",
#     "parrec_WIP30prc_20241205082447_9_nordic_clv.nii",
#     "parrec_WIP50prc_20241205082447_4_nordic_clv.nii",
#     "parrec_WIP50prc_20241205082447_8_nordic_clv.nii"
# ]

input_files = [
    "parrec_WIP1bar_20241205082447_6_nordic_clv"
]
# Step 4: Smoothing
for file in input_files:
    base_name = os.path.splitext(file)[0]
    normalized_out = os.path.join(output_folder, base_name + "_mni.nii.gz")
    smoothed_out = os.path.join(output_folder, base_name + "_smoothed.nii.gz")
    
    # Apply smoothing
    subprocess.run([
        "fslmaths", normalized_out,
        "-s", "3",  # Smooth with 2.5mm FWHM
        smoothed_out
    ])
    print(f"Smoothed file saved to: {smoothed_out}")