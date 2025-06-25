import numpy as np
import matplotlib.pyplot as plt
import os

# Input and output folders
#input_folder = "/Volumes/nemosine/CANAPI_210125/spmanalysis/"  # Replace with your input folder path
#input_folder = '/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/canapi_030225/'
#input_folder = '/Users/spmic/data/postDUST_MBSENSE_HEAD_200225/spm_check_motion/'
#input_folder = '/Users/spmic/data/canapi_sub03_180325/spm_analysis/'
input_folder = '/Volumes/nemosine/canapi_sub06_240625/spm_analysis/'
#input_folder = '/Volumes/nemosine/caitlin_data/Map01/spmanalysis/'

output_folder = os.path.join(input_folder, "motion_plots")  # Output folder for saving plots
os.makedirs(output_folder, exist_ok=True)  # Create the folder if it doesn't exist

#List of input files
input_files = [
    "rp_canapi_sub06_240625_WIP1bar_TAP_L_20250624134205_6_nordic_clv",
    "rp_canapi_sub06_240625_WIPlow_TAP_L_20250624134205_7_nordic_clv",
    "rp_canapi_sub06_240625_WIP1bar_TAP_R_20250624134205_4_nordic_clv",
    "rp_canapi_sub06_240625_WIPlow_TAP_R_20250624134205_5_nordic_clv"
]

# input_files = [
#     "rp_Map01_Motor_TW_fwd_20230607123527_18_nordic_NoNoise_toppedup_clv",
#     "rp_Map01_Motor_TW_rev_20230607123527_19_nordic_NoNoise_toppedup_clv",
# ]


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
    tr = 2
    # Convert times in seconds to dynamics
    #timepoints_seconds = [21, 51, 81, 111, 141] #PUSH
    #timepoints_seconds = [21, 61, 101, 141, 181, 221, 261, 301, 341, 381] #TAP

    #timepoints_seconds = [0, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220] #TW
    timepoints_seconds = [0, 16, 32, 48, 64, 80, 96, 112] #TW

    timepoints_dynamics = [int(t / tr) for t in timepoints_seconds]

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
