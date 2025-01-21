import os
import subprocess

# Paths to input and output folders
#rootFold = "/Volumes/hermes/canapi_051224/aroma_mni_space/"
rootFold = "/Volumes/nemosine/CANAPI_210125/spmanalysis/"

strucFold = "/Volumes/nemosine/CANAPI_210125/structs/"
ica_aroma_path = "/Users/ppzma/Documents/MATLAB/ICA-AROMA/ICA_AROMA.py"  # Path to ICA-AROMA script

brain_mask = os.path.join(rootFold, "brain_mask.nii.gz")  # Optional brain mask

structural_image = os.path.join(strucFold, "parrec_WIPMPRAGE_CS3_5_20241205082447_2.nii")

os.makedirs(rootFold, exist_ok=True)

# Input files and corresponding motion parameter files
input_files = [
    "rwrCANAPI_210125_WIP1bar_PUSH_20250121121208_3_nordic_clv.nii",
    "rwrCANAPI_210125_WIP1bar_TAP_20250121121208_4_nordic_clv.nii",
    "rwrCANAPI_210125_WIPlow_PUSH_20250121121208_5_nordic_clv.nii",
    "rwrCANAPI_210125_WIPlow_TAP_20250121121208_6_nordic_clv.nii"
]

motion_files = [
    "rp_CANAPI_210125_WIP1bar_PUSH_20250121121208_3_nordic_clv.txt",
    "rp_CANAPI_210125_WIP1bar_TAP_20250121121208_4_nordic_clv.txt",
    "rp_CANAPI_210125_WIPlow_PUSH_20250121121208_5_nordic_clv.txt",
    "rp_CANAPI_210125_WIPlow_TAP_20250121121208_6_nordic_clv.txt"
]

# input_files = [
#     "rwrparrec_WIP50prc_20241205082447_4_nordic_clv.nii"
# ]

# motion_files = [
#     "rp_parrec_WIP50prc_20241205082447_4_nordic_clv.txt"
# ]


# ICA-AROMA processing loop
for input_file, motion_file in zip(input_files, motion_files):



    base_name = os.path.splitext(input_file)[0] 
    #base_name = os.path.splitext(os.path.splitext(input_file)[0])[0]
    input_file_path = os.path.join(rootFold, input_file)
    input_file_path_nonan = os.path.join(rootFold, base_name + "_nonan.nii.gz")

    print(input_file_path_nonan)

    subprocess.run([
        "fslmaths",
        input_file_path,
        "-nan",
        input_file_path_nonan
        ], check=True)

    if not os.path.exists(brain_mask):
        print("No brain mask, creating one...")
        subprocess.run([
            "bet",
            input_file_path_nonan,
            rootFold + "brain",
            "-R","-F","-m",
            ], check=True)


    motion_params_file_path = os.path.join(rootFold, motion_file)
    
    print(motion_params_file_path)

    aroma_out = os.path.splitext(os.path.splitext(input_file_path_nonan)[0])[0] + "_aroma"

    print(aroma_out)
    print(brain_mask)

    # Check if the input file and motion file exist
    if not os.path.exists(input_file_path_nonan):
        print(f"Error: Input file not found: {input_file_path_nonan}")
        continue
    if not os.path.exists(motion_params_file_path):
        print(f"Error: Motion correction file not found: {motion_params_file_path}")
        continue

    # Run ICA-AROMA

    try:
        #melodic_dir = os.path.join(aroma_out, "melodic.ica")  # Path to MELODIC output
        melodic_dir = os.path.join(rootFold,base_name + ".melodic.ica")

        if not os.path.exists(melodic_dir):
            print('Theres no melodic dir, running melodic')
            subprocess.run([
                "python3", ica_aroma_path,
                "-in", input_file_path_nonan,
                "-out", aroma_out,
                "-mc", motion_params_file_path,
                "-m", brain_mask,
                "-den", "nonaggr",
            ], check=True)
            print(f"ICA-AROMA completed for {input_file_path_nonan}")
        else:
            print('Found a melodic dir')
            subprocess.run([
                "python3", ica_aroma_path,
                "-in", input_file_path_nonan,
                "-out", aroma_out,
                "-mc", motion_params_file_path,
                "-m", brain_mask,
                "-md", melodic_dir,
                "-den", "nonaggr",
            ], check=True)
            print(f"ICA-AROMA completed for {input_file_path_nonan}")

    except subprocess.CalledProcessError as e:
        print(f"Error running ICA-AROMA for {input_file_path_nonan}: {e}")





