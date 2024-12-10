import os
import subprocess

# Define file paths
indir = "/Volumes/hermes/canapi_051224/spmanalysis/ica_aroma_results/"
ica_aroma_path = "/Users/ppzma/Documents/MATLAB/ICA-AROMA/ICA_AROMA.py"  # Path to the ICA_AROMA.py script

input_files = [
    "wrparrec_WIP50prc_20241205082447_8_nordic_clv.nii.gz",
    "wrparrec_WIP50prc_20241205082447_4_nordic_clv.nii.gz",
    "wrparrec_WIP30prc_20241205082447_9_nordic_clv.nii.gz",
    "wrparrec_WIP30prc_20241205082447_5_nordic_clv.nii.gz",
    "wrparrec_WIP1bar_20241205082447_6_nordic_clv.nii.gz",
    "wrparrec_WIP1bar_20241205082447_10_nordic_clv.nii.gz"
]

output_dir = os.path.join(indir, "outputs/")

motion_params = [
    "rp_parrec_WIP50prc_20241205082447_8_nordic_clv.txt",
    "rp_parrec_WIP50prc_20241205082447_4_nordic_clv.txt",
    "rp_parrec_WIP30prc_20241205082447_9_nordic_clv.txt",
    "rp_parrec_WIP30prc_20241205082447_5_nordic_clv.txt",
    "rp_parrec_WIP1bar_20241205082447_6_nordic_clv.txt",
    "rp_parrec_WIP1bar_20241205082447_10_nordic_clv.txt"
]

brain_mask = os.path.join(indir,"file1tmmask.nii.gz")  # Precomputed brain mask

# Ensure output folder exists
os.makedirs(output_dir, exist_ok=True)

# Check that the number of input files matches the number of motion parameter files
if len(input_files) != len(motion_params):
    raise ValueError("The number of motion parameter files does not match the number of input files.")

# Loop through files and run ICA-AROMA
for i, input_file in enumerate(input_files):
    input_path = os.path.join(indir, input_file)
    motion_param_path = os.path.join(indir, motion_params[i])
    base_name = os.path.basename(input_file).replace(".nii.gz", "")
    subject_output_dir = os.path.join(output_dir, base_name)
    os.makedirs(subject_output_dir, exist_ok=True)

    command = [
        "python3", ica_aroma_path,
        "-in", input_path,
        "-out", subject_output_dir,
        "-mc", motion_param_path,
        "-m", brain_mask,
        "-overwrite"
    ]

    print(f"Running ICA-AROMA for {input_file}...")
    subprocess.run(command)

print("ICA-AROMA processing completed!")
