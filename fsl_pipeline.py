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
    "parrec_WIP30prc_20241205082447_9_nordic_clv.nii",
    "parrec_WIP50prc_20241205082447_4_nordic_clv.nii",
    "parrec_WIP50prc_20241205082447_8_nordic_clv.nii"
]

# input_files = [
#     "parrec_WIP1bar_20241205082447_6_nordic_clv"
# ]

# Step 1: Realignment (Motion Correction)
# for file in input_files:
#     input_path = os.path.join(input_folder, file)
#     base_name = os.path.splitext(file)[0]
#     mcflirt_out = os.path.join(output_folder, base_name + "_mc")
#     motion_params_out = os.path.join(output_folder, base_name + "_motion.txt")
    
#     # Run MCFLIRT
#     subprocess.run([
#         "mcflirt", "-in", input_path, "-out", mcflirt_out, 
#         "-mats", "-plots", "-rmsrel", "-rmsabs"
#     ])
    
#     # Save motion parameters for MATLAB plotting
#     motion_params_path = mcflirt_out + ".par"
#     subprocess.run(["cp", motion_params_path, motion_params_out])
#     print(f"Motion parameters saved to: {motion_params_out}")

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
    
    
    # # Run ICA-AROMA in native space
    # subprocess.run([
    #     "python3", ica_aroma_path,
    #     "-in", mc_output + ".nii.gz",
    #     "-out", aroma_out,
    #     "-mc", motion_params_file,
    #     "-m", brain_mask,
    #     "-overwrite"
    # ])
    # print(f"ICA-AROMA completed for {file}")


   # Run ICA-AROMA in native space
    try:
        subprocess.run([
            "python3", ica_aroma_path,
            "-in", mc_output + ".nii.gz",
            "-out", aroma_out,
            "-mc", motion_params_file,
            "-m", brain_mask,
            "-overwrite"
        ], cwd=os.path.dirname(ica_aroma_path), check=True)
        print(f"ICA-AROMA completed for {file}")
    except subprocess.CalledProcessError as e:
        print(f"Error running ICA-AROMA for {file}: {e}")


# Step 3: Normalization to MNI152 Space
# for file in input_files:
#     base_name = os.path.splitext(file)[0]
#     aroma_out = os.path.join(output_folder, base_name + "_aroma/denoised_func_data_nonaggr.nii.gz")
#     func2anat_mat = os.path.join(output_folder, base_name + "_func2anat.mat")
#     anat2mni_mat = os.path.join(output_folder, base_name + "_anat2mni.mat")
#     func2mni_mat = os.path.join(output_folder, base_name + "_func2mni.mat")
#     normalized_out = os.path.join(output_folder, base_name + "_mni.nii.gz")

#     # Step 3a: Align Functional to Structural
#     subprocess.run([
#         "flirt", "-in", aroma_out,
#         "-ref", structural_image,
#         "-omat", func2anat_mat,
#         "-out", os.path.join(output_folder, base_name + "_func2anat.nii.gz")
#     ])
#     print(f"Functional to Structural alignment completed: {func2anat_mat}")

#     # Step 3b: Align Structural to MNI
#     anat2mni_out = os.path.join(output_folder, base_name + "_anat2mni.nii.gz")
#     subprocess.run([
#         "/usr/local/fsl/bin/flirt",
#         "-in", structural_image,
#         "-ref", "/usr/local/fsl/data/standard/MNI152_T1_2mm_brain",
#         "-out", anat2mni_out,
#         "-omat", anat2mni_mat,
#         "-bins", "256",
#         "-cost", "corratio",
#         "-searchrx", "-90", "90",
#         "-searchry", "-90", "90",
#         "-searchrz", "-90", "90",
#         "-dof", "12",
#         "-interp", "trilinear"
#     ])
#     print(f"Structural to MNI alignment completed: {anat2mni_mat}")

#     # Step 3c: Combine Transformations
#     subprocess.run([
#         "convert_xfm", "-omat", func2mni_mat,
#         "-concat", anat2mni_mat, func2anat_mat
#     ])
#     print(f"Transformations combined into: {func2mni_mat}")

#     # Step 3d: Apply Combined Transformation to Functional Data
#     subprocess.run([
#         "flirt", "-in", aroma_out,
#         "-ref", "/usr/local/fsl/data/standard/MNI152_T1_2mm_brain",
#         "-out", normalized_out,
#         "-applyxfm", "-init", func2mni_mat
#     ])
#     print(f"Normalized to MNI space: {normalized_out}")

# # Step 4: Smoothing
# for file in input_files:
#     base_name = os.path.splitext(file)[0]
#     normalized_out = os.path.join(output_folder, base_name + "_mni.nii.gz")
#     smoothed_out = os.path.join(output_folder, base_name + "_smoothed.nii.gz")
    
#     # Apply smoothing
#     subprocess.run([
#         "fslmaths", normalized_out,
#         "-s", "3",  # Smooth with 2.5mm FWHM
#         smoothed_out
#     ])
#     print(f"Smoothed file saved to: {smoothed_out}")




