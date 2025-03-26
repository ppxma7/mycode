import os
import re
import numpy as np
import nibabel as nib
import matplotlib.pyplot as plt
from matplotlib.patches import Patch

root_path = "/Users/spmic/data/postDUST_QUAD_MBSHIFTS/gfac/"
output_plot_path = os.path.join(root_path, "bar_chart_with_MB_SENSE_SHIFT.png")

# Get all files ending with _one_over.nii (both MBRES and MBSHIFTS)
files = [f for f in os.listdir(root_path) if f.startswith('gfactor') and f.endswith('_one_over.nii')]

# Regex to extract MB, SENSE, and optionally SHIFT.
# It matches filenames like:
#   ..._WIPMB2_SENSE2_1p5mmiso_...       (MBRES, no shift)
#   ..._WIPMB2_SENSE2p5_1p5mmiso_shift3_... (MBSHIFTS, shift present)
pattern = r"WIPMB(\d+)_SENSE([0-9p.]+)_1p5mmiso(?:_shift(\d+))?_"

# Build a list of scans, one per file
scans = []

for fname in files:
    fname = os.path.join(root_path, fname)
    m = re.search(pattern, fname)
    if not m:
        print(f"Could not parse {fname}")
        continue
    # Parse MB and SENSE; convert to numeric for proper sorting.
    mb = int(m.group(1))
    sense = float(m.group(2).replace('p','.'))
    # If no shift is found, assign "no_shift" (for MBRES files).
    shift = m.group(3) if m.group(3) is not None else "default"
    
    # Load image and compute mean and std from nonzero voxels.
    img = nib.load(fname)
    data = img.get_fdata()
    #nonzero = data[data > 0]
    threshold = 0.25  # example threshold value
    mask = data < threshold

    # Compute statistics using the mask
    mean_val = np.mean(data[mask])
    std_val = np.std(data[mask])
    #mean_val = np.mean(nonzero)
    #std_val = np.std(nonzero)

    mid_slice = mask.shape[2] // 2
    plt.figure(figsize=(8, 6))
    plt.imshow(mask[:, :, mid_slice], cmap='gray', origin='lower')
    plt.title("Mask (data < {}) at mid slice".format(threshold))
    plt.colorbar(label="Mask Value")
    base_fname = os.path.splitext(fname)[0]  # Remove the .nii extension
    png_fname = base_fname + "_mask_visualization.png"
    plt.savefig(png_fname, dpi=300)
    plt.close()
    
    scans.append({
        "fname": fname,
        "mb": mb,
        "sense": sense,
        "shift": shift,
        "mean": mean_val,
        "std": std_val
    })

# Define a helper for sorting the shift values.
def shift_sort_value(s):
    # Use 0 for no_shift so that MBRES come first, then numeric shifts.
    return 0 if s == "default" else int(s)

# Sort scans by shift (no_shift first), then by MB, then by SENSE.
scans.sort(key=lambda x: (shift_sort_value(x['shift']), x['mb'], x['sense']))

# For debugging, print the sorted filenames with their factors.
print("Sorted scans:")
for s in scans:
    print(s["fname"], "Shift:", s["shift"], "MB:", s["mb"], "SENSE:", s["sense"], "Mean:", s["mean"])

# Prepare data for plotting.
num_scans = len(scans)
x = np.arange(num_scans)
means = [s['mean'] for s in scans]
stds = [s['std'] for s in scans]

# Define colors based on shift (you can adjust these as desired).
color_map = {
    "default": "#999999",  # Gray for MBRES (no shift)
    "2": "#1f77b4",
    "3": "#2ca02c",
    "4": "#d62728"
}
colors = [color_map[s['shift']] for s in scans]

# Create the bar chart.
fig, ax = plt.subplots(figsize=(20, 6))
ax.bar(x, means, yerr=stds, color=colors, capsize=4)
ax.set_xlabel("Scan (sorted by Shift, MB, SENSE)")
ax.set_ylabel("Mean 1/g")
ax.set_title("Mean 1/g for Each Scan")

# Optionally, create a label for each bar showing MB, SENSE, and Shift.
labels = [f"MB{s['mb']}\nS{s['sense']}\nShift:{s['shift']}" for s in scans]
#labels = [f"MB{s['mb']}\nS{s['sense']}" for s in scans]

ax.set_xticks(x)
ax.set_xticklabels(labels, rotation=90, ha='center')
plt.setp(ax.get_xticklabels(), fontsize=8)

# Define a mapping from shift to a color.
legend_handles = [Patch(facecolor=color, label=f"Shift {shift}") for shift, color in color_map.items()]
ax.legend(handles=legend_handles, title="Shift", loc="best")
ax.grid(axis='y', linestyle='--', alpha=0.7)

plt.tight_layout()
plt.savefig(output_plot_path, dpi=300)
print(f"Bar chart saved as {output_plot_path}")
