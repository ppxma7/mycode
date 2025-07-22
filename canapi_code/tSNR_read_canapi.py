import os
import numpy as np

import nibabel as nib
import matplotlib.pyplot as plt
from scipy.stats import norm
from matplotlib.patches import Rectangle
from matplotlib import colormaps
import pandas as pd
import statsmodels.api as sm
from statsmodels.formula.api import ols
from statsmodels.stats.multicomp import pairwise_tukeyhsd
import seaborn as sns
import re

# ==== CONFIG ====
root_path = "/Volumes/kratos/"
savedir = "/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/grouplevel_results/"
mode = 'doroi'  # 'dogen' for whole image, 'doroi' for ROI
ROI = 1 if mode == 'doroi' else 0
tSNRmax = 150
tSNRmin = 0
slice_index = 18  # slice to take for ROI


# ==== CONFIDENCE ====
z = norm.ppf(0.975)  # 95% confidence
means = []
stds = []
labels_for_bar = []

# ==== SUBJECT LOOP ====
subject_folders = sorted([
    f for f in os.listdir(root_path)
    if os.path.isdir(os.path.join(root_path, f)) and f.startswith("canapi_sub")
])

print(f"Found {len(subject_folders)} subject folders.")
print("Subject folders:", subject_folders)
#subject_folders = ['canapi_sub03_180325', 'canapi_sub04_280425']

for subj in subject_folders:
    subj_match = re.search(r"canapi_sub(\d+)", subj)
    if not subj_match:
        print(f"Could not extract subject ID from folder name {subj}")
        continue
    subj_id = f"sub{subj_match.group(1)}"

    qa_dir = os.path.join(root_path, subj, 'qa_outputs_afterrealign')
    if not os.path.exists(qa_dir):
        continue

    scan_folders = sorted([
        f for f in os.listdir(qa_dir)
        if os.path.isdir(os.path.join(qa_dir, f)) and f.startswith("qa_output")
    ])

    for scan in scan_folders:
        tsnr_path = os.path.join(qa_dir, scan, "tsnr_tsnr_map.nii.gz")
        if not os.path.exists(tsnr_path):
            print(f"Missing file: {tsnr_path}")
            continue

        try:
            nii = nib.load(tsnr_path)
            data = nii.get_fdata()
            data_shape = data.shape

            # ==== ROI ====
            if ROI == 1:
                roi_center = (45, 36)
                roi_size = (20, 20)
                x_start = max(roi_center[0] - roi_size[0] // 2, 0)
                x_end = min(roi_center[0] + roi_size[0] // 2, data_shape[0])
                y_start = max(roi_center[1] - roi_size[1] // 2, 0)
                y_end = min(roi_center[1] + roi_size[1] // 2, data_shape[1])

                slice_data = data[:, :, slice_index]
                roi_data = slice_data[x_start:x_end, y_start:y_end]
                flat_data = roi_data.flatten()
            else:
                flat_data = data.flatten()

            # Filter low values (bottom 5%)
            threshold = 0.05 * np.max(flat_data)
            filtered_data = flat_data[flat_data >= threshold]

            # Extract scan label from scan folder name, handling optional WIP prefix
            scan_match = re.search(r"_WIP?(1bar|low)_TAP_(R|L)", scan)
            if not scan_match:
                print(f"Could not parse scan label from folder name: {scan}")
                continue
            scan_label = scan_match.group(1) + scan_match.group(2)  # e.g. '1barR'


            mean_val = np.mean(filtered_data)
            std_val = np.std(filtered_data)

            means.append(mean_val)
            stds.append(std_val)
            labels_for_bar.append(f"{subj_id}_{scan_label}")


            # Visualize the slice with the ROI as a rectangle
            fig, ax = plt.subplots(figsize=(8, 8))
            img = ax.imshow(slice_data.T, cmap='plasma', origin='lower', vmin=0, vmax=tSNRmax)  # Transpose for correct orientation

            # Add rectangle showing ROI
            ax.add_patch(Rectangle(
            (y_start, x_start),  # ⚠️ note: y and x flipped due to .T
            roi_size[1],         # width in Y after transpose
            roi_size[0],         # height in X after transpose
            edgecolor='red',
            facecolor='none',
            linewidth=2
            ))

            ax.set_title(f"Slice {slice_index} with ROI")
            ax.set_xlabel("X-axis (voxels)")
            ax.set_ylabel("Y-axis (voxels)")
            cbar = fig.colorbar(img, ax=ax, orientation="vertical", shrink=0.8)
            cbar.set_label("tSNR")

            # Add mean tSNR text on the plot
            ax.text(
            5, 5,
            f"ROI tSNR: {mean_val:.2f}",
            color='white',
            fontsize=12,
            backgroundcolor='black'
            )

            # Save the figure in the scan folder
            roi_vis_path = roi_vis_path = os.path.join(savedir, f"slice_with_tsnr_{scan}_afterrealign.png")
            plt.savefig(roi_vis_path, dpi=300, bbox_inches='tight')
            plt.close(fig)
            print(f"ROI visual saved to {roi_vis_path}")


            print(f"{subj}/{scan}: mean={mean_val:.2f}, std={std_val:.2f}")

        except Exception as e:
            print(f"Error processing {tsnr_path}: {e}")

# ==== BAR PLOT ====


# === CONFIG ===
scan_colors = {
    '1barR': "#FFEDA0",
    '1barL': "#FD8D3C",
    'lowR': "#E31A1C",
    'lowL': "#BD0026"
}
#scan_colors = ['#FFEDA0', '#FD8D3C', '#E31A1C', '#BD0026', '#800026']
bar_width = 0.2

# === Collect structured data ===
subject_ids = []
scan_labels_all = set()
subject_scan_dict = {}

for label, mean, std in zip(labels_for_bar, means, stds):
    # Extract subj_id and scan_label
    subj_match = re.match(r"(sub\d+)_", label)
    scan_match = re.search(r"_(1bar|low)(R|L)$", label)

    if not subj_match or not scan_match:
        print(f"Could not parse label: {label}")
        continue

    subj_id = subj_match.group(1)
    scan_label = scan_match.group(1) + scan_match.group(2)

    scan_labels_all.add(scan_label)

    if subj_id not in subject_scan_dict:
        subject_scan_dict[subj_id] = {}
        subject_ids.append(subj_id)

    subject_scan_dict[subj_id][scan_label] = {'mean': mean, 'std': std}


for subj, scans in subject_scan_dict.items():
    print(f"\nSubject {subj}")
    for scan, stats in scans.items():
        print(f"  {scan}: mean={stats['mean']:.2f}, std={stats['std']:.2f}")


# Sort subjects and scan labels consistently
subject_ids.sort()
scan_order = sorted(scan_labels_all, key=lambda s: (s[-1], s))  # Sort by side (L/R), then type

# === Plot ===
fig, ax = plt.subplots(figsize=(12, 6))
x = np.arange(len(subject_ids))

for i, scan in enumerate(scan_order):
    bar_means = [subject_scan_dict[subj].get(scan, {}).get('mean', np.nan) for subj in subject_ids]
    bar_stds = [subject_scan_dict[subj].get(scan, {}).get('std', 0) for subj in subject_ids]

    ax.bar(
        x + i * bar_width,
        bar_means,
        yerr=bar_stds,
        width=bar_width,
        label=scan,
        color=scan_colors.get(scan, 'gray'),
        capsize=3
    )

# === Format plot ===
ax.set_xticks(x + bar_width * (len(scan_order) - 1) / 2)
ax.set_xticklabels(subject_ids, rotation=45)
ax.set_ylabel("tSNR")
ax.set_title("tSNR by Subject and Scan Type")
ax.legend(title="Scan Type")
ax.set_ylim(tSNRmin, tSNRmax)
ax.grid(axis='y', linestyle='--', alpha=0.5)

# === Save ===
output_path = os.path.join(savedir, "tSNR_grouped_bar_chart_afterrealign.png")
plt.tight_layout()
plt.savefig(output_path, dpi=300)
plt.close()

print(f"Grouped bar chart saved to: {output_path}")

# Create a dataframe from the mean values
anova_data = []

for label, mean in zip(labels_for_bar, means):
    subj_match = re.match(r"(sub\d+)_", label)
    if subj_match:
        subj_id = subj_match.group(1)
        anova_data.append({'Subject': subj_id, 'tSNR': mean})

df = pd.DataFrame(anova_data)

# Run one-way ANOVA
model = ols('tSNR ~ C(Subject)', data=df).fit()
anova_table = sm.stats.anova_lm(model, typ=2)
print("\n=== ANOVA Results ===")
print(anova_table)

# Save ANOVA table
anova_csv_path = os.path.join(savedir, "anova_tsnr_by_subject_afterrealign.csv")
anova_table.to_csv(anova_csv_path)
print(f"ANOVA table saved to {anova_csv_path}")


# Run Tukey's HSD test
tukey = pairwise_tukeyhsd(endog=df['tSNR'], groups=df['Subject'], alpha=0.05)
print("\n=== Tukey HSD Results ===")
print(tukey.summary())

# Convert Tukey HSD summary to DataFrame and save
# statsmodels uses group2 - group1. So the meandiff is actually B - A, not like MATLAB
tukey_df = pd.DataFrame(
    tukey.summary().data[1:],  # skip header row
    columns=tukey.summary().data[0]
)

tukey_csv_path = os.path.join(savedir, "tukey_tsnr_by_subject_afterrealign.csv")
tukey_df.to_csv(tukey_csv_path, index=False)
print(f"Tukey HSD results saved to {tukey_csv_path}")