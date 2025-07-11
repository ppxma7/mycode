import numpy as np
import matplotlib.pyplot as plt
import os
import glob
import re

# Main CANAPI directory
main_dir = "/Volumes/DRS-TOUCHMAP/ma_ares_backup/CANAPI/"
savedir = "/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/grouplevel_results/"


# Main CANAPI directory
subject_folders = sorted([f for f in os.listdir(main_dir) if f.startswith("canapi_sub")])

# Store per-timepoint data for each of the 6 motion parameters
all_data = []

scan_boundaries = []  # To track where each scan starts
scan_labels = []      # To track scan names like '1barR'


# Loop over subjects
for subj in subject_folders:
    subj_dir = os.path.join(main_dir, subj, "spm_analysis")
    if not os.path.exists(subj_dir):
        print(f"Missing: {subj_dir}")
        continue

    motion_files = sorted(glob.glob(os.path.join(subj_dir, "rp_*.txt")))
    if not motion_files:
        print(f"No rp_*.txt found for {subj}")
        continue

    subj_motion = []
    scan_starts = []
    total_len = 0

    for f in motion_files:
        try:
            mp = np.loadtxt(f)
            subj_motion.append(mp)

            # Extract scan label
            fname = os.path.basename(f)
            match = re.search(r"_WIP?(1bar|low)_TAP_(R|L)", fname)
            if match:
                label = match.group(1) + match.group(2)  # e.g., '1barR'
                scan_labels.append(label)
                scan_starts.append(total_len)
            else:
                scan_labels.append("Unknown")
                scan_starts.append(total_len)

            total_len += mp.shape[0]
        except Exception as e:
            print(f"Error reading {f}: {e}")
            continue

    if subj_motion:
        subj_motion = np.vstack(subj_motion)
        all_data.append(subj_motion)

        if not scan_boundaries:  # Save boundaries only once (all subjects same layout)
            scan_boundaries = scan_starts

# Truncate all to shortest time length
min_len = min([d.shape[0] for d in all_data])
all_data_trimmed = np.array([d[:min_len, :] for d in all_data])  # [n_subjects, min_len, 6]

# Compute mean and std
mean_motion = np.mean(all_data_trimmed, axis=0)  # [min_len, 6]
std_motion = np.std(all_data_trimmed, axis=0)

# Plot
fig, axes = plt.subplots(2, 1, figsize=(12, 8), sharex=True)

# Colors and labels
colors = ['#7570b3', '#d95f02', '#1b9e77']
labels_trans = ['X Translation', 'Y Translation', 'Z Translation']
labels_rot = ['X Rotation', 'Y Rotation', 'Z Rotation']

# Plot Translations (0:3)
for i in range(3):
    axes[0].plot(mean_motion[:, i], label=labels_trans[i], color=colors[i])
    axes[0].fill_between(range(min_len),
                         mean_motion[:, i] - std_motion[:, i],
                         mean_motion[:, i] + std_motion[:, i],
                         color=colors[i], alpha=0.2)

axes[0].set_ylabel('Translation (mm)')
axes[0].set_title('Mean ± SD Translation Across Subjects')
axes[0].legend()
axes[0].grid(True)

for ax in axes:
    for i, x in enumerate(scan_boundaries):
        ax.axvline(x=x, color='gray', linestyle='--', linewidth=0.5)
        ax.text(x + 5, ax.get_ylim()[1]*0.95, scan_labels[i],
                rotation=0, ha='left', va='top', fontsize=8, color='gray')


# Plot Rotations (3:6)
for i in range(3):
    axes[1].plot(mean_motion[:, i+3], label=labels_rot[i], color=colors[i])
    axes[1].fill_between(range(min_len),
                         mean_motion[:, i+3] - std_motion[:, i+3],
                         mean_motion[:, i+3] + std_motion[:, i+3],
                         color=colors[i], alpha=0.2)

axes[1].set_ylabel('Rotation (radians)')
axes[1].set_xlabel('Volume')
axes[1].set_title('Mean ± SD Rotation Across Subjects')
axes[1].legend()
axes[1].grid(True)

for ax in axes:
    for i, x in enumerate(scan_boundaries):
        ax.axvline(x=x, color='gray', linestyle='--', linewidth=0.5)
        ax.text(x + 5, ax.get_ylim()[1]*0.95, scan_labels[i],
                rotation=0, ha='left', va='top', fontsize=8, color='gray')


# Save or show
output_path = os.path.join(savedir, "CANAPI_all_subjects_motion_summary.png")
plt.savefig(output_path, dpi=300)
plt.close()
#plt.show()
