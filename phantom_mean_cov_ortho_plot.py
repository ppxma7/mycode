import os
import re
import numpy as np
import nibabel as nib
import matplotlib.pyplot as plt
from matplotlib.patches import Patch

# Define paths and parameters
root_path = "/Users/spmic/data/gre_se_shifts_head_020425/magnitude/mmisc/se/"
output_plot_path = os.path.join(root_path, "bar_chart_shifts.png")
threshold = 5000  # Set your threshold value here

# Get list of nii.gz files
files = [f for f in os.listdir(root_path) if f.endswith('.nii')]

# Updated pattern to match filenames like:
# gre_se_shifts_020425_WIPMB2_GREEPI_S3_1p5mmiso_shift0_20250402092939_16.nii.gz
#pattern = r"gre_se_shifts_020425_WIPMB(\d+)_(GREEPI|SEEPI)_S(\d+)_((?:\d+(?:p\d+)?mmiso))_shift(\d+)_\d+_\d+\.nii\.gz"


if "magnitude/se/" in root_path:
    # Pattern for magnitude images
    pattern = r"gre_se_shifts_head_020425_WIPMB(\d+)_SEEPI_S(\d+)_((?:\d+(?:p\d+)?mmiso))_shift(\d+)_\d+_\d+\.nii\.gz"
    vmax_val = 100000 #200000
    ymax = 1
else:
    pattern = r"gre_se_shifts_head_020425_WIPMB(\d+)_GREEPI_S(\d+)_((?:\d+(?:p\d+)?mmiso))_shift(\d+)_\d+_\d+\.nii\.gz"
    vmax_val = 35000 #100000
    ymax = 1

pattern = r"gre_se_shifts_head_020425_WIPMB(\d+)_SEEPI_S(\d+)_((?:\d+(?:p\d+)?mmiso))_shift(\d+)_\d+_\d+\.nii"
vmax_val = 100000 #100000
ymax = 1

#pattern = r"gre_se_shifts_020425_WIPMB(\d+)_SEEPI_S(\d+)_((?:\d+(?:p\d+)?mmiso))_shift(\d+)_\d+_\d+\.nii\.gz"

# List to store scan info for later plotting
scans = []

# Define rotation multiplier 
rotMult = 3

# Define mask max value for visualization
maskmax = vmax_val

# Define vmin and vmax
vmin_val = 0
#vmax_val = 200000
#vmax_val = 100000

#bar char
ymin = 0
#ymax = 1

for fname in files:
    full_path = os.path.join(root_path, fname)
    m = re.search(pattern, fname)
    if not m:
        print(f"Could not parse {fname}")
        continue

    # Extract parameters from the filename
    mb = int(m.group(1))
    s_value = int(m.group(2))
    # Extract resolution numeric part from e.g., "1p5mmiso"
    res_str = m.group(3)
    res_numeric = res_str.split("mmiso")[0]
    sense = float(res_numeric.replace('p', '.'))
    shift = m.group(4)
    
    # Load image and compute the mean image (exclude the last volume if 4D)
    img = nib.load(full_path)
    data = img.get_fdata()
    if data.ndim == 4 and data.shape[3] > 1:
        mean_volume = np.mean(data[..., :-1], axis=3)
    elif data.ndim == 4:
        mean_volume = data[..., 0]
    else:
        mean_volume = data

    # Determine base filename (without extension) for saving outputs
    base_fname = os.path.splitext(os.path.splitext(full_path)[0])[0]

    # --- Save the mean image in three orientations ---

    # Compute mid-slices for each orientation
    sagittal_slice = mean_volume.shape[0] // 2
    coronal_slice = mean_volume.shape[1] // 2
    axial_slice = mean_volume.shape[2] // 2

 # Create a figure with 3 subplots (1 row, 3 columns)
    fig, axes = plt.subplots(1, 3, figsize=(18, 7))

    # Compute mid-slices for each orientation
    sagittal_slice = mean_volume.shape[0] // 2
    coronal_slice = mean_volume.shape[1] // 2
    axial_slice = mean_volume.shape[2] // 2


    # Sagittal view (slice along x-axis)
    axes[0].imshow(np.rot90(mean_volume[sagittal_slice, :, :],k=rotMult), cmap='gray', origin='lower', vmin=vmin_val, vmax=vmax_val)
    axes[0].set_title("Sagittal View")
    axes[0].axis("off")

    # Coronal view (slice along y-axis)
    axes[1].imshow(np.rot90(mean_volume[:, coronal_slice, :],k=rotMult), cmap='gray', origin='lower', vmin=vmin_val, vmax=vmax_val)
    axes[1].set_title("Coronal View")
    axes[1].axis("off")

    # Axial view (slice along z-axis)
    axes[2].imshow(np.rot90(mean_volume[:, :, axial_slice],k=rotMult), cmap='gray', origin='lower', vmin=vmin_val, vmax=vmax_val)
    axes[2].set_title("Axial View")
    axes[2].axis("off")

    plt.tight_layout()
    plt.savefig(base_fname + "_mean_orientations.png", dpi=300)
    plt.close()


    # --- Create mask and calculate Coefficient of Variation (CoV) ---

    # Create mask based on the threshold
    mask = mean_volume > threshold
    region_values = mean_volume[mask]

    region_mean = np.mean(region_values) if region_values.size else np.nan
    region_std = np.std(region_values) if region_values.size else np.nan
    coef_variation = region_std / region_mean if region_mean else np.nan

    # Choose a mid-slice along the z-axis for visualization of the mask and masked image
    mid_slice = mean_volume.shape[2] // 2

    # Save mask visualization
    plt.figure(figsize=(8, 6))
    plt.imshow(mask[:, :, mid_slice], cmap='gray', origin='lower')
    plt.title(f"Mask (mean > {threshold}) at mid slice")
    plt.colorbar(label="Mask Value")
    mask_png_fname = base_fname + "_mask_visualization.png"
    plt.savefig(mask_png_fname, dpi=300)
    plt.close()

    # Create masked mean image (set values below threshold to 0) and save visualization
    masked_mean = np.where(mask, mean_volume, 0)
    plt.figure(figsize=(8, 6))
    plt.imshow(masked_mean[:, :, mid_slice], cmap='viridis', origin='lower', vmin=0, vmax=maskmax)
    plt.axis('off')  # Remove axis bars
    masked_mean_png_fname = base_fname + "_masked_mean_visualization.png"
    plt.savefig(masked_mean_png_fname, dpi=300, bbox_inches='tight', pad_inches=0)
    plt.close()

    # Collect scan information for plotting later
    scans.append({
        "fname": fname,
        "mb": mb,
        "sense": sense,
        "shift": shift,
        "region_mean": region_mean,
        "region_std": region_std,
        "coef_variation": coef_variation
    })

# --- Sorting and plotting the bar chart ---

# Define a helper function for sorting shifts (if shift is 'default', return 0; otherwise, integer value)
def shift_sort_value(s):
    return 0 if s == "default" else int(s)

# Sort scans by shift, then by MB and SENSE (resolution)
#scans.sort(key=lambda x: (shift_sort_value(x['shift']), x['mb'], x['sense']))
scans.sort(key=lambda x: (x['mb'], shift_sort_value(x['shift']), x['sense']))

# Debug prints for sorted scans
print("Sorted scans:")
for s in scans:
    print(f"{s['fname']} Shift: {s['shift']} MB: {s['mb']} SENSE: {s['sense']} CV: {s['coef_variation']:.4f}")

# Prepare data for plotting (Coefficient of Variation as Homogeneity)
num_scans = len(scans)
x = np.arange(num_scans)
homogeneity_values = [s['coef_variation'] for s in scans]

# Define colors based on shift value (update colors if needed)
color_map = {
    "0": "#66c2a5",  # greenish teal
    "2": "#fc8d62",  # soft orange
    "3": "#8da0cb",  # light blue
    "4": "#e78ac3",  # pink
    "5": "#a6d854",  # lime green
    "6": "#ffd92f"   # bright yellow
}
colors = [color_map.get(s['shift'], "#888888") for s in scans]

# Create the bar chart
fig, ax = plt.subplots(figsize=(16, 6))
ax.bar(x, homogeneity_values, color=colors, capsize=4)
ax.set_xlabel("Scan (sorted by Shift, MB, SENSE)")
ax.set_ylabel("Coefficient of Variation (Homogeneity)")
ax.set_title("Homogeneity of Mean Image (CV) for Each Scan")

# Create bar labels from MB, SENSE (resolution) and shift information
labels = [f"MB{s['mb']}\nS{s['sense']}\nShift:{s['shift']}" for s in scans]
ax.set_xticks(x)
ax.set_xticklabels(labels, rotation=90, ha='center')
plt.setp(ax.get_xticklabels(), fontsize=8)

# Create legend for shifts
unique_shifts = sorted(set(s['shift'] for s in scans), key=shift_sort_value)
legend_handles = [Patch(facecolor=color_map[shift], label=f"Shift {shift}") for shift in unique_shifts]
ax.legend(handles=legend_handles, title="Shift", loc="best")
ax.grid(axis='y', linestyle='--', alpha=0.7)
plt.ylim(ymin, ymax)
plt.tight_layout()
plt.savefig(output_plot_path, dpi=300)
plt.close()
print(f"Bar chart saved as {output_plot_path}")
