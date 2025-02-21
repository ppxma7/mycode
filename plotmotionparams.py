import numpy as np
import matplotlib.pyplot as plt
import os

# Input and output folders
#input_folder = "/Volumes/nemosine/CANAPI_210125/spmanalysis/"  # Replace with your input folder path
#input_folder = '/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/canapi_030225/'
input_folder = '/Users/spmic/data/postDUST_MBSENSE_HEAD_200225/spm_check_motion/'
output_folder = os.path.join(input_folder, "motion_plots")  # Output folder for saving plots
os.makedirs(output_folder, exist_ok=True)  # Create the folder if it doesn't exist

# List of input files
# input_files = [
#     "parrec_WIP1bar_20241205082447_6_nordic_clv",
#     "parrec_WIP1bar_20241205082447_10_nordic_clv",
#     "parrec_WIP30prc_20241205082447_5_nordic_clv",
#     "parrec_WIP30prc_20241205082447_9_nordic_clv",
#     "parrec_WIP50prc_20241205082447_4_nordic_clv",
#     "parrec_WIP50prc_20241205082447_8_nordic_clv"
# ]

input_files = [
    "rp_postDUST_HEAD_200225_WIPMB1_SENSE1_20250220151249_3_clv",   
    "rp_postDUST_HEAD_200225_WIPMB1_SENSE1p5_20250220151249_4_clv",
    "rp_postDUST_HEAD_200225_WIPMB1_SENSE2_20250220151249_5_clv",
    "rp_postDUST_HEAD_200225_WIPMB1_SENSE2p5_20250220151249_6_clv",
    "rp_postDUST_HEAD_200225_WIPMB1_SENSE3_20250220151249_7_clv",
    "rp_postDUST_HEAD_200225_WIPMB2_SENSE1_20250220151249_10_clv",
    "rp_postDUST_HEAD_200225_WIPMB2_SENSE1p5_20250220151249_12_clv",
    "rp_postDUST_HEAD_200225_WIPMB2_SENSE2_20250220151249_14_clv",
    "rp_postDUST_HEAD_200225_WIPMB2_SENSE2p5_20250220151249_16_clv",
    "rp_postDUST_HEAD_200225_WIPMB2_SENSE3_20250220151249_18_clv",
    "rp_postDUST_HEAD_200225_WIPMB3_SENSE1_20250220151249_20_clv",
    "rp_postDUST_HEAD_200225_WIPMB3_SENSE1p5_20250220151249_22_clv",
    "rp_postDUST_HEAD_200225_WIPMB3_SENSE2_20250220151249_24_clv",
    "rp_postDUST_HEAD_200225_WIPMB3_SENSE2p5_20250220151249_26_clv",
    "rp_postDUST_HEAD_200225_WIPMB3_SENSE3_20250220151249_28_clv",
    "rp_postDUST_HEAD_200225_WIPMB4_SENSE1_20250220151249_30_clv",
    "rp_postDUST_HEAD_200225_WIPMB4_SENSE1p5_20250220151249_32_clv",
    "rp_postDUST_HEAD_200225_WIPMB4_SENSE2_20250220151249_34_clv",
    "rp_postDUST_HEAD_200225_WIPMB4_SENSE2p5_20250220151249_36_clv",
    "rp_postDUST_HEAD_200225_WIPMB4_SENSE3_20250220151249_38_clv"
]

# Loop through each file
for file in input_files:
    par_file = os.path.join(input_folder, file + ".txt")  # Assuming motion parameter files end with "_mc.par"
    
    # Check if the .par file exists
    if not os.path.exists(par_file):
        print(f"Motion parameter file not found: {par_file}")
        continue

    # Load the motion parameters
    motion_params = np.loadtxt(par_file)

    lower_limit = -2
    upper_limit = 2

    # Convert times in seconds to dynamics
    #timepoints_seconds = [21, 51, 81, 111, 141] #PUSH
    timepoints_seconds = [21, 61, 101, 141, 181, 221, 261, 301, 341, 381] #TAP
    timepoints_dynamics = [int(t / 1.5) for t in timepoints_seconds]

    # Plot translations and rotations
    fig, axes = plt.subplots(2, 1, figsize=(10, 6), sharex=True)

    # Plot translations (columns 3-5)
    axes[0].plot(motion_params[:, 0], label='X Translation', color='#7570b3')  # Hex color)
    axes[0].plot(motion_params[:, 1], label='Y Translation', color='#d95f02')  # Hex color)
    axes[0].plot(motion_params[:, 2], label='Z Translation', color='#1b9e77')  # Hex color)
    axes[0].set_title('Translations')
    axes[0].set_xlabel('Volume')
    axes[0].set_ylabel('Translation (mm)')
    axes[0].legend()
    axes[0].grid(True)
    # Add vertical lines at the calculated dynamics
    # for x in timepoints_dynamics:
    #     axes[0].axvline(x=x, color='k', linestyle='--', linewidth=0.8)


    #axes[0].set_ylim(lower_limit, upper_limit)

        # Plot rotations (columns 0-2)
    axes[1].plot(motion_params[:, 3], label='X Rotation', color='#7570b3')  # Hex color)
    axes[1].plot(motion_params[:, 4], label='Y Rotation', color='#d95f02')  # Hex color)
    axes[1].plot(motion_params[:, 5], label='Z Rotation', color='#1b9e77')  # Hex color)
    axes[1].set_title('Rotations')
    axes[1].set_ylabel('Rotations (radians)')
    axes[1].legend()
    axes[1].grid(True)
    #axes[1].set_ylim(lower_limit, upper_limit)


    # Save the plot as PNG
    plot_file = os.path.join(output_folder, f"{file}_motion_plot.png")
    plt.tight_layout()
    plt.savefig(plot_file, dpi=300)
    plt.close()  # Close the plot to free memory
    print(f"Saved motion parameter plot: {plot_file}")
