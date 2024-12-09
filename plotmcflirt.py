import numpy as np
import matplotlib.pyplot as plt
import os

input_folder = "/Volumes/hermes/canapi_051224/fslanalysis/"  # Replace with your input folder path
file = "parrec_WIP1bar_20241205082447_6_nordic_clv_mc"
par_file = os.path.join(input_folder, file + ".par")


# Load the motion parameters
motion_params = np.loadtxt(par_file)

# Plot translations and rotations
fig, axes = plt.subplots(2, 1, figsize=(10, 6), sharex=True)

# Plot translations (columns 0-2)
axes[0].plot(motion_params[:, 0], label='X Rotation')
axes[0].plot(motion_params[:, 1], label='Y Rotation')
axes[0].plot(motion_params[:, 2], label='Z Rotation')
axes[0].set_title('Rotations')
axes[0].set_ylabel('Rotations (radians)')
axes[0].legend()

# Plot rotations (columns 3-5)
axes[1].plot(motion_params[:, 3], label='X Translation')
axes[1].plot(motion_params[:, 4], label='Y Translation')
axes[1].plot(motion_params[:, 5], label='Z Translation')
axes[1].set_title('Translation')
axes[1].set_xlabel('Volume')
axes[1].set_ylabel('Translation (mm)')
axes[1].legend()

plt.tight_layout()
plt.show()
