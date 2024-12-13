import os
import subprocess

# Paths to input and output folders
rootFold = "/Volumes/hermes/canapi_051224/aroma_mni_space/"
strucFold = "/Volumes/hermes/canapi_051224/structural/"
input_folder = rootFold  # Replace with your input folder path
output_folder = rootFold  # Replace with your output folder path
ica_aroma_path = "/Users/ppzma/Documents/MATLAB/ICA-AROMA/ICA_AROMA.py"  # Path to ICA-AROMA script
brain_mask = os.path.join(rootFold,"brain_mask.nii")  # Optional brain mask
structural_image = os.path.join(strucFold,"parrec_WIPMPRAGE_CS3_5_20241205082447_2_masked.nii")

os.makedirs(output_folder, exist_ok=True)


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

# Step 2: Coregistration and ICA-AROMA
for file in input_files:
    base_name = os.path.splitext(file)[0]
    input_file_path = os.path.join(input_folder, base_name)

    print(input_file_path)

    motion_params_file = motion_files[input_files.index(file)]
    motion_params_file_input = os.path.join(rootFold,motion_params_file)

    print(motion_params_file_input)

    #mc_output = os.path.join(output_folder, base_name + "_mc")
    aroma_out = os.path.join(output_folder, base_name + "_aroma")

    print(aroma_out)

    # Check if the motion correction file exists
    if not os.path.exists(motion_params_file_input):
        print(f"Error: Motion correction file not found for {file}: {motion_params_file_input}")
        continue  # Skip to the next file
    


   # Run ICA-AROMA in MNI space
    try:
        subprocess.run([
            "python3", ica_aroma_path,
            "-in", input_file_path + ".nii",
            "-out", aroma_out,
            "-mc", motion_params_file_input,
            "-m", brain_mask,
            "-overwrite"
        ], cwd=os.path.dirname(ica_aroma_path), check=True)
        print(f"ICA-AROMA completed for {file}")
    except subprocess.CalledProcessError as e:
        print(f"Error running ICA-AROMA for {file}: {e}")




