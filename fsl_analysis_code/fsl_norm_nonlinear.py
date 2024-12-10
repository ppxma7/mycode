import os
import subprocess

# Paths to input and output folders
rootFold = "/Volumes/hermes/canapi_051224/fslanalysis/"
input_folder = rootFold  # Replace with your input folder path
output_folder = rootFold  # Replace with your output folder path
ica_aroma_path = "/Users/ppzma/Documents/MATLAB/ICA-AROMA/ICA_AROMA.py"  # Path to ICA-AROMA script
#brain_mask = os.path.join(rootFold, "brain_mask.nii.gz")  # Optional brain mask
structural_image = os.path.join(rootFold, "parrec_WIPMPRAGE_CS3_5_20241205082447_2_masked.nii")

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
    "parrec_WIP1bar_20241205082447_6_nordic_clv.nii"
]

# Step 3: Normalization to MNI152 Space using FLIRT and FNIRT
for file in input_files:
    base_name = os.path.splitext(file)[0]
    aroma_out = os.path.join(output_folder, base_name + "_nuisance_regressed.nii.gz")

    func2anat_mat = os.path.join(output_folder, base_name + "_func2anat.mat")
    anat2mni_mat = os.path.join(output_folder, base_name + "_anat2mni.mat")
    func2mni_mat = os.path.join(output_folder, base_name + "_func2mni.mat")
    anat2mni_warp = os.path.join(output_folder, base_name + "_anat2mni_warpcoef.nii.gz")
    normalized_out = os.path.join(output_folder, base_name + "_mni.nii.gz")

    # Step 3a: Align Functional to Structural (FLIRT)
    func2anat_out = os.path.join(output_folder, base_name + "_func2anat.nii.gz")
    subprocess.run([
        "flirt", "-in", aroma_out,
        "-ref", structural_image,
        "-omat", func2anat_mat,
        "-out", func2anat_out,
        "-bins", "256",
        "-cost", "corratio",
        "-searchrx", "-90", "90",
        "-searchry", "-90", "90",
        "-searchrz", "-90", "90",
        "-dof", "6",
        "-interp", "trilinear"
    ])
    print(f"Functional to Structural alignment completed: {func2anat_mat}")

    # Step 3b: Linear alignment of Structural to MNI space (FLIRT)
    anat2mni_out = os.path.join(output_folder, base_name + "_anat2mni_flirt.nii.gz")
    subprocess.run([
        "flirt", "-in", structural_image,
        "-ref", "/usr/local/fsl/data/standard/MNI152_T1_2mm_brain",
        "-omat", anat2mni_mat,
        "-out", anat2mni_out,
        "-bins", "256",
        "-cost", "corratio",
        "-searchrx", "-90", "90",
        "-searchry", "-90", "90",
        "-searchrz", "-90", "90",
        "-dof", "12",
        "-interp", "trilinear"
    ])
    print(f"Linear Structural to MNI alignment completed: {anat2mni_mat}")

    # Step 3c: Nonlinear alignment of Structural to MNI space (FNIRT)
    fnirt_out = os.path.join(output_folder, base_name + "_anat2mni_fnirt.nii.gz")
    # Run FNIRT for nonlinear alignment
    subprocess.run([
        "fnirt",
        "--in=" + structural_image,                          # Input structural image
        "--aff=" + anat2mni_mat,                            # Affine matrix from FLIRT
        "--ref=/usr/local/fsl/data/standard/MNI152_T1_2mm", # Reference MNI image
        "--refmask=/usr/local/fsl/data/standard/MNI152_T1_2mm_brain_mask_dil", # Dilated brain mask for FNIRT
        "--cout=" + anat2mni_warp,                          # Output warp coefficients
        "--iout=" + fnirt_out,                              # Output warped image
        "--lambda=5",                                       # Regularization strength (more conservative)
        "--subsamp=4,2,2,1",                                # Subsampling levels for refinement
        "--biasres=50",                                     # Bias field regularization
        "--intmod=global_non_linear",                       # Intensity mapping model
        "--jacrange=0.5,2"                                  # Restrict deformation Jacobian range
    ])
    print(f"Nonlinear Structural to MNI alignment completed: {anat2mni_warp}")

    # Step 3d: Apply Combined Transformations to Functional Data
    normalized_out = os.path.join(output_folder, base_name + "_mni.nii.gz")
    subprocess.run([
        "applywarp", "--ref=/usr/local/fsl/data/standard/MNI152_T1_2mm",
        "--in=" + aroma_out,
        "--warp=" + anat2mni_warp,
        "--premat=" + func2anat_mat,
        "--out=" + normalized_out
    ])
    print(f"Normalized functional data to MNI space: {normalized_out}")

