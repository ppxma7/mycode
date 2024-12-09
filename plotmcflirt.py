import numpy as np
import matplotlib.pyplot as plt
import os

# Input and output folders
input_folder = "/Volumes/hermes/canapi_051224/fslanalysis/"  # Replace with your input folder path
output_folder = os.path.join(input_folder, "motion_plots")  # Output folder for saving plots
os.makedirs(output_folder, exist_ok=True)  # Create the folder if it doesn't exist

# List of input files
input_files = [
    "parrec_WIP1bar_20241205082447_6_nordic_clv",
    "parrec_WIP1bar_20241205082447_10_nordic_clv",
    "parrec_WIP30prc_20241205082447_5_nordic_clv",
    "parrec_WIP30prc_20241205082447_9_nordic_clv",
    "parrec_WIP50prc_20241205082447_4_nordic_clv",
    "parrec_WIP50prc_20241205082447_8_nordic_clv"
]

# Loop through each file
for file in input_files:
    par_file = os.path.join(input_folder, file + "_mc.par")  # Assuming motion parameter files end with "_mc.par"
    
    # Check if the .par file exists
    if not os.path.exists(par_file):
        print(f"Motion parameter file not found: {par_file}")
        continue

    # Load the motion parameters
    motion_params = np.loadtxt(par_file)

    # Plot translations and rotations
    fig, axes = plt.subplots(2, 1, figsize=(10, 6), sharex=True)

    # Plot rotations (columns 0-2)
    axes[0].plot(motion_params[:, 0], label='X Rotation')
    axes[0].plot(motion_params[:, 1], label='Y Rotation')
    axes[0].plot(motion_params[:, 2], label='Z Rotation')
    axes[0].set_title('Rotations')
    axes[0].set_ylabel('Rotations (radians)')
    axes[0].legend()

    # Plot translations (columns 3-5)
    axes[1].plot(motion_params[:, 3], label='X Translation')
    axes[1].plot(motion_params[:, 4], label='Y Translation')
    axes[1].plot(motion_params[:, 5], label='Z Translation')
    axes[1].set_title('Translations')
    axes[1].set_xlabel('Volume')
    axes[1].set_ylabel('Translation (mm)')
    axes[1].legend()

    # Save the plot as PNG
    plot_file = os.path.join(output_folder, f"{file}_motion_plot.png")
    plt.tight_layout()
    plt.savefig(plot_file, dpi=300)
    plt.close()  # Close the plot to free memory
    print(f"Saved motion parameter plot: {plot_file}")
