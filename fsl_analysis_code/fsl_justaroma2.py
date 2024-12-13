import os
import subprocess

# Paths to input and output folders
rootFold = "/Volumes/hermes/canapi_051224/aroma_mni_space/"
strucFold = "/Volumes/hermes/canapi_051224/structural/"
ica_aroma_path = "/Users/ppzma/Documents/MATLAB/ICA-AROMA/ICA_AROMA.py"  # Path to ICA-AROMA script
brain_mask = os.path.join(rootFold, "brain_mask.nii")  # Optional brain mask
structural_image = os.path.join(strucFold, "parrec_WIPMPRAGE_CS3_5_20241205082447_2_masked.nii")

os.makedirs(rootFold, exist_ok=True)

# Input files and corresponding motion parameter files
# input_files = [
#     "rwrparrec_WIP50prc_20241205082447_4_nordic_clv.nii",
#     "rwrparrec_WIP30prc_20241205082447_5_nordic_clv.nii",
#     "rwrparrec_WIP1bar_20241205082447_6_nordic_clv.nii",
#     "rwrparrec_WIP50prc_20241205082447_8_nordic_clv.nii",
#     "rwrparrec_WIP30prc_20241205082447_9_nordic_clv.nii",
#     "rwrparrec_WIP1bar_20241205082447_10_nordic_clv.nii"
# ]

# motion_files = [
#     "rp_parrec_WIP50prc_20241205082447_4_nordic_clv.txt",
#     "rp_parrec_WIP30prc_20241205082447_5_nordic_clv.txt",
#     "rp_parrec_WIP1bar_20241205082447_6_nordic_clv.txt",
#     "rp_parrec_WIP50prc_20241205082447_8_nordic_clv.txt",
#     "rp_parrec_WIP30prc_20241205082447_9_nordic_clv.txt",
#     "rp_parrec_WIP1bar_20241205082447_10_nordic_clv.txt"
# ]
input_files = [
    "rwrparrec_WIP50prc_20241205082447_4_nordic_clv.nii"
]

motion_files = [
    "rp_parrec_WIP50prc_20241205082447_4_nordic_clv.txt"
]


# ICA-AROMA processing loop
for input_file, motion_file in zip(input_files, motion_files):
    input_file_path = os.path.join(rootFold, input_file)

    print(input_file_path)

    motion_params_file_path = os.path.join(rootFold, motion_file)
    
    print(motion_params_file_path)

    aroma_out = os.path.join(rootFold, os.path.splitext(input_file)[0] + "_aroma/")

    print(aroma_out)
    print(brain_mask)

    # Check if the input file and motion file exist
    if not os.path.exists(input_file_path):
        print(f"Error: Input file not found: {input_file_path}")
        continue
    if not os.path.exists(motion_params_file_path):
        print(f"Error: Motion correction file not found: {motion_params_file_path}")
        continue

    # Run ICA-AROMA
    try:
        subprocess.run([
            "python3", ica_aroma_path,
            "-in", input_file_path,
            "-out", aroma_out,
            "-mc", motion_params_file_path,
            "-m", brain_mask,
            "-overwrite"
        ], cwd=os.path.dirname(ica_aroma_path), check=True)
        print(f"ICA-AROMA completed for {input_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error running ICA-AROMA for {input_file}: {e}")




