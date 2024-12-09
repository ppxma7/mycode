import os
import subprocess

# Paths to input and output folders
input_folder = "/Volumes/hermes/canapi_051224/fslanalysis/"  # Replace with your input folder path
output_folder = "/Volumes/hermes/canapi_051224/fslanalysis/"  # Replace with your output folder path
ica_aroma_path = "/Users/ppzma/Documents/MATLAB/ICA-AROMA/ICA_AROMA.py"  # Path to ICA-AROMA script
brain_mask = "/Volumes/hermes/canapi_051224/fslanalysis/brain_mask.nii.gz"  # Optional brain mask
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

# Step 1: Realignment (Motion Correction)
for file in input_files:
    input_path = os.path.join(input_folder, file)
    base_name = os.path.splitext(file)[0]
    mcflirt_out = os.path.join(output_folder, base_name + "_mc")
    motion_params_out = os.path.join(output_folder, base_name + "_motion.txt")
    
    # Run MCFLIRT
    subprocess.run([
        "mcflirt", "-in", input_path, "-out", mcflirt_out, 
        "-mats", "-plots", "-rmsrel", "-rmsabs"
    ])
    
    # Save motion parameters for MATLAB plotting
    motion_params_path = mcflirt_out + ".par"
    subprocess.run(["cp", motion_params_path, motion_params_out])
    print(f"Motion parameters saved to: {motion_params_out}")

# Step 2: Coregistration and ICA-AROMA
for file in input_files:
    base_name = os.path.splitext(file)[0]
    mc_output = os.path.join(output_folder, base_name + "_mc")
    aroma_out = os.path.join(output_folder, base_name + "_aroma")
    motion_params_file = mc_output + ".par"  # Correct .par file path from MCFLIRT output

    # Check if the motion correction file exists
    if not os.path.exists(motion_params_file):
        print(f"Error: Motion correction file not found for {file}: {motion_params_file}")
        continue  # Skip to the next file
    
    
    # Run ICA-AROMA in native space
    subprocess.run([
        "python3.10", ica_aroma_path,
        "-in", mc_output + ".nii.gz",
        "-out", aroma_out,
        "-mc", motion_params_file,
        "-m", brain_mask,
        "-overwrite"
    ])
    print(f"ICA-AROMA completed for {file}")

# Step 3: Normalization to MNI152 Space
for file in input_files:
    base_name = os.path.splitext(file)[0]
    aroma_out = os.path.join(output_folder, base_name + "_aroma/denoised_func_data_nonaggr.nii.gz")
    normalized_out = os.path.join(output_folder, base_name + "_mni.nii.gz")
    
    # Normalize to MNI space
    subprocess.run([
        "flirt", "-in", aroma_out,
        "-ref", os.path.join(os.environ["FSLDIR"], "data/standard/MNI152_T1_2mm.nii.gz"),
        "-out", normalized_out,
        "-applyxfm"
    ])
    print(f"Normalized to MNI space: {normalized_out}")

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
