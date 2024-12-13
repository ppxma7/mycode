import os
import subprocess

# Paths to input and output folders
rootFold = "/Volumes/hermes/canapi_111224/tryaroma_mni_space/"
strucFold = "/Volumes/hermes/canapi_111224/structural/"
input_folder = rootFold  # Replace with your input folder path
output_folder = rootFold  # Replace with your output folder path
ica_aroma_path = "/Users/ppzma/Documents/MATLAB/ICA-AROMA/ICA_AROMA.py"  # Path to ICA-AROMA script
#brain_mask = os.path.join(rootFold, "brain_mask.nii.gz")  # Optional brain mask
structural_image = os.path.join(strucFold, "canapi_111224_WIPMPRAGE_CS3_5_20241211155413_4_masked.nii")

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
    "wrcanapi_111224_WIP1bar_20241211155413_3_nordic_clv"
]


# Step 3: Normalization to MNI152 Space
for file in input_files:
    base_name = os.path.splitext(file)[0]
    #aroma_out = os.path.join(output_folder, base_name + "_mc.nii.gz")
    aroma_out = os.path.join(output_folder, base_name)

    func2anat_mat = os.path.join(output_folder, base_name + "_func2anat.mat")
    anat2mni_mat = os.path.join(output_folder, base_name + "_anat2mni.mat")
    func2mni_mat = os.path.join(output_folder, base_name + "_func2mni.mat")
    normalized_out = os.path.join(output_folder, base_name + "_mni.nii.gz")

    # Step 3a: Align Functional to Structural
    subprocess.run([
        "flirt", "-in", aroma_out,
        "-ref", structural_image,
        "-omat", func2anat_mat,
        "-out", os.path.join(output_folder, base_name + "_func2anat.nii.gz")
    ])
    print(f"Functional to Structural alignment completed: {func2anat_mat}")

    # Step 3b: Align Structural to MNI
    anat2mni_out = os.path.join(output_folder, base_name + "_anat2mni.nii.gz")
    subprocess.run([
        "/usr/local/fsl/bin/flirt",
        "-in", structural_image,
        "-ref", "/usr/local/fsl/data/standard/MNI152_T1_2mm_brain",
        "-out", anat2mni_out,
        "-omat", anat2mni_mat,
        "-bins", "256",
        "-cost", "corratio",
        "-searchrx", "-90", "90",
        "-searchry", "-90", "90",
        "-searchrz", "-90", "90",
        "-dof", "12",
        "-interp", "trilinear"
    ])
    print(f"Structural to MNI alignment completed: {anat2mni_mat}")

    # Step 3c: Combine Transformations
    subprocess.run([
        "convert_xfm", "-omat", func2mni_mat,
        "-concat", anat2mni_mat, func2anat_mat
    ])
    print(f"Transformations combined into: {func2mni_mat}")

    # Step 3d: Apply Combined Transformation to Functional Data
    subprocess.run([
        "flirt", "-in", aroma_out,
        "-ref", "/usr/local/fsl/data/standard/MNI152_T1_2mm_brain",
        "-out", normalized_out,
        "-applyxfm", "-init", func2mni_mat
    ])
    print(f"Normalized to MNI space: {normalized_out}")
