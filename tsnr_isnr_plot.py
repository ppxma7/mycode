import os
import nibabel as nib
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
# Base directory and folder names
base_dir = "/Users/spmic/data/qaplot/"
folders = [
    "qa_output_postDUST_QUAD_MBRES_WIPMB2_SENSE2_1p25mm",
    "qa_output_postDUST_QUAD_MBRES_WIPMB2_SENSE2_1p50mm",
    "qa_output_postDUST_QUAD_MBRES_WIPMB2_SENSE2_2p00mm"
]

# Define folder-to-ROI center mapping
roi_centers = {
    "qa_output_postDUST_QUAD_MBRES_WIPMB2_SENSE2_1p25mm": (40, 110),
    "qa_output_postDUST_QUAD_MBRES_WIPMB2_SENSE2_1p50mm": (40, 80),
    "qa_output_postDUST_QUAD_MBRES_WIPMB2_SENSE2_2p00mm": (32, 70)

}

# ROI parameters (you can adjust these as needed)
#roi_center = (30, 60)  # (x, y) center of the ROI
roi_size = (20, 20)    # (width, height) of the ROI
ROI_flag = True           # Set to 1 to use the ROI, else process entire volume

# For confidence interval calculation if needed (not used in plotting)
z = 1.96

def process_file(nii_path, roi_center, roi_size, ROI_flag=True):
    """
    Loads a NIfTI file, averages across the 4th dimension,
    extracts a 2D ROI from a chosen slice, filters out the lowest 1%
    of the maximum value, and computes the mean and std.
    """
    nii = nib.load(nii_path)
    data = nii.get_fdata()
    if data.ndim == 4:
        data = data.mean(axis=3)
    #data = data.mean(axis=3)  # collapse 4th dimension, result shape (x, y, z)
    data_shape = data.shape

    x_center, y_center = roi_center
    # Define the ROI bounds in the slice:
    x_start = max(roi_center[0] - roi_size[0] // 2, 0)
    x_end = min(roi_center[0] + roi_size[0] // 2, data_shape[0])
    y_start = max(roi_center[1] - roi_size[1] // 2, 0)
    y_end = min(roi_center[1] + roi_size[1] // 2, data_shape[1])
    
    # Choose a slice index (e.g., 2/3 of total slices)
    slice_index = round(data_shape[2] * 2 / 3)
    slice_data = data[:, :, slice_index]
    roi_data = slice_data[x_start:x_end, y_start:y_end]

    # Flatten ROI data or full data based on ROI_flag
    # Choose between ROI or the full 2D slice
    if ROI_flag:
        roi_data = slice_data[x_start:x_end, y_start:y_end]
        flat_data = roi_data.flatten()
    else:
        flat_data = slice_data.flatten()

    # Remove the bottom 1% of the maximum value
    max_val = np.max(flat_data)
    threshold = 0.01 * max_val
    filtered_data = flat_data[flat_data >= threshold]

    # Calculate mean and standard deviation for the filtered data
    mean_val = np.mean(filtered_data)
    std_val = np.std(filtered_data)

    iSNRmax = slice_data.max()

    # Visualize the slice with the ROI as a rectangle
    fig, ax = plt.subplots(figsize=(8, 8))
    img = ax.imshow(slice_data.T, cmap='plasma', origin='lower', vmin=0, vmax=iSNRmax)  # Transpose for correct orientation

    # Add a rectangle patch representing the ROI
    ax.add_patch(Rectangle(
        (x_start, y_start),  # Bottom-left corner of the ROI
        roi_size[0],         # Width of the rectangle
        roi_size[1],         # Height of the rectangle
        edgecolor='red',
        facecolor='none',
        linewidth=2
    ))
    output_path = os.path.join(base_dir, folder, "slice_with_isnr.png")
    ax.set_title("Slice with ROI")
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    plt.close(fig)
    return mean_val, std_val

# Lists to store results for each folder
tsnr_means = []
tsnr_stds = []
isnr_means = []
isnr_stds = []
labels = []

# Loop over folders and process each file
for folder in folders:
    folder_path = os.path.join(base_dir, folder)
    
    # Process iSNR file

    isnr_file = os.path.join(base_dir, folder, "isnr_isnr_map.nii.gz")
    roi_center = roi_centers[folder]
    isnr_mean, isnr_std = process_file(isnr_file, roi_center, roi_size, ROI_flag=ROI_flag)
    print(f"Folder: {folder}, ROI Center: {roi_center}, Mean: {isnr_mean:.3f}, Std: {isnr_std:.3f}")


    tsnr_file = os.path.join(base_dir, folder, "classic_tsnr_tsnr_map.nii.gz")
    roi_center = roi_centers[folder]
    tsnr_mean, tsnr_std = process_file(tsnr_file, roi_center, roi_size, ROI_flag=ROI_flag)
    print(f"Folder: {folder}, ROI Center: {roi_center}, Mean: {tsnr_mean:.3f}, Std: {tsnr_std:.3f}")

    #isnr_file = os.path.join(folder_path, "isnr_isnr_map.nii.gz")
    #isnr_mean, isnr_std = process_file(isnr_file, ROI_flag=ROI_flag)
    
    # Process tSNR file
    #tsnr_file = os.path.join(folder_path, "classic_tsnr_tsnr_map.nii.gz")
    #tsnr_mean, tsnr_std = process_file(tsnr_file, ROI_flag=ROI_flag)
    
    # Save the results for plotting
    isnr_means.append(isnr_mean)
    isnr_stds.append(isnr_std)
    tsnr_means.append(tsnr_mean)
    tsnr_stds.append(tsnr_std)
    labels.append(folder)
    
    print(f"Processed {folder}: iSNR Mean = {isnr_mean:.3f}, STD = {isnr_std:.3f}; "
          f"tSNR Mean = {tsnr_mean:.3f}, STD = {tsnr_std:.3f}")

# Create the scatter plot: tSNR on x-axis, iSNR on y-axis.

point_labels = ["1.25mm", "1.5mm", "2mm"]

# Plot error bars: tSNR on x-axis, iSNR on y-axis

# Use a seaborn style for a cleaner look
available_styles = plt.style.available
style_to_use = "seaborn-darkgrid" if "seaborn-darkgrid" in available_styles else "default"
plt.style.use(style_to_use)

#plt.style.use('seaborn-darkgrid')


plt.figure(figsize=(8, 6))
# plt.errorbar(tsnr_means, isnr_means, xerr=tsnr_stds, yerr=isnr_stds,
#              fmt='o', capsize=5, label='Mean')

plt.errorbar(tsnr_means, isnr_means, xerr=tsnr_stds, yerr=isnr_stds,
            fmt='o', capsize=5, markersize=6,
            color='tab:blue', ecolor='tab:gray', elinewidth=2, markeredgewidth=2,
            label='Mean')

# Add labels to each point
# for x, y, lab in zip(tsnr_means, isnr_means, point_labels):
#     plt.text(x, y, lab, fontsize=10, ha='right', va='bottom')

for x, y, label in zip(tsnr_means, isnr_means, point_labels):
    plt.annotate(label, (x, y), textcoords="offset points", xytext=(5, 5),
                ha='center', fontsize=8, color='darkred')

# Determine maximum value (considering error bars) for axis limits
max_limit = max(
    max([t + s for t, s in zip(tsnr_means, tsnr_stds)]),
    max([i + s for i, s in zip(isnr_means, isnr_stds)])
) * 1.1  # add 10% padding

max_limit = 400

# Plot unity line x=y from (0,0) to (max_limit, max_limit)
#plt.plot([0, max_limit], [0, max_limit], 'k--', label='x = y')

plt.plot([0, max_limit], [0, max_limit], linestyle='--', color='tab:orange',
        label='x = y', linewidth=2)

# Set axes to start at 0 and use equal scaling
plt.xlim(0, max_limit)
plt.ylim(0, max_limit)
plt.gca().set_aspect('equal', adjustable='box')

plt.grid(True, which='both', linestyle='--', linewidth=0.5)

plt.xlabel("tSNR")
plt.ylabel("iSNR")
plt.title("tSNR vs iSNR in ROI")
plt.legend()

# Save the figure (does not display)
if ROI_flag:
    output_plot_path = base_dir + "roichart.png"
else:
    output_plot_path = base_dir + "fullchart.png"

#output_fig_path = "tsnr_vs_isnr.png"
plt.savefig(output_plot_path,dpi=300)
plt.close()

# Save the figure to file (do not display)


print(f"Figure saved as: {output_plot_path}")
