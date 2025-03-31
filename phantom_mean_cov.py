import os
import re
import numpy as np
import nibabel as nib
import matplotlib.pyplot as plt
from matplotlib.patches import Patch

root_path = "/Users/spmic/data/postDUST_QUAD_SEEPI_MBSHIFTS_2mm/gfac/"
output_plot_path = os.path.join(root_path, "bar_chart_homogeneity_MB_SENSE_SHIFT.png")

files = [f for f in os.listdir(root_path) if f.endswith('.nii')]

pattern = r"postDUST_QUAD_SEEPI_MBSHIFTS_2mm_WIPMB(\d+)_SEEPI_S([0-9p.]+)_2mmiso_shift(\d+)_\d+_\d+_nordic\.nii"

scans = []
threshold = 20000

for fname in files:
    full_path = os.path.join(root_path, fname)
    m = re.search(pattern, fname)
    if not m:
        print(f"Could not parse {fname}")
        continue

    mb = int(m.group(1))
    sense = float(m.group(2).replace('p', '.'))
    shift = m.group(3)

    img = nib.load(full_path)
    data = img.get_fdata()

    if data.ndim == 4 and data.shape[3] > 1:
        mean_volume = np.mean(data[..., :-1], axis=3)
    elif data.ndim == 4:
        mean_volume = data[..., 0]
    else:
        mean_volume = data

    # Create mask based on threshold
    mask = mean_volume > threshold
    region_values = mean_volume[mask]

    region_mean = np.mean(region_values) if region_values.size else np.nan
    region_std = np.std(region_values) if region_values.size else np.nan
    coef_variation = region_std / region_mean if region_mean else np.nan

    # Choose a mid-slice along the z-axis for visualization
    mid_slice = mask.shape[2] // 2

    # Save mask visualization
    plt.figure(figsize=(8, 6))
    plt.imshow(mask[:, :, mid_slice], cmap='gray', origin='lower')
    plt.title(f"Mask (mean > {threshold}) at mid slice")
    plt.colorbar(label="Mask Value")
    base_fname = os.path.splitext(full_path)[0]
    mask_png_fname = base_fname + "_mask_visualization.png"
    plt.savefig(mask_png_fname, dpi=300)
    plt.close()

    # Create masked mean image (set values below threshold to 0)
    masked_mean = np.where(mask, mean_volume, 0)
    plt.figure(figsize=(8, 6))
    plt.imshow(masked_mean[:, :, mid_slice], cmap='viridis', origin='lower', vmin=0, vmax=250000)
    plt.axis('off')  # Remove axis bars
    masked_mean_png_fname = base_fname + "_masked_mean_visualization.png"
    plt.savefig(masked_mean_png_fname, dpi=300, bbox_inches='tight', pad_inches=0)
    plt.close()

    scans.append({
        "fname": fname,
        "mb": mb,
        "sense": sense,
        "shift": shift,
        "region_mean": region_mean,
        "region_std": region_std,
        "coef_variation": coef_variation
    })

# Sorting logic
def shift_sort_value(s):
    return 0 if s == "default" else int(s)

scans.sort(key=lambda x: (shift_sort_value(x['shift']), x['mb'], x['sense']))

# Debugging prints
print("Sorted scans:")
for s in scans:
    print(f"{s['fname']} Shift: {s['shift']} MB: {s['mb']} SENSE: {s['sense']} CV: {s['coef_variation']:.4f}")

# Prepare data for plotting (Coefficient of Variation as Homogeneity)
num_scans = len(scans)
x = np.arange(num_scans)
homogeneity_values = [s['coef_variation'] for s in scans]

# Define colors based on shift
color_map = {
    "0": "#999999",
    "1": "#ff7f0e",
    "2": "#1f77b4",
    "3": "#2ca02c",
    "4": "#d62728"
}
colors = [color_map.get(s['shift'], "#888888") for s in scans]

# Create the bar chart
fig, ax = plt.subplots(figsize=(20, 6))
ax.bar(x, homogeneity_values, color=colors, capsize=4)
ax.set_xlabel("Scan (sorted by Shift, MB, SENSE)")
ax.set_ylabel("Coefficient of Variation (Homogeneity)")
ax.set_title("Homogeneity of Mean Image (CV) for Each Scan")

# Bar labels
labels = [f"MB{s['mb']}\nS{s['sense']}\nShift:{s['shift']}" for s in scans]
ax.set_xticks(x)
ax.set_xticklabels(labels, rotation=90, ha='center')
plt.setp(ax.get_xticklabels(), fontsize=8)

# Legend for shifts
unique_shifts = sorted(set(s['shift'] for s in scans), key=shift_sort_value)
legend_handles = [Patch(facecolor=color_map[shift], label=f"Shift {shift}") for shift in unique_shifts]
ax.legend(handles=legend_handles, title="Shift", loc="best")
ax.grid(axis='y', linestyle='--', alpha=0.7)

plt.tight_layout()
plt.savefig(output_plot_path, dpi=300)
print(f"Bar chart saved as {output_plot_path}")
