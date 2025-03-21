import os
import nibabel as nib
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle

# Base directory and folder names for 9 datasets
base_dir = "/Users/spmic/data/qa_outputs_1p5/"
folders = [
    "qa_output_postDUST_QUAD_MBRES_1p5_1p25_WIPMB2_SENSE2_1p5mmiso_20250304120306_7_clipped",
    "qa_output_postDUST_QUAD_MBRES_1p5_1p25_WIPMB2_SENSE2p5_1p5mmiso_20250304120306_8_clipped",
    "qa_output_postDUST_QUAD_MBRES_1p5_1p25_WIPMB2_SENSE3_1p5mmiso_20250304120306_9_clipped",
    "qa_output_postDUST_QUAD_MBRES_1p5_1p25_WIPMB3_SENSE2_1p5mmiso_20250304120306_10_clipped",
    "qa_output_postDUST_QUAD_MBRES_1p5_1p25_WIPMB3_SENSE2p5_1p5mmiso_20250304120306_11_clipped",
    "qa_output_postDUST_QUAD_MBRES_1p5_1p25_WIPMB3_SENSE3_1p5mmiso_20250304120306_12_clipped",
    "qa_output_postDUST_QUAD_MBRES_1p5_1p25_WIPMB4_SENSE2_1p5mmiso_20250304120306_13_clipped",
    "qa_output_postDUST_QUAD_MBRES_1p5_1p25_WIPMB4_SENSE2p5_1p5mmiso_20250304120306_14_clipped",
    "qa_output_postDUST_QUAD_MBRES_1p5_1p25_WIPMB4_SENSE3_1p5mmiso_20250304120306_15_clipped"
]

# Use the same ROI center for all folders
roi_center = (40, 82)  # (x, y) center for the ROI
roi_size = (20, 20)    # ROI size (width, height)
ROI_flag = True        # Set to True to use the ROI; set to False to use the full 2D slice

def process_file(nii_path, roi_center, roi_size, ROI_flag=True):
    """
    Loads a NIfTI file, averages across the 4th dimension if present,
    extracts a 2D ROI from a chosen slice, filters out the lowest 1%
    of the maximum value, and computes the mean and std.
    Also saves a visualization of the selected slice with the ROI overlay.
    """
    nii = nib.load(nii_path)
    data = nii.get_fdata()
    if data.ndim == 4:
        data = data.mean(axis=3)
    data_shape = data.shape

    # Define ROI bounds based on the constant ROI center
    x_center, y_center = roi_center
    x_start = max(x_center - roi_size[0] // 2, 0)
    x_end = min(x_center + roi_size[0] // 2, data_shape[0])
    y_start = max(y_center - roi_size[1] // 2, 0)
    y_end = min(y_center + roi_size[1] // 2, data_shape[1])
    
    # Choose a slice index (e.g., 2/3 of total slices)
    slice_index = round(data_shape[2] * 2 / 3)
    slice_data = data[:, :, slice_index]
    
    # Use either the ROI or the full 2D slice
    if ROI_flag:
        flat_data = slice_data[x_start:x_end, y_start:y_end].flatten()
    else:
        flat_data = slice_data.flatten()

    # Remove the bottom 1% of the maximum value
    max_val = np.max(flat_data)
    threshold = 0.01 * max_val
    filtered_data = flat_data[flat_data >= threshold]

    # Calculate mean and standard deviation
    mean_val = np.mean(filtered_data)
    std_val = np.std(filtered_data)

    # Save visualization of the slice with ROI overlay
    iSNRmax = slice_data.max()
    fig, ax = plt.subplots(figsize=(8, 8))
    ax.imshow(slice_data.T, cmap='plasma', origin='lower', vmin=0, vmax=iSNRmax)
    ax.add_patch(Rectangle(
        (x_start, y_start),
        roi_size[0],
        roi_size[1],
        edgecolor='red',
        facecolor='none',
        linewidth=2
    ))
    ax.set_title("Slice with ROI")
    # Save visualization in the same folder as the data
    vis_path = os.path.join(os.path.dirname(nii_path), "slice_with_roi.png")
    plt.savefig(vis_path, dpi=300, bbox_inches='tight')
    plt.close(fig)
    
    return mean_val, std_val

# Lists to store results for each folder
tsnr_means = []
tsnr_stds = []
isnr_means = []
isnr_stds = []
point_labels = []  # will be generated from folder names

# Loop over folders and process both iSNR and tSNR maps
for folder in folders:
    folder_path = os.path.join(base_dir, folder)
    
    # Process iSNR map
    isnr_file = os.path.join(folder_path, "isnr_isnr_map.nii.gz")
    isnr_mean, isnr_std = process_file(isnr_file, roi_center, roi_size, ROI_flag=ROI_flag)
    
    # Process tSNR map
    tsnr_file = os.path.join(folder_path, "classic_tsnr_tsnr_map.nii.gz")
    tsnr_mean, tsnr_std = process_file(tsnr_file, roi_center, roi_size, ROI_flag=ROI_flag)
    
    isnr_means.append(isnr_mean)
    isnr_stds.append(isnr_std)
    tsnr_means.append(tsnr_mean)
    tsnr_stds.append(tsnr_std)
    
    # Generate a label by extracting MB and SENSE info from folder name
    parts = folder.split("_")
    mb = [p for p in parts if p.startswith("WIPMB")]
    sense = [p for p in parts if p.startswith("SENSE")]
    if mb and sense:
        lab = mb[0].replace("WIP", "") + " " + sense[0].replace("SENSE", "S")
    else:
        lab = folder  # fallback to full folder name if parsing fails
    point_labels.append(lab)
    
    print(f"Processed {folder}: iSNR Mean = {isnr_mean:.3f}, STD = {isnr_std:.3f}; "
          f"tSNR Mean = {tsnr_mean:.3f}, STD = {tsnr_std:.3f}")

# Now create a prettier scatter plot with 9 points
available_styles = plt.style.available
style_to_use = "seaborn-darkgrid" if "seaborn-darkgrid" in available_styles else "default"
plt.style.use(style_to_use)

fig, ax = plt.subplots(figsize=(10, 8))
ax.errorbar(tsnr_means, isnr_means, xerr=tsnr_stds, yerr=isnr_stds,
            fmt='o', capsize=5, markersize=8,
            color='tab:blue', ecolor='tab:gray', elinewidth=2, markeredgewidth=2,
            label='ROI Mean')

# Annotate each point slightly off-center
for x, y, lab in zip(tsnr_means, isnr_means, point_labels):
    ax.annotate(lab, (x, y), textcoords="offset points", xytext=(5, 5),
                ha='left', va='top', fontsize=10, color='darkred')

# Determine maximum axis limit (or set a fixed one if desired)
max_limit = max(
    max([t + s for t, s in zip(tsnr_means, tsnr_stds)]),
    max([i + s for i, s in zip(isnr_means, isnr_stds)])
) * 1.1
# For example, you can also use a fixed limit:
# max_limit = 400

# Plot the unity line x = y
ax.plot([0, max_limit], [0, max_limit], linestyle='--', color='tab:orange',
        label='x = y', linewidth=2)

ax.set_xlim(0, max_limit)
ax.set_ylim(0, max_limit)
ax.set_aspect('equal', adjustable='box')
ax.grid(True, which='both', linestyle='--', linewidth=0.5)
ax.set_xlabel("tSNR", fontsize=14)
ax.set_ylabel("iSNR", fontsize=14)
ax.set_title("tSNR vs iSNR in ROI", fontsize=16)
ax.legend(fontsize=12)

# Save the scatter plot
output_plot_path = os.path.join(base_dir, "tsnr_vs_isnr_pretty.png")
plt.savefig(output_plot_path, dpi=300, bbox_inches='tight')
plt.close(fig)

print(f"Scatter plot saved as: {output_plot_path}")
